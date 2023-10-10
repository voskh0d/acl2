

(funcdef rshift (x) (block (assign x (bits (* (* (/ x (expt 2 1)) (expt 2 2)) (expt 2 1)) 3 0)) (return 0)))(funcdef lshift (x) (block (assign x (bits (* (/ (/ x (expt 2 1)) (expt 2 2)) (expt 2 1)) 3 0)) (return 0)))
