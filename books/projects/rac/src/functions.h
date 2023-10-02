#ifndef FUNCTIONS_H
#define FUNCTIONS_H

#include "sexpressions.h"
#include "statements.h"
#include "utils.h"

#include <iomanip>

//***********************************************************************************
// Functions
//***********************************************************************************

class FunDef : public Statement {
protected:
  Symbol *sym;

public:
  Type *returnType;
  List<VarDec> *params;
  Block *body;

  FunDef(Location loc, const char *n, Type *t, List<VarDec> *p, Block *b);
  FunDef(NodesId id, Location loc, const char *n, Type *t, List<VarDec> *p,
         Block *b);

  const char *getname() const { return sym->getname(); }

  void displayDec(std::ostream &os, const char *prefix = "",
                  unsigned indent = 0);

  void display(std::ostream &, unsigned) override { assert(!"TODO"); }

  Sexpression *ACL2Expr() override { assert(!"TODO"); }

  virtual void display(std::ostream &os, const char *prefix = "",
                       unsigned indent = 0);
  virtual void displayACL2Expr(std::ostream &os);

private:
  void displayPrototype(std::ostream &os, const char *prefix, unsigned indent);
};

class Builtin final : public FunDef {
public:
  Builtin(Location loc, const char *n, Type *t, List<VarDec> *p)
      : FunDef(idOf(this), loc, n, t, p, nullptr) {}
};

class Template final : public FunDef {
public:
  List<TempParamDec> *tempParams;
  std::vector<TempCall *> calls;

  Template(Location loc, const char *n, Type *t, List<VarDec> *p, Block *b,
           List<TempParamDec> *tp);
  void display(std::ostream &os, const char *prefix = "",
               unsigned indent = 0) override;
  void bindParams(List<Expression> *a);
  void displayACL2Expr(std::ostream &os) override;
};

#endif // FUNCTIONS_H
