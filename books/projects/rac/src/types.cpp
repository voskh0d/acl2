#include "expressions.h"
#include "statements.h"
#include "types.h"

#include <algorithm>
#include <iomanip>
#include <sstream>

//***********************************************************************************
// class Type
//***********************************************************************************

std::string Type::to_string() const {
  std::stringstream ss;

  // TODO
  //  auto cur = origin_;
  //  while (std::holds_alternative<const DefinedType *>(cur)) {
  //    auto dt = std::get<const DefinedType *>(cur);
  //    ss << dt->getname() << " aka ";
  //    cur = dt->origin_;
  //  }

  display(ss);
  return ss.str();
}

Sexpression *
Type::ACL2Assign(Expression *rval) const { // virtual (overridden by IntType)
  // Convert rval to an S-expression to be assigned to an object of this type.
  return rval->ACL2Expr();
}

void Type::displayVarType(std::ostream &os) const {
  // How this type is displayed in a variable declaration
  display(os);
}

void Type::displayVarName(const char *name, std::ostream &os) const {
  os << name;
}

// overridden by ArrayType, StructType, and EnumType
void Type::makeDef([[maybe_unused]] const char *name, std::ostream &os) const {
  // How this type is displayed in a type definition.
  os << "\ntypedef ";
  display(os);
  os << " " << name << ";";
}

// class PrimType : public Symbol, public Type (Primitive type)
// ------------------------------------------------------------

PrimType boolType = PrimType::Bool();
PrimType intType = PrimType::Int();
PrimType uintType = PrimType::Uint();
PrimType int64Type = PrimType::Int64();
PrimType uint64Type = PrimType::Uint64();

Sexpression *PrimType::ACL2Assign(Expression *rval) const {

  const Type *rval_type = rval->get_type();
  return numeric_cast(rval->ACL2Expr(), { rval_type }, this);
}

bool PrimType::isEqual(const Type *other) const {

  if (auto o = dynamic_cast<const DefinedType *>(other)) {
    other = o->derefType();
  }

  if (auto o = dynamic_cast<const PrimType *>(other)) {
    return rank_ == o->rank_ && signed_ == o->signed_;
  } else {
    return false;
  }
}

Type *PrimType::usual_conversions(const PrimType *t1, const PrimType *t2,
                                  bool integer_promotion) {

  // Integer promotion.
  PrimType *t1_promoted = new PrimType(*t1);
  if (integer_promotion) {
    t1_promoted->integerPromtion();
  }

  PrimType *t2_promoted = new PrimType(*t2);
  if (integer_promotion) {
    t2_promoted->integerPromtion();
  }

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

bool PrimType::canBeImplicitlyCastTo(const Type *target) const {

  // We can convert to any size, even if it is a narrowing conversion.
  if (isa<const PrimType *>(target)) {
    return true;
  }

  // TODO what are the constraint for u/int -> intType.
  // We can convert only if the register in large enough.
  if (isa<const IntType *>(target)) {
    return true;
    //    return static_cast<int>(rank_) <= int_type->width()->evalConst();
    //           && signed_ == int_type->isSigned();
  }

  return false;
}

// class IntType : public Type
// -------------------------------

IntType *IntType::FromPrimType(const PrimType *t) {
  return new IntType(
      t->loc(), new Integer(Location::dummy(), static_cast<int>(t->rank_)),
      t->signed_);
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

Sexpression *IntType::ACL2Assign(Expression *rval) const {

  const Type *rval_type = rval->get_type();
  return numeric_cast(rval->ACL2Expr(), { rval_type }, this);
}

bool IntType::isEqual(const Type *other) const {

  if (auto o = dynamic_cast<const DefinedType *>(other)) {
    other = o->derefType();
  }

  if (auto o = dynamic_cast<const IntType *>(other)) {
    return width_->evalConst() == o->width_->evalConst()
           && isSigned_ == o->isSigned_;
  } else {
    return false;
  }
}

// Type integer register type according to ac_datatypes_ref section 2.3.7.
// The AC library only defines long long and unsigned long long operator but
// since they can be casted to any smaller types, we assume this is possible.
bool IntType::canBeImplicitlyCastTo(const Type *target) const {
  if (isa<const PrimType *>(target)) {
    return width_->evalConst() <= 64;
  }
  return isa<const IntType *>(target);
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

bool ArrayType::isEqual(const Type *other) const {

  if (auto o = dynamic_cast<const DefinedType *>(other)) {
    other = o->derefType();
  }

  if (auto o = dynamic_cast<const ArrayType *>(other)) {
    return dim->evalConst() == o->dim->evalConst()
           && baseType->isEqual(o->baseType);
  } else {
    return false;
  }
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

StructType::StructType(origin_t loc, std::vector<StructField *> f)
    : Type(loc), fields_(f) {}

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

bool StructType::isEqual(const Type *other) const {

  if (auto o = dynamic_cast<const DefinedType *>(other)) {
    other = o->derefType();
  }

  if (auto o = dynamic_cast<const StructType *>(other)) {
    if (fields_.size() != o->fields_.size()) {
      return false;
    }

    for (unsigned i = 0; i < fields_.size(); ++i) {
      if (fields_[i] != o->fields_[i]) {
        return false;
      }
    }

    return true;
  }

  return false;
}

// class EnumType : public Type
// ----------------------------

// Data member:  List<EnumConstDec> *vals;

EnumType::EnumType(origin_t loc, std::vector<EnumConstDec *> v)
    : Type(loc), vals_(v) {
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

bool EnumType::isEqual(const Type *other) const {

  if (auto o = dynamic_cast<const DefinedType *>(other)) {
    other = o->derefType();
  }

  if (auto o = dynamic_cast<const EnumType *>(other)) {
    if (vals_.size() != o->vals_.size()) {
      return false;
    }

    for (unsigned i = 0; i < vals_.size(); ++i) {
      // TODO this is wrong (ptr ==)
      if (vals_[i] != o->vals_[i]) {
        return false;
      }
    }
    return true;
  }

  return false;
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

bool MvType::isEqual(const Type *other) const {

  if (auto o = dynamic_cast<const DefinedType *>(other)) {
    other = o->derefType();
  }

  if (auto o = dynamic_cast<const MvType *>(other)) {
    if (types_.size() != o->types_.size()) {
      return false;
    }

    for (unsigned i = 0; i < types_.size(); ++i) {
      if (!types_[i]->isEqual(o->types_[i])) {
        return false;
      }
    }
    return true;
  }

  return false;
}

Sexpression *numeric_cast(Sexpression *sexpr, std::optional<const Type *> src,
                          const Type *dst) {

  // TODO
  auto loc = Location::dummy();

  if (auto pt = dynamic_cast<const PrimType *>(dst)) {
    if (pt->rank_ == PrimType::Rank::Bool) {

      // If the source is also a bool, return sexpr.
      if (src) {
        if (auto ppt = dynamic_cast<const PrimType *>(*src)) {
          if (ppt->rank_ == PrimType::Rank::Bool) {
            return sexpr;
          }
        }
      }

      // Else we add this conversion to ensure that the value is alway 1 or 0.
      return new Plist(
          { &s_if1, sexpr, new Plist({ &s_true }), new Plist({ &s_false }) });
    }
  }

  unsigned w_dst = dst->ACL2ValWidth();
  bool s_dst = isSigned(dst);

  // A bits block is needed in two cases:
  //
  //  * when dealing with unbounded value (like when generating the result of
  //  an arithmetic expression). In that case, src is nullopt.
  //
  //  * to perform narrowing conversion (either signed or unsigned).
  //
  //  * to perform a signed -> unsigned conversion.
  //
  //                 | w_src > w_dst | w_src = w_dst | w_src < w_dst
  // ================+===============+===============+===============
  // ~s_src & ~s_dst |    (bits x)   |       x       |       x
  // ----------------+---------------+---------------+---------------
  // s_src & ~s_dst  |    (bits x)   |    (bits x)   |    (bits x)
  // ----------------+---------------+---------------+---------------
  // ~s_src & s_dst  | (si (bits x)) |     (si x)    |       x
  // ----------------+---------------+---------------+---------------
  // s_src & s_dst   | (si (bits x)) |       x       |       x
  // ----------------+---------------+---------------+---------------
  //
  bool needs_bits = [&]() {
    // Unbounded value.
    if (!src) {
      return true;
    }

    unsigned w_src = (*src)->ACL2ValWidth();
    bool s_src = isSigned(*src);
    // Narrowing or signed to unsigned conversion.
    return w_src > w_dst || (s_src && !s_dst);
  }();

  Sexpression *res = sexpr;

  // Bits alway does an signed to unsigned conversion, so we only need to add
  // a si if the destination is signed.
  if (needs_bits) {
    res = new Plist(
        { &s_bits, sexpr, new Integer(loc, w_dst - 1), Integer::zero_v(loc) });
  }

  // Two cases where we need si:
  //  * we are after a bits
  //  * the source is unsigned
  bool needs_si = [&]() {
    if (!s_dst) {
      return false;
    }
    if (needs_bits) {
      return true;
    }
    unsigned w_src = (*src)->ACL2ValWidth();
    bool s_src = isSigned(*src);
    // If w_dst > w_src then all the positive value of src can fit inside dst.
    return !s_src && w_dst == w_src;
  }();

  if (needs_si) {
    res = new Plist({ &s_si, res, new Integer(loc, w_dst) });
  }

  return res;
}
