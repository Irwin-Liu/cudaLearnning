__global__ void registerDemo(int width)
{
  int start = width * threadIdx.x;
  int end   = start + width;
 
  for (int i = start; i < end; i++) {
    // some codes here
  }
}
