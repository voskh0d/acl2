#include "ac_int.h"

// RAC begin

template <int n>
ac_int<n, false> foo() {
  return ac_int<n, false>(4);
}

int main() { return foo<4>(); }
