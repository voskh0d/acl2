#include "expressions.h"
#include "functions.h"
#include "statements.h"

#include <iomanip>
#include <sstream>

// TODO remove (only for debug)
#include "parser.h"

//***********************************************************************************
// class Expression
//***********************************************************************************

bool Expression::isConst() { return false; } // virtual

// Value of expression, applicable to a limited variety of integer-valued
// constant expressions:

int Expression::evalConst() { // virtual (overridden by constant expressions)
  assert(!"attempt to evaluate a non-constant expression");
  return 0;
}

bool Expression::isInteger() { // virtual
  return false;
}

// The following method converts an expression to an Sexpression to be used as
// an array initialization. It returns the same value as ACL2Expr, except for
// an Initializer:

Sexpression *
Expression::ACL2ArrayExpr() { // virtual (overridden by Initializer)
  return ACL2Expr();
}

// Translate to an ACL2 assignment with this lvalue and the rvalue given as the
// argument:

Sexpression *
Expression::ACL2Assign([[maybe_unused]] Sexpression
                           *rval) { // virtual (overridden by valid lvalues)
  assert(!"Assigment can be made only to an expression of type SymRef, "
          "ArrayRef, StructRef, or Subrange");
  return nullptr;
}

// If a numerical expression is known to have a non-negative value of bounded
// width, then return the bound; otherwise, return 0:

unsigned Expression::ACL2ValWidth() {
  const Type *t = get_type();
  return t ? t->ACL2ValWidth() : 0;
}

// class Constant : public Expression, public Symbol
// -------------------------------------------------

Constant::Constant(NodesId id, Location loc, const char *n)
    : Expression(id, loc), Symbol(n) {}
Constant::Constant(NodesId id, Location loc, std::string &&n)
    : Expression(id, loc), Symbol(std::move(n)) {}

Constant::Constant(NodesId id, Location loc, int n)
    : Expression(id, loc), Symbol(n) {}

bool Constant::isConst() { return true; }

Sexpression *Constant::ACL2Expr() { return this; }

// class Integer : public Constant
// -------------------------------

Integer::Integer(Location loc, const char *n) : Constant(idOf(this), loc, n) {
  if (!strncmp(getname(), "0x", 2)) {
    val_ = strtoll(getname() + 2, nullptr, 16);
  } else if (!strncmp(getname(), "-0x", 3)) {
    val_ = -strtoll(getname() + 3, nullptr, 16);
  } else {
    val_ = atoi(getname());
  }
}

Integer::Integer(Location loc, int n)
    : Constant(idOf(this), loc, n), val_(n) {}

int Integer::evalConst() { return val_; }

void Integer::display(std::ostream &os) const { os << getname(); }

Sexpression *Integer::ACL2Expr() {
  if (!strncmp(getname(), "0x", 2)) {
    std::string new_name(getname());
    new_name[0] = '#';
    Symbol *result = new Symbol(std::move(new_name));
    return result;
  } else if (!strncmp(getname(), "-0x", 3)) {
    std::string new_name(getname() + 1);
    new_name[0] = '#';
    Symbol *result = new Symbol(std::move(new_name));
    return new Plist({ &s_minus, result });
  } else {
    return this;
  }
}

// class Boolean : public Constant
// -------------------------------
Boolean::Boolean(Location loc, bool value)
    : Constant(idOf(this), loc, std::to_string(value)), value_(value) {}

int Boolean::evalConst() { return value_; }

void Boolean::display(std::ostream &os) const {
  os << (value_ ? "true" : "false");
}

Sexpression *Boolean::ACL2Expr() {
  return new Plist({ value_ ? &s_true : &s_false });
}

// class SymRef : public Expression
// ---------------------------------------------------------------

// Reference to declared symbol, which may be an enumeration constant or a
// variable

// Data member: SymDec *symDec;

SymRef::SymRef(Location loc, SymDec *s) : Expression(idOf(this), loc) {
  symDec = s;
}

bool SymRef::isConst() { return symDec->isConst(); }

int SymRef::evalConst() {
  if (isConst()) {
    return symDec->evalConst();
  } else {
    assert(!"Attempt to evaluate a non-constant symbol reference.");
  }
}

bool SymRef::isInteger() { return isIntegerType(get_type()); }

void SymRef::display(std::ostream &os) const { symDec->sym->display(os); }

Sexpression *SymRef::ACL2Expr() {
  Sexpression *s = symDec->ACL2SymExpr();
  return s;
}

Sexpression *SymRef::ACL2Assign(Sexpression *rval) {
  return new Plist({ &s_assign, symDec->sym, rval });
}

// class FunCall : public Expression (function call)
// -------------------------------------------------

// Data members:  FunDef *func; List<Expression> *args;

FunCall::FunCall(Location loc, FunDef *f, List<Expression> *a)
    : Expression(idOf(this), loc) {
  func = f;
  args = a;
}

FunCall::FunCall(NodesId id, Location loc, FunDef *f, List<Expression> *a)
    : Expression(id, loc) {
  func = f;
  args = a;
}

bool FunCall::isInteger() { return isIntegerType(get_type()); }

void FunCall::display(std::ostream &os) const {

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

Sexpression *FunCall::ACL2Expr() {
  Plist *result = new Plist({ new Symbol(func->getname()) });
  List<VarDec> *p = func->params;
  List<Expression> *a = args;
  while (a) {
    result->add(p->value->type->ACL2Assign(a->value));
    a = a->next;
    p = p->next;
  }
  return result;
}

// class TempCall : public Expression (function template Data)
// -------------------------------------------------

// call members:  Symbol *instanceSym; List<Expression> *params;

TempCall::TempCall(Location loc, Template *f, List<Expression> *a,
                   List<Expression> *p)
    : FunCall(idOf(this), loc, f, a) {
  params = p;
  f->calls.push_back(this);
}

void TempCall::display(std::ostream &os) const {
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

Sexpression *TempCall::ACL2Expr() {
  dynamic_cast<Template *>(func)->bindParams(params);
  Plist *result = dynamic_cast<Plist *>(FunCall::ACL2Expr());
  result->list->value = instanceSym;
  return result;
}

// class Initializer : public Expression (array initializer)
// ---------------------------------------------------------

// Data member:  List<Constant> *vals;

Initializer::Initializer(Location loc, List<Constant> *v)
    : Expression(idOf(this), loc) {
  vals = v;
}

void Initializer::display(std::ostream &os) const {
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

Sexpression *Initializer::ACL2Expr() {
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
      p->add(new Cons(new Integer(loc_, i), entries->value));
    }
    i++;
    entries = entries->next;
  }
  if (p->list) {
    p = new Plist({ &s_quote, p });
  }
  return p;
}

Sexpression *
Initializer::ACL2StructExpr(const std::vector<StructField *> &fields) {
  Sexpression *result = new Plist();
  List<Constant> *ptr = vals;
  assert(vals->length() == fields.size());

  for (auto f : fields) {
    result = new Plist({ &s_as, new Plist({ &s_quote, f->sym }),
                         ptr->value->ACL2Expr(), result });
    ptr = ptr->next;
  }
  return result;
}

// class ArrayRef : public Expression
// ----------------------------------

// Data members:  Expression *array; Expression *index;

ArrayRef::ArrayRef(Location loc, Expression *a, Expression *i)
    : Expression(idOf(this), loc) {
  array = a;
  index = i;
}

bool ArrayRef::isInteger() { return isIntegerType(get_type()); }

void ArrayRef::display(std::ostream &os) const {
  array->display(os);
  os << "[";
  index->display(os);
  os << "]";
}

Sexpression *ArrayRef::ACL2Expr() {
  if (isa<const ArrayType *>(array->get_type())) {
    Sexpression *s = nullptr;
    SymRef *ref = dynamic_cast<SymRef *>(array);

    if (ref && ref->symDec->isROM()) {
      s = new Plist(
          { &s_nth, index->ACL2Expr(), new Plist({ ref->symDec->sym }) });
    } else if (ref && ref->symDec->isGlobal()) {
      s = new Plist(
          { &s_ag, index->ACL2Expr(), new Plist({ ref->symDec->sym }) });
    } else {
      s = new Plist({ &s_ag, index->ACL2Expr(), array->ACL2Expr() });
    }
    return s;
  } else {

    Sexpression *b = array->ACL2Expr();
    Sexpression *i = index->ACL2Expr();

    // If the register is signed, get its 2-complement representation.
    const RegType *t = always_cast<const RegType *>(array->get_type());

    if (t->isSigned()) {
      unsigned n = t->width()->evalConst();
      b = new Plist(
          { &s_bits, b, new Integer(loc_, n - 1), Integer::zero_v(loc_) });
    }

    return new Plist({ &s_bitn, b, i });
  }
}

Sexpression *ArrayRef::ACL2Assign(Sexpression *rval) {
  if (isa<const ArrayType *>(array->get_type())) {
    return array->ACL2Assign(
        new Plist({ &s_as, index->ACL2Expr(), rval, array->ACL2Expr() }));
  } else {
    Sexpression *b = array->ACL2Expr();
    Sexpression *i = index->ACL2Expr();

    const RegType *t = always_cast<const RegType *>(array->get_type());
    unsigned n = t->width()->evalConst();

    // If the register is signed, get its 2-complement representation.
    if (t->isSigned()) {
      b = new Plist(
          { &s_bits, b, new Integer(loc_, n - 1), Integer::zero_v(loc_) });
    }

    Integer *s = new Integer(loc_, n);
    Sexpression *val = new Plist({ &s_setbitn, b, s, i, rval });

    // If the register is signed, recover the signed value.
    if (t->isSigned()) {
      val = new Plist({ &s_si, val, new Integer(loc_, n) });
    }

    return array->ACL2Assign(val);
  }
}

// class StructRef : public Expression
// -----------------------------------

// Data members:  Expression *base; char *field;

StructRef::StructRef(Location loc, Expression *s, char *f)
    : Expression(idOf(this), loc) {
  base = s;
  field = f;
}

bool StructRef::isInteger() { return isIntegerType(get_type()); }

void StructRef::display(std::ostream &os) const {
  base->display(os);
  os << "." << field;
}

Sexpression *StructRef::ACL2Expr() {
  Symbol *sym = always_cast<const StructType *>(base->get_type())
                    ->getField(field)
                    ->sym;

  Sexpression *s
      = new Plist({ &s_ag, new Plist({ &s_quote, sym }), base->ACL2Expr() });

  return s;
}

Sexpression *StructRef::ACL2Assign(Sexpression *rval) {
  Symbol *sym = always_cast<const StructType *>(base->get_type())
                    ->getField(field)
                    ->sym;

  return base->ACL2Assign(new Plist(
      { &s_as, new Plist({ &s_quote, sym }), rval, base->ACL2Expr() }));
}

// class Subrange : public Expression
// ----------------------------------

// Data members: Expression *base; Expression *high; Expression *low;

Subrange::Subrange(Location loc, Expression *b, Expression *l, unsigned w)
    : Expression(idOf(this), loc), base(b), low(l), width_(w) {
  if (l->isConst())
    high = new Integer(loc_, l->evalConst() + w - 1);
  else {
    high = new BinaryExpr(loc_, l, new Integer(loc_, w - 1), strdup("+"));
    high->set_type(&intType); // TODO
  }
}

void Subrange::display(std::ostream &os) const {
  base->display(os);
  os << "[";
  high->display(os);
  os << ":";
  low->display(os);
  os << "]";
}

Sexpression *Subrange::ACL2Expr() {
  Sexpression *b = base->ACL2Expr();
  Sexpression *hi = high->ACL2Expr();
  Sexpression *lo = low->ACL2Expr();

  Sexpression *bv_val = new Plist({ &s_bits, b, hi, lo });

  const RegType *t = always_cast<const RegType *>(base->get_type());

  if (t->isSigned()) {
    return new Plist({ &s_si, bv_val, new Integer(loc_, width_) });
  } else {
    return bv_val;
  }
}

Sexpression *Subrange::ACL2Assign(Sexpression *rval) {

  Sexpression *b = base->ACL2Expr();
  Sexpression *hi = high->ACL2Expr();
  Sexpression *lo = low->ACL2Expr();

  const RegType *t = always_cast<const RegType *>(base->get_type());
  unsigned n = t->width()->evalConst();

  // If the register is signed, get its 2-complement representation.
  if (t->isSigned()) {
    b = new Plist(
        { &s_bits, b, new Integer(loc_, n - 1), Integer::zero_v(loc_) });
  }

  Integer *s = new Integer(loc_, n);
  Sexpression *val = new Plist({ &s_setbits, b, s, hi, lo, rval });

  // If the register is signed, recover the signed value.
  if (t->isSigned()) {
    val = new Plist({ &s_si, val, new Integer(loc_, n) });
  }

  return base->ACL2Assign(val);
}

// class PrefixExpr : public Expression
// ------------------------------------

// Data members: Expression *expr; const char *op;

PrefixExpr::PrefixExpr(Location loc, Expression *e, const char *o)
    : Expression(idOf(this), loc), expr(e), op(parseOp(o)) {}

PrefixExpr::Op PrefixExpr::parseOp(const char *o) {
  if (false) {
  }
#define APPLY_BINARY_OP(_, __)
#define APPLY_ASSIGN_OP(_, __)
#define APPLY_UNARY_OP(NAME, OP) else if (!strcmp(o, #OP)) return Op::NAME;
#include "operators.def"
#undef APPLY_BINARY_OP
#undef APPLY_ASSIGN_OP
#undef APPLY_UNARY_OP
  else
    UNREACHABLE();
}

bool PrefixExpr::isConst() { return expr->isConst(); }

int PrefixExpr::evalConst() {
  int val = expr->evalConst();
  switch (op) {
  case Op::UnaryPlus:
    return val;
  case Op::UnaryMinus:
    return -val;
  case Op::BitNot:
    return -1 - val;
  case Op::Not:
    return val ? 0 : 1;
  default:
    UNREACHABLE();
  }
}

bool PrefixExpr::isInteger() { return expr->isInteger(); }

std::ostream &operator<<(std::ostream &os, PrefixExpr::Op op) {
  switch (op) {
#define APPLY_BINARY_OP(NAME, OP)
#define APPLY_ASSIGN_OP(_, __)
#define APPLY_UNARY_OP(NAME, OP)                                              \
  case PrefixExpr::Op::NAME:                                                  \
    return os << #OP;
#include "operators.def"
#undef APPLY_BINARY_OP
#undef APPLY_ASSIGN_OP
#undef APPLY_UNARY_OP
  default:
    UNREACHABLE();
  }
}

std::string to_string(PrefixExpr::Op op) {
  std::stringstream ss;
  ss << op;
  return ss.str();
}

void PrefixExpr::display(std::ostream &os) const {
  os << op;
  expr->display(os);
}

Sexpression *PrefixExpr::ACL2Expr() {
  Sexpression *s = expr->ACL2Expr();
  if (op == Op::UnaryPlus) {
    return s;
  } else if (op == Op::UnaryMinus) {
    return new Plist({ &s_minus, s });
  } else if (op == Op::Not) {
    return new Plist({ &s_lognot1, s });
  } else if (op == Op::BitNot) {

    Plist *val = new Plist({ &s_lognot, expr->ACL2Expr() });
    return numeric_cast(val, {}, get_type());
  } else
    UNREACHABLE();
}

// class CastExpr : public Expression
// ----------------------------------

// Data members: Expression *expr; Type *type;

CastExpr::CastExpr(Location loc, Expression *e, Type *t)
    : Expression(idOf(this), loc) {
  expr = e;
  type = t;
}

bool CastExpr::isConst() { return expr->isConst(); }

int CastExpr::evalConst() { return expr->evalConst(); }

bool CastExpr::isInteger() { return expr->isInteger(); }

void CastExpr::display(std::ostream &os) const { expr->display(os); }

Sexpression *CastExpr::ACL2Expr() { return type->ACL2Assign(expr); }

// class BinaryExpr : public Expression
// ------------------------------------

// Data members: Expression *expr1; Expression *expr2; const char *op;

BinaryExpr::BinaryExpr(Location loc, Expression *e1, Expression *e2,
                       const char *o)
    : Expression(idOf(this), loc), expr1(e1), expr2(e2), op(parseOp(o)) {}

BinaryExpr::Op BinaryExpr::parseOp(const char *o) {

  if (false) {
  }
#define APPLY_BINARY_OP(NAME, OP) else if (!strcmp(o, #OP)) return Op::NAME;
#define APPLY_ASSIGN_OP(_, __)
#define APPLY_UNARY_OP(_, __)
#include "operators.def"
#undef APPLY_BINARY_OP
#undef APPLY_ASSIGN_OP
#undef APPLY_UNARY_OP
  else
    UNREACHABLE();
}

bool BinaryExpr::isConst() { return expr1->isConst() && expr2->isConst(); }

int BinaryExpr::evalConst() {
  int val1 = expr1->evalConst();
  int val2 = expr2->evalConst();

  switch (op) {
#define APPLY_BINARY_OP(NAME, OP)                                             \
  case Op::NAME:                                                              \
    return val1 OP val2;
#define APPLY_ASSIGN_OP(_, __)
#define APPLY_UNARY_OP(_, __)
#include "operators.def"
#undef APPLY_BINARY_OP
#undef APPLY_ASSIGN_OP
#undef APPLY_UNARY_OP
  default:
    UNREACHABLE();
  }
}

std::ostream &operator<<(std::ostream &os, BinaryExpr::Op op) {
  switch (op) {
#define APPLY_BINARY_OP(NAME, OP)                                             \
  case BinaryExpr::Op::NAME:                                                  \
    return os << #OP;
#define APPLY_ASSIGN_OP(_, __)
#define APPLY_UNARY_OP(_, __)
#include "operators.def"
#undef APPLY_BINARY_OP
#undef APPLY_ASSIGN_OP
#undef APPLY_UNARY_OP
  default:
    UNREACHABLE();
  }
}

std::string to_string(BinaryExpr::Op op) {
  std::stringstream ss;
  ss << op;
  return ss.str();
}

bool BinaryExpr::isOpShift(Op o) {
  return o == BinaryExpr::Op::RShift || o == BinaryExpr::Op::LShift;
}

bool BinaryExpr::isOpArithmetic(Op o) {
  return o >= BinaryExpr::Op::Plus && o <= BinaryExpr::Op::Mod;
}

bool BinaryExpr::isOpBitwise(Op o) {
  return o >= BinaryExpr::Op::BitAnd && o <= BinaryExpr::Op::BitOr;
}

bool BinaryExpr::isOpCompare(Op o) {
  return o >= BinaryExpr::Op::Less && o <= BinaryExpr::Op::NotEqual;
}

bool BinaryExpr::isOpLogical(Op o) {
  return o == BinaryExpr::Op::And || o == BinaryExpr::Op::Or;
}

bool BinaryExpr::isInteger() {
  return expr1->isInteger() && expr2->isInteger();
}

void BinaryExpr::display(std::ostream &os) const {
  expr1->display(os);
  os << " " << op << " ";
  expr2->display(os);
}

Sexpression *BinaryExpr::ACL2Expr() {

  Symbol *ptr = nullptr;
  Sexpression *sexpr1 = expr1->ACL2Expr();
  Sexpression *sexpr2 = expr2->ACL2Expr();

  if (isa<const FixedPointType *>(expr1->get_type()) && op == Op::LShift) {
    return new Plist({ &s_times, sexpr1,
                       new Plist({ &s_expt, Integer::two_v(loc_), sexpr2 }) });
  } else if (isa<const FixedPointType *>(expr1->get_type())
             && op == Op::RShift) {
    return new Plist({ &s_divide, sexpr1,
                       new Plist({ &s_expt, Integer::two_v(loc_), sexpr2 }) });
  }

  bool need_narrowing = true;

  switch (op) {
  case Op::Plus:
    ptr = &s_plus;
    // AC types are guranted to fit in their result type.
    need_narrowing = !isa<const RegType *>(get_type());
    break;
  case Op::Minus:
    ptr = &s_minus;
    // AC types are guranted to fit in their result type.
    need_narrowing = !isa<const RegType *>(get_type());
    break;
  case Op::Times:
    ptr = &s_times;
    // AC types are guranted to fit in their result type.
    need_narrowing = !isa<const RegType *>(get_type());
    break;
  case Op::Divide:
    // TODO
    return new Plist({ &s_fl, new Plist({ &s_slash, sexpr1, sexpr2 }) });
  case Op::Mod:
    // AC types are guranted to fit in their result type.
    need_narrowing = !isa<const RegType *>(get_type());
    ptr = &s_rem;
    break;
  case Op::LShift:
    ptr = &s_ash;
    break;
  case Op::RShift:
    ptr = &s_ash;
    sexpr2 = new Plist({ &s_minus, sexpr2 });
    break;
  case Op::BitAnd:
    ptr = &s_logand;
    // The result is the same size as the biggest input.
    need_narrowing = false;
    break;
  case Op::BitXor:
    ptr = &s_logxor;
    // The result is the same size as the biggest input.
    need_narrowing = false;
    break;
  case Op::BitOr:
    ptr = &s_logior;
    // The result is the same size as the biggest input.
    need_narrowing = false;
    break;
  case Op::Less:
    ptr = &s_logless;
    // The result is always 0 or 1.
    need_narrowing = false;
    break;
  case Op::Greater:
    ptr = &s_loggreater;
    // The result is always 0 or 1.
    need_narrowing = false;
    break;
  case Op::LessEqual:
    ptr = &s_logleq;
    // The result is always 0 or 1.
    need_narrowing = false;
    break;
  case Op::GreaterEqual:
    ptr = &s_loggeq;
    // The result is always 0 or 1.
    need_narrowing = false;
    break;
  case Op::Equal:
    ptr = &s_logeq;
    // The result is always 0 or 1.
    need_narrowing = false;
    break;
  case Op::NotEqual:
    ptr = &s_logneq;
    // The result is always 0 or 1.
    need_narrowing = false;
    break;
  case Op::And:
    ptr = &s_logand1;
    // The result is always 0 or 1.
    need_narrowing = false;
    break;
  case Op::Or:
    ptr = &s_logior1;
    // The result is always 0 or 1.
    need_narrowing = false;
    break;
  }

  if (!get_type()) {
    prog.diag().report(this->loc(),
                       format("untyped %s", to_string(op).c_str()));
  }

  Sexpression *val = new Plist({ ptr, sexpr1, sexpr2 });

  if (need_narrowing) {
    val = numeric_cast(val, {}, get_type());
  }

  return val;
}

// class CondExpr : public Expression (conditional expression)
// -----------------------------------------------------------

// Data members:  Expression *expr1; Expression *expr2; Expression *test;

CondExpr::CondExpr(Location loc, Expression *e1, Expression *e2, Expression *t)
    : Expression(idOf(this), loc) {
  expr1 = e1;
  expr2 = e2;
  test = t;
}

bool CondExpr::isInteger() { return expr1->isInteger() && expr2->isInteger(); }

void CondExpr::display(std::ostream &os) const {
  test->display(os);
  os << " ? ";
  expr1->display(os);
  os << " : ";
  expr2->display(os);
}

Sexpression *CondExpr::ACL2Expr() {
  return new Plist(
      { &s_if1, test->ACL2Expr(), expr1->ACL2Expr(), expr2->ACL2Expr() });
}

// class MultipleValue : public Expression
// ---------------------------------------

// Data members: MvType *type; Expression *expr[8];

MultipleValue::MultipleValue(Location loc, MvType *t, List<Expression> *e)
    : Expression(idOf(this), loc), type(t) {

  expr.reserve(8);
  for (unsigned i = 0; i < 8 && e; ++i) {
    expr.push_back(e->value);
    e = e->pop();
  }
}

void MultipleValue::display(std::ostream &os) const {

  os << "<";
  bool first = true;
  for (const auto e : expr) {
    if (!first) {
      os << ", ";
    }
    e->display(os);
    first = false;
  }
  os << ">";
}

Sexpression *MultipleValue::ACL2Expr() {

  Plist *result = new Plist({ &s_mv });

  for (unsigned i = 0; i < expr.size(); ++i)
    result->add(type->get(i)->ACL2Assign(expr[i]));
  return result;
}
