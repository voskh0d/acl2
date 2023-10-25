#include "functions.h"
#include "program.h"
#include "statements.h"

#include <algorithm>
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
  return new Block(loc_, this);
}

// Create a block consisting of s appended to this:

Block *Statement::blockify(Statement *s) { // virtual (overridden by Block)
  return new Block(loc_, this, s);
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

SymDec::SymDec(Location loc, const char *n, Type *t, Expression *i)
    : SimpleStatement(idOf(this), loc), sym(new Symbol(n)), type(t), init(i) {}

SymDec::SymDec(NodesId id, Location loc, const char *n, Type *t, Expression *i)
    : SimpleStatement(id, loc), sym(new Symbol(n)), type(t), init(i) {}

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

EnumConstDec::EnumConstDec(Location loc, const char *n, Expression *v)
    : SymDec(idOf(this), loc, n, &intType, v) {}

void EnumConstDec::display(std::ostream &os, unsigned) {
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

VarDec::VarDec(Location loc, const char *n, Type *t, Expression *i)
    : SymDec(idOf(this), loc, n, t, i) {}

VarDec::VarDec(NodesId id, Location loc, const char *n, Type *t, Expression *i)
    : SymDec(id, loc, n, t, i) {}

void VarDec::displaySimple(std::ostream &os) { displaySymDec(os); }

Sexpression *VarDec::ACL2Expr() {

  const Type *t = type;
  if (auto dt = dynamic_cast<const DefinedType *>(t)) {
    t = dt->derefType();
  }

  Sexpression *val;
  if (isa<const ArrayType *>(t)) {
    if (!init) {
      val = new Plist();
    } else if (isROM()) {
      val = new Plist({ &s_quote, init->ACL2Expr() });
    } else {
      val = init->ACL2ArrayExpr();
    }
  } else if (isa<const StructType *>(t)) {
    if (!init) {
      val = new Plist();
    } else if (Initializer *i = dynamic_cast<Initializer *>(init)) {
      val = i->ACL2StructExpr(always_cast<const StructType *>(t)->fields());
    } else {
      val = init->ACL2ArrayExpr();
    }
  } else if (init) {
    val = t->ACL2Assign(init);
  } else {
    val = Integer::zero_v(loc_);
  }
  return new Plist({ &s_declare, sym, val });
}

Sexpression *VarDec::ACL2SymExpr() { return sym; }

// class ConstDec : public VarDec
// ------------------------------

ConstDec::ConstDec(Location loc, const char *n, Type *t, Expression *i)
    : VarDec(idOf(this), loc, n, t, i) {}

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

MulVarDec::MulVarDec(Location loc, VarDec *dec1, VarDec *dec2)
    : SimpleStatement(idOf(this), loc) {
  decs = new List<VarDec>(dec1, dec2);
}

MulVarDec::MulVarDec(Location loc, List<VarDec> *d)
    : SimpleStatement(idOf(this), loc), decs(d) {}

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

MulConstDec::MulConstDec(Location loc, ConstDec *dec1, ConstDec *dec2)
    : SimpleStatement(idOf(this), loc) {
  decs = new List<ConstDec>(dec1, dec2);
}

MulConstDec::MulConstDec(Location loc, List<ConstDec> *d)
    : SimpleStatement(idOf(this), loc), decs(d) {}

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

TempParamDec::TempParamDec(Location loc, const char *n, Type *t)
    : SymDec(idOf(this), loc, n, t) {}

bool TempParamDec::isConst() { return true; }

Sexpression *TempParamDec::ACL2SymExpr() {
  return init ? type->ACL2Assign(init) : Integer::zero_v(loc_);
}

// class BreakStmt : public SimpleStatement
// ----------------------------------------

BreakStmt::BreakStmt(Location loc) : SimpleStatement(idOf(this), loc) {}

void BreakStmt::displaySimple(std::ostream &os) { os << "break"; }

Sexpression *BreakStmt::ACL2Expr() { return &s_break; }

// class ReturnStmt : public SimpleStatement
// -----------------------------------------

// Data members: Expression *value;

ReturnStmt::ReturnStmt(Location loc, Expression *v)
    : SimpleStatement(idOf(this), loc), value(v) {}

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

Assertion::Assertion(Location loc, Expression *e)
    : SimpleStatement(idOf(this), loc), expr(e) {}

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

Assignment::Assignment(Location loc, Expression *l, const char *o,
                       Expression *r)
    : SimpleStatement(idOf(this), loc), lval(l), op(o), rval(r) {}

void Assignment::displaySimple(std::ostream &os) {

  if (!strcmp(op, "set_slc")) {

    const Type *rval_type = rval->get_type();
    if (!isa<const RegType *>(rval_type)) {
      prog.diag().report(this->loc(), rval->loc(), "here");
      std::cerr << rval_type->to_string();
      assert(!"Second arg of set_slc must have a defined width");
    }
    unsigned w = always_cast<const RegType *>(rval_type)->width()->evalConst();
    Subrange lval_slc(loc_, lval, index, w);
    lval_slc.display(os);

    os << " = ";

    rval->display(os);
    return;
  }

  lval->display(os);

  if (!strcmp(op, "++") || !strcmp(op, "--")) {
    os << op;
  } else if (strcmp(op, "=")) {
    os << ' ' << op << ' ';
    always_cast<BinaryExpr *>(rval)->expr2->display(os);
  } else {
    os << ' ' << op << ' ';
    rval->display(os);
  }
}

Sexpression *Assignment::ACL2Expr() {

  if (!strcmp(op, "set_slc")) {

    const Type *rval_type = rval->get_type();
    if (!isa<const RegType *>(rval_type)) {
      assert(!"Second arg of set_slc must have a defined width");
    }

    unsigned w = always_cast<const RegType *>(rval_type)->width()->evalConst();

    auto lval_slc = new Subrange(loc_, lval, index, w);

    auto width = new Integer(Location::dummy(), w);

    // TODO not sure about the false.
    auto t = new IntType(Location::dummy(), width, false);
    lval_slc->set_type(t);

    return lval_slc->ACL2Assign(rval->ACL2Expr());
  }

  // TODO shady why are we doing assing twice ?
  const Type *lval_type = lval->get_type();
  Sexpression *sexpr
      = lval_type ? lval_type->ACL2Assign(rval) : rval->ACL2Expr();

  return lval->ACL2Assign(sexpr);
}

void Assignment::desugar() {

  if (!strcmp(op, "=") || !strcmp(op, "set_slc")) {
    // Do nothing.
    return;
  } else if (!strcmp(op, "++")) {
    rval = new BinaryExpr(loc_, lval, Integer::one_v(loc_), "+");
  } else if (!strcmp(op, "--")) {
    rval = new BinaryExpr(loc_, lval, Integer::one_v(loc_), "-");
  } else if (!strcmp(op, ">>=")) {
    rval = new BinaryExpr(loc_, lval, rval, ">>");
  } else if (!strcmp(op, "<<=")) {
    rval = new BinaryExpr(loc_, lval, rval, "<<");
  } else if (!strcmp(op, "+=")) {
    rval = new BinaryExpr(loc_, lval, rval, "+");
  } else if (!strcmp(op, "-=")) {
    rval = new BinaryExpr(loc_, lval, rval, "-");
  } else if (!strcmp(op, "*=")) {
    rval = new BinaryExpr(loc_, lval, rval, "*");
  } else if (!strcmp(op, "%=")) {
    rval = new BinaryExpr(loc_, lval, rval, "%");
  } else if (!strcmp(op, "&=")) {
    rval = new BinaryExpr(loc_, lval, rval, "&");
  } else if (!strcmp(op, "^=")) {
    rval = new BinaryExpr(loc_, lval, rval, "^");
  } else if (!strcmp(op, "|=")) {
    rval = new BinaryExpr(loc_, lval, rval, "|");
  } else {
    assert(!"Unknown assignment operator");
  }
}

// class MultipleAssignment : public SimpleStatement
// -------------------------------------------------

// Data members: Expression *lval[8]; FunCall *rval;

MultipleAssignment::MultipleAssignment(Location loc, FunCall *r,
                                       std::vector<Expression *> e)
    : SimpleStatement(idOf(this), loc), lval_(e), rval_(r) {}

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

NullStmt::NullStmt(Location loc) : SimpleStatement(idOf(this), loc) {}

void NullStmt::displaySimple([[maybe_unused]] std::ostream &os) {}

Sexpression *NullStmt::ACL2Expr() { return new Plist({ &s_null }); }

// class Block : public Statement
// ------------------------------

// Data member: List<Statement> *stmtList;

Block::Block(Location loc, List<Statement> *s)
    : Statement(idOf(this), loc), stmtList(s) {}

Block::Block(Location loc, Statement *s) : Statement(idOf(this), loc) {
  stmtList = new List<Statement>(s);
}

Block::Block(Location loc, Statement *s1, Statement *s2)
    : Statement(idOf(this), loc) {
  stmtList = new List<Statement>(s1, new List<Statement>(s2));
}

Block::Block(Location loc, Statement *s1, Statement *s2, Statement *s3)
    : Statement(idOf(this), loc) {
  stmtList = new List<Statement>(
      s1, new List<Statement>(s2, new List<Statement>(s3)));
}

Block *Block::blockify() { return this; }

Block *Block::blockify(Statement *s) {
  return new Block(loc_, stmtList ? stmtList->copy()->add(s)
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

IfStmt::IfStmt(Location loc, Expression *t, Statement *l, Statement *r)
    : Statement(idOf(this), loc), test(t), left(l), right(r) {}

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

ForStmt::ForStmt(Location loc, SimpleStatement *v, Expression *t,
                 Assignment *u, Statement *b)
    : Statement(idOf(this), loc) {
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

Case::Case(Location loc, Expression *l, List<Statement> *a)
    : Statement(idOf(this), loc), label(l), action(a) {}

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

SwitchStmt::SwitchStmt(Location loc, Expression *t, std::vector<Case *> c)
    : Statement(idOf(this), loc), test_(t), cases_(c) {}

void SwitchStmt::display(std::ostream &os, unsigned indent) {

  os << "\n"
     << std::setw(indent) << " "
     << "switch (";
  test_->display(os);
  os << ") {";

  std::for_each(cases_.begin(), cases_.end(),
                [&](Case *c) { c->display(os, indent); });

  os << "\n"
     << std::setw(indent) << " "
     << "}";
}

Sexpression *SwitchStmt::ACL2Expr() {

  List<Sexpression> *result
      = new List<Sexpression>(&s_switch, test_->ACL2Expr());

  List<Sexpression> *labels = nullptr;
  Expression *l = nullptr;
  List<Statement> *a = nullptr;
  List<Sexpression> *s = nullptr;

  std::for_each(cases_.begin(), cases_.end(), [&](Case *c) {
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
      while (a && !isa<BreakStmt *>(a->value)) {
        s->add(a->value->ACL2Expr());
        a = a->next;
      }
      result->add(Plist::FromList(s));
      labels = nullptr;
    }
  });

  if (l)
    result->add(new Plist({ &s_t }));

  return Plist::FromList(result);
}
