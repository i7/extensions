Command Unit Testing by Xavid begins here.

"Support for creating 'unit tests' that run a series of commands and make assertions about the output of some of them."

[ Overall inspired by Simple Unit Tests by Dannii Willis, which didn't have sufficient command-simulation abilities. ]

Use authorial modesty.

Part 1 - Unit Testing - Not for release

Unit test rules is a rulebook.

Running the unit tests is an action out of world.
Understand "run the unit test/tests" and "run unit test/tests" and "unit test/tests" and "unit" as running the unit tests.

The assertion count is a number that varies.
The success count is a number that varies.

Carry out running the unit tests (this is the run all unit tests rule):
	now the assertion count is 0;
	now the success count is 0;
	follow the unit test rules.

To start suite (S - text):
	echo "[line break]Starting suite: [S]...".

To start test (T - text):
	echo "Starting test: [T]...".

To assert that (command - text) produces (expected - text):
	add command to the command queue;
	add expected to the expectation queue;
	add "" to the arg queue.

To assert that (str - text) substitutes to (expected - text):
	add "!echo" to the command queue;
	add expected to the expectation queue;
	add str to the arg queue.

To do (command - text):
	add command to the command queue;
	add "" to the expectation queue;
	add "" to the arg queue.

To echo (T - text):
	add "!echo" to the command queue;
	add "" to the expectation queue;
	add T to the arg queue.

The expected output is text that varies.

[ Inspired by / based on Command Modification by Daniel Stelzer]

The command queue is a list of text that varies.
The expectation queue is a list of text that varies.
The arg queue is a list of text that varies.

Rule for reading a command when the command queue is not empty (this is the Command Unit Testing execute queued commands rule):
	let the new command be entry 1 in the command queue;
	change the text of the player's command to the new command;
	now the expected output is entry 1 in the expectation queue;
	remove entry 1 from the command queue;
	remove entry 1 from the expectation queue;
	remove entry 1 from the arg queue;
	if the expected output is empty:
		say "> [italic type][new command][roman type][line break][run paragraph on]";
	else:
		say "Evaluating: [italic type][new command][roman type][line break][run paragraph on]";
		start unit-capturing text.

First before reading a command when the expected output is not empty (this is the Command Unit Testing process current assertion after the command finishes rule):
	process current assertion.

Before reading a command when the command queue is not empty (this is the Command Unit Testing handle queued echoes rule):
	while the command queue is not empty and entry 1 in the command queue exactly matches the text "!echo":
		if entry 1 from the expectation queue is empty:
			say "[entry 1 from the arg queue][line break]";
		else:
			increase the assertion count by 1;
			let S be entry 1 from the arg queue;
			if S exactly matches the text entry 1 from the expectation queue:
				increase the success count by 1;
				say "[S][line break]";
			else:
				say "[bold type]Assertion failed:[roman type] substituted as '[S]', not '[entry 1 from the expectation queue]'!";
		remove entry 1 from the command queue;
		remove entry 1 from the expectation queue;
		remove entry 1 from the arg queue.

To process current assertion:
	stop unit-capturing text;
	let the result be "[the unit-captured text]";
	[ If there's more than 2 newlines at the end, we don't remove any. This is mainly because the regular expression support in Inform doesn't handle non-greedy captures properly in some cases in mysterious ways. ]
	if the result matches the regular expression "^(.*<^\n>)\n{1,2}$":
		let the result be text matching subexpression 1;
	increase the assertion count by 1;
	if the result exactly matches the text expected output:
		increase the success count by 1;
		say "[result][line break]";
	else:
		replace the text "[paragraph break]" in the result with "[bracket]paragraph break[close bracket]";
		replace the text "[paragraph break]" in the expected output with "[bracket]paragraph break[close bracket]";
		replace the text "[line break]" in the result with "[bracket]line break[close bracket]";
		replace the text "[line break]" in the expected output with "[bracket]line break[close bracket]";
		say "[bold type]Assertion failed:[roman type] produced '[result]', not '[expected output]'!";
	now the expected output is "".

[ Clarification questions don't trigger "reading a command" ]
After asking which do you mean when the command queue is not empty or the expected output is not empty (this is the Command Unit Testing process current assertion after clarification question rule):
	if the expected output is not empty:
		process current assertion;
	say "(Test paused due to clarification question; type 'z' to continue.)".

Last before reading a command when the command queue is empty and the assertion count is not 0 (this is the Command Unit Testing print results after emptying command queue rule):
	if the assertion count is the success count:
		say "[line break]Results: all [success count]/[assertion count] assertions passed!";
	else:
		say "[line break]Results: [success count]/[assertion count] assertions passed.";
	now the assertion count is 0;
	now the success count is 0.

Part 2 - Additional Text Capture - Not for release (for Glulx Only)

[ This is basically a duplicate copy of Text Capture by Eric Eve with different names for everything. ]

Section 1 - Define a Use Option

Use maximum unit-capture buffer length of at least 256 translates as (- Constant UNIT_CAPTURE_BUFFER_LEN = {N}; -). 

Section 2 - Define Phrases

To start unit-capturing text:
	(- StartUnitCapture(); -).

To stop unit-capturing text:
	(- EndUnitCapture(); -).

To say the/-- unit-captured text:
	(- PrintUnitCapture(); -).

Section 3 - Implementation

Include (-	Global unit_capture_active = 0;	-).

Include (-

Array unit_captured_text --> UNIT_CAPTURE_BUFFER_LEN + 1;

Global text_unit_capture_old_stream = 0;
Global text_unit_capture_new_stream = 0;

[ StartUnitCapture i;   
	if (unit_capture_active ==1)
		return;
	unit_capture_active = 1;
	text_unit_capture_old_stream = glk_stream_get_current();
	text_unit_capture_new_stream = glk_stream_open_memory_uni(unit_captured_text + WORDSIZE, UNIT_CAPTURE_BUFFER_LEN, 1, 0);
	glk_stream_set_current(text_unit_capture_new_stream);
];

[ EndUnitCapture len;
	if ( unit_capture_active == 0 )
		return;
	unit_capture_active = 0;
	glk_stream_set_current(text_unit_capture_old_stream);
	@copy $ffffffff sp;
	@copy text_unit_capture_new_stream sp;
	@glk $0044 2 0; ! stream_close
	@copy sp len;
	@copy sp 0;
	unit_captured_text-->0 = len;
	if (len > UNIT_CAPTURE_BUFFER_LEN)
	{
		unit_captured_text-->0 = UNIT_CAPTURE_BUFFER_LEN;
	}
];

[ PrintUnitCapture len i;
	len = unit_captured_text-->0;
	for ( i = 0 : i < len : i++ )
	{
		glk_put_char_uni(unit_captured_text-->(i + 1));
	}
];

-).

Part 3 - Shared Text Capture - Not for release (for Z-machine Only)

Include Text Capture by Eric Eve.

To start unit-capturing text:
	start capturing text.

To stop unit-capturing text:
	stop capturing text.

To say the/-- unit-captured text:
	say the captured text.

Command Unit Testing ends here.

---- DOCUMENTATION ----

Suppose you've put great effort into making sure that a given series of commands responds a certain way. You're now ready to work on the rest of your game, but you want to make sure that nothing you do breaks what you just set up. You can have "test" commands to check this, but you have to manually verify that the output is correct each time. This extension provides another option: the ability to create 'unit tests' that run a series of commands and make assertions about the output of some of them.

Chapter 1 - Writing Tests

Unit tests are very similar conceptually to the Inform built-in "test" command, in that they run a series of user commands, but they're defined differently, in unit test rules. A basic example would be:

	Unit test:
		start test "dropping";
		do "take fish";
		assert that "drop fish" produces "Dropped.";
		assert that "[the fish]" substitutes to "the dirty fish".

The "start test" instruction just prints a message to make it easier to tell where one test ends and another begins. There's also a "start suite" which works in the same way. (Because tests need to set up a series of commands and later execute them, normal "say" won't work well, but you can use "echo" to schedule other messages in the output.)

The "do" instruction just executes a command without doing anything special with it.

The "assert that ... produces" instruction is the real powerhouse; it runs a command, capturing the output text, and then compares it to the expected output. If they don't match, the extension reports an assertion failure. Ordinary newlines are removed from the end of the output.

You can also do "assert that ... substitutes to ..." to test the value an expansion produces without running any particular command.

Chapter 2 - Running Tests

You can run tests manually with the "unit" command. You could also run them automatically (on startup, say) with "try running the unit tests", but given that this extension currently doesn't support restoring the original game state this is probably not recommended.

Chapter 3 - Caveats

Section 1 - Unit Test Commands Are Delayed

The way unit tests work, we queue up a bunch of commands during the unit test rules and then run them afterwards. Thus, most non-unit-test specific things you might want to do in a unit test rule won't work, because the commands will happen too late. For example, if you do something like:
	
	Unit test:
		do "x apple";
		now the player holds the apple;
		do "x apple".

The now line will take effect before either of the examine commands.

Section 2 - Clarification Questions

Inform doesn't give Inform 7 code easy full control over clarification questions. Assertions work properly when a clarification question is passed, but the unit testing will pause there. To let the test continue, you'll be asked to type the "z" ("wait") command to get out of the "waiting for clarification question answer" state.

(We could potentially improve this by basing the extension off of the Inform 6 implementation of the "test" command instead of a "reading a command" rule, which would let us also script answers to clarification questions, but that'd make the extension much more complicated/brittle for a pretty minor benefit.)

Section 3 - Text Capture

Assertion instructions rely on text capture (based on Text Capture by Eric Eve). On the Z-machine, if the underlying action also uses text capture (for example, it involves Implicit Actions by Eric Eve), then this won't work properly. (On Glulx, we add a second text capture implementation that can co-exist with the normal one.)

Text capture has a 256-character limit on the length of captured text; for commands with longer expected output, you might want to increase this with something like:

	Use maximum unit-capture buffer length of at least 512.

or, on the Z-machine:
	
	Use maximum capture buffer length of at least 512.

Chapter 4 - Bugs and Comments

This extension is hosted in Github at https://github.com/i7/extensions/tree/master/Xavid. Feel free to email me at extensions@xavid.us with questions, comments, bug reports, suggestions, or improvements.

Example: * Unit 1 - A basic unit test.

	*: "Unit 1"
	
	Include Command Unit Testing by Xavid.
	
	Facility is a room.

	A thing called an apple is here.

	Unit test:
		start test "taking a possession";
		do "take apple";
		assert that "take apple" produces "You already have that.";
		assert that "[a apple]" substitutes to "an apple".
	
	Test me with "unit".
