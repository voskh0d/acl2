#ifndef PARSER_H
#define PARSER_H

#include <variant>

#include "diagnostics.h"
#include "program.h"

extern int yylineno;
extern Location yylloc;

extern int yyparse();
extern FILE *yyin;

extern Program prog;

#include "statements.h"

class SymbolStack {
  // We use a deque to store all values and we use nullptr to mark the limit
  // between frames. All values are sorted from last to be pushed to first
  // (this is done cheaply by deque push_front()) and thus searching should be
  // more or less efficient (we are traversing the addresses from low to high).
public:
  // Represent the three states result: not found, found with matching case and
  // mach with different case.
  struct None {};
  STRONGTYPEDEF(SymDec *, Found);
  STRONGTYPEDEF(SymDec *, FoundWithDifferentCase);
  using Result = std::variant<None, Found, FoundWithDifferentCase>;

  void push(SymDec *value) {
    assert(value && "this stack does not support nullptr as value");
    data_.push_front(value);
  }

  void pushFrame() { data_.push_front(nullptr); }

  void popFrame() {
    // While there is some values in the vector and the last one is not null
    // (the end of the last frame), we remove the element of the last frame.
    while (data_.size() && data_.front()) {
      data_.pop_front();
    }
  }

  Result find_last_frame_safe(const char *name) {
    for (auto it = begin(data_); it != end(data_); ++it) {
      // Detect the limit of frame and stop.
      if (!*it) {
        break;
      }

      if (!strcmp((*it)->getname(), name)) {
        return Result(Found(*it));
      }

      if (!strcasecmp((*it)->getname(), name)) {
        return FoundWithDifferentCase(*it);
      }
    }
    return None();
  }

  Result find_safe(const char *name) {
    for (auto it = begin(data_); it != end(data_); ++it) {
      // Detect the limit of frame and ingore it.
      if (!*it) {
        continue;
      }

      if (!strcmp((*it)->getname(), name)) {
        return Found(*it);
      }

      if (!strcasecmp((*it)->getname(), name)) {
        return FoundWithDifferentCase(*it);
      }
    }
    return None();
  }

  SymDec *find_last_frame(const char *name) {
    for (auto it = begin(data_); it != end(data_); ++it) {
      // Detect the limit of frame and stop.
      if (!*it) {
        break;
      }

      if (!strcmp((*it)->getname(), name)) {
        return Found(*it);
      }
    }
    return nullptr;
  }

  SymDec *find(const char *name) {
    for (auto it = begin(data_); it != end(data_); ++it) {
      // Detect the limit of frame and ingore it.
      if (!*it) {
        continue;
      }

      if (!strcmp((*it)->getname(), name)) {
        return *it;
      }
    }
    return nullptr;
  }

private:
  std::deque<SymDec *> data_;
};

#endif
