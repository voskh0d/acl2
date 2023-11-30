%{
#include "yyparser.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wfree-nonheap-object"

void yyerror (const char *s)
{
  yyast.diag()
      .new_error(yylloc, s)
      .report();
}

List<Builtin> builtins (new Builtin (Location::dummy(), "abs", &intType,
    new List<VarDec>(new VarDec(Location::dummy(), "", &intType))));

SymbolStack symTab;
AST yyast;

template <typename Container, typename F, typename... Args>
bool register_with_new_id(Container c, const std::string& id,
                          const Location& loc, F register_action)
{
  auto res = c.find_last_frame(id);
  bool error = std::visit(overloaded {
      [&](SymbolStack::None) {
        register_action();
        return false;
      },
      [&](SymbolStack::Found f) {
        auto message = format("Duplicate identifier declaration (could be an "
                             "enum, a variable template parameter or function) `%s`",
                             id.c_str());
        yyast.diag()
          .new_error(loc, message)
          .note("first defined here")
          .note_location(symTab.get_loc(f.value))
          .report();

        return true;
      },
      [&](SymbolStack::FoundWithDifferentCase f) {
        auto message = format("%s is already used but with a different case "
                              "(in ACL2, they will refer to the same thing)",
                              id.c_str());
        yyast.diag()
            .new_error(loc, message)
            .note("first defined here")
            .note_location(symTab.get_loc(f.value))
            .report();
          return true;
      }
    }, res);

  return error;
}

enum class Where { LastFrame, Global };

template <typename ExpectedType>
auto get_from_id(Where where, const std::string& id, const Location& loc)
{
  auto res = where == Where::LastFrame ? symTab.find_last_frame(id)
                                       : symTab.find(id);

  return std::visit(overloaded {
      [&](SymbolStack::None) {
        yyast.diag()
            .new_error(loc, format("Unknown symbol `%s`", id.c_str()))
            .report();
        return std::optional<ExpectedType>();
      },
      [&](SymbolStack::Found f) {
        if (std::holds_alternative<ExpectedType>(f.value)) {
          return std::optional { std::get<ExpectedType>(f.value) };
        } else {
          yyast.diag()
              .new_error(loc, format("error todo"))
              .note_location(symTab.get_loc(f.value))
              .report();
          return std::optional<ExpectedType>();
        }
      },
      [&](SymbolStack::FoundWithDifferentCase f) {

        if (std::holds_alternative<ExpectedType>(f.value)) {
          yyast.diag()
              .new_error(loc, format("Unknown symbol `%s`", id.c_str()))
              .note(format("maybe you meant `%s` ?", symTab.get_name(f.value)))
              .note_location(symTab.get_loc(f.value))
              .report();
        }

        return std::optional<ExpectedType>();
      }
    }, res);
}


#define YYLLOC_DEFAULT(Cur, Rhs, N)                                           \
do                                                                            \
  if (N)                                                                      \
    {                                                                         \
      (Cur).first_line   = YYRHSLOC(Rhs, 1).first_line;                       \
      (Cur).first_column = YYRHSLOC(Rhs, 1).first_column;                     \
      (Cur).last_line    = YYRHSLOC(Rhs, N).last_line;                        \
      (Cur).last_column  = YYRHSLOC(Rhs, N).last_column;                      \
      (Cur).f_pos = YYRHSLOC(Rhs, 1).f_pos;                                   \
      (Cur).f_pos_end = YYRHSLOC(Rhs, 1).f_pos_end;                           \
      (Cur).file_name = YYRHSLOC(Rhs, 1).file_name;                           \
    }                                                                         \
  else                                                                        \
    {                                                                         \
      (Cur).first_line = (Cur).last_line = YYRHSLOC(Rhs, 0).last_line;        \
      (Cur).first_column = (Cur).last_column = YYRHSLOC(Rhs, 0).last_column;  \
      (Cur).f_pos = YYRHSLOC(Rhs, 0).f_pos;                                   \
      (Cur).f_pos_end = YYRHSLOC(Rhs, 0).f_pos_end;                           \
      (Cur).file_name = YYRHSLOC(Rhs, 0).file_name;                           \
    }                                                                         \
while (0)
%}

%union {
  char *s;

  Type *type;
  DefinedType *defined_type;

  Expression *exp;
  FunDef *fd;
  std::vector<Expression *> *expl;
  BigList<Expression> *initl;
  StructField *sf;
  std::vector<StructField *> *sfl;
  EnumConstDec *ecd;
  std::vector<EnumConstDec *> *ecdl;
  VarDec *vd;
  List<VarDec> *vdl;
  TempParamDec *tpd;
  List<TempParamDec> *tdl;
  Statement *stm;
  std::vector<Statement *> *stml;
  Case *c;
  std::vector<Case *> *cl;

  std::vector<const Type *> *vl;
  Boolean *b;
  MvType *mvtype;
}

%define parse.error verbose
%define parse.lac full

%locations
%define api.location.type { Location }

%define parse.trace

%token TYPEDEF CONST STRUCT ENUM TEMPLATE
%token INT UINT INT64 UINT64 BOOL
%token SLC SET_SLC
%token FOR IF ELSE WHILE DO SWITCH CASE DEFAULT BREAK RETURN ASSERT
%token ARRAY TUPLE TIE
%token AC_INT AC_FIXED
%token<s> RSHFT_ASSIGN LSHFT_ASSIGN ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN
%token<s> MOD_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN
%token<s> INC_OP DEC_OP
%token<s> RSHFT_OP LSHFT_OP AND_OP OR_OP LE_OP GE_OP EQ_OP NE_OP
%token<s> ID NAT TRUE FALSE TYPEID TEMPLATEID
%token<s> '=' '+' '-' '&' '|' '!' '~' '*' '%' '<' '>' '^' '/'

%start program

%type<mvtype> mv_type;
%type<type> type_spec typedef_type
%type<type> primitive_type array_param_type register_type struct_type enum_type
%type<defined_type> type_dec typedef_dec

%type<sf> struct_field
%type<sfl> struct_field_list
%type<ecd> enum_const_dec
%type<ecdl> enum_const_dec_list
%type<b> boolean
%type<exp> expression constant integer symbol_ref funcall
%type<exp> array_or_bit_ref subrange array_or_struct_init case_label
%type<exp> primary_expression postfix_expression prefix_expression mult_expression add_expression
%type<exp> arithmetic_expression rel_expression eq_expression and_expression xor_expression ior_expression
%type<exp> log_and_expression log_or_expression cond_expression
%type<exp> mv_expression struct_ref
%type<fd> func_def func_template
%type<expl> expr_list nontrivial_expr_list arith_expr_list nontrivial_arith_expr_list
%type<initl> init_list
%type<vdl> param_dec_list nontrivial_param_dec_list
%type<tpd> template_param_dec
%type<tdl> template_param_dec_list nontrivial_template_param_dec_list
%type<stml> statement_list r_statement_list
%type<stm> statement r_statement block r_block var_dec const_dec untyped_var_dec untyped_const_dec
%type<stm> for_statement for_init multiple_var_dec multiple_const_dec null_statement final_statement
%type<stm> if_statement switch_statement break_statement
%type<stm> simple_statement assignment multiple_assignment assertion return_statement
%type<c> case
%type<cl> case_list
%type<s> assign_op inc_op unary_op
%type<vl> mv_type_rest

%expect 3

%%

//*************************************************************************************
// Program Structure
//*************************************************************************************

// A program consists of a sequence of type definitions, global
// constant declarations, and function definitions.  The parser
// produces four linked lists corresponding to these sequences, stored
// as the values of the variables typeDefs, constDecs, and funDefs.

program
    : program program_element
    | program_element;

program_element
    : type_dec ';'
{
  if (!yyast.registerType($1))
  {
      yyast.diag()
          .new_error(@$, "Duplicate type definition")
          .report();
      YYERROR;
  }
}
    | const_dec ';'
{
  ConstDec *cd = static_cast<ConstDec *>($1);
  cd->setGlobal();
  yyast.registerConstDec(cd);
}
    | func_def
    | multiple_const_dec ';'
{
  for_each(static_cast<MulConstDec *>($1)->decs,
    [&](ConstDec *cd) {
      cd->setGlobal();
      yyast.registerConstDec(cd);
    });
}
    ;

//*************************************************************************************
// Types
//*************************************************************************************

type_dec
    : typedef_dec
    | STRUCT ID struct_type
{
  $$ = new DefinedType (@$, $2, $3);
}
    | ENUM ID enum_type
{
  $$ = new DefinedType (@$, $2, $3);
};

typedef_dec
    : TYPEDEF typedef_type ID
{
  $$ = new DefinedType (@$, $3, $2);
}
    | typedef_dec '[' arithmetic_expression ']'
{
  if ($3->isConst () && $3->evalConst () > 0)
    {
      auto at = new ArrayType (@$, $3, $1->getdef ());
      $$ = new DefinedType(@$, $1->getname(), at);
    }
  else
    {
      yyast.diag()
          .new_error(@3, "Array dimension not a positive integer constant")
          .context(@$)
          .report();
      YYERROR;
    }
};

typedef_type
    : primitive_type   // name of a primitive C numerical type
    | register_type    // Algorithmic C register class
    | array_param_type // instantiation of array class template
    | mv_type { $$ = static_cast<Type *>($1); }       // instantiation of mv class template
    | TYPEID
{
  $$ = yyast.getType($1);
}; // name of a previously declared type


type_spec
    : typedef_type // type that can appear in a typedef declaration
    | STRUCT struct_type
{
  $$ = $2;
} // standard C structure type
    | ENUM enum_type
{
  $$ = $2;
}; // standard C enumeration type


primitive_type
    : INT { $$ = &intType; }
    | UINT { $$ = &uintType; }
    | INT64 { $$ = &int64Type; }
    | UINT64 { $$ = &uint64Type; }
    | BOOL { $$ = &boolType; };

register_type
    : AC_FIXED
{
  yyast.diag()
      .new_error(@1, "ac_fixed is deprecated")
      .report();
  YYERROR;
}
    | AC_INT '<' arithmetic_expression ',' boolean '>'
{
  if ($3->isConst () && $3->isInteger () && $3->evalConst () >= 0)
    {
      $$ = new IntType (@$, $3, $5->evalConst());
      delete $5;
    }
  else
    {
      const char *expected = [&]() {
        if (!$3->isConst ()) {
          return "constant";
        } else if (!$3->isInteger ()) {
          return "an integer";
        } else {
          return "positive";
        }
      }();

      auto message = format("Illegal parameter of ac_int, expected this to be "
                            "%s but is not.", expected);
      yyast.diag()
          .new_error(@3, message)
          .context(@$)
          .report();
      YYERROR;
    }
};

array_param_type
    : ARRAY '<' type_spec ',' arithmetic_expression '>'
{
  if ($5->isConst () && $5->evalConst () > 0)
    {
      $$ = new ArrayType (@$, $5, $3);
    }
  else
    {
      yyast.diag()
          .new_error(@3, "Non-constant array dimension")
          .context(@$)
          .report();
      YYERROR;
    }
};

struct_type
    : '{' struct_field_list '}'
{
  $$ = new StructType (@$, *$2);
};

struct_field_list
    : struct_field
{
  $$ = new std::vector<StructField *> ({$1});
}
    | struct_field_list struct_field
{
  $1->push_back($2);
  $$ = $1;
};

struct_field
    : type_spec ID ';'
{
  $$ = new StructField ($1, $2);
};

enum_type
    : '{' enum_const_dec_list '}'
{
  $$ = new EnumType (@$, *$2);
};

enum_const_dec_list
    : enum_const_dec
{
  $$ = new std::vector<EnumConstDec *> ({$1});
}
    | enum_const_dec_list ',' enum_const_dec
{
  $1->push_back($3); $$ = $1;
};

enum_const_dec
    : ID
{
  bool error = register_with_new_id(symTab, $1, @$,
    [&]() {
      $$ = new EnumConstDec (@$, $1);
      symTab.push($$);
    });
  if (error) {
    YYERROR;
  }
}
    | ID '=' expression
{
  bool error = register_with_new_id(symTab, $1, @$,
    [&]() {
      $$ = new EnumConstDec (@$, $1, $3);
      symTab.push($$);
    });
  if (error) {
    YYERROR;
  }
};

mv_type
    : TUPLE '<' type_spec mv_type_rest
{
  $4->push_back($3);
  std::reverse($4->begin(), $4->end());
  $$ = new MvType(@$, std::move(*$4));
  delete($4);
};

mv_type_rest
    : '>'
{
  $$ = new std::vector<const Type *>();
}
    | ',' type_spec mv_type_rest
{
  $3->push_back($2);
  $$ = $3;
}

//*************************************************************************************
// Expressions
//*************************************************************************************

primary_expression
    : constant
    | symbol_ref
    | funcall
    | '(' expression ')'
{
  $$ = new Parenthesis(@$, $2);
};

constant
    : integer
    | boolean
{
  $$ = static_cast<Constant *>($1);
}

integer
    : NAT { $$ = new Integer (@$, $1); }
    | '-' NAT
{
  char *name = new char[strlen ($2) + 2];
  strcpy (name + 1, $2);
  name[0] = '-';
  $$ = new Integer (@$, name);
};

boolean
    : TRUE
{
  $$ = Boolean::true_v(@$);
}
    | FALSE
{
  $$ = Boolean::false_v(@$);
};

symbol_ref
    : ID
{
  if (auto s = get_from_id<SymDec *>(Where::Global, $1, @$)) {
    $$ = new SymRef (@$, *s);
  } else {
    YYERROR;
  }
};

funcall
    : ID '(' expr_list ')'
{
  FunDef *f;
  if ((f = yyast.getFunDef ($1)) == nullptr
      && (f = builtins.find ($1)) == nullptr)
    {
      yyast.diag()
          .new_error(@$, "Undefined function")
          .report();
      YYERROR;
    }
  else
    {
      $$ = new FunCall (@$, f, std::move(*$3));
      delete $3;
    }
}
    | TEMPLATEID '<' arith_expr_list '>' '(' arith_expr_list ')'
{
  Template *f;
  if ((f = yyast.getTemplate($1)) == nullptr)
    {
      yyast.diag()
          .new_error(@$, "Undefined function template")
          .report();
      YYERROR;
    }
  else
    {
      $$ = new TempCall (@$, f, std::move(*$6), std::move(*$3));
      delete $6;
      delete $3;
    }
};

postfix_expression
    : primary_expression
    | array_or_bit_ref
    | struct_ref
    | subrange;

// At this step, we don't know yet if it is a a bit reference and a
// (syntactically equivalent) array reference. The base must be examined after
// typing.
array_or_bit_ref
    : postfix_expression '[' expression ']'
{
  $$ = new ArrayRef (@$, $1, $3);
};

struct_ref
    : postfix_expression '.' ID
{
    $$ = new StructRef (@$, $1, $3);
}

subrange
    : postfix_expression '.' SLC '<' NAT '>' '(' expression ')'
{
  $$ = new Subrange (@$, $1, $8, Integer (@$, $5).evalConst ());
}

prefix_expression
    : postfix_expression
    | unary_op prefix_expression
{
  $$ = new PrefixExpr (@$, $2, $1);
}
    | '(' type_spec ')' prefix_expression
{
  $$ = new CastExpr (@$, $4, $2);
}
    | type_spec '(' expression ')'
{
  $$ = new CastExpr (@$, $3, $1);
};

unary_op
    : '+'
    | '-'
    | '~'
    | '!';

mult_expression
    : prefix_expression
    | mult_expression '*' prefix_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
}
    | mult_expression '/' prefix_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
}
    | mult_expression '%' prefix_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
};

add_expression
    : mult_expression
    | add_expression '+' mult_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
}
    | add_expression '-' mult_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
};

arithmetic_expression
    : add_expression
    | arithmetic_expression LSHFT_OP add_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
}
    | arithmetic_expression RSHFT_OP add_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
};

rel_expression
    : arithmetic_expression
    | rel_expression '<' arithmetic_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
}
    | rel_expression '>' arithmetic_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
}
    | rel_expression LE_OP arithmetic_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
}
    | rel_expression GE_OP arithmetic_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
};

eq_expression
    : rel_expression
    | eq_expression EQ_OP rel_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
}
    | eq_expression NE_OP rel_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
};

and_expression
    : eq_expression
    | and_expression '&' eq_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
};

xor_expression
    : and_expression
    | xor_expression '^' and_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
};

ior_expression
    : xor_expression
    | ior_expression '|' xor_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
};

log_and_expression
    : ior_expression
    | log_and_expression AND_OP ior_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
};

log_or_expression
    : log_and_expression
    | log_or_expression OR_OP log_and_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
};

cond_expression
    : log_or_expression
    | log_or_expression '?' expression ':' cond_expression
{
  $$ = new CondExpr (@$, $3, $5, $1);
};

mv_expression
    : mv_type '(' expr_list ')'
{
  //std::reverse($3->begin(), $3->end());
  $$ = new MultipleValue (@$, $1, std::move(*$3));
  delete $3;
};

expression
    : cond_expression
    | mv_expression;

expr_list
    : %empty
{
  $$ = new std::vector<Expression *>();
}
    | nontrivial_expr_list
{
  $$ = $1;
};

nontrivial_expr_list
    : expression
{
  $$ = new std::vector<Expression *>();
  $$->push_back($1);
}
    | nontrivial_expr_list ',' expression
{
  $1->push_back($3);
  $$ = $1;
};

arith_expr_list
    : %empty
{
  $$ = new std::vector<Expression *>();
}
    | nontrivial_arith_expr_list
{
  $$ = $1;
};

nontrivial_arith_expr_list
    : arithmetic_expression
{
  $$ = new std::vector<Expression *>();
  $$->push_back($1);
}
    | nontrivial_arith_expr_list ',' arithmetic_expression
{
  $1->push_back($3);
  $$ = $1;
};

//*************************************************************************************
// Statements
//*************************************************************************************

statement
    : simple_statement ';'
    | block
    | for_statement
    | if_statement
    | switch_statement;

r_statement
    : final_statement
    | r_block;

simple_statement
    : var_dec
    | const_dec
    | multiple_var_dec
    | multiple_const_dec
    | break_statement
    | assignment
    | multiple_assignment
    | assertion
    | null_statement;

var_dec
    : type_spec untyped_var_dec
{
  $$ = $2;
  const Type *t = ((VarDec *)$$)->type;
  if (t)
    {
      ((ArrayType *)t)->baseType = $1;
    }
  else
    {
      ((VarDec *)$$)->type = $1;
    }
};

untyped_var_dec
    : ID
{
  bool error = register_with_new_id(symTab, $1, @$,
    [&]() {
      $$ = new VarDec (@$, $1, nullptr);
      symTab.push ((VarDec *)$$);
    });
  if (error) {
    YYERROR;
  }
}
    | ID '=' expression
{
  bool error = register_with_new_id(symTab, $1, @$,
    [&]() {
      $$ = new VarDec (@$, $1, nullptr, $3);
      symTab.push ((VarDec *)$$);
    });
  if (error) {
    YYERROR;
  }
}
    | ID '=' array_or_struct_init
{
  bool error = register_with_new_id(symTab, $1, @$,
    [&]() {
      $$ = new VarDec (@$, $1, nullptr, $3);
      symTab.push ((VarDec *)$$);
    });
  if (error) {
    YYERROR;
  }
}
    | ID '[' arithmetic_expression ']'
{
  if (!$3->isConst () || $3->evalConst () <= 0)
    {
      yyast.diag()
          .new_error(@3, "Invalid array size (it shoud be a constant, stricly "
                      "positive expression)")
          .context(@$)
          .report();
      YYERROR;
    }
  bool error = register_with_new_id(symTab, $1, @$,
    [&]() {
      $$ = new VarDec (@$, $1, new ArrayType (@$, $3, nullptr));
      symTab.push ((VarDec *)$$);
  });
  if (error) {
    YYERROR;
  }
}
    | ID '[' arithmetic_expression ']' '=' array_or_struct_init
{
  if (!$3->isConst () || $3->evalConst () <= 0)
    {
      yyast.diag()
          .new_error(@3, "Invalid array size (it shoud be a constant,"
                    "stricly positive expression)")
          .context(@$)
          .report();
      YYERROR;
    }
  bool error = register_with_new_id(symTab, $1, @$,
    [&]() {
      $$ = new VarDec (@$, $1, new ArrayType (@$, $3, nullptr), $6);
      symTab.push ((VarDec *)$$);
    });
  if (error) {
    YYERROR;
  }
};

array_or_struct_init
    : '{' init_list '}'
{
  $$ = new Initializer (@$, (List<Constant> *)($2->front ()));
}
    | '{' '}'
{
  $$ = new Initializer (@$, nullptr);
};

init_list
    : expression { $$ = new BigList<Expression> ($1); }
    | init_list ',' expression { $$ = $1->add ($3); };

const_dec
    : CONST type_spec untyped_const_dec
{
  $$ = $3;
  const Type *t = ((ConstDec *)$$)->type;
  if (t)
    {
      ((ArrayType *)t)->baseType = $2;
    }
  else
    {
      ((ConstDec *)$$)->type = $2;
    }
};

untyped_const_dec
    : ID '=' expression
{
  bool error = register_with_new_id(symTab, $1, @1,
    [&]() {
      $$ = new ConstDec (@1, $1, nullptr, $3);
      symTab.push ((ConstDec *)$$);
    });
  if (error) {
    YYERROR;
  }
}
    | ID '=' array_or_struct_init
{
  bool error = register_with_new_id(symTab, $1, @1,
    [&]() {
      $$ = new ConstDec(@1, $1, nullptr, $3);
      symTab.push ((ConstDec *)$$);
    });
  if (error) {
    YYERROR;
  }
}
    | ID '[' arithmetic_expression ']' '=' array_or_struct_init
{
  if (!$3->isConst () || $3->evalConst () <= 0)
    {
      yyast.diag()
          .new_error(@$, "Invalid array size (it shoud be a constant, "
                     "stricly positive expression)")
          .report();
      YYERROR;
    }

  bool error = register_with_new_id(symTab, $1, @1,
    [&]() {
      $$ = new ConstDec (@1, $1, new ArrayType (@1, $3, nullptr), $6);
      symTab.push ((ConstDec *)$$);
    });
  if (error) {
    YYERROR;
  }

  symTab.push ((ConstDec *)$$);
};

multiple_var_dec
    : var_dec ',' untyped_var_dec
{
  if (((VarDec *)$3)->type)
    {
      ((ArrayType *)(((VarDec *)$3)->type))->baseType
          = ((ArrayType *)(((VarDec *)$1)->type))->baseType;
    }
  else
    {
      ((VarDec *)$3)->type = ((VarDec *)$1)->type;
    }
  $$ = new MulVarDec (@$, (VarDec *)$1, (VarDec *)$3);
}
    | multiple_var_dec ',' untyped_var_dec
{
  if (((VarDec *)$3)->type)
    {
      ((ArrayType *)(((VarDec *)$3)->type))->baseType
          = ((ArrayType *)((MulVarDec *)$1)->decs->value->type)->baseType;
    }
  else
    {
      ((VarDec *)$3)->type = ((MulVarDec *)$1)->decs->value->type;
    }
  $$ = $1;
  ((MulVarDec *)$$)->decs->add ((VarDec *)$3);
};

multiple_const_dec
    : const_dec ',' untyped_const_dec
{
  if (((ConstDec *)$3)->type)
    {
      ((ArrayType *)(((ConstDec *)$3)->type))->baseType
          = ((ArrayType *)(((ConstDec *)$1)->type))->baseType;
    }
  else
    {
      ((ConstDec *)$3)->type = ((ConstDec *)$1)->type;
    }
  $$ = new MulConstDec (@$, (ConstDec *)$1, (ConstDec *)$3);
}
    | multiple_const_dec ',' untyped_const_dec
{
  if (((ConstDec *)$3)->type)
    {
      ((ArrayType *)(((ConstDec *)$3)->type))->baseType
          = ((ArrayType *)((MulConstDec *)$1)->decs->value->type)->baseType;
    }
  else
    {
      ((ConstDec *)$3)->type = ((MulConstDec *)$1)->decs->value->type;
    }
  $$ = $1;
  ((MulConstDec *)$$)->decs->add ((ConstDec *)$3);
};

break_statement
    : BREAK
{
  $$ = new BreakStmt(@$);
};

return_statement
    : RETURN
{
  yyast.diag()
      .new_error(@$, "Non-void function should return a value")
      .report();
  YYERROR;
}
    | RETURN expression
{
  $$ = new ReturnStmt (@$, $2);
};

assignment
    : expression assign_op expression
{
  $$ = new Assignment (@$, $1, $2, $3);
  static_cast<Assignment *>($$)->desugar();
}
    | expression inc_op
{
  $$ = new Assignment (@$, $1, $2, nullptr);
  static_cast<Assignment *>($$)->desugar();
}
    | postfix_expression '.' SET_SLC '(' expression ',' expression ')'
{
  $$ = new Assignment (@$, $1, $7, $5);
  static_cast<Assignment *>($$)->desugar();
};

assign_op
    : '='
    | RSHFT_ASSIGN
    | LSHFT_ASSIGN
    | ADD_ASSIGN
    | SUB_ASSIGN
    | MUL_ASSIGN
    | DIV_ASSIGN
    | MOD_ASSIGN
    | AND_ASSIGN
    | XOR_ASSIGN
    | OR_ASSIGN;

inc_op
    : INC_OP
    | DEC_OP;

multiple_assignment
    : TIE '(' nontrivial_expr_list ')' '=' postfix_expression
{
  //std::reverse($3->begin(), $3->end());
  $$ = new MultipleAssignment (@$, (FunCall *)$6, std::move(*$3));
};

assertion
    : ASSERT '(' expression ')'
{
  $$ = new Assertion (@$, $3);
};

null_statement
    : %empty
{
  $$ = new NullStmt(@$);
};

dummy
    : %empty
{
  symTab.pushFrame ();
};

block
    : '{' dummy statement_list '}'
{
  symTab.popFrame ();
  $$ = new Block (@$, std::move(*$3));
  delete $3;
}; // Replace 'dummy' with the midrule action '{symTab.pushFrame();}'
   // will cause reduce/reduce conflicts.

r_block
    : '{' dummy r_statement_list '}'
{
  symTab.popFrame ();
  $$ = new Block (@$, std::move(*$3));
  delete $3;
}; // Replace 'dummy' with the midrule action '{symTab.pushFrame();}'
   // will cause reduce/reduce conflicts.

statement_list
    : %empty { $$ = new std::vector<Statement *>(); }
    | statement_list statement
{
  $1->push_back($2);
  $$ = $1;
};

r_statement_list
    : statement_list final_statement
{
  $1->push_back($2);
  $$ = $1;
};

for_statement
    : FOR
{
  symTab.pushFrame ();
}
'(' for_init ';' expression ';' assignment ')' statement
{
  $$ = new ForStmt (@$, (SimpleStatement *)$4, $6, (Assignment *)$8, $10);
  symTab.popFrame ();
};

for_init
    : var_dec
{
  // Here no need to check if the var is already declare since it's the
  // first declaration inside the new frame.
  symTab.push ((VarDec *)$1);
}
    | assignment;

if_statement
    : IF '(' expression ')' statement ELSE statement
{
  $$ = new IfStmt (@$, $3, $5, $7);
}
    | IF '(' expression ')' statement
{
  $$ = new IfStmt (@$, $3, $5, nullptr);
};

switch_statement
    : SWITCH '(' expression ')' '{' case_list '}'
{
  $$ = new SwitchStmt (@$, $3, *$6);
  delete $6;
};

case_list
    : case
{
  $$ = new std::vector<Case *> ();
  $$->push_back($1);
}
    | case_list case
{
  $$ = $1;
  $$->push_back ($2);
};

case
    : CASE case_label ':' statement_list
{
  $$ = new Case (@$, $2, std::move(*$4));
}
    | DEFAULT ':' statement_list
{
  $$ = new Case (@$, nullptr, std::move(*$3));
};

case_label
  : constant
  | symbol_ref

final_statement
  : return_statement ';'
  | IF '(' expression ')' r_statement ELSE r_statement
{
  $$ = new IfStmt (@$, $3, $5, $7);
};

//*************************************************************************************
// Function Definitions
//*************************************************************************************

func_def
    : type_spec ID { symTab.pushFrame (); }
      '(' param_dec_list ')' '{' r_statement_list '}'
{
  auto f = new FunDef (@$, $2, $1, $5, new Block(@8, std::move(*$8)));
  symTab.popFrame ();

  bool error = register_with_new_id(symTab, $2, f->get_decl_loc(), [&]() {
    $$ = f;
    delete $8;
    symTab.push(f);
    yyast.registerFunDef($$);
  });

  if (error) {
    YYERROR;
  }
}
    | func_template;

param_dec_list
    : %empty
{
  $$ = nullptr;
}
    | nontrivial_param_dec_list;

nontrivial_param_dec_list
    : var_dec
{
  $$ = new List<VarDec> ((VarDec *)$1);
}
    | nontrivial_param_dec_list ',' var_dec
{
  $$ = $1->add ((VarDec *)$3);
};

func_template
  : TEMPLATE { symTab.pushFrame (); }
    '<' template_param_dec_list '>' type_spec ID '(' param_dec_list ')' r_block
{
  auto f = new Template (@$, $7, $6, $9, (Block *)$11, $4);
  symTab.popFrame ();

  bool error = register_with_new_id(symTab, $7, f->get_decl_loc(), [&]() {
    $$ = f;
    symTab.push(f);
    yyast.registerTemplate(f);
    yyast.registerFunDef(f);
  });

  if (error) {
    YYERROR;
  }
};

template_param_dec_list
    : %empty { $$ = nullptr; }
    | nontrivial_template_param_dec_list;

nontrivial_template_param_dec_list
    : template_param_dec
{
  $$ = new List<TempParamDec> ((TempParamDec *)$1);
}
    | nontrivial_template_param_dec_list ',' template_param_dec
{
  $$ = $1->add ((TempParamDec *)$3);
};

template_param_dec : type_spec ID
{
  bool error = register_with_new_id(symTab, $2, @$,
    [&]() {
      $$ = new TempParamDec (@$, $2, $1);
      symTab.push ((TempParamDec *)$$);
  });
  if (error) {
    YYERROR;
  }
};
%%

#pragma GCC diagnostic pop
