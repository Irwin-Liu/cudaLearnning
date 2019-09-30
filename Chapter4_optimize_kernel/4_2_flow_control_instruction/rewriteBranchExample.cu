// conditional assignment
if (a == b) {
  c++;
}
// instead “==” by “-”
c += !(a - b)
 
 
// segmentation judgment
if (a > b) {
  a = b;
}
// use value of (a > b)
a = a - (a > b) * (a - b);
 
 
// min(a, b)
if (a < b) {
  c = a;
} else {
  c = b;
}
// reduce time cost of min(a, b)
c = (a < b) * a + (a >= b) * b;
 
 
// assignment according to control condition
// input a = 0 or 1
if (a == 0) {
  b = 1;
} else {
  b = 5;
}
// rewrite according a = 0 or 1
b = (a << 2) + 1;
