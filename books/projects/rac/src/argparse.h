#ifndef ARGPARSE_H
#define ARGPARSE_H

#include <iostream>
#include <optional>
#include <string>
#include <vector>

#include "program.h"
#include "version.h"

class CommandLine {
public:
  struct Result {
    bool dump_ast = false;
    std::optional<std::string> file = {};
    std::optional<DispMode> mode = std::nullopt;
  };

  // Parse argv directly (the name of the program is still at argv[0]). If an
  // error if found (like a unknown option std::nullopt) is returned.
  std::optional<Result> parse(int argc, char **argv) {

    // If nothing is provided this is error.
    if (argc == 1) {
      help();
      return std::nullopt;
    }

    Result res;

    for (int i = argc - 1; i > 0; --i) {
      std::string arg(argv[i]);

      if (arg == "-h" || arg == "-help") {
        help();
      } else if (arg == "-v" || arg == "-version") {
        version();
      } else if (arg == "-rac") {
        res.mode = DispMode::rac;
      } else if (arg == "-acl2") {
        res.mode = DispMode::acl2;
      } else if (arg == "-dump-ast") {
        res.dump_ast = true;
      } else {
        if (arg.size() >= 1 && arg[0] == '-') {
          return error("Unknown option `", arg, '`');
        }
        if (res.file && arg != "") {
          return error("Duplicate file name");
        }
        res.file = { arg };
      }
    }

    if ((res.dump_ast || res.mode) && !res.file) {
      return error("Missing file name");
    }

    return res;
  }

  void help() {
    std::cout
        << "This is the RAC (Restricted Algorithmic C) parser which translate "
           "a\n"
           "RAC program into a list of S-Expressions.\n\n"
           "Usage:\n"
           "  parse FILE [options]\n\n"
           "Options:\n"
           "  -rac       convert to RAC pseudocode and write to file.pc\n"
           "  -acl2      write ACL2 translation to file.ast.lsp\n"
           "  -dump-ast  display the intermediate AST in dot format\n";
  }

  void version() {
    std::cout << "RAC (Restricted Algorithmic C) parser\n"
              << "Built from ACL2 commit: " << git_commit << '\n';
  }

private:
  template <typename T>
  void print_pack(T t) {
    std::cerr << t;
  }

  template <typename... Rest, typename T>
  void print_pack(T t, Rest... r) {
    std::cerr << t;
    print_pack(r...);
  }

  template <typename... Printable>
  inline std::optional<Result> error(Printable... msg) {
    print_pack(msg..., '\n');
    help();
    return std::nullopt;
  }
};

#endif // ARGPARSE_H
