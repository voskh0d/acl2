; A stobj that contains a single byte array
;
; Copyright (C) 2021-2022 Kestrel Institute
;
; License: A 3-clause BSD license. See the file books/3BSD-mod.txt.
;
; Author: Eric Smith (eric.smith@kestrel.edu)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package "ACL2")

(local (include-book "kestrel/lists-light/resize-list" :dir :system))

;; A stobj with a single field, which is a byte array.
(defstobj byte-array-stobj
  (bytes :type (array (unsigned-byte 8) (0)) ; initially empty
         :initially 0
         :resizable t))

;; Names generated by defstobj:
(in-theory (disable byte-array-stobjp bytes-length resize-bytes bytesi update-bytesi))

(defthm bytes-length-of-update-bytesi
  (implies (and (natp next-index)
                (< next-index (bytes-length byte-array-stobj)))
           (equal (bytes-length (update-bytesi next-index val byte-array-stobj))
                  (bytes-length byte-array-stobj)))
  :hints (("Goal" :in-theory (enable update-bytesi bytes-length))))

(defthm bytes-length-of-resize-bytesi
  (implies (and (natp len))
           (equal (bytes-length (resize-bytes len byte-array-stobj))
                  len))
  :hints (("Goal" :in-theory (enable resize-bytes bytes-length))))
