int not_suspended = 1;
int cond;
 
for (int i = 0; i < N; i++) {
  if (not_suspended) {
    cond = … // solve branch condition
  }
 
  … // path selection (most-preferred or rotary)
  … // set values of not_suspend and cond_opt
  if (not_suspended) {
    if (cond_opt) {
      … // divergence 1
    } else {
      … // divergence 2
    }
    … // some codes here
  }
}
