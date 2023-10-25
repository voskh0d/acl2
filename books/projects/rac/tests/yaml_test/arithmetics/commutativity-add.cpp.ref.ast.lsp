

(funcdef foo (a b c) (block (return (si (bits (+ (si (bits (+ a b) 31 0) 32) c) 31 0) 32))))
