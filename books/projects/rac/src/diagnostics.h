#ifndef DIAGNOSTICS_H
#define DIAGNOSTICS_H

#include <cassert>
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
};

class DiagnosticHandler {

public:
  ~DiagnosticHandler() {
    if (file_)
      std::fclose(file_);
  }

  void setup(FILE *f) { file_ = f; }

  void report(Expression *context_node, Expression *error_node,
              const std::string &msg) const;
  void report(Expression *context_node, Statement *error_node,
              const std::string &msg) const;
  void report(Statement *context_node, Statement *error_node,
              const std::string &msg) const;
  void report(Statement *context_node, Expression *error_node,
              const std::string &msg) const;
  void report(Expression *error_node, const std::string &msg) const;
  void report(Statement *error_node, const std::string &msg) const;

private:
  FILE *file_ = nullptr;
};

#endif // DIAGNOSTICS_H
