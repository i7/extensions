Version 1/150829 of C by G begins here.

"A code golfing library by Dannii Willis"

[ Inform 7 is of course not at all suited to code golfing. This extension doesn't make it any easier to compress Inform 7 code, but it does give you a safe hook to run your code without having extraneous line breaks be printed. ]

[ Define that obligatory room. ]
There is a room.

[ Our new startup rulebook, which is also where hooks can be added. ]
Z is a rulebook.

[ Replace Main() with a simple function which only calls Z. ]
Include (-
Global EarlyInTurnSequence;
Global IterationsOfTurnSequence;
[ Main;
	! Set to 0 to prevent a line break from being printed
	say__p = 0;
	! Hide the status window
	statuswin_size = 0;
	! Set the prompt to ""
	BlkValueCopy( (Global_Vars-->1), EMPTY_TEXT_VALUE );
	#ifdef TARGET_ZCODE; max_z_object = #largest_object - 255; #endif;
	ClearRTP();
	FollowRulebook( (+ Z +) );
];
[ DrawStatusLine; ];
-) instead of "Main" in "OrderOfPlay.i6t".

[ A couple of phrases for input. ]
To decide what text is T:
	request keyboard input;
	decide on "[the player's command]";

To request keyboard input:
	(- @push say__p;
	say__p = 0;
	Keyboard( buffer, parse );
	num_words = WordCount();
	players_command = 100 + num_words;
	@pull say__p; -).

To decide what number is N:
	(- VM_KeyChar() -).

Section (for Glulx only)

Include version 1/140516 of Alternative Startup Rules by Dannii Willis.

A first Z rule:
	carry out the starting the virtual machine activity;

The initial whitespace rule is not listed in any rulebook.

Section (for Z-Machine only)

[ These rules must be run or otherwise we cannot check relations ]
A first Z rule:
	follow the initialise memory rule;
	follow the position player in model world rule;

C ends here.

---- DOCUMENTATION ----

This extension is a minimalistic framework for use with code golfing challenges, such as those found on the Programming Puzzles & Code Golf Stack Exchange site <http://codegolf.stackexchange.com>. It doesn't make Inform 7 any more concise, but does give you a safe hook to run your code from, without any unwanted line breaks, as the standard Inform 7 library likes to produce.

Run your code by creating a Z rule. So for example, a Hello, World! programme can be golfed as:

	Include C by G.Z:say "Hello, World!"

You can also use the Tand N phrases to collect text and a character code input:

	Include C by G.Z:say "[T][N]"

The latest version of this extension can be found at <https://github.com/i7/extensions>. This extension is released under the Creative Commons Attribution licence. Bug reports, feature requests or questions should be made at <https://github.com/i7/extensions/issues>.
