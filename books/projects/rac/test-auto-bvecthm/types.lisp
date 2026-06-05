(in-package "RTL")

(include-book "rtl/rel11/lib/top-alt" :dir :system)

(set-ignore-ok t)

(defun rac-type-info (x type)
  (declare (ignore type))
  x)

;(defund valid-type-lst types (types)
;  (if (not types)
;    t
;    (and (valid-type 

;(defund valid-type (type)
;;  (declare (xargs :guard t))
;  (and (true-listp type)
;       (cond ((equal type '(int)) t)
;             ((equal type '(bool)) t)
;             ((equal (car type) 'bvec) (natp (cadr type)))
;             ((equal (car type) 'array) (and (valid-type (cadr type)) (natp (caddr type)))))))

;(defthm aaa
;  (implies (consp type)
;           (< (ACL2-COUNT (MV-NTH I TYPE))
;              (ACL2-COUNT TYPE))
;           )
;  :hints (("Goal"
;           :in-theory (enable mv-nth))))

;:ubt is-type-p
(mutual-recursion
  (defund is-type-p (x type)
    (declare (xargs :measure (acl2-count type)))
;    (declare (xargs :guard (valid-type type)
;                    :guard-hints (("Goal" :in-theory (enable valid-type)))))
    (cond ((equal type '(int)) (integerp x))
          ((equal type '(bool)) (bitp x))
          ((equal (car type) 'bvec) (bvecp x (cadr type)))
          ((equal (car type) 'array) (is-array-p x (cadr type) (caddr type)))
          ((equal (car type) 'mv-type)
           (if (equal (len x) (1- (len type)))
             (is-mv-p-loop x (cdr type))
             nil))
          (t t)))
  (defund is-array-p (x type len)
    (declare (xargs :measure (+ (nfix len) (acl2-count type))
;                    :guard (and (natp len)
;                                (valid-type type))
                                ))
    (if (zp len)
      t
      (and (is-type-p (ag (1- len) x) type)
           (is-array-p x type (1- len)))))
  (defund is-mv-p-loop (x type)
    (declare (xargs :measure (acl2-count type)))
;    (if (or (not (listp type)) (not type))
    (if (or (not (listp type))
            (not type))
      t
        (and (is-type-p (car x) (car type))
             (is-mv-p-loop (cdr x) (cdr type)))))
  )

(defthmd is-type-p-to-mv-p
  (implies (equal (car type) 'mv-type)
           (equal (is-type-p x type)
                  (if (equal (len x) (1- (len type)))
                    (is-mv-p-loop x (cdr type))
                    nil)))
  :hints (("Goal"
           :in-theory (e/d (is-type-p) (len)))))

(defthmd mv-nth-type-lemma
  (implies (and (is-mv-p-loop x type)
                (equal (len type) (len x)))
           (is-type-p (nth i x)
                      (nth i type)))
  :hints (("Goal"
           :in-theory (enable is-mv-p-loop zp natp nth))))

(local
  (defthmd mv-nth-to-nth
    (equal (MV-NTH i x)
           (nth i x))
    :hints (("Goal"
             :in-theory (enable mv-nth)))))

(defthmd mv-nth-type
  (implies (and (is-type-p x type)
                (natp i)
                (equal (car type) 'mv-type)
                (equal (nth (1+ i) type) type-i))
           (is-type-p (mv-nth i x) type-i))
  :hints (("Goal"
           :use (:instance mv-nth-type-lemma
                           (type (cdr type)))
           :in-theory (e/d (natp is-type-p-to-mv-p mv-nth-to-nth)
                           ()))))

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
    is-type-p-to-mv-p
    is-mv-p-loop
    bitn-bool
    mv-nth-type
;
logior-bvecp-alt len cdr-cons car-cons
logior-bvecp-alt-2
;logand-bvecp-alt
logand-bvecp-alt-2
lognot1-bvecp-alt-2
;
    ))

(defund search-for-known-types-loop (clause known-types)
  (declare (xargs :mode :program))
  (if (not clause)
    nil
    (if (listp clause)
      (append (search-for-known-types-loop (car clause) known-types)
              (search-for-known-types-loop (cdr clause) known-types))
      (let ((thm (cdr (assoc clause known-types))))
        (if thm (list thm) nil)))))

;; TODO instanciate the rule when the rule is a function
(defund search-for-known-types (id clause world stable-under-simplificationp)
  (declare (xargs :mode :program)
            (ignore id))
  (if (not stable-under-simplificationp)
    ()
    (let* ((type-thms (table-alist 'known-types world))
           (thms-to-use (search-for-known-types-loop clause type-thms)))
      (if thms-to-use
        `(:use ,@thms-to-use
          :in-theory (disable ,@thms-to-use))
        ()))))
