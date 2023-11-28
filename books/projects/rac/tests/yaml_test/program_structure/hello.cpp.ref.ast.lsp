

(funcdef reverseByte (mumble) (block (declare result (bits 0 7 0)) (for ((declare i 0) (logand1 (logand1 (log< i 4) (log>= i -2147483648)) (log<= i 2147483647)) (si (bits (+ i 1) 31 0) 32)) (block (assign result (setbits result 8 (si (bits (+ (si (bits (* 2 i) 31 0) 32) 1) 31 0) 32) (si (bits (* 2 i) 31 0) 32) (bits mumble (si (bits (+ (si (bits (- 6 (si (bits (* 2 i) 31 0) 32)) 31 0) 32) 1) 31 0) 32) (si (bits (- 6 (si (bits (* 2 i) 31 0) 32)) 31 0) 32)))))) (return result)))
