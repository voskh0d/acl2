(ABNF::RULENAMES-FROM-SINGULAR-CONC-AND-REP
 (74 1 (:DEFINITION ABNF::RULENAMES-FROM-SINGULAR-CONC-AND-REP))
 (42 3 (:REWRITE ABNF::0-WHEN-MATCH-REPEAT-RANGE-0))
 (23 5 (:REWRITE FTY::RESERRP-WHEN-RESERR-OPTIONP))
 (19 19 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 2))
 (19 19 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 1))
 (18 11 (:REWRITE DEFAULT-CAR))
 (16 2 (:REWRITE FTY::RESERR-OPTIONP-WHEN-RESERRP))
 (15 12 (:REWRITE DEFAULT-CDR))
 (15 3 (:DEFINITION STRING-LISTP))
 (9 9 (:REWRITE-QUOTED-CONSTANT NFIX-UNDER-NAT-EQUIV))
 (8 8 (:REWRITE ABNF::REPETITIONP-WHEN-MEMBER-EQUAL-OF-CONCATENATIONP))
 (8 8 (:REWRITE ABNF::CONCATENATIONP-WHEN-SUBSETP-EQUAL))
 (8 4 (:REWRITE ABNF::CONCATENATIONP-WHEN-NOT-CONSP))
 (6 6 (:TYPE-PRESCRIPTION FTY::RESERR-OPTIONP))
 (6 3 (:REWRITE DEFAULT-+-2))
 (4 2 (:REWRITE ABNF::ALTERNATIONP-WHEN-NOT-CONSP))
 (3 3 (:TYPE-PRESCRIPTION ABNF::REPEAT-RANGE))
 (3 3 (:REWRITE SUBSETP-TRANS2))
 (3 3 (:REWRITE SUBSETP-TRANS))
 (3 3 (:REWRITE DEFAULT-+-1))
 (2 1 (:REWRITE STR-FIX-WHEN-STRINGP))
 )
(ABNF::STRING-LIST-RESULTP-OF-RULENAMES-FROM-SINGULAR-CONC-AND-REP
 (320 20 (:REWRITE ABNF::REPETITIONP-OF-CAR-WHEN-CONCATENATIONP))
 (269 157 (:REWRITE DEFAULT-CAR))
 (266 19 (:REWRITE ABNF::0-WHEN-MATCH-REPEAT-RANGE-0))
 (152 152 (:TYPE-PRESCRIPTION ABNF::REPETITION->RANGE$INLINE))
 (140 140 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 2))
 (140 140 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 1))
 (120 20 (:REWRITE ABNF::CONCATENATIONP-OF-CAR-WHEN-ALTERNATIONP))
 (93 73 (:REWRITE DEFAULT-CDR))
 (60 20 (:REWRITE ABNF::CONCATENATIONP-WHEN-NOT-CONSP))
 (57 57 (:REWRITE-QUOTED-CONSTANT NFIX-UNDER-NAT-EQUIV))
 (54 27 (:REWRITE DEFAULT-+-2))
 (40 40 (:REWRITE ABNF::REPETITIONP-WHEN-MEMBER-EQUAL-OF-CONCATENATIONP))
 (40 40 (:REWRITE ABNF::CONCATENATIONP-WHEN-SUBSETP-EQUAL))
 (40 40 (:REWRITE ABNF::CONCATENATIONP-WHEN-MEMBER-EQUAL-OF-ALTERNATIONP))
 (40 40 (:REWRITE ABNF::ALTERNATIONP-WHEN-SUBSETP-EQUAL))
 (27 27 (:REWRITE DEFAULT-+-1))
 (20 20 (:REWRITE ABNF::ALTERNATIONP-WHEN-NOT-CONSP))
 (19 19 (:TYPE-PRESCRIPTION ABNF::REPEAT-RANGE))
 )
(ABNF::RULE-SIMPLE-SUBS
 (106 6 (:REWRITE ABNF::RULEP-WHEN-MEMBER-EQUAL-OF-RULELISTP))
 (59 3 (:DEFINITION MEMBER-EQUAL))
 (58 6 (:REWRITE SUBSETP-CAR-MEMBER))
 (19 19 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 2))
 (19 19 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 1))
 (18 6 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (15 15 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (10 6 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (7 7 (:REWRITE SUBSETP-TRANS2))
 (7 7 (:REWRITE SUBSETP-TRANS))
 (6 6 (:REWRITE SUBSETP-MEMBER . 2))
 (6 6 (:REWRITE SUBSETP-MEMBER . 1))
 (6 4 (:REWRITE DEFAULT-CAR))
 (6 2 (:REWRITE ABNF::RULELISTP-WHEN-NOT-CONSP))
 (5 5 (:REWRITE DEFAULT-CDR))
 (4 2 (:REWRITE DEFAULT-+-2))
 (2 2 (:REWRITE DEFAULT-+-1))
 )
(ABNF::STRING-LIST-RESULTP-OF-RULE-SIMPLE-SUBS)
