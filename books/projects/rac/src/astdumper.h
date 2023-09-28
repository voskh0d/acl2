#ifndef ASTDUMPER_H
#define ASTDUMPER_H

#include "expressions.h"
#include "functions.h"
#include "statements.h"
#include "visitor.h"

#include <iostream>
#include <vector>

// Display the AST as a dot graph (https://graphviz.org/). This is mainly use
// for debuging.
class ASTDumperAction final : public RecursiveASTVisitor<ASTDumperAction> {
public:
  // With the constructor and destructor, we write the top scope of the
  // graph.
  ASTDumperAction() {
    std::cout << "digraph ast {\n";
    parents_.reserve(128);
  }

  ~ASTDumperAction() { std::cout << "}"; }

  // For each node, we want to track its parents. The node at the end of the
  // parents_ vector is the current node and the one before is the direct
  // parent.
  bool TraverseExpression(Expression *e) {
    parents_.push_back(e);
    bool b = base_t::TraverseExpression(e);
    parents_.pop_back();
    return b;
  }

  bool TraverseStatement(Statement *s) {
    parents_.push_back(s);
    bool b = base_t::TraverseStatement(s);
    parents_.pop_back();
    return b;
  }

// Edge declaration: ID -> ID;
// Since we define Visit* for all classes, most of the edges will be doubled:
// take for example the node Integer: we will run first VisitInteger, then
// VisitConstant and finaly, VisitInteger.
#define APPLY(CLASS, PARENT)                                                  \
  bool Visit##CLASS(CLASS *ptr) {                                             \
    /*  Node declaration: node_ADDRESS [label="KIND\nVALUE", shape=s]; */     \
    constexpr bool is_expression = std::is_base_of_v<Expression, CLASS>;      \
    const char *s = is_expression ? "diamond" : "oval";                       \
    std::cout << "node_" << ptr << " [label=\"" #CLASS;                       \
                                                                              \
    if constexpr (is_expression) {                                            \
      Expression *e = reinterpret_cast<Expression *>(ptr);                    \
      if (const Type *t = e->get_type()) {                                    \
        std::cout << '\n';                                                    \
        t->displayVarType();                                                  \
      }                                                                       \
    }                                                                         \
                                                                              \
    std::cout << "\", shape=" << s << "];\n";                                 \
                                                                              \
    if (parents_.size() >= 2)                                                 \
      std::cout << "node_" << parents_[parents_.size() - 2] << " -> "         \
                << "node_" << ptr << ";\n";                                   \
                                                                              \
    return true;                                                              \
  }
#include "astnodes.def"
#undef APPLY

private:
  using base_t = RecursiveASTVisitor;
  // We don't need type info, the address is enough.
  std::vector<void *> parents_;
};

#endif // ASTDUMPER_H
