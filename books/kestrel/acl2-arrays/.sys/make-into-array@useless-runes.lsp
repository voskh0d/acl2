(MAKE-INTO-ARRAY
 (10 2 (:REWRITE DEFAULT-+-2))
 (9 7 (:REWRITE BOUNDED-NATP-ALISTP-MONOTONE))
 (9 5 (:REWRITE DEFAULT-<-2))
 (9 5 (:REWRITE DEFAULT-<-1))
 (6 6 (:REWRITE MAX-KEY-WHEN-NOT-CONSP-CHEAP))
 (4 4 (:REWRITE DEFAULT-CDR))
 (4 1 (:REWRITE <-OF-MAX-KEY))
 (2 2 (:REWRITE DEFAULT-+-1))
 (1 1 (:REWRITE <-OF-+-ARG2-WHEN-NEGATIVE-CONSTANT))
 (1 1 (:REWRITE <-OF-+-ARG1-WHEN-NEGATIVE-CONSTANT))
 )
(DEFAULT-OF-MAKE-INTO-ARRAY
 (6 1 (:REWRITE DEFAULT-+-2))
 (5 1 (:REWRITE RATIONALP-IMPLIES-ACL2-NUMBERP))
 (4 1 (:REWRITE RATIONALP-OF-MAX-KEY))
 (2 2 (:TYPE-PRESCRIPTION NATP-ALISTP))
 (1 1 (:REWRITE NATP-ALISTP-WHEN-BOUNDED-NATP-ALISTP))
 (1 1 (:REWRITE MAX-KEY-WHEN-NOT-CONSP-CHEAP))
 (1 1 (:REWRITE DEFAULT-+-1))
 )
(ARRAY1P-OF-MAKE-INTO-ARRAY
 (10 2 (:REWRITE DEFAULT-+-2))
 (7 1 (:REWRITE BOUNDED-INTEGER-ALISTP-WHEN-BOUNDED-NATP-ALISTP))
 (5 5 (:REWRITE MAX-KEY-WHEN-NOT-CONSP-CHEAP))
 (4 1 (:DEFINITION NATP))
 (3 3 (:TYPE-PRESCRIPTION NATP))
 (2 2 (:REWRITE DEFAULT-CDR))
 (2 2 (:REWRITE DEFAULT-+-1))
 (2 2 (:REWRITE BOUNDED-NATP-ALISTP-MONOTONE))
 (2 2 (:DEFINITION ARRAY1P))
 (1 1 (:REWRITE DEFAULT-<-2))
 (1 1 (:REWRITE DEFAULT-<-1))
 )
(AREF1-OF-MAKE-INTO-ARRAY
 (14 2 (:DEFINITION ASSOC-EQUAL))
 (8 6 (:REWRITE DEFAULT-CAR))
 (6 2 (:REWRITE DEFAULT-<-2))
 (5 5 (:REWRITE DEFAULT-CDR))
 (4 4 (:REWRITE MAX-KEY-WHEN-NOT-CONSP-CHEAP))
 (4 1 (:REWRITE RATIONALP-IMPLIES-ACL2-NUMBERP))
 (3 1 (:REWRITE RATIONALP-OF-MAX-KEY))
 (2 2 (:REWRITE TRUE-LISTP-OF-CAR-WHEN-WHEN-BOUNDED-NATP-ALISTP))
 (2 2 (:REWRITE EQUAL-OF-NON-NATP-AND-CAAR-WHEN-WHEN-BOUNDED-NATP-ALISTP))
 (2 2 (:REWRITE DEFAULT-<-1))
 (2 1 (:DEFINITION TRUE-LISTP))
 (1 1 (:REWRITE DEFAULT-+-2))
 (1 1 (:REWRITE DEFAULT-+-1))
 (1 1 (:REWRITE BOUNDED-NATP-ALISTP-MONOTONE))
 )
(DIMENSIONS-OF-MAKE-INTO-ARRAY
 (12 2 (:REWRITE DEFAULT-+-2))
 (10 2 (:REWRITE RATIONALP-IMPLIES-ACL2-NUMBERP))
 (8 2 (:REWRITE RATIONALP-OF-MAX-KEY))
 (4 4 (:TYPE-PRESCRIPTION NATP-ALISTP))
 (2 2 (:REWRITE NATP-ALISTP-WHEN-BOUNDED-NATP-ALISTP))
 (2 2 (:REWRITE MAX-KEY-WHEN-NOT-CONSP-CHEAP))
 (2 2 (:REWRITE DEFAULT-CDR))
 (2 2 (:REWRITE DEFAULT-CAR))
 (2 2 (:REWRITE DEFAULT-+-1))
 )
(ALEN1-OF-MAKE-INTO-ARRAY
 (12 2 (:REWRITE DEFAULT-+-2))
 (10 2 (:REWRITE RATIONALP-IMPLIES-ACL2-NUMBERP))
 (8 2 (:REWRITE RATIONALP-OF-MAX-KEY))
 (4 4 (:TYPE-PRESCRIPTION NATP-ALISTP))
 (2 2 (:REWRITE NATP-ALISTP-WHEN-BOUNDED-NATP-ALISTP))
 (2 2 (:REWRITE MAX-KEY-WHEN-NOT-CONSP-CHEAP))
 (2 2 (:REWRITE DEFAULT-+-1))
 )
(MAKE-INTO-ARRAY-OF-NIL)
