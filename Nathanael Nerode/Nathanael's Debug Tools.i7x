Version 1/210331 of Nathanael's Debug Tools by Nathanael Nerode begins here.

"Miscellaneous stuff I like to have built in when debugging and programming, but would never want to relase."

Section - Quit Faster

[Speed up the debug cycle by not asking for confirmation before quitting.]

Include (-
[ QUIT_THE_GAME_R;
  if (actor ~= player) rfalse;
  if ((actor == player) && (untouchable_silence == false))
    quit;
];
-) instead of "Quit The Game Rule" in "Glulx.i6t".

Section - Startup Debugging

[ See RulesOnSub in Tests.i6t for reference ]
To turn rules tracing on:
	(- debug_rules = 1; -)

This is the trace rules at startup rule:
	turn rules tracing on;

[ We want to let the game initialize memory, start the virtual machine, and seed the RNG before tracing starts.]
The trace rules at startup rule is listed after the seed random number generator rule in the startup rulebook.
The trace rules at startup rule is listed before the update chronological records rule in the startup rulebook.

[ The first rule which will actually trace is the "start in the correct scenes" rule.  This is because NI doesn't instrument the earlier startup rules with the debug code, a problem we can't fix because NI is closed-source. ]
[ The untraceable rules in Standard Rules are:
		initialize memory
		virtual machine startup
		seed random number generator
		update chronological records
		declare everything initially unmentioned -- the one we might want to trace
		position player in model world
]


Nathanael's Debug Tools ends here.

---- DOCUMENTATION ----

To disable the tracing of startup rules:

	The trace rules at startup rule is not listed in the startup rulebook.
