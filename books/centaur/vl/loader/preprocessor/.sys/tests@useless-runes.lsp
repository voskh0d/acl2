(VL::VL-PPS-DEFINES)
(VL::VL-PPS-DEFINE-FORMALS)
(VL::SIMPLE-TEST-DEFINES
 (3995 20 (:REWRITE VL::STRINGP-WHEN-TRUE-LISTP))
 (2541 162 (:REWRITE STRING-LISTP-WHEN-SUBSETP-EQUAL))
 (1479 29 (:REWRITE TRUE-LISTP-WHEN-ATOM))
 (1102 9 (:REWRITE STRINGP-OF-CAR-WHEN-STRING-LISTP))
 (1067 150 (:REWRITE SUBSETP-WHEN-ATOM-RIGHT))
 (977 25 (:REWRITE ALISTP-WHEN-HONS-DUPLICITY-ALIST-P))
 (966 73 (:REWRITE VL::STRING-LISTP-WHEN-NO-NILS-IN-VL-MAYBE-STRING-LISTP))
 (920 18 (:REWRITE TRUE-LISTP-OF-CAR-WHEN-TRUE-LIST-LISTP))
 (907 25 (:REWRITE ALISTP-WHEN-ATOM))
 (902 25 (:REWRITE HONS-DUPLICITY-ALIST-P-WHEN-NOT-CONSP))
 (881 150 (:REWRITE SUBSETP-WHEN-ATOM-LEFT))
 (750 9 (:DEFINITION TRUE-LIST-LISTP))
 (738 738 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-CONS-LISTP))
 (738 738 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-ATOM-LISTP))
 (722 73 (:REWRITE DEFAULT-CDR))
 (670 81 (:REWRITE STRING-LISTP-WHEN-NOT-CONSP))
 (641 58 (:REWRITE DEFAULT-CAR))
 (535 73 (:REWRITE VL::STRING-LISTP-WHEN-SUBSETP-EQUAL-OF-STRING-LISTP . 1))
 (507 8 (:REWRITE SUBSETP-OF-CONS))
 (453 235 (:TYPE-PRESCRIPTION TRUE-LISTP-MEMBER-EQUAL))
 (425 29 (:REWRITE TRUE-LISTP-WHEN-STRING-LISTP-REWRITE))
 (414 414 (:TYPE-PRESCRIPTION SUBSETP-EQUAL))
 (390 18 (:REWRITE VL::TRUE-LISTP-OF-CAR-WHEN-TRUE-LIST-LISTP))
 (387 29 (:REWRITE TRUE-LISTP-WHEN-SYMBOL-LISTP-REWRITE-BACKCHAIN-1))
 (367 106 (:REWRITE VL::MEMBER-EQUAL-WHEN-MEMBER-EQUAL-OF-CDR-UNDER-IFF))
 (349 40 (:REWRITE STRINGP-WHEN-MEMBER-EQUAL-OF-STRING-LISTP))
 (327 9 (:REWRITE VL::VL-DEFINES-P-WHEN-NOT-CONSP))
 (300 18 (:REWRITE VL::TRUE-LIST-LISTP-WHEN-NOT-CONSP))
 (269 29 (:REWRITE TRUE-LISTP-WHEN-CHARACTER-LISTP-REWRITE))
 (258 112 (:REWRITE ALIST-VALS-WHEN-ATOM))
 (252 11 (:REWRITE TRUE-LIST-LISTP-WHEN-NOT-CONSP))
 (240 45 (:REWRITE ALIST-KEYS-MEMBER-HONS-ASSOC-EQUAL))
 (237 107 (:REWRITE ALIST-KEYS-WHEN-ATOM))
 (205 205 (:TYPE-PRESCRIPTION TRUE-LISTP))
 (193 62 (:REWRITE VL::CONSP-OF-CAR-WHEN-VL-COMMENTMAP-P))
 (174 29 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (158 158 (:REWRITE SUBSETP-TRANS2))
 (158 158 (:REWRITE SUBSETP-TRANS))
 (158 43 (:REWRITE MEMBER-EQUAL-OF-ALIST-VALS-UNDER-IFF))
 (150 9 (:REWRITE MEMBER-WHEN-ATOM))
 (146 146 (:REWRITE VL::STRING-LISTP-WHEN-MEMBER-EQUAL-OF-STRING-LIST-LISTP))
 (124 62 (:REWRITE CONSP-OF-CAR-WHEN-CONS-LISTP))
 (124 62 (:REWRITE CONSP-OF-CAR-WHEN-ATOM-LISTP))
 (123 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-DEFINES-P . 1))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEITEM-ALIST-P . 2))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEITEM-ALIST-P . 1))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEDEF-ALIST-P . 2))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-SCOPEDEF-ALIST-P . 1))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-REPORTCARD-P . 2))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-REPORTCARD-P . 1))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-INCLUDESKIPS-P . 2))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-INCLUDESKIPS-P . 1))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-IMPORTRESULT-ALIST-P . 2))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-IMPORTRESULT-ALIST-P . 1))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-IFDEF-USE-MAP-P . 2))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-IFDEF-USE-MAP-P . 1))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-GENCASELIST-P . 2))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-GENCASELIST-P . 1))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-FUNCTION-SPECIALIZATION-MAP-P . 2))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-FUNCTION-SPECIALIZATION-MAP-P . 1))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-FILEMAP-P . 2))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-FILEMAP-P . 1))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-DIRXLIST-CACHE-P . 2))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-DIRXLIST-CACHE-P . 1))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-DIRXCACHE-P . 2))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-DIRXCACHE-P . 1))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-DIRLIST-CACHE-P . 2))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-DIRLIST-CACHE-P . 1))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-DIRCACHE-P . 2))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-DIRCACHE-P . 1))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-DEFINES-P . 2))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-DEF-USE-MAP-P . 2))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-DEF-USE-MAP-P . 1))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-COMMENTMAP-P . 2))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-COMMENTMAP-P . 1))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-CASELIST-P . 2))
 (116 116 (:REWRITE VL::CONSP-WHEN-MEMBER-EQUAL-OF-VL-CASELIST-P . 1))
 (116 116 (:REWRITE CONSP-BY-LEN))
 (106 106 (:REWRITE MEMBER-EQUAL-WHEN-ALL-EQUALP))
 (91 9 (:REWRITE HONS-ASSOC-EQUAL-OF-CONS))
 (80 40 (:REWRITE SYMBOL-LISTP-WHEN-SUBSETP-EQUAL))
 (73 73 (:REWRITE VL::STRING-LISTP-WHEN-SUBSETP-EQUAL-OF-STRING-LISTP . 2))
 (73 73 (:REWRITE FN-CHECK-DEF-FORMALS))
 (72 23 (:REWRITE HONS-RASSOC-EQUAL-WHEN-ATOM))
 (68 68 (:TYPE-PRESCRIPTION SET::SETP-TYPE))
 (68 34 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (63 63 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-TRUELIST-ALISTP . 2))
 (63 63 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-TRUELIST-ALISTP . 1))
 (63 63 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 2))
 (63 63 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-SYMBOL-SYMBOL-ALISTP . 1))
 (63 63 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-TRUELIST-ALISTP . 2))
 (63 63 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-TRUELIST-ALISTP . 1))
 (63 63 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-SYMBOL-ALISTP . 2))
 (63 63 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-KEYWORD-SYMBOL-ALISTP . 1))
 (60 21 (:REWRITE HONS-ASSOC-EQUAL-WHEN-ATOM))
 (60 20 (:REWRITE VL::SYMBOL-LISTP-WHEN-SUBSETP-EQUAL-OF-SYMBOL-LISTP . 1))
 (58 58 (:REWRITE VL::TRUE-LISTP-WHEN-MEMBER-EQUAL-OF-TRUE-LIST-LISTP))
 (58 58 (:REWRITE CAR-WHEN-ALL-EQUALP))
 (56 56 (:REWRITE VL::VL-COMMENTMAP-P-WHEN-SUBSETP-EQUAL))
 (50 50 (:TYPE-PRESCRIPTION HONS-DUPLICITY-ALIST-P))
 (50 50 (:TYPE-PRESCRIPTION HONS-ASSOC-EQUAL))
 (47 47 (:TYPE-PRESCRIPTION CONSP-MEMBER-EQUAL))
 (46 46 (:TYPE-PRESCRIPTION HONS-RASSOC-EQUAL-TYPE))
 (40 40 (:REWRITE VL::SYMBOL-LISTP-WHEN-MEMBER-EQUAL-OF-SYMBOL-LIST-LISTP))
 (40 40 (:REWRITE VL::SYMBOL-LISTP-OF-ALIST-VALS-OF-VL-FULL-KEYWORD-TABLE))
 (40 40 (:REWRITE CHARACTER-LISTP-WHEN-SUBSETP-EQUAL))
 (40 20 (:REWRITE SYMBOL-LISTP-WHEN-BOOLEAN-LISTP))
 (40 20 (:REWRITE STR::CHARACTER-LISTP-WHEN-OCT-DIGIT-CHAR-LIST*P))
 (40 20 (:REWRITE STR::CHARACTER-LISTP-WHEN-HEX-DIGIT-CHAR-LIST*P))
 (40 20 (:REWRITE STR::CHARACTER-LISTP-WHEN-DEC-DIGIT-CHAR-LIST*P))
 (36 36 (:REWRITE VL::TRUE-LIST-LISTP-WHEN-SUBSETP-EQUAL))
 (36 12 (:REWRITE VL::STRING-LISTP-OF-CAR-WHEN-STRING-LIST-LISTP))
 (34 34 (:TYPE-PRESCRIPTION SET::EMPTYP-TYPE))
 (34 34 (:REWRITE SET::IN-SET))
 (34 9 (:REWRITE SET::DOUBLE-CONTAINMENT))
 (32 32 (:REWRITE VL::ALISTP-WHEN-ALL-HAVE-LEN))
 (29 29 (:REWRITE TRUE-LISTP-WHEN-UNSIGNED-BYTE-LISTP))
 (29 29 (:REWRITE TRUE-LISTP-WHEN-SIGNED-BYTE-LISTP))
 (29 29 (:REWRITE TRUE-LISTP-WHEN-FUNCTION-SYMBOL-LISTP))
 (28 28 (:REWRITE VL::VL-COMMENTMAP-P-WHEN-NOT-CONSP))
 (25 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-DEFINES-P))
 (20 20 (:REWRITE TRUE-LISTP-OF-CDR-WHEN-MEMBER-EQUAL-OF-SYMBOL-TRUELIST-ALISTP))
 (20 20 (:REWRITE TRUE-LISTP-OF-CDR-WHEN-MEMBER-EQUAL-OF-KEYWORD-TRUELIST-ALISTP))
 (20 20 (:REWRITE VL::SYMBOL-LISTP-WHEN-SUBSETP-EQUAL-OF-SYMBOL-LISTP . 2))
 (20 20 (:REWRITE SYMBOL-LISTP-WHEN-NOT-CONSP))
 (20 20 (:REWRITE VL::STRINGP-OF-CDR-WHEN-MEMBER-EQUAL-OF-VL-FILEMAP-P))
 (20 20 (:REWRITE VL::STRINGP-OF-CDR-WHEN-MEMBER-EQUAL-OF-VL-COMMENTMAP-P))
 (20 20 (:REWRITE VL::STRING-LISTP-OF-CDR-WHEN-MEMBER-EQUAL-OF-VL-DIRXCACHE-P))
 (20 20 (:REWRITE CHARACTER-LISTP-WHEN-NOT-CONSP))
 (20 10 (:REWRITE SYMBOL-LISTP-OF-CDR-WHEN-SYMBOL-LISTP))
 (20 10 (:REWRITE STRING-LISTP-OF-CDR-WHEN-STRING-LISTP))
 (20 10 (:REWRITE CHARACTER-LISTP-OF-CDR-WHEN-CHARACTER-LISTP))
 (18 18 (:REWRITE VL::VL-DEFINES-P-WHEN-SUBSETP-EQUAL))
 (18 18 (:REWRITE SUBSETP-MEMBER . 2))
 (18 18 (:REWRITE SUBSETP-MEMBER . 1))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-VARDECL-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-UDP-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-TYPEDEF-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-TASKDECL-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-SCOPEITEM-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-SCOPEDEF-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-PROGRAM-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-PORTDECL-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-PARAMDECL-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-PACKAGE-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-MODULE-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-MODPORT-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-MODINST-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-INTERFACEPORT-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-INTERFACE-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-INCLUDESKIPS-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-IMPORTRESULT-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-IFDEF-USE-MAP-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-GENVAR-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-GENELEMENT-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-GATEINST-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-FUNDECL-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-FILEMAP-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-DPIIMPORT-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-DIRXLIST-CACHE-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-DIRXCACHE-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-DIRLIST-CACHE-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-DIRCACHE-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-DEF-USE-MAP-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-CONFIG-ALIST-P))
 (18 18 (:REWRITE VL::STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-VL-CLASS-ALIST-P))
 (18 9 (:REWRITE VL::SYMBOL-LISTP-OF-CAR-WHEN-SYMBOL-LIST-LISTP))
 (18 3 (:REWRITE TRUE-LISTP-OF-CDAR-WHEN-SYMBOL-TRUELIST-ALISTP))
 (18 3 (:REWRITE TRUE-LISTP-OF-CDAR-WHEN-KEYWORD-TRUELIST-ALISTP))
 (18 3 (:REWRITE VL::STRINGP-OF-CDAR-WHEN-VL-FILEMAP-P))
 (18 3 (:REWRITE VL::STRINGP-OF-CDAR-WHEN-VL-COMMENTMAP-P))
 (18 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-SCOPEITEM-ALIST-P))
 (18 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-SCOPEDEF-ALIST-P))
 (18 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-INCLUDESKIPS-P))
 (18 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-IMPORTRESULT-ALIST-P))
 (18 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-IFDEF-USE-MAP-P))
 (18 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-FILEMAP-P))
 (18 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-DIRXLIST-CACHE-P))
 (18 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-DIRXCACHE-P))
 (18 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-DIRLIST-CACHE-P))
 (18 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-DIRCACHE-P))
 (18 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-DEFINES-P))
 (18 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-DEF-USE-MAP-P))
 (12 12 (:REWRITE VL::VL-FILEMAP-P-WHEN-SUBSETP-EQUAL))
 (12 12 (:REWRITE CONSP-OF-CDR-BY-LEN))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-VARDECL-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-UDP-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-TYPEDEF-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-TASKDECL-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-PROGRAM-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-PORTDECL-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-PARAMDECL-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-PACKAGE-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-MODULE-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-MODPORT-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-MODINST-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-INTERFACEPORT-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-INTERFACE-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-GENVAR-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-GENELEMENT-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-GATEINST-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-FUNDECL-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-DPIIMPORT-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-CONFIG-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-CLASS-ALIST-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-CALL-NAMEDARGS-P))
 (12 3 (:REWRITE VL::STRINGP-OF-CAAR-WHEN-VL-ATTS-P))
 (9 9 (:REWRITE SUBSETP-MEMBER . 4))
 (9 9 (:REWRITE SUBSETP-MEMBER . 3))
 (9 9 (:REWRITE INTERSECTP-MEMBER . 3))
 (9 9 (:REWRITE INTERSECTP-MEMBER . 2))
 (9 9 (:META CANCEL_TIMES-EQUAL-CORRECT))
 (9 9 (:META CANCEL_PLUS-EQUAL-CORRECT))
 (8 8 (:REWRITE-QUOTED-CONSTANT VL::VL-LOCATION-FIX-UNDER-VL-LOCATION-EQUIV))
 (8 8 (:REWRITE-QUOTED-CONSTANT VL::VL-DEFINE-FORMALLIST-FIX-UNDER-VL-DEFINE-FORMALLIST-EQUIV))
 (8 8 (:REWRITE HONS-ASSOC-EQUAL-WHEN-FOUND-BY-FAL-FIND-ANY))
 (6 6 (:REWRITE VL::VL-SCOPEITEM-ALIST-P-WHEN-SUBSETP-EQUAL))
 (6 6 (:REWRITE VL::VL-SCOPEDEF-ALIST-P-WHEN-SUBSETP-EQUAL))
 (6 6 (:REWRITE VL::VL-INCLUDESKIPS-P-WHEN-SUBSETP-EQUAL))
 (6 6 (:REWRITE VL::VL-IMPORTRESULT-ALIST-P-WHEN-SUBSETP-EQUAL))
 (6 6 (:REWRITE VL::VL-IFDEF-USE-MAP-P-WHEN-SUBSETP-EQUAL))
 (6 6 (:REWRITE VL::VL-FILEMAP-P-WHEN-NOT-CONSP))
 (6 6 (:REWRITE VL::VL-DIRXLIST-CACHE-P-WHEN-SUBSETP-EQUAL))
 (6 6 (:REWRITE VL::VL-DIRXCACHE-P-WHEN-SUBSETP-EQUAL))
 (6 6 (:REWRITE VL::VL-DIRLIST-CACHE-P-WHEN-SUBSETP-EQUAL))
 (6 6 (:REWRITE VL::VL-DIRCACHE-P-WHEN-SUBSETP-EQUAL))
 (6 6 (:REWRITE VL::VL-DEF-USE-MAP-P-WHEN-SUBSETP-EQUAL))
 (6 6 (:REWRITE SYMBOL-TRUELIST-ALISTP-WHEN-SUBSETP-EQUAL))
 (6 6 (:REWRITE VL::STRING-LIST-LISTP-WHEN-SUBSETP-EQUAL))
 (6 6 (:REWRITE KEYWORD-TRUELIST-ALISTP-WHEN-SUBSETP-EQUAL))
 (6 3 (:REWRITE VL::VL-COMMENTMAP-P-OF-CDR-WHEN-VL-COMMENTMAP-P))
 (6 3 (:REWRITE VL::STRING-LISTP-OF-CDAR-WHEN-VL-DIRXCACHE-P))
 (4 2 (:REWRITE TRUE-LIST-LISTP-OF-CDR-WHEN-TRUE-LIST-LISTP))
 (4 2 (:REWRITE SUBSETP-CAR-MEMBER))
 (3 3 (:REWRITE VL::VL-VARDECL-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-UDP-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-TYPEDEF-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-TASKDECL-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-SCOPEITEM-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-SCOPEDEF-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-PROGRAM-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-PORTDECL-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-PARAMDECL-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-PACKAGE-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-MODULE-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-MODPORT-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-MODINST-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-INTERFACEPORT-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-INTERFACE-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-INCLUDESKIPS-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-IMPORTRESULT-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-IFDEF-USE-MAP-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-GENVAR-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-GENELEMENT-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-GATEINST-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-FUNDECL-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-DPIIMPORT-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-DIRXLIST-CACHE-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-DIRXCACHE-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-DIRLIST-CACHE-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-DIRCACHE-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-DEF-USE-MAP-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-CONFIG-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-CLASS-ALIST-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-CALL-NAMEDARGS-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::VL-ATTS-P-WHEN-NOT-CONSP))
 (3 3 (:REWRITE SYMBOL-TRUELIST-ALISTP-WHEN-NOT-CONSP))
 (3 3 (:REWRITE VL::STRING-LIST-LISTP-WHEN-NOT-CONSP))
 (3 3 (:REWRITE KEYWORD-TRUELIST-ALISTP-WHEN-NOT-CONSP))
 )
(VL::VL-DEFINES-P-OF-SIMPLE-TEST-DEFINES)
