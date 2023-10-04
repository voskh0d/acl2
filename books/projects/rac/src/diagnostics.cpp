#include "diagnostics.h"
#include "visitor.h"

#include <limits>

std::ostream &operator<<(std::ostream &os, const Location &loc) {

  os << loc.file_name << ':';

  os << loc.first_line;
  if (loc.first_line != loc.last_line)
    os << '-' << loc.last_line;

  os << " (" << loc.first_column << '-' << loc.last_column << "):";

  return os;
}

void DiagnosticHandler::show_code_at(const Location &context,
                                     const Location &error) {

  assert(file_
         && "DiagnosticHandler::setup should be called before with a valid "
            "pointer");

  long saved_pos = std::ftell(file_);

  // f_pos is the begining of the first token of context. We recover the
  // begining of the line to display the code.
  long cur_pos = context.f_pos - context.first_column;

  // Move the cursor to the begin of the area we need to report.
  assert(fseek(file_, cur_pos, SEEK_SET) == 0);

  static char *buffer = nullptr;
  size_t size = 0;

  // By default, we show all the context...
  int first_line_to_display = context.first_line;
  int last_line_to_display = context.last_line;

  // ... but if it is too long, we only show the error...
  if (last_line_to_display - first_line_to_display > 5) {
    first_line_to_display = error.first_line;
    last_line_to_display = error.last_line;
  }

  // ... unless if it is also too big, in that case we only the first 5 lines.
  if (last_line_to_display - first_line_to_display > 5) {
    last_line_to_display = first_line_to_display + 5;
  }

  for (int line = first_line_to_display; line <= last_line_to_display;
       ++line) {
    // Display the code.
    size = getline(&buffer, &size, file_);
    cur_pos += size;
    std::fprintf(stderr, "% 3d | %s", line, buffer);

    // If we are not in the part responsible for the error, skip the rest.
    if (line < error.first_line || line > error.last_line) {
      continue;
    }

    fputs("    | ", stderr);

    int col = 0;
    if (line == error.first_line) {
      for (; col < error.first_column; ++col) {
        std::putc(' ', stderr);
      }
    }

    int stop_at;
    if (line == error.last_line) {
      stop_at = error.last_column;
    } else {
      stop_at = size;
    }

    for (; col < stop_at; ++col) {
      std::putc('^', stderr);
    }

    std::putc('\n', stderr);
  }

  std::free(buffer);
  assert(std::fseek(file_, saved_pos, SEEK_SET) == 0);
}

void DiagnosticHandler::report(const Location &context, const Location &error,
                               const std::string &msg) {

  std::cout << std::flush;

  if (!first_error_reported_)
    std::cerr << '\n';
  first_error_reported_ = false;

  std::cerr << error << ' ' << msg << '\n';

  show_code_at(context, error);
}

void DiagnosticHandler::report(const Location &error, const std::string &msg) {
  report(error, error, msg);
}
