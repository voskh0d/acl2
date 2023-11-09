#include "racconstraint.h"

#include <optional>

bool RACConstraint::VisitSwitchStmt(SwitchStmt *s) {

  // Check that no case, other that the last one, is default.
  bool is_last = true;
  std::optional<Location> first_default_loc = {};

  for (auto it = s->cases().rbegin(); it != s->cases().rend(); ++it) {

    const auto &c = **it;

    if (c.isDefaultCase()) {
      if (!is_last) {

        if (first_default_loc) {

          diag_.new_error(c.loc(), "Duplicate default case")
              .context(s->loc())
              .note("previous default was declared here:")
              .note_location(*first_default_loc)
              .report();

        } else {
          diag_.new_error(c.loc(), "Default case is not the last case")
              .context(s->loc())
              .report();
        }

        return false;
      } else {
        first_default_loc = { c.loc() };
      }
    }

    is_last = false;
  }

  unsigned size = s->cases().size();
  last_case_ = size ? s->cases()[size - 1] : nullptr;

  return true;
}

bool RACConstraint::TraverseCase(Case *s) {

  in_switch_ = true;

  if (!base_t::TraverseCase(s)) {
    return false;
  }

  in_switch_ = false;

  if (s->action && s != last_case_ && !previous_break_loc_) {
    diag_.new_error(s->loc(), "No break at the end of case").report();
    return false;
  }

  previous_break_loc_ = {};
  return true;
}

bool RACConstraint::VisitStatement(Statement *s) {

  if (previous_break_loc_) {
    diag_.new_error(s->loc(), "Statement after break")
        .note("this statment is hidden by")
        .note_location(*previous_break_loc_)
        .report();
    return false;
  }
  return true;
}

bool RACConstraint::VisitBreakStmt(BreakStmt *s) {

  if (!in_switch_) {
    diag_.new_error(s->loc(), "break outside of switch")
        .note("RAC forbid break and continue inside loops")
        .report();
    return false;
  }

  previous_break_loc_ = { s->loc() };
  return true;
}

bool RACConstraint::TraverseFunDef(FunDef *s) {
  // Copy and pasted from visitor.hxx.

  if (!postfixTraversal())
    if (!WalkUpFunDef(s))
      return false;

  disable_assignement_check_ = true;

  bool b = true;
  for_each(s->params, [&](VarDec *s) {
    if (b && !TraverseStatement(s))
      b = false;
  });

  disable_assignement_check_ = false;

  if (!b)
    return false;

  if (!TraverseStatement(s->body))
    return false;

  if (postfixTraversal())
    if (!WalkUpFunDef(s))
      return false;

  return true;
}

bool RACConstraint::VisitVarDec(VarDec *s) {

  if (disable_assignement_check_) {
    return true;
  }

  if (!s->init) {
    diag_.new_error(s->loc(), "variable must be assigned directly")
        .note("non initialized variable can introduce undefined behavior")
        .report();
    return false;
  }
  return true;
}

bool RACConstraint::VisitMulVarDec(MulVarDec *s) {

  if (disable_assignement_check_) {
    return true;
  }

  bool sucess = true;
  for_each(s->decs, [&](const auto vd) {
    if (!vd->init) {
      diag_.new_error(vd->loc(), "variable must be assigned directly")
          .note("non initialized variable can introduce undefined behavior")
          .context(vd->loc())
          .report();
      sucess = false;
    }
  });
  return sucess;
}

bool RACConstraint::VisitMulConstDec(MulConstDec *s) {

  if (disable_assignement_check_) {
    return true;
  }

  bool sucess = true;
  for_each(s->decs, [&](const auto vd) {
    if (!vd->init) {
      diag_.new_error(vd->loc(), "variable must be assigned directly")
          .note("non initialized variable can introduce undefined behavior")
          .context(vd->loc())
          .report();
      sucess = false;
    }
  });
  return sucess;
}
