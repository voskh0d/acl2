#include "diagnostics.h"
#include "visitor.h"

template <typename NodeContext, typename NodeError>
void show_code_at(NodeContext c, NodeError e, FILE *file) {

  // Trick to have constexpr ternary.
  const Location &loc = [&]() {
    if constexpr (std::is_same_v<std::nullptr_t, NodeContext>) {
      return e->loc();
    } else {
      return c->loc();
    }
  }();

  const auto &error_loc = e->loc();
  long cur_pos = loc.f_pos;

  // Move the cursor to the begin of the area we need to report.
  assert(fseek(file, loc.f_pos, SEEK_SET) == 0);

  static char *buffer = nullptr;
  size_t size = 0;

  for (int line = loc.first_line; line <= loc.last_line; ++line) {
    // Display the code.
    size = getline(&buffer, &size, file);
    cur_pos += size;
    std::fprintf(stderr, "% 3d | %s", line, buffer);

    // If we are not in the part responsible for the error, skip the rest.
    if (line < error_loc.first_line || line > error_loc.last_line) {
      continue;
    }

    fputs("    | ", stderr);

    // First we want to display space until we reach the begining of the
    // issue. We use f_pos to take into account the indentation (wich will not
    // be display since f_pos takes the begining of a word but first_col count
    // from the first charater including indentation).
    const int begin_of_line = cur_pos - size;
    int i = begin_of_line;
    for (; i < error_loc.f_pos; ++i) {
      putc(' ', stderr);
    }
    // i is at the begining of the area we want to highlight.

    // We want to highlight the are between the begining (i) and either the end
    // of the issue (width + i) or the end of the line.
    const int width = error_loc.last_column - error_loc.first_column;
    const int end_of_line = begin_of_line + size;
    const int stop_at = std::min(i + width, end_of_line);

    for (int j = i; j < stop_at; ++j)
      putc('^', stderr);

    putc('\n', stderr);
  }

  std::free(buffer);
}

template <typename NodeContext, typename NodeError>
void report_impl(NodeContext n_context, NodeError n_error,
                 const std::string &msg, FILE *file) {

  const auto &loc = n_error->loc();
  std::cerr << loc.file_name << ':';

  std::cerr << loc.first_line;
  if (loc.first_line != loc.last_line)
    std::cerr << '-' << loc.last_line;

  std::cerr << " (" << loc.first_column << '-' << loc.last_column << "): ";
  std::cerr << msg << '\n';

  show_code_at(n_context, n_error, file);
  abort();
}

void DiagnosticHandler::report(Expression *context_node,
                               Expression *error_node,
                               const std::string &msg) const {
  report_impl(context_node, error_node, msg, file_);
}

void DiagnosticHandler::report(Expression *context_node, Statement *error_node,
                               const std::string &msg) const {
  report_impl(context_node, error_node, msg, file_);
}

void DiagnosticHandler::report(Statement *context_node, Statement *error_node,
                               const std::string &msg) const {
  report_impl(context_node, error_node, msg, file_);
}

void DiagnosticHandler::report(Statement *context_node, Expression *error_node,
                               const std::string &msg) const {
  report_impl(context_node, error_node, msg, file_);
}

void DiagnosticHandler::report(Expression *error_node,
                               const std::string &msg) const {
  report_impl(nullptr, error_node, msg, file_);
}

void DiagnosticHandler::report(Statement *error_node,
                               const std::string &msg) const {
  report_impl(nullptr, error_node, msg, file_);
}
