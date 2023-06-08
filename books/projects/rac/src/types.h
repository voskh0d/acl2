#ifndef TYPES_H
#define TYPES_H

#include "parser.h"
#include "utils.h"

// TODO remove
#include <iostream>

//***********************************************************************************
// Types
//***********************************************************************************

class Expression;
class SymRef;
class EnumConstDec;

// Derived classes:
//
//   PrimType           (primitive type: uintTYpe, intType, boolType)
//   RegType            (Algorithmic C register type)
//   IntType            (signed limited integer register signed or unsigned)
//   FixedType          (fixed-point register signed or unsigned)
//   ArrayType          (array type)
//   StructType         (struct type) EnumType (enumeration type)
//   MvType             (multiple value type)
//   DefinedType        (introduced by typedef)
//
//   TODO: PrimType should be removed and replaced by IntType.
//
//  Type
//  |
//  |-- PrimType
//  |
//  |-- RegType
//  |   |-- IntType
//  |   `-- FixedType
//  |
//  |-- ArrayType
//  |-- StructField
//  |-- StructType
//  |-- EnumType
//  |-- MvType
//  `-- DefinedType
//

class Type {
public:
  virtual bool isIntegerType() const { return false; }

  virtual Type *derefType() { return this; }

  virtual void display(std::ostream &os) const = 0;

  virtual void displayVarType(std::ostream &os) const {
    // How this type is displayed in a variable declaration
    display(os);
  }

  // overridden by ArrayType
  virtual void displayVarName([[maybe_unused]] const char *name,
                              std::ostream &os) const {
    // How a variable of this type is displayed in a variable declaration
    os << name;
  }

  // overridden by ArrayType, StructType, and EnumType
  virtual void makeDef([[maybe_unused]] const char *name,
                       std::ostream &os) const {
    // How this type is displayed in a type definition.
    os << "\ntypedef " << *this << " " << name << ";";
  }

  // TODO this line depends on Expression which is defined below. For now, the
  // implementation stays in output.c.
  // overridden by RegType
  virtual Sexpression *ACL2Assign(Expression *rval) const;

  // overridden by RegType
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

  friend std::ostream &operator<<(std::ostream &os, const Type &t) {
    t.display(os);
    return os;
  }
};

// TODO remove this, should be replace by Uint/Int type
class PrimType : public Type {
public:
  PrimType(const char *s, const char *m = nullptr)
      : name_(s), RACname_(m ? std::optional(std::string(m)) : std::nullopt) {}

  bool isIntegerType() const override { return true; }

  void display(std::ostream &os) const override {
    os << (RACname_ ? *RACname_ : name_);
  }

private:
  const std::string name_;
  const std::optional<std::string> RACname_;
};

class RegType : public Type {
public:
  RegType(Expression *w) : width_(w) {}

  Expression *width() const { return width_; }

  unsigned ACL2ValWidth() const override;

private:
  Expression *width_;
};

class IntType : public RegType {
  bool is_signed_;

public:
  IntType(Expression *w, bool is_signed) : RegType(w), is_signed_(is_signed) {}

  bool isIntegerType() const override { return true; }

  bool is_signed() const { return is_signed_; }

  void display(std::ostream &os) const override;
  Sexpression *ACL2Eval(Sexpression *s) const override;

  Sexpression *ACL2Assign(Expression *rval) const override;
};

class FixedType : public RegType {
  bool is_signed_;
  Expression *iwidth;

public:
  FixedType(Expression *w, Expression *iw, bool is_signed)
      : RegType(w), is_signed_(is_signed), iwidth(iw) {}

  void display(std::ostream &os) const override;
  Sexpression *ACL2Eval(Sexpression *s) const override;
  Sexpression *ACL2Assign(Expression *rval) const override;
};

class ArrayType : public Type {
public:
  Type *baseType;
  Expression *dim;

  ArrayType(Expression *d, Type *t) : baseType(t), dim(d) {}

  Type *getBaseType() const;

  void display(std::ostream &os) const override;
  void displayVarType(std::ostream &os) const override;
  void displayVarName(const char *name, std::ostream &os) const override;
  void makeDef(const char *name, std::ostream &os) const override;
};

class StructField : public Type {
public:
  Symbol *sym;
  Type *type;
  StructField(Type *t, char *n);
  const char *getname() const { return sym->getname(); }
  void display(std::ostream &os) const override;
};

class StructType : public Type {
public:
  List<StructField> *fields;
  StructType(List<StructField> *f);

  void displayFields(std::ostream &os) const;
  void display(std::ostream &os) const override;
  void makeDef(const char *name, std::ostream &os) const override;
};

class EnumType : public Type {
public:
  EnumType(List<EnumConstDec> *v);

  bool isIntegerType() const override { return true; }

  // TODO derefType -> int32
  //  Type *
  //  derefType () override

  void displayConsts(std::ostream &os) const;
  void display(std::ostream &os) const override;
  void makeDef(const char *name, std::ostream &os) const override;

  // ACL2expr Weird
  Sexpression *ACL2Expr();
  Sexpression *getEnumVal(Symbol *s) const;

private:
  List<EnumConstDec> *vals;
};

class MvType : public Type {
public:
  MvType(std::initializer_list<Type *> &&t) : type(t) {}
  MvType(const std::vector<Type *> &t) : type(t) {}
  void display(std::ostream &os) const;

  Type *typeOfNth(unsigned i) { return type[i]; }

#ifndef NDEBUG
  unsigned size() { return type.size(); }
#endif // NDEBUG

private:
  std::vector<Type *> type;
};

class DefinedType : public Type {
public:
  DefinedType(const char *s, Type *t) : name_(s), def_(t) {}

  const std::string &name() { return name_; }
  Type *typeDefined() { return def_; }

  void display(std::ostream &os) const override { os << name_; }

  void displayDef(std::ostream &os) const {
    if (!isa<RegType>(def_))
      def_->makeDef(name_.c_str(), os);
  }

  Type *derefType() override { return def_->derefType(); }

private:
  std::string name_;
  Type *def_;
};

extern PrimType boolType;
extern PrimType intType;
extern PrimType uintType;
extern PrimType int64Type;
extern PrimType uint64Type;
extern IntType bitType;

#endif // TYPES_H
