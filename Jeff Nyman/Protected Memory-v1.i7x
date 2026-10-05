Version 1.0 of Protected Memory by Jeff Nyman begins here.

"One block of memory that survives restart, restore and undo, shared by every extension and story that needs it; and two kinds of snapshot: moments, which go there and back, and checkpoints, which can be returned to later."

[How it works. Glulx has one opcode, @protect, that keeps a range of memory as it
is when the story restarts, restores a saved game or undoes a turn. Only one
range can be protected at a time, and protecting a new one silently cancels the
old, so this extension owns the range and shares it out as slots. The range is
protected anew after every restart, restore and undo, but @protect doesn't
outlast the interpreter, so a copy (the mirror) is written into ordinary memory
just before every save, and offered back after a restore.

Which kind of jump just happened is worked out from two ordinary variables, which
the jump itself resets or restores: pm_alive is 0 in a freshly started or
restarted story, and pm_marker says whether the memory image was made by a save,
a checkpoint or a moment (none of those means an undo).]

[Inform 10.2: Basic Inform 10.2 defines the glk object updating rules itself, so
this Include (and the Glk Object Updating extension) can be removed. This extension
will have to be updated when 10.2 becomes a reality becuase I don't know how to
conditionally apply parts of an extension based on the Inform version. The other
alternative is to have a blank Glk Object Updating-v1, but that seems a bit
annoying, not to mention the fact I still don't know how I would detect the version
of Inform being used.]
Include Glk Object Updating by Jeff Nyman.

Part - Slots

Chapter - Declaring slots

A protected slot is a kind of value.
A protected slot has a number called the size. The size of a protected slot is usually 1.
A protected slot has a number called the offset.

[The extension's own bookkeeping, always the first slot:
	0 a magic number, once the block has been set up
	1 a checkpoint file being read, to close after the return
	2 1 if the last moment ran
	3 the checkpoint being returned to
	4-11 the eight checkpoint files
	12 restarts, restores and checkpoint returns so far this session
	13 this session's identity, a random number.]

The protected memory header is a protected slot.
The size of the protected memory header is 14.

Use protected memory size of at least 256 translates as (- Constant PM_WORDS = {N}; -).
Use protected memory size of at least 256. [So the constant always exists; a larger request wins.]

The protected words needed is a number that varies.

To decide which number is the protected memory capacity: (- PM_WORDS -).

To decide whether protected memory is overfull:
	if the protected words needed > the protected memory capacity, yes;
	no.

To lay out the protected slots:
	let A be 0;
	repeat with S running through protected slots:
		now the offset of S is A;
		increase A by the size of S;
	now the protected words needed is A.

Chapter - Reading and writing slots

[Slots hold words: numbers, truth states, times, objects and other values that
fit in one word. Never store text, lists or other values kept on the heap: the
heap isn't protected, so they would point at garbage after a restart.]

To decide which number is word (N - a number) of (S - a protected slot):
	if N < 0 or N >= the size of S or protected memory is overfull, decide on 0;
	let A be the offset of S;
	increase A by N;
	decide on the protected word A.

To set word (N - a number) of (S - a protected slot) to (V - a number):
	if N < 0 or N >= the size of S or protected memory is overfull, stop;
	let A be the offset of S;
	increase A by N;
	set the protected word A to V.

To clear (S - a protected slot):
	repeat with N running from 0 to the size of S - 1:
		set word N of S to 0.

To decide whether (S - a protected slot) is blank:
	repeat with N running from 0 to the size of S - 1:
		if word N of S is not 0, no;
	yes.

[Turning other one-word values into words and back.]
To decide which number is (V - a value) as a word: (- {V} -).
To decide which K is (N - a number) as a/an (name of kind of value K): (- {N} -).

To decide which number is the protected word (A - a number): (- (pm_block-->{A}) -).
To set the protected word (A - a number) to (V - a number): (- pm_block-->{A} = {V}; -).
To decide which number is the mirrored word (A - a number): (- (pm_mirror-->{A}) -).

Part - Time Jumps

A time jump is a kind of value.
The time jumps are session start, story restart, save restore, player undo, checkpoint return and moment return.

The latest time jump is a time jump that varies.

[Run after each jump, once the memory is safe. Rules for a session start or a
story restart run before the story's window opens, so they shouldn't print
anything: use "when play begins" for that.]
The time jump rules are a time jump based rulebook.

To decide which time jump is the detected time jump: (- (PM_Detect()) -).

To protect the protected memory: (- PM_Protect(); -).
To mark protected memory as recovered: (- pm_alive = 1; pm_marker = 0; -).

To recover protected memory:
	let J be the detected time jump;
	lay out the protected slots;
	protect the protected memory;
	if J is session start or word 0 of the protected memory header is not the protected memory magic number:
		repeat with A running from 0 to the protected memory capacity - 1:
			set the protected word A to 0;
		set word 0 of the protected memory header to the protected memory magic number;
		set word 13 of the protected memory header to a random number between 1 and 30000;
	mark protected memory as recovered;
	if J is save restore, reconcile the protected slots;
	if J is story restart or J is save restore or J is checkpoint return:
		set word 12 of the protected memory header to (word 12 of the protected memory header) + 1;
	if J is checkpoint return:
		note the checkpoint returned to;
	otherwise:
		forget the checkpoint returned to;
	now the latest time jump is J;
	follow the time jump rules for J.

To decide which number is the protected memory magic number: (- PM_MAGIC -).

Part - Saved Games

Chapter - The mirror

To copy protected memory to the mirror: (- PM_CopyToMirror(); -).
To mark protected memory as being saved: (- pm_marker = 1; -).
To mark protected memory as not being saved: (- pm_marker = 0; -).

First carry out saving the game (this is the mirror protected memory before saving rule):
	copy protected memory to the mirror;
	mark protected memory as being saved.

Carry out saving the game (this is the stop marking protected memory as saved rule):
	mark protected memory as not being saved.

The stop marking protected memory as saved rule is listed after the save the game rule in the carry out saving the game rules.

Chapter - Reconciling after a restore

[After a restore, each slot's owner decides between the protected copy (what the
story remembers from this session) and the saved copy (what was protected when
the game was saved). A rule that decides says "adopt the saved copy of (slot)"
or "keep the current copy of (slot)". If no rule decides, the saved copy is
adopted if the current copy is blank, or if the saved game came from another
session and this one is fresh (nothing has been restarted, restored or returned
to yet); otherwise the current copy wins.]

The reconciling rules are a protected slot based rulebook.

The reconciliation decided is a truth state that varies.

To decide which number is saved word (N - a number) of (S - a protected slot):
	if N < 0 or N >= the size of S or protected memory is overfull, decide on 0;
	let A be the offset of S;
	increase A by N;
	decide on the mirrored word A.

To decide whether protected memory came with the saved game:
	if the mirrored word 0 is the protected memory magic number, yes;
	no.

To adopt the saved copy of (S - a protected slot):
	repeat with N running from 0 to the size of S - 1:
		set word N of S to saved word N of S;
	now the reconciliation decided is true.

To keep the current copy of (S - a protected slot):
	now the reconciliation decided is true.

[Whether the game just restored was saved in an earlier session (or another
interpreter), rather than earlier in this one.]
To decide whether the saved game came from another session:
	if saved word 13 of the protected memory header is word 13 of the protected memory header, no;
	yes.

[A session is fresh until its first restart, restore or return to a checkpoint.]
To decide whether protected memory is fresh:
	if word 12 of the protected memory header is 0, yes;
	no.

To reconcile the protected slots:
	if protected memory is overfull, stop;
	unless protected memory came with the saved game, stop;
	repeat with S running through protected slots:
		if S is not the protected memory header:
			now the reconciliation decided is false;
			follow the reconciling rules for S;
			if the reconciliation decided is false:
				if S is blank:
					adopt the saved copy of S;
				otherwise if protected memory is fresh and the saved game came from another session:
					adopt the saved copy of S.

Part - Checkpoints

[A checkpoint is a snapshot of the whole story, kept in a temporary file, that the
story can return to later. Returning to it restores everything except protected
memory, so the story continues from the moment the checkpoint was taken (just
after the "take checkpoint" phrase), but remembers what happened since. Up to
eight checkpoints; taking one again replaces it. They last for the session.]

A checkpoint is a kind of value.

To take checkpoint (C - a checkpoint): (- PM_TakeCheckpoint({C}); -).

[The same, as a value: 1 when the checkpoint has just been taken, 2 on
returning to it later, 0 if it couldn't be taken. Unlike "was just returned
to", this can't be confused by an earlier return in the same turn.]
To decide which number is the result of taking checkpoint (C - a checkpoint): (- (PM_TakeCheckpoint({C})) -).
To return to checkpoint (C - a checkpoint): (- PM_ReturnToCheckpoint({C}); -).
To discard checkpoint (C - a checkpoint): (- PM_DiscardCheckpoint({C}); -).
To decide whether checkpoint (C - a checkpoint) is available: (- (PM_CheckpointFile({C}) ~= 0) -).

[True from a return to that checkpoint until the next command is read.]
To decide whether checkpoint (C - a checkpoint) was just returned to: (- (pm_returned_to == {C}) -).

To note the checkpoint returned to: (- pm_returned_to = pm_block-->3; pm_block-->3 = 0; -).
To forget the checkpoint returned to: (- pm_returned_to = 0; -).

This is the forget the last checkpoint return rule:
	forget the checkpoint returned to.

The forget the last checkpoint return rule is listed before the parse command rule in the turn sequence rules.

Part - Moments

[A moment runs a phrase, then a rule that judges what happened, and then puts the
whole story back as it was. Only protected memory keeps anything from the moment,
so the judging rule writes its findings into a slot. The phrase's output is
captured, not shown; the judging rule can say "[the moment's output]". Moments
use the same random numbers that the story will then use, so a moment that tries
something sees what really would happen if it were tried next. Moments can't be
nested, and shouldn't save, restore, restart or take checkpoints.]

To momentarily (ph - a phrase) and then follow (R - a rule): (-
	if (PM_MomentStart()) { {ph}; PM_MomentEnd({R}); }
-).

To decide whether the last moment ran: (- (pm_block-->2 == 1) -).

[True while a moment is running. Anything written into protected memory during a
moment stays, which is how a moment reports back; but a slot that counts things
the story really does (lived time, say) should skip its writes during one.]
To decide whether a moment is happening: (- (pm_in_moment == 1) -).
To decide whether no moment is happening: (- (pm_in_moment == 0) -).

To say the moment's output: (- PM_PrintCapture(); -).
To decide which number is the length of the moment's output: (- (pm_capture_len) -).
To decide which number is character (N - a number) of the moment's output: (- (PM_CaptureChar({N})) -).

[Moments normally see the same random numbers the story will go on to use. This
makes the next moment (only) use different ones, so it sees one of the things
that might happen rather than the thing that will.]
To use fresh dice for the next moment: (- pm_fresh_dice = 1; -).

Use moment output length of at least 1024 translates as (- Constant PM_CAPTURE_CHARS = {N}; -).
Use moment output length of at least 1024.

Part - Recovery Hooks

Section - Glulx (for Glulx only)

To decide whether protected memory is available: (- (PM_Available()) -).

First glk object updating rule (this is the recover protected memory rule):
	recover protected memory.

Include (-
Constant PM_MAGIC = $504D454D;
Constant PM_ROCK = 1501;
Constant PM_CHECKPOINTS = 8;

Array pm_block --> PM_WORDS;
Array pm_mirror --> PM_WORDS;
Array pm_capture --> PM_CAPTURE_CHARS;

Global pm_alive = 0;
Global pm_marker = 0;		! 1 saving, 2 taking a checkpoint, 3 starting a moment
Global pm_returned_to = 0;
Global pm_in_moment = 0;
Global pm_capture_prev = 0;
Global pm_capture_len = 0;
Global pm_fresh_dice = 0;

[ PM_Available;
	rtrue;
];

[ PM_Protect len;
	len = PM_WORDS * WORDSIZE;
	@protect pm_block len;
];

[ PM_Detect;
	if (pm_alive == 0) {
		if (pm_block-->0 ~= PM_MAGIC) return 1;	! session start
		return 2;					! story restart
	}
	switch (pm_marker) {
		1: return 3;				! save restore
		2: return 5;				! checkpoint return
		3: return 6;				! moment return
	}
	return 4;					! player undo
];

[ PM_CopyToMirror i;
	for (i=0 : i<PM_WORDS : i++) pm_mirror-->i = pm_block-->i;
];

[ PM_CheckpointFile c;
	if (c < 1 || c > PM_CHECKPOINTS) return 0;
	return pm_block-->(3+c);
];

[ PM_DiscardCheckpoint c fref;
	fref = PM_CheckpointFile(c);
	if (fref == 0) return;
	glk_fileref_delete_file(fref);
	glk_fileref_destroy(fref);
	pm_block-->(3+c) = 0;
];

! Returns 1 once the checkpoint is taken, 2 on returning to it, 0 on failure.
[ PM_TakeCheckpoint c fref str res;
	if (c < 1 || c > PM_CHECKPOINTS) return 0;
	PM_DiscardCheckpoint(c);
	fref = glk_fileref_create_temp(fileusage_SavedGame + fileusage_BinaryMode, PM_ROCK);
	if (fref == 0) return 0;
	str = glk_stream_open_file(fref, filemode_Write, PM_ROCK);
	if (str == 0) { glk_fileref_destroy(fref); return 0; }
	pm_block-->(3+c) = fref;
	PM_CopyToMirror();
	pm_marker = 2;
	@save str res;
	if (res == -1) {
		! Back from PM_ReturnToCheckpoint: close the file it read from.
		glk_stream_close(pm_block-->1, 0);
		pm_block-->1 = 0;
		GGRecoverObjects();
		return 2;
	}
	pm_marker = 0;
	glk_stream_close(str, 0);
	if (res ~= 0) { PM_DiscardCheckpoint(c); return 0; }
	return 1;
];

! Doesn't return if it succeeds.
[ PM_ReturnToCheckpoint c fref str res;
	fref = PM_CheckpointFile(c);
	if (fref == 0) return 0;
	str = glk_stream_open_file(fref, filemode_Read, PM_ROCK);
	if (str == 0) return 0;
	pm_block-->1 = str;
	pm_block-->3 = c;
	@restore str res;
	glk_stream_close(str, 0);
	pm_block-->1 = 0;
	pm_block-->3 = 0;
	return 0;
];

! Returns 1 to run the moment, 0 if it can't run or has just been undone.
[ PM_MomentStart rv seed strtbl iosys iorock;
	if (pm_in_moment) return 0;
	pm_block-->2 = 0;
	do { @random 0 seed; } until (seed ~= 0);
	@getstringtbl strtbl;
	@getiosys iosys iorock;
	pm_marker = 3;
	@saveundo rv;
	@setrandom seed;
	@setstringtbl strtbl;
	@setiosys iosys iorock;
	if (rv == -1) {
		pm_fresh_dice = 0;
		GGRecoverObjects();
		return 0;
	}
	pm_marker = 0;
	if (rv ~= 0) { pm_fresh_dice = 0; return 0; }
	if (pm_fresh_dice) {
		pm_fresh_dice = 0;
		@setrandom 0;
	}
	pm_in_moment = 1;
	pm_capture_prev = glk_stream_get_current();
	glk_stream_set_current(glk_stream_open_memory_uni(pm_capture, PM_CAPTURE_CHARS, filemode_Write, 0));
	return 1;
];

[ PM_MomentEnd rule save_sp res;
	glk_stream_close(glk_stream_get_current(), gg_arguments);
	pm_capture_len = gg_arguments-->1;
	if (pm_capture_len > PM_CAPTURE_CHARS) pm_capture_len = PM_CAPTURE_CHARS;
	glk_stream_set_current(pm_capture_prev);
	save_sp = say__p; say__p = 0;
	FollowRulebook(rule);
	if (say__p == false) say__p = save_sp;
	pm_block-->2 = 1;
	@restoreundo res;
	print "[Protected Memory: the moment could not be undone.]^";
];

[ PM_CaptureChar i;
	if (i < 0 || i >= pm_capture_len) return 0;
	return pm_capture-->i;
];

[ PM_PrintCapture i ch;
	for (i=0 : i<pm_capture_len : i++) {
		ch = pm_capture-->i;
		@streamunichar ch;
	}
];
-).

Section - Z-machine (for Z-machine only)

[The Z-machine can't protect memory, so the block is ordinary memory, nothing
survives a restart, restore or undo, and moments and checkpoints do nothing.]

To decide whether protected memory is available: no.

First when play begins (this is the start protected memory rule):
	recover protected memory.

Include (-
Constant PM_MAGIC = $504D;
Constant PM_CHECKPOINTS = 8;
Array pm_block --> PM_WORDS;
Array pm_mirror --> PM_WORDS;
Global pm_alive = 0;
Global pm_marker = 0;
Global pm_returned_to = 0;
Global pm_capture_len = 0;
Global pm_fresh_dice = 0;
Global pm_in_moment = 0;
[ PM_Protect; ];
[ PM_Detect; if (pm_alive == 0) return 1; return 4; ];
[ PM_CopyToMirror i; for (i=0 : i<PM_WORDS : i++) pm_mirror-->i = pm_block-->i; ];
[ PM_CheckpointFile c; c = 0; return 0; ];
[ PM_DiscardCheckpoint c; c = 0; ];
[ PM_TakeCheckpoint c; c = 0; return 0; ];
[ PM_ReturnToCheckpoint c; c = 0; return 0; ];
[ PM_MomentStart; return 0; ];
[ PM_MomentEnd rule; rule = 0; ];
[ PM_PrintCapture; ];
[ PM_CaptureChar i; i = 0; return 0; ];
-).

Part - Problems

When play begins (this is the report protected memory problems rule):
	if protected memory is overfull:
		say "[bracket]Protected Memory: the protected slots need [protected words needed] words, but there are only [protected memory capacity]. Add 'Use protected memory size of at least [protected words needed].'[close bracket][paragraph break]".

Protected Memory ends here.

---- DOCUMENTATION ----

Some stories need to remember things that the story itself forgets: a character who remembers earlier attempts after the story restarts, a count of how many times the player has used UNDO, the result of trying something out and taking it back. Glulx can do this with one opcode, @protect, which keeps a range of memory as it is through a restart, a restore and an undo. But only one range can be protected at a time, so two extensions that each protect their own will silently break each other.

Protected Memory owns that range and shares it out. It also provides two kinds of snapshot (moments and checkpoints), tells the story whenever time has jumped, and saves a copy of the protected memory with every saved game.

It is for Glulx. On the Z-machine it compiles, but protected memory is ordinary memory, and moments and checkpoints do nothing; "if protected memory is available" tells the story which.

Section: Slots

Declare a slot, with its size in words:

	The loop memory is a protected slot. The size of the loop memory is 65.

A slot's size is 1 unless it says otherwise. Read and write it a word at a time:

	word 0 of the loop memory
	set word 1 of the loop memory to 7;
	clear the loop memory;
	if the loop memory is blank, ...

Words count from 0. Reading or writing outside the slot does nothing (and reads 0).

A word can hold anything that fits in a word: a number, a truth state, a time, an object, or a value of an enumerated kind. Turn these into words and back with "as a word" and "as a (kind)":

	set word 2 of the loop memory to the location as a word;
	let R be (word 2 of the loop memory) as a room;

Never store text, lists, tables of text or other values kept on the heap. The heap isn't protected, so after a restart the word would point at garbage.

The block holds 256 words by default, of which the extension uses 14. For more:

	Use protected memory size of at least 1024.

If the slots need more than there is, the story says so when play begins.

Section: Time jumps

After every jump, the "time jump rules" run for one of these:

	session start: the interpreter has just started the story;
	story restart: the story has restarted (RESTART, or a restart from the story);
	save restore: a saved game has been restored;
	player undo: the player has typed UNDO;
	checkpoint return: the story has returned to a checkpoint;
	moment return: a moment has just ended.

For example:

	Time jump for player undo:
		increase word 0 of the undo count by 1.

"The latest time jump" is the most recent one. Rules for a session start and a story restart run before the story's window opens, so they shouldn't print; use "when play begins" for that.

Section: Saved games

Protected memory isn't part of a saved game, so a copy (the mirror) is written into the saved game just before each save. When a saved game is restored, each slot's owner can choose between the protected copy (what this session remembers) and the saved copy, with reconciling rules:

	Reconciling the loop memory:
		if saved word 1 of the loop memory > word 1 of the loop memory:
			adopt the saved copy of the loop memory;
		otherwise:
			keep the current copy of the loop memory.

"Saved word N of (slot)" reads the saved copy. Two conditions help decide: "if the saved game came from another session" (an earlier run of the interpreter, rather than earlier in this one), and "if protected memory is fresh" (true until the session's first restart, restore or return to a checkpoint).

If no rule decides, the saved copy is adopted when the protected copy is blank, or when the saved game came from another session and this one is still fresh; otherwise the protected copy is kept. So by default, whatever the story remembers survives loading an earlier save from the same session, and the first saved game restored in a new session brings its memories with it.

Section: Checkpoints

A checkpoint is a snapshot of the whole story that can be returned to later. Declare them as values:

	The start of the night is a checkpoint.

Then:

	take checkpoint the start of the night;
	if checkpoint the start of the night is available, ...
	return to checkpoint the start of the night;
	discard checkpoint the start of the night;

Returning puts everything back as it was when the checkpoint was taken, except protected memory, and the story carries on from just after the "take checkpoint" phrase. To tell a return from the first time through:

	take checkpoint the start of the night;
	if checkpoint the start of the night was just returned to:
		say "You are back at the start of the night.";

That stays true until the next command is read. Code that may take a checkpoint more than once in a turn should use the result instead:

	let R be the result of taking checkpoint the start of the night;
	if R is 2, say "Back again.";

which is 1 when the checkpoint has just been taken, 2 on returning to it, and 0 if it couldn't be taken. The time jump rules also run, for a checkpoint return.

Up to eight checkpoints can be declared and kept (a ninth can't be taken, and is never available); taking one again replaces it. They are kept in temporary files and last until the interpreter quits, so they don't survive into a new session. They are separate from the player's UNDO: returning to a checkpoint doesn't use up undo, and UNDO doesn't remove checkpoints.

Section: Moments

A moment tries something out and then takes it back:

	momentarily try drinking the poison and then follow the judge the poison rule;

This runs "try drinking the poison", then the judge the poison rule, and then puts the whole story back as it was. Nothing the phrase or the rule did remains, except what the rule wrote into protected memory, so that is how the rule reports back:

	The poison verdict is a protected slot.

	This is the judge the poison rule:
		if the story has ended, set word 0 of the poison verdict to 1;
		otherwise set word 0 of the poison verdict to 0.

	Instead of drinking the poison for the first time:
		momentarily try drinking the poison and then follow the judge the poison rule;
		if the last moment ran and word 0 of the poison verdict is 1:
			say "Something tells you not to." instead;
		continue the action.

What the phrase prints is captured rather than shown; the judging rule can look at it with "[the moment's output]" (the first 1024 characters, or more with "Use moment output length of at least 2048"). What the judging rule prints is shown.

"If the last moment ran" is false if the moment couldn't run: on the Z-machine, in an interpreter without undo, or inside another moment (they can't be nested).

A moment uses the same random numbers that the story then goes on to use, so it sees what really would happen if the same thing were tried next. To see one of the things that might happen instead, say "use fresh dice for the next moment" just before it. Either way, each moment chooses new random numbers for the story as well (Glulx can't read the generator's state, only set it), so what one moment saw stays true only until the next moment.

"The length of the moment's output" and "character N of the moment's output" give the captured text a character at a time (as Unicode code points), for copying it into a slot. A moment uses one of the interpreter's undo states for an instant and gives it back, so the player's UNDO is unaffected.

Everything written into protected memory during a moment stays, not only what the judging rule writes. So a slot that keeps count of something the story really does (turns lived, UNDOs used) should leave it alone while "a moment is happening":

	Every turn when no moment is happening:
		set word 0 of the lived time to (word 0 of the lived time) + 1. A moment shouldn't save, restore, restart, or take or return to checkpoints.

Example: * Second Thoughts - A slot that counts UNDOs, a checkpoint to return to, and a moment that tries a door.

	*: "Second Thoughts"

	Include Protected Memory by Jeff Nyman.

	The second thoughts is a protected slot. The size of the second thoughts is 2.

	Time jump for player undo:
		set word 0 of the second thoughts to (word 0 of the second thoughts) + 1.

	The Landing is a room. "A narrow landing. A door leads north, and a bell rope hangs by it."
	The Tower is a room. "Wind howls through the empty tower."
	The heavy door is a door. It is north of the Landing and south of the Tower. It is closed, openable, lockable and locked.
	The player carries an iron key. The iron key unlocks the heavy door.
	The bell rope is in the Landing. It is fixed in place.

	The top of the stairs is a checkpoint.

	When play begins:
		take checkpoint the top of the stairs;
		if checkpoint the top of the stairs was just returned to:
			say "You find yourself at the top of the stairs again, and you remember everything.";
			set word 1 of the second thoughts to (word 1 of the second thoughts) + 1.

	Instead of pulling the bell rope:
		say "The bell tolls, and the world folds back on itself.";
		return to checkpoint the top of the stairs.

	The door verdict is a protected slot.

	This is the judge the door rule:
		if the player is in the Tower, set word 0 of the door verdict to 1;
		otherwise set word 0 of the door verdict to 0.

	Instead of examining the heavy door:
		momentarily try going north and then follow the judge the door rule;
		if the last moment ran and word 0 of the door verdict is 1:
			say "It looks like it would open easily.";
		otherwise:
			say "It looks stuck."

	Every turn: say "(UNDOs so far: [word 0 of the second thoughts]; returns: [word 1 of the second thoughts])".

	Test me with "x door / unlock door with key / x door / n / s / pull rope / x door".

Examining the door tries going north for a moment: at first the door is locked, so the moment can't get through, but once it's unlocked, the moment reaches the Tower (opening the door on the way), and examining the door says so, while the player stays on the Landing. Pulling the bell rope returns to the checkpoint taken when play began, with the door locked again but the count of returns remembered. A test script stops at a return to a checkpoint, since the script's own place is rewound too, so the last command has to be typed by hand. (A test script can't contain UNDO, so try that by hand: the UNDO count survives the undos themselves.)