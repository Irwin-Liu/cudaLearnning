nt mode = 0;
bool cond1，cond2，condition;
 
for (int i = 0; i < N; i++ ) {
  cond1 = … // solve branch condition of nth loop
  cond2 = … // solve branch condition of n+1th loop
  … // solve environment variables of nth and n+1th loop
  … // set environment variables to nth loop needed
 
  if ((cond1 == false) && (cond2 == true)) {
    mode = 1;
    condition = ((i + 1) < N) ? cond2 : cond1;
    … // i+1, set environment variables to n+1th loop needed
  } else if ((cond1 == true) && (cond2 == false)) {
    mode = 2;
    condition = cond1;
  } else {  
    condition = cond1;
  }
 
  if (condition) {
    … // divergence 1: T
    if (mode == 1) {
      condition = cond1;
      … // i-1, set environment variables to nth loop needed
    }
    if (mode == 2) {
      condition = ((i + 1) < N) ? cond2 : cond1;
      mode = 0;
      … // i+1, set environment variables to n+1th loop needed
    }
    …// some codes here
  } else {
    … // divergence 2: F
    if (mode == 1) {
      mode = 0;
      … // i+1
    }
    … // some codes here
  }
}
