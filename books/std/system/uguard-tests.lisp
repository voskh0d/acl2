; Standard System Library
;
; Copyright (C) 2024 Kestrel Institute (http://www.kestrel.edu)
;
; License: A 3-clause BSD license. See the LICENSE file distributed with ACL2.
;
; Author: Alessandro Coglio (www.alessandrocoglio.info)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package "ACL2")

(include-book "uguard")

(include-book "std/testing/assert-equal" :dir :system)
(include-book "std/testing/must-succeed-star" :dir :system)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(assert-equal (uguard 'atom (w state)) *t*)

(assert-equal (uguard 'car (w state)) '(if (consp x) 't (equal x 'nil)))

(must-succeed*
 (defun f (x) (declare (xargs :guard (natp x))) x)
 (assert-equal (uguard 'f (w state)) '(natp x)))

(assert-equal (uguard '(lambda (z y) (binary-+ y (cons z '2))) (w state)) *t*)
