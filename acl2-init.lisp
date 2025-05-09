; ACL2 Version 8.6 -- A Computational Logic for Applicative Common Lisp
; Copyright (C) 2025, Regents of the University of Texas

; This version of ACL2 is a descendent of ACL2 Version 1.9, Copyright
; (C) 1997 Computational Logic, Inc.  See the documentation topic NOTE-2-0.

; This program is free software; you can redistribute it and/or modify
; it under the terms of the LICENSE file distributed with ACL2.

; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; LICENSE for more details.

; Written by:  Matt Kaufmann               and J Strother Moore
; email:       Kaufmann@cs.utexas.edu      and Moore@cs.utexas.edu
; Department of Computer Science
; University of Texas at Austin
; Austin, TX 78712 U.S.A.

; This file cannot be compiled because it changes packages in the middle.

; We use the static honsing scheme on 64-bit CCL.
#+(and ccl x86_64)
(push :static-hons *features*)

; We use the static honsing scheme on 64-bit GCL when the support is there.
; Actually, with our restriction to GCL Version 2.6.12 and later, we believe
; that the test below will always be true for ANSI GCL.
#+(and gcl x86_64)
(when (and (fboundp 'si::static-inverse-cons)
           (fboundp 'si::without-interrupts))
  (pushnew :static-hons *features*))

; Essay on Parallelism, Parallelism Warts, Parallelism Blemishes, Parallelism
; No-fixes, Parallelism Hazards, and #+ACL2-PAR notes.

; These sources incorporate code for an experimental extension for parallelism
; contributed by David Rager during his master's and Ph.D. dissertation work.
; That extension may be built by setting the :acl2-par feature, for example
; using make (see :DOC compiling-acl2p).  The incorporation of code supporting
; parallelism has been carried out while taking great pains to preserve the
; functionality of the ACL2 system proper (i.e., without the experimental
; extension for parallelism).

; At the lowest level, parallel computation is carried out by Lisp threads,
; which provide Lisp-level abstractions of OS threads.  A thread can be running
; or blocked (e.g., waiting for a semaphore signal).  Threads can create other
; threads.  We manage the creation and use of threads to reflect the resources
; we have available, for example the number of available cpu cores according to
; our own tracking.

; The implementation of the multi-threading primitives -- futures, spec-mv-let,
; plet, pargs, pand, and por -- has a dependency structure shown as follows.
; For example, multi-threading primitives are at the base of everything,
; futures and plet/pargs/pand/por are built on top of these primitives, and so
; forth, as indicated by the indentations.

; multi-threading primitives (semaphores, locks, condition variables, etc)
;   futures
;     spec-mv-let
;       waterfall parallelism
;       user-level program parallelism (no examples as of April 2012)
;   plet, pargs, pand, por
;     user-level program parallelism (e.g., community book
;                                     books/parallel/fibonacci.lisp)

; This dependency structure roughly correlates to the following file structure.

; #+acl2-par
; multi-threading-raw.lisp (defines multi-threading primitives)
;   parallel-raw.lisp  (provides raw Lisp defs. of plet, pargs, pand, and por)
;     futures-raw.lisp (defines futures and uses some helper functions
;                       from parallel-raw.lisp)
;       parallel.lisp
; #-acl2-par
; parallel.lisp

; One might wonder how we use threads to execute pieces of parallelism work
; (where "pieces of parallelism work" can mean either futures, bindings of
; plet, arguments of calls surrounded by pargs, or arguments given to pand or
; por).  For futures, the story is as follows.

; (1) A primitive adds a piece of parallelism work to one of the two
;     parallelism queues (either *future-array* or *work-queue*, as
;     appropriate).
;
; (2) The primitive checks to see if there are enough threads already in
;     existence to process that piece of parallelism work.  If so, the
;     primitive returns and execution continues until the result of the
;     parallelized computation is needed.  If not, the primitive creates one to
;     many "worker threads" to consume pieces of parallelism work.
;
; (3) The primitive may eventually need the result from the piece of
;     parallelism work.  In this case, it will read the value from the piece of
;     parallelism work (once it is available) and use it as appropriate.  In
;     the case that the primitive does not need the value (as can happen with a
;     pand/por or a spec-mv-let, when the speculative computation is determined
;     to be useless), the primitive will abort (or early terminate) the
;     parallel execution of the piece of parallelism work.
;
; When a worker thread is created, it performs the following sequence of
; steps.
;
; (A) Waits until there is a piece of parallelism work to consume.  A worker
;     thread will wait between 10 and 120 seconds before "giving up", unwinding
;     itself, and freeing itself as a resource for the operating system to
;     collect.  The reader might be tempted to assume that there would
;     immediately be work, but this is not guaranteed to be the case (because,
;     for efficiency reasons, we typically create a handful more threads than
;     are needed).
;
; (B) Waits until there is an idle CPU core available, as determined by our
;     resource management using the multi-threading primitives available to us
;     in the Lisp (as opposed to trying to tell the operating system how to
;     schedule our threads).  There is no timeout associated with this wait.
;
; (C) Making it to (C) requires that the thread first made it through (A) and
;     then also made it through (B).  Thus, the thread has both a piece of
;     parallelism work and a CPU core.  At this point, the thread executes that
;     piece of parallelism work.
;
; (D) Perhaps the piece of parallelism work itself encounters a parallelism
;     primitive and decides to further parallelize execution.  In this case,
;     the worker thread will do (1), (2), and (3), as explained above.
;
; (E) At this point, the worker thread has finished executing the piece of
;     parallelism work and stores the result of that execution in the
;     appropriate place (e.g., for futures, it stores the execution result in
;     the "value" slot of the future).
;
; (F) After performing some cleanup, the thread goes back to (A).

; We use the phrase "Parallelism wart:" to label comments about known issues
; for the #+acl2-par build of ACL2 that we would like to fix, time permitting.
; We also use the phrase "Parallelism blemish:" to identify known issues for
; the #+acl2-par build of ACL2 that we intend to fix only if led to do so by
; user complaints.  Finally, we use the phrase "Parallelism no-fix:" to label
; comments about known issues for the #+acl2-par build of ACL2 that we do not
; intend to fix, though we could reclassify these if there are sufficiently
; strong user complaints.  Searching through the parallelism warts, blemishes,
; and no-fixes could be useful when a user reports a bug in #+acl2-par that
; cannot be replicated in #-acl2-par.

; Parallelism hazards are unrelated to parallelism warts, blemishes, and
; no-fixes.  Parallelism hazards are macros or functions that are known to be
; theoretically unsafe when performing multi-threaded execution.  We originally
; did not expect users to encounter parallelism hazards (because we should have
; programmed such that the hazards never occur).  However, in practice, these
; parallelism hazards are somewhat common and we have disabled the automatic
; warning that occurs every time a hazard occurs.  Once we re-enable that
; warning, in the event that users encounter a parallelism hazard, they will be
; asked to report the associated warning to the ACL2 maintainers.  For example,
; if state-global-let* is called while executing concurrently, we want to know
; about it and develop a work-around.  See *possible-parallelism-hazards* and
; warn-about-parallelism-hazard for more information.

; #+ACL2-PAR notes contain documentation that only applies to #+acl2-par.

; In an effort to avoid code duplication, we created a definition scheme that
; supports defining both serial and parallel versions of a function with one
; call to a defun-like macro.  See the definitions of @par-mappings and
; defun@par for an explanation of this scheme.

; Developer note on emacs and parallelism.  When comparing with versions up
; through svn revision 335 (May 27, 2011), it may be useful to ignore "@par"
; when ignoring whitespace with meta-x compare-windows in emacs.
;   (setq compare-windows-whitespace "\\(@par\\)?[ \t\n]+")
; To revert to the default behavior:
;   (setq compare-windows-whitespace
;   "\\(\\s-\\|
;   \\)+")
; We indent certain calls as we indent calls of defun.  (These forms are in
; emacs/emacs-acl2.el.)
;   (put 'er@par       'lisp-indent-function 'defun)
;   (put 'warning$@par 'lisp-indent-function 'defun)
; To revert:
;   (put 'er@par       'lisp-indent-function nil)
;   (put 'warning$@par 'lisp-indent-function nil)

; Only allow the feature :acl2-par in environments that support
; multi-threading.  Keep this in sync with the error message about CCL,
; Lispworks, and SBCL in set-parallel-execution-fn and with :doc
; compiling-acl2p.  If we add support for non-ANSI GCL, consider providing a
; call of reset-parallelism-variables analogous to the one generated by setting
; *reset-parallelism-variables* in our-abort.

#+(and acl2-par (not ccl) (not (and sbcl sb-thread)) (not lispworks))
(error "It is currently illegal to build the parallel version of ACL2 in this
Common Lisp.  See source file acl2-init.lisp for this error message,
which is preceded by information (Lisp features) indicating the legal Lisp
implementations.")

#+gcl
(setq si:*notify-gbc* t)

; The following has been superseded; see the section on reading characters from
; files in acl2.lisp.
;  ; Dave Greve reported a problem: the saved_acl2 script in CLISP had characters
;  ; that, contrary to expectation, were not being interpreted as newlines.  The
;  ; CLISP folks explained that "CUSTOM:*DEFAULT-FILE-ENCODING* defaults to :DOS
;  ; on cygwin, so #\Newline is printed as '\r\n' (CRLF)."  We expect that the
;  ; following setting will fix the problem; Dave tried an experiment for us that
;  ; seemed to validate this expectation.
;  #+clisp
;  (setq CUSTOM:*DEFAULT-FILE-ENCODING* :unix)

#+lispworks
(hcl:extend-current-stack

; For LispWorks, we extend the stack size to avoid stack overflows.

; We have also considered setting system::*stack-overflow-behaviour* to nil (as
; we did in ACL2 Version 7.4 and some (perhaps many) versions earlier -- or
; :warn, as we did similarly for ACL2(p).  However, it seems best not to mess
; with the default of :error: a stack overflow seems unlikely to be caught with
; safety 0, and with safety 3, we prefer to see the error rather than having
; the stack automatically extended, so that we can find the offending loop and
; fix it.  For example, for the community book books/centaur/truth/perm4.lisp,
; we sent a bug report to LispWorks (during post-7.4 development) for a hang in
; "Computing the guard conjecture for RECORD-ALL-NPN4-PERMS-TOP"; but the
; problem was simply a stack overflow.  We didn't catch the problem with safety
; 3 because system::*stack-overflow-behaviour* was nil, so the stack grew
; automatically.  Why not set it to nil for safety 0 and :error for safety 3?
; Because perhaps (not sure) when investigating an issue with safety 3, we
; could get stack overflows that aren't actually the problem.

; We choose 20000 somewhat arbitrarily.  The value of 400 (representing a 4x
; addition, i.e., increasing the stack by a factor of 5) was insufficient for
; community book books/centaur/aignet/rwlib.lisp (this, before unmemoizing
; bad-lisp-consp): we had to increase the stack 50% seven times in order to
; complete a LD of that book.  Since (* 5 (expt 1.5 7)) = 85, we needed to add
; a total of something like 8400% to the default stack size.  So 10000 might be
; safe, but 20000 seems safer.

 20000)

; We have observed a significant speedup with Allegro CL when turning off
; its cross-referencing capability.  Here are the times before and after
; evaluating the setq form below, in an example from Dave Greve that spends
; a lot of time loading compiled files.
;
; 165.43 seconds realtime, 163.84 seconds runtime.
; 120.23 seconds realtime, 118.32 seconds runtime.
;
; The user is welcome to edit the form below.  Note that it doesn't seem to
; affect the profiler.
#+allegro
(setq excl::*record-xref-info* nil
      excl::*load-xref-info* nil
      excl::*record-source-file-info* nil
      excl::*load-source-file-info* nil)

; Create the packages we use.

(load "acl2.lisp")

; Now that acl2-fns.lisp has been loaded (by loading acl2.lisp) so that
; getenv$-raw has been defined, we can evaluate the code that may set feature
; :acl2-small-fixnums.
(let* ((smallp (acl2::getenv$-raw "ACL2_SMALL_FIXNUMS"))
       (smallp (and smallp
                    (not (equal smallp "")))))
  (cond
   ((and (>= most-positive-fixnum (1- (expt 2 60)))
         (<= most-negative-fixnum (- (expt 2 60)))
         (not smallp))

; ACL2 will assume that every fixnum is of type (signed-byte 61),
; hence also of type (unsigned-byte 60) if it is non-negative.

    nil)
   ((and (>= most-positive-fixnum (1- (expt 2 29)))
         (<= most-negative-fixnum (- (expt 2 29))))
    (cond (smallp

; ACL2 will assume that every fixnum is of type (signed-byte 30),
; hence also of type (unsigned-byte 29) if it is non-negative.

           (pushnew :acl2-small-fixnums *features*))
          (t
           (error "ACL2 generally assumes that all integers that are
at least -2^60 but less than 2^60 are Lisp fixnums,
but that is not the case for this Lisp implementation.
You can defeat this check by setting environment variable
ACL2_SMALL_FIXNUMS to a non-empty value when building the
ACL2 executable.  However, such ACL2 builds are not as
fully tested as the usual builds and thus may be less
reliable, and they are not guaranteed to work compatibly
with ordinary ACL2 builds on the same set of books."))))
   (t

; The absolute value of most-positive-fixnum or of most-negative-fixnum is too
; sall for ACL2.

    (error "This Lisp implementation is not a suitable host for ACL2:
the values of most-negative-fixnum and most-positive-fixnum are
~s and ~s (respectively),
but ACL2 assumes that these have absolute values that are
respectively at least (1- (expt 2 29)) and (expt 2 29), which are
~s and ~s, respectively."
           most-positive-fixnum
           most-negative-fixnum
           (1- (expt 2 29))
           (expt 2 29)))))

(acl2::proclaim-optimize)

; Fix a bug in SBCL 1.0.49 (https://bugs.launchpad.net/bugs/795705), thanks to
; patch provided by Nikodemus Siivola.
#+sbcl
(in-package :sb-c)
#+sbcl
(when (equal (lisp-implementation-version) "1.0.49")
  (without-package-locks

   (defun undefine-fun-name (name)
     (when name
       (macrolet ((frob (type &optional val)
                        `(unless (eq (info :function ,type name) ,val)
                           (setf (info :function ,type name) ,val))))
                 (frob :info)
                 (frob :type (specifier-type 'function))
                 (frob :where-from :assumed)
                 (frob :inlinep)
                 (frob :kind)
                 (frob :macro-function)
                 (frob :inline-expansion-designator)
                 (frob :source-transform)
                 (frob :structure-accessor)
                 (frob :assumed-type)))
     (values))
   ))

; WARNING: The next form should be an in-package (see in-package form for sbcl
; just above).

;  Now over to the "ACL2" package for the rest of this file.

(in-package "ACL2")

(defconstant *current-acl2-world-key*

; *Current-acl2-world-key* is the property used for the current-acl2-world
; world.  We formerly used a defvar, but there seemed to be no reason to use a
; special variable, which Gary Byers has pointed out takes about 5 instructions
; to read in CCL in order to check if a thread-local binding is dynamically in
; effect.  So we tried using a defconstant.  Unfortunately, that trick failed
; in Allegro CL; even if we use a boundp test to guard the defconstant, when we
; used make-symbol to create the value; the build failed.  So the value is now
; an interned symbol.

  'acl2_invisible::*CURRENT-ACL2-WORLD-KEY*)

#+cltl2
(when (not (boundp 'COMMON-LISP::*PRINT-PPRINT-DISPATCH*))

; Many improvements were made to ANSI GCL in May, 2013.  If
; COMMON-LISP::*PRINT-PPRINT-DISPATCH* is unbound, then something is wrong with
; this Lisp.  In particular, with-standard-io-syntax might not work correctly.

   (exit-with-build-error
    "ERROR: We do not support building ACL2 in~%~
     a host ANSI Common Lisp when variable ~s is~%~
     unbound.  Please obtain a more recent version of your Lisp~%~
     implementation."
    'COMMON-LISP::*PRINT-PPRINT-DISPATCH*))

#+(and gcl cltl2)
; Deal with undefined cltl2 symbols in ANSI GCL, using values that would be
; assigned by with-standard-io-syntax.
(loop for pair in '((COMMON-LISP::*PRINT-LINES* . nil)
                    (COMMON-LISP::*PRINT-MISER-WIDTH* . nil)
                    (COMMON-LISP::*PRINT-RIGHT-MARGIN* . nil)
                    (COMMON-LISP::*READ-EVAL* . t))
      when (not (boundp (car pair)))
      do (progn (proclaim `(special ,(car pair)))
                (setf (symbol-value (car pair))
                      (cdr pair))))

; It is a mystery why the following proclamation is necessary, but it
; SEEMS to be necessary in order to permit the interaction of tracing
; with the redefinition of si::break-level.

#+gcl
(declaim (special si::arglist))

#+gcl
(let ((v (symbol-function 'si::break-level)))
  (setf (symbol-function 'si::break-level)
        (function
         (lambda (&rest rst)
           (format t "~%Raw Lisp Break.~%")
           (apply v rst)))))

(defun system-call (string arguments)

; Warning: Keep this in sync with system-call+.

; Unlike system-call+, we allow an error to occur.

  #+gcl
  (when (not (fboundp 'si::system))
    (exit-with-build-error
     "SYSTEM-CALL is not defined in this version of GCL."))

  #+gcl
  (si::system ; if undefined, ignore compiler warning; see check above
   (let ((result string))
     (dolist
      (x arguments)
      (setq result (concatenate 'string result " " x)))
     result))
  #+lispworks
  (system::call-system
   (let ((result string))
     (dolist
      (x arguments)
      (setq result (concatenate 'string result " " x)))
     result))
  #+allegro
  (let ((result string))
    (dolist
      (x arguments)
      (setq result (concatenate 'string result " " x)))
    #-unix
    (excl::run-shell-commad result)
    #+unix

; In Allegro CL in Unix, we can avoid spawning a new shell by calling
; run-shell-command on a simple vector.  So we parse the resulting string "cmd
; arg1 ... argk" and run with the simple vector #(cmd cmd arg1 ... argk).

    (excl::run-shell-command
     (let ((lst nil)
           (len (length result))
           (n 0))
       (loop
        (if (>= n len) (return)) ; else get next word
        (let ((start n)
              (ch (char result n)))
          (cond
           ((member ch '(#\Space #\Tab))
            (setq n (1+ n)))
           (t (loop
               (if (or (>= n len)
                       (member (setq ch (char result n))
                               '(#\Space #\Tab)))
                   (return)
                 (setq n (1+ n))))
              (setq lst (cons (subseq result start n)
                              lst))))))
       (setq result (nreverse lst))
       (setq result (coerce (cons (car result) result) 'vector)))))
  #+cmu
  (let ((ans (ext:process-exit-code
              (common-lisp-user::run-program string arguments :output t))))
    (if (integerp ans) ans 1))
  #+sbcl
  (let ((ans (sb-ext:process-exit-code
              (sb-ext:run-program string arguments
                                  :output t
                                  :search t))))
    (if (integerp ans) ans 1))
  #+clisp
  (let ((result (ext:run-program string :arguments arguments)))
    (or result 0))
  #+ccl
  (let* ((proc (ccl::run-program string arguments :output t))
         (status (multiple-value-list (ccl::external-process-status proc))))
    (if (not (and (consp status)
                  (eq (car status) :EXITED)
                  (consp (cdr status))
                  (integerp (cadr status))))
        1 ; just some non-zero exit code here
      (cadr status)))
  #-(or gcl lispworks allegro cmu sbcl clisp ccl)
  (declare (ignore string arguments))
  #-(or gcl lispworks allegro cmu sbcl clisp ccl)
  (error "SYSTEM-CALL is not yet defined in this Lisp."))

(defun read-file-by-lines (file &optional delete-after-reading)
  (let ((acc nil)
        (eof '(nil))
        missing-newline-p)
    (with-open-file
     (s file :direction :input)
     (loop (multiple-value-bind (line temp)
               (read-line s nil eof)
             (cond ((eq line eof)
                    (return acc))
                   (t
                    (setq missing-newline-p temp)
                    (setq acc
                          (if acc
                              (concatenate 'string acc (string #\Newline) line)
                            line)))))))
    (when delete-after-reading
      (delete-file file))
    (if missing-newline-p
        acc
      (concatenate 'string acc (string #\Newline)))))

(defun getpid$ ()

; This function is intended to return the process id.  But it may return nil
; instead, depending on the underlying lisp platform.

  (let ((fn
         #+allegro 'excl::getpid
         #+gcl 'si::getpid
         #+sbcl 'sb-unix::unix-getpid
         #+cmu 'unix::unix-getpid
         #+clisp (or (let ((fn0 (find-symbol "PROCESS-ID" "SYSTEM")))
                       (and (fboundp fn0) ; CLISP 2.34
                            fn0))
                     (let ((fn0 (find-symbol "PROGRAM-ID" "SYSTEM")))
                       (and (fboundp fn0) ; before CLISP 2.34
                            fn0)))
         #+ccl 'ccl::getpid
         #+lispworks 'system::getpid
         #-(or allegro gcl sbcl cmu clisp ccl lispworks) nil))
    (and fn
         (fboundp fn)
         (funcall fn))))

(defun system-call+ (string arguments)

; Warning: Keep this in sync with system-call.

; Unlike system-call, we catch Lisp errors and treat the status as 1 in those
; cases.

  #-(or gcl lispworks allegro cmu sbcl clisp ccl)
  (declare (ignore string arguments))
  #-(or gcl lispworks allegro cmu sbcl clisp ccl)
  (error "SYSTEM-CALL is not yet defined in this Lisp.")

  #+gcl
  (when (not (fboundp 'si::system))
    (exit-with-build-error
     "SYSTEM-CALL is not defined in this version of GCL."))

  (let* (exit-code ; assigned below
         #+(or gcl clisp)
         (tmp-file (format nil
                           "~a/tmp~s"
                           (or (our-ignore-errors
                                (f-get-global 'tmp-dir *the-live-state*))
                               "/tmp")
                           (getpid$)))
         (output-string
          (our-ignore-errors
           #+gcl ; does wildcard expansion
           (progn (setq exit-code
; If si::system is undefined, ignore compiler warning; see check above.
                        (si::system
                         (let ((result string))
                           (dolist
                             (x arguments)
                             (setq result (concatenate 'string result " " x)))
                           (concatenate 'string result " > " tmp-file))))
                  (read-file-by-lines tmp-file t))
           #+lispworks ; does wildcard expansion (see comment below)
           (with-output-to-string
             (s)
             (setq exit-code
                   (system::call-system-showing-output

; It was tempting to use (cons string arguments).  This would cause the given
; command, string, to be applied to the given arguments, without involving the
; shell.  But then a command such as "ls" would not work; one would have to
; provide a string such as "/bin/ls".  So instead of using a list here, we use
; a string, which according to the LispWorks manual will invoke the shell,
; which will find commands (presumably including built-ins and also using the
; user's path).

                    (let ((result string))
                      (dolist
                        (x arguments)
                        (setq result (concatenate 'string result " " x)))
                      result)
                    :output-stream s
                    :prefix ""
                    :show-cmd nil
                    :kill-process-on-abort t)))
           #+allegro ; does wildcard expansion
           (multiple-value-bind
            (stdout-lines stderr-lines exit-status)
            (excl.osi::command-output
             (let ((result string))
               (dolist
                 (x arguments)
                 (setq result (concatenate 'string result " " x)))
               result))
            (declare (ignore stderr-lines))
            (setq exit-code exit-status)
            (let ((acc nil))
              (loop for line in stdout-lines
                    do
                    (setq acc
                          (if acc
                              (concatenate 'string
                                           acc
                                           (string #\Newline)
                                           line)
                            line)))
              acc))
           #+cmu
           (with-output-to-string
             (s)
             (setq exit-code
                   (let (temp)
                     (if (progn
                           (setq temp
                                 (ext:process-exit-code
                                  (common-lisp-user::run-program
                                   string arguments
                                   :output s)))
                           1)
                         temp
                       1))))
           #+sbcl
           (with-output-to-string
             (s)
             (setq exit-code
                   (let (temp)
                     (if (progn
                           (setq temp
                                 (sb-ext:process-exit-code
                                  (sb-ext:run-program string arguments
                                                      :output s
                                                      :search t)))
                           1)
                         temp
                       1))))
           #+clisp
           (progn (setq exit-code
                        (or (ext:run-program string
                                             :arguments arguments
                                             :output tmp-file)
                            0))
                  (read-file-by-lines tmp-file t))
           #+ccl
           (with-output-to-string
             (s)
             (setq exit-code
                   (let* ((proc
                           (ccl::run-program string arguments
                                             :output s
                                             :wait t))
                          (status (multiple-value-list
                                   (ccl::external-process-status proc))))
                     (if (not (and (consp status)
                                   (eq (car status) :EXITED)
                                   (consp (cdr status))
                                   (integerp (cadr status))))
                         1 ; just some non-zero exit code here
                       (cadr status))))))))
    (values (if (integerp exit-code)
                exit-code
              1)
            (if (stringp output-string)
                output-string
              ""))))

(defun our-probe-file (filename)

; Use this function instead of probe-file if filename might be a directory.

; We noticed that GCL 2.6.7 on 64-bit Linux doesn't recognize directories with
; probe-file.  So we use directory instead, which we have found to work in both
; 32-bit and 64-bit Linux environments.

; BUG: It appears that this function returns nil in GCL 2.6.7 when given an
; existing but empty directory.

  #+gcl
  (or (probe-file filename)
      (let ((x (cond ((and (not (equal filename ""))
                           (eql (char filename (1- (length filename))) #\/))
                      (subseq filename 0 (1- (length filename))))
                     (t filename))))
        (directory x)))
  #-gcl
  (probe-file filename))

(defun copy-distribution (output-file source-directory target-directory
                                      &optional
                                      (all-files "all-files.txt")
                                      (use-existing-target nil))

; We check that all files and directories exist that are supposed to exist.  We
; cause an error if not, which ultimately will cause the Unix process that
; calls this function to return an error status, thus halting the make of which
; this operation is a part.  Wart:  Since probe-file does not check names with
; wildcards, we skip those.

; This function calls error rather than exit-with-build-error simply because
; we don't expect it to be called much by users and if a user does call it,
; then it might be from within an existing session, not at build time.

; Note:  This function does not actually do any copying or directory creation;
; rather, it creates a file that can be executed.

; FIRST, we make sure we are in the expected directory.

  (cond ((not (and (stringp source-directory)
                   (not (equal source-directory ""))))
         (error "The source directory specified for COPY-DISTRIBUTION~%~
                 must be a non-empty string, but~%~s~%is not."
                source-directory)))
  (cond ((not (and (stringp target-directory)
                   (not (equal target-directory ""))))
         (error "The target directory specified for COPY-DISTRIBUTION~%must ~
                 be a non-empty string, but~%~s~%is not.  (If you invoked ~
                 \"make copy-distribution\", perhaps you forgot to set DIR.)"
                target-directory)))
  (cond ((eql (char source-directory (1- (length source-directory))) #\/)

; In this code we treat all directories as names without the trailing slash.

         (setq source-directory
               (subseq source-directory 0 (1- (length source-directory))))))
  (cond ((not (equal (our-truename (format nil "~a/" source-directory) :safe)
                     (our-truename
                      ""
                      "Note: Calling OUR-TRUENAME from COPY-DISTRIBUTION.")))
         (error "We expected to be in the directory~%~s~%~
                 but instead are apparently in the directory~%~s .~%~
                 Either issue, in Unix, the command~%~
                 cd ~a~%~
                 or else edit the file (presumably, makefile) from~%~
                 which the function COPY-DISTRIBUTION was called,~%~
                 in order to give it the correct second argument."
                source-directory
                (our-truename "" t)
                source-directory)))

; Next, check that everything exists that is supposed to.

  (cond ((and (not use-existing-target)
              (our-probe-file target-directory))
         (error "Aborting copying of the distribution.  The target ~%~
                 distribution directory~%~s~%~
                 already exists!  You may wish to execute the following~%~
                 Unix command to remove it and all its contents:~%~
                 rm -r ~a"
                target-directory target-directory)))
  (format t "Checking that distribution files are all present.~%")
  (let (missing-files)
    (with-open-file
     (str (concatenate 'string source-directory "/" all-files)
          :direction :input)
     (let (filename (dir nil))
       (loop (setq filename (read-line str nil))
             (cond
              ((null filename) (return))
              ((or (equal filename "")
                   (equal (char filename 0) #\#)))
              ((find #\Tab filename)
               (error "Found a line with a Tab in it:  ~s" filename))
              ((find #\Space filename)
               (error "Found a line with a Space in it:  ~s" filename))
              ((find #\* filename)
               (format t "Skipping wildcard file name, ~s.~%" filename))
              ((eql (char filename (1- (length filename))) #\:)

; No need to check for directories here; they'll get checked elsewhere.  But
; it's harmless enough to do so.

               (let* ((new-dir (subseq filename 0 (1- (length filename))))
                      (absolute-dir
                       (format nil "~a/~a" source-directory new-dir)))
                 (cond
                  ((our-probe-file absolute-dir)
                   (setq dir new-dir))
                  (t
                   (setq missing-files
                         (cons absolute-dir missing-files))
                   (error "Failed to find directory ~a ."
                          absolute-dir)))))
              (t (let ((absolute-filename
                        (if dir
                            (format nil "~a/~a/~a" source-directory dir filename)
                          (format nil "~a/~a" source-directory filename))))
                   (cond
                    ((not (our-probe-file absolute-filename))
                     (setq missing-files
                           (cons absolute-filename missing-files))
                     (format t "Failed to find file ~a.~%" absolute-filename)))))))))
    (cond
     (missing-files
      (error "~%Missing the following files (and/or directories):~%~s"
             missing-files))
     (t (format t "Distribution files are all present.~%"))))

  (format t "Preparing to copy distribution files from~%~a/~%to~%~a/ .~%"
          source-directory target-directory)
  (let (all-dirs)

; In this pass, we look only for directory names.

    (with-open-file
     (str (concatenate 'string source-directory "/" all-files)
          :direction :input)
     (let (filename)
       (loop (setq filename (read-line str nil))
             (cond
              ((null filename) (return))
              ((or (equal filename "")
                   (equal (char filename 0) #\#)))
              ((find #\Tab filename)
               (error "Found a line with a Tab in it:  ~s" filename))
              ((find #\Space filename)
               (error "Found a line with a Space in it:  ~s" filename))
              ((eql (char filename (1- (length filename))) #\:)
               (setq all-dirs
                     (cons (subseq filename 0 (1- (length filename)))
                           all-dirs)))))))

; In the final pass we do our writing.

    (with-open-file
     (str (concatenate 'string source-directory "/" all-files)
          :direction :input)
     (with-open-file
      (outstr output-file :direction :output)
      (let (filename (dir nil))
        (if (not use-existing-target)
            (format outstr "mkdir ~a~%~%" target-directory))
        (loop (setq filename (read-line str nil))
              (cond
               ((null filename) (return))
               ((or (equal filename "")
                    (equal (char filename 0) #\#)))
               ((eql (char filename (1- (length filename))) #\:)
                (setq dir (subseq filename 0 (1- (length filename))))
                (format outstr "~%mkdir ~a/~a~%"
                        target-directory dir))
               ((null dir)
                (cond ((not (member filename all-dirs
                                    :test 'equal))
                       (format outstr "cp -p ~a/~a ~a~%"
                               source-directory
                               filename
                               target-directory))))
               (t
                (cond ((not (member (format nil "~a/~a"
                                            dir filename)
                                    all-dirs
                                    :test 'equal))
                       (format outstr "cp -p ~a/~a/~a ~a/~a~%"
                               source-directory
                               dir
                               filename
                               target-directory
                               dir)))))))))

    (format t "Finished creating a command file for copying distribution files.")))

(defun make-tags ()
  (when (not (eql (ignore-errors (system-call "which" '("etags"))) 0))
    (format t "SKIPPING etags: No such program is in the path.")
    (return-from make-tags 1))
  (system-call "etags"
               (let* ((fmt-str
                       #+(or cmu sbcl clisp ccl) "~a.lisp"
                       #-(or cmu sbcl clisp ccl) " ~a.lisp")
                      (lst (append '("acl2.lisp"
                                     "acl2-check.lisp"
                                     "acl2-fns.lisp"
                                     "init.lisp"
                                     "acl2-init.lisp"
                                     "akcl-acl2-trace.lisp"
                                     "allegro-acl2-trace.lisp"
                                     "openmcl-acl2-trace.lisp")
                                   (let ((result nil))
                                     (dolist
                                       (x *acl2-files*)

; Since we don't want to edit doc.lisp, don't go there with tags.

                                       (when (not (equal x "doc.lisp"))
                                         (setq result
                                               (cons (format nil fmt-str x)
                                                     result))))
                                     (reverse result)))))
                 #+acl2-par
                 lst
                 #-acl2-par
                 (append lst (list "multi-threading-raw.lisp"
                                   "futures-raw.lisp"
                                   "parallel-raw.lisp")))))

(defvar *saved-build-date-lst* nil)

(defun git-commit-hash (&optional quiet)
  (multiple-value-bind
   (exit-code hash)
   (ignore-errors (system-call+ "git" '("rev-parse" "HEAD")))
   (cond ((and (eql exit-code 0)
               (stringp hash))
          (coerce (remove #\Newline (coerce hash 'list))
                  'string))
         (quiet nil)
         (t (exit-with-build-error "Unable to determine git commit hash.")))))

(defvar *acl2-release-p*

; Notes to developers (users should ignore this!):

;   (1) Replace the value below by t when making a release, then to nil after a
;       release.

;   (2) More generally, see UT CS file
;       /projects/acl2/devel-misc/release.cmds
;       for release instructions.

  nil)

(defun acl2-snapshot-info ()
  (let* ((var "ACL2_SNAPSHOT_INFO")
         (s (getenv$-raw var))
         (err-string
          "Unable to determine git commit hash for use in the startup~%~
           banner.  Consider setting environment variable ACL2_SNAPSHOT_INFO~%~
           to a message to use in its place, or set it to NONE if you simply~%~
           want to avoid this error."))
    (cond ((and s (string-equal s "NONE"))
           (format nil "~% +~72t+"))
          ((and s (not (equal s "")))
           (format nil
                   "~% +   (Note from the environment when this executable was ~
                    saved:~72t+~% +    ~a)~72t+"
                   s))
          (*acl2-release-p* "")
          (t (let ((h (git-commit-hash t)))
               (cond (h
                      (format nil
                              "~% +   (Git commit hash: ~a)~72t+"
                              h))
                     (t (exit-with-build-error err-string var))))))))

(defvar *saved-string*
  (concatenate
   'string
   "~% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
   "~% + ~a~72t+"
   "~% +   built ~a.~72t+"
   (acl2-snapshot-info)
   "~% + Copyright (C) 2025, Regents of the University of Texas.~72t+"
   "~% + ACL2 comes with ABSOLUTELY NO WARRANTY.  This is free software and~72t+"
   "~% + you are welcome to redistribute it under certain conditions.  For~72t+"
   "~% + details, see the LICENSE file distributed with ACL2.~72t+"
   "~% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++~%"

; Here, we formerly printed "Includes support for hash cons, memoization, and
; applicative hash tables."  Now that ACL2(c) is deprecated, we have decided
; that this is no longer appropriate to print (after all, we don't say that
; ACL2 includes support for rewriting).

   #+acl2-par
   "~%~% Experimental modification for parallel evaluation.  Please expect at~
    ~% most limited maintenance for this version~%"))

(defun maybe-load-acl2-init ()
  (let* ((home (our-user-homedir-pathname))
         (fl (and home
                  (probe-file (merge-pathnames home "acl2-init.lsp")))))
    (when fl
      (format t "; Loading file ~s...~%" fl)
      (load fl)
      (format t "; Finished loading file ~s.~%" fl))))

(defun chmod-executable (sysout-name)
  (system-call "chmod" (list "+x" sysout-name)))

(defun saved-build-dates (separator)
  (let* ((date-lst (reverse *saved-build-date-lst*))
         (result (car date-lst))
         (sep (concatenate
               'string
               (string #\Newline)
               (if (eq separator :terminal)
                   (concatenate
                    'string
                    (make-string (+ 3 (length *copy-of-acl2-version*))
                                 :initial-element #\Space)
                    "then ")
                 separator))))
    (dolist (s (cdr date-lst))
      (setq result (concatenate 'string result sep s)))
    result))

(defmacro our-with-standard-io-syntax (&rest args)

; See comment about SBCL below.

; Note for GCL:
; As of late May 2013, with-standard-io-syntax seems to work properly in ANSI
; GCL.

  #-cltl2
  (cons 'progn args)

  #+(and cltl2 (not sbcl))
  (cons 'with-standard-io-syntax args)

; For sbcl we bind *print-readably* to nil.  Otherwise, there is a problem with
; the call of write-exec-file in save-acl2-in-sbcl-aux: write-exec-file uses
; our-with-standard-io-syntax, which (without the fix below) has caused the
; printing of variable PROG (using format directive ~s) to produce not a
; string, but rather, a structure like this: #A((62) BASE-CHAR . "<string>").
  #+(and cltl2 sbcl)
  `(with-standard-io-syntax
    (let ((*print-readably* nil))
      ,@args)))

(defun user-args-string (inert-args &optional (separator '"--"))

; This function is used when saving executable scripts, which may specify that
; certain command line arguments are not to be processed by Lisp (other than to
; affect the value of a variable or function such as
; ccl::*unprocessed-command-line-arguments*; see books/oslib/argv.lisp).  Also
; see :doc save-exec.  A common convention is that arguments after `--' are not
; processed by Lisp.

  (cond ((null inert-args)
         "\"$@\"")
        ((eq inert-args t)
         (concatenate 'string separator " \"$@\""))
        (t
         (concatenate 'string separator " " inert-args " \"$@\""))))

(defmacro write-exec-file (stream prefix string &rest args)

; Prefix is generally nil, but can be (string . fmt-args).  String is the
; actual command invocation, with the indicated format args, args.

  `(our-with-standard-io-syntax ; Thus, we hope that progn is OK for GCL!
    (format ,stream "#!/bin/sh~%~%")
    (format ,stream
            "# Saved ~a~%~%"
            (saved-build-dates "#  then "))
    ,@(and prefix
           `((format ,stream ,(car prefix) ,@(cdr prefix))))
    (format ,stream

; We generally take Noah Friedman's suggestion of using "exec" since there is
; no reason to keep the saved_acl2 shell script in the process table.  However,
; we have seen Windows write out "C:..." as the path of the executable, because
; that is what truename produces.  But then the "exec" seems to consider that
; to be a relative pathname, and invoking ./saved_acl2 thus fails.  So we
; eliminate the "exec" in Windows; we have found that this works fine, at least
; for GCL and SBCL.

            #-mswindows
            (concatenate 'string "exec " ,string)
            #+mswindows
            ,string
            ,@args)))

(defun proclaim-files (outfilename)

; When *do-proclaims* is true, this function proclaims types for forms
; introduced in files among *acl2-files*.  It assumes that the defconst and
; defmacro forms in those files have already been evaluated, for example by
; loading those files first.

  (unless (and *do-proclaims*
               (not (eq *do-proclaims* :gcl)))
    (return-from proclaim-files nil))
  (when (probe-file outfilename)
    (delete-file outfilename))
  (format t
          "Writing proclaim forms for ACL2 source files to file ~s.~%"
          outfilename)
  #+gcl
  (when (eq *do-proclaims* :gcl)
    (when (not (equal outfilename "sys-proclaim.lisp"))
      (if (probe-file "sys-proclaim.lisp")
          (rename-file "sys-proclaim.lisp" outfilename)
        (error "File sys-proclaim.lisp does not exist!")))
    (return-from proclaim-files nil))
  (let (str)
    (or (setq str (safe-open outfilename :direction :output))
        (error "Unable to open file ~s for output." outfilename))

; It is tempting to print an in-package form, but we leave that task to
; proclaim-file.

    (dolist (fl *acl2-files*)
      (when (not (equal fl "doc.lisp")) ; no need to proclaim that one!
        (proclaim-file (format nil "~a.lisp" fl) str)))
    (close str)))

(defun insert-string (s)
  (cond ((null s) "")
        (t (concatenate 'string " " s))))

(defconstant *thisscriptdir-def*

; Thanks to Eric Smith for the idea of providing this sort of support for using
; a relative pathname to allow some movability of the saved script, to Sol
; Swords for pointing out issues with the initial solution when there is a
; symlink living in another directory, and to the website
; https://serverfault.com/questions/40144/how-can-i-retrieve-the-absolute-filename-in-a-shell-script-on-mac-os-x
; for completing the current solution.

  "absdir=`perl -e 'use Cwd \"abs_path\";print abs_path(shift)' $0`
THISSCRIPTDIR=\"$( cd \"$( dirname \"$absdir\" )\" && pwd -P )\"
")

(defun use-thisscriptdir-p (sysout-name core-name)
  (and (equal sysout-name core-name) ; perhaps not necessary
       (not (position (symbol-value '*directory-separator*)
                      core-name))))

#+gcl
(defvar *saved-system-banner*

; This variable is only used in GCL 2.6.9 and later, and the following comments
; pertain only to that case.

; Set this variable to nil before save-exec in order to save an image without a
; GCL startup banner, as this will leave si::*system-banner* unbound; see
; below.

; ACL2 keeps this value at nil except when acl2-default-restart unbinds
; si::*system-banner*, in which case *saved-system-banner* is set to the value
; of si::*system-banner* just before that unbinding takes place.  When
; save-exec saves an image, it first checks whether si::*system-banner* is
; unbound and *saved-system-banner* is non-nil, in which case it sets
; si::*system-banner* to *saved-system-banner*.  Even if si::*system-banner* is
; bound, *saved-system-banner* is set to nil before saving an image.

  nil)

#+gcl
(defvar *gcl-large-maxpages*

; This variable tells GCL to use Camm Maguire's strategy during development of
; GCL 2.6.13 of using large maxpage limits to postpone garbage collection, and
; thus avoid SGC.  It appears that si::*code-block-reserve* was introduced at
; the time this strategy was developed, and that si::set-log-maxpage-bound was
; already defined at that point (but we check, since we rely on that).

  (and (boundp 'si::*code-block-reserve*)
       (fboundp 'si::set-log-maxpage-bound)))

#+gcl
(defun save-acl2-in-gcl-aux (sysout-name gcl-exec-name
                                         write-worklispext
                                         set-optimize-maximum-pages
                                         host-lisp-args
                                         inert-args)
  (when *saved-system-banner*
    (when (not (boundp 'si::*system-banner*)) ; true, unless user intervened
      (setq si::*system-banner* *saved-system-banner*))
    (setq *saved-system-banner* nil))
  (if (and write-worklispext (probe-file "worklispext"))
      (delete-file "worklispext"))
  (let* ((ext "gcl")
         (ext+

; We deal with the apparent fact that Windows implementations of GCL append
; ".exe" to the filename created by save-system.

          #+mswindows "gcl.exe"
          #-mswindows "gcl")
         (gcl-exec-file
          (unix-full-pathname gcl-exec-name ext+))
         (use-thisscriptdir-p (use-thisscriptdir-p sysout-name gcl-exec-name)))
    (if write-worklispext
        (with-open-file (str "worklispext" :direction :output)
                        (format str ext+)))
    (if (probe-file sysout-name)
        (delete-file sysout-name))
    (if (probe-file gcl-exec-file)
        (delete-file gcl-exec-file))
    (with-open-file
      (str sysout-name :direction :output)
      (write-exec-file str
                       ("~a"
                        (if use-thisscriptdir-p *thisscriptdir-def* ""))
                       "~s~s ~a~%"
                       (if use-thisscriptdir-p
                           (concatenate 'string
                                        "$THISSCRIPTDIR/"
                                        gcl-exec-name
                                        "."
                                        ext+)
                         gcl-exec-file)
                       (insert-string host-lisp-args)
                       (user-args-string inert-args)))
    (cond ((and set-optimize-maximum-pages
                (boundp 'si::*optimize-maximum-pages*))

; We follow a suggestion of Camm Maguire by setting
; 'si::*optimize-maximum-pages* to t just before the save.

           (setq si::*optimize-maximum-pages* t)))
    (when *gcl-large-maxpages*
      (setq si::*code-block-reserve*

; Camm Maguire suggestion (he notes that a certification failed when using
; 50000000 here):

            (make-array 60000000 :element-type 'character :static t)))
    (chmod-executable sysout-name)
    (si::save-system (concatenate 'string sysout-name "." ext))))

#+gcl
(defun save-acl2-in-gcl (sysout-name gcl-exec-name
                                     &optional mode do-not-save-gcl)
  (declare (ignore mode))
  (setq *acl2-allocation-alist*

; If *acl2-allocation-alist* is rebound before allocation is done in
; si::*top-level-hook*, e.g., if it is bound in one's init.lisp or
; acl2-init.lsp file, then such binding will override this one.  The package
; name shouldn't matter for the keys in user's alist, but in the code below we
; need to keep 'hole in the ACL2 package because we refer to it below.

; Historical Comments:

; Where did these numbers come from?  At CLInc we have used the numbers from
; the non-small-p case for some time, and they seem satisfactory.  When we
; moved to a "small" image in Version 1.8, we wanted to have roughly the same
; number of free cells as we've had all along, as a default.  The cons number
; below is obtained by seeing how many pages we had free (pages in use
; multiplied by percent free, as shown by (room)) the last time we built ACL2,
; before modifying ACL2 to support small images, and adding that to the number
; of pages in use in the small image when no extra pages were allocated at
; start-up.  The total was 2917, so that is what we use below.  The relocatable
; size is rather arbitrary, and the hole size has been suggested by Bill
; Schelter.  Finally, the other numbers were unchanged when we used the same
; algorithm described above for cons (except for fixnum, which came out to 99
; -- close enough!).

; Warning:  as of this writing (5/95), there are versions of Linux in which the
; page size is half of that in GCL on a Sparc.  In that case, we should double
; the number of pages in each case in order to have the same amount of free
; objects available.  We do this below; see the next comment.  (We assume that
; there are still the same number of bytes per object; at least, in one
; instance in Linux that appears to be the case for cons, namely, 12 bytes per
; cons.)

; Additional comments during Version_2.9 development:

; When built with GCL 2.6.1-38 and *acl2-allocation-alist* = nil, we have:

;   ACL2>(room)
;
;     4972/4972   61.7%         CONS RATIO LONG-FLOAT COMPLEX STRUCTURE
;      133/274    14.0%         FIXNUM SHORT-FLOAT CHARACTER RANDOM-STATE READTABLE NIL
;      210/462    97.5%         SYMBOL STREAM
;        1/2      37.2%         PACKAGE
;       69/265     1.0%         ARRAY HASH-TABLE VECTOR BIT-VECTOR PATHNAME CCLOSURE FAT-STRING
;     1290/1884    7.4%         STRING
;      711/779     0.9%         CFUN BIGNUM
;       29/115    82.8%         SFUN GFUN CFDATA SPICE NIL
;
;     1302/1400                 contiguous (176 blocks)
;          13107                hole
;          5242    0.0%         relocatable
;
;         7415 pages for cells
;        27066 total pages
;        93462 pages available
;        10544 pages in heap but not gc'd + pages needed for gc marking
;       131072 maximum pages
;
;   ACL2>

; So as an experiment we used some really large numbers below (but not for hole or
; relocatable).  They seemed to work well, but see comment just below.

; End of Historical Comments... well, except here is one more.

; In GCL 2.6.5, and in fact starting (we believe) with GCL 2.6.2, GCL does not
; need preallocation to do the job well.  We got this opinion after discussions
; with Bob Boyer and Camm Maguire.  In a pre-release of Version_2.9, we found
; there was no noticeable change in regression time or image size when avoiding
; preallocation.  So it seems reasonable to stop messing with such numbers so
; that they do not become stale and interfere with GCL doing its job.

        nil)

; Now adjust if the page size differs from that for GCL running on a Sparc.
; See comment above.

  (let ((multiplier (/ 4096 si::lisp-pagesize)))
    (cond ((not (= multiplier 1))
           (setq *acl2-allocation-alist*
                 (loop for (type . n) in *acl2-allocation-alist*
                       collect
                       (cons type
                             (and n
                                  (round (* multiplier n)))))))))
  (setq si::*top-level-hook*
        #'(lambda ()
            (acl2-default-restart)
            (cond
             (*acl2-allocation-alist*
;              (format
;               t
;               "Beginning allocations.  Set acl2::*acl2-allocation-alist* to NIL~%~
;                in ~~/acl2-init.lsp if you must make your running image smaller.~%")
              (loop for (type . n) in *acl2-allocation-alist*
                    when n
                    do
;                    (format t "Allocating ~s to ~s.~%" type n)
                    (let ((x (symbol-name type)))
                      (cond
                       ((equal x "HOLE")
                        (si::set-hole-size n))
                       ((equal x "RELOCATABLE")
                        (si::allocate-relocatable-pages n))
                       (t (si::allocate type n t)))))))
            (lp)))
  (load "akcl-acl2-trace.lisp")

; Return to normal allocation growth.  Keep this in sync with load-acl2, which
; had presumably already set the allocation growth to be particularly slow.

  (loop
   for type in
   '(cons fixnum symbol array string cfun sfun
          #+gcl relocatable)
   do
   (si::allocate-growth type 0 0 0 0))

;  (print "Start (si::gbc nil)") ;debugging GC

; Camm Maguire suggests leaving the hole size alone for GCL 2.6.10pre as of
; 9/22/2013:
;  (si::set-hole-size 500) ; wfs suggestion

; Camm Maguire says (7/04) that "the gc algorithm skips over any pages which
; have not been written to since sgc-on was invoked.  So gc really needs to be
; done before turning [sgc] on (not off)...."

  (si::gbc t) ; wfs suggestion [at least if we turn on SGC] -- formerly nil
              ; (don't know why...)

; We formerly turned on SGC.  However, when we reported to Camm Maguire
; certification failure for community book
; books/centaur/fty/tests/deftagsum-scale.lisp in February 2017, he suggested
; that we turn off SGC, since it may not have benefits now that there are huge
; rams where swapping is to be avoided.

; (cond ((and (not *gcl-large-maxpages*)
;             (fboundp 'si::sgc-on))
;        (print "Executing (si::sgc-on t)") ;debugging GC
;        (funcall 'si::sgc-on t)))

; Set the hole to be sufficiently large so that ACL2 can do all the allocations
; quickly when it starts up, without any GC, leaving the desired size hole when
; finished.

  (let ((new-hole-size
         (or (cdr (assoc 'hole *acl2-allocation-alist*))
             (si::get-hole-size))))
    (loop for (type . n) in *acl2-allocation-alist*
          with space
          when (and n
                    (not (equal (symbol-name type) "HOLE"))
                    (< (setq space
                             #+gcl
                             (nth 1 (multiple-value-list
                                     (si::allocated type)))
                             #-gcl
                             (cond
                              ((equal (symbol-name type)
                                      "RELOCATABLE")
                               (si::allocated-relocatable-pages))
                              (t (si::allocated-pages type))))
                       n))
          do (setq new-hole-size (+ new-hole-size (- n space))))
;    (print "Set hole size") ;debugging
; Camm Maguire suggests leaving the hole size alone for GCL 2.6.10pre as of
; 9/22/2013:
;    (si::set-hole-size new-hole-size)
    )

; The calculation above is legacy.  Now we increment the hole size to 20% of
; max-pages instead of the default 10%.  Camm Maguire says that "Larger values
; allow quick allocation of pages without triggering gc" and that the hole is
; part of the virtual (not resident) memory size, rather than being saved to
; disk.

; Camm Maguire suggests leaving the hole size alone for GCL 2.6.10pre as of
; 9/22/2013:
;  (let ((new-size (floor si:*lisp-maxpages* 5)))
;    (if (< (si:get-hole-size) new-size)
;        (si::set-hole-size new-size)))

;  (print (true-listp (w *the-live-state*))) ;swap in the world's pages

;  (print "Save the system") ;debugging
  (when (not do-not-save-gcl)
    (save-acl2-in-gcl-aux sysout-name gcl-exec-name t t nil nil)))

#+gcl
(defun save-exec-raw (sysout-name host-lisp-args inert-args)
  (setq *acl2-allocation-alist* nil) ; Don't meddle with allocations.
  (setq *acl2-default-restart-complete* nil)
  (save-acl2-in-gcl-aux sysout-name sysout-name nil nil host-lisp-args
                        inert-args))

(defvar *acl2-default-restart-complete* nil)

(defun fix-default-pathname-defaults ()

; Some Lisps save *default-pathname-defaults* and do not reset it at startup.
; According to our experiments:

; - CCL, CMUCL, LispWorks, and GCL retain *default-pathname-defaults*.

; - SBCL and Allegro CL apparently do not retain *default-pathname-defaults*,
;   but instead setting it at startup according to the current working
;   directory.

; - CLISP sets *default-pathname-defaults* to #P"" at startup.

; But since *default-pathname-defaults* can affect truename, we want it to
; reflect the current working directory.

  #+(or ccl cmu gcl lispworks)
  (when (pathname-directory *default-pathname-defaults*)
    (let ((p (make-pathname)))

; Before November 2022 we printed the following message.  But now it seems
; inappropriate at the user level; in particular, since ACL2 arranges for
; *default-pathname-defaults* to track the cbd, users shouldn't need to know
; anything about *default-pathname-defaults*.

;     (format t "~%Note: Resetting *default-pathname-defaults* to ~s.~%"
;             p)

      (setq *default-pathname-defaults* p)))
  nil)

(defvar *print-startup-banner*

; One might want to set this variable to nil in raw Lisp before calling
; save-exec, in order to avoid seeing startup information.  We do not comment
; here on whether that is legally appropriate; for example, it suppresses
; copyright information for ACL2 and, for CCL at least, information about the
; host Lisp.  We also do not guarantee that this behavior (suppressing printing
; of startup information) is supported for every host Lisp.

; Note that LD always prints some startup information, regardless of the value
; of *print-startup-banner*.  But that information is suppressed with
; (set-ld-verbose nil state).

; The following form can be put into one's ~/ccl-init.lisp file for CCL or
; ~/init.lsp file for GCL, and similarly perhaps for some other Lisps, in order
; to suppress printing at startup.

;   (when (find-package "ACL2")
;     ;; Suppress as much as possible at startup except for the LD info.
;     (set (intern "*PRINT-STARTUP-BANNER*" "ACL2")
;          nil)
;     ;; Suppress the LD info.
;     (eval (list (intern "SET-LD-VERBOSE" "ACL2")
;                 nil
;                 (intern "*THE-LIVE-STATE*" "ACL2"))))

  t)

(defvar *lp-ever-entered-p* nil)

(defun acl2-version+ ()
  (format nil "~a~a"
          *copy-of-acl2-version*
          (cond
           (*acl2-release-p* "")
           (t (format nil "+ (a development snapshot based on ~a)"
                      *copy-of-acl2-version*)))))

(defun acl2-default-restart (&optional called-by-lp)
  (if *acl2-default-restart-complete*
      (return-from acl2-default-restart nil))
  #+cmu
  (when *print-startup-banner*
    (extensions::print-herald t))
  (let ((produced-by-save-exec-p *lp-ever-entered-p*))
    (proclaim-optimize) ; see comment in proclaim-optimize
    (setq *lp-ever-entered-p* nil)
    (#+cltl2
     common-lisp-user::acl2-set-character-encoding
     #-cltl2
     user::acl2-set-character-encoding)

    (fix-default-pathname-defaults)

    #+ccl
    (progn

; In CCL, print greeting now, rather than upon first re-entry to ACL2 loop.
; Here we follow a suggestion from Gary Byers.

      (when *print-startup-banner*
        (format t "~&Welcome to ~A ~A!~%"
                (lisp-implementation-type)
                (lisp-implementation-version)))
      (setq ccl::*inhibit-greeting* t))

    (when (not produced-by-save-exec-p)
      (qfuncall acl2h-init))

    #+gcl
    (progn

; Some recent versions of GCL (specifically, 2.6.9 in Sept. 2013) do not print
; the startup banner until we first exit the loop.  So we handle that situation
; much as we handle a similar issue for CCL above, following GCL source file
; lsp/gcl_top.lsp.

      (when (and *print-startup-banner*
                 (boundp 'si::*system-banner*))
        (format t si::*system-banner*)
        (setq *saved-system-banner* si::*system-banner*)
        (makunbound 'si::*system-banner*)
        (when (boundp 'si::*tmp-dir*)
          (format t "Temporary directory for compiler files set to ~a~%"
                  si::*tmp-dir*)))
; Growing the sbits structure just before si::save-system hasn't seemed to
; avoid triggering a call of hl-hspace-grow-sbits when the first static hons is
; created.  So we do the grow here, i.e., after starting ACL2.
      #+static-hons
      (hl-hspace-grow-sbits (hl-staticp (cons nil nil)) *default-hs*))

    (when *print-startup-banner*
      (format t
              *saved-string*
              (acl2-version+)
              (saved-build-dates :terminal)))
    (maybe-load-acl2-init)
    (eval `(in-package ,*startup-package-name*))

; The following two lines follow the recommendation in Allegro CL's
; documentation file doc/delivery.htm.

    #+allegro (tpl:setq-default *package* (find-package *startup-package-name*))
    #+allegro (rplacd (assoc 'tpl::*saved-package*
                             tpl:*default-lisp-listener-bindings*)
                      'common-lisp:*package*)
    (setq *acl2-default-restart-complete* t)
    (when (not called-by-lp)

; GCL handles (lp) using si::*top-level-hook*.
; CLISP handles (lp) via write-acl2rc.

      #+allegro (lp)
      #+lispworks (lp)
      #+ccl (eval '(lp)) ; using eval to avoid compiler warning
      )
    nil))

#+cmu
(defun cmulisp-restart ()
  (acl2-default-restart)
  (lp))

#+sbcl
(defun sbcl-restart ()
  (acl2-default-restart)
; Use eval to avoid style-warning for undefined function LP.
  (eval '(lp)))

#+lucid
(defun save-acl2-in-lucid (sysout-name &optional mode)
  (declare (ignore mode))
  (user::disksave sysout-name :restart-function 'acl2-default-restart
                  :full-gc t))

#+lispworks
(defun lispworks-save-exec-aux (sysout-name eventual-sysout-name
                                            host-lisp-args inert-args)

; LispWorks support (Dave Fox) pointed out, in the days of LispWorks 4, that we
; need to be sure to call (mp:initialize-multiprocessing) when starting up.  Up
; through ACL2 Version_4.2 we did that by making that call in
; acl2-default-restart.  But when testing with LispWorks 6.0, we noticed that
; some processes hang, and we wondered if that has to do with the fact that
; (mp:initialize-multiprocessing) does not return.  That also got in the way of
; our running (LP) in acl2-default-restart.  We experimented with removing
; (mp:initialize-multiprocessing) from acl2-default-restart, instead passing
; :multiprocessing t to system::save-image.  But with that change, we noticed
; that upon exiting the ACL2 loop with :q, we got the following rather scary
; message.

; ;; No live processes except internal servers - stopping multiprocessing

; So we have decided not to call :multiprocessing t, and also not to call
; (mp:initialize-multiprocessing) in the #-acl2-par case.

  #+acl2-par
  (when mp::*multiprocessing*
    (send-die-to-worker-threads)
    (mp::stop-multiprocessing)
    (gc$))
  #+acl2-par
  (when *lp-ever-entered-p* ; don't print during compilation
    (format t
            "If you wish to continue using this image, you will need to call ~%~
             'mp:initialize-multiprocessing' instead of calling 'lp'.  This ~%~
             is necessary because of the way multiprocessing works in ~%~
             Lispworks.~%~%"))

; We just make a guess that Lispworks can be handled the way that GCL is
; handled.

  (if (probe-file "worklispext")
      (delete-file "worklispext"))
  (let* ((ext "lw")
         (ext+

; We deal with the apparent fact that Windows implementations of GCL append
; ".exe" to the filename created by save-system -- and assume, until someone
; tells us otherwise, that Lispworks does similarly.

          #+mswindows "lw.exe"
          #-mswindows "lw")
         (use-thisscriptdir-p (use-thisscriptdir-p sysout-name eventual-sysout-name))
         (lw-exec-file
          (unix-full-pathname sysout-name ext+))
         (eventual-lw-exec-file
          (unix-full-pathname eventual-sysout-name ext+)))
    (with-open-file (str "worklispext" :direction :output)
                    (format str ext+))
    (if (probe-file sysout-name)
        (delete-file sysout-name))
    (if (probe-file lw-exec-file)
        (delete-file lw-exec-file))
    (when use-thisscriptdir-p
      (setq eventual-lw-exec-file
            (concatenate 'string "$THISSCRIPTDIR/" eventual-sysout-name "." ext+)))
    (with-open-file (str sysout-name :direction :output)
      (write-exec-file
       str
       ("~a"
        (if use-thisscriptdir-p *thisscriptdir-def* ""))

; We pass options "-init -" and "-siteinit -" to inhibit loading init and patch
; files because we assume that whatever such files were to be loaded, were in
; fact loaded at the time the original Lispworks executable was saved.  Of
; course, individual users who doesn't like this decision and know better could
; always edit this script file, i.e., lw-exec-file, in the same spirit as
; changing the underlying Lisp implementation before building ACL2 (again,
; presumably based on knowledge of the host Lisp implementation).

       "~s -init - -siteinit -~a ~a~%"
       eventual-lw-exec-file
       (insert-string host-lisp-args)
       (user-args-string inert-args)))
    (chmod-executable sysout-name)
    (cond ((and system::*init-file-loaded*
                system::*complain-about-init-file-loaded*)

; We hope it's fine to save an image when an init-file has been loaded.  Maybe
; somebody can explain to us why LispWorks causes a break in such a situation
; by default (which explains the binding of
; system::*complain-about-init-file-loaded* below).

           (format t
                   "Warning: Overriding LispWorks hesitation to save an image~%~
                    after init-file has been loaded.~%")
           (let ((system::*complain-about-init-file-loaded* nil))
             (system::save-image lw-exec-file
                                 :restart-function 'acl2-default-restart
                                 #+acl2-par :multiprocessing
                                 #+acl2-par t
                                 :gc t)))
          (t (system::save-image lw-exec-file
                                 :restart-function 'acl2-default-restart
                                 #+acl2-par :multiprocessing
                                 #+acl2-par t
                                 :gc t)))))

#+lispworks
(defun save-acl2-in-lispworks (sysout-name mode eventual-sysout-name)
  (declare (ignore mode))
  (if (probe-file "worklispext")
      (delete-file "worklispext"))
  (with-open-file (str "worklispext" :direction :output)
                  (format str "lw"))
  (lispworks-save-exec-aux sysout-name eventual-sysout-name
                           nil nil))

#+lispworks
(defun save-exec-raw (sysout-name host-lisp-args inert-args)

; See the comment above about :multiprocessing t.

  (setq *acl2-default-restart-complete* nil)
  (lispworks-save-exec-aux sysout-name sysout-name
                           host-lisp-args inert-args))

#+cmu
(defun save-acl2-in-cmulisp-aux (sysout-name core-name
                                             host-lisp-args inert-args)

; Warning: This function was modified 8/2018 in support of the change described
; in :doc note-8-1: "The save-exec utility now utilizes a relative pathname in
; the saved_acl2 script, which can allow it and a corresponding image file to
; be moved, even across filesystems...."  Once save-exec is again tested
; successfully and adequately in CMUCL, this warning should be removed.

  (let* ((use-thisscriptdir-p (use-thisscriptdir-p sysout-name core-name))
         (eventual-sysout-core
          (unix-full-pathname core-name "core"))
         (sysout-core
          (unix-full-pathname sysout-name "core")))
    (if (probe-file sysout-name)
        (delete-file sysout-name))
    (if (probe-file eventual-sysout-core)
        (delete-file eventual-sysout-core))
    (when use-thisscriptdir-p
      (setq eventual-sysout-core
            (concatenate 'string "$THISSCRIPTDIR/" core-name ".core")))
    (with-open-file ; write to nsaved_acl2
     (str sysout-name :direction :output)
     (let* ((prog1 (car extensions::*command-line-strings*))
            (len (length prog1))
            (prog2 (cond ((< len 4)

; If cmucl is installed by extracting to /usr/local/ then the cmucl command is
; simply "lisp" (thanks to Bill Pase for pointing this out).

                          "lisp")

; The next two cases apply in 18e (and probably earlier) but not 19a (and
; probably later), which has the correct path (doesn't need "lisp" appended).

                         ((equal (subseq prog1 (- len 4) len) "bin/")
                          (our-truename (concatenate 'string prog1 "lisp") t))
                         ((equal (subseq prog1 (- len 3) len) "bin")
                          (our-truename (concatenate 'string prog1 "/lisp") t))
                         (t (our-truename prog1 t)))))
       (write-exec-file str
                        ("~a"
                         (if use-thisscriptdir-p *thisscriptdir-def* ""))
                        "~s -core ~s -dynamic-space-size ~s -eval ~
                         '(acl2::cmulisp-restart)'~a ~a~%"
                        prog2
                        eventual-sysout-core

; In our testing for ACL2 Version_6.2 we found that certification failed for
; ACL2(h) built on CMUCL for the book tau/bounders/elementary-bounders.lisp,
; with the error: "CMUCL has run out of dynamic heap space (512 MB)."  This
; failure doesn't seem to be fully reproducible, but it seems safest to
; increase the stack size.  Our CMUCL image, even though on 64-bit linux,
; reported the following when we tried a value of 2000 here:

; -dynamic-space-size must be no greater than 1632 MBytes.

; Indeed, we have exceeded that in a version of community book
; books/centaur/gl/solutions.lisp using ACL2(h) built on CMUCL.  So we use the
; maximum possible value just below, which for darwin (at least on Matt's
; Macbook pro) is only 1150.

; Starting with CMUCL snapshot-2016-01, -dynamic-space-size can be 0, meaning
; that the maximum heap allocation will be used (thanks to Raymond Toy for this
; option).

                        (if (string>=
                             (subseq (lisp-implementation-version) 0 16)
                             "snapshot-2016-01")
                            0
                          #+darwin 1150 #-darwin 1632)
                        (insert-string host-lisp-args)
                        (user-args-string inert-args))))
    (chmod-executable sysout-name)
    (system::gc)
    (extensions::save-lisp sysout-core :load-init-file nil :site-init nil

; We call print-herald in cmulisp-restart, so that the herald is printed
; before the ACL2-specific information (and before the call of lp).

                           :print-herald nil)))

#+cmu
(defun save-acl2-in-cmulisp (sysout-name &optional mode core-name)
  (declare (ignore mode))
  (if (probe-file "worklispext")
      (delete-file "worklispext"))
  (with-open-file (str "worklispext" :direction :output)
                  (format str "core"))
  (save-acl2-in-cmulisp-aux sysout-name core-name nil nil))

#+cmu
(defun save-exec-raw (sysout-name host-lisp-args inert-args)
  (setq *acl2-default-restart-complete* nil)
  (save-acl2-in-cmulisp-aux sysout-name sysout-name host-lisp-args inert-args))

#+sbcl
(defvar *sbcl-dynamic-space-size*

; The user is welcome to set this value, which according to
; http://www.sbcl.org/manual/, is the "Size of the dynamic space reserved on
; startup in megabytes."  It can be done either by setting this variable before
; saving an ACL2 image, or by editing the resulting script (e.g., saved_acl2).
; Here we explain the defaults that we provide for this variable.

; We observed during development of Version_5.0 that --dynamic-space-size 2000
; is necessary in order to complete an ACL2(h) regression with SBCL 1.0.55 on a
; Mac OS 10.6 laptop; otherwise Lisp dies during a GC when certifying community
; book books/centaur/tutorial/intro.lisp, even with (clear-memoize-tables)
; executed at the start of acl2-compile-file and with (gc$ :full t) executed
; there as well, and also at the start of write-expansion-file and immediately
; before and after include-book-fn in certify-book-fn.  We believe that it has
; often been necessary to use such a --dynamic-space-size setting to build ACL2
; with SBCL on some platforms, so we decided to use this option for ACL2.

; But in December 2012 we found that 2000 is not sufficient using SBCL 1.0.49
; on our 64-bit linux system.  Our first such failure was in certifying
; community book
; books/models/y86/y86-two-level-abs/common/x86-state-concrete.lisp in ACL2(h).
; We tried increasing the --dynamic-space-size to 4000, but that was not
; sufficient for community book
; books/models/y86/y86-basic/common/x86-state.lisp; in fact, 8000 also was not
; sufficient for that book.  Fortunately, 16000 was sufficient.

; These are unusual books, in that they allocate an array of size 2^32.
; Indeed, the x86 books do not all certify in 32-bit SBCL; we found an error in
; a certification attempt for community book
; books/models/y86/y86-two-level-abs/common/x86-state-concrete.lisp,
; complaining that the array dimension of 1677721600 is too large.  Therefore
; we only increase the value to 16000 in 64-bit SBCL.  If --dynamic-space-size
; 16000 causes a problem for some users, a simple solution will be for them to
; edit saved_acl2 or for them to build ACL2 after defining this variable to be
; smaller than 16000 (at the risk of certification failure for some x86 and y86
; books).

; On 32-bit systems, 16000 may be too large.  We tried it on a 32-bit Linux
; system and got an error upon starting ACL2: "--dynamic-space-size argument is
; out of range: 16000".  We have thus reverted to our earlier value of 2000 for
; such systems.  Harsh Raju Chamarthi reported that this value was still too
; large for his Linux system, so at his suggestion, we tried lowering the
; 32-bit value to 1024.  However community book
; books/centaur/fty/tests/deftranssum.lisp then failed to certify, reporting:
; "Heap exhausted during allocation: 43372544 bytes available, 67108872
; requested."

; On October 18, 2016, we found that even 16,000 is insufficient for building
; the manual.  So we are increasing this value by 50%, to 24,000.

; On August 16, 2017 we found that 24,000 was insufficient to build
; books/projects/x86isa/proofs/zeroCopy/marking-mode/zeroCopy.cert, so we
; increased to 32,000.  (Note: this was based on the x86isa books as of a few
; days earlier.  Even if the increase to 32,000 was not necessary, it seems a
; good idea to accommodate even the previous version.)

  #+(or x86-64 64-bit) 32000
  #-(or x86-64 64-bit) 2000)

#+sbcl
(defvar *sbcl-home-dir*
  (let* ((sbcl-home-env (getenv$-raw "SBCL_HOME"))
         (sbcl-home-env (and sbcl-home-env

; Besides checking that the filesystem location pointed to by SBCL_HOME exists,
; this also canonicalizes the pathname, for example by (we believe) adding a
; terminating "/" if one did not exist.

                             (probe-file sbcl-home-env)))
         (core-dir (and (boundp 'sb-ext::*core-pathname*)
                        (pathname-directory sb-ext::*core-pathname*)))
         (in-place  (and core-dir (equal (car (last core-dir)) "output")))
         (installed (and core-dir (not in-place)))
         (sbcl-home-installed
          (and installed
               (make-pathname :directory core-dir)))

; Note 2017-11-23: The comment below only applies to the case when SBCL is
; running in-place from an SBCL source tree, and not the case when SBCL is
; running from an install target directory.

; In order to profile, Nikodemus Siivola has told us that we "need to set
; SBCL_HOME to the location of the contribs".  We used contrib/ through SBCL
; 1.1.11.  But we noticed in SBCL 1.1.14 that the suitable contrib/ directory
; (at least for requiring sb-sprof) is obj/sbcl-home/contrib/, an impression
; that seemed to be confirmed via email from fahree@gmail.com on 1/13/2014.
; Since directory obj/sbcl-home/ doesn't exist in (our installation of) SBCL
; 1.1.11, we simply look for that first.  But we noticed that it doesn't work
; to include the trailing "contrib/" when using obj/sbcl-home/.

         (sbcl-home-in-place-old
          (and in-place
               (make-pathname :directory (append (butlast core-dir 1)
                                                 '("contrib")))))
         (sbcl-home-in-place-new
          (and in-place
               (make-pathname :directory (append (butlast core-dir 1)
                                                 '("obj" "sbcl-home")))))
         (sbcl-home-detected
          (or
           (and sbcl-home-installed    (probe-file sbcl-home-installed))
           (and sbcl-home-in-place-new (probe-file sbcl-home-in-place-new))
           (and sbcl-home-in-place-old (probe-file sbcl-home-in-place-old)))))
    (cond
     ((and sbcl-home-env

; In some older versions of SBCL, such as 1.1.11, if SBCL_HOME is not passed to
; SBCL upon startup, the SBCL process itself sets SBCL_HOME to the location of
; sbcl.core.  But if SBCL is being run in-place from an SBCL source tree
; instead of being installed in an install target directory, this SBCL_HOME
; value is incorrect and should be ignored.

           (not (and in-place core-dir
                     (equal sbcl-home-env
                            (probe-file (make-pathname :directory core-dir))))))
      (when (and sbcl-home-detected
                 (not (equal sbcl-home-env sbcl-home-detected)))
        (warn "SBCL_HOME is currently set to \"~a\", but our heuristics ~
               indicate that it should be set to \"~a\".  The ACL2 image we ~
               save may not work correctly.~%"
              sbcl-home-env sbcl-home-detected))
      (namestring sbcl-home-env))
     (sbcl-home-detected
      (namestring sbcl-home-detected))
     (t (exit-with-build-error
         "Could not determine a suitable value for the environment variable ~
          SBCL_HOME.~%If it is set, please try unsetting it or correcting ~
          it.~%If it is not set, please try setting it to an appropriate ~
          value.")))))

#+sbcl
(defun save-acl2-in-sbcl-aux (sysout-name core-name
                                          host-lisp-args
                                          toplevel-args
                                          inert-args)

; Note that host-lisp-args specifies what the SBCL manual calls "runtime
; options", while toplevel-args is what it calls "toplevel options".

  (declare (optimize (sb-ext:inhibit-warnings 3)))
  (let* ((use-thisscriptdir-p (use-thisscriptdir-p sysout-name core-name))
         (eventual-sysout-core
          (unix-full-pathname core-name "core"))
         (sysout-core
          (unix-full-pathname sysout-name "core")))
    (if (probe-file sysout-name)
        (delete-file sysout-name))
    (if (probe-file eventual-sysout-core)
        (delete-file eventual-sysout-core))
    (when use-thisscriptdir-p
      (setq eventual-sysout-core
            (concatenate 'string "$THISSCRIPTDIR/" core-name ".core")))
    (with-open-file ; write to nsaved_acl2
      (str sysout-name :direction :output)
      (let ((prog

; This is the program that will be invoked when starting ACL2.  We prefer an
; absolute pathname, rather than just "sbcl" or a relative pathname, so that
; ACL2 is invoked successfully even by those for whom "sbcl" points elsewhere
; (because of a different PATH).  At one point, between Versions 8.3 and 8.4,
; we applied our-truename to (car sb-ext:*posix-argv*).  But Andrew Walter
; reported a problem on 4/30/2021 (GitHub Issue #1254) that was due to nil
; being returned by that our-truename call, because (car sb-ext:*posix-argv*)
; is "sbcl" in his environment.  He suggested using undocumented SBCL global
; sb-ext:*runtime-pathname*, and we took that suggestion.

             (or (our-truename sb-ext:*runtime-pathname* t)

; If somehow the value above is nil, then we go with the called program.  We
; avoid calling our-truename in that case, since if "make LISP=sbcl" invokes a
; different sbcl than ./sbcl because "." is not at the front of the PATH at
; build time, then (our-truename "sbcl" t) would return the wrong path.

                 (car sb-ext:*posix-argv*))))
        (write-exec-file
         str
         ("~a~a~%"
          (if use-thisscriptdir-p *thisscriptdir-def* "")
          (format nil
                  "export SBCL_HOME='~a'"
                  *sbcl-home-dir*))

; We have observed with SBCL 1.0.49 that "make HTML" fails on our 64-bit linux
; system unless we start sbcl with --control-stack-size 4 [or larger].  The
; default, according to http://www.sbcl.org/manual/, is 2.  The problem seems
; to be stack overflow from fmt0, which is not tail recursive.  More recently,
; community book centaur/misc/defapply.lisp causes a stack overflow even with
; --control-stack-size 4 (though that might disappear after we added (comp t)
; in a couple of places).  Yet more recently, community books
; books/centaur/regression/common.lisp and books/centaur/tutorial/intro.lisp
; fail with --control-stack-size 8, due to calls of def-gl-clause-processor.
; So we use --control-stack-size 16.  We increased 16 to 64 on 10/22/2015 at
; the request of Jared Davis, in support of a Verilog parser.

; See *sbcl-dynamic-space-size* for an explanation of the --dynamic-space-size
; setting below.

; Note that --no-userinit was introduced into SBCL in Version 0.9.13, hence has
; been part of SBCL since 2007 (perhaps earlier).  So when Jared Davis pointed
; out this option to us after ACL2 Version_6.2, we started using it in place of
; " --userinit /dev/null", which had not worked on Windows.

; In July 2017 we added ${SBCL_USER_ARGS} below to accommodate Sol Swords's
; request to be able to pass runtime-options without having to call save-exec.
; Example:
; (export SBCL_USER_ARGS="--lose-on-corruption" ; ./sbcl-saved_acl2)

; On October 9, 2020 we added --tls-limit 8192, because certification of
; community book books/kestrel/apt/schemalg-template-proofs.lisp failed with
; ACL2 built on SBCL.  The error was "Thread local storage exhausted", which
; apparently indicates too many special variables.  The SBCL 1.5.2 release
; notes say that "command-line option "--tls-limit" can be used to alter the
; maximum number of thread-local symbols from its default of 4096".  We chose
; 8192 because it was sufficient for the book above, but perhaps it can be
; increased significantly more without bad effect (not sure).  But then in
; March 2021, on a Mac, that same book again failed with the same error; so we
; doubled the tls-limit.

         "~s --tls-limit 16384 --dynamic-space-size ~s --control-stack-size ~
          64 --disable-ldb --core ~s~a ${SBCL_USER_ARGS} ~
          --end-runtime-options --no-userinit --eval '(acl2::sbcl-restart)'~a ~a~%"
         prog
         *sbcl-dynamic-space-size*
         eventual-sysout-core
         (insert-string host-lisp-args)
         (insert-string toplevel-args)
         (user-args-string inert-args "--end-toplevel-options"))))
    (chmod-executable sysout-name)
    (sb-ext:gc)
    (sb-ext:save-lisp-and-die sysout-core

; Quoting the SBCL manual on the :purify parameter: "This parameter has no
; effect on platforms using the generational garbage collector."  The manual
; also says "Garbage collection is done with the existing Conservative
; Generational GC."  Our guess is that the presence of that garbage collector
; is indicated by feature :GENCGC; see sbcl source file src/runtime/gencgc.c.
; So most likely this use of :purify has no effect.  But maybe there are
; platforms where it is helpful, so we go ahead with it.

                              :purify t)))

#+sbcl
(defun save-acl2-in-sbcl (sysout-name &optional mode core-name)
  (declare (ignore mode))
  (with-warnings-suppressed
   (if (probe-file "worklispext")
       (delete-file "worklispext"))
   (with-open-file (str "worklispext" :direction :output)
                   (format str "core"))
   (save-acl2-in-sbcl-aux sysout-name core-name nil nil nil)))

#+sbcl
(defun save-exec-raw (sysout-name host-lisp-args toplevel-args inert-args)
  (with-warnings-suppressed
   (setq *acl2-default-restart-complete* nil)
   (save-acl2-in-sbcl-aux sysout-name sysout-name host-lisp-args toplevel-args
                          inert-args)))

#+allegro
(defun save-acl2-in-allegro-aux (sysout-name dxl-name
                                             host-lisp-args inert-args)
  (excl:gc t) ; Suggestions are welcome for better gc call(s)!
  #+(and allegro-version>= (version>= 4 3))
  (progn
    (tpl:setq-default *PACKAGE* (find-package "ACL2"))
    (setq EXCL:*RESTART-INIT-FUNCTION* 'acl2-default-restart)
    #+(and allegro-version>= (version>= 5 0))
    (progn

; Allegro 5.0 and later no longer supports standalone images.  Instead, one
; creates a .dxl file using dumplisp and then starts up ACL2 using the original
; Lisp executable, but with the .dxl file specified using option -I.  Our
; saved_acl2 executable is then a one-line script that makes this Lisp
; invocation.  Note that :checkpoint is no longer supported starting in 5.0.

      (let* ((use-thisscriptdir-p
              (use-thisscriptdir-p sysout-name dxl-name))
             (eventual-sysout-dxl
              (if dxl-name
                  (unix-full-pathname dxl-name "dxl")
                (exit-with-build-error
                 "An image file must be specified when building ACL2 in ~
                  Allegro 5.0 or later.")))
             (sysout-dxl
              (unix-full-pathname sysout-name "dxl")))
    (if (probe-file eventual-sysout-dxl)
        (delete-file eventual-sysout-dxl))
    (if (probe-file sysout-dxl)
        (delete-file sysout-dxl))
    (when use-thisscriptdir-p
      (setq eventual-sysout-dxl
            (concatenate 'string "$THISSCRIPTDIR/" dxl-name ".dxl")))
    (write-acl2rc
         (our-truename ; our-pwd, without converting to ACL2/Unix pathname
          ""
          "NOTE: Calling OUR-TRUENAME from save-acl2-in-allegro-aux"))
        (with-open-file ; write to nsaved_acl2
         (str sysout-name :direction :output)
         (write-exec-file
          str
          ("~a"
           (if use-thisscriptdir-p *thisscriptdir-def* ""))

; We use ~s instead of ~a below because John Cowles has told us that in Windows
; 98, the string quotes seem necessary for the first string and desirable for
; the second.  The string quotes do not hurt on Unix platforms.

; We omit the trailing " -L ~s" for now from the following string, which would
; go with format arg (rc-filename save-dir), because we know of no way in
; Allegro 6.2 to avoid getting Allegro copyright information printed upon :q if
; we start up in the ACL2 read-eval-print loop.

;         "~s -I ~s -L ~s ~s~%"

          "~s -I ~s~s ~a~%"
          (our-truename (system::command-line-argument 0) t)
          eventual-sysout-dxl
          (insert-string host-lisp-args)
          (user-args-string inert-args)))
        (chmod-executable sysout-name)
        (excl:dumplisp :name sysout-dxl)))
    #-(and allegro-version>= (version>= 5 0))
    (excl:dumplisp :name sysout-name :checkpoint nil))
  #-(and allegro-version>= (version>= 4 3))
  (progn
    (excl:dumplisp :name sysout-name :checkpoint t
                   :restart-function 'acl2-default-restart)))

#+allegro
(defun save-acl2-in-allegro (sysout-name &optional mode dxl-name)

; Note that dxl-name should, if supplied, be a relative pathname string, not
; absolute.

  (declare (ignore mode))
  (if (probe-file "worklispext")
      (delete-file "worklispext"))
  (with-open-file (str "worklispext" :direction :output)
                  (format str "dxl"))
  (load "allegro-acl2-trace.lisp") ; Robert Krug's trace patch
  (save-acl2-in-allegro-aux sysout-name dxl-name nil nil))

#+allegro
(defun save-exec-raw (sysout-name host-lisp-args inert-args)
  (setq *acl2-default-restart-complete* nil)
  (save-acl2-in-allegro-aux sysout-name sysout-name host-lisp-args inert-args))

(defun rc-filename (dir)
  (concatenate 'string dir ".acl2rc"))

(defun write-acl2rc (dir)
  (let ((rc-filename
         (concatenate 'string dir ".acl2rc")))
    (if (not (probe-file rc-filename))
        (with-open-file ; write to .acl2rc
         (str (rc-filename dir) :direction :output)

; We call acl2-default-restart before lp so that the banner will be printed
; and (optionally) ~/acl2-init.lsp file will be loaded before entering the ACL2
; read-eval-print loop.

         (format str
                 "; enter ACL2 read-eval-print loop~%~
                  (ACL2::ACL2-DEFAULT-RESTART)~%~
                  #+ALLEGRO (EXCL::PRINT-STARTUP-INFO T)~%~
                  #+ALLEGRO (SETQ EXCL::*PRINT-STARTUP-MESSAGE* NIL)~%~
                  (ACL2::LP)~%")))))

#+clisp
(defun save-acl2-in-clisp-aux (sysout-name mem-name host-lisp-args inert-args)
  (let ((save-dir
         (our-truename ; our-pwd, without converting to ACL2/Unix pathname
          ""
          "NOTE: Calling OUR-TRUENAME from save-acl2-in-clisp-aux"))
        (eventual-sysout-mem
         (unix-full-pathname mem-name "mem"))
        (sysout-mem
         (unix-full-pathname sysout-name "mem")))
    (if (probe-file sysout-name)
        (delete-file sysout-name))
    (if (probe-file eventual-sysout-mem)
        (delete-file eventual-sysout-mem))
    (write-acl2rc save-dir)
    (with-open-file ; write to nsaved_acl2
     (str sysout-name :direction :output)
     (write-exec-file str
                      nil
                      "~s -i ~s -p ACL2 -M ~s -m ~dMB -E ISO-8859-1~a ~a~%"
                      (or (ext:getenv "LISP") "clisp")
                      (rc-filename save-dir)
                      eventual-sysout-mem

; Here we choose a value of 10 for the -m argument.  We have found that without
; setting -m, we get a stack overflow in community book
; books/unicode/read-utf8.lisp at (verify-guards read-utf8-fast ...) when
; running on CLISP 2.34 on Linux.  CLISP documentation at
; http://clisp.cons.org/clisp.html#opt-memsize says that it is "common to
; specify 10 MB" for the value of -m; since that suffices to eliminate the
; stack overflow mentioned above, we use that value.  Note that we use ~dMB
; instead of ~sMB because the (our-)with-standard-io-syntax wrapper in
; write-exec-file seems to put a decimal point after the number when using ~s,
; and CLISP complains about that when starting up.

                      10
                      (insert-string host-lisp-args)
                      (user-args-string inert-args)))
    (chmod-executable sysout-name)
    (ext:gc)
    (ext:saveinitmem sysout-mem
                     :quiet nil

; We call acl2-default-restart here, even though above we take pains to call it
; in the .acl2rc file, because someone could edit that file but we still want
; the banner printed.

                     :init-function 'acl2-default-restart)))

#+clisp
(defun save-acl2-in-clisp (sysout-name &optional mode mem-name)
  (declare (ignore mode))
  (if (probe-file "worklispext")
      (delete-file "worklispext"))
  (with-open-file (str "worklispext" :direction :output)
                  (format str "mem"))
  (save-acl2-in-clisp-aux sysout-name mem-name nil nil))

#+clisp
(defun save-exec-raw (sysout-name host-lisp-args inert-args)
  (setq *acl2-default-restart-complete* nil)
  (save-acl2-in-clisp-aux sysout-name sysout-name host-lisp-args inert-args))

#+ccl
(defun save-acl2-in-ccl-aux (sysout-name core-name
                                         &optional
                                         (host-lisp-args nil save-exec-p)
                                         inert-args)
  (let* ((ccl-program0
          (or (car ccl::*command-line-argument-list*) ; Gary Byers suggestion
              (exit-with-build-error
               "Unable to determine CCL program pathname!")))
         (os (get-os))
         (ccl-program1 (ignore-errors (our-truename ccl-program0 :safe)))
         (ccl-program (cond
                       (ccl-program1
                        (qfuncall pathname-os-to-unix
                                  ccl-program1
                                  os
                                  *the-live-state*))
                       (t
                        (when (probe-file *acl2-status-file*)
                          (delete-file *acl2-status-file*))
                        (exit-with-build-error
                         "Your CCL was apparently invoked as ~s.~%In order to ~
                          save an ACL2 executable, ACL2~%must determine the ~
                          absolute pathname of the~%CCL executable.  That ~
                          determination failed.~%Failure can occur if you ~
                          invoked CCL as a~%soft link on your Unix PATH ~
                          rather than as a~%regular file."
                         ccl-program0))))
         (use-thisscriptdir-p (use-thisscriptdir-p sysout-name core-name))
         (core-name-given core-name)
         (core-name (unix-full-pathname core-name
                                        (pathname-name ccl-program)))
         (core-name-string (if use-thisscriptdir-p
                               (concatenate 'string
                                            "$THISSCRIPTDIR/"
                                            core-name-given
                                            "."
                                            (pathname-name ccl-program))
                             core-name)))
    (when (probe-file sysout-name)

; At one point we supplied :if-exists :overwrite in the first argument to
; with-open-file below.  Robert Krug reported problems with that solution in
; OpenMCL 0.14 (CCL).  A safe solution seems to be simply to delete the file
; before attempting to write to it.

      (delete-file sysout-name))
    (when (probe-file core-name)
      (delete-file core-name))
    (with-open-file ; write to nsaved_acl2
     (str sysout-name :direction :output)
     (write-exec-file str

; Gary Byers has pointed out (Feb. 2009) that:

;    In order for REQUIRE (and many other things) to work, the lisp needs
;    to know where its installation directory (the "ccl" directory) is.
;    (More accurately, the "ccl" logical host has to has its logical-pathname
;    translations set up to refer to that directory:)
;
;    ? (truename "ccl:")
;    #P"/usr/local/src/ccl-dev/"

; So we make an effort to set CCL_DEFAULT_DIRECTORY correctly so that the above
; truename will be correct.

                      ("~a~a~%"
                       (if use-thisscriptdir-p *thisscriptdir-def* "")
                       (let ((default-dir
                               (or (ccl::getenv "CCL_DEFAULT_DIRECTORY")
                                   (let ((path (our-truename "ccl:")))
                                     (and path
                                          (qfuncall pathname-os-to-unix
                                                    (namestring path)
                                                    (get-os)
                                                    *the-live-state*))))))
                         (if default-dir
                             (format nil
                                     "export CCL_DEFAULT_DIRECTORY=~s"
                                     default-dir)
                           "")))

; See the section on "reading characters from files" in file acl2.lisp for an
; explanation of the -K argument below.

; It is probably important to use -e just below instead of :toplevel-function.
; Jared Davis and Sol Swords have told us that it seems that with
; :toplevel-function one gets a new "toplevel" thread at start-up, which "plays
; badly with the thread-local hash tables that make up the hons space".

                      "~s -I ~s~a -K ISO-8859-1 -e ~
                       \"(acl2::acl2-default-restart)\"~a ~a~%"
                      ccl-program
                      core-name-string
                      (if save-exec-p

; For an ACL2 built from sources, the saved script will include "-Z 64M"; see
; comment below.  But with save-exec, no -Z option will be written.  The new
; script can then be expected to invoke ACL2 with the same stack sizes as did
; the original (which had -Z 64M explicitly), unless an explicit -Z option is
; given to save-exec or globals such as
; ccl::*initial-listener-default-control-stack-size* (see community book
; books/centaur/ccl-config.lsp) are set before the save-exec call.

; Turning now to the case of building from sources, as opposed to save-exec:

; We use -Z 64M even though the default for -Z (as of mid-2013) is 2M, in order
; to get larger stacks.  We have ample evidence that a larger stack would be
; useful: an ACL2 example from David Russinoff in August 2013 for which 8M was
; insufficient (defining a constant function with body '(...), a quoted list of
; length 65536; our own x86 model requiring 4M for an ACL2 proof using
; def-gl-thm; and more generally, Centaur's routine use of large stacks,
; equivalent to -Z 256M.  Not surprisingly, that performance was not hurt using
; a larger stack size, for two pairs of ACL2(h) regressions as follows.  We ran
; one pair of runs on a Linux system with 32GB of RAM, and one pair of runs on
; a MacBook Pro with 8GB of RAM, all in August 2013.  For each pair we ran with
; -Z 64M and also omitting -Z (equivalent to using -Z 2M).  Our main concern
; was potentially larger backtraces when using (set-debugger-enable :bt), as
; during a regression.  We solved that by restricting backtrace counts using
; *ccl-print-call-history-count*.

                          ""
                        " -Z 64M")
                      (insert-string host-lisp-args)
                      (user-args-string inert-args)))
    (chmod-executable sysout-name)
    (ccl::gc)
    (ccl:save-application core-name)))

#+ccl
(defun save-acl2-in-ccl (sysout-name &optional mode core-name)
  (declare (ignore mode))
  (load "openmcl-acl2-trace.lisp")
  (save-acl2-in-ccl-aux sysout-name core-name))

#+ccl
(defun save-exec-raw (sysout-name host-lisp-args inert-args)
  (setq *acl2-default-restart-complete* nil)
  (save-acl2-in-ccl-aux sysout-name sysout-name host-lisp-args inert-args))

; Since saved-build-date-string is avoided for MCL, we avoid the following too
; (which is not applicable to MCL sessions anyhow).
#-(and mcl (not ccl))
(defun save-acl2 (&optional mode other-info

; Currently do-not-save-gcl is ignored for other than GCL.  It was added in
; order to assist in the building of Debian packages for ACL2 based on GCL, in
; case Camm Maguire uses compiler::link.

                            do-not-save-gcl)
  #-gcl (declare (ignore do-not-save-gcl))
  #-(or gcl allegro cmu sbcl clisp ccl)
  (declare (ignore other-info))

  #+gcl
  (when (boundp 'si::*optimize-maximum-pages*) ; Camm Maguire suggestions
    (setq si::*optimize-maximum-pages* nil)
    (when *gcl-large-maxpages*
      (si::set-log-maxpage-bound
       (1+ (integer-length most-positive-fixnum)))))

; Consider adding something like
; (ccl::save-application "acl2-image" :size (expt 2 24))
; for the Mac.

  (load-acl2 :load-acl2-proclaims *do-proclaims*)
  (eval mode)
  (princ "
******************************************************************************
          Initialization complete, beginning the check and save.
******************************************************************************
")
  (cond
   ((or (not (probe-file *acl2-status-file*))
        (with-open-file (str *acl2-status-file*
                             :direction :input)
                        (not (eq (read str nil)
                                 :initialized))))
    (exit-with-build-error
     "Initialization has failed.  Try INITIALIZE-ACL2 again.")))

  #+gcl
  (save-acl2-in-gcl "nsaved_acl2" other-info mode do-not-save-gcl)
  #+lucid
  (save-acl2-in-lucid "nsaved_acl2" mode)
  #+lispworks
  (save-acl2-in-lispworks "nsaved_acl2" mode other-info)
  #+allegro
  (save-acl2-in-allegro "nsaved_acl2" mode other-info)
  #+cmu
  (save-acl2-in-cmulisp "nsaved_acl2" mode other-info)
  #+sbcl
  (save-acl2-in-sbcl "nsaved_acl2" mode other-info)
  #+clisp
  (save-acl2-in-clisp "nsaved_acl2" mode other-info)
  #+ccl
  (save-acl2-in-ccl "nsaved_acl2" mode other-info)
  #-(or gcl lucid lispworks allegro clisp ccl cmu sbcl)
  (error "We do not know how to save ACL2 in this Common Lisp.")
  (format t "Saving of ACL2 is complete.~%"))

(defun generate-acl2-proclaims ()

; See the Essay on Proclaiming.

  (let ((filename "acl2-proclaims.lisp"))
    (when (probe-file filename)
      (delete-file filename))
    (cond
     ((eq *do-proclaims* :gcl)
      (cond ((probe-file "sys-proclaim.lisp")
             (rename-file "sys-proclaim.lisp" filename))
            (t (exit-with-build-error
                "File sys-proclaim.lisp does not exist!"))))
     (*do-proclaims*
      (format t "Beginning load-acl2 and initialize-acl2 on behalf of ~
                 generate-acl2-proclaims.~%")
      (load-acl2 :fast t)
; Use funcall to avoid compiler warning in (at least) CCL.
      (qfuncall initialize-acl2 'include-book nil nil 'generating)
      (proclaim-files filename))
     (t
      (when (probe-file filename)
        (delete-file filename))
      (with-open-file
       (str filename :direction :output)
       (format str "(in-package \"ACL2\")~%~%")
       (format str
               "; No proclaims are generated here for this host Lisp.~%")))))
  nil)

; The following avoids core being dumped in certain circumstances
; resulting from very hard errors.

#+gcl
(si::catch-fatal 1)
