

(funcdef foo (i j) (block (return (si (bits (+ i j) 31 0) 32))))(funcdef foo2 (i j) (block (return (si (bits (+ i j) 31 0) 32))))(funcdef bar () (block (return (si (bits (+ (foo 2 4) (foo2 1 3)) 31 0) 32))))
