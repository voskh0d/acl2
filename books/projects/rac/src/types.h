#ifndef TYPES_H
#define TYPES_H

#include "sexpressions.h"

#include <iostream>
#include <optional>

//***********************************************************************************
// Types
//***********************************************************************************

class Expression;
class EnumConstDec;

// Derived classes:
//
//   PrimType           (primitive type: uintType, intType, boolType)
//   DefinedType        (introduced by typedef)
//   RegType            (Algorithmic C register type)
//   IntType            (limited integer register)
//   FixedPointType     (fixed-point register
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
    os << name;
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

  // overridden by IntType
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

  virtual bool isEqual(const Type *other) const = 0;
};

class PrimType final : public Symbol, public Type {

public:
  enum class Rank {
    Bool = 1,
    Int = 32,
    Long = 64,
  };

  PrimType(const char *name, const char *m, Rank r, bool s)
      : Symbol(name),
        RACname_(m ? std::optional(std::string(m)) : std::nullopt), rank_(r),
        signed_(s) {}

  static PrimType Bool() {
    return PrimType("bool", nullptr, Rank::Bool, false);
  }
  static PrimType Int() { return PrimType("int", nullptr, Rank::Int, true); }
  static PrimType Uint() {
    return PrimType("uint", nullptr, Rank::Int, false);
  }
  static PrimType Int64() {
    return PrimType("int64", "int", Rank::Long, true);
  }
  static PrimType Uint64() {
    return PrimType("uint64", "uint", Rank::Long, false);
  }

  void display(std::ostream &os) const override {
    if (RACname_) {
      os << *RACname_;
    } else {
      Symbol::display(os);
    }
  }

  // Integer promotion: all the type below int are transformed to an int.
  void integerPromtion() {
    if (rank_ < Rank::Int) {
      rank_ = Rank::Int;
    }
  }

  bool isEqual(const Type *other) const override;

  // https://en.cppreference.com/w/cpp/language/usual_arithmetic_conversions
  // Return a new type.
  static Type *usual_conversions(const PrimType *t1, const PrimType *t2);

  const std::optional<std::string> RACname_;
  Rank rank_;
  bool signed_;
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

  Sexpression *ACL2Eval(Sexpression *s) const override {
    return derefType()->ACL2Eval(s);
  }

  void displayDef(std::ostream &os = std::cout) const {
    // Why do we display only if it is a regtype ? We should show all typedefs.
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

  // TODO
  bool isEqual(const Type *other) const override {
    return derefType()->isEqual(other);
  }

private:
  Type *def_;
};

class RegType : public Type {
public:
  virtual Expression *width() const = 0;
  virtual bool isSigned() const = 0;
};

class IntType final : public RegType {
public:
  IntType(Expression *w, bool s) : width_(w), isSigned_(s) {}

  // Return an ac_int of the same sign and width as t.
  static IntType *FromPrimType(const PrimType *t);

  void display(std::ostream &os = std::cout) const override;
  Sexpression *ACL2Eval(Sexpression *s) const override;
  Sexpression *ACL2Assign(Expression *rval) const override;

  unsigned ACL2ValWidth() const override;

  bool isSigned() const override { return isSigned_; }
  Expression *width() const override { return width_; }

  bool isEqual(const Type *other) const override;

private:
  Expression *width_;
  bool isSigned_;
};

class FixedPointType : public RegType {
public:
  FixedPointType(Expression *w, Expression *iw, bool isSigned);

  Sexpression *ACL2Assign(Expression *rval) const override;
  Sexpression *ACL2Eval(Sexpression *s) const override;
  void display(std::ostream &os = std::cout) const override;

  Expression *width() const override { return width_; }
  bool isSigned() const override { return isSigned_; }

  bool isEqual(const Type *other) const override;

private:
  Expression *width_;
  Expression *iwidth_;
  bool isSigned_;
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

  bool isEqual(const Type *other) const override;
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

  bool isEqual(const Type *) const override {
    UNREACHABLE(); // TODO
  }

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

  bool isEqual(const Type *) const override {
    UNREACHABLE(); // TODO
  }

private:
  std::vector<EnumConstDec *> vals_;
};

class MvType : public Type {
public:
  MvType(std::initializer_list<Type *> &&t) : types_(t) {}
  void display(std::ostream &os) const override;

  unsigned size() const { return types_.size(); }
  const Type *get(unsigned n) { return types_[n]; }

  bool isEqual(const Type *) const override {
    UNREACHABLE(); // TODO
  }

private:
  std::vector<Type *> types_;
};

inline bool isIntegerType(const Type *t) {
  return dynamic_cast<const PrimType *>(t) || dynamic_cast<const IntType *>(t)
         || dynamic_cast<const EnumType *>(t);
}

#endif // TYPES_H
