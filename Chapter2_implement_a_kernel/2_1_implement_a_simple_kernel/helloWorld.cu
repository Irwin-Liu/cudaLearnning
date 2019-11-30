#include <cstdio>

__global__ void helloWorldKernel() {
    printf("Hello World from GPU\n");
}

__global__ void helloWorldwithThreadKernel() {
    printf("Hello World from GPU block: %d thread: %d\n", blockIdx.x, threadIdx.x);
}

int main() {
    std::printf("Hello World from CPU\n");
    std::printf("--------------------------------\n");

    helloWorldKernel<<<1, 10>>>();
    cudaDeviceSynchronize();
    std::printf("--------------------------------\n");

    helloWorldwithThreadKernel<<<4, 2>>>();
    cudaDeviceSynchronize();
    std::printf("--------------------------------\n");


    return 0;
}
