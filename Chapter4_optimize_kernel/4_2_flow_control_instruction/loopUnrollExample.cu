struct S1_t { static const int value = 4; };
template <int X, typename T2>

__device__ void foo(int *p1, int *p2) { 
// no argument specified, loop will be completely unrolled
#pragma unroll
for (int i = 0; i < 12; ++i)
  p1[i] += p2[i] * 2;
   
// unroll value = 8
#pragma unroll (X+1)
for (int i = 0; i < 12; ++i)
  p1[i] += p2[i] * 4;
 
// unroll value = 1, loop unrolling disabled
#pragma unroll 1
for (int i = 0; i < 12; ++i)
  p1[i] += p2[i] * 8;
 
// unroll value = 4
#pragma unroll (T2::value)
for (int i = 0; i < 12; ++i)
  p1[i] += p2[i] * 16;
}
 
__global__ void bar(int *p1, int *p2) {
  foo<7, S1_t>(p1, p2);
}
