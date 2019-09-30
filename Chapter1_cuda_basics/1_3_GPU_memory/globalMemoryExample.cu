__global__ void globalMemoryDemo1(float* A)
{
  int i = threadIDx.x;
  A[i] *= 2.0f;
}
 
__global__ void globalMemoryDemo2(float* B, int pitch, int width, int height)
{
  for (int r = 0; r < height; r++) {
    float* row = (float*)((char*)B + r * pitch);
    for (int c = 0; c < width; c++) {
      float tmp = row[c];
    }
  }
}
 
__global__ void globalMemoryDemo3(cudaPitchedPtr pitched_D, cudaExtent extent)
{
  char* D = pitched_D.ptr;
  size_t pitch = pitched_D.pitch;
  size_t slice_pitch = pitch * extent.height;
  for (int k = 0; k < extent.depth; k++) {
    char* slice = D + k * slice_pitch;
    for (int j = 0; j < extent.height; j++) {
      float* row = (float*)(slice + y * pitch);
      for (int i = 0; i < extent.width; i++) {
        float tmp = row[i];
      }
    }
  }
}
 
int main(int argc, char** argv)
{
  // 1D array
  const int N = 256;
  size_t size = N * sizeof(float);
  float *h_A, *d_A;
 
  h_A = (float *)malloc(size); // alloc on host memory
  for (int i = 0; i < N; i++) {
    h_A[i] = i;
  }
 
  cudaMalloc((void **)&d_A, size); // alloc on GPU global memory
 
  cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice); // copy data from host to device
  globalMemoryDemo1<<<1, N>>>(d_A); // start kernel, change elements in d_A
  cudaMemcpy(h_A, d_A, size, cudaMemcpyDeviceToHost); // copy data from device back to host
 
  cudaFree(d_A); //release global memory
  free(h_A);
 
  // 2D array
  int pitch, width = 32, height = 16;
  float *d_B, *d_C;
 
  cudaMallocPitch((void **)&d_B, &pitch, width * sizeof(float), height); // alloc on GPU global memory
  globalMemoryDemo2<<<1, 1>>>(d_B, pitch, width, height); // start kernel, traverse elements of d_B
  cudaMemcpy2DToArray(d_C, 0, 0, d_B, pitch, width * sizeof(float), height, cudaMemcpyDeviceToDevice); //copy data from d_B to d_C
 
  cudaFree(d_B);
  cudaFree(d_C);
 
  // 3D array
  cudaPitchedPtr d_D;
  cudaExtent extent = make_cudaExtent(64, 32, 16); // define dimension variable extent
 
  cudaMalloc3D(&d_D, extent); // alloc on GPU global memory
  globalMemoryDemo3<<<1, 1>>>(d_D, extent); // start kernel, traverse elements of d_D
 
  cudaFree(d_D);
}
