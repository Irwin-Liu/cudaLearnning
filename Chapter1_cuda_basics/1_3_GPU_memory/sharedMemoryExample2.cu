__global__ void sharedMemoryDemo3( )
{
  extern __shared__ char shared_data[];
 
  double* data1 = (double*)shared_data;
  float*  data2 = (float*)&data1[128];
  int*    data3 = (int*)&data2[64];
 
  // initialization
  int id = threadIDx.x;
  if (id < 128) {
    data1[id] = 0.0f;
  }
  if (id < 64) {
    data2[id] = 0.0f;
  }
  data3[id] = 0;
}
 
int main(int argc, char** argv)
{
  // alloc these arrays on GPU shared memory
  double data1[128];
  float  data2[64];
  int    data3[256];
 
  sharedMemoryDemo3<<<1, 256, 128 * sizeof(double) + 64 * sizeof(float) + 256 * sizeof(int)>>>();
}
