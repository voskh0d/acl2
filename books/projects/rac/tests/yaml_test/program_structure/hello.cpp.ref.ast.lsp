

(funcdef reverseByte (mumble) (block (declare result (bits 0 7 0)) (for ((declare i 0) (logand1 (logand1 (log< i 4) (log>= i -2147483648)) (log<= i 2147483647)) (+ i 1)) (block (assign result (setbits result 8 (+ (* 2 i) (- 2 1)) (* 2 i) (bits mumble (+ (- 6 (* 2 i)) (- 2 1)) (- 6 (* 2 i))))))) (return result)))
