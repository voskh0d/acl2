#ifndef PARSER_H
#define PARSER_H

#include <assert.h>
#include <cstring> // for strlen, strcpy, etc
#include <ostream>
#include <stdio.h>

#include <deque>
#include <optional>
#include <vector>

class Program;

extern int yylineno;

extern int yyparse();
extern FILE *yyin;
extern FILE *yyout;
extern Program prog;

extern int yylineno;
extern char yyfilenm[];

#include "utils.h"

//***********************************************************************************
// S-Expressions
//***********************************************************************************

// An Sexpression is a Symbol, a Cons, or a Plist (proper list of
// S-expressions). Note that Constant is a derived class of Symbol.
class Sexpression {
public:
  virtual void display(std::ostream &os) const = 0;
};

class Plist : public Sexpression {
public:
  // TODO list -> private
  List<Sexpression> *list;

  Plist() : list(nullptr){};

  virtual ~Plist() {}

  Plist(std::initializer_list<Sexpression *> sexprs) {

    auto it = crbegin(sexprs);
    if (it == crend(sexprs)) {
      list = nullptr;
      return;
    }

    list = new List<Sexpression>(*it);
    for (++it; it != crend(sexprs); ++it) {
      list = list->push(*it);
    }
  }

  static Plist *FromList(List<Sexpression> *l = nullptr) {
    auto pl = new Plist();
    pl->list = l;
    return pl;
  }

  Plist *add(Sexpression *s) {
    if (list) {
      list->add(s);
    } else {
      list = new List<Sexpression>(s);
    }
    return this;
  }

  Plist *push(Sexpression *s) {
    if (list) {
      list = list->push(s);
    } else {
      list = new List<Sexpression>(s);
    }
    return this;
  }

  void display(std::ostream &os) const;
};

class Cons : public Sexpression {
public:
  Cons(Sexpression *a, Sexpression *d) : car_(a), cdr_(d) {}

  void display(std::ostream &os) const {
    os << "(";
    car_->display(os);
    os << " . ";
    cdr_->display(os);
    os << ")";
  }

private:
  Sexpression *car_;
  Sexpression *cdr_;
};

class Symbol : public Sexpression {
  std::string name_;

public:
  Symbol(std::string &&s) : name_(s) {}

  Symbol(const char *s) : name_(s) {}

  Symbol(int n) : name_(std::to_string(n)) {}

  const char *getname() const { return name_.c_str(); }
  void display(std::ostream &os) const { os << name_; }
};

extern Symbol s_ag;
extern Symbol s_as;
extern Symbol s_ash;
extern Symbol s_assert;
extern Symbol s_assign;
extern Symbol s_bitn;
extern Symbol s_bits;
extern Symbol s_block;
extern Symbol s_break;
extern Symbol s_case;
extern Symbol s_declare;
extern Symbol s_default;
extern Symbol s_divide;
extern Symbol s_expt;
extern Symbol s_fl;
extern Symbol s_false;
extern Symbol s_true;
extern Symbol s_if;
extern Symbol s_if1;
extern Symbol s_for;
extern Symbol s_list;
extern Symbol s_logand;
extern Symbol s_logand1;
extern Symbol s_logeq;
extern Symbol s_loggeq;
extern Symbol s_loggreater;
extern Symbol s_logior;
extern Symbol s_logior1;
extern Symbol s_logleq;
extern Symbol s_logless;
extern Symbol s_logneq;
extern Symbol s_lognot;
extern Symbol s_lognot1;
extern Symbol s_logxor;
extern Symbol s_minus;
extern Symbol s_mv;
extern Symbol s_mv_assign;
extern Symbol s_nth;
extern Symbol s_nil;
extern Symbol s_null;
extern Symbol s_plus;
extern Symbol s_quote;
extern Symbol s_rem;
extern Symbol s_return;
extern Symbol s_t;
extern Symbol s_times;
extern Symbol s_floor;
extern Symbol s_slash;
extern Symbol s_setbitn;
extern Symbol s_setbits;
extern Symbol s_si;
extern Symbol s_switch;

#endif
