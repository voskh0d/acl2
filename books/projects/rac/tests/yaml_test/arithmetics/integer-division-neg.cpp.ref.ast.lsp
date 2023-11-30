

(funcdef div_int () (block (return (truncate (/ 10 -7) 1))))(funcdef div_reg () (block (declare a 10) (declare b -7) (return (si (bits (truncate (/ a b) 1) 31 0) 32))))(funcdef mod_int () (block (return (si (bits (rem 10 -7) 31 0) 32))))(funcdef mod_reg () (block (declare a 10) (declare b -7) (return (rem a b))))
