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
  using type = SymDec *;

  // Represent the three states result: not found, found with matching case
  // and mach with different case.
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

  Result find_last_frame(std::string_view name) {
    for (auto it = begin(data_); it != end(data_); ++it) {
      // Detect the limit of frame and stop.
      if (!*it) {
        break;
      }

      if (!strcmp((*it)->getname(), name.data())) {
        return Result(Found(*it));
      }
    }

    for (auto it = begin(data_); it != end(data_); ++it) {
      // Detect the limit of frame and stop.
      if (!*it) {
        break;
      }

      if (!strcasecmp((*it)->getname(), name.data())) {
        return FoundWithDifferentCase(*it);
      }
    }
    return None();
  }

  Result find(std::string_view name) {
    for (auto it = begin(data_); it != end(data_); ++it) {
      // Detect the limit of frame and ingore it.
      if (!*it) {
        continue;
      }

      if (!strcmp((*it)->getname(), name.data())) {
        return Found(*it);
      }
    }

    for (auto it = begin(data_); it != end(data_); ++it) {
      // Detect the limit of frame and ingore it.
      if (!*it) {
        continue;
      }
      if (!strcasecmp((*it)->getname(), name.data())) {
        return FoundWithDifferentCase(*it);
      }
    }

    return None();
  }

  void dump() {
    for (auto it = begin(data_); it != end(data_); ++it) {
      // frame limit
      if (*it) {
        std::cerr << (*it)->getname() << '\n';
      } else {
        std::cerr << "======================================\n";
      }
    }
  }

private:
  std::deque<SymDec *> data_;
};

#endif
