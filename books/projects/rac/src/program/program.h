#ifndef PROGRAM_H
#define PROGRAM_H

#include "parser/utils/diagnostics.h"

#include <algorithm>
#include <string>
#include <vector>

//***********************************************************************************
// Programs
//***********************************************************************************

enum class DispMode { rac, acl2 };

class DefinedType;
class ConstDec;
class Template;
class FunDef;

// A program consists of type definitions, global constant declarations, and
// function definitions.
class Program {
  std::vector<DefinedType *> typeDefs;
  std::vector<ConstDec *> constDecs;
  std::vector<Template *> templates;
  std::vector<FunDef *> funDefs;

  DiagnosticHandler diag_;

public:
  Program();

  // Parse the file given and store the result into this class. The program
  // should be empty before calling it.
  bool parse(const std::string &file);

  // Only used in the parser.
  DiagnosticHandler &diag() { return diag_; }

  // Apply all required passes (type check, desugarization, ...) to the
  // program.
  bool process();

  void dumpAsDot() const;

  // Add anew type/constant/function to the program. Those should only be
  // called in the parser. Return false if the registration failed (they is
  // already something with the same name).
  bool registerType(DefinedType *t);
  void registerConstDec(ConstDec *d);
  void registerTemplate(Template *t);
  void registerFunDef(FunDef *t);

  // Get an type/dec/function called `name`. Return nullptr if nothing was
  // registered with this name.
  DefinedType *getType(const std::string &name);
  ConstDec *getConstDec(const std::string &name);
  Template *getTemplate(const std::string &name);
  FunDef *getFunDef(const std::string &name);

  // Display functions.
  void displayConstDecs(std::ostream &os, DispMode mode) const;
  // Why this one is not defined
  //  void displayTemplates(ostream& os, DispMode mode, const std::string&
  //  prefix="");
  void displayTypeDefs(std::ostream &os, DispMode mode) const;
  void displayFunDefs(std::ostream &os, DispMode mode) const;
  void displayFunDecs(std::ostream &os) const;
  void display(std::ostream &os, DispMode mode = DispMode::rac) const;

  // Run an action (implemented by v) on the full program in the following
  // order: constant declarations, template fuctions and functions.
  template <typename Visitor>
  bool runAction(Visitor *v) {
    return std::all_of(constDecs.begin(), constDecs.end(),
                       [&](auto e) { return v->TraverseStatement(e); })
           && std::all_of(templates.begin(), templates.end(),
                          [&](auto e) { return v->TraverseStatement(e); })
           && std::all_of(funDefs.begin(), funDefs.end(),
                          [&](auto e) { return v->TraverseStatement(e); });
  }

private:
  bool isEmpty() const;
};

extern Program prog;

#endif // PROGRAM_H
