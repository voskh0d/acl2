(IN-PACKAGE "RTL")

(INCLUDE-BOOK "rtl/rel11/lib/rac" :DIR :SYSTEM)

(SET-IGNORE-OK T)

(SET-IRRELEVANT-FORMALS-OK T)

(DEFUND CLZ64-LOOP-0 (I N K C Z)
        (DECLARE (XARGS :MEASURE (NFIX (- N I))))
        (IF (AND (INTEGERP I) (INTEGERP N) (< I N))
            (LET* ((C (AS I
                          (BITS (IF1 (AG (+ (* 2 I) 1) Z)
                                     (AG (* 2 I) C)
                                     (AG (+ (* 2 I) 1) C))
                                5 0)
                          C))
                   (C (AS I
                          (SETBITN (AG I C)
                                   6 K (AG (+ (* 2 I) 1) Z))
                          C))
                   (Z (AS I
                          (LOGAND1 (AG (+ (* 2 I) 1) Z)
                                   (AG (* 2 I) Z))
                          Z)))
                  (CLZ64-LOOP-0 (+ I 1) N K C Z))
            (MV C Z)))

(DEFUND CLZ64-LOOP-1 (K N C Z)
        (DECLARE (XARGS :MEASURE (NFIX (- 6 K))))
        (IF (AND (INTEGERP K) (< K 6))
            (LET ((N (FLOOR N 2)))
                 (MV-LET (C Z)
                         (CLZ64-LOOP-0 0 N K C Z)
                         (CLZ64-LOOP-1 (+ K 1) N C Z)))
            (MV N C Z)))

(DEFUND CLZ64-LOOP-2 (I X Z C)
        (DECLARE (XARGS :MEASURE (NFIX (- 64 I))))
        (IF (AND (INTEGERP I) (< I 64))
            (LET ((Z (AS I (LOGNOT1 (BITN X I)) Z))
                  (C (AS I (BITS 0 5 0) C)))
                 (CLZ64-LOOP-2 (+ I 1) X Z C))
            (MV Z C)))

(DEFUND CLZ64 (X)
        (LET ((Z NIL) (C NIL))
             (MV-LET (Z C)
                     (CLZ64-LOOP-2 0 X Z C)
                     (LET ((N 64))
                          (MV-LET (N C Z)
                                  (CLZ64-LOOP-1 0 N C Z)
                                  (AG 0 C))))))

(DEFUND ISPOW2-LOOP-0 (I A RESULT)
        (DECLARE (XARGS :MEASURE (NFIX (- 6 I))))
        (IF (AND (INTEGERP I) (< I 6))
            (LET ((RESULT (LOGAND1 RESULT (BITN (AG I A) 0))))
                 (ISPOW2-LOOP-0 (+ I 1) A RESULT))
            RESULT))

(DEFUND ISPOW2-LOOP-1 (J I W A)
        (DECLARE (XARGS :MEASURE (NFIX (- I J))))
        (IF (AND (INTEGERP J) (INTEGERP I) (< J I))
            (LET ((A (AS J
                         (BITS (LOGIOR (AG J A) (ASH (AG J A) (- W)))
                               63 0)
                         A)))
                 (ISPOW2-LOOP-1 (+ J 1) I W A))
            A))

(DEFUND ISPOW2-LOOP-2 (I W A V)
        (DECLARE (XARGS :MEASURE (NFIX (- 6 I))))
        (IF (AND (INTEGERP I) (< I 6))
            (LET* ((W (FLOOR W 2))
                   (A (ISPOW2-LOOP-1 0 I W A))
                   (A (AS I (BITS (LOGXOR V (ASH V (- W))) 63 0)
                          A))
                   (V (BITS (LOGIOR V (ASH V (- W))) 63 0)))
                  (ISPOW2-LOOP-2 (+ I 1) W A V))
            (MV W A V)))

(DEFUND ISPOW2 (X ISNEG)
        (LET* ((Z 0)
               (Z (IF1 ISNEG (BITS (LOGXOR (ASH X 1) X) 63 0)
                       X))
               (W 64)
               (V Z)
               (A NIL))
              (MV-LET (W A V)
                      (ISPOW2-LOOP-2 0 W A V)
                      (LET ((RESULT (TRUE$)))
                           (ISPOW2-LOOP-0 0 A RESULT)))))

(DEFUND DIVPOW2 (ARG SGNQ SHFT)
        (IF1 SGNQ
             (LET* ((PADA (BITS (ASH ARG 64) 127 0))
                    (SHFTA (BITS (ASH (SI PADA 128) (- SHFT))
                                 127 0)))
                   (IF1 (LOG= (BITS SHFTA 63 0) 0)
                        (BITS SHFTA 127 64)
                        (BITS (+ (BITS SHFTA 127 64) 1) 63 0)))
             (BITS (ASH ARG (- SHFT)) 63 0)))

(DEFUND COMPAREOPS (OPA OPB SGNA SGNB INT32)
        (LET* ((CIN (LOGIOR1 SGNA (LOGNOT1 SGNB)))
               (SUM (LOGXOR (BITS (LOGNOT OPA) 63 0)
                            (BITS (LOGNOT OPB) 63 0)))
               (CAR (BITS (ASH (LOGAND (BITS (LOGNOT OPA) 63 0)
                                       (BITS (LOGNOT OPB) 63 0))
                               1)
                          63 0))
               (CAR (IF1 INT32 (SETBITN CAR 64 32 1)
                         (SETBITN CAR 64 0 1)))
               (ARGA (BITS (IF1 (LOGAND1 SGNA (LOGNOT1 SGNB))
                                SUM (IF1 SGNA (LOGNOT OPA) OPA))
                           63 0))
               (ARGB (BITS (IF1 (LOGAND1 SGNA (LOGNOT1 SGNB))
                                CAR (IF1 SGNB OPB (LOGNOT OPB)))
                           63 0)))
              (MV-LET (ARGA ARGB)
                      (IF1 INT32
                           (MV (SETBITS ARGA 64 31 0 0)
                               (SETBITS ARGB 64 31 0 4294967295))
                           (MV ARGA ARGB))
                      (LET ((DIFF (BITS (+ (+ ARGA ARGB) CIN) 64 0)))
                           (LOGNOT1 (BITN DIFF 64))))))

(DEFUND COMPUTECMPCONST (DIVTOP)
        (LET ((A NIL))
             (CASE (BITS DIVTOP 5 1)
                   (0 (LET* ((A (AS 7
                                    (BITS (IF1 (BITN DIVTOP 0) 909 911) 9 0)
                                    A))
                             (A (AS 6 (BITS 942 9 0) A))
                             (A (AS 5 (BITS 974 9 0) A))
                             (A (AS 4 (BITS 1008 9 0) A))
                             (A (AS 3 (BITS 16 9 0) A))
                             (A (AS 2 (BITS 48 9 0) A))
                             (A (AS 1 (BITS 81 9 0) A)))
                            (AS 0
                                (BITS (IF1 (BITN DIVTOP 0) 114 112) 9 0)
                                A)))
                   (1 (LET* ((A (AS 7
                                    (BITS (IF1 (BITN DIVTOP 0) 906 907) 9 0)
                                    A))
                             (A (AS 6 (BITS 940 9 0) A))
                             (A (AS 5 (BITS 974 9 0) A))
                             (A (AS 4 (BITS 1008 9 0) A))
                             (A (AS 3 (BITS 16 9 0) A))
                             (A (AS 2 (BITS 50 9 0) A))
                             (A (AS 1 (BITS 83 9 0) A)))
                            (AS 0
                                (BITS (IF1 (BITN DIVTOP 0) 117 116) 9 0)
                                A)))
                   (2 (LET* ((A (AS 7 (BITS 903 9 0) A))
                             (A (AS 6 (BITS 938 9 0) A))
                             (A (AS 5 (BITS 972 9 0) A))
                             (A (AS 4 (BITS 1008 9 0) A))
                             (A (AS 3 (BITS 16 9 0) A))
                             (A (AS 2 (BITS 52 9 0) A))
                             (A (AS 1 (BITS 86 9 0) A)))
                            (AS 0 (BITS 120 9 0) A)))
                   (3 (LET* ((A (AS 7 (BITS 899 9 0) A))
                             (A (AS 6 (BITS 934 9 0) A))
                             (A (AS 5 (BITS 970 9 0) A))
                             (A (AS 4 (BITS 1006 9 0) A))
                             (A (AS 3 (BITS 18 9 0) A))
                             (A (AS 2 (BITS 54 9 0) A))
                             (A (AS 1 (BITS 88 9 0) A)))
                            (AS 0 (BITS 124 9 0) A)))
                   (4 (LET* ((A (AS 7 (BITS 896 9 0) A))
                             (A (AS 6 (BITS 932 9 0) A))
                             (A (AS 5 (BITS 970 9 0) A))
                             (A (AS 4 (BITS 1006 9 0) A))
                             (A (AS 3 (BITS 18 9 0) A))
                             (A (AS 2 (BITS 54 9 0) A))
                             (A (AS 1 (BITS 90 9 0) A)))
                            (AS 0 (BITS 127 9 0) A)))
                   (5 (LET* ((A (AS 7 (BITS 892 9 0) A))
                             (A (AS 6 (BITS 930 9 0) A))
                             (A (AS 5 (BITS 968 9 0) A))
                             (A (AS 4 (BITS 1006 9 0) A))
                             (A (AS 3 (BITS 18 9 0) A))
                             (A (AS 2 (BITS 56 9 0) A))
                             (A (AS 1 (BITS 94 9 0) A)))
                            (AS 0 (BITS 131 9 0) A)))
                   (6 (LET* ((A (AS 7 (BITS 889 9 0) A))
                             (A (AS 6 (BITS 928 9 0) A))
                             (A (AS 5 (BITS 966 9 0) A))
                             (A (AS 4 (BITS 1006 9 0) A))
                             (A (AS 3 (BITS 18 9 0) A))
                             (A (AS 2 (BITS 58 9 0) A))
                             (A (AS 1 (BITS 96 9 0) A)))
                            (AS 0 (BITS 134 9 0) A)))
                   (7 (LET* ((A (AS 7 (BITS 885 9 0) A))
                             (A (AS 6 (BITS 924 9 0) A))
                             (A (AS 5 (BITS 964 9 0) A))
                             (A (AS 4 (BITS 1004 9 0) A))
                             (A (AS 3 (BITS 20 9 0) A))
                             (A (AS 2 (BITS 60 9 0) A))
                             (A (AS 1 (BITS 98 9 0) A)))
                            (AS 0 (BITS 138 9 0) A)))
                   (8 (LET* ((A (AS 7 (BITS 882 9 0) A))
                             (A (AS 6 (BITS 922 9 0) A))
                             (A (AS 5 (BITS 964 9 0) A))
                             (A (AS 4 (BITS 1004 9 0) A))
                             (A (AS 3 (BITS 20 9 0) A))
                             (A (AS 2 (BITS 60 9 0) A))
                             (A (AS 1 (BITS 100 9 0) A)))
                            (AS 0 (BITS 141 9 0) A)))
                   (9 (LET* ((A (AS 7 (BITS 878 9 0) A))
                             (A (AS 6 (BITS 920 9 0) A))
                             (A (AS 5 (BITS 962 9 0) A))
                             (A (AS 4 (BITS 1004 9 0) A))
                             (A (AS 3 (BITS 20 9 0) A))
                             (A (AS 2 (BITS 62 9 0) A))
                             (A (AS 1 (BITS 104 9 0) A)))
                            (AS 0 (BITS 144 9 0) A)))
                   (10 (LET* ((A (AS 7 (BITS 874 9 0) A))
                              (A (AS 6 (BITS 918 9 0) A))
                              (A (AS 5 (BITS 960 9 0) A))
                              (A (AS 4 (BITS 1004 9 0) A))
                              (A (AS 3 (BITS 20 9 0) A))
                              (A (AS 2 (BITS 64 9 0) A))
                              (A (AS 1 (BITS 106 9 0) A)))
                             (AS 0 (BITS 148 9 0) A)))
                   (11 (LET* ((A (AS 7 (BITS 872 9 0) A))
                              (A (AS 6 (BITS 916 9 0) A))
                              (A (AS 5 (BITS 960 9 0) A))
                              (A (AS 4 (BITS 1004 9 0) A))
                              (A (AS 3 (BITS 20 9 0) A))
                              (A (AS 2 (BITS 64 9 0) A))
                              (A (AS 1 (BITS 108 9 0) A)))
                             (AS 0 (BITS 152 9 0) A)))
                   (12 (LET* ((A (AS 7 (BITS 868 9 0) A))
                              (A (AS 6 (BITS 912 9 0) A))
                              (A (AS 5 (BITS 958 9 0) A))
                              (A (AS 4 (BITS 1002 9 0) A))
                              (A (AS 3 (BITS 22 9 0) A))
                              (A (AS 2 (BITS 66 9 0) A))
                              (A (AS 1 (BITS 112 9 0) A)))
                             (AS 0 (BITS 156 9 0) A)))
                   (13 (LET* ((A (AS 7 (BITS 864 9 0) A))
                              (A (AS 6 (BITS 910 9 0) A))
                              (A (AS 5 (BITS 956 9 0) A))
                              (A (AS 4 (BITS 1002 9 0) A))
                              (A (AS 3 (BITS 22 9 0) A))
                              (A (AS 2 (BITS 68 9 0) A))
                              (A (AS 1 (BITS 114 9 0) A)))
                             (AS 0 (BITS 158 9 0) A)))
                   (14 (LET* ((A (AS 7 (BITS 860 9 0) A))
                              (A (AS 6 (BITS 908 9 0) A))
                              (A (AS 5 (BITS 954 9 0) A))
                              (A (AS 4 (BITS 1000 9 0) A))
                              (A (AS 3 (BITS 24 9 0) A))
                              (A (AS 2 (BITS 70 9 0) A))
                              (A (AS 1 (BITS 116 9 0) A)))
                             (AS 0 (BITS 162 9 0) A)))
                   (15 (LET* ((A (AS 7 (BITS 858 9 0) A))
                              (A (AS 6 (BITS 906 9 0) A))
                              (A (AS 5 (BITS 954 9 0) A))
                              (A (AS 4 (BITS 1000 9 0) A))
                              (A (AS 3 (BITS 24 9 0) A))
                              (A (AS 2 (BITS 70 9 0) A))
                              (A (AS 1 (BITS 118 9 0) A)))
                             (AS 0 (BITS 166 9 0) A)))
                   (16 (LET* ((A (AS 7 (BITS 854 9 0) A))
                              (A (AS 6 (BITS 904 9 0) A))
                              (A (AS 5 (BITS 952 9 0) A))
                              (A (AS 4 (BITS 1000 9 0) A))
                              (A (AS 3 (BITS 24 9 0) A))
                              (A (AS 2 (BITS 72 9 0) A))
                              (A (AS 1 (BITS 120 9 0) A)))
                             (AS 0 (BITS 170 9 0) A)))
                   (17 (LET* ((A (AS 7 (BITS 851 9 0) A))
                              (A (AS 6 (BITS 900 9 0) A))
                              (A (AS 5 (BITS 951 9 0) A))
                              (A (AS 4 (BITS 1000 9 0) A))
                              (A (AS 3 (BITS 24 9 0) A))
                              (A (AS 2 (BITS 72 9 0) A))
                              (A (AS 1 (BITS 124 9 0) A)))
                             (AS 0 (BITS 172 9 0) A)))
                   (18 (LET* ((A (AS 7 (BITS 848 9 0) A))
                              (A (AS 6 (BITS 898 9 0) A))
                              (A (AS 5 (BITS 948 9 0) A))
                              (A (AS 4 (BITS 1000 9 0) A))
                              (A (AS 3 (BITS 24 9 0) A))
                              (A (AS 2 (BITS 76 9 0) A))
                              (A (AS 1 (BITS 124 9 0) A)))
                             (AS 0 (BITS 176 9 0) A)))
                   (19 (LET* ((A (AS 7 (BITS 844 9 0) A))
                              (A (AS 6 (BITS 896 9 0) A))
                              (A (AS 5 (BITS 948 9 0) A))
                              (A (AS 4 (BITS 1000 9 0) A))
                              (A (AS 3 (BITS 24 9 0) A))
                              (A (AS 2 (BITS 76 9 0) A))
                              (A (AS 1 (BITS 128 9 0) A)))
                             (AS 0 (BITS 180 9 0) A)))
                   (20 (LET* ((A (AS 7 (BITS 840 9 0) A))
                              (A (AS 6 (BITS 892 9 0) A))
                              (A (AS 5 (BITS 946 9 0) A))
                              (A (AS 4 (BITS 1000 9 0) A))
                              (A (AS 3 (BITS 24 9 0) A))
                              (A (AS 2 (BITS 78 9 0) A))
                              (A (AS 1 (BITS 132 9 0) A)))
                             (AS 0 (BITS 184 9 0) A)))
                   (21 (LET* ((A (AS 7 (BITS 836 9 0) A))
                              (A (AS 6 (BITS 890 9 0) A))
                              (A (AS 5 (BITS 944 9 0) A))
                              (A (AS 4 (BITS 996 9 0) A))
                              (A (AS 3 (BITS 28 9 0) A))
                              (A (AS 2 (BITS 80 9 0) A))
                              (A (AS 1 (BITS 134 9 0) A)))
                             (AS 0 (BITS 188 9 0) A)))
                   (22 (LET* ((A (AS 7 (BITS 834 9 0) A))
                              (A (AS 6 (BITS 888 9 0) A))
                              (A (AS 5 (BITS 942 9 0) A))
                              (A (AS 4 (BITS 996 9 0) A))
                              (A (AS 3 (BITS 28 9 0) A))
                              (A (AS 2 (BITS 82 9 0) A))
                              (A (AS 1 (BITS 136 9 0) A)))
                             (AS 0 (BITS 190 9 0) A)))
                   (23 (LET* ((A (AS 7 (BITS 830 9 0) A))
                              (A (AS 6 (BITS 886 9 0) A))
                              (A (AS 5 (BITS 942 9 0) A))
                              (A (AS 4 (BITS 996 9 0) A))
                              (A (AS 3 (BITS 28 9 0) A))
                              (A (AS 2 (BITS 82 9 0) A))
                              (A (AS 1 (BITS 138 9 0) A)))
                             (AS 0 (BITS 194 9 0) A)))
                   (24 (LET* ((A (AS 7 (BITS 826 9 0) A))
                              (A (AS 6 (BITS 884 9 0) A))
                              (A (AS 5 (BITS 940 9 0) A))
                              (A (AS 4 (BITS 996 9 0) A))
                              (A (AS 3 (BITS 28 9 0) A))
                              (A (AS 2 (BITS 84 9 0) A))
                              (A (AS 1 (BITS 140 9 0) A)))
                             (AS 0 (BITS 198 9 0) A)))
                   (25 (LET* ((A (AS 7 (BITS 824 9 0) A))
                              (A (AS 6 (BITS 882 9 0) A))
                              (A (AS 5 (BITS 940 9 0) A))
                              (A (AS 4 (BITS 996 9 0) A))
                              (A (AS 3 (BITS 28 9 0) A))
                              (A (AS 2 (BITS 84 9 0) A))
                              (A (AS 1 (BITS 142 9 0) A)))
                             (AS 0 (BITS 200 9 0) A)))
                   (26 (LET* ((A (AS 7 (BITS 820 9 0) A))
                              (A (AS 6 (BITS 878 9 0) A))
                              (A (AS 5 (BITS 938 9 0) A))
                              (A (AS 4 (BITS 996 9 0) A))
                              (A (AS 3 (BITS 28 9 0) A))
                              (A (AS 2 (BITS 86 9 0) A))
                              (A (AS 1 (BITS 146 9 0) A)))
                             (AS 0 (BITS 204 9 0) A)))
                   (27 (LET* ((A (AS 7 (BITS 816 9 0) A))
                              (A (AS 6 (BITS 876 9 0) A))
                              (A (AS 5 (BITS 936 9 0) A))
                              (A (AS 4 (BITS 996 9 0) A))
                              (A (AS 3 (BITS 28 9 0) A))
                              (A (AS 2 (BITS 88 9 0) A))
                              (A (AS 1 (BITS 148 9 0) A)))
                             (AS 0 (BITS 208 9 0) A)))
                   (28 (LET* ((A (AS 7 (BITS 812 9 0) A))
                              (A (AS 6 (BITS 872 9 0) A))
                              (A (AS 5 (BITS 934 9 0) A))
                              (A (AS 4 (BITS 996 9 0) A))
                              (A (AS 3 (BITS 28 9 0) A))
                              (A (AS 2 (BITS 90 9 0) A))
                              (A (AS 1 (BITS 152 9 0) A)))
                             (AS 0 (BITS 212 9 0) A)))
                   (29 (LET* ((A (AS 7 (BITS 810 9 0) A))
                              (A (AS 6 (BITS 872 9 0) A))
                              (A (AS 5 (BITS 934 9 0) A))
                              (A (AS 4 (BITS 996 9 0) A))
                              (A (AS 3 (BITS 28 9 0) A))
                              (A (AS 2 (BITS 90 9 0) A))
                              (A (AS 1 (BITS 152 9 0) A)))
                             (AS 0 (BITS 214 9 0) A)))
                   (30 (LET* ((A (AS 7 (BITS 806 9 0) A))
                              (A (AS 6 (BITS 870 9 0) A))
                              (A (AS 5 (BITS 930 9 0) A))
                              (A (AS 4 (BITS 996 9 0) A))
                              (A (AS 3 (BITS 28 9 0) A))
                              (A (AS 2 (BITS 94 9 0) A))
                              (A (AS 1 (BITS 154 9 0) A)))
                             (AS 0 (BITS 218 9 0) A)))
                   (31 (LET* ((A (AS 7 (BITS 802 9 0) A))
                              (A (AS 6 (BITS 866 9 0) A))
                              (A (AS 5 (BITS 930 9 0) A))
                              (A (AS 4 (BITS 992 9 0) A))
                              (A (AS 3 (BITS 32 9 0) A))
                              (A (AS 2 (BITS 94 9 0) A))
                              (A (AS 1 (BITS 158 9 0) A)))
                             (AS 0 (BITS 222 9 0) A)))
                   (T A))))

(DEFUND
 NEXTDIGIT (RS10 CMPCONST)
 (LET
  ((GEP4 (BITS (+ RS10 (AG 7 CMPCONST)) 10 0))
   (GEP3 (BITS (+ RS10 (AG 6 CMPCONST)) 10 0))
   (GEP2 (BITS (+ RS10 (AG 5 CMPCONST)) 10 0))
   (GEP1 (BITS (+ RS10 (AG 4 CMPCONST)) 10 0))
   (GEZ0 (BITS (+ RS10 (AG 3 CMPCONST)) 10 0))
   (GEN1 (BITS (+ RS10 (AG 2 CMPCONST)) 10 0))
   (GEN2 (BITS (+ RS10 (AG 1 CMPCONST)) 10 0))
   (GEN3 (BITS (+ RS10 (AG 0 CMPCONST)) 10 0))
   (Q 0))
  (IF1 (LOGAND1 (BITN GEP4 10)
                (LOGNOT1 (BITN RS10 9)))
       4
       (IF1 (LOGAND1 (LOGNOT1 (BITN GEP4 10))
                     (BITN GEP3 10))
            3
            (IF1 (LOGAND1 (LOGNOT1 (BITN GEP3 10))
                          (BITN GEP2 10))
                 2
                 (IF1 (LOGAND1 (LOGNOT1 (BITN GEP2 10))
                               (BITN GEP1 10))
                      1
                      (IF1 (LOGIOR1 (LOGAND1 (LOGNOT1 (BITN GEP1 10))
                                             (LOGNOT1 (BITN RS10 9)))
                                    (BITN GEZ0 10))
                           0
                           (IF1 (LOGAND1 (LOGNOT1 (BITN GEZ0 10))
                                         (BITN GEN1 10))
                                -1
                                (IF1 (LOGAND1 (LOGNOT1 (BITN GEN1 10))
                                              (BITN GEN2 10))
                                     -2
                                     (IF1 (LOGAND1 (LOGNOT1 (BITN GEN2 10))
                                                   (BITN GEN3 10))
                                          -3
                                          (IF1 (LOGAND1 (LOGNOT1 (BITN GEN3 10))
                                                        (BITN RS10 9))
                                               -4 Q)))))))))))

(DEFUND
 NEXTREM
 (RP RN REMSIGN Q DIVSIGNED DIV3SIGNED INT32)
 (LET*
     ((DIVMULT 0)
      (DIVMULT (CASE Q
                     ((4 -4)
                      (LET* ((DIVMULT (BITS (ASH DIVSIGNED 2) 70 0))
                             (DIVMULT (SETBITN DIVMULT 71 0 (LOGNOT1 REMSIGN))))
                            (SETBITN DIVMULT 71 1 (LOGNOT1 REMSIGN))))
                     ((3 -3) DIV3SIGNED)
                     ((2 -2)
                      (LET ((DIVMULT (BITS (ASH DIVSIGNED 1) 70 0)))
                           (SETBITN DIVMULT 71 0 (LOGNOT1 REMSIGN))))
                     ((1 -1) DIVSIGNED)
                     (T DIVMULT)))
      (RP8 (BITS (ASH RP 3) 70 0))
      (RN8 (BITS (ASH RN 3) 70 0))
      (SUM (LOGXOR (LOGXOR RN8 RP8) DIVMULT))
      (CARRY (LOGIOR (LOGAND (BITS (LOGNOT RN8) 70 0) RP8)
                     (LOGAND (LOGIOR (BITS (LOGNOT RN8) 70 0) RP8)
                             DIVMULT))))
     (MV-LET (RP RN)
             (IF1 INT32
                  (MV (SETBITN (SETBITS RP 71 70 33 (BITS CARRY 69 32))
                               71 32 (LOGNOT1 REMSIGN))
                      (SETBITS RN 71 70 32 (BITS SUM 70 32)))
                  (MV (SETBITN (SETBITS RP 71 70 1 (BITS CARRY 69 0))
                               71 0 (LOGNOT1 REMSIGN))
                      SUM))
             (IF1 (LOG= Q 0)
                  (MV RP8 RN8)
                  (MV RP RN)))))

(DEFUND NEXTQUOT (SGNQ Q QUOT QUOTM)
        (LET ((Q (IF1 SGNQ (- Q) Q))
              (QUOTNEW 0)
              (QUOTMNEW 0))
             (MV (SETBITS (BITS (IF1 (LOG>= Q 0)
                                     (ASH QUOT 3)
                                     (ASH QUOTM 3))
                                64 0)
                          65 2 0 Q)
                 (SETBITS (BITS (IF1 (LOG> Q 0)
                                     (ASH QUOT 3)
                                     (ASH QUOTM 3))
                                64 0)
                          65 2 0 (- Q 1)))))

(DEFUND INCQUOT
        (SGNQ Q QUOT QUOTM QLAST QUOTLAST QUOTMLAST K)
        (MV-LET (Q QLAST)
                (IF1 SGNQ (MV (- Q) (- QLAST))
                     (MV Q QLAST))
                (LET ((QUOTP 0))
                     (IF1 (LOG= K 2)
                          (IF1 (LOG= Q 4)
                               (LET ((QUOTP (BITS (IF1 (LOG>= QLAST -1)
                                                       (ASH QUOTLAST 6)
                                                       (ASH QUOTMLAST 6))
                                                  64 0)))
                                    (SETBITS QUOTP 65 5 3 (+ QLAST 1)))
                               (LET ((QUOTP (BITS (ASH QUOT 3) 64 0)))
                                    (SETBITS QUOTP 65 2 0 (+ Q 4))))
                          (IF1 (LOG= K 1)
                               (LET ((QUOTP (BITS (IF1 (LOG>= Q -2)
                                                       (ASH QUOT 3)
                                                       (ASH QUOTM 3))
                                                  64 0)))
                                    (SETBITS QUOTP 65 2 0 (+ Q 2)))
                               (LET ((QUOTP (BITS (IF1 (LOG>= Q -1)
                                                       (ASH QUOT 3)
                                                       (ASH QUOTM 3))
                                                  64 0)))
                                    (SETBITS QUOTP 65 2 0 (+ Q 1))))))))

(DEFUND COMPUTERS11
        (RP RN Q DIVSIGNED DIV3SIGNED)
        (LET* ((RP13 (BITS RP 61 49))
               (RN13 (BITS RN 61 49))
               (DIVMULT 0)
               (DIVMULT (CASE Q ((4 -4) (BITS DIVSIGNED 62 50))
                              ((3 -3) (BITS DIV3SIGNED 64 52))
                              ((2 -2) (BITS DIVSIGNED 63 51))
                              ((1 -1) (BITS DIVSIGNED 64 52))
                              (T DIVMULT)))
               (SUM (BITS (LOGXOR (LOGXOR (BITS RP13 12 1)
                                          (BITS RN13 12 1))
                                  (BITS DIVMULT 12 1))
                          11 0))
               (CARRY (BITS (LOGIOR (LOGAND (BITS RP13 11 0)
                                            (LOGNOT (BITS RN13 11 0)))
                                    (LOGAND (LOGIOR (BITS RP13 11 0)
                                                    (LOGNOT (BITS RN13 11 0)))
                                            (BITS DIVMULT 11 0)))
                            11 0))
               (SUM12 0)
               (SUM12 (IF1 (LOG= Q 0)
                           (BITS (+ (+ (BITS RP13 12 1)
                                       (LOGNOT (BITS RN13 12 1)))
                                    1)
                                 11 0)
                           (BITS (+ (+ CARRY (LOGNOT SUM)) 1)
                                 11 0))))
              (BITS SUM12 11 1)))

(DEFUND COMPUTERS10
        (DIVSIGNED DIV3SIGNED Q RS11)
        (LET* ((DIVMULT 0)
               (DIVMULT (CASE Q ((4 -4) (BITS DIVSIGNED 65 55))
                              ((3 -3) (BITS DIV3SIGNED 67 57))
                              ((2 -2) (BITS DIVSIGNED 66 56))
                              ((1 -1) (BITS DIVSIGNED 67 57))
                              (0 (BITS 0 10 0))
                              (T DIVMULT)))
               (SUM11 (BITS (+ (+ RS11 DIVMULT) 1) 10 0)))
              (BITS SUM11 10 1)))

(DEFUND
 IDIV8-LOOP-0
 (J ONLY1ITER SKIPITER I C CMPCONST DIV DIV3
    INT32 SGNQ K Q QLAST QUOTLAST QUOTMLAST
    RS11 RP RN RS10 QUOT QUOTM QUOTP)
 (DECLARE (XARGS :MEASURE (NFIX (- (1+ 2) J))))
 (IF
  (AND (INTEGERP J) (<= J 2))
  (MV-LET
   (Q QLAST QUOTLAST QUOTMLAST
      RS11 RP RN RS10 QUOT QUOTM QUOTP)
   (IF1
    (LOGAND1 (LOG= J 2)
             (LOGIOR1 ONLY1ITER
                      (LOGAND1 SKIPITER (LOG= I (- C 1)))))
    (MV Q QLAST QUOTLAST QUOTMLAST
        RS11 RP RN RS10 QUOT QUOTM QUOTP)
    (LET
     ((Q (NEXTDIGIT RS10 CMPCONST)))
     (MV-LET
      (QLAST QUOTLAST QUOTMLAST)
      (IF1 (LOG= J 1)
           (MV Q QUOT QUOTM)
           (MV QLAST QUOTLAST QUOTMLAST))
      (LET
       ((DIVSIGNED 0) (DIV3SIGNED 0))
       (MV-LET
        (DIVSIGNED DIV3SIGNED)
        (IF1 (BITN RS10 9)
             (MV DIV DIV3)
             (MV (BITS (LOGNOT DIV) 70 0)
                 (BITS (LOGNOT DIV3) 70 0)))
        (LET
         ((RS11 (IF1 (LOG= J 1)
                     (COMPUTERS11 RP RN Q DIVSIGNED DIV3SIGNED)
                     RS11)))
         (MV-LET
              (RP RN)
              (NEXTREM RP RN (BITN RS10 9)
                       Q DIVSIGNED DIV3SIGNED INT32)
              (MV-LET (QUOTP RS10)
                      (IF1 (LOG= J 1)
                           (MV QUOTP
                               (BITS (+ (+ (BITS RP 67 58)
                                           (LOGNOT (BITS RN 67 58)))
                                        1)
                                     9 0))
                           (MV (INCQUOT SGNQ
                                        Q QUOT QUOTM QLAST QUOTLAST QUOTMLAST K)
                               (COMPUTERS10 DIVSIGNED DIV3SIGNED Q RS11)))
                      (MV-LET (QUOT QUOTM)
                              (NEXTQUOT SGNQ Q QUOT QUOTM)
                              (MV Q QLAST QUOTLAST
                                  QUOTMLAST RS11 RP RN RS10 QUOT QUOTM
                                  (IF1 (LOG= J 1)
                                       (BITS (+ QUOT (ASH 1 K)) 64 0)
                                       QUOTP)))))))))))
   (IDIV8-LOOP-0 (+ J 1)
                 ONLY1ITER SKIPITER I C CMPCONST DIV DIV3
                 INT32 SGNQ K Q QLAST QUOTLAST QUOTMLAST
                 RS11 RP RN RS10 QUOT QUOTM QUOTP))
  (MV Q QLAST QUOTLAST QUOTMLAST
      RS11 RP RN RS10 QUOT QUOTM QUOTP)))

(DEFUND IDIV8-LOOP-1
        (I ONLY1ITER SKIPITER C CMPCONST DIV DIV3
           INT32 SGNQ K Q QLAST QUOTLAST QUOTMLAST
           RS11 RP RN RS10 QUOT QUOTM QUOTP)
        (DECLARE (XARGS :MEASURE (NFIX (- (1+ C) I))))
        (IF (AND (INTEGERP I)
                 (INTEGERP C)
                 (AND (<= I C) (<= I 11)))
            (MV-LET (Q QLAST QUOTLAST QUOTMLAST
                       RS11 RP RN RS10 QUOT QUOTM QUOTP)
                    (IDIV8-LOOP-0 1
                                  ONLY1ITER SKIPITER I C CMPCONST DIV DIV3
                                  INT32 SGNQ K Q QLAST QUOTLAST QUOTMLAST
                                  RS11 RP RN RS10 QUOT QUOTM QUOTP)
                    (IDIV8-LOOP-1 (+ I 1)
                                  ONLY1ITER SKIPITER C CMPCONST DIV DIV3
                                  INT32 SGNQ K Q QLAST QUOTLAST QUOTMLAST
                                  RS11 RP RN RS10 QUOT QUOTM QUOTP))
            (MV Q QLAST QUOTLAST QUOTMLAST
                RS11 RP RN RS10 QUOT QUOTM QUOTP)))

(DEFUND
 IDIV8 (OPA OPB INT32 SGND)
 (LET*
  ((SGNA (LOGAND1 SGND (BITN OPA 63)))
   (SGNB (LOGAND1 SGND (BITN OPB 63)))
   (SGNQ (LOGXOR SGNA SGNB))
   (BGTA (COMPAREOPS OPA OPB SGNA SGNB INT32))
   (MSKA OPA)
   (MSKB OPB))
  (MV-LET
   (MSKA MSKB)
   (IF1 INT32
        (MV (SETBITS MSKA 64 31 0 0)
            (SETBITS MSKB 64 31 0 0))
        (MV MSKA MSKB))
   (LET*
    ((NEGA (BITS (+ (LOGNOT MSKA) 1) 63 0))
     (NEGB (BITS (+ (LOGNOT MSKB) 1) 63 0))
     (ABSA (BITS (IF1 SGNA NEGA MSKA) 63 0))
     (ABSB (BITS (IF1 SGNB NEGB MSKB) 63 0))
     (CLZA (CLZ64 ABSA))
     (CLZB (CLZ64 ABSB)))
    (IF1
     (LOGIOR1 (LOG= MSKB 0) BGTA)
     (BITS 0 63 0)
     (IF1
      (ISPOW2 MSKB SGNB)
      (DIVPOW2 (BITS (IF1 SGNB NEGA MSKA) 63 0)
               SGNQ (BITS (LOGNOT CLZB) 5 0))
      (IF1
       (LOG= CLZA CLZB)
       (BITS (IF1 SGNQ 18446744073709551615 1)
             63 0)
       (LET*
        ((DIV (BITS (ASH ABSB (+ CLZB 3)) 70 0))
         (DIV2 (BITS (ASH DIV 1) 70 0))
         (DIV3 (BITS (+ DIV DIV2) 70 0))
         (RP 0)
         (RN 0)
         (Q 0)
         (QLAST 0)
         (QUOT (BITS 0 64 0))
         (QUOTM (BITS 0 64 0))
         (QUOTP (BITS 0 64 0))
         (QUOTLAST 0)
         (QUOTMLAST 0)
         (RS10 0)
         (RS11 0)
         (CMPCONST (COMPUTECMPCONST (BITS DIV 65 60)))
         (RP (BITS (ASH ABSA (+ CLZA 3)) 70 0))
         (RS10 (BITS RP 70 61))
         (GEP2 (BITS (+ RS10 (AG 5 CMPCONST)) 10 0)))
        (MV-LET
         (Q RN)
         (IF1 (BITN GEP2 10)
              (MV 2 DIV2)
              (MV 1 DIV))
         (MV-LET
          (QUOT QUOTM)
          (IF1 SGNQ
               (MV (BITS (- Q) 64 0)
                   (BITS (- (- Q) 1) 64 0))
               (MV (BITS Q 64 0) (BITS (- Q 1) 64 0)))
          (LET* ((RS10 (BITS (+ (+ (BITS RP 67 58)
                                   (LOGNOT (BITS RN 67 58)))
                                1)
                             9 0))
                 (DELTA (- CLZB CLZA))
                 (BITSMOD6 (REM DELTA 6))
                 (C (IF1 (LOG= BITSMOD6 0)
                         (FLOOR DELTA 6)
                         (+ 1 (FLOOR DELTA 6))))
                 (ONLY1ITER (LOG<= DELTA 3))
                 (SKIPITER (LOGAND1 (LOGAND1 (LOGNOT1 ONLY1ITER)
                                             (LOG< 0 BITSMOD6))
                                    (LOG<= BITSMOD6 3)))
                 (K 0)
                 (K (CASE (REM DELTA 3)
                          (0 0)
                          (1 2)
                          (2 1)
                          (T K))))
                (MV-LET (Q QLAST QUOTLAST QUOTMLAST
                           RS11 RP RN RS10 QUOT QUOTM QUOTP)
                        (IDIV8-LOOP-1 1 ONLY1ITER SKIPITER C CMPCONST DIV DIV3
                                      INT32 SGNQ K Q QLAST QUOTLAST QUOTMLAST
                                      RS11 RP RN RS10 QUOT QUOTM QUOTP)
                        (LET* ((QUOTSIGNED QUOT)
                               (QUOTMSIGNED QUOTM)
                               (QUOTPSIGNED QUOTP)
                               (ISLOST (LOG<> (LOGAND (SI QUOTSIGNED 65)
                                                      (- (ASH 1 K) 1))
                                              0))
                               (QUOT0 (BITS (ASH (SI QUOTSIGNED 65) (- K))
                                            63 0))
                               (QUOTM0 (BITS (ASH (SI QUOTMSIGNED 65) (- K))
                                             63 0))
                               (QUOTP0 (BITS (ASH (SI QUOTPSIGNED 65) (- K))
                                             63 0))
                               (REM (BITS (+ (+ RP (LOGNOT RN)) 1) 70 0)))
                              (IF1 (LOGAND1 SGNQ (LOGIOR1 ISLOST (BITN REM 70)))
                                   QUOTP0
                                   (IF1 (LOGAND1 (LOGAND1 (LOGNOT1 SGNQ)
                                                          (LOGNOT1 ISLOST))
                                                 (BITN REM 70))
                                        QUOTM0 QUOT0)))))))))))))))

