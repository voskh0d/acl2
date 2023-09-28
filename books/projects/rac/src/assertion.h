#ifndef ASSERTION_H
#define ASSERTION_H

#include "visitor.h"
#include "statements.h"
#include "functions.h"

class MarkAssertionAction final : public RecursiveASTVisitor<MarkAssertionAction> {
public:
  bool VisitFunDef(FunDef *f) {
    fn = f;
    return true;
  }

  bool VisitAssertion(Assertion *a) {
    assert(fn);
    a->funDef = fn;
    return true;
  }

private:
  FunDef *fn = nullptr;
};

#endif // ASSERTION_H
