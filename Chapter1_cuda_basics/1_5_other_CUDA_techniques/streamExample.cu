int main(int argc, char** argv)
{
  // create 2 streams
  cudaStream_t stream[2];
  // initialize cuda stream
  for (int i = 0; i < 2; i++) {
    cudaStreamCreate(&stream[i]);
  }

  // alloc pinned memory and device memory;
  float *hostPtr, *d_in, *d_out;
  size_t size = 512 * sizeof(float);
  cudaMallocHost((void **)hostPtr, 2 * size);
  cudaMalloc((void **)d_in,  2 * size);
  cudaMalloc((void **)d_out, 2 * size);

  // copy data from host to device in 2 streams
  for (int i = 0; i < 2; i++) {
    cudaMemcpyAsync(d_in + i * size, hostPtr + i * size, size, cudaMemcpyHostToDevce, stream[i]);
  }

  // run testkernel in 2 streams
  for (int i = 0; i < 2; i++) {
    testkernel<<<1, 512, 0, stream[i]>>>(d_in + i * size, d_out + i * size, size);
  }

  // copy data from device to host in 2 streams
  for (int i = 0; i < 2; i++) {
    cudaMemcpyAsync(hostPtr + i * size, d_out + i * ptr, size, cudaMemcpyDevceToHost, stream[i]);
  }

  cudaThreadSynchronize();

  // release cuda stream
  for (int i = 0; i < 2; i++) {
    cudaStreamDestroy(stream[i]);
  }
  cudaFree(hostPtr);

  return 0;
}
