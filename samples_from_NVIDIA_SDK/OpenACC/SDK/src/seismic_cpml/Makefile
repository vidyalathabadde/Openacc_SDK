# SPDX-FileCopyrightText: Copyright (c) 2017 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: LicenseRef-NvidiaProprietary
#
# NVIDIA CORPORATION, its affiliates and licensors retain all intellectual
# property and proprietary rights in and to this material, related
# documentation and any modifications thereto. Any use, reproduction,
# disclosure or distribution of this material and related documentation
# without an express license agreement from NVIDIA CORPORATION or
# its affiliates is strictly prohibited.

CC = nvc
FC = nvfortran
OBJ = o
EXE = out
UNAME := $(shell uname -a)
ifeq ($(findstring CYGWIN_NT, $(UNAME)), CYGWIN_NT)
   OBJ=obj
   EXE=exe
endif

FCFLAGS ?= -fast -acc -Minfo=acc

all: build run verify

build: seismic_PML_Collino_3D_isotropic.F90
	$(FC) $(FCFLAGS) -o seismic_cmpl.$(EXE) seismic_PML_Collino_3D_isotropic.F90

run: seismic_cmpl.$(EXE)
	$(RUN) ./seismic_cmpl.$(EXE) 32 32 32 2 150 100 >seismic_out.log  2>seismic_out.err

verify: check.F
	@nvfortran -o check.$(EXE) check.F
	./check.$(EXE)

clean:
	@echo 'Cleaning up...'
	@rm -rf *.$(EXE) *.$(OBJ) *.oo *.mod *.dwf *.pdb prof *.pnm *.dat timestamp* plot* seismic_out.*
