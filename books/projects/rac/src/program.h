#ifndef PROGRAM_H
#define PROGRAM_H

#include "utils.h"
#include "visitor.h"

//***********************************************************************************
// Programs
//***********************************************************************************

enum class DispMode
{
  rac,
  acl2
};

class DefinedType;
class ConstDec;
class Template;
class FunDef;

// A program consists of type definitions, global constant declarations, and
// function definitions.
class Program
{
public:
  List<DefinedType> *typeDefs;
  List<ConstDec> *constDecs;
  List<Template> *templates;
  List<FunDef> *funDefs;

  Program ();

  bool parse(const std::string& file);
  bool process();

  // TODO constify ACL2Exp, then this can become const
  void displayConstDecs (std::ostream &os, DispMode mode);
  // Why this one is not defined
  //  void displayTemplates(ostream& os, DispMode mode, const char *prefix="");
  void displayTypeDefs (std::ostream &os, DispMode mode) const;
  void displayFunDefs (std::ostream &os, DispMode mode);
  void displayFunDecs (std::ostream &os) const;
  void display (std::ostream &os, DispMode mode = DispMode::rac);
  bool isEmpty () const;
  bool runAction(RecursiveASTVisitor *v);
};

extern Program prog;

#endif // PROGRAM_H
