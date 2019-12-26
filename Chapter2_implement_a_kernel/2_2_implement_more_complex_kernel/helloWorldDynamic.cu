#include <cstdio>
#include <cuda_runtime_api.h>

__global__ void HelloWorldDynamicKernel(const int block_size, int depth)
{
    int tid = threadIdx.x;
    printf("Recursion=%d: Hello World from thread %d block %d\n", depth, tid,
           blockIdx.x);

    // condition to stop recursive execution
    if (block_size == 1)
                return;

    // reduce block size to half
    int next_block_size = block_size >> 1;

    // thread 0 launches child grid recursively
    if((tid == 0) && (next_block_size > 0))
    {
        HelloWorldDynamicKernel<<<1, next_block_size>>>(next_block_size, ++depth);
        //cudaDeviceSynchronize();
        printf("-------> execution depth: %d\n", depth);
    }
}

int main(int argc, char **argv) {
    const int block_size = 8;
    const int grid_size  = 1;

    std::printf("Excuting GPU:\n");

    HelloWorldDynamicKernel<<<grid_size, block_size>>>(block_size, 0);

    cudaDeviceSynchronize();

    return  0;
}

