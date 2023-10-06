#ifndef EXPRESSIONS_H
#define EXPRESSIONS_H

#include "diagnostics.h"
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
  Expression(NodesId id, Location loc) : id_(id), loc_(loc){};

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
  inline const Location &loc() { return loc_; }

  // Only during the type passs we are allowed to modify the type.
  void set_type(const Type *t) { t_ = t; }

private:
  // The type of the expression. Null means not yet typed, but after the type
  // pass, it should be always set with a concrete type (not a typedef).
  const Type *t_ = nullptr;

protected:
  const NodesId id_;
  const Location loc_;
};

class Constant : public Expression, public Symbol {
public:
  Constant(NodesId id, Location loc, const char *n);
  Constant(NodesId id, Location loc, std::string &&n);
  Constant(NodesId id, Location loc, int n);
  bool isConst() override;
  bool isInteger() override { return true; }
  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
};

// For now, we does not support unsigned literal.
class Integer final : public Constant {
  // type: primType
public:
  Integer(Location loc, const char *n);
  Integer(Location loc, int n);

  // TODO if it is an uint/int64/uint64 this could overflow.
  int evalConst() override;
  Sexpression *ACL2Expr(bool isBV) override;

  static Integer *zero_v(Location loc) { return new Integer(loc, "0"); }
  static Integer *one_v(Location loc) { return new Integer(loc, "1"); }
  static Integer *two_v(Location loc) { return new Integer(loc, "2"); }

  long val_;
};

class Boolean final : public Constant {
  // PrimType (boolType)
public:
  Boolean(Location loc, bool value);
  int evalConst() override;
  Sexpression *ACL2Expr(bool isBV = false) override;

  static Boolean *true_v(Location loc) { return new Boolean(loc, true); }
  static Boolean *false_v(Location loc) { return new Boolean(loc, false); }

private:
  bool value_;
};

class Parenthesis final : public Expression {
public:
  Expression *expr_;

  Parenthesis(Location loc, Expression *e)
      : Expression(idOf(this), loc), expr_(e) {
    assert(e);
  }

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
  virtual Sexpression *ACL2ArrayExpr() override {
    return expr_->ACL2ArrayExpr();
  }
  virtual Sexpression *ACL2Assign(Sexpression *rval) override {
    return expr_->ACL2Assign(rval);
  }
};

class SymRef final : public Expression {
public:
  SymDec *symDec;

  SymRef(Location loc, SymDec *s);
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
  FunCall(Location loc, FunDef *f, List<Expression> *a);
  FunCall(NodesId id, Location loc, FunDef *f, List<Expression> *a);

  bool isInteger() override;
  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
};

class Template;

class TempCall final : public FunCall {
public:
  Symbol *instanceSym;
  List<Expression> *params;
  TempCall(Location loc, Template *f, List<Expression> *a,
           List<Expression> *p);
  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
};

class Initializer final : public Expression {
public:
  List<Constant> *vals;
  Initializer(Location loc, List<Constant> *v);
  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
  Sexpression *ACL2ArrayExpr() override;

  Sexpression *ACL2StructExpr(const std::vector<StructField *> &fields);
};

class ArrayRef final : public Expression {
public:
  Expression *array;
  Expression *index;
  ArrayRef(Location loc, Expression *a, Expression *i);

  bool isInteger() override;
  void display(std::ostream &os) const override;

  Sexpression *ACL2Expr(bool isBV = false) override;
  Sexpression *ACL2Assign(Sexpression *rval) override;
};

class StructRef final : public Expression {
public:
  Expression *base;
  char *field;
  StructRef(Location loc, Expression *s, char *f);
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

  Subrange(Location loc, Expression *b, Expression *l, unsigned w);

  bool isInteger() override { return true; }
  void display(std::ostream &os) const override;

  Sexpression *ACL2Expr(bool isBV = false) override;
  Sexpression *ACL2Assign(Sexpression *rval) override;

private:
  unsigned width_;
};

class PrefixExpr final : public Expression {
public:
  enum class Op {
#define APPLY_BINARY_OP(_, __)
#define APPLY_ASSIGN_OP(_, __)
#define APPLY_UNARY_OP(NAME, __) NAME,
#include "operators.def"
#undef APPLY_BINARY_OP
#undef APPLY_ASSIGN_OP
#undef APPLY_UNARY_OP
  };

  Expression *expr;
  Op op;

  static Op parseOp(const char *o);

  PrefixExpr(Location loc, Expression *e, const char *o);
  bool isConst() override;
  int evalConst() override;
  bool isInteger() override;
  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
};

std::ostream &operator<<(std::ostream &os, PrefixExpr::Op op);

class CastExpr final : public Expression {
public:
  Expression *expr;
  Type *type;
  CastExpr(Location loc, Expression *e, Type *t);
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
#undef APPLY_ASSIGN_OP
#undef APPLY_UNARY_OP
  };

  Expression *expr1;
  Expression *expr2;
  Op op;

  BinaryExpr(Location loc, Expression *e1, Expression *e2, const char *o);
  bool isConst() override;
  int evalConst() override;
  bool isInteger() override;
  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;

  static bool isOpShift(Op o);
  static bool isOpArithmetic(Op o);
  static bool isOpBitwise(Op o);
  static bool isOpCompare(Op o);
  static bool isOpLogical(Op o);

private:
  static Op parseOp(const char *o);
};

std::ostream &operator<<(std::ostream &os, BinaryExpr::Op op);

class CondExpr final : public Expression {
public:
  Expression *expr1;
  Expression *expr2;
  Expression *test;
  CondExpr(Location loc, Expression *e1, Expression *e2, Expression *t);
  bool isInteger() override;
  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
};

class MultipleValue final : public Expression {
public:
  MvType *type;
  std::vector<Expression *> expr;

  MultipleValue(Location loc, MvType *t, std::vector<Expression *> &&e)
      : Expression(idOf(this), loc), type(t), expr(e) {}
  MultipleValue(Location loc, MvType *t, List<Expression> *e);

  void display(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
};

#endif // EXPRESSIONS_H
