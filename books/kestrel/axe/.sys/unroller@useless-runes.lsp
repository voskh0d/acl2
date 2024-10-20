(EXPAND-FUNCTION-CALL
 (735 13 (:DEFINITION ACL2-COUNT))
 (423 35 (:REWRITE CONSP-FROM-LEN-CHEAP))
 (255 21 (:REWRITE LEN-OF-CDR))
 (196 99 (:REWRITE DEFAULT-+-2))
 (133 99 (:REWRITE DEFAULT-+-1))
 (120 15 (:REWRITE EQUAL-OF-LEN-AND-0))
 (113 19 (:REWRITE DEFAULT-CAR))
 (88 18 (:REWRITE DEFAULT-CDR))
 (80 20 (:REWRITE COMMUTATIVITY-OF-+))
 (80 20 (:DEFINITION INTEGER-ABS))
 (55 55 (:REWRITE LEN-WHEN-NOT-CONSP-CHEAP))
 (55 38 (:REWRITE DEFAULT-<-2))
 (42 21 (:REWRITE CONSP-OF-CAR-WHEN-SYMBOL-TERM-ALISTP-CHEAP))
 (40 10 (:DEFINITION LENGTH))
 (39 38 (:REWRITE DEFAULT-<-1))
 (35 35 (:REWRITE CONSP-WHEN-LEN-EQUAL-CONSTANT))
 (33 33 (:REWRITE CONSP-WHEN-LEN-GREATER))
 (24 24 (:REWRITE FOLD-CONSTS-IN-+))
 (21 21 (:TYPE-PRESCRIPTION SYMBOL-TERM-ALISTP))
 (20 20 (:REWRITE DEFAULT-UNARY-MINUS))
 (15 9 (:LINEAR LEN-POSITIVE-WHEN-CONSP-LINEAR-CHEAP))
 (11 11 (:REWRITE CONSP-OF-CDR-WHEN-LEN-KNOWN))
 (10 10 (:REWRITE DEFAULT-REALPART))
 (10 10 (:REWRITE DEFAULT-NUMERATOR))
 (10 10 (:REWRITE DEFAULT-IMAGPART))
 (10 10 (:REWRITE DEFAULT-DENOMINATOR))
 (10 10 (:REWRITE DEFAULT-COERCE-2))
 (10 10 (:REWRITE DEFAULT-COERCE-1))
 (5 5 (:REWRITE LEN-OF-CDDR-WHEN-EQUAL-OF-LEN))
 )
(FIND-AN-IF-TO-LIFT)
(NATP-OF-FIND-AN-IF-TO-LIFT
 (277 28 (:REWRITE CONSP-FROM-LEN-CHEAP))
 (69 41 (:REWRITE DEFAULT-<-2))
 (41 41 (:REWRITE DEFAULT-<-1))
 (39 39 (:REWRITE DEFAULT-CAR))
 (31 31 (:REWRITE LEN-WHEN-NOT-CONSP-CHEAP))
 (30 15 (:REWRITE CONSP-OF-CAR-WHEN-SYMBOL-TERM-ALISTP-CHEAP))
 (28 28 (:REWRITE CONSP-WHEN-LEN-GREATER))
 (28 28 (:REWRITE CONSP-WHEN-LEN-EQUAL-CONSTANT))
 (22 22 (:REWRITE DEFAULT-+-2))
 (22 22 (:REWRITE DEFAULT-+-1))
 (20 20 (:REWRITE DEFAULT-CDR))
 (15 15 (:TYPE-PRESCRIPTION SYMBOL-TERM-ALISTP))
 )
(FIND-AN-IF-TO-LIFT-TYPE
 (60 6 (:REWRITE CONSP-FROM-LEN-CHEAP))
 (30 30 (:TYPE-PRESCRIPTION LEN))
 (13 7 (:REWRITE DEFAULT-<-2))
 (7 7 (:REWRITE DEFAULT-<-1))
 (6 6 (:REWRITE LEN-WHEN-NOT-CONSP-CHEAP))
 (6 6 (:REWRITE DEFAULT-CDR))
 (6 6 (:REWRITE DEFAULT-CAR))
 (6 6 (:REWRITE DEFAULT-+-2))
 (6 6 (:REWRITE DEFAULT-+-1))
 (6 6 (:REWRITE CONSP-WHEN-LEN-GREATER))
 (6 6 (:REWRITE CONSP-WHEN-LEN-EQUAL-CONSTANT))
 (6 6 (:LINEAR LEN-POSITIVE-WHEN-CONSP-LINEAR-CHEAP))
 (6 3 (:REWRITE CONSP-OF-CAR-WHEN-SYMBOL-TERM-ALISTP-CHEAP))
 (3 3 (:TYPE-PRESCRIPTION SYMBOL-TERM-ALISTP))
 )
(FIND-AN-IF-TO-LIFT-BOUND-HELPER
 (176 18 (:REWRITE CONSP-FROM-LEN-CHEAP))
 (50 30 (:REWRITE DEFAULT-<-2))
 (44 30 (:REWRITE DEFAULT-<-1))
 (31 31 (:REWRITE LEN-WHEN-NOT-CONSP-CHEAP))
 (30 30 (:REWRITE DEFAULT-CAR))
 (27 25 (:REWRITE DEFAULT-+-2))
 (25 25 (:REWRITE DEFAULT-+-1))
 (20 10 (:REWRITE CONSP-OF-CAR-WHEN-SYMBOL-TERM-ALISTP-CHEAP))
 (18 18 (:REWRITE CONSP-WHEN-LEN-GREATER))
 (18 18 (:REWRITE CONSP-WHEN-LEN-EQUAL-CONSTANT))
 (10 10 (:TYPE-PRESCRIPTION SYMBOL-TERM-ALISTP))
 (10 10 (:REWRITE DEFAULT-CDR))
 (8 2 (:REWRITE RATIONALP-IMPLIES-ACL2-NUMBERP))
 )
(FIND-AN-IF-TO-LIFT-BOUND-2
 (176 18 (:REWRITE CONSP-FROM-LEN-CHEAP))
 (48 30 (:REWRITE DEFAULT-<-2))
 (44 30 (:REWRITE DEFAULT-<-1))
 (30 30 (:REWRITE DEFAULT-CAR))
 (22 22 (:REWRITE LEN-WHEN-NOT-CONSP-CHEAP))
 (20 10 (:REWRITE CONSP-OF-CAR-WHEN-SYMBOL-TERM-ALISTP-CHEAP))
 (18 18 (:REWRITE CONSP-WHEN-LEN-GREATER))
 (18 18 (:REWRITE CONSP-WHEN-LEN-EQUAL-CONSTANT))
 (10 10 (:TYPE-PRESCRIPTION SYMBOL-TERM-ALISTP))
 (10 10 (:REWRITE DEFAULT-+-2))
 (10 10 (:REWRITE DEFAULT-+-1))
 (8 8 (:REWRITE DEFAULT-CDR))
 (8 2 (:REWRITE RATIONALP-IMPLIES-ACL2-NUMBERP))
 )
(FIND-AN-IF-TO-LIFT-BOUND
 (60 6 (:REWRITE CONSP-FROM-LEN-CHEAP))
 (32 1 (:LINEAR FIND-AN-IF-TO-LIFT-BOUND-2))
 (14 7 (:REWRITE DEFAULT-<-2))
 (7 7 (:REWRITE LEN-WHEN-NOT-CONSP-CHEAP))
 (7 7 (:REWRITE DEFAULT-<-1))
 (6 6 (:REWRITE DEFAULT-CDR))
 (6 6 (:REWRITE DEFAULT-CAR))
 (6 6 (:REWRITE CONSP-WHEN-LEN-GREATER))
 (6 6 (:REWRITE CONSP-WHEN-LEN-EQUAL-CONSTANT))
 (6 6 (:LINEAR LEN-POSITIVE-WHEN-CONSP-LINEAR-CHEAP))
 (6 3 (:REWRITE CONSP-OF-CAR-WHEN-SYMBOL-TERM-ALISTP-CHEAP))
 (3 3 (:TYPE-PRESCRIPTION SYMBOL-TERM-ALISTP))
 )
(<-OF-ACL2-COUNT-OF-UPDATE-NTH
 (2561 1248 (:REWRITE DEFAULT-+-2))
 (1740 1248 (:REWRITE DEFAULT-+-1))
 (804 32 (:LINEAR ACL2-COUNT-CAR-CDR-LINEAR))
 (630 439 (:REWRITE DEFAULT-<-2))
 (524 439 (:REWRITE DEFAULT-<-1))
 (512 7 (:REWRITE ACL2-COUNT-CAR-CHAINING))
 (444 444 (:REWRITE FOLD-CONSTS-IN-+))
 (287 180 (:REWRITE DEFAULT-CAR))
 (276 162 (:REWRITE DEFAULT-CDR))
 (220 220 (:REWRITE DEFAULT-UNARY-MINUS))
 (194 194 (:REWRITE CONSP-WHEN-LEN-EQUAL-CONSTANT))
 (143 3 (:REWRITE ACL2-COUNT-CDR-CHAINING))
 (120 69 (:TYPE-PRESCRIPTION TRUE-LISTP-UPDATE-NTH))
 (112 112 (:REWRITE DEFAULT-REALPART))
 (112 112 (:REWRITE DEFAULT-IMAGPART))
 (110 110 (:REWRITE DEFAULT-NUMERATOR))
 (110 110 (:REWRITE DEFAULT-DENOMINATOR))
 (110 110 (:REWRITE DEFAULT-COERCE-2))
 (110 110 (:REWRITE DEFAULT-COERCE-1))
 (110 110 (:REWRITE CONSP-WHEN-LEN-GREATER))
 (69 69 (:TYPE-PRESCRIPTION UPDATE-NTH))
 (51 51 (:TYPE-PRESCRIPTION TRUE-LISTP))
 (30 3 (:LINEAR LEN-OF-CDR-LINEAR-STRONG))
 (27 27 (:REWRITE ZP-OPEN))
 (24 3 (:LINEAR LEN-OF-CDR-LINEAR))
 (16 8 (:REWRITE CONSP-OF-CAR-WHEN-SYMBOL-TERM-ALISTP-CHEAP))
 (8 8 (:TYPE-PRESCRIPTION SYMBOL-TERM-ALISTP))
 (1 1 (:REWRITE CONSP-OF-CDR-WHEN-LEN-KNOWN))
 )
(CONSP-OF-NTH-OF-FIND-AN-IF-TO-LIFT-HELPER
 (394 40 (:REWRITE CONSP-FROM-LEN-CHEAP))
 (93 57 (:REWRITE DEFAULT-<-2))
 (75 57 (:REWRITE DEFAULT-+-2))
 (57 57 (:REWRITE DEFAULT-<-1))
 (57 57 (:REWRITE DEFAULT-+-1))
 (53 53 (:REWRITE LEN-WHEN-NOT-CONSP-CHEAP))
 (50 50 (:REWRITE DEFAULT-CAR))
 (40 40 (:REWRITE CONSP-WHEN-LEN-GREATER))
 (40 40 (:REWRITE CONSP-WHEN-LEN-EQUAL-CONSTANT))
 (39 21 (:REWRITE FOLD-CONSTS-IN-+))
 (30 6 (:REWRITE LEN-OF-CDR))
 (29 29 (:REWRITE DEFAULT-CDR))
 (28 14 (:REWRITE CONSP-OF-CAR-WHEN-SYMBOL-TERM-ALISTP-CHEAP))
 (14 14 (:TYPE-PRESCRIPTION SYMBOL-TERM-ALISTP))
 (12 12 (:REWRITE DEFAULT-UNARY-MINUS))
 (8 2 (:REWRITE RATIONALP-IMPLIES-ACL2-NUMBERP))
 (6 6 (:REWRITE CONSP-OF-CDR-WHEN-LEN-KNOWN))
 )
(CONSP-OF-NTH-OF-FIND-AN-IF-TO-LIFT
 (50 5 (:REWRITE CONSP-FROM-LEN-CHEAP))
 (25 25 (:TYPE-PRESCRIPTION LEN))
 (21 1 (:DEFINITION NTH))
 (11 6 (:REWRITE DEFAULT-<-2))
 (6 6 (:REWRITE DEFAULT-<-1))
 (5 5 (:REWRITE LEN-WHEN-NOT-CONSP-CHEAP))
 (5 5 (:REWRITE DEFAULT-CDR))
 (5 5 (:REWRITE DEFAULT-CAR))
 (5 5 (:REWRITE CONSP-WHEN-LEN-GREATER))
 (5 5 (:REWRITE CONSP-WHEN-LEN-EQUAL-CONSTANT))
 (5 5 (:LINEAR LEN-POSITIVE-WHEN-CONSP-LINEAR-CHEAP))
 (4 2 (:REWRITE CONSP-OF-CAR-WHEN-SYMBOL-TERM-ALISTP-CHEAP))
 (4 1 (:REWRITE ZP-OPEN))
 (3 3 (:REWRITE DEFAULT-+-2))
 (3 3 (:REWRITE DEFAULT-+-1))
 (2 2 (:TYPE-PRESCRIPTION SYMBOL-TERM-ALISTP))
 )
(LIFT-IFS-IN-ARGS
 (914 41 (:REWRITE CONSP-FROM-LEN-CHEAP))
 (465 45 (:REWRITE LEN-OF-CDR))
 (328 28 (:REWRITE DEFAULT-CAR))
 (302 36 (:REWRITE DEFAULT-CDR))
 (248 8 (:DEFINITION FIND-AN-IF-TO-LIFT))
 (166 100 (:REWRITE LEN-WHEN-NOT-CONSP-CHEAP))
 (115 67 (:REWRITE DEFAULT-+-2))
 (85 41 (:REWRITE DEFAULT-<-2))
 (84 4 (:DEFINITION NTH))
 (74 32 (:LINEAR LEN-POSITIVE-WHEN-CONSP-LINEAR-CHEAP))
 (74 2 (:DEFINITION UPDATE-NTH))
 (69 67 (:REWRITE DEFAULT-+-1))
 (64 2 (:LINEAR FIND-AN-IF-TO-LIFT-BOUND-2))
 (60 30 (:REWRITE EQUAL-OF-LEN-AND-0))
 (50 14 (:REWRITE FOLD-CONSTS-IN-+))
 (41 41 (:REWRITE DEFAULT-<-1))
 (41 41 (:REWRITE CONSP-WHEN-LEN-EQUAL-CONSTANT))
 (35 35 (:REWRITE CONSP-WHEN-LEN-GREATER))
 (24 6 (:REWRITE ZP-OPEN))
 (16 8 (:REWRITE CONSP-OF-CAR-WHEN-SYMBOL-TERM-ALISTP-CHEAP))
 (15 15 (:REWRITE LEN-OF-CDDR-WHEN-EQUAL-OF-LEN))
 (15 15 (:REWRITE CONSP-OF-CDR-WHEN-LEN-KNOWN))
 (8 8 (:TYPE-PRESCRIPTION SYMBOL-TERM-ALISTP))
 (4 2 (:TYPE-PRESCRIPTION TRUE-LISTP-UPDATE-NTH))
 (2 2 (:TYPE-PRESCRIPTION TRUE-LISTP))
 )
(LIFT-IFS
 (588 52 (:REWRITE CONSP-FROM-LEN-CHEAP))
 (204 70 (:REWRITE DEFAULT-CAR))
 (148 54 (:REWRITE DEFAULT-CDR))
 (101 101 (:REWRITE LEN-WHEN-NOT-CONSP-CHEAP))
 (68 4 (:DEFINITION SYMBOL-LISTP))
 (62 30 (:REWRITE DEFAULT-<-2))
 (61 32 (:REWRITE DEFAULT-+-2))
 (52 52 (:REWRITE CONSP-WHEN-LEN-EQUAL-CONSTANT))
 (42 24 (:LINEAR LEN-POSITIVE-WHEN-CONSP-LINEAR-CHEAP))
 (40 20 (:REWRITE CONSP-OF-CAR-WHEN-SYMBOL-TERM-ALISTP-CHEAP))
 (38 38 (:REWRITE CONSP-WHEN-LEN-GREATER))
 (34 32 (:REWRITE DEFAULT-+-1))
 (32 30 (:REWRITE DEFAULT-<-1))
 (20 20 (:TYPE-PRESCRIPTION SYMBOL-TERM-ALISTP))
 (12 12 (:REWRITE CONSP-OF-CDR-WHEN-LEN-KNOWN))
 (10 4 (:REWRITE FOLD-CONSTS-IN-+))
 (9 9 (:REWRITE LEN-OF-CDDR-WHEN-EQUAL-OF-LEN))
 (8 8 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (8 8 (:REWRITE DEFAULT-COERCE-2))
 (8 8 (:REWRITE DEFAULT-COERCE-1))
 (8 4 (:REWRITE PSEUDO-TERMP-OF-LAMBDA-BODY-CHEAP))
 (4 4 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (1 1 (:TYPE-PRESCRIPTION LIFT-IFS))
 )
(EXPAND-FUNCTION-CALL-K-TIMES)
(FUNCTION-CALL-APPEARS)
(EXTRACT-CASES-FOR-NON-RECURSIVE-BRANCHES
 (330 17 (:REWRITE CONSP-FROM-LEN-CHEAP))
 (237 45 (:REWRITE LEN-OF-CDR))
 (146 8 (:REWRITE DEFAULT-CAR))
 (112 12 (:REWRITE DEFAULT-CDR))
 (66 66 (:REWRITE LEN-WHEN-NOT-CONSP-CHEAP))
 (65 61 (:REWRITE DEFAULT-+-2))
 (61 61 (:REWRITE DEFAULT-+-1))
 (36 12 (:REWRITE FOLD-CONSTS-IN-+))
 (23 19 (:REWRITE DEFAULT-<-2))
 (21 19 (:REWRITE DEFAULT-<-1))
 (17 17 (:REWRITE CONSP-WHEN-LEN-GREATER))
 (17 17 (:REWRITE CONSP-WHEN-LEN-EQUAL-CONSTANT))
 (15 15 (:REWRITE LEN-OF-CDDR-WHEN-EQUAL-OF-LEN))
 (15 15 (:REWRITE CONSP-OF-CDR-WHEN-LEN-KNOWN))
 (1 1 (:TYPE-PRESCRIPTION TRUE-LISTP))
 )
(GENERATE-THEOREMS-FOR-CASES)
(GENERATE-LEMMAS-FOR-NON-RECURSIVE-BRANCHES)
(UNROLL-EVENTS)
(UNROLLER-LEMMA-NAME)
