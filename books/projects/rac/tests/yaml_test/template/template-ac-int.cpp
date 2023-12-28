#include "ac_int.h"

// RAC begin

template <int n>
ac_int<n, false> slc_test() {
  return ac_int<n, false>(4);
}

int main() { return slc_test<4>(); }
