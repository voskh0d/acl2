#include <cstdlib>

inline bool error() {
  static bool b = []() { return std::getenv("RAC_BYPASS_ERROR"); }();
  return b;
}
