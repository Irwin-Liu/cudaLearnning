__global__ void myKernel1(int* result)
{
    int tid = threadIdx.x;
    int ref1 = myArray[tid] * 1;

    myArray[tid + 1] = 2;

    int ref2 = myArray[tid] * 1;
    result[tid] = ref1 * ref2;
}

__global__ void myKernel2(int* result)
{
    __shared__ volatile float myArray[512];

    int tid = threadIdx.x;
    int ref1 = myArray[tid] * 1;

    myArray[tid + 1] = 2;

    __syncthreads();

    int ref2 = myArray[tid] * 1;
    result[tid] = ref1 * ref2;
}
