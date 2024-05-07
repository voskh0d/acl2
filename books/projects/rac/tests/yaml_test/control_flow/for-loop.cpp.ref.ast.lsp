

(funcdef foo () (block (declare res 0) (for ((declare i 0) (logand1 (logand1 (log< i 5) (log>= i -2147483648)) (log<= i 2147483647)) (+ i 1)) (block (assign res (+ res i)))) (return res)))
