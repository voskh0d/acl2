

(funcdef foo () (block (declare res 0) (for ((declare i 0) (logand1 (logand1 (log< i 5) (log>= i -9223372036854775808)) (log<= i 9223372036854775807)) (si (bits (+ i 1) 63 0) 64)) (block (assign res (si (bits (si (bits (+ res i) 63 0) 64) 31 0) 32)))) (return res)))(funcdef bar () (block (declare res 0) (for ((declare i (bits 0 63 0)) (logand1 (logand1 (log< i 5) (log>= i 0)) (log<= i 18446744073709551615)) (bits (+ i 1) 63 0)) (block (assign res (si (bits (bits (+ res i) 63 0) 31 0) 32)))) (return res)))
