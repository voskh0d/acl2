#include <ac_fixed.h>

// RAC begin

typedef ac_fixed<2, 1> fp21;

fp21 foo() {
  fp21 a = 1;
  return a;
}

// RAC end

int main() { return foo() == 1; }
