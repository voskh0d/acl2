

(funcdef foo (a) (block (assign a (si (bits (ash a (- 1)) 31 0) 32)) (assign a (si (bits (ash a 1) 31 0) 32)) (assign a (logand a 1)) (assign a (logior a 1)) (assign a (logxor a 1)) (return a)))
