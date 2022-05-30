Version 1 of Autoundo for Object Response Tests by Mike Ciul begins here.

"Tests objects just like Juhana Leinonen's extension, but does an UNDO after each test."

"Inspired by Hypothetical Questions by Jesse McGrew"

Include Object Response Tests by Juhana Leinonen

Book 1 - Triggering Undo From I7

save-restore status is a kind of value. failure to save, successful save, and successful restore are save-restore statuses.

To decide which save-restore status is result of saving undo state: (- Save_Undo_State() -).

To decide whether successfully saved undo state: Decide on whether or not the result of saving undo state is successful save.

To restore undo state: (- Restore_Undo_State(); -).

Include (-

Constant FAILURE_TO_SAVE = 1;
Constant SUCCESSFUL_SAVE = 2;
Constant SUCCESSFUL_RESTORE = 3;

! returns 1 when entering the hypothetical universe, 2 when returning to reality, 0 if entering failed in the first place
[ Save_Undo_State rv seed strtbl iosys iorock;
	! comments from vaporware:

	! The purpose of [these paired sets of three] lines is to restore any changes made by the hypothetical code to 
	! the random number generator, 
	! string decoding table,
	! or I/O system, which aren't part of the Glulx undo state...

	! Without those lines, HQ can't give a good answer to questions like
	! "what number would come up if I spun the roulette wheel now?", because the real spin won't land on the same number as the hypothetical one anyway.
	! It will also leave the game in a bad state if the hypothetical changes the string table or I/O system, although that's unlikely.
	! Also, if the hypothetical makes changes to the Glk state (opening files or windows, etc.), those won't be rolled back either way.
	do { @random 0 seed; } until (seed ~= 0);
	@getstringtbl strtbl;
	@getiosys iosys iorock;

	@saveundo rv;

	@setrandom seed;
	@setstringtbl strtbl;
	@setiosys iosys iorock;

	switch (rv) {
		0: return SUCCESSFUL_SAVE;
		1: print "[This game requires an interpreter with undo support.]^"; return FAILURE_TO_SAVE;
		-1: return SUCCESSFUL_RESTORE;
	}
];

! consider a rule, protect its result, and restore the state saved by Hypo_Start
[ Restore_Undo_State rv;
	@restoreundo rv;	! never returns if successful
	print "[What happened to my undo state? --hypo]^";
];

-)

Book 2 - Autoundo Mode

Autoundo style is a kind of value. The autoundo styles are autoundo off, individual actions, whole turns, and freeze every turn.

The autoundo mode is an autoundo style that varies.

To decide whether we still need to perform an action:
	if autoundo mode is not individual actions or successfully saved undo state, yes;
	no.

To undo the action if necessary:
	if autoundo mode is individual actions, restore undo state.

Current save-restore status is a save-restore status that varies. 

To decide whether we still need to perform a set of tests:
	unless autoundo mode is whole turns, yes;
	if current save-restore status is failure to save, now current save-restore status is the result of saving undo state;
	If current save-restore status is successful save, yes;
	no.

To decide whether we're done performing a set of tests:
	if we still need to perform a set of tests, no;
	yes.

After reading a command when the autoundo mode is not freeze every turn: Now current save-restore status is failure to save.
	
Book 3 - Actions - Not for release

Part - Setting The Autoundo Mode

Setting the autoundo mode to is an action out of world applying to one autoundo style.

Understand "off" as autoundo off. Understand "actions" as individual actions. Understand "turns" as whole turns. Understand "freeze" as freeze every turn.

Understand "autoundo [autoundo style]" as setting the autoundo mode.

Understand "autoundo" and "autoundo [text]" as a mistake ("That option wasn't recognized. You can set the autoundo mode to off, actions, turns, or freeze.").

Carry out setting the autoundo mode to (this is the standard set autoundo mode rule): Now the autoundo mode is the autoundo style understood.

Carry out setting the autoundo mode to (this is the clear save-restore status when resetting autoundo mode rule): Now the current save-restore status is failure to save.

Report setting the autoundo mode to autoundo off:
	say "Autoundo mode disabled. Actions have effects as normal.";

Report setting the autoundo mode to individual actions:
	say "Autoundo mode enabled for individual action tests. Each action will be undone after its output is displayed.";

Report setting the autoundo mode to whole turns:
	say "Autoundo mode enabled for whole turns of object response tests. Undo state will be restored each turn after all tests are complete."

Report setting the autoundo mode to freeze every turn:
	say "Autoundo mode set to freeze every turn. All changes to the world will be undone every turn."

Part - Restoring Undo State in Whole Turns Modes

Before reading a command:
	if the current save-restore status is successful save, restore undo state.

Last before reading a command when the autoundo mode is freeze every turn:
	if the current save-restore status is failure to save:
		now the current save-restore status is the result of saving undo state;

After printing the player's obituary when the autoundo mode is freeze every turn:
	restore undo state.

Part - Object-analyzing

Check object-analyzing when we're done performing a set of tests (this is the don't repeat object-analysis after restoring rule):
	stop the action.

Carry out object-analyzing (this is the go through all analyzing rules with autoundo rule):
	repeat with x running from 1 to the number of rows in the table of analyzing actions:
		if we still need to perform an action:
			follow the testing rule in row x of the table of analyzing actions;
			undo the action if necessary;

The go through all analyzing rules with autoundo rule is listed instead of the go through all analyzing rules rule in the carry out object-analyzing rulebook.

Part - All-encompassing Analyzing

Check all-encompassing analyzing when we're done performing a set of tests (this is the don't repeat all-encompassing analysis after restoring rule):
	stop the action.

Part - Test-verb-trying

Check test-verb-trying when we're done performing a set of tests (this is the don't repeat test-verb-trying after restoring rule):
	stop the action.

The don't repeat test-verb-trying after restoring rule is listed first in the check test-verb-trying rulebook.

Carry out test-verb-trying (this is the repeat an action with all objects with autoundo rule):
	if the topic understood is a topic listed in the Table of analyzing actions:
		repeat with x running through things enclosed by the location of the test-actor:
			if the test-actor can see x:
				now the noun is x;
				if we still need to perform an action:
					follow the testing rule entry;
					undo the action if necessary;

Autoundo for Object Response Tests ends here.

---- DOCUMENTATION ----

Example: * Undropped - items that can't be restored to their original state by dropping them

	*: "Undropped"

	Include Autoundo for Object Response Tests by Mike Ciul.

	Test is a room.

	The glass box is a transparent closed openable container in Test.

	The piece of gum is a thing in Test.

	Check dropping the gum:
		say "It sticks to your fingers and won't let go.";
		stop the action.
	
	After dropping the glass box:
		say "It smashes into a million pieces.";
		Now everything in the glass box is in the location;
		remove the glass box from play.
	
	test me with "autoundo actions/analyze box/analyze gum/autoundo turns/analyze box/analyze gum/i/l/autoundo off/analyze box/analyze gum/i/l"
