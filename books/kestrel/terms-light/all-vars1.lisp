; Rules about the built-in function all-vars1
;
; Copyright (C) 2024 Kestrel Institute
;
; License: A 3-clause BSD license. See the file books/3BSD-mod.txt.
;
; Author: Eric Smith (eric.smith@kestrel.edu)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package "ACL2")

;; See free-vars-in-term.lisp for a simpler function than all-vars1, including
;; rules that connect it to all-vars1.

(local (include-book "tools/flag" :dir :system))
(local (include-book "kestrel/lists-light/subsetp-equal" :dir :system))

(in-theory (disable all-vars1))

(local (make-flag all-vars1))

(defthm-flag-all-vars1
  (defthm subsetp-equal-of-all-vars1-same
    (subsetp-equal ans (all-vars1 term ans))
    :flag all-vars1)
  (defthm subsetp-equal-of-all-vars1-lst-same
    (subsetp-equal ans (all-vars1-lst lst ans))
    :flag all-vars1-lst)
  :hints (("Goal" :in-theory (enable all-vars1))))

(defthm subsetp-equal-of-all-vars1-when-subsetp-equal-arg2
  (implies (subsetp-equal x ans)
           (subsetp-equal x (all-vars1 term ans))))

(defthm subsetp-equal-of-all-vars1-lst-when-subsetp-equal-arg2
  (implies (subsetp-equal x ans)
           (subsetp-equal x (all-vars1-lst terms ans))))

(defthm-flag-all-vars1
  (defthm true-listp-of-all-vars1
    (implies (true-listp ans)
             (true-listp (all-vars1 term ans)))
    :flag all-vars1)
  (defthm true-listp-of-all-vars1-lst
    (implies (true-listp ans)
             (true-listp (all-vars1-lst lst ans)))
    :flag all-vars1-lst)
  :hints (("Goal" :in-theory (enable all-vars1))))

(defthm-flag-all-vars1
  (defthm symbol-listp-of-all-vars1
    (implies (and (pseudo-termp term)
                  (symbol-listp ans))
             (symbol-listp (all-vars1 term ans)))
    :flag all-vars1)
  (defthm symbol-listp-of-all-vars1-lst
    (implies (and (pseudo-term-listp lst)
                  (symbol-listp ans))
             (symbol-listp (all-vars1-lst lst ans)))
    :flag all-vars1-lst)
  :hints (("Goal" :in-theory (enable all-vars1))))
