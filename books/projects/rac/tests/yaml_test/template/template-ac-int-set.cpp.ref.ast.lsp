

(funcdef set_test (n x) (block (assign x (setbits x n (si (bits (+ 0 (si (bits (- (truncate (/ n 2) 1) 1) 31 0) 32)) 31 0) 32) 0 (bits (bits 0 (- (truncate (/ n 2) 1) 1) 0) (- (truncate (/ n 2) 1) 1) 0))) (assign x (setbits x n (si (bits (+ (truncate (/ n 2) 1) (si (bits (- (truncate (/ n 2) 1) 1) 31 0) 32)) 31 0) 32) (truncate (/ n 2) 1) (bits (bits #xFFFFFFFF (- (truncate (/ n 2) 1) 1) 0) (- (truncate (/ n 2) 1) 1) 0))) (return x)))(funcdef main () (block (return (set_test 4 (bits 5 3 0)))))
