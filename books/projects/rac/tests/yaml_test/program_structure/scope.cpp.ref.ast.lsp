

(funcdef main () (block (declare a 0) (block (declare b 4) (assign a (si (bits (+ a b) 31 0) 32))) (return a)))
