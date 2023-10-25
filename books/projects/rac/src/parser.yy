%{
#include "expressions.h"
#include "functions.h"
#include "parser.h"
#include "program.h"
#include "statements.h"
#include "types.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wfree-nonheap-object"

int yylex ();

extern Location yylloc;

void yyerror (const char *s)
{
  prog.diag().report(yylloc, s);
}

Program prog;
List<Builtin> builtins (new Builtin (Location::dummy(), "abs", &intType,
    new List<VarDec>(new VarDec(Location::dummy(), "", &intType))));
SymbolStack<SymDec> symTab;

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
  int i;
  char *s;
  Type *t;
  DefinedType *dt;
  Expression *exp;
  FunDef *fd;
  List<Expression> *expl;
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
  List<Statement> *stml;
  Case *c;
  std::vector<Case *> *cl;
}

%define parse.error verbose
%define parse.lac full

%locations
%define api.location.type { Location }

%token TYPEDEF CONST STRUCT ENUM TEMPLATE
%token INT UINT INT64 UINT64 BOOL
%token SLC SET_SLC
%token FOR IF ELSE WHILE DO SWITCH CASE DEFAULT BREAK RETURN ASSERT
%token ARRAY TUPLE TIE
%token AC_INT AC_FIXED
%token<s> RSHFT_ASSIGN LSHFT_ASSIGN ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN MOD_ASSIGN
%token<s> AND_ASSIGN XOR_ASSIGN OR_ASSIGN
%token<s> INC_OP DEC_OP
%token<s> RSHFT_OP LSHFT_OP AND_OP OR_OP LE_OP GE_OP EQ_OP NE_OP
%token<s> ID NAT TRUE FALSE TYPEID TEMPLATEID
%token<s> '=' '+' '-' '&' '|' '!' '~' '*' '%' '<' '>' '^' '/'
%start program

%type<t> type_spec typedef_type
%type<t> primitive_type array_param_type mv_type register_type struct_type enum_type
%type<dt> type_dec typedef_dec
%type<sf> struct_field
%type<sfl> struct_field_list
%type<ecd> enum_const_dec
%type<ecdl> enum_const_dec_list
%type<exp> expression constant integer boolean symbol_ref funcall
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

%expect 3

%%

//*************************************************************************************
// Program Structure
//*************************************************************************************

// A program consists of a sequence of type definitions, global
// constant declarations, and function definitions.  The parser
// produces four linked lists corresponding to these sequences, stored
// as the values of the variables typeDefs, constDecs, and funDefs.

program : program program_element{}
        | program_element;

program_element : type_dec ';'
{
  if (!prog.registerType($1))
  {
      prog.diag().report (@$, "Duplicate type definition");
      YYERROR;
  }
}
| const_dec ';'
{
  if(!prog.registerConstDec(static_cast<ConstDec *>($1)))
    {
      prog.diag().report (@$, "Duplicate global constant declaration");
      YYERROR;
    }
}
| func_def
{
  if (!prog.registerFunDef($1))
    {
      auto loc = static_cast<FunDef *>($1)->get_decl_loc();
      auto previous_loc = prog.getFunDef($1->getname())->get_decl_loc();
      prog.diag().report(loc, loc, "Duplicate function definition",
                        previous_loc, "defined here:");
      YYERROR;
    }
};

//*************************************************************************************
// Types
//*************************************************************************************

type_dec : typedef_dec | STRUCT ID struct_type
         {
  $$ = new DefinedType (@$, $2, $3);
}
| ENUM ID enum_type { $$ = new DefinedType (@$, $2, $3); };

typedef_dec : TYPEDEF typedef_type ID { $$ = new DefinedType (@$, $3, $2); }
            | typedef_dec '[' arithmetic_expression ']'
{
  if ($3->isConst () && $3->evalConst () > 0)
    {
      $$ = new DefinedType(@$, $1->getname(), new ArrayType (@$, $3, $1->getdef ()));
    }
  else
    {
      prog.diag().report(@$, @3,
        "Array dimension not a positive integer constant");
      YYERROR;
    }
};

typedef_type : primitive_type     // name of a primitive C numerical type
             | register_type    // Algorithmic C register class
               | array_param_type // instantiation of array class template
               | mv_type          // instantiation of mv class template
               | TYPEID
{
  $$ = prog.getType($1);
} // name of a previously declared type
;

type_spec : typedef_type // type that can appear in a typedef declaration
          | STRUCT struct_type
{
  $$ = $2;
} // standard C structure type
| ENUM enum_type
{
  $$ = $2;
} // standard C enumeration type
;

primitive_type : INT { $$ = &intType; }
               | UINT { $$ = &uintType; }
| INT64 { $$ = &int64Type; }
| UINT64 { $$ = &uint64Type; }
| BOOL { $$ = &boolType; };

register_type
    : AC_FIXED '<' arithmetic_expression ',' arithmetic_expression ',' TRUE '>'
{
  if ($3->isConst () && $3->isInteger ()
      && ($3->evalConst () >= 0) & $5->isConst () && $5->isInteger ())
    {
      $$ = new FixedPointType (@$, $3, $5, true);
    }
  else
    {
      prog.diag().report(@$, "Illegal parameter of ac_fixed");
      YYERROR;
    }
}
| AC_FIXED '<' arithmetic_expression ',' arithmetic_expression ',' FALSE '>'
{
  if ($3->isConst () && $3->isInteger ()
      && ($3->evalConst () >= 0) & $5->isConst () && $5->isInteger ())
    {
      $$ = new FixedPointType (@$, $3, $5, false);
    }
  else
    {
      prog.diag().report(@$, "Illegal parameter of ac_fixed");
      YYERROR;
    }
}
| AC_INT '<' arithmetic_expression ',' FALSE '>'
{
  if ($3->isConst () && $3->isInteger () && $3->evalConst () >= 0)
    {
      $$ = new IntType (@$, $3, false);
    }
  else
    {
      prog.diag().report (@$, "Illegal parameter of ac_int");
      YYERROR;
    }
}
| AC_INT '<' arithmetic_expression ',' TRUE '>'
{
  if ($3->isConst () && $3->isInteger () && $3->evalConst () >= 0)
    {
      $$ = new IntType (@$, $3, true);
    }
  else
    {
      prog.diag().report (@$, "Illegal parameter of ac_int");
      YYERROR;
    }
}

;

array_param_type : ARRAY '<' type_spec ',' arithmetic_expression '>'
                 {
  if ($5->isConst () && $5->evalConst () > 0)
    {
      $$ = new ArrayType (@$, $5, $3);
    }
  else
    {
      prog.diag().report (@$, @3, "Non-constant array dimension");
      YYERROR;
    }
};

struct_type : '{' struct_field_list '}' { $$ = new StructType (@$, *$2); };

struct_field_list : struct_field { $$ = new std::vector<StructField *> ({$1}); }
                  | struct_field_list struct_field { $1->push_back($2); $$ = $1; };

struct_field : type_spec ID ';' { $$ = new StructField ($1, $2); };

enum_type : '{' enum_const_dec_list '}' { $$ = new EnumType (@$, *$2); };

enum_const_dec_list : enum_const_dec { $$ = new std::vector<EnumConstDec *> ({$1}); }
                    | enum_const_dec_list ',' enum_const_dec
{ $1->push_back($3); $$ = $1; };

enum_const_dec : ID
               {
  if (symTab.find_last_frame ($1))
    {
      prog.diag().report(
        @$,
        format("Duplicate identifier declaration (could be an enum, a "
               "variable or template parameter) `%s`",
               $1));
      YYERROR;
    }
  $$ = new EnumConstDec (@$, $1);
  symTab.push ($$);
}
| ID '=' expression
{
  if (symTab.find_last_frame ($1))
    {
      prog.diag().report(
        @$,
        format("Duplicate identifier declaration (could be an enum, a "
               "variable or template parameter) `%s`",
               $1));
      YYERROR;
    }
  $$ = new EnumConstDec (@$, $1, $3);
  symTab.push ($$);
};

mv_type : TUPLE '<' type_spec ',' type_spec '>'
        {
  $$ = new MvType (@$, { $3, $5 });
}
| TUPLE '<' type_spec ',' type_spec ',' type_spec '>'
{
  $$ = new MvType (@$, { $3, $5, $7 });
}
| TUPLE '<' type_spec ',' type_spec ',' type_spec ',' type_spec '>'
{
  $$ = new MvType (@$, { $3, $5, $7, $9 });
}
| TUPLE '<' type_spec ',' type_spec ',' type_spec ',' type_spec ',' type_spec '>'
{
  $$ = new MvType (@$, { $3, $5, $7, $9, $11 });
}
| TUPLE '<' type_spec ',' type_spec ',' type_spec ',' type_spec ',' type_spec ',' type_spec '>'
{
  $$ = new MvType (@$, { $3, $5, $7, $9, $11, $13 });
}
| TUPLE '<' type_spec ',' type_spec ',' type_spec ',' type_spec ',' type_spec ',' type_spec ',' type_spec '>'
{
  $$ = new MvType (@$, { $3, $5, $7, $9, $11, $13, $15 });
}
| TUPLE '<' type_spec ',' type_spec ',' type_spec ',' type_spec ',' type_spec ',' type_spec ',' type_spec ',' type_spec '>'
{
  $$ = new MvType (@$, { $3, $5, $7, $9, $11, $13, $15, $17 });
};

//*************************************************************************************
// Expressions
//*************************************************************************************

primary_expression : constant | symbol_ref | funcall | '(' expression ')'
                   {
  $$ = new Parenthesis(@$, $2);
};

constant : integer | boolean;

integer : NAT { $$ = new Integer (@$, $1); }
        | '-' NAT
{
  char *name = new char[strlen ($2) + 2];
  strcpy (name + 1, $2);
  name[0] = '-';
  $$ = new Integer (@$, name);
};

boolean : TRUE { $$ = Boolean::true_v(@$); }
        | FALSE { $$ = Boolean::false_v(@$); };

symbol_ref : ID
           {
  SymDec *s = symTab.find ($1);
  if (s)
    {
      $$ = new SymRef (@$, s);
    }
  else
    {
      prog.diag().report (@$, format("Unknown symbol `%s`", $1));
      YYERROR;
    }
}

;

funcall : ID '(' expr_list ')'
        {
  FunDef *f;
  if ((f = prog.getFunDef ($1)) == nullptr
      && (f = builtins.find ($1)) == nullptr)
    {
      prog.diag().report (@$, "Undefined function");
      YYERROR;
    }
  else
    {
      $$ = new FunCall (@$, f, $3);
    }
}
| TEMPLATEID '<' arith_expr_list '>' '(' arith_expr_list ')'
{
  Template *f;
// TODO: Why are we looking into funDefs and not in templates ???
  if ((f = (Template *)prog.getFunDef ($1)) == nullptr)
    {
      prog.diag().report (@$, "Undefined function template");
      YYERROR;
    }
  else
    {
      $$ = new TempCall (@$, f, $6, $3);
    }
};

postfix_expression : primary_expression | array_or_bit_ref | struct_ref
                   | subrange;

// At this step, we don't know yet if it is a a bit reference and a
// (syntactically equivalent) array reference. The base must be examined after
// typing.
array_or_bit_ref : postfix_expression '[' expression ']'
{
  $$ = new ArrayRef (@$, $1, $3);
};

struct_ref : postfix_expression '.' ID { $$ = new StructRef (@$, $1, $3); }

subrange : postfix_expression '.' SLC '<' NAT '>' '(' expression ')'
{
  $$ = new Subrange (@$, $1, $8, Integer (@$, $5).evalConst ());
}

prefix_expression : postfix_expression | unary_op prefix_expression
                  {
  $$ = new PrefixExpr (@$, $2, $1);
}
| '(' type_spec ')' prefix_expression { $$ = new CastExpr (@$, $4, $2); }
| type_spec '(' expression ')' { $$ = new CastExpr (@$, $3, $1); };

unary_op : '+' | '-' | '~' | '!';

mult_expression : prefix_expression | mult_expression '*' prefix_expression
                {
  $$ = new BinaryExpr (@$, $1, $3, $2);
}
| mult_expression '/' prefix_expression { $$ = new BinaryExpr (@$, $1, $3, $2); }
| mult_expression '%' prefix_expression { $$ = new BinaryExpr (@$, $1, $3, $2); };

add_expression : mult_expression | add_expression '+' mult_expression
               {
  $$ = new BinaryExpr (@$, $1, $3, $2);
}
| add_expression '-' mult_expression { $$ = new BinaryExpr (@$, $1, $3, $2); };

arithmetic_expression : add_expression
                      | arithmetic_expression LSHFT_OP add_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
}
| arithmetic_expression RSHFT_OP add_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
};

rel_expression : arithmetic_expression
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

eq_expression : rel_expression | eq_expression EQ_OP rel_expression
              {
  $$ = new BinaryExpr (@$, $1, $3, $2);
}
| eq_expression NE_OP rel_expression { $$ = new BinaryExpr (@$, $1, $3, $2); };

and_expression : eq_expression | and_expression '&' eq_expression
               {
  $$ = new BinaryExpr (@$, $1, $3, $2);
};

xor_expression : and_expression | xor_expression '^' and_expression
               {
  $$ = new BinaryExpr (@$, $1, $3, $2);
};

ior_expression : xor_expression | ior_expression '|' xor_expression
               {
  $$ = new BinaryExpr (@$, $1, $3, $2);
};

log_and_expression : ior_expression | log_and_expression AND_OP ior_expression
                   {
  $$ = new BinaryExpr (@$, $1, $3, $2);
};

log_or_expression : log_and_expression
                  | log_or_expression OR_OP log_and_expression
{
  $$ = new BinaryExpr (@$, $1, $3, $2);
};

cond_expression : log_or_expression
                | log_or_expression '?' expression ':' cond_expression
{
  $$ = new CondExpr (@$, $3, $5, $1);
};

mv_expression : mv_type '(' expr_list ')'
              {
  $$ = new MultipleValue (@$, (MvType *)$1, $3);
};

expression : cond_expression | mv_expression;

expr_list: { $$ = nullptr; }
         | nontrivial_expr_list { $$ = $1; };

nontrivial_expr_list : expression { $$ = new List<Expression> ($1); }
                     | nontrivial_expr_list ',' expression { $$ = $1->add ($3); };

arith_expr_list: { $$ = nullptr; }
               | nontrivial_arith_expr_list { $$ = $1; };

nontrivial_arith_expr_list : arithmetic_expression
                           {
  $$ = new List<Expression> ($1);
}
| nontrivial_arith_expr_list ',' arithmetic_expression { $$ = $1->add ($3); };

//*************************************************************************************
// Statements
//*************************************************************************************

statement : simple_statement ';' | block | for_statement | if_statement
          | switch_statement;

r_statement : final_statement | r_block;

simple_statement : var_dec | const_dec | multiple_var_dec | multiple_const_dec
                 | break_statement
                   | assignment
                   | multiple_assignment
                   | assertion
                   | null_statement;

var_dec : type_spec untyped_var_dec
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

untyped_var_dec : ID
                {
  if (symTab.find_last_frame ($1))
    {
      prog.diag().report(
        @$,
        format("Duplicate identifier declaration (could be an enum, a "
               "variable or template parameter) `%s`",
               $1));
      YYERROR;
    }
  $$ = new VarDec (@$, $1, nullptr);
  symTab.push ((VarDec *)$$);
}
| ID '=' expression
{
  if (symTab.find_last_frame ($1))
    {
      prog.diag().report(
        @$,
        format("Duplicate identifier declaration (could be an enum, a "
               "variable or template parameter) `%s`",
               $1));
      YYERROR;
    }
  $$ = new VarDec (@$, $1, nullptr, $3);
  symTab.push ((VarDec *)$$);
}
| ID '=' array_or_struct_init
{
  if (symTab.find_last_frame ($1))
    {
      prog.diag().report(@$,
        format("Duplicate identifier declaration (could be an enum, a "
               "variable or template parameter) `%s`",
               $1));
      YYERROR;
    }
  $$ = new VarDec (@$, $1, nullptr, $3);
  symTab.push ((VarDec *)$$);
}
| ID '[' arithmetic_expression ']'
{
  if (!$3->isConst () || $3->evalConst () <= 0)
    {
      prog.diag().report(@$, @3, "Invalid array size (it shoud be a constant, "
                        "stricly positive expression)");
      YYERROR;
    }
  if (symTab.find_last_frame ($1))
    {
      prog.diag().report(@$,
        format("Duplicate identifier declaration (could be an enum, a "
               "variable or template parameter) `%s`",
               $1));
      YYERROR;
    }
  $$ = new VarDec (@$, $1, new ArrayType (@$, $3, nullptr));
  symTab.push ((VarDec *)$$);
}
| ID '[' arithmetic_expression ']' '=' array_or_struct_init
{
  if (!$3->isConst () || $3->evalConst () <= 0)
    {
      prog.diag().report (@$, @3, "Invalid array size (it shoud be a constant,"
        "stricly positive expression)");
      YYERROR;
    }
  if (symTab.find_last_frame ($1))
    {
      prog.diag().report(@$,
        format("Duplicate identifier declaration (could be an enum, a "
               "variable or template parameter) `%s`",
               $1));
      YYERROR;
    }
  $$ = new VarDec (@$, $1, new ArrayType (@$, $3, nullptr), $6);
  symTab.push ((VarDec *)$$);
};

array_or_struct_init : '{' init_list '}'
                     {
  $$ = new Initializer (@$, (List<Constant> *)($2->front ()));
};

init_list : expression { $$ = new BigList<Expression> ($1); }
          | init_list ',' expression { $$ = $1->add ($3); };

const_dec : CONST type_spec untyped_const_dec
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

untyped_const_dec : ID '=' expression
                  {
  if (symTab.find_last_frame ($1))
    {
      prog.diag().report (@$,
        format("Duplicate identifier declaration (could be an enum, a "
               "variable or template parameter) `%s`",
               $1));
      YYERROR;
    }
  $$ = new ConstDec (@$, $1, nullptr, $3);
  symTab.push ((ConstDec *)$$);
}
| ID '=' array_or_struct_init
{
  if (symTab.find_last_frame ($1))
    {
      prog.diag().report (@$,
        format("Duplicate identifier declaration (could be an enum, a "
               "variable or template parameter) `%s`",
               $1));
      YYERROR;
    }
  $$ = new ConstDec (@$, $1, nullptr, $3);
  symTab.push ((ConstDec *)$$);
}
| ID '[' arithmetic_expression ']' '=' array_or_struct_init
{
  if (!$3->isConst () || $3->evalConst () <= 0)
    {
      prog.diag().report (@$, "Invalid array size (it shoud be a constant, "
                              "stricly positive expression)");
      YYERROR;
    }
  if (symTab.find_last_frame ($1))
    {
      prog.diag().report(
        @$,
        format("Duplicate identifier declaration (could be an enum, a "
               "variable or template parameter) `%s`",
               $1));
      YYERROR;
    }
  $$ = new ConstDec (@$, $1, new ArrayType (@$, $3, nullptr), $6);
  symTab.push ((ConstDec *)$$);
};

multiple_var_dec : var_dec ',' untyped_var_dec
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

multiple_const_dec : const_dec ',' untyped_const_dec
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

break_statement : BREAK { $$ = new BreakStmt(@$); };

return_statement : RETURN { $$ = new ReturnStmt (@$, nullptr); }
                 | RETURN expression { $$ = new ReturnStmt (@$, $2); };

assignment : expression assign_op expression
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

assign_op : '=' | RSHFT_ASSIGN | LSHFT_ASSIGN | ADD_ASSIGN | SUB_ASSIGN
          | MUL_ASSIGN
            | MOD_ASSIGN
            | AND_ASSIGN
            | XOR_ASSIGN
            | OR_ASSIGN;

inc_op : INC_OP | DEC_OP;

multiple_assignment : TIE '(' nontrivial_expr_list ')' '=' postfix_expression
                    {
  $$ = new MultipleAssignment (@$, (FunCall *)$6, collect ($3));
};

assertion : ASSERT '(' expression ')' { $$ = new Assertion (@$, $3); };

null_statement: { $$ = new NullStmt(@$); };

dummy: { symTab.pushFrame (); };

block : '{' dummy statement_list '}'
      {
  symTab.popFrame ();
  $$ = new Block (@$, $3);
}; // Replace 'dummy' with the midrule action '{symTab.pushFrame();}'
   // will cause reduce/reduce conflicts.

r_block : '{' dummy r_statement_list '}'
        {
  symTab.popFrame ();
  $$ = new Block (@$, $3);
}; // Replace 'dummy' with the midrule action '{symTab.pushFrame();}'
   // will cause reduce/reduce conflicts.

statement_list: { $$ = nullptr; }
              | statement_list statement
{
  $$ = $1 ? $1->add ($2) : new List<Statement> ($2);
};

r_statement_list : statement_list final_statement
                 {
  $$ = $1 ? $1->add ($2) : new List<Statement> ($2);
};

for_statement : FOR { symTab.pushFrame (); }
              '(' for_init ';' expression ';' assignment ')' statement
{
  $$ = new ForStmt (@$, (SimpleStatement *)$4, $6, (Assignment *)$8, $10);
  symTab.popFrame ();
};

for_init : var_dec
         {
  // Here no need to check if the var is already declare since it's the
  // first declaration inside the new frame.
  symTab.push ((VarDec *)$1);
}
| assignment;

if_statement : IF '(' expression ')' statement
             {
  $$ = new IfStmt (@$, $3, $5, nullptr);
}
| IF '(' expression ')' statement ELSE statement
{
  $$ = new IfStmt (@$, $3, $5, $7);
};

switch_statement : SWITCH '(' expression ')' '{' case_list '}'
                 {
  $$ = new SwitchStmt (@$, $3, *$6);
  delete $6;
};

case_list : case { $$ = new std::vector<Case *> (); $$->push_back($1); }
          | case_list case { $$ = $1; $$->push_back ($2); };

case:
    CASE case_label ':' statement_list { $$ = new Case (@$, $2, $4); }
| DEFAULT ':' statement_list { $$ = new Case (@$, nullptr, $3); };

case_label : constant | symbol_ref

final_statement : return_statement ';'
                | IF '(' expression ')' r_statement ELSE r_statement
{
  $$ = new IfStmt (@$, $3, $5, $7);
};

//*************************************************************************************
// Function Definitions
//*************************************************************************************

func_def : type_spec ID { symTab.pushFrame (); }
         '(' param_dec_list ')' r_block
{
  $$ = new FunDef (@$, $2, $1, $5, (Block *)$7);
  symTab.popFrame ();
}
| func_template;

param_dec_list: { $$ = nullptr; }
              | nontrivial_param_dec_list;

nontrivial_param_dec_list : var_dec { $$ = new List<VarDec> ((VarDec *)$1); }
                          | nontrivial_param_dec_list ',' var_dec { $$ = $1->add ((VarDec *)$3); };

func_template : TEMPLATE { symTab.pushFrame (); }
              '<' template_param_dec_list '>' type_spec ID '(' param_dec_list ')' r_block
{
  $$ = new Template (@$, $7, $6, $9, (Block *)$11, $4);
  symTab.popFrame ();
  if (!prog.registerTemplate(static_cast<Template *>($$))) {
      prog.diag().report (@$, "Duplicate function definition");
      YYERROR;
  }
};

template_param_dec_list: { $$ = nullptr; }
                       | nontrivial_template_param_dec_list;

nontrivial_template_param_dec_list : template_param_dec
                                   {
  $$ = new List<TempParamDec> ((TempParamDec *)$1);
}
| nontrivial_template_param_dec_list ',' template_param_dec
{
  $$ = $1->add ((TempParamDec *)$3);
};

template_param_dec : type_spec ID
                   {
  if (symTab.find_last_frame ($2))
    {
      prog.diag().report (@$,
        format("Duplicate identifier declaration (could be an enum, a "
               "variable or template parameter) `%s`",
               $2));
      YYERROR;
    }
  $$ = new TempParamDec (@$, $2, $1);
  symTab.push ((TempParamDec *)$$);
};
%%

#pragma GCC diagnostic pop
