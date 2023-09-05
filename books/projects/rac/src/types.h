#ifndef TYPES_H
#define TYPES_H

#include "parser.h"
#include "utils.h"

using namespace std;

//***********************************************************************************
// Types
//***********************************************************************************

class Expression;
class SymRef;
class EnumConstDec;
class DefinedType;

// Derived classes:
//
//   PrimType           (primitive type: uintTYpe, intType, boolType)
//   DefinedType        (introduced by typedef)
//   RegType            (Algorithmic C register type)
//   UintType           (unsigned limited integer register)
//   IntType            (signed limited integer register)
//   FPType             (fixed-point register
//   UfixedType         (unsigned fixed-point register
//   FixedType          (signed fixed-point register
//   ArrayType          (array type)
//   StructType         (struct type) EnumType (enumeration type)
//   MvType             (multiple value type)
class Type {

public:
  virtual void display(ostream &os = cout) const = 0;

  virtual void displayVarType(ostream &os = cout) const {
    // How this type is displayed in a variable declaration
    display(os);
  }

  // overridden by ArrayType
  virtual void displayVarName([[maybe_unused]] const char *name,
                              ostream &os = cout) const {
    // How a variable of this type is displayed in a variable declaration
    display(os);
  }

  // overridden by ArrayType, StructType, and EnumType
  virtual void makeDef([[maybe_unused]] const char *name, ostream &os = cout) const {
    // How this type is displayed in a type definition.
    os << "\ntypedef ";
    display(os);
    os << " " << name << ";";
  }

  // overridden by RegType
  virtual Sexpression *ACL2Assign(Expression *rval) const;
  //  {
  //    // Convert rval to an S-expression to be assigned to an object of this
  //    type. return rval->ACL2Expr()
  //  }

  // overridden by UintType
  virtual unsigned ACL2ValWidth() const {
    // TODO: shady, we should probably have something to express unbounded,
    // unknown and zero (imagine a case were translate an unknown size value
    // like it was unbounded...)
    //
    // Boundary on the width of the value of an object of this type.
    // 0 indicates unknown or unbounded width.
    // Used to avoid unnecessary call to bits.
    return 0;
  }

  // overridden by RegType
  virtual Sexpression *ACL2Eval(Sexpression *s) const {
    // For a RegType, the numerical value represented by a given bit vector s.
    // For any other type, just return s.
    return s;
  }
};

class PrimType : public Symbol, public Type {
public:
  PrimType(const char *s, const char *m = nullptr)
      : Symbol(s), RACname_(m ? std::optional(std::string(m)) : nullopt) {}

  void display(ostream &os) const override {
    if (RACname_) {
      os << *RACname_;
    } else {
      Symbol::display(os);
    }
  }

private:
  const std::optional<std::string> RACname_;
};

extern PrimType boolType;
extern PrimType intType;
extern PrimType uintType;
extern PrimType int64Type;
extern PrimType uint64Type;

bool isRegType(const Type *t);

class DefinedType : public Symbol, public Type {
public:
  DefinedType(const char *s, Type *t) : Symbol(s), def_(t) {}

  void display(ostream &os) const { Symbol::display(os); }
  

  void displayVarType(ostream &os = cout) const override {
    derefType()->displayVarType(os);
  }

  void displayVarName(const char *name, ostream &os = cout) const override {
    derefType()->displayVarName(name, os);
  }

  void makeDef(const char *name, ostream &os = cout) const override {
    derefType()->makeDef(name, os);
  }

  virtual Sexpression *ACL2Assign(Expression *rval) const override {
    return derefType()->ACL2Assign(rval);
  }

  unsigned ACL2ValWidth() const override {
    return derefType()->ACL2ValWidth();
  }

  Sexpression *ACL2Eval(Sexpression *s) {
    return derefType()->ACL2Eval(s);
  }

  void displayDef(ostream &os = cout) const {
    if (!(isRegType( def_))) {
      def_->makeDef(getname(), os);
    }
  }

  Type *getdef() { return def_; }
  const Type *getdef() const { return def_; }

  const Type *derefType() const {
    Type *t = def_;
    while (auto *dt = dynamic_cast<DefinedType *>(t)) {
      t = dt->getdef();
    }
    return t;
  }

private:
  Type *def_;
};

class RegType : public Type {
public:
  RegType(Expression *w) : width_(w) {}

  Expression *width() const { return width_; }

  Sexpression *ACL2Assign(Expression *rval) const override;

private:
  Expression *width_;
};

class UintType : public RegType {
public:
  UintType(Expression *w) : RegType(w) {}

  void display(ostream &os = cout) const override;
  unsigned ACL2ValWidth() const override;
};

class IntType : public RegType {
public:
  IntType(Expression *w) : RegType(w) {}
  void display(ostream &os = cout) const override;
  Sexpression *ACL2Eval(Sexpression *s) const override;
};

class FPType : public RegType {
public:
  Expression *iwidth;
  FPType(Expression *w, Expression *iw);
  Sexpression *ACL2Assign(Expression *rval) const override;
};

class UfixedType : public FPType {
public:
  UfixedType(Expression *w, Expression *iw);
  void display(ostream &os = cout) const override;
  Sexpression *ACL2Eval(Sexpression *s) const override;
};

class FixedType : public FPType {
public:
  bool isSigned();
  FixedType(Expression *w, Expression *iw);
  void display(ostream &os = cout) const override;
  Sexpression *ACL2Eval(Sexpression *s) const override;
};

class ArrayType : public Type {
public:
  Type *baseType;
  Expression *dim;

  ArrayType(Expression *d, Type *t) : baseType(t), dim(d) {}

  const Type *getBaseType() const {
    return baseType;
  }

  void display(ostream &os) const override;
  void displayVarType(ostream &os = cout) const override;
  void displayVarName(const char *name, ostream &os = cout) const override;
  void makeDef(const char *name, ostream &os) const override;
};

class StructField {
public:
  Symbol *sym;
  Type *type;
  StructField(Type *t, char *n);
  const char *getname() const { return sym->getname(); }
  void display(ostream &os, unsigned indent = 0) const;
};

class StructType : public Type {
public:
  List<StructField> *fields;
  StructType(List<StructField> *f);
  void displayFields(ostream &os) const;
  void display(ostream &os) const override;
  void makeDef(const char *name, ostream &os = cout) const override;
};

class EnumType : public Type {
public:
  List<EnumConstDec> *vals;
  EnumType(List<EnumConstDec> *v);
  void displayConsts(ostream &os) const;
  void display(ostream &os) const override;
  void makeDef(const char *name, ostream &os = cout) const override;
  // ACL2expr Weird
  Sexpression *ACL2Expr();
  Sexpression *getEnumVal(Symbol *s) const;
};

class MvType : public Type {
public:
  std::vector<Type *> type;
  MvType(std::initializer_list<Type *> &&t) : type(t) {}
  void display(ostream &os) const;
};








// TODO: after the type pass, every node should have its type already cast so
// we won't need this anymore.
// Apply a predicate to a type. If it is a defined type, we derefence it.
inline const Type *typeDeref__(const Type * t) {

  // If t is a typdef, we derefence it until we get a non-defined type.
  if (const DefinedType *dt = dynamic_cast<const DefinedType *>(t)) {
    t = dt->derefType();
  }

  return t;
}

inline bool isRegType(const Type *t) {
  return dynamic_cast<const RegType *>(typeDeref__(t));
}

inline bool isArrayType(const Type *t) {
  return dynamic_cast<const ArrayType *>(typeDeref__(t));
}

inline bool isStructType(const Type *t) {
  return dynamic_cast<const StructType *>(typeDeref__(t));
}

inline bool isIntegerType(const Type *t) {
  t = typeDeref__(t);
  return dynamic_cast<const PrimType *>(t)
    || dynamic_cast<const UintType *>(t)
    || dynamic_cast<const IntType *>(t)
    || dynamic_cast<const EnumType *>(t);
}

inline bool isEnumType(const Type * t) {
  return dynamic_cast<const EnumType *>(typeDeref__(t));
}

// TODO: after the type pass, every node should have its type already cast so
// we won't need this anymore.
template <typename ChildType>
const ChildType *tryDownCast(const Type *t) {

  if (auto *dt = dynamic_cast<const DefinedType *>(t)) {
    t = dt->derefType();
  }

  const ChildType *ct = dynamic_cast<const ChildType *>(t);
  assert(ct && "Invalid conversion");
  return ct;
}

#endif // TYPES_H
