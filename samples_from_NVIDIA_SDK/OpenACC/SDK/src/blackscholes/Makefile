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

CCFLAGS ?= -fast
FCFLAGS ?= -fast
ACCFLAGS = -I../../include -Minline=levels:2 -acc -Minfo=acc 
ACCFLAGS2 = -I../../include -acc -Minfo=acc
OMPFLAGS = -I../../include -fast -Minline -mp -Minfo=par

all: build run verify

build: blackscholes.c blackscholes.F90 blackscholes_routine.c
	$(CC) $(CCFLAGS) $(ACCFLAGS) -o blackscholesc_acc.$(EXE) blackscholes.c
	$(CC) $(OMPFLAGS) -o blackscholesc_omp.$(EXE) blackscholes.c
	$(FC) $(FCFLAGS) $(ACCFLAGS) -o blackscholesf_acc.$(EXE) blackscholes.F90
	$(FC) $(OMPFLAGS) -o blackscholesf_omp.$(EXE) blackscholes.F90
	$(CC) $(CCFLAGS) $(ACCFLAGS2) -o blackscholesc_acc_routine.$(EXE) blackscholes_routine.c

run: blackscholesc_acc.$(EXE) blackscholesc_omp.$(EXE) blackscholesf_acc.$(EXE) blackscholesf_omp.$(EXE) blackscholesc_acc_routine.$(EXE)
	@echo "------------------------- blackscholesc_acc.$(EXE) -----------------------"
	$(RUN) ./blackscholesc_acc.$(EXE)
	@echo "------------------------- blackscholesc_omp.$(EXE) -----------------------"
	$(RUN) ./blackscholesc_omp.$(EXE)
	@echo "------------------------- blackscholesf_acc.$(EXE) -----------------------"
	$(RUN) ./blackscholesf_acc.$(EXE)
	@echo "------------------------- blackscholesf_omp.$(EXE) -----------------------"
	$(RUN) ./blackscholesf_omp.$(EXE)
	@echo "------------------------- blackscholesc_acc_routine.$(EXE) ---------------"
	$(RUN) ./blackscholesc_acc_routine.$(EXE)

verify:

clean:
	@echo 'Cleaning up...'
	@rm -rf *.$(EXE) *.$(OBJ) *.oo *.mod *.dwf *.pdb prof
