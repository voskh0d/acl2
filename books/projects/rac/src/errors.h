#ifndef ERRORS_H
#define ERRORS_H

#include <cstdio>
#include <string>

struct Location {
  Location(int line, int column)
      : first_line_(line), first_column_(column), last_line_(line),
        last_column_(column) {}

  Location(int first_line, int first_column, int last_line, int last_column)
      : first_line_(first_line), first_column_(first_column),
        last_line_(last_line), last_column_(last_column) {}

  const std::string file;
  int first_line_;
  int first_column_;
  int last_line_;
  int last_column_;

  static Location dummy() { return Location{ -1, -1, -1, -1 }; }
};

class ErrorReporter {
public:
  ErrorReporter(Location loc) : loc_(loc) {}

  template <typename... Args>
  void report(const char *name, const char *format, Args... args) const {
    display_location();
    std::fputs(name, stderr);
    std::fprintf(stderr, format, args...);
    std::fprintf(stderr, "\n");
  }

  const Location &location() { return loc_; }

private:
  void display_location() const {
    std::fputs(file_.c_str(), stderr);

    std::fprintf(stderr, ":%d", loc_.first_line_);
    if (loc_.first_line_ != loc_.last_line_)
      std::fprintf(stderr, "-%d: ", loc_.last_line_);

    std::fprintf(stderr, ":%d-%d", loc_.first_column_, loc_.last_column_);
  }

  std::string file_;
  Location loc_;
};

#endif // ERRORS_H
