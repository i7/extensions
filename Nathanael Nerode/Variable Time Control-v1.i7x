Version 1.0.240202 of Variable Time Control by Nathanael Nerode begins here.

"Tracks time so that most actions can take specific amounts of time specified by the game author.
Failed/rejected actions take no time by default.  Allows tracking time separately in different scenes
to allow for time travel scenarios.  Not currently fully functional."

"Inspired by Variable Time Control by Eric Eve (version 4) and Modified Timekeeping by Daniel Stelzer".

[NOT CURRENTLY FULLY FUNCTIONAL.]

Volume - Duration Types

Section - Simple Temporal Duration Type

[One-part times: 2 seconds, 3 minutes, etc.]
A simple temporal duration is a kind of value.
1 second (singular) specifies a simple temporal duration.
2 seconds (plural) specifies a simple temporal duration.
1 sec specifies a simple temporal duration.
1 secs specifies a simple temporal duration.
[Conflict with builtin time parsing, skip.]
[1 minute (singular) specifies a simple temporal duration scaled up by 60.]
[2 minutes (plural) specifies a simple temporal duration scaled up by 60.]
1 min specifies a simple temporal duration scaled up by 60.
1 mins specifies a simple temporal duration scaled up by 60.
[Conflict with builtin time parsing, skip.]
[1 hour (singular) specifies a simple temporal duration scaled up by 3600.]
[2 hours (plural) specifies a simple temporal duration scaled up by 3600.]
1 hr specifies a simple temporal duration scaled up by 3600.
1 hrs specifies a simple temporal duration scaled up by 3600.
1 day (singular) specifies a simple temporal duration scaled up by 86400.
2 days (plural) specifies a simple temporal duration scaled up by 86400.

To decide what number is the reduction to seconds of (interval - a simple temporal duration):
	decide on interval / 1 sec.

Section - Two-part Temporal Duration Type

[Two-part times: 13:07]
A two-part temporal duration is a kind of value.
1:59 specifies a two-part temporal duration with parts hours and minutes.

To decide what number is the reduction to seconds of (interval - a two-part temporal duration):
	let my_hrs be the hours part of interval;
	let my_mins be the minutes part of interval;
	decide on (my_hrs * 60 * 60) + (my_mins * 60);

Section - Time Type

[Inform's default time type.  Generated when matching "5 minutes" or "3 hours".]

To decide what number is the reduction to seconds of (interval - a time):
	let my_hrs be the hours part of interval;
	let my_mins be the minutes part of interval;
	decide on (my_hrs * 60 * 60) + (my_mins * 60);

Section - Three-part Temporal Duration Type
	
[Three-part times -- 3:07:05]
A three-part temporal duration is a kind of value.
1:59:59 specifies a three-part temporal duration with parts hours and minutes and seconds.

To decide what number is the reduction to seconds of (interval - a three-part temporal duration):
	let my_hrs be the hours part of interval;
	let my_mins be the minutes part of interval;
	let my_secs be the seconds part of interval;
	decide on (my_hrs * 60 * 60) + (my_mins * 60) + (my_secs);

Volume - Datetime Type

Chapter - Months and leap years

Section - Month-value Type

A month-value is a kind of value.
The month-values are January, February, March, April, May, June, July, August, September, October, November, December.

Section - Leap years

[Implements a proleptic Gregorian calendar.]

To decide whether (x - a number) is a leap year:
	if the remainder after dividing x by 400 is 0, decide yes;
	if the remainder after dividing x by 100 is 0, decide no;
	if the remainder after dividing x by 4 is 0, decide yes;
	decide no;

Section - Leap year testing - not for release

Checking it for leap year is an action applying to one number.

Understand "leap year [number]" as checking it for leap year.

Carry out checking a number (called x) for leap year:
	if x is a leap year:
		say "yes";
	otherwise:
		say "no";

Section - Month lengths

to decide which number is the/-- length of (m - a month-value) in year (y - a number):
	if m is:
		-- January:
			decide on 31;
		-- February:
			if y is a leap year:
				decide on 29;
			otherwise:
				decide on 28;
		-- March:
			decide on 31;
		-- April:
			decide on 30;
		-- May:
			decide on 31;
		-- June:
			decide on 30;
		-- July:
			decide on 31;
		-- August:
			decide on 31;
		-- September:
			decide on 30;
		-- October:
			decide on 31;
		-- November:
			decide on 30;
		-- December:
			decide on 31;
	[Shouldn't get here]

Chapter - Weekdays

Section - Weekday-value Type

A weekday-value is a kind of value.
The weekday-values are Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday.

Chapter - Datetime object type

Section - Datetime object properties

A datetime is a kind of object.
A datetime has a number called year.
A datetime has a month-value called month.
A datetime has a weekday-value called weekday.
A datetime has a number called day.
A datetime has a number called hour.
A datetime has a number called minute.
A datetime has a number called second.
A datetime has a truth state called modified flag.

Section - Internal advance time phrases

[These work with numbers, and implement the truly complex carry scheme which
our standard calendar uses.  Game writers should typically call the non-internal
versions in the next section, which take durations as arguments.]

to internally advance (dt - a datetime) by (x - a number) second/seconds:
	let old be the second of dt;
	let new total be old + x;
	let carry be new total / 60;
	let new result be the remainder after dividing new total by 60;
	now the second of dt is new result;
	internally advance dt by carry minutes;
	now the modified flag of dt is true;

to internally advance (dt - a datetime) by (x - a number) minute/minutes:
	let old be the minute of dt;
	let new total be old + x;
	let carry be new total / 60;
	let new result be the remainder after dividing new total by 60;
	now the minute of dt is new result;
	internally advance dt by carry hours;
	now the modified flag of dt is true;

to internally advance (dt - a datetime) by (x - a number) hour/hours:
	let old be the hour of dt;
	let new total be old + x;
	let carry be new total / 24;
	let new result be the remainder after dividing new total by 24;
	now the hour of dt is new result;
	internally advance dt by carry days;
	now the modified flag of dt is true;

to internally advance (dt - a datetime) by (x - a number) day/days:
	[First advance the weekdays.]
	let weekdays to advance be the remainder after dividing x by 7; [Weekdays loop forever.]
	while weekdays to advance is greater than 0:
		internally advance weekday for dt;
		decrement weekdays to advance;
	[Now advance the month and day.]
	let old be the day of dt;
	let new total be old + x;
	[Now the month.  This gets ugly.  Have to subtract one month at a time.]
	let the current month be the month of dt;
	let the current year be the year of dt;
	let the month length be the length of current month in year current year;
	while new total is greater than month length:
		now new total is new total - month length;
		internally advance dt by 1 month;
		now the current month is the month of dt;
		now the current year is the year of dt;
		now the month length is the length of current month in year current year;
	now the day of dt is new total;
	now the modified flag of dt is true;

to internally advance weekday for (dt - a datetime):
	[This is meant to be used as a subroutine.]
	[In a fascinating undocumented feature, "weekday-value after" will always loop.]
	[Same with "before".]
	let old be the weekday of dt;
	now the weekday of dt is the weekday-value after old;
	now the modified flag of dt is true;

to internally advance (dt - a datetime) by 1 month/months:
	[WARNING: doesn't advance the weekday!  This is meant to be used as a subroutine.]
	[In a fascinating undocumented feature, "month-value after" will always loop.]
	[Same with "before".]
	let old be the month of dt;
	if old is the last value of month-value:
		[It's December.]
		internally advance dt by 1 year;
	now the month of dt is the month-value after old;
	now the modified flag of dt is true;

to internally advance (dt - a datetime) by (x - a number) year/years:
	[By far the simplest, and the only one with no carries]
	let old be the year of dt;
	let new total be old + x;
	now the year of dt is new total;
	now the modified flag of dt is true;

Section - Advance time phrase for Simple Temporal Duration

to advance (dt - a datetime) by (interval - a simple temporal duration):
	let x be the reduction to seconds of interval;
	internally advance dt by x seconds;

Section - Advance time phrase for Two-part Temporal Duration

to advance (dt - a datetime) by (interval - a time):
	let x be the reduction to seconds of interval;
	internally advance dt by x seconds;

Section - Advance time phrase for Time

to advance (dt - a datetime) by (interval - a two-part temporal duration):
	let x be the reduction to seconds of interval;
	internally advance dt by x seconds;

Section - Advance time phrase for Three-part Temporal Duration

to advance (dt - a datetime) by (interval - a three-part temporal duration):
	let x be the reduction to seconds of interval;
	internally advance dt by x seconds;

Volume - Showing the time

Section - Validate datetime

[ Purely for debugging ]
To validate (dt - a datetime):
	if the second of dt < 0:
		say "Error: second negative [second of dt].";
	if the second of dt > 59:
		say "Error: second too large [second of dt].";
	if the minute of dt < 0:
		say "Error: minute negative [minute of dt].";
	if the minute of dt > 59:
		say "Error: minute too large [minute of dt].";
	if the hour of dt < 0:
		say "Error: hour negative [hour of dt].";
	if the hour of dt > 23:
		say "Error: hour too large [hour of dt].";
	if the day of dt < 0:
		say "Error: day negative [day of dt].";
	if the day of dt > 31:
		say "Error: day too large [day of dt].";
		[We don't check each month, since this is just a sanity check]
	[Months and weekdays are enums, so they always work.]
	[We don't put any limits on year numbers.]

Section - Say pieces of a datetime

To say hour for (dt - a datetime) in zulu format:
	[00: or 01: rather than 24: or 1:]
	if the hour of dt < 10:
		say "0";
	say the hour of dt;

To say hour for (dt - a datetime) in 24 hour format:
	[24:00 rather than 0:00]
	if the hour of dt is 0:
		say "24";
	otherwise:
		say the hour of dt;

To say ampm for (dt - a datetime):
	if the hour of dt < 12:
		say "AM";
	otherwise:
		say "PM";

To say hour for (dt - a datetime) in 12 hour format:
	[1:00 PM rather than 13:00]
	if the hour of dt > 12:
		say the hour of dt - 12;
	otherwise if the hour of dt is 0:
		say "12";
	otherwise:
		say the hour of dt;

To say minutes for (dt - a datetime):
	[:05 rather than :5]
	if the minute of dt < 10:
		say "0";
	say the minute of dt;

To say seconds for (dt - a datetime):
	[:05 rather than :5]
	if the second of dt < 10:
		say "0";
	say the second of dt;


Section - Say a whole datetime 

[FIXME.  This is mostly for testing purposes.  To be improved as needed]
[These had to be broken out into subroutines mostly for readability.]

To say (dt - a datetime) fully:
	validate dt;
	say "[weekday of dt] [year of dt] [month of dt] [day of dt] ";
	say "[hour for dt in 12 hour format]:[minutes for dt]:[seconds for dt] [ampm for dt]";
	[The end.]

Section - Text substitution for datetime object

[The following has to be done instead of 'to say (dt - a datetime)']
Rule for printing the name of a datetime (called dt):
	say the dt fully;

Section - Showing the time action

Showing time is an action out of world applying to nothing.

Report showing time:
	say "It is now [the game datetime fully].";

Section - Showing the time Understand line (not for release)

[For debugging purposes only]
Understand "time" as showing time.

Volume - Standard Datetimes

Section - Default Start Datetime object

The default start datetime is a datetime.

Section - Default Start Datetime Defaults

[These SHOULD be overridden by the game author.]
[Overrides are not tested.  FIXME.]

[This is a real date; it's when I wrote the first version of this extension.]
The year of the default start datetime is usually 2024.
The month of the default start datetime is usually January.
The day of the default start datetime is usually 28.
The weekday of the default start datetime is usually Sunday.
The hour of the default start datetime is usually 22.
The minute of the default start datetime is usually 50.
The second of the default start datetime is usually 15.

Section - Player's real start datetime (for use with Real Date and Time by Ron Newcomb)

[Not implemented.  FIXME]

[
The player's real start datetime is a datetime.
The year of the player's real start datetime is (- GetNthDateTimeComponent(0) -).
The month of the player's real start datetime is (- GetNthDateTimeComponent(1) -).
The day of the player's real start datetime is (- GetNthDateTimeComponent(2) -).
The weekday of the player's real start datetime is (- GetNthDateTimeComponent(3) -).
The hour of the player's real start datetime is (- GetNthDateTimeComponent(4) -).
The minute of the player's real start datetime is (- GetNthDateTimeComponent(5) -).
The second of the player's real start datetime is (- GetNthDateTimeComponent(6) -).
]

Section - Primary Game Datetime

[This is the initial object which tracks the in-game time and date.
It can be swapped out.  See below regarding "game datetime".]

The primary game datetime is a datetime which varies.

[Game author should override this for sure.  This is just so that there is *some* default.]
[FIXME.]
The primary game datetime is usually the default start datetime.

Section - Game Datetime

[This is the object tracking the datetime of the game right now.
It starts out the same as the "primary game datetime".
This is the one which is updated by the various phrases and actions.

The reason for this:

If you have a game set in 1967 and then have a "flashback scene" set in 1795,
you can have the "primary game datetime" start in 1967; then put a different
datetime object into "the game datetime" for the flashback scene, and then when
the player returns to the present day, swap the datetime object back and arrive
"right back when you left".
]

The game datetime is a datetime which varies.

Section - Start in Primary Game Datetime

[ This has to be done in a rule during startup,
because we can't "cascade" usually statements for startup definitions.
It is a very simple assignment so it is quite safe.]

This is the initialize game datetime rule:
	now the game datetime is the primary game datetime.

[This is done very early, before "position player in model world" and before "start in the correct scenes",
largely so that the game author can override it and replace it immediately in "when play begins", or
indeed in the definition of a scene.]

The initialize game datetime rule is listed before the position player in model world rule in the after starting the virtual machine rules.

Volume - Waiting Actions

[These advance the "game datetime".]

[Trying to pass from one action to another using "try" fails.
"convert to" only works with objects, not value types.
So this requires redundant implementation.]

Chapter - Simple Temporal Duration

Section - Wait For Simple Temporal Duration Understand Clause

Understand "wait [simple temporal duration]" or "wait for [simple temporal duration]" as advancing time simply.

Section - Wait for Simple Temporal Duration Action

Advancing time simply is an action applying to one simple temporal duration.

Carry out advancing time simply:
	advance the game datetime by the simple temporal duration understood.

Chapter - Two-part Temporal Duration

Section - Wait For Two-part Temporal Duration Understand Clause

Understand "wait [time]" or "wait for [time]" as advancing time two-part.

Section - Wait For Two-part Temporal Duration Action

Advancing time two-part is an action applying to one time.
Carry out advancing time two-part:
	advance the game datetime by the two-part temporal duration understood.

Chapter - Time Period

["a time period" is defined in Standard Rules.  Handles minutes and hours.]
[Inform 7 confusingly converts this to the "time" type, though it has a different grammar token.]

Section - Wait for Time Period Understand Clause

Understand "wait [a time period]" or "wait for [a time period]" as advancing time by a time period.

Section - Wait for Time Period Action

Advancing time by a time period is an action applying to one time.

Carry out advancing time by a time period:
	advance the game datetime by the time understood.

Chapter - Three-part Temporal Duration

Section - Wait For Three-part Temporal Duration Understand Clause

Understand "wait [Three-part temporal duration]" or "wait for [Three-part temporal duration]" as advancing time three-part.

Section - Wait For Three-part Temporal Duration Action

Advancing time three-part is an action applying to one three-part temporal duration.
Carry out advancing time three-part:
	advance the game datetime by the three-part temporal duration understood.

Chapter - Unified Report for Waiting

[Use an "after" rule so we only have to write the report once.]

After advancing time simply, 
		advancing time two-part,
		advancing time by a time period, 
		or advancing time three-part:
	say "It is now [the game datetime fully].";

Volume - Standard time advancement

Section - Reset modified flag

[Reset this very early in the turn sequence.]
This is the declare time unmodified rule:
	now the modified flag of the game datetime is false;

The declare time unmodified rule is listed before the early scene changing stage rule in the turn sequence rulebook.
[Immediately after the generate action rule]

Section - Standard time per turn

[Game author can override to change the length of all turns.]

The standard time per turn is a simple temporal duration that varies.
[We can't say 1 minute because Core Inform turns that into a "time".  Aargh.]
The standard time per turn is usually 60 seconds.

Section - Default time advancement rule

[This should only trigger if nothing else advanced time during the turn: hence, default]

This is the advance time by default rule:
	if the modified flag of the the game datetime is false:
		advance the game datetime by standard time per turn;

[ TODO FIXME: incorporate Modified Timekeeping by Daniel Stelzer to fix implicit actions ]
[ He does this:
The record action success rule is listed before the carry out stage rule in the specific action-processing rulebook.
This is the record action success rule: now the action-processing success flag is true; make no decision.

This means we hit success at the top of the carry out stack.
The catch is that we want varying amounts of time in the carry out stack.
]

Section - Patch Carry Out rulebooks

[Now we have to add it to ALL the standard actions.]
[This provides a solid reference for the exact names of the standard action rulebooks.]
The advance time by default rule is listed last in the carry out taking inventory rulebook.
The advance time by default rule is listed last in the carry out taking rulebook.
The advance time by default rule is listed last in the carry out dropping rulebook.
The advance time by default rule is listed last in the carry out putting it on rulebook.
The advance time by default rule is listed last in the carry out inserting it into rulebook.
The advance time by default rule is listed last in the carry out eating rulebook.
The advance time by default rule is listed last in the carry out going rulebook.
The advance time by default rule is listed last in the carry out entering rulebook.
The advance time by default rule is listed last in the carry out exiting rulebook.
The advance time by default rule is listed last in the carry out getting off rulebook.
The advance time by default rule is listed last in the carry out looking rulebook.
The advance time by default rule is listed last in the carry out examining rulebook.
The advance time by default rule is listed last in the carry out looking under rulebook.
The advance time by default rule is listed last in the carry out searching rulebook.
The advance time by default rule is listed last in the carry out locking it with rulebook.
The advance time by default rule is listed last in the carry out unlocking it with rulebook.
The advance time by default rule is listed last in the carry out switching on rulebook.
The advance time by default rule is listed last in the carry out switching off rulebook.
The advance time by default rule is listed last in the carry out opening rulebook.
The advance time by default rule is listed last in the carry out closing rulebook.
The advance time by default rule is listed last in the carry out wearing rulebook.
The advance time by default rule is listed last in the carry out taking off rulebook.
The advance time by default rule is listed last in the carry out giving it to rulebook.
The advance time by default rule is listed last in the carry out showing it to rulebook.
The advance time by default rule is listed last in the carry out waking rulebook.
The advance time by default rule is listed last in the carry out throwing it at rulebook.
The advance time by default rule is listed last in the carry out attacking rulebook.
The advance time by default rule is listed last in the carry out kissing rulebook.
The advance time by default rule is listed last in the carry out answering it that rulebook.
The advance time by default rule is listed last in the carry out telling it about rulebook.
The advance time by default rule is listed last in the carry out asking it about rulebook.
The advance time by default rule is listed last in the carry out asking it for rulebook.
The advance time by default rule is listed last in the carry out waiting rulebook.
The advance time by default rule is listed last in the carry out touching rulebook.
The advance time by default rule is listed last in the carry out waving rulebook.
The advance time by default rule is listed last in the carry out pulling rulebook.
The advance time by default rule is listed last in the carry out pushing rulebook.
The advance time by default rule is listed last in the carry out turning rulebook.
The advance time by default rule is listed last in the carry out pushing it to rulebook.
The advance time by default rule is listed last in the carry out squeezing rulebook.
The advance time by default rule is listed last in the carry out saying yes rulebook.
The advance time by default rule is listed last in the carry out saying no rulebook.
The advance time by default rule is listed last in the carry out burning rulebook.
The advance time by default rule is listed last in the carry out waking up rulebook.
The advance time by default rule is listed last in the carry out thinking rulebook.
The advance time by default rule is listed last in the carry out smelling rulebook.
The advance time by default rule is listed last in the carry out listening to rulebook.
The advance time by default rule is listed last in the carry out tasting rulebook.
The advance time by default rule is listed last in the carry out cutting rulebook.
The advance time by default rule is listed last in the carry out jumping rulebook.
The advance time by default rule is listed last in the carry out tying it to rulebook.
The advance time by default rule is listed last in the carry out drinking rulebook.
The advance time by default rule is listed last in the carry out saying sorry rulebook.
The advance time by default rule is listed last in the carry out swinging rulebook.
The advance time by default rule is listed last in the carry out rubbing rulebook.
The advance time by default rule is listed last in the carry out setting it to rulebook.
The advance time by default rule is listed last in the carry out waving hands rulebook.
The advance time by default rule is listed last in the carry out buying rulebook.
The advance time by default rule is listed last in the carry out climbing rulebook.
The advance time by default rule is listed last in the carry out sleeping rulebook.

[We skip the out of world actions]

Section - Dialogue-related actions (for dialogue language element only)

[Note that this isn't active by default.]

[Note that there's a problem with Standard Rules:
it has "Stop the Action" in a "Carry Out" rule, which is forbidden and will break things.]

The advance time by default rule is listed last in the carry out talking about rulebook.

Chapter - Time Control Variables

[
time-reset is a truth state that varies. time-reset is false.
seconds_used is a truth state that varies.
seconds_used is false.
previous_seconds is a number that varies. previous_seconds is 0.
seconds_per_turn is a number that varies. 
seconds_per_turn is 60.
seconds is a number that varies. seconds is 0.
]

Chapter - The Variable Advance Time Rule

[
This is the variable advance time rule:
    if time-reset is true begin;
      now time-reset is false;
      stop;
   end if;
   if seconds_used is false, 
       now seconds is previous_seconds + seconds_per_turn;
   let mins be seconds / 60;
   now seconds is remainder after dividing seconds by 60;
   now the time of day is mins minutes after the time of day;
   increase turn count by 1;
   now seconds_used is false;
   now previous_seconds is seconds.


The variable advance time rule is listed instead of the advance time rule in the turn sequence rules.
]

Chapter - Time Control Phrases

[ Take no time consumes neither time nor turns ]
[
To take no time:  
   now time-reset is true;
   now seconds is previous_seconds;
   now seconds_used is false.


To say take/-- no-time: take no time.
To say take/-- no time: take no time.

To take (n - a number) sec/secs/second/seconds:
   increase seconds by n;
   now time-reset is false;
   now seconds_used is true.

To say take/-- (n - a number) sec/secs/second/seconds: take n secs.

To take (n - a number) sec/secs/second/seconds in/-- all/total/only:
  now seconds is previous_seconds + n;
  now time-reset is false;
  now seconds_used is true.

To say take/-- (n - a number) sec/secs/second/seconds in/-- all/total/only: take n secs in all. 
]

Chapter - Displaying Time with Seconds

[ This can be used to display the time of day in the format hh:mm:ss am/pm ]
[
To say sec-time:  
  let sec_tim be "[time of day]";
  let x be word number 2 in sec_tim;
  if seconds > 9, let x be "[x]:[seconds]";
  otherwise let x be "[x]:0[seconds]";
  replace word number 2 in sec_tim with x;
  say "[sec_tim]";
]

Variable Time Control ends here.

---- DOCUMENTATION ----


The standard behaviour for Inform 7 is to advance the time of day by one minute for each turn taken. There may be times when we'd like to vary this, perhaps because the player is up against a timed puzzle but we don't want certain actions to count too heavily against that time, or because we don't want our story to reach dawn or dusk too fast. This extension allows us to change the time taken per turn both on a global basis and for individual actions.

The passage of time per turn can be changed by changing the global variable seconds_per_turn (which is 60 by default). E.g. if we wanted two turns per minute, we could define:

	now seconds_per_turn is 30


To make individual actions take something other than this standard time we can use the phrases:

	take n secs/sec/seconds/second
	take n secs/sec/seconds/second  in/-- all/total/only

For example:

	take 3 secs
	take 1 sec
	take 20 secs in all

These phrases can be used in any of the rules relating to the action (or anything used by any of those rules, such as "to" or "to say" phrase).  The difference between the two forms "take n secs" and "take n secs in all" is that the first is additive and the second is not. That means that if an action triggers several rules, and more than one of these rules contains a "take n secs" phrase, the time from each of them will be added to the action, whereas if the phrase "take n secs only" (or one of its variants) is encountered in a rule, then the action will take this number of seconds, the time from previous rules for that action being ignored.

Equivalent to say phrases are also available, e.g.:

	"[3 secs]"
	"[20 secs total]"

This makes it easy to write rules like:

	Instead of taking the delicate vase in the presence of Aunt Veronica:
		say "[2 secs]Aunt Veronica's ferocius glare warns you to leave the vase well alone."

	After dropping the knife:
		say "[1 sec total]The knife falls from your grasp and clatters on the floor."

With all the above phrases, the turn count will still be increased by one. To have no time taken at all and the turn count not advanced, we can use the phrases:

	take no time
	"[no-time]"

This can be especially useful when the response to an action is effectively a refusal to act, and we don't want the refusal to count either against the elapsed time or the turn count. For example:

	Instead of taking Nelson's Column:
		say "[no-time]You lack the strength to lift it."

Or, more generally:

	Check taking something fixed in place: take no time.


Finally the phrase "[sec-time]" can be used to display the time of day in the format hh:mm:ss am/pm, for example:

	*: When play begins: now the right hand status line is "    [sec-time]";

Note that internally, the variable time of day is still only held to the nearest minute. This extension keeps track of a second variable, called seconds, which is used to decide when the time of day should be advanced.

One further note: where the various phrases defined above have potentially contradictory effects (e.g. take no time and take 5 seconds used on the same turn), it's the last phrase executed that takes effect.

Example: * Museum of Curiosities - Actions taking variable amounts of time.

In this example we make each turn take 30 seconds by default, but change this for certain actions. Here we'll assume that taking or dropping something normally only takes 1 second, and that taking inventory takes 1 second, so we write additional carry out rules accordingly. Since various actions with the exhibits are forbidden altogether, we won't let attempting them take any time at all, or even any turns. Various objects take various lengths of time to examine (depending on the amount of detail to be absorbed), so we'll use "[n secs]" phrases in their descriptions to vary the length of time taken to look at them. Finally, we'll make the bag of crisps awkward to take the first time, and override the standard 1 second taking time with "[40 secs in all]".

A test script is provided, but you may find it runs too fast for you to see what's going on. It may be more useful to enter commands manually, one at a time, and watch the status line to see the effect.

	*: "Museum of Curiosities" by Eric Eve

	Include Variable Time Control by Eric Eve.

	When play begins: 
	   now the right hand status line is "  [turn count]/[sec-time]";
	   now seconds_per_turn is 30.

	An exhibit is a kind of thing. An exhibit is usually scenery.

	Instead of taking or pushing or pulling or touching or attacking an exhibit:
	  say "[no-time]The signs round the room strictly warn you to leave the exhibits alone."

	Carry out taking something: take 1 second.
	Carry out dropping something: take 1 second.
	Carry out taking inventory: take 1 second.

	The player carries a leaflet.
	The description of the leaflet is "[60 secs]The leaflet describes some of the main exhibits in the museum and explains that they were donated by Sir Robin Lightfinger."

	The Museum is a room.
	"This large hall contains a number of fascinating exhibits, which signs dotted round the room strictly tell you not to touch on pain of a £1,000 fine. The exhibits include a stuffed dodo, Codex Sinaiticus and an unexploded bomb."

	The signs are scenery in the Museum.
	The description is "[5 secs]The signs warn that the penalty for interfering with the exhibits in any way is £1,000."

	The stuffed dodo is an exhibit in the Museum.
	The description is "[2 secs]It doesn't look very lively."

	Codex Sinaiticus is a proper-named exhibit in the Museum.
	The description is "[120 secs]It's one of the oldest surviving Greek manuscripts of the entire bible, containing both Old and New Testaments. You spend some time trying to read the Greek text."

	The unexploded bomb is a proper-named exhibit in the Museum.
	The description is "It's an unexploded bomb of World War II vintage, apparently dug up from a street in the East End in 1941 and never disposed of since."

	Instead of listening to the unexploded bomb:
	  say "[2 secs]It seems to be ticking."

	The bag of crisps is in the Museum.
	"A discarded bag of crisps lies on the floor."

	Understand "discarded" as the bag of crisps when the bag of crisps is not handled.

	After taking the bag of crisps for the first time: 
	   say "[40 secs in all]As you pick up the bag, some of the crisps spill out onto the floor, so you have to scrabble around picking them all up."

	Test me with "take crisps/i/x leaflet/drop it/take it/take dodo/x signs/x codex/x bomb/listen to bomb/break bomb"


