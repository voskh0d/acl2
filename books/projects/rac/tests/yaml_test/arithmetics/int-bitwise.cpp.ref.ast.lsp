

(funcdef bit_and (a b) (block (return (logand a b))))(funcdef bit_or (a b) (block (return (logior a b))))(funcdef bit_not (a) (block (return (si (bits (lognot a) 31 0) 32))))(funcdef shift_left (a n) (block (return (si (bits (ash a n) 31 0) 32))))(funcdef shift_right (a n) (block (return (si (bits (ash a (- n)) 31 0) 32))))(funcdef bit_xor (a b) (block (return (logxor a b))))
