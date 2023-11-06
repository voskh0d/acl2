#ifndef STATEMENTS_H
#define STATEMENTS_H

#include "diagnostics.h"
#include "expressions.h"
#include "sexpressions.h"
#include "types.h"
#include "utils.h"

//***********************************************************************************
// Statements
//***********************************************************************************

class Block;
class FunCall;

class Statement {
public:
  Statement(NodesId id, Location loc) : id_(id), loc_(loc) {}

  virtual void display(std::ostream &os, unsigned indent = 0) = 0;
  virtual void displayAsRightBranch(std::ostream &os, unsigned indent = 0);
  virtual void displayWithinBlock(std::ostream &os, unsigned indent = 0);
  virtual Block *blockify();
  virtual Block *blockify(Statement *s);
  virtual Sexpression *ACL2Expr() = 0;

  inline NodesId id() const { return id_; }
  inline const Location &loc() const { return loc_; }

private:
  const NodesId id_;

protected:
  Location loc_;
};

class SimpleStatement : public Statement {
public:
  SimpleStatement(NodesId id, Location loc) : Statement(id, loc) {}
  void display(std::ostream &os, unsigned indent = 0) override;
  virtual void displaySimple(std::ostream &os) = 0;
};

class SymDec : public SimpleStatement {
public:
  Symbol *sym;
  const Type *type;
  Expression *init;
  SymDec(Location loc, const char *n, Type *t, Expression *i = nullptr);
  SymDec(NodesId id, Location loc, const char *n, Type *t,
         Expression *i = nullptr);

  const char *getname() const { return sym->getname(); }
  virtual void displaySymDec(std::ostream &os) const;
  virtual bool isGlobal();
  virtual bool isROM();
  virtual bool isConst();
  virtual int evalConst();
  virtual Sexpression *ACL2SymExpr();
};

class EnumConstDec final : public SymDec {
public:
  EnumConstDec(Location loc, const char *n, Expression *v = nullptr);
  // TODO indent.
  void display(std::ostream &os, unsigned) override;
  void displaySimple(std::ostream &os) override { display(os, 0); }
  bool isConst() override;
  // ACL2expr Weird
  Sexpression *ACL2Expr() override;
  Sexpression *ACL2SymExpr() override;
};

class VarDec : public SymDec {
public:
  VarDec(Location loc, const char *n, Type *t, Expression *i = nullptr);
  VarDec(NodesId id, Location loc, const char *n, Type *t,
         Expression *i = nullptr);
  void displaySimple(std::ostream &os) override;
  Sexpression *ACL2Expr() override;
  Sexpression *ACL2SymExpr() override;
};

class ConstDec : public VarDec {
public:
  ConstDec(Location loc, const char *n, Type *t, Expression *i);
  void displaySimple(std::ostream &os) override;
  bool isConst() override;
  bool isGlobal() override;
  bool isROM() override;
  Sexpression *ACL2SymExpr() override;
};

class MulConstDec : public SimpleStatement {
public:
  List<ConstDec> *decs;
  MulConstDec(Location loc, ConstDec *dec1, ConstDec *dec2);
  MulConstDec(Location loc, List<ConstDec> *decs);
  Sexpression *ACL2Expr() override;
  void displaySimple(std::ostream &os) override;
};

class MulVarDec : public SimpleStatement {
public:
  List<VarDec> *decs;
  MulVarDec(Location loc, VarDec *dec1, VarDec *dec2);
  MulVarDec(Location loc, List<VarDec> *decs);
  Sexpression *ACL2Expr() override;
  void displaySimple(std::ostream &os) override;
};

class TempParamDec final : public SymDec {
public:
  TempParamDec(Location loc, const char *n, Type *t);
  bool isConst() override;
  Sexpression *ACL2SymExpr() override;

  // TODO
  void display(std::ostream &, unsigned) override{};
  void displaySimple(std::ostream &) override{};
  Sexpression *ACL2Expr() override {
    assert(false);
    return nullptr;
  }
};

class BreakStmt final : public SimpleStatement {
public:
  BreakStmt(Location loc);
  void displaySimple(std::ostream &os) override;
  Sexpression *ACL2Expr() override;
};

class ReturnStmt final : public SimpleStatement {
public:
  Expression *value;
  const Type *returnType;
  ReturnStmt(Location loc, Expression *v);
  void displaySimple(std::ostream &os) override;
  Sexpression *ACL2Expr() override;
};

class NullStmt final : public SimpleStatement {
public:
  NullStmt(Location loc);
  void displaySimple(std::ostream &os) override;
  Sexpression *ACL2Expr() override;
};

class Assertion final : public SimpleStatement {
public:
  Expression *expr;
  FunDef *funDef;
  Assertion(Location loc, Expression *e);
  void displaySimple(std::ostream &os) override;
  Sexpression *ACL2Expr() override;
};

class Assignment final : public SimpleStatement {
public:
  Expression *lval;
  const char *op;
  Expression *rval;
  Expression *index = nullptr;

  Assignment(Location loc, Expression *l, const char *o, Expression *r);
  // set_slc
  Assignment(Location loc, Expression *l, Expression *r, Expression *i)
      : SimpleStatement(idOf(this), loc), lval(l), op("set_slc"), rval(r),
        index(i) {}

  void displaySimple(std::ostream &os) override;
  Sexpression *ACL2Expr() override;

  void desugar();
};

class MultipleAssignment : public SimpleStatement {
  std::vector<Expression *> lval_;
  FunCall *rval_;

public:
  MultipleAssignment(Location loc, FunCall *r, std::vector<Expression *> e);
  void displaySimple(std::ostream &os) override;
  Sexpression *ACL2Expr() override;

  const std::vector<Expression *> &lvals() const { return lval_; }
  FunCall *rval() { return rval_; }
};

class Block final : public Statement {
public:
  List<Statement> *stmtList;
  Block(Location loc, List<Statement> *s);
  Block(Location loc, Statement *s);
  Block(Location loc, Statement *s1, Statement *s2);
  Block(Location loc, Statement *s1, Statement *s2, Statement *s3);
  Block *blockify() override;
  Block *blockify(Statement *s) override;
  void display(std::ostream &os, unsigned indent = 0) override;
  void displayWithinBlock(std::ostream &os, unsigned indent = 0) override;
  Sexpression *ACL2Expr() override;
};

class IfStmt final : public Statement {
public:
  Expression *test;
  Statement *left;
  Statement *right;
  IfStmt(Location loc, Expression *t, Statement *l, Statement *r);
  void display(std::ostream &os, unsigned indent = 0) override;
  void displayAsRightBranch(std::ostream &os, unsigned indent = 0) override;
  Sexpression *ACL2Expr() override;
};

class ForStmt final : public Statement {
public:
  SimpleStatement *init;
  Expression *test;
  Assignment *update;
  Statement *body;
  ForStmt(Location loc, SimpleStatement *v, Expression *t, Assignment *u,
          Statement *b);
  void display(std::ostream &os, unsigned indent = 0) override;
  Sexpression *ACL2Expr() override;
};

class Case final : public Statement {
public:
  Case(Location loc, Expression *l, List<Statement> *a);
  void display(std::ostream &os, unsigned indent = 0) override;

  bool isDefaultCase() const { return label == nullptr; }
  bool isFallthrough() const { return action == nullptr; }

  Sexpression *ACL2Expr() override { assert(!"TODO"); }

  Expression *label;
  List<Statement> *action;
};

class SwitchStmt : public Statement {
public:
  Expression *test_;
  std::vector<Case *> cases_;

  SwitchStmt(Location loc, Expression *t, std::vector<Case *> c);
  void display(std::ostream &os, unsigned indent = 0) override;
  Sexpression *ACL2Expr() override;

  Expression *test() { return test_; }
  const std::vector<Case *> &cases() { return cases_; }
};

#endif // STATEMENTS_H
