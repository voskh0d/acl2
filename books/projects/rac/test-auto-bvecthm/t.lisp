(IN-PACKAGE "RTL")

(INCLUDE-BOOK "rtl/rel11/lib/rac" :DIR :SYSTEM)

(SET-IGNORE-OK T)

(SET-IRRELEVANT-FORMALS-OK T)

(DEFUND FOO NIL
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
           (RAC-TYPE-INFO (AINIT (LIST (CONS 0 (AS 'B (TRUE$) (AS 'A 1 NIL)))
                                       (CONS 1 (AS 'B (FALSE$) (AS 'A 2 NIL)))))
                          '(ARRAY (STRUCT (A (INT)) (B (BOOL)))
                                  2)))
      (ARR_OF_ARR (RAC-TYPE-INFO (AINIT (LIST (CONS 0
                                                    (AINIT (LIST (CONS 0 0)
                                                                 (CONS 1 0)
                                                                 (CONS 2 0))))
                                              (CONS 1
                                                    (AINIT (LIST (CONS 0 0)
                                                                 (CONS 1 0)
                                                                 (CONS 2 0))))))
                                 '(ARRAY (ARRAY (INT) 3) 2))))
    1))

