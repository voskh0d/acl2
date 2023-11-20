#include "program.h"

#include "astdumper.h"

#include "parser/ast/functions.h"
#include "parser/ast/types.h"

#include "parser/parser.h"

#include "process/assertion.h"
#include "process/forconstraints.h"
#include "process/racconstraint.h"
#include "process/returnfalse.h"
#include "process/typing.h"

#include <algorithm>

Program::Program() {
  typeDefs.reserve(256);
  constDecs.reserve(256);
  templates.reserve(256);
  funDefs.reserve(256);
}

bool Program::registerType(DefinedType *t) {
  if (getType(t->getname()))
    return false;
  typeDefs.push_back(t);
  return true;
}

DefinedType *Program::getType(const std::string &name) {
  auto it = std::find_if(typeDefs.begin(), typeDefs.end(),
                         [&](DefinedType *t) { return name == t->getname(); });
  return it == typeDefs.end() ? nullptr : *it;
}

void Program::registerConstDec(ConstDec *d) { constDecs.push_back(d); }

ConstDec *Program::getConstDec(const std::string &name) {
  auto it = std::find_if(constDecs.begin(), constDecs.end(),
                         [&](ConstDec *d) { return name == d->getname(); });
  return it == constDecs.end() ? nullptr : *it;
}

void Program::registerTemplate(Template *t) { templates.push_back(t); }

Template *Program::getTemplate(const std::string &name) {
  auto it = std::find_if(templates.begin(), templates.end(),
                         [&](Template *t) { return name == t->getname(); });
  return it == templates.end() ? nullptr : *it;
}

void Program::registerFunDef(FunDef *f) { funDefs.push_back(f); }

FunDef *Program::getFunDef(const std::string &name) {
  auto it = std::find_if(funDefs.begin(), funDefs.end(),
                         [&](FunDef *t) { return name == t->getname(); });
  return it == funDefs.end() ? nullptr : *it;
}

bool Program::parse(const std::string &file) {

  yyin = fopen(file.c_str(), "r");
  diag_.setup(yyin);

  if (yyin == nullptr) {
    std::cerr << "Failed to open file " << file << ": " << strerror(errno)
              << '\n';
    return false;
  }

  yylineno = 1;
  yylloc = Location::from_file(file);
  if (yyparse())
    return false;

  if (isEmpty())
    puts("Warning: no function definitions found,"
         " maybe you forgot the `// RAC begin` guard");

  return true;
}

bool Program::process() {

#define RUNPASS(ACTION)                                                       \
  {                                                                           \
    ACTION a(diag_);                                                          \
    if (!runAction(&a) && !bypass_errors()) {                                 \
      return false;                                                           \
    }                                                                         \
  }

  RUNPASS(TypingAction);
  RUNPASS(RACConstraint);
  RUNPASS(ForConstraints);
  RUNPASS(MarkAssertionAction);

  return true;
}

void Program::dumpAsDot() const {
  ASTDumperAction a;
  prog.runAction(&a);
}

void Program::displayTypeDefs(std::ostream &os, DispMode mode) const {
  // Note that type definitions are used in generating S-expressions for
  // constant declarations and function definitions, but are not represented
  // explicitly in the ACL2 translation.
  if (mode == DispMode::rac)
    std::for_each(typeDefs.begin(), typeDefs.end(),
                  [&os](auto v) { v->displayDef(os); });
}

void Program::displayConstDecs(std::ostream &os, DispMode mode) const {
  if (mode == DispMode::rac)
    std::for_each(constDecs.begin(), constDecs.end(),
                  [&os](auto v) { v->display(os); });
  else
    std::for_each(constDecs.begin(), constDecs.end(),
                  [&os](auto v) { v->ACL2Expr()->display(os); });
}

// Why this one is not defined
//  void displayTemplates(ostream& os, DispMode mode, const char *prefix="");

void Program::displayFunDefs(std::ostream &os, DispMode mode) const {
  if (mode == DispMode::rac)
    std::for_each(funDefs.begin(), funDefs.end(),
                  [&os](auto v) { v->display(os); });
  else
    std::for_each(funDefs.begin(), funDefs.end(),
                  [&os](auto v) { v->displayACL2Expr(os); });
}

void Program::display(std::ostream &os, DispMode mode) const {
  displayTypeDefs(os, mode);
  os << "\n";
  displayConstDecs(os, mode);
  os << "\n";
  displayFunDefs(os, mode);
  os << "\n";
}

bool Program::isEmpty() const { return funDefs.empty(); }
