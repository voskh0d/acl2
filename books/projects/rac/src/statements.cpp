#include "statements.h"
#include "functions.h"
#include "program.h"

#include <iomanip>

//***********************************************************************************
// class Statement
//***********************************************************************************

// Derived classes:

//   SimpleStatement       (statement that does not include substatements)
//     VarDec              (variable declaration)
//       ConstDec          (constant declaration)
//     MulVarDec           (multiple variable declaration)
//     MulConstDec         (multiple constant declaration)
//     BreakStmt           (break -- may occur only within a switch)
//     ReturnStmt          (return)
//     Assertion           (assert)
//     Assignment          (=, ++, --, +=, etc.)
//     MultipleAssignment  (assignment of multiple function value)
//     NullStmt            (null statement)
//   Block                 (list of statements)
//   IfStmt                (if or if ... else)
//   ForStmt               (for)
//   SwitchStmt            (switch)

// This method is designed to handle if ... else if ... :

void Statement::displayAsRightBranch(
    std::ostream &os, unsigned indent) { // virtual (overridden by IfStmt)
  display(os, indent + 2);
}

// This method is designed to handle nested blocks:

void Statement::displayWithinBlock(
    std::ostream &os, unsigned indent) { // virtual (overridden by Block)
  display(os, indent);
}

// Turn into a block if not already one:

Block *Statement::blockify() { // virtual (overridden by Block)
  return new Block(this);
}

// Create a block consisting of s appended to this:

Block *Statement::blockify(Statement *s) { // virtual (overridden by Block)
  return new Block(this, s);
}

// class SimpleStatement : public Statement
// ----------------------------------------

void SimpleStatement::display(std::ostream &os, unsigned indent) {
  os << "\n";
  if (indent) {
    os << std::setw(indent) << " ";
  }
  displaySimple(os);
  os << ";";
}

// class SymDec (symbol declaration)
// ------------

// Derived classes: EnumConstDec, VarDec, and TempParamDec.

// Data members: Symbol* sym; Type *type; Expression *init; (init is optional)

SymDec::SymDec(const char *n, Type *t, Expression *i)
    : SimpleStatement(idOf(this)), sym(new Symbol(n)), type(t), init(i) {}

SymDec::SymDec(NodesId id, const char *n, Type *t, Expression *i)
    : SimpleStatement(id), sym(new Symbol(n)), type(t), init(i) {}

void SymDec::displaySymDec(std::ostream &os) const {
  type->displayVarType(os);
  os << " ";
  type->displayVarName(getname(), os);
  if (init) {
    os << " = ";
    init->display(os);
  }
}

bool SymDec::isConst() {
  return false;
} // overridden by EnumConstDec and ConstDec

int SymDec::evalConst() {
  assert(init);
  return init->evalConst();
}

bool SymDec::isGlobal() { return false; }

bool SymDec::isROM() { return false; }

Sexpression *
SymDec::ACL2SymExpr() { // Sexpression for a reference to this symbol.
  assert(!"Undefined method: ACL2SymExpr");
  return nullptr;
}

// class EnumConstDec : public SymDec
// ----------------------------------

EnumConstDec::EnumConstDec(const char *n, Expression *v)
    : SymDec(idOf(this), n, &intType, v) {}

void EnumConstDec::display(std::ostream &os) const {
  os << getname();
  if (init) {
    os << "=";
    init->display(os);
  }
}

bool EnumConstDec::isConst() { return true; }

Sexpression *EnumConstDec::ACL2Expr() {
  if (init) {
    return new Plist({ sym, init->ACL2Expr() });
  } else {
    return sym;
  }
}

Sexpression *EnumConstDec::ACL2SymExpr() {
  return always_cast<const EnumType *>(type)->getEnumVal(sym);
}

// class VarDec : public SimpleStatement, public SymDec (variable declaration)
// ---------------------------------------------------------------------------

VarDec::VarDec(const char *n, Type *t, Expression *i)
    : SymDec(idOf(this), n, t, i) {}

VarDec::VarDec(NodesId id, const char *n, Type *t, Expression *i)
    : SymDec(id, n, t, i) {}

void VarDec::displaySimple(std::ostream &os) { displaySymDec(os); }

Sexpression *VarDec::ACL2Expr() {
  Sexpression *val;
  if (isa<const ArrayType *>(type)) {
    if (!init) {
      val = new Plist();
    } else if (isROM()) {
      val = new Plist({ &s_quote, init->ACL2Expr() });
    } else {
      val = init->ACL2ArrayExpr();
    }
  } else if (isa<const StructType *>(type)) {
    if (!init) {
      val = new Plist();
    } else if (Initializer *i = dynamic_cast<Initializer *>(init)) {
      val = i->ACL2StructExpr(always_cast<const StructType *>(type)->fields());
    } else {
      val = init->ACL2ArrayExpr();
    }
  } else if (init) {
    val = type->ACL2Assign(init);
  } else {
    val = &i_0;
  }
  return new Plist({ &s_declare, sym, val });
}

Sexpression *VarDec::ACL2SymExpr() { return sym; }

// class ConstDec : public VarDec
// ------------------------------

ConstDec::ConstDec(const char *n, Type *t, Expression *i)
    : VarDec(idOf(this), n, t, i) {}

void ConstDec::displaySimple(std::ostream &os) {
  os << "const ";
  VarDec::displaySimple(os);
}

bool ConstDec::isConst() { return isIntegerType(type); }

bool ConstDec::isGlobal() {
  // TODO is the == this is really necessary ?
  return prog.getConstDec(getname()) == this;
}

bool ConstDec::isROM() { return isGlobal() && isa<const ArrayType *>(type); }

Sexpression *ConstDec::ACL2SymExpr() {
  if (isGlobal()) {
    return new Plist({ sym });
  } else {
    return sym;
  }
}

// class MulVarDec : public SimpleStatement  (multiple variable declaration)
// ---------------------------------------------------------------------------

MulVarDec::MulVarDec(VarDec *dec1, VarDec *dec2)
    : SimpleStatement(idOf(this)) {
  decs = new List<VarDec>(dec1, dec2);
}

MulVarDec::MulVarDec(List<VarDec> *d) : SimpleStatement(idOf(this)), decs(d) {}

Sexpression *MulVarDec::ACL2Expr() {
  Plist *result = new Plist({ &s_list });
  List<VarDec> *ptr = decs;
  while (ptr) {
    result->add(ptr->value->ACL2Expr());
    ptr = ptr->next;
  }
  return result;
}

void MulVarDec::displaySimple(std::ostream &os) {
  List<VarDec> *dlist = decs;
  VarDec *d = decs->value;
  d->type->displayVarType(os);
  while (dlist) {
    os << " ";
    d->type->displayVarName(d->getname(), os);
    if (d->init) {
      os << " = ";
      d->init->display(os);
    }
    dlist = dlist->next;
    if (dlist) {
      d = dlist->value;
      os << ",";
    }
  }
}

// class MulConstDec : public SimpleStatement  (multiple constant declaration)
// ---------------------------------------------------------------------------

MulConstDec::MulConstDec(ConstDec *dec1, ConstDec *dec2)
    : SimpleStatement(idOf(this)) {
  decs = new List<ConstDec>(dec1, dec2);
}

MulConstDec::MulConstDec(List<ConstDec> *d)
    : SimpleStatement(idOf(this)), decs(d) {}

Sexpression *MulConstDec::ACL2Expr() {
  Plist *result = new Plist({ &s_list });
  List<ConstDec> *ptr = decs;
  while (ptr) {
    result->add(ptr->value->ACL2Expr());
    ptr = ptr->next;
  }
  return result;
}

void MulConstDec::displaySimple(std::ostream &os) {
  List<ConstDec> *dlist = decs;
  ConstDec *d = decs->value;
  d->type->displayVarType(os);
  while (dlist) {
    os << " ";
    d->type->displayVarName(d->getname(), os);
    if (d->init) {
      os << " = ";
      d->init->display(os);
    }
    dlist = dlist->next;
    if (dlist) {
      d = dlist->value;
      os << ",";
    }
  }
}

// class TempParamDec : public VarDec  (template parameter declaration)
// --------------------------------------------------------------------

TempParamDec::TempParamDec(const char *n, Type *t)
    : SymDec(idOf(this), n, t) {}

bool TempParamDec::isConst() { return true; }

Sexpression *TempParamDec::ACL2SymExpr() {
  return init ? type->ACL2Assign(init) : &i_0;
}

// class BreakStmt : public SimpleStatement
// ----------------------------------------

BreakStmt::BreakStmt() : SimpleStatement(idOf(this)) {}

void BreakStmt::displaySimple(std::ostream &os) { os << "break"; }

Sexpression *BreakStmt::ACL2Expr() { return &s_break; }

BreakStmt breakStmt;

// class ReturnStmt : public SimpleStatement
// -----------------------------------------

// Data members: Expression *value;

ReturnStmt::ReturnStmt(Expression *v)
    : SimpleStatement(idOf(this)), value(v) {}

void ReturnStmt::displaySimple(std::ostream &os) {
  os << "return ";
  value->display(os);
}

Sexpression *ReturnStmt::ACL2Expr() {
  return new Plist({ &s_return, returnType->ACL2Assign(value) });
}

// class Assertion : public SimpleStatement
// ----------------------------------------

// Data member: Expression *expr;

Assertion::Assertion(Expression *e) : SimpleStatement(idOf(this)), expr(e) {}

void Assertion::displaySimple(std::ostream &os) {
  os << "assert(";
  expr->display(os);
  os << ")";
}

Sexpression *Assertion::ACL2Expr() {
  assert(funDef && "MarkAssertion should be run first");
  return new Plist(
      { &s_assert, expr->ACL2Expr(), new Symbol(funDef->getname()) });
}

// class Assignment : public SimpleStatement
// -----------------------------------------

// Data members: Expression *lval; const char* op; Expression *rval;

Assignment::Assignment(Expression *l, const char *o, Expression *r)
    : SimpleStatement(idOf(this)), lval(l), op(o), rval(r) {}

void Assignment::displaySimple(std::ostream &os) {
  lval->display(os);
  if (rval) {
    os << " " << op << " ";
    rval->display(os);
  } else {
    os << op;
  }
}

Sexpression *Assignment::ACL2Expr() {
  Expression *expr = rval;
  if (!strcmp(op, "=")) {
    expr = rval;
  } else if (!strcmp(op, "++")) {
    expr = new BinaryExpr(lval, &i_1, "+");
  } else if (!strcmp(op, "--")) {
    expr = new BinaryExpr(lval, &i_1, "-");
  } else if (!strcmp(op, ">>=")) {
    expr = new BinaryExpr(lval, rval, ">>");
  } else if (!strcmp(op, "<<=")) {
    expr = new BinaryExpr(lval, rval, "<<");
  } else if (!strcmp(op, "+=")) {
    expr = new BinaryExpr(lval, rval, "+");
  } else if (!strcmp(op, "-=")) {
    expr = new BinaryExpr(lval, rval, "-");
  } else if (!strcmp(op, "*=")) {
    expr = new BinaryExpr(lval, rval, "*");
  } else if (!strcmp(op, "%=")) {
    expr = new BinaryExpr(lval, rval, "%");
  } else if (!strcmp(op, "&=")) {
    expr = new BinaryExpr(lval, rval, "&");
  } else if (!strcmp(op, "^=")) {
    expr = new BinaryExpr(lval, rval, "^");
  } else if (!strcmp(op, "|=")) {
    expr = new BinaryExpr(lval, rval, "|");
  } else if (strcmp(op, "set_slc")) {
    assert(!"Unknown assignment operator");
  }
  const Type *lval_type = lval->get_type();
  Sexpression *sexpr
      = lval_type ? lval_type->ACL2Assign(expr) : expr->ACL2Expr();

  if (!strcmp(op, "set_slc")) {
    const Type *rval_type = rval->get_type();
    if (!rval_type || !isa<const RegType *>(rval_type)) {
      assert(!"Second arg of set_slc must have a defined width");
    }

    unsigned w = always_cast<const RegType *>(rval_type)->width()->evalConst();

    Subrange lval_slc(lval, index, w);
    return lval_slc.ACL2Assign(sexpr);
  } else {
    return lval->ACL2Assign(sexpr);
  }
}

// class MultipleAssignment : public SimpleStatement
// -------------------------------------------------

// Data members: Expression *lval[8]; FunCall *rval;

MultipleAssignment::MultipleAssignment(FunCall *r, std::vector<Expression *> e)
    : SimpleStatement(idOf(this)), lval_(e), rval_(r) {}

void MultipleAssignment::displaySimple(std::ostream &os) {
  assert(lval_.size() > 0);
  os << "<";
  lval_[0]->display(os);
  for (Expression *e : lval_) {
    os << ", ";
    e->display(os);
  }
  os << "> = ";
  rval_->display(os);
}

// In the event that each target of a multiple assignment is a simple variable,
// the corrersponding S-expression  has the form

//   (MV-ASSIGN (var1 ... vark) fncall).

// Otherwise, for each target that is not a simple variable (i.e., a reference
// to an array entry, a struct field, a subrange, or a bit), a temporary
// variable and an additional assignment are introduced, and the S-expression
// has the form

//   (BLOCK (MV-ASSIGN (var1 ... vark) fncall) (ASSIGN ...) ... (ASSIGN ...)).

// For example, the statement

//   foo(...).assign(x, y[i], z.range(j, k))

// where y is an array and z is a register of width 8, generates the following:

//   (BLOCK (MV-ASSIGN (X TEMP-0 TEMP-1) (FOO ...))
//          (ASSIGN Y (AS I TEMP-0 Y))
//          (ASSIGN Z (SETBITS Z 8 J K TEMP-1))).

Sexpression *MultipleAssignment::ACL2Expr() {
  Plist *vars = new Plist();
  Plist *result = new Plist({ &s_mv_assign, vars, rval_->ACL2Expr() });
  bool isBlock = false;
  for (unsigned i = 0; i < lval_.size(); i++) {
    if (SymRef *ref = dynamic_cast<SymRef *>(lval_[i])) {
      vars->add(ref->symDec->sym);
    } else {
      if (!isBlock) {
        result = new Plist({ result });
        isBlock = true;
      }

      Symbol *s_temp = new Symbol("temp-" + std::to_string(i));
      vars->add(s_temp);
      result->add(lval_[i]->ACL2Assign(s_temp));
      result->push(new Plist({ &s_declare, s_temp }));
    }
  }
  if (isBlock) {
    result->push(&s_block);
  }
  return result;
}

// class NullStmt : public SimpleStatement (null statement)
// --------------------------------------------------

NullStmt::NullStmt() : SimpleStatement(idOf(this)) {}

void NullStmt::displaySimple([[maybe_unused]] std::ostream &os) {}

Sexpression *NullStmt::ACL2Expr() { return new Plist({ &s_null }); }

NullStmt nullStmt;

// class Block : public Statement
// ------------------------------

// Data member: List<Statement> *stmtList;

Block::Block(List<Statement> *s) : Statement(idOf(this)), stmtList(s) {}

Block::Block(Statement *s) : Statement(idOf(this)) {
  stmtList = new List<Statement>(s);
}

Block::Block(Statement *s1, Statement *s2) : Statement(idOf(this)) {
  stmtList = new List<Statement>(s1, new List<Statement>(s2));
}

Block::Block(Statement *s1, Statement *s2, Statement *s3)
    : Statement(idOf(this)) {
  stmtList = new List<Statement>(
      s1, new List<Statement>(s2, new List<Statement>(s3)));
}

Block *Block::blockify() { return this; }

Block *Block::blockify(Statement *s) {
  return new Block(stmtList ? stmtList->copy()->add(s)
                            : new List<Statement>(s));
}

void Block::display(std::ostream &os, unsigned indent) {
  os << " {";
  if (stmtList) {
    List<Statement> *ptr = stmtList;
    while (ptr) {
      ptr->value->displayWithinBlock(os, indent);
      ptr = ptr->next;
    }
    os << "\n";
    if (indent > 2) {
      os << std::setw(indent - 2) << " ";
    }
  }
  os << "}";
}

void Block::displayWithinBlock(std::ostream &os, unsigned indent) {
  os << "\n" << std::setw(indent) << (indent ? " " : "") << "{";
  List<Statement> *ptr = stmtList;
  while (ptr) {
    ptr->value->displayWithinBlock(os, indent + 2);
    ptr = ptr->next;
  }
  os << "\n";
  if (indent) {
    os << std::setw(indent) << " ";
  }
  os << "}";
}

Sexpression *Block::ACL2Expr() {
  Plist *result = new Plist({ &s_block });
  List<Statement> *ptr = stmtList;
  while (ptr) {
    result->add(ptr->value->ACL2Expr());
    ptr = ptr->next;
  }
  return result;
}

// class IfStmt : public Statement
// -------------------------------

// Data members: Expression *test; Statement *left; Statement *right;

IfStmt::IfStmt(Expression *t, Statement *l, Statement *r)
    : Statement(idOf(this)), test(t), left(l), right(r) {}

void IfStmt::display(std::ostream &os, unsigned indent) {
  os << "\n" << std::setw(indent) << " ";
  displayAsRightBranch(os, indent);
}

void IfStmt::displayAsRightBranch(std::ostream &os, unsigned indent) {
  os << "if (";
  test->display(os);
  os << ")";
  left->display(os, indent + 2);
  if (right) {
    os << "\n"
       << std::setw(indent) << " "
       << "else ";
    right->displayAsRightBranch(os, indent);
  }
}

Sexpression *IfStmt::ACL2Expr() {
  return new Plist({ &s_if, test->ACL2Expr(), left->blockify()->ACL2Expr(),
                     right ? right->blockify()->ACL2Expr() : new Plist() });
}

// class ForStmt : public Statement
// --------------------------------

// Data members: SimpleStatement *init; Expression *test; Assignment *update;
// Statement *body;

ForStmt::ForStmt(SimpleStatement *v, Expression *t, Assignment *u,
                 Statement *b)
    : Statement(idOf(this)) {
  init = v;
  test = t;
  update = u;
  body = b;
}

void ForStmt::display(std::ostream &os, unsigned indent) {
  os << "\n"
     << std::setw(indent) << " "
     << "for (";
  init->displaySimple(os);
  os << "; ";
  test->display(os);
  os << "; ";
  update->displaySimple(os);
  os << ")";
  body->display(os, indent + 2);
}

Sexpression *ForStmt::ACL2Expr() {
  Sexpression *sinit = init->ACL2Expr();
  Sexpression *stest = test->ACL2Expr();
  Sexpression *supdate = ((Plist *)(update->ACL2Expr()))->list->nth(2);
  return new Plist({ &s_for, new Plist({ sinit, stest, supdate }),
                     body->blockify()->ACL2Expr() });
}

// class Case : public Statement (component of switch statement)
// -------------------------------------------------------------

// Data members:   Expression *label; List<Statement> *action;

Case::Case(Expression *l, List<Statement> *a)
    : Statement(idOf(this)), label(l), action(a) {}

void Case::display(std::ostream &os, unsigned indent) {
  os << "\n" << std::setw(indent) << " ";
  if (label) {
    os << "case ";
    label->display(os);
  } else {
    os << "default";
  }
  os << ":";
  List<Statement> *ptr = action;
  while (ptr) {
    ptr->value->displayWithinBlock(os, indent + 2);
    ptr = ptr->next;
  }
}

// class SwitchStmt : public Statement
// -----------------------------------

// Data members: Expression *test; List<Case> *cases;

SwitchStmt::SwitchStmt(Expression *t, List<Case> *c)
    : Statement(idOf(this)), test_(t), cases_(BetterList<Case>::_from_raw(c)) {
}

void SwitchStmt::display(std::ostream &os, unsigned indent) {
  for_each(cases_, [](Case *c) { c->typeCheck(); });

  os << "\n"
     << std::setw(indent) << " "
     << "switch (";
  test_->display(os);
  os << ") {";
  cases_.displayList(os, indent);
  os << "\n"
     << std::setw(indent) << " "
     << "}";
}

Sexpression *SwitchStmt::ACL2Expr() {
  for_each(cases_, [](Case *c) { c->typeCheck(); });

  List<Sexpression> *result
      = new List<Sexpression>(&s_switch, test_->ACL2Expr());

  List<Case> *clist = cases_._underlying();
  List<Sexpression> *labels = nullptr;
  Expression *l;
  List<Statement> *a;
  List<Sexpression> *s;

  while (clist) {
    Case *c = clist->value;

    l = c->label;
    a = c->action;
    if (l) {
      labels = labels ? labels->add(l->ACL2Expr())
                      : new List<Sexpression>(l->ACL2Expr());
    }
    if (a) {
      Sexpression *slabel
          = !labels
                ? &s_t
                : !(labels->next) ? labels->value : Plist::FromList(labels);
      s = new List<Sexpression>(slabel);
      while (a && a->value != &breakStmt) {
        s->add(a->value->ACL2Expr());
        a = a->next;
      }
      result->add(Plist::FromList(s));
      labels = nullptr;
    }

    clist = clist->next;
  }

  if (l)
    result->add(new Plist({ &s_t }));

  return Plist::FromList(result);
}
