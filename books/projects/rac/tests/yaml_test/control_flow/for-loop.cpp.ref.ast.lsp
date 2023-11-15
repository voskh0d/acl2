

(funcdef foo () (block (declare res 0) (for ((declare i 0) (logand1 (logand1 (log< i 5) (log>= i -2147483648)) (log< i 2147483648)) (si (bits (+ i 1) 31 0) 32)) (block (assign res (si (bits (+ res i) 31 0) 32)))) (return res)))
