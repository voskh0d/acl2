#include "expressions.h"
#include "types.h"
#include "typing.h"

bool TypingAction::TraverseExpression(Expression *e) {

  if (!base_t::TraverseExpression(e))
    return false;

  if (e) {
    e->set_type(deref(e->get_type()));
  }

  return true;
}

bool TypingAction::TraverseFunDef(FunDef *e) {

  assert(!type_of_scope);
  type_of_scope = e->returnType;

  if (!base_t::TraverseFunDef(e))
    return false;

  type_of_scope = nullptr;

  return true;
}

bool TypingAction::TraverseTemplate(Template *e) {

  assert(!type_of_scope);
  type_of_scope = e->returnType;

  if (!base_t::TraverseTemplate(e))
    return false;

  type_of_scope = nullptr;

  return true;
}

bool TypingAction::VisitInteger(Integer *e) {
  e->set_type(nullptr);
  return true;
}

bool TypingAction::VisitBoolean(Boolean *e) {
  e->set_type(nullptr);
  return true;
}

bool TypingAction::VisitParenthesis(Parenthesis *e) {
  e->set_type(e->expr_->get_type());
  return true;
}

bool TypingAction::VisitSymRef(SymRef *e) {
  e->set_type(e->symDec->type);
  return true;
}

bool TypingAction::VisitFunCall(FunCall *e) {
  e->set_type(e->func->returnType);
  return true;
}

bool TypingAction::VisitTempCall(TempCall *e) {
  e->set_type(e->get_type());
  return true;
}

bool TypingAction::VisitInitializer(Initializer *e) {
  e->set_type(e->get_type());
  return true;
}

bool TypingAction::VisitArrayRef(ArrayRef *e) {
  if (isa<const ArrayType *>(e->array->get_type())) {
    e->set_type(
        always_cast<const ArrayType *>(e->array->get_type())->getBaseType());
  } else {
    e->set_type(&boolType);
  }
  return true;
}

bool TypingAction::VisitStructRef(StructRef *e) {
  const StructType *t = always_cast<const StructType *>(e->base->get_type());
  e->set_type(t->getField(e->field)->type);
  return true;
}

bool TypingAction::VisitSubrange(Subrange *e) {
  Integer *width = new Integer(e->loc(), e->width());

  if (const RegType *t = always_cast<const RegType *>(e->base->get_type())) {

    if (t->isSigned()) {
      e->set_type(new IntType(width));
    } else {
      e->set_type(new UintType(width));
    }
  } else {
    e->set_type(nullptr);
  }
  return true;
}

bool TypingAction::VisitPrefixExpr(PrefixExpr *e) {
  if (e->op == PrefixExpr::Op::BitNot) {
    // TODO: ac_int<W+!S, true>
    e->set_type(e->expr->get_type());
  } else {
    e->set_type(nullptr);
  }
  return true;
}

bool TypingAction::VisitCastExpr(CastExpr *e) {
  e->set_type(e->type);
  return true;
}

bool TypingAction::VisitBinaryExpr(BinaryExpr *e) {
  const Type *t1 = e->expr1->get_type();
  const Type *t2 = e->expr2->get_type();
  if ((e->op == BinaryExpr::Op::BitAnd || e->op == BinaryExpr::Op::BitOr
       || e->op == BinaryExpr::Op::BitXor)
      && t1 == t2) {
    e->set_type(t1);
  } else {
    e->set_type(nullptr);
  }
  return true;
}

bool TypingAction::VisitCondExpr(CondExpr *e) {
  e->set_type(nullptr);
  return true;
}

bool TypingAction::VisitMultipleValue(MultipleValue *e) {
  e->set_type(nullptr);
  return true;
}

bool TypingAction::VisitSymDec(SymDec *s) {
  s->type = deref(s->type);
  return true;
}

bool TypingAction::VisitReturnStmt(ReturnStmt *s) {
  s->returnType = deref(type_of_scope);
  assert(s->returnType);
  return true;
}

bool TypingAction::VisitSwitchStmt(SwitchStmt *s) {
  for_each(s->cases_, [s, this](Case *c) {
    if (!c->label) {
      // true
      return;
    }

    const Type *t = c->label->get_type();
    // If it is an enum, t will always be non null.
    if ((t == nullptr || !isa<const EnumType *>(t))
        && !isa<Constant *>(c->label))
      diag_.report(c, c->label,
                   "Case label must be an integer or an enum constant.");
  });
  return true;
}
