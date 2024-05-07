

(funcdef foo (a b) (block (return (si (bits (logand1 a b) 31 0) 32))))(funcdef bar (a b) (block (return (si (bits (logand1 a b) 31 0) 32))))
