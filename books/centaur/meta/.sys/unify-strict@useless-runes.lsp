(CMR::ASSOC-IS-HONS-ASSOC
 (7 7 (:REWRITE DEFAULT-CDR))
 )
(CMR::TAKE-OF-PSEUDO-TERM-LIST-FIX
 (2186 22 (:REWRITE PSEUDO-TERM-LIST-FIX-WHEN-PSEUDO-TERM-LISTP))
 (2095 66 (:DEFINITION PSEUDO-TERM-LISTP))
 (1951 11 (:DEFINITION PSEUDO-TERM-LIST-FIX$INLINE))
 (1487 138 (:REWRITE CMR::PSEUDO-TERM-LIST-P-WHEN-PSEUDO-VAR-LIST-P))
 (962 94 (:REWRITE PSEUDO-TERM-LISTP-CDR-WHEN-PSEUDO-TERM-LISTP))
 (854 121 (:REWRITE CMR::PSEUDO-VAR-LIST-P-OF-CDR-WHEN-PSEUDO-VAR-LIST-P))
 (774 81 (:REWRITE PSEUDO-TERMP-CAR-WHEN-PSEUDO-TERM-LISTP))
 (699 15 (:REWRITE PSEUDO-TERM-FIX-WHEN-PSEUDO-TERMP))
 (465 465 (:TYPE-PRESCRIPTION PSEUDO-TERM-LISTP))
 (399 33 (:REWRITE TAKE-OF-LEN-FREE))
 (331 237 (:REWRITE CMR::PSEUDO-VAR-LIST-P-WHEN-NOT-CONSP))
 (309 8 (:REWRITE PSEUDO-TERM-LISTP-TAKE))
 (221 221 (:TYPE-PRESCRIPTION LEN))
 (186 162 (:REWRITE DEFAULT-CDR))
 (173 33 (:DEFINITION LEN))
 (162 162 (:TYPE-PRESCRIPTION PSEUDO-TERMP))
 (138 138 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (93 93 (:REWRITE DEFAULT-CAR))
 (90 32 (:REWRITE CONSP-OF-TAKE))
 (85 50 (:REWRITE DEFAULT-+-2))
 (84 12 (:REWRITE CAR-OF-TAKE))
 (81 81 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (51 7 (:REWRITE LEN-OF-PSEUDO-TERM-LIST-FIX))
 (50 50 (:REWRITE DEFAULT-+-1))
 (48 16 (:DEFINITION NFIX))
 (38 38 (:REWRITE DEFAULT-<-2))
 (38 38 (:REWRITE DEFAULT-<-1))
 (38 20 (:REWRITE ZP-OPEN))
 (28 4 (:REWRITE SECOND-OF-TAKE))
 (16 16 (:TYPE-PRESCRIPTION NFIX))
 (3 3 (:REWRITE-QUOTED-CONSTANT PSEUDO-TERM-LIST-FIX-UNDER-PSEUDO-TERM-LIST-EQUIV))
 )
(CMR::PSEUDO-TERM-LAMBDA-OF-REPLACE-NON-SYMBOLS
 (364 4 (:REWRITE PSEUDO-TERM-LIST-FIX-WHEN-PSEUDO-TERM-LISTP))
 (276 5 (:DEFINITION PSEUDO-TERM-LISTP))
 (209 12 (:REWRITE CMR::PSEUDO-TERM-LIST-P-WHEN-PSEUDO-VAR-LIST-P))
 (138 138 (:TYPE-PRESCRIPTION LEN))
 (126 5 (:DEFINITION TAKE))
 (108 10 (:REWRITE TAKE-OF-LEN-FREE))
 (102 5 (:REWRITE CMR::PSEUDO-VAR-LIST-P-OF-CDR-WHEN-PSEUDO-VAR-LIST-P))
 (78 8 (:REWRITE CONSP-OF-TAKE))
 (72 16 (:REWRITE CMR::PSEUDO-VAR-LIST-P-WHEN-NOT-CONSP))
 (65 13 (:DEFINITION LEN))
 (57 2 (:REWRITE PSEUDO-TERM-LISTP-TAKE))
 (56 7 (:REWRITE ZP-OPEN))
 (55 11 (:DEFINITION NOT))
 (40 40 (:TYPE-PRESCRIPTION TAKE))
 (39 39 (:TYPE-PRESCRIPTION PSEUDO-TERM-LISTP))
 (32 32 (:TYPE-PRESCRIPTION CMR::PSEUDO-VAR-LIST-P))
 (31 18 (:REWRITE DEFAULT-+-2))
 (30 24 (:REWRITE DEFAULT-CDR))
 (24 13 (:REWRITE DEFAULT-<-2))
 (24 5 (:REWRITE PSEUDO-TERMP-CAR-WHEN-PSEUDO-TERM-LISTP))
 (18 18 (:REWRITE DEFAULT-+-1))
 (14 14 (:TYPE-PRESCRIPTION PSEUDO-TERMP))
 (13 13 (:REWRITE DEFAULT-<-1))
 (12 12 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (12 2 (:REWRITE CAR-OF-TAKE))
 (11 11 (:REWRITE DEFAULT-CAR))
 (10 5 (:REWRITE PSEUDO-TERM-LISTP-CDR-WHEN-PSEUDO-TERM-LISTP))
 (8 2 (:REWRITE PSEUDO-TERM-FIX-WHEN-PSEUDO-TERMP))
 (7 7 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (6 2 (:DEFINITION NFIX))
 (6 1 (:DEFINITION SYMBOL-LISTP))
 (3 3 (:REWRITE-QUOTED-CONSTANT PSEUDO-TERM-LIST-FIX-UNDER-PSEUDO-TERM-LIST-EQUIV))
 (2 2 (:TYPE-PRESCRIPTION NFIX))
 )
(CMR::EQUAL-OF-PSEUDO-TERM-LAMBDA
 (544 38 (:REWRITE TAKE-OF-LEN-FREE))
 (364 4 (:REWRITE PSEUDO-TERM-LIST-FIX-WHEN-PSEUDO-TERM-LISTP))
 (280 56 (:DEFINITION LEN))
 (276 5 (:DEFINITION PSEUDO-TERM-LISTP))
 (209 12 (:REWRITE CMR::PSEUDO-TERM-LIST-P-WHEN-PSEUDO-VAR-LIST-P))
 (145 17 (:REWRITE REPLACE-NON-SYMBOLS-WITH-NIL-WHEN-SYMBOL-LISTP))
 (132 112 (:REWRITE DEFAULT-CDR))
 (131 75 (:REWRITE DEFAULT-+-2))
 (102 5 (:REWRITE CMR::PSEUDO-VAR-LIST-P-OF-CDR-WHEN-PSEUDO-VAR-LIST-P))
 (96 16 (:DEFINITION SYMBOL-LISTP))
 (80 80 (:TYPE-PRESCRIPTION SYMBOL-LISTP))
 (78 8 (:REWRITE CONSP-OF-TAKE))
 (75 75 (:REWRITE DEFAULT-+-1))
 (72 16 (:REWRITE CMR::PSEUDO-VAR-LIST-P-WHEN-NOT-CONSP))
 (70 56 (:REWRITE DEFAULT-CAR))
 (57 2 (:REWRITE PSEUDO-TERM-LISTP-TAKE))
 (52 27 (:REWRITE DEFAULT-<-2))
 (39 39 (:TYPE-PRESCRIPTION PSEUDO-TERM-LISTP))
 (32 32 (:TYPE-PRESCRIPTION CMR::PSEUDO-VAR-LIST-P))
 (27 27 (:REWRITE DEFAULT-<-1))
 (24 5 (:REWRITE PSEUDO-TERMP-CAR-WHEN-PSEUDO-TERM-LISTP))
 (17 17 (:REWRITE-QUOTED-CONSTANT PSEUDO-TERM-LIST-FIX-UNDER-PSEUDO-TERM-LIST-EQUIV))
 (12 12 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (12 2 (:REWRITE CAR-OF-TAKE))
 (10 10 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (10 5 (:REWRITE PSEUDO-TERM-LISTP-CDR-WHEN-PSEUDO-TERM-LISTP))
 (6 2 (:DEFINITION NFIX))
 (2 2 (:TYPE-PRESCRIPTION NFIX))
 )
(CMR::EQUAL-OF-PSEUDO-TERM-FNCALL
 (61 3 (:REWRITE PSEUDO-TERM-LIST-FIX-WHEN-PSEUDO-TERM-LISTP))
 (44 2 (:DEFINITION PSEUDO-TERM-LISTP))
 (27 3 (:REWRITE PSEUDO-FNSYM-FIX-WHEN-PSEUDO-FNSYM-P))
 (24 4 (:REWRITE CMR::PSEUDO-TERM-LIST-P-WHEN-PSEUDO-VAR-LIST-P))
 (20 2 (:REWRITE PSEUDO-FN-P-WHEN-NOT-CONSP))
 (14 14 (:TYPE-PRESCRIPTION PSEUDO-TERM-LISTP))
 (12 12 (:TYPE-PRESCRIPTION CMR::PSEUDO-VAR-LIST-P))
 (10 2 (:REWRITE PSEUDO-FN-P-WHEN-LAMBDA))
 (8 2 (:REWRITE CMR::PSEUDO-VAR-LIST-P-OF-CDR-WHEN-PSEUDO-VAR-LIST-P))
 (6 6 (:TYPE-PRESCRIPTION PSEUDO-FNSYM-P))
 (6 6 (:TYPE-PRESCRIPTION PSEUDO-FN-P))
 (6 6 (:REWRITE CMR::PSEUDO-VAR-LIST-P-WHEN-NOT-CONSP))
 (5 5 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (4 4 (:TYPE-PRESCRIPTION PSEUDO-LAMBDA-P))
 (4 4 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (4 2 (:REWRITE PSEUDO-TERMP-CAR-WHEN-PSEUDO-TERM-LISTP))
 (4 2 (:REWRITE PSEUDO-TERM-LISTP-CDR-WHEN-PSEUDO-TERM-LISTP))
 (4 2 (:REWRITE PSEUDO-FN-P-WHEN-FNSYM))
 (4 2 (:REWRITE PSEUDO-FN-P-WHEN-CONSP))
 (2 2 (:REWRITE DEFAULT-CDR))
 (2 2 (:REWRITE DEFAULT-CAR))
 )
(CMR::EQUAL-OF-PSEUDO-TERM-CALL
 (1 1 (:REWRITE PSEUDO-TERM-CALL-WHEN-LAMBDA))
 (1 1 (:REWRITE PSEUDO-TERM-CALL-WHEN-FUNCTION))
 )
(CMR::EQUAL-OF-PSEUDO-TERM-QUOTE
 (1 1 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 )
(CMR::EQUAL-OF-PSEUDO-TERM-LAMBDA->FN
 (16 8 (:REWRITE DEFAULT-CDR))
 (16 8 (:REWRITE DEFAULT-CAR))
 (13 2 (:REWRITE PSEUDO-FN-P-WHEN-CONSP))
 (5 1 (:REWRITE PSEUDO-FN-P-WHEN-LAMBDA))
 (5 1 (:REWRITE PSEUDO-FN-P-WHEN-FNSYM))
 (4 4 (:TYPE-PRESCRIPTION PSEUDO-FN-P))
 (2 2 (:TYPE-PRESCRIPTION PSEUDO-FNSYM-P))
 (2 1 (:REWRITE PSEUDO-FN-P-WHEN-NOT-CONSP))
 )
(CMR::PSEUDO-TERM-FIX-UNDER-IFF
 (1002 27 (:DEFINITION PSEUDO-TERM-LISTP))
 (975 9 (:REWRITE PSEUDO-TERM-LIST-FIX-WHEN-PSEUDO-TERM-LISTP))
 (747 60 (:REWRITE CMR::PSEUDO-TERM-LIST-P-WHEN-PSEUDO-VAR-LIST-P))
 (468 30 (:REWRITE PSEUDO-TERMP-CAR-WHEN-PSEUDO-TERM-LISTP))
 (447 45 (:REWRITE PSEUDO-TERM-LISTP-CDR-WHEN-PSEUDO-TERM-LISTP))
 (423 63 (:REWRITE CMR::PSEUDO-VAR-LIST-P-OF-CDR-WHEN-PSEUDO-VAR-LIST-P))
 (396 6 (:REWRITE PSEUDO-TERM-FIX-WHEN-PSEUDO-TERMP))
 (234 234 (:TYPE-PRESCRIPTION CMR::PSEUDO-VAR-LIST-P))
 (204 204 (:TYPE-PRESCRIPTION PSEUDO-TERM-LISTP))
 (201 117 (:REWRITE CMR::PSEUDO-VAR-LIST-P-WHEN-NOT-CONSP))
 (195 195 (:TYPE-PRESCRIPTION LEN))
 (159 12 (:REWRITE TAKE-OF-LEN-FREE))
 (138 6 (:DEFINITION TAKE))
 (117 12 (:REWRITE CONSP-OF-TAKE))
 (111 102 (:REWRITE DEFAULT-CDR))
 (99 3 (:REWRITE PSEUDO-TERM-LISTP-TAKE))
 (94 94 (:REWRITE DEFAULT-CAR))
 (90 18 (:DEFINITION LEN))
 (72 9 (:REWRITE ZP-OPEN))
 (66 66 (:TYPE-PRESCRIPTION PSEUDO-TERMP))
 (60 60 (:TYPE-PRESCRIPTION TAKE))
 (60 60 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (42 24 (:REWRITE DEFAULT-+-2))
 (33 33 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (33 18 (:REWRITE DEFAULT-<-2))
 (27 3 (:REWRITE REPLACE-NON-SYMBOLS-WITH-NIL-WHEN-SYMBOL-LISTP))
 (24 24 (:REWRITE DEFAULT-+-1))
 (18 18 (:REWRITE DEFAULT-<-1))
 (18 3 (:REWRITE CAR-OF-TAKE))
 (18 3 (:DEFINITION SYMBOL-LISTP))
 (15 15 (:TYPE-PRESCRIPTION SYMBOL-LISTP))
 (9 3 (:DEFINITION NFIX))
 (3 3 (:TYPE-PRESCRIPTION NFIX))
 (3 3 (:REWRITE-QUOTED-CONSTANT PSEUDO-TERM-LIST-FIX-UNDER-PSEUDO-TERM-LIST-EQUIV))
 )
(CMR::TERM-UNIFY-STRICT
 (28 4 (:DEFINITION EQ))
 (8 4 (:REWRITE DEFAULT-<-2))
 (8 4 (:REWRITE DEFAULT-<-1))
 (4 4 (:REWRITE DEFAULT-CAR))
 (4 1 (:REWRITE CMR::PSEUDO-TERM-SUBST-FIX-WHEN-PSEUDO-TERM-SUBST-P))
 (3 3 (:REWRITE SUBSETP-MEMBER . 4))
 (3 3 (:REWRITE SUBSETP-MEMBER . 3))
 (3 3 (:REWRITE SUBSETP-MEMBER . 2))
 (3 3 (:REWRITE SUBSETP-MEMBER . 1))
 (3 3 (:REWRITE INTERSECTP-MEMBER . 3))
 (3 3 (:REWRITE INTERSECTP-MEMBER . 2))
 (2 2 (:REWRITE DEFAULT-CDR))
 (1 1 (:REWRITE CMR::PSEUDO-TERM-SUBST-P-WHEN-NOT-CONSP))
 )
(CMR::TERM-UNIFY-STRICT-FLAG
 (28 4 (:DEFINITION EQ))
 (8 4 (:REWRITE DEFAULT-<-2))
 (8 4 (:REWRITE DEFAULT-<-1))
 (4 4 (:REWRITE DEFAULT-CAR))
 (4 1 (:REWRITE CMR::PSEUDO-TERM-SUBST-FIX-WHEN-PSEUDO-TERM-SUBST-P))
 (3 3 (:REWRITE SUBSETP-MEMBER . 4))
 (3 3 (:REWRITE SUBSETP-MEMBER . 3))
 (3 3 (:REWRITE SUBSETP-MEMBER . 2))
 (3 3 (:REWRITE SUBSETP-MEMBER . 1))
 (3 3 (:REWRITE INTERSECTP-MEMBER . 3))
 (3 3 (:REWRITE INTERSECTP-MEMBER . 2))
 (2 2 (:REWRITE DEFAULT-CDR))
 (1 1 (:REWRITE CMR::PSEUDO-TERM-SUBST-P-WHEN-NOT-CONSP))
 )
(FLAG::FLAG-EQUIV-LEMMA)
(CMR::TERM-UNIFY-STRICT-FLAG-EQUIVALENCES)
(CMR::FLAG-LEMMA-FOR-RETURN-TYPE-OF-TERM-UNIFY-STRICT.NEW-ALIST
 (294 42 (:DEFINITION EQ))
 (229 42 (:REWRITE PSEUDO-TERM-FIX-WHEN-PSEUDO-TERMP))
 (192 48 (:REWRITE CMR::PSEUDO-TERM-SUBST-FIX-WHEN-PSEUDO-TERM-SUBST-P))
 (170 169 (:REWRITE DEFAULT-CAR))
 (140 140 (:REWRITE CMR::PSEUDO-TERM-SUBST-P-WHEN-NOT-CONSP))
 (100 95 (:REWRITE DEFAULT-CDR))
 (82 82 (:TYPE-PRESCRIPTION PSEUDO-TERMP))
 (64 16 (:REWRITE CMR::PSEUDO-TERMP-OF-CDR-OF-HONS-ASSOC-EQUAL-WHEN-PSEUDO-TERM-SUBST-P))
 (41 41 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (12 12 (:REWRITE SUBSETP-MEMBER . 4))
 (12 12 (:REWRITE SUBSETP-MEMBER . 3))
 (12 12 (:REWRITE SUBSETP-MEMBER . 2))
 (12 12 (:REWRITE SUBSETP-MEMBER . 1))
 (12 12 (:REWRITE INTERSECTP-MEMBER . 3))
 (12 12 (:REWRITE INTERSECTP-MEMBER . 2))
 )
(CMR::RETURN-TYPE-OF-TERM-UNIFY-STRICT.NEW-ALIST)
(CMR::RETURN-TYPE-OF-TERMLIST-UNIFY-STRICT.NEW-ALIST)
(CMR::TERM-UNIFY-STRICT
 (110 1 (:DEFINITION CMR::TERM-UNIFY-STRICT))
 (76 12 (:REWRITE CMR::PSEUDO-TERM-LIST-P-WHEN-PSEUDO-VAR-LIST-P))
 (64 2 (:DEFINITION PSEUDO-TERM-LISTP))
 (40 4 (:REWRITE PSEUDO-TERM-CALL->FN-WHEN-LAMBDA))
 (40 4 (:REWRITE PSEUDO-TERM-CALL->FN-WHEN-FNCALL))
 (24 24 (:REWRITE SUBSETP-MEMBER . 4))
 (24 24 (:REWRITE SUBSETP-MEMBER . 3))
 (24 24 (:REWRITE SUBSETP-MEMBER . 2))
 (24 24 (:REWRITE SUBSETP-MEMBER . 1))
 (24 24 (:REWRITE INTERSECTP-MEMBER . 3))
 (24 24 (:REWRITE INTERSECTP-MEMBER . 2))
 (22 16 (:REWRITE CMR::PSEUDO-VAR-LIST-P-WHEN-NOT-CONSP))
 (20 2 (:DEFINITION HONS-ASSOC-EQUAL))
 (17 17 (:REWRITE DEFAULT-CAR))
 (16 16 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (16 4 (:REWRITE CMR::PSEUDO-VAR-LIST-P-OF-CDR-WHEN-PSEUDO-VAR-LIST-P))
 (12 12 (:REWRITE DEFAULT-CDR))
 (9 3 (:DEFINITION ALISTP))
 (8 8 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (6 6 (:REWRITE CMR::PSEUDO-TERM-SUBST-P-WHEN-NOT-CONSP))
 (4 2 (:DEFINITION HONS-EQUAL))
 )
(CMR::FLAG-LEMMA-FOR-TERM-UNIFY-STRICT-OF-PSEUDO-TERM-FIX-PAT
 (4926 180 (:DEFINITION PSEUDO-TERM-LISTP))
 (2720 348 (:REWRITE CMR::PSEUDO-TERM-LIST-P-WHEN-PSEUDO-VAR-LIST-P))
 (2528 260 (:REWRITE PSEUDO-TERMP-CAR-WHEN-PSEUDO-TERM-LISTP))
 (1918 238 (:REWRITE PSEUDO-TERM-LISTP-CDR-WHEN-PSEUDO-TERM-LISTP))
 (1740 1308 (:REWRITE DEFAULT-CAR))
 (1504 1058 (:REWRITE DEFAULT-CDR))
 (1322 312 (:REWRITE CMR::PSEUDO-VAR-LIST-P-OF-CDR-WHEN-PSEUDO-VAR-LIST-P))
 (770 110 (:DEFINITION EQ))
 (682 654 (:REWRITE CMR::PSEUDO-VAR-LIST-P-WHEN-NOT-CONSP))
 (455 455 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (344 344 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (229 229 (:REWRITE CMR::PSEUDO-TERM-SUBST-P-WHEN-NOT-CONSP))
 (152 38 (:REWRITE CMR::PSEUDO-TERMP-OF-CDR-OF-HONS-ASSOC-EQUAL-WHEN-PSEUDO-TERM-SUBST-P))
 (27 27 (:REWRITE SUBSETP-MEMBER . 4))
 (27 27 (:REWRITE SUBSETP-MEMBER . 3))
 (27 27 (:REWRITE SUBSETP-MEMBER . 2))
 (27 27 (:REWRITE SUBSETP-MEMBER . 1))
 (27 27 (:REWRITE INTERSECTP-MEMBER . 3))
 (27 27 (:REWRITE INTERSECTP-MEMBER . 2))
 (24 24 (:TYPE-PRESCRIPTION PSEUDO-TERM-CALL->ARGS))
 )
(CMR::TERM-UNIFY-STRICT-OF-PSEUDO-TERM-FIX-PAT)
(CMR::TERM-UNIFY-STRICT-OF-PSEUDO-TERM-FIX-X)
(CMR::TERM-UNIFY-STRICT-OF-PSEUDO-TERM-SUBST-FIX-ALIST)
(CMR::TERMLIST-UNIFY-STRICT-OF-PSEUDO-TERM-LIST-FIX-PAT)
(CMR::TERMLIST-UNIFY-STRICT-OF-PSEUDO-TERM-LIST-FIX-X)
(CMR::TERMLIST-UNIFY-STRICT-OF-PSEUDO-TERM-SUBST-FIX-ALIST)
(CMR::TERM-UNIFY-STRICT-PSEUDO-TERM-EQUIV-CONGRUENCE-ON-PAT)
(CMR::TERM-UNIFY-STRICT-PSEUDO-TERM-EQUIV-CONGRUENCE-ON-X)
(CMR::TERM-UNIFY-STRICT-PSEUDO-TERM-SUBST-EQUIV-CONGRUENCE-ON-ALIST)
(CMR::TERMLIST-UNIFY-STRICT-PSEUDO-TERM-LIST-EQUIV-CONGRUENCE-ON-PAT)
(CMR::TERMLIST-UNIFY-STRICT-PSEUDO-TERM-LIST-EQUIV-CONGRUENCE-ON-X)
(CMR::TERMLIST-UNIFY-STRICT-PSEUDO-TERM-SUBST-EQUIV-CONGRUENCE-ON-ALIST)
(CMR::TERM-UNIFY-STRICT-OK)
(CMR::TERM-UNIFY-STRICT-OK-WHEN-OK)
(CMR::TERMLIST-UNIFY-STRICT-OK)
(CMR::TERMLIST-UNIFY-STRICT-OK-WHEN-OK)
(CMR::FLAG-LEMMA-FOR-<FN>-PRESERVES-PAIRS
 (1934 106 (:REWRITE PSEUDO-TERM-FIX-WHEN-PSEUDO-TERMP))
 (1274 70 (:REWRITE PSEUDO-TERMP-CAR-WHEN-PSEUDO-TERM-LISTP))
 (1138 35 (:DEFINITION PSEUDO-TERM-LISTP))
 (742 106 (:DEFINITION EQ))
 (564 70 (:REWRITE CMR::PSEUDO-TERM-LIST-P-WHEN-PSEUDO-VAR-LIST-P))
 (539 531 (:REWRITE DEFAULT-CAR))
 (457 429 (:REWRITE DEFAULT-CDR))
 (306 306 (:TYPE-PRESCRIPTION PSEUDO-TERMP))
 (284 67 (:REWRITE CMR::PSEUDO-VAR-LIST-P-OF-CDR-WHEN-PSEUDO-VAR-LIST-P))
 (248 62 (:REWRITE CMR::PSEUDO-TERMP-OF-CDR-OF-HONS-ASSOC-EQUAL-WHEN-PSEUDO-TERM-SUBST-P))
 (229 229 (:TYPE-PRESCRIPTION PSEUDO-TERM-LISTP))
 (158 158 (:REWRITE CMR::PSEUDO-TERM-SUBST-P-WHEN-NOT-CONSP))
 (153 153 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (137 137 (:REWRITE CMR::PSEUDO-VAR-LIST-P-WHEN-NOT-CONSP))
 (102 51 (:REWRITE PSEUDO-TERM-LISTP-CDR-WHEN-PSEUDO-TERM-LISTP))
 (70 70 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (69 69 (:REWRITE SUBSETP-MEMBER . 4))
 (69 69 (:REWRITE SUBSETP-MEMBER . 3))
 (69 69 (:REWRITE SUBSETP-MEMBER . 2))
 (69 69 (:REWRITE SUBSETP-MEMBER . 1))
 (69 69 (:REWRITE INTERSECTP-MEMBER . 3))
 (69 69 (:REWRITE INTERSECTP-MEMBER . 2))
 (60 60 (:TYPE-PRESCRIPTION PSEUDO-TERM-CALL->ARGS))
 (2 2 (:REWRITE CMR::TERM-UNIFY-STRICT-OK-WHEN-OK))
 )
(CMR::TERM-UNIFY-STRICT-PRESERVES-PAIRS)
(CMR::TERMLIST-UNIFY-STRICT-PRESERVES-PAIRS)
(CMR::FLAG-LEMMA-FOR-<FN>-PRESERVES-PAIRS
 (1226 68 (:REWRITE PSEUDO-TERM-FIX-WHEN-PSEUDO-TERMP))
 (830 46 (:REWRITE PSEUDO-TERMP-CAR-WHEN-PSEUDO-TERM-LISTP))
 (736 23 (:DEFINITION PSEUDO-TERM-LISTP))
 (630 90 (:DEFINITION EQ))
 (416 24 (:DEFINITION MEMBER-EQUAL))
 (378 374 (:REWRITE DEFAULT-CAR))
 (366 46 (:REWRITE CMR::PSEUDO-TERM-LIST-P-WHEN-PSEUDO-VAR-LIST-P))
 (332 315 (:REWRITE DEFAULT-CDR))
 (248 8 (:REWRITE CMR::TERM-UNIFY-STRICT-PRESERVES-PAIRS))
 (202 202 (:TYPE-PRESCRIPTION PSEUDO-TERMP))
 (182 43 (:REWRITE CMR::PSEUDO-VAR-LIST-P-OF-CDR-WHEN-PSEUDO-VAR-LIST-P))
 (172 172 (:TYPE-PRESCRIPTION CMR::TRUE-LISTP-OF-TERMLIST-VARS))
 (153 153 (:REWRITE SUBSETP-MEMBER . 4))
 (153 153 (:REWRITE INTERSECTP-MEMBER . 3))
 (153 153 (:REWRITE INTERSECTP-MEMBER . 2))
 (151 151 (:TYPE-PRESCRIPTION PSEUDO-TERM-LISTP))
 (146 146 (:REWRITE SUBSETP-MEMBER . 2))
 (146 146 (:REWRITE SUBSETP-MEMBER . 1))
 (132 132 (:TYPE-PRESCRIPTION CMR::TRUE-LISTP-OF-TERM-VARS))
 (124 31 (:REWRITE CMR::PSEUDO-TERMP-OF-CDR-OF-HONS-ASSOC-EQUAL-WHEN-PSEUDO-TERM-SUBST-P))
 (107 5 (:REWRITE SUBSETP-APPEND1))
 (101 101 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (95 35 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (91 91 (:REWRITE CMR::PSEUDO-TERM-SUBST-P-WHEN-NOT-CONSP))
 (89 89 (:REWRITE CMR::PSEUDO-VAR-LIST-P-WHEN-NOT-CONSP))
 (80 8 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (80 8 (:DEFINITION BINARY-APPEND))
 (71 35 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (69 47 (:REWRITE SUBSETP-TRANS2))
 (66 33 (:REWRITE PSEUDO-TERM-LISTP-CDR-WHEN-PSEUDO-TERM-LISTP))
 (64 16 (:REWRITE APPEND-ATOM-UNDER-LIST-EQUIV))
 (47 47 (:REWRITE SUBSETP-TRANS))
 (46 46 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (40 16 (:REWRITE APPEND-WHEN-NOT-CONSP))
 (10 10 (:TYPE-PRESCRIPTION PSEUDO-VAR-P))
 (2 2 (:REWRITE CMR::TERM-UNIFY-STRICT-OK-WHEN-OK))
 (1 1 (:REWRITE CMR::TERMLIST-UNIFY-STRICT-OK-WHEN-OK))
 )
(CMR::TERM-UNIFY-STRICT-BINDS-PAT-VARS)
(CMR::TERMLIST-UNIFY-STRICT-BINDS-PAT-VARS)
(CMR::NOT-MEMBER-WHEN-SUBSETP-AND-HONS-ASSOC
 (13 3 (:REWRITE SUBSETP-MEMBER . 2))
 (9 9 (:REWRITE DEFAULT-CAR))
 (8 1 (:DEFINITION MEMBER-EQUAL))
 (5 5 (:REWRITE DEFAULT-CDR))
 (4 1 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (4 1 (:REWRITE CMR::PSEUDO-TERM-SUBST-FIX-WHEN-PSEUDO-TERM-SUBST-P))
 (4 1 (:REWRITE MEMBER-WHEN-ATOM))
 (4 1 (:REWRITE ALIST-KEYS-WHEN-ATOM))
 (3 3 (:TYPE-PRESCRIPTION CMR::PSEUDO-TERM-SUBST-FIX$INLINE))
 (3 3 (:REWRITE SUBSETP-MEMBER . 1))
 (2 2 (:TYPE-PRESCRIPTION CMR::PSEUDO-TERM-SUBST-P))
 (2 2 (:REWRITE INTERSECTP-MEMBER . 3))
 (2 2 (:REWRITE INTERSECTP-MEMBER . 2))
 (1 1 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (1 1 (:REWRITE SUBSETP-TRANS2))
 (1 1 (:REWRITE SUBSETP-TRANS))
 (1 1 (:REWRITE SUBSETP-MEMBER . 3))
 (1 1 (:REWRITE CMR::PSEUDO-TERM-SUBST-P-WHEN-NOT-CONSP))
 )
(CMR::ALIST-KEYS-SUBSETP-OF-TERM-UNIFY-STRICT
 (1389 10 (:DEFINITION CMR::TERM-UNIFY-STRICT))
 (310 310 (:TYPE-PRESCRIPTION SYMBOLP-OF-PSEUDO-TERM-KIND))
 (310 310 (:TYPE-PRESCRIPTION PSEUDO-TERM-KIND$INLINE))
 (280 40 (:DEFINITION EQ))
 (250 20 (:REWRITE MEMBER-OF-CONS))
 (240 10 (:REWRITE CMR::ASSOC-IS-HONS-ASSOC))
 (210 10 (:REWRITE PSEUDO-TERM-CALL->FN-OF-PSEUDO-TERM-FIX-X))
 (200 20 (:REWRITE PSEUDO-TERM-CALL->FN-WHEN-LAMBDA))
 (200 20 (:REWRITE PSEUDO-TERM-CALL->FN-WHEN-FNCALL))
 (168 18 (:DEFINITION HONS-ASSOC-EQUAL))
 (153 25 (:REWRITE PSEUDO-TERM-FIX-WHEN-PSEUDO-TERMP))
 (73 73 (:REWRITE DEFAULT-CAR))
 (73 63 (:REWRITE DEFAULT-CDR))
 (56 14 (:REWRITE CMR::PSEUDO-TERMP-OF-CDR-OF-HONS-ASSOC-EQUAL-WHEN-PSEUDO-TERM-SUBST-P))
 (48 48 (:TYPE-PRESCRIPTION PSEUDO-TERMP))
 (47 20 (:REWRITE CMR::PSEUDO-TERM-SUBST-FIX-WHEN-PSEUDO-TERM-SUBST-P))
 (46 46 (:TYPE-PRESCRIPTION CMR::PSEUDO-TERM-SUBST-P))
 (40 40 (:TYPE-PRESCRIPTION PSEUDO-VAR-P-OF-PSEUDO-TERM-VAR->NAME))
 (36 36 (:REWRITE SUBSETP-MEMBER . 2))
 (36 36 (:REWRITE SUBSETP-MEMBER . 1))
 (34 2 (:REWRITE CMR::TERM-UNIFY-STRICT-BINDS-PAT-VARS))
 (32 32 (:REWRITE SUBSETP-MEMBER . 4))
 (32 32 (:REWRITE SUBSETP-MEMBER . 3))
 (32 32 (:REWRITE CMR::NOT-MEMBER-WHEN-SUBSETP-AND-HONS-ASSOC))
 (32 32 (:REWRITE INTERSECTP-MEMBER . 3))
 (32 32 (:REWRITE INTERSECTP-MEMBER . 2))
 (32 14 (:REWRITE ALIST-KEYS-WHEN-ATOM))
 (30 30 (:REWRITE PSEUDO-TERM-KIND$INLINE-OF-PSEUDO-TERM-FIX-X))
 (28 18 (:DEFINITION HONS-EQUAL))
 (24 24 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (24 2 (:DEFINITION MEMBER-EQUAL))
 (23 23 (:REWRITE CMR::PSEUDO-TERM-SUBST-P-WHEN-NOT-CONSP))
 (18 18 (:TYPE-PRESCRIPTION CMR::PSEUDO-TERM-SUBST-FIX$INLINE))
 (18 12 (:REWRITE MEMBER-WHEN-ATOM))
 (10 10 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (10 10 (:REWRITE PSEUDO-TERM-QUOTE->VAL-OF-PSEUDO-TERM-FIX-X))
 (10 10 (:REWRITE PSEUDO-TERM-CALL->ARGS-OF-PSEUDO-TERM-FIX-X))
 (8 8 (:TYPE-PRESCRIPTION CMR::TRUE-LISTP-OF-TERM-VARS))
 (4 1 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (4 1 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (2 2 (:REWRITE CMR::TERM-UNIFY-STRICT-OK-WHEN-OK))
 (2 2 (:REWRITE SUBSETP-TRANS2))
 (2 2 (:REWRITE SUBSETP-TRANS))
 )
(CMR::ALIST-KEYS-SUBSETP-OF-TERMLIST-UNIFY-STRICT
 (69 10 (:DEFINITION CMR::TERMLIST-UNIFY-STRICT))
 (68 8 (:DEFINITION HONS-ASSOC-EQUAL))
 (53 53 (:REWRITE DEFAULT-CAR))
 (47 20 (:REWRITE CMR::PSEUDO-TERM-SUBST-FIX-WHEN-PSEUDO-TERM-SUBST-P))
 (43 43 (:REWRITE DEFAULT-CDR))
 (36 2 (:REWRITE CMR::TERMLIST-UNIFY-STRICT-BINDS-PAT-VARS))
 (33 5 (:REWRITE PSEUDO-TERM-FIX-WHEN-PSEUDO-TERMP))
 (32 14 (:REWRITE ALIST-KEYS-WHEN-ATOM))
 (26 26 (:TYPE-PRESCRIPTION CMR::PSEUDO-TERM-SUBST-P))
 (24 2 (:DEFINITION MEMBER-EQUAL))
 (18 18 (:TYPE-PRESCRIPTION CMR::PSEUDO-TERM-SUBST-FIX$INLINE))
 (16 4 (:REWRITE CMR::PSEUDO-TERMP-OF-CDR-OF-HONS-ASSOC-EQUAL-WHEN-PSEUDO-TERM-SUBST-P))
 (13 13 (:REWRITE CMR::PSEUDO-TERM-SUBST-P-WHEN-NOT-CONSP))
 (10 10 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (8 8 (:TYPE-PRESCRIPTION CMR::TRUE-LISTP-OF-TERMLIST-VARS))
 (8 8 (:TYPE-PRESCRIPTION PSEUDO-TERMP))
 (8 8 (:DEFINITION HONS-EQUAL))
 (8 2 (:REWRITE MEMBER-WHEN-ATOM))
 (6 6 (:REWRITE SUBSETP-MEMBER . 2))
 (6 6 (:REWRITE SUBSETP-MEMBER . 1))
 (4 4 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (4 1 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (4 1 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (2 2 (:REWRITE CMR::TERMLIST-VARS-OF-ATOM))
 (2 2 (:REWRITE CMR::TERMLIST-UNIFY-STRICT-OK-WHEN-OK))
 (2 2 (:REWRITE SUBSETP-TRANS2))
 (2 2 (:REWRITE SUBSETP-TRANS))
 (2 2 (:REWRITE SUBSETP-MEMBER . 4))
 (2 2 (:REWRITE SUBSETP-MEMBER . 3))
 (2 2 (:REWRITE CMR::NOT-MEMBER-WHEN-SUBSETP-AND-HONS-ASSOC))
 (2 2 (:REWRITE INTERSECTP-MEMBER . 3))
 (2 2 (:REWRITE INTERSECTP-MEMBER . 2))
 )
(CMR::TERM-VARS-SUBSETP-OF-TERM-UNIFY-STRICT
 (987 7 (:DEFINITION CMR::TERM-UNIFY-STRICT))
 (217 217 (:TYPE-PRESCRIPTION SYMBOLP-OF-PSEUDO-TERM-KIND))
 (217 217 (:TYPE-PRESCRIPTION PSEUDO-TERM-KIND$INLINE))
 (196 28 (:DEFINITION EQ))
 (189 8 (:REWRITE CMR::HONS-ASSOC-EQUAL-OF-PSEUDO-TERM-SUBST-FIX))
 (175 14 (:REWRITE MEMBER-OF-CONS))
 (168 7 (:REWRITE CMR::ASSOC-IS-HONS-ASSOC))
 (147 7 (:REWRITE PSEUDO-TERM-CALL->FN-OF-PSEUDO-TERM-FIX-X))
 (140 14 (:REWRITE PSEUDO-TERM-CALL->FN-WHEN-LAMBDA))
 (140 14 (:REWRITE PSEUDO-TERM-CALL->FN-WHEN-FNCALL))
 (98 10 (:DEFINITION HONS-ASSOC-EQUAL))
 (92 15 (:REWRITE PSEUDO-TERM-FIX-WHEN-PSEUDO-TERMP))
 (65 26 (:REWRITE CMR::NOT-MEMBER-WHEN-SUBSETP-AND-HONS-ASSOC))
 (60 3 (:DEFINITION MEMBER-EQUAL))
 (45 38 (:REWRITE DEFAULT-CDR))
 (43 43 (:TYPE-PRESCRIPTION PSEUDO-TERM-FIX$INLINE))
 (42 42 (:REWRITE DEFAULT-CAR))
 (41 1 (:REWRITE CMR::TERM-UNIFY-STRICT-PRESERVES-PAIRS))
 (38 10 (:REWRITE CMR::PSEUDO-TERM-SUBST-FIX-WHEN-PSEUDO-TERM-SUBST-P))
 (34 34 (:TYPE-PRESCRIPTION CMR::PSEUDO-TERM-SUBST-P))
 (32 8 (:REWRITE CMR::PSEUDO-TERMP-OF-CDR-OF-HONS-ASSOC-EQUAL-WHEN-PSEUDO-TERM-SUBST-P))
 (30 30 (:TYPE-PRESCRIPTION PSEUDO-TERMP))
 (28 28 (:TYPE-PRESCRIPTION PSEUDO-VAR-P-OF-PSEUDO-TERM-VAR->NAME))
 (28 28 (:REWRITE SUBSETP-MEMBER . 2))
 (28 28 (:REWRITE SUBSETP-MEMBER . 1))
 (26 26 (:REWRITE SUBSETP-MEMBER . 4))
 (26 26 (:REWRITE SUBSETP-MEMBER . 3))
 (26 26 (:REWRITE INTERSECTP-MEMBER . 3))
 (26 26 (:REWRITE INTERSECTP-MEMBER . 2))
 (21 21 (:REWRITE PSEUDO-TERM-KIND$INLINE-OF-PSEUDO-TERM-FIX-X))
 (21 12 (:REWRITE MEMBER-WHEN-ATOM))
 (17 10 (:DEFINITION HONS-EQUAL))
 (16 16 (:REWRITE CMR::PSEUDO-TERM-SUBST-P-WHEN-NOT-CONSP))
 (15 15 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (13 4 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (11 1 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (10 4 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (7 7 (:REWRITE PSEUDO-TERM-QUOTE->VAL-OF-PSEUDO-TERM-FIX-X))
 (7 7 (:REWRITE PSEUDO-TERM-CALL->ARGS-OF-PSEUDO-TERM-FIX-X))
 (6 6 (:REWRITE ALIST-KEYS-WHEN-ATOM))
 (5 5 (:REWRITE SUBSETP-TRANS2))
 (5 5 (:REWRITE SUBSETP-TRANS))
 (2 2 (:REWRITE CMR::TERM-UNIFY-STRICT-OK-WHEN-OK))
 (2 2 (:REWRITE CMR::RETURN-TYPE-OF-TERM-UNIFY-STRICT.NEW-ALIST))
 (1 1 (:TYPE-PRESCRIPTION PSEUDO-VAR-P))
 )
(CMR::TERMLIST-VARS-SUBSETP-OF-TERMLIST-UNIFY-STRICT
 (63 7 (:DEFINITION CMR::TERMLIST-UNIFY-STRICT))
 (60 3 (:DEFINITION MEMBER-EQUAL))
 (44 5 (:REWRITE CMR::NOT-MEMBER-WHEN-SUBSETP-AND-HONS-ASSOC))
 (41 1 (:REWRITE CMR::TERMLIST-UNIFY-STRICT-PRESERVES-PAIRS))
 (38 10 (:REWRITE CMR::PSEUDO-TERM-SUBST-FIX-WHEN-PSEUDO-TERM-SUBST-P))
 (35 1 (:REWRITE CMR::HONS-ASSOC-EQUAL-OF-PSEUDO-TERM-SUBST-FIX))
 (28 28 (:REWRITE DEFAULT-CAR))
 (28 3 (:DEFINITION HONS-ASSOC-EQUAL))
 (24 24 (:REWRITE DEFAULT-CDR))
 (20 20 (:TYPE-PRESCRIPTION CMR::PSEUDO-TERM-SUBST-P))
 (14 5 (:REWRITE MEMBER-WHEN-ATOM))
 (13 4 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (11 1 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (10 4 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (9 9 (:REWRITE CMR::PSEUDO-TERM-SUBST-P-WHEN-NOT-CONSP))
 (8 1 (:REWRITE PSEUDO-TERM-FIX-WHEN-PSEUDO-TERMP))
 (7 7 (:REWRITE SUBSETP-MEMBER . 2))
 (7 7 (:REWRITE SUBSETP-MEMBER . 1))
 (6 6 (:REWRITE CMR::TERMLIST-VARS-OF-ATOM))
 (6 6 (:REWRITE ALIST-KEYS-WHEN-ATOM))
 (5 5 (:REWRITE SUBSETP-TRANS2))
 (5 5 (:REWRITE SUBSETP-TRANS))
 (5 5 (:REWRITE SUBSETP-MEMBER . 4))
 (5 5 (:REWRITE SUBSETP-MEMBER . 3))
 (5 5 (:REWRITE INTERSECTP-MEMBER . 3))
 (5 5 (:REWRITE INTERSECTP-MEMBER . 2))
 (4 1 (:REWRITE CMR::PSEUDO-TERMP-OF-CDR-OF-HONS-ASSOC-EQUAL-WHEN-PSEUDO-TERM-SUBST-P))
 (3 3 (:DEFINITION HONS-EQUAL))
 (2 2 (:TYPE-PRESCRIPTION PSEUDO-TERMP))
 (2 2 (:REWRITE CMR::TERMLIST-UNIFY-STRICT-OK-WHEN-OK))
 (2 2 (:REWRITE CMR::RETURN-TYPE-OF-TERMLIST-UNIFY-STRICT.NEW-ALIST))
 (1 1 (:TYPE-PRESCRIPTION PSEUDO-VAR-P))
 (1 1 (:TYPE-PRESCRIPTION PSEUDO-TERM-FIX$INLINE))
 (1 1 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 )
(CMR::FLAG-LEMMA-FOR-<FN>-PRESERVES-TERM-SUBST-STRICT
 (1406 57 (:REWRITE PSEUDO-TERM-FIX-WHEN-PSEUDO-TERMP))
 (1082 60 (:REWRITE PSEUDO-TERMP-CAR-WHEN-PSEUDO-TERM-LISTP))
 (959 30 (:DEFINITION PSEUDO-TERM-LISTP))
 (630 90 (:DEFINITION EQ))
 (477 60 (:REWRITE CMR::PSEUDO-TERM-LIST-P-WHEN-PSEUDO-VAR-LIST-P))
 (237 56 (:REWRITE CMR::PSEUDO-VAR-LIST-P-OF-CDR-WHEN-PSEUDO-VAR-LIST-P))
 (224 203 (:REWRITE DEFAULT-CDR))
 (221 221 (:REWRITE DEFAULT-CAR))
 (200 200 (:TYPE-PRESCRIPTION PSEUDO-TERMP))
 (197 197 (:TYPE-PRESCRIPTION PSEUDO-TERM-LISTP))
 (116 116 (:REWRITE CMR::PSEUDO-VAR-LIST-P-WHEN-NOT-CONSP))
 (116 29 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (116 29 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (111 30 (:REWRITE ALIST-KEYS-WHEN-ATOM))
 (100 100 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (96 24 (:REWRITE CMR::PSEUDO-TERMP-OF-CDR-OF-HONS-ASSOC-EQUAL-WHEN-PSEUDO-TERM-SUBST-P))
 (94 94 (:REWRITE CMR::PSEUDO-TERM-SUBST-P-WHEN-NOT-CONSP))
 (87 87 (:TYPE-PRESCRIPTION CMR::TRUE-LISTP-OF-TERM-VARS))
 (87 87 (:TYPE-PRESCRIPTION TRUE-LISTP-OF-ALIST-KEYS))
 (86 43 (:REWRITE PSEUDO-TERM-LISTP-CDR-WHEN-PSEUDO-TERM-LISTP))
 (63 63 (:REWRITE SUBSETP-MEMBER . 4))
 (63 63 (:REWRITE SUBSETP-MEMBER . 3))
 (63 63 (:REWRITE SUBSETP-MEMBER . 2))
 (63 63 (:REWRITE SUBSETP-MEMBER . 1))
 (63 63 (:REWRITE INTERSECTP-MEMBER . 3))
 (63 63 (:REWRITE INTERSECTP-MEMBER . 2))
 (60 60 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (36 36 (:TYPE-PRESCRIPTION PSEUDO-TERM-CALL->ARGS))
 (30 30 (:REWRITE SUBSETP-TRANS2))
 (3 3 (:REWRITE CMR::TERM-UNIFY-STRICT-OK-WHEN-OK))
 )
(CMR::TERM-UNIFY-STRICT-PRESERVES-TERM-SUBST-STRICT)
(CMR::TERMLIST-UNIFY-STRICT-PRESERVES-TERM-SUBST-STRICT)
(CMR::FLAG-LEMMA-FOR-<FN>-PRESERVES-TERMLIST-SUBST-STRICT
 (1406 57 (:REWRITE PSEUDO-TERM-FIX-WHEN-PSEUDO-TERMP))
 (1082 60 (:REWRITE PSEUDO-TERMP-CAR-WHEN-PSEUDO-TERM-LISTP))
 (959 30 (:DEFINITION PSEUDO-TERM-LISTP))
 (630 90 (:DEFINITION EQ))
 (477 60 (:REWRITE CMR::PSEUDO-TERM-LIST-P-WHEN-PSEUDO-VAR-LIST-P))
 (237 56 (:REWRITE CMR::PSEUDO-VAR-LIST-P-OF-CDR-WHEN-PSEUDO-VAR-LIST-P))
 (224 203 (:REWRITE DEFAULT-CDR))
 (221 221 (:REWRITE DEFAULT-CAR))
 (200 200 (:TYPE-PRESCRIPTION PSEUDO-TERMP))
 (197 197 (:TYPE-PRESCRIPTION PSEUDO-TERM-LISTP))
 (116 116 (:REWRITE CMR::PSEUDO-VAR-LIST-P-WHEN-NOT-CONSP))
 (116 29 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (116 29 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (111 30 (:REWRITE ALIST-KEYS-WHEN-ATOM))
 (100 100 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (96 24 (:REWRITE CMR::PSEUDO-TERMP-OF-CDR-OF-HONS-ASSOC-EQUAL-WHEN-PSEUDO-TERM-SUBST-P))
 (94 94 (:REWRITE CMR::PSEUDO-TERM-SUBST-P-WHEN-NOT-CONSP))
 (87 87 (:TYPE-PRESCRIPTION CMR::TRUE-LISTP-OF-TERMLIST-VARS))
 (87 87 (:TYPE-PRESCRIPTION TRUE-LISTP-OF-ALIST-KEYS))
 (86 43 (:REWRITE PSEUDO-TERM-LISTP-CDR-WHEN-PSEUDO-TERM-LISTP))
 (63 63 (:REWRITE SUBSETP-MEMBER . 4))
 (63 63 (:REWRITE SUBSETP-MEMBER . 3))
 (63 63 (:REWRITE SUBSETP-MEMBER . 2))
 (63 63 (:REWRITE SUBSETP-MEMBER . 1))
 (63 63 (:REWRITE INTERSECTP-MEMBER . 3))
 (63 63 (:REWRITE INTERSECTP-MEMBER . 2))
 (60 60 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (36 36 (:TYPE-PRESCRIPTION PSEUDO-TERM-CALL->ARGS))
 (31 31 (:REWRITE CMR::TERMLIST-VARS-OF-ATOM))
 (30 30 (:REWRITE SUBSETP-TRANS2))
 (3 3 (:REWRITE CMR::TERM-UNIFY-STRICT-OK-WHEN-OK))
 )
(CMR::TERM-UNIFY-STRICT-PRESERVES-TERMLIST-SUBST-STRICT)
(CMR::TERMLIST-UNIFY-STRICT-PRESERVES-TERMLIST-SUBST-STRICT)
(CMR::PSEUDO-TERM-FIX-WHEN-PSEUDO-TERM-QUOTE
 (5 2 (:REWRITE PSEUDO-TERM-FIX-WHEN-PSEUDO-TERMP))
 (2 2 (:TYPE-PRESCRIPTION PSEUDO-TERMP))
 (1 1 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 )
(CMR::FLAG-LEMMA-FOR-<FN>-REVERSIBLE
 (2592 84 (:DEFINITION PSEUDO-TERM-LISTP))
 (1934 142 (:REWRITE PSEUDO-TERMP-CAR-WHEN-PSEUDO-TERM-LISTP))
 (1477 211 (:DEFINITION EQ))
 (1356 166 (:REWRITE CMR::PSEUDO-TERM-LIST-P-WHEN-PSEUDO-VAR-LIST-P))
 (698 164 (:REWRITE CMR::PSEUDO-VAR-LIST-P-OF-CDR-WHEN-PSEUDO-VAR-LIST-P))
 (691 122 (:REWRITE PSEUDO-TERM-LISTP-CDR-WHEN-PSEUDO-TERM-LISTP))
 (409 20 (:REWRITE CMR::TERMLIST-UNIFY-STRICT-PRESERVES-TERMLIST-SUBST-STRICT))
 (407 381 (:REWRITE DEFAULT-CDR))
 (379 375 (:REWRITE DEFAULT-CAR))
 (334 324 (:REWRITE CMR::PSEUDO-VAR-LIST-P-WHEN-NOT-CONSP))
 (208 208 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (164 164 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (124 80 (:REWRITE CMR::NOT-MEMBER-WHEN-SUBSETP-AND-HONS-ASSOC))
 (119 119 (:REWRITE CMR::PSEUDO-TERM-SUBST-P-WHEN-NOT-CONSP))
 (114 30 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (112 28 (:REWRITE CMR::PSEUDO-TERMP-OF-CDR-OF-HONS-ASSOC-EQUAL-WHEN-PSEUDO-TERM-SUBST-P))
 (108 30 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (105 5 (:REWRITE CMR::TERM-UNIFY-STRICT-PRESERVES-TERM-SUBST-STRICT))
 (93 30 (:REWRITE ALIST-KEYS-WHEN-ATOM))
 (80 80 (:REWRITE SUBSETP-MEMBER . 4))
 (80 80 (:REWRITE SUBSETP-MEMBER . 3))
 (80 80 (:REWRITE SUBSETP-MEMBER . 2))
 (80 80 (:REWRITE SUBSETP-MEMBER . 1))
 (80 80 (:REWRITE INTERSECTP-MEMBER . 3))
 (80 80 (:REWRITE INTERSECTP-MEMBER . 2))
 (78 78 (:TYPE-PRESCRIPTION TRUE-LISTP-OF-ALIST-KEYS))
 (78 1 (:REWRITE CMR::ACONS-NON-VAR-PRESERVES-TERM-SUBST-STRICT))
 (60 60 (:TYPE-PRESCRIPTION CMR::TRUE-LISTP-OF-TERMLIST-VARS))
 (44 1 (:DEFINITION MEMBER-EQUAL))
 (34 20 (:REWRITE CMR::TERMLIST-VARS-OF-ATOM))
 (31 31 (:TYPE-PRESCRIPTION CMR::TRUE-LISTP-OF-TERM-VARS))
 (30 30 (:REWRITE SUBSETP-TRANS2))
 (30 30 (:REWRITE SUBSETP-TRANS))
 (20 20 (:REWRITE PSEUDO-TERM-QUOTE->VAL-OF-PSEUDO-TERM-FIX-X))
 (13 13 (:REWRITE CMR::TERMLIST-UNIFY-STRICT-OK-WHEN-OK))
 (10 1 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (5 5 (:REWRITE CMR::TERM-UNIFY-STRICT-OK-WHEN-OK))
 )
(CMR::TERM-UNIFY-STRICT-REVERSIBLE)
(CMR::TERMLIST-UNIFY-STRICT-REVERSIBLE)
(CMR::NOT-EQUAL-BY-LEN)
(CMR::FLAG-LEMMA-FOR-<FN>-REVERSIBLE-IFF
 (4650 159 (:DEFINITION PSEUDO-TERM-LISTP))
 (3215 263 (:REWRITE PSEUDO-TERMP-CAR-WHEN-PSEUDO-TERM-LISTP))
 (2467 321 (:REWRITE CMR::PSEUDO-TERM-LIST-P-WHEN-PSEUDO-VAR-LIST-P))
 (1399 1272 (:REWRITE DEFAULT-CDR))
 (1248 221 (:REWRITE PSEUDO-TERM-LISTP-CDR-WHEN-PSEUDO-TERM-LISTP))
 (1219 288 (:REWRITE CMR::PSEUDO-VAR-LIST-P-OF-CDR-WHEN-PSEUDO-VAR-LIST-P))
 (1198 603 (:REWRITE DEFAULT-+-2))
 (716 678 (:REWRITE DEFAULT-CAR))
 (608 585 (:REWRITE CMR::PSEUDO-VAR-LIST-P-WHEN-NOT-CONSP))
 (603 603 (:REWRITE DEFAULT-+-1))
 (548 30 (:REWRITE CMR::TERMLIST-UNIFY-STRICT-PRESERVES-TERMLIST-SUBST-STRICT))
 (352 352 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (313 313 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (296 8 (:DEFINITION TAKE))
 (229 185 (:REWRITE CMR::NOT-MEMBER-WHEN-SUBSETP-AND-HONS-ASSOC))
 (220 55 (:REWRITE CMR::PSEUDO-TERMP-OF-CDR-OF-HONS-ASSOC-EQUAL-WHEN-PSEUDO-TERM-SUBST-P))
 (190 49 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (185 185 (:REWRITE SUBSETP-MEMBER . 4))
 (185 185 (:REWRITE SUBSETP-MEMBER . 3))
 (185 185 (:REWRITE SUBSETP-MEMBER . 2))
 (185 185 (:REWRITE SUBSETP-MEMBER . 1))
 (185 185 (:REWRITE INTERSECTP-MEMBER . 3))
 (185 185 (:REWRITE INTERSECTP-MEMBER . 2))
 (173 173 (:REWRITE CMR::PSEUDO-TERM-SUBST-P-WHEN-NOT-CONSP))
 (169 49 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (159 8 (:REWRITE CMR::TERM-UNIFY-STRICT-PRESERVES-TERM-SUBST-STRICT))
 (141 51 (:REWRITE ALIST-KEYS-WHEN-ATOM))
 (120 120 (:TYPE-PRESCRIPTION TRUE-LISTP-OF-ALIST-KEYS))
 (97 1 (:REWRITE CMR::ACONS-NON-VAR-PRESERVES-TERM-SUBST-STRICT))
 (96 96 (:TYPE-PRESCRIPTION CMR::TRUE-LISTP-OF-TERMLIST-VARS))
 (74 8 (:REWRITE CMR::TERM-UNIFY-STRICT-PRESERVES-TERMLIST-SUBST-STRICT))
 (64 8 (:REWRITE ZP-OPEN))
 (63 1 (:DEFINITION MEMBER-EQUAL))
 (56 8 (:REWRITE LEN-OF-TAKE))
 (52 52 (:TYPE-PRESCRIPTION CMR::TRUE-LISTP-OF-TERM-VARS))
 (49 49 (:REWRITE SUBSETP-TRANS2))
 (49 49 (:REWRITE SUBSETP-TRANS))
 (48 32 (:REWRITE CMR::TERMLIST-VARS-OF-ATOM))
 (48 8 (:DEFINITION NFIX))
 (46 46 (:REWRITE PSEUDO-TERM-QUOTE->VAL-OF-PSEUDO-TERM-FIX-X))
 (24 16 (:REWRITE DEFAULT-<-2))
 (24 16 (:REWRITE DEFAULT-<-1))
 (21 21 (:REWRITE CMR::TERMLIST-UNIFY-STRICT-OK-WHEN-OK))
 (14 14 (:REWRITE CMR::TERM-UNIFY-STRICT-OK-WHEN-OK))
 (10 1 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 )
(CMR::TERM-UNIFY-STRICT-REVERSIBLE-IFF)
(CMR::TERMLIST-UNIFY-STRICT-REVERSIBLE-IFF)
(CMR::TERM-UNIFY-STRICT-REVERSIBLE-IFF-RW
 (2844 9 (:DEFINITION CMR::TERM-UNIFY-STRICT))
 (1287 141 (:REWRITE CMR::NOT-EQUAL-BY-LEN))
 (622 622 (:TYPE-PRESCRIPTION LEN))
 (600 148 (:DEFINITION LEN))
 (558 9 (:REWRITE CMR::ASSOC-IS-HONS-ASSOC))
 (540 9 (:REWRITE CMR::HONS-ASSOC-EQUAL-OF-PSEUDO-TERM-SUBST-FIX))
 (534 534 (:TYPE-PRESCRIPTION SYMBOLP-OF-PSEUDO-TERM-KIND))
 (534 534 (:TYPE-PRESCRIPTION PSEUDO-TERM-KIND$INLINE))
 (420 60 (:DEFINITION EQ))
 (333 18 (:REWRITE MEMBER-OF-CONS))
 (261 9 (:DEFINITION HONS-ASSOC-EQUAL))
 (240 24 (:REWRITE CMR::PSEUDO-TERM-FIX-WHEN-PSEUDO-TERM-QUOTE))
 (216 24 (:REWRITE PSEUDO-TERM-FIX-WHEN-PSEUDO-TERM-NULL))
 (189 9 (:REWRITE PSEUDO-TERM-CALL->FN-OF-PSEUDO-TERM-FIX-X))
 (189 9 (:DEFINITION HONS-EQUAL))
 (180 18 (:REWRITE PSEUDO-TERM-CALL->FN-WHEN-LAMBDA))
 (180 18 (:REWRITE PSEUDO-TERM-CALL->FN-WHEN-FNCALL))
 (134 67 (:REWRITE DEFAULT-+-2))
 (132 24 (:REWRITE PSEUDO-TERM-FIX-WHEN-PSEUDO-TERMP))
 (126 6 (:REWRITE CMR::TERM-UNIFY-STRICT-PRESERVES-TERM-SUBST-STRICT))
 (112 103 (:REWRITE DEFAULT-CDR))
 (67 67 (:REWRITE DEFAULT-+-1))
 (60 15 (:REWRITE CMR::PSEUDO-TERM-SUBST-FIX-WHEN-PSEUDO-TERM-SUBST-P))
 (48 48 (:TYPE-PRESCRIPTION PSEUDO-TERMP))
 (48 48 (:TYPE-PRESCRIPTION CMR::PSEUDO-TERM-SUBST-P))
 (45 45 (:TYPE-PRESCRIPTION PSEUDO-VAR-P-OF-PSEUDO-TERM-VAR->NAME))
 (36 36 (:REWRITE DEFAULT-CAR))
 (36 9 (:REWRITE CMR::PSEUDO-TERMP-OF-CDR-OF-HONS-ASSOC-EQUAL-WHEN-PSEUDO-TERM-SUBST-P))
 (27 27 (:REWRITE SUBSETP-MEMBER . 4))
 (27 27 (:REWRITE SUBSETP-MEMBER . 3))
 (27 27 (:REWRITE SUBSETP-MEMBER . 2))
 (27 27 (:REWRITE SUBSETP-MEMBER . 1))
 (27 27 (:REWRITE PSEUDO-TERM-KIND$INLINE-OF-PSEUDO-TERM-FIX-X))
 (27 27 (:REWRITE CMR::NOT-MEMBER-WHEN-SUBSETP-AND-HONS-ASSOC))
 (27 27 (:REWRITE INTERSECTP-MEMBER . 3))
 (27 27 (:REWRITE INTERSECTP-MEMBER . 2))
 (24 24 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (24 24 (:REWRITE CMR::PSEUDO-TERM-SUBST-P-WHEN-NOT-CONSP))
 (24 6 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (24 6 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (24 6 (:REWRITE ALIST-KEYS-WHEN-ATOM))
 (18 18 (:TYPE-PRESCRIPTION CMR::TRUE-LISTP-OF-TERM-VARS))
 (18 18 (:TYPE-PRESCRIPTION TRUE-LISTP-OF-ALIST-KEYS))
 (18 18 (:TYPE-PRESCRIPTION CMR::PSEUDO-TERM-SUBST-FIX$INLINE))
 (18 18 (:TYPE-PRESCRIPTION HONS-ASSOC-EQUAL))
 (12 12 (:TYPE-PRESCRIPTION SUBSETP-EQUAL))
 (9 9 (:REWRITE PSEUDO-TERM-QUOTE->VAL-OF-PSEUDO-TERM-FIX-X))
 (9 9 (:REWRITE PSEUDO-TERM-CALL->ARGS-OF-PSEUDO-TERM-FIX-X))
 (9 9 (:REWRITE MEMBER-WHEN-ATOM))
 (6 6 (:REWRITE SUBSETP-TRANS2))
 (6 6 (:REWRITE SUBSETP-TRANS))
 )
(CMR::TERMLIST-UNIFY-STRICT-REVERSIBLE-IFF-RW
 (180 6 (:REWRITE PSEUDO-TERM-LIST-FIX-WHEN-PSEUDO-TERM-LISTP))
 (132 6 (:REWRITE CMR::TERMLIST-UNIFY-STRICT-PRESERVES-TERMLIST-SUBST-STRICT))
 (132 6 (:DEFINITION PSEUDO-TERM-LISTP))
 (81 9 (:DEFINITION CMR::TERMLIST-UNIFY-STRICT))
 (72 12 (:REWRITE CMR::PSEUDO-TERM-LIST-P-WHEN-PSEUDO-VAR-LIST-P))
 (62 6 (:REWRITE CMR::NOT-EQUAL-BY-LEN))
 (60 15 (:REWRITE CMR::PSEUDO-TERM-SUBST-FIX-WHEN-PSEUDO-TERM-SUBST-P))
 (42 42 (:TYPE-PRESCRIPTION PSEUDO-TERM-LISTP))
 (36 36 (:TYPE-PRESCRIPTION CMR::PSEUDO-VAR-LIST-P))
 (32 32 (:TYPE-PRESCRIPTION LEN))
 (30 30 (:TYPE-PRESCRIPTION CMR::PSEUDO-TERM-SUBST-P))
 (28 28 (:REWRITE DEFAULT-CDR))
 (28 8 (:DEFINITION LEN))
 (24 24 (:REWRITE DEFAULT-CAR))
 (24 6 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (24 6 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (24 6 (:REWRITE CMR::PSEUDO-VAR-LIST-P-OF-CDR-WHEN-PSEUDO-VAR-LIST-P))
 (24 6 (:REWRITE ALIST-KEYS-WHEN-ATOM))
 (18 18 (:TYPE-PRESCRIPTION CMR::TRUE-LISTP-OF-TERMLIST-VARS))
 (18 18 (:TYPE-PRESCRIPTION TRUE-LISTP-OF-ALIST-KEYS))
 (18 18 (:TYPE-PRESCRIPTION CMR::PSEUDO-TERM-SUBST-FIX$INLINE))
 (18 18 (:REWRITE CMR::PSEUDO-VAR-LIST-P-WHEN-NOT-CONSP))
 (15 15 (:REWRITE CMR::PSEUDO-TERM-SUBST-P-WHEN-NOT-CONSP))
 (12 12 (:TYPE-PRESCRIPTION SUBSETP-EQUAL))
 (12 12 (:TYPE-PRESCRIPTION PSEUDO-TERMP))
 (12 12 (:REWRITE TERM-LISTP-IMPLIES-PSEUDO-TERM-LISTP))
 (12 6 (:REWRITE PSEUDO-TERMP-CAR-WHEN-PSEUDO-TERM-LISTP))
 (12 6 (:REWRITE PSEUDO-TERM-LISTP-CDR-WHEN-PSEUDO-TERM-LISTP))
 (12 2 (:REWRITE CMR::LEN-OF-TERMLIST-SUBST-STRICT))
 (12 2 (:REWRITE LEN-OF-PSEUDO-TERM-LIST-FIX))
 (8 4 (:REWRITE DEFAULT-+-2))
 (6 6 (:REWRITE TERMP-IMPLIES-PSEUDO-TERMP))
 (6 6 (:REWRITE CMR::TERMLIST-VARS-OF-ATOM))
 (6 6 (:REWRITE SUBSETP-TRANS2))
 (6 6 (:REWRITE SUBSETP-TRANS))
 (4 4 (:REWRITE DEFAULT-+-1))
 )
