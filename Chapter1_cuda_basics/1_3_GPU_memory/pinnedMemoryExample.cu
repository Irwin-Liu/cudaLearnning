int main(int argc, char** argv[])
{
  const int n = 64;
  size_t size = n * sizeof(int);

  int *data1, *data2, *data3, *data4;
  int *d_data4;

  // alloc pinned memory
  cudaHostAlloc((void **)&data1, size, cudaHostAllocDefault);

  // alloc portable memory
  cudaHostAlloc((void **)&data2, size, cudaHostAllocPortable);

  // alloc write-combined memory
  cudaHostAlloc((void **)&data3, size, cudaHostAllocWriteCombined);

  // alloc mapped memory
  cudaDeviceProp prop;
  int flag, device_id = 0;
  cudaGetDeviceProperties(prop, device_id);
  if (prop.canMapHostMemory) {
    cudaHostAlloc((void **)&data4, size, cudaHostAllocMapped);
    cudaHostGetDevicePointer(&d_data4, data4, flag);
  }
  
  // free
  cudaFreeHost(data1);
  cudaFreeHost(data2);
  cudaFreeHost(data3);
  if (prop.canMapHostMemory) {
    cudaFreeHost(data4);
    cudaFree(d_data4);
  }

  return 0;
}
