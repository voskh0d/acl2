(GATHER-ARGS
 (199 92 (:REWRITE DEFAULT-+-2))
 (132 14 (:REWRITE PSEUDO-TERM-LISTP-WHEN-SYMBOL-LISTP))
 (129 92 (:REWRITE DEFAULT-+-1))
 (113 4 (:REWRITE PSEUDO-TERM-LISTP-OF-CDR-WHEN-PSEUDO-TERM-LISTP))
 (96 17 (:DEFINITION SYMBOL-LISTP))
 (73 73 (:REWRITE DEFAULT-CAR))
 (72 18 (:DEFINITION INTEGER-ABS))
 (72 9 (:DEFINITION LENGTH))
 (64 64 (:TYPE-PRESCRIPTION SYMBOL-LISTP))
 (45 9 (:DEFINITION LEN))
 (39 3 (:REWRITE ACL2-COUNT-WHEN-MEMBER))
 (32 4 (:DEFINITION MEMBER-EQUAL))
 (31 23 (:REWRITE DEFAULT-<-2))
 (28 4 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (27 23 (:REWRITE DEFAULT-<-1))
 (20 20 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (18 18 (:REWRITE DEFAULT-UNARY-MINUS))
 (18 1 (:DEFINITION GATHER-ARGS))
 (14 2 (:REWRITE PSEUDO-TERMP-WHEN-MEMBER-EQUAL-OF-PSEUDO-TERM-LISTP))
 (13 13 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (13 13 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (13 13 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (13 13 (:REWRITE SUBSETP-TRANS2))
 (13 13 (:REWRITE SUBSETP-TRANS))
 (13 13 (:REWRITE PSEUDO-TERM-LISTP-WHEN-NOT-CONSP))
 (12 12 (:LINEAR ACL2-COUNT-WHEN-MEMBER))
 (9 9 (:TYPE-PRESCRIPTION LEN))
 (9 9 (:REWRITE DEFAULT-REALPART))
 (9 9 (:REWRITE DEFAULT-NUMERATOR))
 (9 9 (:REWRITE DEFAULT-IMAGPART))
 (9 9 (:REWRITE DEFAULT-DENOMINATOR))
 (9 9 (:REWRITE DEFAULT-COERCE-2))
 (9 9 (:REWRITE DEFAULT-COERCE-1))
 (8 8 (:REWRITE SUBSETP-MEMBER . 2))
 (8 8 (:REWRITE SUBSETP-MEMBER . 1))
 (6 3 (:REWRITE APPEND-WHEN-NOT-CONSP))
 (6 1 (:DEFINITION BINARY-APPEND))
 (3 3 (:LINEAR ACL2-COUNT-CAR-CDR-LINEAR))
 (2 1 (:REWRITE APPEND-OF-CONS))
 (1 1 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 )
(PSEUDO-TERM-LISTP-OF-GATHER-ARGS
 (785 61 (:REWRITE PSEUDO-TERM-LISTP-WHEN-SYMBOL-LISTP))
 (623 74 (:DEFINITION SYMBOL-LISTP))
 (308 308 (:TYPE-PRESCRIPTION SYMBOL-LISTP))
 (265 258 (:REWRITE DEFAULT-CAR))
 (222 6 (:REWRITE PSEUDO-TERM-LISTP-OF-CDR-WHEN-PSEUDO-TERM-LISTP))
 (204 115 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (201 115 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (184 7 (:REWRITE SUBSETP-OF-CONS))
 (178 140 (:REWRITE SUBSETP-TRANS2))
 (172 28 (:DEFINITION BINARY-APPEND))
 (140 140 (:REWRITE SUBSETP-TRANS))
 (116 5 (:REWRITE SUBSETP-APPEND1))
 (87 11 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (86 6 (:DEFINITION MEMBER-EQUAL))
 (47 47 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (16 4 (:REWRITE APPEND-ATOM-UNDER-LIST-EQUIV))
 (12 12 (:REWRITE SUBSETP-MEMBER . 2))
 (12 12 (:REWRITE SUBSETP-MEMBER . 1))
 (12 4 (:REWRITE CONSP-OF-APPEND))
 (12 2 (:REWRITE CAR-OF-APPEND))
 (7 2 (:REWRITE CDR-OF-APPEND-WHEN-CONSP))
 (1 1 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 )
(RECONSTRUCT-OR-IN-TERM
 (613 263 (:REWRITE DEFAULT-+-2))
 (369 263 (:REWRITE DEFAULT-+-1))
 (247 5 (:LINEAR ACL2-COUNT-CAR-CDR-LINEAR))
 (192 48 (:DEFINITION INTEGER-ABS))
 (192 24 (:DEFINITION LENGTH))
 (175 4 (:REWRITE ACL2-COUNT-WHEN-MEMBER))
 (126 6 (:REWRITE SUBSETP-CAR-MEMBER))
 (120 24 (:DEFINITION LEN))
 (93 4 (:DEFINITION MEMBER-EQUAL))
 (84 12 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (74 56 (:REWRITE DEFAULT-<-2))
 (62 56 (:REWRITE DEFAULT-<-1))
 (48 48 (:REWRITE DEFAULT-UNARY-MINUS))
 (36 36 (:TYPE-PRESCRIPTION SUBSETP-EQUAL))
 (24 24 (:TYPE-PRESCRIPTION LEN))
 (24 24 (:REWRITE DEFAULT-REALPART))
 (24 24 (:REWRITE DEFAULT-NUMERATOR))
 (24 24 (:REWRITE DEFAULT-IMAGPART))
 (24 24 (:REWRITE DEFAULT-DENOMINATOR))
 (24 24 (:REWRITE DEFAULT-COERCE-2))
 (24 24 (:REWRITE DEFAULT-COERCE-1))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (18 18 (:REWRITE SUBSETP-TRANS2))
 (18 18 (:REWRITE SUBSETP-TRANS))
 (18 18 (:LINEAR ACL2-COUNT-WHEN-MEMBER))
 (16 16 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (8 8 (:REWRITE SUBSETP-MEMBER . 2))
 (8 8 (:REWRITE SUBSETP-MEMBER . 1))
 (1 1 (:TYPE-PRESCRIPTION RECONSTRUCT-OR-IN-TERM))
 (1 1 (:REWRITE MEMBER-SELF))
 )
(FLAG-RECONSTRUCT-OR-IN-TERM
 (697 303 (:REWRITE DEFAULT-+-2))
 (425 303 (:REWRITE DEFAULT-+-1))
 (224 56 (:DEFINITION INTEGER-ABS))
 (224 28 (:DEFINITION LENGTH))
 (140 28 (:DEFINITION LEN))
 (99 5 (:DEFINITION MEMBER-EQUAL))
 (84 65 (:REWRITE DEFAULT-<-2))
 (84 12 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (72 65 (:REWRITE DEFAULT-<-1))
 (56 56 (:REWRITE DEFAULT-UNARY-MINUS))
 (28 28 (:TYPE-PRESCRIPTION LEN))
 (28 28 (:REWRITE DEFAULT-REALPART))
 (28 28 (:REWRITE DEFAULT-NUMERATOR))
 (28 28 (:REWRITE DEFAULT-IMAGPART))
 (28 28 (:REWRITE DEFAULT-DENOMINATOR))
 (28 28 (:REWRITE DEFAULT-COERCE-2))
 (28 28 (:REWRITE DEFAULT-COERCE-1))
 (20 20 (:LINEAR ACL2-COUNT-WHEN-MEMBER))
 (19 19 (:REWRITE SUBSETP-TRANS2))
 (19 19 (:REWRITE SUBSETP-TRANS))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (16 2 (:TYPE-PRESCRIPTION RETURN-LAST))
 (10 10 (:REWRITE SUBSETP-MEMBER . 2))
 (10 10 (:REWRITE SUBSETP-MEMBER . 1))
 (2 2 (:TYPE-PRESCRIPTION THROW-NONEXEC-ERROR))
 (2 2 (:REWRITE MEMBER-SELF))
 )
(FLAG::FLAG-EQUIV-LEMMA)
(FLAG-RECONSTRUCT-OR-IN-TERM-EQUIVALENCES)
(FLAG-LEMMA-FOR-PSEUDO-TERMP-RECONSTRUCT-OR-IN-TERM
 (2162 59 (:REWRITE PSEUDO-TERM-LISTP-OF-CDR-WHEN-PSEUDO-TERM-LISTP))
 (1495 122 (:REWRITE PSEUDO-TERM-LISTP-WHEN-SYMBOL-LISTP))
 (1436 62 (:DEFINITION MEMBER-EQUAL))
 (1217 878 (:REWRITE DEFAULT-CAR))
 (1154 903 (:REWRITE DEFAULT-CDR))
 (451 12 (:REWRITE SUBSETP-OF-CONS))
 (309 309 (:REWRITE SUBSETP-TRANS2))
 (309 309 (:REWRITE SUBSETP-TRANS))
 (304 282 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (285 276 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (176 28 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (148 74 (:REWRITE DEFAULT-+-2))
 (123 123 (:REWRITE SUBSETP-MEMBER . 2))
 (123 123 (:REWRITE SUBSETP-MEMBER . 1))
 (112 112 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (74 74 (:REWRITE DEFAULT-+-1))
 (56 56 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (56 28 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (39 39 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (28 28 (:TYPE-PRESCRIPTION SET::EMPTY-TYPE))
 (28 28 (:REWRITE SET::IN-SET))
 (10 10 (:REWRITE DEFAULT-COERCE-2))
 (10 10 (:REWRITE DEFAULT-COERCE-1))
 (6 6 (:REWRITE SUBSETP-NIL))
 (2 2 (:DEFINITION ATOM))
 )
(PSEUDO-TERMP-RECONSTRUCT-OR-IN-TERM)
(PSEUDO-TERM-LISTP-RECONSTRUCT-OR-IN-TERMS)
(RECONSTRUCT-OR-IN-TERM
 (371 32 (:REWRITE PSEUDO-TERM-LISTP-WHEN-SYMBOL-LISTP))
 (363 20 (:REWRITE SUBSETP-CAR-MEMBER))
 (362 22 (:REWRITE PSEUDO-TERMP-WHEN-MEMBER-EQUAL-OF-PSEUDO-TERM-LISTP))
 (305 10 (:DEFINITION MEMBER-EQUAL))
 (293 41 (:DEFINITION SYMBOL-LISTP))
 (239 41 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (214 163 (:REWRITE DEFAULT-CDR))
 (188 149 (:REWRITE DEFAULT-CAR))
 (166 3 (:REWRITE SUBSETP-OF-CONS))
 (110 65 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (84 14 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (70 70 (:REWRITE SUBSETP-TRANS2))
 (70 70 (:REWRITE SUBSETP-TRANS))
 (65 65 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (52 52 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (37 31 (:REWRITE PSEUDO-TERM-LISTP-WHEN-NOT-CONSP))
 (28 28 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (28 14 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (27 27 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (26 13 (:REWRITE DEFAULT-+-2))
 (20 20 (:REWRITE SUBSETP-MEMBER . 2))
 (20 20 (:REWRITE SUBSETP-MEMBER . 1))
 (15 5 (:DEFINITION RECONSTRUCT-OR-IN-TERMS))
 (14 14 (:TYPE-PRESCRIPTION SET::EMPTY-TYPE))
 (14 14 (:REWRITE SET::IN-SET))
 (13 13 (:REWRITE DEFAULT-+-1))
 (9 9 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (3 3 (:REWRITE CDR-CONS))
 (3 3 (:REWRITE CAR-CONS))
 (2 2 (:REWRITE SUBSETP-NIL))
 (2 2 (:REWRITE DEFAULT-COERCE-2))
 (2 2 (:REWRITE DEFAULT-COERCE-1))
 )
(RECONSTRUCT-AND-IN-TERM
 (613 263 (:REWRITE DEFAULT-+-2))
 (369 263 (:REWRITE DEFAULT-+-1))
 (247 5 (:LINEAR ACL2-COUNT-CAR-CDR-LINEAR))
 (192 48 (:DEFINITION INTEGER-ABS))
 (192 24 (:DEFINITION LENGTH))
 (175 4 (:REWRITE ACL2-COUNT-WHEN-MEMBER))
 (126 6 (:REWRITE SUBSETP-CAR-MEMBER))
 (120 24 (:DEFINITION LEN))
 (93 4 (:DEFINITION MEMBER-EQUAL))
 (84 12 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (74 56 (:REWRITE DEFAULT-<-2))
 (62 56 (:REWRITE DEFAULT-<-1))
 (48 48 (:REWRITE DEFAULT-UNARY-MINUS))
 (36 36 (:TYPE-PRESCRIPTION SUBSETP-EQUAL))
 (24 24 (:TYPE-PRESCRIPTION LEN))
 (24 24 (:REWRITE DEFAULT-REALPART))
 (24 24 (:REWRITE DEFAULT-NUMERATOR))
 (24 24 (:REWRITE DEFAULT-IMAGPART))
 (24 24 (:REWRITE DEFAULT-DENOMINATOR))
 (24 24 (:REWRITE DEFAULT-COERCE-2))
 (24 24 (:REWRITE DEFAULT-COERCE-1))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (18 18 (:REWRITE SUBSETP-TRANS2))
 (18 18 (:REWRITE SUBSETP-TRANS))
 (18 18 (:LINEAR ACL2-COUNT-WHEN-MEMBER))
 (16 16 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (8 8 (:REWRITE SUBSETP-MEMBER . 2))
 (8 8 (:REWRITE SUBSETP-MEMBER . 1))
 (1 1 (:TYPE-PRESCRIPTION RECONSTRUCT-AND-IN-TERM))
 (1 1 (:REWRITE MEMBER-SELF))
 )
(FLAG-RECONSTRUCT-AND-IN-TERM
 (697 303 (:REWRITE DEFAULT-+-2))
 (425 303 (:REWRITE DEFAULT-+-1))
 (224 56 (:DEFINITION INTEGER-ABS))
 (224 28 (:DEFINITION LENGTH))
 (140 28 (:DEFINITION LEN))
 (99 5 (:DEFINITION MEMBER-EQUAL))
 (84 65 (:REWRITE DEFAULT-<-2))
 (84 12 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (72 65 (:REWRITE DEFAULT-<-1))
 (56 56 (:REWRITE DEFAULT-UNARY-MINUS))
 (28 28 (:TYPE-PRESCRIPTION LEN))
 (28 28 (:REWRITE DEFAULT-REALPART))
 (28 28 (:REWRITE DEFAULT-NUMERATOR))
 (28 28 (:REWRITE DEFAULT-IMAGPART))
 (28 28 (:REWRITE DEFAULT-DENOMINATOR))
 (28 28 (:REWRITE DEFAULT-COERCE-2))
 (28 28 (:REWRITE DEFAULT-COERCE-1))
 (20 20 (:LINEAR ACL2-COUNT-WHEN-MEMBER))
 (19 19 (:REWRITE SUBSETP-TRANS2))
 (19 19 (:REWRITE SUBSETP-TRANS))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (18 2 (:TYPE-PRESCRIPTION RETURN-LAST))
 (10 10 (:REWRITE SUBSETP-MEMBER . 2))
 (10 10 (:REWRITE SUBSETP-MEMBER . 1))
 (2 2 (:TYPE-PRESCRIPTION THROW-NONEXEC-ERROR))
 (2 2 (:REWRITE MEMBER-SELF))
 )
(FLAG::FLAG-EQUIV-LEMMA)
(FLAG-RECONSTRUCT-AND-IN-TERM-EQUIVALENCES)
(FLAG-LEMMA-FOR-PSEUDO-TERMP-RECONSTRUCT-AND-IN-TERM
 (2596 67 (:REWRITE PSEUDO-TERM-LISTP-OF-CDR-WHEN-PSEUDO-TERM-LISTP))
 (1797 12 (:REWRITE PSEUDO-TERMP-OF-CAR-WHEN-PSEUDO-TERM-LISTP))
 (1757 137 (:REWRITE PSEUDO-TERM-LISTP-WHEN-SYMBOL-LISTP))
 (1694 74 (:DEFINITION MEMBER-EQUAL))
 (1673 1159 (:REWRITE DEFAULT-CDR))
 (1542 1037 (:REWRITE DEFAULT-CAR))
 (841 154 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (324 324 (:REWRITE SUBSETP-TRANS2))
 (324 324 (:REWRITE SUBSETP-TRANS))
 (309 287 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (290 281 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (176 28 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (170 85 (:REWRITE DEFAULT-+-2))
 (143 143 (:REWRITE SUBSETP-MEMBER . 2))
 (143 143 (:REWRITE SUBSETP-MEMBER . 1))
 (127 127 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (85 85 (:REWRITE DEFAULT-+-1))
 (56 56 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (56 28 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (44 44 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (28 28 (:TYPE-PRESCRIPTION SET::EMPTY-TYPE))
 (28 28 (:REWRITE SET::IN-SET))
 (10 10 (:REWRITE DEFAULT-COERCE-2))
 (10 10 (:REWRITE DEFAULT-COERCE-1))
 (2 2 (:DEFINITION ATOM))
 )
(PSEUDO-TERMP-RECONSTRUCT-AND-IN-TERM)
(PSEUDO-TERM-LISTP-RECONSTRUCT-AND-IN-TERMS)
(RECONSTRUCT-AND-IN-TERM
 (353 31 (:REWRITE PSEUDO-TERM-LISTP-WHEN-SYMBOL-LISTP))
 (352 22 (:REWRITE PSEUDO-TERMP-WHEN-MEMBER-EQUAL-OF-PSEUDO-TERM-LISTP))
 (342 192 (:REWRITE DEFAULT-CDR))
 (323 20 (:REWRITE SUBSETP-CAR-MEMBER))
 (278 40 (:DEFINITION SYMBOL-LISTP))
 (275 10 (:DEFINITION MEMBER-EQUAL))
 (202 151 (:REWRITE DEFAULT-CAR))
 (198 36 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (136 3 (:REWRITE SUBSETP-OF-CONS))
 (93 60 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (84 14 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (65 65 (:REWRITE SUBSETP-TRANS2))
 (65 65 (:REWRITE SUBSETP-TRANS))
 (60 60 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (52 52 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (33 30 (:REWRITE PSEUDO-TERM-LISTP-WHEN-NOT-CONSP))
 (28 28 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (28 14 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (27 27 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (26 13 (:REWRITE DEFAULT-+-2))
 (20 20 (:REWRITE SUBSETP-MEMBER . 2))
 (20 20 (:REWRITE SUBSETP-MEMBER . 1))
 (14 14 (:TYPE-PRESCRIPTION SET::EMPTY-TYPE))
 (14 14 (:REWRITE SET::IN-SET))
 (13 13 (:REWRITE DEFAULT-+-1))
 (12 4 (:DEFINITION RECONSTRUCT-AND-IN-TERMS))
 (9 9 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (3 3 (:REWRITE CDR-CONS))
 (3 3 (:REWRITE CAR-CONS))
 (2 2 (:REWRITE SUBSETP-NIL))
 (2 2 (:REWRITE DEFAULT-COERCE-2))
 (2 2 (:REWRITE DEFAULT-COERCE-1))
 )
(RECONSTRUCT-+-IN-TERM
 (650 281 (:REWRITE DEFAULT-+-2))
 (394 281 (:REWRITE DEFAULT-+-1))
 (248 6 (:LINEAR ACL2-COUNT-CAR-CDR-LINEAR))
 (208 52 (:DEFINITION INTEGER-ABS))
 (208 26 (:DEFINITION LENGTH))
 (175 4 (:REWRITE ACL2-COUNT-WHEN-MEMBER))
 (130 26 (:DEFINITION LEN))
 (126 6 (:REWRITE SUBSETP-CAR-MEMBER))
 (93 4 (:DEFINITION MEMBER-EQUAL))
 (84 12 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (81 61 (:REWRITE DEFAULT-<-2))
 (67 61 (:REWRITE DEFAULT-<-1))
 (52 52 (:REWRITE DEFAULT-UNARY-MINUS))
 (36 36 (:TYPE-PRESCRIPTION SUBSETP-EQUAL))
 (26 26 (:TYPE-PRESCRIPTION LEN))
 (26 26 (:REWRITE DEFAULT-REALPART))
 (26 26 (:REWRITE DEFAULT-NUMERATOR))
 (26 26 (:REWRITE DEFAULT-IMAGPART))
 (26 26 (:REWRITE DEFAULT-DENOMINATOR))
 (26 26 (:REWRITE DEFAULT-COERCE-2))
 (26 26 (:REWRITE DEFAULT-COERCE-1))
 (22 22 (:LINEAR ACL2-COUNT-WHEN-MEMBER))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (18 18 (:REWRITE SUBSETP-TRANS2))
 (18 18 (:REWRITE SUBSETP-TRANS))
 (16 16 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (8 8 (:REWRITE SUBSETP-MEMBER . 2))
 (8 8 (:REWRITE SUBSETP-MEMBER . 1))
 (1 1 (:TYPE-PRESCRIPTION RECONSTRUCT-+-IN-TERM))
 (1 1 (:REWRITE MEMBER-SELF))
 )
(FLAG-RECONSTRUCT-+-IN-TERM
 (734 321 (:REWRITE DEFAULT-+-2))
 (450 321 (:REWRITE DEFAULT-+-1))
 (240 60 (:DEFINITION INTEGER-ABS))
 (240 30 (:DEFINITION LENGTH))
 (150 30 (:DEFINITION LEN))
 (99 5 (:DEFINITION MEMBER-EQUAL))
 (91 70 (:REWRITE DEFAULT-<-2))
 (84 12 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (77 70 (:REWRITE DEFAULT-<-1))
 (60 60 (:REWRITE DEFAULT-UNARY-MINUS))
 (30 30 (:TYPE-PRESCRIPTION LEN))
 (30 30 (:REWRITE DEFAULT-REALPART))
 (30 30 (:REWRITE DEFAULT-NUMERATOR))
 (30 30 (:REWRITE DEFAULT-IMAGPART))
 (30 30 (:REWRITE DEFAULT-DENOMINATOR))
 (30 30 (:REWRITE DEFAULT-COERCE-2))
 (30 30 (:REWRITE DEFAULT-COERCE-1))
 (24 24 (:LINEAR ACL2-COUNT-WHEN-MEMBER))
 (19 19 (:REWRITE SUBSETP-TRANS2))
 (19 19 (:REWRITE SUBSETP-TRANS))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (12 2 (:TYPE-PRESCRIPTION RETURN-LAST))
 (10 10 (:REWRITE SUBSETP-MEMBER . 2))
 (10 10 (:REWRITE SUBSETP-MEMBER . 1))
 (2 2 (:TYPE-PRESCRIPTION THROW-NONEXEC-ERROR))
 (2 2 (:REWRITE MEMBER-SELF))
 )
(FLAG::FLAG-EQUIV-LEMMA)
(FLAG-RECONSTRUCT-+-IN-TERM-EQUIVALENCES)
(FLAG-LEMMA-FOR-PSEUDO-TERMP-RECONSTRUCT-+-IN-TERM
 (1325 44 (:REWRITE PSEUDO-TERM-LISTP-OF-CDR-WHEN-PSEUDO-TERM-LISTP))
 (1026 90 (:REWRITE PSEUDO-TERM-LISTP-WHEN-SYMBOL-LISTP))
 (1026 9 (:REWRITE PSEUDO-TERMP-OF-CAR-WHEN-PSEUDO-TERM-LISTP))
 (803 39 (:DEFINITION MEMBER-EQUAL))
 (594 110 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (584 580 (:REWRITE DEFAULT-CAR))
 (209 192 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (199 199 (:REWRITE SUBSETP-TRANS2))
 (199 199 (:REWRITE SUBSETP-TRANS))
 (198 192 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (150 24 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (124 62 (:REWRITE DEFAULT-+-2))
 (84 84 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (82 2 (:REWRITE SUBSETP-OF-CONS))
 (78 78 (:REWRITE SUBSETP-MEMBER . 2))
 (78 78 (:REWRITE SUBSETP-MEMBER . 1))
 (62 62 (:REWRITE DEFAULT-+-1))
 (48 48 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (48 24 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (31 31 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (24 24 (:TYPE-PRESCRIPTION SET::EMPTY-TYPE))
 (24 24 (:REWRITE SET::IN-SET))
 (8 8 (:REWRITE DEFAULT-COERCE-2))
 (8 8 (:REWRITE DEFAULT-COERCE-1))
 )
(PSEUDO-TERMP-RECONSTRUCT-+-IN-TERM)
(PSEUDO-TERM-LISTP-RECONSTRUCT-+-IN-TERMS)
(RECONSTRUCT-+-IN-TERM
 (333 16 (:REWRITE PSEUDO-TERM-LISTP-OF-CDR-WHEN-PSEUDO-TERM-LISTP))
 (309 4 (:REWRITE PSEUDO-TERMP-OF-CAR-WHEN-PSEUDO-TERM-LISTP))
 (289 29 (:REWRITE PSEUDO-TERM-LISTP-WHEN-SYMBOL-LISTP))
 (220 36 (:DEFINITION SYMBOL-LISTP))
 (180 18 (:REWRITE PSEUDO-TERMP-WHEN-MEMBER-EQUAL-OF-PSEUDO-TERM-LISTP))
 (132 132 (:REWRITE DEFAULT-CDR))
 (126 6 (:REWRITE SUBSETP-CAR-MEMBER))
 (125 125 (:REWRITE DEFAULT-CAR))
 (90 18 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (87 3 (:DEFINITION MEMBER-EQUAL))
 (84 14 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (28 28 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (28 28 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (28 28 (:REWRITE PSEUDO-TERM-LISTP-WHEN-NOT-CONSP))
 (28 14 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (27 27 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (27 27 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (27 27 (:REWRITE SUBSETP-TRANS2))
 (27 27 (:REWRITE SUBSETP-TRANS))
 (26 13 (:REWRITE DEFAULT-+-2))
 (15 15 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (14 14 (:TYPE-PRESCRIPTION SET::EMPTY-TYPE))
 (14 14 (:REWRITE SET::IN-SET))
 (13 13 (:REWRITE DEFAULT-+-1))
 (10 1 (:DEFINITION RECONSTRUCT-+-IN-TERM))
 (9 9 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (6 6 (:REWRITE SUBSETP-MEMBER . 2))
 (6 6 (:REWRITE SUBSETP-MEMBER . 1))
 (3 1 (:DEFINITION RECONSTRUCT-+-IN-TERMS))
 (2 2 (:REWRITE DEFAULT-COERCE-2))
 (2 2 (:REWRITE DEFAULT-COERCE-1))
 )
(RECONSTRUCT-*-IN-TERM
 (650 281 (:REWRITE DEFAULT-+-2))
 (394 281 (:REWRITE DEFAULT-+-1))
 (248 6 (:LINEAR ACL2-COUNT-CAR-CDR-LINEAR))
 (208 52 (:DEFINITION INTEGER-ABS))
 (208 26 (:DEFINITION LENGTH))
 (175 4 (:REWRITE ACL2-COUNT-WHEN-MEMBER))
 (130 26 (:DEFINITION LEN))
 (126 6 (:REWRITE SUBSETP-CAR-MEMBER))
 (93 4 (:DEFINITION MEMBER-EQUAL))
 (84 12 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (81 61 (:REWRITE DEFAULT-<-2))
 (67 61 (:REWRITE DEFAULT-<-1))
 (52 52 (:REWRITE DEFAULT-UNARY-MINUS))
 (36 36 (:TYPE-PRESCRIPTION SUBSETP-EQUAL))
 (26 26 (:TYPE-PRESCRIPTION LEN))
 (26 26 (:REWRITE DEFAULT-REALPART))
 (26 26 (:REWRITE DEFAULT-NUMERATOR))
 (26 26 (:REWRITE DEFAULT-IMAGPART))
 (26 26 (:REWRITE DEFAULT-DENOMINATOR))
 (26 26 (:REWRITE DEFAULT-COERCE-2))
 (26 26 (:REWRITE DEFAULT-COERCE-1))
 (22 22 (:LINEAR ACL2-COUNT-WHEN-MEMBER))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (18 18 (:REWRITE SUBSETP-TRANS2))
 (18 18 (:REWRITE SUBSETP-TRANS))
 (16 16 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (8 8 (:REWRITE SUBSETP-MEMBER . 2))
 (8 8 (:REWRITE SUBSETP-MEMBER . 1))
 (1 1 (:TYPE-PRESCRIPTION RECONSTRUCT-*-IN-TERM))
 (1 1 (:REWRITE MEMBER-SELF))
 )
(FLAG-RECONSTRUCT-*-IN-TERM
 (734 321 (:REWRITE DEFAULT-+-2))
 (450 321 (:REWRITE DEFAULT-+-1))
 (240 60 (:DEFINITION INTEGER-ABS))
 (240 30 (:DEFINITION LENGTH))
 (150 30 (:DEFINITION LEN))
 (99 5 (:DEFINITION MEMBER-EQUAL))
 (91 70 (:REWRITE DEFAULT-<-2))
 (84 12 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (77 70 (:REWRITE DEFAULT-<-1))
 (60 60 (:REWRITE DEFAULT-UNARY-MINUS))
 (30 30 (:TYPE-PRESCRIPTION LEN))
 (30 30 (:REWRITE DEFAULT-REALPART))
 (30 30 (:REWRITE DEFAULT-NUMERATOR))
 (30 30 (:REWRITE DEFAULT-IMAGPART))
 (30 30 (:REWRITE DEFAULT-DENOMINATOR))
 (30 30 (:REWRITE DEFAULT-COERCE-2))
 (30 30 (:REWRITE DEFAULT-COERCE-1))
 (24 24 (:LINEAR ACL2-COUNT-WHEN-MEMBER))
 (19 19 (:REWRITE SUBSETP-TRANS2))
 (19 19 (:REWRITE SUBSETP-TRANS))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (12 2 (:TYPE-PRESCRIPTION RETURN-LAST))
 (10 10 (:REWRITE SUBSETP-MEMBER . 2))
 (10 10 (:REWRITE SUBSETP-MEMBER . 1))
 (2 2 (:TYPE-PRESCRIPTION THROW-NONEXEC-ERROR))
 (2 2 (:REWRITE MEMBER-SELF))
 )
(FLAG::FLAG-EQUIV-LEMMA)
(FLAG-RECONSTRUCT-*-IN-TERM-EQUIVALENCES)
(FLAG-LEMMA-FOR-PSEUDO-TERMP-RECONSTRUCT-*-IN-TERM
 (1325 44 (:REWRITE PSEUDO-TERM-LISTP-OF-CDR-WHEN-PSEUDO-TERM-LISTP))
 (1026 90 (:REWRITE PSEUDO-TERM-LISTP-WHEN-SYMBOL-LISTP))
 (1026 9 (:REWRITE PSEUDO-TERMP-OF-CAR-WHEN-PSEUDO-TERM-LISTP))
 (803 39 (:DEFINITION MEMBER-EQUAL))
 (594 110 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (584 580 (:REWRITE DEFAULT-CAR))
 (209 192 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (199 199 (:REWRITE SUBSETP-TRANS2))
 (199 199 (:REWRITE SUBSETP-TRANS))
 (198 192 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (150 24 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (124 62 (:REWRITE DEFAULT-+-2))
 (84 84 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (82 2 (:REWRITE SUBSETP-OF-CONS))
 (78 78 (:REWRITE SUBSETP-MEMBER . 2))
 (78 78 (:REWRITE SUBSETP-MEMBER . 1))
 (62 62 (:REWRITE DEFAULT-+-1))
 (48 48 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (48 24 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (31 31 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (24 24 (:TYPE-PRESCRIPTION SET::EMPTY-TYPE))
 (24 24 (:REWRITE SET::IN-SET))
 (8 8 (:REWRITE DEFAULT-COERCE-2))
 (8 8 (:REWRITE DEFAULT-COERCE-1))
 )
(PSEUDO-TERMP-RECONSTRUCT-*-IN-TERM)
(PSEUDO-TERM-LISTP-RECONSTRUCT-*-IN-TERMS)
(RECONSTRUCT-*-IN-TERM
 (333 16 (:REWRITE PSEUDO-TERM-LISTP-OF-CDR-WHEN-PSEUDO-TERM-LISTP))
 (309 4 (:REWRITE PSEUDO-TERMP-OF-CAR-WHEN-PSEUDO-TERM-LISTP))
 (289 29 (:REWRITE PSEUDO-TERM-LISTP-WHEN-SYMBOL-LISTP))
 (220 36 (:DEFINITION SYMBOL-LISTP))
 (180 18 (:REWRITE PSEUDO-TERMP-WHEN-MEMBER-EQUAL-OF-PSEUDO-TERM-LISTP))
 (132 132 (:REWRITE DEFAULT-CDR))
 (126 6 (:REWRITE SUBSETP-CAR-MEMBER))
 (125 125 (:REWRITE DEFAULT-CAR))
 (90 18 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (87 3 (:DEFINITION MEMBER-EQUAL))
 (84 14 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (28 28 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (28 28 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (28 28 (:REWRITE PSEUDO-TERM-LISTP-WHEN-NOT-CONSP))
 (28 14 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (27 27 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (27 27 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (27 27 (:REWRITE SUBSETP-TRANS2))
 (27 27 (:REWRITE SUBSETP-TRANS))
 (26 13 (:REWRITE DEFAULT-+-2))
 (15 15 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (14 14 (:TYPE-PRESCRIPTION SET::EMPTY-TYPE))
 (14 14 (:REWRITE SET::IN-SET))
 (13 13 (:REWRITE DEFAULT-+-1))
 (10 1 (:DEFINITION RECONSTRUCT-*-IN-TERM))
 (9 9 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (6 6 (:REWRITE SUBSETP-MEMBER . 2))
 (6 6 (:REWRITE SUBSETP-MEMBER . 1))
 (3 1 (:DEFINITION RECONSTRUCT-*-IN-TERMS))
 (2 2 (:REWRITE DEFAULT-COERCE-2))
 (2 2 (:REWRITE DEFAULT-COERCE-1))
 )
(RECONSTRUCT-<=-IN-TERM
 (2953 1207 (:REWRITE DEFAULT-+-2))
 (2395 95 (:REWRITE PSEUDO-TERM-LISTP-OF-CDR-WHEN-PSEUDO-TERM-LISTP))
 (2258 26 (:REWRITE PSEUDO-TERMP-OF-CAR-WHEN-PSEUDO-TERM-LISTP))
 (1952 104 (:REWRITE PSEUDO-TERMP-WHEN-MEMBER-EQUAL-OF-PSEUDO-TERM-LISTP))
 (1780 179 (:REWRITE PSEUDO-TERM-LISTP-WHEN-SYMBOL-LISTP))
 (1728 1207 (:REWRITE DEFAULT-+-1))
 (1378 239 (:DEFINITION SYMBOL-LISTP))
 (1344 66 (:REWRITE SUBSETP-CAR-MEMBER))
 (1080 51 (:DEFINITION MEMBER-EQUAL))
 (1015 199 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (824 206 (:DEFINITION INTEGER-ABS))
 (366 61 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (337 337 (:REWRITE SUBSETP-TRANS2))
 (337 337 (:REWRITE SUBSETP-TRANS))
 (328 328 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (318 233 (:REWRITE DEFAULT-<-2))
 (257 257 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (251 233 (:REWRITE DEFAULT-<-1))
 (206 206 (:REWRITE DEFAULT-UNARY-MINUS))
 (175 175 (:REWRITE PSEUDO-TERM-LISTP-WHEN-NOT-CONSP))
 (171 171 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (156 9 (:REWRITE SUBSETP-OF-CONS))
 (122 122 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (122 61 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (117 117 (:REWRITE DEFAULT-COERCE-2))
 (117 117 (:REWRITE DEFAULT-COERCE-1))
 (103 103 (:REWRITE DEFAULT-REALPART))
 (103 103 (:REWRITE DEFAULT-NUMERATOR))
 (103 103 (:REWRITE DEFAULT-IMAGPART))
 (103 103 (:REWRITE DEFAULT-DENOMINATOR))
 (102 102 (:REWRITE SUBSETP-MEMBER . 2))
 (102 102 (:REWRITE SUBSETP-MEMBER . 1))
 (72 72 (:LINEAR ACL2-COUNT-WHEN-MEMBER))
 (61 61 (:TYPE-PRESCRIPTION SET::EMPTY-TYPE))
 (61 61 (:REWRITE SET::IN-SET))
 (52 52 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (15 15 (:LINEAR ACL2-COUNT-CAR-CDR-LINEAR))
 (2 2 (:TYPE-PRESCRIPTION RECONSTRUCT-*-IN-TERM))
 (1 1 (:TYPE-PRESCRIPTION RECONSTRUCT-<=-IN-TERM))
 )
(FLAG-RECONSTRUCT-<=-IN-TERM
 (950 425 (:REWRITE DEFAULT-+-2))
 (595 425 (:REWRITE DEFAULT-+-1))
 (328 82 (:DEFINITION INTEGER-ABS))
 (328 41 (:DEFINITION LENGTH))
 (205 41 (:DEFINITION LEN))
 (121 95 (:REWRITE DEFAULT-<-2))
 (105 95 (:REWRITE DEFAULT-<-1))
 (105 6 (:DEFINITION MEMBER-EQUAL))
 (84 12 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (82 82 (:REWRITE DEFAULT-UNARY-MINUS))
 (41 41 (:TYPE-PRESCRIPTION LEN))
 (41 41 (:REWRITE DEFAULT-REALPART))
 (41 41 (:REWRITE DEFAULT-NUMERATOR))
 (41 41 (:REWRITE DEFAULT-IMAGPART))
 (41 41 (:REWRITE DEFAULT-DENOMINATOR))
 (41 41 (:REWRITE DEFAULT-COERCE-2))
 (41 41 (:REWRITE DEFAULT-COERCE-1))
 (26 26 (:LINEAR ACL2-COUNT-WHEN-MEMBER))
 (19 19 (:REWRITE SUBSETP-TRANS2))
 (19 19 (:REWRITE SUBSETP-TRANS))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (12 12 (:REWRITE SUBSETP-MEMBER . 2))
 (12 12 (:REWRITE SUBSETP-MEMBER . 1))
 (8 2 (:TYPE-PRESCRIPTION RETURN-LAST))
 (3 3 (:REWRITE MEMBER-SELF))
 (2 2 (:TYPE-PRESCRIPTION THROW-NONEXEC-ERROR))
 )
(FLAG::FLAG-EQUIV-LEMMA)
(FLAG-RECONSTRUCT-<=-IN-TERM-EQUIVALENCES)
(FLAG-LEMMA-FOR-PSEUDO-TERMP-RECONSTRUCT-<=-IN-TERM
 (4512 120 (:REWRITE PSEUDO-TERM-LISTP-OF-CDR-WHEN-PSEUDO-TERM-LISTP))
 (4143 36 (:REWRITE PSEUDO-TERMP-OF-CAR-WHEN-PSEUDO-TERM-LISTP))
 (2739 124 (:DEFINITION MEMBER-EQUAL))
 (2701 243 (:REWRITE PSEUDO-TERM-LISTP-WHEN-SYMBOL-LISTP))
 (2217 423 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (1941 1931 (:REWRITE DEFAULT-CAR))
 (950 95 (:DEFINITION RECONSTRUCT-*-IN-TERM))
 (750 719 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (747 747 (:REWRITE SUBSETP-TRANS2))
 (747 747 (:REWRITE SUBSETP-TRANS))
 (440 68 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (391 16 (:REWRITE SUBSETP-OF-CONS))
 (298 149 (:REWRITE DEFAULT-+-2))
 (248 248 (:REWRITE SUBSETP-MEMBER . 2))
 (248 248 (:REWRITE SUBSETP-MEMBER . 1))
 (224 224 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (149 149 (:REWRITE DEFAULT-+-1))
 (136 136 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (136 68 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (124 124 (:TYPE-PRESCRIPTION RECONSTRUCT-*-IN-TERM))
 (77 77 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (68 68 (:TYPE-PRESCRIPTION SET::EMPTY-TYPE))
 (68 68 (:REWRITE SET::IN-SET))
 (27 27 (:REWRITE DEFAULT-COERCE-2))
 (27 27 (:REWRITE DEFAULT-COERCE-1))
 (3 3 (:REWRITE SUBSETP-NIL))
 )
(PSEUDO-TERMP-RECONSTRUCT-<=-IN-TERM)
(PSEUDO-TERM-LISTP-RECONSTRUCT-<=-IN-TERMS)
(RECONSTRUCT-UNARY---IN-TERM
 (676 294 (:REWRITE DEFAULT-+-2))
 (407 294 (:REWRITE DEFAULT-+-1))
 (332 15 (:REWRITE PSEUDO-TERM-LISTP-OF-CDR-WHEN-PSEUDO-TERM-LISTP))
 (309 4 (:REWRITE PSEUDO-TERMP-OF-CAR-WHEN-PSEUDO-TERM-LISTP))
 (288 28 (:REWRITE PSEUDO-TERM-LISTP-WHEN-SYMBOL-LISTP))
 (252 12 (:REWRITE SUBSETP-CAR-MEMBER))
 (248 6 (:LINEAR ACL2-COUNT-CAR-CDR-LINEAR))
 (220 36 (:DEFINITION SYMBOL-LISTP))
 (208 52 (:DEFINITION INTEGER-ABS))
 (180 18 (:REWRITE PSEUDO-TERMP-WHEN-MEMBER-EQUAL-OF-PSEUDO-TERM-LISTP))
 (180 7 (:DEFINITION MEMBER-EQUAL))
 (175 4 (:REWRITE ACL2-COUNT-WHEN-MEMBER))
 (174 30 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (84 14 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (81 61 (:REWRITE DEFAULT-<-2))
 (67 61 (:REWRITE DEFAULT-<-1))
 (52 52 (:REWRITE DEFAULT-UNARY-MINUS))
 (45 45 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (45 45 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (45 45 (:REWRITE SUBSETP-TRANS2))
 (45 45 (:REWRITE SUBSETP-TRANS))
 (31 31 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (28 28 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (28 28 (:REWRITE DEFAULT-COERCE-2))
 (28 28 (:REWRITE DEFAULT-COERCE-1))
 (28 14 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (27 27 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (27 27 (:REWRITE PSEUDO-TERM-LISTP-WHEN-NOT-CONSP))
 (26 26 (:REWRITE DEFAULT-REALPART))
 (26 26 (:REWRITE DEFAULT-NUMERATOR))
 (26 26 (:REWRITE DEFAULT-IMAGPART))
 (26 26 (:REWRITE DEFAULT-DENOMINATOR))
 (22 22 (:LINEAR ACL2-COUNT-WHEN-MEMBER))
 (14 14 (:TYPE-PRESCRIPTION SET::EMPTY-TYPE))
 (14 14 (:REWRITE SUBSETP-MEMBER . 2))
 (14 14 (:REWRITE SUBSETP-MEMBER . 1))
 (14 14 (:REWRITE SET::IN-SET))
 (9 9 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (1 1 (:TYPE-PRESCRIPTION RECONSTRUCT-UNARY---IN-TERM))
 (1 1 (:REWRITE MEMBER-SELF))
 )
(FLAG-RECONSTRUCT-UNARY---IN-TERM
 (734 321 (:REWRITE DEFAULT-+-2))
 (450 321 (:REWRITE DEFAULT-+-1))
 (240 60 (:DEFINITION INTEGER-ABS))
 (240 30 (:DEFINITION LENGTH))
 (150 30 (:DEFINITION LEN))
 (99 5 (:DEFINITION MEMBER-EQUAL))
 (91 70 (:REWRITE DEFAULT-<-2))
 (84 12 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (77 70 (:REWRITE DEFAULT-<-1))
 (60 60 (:REWRITE DEFAULT-UNARY-MINUS))
 (30 30 (:TYPE-PRESCRIPTION LEN))
 (30 30 (:REWRITE DEFAULT-REALPART))
 (30 30 (:REWRITE DEFAULT-NUMERATOR))
 (30 30 (:REWRITE DEFAULT-IMAGPART))
 (30 30 (:REWRITE DEFAULT-DENOMINATOR))
 (30 30 (:REWRITE DEFAULT-COERCE-2))
 (30 30 (:REWRITE DEFAULT-COERCE-1))
 (24 24 (:LINEAR ACL2-COUNT-WHEN-MEMBER))
 (19 19 (:REWRITE SUBSETP-TRANS2))
 (19 19 (:REWRITE SUBSETP-TRANS))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (10 10 (:REWRITE SUBSETP-MEMBER . 2))
 (10 10 (:REWRITE SUBSETP-MEMBER . 1))
 (8 2 (:TYPE-PRESCRIPTION RETURN-LAST))
 (2 2 (:TYPE-PRESCRIPTION THROW-NONEXEC-ERROR))
 (2 2 (:REWRITE MEMBER-SELF))
 )
(FLAG::FLAG-EQUIV-LEMMA)
(FLAG-RECONSTRUCT-UNARY---IN-TERM-EQUIVALENCES)
(FLAG-LEMMA-FOR-PSEUDO-TERMP-RECONSTRUCT-UNARY---IN-TERM
 (1693 44 (:REWRITE PSEUDO-TERM-LISTP-OF-CDR-WHEN-PSEUDO-TERM-LISTP))
 (1575 13 (:REWRITE PSEUDO-TERMP-OF-CAR-WHEN-PSEUDO-TERM-LISTP))
 (1104 91 (:REWRITE PSEUDO-TERM-LISTP-WHEN-SYMBOL-LISTP))
 (1104 50 (:DEFINITION MEMBER-EQUAL))
 (920 172 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (753 741 (:REWRITE DEFAULT-CAR))
 (323 294 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (315 294 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (304 304 (:REWRITE SUBSETP-TRANS2))
 (304 304 (:REWRITE SUBSETP-TRANS))
 (196 31 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (158 79 (:REWRITE DEFAULT-+-2))
 (100 100 (:REWRITE SUBSETP-MEMBER . 2))
 (100 100 (:REWRITE SUBSETP-MEMBER . 1))
 (82 82 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (82 2 (:REWRITE SUBSETP-OF-CONS))
 (79 79 (:REWRITE DEFAULT-+-1))
 (62 62 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (62 31 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (31 31 (:TYPE-PRESCRIPTION SET::EMPTY-TYPE))
 (31 31 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (31 31 (:REWRITE SET::IN-SET))
 (10 10 (:REWRITE DEFAULT-COERCE-2))
 (10 10 (:REWRITE DEFAULT-COERCE-1))
 )
(PSEUDO-TERMP-RECONSTRUCT-UNARY---IN-TERM)
(PSEUDO-TERM-LISTP-RECONSTRUCT-UNARY---IN-TERMS)
(UNQUOTE-IN-TERM
 (518 218 (:REWRITE DEFAULT-+-2))
 (332 15 (:REWRITE PSEUDO-TERM-LISTP-OF-CDR-WHEN-PSEUDO-TERM-LISTP))
 (309 4 (:REWRITE PSEUDO-TERMP-OF-CAR-WHEN-PSEUDO-TERM-LISTP))
 (301 218 (:REWRITE DEFAULT-+-1))
 (288 28 (:REWRITE PSEUDO-TERM-LISTP-WHEN-SYMBOL-LISTP))
 (252 12 (:REWRITE SUBSETP-CAR-MEMBER))
 (220 36 (:DEFINITION SYMBOL-LISTP))
 (180 18 (:REWRITE PSEUDO-TERMP-WHEN-MEMBER-EQUAL-OF-PSEUDO-TERM-LISTP))
 (174 30 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (174 6 (:DEFINITION MEMBER-EQUAL))
 (165 3 (:REWRITE ACL2-COUNT-WHEN-MEMBER))
 (144 36 (:DEFINITION INTEGER-ABS))
 (84 14 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (60 43 (:REWRITE DEFAULT-<-2))
 (47 43 (:REWRITE DEFAULT-<-1))
 (45 45 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (45 45 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (45 45 (:REWRITE SUBSETP-TRANS2))
 (45 45 (:REWRITE SUBSETP-TRANS))
 (36 36 (:REWRITE DEFAULT-UNARY-MINUS))
 (30 30 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (28 28 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (28 14 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (27 27 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (27 27 (:REWRITE PSEUDO-TERM-LISTP-WHEN-NOT-CONSP))
 (20 20 (:REWRITE DEFAULT-COERCE-2))
 (20 20 (:REWRITE DEFAULT-COERCE-1))
 (20 20 (:LINEAR ACL2-COUNT-WHEN-MEMBER))
 (18 18 (:REWRITE DEFAULT-REALPART))
 (18 18 (:REWRITE DEFAULT-NUMERATOR))
 (18 18 (:REWRITE DEFAULT-IMAGPART))
 (18 18 (:REWRITE DEFAULT-DENOMINATOR))
 (14 14 (:TYPE-PRESCRIPTION SET::EMPTY-TYPE))
 (14 14 (:REWRITE SET::IN-SET))
 (12 12 (:REWRITE SUBSETP-MEMBER . 2))
 (12 12 (:REWRITE SUBSETP-MEMBER . 1))
 (9 9 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (5 5 (:LINEAR ACL2-COUNT-CAR-CDR-LINEAR))
 (1 1 (:TYPE-PRESCRIPTION UNQUOTE-IN-TERM))
 )
(RECONSTRUCT-MBT-IN-TERM
 (576 246 (:REWRITE DEFAULT-+-2))
 (340 246 (:REWRITE DEFAULT-+-1))
 (323 14 (:REWRITE PSEUDO-TERM-LISTP-OF-CDR-WHEN-PSEUDO-TERM-LISTP))
 (309 4 (:REWRITE PSEUDO-TERMP-OF-CAR-WHEN-PSEUDO-TERM-LISTP))
 (277 26 (:REWRITE PSEUDO-TERM-LISTP-WHEN-SYMBOL-LISTP))
 (252 12 (:REWRITE SUBSETP-CAR-MEMBER))
 (216 35 (:DEFINITION SYMBOL-LISTP))
 (180 18 (:REWRITE PSEUDO-TERMP-WHEN-MEMBER-EQUAL-OF-PSEUDO-TERM-LISTP))
 (174 30 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (174 6 (:DEFINITION MEMBER-EQUAL))
 (168 42 (:DEFINITION INTEGER-ABS))
 (165 3 (:REWRITE ACL2-COUNT-WHEN-MEMBER))
 (84 14 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (69 50 (:REWRITE DEFAULT-<-2))
 (55 50 (:REWRITE DEFAULT-<-1))
 (45 45 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (45 45 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (45 45 (:REWRITE SUBSETP-TRANS2))
 (45 45 (:REWRITE SUBSETP-TRANS))
 (44 1 (:DEFINITION RECONSTRUCT-MBT-IN-TERM))
 (42 42 (:REWRITE DEFAULT-UNARY-MINUS))
 (30 30 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (28 28 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (28 14 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (25 25 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (25 25 (:REWRITE PSEUDO-TERM-LISTP-WHEN-NOT-CONSP))
 (23 23 (:REWRITE DEFAULT-COERCE-2))
 (23 23 (:REWRITE DEFAULT-COERCE-1))
 (21 21 (:REWRITE DEFAULT-REALPART))
 (21 21 (:REWRITE DEFAULT-NUMERATOR))
 (21 21 (:REWRITE DEFAULT-IMAGPART))
 (21 21 (:REWRITE DEFAULT-DENOMINATOR))
 (20 20 (:LINEAR ACL2-COUNT-WHEN-MEMBER))
 (14 14 (:TYPE-PRESCRIPTION SET::EMPTY-TYPE))
 (14 14 (:REWRITE SET::IN-SET))
 (12 12 (:REWRITE SUBSETP-MEMBER . 2))
 (12 12 (:REWRITE SUBSETP-MEMBER . 1))
 (9 9 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (5 5 (:LINEAR ACL2-COUNT-CAR-CDR-LINEAR))
 (3 1 (:DEFINITION RECONSTRUCT-MBT-IN-TERMS))
 (1 1 (:TYPE-PRESCRIPTION RECONSTRUCT-MBT-IN-TERM))
 )
(FLAG-RECONSTRUCT-MBT-IN-TERM
 (634 273 (:REWRITE DEFAULT-+-2))
 (383 273 (:REWRITE DEFAULT-+-1))
 (200 50 (:DEFINITION INTEGER-ABS))
 (200 25 (:DEFINITION LENGTH))
 (125 25 (:DEFINITION LEN))
 (93 4 (:DEFINITION MEMBER-EQUAL))
 (84 12 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (79 59 (:REWRITE DEFAULT-<-2))
 (65 59 (:REWRITE DEFAULT-<-1))
 (50 50 (:REWRITE DEFAULT-UNARY-MINUS))
 (25 25 (:TYPE-PRESCRIPTION LEN))
 (25 25 (:REWRITE DEFAULT-REALPART))
 (25 25 (:REWRITE DEFAULT-NUMERATOR))
 (25 25 (:REWRITE DEFAULT-IMAGPART))
 (25 25 (:REWRITE DEFAULT-DENOMINATOR))
 (25 25 (:REWRITE DEFAULT-COERCE-2))
 (25 25 (:REWRITE DEFAULT-COERCE-1))
 (22 22 (:LINEAR ACL2-COUNT-WHEN-MEMBER))
 (19 19 (:REWRITE SUBSETP-TRANS2))
 (19 19 (:REWRITE SUBSETP-TRANS))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (18 18 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (8 8 (:REWRITE SUBSETP-MEMBER . 2))
 (8 8 (:REWRITE SUBSETP-MEMBER . 1))
 (4 2 (:TYPE-PRESCRIPTION RETURN-LAST))
 (2 2 (:TYPE-PRESCRIPTION THROW-NONEXEC-ERROR))
 (1 1 (:REWRITE MEMBER-SELF))
 )
(FLAG::FLAG-EQUIV-LEMMA)
(FLAG-RECONSTRUCT-MBT-IN-TERM-EQUIVALENCES)
(LEN-OF-RECONSTRUCT-MBT-IN-TERMS
 (62 46 (:REWRITE DEFAULT-CDR))
 (48 24 (:REWRITE DEFAULT-+-2))
 (44 1 (:DEFINITION RECONSTRUCT-MBT-IN-TERM))
 (24 24 (:REWRITE DEFAULT-+-1))
 (24 18 (:REWRITE DEFAULT-CAR))
 )
(FLAG-LEMMA-FOR-PSEUDO-TERMP-OF-RECONSTRUCT-MBT-IN-TERM
 (2234 61 (:REWRITE PSEUDO-TERM-LISTP-OF-CDR-WHEN-PSEUDO-TERM-LISTP))
 (1629 12 (:REWRITE PSEUDO-TERMP-OF-CAR-WHEN-PSEUDO-TERM-LISTP))
 (1547 124 (:REWRITE PSEUDO-TERM-LISTP-WHEN-SYMBOL-LISTP))
 (1439 60 (:DEFINITION MEMBER-EQUAL))
 (1137 931 (:REWRITE DEFAULT-CAR))
 (290 264 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (278 278 (:REWRITE SUBSETP-TRANS2))
 (278 278 (:REWRITE SUBSETP-TRANS))
 (277 264 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (176 28 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (119 119 (:REWRITE SUBSETP-MEMBER . 2))
 (119 119 (:REWRITE SUBSETP-MEMBER . 1))
 (114 114 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (104 52 (:REWRITE DEFAULT-+-2))
 (56 56 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (56 28 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (52 52 (:REWRITE DEFAULT-+-1))
 (41 41 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (28 28 (:TYPE-PRESCRIPTION SET::EMPTY-TYPE))
 (28 28 (:REWRITE SET::IN-SET))
 (10 10 (:REWRITE DEFAULT-COERCE-2))
 (10 10 (:REWRITE DEFAULT-COERCE-1))
 )
(PSEUDO-TERMP-OF-RECONSTRUCT-MBT-IN-TERM)
(PSEUDO-TERM-LISTP-OF-RECONSTRUCT-MBT-IN-TERMS)
(RECONSTRUCT-MACROS-IN-TERM
 (1 1 (:TYPE-PRESCRIPTION RECONSTRUCT-MACROS-IN-TERM))
 )
