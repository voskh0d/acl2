(FUNCDEF FOO NIL
         (BLOCK (DECLARE X
                         (RAC-TYPE-INFO (BITS 43 3 0) '(BVEC 4)))
                (DECLARE Y (RAC-TYPE-INFO 3 '(BVEC 4)))
                (DECLARE Z (RAC-TYPE-INFO 2 '(BVEC 4)))
                (DECLARE RES (RAC-TYPE-INFO Z 'INT))
                (RETURN RES)))

