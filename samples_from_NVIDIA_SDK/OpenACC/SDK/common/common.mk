# SPDX-FileCopyrightText: Copyright (c) 2017 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: LicenseRef-NvidiaProprietary
#
# NVIDIA CORPORATION, its affiliates and licensors retain all intellectual
# property and proprietary rights in and to this material, related
# documentation and any modifications thereto. Any use, reproduction,
# disclosure or distribution of this material and related documentation
# without an express license agreement from NVIDIA CORPORATION or
# its affiliates is strictly prohibited.

UNAME := $(shell uname -a)
ifeq ($(findstring CYGWIN_NT, $(UNAME)), CYGWIN_NT)
	OBJ = obj
	EXESUFFIX = .exe
else
	OBJ = o
	EXESUFFIX = .out
endif

.SUFFIXES : .cu .c .cpp

OSARCH = $(shell uname -m)

# Basic directory setup for SDK
# (override directories only if they are not already defined)
SRCDIR     ?= ./
ROOTDIR    ?= ..
ROOTBINDIR ?= $(ROOTDIR)/../bin
BINDIR     ?= $(ROOTBINDIR)
ROOTOBJDIR ?= obj
LIBDIR     := $(ROOTDIR)/../lib
COMMONDIR  := $(ROOTDIR)/../common
INCDIR     := $(ROOTDIR)/../include

# Compilers
CC         = nvc
CXX        = nvc++
LINK       := $(CXX)

# Includes
INCLUDES   += -I. -I$(INCDIR)

# architecture flag for compilers build
LIB_ARCH   := $(OSARCH)

# Debug/release configuration
ifeq ($(dbg),1)
	COMMONFLAGS += -g
	BINSUBDIR   := debug
	LIBSUFFIX   :=
else
	COMMONFLAGS += -acc -Minfo=accel
	BINSUBDIR   := release
LIBSUFFIX   :=
endif

################################################################################
# Check for input flags and set compiler flags appropriately
################################################################################
ifeq ($(fastmath), 1)
	COMMONFLAGS +=
endif

ifeq ($(verbose), 1)
	COMMONFLAGS += -v
endif

# Libs
LIB       := -L$(LIBDIR)

CCFLAGS   ?= $(COMMONFLAGS)
CXXFLAGS  ?= $(COMMONFLAGS)
PGCUFLAGS ?= $(CXXFLAGS)

ifeq ($(USECUFFT),1)
    LIB += -cudalib=cufft
endif

ifeq ($(USECUBLAS),1)
  LIB += -cudalib=cublas -llapack -lblas -fortranlibs
endif

# Lib/exe configuration
ifneq ($(STATIC_LIB),)
TARGETDIR := $(LIBDIR)
ifeq ($(findstring CYGWIN_NT, $(UNAME)), CYGWIN_NT)
TARGET    := $(subst .lib,_$(LIB_ARCH)$(LIBSUFFIX).lib,$(LIBDIR)/$(STATIC_LIB))
else
TARGET    := $(subst .a,_$(LIB_ARCH)$(LIBSUFFIX).a,$(LIBDIR)/$(STATIC_LIB))
endif
LINKLINE  = ar rucv $(TARGET) $(OBJS)
else
ifneq ($(OMIT_CUTIL_LIB),1)
LIB += -lcommon_$(LIB_ARCH)$(LIBSUFFIX)
endif
# Device emulation configuration
TARGETDIR := $(BINDIR)/$(BINSUBDIR)
TARGET    := $(TARGETDIR)/$(EXECUTABLE)
LINKLINE  = $(LINK) $(CXXFLAGS) $(EXTRAFLAGS) $(EXTRALDFLAGS) $(CUDAFLAGS) -o $(TARGET) $(OBJS) $(LIB)
endif

# check if verbose
ifeq ($(verbose), 1)
	VERBOSE :=
else
	VERBOSE :=
endif

################################################################################
# Set up source fiels
################################################################################
CFILES = $(filter %.c, $(SRCFILES))
CPPFILES = $(filter %.cpp, $(SRCFILES))
CUDAFILES = $(filter %.cu, $(SRCFILES))

################################################################################
# Set up object files
################################################################################

OBJDIR := $(ROOTOBJDIR)/$(LIB_ARCH)/$(BINSUBDIR)
OBJS +=  $(patsubst %.cpp,$(OBJDIR)/%.cpp.$(OBJ),$(notdir $(CPPFILES)))
OBJS +=  $(patsubst %.c,$(OBJDIR)/%.c.$(OBJ),$(notdir $(CFILES)))
OBJS +=  $(patsubst %.cu,$(OBJDIR)/%.cu.$(OBJ),$(notdir $(CUDAFILES)))

################################################################################
# Rules
################################################################################

ifeq ($(HOME_QA),)
ifneq ($(EXECUTABLE),)
default: all

all: run
endif
endif

$(OBJDIR)/%.c.$(OBJ) : $(SRCDIR)%.c $(C_DEPS)
	$(VERBOSE) $(CC) $(INCLUDES) $(CCFLAGS) $(EXTRAFLAGS) $(CUDAFLAGS) -o $@ -c $<

$(OBJDIR)/%.cpp.$(OBJ) : $(SRCDIR)%.cpp $(C_DEPS)
	$(VERBOSE) $(CXX) $(INCLUDES) $(CXXFLAGS) $(EXTRAFLAGS) $(CUDAFLAGS) -o $@ -c $<

# Default arch includes gencode for sm_10, sm_20, and other archs from GENCODE_ARCH declared in the makefile
$(OBJDIR)/%.cu.$(OBJ) : $(SRCDIR)%.cu $(CU_DEPS)
	$(VERBOSE) $(CXX) $(PGCUFLAGS) -o $@ -c $<

$(TARGET): makedirectories $(OBJS) Makefile
	$(VERBOSE) $(LINKLINE)

run: $(TARGET)
	$(RUN) ./$(TARGETDIR)/$(EXECUTABLE)

makedirectories:
	$(VERBOSE) mkdir -p $(LIBDIR)
	$(VERBOSE) mkdir -p $(OBJDIR)
	$(VERBOSE) mkdir -p $(TARGETDIR)

tidy:
	$(VERBOSE) find . | egrep "#" | xargs rm -f
	$(VERBOSE) find . | egrep "\~" | xargs rm -f

clean: tidy
	$(VERBOSE) rm -f $(OBJS)
	$(VERBOSE) rm -f $(TARGET)
	$(VERBOSE) rm -f $(ROOTBINDIR)/$(BINSUBDIR)/*.ppm
	$(VERBOSE) rm -f $(ROOTBINDIR)/$(BINSUBDIR)/*.pgm
	$(VERBOSE) rm -f $(ROOTBINDIR)/$(BINSUBDIR)/*.bin
	$(VERBOSE) rm -f $(ROOTBINDIR)/$(BINSUBDIR)/*.bmp
	$(VERBOSE) rm -f $(ROOTBINDIR)/$(BINSUBDIR)/*.pdb
	$(VERBOSE) rm -f $(ROOTBINDIR)/$(BINSUBDIR)/*.dwf

clobber : clean
	$(VERBOSE) rm -rf $(ROOTOBJDIR)
