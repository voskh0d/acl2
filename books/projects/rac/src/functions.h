#ifndef FUNCTIONS_H
#define FUNCTIONS_H

#include "statements.h"
#include "utils.h"

#include <iomanip>

using namespace std;

//***********************************************************************************
// Functions
//***********************************************************************************

// Same why not is hierarchy
class FunDef : public Statement
{
protected:
  Symbol *sym;

public:
  Type *returnType;
  List<VarDec> *params;
  Block *body;

  FunDef (const char *n, Type *t, List<VarDec> *p, Block *b);

  const char *
  getname () const
  {
    return sym->getname ();
  }

  void displayDec (ostream &os, const char *prefix = "", unsigned indent = 0);

  void display (ostream &, unsigned) override {
    assert(!"TODO");
  }

  Sexpression *ACL2Expr () {
    assert(!"TODO");
  }

  virtual void display (ostream &os, const char *prefix = "",
                        unsigned indent = 0);
  virtual void displayACL2Expr (ostream &os);

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseFunDef(this);
  }

private:
  void displayPrototype (ostream &os, const char *prefix, unsigned indent);
};

class Builtin final : public FunDef
{
public:
  Builtin (const char *n, Type *t, List<VarDec> *p)
    : FunDef(n, t, p, nullptr)
  {
  }

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseBuiltin(this);
  }
};

class Template final : public FunDef
{
public:
  List<TempParamDec> *tempParams;
  List<TempCall> *calls;
  Template (const char *n, Type *t, List<VarDec> *p, Block *b,
            List<TempParamDec> *tp);
  void display (ostream &os, const char *prefix = "",
                unsigned indent = 0) override;
  void bindParams (List<Expression> *a);
  void displayACL2Expr (ostream &os) override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseTemplate(this);
  }
};

#endif // FUNCTIONS_H
