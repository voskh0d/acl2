#include <ac_int.h>
#include <array>
#include <rac.h>
#include <tuple>

#define STRIGIFY_IMPL(x) #x
#define STRIGIFY(x) STRIGIFY_IMPL(x)
#define UNREACHABLE()                                                         \
  assert(!"Unreachable code reached at " __FILE__ ":" STRIGIFY(__LINE__));

#ifdef SLEC_SYSTEMC
#define DBG(X)
#define DBGB(X)
#else
#define DBG(X) std::cout << (#X) << ": " << (X).to_string(AC_HEX) << '\n';
#define DBGB(X) std::cout << (#X) << ": " << (X) << '\n';
#endif // SLEC_SYSTEMC

typedef unsigned uint;

using namespace std;

#ifdef SLEC_SYSTEMC
#include "ac_probe.h"
#else
namespace ac {
  template <typename T>
  void probe_map(const char *, T) {}
}
#endif // SLEC_SYSTEMC

// RAC begin

typedef ac_int<128, false> ui128;
typedef ac_int<64, false> ui64;
typedef ac_int<36, false> ui36;
typedef ac_int<32, false> ui32;
typedef ac_int<28, false> ui28;
typedef ac_int<22, false> ui22;
typedef ac_int<21, false> ui21;
typedef ac_int<20, false> ui20;
typedef ac_int<19, false> ui19;
typedef ac_int<18, false> ui18;
typedef ac_int<18, false> ui17;
typedef ac_int<16, false> ui16;
typedef ac_int<12, false> ui12;
typedef ac_int<10, false> ui10;
typedef ac_int<9, false> ui9;
typedef ac_int<8, false> ui8;
typedef ac_int<4, false> ui4;
typedef ac_int<3, false> ui3;
typedef ac_int<2, false> ui2;
typedef ac_int<16, true> si16;
typedef ac_int<8, true> si8;

int encode8(ui9 src, int i, bool smul) {

  int res;
  switch (i) {
  case 0:
    res = src[0] - 2 * src[1];
    break;
  case 4:
    res = !smul && src[7];
    break;
  default:
    res = src[2 * i] + src[2 * i - 1] - 2 * src[2 * i + 1];
    break;
  }
  return res;
}

int encode16(ui17 src, int i, bool smul) {

  int res;
  switch (i) {
  case 0:
    res = src[0] - 2 * src[1];
    break;
  case 8:
    res = !smul && src[15];
    break;
  default:
    res = src[2 * i] + src[2 * i - 1] - 2 * src[2 * i + 1];
    break;
  }
  return res;
}

// This fonction is used to transform benc's output (a value) to the encoding
// used by the RTL.
ui4 adapt_encoding(int x) {
  ui4 pp = 0;
  pp[0] = x == 1;  // * +1
  pp[1] = x == 2;  // * +2
  pp[2] = x == -1; // * -1
  pp[3] = x == -2; // * -2
  return pp;
}

array<int, 5> booth8(ui8 x, bool smul) {

  array<int, 5> a;
  a[0] = encode8(x, 0, smul);
  a[1] = encode8(x, 1, smul);
  a[2] = encode8(x, 2, smul);
  a[3] = encode8(x, 3, smul);
  a[4] = encode8(x, 4, smul);
  return a;
}

array<int, 9> booth16(ui16 x, bool smul) {

  array<int, 9> a;
  a[0] = encode16(x, 0, smul);
  a[1] = encode16(x, 1, smul);
  a[2] = encode16(x, 2, smul);
  a[3] = encode16(x, 3, smul);
  a[4] = encode16(x, 4, smul);
  a[5] = encode16(x, 5, smul);
  a[6] = encode16(x, 6, smul);
  a[7] = encode16(x, 7, smul);
  a[8] = encode16(x, 8, smul);
  return a;
}

array<ui12, 5> partialsProducts8(ui8 b, array<int, 5> b_encs, bool bsigned) {

  array<ui12, 5> pps;
  int bval = bsigned ? int(si8(b)) : int(b);

  for (int i = 0; i < 5; i++) {
    ui12 pp = (1 << 9) + bval * b_encs[i] - (b_encs[i] < 0 ? 1 : 0);
    if (i != 0) {
      pp <<= 2;
      pp[0] = b_encs[i - 1] < 0;
    }
    pps[i] = pp;
  }
  return pps;
}

array<ui20, 9> partialsProducts16(ui16 b, array<int, 9> b_encs, bool bsigned) {

  array<ui20, 9> pps;
  int bval = bsigned ? int(si16(b)) : int(b);

  for (int i = 0; i < 9; i++) {
    ui20 pp = (1 << 17) + bval * b_encs[i] - (b_encs[i] < 0 ? 1 : 0);
    if (i != 0) {
      pp <<= 2;
      pp[0] = b_encs[i - 1] < 0;
    }
    pps[i] = pp;
  }
  return pps;
}

ui36 s36(ui36 a, ui36 b, ui36 c) { return a ^ b ^ c; }

ui36 c36(ui36 a, ui36 b, ui36 c) { return ((a & b) | (b & c) | (c & a)) << 1; }

ui21 s21(ui21 a, ui21 b, ui21 c) { return a ^ b ^ c; }

ui21 c21(ui21 a, ui21 b, ui21 c) { return ((a & b) | (b & c) | (c & a)) << 1; }

// 40 to 2 compression tree
tuple<ui36, ui36> compress(array<ui36, 40> l0pp) {
  array<ui36, 13> l0pps, l0ppc;
  for (uint i = 0; i < 13; i++) {
    l0pps[i] = s36(l0pp[3 * i], l0pp[3 * i + 1], l0pp[3 * i + 2]);
    l0ppc[i] = c36(l0pp[3 * i], l0pp[3 * i + 1], l0pp[3 * i + 2]);
  }
  array<ui36, 27> l1pp;
  l1pp[0] = l0pps[1];
  l1pp[1] = l0pps[2];
  l1pp[2] = l0pps[3];
  l1pp[3] = l0ppc[1];
  l1pp[4] = l0ppc[2];
  l1pp[5] = l0ppc[3];
  l1pp[6] = l0pps[4];
  l1pp[7] = l0ppc[4];
  l1pp[8] = l0pps[5];
  l1pp[9] = l0pps[6];
  l1pp[10] = l0ppc[5];
  l1pp[11] = l0pps[7];
  l1pp[12] = l0ppc[6];
  l1pp[13] = l0pps[0];
  l1pp[14] = l0ppc[0];
  l1pp[15] = l0ppc[7];
  l1pp[16] = l0pps[8];
  l1pp[17] = l0ppc[8];
  l1pp[18] = l0pps[9];
  l1pp[19] = l0pps[10];
  l1pp[20] = l0ppc[9];
  l1pp[21] = l0pps[11];
  l1pp[22] = l0ppc[10];
  l1pp[23] = l0ppc[11];
  l1pp[24] = l0pps[12];
  l1pp[25] = l0pp[39];
  l1pp[26] = l0ppc[12];

  array<ui36, 9> l1pps, l1ppc;
  for (uint i = 0; i < 9; i++) {
    l1pps[i] = s36(l1pp[3 * i], l1pp[3 * i + 1], l1pp[3 * i + 2]);
    l1ppc[i] = c36(l1pp[3 * i], l1pp[3 * i + 1], l1pp[3 * i + 2]);
  }
  array<ui36, 18> l2pp;
  l2pp[0] = l1pps[0];
  l2pp[1] = l1ppc[0];
  l2pp[2] = l1pps[1];
  l2pp[3] = l1ppc[1];
  l2pp[4] = l1pps[2];
  l2pp[5] = l1ppc[2];
  l2pp[6] = l1pps[3];
  l2pp[7] = l1ppc[3];
  l2pp[8] = l1pps[4];
  l2pp[9] = l1pps[5];
  l2pp[10] = l1ppc[5];
  l2pp[11] = l1pps[6];
  l2pp[12] = l1ppc[6];
  l2pp[13] = l1pps[7];
  l2pp[14] = l1ppc[7];
  l2pp[15] = l1pps[8];
  l2pp[16] = l1ppc[4];
  l2pp[17] = l1ppc[8];

  array<ui36, 6> l2pps, l2ppc;
  for (uint i = 0; i < 6; i++) {
    l2pps[i] = s36(l2pp[3 * i], l2pp[3 * i + 1], l2pp[3 * i + 2]);
    l2ppc[i] = c36(l2pp[3 * i], l2pp[3 * i + 1], l2pp[3 * i + 2]);
  }

  array<ui36, 12> l3pp;
  l3pp[0] = l2pps[0];
  l3pp[1] = l2ppc[0];
  l3pp[2] = l2pps[1];
  l3pp[3] = l2ppc[1];
  l3pp[4] = l2pps[2];
  l3pp[5] = l2ppc[2];
  l3pp[6] = l2pps[3];
  l3pp[7] = l2ppc[3];
  l3pp[8] = l2pps[4];
  l3pp[9] = l2ppc[4];
  l3pp[10] = l2pps[5];
  l3pp[11] = l2ppc[5];

  array<ui36, 4> l3pps, l3ppc;
  for (uint i = 0; i < 4; i++) {
    l3pps[i] = s36(l3pp[3 * i], l3pp[3 * i + 1], l3pp[3 * i + 2]);
    l3ppc[i] = c36(l3pp[3 * i], l3pp[3 * i + 1], l3pp[3 * i + 2]);
  }

  array<ui36, 8> l4pp;
  l4pp[0] = l3pps[0];
  l4pp[1] = l3ppc[0];
  l4pp[2] = l3pps[1];
  l4pp[3] = l3ppc[1];
  l4pp[4] = l3pps[2];
  l4pp[5] = l3ppc[2];
  l4pp[6] = l3pps[3];
  l4pp[7] = l3ppc[3];

  array<ui36, 2> l4pps, l4ppc;
  for (uint i = 0; i < 2; i++) {
    l4pps[i] = s36(l4pp[3 * i], l4pp[3 * i + 1], l4pp[3 * i + 2]);
    l4ppc[i] = c36(l4pp[3 * i], l4pp[3 * i + 1], l4pp[3 * i + 2]);
  }

  array<ui36, 6> l5pp;
  l5pp[0] = l4pps[0];
  l5pp[1] = l4ppc[0];
  l5pp[2] = l4pps[1];
  l5pp[3] = l4ppc[1];
  l5pp[4] = l4pp[6];
  l5pp[5] = l4pp[7];

  array<ui36, 2> l5pps, l5ppc;
  for (uint i = 0; i < 2; i++) {
    l5pps[i] = s36(l5pp[3 * i], l5pp[3 * i + 1], l5pp[3 * i + 2]);
    l5ppc[i] = c36(l5pp[3 * i], l5pp[3 * i + 1], l5pp[3 * i + 2]);
  }

  array<ui36, 4> l6pp;
  l6pp[0] = l5pps[0];
  l6pp[1] = l5ppc[0];
  l6pp[2] = l5pps[1];
  l6pp[3] = l5ppc[1];

  array<ui36, 1> l6pps, l6ppc;
  for (uint i = 0; i < 1; i++) {
    l6pps[i] = s36(l6pp[3 * i], l6pp[3 * i + 1], l6pp[3 * i + 2]);
    l6ppc[i] = c36(l6pp[3 * i], l6pp[3 * i + 1], l6pp[3 * i + 2]);
  }

  array<ui36, 3> l7pp;
  l7pp[0] = l6pps[0];
  l7pp[1] = l6ppc[0];
  l7pp[2] = l6pp[3];

  array<ui36, 1> l7pps, l7ppc;
  for (uint i = 0; i < 1; i++) {
    l7pps[i] = s36(l7pp[3 * i], l7pp[3 * i + 1], l7pp[3 * i + 2]);
    l7ppc[i] = c36(l7pp[3 * i], l7pp[3 * i + 1], l7pp[3 * i + 2]);
  }

  return tuple<ui36, ui36>(l7pps[0], l7ppc[0]);
}

array<ui21, 40> convert_pp(array<ui20, 40> pp) {

  // The partials products are either right or left align depending if the
  // element, is respectively, odd or even.
  array<ui21, 40> l0pp;

  l0pp[0] = pp[0] >> 8;
  // Remove additional
  l0pp[1] = pp[4].slc<12>(2);
  l0pp[2] = pp[8] >> 8;

  l0pp[3] = pp[16] >> 8;
  l0pp[4] = pp[20] >> 2;
  l0pp[5] = pp[24] >> 8;

  l0pp[6] = pp[28] >> 2;
  l0pp[7] = pp[1] >> 8;
  l0pp[8] = pp[5];

  l0pp[9] = pp[9] >> 8;
  l0pp[10] = pp[13];
  l0pp[11] = pp[17] >> 8;

  l0pp[12] = pp[21];
  l0pp[13] = pp[25] >> 8;
  l0pp[14] = pp[29];

  l0pp[15] = pp[2] >> 8;
  l0pp[16] = pp[6];
  l0pp[17] = pp[10] >> 8;

  l0pp[18] = pp[14];
  l0pp[19] = pp[18] >> 8;
  l0pp[20] = pp[22];

  l0pp[21] = pp[26] >> 8;
  l0pp[22] = pp[30];
  l0pp[23] = pp[3] >> 6;

  l0pp[24] = pp[7];
  l0pp[25] = pp[11] >> 8;
  l0pp[26] = pp[15];

  l0pp[27] = pp[19] >> 8;
  l0pp[28] = pp[23];
  l0pp[29] = pp[27] >> 8;

  l0pp[30] = pp[31];

  l0pp[31] = ui22(pp[32].slc<11>(1)) << 7;
  l0pp[31][6] = pp[33][0];
  assert(l0pp[31].slc<5>(0) == 0);
  assert(l0pp[31].slc<4>(17) == 0);

  l0pp[32] = ui22(pp[33].slc<11>(1)) << 7;
  l0pp[32][6] = pp[32][0];
  assert(l0pp[32].slc<5>(0) == 0);
  assert(l0pp[32].slc<4>(17) == 0);

  l0pp[33] = ui22(pp[34].slc<11>(1)) << 7;
  l0pp[33][6] = pp[35][0];
  assert(l0pp[33].slc<5>(0) == 0);
  assert(l0pp[33].slc<4>(17) == 0);

  l0pp[34] = ui22(pp[35].slc<11>(1)) << 7;
  l0pp[34][6] = pp[34][0];
  assert(l0pp[34].slc<5>(0) == 0);
  assert(l0pp[34].slc<4>(17) == 0);

  l0pp[35] = ui22(pp[36].slc<11>(1)) << 7;
  l0pp[35][6] = pp[37][0];
  assert(l0pp[35].slc<5>(0) == 0);
  assert(l0pp[35].slc<4>(17) == 0);

  l0pp[36] = ui22(pp[37].slc<11>(1)) << 7;
  l0pp[36][6] = pp[36][0];
  assert(l0pp[36].slc<5>(0) == 0);
  assert(l0pp[36].slc<4>(17) == 0);

  l0pp[37] = ui22(pp[38].slc<11>(1)) << 7;
  l0pp[37][6] = pp[39][0];
  assert(l0pp[37].slc<5>(0) == 0);
  assert(l0pp[37].slc<4>(17) == 0);

  l0pp[38] = ui22(pp[39].slc<11>(1)) << 7;
  l0pp[38][6] = pp[38][0];
  assert(l0pp[38].slc<5>(0) == 0);
  assert(l0pp[38].slc<4>(17) == 0);

  l0pp[39] = (pp[12] + 0xAC000 >> 2);

#ifdef SLEC_SYSTEMC
  ac::probe_map("l0pp0", l0pp[0]);
  ac::probe_map("l0pp1", l0pp[1]);
  ac::probe_map("l0pp2", l0pp[2]);
  ac::probe_map("l0pp3", l0pp[3]);
  ac::probe_map("l0pp4", l0pp[4]);
  ac::probe_map("l0pp5", l0pp[5]);
  ac::probe_map("l0pp6", l0pp[6]);
  ac::probe_map("l0pp7", l0pp[7]);
  ac::probe_map("l0pp8", l0pp[8]);
  ac::probe_map("l0pp9", l0pp[9]);
  ac::probe_map("l0pp10", l0pp[10]);
  ac::probe_map("l0pp11", l0pp[11]);
  ac::probe_map("l0pp12", l0pp[12]);
  ac::probe_map("l0pp13", l0pp[13]);
  ac::probe_map("l0pp14", l0pp[14]);
  ac::probe_map("l0pp15", l0pp[15]);
  ac::probe_map("l0pp16", l0pp[16]);
  ac::probe_map("l0pp17", l0pp[17]);
  ac::probe_map("l0pp18", l0pp[18]);
  ac::probe_map("l0pp19", l0pp[19]);
  ac::probe_map("l0pp20", l0pp[20]);
  ac::probe_map("l0pp21", l0pp[21]);
  ac::probe_map("l0pp22", l0pp[22]);
  ac::probe_map("l0pp23", l0pp[23]);
  ac::probe_map("l0pp24", l0pp[24]);
  ac::probe_map("l0pp25", l0pp[25]);
  ac::probe_map("l0pp26", l0pp[26]);
  ac::probe_map("l0pp27", l0pp[27]);
  ac::probe_map("l0pp28", l0pp[28]);
  ac::probe_map("l0pp29", l0pp[29]);
  ac::probe_map("l0pp30", l0pp[30]);
  ac::probe_map("l0pp31", l0pp[31]);
  ac::probe_map("l0pp32", l0pp[32]);
  ac::probe_map("l0pp33", l0pp[33]);
  ac::probe_map("l0pp34", l0pp[34]);
  ac::probe_map("l0pp35", l0pp[35]);
  ac::probe_map("l0pp36", l0pp[36]);
  ac::probe_map("l0pp37", l0pp[37]);
  ac::probe_map("l0pp38", l0pp[38]);
  ac::probe_map("l0pp39", l0pp[39]);
#endif // SLEC_SYSTEMC

  // PPS 1
  l0pp[15] <<= 2;
  l0pp[16] <<= 2;
  l0pp[17] <<= 2;
  l0pp[18] <<= 2;
  l0pp[19] <<= 2;
  l0pp[20] <<= 2;
  l0pp[21] <<= 2;
  l0pp[22] <<= 2;

  // PPS 2
  l0pp[23] <<= 2;
  l0pp[24] <<= 4;
  l0pp[25] <<= 4;
  l0pp[26] <<= 4;
  l0pp[27] <<= 4;
  l0pp[28] <<= 4;
  l0pp[29] <<= 4;
  l0pp[30] <<= 4;

  return l0pp;
}

tuple<ui21, ui21> compress_without_vdot16(array<ui21, 40> l0pp) {

  array<ui21, 13> l1pps, l1ppc;
  for (uint i = 0; i < 13; i++) {
    l1pps[i] = s21(l0pp[3 * i], l0pp[3 * i + 1], l0pp[3 * i + 2]);
    l1ppc[i] = c21(l0pp[3 * i], l0pp[3 * i + 1], l0pp[3 * i + 2]);
  }

  array<ui21, 27> l1pp;
  l1pp[0] = l1ppc[0];
  l1pp[1] = l1ppc[1];
  l1pp[2] = l1ppc[2];

  l1pp[3] = l1ppc[3];
  l1pp[4] = l1ppc[4];
  l1pp[5] = l1ppc[5];

  l1pp[6] = l1ppc[6];
  l1pp[7] = l1ppc[8];
  l1pp[8] = l1ppc[9];

  l1pp[9] = l1ppc[10];
  l1pp[10] = l1ppc[11];
  l1pp[11] = l1ppc[12];

  l1pp[12] = l1pps[0];
  l1pp[13] = l1pps[1];
  l1pp[14] = l1pps[2];

  l1pp[15] = l1pps[3];
  l1pp[16] = l1pps[4];
  l1pp[17] = l1pps[5];

  l1pp[18] = l1pps[6];
  l1pp[19] = l1pps[8];
  l1pp[20] = l1pps[9];

  l1pp[21] = l1pps[10];
  l1pp[22] = l1pps[11];
  l1pp[23] = l1pps[12];

  l1pp[24] = l1pps[7];
  l1pp[25] = l1ppc[7];
  l1pp[26] = l0pp[39];

  array<ui21, 9> l2pps, l2ppc;
  for (uint i = 0; i < 9; i++) {
    l2pps[i] = s21(l1pp[3 * i], l1pp[3 * i + 1], l1pp[3 * i + 2]);
    l2ppc[i] = c21(l1pp[3 * i], l1pp[3 * i + 1], l1pp[3 * i + 2]);
  }

  array<ui21, 18> l2pp;
  l2pp[0] = l2ppc[0];
  l2pp[1] = l2ppc[1];
  l2pp[2] = l2ppc[2];

  l2pp[3] = l2ppc[3];
  l2pp[4] = l2pps[2];
  l2pp[5] = l2ppc[6];

  l2pp[6] = l2pps[8];
  l2pp[7] = l2ppc[8];
  l2pp[8] = l2pps[4];

  l2pp[9] = l2ppc[5];
  l2pp[10] = l2pps[1];
  l2pp[11] = l2pps[5];

  l2pp[12] = l2ppc[4];
  l2pp[13] = l2pps[0];
  l2pp[14] = l2pps[6];

  l2pp[15] = l2ppc[7];
  l2pp[16] = l2pps[3];
  l2pp[17] = l2pps[7];

  array<ui21, 6> l3pps, l3ppc;
  for (uint i = 0; i < 6; i++) {
    l3pps[i] = s21(l2pp[3 * i], l2pp[3 * i + 1], l2pp[3 * i + 2]);
    l3ppc[i] = c21(l2pp[3 * i], l2pp[3 * i + 1], l2pp[3 * i + 2]);
  }

  array<ui21, 12> l3pp;
  l3pp[0] = l3pps[0];
  l3pp[1] = l3ppc[0];
  l3pp[2] = l3ppc[1];

  l3pp[3] = l3pps[1];
  l3pp[4] = l3pps[2];
  l3pp[5] = l3ppc[2];

  l3pp[6] = l3pps[3];
  l3pp[7] = l3ppc[3];
  l3pp[8] = l3pps[4];

  l3pp[9] = l3ppc[4];
  l3pp[10] = l3pps[5];
  l3pp[11] = l3ppc[5];

  array<ui21, 4> l4pps, l4ppc;
  for (uint i = 0; i < 4; i++) {
    l4pps[i] = s21(l3pp[3 * i], l3pp[3 * i + 1], l3pp[3 * i + 2]);
    l4ppc[i] = c21(l3pp[3 * i], l3pp[3 * i + 1], l3pp[3 * i + 2]);
  }

  array<ui21, 8> l4pp;
  l4pp[0] = l4ppc[0];
  l4pp[1] = l4pps[0];
  l4pp[2] = l4ppc[3];

  l4pp[3] = l4ppc[2];
  l4pp[4] = l4ppc[1];
  l4pp[5] = l4pps[3];

  l4pp[6] = l4pps[2];
  l4pp[7] = l4pps[1];

  array<ui21, 2> l5pps, l5ppc;
  for (uint i = 0; i < 2; i++) {
    l5pps[i] = s21(l4pp[3 * i], l4pp[3 * i + 1], l4pp[3 * i + 2]);
    l5ppc[i] = c21(l4pp[3 * i], l4pp[3 * i + 1], l4pp[3 * i + 2]);
  }

  array<ui21, 6> l5pp;
  l5pp[0] = l5pps[0];
  l5pp[1] = l4pp[6];
  l5pp[2] = l4pp[7];

  l5pp[3] = l5ppc[0];
  l5pp[4] = l5pps[1];
  l5pp[5] = l5ppc[1];

  array<ui21, 2> l6pps, l6ppc;
  for (uint i = 0; i < 2; i++) {
    l6pps[i] = s21(l5pp[3 * i], l5pp[3 * i + 1], l5pp[3 * i + 2]);
    l6ppc[i] = c21(l5pp[3 * i], l5pp[3 * i + 1], l5pp[3 * i + 2]);
  }

  array<ui21, 4> l6pp;
  l6pp[0] = l6pps[0];
  l6pp[1] = l6ppc[0];
  l6pp[2] = l6ppc[1];

  l6pp[3] = l6pps[1];

  ui21 l7pp0s = s21(l6pp[0], l6pp[1], l6pp[2]);
  ui21 l7pp0c = c21(l6pp[0], l6pp[1], l6pp[2]);

  array<ui21, 3> l7pp;
  l7pp[0] = l7pp0s;
  l7pp[1] = l7pp0c;
  l7pp[2] = l6pp[3];

  ui21 l8pp0s = s21(l7pp[0], l7pp[1], l7pp[2]);
  ui21 l8pp0c = c21(l7pp[0], l7pp[1], l7pp[2]);
  assert(l8pp0c[0] == 0);

  return tuple<ui21, ui21>(l8pp0s, l8pp0c);
}

// without_vdot16 does not change the value, it is only here to help the
// equivalence for scpu_vx_vdot_without_vdot16.
ui64 lane(ui64 opa, ui64 opb, ui64 acc, bool opa_unsigned, bool opb_unsigned,
          bool size, bool without_vdot16) {

  array<ui20, 40> pp;
  for (uint i = 0; i < 40; i++)
    pp[i] = 0;

  if (size) {
    // Select
    array<ui16, 4> a, b;
    for (uint elem = 0; elem < 4; elem++) {
      a[elem] = opa.slc<16>(elem * 16);
      b[elem] = opb.slc<16>(elem * 16);
    }

    // PP
    array<array<int, 9>, 4> b_encs;
    array<array<ui20, 9>, 4> pps_aligned;
    for (uint elem = 0; elem < 4; elem++) {
      b_encs[elem] = booth16(a[elem], !opa_unsigned);
      pps_aligned[elem]
          = partialsProducts16(b[elem], b_encs[elem], !opb_unsigned);
    }

    for (uint index = 0; index < 32; index++) {
      uint elem = index / 8;
      uint i = index % 8;
      pp[8 * elem + i] = ui20(pps_aligned[elem][i]);
    }

    // Sign placement in the last partial product is weird:
    pp[32] = pps_aligned[0][8] - (1 << 18);
    pp[32][0] = b_encs[0][7] < 0;

    // Additional
    // 0b1010101010101100000;
    pp[33] = 0x55560;

    pp[34] = pps_aligned[1][8] - (1 << 18);
    pp[34][0] = b_encs[1][7] < 0;
    pp[36] = pps_aligned[2][8] - (1 << 18);
    pp[36][0] = b_encs[2][7] < 0;
    pp[38] = pps_aligned[3][8] - (1 << 18);
    pp[38][0] = b_encs[3][7] < 0;

  } else {
    // Select
    array<ui8, 8> a, b;
    for (uint elem = 0; elem < 8; elem++) {
      a[elem] = opa.slc<8>(elem * 8);
      b[elem] = opb.slc<8>(elem * 8);
    }

    // PP
    array<array<int, 5>, 8> b_encs;
    array<array<ui12, 5>, 8> pps_aligned;
    for (uint elem = 0; elem < 8; elem++) {
      b_encs[elem] = booth8(a[elem], !opa_unsigned);
      pps_aligned[elem]
          = partialsProducts8(b[elem], b_encs[elem], !opb_unsigned);
    }

    // align
    for (uint index = 0; index < 32; index++) {
      uint elem = index / 4;
      uint i = index % 4;
      if (elem % 2 == 0) {
        pp[4 * elem + i] = ui20(pps_aligned[elem][i]) << 8;
      } else {
        pp[4 * elem + i] = ui20(pps_aligned[elem][i]) << (i == 0 ? 2 : 0);
      }
    }

    for (uint elem = 0; elem < 8; elem++) {
      pp[32 + elem] = pps_aligned[elem][4] - (1 << 10);
      // Sign placement in the last partial product is weird:
      if (elem % 2 == 0) {
        pp[32 + elem][0] = b_encs[elem + 1][3] < 0;
      } else {
        pp[32 + elem][0] = b_encs[elem - 1][3] < 0;
      }
    }

    // Injecting additional
    pp[4] += 0xAC000;
  }

#ifdef SLEC_SYSTEMC
  // A0 x B0
  ac::probe_map("pp0", pp[0]);
  ac::probe_map("pp4", pp[1]);
  ac::probe_map("pp8", pp[2]);
  ac::probe_map("pp12", pp[3]);

  // A1 x B1
  ac::probe_map("pp16", pp[4]);
  ac::probe_map("pp20", pp[5]);
  ac::probe_map("pp24", pp[6]);
  ac::probe_map("pp28", pp[7]);

  // A2 x B2
  ac::probe_map("pp1", pp[8]);
  ac::probe_map("pp5", pp[9]);
  ac::probe_map("pp9", pp[10]);
  ac::probe_map("pp13", pp[11]);

  // A3 x B3
  ac::probe_map("pp17", pp[12]);
  ac::probe_map("pp21", pp[13]);
  ac::probe_map("pp25", pp[14]);
  ac::probe_map("pp29", pp[15]);

  // A4 x B4
  ac::probe_map("pp2", pp[16]);
  ac::probe_map("pp6", pp[17]);
  ac::probe_map("pp10", pp[18]);
  ac::probe_map("pp14", pp[19]);

  // A5 x B5
  ac::probe_map("pp18", pp[20]);
  ac::probe_map("pp22", pp[21]);
  ac::probe_map("pp26", pp[22]);
  ac::probe_map("pp30", pp[23]);

  // A6 x B6
  ac::probe_map("pp3", pp[24]);
  ac::probe_map("pp7", pp[25]);
  ac::probe_map("pp11", pp[26]);
  ac::probe_map("pp15", pp[27]);

  // A7 x B7
  ac::probe_map("pp19", pp[28]);
  ac::probe_map("pp23", pp[29]);
  ac::probe_map("pp27", pp[30]);
  ac::probe_map("pp31", pp[31]);

  ac::probe_map("pp32", pp[32]);
  ac::probe_map("pp33", pp[34]);
  ac::probe_map("pp34", pp[36]);
  ac::probe_map("pp35", pp[38]);

  ac::probe_map("pp36", pp[33]);
  ac::probe_map("pp37", pp[35]);
  ac::probe_map("pp38", pp[37]);
  ac::probe_map("pp39", pp[39]);
#endif // SLEC_SYSTEMC

  if (without_vdot16) {

    array<ui21, 40> l0pp = convert_pp(pp);

    ui21 pps, ppc;
    tie(pps, ppc) = compress_without_vdot16(l0pp);

#ifdef SLEC_SYSTEMC
    ac::probe_map("l8pp0s", pps);
    ac::probe_map("l8pp0c", ppc);
#endif

    ui21 sum_pp = ui21(pps + ppc);
    return sum_pp + acc + 0xfff00000;
  } else {
    array<ui36, 40> l0pp;
    for (uint i = 0; i < 40; i++) {
      l0pp[i] = 0;
    }
    l0pp[0] = ui36(pp[35]) << 14;
    l0pp[1] = ui36(pp[37]) << 14;
    l0pp[2] = ui36(pp[39]) << 14;

    l0pp[3] = pp[0];
    l0pp[4] = pp[8];
    l0pp[5] = pp[16];
    l0pp[6] = pp[24];
    l0pp[7] = pp[1];
    l0pp[8] = pp[9];
    l0pp[9] = pp[17];
    l0pp[10] = pp[25];
    l0pp[11] = ui36(pp[2]) << 2;
    l0pp[12] = ui36(pp[10]) << 2;
    l0pp[13] = ui36(pp[18]) << 2;
    l0pp[14] = ui36(pp[26]) << 2;
    l0pp[15] = ui36(pp[3]) << 4;
    l0pp[16] = ui36(pp[11]) << 4;
    l0pp[17] = ui36(pp[19]) << 4;
    l0pp[18] = ui36(pp[27]) << 4;
    l0pp[19] = ui36(pp[4]) << 6;
    l0pp[20] = ui36(pp[12]) << 6;
    l0pp[21] = ui36(pp[20]) << 6;
    l0pp[22] = ui36(pp[28]) << 6;
    l0pp[23] = ui36(pp[5]) << 8;
    l0pp[24] = ui36(pp[13]) << 8;
    l0pp[25] = ui36(pp[21]) << 8;
    l0pp[26] = ui36(pp[29]) << 8;
    l0pp[27] = ui36(pp[6]) << 10;
    l0pp[28] = ui36(pp[14]) << 10;
    l0pp[29] = ui36(pp[22]) << 10;
    l0pp[30] = ui36(pp[30]) << 10;
    l0pp[31] = ui36(pp[7]) << 12;
    l0pp[32] = ui36(pp[15]) << 12;
    l0pp[33] = ui36(pp[23]) << 12;
    l0pp[34] = ui36(pp[31]) << 12;
    l0pp[35] = ui36(pp[32]) << 14;
    l0pp[36] = ui36(pp[34]) << 14;
    l0pp[37] = ui36(pp[36]) << 14;
    l0pp[38] = ui36(pp[38]) << 14;
    l0pp[39] = ui36(pp[33]) << 14;

    ui36 pps, ppc;
    tie(pps, ppc) = compress(l0pp);
    ui36 sum_pp = pps + ppc;
    if (size) {
      return sum_pp + acc + 0xFFFFFFF800000000U;
    } else {
      return (sum_pp >> 8) + 0xFFFFFFFFFFF00000U + acc;
    }
  }
}

ui128 vdot(ui128 opa, ui128 opb, ui128 acc, bool opa_unsigned,
           bool opb_unsigned, bool quad_result, bool size, bool mmla,
           bool scalar, ui2 index_in, bool sel_4ways, bool without_vdot16) {

  // Keeping index as ac register cause some compilation error.
  uint index = index_in;

  ui64 opa_lane1 = 0;
  ui64 opb_lane1 = 0;
  ui64 acc_lane1 = 0;
  if (size) {
    if (sel_4ways) {
      opa_lane1 = opa.slc<64>(0);
      opb_lane1 = opb.slc<64>((scalar ? index : 0) * 4 * 16);
      acc_lane1 = acc.slc<64>(0);
    } else {
      opa_lane1 = opa.slc<64>(0);
      opb_lane1 = opb.slc<32>((scalar ? index : 0) * 2 * 16);
      acc_lane1 = acc.slc<32>(0);
    }
  } else {
    if (mmla) {
      opa_lane1 = opa.slc<64>(0);
      opb_lane1 = opb.slc<64>(0);
      acc_lane1 = acc.slc<32>(0);
    } else {
      opa_lane1 = opa.slc<32>(0);
      opb_lane1 = ui64(opb.slc<32>((scalar ? index : 0) * 4 * 8));
      acc_lane1 = acc.slc<32>(0);
    }
  }
  ui128 lane1_res = lane(opa_lane1, opb_lane1, acc_lane1, opa_unsigned,
                         opb_unsigned, size, without_vdot16);

  ui64 opa_lane2 = 0;
  ui64 opb_lane2 = 0;
  if (size) {
    if (sel_4ways) {
      // Disabled
    } else {
      opa_lane2 = ui64(opa.slc<32>(32)) | (ui64(opa.slc<32>(0)) << 32);
      opb_lane2 = opb.slc<32>((scalar ? index : 1) * 2 * 16);
    }
  } else {
    if (mmla) {
      opa_lane2 = ui64(opa.slc<32>(32)) | (ui64(opa.slc<32>(0)) << 32);
      opb_lane2 = ui64(opb.slc<32>(96)) | (ui64(opb.slc<32>(64)) << 32);
    } else {
      opa_lane2 = ui64(opa.slc<32>(32));
      opb_lane2 = ui64(opb.slc<32>((scalar ? index : 1) * 4 * 8));
    }
  }
  ui128 lane2_res = lane(opa_lane2, opb_lane2, acc.slc<32>(32), opa_unsigned,
                         opb_unsigned, size, without_vdot16);

  // Lane 3, on when quad_result.
  ui64 opa_lane3 = 0;
  ui64 opb_lane3 = 0;
  ui64 acc_lane3 = 0;
  if (size) {
    if (sel_4ways) {
      opa_lane3 = opa.slc<64>(64);
      opb_lane3 = opb.slc<64>((scalar ? index : 1) * 4 * 16);
      acc_lane3 = acc.slc<64>(64);
    } else {
      opa_lane3 = opa.slc<64>(64);
      opb_lane3 = opb.slc<32>((scalar ? index : 2) * 2 * 16);
      acc_lane3 = acc.slc<32>(64);
    }
  } else {
    if (mmla) {
      opa_lane3 = opa.slc<64>(64);
      opb_lane3 = opb.slc<64>(0);
      acc_lane3 = acc.slc<32>(64);
    } else {
      opa_lane3 = ui64(opa.slc<32>(64));
      opb_lane3 = ui64(opb.slc<32>((scalar ? index : 2) * 4 * 8));
      acc_lane3 = acc.slc<32>(64);
    }
  }
  ui128 lane3_res = lane(opa_lane3, opb_lane3, acc_lane3, opa_unsigned,
                         opb_unsigned, size, without_vdot16);

  // Lane 4, on when quad_result.
  ui64 opa_lane4 = 0;
  ui64 opb_lane4 = 0;
  if (mmla || size) {

    if (sel_4ways) {
      opa_lane4 = ui64(opa.slc<32>(96)) | (ui64(opa.slc<32>(64)) << 32);
      opb_lane4 = ui64(opb.slc<32>(96)) | (ui64(opb.slc<32>(64)) << 32);
    } else {
      opa_lane4 = ui64(opa.slc<32>(96)) | (ui64(opa.slc<32>(64)) << 32);
      opb_lane4 = opb.slc<32>((scalar ? index : 3) * 2 * 16);
    }
  } else {
    opa_lane4 = ui64(opa.slc<32>(96));
    opb_lane4 = ui64(opb.slc<32>((scalar ? index : 3) * 4 * 8));
  }
  ui128 lane4_res = lane(opa_lane4, opb_lane4, acc.slc<32>(96), opa_unsigned,
                         opb_unsigned, size, without_vdot16);

#ifdef SLEC_SYSTEMC
  ac::probe_map("opa_lane1", opa_lane1);
  ac::probe_map("opa_lane2", opa_lane2);
  ac::probe_map("opa_lane3", opa_lane3);
  ac::probe_map("opa_lane4", opa_lane4);

  ac::probe_map("opb_lane1", opb_lane1);
  ac::probe_map("opb_lane2", opb_lane2);
  ac::probe_map("opb_lane3", opb_lane3);
  ac::probe_map("opb_lane4", opb_lane4);

  ac::probe_map("signed_prod_lane1_v2", lane1_res);
  ac::probe_map("signed_prod_lane2_v2", lane2_res);
  ac::probe_map("signed_prod_lane3_v2", lane3_res);
  ac::probe_map("signed_prod_lane4_v2", lane4_res);
#endif // SLEC_SYSTEMC

  ui128 res = 0;

  if (size) {
    if (sel_4ways) {
      res = lane1_res.slc<64>(0);
      if (quad_result) {
        res.set_slc(64, lane3_res.slc<64>(0));
      }
    } else {
      res.set_slc(0, ui32(lane1_res));
      res.set_slc(32, ui32(lane2_res));
      if (quad_result) {
        res.set_slc(64, ui32(lane3_res));
        res.set_slc(96, ui32(lane4_res));
      }
    }
  } else {
    res = lane1_res.slc<32>(0);
    res.set_slc(32, ui32(lane2_res));

    if (quad_result) {
      res.set_slc(64, ui32(lane3_res));
      res.set_slc(96, ui32(lane4_res));
    }
  }

  return res;
}

// RAC end

#ifdef SLEC_SYSTEMC

SC_MODULE(vdot_wrapper) {

  sc_in_clk clk;
  sc_in<bool> reset;

  sc_in<bool> size;
  sc_in<bool> mmla;
  sc_in<bool> scalar;
  sc_in<ui2> index;
  sc_in<bool> sel_4ways;

  sc_in<bool> quad_result;

  sc_in<bool> opa_unsigned;
  sc_in<bool> opb_unsigned;

  sc_in<ui128> opa;
  sc_in<ui128> opb;
  sc_in<ui128> acc;

  sc_out<ui128> vdout_out;

  void doit() {

    if (reset.read()) {
      return;
    }

#ifdef WITHOUT_16BITS
    bool without_vdot16 = true;
#else
    bool without_vdot16 = false;
#endif
    ui128 res = vdot(opa.read(), opb.read(), acc.read(), opa_unsigned.read(),
                     opb_unsigned.read(), quad_result.read(), size.read(),
                     mmla.read(), scalar.read(), index.read(),
                     /* sel_4ways.read() */ true, without_vdot16);

    vdout_out.write(res);
  }

  SC_CTOR(vdot_wrapper) {
    SC_METHOD(doit);
    sensitive_pos << clk;
  }
};

#else

#include <iostream>

int main() {

  // 0 0 0 0   100100015092a 0
  // 0 0 2 0 1 f890a96ae00a76f1 65fabb55e6cbd8a5 1
  // 0 0 2 0 1 4936522e980e8c7db36102186047c3ab
  // 4d8ef975b84c4d2a047e9476d1334425 0
  // 1 0 1 1 1 1 9045fe9621a8a72009571d17e0da82d0
  // af80ed00e864cbaf20720832192228d6 15c18ef7968639f8e150a049f26c2ac6 0
  ui128 opa = ac::bit_fill_hex<ui128>("9045fe9621a8a72009571d17e0da82d0");
  ui128 opb = ac::bit_fill_hex<ui128>("af80ed00e864cbaf20720832192228d6");
  ui128 acc = ac::bit_fill_hex<ui128>("cc12ef52901e378a293a417bfa41b3e3");
  bool opa_unsigned = 1;
  bool opb_unsigned = 1;
  bool size = 1;
  bool mmla = 0;
  ui2 index = 1;
  bool scalar = false;

  DBG(opa);
  DBG(opb);
  auto res = vdot(opa, opb, acc, opa_unsigned, opb_unsigned, true, size, mmla,
                  scalar, index, true, true);

  DBG(res);
}

#endif
