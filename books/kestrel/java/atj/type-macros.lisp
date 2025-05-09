; Java Library
;
; Copyright (C) 2022 Kestrel Institute (http://www.kestrel.edu)
;
; License: A 3-clause BSD license. See the LICENSE file distributed with ACL2.
;
; Author: Alessandro Coglio (coglio@kestrel.edu)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package "JAVA")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(include-book "types")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defxdoc+ atj-type-macros
  :parents (atj-implementation)
  :short "User-level macros to verify and record ATJ types."
  :long
  (xdoc::topstring
   (xdoc::p
    "These are the event macros
     @(tsee atj-main-function-type) and @(tsee atj-other-function-type),
     whose purpose is described in @(see atj-types).")
   (xdoc::p
    "User-oriented documentation for these macros
     should be added at some point."))
  :order-subtopics t
  :default-parent t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define atj-process-output-type-spec (out-type-spec
                                      (formals symbol-listp)
                                      (in-types atj-type-listp))
  :guard (= (len formals) (len in-types))
  :returns (mv (type atj-typep)
               (array symbolp))
  :short "Process an output type specification in
          @(tsee atj-main-function-type) or @(tsee atj-other-function-type)."
  :long
  (xdoc::topstring
   (xdoc::p
    "An output type specification must be
     either a keyword that denotes an ATJ type,
     or a doublet consisting of a non-@('nil') symbol
     followed by a keyword that denotes an ATJ type.
     The second case is allowed only if the type is an array one,
     and in that case the non-@('nil') symbol must be
     some formal argument of the function that has the same array type:
     the non-@('nil') symbol is the name of the array."))
  (if (tuplep 2 out-type-spec)
      (b* (((list sym kwd) out-type-spec)
           ((unless (symbolp sym))
            (raise "Invalid array name ~x0." sym)
            (mv (atj-type-irrelevant) nil))
           (array sym)
           ((unless (keywordp kwd))
            (raise "Invalid type keyword ~x0." kwd)
            (mv (atj-type-irrelevant) nil))
           (type (atj-type-from-keyword kwd))
           ((when (and sym (not (atj-type-case type :jprimarr))))
            (raise "Invalid array name ~x0 for non-array type ~x1." array kwd)
            (mv (atj-type-irrelevant) nil))
           (pos (index-of array formals))
           ((when (not pos))
            (raise "Array name ~x0 not among formals ~x1." array formals)
            (mv (atj-type-irrelevant) nil))
           (in-type (nth pos in-types))
           ((unless (equal type in-type))
            (raise "The type ~x0 of the ~x1 input does not match ~
                    the type ~x2 of the ~x1 output."
                   (atj-type-to-keyword in-type) array kwd)
            (mv (atj-type-irrelevant) nil)))
        (mv type array))
    (if (keywordp out-type-spec)
        (mv (atj-type-from-keyword out-type-spec) nil)
      (prog2$ (raise "Invalid output type specification ~x0." out-type-spec)
              (mv (atj-type-irrelevant) nil)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define atj-process-output-type-specs ((out-type-specs true-listp)
                                       (formals symbol-listp)
                                       (in-types atj-type-listp))
  :guard (= (len formals) (len in-types))
  :returns (mv (types atj-type-listp)
               (arrays symbol-listp))
  :short "Lift @(tsee atj-process-output-type-spec) to lists."
  (b* (((when (endp out-type-specs)) (mv nil nil))
       ((mv type array) (atj-process-output-type-spec (car out-type-specs)
                                                      formals
                                                      in-types))
       ((mv types arrays) (atj-process-output-type-specs (cdr out-type-specs)
                                                         formals
                                                         in-types)))
    (mv (cons type types) (cons array arrays))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define atj-main-function-type-input-theorem ((fn symbolp)
                                              (guard pseudo-termp)
                                              (formal symbolp)
                                              (in-type atj-typep)
                                              (hints true-listp)
                                              (wrld plist-worldp))
  :returns (event "A @(tsee acl2::pseudo-event-formp).")
  :mode :program ; because of UNTRANSLATE
  :short "Theorem generated by @(tsee atj-main-function-type)
          for an input of an ACL2 function."
  :long
  (xdoc::topstring
   (xdoc::p
    "The theorem states that, under the guard,
     the specified formal argument satisfies the predicate
     that corresponds to the specified type.")
   (xdoc::p
    "The theorem has no rule classes because its only purpose is
     to make sure that its formula holds.
     The theorem is local (to the @(tsee encapsulate) generated by the macro)
     for the same reason."))
  (b* ((thm-name (packn-pos (list 'atj-
                                  fn
                                  '-input-
                                  formal
                                  '-
                                  (atj-type-to-keyword in-type))
                            (pkg-witness (symbol-package-name fn))))
       (thm-formula (implicate guard
                               `(,(atj-type-to-pred in-type) ,formal))))
    `(local
      (defthm ,thm-name
        ,(untranslate thm-formula t wrld)
        :rule-classes nil
        :hints ,hints))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define atj-main-function-type-input-theorems ((fn symbolp)
                                               (guard pseudo-termp)
                                               (formals symbol-listp)
                                               (in-types atj-type-listp)
                                               (hints true-listp)
                                               (wrld plist-worldp))
  :guard (= (len formals) (len in-types))
  :returns (events "A @(tsee acl2::pseudo-event-form-listp).")
  :mode :program ; because of ATJ-MAIN-FUNCTION-TYPE-INPUT-THEOREM
  :short "Theorems generated by @(tsee atj-main-function-type)
          for all the inputs of an ACL2 function."
  :long
  (xdoc::topstring
   (xdoc::p
    "This lifts @(tsee atj-main-function-type-input-theorem) to lists."))
  (if (endp formals)
      nil
    (cons (atj-main-function-type-input-theorem
           fn guard (car formals) (car in-types) hints wrld)
          (atj-main-function-type-input-theorems
           fn guard (cdr formals) (cdr in-types) hints wrld))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define atj-main-function-type-output-theorem ((fn symbolp)
                                               (guard pseudo-termp)
                                               (formals symbol-listp)
                                               (result maybe-natp)
                                               (out-type atj-typep)
                                               (hints true-listp)
                                               (wrld plist-worldp))
  :returns (event "A @(tsee acl2::pseudo-event-formp).")
  :mode :program ; because of UNTRANSLATE
  :short "Theorem generated by @(tsee atj-main-function-type)
          for the/an output of an ACL2 function."
  :long
  (xdoc::topstring
   (xdoc::p
    "The @('result') parameter is @('nil') if @('fn') returns a single result;
     otherwise, it is the (0-based) index of one of the @('fn')'s results.")
   (xdoc::p
    "The theorem states that, under the guard,
     the result of the function (applied to its formals)
     satisfies the predicate that corresponds to the specified type.")
   (xdoc::p
    "The theorem has no rule classes because its only purpose is
     to make sure that its formula holds.
     The theorem is local (to the @(tsee encapsulate) generated by the macro)
     for the same reason."))
  (b* ((thm-name (if result
                     (packn-pos (list 'atj-
                                      fn
                                      '-output-
                                      result
                                      '-
                                      (atj-type-to-keyword out-type))
                                (pkg-witness (symbol-package-name fn)))
                   (packn-pos (list 'atj-
                                    fn
                                    '-output-
                                    (atj-type-to-keyword out-type))
                              (pkg-witness (symbol-package-name fn)))))
       (fn-result (if result
                      `(mv-nth ,result (,fn ,@formals))
                    `(,fn ,@formals)))
       (thm-formula (implicate guard
                               `(,(atj-type-to-pred out-type) ,fn-result))))
    `(local
      (defthm ,thm-name
        ,(untranslate thm-formula t wrld)
        :rule-classes nil
        :hints ,hints))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define atj-main-function-type-output-theorems ((fn symbolp)
                                                (guard pseudo-termp)
                                                (formals symbol-listp)
                                                (nresults natp)
                                                (rev-out-types atj-type-listp)
                                                (hints true-listp)
                                                (wrld plist-worldp))
  :guard (= nresults (len rev-out-types))
  :returns (events "A @(tsee acl2::pseudo-event-form-listp).")
  :mode :program ; because of ATJ-MAIN-FUNCTION-TYPE-OUTPUT-THEOREM
  :short "Theorems generated by @(tsee atj-main-function-type)
          for all the outputs of a multi-valued ACL2 function."
  :long
  (xdoc::topstring
   (xdoc::p
    "This is only used when @('fn') returns multiple values.
     We generate an output type theorem for each,
     counting down from @('nresults - 1') to 0.")
   (xdoc::p
    "The output types are reversed (as suggested by the @('rev-') prefix,
     so that they ``match'' the counting down mentioned just above."))
  (if (zp nresults)
      nil
    (cons (atj-main-function-type-output-theorem
           fn guard formals (1- nresults) (car rev-out-types) hints wrld)
          (atj-main-function-type-output-theorems
           fn guard formals (1- nresults) (cdr rev-out-types) hints wrld))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define atj-main-function-type-fn (fn
                                   in-type-specs
                                   out-type-spec/specs
                                   (hints true-listp)
                                   (wrld plist-worldp))
  :returns (event "A @(tsee acl2::maybe-pseudo-event-formp).")
  :mode :program ; because of ATJ-MAIN-FUNCTION-TYPE-INPUT/OUTPUT-THEOREM(S)
  :short "Top-level event generated by @(tsee atj-main-function-type)."
  :long
  (xdoc::topstring
   (xdoc::p
    "This includes the theorems for the function inputs and outputs
     (if the function is in logic mode),
     as well as an event to record the function type in the table.")
   (xdoc::p
    "If the table already includes an entry for the function,
     the proposed function type is compared with the existing one.
     If they are the same, the call is considered redundant
     and no further action is taken.
     If they differ, it is an error."))
  (b* (((unless (function-namep fn wrld))
        (raise "The first input, ~x0, must be the name of a function." fn))
       (formals (formals fn wrld))
       ((unless (keyword-listp in-type-specs))
        (raise "The second input, ~x0, ~
                must be a list of ATJ type keywords."
               in-type-specs))
       (in-types ; error id not valid ATJ type keywords:
        (atj-type-list-from-keyword-list in-type-specs))
       ((unless (= (len in-types) (len formals)))
        (raise "The number of input types ~x0 must match ~
                the arity ~x1 of the function ~x2."
               in-type-specs (len formals) fn))
       (nresults (atj-number-of-results fn wrld))
       ((mv out-types arrays)
        (if (= nresults 1)
            (b* (((mv out-type array) (atj-process-output-type-spec
                                       out-type-spec/specs formals in-types)))
              (mv (list out-type) (list array)))
          (if (tuplep nresults out-type-spec/specs)
              (atj-process-output-type-specs
               out-type-spec/specs formals in-types)
            (prog2$ (raise "The third input, ~x0, ~
                            must be a list of length ~x1 ~
                            of output type specifications."
                           out-type-spec/specs nresults)
                    (mv nil nil)))))
       ((unless (no-duplicatesp-eq (remove-eq nil arrays)))
        (raise "The list of output array names, ~x0, ~
                contains non-NIL duplicates."
               arrays))
       (fn-info? (atj-get-function-type-info-from-table fn wrld))
       ((when fn-info?)
        (b* ((main (atj-function-type-info->main fn-info?)))
          (if (and (equal (atj-function-type->inputs main) in-types)
                   (equal (atj-function-type->outputs main) out-types))
              `(value-triple :redundant)
            (raise "The proposed ATJ main function type [~x0 -> ~x1] for ~x2 ~
                    differs from the already recorded [~x3 -> ~x4]."
                   in-type-specs
                   out-type-spec/specs
                   fn
                   (atj-type-list-to-keyword-list
                    (atj-function-type->inputs main))
                   (atj-type-list-to-keyword-list
                    (atj-function-type->outputs main))))))
       (guard (guard fn nil wrld))
       (input-thms (and (logicp fn wrld)
                        (atj-main-function-type-input-theorems fn
                                                               guard
                                                               formals
                                                               in-types
                                                               hints
                                                               wrld)))
       (output-thms
        (and (logicp fn wrld)
             (if (= nresults 1)
                 (list (atj-main-function-type-output-theorem fn
                                                              guard
                                                              formals
                                                              nil
                                                              (car out-types)
                                                              hints
                                                              wrld))
               (atj-main-function-type-output-theorems fn
                                                       guard
                                                       formals
                                                       nresults
                                                       (rev out-types)
                                                       hints
                                                       wrld))))
       (fn-ty (make-atj-function-type :inputs in-types
                                      :outputs out-types
                                      :arrays arrays))
       (fn-info (make-atj-function-type-info :main fn-ty :others nil)))
    `(encapsulate
       ()
       (set-ignore-ok t)
       ,@input-thms
       ,@output-thms
       (table ,*atj-function-type-info-table-name* ',fn ',fn-info))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defsection atj-main-function-type
  :short (xdoc::topstring
          "Macro to prove and record the primary input and output "
          (xdoc::seetopic "atj-types" "types")
          " of an ACL2 function.")
  :long
  (xdoc::topstring
   (xdoc::p
    "This has to be used on the functions of interest
     (i.e. functions for which we want to generate Java code)
     prior to calling ATJ,
     so that ATJ can take advantage of the type information
     recorded for the functions.
     This is only relevant
     when @(':deep') is @('nil') and @(':guards') is @('t');
     in all other cases, the type information is ignored.")
   (xdoc::p
    "For instance, the file @('types-for-natives.lisp') uses this macro
     on the ACL2 functions that are implemented natively in AIJ.")
   (xdoc::p
    "If ATJ encounters a function that is not in the table,
     it assumes the widest possible type (i.e. the one for all ACL2 values)
     for all the inputs and outputs of the function.
     See the code generation functions for details.")
   (xdoc::@def "atj-main-function-type"))
  (defmacro atj-main-function-type (fn
                                    in-type-specs
                                    out-type-spec/specs
                                    &key
                                    hints)
    `(make-event
      (atj-main-function-type-fn
       ',fn ',in-type-specs ',out-type-spec/specs ',hints (w state)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define atj-other-function-type-theorem ((fn symbolp)
                                         (guard pseudo-termp)
                                         (formals symbol-listp)
                                         (in-types atj-type-listp)
                                         (result maybe-natp)
                                         (out-type atj-typep)
                                         (hints true-listp)
                                         (wrld plist-worldp))
  :guard (= (len formals) (len in-types))
  :returns (event "A @(tsee acl2::pseudo-event-formp).")
  :mode :program ; because of UNTRANSLATE
  :short "Theorem generated by @(tsee atj-other-function-type)
          for the/an output of an ACL2 function."
  :long
  (xdoc::topstring
   (xdoc::p
    "The @('result') parameter is @('nil') if @('fn') returns a single result;
     otherwise, it is the (0-based) index of one of the @('fn')'s results.")
   (xdoc::p
    "The theorem states that if the formal parameters
     satisfy both the function's guard
     and the predicates that correspond to the input types,
     then the result of the function (applied to its formal parameters)
     satisfies the predicate that corresponds to the output type.")
   (xdoc::p
    "The theorem has no rule classes because its only purpose is
     to make sure that its formula holds.
     The theorem is local (to the @(tsee encapsulate) generated by the macro)
     for the same reason."))
  (b* ((thm-name (if result
                     (packn-pos (list 'atj-
                                      fn
                                      '-other-type-
                                      result
                                      '-
                                      (atj-type-to-keyword out-type))
                                (pkg-witness (symbol-package-name fn)))
                   (packn-pos (list 'atj-
                                    fn
                                    '-other-type)
                              (pkg-witness (symbol-package-name fn)))))
       (type-hyps (atj-other-function-type-theorem-aux formals in-types))
       (fn-result (if result
                      `(mv-nth ,result (,fn ,@formals))
                    `(,fn ,@formals)))
       (concl `(,(atj-type-to-pred out-type) ,fn-result))
       (thm-formula (implicate (conjoin (cons guard type-hyps)) concl)))
    `(local
      (defthm ,thm-name
        ,(untranslate thm-formula t wrld)
        :rule-classes nil
        :hints ,hints)))

  :prepwork
  ((define atj-other-function-type-theorem-aux ((formals symbol-listp)
                                                (in-types atj-type-listp))
     :guard (= (len formals) (len in-types))
     :returns (terms pseudo-term-listp
                     :hyp :guard
                     :hints (("Goal" :in-theory (enable atj-type-to-pred))))
     :parents nil
     (cond ((endp formals) nil)
           (t (cons `(,(atj-type-to-pred (car in-types)) ,(car formals))
                    (atj-other-function-type-theorem-aux (cdr formals)
                                                         (cdr in-types))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define atj-other-function-type-theorems ((fn symbolp)
                                          (guard pseudo-termp)
                                          (formals symbol-listp)
                                          (in-types atj-type-listp)
                                          (nresults natp)
                                          (out-types atj-type-listp)
                                          (hints true-listp)
                                          (wrld plist-worldp))
  :guard (= nresults (len out-types))
  :returns (events "A @(tsee acl2::pseudo-event-form-listp).")
  :mode :program ; because of ATJ-OTHER-FUNCTION-TYPE-THEOREM
  :short "Theorems generated by @(tsee atj-other-function-type)
          for all the outputs of a multi-valued ACL2 function."
  :long
  (xdoc::topstring
   (xdoc::p
    "This is only used when @('fn') returns multiple values.
     We generate an output type theorem for each,
     counting down from @('nresults - 1') to 0."))
  (if (zp nresults)
      nil
    (cons (atj-other-function-type-theorem fn
                                           guard
                                           formals
                                           in-types
                                           (1- nresults)
                                           (car out-types)
                                           hints
                                           wrld)
          (atj-other-function-type-theorems fn
                                            guard
                                            formals
                                            in-types
                                            (1- nresults)
                                            (cdr out-types)
                                            hints
                                            wrld))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define atj-check-other-function-type ((new-in-types atj-type-listp)
                                       (old-fn-types atj-function-type-listp)
                                       (all-in-typess atj-type-list-listp))
  :returns (yes/no booleanp)
  :short "Check the new input types
          passed to @(tsee atj-other-function-type)
          against the existing function types."
  :long
  (xdoc::topstring
   (xdoc::p
    "The primary and secondary input types attached to a function
     are used to generate overloaded methods for the function.
     It must be possible, at compile time, to always resolve the method,
     based on the most specific argument types.
     This should be guaranteed if the set of all the function's input types
     (more precisely, the set of all the input type tuples of the function)
     is closed under greatest lower bounds that do not include @('nil')s,
     as explained below.")
   (xdoc::p
    "For example, consider a binary function @('f')
     with two function types whose inputs are
     @('(:arational :ainteger)') and @('(:ainteger :arational)').
     These will give rise to two overloaded methods for @('f'),
     one with argument types @('Acl2Rational') and @('Acl2Integer'),
     and one with argument types @('Acl2Integer') and @('Acl2Rational').
     Consider a method call whose actual argument types
     are @('Acl2Integer') and @('Acl2Integer'):
     if only those two overloaded methods are available,
     then there is no most specific method that is based just on the types.
     However, if a third overloaded method were available
     with @('Acl2Integer') and @('Acl2Integer') as argument types,
     that would be the most specific method to call.
     This is the case if the table includes a function type for @('f')
     with input types @('(:ainteger :ainteger)').")
   (xdoc::p
    "Generalizing from this example,
     we want the set of all function input types
     to be closed under greatest lower bounds.
     This way, if some tuple of actual arguments
     fits two different overloaded methods,
     it will also fit the method corresponding to the greatest lower bound;
     therefore, there will be always a ``minimum'' method
     that will be selected at compile time and called at run time.
     However, recall that @(tsee atj-type-meet) may produce @('nil'):
     if the greatest lower bound contains a @('nil') component,
     the closure requirement does not apply,
     because it means that some types are incompatible
     and therefore there is no confusion about most specific types.")
   (xdoc::p
    "We calculate these greatest lower bounds on ATJ types,
     not on the corresponding Java types,
     even though it is the Java types that are used
     to resolve the overloaded methods in the Java code.
     This way, we have more flexibility in mapping
     ATJ types that are related in the ATJ type partial order
     to Java types that are not related in the Java type partial order.")
   (xdoc::p
    "The closure property is also needed for ATJ's type annotations.
     When type-annotating a function call,
     the arguments are type-annotated first.
     Based on the initially inferred types of the arguments,
     a (primary or secondary) function type is searched
     that matches those inferred types.
     This may or may not be found
     (and in the latter case automatic conversions are inserted
     to the primary input types of the function),
     but if one exists, it must be unque to avoid an ambiguity.
     The closure property ensures this.")
   (xdoc::p
    "Besides the closure property just explained,
     we also ensure that the proposed new input types
     differ from all the existing input types.
     We maintain the uniqueness, for each function,
     of the (primary and secondary) input types in the table,
     so that there is exactly one overloaded method for each input type tuple.
     Redundant calls of @(tsee atj-other-function-type)
     are handled before calling this function.")
   (xdoc::p
    "The @('new-in-types') parameter of this function
     consist of the new proposed input types.
     The @('old-fn-types') parameter
     consists of all the existing secondary input types already in the table,
     which we @(tsee cdr) through and compare against @('new-in-types')
     to ensure that they are all distinct.
     The @('all-in-typess') parameter of this function
     consists of all the primary and secondary input types in the table,
     plus @('new-in-types');
     this parameter stays constant, we do not @(tsee cdr) through it
     because we need the whole collection to check the closure property.
     We include @('new-in-types')
     because the new proposed input types contribute to the closure properties:
     they will be in the table if all the checks succeed;
     for instance, if only @(':arational') is in the table
     and we are trying to add @(':ainteger'),
     their greatest lower bound is @(':ainteger'),
     which will be in the table.
     The primary function type is not included in @('old-fn-types')
     because the primary input types are always checked
     to be strictly wider than @('new-in-types'),
     in @(tsee atj-other-function-type-fn)."))
  (b* (((when (endp old-fn-types)) t)
       (old-fn-type (car old-fn-types))
       (old-in-types (atj-function-type->inputs old-fn-type))
       ((when (equal new-in-types old-in-types))
        (raise "The proposed input types ~x0 must differ from ~
                the existing secondary input types ~
                for the function, ~
                but they are equal to some of these existing types."
               new-in-types))
       ((unless (= (len old-in-types) (len new-in-types)))
        (raise "Internal error: ~
                the number of proposed input types ~x0 differs from ~
                the number of existing input types ~x1."
               new-in-types old-in-types))
       (glb (atj-type-list-meet old-in-types new-in-types))
       ((unless (or (member-eq nil glb)
                    (member-equal glb all-in-typess)))
        (raise "The proposed input types ~x0 ~
                and some existing input types ~x1, ~
                have a greatest lower bound ~x2 ~
                that is not in the table ~
                and differs from the proposed input types. ~
                This may cause type ambiguities. ~
                Consider adding types ~x2 first, ~
                and then the proposed input types ~x0."
               new-in-types old-in-types glb)))
    (atj-check-other-function-type new-in-types
                                   (cdr old-fn-types)
                                   all-in-typess)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define atj-other-function-type-fn (fn
                                    in-type-specs
                                    out-type-spec/specs
                                    (hints true-listp)
                                    (wrld plist-worldp))
  :returns (event "A @(tsee acl2::maybe-pseudo-event-formp).")
  :mode :program ; because of ATJ-OTHER-FUNCTION-TYPE-THEOREM
  :short "Top-level event generated by @(tsee atj-other-function-type)."
  :long
  (xdoc::topstring
   (xdoc::p
    "This includes the theorem(s) stating that
     the guard and input types imply the output type(s),
     as well as an event to record the function type in the table.")
   (xdoc::p
    "It is an error if the function does not have a primary type already;
     that is, @(tsee atj-main-function-type) must be called
     before calling @(tsee atj-other-function-type).")
   (xdoc::p
    "The proposed input types must be narrower than the primary input types;
     otherwise, there would be no advantage
     in adding these secondary input types,
     and in generating overloaded method corresponding to these types.
     The proposed output types must be narrower than or the same as
     the primary output types:
     since the primary output types are proved under the guard assumption only,
     while the secondary output types are proved
     with additional type hypotheses,
     it does not make sense that the secondary output types
     is wider than, or unrelated to, the primary output types;
     this situation probably signals the misstatement of some types
     to either @(tsee atj-main-function-type)
     or @(tsee atj-other-function-type).")
   (xdoc::p
    "If the proposed function type is already in the table,
     the call of @(tsee atj-other-function-type) is considered redundant
     and no further action is taken.")
   (xdoc::p
    "We also ensure that the addition of the proposed types
     does not cause type ambiguities:
     see @(tsee atj-check-other-function-type) for details.")
   (xdoc::p
    "We may add additional sanity checks in the future,
     e.g. that if the new input types are narrower than or equal to
     some already existing secondary types,
     then the output types must satisfy that relation too.
     The reason is analogous to the one discussed above
     to motivate the check against the primary output types;
     but here we are talking about the secondary output types."))
  (b* (((unless (function-namep fn wrld))
        (raise "The first input, ~x0, must be the name of a function." fn))
       (formals (formals fn wrld))
       ((unless (keyword-listp in-type-specs))
        (raise "The second input, ~x0, ~
                must be a list of ATJ type keywords."
               in-type-specs))
       (in-types ; error if not valid ATJ type keywords:
        (atj-type-list-from-keyword-list in-type-specs))
       ((unless (= (len in-types) (len formals)))
        (raise "The number of input types ~x0 must match ~
                the arity ~x1 of the function ~x2."
               in-type-specs (len formals) fn))
       (nresults (atj-number-of-results fn wrld))
       ((mv out-types arrays)
        (if (= nresults 1)
            (b* (((mv out-type array)
                  (atj-process-output-type-spec out-type-spec/specs
                                                formals
                                                in-types)))
              (mv (list out-type) (list array)))
          (if (tuplep nresults out-type-spec/specs)
              (atj-process-output-type-specs
               out-type-spec/specs formals in-types)
            (prog2$ (raise "The third input, ~x0, ~
                            must be a list of length ~x1 ~
                            of output type specifications."
                           out-type-spec/specs nresults)
                    (mv nil nil)))))
       ((unless (no-duplicatesp-eq (remove-eq nil arrays)))
        (raise "The list of output array names, ~x0, ~
                contains non-NIL duplicates."
               arrays))
       (fn-info? (atj-get-function-type-info-from-table fn wrld))
       ((unless fn-info?)
        (raise "The function ~x0 does not have a primary function type yet. ~
                Use ATJ-MAIN-FUNCTION-TYPE to define it, ~
                and then try again this ATJ-OTHER-FUNCTION-TYPE."
               fn))
       (main-fn-type (atj-function-type-info->main fn-info?))
       (main-in-types (atj-function-type->inputs main-fn-type))
       (main-out-types (atj-function-type->outputs main-fn-type))
       ((unless (atj-type-list-< in-types main-in-types))
        (raise "The proposed inputs types ~x0 must be strictly narrower ~
                than the primary input types ~x1."
               in-type-specs
               (atj-type-list-to-keyword-list main-in-types)))
       ((unless (atj-type-list-<= out-types main-out-types))
        (raise "The proposed output types ~x0 must be ~
                narrower than or equal to, ~
                the primary output types ~x1."
               out-type-spec/specs
               (atj-type-list-to-keyword-list main-out-types)))
       (other-fn-types (atj-function-type-info->others fn-info?))
       (new-fn-type (make-atj-function-type :inputs in-types
                                            :outputs out-types
                                            :arrays (repeat nresults nil)))
       ((when (member-equal new-fn-type other-fn-types))
        `(value-triple :redundant))
       (other-in-types (atj-function-type-list->inputs other-fn-types))
       (all-in-typess (cons in-types other-in-types))
       (- (atj-check-other-function-type in-types other-fn-types all-in-typess))
       (guard (guard fn nil wrld))
       (thms
        (if (= nresults 1)
            (list (atj-other-function-type-theorem fn
                                                   guard
                                                   formals
                                                   in-types
                                                   nil
                                                   (car out-types)
                                                   hints
                                                   wrld))
          (atj-other-function-type-theorems fn
                                            guard
                                            formals
                                            in-types
                                            nresults
                                            out-types
                                            hints
                                            wrld)))
       (new-fn-info (change-atj-function-type-info
                     fn-info? :others (cons new-fn-type other-fn-types))))
    `(encapsulate
       ()
       (set-ignore-ok t)
       ,@thms
       (table ,*atj-function-type-info-table-name* ',fn ',new-fn-info))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defsection atj-other-function-type
  :short (xdoc::topstring
          "Macro to prove and record secondary input and output "
          (xdoc::seetopic "atj-types" "types")
          " of an ACL2 function.")
  :long
  (xdoc::topstring
   (xdoc::p
    "This has to be used on the functions of interest
     (i.e. functions for which we want to generate Java code)
     prior to calling ATJ,
     so that ATJ can take advantage of the type information
     recorded for the functions.
     This is only relevant
     when @(':deep') is @('nil') and @(':guards') is @('t');
     in all other cases, the type information is ignored.")
   (xdoc::p
    "Each of the successful calls of this macro
     will result in an overloaded method with the specified types."))
  (defmacro atj-other-function-type (fn
                                     in-types
                                     out-type/types
                                     &key
                                     hints)
    `(make-event
      (atj-other-function-type-fn
       ',fn ',in-types ',out-type/types ',hints (w state)))))
