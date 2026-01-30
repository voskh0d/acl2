(in-package "RTL")
;
;(include-book "vdot")
(include-book "projects/arm/utils/rtl-utils" :dir :system)

;(defun RAC-TYPE-INFO (x type) x)

;; TODO
;;
;; * renamed var
;; * error -> no fails / switch off
;; * CP / FGL (complex expr)
;; * assign from function ?? (declare x (bar ....))

;; DONE
;; * autres types

;Summary
;Form:  ( DEFTHM ARR-TYPE ...)
;Rules: ((:DEFINITION ARR)
;        (:EXECUTABLE-COUNTERPART AINIT)
;        (:EXECUTABLE-COUNTERPART RAC-TYPE-INFO))


;(defun RAC-TYPE-INFO (x type)
;  (declare (ignorable type))
;          x)


(include-book "fgl")
(value-triple (acl2::tshell-ensure))

:ubt here
(defund here () nil)
(set-ignore-ok t)
(include-book "../lisp/alt-const-fns-gen")
(include-book "t")

;(assign :fgl-make-ites t)
;(fgl::disable-execution as)
;(fgl::disable-execution ag)

(assign :fgl-make-ites t)
;(assign :fgl-make-ites nil)
(fgl::disable-execution as)
(fgl::disable-execution ag)
(fgl::enable-split-ifs ag)


(alt-const-fns-gen
  'foo-res
  t
'(DEFUN FOO NIL
                (LET
                 ((A (RAC-TYPE-INFO 4 '(BVEC 3)))
                  (B (RAC-TYPE-INFO 4 '(INT)))
                  (C (RAC-TYPE-INFO 4 '(LONG)))
                  (D (RAC-TYPE-INFO (FALSE$) '(BOOL)))
                  (ARR (RAC-TYPE-INFO (AINIT (LIST (CONS 0 2)
                                                   (CONS 1 3)
                                                   (CONS 2 0)
                                                   (CONS 3 0)
                                                   (CONS 4 0)
                                                   (CONS 5 0)))
                                      '(ARRAY (INT) 6)))
                  (ARR2 (RAC-TYPE-INFO (AINIT (LIST (CONS 0 2)
                                                    (CONS 1 3)
                                                    (CONS 2 0)
                                                    (CONS 3 0)
                                                    (CONS 4 0)
                                                    (CONS 5 0)))
                                       '(ARRAY (BVEC 2) 6)))
                  (ARR3 (RAC-TYPE-INFO (AINIT (LIST (CONS 0 2)
                                                    (CONS 1 3)
                                                    (CONS 2 0)
                                                    (CONS 3 0)
                                                    (CONS 4 0)
                                                    (CONS 5 0)))
                                       '(ARRAY (INT) 6)))
                  (S (RAC-TYPE-INFO (AS 'B (FALSE$) (AS 'A 3 NIL))
                                    '(STRUCT (A (INT)) (B (BOOL)))))
                  (ARRAY_OF_STRUCT
                   (RAC-TYPE-INFO
                       (AINIT (LIST (CONS 0 (AS 'B (TRUE$) (AS 'A 1 NIL)))
                                    (CONS 1 (AS 'B (FALSE$) (AS 'A 2 NIL)))))
                       '(ARRAY (STRUCT (A (INT)) (B (BOOL)))
                               2)))
                  (:ARR_OF_ARR
                       (RAC-TYPE-INFO
                            (AINIT (LIST (CONS 0
                                               (AINIT (LIST (CONS 0 0)
                                                            (CONS 1 0)
                                                            (CONS 2 0))))
                                         (CONS 1
                                               (AINIT (LIST (CONS 0 0)
                                                            (CONS 1 0)
                                                            (CONS 2 0))))))
                            '(ARRAY (ARRAY (INT) 3) 2))))
                 1))
)
;
;;(ENCAPSULATE NIL
; (DEFUNDD ARR_OF_ARR NIL
;          (RAC-TYPE-INFO (AINIT (LIST (CONS 0
;                                            (AINIT (LIST (CONS 0 0)
;                                                         (CONS 1 0)
;                                                         (CONS 2 0))))
;                                      (CONS 1
;                                            (AINIT (LIST (CONS 0 0)
;                                                         (CONS 1 0)
;                                                         (CONS 2 0))))))
;                         '(ARRAY (ARRAY (INT) 3) 2)))
; (DEFUNDD FOO-RES NIL 1)
;
; (DEFTHM-USING-FGL
;      ARR_OF_ARR-TYPE
;      (IMPLIES (MEMBER I1 '(1 0))
;               (IMPLIES (MEMBER I2 '(2 1 0))
;                        (INTEGERP (AG I2 (AG I1 (ARR_OF_ARR))))))
;      :EXPAND-FNS (ARR_OF_ARR ainit))
;
; (DEFTHMD FOO-LEMMA
;  (EQUAL (FOO-RES) (FOO))
;  :HINTS
;  (("Goal"
;       :IN-THEORY NIL
;       :DO-NOT '(PREPROCESS)
;       :CLAUSE-PROCESSOR (EXPAND-REDUCE-CP CLAUSE '(T FOO-RES ARR_OF_ARR FOO)
;                                           STATE)))))
