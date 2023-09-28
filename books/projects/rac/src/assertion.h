#ifndef ASSERTION_H
#define ASSERTION_H

#include "functions.h"
#include "statements.h"
#include "visitor.h"

class MarkAssertionAction final
    : public RecursiveASTVisitor<MarkAssertionAction> {
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
