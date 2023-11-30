

(funcdef foo (a b c) (block (declare res1 (si (bits (+ (si (bits (* a b) 31 0) 32) c) 31 0) 32)) (declare res2 (si (bits (+ (truncate (/ a b) 1) c) 31 0) 32)) (declare res3 (si (bits (rem (si (bits (* a b) 31 0) 32) c) 31 0) 32)) (declare res4 (si (bits (* (truncate (/ a b) 1) b) 31 0) 32)) (declare res5 (si (bits (* a (si (bits (+ b c) 31 0) 32)) 31 0) 32)) (return 0)))
