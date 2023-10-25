

(funcdef foo () (block (declare i (bits #xFFFFFFFF 31 0)) (return (bits (+ i 1) 31 0))))
