
(declare n 0)(declare s (as (quote a) 3 ()))(declare a 2)(declare b 2)(declare arr (quote (1 2 3 4)))(declare std_arr (quote (1 2)))
(funcdef foo () (block (return (si (bits (+ (si (bits (+ (a) (ag (quote a) (s))) 31 0) 32) (n)) 31 0) 32))))(funcdef bar () (block (list (declare c 4) (declare e 4) (declare f 4)) (return (nth 3 (arr)))))
