#include <fstream>
#include <iostream>
#include <stdio.h>
#include <string>

#include "parser.h"
#include "program.h"
#include "version.h"

void version() {

  std::cout << "RAC: version 1.1-dev\n"
            << "Build " << __DATE__ << '\n'
            << "from: " << git_commit << '\n';
}

int main(int argc, char **argv) {

  ++argv, --argc; /* skip over program name */

  if (argc == 0) {
    std::cout
        << "Usage:\n\n"
           "  parse file           check that file.cpp is well formed\n"
           "  parse file -rac      convert to RAC pseudocode and write to "
           "file.pc\n"
           "  parse file -acl2     write ACL2 translation to output.lisp\n\n"
           "  parse -version       display version\n";
    return 0;
  }

  DispMode type;
  if (argc == 1) {
    if (!strcmp(argv[0], "-version")) {
      version();
      return 0;
    } else {
      // Only parse
      type = DispMode::none;
    }
  } else {
    if (!strcmp(argv[1], "-acl2")) {
      type = DispMode::acl2;
    } else if (!strcmp(argv[1], "-rac")) {
      type = DispMode::rac;
    } else {
      std::cerr << "Unknown option `" << argv[1]
                << "`, for a list of available options, type `parse`";
      return 1;
    }
  }

  std::string buf(argv[0]);
  buf += ".i";
  yyin = fopen(buf.c_str(), "r");
  if (yyin == nullptr) {
    std::cerr << "Failed to open file " << buf << ": " << strerror(errno)
              << '\n';
    return 1;
  }

  yylineno = 1;
  if (yyparse()) {
    return 1;
  }

  fclose(yyin);

  if (prog.isEmpty())
    puts("Warning: no function definitions found,"
         " maybe you forgot the `// RAC begin` guard");

  if (type == DispMode::none)
    return 0;

  // Restore basename
  buf.pop_back();
  buf.pop_back();
  buf += type == DispMode::acl2 ? ".ast.lsp" : ".pc";

  std::fstream fout;
  fout.open(buf, fstream::out);
  if (!fout.is_open())
    std::cerr << "Failed to open file " << buf << ": " << strerror(errno)
              << '\n';

  prog.display(fout, type);
}
