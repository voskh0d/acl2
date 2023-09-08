#ifndef EXPRESSIONS_H
#define EXPRESSIONS_H

#include "parser.h"
#include "types.h"
#include "utils.h"
#include "visitor.h"

using namespace std;

//***********************************************************************************
// Expressions
//***********************************************************************************

class Statement;
class SymRef;
class SymDec;
class Constant;
class Type;
class StructField;
class MvType;

class Expression
{
public:
  bool needsParens;
  Expression ();
  virtual bool isConst ();
  virtual int evalConst ();
  virtual bool isArray ();
  virtual bool isStruct ();
  virtual bool isSubrange() { return false; }
  bool isNumber ();
  virtual bool isSymRef ();
  virtual bool isInteger ();
  virtual bool isInitializer ();
  bool isFP ();

  virtual const Type *exprType ();
  void display (ostream &os) const;
  virtual void displayNoParens (ostream &os) const = 0;

  virtual Expression *subst (SymRef *var, Expression *val);
  virtual Sexpression *ACL2Expr (bool isBV = false);
  virtual Sexpression *ACL2ArrayExpr ();
  virtual Sexpression *ACL2Assign (Sexpression *rval);
  virtual unsigned ACL2ValWidth ();

  virtual bool isEqual (Expression *e);
  virtual bool isEqualPrefix (const char *o, Expression *e);
  virtual bool isEqualBinary (const char *o, Expression *e1, Expression *e2);

  virtual bool isPlusConst (Expression *e);
  virtual int getPlusConst ();

  virtual bool isEqualSymRef (SymDec *s);
  virtual bool isEqualConst (Constant *c);

  virtual bool accept(RecursiveASTVisitor *visitor) = 0;
};

class Constant : public Expression, public Symbol
{
public:
  Constant (const char *n);
  Constant (int n);
  bool isConst () override;
  bool
  isInteger () override
  {
    return true;
  }
  void displayNoParens (ostream &os) const override;
  Sexpression *ACL2Expr (bool isBV = false) override;
  bool isEqual (Expression *e) override;
  bool isEqualConst (Constant *c) override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseConstant(this);
  }
};

class Integer final : public Constant
{
  // type: primType
public:
  Integer (const char *n);
  Integer (int n);
  int evalConst ();
  Sexpression *ACL2Expr (bool isBV);

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseInteger(this);
  }
};

extern Integer i_0;
extern Integer i_1;
extern Integer i_2;

class Boolean final : public Constant
{
  // PrimType (boolType)
public:
  Boolean (const char *n);
  int evalConst () override;
  Sexpression *ACL2Expr (bool isBV = false) override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseBoolean(this);
  }
};

extern Boolean b_true;
extern Boolean b_false;

class SymRef : public Expression
{
  // type depends de la dec
public:
  SymDec *symDec;

  SymRef (SymDec *s);
  bool isSymRef () override;
  const Type *exprType () override;
  virtual bool isConst () override;
  virtual int evalConst () override;
  bool isArray () override;
  bool isStruct () override;
  bool isInteger () override;
  void displayNoParens (ostream &os) const override;
  Expression *subst (SymRef *var, Expression *val) override;
  Sexpression *ACL2Expr (bool isBV = false) override;
  Sexpression *ACL2Assign (Sexpression *rval) override;
  bool isEqual (Expression *e) override;
  bool isEqualSymRef (SymDec *s) override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseSymRef(this);
  }
};

class FunDef;

class FunCall : public Expression
{
  // type: rtype
public:
  FunDef *func;
  List<Expression> *args;
  FunCall (FunDef *f, List<Expression> *a);

  bool isArray () override;
  bool isStruct () override;
  bool isInteger () override;
  const Type *exprType () override;
  void displayNoParens (ostream &os) const override;
  Expression *subst (SymRef *var, Expression *val) override;
  Sexpression *ACL2Expr (bool isBV = false) override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseFunCall(this);
  }
};

class Template;

class TempCall final : public FunCall
{
public:
  Symbol *instanceSym;
  List<Expression> *params;
  TempCall (Template *f, List<Expression> *a, List<Expression> *p);
  void displayNoParens (ostream &os) const override;
  Expression *subst (SymRef *var, Expression *val) override;
  Sexpression *ACL2Expr (bool isBV = false) override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseTempCall(this);
  }
};

class Initializer final : public Expression
{
public:
  List<Constant> *vals;
  Initializer (List<Constant> *v);
  bool isInitializer () override;
  void displayNoParens (ostream &os) const override;
  Sexpression *ACL2Expr (bool isBV = false) override;
  Sexpression *ACL2ArrayExpr () override;
  Sexpression *ACL2StructExpr (List<StructField> *fields);

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseInitializer(this);
  }
};

class ArrayRef : public Expression
{
public:
  Expression *array;
  Expression *index;
  ArrayRef (Expression *a, Expression *i);
  bool isArray () override;
  bool isInteger () override;
  const Type *exprType () override;
  void displayNoParens (ostream &os) const override;
  Expression *subst (SymRef *var, Expression *val) override;
  Sexpression *ACL2Expr (bool isBV = false) override;
  Sexpression *ACL2Assign (Sexpression *rval) override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseArrayRef(this);
  }
};

// TODO is this used anywhere ?
class ArrayParamRef : public ArrayRef
{
public:
  ArrayParamRef (Expression *a, Expression *i);
  void displayNoParens (ostream &os) const override;
  Expression *subst (SymRef *var, Expression *val) override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseArrayParamRef(this);
  }
};

class StructRef final : public Expression
{
public:
  Expression *base;
  char *field;
  StructRef (Expression *s, char *f);
  bool isArray () override;
  bool isInteger () override;
  const Type *exprType () override;
  void displayNoParens (ostream &os) const override;
  Sexpression *ACL2Expr (bool isBV = false) override;
  Sexpression *ACL2Assign (Sexpression *rval) override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseStructRef(this);
  }
};

class BitRef final : public Expression
{
public:
  Expression *base;
  Expression *index;
  BitRef (Expression *b, Expression *i);
  bool isInteger () override;
  void displayNoParens (ostream &os) const override;
  Expression *subst (SymRef *var, Expression *val) override;
  Sexpression *ACL2Expr (bool isBV = false) override;
  Sexpression *ACL2Assign (Sexpression *rval) override;
  unsigned ACL2ValWidth () override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseBitRef(this);
  }
};

class Subrange final : public Expression
{
  // RegType
public:
  Expression *base;
  Expression *high;
  Expression *low;
  unsigned width;
  Subrange (Expression *b, Expression *h, Expression *l);
  Subrange (Expression *b, Expression *h, Expression *l, unsigned w);

  bool isSubrange() override { return true; }
  bool isInteger () override { return true; }
  void displayNoParens (ostream &os) const override;
  Expression *subst (SymRef *var, Expression *val) override;

  const Type *exprType () override;
  Sexpression *ACL2Expr (bool isBV = false) override;
  Sexpression *ACL2Assign (Sexpression *rval) override;
  unsigned ACL2ValWidth () override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseSubrange(this);
  }
};

class PrefixExpr final : public Expression
{
public:
  Expression *expr;
  const char *op;
  PrefixExpr (Expression *e, const char *o);
  bool isConst () override;
  int evalConst () override;
  bool isInteger () override;
  void displayNoParens (ostream &os) const override;
  Expression *subst (SymRef *var, Expression *val) override;
  const Type *exprType () override;
  Sexpression *ACL2Expr (bool isBV = false) override;
  virtual bool isEqual (Expression *e) override;
  virtual bool isEqualPrefix (const char *o, Expression *e) override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraversePrefixExpr(this);
  }
};

class CastExpr : public Expression
{
public:
  Expression *expr;
  Type *type;
  CastExpr (Expression *e, Type *t);
  const Type *exprType () override;
  bool isConst () override;
  int evalConst () override;
  bool isInteger () override;
  void displayNoParens (ostream &os) const override;
  Expression *subst (SymRef *var, Expression *val) override;
  Sexpression *ACL2Expr (bool isBV = false) override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseCastExpr(this);
  }
};

class BinaryExpr : public Expression
{
public:
  Expression *expr1;
  Expression *expr2;
  const char *op;
  BinaryExpr (Expression *e1, Expression *e2, const char *o);
  bool isConst () override;
  int evalConst () override;
  bool isInteger () override;
  void displayNoParens (ostream &os) const override;
  Expression *subst (SymRef *var, Expression *val) override;
  const Type *exprType () override;
  Sexpression *ACL2Expr (bool isBV = false) override;
  virtual bool isEqual (Expression *e) override;
  virtual bool isEqualBinary (const char *o, Expression *e1,
                              Expression *e2) override;
  virtual bool isPlusConst (Expression *e) override;
  virtual int getPlusConst () override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseBinaryExpr(this);
  }
};

class CondExpr : public Expression
{
public:
  Expression *expr1;
  Expression *expr2;
  Expression *test;
  CondExpr (Expression *e1, Expression *e2, Expression *t);
  bool isInteger () override;
  void displayNoParens (ostream &os) const override;
  Expression *subst (SymRef *var, Expression *val) override;
  Sexpression *ACL2Expr (bool isBV = false) override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseCondExpr(this);
  }
};

class MultipleValue : public Expression
{
public:
  MvType *type;
  std::vector<Expression *> expr;

  MultipleValue (MvType *t, std::vector<Expression *> &&e) : type (t), expr (e)
  {
  }
  MultipleValue (MvType *t, List<Expression> *e);

  void displayNoParens (ostream &os) const override;
  Expression *subst (SymRef *var, Expression *val) override;
  Sexpression *ACL2Expr (bool isBV = false) override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseMultipleValue(this);
  }
};

#endif // EXPRESSIONS_H
