# Set g++ as default, unless the CC environment variable is already set.
ifeq ($(origin CC),default)
CC = g++
endif

# Preprocessor, compiler and liker flags. Those lines does not overwrite the
# environment variable, it only append more to them.
CPPFLAGS +=
CXXFLAGS += -Wall -Wextra -pedantic -std=c++17
LDFLAGS +=

OBJS += program/parser/ast/ast.o program/parser/ast/expressions.o program/parser/ast/functions.o program/parser/ast/statements.o program/parser/ast/types.o
OBJS += program/parser/utils/diagnostics.o
OBJS += program/parser/lex.yy.o program/parser/parser.tab.o
OBJS += program/process/typing.o program/process/racconstraint.o program/process/forconstraints.o
OBJS += main.o program/astdumper.o program/program.o program/sexpressions.o

# By default, build and install everything.
all : install

install: release rac
	install -m 775 parse ${RAC}/bin
	install -m 775 rac ${RAC}/bin
	rm rac parse

# We should execute this rule every time, since it depends on some environment
# variables.
rac:
	printf "#!/bin/bash\n\nRAC=${RAC}\nACL2=${ACL2}" | cat - rac-skel > rac

# Configure the releaes (no debug log and highest optiomization level) and
# debug.
release: CPPFLAGS += -O3
release: parse

debug: CPPFLAGS += -DDEBUG
debug: CXXFLAGS += -O0 -g
debug: parse

# Compile and generate dependencies (stored under .deps).
DEPDIR := .deps
CPPFLAGS += -MT $@ -MMD -MP -MF $(DEPDIR)/$*.d

# Copy the layout of the sources in the dependencies directory.
$(DEPDIR):
	@find -type d -links 2 -exec mkdir -p "$(DEPDIR)/{}" \;

DEPFILES := $(SRCS:$*.cpp=$(DEPDIR)/$*.d)
$(DEPFILES):
include $(shell find $(DEPFILES) -name '*.d')

# Generate the version header.
version.h:
	sh -e generate_version.sh

# Run bison and flex.
program/parser/parser.tab.cpp: program/parser/parser.yy
	bison -d -v -o program/parser/parser.tab.cpp program/parser/parser.yy -Wall

program/parser/lex.yy.cpp: program/parser/parser.ll program/parser/parser.tab.cpp
	flex -o program/parser/lex.yy.cpp program/parser/parser.ll

# Build the binary.
parse:  $(DEPDIR) | version.h ${OBJS}
	${CC} -o parse $(LDFLAGS) ${OBJS}

clean:
	rm -f ${OBJS} version.h program/parser/parser.tab.cpp program/parser/lex.yy.cpp
	rm -f -r parse.dSym

veryclean : clean
	rm -rf rac parse .deps

.PHONY : all clean veryclean install rac release debug
