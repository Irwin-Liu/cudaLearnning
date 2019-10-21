int main(int argc, char** argv)
{
  // some initialization
 
  kernel1<<<2, 512>>>();
 
  int a = 2 * 512;
 
  __cudaThreadSynchronize(); // or __cudaDeviceSynchronize();
 
  int b = 4 * 256;
 
  kernel2<<<4, 256>>>();
 
  return 0;
}
