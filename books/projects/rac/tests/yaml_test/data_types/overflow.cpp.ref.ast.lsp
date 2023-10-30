

(funcdef foo () (block (declare i #xFFFFFFFF) (return (bits (+ i 1) 31 0))))
