#ifndef EXPRESSIONS_H
#define EXPRESSIONS_H

#include "program.h"
#include "sexpressions.h"
#include "types.h"
#include "utils.h"

#include "visitor.h"
// Used to declare TypePass::set_type as friend to get access to
// Expressions::set_type.
#include "typing.h"


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
  Expression () = default;
  virtual bool isConst ();
  virtual int evalConst ();

  virtual bool isInteger ();

  virtual const Type *exprType ();

  const Type *get_type() { return t_; }

  virtual void display (std::ostream &os) const = 0;

// The following method converts an expression to an S-expression.  The
// argument isBV is relevant only for a typed expression of a register type
// (see exprType above).  In this case, if isBV is true, then the resulting
// S-expression should represent the value of the bit vector contents of the
// register, and otherwise it should represent the value of that bit vector as
// interpreted according to the type. The argument isBV is set the following
// cases: (1) The expression is being assigned to a register of the same type;
// (2) The expression is being assigned to an integer register and the
// expression is an unsigned
//     integer register of width not exceeding that of the target;
// (3) The resulting S-expression is to be the first argument of bitn, bits,
// setbitn, or setbits. (4) The expression is an argument of a logical
// expression of a register type.
  virtual Sexpression *ACL2Expr (bool isBV = false) = 0;
  virtual Sexpression *ACL2ArrayExpr ();
  virtual Sexpression *ACL2Assign (Sexpression *rval);

  unsigned ACL2ValWidth ();

  virtual bool accept(RecursiveASTVisitor *visitor) = 0;

private:
  // Only during the type passs we are allowed to modify the type.
  friend void TypePass::set_type(Expression*, Type *);
  void set_type(Type *t) { t_ = t; }

  // The type of the expression. Null means not yet typed, but after the type
  // pass, it should be always set with a concrete type (not a typedef).
  Type *t_ = nullptr;
};

class Constant : public Expression, public Symbol
{
public:
  Constant (const char *n);
  Constant (int n);
  bool isConst () override;
  bool isInteger () override { return true; }
  void display (std::ostream &os) const override;
  Sexpression *ACL2Expr (bool isBV = false) override;

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

class Parenthesis : public Expression {
public:
  Expression *expr_;
  Parenthesis (Expression *e) : expr_(e) { assert(e); }
  bool isConst () override { return expr_->isConst(); }
  int evalConst () override { return expr_->evalConst(); }
  bool isInteger () override { return expr_->isInteger(); }

  const Type *exprType () override { return expr_->exprType(); }

  // TODO rename
  void display (std::ostream &os) const override {
    os << '(';
    expr_->display(os);
    os << ')';
  }

  virtual Sexpression *ACL2Expr (bool isBV = false) { return expr_->ACL2Expr(isBV);}
  virtual Sexpression *ACL2ArrayExpr () { return expr_->ACL2ArrayExpr(); }
  virtual Sexpression *ACL2Assign (Sexpression *rval) { return expr_->ACL2Assign(rval); }

  unsigned ACL2ValWidth () { return expr_->ACL2ValWidth(); }

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseParenthesis(this);
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
  const Type *exprType () override;
  virtual bool isConst () override;
  virtual int evalConst () override;
  bool isInteger () override;
  void display (std::ostream &os) const override;
  Sexpression *ACL2Expr (bool isBV = false) override;
  Sexpression *ACL2Assign (Sexpression *rval) override;

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

  bool isInteger () override;
  const Type *exprType () override;
  void display (std::ostream &os) const override;
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
  void display (std::ostream &os) const override;
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
  void display (std::ostream &os) const override;
  Sexpression *ACL2Expr (bool isBV = false) override;
  Sexpression *ACL2ArrayExpr () override;

  Sexpression *ACL2StructExpr (const std::vector<StructField *>& fields);

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
  bool isInteger () override;
  const Type *exprType () override;
  void display (std::ostream &os) const override;
  Sexpression *ACL2Expr (bool isBV = false) override;
  Sexpression *ACL2Assign (Sexpression *rval) override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseArrayRef(this);
  }
};

class StructRef final : public Expression
{
public:
  Expression *base;
  char *field;
  StructRef (Expression *s, char *f);
  bool isInteger () override;
  const Type *exprType () override;
  void display (std::ostream &os) const override;
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
  const Type *exprType () override;
  void display (std::ostream &os) const override;
  Sexpression *ACL2Expr (bool isBV = false) override;
  Sexpression *ACL2Assign (Sexpression *rval) override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseBitRef(this);
  }
};

class Subrange final : public Expression
{
public:
  Expression *base;
  Expression *high;
  Expression *low;

  unsigned width() {
    return width_;
  }

  Subrange (Expression *b, Expression *l, unsigned w);

  bool isInteger () override { return true; }
  void display (std::ostream &os) const override;

  const Type *exprType () override;
  Sexpression *ACL2Expr (bool isBV = false) override;
  Sexpression *ACL2Assign (Sexpression *rval) override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseSubrange(this);
  }

private:
  unsigned width_;
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
  void display (std::ostream &os) const override;
  const Type *exprType () override;
  Sexpression *ACL2Expr (bool isBV = false) override;

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
  void display (std::ostream &os) const override;
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
  void display (std::ostream &os) const override;
  const Type *exprType () override;
  Sexpression *ACL2Expr (bool isBV = false) override;

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
  void display (std::ostream &os) const override;
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

  void display (std::ostream &os) const override;
  Sexpression *ACL2Expr (bool isBV = false) override;

  bool accept(RecursiveASTVisitor *visitor) override {
    return visitor->TraverseMultipleValue(this);
  }
};

#endif // EXPRESSIONS_H
