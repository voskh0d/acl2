#include "ac_fixed.h"

// RAC begin

int rshift(ac_fixed<4, 3, false> x) {
  x = x << 2;
  return 0;
}

int lshift(ac_fixed<4, 3, false> x) {
  x = x >> 2;
  return 0;
}

// RAC end
