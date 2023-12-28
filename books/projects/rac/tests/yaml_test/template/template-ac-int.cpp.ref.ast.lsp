

(funcdef slc_test (n) (block (return (bits (bits 4 (- n 1) 0) (- n 1) 0))))(funcdef main () (block (return (slc_test 4))))
