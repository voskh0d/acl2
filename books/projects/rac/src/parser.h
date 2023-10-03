#ifndef PARSER_H
#define PARSER_H

#include "program.h"

extern int yylineno;
extern Location yylloc;

extern int yyparse();
extern FILE *yyin;

extern Program prog;

#endif
