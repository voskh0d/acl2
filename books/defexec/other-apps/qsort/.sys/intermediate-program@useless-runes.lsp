(DEL-LAST
 (99 46 (:REWRITE DEFAULT-+-2))
 (65 46 (:REWRITE DEFAULT-+-1))
 (32 8 (:REWRITE COMMUTATIVITY-OF-+))
 (32 8 (:DEFINITION INTEGER-ABS))
 (32 4 (:DEFINITION LENGTH))
 (20 20 (:REWRITE DEFAULT-CDR))
 (20 4 (:DEFINITION LEN))
 (17 12 (:REWRITE DEFAULT-<-2))
 (16 12 (:REWRITE DEFAULT-<-1))
 (15 15 (:REWRITE FOLD-CONSTS-IN-+))
 (10 10 (:REWRITE DEFAULT-CAR))
 (8 8 (:REWRITE DEFAULT-UNARY-MINUS))
 (4 4 (:TYPE-PRESCRIPTION LEN))
 (4 4 (:REWRITE DEFAULT-REALPART))
 (4 4 (:REWRITE DEFAULT-NUMERATOR))
 (4 4 (:REWRITE DEFAULT-IMAGPART))
 (4 4 (:REWRITE DEFAULT-DENOMINATOR))
 (4 4 (:REWRITE DEFAULT-COERCE-2))
 (4 4 (:REWRITE DEFAULT-COERCE-1))
 (2 2 (:LINEAR ACL2-COUNT-CAR-CDR-LINEAR))
 )
(LAST-VAL)
(SNOC)
(LOWER-PART
 (4736 1996 (:REWRITE DEFAULT-+-2))
 (2820 1996 (:REWRITE DEFAULT-+-1))
 (1088 272 (:DEFINITION INTEGER-ABS))
 (1088 136 (:DEFINITION LENGTH))
 (680 136 (:DEFINITION LEN))
 (643 378 (:REWRITE DEFAULT-<-2))
 (624 26 (:LINEAR ACL2-COUNT-CAR-CDR-LINEAR))
 (482 378 (:REWRITE DEFAULT-<-1))
 (421 407 (:REWRITE DEFAULT-CAR))
 (352 88 (:REWRITE <<-ASYMMETRIC))
 (272 272 (:REWRITE DEFAULT-UNARY-MINUS))
 (176 176 (:REWRITE <<-TRANSITIVE))
 (136 136 (:TYPE-PRESCRIPTION LEN))
 (136 136 (:REWRITE DEFAULT-REALPART))
 (136 136 (:REWRITE DEFAULT-NUMERATOR))
 (136 136 (:REWRITE DEFAULT-IMAGPART))
 (136 136 (:REWRITE DEFAULT-DENOMINATOR))
 (136 136 (:REWRITE DEFAULT-COERCE-2))
 (136 136 (:REWRITE DEFAULT-COERCE-1))
 )
(UPPER-PART
 (4736 1996 (:REWRITE DEFAULT-+-2))
 (2820 1996 (:REWRITE DEFAULT-+-1))
 (1088 272 (:DEFINITION INTEGER-ABS))
 (1088 136 (:DEFINITION LENGTH))
 (680 136 (:DEFINITION LEN))
 (643 378 (:REWRITE DEFAULT-<-2))
 (624 26 (:LINEAR ACL2-COUNT-CAR-CDR-LINEAR))
 (482 378 (:REWRITE DEFAULT-<-1))
 (421 407 (:REWRITE DEFAULT-CAR))
 (352 88 (:REWRITE <<-ASYMMETRIC))
 (272 272 (:REWRITE DEFAULT-UNARY-MINUS))
 (176 176 (:REWRITE <<-TRANSITIVE))
 (136 136 (:TYPE-PRESCRIPTION LEN))
 (136 136 (:REWRITE DEFAULT-REALPART))
 (136 136 (:REWRITE DEFAULT-NUMERATOR))
 (136 136 (:REWRITE DEFAULT-IMAGPART))
 (136 136 (:REWRITE DEFAULT-DENOMINATOR))
 (136 136 (:REWRITE DEFAULT-COERCE-2))
 (136 136 (:REWRITE DEFAULT-COERCE-1))
 )
(HOW-MANY-SNOC-REDUCTION
 (114 59 (:REWRITE DEFAULT-+-2))
 (78 54 (:REWRITE DEFAULT-CDR))
 (63 59 (:REWRITE DEFAULT-+-1))
 (48 36 (:REWRITE DEFAULT-CAR))
 (25 25 (:REWRITE PERM-IMPLIES-HOW-MANY-EQUAL-NEW))
 (2 2 (:REWRITE FOLD-CONSTS-IN-+))
 )
(HOW-MANY-DEL-LAST-REDUCTION
 (160 83 (:REWRITE DEFAULT-+-2))
 (95 83 (:REWRITE DEFAULT-+-1))
 (82 79 (:REWRITE DEFAULT-CAR))
 (51 51 (:REWRITE PERM-IMPLIES-HOW-MANY-EQUAL-NEW))
 (4 4 (:REWRITE DEFAULT-UNARY-MINUS))
 )
(HOW-MANY-LOWER-UPPER-REDUCTION
 (3260 3044 (:REWRITE DEFAULT-CDR))
 (1872 1770 (:REWRITE DEFAULT-CAR))
 (1061 536 (:REWRITE DEFAULT-+-2))
 (950 242 (:REWRITE <<-ASYMMETRIC))
 (750 150 (:DEFINITION SNOC))
 (659 536 (:REWRITE DEFAULT-+-1))
 (568 508 (:REWRITE <<-TRANSITIVE))
 (400 400 (:TYPE-PRESCRIPTION UPPER-PART))
 (195 195 (:REWRITE PERM-IMPLIES-HOW-MANY-EQUAL-NEW))
 (30 30 (:REWRITE <<-IRREFLEXIVE))
 (2 2 (:TYPE-PRESCRIPTION SNOC))
 (2 2 (:REWRITE DEFAULT-UNARY-MINUS))
 )
(HOW-MANY-LOWER-UPPER-REDUCTION-REDUCED-TO-APPEND
 (107 1 (:DEFINITION UPPER-PART))
 (73 1 (:DEFINITION LOWER-PART))
 (66 66 (:REWRITE DEFAULT-CDR))
 (56 4 (:DEFINITION HOW-MANY))
 (44 11 (:DEFINITION LAST-VAL))
 (40 40 (:REWRITE DEFAULT-CAR))
 (40 10 (:DEFINITION DEL-LAST))
 (25 5 (:DEFINITION SNOC))
 (24 6 (:REWRITE <<-ASYMMETRIC))
 (18 18 (:TYPE-PRESCRIPTION <<))
 (16 8 (:REWRITE DEFAULT-+-2))
 (12 12 (:TYPE-PRESCRIPTION UPPER-PART))
 (12 12 (:REWRITE <<-TRANSITIVE))
 (12 4 (:REWRITE UNICITY-OF-0))
 (10 6 (:REWRITE <<=-TRANSITIVE))
 (8 8 (:TYPE-PRESCRIPTION <<=))
 (8 8 (:REWRITE DEFAULT-+-1))
 (8 4 (:DEFINITION FIX))
 (5 1 (:DEFINITION BINARY-APPEND))
 (4 4 (:TYPE-PRESCRIPTION LOWER-PART))
 (4 4 (:REWRITE PERM-IMPLIES-HOW-MANY-EQUAL-NEW))
 )
(PERM-APPEND-LOWER-UPPER-REDUCTION
 (107 1 (:DEFINITION UPPER-PART))
 (73 1 (:DEFINITION LOWER-PART))
 (62 62 (:REWRITE DEFAULT-CDR))
 (44 11 (:DEFINITION LAST-VAL))
 (40 10 (:DEFINITION DEL-LAST))
 (38 38 (:REWRITE DEFAULT-CAR))
 (26 2 (:DEFINITION HOW-MANY))
 (25 5 (:DEFINITION SNOC))
 (24 6 (:REWRITE <<-ASYMMETRIC))
 (18 18 (:TYPE-PRESCRIPTION <<))
 (12 12 (:REWRITE <<-TRANSITIVE))
 (10 10 (:TYPE-PRESCRIPTION UPPER-PART))
 (10 6 (:REWRITE <<=-TRANSITIVE))
 (8 8 (:TYPE-PRESCRIPTION <<=))
 (8 4 (:REWRITE DEFAULT-+-2))
 (6 2 (:REWRITE UNICITY-OF-0))
 (5 1 (:DEFINITION BINARY-APPEND))
 (4 4 (:REWRITE DEFAULT-+-1))
 (4 2 (:DEFINITION FIX))
 (2 2 (:TYPE-PRESCRIPTION LOWER-PART))
 (2 2 (:REWRITE PERM-IMPLIES-HOW-MANY-EQUAL-NEW))
 )
(LEN-LOWER-PART-REDUCTION)
(LEN-CONSP-REDUCTION-1
 (36 19 (:REWRITE DEFAULT-+-2))
 (32 16 (:TYPE-PRESCRIPTION TRUE-LISTP-APPEND))
 (28 22 (:REWRITE DEFAULT-CDR))
 (19 19 (:REWRITE DEFAULT-+-1))
 (16 16 (:TYPE-PRESCRIPTION TRUE-LISTP))
 (16 16 (:TYPE-PRESCRIPTION BINARY-APPEND))
 (14 7 (:REWRITE DEFAULT-<-1))
 (13 7 (:REWRITE DEFAULT-<-2))
 (5 5 (:REWRITE DEFAULT-CAR))
 )
(UPPER-HAS-LESS-LEN)
(LEN-CONSP-REDUCTION-2
 (35 17 (:REWRITE DEFAULT-CDR))
 (31 17 (:REWRITE DEFAULT-+-2))
 (24 12 (:TYPE-PRESCRIPTION TRUE-LISTP-APPEND))
 (17 17 (:REWRITE DEFAULT-+-1))
 (12 12 (:TYPE-PRESCRIPTION TRUE-LISTP))
 (11 6 (:REWRITE DEFAULT-<-2))
 (11 6 (:REWRITE DEFAULT-<-1))
 (4 4 (:REWRITE DEFAULT-CAR))
 )
(UPPER-PART-IS-CONSP
 (163 163 (:REWRITE DEFAULT-CAR))
 (45 39 (:REWRITE <<-TRANSITIVE))
 (24 24 (:REWRITE CDR-CONS))
 (14 14 (:REWRITE CAR-CONS))
 )
(LOWER-HAS-LESS-LEN
 (58 1 (:DEFINITION UPPER-PART))
 (39 1 (:DEFINITION LOWER-PART))
 (35 35 (:REWRITE DEFAULT-CDR))
 (28 7 (:DEFINITION LAST-VAL))
 (24 6 (:DEFINITION DEL-LAST))
 (22 22 (:REWRITE DEFAULT-CAR))
 (15 3 (:DEFINITION SNOC))
 (12 2 (:DEFINITION LEN))
 (8 2 (:REWRITE <<-ASYMMETRIC))
 (6 6 (:TYPE-PRESCRIPTION <<))
 (4 4 (:REWRITE <<=-TRANSITIVE))
 (4 4 (:REWRITE <<-TRANSITIVE))
 (4 2 (:REWRITE DEFAULT-+-2))
 (2 2 (:TYPE-PRESCRIPTION LOWER-PART))
 (2 2 (:TYPE-PRESCRIPTION <<=))
 (2 2 (:REWRITE DEFAULT-+-1))
 (2 2 (:REWRITE <<=-REFLEXIVE))
 (2 1 (:REWRITE DEFAULT-<-2))
 (2 1 (:REWRITE DEFAULT-<-1))
 )
(LEN-IS-AN-ORDINAL
 (5 1 (:DEFINITION LEN))
 (2 1 (:REWRITE DEFAULT-+-2))
 (1 1 (:REWRITE DEFAULT-CDR))
 (1 1 (:REWRITE DEFAULT-+-1))
 )
(LEN-LESS-IN-CDR
 (8 4 (:REWRITE DEFAULT-+-2))
 (5 5 (:REWRITE DEFAULT-CDR))
 (4 4 (:REWRITE DEFAULT-+-1))
 (2 1 (:REWRITE DEFAULT-<-2))
 (2 1 (:REWRITE DEFAULT-<-1))
 (1 1 (:REWRITE LEN-CONSP-REDUCTION-2))
 )
(QSORT-FN
 (228 4 (:DEFINITION LOWER-PART))
 (142 142 (:REWRITE DEFAULT-CDR))
 (128 32 (:DEFINITION LAST-VAL))
 (90 20 (:DEFINITION DEL-LAST))
 (80 1 (:DEFINITION UPPER-PART))
 (59 59 (:REWRITE DEFAULT-CAR))
 (20 5 (:REWRITE <<-ASYMMETRIC))
 (15 15 (:TYPE-PRESCRIPTION <<))
 (15 3 (:DEFINITION SNOC))
 (10 10 (:REWRITE <<=-TRANSITIVE))
 (10 10 (:REWRITE <<-TRANSITIVE))
 (5 5 (:TYPE-PRESCRIPTION <<=))
 (5 5 (:REWRITE <<=-REFLEXIVE))
 (1 1 (:TYPE-PRESCRIPTION TRUE-LISTP))
 (1 1 (:REWRITE LEN-CONSP-REDUCTION-2))
 )
