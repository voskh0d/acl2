#include <ac_fixed.h>

// RAC begin

typedef ac_fixed<2, 1> fp21;

int foo() {
  fp21 a = 3;
  return a;
}

// RAC end
