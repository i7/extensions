Version 1 of Parser Error Number Bugfix by Nathanael Nerode begins here.

"Fixes a nasty bug in the I7 error names in Inform 7 version 6M62 (and probably earlier)."

[
The Standard Rules have a very serious error in Section SR2/14 - Command parser errors.
The order of the "noun did not make sense in that context error" and the "referred to a determination of scope error" is *swapped*
compared to the order of the corresponding errors in I6 code.

Unfortunately, there's a lot of stuff in Section SR2/14 and replacing it is a huge pain.  It's easier to replace the *I6 code* and swap the error number there,
so that's what we do here.
]

Include (-
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Replacement for Definitions.i6t: Parser Error Numbers
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====

! The traditional ways in which the I6 library's parser, which we adopt here
! more or less intact, can give up on a player's command. See the {\it Inform
! Designer's Manual}, 4th edition, for details.
!
! There is a nasty bug in the Standard Rules which swapped the order of ASKSCOPE_PE and NOTINCONTEXT_PE.
! In order to correct this bug, we swap their order here.

Constant STUCK_PE         = 1;
Constant UPTO_PE          = 2;
Constant NUMBER_PE        = 3;
Constant ANIMA_PE         = 4;
Constant CANTSEE_PE       = 5;
Constant TOOLIT_PE        = 6; ! Unused, but story author could use it
Constant NOTHELD_PE       = 7;
Constant MULTI_PE         = 8;
Constant MMULTI_PE        = 9;
Constant VAGUE_PE         = 10;
Constant EXCEPT_PE        = 11;
Constant VERB_PE          = 12;
Constant SCENERY_PE       = 13; ! Unused, but story author could use it
Constant ITGONE_PE        = 14;
Constant JUNKAFTER_PE     = 15; ! Unused, but story author could use it
Constant TOOFEW_PE        = 16;
Constant NOTHING_PE       = 17;
Constant ASKSCOPE_PE      = 19; ! Standard Rules swapped these by accident
Constant NOTINCONTEXT_PE  = 18; ! Standard Rules swapped these by accident
Constant BLANKLINE_PE     = 20; ! Not formally a parser error, but used by I7 as if
Constant ANIMAAGAIN_PE    = 21;
Constant COMMABEGIN_PE    = 22;
Constant MISSINGPERSON_PE = 23;
Constant ANIMALISTEN_PE   = 24;
Constant TOTALK_PE        = 25;

-) instead of "Parser Error Numbers" in "Definitions.i6t".

Parser Error Number Bugfix ends here.

---- DOCUMENTATION ----

In version 6M62 of Inform 7, there is a nasty bug in Standard Rules by Graham Nelson which swaps the I7 names of two error messages.
	referred to a determination of scope error - NOTINCONTEXT_PE
	noun did not make sense in that context error - ASKSCOPE_PE

This fixes the bug by swapping the error numbers in the I6 template code.  (This was less invasive than replacing the defective section of Standard Rules.)
