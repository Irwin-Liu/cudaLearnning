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

__host__ __device__ double MaxElement(double a, double b, double c) {
    if ((a >= b) && (a >= c)) {
        return a;
    }
    if (b >= c) {
        return b;
    }
    return c;
}

double *MaxElements(double *A, double *B, double *C, const int length) {
    double *D = (double*)malloc(length * sizeof(double));

    for (int i = 0; i < length; ++i) {
        D[i] = MaxElement(A[i], B[i], C[i]);
    }

    return D;
}

__global__ void MaxElementsKernel(double *A, double *B, double *C, double *D) {
    int i = threadIdx.x;

    D[i] = MaxElement(A[i], B[i], C[i]);
}

int main() {
    const int length = 10;
    const size_t size = length * sizeof(double);

    double *h_A, *h_B, *h_C, *h_D;
    h_A = (double*)malloc(size);
    h_B = (double*)malloc(size);
    h_C = (double*)malloc(size);
    h_D = (double*)malloc(size);

    h_A = InitializeArray(length, 0);
    h_B = InitializeArray(length, 5);
    h_C = InitializeArray(length, 10);

    PrintArray(h_A, length, "A");
    PrintArray(h_B, length, "B");
    PrintArray(h_C, length, "C");

    std::cout << "CPU Result:\n";
    PrintArray(MaxElements(h_A, h_B, h_C, length), length, "D");

    std::cout << "GPU Result:\n";
    const int dev = 0;
    cudaSetDevice(dev);

    double *d_A, *d_B, *d_C, *d_D;
    cudaMalloc((void **)&d_A, size);
    cudaMalloc((void **)&d_B, size);
    cudaMalloc((void **)&d_C, size);
    cudaMalloc((void **)&d_D, size);

    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_C, h_C, size, cudaMemcpyHostToDevice);

    MaxElementsKernel<<<1, length>>>(d_A, d_B, d_C, d_D);

    cudaMemcpy(h_D, d_D, size, cudaMemcpyDeviceToHost);

    PrintArray(h_D, length, "D");

    free(h_A);
    free(h_B);
    free(h_C);
    free(h_D);

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
    cudaFree(d_D);

    return 0;
}

