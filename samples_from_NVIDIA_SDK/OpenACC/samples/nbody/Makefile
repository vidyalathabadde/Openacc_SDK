# SPDX-FileCopyrightText: Copyright (c) 2017 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: LicenseRef-NvidiaProprietary
#
# NVIDIA CORPORATION, its affiliates and licensors retain all intellectual
# property and proprietary rights in and to this material, related
# documentation and any modifications thereto. Any use, reproduction,
# disclosure or distribution of this material and related documentation
# without an express license agreement from NVIDIA CORPORATION or
# its affiliates is strictly prohibited.

PREC ?= FP64
CC = nvc
OBJ = o
EXE	= out
UNAME := $(shell uname -a)
ifeq ($(findstring CYGWIN_NT, $(UNAME)), CYGWIN_NT)
OBJ = obj
EXE	= exe
endif

CCFLAGS ?= -fast -Minline -Minfo -acc

all: build run verify

build: nbodyacc.c check.c
	$(CC) -c $(CCFLAGS) check.c
	$(CC) $(CCFLAGS) -D$(PREC) -o nbody.$(EXE) nbodyacc.c check.$(OBJ)

run: nbody.$(EXE)
	$(RUN) ./nbody.$(EXE)

verify:

clean:
	@echo 'Cleaning up...'
	@rm -rf *.$(EXE) *.$(OBJ) *.dwf *.pdb prof
