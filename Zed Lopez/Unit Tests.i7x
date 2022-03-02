Version 1 of Unit Tests by Zed Lopez begins here.

"Yet another Unit Tests extension. Tested with 6M62."

Volume Unit Tests (not for release)

Part Autotest

Use test automatically translates as (- Constant TEST_AUTOMATICALLY; -)

when play begins (this is the test all unit tests automatically rule):
  if test automatically option is active, test all unit-tests.

Part Undo

To decide what number is the result of saving before running the unit tests:
(- VM_Save_Undo() -).

To restore back to before running the unit tests:
(- VM_Undo(); -).

Part unit-test object

A unit-test is a kind of object.
A unit-test has a text called the description.
The description of a unit-test is usually "".

Chapter Saying unit-test

To say (ut - a unit-test):
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

Chapter Unit-testing

Unit-testing is an action out of world.
Understand "utest" as unit-testing.

Carry out unit-testing (this is the test all unit tests rule): test all unit-tests.

Section Test all unit-tests to-phrase

[ also used in the test all unit-tests automatically rule]
To test all unit-tests:
  repeat with ut running through the unit-tests begin;
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
  repeat with ut running through the unit-tests begin;
    if printed name of ut rmatches "^[txt]", case insensitively begin;
      follow the utest rules for ut;
    end if;
  end repeat;

Part Assertions

Section I6 puts

Include (-
[ TEXT_TY_puts T;
  TEXT_TY_Say(T);
  print "^";
];
-)

Chapter Assertions proper

To assert (C - a condition) or (T - a text): (- if ({C}) {-open-brace} unit_test_success++; {-close-brace} else {-open-brace} unit_test_failure++; TEXT_TY_puts({T}); {-close-brace} -)

Section Assert or die

To assert (C - a condition) or die with/-- (T - a text): (- if ({C}) {-open-brace} unit_test_success++; {-close-brace} else {-open-brace} unit_test_failure++; TEXT_TY_puts({T}); RulebookFails(); rtrue; {-close-brace} -)

Chapter Refutations

To refute (C - a condition) or (T - a text): (- if (~~({C})) {-open-brace} unit_test_success++; {-close-brace} else {-open-brace} unit_test_failure++; TEXT_TY_puts({T}); {-close-brace} -)

Section Refute or die

To refute (C - a condition) or die with/-- (T - a text): (- if (~~({C})) {-open-brace} unit_test_success++; {-close-brace} else {-open-brace} unit_test_failure++; TEXT_TY_puts({T}); RulebookFails(); rtrue; {-close-brace} -)

[ a rulebook wraps around an activity because restoring from save was taking us back
  to the middle of the previous activity, and because this guarantees a user-defined
  before rule can't beat us to first. ]

Part Utest rulebook

Utest is a unit-test based rulebook.
[The utest rulebook has a number called the total test count.]

Chapter Setup test

First utest a unit-test (called ut) (this is the unit test setup rule):
  now unit test success is 0;
  now unit test failure is 0;
  say "[line break]Testing [ut][line break]";
  if the result of saving before running the unit tests is 2, stop;

Chapter Utest rule to carry out testing activity

Utest a unit-test (called ut) (this is the carry out a unit test rule):
  carry out the testing activity with ut;

Chapter Test results

Utest a unit-test (called ut) (this is the unit test reporting rule):
  let total test count be unit test success + unit test failure;
  say "[unit test success]/[total test count] passed[if unit test failure is 0].[else]; [unit test failure]/[total test count] failed.[end if]";

Chapter Cleanup

Utest (this is the unit test cleanup rule):
  restore back to before running the unit tests;

Part Testing something activity

[ no pre-defined rule: this is for authors to define rules for their tests ]
Testing something is an activity on unit-tests.

Part Captured (for use with Text Capture by Eric Eve)

A unit-test can be text-capturing.

Before testing a text-capturing unit-test (called ut):
  start capturing text.    

Part text comparisons (For use without textile by zed lopez)

To decide if (S - text) exactly matches (T - text): decide on whether or not S exactly matches the text T;
To decide if (S - text) does not exactly match (T - text): if S exactly matches T, no; yes.
To decide if (S - text) includes (T - text): decide on whether or not S matches the text T;
To decide if (S - text) does not include (T - text): if S includes T, no; yes.
To rmatch (V - a text) by (R - a text), case insensitively:
  (- TEXT_TY_Replace_RE(REGEXP_BLOB,{-by-reference:V},{-by-reference:R},0,{phrase options}); -).

To decide if (V - a text) rmatches (R - a text), case insensitively:
  (- TEXT_TY_Replace_RE(REGEXP_BLOB,{-by-reference:V},{-by-reference:R},0,{phrase options}) -).

[ unfortunate ambiguity if we add case insensitively here ]
To decide if (V - a text) does not rmatch (R - a text), case insensitively:
  (- (~~(TEXT_TY_Replace_RE(REGEXP_BLOB,{-by-reference:V},{-by-reference:R},0,{phrase options}))) -).

To decide what text is the/a/-- match (N - a number):
  (- TEXT_TY_RE_GetMatchVar({N}) -).

To rmatch (V - a text) by/with/against (R - a text), case insensitively:
  (- TEXT_TY_Replace_RE(REGEXP_BLOB,{-by-reference:V},{-by-reference:R},0,{phrase options}); -).

To decide what text is (T - a text) trimmed:
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
case the test falls back on the object name itself.)

	Math-still-works is a unit-test. "Whether math still works".

``Testing`` is an activity on unit-tests. For the test to do anything useful,
you must define a corresponding ``For testing`` rule:

	For testing math-still-works:
		assert 2 + 2 is 4 or say "Math is broken.";

(More about assert statements later.)

If you have setup to do, a ``Before testing`` rule is a good place for it. But
you may need to establish global variables or activity variables for the ``for testing``
rules to have access to information set up in the Before rule.

If there's more reporting you want, you might use an ``After testing`` rule. But you shouldn't
need to do any teardown: unit tests are idempotent. They save the game state before they
start, and restore when they're finished... but on glulx one can protect memory from being
clobbered by a restore, so make that *mostly* idempotent. At any rate, it should be fairly
difficult for one test to screw up the environment for another.

This means that you also can't share context between different tests... but you can make the
same Before rule apply to more than one test. (You can have multiple ``for testing`` rules
for the same unit-test, using ``continue the activity``, but those would be treated as the
same test.)

	Before testing a unit-test (called ut) when ut is test1 or ut is test2:

And don't have one test invoke another: when the outer test restored state, it would be
restoring the state as of beginning the inner test.

Chapter Assertions and Refutations

assert/refute statements are the heart of testing. It technically doesn't matter where they
occur in the activity, but the intent is that they be used in For Testing rules. They're very simple:

assert <condition> or <text of message to be printed on failure>
refute <condition> or <text of message to be printed on failure>

For example:

	assert 1 + 1 is 2 or "Oh no! Math is broken!"

If you create a unit-test object, you should write a corresponding For testing activity rule
which should include at least one assertion or refutation. This isn't enforced; if you don't
have any assertions, the test will run and report 0/0 Passed.

Section Death

Assert and refute have an "or die" variant, which ends the activity immediately.

assert <condition> or die with/-- <text of message to be printed on failure>
refute <condition> or die with/-- <text of message to be printed on failure>

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

In old versions of I7, text and indexed text were separate types. Texts could
include adaptive text; indexed texts were some particular static string.
Subsequently, they were collapsed together (in fact, you can still use "indexed text"
as a synonym for "text") but they continue to have different underlying representations.

When you test whether a text containing adaptive text *is* a text that doesn't,
I7 automatically takes the substituted form of the text containing adaptive text.
But when you test whether a text containing adaptive text *is* a text containing
adaptive text, the answer is just no, always no. So that's why we have the
``substituted form of`` and ``exactly matches the text`` phrases.

Not just ``exactly matches the text``, but also ``matches the text`` and ``matches the
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
and to get the same behavior. Existing phrases are unchanged.

Further it includes the following just to reduce the verbosity of regular expression
usage:

if <text> rmatches <text of a regexp> [ = if <text> matches the regular expression <text of a regexp> ]
let t1 be match 1 [ = text matching subexpression 1 ]
let t0 be match 0 [ = text matching the regular expression ]

Chapter Testing printed output

Most unit test extensions include Text Capture by Eric Eve to facilitate testing output. But much
of the time you can make do by wrapping things in a say statement constructed for the purpose.

[ the phrase to be tested ]
To say (T - a text) backwards:
    let len be the number of characters in T + 1;
    repeat with i running from 1 to the number of characters in T begin;
      say character number len - i in T;
    end repeat;

Backwards-test is a unit-test. "saying text backwards."

[ the custom say statement added for testing purposes]
To say backwards-test-output:
    say "schmoop" backwards;

For testing backwards-test:
 assert "[backwards-test-output]" exactly matches "poomhcs" or "[backwards-test-output] not poomhcs";

Section Text-capturing unit-tests for use with Text Capture by Eric Eve

But if your game *does* include Text Capture, Unit Tests adds a text-capturing
property to unit-tests and, for them, starts capturing text in a Before testing rule.
So you could then have:

Backwards-capture-test is a text-capturing unit-test. "Saying captured text backwards."

For testing backwards-capture-test:
  let t be "doowyc3";
  say t backwards;
  stop capturing text;
  let expectation be "3cywood";
  assert "[captured text trimmed]" exactly matches "3cywood" or "[t] backwards wasn't [expectation]";

But make sure you stop capturing text prior to your assert statements!

Chapter Test Automatically

There is a "test automatically" use option. You can include:

Use test automatically.

and all tests will be run on startup. Otherwise you can enter the command ``test suite`` or ``utest``.

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

Chapter Examples

Example: * Who tests the tester?

