all : install

parse: diagnostics.cpp diagnostics.h visitor.hxx version.h argparse.h parser.ll parser.yy parser.h expressions.cpp functions.cpp types.cpp main.cpp expressions.h  functions.h  parser.h  program.h  statements.h  types.h  utils.h visitor.h astdumper.h astnodes.def typing.cpp typing.h sexpressions.h sexpressions.cpp program.h program.cpp
	bison -d -v -o parser.tab.cpp parser.yy
	flex -o lex.yy.cpp parser.ll
	g++ -Wall -Wextra -std=c++17 -O3 -g -o parse diagnostics.cpp functions.cpp expressions.cpp statements.cpp parser.tab.cpp lex.yy.cpp types.cpp typing.cpp main.cpp sexpressions.cpp program.cpp

debug: diagnostics.cpp diagnostics.h visitor.hxx version.h argparse.h parser.ll parser.yy parser.h expressions.cpp functions.cpp types.cpp main.cpp expressions.h  functions.h  parser.h  program.h  statements.h  types.h  utils.h visitor.h astdumper.h astnodes.def typing.cpp typing.h sexpressions.h sexpressions.cpp program.h program.cpp
	bison -d -v -o parser.tab.cpp parser.yy
	flex -o lex.yy.cpp parser.ll
	g++ -DDEBUG -Wall -Wextra -std=c++17 -O0 -g -o parse diagnostics.cpp functions.cpp expressions.cpp statements.cpp parser.tab.cpp lex.yy.cpp types.cpp typing.cpp main.cpp sexpressions.cpp program.cpp

version.h:
	sh -e generate_version.sh

#We should execute this rule every time, since it depends on some environment
#variables.
rac:
	printf "#!/bin/bash\n\nRAC=${RAC}\nACL2=${ACL2}" | cat - rac-skel > rac

install: parse rac
	install -m 775 parse ${RAC}/bin
	install -m 775 rac ${RAC}/bin
	rm rac parse

clean:
	rm -f rac parser.tab.c parser.tab.h parser.output lex.yy.c parser.c
	rm -f -r parse.dSym

veryclean : clean
	rm -f rac parse

.PHONY : all clean veryclean install rac version.h
