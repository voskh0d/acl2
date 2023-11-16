#ifndef UTILS_H
#define UTILS_H

#include <cassert>
#include <cstring>
#include <deque>
#include <memory>
#include <ostream>
#include <tuple>
#include <vector>

#define UNREACHABLE() assert(!"Woopsie, some unreachable code was reach")

//***********************************************************************************
// Linked Lists
//***********************************************************************************

template <class T>
class List {
public:
  T *value;
  List<T> *next;

  // clang-format off
  List(T *v, List<T> *n = nullptr) {
    value = v;
    next = n;
  }
  List(T *v1, T *v2) {
    value = v1;
    next = new List<T>(v2);
  }

  static List *empty() { return nullptr; }

  unsigned length();
  List *nthl(unsigned n);
  T *nth(unsigned n);
  T *find(const char *name);
  bool isMember(T *ptr);
  List *add(T *value);
  List *push(T *value);
  List *pop();
  List *copy();
  void displayList(std::ostream &os, unsigned indent = 0) const;
  void displayDefs(std::ostream &os) const;

  T *first() { return value; }
};

template <typename T>
List<T> *to_list(std::vector<T *> v) {

  List<T> *res = nullptr;
  for (auto elm : v) {
    if (res)
      res->add(elm);
    else
      res = new List(elm);
  }
  return res;
}

template <typename T>
std::vector<T *> collect(List<T> *l) {
  std::vector<T *> res;
  for_each(l, [&res](T *elm) { res.push_back(elm); });
  return res;
}

template <typename T, typename F>
void for_each(List<T> *list, F f) {
  for (; list; list = list->next) {
    f(list->first());
  }
}

// Length of a list;

template <class T>
unsigned List<T>::length() {
  unsigned result = 0;
  List<T> *ptr = this;
  while (ptr) {
    result++;
    ptr = ptr->next;
  }
  return result;
}

// nth sublist of a list;

template <class T>
List<T> *List<T>::nthl(unsigned n) {
  List<T> *ptr = this;
  while (ptr && n) {
    ptr = ptr->next;
    n--;
  }
  return ptr;
}

// nth element of a list;

template <class T>
T *List<T>::nth(unsigned n) {
  return this->nthl(n)->value;
}

// Add a new element to the end of a list:

template <class T>
List<T> *List<T>::add(T *value) {
  List<T> *ptr = this;
  while (ptr->next) {
    ptr = ptr->next;
  }
  ptr->next = new List<T>(value);
  return this;
}

// Add a new element to the front of a list and return a pointer to the new
// list:

template <class T>
List<T> *List<T>::push(T *value) {
  return new List<T>(value, this);
}

// Find an element in the list with a given name:

template <class T>
T *List<T>::find(const char *name) {
  List<T> *ptr = this;
  while (ptr) {
    if (!strcmp(ptr->value->getname(), name)) {
      return ptr->value;
    }
    ptr = ptr->next;
  }
  return nullptr;
}

// Find a given object in a list:

template <class T>
bool List<T>::isMember(T *ptr) {
  List<T> *lst = this;
  while (lst) {
    if (lst->value == ptr) {
      return true;
    }
    lst = lst->next;
  }
  return false;
}

// Remove the head of a list and return a pointer to the tail:

template <class T>
List<T> *List<T>::pop() {
  List<T> *result = this->next;
  delete this;
  return result;
}

// Create a copy of a list:

template <class T>
List<T> *List<T>::copy() {
  List<T> *result = new List<T>(value);
  List<T> *ptr = next;
  while (ptr) {
    result->add(ptr->value);
    ptr = ptr->next;
  }
  return result;
}

// Call "display" on each element of a list:

template <class T>
void List<T>::displayList(std::ostream &os, unsigned indent) const {
  const List<T> *ptr = this;
  while (ptr) {
    ptr->value->display(os, indent);
    ptr = ptr->next;
  }
}

// Call "displayDef" on each element of a list:

template <class T>
void List<T>::displayDefs(std::ostream &os) const {
  List<T> *ptr = this;
  while (ptr) {
    ptr->value->displayDef(os);
    ptr = ptr->next;
  }
}

// BigList: a list with a pointer to the last entry, designed for a fast add
// operation

template <class T>
class BigList {
  List<T> *front_;
  List<T> *back_;

public:
  BigList(T *v) : front_(new List<T>(v)), back_(front_) {}

  BigList *add(T *v) {
    back_->next = new List<T>(v);
    back_ = back_->next;
    return this;
  }

  List<T> *front() { return front_; }
};

#define STRONGTYPEDEF(BASE, TYPE)                                             \
  struct TYPE {                                                               \
    TYPE() = default;                                                         \
    TYPE(BASE v) : value(v) {}                                                \
    TYPE(const TYPE &v) = default;                                            \
    TYPE &operator=(const TYPE &rhs) = default;                               \
    TYPE &operator=(BASE &rhs) { value = rhs; return *this; }                 \
    operator BASE & () { return value; }                                      \
    BASE value;                                                               \
    using BaseType = BASE;                                                    \
  }

template<class... Ts>
struct overloaded : Ts... { using Ts::operator()...; };
// explicit deduction guide (not needed as of C++20)
template<class... Ts>
overloaded(Ts...) -> overloaded<Ts...>;

// Check if the pointer elm is of type T. T and U should be both a pointer
// type. If both are the type but one if const (or volatile) and not the other
// this will return false. Maybe this behavior should be modified ?
template <typename T, typename U>
inline bool isa(U elm) {
  return dynamic_cast<T>(elm);
}

// Alaways cast elem from type U to T where U is a base of T.
template <typename T, typename U>
inline T always_cast(U elm) {
  auto t = dynamic_cast<T>(elm);
  assert(t && "Invalid conversion");
  return t;
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wformat-security"

template <typename... Args>
std::string format(const std::string &format, Args... args) {

  // Compute size of string.
  int size = std::snprintf(nullptr, 0, format.c_str(), args...) + 1;

  assert(size >= 0 && "Error during formatting");

  std::unique_ptr<char[]> buf(new char[(size_t)size]);
  std::snprintf(buf.get(), size, format.c_str(), args...);
  return std::string(buf.get(),
                     buf.get() + size - 1); // We don't want the '\0' inside
}

#pragma GCC diagnostic pop

#endif // UTILS_H
