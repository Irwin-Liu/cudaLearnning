__device__ int count = 0;
 
__global__ static void sum(int* data_gpu, int* block_gpu, int *sum_gpu, int length)
{
  extern __shared__ int blocksum[];
  __shared__ int islast;
  int offset;
 
  const int tid  = threadIdx.x;
  const int bid  = blockIdx.x;
  const int tnum = blockDim.x;
  const int bnum = gridDim.x;
  blocksum[tid]  = 0;

  for (int i = bid * tnum + tid; i < length; i += bnum * tnum) {
    blocksum[tid] += data_gpu[i];
  } 
 
  __syncthreads();

  offset = tnum / 2;
  while (offset > 0) {
    if(tid < offset) {
      blocksum[tid] += blocksum[tid + offset];
    }
    offset >>= 1;
    __syncthreads();
  }
 
  if (tid == 0) {
    block_gpu[bid] = blocksum[0];
    __threadfence();
 
    int value = atomicAdd(&count, 1);
    islast = (value == gridDim.x - 1);
  }
 
  __syncthreads();
 
  if (islast) {
    if (tid == 0) {
      int s = 0;
      for (int i = 0; i < bnum; i++) {
        s += block_gpu[i];
      }
      *sum_gpu = s;
    }
  }
}
