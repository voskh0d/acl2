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

/*
#include "statements.h"

template <typename T, bool reverse = false>
class NamedVector {
public:
  // Represent the three states result: not found, found with matching case
  // and mach with different case.

  using type = T;
  using iterator = typename std::deque<T>::iterator;

  struct None {};

  STRONGTYPEDEF(type, FoundIt);
  STRONGTYPEDEF(type, FoundWithDifferentCaseIt);
  using ResultIt = std::variant<None, FoundIt, FoundWithDifferentCaseIt>;

  STRONGTYPEDEF(iterator, Found);
  STRONGTYPEDEF(iterator, FoundWithDifferentCase);
  using Result = std::variant<None, Found, FoundWithDifferentCase>;

  void push(T value) {
    if (reverse) {
      data_.push_front(value);
    } else {
      data_.push_back(value);
    }
  }

  ResultIt find_it(const std::string_view name,
                   std::optional<iterator> restart_from = std::nullopt) {

    auto begin = restart_from ? *restart_from
                              : reverse ? data_.rbegin() : data_.begin();
    auto end = reverse ? data_.rend() : data_.end();

    for (auto it = begin; it != end; ++it) {

      if (string_compare_ignore_case(name, it->getname())) {
        if (name == it->getname()) {
          return ResultIt(Found(it));
        } else {
          return FoundWithDifferentCaseIt(it);
        }
      }
    }
    return None();
  }

  Result find(const std::string_view name) {

    auto res = find_it(name);
    return std::visit(overloaded{ [](FoundIt f) { return Found(*f.value); },
                                  [](FoundWithDifferentCaseIt f) {
                                    return FoundWithDifferentCase(*f.value);
                                  },
                                  [](None) { return None(); } },
                      res);
  }

private:
  bool string_compare_ignore_case(std::string_view a, std::string_view b) {
    return std::equal(a.begin(), a.end(), b.begin(), b.end(),
                      [](char a, char b) {
                        return std::tolower(static_cast<unsigned char>(a))
                               == std::tolower(static_cast<unsigned char>(b));
                      });
  }

  std::deque<T> data_;
};
*/

class SymbolStack {
  // We use a deque to store all values and we use nullptr to mark the limit
  // between frames. All values are sorted from last to be pushed to first
  // (this is done cheaply by deque push_front()) and thus searching should
  // be more or less efficient (we are traversing the addresses from low to
  // high).
public:
  struct FrameBoundary {
    int a;
  };
  using type = std::variant<FrameBoundary, SymDec *, FunDef *>;

  // Represent the three states result: not found, found with matching case
  // and mach with different case.
  struct None {};
  STRONGTYPEDEF(type, Found);
  STRONGTYPEDEF(type, FoundWithDifferentCase);
  using Result = std::variant<None, Found, FoundWithDifferentCase>;

  template <typename T>
  void push(T value) {
    data_.push_front({ value });
  }

  void pushFrame() { data_.push_front(FrameBoundary{}); }

  void popFrame() {
    // While there is some values in the vector and the last one the boudary,
    // we remove the element of the last frame.
    while (data_.size()
           && !std::holds_alternative<FrameBoundary>(data_.front())) {
      data_.pop_front();
    }
    data_.pop_front();
  }

  Result find_last_frame(std::string_view name) {
    for (auto it = begin(data_); it != end(data_); ++it) {
      // Detect the limit of frame and stop.
      if (std::holds_alternative<FrameBoundary>(*it)) {
        break;
      }

      if (!strcmp(get_name(*it), name.data())) {
        return Result(Found(*it));
      }
    }

    for (auto it = begin(data_); it != end(data_); ++it) {
      // Detect the limit of frame and stop.
      if (std::holds_alternative<FrameBoundary>(*it)) {
        break;
      }

      if (!strcasecmp(get_name(*it), name.data())) {
        return FoundWithDifferentCase(*it);
      }
    }
    return None();
  }

  Result find(std::string_view name) {
    for (auto it = begin(data_); it != end(data_); ++it) {
      // Detect the limit of frame and ingore it.
      if (std::holds_alternative<FrameBoundary>(*it)) {
        continue;
      }

      if (!strcmp(get_name(*it), name.data())) {
        return Found(*it);
      }
    }

    for (auto it = begin(data_); it != end(data_); ++it) {
      // Detect the limit of frame and ingore it.
      if (std::holds_alternative<FrameBoundary>(*it)) {
        continue;
      }
      if (!strcasecmp(get_name(*it), name.data())) {
        return FoundWithDifferentCase(*it);
      }
    }

    return None();
  }

  void dump() {
    for (auto it = begin(data_); it != end(data_); ++it) {
      // frame limit
      if (std::holds_alternative<FrameBoundary>(*it)) {
        std::cerr << "======================================\n";
      } else {
        std::cerr << get_name(*it) << '\n';
      }
    }
  }

  const char *get_name(type v) {
    return std::visit(overloaded{ [](SymDec *s) { return s->getname(); },
                                  [](FunDef *s) { return s->getname(); },
                                  [](FrameBoundary) {
                                    UNREACHABLE();
                                    return "";
                                  } },
                      v);
  }

  Location get_loc(type v) {
    return std::visit(overloaded{ [](SymDec *s) { return s->loc(); },
                                  [](FunDef *s) { return s->get_decl_loc(); },
                                  [](FrameBoundary) {
                                    UNREACHABLE();
                                    return Location::dummy();
                                  } },
                      v);
  }

private:
  std::deque<type> data_;
};

#endif
