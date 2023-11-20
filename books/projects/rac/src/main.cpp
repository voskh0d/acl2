#include <fstream>
#include <iostream>
#include <string.h>
#include <string>

#include "argparse.h"
#include "program/program.h"

int main(int argc, char **argv) {

  CommandLine cl;
  auto args = cl.parse(argc, argv);
  if (!args) {
    return 1;
  }

  if (!args->file) {
    return 0;
  }

  if (!prog.parse(*args->file + ".i")) {
    return 1;
  }

  if (!prog.process()) {
    return 1;
  }

  if (args->dump_ast) {
    prog.dumpAsDot();
  }

  if (args->mode) {
    const std::string ext = *args->mode == DispMode::acl2 ? ".ast.lsp" : ".pc";
    const std::string out = *args->file + ext;

    std::fstream fout;
    fout.open(out, std::fstream::out);
    if (!fout.is_open()) {
      std::cerr << "Failed to open file " << out << ": " << strerror(errno)
                << '\n';
    }

    prog.display(fout, *args->mode);
  }

  return 0;
}
