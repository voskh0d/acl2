(WANT-TO-AUTOHIDE
 (9 3 (:DEFINITION SYMBOL-LISTP))
 (6 6 (:REWRITE DEFAULT-CAR))
 (5 5 (:REWRITE DEFAULT-CDR))
 (4 4 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (3 3 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 )
(AUTOHIDE-TERM
 (9 3 (:DEFINITION SYMBOL-LISTP))
 (6 6 (:REWRITE DEFAULT-CAR))
 (5 5 (:REWRITE DEFAULT-CDR))
 (4 4 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (3 3 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 )
(FLAG-AUTOHIDE-TERM
 (8 2 (:TYPE-PRESCRIPTION RETURN-LAST))
 (2 2 (:TYPE-PRESCRIPTION THROW-NONEXEC-ERROR))
 )
(FLAG::FLAG-EQUIV-LEMMA)
(FLAG-AUTOHIDE-TERM-EQUIVALENCES)
(AUTOHIDE-TERM-LIST-WHEN-ATOM)
(AUTOHIDE-TERM-LIST-OF-CONS
 (22 2 (:DEFINITION AUTOHIDE-TERM))
 (13 13 (:REWRITE DEFAULT-CAR))
 (8 8 (:REWRITE AUTOHIDE-TERM-LIST-WHEN-ATOM))
 (7 7 (:REWRITE DEFAULT-CDR))
 (6 2 (:DEFINITION MEMBER-EQUAL))
 (2 2 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 )
(AUTOHIDE-TERM-LIST-LEN
 (76 38 (:REWRITE DEFAULT-+-2))
 (64 16 (:DEFINITION AUTOHIDE-TERM-LIST))
 (62 62 (:REWRITE DEFAULT-CDR))
 (38 38 (:REWRITE DEFAULT-+-1))
 (21 21 (:REWRITE DEFAULT-CAR))
 (11 1 (:DEFINITION AUTOHIDE-TERM))
 (3 1 (:DEFINITION MEMBER-EQUAL))
 (1 1 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 )
(LAMBDA-HEADER-P)
(PSEUDO-TERMP-OF-CONS
 (166 166 (:REWRITE DEFAULT-CDR))
 (124 124 (:REWRITE DEFAULT-CAR))
 (96 48 (:REWRITE DEFAULT-+-2))
 (48 48 (:REWRITE DEFAULT-+-1))
 (36 6 (:DEFINITION PSEUDO-TERM-LISTP))
 (26 26 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (25 25 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 )
(FLAG-LEMMA-FOR-PSEUDO-TERMP-OF-AUTOHIDE-TERM
 (244 244 (:REWRITE DEFAULT-CAR))
 (208 208 (:REWRITE DEFAULT-CDR))
 (72 36 (:REWRITE DEFAULT-+-2))
 (57 57 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (48 48 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (36 36 (:REWRITE DEFAULT-+-1))
 (2 2 (:TYPE-PRESCRIPTION AUTOHIDE-TERM))
 )
(PSEUDO-TERMP-OF-AUTOHIDE-TERM)
(PSEUDO-TERM-LISTP-OF-AUTOHIDE-TERM-LIST)
(APPLY-FOR-DEFEVALUATOR)
(AUTOHIDE-EV)
(EVAL-LIST-KWOTE-LST)
(TRUE-LIST-FIX-EV-LST)
(EV-COMMUTES-CAR)
(EV-LST-COMMUTES-CDR)
(AUTOHIDE-EV-CONSTRAINT-0)
(AUTOHIDE-EV-CONSTRAINT-1)
(AUTOHIDE-EV-CONSTRAINT-2)
(AUTOHIDE-EV-CONSTRAINT-3)
(AUTOHIDE-EV-CONSTRAINT-4)
(AUTOHIDE-EV-CONSTRAINT-5)
(AUTOHIDE-EV-CONSTRAINT-6)
(AUTOHIDE-EV-CONSTRAINT-7)
(AUTOHIDE-EV-CONSTRAINT-8)
(AUTOHIDE-EV-CONSTRAINT-9)
(AUTOHIDE-EV-OF-DISJOIN2
 (27 21 (:REWRITE AUTOHIDE-EV-CONSTRAINT-9))
 (18 18 (:REWRITE AUTOHIDE-EV-CONSTRAINT-3))
 (13 13 (:REWRITE DEFAULT-CDR))
 (13 13 (:REWRITE DEFAULT-CAR))
 (12 12 (:REWRITE AUTOHIDE-EV-CONSTRAINT-1))
 )
(AUTOHIDE-EV-OF-DISJOIN
 (71 71 (:REWRITE DEFAULT-CDR))
 (62 62 (:REWRITE DEFAULT-CAR))
 (36 36 (:REWRITE AUTOHIDE-EV-CONSTRAINT-9))
 (36 36 (:REWRITE AUTOHIDE-EV-CONSTRAINT-8))
 (36 36 (:REWRITE AUTOHIDE-EV-CONSTRAINT-3))
 (35 35 (:REWRITE AUTOHIDE-EV-CONSTRAINT-1))
 )
(AUTOHIDE-EV-OF-ARBITRARY-FUNCTION
 (26 18 (:REWRITE DEFAULT-CAR))
 (18 4 (:REWRITE AUTOHIDE-EV-CONSTRAINT-9))
 (18 4 (:REWRITE AUTOHIDE-EV-CONSTRAINT-8))
 (18 4 (:REWRITE AUTOHIDE-EV-CONSTRAINT-3))
 (18 4 (:REWRITE AUTOHIDE-EV-CONSTRAINT-2))
 (8 2 (:DEFINITION KWOTE-LST))
 (6 4 (:REWRITE AUTOHIDE-EV-CONSTRAINT-1))
 (2 2 (:REWRITE DEFAULT-CDR))
 (2 2 (:REWRITE AUTOHIDE-EV-CONSTRAINT-5))
 (2 2 (:REWRITE AUTOHIDE-EV-CONSTRAINT-4))
 (2 2 (:DEFINITION KWOTE))
 )
(FLAG-LEMMA-FOR-AUTOHIDE-TERM-CORRECT
 (310 310 (:REWRITE DEFAULT-CAR))
 (248 248 (:REWRITE DEFAULT-CDR))
 (82 41 (:REWRITE DEFAULT-+-2))
 (62 30 (:REWRITE AUTOHIDE-EV-CONSTRAINT-8))
 (41 41 (:REWRITE DEFAULT-+-1))
 (36 12 (:DEFINITION SYMBOL-LISTP))
 (35 35 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (34 34 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (30 30 (:TYPE-PRESCRIPTION AUTOHIDE-TERM))
 (10 2 (:DEFINITION PAIRLIS$))
 (10 2 (:DEFINITION ASSOC-EQUAL))
 )
(AUTOHIDE-TERM-CORRECT)
(AUTOHIDE-TERM-LIST-CORRECT)
(AUTOHIDE-CP)
(AUTOHIDE-CP-CORRECT
 (12 12 (:REWRITE DEFAULT-CDR))
 (12 12 (:REWRITE DEFAULT-CAR))
 (12 2 (:DEFINITION PSEUDO-TERM-LISTP))
 (8 2 (:DEFINITION AUTOHIDE-TERM-LIST))
 (6 2 (:DEFINITION SYMBOL-LISTP))
 (6 2 (:DEFINITION ALISTP))
 (4 4 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (4 4 (:REWRITE AUTOHIDE-TERM-LIST-WHEN-ATOM))
 (4 4 (:REWRITE AUTOHIDE-EV-CONSTRAINT-5))
 (4 4 (:REWRITE AUTOHIDE-EV-CONSTRAINT-4))
 (2 2 (:TYPE-PRESCRIPTION PSEUDO-TERMP))
 (2 2 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (1 1 (:REWRITE AUTOHIDE-EV-CONSTRAINT-9))
 (1 1 (:REWRITE AUTOHIDE-EV-CONSTRAINT-8))
 (1 1 (:REWRITE AUTOHIDE-EV-CONSTRAINT-3))
 (1 1 (:REWRITE AUTOHIDE-EV-CONSTRAINT-2))
 (1 1 (:REWRITE AUTOHIDE-EV-CONSTRAINT-1))
 )
(AUTOHIDE-FNS)
(AUTOHIDE-HINT)
