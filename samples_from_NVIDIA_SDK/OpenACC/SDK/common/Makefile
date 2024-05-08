# SPDX-FileCopyrightText: Copyright (c) 2017 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: LicenseRef-NvidiaProprietary
#
# NVIDIA CORPORATION, its affiliates and licensors retain all intellectual
# property and proprietary rights in and to this material, related
# documentation and any modifications thereto. Any use, reproduction,
# disclosure or distribution of this material and related documentation
# without an express license agreement from NVIDIA CORPORATION or
# its affiliates is strictly prohibited.

# SOURCE FILES
UNAME := $(shell uname -a)
ifeq ($(findstring CYGWIN_NT, $(UNAME)), CYGWIN_NT)
STATIC_LIB := libcommon.lib
else
STATIC_LIB := libcommon.a
endif

SRCFILES = common.c argproc.c device_helper.cpp
ifneq (,$(findstring -ta,$(OPT)))
	CUDAFLAGS = -Mcuda
else
	CUDAFLAGS = -cuda
endif
ROOTDIR := .

include common.mk
