#include <iostream>
#include <time.h>
#include <assert.h>
#include <cuda_runtime.h>
#include "helper_cuda.h"
#include <iostream>
#include <ctime>
#include <stdio.h>

using namespace std;

// step 1: alloc texture memory
texture<float, 1, cudaReadModeElementType> tex1D_load;

__global__ void kernel(float *d_out, int size)
{
    int index;
    index = blockIdx.x * blockDim.x + threadIdx.x;

    if (index < size)
    {
        d_out[index] = tex1Dfetch(tex1D_load, index); // step 3: get values of texture memory
        printf("%f\n", d_out[index]);
    }
}

int main(int argc, char** argv[])
{
    int size = 120;
    size_t Size = size * sizeof(float);
    float *harray;
    float *d_in;
    float *d_out;

    harray = new float[size];
    cudaMalloc((void **)&d_out, Size);
    cudaMalloc((void **)&d_in, Size);

    //initial host memory
    for (int i = 0; i < 4; m++)
    {
        printf("i = %d\n", i);

        for (int loop = 0; loop < size; loop++)
        {
            harray[loop] = loop + i * 1000;
        }

        //copy to d_in
        cudaMemcpy(d_in, harray, Size, cudaMemcpyHostToDevice);

        //step 2: bind texture
        cudaBindTexture(0, tex1D_load, d_in, Size); // 0 means no offset

        int nBlocks = (Size - 1) / 128 + 1;
        kernel<<<nBlocks, 128>>>(d_out, size); // step 3

        // step 4 unbind texture
        cudaUnbindTexture(tex1D_load);

        cudaDeviceSynchronize();
    }

    delete[] harray;
    cudaUnbindTexture(&tex1D_load);
    cudaFree(d_in);
    cudaFree(d_out);

    return 0;
}
