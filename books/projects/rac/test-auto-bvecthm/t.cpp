
// RAC begin


struct my_sintr { int a; bool b; };

int foo() {

  ac_int<3, false> a = 4;
  int b = 4;
  int64 c = 4;
  bool d = false;

  array<int, 6> arr = {{ 2, 3 }};
  array<ac_int<2, false>, 6> arr2 = {{ 2, 3 }};

  const array<int, 6> arr3 = {{ 2, 3 }};

  my_sintr s = { 3, false };

  array<my_sintr, 2> array_of_struct = {{ {1, true}, {2, false} }};

  array<array<int, 3>, 2> arr_of_arr = {{ {{}}, {{}} }};
//  arr_of_arr[0][0] = 3;
//  arr_of_arr[1][0] = 3;

  // TODO structs
  // TODO static arrays



  return 1;
}
