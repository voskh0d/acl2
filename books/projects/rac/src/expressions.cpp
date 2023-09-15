#include "expressions.h"
#include "functions.h"
#include "statements.h"

#include <iomanip>


//***********************************************************************************
// class Expression
//***********************************************************************************

bool
Expression::isConst ()
{
  return false;
} // virtual

// Value of expression, applicable to a limited variety of integer-valued
// constant expressions:

int
Expression::evalConst ()
{ // virtual (overridden by constant expressions)
  assert (!"attempt to evaluate a non-constant expression");
  return 0;
}

bool
Expression::isInteger ()
{ // virtual
  return false;
}

// The following expressions have associated types: variable, array, and struct
// references; function calls; cast expressions; applications of "~" to typed
// expressions; and applications of "&", "|", and "^" to typed expressions of
// the same type.  For all other expressions, exprType is undefined:

const Type *
Expression::exprType ()
{ // virtual (overridden by SymRef, Funcall, ArrayRef, StructRef, PrefixExpr,
  // and BinaryExpr)
  // Dereferenced type of expression.
  return nullptr;
}

// The following method converts an expression to an Sexpression to be used as
// an array initialization. It returns the same value as ACL2Expr, except for
// an Initializer:

Sexpression *
Expression::ACL2ArrayExpr ()
{ // virtual (overridden by Initializer)
  return ACL2Expr ();
}

// Translate to an ACL2 assignment with this lvalue and the rvalue given as the
// argument:

Sexpression *
Expression::ACL2Assign ([[maybe_unused]] Sexpression *rval)
{ // virtual (overridden by valid lvalues)
  assert (!"Assigment can be made only to an expression of type SymRef, "
           "ArrayRef, StructRef, BitRef, or Subrange");
  return nullptr;
}

// If a numerical expression is known to have a non-negative value of bounded
// width, then return the bound; otherwise, return 0:

unsigned
Expression::ACL2ValWidth ()
{ // virtual (overridden by BitRef and Subrange)
  const Type *t = get_type ();
  return t ? t->ACL2ValWidth () : 0;
}

// class Constant : public Expression, public Symbol
// -------------------------------------------------

Constant::Constant (const char *n) : Expression (), Symbol (n) {}

Constant::Constant (int n) : Expression (), Symbol (n) {}

bool
Constant::isConst ()
{
  return true;
}

void
Constant::display (std::ostream &os) const
{
  os << getname ();
}

Sexpression *
Constant::ACL2Expr ([[maybe_unused]] bool isBV)
{
  return this;
}

// class Integer : public Constant
// -------------------------------

Integer::Integer (const char *n) : Constant (n) {}

Integer::Integer (int n) : Constant (n) {}

int
Integer::evalConst ()
{
  if (!strncmp (getname (), "0x", 2))
    {
      return strtol (getname () + 2, nullptr, 16);
    }
  else if (!strncmp (getname (), "-0x", 3))
    {
      return -strtol (getname () + 3, nullptr, 16);
    }
  else
    {
      return atoi (getname ());
    }
}

Sexpression *
Integer::ACL2Expr ([[maybe_unused]] bool isBV)
{
  if (!strncmp (getname (), "0x", 2))
    {
      std::string new_name (getname ());
      new_name[0] = '#';
      Symbol *result = new Symbol (std::move (new_name));
      return result;
    }
  else if (!strncmp (getname (), "-0x", 3))
    {
      std::string new_name (getname () + 1);
      new_name[0] = '#';
      Symbol *result = new Symbol (std::move (new_name));
      return new Plist ({ &s_minus, result });
    }
  else
    {
      return this;
    }
}

Integer i_0 ("0");
Integer i_1 ("1");
Integer i_2 ("2");

// class Boolean : public Constant
// -------------------------------
Boolean::Boolean (const char *n) : Constant (n) {}

int
Boolean::evalConst ()
{
  if (!strcmp (getname (), "true"))
    return 1;
  else if (!strcmp (getname (), "false"))
    return 0;
  else
    UNREACHABLE ();
}

Boolean b_true ("true");
Boolean b_false ("false");

Sexpression *
Boolean::ACL2Expr ([[maybe_unused]] bool isBV)
{
  if (!strcmp (getname (), "true"))
    return new Plist ({ &s_true });
  else if (!strcmp (getname (), "false"))
    return new Plist ({ &s_false });
  else // error
    std::cerr << getname () << '\n';
  UNREACHABLE ();
}

// class SymRef : public Expression
// ---------------------------------------------------------------

// Reference to declared symbol, which may be an enumeration constant or a
// variable

// Data member: SymDec *symDec;

SymRef::SymRef (SymDec *s) : Expression () { symDec = s; }

const Type *
SymRef::exprType ()
{
  return symDec->type;
}

bool
SymRef::isConst ()
{
  return symDec->isConst ();
}

int
SymRef::evalConst ()
{
  if (isConst ())
    {
      return symDec->evalConst ();
    }
  else
    {
      assert (!"Attempt to evaluate a non-constant symbol reference.");
    }
}

bool
SymRef::isInteger ()
{
  return isIntegerType (exprType ());
}

void
SymRef::display (std::ostream &os) const
{
  symDec->sym->display (os);
}

Sexpression *
SymRef::ACL2Expr (bool isBV)
{
  Sexpression *s = symDec->ACL2SymExpr ();
  return isBV ? s : get_type ()->ACL2Eval (s);
}

Sexpression *
SymRef::ACL2Assign (Sexpression *rval)
{
  return new Plist ({ &s_assign, symDec->sym, rval });
}

// class FunCall : public Expression (function call)
// -------------------------------------------------

// Data members:  FunDef *func; List<Expression> *args;

FunCall::FunCall (FunDef *f, List<Expression> *a) : Expression ()
{
  func = f;
  args = a;
}

const Type *
FunCall::exprType ()
{
  return func->returnType;
}

bool
FunCall::isInteger ()
{
  return isIntegerType (exprType ());
}

void
FunCall::display (std::ostream &os) const
{

  os << func->getname () << "(";
  bool is_first = true;
  for_each (args, [&] (Expression *e) {
    if (!is_first)
      os << ", ";
    e->display (os);
    is_first = false;
  });

  os << ")";
}

Sexpression *
FunCall::ACL2Expr (bool isBV)
{
  Plist *result = new Plist ({ new Symbol (func->getname ()) });
  List<VarDec> *p = func->params;
  List<Expression> *a = args;
  while (a)
    {
      result->add (p->value->type->ACL2Assign (a->value));
      a = a->next;
      p = p->next;
    }
  return isBV ? result : get_type ()->ACL2Eval (result);
}

// class TempCall : public Expression (function template Data)
// -------------------------------------------------

// call members:  Symbol *instanceSym; List<Expression> *params;

TempCall::TempCall (Template *f, List<Expression> *a, List<Expression> *p)
    : FunCall (f, a)
{
  params = p;
  if (f->calls == nullptr)
    {
      f->calls = new List<TempCall> (this);
    }
  else
    {
      f->calls->add (this);
    }
}

void
TempCall::display (std::ostream &os) const
{
  os << func->getname () << "<";
  List<Expression> *ptr = params;
  while (ptr)
    {
      ptr->value->display (os);
      if (ptr->next)
        os << ", ";
      ptr = ptr->next;
    }
  os << ">(";
  ptr = args;
  while (ptr)
    {
      ptr->value->display (os);
      if (ptr->next)
        os << ", ";
      ptr = ptr->next;
    }
  os << ")";
}

Sexpression *
TempCall::ACL2Expr (bool isBV)
{
  dynamic_cast<Template *>(func)->bindParams (params);
  Plist *result = dynamic_cast<Plist *> (FunCall::ACL2Expr (isBV));
  result->list->value = instanceSym;
  return result;
}

// class Initializer : public Expression (array initializer)
// ---------------------------------------------------------

// Data member:  List<Constant> *vals;

Initializer::Initializer (List<Constant> *v) : Expression () { vals = v; }

void
Initializer::display (std::ostream &os) const
{
  os << "{";
  List<Constant> *ptr = vals;
  while (ptr)
    {
      ptr->value->Symbol::display (os);
      if (ptr->next)
        os << ", ";
      ptr = ptr->next;
    }
  os << "}";
}

Sexpression *
Initializer::ACL2Expr ([[maybe_unused]] bool isBV)
{
  BigList<Sexpression> *result
      = new BigList<Sexpression> ((Sexpression *)(vals->value->ACL2Expr ()));
  List<Constant> *ptr = vals->next;
  while (ptr)
    {
      result->add ((Sexpression *)(ptr->value->ACL2Expr ()));
      ptr = ptr->next;
    }
  return Plist::FromList (result->front ());
}

Sexpression *
Initializer::ACL2ArrayExpr ()
{
  List<Sexpression> *entries = ((Plist *)(ACL2Expr ()))->list;
  Plist *p = new Plist ();
  unsigned i = 0;
  while (entries)
    {
      if (strcmp (((Constant *)(entries->value))->getname (), "0"))
        {
          p->add (new Cons (new Integer (i), entries->value));
        }
      i++;
      entries = entries->next;
    }
  if (p->list)
    {
      p = new Plist ({ &s_quote, p });
    }
  return p;
}

Sexpression *
Initializer::ACL2StructExpr (const std::vector<StructField *>& fields)
{
  Sexpression *result = new Plist ();
  List<Constant> *ptr = vals;
  assert (vals->length () == fields.size());

  for (auto f : fields) {
      result = new Plist ({
          &s_as,
          new Plist ({ &s_quote, f->sym }),
          ptr->value->ACL2Expr (),
          result
          });
      ptr = ptr->next;
    }
  return result;
}

// class ArrayRef : public Expression
// ----------------------------------

// Data members:  Expression *array; Expression *index;

ArrayRef::ArrayRef (Expression *a, Expression *i) : Expression ()
{
  array = a;
  index = i;
}

const Type *
ArrayRef::exprType ()
{
  return tryDownCast<ArrayType>(array->exprType ())->getBaseType ();
}

bool
ArrayRef::isInteger ()
{
  return isIntegerType (exprType ());
}

void
ArrayRef::display (std::ostream &os) const
{
  array->display (os);
  os << "[";
  index->display (os);
  os << "]";
}

Sexpression *
ArrayRef::ACL2Expr (bool isBV)
{
  Sexpression *s = nullptr;
  SymRef *ref = dynamic_cast<SymRef *>(array);

  if (ref && ref->symDec->isROM ())
    {
      s = new Plist ({ &s_nth,
                        index->ACL2Expr (),
                        new Plist ({ ref->symDec->sym }) });
    }
  else if (ref && ref->symDec->isGlobal ())
    {
      s = new Plist ({ &s_ag,
                        index->ACL2Expr (),
                        new Plist ({ ref->symDec->sym }) });
    }
  else
    {
      s = new Plist ({ &s_ag,
                        index->ACL2Expr (),
                        array->ACL2Expr () });
    }
  return isBV ? s : get_type ()->ACL2Eval (s);
}

Sexpression *
ArrayRef::ACL2Assign (Sexpression *rval)
{
  return array->ACL2Assign (
      new Plist ({ &s_as, index->ACL2Expr (), rval, array->ACL2Expr () }));
}

// class StructRef : public Expression
// -----------------------------------

// Data members:  Expression *base; char *field;

StructRef::StructRef (Expression *s, char *f) : Expression ()
{
  base = s;
  field = f;
}

const Type *
StructRef::exprType ()
{
  const StructType *t = tryDownCast<StructType>(base->exprType ());
  return t->getField(field)->type;
}

bool
StructRef::isInteger ()
{
  return isIntegerType (exprType ());
}

void
StructRef::display (std::ostream &os) const
{
  base->display (os);
  os << "." << field;
}

Sexpression *
StructRef::ACL2Expr (bool isBV)
{
  Symbol *sym = tryDownCast<StructType>(base->get_type())->getField(field)->sym;

  Sexpression *s = new Plist (
      { &s_ag, new Plist ({ &s_quote, sym }), base->ACL2Expr () });

  return isBV ? s : get_type()->ACL2Eval (s);
}

Sexpression *
StructRef::ACL2Assign (Sexpression *rval)
{
  Symbol *sym = tryDownCast<StructType>(base->get_type())->getField(field)->sym;

  return base->ACL2Assign (new Plist (
      { &s_as, new Plist ({ &s_quote, sym }), rval, base->ACL2Expr () }));
}

// class BitRef : public Expression
// --------------------------------

// Data members: Expression *base; Expression *index;

BitRef::BitRef (Expression *b, Expression *i) : Expression ()
{
  base = b;
  index = i;
}

bool
BitRef::isInteger ()
{
  return true;
}

const Type *
BitRef::exprType() {
  // here should return a bool (according to ac_types ref).
//  return new UintType(new Integer(1));
  return nullptr;
}

void
BitRef::display (std::ostream &os) const
{
  base->display (os);
  os << "[";
  index->display (os);
  os << "]";
}

Sexpression *
BitRef::ACL2Expr ([[maybe_unused]] bool isBV)
{
  Sexpression *b = base->ACL2Expr (true);
  Sexpression *i = index->ACL2Expr ();
  return new Plist ({ &s_bitn, b, i });
}

Sexpression *
BitRef::ACL2Assign (Sexpression *rval)
{
  Sexpression *b = base->ACL2Expr (true);
  Sexpression *i = index->ACL2Expr ();
  unsigned n = tryDownCast<RegType>(base->get_type())
    ->width ()
    ->evalConst ();
  Integer *s = new Integer (n);
  return base->ACL2Assign (new Plist ({ &s_setbitn, b, s, i, rval }));
}


//unsigned
//BitRef::ACL2ValWidth ()
//{
//  return 1;
//}

// class Subrange : public Expression
// ----------------------------------

// Data members: Expression *base; Expression *high; Expression *low;

Subrange::Subrange (Expression *b, Expression *l, unsigned w)
    : Expression ()
    , base(b)
    , low(l)
    , width_(w)
{
  if (l->isConst ())
    high = new Integer (l->evalConst () + w - 1);
  else
    high = new BinaryExpr (l, new Integer (w - 1), strdup ("+"));
}

void
Subrange::display (std::ostream &os) const
{
  base->display (os);
  os << "[";
  high->display (os);
  os << ":";
  low->display (os);
  os << "]";
}

const Type *
Subrange::exprType() {

  Integer *width = new Integer(this->width_);

  if (const RegType *t = tryDownCast<RegType>(base->get_type())) {

    if (t->isSigned()) {
      return new IntType(width);
    } else {
      return new UintType(width);
    }
  } else {
    return nullptr;
  }
}

Sexpression *
Subrange::ACL2Expr ([[maybe_unused]] bool isBV)
{
  Sexpression *b = base->ACL2Expr (true); // here
  Sexpression *hi = high->ACL2Expr ();
  Sexpression *lo = low->ACL2Expr ();

  Sexpression *bv_val = new Plist ({ &s_bits, b, hi, lo });

  if (const RegType *t = tryDownCast<RegType>(base->get_type())) {

    if (t->isSigned()) {
      return new Plist ({ &s_si, bv_val, new Integer (width_) });
    } else {
      return bv_val;
    }
  } else {
    return bv_val;
  }
}

Sexpression *
Subrange::ACL2Assign (Sexpression *rval)
{
  Sexpression *b = base->ACL2Expr (true);
  Sexpression *hi = high->ACL2Expr ();
  Sexpression *lo = low->ACL2Expr ();

  unsigned n = tryDownCast<RegType>(base->get_type())
    ->width ()
    ->evalConst ();

  Integer *s = new Integer (n);
  return base->ACL2Assign (new Plist ({ &s_setbits, b, s, hi, lo, rval }));
}

// class PrefixExpr : public Expression
// ------------------------------------

// Data members: Expression *expr; const char *op;

PrefixExpr::PrefixExpr (Expression *e, const char *o) : Expression ()
{
  expr = e;
  op = o;
}

bool
PrefixExpr::isConst ()
{
  return expr->isConst ();
}

int
PrefixExpr::evalConst ()
{
  int val = expr->evalConst ();
  if (!strcmp (op, "+"))
    {
      return val;
    }
  else if (!strcmp (op, "-"))
    {
      return -val;
    }
  else if (!strcmp (op, "~"))
    {
      return -1 - val;
    }
  else if (!strcmp (op, "!"))
    {
      return val ? 1 : 0;
    }
  else
    UNREACHABLE ();
}

bool
PrefixExpr::isInteger ()
{
  return expr->isInteger ();
}

void
PrefixExpr::display (std::ostream &os) const
{
  os << op;
  expr->display (os);
}

const Type *
PrefixExpr::exprType ()
{
  if (!strcmp (op, "~"))
    {
      // TODO: ac_int<W+!S, true>
      return expr->exprType ();
    }
  else
    {
      return nullptr;
    }
}

Sexpression *
PrefixExpr::ACL2Expr (bool isBV)
{
  Sexpression *s = expr->ACL2Expr ();
  if (!strcmp (op, "+"))
    {
      return s;
    }
  else if (!strcmp (op, "-"))
    {
      return new Plist ({ &s_minus, s });
    }
  else if (!strcmp (op, "!"))
    {
      return new Plist ({ &s_lognot1, s });
    }
  else if (!strcmp (op, "~"))
    {
      const Type *t = get_type();
      if (t)
        {
          Plist *bv = new Plist ({ &s_lognot, expr->ACL2Expr (true) });
          if (isBV && isRegType (t))
            {
              unsigned w = tryDownCast<RegType>(t)
                ->width ()
                ->evalConst ();
              return new Plist ({ &s_bits, bv, new Integer (w - 1), &i_0 });
            }
          else
            {
              return t->ACL2Eval (bv);
              //?? return bv;
            }
        }
      else
        {
          return new Plist ({ &s_lognot, s });
        }
    }
  else
    UNREACHABLE ();
}

// class CastExpr : public Expression
// ----------------------------------

// Data members: Expression *expr; Type *type;

CastExpr::CastExpr (Expression *e, Type *t) : Expression ()
{
  expr = e;
  type = t;
}

const Type *
CastExpr::exprType ()
{
  return type;
}

bool
CastExpr::isConst ()
{
  return expr->isConst ();
}

int
CastExpr::evalConst ()
{
  return expr->evalConst ();
}

bool
CastExpr::isInteger ()
{
  return expr->isInteger ();
}

void
CastExpr::display (std::ostream &os) const
{
  expr->display (os);
}

Sexpression *
CastExpr::ACL2Expr ([[maybe_unused]] bool isBV)
{
  return type->ACL2Assign(expr);
}

// class BinaryExpr : public Expression
// ------------------------------------

// Data members: Expression *expr1; Expression *expr2; const char *op;

BinaryExpr::BinaryExpr (Expression *e1, Expression *e2, const char *o)
    : Expression ()
{
  expr1 = e1;
  expr2 = e2;
  op = o;
}

bool
BinaryExpr::isConst ()
{
  return expr1->isConst () && expr2->isConst ();
}

int
BinaryExpr::evalConst ()
{
  int val1 = expr1->evalConst ();
  int val2 = expr2->evalConst ();
  if (!strcmp (op, "+"))
    return val1 + val2;
  if (!strcmp (op, "-"))
    return val1 - val2;
  if (!strcmp (op, "*"))
    return val1 * val2;
  if (!strcmp (op, "/"))
    return val1 / val2;
  if (!strcmp (op, "%"))
    return val1 % val2;
  if (!strcmp (op, "<<"))
    return val1 << val2;
  if (!strcmp (op, ">>"))
    return val1 >> val2;
  if (!strcmp (op, "&"))
    return val1 & val2;
  if (!strcmp (op, "^"))
    return val1 ^ val2;
  if (!strcmp (op, "|"))
    return val1 | val2;
  if (!strcmp (op, "<"))
    return val1 < val2;
  if (!strcmp (op, ">"))
    return val1 > val2;
  if (!strcmp (op, "<="))
    return val1 <= val2;
  if (!strcmp (op, ">="))
    return val1 >= val2;
  if (!strcmp (op, "=="))
    return val1 == val2;
  if (!strcmp (op, "!="))
    return val1 != val2;
  if (!strcmp (op, "&&"))
    return val1 && val2;
  if (!strcmp (op, "||"))
    return val1 || val2;
  UNREACHABLE ();
}

bool
BinaryExpr::isInteger ()
{
  return expr1->isInteger () && expr2->isInteger ();
}

void
BinaryExpr::display (std::ostream &os) const
{
  expr1->display (os);
  os << " " << op << " ";
  expr2->display (os);
}

const Type *
BinaryExpr::exprType ()
{
  const Type *t1 = expr1->exprType ();
  const Type *t2 = expr2->exprType ();
  if ((!strcmp (op, "&") || !strcmp (op, "|") || !strcmp (op, "^"))
      && (t1 == t2))
    {
      return t1;
    }
  else
    {
      return nullptr;
    }
}

Sexpression *
BinaryExpr::ACL2Expr (bool isBV)
{
  Symbol *ptr;
  Sexpression *sexpr1 = expr1->ACL2Expr ();
  Sexpression *sexpr2 = expr2->ACL2Expr ();
  if (isFPType(expr1->get_type()) && !strcmp (op, "<<"))
    {
      return new Plist (
          { &s_times, sexpr1, new Plist ({ &s_expt, &i_2, sexpr2 }) });
    }
  else if (isFPType(expr1->get_type()) && !strcmp (op, ">>"))
    {
      return new Plist (
          { &s_divide, sexpr1, new Plist ({ &s_expt, &i_2, sexpr2 }) });
    }
  if (!strcmp (op, "+"))
    ptr = &s_plus;
  else if (!strcmp (op, "-"))
    ptr = &s_minus;
  else if (!strcmp (op, "*"))
    ptr = &s_times;
  else if (!strcmp (op, "/"))
    return new Plist ({ &s_fl, new Plist ({ &s_slash, sexpr1, sexpr2 }) });
  else if (!strcmp (op, "%"))
    ptr = &s_rem;
  else if (!strcmp (op, "<<"))
    ptr = &s_ash;
  else if (!strcmp (op, ">>"))
    {
      ptr = &s_ash;
      sexpr2 = new Plist ({ &s_minus, sexpr2 });
    }
  else if (!strcmp (op, "&"))
    ptr = &s_logand;
  else if (!strcmp (op, "^"))
    ptr = &s_logxor;
  else if (!strcmp (op, "|"))
    ptr = &s_logior;
  else if (!strcmp (op, "<"))
    ptr = &s_logless;
  else if (!strcmp (op, ">"))
    ptr = &s_loggreater;
  else if (!strcmp (op, "<="))
    ptr = &s_logleq;
  else if (!strcmp (op, ">="))
    ptr = &s_loggeq;
  else if (!strcmp (op, "=="))
    ptr = &s_logeq;
  else if (!strcmp (op, "!="))
    ptr = &s_logneq;
  else if (!strcmp (op, "&&"))
    ptr = &s_logand1;
  else if (!strcmp (op, "||"))
    ptr = &s_logior1;
  else
    UNREACHABLE ();
  if (get_type()
      && (ptr == &s_logand || ptr == &s_logior || ptr == &s_logxor))
    {
      Plist *bv = new Plist (
          { ptr, expr1->ACL2Expr (true), expr2->ACL2Expr (true) });
      return isBV ? bv : get_type()->ACL2Eval (bv);
    }
  else
    {
      return new Plist ({ ptr, sexpr1, sexpr2 });
    }
}

// class CondExpr : public Expression (conditional expression)
// -----------------------------------------------------------

// Data members:  Expression *expr1; Expression *expr2; Expression *test;

CondExpr::CondExpr (Expression *e1, Expression *e2, Expression *t)
    : Expression ()
{
  expr1 = e1;
  expr2 = e2;
  test = t;
}

bool
CondExpr::isInteger ()
{
  return expr1->isInteger () && expr2->isInteger ();
}

void
CondExpr::display (std::ostream &os) const
{
  test->display (os);
  os << " ? ";
  expr1->display (os);
  os << " : ";
  expr2->display (os);
}

Sexpression *
CondExpr::ACL2Expr ([[maybe_unused]] bool isBV)
{
  return new Plist (
      { &s_if1, test->ACL2Expr (), expr1->ACL2Expr (), expr2->ACL2Expr () });
}

// class MultipleValue : public Expression
// ---------------------------------------

// Data members: MvType *type; Expression *expr[8];

MultipleValue::MultipleValue (MvType *t, List<Expression> *e)
    : Expression (), type (t)
{

  expr.reserve (8);
  for (unsigned i = 0; i < 8 && e; ++i)
    {
      expr.push_back (e->value);
      e = e->pop ();
    }

  assert (expr.size () >= 2
          && "It does not make sense to have a mv with 1 or 0 elem");
  assert (type->size () == expr.size ()
          && "We should have as many types as values");
}

void
MultipleValue::display (std::ostream &os) const
{

  os << "<";
  bool first = true;
  for (const auto e : expr)
    {
      if (!first)
        {
          os << ", ";
        }
      e->display (os);
    }
  os << ">";
}

Sexpression *
MultipleValue::ACL2Expr ([[maybe_unused]] bool isBV)
{

  Plist *result = new Plist ({ &s_mv });

  for (unsigned i = 0; i < expr.size (); ++i)
      result->add (type->get(i)->ACL2Assign (expr[i]));
  return result;
}
