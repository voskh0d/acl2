#ifndef EXPRESSIONS_H
#define EXPRESSIONS_H

#include "nodesid.h"
#include "sexpressions.h"
#include "types.h"
#include "utils.h"

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

class Expression {
public:
  Expression(NodesId id) : id_(id){};

  virtual bool isConst();
  virtual int evalConst();

  virtual bool isInteger();

  const Type *get_type() { return t_; }

  virtual void display(std::ostream &os) const = 0;

  // The following method converts an expression to an S-expression.  The
  // argument isBV is relevant only for a typed expression of a register type
  // In this case, if isBV is true, then the resulting S-expression should
  // represent the value of the bit vector contents of the register, and
  // otherwise it should represent the value of that bit vector as interpreted
  // according to the type. The argument isBV is set the following cases:
  //
  // (1) The expression is being assigned to a register of the same type;
  //
  // (2) The expression is being assigned to an integer register and the
  // expression is an unsigned integer register of width not exceeding that of
  // the target;
  //
  // (3) The resulting S-expression is to be the first argument of bitn, bits,
  // setbitn, or setbits. (4) The expression is an argument of a logical
  // expression of a register type.
  virtual Sexpression *ACL2Expr(bool isBV = false) = 0;
  virtual Sexpression *ACL2ArrayExpr();
  virtual Sexpression *ACL2Assign(Sexpression *rval);

  unsigned ACL2ValWidth();

  inline NodesId id() const { return id_; }

  // Only during the type passs we are allowed to modify the type.
  void set_type(const Type *t) { t_ = t; }

private:
  // The type of the expression. Null means not yet typed, but after the type
  // pass, it should be always set with a concrete type (not a typedef).
  const Type *t_ = nullptr;

protected:
  const NodesId id_;
};

class Constant : public Expression, public Symbol {
public:
  Constant(NodesId id, const char *n);
  Constant(NodesId id, int n);
  bool isConst() override;
  bool isInteger() override { return true; }
  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
};

class Integer final : public Constant {
  // type: primType
public:
  Integer(const char *n);
  Integer(int n);
  int evalConst() override;
  Sexpression *ACL2Expr(bool isBV) override;
};

extern Integer i_0;
extern Integer i_1;
extern Integer i_2;

class Boolean final : public Constant {
  // PrimType (boolType)
public:
  Boolean(const char *n);
  int evalConst() override;
  Sexpression *ACL2Expr(bool isBV = false) override;
};

class Parenthesis final : public Expression {
public:
  Expression *expr_;

  Parenthesis(Expression *e) : Expression(idOf(this)), expr_(e) { assert(e); }

  bool isConst() override { return expr_->isConst(); }
  int evalConst() override { return expr_->evalConst(); }
  bool isInteger() override { return expr_->isInteger(); }

  // TODO rename
  void display(std::ostream &os) const override {
    os << '(';
    expr_->display(os);
    os << ')';
  }

  virtual Sexpression *ACL2Expr(bool isBV = false) override {
    return expr_->ACL2Expr(isBV);
  }
  virtual Sexpression *ACL2ArrayExpr() override { return expr_->ACL2ArrayExpr(); }
  virtual Sexpression *ACL2Assign(Sexpression *rval) override {
    return expr_->ACL2Assign(rval);
  }
};

extern Boolean b_true;
extern Boolean b_false;

class SymRef final : public Expression {
public:
  SymDec *symDec;

  SymRef(SymDec *s);
  virtual bool isConst() override;
  virtual int evalConst() override;
  bool isInteger() override;
  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
  Sexpression *ACL2Assign(Sexpression *rval) override;
};

class FunDef;

class FunCall : public Expression {
  // type: rtype
public:
  FunDef *func;
  List<Expression> *args;
  FunCall(FunDef *f, List<Expression> *a);
  FunCall(NodesId id, FunDef *f, List<Expression> *a);

  bool isInteger() override;
  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
};

class Template;

class TempCall final : public FunCall {
public:
  Symbol *instanceSym;
  List<Expression> *params;
  TempCall(Template *f, List<Expression> *a, List<Expression> *p);
  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
};

class Initializer final : public Expression {
public:
  List<Constant> *vals;
  Initializer(List<Constant> *v);
  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
  Sexpression *ACL2ArrayExpr() override;

  Sexpression *ACL2StructExpr(const std::vector<StructField *> &fields);
};

class ArrayRef final : public Expression {
public:
  Expression *array;
  Expression *index;
  ArrayRef(Expression *a, Expression *i);

  bool isInteger() override;
  void display(std::ostream &os) const override;

  Sexpression *ACL2Expr(bool isBV = false) override;
  Sexpression *ACL2Assign(Sexpression *rval) override;
};

class StructRef final : public Expression {
public:
  Expression *base;
  char *field;
  StructRef(Expression *s, char *f);
  bool isInteger() override;
  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
  Sexpression *ACL2Assign(Sexpression *rval) override;
};

class BitRef final : public Expression {
public:
  Expression *base;
  Expression *index;
  BitRef(Expression *b, Expression *i);

  bool isInteger() override;
  void display(std::ostream &os) const override;

  Sexpression *ACL2Expr(bool isBV = false) override;
  Sexpression *ACL2Assign(Sexpression *rval) override;
};

class Subrange final : public Expression {
public:
  Expression *base;
  Expression *high;
  Expression *low;

  unsigned width() { return width_; }

  Subrange(Expression *b, Expression *l, unsigned w);

  bool isInteger() override { return true; }
  void display(std::ostream &os) const override;

  Sexpression *ACL2Expr(bool isBV = false) override;
  Sexpression *ACL2Assign(Sexpression *rval) override;

private:
  unsigned width_;
};

class PrefixExpr final : public Expression {
public:
  Expression *expr;
  const char *op;
  PrefixExpr(Expression *e, const char *o);
  bool isConst() override;
  int evalConst() override;
  bool isInteger() override;
  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
};

class CastExpr final : public Expression {
public:
  Expression *expr;
  Type *type;
  CastExpr(Expression *e, Type *t);
  bool isConst() override;
  int evalConst() override;
  bool isInteger() override;
  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
};

class BinaryExpr final : public Expression {
public:
  enum class Op {
#define APPLY_BINARY_OP(NAME, _) NAME,
#define APPLY_ASSIGN_OP(_, __)
#define APPLY_UNARY_OP(_, __)
#include "operators.def"
#undef APPLY_BINARY_OP
  };

  Expression *expr1;
  Expression *expr2;
  Op op;

  BinaryExpr(Expression *e1, Expression *e2, const char *o);
  bool isConst() override;
  int evalConst() override;
  bool isInteger() override;
  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;

private:
  static Op parseOp(const char *o);
};

std::ostream &operator<<(std::ostream &os, BinaryExpr::Op op);

class CondExpr final : public Expression {
public:
  Expression *expr1;
  Expression *expr2;
  Expression *test;
  CondExpr(Expression *e1, Expression *e2, Expression *t);
  bool isInteger() override;
  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
};

class MultipleValue final : public Expression {
public:
  MvType *type;
  std::vector<Expression *> expr;

  MultipleValue(MvType *t, std::vector<Expression *> &&e)
      : Expression(idOf(this)), type(t), expr(e) {}
  MultipleValue(MvType *t, List<Expression> *e);

  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
};

#endif // EXPRESSIONS_H
