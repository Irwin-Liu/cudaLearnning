#include <iostream>
#include <random>
#include "cuda_runtime_api.h"

double *InitializeArray(const int length, const int seed) {
    double *A = (double*)malloc(length * sizeof(double));

    std::default_random_engine e;
    std::uniform_real_distribution<double> rand(0, 10);
    e.seed(seed);

    for (int i = 0; i < length; ++i) {
        A[i] = rand(e);
    }

    return A;
}

void PrintArray(double *A, const int length, std::string str) {
    std::cout <<"Array " << str << ":";

    for (int i = 0; i < length; ++i) {
        std::cout << " " << A[i];
    }

    std::cout << std::endl;
}

double *ArraySum(double *A, double *B, const int length) {
    double *C = (double*)malloc(length * sizeof(double));

    for (int i = 0; i < length; ++i) {
        C[i] = A[i] + B[i];
    }

    return C;
}

__global__ void ArraySumKernel(double *A, double *B, double *C) {
    int i = threadIdx.x;

    C[i] = A[i] + B[i];
}

int main() {
    const int length = 10;
    const size_t size = length * sizeof(double);

    double *h_A, *h_B, *h_C;
    h_A = (double*)malloc(size);
    h_B = (double*)malloc(size);
    h_C = (double*)malloc(size);

    h_A = InitializeArray(length, 0);
    h_B = InitializeArray(length, 10);

    PrintArray(h_A, length, "A");
    PrintArray(h_B, length, "B");

    std::cout << "CPU Array Sum Result:\n";
    PrintArray(ArraySum(h_A, h_B, length), length, "C");

    std::cout << "GPU Array Sum Result:\n";
    const int dev = 0;
    cudaSetDevice(dev);

    double *d_A, *d_B, *d_C;
    cudaMalloc((void **)&d_A, size);
    cudaMalloc((void **)&d_B, size);
    cudaMalloc((void **)&d_C, size);

    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

    ArraySumKernel<<<1, length>>>(d_A, d_B, d_C);

    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);

    PrintArray(h_C, length, "C");

    free(h_A);
    free(h_B);
    free(h_C);

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    return 0;
}