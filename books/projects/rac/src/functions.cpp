#include "functions.h"

#include <algorithm>
#include <sstream>

//***********************************************************************************
// class FunDef
//***********************************************************************************

// Data members: Symbol *sym; Type *returnType; List<VarDec> *params; Block
// *body;

FunDef::FunDef(Location loc, const char *n, Type *t, List<VarDec> *p, Block *b)
    : Statement(idOf(this), loc), sym(new Symbol(n)), returnType(t), params(p),
      body(b) {}

FunDef::FunDef(NodesId id, Location loc, const char *n, Type *t,
               List<VarDec> *p, Block *b)
    : Statement(id, loc), sym(new Symbol(n)), returnType(t), params(p),
      body(b) {}

void FunDef::displayPrototype(std::ostream &os, const char *prefix,
                              unsigned indent) {
  os << "\n";

  if (indent)
    os << std::setw(indent) << " ";

  returnType->display(os);

  os << " " << prefix << getname() << "(";

  bool is_first = true;
  for_each(params, [&](VarDec *v) {
    if (!is_first)
      os << ", ";
    v->displaySimple(os);
    is_first = false;
  });

  os << ")";
}

void FunDef::displayDec(std::ostream &os, const char *prefix,
                        unsigned indent) {
  displayPrototype(os, prefix, indent);
  os << ';';
}

void FunDef::display(std::ostream &os, const char *prefix, unsigned indent) {

  displayPrototype(os, prefix, indent);
  body->display(os, indent + 2);
  os << "\n";
}

Symbol s_funcdef("funcdef");

void FunDef::displayACL2Expr(std::ostream &os) {

  Plist sparams;
  for_each(params, [&sparams](VarDec *v) { sparams.add(v->sym); });

  Plist({ &s_funcdef, sym, &sparams, body->blockify()->ACL2Expr() })
      .display(os);
}

// class Template : public FunDef
// -----------------------------

Template::Template(Location loc, const char *n, Type *t, List<VarDec> *p,
                   Block *b, List<TempParamDec> *tp)
    : FunDef(idOf(this), loc, n, t, p, b), tempParams(tp) {}

void Template::display(std::ostream &os, const char *prefix, unsigned indent) {
  os << "\n";
  if (indent)
    os << std::setw(indent) << " ";

  os << "template<";
  List<TempParamDec> *ptr = tempParams;
  while (ptr) {
    ptr->value->displaySymDec(os);
    ptr = ptr->next;
    if (ptr) {
      os << ", ";
    }
  }
  os << ">";
  FunDef::display(os, prefix, indent);
}

// This is called by both Template::displayACL2Expr and TempCall::ACL2Expr:

void Template::bindParams(List<Expression> *actuals) {

  for_each(tempParams, [&](TempParamDec *formal) {
    assert(actuals);
    formal->init = actuals->value;
    actuals = actuals->next;
  });
}

void Template::displayACL2Expr(std::ostream &os) {

  unsigned numCalls = 0;
  Symbol *saveSym = sym;

  std::for_each(calls.begin(), calls.end(), [&](TempCall *c) {
    // Generate a new name for each template instanciation and tranform this
    // into the instanciated function.
    std::ostringstream ostr;
    ostr << saveSym->getname() << "-" << numCalls++;
    sym = new Symbol(ostr.str());

    // Change the caller to call the instanciated function (this).
    c->instanceSym = sym;

    // Bind params and display this as a standard function.
    bindParams(c->params);
    FunDef::displayACL2Expr(os);
  });

  sym = saveSym;
}
