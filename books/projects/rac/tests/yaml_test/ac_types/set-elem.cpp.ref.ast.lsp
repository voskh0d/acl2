

(funcdef get (x) (block (assign x (setbitn x 4 2 (if1 0 true$ false$))) (return x)))
