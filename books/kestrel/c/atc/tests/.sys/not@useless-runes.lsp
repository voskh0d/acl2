(|one|)
(|two|)
(C::*PROGRAM*-WELL-FORMED)
(C::*PROGRAM*-FUN-ENV)
(|one-FUN-ENV|)
(C::|one-GUARD|)
(|one$NOT-NORMALIZED|)
(C::|one-DEF*|)
(C::|one-x|)
(C::|one-INIT-SCOPE-EXPAND|
 (2 2 (:REWRITE C::VALUEP-WHEN-ULONGP))
 (2 2 (:REWRITE C::VALUEP-WHEN-ULLONGP))
 (2 2 (:REWRITE C::VALUEP-WHEN-SLONGP))
 (2 2 (:REWRITE C::VALUEP-WHEN-SLLONGP))
 (2 2 (:REWRITE C::VALUEP-WHEN-SINTP))
 (1 1 (:REWRITE C::TYPE-OF-VALUE-WHEN-ULONGP))
 (1 1 (:REWRITE C::TYPE-OF-VALUE-WHEN-ULLONGP))
 (1 1 (:REWRITE C::TYPE-OF-VALUE-WHEN-SLONGP))
 (1 1 (:REWRITE C::TYPE-OF-VALUE-WHEN-SLLONGP))
 (1 1 (:REWRITE C::TYPE-OF-VALUE-WHEN-SINTP))
 (1 1 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-ULONGP))
 (1 1 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-ULLONGP))
 (1 1 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SLONGP))
 (1 1 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SLLONGP))
 (1 1 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SINTP))
 )
(C::|one-INIT-SCOPE-SCOPEP|
 (1 1 (:REWRITE C::VALUEP-WHEN-ULONGP))
 (1 1 (:REWRITE C::VALUEP-WHEN-ULLONGP))
 (1 1 (:REWRITE C::VALUEP-WHEN-SLONGP))
 (1 1 (:REWRITE C::VALUEP-WHEN-SLLONGP))
 (1 1 (:REWRITE C::VALUEP-WHEN-SINTP))
 )
(C::|one-PUSH-INIT|
 (1 1 (:REWRITE C::VALUEP-WHEN-ULONGP))
 (1 1 (:REWRITE C::VALUEP-WHEN-ULLONGP))
 (1 1 (:REWRITE C::VALUEP-WHEN-SLONGP))
 (1 1 (:REWRITE C::VALUEP-WHEN-SLLONGP))
 (1 1 (:REWRITE C::VALUEP-WHEN-SINTP))
 (1 1 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-ULONGP))
 (1 1 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-ULLONGP))
 (1 1 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SLONGP))
 (1 1 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SLLONGP))
 (1 1 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SINTP))
 )
(C::|one-x-IN-SCOPE-0|)
(C::|one-CORRECT-1|)
(C::|one-CORRECT-2|)
(C::|one-CORRECT-3|)
(C::|one-x-IN-SCOPE-4|)
(C::|one-CORRECT-5|)
(C::|one-CORRECT-6|)
(C::|one-CORRECT-7|)
(C::|one-CORRECT-8|)
(C::|one-CORRECT-9|)
(C::|one-x-IN-SCOPE-10|)
(C::|one-CORRECT-11|)
(C::|one-CORRECT-12|)
(C::|one-CORRECT-13|)
(C::|one-CORRECT-14|)
(C::|one-CORRECT-15|)
(C::|one-CORRECT-16|)
(C::|one-CORRECT-17|)
(C::|one-CORRECT-18|)
(C::|one-CORRECT-19|)
(C::|one-CORRECT-20|)
(C::|one-POP-FRAME|)
(|one-RESULT|)
(C::|one-CORRECT|)
(C::|*PROGRAM*-one-CORRECT|)
(|two-FUN-ENV|)
(C::|two-GUARD|)
(|two$NOT-NORMALIZED|)
(C::|two-DEF*|)
(C::|two-x|)
(C::|two-y|)
(C::|two-INIT-SCOPE-EXPAND|
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
(C::|two-INIT-SCOPE-SCOPEP|
 (2 2 (:REWRITE C::VALUEP-WHEN-ULONGP))
 (2 2 (:REWRITE C::VALUEP-WHEN-ULLONGP))
 (2 2 (:REWRITE C::VALUEP-WHEN-SLONGP))
 (2 2 (:REWRITE C::VALUEP-WHEN-SLLONGP))
 )
(C::|two-PUSH-INIT|
 (3 3 (:REWRITE C::VALUEP-WHEN-ULONGP))
 (3 3 (:REWRITE C::VALUEP-WHEN-ULLONGP))
 (3 3 (:REWRITE C::VALUEP-WHEN-SLONGP))
 (3 3 (:REWRITE C::VALUEP-WHEN-SLLONGP))
 (2 2 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-ULONGP))
 (2 2 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-ULLONGP))
 (2 2 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SLONGP))
 (2 2 (:REWRITE C::NOT-FLEXIBLE-ARRAY-MEMBER-P-WHEN-SLLONGP))
 )
(C::|two-x-IN-SCOPE-0|)
(C::|two-y-IN-SCOPE-0|)
(C::|two-CORRECT-1|)
(C::|two-CORRECT-2|)
(C::|two-CORRECT-3|)
(C::|two-CORRECT-4|)
(C::|two-CORRECT-5|)
(C::|two-x-IN-SCOPE-6|)
(C::|two-y-IN-SCOPE-6|)
(C::|two-CORRECT-7|)
(C::|two-CORRECT-8|)
(C::|two-CORRECT-9|)
(C::|two-CORRECT-10|)
(C::|two-CORRECT-11|)
(C::|two-x-IN-SCOPE-12|)
(C::|two-y-IN-SCOPE-12|)
(C::|two-CORRECT-13|)
(C::|two-CORRECT-14|)
(C::|two-CORRECT-15|)
(C::|two-CORRECT-16|)
(C::|two-CORRECT-17|)
(C::|two-CORRECT-18|)
(C::|two-CORRECT-19|)
(C::|two-CORRECT-20|)
(C::|two-CORRECT-21|)
(C::|two-CORRECT-22|)
(C::|two-POP-FRAME|)
(|two-RESULT|)
(C::|two-CORRECT|)
(C::|*PROGRAM*-two-CORRECT|)
