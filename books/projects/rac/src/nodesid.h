#ifndef NODES_ID_H
#define NODES_ID_H

#define APPLY(CLASS, _) class CLASS;
#include "astnodes.def"
#undef APPLY

enum class NodesId {
#define APPLY(CLASS, _) CLASS,
#include "astnodes.def"
#undef APPLY
};

template <typename NodeType>
constexpr NodesId idOf(const NodeType *) {
  if constexpr (false)
    {}
#define APPLY(CLASS, _)                                                      \
  else if constexpr (std::is_same_v<NodeType, CLASS>)     \
    return NodesId::CLASS;
#include "astnodes.def"
#undef APPLY
  else
    assert(!"Uknown type");
}

template <typename NodeType>
constexpr NodesId idOf_impl(const NodeType *) {
  if constexpr (false)
    {}
#define APPLY(CLASS, _)                                                      \
  else if constexpr (std::is_same_v<NodeType, CLASS>)     \
    return NodesId::CLASS;
#include "astnodes.def"
#undef APPLY
  else
    assert(!"Uknown type");
}

#endif // NODES_ID_H
