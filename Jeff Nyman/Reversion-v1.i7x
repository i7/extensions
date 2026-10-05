Version 1.0 of Reversion by Jeff Nyman begins here.

"Lets the story turn time back to a branch point, with the player character remembering what happened, and keeps the player's UNDO from crossing back into the abandoned timeline; also lets the story limit or refuse UNDO."

"based (partly) on ideas in Undo Output Control by Nathanael Nerode and Erik Temple."

Include Protected Memory by Jeff Nyman.

[How it works. A branch point is a Protected Memory checkpoint, taken at the
start of a turn, just before the command is read. Reverting returns to it, so
the story carries on from that prompt, with everything as it was then except
protected memory: what the player character remembers, and the counts kept
here. A reversion leaves the player's undo states from the abandoned timeline
in the interpreter; an UNDO that lands in one is noticed (it carries an older
reversion count than protected memory does) and sent straight back to the
branch point.]

Part - Branch Points

[Words of the reversion record:
	0 how many reversions there have been
	1 the branch point most recently reverted to
	2 1 while returning to it because an UNDO crossed a reversion, 2 while
	  visiting it (see "visit", below)
	3-10 how many reversions to each of the eight checkpoints
	11 how many UNDOs the player has used.]
The reversion record is a protected slot. The size of the reversion record is 12.

[A branch point waiting to be taken at the start of the next turn, as a word
(0 for none).]
The pending branch point is a number that varies.

[The reversion count as this timeline knows it: ordinary memory, so an UNDO into
the abandoned timeline brings back an older value.]
The timeline reversion count is a number that varies.

To mark (C - a checkpoint) as a branch point:
	now the pending branch point is C as a word.

To decide whether (C - a checkpoint) can be reverted to:
	if checkpoint C is available, yes;
	no.

To decide which number is the number of reversions:
	decide on word 0 of the reversion record.

To decide which number is the number of reversions to (C - a checkpoint):
	let W be C as a word;
	increase W by 2;
	decide on word W of the reversion record.

To decide whether there has been a reversion:
	if word 0 of the reversion record > 0, yes;
	no.

[A condition rather than a value, so that a story with no checkpoints at all
still compiles.]
To decide whether (C - a checkpoint) is the branch point last reverted to:
	if there has been a reversion and word 1 of the reversion record is C as a word, yes;
	no.

[Visiting: going to a branch point and coming straight back, without reverting.
The present is kept in a checkpoint of its own; at the branch point, the branch
point visiting rules run (they can look around, or imagine something there, and
write what they find into protected memory), and then the story returns to the
present, carrying on just after the "visit" phrase. A visit isn't a reversion:
it isn't counted, and the reversion to rules don't run.]

The present visit point is a checkpoint.

The branch point visiting rules are a checkpoint based rulebook.

To visit (C - a checkpoint):
	if a moment is happening, stop;
	unless checkpoint C is available, stop;
	if C is the present visit point, stop;
	let R be the result of taking checkpoint the present visit point;
	if R is 2:
		discard checkpoint the present visit point;
		stop;
	if R is 0, stop;
	set word 2 of the reversion record to 2;
	return to checkpoint C;
	set word 2 of the reversion record to 0.

To revert to (C - a checkpoint):
	if a moment is happening, stop;
	unless checkpoint C is available, stop;
	set word 0 of the reversion record to (word 0 of the reversion record) + 1;
	set word 1 of the reversion record to C as a word;
	let W be C as a word;
	increase W by 2;
	set word W of the reversion record to (word W of the reversion record) + 1;
	return to checkpoint C.

Chapter - Taking branch points and arriving back

[Branch points are taken here, at the start of a turn. Returning to one carries
on from just after "take checkpoint", in this rule, so this is also where the
story arrives back.]
This is the take a pending branch point rule:
	if the pending branch point is 0, make no decision;
	let C be (the pending branch point) as a checkpoint;
	now the pending branch point is 0;
	let R be the result of taking checkpoint C;
	if R is 2:
		now the timeline reversion count is word 0 of the reversion record;
		if word 2 of the reversion record is 1:
			set word 2 of the reversion record to 0;
			follow the undo can't cross a reversion rule;
		otherwise if word 2 of the reversion record is 2:
			set word 2 of the reversion record to 0;
			follow the branch point visiting rules for C;
			return to checkpoint the present visit point;
		otherwise:
			follow the reversion to rules for C.

The take a pending branch point rule is listed before the parse command rule in the turn sequence rules.

[Run after each reversion, at the branch point. The last one describes where the
player is; unlist it ("The look around after reverting rule is not listed in the
reversion to rules.") to describe the return some other way.]
The reversion to rules are a checkpoint based rulebook.

Last reversion to rule (this is the look around after reverting rule):
	try looking.

This is the undo can't cross a reversion rule:
	say "[bracket]You can't undo past the moment time turned back.[close bracket]" (A);
	say line break.

Chapter - Keeping UNDO in this timeline

Use undo across reversions translates as (- Constant RV_UNDO_ACROSS; -).

[A restart or a restore starts a timeline of its own, which has seen every
reversion so far.]
A time jump rule (this is the keep count of the timeline's reversions rule):
	if the latest time jump is not player undo:
		now the timeline reversion count is word 0 of the reversion record.

Time jump for player undo (this is the stop undo crossing a reversion rule):
	if the undo across reversions option is active, make no decision;
	if the timeline reversion count < word 0 of the reversion record:
		let C be (word 1 of the reversion record) as a checkpoint;
		if checkpoint C is available:
			set word 2 of the reversion record to 1;
			return to checkpoint C;
		otherwise:
			now the timeline reversion count is word 0 of the reversion record;
	otherwise:
		set word 11 of the reversion record to (word 11 of the reversion record) + 1.

Part - Recollections

[What the player character carries back: one bit each, in protected memory, so
they survive reversions, restarts, restores and UNDO.]

A recollection is a kind of value.

The recollection store is a protected slot. The size of the recollection store is 8.

To decide which number is the recollection word for (R - a recollection): (- RV_Word({R}) -).
To decide which number is the recollection bit for (R - a recollection): (- RV_Bit({R}) -).
To decide which number is (A - a number) with recollection bit (B - a number): (- ({A} | {B}) -).
To decide which number is (A - a number) without recollection bit (B - a number): (- ({A} & (~{B})) -).
To decide whether (A - a number) has recollection bit (B - a number): (- (({A} & {B}) ~= 0) -).

To remember (R - a recollection):
	let W be the recollection word for R;
	set word W of the recollection store to (word W of the recollection store) with recollection bit (the recollection bit for R).

To forget (R - a recollection):
	let W be the recollection word for R;
	set word W of the recollection store to (word W of the recollection store) without recollection bit (the recollection bit for R).

To decide whether the player remembers (R - a recollection):
	let W be the recollection word for R;
	if word W of the recollection store has recollection bit (the recollection bit for R), yes;
	no.

Include (-
[ RV_Word r; return (r - 1) / (WORDSIZE * 8); ];
[ RV_Bit r b i; b = 1; for (i = (r - 1) % (WORDSIZE * 8) : i > 0 : i = i - 1) b = b * 2; return b; ];
-).

Part - The Player's UNDO

[UNDO isn't an action, so it can't have check rules; these are its equivalent.
A rule that refuses says why and ends "rule fails". The extension replaces the
kit's Perform_Undo routine to run them (the same in Inform 10.1 and 10.2).]

The undo permission rules are a rulebook.

[Handed to the Inform 6 routine below at the start of play, as a value: naming
a rulebook for Inform 6 is done differently in Inform 10.1 and 10.2, and this
works in both.]
To hand (R - a rulebook) to Inform 6 as the undo permission rules: (- rv_permission_rb = {R}; -).

First when play begins (this is the hand the undo permission rules to Inform 6 rule):
	hand the undo permission rules to Inform 6 as the undo permission rules.

[Inform 10.2: the rulebook can be named for Inform 6 directly. Replace the phrase
and rule above with
	The undo permission rules are accessible to Inter as "RV_PERMISSION_RB".
and, in Perform_Undo below, use RV_PERMISSION_RB in place of the global
rv_permission_rb (which can then go), dropping the "rv_permission_rb &&" test.]

[-1 for no limit.]
The undo allowance is a number that varies. The undo allowance is usually -1.

To decide which number is the number of undos used:
	decide on word 11 of the reversion record.

First undo permission rule (this is the undo prevention rule):
	if the undo prevention option is active:
		say "The use of 'undo' is forbidden in this story." (A);
		say line break;
		rule fails.

An undo permission rule (this is the undo allowance rule):
	if the undo allowance >= 0 and the number of undos used >= the undo allowance:
		say "[bracket]You have no more UNDOs.[close bracket]" (A);
		say line break;
		rule fails.

Include (-
Global rv_permission_rb = 0;
[ Perform_Undo;
	if (rv_permission_rb && FollowRulebook(rv_permission_rb) && RulebookFailed()) return;
	if (IterationsOfTurnSequence == 0) { IMMEDIATELY_UNDO_RM('B'); new_line; return; }
	if (undo_flag == 0) { IMMEDIATELY_UNDO_RM('C'); new_line; return; }
	if (undo_flag == 1) { IMMEDIATELY_UNDO_RM('D'); new_line; return; }
	if (VM_Undo() == 0) { IMMEDIATELY_UNDO_RM('F'); new_line; }
];
-) replacing "Perform_Undo".

Reversion ends here.

---- DOCUMENTATION ----

Reversion lets the story turn time back. It marks branch points, and later reverts to one: everything goes back to how it was then, except what the player character remembers. It's for stories where turning time back is part of the fiction (a rewinding watch, a recurring day, a loop), not for the player's UNDO, which is a matter of the interface. It also makes sure the two don't get in each other's way, and lets the story limit or refuse UNDO.

It needs Glulx, and Protected Memory (which it includes).

Section: Branch points

A branch point is a checkpoint (from Protected Memory). Declare them as values:

	Dawn is a checkpoint.

Mark one, and later revert to it:

	When play begins: mark dawn as a branch point.

	Instead of winding the pocket watch:
		say "The hands spin backwards.";
		revert to dawn.

A branch point is taken at the start of the next turn, just before the command is read, so reverting always returns to a prompt, as UNDO does. Everything is as it was at that moment, except protected memory. Marking a branch point again replaces it. Up to eight checkpoints can be used; this extension uses one (the present visit point, see "Visiting a branch point"), leaving seven for the story.

"If (checkpoint) can be reverted to" is true once a branch point has been taken. Reverting to one that hasn't been taken yet does nothing, and so does reverting during a Protected Memory moment or a Counterfactuals imagining.

Section: Arriving back

After a reversion, the reversion to rules run, and the last of them describes where the player is (by trying looking):

	Reversion to dawn:
		say "The night falls away, and it is dawn again."

	A reversion to rule:
		say "You remember everything."

To describe the return some other way:

	The look around after reverting rule is not listed in the reversion to rules.

These can be asked at any time:

	the number of reversions
	the number of reversions to (checkpoint)
	if there has been a reversion
	if (checkpoint) is the branch point last reverted to

Section: Visiting a branch point

A story can also go to a branch point and come straight back, to find something out there:

	visit dawn;

The present is kept in a checkpoint, the story goes to the branch point, the branch point visiting rules run there, and then the story comes back to the present and carries on just after "visit". Nothing done at the branch point lasts, except what the rules write into protected memory:

	The dawn weather is a protected slot.

	Branch point visiting dawn:
		set word 0 of the dawn weather to the weather as a word.

A visit isn't a reversion: it isn't counted, and the reversion to rules don't run. The visiting rules shouldn't print, since the visit is invisible to the player; and since the story comes back to the present afterwards, they mustn't revert, restart or end the story. Counterfactuals uses visits to ask what would have happened if something had been done at a branch point. Visiting does nothing during a moment, or if the branch point hasn't been taken.

Section: Recollections

What the player character carries back can be anything in protected memory. For facts, there are recollections:

	The vault code is a recollection.

	After reading the note: remember the vault code.

	Instead of opening the vault when the player remembers the vault code: ...

"Remember (recollection)" and "forget (recollection)" set and clear them. Up to 256 recollections can be declared. Like everything in protected memory, recollections survive reversions, restarts, restores and UNDO: UNDO doesn't make the character forget.

Section: UNDO and reversions

After a reversion, the interpreter still holds the player's undo states from before it, in the abandoned timeline. An UNDO that would land in one goes straight back to the branch point instead, and says:

	[You can't undo past the moment time turned back.]

UNDOs within the new timeline work as usual. To let UNDO go back into the abandoned timeline (for testing, say):

	Use undo across reversions.

Section: Limiting UNDO

UNDO isn't an action, so it has no check rules, but it has undo permission rules. A rule that refuses says why and ends with "rule fails":

	An undo permission rule when the player is in the Burning Room:
		say "There's no taking this back.";
		rule fails.

To limit how many UNDOs the player may use:

	The undo allowance is 3.

"The number of undos used" counts them (an UNDO sent back to a branch point doesn't count). Inform's own "Use undo prevention" still works.

This part replaces one routine of the Inform kits, Perform_Undo (the same in Inform 10.1 and 10.2).

Example: * The Recurring Morning - A watch that turns the morning back, a fact that survives it, and an UNDO that can't cross it.

	*: "The Recurring Morning"

	Include Reversion by Jeff Nyman.

	The Kitchen is a room. "A bright kitchen. The back door leads east."
	The Garden is east of the Kitchen. "An overgrown garden, with a locked shed."
	The shed is scenery in the Garden.
	The player carries a pocket watch.
	The kettle is a device in the Kitchen.
	A note is in the Garden. The description of the note is "Someone has written: the shed code is 4-1-7."

	Morning is a checkpoint.
	The shed code is a recollection.

	When play begins: mark morning as a branch point.

	After examining the note: remember the shed code; continue the action.

	Instead of opening the shed:
		if the player remembers the shed code, end the story finally saying "The shed swings open";
		otherwise say "It needs a code."

	Winding is an action applying to one thing. Understand "wind [something]" as winding.
	Instead of winding the pocket watch:
		say "You wind the watch backwards, and the morning folds up around you.";
		revert to morning.

	Reversion to morning:
		say "It is morning again. [if the number of reversions is 1]Strange.[otherwise]Again.[end if]".

	Test me with "switch on kettle / e / take note / x note / wind watch / look / e / open shed".

Switching on the kettle and taking the note are undone by winding the watch, but the shed code isn't: it's a recollection. (A test script stops at a reversion, since its own place is turned back too, so type the last two commands by hand.) UNDO straight after winding the watch can't go back to the garden where the note was taken; here, because the morning is the story's first turn, Inform itself says there's nothing to undo.
