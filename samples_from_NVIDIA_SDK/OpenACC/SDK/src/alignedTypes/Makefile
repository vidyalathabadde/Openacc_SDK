# SPDX-FileCopyrightText: Copyright (c) 2017 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: LicenseRef-NvidiaProprietary
#
# NVIDIA CORPORATION, its affiliates and licensors retain all intellectual
# property and proprietary rights in and to this material, related
# documentation and any modifications thereto. Any use, reproduction,
# disclosure or distribution of this material and related documentation
# without an express license agreement from NVIDIA CORPORATION or
# its affiliates is strictly prohibited.

EXECUTABLE = alignedTypes$(EXESUFFIX)
SRCFILES = alignedTypes.cpp
ifneq (,$(findstring -ta,$(OPT)))
    EXTRALDFLAGS = -Mcuda
else
    EXTRALDFLAGS = -cuda
endif

include ../../common/common.mk
