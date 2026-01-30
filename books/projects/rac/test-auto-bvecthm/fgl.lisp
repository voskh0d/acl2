(in-package "RTL")

;;; Experimental FGL file

(include-book "projects/arm/utils/rtl-utils" :dir :system)
(include-book "centaur/fgl/def-fgl-rewrite" :dir :system)
(include-book "kestrel/utilities/keyword-value-lists" :dir :system)
;; Now we define a tool that uses FGL to prove lemmas about (0-ary) constrained
;; function which are established to be bounded non-negative integers using
;; bvecthm+ form. The idea is to generate an generalized instance that replaces
;; the constrained functions with variables, and whose form is better suited
;; for FGL.

(defmacro bvecthm+ (&rest thm)
  (declare (xargs :guard (and (true-listp thm)
                              (symbolp (car thm)))))
  (b* ((body (cadr thm))
       (implies-form? (equal (car body) 'implies))
       (bvecthm-form `(bvecthm ,@thm)))
    (if implies-form?
        bvecthm-form
      (b* ((fn (car (cadr body)))
           (constrained-fn? (= (len (cdr (cadr body))) 0))
           (thm-name (car thm)))
        (if (not constrained-fn?)
            bvecthm-form
          `(progn ,bvecthm-form
                  (table known-bvecps ',fn ',thm-name)))))))

(defmacro bitthm+ (&rest thm)
  `(progn (bitthm ,@thm)
          (table known-bvecps ',(car (cadr (cadr thm))) ',(car thm))))

(define pseudo-term-fix (x)
  :returns (x pseudo-termp)
  (if (pseudo-termp x)
      x
    nil)
  ///
  (defthm pseudo-term-fix-involutive
    (equal (pseudo-term-fix (pseudo-term-fix x))
           (pseudo-term-fix x)))
  (defthm pseudo-term-fix-is-okay
    (implies (pseudo-termp x)
             (equal (pseudo-term-fix x) x)))
  )

(fty::deffixtype pseudo-term
  :pred pseudo-termp
  :fix pseudo-term-fix
  :equiv pseudo-termp-equiv
  :define t
  :forward t)

(define pseudo-term-list-fix (x)
  :returns (x pseudo-term-listp)
  (if (consp x)
      (cons (pseudo-term-fix (car x)) (pseudo-term-list-fix (cdr x)))
    nil)
  ///
  (defthm pseudo-term-list-fix-involutive
    (equal (pseudo-term-list-fix (pseudo-term-list-fix x))
           (pseudo-term-list-fix x)))
  (defthm pseudo-termp-fix-is-okay
    (implies (pseudo-term-listp x)
             (equal (pseudo-term-list-fix x) x)))
  )

(fty::deffixtype pseudo-term-list
  :pred pseudo-term-listp
  :fix pseudo-term-list-fix
  :equiv pseudo-term-list-equiv
  :define t
  :forward t)

;; (define symbol-list-fix (lst)
;;   :returns (ret symbol-listp)
;;   (if (consp lst)
;;       (cons (acl2::symbol-fix (car lst))
;;             (symbol-list-fix (cdr lst)))
;; ;;     nil))

(local-defthm len-remove1-equal
  (implies (member-equal x y)
           (equal (len (remove1-equal x y))
                  (1- (len y))))
  :hints (("Goal" :in-theory (e/d () ()))))

(local-defthm symbol-listp-of-union-equal
  (implies (and (symbol-listp x)
                (symbol-listp y))
           (symbol-listp (union-equal x y))))

;; (local-defthm pseudo-term-listp-append
;;   (implies (pseudo-term-listp x)
;;            (equal (pseudo-term-listp (append x y))
;;                   (pseudo-term-listp y))))

(local-defthm symbol-listp-implies-pseudo-termp-listp
  (implies (symbol-listp x)
           (pseudo-term-listp x)))

;; (local-defthm symbol-listp-append
;;   (implies (symbol-listp x)
;;            (equal (symbol-listp (append x y))
;;                   (symbol-listp y))))

;; (local-defthm len-cons
;;   (equal (len (cons x y))
;;          (1+ (len y)))
;;   :hints (("Goal" :in-theory (e/d (len) ()))))

;; (local (in-theory (disable acl2::genvar len)))

;; (define merge-alist ((a1 alistp)
;;                      (a2 alistp))
;;   :returns (ret alistp :hyp :guard)
;;   (if (consp a1)
;;       (b* ((key (caar a1)))
;;         (if (assoc-equal key a2)
;;             (merge-alist (cdr a1) a2)
;;           (merge-alist (cdr a1) (cons (car a1) a2))))
;;     a2))

;; (local-defthm assoc-merge-alist
;;   (implies (and (alistp a1)
;;                 (alistp a2))
;;            (equal (assoc key (merge-alist a1 a2))
;;                   (if (assoc key a2)
;;                       (assoc key a2)
;;                     (assoc key a1))))
;;   :hints (("Goal" :in-theory (e/d (merge-alist) ()))))

;; (defthm symbol-alistp-merge-alist
;;   (implies (and (symbol-alistp x)
;;                 (symbol-alistp y))
;;            (symbol-alistp (merge-alist x y)))
;;   :hints (("Goal" :in-theory (e/d (merge-alist) ()))))

;; (defthm symbol-alistp-strip-cars
;;     (implies (symbol-alistp x)
;;              (symbol-listp (strip-cars x))))


;; (local-defthm my-genvar-unique
;;   (implies (and (stringp x)
;;                 (stringp y)
;;                 (equal (my-genvar x avoid-vars)
;;                        (my-genvar y avoid-vars)))
;;            (equal x y))
;;   :hints (("Goal" :in-theory (e/d (my-genvar) ())
;;                   :expand ((MY-GENVAR Y AVOID-VARS))
;;                   :induct (and (my-genvar x avoid-vars)
;;                                (my-genvar y avoid-vars))))
;;   :rule-classes nil)

(local (include-book "std/basic/intern-in-package-of-symbol" :dir :system))

(local-defthmd append-last
  (implies (>= (len y) 1)
           (equal (last (append x y))
                  (last y))))

(local-defthmd intern-in-package-of-symbol-lemma
  (implies (and (not (equal x t))
                (not (equal x nil))
                (symbolp x))
           (and (intern-in-package-of-symbol (concatenate 'string (symbol-name x) "'")
                                             'my-genvar)
                (not (equal (intern-in-package-of-symbol (concatenate 'string (symbol-name x) "'")
                                                         'my-genvar)
                            t))))
  :hints (("Goal" :in-theory (e/d () (ACL2::EQUAL-OF-INTERN-IN-PACKAGE-OF-SYMBOLS))
                  :use ((:instance ACL2::EQUAL-OF-INTERN-IN-PACKAGE-OF-SYMBOLS
                         (a (concatenate 'string (symbol-name x) "'"))
                         (b "NIL")
                         (acl2::in-pkg 'my-genvar))
                        (:instance ACL2::EQUAL-OF-INTERN-IN-PACKAGE-OF-SYMBOLS
                         (a (concatenate 'string (symbol-name x) "'"))
                         (b "T")
                         (acl2::in-pkg 'my-genvar))
                        (:instance str::explode-of-implode
                         (x (APPEND (ACL2::EXPLODE (SYMBOL-NAME X))
                                    '(#\'))))
                        (:instance append-last
                         (x (ACL2::EXPLODE (SYMBOL-NAME X)))
                         (y '(#\')))))))

(local-defthm symbol-listp-remove1
  (implies (symbol-listp x)
           (symbol-listp (remove1-equal y x))))

;; (i-am-here)

(define max-len ((x symbol-listp))
  (if (consp x)
      (max (length (symbol-name (car x)))
           (max-len (cdr x)))
    0)
  ///
  (defthm member-p-leq-max-len
    (implies (member x y)
             (<= (length (symbol-name x)) (max-len y)))
    :rule-classes :linear))

(local-defthm length-implode-append
  (implies (stringp x)
           (equal (LENGTH
                   (ACL2::IMPLODE (APPEND (ACL2::EXPLODE x)
                                          '(#\'))))
                  (1+ (length x))))
  :hints (("Goal" :in-theory (e/d (length) ()))))


(define my-genvar-aux ((x symbolp)
                       (avoid-vars symbol-listp))

  :measure (if (member x avoid-vars) (1+ (- (max-len avoid-vars) (length (symbol-name x)))) 0)
  :verify-guards :after-returns
  :returns (ret symbolp :hyp (symbolp x))
  (if (member-eq x avoid-vars)
      (my-genvar-aux (intern-in-package-of-symbol (concatenate 'string (symbol-name x) "'") 'my-genvar)
                     avoid-vars)
    x)
  ///
  (defret not-member-equal-avoid-vars-<fn>
          (not (member-equal ret avoid-vars))))

(define my-genvar ((x symbolp)
                   (avoid-vars symbol-listp))
  :returns (ret symbolp :hyp (symbolp x))
  (my-genvar-aux x (cons t (cons nil avoid-vars)))
  ///
  (defret not-member-equal-avoid-vars-<fn>
          (not (member-equal ret avoid-vars))
          :hints (("Goal" :do-not-induct t
                          :in-theory (e/d () (acl2::subsetp-member))
                          :use ((:instance acl2::subsetp-member
                                 (a (my-genvar x avoid-vars))
                                 (x avoid-vars)
                                 (y (cons t (cons nil avoid-vars))))))))
  (defret not-t-nil-<fn>
          (and (not (equal ret t))
               (not (equal ret nil)))
          :hints (("Goal" :in-theory (e/d () (acl2::subsetp-member))
                          :use ((:instance acl2::subsetp-member
                                 (a (my-genvar x avoid-vars))
                                 (x (list t))
                                 (y (cons t (cons nil avoid-vars))))
                                (:instance acl2::subsetp-member
                                 (a (my-genvar x avoid-vars))
                                 (x (list nil))
                                 (y (cons t (cons nil avoid-vars)))))))))

;; (define symbol-width (x)
;;   :returns (ret booleanp)
;;   (and (consp x)
;;        (symbolp (car x))
;;        (consp (cdr x))
;;        (symbolp (cadr x))))

;; (define symbol-width-alistp (f)
;;    :returns (ret booleanp)
;;    (if (consp f)
;;        (and (symbol-width (car f))
;;             (symbol-width-alistp (cdr f)))
;;      (eq f nil)))

;; (local-defthm symbol-width-alistp-of-cons
;;   (equal (symbol-width-alistp (cons x y))
;;          (and (symbol-width-alistp y)
;;               (symbol-width x)))
;;   :hints (("Goal" :in-theory (e/d (symbol-width-alistp) ()))))

;; (local-defthm symbol-width-alistp-cadr-assoc
;;   (implies (and (symbol-width-alistp x)
;;                 (assoc y x))
;;            (symbolp (cadr (assoc y x))))
;;   :hints (("Goal" :in-theory (e/d (symbol-width-alistp
;;                                    symbol-width) ()))))

(local-defthm symbolp-implies-pseudo-termp
  (implies (symbolp x) (pseudo-termp x)))

(local (in-theory (disable len pseudo-termp pseudo-term-listp)))

;; (local-defthm pseudo-termp-of-cons
;;   (implies (and (not (consp x))
;;                 (not (equal x 'quote))
;;                 (symbolp x)
;;                 (pseudo-term-listp y))
;;            (pseudo-termp (cons x y)))
;;   :hints (("Goal" :in-theory (e/d (pseudo-termp) ()))))

;; (local-defthm pseudo-termp-of-lambda
;;   (implies (and (pseudo-termp x)
;;                 (acl2::flambda-applicationp x))
;;            (pseudo-termp (caddr (car x))))
;;   :hints (("Goal" :in-theory (e/d (pseudo-termp) ()))))

(defevaluator rev rev-lst
              ((typespec-check ts x)
               (if a b c)
               (equal a b)
               (not a)
               (iff a b)
               (implies a b)
               (bits x i j)
               (bvecp x j)
               (bitp x)
               (bitn x i)
               (acl2::loghead$inline i x))
              :namedp t)

(acl2::def-meta-extract rev rev-lst)

;; (local
;;  (define interp-sw ((x symbol-width))
;;    :guard-hints (("Goal" :in-theory (e/d (symbol-width) ())))
;;    (cons (cadr x) `(acl2::loghead$inline ,(cddr x) (,(car x))))))

;; (local
;;  (define interp-swa ((f symbol-width-alistp))
;;    (if (consp f)
;;        (cons (interp-sw (car f))
;;              (interp-swa (cdr f)))
;;      nil)))

(local
 (defthm rev-formula
   (implies (and (rev-meta-extract-global-facts)
                 (equal (w st) (w state)))
            (rev (meta-extract-formula name st) a))
   :hints(("Goal" :use ((:instance rev-meta-extract-global-badguy-sufficient
                         (obj (list :formula name))))))))

(local
 (defthm rev-fn-get-def
   (b* (((mv ok formals body) (acl2::fn-get-def fn st)))
     (implies (and ok
                   (rev-meta-extract-global-facts)
                   (equal (w st) (w state))
                   (equal (len args) (len formals)))
              (equal (rev (cons fn args) a)
                     (rev body (pairlis$ formals
                                         (rev-lst args a))))))
   :hints(("Goal" :in-theory (e/d (rev-of-fncall-args
                                   acl2::match-tree-opener-theory
                                   acl2::match-tree-alist-opener-theory)
                                  (rev-formula
                                   meta-extract-global-fact+
                                   meta-extract-formula
                                   take))
                  :use ((:instance rev-formula
                         (name fn)
                         (st st)
                         (a (pairlis$ (mv-nth 1 (acl2::fn-get-def fn st))
                                      (rev-lst args a)))))))))

;; (define gify-term-bvecp ((x (and (pseudo-termp x)
;;                                  (consp x)
;;                                  (not (quotep x))
;;                                  (not (acl2::flambda-applicationp x))
;;                                  (not (cdr x))))
;;                          (avoid-vars symbol-listp)
;;                          state)
;;   :verify-guards nil
;;   :returns (mv (okp-term booleanp)
;;                (gen-term pseudo-termp :hyp (pseudo-termp x))
;;                (n-subst (implies n-subst
;;                                  (symbol-width n-subst))
;;                         :hyp (pseudo-termp x)
;;                         :hints (("Goal" :in-theory (e/d (symbol-width) ()))))
;;                (avoid-vars-res symbol-listp :hyp (symbol-listp avoid-vars)))
;;   (if (mbt (and (consp x)
;;                 (not (quotep x))
;;                 (not (cdr x))))
;;       (b* (((unless (mbt (symbolp (car x))))
;;             (mv t x nil avoid-vars))
;;            (bvecp-thm (table-alist 'known-bvecps (w state)))
;;            ((unless (or (alistp bvecp-thm)
;;                         (cw "known-bvecps is not an alist")))
;;             (mv t x nil avoid-vars))
;;            (bvecp-thm (assoc (car x) bvecp-thm))
;;            ((unless (and (or bvecp-thm (cw "Warning: constant function with unknown width: ~x0~%" (car x)))
;;                          (or (symbolp (cdr bvecp-thm)) (cw "Theorem name not a symol!"))))
;;             (mv t x nil avoid-vars))
;;            (bvecp-thm (cdr bvecp-thm))
;;            ((unless (or bvecp-thm
;;                         (cw "Warning: constant function with unknown width: ~x0~%" (car x))))
;;             (mv t x nil avoid-vars))
;;            (bvecp-thm (meta-extract-formula bvecp-thm state))
;;            ((unless (and (pseudo-termp bvecp-thm)
;;                          (or (and (= (len bvecp-thm) 3)
;;                                   (quotep (caddr bvecp-thm))
;;                                   (consp (cdr (caddr bvecp-thm)))
;;                                   (natp (unquote (caddr bvecp-thm)))
;;                                   (equal (cadr bvecp-thm) x)
;;                                   (equal (car bvecp-thm) 'bvecp))
;;                              (and (= (len bvecp-thm) 2)
;;                                   (equal (cadr bvecp-thm) x)
;;                                   (equal (car bvecp-thm) 'bitp)))))
;;             (prog2$ (cw "Bad bvecp-form: ~x0~%" bvecp-thm)
;;                     (mv t x nil avoid-vars)))
;;            (width (if (eq (car bvecp-thm) 'bitp)
;;                       (kwote 1)
;;                     (caddr bvecp-thm)))
;;            (new-var (my-genvar (car x) avoid-vars))
;;            (avoid-vars (cons new-var avoid-vars))
;;            (new-subst (cons (car x) (cons new-var width))))
;;         (mv t new-var new-subst avoid-vars))
;;     (mv nil nil nil nil)))

;; (local-defthm gify-term-bvecp-lemma
;;   (b* (((mv okp gen-term nsw avoid-vars-new)
;;         (gify-term-bvecp x avoid-vars state)))
;;     (implies (and okp
;;                   (pseudo-termp x)
;;                   (consp x)
;;                   (not (quotep x))
;;                   (not (acl2::flambda-applicationp x))
;;                   (not (cdr x)))
;;              (implies nsw
;;                       (and (symbolp gen-term)
;;                            (not (eq gen-term nil))
;;                            (not (member gen-term avoid-vars))
;;                            (member gen-term avoid-vars-new)
;;                            (implies (rev-meta-extract-global-facts)
;;                                     (equal (rev (cdr (interp-sw nsw)) a)
;;                                            (rev x a)))))))
;;   :hints (("Goal" :in-theory (e/d (gify-term-bvecp
;;                                    interp-sw
;;                                    len)
;;                                   (rev-formula
;;                                    meta-extract-global-fact+
;;                                    meta-extract-formula
;;                                    REV-META-EXTRACT-FORMULA
;;                                    bitp))
;;                   :use ((:instance rev-formula
;;                          (name (cdr (assoc (car x) (table-alist 'known-bvecps (w state)))))
;;                          (st state))))))

(define symbol-symbol-alistp (x)
  :enabled t
  (if (atom x)
      (eq x nil)
    (and (consp (car x))
         (symbolp (caar x))
         (symbolp (cdar x))
         (symbol-symbol-alistp (cdr x)))))

;; (define modify-vars ((x symbol-listp)
;;                      (avoid-vars symbol-listp))
;;   :returns (ret symbol-symbol-alistp :hyp (symbol-listp x))
;;   (if (consp x)
;;       (b* ((new-var (my-genvar (car x) avoid-vars)))
;;       (cons (cons new-var (car x))
;;             (modify-vars (cdr x) (cons new-var avoid-vars))))
;;     nil))

;; (local-defthm symbol-symbol-alistp-union-equal
;;   (implies (and (symbol-symbol-alistp x)
;;                 (symbol-symbol-alistp y))
;;            (symbol-symbol-alistp (union-equal x y))))

;; (local-defthm symbol-listp-strip-cdrs-symbol-symbol-alistp
;;   (implies (symbol-symbol-alistp x)
;;            (symbol-listp (strip-cdrs x))))

;; (local-defthm symbol-listp-strip-cars-symbol-symbol-alistp
;;   (implies (symbol-symbol-alistp x)
;;            (symbol-listp (strip-cars x))))

;; (local (in-theory (enable pseudo-termp pseudo-term-listp len)))

;; (local-defthm pseudo-term-listp-append
;;   (implies (and (pseudo-term-listp x)
;;                 (pseudo-term-listp y))
;;            (pseudo-term-listp (append x y)))
;;   :hints (("Goal" :in-theory (e/d () ()))))

(local-defthm pseudo-term-listp-symbol-listp
  (implies (symbol-listp x)
           (pseudo-term-listp x)))

(local-defthm symbol-listp-append
  (implies (and (symbol-listp x)
                (symbol-listp y))
           (symbol-listp (append x y)))
  :hints (("Goal" :in-theory (e/d () ()))))

;; (local-defthm len-strip-cars
;;   (equal (len (strip-cars x))
;;          (len x)))

;; (local-defthm len-strip-cdrs
;;   (equal (len (strip-cdrs x))
;;          (len x)))

;; (local-defthm len-modify-vars
;;   (equal (len (modify-vars x y))
;;          (len x))
;;   :hints (("Goal" :in-theory (e/d (modify-vars) ()))))


(local-defthm symbolp-cdr-assoc-symbol-symbol-alistp
  (implies (and (symbol-symbol-alistp x)
                (assoc-equal y x))
           (symbolp (cdr (assoc-equal y x)))))

(define unify-subst ((f1 symbol-symbol-alistp)
                     (f2 symbol-symbol-alistp)
                     (avoid-vars symbol-listp))
  :returns (mv (f symbol-listp :hyp (and (symbol-symbol-alistp f1)
                                         (symbol-symbol-alistp f2)))
               (a symbol-listp :hyp (and (symbol-symbol-alistp f1)
                                         (symbol-symbol-alistp f2)))
               (s symbol-symbol-alistp :hyp (and (symbol-symbol-alistp f1)
                                                 (symbol-symbol-alistp f2))))
  (if (atom f1)
      (mv nil nil f2)
    (b* ((fst (car f1))
         (fn (car fst))
         (sym (cdr fst))
         (p (assoc-eq fn f2)))
      (if p
          (b* (((mv frest arest srest)
                (unify-subst (cdr f1) f2 avoid-vars)))
            (mv (cons sym frest)
                (cons (cdr p) arest)
                srest))
        (b* ((new-var (my-genvar fn (append (strip-cdrs f2) avoid-vars)))
             ((mv frest arest srest)
              (unify-subst (cdr f1) (cons (cons fn new-var) f2) avoid-vars)))
          (mv (cons sym frest)
              (cons new-var arest)
              srest))))))

(local-defthm len-mv-nth-0-1-unify-subst
  (equal (len (mv-nth 0 (unify-subst x y avoid-vars)))
         (len (mv-nth 1 (unify-subst x y avoid-vars))))
  :hints (("Goal" :in-theory (e/d (unify-subst
                                   len) ()))))

(define symbol-list-fix ((k symbol-listp))
  (mbe :logic (if (consp k)
                  (cons (if (symbolp (car k))
                            (car k)
                          nil)
                        (symbol-list-fix (cdr k)))
                nil)
       :exec k)
  ///
  (defthm symbol-list-fix-is-involutive
    (equal (symbol-list-fix (symbol-list-fix x))
           (symbol-list-fix x)))
  (defthm symbol-list-fix-is-okay
    (implies (symbol-listp x)
             (equal (symbol-list-fix x) x))))

(fty::deffixtype symbol-list
                 :pred symbol-listp
                 :fix symbol-list-fix
                 :equiv symbol-list-equiv
                 :define t
                 :forward t)

(define symbol-symbol-alist-fix ((k symbol-symbol-alistp))
  (mbe :logic (if (alistp k)
                  (pairlis$ (strip-cars k) (strip-cdrs k))
                nil)
       :exec k)
  ///
  (defthm symbol-symbol-alist-fix-is-involutive
    (equal (symbol-symbol-alist-fix (symbol-symbol-alist-fix x))
           (symbol-symbol-alist-fix x)))
  (defthm symbol-symbol-alist-fix-is-okay
    (implies (symbol-symbol-alistp x)
             (equal (symbol-symbol-alist-fix x) x))))

(fty::deffixtype symbol-symbol-alist
                 :pred symbol-symbol-alistp
                 :fix symbol-symbol-alist-fix
                 :equiv symbol-symbol-alist-equiv
                 :define t
                 :forward t)

(define apply-map ((s symbol-symbol-alistp)
                   (k symbol-listp))
  :returns (ret symbol-listp)
  (mbe :logic
       (if (consp k)
           (b* ((p (assoc-eq (car k) s)))
             (cons (if p (if (symbolp (cdr p))
                             (cdr p) nil)
                     (if (symbolp (car k)) (car k) nil))
                   (apply-map s (cdr k))))
         nil)
       :exec
       (if (consp k)
           (b* ((p (assoc-eq (car k) s)))
             (cons (if p (cdr p) (car k))
                   (apply-map s (cdr k))))
         nil))
  ///
  (defthm len-apply-map
    (equal (len (apply-map s k))
           (len k))
    :hints (("Goal" :in-theory (e/d (len) ())))))

(local-defthm symbol-symbol-alistp-pairlis$
  (implies (and (symbol-listp x)
                (symbol-listp y)
                (= (len x) (len y)))
           (symbol-symbol-alistp (pairlis$ x y)))
  :hints (("Goal" :in-theory (e/d (len) ()))))

(local-defthm true-listp-of-union-equal
  (implies (true-listp y)
           (true-listp (union-equal x y))))

(defines free-vars
  :verify-guards :after-returns
  :flag-local nil
  (define free-vars ((term pseudo-termp))
    :returns (ret symbol-listp :hyp :guard
                  )
    (cond ((acl2::variablep term)
           (list term))
          ((quotep term) nil)
          (t (free-vars-lst (acl2::fargs term)))))
  (define free-vars-lst ((term-lst pseudo-term-listp))
    :returns (ret symbol-listp :hyp :guard)
    (cond ((endp term-lst) nil)
          (t (union-eq (free-vars-lst (cdr term-lst))
                       (free-vars (car term-lst))))))
  :returns-hints (("Goal" :in-theory (e/d (pseudo-termp) ())))
  ///
  (defthm-free-vars-flag
    (defthm true-listp-of-free-vars
      (true-listp (free-vars term))
      :flag free-vars)
    (defthm true-listp-of-free-vars-lst
      (true-listp (free-vars-lst term-lst))
      :flag free-vars-lst)))

(local
 (acl2::make-flag all-vars1))

(local-defthm union-equal-right-assoc
  (equal (union-equal (union-equal x y) z)
         (union-equal x (union-equal y z)))
  :hints (("Goal" :in-theory (e/d () ()))))

(local
 (acl2::defthm-flag-all-vars1
  (defthm all-vars-eq-free-vars
    (equal (all-vars1 acl2::term acl2::ans)
           (union-equal (free-vars acl2::term) acl2::ans))
    :flag all-vars1)
  (defthm all-vars-lst-eq-free-vars-lst
    (equal (all-vars1-lst acl2::lst acl2::ans)
           (union-equal (free-vars-lst acl2::lst) acl2::ans))
    :flag all-vars1-lst)
  :hints (("Goal" :in-theory (e/d (free-vars free-vars-lst) ())))))

(local-defthm union-equal-nil
  (implies (true-listp x)
           (equal (union-equal x nil) x)))

(defines gify-term
  :verify-guards nil
  :flag-local nil
  (define gify-term-lambda ((x (and (pseudo-termp x)
                                    (consp x)
                                    (not (quotep x))
                                    (acl2::flambda-applicationp x)))
                            (expand-fns symbol-listp)
                            (avoid-vars symbol-listp)
                            state)
    :measure (make-ord 2 (1+ (len expand-fns)) (make-ord 1 (1+ (acl2-count x)) 0))
    :returns (mv okp gen-term f-subst-res)
    (if (mbt (and (acl2::flambda-applicationp x)
                  (equal (len (car x)) 3)
                  (eq (caar x) 'lambda)
                  (symbol-listp (cadr (car x)))
                  (pseudo-termp (caddr (car x)))
                  (pseudo-term-listp (cdr x))
                  (equal (len (cadr (car x)))
                         (len (cdr x)))))
        (b* (((mv okp gen-args f-subst-args)
              (gify-term-lst (acl2::fargs x) expand-fns avoid-vars state))
             ((unless okp) (mv nil nil nil))
             (lambda-form (acl2::ffn-symb x))
             (body (acl2::lambda-body lambda-form))
             (formals (acl2::lambda-formals lambda-form))
             ((unless (subsetp-eq (all-vars body) formals))
              (mv nil nil nil))
             ((mv okp gen-term-body f-subst-body)
              (gify-term body expand-fns formals state))
             ((unless okp) (mv nil nil nil))
             ((mv nf na ns) (unify-subst f-subst-body f-subst-args avoid-vars))
             (lambda-form `(lambda ,(append nf formals) ,gen-term-body))
             (lambda-args (append na gen-args))
             (gen-term `(,lambda-form ,@lambda-args)))
          (mv okp gen-term ns))
      (mv nil nil nil)))
  (define gify-term-expand ((x (and (pseudo-termp x)
                                    (consp x)
                                    (not (quotep x))
                                    (not (acl2::flambda-applicationp x))
                                    (member-eq (car x) expand-fns)))
                            (expand-fns symbol-listp)
                            (avoid-vars symbol-listp)
                            state)
    :measure (make-ord 2 (1+ (len expand-fns)) (make-ord 1 (1+ (acl2-count x)) 0))
    :returns (mv okp gen-term f-subst-res)
    (mbe :logic (if (and (consp x)
                         (not (quotep x))
                         (not (acl2::flambda-applicationp x))
                         (member-eq (car x) expand-fns))
                    (b* (((mv okp-def formals body) (acl2::fn-get-def (car x) state))
                         ((unless (and okp-def
                                       (symbol-listp formals)
                                       (true-listp formals)
                                       (equal (len formals)
                                              (len (acl2::fargs x)))
                                       (pseudo-termp body)
                                       (subsetp-eq (all-vars body) formals)))
                          (mv nil nil nil))
                         ((mv okp gen-args f-subst-args)
                          (gify-term-lst (acl2::fargs x) expand-fns avoid-vars state))
                         ((unless okp) (mv nil nil nil))
                         (body (pseudo-term-fix body))
                         (formals (acl2::symbol-list-fix formals))
                         (expand-fns (remove1 (car x) expand-fns))
                         ((mv okp gen-term-body f-subst-body)
                          (gify-term body expand-fns formals state))
                         ((unless okp) (mv nil nil nil))
                         ((mv nf na ns)
                          (unify-subst f-subst-body f-subst-args avoid-vars))
                         (lambda-form `(lambda ,(append nf formals) ,gen-term-body))
                         (lambda-args (append na gen-args))
                         (gen-term `(,lambda-form ,@lambda-args)))
                      (mv t gen-term ns))
                  (mv nil nil nil))
         :exec
         (b* (((mv okp-def formals body) (acl2::fn-get-def (car x) state))
              ((unless (and okp-def
                            (symbol-listp formals)
                            (equal (len formals)
                                   (len (acl2::fargs x)))
                            (pseudo-termp body)
                            (subsetp-eq (all-vars body) formals)))
               (mv nil nil nil))
              ((mv okp gen-args f-subst-args)
               (gify-term-lst (acl2::fargs x) expand-fns avoid-vars state))
              ((unless okp) (mv nil nil nil))
              (body (pseudo-term-fix body))
              (formals (acl2::symbol-list-fix formals))
              (expand-fns (remove1 (car x) expand-fns))
              ((mv okp gen-term-body f-subst-body)
               (gify-term body expand-fns formals state))
              ((unless okp) (mv nil nil nil))
              ((mv nf na ns)
               (unify-subst f-subst-body f-subst-args avoid-vars))
              (lambda-form `(lambda ,(append nf formals) ,gen-term-body))
              (lambda-args (append na gen-args))
              (gen-term `(,lambda-form ,@lambda-args)))
           (mv t gen-term ns))))
  (define gify-term ((x pseudo-termp)
                     (expand-fns symbol-listp)
                     (avoid-vars symbol-listp)
                     state)
    :measure (make-ord 2 (1+ (len expand-fns)) (make-ord 1 (1+ (acl2-count x)) 1))
    :returns (mv okp gen-term f-subst-res)
    (cond ((atom x)
           (if (and x (mbt (symbolp x)))
               (mv t x nil)
             (mv nil nil nil)))
          ((quotep x)
           (mv t x nil))
          ((acl2::flambda-applicationp x)
           (gify-term-lambda x expand-fns avoid-vars state))
          ((or ; (cw "FN: ~x0~%" (car x))
            (member-eq (car x) expand-fns))
           (gify-term-expand x expand-fns avoid-vars state))
          ((not (cdr x))
           (b* (((unless (mbt (symbolp (car x))))
                 (mv t x nil))
                (known-bvecps (table-alist 'known-bvecps (w state)))
                ((unless (or (alistp known-bvecps)
                             (cw "Known-bvecps is not an alist~%")))
                 (mv t x nil))
                ((unless (or (assoc-eq (car x) known-bvecps)
                             ;(cw "Unknown width for const-fn: ~x0~%" (car x))
                             ))
                 (mv t x nil))
                (new-var (my-genvar (car x) avoid-vars)))
             (mv t new-var (cons (cons (car x) new-var) nil))))
          (t
           (if (mbt (symbolp (car x)))
               (b* (((mv okp gen-args f-subst)
                     (gify-term-lst (acl2::fargs x) expand-fns avoid-vars state)))
                 (mv okp (cons (car x) gen-args) f-subst))
             (mv nil nil nil)))))
  (define gify-term-lst  ((lst pseudo-term-listp)
                          (expand-fns symbol-listp)
                          (avoid-vars symbol-listp)
                          state)
    :measure (make-ord 2 (1+ (len expand-fns)) (make-ord 1 (1+ (acl2-count lst)) 1))
    :returns (mv okp gen-term f-subst-res)
    (if (consp lst)
        (b* (((mv okp term f-subst)
              (gify-term (car lst) expand-fns avoid-vars state))
             ((unless okp) (mv nil nil nil))
             ((mv okp term-lst f-subst-lst)
              (gify-term-lst (cdr lst) expand-fns avoid-vars state))
             ((unless okp) (mv nil nil nil))
             ((mv nf na ns) (unify-subst f-subst f-subst-lst avoid-vars)))
          (if (equal na nf)
              (mv t (cons term term-lst) ns)
            (b* ((free (all-vars term)))
              (mv t (cons `((lambda ,free ,term) ,@(apply-map (pairlis$ nf na) free)) term-lst) ns))))
      (mv t nil nil)))
  ///
  (defthm len-of-gify-term-lst
    (implies (mv-nth 0 (gify-term-lst lst expand-fns avoid-vars state))
             (equal (len (mv-nth 1 (gify-term-lst lst expand-fns avoid-vars state)))
                    (len lst)))
    :hints (("Goal" :in-theory (e/d (len) ()))))
  (std::defret-mutual gify-term
                      (defret booleanp-okp-gify-term-lambda
                              (booleanp okp)
                              :fn gify-term-lambda)
                      (defret booleanp-okp-gify-term-expand
                              (booleanp okp)
                              :fn gify-term-expand)
                      (defret booleanp-okp-gify-term-lst
                              (booleanp okp)
                              :fn gify-term-lst)
                      (defret booleanp-okp-gify-term
                              (booleanp okp)
                              :fn gify-term)
                      :hints (("Goal" :in-theory (e/d () ()))))
  (std::defret-mutual gify-term
                      (defret symbol-symbol-alistp-f-subst-gify-term-lambda
                              (implies (pseudo-termp x)
                                       (symbol-symbol-alistp f-subst-res))
                              :fn gify-term-lambda)
                      (defret symbol-symbol-alistp-f-subst-gify-term-expand
                              (implies (pseudo-termp x)
                                       (symbol-symbol-alistp f-subst-res))
                              :fn gify-term-expand)
                      (defret symbol-symbol-alistp-f-subst-gify-term
                              (implies (pseudo-termp x)
                                       (symbol-symbol-alistp f-subst-res))
                              :fn gify-term)
                      (defret symbol-symbol-alistp-f-subst-gify-term-lst
                              (implies (pseudo-term-listp lst)
                                       (symbol-symbol-alistp f-subst-res))
                              :fn gify-term-lst)
                      :hints (("Goal" :in-theory (e/d () ()))))
  (std::defret-mutual gify-term
                      (defret pseudo-termp-gen-term-gify-term-lambda
                              (implies (pseudo-termp x)
                                       (pseudo-termp gen-term))
                              :fn gify-term-lambda)
                      (defret pseudo-termp-gen-term-gify-term-expand
                              (implies (pseudo-termp x)
                                       (pseudo-termp gen-term))
                              :fn gify-term-expand)
                      (defret pseudo-termp-gen-term-gify-term
                              (implies (pseudo-termp x)
                                       (pseudo-termp gen-term))
                              :fn gify-term)
                      (defret pseudo-termp-gen-term-gify-term-lst
                              (implies (pseudo-term-listp lst)
                                       (pseudo-term-listp gen-term))
                              :fn gify-term-lst)
                      :hints (("Goal" :in-theory (e/d (pseudo-termp
                                                       pseudo-term-listp
                                                       len) ())))))

(local-defthm symbol-listp-implies-true-listp
  (implies (symbol-listp x)
           (true-listp x)))

(verify-guards gify-term
  :hints (("Goal" :do-not-induct t
                  :in-theory (e/d (pseudo-term-listp
                                   pseudo-termp) ()))))

(define interp-subst ((f symbol-symbol-alistp))
  :returns (ret symbol-alistp :hyp :guard)
  (if (consp f)
      (cons `(,(cdar f) . (,(caar f)))
            (interp-subst (cdr f)))
    nil))

(acl2::make-flag pseudo-termp
                 :defthm-macro-name defthm-pseudo-termp)

(define rev-ctx ((ctx symbol-alistp)
                 (al alistp))
  (if (consp ctx)
      (cons (cons (caar ctx) (rev (cdar ctx) al))
            (rev-ctx (cdr ctx) al))
    nil))

(local-defthm strip-cars-pairlis$
  (implies (true-listp x)
           (equal (strip-cars (pairlis$ x y))
                  x)))

(local-defthm pairlis$-rev-lst-to-rev-ctx
  (implies (true-listp x)
           (equal (pairlis$ x (rev-lst (apply-map s x) a))
                  (rev-ctx (pairlis$ x (apply-map s x)) a)))
  :hints (("Goal" :in-theory (e/d (rev-ctx
                                   apply-map) ()))))

;; (local-defthm cdr-assoc-rev-ctx
;;   (implies (and (member x vars)
;;                 (symbolp x)
;;                 (symbol-symbol-alistp s))
;;            (equal (cdr (assoc-equal x (rev-ctx (pairlis$ vars (apply-map s vars)) a)))
;;                   (if (assoc-equal x s)
;;                       (rev (cdr (assoc-equal x s)) a)
;;                     (rev x a))))
;;   :hints (("Goal" :in-theory (e/d (rev-ctx
;;                                    apply-map)
;;                                   (PAIRLIS$-REV-LST-TO-REV-CTX)))))

(local-defthm intersection-equal-cons-1
  (implies (true-listp a)
           (iff (intersection-equal a (cons x y))
                (or (member-equal x a)
                    (intersection-equal a y))))
  :hints (("Goal" :in-theory (e/d (intersection-equal) ()))))

(local-defthm not-member-my-genvar-append
  (and (not (member-equal (my-genvar x (append z y)) y))
       (not (member-equal (my-genvar x (append z y)) z)))
  :hints (("Goal" :in-theory (e/d () (not-member-equal-avoid-vars-my-genvar))
                  :do-not-induct t
                  :use ((:instance not-member-equal-avoid-vars-my-genvar
                         (x x)
                         (avoid-vars (append z y)))))))


(local-defthm alistp-rev-ctx
  (alistp (rev-ctx ctx al))
  :hints (("Goal" :in-theory (e/d (rev-ctx) ()))))

(local-defthm assoc-alistp-append
  (implies (alistp x)
           (equal (Assoc a (append x y))
                  (or (assoc a x)
                      (assoc a y)))))

(local-defthm assoc-equal-rev-ctx
  (implies (alistp s)
           (equal (assoc-equal x (rev-ctx s a))
         (if (assoc-equal x s)
             (cons x (rev (cdr (assoc-equal x s)) a))
           nil)))
  :hints (("Goal" :in-theory (e/d (rev-ctx) ()))))

(local-defthm assoc-interp-subst
  (implies (member-equal x (strip-cdrs f))
           (equal (assoc-equal x (interp-subst f))
                  (cons x (list (cdr (assoc-equal x (pairlis$ (strip-cdrs f)
                                                      (strip-cars f))))))))
  :hints (("Goal" :in-theory (e/d (interp-subst) ()))))

(local-defthm cdr-assoc-interp-subst-unify-subst
  (implies (member x (strip-cdrs f2))
           (equal (assoc-equal x (interp-subst (mv-nth 2 (unify-subst f1 f2 avoid-vars))))
                  (cons x (list (cdr (assoc-equal x (pairlis$ (strip-cdrs f2) (strip-cars f2))))))))
  :hints (("Goal" :in-theory (e/d (unify-subst
                                   interp-subst) (not-member-equal-avoid-vars-my-genvar)))
          ("Subgoal *1/5"
                  :use ((:instance not-member-equal-avoid-vars-my-genvar
                         (x (caar f1))
                         (avoid-vars (append (Strip-cdrs f2) avoid-vars)))))
          ("Subgoal *1/4"
                  :use ((:instance not-member-equal-avoid-vars-my-genvar
                         (x (caar f1))
                         (avoid-vars (append (Strip-cdrs f2) avoid-vars)))))))

(local-defthm alistp-interp-subst
  (alistp (interp-subst x))
  :hints (("Goal" :in-theory (e/d (interp-subst) ()))))

(local-defthm not-cdr-assoc-when-non-nil-member
  (implies (and (alistp s)
                (not (member-equal nil (strip-cdrs s)))
                (assoc-equal x s))
           (cdr (assoc-equal x s))))

(local-defthm symbol-symbol-alistp-alistp
  (implies (symbol-symbol-alistp x)
           (alistp x)))

(local-defthm member-cdr-if-assoc-eq
  (implies (assoc-equal x y)
           (member-equal (cdr (assoc-equal x y)) (strip-cdrs y))))

(local-defthm assoc-of-pairlis-when-not-member
  (implies (not (member-equal x y))
           (not (assoc-equal x (pairlis$ y z)))))

(local-defthm assoc-assoc-pairlis-inverse
  (implies (and (assoc-equal x y)
                (no-duplicatesp-equal (strip-cdrs y))
                (no-duplicatesp-equal (strip-cars y)))
           (equal (cdr (assoc-equal (cdr (assoc-equal x y))
                                    (pairlis$ (strip-cdrs y)
                                              (strip-cars y))))
                  x))
  :hints (("Goal" :induct (assoc-equal x y))))

(local-defthm member-equal-assoc-equal-strip-cars
  (implies (and (member-equal x (Strip-cars y))
                (alistp y))
           (assoc-equal x y)))

(local-defthm no-duplicatesp-equal-strip-cars-unify
  (implies (and (no-duplicatesp-equal (strip-cars f2))
                (alistp f2))
           (no-duplicatesp-equal (strip-cars (mv-nth 2 (unify-subst f1 f2 avoid-vars)))))
  :hints (("Goal" :in-theory (e/d (unify-subst) ()))))

(local-defthm no-duplicatesp-equal-strip-cdrs-unify
  (implies (and (no-duplicatesp-equal (strip-cdrs f2))
                (alistp f2))
           (no-duplicatesp-equal (strip-cdrs (mv-nth 2 (unify-subst f1 f2 avoid-vars)))))
  :hints (("Goal" :in-theory (e/d (unify-subst) (not-member-equal-avoid-vars-my-genvar)))
          ("Subgoal *1/3"
           :use ((:instance not-member-equal-avoid-vars-my-genvar
                  (x (caar f1))
                  (avoid-vars (append (Strip-cdrs f2) avoid-vars)))))))

(defthm-gify-term-flag
  (defthm no-duplicatesp-strip-cars-lambda
    (b* (((mv ?okp ?gen-term f)
          (gify-term-lambda x expand-fns avoid-vars state)))
      (implies (pseudo-termp x)
               (no-duplicatesp-equal (strip-cars f))))
    :flag gify-term-lambda)
  (defthm no-duplicatesp-strip-cars-expand
    (b* (((mv ?okp ?gen-term f)
          (gify-term-expand x expand-fns avoid-vars state)))
      (implies (pseudo-termp x)
               (no-duplicatesp-equal (strip-cars f))))
    :flag gify-term-expand)
  (defthm no-duplicatesp-strip-cars
    (b* (((mv ?okp ?gen-term f)
          (gify-term x expand-fns avoid-vars state)))
      (implies (pseudo-termp x)
               (no-duplicatesp-equal (strip-cars f))))
    :flag gify-term)
  (defthm no-duplicatesp-strip-cars-lst
    (b* (((mv ?okp ?gen-term f)
          (gify-term-lst lst expand-fns avoid-vars state)))
      (implies (pseudo-term-listp lst)
               (no-duplicatesp-equal (strip-cars f))))
    :flag gify-term-lst)
  :hints (("Goal" :in-theory (e/d (gify-term-lst
                                   gify-term
                                   gify-term-expand
                                   gify-term-lambda) ()))))

(defthm-gify-term-flag
  (defthm no-duplicatesp-strip-cdrs-lambda
    (b* (((mv ?okp ?gen-term f)
          (gify-term-lambda x expand-fns avoid-vars state)))
      (implies (pseudo-termp x)
               (no-duplicatesp-equal (strip-cdrs f))))
    :flag gify-term-lambda)
  (defthm no-duplicatesp-strip-cdrs-expand
    (b* (((mv ?okp ?gen-term f)
          (gify-term-expand x expand-fns avoid-vars state)))
      (implies (pseudo-termp x)
               (no-duplicatesp-equal (strip-cdrs f))))
    :flag gify-term-expand)
  (defthm no-duplicatesp-strip-cdrs
    (b* (((mv ?okp ?gen-term f)
          (gify-term x expand-fns avoid-vars state)))
      (implies (pseudo-termp x)
               (no-duplicatesp-equal (strip-cdrs f))))
    :flag gify-term)
  (defthm no-duplicatesp-strip-cdrs-lst
    (b* (((mv ?okp ?gen-term f)
          (gify-term-lst lst expand-fns avoid-vars state)))
      (implies (pseudo-term-listp lst)
               (no-duplicatesp-equal (strip-cdrs f))))
    :flag gify-term-lst)
  :hints (("Goal" :in-theory (e/d (gify-term-lst
                                   gify-term
                                   gify-term-expand
                                   gify-term-lambda) ()))))

(local-defthm not-intersectionp-nil
  (not (intersection-equal x nil))
  :hints (("Goal" :in-theory (e/d (intersection-equal) ()))))

(local-defthm not-intersection-equal-union
  (implies (and (not (intersection-equal avoid-vars (strip-cdrs f2)))
                (symbol-listp avoid-vars))
           (not (intersection-equal avoid-vars (strip-cdrs (mv-nth 2 (unify-subst f1 f2 avoid-vars))))))
  :hints (("Goal" :in-theory (e/d (unify-subst
                                   intersection-equal)
                                  ()))))


(defthm-gify-term-flag
  (defthm not-intersectionp-strip-cdrs-lambda
    (b* (((mv ?okp ?gen-term f)
          (gify-term-lambda x expand-fns avoid-vars state)))
      (implies (and (pseudo-termp x)
                    (symbol-listp avoid-vars))
               (not (intersection-equal avoid-vars (strip-cdrs f)))))
    :flag gify-term-lambda)
  (defthm not-intersectionp-strip-cdrs-expand
    (b* (((mv ?okp ?gen-term f)
          (gify-term-expand x expand-fns avoid-vars state)))
      (implies (and (pseudo-termp x)
                    (symbol-listp avoid-vars))
               (not (intersection-equal avoid-vars (strip-cdrs f)))))
    :flag gify-term-expand)
  (defthm not-intersectionp-strip-cdrs
    (b* (((mv ?okp ?gen-term f)
          (gify-term x expand-fns avoid-vars state)))
      (implies (and (pseudo-termp x)
                    (symbol-listp avoid-vars))
               (not (intersection-equal avoid-vars (strip-cdrs f)))))
    :flag gify-term)
  (defthm not-intersectionp-strip-cdrs-lst
    (b* (((mv ?okp ?gen-term f)
          (gify-term-lst lst expand-fns avoid-vars state)))
      (implies (and (pseudo-term-listp lst)
                    (symbol-listp avoid-vars))
               (not (intersection-equal avoid-vars (strip-cdrs f)))))
    :flag gify-term-lst)
  :hints (("Goal" :in-theory (e/d (gify-term-lst
                                   gify-term
                                   gify-term-expand
                                   gify-term-lambda) ()))))

(local-defthm not-member-nil-unify-subst
  (implies (not (member-equal nil (strip-cdrs f2)))
           (not (member-equal nil (strip-cdrs (mv-nth 2 (unify-subst f1 f2 avoid-vars))))))
  :hints (("Goal" :in-theory (e/d (unify-subst) ()))))

(defthm-gify-term-flag
  (defthm not-member-nil-strip-cdrs-lambda
    (b* (((mv ?okp ?gen-term f)
          (gify-term-lambda x expand-fns avoid-vars state)))
      (implies (and (pseudo-termp x))
               (not (member-equal nil (strip-cdrs f)))))
    :flag gify-term-lambda)
  (defthm not-member-nil-strip-cdrs-expand
    (b* (((mv ?okp ?gen-term f)
          (gify-term-expand x expand-fns avoid-vars state)))
      (implies (and (pseudo-termp x))
               (not (member-equal nil (strip-cdrs f)))))
    :flag gify-term-expand)
  (defthm not-member-nil-strip-cdrs
    (b* (((mv ?okp ?gen-term f)
          (gify-term x expand-fns avoid-vars state)))
      (implies (and (pseudo-termp x))
               (not (member-equal nil (strip-cdrs f)))))
    :flag gify-term)
  (defthm not-member-nil-strip-cdrs-lst
    (b* (((mv ?okp ?gen-term f)
          (gify-term-lst lst expand-fns avoid-vars state)))
      (implies (and (pseudo-term-listp lst))
               (not (member-equal nil (strip-cdrs f)))))
    :flag gify-term-lst)
  :hints (("Goal" :in-theory (e/d (gify-term-lst
                                   gify-term
                                   gify-term-expand
                                   gify-term-lambda) ()))))

(local-defthmd interp-subst-assoc
  (iff (assoc-equal x (interp-subst f))
           (member x (strip-cdrs f)))
  :hints (("Goal" :in-theory (e/d (interp-subst) ()))))

(local-defthmd member-not-common
  (implies (and (member-equal x a)
                (member-equal x b))
           (intersection-equal a b))
  :hints (("Goal" :in-theory (e/d (intersection-equal) ()))))

(local-defthm rev-ctx-rw-symbolp
  (implies (and (pseudo-termp x)
                (not (consp x))

                (subsetp-equal (free-vars x)
                               (union-equal (strip-cdrs f1)
                                            avoid-vars))
                (not (member-equal nil (strip-cdrs f1)))
                (not (member-equal nil (strip-cdrs f2)))
                (no-duplicatesp-equal (strip-cars f2))
                (no-duplicatesp-equal (strip-cdrs f2))
                (symbol-listp avoid-vars)
                (symbol-symbol-alistp f1)
                (symbol-symbol-alistp f2)
                (not (intersection-equal avoid-vars (strip-cdrs f2))))
           (mv-let (nf na ns)
             (unify-subst f1 f2 avoid-vars)
             (equal (rev x
                         (rev-ctx (pairlis$ (free-vars x)
                                            (apply-map (pairlis$ nf na)
                                                       (free-vars x)))
                                  (append (rev-ctx (interp-subst ns) a)
                                          a)))
                    (rev x
                         (append (rev-ctx (interp-subst f1) a)
                                 a)))))
  :hints (("Goal" :in-theory (e/d (interp-subst
                                   unify-subst
                                   apply-map
                                   len
                                   rev-ctx
                                   free-vars
                                   pseudo-termp) (pairlis$-rev-lst-to-rev-ctx)))
          (and stable-under-simplificationp
               '(:in-theory (enable interp-subst-assoc
                             member-not-common)))))

(local
 (define alist-eq ((k symbol-listp)
                   (a1 symbol-alistp)
                   (a2 symbol-alistp))
   (if (consp k)
       (and (or (not (car k))
                (equal (cdr (assoc-equal (car k) a1)) (cdr (assoc-equal (car k) a2))))
            (alist-eq (cdr k) a1 a2))
     t)))

(local-defthmd alist-eq-on-member
  (implies (and (alist-eq k a1 a2)
                (member-equal x k)
                x)
           (equal (cdr (assoc-equal x a1))
                  (cdr (assoc-equal x a2))))
  :hints (("Goal" :in-theory (e/d (alist-eq) ()))))

(local-defthm alist-eq-on-union
  (implies (true-listp k1)
           (iff (alist-eq (union-equal k1 k2) a1 a2)
                (and (alist-eq k1 a1 a2)
                     (alist-eq k2 a1 a2))))
  :hints (("Goal" :in-theory (e/d (alist-eq
                                   alist-eq-on-member) ()))))

(local
 (defthm-pseudo-termp
   (defthmd rev-alist-eq-on-free-vars
     (implies (and (pseudo-termp x)
                   (alist-eq (free-vars x) a1 a2))
              (equal (rev x a1) (rev x a2)))
     :flag pseudo-termp)
   (defthmd rev-alist-eq-on-free-vars-lst
     (implies (and (pseudo-term-listp acl2::lst)
                   (alist-eq (free-vars-lst acl2::lst) a1 a2))
              (equal (rev-lst acl2::lst a1) (rev-lst acl2::lst a2)))
     :flag pseudo-term-listp)
   :hints (("Goal" :in-theory (e/d (alist-eq
                                    pseudo-termp
                                    pseudo-term-listp
                                    free-vars free-vars-lst
                                    rev-of-fncall-args) ())))))

(local-defthm assoc-member-pairlis$-apply-map
  (implies (and (member-equal x vars)
                (symbol-symbol-alistp s)
                (symbol-listp vars))
           (equal (assoc-equal x (pairlis$ vars (apply-map s vars)))
                  (if (assoc-equal x s)
                      (cons x (cdr (assoc-equal x s)))
                    (cons x x))))
  :hints (("Goal" :in-theory (e/d (apply-map) ()))))

(local
 (defthmd alist-eq-on-union-eq-apply-map
   (implies (and (symbol-listp vars1)
                 (symbol-listp vars2)
                 (subsetp-equal k vars1)
                 (subsetp-equal vars1 vars2)
                 (symbol-symbol-alistp s))
            (alist-eq k
                      (rev-ctx (pairlis$ vars2
                                         (apply-map s vars2))
                               a)
                      (rev-ctx (pairlis$ vars1
                                (apply-map s vars1)) a)))
   :hints (("Goal" :in-theory (e/d (alist-eq
                                    len
                                    apply-map) ())
                   :induct (len k)))))

(local-defthm member-x-unify-subst-f1-assoc
  (implies (member x (mv-nth 0 (unify-subst f1 f2 avoid-vars)))
           (assoc-equal x (interp-subst f1)))
  :hints (("Goal" :in-theory (e/d (unify-subst interp-subst) ()))))

(local-defthm cdr-member-x-unify-subst-f1-assoc
  (implies (member x (mv-nth 0 (unify-subst f1 f2 avoid-vars)))
           (cdr (assoc-equal x (interp-subst f1))))
  :hints (("Goal" :in-theory (e/d (unify-subst interp-subst) ()))))

(local-defthm member-x-unify-subst-f1-assoc-pairlis
  (implies (and (member x (mv-nth 0 (unify-subst f1 f2 avoid-vars)))
                (symbol-symbol-alistp f2)
                (symbol-symbol-alistp f1))
           (assoc-equal x (pairlis$ (mv-nth 0 (unify-subst f1 f2 avoid-vars))
                                    (mv-nth 1 (unify-subst f1 f2 avoid-vars)))))
  :hints (("Goal" :in-theory (e/d (unify-subst) ()))))

(local
 (defthm-pseudo-termp
   (defthmd rev-ctx-of-unify-subst-pseudo-termp
     (implies (and (pseudo-termp x)
                   (subsetp-equal (free-vars x) (union-equal (strip-cdrs f1) avoid-vars))
                   (not (member-equal nil (strip-cdrs f1)))
                   (not (member-equal nil (strip-cdrs f2)))
                   (no-duplicatesp-equal (strip-cars f2))
                   (no-duplicatesp-equal (strip-cdrs f2))
                   (symbol-listp avoid-vars)
                   (symbol-symbol-alistp f1)
                   (symbol-symbol-alistp f2)
                   (not (intersection-equal avoid-vars (strip-cdrs f2))))
              (b* (((mv nf na ns)
                    (unify-subst f1 f2 avoid-vars)))
                (equal (rev x (rev-ctx (pairlis$ (free-vars x)
                                                 (apply-map (pairlis$ nf na)
                                                            (free-vars x)))
                                       (append (rev-ctx (interp-subst ns) a) a)))
                       (rev x (append (rev-ctx (interp-subst f1) a) a)))))
     :flag pseudo-termp)
   (defthmd rev-ctx-of-unify-subst-pseudo-termp-lst
     (implies (and (pseudo-term-listp acl2::lst)
                   (subsetp-equal (free-vars-lst acl2::lst) (union-equal (strip-cdrs f1) avoid-vars))
                   (not (member-equal nil (strip-cdrs f1)))
                   (not (member-equal nil (strip-cdrs f2)))
                   (no-duplicatesp-equal (strip-cars f2))
                   (no-duplicatesp-equal (strip-cdrs f2))
                   (symbol-listp avoid-vars)
                   (symbol-symbol-alistp f1)
                   (symbol-symbol-alistp f2)
                   (not (intersection-equal avoid-vars (strip-cdrs f2))))
              (b* (((mv nf na ns)
                    (unify-subst f1 f2 avoid-vars)))
                (equal (rev-lst acl2::lst (rev-ctx (pairlis$ (free-vars-lst acl2::lst)
                                                             (apply-map (pairlis$ nf na)
                                                                        (free-vars-lst acl2::lst)))
                                                   (append (rev-ctx (interp-subst ns) a) a)))
                       (rev-lst acl2::lst (append (rev-ctx (interp-subst f1) a) a)))))
     :flag pseudo-term-listp)
   :hints (("Goal" :in-theory (e/d (free-vars free-vars-lst
                                    pseudo-termp
                                    pseudo-term-listp
                                    unify-subst
                                    interp-subst
                                    rev-of-fncall-args)
                                   (rev-ctx-rw-symbolp)))
           ("Subgoal *1/11"
            :use ((:instance alist-eq-on-union-eq-apply-map
                   (k (free-vars (car acl2::lst)))
                   (vars1 (free-vars (car acl2::lst)))
                   (vars2 (union-equal (free-vars-lst (cdr acl2::lst))
                                       (free-vars (car acl2::lst))))
                   (s (pairlis$ (mv-nth 0 (unify-subst f1 f2 avoid-vars))
                                (mv-nth 1 (unify-subst f1 f2 avoid-vars))))
                   (a (append
                       (rev-ctx (interp-subst (mv-nth 2 (unify-subst f1 f2 avoid-vars)))
                                a)
                       a)))
                  (:instance alist-eq-on-union-eq-apply-map
                   (k (free-vars-lst (cdr acl2::lst)))
                   (vars1 (free-vars-lst (cdr acl2::lst)))
                   (vars2 (union-equal (free-vars-lst (cdr acl2::lst))
                                       (free-vars (car acl2::lst))))
                   (s (pairlis$ (mv-nth 0 (unify-subst f1 f2 avoid-vars))
                                (mv-nth 1 (unify-subst f1 f2 avoid-vars))))
                   (a (append
                       (rev-ctx (interp-subst (mv-nth 2 (unify-subst f1 f2 avoid-vars)))
                                a)
                       a)))
                  (:instance rev-alist-eq-on-free-vars-lst
                   (acl2::lst (cdr acl2::lst))
                   (a1 (rev-ctx
                        (pairlis$ (union-equal (free-vars-lst (cdr acl2::lst))
                                               (free-vars (car acl2::lst)))
                                  (apply-map (pairlis$ (mv-nth 0 (unify-subst f1 f2 avoid-vars))
                                                       (mv-nth 1 (unify-subst f1 f2 avoid-vars)))
                                             (union-equal (free-vars-lst (cdr acl2::lst))
                                                          (free-vars (car acl2::lst)))))
                        (append (rev-ctx (interp-subst (mv-nth 2 (unify-subst f1 f2 avoid-vars)))
                                         a)
                                a)))
                   (a2 (rev-ctx
                        (pairlis$
                         (free-vars-lst (cdr acl2::lst))
                         (apply-map (pairlis$ (mv-nth 0 (unify-subst f1 f2 avoid-vars))
                                              (mv-nth 1 (unify-subst f1 f2 avoid-vars)))
                                    (free-vars-lst (cdr acl2::lst))))
                        (append
                         (rev-ctx (interp-subst (mv-nth 2 (unify-subst f1 f2 avoid-vars)))
                                  a)
                         a))))
                  (:instance rev-alist-eq-on-free-vars
                   (x (car acl2::lst))
                   (a1 (rev-ctx
                        (pairlis$ (union-equal (free-vars-lst (cdr acl2::lst))
                                               (free-vars (car acl2::lst)))
                                  (apply-map (pairlis$ (mv-nth 0 (unify-subst f1 f2 avoid-vars))
                                                       (mv-nth 1 (unify-subst f1 f2 avoid-vars)))
                                             (union-equal (free-vars-lst (cdr acl2::lst))
                                                          (free-vars (car acl2::lst)))))
                        (append (rev-ctx (interp-subst (mv-nth 2 (unify-subst f1 f2 avoid-vars)))
                                         a)
                                a)))
                   (a2 (rev-ctx
                        (pairlis$
                         (free-vars (car acl2::lst))
                         (apply-map (pairlis$ (mv-nth 0 (unify-subst f1 f2 avoid-vars))
                                              (mv-nth 1 (unify-subst f1 f2 avoid-vars)))
                                    (free-vars (car acl2::lst))))
                        (append
                         (rev-ctx (interp-subst (mv-nth 2 (unify-subst f1 f2 avoid-vars)))
                                  a)
                         a))))))
           ("Subgoal *1/10"
            :use (rev-ctx-rw-symbolp)))))

(local-defthm assoc-implies-member-interp-subst
  (implies (assoc-equal x (interp-subst f))
           (member-equal x (strip-cdrs f)))
  :hints (("Goal" :in-theory (e/d (interp-subst) ())))
  :rule-classes :forward-chaining)

(local-defthm assoc-interp-subst-unify-subst
  (implies (assoc-equal x (interp-subst f2))
           (and (assoc-equal x (interp-subst (mv-nth 2 (unify-subst f1 f2 avoid-vars))))
                (equal (cdr (assoc-equal x (interp-subst (mv-nth 2 (unify-subst f1 f2 avoid-vars)))))
                       (cdr (assoc-equal x (interp-subst f2))))
                (equal (cdr (assoc-equal x (pairlis$ (strip-cdrs (mv-nth 2 (unify-subst f1 f2 avoid-vars)))
                                                     (strip-cars (mv-nth 2 (unify-subst f1 f2 avoid-vars))))))
                       (cdr (assoc-equal x (pairlis$ (strip-cdrs f2)
                                                     (strip-cars f2)))))))
  :hints (("Goal" :in-theory (e/d (interp-subst unify-subst) (not-member-equal-avoid-vars-my-genvar
                                                              not-member-my-genvar-append)))
          ("Subgoal *1/4"
           :use ((:instance not-member-equal-avoid-vars-my-genvar
                  (x (caar f1)) (avoid-vars (append (strip-cdrs f2) avoid-vars)))))))

(local-defthmd intersection-equal-when-member
  (implies (and (member-equal x a)
                (member-equal x b))
           (intersection-equal a b))
  :hints (("Goal" :in-theory (e/d (intersection-equal) ()))))

(local-defthm member-avoid-vars-not-assoc-unify
  (implies (and (member-equal x avoid-vars)
                (symbol-listp avoid-vars)
                (not (intersection-equal avoid-vars (strip-cdrs f2))))
           (not (assoc-equal x (interp-subst (mv-nth 2 (unify-subst f1 f2 avoid-vars))))))
  :hints (("Goal" :in-theory (e/d (interp-subst unify-subst) (assoc-implies-member-interp-subst)))
          ("Subgoal *1/1"
                  :use ((:instance assoc-implies-member-interp-subst
                         (x x) (f f2))
                        (:instance intersection-equal-when-member
                         (x x) (a avoid-vars) (b (strip-cdrs f2)))))))

(local
 (defthm-pseudo-termp
   (defthmd rev-ctx-of-unify-subst-pseudo-termp-2
     (implies (and (pseudo-termp x)
                   (subsetp-equal (free-vars x) (union-equal (strip-cdrs f2) avoid-vars))
                   (not (member-equal nil (strip-cdrs f1)))
                   (not (member-equal nil (strip-cdrs f2)))
                   (no-duplicatesp-equal (strip-cars f2))
                   (no-duplicatesp-equal (strip-cdrs f2))
                   (symbol-listp avoid-vars)
                   (symbol-symbol-alistp f1)
                   (symbol-symbol-alistp f2)
                   (not (intersection-equal avoid-vars (strip-cdrs f2))))
              (b* (((mv ?nf ?na ns)
                    (unify-subst f1 f2 avoid-vars)))
                (equal (rev x (append (rev-ctx (interp-subst ns) a) a))
                       (rev x (append (rev-ctx (interp-subst f2) a) a)))))
     :flag pseudo-termp)
   (defthmd rev-ctx-of-unify-subst-pseudo-termp-lst-2
     (implies (and (pseudo-term-listp acl2::lst)
                   (subsetp-equal (free-vars-lst acl2::lst) (union-equal (strip-cdrs f2) avoid-vars))
                   (not (member-equal nil (strip-cdrs f1)))
                   (not (member-equal nil (strip-cdrs f2)))
                   (no-duplicatesp-equal (strip-cars f2))
                   (no-duplicatesp-equal (strip-cdrs f2))
                   (symbol-listp avoid-vars)
                   (symbol-symbol-alistp f1)
                   (symbol-symbol-alistp f2)
                   (not (intersection-equal avoid-vars (strip-cdrs f2))))
              (b* (((mv ?nf ?na ns)
                    (unify-subst f1 f2 avoid-vars)))
                (equal (rev-lst acl2::lst (append (rev-ctx (interp-subst ns) a) a))
                       (rev-lst acl2::lst (append (rev-ctx (interp-subst f2) a) a)))))
     :flag pseudo-term-listp)
   :hints (("Goal" :in-theory (e/d (free-vars free-vars-lst
                                    pseudo-termp
                                    pseudo-term-listp
                                    unify-subst
                                    interp-subst
                                    rev-of-fncall-args)
                                   (rev-ctx-rw-symbolp
                                    assoc-implies-member-interp-subst)))
           ("Subgoal *1/10"
            :use ((:instance assoc-implies-member-interp-subst
                   (x x) (f f2)))))))

(local-defthm subsetp-equal-unify-subst
  (subsetp-equal (strip-cdrs f2)
                 (strip-cdrs (mv-nth 2 (unify-subst f1 f2 avoid-vars))))
  :hints (("Goal" :in-theory (e/d (unify-subst) ()))))

(local-defthm member-equal-unify-subst-f2-preserved
  (implies (member-equal x (strip-cdrs f2))
           (member-equal x (strip-cdrs (mv-nth 2 (unify-subst f1 f2 avoid-vars)))))
  :hints (("Goal" :in-theory (e/d (unify-subst) ()))))

(local-defthmd member-equal-unify-subst-2
  (implies (and (symbol-symbol-alistp f1)
                (symbol-symbol-alistp f2)
                (member-equal v (append avoid-vars (strip-cdrs f1))))
           (member-equal
            (b* ((p (assoc-equal v (pairlis$ (mv-nth 0 (unify-subst f1 f2 avoid-vars))
                                             (mv-nth 1 (unify-subst f1 f2 avoid-vars))))))
              (if p (cdr p) v))
            (append avoid-vars (strip-cdrs (mv-nth 2 (unify-subst f1 f2 avoid-vars))))))
  :hints (("Goal" :in-theory (e/d (unify-subst) ()))))

(local-defthm not-consp-cdr-assoc-equal-of-symbol-symbol-alistp
  (implies (symbol-symbol-alistp f)
           (not (consp (cdr (assoc-equal x f))))))


(local-defthm subsetp-equal-unify-subst-2
  (implies (and (symbol-symbol-alistp f1)
                (symbol-symbol-alistp f2)
                (symbol-listp vars)
                (subsetp-equal vars (append avoid-vars (strip-cdrs f1))))
           (subsetp-equal
            (free-vars-lst
             (apply-map
              (pairlis$
               (mv-nth 0 (unify-subst f1 f2 avoid-vars))
               (mv-nth 1 (unify-subst f1 f2 avoid-vars)))
              vars))
            (append avoid-vars (strip-cdrs (mv-nth 2 (unify-subst f1 f2 avoid-vars))))))
  :hints (("Goal" :in-theory (e/d (unify-subst
                                   apply-map
                                   free-vars-lst
                                   free-vars
                                   len) ())
                  :induct (len vars))
          ("Subgoal *1/1"
           :expand ((FREE-VARS
                     (CDR (ASSOC-EQUAL (CAR VARS)
                                       (PAIRLIS$ (MV-NTH 0 (UNIFY-SUBST F1 F2 AVOID-VARS))
                                                 (MV-NTH 1 (UNIFY-SUBST F1 F2 AVOID-VARS)))))))
           :use ((:instance member-equal-unify-subst-2
                  (v (car vars)))))))

(local-defthmd strip-cdrs-unify-subst-special-case
  (implies (and (symbol-symbol-alistp f1)
                (symbol-symbol-alistp f2)
                (equal (mv-nth 0 (unify-subst f1 f2 avoid-vars))
                       (mv-nth 1 (unify-subst f1 f2 avoid-vars))))
           (subsetp-equal (strip-cdrs f1)
                          (strip-cdrs (mv-nth 2 (unify-subst f1 f2 avoid-vars)))))
  :hints (("Goal" :in-theory (e/d (unify-subst) ()))))

(local-defthm member-equal-assoc-pairlis
  (implies (member-equal x s)
           (equal (assoc-equal x (pairlis$ s s))
                  (cons x x))))

(local-defthm subsetp-apply-map
  (implies (and (symbol-listp s)
                (symbol-listp x))
           (equal (apply-map (pairlis$ s s) x) x))
  :hints (("Goal" :in-theory (e/d (apply-map
                                   len) ())
                  :induct (len x))))

(local
 (defthm-pseudo-termp
   (defthm rev-pairlis-rev-ctx
     (implies (and (pseudo-termp x)
                   (subsetp-equal (free-vars x) v))
              (equal (rev x (rev-ctx (pairlis$ v v) a))
                     (rev x a)))
     :flag pseudo-termp)
   (defthm rev-pairlis-rev-ctx-lst
     (implies (and (pseudo-term-listp acl2::lst)
                   (subsetp-equal (free-vars-lst acl2::lst) v))
              (equal (rev-lst acl2::lst (rev-ctx (pairlis$ v v) a))
                     (rev-lst acl2::lst a)))
     :flag pseudo-term-listp)
   :hints (("Goal" :in-theory (e/d (pseudo-term-listp
                                    pseudo-termp
                                    free-vars free-vars-lst
                                    rev-of-fncall-args) ())))))

(local
 (defthmd rev-ctx-of-unify-subst-pseudo-termp-3
   (implies (and (pseudo-termp x)
                 (subsetp-equal (free-vars x) (union-equal (strip-cdrs f1) avoid-vars))
                 (not (member-equal nil (strip-cdrs f1)))
                 (not (member-equal nil (strip-cdrs f2)))
                 (no-duplicatesp-equal (strip-cars f2))
                 (no-duplicatesp-equal (strip-cdrs f2))
                 (symbol-listp avoid-vars)
                 (symbol-symbol-alistp f1)
                 (symbol-symbol-alistp f2)
                 (not (intersection-equal avoid-vars (strip-cdrs f2))))
            (b* (((mv ?nf ?na ns)
                  (unify-subst f1 f2 avoid-vars)))
              (implies (equal nf na)
                       (equal (rev x (append (rev-ctx (interp-subst ns) a) a))
                              (rev x (append (rev-ctx (interp-subst f1) a) a))))))
   :hints (("Goal" :use (rev-ctx-of-unify-subst-pseudo-termp)

                   :do-not-induct t))))

(local-defthmd free-vars-lst-of-append
  (implies (and (pseudo-term-listp x)
                (pseudo-term-listp y))
           (iff (subsetp-equal (free-vars-lst (append x y)) z)
                (and (subsetp-equal (free-vars-lst x) z)
                     (subsetp-equal (free-vars-lst y) z))))
  :hints (("Goal" :in-theory (e/d (free-vars-lst
                                   free-vars) ()))))

(local-defthm subsetp-of-unify-subst-1
  (implies (and (symbol-symbol-alistp f2)
                (symbol-symbol-alistp f1))
           (subsetp-equal (free-vars-lst (mv-nth 1 (unify-subst f1 f2 avoid-vars)))
                          (strip-cdrs (mv-nth 2 (unify-subst f1 f2 avoid-vars)))))
  :hints (("Goal" :in-theory (e/d (unify-subst
                                   free-vars
                                   free-vars-lst) ()))))

(local
 (defthm-gify-term-flag
   (defthm subset-gify-term-lambda
    (b* (((mv okp gen-term f)
          (gify-term-lambda x expand-fns avoid-vars state)))
      (implies (and okp
                    (pseudo-termp x)
                    (consp x)
                    (not (quotep x))
                    (acl2::flambda-applicationp x)
                    (subsetp-equal (free-vars x) avoid-vars))
               (subsetp-equal (free-vars gen-term) (append avoid-vars (strip-cdrs f)))))
    :flag gify-term-lambda)
  (defthm subset-gify-term-expand
    (b* (((mv okp gen-term f)
          (gify-term-expand x expand-fns avoid-vars state)))
      (implies (and okp
                    (pseudo-termp x)
                    (consp x)
                    (not (quotep x))
                    (not (acl2::flambda-applicationp x))
                    (member-eq (car x) expand-fns)
                    (subsetp-equal (free-vars x) avoid-vars))
               (subsetp-equal (free-vars gen-term) (append avoid-vars (strip-cdrs f)))))
    :flag gify-term-expand)
  (defthm subset-gify-term
    (b* (((mv okp gen-term f)
          (gify-term x expand-fns avoid-vars state)))
      (implies (and okp
                    (pseudo-termp x)
                    (subsetp-equal (free-vars x) avoid-vars))
               (subsetp-equal (free-vars gen-term) (append avoid-vars (strip-cdrs f)))))
    :flag gify-term)
  (defthm subset-gify-term-lst
    (b* (((mv okp gen-term f)
          (gify-term-lst lst expand-fns avoid-vars state)))
      (implies (and okp
                    (pseudo-term-listp lst)
                    (subsetp-equal (free-vars-lst lst) avoid-vars))
               (subsetp-equal (free-vars-lst gen-term) (append avoid-vars (strip-cdrs f)))))
    :flag gify-term-lst)
  :hints (("Goal" :in-theory (e/d (free-vars
                                   free-vars-lst
                                   pseudo-term-listp
                                   pseudo-termp
                                   gify-term
                                   gify-term-lst
                                   gify-term-lambda
                                   gify-term-expand
                                   strip-cdrs-unify-subst-special-case
                                   free-vars-lst-of-append) ())))))

(local-defthm rev-ctx-nil
  (equal (rev-ctx nil a) nil)
  :hints (("Goal" :in-theory (e/d (rev-ctx) ()))))

(local
 (defines gify-term-ind
  :verify-guards nil
  :flag-local nil
  :ignore-ok t
  (define gify-term-lambda-ind (x expand-fns avoid-vars a state)
    :measure (make-ord 2 (1+ (len expand-fns)) (make-ord 1 (1+ (acl2-count x)) 0))
    :irrelevant-formals-ok t
    (if (and (acl2::flambda-applicationp x)
             (equal (len (car x)) 3)
             (eq (caar x) 'lambda)
             (symbol-listp (cadr (car x)))
             (pseudo-termp (caddr (car x)))
             (pseudo-term-listp (cdr x))
             (equal (len (cadr (car x)))
                    (len (cdr x))))
        (b* ((rargs
              (gify-term-lst-ind (acl2::fargs x) expand-fns avoid-vars a state))
             (lambda-form (acl2::ffn-symb x))
             (body (acl2::lambda-body lambda-form))
             (formals (acl2::lambda-formals lambda-form))
             (a (rev-ctx (pairlis$ formals (acl2::fargs x)) a)))
          (and rargs
               (gify-term-ind body expand-fns formals a state)))
      t))
  (define gify-term-expand-ind (x expand-fns avoid-vars a state)
    :measure (make-ord 2 (1+ (len expand-fns)) (make-ord 1 (1+ (acl2-count x)) 0))
    (if (and (consp x)
             (not (quotep x))
             (not (acl2::flambda-applicationp x))
             (member-eq (car x) expand-fns))
        (b* (((mv okp-def formals body) (acl2::fn-get-def (car x) state))
             (rargs
              (gify-term-lst-ind (acl2::fargs x) expand-fns avoid-vars a state))
             (body (pseudo-term-fix body))
             (formals (acl2::symbol-list-fix formals))
             (expand-fns (remove1 (car x) expand-fns))
             (a (rev-ctx (pairlis$ formals (acl2::fargs x)) a)))
          (and rargs
               (gify-term-ind body expand-fns formals a state)))
      t))
  (define gify-term-ind (x expand-fns avoid-vars a state)
    :measure (make-ord 2 (1+ (len expand-fns)) (make-ord 1 (1+ (acl2-count x)) 1))
    (cond ((atom x)
           t)
          ((quotep x)
           t)
          ((acl2::flambda-applicationp x)
           (gify-term-lambda-ind x expand-fns avoid-vars a state))
          ((member-eq (car x) expand-fns)
           (gify-term-expand-ind x expand-fns avoid-vars a state))
          ((not (cdr x)) t)
          (t
           (if (symbolp (car x))
               (gify-term-lst-ind (acl2::fargs x) expand-fns avoid-vars a state)
             t))))
  (define gify-term-lst-ind  (lst expand-fns avoid-vars a state)
    :measure (make-ord 2 (1+ (len expand-fns)) (make-ord 1 (1+ (acl2-count lst)) 1))
    (if (consp lst)
        (and (gify-term-ind (car lst) expand-fns avoid-vars a state)
             (gify-term-lst-ind (cdr lst) expand-fns avoid-vars a state))
      t))))

(local-defthm intersection-equal-union
  (iff (intersection-equal (union-equal x y) z)
       (or (intersection-equal x z)
           (intersection-equal y z)))
  :hints (("Goal" :in-theory (e/d (intersection-equal
                                   intersection-equal-when-member) ())
                  :induct (intersection-equal x z))))

(local-defthm assoc-equal-then-member
  (implies (assoc-equal x a)
           (member-equal x (strip-cars a))))

(local-defthm member-then-cdr-assoc
  (implies (and (member x (strip-cars a))
                (= y (strip-cdrs a)))
           (member (cdr (assoc x a)) y))
  :hints (("Goal" :in-theory (e/d () ()))))

(local-defthmd subset-equal-intersection-1
  (implies (and (subsetp-equal x y)
                (intersection-equal a x))
           (intersection-equal a y))
  :hints (("Goal" :in-theory (e/d (intersection-equal) ()))))

(local-defthmd intersection-comm-1
  (implies (intersection-equal a b)
           (intersection-equal b a))
  :hints (("Goal" :in-theory (e/d (intersection-equal
                                   intersection-equal-when-member) ())
                  :expand ((INTERSECTION-EQUAL B A)))
          ("Subgoal *1/3"
           :use ((:instance subset-equal-intersection-1
                  (a (cdr b)) (x (cdr a)) (y a))))))

(local-defthmd intersection-comm
  (iff (intersection-equal a b)
       (intersection-equal b a))
  :hints (("Goal" :use (intersection-comm-1
                        (:instance intersection-comm-1
                         (a b) (b a))))))

(local-defthmd subset-equal-intersection-2
  (implies (and (subsetp-equal a b)
                (subsetp-equal x y)
                (intersection-equal a x))
           (intersection-equal b y))
  :hints (("Goal" :in-theory (e/d (intersection-comm) ())
                  :use (subset-equal-intersection-1
                        (:instance subset-equal-intersection-1 (x a) (y b) (a y))))))

(local-defthm intersection-of-cons
  (iff (intersection-equal (cons x y) z)
       (or (member-equal x z)
           (intersection-equal y z)))
  :hints (("Goal" :in-theory (e/d (intersection-equal) ()))))

(local-defthm strip-cars-rev-ctx
  (equal (strip-cars (rev-ctx s a))
         (strip-cars s))
  :hints (("Goal" :in-theory (e/d (rev-ctx) ()))))

(local-defthmd subsetp-equal-free-vars-member
  (implies (member-equal x actuals)
           (subsetp-equal (free-vars x)
                          (free-vars-lst actuals)))
  :hints (("Goal" :in-theory (e/d (free-vars free-vars-lst) ()))))

(local-defthm strip-cars-interp-subst
  (equal (strip-cars (interp-subst x))
         (strip-cdrs x))
  :hints (("Goal" :in-theory (e/d (interp-subst) ()))))

(local-defthmd mv-nth-0-unify-subst
  (equal (mv-nth 0 (unify-subst f1 f2 avoid-vars))
         (strip-cdrs f1))
  :hints (("Goal" :in-theory (e/d (unify-subst) ()))))

(local-defthmd aux-lemma-1
  (implies (and (pseudo-term-listp actuals)
                (subsetp-equal (free-vars-lst actuals)
                               (append avoid-vars (strip-cdrs f2)))
                (equal (len formals) (len actuals))
                (subsetp-equal x formals)
                (not (member-equal nil (strip-cdrs f1)))
                (not (member-equal nil (strip-cdrs f2)))
                (no-duplicatesp-equal (strip-cars f2))
                (no-duplicatesp-equal (strip-cdrs f2))
                (no-duplicatesp-equal (strip-cars f1))
                (no-duplicatesp-equal (strip-cdrs f1))
                (symbol-listp avoid-vars)
                (symbol-listp formals)
                (symbol-symbol-alistp f1)
                (symbol-symbol-alistp f2)
                (not (intersection-equal avoid-vars (strip-cdrs f2)))
                (not (intersection-equal formals (strip-cdrs f1))))
           (alist-eq x
                     (append
                      (rev-ctx
                       (pairlis$
                        (mv-nth 0 (unify-subst f1 f2 avoid-vars))
                        (mv-nth 1 (unify-subst f1 f2 avoid-vars)))
                       (append
                        (rev-ctx (interp-subst (mv-nth 2 (unify-subst f1 f2 avoid-vars))) a)
                        a))
                      (rev-ctx
                       (pairlis$ formals
                                 actuals)
                       (append
                        (rev-ctx
                         (interp-subst
                          (mv-nth 2 (unify-subst f1 f2 avoid-vars)))
                         a)
                        a)))
                     (append
                      (rev-ctx (interp-subst f1) (rev-ctx (pairlis$ formals actuals) (append
                                                                                      (rev-ctx
                                                                                       (interp-subst
                                                                                        f2)
                                                                                       a)
                                                                                      a)))
                      (rev-ctx (pairlis$ formals actuals) (append
                                                           (rev-ctx
                                                            (interp-subst
                                                             f2)
                                                            a)
                                                           a)))))
  :hints (("Goal" :in-theory (e/d (alist-eq len
                                   free-vars-lst
                                   len
                                   intersection-equal-when-member
                                   mv-nth-0-unify-subst
                                   subsetp-equal-free-vars-member) ())
                  :induct (len x))
          ("Subgoal *1/1"
           :use ((:instance rev-ctx-of-unify-subst-pseudo-termp-2
                  (x (CDR (ASSOC-EQUAL (CAR X)
                                       (PAIRLIS$ FORMALS ACTUALS)))))))))

(local-defthm member-aux-lemma
  (implies (member x (strip-cdrs f1))
           (member x (mv-nth 0 (unify-subst f1 f2 avoid-vars))))
  :hints (("Goal" :in-theory (e/d (mv-nth-0-unify-subst) ()))))

(local-defthm aux-lemma-3
  (implies (member x (strip-cdrs f1))
           (ASSOC-EQUAL
            (CDR (ASSOC-EQUAL x
                              (PAIRLIS$ (MV-NTH 0 (UNIFY-SUBST F1 F2 AVOID-VARS))
                                        (MV-NTH 1 (UNIFY-SUBST F1 F2 AVOID-VARS)))))
            (INTERP-SUBST (MV-NTH 2 (UNIFY-SUBST F1 F2 AVOID-VARS)))))
  :hints (("Goal" :in-theory (e/d (unify-subst interp-subst) ()))))

(local-defthm aux-lemma-4
  (implies (and (member x (strip-cdrs f1))
                (symbol-symbol-alistp f2)
                (symbol-symbol-alistp f1)
                (no-duplicatesp-equal (strip-cars f2))
                (no-duplicatesp-equal (strip-cdrs f2)))
           (equal (CDR
                   (ASSOC-EQUAL
                    (CDR (ASSOC-EQUAL x
                                      (PAIRLIS$ (MV-NTH 0 (UNIFY-SUBST F1 F2 AVOID-VARS))
                                                (MV-NTH 1 (UNIFY-SUBST F1 F2 AVOID-VARS)))))
                    (INTERP-SUBST (MV-NTH 2 (UNIFY-SUBST F1 F2 AVOID-VARS)))))
                  (list (CDR (ASSOC-EQUAL x
                                          (PAIRLIS$ (STRIP-CDRS F1)
                                                    (STRIP-CARS F1)))))))
  :hints (("Goal" :in-theory (e/d (unify-subst interp-subst) ()))))

(local-defthm aux-lemma-6
  (implies (and (not (member nil (Strip-cdrs f)))
                (member x (strip-cars f)))
           (cdr (assoc-equal x f))))

(local-defthm aux-lemma-5
  (implies (and (not (member-equal nil (strip-cdrs f2)))
                (member-equal x (strip-cdrs f1)))
           (cdr (assoc-equal x (pairlis$ (mv-nth 0 (unify-subst f1 f2 avoid-vars))
                                         (mv-nth 1 (unify-subst f1 f2 avoid-vars))))))
  :hints (("Goal" :in-theory (e/d (unify-subst) ()))))

(local-defthmd aux-lemma-2
  (implies (and (pseudo-term-listp actuals)
                (subsetp-equal (free-vars-lst actuals)
                               (append avoid-vars (strip-cdrs f2)))
                (equal (len formals) (len actuals))
                (subsetp-equal x (strip-cdrs f1))
                (not (member-equal nil (strip-cdrs f1)))
                (not (member-equal nil (strip-cdrs f2)))
                (no-duplicatesp-equal (strip-cars f2))
                (no-duplicatesp-equal (strip-cdrs f2))
                (no-duplicatesp-equal (strip-cars f1))
                (no-duplicatesp-equal (strip-cdrs f1))
                (symbol-listp avoid-vars)
                (symbol-listp formals)
                (symbol-symbol-alistp f1)
                (symbol-symbol-alistp f2)
                (not (intersection-equal avoid-vars (strip-cdrs f2)))
                (not (intersection-equal formals (strip-cdrs f1))))
           (alist-eq x
                     (append
                      (rev-ctx
                       (pairlis$
                        (mv-nth 0 (unify-subst f1 f2 avoid-vars))
                        (mv-nth 1 (unify-subst f1 f2 avoid-vars)))
                       (append
                        (rev-ctx (interp-subst (mv-nth 2 (unify-subst f1 f2 avoid-vars))) a)
                        a))
                      (rev-ctx
                       (pairlis$ formals
                                 actuals)
                       (append
                        (rev-ctx
                         (interp-subst
                          (mv-nth 2 (unify-subst f1 f2 avoid-vars)))
                         a)
                        a)))
                     (append
                      (rev-ctx (interp-subst f1) (rev-ctx (pairlis$ formals actuals) (append
                                                                                      (rev-ctx
                                                                                       (interp-subst
                                                                                        f2)
                                                                                       a)
                                                                                      a)))
                      (rev-ctx (pairlis$ formals actuals) (append
                                                           (rev-ctx
                                                            (interp-subst
                                                             f2)
                                                            a)
                                                           a)))))
  :hints (("Goal" :in-theory (e/d (alist-eq len
                                   free-vars-lst
                                   len
                                   intersection-equal-when-member
                                   ;; mv-nth-0-unify-subst
                                   rev-of-fncall-args) ())
                  :induct (len x))
          ("Subgoal *1/1"
           :cases ((equal (CDR (ASSOC-EQUAL (CAR X)
                                            (PAIRLIS$ (STRIP-CDRS F1)
                                                      (STRIP-CARS F1)))) 'quote)))))

(local-defthm alist-eq-append
  (implies (and (alist-eq x a1 a2)
                (alist-eq y a1 a2))
           (alist-eq (append x y) a1 a2))
  :hints (("Goal" :in-theory (e/d (alist-eq) ()))))

(local-defthm alist-eq-member
  (implies (and (member-equal x y)
                (alist-eq y a1 a2)
                x)
           (equal (cdr (assoc x a1)) (cdr (assoc x a2))))
  :hints (("Goal" :in-theory (e/d (alist-eq) ()))))

(local-defthmd alist-eq-subset
  (implies (and (subsetp-equal x y)
                (alist-eq y a1 a2))
           (alist-eq x a1 a2))
  :hints (("Goal" :in-theory (e/d (alist-eq len) ())
                  :induct (len x))))

(local-defthm aux-lemma
  (implies (and (pseudo-term-listp actuals)
                (subsetp-equal (free-vars-lst actuals)
                               (append avoid-vars (strip-cdrs f2)))
                (equal (len formals) (len actuals))
                (subsetp-equal x (append (strip-cdrs f1) formals))
                (not (member-equal nil (strip-cdrs f1)))
                (not (member-equal nil (strip-cdrs f2)))
                (no-duplicatesp-equal (strip-cars f2))
                (no-duplicatesp-equal (strip-cdrs f2))
                (no-duplicatesp-equal (strip-cars f1))
                (no-duplicatesp-equal (strip-cdrs f1))
                (symbol-listp avoid-vars)
                (symbol-listp formals)
                (symbol-symbol-alistp f1)
                (symbol-symbol-alistp f2)
                (not (intersection-equal avoid-vars (strip-cdrs f2)))
                (not (intersection-equal formals (strip-cdrs f1))))
           (alist-eq x
                     (append
                      (rev-ctx
                       (pairlis$
                        (mv-nth 0 (unify-subst f1 f2 avoid-vars))
                        (mv-nth 1 (unify-subst f1 f2 avoid-vars)))
                       (append
                        (rev-ctx (interp-subst (mv-nth 2 (unify-subst f1 f2 avoid-vars))) a)
                        a))
                      (rev-ctx
                       (pairlis$ formals
                                 actuals)
                       (append
                        (rev-ctx
                         (interp-subst
                          (mv-nth 2 (unify-subst f1 f2 avoid-vars)))
                         a)
                        a)))
                     (append
                      (rev-ctx (interp-subst f1) (rev-ctx (pairlis$ formals actuals) (append
                                                                                      (rev-ctx
                                                                                       (interp-subst
                                                                                        f2)
                                                                                       a)
                                                                                      a)))
                      (rev-ctx (pairlis$ formals actuals) (append
                                                           (rev-ctx
                                                            (interp-subst
                                                             f2)
                                                            a)
                                                           a)))))
  :hints (("Goal" :use ((:instance aux-lemma-1
                         (x formals))
                        (:instance aux-lemma-2
                         (x (strip-cdrs f1))))
                  :in-theory (e/d (alist-eq-subset) ())
                  :do-not-induct t)))

(local
 (defthmd rev-ctx-of-unify-subst-pseudo-termp-4
   (implies (and (pseudo-termp x)
                 (equal (len formals) (len actuals))
                 (pseudo-term-listp actuals)
                 (subsetp-equal (free-vars-lst actuals)
                               (append avoid-vars (strip-cdrs f2)))
                 (subsetp-equal (free-vars x) (union-equal (strip-cdrs f1) formals))
                 (not (member-equal nil (strip-cdrs f1)))
                 (not (member-equal nil (strip-cdrs f2)))
                 (no-duplicatesp-equal (strip-cars f2))
                 (no-duplicatesp-equal (strip-cdrs f2))
                 (no-duplicatesp-equal (strip-cars f1))
                 (no-duplicatesp-equal (strip-cdrs f1))
                 (symbol-listp avoid-vars)
                 (symbol-listp formals)
                 (symbol-symbol-alistp f1)
                 (symbol-symbol-alistp f2)
                 (not (intersection-equal avoid-vars (strip-cdrs f2)))
                 (not (intersection-equal formals (strip-cdrs f1))))
            (EQUAL
             (rev x
                  (append
                      (rev-ctx
                       (pairlis$
                        (mv-nth 0 (unify-subst f1 f2 avoid-vars))
                        (mv-nth 1 (unify-subst f1 f2 avoid-vars)))
                       (append
                        (rev-ctx (interp-subst (mv-nth 2 (unify-subst f1 f2 avoid-vars))) a)
                        a))
                      (rev-ctx
                       (pairlis$ formals
                                 actuals)
                       (append
                        (rev-ctx
                         (interp-subst
                          (mv-nth 2 (unify-subst f1 f2 avoid-vars)))
                         a)
                        a))))
             (rev
              x
              (append
               (rev-ctx (interp-subst f1) (rev-ctx (pairlis$ formals actuals) (append
                                                                               (rev-ctx
                                                                                (interp-subst
                                                                                 f2)
                                                                                a)
                                                                               a)))
               (rev-ctx (pairlis$ formals actuals) (append
                                                    (rev-ctx
                                                     (interp-subst
                                                      f2)
                                                     a)
                                                    a))))))
   :hints (("Goal" :in-theory (e/d (REV-ALIST-EQ-ON-FREE-VARS) (aux-lemma))
                   :do-not-induct t
                   :use ((:instance aux-lemma
                          (x (free-vars x))))))))

(local-defthm pailis$-to-rev-ctx
  (implies (equal (len x) (len y))
           (equal (pairlis$ x (rev-lst y a))
                  (rev-ctx (pairlis$ x y) a)))
  :hints (("Goal" :in-theory (e/d (rev-ctx
                                   len) ()))))

(local
 (defthm pairlis$-append
   (implies (equal (len x) (len z))
            (equal (pairlis$ (append x y) (append z w))
                   (append (pairlis$ x z)
                           (pairlis$ y w))))
   :hints (("Goal" :in-theory (e/d (rev-ctx
                                    len) ())))))

(local-defthm append-rev-ctx
  (equal (rev-ctx (append x y) a)
         (append (rev-ctx x a) (rev-ctx y a)))
  :hints (("Goal" :in-theory (e/d (rev-ctx) ()))))

(local-defthmd rev-ctx-pairlis$
  (equal (rev-ctx (pairlis$ x y) a)
         (pairlis$ x (rev-lst y a)))
  :hints (("Goal" :in-theory (e/d (rev-ctx) ()))))

(local-defthmd rev-ctx-of-processed
  (implies (EQUAL (REV-LST processed-actuals (APPEND (REV-CTX processed-context A) A))
                  (REV-LST actuals A))
           (equal (REV-CTX
                   (PAIRLIS$ formals
                             processed-actuals)
                   (APPEND (REV-CTX processed-context A) A))
                  (rev-ctx (pairlis$ formals actuals) a)))
  :hints (("Goal" :in-theory (e/d (rev-ctx-pairlis$) ()))))

(local
 (defthm-gify-term-ind-flag
   (defthm gify-term-correct-lambda
     (b* (((mv okp gen-term f)
           (gify-term-lambda x expand-fns avoid-vars state)))
       (implies (and okp
                     (rev-meta-extract-global-facts)
                     (subsetp-equal (free-vars x) avoid-vars)
                     (pseudo-termp x)
                     (symbol-listp avoid-vars))
                (equal (rev gen-term (append (rev-ctx (interp-subst f) a) a))
                       (rev x a))))
     :flag gify-term-lambda-ind)
   (defthm gify-term-correct-expand
     (b* (((mv okp gen-term f)
           (gify-term-expand x expand-fns avoid-vars state)))
       (implies (and okp
                     (rev-meta-extract-global-facts)
                     (subsetp-equal (free-vars x) avoid-vars)
                     (pseudo-termp x)
                     (symbol-listp avoid-vars))
                (equal (rev gen-term (append (rev-ctx (interp-subst f) a) a))
                       (rev x a))))
     :flag gify-term-expand-ind)
   (defthm gify-term-correct
     (b* (((mv okp gen-term f)
           (gify-term x expand-fns avoid-vars state)))
       (implies (and okp
                     (rev-meta-extract-global-facts)
                     (subsetp-equal (free-vars x) avoid-vars)
                     (pseudo-termp x)
                     (symbol-listp avoid-vars))
                (equal (rev gen-term (append (rev-ctx (interp-subst f) a) a))
                       (rev x a))))
     :flag gify-term-ind)
   (defthm gify-term-correct-lst
     (b* (((mv okp gen-term f)
           (gify-term-lst lst expand-fns avoid-vars state)))
       (implies (and okp
                     (rev-meta-extract-global-facts)
                     (subsetp-equal (free-vars-lst lst) avoid-vars)
                     (pseudo-term-listp lst)
                     (symbol-listp avoid-vars))
                (equal (rev-lst gen-term (append (rev-ctx (interp-subst f) a) a))
                       (rev-lst lst a))))
     :flag gify-term-lst-ind)
   :hints (("Goal" :in-theory (e/d (gify-term-lambda
                                    gify-term-expand
                                    gify-term
                                    gify-term-lst
                                    rev-ctx-of-unify-subst-pseudo-termp
                                    rev-ctx-of-unify-subst-pseudo-termp-3
                                    rev-ctx-of-unify-subst-pseudo-termp-lst-2
                                    pseudo-termp
                                    pseudo-term-listp
                                    free-vars-lst
                                    free-vars
                                    rev-of-fncall-args)
                                   (rev-fn-get-def)))
           ("Subgoal *1/12"
            :in-theory (e/d (gify-term-lambda
                             gify-term-expand
                             gify-term
                             gify-term-lst
                             rev-ctx-of-unify-subst-pseudo-termp
                             rev-ctx-of-unify-subst-pseudo-termp-3
                             rev-ctx-of-unify-subst-pseudo-termp-lst-2
                             rev-ctx-of-unify-subst-pseudo-termp-4
                             pseudo-termp
                             pseudo-term-listp
                             free-vars-lst
                             free-vars
                             rev-of-fncall-args)
                            (rev-fn-get-def))
            :use ((:instance rev-fn-get-def
                   (fn (car x))
                   (st state)
                   (args (cdr x))
                   (a a))
                  (:instance rev-ctx-of-processed
                   (processed-actuals (MV-NTH 1
                                              (GIFY-TERM-LST (CDR X)
                                                             EXPAND-FNS AVOID-VARS STATE)))
                   (processed-context (INTERP-SUBST (MV-NTH 2
                                                            (GIFY-TERM-LST (CDR X)
                                                                           EXPAND-FNS AVOID-VARS STATE))))
                   (formals (MV-NTH 1 (ACL2::FN-GET-DEF (CAR X) STATE)))
                   (actuals (cdr x)))))
           ("Subgoal *1/1"
            :in-theory (e/d (gify-term-lambda
                             gify-term-expand
                             gify-term
                             gify-term-lst
                             rev-ctx-of-unify-subst-pseudo-termp
                             rev-ctx-of-unify-subst-pseudo-termp-3
                             rev-ctx-of-unify-subst-pseudo-termp-lst-2
                             rev-ctx-of-unify-subst-pseudo-termp-4
                             pseudo-termp
                             pseudo-term-listp
                             free-vars-lst
                             free-vars
                             rev-of-fncall-args)
                            (rev-fn-get-def))
            :use ((:instance rev-ctx-of-processed
                   (processed-actuals (MV-NTH 1
                                              (GIFY-TERM-LST (CDR X)
                                                             EXPAND-FNS AVOID-VARS STATE)))
                   (processed-context (INTERP-SUBST (MV-NTH 2
                                                            (GIFY-TERM-LST (CDR X)
                                                                           EXPAND-FNS AVOID-VARS STATE))))
                   (formals (cadar x))
                   (actuals (cdr x))))))))

(local-defthm symbolp-car-assoc
  (implies (symbolp x)
           (symbolp (car (assoc x s)))))

(define gify-mapping ((free-vars symbol-listp)
                      (f symbol-symbol-alistp)
                      state)
  :verify-guards nil
  :returns (g symbol-alistp :hyp (symbol-listp free-vars))
  (if (consp free-vars)
      (b* ((rest
            (gify-mapping (cdr free-vars) f state))
           (fst (car free-vars))
           (fn-pair (assoc-eq fst f))
           ((unless fn-pair)
            (cons (cons fst fst) rest))
           ((cons v fn) fn-pair)
           (tab (table-alist 'known-bvecps (w state)))
           ((unless (symbol-symbol-alistp tab))
            (cons (cons fst fst) rest))
           (bvecp-thm (assoc (cdr fn-pair) tab))
           ((unless (and bvecp-thm
                         (symbolp (cdr bvecp-thm))
                         (cdr bvecp-thm)))
            (cons (cons fst fst) rest))
           (bvecp-thm (meta-extract-formula (cdr bvecp-thm) state))
           ((unless (and (pseudo-termp bvecp-thm)
                         (or (and (= (len bvecp-thm) 3)
                                  (quotep (caddr bvecp-thm))
                                  (consp (cdr (caddr bvecp-thm)))
                                  (natp (unquote (caddr bvecp-thm)))
                                  (eql (len (cadr bvecp-thm)) 1)
                                  (eq (car (cadr bvecp-thm)) fn)
                                  (eq (car bvecp-thm) 'bvecp))
                             (and (= (len bvecp-thm) 2)
                                  (eql (len (cadr bvecp-thm)) 1)
                                  (eq (car (cadr bvecp-thm)) fn)
                                  (eq (car bvecp-thm) 'bitp)))))
            (prog2$ (cw "Bad bvecp-form: ~x0~%" bvecp-thm)
                    (cons (cons fst fst) rest)))
           (width (if (eq (car bvecp-thm) 'bitp)
                      (kwote 1)
                    (caddr bvecp-thm))))
        (cons (cons v `(acl2::loghead$inline ,width ,v)) rest))
    nil))

(local-defthm alistp-assoc-consp
  (implies (and (alistp x)
                (assoc y x))
           (consp (assoc y x))))

(local-defthm symbol-symbol-alistp-is-eqlable-alistp
  (implies (symbol-symbol-alistp x)
           (eqlable-alistp x)))

(verify-guards gify-mapping
  :hints (("Goal" :in-theory (e/d (len) ())
                  :do-not-induct t)))

(include-book "std/strings/pretty" :dir :system)

(local-defthm symbol-symbol-alistp-pairlis-strip-cdrs
  (implies (symbol-symbol-alistp x)
           (symbol-symbol-alistp (pairlis$ (strip-cdrs x) (strip-cars x)))))

(local-defthm character-alistp-lemma
  (character-alistp (list (cons #\0 x))))

(define gify-cp ((cl pseudo-term-listp)
                 expand-fns
                 state)
  :verify-guards nil
  (if (and (symbol-listp expand-fns)
           (or 
             ;(cw "clause ~x0 ~%" cl)
               (= (len cl) 1)
;               (= (len cl) 3)
               )
           (acl2::fmt-state-p state)
           (open-output-channel-p *standard-co* :character state))
      (b* ((term (car cl))
;           (- (cw "term ~x0 ~%" term))
           ((mv okp g-term f) (gify-term term expand-fns (all-vars term) state))
           (free-vars (all-vars g-term))
           ((unless (and okp
                         (not (member-eq nil free-vars))))
            (mv t nil state))
           (f (pairlis$ (strip-cdrs f) (strip-cars f)))
;           (- (cw "f: ~x0 ~%" f))
           (g-bindings (gify-mapping free-vars f state))
           (res `((lambda ,(strip-cars g-bindings) ,g-term) ,@(strip-cdrs g-bindings)))
           (- (cw "FGL term: ~x0~%" res))
           ;; (state (fms "FGL term: ~x0~%" (list (cons #\0 res)) *standard-co* state
                       ;; (evisc-tuple 3 4 nil nil)))
           )
        (mv nil (list (list res)) state))
    (mv t nil state)))

(define get-v-bindings ((cl pseudo-term-listp)
                        expand-fns
                        a
                        state)
  (if (and (symbol-listp expand-fns)
           (= (len cl) 1)
           (alistp a))
      (b* ((term (car cl))
           ((mv okp g-term f) (gify-term term expand-fns (all-vars term) state))
           ((unless (and okp
                         (not (member-eq nil (all-vars g-term))))) a))
        (append (rev-ctx (interp-subst f) a) a))
    a))

(local-defthm assoc-rev-ctx-cons
  (equal (assoc x (rev-ctx (cons (cons x y) z) a))
         (cons x (rev y a)))
  :hints (("Goal" :in-theory (e/d (rev-ctx) ()))))

(local-defthm assoc-interp-subst-pairlis
  (implies (symbol-symbol-alistp f)
           (iff (ASSOC-EQUAL fvar (INTERP-SUBST (PAIRLIS$ (STRIP-CDRS F) (STRIP-CARS F))))
                (ASSOC-EQUAL fvar f)))
  :hints (("Goal" :in-theory (e/d (interp-subst) ()))))

(local-defthm car-assoc-equal-x
  (implies (Assoc x y)
           (equal (car (Assoc x y)) x)))

(local-defthm assoc-equal-interp-subst-pairlis$
  (implies (symbol-symbol-alistp f)
           (equal (assoc x (interp-subst (pairlis$ (strip-cdrs f) (strip-cars f))))
                  (b* ((p (assoc x f)))
                    (if p
                        (cons (car p) (list (cdr p)))
                      nil))))
  :hints (("Goal" :in-theory (e/d (interp-subst) ()))))

(local-defthm len-x-1-rev-lst
  (implies (equal (len x) 0)
           (equal (rev-lst x a)
                  nil))
  :hints (("Goal" :in-theory (e/d (len) ()))))

(local-defthm alist-eq-on-cons
  (implies (and (alist-eq x y z)
                (not (member-equal a x)))
           (alist-eq x (cons (cons a b) y) z))
  :hints (("Goal" :in-theory (e/d (alist-eq) ()))))

(local-defthm rev-ctx-of-cons
  (equal (rev-ctx (cons (cons x y) z) a)
         (cons (cons x (rev y a)) (rev-ctx z a)))
  :hints (("Goal" :in-theory (e/d (rev-ctx) ()))))

(local-defthm alist-eq-on-gify-mapping
  (implies (and (rev-meta-extract-global-facts)
                (symbol-listp fvars)
                (no-duplicatesp-equal fvars)
                (not (member nil fvars))
                (symbol-symbol-alistp f))
           (alist-eq fvars (rev-ctx (gify-mapping fvars f state)
                                    (append (rev-ctx (interp-subst (pairlis$ (strip-cdrs f) (strip-cars f))) a) a))
                     (append (rev-ctx (interp-subst (pairlis$ (strip-cdrs f) (strip-cars f))) a) a)))
  :hints (("Goal" :in-theory (e/d (gify-mapping
                                   alist-eq
                                   len)
                                  (rev-meta-extract-formula
                                   rev-formula)))
          ("Subgoal *1/5"
           :use ((:instance rev-meta-extract-formula
                  (acl2::name (CDR (ASSOC-EQUAL (CDR (ASSOC-EQUAL (CAR FVARS) F))
                                                (FGETPROP 'KNOWN-BVECPS
                                                          'TABLE-ALIST
                                                          NIL
                                                          (CDR (ASSOC-EQUAL 'ACL2::CURRENT-ACL2-WORLD
                                                                            (NTH 2 STATE)))))))
                  (st state))
                 (:instance rev-of-fncall-args
                  (x (cadr (META-EXTRACT-FORMULA
                            (CDR (ASSOC-EQUAL (CDR (ASSOC-EQUAL (CAR FVARS) F))
                                              (FGETPROP 'KNOWN-BVECPS
                                                        'TABLE-ALIST
                                                        NIL
                                                        (CDR (ASSOC-EQUAL 'ACL2::CURRENT-ACL2-WORLD
                                                                          (NTH 2 STATE))))))
                            STATE))))
                 (:instance rev-of-fncall-args
                  (x (LIST (CDR (ASSOC-EQUAL (CAR FVARS) F)))))
                 (:instance rev-of-quote
                  (x (cadr (META-EXTRACT-FORMULA
                            (CDR (ASSOC-EQUAL (CDR (ASSOC-EQUAL (CAR FVARS) F))
                                              (FGETPROP 'KNOWN-BVECPS
                                                        'TABLE-ALIST
                                                        NIL
                                                        (CDR (ASSOC-EQUAL 'ACL2::CURRENT-ACL2-WORLD
                                                                          (NTH 2 STATE))))))
                            STATE))))
                 (:instance rev-of-quote
                  (x (LIST (CDR (ASSOC-EQUAL (CAR FVARS) F)))))))))

(local-defthm rev-ctx-pairlis$-inv
  (equal (pairlis$ x (rev-lst y a))
         (rev-ctx (pairlis$ x y) a))
  :hints (("Goal" :use (rev-ctx-pairlis$))))

(local-defthm pairlis$-strip-cars-cdrs
  (implies (alistp x)
           (equal (pairlis$ (strip-cars x) (strip-cdrs x))
                  x)))

(local-defthm symbol-alistp-is-alistp
  (implies (symbol-alistp x)
           (alistp x)))

(local-defthm no-duplicatesp-union
  (implies (and (NO-DUPLICATESP-EQUAL x)
                (NO-DUPLICATESP-EQUAL y))
           (NO-DUPLICATESP-EQUAL (UNION-EQUAL x y)))
  :hints (("Goal" :in-theory (e/d (no-duplicatesp-equal
                                   len) ()))))

(local
 (defthm-free-vars-flag
   (defthm no-duplicates-free-vars
     (no-duplicatesp-equal (free-vars term))
     :flag free-vars)
   (defthm no-duplicates-free-vars-lst
     (no-duplicatesp-equal (free-vars-lst term-lst))
     :flag free-vars-lst)
   :hints (("Goal" :in-theory (e/d (free-vars free-vars-lst) ())))))

(local-defthm pairlis$-double
  (implies (and (true-listp y)
                (equal (len x) (len y)))
           (equal (strip-cdrs (pairlis$ x y)) y)))

(local-defthm len-strip-cars-strip-cdrs
  (implies (alistp x)
           (equal (len (strip-cars x)) (len (strip-cdrs x))))
  :hints (("Goal" :in-theory (e/d (len) ()))))

(defthm gify-cp-correct
  (implies (and (pseudo-term-listp cl)
                (rev-meta-extract-global-facts)
                (alistp a)
                (rev (acl2::conjoin-clauses (acl2::clauses-result (gify-cp cl expand-fns state))) (get-v-bindings cl expand-fns a state)))
           (rev (acl2::disjoin cl) a))
  :hints (("Goal" :in-theory (e/d (get-v-bindings
                                   gify-cp
                                   acl2::conjoin-clauses
                                   acl2::disjoin
                                   acl2::disjoin2
                                   REV-ALIST-EQ-ON-FREE-VARS)
                                  (rev-meta-extract-formula
                                   REV-FORMULA
                                   rev-of-bitp-call))
                  :use ((:instance alist-eq-on-gify-mapping
                         (fvars (FREE-VARS (MV-NTH 1
                                                   (GIFY-TERM (CAR CL)
                                                              EXPAND-FNS (FREE-VARS (CAR CL))
                                                              STATE))))
                         (f (PAIRLIS$ (STRIP-CDRS (MV-NTH 2
                                                          (GIFY-TERM (CAR CL)
                                                                     EXPAND-FNS (FREE-VARS (CAR CL))
                                                                     STATE)))
                                      (STRIP-CARS (MV-NTH 2
                                                          (GIFY-TERM (CAR CL)
                                                                     EXPAND-FNS (FREE-VARS (CAR CL))
                                                                     STATE)))))))
                  :do-not-induct t))
  :rule-classes :clause-processor)

;; Include fgl/top -- some lemmas are not proven when this is included earlier
;; because of conflicting rewrite rules!
(include-book "centaur/fgl/top" :dir :system)
;; (value-triple (acl2::tshell-ensure))

(define defthm-using-fgl-fn (form)
  :verify-guards nil
  (b* ((thm-name (car form))
       (term (cadr form))
       (kw-val-alst (acl2::keyword-value-list-to-alist (cddr form)))
       (expand-fns (cdr (assoc :expand-fns kw-val-alst))))
    `(defthm ,thm-name
       ,term
       :hints (
               ("Goal" :clause-processor (gify-cp clause ',expand-fns state))
               '(:CLAUSE-PROCESSOR
                 (FGL::EXPAND-AN-IMPLIES-CP CLAUSE (FGL::DEFAULT-FGL-CONFIG)))
               '(:CLAUSE-PROCESSOR (FGL::FGL-INTERP-CP CLAUSE (FGL::DEFAULT-FGL-CONFIG)
                                    FGL::INTERP-ST STATE))))))

(define defthmd-using-fgl-fn (form)
  :verify-guards nil
  (b* ((thm-name (car form))
       (term (cadr form))
       (kw-val-alst (acl2::keyword-value-list-to-alist (cddr form)))
       (expand-fns (cdr (assoc :expand-fns kw-val-alst))))
    `(defthmd ,thm-name
       ,term
       :hints (("Goal" :clause-processor (gify-cp clause ',expand-fns state))
               '(:CLAUSE-PROCESSOR
                 (FGL::EXPAND-AN-IMPLIES-CP CLAUSE (FGL::DEFAULT-FGL-CONFIG)))
               '(:CLAUSE-PROCESSOR (FGL::FGL-INTERP-CP CLAUSE (FGL::DEFAULT-FGL-CONFIG)
                                    FGL::INTERP-ST STATE))))))

(defmacro defthm-using-fgl (&rest form)
  `(make-event
    (defthm-using-fgl-fn ',form)))

(defmacro defthmd-using-fgl (&rest form)
  `(make-event
    (defthmd-using-fgl-fn ',form)))

;; Simple Test:
;; (encapsulate (((bar) => *))
;;   (local (defund bar () 0))
;;   (local (in-theory (disable (bar))))
;;   (bvecthm+ bar-size
;;     (bvecp (bar) 2)
;;     :hints (("Goal" :in-theory (e/d (bar) ())))))

;; (defthm-using-fgl foo-thm-alt
;;   (equal (bar)
;;          (+ (* 2 (bitn (bar) 1)) (bitn (bar) 0))))



(fgl::remove-fgl-rewrite expt)

(local (arith-5-for-rtl))

(fgl::def-fgl-rewrite expt-2-for-fgl
  (equal (expt 2 i)
         (if (fgl::fgl-validity-check (fgl::make-fgl-satlink-monolithic-sat-config) (natp i))
             (ash 1 i)
           (fgl::abort-rewrite (expt 2 i))))
  :hints (("Goal" :in-theory (e/d () ()))))

(local (include-book "rtl/rel11/support/definitions" :dir :system))

(fgl::def-fgl-rewrite bits-for-fgl
  (equal (bits x i j)
         (if (fgl::fgl-validity-check
               (fgl::make-fgl-satlink-monolithic-sat-config)
               (and (integerp x) (integerp i) (integerp j) (>= i j)))
           (logand (ash x (- j))
                   (1- (ash 1 (1+ (- i j)))))
           (fgl::abort-rewrite (bits x i j))))
  :hints (("Goal"
           :use bits-for-gl)))

(fgl::def-fgl-rewrite bitn-for-fgl
  (equal (bitn x n)
         (if (fgl::fgl-validity-check
               (fgl::make-fgl-satlink-monolithic-sat-config)
               (and (integerp x) (integerp n) (>= n 0)))
           (if (logbitp n x) 1 0)
           (fgl::abort-rewrite (bitn x n))))
  :hints (("Goal"
           :use bitn-for-gl)))

(fgl::def-fgl-rewrite expo-for-fgl
  (equal (expo x)
         (if (fgl::fgl-validity-check
               (fgl::make-fgl-satlink-monolithic-sat-config)
               (and (integerp x) (not (= x 0))))
           (1- (integer-length (abs x)))
           (fgl::abort-rewrite (expo x))))
  :hints (("Goal"
           :use expo-for-gl)))

(fgl::def-fgl-rewrite ag-of-as-fgl
  (equal (ag a (as wa v r))
         (if (fgl::fgl-validity-check
               (fgl::make-fgl-satlink-monolithic-sat-config)
               (equal a wa))
           v
           (ag a r))))


(fgl::add-fgl-rewrite bits-for-fgl)
(fgl::add-fgl-rewrite bitn-for-fgl)
(fgl::add-fgl-rewrite binary-cat-for-gl)
(fgl::add-fgl-rewrite expo-for-fgl)
(fgl::add-fgl-rewrite ag-of-as-fgl)
;(fgl::add-fgl-rewrite ag-of-as)
(fgl::add-fgl-rewrite ag-of-nil)



;; It's beneficial to make `ag` and `as` uninterpreted.

(fgl::remove-fgl-rewrite as)
(fgl::remove-fgl-rewrite ag)
(fgl::disable-execution as)
(fgl::disable-execution ag)
