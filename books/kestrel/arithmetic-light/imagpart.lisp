; A lightweight book about the built-in function imagpart.
;
; Copyright (C) 2019 Kestrel Institute
;
; License: A 3-clause BSD license. See the file books/3BSD-mod.txt.
;
; Author: Eric Smith (eric.smith@kestrel.edu)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package "ACL2")

(local (include-book "complex"))
(local (include-book "plus-and-minus"))
(local (include-book "minus"))

(defthm imagpart-when-rationalp
  (implies (real/rationalp x)
           (equal (imagpart x)
                  0)))

(local
 (defthm complex-split
   (implies (acl2-numberp x)
            (equal (+ (realpart x)
                      (* #C(0 1) (imagpart x)))
                   x))
   :rule-classes nil
   :hints (("Goal" :use realpart-imagpart-elim))))

(local
 (defthmd --becomes-*-of--1
   (equal (- x)
          (* -1 x))))

(local
 (defthm commutativity-2-of-*
   (equal (* x (* y z))
          (* y (* x z)))
   :hints (("Goal" :use ((:instance associativity-of-*)
                         (:instance associativity-of-* (x y) (y x)))
            :in-theory (disable associativity-of-*)))))

(local
 (defthm *-of---arg2
   (equal (* x (- y))
          (- (* x y)))
   :hints (("Goal" :in-theory (enable --becomes-*-of--1)))))

(defthm imagpart-of--
  (equal (imagpart (- x))
         (- (imagpart x)))
  :hints (("Goal" :do-not '(generalize eliminate-destructors)
           :use ((:instance complex-split)
                 (:instance complex-split (x (- x)))
                 (:instance complex-equal
                            (x1 (realpart x))
                            (y1 (imagpart x))
                            (x2 (- (realpart (- x))))
                            (y2 (- (imagpart (- x)))))))))

(defthm imagpart-of-*-of-i
  (implies (real/rationalp x)
           (equal (imagpart (* #c(0 1) x))
                  x))
  :hints (("Goal" :do-not '(generalize eliminate-destructors)
           :in-theory (disable complex-opener imagpart-complex)
           :use ((:instance imagpart-complex (y x))
                 (:instance complex-definition (y x))))))

(defthm imagpart-of-*-when-rationalp-arg1
  (implies (real/rationalp x)
           (equal (imagpart (* x y))
                  (* x (imagpart y))))
  :hints (("Goal" :do-not '(generalize eliminate-destructors)
           :use ((:instance complex-split (x y))))))

;commuted version
(defthm imagpart-of-*-when-rationalp-arg2
  (implies (real/rationalp y)
           (equal (imagpart (* x y))
                  (* y (imagpart x))))
  :hints (("Goal" :do-not '(generalize eliminate-destructors)
           :in-theory (disable imagpart-of-*-when-rationalp-arg1)
           :use (:instance imagpart-of-*-when-rationalp-arg1
                           (x y)
                           (y x)))))
