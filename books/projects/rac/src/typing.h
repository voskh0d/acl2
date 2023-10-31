#ifndef TYPING_H
#define TYPING_H

#include "expressions.h"
#include "types.h"
#include "visitor.h"

// This pass is rensposible of the typing (type check and determing the type)
// of each nodes (expressions and some statements).
class TypingAction final : public RecursiveASTVisitor<TypingAction> {
public:
  TypingAction(DiagnosticHandler &diag) : diag_(diag) {}
  ~TypingAction() {}

  // The type of the current depends on the types of its childs.
  bool postfixTraversal() { return true; }

  // Perform the type dereference. We use Traverse to process the type after
  // it was determined by Visit* functions.
  bool TraverseExpression(Expression *e);

  // Used to keep track of the type of the return type. We assume they are no
  // nested fuction.
  bool TraverseFunDef(FunDef *s);
  bool TraverseTemplate(Template *s);

  // All expressions should be typed.
  bool VisitInteger(Integer *e);
  bool VisitBoolean(Boolean *e);
  bool VisitParenthesis(Parenthesis *e);
  bool VisitSymRef(SymRef *e);
  bool VisitFunCall(FunCall *e);
  bool VisitTempCall(TempCall *e);
  bool VisitInitializer(Initializer *e);
  bool VisitArrayRef(ArrayRef *e);
  bool VisitStructRef(StructRef *e);
  bool VisitSubrange(Subrange *e);
  bool VisitPrefixExpr(PrefixExpr *e);
  bool VisitCastExpr(CastExpr *e);
  bool VisitBinaryExpr(BinaryExpr *e);
  bool VisitCondExpr(CondExpr *e);
  bool VisitMultipleValue(MultipleValue *e);

  // Type and dereference the type of return.
  bool VisitReturnStmt(ReturnStmt *s);
  bool VisitSwitchStmt(SwitchStmt *s);

private:
  using base_t = RecursiveASTVisitor<TypingAction>;

  DiagnosticHandler &diag_;

  // The return type of the current function. We assume there are no nested
  // functions.
  const Type *type_of_scope = nullptr;

  static inline const Type *deref(const Type *t);
};

const Type *TypingAction::deref(const Type *t) {

  if (const DefinedType *dt = dynamic_cast<const DefinedType *>(t)) {
    return dt->derefType();
  } else {
    return t;
  }
}

#endif // TYPING_H
