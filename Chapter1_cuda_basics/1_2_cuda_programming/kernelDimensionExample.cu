// 1D
dim3 blockNum(16); // equal to "blockNum.x = 16; blockNum.y = 1; blockNum.z = 1;"
dim3 threadNum(512); // equal to "threadNum.x = 512; threadNum.y = 1; threadNum.z = 1;"
kernelsample1d<<<blockNum, threadNum>>>();
 
// 2D
dim3 blockNum(4, 4); // equal to "blockNum.x = 4; blockNum.y = 4; blockNum.z = 1;"
dim3 threadNum(128, 4); // equal to "threadNum.x = 128; threadNum.y = 4; threadNum.z = 1;"
kernelsample2d<<<blockNum, threadNum>>>();
 
// 3D
dim3 blockNum(4, 2, 2); // equal to "blockNum.x = 4; blockNum.y = 2; blockNum.z = 2;"
dim3 threadNum(16, 8, 4); // equal to "threadNum.x = 16; threadNum.y = 8; threadNum.z = 4;"
kernelsample3d<<<blockNum, threadNum>>>();
