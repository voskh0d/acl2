(BOOLEANP-OF-STRINGP-FOR-STRING-STRING-ALISTP-KEY-LEMMA)
(BOOLEANP-OF-STRINGP-FOR-STRING-STRING-ALISTP-VAL-LEMMA)
(STRINGP-OF-NIL-FOR-STRING-STRING-ALISTP-KEY-LEMMA)
(STRINGP-OF-NIL-FOR-STRING-STRING-ALISTP-VAL-LEMMA)
(BOOLEANP-OF-STRINGP-FOR-STRING-STRING-ALISTP-KEY)
(BOOLEANP-OF-STRINGP-FOR-STRING-STRING-ALISTP-VAL)
(STRING-STRING-ALISTP)
(STRING-STRING-ALISTP-OF-REVAPPEND)
(STRING-STRING-ALISTP-OF-REMOVE)
(STRING-STRING-ALISTP-OF-LAST)
(STRING-STRING-ALISTP-OF-NTHCDR)
(STRING-STRING-ALISTP-OF-BUTLAST)
(STRING-STRING-ALISTP-OF-UPDATE-NTH)
(STRING-STRING-ALISTP-OF-REPEAT)
(STRING-STRING-ALISTP-OF-TAKE)
(STRING-STRING-ALISTP-OF-UNION-EQUAL)
(STRING-STRING-ALISTP-OF-INTERSECTION-EQUAL-2)
(STRING-STRING-ALISTP-OF-INTERSECTION-EQUAL-1)
(STRING-STRING-ALISTP-OF-SET-DIFFERENCE-EQUAL)
(STRING-STRING-ALISTP-WHEN-SUBSETP-EQUAL)
(STRING-STRING-ALISTP-OF-RCONS)
(STRING-STRING-ALISTP-OF-APPEND)
(STRING-STRING-ALISTP-OF-REV)
(STRING-STRING-ALISTP-OF-DUPLICATED-MEMBERS)
(STRING-STRING-ALISTP-OF-DIFFERENCE)
(STRING-STRING-ALISTP-OF-INTERSECT-2)
(STRING-STRING-ALISTP-OF-INTERSECT-1)
(STRING-STRING-ALISTP-OF-UNION)
(STRING-STRING-ALISTP-OF-MERGESORT)
(STRING-STRING-ALISTP-OF-DELETE)
(STRING-STRING-ALISTP-OF-INSERT)
(STRING-STRING-ALISTP-OF-SFIX)
(STRING-STRING-ALISTP-OF-LIST-FIX)
(TRUE-LISTP-WHEN-STRING-STRING-ALISTP)
(STRING-STRING-ALISTP-WHEN-NOT-CONSP)
(STRING-STRING-ALISTP-OF-CDR-WHEN-STRING-STRING-ALISTP)
(STRING-STRING-ALISTP-OF-CONS)
(STRING-STRING-ALISTP-OF-MAKE-FAL
 (73 10 (:REWRITE STRING-STRING-ALISTP-OF-CDR-WHEN-STRING-STRING-ALISTP))
 (32 32 (:REWRITE STRING-STRING-ALISTP-WHEN-SUBSETP-EQUAL))
 (16 16 (:REWRITE STRING-STRING-ALISTP-WHEN-NOT-CONSP))
 (2 2 (:TYPE-PRESCRIPTION BOOLEANP-OF-STRINGP-FOR-STRING-STRING-ALISTP-VAL))
 )
(STRINGP-OF-CDR-WHEN-MEMBER-EQUAL-OF-STRING-STRING-ALISTP)
(STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-STRING-STRING-ALISTP)
(CONSP-WHEN-MEMBER-EQUAL-OF-STRING-STRING-ALISTP)
(STRING-STRING-ALISTP-OF-REMOVE-ASSOC)
(STRING-STRING-ALISTP-OF-PUT-ASSOC)
(STRING-STRING-ALISTP-OF-FAST-ALIST-CLEAN)
(STRING-STRING-ALISTP-OF-HONS-SHRINK-ALIST)
(STRING-STRING-ALISTP-OF-HONS-ACONS)
(STRINGP-OF-CDR-OF-HONS-ASSOC-EQUAL-WHEN-STRING-STRING-ALISTP)
(ALISTP-WHEN-STRING-STRING-ALISTP-REWRITE)
(ALISTP-WHEN-STRING-STRING-ALISTP)
(STRINGP-OF-CDAR-WHEN-STRING-STRING-ALISTP)
(STRINGP-OF-CAAR-WHEN-STRING-STRING-ALISTP)
(STRINGP-OF-CDR-OF-ASSOC-EQUAL-WHEN-STRING-STRING-ALISTP
 (146 116 (:REWRITE DEFAULT-CAR))
 (126 13 (:REWRITE STRINGP-OF-CAAR-WHEN-STRING-STRING-ALISTP))
 (116 18 (:REWRITE STRINGP-OF-CDAR-WHEN-STRING-STRING-ALISTP))
 (115 44 (:REWRITE STRINGP-OF-CDR-WHEN-MEMBER-EQUAL-OF-STRING-STRING-ALISTP))
 (79 48 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-STRING-STRING-ALISTP . 1))
 (58 58 (:REWRITE STRING-STRING-ALISTP-WHEN-SUBSETP-EQUAL))
 (56 5 (:DEFINITION MEMBER-EQUAL))
 (55 40 (:REWRITE DEFAULT-CDR))
 (53 53 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (48 48 (:REWRITE CONSP-WHEN-MEMBER-EQUAL-OF-STRING-STRING-ALISTP . 2))
 (26 26 (:REWRITE STRINGP-OF-CAR-WHEN-MEMBER-EQUAL-OF-STRING-STRING-ALISTP))
 (21 3 (:REWRITE STRING-STRING-ALISTP-OF-CDR-WHEN-STRING-STRING-ALISTP))
 (10 10 (:REWRITE SUBSETP-MEMBER . 2))
 (10 10 (:REWRITE SUBSETP-MEMBER . 1))
 (3 3 (:DEFINITION NULL))
 )
