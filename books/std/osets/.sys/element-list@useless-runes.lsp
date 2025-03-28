(ELEMENT-LIST-P-OF-SFIX
 (89 6 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-NONEMPTY-P))
 (80 3 (:DEFINITION ELEMENT-LIST-NONEMPTY-P))
 (72 6 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-UNKNOWN-NIL))
 (55 16 (:REWRITE ELEMENT-LIST-P-WHEN-NOT-CONSP-TRUE-LIST))
 (55 16 (:REWRITE ELEMENT-LIST-P-WHEN-NOT-CONSP-NON-TRUE-LIST))
 (54 54 (:TYPE-PRESCRIPTION ELEMENT-LIST-FINAL-CDR-P-TYPE))
 (41 12 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (39 37 (:REWRITE ELEMENT-LIST-FINAL-CDR-P-REWRITE))
 (26 3 (:REWRITE ELEMENT-LIST-P-OF-CDR-WHEN-ELEMENT-LIST-P))
 (21 21 (:TYPE-PRESCRIPTION ELEMENT-LIST-NONEMPTY-P))
 (15 15 (:TYPE-PRESCRIPTION SET::EMPTYP-TYPE))
 (12 12 (:REWRITE SET::IN-SET))
 (11 1 (:REWRITE SET::SFIX-SET-IDENTITY))
 (6 6 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-NOT-ELEMENT-P-NIL-AND-NOT-NEGATED))
 (6 6 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-ELEMENT-P-NIL))
 (6 6 (:REWRITE DEFAULT-CDR))
 (6 6 (:REWRITE DEFAULT-CAR))
 (6 3 (:REWRITE ELEMENT-LIST-NONEMPTY-P-OF-CDR-WHEN-ELEMENT-LIST-NONEMPTY-P))
 (6 1 (:REWRITE SET::SFIX-WHEN-EMPTYP))
 )
(ELEMENT-LIST-P-OF-INSERT
 (1633 246 (:REWRITE ELEMENT-LIST-NONEMPTY-P-OF-CDR-WHEN-ELEMENT-LIST-NONEMPTY-P))
 (1230 561 (:REWRITE ELEMENT-LIST-P-WHEN-NOT-CONSP-TRUE-LIST))
 (1178 1152 (:REWRITE DEFAULT-CDR))
 (813 787 (:REWRITE DEFAULT-CAR))
 (427 427 (:REWRITE SET::IN-SET))
 (301 61 (:REWRITE SET::INSERT-IDENTITY))
 (277 277 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-NOT-ELEMENT-P-NIL-AND-NOT-NEGATED))
 (277 277 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-ELEMENT-P-NIL))
 (202 72 (:REWRITE SET::HEAD-WHEN-EMPTYP))
 (180 180 (:TYPE-PRESCRIPTION SET::IN-TYPE))
 (120 60 (:REWRITE SET::IN-TAIL))
 (120 20 (:REWRITE SET::TAIL-WHEN-EMPTYP))
 (72 72 (:REWRITE SET::IN-TAIL-OR-HEAD))
 )
(ELEMENT-LIST-P-OF-DELETE
 (638 43 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-NONEMPTY-P))
 (584 22 (:DEFINITION ELEMENT-LIST-NONEMPTY-P))
 (527 13 (:REWRITE SET::INSERT-IDENTITY))
 (501 13 (:REWRITE SET::DELETE-IN))
 (488 65 (:REWRITE SET::IN-TAIL))
 (436 174 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (264 93 (:REWRITE ELEMENT-LIST-P-WHEN-NOT-CONSP-NON-TRUE-LIST))
 (234 70 (:REWRITE SET::SFIX-WHEN-EMPTYP))
 (216 36 (:REWRITE SET::TAIL-WHEN-EMPTYP))
 (174 174 (:REWRITE SET::IN-SET))
 (153 153 (:TYPE-PRESCRIPTION ELEMENT-LIST-NONEMPTY-P))
 (130 13 (:REWRITE SET::INSERT-WHEN-EMPTYP))
 (123 90 (:REWRITE DEFAULT-CDR))
 (107 26 (:REWRITE ELEMENT-LIST-NONEMPTY-P-OF-CDR-WHEN-ELEMENT-LIST-NONEMPTY-P))
 (97 27 (:REWRITE SET::HEAD-WHEN-EMPTYP))
 (79 14 (:REWRITE SET::DELETE-PRESERVES-EMPTYP))
 (74 74 (:REWRITE DEFAULT-CAR))
 (35 35 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-NOT-ELEMENT-P-NIL-AND-NOT-NEGATED))
 (35 35 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-ELEMENT-P-NIL))
 (27 27 (:REWRITE SET::IN-TAIL-OR-HEAD))
 (4 4 (:REWRITE SET::TAIL-PRODUCES-SET))
 )
(ELEMENT-LIST-P-OF-MERGESORT
 (2042 133 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-NONEMPTY-P))
 (1911 69 (:DEFINITION ELEMENT-LIST-NONEMPTY-P))
 (1664 21 (:REWRITE ELEMENT-LIST-P-OF-LIST-FIX-TRUE-LISTP))
 (628 95 (:REWRITE ELEMENT-LIST-NONEMPTY-P-OF-CDR-WHEN-ELEMENT-LIST-NONEMPTY-P))
 (537 537 (:TYPE-PRESCRIPTION ELEMENT-LIST-FINAL-CDR-P-TYPE))
 (514 190 (:REWRITE ELEMENT-LIST-P-WHEN-NOT-CONSP-TRUE-LIST))
 (514 190 (:REWRITE ELEMENT-LIST-P-WHEN-NOT-CONSP-NON-TRUE-LIST))
 (498 409 (:REWRITE ELEMENT-LIST-FINAL-CDR-P-REWRITE))
 (482 482 (:TYPE-PRESCRIPTION ELEMENT-LIST-NONEMPTY-P))
 (478 22 (:REWRITE LIST-FIX-WHEN-TRUE-LISTP))
 (292 49 (:REWRITE SET::SETS-ARE-TRUE-LISTS-CHEAP))
 (286 25 (:DEFINITION TRUE-LISTP))
 (237 237 (:REWRITE DEFAULT-CDR))
 (165 72 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (161 23 (:REWRITE SET::MERGESORT-SET-IDENTITY))
 (156 156 (:REWRITE DEFAULT-CAR))
 (131 131 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-NOT-ELEMENT-P-NIL-AND-NOT-NEGATED))
 (131 131 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-ELEMENT-P-NIL))
 (121 121 (:TYPE-PRESCRIPTION SET::EMPTYP-TYPE))
 (120 12 (:REWRITE SET::INSERT-IDENTITY))
 (112 112 (:TYPE-PRESCRIPTION TRUE-LISTP))
 (96 12 (:REWRITE SET::IN-MERGESORT-UNDER-IFF))
 (72 72 (:REWRITE SET::IN-SET))
 (72 12 (:DEFINITION MEMBER-EQUAL))
 (54 27 (:REWRITE DEFAULT-+-2))
 (48 48 (:TYPE-PRESCRIPTION MEMBER-EQUAL))
 (44 11 (:REWRITE ELEMENT-LIST-P-OF-LIST-FIX-NON-TRUE-LISTP))
 (36 12 (:REWRITE SET::INSERT-WHEN-EMPTYP))
 (27 27 (:REWRITE DEFAULT-+-1))
 (21 21 (:REWRITE LIST-FIX-WHEN-NOT-CONSP))
 (12 12 (:TYPE-PRESCRIPTION SET::IN-TYPE))
 (6 2 (:REWRITE SET::SFIX-WHEN-EMPTYP))
 )
(ELEMENT-LIST-P-OF-UNION
 (9268 2387 (:REWRITE <<-TRICHOTOMY))
 (8182 62 (:REWRITE SET::INSERT-IDENTITY))
 (7954 52 (:REWRITE SET::UNION-IN))
 (7836 226 (:REWRITE SET::IN-TAIL))
 (6530 1133 (:REWRITE <<-ASYMMETRIC))
 (5231 56 (:REWRITE SET::UNION-EMPTYP))
 (3560 3284 (:REWRITE DEFAULT-CDR))
 (2387 2387 (:REWRITE <<-TRANSITIVE))
 (2355 347 (:REWRITE ELEMENT-LIST-NONEMPTY-P-OF-CDR-WHEN-ELEMENT-LIST-NONEMPTY-P))
 (2204 845 (:REWRITE ELEMENT-LIST-P-WHEN-NOT-CONSP-NON-TRUE-LIST))
 (1969 1969 (:REWRITE SET::IN-SET))
 (1773 1773 (:REWRITE DEFAULT-CAR))
 (902 152 (:REWRITE SET::TAIL-WHEN-EMPTYP))
 (560 560 (:TYPE-PRESCRIPTION SET::IN-TYPE))
 (512 102 (:REWRITE SET::UNION-EMPTYP-Y))
 (425 425 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-NOT-ELEMENT-P-NIL-AND-NOT-NEGATED))
 (425 425 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-ELEMENT-P-NIL))
 (296 296 (:TYPE-PRESCRIPTION SET::SFIX))
 (264 44 (:REWRITE SET::HEAD-WHEN-EMPTYP))
 (80 4 (:REWRITE SET::IN-SFIX-CANCEL))
 (44 44 (:REWRITE SET::IN-TAIL-OR-HEAD))
 (24 24 (:TYPE-PRESCRIPTION SET::INSERT))
 )
(ELEMENT-LIST-P-OF-INTERSECT-1
 (4525 142 (:REWRITE SET::IN-TAIL))
 (2232 20 (:REWRITE SET::INSERT-IDENTITY))
 (2192 20 (:REWRITE SET::INTERSECT-IN))
 (2102 538 (:REWRITE <<-TRICHOTOMY))
 (1332 230 (:REWRITE <<-ASYMMETRIC))
 (985 70 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-NONEMPTY-P))
 (938 815 (:REWRITE DEFAULT-CDR))
 (903 36 (:DEFINITION ELEMENT-LIST-NONEMPTY-P))
 (707 707 (:REWRITE SET::IN-SET))
 (686 170 (:REWRITE SET::SFIX-WHEN-EMPTYP))
 (582 106 (:REWRITE SET::TAIL-WHEN-EMPTYP))
 (544 536 (:REWRITE <<-TRANSITIVE))
 (429 429 (:REWRITE DEFAULT-CAR))
 (394 145 (:REWRITE ELEMENT-LIST-P-WHEN-NOT-CONSP-NON-TRUE-LIST))
 (280 20 (:REWRITE SET::INSERT-WHEN-EMPTYP))
 (240 240 (:TYPE-PRESCRIPTION ELEMENT-LIST-NONEMPTY-P))
 (174 32 (:REWRITE SET::NEVER-IN-EMPTY))
 (160 42 (:REWRITE ELEMENT-LIST-NONEMPTY-P-OF-CDR-WHEN-ELEMENT-LIST-NONEMPTY-P))
 (152 42 (:REWRITE SET::HEAD-WHEN-EMPTYP))
 (123 123 (:TYPE-PRESCRIPTION SET::SFIX))
 (121 21 (:REWRITE SET::INTERSECT-EMPTYP-X))
 (81 21 (:REWRITE SET::INTERSECT-EMPTYP-Y))
 (58 58 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-NOT-ELEMENT-P-NIL-AND-NOT-NEGATED))
 (58 58 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-ELEMENT-P-NIL))
 (42 42 (:REWRITE SET::IN-TAIL-OR-HEAD))
 (4 4 (:REWRITE SET::TAIL-PRODUCES-SET))
 (2 2 (:REWRITE <<-IRREFLEXIVE))
 )
(ELEMENT-P-WHEN-IN-ELEMENT-LIST-P
 (681 34 (:REWRITE SET::IN-TAIL))
 (303 119 (:REWRITE SET::NONEMPTY-MEANS-SET))
 (147 25 (:REWRITE SET::TAIL-WHEN-EMPTYP))
 (147 12 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-NONEMPTY-P))
 (129 6 (:DEFINITION ELEMENT-LIST-NONEMPTY-P))
 (84 14 (:REWRITE SET::HEAD-WHEN-EMPTYP))
 (75 39 (:REWRITE DEFAULT-CDR))
 (71 23 (:REWRITE ELEMENT-LIST-P-WHEN-NOT-CONSP-TRUE-LIST))
 (71 23 (:REWRITE ELEMENT-LIST-P-WHEN-NOT-CONSP-NON-TRUE-LIST))
 (42 42 (:TYPE-PRESCRIPTION ELEMENT-LIST-NONEMPTY-P))
 (33 30 (:REWRITE DEFAULT-CAR))
 (14 14 (:REWRITE SET::IN-TAIL-OR-HEAD))
 (12 6 (:REWRITE ELEMENT-LIST-NONEMPTY-P-OF-CDR-WHEN-ELEMENT-LIST-NONEMPTY-P))
 (8 8 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-NOT-ELEMENT-P-NIL-AND-NOT-NEGATED))
 (8 8 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-ELEMENT-P-NIL))
 (1 1 (:REWRITE ELEMENT-LIST-FINAL-CDR-P-OF-NIL))
 )
(ELEMENT-LIST-P-OF-INTERSECT-2
 (4331 138 (:REWRITE SET::IN-TAIL))
 (2503 42 (:REWRITE ELEMENT-LIST-P-OF-INTERSECT-1))
 (2232 20 (:REWRITE SET::INSERT-IDENTITY))
 (2192 20 (:REWRITE SET::INTERSECT-IN))
 (2126 128 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-NONEMPTY-P))
 (2023 518 (:REWRITE <<-TRICHOTOMY))
 (1961 79 (:DEFINITION ELEMENT-LIST-NONEMPTY-P))
 (1285 222 (:REWRITE <<-ASYMMETRIC))
 (982 865 (:REWRITE DEFAULT-CDR))
 (690 111 (:REWRITE ELEMENT-LIST-NONEMPTY-P-OF-CDR-WHEN-ELEMENT-LIST-NONEMPTY-P))
 (682 682 (:REWRITE SET::IN-SET))
 (650 164 (:REWRITE SET::SFIX-WHEN-EMPTYP))
 (570 104 (:REWRITE SET::TAIL-WHEN-EMPTYP))
 (560 236 (:REWRITE ELEMENT-LIST-P-WHEN-NOT-CONSP-NON-TRUE-LIST))
 (539 539 (:TYPE-PRESCRIPTION ELEMENT-LIST-NONEMPTY-P))
 (524 516 (:REWRITE <<-TRANSITIVE))
 (485 485 (:REWRITE DEFAULT-CAR))
 (280 20 (:REWRITE SET::INSERT-WHEN-EMPTYP))
 (248 124 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-NOT-ELEMENT-P-NIL-AND-NOT-NEGATED))
 (248 124 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-ELEMENT-P-NIL))
 (162 30 (:REWRITE SET::NEVER-IN-EMPTY))
 (152 42 (:REWRITE SET::HEAD-WHEN-EMPTYP))
 (121 21 (:REWRITE SET::INTERSECT-EMPTYP-X))
 (117 117 (:TYPE-PRESCRIPTION SET::SFIX))
 (81 21 (:REWRITE SET::INTERSECT-EMPTYP-Y))
 (42 42 (:REWRITE SET::IN-TAIL-OR-HEAD))
 (4 4 (:REWRITE SET::TAIL-PRODUCES-SET))
 (2 2 (:REWRITE <<-IRREFLEXIVE))
 )
(ELEMENT-LIST-P-OF-DIFFERENCE
 (5606 164 (:REWRITE SET::IN-TAIL))
 (3459 20 (:REWRITE SET::INSERT-IDENTITY))
 (3419 20 (:REWRITE SET::DIFFERENCE-IN))
 (2414 616 (:REWRITE <<-TRICHOTOMY))
 (1488 256 (:REWRITE <<-ASYMMETRIC))
 (1127 72 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-NONEMPTY-P))
 (1085 923 (:REWRITE DEFAULT-CDR))
 (1042 37 (:DEFINITION ELEMENT-LIST-NONEMPTY-P))
 (900 900 (:REWRITE SET::IN-SET))
 (721 172 (:REWRITE SET::SFIX-WHEN-EMPTYP))
 (622 614 (:REWRITE <<-TRANSITIVE))
 (616 108 (:REWRITE SET::TAIL-WHEN-EMPTYP))
 (483 483 (:REWRITE DEFAULT-CAR))
 (404 152 (:REWRITE ELEMENT-LIST-P-WHEN-NOT-CONSP-NON-TRUE-LIST))
 (326 20 (:REWRITE SET::INSERT-WHEN-EMPTYP))
 (302 62 (:REWRITE SET::DIFFERENCE-EMPTYP-Y))
 (291 21 (:REWRITE SET::SUBSET-DIFFERENCE))
 (280 52 (:REWRITE SET::NEVER-IN-EMPTY))
 (264 192 (:REWRITE ELEMENT-P-WHEN-IN-ELEMENT-LIST-P))
 (247 247 (:TYPE-PRESCRIPTION ELEMENT-LIST-NONEMPTY-P))
 (179 43 (:REWRITE ELEMENT-LIST-NONEMPTY-P-OF-CDR-WHEN-ELEMENT-LIST-NONEMPTY-P))
 (162 162 (:TYPE-PRESCRIPTION SET::SFIX))
 (152 42 (:REWRITE SET::HEAD-WHEN-EMPTYP))
 (121 21 (:REWRITE SET::EMPTYP-SUBSET))
 (120 60 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-NOT-ELEMENT-P-NIL-AND-NOT-NEGATED))
 (120 60 (:REWRITE ELEMENT-P-OF-CAR-WHEN-ELEMENT-LIST-P-WHEN-ELEMENT-P-NIL))
 (107 21 (:REWRITE SET::EMPTYP-SUBSET-2))
 (42 42 (:REWRITE SET::IN-TAIL-OR-HEAD))
 (21 21 (:REWRITE SET::PICK-A-POINT-SUBSET-CONSTRAINT-HELPER))
 (4 4 (:REWRITE SET::TAIL-PRODUCES-SET))
 (2 2 (:REWRITE <<-IRREFLEXIVE))
 )
