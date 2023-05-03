#ifndef EXPRESSIONS_H
#define EXPRESSIONS_H

#include <cmath>

#include "parser.h"
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

// class ASTNode {
// public:
//  virtual bool bindNames(SymbolStack<SymDec> &symTab) { TODO(); }
//
// protected:
//  template <typename... Args> void report(const char *format, Args... args)
//  {
//    //std::fprintf (stderr, "%s:%d: ", yyfilenm, yylineno);
//    std::fprintf (stderr, format, args...);
//    std::fprintf (stderr, "\n");
//  }
//};

template <typename Expr>
class NoParenthesis {
public:
  NoParenthesis(const Expr &e) : expr_(e) {}

  friend std::ostream &operator<<(std::ostream &os,
                                  const NoParenthesis<Expr> &e) {
    e.expr_->displayNoParens(os);
    return os;
  }

private:
  const Expr &expr_;
};

class Expression //: public ASTNode
{
  bool needsParens_;

public:
  Expression() : needsParens_(false) {}

  void needsParens() { needsParens_ = true; }

  // TODO remove all of this
  virtual bool isConst() const { return false; }
  virtual bool isArray() { return false; }
  virtual bool isStruct() { return false; }
  virtual bool isSubrange() { return false; }
  virtual bool isInteger() { return false; }

  virtual int evalConst() const {
    assert(!"attempt to evaluate a non-constant expression");
    return 0;
  }

  bool isNumber() { return !isArray() && !isStruct(); }
  bool isFP() { return isNumber() && !isInteger(); }

  // The following expressions have associated types: variable, array, and
  // struct references; function calls; cast expressions; applications of "~"
  // to typed expressions; and applications of "&", "|", and "^" to typed
  // expressions of the same type.  For all other expressions, exprType is
  // undefined:
  //
  // virtual (overridden by SymRef, Funcall, ArrayRef, StructRef, PrefixExpr,
  // and BinaryExpr)
  // Dereferenced type of expression.
  virtual Type *exprType() = 0;

  // displayNoParens is defined for each class of expressions and is called by
  // the non-virtual display method, which inserts parentheses as required:
  virtual void displayNoParens(std::ostream &os) const = 0;
  void display(std::ostream &os) const {
    if (needsParens_)
      os << "(";
    displayNoParens(os);
    if (needsParens_)
      os << ")";
  }

  friend std::ostream &operator<<(std::ostream &os, const Expression &e) {
    e.display(os);
    return os;
  }

  // The following method substitutes each occurrence of a given variable with
  // a given value:
  virtual Expression *subst([[maybe_unused]] SymRef *var,
                            [[maybe_unused]] Expression *val) {
    return this;
  };

  // The following method converts an expression to an S-expression.  The
  // argument isBV is relevant only for a typed expression of a register type
  // (see exprType above).  In this case, if isBV is true, then the resulting
  // S-expression should represent the value of the bit vector contents of the
  // register, and otherwise it should represent the value of that bit vector
  // as interpreted according to the type. The argument isBV is set the
  // following cases: (1) The expression is being assigned to a register of the
  // same type; (2) The expression is being assigned to an integer register and
  // the expression is an unsigned
  //     integer register of width not exceeding that of the target;
  // (3) The resulting S-expression is to be the first argument of bitn, bits,
  // setbitn, or setbits. (4) The expression is an argument of a logical
  // expression of a register type.
  virtual Sexpression *ACL2Expr([[maybe_unused]] bool isBV = false) = 0;

  // The following method converts an expression to an Sexpression to be used
  // as an array initialization. It returns the same value as ACL2Expr, except
  // for an Initializer:
  virtual Sexpression *ACL2ArrayExpr() { return ACL2Expr(); }

  // Translate to an ACL2 assignment with this lvalue and the rvalue given as
  // the argument. virtual (overridden by valid lvalues)
  virtual Sexpression *ACL2Assign([[maybe_unused]] Sexpression *rval) {
    assert(!"Assigment can be made only to an expression of type SymRef, "
            "ArrayRef, StructRef, BitRef, or Subrange");
    return nullptr;
  }

  // If a numerical expression is known to have a non-negative value of bounded
  // width, then return the bound; otherwise, return 0:
  unsigned ACL2ValWidth() {
    //    assert(exprType()->ACL2ValWidth());
    return exprType()->ACL2ValWidth();
  }

  // The remaining Expression methods are defined solely for the purpose of
  // making ACL2ValWidth a little smarter by computing the width of a Subrange
  // expression when the limits differ by a computable constant:

  // virtual (overridden by PrefixExpr and BinaryExpr)
  // Is this expression known to be equal in value to e?
  // Used only by isPlusConst.
  virtual bool isEqual(Expression *e) { return this == e; }

  // virtual (overridden by PrefixExpr)
  // Is this a prefix expression with the given operator and argument?
  // Used only by isEqual.
  virtual bool isEqualPrefix([[maybe_unused]] const char *o,
                             [[maybe_unused]] Expression *e) {
    return false;
  }

  // virtual (overridden by BinaryExpr)
  // Is this a binary expression with the given operator and arguments?
  // Used only by isEqual.
  virtual bool isEqualBinary([[maybe_unused]] const char *o,
                             [[maybe_unused]] Expression *e1,
                             [[maybe_unused]] Expression *e2) {
    return false;
  }

  // virtual (overridden by BinaryExpr)
  // Used only by Subrange::ACL2ValWidth
  // Applied to the upper limit of a Subrange expression to determine whether
  // it is it is a binary expression representing the sum of the lower limit
  // and a constant.
  virtual bool isPlusConst([[maybe_unused]] Expression *e) { return false; }

  virtual int getPlusConst() {
    // virtual (overridden by BinaryExpr)
    // Called on a binary expression for which isPlusConst is true; returns the
    // value of the constant.
    return 0;
  }

  virtual bool isEqualSymRef([[maybe_unused]] SymDec *s) {
    // virtual (overridden by SymRef)
    // Is this a reference to a given symbol?
    // Used only by isEqual.
    return false;
  }

  virtual bool isEqualConst([[maybe_unused]] Constant *c) {
    // virtual (overridden by Constant)
    // Is this a constant equal to a given constant?
    // Used only by isEqual.
    return false;
  }
};

class Constant : public Expression, public Symbol {
public:
  Constant(const char *n) : Expression(), Symbol(n) {}
  Constant(int n) : Expression(), Symbol(n) {}

  bool isConst() const override { return true; }
  bool isInteger() override { return true; }

  void displayNoParens(std::ostream &os) const override { os << getname(); }

  Sexpression *ACL2Expr([[maybe_unused]] bool isBV = false) override {
    return this;
  }

  bool isEqual(Expression *e) override { return e->isEqualConst(this); }

  bool isEqualConst(Constant *c) override {
    return !strcmp(getname(), c->getname());
  }

  // astnode implementation
  //  bool bindNames(SymbolStack<SymDec> &symTab) override { return true; }
};

class Integer : public Constant {
public:
  Integer(const char *n) : Constant(n) {
    if (!strncmp(getname(), "0x", 2)) {
      val_ = strtol(getname() + 2, nullptr, 16);
      is_hex_ = true;
    } else if (!strncmp(getname(), "-0x", 3)) {
      val_ = -strtol(getname() + 3, nullptr, 16);
      is_hex_ = true;
    } else {
      val_ = atoi(getname());
      is_hex_ = false;
    }
  }

  static Integer *zero() { return new Integer(0); };
  static Integer *one() { return new Integer(1); };
  static Integer *two() { return new Integer(2); };

  Integer(int n) : Constant(n), val_(n), is_hex_(false) {}

  int evalConst() const override { return val_; }

  Sexpression *ACL2Expr(bool isBV) override;

  Type *exprType() override {
    // TODO Remove ternary: it is needed since 0 is consider as no or unknown
    // bounds.
    unsigned width = val_ ? std::floor(std::log2(val_)) : 1;
    return new IntType(new Integer(width), val_ < 0);
  }

  // astnode implementation
  //  bool bindNames(SymbolStack<SymDec> &symTab) override { return true; }
private:
  long val_;
  bool is_hex_;
};

class Boolean : public Constant {
public:
  Boolean(const char *n) : Constant(n) {
    if (!strcmp(getname(), "true"))
      val_ = true;
    else if (!strcmp(getname(), "false"))
      val_ = false;
    else
      UNREACHABLE();
  }

  Boolean(bool val) : Constant(val ? "true" : "false"), val_(val){};

  int evalConst() const override { return val_; }

  Sexpression *ACL2Expr([[maybe_unused]] bool isBV) {
    return val_ ? new Plist({ &s_true }) : new Plist({ &s_false });
  }

  Type *exprType() override { return &boolType; }

  // astnode implementation
  //  bool bindNames(SymbolStack<SymDec> &symTab) override { return true; }
private:
  bool val_;
};

extern Boolean b_true;
extern Boolean b_false;

class SymRef : public Expression {

public:
  SymDec *symDec;
  SymRef(SymDec *s);
  Type *exprType() override;
  virtual bool isConst() const override;
  virtual int evalConst() const override;
  bool isArray() override;
  bool isStruct() override;
  bool isInteger() override;
  void displayNoParens(std::ostream &os) const override;
  Expression *subst(SymRef *var, Expression *val) override;
  Sexpression *ACL2Expr(bool isBV = false) override;
  Sexpression *ACL2Assign(Sexpression *rval) override;
  bool isEqual(Expression *e) override;
  bool isEqualSymRef(SymDec *s) override;

  //  // astnode implementation
  //  bool bindNames(SymbolStack<SymDec> &symTab) override {
  //    if (auto dec = symTab.find (id)) {
  //      symDec = dec;
  //      return true;
  //    } else {
  //      report ("Unknown symbol `%s`\n", id);
  //      return false;
  //    }
  //  }
};

class FunDef;

class FunCall : public Expression {
public:
  FunDef *func;
  List<Expression> *args;
  FunCall(FunDef *f, List<Expression> *a);
  bool isArray() override;
  bool isStruct() override;
  bool isInteger() override;
  Type *exprType() override;
  void displayNoParens(std::ostream &os) const override;
  Expression *subst(SymRef *var, Expression *val) override;
  Sexpression *ACL2Expr(bool isBV = false) override;
};

class Template;

class TempCall : public FunCall {
public:
  Symbol *instanceSym = nullptr;
  List<Expression> *params;
  TempCall(Template *f, List<Expression> *a, List<Expression> *p);
  void displayNoParens(std::ostream &os) const override;
  Expression *subst(SymRef *var, Expression *val) override;
  Sexpression *ACL2Expr(bool isBV = false) override;
};

class Initializer : public Expression {
public:
  List<Constant> *vals;
  Initializer(List<Constant> *v);
  void displayNoParens(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
  Sexpression *ACL2ArrayExpr() override;
  Sexpression *ACL2StructExpr(List<StructField> *fields);

  Type *exprType() override {
    TODO();
    return nullptr;
  }
};

class ArrayRef : public Expression {
public:
  Expression *array;
  Expression *index;
  ArrayRef(Expression *a, Expression *i);
  bool isArray() override;
  bool isInteger() override;
  Type *exprType() override;
  void displayNoParens(std::ostream &os) const override;
  Expression *subst(SymRef *var, Expression *val) override;
  Sexpression *ACL2Expr(bool isBV = false) override;
  Sexpression *ACL2Assign(Sexpression *rval) override;
};

class ArrayParamRef : public ArrayRef {
public:
  ArrayParamRef(Expression *a, Expression *i);
  void displayNoParens(std::ostream &os) const override;
  Expression *subst(SymRef *var, Expression *val) override;
};

class StructRef : public Expression {
public:
  Expression *base;
  char *field;
  StructRef(Expression *s, char *f);
  bool isArray() override;
  bool isInteger() override;
  Type *exprType() override;
  void displayNoParens(std::ostream &os) const override;
  Sexpression *ACL2Expr(bool isBV = false) override;
  Sexpression *ACL2Assign(Sexpression *rval) override;
};

class BitRef : public Expression {
public:
  Expression *base;
  Expression *index;
  BitRef(Expression *b, Expression *i);
  bool isInteger() override;
  void displayNoParens(std::ostream &os) const override;
  Expression *subst(SymRef *var, Expression *val) override;
  Sexpression *ACL2Expr(bool isBV = false) override;
  Sexpression *ACL2Assign(Sexpression *rval) override;

  Type *exprType() override { return new IntType(new Integer(1), false); }
};

class Subrange : public Expression {
  std::optional<unsigned> width_;

  unsigned compute_size() const;

public:
  Expression *base;
  Expression *high;
  Expression *low;

  Subrange(Expression *b, Expression *h, Expression *l);
  Subrange(Expression *b, Expression *h, Expression *l, unsigned w);

  bool isSubrange() override;
  bool isInteger() override;
  void displayNoParens(std::ostream &os) const override;

  Expression *subst(SymRef *var, Expression *val) override;
  Sexpression *ACL2Expr(bool isBV = false) override;
  Sexpression *ACL2Assign(Sexpression *rval) override;

  Type *exprType() override {
    return new IntType(new Integer(compute_size()), false);
  }
};

class PrefixExpr : public Expression {
public:
  Expression *expr;
  const char *op;
  PrefixExpr(Expression *e, const char *o);
  bool isConst() const override;
  int evalConst() const override;
  bool isInteger() override;
  void displayNoParens(std::ostream &os) const override;
  Expression *subst(SymRef *var, Expression *val) override;
  Type *exprType() override;
  Sexpression *ACL2Expr(bool isBV = false) override;
  virtual bool isEqual(Expression *e) override;
  virtual bool isEqualPrefix(const char *o, Expression *e) override;
};

class CastExpr : public Expression {
public:
  Expression *expr;
  Type *type;
  CastExpr(Expression *e, Type *t);
  Type *exprType() override;
  bool isConst() const override;
  int evalConst() const override;
  bool isInteger() override;
  void displayNoParens(std::ostream &os) const override;
  Expression *subst(SymRef *var, Expression *val) override;
  Sexpression *ACL2Expr(bool isBV = false) override;
};

class BinaryExpr : public Expression {
protected:
public:
  Expression *expr1;
  Expression *expr2;
  const char *op;
  BinaryExpr(Expression *e1, Expression *e2, const char *o);
  bool isConst() const override;
  int evalConst() const override;
  bool isInteger() override;
  void displayNoParens(std::ostream &os) const override;
  Expression *subst(SymRef *var, Expression *val) override;
  Type *exprType() override;
  Sexpression *ACL2Expr(bool isBV = false) override;
  virtual bool isEqual(Expression *e) override;
  virtual bool isEqualBinary(const char *o, Expression *e1,
                             Expression *e2) override;
  virtual bool isPlusConst(Expression *e) override;
  virtual int getPlusConst() override;
};

class CondExpr : public Expression {
public:
  Expression *expr1;
  Expression *expr2;
  Expression *test;
  CondExpr(Expression *e1, Expression *e2, Expression *t);
  bool isInteger() override;
  void displayNoParens(std::ostream &os) const override;
  Expression *subst(SymRef *var, Expression *val) override;
  Sexpression *ACL2Expr(bool isBV = false) override;

  Type *exprType() override {
    assert(expr1->exprType() == expr2->exprType());
    return expr1->exprType();
  }
};

class MultipleValue : public Expression {
public:
  MvType *type;
  std::vector<Expression *> expr;

  MultipleValue(MvType *t, std::vector<Expression *> &&e) : type(t), expr(e) {}
  MultipleValue(MvType *t, List<Expression> *e);

  void displayNoParens(std::ostream &os) const override;
  Expression *subst(SymRef *var, Expression *val) override;
  Sexpression *ACL2Expr(bool isBV = false) override;

  Type *exprType() override { return type; }
};

#endif // EXPRESSIONS_H
