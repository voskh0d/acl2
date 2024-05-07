

(funcdef foo () (block (declare res 0) (for ((declare i 0) (logand1 (logand1 (log< i 5) (log>= i -9223372036854775808)) (log<= i 9223372036854775807)) (+ i 1)) (block (assign res (si (bits (+ res i) 31 0) 32)))) (return res)))(funcdef bar () (block (declare res 0) (for ((declare i (bits 0 63 0)) (logand1 (logand1 (log< i 5) (log>= i 0)) (log<= i 18446744073709551615)) (+ i 1)) (block (assign res (si (bits (+ res i) 31 0) 32)))) (return res)))
