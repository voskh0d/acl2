#ifndef STATEMENTS_H
#define STATEMENTS_H

#include "expressions.h"
#include "types.h"
#include "utils.h"
#include "sexpressions.h"


//***********************************************************************************
// Statements
//***********************************************************************************

class Block;
class FunCall;
class TempCall;

class Statement
{
public:
  Statement(NodesId id) : id_(id) {}

  virtual void display (std::ostream &os, unsigned indent = 0) = 0;
  virtual void displayAsRightBranch (std::ostream &os, unsigned indent = 0);
  virtual void displayWithinBlock (std::ostream &os, unsigned indent = 0);
  virtual Block *blockify ();
  virtual Block *blockify (Statement *s);
  virtual Sexpression *ACL2Expr () = 0;

  inline NodesId id() const { return id_; }

private:
  const NodesId id_;
};

class SimpleStatement : public Statement
{
public:
  SimpleStatement (NodesId id) : Statement(id) {}
  void display (std::ostream &os, unsigned indent = 0) override;
  virtual void displaySimple (std::ostream &os) = 0;
};

class SymDec : public SimpleStatement
{
public:
  Symbol *sym;
  const Type *type;
  Expression *init;
  SymDec (const char *n, Type *t, Expression *i = nullptr);
  SymDec (NodesId id, const char *n, Type *t, Expression *i = nullptr);

  const char *
  getname () const
  {
    return sym->getname ();
  }
  void displaySymDec (std::ostream &os) const;
  virtual bool isGlobal ();
  virtual bool isROM ();
  virtual bool isConst ();
  virtual int evalConst ();
  virtual Sexpression *ACL2SymExpr ();
};

class EnumConstDec final : public SymDec
{
public:
  EnumConstDec (const char *n, Expression *v = nullptr);
  void display (std::ostream &os) const;
  void displaySimple(std::ostream &os) override { display(os); }
  bool isConst ();
  // ACL2expr Weird
  Sexpression *ACL2Expr ();
  Sexpression *ACL2SymExpr ();
};

class VarDec : public SymDec
{
public:
  VarDec (const char *n, Type *t, Expression *i = nullptr);
  VarDec (NodesId id, const char *n, Type *t, Expression *i = nullptr);
  void displaySimple (std::ostream &os) override;
  Sexpression *ACL2Expr () override;
  Sexpression *ACL2SymExpr () override;
};

class ConstDec : public VarDec
{
public:
  ConstDec (const char *n, Type *t, Expression *i);
  void displaySimple (std::ostream &os) override;
  bool isConst () override;
  bool isGlobal () override;
  bool isROM () override;
  Sexpression *ACL2SymExpr () override;
};

class MulConstDec : public SimpleStatement {
public:
  List<ConstDec> *decs;
  MulConstDec (ConstDec *dec1, ConstDec *dec2);
  MulConstDec (List<ConstDec> *decs);
  Sexpression *ACL2Expr () override;
  void displaySimple (std::ostream &os) override;
};

class MulVarDec : public SimpleStatement
{
public:
  List<VarDec> *decs;
  MulVarDec (VarDec *dec1, VarDec *dec2);
  MulVarDec (List<VarDec> *decs);
  Sexpression *ACL2Expr () override;
  void displaySimple (std::ostream &os) override;
};

class TempParamDec final : public SymDec
{
public:
  TempParamDec (const char *n, Type *t);
  bool isConst () override;
  Sexpression *ACL2SymExpr () override;

  // TODO
  void display(std::ostream &, unsigned) {};
  void displaySimple(std::ostream &) override {};
  Sexpression *ACL2Expr () override {
    assert(false);
    return nullptr;
  }
};

class BreakStmt final : public SimpleStatement
{
public:
  BreakStmt ();
  void displaySimple (std::ostream &os) override;
  Sexpression *ACL2Expr () override;
};

class ReturnStmt final : public SimpleStatement
{
public:
  Expression *value;
  const Type *returnType;
  ReturnStmt (Expression *v);
  void displaySimple (std::ostream &os) override;
  Sexpression *ACL2Expr () override;
};

class NullStmt final : public SimpleStatement
{
public:
  NullStmt ();
  void displaySimple (std::ostream &os) override;
  Sexpression *ACL2Expr () override;
};

class Assertion final : public SimpleStatement
{
public:
  Expression *expr;
  FunDef *funDef;
  Assertion (Expression *e);
  void displaySimple (std::ostream &os) override;
  Sexpression *ACL2Expr () override;
};

class Assignment final : public SimpleStatement
{
public:
  Expression *lval;
  const char *op;
  Expression *rval;
  Expression *index = nullptr;

  Assignment (Expression *l, const char *o, Expression *r);
  // set_slc
  Assignment (Expression *l, Expression *r, Expression *i)
    : SimpleStatement (idOf(this))
    , lval(l)
    , op("set_slc")
    , rval(r)
    , index(i)
  {}

  void displaySimple (std::ostream &os) override;
  Sexpression *ACL2Expr () override;
};

class MultipleAssignment : public SimpleStatement
{
  std::vector<Expression *> lval_;
  FunCall *rval_;

public:
  MultipleAssignment (FunCall *r, std::vector<Expression *> e);
  void displaySimple (std::ostream &os) override;
  Sexpression *ACL2Expr () override;

  const std::vector<Expression *>& lvals() const { return lval_; }
  FunCall *rval() { return rval_; }
};

class Block final : public Statement
{
public:
  List<Statement> *stmtList;
  Block (List<Statement> *s);
  Block (Statement *s);
  Block (Statement *s1, Statement *s2);
  Block (Statement *s1, Statement *s2, Statement *s3);
  Block *blockify () override;
  Block *blockify (Statement *s) override;
  void display (std::ostream &os, unsigned indent = 0) override;
  void displayWithinBlock (std::ostream &os, unsigned indent = 0) override;
  Sexpression *ACL2Expr () override;
};

class IfStmt final : public Statement
{
public:
  Expression *test;
  Statement *left;
  Statement *right;
  IfStmt (Expression *t, Statement *l, Statement *r);
  void display (std::ostream &os, unsigned indent = 0) override;
  void displayAsRightBranch (std::ostream &os, unsigned indent = 0) override;
  Sexpression *ACL2Expr () override;
};

class ForStmt final : public Statement
{
public:
  SimpleStatement *init;
  Expression *test;
  Assignment *update;
  Statement *body;
  ForStmt (SimpleStatement *v, Expression *t, Assignment *u, Statement *b);
  void display (std::ostream &os, unsigned indent = 0) override;
  Sexpression *ACL2Expr () override;
};

class Case final : public Statement
{
public:
  Expression *label;
  List<Statement> *action;
  Case (Expression *l, List<Statement> *a);
  void display (std::ostream &os, unsigned indent = 0);

  Sexpression *ACL2Expr () override { assert(!"TODO"); }

  // TODO move this to the type pass.
  void typeCheck() const {

    if (!label) {
      return;
    }

    const Type *t = label->get_type();
    // If it is an enum, t will always be non null.
    if ((t == nullptr || !isa<const EnumType *>(t)) && !isa<Constant *>(label))
      assert(!"case label must be an integer or an enum constant");
  }
};

class SwitchStmt : public Statement
{
  Expression *test_;
  BetterList<Case> cases_;

public:
  SwitchStmt (Expression *t, List<Case> *c);
  void display (std::ostream &os, unsigned indent = 0) override;
  Sexpression *ACL2Expr () override;

  Expression *test() { return test_; }
  BetterList<Case> cases() { return cases_; }
};

#endif // STATEMENTS_H
