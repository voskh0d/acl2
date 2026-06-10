(in-package "RTL")

(include-book "rtl/rel11/lib/top-alt" :dir :system)

(set-ignore-ok t)

(defun rac-type-info (x type)
  (declare (ignore type))
  x)

(local
  (defthmd hack
    (implies (and x (listp x))
             (< (acl2-count (nth i x))
                (acl2-count x)))
    :hints (("Goal"
             :in-theory (enable nth)))))

(mutual-recursion
  (defund is-type-p (x type)
    (declare (xargs :measure (acl2-count type)))
    (cond ((equal type '(int)) (integerp x))
          ((equal type '(bool)) (bitp x))
          ((equal (car type) 'bvec) (bvecp x (cadr type)))
          ((equal (car type) 'array) (is-array-p x (cadr type) (caddr type)))
          ((equal (car type) 'mv-type) (mv-type-p-loop-alt x (cddr type) (cadr type)))
          (t t)))
  (defund is-array-p (x type len)
    (declare (xargs :measure (+ (nfix len) (acl2-count type))))
    (if (zp len)
      t
      (and (is-type-p (ag (1- len) x) type)
           (is-array-p x type (1- len)))))
  (defun mv-type-p-loop-alt (x type i)
    (declare (xargs :measure (+ (nfix i) (acl2-count type))
                    :hints (("Goal" :use (:instance hack (x type) (i (1- i)))))))
    (if (zp i)
      t
      (and (is-type-p (mv-nth (1- i) x) (nth (1- i) type))
           (mv-type-p-loop-alt x type (1- i))))))

(defthmd is-type-p-to-mv-p
  (implies (equal (car type) 'mv-type)
           (equal (is-type-p x type)
                  (mv-type-p-loop-alt x (cddr type) (cadr type))))
  :hints (("Goal"
           :in-theory (e/d (is-type-p) (len)))))

(defthmd unroll-mv-type-p-loop-alt
  (implies (not (zp i))
           (equal (mv-type-p-loop-alt x types i)
           (and (is-type-p (mv-nth (1- i) x) (nth (1- i) types))
                (mv-type-p-loop-alt x types (1- i))))))

(defthmd unroll-mv-type-p-loop-alt-2
  (implies (zp i)
           (equal (mv-type-p-loop-alt x types i)
                  t)))

;  (defund is-mv-p-loop (x type)
;    (declare (xargs :measure (acl2-count type)))
;;    (if (or (not (listp type)) (not type))
;    (if (or (not (listp type))
;            (not type))
;      t
;        (and (is-type-p (car x) (car type))
;             (is-mv-p-loop (cdr x) (cdr type)))))
;  )

;(defthmd is-type-p-to-mv-p
;  (implies (equal (car type) 'mv-type)
;           (equal (is-type-p x type)
;                  (if (equal (len x) (1- (len type)))
;                    (is-mv-p-loop x (cdr type))
;                    nil)))
;  :hints (("Goal"
;           :in-theory (e/d (is-type-p) (len)))))
;
;(defthmd mv-nth-type-lemma
;  (implies (and (is-mv-p-loop x type)
;                (equal (len type) (len x)))
;           (is-type-p (nth i x)
;                      (nth i type)))
;  :hints (("Goal"
;           :in-theory (enable is-mv-p-loop zp natp nth))))
;
;(local
;  (defthmd mv-nth-to-nth
;    (equal (mv-nth i x)
;           (nth i x))
;    :hints (("Goal"
;             :in-theory (enable mv-nth)))))
;
;(defthmd mv-nth-type
;  (implies (and (is-type-p x type)
;                (natp i)
;                (equal (car type) 'mv-type)
;                (equal (nth (1+ i) type) type-i))
;           (is-type-p (mv-nth i x) type-i))
;  :hints (("Goal"
;           :use (:instance mv-nth-type-lemma
;                           (type (cdr type)))
;           :in-theory (e/d (natp is-type-p-to-mv-p mv-nth-to-nth)
;                           ()))))
;
;(defun mv-type-p-loop-alt (i x type)
;  (declare (xargs :measure (+ (nfix (- (len type) i)))
;;                  :hints (("Goal" :in-theory (disable is-type-p)))
;                  ))
;  (if (and (natp i) (< i (len type)))
;    (and (is-type-p (mv-nth i x) (nth (1+ i) type))
;         (mv-type-p-loop-alt (1+ i) x type))
;    t))

;(thm
;  (implies (and (equal (car type) 'mv-type)
;                (listp type)
;                )
;           (equal (is-type-p x type)
;                  (mv-type-p-loop-alt 0 x type)))
;  :hints (("Goal"
;;           :induct
;;           (list
;;             (mv-type-p-loop-alt (nfix i) x type)
;;                         (is-mv-p-loop x (cdr type)))
;;            :expand 
;           :in-theory (enable 
;                        is-type-p-to-mv-p
;                        is-mv-p-loop
;;                        is-type-p
;                        mv-type-p-loop-alt
;;                        mv-nth-type
;                              )
;           )))

(defthmd is-type-p-bvecp
  (equal (bvecp x n)
         (is-type-p x (list 'bvec n)))
  :hints (("Goal"
           :in-theory (enable is-type-p))))
                
(local
  (defun induct-on-nat (n)
    (if (zp n)
      t
      (induct-on-nat (1- n)))))

(defthmd is-array-p-fwd
  (implies (and (is-array-p a type-expr n)
                (integerp n)
                (natp i)
                (< i n))
           (is-type-p (ag i a) type-expr))
  :hints (("Goal"
           :induct (induct-on-nat n)
           :in-theory (enable zp is-array-p))))

(defthmd ag-type
  (implies (and (is-type-p a (list 'array type-expr n))
                (integerp n)
                (natp i)
                (< i n))
            (is-type-p (ag i a) type-expr))
  :hints (("Goal"
           :expand (:free (x type) (is-type-p x type))
           :in-theory (enable is-type-p is-array-p-fwd))))

(defthmd check-rac-array-type-subset
  (implies (and (is-array-p a type n)
                (< i n)
                (integerp n)
                (natp i))
           (is-array-p a type i))
  :hints (("Goal"
           :induct (induct-on-nat n)
           :in-theory (enable zp is-array-p))))

(defthmd array-of-vec-p-does-not-change-if-set-outside-of-range-hack
  (implies (and (>= i n)
                )
           (equal (is-array-p (as i x a) type n)
                  (is-array-p a type n)))
  :hints (("Goal"
           :induct (induct-on-nat n)
           :in-theory (e/d (zp is-array-p)
                           (check-rac-array-type-subset)))
          ("Subgoal *1/2"
           ;; We want to expand only the nth term not the n-1 !
           :expand (:free (x type) (is-array-p x type n)))))



(defthmd array-of-vec-p-does-not-change-if-set-outside-of-range
  (implies (and (>= i n)
                (equal expr-type (list 'array inner-type n))
                )
           (equal (is-type-p (as i x a) expr-type)
                  (is-type-p a expr-type)))
  :hints (("Goal"
           :in-theory (enable is-type-p array-of-vec-p-does-not-change-if-set-outside-of-range-hack))))

(defthmd as-keeps-type-hack
  (implies (and (is-array-p a type n)
                (is-type-p x type)
                (integerp n)
                (integerp i)
                (< i n))
           (is-array-p (as i x a) type n))
  :hints (("Goal"
           :induct (induct-on-nat n)
           :in-theory (enable is-array-p
                              zp
                              array-of-vec-p-does-not-change-if-set-outside-of-range-hack)
           )
          ("Subgoal *1/2.2"
           :cases ((= i (1- n)))
;           ;; We want to expand only the nth term not the n-1 !
           :expand (:free (x type) (is-array-p x type n)))))

(defthmd as-keeps-type
  (implies (and (is-type-p a (list 'array inner-type n))
                (is-type-p x inner-type)
                (integerp n)
                (integerp i)
                (< i n))
           (is-type-p (as i x a) (list 'array inner-type n)))
  :hints (("Goal"
           :in-theory (enable is-type-p as-keeps-type-hack))))

(defthmd bvecp-setbits
  (implies (integerp w)
           (bvecp (setbits x w i j y) w))
  :hints (("Goal"
           :in-theory (disable is-type-p-bvecp))))

(defthmd bvecp-setbits-alt
  (implies (integerp w)
           (is-type-p (setbits x w i j y) (list 'bvec w)))
  :hints (("Goal"
           :use bvecp-setbits
           :in-theory (e/d (is-type-p-bvecp) (setbits)))))

(defthmd bvecp-setbitn
  (implies (integerp w)
           (bvecp (setbitn x w n y) w))
  :hints (("Goal"
           :in-theory (disable is-type-p-bvecp))))

(defthmd bvecp-setbitn-alt
  (implies (integerp w)
           (is-type-p (setbitn x w n y) (list 'bvec w)))
  :hints (("Goal"
           :use bvecp-setbitn
           :in-theory (e/d (is-type-p-bvecp) (setbitn)))))

(defthmd bits-bvecp-alt
  (implies (and (<= (+ 1 i (- j)) (cadr expr-type))
                (equal (car expr-type) 'bvec)
                (case-split (integerp (cadr expr-type))))
           (is-type-p (bits x i j) expr-type))
  :hints (("Goal"
           :expand (:free () (is-type-p (bits x i j) expr-type))
           :in-theory ()
           :use (:instance bits-bvecp (k (cadr expr-type))))))

(defthmd bvecp-int
  (implies (and (is-type-p x type)
                (equal (car type) 'bvec))
           (is-type-p x '(int)))
  :hints (("Goal"
           :expand (:free (x type) (is-type-p x type))
           :in-theory '(bvecp (equal))))
  :rule-classes :forward-chaining)

;(defthmd bvecp-to-is-type-p
;  (implies (equal (car type) 'bvec)
;           (equal (is-type-p x type)
;                  (bvecp x (cadr type))))
;  :hints (("Goal"
;           :expand (:free (x type) (IS-TYPE-P X type))
;           :in-theory ())))

(defthmd bvecp-to-is-type-p
  (implies (bvecp x n)
           (is-type-p x (list 'bvec n)))
  :hints (("Goal"
           :expand (:free (x type) (is-type-p x type)))))

(defthmd int-to-is-type-p
  (implies (integerp x)
           (is-type-p x '(int)))
  :hints (("Goal"
           :in-theory (enable is-type-p))))

(defthmd int-si-alt
  (implies (and (is-type-p x '(int))
                (natp n))
           (is-type-p (si x n) '(int)))
  :hints (("Goal"
           :expand (:free (x type) (is-type-p x type))))
  :rule-classes (:type-prescription :rewrite))

(defthmd bitn-bool
  (is-type-p (bitn x n) '(bool))
  :hints (("Goal"
           :in-theory (enable is-type-p))))

(defthmd logior-bvecp-alt
  (implies (and (equal (car type) 'bvec)
                (is-type-p x type)
                (is-type-p y type))
           (is-type-p (logior x y) type))
  :hints (("Goal"
           :expand (:free (x type) (is-type-p x type)))))

(defthmd logior-bvecp-alt-2
  (implies (and (is-type-p x '(bool))
                (is-type-p y '(bool)))
           (is-type-p (logior1 x y) '(bool)))
  :hints (("Goal"
           :expand (:free (x type) (is-type-p x type)))))

;;; TODO: can we have a rule (ty & ty) -> ty
;(defthmd logand-bvecp-alt
;  (implies (and (equal (car type) 'bvec)
;                (is-type-p x type)
;                (is-type-p y type))
;           (is-type-p (logand x y) type))
;  :hints (("Goal"
;           :expand (:free (x type) (is-type-p x type)))))

(defthmd logand-bvecp-alt-2
  (implies (and (is-type-p x '(bool))
                (is-type-p y '(bool)))
           (is-type-p (logand1 x y) '(bool)))
  :hints (("Goal"
           :expand (:free (x type) (is-type-p x type)))))

(defthmd lognot1-bvecp-alt-2
  (implies (is-type-p x '(bool))
           (is-type-p (lognot1 x) '(bool)))
  :hints (("Goal"
           :expand (:free (x type) (is-type-p x type)))))

;(defthm bvecp-int
;  (implies (and (is-type-p x '(int))
;                (natp n))
;           (is-type-p (si x n) '(int)))
;  :hints (("Goal"
;           :expand (:free (x type) (is-type-p x type))))
;  :rule-classes (:type-prescription :rewrite))

;(defthmd array-of-vec-nil
;  (is-type-p nil (list 'array type n))
;  :hints (("Goal"
;           :expand (:free (type n) (is-array-p nil type n))
;           :in-theory (enable bvecp is-type-p))))

(encapsulate ()
  (local (INCLUDE-BOOK "rtl/rel11/lib/top" :dir :system))
  (defthmd bvecp-right-shift
    (implies (and (natp i)
                  (is-type-p x (list 'bvec n)))
             (is-type-p (ash x (- i)) (list 'bvec n)))
    :hints (("Goal"
             :nonlinearp t
             :in-theory (enable bvecp)
             :expand (:free (x ty) (is-type-p x ty))))))

(defthmd type-of-log<>
  (is-type-p (log<> x y) '(bool))
  :hints (("Goal"
           :in-theory (enable log<> IS-TYPE-P))))

(deftheory type-theory
  '(rac-type-info
    (is-type-p)
    (is-array-p)
    ag-type
    as-keeps-type
    bits-bvecp-alt
    bvecp-setbits-alt
    bvecp-setbitn-alt
    (natp)
    int-si-alt
    bvecp-int
    (ainit)
    bvecp-to-is-type-p
    int-to-is-type-p
    bvecp-forward
    ;
;    is-type-p-to-mv-p
;    is-mv-p-loop
    bitn-bool
;    mv-nth-type
;
logior-bvecp-alt len cdr-cons car-cons
logior-bvecp-alt-2
;logand-bvecp-alt
logand-bvecp-alt-2
lognot1-bvecp-alt-2
;
bvecp-right-shift
;
is-type-p-to-mv-p
unroll-mv-type-p-loop-alt
unroll-mv-type-p-loop-alt-2
(nth)
zp
type-of-log<>
    ))

(defund search-for-known-types-loop (clause known-types)
  (if (not clause)
    nil
    (if (listp clause)
      (append (search-for-known-types-loop (car clause) known-types)
              (search-for-known-types-loop (cdr clause) known-types))
      (let ((thm (cdr (assoc clause known-types))))
        (if thm (list thm) nil)))))


(defund search-vars (formula target)
  (if (or (not formula) (not (listp formula)))
    ()
    (if (equal (car formula) target)
      (cdr formula)
      (let ((maybe-res (search-vars (car formula) target)))
        (if maybe-res
          maybe-res
          (search-vars (cdr formula) target))))))

;; TODO est ce que zip existe ?
(defund zip-2 (l1 l2)
;  (declare (xargs :mode :program))
  (if (and (listp l1) (listp l2) l1 l2)
    (cons (list (car l1) (car l2))
          (zip-2 (cdr l1) (cdr l2)))
    ()))

(local (include-book "std/system/theorem-symbolp" :dir :system))

;:ubt instanciate-vars
(defund instanciate-vars (vars thm-name name world)
  (declare (xargs :mode :program))
  (let* ((f (acl2::formula thm-name t world))
         (thm-vars (search-vars f name)))
    (if (or thm-vars
            (cw "Could not find free variable in ~x0 (~x1 ~% ~x2) ~%" name f name))
    (zip-2 thm-vars vars)
    ())))


;; TODO we don't look inside of the detected clause, we should always do the
;; rec call
(defund search-for-known-types-loop-2 (clause known-types world)
  (declare (xargs :mode :program))
  (if (or (not clause) (not (listp clause)))
    ()
    (let* ((maybe-type-thm (assoc (car clause) known-types)))
      (if maybe-type-thm
        (if (equal (len clause) 1)
          (list (cdr maybe-type-thm))
          (let ((instance (instanciate-vars (cdr clause)
                                            (cdr maybe-type-thm)
                                            (car clause)
                                            world)))
            (if instance
              (list `(:instance ,(cdr maybe-type-thm) ,@instance))
              ())))
        (append (search-for-known-types-loop-2 (car clause) known-types world)
                (search-for-known-types-loop-2 (cdr clause) known-types world))))))

(defund get-list-of-thm-name (instanciated-thms)
  (if (and (listp instanciated-thms) instanciated-thms)
    (cons (cadar instanciated-thms)
          (get-list-of-thm-name (cdr instanciated-thms)))
    ()))

(defund remove-duplicate (in out)
  (declare (xargs :mode :program))
  (if (not in)
    out
    (if (member (car in) out :test 'equal)
      (remove-duplicate (cdr in) out)
      (remove-duplicate (cdr in) (cons (car in) out)))))

(defund search-for-known-types (id clause world stable-under-simplificationp)
  (declare (xargs :mode :program)
            (ignore id))
  (if (not stable-under-simplificationp)
    ()
    (let* ((type-thms (table-alist 'known-types world))
           (thms-to-use (remove-duplicate (search-for-known-types-loop-2 clause type-thms world) ())))
      (if thms-to-use
        `(:use ,thms-to-use
          :in-theory '(type-theory))
        ())))
)
