#ifndef PARSER_H
#define PARSER_H

#include "program.h"

extern int yylineno;

extern int yyparse();
extern FILE *yyin;
extern FILE *yyout;
extern Program prog;

extern int yylineno;
extern char yyfilenm[];

#endif
