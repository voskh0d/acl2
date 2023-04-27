#include <iomanip>

#include "expressions.h"
#include "functions.h"
#include "statements.h"

// class Integer : public Constant
// -------------------------------

Integer::Integer(const char *n) : Constant(n) {}

Integer::Integer(int n) : Constant(n) {}

// FIXME should be at least long.
int Integer::evalConst() const {
  if (!strncmp(getname(), "0x", 2)) {
    return strtol(getname() + 2, nullptr, 16);
  } else if (!strncmp(getname(), "-0x", 3)) {
    return -strtol(getname() + 3, nullptr, 16);
  } else {
    return atoi(getname());
  }
}

Sexpression *Integer::ACL2Expr([[maybe_unused]] bool isBV) {
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

Integer i_0("0");
Integer i_1("1");
Integer i_2("2");

// class Boolean : public Constant
// -------------------------------
Boolean::Boolean(const char *n) : Constant(n) {}

int Boolean::evalConst() const {
  if (!strcmp(getname(), "true"))
    return 1;
  else if (!strcmp(getname(), "false"))
    return 0;
  else
    UNREACHABLE();
}

Boolean b_true("true");
Boolean b_false("false");

Sexpression *Boolean::ACL2Expr([[maybe_unused]] bool isBV) {
  if (!strcmp(getname(), "true"))
    return new Plist({ &s_true });
  else if (!strcmp(getname(), "false"))
    return new Plist({ &s_false });
  else
    cout << getname() << endl;
  UNREACHABLE();
}

// class SymRef : public Expression
// ---------------------------------------------------------------

// Reference to declared symbol, which may be an enumeration constant or a
// variable

// Data member: SymDec *symDec;

SymRef::SymRef(SymDec *s) : Expression() { symDec = s; }

Type *SymRef::exprType() {
  assert(symDec->type->derefType());
  return symDec->type->derefType();
}

bool SymRef::isConst() const { return symDec->isConst(); }

int SymRef::evalConst() const {
  if (isConst()) {
    return symDec->evalConst();
  } else {
    assert(!"Attempt to evaluate a non-constant symbol reference.");
  }
}

bool SymRef::isArray() { return isa<ArrayType>(exprType()); }

bool SymRef::isStruct() { return isa<StructType>(exprType()); }

bool SymRef::isInteger() { return exprType()->isIntegerType(); }

void SymRef::displayNoParens(ostream &os) const { symDec->sym->display(os); }

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

FunCall::FunCall(FunDef *f, List<Expression> *a) : Expression() {
  func = f;
  args = a;
}

Type *FunCall::exprType() {
  assert(func->returnType->derefType());
  return func->returnType->derefType();
}

bool FunCall::isArray() { return isa<ArrayType>(exprType()); }

bool FunCall::isStruct() { return isa<StructType>(exprType()); }

bool FunCall::isInteger() { return exprType()->isIntegerType(); }

void FunCall::displayNoParens(ostream &os) const {

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
  return new FunCall(func, newArgs);
}

Sexpression *FunCall::ACL2Expr(bool isBV) {
  Plist *result = new Plist({ new Symbol(func->getname()) });
  List<VarDec> *p = func->params;
  List<Expression> *a = args;
  while (a) {
    result->add(p->value->type->derefType()->ACL2Assign(a->value));
    a = a->next;
    p = p->next;
  }
  return isBV ? result : exprType()->ACL2Eval(result);
}

// class TempCall : public Expression (function template Data)
// -------------------------------------------------

// call members:  Symbol *instanceSym; List<Expression> *params;

TempCall::TempCall(Template *f, List<Expression> *a, List<Expression> *p)
    : FunCall(f, a) {
  params = p;
  if (f->calls == nullptr) {
    f->calls = new List<TempCall>(this);
  } else {
    f->calls->add(this);
  }
}

void TempCall::displayNoParens(ostream &os) const {
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

Initializer::Initializer(List<Constant> *v) : Expression() { vals = v; }

void Initializer::displayNoParens(ostream &os) const {
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
      p->add(new Cons(new Integer(i), entries->value));
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

ArrayRef::ArrayRef(Expression *a, Expression *i) : Expression() {
  array = a;
  index = i;
}

Type *ArrayRef::exprType() {
  assert(((ArrayType *)(array->exprType()))->getBaseType());
  return ((ArrayType *)(array->exprType()))->getBaseType();
}

bool ArrayRef::isArray() { return isa<ArrayType>(exprType()); }

bool ArrayRef::isInteger() { return exprType()->isIntegerType(); }

void ArrayRef::displayNoParens(ostream &os) const {
  array->display(os);
  os << "[";
  index->display(os);
  os << "]";
}

Expression *ArrayRef::subst(SymRef *var, Expression *val) {
  Expression *newIndex = index->subst(var, val);
  return (newIndex == index) ? this : new ArrayRef(array, newIndex);
}

Sexpression *ArrayRef::ACL2Expr(bool isBV) {
  Sexpression *s;

  auto *refT = dynamic_cast<SymRef *>(array);
  if (refT && refT->symDec->isROM()) {
    s = new Plist(
        { &s_nth, index->ACL2Expr(), new Plist({ refT->symDec->sym }) });
  } else if (refT && refT->symDec->isGlobal()) {
    s = new Plist(
        { &s_ag, index->ACL2Expr(), new Plist({ refT->symDec->sym }) });
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

ArrayParamRef::ArrayParamRef(Expression *a, Expression *i) : ArrayRef(a, i) {}

Expression *ArrayParamRef::subst(SymRef *var, Expression *val) {
  Expression *newIndex = index->subst(var, val);
  return (newIndex == index) ? this : new ArrayParamRef(array, newIndex);
}

void ArrayParamRef::displayNoParens(ostream &os) const {
  array->display(os);
  os << "[";
  index->display(os);
  os << "]";
}

// class StructRef : public Expression
// -----------------------------------

// Data members:  Expression *base; char *field;

StructRef::StructRef(Expression *s, char *f) : Expression() {
  base = s;
  field = f;
}

Type *StructRef::exprType() {

  assert(((StructType *)(base->exprType()))
             ->fields->find(field)
             ->type->derefType());
  return ((StructType *)(base->exprType()))
      ->fields->find(field)
      ->type->derefType();
}

bool StructRef::isArray() { return isa<ArrayType>(exprType()); }

bool StructRef::isInteger() { return exprType()->isIntegerType(); }

void StructRef::displayNoParens(ostream &os) const {
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

BitRef::BitRef(Expression *b, Expression *i) : Expression() {
  base = b;
  index = i;
}

bool BitRef::isInteger() { return true; }

void BitRef::displayNoParens(ostream &os) const {
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
             : new BitRef(newBase, newIndex);
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
  Integer *s = new Integer(n);
  return base->ACL2Assign(new Plist({ &s_setbitn, b, s, i, rval }));
}

// class Subrange : public Expression
// ----------------------------------

// Data members: Expression *base; Expression *high; Expression *low;

Subrange::Subrange(Expression *b, Expression *h, Expression *l)
    : Expression() {
  base = b;
  high = h;
  low = l;
  width_ = std::nullopt;
}

Subrange::Subrange(Expression *b, Expression *h, Expression *l, unsigned w)
    : Expression() {
  base = b;
  high = h;
  low = l;
  width_ = { w };
}

bool Subrange::isSubrange() { return true; }

bool Subrange::isInteger() { return true; }

void Subrange::displayNoParens(ostream &os) const {
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
             : new Subrange(newBase, newHigh, newLow);
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
  Integer *s = new Integer(n);
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

PrefixExpr::PrefixExpr(Expression *e, const char *o) : Expression() {
  expr = e;
  op = o;
}

bool PrefixExpr::isConst() const { return expr->isConst(); }

int PrefixExpr::evalConst() const {
  int val = expr->evalConst();
  if (!strcmp(op, "+")) {
    return val;
  } else if (!strcmp(op, "-")) {
    return -val;
  } else if (!strcmp(op, "~")) {
    return -1 - val;
  } else if (!strcmp(op, "!")) {
    return val ? 1 : 0;
  } else
    UNREACHABLE();
}

bool PrefixExpr::isInteger() { return expr->isInteger(); }

void PrefixExpr::displayNoParens(ostream &os) const {
  os << op;
  expr->display(os);
}

Expression *PrefixExpr::subst(SymRef *var, Expression *val) {
  Expression *newExpr = expr->subst(var, val);
  return (newExpr == expr) ? this : new PrefixExpr(newExpr, op);
}

Type *PrefixExpr::exprType() {
  if (!strcmp(op, "~")) {
    return expr->exprType();
  } else {
    return nullptr;
  }
}

Sexpression *PrefixExpr::ACL2Expr(bool isBV) {
  Sexpression *s = expr->ACL2Expr();
  if (!strcmp(op, "+")) {
    return s;
  } else if (!strcmp(op, "-")) {
    return new Plist({ &s_minus, s });
  } else if (!strcmp(op, "!")) {
    return new Plist({ &s_lognot1, s });
  } else if (!strcmp(op, "~")) {
    Type *t = exprType();
    if (t) {
      Plist *bv = new Plist({ &s_lognot, expr->ACL2Expr(true) });
      auto *regT = dynamic_cast<RegType *>(t);
      if (bv && regT) {
        unsigned w = regT->width()->evalConst();
        return new Plist({ &s_bits, bv, new Integer(w - 1), &i_0 });
      } else {
        return t->ACL2Eval(bv);
        //?? return bv;
      }
    } else {
      return new Plist({ &s_lognot, s });
    }
  } else
    UNREACHABLE();
}

bool PrefixExpr::isEqual(Expression *e) {
  return this == e || e->isEqualPrefix(op, expr);
}

bool PrefixExpr::isEqualPrefix(const char *o, Expression *e) {
  return !strcmp(o, op) && e->isEqual(expr);
}

// class CastExpr : public Expression
// ----------------------------------

// Data members: Expression *expr; Type *type;

CastExpr::CastExpr(Expression *e, Type *t) : Expression() {
  expr = e;
  type = t;
}

Type *CastExpr::exprType() { return type; }

bool CastExpr::isConst() const { return expr->isConst(); }

int CastExpr::evalConst() const { return expr->evalConst(); }

bool CastExpr::isInteger() { return expr->isInteger(); }

void CastExpr::displayNoParens(ostream &os) const { expr->display(os); }

Expression *CastExpr::subst(SymRef *var, Expression *val) {
  Expression *newExpr = expr->subst(var, val);
  return (newExpr == expr) ? this : new CastExpr(newExpr, type);
}

Sexpression *CastExpr::ACL2Expr([[maybe_unused]] bool isBV) {
  return expr->ACL2Expr();
}

// class BinaryExpr : public Expression
// ------------------------------------

// Data members: Expression *expr1; Expression *expr2; const char *op;

BinaryExpr::BinaryExpr(Expression *e1, Expression *e2, const char *o)
    : Expression() {
  expr1 = e1;
  expr2 = e2;
  op = o;
}

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

void BinaryExpr::displayNoParens(ostream &os) const {
  expr1->display(os);
  os << " " << op << " ";
  expr2->display(os);
}

Expression *BinaryExpr::subst(SymRef *var, Expression *val) {
  Expression *newExpr1 = expr1->subst(var, val);
  Expression *newExpr2 = expr2->subst(var, val);
  return (newExpr1 == expr1 && newExpr2 == expr2)
             ? this
             : new BinaryExpr(newExpr1, newExpr2, op);
}

Type *BinaryExpr::exprType() {
  Type *t1 = expr1->exprType();
  Type *t2 = expr2->exprType();
  if ((!strcmp(op, "&") || !strcmp(op, "|") || !strcmp(op, "^"))
      && (t1 == t2)) {
    return t1;
  } else {
    return t2;
    //    TODO(); // This should not happen since it would be run after the
    //    type
    //            // pass.
    //    return nullptr;
  }
}

Sexpression *BinaryExpr::ACL2Expr(bool isBV) {
  Symbol *ptr;
  Sexpression *sexpr1 = expr1->ACL2Expr();
  Sexpression *sexpr2 = expr2->ACL2Expr();
  if (expr1->isFP() && !strcmp(op, "<<")) {
    return new Plist(
        { &s_times, sexpr1, new Plist({ &s_expt, &i_2, sexpr2 }) });
  } else if (expr1->isFP() && !strcmp(op, ">>")) {
    return new Plist(
        { &s_divide, sexpr1, new Plist({ &s_expt, &i_2, sexpr2 }) });
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

CondExpr::CondExpr(Expression *e1, Expression *e2, Expression *t)
    : Expression() {
  expr1 = e1;
  expr2 = e2;
  test = t;
}

bool CondExpr::isInteger() { return expr1->isInteger() && expr2->isInteger(); }

void CondExpr::displayNoParens(ostream &os) const {
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
             : new CondExpr(newExpr1, newExpr2, newTest);
}

Sexpression *CondExpr::ACL2Expr([[maybe_unused]] bool isBV) {
  return new Plist(
      { &s_if1, test->ACL2Expr(), expr1->ACL2Expr(), expr2->ACL2Expr() });
}

// class MultipleValue : public Expression
// ---------------------------------------

// Data members: MvType *type; Expression *expr[8];

MultipleValue::MultipleValue(MvType *t, List<Expression> *e)
    : Expression(), type(t) {

  expr.reserve(8);
  for (unsigned i = 0; i < 8 && e; ++i) {
    expr.push_back(e->value);
    e = e->pop();
  }

  assert(expr.size() >= 2
         && "It does not make sense to have a mv with 1 or 0 elem");
  assert(type->type.size() == expr.size()
         && "We should have as many types as values");
}

void MultipleValue::displayNoParens(ostream &os) const {

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
  return isNew ? new MultipleValue(type, std::move(newExpr)) : this;
}

Sexpression *MultipleValue::ACL2Expr([[maybe_unused]] bool isBV) {

  Plist *result = new Plist({ &s_mv });

  for (unsigned i = 0; i < expr.size(); ++i) {
    result->add(type->type[i]->derefType()->ACL2Assign(expr[i]));
  }
  return result;
}
