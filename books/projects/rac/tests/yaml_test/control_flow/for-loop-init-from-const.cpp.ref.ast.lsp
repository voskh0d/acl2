
(declare init 3)
(funcdef foo () (block (declare res 0) (for ((declare i (init)) (logand1 (logand1 (log< i 9) (log>= i -2147483648)) (log<= i 2147483647)) (+ i 1)) (block (assign res (+ res 1)))) (return res)))
