#include "expressions.h"
#include "statements.h"
#include "types.h"

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

PrimType boolType("bool");
PrimType intType("int");
PrimType uintType("uint");
PrimType int64Type("int64", "int");
PrimType uint64Type("uint64", "uint");
IntType bitType(Integer::one(), false);

// class RegType : public Type (Algorithmic C register type)
// ---------------------------------------------------

Sexpression *IntType::ACL2Assign(Expression *rval) const {

  Type *t = rval->exprType();
  unsigned w = rval->ACL2ValWidth();

  int width_evaluated = width()->evalConst();
  assert(width_evaluated >= 0);

  if (t == this || (w && w <= (unsigned)width_evaluated)) {
    return rval->ACL2Expr(true);
  } else {
    assert(width_evaluated);
    Sexpression *s = rval->ACL2Expr();
    if (rval->isFP())
      s = new Plist({ &s_fl, s });
    // TODO location
    return new Plist(
        { &s_bits, s, new Integer(Location::dummy(), width()->evalConst() - 1),
          Integer::zero() });
  }
}

// class IntType : public RegType
// ------------------------------

void IntType::display(std::ostream &os) const {
  os << (is_signed_ ? "sc_int<" : "sc_uint<") << NoParenthesis(width()) << ">";
}

Sexpression *IntType::ACL2Eval(Sexpression *s) const {
  if (is_signed_)
    return new Plist(
        { &s_si, s, new Integer(Location::dummy(), width()->evalConst()) });
  else
    return s;
}

unsigned RegType::ACL2ValWidth() const { return width()->evalConst(); }

// class FixedType : public RegType
// --------------------------------

void FixedType::display(std::ostream &os) const {
  os << (is_signed_ ? "sc_fixed<" : "sc_ufixed<") << NoParenthesis(width())
     << ", " << NoParenthesis(iwidth) << '>';
}

Sexpression *FixedType::ACL2Eval(Sexpression *s) const {

  if (is_signed_) {

    Sexpression *numerator = new Plist(
        { &s_si, s, new Integer(Location::dummy(), width()->evalConst()) });
    Sexpression *denominator = new Plist(
        { &s_expt, Integer::two(),
          new Integer(Location::dummy(),
                      width()->evalConst() - iwidth->evalConst()) });
    return new Plist({ &s_divide, numerator, denominator });
  } else {

    return new Plist(
        { &s_divide, s,
          new Plist(
              { &s_expt, Integer::two(),
                new Integer(Location::dummy(),
                            width()->evalConst() - iwidth->evalConst()) }) });
  }
}

Sexpression *FixedType::ACL2Assign(Expression *rval) const {
  Type *t = rval->exprType();
  // ??? should be *this == *t sauf que vu que c'est des ptr partout ca
  // marchera pas...
  if (t == this) {
    return rval->ACL2Expr(true);
  } else {
    Sexpression *s = rval->ACL2Expr();
    int wVal = width()->evalConst(), iwVal = iwidth->evalConst();
    s = new Plist(
        { &s_times, s,
          new Plist({ &s_expt, Integer::two(),
                      new Integer(Location::dummy(), wVal - iwVal) }) });
    if ((rval->isFP()) || wVal < iwVal)
      s = new Plist({ &s_fl, s });
    return new Plist({ &s_bits, s, new Integer(Location::dummy(), wVal - 1),
                       Integer::zero() });
  }
}

// class ArrayType : public Type
// -----------------------------

// Data members: Type *baseType; Expresion *dim;

Type *ArrayType::getBaseType() const { return baseType->derefType(); }

void ArrayType::display(std::ostream &os) const {
  os << *baseType << "[" << NoParenthesis(dim) << "]";
}

void ArrayType::displayVarType(std::ostream &os) const { os << *baseType; }

void ArrayType::displayVarName(const char *name, std::ostream &os) const {
  os << name << '[' << NoParenthesis(dim) << ']';
}

void ArrayType::makeDef(const char *name, std::ostream &os) const {

  Type *b = baseType;
  os << "\ntypedef " << *b << " " << name;

  os << "[" << NoParenthesis(dim) << "]";
  while (auto arrayType = dynamic_cast<ArrayType *>(b)) {
    os << "[" << NoParenthesis(arrayType->dim) << "]";
    b = arrayType->baseType;
  }
  os << ";";
}

// class StructField
// -----------------

// Data members:  Symbol *sym; Type *type;

StructField::StructField(Type *t, char *n) {
  sym = new Symbol(n);
  type = t;
}

void StructField::display(std::ostream &os) const {
  os << *type << " " << getname() << ";";
}

// class StructType : public Type
// ------------------------------

// Data member:  List<StructField> *fields;

StructType::StructType(List<StructField> *f) { fields = f; }

void StructType::displayFields(std::ostream &os) const {
  os << "{";
  //  List<StructField> *ptr = fields;
  //  while (ptr) {
  //    ptr->value->display(os);
  //    if (ptr->next)
  //      os << " ";
  //    ptr = ptr->next;
  //  }

  bool first = true;
  for_each(fields, [&](StructField *sf) {
    if (!first)
      os << " ";
    os << *sf;
  });
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

// class EnumType : public Type
// ----------------------------

// Data member:  List<EnumConstDec> *vals;

EnumType::EnumType(List<EnumConstDec> *v) {
  vals = v;
  for_each(vals, [this](EnumConstDec *e) { e->type = this; });
}

Sexpression *EnumType::ACL2Expr() {
  Plist *result = new Plist();
  for_each(vals, [result](EnumConstDec *e) { result->add(e->ACL2Expr()); });
  return result;
}

void EnumType::displayConsts(std::ostream &os) const {
  os << "{";
  bool is_first = true;
  for_each(vals, [&](EnumConstDec *e) {
    if (!is_first)
      os << ", ";
    e->display(os);
    is_first = false;
  });
  os << "}";
}

void EnumType::display(std::ostream &os) const {
  os << "enum ";
  displayConsts(os);
}

Sexpression *EnumType::getEnumVal(Symbol *s) const {
  // TODO zip(iota)
  List<EnumConstDec> *ptr = vals;
  unsigned count = 0;
  while (ptr) {
    if (ptr->value->init) {
      count = ptr->value->init->evalConst();
    }
    if (ptr->value->sym == s) {
      return new Integer(Location::dummy(), count);
    } else {
      count++;
      ptr = ptr->next;
    }
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

  assert(type.size() >= 2
         && "It does not make sense to have a mv with 1 or 0 elem");

  os << "<";
  bool first = true;
  for (const auto t : type) {
    if (!first) {
      os << ", ";
    }
    t->display(os);
  }
  os << ">";
}
