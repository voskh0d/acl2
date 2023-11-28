

(funcdef foo () (block (declare res 0) (for ((declare i (bits 0 31 0)) (logand1 (logand1 (log< i 5) (log>= i 0)) (log<= i 4294967295)) (bits (+ i 1) 31 0)) (block (assign res (si (bits (+ res i) 31 0) 32)))) (return res)))
