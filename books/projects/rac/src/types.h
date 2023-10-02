#ifndef TYPES_H
#define TYPES_H

#include "sexpressions.h"

#include <iostream>
#include <optional>

//***********************************************************************************
// Types
//***********************************************************************************

class Expression;
class SymRef;
class EnumConstDec;
class DefinedType;

// Derived classes:
//
//   PrimType           (primitive type: uintType, intType, boolType)
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
  virtual void display(std::ostream &os = std::cout) const = 0;

  virtual void displayVarType(std::ostream &os = std::cout) const {
    // How this type is displayed in a variable declaration
    display(os);
  }

  // overridden by ArrayType
  virtual void displayVarName([[maybe_unused]] const char *name,
                              std::ostream &os = std::cout) const {
    // How a variable of this type is displayed in a variable declaration
    display(os);
  }

  // overridden by ArrayType, StructType, and EnumType
  virtual void makeDef([[maybe_unused]] const char *name,
                       std::ostream &os = std::cout) const {
    // How this type is displayed in a type definition.
    os << "\ntypedef ";
    display(os);
    os << " " << name << ";";
  }

  // overridden by RegType
  // Convert rval to an S-expression to be assigned to an object of this
  virtual Sexpression *ACL2Assign(Expression *rval) const;

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
      : Symbol(s), RACname_(m ? std::optional(std::string(m)) : std::nullopt) {
  }

  void display(std::ostream &os) const override {
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

class DefinedType : public Symbol, public Type {
public:
  DefinedType(const char *s, Type *t) : Symbol(s), def_(t) {}

  void display(std::ostream &os) const override { Symbol::display(os); }

  void displayVarType(std::ostream &os = std::cout) const override {
    derefType()->displayVarType(os);
  }

  void displayVarName(const char *name,
                      std::ostream &os = std::cout) const override {
    derefType()->displayVarName(name, os);
  }

  void makeDef(const char *name, std::ostream &os = std::cout) const override {
    derefType()->makeDef(name, os);
  }

  virtual Sexpression *ACL2Assign(Expression *rval) const override {
    return derefType()->ACL2Assign(rval);
  }

  unsigned ACL2ValWidth() const override {
    return derefType()->ACL2ValWidth();
  }

  Sexpression *ACL2Eval(Sexpression *s) const override { return derefType()->ACL2Eval(s); }

  void displayDef(std::ostream &os = std::cout) const {
    // Why do we display only if it is a regtype ? We should shpw all typedef.
    //    if (!(isa<const RegType *>( def_))) {
    def_->makeDef(getname(), os);
    //    }
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

  virtual bool isSigned() const = 0;

private:
  Expression *width_;
};

class UintType : public RegType {
public:
  UintType(Expression *w) : RegType(w) {}

  void display(std::ostream &os = std::cout) const override;
  unsigned ACL2ValWidth() const override;

  bool isSigned() const override { return false; }
};

class IntType : public RegType {
public:
  IntType(Expression *w) : RegType(w) {}
  void display(std::ostream &os = std::cout) const override;
  Sexpression *ACL2Eval(Sexpression *s) const override;

  bool isSigned() const override { return true; }
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
  void display(std::ostream &os = std::cout) const override;
  Sexpression *ACL2Eval(Sexpression *s) const override;

  // TODO remove
  bool isSigned() const override { return false; }
};

class FixedType : public FPType {
public:
  bool isSigned();
  FixedType(Expression *w, Expression *iw);
  void display(std::ostream &os = std::cout) const override;
  Sexpression *ACL2Eval(Sexpression *s) const override;

  // TODO remove
  bool isSigned() const override { return true; }
};

class ArrayType : public Type {
public:
  Type *baseType;
  Expression *dim;

  ArrayType(Expression *d, Type *t) : baseType(t), dim(d) {}

  const Type *getBaseType() const { return baseType; }

  void display(std::ostream &os) const override;
  void displayVarType(std::ostream &os = std::cout) const override;
  void displayVarName(const char *name,
                      std::ostream &os = std::cout) const override;
  void makeDef(const char *name, std::ostream &os) const override;
};

class StructField {
public:
  Symbol *sym;
  Type *type;
  StructField(Type *t, char *n);
  const char *getname() const { return sym->getname(); }
  void display(std::ostream &os, unsigned indent = 0) const;
};

class StructType : public Type {
public:
  StructType(std::vector<StructField *> f);
  void displayFields(std::ostream &os) const;
  void display(std::ostream &os) const override;
  void makeDef(const char *name, std::ostream &os = std::cout) const override;

  const std::vector<StructField *> &fields() const { return fields_; }

  const StructField *getField(const std::string &name) const;

private:
  std::vector<StructField *> fields_;
};

class EnumType : public Type {
public:
  EnumType(std::vector<EnumConstDec *> v);
  void displayConsts(std::ostream &os) const;
  void display(std::ostream &os) const override;
  void makeDef(const char *name, std::ostream &os = std::cout) const override;
  Sexpression *ACL2Expr();
  Sexpression *getEnumVal(Symbol *s) const;

private:
  std::vector<EnumConstDec *> vals_;
};

class MvType : public Type {
public:
  MvType(std::initializer_list<Type *> &&t) : types_(t) {}
  void display(std::ostream &os) const override;

  unsigned size() const { return types_.size(); }
  const Type *get(unsigned n) { return types_[n]; }

private:
  std::vector<Type *> types_;
};

inline bool isIntegerType(const Type *t) {
  return dynamic_cast<const PrimType *>(t) || dynamic_cast<const UintType *>(t)
         || dynamic_cast<const IntType *>(t)
         || dynamic_cast<const EnumType *>(t);
}

#endif // TYPES_H
