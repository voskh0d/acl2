

(funcdef foo (f) (block (return f)))(funcdef bar (f) (block (return (si (bits f 31 0) 32))))(funcdef main () (block (return (si (bits (+ (foo (bits 255 1 0)) (bar (bits 255 61 0))) 31 0) 32))))
