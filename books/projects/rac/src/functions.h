#ifndef FUNCTIONS_H
#define FUNCTIONS_H

#include "statements.h"
#include "utils.h"

#include <iomanip>
#include <vector>

//***********************************************************************************
// Functions
//***********************************************************************************

// Same why not is hierarchy
class FunDef {
public:
  FunDef(const char *n, Type *t, std::vector<VarDec *> p, Block *b)
      : name_(n), returnType_(t), params_(p), body_(b) {
    assert(n);
    assert(t);
    assert(b);
  }

  const char *getname() const { return name_.c_str(); }

  Type *returnType() { return returnType_; }
  std::vector<VarDec *> &params() { return params_; }

  void displayDec(std::ostream &os, const char *prefix = "",
                  unsigned indent = 0);
  virtual void display(std::ostream &os, const char *prefix = "",
                       unsigned indent = 0);
  virtual void displayACL2Expr(std::ostream &os);

protected:
  FunDef(const char *n, Type *t, std::vector<VarDec *> p)
      : name_(n), returnType_(t), params_(p), body_(nullptr) {
    assert(n);
    assert(t);
  }

  std::string name_;
  Type *returnType_;
  std::vector<VarDec *> params_;
  Block *body_;

private:
  void displayPrototype(std::ostream &os, const char *prefix, unsigned indent);
};

// A builtin does not need an implemtation and should not be displayed.
class Builtin : public FunDef {
public:
  Builtin(const char *n, Type *t, std::vector<VarDec *> p) : FunDef(n, t, p) {}

  virtual void display([[maybe_unused]] std::ostream &os,
                       [[maybe_unused]] const char *prefix = "",
                       [[maybe_unused]] unsigned indent = 0) override {}

  virtual void displayACL2Expr([[maybe_unused]] std::ostream &os) override {}
};

class Template : public FunDef {
public:
  Template(const char *n, Type *t, std::vector<VarDec *> p, Block *b,
           std::vector<TempParamDec *> tp)
      : FunDef(n, t, p, b), tempParams_(tp) {
    calls_.reserve(16);
  }

  void registerCall(TempCall *tc) { calls_.push_back(tc); }

  void display(std::ostream &os, const char *prefix = "",
               unsigned indent = 0) override;

  void bindParams(std::vector<Expression *> a);
  void displayACL2Expr(std::ostream &os) override;

private:
  std::vector<TempParamDec *> tempParams_;
  std::vector<TempCall *> calls_;
};

#endif // FUNCTIONS_H
