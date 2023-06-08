#include <algorithm>
#include <iomanip>
#include <sstream>

#include "expressions.h"
#include "functions.h"
#include "statements.h"

// class Integer : public Constant
// -------------------------------

Sexpression *Integer::ACL2Expr([[maybe_unused]] bool isBV) {

  // In ACL2, hexadecimal litteral uses `#x` instead of `0x` prefix.
  // Also, the case where val_ is negative and needs to be displayed as hex is
  // a bit specialp: we can't write -#xFF, so instread we have (- #FF).

  std::stringstream ss;

  if (is_hex_) {
    ss << "#x" << std::hex << std::uppercase << std::abs(val_);
  } else {
    ss << val_;
  }

  if (is_hex_ && val_ < 0) {
    return new Plist({ &s_minus, new Symbol(ss.str()) });
  } else {
    return new Symbol(std::move(ss.str()));
  }
}

// class Boolean : public Constant
// -------------------------------

Boolean b_true(Location::dummy(), "true");
Boolean b_false(Location::dummy(), "false");

// class SymRef : public Expression
// ---------------------------------------------------------------

// Reference to declared symbol, which may be an enumeration constant or a
// variable

// Data member: SymDec *symDec;

Type *SymRef::exprType() { return symDec->type->derefType(); }

bool SymRef::isConst() const { return symDec->isConst(); }

int SymRef::evalConst() const {
  assert(isConst() && "Attempt to evaluate a non-constant symbol reference.");
  return symDec->evalConst();
}

bool SymRef::isInteger() { return exprType()->isIntegerType(); }

void SymRef::displayNoParens(std::ostream &os) const {
  symDec->sym->display(os);
}

Expression *SymRef::subst(SymRef *var, Expression *val) {
  return (symDec == var->symDec) ? val : (Expression *)this;
}

Sexpression *SymRef::ACL2Expr(bool isBV) {
  Sexpression *s = symDec->ACL2SymExpr();
  return isBV ? s : exprType()->ACL2Eval(s);
}

Sexpression *SymRef::ACL2Assign(Sexpression *rval) {
  return new Plist({ &s_assign, symDec->sym, rval });
}

bool SymRef::isEqual(Expression *e) { return e->isEqualSymRef(symDec); }

bool SymRef::isEqualSymRef(SymDec *s) { return s == symDec; }

// class FunCall : public Expression (function call)
// -------------------------------------------------

// Data members:  FunDef *func; List<Expression> *args;

FunCall::FunCall(Location loc, FunDef *f, List<Expression> *a)
    : Expression(loc) {
  func = f;
  args = a;
}

Type *FunCall::exprType() {
  assert(func->returnType()->derefType());
  return func->returnType()->derefType();
}

bool FunCall::isInteger() { return exprType()->isIntegerType(); }

void FunCall::displayNoParens(std::ostream &os) const {

  os << func->getname() << "(";
  bool is_first = true;
  for_each(args, [&](Expression *e) {
    if (!is_first)
      os << ", ";
    e->display(os);
    is_first = false;
  });

  os << ")";
}

Expression *FunCall::subst(SymRef *var, Expression *val) {
  List<Expression> *ptr = args;
  List<Expression> *newArgs = nullptr;
  while (ptr) {
    Expression *expr = ptr->value->subst(var, val);
    if (newArgs) {
      newArgs->add(expr);
    } else {
      newArgs = new List<Expression>(expr);
    }
    ptr = ptr->next;
  }
  return new FunCall(this->location(), func, newArgs);
}

Sexpression *FunCall::ACL2Expr(bool isBV) {
  Plist *result = new Plist({ new Symbol(func->getname()) });
  List<Expression> *a = args;

  std::for_each(func->params().begin(), func->params().end(), [&](VarDec *v) {
    result->add(v->type->derefType()->ACL2Assign(a->value));
    a = a->next;
  });

  return isBV ? result : exprType()->ACL2Eval(result);
}

// class TempCall : public Expression (function template Data)
// -------------------------------------------------

// call members:  Symbol *instanceSym; List<Expression> *params;

TempCall::TempCall(Location loc, Template *f, List<Expression> *a,
                   List<Expression> *p)
    : FunCall(loc, f, a), params(p) {
  f->registerCall(this);
}

void TempCall::displayNoParens(std::ostream &os) const {
  os << func->getname() << "<";
  List<Expression> *ptr = params;
  while (ptr) {
    ptr->value->display(os);
    if (ptr->next)
      os << ", ";
    ptr = ptr->next;
  }
  os << ">(";
  ptr = args;
  while (ptr) {
    ptr->value->display(os);
    if (ptr->next)
      os << ", ";
    ptr = ptr->next;
  }
  os << ")";
}

Expression *TempCall::subst(SymRef *var, Expression *val) {
  TempCall *result = (TempCall *)FunCall::subst(var, val);
  List<Expression> *ptr = params;
  List<Expression> *newParams = nullptr;
  while (ptr) {
    Expression *expr = ptr->value->subst(var, val);
    if (newParams) {
      newParams->add(expr);
    } else {
      newParams = new List<Expression>(expr);
    }
    ptr = ptr->next;
  }
  result->params = newParams;
  return result;
}

Sexpression *TempCall::ACL2Expr(bool isBV) {
  auto *result = static_cast<Plist *>(FunCall::ACL2Expr(isBV));
  result->list->value = instanceSym;
  return result;
}

// class Initializer : public Expression (array initializer)
// ---------------------------------------------------------

// Data member:  List<Constant> *vals;

Initializer::Initializer(Location loc, List<Constant> *v) : Expression(loc) {
  vals = v;
}

void Initializer::displayNoParens(std::ostream &os) const {
  os << "{";
  List<Constant> *ptr = vals;
  while (ptr) {
    ptr->value->Symbol::display(os);
    if (ptr->next)
      os << ", ";
    ptr = ptr->next;
  }
  os << "}";
}

Sexpression *Initializer::ACL2Expr([[maybe_unused]] bool isBV) {
  BigList<Sexpression> *result
      = new BigList<Sexpression>((Sexpression *)(vals->value->ACL2Expr()));
  List<Constant> *ptr = vals->next;
  while (ptr) {
    result->add((Sexpression *)(ptr->value->ACL2Expr()));
    ptr = ptr->next;
  }
  return Plist::FromList(result->front());
}

Sexpression *Initializer::ACL2ArrayExpr() {
  List<Sexpression> *entries = ((Plist *)(ACL2Expr()))->list;
  Plist *p = new Plist();
  unsigned i = 0;
  while (entries) {
    if (strcmp(((Constant *)(entries->value))->getname(), "0")) {
      p->add(new Cons(new Integer(this->location(), i), entries->value));
    }
    i++;
    entries = entries->next;
  }
  if (p->list) {
    p = new Plist({ &s_quote, p });
  }
  return p;
}

Sexpression *Initializer::ACL2StructExpr(List<StructField> *fields) {
  Sexpression *result = new Plist();
  List<Constant> *ptr = vals;
  assert(vals->length() == fields->length());
  while (fields) {
    result = new Plist({ &s_as, new Plist({ &s_quote, fields->value->sym }),
                         ptr->value->ACL2Expr(), result });
    ptr = ptr->next;
    fields = fields->next;
  }
  return result;
}

// class ArrayRef : public Expression
// ----------------------------------

// Data members:  Expression *array; Expression *index;

ArrayRef::ArrayRef(Location loc, Expression *a, Expression *i)
    : Expression(loc) {
  array = a;
  index = i;
}

Type *ArrayRef::exprType() {
  assert(((ArrayType *)(array->exprType()))->getBaseType());
  return ((ArrayType *)(array->exprType()))->getBaseType();
}

bool ArrayRef::isInteger() { return exprType()->isIntegerType(); }

void ArrayRef::displayNoParens(std::ostream &os) const {
  array->display(os);
  os << "[";
  index->display(os);
  os << "]";
}

Expression *ArrayRef::subst(SymRef *var, Expression *val) {
  Expression *newIndex = index->subst(var, val);
  return (newIndex == index) ? this
                             : new ArrayRef(this->location(), array, newIndex);
}

Sexpression *ArrayRef::ACL2Expr(bool isBV) {
  Sexpression *s;

  auto *refT = dynamic_cast<SymRef *>(array);
  if (refT && refT->symbolDec()->isROM()) {
    s = new Plist(
        { &s_nth, index->ACL2Expr(), new Plist({ refT->symbolDec()->sym }) });
  } else if (refT && refT->symbolDec()->isGlobal()) {
    s = new Plist(
        { &s_ag, index->ACL2Expr(), new Plist({ refT->symbolDec()->sym }) });
  } else {
    s = new Plist({ &s_ag, index->ACL2Expr(), array->ACL2Expr() });
  }
  return isBV ? s : exprType()->ACL2Eval(s);
}

Sexpression *ArrayRef::ACL2Assign(Sexpression *rval) {
  return array->ACL2Assign(
      new Plist({ &s_as, index->ACL2Expr(), rval, array->ACL2Expr() }));
}

// class ArrayParamRef : public ArrayRef
// -------------------------------------

// ArrayParamRef::ArrayParamRef(Location loc, Expression *a, Expression *i) :
// ArrayRef(a, i) {}
//
// Expression *ArrayParamRef::subst(SymRef *var, Expression *val) {
//  Expression *newIndex = index->subst(var, val);
//  return (newIndex == index) ? this : new ArrayParamRef(array, newIndex);
//}
//
// void ArrayParamRef::displayNoParens(std::ostream &os) const {
//  array->display(os);
//  os << "[";
//  index->display(os);
//  os << "]";
//}

// class StructRef : public Expression
// -----------------------------------

// Data members:  Expression *base; char *field;

StructRef::StructRef(Location loc, Expression *s, char *f) : Expression(loc) {
  base = s;
  field = f;
}

Type *StructRef::exprType() {

  return static_cast<StructType *>(base->exprType())
      ->fields->find(field)
      ->type->derefType();
}

bool StructRef::isInteger() { return exprType()->isIntegerType(); }

void StructRef::displayNoParens(std::ostream &os) const {
  base->display(os);
  os << "." << field;
}

Sexpression *StructRef::ACL2Expr(bool isBV) {
  Symbol *sym
      = ((const StructType *)(base->exprType()))->fields->find(field)->sym;
  Sexpression *s
      = new Plist({ &s_ag, new Plist({ &s_quote, sym }), base->ACL2Expr() });
  return isBV ? s : exprType()->ACL2Eval(s);
}

Sexpression *StructRef::ACL2Assign(Sexpression *rval) {
  Symbol *sym
      = ((const StructType *)(base->exprType()))->fields->find(field)->sym;
  return base->ACL2Assign(new Plist(
      { &s_as, new Plist({ &s_quote, sym }), rval, base->ACL2Expr() }));
}

// class BitRef : public Expression
// --------------------------------

// Data members: Expression *base; Expression *index;

BitRef::BitRef(Location loc, Expression *b, Expression *i) : Expression(loc) {
  base = b;
  index = i;
}

bool BitRef::isInteger() { return true; }

void BitRef::displayNoParens(std::ostream &os) const {
  base->display(os);
  os << "[";
  index->display(os);
  os << "]";
}

Expression *BitRef::subst(SymRef *var, Expression *val) {
  Expression *newBase = base->subst(var, val);
  Expression *newIndex = index->subst(var, val);
  return (newBase == base && newIndex == index)
             ? this
             : new BitRef(this->location(), newBase, newIndex);
}

Sexpression *BitRef::ACL2Expr([[maybe_unused]] bool isBV) {
  Sexpression *b = base->ACL2Expr(true);
  Sexpression *i = index->ACL2Expr();
  return new Plist({ &s_bitn, b, i });
}

Sexpression *BitRef::ACL2Assign(Sexpression *rval) {
  Sexpression *b = base->ACL2Expr(true);
  Sexpression *i = index->ACL2Expr();
  unsigned n = (((const RegType *)(base->exprType()))->width())->evalConst();
  Integer *s = new Integer(this->location(), n);
  return base->ACL2Assign(new Plist({ &s_setbitn, b, s, i, rval }));
}

// class Subrange : public Expression
// ----------------------------------

// Data members: Expression *base; Expression *high; Expression *low;

Subrange::Subrange(Location loc, Expression *b, Expression *h, Expression *l)
    : Expression(loc) {
  base = b;
  high = h;
  low = l;
  width_ = std::nullopt;
}

Subrange::Subrange(Location loc, Expression *b, Expression *h, Expression *l,
                   unsigned w)
    : Expression(loc) {
  base = b;
  high = h;
  low = l;
  width_ = { w };
}

bool Subrange::isInteger() { return true; }

void Subrange::displayNoParens(std::ostream &os) const {
  base->display(os);
  os << "[";
  high->display(os);
  os << ":";
  low->display(os);
  os << "]";
}

Expression *Subrange::subst(SymRef *var, Expression *val) {
  Expression *newBase = base->subst(var, val);
  Expression *newHigh = high->subst(var, val);
  Expression *newLow = low->subst(var, val);
  return (newBase == base && newHigh == high && newLow == low)
             ? this
             : new Subrange(this->location(), newBase, newHigh, newLow);
}

Sexpression *Subrange::ACL2Expr([[maybe_unused]] bool isBV) {
  Sexpression *b = base->ACL2Expr(true);
  Sexpression *hi = high->ACL2Expr();
  Sexpression *lo = low->ACL2Expr();
  return new Plist({ &s_bits, b, hi, lo });
}

Sexpression *Subrange::ACL2Assign(Sexpression *rval) {
  Sexpression *b = base->ACL2Expr(true);
  Sexpression *hi = high->ACL2Expr();
  Sexpression *lo = low->ACL2Expr();
  unsigned n = (((const RegType *)(base->exprType()))->width())->evalConst();
  Integer *s = new Integer(this->location(), n);
  return base->ACL2Assign(new Plist({ &s_setbits, b, s, hi, lo, rval }));
}

unsigned Subrange::compute_size() const {
  if (high->isConst() && low->isConst()) {
    return high->evalConst() - low->evalConst() + 1;
  } else if (high->isPlusConst(low)) {
    return high->getPlusConst() + 1;
  } else {
    assert(width_);
    return *width_;
  }
}

// class PrefixExpr : public Expression
// ------------------------------------

// Data members: Expression *expr; const char *op;

bool PrefixExpr::isConst() const { return expr->isConst(); }

int PrefixExpr::evalConst() const {
  int val = expr->evalConst();
  switch (op_) {
  case PrefixOp::Plus:
    return val;
  case PrefixOp::Minus:
    return -val;
  case PrefixOp::BitwiseNot:
    return -1 - val;
  case PrefixOp::LogicalNot:
    return !val;
  }
  UNREACHABLE();
}

bool PrefixExpr::isInteger() { return expr->isInteger(); }

void PrefixExpr::displayNoParens(std::ostream &os) const {
  switch (op_) {
  case PrefixOp::Plus:
    os << '+';
    break;
  case PrefixOp::Minus:
    os << '-';
    break;
  case PrefixOp::BitwiseNot:
    os << '~';
    break;
  case PrefixOp::LogicalNot:
    os << '!';
    break;
  }
  expr->display(os);
}

Expression *PrefixExpr::subst(SymRef *var, Expression *val) {
  Expression *newExpr = expr->subst(var, val);
  return (newExpr == expr) ? this
                           : new PrefixExpr(this->location(), newExpr, op_);
}

Type *PrefixExpr::exprType() {

  if (IntType *t = dynamic_cast<IntType *>(expr->exprType())) {
    // Otherwise, the behavior is describe in section 2.3.4 of
    // ac_datatypes_ref.
    switch (op_) {
    case PrefixOp::Plus:
      return expr->exprType();
    case PrefixOp::Minus:
      // result type is ac_int<W + 1, true>
      return new IntType(
          new BinaryExpr(expr->location(), t->width(), Integer::one(), "+"),
          true);
    case PrefixOp::BitwiseNot:
      // result type is ac_int<W + !S, true>
      return new IntType(
          new BinaryExpr(expr->location(), t->width(),
                         new Integer(expr->location(), !t->is_signed()), "+"),
          true);
    case PrefixOp::LogicalNot:
      return &boolType;
    default:
      UNREACHABLE();
    }
  } else {
    // TODO: fixed point + int + bool
    return expr->exprType();
  }
}

Sexpression *PrefixExpr::ACL2Expr([[maybe_unused]] bool isBV) {
  Sexpression *s = expr->ACL2Expr();
  switch (op_) {
  case PrefixOp::Plus:
    return s;
  case PrefixOp::Minus:
    return new Plist({ &s_minus, s });
  case PrefixOp::LogicalNot:
    return new Plist({ &s_lognot1, s });
  case PrefixOp::BitwiseNot:
    Type *t = exprType();
    if (t) {
      Plist *bv = new Plist({ &s_lognot, expr->ACL2Expr(true) });
      auto *regT = dynamic_cast<RegType *>(t);
      if (bv && regT) {
        unsigned w = regT->width()->evalConst();
        return new Plist({ &s_bits, bv, new Integer(this->location(), w - 1),
                           Integer::zero() });
      } else {
        return t->ACL2Eval(bv);
        //?? return bv;
      }
    } else {
      return new Plist({ &s_lognot, s });
    }
  }
  UNREACHABLE();
}

bool PrefixExpr::isEqual(Expression *e) {
  return this == e || e->isEqualPrefix(op_, expr);
}

bool PrefixExpr::isEqualPrefix(const PrefixOp o, Expression *e) {
  return o == op_ && e->isEqual(expr);
}

// class CastExpr : public Expression
// ----------------------------------

// Data members: Expression *expr; Type *type;

CastExpr::CastExpr(Location loc, Expression *e, Type *t) : Expression(loc) {
  expr = e;
  type = t;
}

Type *CastExpr::exprType() { return type; }

bool CastExpr::isConst() const { return expr->isConst(); }

int CastExpr::evalConst() const { return expr->evalConst(); }

bool CastExpr::isInteger() { return expr->isInteger(); }

void CastExpr::displayNoParens(std::ostream &os) const { expr->display(os); }

Expression *CastExpr::subst(SymRef *var, Expression *val) {
  Expression *newExpr = expr->subst(var, val);
  return (newExpr == expr) ? this
                           : new CastExpr(this->location(), newExpr, type);
}

Sexpression *CastExpr::ACL2Expr([[maybe_unused]] bool isBV) {
  return expr->ACL2Expr();
}

// class BinaryExpr : public Expression
// ------------------------------------

// Data members: Expression *expr1; Expression *expr2; const char *op;

BinaryExpr::BinaryExpr(Location loc, Expression *e1, Expression *e2,
                       const char *o)
    : Expression(loc), expr1(e1), expr2(e2), op(o), op_(parse_op(o)) {}

bool BinaryExpr::isConst() const {
  return expr1->isConst() && expr2->isConst();
}

int BinaryExpr::evalConst() const {
  int val1 = expr1->evalConst();
  int val2 = expr2->evalConst();
  if (!strcmp(op, "+"))
    return val1 + val2;
  if (!strcmp(op, "-"))
    return val1 - val2;
  if (!strcmp(op, "*"))
    return val1 * val2;
  if (!strcmp(op, "/"))
    return val1 / val2;
  if (!strcmp(op, "%"))
    return val1 % val2;
  if (!strcmp(op, "<<"))
    return val1 << val2;
  if (!strcmp(op, ">>"))
    return val1 >> val2;
  if (!strcmp(op, "&"))
    return val1 & val2;
  if (!strcmp(op, "^"))
    return val1 ^ val2;
  if (!strcmp(op, "|"))
    return val1 | val2;
  if (!strcmp(op, "<"))
    return val1 < val2;
  if (!strcmp(op, ">"))
    return val1 > val2;
  if (!strcmp(op, "<="))
    return val1 <= val2;
  if (!strcmp(op, ">="))
    return val1 >= val2;
  if (!strcmp(op, "=="))
    return val1 == val2;
  if (!strcmp(op, "!="))
    return val1 != val2;
  if (!strcmp(op, "&&"))
    return val1 && val2;
  if (!strcmp(op, "||"))
    return val1 || val2;
  UNREACHABLE();
}

bool BinaryExpr::isInteger() {
  return expr1->isInteger() && expr2->isInteger();
}

void BinaryExpr::displayNoParens(std::ostream &os) const {
  expr1->display(os);
  os << " " << op << " ";
  expr2->display(os);
}

Expression *BinaryExpr::subst(SymRef *var, Expression *val) {
  Expression *newExpr1 = expr1->subst(var, val);
  Expression *newExpr2 = expr2->subst(var, val);
  return (newExpr1 == expr1 && newExpr2 == expr2)
             ? this
             : new BinaryExpr(this->location(), newExpr1, newExpr2, op);
}

Type *BinaryExpr::exprType() {

  IntType *t1 = dynamic_cast<IntType *>(expr1->exprType());
  IntType *t2 = dynamic_cast<IntType *>(expr2->exprType());

  if (t1 && t2) {
    // This behavior is describe in section 2.3.1 of ac_datatypes_ref.
    switch (op_) {

    case BinaryOp::Times:
    case BinaryOp::Div: {
      // W1+W2
      Expression *width
          = new BinaryExpr(this->location(), t1->width(), t2->width(), "+");
      return new IntType(width, t1->is_signed() || t2->is_signed());
    }

    case BinaryOp::Mod: {
      // W2 + !S2&S1
      Expression *rigth = new BinaryExpr(
          this->location(), t2->width(),
          new Integer(this->location(), (!t2->is_signed()) && t1->is_signed()),
          "+");

      return new IntType(
          new Integer(this->location(),
                      std::min(t1->width()->evalConst(), rigth->evalConst())),
          t1->is_signed());
    }

    case BinaryOp::LShift:
    case BinaryOp::RShift:
      return t1;

    case BinaryOp::Plus:
    case BinaryOp::Minus:
    case BinaryOp::BitwiseAnd:
    case BinaryOp::BitwiseXor:
    case BinaryOp::BitwiseOr: {
      // W1 + !S1&S2
      Expression *left = new BinaryExpr(
          this->location(), t1->width(),
          new Integer(this->location(), (!t1->is_signed()) && t2->is_signed()),
          "+");
      // W2 + !S2&S1
      Expression *rigth = new BinaryExpr(
          this->location(), t2->width(),
          new Integer(this->location(), (!t2->is_signed()) && t1->is_signed()),
          "+");
      // max(left, rigth)
      Expression *max = new Integer(
          this->location(), std::max(left->evalConst(), rigth->evalConst()));

      // If we are in the + / - case, we add + 1 for the overflow bit.
      Expression *width = nullptr;
      if (op_ == BinaryOp::Plus || op_ == BinaryOp::Minus) {
        width = new BinaryExpr(this->location(), max, Integer::one(), "+");
      } else {
        width = max;
      }

      // sign: s1 | s2 || op == minus
      return new IntType(width, t1->is_signed() || t2->is_signed()
                                    || op_ == BinaryOp::Minus);
    }

    case BinaryOp::Less:
    case BinaryOp::Greater:
    case BinaryOp::LessEqual:
    case BinaryOp::GreaterEqual:
    case BinaryOp::Equal:
    case BinaryOp::NotEqual:
    case BinaryOp::LogicalAnd:
    case BinaryOp::LogicalOr:
      return &boolType;

    default:
      UNREACHABLE();
    }

  } /*else  if () {
    Mixed type: ac_int OP primType
  } */
  else
    return expr2->exprType();
}

Sexpression *BinaryExpr::ACL2Expr(bool isBV) {
  // TODO add cast for operation that can exceed the type (ash...)
  Symbol *ptr;
  Sexpression *sexpr1 = expr1->ACL2Expr();
  Sexpression *sexpr2 = expr2->ACL2Expr();
  if (expr1->isFP() && !strcmp(op, "<<")) {
    return new Plist(
        { &s_times, sexpr1, new Plist({ &s_expt, Integer::two(), sexpr2 }) });
  } else if (expr1->isFP() && !strcmp(op, ">>")) {
    return new Plist(
        { &s_divide, sexpr1, new Plist({ &s_expt, Integer::two(), sexpr2 }) });
  }
  if (!strcmp(op, "+"))
    ptr = &s_plus;
  else if (!strcmp(op, "-"))
    ptr = &s_minus;
  else if (!strcmp(op, "*"))
    ptr = &s_times;
  else if (!strcmp(op, "/"))
    return new Plist({ &s_fl, new Plist({ &s_slash, sexpr1, sexpr2 }) });
  else if (!strcmp(op, "%"))
    ptr = &s_rem;
  else if (!strcmp(op, "<<"))
    ptr = &s_ash;
  else if (!strcmp(op, ">>")) {
    ptr = &s_ash;
    sexpr2 = new Plist({ &s_minus, sexpr2 });
  } else if (!strcmp(op, "&"))
    ptr = &s_logand;
  else if (!strcmp(op, "^"))
    ptr = &s_logxor;
  else if (!strcmp(op, "|"))
    ptr = &s_logior;
  else if (!strcmp(op, "<"))
    ptr = &s_logless;
  else if (!strcmp(op, ">"))
    ptr = &s_loggreater;
  else if (!strcmp(op, "<="))
    ptr = &s_logleq;
  else if (!strcmp(op, ">="))
    ptr = &s_loggeq;
  else if (!strcmp(op, "=="))
    ptr = &s_logeq;
  else if (!strcmp(op, "!="))
    ptr = &s_logneq;
  else if (!strcmp(op, "&&"))
    ptr = &s_logand1;
  else if (!strcmp(op, "||"))
    ptr = &s_logior1;
  else
    UNREACHABLE();
  if (exprType()
      && (ptr == &s_logand || ptr == &s_logior || ptr == &s_logxor)) {
    Plist *bv
        = new Plist({ ptr, expr1->ACL2Expr(true), expr2->ACL2Expr(true) });
    return isBV ? bv : exprType()->ACL2Eval(bv);
  } else {
    return new Plist({ ptr, sexpr1, sexpr2 });
  }
}

bool BinaryExpr::isEqual(Expression *e) {
  return this == e || e->isEqualBinary(op, expr1, expr2);
}

bool BinaryExpr::isEqualBinary(const char *o, Expression *e1, Expression *e2) {
  return !strcmp(o, op) && e1->isEqual(expr1) && e2->isEqual(expr2);
}

bool BinaryExpr::isPlusConst(Expression *e) {
  return !strcmp(op, "+") && expr1->isEqual(e) && expr2->isConst();
}

int BinaryExpr::getPlusConst() { return expr2->evalConst(); }

// class CondExpr : public Expression (conditional expression)
// -----------------------------------------------------------

// Data members:  Expression *expr1; Expression *expr2; Expression *test;

CondExpr::CondExpr(Location loc, Expression *e1, Expression *e2, Expression *t)
    : Expression(loc) {
  expr1 = e1;
  expr2 = e2;
  test = t;
}

bool CondExpr::isInteger() { return expr1->isInteger() && expr2->isInteger(); }

void CondExpr::displayNoParens(std::ostream &os) const {
  test->display(os);
  os << " ? ";
  expr1->display(os);
  os << " : ";
  expr2->display(os);
}

Expression *CondExpr::subst(SymRef *var, Expression *val) {
  Expression *newExpr1 = expr1->subst(var, val);
  Expression *newExpr2 = expr2->subst(var, val);
  Expression *newTest = test->subst(var, val);
  return (newExpr1 == expr1 && newExpr2 == expr2 && newTest == test)
             ? this
             : new CondExpr(this->location(), newExpr1, newExpr2, newTest);
}

Sexpression *CondExpr::ACL2Expr([[maybe_unused]] bool isBV) {
  return new Plist(
      { &s_if1, test->ACL2Expr(), expr1->ACL2Expr(), expr2->ACL2Expr() });
}

// class MultipleValue : public Expression
// ---------------------------------------

// Data members: MvType *type; Expression *expr[8];

MultipleValue::MultipleValue(Location loc, MvType *t, List<Expression> *e)
    : Expression(loc), type(t), expr(collect(e)) {
  //  expr.reserve(8);
  //  for_each(e, [&](Expression *ee) { expr.push_back(ee); })

  //  for (unsigned i = 0; i < 8 && e; ++i) {
  //    expr.push_back(e->value);
  //    e = e->pop();
  //  }
  //
  //  std::cerr << type->size() << ' ' << expr.size() << '\n';

  assert(expr.size() >= 2
         && "It does not make sense to have a mv with 1 or 0 elem");
  assert(type->size() == expr.size()
         && "We should have as many types as values");
}

void MultipleValue::displayNoParens(std::ostream &os) const {
  os << "<";
  bool first = true;
  for (const auto e : expr) {
    if (!first) {
      os << ", ";
    }
    e->display(os);
  }
  os << ">";
}

Expression *MultipleValue::subst(SymRef *var, Expression *val) {
  std::vector<Expression *> newExpr;
  newExpr.reserve(8);
  bool isNew = false;

  for (unsigned i = 0; i < expr.size(); ++i) {
    newExpr.push_back(expr[i]->subst(var, val));
    if (newExpr[i] != expr[i]) {
      isNew = true;
    }
  }
  return isNew ? new MultipleValue(this->location(), type, std::move(newExpr))
               : this;
}

Sexpression *MultipleValue::ACL2Expr([[maybe_unused]] bool isBV) {
  Plist *result = new Plist({ &s_mv });

  for (unsigned i = 0; i < expr.size(); ++i) {
    result->add(type->typeOfNth(i)->derefType()->ACL2Assign(expr[i]));
  }
  return result;
}
