

(funcdef foo-0 () (block (return (si (bits (+ 2 4) 31 0) 32))))(funcdef foo2-0 () (block (return (si (bits (+ 1 3) 31 0) 32))))(funcdef bar () (block (return (si (bits (+ (foo-0) (foo2-0)) 31 0) 32))))
