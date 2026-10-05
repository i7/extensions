Version 1.0 of Counterfactuals by Jeff Nyman begins here.

"Lets the story imagine what would happen if something were done, for one action or for several turns, and then ask what the imagined world was like, without anything having happened."

"based (partly) on Hypothetical Questions by Tara McGrew."

Include Protected Memory by Jeff Nyman.
Include Reversion by Jeff Nyman.

Use protected memory size of at least 1024.

[How it works. Imagining runs inside a Protected Memory moment: the phrase is run
with its output captured, then (if asked for) the end of the turn and any further
turns, and then the outcome is recorded into two protected slots before the
moment puts the story back. Everything the story can ask about afterwards is read
from those slots.]

Part - The Outcome

[Words of the imagining record:
	0 1 once an imagining has run
	1 1 if the imagined story ended
	2 1 if it ended finally
	3 the change in the score
	4 where the player was at the end
	5 how many turns went by
	6 the time of day at the end
	7 how many things the player carried at the end (at most 32)
	8-39 those things.]
The imagining record is a protected slot. The size of the imagining record is 40.

[The text printed while imagining: word 0 is its length, then one character a
word. At most 511 characters are kept.]
The imagining transcript is a protected slot. The size of the imagining transcript is 512.

Part - Imagining

The imagined turns wanted is a number that varies.
The imagined turns wanted variable translates into Inter as "cf_turns".
The imagined score before is a number that varies.
The imagined score before variable translates into Inter as "cf_score_before".
The imagined turns completed is a number that varies.

[An action can be imagined directly ("imagine drinking the poison"); any other
phrase with "imagine doing" ("imagine doing take everything").]
To imagine (A - a stored action): (-
	cf_turns = 0; if (CF_Begin(0) && PM_MomentStart()) { STORED_ACTION_TY_Try({A}); CF_Middle(); }
-).

To imagine (A - a stored action) for (N - a number) turn/turns: (-
	cf_turns = {N}; if (CF_Begin(0) && PM_MomentStart()) { STORED_ACTION_TY_Try({A}); CF_Middle(); }
-).

To imagine (A - a stored action) with fresh dice: (-
	cf_turns = 0; if (CF_Begin(1) && PM_MomentStart()) { STORED_ACTION_TY_Try({A}); CF_Middle(); }
-).

To imagine (A - a stored action) for (N - a number) turn/turns with fresh dice: (-
	cf_turns = {N}; if (CF_Begin(1) && PM_MomentStart()) { STORED_ACTION_TY_Try({A}); CF_Middle(); }
-).

To imagine doing (ph - a phrase): (-
	cf_turns = 0; if (CF_Begin(0) && PM_MomentStart()) { {ph}; CF_Middle(); }
-).

To imagine doing (ph - a phrase) for (N - a number) turn/turns: (-
	cf_turns = {N}; if (CF_Begin(0) && PM_MomentStart()) { {ph}; CF_Middle(); }
-).

To imagine doing (ph - a phrase) with fresh dice: (-
	cf_turns = 0; if (CF_Begin(1) && PM_MomentStart()) { {ph}; CF_Middle(); }
-).

To imagine doing (ph - a phrase) for (N - a number) turn/turns with fresh dice: (-
	cf_turns = {N}; if (CF_Begin(1) && PM_MomentStart()) { {ph}; CF_Middle(); }
-).

[Before the moment: forget the last outcome, and note the score.]
The preparing to imagine rules are a rulebook.
The completing imagined turns rules are a rulebook.
The recording the imagined outcome rules are a rulebook.

[Handed to the Inform 6 routines below at the start of play, as values: naming
a rulebook for Inform 6 is done differently in Inform 10.1 and 10.2, and this
works in both.]
To hand (A - a rulebook) and (B - a rulebook) and (C - a rulebook) to Inform 6 as the imagining rulebooks: (- cf_prepare_rb = {A}; cf_complete_rb = {B}; cf_record_rb = {C}; -).

First when play begins (this is the hand the imagining rulebooks to Inform 6 rule):
	hand the preparing to imagine rules and the completing imagined turns rules and the recording the imagined outcome rules to Inform 6 as the imagining rulebooks.

[Inform 10.2: the rulebooks can be named for Inform 6 directly, which also makes
them available before play begins. Replace the phrase and rule above with
	The preparing to imagine rules are accessible to Inter as "CF_PREPARE_RB".
	The completing imagined turns rules are accessible to Inter as "CF_COMPLETE_RB".
	The recording the imagined outcome rules are accessible to Inter as "CF_RECORD_RB".
and, in the Inform 6 code below, use CF_PREPARE_RB, CF_COMPLETE_RB and
CF_RECORD_RB in place of the three globals (which can then go), dropping the
"cf_prepare_rb == 0" test in CF_Begin.]

A preparing to imagine rule (this is the prepare to imagine rule):
	clear the imagining record;
	clear the imagining transcript;
	now the imagined score before is the score.

[Inside the moment, after the phrase: the rest of the turn and any further turns,
each a turn of waiting. Following the turn sequence rules from inside a rule runs
the end of a turn (every turn rules, scenes, timed events, the clock, light,
score notification) without reading a command. They stop if the story ends.]
A completing imagined turns rule (this is the complete the imagined turns rule):
	now the imagined turns completed is 0;
	repeat with N running from 1 to the imagined turns wanted:
		if the story has ended, stop;
		if N > 1, try waiting;
		if the story has ended, stop;
		follow the turn sequence rules;
		increment the imagined turns completed.

[Still inside the moment, with the output captured: write down what the world is
like, then let the story's own imagined outcome rules look too.]
A recording the imagined outcome rule (this is the record the imagined outcome rule):
	set word 0 of the imagining record to 1;
	if the story has ended, set word 1 of the imagining record to 1;
	if the story has ended finally, set word 2 of the imagining record to 1;
	set word 3 of the imagining record to the score - the imagined score before;
	set word 4 of the imagining record to the location as a word;
	set word 5 of the imagining record to the imagined turns completed;
	set word 6 of the imagining record to the time of day as a word;
	let C be 0;
	repeat with T running through things enclosed by the player:
		if C < 32:
			let W be C + 8;
			set word W of the imagining record to T as a word;
			increment C;
	set word 7 of the imagining record to C;
	let L be the length of the moment's output;
	if L > 511, now L is 511;
	set word 0 of the imagining transcript to L;
	repeat with I running from 1 to L:
		let K be I - 1;
		set word I of the imagining transcript to character K of the moment's output;
	follow the imagined outcome rules.

[Run at the end of every imagining, inside it: rules here can look at the
imagined world and write what they find into slots of their own.]
The imagined outcome rules are a rulebook.

Part - Imagining Back at a Branch Point

[A backward question: what would have happened if, at a branch point (from the
Reversion extension), the player had done something else. The story visits the
branch point, imagines the action there as a forward question, and comes back
with the outcome. A stored action lives on the heap, which the visit replaces,
so the planned action travels as words in protected memory:
	0 1 while a backward imagining is planned
	1-5 the request flag, actor, action, noun and second noun
	6 how many turns to imagine
	7 1 for fresh dice.]
The backward plan is a protected slot. The size of the backward plan is 8.

[The nouns are read raw, because "the noun part of" gives nothing for a noun
that isn't an object (a number, say). BlkValueRead reads them in Inform 10.1 and
10.2 alike.
Inform 10.2: its own routine for this is PVField, as in PVField({A}, STORA_NOUN_F);
BlkValueRead still works there.]
To decide which number is the raw noun of (A - a stored action): (- (BlkValueRead({-by-reference:A}, STORA_NOUN_F)) -).
To decide which number is the raw second noun of (A - a stored action): (- (BlkValueRead({-by-reference:A}, STORA_SECOND_F)) -).
To try the action with request (R - a number) actor (P - a number) action (A - a number) noun (N - a number) second (S - a number): (- TryAction({R}, {P}, {A}, {N}, {S}); -).

To imagine (A - a stored action) back at (C - a checkpoint):
	imagine A back at C with 0 turns and dice 0.

To imagine (A - a stored action) back at (C - a checkpoint) for (N - a number) turn/turns:
	imagine A back at C with N turns and dice 0.

To imagine (A - a stored action) back at (C - a checkpoint) with fresh dice:
	imagine A back at C with 0 turns and dice 1.

To imagine (A - a stored action) back at (C - a checkpoint) for (N - a number) turn/turns with fresh dice:
	imagine A back at C with N turns and dice 1.

To imagine (A - a stored action) back at (C - a checkpoint) with (N - a number) turns and dice (F - a number):
	if a moment is happening, stop; [and leave the enclosing imagining's record alone]
	clear the imagining record;
	clear the imagining transcript;
	set word 1 of the backward plan to 0; [an imagined action is tried, not requested]
	set word 2 of the backward plan to (the actor part of A) as a word;
	set word 3 of the backward plan to (the action name part of A) as a word;
	set word 4 of the backward plan to the raw noun of A;
	set word 5 of the backward plan to the raw second noun of A;
	set word 6 of the backward plan to N;
	set word 7 of the backward plan to F;
	set word 0 of the backward plan to 1;
	visit C;
	clear the backward plan.

To try the planned action:
	try the action with request (word 1 of the backward plan) actor (word 2 of the backward plan) action (word 3 of the backward plan) noun (word 4 of the backward plan) second (word 5 of the backward plan).

A branch point visiting rule (this is the imagine at the branch point rule):
	if word 0 of the backward plan is not 1, make no decision;
	set word 0 of the backward plan to 0;
	let T be word 6 of the backward plan;
	if word 7 of the backward plan is 1:
		imagine doing try the planned action for T turns with fresh dice;
	otherwise:
		imagine doing try the planned action for T turns.

Include (-
Global cf_turns = 0;
Global cf_score_before = 0;
Global cf_prepare_rb = 0;
Global cf_complete_rb = 0;
Global cf_record_rb = 0;

! Inside a moment, imagining can't start, and mustn't touch the outcome the
! enclosing imagining is recording.
[ CF_Begin fresh;
	if (pm_in_moment || cf_prepare_rb == 0) rfalse;
	FollowRulebook(cf_prepare_rb);
	if (fresh) pm_fresh_dice = 1;
	rtrue;
];

! The kit's parse command and generate action rules only do nothing, when the
! turn sequence is followed from inside a rule, once EarlyInTurnSequence is
! false, which happens when a turn's action is generated. An imagining that
! starts before that (at a branch point, which is reached just before a command
! is read) would otherwise read a real command. The moment puts the flag back.
[ CF_Middle;
	EarlyInTurnSequence = false;
	FollowRulebook(cf_complete_rb);
	PM_MomentEnd(cf_record_rb);
];
-).

Part - Asking About It

To decide whether the imagining ran:
	if the last moment ran and word 0 of the imagining record is 1, yes;
	no.

To decide whether the imagined story ended:
	if word 1 of the imagining record is 1, yes;
	no.

To decide whether the imagined story ended finally:
	if word 2 of the imagining record is 1, yes;
	no.

To decide which number is the imagined score change:
	decide on word 3 of the imagining record.

To decide which object is the imagined location:
	decide on (word 4 of the imagining record) as an object.

To decide which number is the number of imagined turns:
	decide on word 5 of the imagining record.

To decide which time is the imagined time:
	decide on (word 6 of the imagining record) as a time.

To decide whether (T - a thing) was carried in the imagining:
	let C be word 7 of the imagining record;
	repeat with I running from 1 to C:
		let W be I + 7;
		if word W of the imagining record is T as a word, yes;
	no.

To say the imagined output:
	let L be word 0 of the imagining transcript;
	repeat with I running from 1 to L:
		say "[(word I of the imagining transcript) as a unicode character]".

To decide whether the imagined output includes (T - a text):
	let O be "[the imagined output]";
	if O matches the text T, case insensitively:
		yes;
	no.

Counterfactuals ends here.

---- DOCUMENTATION ----

Counterfactuals lets a story imagine what would happen if something were done, and then ask what the imagined world was like, without anything having happened at all:

	imagine drinking the poison;
	if the imagined story ended, say "Something tells you not to drink that.";

Here the story tries drinking the poison, notes what the world is like afterwards, and puts everything back. The player sees nothing of it, and nothing has changed, except that the story now knows the poison is deadly.

It needs Glulx, and Protected Memory (which it includes).

Section: Imagining

Imagine an action by naming it:

	imagine taking the idol;
	imagine Floyd going north;

Any other phrase can be imagined with "imagine doing":

	imagine doing move the player to the Vault;
	imagine doing take everything;

That runs just the action or phrase. To see what happens afterwards, say for how many turns:

	imagine burning the fuse for 3 turns;

That runs the phrase and then the end of the turn (every turn rules, scenes, timed events, the clock and so on), and then waits through the remaining turns, each a turn of the player waiting. So "imagine waiting for 5 turns" asks what happens if the player waits five turns. If the story ends, the imagining stops there.

Section: What can be asked

After imagining:

	if the imagining ran ...
	if the imagined story ended ...
	if the imagined story ended finally ...
	the imagined score change
	the imagined location
	the imagined time
	the number of imagined turns
	if (thing) was carried in the imagining ...
	"[the imagined output]"
	if the imagined output includes "(text)" ...

"The imagining ran" is false if it couldn't: on an interpreter without undo, on the Z-machine, or inside another imagining (imaginings can't be nested). Check it before trusting the rest.

"The imagined output" is what the imagining printed (its first 511 characters), and it can be used at any time afterwards, until the next imagining. "Includes" ignores case.

"Was carried in the imagining" covers everything the player held, directly or inside something, up to 32 things.

Section: Asking anything else

For anything else, write imagined outcome rules. They run at the end of every imagining, in the imagined world, and can write what they find into a protected slot:

	The flood verdict is a protected slot.

	An imagined outcome rule:
		if the cellar is flooded, set word 0 of the flood verdict to 1;
		otherwise set word 0 of the flood verdict to 0.

What these rules print is shown to the player, so they shouldn't normally print anything.

Section: The dice

An imagining sees the same random numbers the story will go on to use, so it shows what really would happen if the same thing were done next.

That holds until the story imagines something again. Glulx can't read the state of its random number generator, only set it, so an imagining shares its dice with the story by choosing new ones for both; the next imagining, of either kind, chooses again. So a forecast stays true only if nothing else is imagined before the forecast moment arrives.

To imagine one of the things that might happen instead:

	imagine rolling the die with fresh dice;
	imagine waiting for 3 turns with fresh dice;

Section: Imagining back at a branch point

With the Reversion extension (which this one includes), the story can also ask what would have happened if, at a branch point, the player had done something else:

	imagine taking the coin back at noon;
	imagine taking the coin back at noon for 3 turns;
	imagine opening the cage back at noon with fresh dice;

The branch point must have been taken (see Reversion). The story visits it, imagines the action there exactly as a forward question would, and comes back, so everything that can be asked afterwards is the same, and nothing has changed. The imagined score change is measured from the branch point. If the branch point hasn't been taken, or this is inside an imagining, it doesn't run.

The action travels to the branch point as its parts (who, what, and the two nouns), so actions on things and values work, but not actions on a topic of conversation.

Section: Limits

An imagining uses one of the interpreter's undo states for an instant and gives it back, so the player's UNDO is unaffected.

The imagined phrase shouldn't save, restore, restart, quit, or take or return to checkpoints. Glk changes (opening windows, playing sounds) aren't put back.

Asking about an earlier moment needs a branch point there (see "Imagining back at a branch point").

Because this extension includes Reversion, it also has Reversion's other parts, including its replacement of the Perform_Undo routine.

Example: * A Sense of Adventure - Sensing what picking things up would do.

This is the example from Hypothetical Questions, rewritten. After arriving in a room, the player senses whether taking everything there would win, lose or score.

	*: "A Sense of Adventure"

	Include Counterfactuals by Jeff Nyman.

	Use scoring. The maximum score is 5.

	Hallway is a room. "This hall leads east and west. There's also a door to the south."
	Trophy Room is east of the Hallway. "This room is absolutely jam-packed with trophies. The exit is to the west."
	A golden idol is in the Trophy Room. After taking the golden idol for the first time: increase the score by 5; say "Taken."
	Danger Zone is west of the Hallway. "This room is full of various hazards. If you know what's good for you, you'll leave to the east."
	A cursed idol is in the Danger Zone. After taking the cursed idol: say "As you pick up the idol, you feel an evil presence sucking the life force out of your body."; end the story.
	Winners Lounge is south of the Hallway. "This is where winners hang out. A door to the north leads back to the hallway."
	The Mask of Victory is in the Winners Lounge. "A strange mask is hanging on the wall here." After taking the Mask of Victory: say "Taken."; end the story finally.

	To take everything:
		repeat with X running through things in the location:
			try taking X.

	Report going:
		imagine doing take everything;
		if the imagining ran:
			if the imagined story ended finally:
				say "You sense your victory is at hand!";
			otherwise if the imagined story ended:
				say "You sense an ominous presence. Better be careful picking things up in here!";
			otherwise if the imagined score change > 0:
				say "You sense a potential profit. Better grab everything you can!"

	Test me with "w / e / e / get idol / w / s / get mask".

Example: ** The Slow Fuse - Imagining several turns ahead, with the same dice and with fresh ones.

THINK imagines lighting the dynamite and waiting. FORECAST imagines waiting two turns, with the same dice the story will use, so actually waiting twice brings exactly the weather it forecast; GUESS uses fresh dice, so it shows one of the weathers that might come. FORECAST, GUESS and WEATHER take no time. GUESS comes before FORECAST in the test, because every imagining rolls the dice again (see "The dice").

	*: "The Slow Fuse"

	Include Counterfactuals by Jeff Nyman.

	The Quarry is a room. "A dusty quarry floor, with a boulder in the middle."
	The boulder is a scenery supporter in the Quarry. A stick of dynamite is on the boulder.
	The stick of dynamite can be lit or unlit. It is unlit.
	The fuse count is a number that varies.

	Instead of burning the dynamite:
		now the dynamite is lit;
		now the fuse count is 3;
		say "The fuse sputters into life."

	Every turn when the dynamite is lit:
		decrease the fuse count by 1;
		if the fuse count is 0:
			say "The dynamite explodes!";
			if the player encloses the dynamite, end the story saying "You were holding it";
			otherwise now the dynamite is nowhere.

	Instead of thinking:
		imagine burning the dynamite for 4 turns;
		if the imagining ran:
			if the imagined story ended:
				say "If you lit it and waited, you would not live to regret it.";
			otherwise if the imagined output includes "explodes":
				say "If you lit it and waited, it would go off, but you'd be fine.";
			otherwise:
				say "Nothing much would happen."

	The weather is a number that varies.
	Every turn: now the weather is a random number between 1 and 100.

	The weather verdict is a protected slot.
	An imagined outcome rule: set word 0 of the weather verdict to the weather.

	Forecasting is an action out of world. Understand "forecast" as forecasting.
	Carry out forecasting:
		imagine waiting for 2 turns;
		say "In two turns, the weather will be [word 0 of the weather verdict]."

	Guessing is an action out of world. Understand "guess" as guessing.
	Carry out guessing:
		imagine waiting for 2 turns with fresh dice;
		say "In two turns, the weather might be [word 0 of the weather verdict]."

	Checking the weather is an action out of world. Understand "weather" as checking the weather.
	Carry out checking the weather: say "The weather is [the weather]."

	Test me with "think / take dynamite / think / guess / forecast / z / z / weather".

Example: ** Hindsight - Asking what would have happened if the player had acted at the start.

THINK asks what would have happened if the player had taken the vase at the very start and then waited four turns. The answer doesn't depend on what the player has really done since, and asking changes nothing.

	*: "Hindsight"

	Include Counterfactuals by Jeff Nyman.

	The Gallery is a room. "A quiet gallery. A vase stands on a plinth."
	The plinth is a scenery supporter in the Gallery. A vase is on the plinth.
	The guard is a man.

	The start is a checkpoint.
	When play begins: mark the start as a branch point.

	Every turn when the turn count is 4:
		move the guard to the Gallery;
		say "A guard walks in, and glances at the plinth.";
		if the player carries the vase, end the story saying "You were caught red-handed".

	Instead of thinking:
		imagine taking the vase back at the start for 4 turns;
		if the imagining ran:
			if the imagined story ended:
				say "If you had grabbed the vase straight away, the guard would have caught you with it.";
			otherwise:
				say "If you had grabbed the vase straight away, you'd have got away with it."

	Test me with "z / z / z / z / think / take vase / think / i".
