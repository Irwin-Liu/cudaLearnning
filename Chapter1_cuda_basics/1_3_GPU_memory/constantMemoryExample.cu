__constant__ int  num = 16; // method 1
__constant__ int  con_t[16] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}; // method 1
__constant__ char con_p[16]; // method 2

__global__ static void constantMemoryDemo(char* result)
{
  int index = threadIdx.x;
  if (index >= num) {
    return;
  }
  result[index] = con_p[index] + con_t[index];
}

int main(int argc, char** argv[])
{
  char h_result[16] = {0};
  char *d_result;
  cudaMalloc((void **)&d_result, 16 * sizeof(char));

  char h_con_p[16] = "Let's learn cuda";
  cudaMemcpyToSymbol(con_p, h_con_p, 16 * sizeof(char)); // method 2
  constantMemoryDemo<<<1, 32>>>(d_result);
  cudaMemcpy(&h_result, d_result, 16 * sizeof(char), cudaMemcpyDeviceToHost);

  cudaFree(d_result);
}
