(|f|)
(|g|)
(|h|)
(C::*PROGRAM*-WELL-FORMED)
(C::*PROGRAM*-FUN-ENV)
(|f-FUN-ENV|)
(C::|f-GUARD|)
(|f$NOT-NORMALIZED|)
(C::|f-DEF*|)
(C::|f-x|)
(C::|f-y|)
(C::|f-INIT-SCOPE-EXPAND|
 (6 6 (:REWRITE C::VALUEP-WHEN-ULONGP))
 (6 6 (:REWRITE C::VALUEP-WHEN-ULLONGP))
 (6 6 (:REWRITE C::VALUEP-WHEN-SLONGP))
 (6 6 (:REWRITE C::VALUEP-WHEN-SLLONGP))
 (2 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-ULONGP))
 (2 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-ULLONGP))
 (2 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-SLONGP))
 (2 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-SLLONGP))
 (2 2 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-ULONGP))
 (2 2 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-ULLONGP))
 (2 2 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SLONGP))
 (2 2 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SLLONGP))
 )
(C::|f-INIT-SCOPE-SCOPEP|
 (2 2 (:REWRITE C::VALUEP-WHEN-ULONGP))
 (2 2 (:REWRITE C::VALUEP-WHEN-ULLONGP))
 (2 2 (:REWRITE C::VALUEP-WHEN-SLONGP))
 (2 2 (:REWRITE C::VALUEP-WHEN-SLLONGP))
 )
(C::|f-PUSH-INIT|
 (3 3 (:REWRITE C::VALUEP-WHEN-ULONGP))
 (3 3 (:REWRITE C::VALUEP-WHEN-ULLONGP))
 (3 3 (:REWRITE C::VALUEP-WHEN-SLONGP))
 (3 3 (:REWRITE C::VALUEP-WHEN-SLLONGP))
 (2 2 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-ULONGP))
 (2 2 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-ULLONGP))
 (2 2 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SLONGP))
 (2 2 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SLLONGP))
 )
(C::|f-x-IN-SCOPE-0|)
(C::|f-y-IN-SCOPE-0|)
(C::|f-CORRECT-1|)
(C::|f-CORRECT-2|)
(C::|f-CORRECT-3|)
(C::|f-CORRECT-4|)
(C::|f-CORRECT-5|)
(C::|f-CORRECT-6|)
(C::|f-CORRECT-7|)
(C::|f-POP-FRAME|)
(|f-RESULT|)
(C::|f-CORRECT|)
(C::|*PROGRAM*-f-CORRECT|)
(|g-FUN-ENV|)
(C::|g-GUARD|)
(|g$NOT-NORMALIZED|)
(C::|g-DEF*|)
(C::|g-z|)
(C::|g-z-IN-SCOPE-0|)
(C::|g-CORRECT-1|)
(C::|g-CORRECT-2|)
(C::|g-CORRECT-3|)
(|g-RESULT|)
(C::|*PROGRAM*-g-CORRECT|
 (93 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-VALUE-POINTER))
 (25 19 (:REWRITE C::VALUEP-WHEN-ULONGP))
 (25 19 (:REWRITE C::VALUEP-WHEN-ULLONGP))
 (25 19 (:REWRITE C::VALUEP-WHEN-SLONGP))
 (25 19 (:REWRITE C::VALUEP-WHEN-SLLONGP))
 (21 4 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-VALUE-STRUCT))
 (21 4 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-VALUE-POINTER))
 (19 19 (:REWRITE C::VALUEP-WHEN-USHORT-ARRAYP))
 (19 19 (:REWRITE C::VALUEP-WHEN-ULONG-ARRAYP))
 (19 19 (:REWRITE C::VALUEP-WHEN-ULLONG-ARRAYP))
 (19 19 (:REWRITE C::VALUEP-WHEN-UINT-ARRAYP))
 (19 19 (:REWRITE C::VALUEP-WHEN-UCHAR-ARRAYP))
 (19 19 (:REWRITE C::VALUEP-WHEN-SSHORT-ARRAYP))
 (19 19 (:REWRITE C::VALUEP-WHEN-SLONG-ARRAYP))
 (19 19 (:REWRITE C::VALUEP-WHEN-SLLONG-ARRAYP))
 (19 19 (:REWRITE C::VALUEP-WHEN-SINT-ARRAYP))
 (19 19 (:REWRITE C::VALUEP-WHEN-SCHAR-ARRAYP))
 (9 6 (:REWRITE C::VALUE-KIND-WHEN-ULONGP))
 (9 6 (:REWRITE C::VALUE-KIND-WHEN-ULLONGP))
 (9 6 (:REWRITE C::VALUE-KIND-WHEN-UINTP))
 (9 6 (:REWRITE C::VALUE-KIND-WHEN-SLONGP))
 (9 6 (:REWRITE C::VALUE-KIND-WHEN-SLLONGP))
 (7 2 (:REWRITE C::READ-VAR-TO-READ-STATIC-VAR))
 (6 6 (:REWRITE C::VALUE-KIND-WHEN-USHORT-ARRAYP))
 (6 6 (:REWRITE C::VALUE-KIND-WHEN-ULONG-ARRAYP))
 (6 6 (:REWRITE C::VALUE-KIND-WHEN-ULLONG-ARRAYP))
 (6 6 (:REWRITE C::VALUE-KIND-WHEN-UINT-ARRAYP))
 (6 6 (:REWRITE C::VALUE-KIND-WHEN-UCHAR-ARRAYP))
 (6 6 (:REWRITE C::VALUE-KIND-WHEN-SSHORT-ARRAYP))
 (6 6 (:REWRITE C::VALUE-KIND-WHEN-SLONG-ARRAYP))
 (6 6 (:REWRITE C::VALUE-KIND-WHEN-SLLONG-ARRAYP))
 (6 6 (:REWRITE C::VALUE-KIND-WHEN-SINT-ARRAYP))
 (6 6 (:REWRITE C::VALUE-KIND-WHEN-SCHAR-ARRAYP))
 (5 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-ULONGP))
 (5 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-ULLONGP))
 (5 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-SLONGP))
 (5 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-SLLONGP))
 (5 1 (:REWRITE C::VAR-AUTOP-OF-ADD-VAR))
 (4 4 (:REWRITE C::NOT-SINTP-WHEN-USHORTP))
 (4 4 (:REWRITE C::NOT-SINTP-WHEN-ULONGP))
 (4 4 (:REWRITE C::NOT-SINTP-WHEN-ULLONGP))
 (4 4 (:REWRITE C::NOT-SINTP-WHEN-UINTP))
 (4 4 (:REWRITE C::NOT-SINTP-WHEN-UCHARP))
 (4 4 (:REWRITE C::NOT-SINTP-WHEN-SSHORTP))
 (4 4 (:REWRITE C::NOT-SINTP-WHEN-SLONGP))
 (4 4 (:REWRITE C::NOT-SINTP-WHEN-SLLONGP))
 (4 4 (:REWRITE C::NOT-SINTP-WHEN-SCHARP))
 (4 4 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-USHORT-ARRAYP))
 (4 4 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-ULONGP))
 (4 4 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-ULONG-ARRAYP))
 (4 4 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-ULLONGP))
 (4 4 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-ULLONG-ARRAYP))
 (4 4 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-UINT-ARRAYP))
 (4 4 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-UCHAR-ARRAYP))
 (4 4 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SSHORT-ARRAYP))
 (4 4 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SLONGP))
 (4 4 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SLONG-ARRAYP))
 (4 4 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SLLONGP))
 (4 4 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SLLONG-ARRAYP))
 (4 4 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SINT-ARRAYP))
 (4 4 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SCHAR-ARRAYP))
 (4 4 (:REWRITE C::COMPUSTATEP-WHEN-COMPUSTATE-RESULTP-AND-NOT-ERRORP))
 (3 3 (:REWRITE C::EXEC-EXPR-PURE-WHEN-STRICT-PURE-BINARY))
 (3 3 (:REWRITE C::EXEC-EXPR-PURE-WHEN-COND))
 (3 3 (:REWRITE C::EXEC-EXPR-PURE-WHEN-CAST))
 (3 3 (:REWRITE C::EXEC-EXPR-PURE-WHEN-BINARY-LOGOR))
 (3 3 (:REWRITE C::EXEC-EXPR-PURE-WHEN-BINARY-LOGAND))
 (2 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-USHORT-ARRAYP))
 (2 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-ULONG-ARRAYP))
 (2 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-ULLONG-ARRAYP))
 (2 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-UINT-ARRAYP))
 (2 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-UCHAR-ARRAYP))
 (2 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-SSHORT-ARRAYP))
 (2 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-SLONG-ARRAYP))
 (2 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-SLLONG-ARRAYP))
 (2 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-SINT-ARRAYP))
 (2 2 (:REWRITE C::TYPE-OF-VALUE-WHEN-SCHAR-ARRAYP))
 (2 2 (:REWRITE C::EXEC-EXPR-PURE-WHEN-MEMBERP))
 (2 2 (:REWRITE C::EXEC-EXPR-PURE-WHEN-MEMBER))
 (2 2 (:REWRITE C::EXEC-EXPR-PURE-WHEN-CONST))
 (2 2 (:REWRITE C::EXEC-EXPR-PURE-WHEN-ARRSUB-OF-MEMBERP))
 (2 2 (:REWRITE C::EXEC-EXPR-PURE-WHEN-ARRSUB-OF-MEMBER))
 (2 2 (:REWRITE C::EXEC-EXPR-PURE-WHEN-ARRSUB))
 (1 1 (:REWRITE C::LOGNOT-VALUE-WHEN-USHORTP))
 (1 1 (:REWRITE C::LOGNOT-VALUE-WHEN-ULONGP))
 (1 1 (:REWRITE C::LOGNOT-VALUE-WHEN-ULLONGP))
 (1 1 (:REWRITE C::LOGNOT-VALUE-WHEN-UINTP))
 (1 1 (:REWRITE C::LOGNOT-VALUE-WHEN-UCHARP))
 (1 1 (:REWRITE C::LOGNOT-VALUE-WHEN-SSHORTP))
 (1 1 (:REWRITE C::LOGNOT-VALUE-WHEN-SLONGP))
 (1 1 (:REWRITE C::LOGNOT-VALUE-WHEN-SLLONGP))
 (1 1 (:REWRITE C::LOGNOT-VALUE-WHEN-SINTP))
 (1 1 (:REWRITE C::LOGNOT-VALUE-WHEN-SCHARP))
 (1 1 (:REWRITE C::BITNOT-VALUE-WHEN-ULONGP))
 (1 1 (:REWRITE C::BITNOT-VALUE-WHEN-ULLONGP))
 (1 1 (:REWRITE C::BITNOT-VALUE-WHEN-UINTP))
 (1 1 (:REWRITE C::BITNOT-VALUE-WHEN-SLONGP))
 (1 1 (:REWRITE C::BITNOT-VALUE-WHEN-SLLONGP))
 )
(|h-FUN-ENV|)
(C::|h-GUARD|)
(|h$NOT-NORMALIZED|)
(C::|h-DEF*|)
(C::|h-a|)
(C::|h-b|)
(C::|h-a-IN-SCOPE-0|)
(C::|h-b-IN-SCOPE-0|)
(C::|h-CORRECT-1|)
(C::|h-CORRECT-2|)
(C::|h-CORRECT-3|)
(|h-RESULT|)
(C::|*PROGRAM*-h-CORRECT|
 (126 3 (:REWRITE C::TYPE-OF-VALUE-WHEN-VALUE-POINTER))
 (40 6 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-VALUE-STRUCT))
 (40 6 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-VALUE-POINTER))
 (31 25 (:REWRITE C::VALUEP-WHEN-ULONGP))
 (31 25 (:REWRITE C::VALUEP-WHEN-ULLONGP))
 (31 25 (:REWRITE C::VALUEP-WHEN-SLONGP))
 (31 25 (:REWRITE C::VALUEP-WHEN-SLLONGP))
 (25 25 (:REWRITE C::VALUEP-WHEN-USHORT-ARRAYP))
 (25 25 (:REWRITE C::VALUEP-WHEN-ULONG-ARRAYP))
 (25 25 (:REWRITE C::VALUEP-WHEN-ULLONG-ARRAYP))
 (25 25 (:REWRITE C::VALUEP-WHEN-UINT-ARRAYP))
 (25 25 (:REWRITE C::VALUEP-WHEN-UCHAR-ARRAYP))
 (25 25 (:REWRITE C::VALUEP-WHEN-SSHORT-ARRAYP))
 (25 25 (:REWRITE C::VALUEP-WHEN-SLONG-ARRAYP))
 (25 25 (:REWRITE C::VALUEP-WHEN-SLLONG-ARRAYP))
 (25 25 (:REWRITE C::VALUEP-WHEN-SINT-ARRAYP))
 (25 25 (:REWRITE C::VALUEP-WHEN-SCHAR-ARRAYP))
 (23 3 (:REWRITE C::READ-VAR-TO-READ-STATIC-VAR))
 (20 4 (:REWRITE C::VAR-AUTOP-OF-ADD-VAR))
 (12 9 (:REWRITE C::VALUE-KIND-WHEN-ULONGP))
 (12 9 (:REWRITE C::VALUE-KIND-WHEN-ULLONGP))
 (12 9 (:REWRITE C::VALUE-KIND-WHEN-UINTP))
 (12 9 (:REWRITE C::VALUE-KIND-WHEN-SLONGP))
 (12 9 (:REWRITE C::VALUE-KIND-WHEN-SLLONGP))
 (9 9 (:REWRITE C::VALUE-KIND-WHEN-USHORT-ARRAYP))
 (9 9 (:REWRITE C::VALUE-KIND-WHEN-ULONG-ARRAYP))
 (9 9 (:REWRITE C::VALUE-KIND-WHEN-ULLONG-ARRAYP))
 (9 9 (:REWRITE C::VALUE-KIND-WHEN-UINT-ARRAYP))
 (9 9 (:REWRITE C::VALUE-KIND-WHEN-UCHAR-ARRAYP))
 (9 9 (:REWRITE C::VALUE-KIND-WHEN-SSHORT-ARRAYP))
 (9 9 (:REWRITE C::VALUE-KIND-WHEN-SLONG-ARRAYP))
 (9 9 (:REWRITE C::VALUE-KIND-WHEN-SLLONG-ARRAYP))
 (9 9 (:REWRITE C::VALUE-KIND-WHEN-SINT-ARRAYP))
 (9 9 (:REWRITE C::VALUE-KIND-WHEN-SCHAR-ARRAYP))
 (6 6 (:REWRITE C::NOT-SINTP-WHEN-USHORTP))
 (6 6 (:REWRITE C::NOT-SINTP-WHEN-ULONGP))
 (6 6 (:REWRITE C::NOT-SINTP-WHEN-ULLONGP))
 (6 6 (:REWRITE C::NOT-SINTP-WHEN-UINTP))
 (6 6 (:REWRITE C::NOT-SINTP-WHEN-UCHARP))
 (6 6 (:REWRITE C::NOT-SINTP-WHEN-SSHORTP))
 (6 6 (:REWRITE C::NOT-SINTP-WHEN-SLONGP))
 (6 6 (:REWRITE C::NOT-SINTP-WHEN-SLLONGP))
 (6 6 (:REWRITE C::NOT-SINTP-WHEN-SCHARP))
 (6 6 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-USHORT-ARRAYP))
 (6 6 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-ULONGP))
 (6 6 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-ULONG-ARRAYP))
 (6 6 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-ULLONGP))
 (6 6 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-ULLONG-ARRAYP))
 (6 6 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-UINT-ARRAYP))
 (6 6 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-UCHAR-ARRAYP))
 (6 6 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SSHORT-ARRAYP))
 (6 6 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SLONGP))
 (6 6 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SLONG-ARRAYP))
 (6 6 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SLLONGP))
 (6 6 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SLLONG-ARRAYP))
 (6 6 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SINT-ARRAYP))
 (6 6 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SCHAR-ARRAYP))
 (6 3 (:REWRITE C::TYPE-OF-VALUE-WHEN-ULONGP))
 (6 3 (:REWRITE C::TYPE-OF-VALUE-WHEN-ULLONGP))
 (6 3 (:REWRITE C::TYPE-OF-VALUE-WHEN-SLONGP))
 (6 3 (:REWRITE C::TYPE-OF-VALUE-WHEN-SLLONGP))
 (3 3 (:REWRITE C::TYPE-OF-VALUE-WHEN-USHORT-ARRAYP))
 (3 3 (:REWRITE C::TYPE-OF-VALUE-WHEN-ULONG-ARRAYP))
 (3 3 (:REWRITE C::TYPE-OF-VALUE-WHEN-ULLONG-ARRAYP))
 (3 3 (:REWRITE C::TYPE-OF-VALUE-WHEN-UINT-ARRAYP))
 (3 3 (:REWRITE C::TYPE-OF-VALUE-WHEN-UCHAR-ARRAYP))
 (3 3 (:REWRITE C::TYPE-OF-VALUE-WHEN-SSHORT-ARRAYP))
 (3 3 (:REWRITE C::TYPE-OF-VALUE-WHEN-SLONG-ARRAYP))
 (3 3 (:REWRITE C::TYPE-OF-VALUE-WHEN-SLLONG-ARRAYP))
 (3 3 (:REWRITE C::TYPE-OF-VALUE-WHEN-SINT-ARRAYP))
 (3 3 (:REWRITE C::TYPE-OF-VALUE-WHEN-SCHAR-ARRAYP))
 (3 3 (:REWRITE C::EXEC-EXPR-PURE-WHEN-COND))
 (3 3 (:REWRITE C::EXEC-EXPR-PURE-WHEN-BINARY-LOGOR))
 (3 3 (:REWRITE C::EXEC-EXPR-PURE-WHEN-BINARY-LOGAND))
 (3 3 (:REWRITE C::COMPUSTATEP-WHEN-COMPUSTATE-RESULTP-AND-NOT-ERRORP))
 (2 2 (:REWRITE C::EXEC-EXPR-PURE-WHEN-UNARY))
 (2 2 (:REWRITE C::EXEC-EXPR-PURE-WHEN-MEMBERP))
 (2 2 (:REWRITE C::EXEC-EXPR-PURE-WHEN-MEMBER))
 (2 2 (:REWRITE C::EXEC-EXPR-PURE-WHEN-CONST))
 (2 2 (:REWRITE C::EXEC-EXPR-PURE-WHEN-CAST))
 (2 2 (:REWRITE C::EXEC-EXPR-PURE-WHEN-ARRSUB-OF-MEMBERP))
 (2 2 (:REWRITE C::EXEC-EXPR-PURE-WHEN-ARRSUB-OF-MEMBER))
 (2 2 (:REWRITE C::EXEC-EXPR-PURE-WHEN-ARRSUB))
 (1 1 (:REWRITE C::EXEC-BINARY-STRICT-PURE-WHEN-BITXOR))
 (1 1 (:REWRITE C::EXEC-BINARY-STRICT-PURE-WHEN-BITIOR))
 (1 1 (:REWRITE C::BITAND-VALUES-WHEN-ULONG))
 (1 1 (:REWRITE C::BITAND-VALUES-WHEN-ULLONG))
 (1 1 (:REWRITE C::BITAND-VALUES-WHEN-UINT))
 (1 1 (:REWRITE C::BITAND-VALUES-WHEN-SLONG))
 (1 1 (:REWRITE C::BITAND-VALUES-WHEN-SLLONG))
 (1 1 (:REWRITE C::BITAND-SINT-AND-VALUE-WHEN-ULONG))
 (1 1 (:REWRITE C::BITAND-SINT-AND-VALUE-WHEN-ULLONG))
 (1 1 (:REWRITE C::BITAND-SINT-AND-VALUE-WHEN-UINT))
 (1 1 (:REWRITE C::BITAND-SINT-AND-VALUE-WHEN-SLONG))
 (1 1 (:REWRITE C::BITAND-SINT-AND-VALUE-WHEN-SLLONG))
 )
