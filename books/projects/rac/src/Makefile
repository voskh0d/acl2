# Set g++ as default, unless the CC environment variable is already set.
ifeq ($(origin CC),default)
CC = g++
endif

# Preprocessor, compiler and liker flags. Those lines does not overwrite the
# environment variable, it only append more to them.
CPPFLAGS +=
CXXFLAGS += -Wall -Wextra -pedantic -std=c++17
LDFLAGS +=

SRCS += diagnostics.cpp expressions.cpp functions.cpp lex.yy.cpp main.cpp
SRCS += parser.tab.cpp program.cpp sexpressions.cpp statements.cpp types.cpp
SRCS += typing.cpp racconstraint.cpp forconstraints.cpp

# By default, build and install everything.
all : install

install: release rac
	install -m 775 parse ${RAC}/bin
	install -m 775 rac ${RAC}/bin
	rm rac parse

#We should execute this rule every time, since it depends on some environment
#variables.
rac:
	printf "#!/bin/bash\n\nRAC=${RAC}\nACL2=${ACL2}" | cat - rac-skel > rac

# Configure the releaes (no debug log and highest optiomization level) and
# debug.
release: CPPFLAGS += -O3
release: parse

debug: CPPFLAGS += -DDEBUG
debug: CXXFLAGS += -O0 -g
debug: parse

OBJS := $(SRCS:%.cpp=%.o)

# Compile and generate dependencies (stored under .deps).
DEPDIR := .deps
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.d

COMPILE.cpp = $(CC) $(DEPFLAGS) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c

%.o: %.cpp
%.o: %.cpp $(DEPDIR)/%.d | $(DEPDIR)
	$(COMPILE.cpp) $(OUTPUT_OPTION) $<

$(DEPDIR): ; @mkdir -p $@

DEPFILES := $(SRCS:%.cpp=$(DEPDIR)/%.d)
$(DEPFILES):
include $(wildcard $(DEPFILES))

# Generate the version header.
version.h:
	sh -e generate_version.sh

# Run bison and flex.
parser.tab.cpp: parser.yy
	bison -d -v -o parser.tab.cpp parser.yy -Wall

lex.yy.cpp: parser.ll parser.tab.cpp
	flex -o lex.yy.cpp parser.ll

# Build the binary.
parse: version.h ${OBJS}
	${CC} -o parse $(LDFLAGS) ${OBJS}

clean:
	rm -f ${OBJS} version.h parser.tab.cpp lex.yy.cpp
	rm -f -r parse.dSym

veryclean : clean
	rm -rf rac parse .deps

.PHONY : all clean veryclean install rac version.h release debug
