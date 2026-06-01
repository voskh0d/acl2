(in-package "RTL")

(set-ignore-ok t)

(defun rac-type-info (x type)
  (declare (ignore type))
  x)


(mutual-recursion
  (defund is-type-p (x type)
     (cond ((equal type '(int)) (integerp x))
           ((equal type '(bool)) (bitp x))
           ((equal (car type) 'bvec) (bvecp x (cadr type)))
           ((equal (car type) 'array) (is-array-p x (cadr type) (caddr type)))
           (t t)))
  (defund is-array-p (x type len)
    (declare (xargs :measure (+ (nfix len) (acl2-count type))))
    (if (zp len)
      t
      (and (is-type-p (ag (1- len) x) type)
           (is-array-p x type (1- len))))))

(defthm is-type-p-bvecp
  (implies (is-type-p x (cons 'bvec (cons n nil)))
           (bvecp x n))
  :hints (("Goal"
           :in-theory (enable is-type-p))))
                

;;

;(defund test ()
;  6)
;(in-theory (disable (test)))
;(defthm test-type
;  (is-type-p (test) '(bvec 32))
;  :hints (("Goal"
;           :in-theory (enable test))))
;(thm
;  (bvecp (test) 32)
;  )


;;;



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

(defthm ag-type
  (implies (and (is-type-p a (list 'array type-expr n))
                (integerp n)
                (natp i)
                (< i n))
            (is-type-p (ag i a) type-expr))
  :hints (("Goal"
           :expand (:free (x type) (is-type-p x type))
           :in-theory (enable is-type-p is-array-p-fwd))))

(defthm check-rac-array-type-subset
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
           :in-theory (enable 
                         is-array-p
                         zp
                         array-of-vec-p-does-not-change-if-set-outside-of-range-hack)
           )
          ("Subgoal *1/2.1"
           :cases ((= i (1- n)))
;           ;; We want to expand only the nth term not the n-1 !
           :expand (:free (x type) (is-array-p x type n)))))

(defthm as-keeps-type
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
           (bvecp (setbits x w i j y) w)))

(defthmd bvecp-setbitn
  (implies (integerp w)
           (bvecp (setbitn x w n y) w)))

(defthmd bvecp-int
  (implies (bvecp x n)
           (integerp x)))

;(defthmd array-of-vec-nil
;  (is-type-p nil (list 'array type n))
;  :hints (("Goal"
;           :expand (:free (type n) (is-array-p nil type n))
;           :in-theory (enable bvecp is-type-p))))


(deftheory type-theory
  '(rac-type-info
    ag-type
    as-keeps-type
    bits-bvecp
    bvecp-setbits
    bvecp-setbitn
    (natp)
    int-si
    bvecp-int
    (ainit)
;    array-of-vec-nil
    ))





;(DEFUND ARR NIL
;  (AINIT (LIST (CONS 0 2)
;                              (CONS 1 3)
;                              (CONS 2 0)
;                              (CONS 3 0)
;                              (CONS 4 0)
;                              (CONS 5 0)))
;                 )
;
;(thm
;  (implies t; (bvecp x 5)
;           (array-of-vec-p (as 3 (bits (+ x (ag 2 (arr))) 2 0)
;                                          (arr)) 6)))
;
