#ifndef PROGRAM_H
#define PROGRAM_H

#include "displaymode.h"
#include "parser/ast/ast.h"
#include "parser/utils/diagnostics.h"

#include <algorithm>
#include <string>
#include <vector>

//***********************************************************************************
// Programs
//***********************************************************************************

class Program : public AST {
public:
  // Apply all required passes (type check, desugarization, ...) to the
  // program.
  enum class Warning { All, Minimal };
  static std::optional<Program> process(AST &&ast, bool all_warnings);

  void dumpAsDot();

  // Display functions.
  void displayConstDecs(std::ostream &os, DispMode mode) const;
  // Why this one is not defined
  //  void displayTemplates(ostream& os, DispMode mode, const std::string&
  //  prefix="");
  void displayTypeDefs(std::ostream &os, DispMode mode) const;
  void displayFunDefs(std::ostream &os, DispMode mode) const;
  void displayFunDecs(std::ostream &os) const;
  void display(std::ostream &os, DispMode mode = DispMode::rac) const;

  // Run an action (implemented by v) on the full program in the following
  // order: types, constant declarations, template fuctions and functions.
  template <typename Visitor>
  bool runAction(Visitor *v) {
    return std::all_of(typeDefs.begin(), typeDefs.end(),
                       [&](auto e) { return v->TraverseType(e); })
           && std::all_of(constDecs.begin(), constDecs.end(),
                          [&](auto e) { return v->TraverseStatement(e); })
           && std::all_of(templates.begin(), templates.end(),
                          [&](auto e) { return v->TraverseStatement(e); })
           && std::all_of(funDefs.begin(), funDefs.end(),
                          [&](auto e) { return v->TraverseStatement(e); });
  }

private:
  Program(AST ast) : AST(std::move(ast)) {}
};

// TODO remove
extern AST prog;

#endif // PROGRAM_H
