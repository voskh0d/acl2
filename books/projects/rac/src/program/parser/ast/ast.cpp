#include "ast.h"

#include "expressions.h"
#include "functions.h"
#include "statements.h"
#include "types.h"

#include "../parser.h"

AST::AST() {
  typeDefs.reserve(256);
  constDecs.reserve(256);
  templates.reserve(256);
  funDefs.reserve(256);
}

AST::AST(AST &&other)
    : typeDefs(std::move(other.typeDefs)),
      constDecs(std::move(other.constDecs)),
      templates(std::move(other.templates)), funDefs(std::move(other.funDefs)),
      diag_(std::move(other.diag_)) {}

bool AST::registerType(DefinedType *t) {
  if (getType(t->getname()))
    return false;
  typeDefs.push_back(t);
  return true;
}

DefinedType *AST::getType(const std::string &name) {
  auto it = std::find_if(typeDefs.begin(), typeDefs.end(),
                         [&](DefinedType *t) { return name == t->getname(); });
  return it == typeDefs.end() ? nullptr : *it;
}

void AST::registerConstDec(ConstDec *d) { constDecs.push_back(d); }

ConstDec *AST::getConstDec(const std::string &name) {
  auto it = std::find_if(constDecs.begin(), constDecs.end(),
                         [&](ConstDec *d) { return name == d->getname(); });
  return it == constDecs.end() ? nullptr : *it;
}

void AST::registerTemplate(Template *t) { templates.push_back(t); }

Template *AST::getTemplate(const std::string &name) {
  auto it = std::find_if(templates.begin(), templates.end(),
                         [&](Template *t) { return name == t->getname(); });
  return it == templates.end() ? nullptr : *it;
}

void AST::registerFunDef(FunDef *f) { funDefs.push_back(f); }

FunDef *AST::getFunDef(const std::string &name) {
  auto it = std::find_if(funDefs.begin(), funDefs.end(),
                         [&](FunDef *t) { return name == t->getname(); });
  return it == funDefs.end() ? nullptr : *it;
}

std::optional<AST> AST::parse(const std::string &file) {

  yyin = fopen(file.c_str(), "r");

  yyast.diag_.setup(yyin);

  if (yyin == nullptr) {
    std::cerr << "Failed to open file " << file << ": " << strerror(errno)
              << '\n';
    return {};
  }

  yylineno = 1;
  yylloc = Location::from_file(file);
  if (yyparse())
    return {};

  if (yyast.isEmpty())
    puts("Warning: no function definitions found,"
         " maybe you forgot the `// RAC begin` guard");

  return { std::move(yyast) };
}

bool AST::isEmpty() const { return funDefs.size() == 0; }
