// This file is used to generate code for each AST node except Expression and
// Statement.
// To define first define a macro APPLY(CLASS, PARENT) where CLASS is the
// current type and PARENT is the direct parent in the type hierarchy. For
// example for the Integer expression, Constant is its parent and not
// Expression (but the parent of Constant is Expression).
// Then include this file and #undef the macro (for sanity).
// For an example on how to use it, see visitor.h or visitor.cpp .

APPLY( Constant, Expression )
APPLY( Integer,  Constant )
APPLY( Boolean, Constant )
APPLY( SymRef, Expression )
APPLY( FunCall, Expression )
APPLY( TempCall, FunCall )
APPLY( Initializer, Expression)
APPLY( ArrayRef, Expression )
APPLY( ArrayParamRef, ArrayRef)
APPLY( StructRef, Expression )
APPLY( BitRef, Expression )
APPLY( Subrange, Expression )
APPLY( PrefixExpr, Expression)
APPLY( CastExpr, Expression )
APPLY( BinaryExpr, Expression )
APPLY( CondExpr, Expression )
APPLY( MultipleValue, Expression )

APPLY( SimpleStatement, Statement )
APPLY( SymDec, SimpleStatement )
APPLY( EnumConstDec, SymDec )
APPLY( VarDec, SymDec )
APPLY( ConstDec, VarDec )
APPLY( MulVarDec, SimpleStatement )
APPLY( MulConstDec, SimpleStatement )
APPLY( TempParamDec, SymDec )
APPLY( BreakStmt, SimpleStatement )
APPLY( ReturnStmt, SimpleStatement )
APPLY( NullStmt, SimpleStatement )
APPLY( Assertion, SimpleStatement )
APPLY( Assignment, SimpleStatement )
APPLY( AssignBit, SimpleStatement )
APPLY( AssignRange, SimpleStatement )
APPLY( AssignFull, SimpleStatement )
APPLY( MultipleAssignment, SimpleStatement )
APPLY( Block, Statement )
APPLY( IfStmt, Statement )
APPLY( ForStmt, Statement )
APPLY( Case, Statement)
APPLY( SwitchStmt, Statement )

APPLY( FunDef, Statement )
APPLY( Builtin, FunDef )
APPLY( Template, FunDef )
