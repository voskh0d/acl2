#include "diagnostics.h"
#include "visitor.h"

#include <limits>

void DiagnosticHandler::show_code_at(const Location &context,
                                     const Location &error) {

  assert(file_
         && "DiagnosticHandler::setup should be called before with a valid "
            "pointer");

  long saved_pos = std::ftell(file_);
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
        putc(' ', stderr);
      }
    }

    int stop_at;
    if (line == error.last_line) {
      stop_at = error.last_column;
    } else {
      stop_at = size;
    }

    for (; col < stop_at; ++col) {
      putc('^', stderr);
    }

    putc('\n', stderr);
  }

  std::free(buffer);
  assert(fseek(file_, saved_pos, SEEK_SET) == 0);
}

void DiagnosticHandler::show_location(const Location &loc) {

  std::cerr << loc.file_name << ':';

  std::cerr << loc.first_line;
  if (loc.first_line != loc.last_line)
    std::cerr << '-' << loc.last_line;

  std::cerr << " (" << loc.first_column << '-' << loc.last_column << "): ";
}

void DiagnosticHandler::report(const Location &context, const Location &error,
                               const std::string &msg) {

  std::cout << std::flush;

  if (!first_error_reported_)
    std::cerr << '\n';
  first_error_reported_ = false;

  show_location(error);

  std::cerr << msg << '\n';

  show_code_at(context, error);
}

void DiagnosticHandler::report_and_abort(const Location &context,
                                         const Location &error,
                                         const std::string &msg) {

  report(context, error, msg);
  abort();
}

void DiagnosticHandler::report_and_abort(const Location &error,
                                         const std::string &msg) {

  report_and_abort(error, error, msg);
}

void DiagnosticHandler::report(const Location &error, const std::string &msg) {
  report(error, error, msg);
}
