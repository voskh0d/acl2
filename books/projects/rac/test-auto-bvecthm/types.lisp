(in-package "RTL")

(set-ignore-ok t)

(defun rac-type-info (x type)
  (declare (ignore type))
  x)

(defun array-of-vec-p (x i vec-size)
  (if (zp i)
    t
    (and (bvecp (ag (1- i) x) vec-size)
         (array-of-vec-p x (1- i) vec-size))))


(defthm ag-type
  (implies (and (array-of-vec-p a n vec-size)
                (integerp n)
                (natp i)
                (< i n))
           (bvecp (ag i a) vec-size))
  :hints (("Goal"
           :in-theory (enable zp))))

(defthm check-rac-array-type-subset
  (implies (and (array-of-vec-p a n vec-size)
                (< i n)
                (integerp n)
                (natp i))
           (array-of-vec-p a i vec-size))
  :hints (("Goal"
           :in-theory (enable zp))))

(defthmd array-of-vec-p-does-not-change-if-set-outside-of-range
  (implies (and (>= i n))
           (equal (array-of-vec-p (as i x a) n vec-size)
                  (array-of-vec-p a n vec-size))))

(defthm as-keeps-type
  (implies (and (array-of-vec-p a n vec-size)
                (bvecp x vec-size)
                (integerp n)
                (< i n))
           (array-of-vec-p (as i x a) n vec-size))
  :hints (("Goal"
           :in-theory (enable array-of-vec-p-does-not-change-if-set-outside-of-range))
          ("Subgoal *1/6"
           :cases ((= i (- n 1))))))

(defthmd bvecp-setbits
  (implies (integerp w)
           (bvecp (setbits x w i j y) w)))

(defthmd bvecp-setbitn
  (implies (integerp w)
           (bvecp (setbitn x w n y) w)))

(defthmd bvecp-int
  (implies (bvecp x n)
           (integerp x)))

(defthmd array-of-vec-nil
  (array-of-vec-p 'nil i n)
  :hints (("Goal"
           :in-theory (enable bvecp))))


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
    array-of-vec-nil))





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
