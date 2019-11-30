// thread ID in one block
int threadID = threadIdx.x; // 1D
int threadID = threadIdx.x + threadIdx.y * blockDim.x; // 2D
int threadID = threadIdx.x + threadIdx.y * blockDim.x + threadIdx.z * blockDim.x * blockDim.y; // 3D
 
 
// block ID in one grid
int blockID = blockIdx.x; // 1D
int blockID = blockIdx.x + blockIdx.y * gridDim.x; // 2D
int blockID = blockIdx.x + blockIdx.y * gridDim.x + blockIdx.z * gridDim.x * gridDim.y; // 3D
 
 
// three components of thread ID in one grid
int threadID_x = blockIdx.x * blockDim.x + threadIdx.x; // x direction
int threadID_y = blockIdx.y * blockDim.y + threadIdx.y; // y direction
int threadID_z = blockIdx.z * blockDim.z + threadIdx.z; // z direction

// thread ID in one grid
int threadIDinGird = threadID + blockID * blockDim.x * blockDim.y * blockDim.z;
