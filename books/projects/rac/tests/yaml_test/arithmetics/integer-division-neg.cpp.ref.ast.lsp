

(funcdef div_int () (block (return (fl (/ 10 -7)))))(funcdef div_reg () (block (declare a 10) (declare b -7) (return (si (bits (fl (/ a b)) 31 0) 32))))(funcdef mod_int () (block (return (si (bits (rem 10 -7) 31 0) 32))))(funcdef mod_reg () (block (declare a 10) (declare b -7) (return (rem a b))))
