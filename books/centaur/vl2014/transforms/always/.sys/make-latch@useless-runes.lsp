(VL2014::VL-MAKE-1-BIT-LATCH-INSTANCES-FN
 (355 19 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (47 19 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (42 42 (:REWRITE SUBSETP-TRANS2))
 (42 42 (:REWRITE SUBSETP-TRANS))
 (42 42 (:REWRITE DEFAULT-CDR))
 (40 40 (:REWRITE SUBSETP-MEMBER . 2))
 (40 40 (:REWRITE SUBSETP-MEMBER . 1))
 (40 40 (:REWRITE DEFAULT-CAR))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEITEM-ALIST-P . 2))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEITEM-ALIST-P . 1))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEDEF-ALIST-P . 2))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEDEF-ALIST-P . 1))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-PREFIXMAP-P . 2))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-PREFIXMAP-P . 1))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-NAMESET-P . 2))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-NAMESET-P . 1))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-MODITEM-ALIST-P . 2))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-MODITEM-ALIST-P . 1))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-IMPORTRESULT-ALIST-P . 2))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-IMPORTRESULT-ALIST-P . 1))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-GENCASELIST-P . 2))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-GENCASELIST-P . 1))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-COMMENTMAP-P . 2))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-COMMENTMAP-P . 1))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-CASELIST-P . 2))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-CASELIST-P . 1))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-ATTS-P . 2))
 (31 31 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-ATTS-P . 1))
 (31 31 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-TRUELIST-ALISTP . 2))
 (31 31 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-TRUELIST-ALISTP . 1))
 (31 31 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 2))
 (31 31 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 1))
 (31 31 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-TRUELIST-ALISTP . 2))
 (31 31 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-TRUELIST-ALISTP . 1))
 (31 31 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-SYMBOL-ALISTP . 2))
 (31 31 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-SYMBOL-ALISTP . 1))
 (18 10 (:REWRITE DEFAULT-+-2))
 (14 14 (:REWRITE VL2014::VL-EXPRLIST-P-WHEN-MEMBER-EQUAL-OF-VL-EXPRLISTLIST-P))
 (10 10 (:REWRITE DEFAULT-+-1))
 (7 1 (:REWRITE SUBSETP-IMPLIES-SUBSETP-CDR))
 (4 4 (:REWRITE VL2014::VL-EXPRLIST-P-WHEN-NOT-CONSP))
 (4 4 (:LINEAR LOWER-BOUND-OF-LEN-WHEN-SUBLISTP))
 (4 4 (:LINEAR LISTPOS-UPPER-BOUND-STRONG-2))
 (4 4 (:LINEAR LEN-WHEN-PREFIXP))
 (2 2 (:LINEAR STR::COUNT-LEADING-CHARSET-LEN))
 (2 1 (:REWRITE STR::EXPLODE-WHEN-NOT-STRINGP))
 (1 1 (:REWRITE DEFAULT-<-2))
 (1 1 (:REWRITE DEFAULT-<-1))
 )
(VL2014::VL-MODINSTLIST-P-OF-VL-MAKE-1-BIT-LATCH-INSTANCES
 (290 10 (:REWRITE VL2014::VL-MODINSTLIST-P-WHEN-NOT-CONSP))
 (121 9 (:REWRITE DEFAULT-CDR))
 (96 3 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (96 3 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (51 1 (:REWRITE SUBSETP-OF-CONS))
 (42 1 (:DEFINITION MEMBER-EQUAL))
 (31 3 (:REWRITE DEFAULT-CAR))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEITEM-ALIST-P . 2))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEITEM-ALIST-P . 1))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEDEF-ALIST-P . 2))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEDEF-ALIST-P . 1))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-PREFIXMAP-P . 2))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-PREFIXMAP-P . 1))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-NAMESET-P . 2))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-NAMESET-P . 1))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-MODITEM-ALIST-P . 2))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-MODITEM-ALIST-P . 1))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-IMPORTRESULT-ALIST-P . 2))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-IMPORTRESULT-ALIST-P . 1))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-GENCASELIST-P . 2))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-GENCASELIST-P . 1))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-COMMENTMAP-P . 2))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-COMMENTMAP-P . 1))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-CASELIST-P . 2))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-CASELIST-P . 1))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-ATTS-P . 2))
 (28 28 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-ATTS-P . 1))
 (28 28 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-TRUELIST-ALISTP . 2))
 (28 28 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-TRUELIST-ALISTP . 1))
 (28 28 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 2))
 (28 28 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 1))
 (28 28 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-TRUELIST-ALISTP . 2))
 (28 28 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-TRUELIST-ALISTP . 1))
 (28 28 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-SYMBOL-ALISTP . 2))
 (28 28 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-SYMBOL-ALISTP . 1))
 (10 6 (:REWRITE DEFAULT-+-2))
 (8 6 (:REWRITE DEFAULT-+-1))
 (6 6 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (6 6 (:REWRITE SUBSETP-TRANS2))
 (6 6 (:REWRITE SUBSETP-TRANS))
 (6 6 (:REWRITE RATIONALP-IMPLIES-ACL2-NUMBERP))
 (4 1 (:REWRITE VL2014::VL-MODINST-P-BY-TAG-WHEN-VL-MODITEM-P))
 (3 1 (:REWRITE VL2014::TAG-WHEN-VL-OPINFO-P))
 (2 2 (:REWRITE SUBSETP-MEMBER . 2))
 (2 2 (:REWRITE SUBSETP-MEMBER . 1))
 (2 1 (:REWRITE STR::EXPLODE-WHEN-NOT-STRINGP))
 (1 1 (:TYPE-PRESCRIPTION STR::STRINGP-OF-NAT-TO-DEC-STRING))
 (1 1 (:TYPE-PRESCRIPTION VL2014::BOOLEANP-OF-VL-OPINFO-P))
 (1 1 (:REWRITE-QUOTED-CONSTANT VL2014::VL-MODULE-FIX-UNDER-VL-MODULE-EQUIV))
 (1 1 (:REWRITE-QUOTED-CONSTANT VL2014::VL-MAYBE-MODULE-FIX-UNDER-VL-MAYBE-MODULE-EQUIV))
 (1 1 (:REWRITE-QUOTED-CONSTANT VL2014::VL-LOCATION-FIX-UNDER-VL-LOCATION-EQUIV))
 (1 1 (:REWRITE-QUOTED-CONSTANT VL2014::VL-EXPRLIST-FIX-UNDER-VL-EXPRLIST-EQUIV))
 )
(VL2014::VL-MAKE-N-BIT-LATCH
 (136 1 (:DEFINITION BINARY-APPEND))
 (76 3 (:REWRITE VL2014::VL-PORTLIST-P-WHEN-VL-REGULARPORTLIST-P))
 (61 6 (:REWRITE VL2014::VL-REGULARPORTLIST-P-OF-CONS))
 (53 3 (:REWRITE VL2014::VL-PORTLIST-P-WHEN-VL-INTERFACEPORTLIST-P))
 (38 4 (:REWRITE VL2014::VL-INTERFACEPORTLIST-P-OF-CONS))
 (37 3 (:REWRITE DEFAULT-CDR))
 (37 3 (:REWRITE DEFAULT-CAR))
 (24 12 (:REWRITE VL2014::TAG-WHEN-VL-OPINFO-P))
 (16 16 (:REWRITE DEFAULT-+-2))
 (16 16 (:REWRITE DEFAULT-+-1))
 (16 4 (:REWRITE STR::CONSP-OF-EXPLODE))
 (14 14 (:REWRITE VL2014::VL-REGULARPORT-P-WHEN-MEMBER-EQUAL-OF-VL-REGULARPORTLIST-P))
 (12 12 (:TYPE-PRESCRIPTION VL2014::BOOLEANP-OF-VL-OPINFO-P))
 (12 12 (:REWRITE VL2014::VL-REGULARPORTLIST-P-WHEN-SUBSETP-EQUAL))
 (11 7 (:REWRITE VL2014::VL-REGULARPORT-P-BY-TAG-WHEN-VL-PORT-P))
 (11 7 (:REWRITE VL2014::VL-REGULARPORT-P-BY-TAG-WHEN-VL-CTXELEMENT-P))
 (10 10 (:TYPE-PRESCRIPTION VL2014::VL-REGULARPORT-P))
 (8 8 (:REWRITE VL2014::VL-INTERFACEPORTLIST-P-WHEN-SUBSETP-EQUAL))
 (7 7 (:REWRITE DEFAULT-<-2))
 (7 7 (:REWRITE DEFAULT-<-1))
 (7 3 (:REWRITE VL2014::VL-INTERFACEPORT-P-BY-TAG-WHEN-VL-SCOPEITEM-P))
 (7 3 (:REWRITE VL2014::VL-INTERFACEPORT-P-BY-TAG-WHEN-VL-PORT-P))
 (7 3 (:REWRITE VL2014::VL-INTERFACEPORT-P-BY-TAG-WHEN-VL-CTXELEMENT-P))
 (6 6 (:REWRITE VL2014::VL-VARDECLLIST-P-WHEN-SUBSETP-EQUAL))
 (6 6 (:REWRITE VL2014::VL-REGULARPORTLIST-P-WHEN-NOT-CONSP))
 (6 6 (:REWRITE VL2014::VL-PORTLIST-P-WHEN-SUBSETP-EQUAL))
 (6 6 (:REWRITE VL2014::VL-PORTDECLLIST-P-WHEN-SUBSETP-EQUAL))
 (6 6 (:REWRITE VL2014::VL-INTERFACEPORT-P-WHEN-MEMBER-EQUAL-OF-VL-INTERFACEPORTLIST-P))
 (6 2 (:REWRITE VL2014::VL-VARDECL-P-BY-TAG-WHEN-VL-MODITEM-P))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEITEM-ALIST-P . 2))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEITEM-ALIST-P . 1))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEDEF-ALIST-P . 2))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEDEF-ALIST-P . 1))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-PREFIXMAP-P . 2))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-PREFIXMAP-P . 1))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-NAMESET-P . 2))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-NAMESET-P . 1))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-MODITEM-ALIST-P . 2))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-MODITEM-ALIST-P . 1))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-IMPORTRESULT-ALIST-P . 2))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-IMPORTRESULT-ALIST-P . 1))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-GENCASELIST-P . 2))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-GENCASELIST-P . 1))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-COMMENTMAP-P . 2))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-COMMENTMAP-P . 1))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-CASELIST-P . 2))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-CASELIST-P . 1))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-ATTS-P . 2))
 (5 5 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-ATTS-P . 1))
 (5 5 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-TRUELIST-ALISTP . 2))
 (5 5 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-TRUELIST-ALISTP . 1))
 (5 5 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 2))
 (5 5 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 1))
 (5 5 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-TRUELIST-ALISTP . 2))
 (5 5 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-TRUELIST-ALISTP . 1))
 (5 5 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-SYMBOL-ALISTP . 2))
 (5 5 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-SYMBOL-ALISTP . 1))
 (4 4 (:TYPE-PRESCRIPTION VL2014::VL-INTERFACEPORT-P))
 (4 4 (:REWRITE VL2014::VL-MAYBE-STRING-LISTP-WHEN-SUBSETP-EQUAL))
 (4 4 (:REWRITE VL2014::VL-INTERFACEPORTLIST-P-WHEN-NOT-CONSP))
 (4 4 (:REWRITE STR::NAT-TO-DEC-STRING-NONEMPTY))
 (4 2 (:REWRITE STR::EXPLODE-WHEN-NOT-STRINGP))
 (3 3 (:TYPE-PRESCRIPTION VL2014::VL-REGULARPORTLIST-P))
 (3 3 (:TYPE-PRESCRIPTION VL2014::VL-INTERFACEPORTLIST-P))
 (3 3 (:REWRITE VL2014::VL-VARDECLLIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL2014::VL-PORTLIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL2014::VL-PORTDECLLIST-P-WHEN-NOT-CONSP))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::VL-MAYBE-DIRECTION-FIX-UNDER-VL-MAYBE-DIRECTION-EQUIV))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::VL-DIRECTION-FIX-UNDER-VL-DIRECTION-EQUIV))
 (2 2 (:REWRITE-QUOTED-CONSTANT NFIX-UNDER-NAT-EQUIV))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::MAYBE-STRING-FIX-UNDER-MAYBE-STRING-EQUIV))
 (2 2 (:REWRITE VL2014::VL-MAYBE-STRING-LISTP-WHEN-NOT-CONSP))
 (2 2 (:REWRITE SUBSETP-MEMBER . 4))
 (2 2 (:REWRITE SUBSETP-MEMBER . 3))
 (2 2 (:REWRITE SUBSETP-MEMBER . 2))
 (2 2 (:REWRITE SUBSETP-MEMBER . 1))
 (2 2 (:REWRITE VL2014::STRING-LISTP-WHEN-MEMBER-EQUAL-OF-STRING-LIST-LISTP))
 (2 2 (:REWRITE INTERSECTP-MEMBER . 3))
 (2 2 (:REWRITE INTERSECTP-MEMBER . 2))
 )
(VL2014::VL-MODULELIST-P-OF-VL-MAKE-N-BIT-LATCH
 (410 3 (:DEFINITION BINARY-APPEND))
 (107 5 (:REWRITE DEFAULT-CDR))
 (107 5 (:REWRITE DEFAULT-CAR))
 (44 11 (:REWRITE STR::CONSP-OF-EXPLODE))
 (29 2 (:REWRITE VL2014::VL-MODULE-P-BY-TAG-WHEN-VL-SCOPE-P))
 (25 25 (:TYPE-PRESCRIPTION STR::STRINGP-OF-NAT-TO-DEC-STRING))
 (22 2 (:REWRITE VL2014::VL-MODULE-P-BY-TAG-WHEN-VL-SCOPEDEF-P))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEITEM-ALIST-P . 2))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEITEM-ALIST-P . 1))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEDEF-ALIST-P . 2))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEDEF-ALIST-P . 1))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-PREFIXMAP-P . 2))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-PREFIXMAP-P . 1))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-NAMESET-P . 2))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-NAMESET-P . 1))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-MODITEM-ALIST-P . 2))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-MODITEM-ALIST-P . 1))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-IMPORTRESULT-ALIST-P . 2))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-IMPORTRESULT-ALIST-P . 1))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-GENCASELIST-P . 2))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-GENCASELIST-P . 1))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-COMMENTMAP-P . 2))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-COMMENTMAP-P . 1))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-CASELIST-P . 2))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-CASELIST-P . 1))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-ATTS-P . 2))
 (14 14 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-ATTS-P . 1))
 (14 14 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-TRUELIST-ALISTP . 2))
 (14 14 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-TRUELIST-ALISTP . 1))
 (14 14 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 2))
 (14 14 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 1))
 (14 14 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-TRUELIST-ALISTP . 2))
 (14 14 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-TRUELIST-ALISTP . 1))
 (14 14 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-SYMBOL-ALISTP . 2))
 (14 14 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-SYMBOL-ALISTP . 1))
 (11 11 (:REWRITE STR::NAT-TO-DEC-STRING-NONEMPTY))
 (10 10 (:REWRITE-QUOTED-CONSTANT VL2014::VL-MAYBE-DIRECTION-FIX-UNDER-VL-MAYBE-DIRECTION-EQUIV))
 (10 10 (:REWRITE-QUOTED-CONSTANT VL2014::VL-DIRECTION-FIX-UNDER-VL-DIRECTION-EQUIV))
 (10 10 (:REWRITE-QUOTED-CONSTANT VL2014::MAYBE-STRING-FIX-UNDER-MAYBE-STRING-EQUIV))
 (8 4 (:REWRITE STR::EXPLODE-WHEN-NOT-STRINGP))
 (6 4 (:REWRITE DEFAULT-+-2))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-LOCATION-FIX-UNDER-VL-LOCATION-EQUIV))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-GENELEMENTLIST-FIX-UNDER-VL-GENELEMENTLIST-EQUIV))
 (4 4 (:REWRITE-QUOTED-CONSTANT NFIX-UNDER-NAT-EQUIV))
 (4 4 (:REWRITE VL2014::VL-MODULELIST-P-WHEN-SUBSETP-EQUAL))
 (4 4 (:REWRITE DEFAULT-+-1))
 (4 4 (:REWRITE APPEND-ATOM-UNDER-LIST-EQUIV))
 (3 1 (:REWRITE VL2014::VL-SCOPEDEF-P-WHEN-VL-UDP-P))
 (3 1 (:REWRITE VL2014::VL-SCOPEDEF-P-WHEN-VL-PROGRAM-P))
 (3 1 (:REWRITE VL2014::VL-SCOPEDEF-P-WHEN-VL-MODULE-P))
 (3 1 (:REWRITE VL2014::VL-SCOPEDEF-P-WHEN-VL-INTERFACE-P))
 (3 1 (:REWRITE VL2014::VL-SCOPE-P-WHEN-VL-SCOPEINFO-P))
 (3 1 (:REWRITE VL2014::VL-SCOPE-P-WHEN-VL-PACKAGE-P))
 (3 1 (:REWRITE VL2014::VL-SCOPE-P-WHEN-VL-MODULE-P))
 (3 1 (:REWRITE VL2014::VL-SCOPE-P-WHEN-VL-INTERFACE-P))
 (3 1 (:REWRITE VL2014::VL-SCOPE-P-WHEN-VL-GENBLOB-P))
 (3 1 (:REWRITE VL2014::VL-SCOPE-P-WHEN-VL-DESIGN-P))
 (3 1 (:REWRITE VL2014::VL-SCOPE-P-WHEN-VL-BLOCKSCOPE-P))
 (2 2 (:TYPE-PRESCRIPTION VL2014::VL-SCOPEDEF-P))
 (2 2 (:TYPE-PRESCRIPTION VL2014::VL-SCOPE-P))
 (2 2 (:TYPE-PRESCRIPTION VL2014::VL-INTERFACE-P))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::VL-WARNINGLIST-FIX-UNDER-VL-WARNINGLIST-EQUIV))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::VL-VARDECLLIST-FIX-UNDER-VL-VARDECLLIST-EQUIV))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::VL-TASKDECLLIST-FIX-UNDER-VL-TASKDECLLIST-EQUIV))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::VL-PORTLIST-FIX-UNDER-VL-PORTLIST-EQUIV))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::VL-PORTDECLLIST-FIX-UNDER-VL-PORTDECLLIST-EQUIV))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::VL-PARAMDECLLIST-FIX-UNDER-VL-PARAMDECLLIST-EQUIV))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::VL-INITIALLIST-FIX-UNDER-VL-INITIALLIST-EQUIV))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::VL-IMPORTLIST-FIX-UNDER-VL-IMPORTLIST-EQUIV))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::VL-GENVARLIST-FIX-UNDER-VL-GENVARLIST-EQUIV))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::VL-GATEINSTLIST-FIX-UNDER-VL-GATEINSTLIST-EQUIV))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::VL-FUNDECLLIST-FIX-UNDER-VL-FUNDECLLIST-EQUIV))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::VL-COMMENTMAP-FIX-UNDER-VL-COMMENTMAP-EQUIV))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::VL-ATTS-FIX-UNDER-VL-ATTS-EQUIV))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::VL-ASSIGNLIST-FIX-UNDER-VL-ASSIGNLIST-EQUIV))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::VL-ALWAYSLIST-FIX-UNDER-VL-ALWAYSLIST-EQUIV))
 (2 2 (:REWRITE-QUOTED-CONSTANT VL2014::VL-ALIASLIST-FIX-UNDER-VL-ALIASLIST-EQUIV))
 (2 2 (:REWRITE VL2014::VL-SCOPEDEF-P-WHEN-MEMBER-EQUAL-OF-VL-SCOPEDEFLIST-P))
 (2 2 (:REWRITE VL2014::VL-MODULELIST-P-WHEN-NOT-CONSP))
 (2 2 (:REWRITE VL2014::VL-MODULE-P-WHEN-MEMBER-EQUAL-OF-VL-MODULELIST-P))
 (2 2 (:REWRITE VL2014::TAG-OF-VL-MODULE))
 (2 2 (:REWRITE RATIONALP-IMPLIES-ACL2-NUMBERP))
 (1 1 (:TYPE-PRESCRIPTION VL2014::VL-UDP-P))
 (1 1 (:TYPE-PRESCRIPTION VL2014::VL-SCOPEINFO-P))
 (1 1 (:TYPE-PRESCRIPTION VL2014::VL-PROGRAM-P))
 (1 1 (:TYPE-PRESCRIPTION VL2014::VL-PACKAGE-P))
 (1 1 (:TYPE-PRESCRIPTION VL2014::VL-GENBLOB-P))
 (1 1 (:TYPE-PRESCRIPTION VL2014::VL-DESIGN-P))
 (1 1 (:TYPE-PRESCRIPTION VL2014::VL-BLOCKSCOPE-P))
 (1 1 (:TYPE-PRESCRIPTION STRING-APPEND-LST))
 (1 1 (:REWRITE-QUOTED-CONSTANT VL2014::VL-VARDECL-FIX-UNDER-VL-VARDECL-EQUIV))
 (1 1 (:REWRITE-QUOTED-CONSTANT VL2014::VL-PORTDECL-FIX-UNDER-VL-PORTDECL-EQUIV))
 (1 1 (:REWRITE-QUOTED-CONSTANT VL2014::VL-PORT-FIX-UNDER-VL-PORT-EQUIV))
 )
(VL2014::TYPE-OF-VL-MAKE-N-BIT-LATCH)
(VL2014::VL-MAKE-N-BIT-LATCH-VEC
 (962 7 (:DEFINITION BINARY-APPEND))
 (305 5 (:REWRITE VL2014::VL-ASSIGN-P-BY-TAG-WHEN-VL-CTXELEMENT-P))
 (285 5 (:REWRITE VL2014::VL-ASSIGN-P-BY-TAG-WHEN-VL-MODELEMENT-P))
 (263 23 (:REWRITE DEFAULT-CDR))
 (257 17 (:REWRITE DEFAULT-CAR))
 (152 6 (:REWRITE VL2014::VL-PORTLIST-P-WHEN-VL-REGULARPORTLIST-P))
 (122 12 (:REWRITE VL2014::VL-REGULARPORTLIST-P-OF-CONS))
 (112 28 (:REWRITE STR::CONSP-OF-EXPLODE))
 (106 6 (:REWRITE VL2014::VL-PORTLIST-P-WHEN-VL-INTERFACEPORTLIST-P))
 (76 8 (:REWRITE VL2014::VL-INTERFACEPORTLIST-P-OF-CONS))
 (54 27 (:REWRITE VL2014::TAG-WHEN-VL-OPINFO-P))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEITEM-ALIST-P . 2))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEITEM-ALIST-P . 1))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEDEF-ALIST-P . 2))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEDEF-ALIST-P . 1))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-PREFIXMAP-P . 2))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-PREFIXMAP-P . 1))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-NAMESET-P . 2))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-NAMESET-P . 1))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-MODITEM-ALIST-P . 2))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-MODITEM-ALIST-P . 1))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-IMPORTRESULT-ALIST-P . 2))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-IMPORTRESULT-ALIST-P . 1))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-GENCASELIST-P . 2))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-GENCASELIST-P . 1))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-COMMENTMAP-P . 2))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-COMMENTMAP-P . 1))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-CASELIST-P . 2))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-CASELIST-P . 1))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-ATTS-P . 2))
 (35 35 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-ATTS-P . 1))
 (35 35 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-TRUELIST-ALISTP . 2))
 (35 35 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-TRUELIST-ALISTP . 1))
 (35 35 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 2))
 (35 35 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 1))
 (35 35 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-TRUELIST-ALISTP . 2))
 (35 35 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-TRUELIST-ALISTP . 1))
 (35 35 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-SYMBOL-ALISTP . 2))
 (35 35 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-SYMBOL-ALISTP . 1))
 (31 31 (:REWRITE-QUOTED-CONSTANT VL2014::MAYBE-STRING-FIX-UNDER-MAYBE-STRING-EQUIV))
 (28 28 (:REWRITE VL2014::VL-REGULARPORT-P-WHEN-MEMBER-EQUAL-OF-VL-REGULARPORTLIST-P))
 (28 28 (:REWRITE STR::NAT-TO-DEC-STRING-NONEMPTY))
 (27 27 (:TYPE-PRESCRIPTION VL2014::BOOLEANP-OF-VL-OPINFO-P))
 (25 25 (:TYPE-PRESCRIPTION VL2014::VL-REGULARPORT-P))
 (24 24 (:REWRITE VL2014::VL-REGULARPORTLIST-P-WHEN-SUBSETP-EQUAL))
 (22 14 (:REWRITE VL2014::VL-REGULARPORT-P-BY-TAG-WHEN-VL-PORT-P))
 (22 14 (:REWRITE VL2014::VL-REGULARPORT-P-BY-TAG-WHEN-VL-CTXELEMENT-P))
 (22 11 (:REWRITE STR::EXPLODE-WHEN-NOT-STRINGP))
 (21 7 (:REWRITE VL2014::VL-VARDECL-P-BY-TAG-WHEN-VL-MODITEM-P))
 (20 20 (:REWRITE-QUOTED-CONSTANT VL2014::VL-MAYBE-DIRECTION-FIX-UNDER-VL-MAYBE-DIRECTION-EQUIV))
 (20 20 (:REWRITE-QUOTED-CONSTANT VL2014::VL-DIRECTION-FIX-UNDER-VL-DIRECTION-EQUIV))
 (20 20 (:REWRITE VL2014::VL-EXPRLIST-P-WHEN-SUBSETP-EQUAL))
 (20 20 (:REWRITE VL2014::VL-EXPRLIST-P-WHEN-MEMBER-EQUAL-OF-VL-EXPRLISTLIST-P))
 (20 8 (:REWRITE APPEND-ATOM-UNDER-LIST-EQUIV))
 (18 18 (:REWRITE VL2014::VL-VARDECLLIST-P-WHEN-SUBSETP-EQUAL))
 (18 2 (:REWRITE VL2014::VL-EXPR-P-WHEN-VL-MAYBE-EXPR-P))
 (17 17 (:REWRITE-QUOTED-CONSTANT VL2014::VL-LOCATION-FIX-UNDER-VL-LOCATION-EQUIV))
 (16 16 (:REWRITE VL2014::VL-INTERFACEPORTLIST-P-WHEN-SUBSETP-EQUAL))
 (15 5 (:REWRITE VL2014::VL-MODELEMENT-P-WHEN-VL-VARDECL-P))
 (15 5 (:REWRITE VL2014::VL-MODELEMENT-P-WHEN-VL-TYPEDEF-P))
 (15 5 (:REWRITE VL2014::VL-MODELEMENT-P-WHEN-VL-TASKDECL-P))
 (15 5 (:REWRITE VL2014::VL-MODELEMENT-P-WHEN-VL-PORTDECL-P))
 (15 5 (:REWRITE VL2014::VL-MODELEMENT-P-WHEN-VL-PARAMDECL-P))
 (15 5 (:REWRITE VL2014::VL-MODELEMENT-P-WHEN-VL-MODPORT-P))
 (15 5 (:REWRITE VL2014::VL-MODELEMENT-P-WHEN-VL-MODINST-P))
 (15 5 (:REWRITE VL2014::VL-MODELEMENT-P-WHEN-VL-INITIAL-P))
 (15 5 (:REWRITE VL2014::VL-MODELEMENT-P-WHEN-VL-IMPORT-P))
 (15 5 (:REWRITE VL2014::VL-MODELEMENT-P-WHEN-VL-GENVAR-P))
 (15 5 (:REWRITE VL2014::VL-MODELEMENT-P-WHEN-VL-GATEINST-P))
 (15 5 (:REWRITE VL2014::VL-MODELEMENT-P-WHEN-VL-FWDTYPEDEF-P))
 (15 5 (:REWRITE VL2014::VL-MODELEMENT-P-WHEN-VL-FUNDECL-P))
 (15 5 (:REWRITE VL2014::VL-MODELEMENT-P-WHEN-VL-ASSIGN-P))
 (15 5 (:REWRITE VL2014::VL-MODELEMENT-P-WHEN-VL-ALWAYS-P))
 (15 5 (:REWRITE VL2014::VL-MODELEMENT-P-WHEN-VL-ALIAS-P))
 (15 5 (:REWRITE VL2014::VL-CTXELEMENT-P-WHEN-VL-VARDECL-P))
 (15 5 (:REWRITE VL2014::VL-CTXELEMENT-P-WHEN-VL-TYPEDEF-P))
 (15 5 (:REWRITE VL2014::VL-CTXELEMENT-P-WHEN-VL-TASKDECL-P))
 (15 5 (:REWRITE VL2014::VL-CTXELEMENT-P-WHEN-VL-REGULARPORT-P))
 (15 5 (:REWRITE VL2014::VL-CTXELEMENT-P-WHEN-VL-PORTDECL-P))
 (15 5 (:REWRITE VL2014::VL-CTXELEMENT-P-WHEN-VL-PARAMDECL-P))
 (15 5 (:REWRITE VL2014::VL-CTXELEMENT-P-WHEN-VL-MODPORT-P))
 (15 5 (:REWRITE VL2014::VL-CTXELEMENT-P-WHEN-VL-MODINST-P))
 (15 5 (:REWRITE VL2014::VL-CTXELEMENT-P-WHEN-VL-INTERFACEPORT-P))
 (15 5 (:REWRITE VL2014::VL-CTXELEMENT-P-WHEN-VL-INITIAL-P))
 (15 5 (:REWRITE VL2014::VL-CTXELEMENT-P-WHEN-VL-IMPORT-P))
 (15 5 (:REWRITE VL2014::VL-CTXELEMENT-P-WHEN-VL-GENELEMENT-P))
 (15 5 (:REWRITE VL2014::VL-CTXELEMENT-P-WHEN-VL-GATEINST-P))
 (15 5 (:REWRITE VL2014::VL-CTXELEMENT-P-WHEN-VL-FWDTYPEDEF-P))
 (15 5 (:REWRITE VL2014::VL-CTXELEMENT-P-WHEN-VL-FUNDECL-P))
 (15 5 (:REWRITE VL2014::VL-CTXELEMENT-P-WHEN-VL-ASSIGN-P))
 (15 5 (:REWRITE VL2014::VL-CTXELEMENT-P-WHEN-VL-ALWAYS-P))
 (15 5 (:REWRITE VL2014::VL-CTXELEMENT-P-WHEN-VL-ALIAS-P))
 (14 6 (:REWRITE VL2014::VL-INTERFACEPORT-P-BY-TAG-WHEN-VL-SCOPEITEM-P))
 (14 6 (:REWRITE VL2014::VL-INTERFACEPORT-P-BY-TAG-WHEN-VL-PORT-P))
 (14 6 (:REWRITE VL2014::VL-INTERFACEPORT-P-BY-TAG-WHEN-VL-CTXELEMENT-P))
 (13 13 (:TYPE-PRESCRIPTION VL2014::VL-INTERFACEPORT-P))
 (12 12 (:REWRITE VL2014::VL-REGULARPORTLIST-P-WHEN-NOT-CONSP))
 (12 12 (:REWRITE VL2014::VL-PORTLIST-P-WHEN-SUBSETP-EQUAL))
 (12 12 (:REWRITE VL2014::VL-PORTDECLLIST-P-WHEN-SUBSETP-EQUAL))
 (12 12 (:REWRITE VL2014::VL-MAYBE-STRING-LISTP-WHEN-SUBSETP-EQUAL))
 (12 12 (:REWRITE VL2014::VL-INTERFACEPORT-P-WHEN-MEMBER-EQUAL-OF-VL-INTERFACEPORTLIST-P))
 (12 8 (:REWRITE DEFAULT-+-2))
 (10 10 (:TYPE-PRESCRIPTION VL2014::VL-VARDECL-P))
 (10 10 (:TYPE-PRESCRIPTION VL2014::VL-TYPEDEF-P))
 (10 10 (:TYPE-PRESCRIPTION VL2014::VL-TASKDECL-P))
 (10 10 (:TYPE-PRESCRIPTION VL2014::VL-PORTDECL-P))
 (10 10 (:TYPE-PRESCRIPTION VL2014::VL-PARAMDECL-P))
 (10 10 (:TYPE-PRESCRIPTION VL2014::VL-MODPORT-P))
 (10 10 (:TYPE-PRESCRIPTION VL2014::VL-MODINST-P))
 (10 10 (:TYPE-PRESCRIPTION VL2014::VL-MODELEMENT-P))
 (10 10 (:TYPE-PRESCRIPTION VL2014::VL-INITIAL-P))
 (10 10 (:TYPE-PRESCRIPTION VL2014::VL-IMPORT-P))
 (10 10 (:TYPE-PRESCRIPTION VL2014::VL-GATEINST-P))
 (10 10 (:TYPE-PRESCRIPTION VL2014::VL-FWDTYPEDEF-P))
 (10 10 (:TYPE-PRESCRIPTION VL2014::VL-FUNDECL-P))
 (10 10 (:TYPE-PRESCRIPTION VL2014::VL-CTXELEMENT-P))
 (10 10 (:TYPE-PRESCRIPTION VL2014::VL-ASSIGN-P))
 (10 10 (:TYPE-PRESCRIPTION VL2014::VL-ALWAYS-P))
 (10 10 (:TYPE-PRESCRIPTION VL2014::VL-ALIAS-P))
 (10 10 (:REWRITE ZP-OPEN))
 (10 10 (:REWRITE VL2014::VL-MODELEMENT-P-WHEN-MEMBER-EQUAL-OF-VL-MODELEMENTLIST-P))
 (10 10 (:REWRITE VL2014::VL-EXPRLIST-P-WHEN-NOT-CONSP))
 (10 10 (:REWRITE VL2014::VL-ASSIGNLIST-P-WHEN-SUBSETP-EQUAL))
 (10 10 (:REWRITE VL2014::VL-ASSIGN-P-WHEN-MEMBER-EQUAL-OF-VL-ASSIGNLIST-P))
 (10 10 (:REWRITE VL2014::TAG-OF-VL-ASSIGN))
 (9 9 (:REWRITE VL2014::VL-VARDECLLIST-P-WHEN-NOT-CONSP))
 (8 8 (:REWRITE-QUOTED-CONSTANT VL2014::VL-OP-FIX-UNDER-VL-OP-EQUIV))
 (8 8 (:REWRITE-QUOTED-CONSTANT VL2014::VL-ATTS-FIX-UNDER-VL-ATTS-EQUIV))
 (8 8 (:REWRITE VL2014::VL-INTERFACEPORTLIST-P-WHEN-NOT-CONSP))
 (8 8 (:REWRITE DEFAULT-<-2))
 (8 8 (:REWRITE DEFAULT-<-1))
 (8 8 (:REWRITE DEFAULT-+-1))
 (6 6 (:TYPE-PRESCRIPTION VL2014::VL-REGULARPORTLIST-P))
 (6 6 (:TYPE-PRESCRIPTION VL2014::VL-INTERFACEPORTLIST-P))
 (6 6 (:REWRITE-QUOTED-CONSTANT VL2014::VL-MAYBE-GATESTRENGTH-FIX-UNDER-VL-MAYBE-GATESTRENGTH-EQUIV))
 (6 6 (:REWRITE VL2014::VL-PORTLIST-P-WHEN-NOT-CONSP))
 (6 6 (:REWRITE VL2014::VL-PORTDECLLIST-P-WHEN-NOT-CONSP))
 (6 6 (:REWRITE VL2014::VL-MAYBE-STRING-LISTP-WHEN-NOT-CONSP))
 (6 6 (:REWRITE SUBSETP-MEMBER . 4))
 (6 6 (:REWRITE SUBSETP-MEMBER . 3))
 (6 6 (:REWRITE SUBSETP-MEMBER . 2))
 (6 6 (:REWRITE SUBSETP-MEMBER . 1))
 (6 6 (:REWRITE INTERSECTP-MEMBER . 3))
 (6 6 (:REWRITE INTERSECTP-MEMBER . 2))
 (5 5 (:TYPE-PRESCRIPTION VL2014::VL-GENVAR-P))
 (5 5 (:TYPE-PRESCRIPTION VL2014::VL-GENELEMENT-P))
 (5 5 (:REWRITE VL2014::VL-ASSIGNLIST-P-WHEN-NOT-CONSP))
 (4 4 (:TYPE-PRESCRIPTION VL2014::VL-MAYBE-EXPR-P))
 (4 4 (:TYPE-PRESCRIPTION LEN))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-MAYBE-GATEDELAY-FIX-UNDER-VL-MAYBE-GATEDELAY-EQUIV))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-MAYBE-EXPRTYPE-FIX-UNDER-VL-MAYBE-EXPRTYPE-EQUIV))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-EXPRLIST-FIX-UNDER-VL-EXPRLIST-EQUIV))
 (4 4 (:REWRITE VL2014::STRING-LISTP-WHEN-MEMBER-EQUAL-OF-STRING-LIST-LISTP))
 )
(VL2014::VL-MODULELIST-P-OF-VL-MAKE-N-BIT-LATCH-VEC
 (1234 9 (:DEFINITION BINARY-APPEND))
 (325 19 (:REWRITE DEFAULT-CDR))
 (325 19 (:REWRITE DEFAULT-CAR))
 (144 36 (:REWRITE STR::CONSP-OF-EXPLODE))
 (116 8 (:REWRITE VL2014::VL-MODULE-P-BY-TAG-WHEN-VL-SCOPE-P))
 (88 8 (:REWRITE VL2014::VL-MODULE-P-BY-TAG-WHEN-VL-SCOPEDEF-P))
 (81 81 (:TYPE-PRESCRIPTION STR::STRINGP-OF-NAT-TO-DEC-STRING))
 (61 13 (:REWRITE POS-FIX-WHEN-POSP))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEITEM-ALIST-P . 2))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEITEM-ALIST-P . 1))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEDEF-ALIST-P . 2))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEDEF-ALIST-P . 1))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-PREFIXMAP-P . 2))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-PREFIXMAP-P . 1))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-NAMESET-P . 2))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-NAMEDB-NAMESET-P . 1))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-MODITEM-ALIST-P . 2))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-MODITEM-ALIST-P . 1))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-IMPORTRESULT-ALIST-P . 2))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-IMPORTRESULT-ALIST-P . 1))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-GENCASELIST-P . 2))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-GENCASELIST-P . 1))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-COMMENTMAP-P . 2))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-COMMENTMAP-P . 1))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-CASELIST-P . 2))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-CASELIST-P . 1))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-ATTS-P . 2))
 (45 45 (:REWRITE VL2014::CONSP-WHEN-MEMBER-EQUAL-OF-VL-ATTS-P . 1))
 (45 45 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-TRUELIST-ALISTP . 2))
 (45 45 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-TRUELIST-ALISTP . 1))
 (45 45 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 2))
 (45 45 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 1))
 (45 45 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-TRUELIST-ALISTP . 2))
 (45 45 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-TRUELIST-ALISTP . 1))
 (45 45 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-SYMBOL-ALISTP . 2))
 (45 45 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-SYMBOL-ALISTP . 1))
 (36 36 (:REWRITE STR::NAT-TO-DEC-STRING-NONEMPTY))
 (30 30 (:REWRITE-QUOTED-CONSTANT VL2014::MAYBE-STRING-FIX-UNDER-MAYBE-STRING-EQUIV))
 (30 15 (:REWRITE STR::EXPLODE-WHEN-NOT-STRINGP))
 (26 26 (:REWRITE-QUOTED-CONSTANT VL2014::VL-LOCATION-FIX-UNDER-VL-LOCATION-EQUIV))
 (24 8 (:DEFINITION POSP))
 (23 6 (:REWRITE VL2014::VL-MODULELIST-P-WHEN-NOT-CONSP))
 (22 22 (:REWRITE-QUOTED-CONSTANT VL2014::VL-MAYBE-DIRECTION-FIX-UNDER-VL-MAYBE-DIRECTION-EQUIV))
 (22 22 (:REWRITE-QUOTED-CONSTANT VL2014::VL-DIRECTION-FIX-UNDER-VL-DIRECTION-EQUIV))
 (20 8 (:REWRITE APPEND-ATOM-UNDER-LIST-EQUIV))
 (18 18 (:REWRITE-QUOTED-CONSTANT VL2014::VL-ATTS-FIX-UNDER-VL-ATTS-EQUIV))
 (16 16 (:REWRITE VL2014::POSP-WHEN-MEMBER-EQUAL-OF-POS-LISTP))
 (13 12 (:REWRITE DEFAULT-<-1))
 (12 12 (:REWRITE VL2014::VL-MODULELIST-P-WHEN-SUBSETP-EQUAL))
 (12 12 (:REWRITE DEFAULT-<-2))
 (12 4 (:REWRITE VL2014::VL-SCOPEDEF-P-WHEN-VL-UDP-P))
 (12 4 (:REWRITE VL2014::VL-SCOPEDEF-P-WHEN-VL-PROGRAM-P))
 (12 4 (:REWRITE VL2014::VL-SCOPEDEF-P-WHEN-VL-MODULE-P))
 (12 4 (:REWRITE VL2014::VL-SCOPEDEF-P-WHEN-VL-INTERFACE-P))
 (12 4 (:REWRITE VL2014::VL-SCOPE-P-WHEN-VL-SCOPEINFO-P))
 (12 4 (:REWRITE VL2014::VL-SCOPE-P-WHEN-VL-PACKAGE-P))
 (12 4 (:REWRITE VL2014::VL-SCOPE-P-WHEN-VL-MODULE-P))
 (12 4 (:REWRITE VL2014::VL-SCOPE-P-WHEN-VL-INTERFACE-P))
 (12 4 (:REWRITE VL2014::VL-SCOPE-P-WHEN-VL-GENBLOB-P))
 (12 4 (:REWRITE VL2014::VL-SCOPE-P-WHEN-VL-DESIGN-P))
 (12 4 (:REWRITE VL2014::VL-SCOPE-P-WHEN-VL-BLOCKSCOPE-P))
 (10 10 (:REWRITE-QUOTED-CONSTANT VL2014::VL-MAYBE-GATESTRENGTH-FIX-UNDER-VL-MAYBE-GATESTRENGTH-EQUIV))
 (8 8 (:TYPE-PRESCRIPTION VL2014::VL-SCOPEDEF-P))
 (8 8 (:TYPE-PRESCRIPTION VL2014::VL-SCOPE-P))
 (8 8 (:TYPE-PRESCRIPTION VL2014::VL-INTERFACE-P))
 (8 8 (:TYPE-PRESCRIPTION STRING-APPEND-LST))
 (8 8 (:TYPE-PRESCRIPTION POSP))
 (8 8 (:REWRITE-QUOTED-CONSTANT VL2014::VL-OP-FIX-UNDER-VL-OP-EQUIV))
 (8 8 (:REWRITE-QUOTED-CONSTANT VL2014::VL-MAYBE-GATEDELAY-FIX-UNDER-VL-MAYBE-GATEDELAY-EQUIV))
 (8 8 (:REWRITE-QUOTED-CONSTANT VL2014::VL-MAYBE-EXPRTYPE-FIX-UNDER-VL-MAYBE-EXPRTYPE-EQUIV))
 (8 8 (:REWRITE-QUOTED-CONSTANT VL2014::VL-GENELEMENTLIST-FIX-UNDER-VL-GENELEMENTLIST-EQUIV))
 (8 8 (:REWRITE-QUOTED-CONSTANT VL2014::VL-EXPRLIST-FIX-UNDER-VL-EXPRLIST-EQUIV))
 (8 8 (:REWRITE VL2014::VL-SCOPEDEF-P-WHEN-MEMBER-EQUAL-OF-VL-SCOPEDEFLIST-P))
 (8 8 (:REWRITE VL2014::VL-MODULE-P-WHEN-MEMBER-EQUAL-OF-VL-MODULELIST-P))
 (8 8 (:REWRITE VL2014::TAG-OF-VL-MODULE))
 (8 4 (:REWRITE DEFAULT-+-2))
 (6 6 (:TYPE-PRESCRIPTION POSP-OF-POS-FIX))
 (4 4 (:TYPE-PRESCRIPTION VL2014::VL-UDP-P))
 (4 4 (:TYPE-PRESCRIPTION VL2014::VL-SCOPEINFO-P))
 (4 4 (:TYPE-PRESCRIPTION VL2014::VL-PROGRAM-P))
 (4 4 (:TYPE-PRESCRIPTION VL2014::VL-PACKAGE-P))
 (4 4 (:TYPE-PRESCRIPTION VL2014::VL-GENBLOB-P))
 (4 4 (:TYPE-PRESCRIPTION VL2014::VL-DESIGN-P))
 (4 4 (:TYPE-PRESCRIPTION VL2014::VL-BLOCKSCOPE-P))
 (4 4 (:TYPE-PRESCRIPTION VL2014::VL-ASSIGN))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-WARNINGLIST-FIX-UNDER-VL-WARNINGLIST-EQUIV))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-TASKDECLLIST-FIX-UNDER-VL-TASKDECLLIST-EQUIV))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-PORTLIST-FIX-UNDER-VL-PORTLIST-EQUIV))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-PORTDECLLIST-FIX-UNDER-VL-PORTDECLLIST-EQUIV))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-PARAMDECLLIST-FIX-UNDER-VL-PARAMDECLLIST-EQUIV))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-MODINSTLIST-FIX-UNDER-VL-MODINSTLIST-EQUIV))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-INITIALLIST-FIX-UNDER-VL-INITIALLIST-EQUIV))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-IMPORTLIST-FIX-UNDER-VL-IMPORTLIST-EQUIV))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-GENVARLIST-FIX-UNDER-VL-GENVARLIST-EQUIV))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-GATEINSTLIST-FIX-UNDER-VL-GATEINSTLIST-EQUIV))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-FUNDECLLIST-FIX-UNDER-VL-FUNDECLLIST-EQUIV))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-COMMENTMAP-FIX-UNDER-VL-COMMENTMAP-EQUIV))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-ALWAYSLIST-FIX-UNDER-VL-ALWAYSLIST-EQUIV))
 (4 4 (:REWRITE-QUOTED-CONSTANT VL2014::VL-ALIASLIST-FIX-UNDER-VL-ALIASLIST-EQUIV))
 (4 4 (:REWRITE DEFAULT-+-1))
 (3 3 (:TYPE-PRESCRIPTION VL2014::VL-OCCFORM-MKWIRE-FN))
 (3 3 (:REWRITE ZP-OPEN))
 (2 2 (:TYPE-PRESCRIPTION VL2014::VL-OCCFORM-MKPORT))
 (2 2 (:TYPE-PRESCRIPTION VL2014::VL-NONATOM))
 (2 2 (:TYPE-PRESCRIPTION STRINGP-OF-IMPLODE))
 (1 1 (:REWRITE RATIONALP-IMPLIES-ACL2-NUMBERP))
 )
(VL2014::TYPE-OF-VL-MAKE-N-BIT-LATCH-VEC)
