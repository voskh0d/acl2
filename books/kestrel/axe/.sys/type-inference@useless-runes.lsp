(MAYBE-GET-TYPE-OF-VAL
 (60 1 (:DEFINITION NAT-LISTP))
 (41 1 (:DEFINITION NATP))
 (23 1 (:REWRITE USE-ALL-<-FOR-CAR))
 (20 2 (:DEFINITION LEN))
 (11 1 (:REWRITE USE-ALL-NATP-FOR-CAR))
 (11 1 (:REWRITE ALL-<-OF-0-WHEN-ALL-NATP))
 (8 4 (:REWRITE LEN-WHEN-DARGP-CHEAP))
 (8 2 (:REWRITE ALL-NATP-WHEN-NAT-LISTP))
 (7 4 (:REWRITE DEFAULT-<-1))
 (5 5 (:TYPE-PRESCRIPTION ALL-NATP))
 (4 4 (:TYPE-PRESCRIPTION DARGP))
 (4 4 (:REWRITE USE-ALL-<=-2))
 (4 4 (:REWRITE USE-ALL-<=))
 (4 4 (:REWRITE USE-ALL-<-2))
 (4 4 (:REWRITE USE-ALL-<))
 (4 4 (:REWRITE LEN-WHEN-PSEUDO-DAGP-AUX))
 (4 4 (:REWRITE LEN-WHEN-DARGP-LESS-THAN))
 (4 4 (:REWRITE LEN-WHEN-BOUNDED-DAG-EXPRP-AND-QUOTEP))
 (4 4 (:REWRITE DEFAULT-<-2))
 (4 4 (:REWRITE <-WHEN-BOUNDED-DARG-LISTP-GEN))
 (4 2 (:REWRITE DEFAULT-+-2))
 (4 2 (:REWRITE ALL-NATP-WHEN-NAT-LISTP-CHEAP))
 (4 1 (:REWRITE ALL-<-OF-0-WHEN-NAT-LISTP))
 (3 3 (:TYPE-PRESCRIPTION ALL-<))
 (3 3 (:REWRITE DEFAULT-CDR))
 (3 3 (:REWRITE <-OF-+-OF-1-STRENGTHEN))
 (2 2 (:REWRITE DEFAULT-+-1))
 (2 2 (:REWRITE ALL-NATP-WHEN-NOT-CONSP-CHEAP))
 (2 2 (:REWRITE ALL-NATP-WHEN-NOT-CONSP))
 (2 1 (:REWRITE INTEGERP-OF-CAR-WHEN-ALL-NATP-CHEAP))
 (2 1 (:REWRITE INTEGERP-OF-CAR-WHEN-ALL-INTEGERP-CHEAP))
 (2 1 (:REWRITE <-OF-CAR-WHEN-ALL-<-CHEAP))
 (1 1 (:REWRITE USE-ALL-NATP-2))
 (1 1 (:REWRITE USE-ALL-NATP))
 (1 1 (:REWRITE USE-ALL-CONSP-2))
 (1 1 (:REWRITE USE-ALL-CONSP))
 (1 1 (:REWRITE NOT-<-OF-CAR-WHEN-BOUNDED-DARG-LISTP-2))
 (1 1 (:REWRITE NONNEG-WHEN-DARGP-LESS-THAN))
 (1 1 (:REWRITE NATP-WHEN-BOUNDED-DARG-LISTP-GEN))
 (1 1 (:REWRITE INTEGERP-WHEN-DARGP-LESS-THAN))
 (1 1 (:REWRITE INTEGERP-OF-CAR-WHEN-BOUNDED-DARG-LISTP))
 (1 1 (:REWRITE DEFAULT-CAR))
 (1 1 (:REWRITE ALL-<-WHEN-NOT-CONSP-CHEAP))
 (1 1 (:REWRITE ALL-<-WHEN-NOT-CONSP))
 (1 1 (:REWRITE ALL-<-TRANSITIVE-FREE-2))
 (1 1 (:REWRITE ALL-<-TRANSITIVE-FREE))
 (1 1 (:REWRITE ALL-<-TRANSITIVE))
 )
(AXE-TYPEP-OF-MAYBE-GET-TYPE-OF-VAL
 (28 14 (:REWRITE LEN-WHEN-DARGP-CHEAP))
 (23 1 (:REWRITE USE-ALL-<-FOR-CAR))
 (16 8 (:REWRITE DEFAULT-+-2))
 (14 14 (:TYPE-PRESCRIPTION DARGP))
 (14 14 (:REWRITE LEN-WHEN-PSEUDO-DAGP-AUX))
 (14 14 (:REWRITE LEN-WHEN-DARGP-LESS-THAN))
 (14 14 (:REWRITE LEN-WHEN-BOUNDED-DAG-EXPRP-AND-QUOTEP))
 (11 1 (:REWRITE ALL-<-OF-0-WHEN-ALL-NATP))
 (9 9 (:REWRITE USE-ALL-CONSP-2))
 (9 9 (:REWRITE USE-ALL-CONSP))
 (9 9 (:REWRITE DEFAULT-CDR))
 (9 7 (:REWRITE DEFAULT-<-1))
 (8 8 (:REWRITE DEFAULT-+-1))
 (8 2 (:DEFINITION INTEGER-LENGTH))
 (7 7 (:REWRITE USE-ALL-<=-2))
 (7 7 (:REWRITE USE-ALL-<=))
 (7 7 (:REWRITE USE-ALL-<-2))
 (7 7 (:REWRITE USE-ALL-<))
 (7 7 (:REWRITE DEFAULT-<-2))
 (7 7 (:REWRITE <-WHEN-BOUNDED-DARG-LISTP-GEN))
 (5 5 (:REWRITE <-OF-+-OF-1-STRENGTHEN))
 (4 4 (:REWRITE USE-ALL-NATP-2))
 (4 4 (:REWRITE USE-ALL-NATP))
 (4 4 (:REWRITE NATP-WHEN-BOUNDED-DARG-LISTP-GEN))
 (4 2 (:REWRITE ALL-NATP-WHEN-NAT-LISTP-CHEAP))
 (4 1 (:REWRITE ALL-<-OF-0-WHEN-NAT-LISTP))
 (3 3 (:TYPE-PRESCRIPTION ALL-<))
 (3 3 (:REWRITE DEFAULT-CAR))
 (2 2 (:REWRITE NONNEG-WHEN-DARGP-LESS-THAN))
 (2 2 (:REWRITE INTEGERP-WHEN-DARGP-LESS-THAN))
 (2 2 (:REWRITE EQUAL-OF-CONSTANT-WHEN-SBVLT))
 (2 2 (:REWRITE EQUAL-CONSTANT-WHEN-NOT-SBVLT))
 (2 2 (:REWRITE EQUAL-CONSTANT-WHEN-BVCHOP-EQUAL-CONSTANT-FALSE))
 (2 2 (:REWRITE ALL-NATP-WHEN-NOT-CONSP-CHEAP))
 (2 2 (:REWRITE ALL-NATP-WHEN-NOT-CONSP))
 (2 1 (:REWRITE INTEGERP-OF-CAR-WHEN-ALL-NATP-CHEAP))
 (2 1 (:REWRITE INTEGERP-OF-CAR-WHEN-ALL-INTEGERP-CHEAP))
 (2 1 (:REWRITE <-OF-CAR-WHEN-ALL-<-CHEAP))
 (1 1 (:TYPE-PRESCRIPTION ALL-INTEGERP))
 (1 1 (:REWRITE NOT-<-OF-CAR-WHEN-BOUNDED-DARG-LISTP-2))
 (1 1 (:REWRITE INTEGERP-OF-CAR-WHEN-BOUNDED-DARG-LISTP))
 (1 1 (:REWRITE ALL-<-WHEN-NOT-CONSP-CHEAP))
 (1 1 (:REWRITE ALL-<-WHEN-NOT-CONSP))
 (1 1 (:REWRITE ALL-<-TRANSITIVE-FREE-2))
 (1 1 (:REWRITE ALL-<-TRANSITIVE-FREE))
 (1 1 (:REWRITE ALL-<-TRANSITIVE))
 )
(BV-ARRAY-TYPE-LEN-OF-MAYBE-GET-TYPE-OF-VAL-WHEN-BV-ARRAY-TYPEP
 (68 34 (:REWRITE LEN-WHEN-DARGP-CHEAP))
 (39 2 (:REWRITE USE-ALL-<-FOR-CAR))
 (34 34 (:TYPE-PRESCRIPTION DARGP))
 (34 34 (:REWRITE LEN-WHEN-PSEUDO-DAGP-AUX))
 (34 34 (:REWRITE LEN-WHEN-DARGP-LESS-THAN))
 (34 34 (:REWRITE LEN-WHEN-BOUNDED-DAG-EXPRP-AND-QUOTEP))
 (28 14 (:REWRITE DEFAULT-+-2))
 (18 2 (:REWRITE ALL-<-OF-0-WHEN-ALL-NATP))
 (16 16 (:REWRITE USE-ALL-CONSP-2))
 (16 16 (:REWRITE USE-ALL-CONSP))
 (16 16 (:REWRITE DEFAULT-CDR))
 (14 14 (:REWRITE DEFAULT-+-1))
 (14 10 (:REWRITE DEFAULT-<-1))
 (10 10 (:REWRITE USE-ALL-<=-2))
 (10 10 (:REWRITE USE-ALL-<=))
 (10 10 (:REWRITE USE-ALL-<-2))
 (10 10 (:REWRITE USE-ALL-<))
 (10 10 (:REWRITE DEFAULT-<-2))
 (10 10 (:REWRITE <-WHEN-BOUNDED-DARG-LISTP-GEN))
 (8 2 (:DEFINITION INTEGER-LENGTH))
 (7 7 (:REWRITE <-OF-+-OF-1-STRENGTHEN))
 (6 6 (:TYPE-PRESCRIPTION ALL-<))
 (6 4 (:REWRITE ALL-NATP-WHEN-NAT-LISTP-CHEAP))
 (5 5 (:REWRITE USE-ALL-NATP-2))
 (5 5 (:REWRITE USE-ALL-NATP))
 (5 5 (:REWRITE NATP-WHEN-BOUNDED-DARG-LISTP-GEN))
 (5 2 (:REWRITE ALL-<-OF-0-WHEN-NAT-LISTP))
 (4 4 (:REWRITE DEFAULT-CAR))
 (4 4 (:REWRITE ALL-NATP-WHEN-NOT-CONSP-CHEAP))
 (4 4 (:REWRITE ALL-NATP-WHEN-NOT-CONSP))
 (4 2 (:REWRITE INTEGERP-OF-CAR-WHEN-ALL-NATP-CHEAP))
 (4 2 (:REWRITE INTEGERP-OF-CAR-WHEN-ALL-INTEGERP-CHEAP))
 (4 2 (:REWRITE <-OF-CAR-WHEN-ALL-<-CHEAP))
 (3 3 (:REWRITE NONNEG-WHEN-DARGP-LESS-THAN))
 (3 3 (:REWRITE INTEGERP-WHEN-DARGP-LESS-THAN))
 (2 2 (:TYPE-PRESCRIPTION ALL-INTEGERP))
 (2 2 (:REWRITE NOT-<-OF-CAR-WHEN-BOUNDED-DARG-LISTP-2))
 (2 2 (:REWRITE INTEGERP-OF-CAR-WHEN-BOUNDED-DARG-LISTP))
 (2 2 (:REWRITE EQUAL-OF-CONSTANT-WHEN-SBVLT))
 (2 2 (:REWRITE EQUAL-CONSTANT-WHEN-NOT-SBVLT))
 (2 2 (:REWRITE EQUAL-CONSTANT-WHEN-BVCHOP-EQUAL-CONSTANT-FALSE))
 (2 2 (:REWRITE ALL-<-WHEN-NOT-CONSP-CHEAP))
 (2 2 (:REWRITE ALL-<-WHEN-NOT-CONSP))
 (2 2 (:REWRITE ALL-<-TRANSITIVE-FREE-2))
 (2 2 (:REWRITE ALL-<-TRANSITIVE-FREE))
 (2 2 (:REWRITE ALL-<-TRANSITIVE))
 (2 1 (:REWRITE NOT-BV-ARRAY-TYPEP-WHEN-BV-TYPEP-CHEAP))
 (1 1 (:TYPE-PRESCRIPTION BV-TYPEP))
 )
(GET-TYPE-OF-VAL-CHECKED)
(GET-TYPE-OF-VAL-SAFE)
(AXE-TYPEP-OF-GET-TYPE-OF-VAL-SAFE)
(MAYBE-GET-TYPE-OF-FUNCTION-CALL)
(AXE-TYPEP-OF-MAYBE-GET-TYPE-OF-FUNCTION-CALL
 (66 22 (:REWRITE DEFAULT-CAR))
 (63 63 (:REWRITE EQUAL-OF-CONSTANT-WHEN-SBVLT))
 (63 63 (:REWRITE EQUAL-CONSTANT-WHEN-NOT-SBVLT))
 (63 63 (:REWRITE EQUAL-CONSTANT-WHEN-BVCHOP-EQUAL-CONSTANT-FALSE))
 (36 12 (:REWRITE DEFAULT-CDR))
 (34 34 (:REWRITE USE-ALL-CONSP-2))
 (34 34 (:REWRITE USE-ALL-CONSP))
 (14 14 (:REWRITE USE-ALL-<=-2))
 (14 14 (:REWRITE USE-ALL-<=))
 (14 14 (:REWRITE USE-ALL-<-2))
 (14 14 (:REWRITE USE-ALL-<))
 (14 14 (:REWRITE DEFAULT-<-2))
 (14 14 (:REWRITE DEFAULT-<-1))
 (14 14 (:REWRITE <-WHEN-BOUNDED-DARG-LISTP-GEN))
 (8 8 (:REWRITE INTEGERP-WHEN-DARGP-LESS-THAN))
 (6 6 (:REWRITE <-OF-+-OF-1-STRENGTHEN))
 (4 4 (:REWRITE NONNEG-WHEN-DARGP-LESS-THAN))
 (2 2 (:REWRITE USE-ALL-NATP-2))
 (2 2 (:REWRITE USE-ALL-NATP))
 (2 2 (:REWRITE NATP-WHEN-BOUNDED-DARG-LISTP-GEN))
 )
(MAYBE-GET-TYPE-OF-NODENUM
 (181 181 (:TYPE-PRESCRIPTION POSP-OF-ALEN1))
 (62 62 (:TYPE-PRESCRIPTION TYPE-OF-AREF1-WHEN-PSEUDO-DAG-ARRAYP-AUX))
 (22 11 (:TYPE-PRESCRIPTION TRUE-LISTP-OF-DIMENSIONS-WHEN-ARRAY1P))
 (22 11 (:TYPE-PRESCRIPTION POSP-OF-CAR-OF-DIMENSIONS-WHEN-ARRAY1P))
 (12 6 (:TYPE-PRESCRIPTION SYMBOLP-OF-CAR-OF-AREF1))
 (11 4 (:REWRITE NOT-EQUAL-OF-CAR-AND-QUOTE-WHEN-LEN-WRONG-AND-PSEUDO-DAG-ARRAYP-AUX))
 (4 4 (:REWRITE QUOTE-LEMMA-FOR-BOUNDED-DARG-LISTP-GEN-ALT))
 (4 4 (:REWRITE EQUAL-OF-CONSTANT-WHEN-SBVLT))
 (4 4 (:REWRITE EQUAL-CONSTANT-WHEN-NOT-SBVLT))
 (4 4 (:REWRITE EQUAL-CONSTANT-WHEN-BVCHOP-EQUAL-CONSTANT-FALSE))
 (4 1 (:REWRITE PSEUDO-DAG-ARRAYP-AUX-WHEN-PSEUDO-DAGP-AUX))
 (3 3 (:REWRITE DEFAULT-CAR))
 (2 2 (:TYPE-PRESCRIPTION PSEUDO-DAGP-AUX))
 (2 2 (:REWRITE USE-ALL-CONSP-2))
 (2 2 (:REWRITE USE-ALL-CONSP))
 (2 2 (:REWRITE USE-ALL-<=-2))
 (2 2 (:REWRITE USE-ALL-<=))
 (2 2 (:REWRITE USE-ALL-<-2))
 (2 2 (:REWRITE USE-ALL-<))
 (2 2 (:REWRITE PSEUDO-DAG-ARRAYP-MONOTONE))
 (2 2 (:REWRITE NONNEG-WHEN-DARGP-LESS-THAN))
 (2 2 (:REWRITE LOOKUP-EQUAL-WHEN-NOT-CONSP-CHEAP))
 (2 2 (:REWRITE LOOKUP-EQUAL-WHEN-NOT-ASSOC-EQUAL-CHEAP))
 (2 2 (:REWRITE INTEGERP-WHEN-DARGP-LESS-THAN))
 (2 2 (:REWRITE DEFAULT-<-2))
 (2 2 (:REWRITE DEFAULT-<-1))
 (2 2 (:REWRITE DEFAULT-+-2))
 (2 2 (:REWRITE DEFAULT-+-1))
 (2 2 (:REWRITE <-WHEN-BOUNDED-DARG-LISTP-GEN))
 (1 1 (:REWRITE PSEUDO-DAGP-AUX-WHEN-NOT-CONSP-CHEAP))
 (1 1 (:REWRITE PSEUDO-DAG-ARRAYP-AUX-MONOTONE))
 (1 1 (:REWRITE DEFAULT-CDR))
 (1 1 (:REWRITE AREF1-WHEN-TOO-LARGE-CHEAP))
 )
(AXE-TYPEP-OF-MAYBE-GET-TYPE-OF-NODENUM
 (100 50 (:TYPE-PRESCRIPTION SYMBOLP-OF-CAR-OF-AREF1))
 (60 60 (:TYPE-PRESCRIPTION PSEUDO-DAG-ARRAYP-AUX))
 (53 53 (:TYPE-PRESCRIPTION TYPE-OF-AREF1-WHEN-PSEUDO-DAG-ARRAYP-AUX))
 (50 50 (:TYPE-PRESCRIPTION SYMBOLP-OF-CAR-OF-AREF1-WHEN-PSEUDO-DAG-ARRAYP))
 (40 5 (:REWRITE NOT-EQUAL-OF-CAR-AND-QUOTE-WHEN-LEN-WRONG-AND-PSEUDO-DAG-ARRAYP-AUX))
 (26 10 (:REWRITE DEFAULT-CAR))
 (20 10 (:REWRITE AREF1-WHEN-TOO-LARGE-CHEAP))
 (20 5 (:REWRITE PSEUDO-DAG-ARRAYP-AUX-WHEN-PSEUDO-DAGP-AUX))
 (10 10 (:TYPE-PRESCRIPTION PSEUDO-DAGP-AUX))
 (10 10 (:TYPE-PRESCRIPTION POSP-OF-ALEN1))
 (9 9 (:REWRITE USE-ALL-CONSP-2))
 (9 9 (:REWRITE USE-ALL-CONSP))
 (9 9 (:REWRITE LOOKUP-EQUAL-WHEN-NOT-CONSP-CHEAP))
 (9 9 (:REWRITE LOOKUP-EQUAL-WHEN-NOT-ASSOC-EQUAL-CHEAP))
 (5 5 (:REWRITE QUOTE-LEMMA-FOR-BOUNDED-DARG-LISTP-GEN-ALT))
 (5 5 (:REWRITE PSEUDO-DAGP-AUX-WHEN-NOT-CONSP-CHEAP))
 (5 5 (:REWRITE PSEUDO-DAG-ARRAYP-AUX-MONOTONE))
 (5 5 (:REWRITE EQUAL-OF-CONSTANT-WHEN-SBVLT))
 (5 5 (:REWRITE EQUAL-CONSTANT-WHEN-NOT-SBVLT))
 (5 5 (:REWRITE EQUAL-CONSTANT-WHEN-BVCHOP-EQUAL-CONSTANT-FALSE))
 (4 4 (:REWRITE DEFAULT-CDR))
 (4 4 (:REWRITE CONSP-OF-CDR-OF-AREF1-WHEN-PSEUDO-DAG-ARRAYP-AUX-AND-QUOTEP))
 (4 4 (:REWRITE CONSP-OF-CDR-OF-AREF1-WHEN-PSEUDO-DAG-ARRAYP))
 )
(GET-TYPE-OF-NODENUM-CHECKED
 (119 119 (:TYPE-PRESCRIPTION POSP-OF-ALEN1))
 (22 11 (:TYPE-PRESCRIPTION TRUE-LISTP-OF-DIMENSIONS-WHEN-ARRAY1P))
 (22 11 (:TYPE-PRESCRIPTION POSP-OF-CAR-OF-DIMENSIONS-WHEN-ARRAY1P))
 (2 2 (:TYPE-PRESCRIPTION TYPE-OF-AREF1-WHEN-PSEUDO-DAG-ARRAYP-AUX))
 (1 1 (:REWRITE USE-ALL-<=-2))
 (1 1 (:REWRITE USE-ALL-<=))
 (1 1 (:REWRITE USE-ALL-<-2))
 (1 1 (:REWRITE USE-ALL-<))
 (1 1 (:REWRITE PSEUDO-DAG-ARRAYP-MONOTONE))
 (1 1 (:REWRITE NONNEG-WHEN-DARGP-LESS-THAN))
 (1 1 (:REWRITE INTEGERP-WHEN-DARGP-LESS-THAN))
 (1 1 (:REWRITE DEFAULT-<-2))
 (1 1 (:REWRITE DEFAULT-<-1))
 (1 1 (:REWRITE DEFAULT-+-2))
 (1 1 (:REWRITE DEFAULT-+-1))
 (1 1 (:REWRITE <-WHEN-BOUNDED-DARG-LISTP-GEN))
 )
(GET-TYPE-OF-NODENUM-SAFE)
(AXE-TYPEP-OF-GET-TYPE-OF-NODENUM-SAFE)
(MAYBE-GET-TYPE-OF-ARG
 (176 176 (:TYPE-PRESCRIPTION POSP-OF-ALEN1))
 (114 114 (:TYPE-PRESCRIPTION TYPE-OF-AREF1-WHEN-PSEUDO-DAG-ARRAYP-AUX))
 (80 10 (:REWRITE NOT-EQUAL-OF-CAR-AND-QUOTE-WHEN-LEN-WRONG-AND-PSEUDO-DAG-ARRAYP-AUX))
 (40 10 (:REWRITE PSEUDO-DAG-ARRAYP-AUX-WHEN-PSEUDO-DAGP-AUX))
 (30 15 (:TYPE-PRESCRIPTION TRUE-LISTP-OF-DIMENSIONS-WHEN-ARRAY1P))
 (30 15 (:TYPE-PRESCRIPTION POSP-OF-CAR-OF-DIMENSIONS-WHEN-ARRAY1P))
 (24 12 (:TYPE-PRESCRIPTION SYMBOLP-OF-CAR-OF-AREF1))
 (20 20 (:TYPE-PRESCRIPTION PSEUDO-DAGP-AUX))
 (19 19 (:REWRITE DEFAULT-CAR))
 (14 14 (:REWRITE USE-ALL-CONSP-2))
 (14 14 (:REWRITE USE-ALL-CONSP))
 (10 10 (:REWRITE QUOTE-LEMMA-FOR-BOUNDED-DARG-LISTP-GEN-ALT))
 (10 10 (:REWRITE PSEUDO-DAGP-AUX-WHEN-NOT-CONSP-CHEAP))
 (10 10 (:REWRITE PSEUDO-DAG-ARRAYP-AUX-MONOTONE))
 (10 10 (:REWRITE EQUAL-OF-CONSTANT-WHEN-SBVLT))
 (10 10 (:REWRITE EQUAL-CONSTANT-WHEN-NOT-SBVLT))
 (10 10 (:REWRITE EQUAL-CONSTANT-WHEN-BVCHOP-EQUAL-CONSTANT-FALSE))
 (2 2 (:REWRITE USE-ALL-<=-2))
 (2 2 (:REWRITE USE-ALL-<=))
 (2 2 (:REWRITE USE-ALL-<-2))
 (2 2 (:REWRITE USE-ALL-<))
 (2 2 (:REWRITE PSEUDO-DAG-ARRAYP-MONOTONE))
 (2 2 (:REWRITE NONNEG-WHEN-DARGP-LESS-THAN))
 (2 2 (:REWRITE INTEGERP-WHEN-DARGP-LESS-THAN))
 (2 2 (:REWRITE DEFAULT-<-2))
 (2 2 (:REWRITE DEFAULT-<-1))
 (2 2 (:REWRITE DEFAULT-+-2))
 (2 2 (:REWRITE DEFAULT-+-1))
 (2 2 (:REWRITE <-WHEN-BOUNDED-DARG-LISTP-GEN))
 (1 1 (:REWRITE DEFAULT-CDR))
 (1 1 (:REWRITE AREF1-WHEN-TOO-LARGE-CHEAP))
 )
(GET-TYPE-OF-ARG-CHECKED)
(BV-ARRAY-TYPE-LEN-OF-GET-TYPE-OF-ARG-CHECKED-WHEN-BV-ARRAY-TYPEP
 (68 2 (:DEFINITION LEN))
 (26 2 (:REWRITE USE-ALL-CONSP-FOR-CAR))
 (12 2 (:REWRITE CONSP-OF-CAR-WHEN-PSEUDO-DAGP))
 (10 4 (:REWRITE ALL-CONSP-WHEN-NOT-CONSP))
 (10 2 (:REWRITE ALL-CONSP-OF-CDR))
 (9 3 (:REWRITE DEFAULT-CAR))
 (8 8 (:TYPE-PRESCRIPTION PSEUDO-DAGP))
 (8 8 (:TYPE-PRESCRIPTION ALL-CONSP))
 (8 8 (:REWRITE USE-ALL-CONSP-2))
 (8 8 (:REWRITE USE-ALL-CONSP))
 (8 4 (:REWRITE LEN-WHEN-DARGP-CHEAP))
 (7 7 (:REWRITE DEFAULT-CDR))
 (6 2 (:REWRITE PSEUDO-DAGP-OF-CDR-WHEN-PSEUDO-DAGP))
 (4 4 (:TYPE-PRESCRIPTION DARGP))
 (4 4 (:REWRITE LEN-WHEN-PSEUDO-DAGP-AUX))
 (4 4 (:REWRITE LEN-WHEN-DARGP-LESS-THAN))
 (4 4 (:REWRITE LEN-WHEN-BOUNDED-DAG-EXPRP-AND-QUOTEP))
 (4 4 (:REWRITE ALL-CONSP-WHEN-NOT-CONSP-CHEAP))
 (4 2 (:REWRITE DEFAULT-+-2))
 (2 2 (:REWRITE TRUE-LISTP-OF-CAR-WHEN-WHEN-BOUNDED-NATP-ALISTP))
 (2 2 (:REWRITE LEN-OF-CAR-WHEN-ITEMS-HAVE-LEN))
 (2 2 (:REWRITE DEFAULT-+-1))
 (2 2 (:REWRITE CONSP-OF-CAR-WHEN-PSEUDO-DAGP-AUX-2))
 (2 2 (:REWRITE CONSP-OF-CAR-WHEN-PSEUDO-DAGP-AUX))
 (2 1 (:REWRITE NOT-BV-ARRAY-TYPEP-WHEN-BV-TYPEP-CHEAP))
 (1 1 (:TYPE-PRESCRIPTION BV-TYPEP))
 )
(GET-TYPE-OF-ARG-SAFE)
(GET-TYPE-OF-NODENUM-DURING-CUTTING
 (223 223 (:TYPE-PRESCRIPTION POSP-OF-ALEN1))
 (103 103 (:TYPE-PRESCRIPTION TYPE-OF-AREF1-WHEN-PSEUDO-DAG-ARRAYP-AUX))
 (56 2 (:DEFINITION ASSOC-EQUAL))
 (47 21 (:REWRITE DEFAULT-CAR))
 (32 8 (:REWRITE USE-ALL-CONSP-FOR-CAR))
 (22 22 (:REWRITE USE-ALL-CONSP-2))
 (22 22 (:REWRITE USE-ALL-CONSP))
 (22 11 (:TYPE-PRESCRIPTION TRUE-LISTP-OF-DIMENSIONS-WHEN-ARRAY1P))
 (22 11 (:TYPE-PRESCRIPTION POSP-OF-CAR-OF-DIMENSIONS-WHEN-ARRAY1P))
 (20 8 (:REWRITE CONSP-OF-CAR-WHEN-PSEUDO-DAGP))
 (18 9 (:TYPE-PRESCRIPTION SYMBOLP-OF-CAR-OF-AREF1))
 (14 7 (:REWRITE NOT-EQUAL-OF-CAR-AND-QUOTE-WHEN-LEN-WRONG-AND-PSEUDO-DAG-ARRAYP-AUX))
 (12 12 (:TYPE-PRESCRIPTION PSEUDO-DAGP))
 (12 12 (:TYPE-PRESCRIPTION ALL-CONSP))
 (10 5 (:REWRITE ALISTP-WHEN-NODENUM-TYPE-ALISTP-CHEAP))
 (9 9 (:REWRITE EQUAL-OF-CONSTANT-WHEN-SBVLT))
 (9 9 (:REWRITE EQUAL-CONSTANT-WHEN-NOT-SBVLT))
 (9 9 (:REWRITE EQUAL-CONSTANT-WHEN-BVCHOP-EQUAL-CONSTANT-FALSE))
 (8 8 (:REWRITE TRUE-LISTP-OF-CAR-WHEN-WHEN-BOUNDED-NATP-ALISTP))
 (8 8 (:REWRITE DEFAULT-CDR))
 (8 8 (:REWRITE CONSP-OF-CAR-WHEN-PSEUDO-DAGP-AUX-2))
 (8 8 (:REWRITE CONSP-OF-CAR-WHEN-PSEUDO-DAGP-AUX))
 (7 7 (:REWRITE QUOTE-LEMMA-FOR-BOUNDED-DARG-LISTP-GEN-ALT))
 (6 6 (:REWRITE ALL-CONSP-WHEN-NOT-CONSP-CHEAP))
 (6 6 (:REWRITE ALL-CONSP-WHEN-NOT-CONSP))
 (5 5 (:TYPE-PRESCRIPTION NODENUM-TYPE-ALISTP))
 (5 5 (:REWRITE AREF1-WHEN-TOO-LARGE-CHEAP))
 (5 5 (:REWRITE ALISTP-WHEN-PSEUDO-DAGP-AUX))
 (5 5 (:REWRITE ALISTP-WHEN-BOUNDED-NATP-ALISTP))
 (4 4 (:REWRITE CAR-OF-CAR-WHEN-PSEUDO-DAGP-AUX))
 (4 4 (:REWRITE ASSOC-EQUAL-WHEN-PSEUDO-DAGP-AUX))
 (4 4 (:REWRITE ASSOC-EQUAL-WHEN-LOOKUP-EQUAL-CHEAP))
 (4 4 (:REWRITE ASSOC-EQUAL-WHEN-ARRAY1P-AND-OUT-OF-BOUNDS))
 (4 1 (:REWRITE PSEUDO-DAG-ARRAYP-AUX-WHEN-PSEUDO-DAGP-AUX))
 (3 3 (:REWRITE USE-ALL-<=-2))
 (3 3 (:REWRITE USE-ALL-<=))
 (3 3 (:REWRITE USE-ALL-<-2))
 (3 3 (:REWRITE USE-ALL-<))
 (3 3 (:REWRITE PSEUDO-DAG-ARRAYP-MONOTONE))
 (3 3 (:REWRITE NONNEG-WHEN-DARGP-LESS-THAN))
 (3 3 (:REWRITE INTEGERP-WHEN-DARGP-LESS-THAN))
 (3 3 (:REWRITE DEFAULT-<-2))
 (3 3 (:REWRITE DEFAULT-<-1))
 (3 3 (:REWRITE DEFAULT-+-2))
 (3 3 (:REWRITE DEFAULT-+-1))
 (3 3 (:REWRITE <-WHEN-BOUNDED-DARG-LISTP-GEN))
 (2 2 (:TYPE-PRESCRIPTION PSEUDO-DAGP-AUX))
 (2 2 (:REWRITE SYMBOLP-WHEN-BOUNDED-DAG-EXPRP))
 (2 2 (:REWRITE SYMBOLP-OF-CAR-WHEN-BOUNDED-DAG-EXPRP))
 (2 2 (:REWRITE EQUAL-OF-NON-NATP-AND-CAAR-WHEN-WHEN-BOUNDED-NATP-ALISTP))
 (1 1 (:REWRITE PSEUDO-DAGP-AUX-WHEN-NOT-CONSP-CHEAP))
 (1 1 (:REWRITE PSEUDO-DAG-ARRAYP-AUX-MONOTONE))
 )
(GET-TYPE-OF-ARG-DURING-CUTTING
 (78 78 (:TYPE-PRESCRIPTION POSP-OF-ALEN1))
 (23 1 (:DEFINITION SYMBOL-ALISTP))
 (5 1 (:REWRITE USE-ALL-CONSP-FOR-CAR))
 (3 3 (:REWRITE DEFAULT-CAR))
 (3 1 (:REWRITE CONSP-OF-CAR-WHEN-PSEUDO-DAGP))
 (2 2 (:TYPE-PRESCRIPTION PSEUDO-DAGP))
 (2 2 (:TYPE-PRESCRIPTION ALL-CONSP))
 (2 2 (:REWRITE USE-ALL-CONSP-2))
 (2 2 (:REWRITE USE-ALL-CONSP))
 (1 1 (:REWRITE USE-ALL-<=-2))
 (1 1 (:REWRITE USE-ALL-<=))
 (1 1 (:REWRITE USE-ALL-<-2))
 (1 1 (:REWRITE USE-ALL-<))
 (1 1 (:REWRITE TRUE-LISTP-OF-CAR-WHEN-WHEN-BOUNDED-NATP-ALISTP))
 (1 1 (:REWRITE SYMBOLP-WHEN-BOUNDED-DAG-EXPRP))
 (1 1 (:REWRITE SYMBOLP-OF-CAR-WHEN-BOUNDED-DAG-EXPRP))
 (1 1 (:REWRITE PSEUDO-DAG-ARRAYP-MONOTONE))
 (1 1 (:REWRITE NONNEG-WHEN-DARGP-LESS-THAN))
 (1 1 (:REWRITE MYQUOTEP-WHEN-DARGP-LESS-THAN))
 (1 1 (:REWRITE MYQUOTEP-WHEN-BOUNDED-DAG-EXPRP))
 (1 1 (:REWRITE INTEGERP-WHEN-DARGP-LESS-THAN))
 (1 1 (:REWRITE DEFAULT-CDR))
 (1 1 (:REWRITE DEFAULT-<-2))
 (1 1 (:REWRITE DEFAULT-<-1))
 (1 1 (:REWRITE DEFAULT-+-2))
 (1 1 (:REWRITE DEFAULT-+-1))
 (1 1 (:REWRITE CONSP-OF-CAR-WHEN-PSEUDO-DAGP-AUX-2))
 (1 1 (:REWRITE CONSP-OF-CAR-WHEN-PSEUDO-DAGP-AUX))
 (1 1 (:REWRITE CAR-OF-CAR-WHEN-PSEUDO-DAGP-AUX))
 (1 1 (:REWRITE ALL-CONSP-WHEN-NOT-CONSP-CHEAP))
 (1 1 (:REWRITE ALL-CONSP-WHEN-NOT-CONSP))
 (1 1 (:REWRITE <-WHEN-BOUNDED-DARG-LISTP-GEN))
 )
