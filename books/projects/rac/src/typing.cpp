#include "expressions.h"
#include "types.h"
#include "typing.h"

#include <limits>

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
  // TODO for now, we does not support unsigned literal.
  if (e->val_ > std::numeric_limits<int>::max()
      || e->val_ > std::numeric_limits<int>::min())
    e->set_type(&int64Type);
  else
    e->set_type(&intType);
  return true;
}

bool TypingAction::VisitBoolean(Boolean *e) {
  e->set_type(&boolType);
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
  e->set_type(e->func->returnType);
  return true;
}

bool TypingAction::VisitInitializer(Initializer *e) {
  // TODO ??
  e->set_type(nullptr);
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
  const RegType *t = always_cast<const RegType *>(e->base->get_type());
  e->set_type(new IntType(width, t->isSigned()));

  return true;
}

bool TypingAction::VisitPrefixExpr(PrefixExpr *e) {

  const Type *expr_type = e->expr->get_type();

  // Convert an unscoped enum (scoped enum are not supported) to int.
  if (isa<const EnumType *>(expr_type)) {
    expr_type = &intType;
  }

  // Type primtive type according to section: "Unary arithmetic operators" of
  // https://en.cppreference.com/w/cpp/language/operator_arithmetic
  if (auto t = dynamic_cast<const PrimType *>(expr_type)) {

    if (e->op == PrefixExpr::Op::Not) {
      e->set_type(&boolType);
    } else {

      PrimType *this_type = new PrimType(*t);
      this_type->integerPromtion();
      e->set_type(this_type);
    }
    return true;
  }

  // Type integer register type according to ac_datatypes_ref section 2.3.4.
  if (auto t = dynamic_cast<const IntType *>(expr_type)) {
    switch (e->op) {
    case PrefixExpr::Op::UnaryPlus:
      e->set_type(t);
      break;
    case PrefixExpr::Op::UnaryMinus:
      e->set_type(new IntType(
          new Integer(e->loc(), t->width()->evalConst() + 1), t->isSigned()));
      break;
    case PrefixExpr::Op::BitNot:
      e->set_type(new IntType(
          new Integer(e->loc(), t->isSigned() ? t->width()->evalConst()
                                              : t->width()->evalConst() + 1),
          t->isSigned()));
      break;
    case PrefixExpr::Op::Not:
      e->set_type(&boolType);
      break;
    }
    return true;
    // TODO
  }

  if (isa<const FPType *>(expr_type)) {
    diag_.report(e->loc(), "warning: Fixed point not well supported yet");
    return true;
  }

  // No overload found.
  std::stringstream ss;
  ss << e->op;

  diag_.report(
      e->loc(), e->expr->loc(),
      format("Cannot apply `%s` to an argument which is not a primitive type"
             "(int, int64, uint, uint64, bool) or a register type.",
             ss.str().c_str()));
  return false;
}

bool TypingAction::VisitCastExpr(CastExpr *e) {
  // TODO check incompatible type ex: array -> int
  e->set_type(e->type);
  return true;
}

bool TypingAction::VisitBinaryExpr(BinaryExpr *e) {

  const Type *t1 = e->expr1->get_type();
  const Type *t2 = e->expr2->get_type();

  // Convert an unscoped enum (scoped enum are not supported) to int.
  if (isa<const EnumType *>(t1)) {
    t1 = &intType;
  }
  if (isa<const EnumType *>(t2)) {
    t2 = &intType;
  }

  // Both primtype: we follow those rules:
  // https://en.cppreference.com/w/cpp/language/operator_arithmetic.
  if (isa<const PrimType *>(t1) && isa<const PrimType *>(t2)) {

    PrimType *t1_promoted = new PrimType(*always_cast<const PrimType *>(t1));
    t1_promoted->integerPromtion();

    PrimType *t2_promoted = new PrimType(*always_cast<const PrimType *>(t2));
    t2_promoted->integerPromtion();

    if (BinaryExpr::isOpShift(e->op)) {
      e->set_type(t1_promoted);
      //      delete t2_promoted;
    } else if (BinaryExpr::isOpArithmetic(e->op)
               || BinaryExpr::isOpBitwise(e->op)) {
      e->set_type(PrimType::usual_conversions(t1_promoted, t1_promoted));
    } else if (BinaryExpr::isOpCompare(e->op)
               || BinaryExpr::isOpLogical(e->op)) {
      e->set_type(&boolType);
    } else {
      UNREACHABLE();
    }

    return true;
  }

  if (isa<const IntType *>(t1) || isa<const RegType *>(t2)) {

    // If e1 if not a intType, try to convert int.
    IntType *t1_promoted = nullptr;
    if (auto int_type = dynamic_cast<const IntType *>(t1)) {
      t1_promoted = new IntType(*int_type);
    } else if (auto pt = dynamic_cast<const PrimType *>(t1)) {
      t1_promoted = IntType::FromPrimType(pt);
    } else {
      // TODO more precise.
      diag_.report(e->loc(), e->expr1->loc(),
                   "Incompatible type, rhs is a ac_int<...> but lhs in not "
                   "convertible to a ac_int");
      return false;
    }

    // Same with e2.
    IntType *t2_promoted = nullptr;
    if (auto int_type = dynamic_cast<const IntType *>(t2)) {
      t2_promoted = new IntType(*int_type);
    } else if (auto pt = dynamic_cast<const PrimType *>(t2)) {
      t2_promoted = IntType::FromPrimType(pt);
    } else {
      // TODO more precise.
      diag_.report(e->loc(), e->expr1->loc(),
                   "Incompatible type, lhs is a ac_int<...> but rhs in not "
                   "convertible to a ac_int");
      return false;
    }

    int w1 = t1_promoted->width()->evalConst();
    bool s1 = t1_promoted->isSigned();
    int w2 = t2_promoted->width()->evalConst();
    bool s2 = t2_promoted->isSigned();

    int w_res = -1;
    bool s_res;

    if (BinaryExpr::isOpShift(e->op)) {
      w_res = w1;
      s_res = s1;
    } else if (BinaryExpr::isOpBitwise(e->op) || e->op == BinaryExpr::Op::Plus
               || e->op == BinaryExpr::Op::Minus) {
      w_res = std::max(w1 + (!s1 && s2), w2 + (!s2 && s1)) + 1;
      s_res = (e->op == BinaryExpr::Op::Minus) ? true : s1 || s2;
    } else if (e->op == BinaryExpr::Op::Times
               || e->op == BinaryExpr::Op::Divide) {
      w_res = w1 + w2;
      s_res = s1 || s2;
    } else if (e->op == BinaryExpr::Op::Mod) {
      w_res = std::min(w1, w2 + (!s2 && s1));
      s_res = s1;
    } else if (BinaryExpr::isOpCompare(e->op)
               || BinaryExpr::isOpLogical(e->op)) {
      e->set_type(&boolType);
      return true;
    } else {
      UNREACHABLE();
    }
    e->set_type(new IntType(new Integer(e->loc(), w_res), s_res));
    return true;
  }

  if (isa<const FPType *>(t1) || isa<const FPType *>(t2)) {
    diag_.report(e->loc(), "warning: Fixed point not well supported yet");
    return true;
  }

  // No overload found.
  std::stringstream ss;
  ss << e->op;

  diag_.report(
      e->loc(), e->loc(),
      format("Cannot apply `%s` to an argument which is not a primitive type"
             "(int, int64, uint, uint64, bool) or a register type.",
             ss.str().c_str()));

  return false;
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

  return std::all_of(s->cases_.begin(), s->cases_.end(), [this](Case *c) {
    if (!c->label) {
      return true;
    }

    const Type *t = c->label->get_type();
    // If it is an enum, t will always be non null.
    if ((t == nullptr || !isa<const EnumType *>(t))
        && !isa<Constant *>(c->label)) {
      diag_.report(c->loc(), c->label->loc(),
                   "Case label must be an integer or an enum constant.");
      return false;
    }
    return true;
  });
}
