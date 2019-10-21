__global__ void vote_all(int* a, int* b, int n) 
{ 
    int tid = threadIdx.x; 
    if (tid > n) { 
       return; 
    } 
    int temp = a[tid]; 
    b[tid] = __all(temp > 100); 
} 
 
__global__ void vote_any(int* a, int* b, int n) 
{ 
    int tid = threadIdx.x; 
    if (tid > n) { 
       return; 
    } 
    int temp = a[tid]; 
    b[tid] = __any(temp > 100); 
}
