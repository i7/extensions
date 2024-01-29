Version 1.0.240128 of Variable Time Control by Nathanael Nerode begins here.

"Allows individual actions to take a different number of seconds, or no time at all. Also allows the standard time taken per turn to be defined as so many seconds, which can be varied during the course of play".

"Based on Variable Time Control by Eric Eve (version 4)."

[NOT CURRENTLY FUNCTIONAL.]

Volume - Time Control Mechanism

Chapter - Months and leap years

Section - Month value type

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

Section - Weekday value type

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

Section - Advance time

to advance (dt - a datetime) by (x - a number) second/seconds:
	let old be the second of dt;
	let new total be old + x;
	let carry be new total / 60;
	let new result be the remainder after dividing new total by 60;
	now the second of dt is new result;
	advance dt by carry minutes;

to advance (dt - a datetime) by (x - a number) minute/minutes:
	let old be the minute of dt;
	let new total be old + x;
	let carry be new total / 60;
	let new result be the remainder after dividing new total by 60;
	now the minute of dt is new result;
	advance dt by carry hours;

to advance (dt - a datetime) by (x - a number) hour/hours:
	let old be the hour of dt;
	let new total be old + x;
	let carry be new total / 24;
	let new result be the remainder after dividing new total by 24;
	now the hour of dt is new result;
	advance dt by carry days;

to advance (dt - a datetime) by (x - a number) day/days:
	[First advance the weekdays.]
	let weekdays to advance be the remainder after dividing x by 7; [Weekdays loop forever.]
	while weekdays to advance is greater than 0:
		advance weekday for dt;
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
		advance dt by 1 month;
		now the current month is the month of dt;
		now the current year is the year of dt;
		now the month length is the length of current month in year current year;
	now the day of dt is new total;

to advance weekday for (dt - a datetime):
	[This is meant to be used as a subroutine.]
	let old be the weekday of dt;
	if old is the last value of weekday-value:
		[It's Saturday.]
		now the weekday of dt is the first value of weekday-value; [Sunday]
	otherwise:
		now the weekday of dt is the weekday-value after old;

to advance (dt - a datetime) by 1 month/months:
	[WARNING: doesn't advance the weekday!  This is meant to be used as a subroutine.]
	let old be the month of dt;
	if old is the last value of month-value:
		[It's December.]
		advance dt by 1 year;
		now the month of dt is the first value of month-value; [January]
	otherwise:
		now the month of dt is the month-value after old;

to advance (dt - a datetime) by (x - a number) year/years:
	[By far the simplest, and the only one with no carries]
	let old be the year of dt;
	let new total be old + x;
	now the year of dt is new total;

Section - say the time

[FIXME.  This is mostly for testing purposes.  To be improved as needed]

To say (dt - a datetime) fully:
	say "[the weekday of dt] [the year of dt] [the month of dt] [the day of dt] [the hour of dt]:[the minute of dt]:[the second of dt]";

Section - default start datetime

[Essentially for testing purposes.
This is a real date; it's when I wrote the first version of this extension.]

The default start datetime is a datetime.

The year of the default start datetime is 2024.
The month of the default start datetime is January.
The day of the default start datetime is 28.
The weekday of the default start datetime is Sunday.
The hour of the default start datetime is 22.
The minute of the default start datetime is 50.
The second of the default start datetime is 15.

Section - Player's real start datetime (for use with Real Date and Time by Ron Newcomb)

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

Section - primary game datetime

The primary game datetime is a datetime which varies.

[Game writer should override]
The primary game datetime is usually the default start datetime.

Section - test advance (not for release)

Advancing the clock it seconds is an action applying to one number.

Understand "advance [number]" as advancing the clock it seconds.

Carry out advancing the clock a number (called x) seconds:
	advance the primary game datetime by x seconds;
	if the primary game datetime is on-stage, say "whoops, primary game datetime shouldn't be onstage";
	if the default start datetime is on-stage, say "whoops, default start datetime shouldn't be onstage";
	say the primary game datetime fully;





Chapter - Time Control Variables

time-reset is a truth state that varies. time-reset is false.
seconds_used is a truth state that varies.
seconds_used is false.
previous_seconds is a number that varies. previous_seconds is 0.
seconds_per_turn is a number that varies. 
seconds_per_turn is 60.
seconds is a number that varies. seconds is 0.


Chapter - The Variable Advance Time Rule

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


Chapter - Time Control Phrases

[ Take no time consumes neither time nor turns ]

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


Chapter - Displaying Time with Seconds

[ This can be used to display the time of day in the format hh:mm:ss am/pm ]

To say sec-time:  
  let sec_tim be "[time of day]";
  let x be word number 2 in sec_tim;
  if seconds > 9, let x be "[x]:[seconds]";
  otherwise let x be "[x]:0[seconds]";
  replace word number 2 in sec_tim with x;
  say "[sec_tim]";


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


