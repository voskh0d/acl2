

(funcdef add (a b) (block (return (si (bits (+ a b) 31 0) 32))))(funcdef sub (a b) (block (return (si (bits (- a b) 31 0) 32))))(funcdef minus (a) (block (return (- a))))(funcdef mult (a b) (block (return (si (bits (* a b) 31 0) 32))))(funcdef div (a b) (block (return (truncate (/ a b) 1))))(funcdef mod (a b) (block (return (si (bits (rem a b) 31 0) 32))))(funcdef parenthesis (a) (block (return a)))
