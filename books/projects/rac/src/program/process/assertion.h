#ifndef ASSERTION_H
#define ASSERTION_H

#include "visitor.h"

// Bind each assertion to its parent function (needed to disply where the
// correct message when the assert fails).
class MarkAssertionAction final
    : public RecursiveASTVisitor<MarkAssertionAction> {
public:
  MarkAssertionAction(const DiagnosticHandler &) {}

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
