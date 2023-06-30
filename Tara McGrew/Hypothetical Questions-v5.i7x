Version 5.1.0 of Hypothetical Questions (for Glulx only) by Tara McGrew begins here.

"Allows us to test the consequences of a phrase or action without permanently changing the game state."

[At one point, I7 did some weird things with curly braces in the generated source when we use phrases as parameters, so we had to work around that here. Specifically, I7 added an opening brace before {ph} and a closing brace after the end of our code.]

To hypothetically (ph - a phrase) and consider (R - a rule): (-
{-my:1} = Hypo_Start({phrase options});
if ({-my:1} == 1) {ph}
Hypo_Middle({R});
if ({-my:1} == 2) Hypo_End();
-)


[To hypothetically (ph - a phrase) and consider (R - a rule): (- switch (Hypo_Start({phrase options})) { 1: do { {ph} } until (1); Hypo_Middle({R}); 2:  } -).]

To say the/-- hypothetical output: (- Hypo_Capture_Print(); -).

Use hypothetical output length of at least 256 translates as (- Constant HYPO_CAPTURE_BYTES = {N}; -).

Include (-
Constant HYPO_RESULT_WORDS = 2;
! hypo_result-->0 = rule success flag
! hypo_result-->1 = rule result
Array hypo_result --> HYPO_RESULT_WORDS;

#ifndef HYPO_CAPTURE_BYTES;
Constant HYPO_CAPTURE_BYTES = 256;
#endif;
Array hypo_capture -> HYPO_CAPTURE_BYTES;
Global hypo_capture_len;
Global hypo_capture_previous;

! returns 1 when entering the hypothetical universe, 2 when returning to reality, 0 if entering failed in the first place
[ Hypo_Start flags  rv seed strtbl iosys iorock;
	do { @random 0 seed; } until (seed ~= 0);
	@getstringtbl strtbl;
	@getiosys iosys iorock;

	@saveundo rv;

	@setrandom seed;
	@setstringtbl strtbl;
	@setiosys iosys iorock;

	switch (rv) {
		0: Hypo_Capture_Start(); return 1; ! saveundo succeeded
		1: print "[This game requires an interpreter with undo support.]^"; return 0; ! saveundo failed
		-1: return 2; ! restoreundo
	}
];

! consider a rule, protect its result, and restore the state saved by Hypo_Start
[ Hypo_Middle rule  a b save_sp hypo_size;
	Hypo_Capture_End();
	save_sp = say__p; say__p = 0;
	FollowRulebook(rule);
	if (say__p == false) say__p = save_sp;
	hypo_result-->0 = RulebookOutcome();
	if (hypo_result-->0 == RS_FAILS or RS_SUCCEEDS)
		hypo_result-->1 = ResultOfRule();
    hypo_size = (HYPO_RESULT_WORDS * WORDSIZE);
	@protect hypo_result hypo_size;
	@restoreundo rule;	! never returns if successful
	print "[What happened to my undo state? --hypo]^";
];

! load the rule result from Hypo_Middle back onto the rulebook stack
[ Hypo_End;
	switch (hypo_result-->0) {
		RS_FAILS: RulebookFails(1, hypo_result-->1);
		RS_SUCCEEDS: RulebookSucceeds(1, hypo_result-->1);
		default: RuleHasNoOutcome();
	}
];

! start capturing output
[ Hypo_Capture_Start;
	#ifdef is_fyrevm;
	if (is_fyrevm) {
		! use the filter I/O system
		OpenOutputBuffer(hypo_capture, HYPO_CAPTURE_BYTES);
		return;
	}
	#endif;

	! use a Glk memory stream
	hypo_capture_previous = glk_stream_get_current();
	glk_stream_set_current(glk_stream_open_memory(hypo_capture, HYPO_CAPTURE_BYTES, filemode_Write, 0));
];

! stop capturing output
[ Hypo_Capture_End  f;
	#ifdef is_fyrevm;
	if (is_fyrevm) {
		hypo_capture_len = CloseOutputBuffer(0);
		return;
	}
	#endif;

	glk_stream_close(glk_stream_get_current(), gg_arguments);
	hypo_capture_len = gg_arguments-->1;
	glk_stream_set_current(hypo_capture_previous);
	hypo_capture_previous = 0;
];

! print the capture buffer
[ Hypo_Capture_Print  i;
	for (i=0: i<hypo_capture_len: i++)
		print (char) hypo_capture->i;
];
-).

Hypothetical Questions ends here.

---- DOCUMENTATION ----

The basic operation of this extension is to run a phrase, then consider a rule or rulebook, and finally undo the phrase while preserving the outcome of the rule. For example:

	This is the check player's pulse rule:
		if the game ended in death, rule fails; otherwise rule succeeds.
	
	...
	
	hypothetically try drinking the poison and consider the check player's pulse rule;
	if the rule failed, say "Drinking the poison would be a bad idea.";

Here, the phrase we're hypothetically running is "try drinking the poison". The "check player's pulse" rule tests whether the player has died after drinking the poison. The extension then undoes the drinking action, but remembers the decision made by the check player's pulse rule.

In fact, we can hypothetically run any phrase, not just an action:

	To drink everything:
		repeat with X running through things that can be touched by the player:
			try drinking X.
	
	...
	
	hypothetically drink everything and consider the check player's pulse rule;

The player won't see any messages about things that happened hypothetically, because this extension captures the text printed during hypothetical execution. Our rule can check "[the hypothetical output]" to see what was printed. (If the rule itself prints anything, though, the player will see it.) For example:

	This is the check for interesting events rule:
		if "[the hypothetical output]" exactly matches the regular expression "\s*Time passes\.\s*", rule fails;
		otherwise rule succeeds.
	
	...
	
	hypothetically try waiting and consider the check for interesting events rule;

The maximum length of captured text is 256 characters by default; anything more will be thrown away. We can change this with a use option:

	Use hypothetical output length of at least 1024.

Section: Caveats

This extension requires an interpreter that supports undo. To the best of the author's knowledge, every Glulx interpreter supports undo, so this isn't much of an issue.

Avoid hypothetically running any code that uses undo, or that hypothetically runs some other code in turn.

If the hypothetical code changes the Glk library state (opening windows, closing streams, moving the cursor, etc.) -- or the FyreVM channel state, when running on FyreVM -- these changes will not be rolled back when hypothetical execution is finished.

Section: Change Log

Version 2 fixes a paragraph spacing issue where multiple hypotheticals would cause extra line breaks; and prevents hypothetical changes to the random number generator, I/O system, and string decoding table from leaking back into reality.

Version 3 was updated for compatibility with 6L38 by Emily Short.

Version 4 was updated for compatibility with 6M62.

Example: * A Sense of Adventure - Letting the player know what will happen if he picks up nearby objects.

Here we use the extension to the give the player a bit of clairvoyance. After moving to another room, we hypothetically try picking up every object in the location, then test whether the player would have died, won the game, or gained points. If so, we print an appropriate message.

	*: "A Sense of Adventure"
	
	Include Hypothetical Questions by Tara McGrew.
	
	Use scoring.
	
	The maximum score is 5.
	
	Hallway is a room. "This hall leads east and west. There's also a door to the south."
	
	Trophy Room is east of the hallway. "This room is absolutely jam-packed with trophies. The exit is to the west."
	
	A golden idol is in the trophy room. After taking the golden idol for the first time, increase score by 5.
	
	Danger Zone is west of the hallway. "This room is full of various hazards. If you know what's good for you, you'll leave to the east."
	
	A cursed idol is in the danger zone. After taking the cursed idol: say "As you pick up the idol, you feel an evil presence sucking the life force out of your body."; end the story.
	
	Winners' Lounge is south of the hallway. "This is where winners hang out. A door to the north leads back to the hallway."
	
	The Mask of Victory is here. "A strange mask is hanging on the wall here. A sign beneath it simply states: 'The Mask of Victory'." After taking the Mask of Victory, end the story finally.
	
	Report going:
		hypothetically take everything and consider the player's fate rulebook;
		if the outcome of the rulebook is:
			-- the player dies outcome: say "You sense an ominous presence. Better be careful picking things up in here!";
			-- the player wins outcome: say "You sense your victory is at hand!";
			-- the player scores outcome: say "You sense a potential profit. Better grab everything you can!".
	
	To take everything:
		repeat with X running through things in the location:
			try taking X.
	
	Player's fate is a rulebook. The player's fate rulebook has outcomes player dies, player wins, player scores, and nothing noteworthy (success - the default).
	
	A player's fate rule when the story has ended finally: player wins.
	
	A player's fate rule when the story has ended: player dies.
	
	A player's fate rule when the score is greater than the last notified score: player scores.
	
	Test me with "w / e / e / get idol / w / s / get mask".
