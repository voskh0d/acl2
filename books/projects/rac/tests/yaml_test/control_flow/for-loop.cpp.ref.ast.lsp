

(funcdef foo () (block (declare res 0) (for ((declare i 0) (log< i 5) (si (bits (+ i 1) 31 0) 32)) (block (assign res (si (bits (+ res i) 31 0) 32)))) (return res)))
