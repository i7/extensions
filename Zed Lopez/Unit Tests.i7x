Version 4 of Unit Tests by Zed Lopez begins here.

"Yet another Unit Tests extension. Tested with 6M62."

Volume Unit Tests (not for release)

Part Output file

The file of results is called "utresults".

Part Improbable

To decide what number is improbable number: (- IMPROBABLE_VALUE -).

Part Use Options

Chapter Test Automatically

Use test automatically translates as (- Constant TEST_AUTOMATICALLY; -).

Last when play begins (this is the test all unit tests automatically rule):
  if test automatically option is active, test all unit tests.

Section Quit Afterwards

Use quit after autotesting translates as (- Constant QUIT_AFTER_AUTOTESTING; -).

Chapter Write to file

Use write test results to file translates as (- Constant WRITE_TEST_RESULTS_TO_FILE; -).

First when play begins when write test results to file option is active:
  write "" to file of results.

Chapter Don't Report passing tests

Use don't report passing tests translates as (- Constant DONT_REPORT_PASSING_TESTS; -).

Chapter Quiet please (for use with Text Capture by Eric Eve)

Use test quietly translates as (- Constant TEST_QUIETLY; -).

Part Undo

To decide what number is the/a/-- result of saving before running the/-- unit test:
(- VM_Save_Undo() -).

To restore back to before running the/-- unit test:
(- VM_Undo(); -).

Part unit test object

A unit test is a kind of object.
A unit test has a text called the description.

The current unit test is a unit test that varies.

A unit test operator value is a kind of value.
A unit test operator value has a text called the description.

ut-lt is a unit test operator value. "<". [1]
ut-eq is a unit test operator value. "==".[2]
ut-gt is a unit test operator value. ">". [3]
ut-ge is a unit test operator value. ">=".[4]
ut-ne is a unit test operator value. "!=". [5]
ut-le is a unit test operator value. "<=". [6]

To say the/a/an/-- (uto - a unit test operator value): say the description of uto.

A unit test operator value has a unit test operator value called the opposite operator.
The opposite operator of ut-eq is ut-ne.
The opposite operator of ut-ne is ut-eq.
The opposite operator of ut-lt is ut-ge.
The opposite operator of ut-ge is ut-lt.
The opposite operator of ut-gt is ut-le.
The opposite operator of ut-le is ut-gt.
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

Chapter Stash (for use with Text Capture by Eric Eve)

To stash unit test output (this is ut-stash):
  now ut-test-output is the expanded "[captured text]";
  unless the test quietly option is active, output ut-test-output;

Chapter Fake Stash (for use without Text Capture by Eric Eve)

To stash unit test output (this is ut-stash):
  do nothing.

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
-) after "Definitions.i6t".

ut-assert is a truth state variable.
ut-assert variable translates into I6 as "ut_assert".

ut-truth-state is a truth state variable.
ut-truth-state variable translates into I6 as "ut_truth_state".

ut-op is a number variable.
ut-op variable translates into I6 as "ut_operator".

ut-result is a truth state variable.
ut-result variable translates into I6 as "ut_result".

ut-test-output is initially "".

Unit test success is a number variable.
Unit test success variable translates into I6 as "unit_test_success".

Unit test failure is a number variable.
Unit test failure variable translates into I6 as "unit_test_failure".

to decide what unit test operator value is the ut-operator: (- (ut_operator + 2) -).
to decide what unit test operator value is the ut-opposite: (- (ut_operator + 5) -).

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

Part Actions

Chapter unit testing

unit testing is an action out of world.
Understand "utest" as unit testing.

Carry out unit testing (this is the test all unit tests rule): test all unit tests.

Chapter Test all unit tests to-phrase

To test all unit tests: test all unit tests matching "".

Section test all unit tests matching

To say test results for (ut - a unit test):
  follow the utest rules for ut;

To test all unit tests matching (T - a text):
  repeat with ut running through the unit tests begin;
    if T is empty or printed name of ut rmatches "^[T]", case insensitively begin;
      output the substituted form of "[test results for ut]";
    end if;
  end repeat;
  if the test automatically option is active and the quit after autotesting option is active, follow the immediately quit rule;
  
Chapter Test command

[ ``> test suite`` can be used instead of ``> utest`` ]
Test suite with "utest".

Chapter Specific-utesting

Specific-utesting is an action out of world applying to one topic.
Understand "utest [text]" as specific-utesting.

Section Carry out specific-utesting

Carry out specific-utesting (this is the carry out unit testing via utest command rule):
  test all unit tests matching "^[the topic understood]"

Part Assertions

[ a rulebook wraps around an activity because restoring from save was taking us back
  to the middle of the previous activity, and because this guarantees a user-defined
  before rule can't beat us to first. ]

Part Utest rulebook

Utest is a unit test based rulebook.

Chapter Setup test

First utest a unit test (called ut) (this is the unit test setup rule):
  now current unit test is ut;
  now unit test success is 0;
  now unit test failure is 0;
  say "[line break]Testing [ut][line break]";
  if the result of saving before running the unit test is 2, stop;

Chapter Utest rule to carry out testing activity (for use with Text Capture by Eric Eve)

Utest a unit test (called ut) (this is the carry out a unit test rule):
  start capturing text;
  carry out the testing activity with ut;
  stop capturing text;

Chapter Utest rule to carry out testing activity (for use without Text Capture by Eric Eve)

Utest a unit test (called ut) (this is the carry out a unit test rule):
  carry out the testing activity with ut;
  
Chapter Test results

Utest a unit test (called ut) (this is the unit test reporting rule):
  let total test count be unit test success + unit test failure;
  let summary be "[if unit test failure > 0]**[else]  [end if] [unit test success]/[total test count] passed[if unit test failure is 0].[else]; [unit test failure]/[total test count] failed.[end if][line break]";
  output summary;
  
Chapter Cleanup

Utest a unit test (this is the unit test cleanup rule):
  restore back to before running the unit test;

Part Testing something activity

[ no pre-defined rules: this is for authors to define rules for their tests ]
Testing something is an activity on unit tests.

Include (-

[ utTruth x;
  if (x) print "true";
  else print "false";
  ];

[ utAssertPlain x assert txt;
  EndCapture();
  ((+ ut-stash +)-->1)();
  ut_truth_state = 1;
print "found: ", x, " assert: ", assert, "^";
  ut_found = x;
  ut_result = 0;
  if ((~~x) == (~~assert)) ut_result = 1;
  ut_assert = assert;
  utFinish(txt);
];

[ utAssert x y k cmp_target assert txt cmp;
  EndCapture();
  ((+ ut-stash +)-->1)();
  ut_result = 0;
  ut_operator = cmp_target;
  if (k) { cmp = KOVComparisonFunction(k); ut_kind = k; }
  if (k == NUMBER_TY) cmp = utSignedCompare;
  if (assert == (utSimpleCmp(cmp(x,y))==cmp_target)) ut_result = 1;
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

[ utSimpleCmp x;
  if (x > 0) return 1;
  if (x < 0) return -1;
  return 0;
  ];

-).




To output (T - a text):
  say T;
  if write test results to file option is active, append T to file of results;

To say captured output of current unit test result for (T - a text): 
  apply output result of current unit test to T.

To report current unit test result for (T - a text) (this is output-result):
  let result be "[if ut-result is true]  [else]**[end if] [captured output of current unit test result for T]";
  output result;

Chapter Fake I6 Stubs (for use without Text Capture by Eric Eve)

Include (-
[ EndCapture; ];
[ StartCapture; ];
-)

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

To for (txt - a text) assert (X - value of kind K) is/== (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},0,1,{txt}); -)

Chapter greater than
  
To for (txt - a text) assert (X - value of kind K) > (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},1,1,{txt}); -).

Chapter less than
  
To for (txt - a text) assert (X - value of kind K) < (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},-1,1,{txt}); -).

Part Refutations

Chapter boolean (for use with If True by Zed Lopez)

To for (txt - a text) refute (X - value of kind K):
  (- utAssertPlain({X},{-strong-kind:K},0,{txt}); -).

Chapter conditional

To for (txt - a text) refute (C - a condition):
  (- {-my:1} = 0; if ({C}) {-my:1} = 1; utAssertPlain({-my:1},0,{txt}); -).

Chapter equality
    
To for (txt - a text) refute (X - value of kind K) is/== (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},0,0,{txt}); -).

Chapter greater than
  
To for (txt - a text) refute (X - value of kind K) > (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},1,0,{txt}); -).

Chapter less than
  
To for (txt - a text) refute (X - value of kind K) < (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},-1,0,{txt}); -).

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

The values must be of compatible kinds. 

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

Chapter Output Result

The output for the results is determined by the ``output result`` phrase property on the relevant unit test.
You can see simple-output-result and original-output-result in the code for working examples. The following
values and say phrases provide the ingredients to build your own:

Values:
- ut-assert (truth state) true if it was an assertion; false if it was a refutation
- ut-truth-state (truth state) true if it was a conditional or boolean; false if it was a comparison
- ut-result (truth state) true if passed; false if failed

Additionally, if Text Capture by Eric Eve is included:

- ut-test-output (text) anything the operation would have printed to the screen
  (it will be output automatically unless Use test quietly is active)
    
Say phrases:
- ut-expected:
  - for comparisons: the expected (right hand side of the comparison) value
  - for conditional/booleans: if it was a refutation, false; if it was an assertion, true.
- ut-found:
  - for comparisons, the found (left hand side of the comparison) value
  - for conditional/booleans, the same as ut-expected if the test passed;
    the opposite of ut-expected if the test failed
- ut-how-tested: the text "Asserted" or "Refuted".
- ut-operator: if it was a comparison, a textual representation of the operator
- ut-opposite: if it was a comparison, a textual representation of the opposite of the operator
  (i.e., instead of <, ==, >, it would be >=, !=, <=, respectively)

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

Chapter Text Capture

If you want to test your assertions' and refutations' printed output you should include Text
Capture by Eric Eve. With it included, each test statement's output is saved to a global text
variable called ut-test-output.

You may want to avoid putting say statements in your unit tests, though, as they'll get captured,
too.

	let L be {0};
	for "out of range" assert entry 2 of L is 0;
	let err be ut-test-output;
	for "out of range error" assert err rmatches "^\*\*";

for "statement that can produce error" assert erroneous is true
for "error message test" 


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
the same. This can be hard to predict. That's why we have the ``substituted form of``
and ``exactly matches the text`` phrases. (I avoid using "is" in text comparisons
unless there's a text literal on one side.)

All of ``exactly matches the text``, ``matches the text``, and ``matches the
regular expression`` automatically take the substituted forms of the texts.

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

Beware that the values of the matches only persist until the next regular expression operation, and
``exactly matches the text`` and ``matches the text`` (and thus ``exactly matches`` and ``includes``
for text as defined here) *are* regular expression operations under the hood. So store the results of
a regexp match before trying to use ``exactly matches`` to test them.

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

v4: support for Text Capture by Eric Eve

v3: Output now done in I7 via output result phrase text -> nothing on unit tests.

v2: Renamed "unit-test" -> "unit test"; completely changed how assertions and refutations
are formed. Incorporated some suggestions and code by Dannii Willis.

Chapter Examples

Example: * Who tests the testers?

	"Unit Tests"
	
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
	
	Power-test-assertion-truths is a unit test. "Power test assertions, true."
	Power-test-assertion-lies is a unit test. "Power test assertions, false statements".
	Power-test-refutation-truths is a unit test. "Power test refutations, true statements".
	Power-test-refutation-lies is a unit test. "Power test refutations, false statements".
	
	Numeric-comparison-assertion-truths is a unit test. "Numeric comparison assertions, true statements".
	Numeric-comparison-refutation-truths is a unit test. "Numeric comparison refutations, true statements".
	Numeric-comparison-assertion-lies is a unit test. "Numeric comparison assertions, false statements".
	Numeric-comparison-refutation-lies is a unit test. "Numeric comparison refutations, false statements".
	
	Text-comparison-assertion-truths is a unit test. "Text comparison assertions, true statements".
	Text-comparison-assertion-lies is a unit test. "Text comparison assertions, false statements".
	Text-comparison-refutation-truths is a unit test. "Text comparison refutations, true statements".
	Text-comparison-refutation-lies is a unit test. "Text comparison refutations, false statements".
	
	For testing power-test-assertion-truths:
	  for "3^2" assert 3 to the 2 is 9;
	  for "0^0" assert 0 to the 0 is 1;
	  for "2^-1" assert 2 to the -1 is -1;
	  for "0^-1" assert 0 to the -1 is -1;
	  for "0^111" assert 0 to the 111 is 0;
	
	For testing power-test-refutation-truths:
	  for "3^2" refute 3 to the 2 is 27;
	  for "0^0" refute 0 to the 0 is 0;
	  for "2^-1" refute 2 to the -1 is -2;
	  for "0^111" refute 0 to the 111 is 1;
	
	For testing power-test-assertion-lies:
	  for "3^2" assert 3 to the 2 is 27;
	  for "0^0" assert 0 to the 0 is 0;
	  for "2^-1" assert 2 to the -1 is -2;
	  for "0^111" assert 0 to the 111 is 1;
	
	For testing power-test-refutation-lies:
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
	
	For testing numeric-comparison-refutation-lies:
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
	  
	For testing numeric-comparison-refutation-truths:
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
	  for "'banana' rmatches '(an)+'" assert "banana" rmatches "(an)+";
	  let m0 be match 0;
	  let m1 be match 1;
	  for "match 0 exactly matches anan" assert m0 exactly matches "anan";
	  for "match 1 exactly matches an" assert m1 exactly matches "an";
	  
	For testing text-comparison-refutation-lies:
	  for "'X' is 'X'" refute "X" is "X";
	  for "'X' < 'Y'" refute "X" < "Y";
	  for "'Y' > 'X'" refute "Y" > "X";
	  for "[lbrack]X[rbrack] exactly matches X" refute "[X]" exactly matches "X";
	  for "[lbrack]X[rbrack] exactly matches [lbrack]X2[rbrack]" refute "[X]" exactly matches "[X2]";
	  for "'banana' rmatches '(an)+'" refute "banana" rmatches "(an)+";
	  let m0 be match 0;
	  let m1 be match 1;
	  for "match 0 exactly matches anan" refute m0 exactly matches "anan";
	  for "match 1 exactly matches an" refute m1 exactly matches "an";
	
	For testing text-comparison-refutation-truths:
	  for "[lbrack]X[rbrack] does not exactly match [lbrack]X2[rbrack]" refute "[X]" does not exactly match "[X2]";
	  for "[lbrack]X[rbrack] does not exactly match [lbrack]Y[rbrack]" refute "[X]" exactly matches "[Y]";
	  for "'A' > 'B'" refute "A" > "B";
	  for "'B' < 'A'" refute "B" < "A";
	  for "'A' > 'A'" refute "A" > "A";
	  for "'A' > 'A'" refute "A" > "A";
	  for "'B' is 'A'" refute "B" is "A";
	
	For testing text-comparison-assertion-lies:
	  for "[lbrack]X[rbrack] does not exactly match [lbrack]X2[rbrack]" assert "[X]" does not exactly match "[X2]";
	  for "[lbrack]X[rbrack] does not exactly match [lbrack]Y[rbrack]" assert "[X]" exactly matches "[Y]";
	  for "'A' > 'B'" assert "A" > "B";
	  for "'B' < 'A'" assert "B" < "A";
	  for "'A' > 'A'" assert "A" > "A";
	  for "'A' > 'A'" assert "A" > "A";
	  for "'B' is 'A'" assert "B" is "A";
	
	[ the phrase to be tested ]
	To say (T - a text) backwards:
	    let len be the number of characters in T + 1;
	    repeat with i running from 1 to the number of characters in T begin;
	      say character number len - i in T;
	    end repeat;
	
	Backwards-test is a unit test. "saying text backwards."
	
	[ the custom say statement added for testing purposes]
	To say backwards-test-output:
	    say "schmoop" backwards;
	
	For testing backwards-test:
	 For "'schmoop' backwards" assert "[backwards-test-output]" exactly matches "poomhcs";
