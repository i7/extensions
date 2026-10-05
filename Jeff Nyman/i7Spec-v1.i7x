Version 1.0 of i7Spec (for Glulx only) by Jeff Nyman begins here.

"Scenarios in Given/When/Then style for testing a story: each sets up the world, types commands and checks what they print, and each starts from the same state, because the world is put back after every scenario."

"based on Simple Unit Tests by Dannii Willis and Command Unit Testing by Xavid"

Include Protected Memory by Jeff Nyman.

Use authorial modesty.

[How it works. RUN SPECS takes a Protected Memory checkpoint of the world, the
baseline. Each scenario runs its Given code at once and queues its When commands
and Then checks; the commands are then typed for the player, one a turn, their
output captured, and each Then compared with the output of the When before it.
When the queue is empty, the story returns to the baseline checkpoint, which
puts the whole world back, and the next scenario starts from there. The counts
live in protected memory, so they survive the return; everything printed stays
on the screen.]

Part - Specs - Not For Release

Chapter - Scenarios

A scenario is a kind of value.

[A kind with no values can't be typed by the player or repeated through, so a
story that hasn't declared any scenarios yet wouldn't compile. This value keeps
the kind from being empty; it comes first, and is never run.]
The i7Spec placeholder is a scenario.

The scenario rules are a scenario based rulebook.

The spec baseline is a checkpoint.

[Words of the spec record:
	0 1 while scenarios are being run
	1 how many scenarios are to run (1 for RUN SPEC, all for RUN SPECS)
	2 the scenario to run alone, by its position (1 for the first declared), or 0
	  for all
	3 how many scenarios have started
	4 expectations checked
	5 expectations passed
	6 scenarios with a failure
	7 1 if the current scenario has failed
	8 how many failed scenarios are listed below
	9-40 the failed scenarios, by position.
Scenarios are handled by position rather than as values, because the rulebook
named "scenario rules" stops Inform reading "scenario" as a kind in some phrases.]
The spec record is a protected slot. The size of the spec record is 41.

Chapter - Writing a Scenario

To given (T - text):
	say "[bold type]Given[roman type] [T][line break]".

To when (C - text):
	add 1 to the spec queue kinds;
	add C to the spec queue texts;
	add the spec placeholder rule to the spec queue rules.

To then the output is (T - text):
	add 2 to the spec queue kinds;
	add T to the spec queue texts;
	add the spec placeholder rule to the spec queue rules.

To then the output includes (T - text):
	add 3 to the spec queue kinds;
	add T to the spec queue texts;
	add the spec placeholder rule to the spec queue rules.

To then (R - a rule) holds:
	add 4 to the spec queue kinds;
	add "" to the spec queue texts;
	add R to the spec queue rules.

This is the spec placeholder rule:
	do nothing.

Chapter - The Queue

[One entry for each When or Then, in order: kind 1 a command, 2 an exact
output, 3 a part of the output, 4 a rule that must succeed.]
The spec queue kinds is a list of numbers that varies.
The spec queue texts is a list of texts that varies.
The spec queue rules is a list of rules that varies.

The latest spec output is a text that varies.
The spec output overflow is a truth state that varies.
The spec command running is a truth state that varies.

To remove the first spec queue entry:
	remove entry 1 from the spec queue kinds;
	remove entry 1 from the spec queue texts;
	remove entry 1 from the spec queue rules.

Chapter - Running Scenarios

Running the specs is an action out of world.
Understand "run specs" or "run scenarios" or "spec tests" as running the specs.

Running one spec is an action out of world applying to one scenario.
Understand "run spec [scenario]" or "run scenario [scenario]" as running one spec.

Carry out running the specs (this is the run every scenario rule):
	start running scenarios, every one.

Carry out running one spec (this is the run one scenario rule):
	let P be 0;
	let I be 0;
	repeat with T running through scenarios:
		increment I;
		if T is the scenario understood, now P is I;
	if P is 1:
		say "That's i7Spec's own placeholder, not one of your scenarios." (A);
		stop the action;
	start running scenarios from position P.

To start running scenarios, every one:
	start running scenarios from position 0.


[The baseline is taken here; every scenario ends by returning to it, which
comes back to just after "the result of taking checkpoint", below, with the
counts in protected memory telling which scenario is next.]
To start running scenarios from position (W - a number):
	if word 0 of the spec record is 1, stop;
	clear the spec record;
	set word 0 of the spec record to 1;
	set word 2 of the spec record to W;
	let R be the result of taking checkpoint the spec baseline;
	if R is 0:
		say "[bold type]i7Spec can't run:[roman type] this interpreter can't take a checkpoint.";
		clear the spec record;
		stop;
	run the next scenario.

To run the next scenario:
	let W be word 2 of the spec record;
	let N be word 3 of the spec record;
	let the next be 0;
	if W is not 0:
		if N is 0, now the next is W;
	otherwise:
		now the next is N + 2; [position 1 is the placeholder]
	let the count be 0;
	repeat with T running through scenarios:
		increment the count;
	if the next is 0 or the next > the count:
		finish running scenarios;
		stop;
	set word 3 of the spec record to N + 1;
	set word 7 of the spec record to 0;
	truncate the spec queue kinds to 0 entries;
	truncate the spec queue texts to 0 entries;
	truncate the spec queue rules to 0 entries;
	now the latest spec output is "";
	let I be 0;
	repeat with S running through scenarios:
		increment I;
		if I is the next:
			say "[line break][bold type]Scenario:[roman type] [S][line break]";
			follow the scenario rules for S.

To finish running scenarios:
	let C be word 4 of the spec record;
	let P be word 5 of the spec record;
	let N be word 3 of the spec record;
	if N is 0:
		say "[line break]There are no scenarios to run.[line break]";
		discard checkpoint the spec baseline;
		clear the spec record;
		stop;
	say "[line break][bold type]Results:[roman type] [P] of [C] expectation[s] passed, in [N] scenario[s].";
	if word 6 of the spec record > 0:
		say "[line break]Failed: ";
		let F be word 8 of the spec record;
		repeat with I running from 1 to F:
			let K be I + 8;
			say "[scenario at position (word K of the spec record)][if I < F], [end if]";
		say ".";
	say line break;
	discard checkpoint the spec baseline;
	clear the spec record.

[A scenario is over when its queue is empty: count it, then go back to the
baseline, which carries on with the next scenario.]
To end the scenario:
	if word 7 of the spec record is 1:
		set word 6 of the spec record to (word 6 of the spec record) + 1;
		let F be word 8 of the spec record;
		if F < 32:
			let K be F + 9;
			let W be (word 3 of the spec record) + 1;
			if word 2 of the spec record is not 0, now W is word 2 of the spec record;
			set word K of the spec record to W;
			set word 8 of the spec record to F + 1;
	return to checkpoint the spec baseline.

To say scenario at position (N - a number):
	let I be 0;
	repeat with S running through scenarios:
		increment I;
		if I is N, say "[S]".

Chapter - Typing the Commands

Rule for reading a command when the spec queue kinds is not empty and entry 1 of the spec queue kinds is 1 (this is the type the next spec command rule):
	let C be entry 1 of the spec queue texts;
	remove the first spec queue entry;
	say "[bold type]When[roman type] [italic type][C][roman type][line break]";
	change the text of the player's command to C;
	now the spec command running is true;
	start spec-capturing text.

[Before the next command: finish the last one's output, then check every Then
that follows it. If nothing is left, the scenario is over.]
First before reading a command when word 0 of the spec record is 1 (this is the check the spec expectations rule):
	if the spec command running is true:
		now the spec command running is false;
		stop spec-capturing text;
		let T be "[the spec-captured text]";
		[Commands' output begins and ends with line breaks that are only spacing.]
		replace the regular expression "^\n+" in T with "";
		replace the regular expression "\n+$" in T with "";
		now the latest spec output is T;
		now the spec output overflow is whether or not the spec capture overflowed;
		say "[T][paragraph break]";
	while the spec queue kinds is not empty and entry 1 of the spec queue kinds is not 1:
		let K be entry 1 of the spec queue kinds;
		let X be entry 1 of the spec queue texts;
		let R be entry 1 of the spec queue rules;
		remove the first spec queue entry;
		check expectation K about X and R;
	if the spec queue kinds is empty, end the scenario.

To check expectation (K - a number) about (X - a text) and (R - a rule):
	set word 4 of the spec record to (word 4 of the spec record) + 1;
	let passed be false;
	if K is 2:
		if the latest spec output exactly matches the text X, now passed is true;
	otherwise if K is 3:
		if the latest spec output matches the text X, now passed is true;
	otherwise:
		follow R;
		if rule succeeded, now passed is true;
	if passed is true:
		set word 5 of the spec record to (word 5 of the spec record) + 1;
		if K is 4, say "[bold type]Then[roman type] [R] holds: passed.[line break]";
		otherwise say "[bold type]Then[roman type] the output [if K is 2]is[otherwise]includes[end if] '[X]': passed.[line break]";
	otherwise:
		set word 7 of the spec record to 1;
		if K is 4:
			say "[bold type]Then[roman type] [R] holds: FAILED.[line break]";
		otherwise:
			let shown be the latest spec output;
			replace the text "[line break]" in shown with "[bracket]line break[close bracket]";
			let wanted be X;
			replace the text "[line break]" in wanted with "[bracket]line break[close bracket]";
			say "[bold type]Then[roman type] the output [if K is 2]is[otherwise]includes[end if] '[wanted]': FAILED. The output was '[shown]'.[if the spec output overflow is true] (It was cut short: see 'Use maximum spec-capture buffer length'.)[end if][line break]".

[A command that ends the story doesn't end the run: the scenario carries on, and
then the baseline puts the story back.]
When play ends when word 0 of the spec record is 1 (this is the keep running scenarios after an ending rule):
	resume the story.

Part - Text Capturing - Not For Release

Use maximum spec-capture buffer length of at least 4096 translates as (- Constant SPEC_CAPTURE_BUFFER_LEN = {N}; -).
Use maximum spec-capture buffer length of at least 4096. [So the constant always exists; a larger request wins.]

To start spec-capturing text: (- StartSpecCapture(); -).
To stop spec-capturing text: (- EndSpecCapture(); -).
To say the/-- spec-captured text: (- PrintSpecCapture(); -).
To decide whether the spec capture overflowed: (- (spec_capture_overflowed == 1) -).

Include (-
Global spec_capture_active = 0;
Global spec_capture_overflowed = 0;
Array spec_captured_text --> (SPEC_CAPTURE_BUFFER_LEN + 1);
Global text_spec_capture_old_stream = 0;
Global text_spec_capture_new_stream = 0;

[ StartSpecCapture;
	if (spec_capture_active == 1) return;
	spec_capture_active = 1;
	text_spec_capture_old_stream = glk_stream_get_current();
	text_spec_capture_new_stream = glk_stream_open_memory_uni(spec_captured_text + WORDSIZE, SPEC_CAPTURE_BUFFER_LEN, 1, 0);
	glk_stream_set_current(text_spec_capture_new_stream);
];

[ EndSpecCapture len;
	if (spec_capture_active == 0) return;
	spec_capture_active = 0;
	glk_stream_set_current(text_spec_capture_old_stream);
	glk_stream_close(text_spec_capture_new_stream, gg_arguments);
	len = gg_arguments-->1;
	spec_capture_overflowed = 0;
	if (len > SPEC_CAPTURE_BUFFER_LEN) { len = SPEC_CAPTURE_BUFFER_LEN; spec_capture_overflowed = 1; }
	spec_captured_text-->0 = len;
];

[ PrintSpecCapture len i;
	len = spec_captured_text-->0;
	for (i = 0 : i < len : i++) glk_put_char_uni(spec_captured_text-->(i + 1));
];
-).

i7Spec ends here.

---- DOCUMENTATION ----

Inform's TEST command plays a sequence of commands, but doesn't check what they print. i7Spec does: you write scenarios, each of which sets up the world, types commands, and checks what they print. Every scenario starts from the same state, because the world is put back after each one, so scenarios can't spoil each other.

It's for testing only: none of it is in a released story. It needs Glulx, and the Protected Memory extension (which it includes).

Chapter: Writing scenarios

Name each scenario, and give it a rule:

	The coin pickup is a scenario.

	Scenario for the coin pickup:
		given "the coin is on the floor";
		now the coin is in the Lab;
		when "take coin";
		then the output is "Taken.";
		when "inventory";
		then the output includes "a coin".

A scenario's name mustn't read like an action: "Taking the coin is a scenario" would be taken as a statement about the action of taking the coin. Nouns are safe: "the coin pickup", "the locked door test".

The three steps:

	given "(description)" names the setup. The lines after it are ordinary Inform: they change the world before any command is typed.
	when "(command)" types a command, as if the player had.
	then ... checks what the command before it printed.

The checks:

	then the output is "(text)": the whole output, exactly.
	then the output includes "(text)": somewhere in the output.
	then (a rule) holds: the rule succeeds when it runs, after the commands before it. For checking the world rather than the text:

	This is the coin is carried rule:
		if the player carries the coin, rule succeeds;
		rule fails.

	...
		then the coin is carried rule holds.

A "then" checks the output of the "when" just before it, and any number of "then"s can follow one "when". Everything in a scenario rule runs at once, before any command is typed, so a check on the world has to be a rule: "if the player carries the coin" written in the scenario itself would be decided before TAKE COIN had happened.

In an exact output, a line break is written "[line break]":

	then the output is "You are carrying:[line break]  a coin".

Chapter: Running scenarios

	RUN SPECS (or RUN SCENARIOS, SPEC TESTS): every scenario, in the order they were declared.
	RUN SPEC (scenario) (or RUN SCENARIO ...): just one.

They begin from the world as it is when you type the command; each scenario starts from that same state, and afterwards the world is put back to it. The report shows each scenario's steps and output, every check as passed or FAILED (with what was printed instead), and at the end how many checks passed and which scenarios failed.

A command that ends the story doesn't end the run: the scenario carries on, and the next one starts from the same state as ever.

Chapter: Limits

Each command's output is captured up to 4096 characters. A failure on longer output says it was cut short; for more:

	Use maximum spec-capture buffer length of at least 16384.

The world is put back with a Protected Memory checkpoint, so i7Spec uses one of its eight checkpoints.

The extension declares one scenario of its own, "the i7Spec placeholder", which is never run. It's there because Inform can't compile a kind with no values, so without it a story that hadn't declared any scenarios yet wouldn't compile. Running scenarios leaves the player's UNDO states from inside them behind, so don't rely on UNDO just after a run.

Chapter: Changes from version 1

(1) Each scenario is named and starts from the same state: the world is put back after every one. Version 1 ran all its scenarios in one world, one after another, and its setup and teardown phrases needed Undo Output Control, which it didn't include, so it didn't compile without it.

(2) Given, when and then replace context, condition, do and verify that. Checks can be exact ("is"), partial ("includes") or a rule.

(3) RUN SPEC (scenario) runs one scenario; failed scenarios are listed by name.

(4) Output is captured up to 4096 characters (256 before), and a failure on output that was cut short says so.

(5) It compiles on Inform 10.2 as well as 10.1.

Example: * Testing the Coin - Scenarios that take, drop and lose a coin, each from the same start.

	*: "Testing the Coin"

	Include i7Spec by Jeff Nyman.

	The Lab is a room. "A bare lab." A coin is in the Lab. A pit is a container in the Lab.

	After inserting the coin into the pit: say "The coin vanishes into the dark."; now the coin is nowhere.

	This is the coin is carried rule:
		if the player carries the coin, rule succeeds;
		rule fails.

	This is the coin is in the lab rule:
		if the coin is in the Lab, rule succeeds;
		rule fails.

	The coin pickup is a scenario.
	The coin loss is a scenario.
	The coin in hand is a scenario.
	The deliberate failure is a scenario.

	Scenario for the coin pickup:
		when "take coin";
		then the output is "Taken.";
		then the coin is carried rule holds.

	Scenario for the coin loss:
		when "take coin";
		when "put coin in pit";
		then the output includes "vanishes";
		when "inventory";
		then the output is "You are carrying nothing.".

	Scenario for the coin in hand:
		given "the player already has the coin";
		now the player carries the coin;
		when "inventory";
		then the output is "You are carrying:[line break]  a coin".

	Scenario for the deliberate failure:
		when "look";
		then the output includes "a golden throne".

	Test me with "run specs / look / run spec coin pickup".

Each scenario starts with the coin on the floor, though the one before took it or threw it into the pit: the coin is in the lab rule would hold at the start of every one. The deliberate failure shows what a failed check reports, and RUN SPECS ends by naming it. LOOK afterwards shows the world back as it began.
