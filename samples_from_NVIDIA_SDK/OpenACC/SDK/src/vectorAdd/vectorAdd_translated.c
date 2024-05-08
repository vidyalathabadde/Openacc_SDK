/*
 *     Copyright (c) 2017, NVIDIA CORPORATION.  All rights reserved.
 *
 * NVIDIA CORPORATION and its licensors retain all intellectual property
 * and proprietary rights in and to this software, related documentation
 * and any modifications thereto.  Any use, reproduction, disclosure or
 * distribution of this software and related documentation without an express
 * license agreement from NVIDIA CORPORATION is strictly prohibited.
 */

/*
 * Vector addition: C = A + B
 *
 * This sample is a very basic sample that implements element by element
 * vector addition.
 *
 * Perform vector addition on a float array using openacc.
 * Usage:
 *     "--n=<N>": Specify the number of elements to reduce (default 50000)
 *     "--thresh=<N>": The threshold used to check answer, default 1e-5.
 */
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <math.h>
#include <float.h>
#include <omp.h>
#define ABS(A) ((A) > 0 ? (A) : -(A))
//#include "cuda2acc.h"

// CPU vector addition
void vectorAddCPU(float *A, float *B, float * C, uint32_t N)
{
    for (int i = 0; i < N; i++) {
        C[i] = A[i] + B[i];
    }
}

// vector addition using openacc
void vectorAddGPU(float *A, float *B, float * C, uint32_t N)
{
    #pragma acc enter data copyin(A[0:N],B[0:N])
#pragma omp target enter data map(to:A[0:N],B[0:N])
    printf("Copy input data from the host memory to the device\n");
    #pragma acc enter data create(C[0:N])
#pragma omp target enter data map(alloc:C[0:N])
    printf("CUDA kernel launch\n");
    #pragma acc kernels loop present(A[0:N],B[0:N],C[0:N]) independent
#pragma omp target teams loop order(concurrent) map(present,alloc:A[0:N],B[0:N],\
            C[0:N])
    for (int i = 0; i < N; i++) {
        C[i] = A[i] + B[i];
    }
    printf("Copy output data from the  device to the host memory\n");
    #pragma acc exit data copyout(C[0:N])
#pragma omp target exit data map(from:C[0:N])
    #pragma acc exit data delete(A[0:N],B[0:N])
#pragma omp target exit data map(delete:A[0:N],B[0:N])
}
void finit_rand(float *vec, uint32_t len)
{
    uint32_t i;
    for (i = 0; i < len; i++)
        vec[i] = rand() / (float)RAND_MAX;
}
int32_t fcheck(float *A, float *B, uint32_t N, float th)
{
    int i;
    for (i = 0; i < N; i++) {
        if (ABS(A[i] - B[i]) > th) {
            printf("Test %d out of %d FAILED, %f %f\n", i, N, A[i], B[i]);
            return 1;
        }
    }
    return 0;
}



// run test
void runtest(uint32_t N, float th)
{
    float *A, *B, *C, *D;

    // Allocate the host vectors
    A = (float *)malloc(sizeof(float) * N);
    B = (float *)malloc(sizeof(float) * N);
    C = (float *)malloc(sizeof(float) * N);
    D = (float *)malloc(sizeof(float) * N);
    finit_rand(A, N);
    finit_rand(B, N);
    vectorAddCPU(A, B, C, N);
    vectorAddGPU(A, B, D, N);

    printf("%s\n", (fcheck(C, D, N, th) ? "Test failed!" : "Test passed"));

    // Free host memory
    free(D);
    free(A);
    free(B);
    free(C);
}

// main function: process arguments and call runtest()
int main(int argc, char **argv)
{
    unsigned int n = 50000;
    float th = 1e-5;

/*    const char *names[] = { "n", "thresh" };
    int flags[] = { 1, 1 };
    int map[] = { 0, 1 };
    struct OptionTable *opttable = make_opttable(2, names, flags, map);
    argproc(argc, argv, opttable);

    const char *str_n = opttable->table[0].val, *str_th = opttable->table[1].val;
    if (str_n)
        n = atoi(str_n);
    if (str_th)
        th = atof(str_th);*/

    // Print the vector length to be used.
    printf("[Vector addition of %d elements]\n", n);
    //print_gpuinfo(argc, (const char **)argv);
    runtest(n, th);

//    free_opttable(opttable);
    printf("Done\n");
    return 0;
}

// Code was translated using: /nfs/site/home/vbaddex/vidya/openacc/intel-application-migration-tool-for-openacc-to-openmp/src/intel-application-migration-tool-for-openacc-to-openmp vectorAdd.c
