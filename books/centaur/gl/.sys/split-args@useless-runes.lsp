(GL::HIDE-IF
 (1 1 (:TYPE-PRESCRIPTION GL::HIDE-IF))
 )
(GL::GL-ARGS-SPLIT-ITE-COND)
(GL::GL-ARGS-SPLIT-ITE)
(GL::G-ITE-DEPTH
 (134 4 (:DEFINITION ACL2-COUNT))
 (42 20 (:REWRITE DEFAULT-+-2))
 (28 28 (:TYPE-PRESCRIPTION ACL2-COUNT))
 (28 20 (:REWRITE DEFAULT-+-1))
 (20 2 (:DEFINITION LENGTH))
 (16 4 (:REWRITE COMMUTATIVITY-OF-+))
 (16 4 (:DEFINITION INTEGER-ABS))
 (14 2 (:DEFINITION LEN))
 (12 4 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (10 10 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (8 8 (:TYPE-PRESCRIPTION BOOLEANP))
 (6 6 (:REWRITE FOLD-CONSTS-IN-+))
 (6 6 (:REWRITE DEFAULT-CDR))
 (4 4 (:REWRITE GL::TAG-WHEN-ATOM))
 (4 4 (:REWRITE DEFAULT-UNARY-MINUS))
 (4 4 (:REWRITE DEFAULT-CAR))
 (4 4 (:REWRITE DEFAULT-<-2))
 (4 4 (:REWRITE DEFAULT-<-1))
 (2 2 (:TYPE-PRESCRIPTION LEN))
 (2 2 (:REWRITE DEFAULT-REALPART))
 (2 2 (:REWRITE DEFAULT-NUMERATOR))
 (2 2 (:REWRITE DEFAULT-IMAGPART))
 (2 2 (:REWRITE DEFAULT-DENOMINATOR))
 (2 2 (:REWRITE DEFAULT-COERCE-2))
 (2 2 (:REWRITE DEFAULT-COERCE-1))
 )
(GL::POSP-G-ITE-DEPTH
 (45 17 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (41 7 (:REWRITE DEFAULT-+-2))
 (22 22 (:TYPE-PRESCRIPTION BOOLEANP))
 (18 18 (:REWRITE GL::TAG-WHEN-ATOM))
 (14 8 (:REWRITE DEFAULT-<-2))
 (13 8 (:REWRITE DEFAULT-<-1))
 (7 7 (:REWRITE DEFAULT-+-1))
 )
(GL::G-ITE-DEPTH-OF-G-ITE->THEN
 (18 2 (:REWRITE DEFAULT-<-2))
 (15 1 (:REWRITE DEFAULT-+-2))
 (6 2 (:REWRITE DEFAULT-<-1))
 (3 1 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (2 2 (:TYPE-PRESCRIPTION BOOLEANP))
 (2 2 (:REWRITE GL::TAG-WHEN-ATOM))
 (1 1 (:REWRITE DEFAULT-+-1))
 )
(GL::G-ITE-DEPTH-OF-G-ITE->ELSE
 (18 2 (:REWRITE DEFAULT-<-2))
 (15 1 (:REWRITE DEFAULT-+-2))
 (6 2 (:REWRITE DEFAULT-<-1))
 (3 1 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (2 2 (:TYPE-PRESCRIPTION BOOLEANP))
 (2 2 (:REWRITE GL::TAG-WHEN-ATOM))
 (1 1 (:REWRITE DEFAULT-+-1))
 )
(GL::G-ITE-DEPTH-SUM
 (6 6 (:TYPE-PRESCRIPTION GL::POSP-G-ITE-DEPTH))
 )
(GL::G-ITE-DEPTH-OF-G-CONCRETE)
(GL::G-ITE-DEPTH-SUM-OF-GL-ARGS-SPLIT-ITE-COND-0
 (71 24 (:REWRITE DEFAULT-+-1))
 (60 60 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (48 24 (:REWRITE DEFAULT-+-2))
 (48 16 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (46 46 (:REWRITE DEFAULT-CAR))
 (32 32 (:TYPE-PRESCRIPTION BOOLEANP))
 (28 10 (:REWRITE DEFAULT-<-2))
 (27 27 (:REWRITE DEFAULT-CDR))
 (27 10 (:REWRITE DEFAULT-<-1))
 (18 9 (:REWRITE CONSP-OF-CAR-WHEN-ATOM-LISTP))
 (11 11 (:REWRITE GL::TAG-WHEN-ATOM))
 )
(GL::G-ITE-DEPTH-SUM-OF-GL-ARGS-SPLIT-ITE-COND-1
 (71 24 (:REWRITE DEFAULT-+-1))
 (60 60 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (48 24 (:REWRITE DEFAULT-+-2))
 (48 16 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (46 46 (:REWRITE DEFAULT-CAR))
 (32 32 (:TYPE-PRESCRIPTION BOOLEANP))
 (28 10 (:REWRITE DEFAULT-<-2))
 (27 27 (:REWRITE DEFAULT-CDR))
 (27 10 (:REWRITE DEFAULT-<-1))
 (18 9 (:REWRITE CONSP-OF-CAR-WHEN-ATOM-LISTP))
 (11 11 (:REWRITE GL::TAG-WHEN-ATOM))
 )
(GL::G-ITE-DEPTH-SUM-OF-GL-ARGS-SPLIT-ITE-THEN
 (67 23 (:REWRITE DEFAULT-+-1))
 (64 64 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (44 23 (:REWRITE DEFAULT-+-2))
 (43 43 (:REWRITE DEFAULT-CAR))
 (34 34 (:REWRITE DEFAULT-CDR))
 (24 8 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (22 8 (:REWRITE DEFAULT-<-1))
 (20 10 (:REWRITE CONSP-OF-CAR-WHEN-ATOM-LISTP))
 (19 8 (:REWRITE DEFAULT-<-2))
 (16 16 (:TYPE-PRESCRIPTION BOOLEANP))
 (13 13 (:REWRITE GL::TAG-WHEN-ATOM))
 )
(GL::G-ITE-DEPTH-SUM-OF-GL-ARGS-SPLIT-ITE-ELSE
 (67 23 (:REWRITE DEFAULT-+-1))
 (64 64 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (44 23 (:REWRITE DEFAULT-+-2))
 (43 43 (:REWRITE DEFAULT-CAR))
 (34 34 (:REWRITE DEFAULT-CDR))
 (24 8 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (22 8 (:REWRITE DEFAULT-<-1))
 (20 10 (:REWRITE CONSP-OF-CAR-WHEN-ATOM-LISTP))
 (19 8 (:REWRITE DEFAULT-<-2))
 (16 16 (:TYPE-PRESCRIPTION BOOLEANP))
 (13 13 (:REWRITE GL::TAG-WHEN-ATOM))
 )
(GL::GL-ARGS-SPLIT-ITE-COND-CORRECT
 (305 99 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (232 152 (:REWRITE DEFAULT-CAR))
 (224 8 (:DEFINITION GL::BFR-LIST->S))
 (206 206 (:TYPE-PRESCRIPTION BOOLEANP))
 (180 180 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (136 80 (:REWRITE DEFAULT-CDR))
 (136 8 (:DEFINITION HONS-ASSOC-EQUAL))
 (104 104 (:TYPE-PRESCRIPTION KWOTE-LST))
 (96 8 (:DEFINITION LOGCONS$INLINE))
 (72 8 (:REWRITE GL::GENERIC-GEVAL-EV-OF-IF-CALL))
 (69 69 (:REWRITE GL::TAG-WHEN-ATOM))
 (64 8 (:DEFINITION KWOTE-LST))
 (56 8 (:REWRITE GL::GENERIC-GEVAL-EV-OF-CONS-CALL))
 (52 26 (:REWRITE CONSP-OF-CAR-WHEN-ATOM-LISTP))
 (48 24 (:REWRITE GL::BFR-EVAL-BOOLEANP))
 (48 8 (:REWRITE GL::GENERIC-GEVAL-EV-OF-QUOTE))
 (48 8 (:REWRITE GL::GENERIC-GEVAL-EV-OF-LAMBDA))
 (48 8 (:DEFINITION GL::FIRST/REST/END))
 (40 16 (:REWRITE GL::BFR-LIST->S-WHEN-S-ENDP))
 (24 24 (:TYPE-PRESCRIPTION GL::S-ENDP$INLINE))
 (24 24 (:TYPE-PRESCRIPTION HONS-ASSOC-EQUAL))
 (24 24 (:TYPE-PRESCRIPTION GL::BFR-LIST->S))
 (16 16 (:TYPE-PRESCRIPTION BOOL->BIT$INLINE))
 (16 8 (:REWRITE GL::SCDR-WHEN-S-ENDP))
 (16 8 (:REWRITE GL::GENERIC-GEVAL-EV-OF-VARIABLE))
 (16 8 (:REWRITE DEFAULT-+-2))
 (16 8 (:REWRITE DEFAULT-+-1))
 (16 8 (:REWRITE DEFAULT-*-2))
 (16 8 (:REWRITE BFIX-BITP))
 (16 8 (:DEFINITION IFIX))
 (16 8 (:DEFINITION GL::BOOL->SIGN))
 (8 8 (:TYPE-PRESCRIPTION GL::TRUE-LISTP-OF-SCDR))
 (8 8 (:TYPE-PRESCRIPTION BFR-EVAL))
 (8 8 (:REWRITE FN-CHECK-DEF-NOT-QUOTE))
 (8 8 (:REWRITE DEFAULT-*-1))
 (8 8 (:DEFINITION KWOTE))
 )
(GL::GOBJ-LISTP-GL-ARGS-SPLIT-ITE-COND
 (168 28 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (140 14 (:DEFINITION TRUE-LISTP))
 (72 72 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (60 20 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (56 56 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (56 28 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (40 40 (:TYPE-PRESCRIPTION BOOLEANP))
 (28 28 (:TYPE-PRESCRIPTION SET::EMPTYP-TYPE))
 (28 28 (:REWRITE SET::IN-SET))
 (26 26 (:REWRITE DEFAULT-CDR))
 (23 23 (:REWRITE DEFAULT-CAR))
 (22 11 (:REWRITE CONSP-OF-CAR-WHEN-ATOM-LISTP))
 (13 13 (:REWRITE GL::TAG-WHEN-ATOM))
 (11 11 (:TYPE-PRESCRIPTION ATOM-LISTP))
 )
(GL::GOBJ-LIST-DEPENDS-ON-OF-GL-ARGS-SPLIT-ITE-COND
 (1458 14 (:DEFINITION GL::GOBJ-DEPENDS-ON))
 (1387 106 (:REWRITE GL::GOBJ-DEPENDS-ON-CAR-OF-GOBJ))
 (285 95 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (259 259 (:REWRITE GL::GOBJ-DEPENDS-ON-WHEN-G-VAR))
 (259 259 (:REWRITE GL::GOBJ-DEPENDS-ON-WHEN-G-CONCRETE))
 (202 202 (:TYPE-PRESCRIPTION BOOLEANP))
 (170 24 (:REWRITE GL::GOBJ-DEPENDS-ON-CDR-OF-GOBJ))
 (142 142 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (107 107 (:REWRITE DEFAULT-CAR))
 (96 96 (:REWRITE GL::TAG-WHEN-ATOM))
 (96 96 (:REWRITE DEFAULT-CDR))
 (86 12 (:REWRITE GL::GOBJ-LIST-DEPENDS-ON-OF-G-APPLY->ARGS))
 (86 12 (:REWRITE GL::GOBJ-DEPENDS-ON-OF-G-INTEGER->BITS))
 (86 12 (:REWRITE GL::GOBJ-DEPENDS-ON-OF-G-BOOLEAN->BOOL))
 (70 12 (:REWRITE GL::GOBJ-DEPENDS-ON-OF-G-ITE->TEST))
 (38 19 (:REWRITE CONSP-OF-CAR-WHEN-ATOM-LISTP))
 (24 12 (:REWRITE GL::PBFR-DEPENDS-ON-WHEN-BOOLEANP))
 (10 10 (:TYPE-PRESCRIPTION GL::PBFR-LIST-DEPENDS-ON))
 (10 10 (:TYPE-PRESCRIPTION GL::PBFR-DEPENDS-ON))
 )
(GL::GL-ARGS-SPLIT-ITE-CORRECT
 (133 43 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (117 77 (:REWRITE DEFAULT-CAR))
 (112 4 (:DEFINITION GL::BFR-LIST->S))
 (90 90 (:TYPE-PRESCRIPTION BOOLEANP))
 (90 90 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (69 41 (:REWRITE DEFAULT-CDR))
 (68 4 (:DEFINITION HONS-ASSOC-EQUAL))
 (52 52 (:TYPE-PRESCRIPTION KWOTE-LST))
 (48 4 (:DEFINITION LOGCONS$INLINE))
 (39 39 (:REWRITE GL::TAG-WHEN-ATOM))
 (36 36 (:REWRITE GL::GENERIC-GEVAL-LIST-ATOM))
 (36 4 (:REWRITE GL::GENERIC-GEVAL-EV-OF-IF-CALL))
 (32 4 (:DEFINITION KWOTE-LST))
 (28 4 (:REWRITE GL::GENERIC-GEVAL-EV-OF-CONS-CALL))
 (26 13 (:REWRITE CONSP-OF-CAR-WHEN-ATOM-LISTP))
 (24 12 (:REWRITE GL::BFR-EVAL-BOOLEANP))
 (24 4 (:REWRITE GL::GENERIC-GEVAL-EV-OF-QUOTE))
 (24 4 (:REWRITE GL::GENERIC-GEVAL-EV-OF-LAMBDA))
 (24 4 (:DEFINITION GL::FIRST/REST/END))
 (20 8 (:REWRITE GL::BFR-LIST->S-WHEN-S-ENDP))
 (16 4 (:DEFINITION HONS-EQUAL))
 (12 12 (:TYPE-PRESCRIPTION GL::S-ENDP$INLINE))
 (12 12 (:TYPE-PRESCRIPTION HONS-ASSOC-EQUAL))
 (12 12 (:TYPE-PRESCRIPTION GL::BFR-LIST->S))
 (8 8 (:TYPE-PRESCRIPTION BOOL->BIT$INLINE))
 (8 4 (:REWRITE GL::SCDR-WHEN-S-ENDP))
 (8 4 (:REWRITE GL::GENERIC-GEVAL-EV-OF-VARIABLE))
 (8 4 (:REWRITE DEFAULT-+-2))
 (8 4 (:REWRITE DEFAULT-+-1))
 (8 4 (:REWRITE DEFAULT-*-2))
 (8 4 (:REWRITE BFIX-BITP))
 (8 4 (:DEFINITION IFIX))
 (8 4 (:DEFINITION GL::BOOL->SIGN))
 (4 4 (:TYPE-PRESCRIPTION GL::TRUE-LISTP-OF-SCDR))
 (4 4 (:TYPE-PRESCRIPTION BFR-EVAL))
 (4 4 (:REWRITE FN-CHECK-DEF-NOT-QUOTE))
 (4 4 (:REWRITE DEFAULT-*-1))
 (4 4 (:DEFINITION KWOTE))
 )
(GL::GOBJ-LISTP-GL-ARGS-SPLIT-ITE
 (180 30 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (64 64 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (60 60 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (60 30 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (32 32 (:REWRITE DEFAULT-CDR))
 (30 30 (:TYPE-PRESCRIPTION SET::EMPTYP-TYPE))
 (30 30 (:REWRITE SET::IN-SET))
 (24 8 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (18 9 (:REWRITE CONSP-OF-CAR-WHEN-ATOM-LISTP))
 (16 16 (:TYPE-PRESCRIPTION BOOLEANP))
 (16 16 (:REWRITE DEFAULT-CAR))
 (11 11 (:REWRITE GL::TAG-WHEN-ATOM))
 (9 9 (:TYPE-PRESCRIPTION ATOM-LISTP))
 )
(GL::GOBJ-LIST-DEPENDS-ON-OF-GL-ARGS-SPLIT-ITE
 (354 118 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (311 311 (:REWRITE GL::GOBJ-DEPENDS-ON-WHEN-G-VAR))
 (311 311 (:REWRITE GL::GOBJ-DEPENDS-ON-WHEN-G-CONCRETE))
 (253 253 (:TYPE-PRESCRIPTION BOOLEANP))
 (132 132 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (127 127 (:REWRITE GL::TAG-WHEN-ATOM))
 (95 95 (:REWRITE DEFAULT-CDR))
 (91 91 (:REWRITE DEFAULT-CAR))
 (34 17 (:REWRITE GL::PBFR-DEPENDS-ON-WHEN-BOOLEANP))
 (30 15 (:REWRITE CONSP-OF-CAR-WHEN-ATOM-LISTP))
 (8 8 (:TYPE-PRESCRIPTION GL::PBFR-LIST-DEPENDS-ON))
 (8 8 (:TYPE-PRESCRIPTION GL::PBFR-DEPENDS-ON))
 )
(GL::DEBUG-FNCALL-SPLIT-ITE)
(GL::GL-FNCALL-SPLIT-ITE
 (4 2 (:REWRITE DEFAULT-<-2))
 (4 2 (:REWRITE DEFAULT-<-1))
 )
(GL::GL-FNCALL-SPLIT-ITE-CORRECT
 (586 222 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (540 296 (:REWRITE DEFAULT-CAR))
 (486 17 (:DEFINITION GL::BFR-LIST->S))
 (417 417 (:TYPE-PRESCRIPTION BOOLEANP))
 (306 306 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (306 17 (:DEFINITION HONS-GET))
 (289 17 (:DEFINITION HONS-ASSOC-EQUAL))
 (288 32 (:REWRITE GL::GENERIC-GEVAL-EV-OF-IF-CALL))
 (256 32 (:DEFINITION KWOTE-LST))
 (244 116 (:REWRITE DEFAULT-CDR))
 (224 32 (:REWRITE GL::GENERIC-GEVAL-EV-OF-CONS-CALL))
 (208 17 (:DEFINITION LOGCONS$INLINE))
 (192 32 (:REWRITE GL::GENERIC-GEVAL-EV-OF-QUOTE))
 (192 32 (:REWRITE GL::GENERIC-GEVAL-EV-OF-LAMBDA))
 (186 102 (:REWRITE GL::TAG-WHEN-ATOM))
 (172 172 (:TYPE-PRESCRIPTION GL::GL-FNCALL-SPLIT-ITE))
 (170 116 (:REWRITE GL::GENERIC-GEVAL-NON-CONS))
 (128 128 (:REWRITE CAR-CONS))
 (106 53 (:REWRITE GL::BFR-EVAL-BOOLEANP))
 (102 17 (:DEFINITION GL::FIRST/REST/END))
 (85 34 (:REWRITE GL::BFR-LIST->S-WHEN-S-ENDP))
 (68 17 (:DEFINITION HONS-EQUAL))
 (64 64 (:TYPE-PRESCRIPTION GL::GENERIC-GEVAL-LIST))
 (64 32 (:REWRITE GL::GENERIC-GEVAL-EV-OF-VARIABLE))
 (53 53 (:TYPE-PRESCRIPTION GL::BFR-LIST->S))
 (51 51 (:TYPE-PRESCRIPTION GL::S-ENDP$INLINE))
 (50 50 (:TYPE-PRESCRIPTION HONS-ASSOC-EQUAL))
 (40 17 (:DEFINITION GL::BOOL->SIGN))
 (36 36 (:TYPE-PRESCRIPTION BOOL->BIT$INLINE))
 (34 17 (:REWRITE GL::SCDR-WHEN-S-ENDP))
 (34 17 (:REWRITE DEFAULT-+-2))
 (34 17 (:REWRITE DEFAULT-+-1))
 (34 17 (:REWRITE DEFAULT-*-2))
 (34 17 (:REWRITE CONSP-OF-CAR-WHEN-ATOM-LISTP))
 (34 17 (:REWRITE BFIX-BITP))
 (34 17 (:DEFINITION IFIX))
 (32 32 (:REWRITE GL::GENERIC-GEVAL-LIST-ATOM))
 (32 32 (:DEFINITION KWOTE))
 (31 31 (:REWRITE FN-CHECK-DEF-NOT-QUOTE))
 (21 21 (:TYPE-PRESCRIPTION BFR-EVAL))
 (17 17 (:TYPE-PRESCRIPTION GL::TRUE-LISTP-OF-SCDR))
 (17 17 (:TYPE-PRESCRIPTION ATOM-LISTP))
 (17 17 (:REWRITE DEFAULT-*-1))
 )
(GL::GOBJ-DEPENDS-ON-OF-GL-ARGS-SPLIT-ITE
 (153 92 (:REWRITE GL::GOBJ-DEPENDS-ON-OF-ATOM))
 (126 42 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (94 94 (:REWRITE GL::GOBJ-DEPENDS-ON-WHEN-G-VAR))
 (94 94 (:REWRITE GL::GOBJ-DEPENDS-ON-WHEN-G-CONCRETE))
 (89 89 (:TYPE-PRESCRIPTION BOOLEANP))
 (84 42 (:REWRITE GL::TAG-WHEN-ATOM))
 (35 30 (:REWRITE GL::GOBJ-LIST-DEPENDS-ON-OF-ATOM))
 (19 12 (:REWRITE DEFAULT-CDR))
 (19 12 (:REWRITE DEFAULT-CAR))
 (10 10 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (10 5 (:REWRITE GL::PBFR-DEPENDS-ON-WHEN-BOOLEANP))
 )
(GL::DEBUG-CONS-SPLIT-ITE)
(GL::GL-CONS-SPLIT-ITE
 (236 102 (:REWRITE DEFAULT-+-1))
 (222 102 (:REWRITE DEFAULT-+-2))
 (60 12 (:REWRITE DEFAULT-<-1))
 (54 18 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (48 48 (:REWRITE DEFAULT-CDR))
 (48 48 (:REWRITE DEFAULT-CAR))
 (46 12 (:REWRITE DEFAULT-<-2))
 (36 36 (:TYPE-PRESCRIPTION BOOLEANP))
 (24 24 (:TYPE-PRESCRIPTION GL::G-ITE-DEPTH-SUM))
 (16 16 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (14 14 (:REWRITE GL::TAG-WHEN-ATOM))
 )
(GL::GL-CONS-SPLIT-ITE-CORRECT
 (3395 1213 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (3248 116 (:DEFINITION GL::BFR-LIST->S))
 (2712 1520 (:REWRITE DEFAULT-CAR))
 (2530 2530 (:TYPE-PRESCRIPTION BOOLEANP))
 (2118 2118 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (2088 116 (:DEFINITION HONS-GET))
 (1972 116 (:DEFINITION HONS-ASSOC-EQUAL))
 (1552 708 (:REWRITE DEFAULT-CDR))
 (1508 1508 (:TYPE-PRESCRIPTION KWOTE-LST))
 (1392 116 (:DEFINITION LOGCONS$INLINE))
 (1044 116 (:REWRITE GL::GENERIC-GEVAL-EV-OF-IF-CALL))
 (994 802 (:REWRITE GL::TAG-WHEN-ATOM))
 (928 116 (:DEFINITION KWOTE-LST))
 (812 116 (:REWRITE GL::GENERIC-GEVAL-EV-OF-CONS-CALL))
 (696 348 (:REWRITE GL::BFR-EVAL-BOOLEANP))
 (696 116 (:REWRITE GL::GENERIC-GEVAL-EV-OF-QUOTE))
 (696 116 (:REWRITE GL::GENERIC-GEVAL-EV-OF-LAMBDA))
 (696 116 (:DEFINITION GL::FIRST/REST/END))
 (580 232 (:REWRITE GL::BFR-LIST->S-WHEN-S-ENDP))
 (396 396 (:TYPE-PRESCRIPTION GL::GL-CONS-SPLIT-ITE))
 (348 348 (:TYPE-PRESCRIPTION GL::S-ENDP$INLINE))
 (348 348 (:TYPE-PRESCRIPTION HONS-ASSOC-EQUAL))
 (348 348 (:TYPE-PRESCRIPTION GL::BFR-LIST->S))
 (232 232 (:TYPE-PRESCRIPTION GL::GENERIC-GEVAL-LIST))
 (232 232 (:TYPE-PRESCRIPTION BOOL->BIT$INLINE))
 (232 116 (:REWRITE GL::SCDR-WHEN-S-ENDP))
 (232 116 (:REWRITE GL::GENERIC-GEVAL-EV-OF-VARIABLE))
 (232 116 (:REWRITE DEFAULT-+-2))
 (232 116 (:REWRITE DEFAULT-+-1))
 (232 116 (:REWRITE DEFAULT-*-2))
 (232 116 (:REWRITE CONSP-OF-CAR-WHEN-ATOM-LISTP))
 (232 116 (:REWRITE BFIX-BITP))
 (232 116 (:DEFINITION IFIX))
 (232 116 (:DEFINITION GL::BOOL->SIGN))
 (116 116 (:TYPE-PRESCRIPTION GL::TRUE-LISTP-OF-SCDR))
 (116 116 (:TYPE-PRESCRIPTION BFR-EVAL))
 (116 116 (:TYPE-PRESCRIPTION ATOM-LISTP))
 (116 116 (:REWRITE GL::GENERIC-GEVAL-LIST-ATOM))
 (116 116 (:REWRITE FN-CHECK-DEF-NOT-QUOTE))
 (116 116 (:REWRITE DEFAULT-*-1))
 (116 116 (:DEFINITION KWOTE))
 )
(GL::GOBJ-DEPENDS-ON-OF-GL-CONS-SPLIT-ITE
 (195 65 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (130 130 (:TYPE-PRESCRIPTION BOOLEANP))
 (104 104 (:REWRITE GL::GOBJ-DEPENDS-ON-WHEN-G-VAR))
 (104 104 (:REWRITE GL::GOBJ-DEPENDS-ON-WHEN-G-CONCRETE))
 (70 70 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (65 65 (:REWRITE GL::TAG-WHEN-ATOM))
 (33 33 (:TYPE-PRESCRIPTION GL::GL-CONS-SPLIT-ITE))
 (4 4 (:TYPE-PRESCRIPTION GL::GL-CONS))
 )
(GL::GL-CONS-MAYBE-SPLIT)
(GL::GL-CONS-MAYBE-SPLIT-CORRECT
 (2183 15 (:DEFINITION GL::GENERIC-GEVAL))
 (441 163 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (420 15 (:DEFINITION GL::BFR-LIST->S))
 (395 222 (:REWRITE DEFAULT-CAR))
 (323 323 (:TYPE-PRESCRIPTION BOOLEANP))
 (322 322 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (300 18 (:DEFINITION HONS-ASSOC-EQUAL))
 (270 15 (:DEFINITION HONS-GET))
 (269 114 (:REWRITE DEFAULT-CDR))
 (195 195 (:TYPE-PRESCRIPTION KWOTE-LST))
 (180 15 (:DEFINITION LOGCONS$INLINE))
 (135 15 (:REWRITE GL::GENERIC-GEVAL-EV-OF-IF-CALL))
 (120 90 (:REWRITE GL::TAG-WHEN-ATOM))
 (120 15 (:DEFINITION KWOTE-LST))
 (105 90 (:REWRITE GL::GENERIC-GEVAL-NON-CONS))
 (105 15 (:REWRITE GL::GENERIC-GEVAL-EV-OF-CONS-CALL))
 (102 3 (:DEFINITION FGETPROP))
 (90 45 (:REWRITE GL::BFR-EVAL-BOOLEANP))
 (90 15 (:REWRITE GL::GENERIC-GEVAL-EV-OF-QUOTE))
 (90 15 (:REWRITE GL::GENERIC-GEVAL-EV-OF-LAMBDA))
 (90 15 (:DEFINITION GL::FIRST/REST/END))
 (75 30 (:REWRITE GL::BFR-LIST->S-WHEN-S-ENDP))
 (66 18 (:DEFINITION HONS-EQUAL))
 (60 60 (:REWRITE CAR-CONS))
 (54 27 (:REWRITE CONSP-OF-CAR-WHEN-ATOM-LISTP))
 (45 45 (:TYPE-PRESCRIPTION GL::S-ENDP$INLINE))
 (45 45 (:TYPE-PRESCRIPTION GL::BFR-LIST->S))
 (30 30 (:TYPE-PRESCRIPTION GL::GENERIC-GEVAL-LIST))
 (30 30 (:TYPE-PRESCRIPTION BOOL->BIT$INLINE))
 (30 15 (:REWRITE GL::SCDR-WHEN-S-ENDP))
 (30 15 (:REWRITE GL::GENERIC-GEVAL-EV-OF-VARIABLE))
 (30 15 (:REWRITE DEFAULT-+-2))
 (30 15 (:REWRITE DEFAULT-+-1))
 (30 15 (:REWRITE DEFAULT-*-2))
 (30 15 (:REWRITE BFIX-BITP))
 (30 15 (:DEFINITION IFIX))
 (30 15 (:DEFINITION GL::BOOL->SIGN))
 (24 24 (:TYPE-PRESCRIPTION GL::GL-CONS))
 (15 15 (:TYPE-PRESCRIPTION GL::TRUE-LISTP-OF-SCDR))
 (15 15 (:TYPE-PRESCRIPTION BFR-EVAL))
 (15 15 (:REWRITE GL::GENERIC-GEVAL-LIST-ATOM))
 (15 15 (:REWRITE FN-CHECK-DEF-NOT-QUOTE))
 (15 15 (:REWRITE DEFAULT-*-1))
 (15 15 (:DEFINITION KWOTE))
 (12 12 (:TYPE-PRESCRIPTION GL::GL-CONS-SPLIT-ITE))
 )
(GL::GOBJ-DEPENDS-ON-OF-GL-CONS-MAYBE-SPLIT
 (102 3 (:DEFINITION FGETPROP))
 (69 24 (:REWRITE DEFAULT-CDR))
 (54 54 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (45 27 (:REWRITE DEFAULT-CAR))
 (45 3 (:DEFINITION HONS-ASSOC-EQUAL))
 (24 12 (:REWRITE CONSP-OF-CAR-WHEN-ATOM-LISTP))
 (22 15 (:REWRITE GL::GOBJ-DEPENDS-ON-OF-ATOM))
 (18 12 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (15 15 (:REWRITE GL::GOBJ-DEPENDS-ON-WHEN-G-VAR))
 (15 15 (:REWRITE GL::GOBJ-DEPENDS-ON-WHEN-G-CONCRETE))
 (6 6 (:TYPE-PRESCRIPTION BOOLEANP))
 (6 3 (:DEFINITION HONS-EQUAL))
 (4 4 (:TYPE-PRESCRIPTION GL::GL-CONS))
 (1 1 (:TYPE-PRESCRIPTION GL::GL-CONS-SPLIT-ITE))
 )
(GL::GL-FNCALL-MAYBE-SPLIT)
(GL::GL-FNCALL-MAYBE-SPLIT-CORRECT
 (170 5 (:DEFINITION FGETPROP))
 (151 86 (:REWRITE DEFAULT-CAR))
 (141 54 (:REWRITE DEFAULT-CDR))
 (122 122 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (95 47 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (92 6 (:DEFINITION HONS-ASSOC-EQUAL))
 (72 9 (:DEFINITION KWOTE-LST))
 (57 9 (:REWRITE GL::GENERIC-GEVAL-EV-OF-IF-CALL))
 (51 51 (:TYPE-PRESCRIPTION BOOLEANP))
 (45 9 (:REWRITE GL::GENERIC-GEVAL-EV-OF-CONS-CALL))
 (42 21 (:REWRITE CONSP-OF-CAR-WHEN-ATOM-LISTP))
 (39 9 (:REWRITE GL::GENERIC-GEVAL-EV-OF-QUOTE))
 (39 9 (:REWRITE GL::GENERIC-GEVAL-EV-OF-LAMBDA))
 (36 6 (:REWRITE GL::TAG-WHEN-ATOM))
 (29 10 (:REWRITE GL::GENERIC-GEVAL-NON-CONS))
 (28 1 (:DEFINITION GL::BFR-LIST->S))
 (24 24 (:REWRITE CAR-CONS))
 (18 18 (:TYPE-PRESCRIPTION GL::GENERIC-GEVAL-LIST))
 (18 9 (:REWRITE GL::GENERIC-GEVAL-EV-OF-VARIABLE))
 (18 1 (:DEFINITION HONS-GET))
 (14 6 (:DEFINITION HONS-EQUAL))
 (12 12 (:TYPE-PRESCRIPTION GL::GL-FNCALL-SPLIT-ITE))
 (12 1 (:DEFINITION LOGCONS$INLINE))
 (9 9 (:REWRITE GL::GENERIC-GEVAL-LIST-ATOM))
 (9 9 (:DEFINITION KWOTE))
 (7 7 (:REWRITE FN-CHECK-DEF-NOT-QUOTE))
 (6 3 (:REWRITE GL::BFR-EVAL-BOOLEANP))
 (6 1 (:DEFINITION GL::FIRST/REST/END))
 (5 2 (:REWRITE GL::BFR-LIST->S-WHEN-S-ENDP))
 (3 3 (:TYPE-PRESCRIPTION GL::S-ENDP$INLINE))
 (3 3 (:TYPE-PRESCRIPTION GL::BFR-LIST->S))
 (2 2 (:TYPE-PRESCRIPTION BOOL->BIT$INLINE))
 (2 1 (:REWRITE GL::SCDR-WHEN-S-ENDP))
 (2 1 (:REWRITE DEFAULT-+-2))
 (2 1 (:REWRITE DEFAULT-+-1))
 (2 1 (:REWRITE DEFAULT-*-2))
 (2 1 (:REWRITE BFIX-BITP))
 (2 1 (:DEFINITION IFIX))
 (2 1 (:DEFINITION GL::BOOL->SIGN))
 (1 1 (:TYPE-PRESCRIPTION GL::TRUE-LISTP-OF-SCDR))
 (1 1 (:TYPE-PRESCRIPTION BFR-EVAL))
 (1 1 (:REWRITE DEFAULT-*-1))
 )
(GL::GOBJ-DEPENDS-ON-OF-GL-ARGS-MAYBE-SPLIT
 (209 1 (:DEFINITION GL::GOBJ-DEPENDS-ON))
 (73 18 (:REWRITE GL::GOBJ-DEPENDS-ON-OF-ATOM))
 (68 2 (:DEFINITION FGETPROP))
 (54 19 (:REWRITE DEFAULT-CDR))
 (54 2 (:DEFINITION GL::GOBJ-LIST-DEPENDS-ON))
 (42 42 (:TYPE-PRESCRIPTION GL::G-APPLY))
 (40 40 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (38 21 (:REWRITE DEFAULT-CAR))
 (36 6 (:REWRITE GL::TAG-WHEN-ATOM))
 (30 14 (:REWRITE EQUAL-OF-BOOLEANS-REWRITE))
 (30 2 (:DEFINITION HONS-ASSOC-EQUAL))
 (26 3 (:REWRITE GL::GOBJ-DEPENDS-ON-CAR-OF-GOBJ))
 (21 21 (:TYPE-PRESCRIPTION GL::GL-FNCALL-SPLIT-ITE))
 (20 3 (:REWRITE GL::GOBJ-DEPENDS-ON-CAR-OF-GOBJ-LIST))
 (18 18 (:REWRITE GL::GOBJ-DEPENDS-ON-WHEN-G-VAR))
 (18 18 (:REWRITE GL::GOBJ-DEPENDS-ON-WHEN-G-CONCRETE))
 (17 17 (:TYPE-PRESCRIPTION BOOLEANP))
 (16 8 (:REWRITE CONSP-OF-CAR-WHEN-ATOM-LISTP))
 (15 10 (:REWRITE GL::GOBJ-LIST-DEPENDS-ON-OF-ATOM))
 (12 1 (:REWRITE GL::GOBJ-LIST-DEPENDS-ON-OF-G-APPLY->ARGS))
 (12 1 (:REWRITE GL::GOBJ-DEPENDS-ON-OF-G-ITE->THEN))
 (12 1 (:REWRITE GL::GOBJ-DEPENDS-ON-OF-G-ITE->TEST))
 (12 1 (:REWRITE GL::GOBJ-DEPENDS-ON-OF-G-ITE->ELSE))
 (12 1 (:REWRITE GL::GOBJ-DEPENDS-ON-OF-G-INTEGER->BITS))
 (12 1 (:REWRITE GL::GOBJ-DEPENDS-ON-OF-G-BOOLEAN->BOOL))
 (12 1 (:REWRITE GL::GOBJ-DEPENDS-ON-CDR-OF-GOBJ))
 (10 2 (:REWRITE GL::GOBJ-LIST-DEPENDS-ON-CDR-OF-GOBJ-LIST))
 (4 2 (:DEFINITION HONS-EQUAL))
 (2 1 (:REWRITE GL::PBFR-DEPENDS-ON-WHEN-BOOLEANP))
 )
