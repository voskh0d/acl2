

(funcdef foo (a) (block (assign a (si (bits (+ a 1) 31 0) 32)) (assign a (si (bits (- a 1) 31 0) 32)) (assign a (si (bits (* a 2) 31 0) 32)) (assign a (si (bits (+ a 1) 31 0) 32)) (assign a (si (bits (- a 1) 31 0) 32)) (return a)))
