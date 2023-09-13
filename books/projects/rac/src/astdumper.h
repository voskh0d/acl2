#ifndef ASTDUMPER_H
#define ASTDUMPER_H

#include "visitor.h"
#include "expressions.h"
#include "statements.h"
#include "functions.h"

#include <iostream>
#include <vector>


class ASTDumper : public RecursiveASTVisitor {

  using base_t = RecursiveASTVisitor;
  // We don't need type info, the address is enough.
  std::vector<void *> parents_;
public:

  ASTDumper() {
    std::cout << "digraph ast {\n";
    parents_.reserve(128);
  }

  ~ASTDumper() {
    std::cout << "}";
  }

  bool TraverseExpression(Expression *e) override {
    parents_.push_back(e);
    bool b = base_t::TraverseExpression(e);
    parents_.pop_back();
    return b;
  }

  bool TraverseStatement(Statement *s) override {
    parents_.push_back(s);
    bool b = base_t::TraverseStatement(s);
    parents_.pop_back();
    return b;
  }

// Edge declaration: ID -> ID;
// Since we define Visit* for all classes, most of the edges will be doubled:
// take for example the node Integer: we will run first VisitInteger, then
// VisitConstant and finaly, VisitInteger.
#define APPLY(CLASS, PARENT)                                                 \
bool Visit##CLASS (CLASS *ptr) override {                                    \
  /*  Node declaration: node_ADDRESS [label="KIND\nVALUE", shape=s]; */      \
  constexpr bool is_expression = std::is_base_of_v<Expression, CLASS>;       \
  const char *s = is_expression ? "diamond" : "oval";                        \
  std::cout << "node_" << ptr << " [label=\""#CLASS;                         \
                                                                             \
  if constexpr (is_expression) {                                             \
    Expression *e = reinterpret_cast<Expression *>(ptr);                     \
    if (const Type *t = e->exprType()) {                                     \
      std::cout << '\n';                                                     \
      t->displayVarType();                                                   \
    }                                                                        \
  }                                                                          \
                                                                             \
   std::cout << "\", shape=" << s << "];\n";                                 \
                                                                             \
  if (parents_.size() >= 2)                                                  \
      std::cout << "node_" << parents_[parents_.size() - 2] << " -> "        \
                << "node_" << ptr << ";\n";                                  \
                                                                             \
  return true;                                                               \
}
#include "ASTNodes.inc"
#undef APPLY

};

#endif // ASTDUMPER_H
