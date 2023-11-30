/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_PROGRAM_PARSER_PARSER_TAB_HPP_INCLUDED
# define YY_YY_PROGRAM_PARSER_PARSER_TAB_HPP_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TYPEDEF = 258,
    CONST = 259,
    STRUCT = 260,
    ENUM = 261,
    TEMPLATE = 262,
    INT = 263,
    UINT = 264,
    INT64 = 265,
    UINT64 = 266,
    BOOL = 267,
    SLC = 268,
    SET_SLC = 269,
    FOR = 270,
    IF = 271,
    ELSE = 272,
    WHILE = 273,
    DO = 274,
    SWITCH = 275,
    CASE = 276,
    DEFAULT = 277,
    BREAK = 278,
    RETURN = 279,
    ASSERT = 280,
    ARRAY = 281,
    TUPLE = 282,
    TIE = 283,
    AC_INT = 284,
    AC_FIXED = 285,
    RSHFT_ASSIGN = 286,
    LSHFT_ASSIGN = 287,
    ADD_ASSIGN = 288,
    SUB_ASSIGN = 289,
    MUL_ASSIGN = 290,
    DIV_ASSIGN = 291,
    MOD_ASSIGN = 292,
    AND_ASSIGN = 293,
    XOR_ASSIGN = 294,
    OR_ASSIGN = 295,
    INC_OP = 296,
    DEC_OP = 297,
    RSHFT_OP = 298,
    LSHFT_OP = 299,
    AND_OP = 300,
    OR_OP = 301,
    LE_OP = 302,
    GE_OP = 303,
    EQ_OP = 304,
    NE_OP = 305,
    ID = 306,
    NAT = 307,
    TRUE = 308,
    FALSE = 309,
    TYPEID = 310,
    TEMPLATEID = 311
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 123 "program/parser/parser.yy"

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

#line 142 "program/parser/parser.tab.hpp"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
typedef  Location  YYLTYPE;


extern YYSTYPE yylval;
extern YYLTYPE yylloc;
int yyparse (void);

#endif /* !YY_YY_PROGRAM_PARSER_PARSER_TAB_HPP_INCLUDED  */
