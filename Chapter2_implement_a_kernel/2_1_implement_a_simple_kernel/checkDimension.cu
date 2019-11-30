#include <cstdio>

__global__ void checkIndexKernel() {
    int threadID = threadIdx.x + threadIdx.y * blockDim.x + threadIdx.z * blockDim.x * blockDim.y;
    int blockID = blockIdx.x + blockIdx.y * gridDim.x + blockIdx.z * gridDim.x * gridDim.y;
    int threadIDinGird = threadID + blockID * blockDim.x * blockDim.y * blockDim.z;

    printf("thread id in grid: %2d; thread id in block: %2d (%d, %d, %d) in blockDim (%d, %d, %d); block id: %d (%d, %d, %d) in gridDim (%d, %d, %d)\n",
           threadIDinGird,
           threadID, threadIdx.x, threadIdx.y, threadIdx.z, blockDim.x, blockDim.y, blockDim.z,
           blockID, blockIdx.x, blockIdx.y, blockIdx.z, gridDim.x, gridDim.y, gridDim.z);
}

int main() {
    dim3 block_size(3, 2, 2);
    dim3 grid_size(2);

    checkIndexKernel<<<grid_size, block_size>>>();
    cudaDeviceSynchronize();

    return 0;
}