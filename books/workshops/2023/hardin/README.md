Supporting Files for "Verification of a Rust Implementation of Knuth's Dancing Links using ACL2",
2023 ACL2 Worskop (https://arxiv.org/abs/2311.08862)

David Hardin


The files in this directory provide source code and correctness proofs for a Circular Doubly-Linked
List (CDLL) originally hand-written in the Rust programming language, and supporting Donald Knuth's
"Dancing Links" via the remove and restore operators on the CDLL, as described in Knuth's
*The Art of Computer Programming*, volume 4B.  A number of additional correctness proofs are also 
provided for other common CDLL operators, resulting in some 285 proved theorems in ACL2.  Development of
the theorems in this directory was conducted using ACL2 version 8.5; the theorems have been re-proved
using a recent ACL2 development snapshot (Git commit hash: e8434bafd280bd06a0f3d2f1eefc5da0a369bc4a).

The top-level ACL2 file is cdll-thms.lisp; run cert.pl on this file in the usual way to certify all
the needed theorems in the various books included in this directory.  This certification should
take less than a minute on modern hardware.  The last theorem in cdll-thms.lisp is the same as
presented in the paper, except that the second hypothesis, the well-formedness hypothesis for
the nth node, has been weakened.

The CDLL source files are located in the src/ subdirectory.  The two source files include the original,
hand-written CDLL Rust implementation, as well as the RAC code that was (mainly) automatically generated
from the Rust code.  (The Rust-to-RAC translation utility is an unverified rough prototype that is not
included in these support materials.  This prototype will be replaced in future work.)  The Rust source
code presented in the paper is basically unchanged.  The ACL2 version of the CDLL code was automatically
generated by David Russinoff's rac tool, the sources for which are included in the ACL2 distribution.
The curious ACL2 user should be able to recreate cdll-trans.lisp from cdll-trans.cpp (CDLL -- translated),
once the rac tools have been built (see instructions in {$ACL2_DIR}/books/projects/rac/README).

The forms in cdll-trans.lisp can be loaded into ACL2 and the Dancing Links functions exercised, but they
are a bit slow due to the large list sizes involved.  One could make the list sizes smaller, but to
drive the point home that ACL2 can handle industrial-size problems, everything is reasonably large --
big enough that loop unrolling could not be a viable proof strategy.

Finally, note that the ACL2 code for the restore function presented in the paper is identical to the code
for the same function present in the cdll-trans.lisp file in this directory.

Many thanks to David Russinoff and his team at Arm for continuing to develop RAC; to Alessandro Coglio,
Eric Smith, and the team at Kestrel for guidance on building ACL2 snapshots on Apple Silicon, as well
as for developing their ACL2 linter; and to Matt Kaufmann for his patient prodding to complete the
preparation of these supporting materials after I (foolishly) decided to add some additional functions to
the CDLL implementation subsequent to the completion of the ACL2 Workshop paper.  These functions turned
out to be difficult for me to prove, causing some rework of the proof infrastructure.  Finally, thanks go
to Brad Martin for his continuing support of formal verification research and development applied to
practical high-assurance engineering problems.  Brad's challenge to improve the scalability and usability
of formal methods has motivated much of this work in recent years.
