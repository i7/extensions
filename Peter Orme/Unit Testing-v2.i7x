Version 2.2 of Unit Testing by Peter Orme begins here.

"A developer extension that lets you write unit tests (asserts) in Inform 7."

Include Developer Framework by Peter Orme.

Chapter 1 - Asserter

Section 1 - The Asserter proper 

[The Asserter is currently not implemented as a kind, just a single object]

The asserter is an object. 
The asserter has a number called _numsucceeded.
The asserter has a number called _numfailed.
The asserter has a verbosity. It is normal verbosity.
The asserter has a halting behavior. It is halt on summary.

Section 2 - Stopping abruptly (for use without Basic Screen Effects by Emily Short)

To stop the/-- game abruptly:
	(- quit; -)

Chapter 2 - Asserter methods

Section 1 - Asserting A is B

to assert that/-- (actual - a value) is (expected - a value):
	assert actual is expected saying only "Expected [expected], was [actual]"

[
	Asserts that a given value is an expected value, with a descriptive message.
]
to assert that/-- (actual - a value) is (expected - a value) saying (msg - a text):
	assert actual is expected saying only "[msg], expected [expected], was [actual]"
		
[
	Asserts that a given value is an expected value, with a descriptive message.
]
to assert that/-- (actual - a value) is (expected - a value) saying only (msg - a text):
	if actual is expected:
		assert_ok "[msg][line break]";
	otherwise:
		assert_fail "[msg][line break]";	

Section 2 - Asserting A is not B

to assert that/-- (actual - a value) is not (expected - a value):
	assert that actual is not expected saying only "Expected anything but [expected], was [actual]"

[
	Asserts that a given value is different from some other value, with a descriptive message.
]
to assert that/-- (actual - a value) is not (expected - a value) saying (msg - a text):
	assert that actual is not expected saying only "[msg], expected anything but [expected], was [actual]"
		
to assert that/-- (actual - a value) is not (expected - a value) saying only (msg - a text):
	if actual is not expected:
		assert_ok "[msg][line break]";
	otherwise:
		assert_fail "[msg][line break]";

Section 3 - Asserting some value is greater than some other value

[
	Asserts that a given value is greater than some expected value, with a descriptive message.
]
to assert that/-- (actual - a number) is greater than (min - a number):
	assert actual is greater than min saying only "Expected minimum [min], was [actual]".

[
	Asserts that a given value is greater than some expected value, with a descriptive message.
]
to assert that/-- (actual - a number) is greater than (min - a number) saying (msg - a text):
	assert actual is greater than min saying only "[msg], expected minimum [min], was [actual]".

to assert that/-- (actual - a number) is greater than (min - a number) saying only (msg - a text):
	if actual is greater than min:
		assert_ok "[msg][line break]";
	otherwise:
		assert_fail "[msg][line break]";
		
Section 4 - Asserting some text is empty

[
	Asserts that a text is empty, with a descriptive message.
]
to assert that/-- (actual - a text) is empty:
	if actual is empty:
		assert_ok "Expected an empty text, ok.[line break]";
	otherwise:
		assert_fail "Expected an empty text, was [actual].[line break]";	

[
	Asserts that a text is empty, with a descriptive message.
]
to assert that/-- (actual - a text) is empty saying (msg - a text):
	if actual is empty:
		assert_ok "[msg] - expected an empty text, ok.[line break]";
	otherwise:
		assert_fail "[msg] - '[actual]' is not an empty text[line break]";	

[
	This is like assert (text) is empty saying (message) except this will not 
	append the "'[actual]' is not empty" in the message.
]
to assert that/-- (actual - a text) is empty saying only (msg - a text):
	if actual is empty:
		assert_ok "[msg][line break]";
	otherwise:
		assert_fail "[msg][line break]";	

Chapter 3 - Other things the asserter does 

Section 1 - halting execution 

to halt execution saying (msg - a text):
	say paragraph break; 
	say msg;
	say paragraph break; 
	stop the game abruptly; [using a phrase from Basic Screen Effects by Emily Short]

Section 2 - Recording a succesful test

[
	Records a successful test and increments the _numsucceeded counter. 
]		
to assert_ok (msg - a text):
	if the verbosity of the asserter is high verbosity:
		say "OK: [msg]";
	increase the _numsucceeded of the asserter by 1;	

Section 3 - Recording a failed test

[
	Records a failed test and increments the _numfailed counter. 
]	
to assert_fail (msg - an indexed text):
	unless the verbosity of the asserter is low verbosity, say "FAIL: [msg]";
	increase the _numfailed of the asserter by 1;
	if the halting behavior of the asserter is halt on failure:
		halt execution saying "Halting on failure - [msg]";

Section 4 - Deciding whether the asserter is happy

[
	Checks if the Asserter is "happy", which it is only if it has no failed tests.
]	
to decide whether the asserter is happy:
	if the _numfailed of asserter is 0, decide yes;
	decide no.	

Section 5 - Counting the total
	
[
	Returns the total number of tests run (failed and successful).
]
to decide which number is tested of asserter:
	decide on the _numfailed of asserter + the _numsucceeded of asserter;
	

Section 6 - Resetting the asserter 

[
	Resetting the asserter means setting its counters to zero.
]
to reset the/-- asserter: 
	now the _numfailed of asserter is 0;
	now the _numsucceeded of asserter is 0;

Section 7 - Reporting asserts 

[
	Prints a summary of the assertions already carried out, possibly halting the execution. 
	You can specifify the verbosity: with silent, nothing is printed at all, with conversational only failures are printed, with verbose both failures and successes are printed. 
	
	Note that the halting behavior of the asserter comes into play. If the halting behavior is "halt on summary", and there indeed have been failures recorded by the asserter (since the last asserter reset), execution will stop. 
	
	Warning: The combination "halt on summary" and "silent" is perhaps not a very good choice, as it will indeed stop, but without telling you that much about why it stopped. 
] 
to report asserts using (V - a verbosity) set to (H - a halting behavior):
	if asserter is happy:
		if V is high verbosity:
			say "*** Assertions OK ***[line break]";
			say "Tested [tested of asserter] assertions without failures.";
	otherwise:
		say "*** ASSERTIONS FAILED ***[line break]";
		say "Tested [tested of asserter] assertions with [_numfailed of asserter] failures.";
	unless the asserter is happy:
		unless H is halt never:
			halt execution saying "There were [_numfailed of asserter] failures.";

to report asserts using (V - a verbosity):
	report asserts using V set to halt never;


[
	prints a summary of the assertions already carried out, possibly halting the execution, using the verbosity of the asserter (rather than having to pass it in).
]
to report asserts:
	report asserts using the verbosity of the asserter set to the halting behavior of the asserter.


Unit Testing ends here.

---- DOCUMENTATION ----

This is an extension aimed at software developer-type Inform 7 authors. It allows you to write "asserts" in the code. 

The main idea is to make a bunch of assertions, and then check the results, as a way of grouping asserts together. 

Chapter: Testing 

The typical usage involves writing some code that runs a number of "assert" tests. The assert calls all have the form "assert" (actual) something (expected) saying (message) where actual is the actual value, expected some expected value, and message is the message that is used if the assertion fails (or succeeeds, in verbose mode). Finally the "something" is one of "is", "is not" or "is greater than".

There are some versions on this. First, there is an optional "that", if we think that reads more fluently: "assert that 1 + 2 is 3 saying 'adding numbers'". Second, if we don't want to include a message (the "saying" part) we can just leave that out, but adding a message makes it easier for us too recognize where the test is in the code. Finally there is a "saying only" version. The "saying (message)" version prepends that message to whatever text the test naturally logs, typically the expected and actual parameters. If we want to be in complete control we can use the "saying only" version which does not append any such additional texts. In fact, the other two versions use the "saying only" version internally.  


Section: asserting two values are the same

assert (actual - a value) is (expected - a value) saying (msg - a text)

Section: asserting two values are different

assert (actual - a value) is not (expected - a value) saying (msg - a text)

Section: asserting one value is greater than the other

assert (actual - a value) is greater than (expected - a value) saying (msg - a text)

Section: asserting a text is empty

assert (actual - a text) is empty saying (msg - a text)

There is a special form that does not append the value to the message:

assert (actual - a text) is empty saying only (msg - a text)


Chapter: Reporting

While you run asserts, the asserter object gathers information about the number of failed and succesful tests. The "report asserts" action will print out a summary of the results. Setting the verbosity affects how much output this produces, and for the "report asserts" action you may also pass in a verbosity using the "report asserts using verbose" phrase. 

The use of "report asserts using silent" may seem a silly thing to do, but if the halting behavior is set to "halt on summary", which is the default, it still does do something: if halts the execution of the entire game if there have been failures. However, it does that without really providing much of a clue to what went wrong, so the combination of "silent" and "halt on summary" really is rather unhelpful.

Chapter: Settings

There are two settings that that modify the behavior of the asserter. 

Section: Setting the verbosity

To set the verbosity, use a phrase like "now the verbosity of the asserter is high verbosity".  Setting to to high verbosity will make it say more, 
setting it to low verbosity will make it quiet. The default is normal verbosity.

Section: Setting the halting behavior

There are also three values for the "halting behavior". Setting it to "halt on failure" will make it halt (stop the execution of the entire game) as soon as an assertion fails. Setting it to "halt never" will, not surprisingly, make it never halt. The default is "halt on summary", which will make it halt in the "report asserts" action, but only if there were any failures.

Chapter: Version History

Section: Version 2

Introduces an optional "that" so you can use either "assert that 1 + 1 is 2 saying 'adding numbers'" or "assert that 1 + 1 is 2 saying 'adding numbers'". Also makes the "saying" part optional, so you can use just "assert that 1 + 1 is 2".

Chapter: Examples

Example: * Asserting Arithmetic - Using assertions to check we know how to do math operations.

In this example we make an "assert" verb available to the player. Another option is just calling the asserts in a "when play begins" method. We don't really need an extension like this to test the standard built-in arithmetic of Inform7, but this illustrates the idea.

	*: "Asserting Arithmetic"

	the demo is a room.

	include Unit Testing by Peter Orme.

	to perform asserts:
		assert 3 + 3 is 6 saying "adding numbers";
		assert 3 - 1 is 2 saying "subtracting numbers";
		assert 1 * 4 is 4 saying "mutliplying numbers";
		assert that 2 + 2 is 4;
		assert 5 - 2 is 3;

	asserting is an action out of world applying to nothing. Understand "assert" as asserting. 

	carry out asserting: 
		now the verbosity of the asserter is normal verbosity;
		perform asserts;
		report asserts using high verbosity.
		
	test me with "assert";
	

