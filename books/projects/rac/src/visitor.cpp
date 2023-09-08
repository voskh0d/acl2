#include <algorithm>

#include "visitor.h"
#include "expressions.h"
#include "statements.h"
#include "functions.h"

// TODO  traverseExpr traverseStmt => appller walkup & visit

bool RecursiveASTVisitor::TraverseExpression(Expression *e) {
  if (!e)
    return true;
  return e->accept(this);
}

bool RecursiveASTVisitor::TraverseStatement(Statement *s) {
  if (!s)
    return true;
  return s->accept(this);
}

bool RecursiveASTVisitor::TraverseSimpleStatement(SimpleStatement *s) {
  if (!s)
    return true;
  return s->accept(this);
}

bool RecursiveASTVisitor::TraverseConstant(Constant *s) {
  if (!s)
    return true;
  return s->accept(this);
}

bool RecursiveASTVisitor::TraverseInteger(Integer * e) {
  return this->WalkUpInteger(e);
}

bool RecursiveASTVisitor::TraverseBoolean(Boolean *e) {
  return this->WalkUpBoolean(e);
}

bool RecursiveASTVisitor::TraverseSymRef(SymRef *e) {
  if (!this->postfixTraversal())
    if (!this->WalkUpSymRef(e))
      return false;

  if (!this->TraverseStatement(e->symDec))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpSymRef(e))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseFunCall(FunCall *e) {

  if (!this->postfixTraversal())
    if (!this->WalkUpFunCall(e))
      return false;

  if (!this->TraverseStatement(e->func))
    return false;

  bool b = true;
  for_each(e->args, [&](Expression *e) {
      if (b && !this->TraverseExpression(e))
        b = false;
  });
  if (!b)
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpFunCall(e))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseTempCall(TempCall *e) {

  if (!this->postfixTraversal())
    if (!this->WalkUpTempCall(e))
      return false;

  if (!this->TraverseExpression(e)) {
    return false;
  }

  bool b = true;
  for_each(e->params, [&](Expression *e) {
      if (b && !this->TraverseExpression(e))
        b = false;
  });
  if (!b)
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpTempCall(e))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseInitializer(Initializer *e) {

  if (!this->postfixTraversal())
    if (!this->WalkUpInitializer(e))
      return false;

  bool b = true;
  for_each(e->vals, [&](Expression *e) {
      if (b && !this->TraverseExpression(e))
        b = false;
  });
  if (!b)
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpInitializer(e))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseArrayRef(ArrayRef *e) {

  if (!this->postfixTraversal())
    if (!this->WalkUpArrayRef(e))
      return false;

  if (!(this->TraverseExpression(e->array)
        && this->TraverseExpression(e->index)))
      return false;

  if (this->postfixTraversal())
    if (!this->WalkUpArrayRef(e))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseArrayParamRef(ArrayParamRef *e) {

  if (!this->postfixTraversal())
    if (!this->WalkUpArrayParamRef(e))
      return false;

  if (!(this->TraverseExpression(e->array)
        && this->TraverseExpression(e->index)))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpArrayParamRef(e))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseStructRef(StructRef *e) {

  if (!this->postfixTraversal())
    if (!this->WalkUpStructRef(e))
      return false;

  if (!this->TraverseExpression(e->base))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpStructRef(e))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseBitRef(BitRef *e) {

  if (!this->postfixTraversal())
    if (!this->WalkUpBitRef(e))
      return false;

  if (!(this->TraverseExpression(e->base)
        && this->TraverseExpression(e->index)))
    return false;

  if (!this->postfixTraversal())
    if (!this->WalkUpBitRef(e))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseSubrange(Subrange *e) {

  if (!this->postfixTraversal())
    if (!this->WalkUpSubrange(e))
      return false;

  if (!(this->TraverseExpression(e->base)
        && this->TraverseExpression(e->high)
        && this->TraverseExpression(e->low)))
      return false;

  if (this->postfixTraversal())
    if (!this->WalkUpSubrange(e))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraversePrefixExpr(PrefixExpr *e) {

  if (!this->postfixTraversal())
    if (!this->WalkUpPrefixExpr(e))
      return false;

  if (!this->TraverseExpression(e->expr))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpPrefixExpr(e))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseCastExpr(CastExpr *e) {

  if (!this->postfixTraversal())
    if (!this->WalkUpCastExpr(e))
      return false;

  if (!this->TraverseExpression(e->expr))
    return true;

  if (this->postfixTraversal())
    if (!this->WalkUpCastExpr(e))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseBinaryExpr(BinaryExpr *e) {

  if (!this->postfixTraversal())
    if (!this->WalkUpBinaryExpr(e))
      return false;

  if (!(this->TraverseExpression(e->expr1)
        && this->TraverseExpression(e->expr2)))
      return false;

  if (this->postfixTraversal())
    if (!this->WalkUpBinaryExpr(e))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseCondExpr(CondExpr *e) {

  if (!this->postfixTraversal())
    if (!this->WalkUpCondExpr(e))
      return false;

  if (!(this->TraverseExpression(e->expr1)
        && this->TraverseExpression(e->expr2)
        && this->TraverseExpression(e->test)))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpCondExpr(e))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseMultipleValue(MultipleValue *e) {

  if (!this->postfixTraversal())
    if (!this->WalkUpMultipleValue(e))
      return false;

  if (!std::all_of(e->expr.begin(), e->expr.end(),
      [this](Expression *e) { return this->TraverseExpression(e); }))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpMultipleValue(e))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseSymDec(SymDec *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpSymDec(s))
      return false;

  if (!this->TraverseExpression(s->init))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpSymDec(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseEnumConstDec(EnumConstDec *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpEnumConstDec(s))
      return false;

  if (!this->TraverseExpression(s->init))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpEnumConstDec(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseVarDec(VarDec* s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpVarDec(s))
      return false;

  if (!this->TraverseExpression(s->init))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpVarDec(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseConstDec(ConstDec* s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpConstDec(s))
      return false;

  if (!this->TraverseExpression(s->init))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpConstDec(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseMulVarDec(MulVarDec *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpMulVarDec(s))
      return false;

  bool b = true;
  for_each(s->decs, [&](VarDec *s) {
      if (b && !this->TraverseStatement(s))
        b = false;
  });
  if (!b)
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpMulVarDec(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseMulConstDec(MulConstDec *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpMulConstDec(s))
      return false;

  bool b = true;
  for_each(s->decs, [&](ConstDec *s) {
      if (b && !this->TraverseStatement(s))
        b = false;
  });
  if (!b)
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpMulConstDec(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseTempParamDec(TempParamDec *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpTempParamDec(s))
      return false;

  if (!this->TraverseExpression(s->init))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpTempParamDec(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseBreakStmt(BreakStmt *s) {

  return this->WalkUpBreakStmt(s);
}

bool RecursiveASTVisitor::TraverseReturnStmt(ReturnStmt *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpReturnStmt(s))
      return false;

  if (!this->TraverseExpression(s->value))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpReturnStmt(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseNullStmt(NullStmt *s) {
  return this->WalkUpNullStmt(s);
}

// here

bool RecursiveASTVisitor::TraverseAssertion(Assertion *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpAssertion(s))
      return false;

  if (!this->TraverseExpression(s->expr))
   return false;
 
  if (!this->TraverseStatement(s->funDef))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpAssertion(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseAssignment(Assignment *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpAssignment(s))
      return false;

  if (!this->TraverseExpression(s->lval))
    return false;

  if (!this->TraverseExpression(s->rval))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpAssignment(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseAssignBit(AssignBit *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpAssignBit(s))
      return false;

  if (!this->TraverseExpression(s->base))
    return false;

  if (!this->TraverseExpression(s->index))
    return false;

  if (!this->TraverseExpression(s->val))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpAssignBit(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseAssignRange(AssignRange *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpAssignRange(s))
      return false;

  if (!this->TraverseExpression(s->base))
    return false;

  if (!this->TraverseExpression(s->high))
    return false;

  if (!this->TraverseExpression(s->low))
    return false;

  if (!this->TraverseExpression(s->width))
    return false;

  if (!this->TraverseExpression(s->val))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpAssignRange(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseAssignFull(AssignFull *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpAssignFull(s))
      return false;

  if (!this->TraverseExpression(s->base))
    return false;

  if (!TraverseExpression(s->val))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpAssignFull(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseMultipleAssignment(MultipleAssignment *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpMultipleAssignment(s))
      return false;

  if (!std::all_of(s->lvals().begin(), s->lvals().end(),
        [this](Expression *e)
        { return this->TraverseExpression(e); }))
    return false;

  if (!this->TraverseExpression(s->rval()))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpMultipleAssignment(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseBlock(Block *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpBlock(s))
      return false;

  bool b = true;
  for_each(s->stmtList, [&](Statement *s) {
      if (b && !this->TraverseStatement(s))
        b = false;
  });
  if (!b)
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpBlock(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseIfStmt(IfStmt *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpIfStmt(s))
      return false;

  if (!this->TraverseExpression(s->test))
    return false;

  if (!this->TraverseStatement(s->left))
    return false;

  if (!this->TraverseStatement(s->right))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpIfStmt(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseForStmt(ForStmt *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpForStmt(s))
      return false;

  if (!this->TraverseStatement(s->init))
    return false;

  if (!this->TraverseExpression(s->test))
    return false;

  if (!this->TraverseStatement(s->update))
    return false;

  if (!this->TraverseStatement(s->body))
    return false;

  if (!this->postfixTraversal())
    if (!this->WalkUpForStmt(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseCase(Case *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpCase(s))
      return false;

  if (!this->TraverseExpression(s->label))
    return false;

  bool b = true;
  for_each(s->action, [&](Statement *s) {
      if (b && !this->TraverseStatement(s))
        b = false;
  });
  if (!b)
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpCase(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseSwitchStmt(SwitchStmt *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpSwitchStmt(s))
      return false;

  if (!this->TraverseExpression(s->test()))
    return false;

  bool b = true;
  for_each(s->cases(), [&](Case *s) {
      if (b && !this->TraverseStatement(s))
        b = false;
  });
  if (!b)
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpSwitchStmt(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseFunDef(FunDef *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpFunDef(s))
      return false;

  bool b = true;
  for_each(s->params, [&](VarDec *s) {
      if (b && !this->TraverseStatement(s))
        b = false;
  });
  if (!b)
   return false;
 
  if (!this->TraverseStatement(s->body))
    return false;

  if (!this->postfixTraversal())
    if (!this->WalkUpFunDef(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseBuiltin(Builtin *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpBuiltin(s))
      return false;

  bool b = true;
  for_each(s->params, [&](VarDec *s) {
      if (b && !this->TraverseStatement(s))
        b = false;
  });
  if (!b)
    return false;

  if (!this->TraverseStatement(s->body))
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpBuiltin(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::TraverseTemplate(Template *s) {

  if (!this->postfixTraversal())
    if (!this->WalkUpTemplate(s))
      return false;

  bool b = true;
  for_each(s->params, [&](VarDec *s) {
      if (b && !this->TraverseStatement(s))
        b = false;
  });
  if (!b)
    return false;

  if (!this->TraverseStatement(s->body))
    return false;

  for_each(s->tempParams, [&](TempParamDec *s) {
      if (b && !this->TraverseStatement(s))
        b = false;
  });
  if (!b)
    return false;

  for_each(s->calls, [&](TempCall *s) {
      if (b && !this->TraverseExpression(s))
        b = false;
  });
  if (!b)
    return false;

  if (this->postfixTraversal())
    if (!this->WalkUpTemplate(s))
      return false;

  return true;
}

bool RecursiveASTVisitor::WalkUpExpression(Expression *e) {
  return this->VisitExpression(e);
}

bool RecursiveASTVisitor::WalkUpStatement(Statement *s) {
  return this->VisitStatement(s);
}

#define APPLY(CLASS, PARENT)                          \
bool RecursiveASTVisitor::WalkUp##CLASS (CLASS *c) { \
  if (!this->WalkUp##PARENT(c)                 )      \
    return false;                                     \
  return this->Visit##CLASS(c);                       \
}
#include "ASTNodes.inc"
#undef APPLY

bool RecursiveASTVisitor::VisitExpression(Expression *) {
  return true;
}

bool RecursiveASTVisitor::VisitStatement(Statement *) {
  return true;
}

#define APPLY(CLASS, PARENT)                       \
bool RecursiveASTVisitor::Visit##CLASS (CLASS *) { \
  return true;                                     \
}
#include "ASTNodes.inc"
#undef APPLY

