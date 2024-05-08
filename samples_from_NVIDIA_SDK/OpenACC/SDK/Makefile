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
SOURCES = \
        alignedTypes \
        bilateralFilter \
        blackscholes \
        FDTD3d \
        histogram \
        seismic_cpml \
        simpleTemplates \
        scalarProd \
        template \
        transpose \
        transposeNew \
        vectorAdd \
        asyncAPI \
        bandwidthTest \
        cppIntegration \
        deviceQuery \
        matrixMul \
        MonteCarloMultiGPU \
        quasirandomGenerator \
        reduction \
        simpleMultiGPU
else
SOURCES = \
	alignedTypes \
	bilateralFilter \
	blackscholes \
	FDTD3d \
	histogram \
	seismic_cpml \
	simpleTemplates \
	scalarProd \
	template \
	transpose \
	transposeNew \
	vectorAdd \
	asyncAPI \
	bandwidthTest \
	cppIntegration \
	deviceQuery \
	matrixMul \
	MonteCarloMultiGPU \
	quasirandomGenerator \
	reduction \
	simpleCUBLAS \
	simpleMultiGPU
endif

STATIC_LIB := libcommon.a

all: src

lib:
	@echo Building common ...
	$(MAKE) -C common

$(SOURCES):
	$(MAKE) -C src/$@

src: lib
	@for i in $(SOURCES); do \
		$(MAKE) -C src/$${i} ; \
	done

clean_lib:
	$(MAKE) -C common clean

clean_src:
	@for i in $(SOURCES); do \
		$(MAKE) -C src/$${i} clean; \
	done

clean: clean_src clean_lib

.PHONY: clean clean_src clean_lib lib src all
