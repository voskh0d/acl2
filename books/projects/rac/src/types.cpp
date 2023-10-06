#include "expressions.h"
#include "statements.h"
#include "types.h"

#include <algorithm>
#include <iomanip>

//***********************************************************************************
// class Type
//***********************************************************************************

Sexpression *
Type::ACL2Assign(Expression *rval) const { // virtual (overridden by RegType)
  // Convert rval to an S-expression to be assigned to an object of this type.
  return rval->ACL2Expr();
}

// class PrimType : public Symbol, public Type (Primitive type)
// ------------------------------------------------------------

PrimType boolType = PrimType::Bool();
PrimType intType = PrimType::Int();
PrimType uintType = PrimType::Uint();
PrimType int64Type = PrimType::Int64();
PrimType uint64Type = PrimType::Uint64();

Type *PrimType::usual_conversions(const PrimType *t1, const PrimType *t2) {

  // Integer promotion.
  PrimType *t1_promoted = new PrimType(*t1);
  t1_promoted->integerPromtion();

  PrimType *t2_promoted = new PrimType(*t2);
  t2_promoted->integerPromtion();

  // If T1 and T2 are the same type, C is that type.
  // Otherwise, if T1 and T2 are both signed integer types or both unsigned
  // integer types, C is the type of greater integer conversion rank.
  if (t1_promoted->signed_ == t2_promoted->signed_) {
    if (t1_promoted->rank_ >= t2_promoted->rank_) {
      delete t2_promoted;
      return t1_promoted;
    } else {
      delete t1_promoted;
      return t2_promoted;
    }
  }

  PrimType *unsigned_type = nullptr;
  PrimType *signed_type = nullptr;
  if (t1_promoted->signed_) {
    unsigned_type = t2_promoted;
    signed_type = t1_promoted;
  } else {
    unsigned_type = t1_promoted;
    signed_type = t2_promoted;
  }

  // If the integer conversion rank of U is greater than or equal to the
  // integer conversion rank of S, C is U.
  if (unsigned_type->rank_ >= signed_type->rank_) {
    delete signed_type;
    return unsigned_type;
  } else {
    // Otherwise, if S can represent all of the values of U, C is S.
    delete unsigned_type;
    return signed_type;
  }
}

// class RegType : public Type (Algorithmic C register type)
// ---------------------------------------------------

// Data member:  Expression *width

Sexpression *
RegType::ACL2Assign(Expression *rval) const { // overridden by FPType

  const RegType *rval_type = dynamic_cast<const RegType *>(rval->get_type());
  unsigned w = rval->ACL2ValWidth();

  int width_evaluated = width_->evalConst();
  assert(width_evaluated >= 0);

  // TODO *rval_type == *this
  if (rval_type == this || (w && w <= (unsigned)width_evaluated)) {
    return rval->ACL2Expr(true);
  } else {
    assert(width_evaluated);

    Sexpression *bv_val
        = new Plist({ &s_bits, rval->ACL2Expr(true),
                      new Integer(rval->loc(), width_evaluated - 1),
                      Integer::zero_v(rval->loc()) });

    return bv_val;
  }
}

// class UintType : public RegType
// -------------------------------

IntType *IntType::FromPrimType(const PrimType *t) {
  return new IntType(
      new Integer(Location::dummy(), static_cast<int>(t->rank_)), t->signed_);
}

void IntType::display(std::ostream &os) const {
  os << (isSigned_ ? "sc_int<" : "sc_uint<");
  width()->display(os);
  os << ">";
}

Sexpression *IntType::ACL2Eval(Sexpression *s) const {
  if (isSigned_)
    return new Plist(
        { &s_si, s, new Integer(Location::dummy(), width()->evalConst()) });
  else
    return s;
}

unsigned IntType::ACL2ValWidth() const { return width()->evalConst(); }

// class FPType :public RegType
// ----------------------------

// Data member:  Expression *iwidth

FPType::FPType(Expression *w, Expression *iw) : RegType(w) { iwidth = iw; }

Sexpression *FPType::ACL2Assign(Expression *rval) const {
  const Type *t = rval->get_type();
  if (t == this) {
    return rval->ACL2Expr(true);
  } else {
    Sexpression *s = rval->ACL2Expr();
    int wVal = width()->evalConst(), iwVal = iwidth->evalConst();
    s = new Plist({ &s_times, s,
                    new Plist({ &s_expt, Integer::two_v(rval->loc()),
                                new Integer(rval->loc(), wVal - iwVal) }) });
    if (isa<const FPType *>(rval->get_type()) || wVal < iwVal)
      s = new Plist({ &s_fl, s });
    return new Plist({ &s_bits, s, new Integer(rval->loc(), wVal - 1),
                       Integer::zero_v(rval->loc()) });
  }
}

// class UfixedType : public FPType
// ---------------------------------

UfixedType::UfixedType(Expression *w, Expression *iw) : FPType(w, iw) {}

void UfixedType::display(std::ostream &os) const {
  os << "sc_ufixed<";
  width()->display(os);
  os << ", ";
  iwidth->display(os);
  os << ">";
}

Sexpression *UfixedType::ACL2Eval(Sexpression *s) const {
  return new Plist({ &s_divide, s,
                     new Plist({ &s_expt, Integer::two_v(Location::dummy()),
                                 new Integer(Location::dummy(),
                                             width()->evalConst()
                                                 - iwidth->evalConst()) }) });
}

// class FixedType : public RegType
// --------------------------------

FixedType::FixedType(Expression *w, Expression *iw) : FPType(w, iw) {}

bool FixedType::isSigned() { return true; }

void FixedType::display(std::ostream &os) const {
  os << "sc_fixed<";
  width()->display(os);
  os << ", ";
  iwidth->display(os);
  os << '>';
}

Sexpression *FixedType::ACL2Eval(Sexpression *s) const {
  Sexpression *numerator = new Plist(
      { &s_si, s, new Integer(Location::dummy(), width()->evalConst()) });
  Sexpression *denominator
      = new Plist({ &s_expt, Integer::two_v(Location::dummy()),
                    new Integer(Location::dummy(),
                                width()->evalConst() - iwidth->evalConst()) });
  return new Plist({ &s_divide, numerator, denominator });
}

// class ArrayType : public Type
// -----------------------------

// Data members: Type *baseType; Expresion *dim;

void ArrayType::display(std::ostream &os) const {
  baseType->display(os);
  os << "[";
  dim->display(os);
  os << "]";
}

void ArrayType::displayVarType(std::ostream &os) const {
  baseType->display(os);
}

void ArrayType::displayVarName(const char *name, std::ostream &os) const {
  os << name << '[';
  dim->display(os);
  os << ']';
}

void ArrayType::makeDef(const char *name, std::ostream &os) const {
  const Type *b = baseType;
  List<Expression> *dims = new List<Expression>(dim);
  while (isa<const ArrayType *>(b)) {
    dims = dims->push(((const ArrayType *)b)->dim);
    b = ((const ArrayType *)b)->baseType;
  }
  os << "\ntypedef ";
  b->display(os);
  os << " " << name;
  while (dims) {
    os << "[";
    (dims->value)->display(os);
    os << "]";
    dims = dims->next;
  }
  os << ";";
}

// class StructField
// -----------------

// Data members:  Symbol *sym; Type *type;

StructField::StructField(Type *t, char *n) : sym(new Symbol(n)), type(t) {}

void StructField::display(std::ostream &os, unsigned indent) const {
  if (indent)
    os << std::setw(indent) << " ";
  type->display(os);
  os << " " << getname() << ";";
}

// class StructType : public Type
// ------------------------------

// Data member:  List<StructField> *fields;

StructType::StructType(std::vector<StructField *> f) : Type(), fields_(f) {}

void StructType::displayFields(std::ostream &os) const {
  os << "{";
  bool first = true;
  for (const auto &f : fields_) {
    if (!first)
      os << " ";
    f->display(os);
    first = false;
  }
  os << "}";
}

void StructType::display(std::ostream &os) const {
  os << "struct ";
  this->displayFields(os);
}

void StructType::makeDef(const char *name, std::ostream &os) const {
  os << "\nstruct " << name << " ";
  displayFields(os);
  os << ";";
}

const StructField *StructType::getField(const std::string &name) const {
  auto it = std::find_if(fields_.begin(), fields_.end(),
                         [&](auto f) { return f->getname() == name; });
  assert(it != fields_.end());
  return *it;
}

// class EnumType : public Type
// ----------------------------

// Data member:  List<EnumConstDec> *vals;

EnumType::EnumType(std::vector<EnumConstDec *> v) : Type(), vals_(v) {
  std::for_each(vals_.begin(), vals_.end(),
                [this](EnumConstDec *e) { e->type = this; });
}

Sexpression *EnumType::ACL2Expr() {
  Plist *result = new Plist();
  std::for_each(vals_.begin(), vals_.end(),
                [result](EnumConstDec *e) { result->add(e->ACL2Expr()); });
  return result;
}

void EnumType::displayConsts(std::ostream &os) const {
  os << "{";
  bool is_first = true;
  std::for_each(vals_.begin(), vals_.end(), [&](EnumConstDec *e) {
    if (!is_first)
      os << ", ";
    e->display(os, 0);
    is_first = false;
  });
  os << "}";
}

void EnumType::display(std::ostream &os) const {
  os << "enum ";
  displayConsts(os);
}

Sexpression *EnumType::getEnumVal(Symbol *s) const {
  unsigned count = 0;
  for (auto d : vals_) {
    if (d->init)
      count = d->init->evalConst();
    if (d->sym == s)
      return new Integer(Location::dummy(), count);
    else
      count++;
  }
  assert(!"enum constant not found");
  return 0;
}

void EnumType::makeDef(const char *name, std::ostream &os) const {
  os << "\nenum " << name << " ";
  displayConsts(os);
  os << ";";
}

// class MvType : public Type (multiple-value type)
// -------------------------------------------

// Data members:  unsigned numVals; Type *type[8];
// 2 <= numVals <= 8; determines number of valid entries of type[].

void MvType::display(std::ostream &os) const {

  assert(types_.size() >= 2
         && "It does not make sense to have a mv with 1 or 0 elem");

  os << "<";
  bool first = true;
  for (const auto t : types_) {
    if (!first) {
      os << ", ";
    }
    t->display(os);
    first = false;
  }
  os << ">";
}
