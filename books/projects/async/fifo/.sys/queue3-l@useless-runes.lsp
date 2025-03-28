(ADE::QUEUE3-L$DATA-INS-LEN
 (1 1 (:REWRITE DEFAULT-<-2))
 (1 1 (:REWRITE DEFAULT-<-1))
 )
(ADE::QUEUE3-L$INS-LEN)
(ADE::QUEUE3-L*
 (27 27 (:TYPE-PRESCRIPTION POSP))
 )
(ADE::QUEUE3-L*$DESTRUCTURE
 (66 12 (:REWRITE APPEND-WHEN-NOT-CONSP))
 (60 60 (:TYPE-PRESCRIPTION POSP))
 (60 6 (:DEFINITION BINARY-APPEND))
 (16 16 (:REWRITE DEFAULT-CDR))
 (11 11 (:REWRITE DEFAULT-CAR))
 )
(ADE::NOT-PRIMP-QUEUE3-L)
(ADE::QUEUE3-L$NETLIST)
(ADE::QUEUE3-L&)
(ADE::CHECK-QUEUE3-L$NETLIST-64)
(ADE::QUEUE3-L$ST-FORMAT)
(ADE::QUEUE3-L$ST-FORMAT=>CONSTRAINT
 (5 1 (:DEFINITION LEN))
 (4 4 (:REWRITE NTH-WHEN-PREFIXP))
 (2 1 (:REWRITE DEFAULT-+-2))
 (1 1 (:REWRITE DEFAULT-CDR))
 (1 1 (:REWRITE DEFAULT-+-1))
 )
(ADE::QUEUE3-L$VALID-ST)
(ADE::QUEUE3-L$VALID-ST=>CONSTRAINT
 (6 6 (:REWRITE NTH-WHEN-PREFIXP))
 (5 1 (:DEFINITION LEN))
 (2 1 (:REWRITE DEFAULT-+-2))
 (1 1 (:REWRITE DEFAULT-CDR))
 (1 1 (:REWRITE DEFAULT-+-1))
 )
(ADE::QUEUE3-L$VALID-ST=>ST-FORMAT
 (33 33 (:REWRITE NTH-WHEN-PREFIXP))
 (12 3 (:DEFINITION STRIP-CARS))
 (6 6 (:REWRITE DEFAULT-CAR))
 (3 3 (:REWRITE DEFAULT-CDR))
 )
(ADE::QUEUE3-L$IN-ACT)
(ADE::QUEUE3-L$OUT-ACT)
(ADE::QUEUE3-L$DATA-IN
 (6 2 (:REWRITE ADE::BV-IS-TRUE-LIST))
 (5 1 (:DEFINITION TRUE-LISTP))
 (4 4 (:TYPE-PRESCRIPTION ADE::BVP))
 (1 1 (:REWRITE DEFAULT-CDR))
 (1 1 (:REWRITE DEFAULT-<-2))
 (1 1 (:REWRITE DEFAULT-<-1))
 )
(ADE::LEN-QUEUE3-L$DATA-IN)
(ADE::QUEUE3-L$READY-IN-
 (5 5 (:TYPE-PRESCRIPTION ADE::F-BUF))
 )
(ADE::BOOLEANP-QUEUE3-L$READY-IN-
 (15 3 (:DEFINITION LEN))
 (12 12 (:REWRITE NTH-WHEN-PREFIXP))
 (12 3 (:DEFINITION STRIP-CARS))
 (6 6 (:REWRITE DEFAULT-CDR))
 (6 6 (:REWRITE DEFAULT-CAR))
 (6 3 (:REWRITE DEFAULT-+-2))
 (3 3 (:REWRITE DEFAULT-+-1))
 )
(ADE::QUEUE3-L$READY-OUT
 (5 5 (:TYPE-PRESCRIPTION ADE::F-BUF))
 )
(ADE::BOOLEANP-QUEUE3-L$READY-OUT
 (15 3 (:DEFINITION LEN))
 (12 12 (:REWRITE NTH-WHEN-PREFIXP))
 (12 3 (:DEFINITION STRIP-CARS))
 (6 6 (:REWRITE DEFAULT-CDR))
 (6 6 (:REWRITE DEFAULT-CAR))
 (6 3 (:REWRITE DEFAULT-+-2))
 (3 3 (:REWRITE DEFAULT-+-1))
 )
(ADE::QUEUE3-L$DATA-OUT)
(ADE::V-THREEFIX-OF-QUEUE3-L$DATA-OUT-CANCELED)
(ADE::LEN-QUEUE3-L$DATA-OUT-1
 (15 3 (:DEFINITION LEN))
 (6 6 (:REWRITE NTH-WHEN-PREFIXP))
 (6 3 (:REWRITE DEFAULT-+-2))
 (4 4 (:LINEAR LEN-WHEN-PREFIXP))
 (3 3 (:REWRITE DEFAULT-CDR))
 (3 3 (:REWRITE DEFAULT-+-1))
 (2 2 (:LINEAR ADE::A-HELPFUL-LEMMA-FOR-TREE-INDUCTIONS))
 )
(ADE::LEN-QUEUE3-L$DATA-OUT-2
 (15 3 (:DEFINITION LEN))
 (12 12 (:REWRITE NTH-WHEN-PREFIXP))
 (8 2 (:DEFINITION STRIP-CARS))
 (6 3 (:REWRITE DEFAULT-+-2))
 (5 5 (:REWRITE DEFAULT-CDR))
 (4 4 (:REWRITE DEFAULT-CAR))
 (4 4 (:LINEAR LEN-WHEN-PREFIXP))
 (3 3 (:REWRITE DEFAULT-+-1))
 (2 2 (:LINEAR ADE::A-HELPFUL-LEMMA-FOR-TREE-INDUCTIONS))
 )
(ADE::BVP-QUEUE3-L$DATA-OUT
 (28 7 (:DEFINITION STRIP-CARS))
 (20 20 (:REWRITE NTH-WHEN-PREFIXP))
 (15 3 (:DEFINITION LEN))
 (14 14 (:REWRITE DEFAULT-CAR))
 (12 12 (:TYPE-PRESCRIPTION ADE::F-BUF))
 (10 10 (:REWRITE DEFAULT-CDR))
 (6 3 (:REWRITE DEFAULT-+-2))
 (3 3 (:REWRITE DEFAULT-+-1))
 )
(ADE::QUEUE3-L$OUTPUTS
 (1 1 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$READY-OUT))
 (1 1 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$READY-IN-))
 )
(ADE::QUEUE3-L$VALUE
 (368 99 (:DEFINITION BINARY-APPEND))
 (316 183 (:REWRITE DEFAULT-+-2))
 (290 290 (:TYPE-PRESCRIPTION POSP))
 (224 224 (:LINEAR LEN-WHEN-PREFIXP))
 (188 183 (:REWRITE DEFAULT-+-1))
 (140 140 (:TYPE-PRESCRIPTION PAIRLIS$))
 (134 12 (:REWRITE ADE::ASSOC-EQ-VALUE-OF-SI-PAIRLIS$-SIS))
 (124 4 (:REWRITE ADE::LEN-NTHCDR))
 (112 112 (:LINEAR ADE::A-HELPFUL-LEMMA-FOR-TREE-INDUCTIONS))
 (112 14 (:TYPE-PRESCRIPTION TRUE-LISTP-NTHCDR-TYPE-PRESCRIPTION))
 (110 20 (:REWRITE CDR-OF-APPEND-WHEN-CONSP))
 (102 38 (:REWRITE TAKE-WHEN-ATOM))
 (98 35 (:REWRITE ADE::ASSOC-EQ-VALUES-ATOM))
 (88 18 (:REWRITE ADE::NTHCDR-APPEND))
 (86 16 (:REWRITE ADE::ASSOC-EQ-VALUES-ARGS-PAIRLIS$-ARGS))
 (80 20 (:REWRITE CAR-OF-APPEND))
 (80 8 (:DEFINITION ATOM))
 (69 23 (:REWRITE ADE::CAR-V-THREEFIX))
 (66 45 (:REWRITE DEFAULT-<-2))
 (65 5 (:REWRITE LEN-OF-APPEND))
 (64 16 (:REWRITE ADE::DISJOINT-SIS-SAME-SYM-2))
 (64 16 (:REWRITE ADE::DISJOINT-SIS-SAME-SYM-1))
 (57 45 (:REWRITE DEFAULT-<-1))
 (51 35 (:REWRITE ADE::F-BUF-OF-NOT-BOOLEANP))
 (51 35 (:REWRITE ADE::F-BUF-OF-3VP))
 (48 10 (:REWRITE ADE::PAIRLIS$-APPEND))
 (47 47 (:TYPE-PRESCRIPTION TRUE-LISTP))
 (46 23 (:DEFINITION ADE::3V-FIX))
 (39 39 (:TYPE-PRESCRIPTION ADE::3VP))
 (39 39 (:DEFINITION STRIP-CARS))
 (38 38 (:REWRITE NTH-WHEN-PREFIXP))
 (38 28 (:REWRITE ADE::V-THREEFIX-BVP))
 (36 36 (:TYPE-PRESCRIPTION ADE::F-BUF))
 (32 16 (:REWRITE DEFAULT-UNARY-MINUS))
 (27 19 (:REWRITE ADE::FV-IF-WHEN-BVP))
 (21 21 (:REWRITE ADE::NTHCDR-OF-POS-CONST-IDX))
 (20 20 (:TYPE-PRESCRIPTION TAKE))
 (20 20 (:TYPE-PRESCRIPTION BOOLEANP))
 (14 14 (:TYPE-PRESCRIPTION ADE::BVP))
 (12 4 (:REWRITE FOLD-CONSTS-IN-+))
 (4 4 (:REWRITE ADE::SI-MEMBER-SIS))
 (4 2 (:REWRITE CAR-OF-TAKE))
 (2 2 (:TYPE-PRESCRIPTION NO-DUPLICATESP-EQUAL))
 (2 2 (:TYPE-PRESCRIPTION NFIX))
 (2 2 (:REWRITE ADE::NO-DUPLICATESP-SIS))
 (2 2 (:REWRITE DEFAULT-SYMBOL-NAME))
 (1 1 (:REWRITE CONSP-OF-APPEND))
 )
(ADE::QUEUE3-L$STEP
 (24 12 (:TYPE-PRESCRIPTION ADE::BOOLEANP-JOINT-ACT))
 (12 12 (:TYPE-PRESCRIPTION BOOLEANP))
 )
(ADE::QUEUE3-L$STEP-V-THREEFIX-OF-DATA-IN-CANCELED
 (439 87 (:DEFINITION LEN))
 (337 2 (:REWRITE PREFIXP-OF-APPEND-ARG1))
 (242 125 (:REWRITE DEFAULT-+-2))
 (145 125 (:REWRITE DEFAULT-+-1))
 (120 114 (:REWRITE DEFAULT-CDR))
 (96 4 (:REWRITE ADE::LEN-NTHCDR))
 (94 2 (:DEFINITION TAKE))
 (66 29 (:REWRITE DEFAULT-<-2))
 (62 4 (:REWRITE LEN-OF-APPEND))
 (56 56 (:REWRITE NTH-WHEN-PREFIXP))
 (56 8 (:REWRITE ADE::FV-IF-WHEN-BVP))
 (54 3 (:DEFINITION NTHCDR))
 (53 47 (:REWRITE DEFAULT-CAR))
 (52 52 (:LINEAR LEN-WHEN-PREFIXP))
 (47 29 (:REWRITE DEFAULT-<-1))
 (40 40 (:TYPE-PRESCRIPTION STRIP-CARS))
 (40 10 (:DEFINITION STRIP-CARS))
 (40 5 (:REWRITE ZP-OPEN))
 (38 7 (:REWRITE TAKE-WHEN-ATOM))
 (36 6 (:REWRITE ADE::LEN-STRIP-CARS))
 (30 6 (:DEFINITION PAIRLIS$))
 (29 8 (:REWRITE LIST-EQUIV-WHEN-ATOM-RIGHT))
 (28 14 (:REWRITE DEFAULT-UNARY-MINUS))
 (26 26 (:LINEAR ADE::A-HELPFUL-LEMMA-FOR-TREE-INDUCTIONS))
 (25 13 (:REWRITE PREFIXP-WHEN-NOT-CONSP-LEFT))
 (24 24 (:TYPE-PRESCRIPTION BOOLEANP))
 (24 12 (:TYPE-PRESCRIPTION TRUE-LISTP-NTHCDR-TYPE-PRESCRIPTION))
 (24 12 (:TYPE-PRESCRIPTION ADE::BOOLEANP-JOINT-ACT))
 (24 3 (:DEFINITION ADE::V-THREEFIX))
 (22 22 (:REWRITE PREFIXP-TRANSITIVE . 2))
 (22 22 (:REWRITE PREFIXP-TRANSITIVE . 1))
 (22 22 (:REWRITE PREFIXP-ONE-WAY-OR-ANOTHER . 2))
 (22 22 (:REWRITE PREFIXP-ONE-WAY-OR-ANOTHER . 1))
 (19 13 (:REWRITE PREFIXP-WHEN-NOT-CONSP-RIGHT))
 (14 6 (:REWRITE ADE::V-THREEFIX-BVP))
 (13 2 (:DEFINITION BINARY-APPEND))
 (12 12 (:TYPE-PRESCRIPTION ADE::JOINT-ACT))
 (12 12 (:TYPE-PRESCRIPTION ADE::BVP))
 (11 8 (:REWRITE LIST-EQUIV-WHEN-ATOM-LEFT))
 (10 4 (:TYPE-PRESCRIPTION TRUE-LISTP-APPEND))
 (9 3 (:REWRITE COMMUTATIVITY-OF-+))
 (8 4 (:DEFINITION ADE::3V-FIX))
 (7 4 (:REWRITE APPEND-WHEN-NOT-CONSP))
 (6 2 (:REWRITE ADE::BV-IS-TRUE-LIST))
 (5 2 (:REWRITE CONSP-OF-APPEND))
 (5 1 (:DEFINITION TRUE-LISTP))
 (4 4 (:TYPE-PRESCRIPTION BINARY-APPEND))
 (4 4 (:TYPE-PRESCRIPTION ADE::3VP))
 (4 1 (:REWRITE ADE::CAR-V-THREEFIX))
 )
(ADE::QUEUE3-L$STATE
 (817 409 (:REWRITE DEFAULT-+-2))
 (512 32 (:REWRITE ADE::DISJOINT-ATOM))
 (448 108 (:DEFINITION BINARY-APPEND))
 (411 409 (:REWRITE DEFAULT-+-1))
 (328 32 (:REWRITE ADE::DISJOINT-COMMUTATIVE))
 (288 32 (:REWRITE ADE::DISJOINT-SIS-SAME-SYM-2))
 (288 32 (:REWRITE ADE::DISJOINT-SIS-SAME-SYM-1))
 (256 256 (:TYPE-PRESCRIPTION PAIRLIS$))
 (240 16 (:DEFINITION ATOM))
 (186 46 (:REWRITE ADE::ASSOC-EQ-VALUES-ATOM))
 (158 78 (:REWRITE ADE::FV-IF-WHEN-BVP))
 (153 51 (:REWRITE ADE::CAR-V-THREEFIX))
 (134 134 (:DEFINITION STRIP-CARS))
 (120 120 (:LINEAR LEN-WHEN-PREFIXP))
 (110 55 (:TYPE-PRESCRIPTION ADE::BOOLEANP-JOINT-ACT))
 (102 51 (:DEFINITION ADE::3V-FIX))
 (96 78 (:REWRITE ADE::F-BUF-OF-NOT-BOOLEANP))
 (96 78 (:REWRITE ADE::F-BUF-OF-3VP))
 (95 95 (:TYPE-PRESCRIPTION BOOLEANP))
 (94 94 (:REWRITE NTH-WHEN-PREFIXP))
 (89 89 (:TYPE-PRESCRIPTION ADE::F-BUF))
 (72 60 (:REWRITE ADE::V-THREEFIX-BVP))
 (69 69 (:TYPE-PRESCRIPTION ADE::3VP))
 (68 34 (:REWRITE DEFAULT-<-2))
 (60 60 (:LINEAR ADE::A-HELPFUL-LEMMA-FOR-TREE-INDUCTIONS))
 (50 50 (:TYPE-PRESCRIPTION ADE::UPDATE-ALIST))
 (44 15 (:REWRITE TAKE-WHEN-ATOM))
 (40 16 (:REWRITE PREFIXP-WHEN-NOT-CONSP-RIGHT))
 (40 16 (:REWRITE PREFIXP-WHEN-NOT-CONSP-LEFT))
 (35 34 (:REWRITE DEFAULT-<-1))
 (29 1 (:REWRITE PREFIXP-OF-APPEND-ARG1))
 (24 24 (:TYPE-PRESCRIPTION ADE::BVP))
 (22 22 (:REWRITE PREFIXP-TRANSITIVE . 2))
 (22 22 (:REWRITE PREFIXP-TRANSITIVE . 1))
 (22 22 (:REWRITE PREFIXP-ONE-WAY-OR-ANOTHER . 2))
 (22 22 (:REWRITE PREFIXP-ONE-WAY-OR-ANOTHER . 1))
 (16 16 (:REWRITE ADE::NTHCDR-OF-POS-CONST-IDX))
 (12 4 (:REWRITE ADE::BV-IS-TRUE-LIST))
 (8 2 (:DEFINITION TRUE-LISTP))
 (4 1 (:REWRITE COMMUTATIVITY-OF-+))
 (2 2 (:REWRITE DEFAULT-SYMBOL-NAME))
 (2 1 (:REWRITE DEFAULT-UNARY-MINUS))
 (1 1 (:REWRITE LIST-EQUIV-WHEN-ATOM-RIGHT))
 (1 1 (:REWRITE LIST-EQUIV-WHEN-ATOM-LEFT))
 (1 1 (:REWRITE CONSP-OF-APPEND))
 )
(ADE::QUEUE3-L$INPUT-FORMAT
 (6 6 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$READY-OUT))
 (6 6 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$READY-IN-))
 )
(ADE::BOOLEANP-QUEUE3-L$IN-ACT
 (10 1 (:DEFINITION NTHCDR))
 (6 1 (:REWRITE COMMUTATIVITY-OF-+))
 (5 1 (:REWRITE ADE::NFIX-OF-NAT))
 (4 4 (:REWRITE DEFAULT-+-2))
 (4 4 (:REWRITE DEFAULT-+-1))
 (3 1 (:REWRITE FOLD-CONSTS-IN-+))
 (3 1 (:DEFINITION NATP))
 (2 2 (:REWRITE DEFAULT-<-2))
 (2 2 (:REWRITE DEFAULT-<-1))
 (1 1 (:TYPE-PRESCRIPTION NATP))
 (1 1 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$READY-IN-))
 (1 1 (:REWRITE NTH-WHEN-PREFIXP))
 (1 1 (:REWRITE DEFAULT-CDR))
 )
(ADE::BOOLEANP-QUEUE3-L$OUT-ACT
 (10 1 (:DEFINITION NTHCDR))
 (6 1 (:REWRITE COMMUTATIVITY-OF-+))
 (5 1 (:REWRITE ADE::NFIX-OF-NAT))
 (4 4 (:REWRITE DEFAULT-+-2))
 (4 4 (:REWRITE DEFAULT-+-1))
 (3 3 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$IN-ACT))
 (3 1 (:REWRITE FOLD-CONSTS-IN-+))
 (3 1 (:DEFINITION NATP))
 (2 2 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$READY-OUT))
 (2 2 (:REWRITE DEFAULT-<-2))
 (2 2 (:REWRITE DEFAULT-<-1))
 (1 1 (:TYPE-PRESCRIPTION NATP))
 (1 1 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$READY-IN-))
 (1 1 (:REWRITE NTH-WHEN-PREFIXP))
 (1 1 (:REWRITE DEFAULT-CDR))
 (1 1 (:REWRITE ADE::BOOLEANP-QUEUE3-L$IN-ACT))
 )
(ADE::QUEUE3-L$ST-FORMAT-PRESERVED
 (64 8 (:REWRITE ADE::FV-IF-WHEN-BVP))
 (63 63 (:REWRITE NTH-WHEN-PREFIXP))
 (40 10 (:DEFINITION STRIP-CARS))
 (34 34 (:REWRITE DEFAULT-CAR))
 (30 3 (:DEFINITION NTHCDR))
 (27 21 (:REWRITE DEFAULT-+-2))
 (24 24 (:TYPE-PRESCRIPTION BOOLEANP))
 (24 12 (:TYPE-PRESCRIPTION ADE::BOOLEANP-JOINT-ACT))
 (22 22 (:REWRITE DEFAULT-CDR))
 (21 21 (:REWRITE DEFAULT-+-1))
 (18 3 (:REWRITE COMMUTATIVITY-OF-+))
 (15 3 (:DEFINITION PAIRLIS$))
 (12 12 (:TYPE-PRESCRIPTION ADE::JOINT-ACT))
 (9 3 (:REWRITE FOLD-CONSTS-IN-+))
 (6 6 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$IN-ACT))
 (3 3 (:REWRITE DEFAULT-UNARY-MINUS))
 (2 2 (:REWRITE ADE::BOOLEANP-QUEUE3-L$IN-ACT))
 )
(ADE::QUEUE3-L$VALUE-ALT
 (890 89 (:DEFINITION NTHCDR))
 (558 558 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$READY-OUT))
 (544 492 (:REWRITE DEFAULT-+-2))
 (534 89 (:REWRITE COMMUTATIVITY-OF-+))
 (492 492 (:REWRITE DEFAULT-+-1))
 (416 26 (:REWRITE ADE::LEN-NTHCDR))
 (390 60 (:DEFINITION BINARY-APPEND))
 (357 357 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$READY-IN-))
 (338 52 (:REWRITE ADE::BV-IS-TRUE-LIST))
 (282 120 (:REWRITE APPEND-WHEN-NOT-CONSP))
 (260 52 (:DEFINITION LEN))
 (234 26 (:DEFINITION TRUE-LISTP))
 (227 227 (:REWRITE DEFAULT-CDR))
 (104 52 (:TYPE-PRESCRIPTION ADE::BVP-NTHCDR))
 (92 92 (:LINEAR LEN-WHEN-PREFIXP))
 (78 26 (:REWRITE ADE::BVP-NTHCDR))
 (60 60 (:REWRITE DEFAULT-CAR))
 (60 12 (:REWRITE APPEND-ATOM-UNDER-LIST-EQUIV))
 (52 26 (:REWRITE DEFAULT-<-1))
 (46 46 (:LINEAR ADE::A-HELPFUL-LEMMA-FOR-TREE-INDUCTIONS))
 (26 26 (:REWRITE DEFAULT-<-2))
 (12 12 (:REWRITE DEFAULT-UNARY-MINUS))
 (12 12 (:REWRITE ADE::BOOLEANP-QUEUE3-L$OUT-ACT))
 (7 7 (:REWRITE ADE::BOOLEANP-QUEUE3-L$IN-ACT))
 )
(ADE::QUEUE3-L$STATE-ALT
 (950 95 (:DEFINITION NTHCDR))
 (570 95 (:REWRITE COMMUTATIVITY-OF-+))
 (568 516 (:REWRITE DEFAULT-+-2))
 (558 558 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$READY-OUT))
 (516 516 (:REWRITE DEFAULT-+-1))
 (426 66 (:DEFINITION BINARY-APPEND))
 (416 26 (:REWRITE ADE::LEN-NTHCDR))
 (357 357 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$READY-IN-))
 (338 52 (:REWRITE ADE::BV-IS-TRUE-LIST))
 (294 132 (:REWRITE APPEND-WHEN-NOT-CONSP))
 (260 52 (:DEFINITION LEN))
 (239 239 (:REWRITE DEFAULT-CDR))
 (234 26 (:DEFINITION TRUE-LISTP))
 (104 52 (:TYPE-PRESCRIPTION ADE::BVP-NTHCDR))
 (92 92 (:LINEAR LEN-WHEN-PREFIXP))
 (78 26 (:REWRITE ADE::BVP-NTHCDR))
 (66 66 (:REWRITE DEFAULT-CAR))
 (60 12 (:REWRITE APPEND-ATOM-UNDER-LIST-EQUIV))
 (52 26 (:REWRITE DEFAULT-<-1))
 (46 46 (:LINEAR ADE::A-HELPFUL-LEMMA-FOR-TREE-INDUCTIONS))
 (26 26 (:REWRITE DEFAULT-<-2))
 (12 12 (:REWRITE DEFAULT-UNARY-MINUS))
 (12 12 (:REWRITE ADE::BOOLEANP-QUEUE3-L$OUT-ACT))
 (7 7 (:REWRITE ADE::BOOLEANP-QUEUE3-L$IN-ACT))
 )
(ADE::QUEUE3-L$RUN)
(DEFOPENER-HINT
 (5 5 (:TYPE-PRESCRIPTION LAST))
 )
(DEFOPENER-TEMP)
(ADE::OPEN-QUEUE3-L$RUN-ZP)
(DEFOPENER-HINT
 (5 5 (:TYPE-PRESCRIPTION LAST))
 )
(DEFOPENER-TEMP)
(ADE::OPEN-QUEUE3-L$RUN)
(ADE::QUEUE3-L$RUN-PLUS
 (87 25 (:REWRITE ZP-OPEN))
 (32 15 (:REWRITE DEFAULT-CDR))
 (27 27 (:REWRITE DEFAULT-<-2))
 (27 27 (:REWRITE DEFAULT-<-1))
 (27 10 (:REWRITE DEFAULT-CAR))
 (24 12 (:TYPE-PRESCRIPTION TRUE-LISTP-NTHCDR-TYPE-PRESCRIPTION))
 (23 23 (:REWRITE DEFAULT-+-2))
 (23 23 (:REWRITE DEFAULT-+-1))
 (16 8 (:REWRITE FOLD-CONSTS-IN-+))
 (12 12 (:TYPE-PRESCRIPTION TRUE-LISTP))
 )
(ADE::QUEUE3-L$INPUT-FORMAT-N)
(DEFOPENER-HINT
 (5 5 (:TYPE-PRESCRIPTION LAST))
 )
(DEFOPENER-TEMP)
(ADE::OPEN-QUEUE3-L$INPUT-FORMAT-N-ZP)
(DEFOPENER-HINT
 (5 5 (:TYPE-PRESCRIPTION LAST))
 )
(DEFOPENER-TEMP)
(ADE::OPEN-QUEUE3-L$INPUT-FORMAT-N)
(ADE::QUEUE3-L$INPUT-FORMAT-PLUS
 (51 27 (:REWRITE DEFAULT-CAR))
 (46 46 (:REWRITE DEFAULT-<-2))
 (46 46 (:REWRITE DEFAULT-<-1))
 (36 18 (:TYPE-PRESCRIPTION TRUE-LISTP-NTHCDR-TYPE-PRESCRIPTION))
 (30 30 (:REWRITE DEFAULT-+-2))
 (30 30 (:REWRITE DEFAULT-+-1))
 (29 17 (:REWRITE DEFAULT-CDR))
 (18 18 (:TYPE-PRESCRIPTION TRUE-LISTP))
 (2 2 (:REWRITE ADE::QUEUE3-L$RUN-PLUS))
 )
(ADE::QUEUE3-L$DE-N
 (90 30 (:REWRITE ZP-OPEN))
 (28 2 (:DEFINITION ADE::QUEUE3-L$RUN))
 (24 24 (:REWRITE DEFAULT-<-2))
 (24 24 (:REWRITE DEFAULT-<-1))
 (10 10 (:REWRITE DEFAULT-CAR))
 (7 7 (:REWRITE DEFAULT-CDR))
 (7 7 (:REWRITE DEFAULT-+-2))
 (7 7 (:REWRITE DEFAULT-+-1))
 (3 3 (:REWRITE ADE::QUEUE3-L$INPUT-FORMAT-PLUS))
 (2 2 (:REWRITE ADE::DE-PLUS))
 )
(ADE::QUEUE3-L$EXTRACT)
(ADE::QUEUE3-L$EXTRACT-NOT-EMPTY
 (183 183 (:REWRITE NTH-WHEN-PREFIXP))
 (140 35 (:DEFINITION STRIP-CARS))
 (82 82 (:REWRITE DEFAULT-CDR))
 (81 81 (:REWRITE DEFAULT-CAR))
 (58 29 (:REWRITE DEFAULT-+-2))
 (36 36 (:LINEAR LEN-WHEN-PREFIXP))
 (29 29 (:TYPE-PRESCRIPTION ADE::F-BUF))
 (29 29 (:REWRITE DEFAULT-+-1))
 (18 18 (:LINEAR ADE::A-HELPFUL-LEMMA-FOR-TREE-INDUCTIONS))
 (16 16 (:TYPE-PRESCRIPTION BOOLEANP))
 (12 4 (:REWRITE ADE::F-GATES=B-GATES))
 (12 4 (:REWRITE ADE::F-BUF-OF-NOT-BOOLEANP))
 (12 4 (:REWRITE ADE::F-BUF-OF-3VP))
 (8 8 (:TYPE-PRESCRIPTION ADE::3VP))
 )
(ADE::QUEUE3-L$EXTRACTED-STEP
 (12 12 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$IN-ACT))
 (6 6 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$OUT-ACT))
 )
(ADE::QUEUE3-L$EXTRACTED-STEP-CORRECT
 (2006 2006 (:REWRITE NTH-WHEN-PREFIXP))
 (1306 710 (:REWRITE DEFAULT-+-2))
 (1271 1271 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$IN-ACT))
 (1228 1228 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$OUT-ACT))
 (1080 270 (:DEFINITION STRIP-CARS))
 (1078 1078 (:REWRITE DEFAULT-CDR))
 (953 803 (:REWRITE DEFAULT-CAR))
 (848 64 (:DEFINITION NTHCDR))
 (764 710 (:REWRITE DEFAULT-+-1))
 (645 69 (:DEFINITION PAIRLIS$))
 (576 36 (:REWRITE ADE::LEN-NTHCDR))
 (516 72 (:REWRITE ADE::BV-IS-TRUE-LIST))
 (500 50 (:DEFINITION ADE::V-THREEFIX))
 (486 63 (:REWRITE COMMUTATIVITY-OF-+))
 (372 36 (:DEFINITION TRUE-LISTP))
 (350 50 (:REWRITE ADE::CAR-V-THREEFIX))
 (243 63 (:REWRITE FOLD-CONSTS-IN-+))
 (216 36 (:DEFINITION BINARY-APPEND))
 (200 100 (:DEFINITION ADE::3V-FIX))
 (192 72 (:TYPE-PRESCRIPTION ADE::BVP-NTHCDR))
 (180 72 (:REWRITE APPEND-WHEN-NOT-CONSP))
 (156 156 (:LINEAR LEN-WHEN-PREFIXP))
 (122 62 (:REWRITE DEFAULT-<-1))
 (108 108 (:TYPE-PRESCRIPTION ADE::3VP))
 (108 36 (:REWRITE ADE::BVP-NTHCDR))
 (100 100 (:TYPE-PRESCRIPTION ADE::V-THREEFIX))
 (86 62 (:REWRITE DEFAULT-<-2))
 (78 78 (:LINEAR ADE::A-HELPFUL-LEMMA-FOR-TREE-INDUCTIONS))
 (58 58 (:TYPE-PRESCRIPTION ADE::F-BUF))
 (32 32 (:TYPE-PRESCRIPTION BOOLEANP))
 (24 24 (:REWRITE DEFAULT-UNARY-MINUS))
 (16 16 (:REWRITE TAKE-WHEN-ATOM))
 (12 4 (:REWRITE ADE::F-GATES=B-GATES))
 (12 4 (:REWRITE ADE::F-BUF-OF-NOT-BOOLEANP))
 (12 4 (:REWRITE ADE::F-BUF-OF-3VP))
 (10 10 (:REWRITE ADE::BOOLEANP-QUEUE3-L$IN-ACT))
 (4 4 (:REWRITE ADE::BOOLEANP-QUEUE3-L$OUT-ACT))
 (3 1 (:DEFINITION NATP))
 (1 1 (:TYPE-PRESCRIPTION NATP))
 )
(ADE::QUEUE3-L$VALID-ST-PRESERVED
 (1888 1888 (:REWRITE NTH-WHEN-PREFIXP))
 (1402 758 (:REWRITE DEFAULT-+-2))
 (1080 1080 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$IN-ACT))
 (1068 1068 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$OUT-ACT))
 (883 883 (:REWRITE DEFAULT-CDR))
 (846 63 (:DEFINITION NTHCDR))
 (812 758 (:REWRITE DEFAULT-+-1))
 (728 182 (:DEFINITION STRIP-CARS))
 (573 492 (:REWRITE DEFAULT-CAR))
 (500 50 (:DEFINITION ADE::V-THREEFIX))
 (486 63 (:REWRITE COMMUTATIVITY-OF-+))
 (480 30 (:REWRITE ADE::LEN-NTHCDR))
 (438 60 (:REWRITE ADE::BV-IS-TRUE-LIST))
 (392 46 (:DEFINITION PAIRLIS$))
 (318 30 (:DEFINITION TRUE-LISTP))
 (243 63 (:REWRITE FOLD-CONSTS-IN-+))
 (189 27 (:REWRITE ADE::CAR-V-THREEFIX))
 (180 30 (:DEFINITION BINARY-APPEND))
 (168 60 (:TYPE-PRESCRIPTION ADE::BVP-NTHCDR))
 (154 77 (:DEFINITION ADE::3V-FIX))
 (150 60 (:REWRITE APPEND-WHEN-NOT-CONSP))
 (144 144 (:LINEAR LEN-WHEN-PREFIXP))
 (110 56 (:REWRITE DEFAULT-<-1))
 (90 30 (:REWRITE ADE::BVP-NTHCDR))
 (81 81 (:TYPE-PRESCRIPTION ADE::3VP))
 (80 56 (:REWRITE DEFAULT-<-2))
 (72 72 (:LINEAR ADE::A-HELPFUL-LEMMA-FOR-TREE-INDUCTIONS))
 (24 24 (:TYPE-PRESCRIPTION BOOLEANP))
 (24 24 (:REWRITE DEFAULT-UNARY-MINUS))
 (15 15 (:TYPE-PRESCRIPTION ADE::F-BUF))
 (9 9 (:REWRITE ADE::BOOLEANP-QUEUE3-L$IN-ACT))
 (6 2 (:REWRITE ADE::F-GATES=B-GATES))
 (6 2 (:REWRITE ADE::F-BUF-OF-NOT-BOOLEANP))
 (6 2 (:REWRITE ADE::F-BUF-OF-3VP))
 (3 1 (:DEFINITION NATP))
 (2 2 (:REWRITE ADE::BOOLEANP-QUEUE3-L$OUT-ACT))
 (1 1 (:TYPE-PRESCRIPTION NATP))
 )
(ADE::QUEUE3-L$EXTRACT-LEMMA-1
 (157 157 (:REWRITE NTH-WHEN-PREFIXP))
 (144 36 (:DEFINITION STRIP-CARS))
 (100 100 (:REWRITE DEFAULT-CAR))
 (86 86 (:REWRITE DEFAULT-CDR))
 (41 41 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$IN-ACT))
 (39 6 (:REWRITE ADE::BV-IS-TRUE-LIST))
 (36 3 (:REWRITE ADE::LEN-NTHCDR))
 (34 19 (:REWRITE DEFAULT-+-2))
 (27 3 (:DEFINITION TRUE-LISTP))
 (19 19 (:REWRITE DEFAULT-+-1))
 (18 3 (:DEFINITION BINARY-APPEND))
 (15 6 (:REWRITE APPEND-WHEN-NOT-CONSP))
 (12 6 (:TYPE-PRESCRIPTION ADE::BVP-NTHCDR))
 (10 1 (:DEFINITION NTHCDR))
 (9 3 (:REWRITE ADE::BVP-NTHCDR))
 (8 8 (:TYPE-PRESCRIPTION ADE::F-BUF))
 (8 5 (:REWRITE DEFAULT-<-1))
 (6 1 (:REWRITE COMMUTATIVITY-OF-+))
 (5 5 (:REWRITE DEFAULT-<-2))
 (5 1 (:REWRITE ADE::NFIX-OF-NAT))
 (4 4 (:TYPE-PRESCRIPTION BOOLEANP))
 (3 1 (:REWRITE FOLD-CONSTS-IN-+))
 (3 1 (:REWRITE ADE::F-GATES=B-GATES))
 (3 1 (:REWRITE ADE::F-BUF-OF-NOT-BOOLEANP))
 (3 1 (:REWRITE ADE::F-BUF-OF-3VP))
 (3 1 (:DEFINITION NATP))
 (2 2 (:TYPE-PRESCRIPTION ADE::3VP))
 (1 1 (:TYPE-PRESCRIPTION NATP))
 (1 1 (:REWRITE ADE::BOOLEANP-QUEUE3-L$IN-ACT))
 )
(ADE::QUEUE3-L$EXTRACT-LEMMA-2
 (144 36 (:DEFINITION STRIP-CARS))
 (134 134 (:REWRITE NTH-WHEN-PREFIXP))
 (96 96 (:REWRITE DEFAULT-CAR))
 (71 71 (:REWRITE DEFAULT-CDR))
 (14 7 (:REWRITE DEFAULT-+-2))
 (12 12 (:TYPE-PRESCRIPTION ADE::F-BUF))
 (7 7 (:REWRITE DEFAULT-+-1))
 )
(ADE::QUEUE3-L$IN-SEQ
 (6 6 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$IN-ACT))
 )
(ADE::QUEUE3-L$IN-SEQ-NETLIST
 (6 6 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$IN-ACT))
 )
(ADE::QUEUE3-L$IN-SEQ-LEMMA
 (205 55 (:REWRITE ZP-OPEN))
 (146 24 (:DEFINITION BINARY-APPEND))
 (114 48 (:REWRITE APPEND-WHEN-NOT-CONSP))
 (102 102 (:REWRITE DEFAULT-CAR))
 (68 68 (:REWRITE DEFAULT-CDR))
 (58 58 (:REWRITE DEFAULT-<-2))
 (58 58 (:REWRITE DEFAULT-<-1))
 (54 54 (:REWRITE DEFAULT-+-2))
 (54 54 (:REWRITE DEFAULT-+-1))
 (42 42 (:REWRITE NTH-WHEN-PREFIXP))
 (30 10 (:REWRITE FOLD-CONSTS-IN-+))
 (24 24 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$IN-ACT))
 (12 12 (:REWRITE ADE::QUEUE3-L$INPUT-FORMAT-PLUS))
 (4 4 (:REWRITE APPEND-ATOM-UNDER-LIST-EQUIV))
 )
(ADE::QUEUE3-L$OUT-SEQ
 (6 6 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$OUT-ACT))
 )
(ADE::QUEUE3-L$OUT-SEQ-NETLIST
 (6 6 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$OUT-ACT))
 )
(ADE::QUEUE3-L$OUT-SEQ-LEMMA
 (205 55 (:REWRITE ZP-OPEN))
 (146 24 (:DEFINITION BINARY-APPEND))
 (114 48 (:REWRITE APPEND-WHEN-NOT-CONSP))
 (100 100 (:REWRITE DEFAULT-CAR))
 (84 72 (:REWRITE DEFAULT-CDR))
 (58 58 (:REWRITE DEFAULT-<-2))
 (58 58 (:REWRITE DEFAULT-<-1))
 (54 54 (:REWRITE DEFAULT-+-2))
 (54 54 (:REWRITE DEFAULT-+-1))
 (42 42 (:REWRITE NTH-WHEN-PREFIXP))
 (34 20 (:REWRITE ADE::QUEUE3-L$EXTRACT-LEMMA-1))
 (30 10 (:REWRITE FOLD-CONSTS-IN-+))
 (24 24 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$OUT-ACT))
 (20 4 (:DEFINITION NTHCDR))
 (14 14 (:TYPE-PRESCRIPTION ADE::QUEUE3-L$VALID-ST))
 (12 12 (:TYPE-PRESCRIPTION ADE::SE))
 (12 12 (:REWRITE ADE::QUEUE3-L$INPUT-FORMAT-PLUS))
 (4 4 (:REWRITE APPEND-ATOM-UNDER-LIST-EQUIV))
 )
(ADE::QUEUE3-L$DATAFLOW-CORRECT-AUX
 (175 163 (:TYPE-PRESCRIPTION BINARY-APPEND))
 (53 16 (:REWRITE APPEND-WHEN-NOT-CONSP))
 (40 2 (:DEFINITION ADE::QUEUE3-L$IN-SEQ))
 (24 10 (:REWRITE DEFAULT-CDR))
 (12 12 (:REWRITE DEFAULT-CAR))
 (8 8 (:REWRITE APPEND-ATOM-UNDER-LIST-EQUIV))
 (6 2 (:REWRITE CAR-OF-APPEND))
 (5 5 (:REWRITE CONSP-OF-APPEND))
 (4 4 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$IN-ACT))
 (2 2 (:REWRITE ZP-OPEN))
 (2 2 (:REWRITE DEFAULT-+-2))
 (2 2 (:REWRITE DEFAULT-+-1))
 (2 2 (:REWRITE CDR-OF-APPEND-WHEN-CONSP))
 )
(ADE::QUEUE3-L$DATAFLOW-CORRECT
 (449 103 (:REWRITE ZP-OPEN))
 (382 61 (:DEFINITION BINARY-APPEND))
 (234 4 (:REWRITE TAKE-OF-TOO-MANY))
 (200 8 (:DEFINITION NTHCDR))
 (173 143 (:REWRITE DEFAULT-CDR))
 (172 166 (:REWRITE DEFAULT-CAR))
 (168 2 (:DEFINITION TAKE))
 (166 126 (:REWRITE DEFAULT-+-2))
 (146 128 (:REWRITE DEFAULT-<-2))
 (146 128 (:REWRITE DEFAULT-<-1))
 (126 126 (:REWRITE DEFAULT-+-1))
 (126 18 (:DEFINITION LEN))
 (82 24 (:REWRITE FOLD-CONSTS-IN-+))
 (82 4 (:REWRITE ADE::NFIX-OF-NAT))
 (66 4 (:DEFINITION NATP))
 (56 8 (:REWRITE COMMUTATIVITY-OF-+))
 (52 2 (:REWRITE CONSP-OF-TAKE))
 (32 32 (:REWRITE APPEND-ATOM-UNDER-LIST-EQUIV))
 (30 4 (:DEFINITION NFIX))
 (24 8 (:LINEAR ADE::QUEUE3-L$EXTRACT-NOT-EMPTY))
 (20 20 (:LINEAR LEN-WHEN-PREFIXP))
 (16 16 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$READY-OUT))
 (16 4 (:REWRITE TAKE-WHEN-ATOM))
 (12 12 (:REWRITE ADE::QUEUE3-L$RUN-PLUS))
 (10 10 (:REWRITE ADE::QUEUE3-L$INPUT-FORMAT-PLUS))
 (10 10 (:LINEAR ADE::A-HELPFUL-LEMMA-FOR-TREE-INDUCTIONS))
 (4 4 (:TYPE-PRESCRIPTION NFIX))
 (4 4 (:TYPE-PRESCRIPTION NATP))
 (3 3 (:TYPE-PRESCRIPTION ADE::QUEUE3-L$RUN))
 )
(ADE::QUEUE3-L$FUNCTIONALLY-CORRECT
 (80 32 (:REWRITE APPEND-WHEN-NOT-CONSP))
 (80 4 (:DEFINITION ADE::QUEUE3-L$IN-SEQ))
 (76 4 (:DEFINITION ADE::QUEUE3-L$OUT-SEQ))
 (44 44 (:TYPE-PRESCRIPTION ZP))
 (30 30 (:REWRITE ZP-OPEN))
 (24 24 (:REWRITE DEFAULT-CDR))
 (24 24 (:REWRITE DEFAULT-CAR))
 (20 5 (:REWRITE ADE::OPEN-QUEUE3-L$INPUT-FORMAT-N-ZP))
 (20 5 (:REWRITE ADE::OPEN-QUEUE3-L$INPUT-FORMAT-N))
 (12 3 (:REWRITE ADE::OPEN-QUEUE3-L$RUN-ZP))
 (12 3 (:REWRITE ADE::OPEN-QUEUE3-L$RUN))
 (12 3 (:REWRITE ADE::OPEN-DE-N-ZP))
 (12 3 (:REWRITE ADE::OPEN-DE-N))
 (8 8 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$OUT-ACT))
 (8 8 (:TYPE-PRESCRIPTION ADE::BOOLEANP-QUEUE3-L$IN-ACT))
 (8 8 (:REWRITE DEFAULT-+-2))
 (8 8 (:REWRITE DEFAULT-+-1))
 (8 8 (:REWRITE APPEND-ATOM-UNDER-LIST-EQUIV))
 (4 4 (:REWRITE ADE::QUEUE3-L$EXTRACT-LEMMA-1))
 (3 3 (:TYPE-PRESCRIPTION ADE::QUEUE3-L$RUN))
 (3 3 (:TYPE-PRESCRIPTION ADE::DE-N))
 )
