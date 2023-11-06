#ifndef RACCONSTRAINT_H
#define RACCONSTRAINT_H

#include "visitor.h"

class RACConstraint final : public RecursiveASTVisitor<RACConstraint> {
public:
  RACConstraint(DiagnosticHandler &diag) : diag_(diag) {}

  // Check restriction on break:
  //   * default: statements... may occur only as the final case of the
  //     statement
  //   * case label: statements... break must always be the last statement
  //     except if there is no statement.

  // Check if default is unique and the last case.
  bool VisitSwitchStmt(SwitchStmt *s);

  // Check if break is the last statement.
  bool TraverseCase(Case *s);
  bool VisitStatement(Statement *s);
  bool VisitBreakStmt(BreakStmt *s);

private:
  using base_t = RecursiveASTVisitor<RACConstraint>;

  DiagnosticHandler &diag_;

  std::optional<Location> previous_break_loc_ = {};
  Case *last_case_ = nullptr;
};

#endif // RACCONSTRAINT_H
