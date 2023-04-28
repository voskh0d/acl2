CXX ?= g++
CPPFLAGS +=
CXXFLAGS +=-std=c++17 -Wall -Wextra -pedantic
LDFLAGS +=

HEADERS = expressions.h functions.h parser.h program.h statements.h types.h utils.h version.h
SOURCES = expressions.cpp functions.cpp main.cpp output.cpp statements.cpp types.cpp version.cpp
OBJECTS = $(SOURCES:.cpp=.o)

$(shell echo "#include \"version.h\"\n\nchar const *const git_commit = \"$$(git describe --always --dirty --match 'NOT A TAG')\";" > version.cpp.tmp; if diff -q version.cpp.tmp version.cpp >/dev/null 2>&1; then rm version.cpp.tmp; else mv version.cpp.tmp version.cpp; fi)

all: CXXFLAGS += -o3
all: install

debug: CXXFLAGS += -o0 -g
debug: parse

parse: ${OBJECTS} parser.tab.o lex.yy.o
	${CXX} ${LDFLAGS} ${OBJECTS} parser.tab.o lex.yy.o -o parse

%.o: %.cpp ${HEADERS}
	${CXX} ${CXXFLAGS} -c $< -o $@

parser.tab.cpp: parser.yy
	bison -d -v -o parser.tab.cpp parser.yy

lex.yy.cpp: parser.ll
	flex -o lex.yy.cpp parser.ll

#We should execute this rule every time, since it depends on some environment
#variables.
rac:
	printf "#!/bin/bash\n\nRAC=${RAC}\nACL2=${ACL2}" | cat - rac-skel > rac

install: parse rac
	install -m 775 parse ${RAC}/bin
	install -m 775 rac ${RAC}/bin
	rm rac parse

clean:
	rm -f ${OBJECTS} lex.yy.o parser.tab.o rac parser.tab.c parser.tab.h parser.output lex.yy.c parser.c
	rm -f -r parse.dSym

veryclean : clean
	rm -f rac parse

.PHONY : all clean debug veryclean install rac
