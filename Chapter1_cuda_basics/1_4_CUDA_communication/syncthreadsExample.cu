__global__ void transpose(float **inputdata, float **outputdata, int width, int height)
{
  __shared__ float block[32][32]; // alloc static shared memory, blockDim.x = 32, blockDim.y = 32

  // read matrix to shared memory
  int x = blockIdx.x * blockDim.x + threadIdx.x;
  int y = blockIdx.y * blockDim.y + threadIdx.y;

  if ((x >= width) || (y >= height)) {
    return;
  }

  int i = threadIdx.x, j = threadIdx.y;

  block[j][i] = inputdata[x][y];

  __syncthreads();

  outputdata[x][y] = block[i][j];
}
