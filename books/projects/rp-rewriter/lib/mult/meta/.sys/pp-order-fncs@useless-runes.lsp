(RP::SHOULD-SUM-TERMS-CANCEL$INLINE)
(RP::PP-ORDER-HAS-PRIORITY?$INLINE)
(RP::EX-FROM-RP/TYPE-FIX/--
 (1393 17 (:REWRITE APPLY$-BADGEP-PROPERTIES . 1))
 (1387 13 (:DEFINITION APPLY$-BADGEP))
 (780 4 (:DEFINITION SUBSETP-EQUAL))
 (728 56 (:DEFINITION MEMBER-EQUAL))
 (545 503 (:REWRITE DEFAULT-CDR))
 (456 28 (:REWRITE MEMBER-EQUAL-NEWVAR-COMPONENTS-1))
 (452 154 (:REWRITE DEFAULT-+-2))
 (248 154 (:REWRITE DEFAULT-+-1))
 (210 14 (:DEFINITION LENGTH))
 (182 18 (:DEFINITION LEN))
 (153 153 (:REWRITE DEFAULT-CAR))
 (140 28 (:REWRITE COMMUTATIVITY-OF-+))
 (124 124 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (112 28 (:DEFINITION INTEGER-ABS))
 (108 4 (:DEFINITION TRUE-LISTP))
 (100 8 (:DEFINITION NATP))
 (96 8 (:REWRITE RP::CC-ST-LISTP-IMPLIES-TRUE-LISTP))
 (84 84 (:REWRITE MEMBER-EQUAL-NEWVAR-COMPONENTS-3))
 (81 81 (:TYPE-PRESCRIPTION APPLY$-BADGEP))
 (72 8 (:DEFINITION RP::CC-ST-LISTP))
 (64 8 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (56 56 (:REWRITE MEMBER-EQUAL-NEWVAR-COMPONENTS-2))
 (45 39 (:REWRITE DEFAULT-<-2))
 (45 39 (:REWRITE DEFAULT-<-1))
 (42 42 (:TYPE-PRESCRIPTION STR::TRUE-LISTP-OF-EXPLODE))
 (42 42 (:TYPE-PRESCRIPTION LEN))
 (42 28 (:REWRITE STR::CONSP-OF-EXPLODE))
 (40 40 (:TYPE-PRESCRIPTION RP::CC-ST-LISTP))
 (40 40 (:REWRITE FOLD-CONSTS-IN-+))
 (40 12 (:LINEAR APPLY$-BADGEP-PROPERTIES . 2))
 (34 13 (:DEFINITION WEAK-APPLY$-BADGE-P))
 (32 16 (:REWRITE APPLY$-BADGEP-PROPERTIES . 3))
 (32 12 (:REWRITE APPLY$-BADGEP-PROPERTIES . 2))
 (28 28 (:REWRITE DEFAULT-UNARY-MINUS))
 (28 14 (:REWRITE STR::COERCE-TO-LIST-REMOVAL))
 (24 24 (:TYPE-PRESCRIPTION RP::CC-ST-P))
 (24 12 (:LINEAR APPLY$-BADGEP-PROPERTIES . 1))
 (24 4 (:DEFINITION ALL-NILS))
 (22 22 (:REWRITE INTEGER-LISTP-IMPLIES-INTEGERP))
 (20 20 (:TYPE-PRESCRIPTION ALL-NILS))
 (18 18 (:REWRITE LEN-MEMBER-EQUAL-LOOP$-AS))
 (16 16 (:TYPE-PRESCRIPTION TRUE-LISTP))
 (16 16 (:TYPE-PRESCRIPTION SUBSETP-EQUAL))
 (16 16 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (16 16 (:LINEAR LOWER-BOUND-OF-LEN-WHEN-SUBLISTP))
 (16 16 (:LINEAR LISTPOS-UPPER-BOUND-STRONG-2))
 (16 16 (:LINEAR LEN-WHEN-PREFIXP))
 (16 8 (:REWRITE OMAP::SETP-WHEN-MAPP))
 (16 8 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (14 14 (:REWRITE RATIONAL-LISTP-IMPLIES-RATIONALP))
 (14 14 (:REWRITE INTEGERP==>NUMERATOR-=-X))
 (14 14 (:REWRITE INTEGERP==>DENOMINATOR-=-1))
 (14 14 (:REWRITE STR::EXPLODE-WHEN-NOT-STRINGP))
 (14 14 (:REWRITE DEFAULT-REALPART))
 (14 14 (:REWRITE DEFAULT-NUMERATOR))
 (14 14 (:REWRITE DEFAULT-IMAGPART))
 (14 14 (:REWRITE DEFAULT-DENOMINATOR))
 (8 8 (:TYPE-PRESCRIPTION OMAP::MAPP))
 (8 8 (:TYPE-PRESCRIPTION SET::EMPTY-TYPE))
 (8 8 (:REWRITE SET::IN-SET))
 (6 6 (:LINEAR MEMBER-EQUAL-ACL2-COUNT-SMALLER-3))
 (4 4 (:LINEAR MEMBER-EQUAL-ACL2-COUNT-SMALLER-2))
 (2 2 (:LINEAR MEMBER-EQUAL-ACL2-COUNT-SMALLER-1))
 (2 2 (:LINEAR MEMBER-EQUAL-ACL2-COUNT-SMALLER-0))
 )
(RP::M-LEMMA1
 (268 268 (:REWRITE DEFAULT-CDR))
 (230 230 (:REWRITE DEFAULT-CAR))
 (191 93 (:REWRITE DEFAULT-+-2))
 (171 93 (:REWRITE DEFAULT-+-1))
 (60 27 (:REWRITE DEFAULT-<-1))
 (47 27 (:REWRITE DEFAULT-<-2))
 (4 4 (:REWRITE FOLD-CONSTS-IN-+))
 )
(RP::PP-LIST-ORDER
 (85 28 (:REWRITE DEFAULT-+-2))
 (57 57 (:TYPE-PRESCRIPTION ACL2-COUNT-OF-CONSP-POSITIVE))
 (50 28 (:REWRITE DEFAULT-+-1))
 (45 3 (:DEFINITION LENGTH))
 (33 3 (:DEFINITION LEN))
 (30 6 (:REWRITE COMMUTATIVITY-OF-+))
 (24 6 (:DEFINITION INTEGER-ABS))
 (18 9 (:REWRITE DEFAULT-CDR))
 (11 7 (:REWRITE DEFAULT-<-2))
 (9 9 (:TYPE-PRESCRIPTION STR::TRUE-LISTP-OF-EXPLODE))
 (9 7 (:REWRITE DEFAULT-<-1))
 (9 6 (:REWRITE STR::CONSP-OF-EXPLODE))
 (8 8 (:REWRITE FOLD-CONSTS-IN-+))
 (7 7 (:REWRITE DEFAULT-CAR))
 (6 6 (:REWRITE DEFAULT-UNARY-MINUS))
 (6 3 (:REWRITE STR::COERCE-TO-LIST-REMOVAL))
 (3 3 (:TYPE-PRESCRIPTION LEN))
 (3 3 (:REWRITE RATIONAL-LISTP-IMPLIES-RATIONALP))
 (3 3 (:REWRITE LEN-MEMBER-EQUAL-LOOP$-AS))
 (3 3 (:REWRITE INTEGERP==>NUMERATOR-=-X))
 (3 3 (:REWRITE INTEGERP==>DENOMINATOR-=-1))
 (3 3 (:REWRITE INTEGER-LISTP-IMPLIES-INTEGERP))
 (3 3 (:REWRITE STR::EXPLODE-WHEN-NOT-STRINGP))
 (3 3 (:REWRITE DEFAULT-REALPART))
 (3 3 (:REWRITE DEFAULT-NUMERATOR))
 (3 3 (:REWRITE DEFAULT-IMAGPART))
 (3 3 (:REWRITE DEFAULT-DENOMINATOR))
 )
(RP::PP-LIST-ORDER-SANITY
 (36 36 (:REWRITE DEFAULT-CAR))
 (8 8 (:REWRITE DEFAULT-CDR))
 )
(RP::PP-ORDER-AND$
 (692 6 (:DEFINITION APPLY$-BADGEP))
 (689 7 (:REWRITE APPLY$-BADGEP-PROPERTIES . 1))
 (390 2 (:DEFINITION SUBSETP-EQUAL))
 (364 28 (:DEFINITION MEMBER-EQUAL))
 (305 293 (:REWRITE DEFAULT-CDR))
 (228 14 (:REWRITE MEMBER-EQUAL-NEWVAR-COMPONENTS-1))
 (145 47 (:REWRITE DEFAULT-+-2))
 (92 92 (:REWRITE DEFAULT-CAR))
 (77 47 (:REWRITE DEFAULT-+-1))
 (62 62 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (60 4 (:DEFINITION LENGTH))
 (58 6 (:DEFINITION LEN))
 (54 2 (:DEFINITION TRUE-LISTP))
 (50 4 (:DEFINITION NATP))
 (48 4 (:REWRITE RP::CC-ST-LISTP-IMPLIES-TRUE-LISTP))
 (42 42 (:REWRITE MEMBER-EQUAL-NEWVAR-COMPONENTS-3))
 (40 40 (:TYPE-PRESCRIPTION APPLY$-BADGEP))
 (40 8 (:REWRITE COMMUTATIVITY-OF-+))
 (36 4 (:DEFINITION RP::CC-ST-LISTP))
 (32 8 (:DEFINITION INTEGER-ABS))
 (32 4 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (28 28 (:REWRITE MEMBER-EQUAL-NEWVAR-COMPONENTS-2))
 (20 20 (:TYPE-PRESCRIPTION RP::CC-ST-LISTP))
 (20 6 (:LINEAR APPLY$-BADGEP-PROPERTIES . 2))
 (18 18 (:TYPE-PRESCRIPTION LEN))
 (17 13 (:REWRITE DEFAULT-<-2))
 (17 7 (:LINEAR APPLY$-BADGEP-PROPERTIES . 1))
 (16 8 (:REWRITE APPLY$-BADGEP-PROPERTIES . 3))
 (16 6 (:REWRITE APPLY$-BADGEP-PROPERTIES . 2))
 (16 6 (:DEFINITION WEAK-APPLY$-BADGE-P))
 (15 13 (:REWRITE DEFAULT-<-1))
 (12 12 (:TYPE-PRESCRIPTION STR::TRUE-LISTP-OF-EXPLODE))
 (12 12 (:TYPE-PRESCRIPTION RP::CC-ST-P))
 (12 8 (:REWRITE STR::CONSP-OF-EXPLODE))
 (12 2 (:DEFINITION ALL-NILS))
 (10 10 (:TYPE-PRESCRIPTION ALL-NILS))
 (8 8 (:TYPE-PRESCRIPTION TRUE-LISTP))
 (8 8 (:TYPE-PRESCRIPTION SUBSETP-EQUAL))
 (8 8 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (8 8 (:REWRITE INTEGER-LISTP-IMPLIES-INTEGERP))
 (8 8 (:REWRITE DEFAULT-UNARY-MINUS))
 (8 8 (:LINEAR LOWER-BOUND-OF-LEN-WHEN-SUBLISTP))
 (8 8 (:LINEAR LISTPOS-UPPER-BOUND-STRONG-2))
 (8 8 (:LINEAR LEN-WHEN-PREFIXP))
 (8 4 (:REWRITE OMAP::SETP-WHEN-MAPP))
 (8 4 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (8 4 (:REWRITE STR::COERCE-TO-LIST-REMOVAL))
 (6 6 (:REWRITE LEN-MEMBER-EQUAL-LOOP$-AS))
 (4 4 (:TYPE-PRESCRIPTION OMAP::MAPP))
 (4 4 (:TYPE-PRESCRIPTION SET::EMPTY-TYPE))
 (4 4 (:REWRITE RATIONAL-LISTP-IMPLIES-RATIONALP))
 (4 4 (:REWRITE INTEGERP==>NUMERATOR-=-X))
 (4 4 (:REWRITE INTEGERP==>DENOMINATOR-=-1))
 (4 4 (:REWRITE SET::IN-SET))
 (4 4 (:REWRITE STR::EXPLODE-WHEN-NOT-STRINGP))
 (4 4 (:REWRITE DEFAULT-REALPART))
 (4 4 (:REWRITE DEFAULT-NUMERATOR))
 (4 4 (:REWRITE DEFAULT-IMAGPART))
 (4 4 (:REWRITE DEFAULT-DENOMINATOR))
 (1 1 (:LINEAR ACL2-COUNT-OF-CONSP-POSITIVE))
 )
(RP::PP-ORDER-AND$-SANITY
 (480 480 (:REWRITE DEFAULT-CDR))
 (266 266 (:REWRITE DEFAULT-CAR))
 (87 29 (:REWRITE RP::LEXORDER2-SANITY-LEMMA2))
 (58 58 (:REWRITE RP::LEXORDER2-SANITY-LEMMA3))
 (29 29 (:REWRITE RP::LEXORDER2-SANITY-LEMMA1))
 )
(RP::PP-ORDER)
(RP::PP-ORDER-SANITY
 (41 41 (:REWRITE DEFAULT-CAR))
 (9 9 (:REWRITE DEFAULT-CDR))
 )
(RP::MERGE-PP-AND)
(RP::MERGE-PP-OR)
(RP::PP-OR$-ORDER)
(RP::SANITY-OR$-ORDER
 (6000 300 (:DEFINITION RP::LEXORDER2))
 (5224 5224 (:REWRITE DEFAULT-CDR))
 (5005 1001 (:DEFINITION RP::EX-FROM-RP))
 (1350 925 (:REWRITE RP::LEXORDER2-SANITY-LEMMA2))
 (1001 1001 (:TYPE-PRESCRIPTION RP::IS-RP$INLINE))
 (900 300 (:REWRITE RP::SMALL-ALPHORDER-SANITY))
 (600 600 (:TYPE-PRESCRIPTION RP::SMALL-ALPHORDER))
 )
(RP::PP-AND$-ORDER)
(RP::SANITY-AND$-ORDER
 (5219 307 (:DEFINITION RP::LEXORDER2))
 (4070 814 (:DEFINITION RP::EX-FROM-RP))
 (3678 3678 (:REWRITE DEFAULT-CDR))
 (3430 3430 (:REWRITE DEFAULT-CAR))
 (921 307 (:REWRITE RP::SMALL-ALPHORDER-SANITY))
 (814 814 (:TYPE-PRESCRIPTION RP::IS-RP$INLINE))
 (614 614 (:TYPE-PRESCRIPTION RP::SMALL-ALPHORDER))
 )
(RP::FLATTEN-PP
 (1 1 (:TYPE-PRESCRIPTION RP::FLATTEN-PP))
 )
