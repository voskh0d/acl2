#include <limits>

#include "returnfalse.h"
#include "typing.h"

#include "../parser/ast/expressions.h"
#include "../parser/ast/types.h"

// Expressions:

bool TypingAction::TraverseExpression(Expression *e) {

  // For all expressions, we try to type it...
  if (!base_t::TraverseExpression(e))
    return error();

  // ... and deref its type.
  if (e) {
    e->set_type(deref(e->get_type()));
  }

  return true;
}

bool TypingAction::TraverseFunDef(FunDef *e) {

  // When entering a function (a new scope), we store it's return type as it
  // will be usefull to type check the returns.
  assert(!type_of_scope);
  type_of_scope = e->returnType;

  if (!base_t::TraverseFunDef(e)) {
    type_of_scope = nullptr;
    return error();
  }

  type_of_scope = nullptr;

  return true;
}

bool TypingAction::TraverseTemplate(Template *e) {

  // Same as FunDef, since template are not really
  assert(!type_of_scope);
  type_of_scope = e->returnType;

  if (!base_t::TraverseTemplate(e)) {
    type_of_scope = nullptr;
    return error();
  }

  type_of_scope = nullptr;

  return true;
}

bool TypingAction::VisitInteger(Integer *e) {
  // TODO for now, we does not support unsigned literal.

  // The type of the integer literal is the first type in which the value can
  // fit. If the literal is written in decimal, then it is always signed.
  // https://en.cppreference.com/w/cpp/language/integer_literal
  if (e->format() == Integer::Format::Decimal) {
    if (e->val_ <= std::numeric_limits<int>::max()
        && e->val_ >= std::numeric_limits<int>::min())
      e->set_type(&intType);
    else
      e->set_type(&int64Type);
  } else {
    if (e->val_ <= std::numeric_limits<int>::max()
        && e->val_ >= std::numeric_limits<int>::min()) {
      e->set_type(&intType);
    } else if (e->val_ <= std::numeric_limits<unsigned>::max()
               && e->val_ >= std::numeric_limits<unsigned>::min()) {
      e->set_type(&uintType);
    } else if (e->val_ < std::numeric_limits<long>::max()
               && e->val_ >= std::numeric_limits<long>::min()) {
      e->set_type(&int64Type);
    } else if (static_cast<unsigned long>(e->val_)
                   < std::numeric_limits<unsigned long>::max()
               && static_cast<unsigned long>(e->val_)
                      >= std::numeric_limits<unsigned long>::min()) {
      e->set_type(&uint64Type);
    } else {
      UNREACHABLE();
    }
  }
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
  e->set_type(deref(e->symDec->type));
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

  // Infer type.
  std::vector<const Type *> types;
  for_each(e->vals, [&](Constant *c) { types.push_back(c->get_type()); });
  e->set_type(new InitializerType({ e->loc() }, std::move(types)));

  return true;
}

bool TypingAction::VisitArrayRef(ArrayRef *e) {
  if (auto array_type
      = dynamic_cast<const ArrayType *>(e->array->get_type())) {
    e->set_type(deref(array_type->getBaseType()));
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

  if (const IntType *t = dynamic_cast<const IntType *>(e->base->get_type())) {
    Integer *width = new Integer(e->loc(), e->width());
    e->set_type(new IntType(e->loc(), width, t->isSigned()));
  } else {
    diag_
        .new_error(e->base->loc(),
                   format("Base (of type %s) is not a register",
                          e->base->get_type()->to_string().c_str()))
        .context(e->loc())
        .report();
  }

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
          e->loc(), new Integer(e->loc(), t->width()->evalConst() + 1),
          t->isSigned()));
      break;
    case PrefixExpr::Op::BitNot:
      e->set_type(new IntType(
          e->loc(),
          new Integer(e->loc(), t->isSigned() ? t->width()->evalConst()
                                              : t->width()->evalConst() + 1),
          t->isSigned()));
      break;
    case PrefixExpr::Op::Not:
      e->set_type(&boolType);
      break;
    }
    return true;
  }

  // No overload found.
  diag_
      .new_error(
          e->expr->loc(),
          format(
              "Cannot apply `%s` to an argument of type `%s` which is not a "
              "register type or a primitive type, aka int, int64, uint, "
              "uint64, bool.",
              to_string(e->op).c_str(), expr_type->to_string().c_str()))
      .context(e->loc())
      .report();

  e->set_type(new ErrorType());
  return error();
}

bool TypingAction::VisitCastExpr(CastExpr *e) {
  const Type *t = deref(e->type);
  e->set_type(t);
  if (!e->expr->get_type()->canBeImplicitlyCastTo(t)) {
    diag_
        .new_error(e->loc(),
                   format("Incompatible types: %s cannot be cast to %s",
                          e->expr->get_type()->to_string().c_str(),
                          t->to_string().c_str()))
        .report();
    return error();
  }
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
      delete t2_promoted;
    } else if (BinaryExpr::isOpArithmetic(e->op)
               || BinaryExpr::isOpBitwise(e->op)) {
      e->set_type(PrimType::usual_conversions(t1_promoted, t2_promoted));
    } else if (BinaryExpr::isOpCompare(e->op)
               || BinaryExpr::isOpLogical(e->op)) {
      e->set_type(&boolType);
    } else {
      UNREACHABLE();
    }

    return true;
  }

  if (isa<const IntType *>(t1) || isa<const IntType *>(t2)) {

    // If e1 if not a intType, try to convert int.
    IntType *t1_promoted = nullptr;
    if (auto int_type = dynamic_cast<const IntType *>(t1)) {
      t1_promoted = new IntType(*int_type);
    } else if (auto pt = dynamic_cast<const PrimType *>(t1)) {
      t1_promoted = IntType::FromPrimType(pt);
    } else {
      diag_
          .new_error(e->expr1->loc(),
                     format("Invalid type: left operand is a `%s` but right "
                            "(%s) is not convertible to a register type.",
                            t2->to_string().c_str(), t1->to_string().c_str()))
          .context(e->loc())
          .report();

      e->set_type(new ErrorType());
      return error();
    }

    // Same with e2.
    IntType *t2_promoted = nullptr;
    if (auto int_type = dynamic_cast<const IntType *>(t2)) {
      t2_promoted = new IntType(*int_type);
    } else if (auto pt = dynamic_cast<const PrimType *>(t2)) {
      t2_promoted = IntType::FromPrimType(pt);
    } else {
      diag_
          .new_error(e->expr2->loc(),
                     format("Invalid type: right operand is a `%s` but left "
                            "(%s) is not convertible to a register type.",
                            t1->to_string().c_str(), t2->to_string().c_str()))
          .context(e->loc())
          .report();

      e->set_type(new ErrorType());
      return error();
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
    } else if (BinaryExpr::isOpBitwise(e->op)) {
      w_res = std::max(w1 + (!s1 && s2), w2 + (!s2 && s1));
      s_res = (e->op == BinaryExpr::Op::Minus) ? true : s1 || s2;
    } else if (e->op == BinaryExpr::Op::Plus
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
    e->set_type(new IntType(e->loc(), new Integer(e->loc(), w_res), s_res));
    return true;
  }

  // No overload found.
  diag_
      .new_error(e->loc(),
                 format("Cannot apply `%s` to arguments of type %s and %s",
                        to_string(e->op).c_str(), t1->to_string().c_str(),
                        t2->to_string().c_str()))
      .context(e->loc())
      .note("They should be both a primitive type (like an int or enum) or a "
            "register type.")
      .report();

  e->set_type(new ErrorType());
  return error();
}

bool TypingAction::VisitCondExpr(CondExpr *e) {

  // Convertible to bool
  if (!isIntegerType(e->test->get_type())) {
    diag_
        .new_error(e->test->loc(),
                   format("Expected a boolean, got `%s`.",
                          e->test->get_type()->to_string().c_str()))
        .context(e->loc())
        .report();

    e->set_type(new ErrorType());
    return error();
  }

  // TODO they don't need to be exacly equal, for ex int and long works
  if (auto t1 = dynamic_cast<const PrimType *>(e->expr1->get_type())) {
    if (auto t2 = dynamic_cast<const PrimType *>(e->expr2->get_type())) {
      e->set_type(PrimType::usual_conversions(t1, t2, false));
      return true;
    }
  }

  if (!e->expr1->get_type()->isEqual(e->expr2->get_type())) {
    diag_
        .new_error(
            e->loc(),
            format("Left and right do not share same type (left is `%s` "
                   "and right `%s`).",
                   e->expr1->get_type()->to_string().c_str(),
                   e->expr2->get_type()->to_string().c_str()))
        .report();

    e->set_type(new ErrorType());
    return error();
  }

  e->set_type(e->expr1->get_type());

  return true;
}

bool TypingAction::VisitMultipleValue(MultipleValue *e) {

  if (e->expr.size() != e->type->size()) {
    diag_
        .new_error(
            e->loc(),
            format("Expected %d argument(s) (from its type: `%s`), got `%d`.",
                   e->type->size(), e->type->to_string().c_str(),
                   e->expr.size()))
        .report();
    e->set_type(new ErrorType());
    return error();
  }

  bool has_failed = false;
  unsigned size = e->expr.size();
  for (unsigned i = 0; i < size; ++i) {

    const Type *expected = e->type->get(i);
    const Type *actual = e->expr[i]->get_type();

    if (!expected->isEqual(actual)) {

      diag_
          .new_error(e->expr[i]->loc(),
                     format("Expected `%s` (from `%s` at index %d), got `%s`",
                            expected->to_string().c_str(),
                            e->type->to_string().c_str(), i,
                            actual->to_string().c_str()))
          .context(e->loc())
          .report();

      has_failed = true;
    }
  }

  e->set_type(e->type);

  e->set_type(new ErrorType());
  return has_failed ? error() : true;
}

// Statements:

bool TypingAction::VisitReturnStmt(ReturnStmt *s) {

  s->returnType = deref(type_of_scope);
  return check_assignement(s->loc(), s->returnType, s->value->get_type());
}

bool TypingAction::VisitSwitchStmt(SwitchStmt *s) {

  const Type *t = s->test()->get_type();

  bool canBeCastToInt = t->canBeImplicitlyCastTo(&uint64Type)
                        || t->canBeImplicitlyCastTo(&int64Type);

  if (!isa<const PrimType *>(t) && !canBeCastToInt) {
    diag_
        .new_error(s->test_->loc(),
                   format("Expected a primtive type, got `%s`",
                          t->to_string().c_str()))
        .context(s->loc())
        .report();

    return error();
  }

  return std::all_of(s->cases().begin(), s->cases().end(), [this](Case *c) {
    // Default case.
    if (c->isDefaultCase()) {
      return true;
    }

    // A label is either an enum value or a constant primtive.
    const Type *t = c->label->get_type();
    if (!(isa<const PrimType *>(t) && isa<Constant *>(c->label))
        && !isa<const EnumType *>(t)) {
      diag_
          .new_error(c->label->loc(),
                     "Case label must be an integer or an enum constant.")
          .context(c->loc())
          .report();
      return error();
    }
    return true;
  });
}

bool TypingAction::VisitAssignment(Assignment *s) {

  if (!strcmp(s->op, "set_slc")) {

    if (!isa<const IntType *>(s->lval->get_type())) {
      diag_
          .new_error(s->lval->loc(),
                     format("Base (of type %s) is not a register",
                            s->lval->get_type()->to_string().c_str()))
          .context(s->loc())
          .report();
      return error();
    }

    if (!isa<const IntType *>(s->rval->get_type())) {
      diag_
          .new_error(s->rval->loc(),
                     format("Value (of type %s) is not a register",
                            s->rval->get_type()->to_string().c_str()))
          .context(s->loc())
          .report();
      return error();
    }

    if (!isIntegerType(s->index->get_type())) {
      diag_
          .new_error(
              s->index->loc(),
              format("Expected an integer (ac_int, int, ..,), got %s instead",
                     s->index->get_type()->to_string().c_str()))
          .context(s->loc())
          .report();
      return error();
    }

    return true;
  }

  return check_assignement(s->loc(), s->lval->get_type(), s->rval->get_type());
}

bool TypingAction::VisitSymDec(SymDec *s) {

  if (s->init) {
    return check_assignement(s->loc(), deref(s->type), s->init->get_type());
  }
  return true;
}

bool TypingAction::check_assignement(const Location &where, const Type *left,
                                     const Type *right) {

  // TODO: refactore this nightmare.
  // Initializer list can be used in two differents context: array and
  // struct. Strong typed Initialization is not supported yet.
  if (auto t = dynamic_cast<const InitializerType *>(right)) {

    if (auto array = dynamic_cast<const ArrayType *>(left)) {

      unsigned array_size = array->dim->evalConst();

      if (t->size() > array_size) {
        diag_
            .new_error(
                where,
                format(
                    "Too many arguments, %s, expected %d argument(s) got %d",
                    array_size, t->size()))
            .report();
        return error();
      }

      auto is_correct = std::all_of(
          t->types().begin(), t->types().end(), [&](const Type *t) {
            if (!t->canBeImplicitlyCastTo(array->baseType)) {
              diag_
                  .new_error(
                      where,
                      format("Wrong type provided, expected %s but got %s",
                             array->baseType->to_string().c_str(),
                             t->to_string().c_str()))
                  .report();
              return false;
            }
            return true;
          });

      return is_correct ? true : error();

    } else if (auto struct_ = dynamic_cast<const StructType *>(left)) {

      unsigned struct_size = struct_->fields().size();

      if (t->size() > struct_size) {
        diag_
            .new_error(
                where,
                format("Too many arguments, expected %d argument(s) got %d",
                       struct_size, t->size()))
            .report();
        return error();
      }

      unsigned i = 0;
      auto is_correct = std::all_of(
          t->types().begin(), t->types().end(), [&](const Type *t) {
            Type *field_type = struct_->fields()[i]->type;
            if (!t->canBeImplicitlyCastTo(field_type)) {
              diag_
                  .new_error(
                      where,
                      format("Wrong type provided, expected %s but got %s",
                             field_type->to_string().c_str(),
                             t->to_string().c_str()))
                  .report();
              return false;
            }
            ++i;
            return true;
          });

      return is_correct ? true : error();

    } else {
      diag_
          .new_error(where,
                     format("Initializer list are not yet supported for %s",
                            left->to_string().c_str()))
          .report();
      return error();
    }
  }

  bool is_same_type = right->isEqual(left);
  bool can_be_cast = right->canBeImplicitlyCastTo(left);

  if (!is_same_type && !can_be_cast) {
    diag_
        .new_error(where, format("Incompatible types: %s cannot be cast to %s",
                                 right->to_string().c_str(),
                                 left->to_string().c_str()))
        .report();
    return error();
  }
  return true;
}
