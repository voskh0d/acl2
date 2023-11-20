#include "astdumper.h"

#include "parser/ast/expressions.h"
#include "parser/ast/functions.h"
#include "parser/ast/statements.h"
#include "parser/ast/types.h"

#define APPLY(CLASS, PARENT)                                                  \
  bool ASTDumperAction::Visit##CLASS(CLASS *ptr) {                            \
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
        std::cout << '(' << t->ACL2ValWidth() << ')';                         \
      }                                                                       \
    }                                                                         \
                                                                              \
    if constexpr (std::is_base_of_v<SymDec, CLASS>) {                         \
      SymDec *s = reinterpret_cast<SymDec *>(ptr);                            \
      std::cout << '\n' << s->sym->getname() << ": " << s->type->to_string(); \
    }                                                                         \
                                                                              \
    std::cout << "\", shape=" << s << "];\n";                                 \
                                                                              \
    if constexpr (std::is_same_v<SymRef, CLASS>) {                            \
      SymRef *r = reinterpret_cast<SymRef *>(ptr);                            \
      std::cout << "node_" << r << " -> "                                     \
                << "node_" << r->symDec                                       \
                << " [style=dotted, constraint=false];\n";                    \
    }                                                                         \
                                                                              \
    if (parents_.size() >= 2)                                                 \
      std::cout << "node_" << parents_[parents_.size() - 2] << " -> "         \
                << "node_" << ptr << ";\n";                                   \
                                                                              \
    return true;                                                              \
  }
#include "parser/ast/astnodes.def"
#undef APPLY
