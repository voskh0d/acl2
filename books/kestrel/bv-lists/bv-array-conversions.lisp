; Conversions between lists and bv-arrays
;
; Copyright (C) 2008-2011 Eric Smith and Stanford University
; Copyright (C) 2013-2024 Kestrel Institute
;
; License: A 3-clause BSD license. See the file books/3BSD-mod.txt.
;
; Author: Eric Smith (eric.smith@kestrel.edu)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package "ACL2")

(include-book "bv-arrays")
(include-book "kestrel/utilities/defopeners" :dir :system)
(local (include-book "all-unsigned-byte-p2"))
;(local (include-book "all-unsigned-byte-p"))
(local (include-book "kestrel/lists-light/cons" :dir :system))
(local (include-book "kestrel/lists-light/len" :dir :system))
(local (include-book "kestrel/lists-light/nthcdr" :dir :system))
(local (include-book "kestrel/utilities/equal-of-booleans" :dir :system))
(local (include-book "kestrel/bv/unsigned-byte-p" :dir :system))

;; See also bv-array-conversions2.lisp and bv-array-conversions-gen.lisp.

(defund list-to-bv-array-aux (element-size elements-left total-length lst)
  (declare (xargs :guard (and (natp element-size)
                              (natp elements-left)
                              (natp total-length)
                              (true-listp lst))))
  (if (zp elements-left)
      (repeat total-length 0) ;the constant array of all zero's
    (let ((current-element-number (+ -1 elements-left)))
      (bv-array-write element-size
                      total-length
                      current-element-number
                      (nth current-element-number lst)
                      (list-to-bv-array-aux element-size (+ -1 elements-left) total-length lst)))))

(defthm list-to-bv-array-aux-unroll
  (implies (not (zp elements-left))
           (equal (list-to-bv-array-aux element-size elements-left total-length lst)
                  (let ((current-element-number (+ -1 elements-left)))
                    (bv-array-write element-size
                                   total-length
                                   current-element-number
                                   (nth current-element-number lst)
                                   (list-to-bv-array-aux element-size (+ -1 elements-left) total-length lst)))))
  :hints (("Goal" :in-theory (enable list-to-bv-array-aux))))

(defthm list-to-bv-array-aux-base
  (implies (zp elements-left)
           (equal (list-to-bv-array-aux element-size elements-left total-length lst)
                  (repeat total-length 0)))
  :hints (("Goal" :in-theory (enable list-to-bv-array-aux))))

(defthm len-of-list-to-bv-array-aux
  (equal (len (list-to-bv-array-aux esize eleft len lst))
         (nfix len))
  :hints (("Goal" :in-theory (enable list-to-bv-array-aux))))

(defthm all-unsigned-byte-p-of-list-to-bv-array-aux
  (implies (natp width)
           (all-unsigned-byte-p width (list-to-bv-array-aux width elements-left total-len x)))
  :hints (("Goal" :in-theory (enable list-to-bv-array-aux))))

;converts a list (e.g., a nest of conses) to an array (a nest of bv-array-write calls)
;often this will just be a no-op, but it helps us compare a spec expressed as a list with an implementation expressed as an array

(defund list-to-bv-array (element-size lst)
  (declare (xargs :guard (and (natp element-size)
                              (true-listp lst))))
  (let ((len (len lst)))
    (list-to-bv-array-aux element-size len len lst)))

(defthm len-of-list-to-bv-array
  (equal (len (list-to-bv-array esize lst))
         (len lst))
  :hints (("Goal" :in-theory (enable list-to-bv-array))))

;; (thm
;;  (equal (BV-ARRAY-READ '32 '44 n (LIST-TO-BV-ARRAY '32 lst))
;;         (bvchop 32 (nth n lst))))

(defthm all-unsigned-byte-p-of-list-to-bv-array
  (implies (natp width)
           (all-unsigned-byte-p width (list-to-bv-array width x)))
  :hints (("Goal" :in-theory (enable list-to-bv-array))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Convert an array of bit-vectors to a list:
(defund bv-array-to-list-aux (size len i arr)
  (declare (xargs :measure (+ 1 (nfix (- (nfix len) i)))
                  :guard (and (natp i)
                              (natp len)
                              (natp size)
                              (bv-arrayp size (len arr) arr))))
  (if (or (not (natp i))
          (not (natp len))
          (>= i len))
      nil
    (cons (bv-array-read size len i arr)
          (bv-array-to-list-aux size len (+ 1 i) arr))))

(defthm len-of-bv-array-to-list-aux
  (implies (and (natp len)
                (natp i)
                (natp width)
                (<= i len))
           (equal (len (bv-array-to-list-aux width len i x))
                  (- len i)))
  :hints (("Goal" :in-theory (enable bv-array-to-list-aux))))

(local
 (defun ind (size len i arr n)
   (declare (xargs :measure (+ 1 (nfix (- (nfix len) i)))))
   (if (or (not (natp i))
           (not (natp len))
           (>= i len))
       (list size len i arr n)
     (cons (bv-array-read size len i arr)
           (ind size len (+ 1 i) arr (+ -1 n))))))

(defthm nth-of-bv-array-to-list-aux
  (implies (and (natp len)
                (natp i)
                (natp n)
                (natp width)
                (< n (- len i)))
           (equal (nth n (bv-array-to-list-aux width len i x))
                  (bv-array-read width len (+ n i) x)))
  :hints (("Goal" :in-theory (e/d (bv-array-to-list-aux
                                   nth) (;NTH-OF-CDR
                                         ))
           :induct (ind size len i arr n)
           :do-not '(generalize eliminate-destructors))))

(defthm integer-listp-of-bv-array-to-list-aux
  (integer-listp (bv-array-to-list-aux size len i arr))
  :hints (("Goal" :in-theory (enable bv-array-to-list-aux))))

(defthm all-unsigned-byte-p-of-bv-array-to-list-aux
  (implies (natp width)
           (all-unsigned-byte-p width (bv-array-to-list-aux width len i y)))
  :hints (("Goal" :in-theory (enable bv-array-to-list-aux))))

(defthm car-of-bv-array-to-list-aux
  (implies (and (natp i)
                (< i len)
                (equal len (len arr)))
           (equal (car (bv-array-to-list-aux size len i arr))
                  (bv-array-read size len i arr)))
  :hints (("Goal" :in-theory (enable bv-array-to-list-aux))))

(defthm consp-of-bv-array-to-list-aux
  (implies (and (natp i)
                (natp len))
           (equal (consp (bv-array-to-list-aux size len i arr))
                  (< i len)))
  :hints (("Goal" :in-theory (enable bv-array-to-list-aux))))

(defthm bv-array-to-list-aux-iff
  (implies (and (natp i)
                (natp len))
           (iff (bv-array-to-list-aux size len i arr)
                (< i len)))
  :hints (("Goal" :in-theory (enable bv-array-to-list-aux))))

(defthm cdr-of-bv-array-to-list-aux
  (implies (and (equal len (len arr))
                (< i len)
                (natp i))
           (equal (cdr (bv-array-to-list-aux size len i arr))
                  (bv-array-to-list-aux size (+ -1 len) i (cdr arr))))
  :hints (("Goal" :do-not '(generalize eliminate-destructors)
;           :induct (bv-array-to-list-aux size len i arr)
           :in-theory (enable bv-array-to-list-aux))))

(DEFTHMd BV-ARRAY-TO-LIST-AUX-BECOMES-NTHCDR-2
  (IMPLIES (AND ;(TRUE-LISTP ARRAY)
                (NATP WIDTH)
                (NATP I)
                (<= I LEN)
                (EQUAL LEN (LEN ARRAY))
;                                     (ALL-UNSIGNED-BYTE-P WIDTH ARRAY)
                )
           (EQUAL (BV-ARRAY-TO-LIST-AUX WIDTH LEN I ARRAY)
                  (NTHCDR I (bvchop-list width ARRAY))))
  :HINTS (("Goal" :IN-THEORY (ENABLE BV-ARRAY-TO-LIST-AUX bv-array-read cdr-of-nthcdr))))

;should we pass in the length too (can't really ask an array for its length)?
(defund bv-array-to-list (size arr)
  (declare (xargs :guard (and (natp size)
                              (bv-arrayp size (len arr) arr))))
  (bv-array-to-list-aux size (len arr) 0 arr))

(defthm len-of-BV-ARRAY-TO-LIST
  (implies (natp width)
           (equal (LEN (BV-ARRAY-TO-LIST width L))
                  (len l)))
  :hints (("Goal" :in-theory (enable BV-ARRAY-TO-LIST))))

(defthm consp-of-bv-array-to-list
  (equal (consp (bv-array-to-list width l))
         (consp l))
  :hints (("Goal" :in-theory (enable bv-array-to-list))))

;drop?
(defthm endp-of-bv-array-to-list
  (equal (endp (bv-array-to-list width l))
         (endp l))
  :hints (("Goal" :in-theory (enable bv-array-to-list))))

(defthm integer-listp-of-bv-array-to-list
  (implies (natp width)
           (integer-listp (bv-array-to-list width arr)))
  :hints (("Goal" :in-theory (enable bv-array-to-list))))

(defthm car-of-BV-ARRAY-TO-LIST
  (implies (and (consp arr) ;drop?
                (natp width))
           (equal (CAR (BV-ARRAY-TO-LIST width ARR))
                  (BV-ARRAY-READ width (LEN ARR) 0 ARR)))
  :hints (("Goal" :expand (BV-ARRAY-TO-LIST-AUX width (LEN ARR)
                                                0 ARR)
           :in-theory (enable BV-ARRAY-TO-LIST BV-ARRAY-TO-LIST-AUX))))

(defthm nth-of-BV-ARRAY-TO-LIST
  (implies (and (natp n)
                (natp width)
                (< n (len arr)))
           (equal (NTH n (BV-ARRAY-TO-LIST width ARR))
                  (BV-ARRAY-READ width (LEN ARR) n ARR)))
  :hints (("Goal" :in-theory (enable BV-ARRAY-TO-LIST))))

(defthm all-unsigned-byte-p-of-bv-array-to-list
  (implies (natp width)
           (all-unsigned-byte-p width (bv-array-to-list width y)))
  :hints (("Goal" :in-theory (enable bv-array-to-list))))

(defthmd cdr-of-bv-array-to-list
  (equal (cdr (bv-array-to-list width bytes))
         (bv-array-to-list width (cdr bytes)))
  :hints (("Goal" :in-theory (enable bv-array-to-list))))

;move
(DEFTHMd BV-ARRAY-TO-LIST-DOES-NOTHING-2
  (IMPLIES (AND; (TRUE-LISTP LST)
                (NATP WIDTH)
;                (ALL-UNSIGNED-BYTE-P WIDTH LST)
                )
           (EQUAL (BV-ARRAY-TO-LIST WIDTH LST)
                  (bvchop-list width LST)))
  :HINTS (("Goal" :IN-THEORY (ENABLE BV-ARRAY-TO-LIST
                                     BV-ARRAY-TO-LIST-AUX-BECOMES-NTHCDR-2))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defund list-to-byte-array (lst)
  (declare (xargs :guard (true-listp lst)))
  (list-to-bv-array 8 lst))

(defthm bv-array-read-of-list-to-bv-array-aux
  (implies (and (< n elements-left) ;main hyp
                (natp n)
                (natp total-len)
                (natp elements-left)
                (<= elements-left total-len)
                (< n total-len)
                (natp width))
           (equal (bv-array-read width total-len n (list-to-bv-array-aux width elements-left total-len x))
                  (bv-array-read width total-len n x)))
  :hints (("Goal" :do-not '(generalize eliminate-destructors)
           :induct (list-to-bv-array-aux width elements-left total-len x)
           :in-theory (enable bv-array-read bv-array-read-of-bv-array-write-both-better list-to-bv-array-aux))))

(defthm bv-array-read-of-list-to-bv-array
  (implies (and (natp n)
                (natp width)
                (< n (len x)))
           (equal (bv-array-read width (len x) n (list-to-bv-array width x))
                  (bv-array-read width (len x) n x)))
  :hints (("Goal"
           :in-theory (e/d (list-to-bv-array) (list-to-bv-array-aux-unroll)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defopeners bv-array-to-list-aux)
