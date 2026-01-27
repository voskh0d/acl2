(FUNCDEF ENCODE8 (SRC I SMUL)
         (BLOCK (DECLARE RES (RAC-TYPE-INFO 0 '(INT)))
                (SWITCH I
                        (0 (ASSIGN RES
                                   (- (BITN SRC 0) (* 2 (BITN SRC 1)))))
                        (4 (ASSIGN RES
                                   (LOGAND1 (LOGNOT1 SMUL) (BITN SRC 7))))
                        (T (ASSIGN RES
                                   (- (+ (BITN SRC (* 2 I))
                                         (BITN SRC (- (* 2 I) 1)))
                                      (* 2 (BITN SRC (+ (* 2 I) 1)))))))
                (RETURN RES)))

(FUNCDEF ENCODE16 (SRC I SMUL)
         (BLOCK (DECLARE RES (RAC-TYPE-INFO 0 '(INT)))
                (SWITCH I
                        (0 (ASSIGN RES
                                   (- (BITN SRC 0) (* 2 (BITN SRC 1)))))
                        (8 (ASSIGN RES
                                   (LOGAND1 (LOGNOT1 SMUL) (BITN SRC 15))))
                        (T (ASSIGN RES
                                   (- (+ (BITN SRC (* 2 I))
                                         (BITN SRC (- (* 2 I) 1)))
                                      (* 2 (BITN SRC (+ (* 2 I) 1)))))))
                (RETURN RES)))

(FUNCDEF ADAPT_ENCODING (X)
         (BLOCK (DECLARE PP (RAC-TYPE-INFO 0 '(BVEC 4)))
                (ASSIGN PP (SETBITN PP 4 0 (LOG= X 1)))
                (ASSIGN PP (SETBITN PP 4 1 (LOG= X 2)))
                (ASSIGN PP (SETBITN PP 4 2 (LOG= X -1)))
                (ASSIGN PP (SETBITN PP 4 3 (LOG= X -2)))
                (RETURN PP)))

(FUNCDEF BOOTH8 (X SMUL)
         (BLOCK (DECLARE A (RAC-TYPE-INFO NIL '(ARRAY (INT) 5)))
                (ASSIGN A (AS 0 (ENCODE8 X 0 SMUL) A))
                (ASSIGN A (AS 1 (ENCODE8 X 1 SMUL) A))
                (ASSIGN A (AS 2 (ENCODE8 X 2 SMUL) A))
                (ASSIGN A (AS 3 (ENCODE8 X 3 SMUL) A))
                (ASSIGN A (AS 4 (ENCODE8 X 4 SMUL) A))
                (RETURN A)))

(FUNCDEF BOOTH16 (X SMUL)
         (BLOCK (DECLARE A (RAC-TYPE-INFO NIL '(ARRAY (INT) 9)))
                (ASSIGN A (AS 0 (ENCODE16 X 0 SMUL) A))
                (ASSIGN A (AS 1 (ENCODE16 X 1 SMUL) A))
                (ASSIGN A (AS 2 (ENCODE16 X 2 SMUL) A))
                (ASSIGN A (AS 3 (ENCODE16 X 3 SMUL) A))
                (ASSIGN A (AS 4 (ENCODE16 X 4 SMUL) A))
                (ASSIGN A (AS 5 (ENCODE16 X 5 SMUL) A))
                (ASSIGN A (AS 6 (ENCODE16 X 6 SMUL) A))
                (ASSIGN A (AS 7 (ENCODE16 X 7 SMUL) A))
                (ASSIGN A (AS 8 (ENCODE16 X 8 SMUL) A))
                (RETURN A)))

(FUNCDEF
 PARTIALSPRODUCTS8 (B B_ENCS BSIGNED)
 (BLOCK
  (DECLARE PPS
           (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                       (CONS 1 0)
                                       (CONS 2 0)
                                       (CONS 3 0)
                                       (CONS 4 0)))
                          '(ARRAY (BVEC 12) 5)))
  (DECLARE BVAL
           (RAC-TYPE-INFO (IF1 BSIGNED (SI B 8) B)
                          '(INT)))
  (FOR
    ((DECLARE I (RAC-TYPE-INFO 0 '(INT)))
     (LOG< I 5)
     (+ I 1))
    (BLOCK (DECLARE PP
                    (RAC-TYPE-INFO (BITS (- (+ (ASH 1 9) (* BVAL (AG I B_ENCS)))
                                            (IF1 (LOG< (AG I B_ENCS) 0) 1 0))
                                         11 0)
                                   '(BVEC 12)))
           (IF (LOG<> I 0)
               (BLOCK (ASSIGN PP (BITS (ASH PP 2) 11 0))
                      (ASSIGN PP
                              (SETBITN PP 12 0 (LOG< (AG (- I 1) B_ENCS) 0))))
             NIL)
           (ASSIGN PPS (AS I PP PPS))))
  (RETURN PPS)))

(FUNCDEF
 PARTIALSPRODUCTS16 (B B_ENCS BSIGNED)
 (BLOCK
  (DECLARE PPS
           (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                       (CONS 1 0)
                                       (CONS 2 0)
                                       (CONS 3 0)
                                       (CONS 4 0)
                                       (CONS 5 0)
                                       (CONS 6 0)
                                       (CONS 7 0)
                                       (CONS 8 0)))
                          '(ARRAY (BVEC 20) 9)))
  (DECLARE BVAL
           (RAC-TYPE-INFO (IF1 BSIGNED (SI B 16) B)
                          '(INT)))
  (FOR
   ((DECLARE I (RAC-TYPE-INFO 0 '(INT)))
    (LOG< I 9)
    (+ I 1))
   (BLOCK (DECLARE PP
                   (RAC-TYPE-INFO (BITS (- (+ (ASH 1 17) (* BVAL (AG I B_ENCS)))
                                           (IF1 (LOG< (AG I B_ENCS) 0) 1 0))
                                        19 0)
                                  '(BVEC 20)))
          (IF (LOG<> I 0)
              (BLOCK (ASSIGN PP (BITS (ASH PP 2) 19 0))
                     (ASSIGN PP
                             (SETBITN PP 20 0 (LOG< (AG (- I 1) B_ENCS) 0))))
            NIL)
          (ASSIGN PPS (AS I PP PPS))))
  (RETURN PPS)))

(FUNCDEF S36 (A B C)
         (BLOCK (RETURN (LOGXOR (LOGXOR A B) C))))

(FUNCDEF C36 (A B C)
         (BLOCK (RETURN (BITS (ASH (LOGIOR (LOGIOR (LOGAND A B) (LOGAND B C))
                                           (LOGAND C A))
                                   1)
                              35 0))))

(FUNCDEF S21 (A B C)
         (BLOCK (RETURN (LOGXOR (LOGXOR A B) C))))

(FUNCDEF C21 (A B C)
         (BLOCK (RETURN (BITS (ASH (LOGIOR (LOGIOR (LOGAND A B) (LOGAND B C))
                                           (LOGAND C A))
                                   1)
                              20 0))))

(FUNCDEF
  COMPRESS (L0PP)
  (BLOCK (LIST (DECLARE L0PPS
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                    (CONS 1 0)
                                                    (CONS 2 0)
                                                    (CONS 3 0)
                                                    (CONS 4 0)
                                                    (CONS 5 0)
                                                    (CONS 6 0)
                                                    (CONS 7 0)
                                                    (CONS 8 0)
                                                    (CONS 9 0)
                                                    (CONS 10 0)
                                                    (CONS 11 0)
                                                    (CONS 12 0)))
                                       '(ARRAY (BVEC 36) 13)))
               (DECLARE L0PPC
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                    (CONS 1 0)
                                                    (CONS 2 0)
                                                    (CONS 3 0)
                                                    (CONS 4 0)
                                                    (CONS 5 0)
                                                    (CONS 6 0)
                                                    (CONS 7 0)
                                                    (CONS 8 0)
                                                    (CONS 9 0)
                                                    (CONS 10 0)
                                                    (CONS 11 0)
                                                    (CONS 12 0)))
                                       '(ARRAY (BVEC 36) 13))))
         (FOR ((DECLARE I (RAC-TYPE-INFO 0 '(INT)))
               (LOG< I 13)
               (+ I 1))
              (BLOCK (ASSIGN L0PPS
                             (AS I
                                 (S36 (AG (* 3 I) L0PP)
                                      (AG (+ (* 3 I) 1) L0PP)
                                      (AG (+ (* 3 I) 2) L0PP))
                                 L0PPS))
                     (ASSIGN L0PPC
                             (AS I
                                 (C36 (AG (* 3 I) L0PP)
                                      (AG (+ (* 3 I) 1) L0PP)
                                      (AG (+ (* 3 I) 2) L0PP))
                                 L0PPC))))
         (DECLARE L1PP
                  (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                              (CONS 1 0)
                                              (CONS 2 0)
                                              (CONS 3 0)
                                              (CONS 4 0)
                                              (CONS 5 0)
                                              (CONS 6 0)
                                              (CONS 7 0)
                                              (CONS 8 0)
                                              (CONS 9 0)
                                              (CONS 10 0)
                                              (CONS 11 0)
                                              (CONS 12 0)
                                              (CONS 13 0)
                                              (CONS 14 0)
                                              (CONS 15 0)
                                              (CONS 16 0)
                                              (CONS 17 0)
                                              (CONS 18 0)
                                              (CONS 19 0)
                                              (CONS 20 0)
                                              (CONS 21 0)
                                              (CONS 22 0)
                                              (CONS 23 0)
                                              (CONS 24 0)
                                              (CONS 25 0)
                                              (CONS 26 0)))
                                 '(ARRAY (BVEC 36) 27)))
         (ASSIGN L1PP (AS 0 (AG 1 L0PPS) L1PP))
         (ASSIGN L1PP (AS 1 (AG 2 L0PPS) L1PP))
         (ASSIGN L1PP (AS 2 (AG 3 L0PPS) L1PP))
         (ASSIGN L1PP (AS 3 (AG 1 L0PPC) L1PP))
         (ASSIGN L1PP (AS 4 (AG 2 L0PPC) L1PP))
         (ASSIGN L1PP (AS 5 (AG 3 L0PPC) L1PP))
         (ASSIGN L1PP (AS 6 (AG 4 L0PPS) L1PP))
         (ASSIGN L1PP (AS 7 (AG 4 L0PPC) L1PP))
         (ASSIGN L1PP (AS 8 (AG 5 L0PPS) L1PP))
         (ASSIGN L1PP (AS 9 (AG 6 L0PPS) L1PP))
         (ASSIGN L1PP (AS 10 (AG 5 L0PPC) L1PP))
         (ASSIGN L1PP (AS 11 (AG 7 L0PPS) L1PP))
         (ASSIGN L1PP (AS 12 (AG 6 L0PPC) L1PP))
         (ASSIGN L1PP (AS 13 (AG 0 L0PPS) L1PP))
         (ASSIGN L1PP (AS 14 (AG 0 L0PPC) L1PP))
         (ASSIGN L1PP (AS 15 (AG 7 L0PPC) L1PP))
         (ASSIGN L1PP (AS 16 (AG 8 L0PPS) L1PP))
         (ASSIGN L1PP (AS 17 (AG 8 L0PPC) L1PP))
         (ASSIGN L1PP (AS 18 (AG 9 L0PPS) L1PP))
         (ASSIGN L1PP (AS 19 (AG 10 L0PPS) L1PP))
         (ASSIGN L1PP (AS 20 (AG 9 L0PPC) L1PP))
         (ASSIGN L1PP (AS 21 (AG 11 L0PPS) L1PP))
         (ASSIGN L1PP (AS 22 (AG 10 L0PPC) L1PP))
         (ASSIGN L1PP (AS 23 (AG 11 L0PPC) L1PP))
         (ASSIGN L1PP (AS 24 (AG 12 L0PPS) L1PP))
         (ASSIGN L1PP (AS 25 (AG 39 L0PP) L1PP))
         (ASSIGN L1PP (AS 26 (AG 12 L0PPC) L1PP))
         (LIST (DECLARE L1PPS
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                    (CONS 1 0)
                                                    (CONS 2 0)
                                                    (CONS 3 0)
                                                    (CONS 4 0)
                                                    (CONS 5 0)
                                                    (CONS 6 0)
                                                    (CONS 7 0)
                                                    (CONS 8 0)))
                                       '(ARRAY (BVEC 36) 9)))
               (DECLARE L1PPC
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                    (CONS 1 0)
                                                    (CONS 2 0)
                                                    (CONS 3 0)
                                                    (CONS 4 0)
                                                    (CONS 5 0)
                                                    (CONS 6 0)
                                                    (CONS 7 0)
                                                    (CONS 8 0)))
                                       '(ARRAY (BVEC 36) 9))))
         (FOR ((DECLARE I (RAC-TYPE-INFO 0 '(INT)))
               (LOG< I 9)
               (+ I 1))
              (BLOCK (ASSIGN L1PPS
                             (AS I
                                 (S36 (AG (* 3 I) L1PP)
                                      (AG (+ (* 3 I) 1) L1PP)
                                      (AG (+ (* 3 I) 2) L1PP))
                                 L1PPS))
                     (ASSIGN L1PPC
                             (AS I
                                 (C36 (AG (* 3 I) L1PP)
                                      (AG (+ (* 3 I) 1) L1PP)
                                      (AG (+ (* 3 I) 2) L1PP))
                                 L1PPC))))
         (DECLARE L2PP
                  (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                              (CONS 1 0)
                                              (CONS 2 0)
                                              (CONS 3 0)
                                              (CONS 4 0)
                                              (CONS 5 0)
                                              (CONS 6 0)
                                              (CONS 7 0)
                                              (CONS 8 0)
                                              (CONS 9 0)
                                              (CONS 10 0)
                                              (CONS 11 0)
                                              (CONS 12 0)
                                              (CONS 13 0)
                                              (CONS 14 0)
                                              (CONS 15 0)
                                              (CONS 16 0)
                                              (CONS 17 0)))
                                 '(ARRAY (BVEC 36) 18)))
         (ASSIGN L2PP (AS 0 (AG 0 L1PPS) L2PP))
         (ASSIGN L2PP (AS 1 (AG 0 L1PPC) L2PP))
         (ASSIGN L2PP (AS 2 (AG 1 L1PPS) L2PP))
         (ASSIGN L2PP (AS 3 (AG 1 L1PPC) L2PP))
         (ASSIGN L2PP (AS 4 (AG 2 L1PPS) L2PP))
         (ASSIGN L2PP (AS 5 (AG 2 L1PPC) L2PP))
         (ASSIGN L2PP (AS 6 (AG 3 L1PPS) L2PP))
         (ASSIGN L2PP (AS 7 (AG 3 L1PPC) L2PP))
         (ASSIGN L2PP (AS 8 (AG 4 L1PPS) L2PP))
         (ASSIGN L2PP (AS 9 (AG 5 L1PPS) L2PP))
         (ASSIGN L2PP (AS 10 (AG 5 L1PPC) L2PP))
         (ASSIGN L2PP (AS 11 (AG 6 L1PPS) L2PP))
         (ASSIGN L2PP (AS 12 (AG 6 L1PPC) L2PP))
         (ASSIGN L2PP (AS 13 (AG 7 L1PPS) L2PP))
         (ASSIGN L2PP (AS 14 (AG 7 L1PPC) L2PP))
         (ASSIGN L2PP (AS 15 (AG 8 L1PPS) L2PP))
         (ASSIGN L2PP (AS 16 (AG 4 L1PPC) L2PP))
         (ASSIGN L2PP (AS 17 (AG 8 L1PPC) L2PP))
         (LIST (DECLARE L2PPS
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                    (CONS 1 0)
                                                    (CONS 2 0)
                                                    (CONS 3 0)
                                                    (CONS 4 0)
                                                    (CONS 5 0)))
                                       '(ARRAY (BVEC 36) 6)))
               (DECLARE L2PPC
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                    (CONS 1 0)
                                                    (CONS 2 0)
                                                    (CONS 3 0)
                                                    (CONS 4 0)
                                                    (CONS 5 0)))
                                       '(ARRAY (BVEC 36) 6))))
         (FOR ((DECLARE I (RAC-TYPE-INFO 0 '(INT)))
               (LOG< I 6)
               (+ I 1))
              (BLOCK (ASSIGN L2PPS
                             (AS I
                                 (S36 (AG (* 3 I) L2PP)
                                      (AG (+ (* 3 I) 1) L2PP)
                                      (AG (+ (* 3 I) 2) L2PP))
                                 L2PPS))
                     (ASSIGN L2PPC
                             (AS I
                                 (C36 (AG (* 3 I) L2PP)
                                      (AG (+ (* 3 I) 1) L2PP)
                                      (AG (+ (* 3 I) 2) L2PP))
                                 L2PPC))))
         (DECLARE L3PP
                  (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                              (CONS 1 0)
                                              (CONS 2 0)
                                              (CONS 3 0)
                                              (CONS 4 0)
                                              (CONS 5 0)
                                              (CONS 6 0)
                                              (CONS 7 0)
                                              (CONS 8 0)
                                              (CONS 9 0)
                                              (CONS 10 0)
                                              (CONS 11 0)))
                                 '(ARRAY (BVEC 36) 12)))
         (ASSIGN L3PP (AS 0 (AG 0 L2PPS) L3PP))
         (ASSIGN L3PP (AS 1 (AG 0 L2PPC) L3PP))
         (ASSIGN L3PP (AS 2 (AG 1 L2PPS) L3PP))
         (ASSIGN L3PP (AS 3 (AG 1 L2PPC) L3PP))
         (ASSIGN L3PP (AS 4 (AG 2 L2PPS) L3PP))
         (ASSIGN L3PP (AS 5 (AG 2 L2PPC) L3PP))
         (ASSIGN L3PP (AS 6 (AG 3 L2PPS) L3PP))
         (ASSIGN L3PP (AS 7 (AG 3 L2PPC) L3PP))
         (ASSIGN L3PP (AS 8 (AG 4 L2PPS) L3PP))
         (ASSIGN L3PP (AS 9 (AG 4 L2PPC) L3PP))
         (ASSIGN L3PP (AS 10 (AG 5 L2PPS) L3PP))
         (ASSIGN L3PP (AS 11 (AG 5 L2PPC) L3PP))
         (LIST (DECLARE L3PPS
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                    (CONS 1 0)
                                                    (CONS 2 0)
                                                    (CONS 3 0)))
                                       '(ARRAY (BVEC 36) 4)))
               (DECLARE L3PPC
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                    (CONS 1 0)
                                                    (CONS 2 0)
                                                    (CONS 3 0)))
                                       '(ARRAY (BVEC 36) 4))))
         (FOR ((DECLARE I (RAC-TYPE-INFO 0 '(INT)))
               (LOG< I 4)
               (+ I 1))
              (BLOCK (ASSIGN L3PPS
                             (AS I
                                 (S36 (AG (* 3 I) L3PP)
                                      (AG (+ (* 3 I) 1) L3PP)
                                      (AG (+ (* 3 I) 2) L3PP))
                                 L3PPS))
                     (ASSIGN L3PPC
                             (AS I
                                 (C36 (AG (* 3 I) L3PP)
                                      (AG (+ (* 3 I) 1) L3PP)
                                      (AG (+ (* 3 I) 2) L3PP))
                                 L3PPC))))
         (DECLARE L4PP
                  (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                              (CONS 1 0)
                                              (CONS 2 0)
                                              (CONS 3 0)
                                              (CONS 4 0)
                                              (CONS 5 0)
                                              (CONS 6 0)
                                              (CONS 7 0)))
                                 '(ARRAY (BVEC 36) 8)))
         (ASSIGN L4PP (AS 0 (AG 0 L3PPS) L4PP))
         (ASSIGN L4PP (AS 1 (AG 0 L3PPC) L4PP))
         (ASSIGN L4PP (AS 2 (AG 1 L3PPS) L4PP))
         (ASSIGN L4PP (AS 3 (AG 1 L3PPC) L4PP))
         (ASSIGN L4PP (AS 4 (AG 2 L3PPS) L4PP))
         (ASSIGN L4PP (AS 5 (AG 2 L3PPC) L4PP))
         (ASSIGN L4PP (AS 6 (AG 3 L3PPS) L4PP))
         (ASSIGN L4PP (AS 7 (AG 3 L3PPC) L4PP))
         (LIST (DECLARE L4PPS
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0) (CONS 1 0)))
                                       '(ARRAY (BVEC 36) 2)))
               (DECLARE L4PPC
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0) (CONS 1 0)))
                                       '(ARRAY (BVEC 36) 2))))
         (FOR ((DECLARE I (RAC-TYPE-INFO 0 '(INT)))
               (LOG< I 2)
               (+ I 1))
              (BLOCK (ASSIGN L4PPS
                             (AS I
                                 (S36 (AG (* 3 I) L4PP)
                                      (AG (+ (* 3 I) 1) L4PP)
                                      (AG (+ (* 3 I) 2) L4PP))
                                 L4PPS))
                     (ASSIGN L4PPC
                             (AS I
                                 (C36 (AG (* 3 I) L4PP)
                                      (AG (+ (* 3 I) 1) L4PP)
                                      (AG (+ (* 3 I) 2) L4PP))
                                 L4PPC))))
         (DECLARE L5PP
                  (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                              (CONS 1 0)
                                              (CONS 2 0)
                                              (CONS 3 0)
                                              (CONS 4 0)
                                              (CONS 5 0)))
                                 '(ARRAY (BVEC 36) 6)))
         (ASSIGN L5PP (AS 0 (AG 0 L4PPS) L5PP))
         (ASSIGN L5PP (AS 1 (AG 0 L4PPC) L5PP))
         (ASSIGN L5PP (AS 2 (AG 1 L4PPS) L5PP))
         (ASSIGN L5PP (AS 3 (AG 1 L4PPC) L5PP))
         (ASSIGN L5PP (AS 4 (AG 6 L4PP) L5PP))
         (ASSIGN L5PP (AS 5 (AG 7 L4PP) L5PP))
         (LIST (DECLARE L5PPS
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0) (CONS 1 0)))
                                       '(ARRAY (BVEC 36) 2)))
               (DECLARE L5PPC
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0) (CONS 1 0)))
                                       '(ARRAY (BVEC 36) 2))))
         (FOR ((DECLARE I (RAC-TYPE-INFO 0 '(INT)))
               (LOG< I 2)
               (+ I 1))
              (BLOCK (ASSIGN L5PPS
                             (AS I
                                 (S36 (AG (* 3 I) L5PP)
                                      (AG (+ (* 3 I) 1) L5PP)
                                      (AG (+ (* 3 I) 2) L5PP))
                                 L5PPS))
                     (ASSIGN L5PPC
                             (AS I
                                 (C36 (AG (* 3 I) L5PP)
                                      (AG (+ (* 3 I) 1) L5PP)
                                      (AG (+ (* 3 I) 2) L5PP))
                                 L5PPC))))
         (DECLARE L6PP
                  (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                              (CONS 1 0)
                                              (CONS 2 0)
                                              (CONS 3 0)))
                                 '(ARRAY (BVEC 36) 4)))
         (ASSIGN L6PP (AS 0 (AG 0 L5PPS) L6PP))
         (ASSIGN L6PP (AS 1 (AG 0 L5PPC) L6PP))
         (ASSIGN L6PP (AS 2 (AG 1 L5PPS) L6PP))
         (ASSIGN L6PP (AS 3 (AG 1 L5PPC) L6PP))
         (LIST (DECLARE L6PPS
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)))
                                       '(ARRAY (BVEC 36) 1)))
               (DECLARE L6PPC
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)))
                                       '(ARRAY (BVEC 36) 1))))
         (FOR ((DECLARE I (RAC-TYPE-INFO 0 '(INT)))
               (LOG< I 1)
               (+ I 1))
              (BLOCK (ASSIGN L6PPS
                             (AS I
                                 (S36 (AG (* 3 I) L6PP)
                                      (AG (+ (* 3 I) 1) L6PP)
                                      (AG (+ (* 3 I) 2) L6PP))
                                 L6PPS))
                     (ASSIGN L6PPC
                             (AS I
                                 (C36 (AG (* 3 I) L6PP)
                                      (AG (+ (* 3 I) 1) L6PP)
                                      (AG (+ (* 3 I) 2) L6PP))
                                 L6PPC))))
         (DECLARE L7PP
                  (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0) (CONS 1 0) (CONS 2 0)))
                                 '(ARRAY (BVEC 36) 3)))
         (ASSIGN L7PP (AS 0 (AG 0 L6PPS) L7PP))
         (ASSIGN L7PP (AS 1 (AG 0 L6PPC) L7PP))
         (ASSIGN L7PP (AS 2 (AG 3 L6PP) L7PP))
         (LIST (DECLARE L7PPS
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)))
                                       '(ARRAY (BVEC 36) 1)))
               (DECLARE L7PPC
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)))
                                       '(ARRAY (BVEC 36) 1))))
         (FOR ((DECLARE I (RAC-TYPE-INFO 0 '(INT)))
               (LOG< I 1)
               (+ I 1))
              (BLOCK (ASSIGN L7PPS
                             (AS I
                                 (S36 (AG (* 3 I) L7PP)
                                      (AG (+ (* 3 I) 1) L7PP)
                                      (AG (+ (* 3 I) 2) L7PP))
                                 L7PPS))
                     (ASSIGN L7PPC
                             (AS I
                                 (C36 (AG (* 3 I) L7PP)
                                      (AG (+ (* 3 I) 1) L7PP)
                                      (AG (+ (* 3 I) 2) L7PP))
                                 L7PPC))))
         (RETURN (MV (AG 0 L7PPS) (AG 0 L7PPC)))))

(FUNCDEF CONVERT_PP (PP)
         (BLOCK (DECLARE L0PP
                         (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                     (CONS 1 0)
                                                     (CONS 2 0)
                                                     (CONS 3 0)
                                                     (CONS 4 0)
                                                     (CONS 5 0)
                                                     (CONS 6 0)
                                                     (CONS 7 0)
                                                     (CONS 8 0)
                                                     (CONS 9 0)
                                                     (CONS 10 0)
                                                     (CONS 11 0)
                                                     (CONS 12 0)
                                                     (CONS 13 0)
                                                     (CONS 14 0)
                                                     (CONS 15 0)
                                                     (CONS 16 0)
                                                     (CONS 17 0)
                                                     (CONS 18 0)
                                                     (CONS 19 0)
                                                     (CONS 20 0)
                                                     (CONS 21 0)
                                                     (CONS 22 0)
                                                     (CONS 23 0)
                                                     (CONS 24 0)
                                                     (CONS 25 0)
                                                     (CONS 26 0)
                                                     (CONS 27 0)
                                                     (CONS 28 0)
                                                     (CONS 29 0)
                                                     (CONS 30 0)
                                                     (CONS 31 0)
                                                     (CONS 32 0)
                                                     (CONS 33 0)
                                                     (CONS 34 0)
                                                     (CONS 35 0)
                                                     (CONS 36 0)
                                                     (CONS 37 0)
                                                     (CONS 38 0)
                                                     (CONS 39 0)))
                                        '(ARRAY (BVEC 21) 40)))
                (ASSIGN L0PP (AS 0 (ASH (AG 0 PP) (- 8)) L0PP))
                (ASSIGN L0PP (AS 1 (BITS (AG 4 PP) 13 2) L0PP))
                (ASSIGN L0PP (AS 2 (ASH (AG 8 PP) (- 8)) L0PP))
                (ASSIGN L0PP (AS 3 (ASH (AG 16 PP) (- 8)) L0PP))
                (ASSIGN L0PP (AS 4 (ASH (AG 20 PP) (- 2)) L0PP))
                (ASSIGN L0PP (AS 5 (ASH (AG 24 PP) (- 8)) L0PP))
                (ASSIGN L0PP (AS 6 (ASH (AG 28 PP) (- 2)) L0PP))
                (ASSIGN L0PP (AS 7 (ASH (AG 1 PP) (- 8)) L0PP))
                (ASSIGN L0PP (AS 8 (AG 5 PP) L0PP))
                (ASSIGN L0PP (AS 9 (ASH (AG 9 PP) (- 8)) L0PP))
                (ASSIGN L0PP (AS 10 (AG 13 PP) L0PP))
                (ASSIGN L0PP
                        (AS 11 (ASH (AG 17 PP) (- 8)) L0PP))
                (ASSIGN L0PP (AS 12 (AG 21 PP) L0PP))
                (ASSIGN L0PP
                        (AS 13 (ASH (AG 25 PP) (- 8)) L0PP))
                (ASSIGN L0PP (AS 14 (AG 29 PP) L0PP))
                (ASSIGN L0PP (AS 15 (ASH (AG 2 PP) (- 8)) L0PP))
                (ASSIGN L0PP (AS 16 (AG 6 PP) L0PP))
                (ASSIGN L0PP
                        (AS 17 (ASH (AG 10 PP) (- 8)) L0PP))
                (ASSIGN L0PP (AS 18 (AG 14 PP) L0PP))
                (ASSIGN L0PP
                        (AS 19 (ASH (AG 18 PP) (- 8)) L0PP))
                (ASSIGN L0PP (AS 20 (AG 22 PP) L0PP))
                (ASSIGN L0PP
                        (AS 21 (ASH (AG 26 PP) (- 8)) L0PP))
                (ASSIGN L0PP (AS 22 (AG 30 PP) L0PP))
                (ASSIGN L0PP (AS 23 (ASH (AG 3 PP) (- 6)) L0PP))
                (ASSIGN L0PP (AS 24 (AG 7 PP) L0PP))
                (ASSIGN L0PP
                        (AS 25 (ASH (AG 11 PP) (- 8)) L0PP))
                (ASSIGN L0PP (AS 26 (AG 15 PP) L0PP))
                (ASSIGN L0PP
                        (AS 27 (ASH (AG 19 PP) (- 8)) L0PP))
                (ASSIGN L0PP (AS 28 (AG 23 PP) L0PP))
                (ASSIGN L0PP
                        (AS 29 (ASH (AG 27 PP) (- 8)) L0PP))
                (ASSIGN L0PP (AS 30 (AG 31 PP) L0PP))
                (ASSIGN L0PP
                        (AS 31
                            (BITS (BITS (ASH (BITS (AG 32 PP) 11 1) 7)
                                        21 0)
                                  20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 31
                            (SETBITN (AG 31 L0PP)
                                     21 6 (BITN (AG 33 PP) 0))
                            L0PP))
                (ASSERT (LOG= (BITS (AG 31 L0PP) 4 0) 0)
                        CONVERT_PP)
                (ASSERT (LOG= (BITS (AG 31 L0PP) 20 17) 0)
                        CONVERT_PP)
                (ASSIGN L0PP
                        (AS 32
                            (BITS (BITS (ASH (BITS (AG 33 PP) 11 1) 7)
                                        21 0)
                                  20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 32
                            (SETBITN (AG 32 L0PP)
                                     21 6 (BITN (AG 32 PP) 0))
                            L0PP))
                (ASSERT (LOG= (BITS (AG 32 L0PP) 4 0) 0)
                        CONVERT_PP)
                (ASSERT (LOG= (BITS (AG 32 L0PP) 20 17) 0)
                        CONVERT_PP)
                (ASSIGN L0PP
                        (AS 33
                            (BITS (BITS (ASH (BITS (AG 34 PP) 11 1) 7)
                                        21 0)
                                  20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 33
                            (SETBITN (AG 33 L0PP)
                                     21 6 (BITN (AG 35 PP) 0))
                            L0PP))
                (ASSERT (LOG= (BITS (AG 33 L0PP) 4 0) 0)
                        CONVERT_PP)
                (ASSERT (LOG= (BITS (AG 33 L0PP) 20 17) 0)
                        CONVERT_PP)
                (ASSIGN L0PP
                        (AS 34
                            (BITS (BITS (ASH (BITS (AG 35 PP) 11 1) 7)
                                        21 0)
                                  20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 34
                            (SETBITN (AG 34 L0PP)
                                     21 6 (BITN (AG 34 PP) 0))
                            L0PP))
                (ASSERT (LOG= (BITS (AG 34 L0PP) 4 0) 0)
                        CONVERT_PP)
                (ASSERT (LOG= (BITS (AG 34 L0PP) 20 17) 0)
                        CONVERT_PP)
                (ASSIGN L0PP
                        (AS 35
                            (BITS (BITS (ASH (BITS (AG 36 PP) 11 1) 7)
                                        21 0)
                                  20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 35
                            (SETBITN (AG 35 L0PP)
                                     21 6 (BITN (AG 37 PP) 0))
                            L0PP))
                (ASSERT (LOG= (BITS (AG 35 L0PP) 4 0) 0)
                        CONVERT_PP)
                (ASSERT (LOG= (BITS (AG 35 L0PP) 20 17) 0)
                        CONVERT_PP)
                (ASSIGN L0PP
                        (AS 36
                            (BITS (BITS (ASH (BITS (AG 37 PP) 11 1) 7)
                                        21 0)
                                  20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 36
                            (SETBITN (AG 36 L0PP)
                                     21 6 (BITN (AG 36 PP) 0))
                            L0PP))
                (ASSERT (LOG= (BITS (AG 36 L0PP) 4 0) 0)
                        CONVERT_PP)
                (ASSERT (LOG= (BITS (AG 36 L0PP) 20 17) 0)
                        CONVERT_PP)
                (ASSIGN L0PP
                        (AS 37
                            (BITS (BITS (ASH (BITS (AG 38 PP) 11 1) 7)
                                        21 0)
                                  20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 37
                            (SETBITN (AG 37 L0PP)
                                     21 6 (BITN (AG 39 PP) 0))
                            L0PP))
                (ASSERT (LOG= (BITS (AG 37 L0PP) 4 0) 0)
                        CONVERT_PP)
                (ASSERT (LOG= (BITS (AG 37 L0PP) 20 17) 0)
                        CONVERT_PP)
                (ASSIGN L0PP
                        (AS 38
                            (BITS (BITS (ASH (BITS (AG 39 PP) 11 1) 7)
                                        21 0)
                                  20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 38
                            (SETBITN (AG 38 L0PP)
                                     21 6 (BITN (AG 38 PP) 0))
                            L0PP))
                (ASSERT (LOG= (BITS (AG 38 L0PP) 4 0) 0)
                        CONVERT_PP)
                (ASSERT (LOG= (BITS (AG 38 L0PP) 20 17) 0)
                        CONVERT_PP)
                (ASSIGN L0PP
                        (AS 39
                            (BITS (ASH (+ (AG 12 PP) 704512) (- 2))
                                  20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 15 (BITS (ASH (AG 15 L0PP) 2) 20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 16 (BITS (ASH (AG 16 L0PP) 2) 20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 17 (BITS (ASH (AG 17 L0PP) 2) 20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 18 (BITS (ASH (AG 18 L0PP) 2) 20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 19 (BITS (ASH (AG 19 L0PP) 2) 20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 20 (BITS (ASH (AG 20 L0PP) 2) 20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 21 (BITS (ASH (AG 21 L0PP) 2) 20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 22 (BITS (ASH (AG 22 L0PP) 2) 20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 23 (BITS (ASH (AG 23 L0PP) 2) 20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 24 (BITS (ASH (AG 24 L0PP) 4) 20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 25 (BITS (ASH (AG 25 L0PP) 4) 20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 26 (BITS (ASH (AG 26 L0PP) 4) 20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 27 (BITS (ASH (AG 27 L0PP) 4) 20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 28 (BITS (ASH (AG 28 L0PP) 4) 20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 29 (BITS (ASH (AG 29 L0PP) 4) 20 0)
                            L0PP))
                (ASSIGN L0PP
                        (AS 30 (BITS (ASH (AG 30 L0PP) 4) 20 0)
                            L0PP))
                (RETURN L0PP)))

(FUNCDEF
  COMPRESS_WITHOUT_VDOT16 (L0PP)
  (BLOCK (LIST (DECLARE L1PPS
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                    (CONS 1 0)
                                                    (CONS 2 0)
                                                    (CONS 3 0)
                                                    (CONS 4 0)
                                                    (CONS 5 0)
                                                    (CONS 6 0)
                                                    (CONS 7 0)
                                                    (CONS 8 0)
                                                    (CONS 9 0)
                                                    (CONS 10 0)
                                                    (CONS 11 0)
                                                    (CONS 12 0)))
                                       '(ARRAY (BVEC 21) 13)))
               (DECLARE L1PPC
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                    (CONS 1 0)
                                                    (CONS 2 0)
                                                    (CONS 3 0)
                                                    (CONS 4 0)
                                                    (CONS 5 0)
                                                    (CONS 6 0)
                                                    (CONS 7 0)
                                                    (CONS 8 0)
                                                    (CONS 9 0)
                                                    (CONS 10 0)
                                                    (CONS 11 0)
                                                    (CONS 12 0)))
                                       '(ARRAY (BVEC 21) 13))))
         (FOR ((DECLARE I (RAC-TYPE-INFO 0 '(INT)))
               (LOG< I 13)
               (+ I 1))
              (BLOCK (ASSIGN L1PPS
                             (AS I
                                 (S21 (AG (* 3 I) L0PP)
                                      (AG (+ (* 3 I) 1) L0PP)
                                      (AG (+ (* 3 I) 2) L0PP))
                                 L1PPS))
                     (ASSIGN L1PPC
                             (AS I
                                 (C21 (AG (* 3 I) L0PP)
                                      (AG (+ (* 3 I) 1) L0PP)
                                      (AG (+ (* 3 I) 2) L0PP))
                                 L1PPC))))
         (DECLARE L1PP
                  (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                              (CONS 1 0)
                                              (CONS 2 0)
                                              (CONS 3 0)
                                              (CONS 4 0)
                                              (CONS 5 0)
                                              (CONS 6 0)
                                              (CONS 7 0)
                                              (CONS 8 0)
                                              (CONS 9 0)
                                              (CONS 10 0)
                                              (CONS 11 0)
                                              (CONS 12 0)
                                              (CONS 13 0)
                                              (CONS 14 0)
                                              (CONS 15 0)
                                              (CONS 16 0)
                                              (CONS 17 0)
                                              (CONS 18 0)
                                              (CONS 19 0)
                                              (CONS 20 0)
                                              (CONS 21 0)
                                              (CONS 22 0)
                                              (CONS 23 0)
                                              (CONS 24 0)
                                              (CONS 25 0)
                                              (CONS 26 0)))
                                 '(ARRAY (BVEC 21) 27)))
         (ASSIGN L1PP (AS 0 (AG 0 L1PPC) L1PP))
         (ASSIGN L1PP (AS 1 (AG 1 L1PPC) L1PP))
         (ASSIGN L1PP (AS 2 (AG 2 L1PPC) L1PP))
         (ASSIGN L1PP (AS 3 (AG 3 L1PPC) L1PP))
         (ASSIGN L1PP (AS 4 (AG 4 L1PPC) L1PP))
         (ASSIGN L1PP (AS 5 (AG 5 L1PPC) L1PP))
         (ASSIGN L1PP (AS 6 (AG 6 L1PPC) L1PP))
         (ASSIGN L1PP (AS 7 (AG 8 L1PPC) L1PP))
         (ASSIGN L1PP (AS 8 (AG 9 L1PPC) L1PP))
         (ASSIGN L1PP (AS 9 (AG 10 L1PPC) L1PP))
         (ASSIGN L1PP (AS 10 (AG 11 L1PPC) L1PP))
         (ASSIGN L1PP (AS 11 (AG 12 L1PPC) L1PP))
         (ASSIGN L1PP (AS 12 (AG 0 L1PPS) L1PP))
         (ASSIGN L1PP (AS 13 (AG 1 L1PPS) L1PP))
         (ASSIGN L1PP (AS 14 (AG 2 L1PPS) L1PP))
         (ASSIGN L1PP (AS 15 (AG 3 L1PPS) L1PP))
         (ASSIGN L1PP (AS 16 (AG 4 L1PPS) L1PP))
         (ASSIGN L1PP (AS 17 (AG 5 L1PPS) L1PP))
         (ASSIGN L1PP (AS 18 (AG 6 L1PPS) L1PP))
         (ASSIGN L1PP (AS 19 (AG 8 L1PPS) L1PP))
         (ASSIGN L1PP (AS 20 (AG 9 L1PPS) L1PP))
         (ASSIGN L1PP (AS 21 (AG 10 L1PPS) L1PP))
         (ASSIGN L1PP (AS 22 (AG 11 L1PPS) L1PP))
         (ASSIGN L1PP (AS 23 (AG 12 L1PPS) L1PP))
         (ASSIGN L1PP (AS 24 (AG 7 L1PPS) L1PP))
         (ASSIGN L1PP (AS 25 (AG 7 L1PPC) L1PP))
         (ASSIGN L1PP (AS 26 (AG 39 L0PP) L1PP))
         (LIST (DECLARE L2PPS
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                    (CONS 1 0)
                                                    (CONS 2 0)
                                                    (CONS 3 0)
                                                    (CONS 4 0)
                                                    (CONS 5 0)
                                                    (CONS 6 0)
                                                    (CONS 7 0)
                                                    (CONS 8 0)))
                                       '(ARRAY (BVEC 21) 9)))
               (DECLARE L2PPC
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                    (CONS 1 0)
                                                    (CONS 2 0)
                                                    (CONS 3 0)
                                                    (CONS 4 0)
                                                    (CONS 5 0)
                                                    (CONS 6 0)
                                                    (CONS 7 0)
                                                    (CONS 8 0)))
                                       '(ARRAY (BVEC 21) 9))))
         (FOR ((DECLARE I (RAC-TYPE-INFO 0 '(INT)))
               (LOG< I 9)
               (+ I 1))
              (BLOCK (ASSIGN L2PPS
                             (AS I
                                 (S21 (AG (* 3 I) L1PP)
                                      (AG (+ (* 3 I) 1) L1PP)
                                      (AG (+ (* 3 I) 2) L1PP))
                                 L2PPS))
                     (ASSIGN L2PPC
                             (AS I
                                 (C21 (AG (* 3 I) L1PP)
                                      (AG (+ (* 3 I) 1) L1PP)
                                      (AG (+ (* 3 I) 2) L1PP))
                                 L2PPC))))
         (DECLARE L2PP
                  (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                              (CONS 1 0)
                                              (CONS 2 0)
                                              (CONS 3 0)
                                              (CONS 4 0)
                                              (CONS 5 0)
                                              (CONS 6 0)
                                              (CONS 7 0)
                                              (CONS 8 0)
                                              (CONS 9 0)
                                              (CONS 10 0)
                                              (CONS 11 0)
                                              (CONS 12 0)
                                              (CONS 13 0)
                                              (CONS 14 0)
                                              (CONS 15 0)
                                              (CONS 16 0)
                                              (CONS 17 0)))
                                 '(ARRAY (BVEC 21) 18)))
         (ASSIGN L2PP (AS 0 (AG 0 L2PPC) L2PP))
         (ASSIGN L2PP (AS 1 (AG 1 L2PPC) L2PP))
         (ASSIGN L2PP (AS 2 (AG 2 L2PPC) L2PP))
         (ASSIGN L2PP (AS 3 (AG 3 L2PPC) L2PP))
         (ASSIGN L2PP (AS 4 (AG 2 L2PPS) L2PP))
         (ASSIGN L2PP (AS 5 (AG 6 L2PPC) L2PP))
         (ASSIGN L2PP (AS 6 (AG 8 L2PPS) L2PP))
         (ASSIGN L2PP (AS 7 (AG 8 L2PPC) L2PP))
         (ASSIGN L2PP (AS 8 (AG 4 L2PPS) L2PP))
         (ASSIGN L2PP (AS 9 (AG 5 L2PPC) L2PP))
         (ASSIGN L2PP (AS 10 (AG 1 L2PPS) L2PP))
         (ASSIGN L2PP (AS 11 (AG 5 L2PPS) L2PP))
         (ASSIGN L2PP (AS 12 (AG 4 L2PPC) L2PP))
         (ASSIGN L2PP (AS 13 (AG 0 L2PPS) L2PP))
         (ASSIGN L2PP (AS 14 (AG 6 L2PPS) L2PP))
         (ASSIGN L2PP (AS 15 (AG 7 L2PPC) L2PP))
         (ASSIGN L2PP (AS 16 (AG 3 L2PPS) L2PP))
         (ASSIGN L2PP (AS 17 (AG 7 L2PPS) L2PP))
         (LIST (DECLARE L3PPS
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                    (CONS 1 0)
                                                    (CONS 2 0)
                                                    (CONS 3 0)
                                                    (CONS 4 0)
                                                    (CONS 5 0)))
                                       '(ARRAY (BVEC 21) 6)))
               (DECLARE L3PPC
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                    (CONS 1 0)
                                                    (CONS 2 0)
                                                    (CONS 3 0)
                                                    (CONS 4 0)
                                                    (CONS 5 0)))
                                       '(ARRAY (BVEC 21) 6))))
         (FOR ((DECLARE I (RAC-TYPE-INFO 0 '(INT)))
               (LOG< I 6)
               (+ I 1))
              (BLOCK (ASSIGN L3PPS
                             (AS I
                                 (S21 (AG (* 3 I) L2PP)
                                      (AG (+ (* 3 I) 1) L2PP)
                                      (AG (+ (* 3 I) 2) L2PP))
                                 L3PPS))
                     (ASSIGN L3PPC
                             (AS I
                                 (C21 (AG (* 3 I) L2PP)
                                      (AG (+ (* 3 I) 1) L2PP)
                                      (AG (+ (* 3 I) 2) L2PP))
                                 L3PPC))))
         (DECLARE L3PP
                  (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                              (CONS 1 0)
                                              (CONS 2 0)
                                              (CONS 3 0)
                                              (CONS 4 0)
                                              (CONS 5 0)
                                              (CONS 6 0)
                                              (CONS 7 0)
                                              (CONS 8 0)
                                              (CONS 9 0)
                                              (CONS 10 0)
                                              (CONS 11 0)))
                                 '(ARRAY (BVEC 21) 12)))
         (ASSIGN L3PP (AS 0 (AG 0 L3PPS) L3PP))
         (ASSIGN L3PP (AS 1 (AG 0 L3PPC) L3PP))
         (ASSIGN L3PP (AS 2 (AG 1 L3PPC) L3PP))
         (ASSIGN L3PP (AS 3 (AG 1 L3PPS) L3PP))
         (ASSIGN L3PP (AS 4 (AG 2 L3PPS) L3PP))
         (ASSIGN L3PP (AS 5 (AG 2 L3PPC) L3PP))
         (ASSIGN L3PP (AS 6 (AG 3 L3PPS) L3PP))
         (ASSIGN L3PP (AS 7 (AG 3 L3PPC) L3PP))
         (ASSIGN L3PP (AS 8 (AG 4 L3PPS) L3PP))
         (ASSIGN L3PP (AS 9 (AG 4 L3PPC) L3PP))
         (ASSIGN L3PP (AS 10 (AG 5 L3PPS) L3PP))
         (ASSIGN L3PP (AS 11 (AG 5 L3PPC) L3PP))
         (LIST (DECLARE L4PPS
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                    (CONS 1 0)
                                                    (CONS 2 0)
                                                    (CONS 3 0)))
                                       '(ARRAY (BVEC 21) 4)))
               (DECLARE L4PPC
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                    (CONS 1 0)
                                                    (CONS 2 0)
                                                    (CONS 3 0)))
                                       '(ARRAY (BVEC 21) 4))))
         (FOR ((DECLARE I (RAC-TYPE-INFO 0 '(INT)))
               (LOG< I 4)
               (+ I 1))
              (BLOCK (ASSIGN L4PPS
                             (AS I
                                 (S21 (AG (* 3 I) L3PP)
                                      (AG (+ (* 3 I) 1) L3PP)
                                      (AG (+ (* 3 I) 2) L3PP))
                                 L4PPS))
                     (ASSIGN L4PPC
                             (AS I
                                 (C21 (AG (* 3 I) L3PP)
                                      (AG (+ (* 3 I) 1) L3PP)
                                      (AG (+ (* 3 I) 2) L3PP))
                                 L4PPC))))
         (DECLARE L4PP
                  (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                              (CONS 1 0)
                                              (CONS 2 0)
                                              (CONS 3 0)
                                              (CONS 4 0)
                                              (CONS 5 0)
                                              (CONS 6 0)
                                              (CONS 7 0)))
                                 '(ARRAY (BVEC 21) 8)))
         (ASSIGN L4PP (AS 0 (AG 0 L4PPC) L4PP))
         (ASSIGN L4PP (AS 1 (AG 0 L4PPS) L4PP))
         (ASSIGN L4PP (AS 2 (AG 3 L4PPC) L4PP))
         (ASSIGN L4PP (AS 3 (AG 2 L4PPC) L4PP))
         (ASSIGN L4PP (AS 4 (AG 1 L4PPC) L4PP))
         (ASSIGN L4PP (AS 5 (AG 3 L4PPS) L4PP))
         (ASSIGN L4PP (AS 6 (AG 2 L4PPS) L4PP))
         (ASSIGN L4PP (AS 7 (AG 1 L4PPS) L4PP))
         (LIST (DECLARE L5PPS
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0) (CONS 1 0)))
                                       '(ARRAY (BVEC 21) 2)))
               (DECLARE L5PPC
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0) (CONS 1 0)))
                                       '(ARRAY (BVEC 21) 2))))
         (FOR ((DECLARE I (RAC-TYPE-INFO 0 '(INT)))
               (LOG< I 2)
               (+ I 1))
              (BLOCK (ASSIGN L5PPS
                             (AS I
                                 (S21 (AG (* 3 I) L4PP)
                                      (AG (+ (* 3 I) 1) L4PP)
                                      (AG (+ (* 3 I) 2) L4PP))
                                 L5PPS))
                     (ASSIGN L5PPC
                             (AS I
                                 (C21 (AG (* 3 I) L4PP)
                                      (AG (+ (* 3 I) 1) L4PP)
                                      (AG (+ (* 3 I) 2) L4PP))
                                 L5PPC))))
         (DECLARE L5PP
                  (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                              (CONS 1 0)
                                              (CONS 2 0)
                                              (CONS 3 0)
                                              (CONS 4 0)
                                              (CONS 5 0)))
                                 '(ARRAY (BVEC 21) 6)))
         (ASSIGN L5PP (AS 0 (AG 0 L5PPS) L5PP))
         (ASSIGN L5PP (AS 1 (AG 6 L4PP) L5PP))
         (ASSIGN L5PP (AS 2 (AG 7 L4PP) L5PP))
         (ASSIGN L5PP (AS 3 (AG 0 L5PPC) L5PP))
         (ASSIGN L5PP (AS 4 (AG 1 L5PPS) L5PP))
         (ASSIGN L5PP (AS 5 (AG 1 L5PPC) L5PP))
         (LIST (DECLARE L6PPS
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0) (CONS 1 0)))
                                       '(ARRAY (BVEC 21) 2)))
               (DECLARE L6PPC
                        (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0) (CONS 1 0)))
                                       '(ARRAY (BVEC 21) 2))))
         (FOR ((DECLARE I (RAC-TYPE-INFO 0 '(INT)))
               (LOG< I 2)
               (+ I 1))
              (BLOCK (ASSIGN L6PPS
                             (AS I
                                 (S21 (AG (* 3 I) L5PP)
                                      (AG (+ (* 3 I) 1) L5PP)
                                      (AG (+ (* 3 I) 2) L5PP))
                                 L6PPS))
                     (ASSIGN L6PPC
                             (AS I
                                 (C21 (AG (* 3 I) L5PP)
                                      (AG (+ (* 3 I) 1) L5PP)
                                      (AG (+ (* 3 I) 2) L5PP))
                                 L6PPC))))
         (DECLARE L6PP
                  (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                              (CONS 1 0)
                                              (CONS 2 0)
                                              (CONS 3 0)))
                                 '(ARRAY (BVEC 21) 4)))
         (ASSIGN L6PP (AS 0 (AG 0 L6PPS) L6PP))
         (ASSIGN L6PP (AS 1 (AG 0 L6PPC) L6PP))
         (ASSIGN L6PP (AS 2 (AG 1 L6PPC) L6PP))
         (ASSIGN L6PP (AS 3 (AG 1 L6PPS) L6PP))
         (DECLARE L7PP0S
                  (RAC-TYPE-INFO (S21 (AG 0 L6PP)
                                      (AG 1 L6PP)
                                      (AG 2 L6PP))
                                 '(BVEC 21)))
         (DECLARE L7PP0C
                  (RAC-TYPE-INFO (C21 (AG 0 L6PP)
                                      (AG 1 L6PP)
                                      (AG 2 L6PP))
                                 '(BVEC 21)))
         (DECLARE L7PP
                  (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0) (CONS 1 0) (CONS 2 0)))
                                 '(ARRAY (BVEC 21) 3)))
         (ASSIGN L7PP (AS 0 L7PP0S L7PP))
         (ASSIGN L7PP (AS 1 L7PP0C L7PP))
         (ASSIGN L7PP (AS 2 (AG 3 L6PP) L7PP))
         (DECLARE L8PP0S
                  (RAC-TYPE-INFO (S21 (AG 0 L7PP)
                                      (AG 1 L7PP)
                                      (AG 2 L7PP))
                                 '(BVEC 21)))
         (DECLARE L8PP0C
                  (RAC-TYPE-INFO (C21 (AG 0 L7PP)
                                      (AG 1 L7PP)
                                      (AG 2 L7PP))
                                 '(BVEC 21)))
         (ASSERT (LOG= (BITN L8PP0C 0) 0)
                 COMPRESS_WITHOUT_VDOT16)
         (RETURN (MV L8PP0S L8PP0C))))

(FUNCDEF
 LANE
 (OPA OPB ACC OPA_UNSIGNED
      OPB_UNSIGNED SIZE WITHOUT_VDOT16)
 (BLOCK
  (DECLARE PP
           (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                       (CONS 1 0)
                                       (CONS 2 0)
                                       (CONS 3 0)
                                       (CONS 4 0)
                                       (CONS 5 0)
                                       (CONS 6 0)
                                       (CONS 7 0)
                                       (CONS 8 0)
                                       (CONS 9 0)
                                       (CONS 10 0)
                                       (CONS 11 0)
                                       (CONS 12 0)
                                       (CONS 13 0)
                                       (CONS 14 0)
                                       (CONS 15 0)
                                       (CONS 16 0)
                                       (CONS 17 0)
                                       (CONS 18 0)
                                       (CONS 19 0)
                                       (CONS 20 0)
                                       (CONS 21 0)
                                       (CONS 22 0)
                                       (CONS 23 0)
                                       (CONS 24 0)
                                       (CONS 25 0)
                                       (CONS 26 0)
                                       (CONS 27 0)
                                       (CONS 28 0)
                                       (CONS 29 0)
                                       (CONS 30 0)
                                       (CONS 31 0)
                                       (CONS 32 0)
                                       (CONS 33 0)
                                       (CONS 34 0)
                                       (CONS 35 0)
                                       (CONS 36 0)
                                       (CONS 37 0)
                                       (CONS 38 0)
                                       (CONS 39 0)))
                          '(ARRAY (BVEC 20) 40)))
  (FOR ((DECLARE I (RAC-TYPE-INFO 0 '(INT)))
        (LOG< I 40)
        (+ I 1))
       (BLOCK (ASSIGN PP (AS I 0 PP))))
  (IF SIZE
   (BLOCK
        (LIST (DECLARE A
                       (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                   (CONS 1 0)
                                                   (CONS 2 0)
                                                   (CONS 3 0)))
                                      '(ARRAY (BVEC 16) 4)))
              (DECLARE B
                       (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                   (CONS 1 0)
                                                   (CONS 2 0)
                                                   (CONS 3 0)))
                                      '(ARRAY (BVEC 16) 4))))
        (FOR ((DECLARE ELEM (RAC-TYPE-INFO 0 '(INT)))
              (LOG< ELEM 4)
              (+ ELEM 1))
             (BLOCK (ASSIGN A
                            (AS ELEM
                                (BITS OPA (+ (* ELEM 16) (- 16 1))
                                      (* ELEM 16))
                                A))
                    (ASSIGN B
                            (AS ELEM
                                (BITS OPB (+ (* ELEM 16) (- 16 1))
                                      (* ELEM 16))
                                B))))
        (DECLARE B_ENCS
                 (RAC-TYPE-INFO (AINIT (LIST (CONS 0 NIL)
                                             (CONS 1 NIL)
                                             (CONS 2 NIL)
                                             (CONS 3 NIL)))
                                '(ARRAY (ARRAY (INT) 9) 4)))
        (DECLARE PPS_ALIGNED
                 (RAC-TYPE-INFO (AINIT (LIST (CONS 0
                                                   (AINIT (LIST (CONS 0 0)
                                                                (CONS 1 0)
                                                                (CONS 2 0)
                                                                (CONS 3 0)
                                                                (CONS 4 0)
                                                                (CONS 5 0)
                                                                (CONS 6 0)
                                                                (CONS 7 0)
                                                                (CONS 8 0))))
                                             (CONS 1
                                                   (AINIT (LIST (CONS 0 0)
                                                                (CONS 1 0)
                                                                (CONS 2 0)
                                                                (CONS 3 0)
                                                                (CONS 4 0)
                                                                (CONS 5 0)
                                                                (CONS 6 0)
                                                                (CONS 7 0)
                                                                (CONS 8 0))))
                                             (CONS 2
                                                   (AINIT (LIST (CONS 0 0)
                                                                (CONS 1 0)
                                                                (CONS 2 0)
                                                                (CONS 3 0)
                                                                (CONS 4 0)
                                                                (CONS 5 0)
                                                                (CONS 6 0)
                                                                (CONS 7 0)
                                                                (CONS 8 0))))
                                             (CONS 3
                                                   (AINIT (LIST (CONS 0 0)
                                                                (CONS 1 0)
                                                                (CONS 2 0)
                                                                (CONS 3 0)
                                                                (CONS 4 0)
                                                                (CONS 5 0)
                                                                (CONS 6 0)
                                                                (CONS 7 0)
                                                                (CONS 8 0))))))
                                '(ARRAY (ARRAY (BVEC 20) 9) 4)))
        (FOR ((DECLARE ELEM (RAC-TYPE-INFO 0 '(INT)))
              (LOG< ELEM 4)
              (+ ELEM 1))
             (BLOCK (ASSIGN B_ENCS
                            (AS ELEM
                                (BOOTH16 (AG ELEM A)
                                         (LOGNOT1 OPA_UNSIGNED))
                                B_ENCS))
                    (ASSIGN PPS_ALIGNED
                            (AS ELEM
                                (PARTIALSPRODUCTS16 (AG ELEM B)
                                                    (AG ELEM B_ENCS)
                                                    (LOGNOT1 OPB_UNSIGNED))
                                PPS_ALIGNED))))
        (FOR ((DECLARE INDEX (RAC-TYPE-INFO 0 '(INT)))
              (LOG< INDEX 32)
              (+ INDEX 1))
             (BLOCK (DECLARE ELEM
                             (RAC-TYPE-INFO (TRUNCATE (/ INDEX 8) 1)
                                            '(INT)))
                    (DECLARE I (RAC-TYPE-INFO (REM INDEX 8) '(INT)))
                    (ASSIGN PP
                            (AS (+ (* 8 ELEM) I)
                                (AG I (AG ELEM PPS_ALIGNED))
                                PP))))
        (ASSIGN PP
                (AS 32
                    (BITS (- (AG 8 (AG 0 PPS_ALIGNED)) (ASH 1 18))
                          19 0)
                    PP))
        (ASSIGN PP
                (AS 32
                    (SETBITN (AG 32 PP)
                             20 0 (LOG< (AG 7 (AG 0 B_ENCS)) 0))
                    PP))
        (ASSIGN PP (AS 33 349536 PP))
        (ASSIGN PP
                (AS 34
                    (BITS (- (AG 8 (AG 1 PPS_ALIGNED)) (ASH 1 18))
                          19 0)
                    PP))
        (ASSIGN PP
                (AS 34
                    (SETBITN (AG 34 PP)
                             20 0 (LOG< (AG 7 (AG 1 B_ENCS)) 0))
                    PP))
        (ASSIGN PP
                (AS 36
                    (BITS (- (AG 8 (AG 2 PPS_ALIGNED)) (ASH 1 18))
                          19 0)
                    PP))
        (ASSIGN PP
                (AS 36
                    (SETBITN (AG 36 PP)
                             20 0 (LOG< (AG 7 (AG 2 B_ENCS)) 0))
                    PP))
        (ASSIGN PP
                (AS 38
                    (BITS (- (AG 8 (AG 3 PPS_ALIGNED)) (ASH 1 18))
                          19 0)
                    PP))
        (ASSIGN PP
                (AS 38
                    (SETBITN (AG 38 PP)
                             20 0 (LOG< (AG 7 (AG 3 B_ENCS)) 0))
                    PP)))
   (BLOCK
    (LIST (DECLARE A
                   (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                               (CONS 1 0)
                                               (CONS 2 0)
                                               (CONS 3 0)
                                               (CONS 4 0)
                                               (CONS 5 0)
                                               (CONS 6 0)
                                               (CONS 7 0)))
                                  '(ARRAY (BVEC 8) 8)))
          (DECLARE B
                   (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                               (CONS 1 0)
                                               (CONS 2 0)
                                               (CONS 3 0)
                                               (CONS 4 0)
                                               (CONS 5 0)
                                               (CONS 6 0)
                                               (CONS 7 0)))
                                  '(ARRAY (BVEC 8) 8))))
    (FOR ((DECLARE ELEM (RAC-TYPE-INFO 0 '(INT)))
          (LOG< ELEM 8)
          (+ ELEM 1))
         (BLOCK (ASSIGN A
                        (AS ELEM
                            (BITS OPA (+ (* ELEM 8) (- 8 1))
                                  (* ELEM 8))
                            A))
                (ASSIGN B
                        (AS ELEM
                            (BITS OPB (+ (* ELEM 8) (- 8 1))
                                  (* ELEM 8))
                            B))))
    (DECLARE B_ENCS
             (RAC-TYPE-INFO (AINIT (LIST (CONS 0 NIL)
                                         (CONS 1 NIL)
                                         (CONS 2 NIL)
                                         (CONS 3 NIL)
                                         (CONS 4 NIL)
                                         (CONS 5 NIL)
                                         (CONS 6 NIL)
                                         (CONS 7 NIL)))
                            '(ARRAY (ARRAY (INT) 5) 8)))
    (DECLARE PPS_ALIGNED
             (RAC-TYPE-INFO (AINIT (LIST (CONS 0
                                               (AINIT (LIST (CONS 0 0)
                                                            (CONS 1 0)
                                                            (CONS 2 0)
                                                            (CONS 3 0)
                                                            (CONS 4 0))))
                                         (CONS 1
                                               (AINIT (LIST (CONS 0 0)
                                                            (CONS 1 0)
                                                            (CONS 2 0)
                                                            (CONS 3 0)
                                                            (CONS 4 0))))
                                         (CONS 2
                                               (AINIT (LIST (CONS 0 0)
                                                            (CONS 1 0)
                                                            (CONS 2 0)
                                                            (CONS 3 0)
                                                            (CONS 4 0))))
                                         (CONS 3
                                               (AINIT (LIST (CONS 0 0)
                                                            (CONS 1 0)
                                                            (CONS 2 0)
                                                            (CONS 3 0)
                                                            (CONS 4 0))))
                                         (CONS 4
                                               (AINIT (LIST (CONS 0 0)
                                                            (CONS 1 0)
                                                            (CONS 2 0)
                                                            (CONS 3 0)
                                                            (CONS 4 0))))
                                         (CONS 5
                                               (AINIT (LIST (CONS 0 0)
                                                            (CONS 1 0)
                                                            (CONS 2 0)
                                                            (CONS 3 0)
                                                            (CONS 4 0))))
                                         (CONS 6
                                               (AINIT (LIST (CONS 0 0)
                                                            (CONS 1 0)
                                                            (CONS 2 0)
                                                            (CONS 3 0)
                                                            (CONS 4 0))))
                                         (CONS 7
                                               (AINIT (LIST (CONS 0 0)
                                                            (CONS 1 0)
                                                            (CONS 2 0)
                                                            (CONS 3 0)
                                                            (CONS 4 0))))))
                            '(ARRAY (ARRAY (BVEC 12) 5) 8)))
    (FOR ((DECLARE ELEM (RAC-TYPE-INFO 0 '(INT)))
          (LOG< ELEM 8)
          (+ ELEM 1))
         (BLOCK (ASSIGN B_ENCS
                        (AS ELEM
                            (BOOTH8 (AG ELEM A)
                                    (LOGNOT1 OPA_UNSIGNED))
                            B_ENCS))
                (ASSIGN PPS_ALIGNED
                        (AS ELEM
                            (PARTIALSPRODUCTS8 (AG ELEM B)
                                               (AG ELEM B_ENCS)
                                               (LOGNOT1 OPB_UNSIGNED))
                            PPS_ALIGNED))))
    (FOR
        ((DECLARE INDEX (RAC-TYPE-INFO 0 '(INT)))
         (LOG< INDEX 32)
         (+ INDEX 1))
        (BLOCK (DECLARE ELEM
                        (RAC-TYPE-INFO (TRUNCATE (/ INDEX 4) 1)
                                       '(INT)))
               (DECLARE I (RAC-TYPE-INFO (REM INDEX 4) '(INT)))
               (IF (LOG= (REM ELEM 2) 0)
                   (BLOCK (ASSIGN PP
                                  (AS (+ (* 4 ELEM) I)
                                      (BITS (ASH (AG I (AG ELEM PPS_ALIGNED)) 8)
                                            19 0)
                                      PP)))
                 (BLOCK (ASSIGN PP
                                (AS (+ (* 4 ELEM) I)
                                    (BITS (ASH (AG I (AG ELEM PPS_ALIGNED))
                                               (IF1 (LOG= I 0) 2 0))
                                          19 0)
                                    PP))))))
    (FOR
     ((DECLARE ELEM (RAC-TYPE-INFO 0 '(INT)))
      (LOG< ELEM 8)
      (+ ELEM 1))
     (BLOCK
         (ASSIGN PP
                 (AS (+ 32 ELEM)
                     (BITS (- (AG 4 (AG ELEM PPS_ALIGNED))
                              (ASH 1 10))
                           19 0)
                     PP))
         (IF (LOG= (REM ELEM 2) 0)
             (BLOCK (ASSIGN PP
                            (AS (+ 32 ELEM)
                                (SETBITN (AG (+ 32 ELEM) PP)
                                         20 0
                                         (LOG< (AG 3 (AG (+ ELEM 1) B_ENCS)) 0))
                                PP)))
           (BLOCK (ASSIGN PP
                          (AS (+ 32 ELEM)
                              (SETBITN (AG (+ 32 ELEM) PP)
                                       20 0
                                       (LOG< (AG 3 (AG (- ELEM 1) B_ENCS)) 0))
                              PP))))))
    (ASSIGN PP
            (AS 4 (BITS (+ (AG 4 PP) 704512) 19 0)
                PP))))
  (IF WITHOUT_VDOT16 (BLOCK (DECLARE L0PP
                                     (RAC-TYPE-INFO (CONVERT_PP PP)
                                                    '(ARRAY (BVEC 21) 40)))
                            (LIST (DECLARE PPS (RAC-TYPE-INFO 0 '(BVEC 21)))
                                  (DECLARE PPC (RAC-TYPE-INFO 0 '(BVEC 21))))
                            (MV-ASSIGN (PPS PPC)
                                       (COMPRESS_WITHOUT_VDOT16 L0PP))
                            (DECLARE SUM_PP
                                     (RAC-TYPE-INFO (BITS (+ PPS PPC) 20 0)
                                                    '(BVEC 21)))
                            (RETURN (BITS (+ (+ SUM_PP ACC) 4293918720)
                                          63 0)))
    (BLOCK (DECLARE L0PP
                    (RAC-TYPE-INFO (AINIT (LIST (CONS 0 0)
                                                (CONS 1 0)
                                                (CONS 2 0)
                                                (CONS 3 0)
                                                (CONS 4 0)
                                                (CONS 5 0)
                                                (CONS 6 0)
                                                (CONS 7 0)
                                                (CONS 8 0)
                                                (CONS 9 0)
                                                (CONS 10 0)
                                                (CONS 11 0)
                                                (CONS 12 0)
                                                (CONS 13 0)
                                                (CONS 14 0)
                                                (CONS 15 0)
                                                (CONS 16 0)
                                                (CONS 17 0)
                                                (CONS 18 0)
                                                (CONS 19 0)
                                                (CONS 20 0)
                                                (CONS 21 0)
                                                (CONS 22 0)
                                                (CONS 23 0)
                                                (CONS 24 0)
                                                (CONS 25 0)
                                                (CONS 26 0)
                                                (CONS 27 0)
                                                (CONS 28 0)
                                                (CONS 29 0)
                                                (CONS 30 0)
                                                (CONS 31 0)
                                                (CONS 32 0)
                                                (CONS 33 0)
                                                (CONS 34 0)
                                                (CONS 35 0)
                                                (CONS 36 0)
                                                (CONS 37 0)
                                                (CONS 38 0)
                                                (CONS 39 0)))
                                   '(ARRAY (BVEC 36) 40)))
           (FOR ((DECLARE I (RAC-TYPE-INFO 0 '(INT)))
                 (LOG< I 40)
                 (+ I 1))
                (BLOCK (ASSIGN L0PP (AS I 0 L0PP))))
           (ASSIGN L0PP
                   (AS 0 (BITS (ASH (AG 35 PP) 14) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 1 (BITS (ASH (AG 37 PP) 14) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 2 (BITS (ASH (AG 39 PP) 14) 35 0)
                       L0PP))
           (ASSIGN L0PP (AS 3 (AG 0 PP) L0PP))
           (ASSIGN L0PP (AS 4 (AG 8 PP) L0PP))
           (ASSIGN L0PP (AS 5 (AG 16 PP) L0PP))
           (ASSIGN L0PP (AS 6 (AG 24 PP) L0PP))
           (ASSIGN L0PP (AS 7 (AG 1 PP) L0PP))
           (ASSIGN L0PP (AS 8 (AG 9 PP) L0PP))
           (ASSIGN L0PP (AS 9 (AG 17 PP) L0PP))
           (ASSIGN L0PP (AS 10 (AG 25 PP) L0PP))
           (ASSIGN L0PP
                   (AS 11 (BITS (ASH (AG 2 PP) 2) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 12 (BITS (ASH (AG 10 PP) 2) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 13 (BITS (ASH (AG 18 PP) 2) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 14 (BITS (ASH (AG 26 PP) 2) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 15 (BITS (ASH (AG 3 PP) 4) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 16 (BITS (ASH (AG 11 PP) 4) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 17 (BITS (ASH (AG 19 PP) 4) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 18 (BITS (ASH (AG 27 PP) 4) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 19 (BITS (ASH (AG 4 PP) 6) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 20 (BITS (ASH (AG 12 PP) 6) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 21 (BITS (ASH (AG 20 PP) 6) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 22 (BITS (ASH (AG 28 PP) 6) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 23 (BITS (ASH (AG 5 PP) 8) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 24 (BITS (ASH (AG 13 PP) 8) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 25 (BITS (ASH (AG 21 PP) 8) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 26 (BITS (ASH (AG 29 PP) 8) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 27 (BITS (ASH (AG 6 PP) 10) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 28 (BITS (ASH (AG 14 PP) 10) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 29 (BITS (ASH (AG 22 PP) 10) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 30 (BITS (ASH (AG 30 PP) 10) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 31 (BITS (ASH (AG 7 PP) 12) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 32 (BITS (ASH (AG 15 PP) 12) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 33 (BITS (ASH (AG 23 PP) 12) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 34 (BITS (ASH (AG 31 PP) 12) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 35 (BITS (ASH (AG 32 PP) 14) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 36 (BITS (ASH (AG 34 PP) 14) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 37 (BITS (ASH (AG 36 PP) 14) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 38 (BITS (ASH (AG 38 PP) 14) 35 0)
                       L0PP))
           (ASSIGN L0PP
                   (AS 39 (BITS (ASH (AG 33 PP) 14) 35 0)
                       L0PP))
           (LIST (DECLARE PPS (RAC-TYPE-INFO 0 '(BVEC 36)))
                 (DECLARE PPC (RAC-TYPE-INFO 0 '(BVEC 36))))
           (MV-ASSIGN (PPS PPC) (COMPRESS L0PP))
           (DECLARE SUM_PP
                    (RAC-TYPE-INFO (BITS (+ PPS PPC) 35 0)
                                   '(BVEC 36)))
           (IF SIZE (BLOCK (RETURN (BITS (+ (+ SUM_PP ACC) 18446744039349813248)
                                         63 0)))
             (BLOCK (RETURN (BITS (+ (+ (ASH SUM_PP (- 8))
                                        18446744073708503040)
                                     ACC)
                                  63 0))))))))

(FUNCDEF
 VDOT
 (OPA OPB ACC OPA_UNSIGNED OPB_UNSIGNED
      QUAD_RESULT SIZE MMLA SCALAR
      INDEX_IN SEL_4WAYS WITHOUT_VDOT16)
 (BLOCK
  (DECLARE INDEX (RAC-TYPE-INFO INDEX_IN '(INT)))
  (DECLARE OPA_LANE1 (RAC-TYPE-INFO 0 '(BVEC 64)))
  (DECLARE OPB_LANE1 (RAC-TYPE-INFO 0 '(BVEC 64)))
  (DECLARE ACC_LANE1 (RAC-TYPE-INFO 0 '(BVEC 64)))
  (IF SIZE
   (BLOCK
        (IF SEL_4WAYS (BLOCK (ASSIGN OPA_LANE1 (BITS OPA 63 0))
                             (ASSIGN OPB_LANE1
                                     (BITS OPB
                                           (+ (* (* (IF1 SCALAR INDEX 0) 4) 16)
                                              (- 64 1))
                                           (* (* (IF1 SCALAR INDEX 0) 4) 16)))
                             (ASSIGN ACC_LANE1 (BITS ACC 63 0)))
          (BLOCK (ASSIGN OPA_LANE1 (BITS OPA 63 0))
                 (ASSIGN OPB_LANE1
                         (BITS OPB
                               (+ (* (* (IF1 SCALAR INDEX 0) 2) 16)
                                  (- 32 1))
                               (* (* (IF1 SCALAR INDEX 0) 2) 16)))
                 (ASSIGN ACC_LANE1 (BITS ACC 31 0)))))
   (BLOCK (IF MMLA (BLOCK (ASSIGN OPA_LANE1 (BITS OPA 63 0))
                          (ASSIGN OPB_LANE1 (BITS OPB 63 0))
                          (ASSIGN ACC_LANE1 (BITS ACC 31 0)))
            (BLOCK (ASSIGN OPA_LANE1 (BITS OPA 31 0))
                   (ASSIGN OPB_LANE1
                           (BITS OPB
                                 (+ (* (* (IF1 SCALAR INDEX 0) 4) 8)
                                    (- 32 1))
                                 (* (* (IF1 SCALAR INDEX 0) 4) 8)))
                   (ASSIGN ACC_LANE1 (BITS ACC 31 0))))))
  (DECLARE LANE1_RES
           (RAC-TYPE-INFO (LANE OPA_LANE1
                                OPB_LANE1 ACC_LANE1 OPA_UNSIGNED
                                OPB_UNSIGNED SIZE WITHOUT_VDOT16)
                          '(BVEC 128)))
  (DECLARE OPA_LANE2 (RAC-TYPE-INFO 0 '(BVEC 64)))
  (DECLARE OPB_LANE2 (RAC-TYPE-INFO 0 '(BVEC 64)))
  (IF SIZE
      (BLOCK (IF SEL_4WAYS (BLOCK)
               (BLOCK (ASSIGN OPA_LANE2
                              (LOGIOR (BITS OPA 63 32)
                                      (BITS (ASH (BITS OPA 31 0) 32) 63 0)))
                      (ASSIGN OPB_LANE2
                              (BITS OPB
                                    (+ (* (* (IF1 SCALAR INDEX 1) 2) 16)
                                       (- 32 1))
                                    (* (* (IF1 SCALAR INDEX 1) 2) 16))))))
   (BLOCK
        (IF MMLA (BLOCK (ASSIGN OPA_LANE2
                                (LOGIOR (BITS OPA 63 32)
                                        (BITS (ASH (BITS OPA 31 0) 32) 63 0)))
                        (ASSIGN OPB_LANE2
                                (LOGIOR (BITS OPB 127 96)
                                        (BITS (ASH (BITS OPB 95 64) 32) 63 0))))
          (BLOCK (ASSIGN OPA_LANE2 (BITS OPA 63 32))
                 (ASSIGN OPB_LANE2
                         (BITS OPB
                               (+ (* (* (IF1 SCALAR INDEX 1) 4) 8)
                                  (- 32 1))
                               (* (* (IF1 SCALAR INDEX 1) 4) 8)))))))
  (DECLARE LANE2_RES
           (RAC-TYPE-INFO (LANE OPA_LANE2 OPB_LANE2 (BITS ACC 63 32)
                                OPA_UNSIGNED
                                OPB_UNSIGNED SIZE WITHOUT_VDOT16)
                          '(BVEC 128)))
  (DECLARE OPA_LANE3 (RAC-TYPE-INFO 0 '(BVEC 64)))
  (DECLARE OPB_LANE3 (RAC-TYPE-INFO 0 '(BVEC 64)))
  (DECLARE ACC_LANE3 (RAC-TYPE-INFO 0 '(BVEC 64)))
  (IF SIZE
   (BLOCK
        (IF SEL_4WAYS (BLOCK (ASSIGN OPA_LANE3 (BITS OPA 127 64))
                             (ASSIGN OPB_LANE3
                                     (BITS OPB
                                           (+ (* (* (IF1 SCALAR INDEX 1) 4) 16)
                                              (- 64 1))
                                           (* (* (IF1 SCALAR INDEX 1) 4) 16)))
                             (ASSIGN ACC_LANE3 (BITS ACC 127 64)))
          (BLOCK (ASSIGN OPA_LANE3 (BITS OPA 127 64))
                 (ASSIGN OPB_LANE3
                         (BITS OPB
                               (+ (* (* (IF1 SCALAR INDEX 2) 2) 16)
                                  (- 32 1))
                               (* (* (IF1 SCALAR INDEX 2) 2) 16)))
                 (ASSIGN ACC_LANE3 (BITS ACC 95 64)))))
   (BLOCK (IF MMLA (BLOCK (ASSIGN OPA_LANE3 (BITS OPA 127 64))
                          (ASSIGN OPB_LANE3 (BITS OPB 63 0))
                          (ASSIGN ACC_LANE3 (BITS ACC 95 64)))
            (BLOCK (ASSIGN OPA_LANE3 (BITS OPA 95 64))
                   (ASSIGN OPB_LANE3
                           (BITS OPB
                                 (+ (* (* (IF1 SCALAR INDEX 2) 4) 8)
                                    (- 32 1))
                                 (* (* (IF1 SCALAR INDEX 2) 4) 8)))
                   (ASSIGN ACC_LANE3 (BITS ACC 95 64))))))
  (DECLARE LANE3_RES
           (RAC-TYPE-INFO (LANE OPA_LANE3
                                OPB_LANE3 ACC_LANE3 OPA_UNSIGNED
                                OPB_UNSIGNED SIZE WITHOUT_VDOT16)
                          '(BVEC 128)))
  (DECLARE OPA_LANE4 (RAC-TYPE-INFO 0 '(BVEC 64)))
  (DECLARE OPB_LANE4 (RAC-TYPE-INFO 0 '(BVEC 64)))
  (IF (LOGIOR1 MMLA SIZE)
      (BLOCK (IF SEL_4WAYS
                 (BLOCK (ASSIGN OPA_LANE4
                                (LOGIOR (BITS OPA 127 96)
                                        (BITS (ASH (BITS OPA 95 64) 32) 63 0)))
                        (ASSIGN OPB_LANE4
                                (LOGIOR (BITS OPB 127 96)
                                        (BITS (ASH (BITS OPB 95 64) 32) 63 0))))
               (BLOCK (ASSIGN OPA_LANE4
                              (LOGIOR (BITS OPA 127 96)
                                      (BITS (ASH (BITS OPA 95 64) 32) 63 0)))
                      (ASSIGN OPB_LANE4
                              (BITS OPB
                                    (+ (* (* (IF1 SCALAR INDEX 3) 2) 16)
                                       (- 32 1))
                                    (* (* (IF1 SCALAR INDEX 3) 2) 16))))))
    (BLOCK (ASSIGN OPA_LANE4 (BITS OPA 127 96))
           (ASSIGN OPB_LANE4
                   (BITS OPB
                         (+ (* (* (IF1 SCALAR INDEX 3) 4) 8)
                            (- 32 1))
                         (* (* (IF1 SCALAR INDEX 3) 4) 8)))))
  (DECLARE LANE4_RES
           (RAC-TYPE-INFO (LANE OPA_LANE4 OPB_LANE4 (BITS ACC 127 96)
                                OPA_UNSIGNED
                                OPB_UNSIGNED SIZE WITHOUT_VDOT16)
                          '(BVEC 128)))
  (DECLARE RES (RAC-TYPE-INFO 0 '(BVEC 128)))
  (IF SIZE
   (BLOCK
     (IF SEL_4WAYS
      (BLOCK (ASSIGN RES (BITS LANE1_RES 63 0))
             (IF QUAD_RESULT
                 (BLOCK (ASSIGN RES
                                (SETBITS RES 128 127 64 (BITS LANE3_RES 63 0))))
               NIL))
      (BLOCK (ASSIGN RES
                     (SETBITS RES 128 31 0 (BITS LANE1_RES 31 0)))
             (ASSIGN RES
                     (SETBITS RES 128 63 32 (BITS LANE2_RES 31 0)))
             (IF QUAD_RESULT
                 (BLOCK (ASSIGN RES
                                (SETBITS RES 128 95 64 (BITS LANE3_RES 31 0)))
                        (ASSIGN RES
                                (SETBITS RES 128 127 96 (BITS LANE4_RES 31 0))))
               NIL))))
   (BLOCK (ASSIGN RES (BITS LANE1_RES 31 0))
          (ASSIGN RES
                  (SETBITS RES 128 63 32 (BITS LANE2_RES 31 0)))
          (IF QUAD_RESULT
              (BLOCK (ASSIGN RES
                             (SETBITS RES 128 95 64 (BITS LANE3_RES 31 0)))
                     (ASSIGN RES
                             (SETBITS RES 128 127 96 (BITS LANE4_RES 31 0))))
            NIL)))
  (RETURN RES)))

