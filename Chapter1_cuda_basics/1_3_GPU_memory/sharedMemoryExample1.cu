// dynamic alloc
__global__ void sharedMemoryDemo1( )
{
  extern __shared__ float shared_data_dynamic[];
  float *data = (float*)shared_data_dynamic;
 
  int id = threadIDx.x;
  data[id] = 0.0f; // initialization
}
 
// static alloc
__global__ void sharedMemoryDemo2( )
{
  __shared__ int shared_data_static[16];
 
  int id = threadIDx.x;
  shared_data_static[id] = 0; // initialization
}
 
int main(int argc, char** argv)
{
  int length = 16;
  sharedMemoryDemo1<<<1, length, length * sizeof(float)>>>();
  sharedMemoryDemo2<<<1, length>>>();
 
  return 0;
}
