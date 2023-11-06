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

  if (!base_t::TraverseCase(s)) {
    return false;
  }

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

  previous_break_loc_ = { s->loc() };
  return true;
}
