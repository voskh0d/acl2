
(declare init 3)
(funcdef foo () (block (declare res 0) (for ((declare i (init)) (log< i 9) (si (bits (+ i 1) 31 0) 32)) (block (assign res (si (bits (+ res 1) 31 0) 32)))) (return res)))
