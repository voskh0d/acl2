#ifndef DIAGNOSTICS_H
#define DIAGNOSTICS_H

#include <iostream>
#include <string>

class Expression;
class Statement;

struct Location {

  inline static Location from_file(const std::string &f) {
    return Location{ 0, 0, 0, 0, 0, 0, f };
  }

  // Used for AST nodes which don't have a clear location (and where it should
  // not matter !!).
  inline static Location dummy() {
    return Location{ -1, -1, -1, -1, -1, -1, "" };
  }

  int first_line, last_line, first_column, last_column;
  // Position relative to the begining of the file.
  long f_pos, f_pos_end;

  // TODO replace this by the string view ?
  std::string file_name;

  friend std::ostream &operator<<(std::ostream &os, const Location &loc);
};

class DiagnosticHandler {

public:
  ~DiagnosticHandler() {
    if (file_)
      std::fclose(file_);
  }

  void setup(FILE *f) { file_ = f; }

  void report(const Location &context, const Location &error,
              const std::string &msg);
  void report(const Location &error, const std::string &msg);

private:
  // Display the code at context and highlight the are delimited by error like
  // that:
  //
  //  4 | context context error context
  //    |                 ^^^^^
  //
  // The error location should be inside or equal to the area delimited by
  // context.
  void show_code_at(const Location &context, const Location &error);

  FILE *file_ = nullptr;
  // If it is not the first error, we add a new line between error messages.
  bool first_error_reported_ = true;
};

#endif // DIAGNOSTICS_H
