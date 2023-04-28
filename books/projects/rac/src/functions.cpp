#include <algorithm>

#include "functions.h"

//***********************************************************************************
// class FunDef
//***********************************************************************************

void FunDef::displayPrototype(ostream &os, const char *prefix,
                              unsigned indent) {
  os << "\n";

  if (indent)
    os << setw(indent) << " ";

  returnType_->display(os);

  os << " " << prefix << getname() << "(";

  bool is_first = true;
  std::for_each(params_.begin(), params_.end(), [&](VarDec *v) {
    if (!is_first)
      os << ", ";
    v->displaySimple(os);
    is_first = false;
  });

  os << ")";
}

void FunDef::displayDec(ostream &os, const char *prefix, unsigned indent) {
  displayPrototype(os, prefix, indent);
  os << ';';
}

void FunDef::display(ostream &os, const char *prefix, unsigned indent) {

  displayPrototype(os, prefix, indent);
  body_->display(os, indent + 2);
  os << "\n";
}

Symbol s_funcdef("funcdef");

void FunDef::displayACL2Expr(ostream &os) {

  Plist *sparams = new Plist();
  std::for_each(params_.begin(), params_.end(),
                [&sparams](VarDec *v) { sparams->add(v->sym); });

  body_->noteReturnType(returnType_);

  body_->markAssertions(this);

  Plist({ &s_funcdef, new Symbol(getname()), sparams,
          body_->blockify()->ACL2Expr() })
      .display(os);

  delete sparams;
}

// class Template : public FunDef
// -----------------------------

// Data members: List<TempParamDec> *tempParams; List<TempCall> *calls;

void Template::display(ostream &os, const char *prefix, unsigned indent) {
  os << "\n";
  if (indent)
    os << setw(indent) << " ";

  os << "template<";

  bool is_first = true;
  std::for_each(tempParams_.begin(), tempParams_.end(),
                [&](TempParamDec *tpd) {
                  if (!is_first)
                    os << ", ";
                  tpd->displaySymDec(os);
                });

  os << ">";
  FunDef::display(os, prefix, indent);
}

// This is called by both Template::displayACL2Expr and TempCall::ACL2Expr:

void Template::bindParams(std::vector<Expression *> actuals) {
  std::transform(actuals.begin(), actuals.end(), tempParams_.begin(),
                 tempParams_.end(),

                 [](Expression *actual, TempParamDec *tpd) {
                   tpd->init = actual;
                   return tpd;
                 });
}

void Template::displayACL2Expr(ostream &os) {
  unsigned numCalls = 0;
  const std::string saved_name = name_;

  std::for_each(calls_.begin(), calls_.end(), [&](TempCall *call) {
    // Generate a unique identifier and transform this into an instance for
    // the call.
    // TODO make sure it does not existe yet in Program::fundefs !
    ostringstream ostr;
    ostr << saved_name << "-" << numCalls++;
    name_ = ostr.str();

    auto params = collect(call->params);
    this->bindParams(params);

    // Then display the instance.
    FunDef::displayACL2Expr(os);

    // And bind the call to the correct instance.
    call->instanceSym = new Symbol(getname());
  });

  // Restore the template.
  name_ = saved_name;
}
