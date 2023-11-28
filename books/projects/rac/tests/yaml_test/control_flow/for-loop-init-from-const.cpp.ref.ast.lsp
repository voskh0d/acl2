
(declare init 3)
(funcdef foo () (block (declare res 0) (for ((declare i (init)) (logand1 (logand1 (log< i 9) (log>= i -2147483648)) (log<= i 2147483647)) (si (bits (+ i 1) 31 0) 32)) (block (assign res (si (bits (+ res 1) 31 0) 32)))) (return res)))
