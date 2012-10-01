Version 1/120604 of Simple Unit Tests by Dannii Willis begins here.

"Very simple unit tests."

Include Text Capture by Eric Eve.

Chapter - Output capturing

To decide what indexed text is the captured output:
	let the result be an indexed text;
	stop capturing text;
	now the result is "[the captured text]";
	[ Strip whitespace at the beginning and end ]
	replace the regular expression "^\s+|\s+$" in the result with "";
	decide on the result;

Chapter - The assert phrase

The test assertion count is a number variable.
The total assertion count is a number variable.
The assertion failures count is a number variable.

[ Assert that two values are the same ]
To assert that/-- (A - a value) is (B - a value):
	stop capturing text;
	increment the test assertion count;
	increment the total assertion count;
	unless A is B:
		increment the assertion failures count;
		say "Failure for test: [the current unit test name], assertion: [the test assertion count]. Expected: [B], Got: [A][line break]";
	start capturing text;

[ Assert that any condition is true, but with less information on failure ]
To assert that/-- (C - a condition):
	(- Assert_Condition({C}); -).

Include (-
[ Assert_Condition C;
	EndCapture();
	(+ the test assertion count +)++;
	(+ the total assertion count +)++;
	if (~~(C))
	{
		(+ the assertion failures count +)++;
		print "Failure for test: ";
		print (INDEXED_TEXT_TY_Say) (+ the current unit test name +);
		print ", assertion: ", (+ the test assertion count +), ". (Asserted condition is false)^";
	}
	StartCapture();
];
-).

Chapter - The Unit test rules unindexed

The current unit test name is an indexed text variable.

Unit test rules is a rulebook.

Running the unit tests is an action out of world.
Understand "run the unit test/tests" and "run unit test/tests" and "unit test/tests" and "unit" as running the unit tests.

[ Manually go through the unit test rules so that we can reset the assertion count for each rule, and capture text automatically. ]
Carry out running the unit tests (this is the run all unit tests rule):
	let index be 0;
	now the total assertion count is 0;
	now the assertion failures count is 0;
	[ Save and restore each time a unit test is run ]
	if the result of saving before running the unit tests is 2:
		stop;
	[ Loop through the unit test rules until we reach the end (NULL/-1) ]
	let addr be the address of unit test rule number index;
	while the addr is not -1:
		now the test assertion count is 0;
		[ Find the name of the rule, if we can ]
		now the current unit test name is "";
		if the memory economy option is inactive:
			now the current unit test name is "[the rule at address addr]";
			replace the regular expression " rule$|Unit test" in the current unit test name with "";
		if the current unit test name is "":
			now the current unit test name is "[index + 1]";
		[ Start capturing text so that the first assertion can use the captured output if it wants ]
		start capturing text;
		consider the rule at address addr;
		stop capturing text;
		increment index;
		now addr is the address of unit test rule number index;
	if the assertion failures count is 0:
		say "Congratulations! ";
	say "[the assertion failures count] of [the total assertion count] assertions failed.[paragraph break]";
	restore back to before running the unit tests;

[ A couple of short I6 phrases to loop through the unit tests ]
To decide what number is the address of unit test rule number (i - a number):
	(- (rulebooks_array-->(+ the unit test rules +) )-->{i} -).

To decide what rule is the rule at address (addr - a number):
	(- {addr} -).

[ A couple more for saving and restoring an undo point ]
To decide what number is the result of saving before running the unit tests:
	(- VM_Save_Undo() -).

To restore back to before running the unit tests:
	(- VM_Undo(); -).

Simple Unit Tests ends here.

---- DOCUMENTATION ----

This extension adds support for simple unit tests. Group tests together in rules added to the Unit test rulebook, and make individual tests with the assert phrase:

	Unit test:
		assert that 5 is 5;
		assert that "happy" is "happy";

Simple Unit Tests uses Text Capture by Eric Eve to capture any text that is said between assertions. You can use "the captured output" to have the captured text automatically stripped of whitespace at its beginning and end. If you need to capture a lot of text then you will need to increase the buffer size used by Text Capture; see that extension for details.

	Unit test:
		say "happy";
		assert that the captured output is "happy";

Failed assertions will display an error message. If you are asserting that two values are the same then the expected and actual values will be displayed. If you give your test rules names, those names will be displayed. So running

	Unit test (this is the failing rule):
		assert that 2 plus 2 is 5;
		assert that the player encloses a room;

produces
	Failure for test: failing, assertion: 1. Expected: 5, Got: 4
	Failure for test: failing, assertion: 2. (Asserted condition is false)
	2 of 2 assertions failed.

If you are writing an extension, we suggest you name all your test rules, and that you place your tests under a section titled:
	(not for release) (for use with Simple Unit Tests by Dannii Willis)

The state of the VM will be saved before and restored after the unit tests are run, so you don't need to worry about your tests changing anything permanently.

Lastly, run the tests by entering the command "run the unit tests" (or just simply "unit"), or use "try running the unit tests" in your code. Happy testing!

The latest version of this extension can be found at <https://github.com/i7/extensions>. This extension is released under the Creative Commons Attribution licence. Contact the author at <curiousdannii@gmail.com>

Example: * Basic Unit Tests - Passing and Failing

	*: "Basic Unit Tests"
	
	Include Simple Unit Tests by Dannii Willis.

	Test room is a room.
	
	Unit test (this is the passing rule):
		assert 5 is 5;
		assert 2 plus 2 is 4;
		assert {1, 2, 3} is {1, 2, 3};
		assert "happy" is "happy";
		say "hello!";
		assert the captured output is "hello!";
		assert the score is 0;
		assert the player is enclosed by the location;

	Unit test (this is the failing rule):
		assert {1, 2, 3} is {1, 2, 3, 4};
		assert "happy" is "sad";
		say "hello!";
		assert the captured output is "goodbye!";
		assert the player encloses a room;

	When play begins:
		try running the unit tests;