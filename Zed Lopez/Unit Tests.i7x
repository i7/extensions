Version 2/220318 of Unit Tests by Zed Lopez begins here.

"Yet another Unit Tests extension. Tested with 6M62."

Volume Unit Tests (not for release)

Part Autotest

Use test automatically translates as (- Constant TEST_AUTOMATICALLY; -).
Use don't report passing tests translates as (- Constant DONT_REPORT_PASSING_TESTS = 1; -).

when play begins (this is the test all unit tests automatically rule):
  if test automatically option is active, test all unit tests.

Part Undo

To decide what number is the result of saving before running the unit tests:
(- VM_Save_Undo() -).

To restore back to before running the unit tests:
(- VM_Undo(); -).

Part unit test object

A unit test is a kind of object.
A unit test has a text called the description.
The description of a unit test is usually "".

Chapter Saying unit test

To say (ut - a unit test):
  if the description of ut is "", say "[printed name of ut]";
  else say description of ut.

Part Success and failure counting

[ For easy of sharing info between I7 and I6 these are globals.
  Only one test should be occurring at a time, so it shouldn't
  pose any problem. ]
Include (-
Global unit_test_success;
Global unit_test_failure;
-) after "Definitions.i6t".

Unit test success is a number variable.
Unit test success variable translates into I6 as "unit_test_success".

Unit test failure is a number variable.
Unit test failure variable translates into I6 as "unit_test_failure".

Part Actions

Chapter unit testing

unit testing is an action out of world.
Understand "utest" as unit testing.

Carry out unit testing (this is the test all unit tests rule): test all unit tests.

Section Test all unit tests to-phrase

[ also used in the test all unit tests automatically rule]
To test all unit tests:
  repeat with ut running through the unit tests begin;
    follow the utest rules for ut;
  end repeat;

Chapter Test command

[ ``> test suite`` can be used instead of ``> utest`` ]
Test suite with "utest".

Chapter Specific-utesting

Specific-utesting is an action out of world applying to one topic.
Understand "utest [text]" as specific-utesting.

Section Carry out specific-utesting

Carry out specific-utesting (this is the carry out unit testing via utest command rule):
  let txt be "[the topic understood]";
  repeat with ut running through the unit tests begin;
    if printed name of ut rmatches "^[txt]", case insensitively begin;
      follow the utest rules for ut;
    end if;
  end repeat;

Part Assertions

[ a rulebook wraps around an activity because restoring from save was taking us back
  to the middle of the previous activity, and because this guarantees a user-defined
  before rule can't beat us to first. ]

Part Utest rulebook

Utest is a unit test based rulebook.
[The utest rulebook has a number called the total test count.]

Chapter Setup test

First utest a unit test (called ut) (this is the unit test setup rule):
  now unit test success is 0;
  now unit test failure is 0;
  say "[line break]Testing [ut][line break]";
  if the result of saving before running the unit tests is 2, stop;

Chapter Utest rule to carry out testing activity

Utest a unit test (called ut) (this is the carry out a unit test rule):
  carry out the testing activity with ut;

Chapter Test results

Utest a unit test (called ut) (this is the unit test reporting rule):
  let total test count be unit test success + unit test failure;
  say "[unit test success]/[total test count] passed[if unit test failure is 0].[else]; [unit test failure]/[total test count] failed.[end if]";

Chapter Cleanup

Utest (this is the unit test cleanup rule):
  restore back to before running the unit tests;

Part Testing something activity

[ no pre-defined rules: this is for authors to define rules for their tests ]
Testing something is an activity on unit tests.

[ utPlainSuccess x assert expected;
  expected = x;
  if (~~assert) expected = ~~x;  
  print "and found "; utTruth(expected);
];
[!  if (pass) { print "and found "; utTruth(expected); }
!  else {   utTruth(x);
!  print ", found ";
!  utTruth(~~x);
]
[ utPlainFailure x assert expected;
  expected = x;
  if (~~assert) expected = ~~x;  
  utTruth(x);
  print "and found "; 
  utTruth(expected);
];



Include (-

[ utAssertPlain x k assert txt err pass;
  pass = 0;
  if ((x && assert) || (~~x && ~~assert)) pass = 1;
  ut_truth_state = 1;
  ut_expected = assert;
  utFinish(x, 0, k, 0, assert, txt, err, pass);
  ];

[ utAssert x y k cmp_target assert txt err cmp pass;
  pass = 0;
  if (k) cmp = KOVComparisonFunction(k);
  if (k == NUMBER_TY) cmp = utSignedCompare;
  if (assert == (utSimpleCmp(cmp(x,y))==cmp_target)) pass = 1;
  ut_truth_state = 0;
  ut_expected = y;
  utFinish(x, y, k, cmp_target, assert, txt, err, pass);

];

[ UtFinish x y k cmp_target assert txt err pass;
  ut_found = x;
if (pass) {
  unit_test_success++;
#ifndef DONT_REPORT_PASSING_TESTS;
  utPreface(assert,txt);
  print "expected ";
  if (ut_truth_state) utPlainResult(x, assert, pass);
  else utSuccessCmp(x, y, k, cmp_target, assert);
  print " (pass)^";
#endif;
}
else {
  unit_test_failure++;
  utPreface(assert,txt);
  if (err) {
    TEXT_TY_Say(err);
  }
  else {
  print "expected ";
  if (ut_truth_state) utPlainResult(x, assert, pass);
  else utFailureCmp(x, y, k, cmp_target, assert);
  }
  print " (fail)^";
}
];

[ stringarray buf
i ;
if (buf == NULL) { print "<NULL>"; return; }
  for (i=1:i<=buf->0:i++ ) print (char) buf->i;
];

[ utPreface assert txt;
  if (assert) { print "Asserted "; }
  else { print "Refuted "; }
  TEXT_TY_say(txt);
  print ": ";
  ];

[ utPlainResult x assert pass expected;
  expected = x;
  if (~~pass) expected = ~~x;  
  if (pass) { print "and found "; utTruth(expected); }
  else {   utTruth(x);
  print ", found ";
  utTruth(~~x);
}
];


[ utTruth x;
  if (x) print "true";
  else print "false";
  ];

[ utSuccessCmp x y k cmp_target assert;
  print "expected ";
  if (~~cmp_target) {
    if (assert) print "and found ";
    else print "other than ";
    PrintKindValuePair(k, y);
    if (~~assert) {
      print ", found "; 
      PrintKindValuePair(k, x);
    }
return;
}
      if (assert) {
      if (cmp_target > 0) { print "> "; }
      else if (cmp_target < 0) { print "< "; }
} else {
      if (cmp_target > 0) { print "<= "; }
      else if (cmp_target < 0) { print ">= "; }
}
      PrintKindValuePair(k, y);
      print ", ";
    print "found ";
    PrintKindValuePair(k, x);
    ];

[ utFailureCmp x y k cmp_target assert txt err;
      if (assert) {
      if (cmp_target > 0) { print "> "; }
      else if (cmp_target < 0) { print "< "; }
      }
      else {
      if (cmp_target > 0) { print "<= "; }
      else if (cmp_target < 0) { print ">= "; }
      else if (cmp_target == 0) print "other than ";
}      PrintKindValuePair(k, y);
      print ", found: ";
      PrintKindValuePair(k, x);
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

-)

To say ut-expected: (- if (ut_truth_state) { utTruth(ut_expected); } else { PrintKindValuePair(ut_kind, ut_expected); } -).
To say ut-found: (- PrintKindValuePair(ut_kind, ut_found); -).

Include (-
Global ut_expected;
Global ut_found;
Global ut_kind;
Global ut_truth_state;
-) after "Definitions.i6t".


Volume Assertions and Refutations

Book Assertions

Part boolean (for use with If True by Zed Lopez)

To for (txt - a text) assert (X - value of kind K):
  (- utAssertPlain({X},{-strong-kind:K},1,{txt}); -).

To for (txt - a text) assert (X - value of kind K) or say/-- (err - a text):
  (- utAssertPlain({X},{-strong-kind:K},1,{txt},{err}); -).


Part conditional

To for (txt - a text) assert (C - a condition) or say/-- (err - a text):
  (- {-my:1} = 0; if ({C}) {-my:1} = 1; utAssertPlain({-my:1},0,1,{txt},{err}); -).

To for (txt - a text) assert (C - a condition):
  (- {-my:1} = 0; if ({C}) {-my:1} = 1; utAssertPlain({-my:1},0,1,{txt}); -).

Part equality

To for (txt - a text) assert (X - value of kind K) is/== (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},0,1,{txt}); -).

To for (txt - a text) assert (X - value of kind K) is/== (Y - K) or say/-- (err - a text):
  (- utAssert({X},{Y},{-strong-kind:K},0,1,{txt},{err}); -).

Part greater than

To for (txt - a text) assert (X - value of kind K) > (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},1,1,{txt}); -).

To for (txt - a text) assert (X - value of kind K) > (Y - K) or say/-- (err - a text):
  (-  utAssert({X},{Y},{-strong-kind:K},1,1,{txt},{err}); -).

Part less than

To for (txt - a text) assert (X - value of kind K) < (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},-1,1,{txt}); -).

To for (txt - a text) assert (X - value of kind K) < (Y - K) or say/-- (err - a text):
  (- utAssert({X},{Y},{-strong-kind:K},-1,1,{txt},{err}); -).

Book Refutations

Part boolean (for use with If True by Zed Lopez)

To for (txt - a text) refute (X - value of kind K):
  (- utAssertPlain({X},{-strong-kind:K},0,{txt}); -).

To for (txt - a text) refute (X - value of kind K) or say/-- (err - a text):
  (- utAssertPlain({X},{-strong-kind:K},0,{txt},{err}); -).

Part conditional

To for (txt - a text) refute (C - a condition) or say/-- (err - a text):
  (- {-my:1} = 0; if ({C}) {-my:1} = 1; utAssertPlain({-my:1},0,0,{txt},{err}); -).

To for (txt - a text) refute (C - a condition):
  (- {-my:1} = 0; if ({C}) {-my:1} = 1; utAssertPlain({-my:1},0,0,{txt}); -).

Part equality

To for (txt - a text) refute (X - value of kind K) is/== (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},0,0, {txt}); -).

To for (txt - a text) refute (X - value of kind K) is/== (Y - K) or say/-- (err - a text):
  (- utAssert({X},{Y},{-strong-kind:K},0,0, {txt},{err}); -).

Part greater than

To for (txt - a text) refute (X - value of kind K) > (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},1,0, {txt}); -).

To for (txt - a text) refute (X - value of kind K) > (Y - K) or say/-- (err - a text):
  (- utAssert({X},{Y},{-strong-kind:K},1,0, {txt},{err}); -).

part less than

To for (txt - a text) refute (X - value of kind K) < (Y - K):
  (- utAssert({X},{Y},{-strong-kind:K},-1,0, {txt}); -).

To for (txt - a text) refute (X - value of kind K) < (Y - K) or say/-- (err - a text):
  (- utAssert({X},{Y},{-strong-kind:K},-1,0, {txt},{err}); -).

Volume Other interactions

Part Captured (for use with Text Capture by Eric Eve)

A unit test can be text-capturing.

Before testing a text-capturing unit test (called ut):
  start capturing text.    

Last for testing a text-capturing unit test: stop capturing text.

Part text comparisons (For use without Textile by zed lopez)

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

To test your game as a whole, I recommend using Andrew Plotkin's [RegTest](https://eblong.com/zarf/plotex/regtest.html). The latest is available in [the plotex Github repo](https://github.com/erkyrath/plotex/blob/master/regtest.html).

But if you're testing code in isolation that isn't about accepting player commands or producing player-visible output, RegTest isn't the most natural fit. This extension was written for those cases.

A unit test is a kind of object, with a text description property, which should
be populated for the test to identify itself. (It *can* be left blank, in which
case the test falls back on the object name itself.) Because the property is
"description" it can be specified with just a stand-alone string immediately
following the object definition.

	Math-still-works is a unit test. "Whether math still works".

``Testing`` is an activity on unit tests. For the test to do anything useful,
you must define a corresponding ``For testing`` rule:

	For testing math-still-works:
		assert 2 + 2 is 4 or "Math is broken.";

(More about assert statements later.)

If you have setup to do, a ``Before testing`` rule is a good place for it. But
you may need to establish global variables or activity variables for the ``For testing``
and/or ``After testing`` rules to have access to information set up in the Before rule.

If there's more reporting you want, you might use an ``After testing`` rule. But you shouldn't
need to do any teardown: unit tests are idempotent. They save the game state before they
start, and restore when they're finished. (On glulx one can protect memory from being
clobbered by a restore, so make that *mostly* idempotent, but at any rate, it should be fairly
difficult for one test to screw up the environment for another.)

This means that you also can't share context between different tests... but you can make the
same Before rule apply to more than one test. (You can have multiple ``for testing`` rules
for the same unit test, using ``continue the activity``, but those would be treated as the
same test.)

	Before testing a unit test (called ut) when ut is test1 or ut is test2:

And don't have one test invoke another: the save-state in the inner test's Before testing
rule would clobber the outer test's state, so when the outer test restored state, it would
restore state as of the beginning of the inner test, not the outer test.

Chapter Assertions and Refutations

assert/refute statements are the heart of testing. It technically doesn't matter where they
occur in the activity, but the intent is that they be used in For Testing rules. There are
several varieties:

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

Or, if you've included If True by Zed Lopez, a plain truth state value.

	for <label> assert <truth state value>
	for <label> refute <truth state value>

In most cases, the default success/failure messages should be adequate, but
you can provide an alternative by adding something like the example below to
the end of any assertion or refutation. There are say phrases to provide
``expected`` and ``found``. If the assertion or refutation was in regard to
a conditional or a truth state, expected is "true" for assertions and "false"
for refutations.

	[...] or "We expected [expected] but got [found]"

for <label> assert <condition> 
for <label> refute <condition> or <text of message to be printed on failure>
for <label> assert <condition> or <text of message to be printed on failure>
for <label> refute <condition> or <text of message to be printed on failure>

If you create a unit test object, you should write a corresponding For testing activity rule
which should include at least one assertion or refutation. This isn't enforced. If you don't
have any assertions, the test will run and report 0/0 Passed.

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
I7 automatically takes the substituted form of the text containing adaptive text.
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

So this extension includes these phrases, that correspond to the behavior of
snippets and topics:

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

Chapter Testing printed output

Most unit test extensions include Text Capture by Eric Eve to facilitate testing output. But much
of the time you can make do by wrapping things in a say statement constructed for the purpose.

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
 For "'schmoop' backwards matches 'poomhcs'" assert "[backwards-test-output]" exactly matches "poomhcs";

This is a trivial example: we could have tested ``To say <T> backwards`` directly. But it illustrates
the point that a custom say phrase can capture other phrases' output.

Section Text-capturing unit tests for use with Text Capture by Eric Eve

But if your game *does* include Text Capture, Unit Tests adds a text-capturing
property to unit tests and, for them, starts capturing text in a Before testing rule and
stops capturing text in a ``Last for testing`` rule, so it becomes crucial to restrict
assertions and refutations until ``After testing`` rules for text-capturing unit tests.

So you could then have:

backwards-test-input is always "doowyc3".
For testing backwards-capture-test:
  say backwards-test-input backwards.

After testing backwards-capture-test:
  let expected be "3cywood";
  for "doowyc3 backwards" assert "[captured text trimmed]" exactly matches "3cywood";

Chapter Test Automatically

There is a "test automatically" use option. You can include:

Use test automatically.

and all tests will be run on startup. Otherwise you can enter the command ``test suite`` or ``utest``.

Chapter Less Verbose

You can omit details about successful tests with:

	Use don't report passing tests.

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

The fundamental mechanism at the heart of Simple Unit Tests ceased working after 6G60, and Automated Testing depends on Simple Unit Tests.

The design of this extension's interface owes most to Simple Unit Tests and Benchmarking.

Chapter Changelog

Section Version 2

Renamed "unit-test" -> "unit test"; completely changed how assertions and refutations
are formed. Incorporated some suggestions and code by Dannii Willis.

Chapter Examples

Example: * Who tests the tester?

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
	  for "-3 < -3" assert -3 < -3 or "We really didn't expect [ut-expected] but we found [ut-found].";
	  
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
	  for "X is X" assert "X" is "X";
	  for "X < Y" assert "X" < "Y";
	  for "Y > X" assert "Y" > "X";
	  for "[lbrack]X[rbrack] exactly matches X" assert "[X]" exactly matches "X";
	  for "[lbrack]X[rbrack] exactly matches [lbrack]X2[rbrack]" assert "[X]" exactly matches "[X2]";
	  for "'banana' rmatches '(an)+'" assert "banana" rmatches "(an)+";
	  let m0 be match 0;
	  let m1 be match 1;
	  for "match 0 exactly matches anan" assert m0 exactly matches "anan";
	  for "match 1 exactly matches an" assert m1 exactly matches "an";
	  
	For testing text-comparison-refutation-lies:
	  for "X is X" refute "X" is "X";
	  for "X < Y" refute "X" < "Y";
	  for "Y > X" refute "Y" > "X";
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
	  for "A > B" refute "A" > "B";
	  for "B < A" refute "B" < "A";
	  for "A > A" refute "A" > "A";
	  for "A > A" refute "A" > "A";
	  for "B is A" refute "B" is "A";
	  for "B is A" refute "B" is "A" or "We really expected [ut-expected] but what we got was [ut-found].";
	
	For testing text-comparison-assertion-lies:
	  for "[lbrack]X[rbrack] does not exactly match [lbrack]X2[rbrack]" assert "[X]" does not exactly match "[X2]";
	  for "[lbrack]X[rbrack] does not exactly match [lbrack]Y[rbrack]" assert "[X]" exactly matches "[Y]";
	  for "A > B" assert "A" > "B";
	  for "B < A" assert "B" < "A";
	  for "A > A" assert "A" > "A";
	  for "A > A" assert "A" > "A";
	  for "B is A" assert "B" is "A";
