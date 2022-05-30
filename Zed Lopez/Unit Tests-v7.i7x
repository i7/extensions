Version 7 of Unit Tests by Zed Lopez begins here.

"For unit testing."

[ relies on the interpreter supporting save/undo ]

Volume Unit Tests (not for release)

Part Output file

The file of results is called "utresults".

Part Constants

Chapter Improbable

To decide what number is improbable number: (- IMPROBABLE_VALUE -).

Chapter maximum int

To decide what number is max/maximum positive/-- number/integer: (- MAX_POSITIVE_NUMBER -).

Chapter minimum int

To decide what number is min/minimum negative/-- number/integer: (- MIN_NEGATIVE_NUMBER -).

Part Use Option

Chapter Test Automatically

Use test automatically translates as (- Constant TEST_AUTOMATICALLY; -).

Last when play begins (this is the test all unit tests automatically rule):
  if test automatically option is active, test all unit tests.

Section Quit Afterwards

Use quit after autotesting translates as (- Constant QUIT_AFTER_AUTOTESTING; -).

Chapter Write to file

Use write test results to file translates as (- Constant WRITE_TEST_RESULTS_TO_FILE; -).

First when play begins when write test results to file option is active (this is the unit test create or empty results file rule):
  write "" to file of results.

Chapter Don't Report passing tests

Use don't report passing tests translates as (- Constant DONT_REPORT_PASSING_TESTS; -).

Part what VM?

To decide if in/on a/-- Zmachine/Z-machine/zcode/z-code: (- (WORDSIZE == 2) -).

To decide if in/on a/-- glulx machine/--: (- (WORDSIZE == 4) -).

[To decide what number is word size: (- WORDSIZE -).

To decide if in/on a/-- Zmachine/Z-machine/zcode/z-code: decide on whether or not word size is 2.

To decide if in/on a/-- glulx machine/--: decide on whether or not word size is 4.
]
Part Undo

[ VM_Save_Undo, z5+
Z-machine:
-1 terp doesn't support
0 failure
1 save succeeded
2 back from restoration
]



To decide what number is the save-restore state: (- VM_Save_Undo() -).

Back from restoration is always 2.

To restore state: (- VM_Undo(); -).

Part unit test object

A unit test is a kind of object.
A unit test has a text called the description.
A unit test can be heap tracking.

The current unit test is a unit test that varies.

A unit test has a phrase text -> nothing called the output result.

To say ut-how-tested: if ut-assert is true, say "Asserted";
else say "Refuted".

To verbosely output result with (T - a text) (this is original-output-result):
  say "[ut-how-tested] [T]: expected ";
  if ut-truth-state is true begin;
    if ut-result is true, say "and found true";
    else say "true, found false";
  else;
    if ut-assert is true, say ut-operator;
    else say ut-opposite;
    say " [ut-expected], found: [ut-found]";
  end if;
  if ut-result is true, say " (pass)";
  else say " (fail)";
  say line break;

To decide what number is text-type: (- TEXT_TY -).

To simple output result with (T - a text) (this is simple-output-result):
  if ut-result is false or don't report passing tests option is not active begin;
    say "[ut-how-tested] [T]: ";
    if ut-truth-state is true, say "[ut-found]";
    else say "tested [ut-found] [ut-operator] [ut-expected]";
    if ut-result is true, say " (pass)";
    else say " (fail)";
    say line break;
  end if;
  
The output result of a unit test is usually simple-output-result.

The description of a unit test is usually "".


Chapter Saying unit test

To say (ut - a unit test):
  if the description of ut is "", say "[printed name of ut]";
  else say description of ut.

Part Success and failure counting

[ For ease of sharing info between I7 and I6 these are globals.
  Only one test should be occurring at a time, so their globality
  shouldn't pose any problem. ]
Include (-
Global unit_test_success;
Global unit_test_failure;
Global ut_expected; ! LHS for comparative ; true/false for conditional
Global ut_found; ! RHS for comparative ; true/false for conditional
Global ut_kind; ! strong kind of operands for comparative; irrelevant for conditional
Global ut_truth_state; ! 0: comparative ; 1 : conditional
Global ut_operator; ! -1: < ; 0: == ; 1: >
Global ut_result; ! 0: fail ; 1: pass
Global ut_assert; ! 0: refutation ; 1: assertion
Global ut_test_output;
! an operator constant xor-ed with 7 produces its opposite
Constant EQ_OK = 1;
Constant LT_OK = 2;
Constant GT_OK = 4;
Global GE_OK;
Global LE_OK;
Global NE_OK;
!Constant GE_OK = EQ_OK | GT_OK;
!Constant LE_OK = (EQ_OK | LT_OK);
!Constant NE_OK = (LT_OK & GT_OK); ! literally <> !

[ AssignCmpPseudoConstants;
  GE_OK = EQ_OK | GT_OK;
LE_OK = (EQ_OK | LT_OK);
NE_OK = (LT_OK & GT_OK);
];
-) after "Definitions.i6t".

to assign comparison pseudoconstants: (- AssignCmpPseudoConstants(); -)

when play begins: assign comparison pseudoconstants.


ut-assert is a truth state variable.
ut-assert variable translates into I6 as "ut_assert".

ut-truth-state is a truth state variable.
ut-truth-state variable translates into I6 as "ut_truth_state".

ut-op is a number variable.
ut-op variable translates into I6 as "ut_operator".

ut-kind is a number variable.
ut-kind variable translates into I6 as "ut_kind".

ut-result is a truth state variable.
ut-result variable translates into I6 as "ut_result".

ut-test-output is a truth state variable.
ut-test-output variable translates into I6 as "ut_test_output".

Unit test success is a number variable.
Unit test success variable translates into I6 as "unit_test_success".

Unit test failure is a number variable.
Unit test failure variable translates into I6 as "unit_test_failure".

to say ut-operator: (- print (utop) ut_operator; -)

To say ut-expected: (- if (ut_truth_state) { utTruth(ut_expected); } else {
if (ut_kind == TEXT_TY) print "~";
PrintKindValuePair(ut_kind, ut_expected);
if (ut_kind == TEXT_TY) print "~";
 } -).
To say ut-found: (- if (ut_kind) {
if (ut_kind == TEXT_TY) print "~";
PrintKindValuePair(ut_kind, ut_found);
if (ut_kind == TEXT_TY) print "~";
} else { utTruth(ut_found); } -)

to say ut-opposite: (- print (utop) bitxor(ut_operator, 7); -)

Part Actions

Chapter unit testing

unit testing is an action out of world.
Understand "utest" as unit testing.

Check unit testing (this is the check for unit tests rule): unless there are unit tests, instead say "No unit tests have been defined.";

Carry out unit testing (this is the test all unit tests rule): test all unit tests.

Chapter Test all unit tests to-phrase

To test all unit tests: test all unit tests matching "".

Section test all unit tests matching

To say test results for (ut - a unit test):
  now unit test success is 0;
  now unit test failure is 0;
  if the save-restore state is back from restoration, stop;
  carry out the testing activity with ut;
  let total test count be unit test success + unit test failure;
  let summary be "[if unit test failure > 0]***[else]   [end if] [unit test success]/[total test count] passed[if unit test failure is 0].[else]; [unit test failure]/[total test count] failed.[end if][line break]";
  output summary;
  restore state;
  
To test all unit tests matching (T - a text):
  let matching-unit-tests-count be 0;
  repeat with ut running through the unit tests begin;
  if T is empty or printed name of ut rmatches "^[T]", case insensitively begin;
      let result be the substituted form of "[test results for ut]";
      output result;
      increment matching-unit-tests-count;
    end if;
  end repeat;
  if the test automatically option is active and the quit after autotesting option is active, follow the immediately quit rule;
  if matching-unit-tests-count is 0, say "No unit tests began with '[T]'.";
  
Chapter Stash (for use with Text Capture by Eric Eve)

To stash unit test output (this is ut-stash):
  unless the test quietly option is active, output "[captured text]";

Chapter Fake Stash (for use without Text Capture by Eric Eve)

To stash unit test output (this is ut-stash):
  do nothing.

Chapter say test

To say test (ph - phrase): (- ut_test_output = 1; if (0==0) {ph} -).

To say test (C - a condition):
  (- ut_test_output = 1; if ({C}) { print ""; } -).

To decide if (T - a text) reports an/-- error:
  decide on whether or not T rmatches "(.*\n)*\*\*\* ".

Chapter Test command

[ ``> test suite`` can be used instead of ``> utest`` ]
Test suite with "utest".

Chapter Specific-utesting

Specific-utesting is an action out of world applying to one topic.
Understand "utest [text]" as specific-utesting.

Section Carry out specific-utesting

Carry out specific-utesting (this is the carry out unit testing via utest command rule):
  test all unit tests matching "[the topic understood]"

Part Assertions

Part Testing something activity

Testing something is an activity on unit tests.
The testing activity has a number called the initial heap usage.

To decide what number is the current heap usage:
  (- ((MEMORY_HEAP_SIZE + 16) - HeapNetFreeSpace(false)) -).

First before testing a heap tracking unit test (called ut) (this is the unit test say your name rule):
  now the initial heap usage is the current heap usage;

First before testing a unit test (called ut) (this is the unit test mark not ready to read rule):
  if write test results to file option is active, mark the file of results as not ready to read;
  output "[line break]Testing [ut][line break]";

After testing a heap tracking unit test (called ut) (this is the unit test heap usage reporting rule):
  let heap-usage be the current heap usage;
  if heap-usage is not initial heap usage, output "*** Test [ut] altered heap usage: was [initial heap usage], now [current heap usage].[line break]" 

Last after testing when write test results to file option is active (this is the unit test mark ready to read rule):
  mark the file of results as ready to read;

The for testing rules have default no outcome.

Include (-

[ bitxor n1 n2 result;
  return (n1 | n2) & (~(n1 & n2));
];

[ utTruth x;
  if (x) print "true";
  else print "false";
  ];

[ utAssertPlain x assert txt;
  EndCapture();
  ((+ ut-stash +)-->1)();
  ut_truth_state = 1;
  ut_found = x;
  ut_result = 0;
  if ((~~x) == (~~assert)) ut_result = 1;
  ut_assert = assert;
  utFinish(txt);
];

[ utTextCompare t1 t2 s1 s2 result;
  s1 = BlkValueCreate(TEXT_TY);
  s2 = BlkValueCreate(TEXT_TY);
  BlkValueCopy(s1, t1);
  BlkValueCopy(s2, t2);
  TEXT_TY_Transmute(s1);
  TEXT_TY_Transmute(s2);
  result = TEXT_TY_Compare(s1, s2);
  BlkValueFree(s1);  
  BlkValueFree(s2);
  return result;
];

[ utAssert x y k cmp_target assert txt equal_op cmp cmp_result;
  EndCapture();
  ((+ ut-stash +)-->1)();
  ut_result = 0;
  ut_operator = cmp_target;
  if (k == NUMBER_TY) cmp = utSignedCompare;
  else if ((k == TEXT_TY) && equal_op) { cmp = utTextCompare; }
  else cmp = KOVComparisonFunction(k);
  cmp_result = cmp(x,y);
  if (assert == (((cmp_result == 0) && (cmp_target & EQ_OK)) || ((cmp_result < 0) && (cmp_target & LT_OK)) || ((cmp_result > 0) && (cmp_target & GT_OK)))) ut_result = 1;
  ut_truth_state = 0;
  ut_kind = k;
  ut_expected = y;
  ut_found = x;
  ut_assert = assert;
  utFinish(txt);
];

[ utFinish txt;
  if (ut_truth_state) ut_kind = 0;
  if (ut_result) {
    unit_test_success++;
#ifndef DONT_REPORT_PASSING_TESTS;
    ((+ output-result +)-->1)(txt);
#endif;
  }
  else {
    unit_test_failure++;
    ((+ output-result +)-->1)(txt);
  }
  StartCapture();
];

[ utSignedCompare x y;
if (x > y) return 1;
if (x < y) return -1;
return 0;
];

[ utop op;
if (op & LT_OK) print "<";
if (op & GT_OK) print ">";
if (op & EQ_OK) print "=";
if (op & EQ_OK) print "="; ! yes, it's supposed to be there twice
];
-)

To output (T - a text):
  say T;
  if write test results to file option is active begin;
    unless ready to read file of results begin;
      append T to file of results;
      mark the file of results as not ready to read;
    end unless;
  end if;

To say captured output of current test statement result for (T - a text): 
  apply output result of current unit test to T.

To report current test statement result for (T - a text) (this is output-result):
  let result be "[if ut-result is true]   [else]***[end if] [captured output of current test statement result for T]";
  output result;
  if ut-test-output is true, now ut-test-output is false;

Book Assertions and Refutations

Part or neither

Chapter instant

To for (txt - a text) pass:
  (- utAssertPlain(1,1,{txt}); -).

To for (txt - a text) fail:
  (- utAssertPlain(0,1,{txt}); -).

Part Assertions

Chapter boolean (for use with If True by Zed Lopez)

To for (txt - a text) assert (X - value of kind K):
  (- utAssertPlain({X},1,{txt}); -).

Chapter conditional

To for (txt - a text) assert (C - a condition):
  (- utAssertPlain({C},1,{txt}); -).

Chapter equality

To for (txt - a text) assert (X - value of kind K) is (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},EQ_OK,1,{txt}); -)

To for (txt - a text) assert (X - a text) is blank:
  (- utAssert({X},(+ empty-string +),{-strong-kind:text},EQ_OK,1,{txt}); -)

To for (txt - a text) assert (X - value of kind K) == (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},EQ_OK,1,{txt}, 1); -)

Chapter greater than
  
To for (txt - a text) assert (X - value of kind K) > (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},GT_OK,1,{txt}); -).

Chapter less than
  
To for (txt - a text) assert (X - value of kind K) < (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},LT_OK,1,{txt}); -).

Chapter <=

To for (txt - a text) refute (X - value of kind K) <= (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},LE_OK,1,{txt}); -).

Chapter <=

To for (txt - a text) refute (X - value of kind K) >= (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},GE_OK,1,{txt}); -).

Part Refutations

Chapter boolean (for use with If True by Zed Lopez)

To for (txt - a text) refute (X - value of kind K):
  (- utAssertPlain({X},{-strong-kind:K},0,{txt}); -).

Chapter conditional

To for (txt - a text) refute (C - a condition):
  (- {-my:1} = 0; if ({C}) {-my:1} = 1; utAssertPlain({-my:1},0,{txt}); -).

Chapter equality

To for (txt - a text) refute (X - value of kind K) is (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},EQ_OK,0,{txt}); -)

To for (txt - a text) refute (X - a text) is blank:
  (- utAssert({X},(+ empty-string +),{-strong-kind:K},EQ_OK,0,{txt}); -)

To for (txt - a text) refute (X - value of kind K) == (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},EQ_OK,0,{txt},1); -)

Chapter greater than
  
To for (txt - a text) refute (X - value of kind K) > (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},GT_OK,0,{txt}); -).

Chapter less than
  
To for (txt - a text) refute (X - value of kind K) < (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},LT_OK,0,{txt}); -).

Chapter <=

To for (txt - a text) refute (X - value of kind K) <= (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},LE_OK,0,{txt}); -).

Chapter <=

To for (txt - a text) refute (X - value of kind K) >= (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},GE_OK,0,{txt}); -).

Book Other interactions

Chapter text comparisons (For use without Textile by Zed Lopez)

To decide what text is an/-- expanded (T - a text):
    (- TEXT_TY_SubstitutedForm({-new:text}, {-by-reference:T}) -).

To decide if a/an/-- (S - text) exactly matches a/an/-- (T - text): decide on whether or not S exactly matches the text T;
To decide if a/an/-- (S - text) does not exactly match a/an/-- (T - text): if S exactly matches T, no; yes.
To decide if a/an/-- (S - text) includes a/an/-- (T - text): decide on whether or not S matches the text T;
To decide if a/an/-- (S - text) does not include a/an/-- (T - text): if S includes T, no; yes.

To rmatch a/an/-- (V - a text) by a/an/-- (R - a text), case insensitively:
  (- TEXT_TY_Replace_RE(REGEXP_BLOB,{-by-reference:V},{-by-reference:R},0,{phrase options}); -).

To decide if (V - a text) rmatches a/an/-- (R - a text), case insensitively:
  (- TEXT_TY_Replace_RE(REGEXP_BLOB,{-by-reference:V},{-by-reference:R},0,{phrase options}) -).

[ unfortunate ambiguity if we add case insensitively here ]
To decide if (V - a text) does not rmatch a/an/-- (R - a text), case insensitively:
  (- (~~(TEXT_TY_Replace_RE(REGEXP_BLOB,{-by-reference:V},{-by-reference:R},0,{phrase options}))) -).

To decide what text is the/a/-- match (N - a number):
  (- TEXT_TY_RE_GetMatchVar({N}) -).

To rmatch (V - a text) by/with/against a/an/-- (R - a text), case insensitively:
  (- TEXT_TY_Replace_RE(REGEXP_BLOB,{-by-reference:V},{-by-reference:R},0,{phrase options}); -).

To decide what text is a/an/-- (T - a text) trimmed:
  rmatch T against "^\s*(.*?)\s*$";
  decide on match 1;

Book Text Capture (for use with Text Capture by Eric Eve)

Use maximum capture buffer length of at least 8192;

Use test quietly translates as (- Constant TEST_QUIETLY; -).

This is the unit test text capture rule: start capturing text.

The unit test text capture rule is listed after the the unit test say your name rule in the before testing rules.

First after testing a unit test: stop capturing text;

Book Fake I6 Stubs (for use without Text Capture by Eric Eve)

Include (-
[ EndCapture;
  rfalse;
];
[ StartCapture;
  rfalse;
];
-)


Unit Tests ends here.

---- Documentation ----

Chapter Introduction

This is a unit test extension. There are many like it, but this one is mine.

Note: because this extension declares a unit test variable, if you include Unit
Tests, your code *must* create at least one unit test, or it will fail to compile.

The entire extension is marked "not for release".

Chapter Use case

To test your game as a whole, I recommend using Andrew Plotkin's [RegTest](https://eblong.com/zarf/plotex/regtest.html).
The latest is available in [the plotex Github repo](https://github.com/erkyrath/plotex/blob/master/regtest.html).

But if you're testing code in isolation that isn't about accepting player commands
or producing player-visible output, RegTest isn't the most natural fit. This
extension was written for those cases.

Chapter Unit Test kind

A unit test is a kind of object, with a text description property, which should
be populated for the test to identify itself. (It *can* be left blank, in which
case the test falls back on the object name itself.) Because the property is
"description" it can be specified with just a stand-alone string immediately
following the object definition.

	Math-still-works is a unit test. "Whether math still works".

``Testing`` is an activity on unit tests. For the test to do anything useful,
you must define a corresponding ``For testing`` rule:

	For testing math-still-works:
		for "Add 2 + 2" assert 2 + 2 is 4;

(More about assert statements later.)

If you have setup to do, a ``Before testing`` rule is a good place for it. But you may
need to establish global variables or activity variables for the ``For testing`` and/or
``After testing`` rules to have access to information set up in the Before rule.

If there's more reporting you want, you might use an ``After testing`` rule. But you shouldn't
need to do any teardown: unit tests are idempotent. They save the game state before they
start, and restore when they're finished. (On glulx one can protect memory from being
clobbered by a restore, so make that *mostly* idempotent, but it should be fairly difficult
for one test to screw up the environment for another.)

This means that you also can't share context between different tests... but you can make the
same Before rule apply to more than one test. (You could have multiple ``for testing`` rules
for the same unit test, using ``continue the activity``, but assertions/refutations spread
among multiple rules in that fashion would be equivalent to them all being in the same rule.)

	Before testing a unit test (called ut) when ut is test1 or ut is test2:

And don't have one test invoke another: the save-state in the inner test's Before testing
rule would clobber the outer test's state, so when the outer test restored state, it would
restore state as of the beginning of the inner test, not the outer test.

Chapter Assertions and Refutations

assert/refute statements are the heart of testing. This documentation will refer to assertions
and refutations collectively as "test statements".

It technically doesn't matter where they occur in the activity, but the intent is that they be
used in For Testing rules. There are several varieties:

Equality with ``is`` or ``==``

	for <label> assert <value> is <value>;
	for <label> refute <value> is <value>;

The values must be of compatible kinds. For texts, == is a special case that means the same as
``exactly matches the text``; ``is`` is the same as in conventional I7. See Text Comparisons
below.

Less than or greater than:

	for <label> assert <value> < <value>;
	for <label> refute <value> < <value>;
	for <label> assert <value> > <value>;
	for <label> refute <value> > <value>;

Any arbitrary condition:

	for <label> assert <condition>
	for <label> refute <condition>

And, if you've included If True by Zed Lopez, a plain truth state value.

	for <label> assert <truth state value>
	for <label> refute <truth state value>

Operators for !=, <=, => aren't provided; just refute ==, >, <, respectively.

If you create a unit test object, you should write a corresponding For testing activity rule
which should include at least one test statement. This isn't enforced: if you don't
have any test statements, the test will run and report 0/0 Passed.

Chapter Instantly passing or failing

You can say either of:

	for <label> pass;
	for <label> fail;

As to why you'd want to, say you had a test whose setup relied upon a phrase invocation that
could return an invalid value, or a case where you wanted the output to include something extra
or both. You might do something like:

	For testing dark-rooms:
	    let r be a random dark room;
	    let label be "dark room has a container";
	    if r is nowhere, for "[label] (got nowhere)" fail;
	    for label assert r encloses a container.

Chapter Testing printed output, including errors

If you want to test phrases' output, use the test say-phrase. It can be passed a phrase invocation or a complete conditional, but it cannot be passed just a value. Any variables local to your For testing rule won't be available; don't make assignments in your phrase. For example:

for "inv-test" assert "[test follow the the print standard inventory rule]" rmatches "the rubber ducky";

For sayable values, you don't need to use ``test``.

for "entry 0 error" assert "[entry 0 of empty-l]" reports an error;

``<text> reports an error`` is true if the text includes a newline character followed by three asterisks and a space. 

Chapter Output Result

The output for the results is determined by the ``output result`` phrase property on the relevant unit test.
You can see simple-output-result and original-output-result in the code for working examples. The following
values and say phrases provide the ingredients to build your own:

Values:
- ut-assert (truth state) true if it was an assertion; false if it was a refutation
- ut-truth-state (truth state) true if it was a conditional or boolean; false if it was a comparison
- ut-result (truth state) true if passed; false if failed

Suppose that ``say foo 123`` produces ``123 out of range for foo``.

	for "foo 123" assert "[foo 123]" exactly matches "123";
	for "foo 123 error" assert previous reported error;

*Both* of these will fail. ``"[foo 123]"`` was never actually said, so it didn't
end up captured so that ut-test-output could find it. In this case:

	for "foo 123 error" assert "[foo 123]" rmatches "^\*\*";

would be better.
    
Say phrases:
- ut-expected:
  - for comparisons: the expected (right hand side of the comparison) value
  - for conditional/booleans: if it was a refutation, false; if it was an assertion, true.
- ut-found:
  - if using the test say-phrase, all output
  - otherwise:
    - for comparisons, the found (left hand side of the comparison) value
    - for conditional/booleans, the same as ut-expected if the test passed;
    the opposite of ut-expected if the test failed
- ut-how-tested: the text "Asserted" or "Refuted".
- ut-operator: if it was a comparison, a textual representation of the operator
- ut-opposite: if it was a comparison, a textual representation of the opposite of the operator
  (i.e., instead of <, ==, >, it would be >=, <>, <=, respectively)

It's a phrase text -> nothing; it automatically receives as a parameter the text value
specified in ``for <label>``.

You can set a custom phrase as the default for all unit tests:

	The output result of a unit test is usually custom-output-result.

Or create subkinds of unit tests that have different defaults:

	Verbose unit test is a kind of unit test.
	The output result of a verbose unit test is usually verbose-output-result.
	Terse unit test is a kind of unit test.
	The output result of a terse unit test is usually terse-output-result.

Or set a custom phrase on a per unit test basis:

	Complicated phrase trial is a unit test.
	The output result of complicated phrase trial is complicated-output-result.

Since the granularity is at the unit test level, all test statements in rules
associated with some given unit test must all use the same output result phrase.
If you find you want different output result phrases for some of them, move them
to a different unit test with a different output result phrase.

Chapter Test commands

Otherwise you can enter the command ``test suite`` or ``utest``.

The ``utest`` command can also take an argument. It will run all unit tests whose object
names begin with the argument given, so if you choose common prefixes for the names of
related unit tests, you can easily run those together, e.g.,

	person-wearing is a unit test. [...]
	person-carrying is a unit test. [...]

	[...]

	> utest person            

Chapter Use Options

Section Less Verbose

You can omit details about successful tests with:

	Use don't report passing tests.

Section Test Automatically

There is a "test automatically" use option. You can include:

	Use test automatically.

and all tests will be run on startup. 

Section Quit after autotesting

	Use quit after autotesting.

Quits the game after testing. It does nothing unless test automatically is also active.

Section Test quietly (for use with Text Capture by Eric Eve)
	Use test quietly.
Suppresses any text output the assertions' and refutations' operations would normally produce.
If Text Capture is not included, this Use option doesn't get defined and mention of it would
cause a compilation error.

Chapter Text comparisons

If you have this:

To say ab: say "x";
To say cd: say "x";
To say xx: say "xx";

all of these are false:

if "[ab]" is "[cd]" [...]
let t be "[ab]";
if t is "[ab]" [...]
if "[ab]" is "[ab]" [...]

but the following are true:

if "x" is "[ab]" [...]
if "[cd]" is "x" [...]
if the substituted form of "[ab]" is the substituted form of "[cd]" [...]
if "[ab]" exactly matches the text "[cd]" [...]
if "[ab]" matches the text "x" [...]
if "[ab]" matches the text "[ab]" [...]
if "[ab]" matches the text "[cd]" [...]
if "[xx]" matches the text "[ab]" [...]
if "[ab]" matches the regular expression "[cd]" [...]

In old versions of I7, text and indexed text were separate types. Only texts
could include substitutions; indexed texts were some particular static string.
Subsequently, they were collapsed together (you can still use "indexed text"
as a synonym for "text") but they continue to have different underlying representations.

When you test whether a text containing substitutions *is* a text that doesn't,
I7 automatically takes the substituted form of the text containing substitutions.
But when you test whether a text containing a substitution *is* a text containing
another substitution, the answer doesn't depend on whether the evaluations of the
two texts are the same, but on whether the underlying function representing it is
the same. Outside of contrived circumstances, this will be false. That's why we
have the ``substituted form of`` and ``exactly matches the text`` phrases. (I avoid
using "is" in text comparisons unless there's a text literal on one side.)

Additionally, if a text T contains a substitution, ``if T is empty`` is always
false, whether or not the substituted form of T is empty.

All of ``exactly matches the text``, ``matches the text``, and ``matches the
regular expression`` automatically take the substituted forms of the texts.

But to make writing tests easier, you can use ``if T1 == T2`` and it acts like
``if T1 exactly matches the text T2``. And you can use ``if T1 is blank`` and
that acts like ``if T1 exactly matches the text ""``.

The phrase

if <text1> matches the text <text2>

is true if text2 occurs anywhere within text 1. So these are all true:

If "banana" matches the text "b"
If "banana" matches the text "an"
If "banana" matches the text "anana"

This is awkwardly non-parallel to similar phrases to compare snippets and topics,
where

if <snippet> matches <topic>

is true only if it's an exact match, and

if <snippet> includes <topic> is true if the topic occurs anywhere within the
snippet, like the behavior of ``matches the text``.

So this extension includes the following phrases, that correspond to the behavior
of snippets and topics:

if <text1> exactly matches <text2>
if <text1> includes <text2>

(There are also ``does not exactly match`` and ``does not include``.) This allows you
to forget about ``matches the text`` and to always use ``exactly matches`` and ``includes``
and to get the same behavior.

Existing phrases are unchanged.

Further, it includes the following just to reduce the verbosity of regular expression
usage:

if <text> rmatches <text of a regexp> [ = if <text> matches the regular expression <text of a regexp> ]
let t1 be match 1 [ = text matching subexpression 1 ]
let t0 be match 0 [ = text matching the regular expression ]

Beware that the values of the matches only persist until the next regular expression operation, so store
the results of a regexp match before trying to use ``exactly matches`` to test them.

Chapter Prior art

Section Other unit testing extensions

[Unit Testing by Nathanael Marion](https://gitlab.com/Natrium729/extensions-inform-7/-/blob/master/Unit%20Testing.i7x)
[Unit Testing by Peter Orme](https://github.com/i7/extensions/blob/master/Peter%20Orme/Unit%20Testing.i7x)
[Checkpoints by Peter Orme](https://github.com/i7/extensions/blob/master/Peter%20Orme/Checkpoints.i7x) (includes Unit Testing by Peter Orme)
[Command Unit Testing by Xavid](https://github.com/i7/extensions/blob/master/Xavid/Command%20Unit%20Testing.i7x)
[I7Spec by Jeff Nyman](https://github.com/jeffnyman/exploring-testing/blob/master/Learning.materials/Extensions/Jeff%20Nyman/i7Spec.i7x)

Section of related interest

[Object Response Tests by Juhana Leinonen](https://github.com/i7/extensions/blob/master/Juhana%20Leinonen/Object%20Response%20Tests.i7x)
[Benchmarking by Dannii Willis](https://github.com/i7/extensions/blob/master/Dannii%20Willis/Benchmarking.i7x)
[profile-analyze.py](https://github.com/erkyrath/glulxe/blob/master/profile-analyze.py)

Section for 6G60

[Simple Unit Tests by Dannii Willis](https://github.com/i7/extensions/blob/master/Dannii%20Willis/Simple%20Unit%20Tests.i7x) 
[Automated Testing by Kerkerkruip](https://github.com/i7/kerkerkruip/blob/master/Kerkerkruip.materials/Extensions/Kerkerkruip/Automated%20Testing.i7x)
[Automated Testing by Roger Carbol](https://github.com/i7/archive/blob/master/Roger%20Carbol/Automated%20Testing.i7x)

The fundamental mechanism at the heart of Simple Unit Tests ceased working after 6G60, and Kerkerkruip's
Automated Testing depends on Simple Unit Tests. (Despite the names, it and Automated Testing by Roger Carbol
don't appear to be related.)

The design of this extension's interface owes most to Simple Unit Tests and Benchmarking.

Chapter Changelog

v7: put back enough support for Text Capture to reinstate Use test quietly.
    Introduced special-case for texts of == meaning exactly matches and
    ``is blank`` meaning ``is ""``.

v6: ripped out text capture support and the unit test operator value kind of value
    added ``test`` say-phrases and ``reports an error`` phrase.

v5: added heap tracking unit tests, per a contribution by Dannii Willis
    fixed bug by which output was written to the file of results twice
    renamed phrases for saving, restoring state
    eliminated utest rulebook; incorporated functionality into To say test results

v4: support for Text Capture by Eric Eve

v3: Output now done in I7 via output result phrase text -> nothing on unit tests.

v2: Renamed "unit-test" -> "unit test"; completely changed how assertions and refutations
are formed. Incorporated some suggestions and code by Dannii Willis.

Chapter Examples

Example: * Who tests the testers?

	*: "Unit Tests"
	
	Include Unit Tests by Zed Lopez.
	
	Use test automatically.
	
	Lab is a room.
	
	To decide what number is (m - a number) to the (n - a number):
	  if n < 0, decide on -1; [ -1 is designated error result ]
	  if n is zero, decide on 1; [ we're allowing 0 ** 0 == 1 ]
	  let result be m;
	  repeat with i running from 2 to n begin;
	    now result is result * m;
	  end repeat;
	  decide on result;
	
	a hat is a thing.
	the player wears a sweater.
	Conditional-tests is a unit test. "All conditionals all the time.".
	
	for testing conditional-tests:
	if the player wears a hat, for "testing forced pass" pass;
	else for "testing forced fail, so failing is correct)" fail;
	for "player wears sweater (true thus should pass)" assert the player wears a sweater;
	for "player wears hat (false thus should fail)" assert the player wears a hat;
	for "player wears sweater (true thus should fail)" refute the player wears a sweater;
	for "player wears hat (false thus should pass)" refute the player wears a hat;
	
	Power-test-assertion-truths is a unit test. "Power test: asserting truths, should pass".
	Power-test-assertion-lies is a unit test. "Power test: asserting lies; should fail.".
	Power-test-refutation-lies is a unit test. "Power test: refuting lies; should pass".
	Power-test-refutation-truths is a unit test. "Power test: refuting truths; should fail".
	
	Numeric-comparison-assertion-truths is a unit test. "Numeric comparison asserting truths, should pass".
	Numeric-comparison-refutation-lies is a unit test. "Numeric comparison refuting lies, should pass".
	Numeric-comparison-assertion-lies is a unit test. "Numeric comparison asserting lies, should fail".
	Numeric-comparison-refutation-truths is a unit test. "Numeric comparison refuting truths, should fail".
	
	Text-comparison-assertion-truths is a unit test. "Text comparison asserting truths, should pass".
	Text-comparison-assertion-lies is a unit test. "Text comparison asserting lies, should fail".
	Text-comparison-refutation-lies is a unit test. "Text comparison refuting lies, should pass".
	Text-comparison-refutation-truths is a unit test. "Text comparison refuting truths, should fail".
	
	For testing power-test-assertion-truths:
	  for "3^2" assert 3 to the 2 is 9;
	  for "0^0" assert 0 to the 0 is 1;
	  for "2^-1" assert 2 to the -1 is -1;
	  for "0^-1" assert 0 to the -1 is -1;
	  for "0^111" assert 0 to the 111 is 0;
	
	For testing power-test-refutation-lies:
	  for "3^2" refute 3 to the 2 is 27;
	  for "0^0" refute 0 to the 0 is 0;
	  for "2^-1" refute 2 to the -1 is -2;
	  for "0^111" refute 0 to the 111 is 1;
	
	For testing power-test-assertion-lies:
	  for "3^2" assert 3 to the 2 is 27;
	  for "0^0" assert 0 to the 0 is 0;
	  for "2^-1" assert 2 to the -1 is -2;
	  for "0^111" assert 0 to the 111 is 1;
	
	For testing power-test-refutation-truths:
	  for "3^2" refute 3 to the 2 is 9;
	  for "0^0" refute 0 to the 0 is 1;
	  for "2^-1" refute 2 to the -1 is -1;
	  for "0^-1" refute 0 to the -1 is -1;
	  for "0^111" refute 0 to the 111 is 0;
	
	For testing numeric-comparison-assertion-truths:
	  for "5 > 3" assert 5 > 3;
	  for "0 > -1" assert 0 > -1;
	  for "-1 > -2" assert -1 > -2;
	  for "1 == 1" assert 1 == 1;
	  for "1 is 1" assert 1 is 1;
	  for "0 < 111" assert 0 < 111;
	  for "2 < 3" assert 2 < 3;
	  for "-2 < -1" assert -2 < -1;
	  for "3 > -3" assert 3 > -3;
	
	For testing numeric-comparison-refutation-truths:
	  for "5 > 3" refute 5 > 3;
	  for "0 > -1" refute 0 > -1;
	  for "-1 > -2" refute -1 > -2;
	  for "1 == 1" refute 1 == 1;
	  for "1 is 1" refute 1 is 1;
	  for "0 < 111" refute 0 < 111;
	  for "2 < 3" refute 2 < 3;
	  for "-2 < -1" refute -2 < -1;
	  for "3 > -3" refute 3 > -3;
	
	For testing numeric-comparison-assertion-lies:
	  for "2 < 1" assert 2 < 1;
	  for "2 < 2" assert 2 < 2;
	  for "2 < 0" assert 2 < 0;
	  for "2 < -2" assert 2 < -2;
	  for "3 > 3" assert 3 > 3;
	  for "3 > 4" assert 3 > 4;
	  for "0 > 3" assert 0 > 3;
	  for "0 > 0" assert 0 > 0;
	  for "0 < 0" assert 0 < 0;
	  for "-3 < -3" assert -3 < -3;
	  
	For testing numeric-comparison-refutation-lies:
	  for "2 < 1" refute 2 < 1;
	  for "2 < 2" refute 2 < 2;
	  for "2 < 0" refute 2 < 0;
	  for "2 < -2" refute 2 < -2;
	  for "3 > 3" refute 3 > 3;
	  for "3 > 4" refute 3 > 4;
	  for "0 > 3" refute 0 > 3;
	  for "0 > 0" refute 0 > 0;
	  for "0 < 0" refute 0 < 0;
	  for "-3 < -3" refute -3 < -3;
	
	To say X: say "X";
	To say X2: say "X";
	To say Y: say "Y";
	
	To say lbrack: say bracket.
	To say rbrack: say close bracket.
	
	For testing text-comparison-assertion-truths:
	  for "'X' is 'X'" assert "X" is "X";
	  for "'X' < 'Y'" assert "X" < "Y";
	  for "'Y' > 'X'" assert "Y" > "X";
	  for "[lbrack]X[rbrack] exactly matches X" assert "[X]" exactly matches "X";
	  for "[lbrack]X[rbrack] exactly matches [lbrack]X2[rbrack]" assert "[X]" exactly matches "[X2]";
	  for "[lbrack]X[rbrack] does not exactly match [lbrack]Y[rbrack]" assert "[X]" does not exactly match "[Y]";
	  for "'banana' rmatches '(an)+'" assert "banana" rmatches "(an)+";
	  let m0 be match 0;
	  let m1 be match 1;
	  for "match 0 exactly matches anan" assert m0 exactly matches "anan";
	  for "match 1 exactly matches an" assert m1 exactly matches "an";
	  
	For testing text-comparison-refutation-truths:
	  for "1 is not 2" refute "1" is not "2";
	  for "'X' is 'X'" refute "X" is "X";
	  for "'X' < 'Y'" refute "X" < "Y";
	  for "'Y' > 'X'" refute "Y" > "X";
	  for "[lbrack]X[rbrack] exactly matches X" refute "[X]" exactly matches "X";
	  for "[lbrack]X[rbrack] exactly matches [lbrack]X2[rbrack]" refute "[X]" exactly matches "[X2]";
	  for "[lbrack]X[rbrack] does not exactly match [lbrack]Y[rbrack]" refute "[X]" does not exactly match "[Y]";
	  for "'banana' rmatches '(an)+'" refute "banana" rmatches "(an)+";
	  let m0 be match 0;
	  let m1 be match 1;
	  for "match 0 exactly matches anan" refute m0 exactly matches "anan";
	  for "match 1 exactly matches an" refute m1 exactly matches "an";
	
	For testing text-comparison-refutation-lies:
	  for "[lbrack]X[rbrack] does not exactly match [lbrack]X2[rbrack]" refute "[X]" does not exactly match "[X2]";
	  for "[lbrack]X[rbrack] exactly matches [lbrack]Y[rbrack]" refute "[X]" exactly matches "[Y]";
	  for "'A' > 'B'" refute "A" > "B";
	  for "'B' < 'A'" refute "B" < "A";
	  for "'A' > 'A'" refute "A" > "A";
	  for "'A' > 'A'" refute "A" > "A";
	  for "'B' is 'A'" refute "B" is "A";
	
	For testing text-comparison-assertion-lies:
	  for "[lbrack]X[rbrack] does not exactly match [lbrack]X2[rbrack]" assert "[X]" does not exactly match "[X2]";
	  for "[lbrack]X[rbrack] exactly matches [lbrack]Y[rbrack]" assert "[X]" exactly matches "[Y]";
	  for "'A' > 'B'" assert "A" > "B";
	  for "'B' < 'A'" assert "B" < "A";
	  for "'A' > 'A'" assert "A" > "A";
	  for "'A' > 'A'" assert "A" > "A";
	  for "'B' is 'A'" assert "B" is "A";
	
	[ A phrase to be tested ]
	To say (T - a text) backwards:
	    let len be the number of characters in T + 1;
	    repeat with i running from 1 to the number of characters in T begin;
	      say character number len - i in T;
	    end repeat;
	
	Backwards-test is a unit test. "Saying text backwards"
	
	Text-scratch is initially "";
	
	For testing backwards-test:
	 let orig be "schmoop";
	 For "'schmoop' backwards" assert "[orig backwards]" exactly matches "poomhcs";
	
	empty-list is a list of numbers that varies.
	empty-list is initially {}.
	
	Error-test is a unit test. "Detecting an error"
	
	For testing error-test:
	  for "can't get entry 0" assert "[test entry 0 of empty-list is 0]" reports an error;
	
	The player carries a rubber ducky.
	
	Rubber-ducky-test is a unit test. "Ducky possession".
	
	For testing rubber-ducky-test:
	  for "inv-test" assert "[test follow the print standard inventory rule]" rmatches "rubber ducky";
