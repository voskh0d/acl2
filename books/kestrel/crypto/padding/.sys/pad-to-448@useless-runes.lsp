(PADDING::PAD-TO-448-NUMBER-OF-ZEROS
 (5 5 (:TYPE-PRESCRIPTION NONNEG-OF-MOD-TYPE-2))
 (5 5 (:TYPE-PRESCRIPTION NONNEG-OF-MOD-TYPE))
 (5 5 (:TYPE-PRESCRIPTION INTEGERP-OF-MOD-TYPE))
 )
(PADDING::PAD-TO-448-NUMBER-OF-ZEROS-TYPE)
(PADDING::PAD-TO-448)
(PADDING::PAD-TO-448-CORRECT-1
 (28 1 (:REWRITE REPEAT-WHEN-ZP))
 (24 9 (:REWRITE DEFAULT-+-2))
 (22 1 (:REWRITE ZP-OPEN))
 (11 9 (:REWRITE DEFAULT-+-1))
 (9 4 (:REWRITE DEFAULT-<-2))
 (9 4 (:REWRITE DEFAULT-<-1))
 (6 5 (:REWRITE DEFAULT-CDR))
 (2 2 (:REWRITE FOLD-CONSTS-IN-+))
 (1 1 (:TYPE-PRESCRIPTION ZP))
 (1 1 (:REWRITE APPEND-WHEN-NOT-CONSP-ARG1-CHEAP))
 )
(PADDING::PAD-TO-448-CORRECT-2
 (28 1 (:REWRITE REPEAT-WHEN-ZP))
 (22 1 (:REWRITE ZP-OPEN))
 (20 10 (:TYPE-PRESCRIPTION PADDING::PAD-TO-448-NUMBER-OF-ZEROS-TYPE))
 (12 12 (:TYPE-PRESCRIPTION LEN))
 (10 2 (:DEFINITION LEN))
 (9 9 (:REWRITE DEFAULT-CDR))
 (6 2 (:REWRITE DEFAULT-<-2))
 (4 4 (:REWRITE DEFAULT-CAR))
 (4 2 (:REWRITE DEFAULT-+-2))
 (2 2 (:REWRITE DEFAULT-<-1))
 (2 2 (:REWRITE DEFAULT-+-1))
 (1 1 (:TYPE-PRESCRIPTION ZP))
 (1 1 (:REWRITE APPEND-WHEN-NOT-CONSP-ARG1-CHEAP))
 )
(PADDING::PAD-TO-448-CORRECT-3
 (6682 349 (:REWRITE MOD-WHEN-INTEGERP-OF-QUOTIENT))
 (3204 1037 (:REWRITE DEFAULT-+-2))
 (2872 242 (:REWRITE MOD-WHEN-<))
 (2328 213 (:REWRITE COMMUTATIVITY-OF-*))
 (1440 518 (:REWRITE DEFAULT-*-2))
 (1412 1037 (:REWRITE DEFAULT-+-1))
 (1212 518 (:REWRITE DEFAULT-*-1))
 (1177 294 (:REWRITE DEFAULT-<-1))
 (995 88 (:REWRITE DISTRIBUTIVITY))
 (835 242 (:REWRITE MOD-WHEN-RATIONALP-ARG1-AND-NOT-RATIONALP-ARG2))
 (835 242 (:REWRITE MOD-WHEN-NOT-RATIONALP-ARG1-AND-RATIONALP-ARG2))
 (835 242 (:REWRITE MOD-WHEN-NOT-ACL2-NUMBERP-ARG1))
 (803 156 (:REWRITE MULTIPLE-WHEN-MOD-0-CHEAP))
 (461 461 (:REWRITE MOD-WHEN-EQUAL-OF-MOD-AND-0-FREE-CHEAP))
 (362 294 (:REWRITE DEFAULT-<-2))
 (242 242 (:REWRITE MOD-WHEN-NOT-ACL2-NUMBERP-ARG2))
 (208 1 (:REWRITE REPEAT-WHEN-ZP))
 (203 169 (:REWRITE MOD-OF-+-SUBST-CONSTANT))
 (166 1 (:REWRITE ZP-OPEN))
 (147 123 (:REWRITE DEFAULT-UNARY-MINUS))
 (135 135 (:REWRITE MOD-OF-+-OF---WHEN-EQUAL-OF-MOD-ARG2))
 (89 88 (:REWRITE DEFAULT-CDR))
 (15 15 (:REWRITE MOD-OF-+-OF---WHEN-EQUAL-OF-MOD-ARG1))
 (1 1 (:TYPE-PRESCRIPTION ZP))
 (1 1 (:REWRITE APPEND-WHEN-NOT-CONSP-ARG1-CHEAP))
 )
(PADDING::PAD-TO-448-CORRECT-4
 (167 1 (:REWRITE REPEAT-WHEN-ZP))
 (157 1 (:REWRITE ZP-OPEN))
 (90 5 (:REWRITE MOD-WHEN-INTEGERP-OF-QUOTIENT))
 (86 25 (:REWRITE DEFAULT-+-2))
 (55 5 (:REWRITE MOD-WHEN-<))
 (55 5 (:REWRITE COMMUTATIVITY-OF-*))
 (53 1 (:LINEAR MOD-BOUND-LINEAR-ARG2))
 (40 5 (:REWRITE MOD-WHEN-<-OF-0))
 (36 25 (:REWRITE DEFAULT-+-1))
 (35 5 (:REWRITE DISTRIBUTIVITY))
 (30 15 (:REWRITE DEFAULT-<-1))
 (29 15 (:REWRITE DEFAULT-<-2))
 (25 15 (:REWRITE DEFAULT-*-2))
 (20 15 (:REWRITE DEFAULT-*-1))
 (10 5 (:REWRITE MOD-WHEN-RATIONALP-ARG1-AND-NOT-RATIONALP-ARG2))
 (10 5 (:REWRITE MOD-WHEN-NOT-RATIONALP-ARG1-AND-RATIONALP-ARG2))
 (10 5 (:REWRITE MOD-WHEN-NOT-ACL2-NUMBERP-ARG1))
 (9 1 (:LINEAR MOD-BOUND-LINEAR-ARG1))
 (8 4 (:REWRITE DEFAULT-UNARY-MINUS))
 (6 5 (:REWRITE DEFAULT-CDR))
 (5 5 (:REWRITE MOD-WHEN-NOT-ACL2-NUMBERP-ARG2))
 (5 5 (:REWRITE MOD-WHEN-EQUAL-OF-MOD-AND-0-FREE-CHEAP))
 (5 5 (:REWRITE MOD-OF-+-SUBST-CONSTANT))
 (5 5 (:REWRITE MOD-OF-+-OF---WHEN-EQUAL-OF-MOD-ARG2))
 (1 1 (:TYPE-PRESCRIPTION ZP))
 (1 1 (:REWRITE APPEND-WHEN-NOT-CONSP-ARG1-CHEAP))
 )
(PADDING::ALL-UNSIGNED-BYTE-P-OF-PAD-TO-448
 (28 1 (:REWRITE REPEAT-WHEN-ZP))
 (9 3 (:REWRITE DEFAULT-<-2))
 (7 3 (:REWRITE ALL-UNSIGNED-BYTE-P-WHEN-NOT-CONSP))
 (5 1 (:DEFINITION LEN))
 (3 3 (:REWRITE DEFAULT-<-1))
 (2 2 (:TYPE-PRESCRIPTION REPEAT))
 (2 1 (:TYPE-PRESCRIPTION TRUE-LISTP-APPEND))
 (2 1 (:REWRITE DEFAULT-+-2))
 (1 1 (:TYPE-PRESCRIPTION ZP))
 (1 1 (:TYPE-PRESCRIPTION BINARY-APPEND))
 (1 1 (:REWRITE DEFAULT-CDR))
 (1 1 (:REWRITE DEFAULT-+-1))
 (1 1 (:REWRITE APPEND-WHEN-NOT-CONSP-ARG1-CHEAP))
 )
(PADDING::MOD-OF-LEN-OF-PAD-TO-448-AND-32
 (15097 1101 (:REWRITE MOD-WHEN-INTEGERP-OF-QUOTIENT))
 (5813 1545 (:REWRITE DEFAULT-+-2))
 (5299 709 (:REWRITE MOD-WHEN-<))
 (5024 924 (:REWRITE COMMUTATIVITY-OF-*))
 (4207 1645 (:REWRITE MOD-WHEN-<-OF-0))
 (3275 1992 (:REWRITE DEFAULT-*-2))
 (3069 1992 (:REWRITE DEFAULT-*-1))
 (2816 803 (:REWRITE MULTIPLE-WHEN-MOD-0-CHEAP))
 (2565 752 (:REWRITE DEFAULT-<-1))
 (2256 1545 (:REWRITE DEFAULT-+-1))
 (1769 709 (:REWRITE MOD-WHEN-RATIONALP-ARG1-AND-NOT-RATIONALP-ARG2))
 (1769 709 (:REWRITE MOD-WHEN-NOT-RATIONALP-ARG1-AND-RATIONALP-ARG2))
 (1769 709 (:REWRITE MOD-WHEN-NOT-ACL2-NUMBERP-ARG1))
 (1175 140 (:REWRITE DISTRIBUTIVITY))
 (792 752 (:REWRITE DEFAULT-<-2))
 (709 709 (:REWRITE MOD-WHEN-NOT-ACL2-NUMBERP-ARG2))
 (333 331 (:REWRITE DEFAULT-UNARY-MINUS))
 (208 1 (:REWRITE REPEAT-WHEN-ZP))
 (166 1 (:REWRITE ZP-OPEN))
 (155 121 (:REWRITE MOD-OF-+-SUBST-CONSTANT))
 (122 121 (:REWRITE DEFAULT-CDR))
 (99 99 (:REWRITE MOD-OF-+-OF---WHEN-EQUAL-OF-MOD-ARG2))
 (9 9 (:REWRITE MOD-OF-+-OF---WHEN-EQUAL-OF-MOD-ARG1))
 (1 1 (:TYPE-PRESCRIPTION ZP))
 (1 1 (:REWRITE APPEND-WHEN-NOT-CONSP-ARG1-CHEAP))
 )
