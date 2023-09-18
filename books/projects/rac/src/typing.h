#ifndef TYPING_H
#define TYPING_H

#include "visitor.h"
#include "expressions.h"
#include "types.h"

class Type;

//class DesugarType : public TypePass {
//
//}

class TypeIt final : public RecursiveASTVisitor<TypeIt> {
public:
  ~TypeIt() {}

  bool postfixTraversal() { return true; }

  bool VisitExpression(Expression *e) {
    e->set_type(e->exprType());
    return true;
  }
};

#endif // TYPING_H
