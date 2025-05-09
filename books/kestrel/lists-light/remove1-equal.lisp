; A lightweight book about the built-in function remove1-equal.
;
; Copyright (C) 2008-2011 Eric Smith and Stanford University
; Copyright (C) 2013-2022 Kestrel Institute
;
; License: A 3-clause BSD license. See the file books/3BSD-mod.txt.
;
; Author: Eric Smith (eric.smith@kestrel.edu)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package "ACL2")

(local (include-book "len"))

(in-theory (disable remove1-equal))

;; A simple/abbreviation rule.
(defthm remove1-equal-of-nil
  (equal (remove1-equal x nil)
         nil)
  :hints (("Goal" :in-theory (enable remove1-equal))))

(defthmd remove1-equal-when-not-consp
  (implies (not (consp l))
           (equal (remove1-equal x l)
                  nil))
  :hints (("Goal" :in-theory (enable remove1-equal))))

(defthm remove1-equal-when-not-consp-cheap
  (implies (not (consp l))
           (equal (remove1-equal x l)
                  nil))
  :rule-classes ((:rewrite :backchain-limit-lst (0)))
  :hints (("Goal" :in-theory (enable remove1-equal))))

(defthm consp-of-remove1-equal
  (equal (consp (remove1-equal x l))
         (and (consp l)
              (not (and (equal 1 (len l))
                        (equal x (car l))))))
  :hints (("Goal" :in-theory (enable remove1-equal))))

(defthm remove1-equal-of-cons
  (equal (remove1-equal x (cons y l))
         (if (equal x y)
             l
           (cons y (remove1-equal x l))))
  :hints (("Goal" :in-theory (enable remove1-equal))))

(defthm remove1-equal-of-car-same
  (equal (remove1-equal (car l) l)
         (cdr l))
  :hints (("Goal" :in-theory (enable remove1-equal))))

(defthm len-of-remove1-equal-linear
  (<= (len (remove1-equal x l))
      (len l))
  :rule-classes ((:linear :trigger-terms ((len (remove1-equal x l)))))
  :hints (("Goal" :in-theory (enable remove1-equal))))

(defthm len-of-remove1-equal-linear-2
  (<= (+ -1 (len l))
      (len (remove1-equal x l)))
  :rule-classes ((:linear :trigger-terms ((len (remove1-equal x l)))))
  :hints (("Goal" :in-theory (enable remove1-equal))))

(defthm len-of-remove1-equal
  (equal (len (remove1-equal x l))
         (if (member-equal x l)
             (+ -1 (len l))
           (len l)))
  :hints (("Goal" :in-theory (enable remove1-equal))))

(defthm true-listp-of-remove1-equal
  (implies (true-listp l)
           (true-listp (remove1-equal x l))))

(defthm true-list-fix-of-remove1-equal
  (equal (true-list-fix (remove1-equal x l))
         (remove1-equal x (true-list-fix l))))

(defthm remove1-equal-of-append
  (equal (remove1-equal x (append l1 l2))
         (if (member-equal x l1)
             (append (remove1-equal x l1)
                     l2)
           (append l1 (remove1-equal x l2)))))

(defthm not-member-equal-of-remove1-equal
  (implies (not (member-equal x l))
           (not (member-equal x (remove1-equal y l))))
  :hints (("Goal" :in-theory (enable remove1-equal))))

(defthm member-equal-of-remove1-equal-when-not-equal-iff
  (implies (not (equal a b))
           (iff (member-equal a (remove1-equal b x))
                (member-equal a x))))

(defthm no-duplicatesp-equal-of-remove1-equal
  (implies (no-duplicatesp-equal l)
           (no-duplicatesp-equal (remove1-equal x l)))
  :hints (("Goal" :in-theory (enable no-duplicatesp-equal remove1-equal))))

(defthm remove1-equal-of-remove1-equal
  (equal (remove1-equal x (remove1-equal y l))
         (remove1-equal y (remove1-equal x l)))
  :hints (("Goal" :in-theory (enable remove1-equal))))

;; Might be expensive
(defthm remove1-equal-when-not-member-equal
  (implies (not (member-equal x l))
           (equal (remove1-equal x l)
                  (true-list-fix l))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defthm <-of-acl2-count-of-remove1-equal-linear
  (implies (member-equal a x)
           (< (acl2-count (remove1-equal a x))
              (acl2-count x)))
  :rule-classes ((:linear :trigger-terms ((acl2-count (remove1-equal a x)))))
  :hints (("Goal" :in-theory (enable remove1-equal))))

(defthm <=-of-acl2-count-of-remove1-equal-linear
  (<= (acl2-count (remove1-equal a x))
      (acl2-count x))
  :rule-classes ((:linear :trigger-terms ((acl2-count (remove1-equal a x)))))
  :hints (("Goal" :in-theory (enable remove1-equal))))

(defthm equal-of-acl2-count-of-remove1-equal-and-acl2-count
  (equal (equal (acl2-count (remove1-equal a x))
                (acl2-count x))
         (if (member-equal a x)
             nil
           (equal (acl2-count (true-list-fix x)) ;simplify?
                  (acl2-count x))))
  :hints (("Goal" :use (:instance <-of-acl2-count-of-remove1-equal-linear)
           :in-theory (disable <-of-acl2-count-of-remove1-equal-linear))))
