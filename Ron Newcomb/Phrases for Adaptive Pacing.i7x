Phrases for Adaptive Pacing by Ron Newcomb begins here.

"We may ask the time when (a description of scenes) began/ended; the number of turns since (a description of scenes) began/ended; if (a future event) is soon; the time/turns until (a future event); the time/turns when (a future event). We may also un-schedule a future event with 'never shall'; begin or end a scene on an event; say a time 'as a time period'; repeat through future events; and change the turns-to-minutes ratio with 'per'."




Chapter 3 - Events

Section 1 - Creating, Testing, and Preventing Future Events

To (R - rule) on/at turn (t - number): 
(- if (t < turns)  {
        if (enable_rte == true) 
            print "^*** Run-time problem: tried to schedule an event in the past, on turn ", n, " while on turn ", turns, "^"; 
     }
    SetTimedEvent({-mark-event-used:R}, turns - {t} +1, 0); -). 

To decide if (event - a rule) is/are/-- soon: 
	decide on whether or not the number of turns until the event is at least zero. [todo: scene machinery correction timer?]

To decide if (event - a rule) is/are/-- this turn: 
	decide on whether or not the number of turns until the event is zero plus the scene machinery correction timer.

To never shall (event - a rule):
	repeat with R2 running through future events:
		if the event is R2, blank out future event the chosen future event.

To repeat with (R - nonexisting rule variable) running through all/each/every/-- future events/event begin -- end loop: (-  {-counter-makes-array:loopingthruevents} ! {-counter-up:loopingthruevents} ! don't delete this comment
	for ((I7_ST_loopingthruevents-->({-counter:loopingthruevents})) = 1
	   :  (I7_ST_loopingthruevents-->({-counter:loopingthruevents})) <= (TimedEventsTable-->0)
	   :  (I7_ST_loopingthruevents-->({-counter:loopingthruevents}))++) 
		if ( ({R} = TimedEventsTable-->(I7_ST_loopingthruevents-->({-counter:loopingthruevents}))) && ({R} ~= 0) )
		-).


Section 2 - helper for never shall - unindexed

To blank out future event (i - a number):  (- TimedEventsTable-->({i}) = 0; -).




Chapter 4 - Measuring Time for Events


[
given exact time, get exact time
   [if raw data is exact time,] simply return exact time

given #/turns, get exact time
   call "given #/turns, get #/minutes"
   return the time of day plus #/minutes
]

To decide what time is the time when (R - a rule): 
	let the event be the index of R;
	if the event is 0, decide on the default value of time;
	if the event was scheduled at a time:
		decide on the TimedEventTimesTable for the event as a time;  [actually and simply read the array]
	otherwise:
		decide on the time of day plus the time until R.


[
given exact time, get #/turns until it
   call "given exact time, get #/minutes
   if time_rate < 0,    #/turns = #/minutes * time_rate
   if time_rate >= 0,  #/turns = (#/minutes divided by time_rate) + time_step     [[1 turn = X minutes]]

given #/turns, get #/turns
   [if raw data is #/turns,] return #/turns
 ]

To decide what number is the --/number --/of turns until (R - a rule): 
	let the event be the index of R;
	if the event is 0, decide on -1;
	if the event was scheduled at a time:
		if minutes-per-turn is at least one minute:
			decide on the current turn countdown until minute increase plus (the time until R divided by minutes-per-turn);
		otherwise: [turns per minute is at least one] 
			decide on (the time until R) as a number multiplied by turns per minute;
	otherwise: [scheduled in so many turns]
		decide on -1 - the TimedEventTimesTable for the event.   [actually and simply read the array]


[
given #/turns, get #/minutes until it
  if time_rate >= 0, return time_rate * #/turns
  if time_rate < 0, return ((#/turns - time_step) divided by (negated time_rate))  +1

given exact time, get #/minutes until it
   return exact time - the time of day
]

To decide what time [period] is time [period] until (R - a rule): 
	let the event be the index of R;
	if the event is 0, decide on -1 minutes;
	if the event was scheduled at a time:
		decide on the time when R minus the time of day;
	otherwise: [in so many turns]
		if turns per minute is at least one:
			decide on ((the turns until R minus the current turn countdown until minute increase) divided by turns per minute) as a time plus one minute;
		otherwise: [minutes-per-turn is at least one]
			decide on the turns until R multiplied by minutes-per-turn.

[
given exact time, get The turn when it
   call "given exact time, get #/turns until it"
   return the turn count plus #/turns
 
given #/turns, get The turn when it
   return the turn count plus #/turns
]

To decide what number is the turn/turns when (R - a rule):
	let the event be the index of R;
	if the event is 0, decide on -1;
	decide on the turn count plus the turns until R.  [simplest because it's the slowest]

[it's "the turn when", not "the turns when", but we'll allow it because it'll be typed anyway]


Chapter 2 - Scenes 

Section 1 - Measuring Time for Groups of Scenes

The scene being referenced is a scene that varies. 

To decide which time [period] is [the] time [period] since (D - a description of scenes) began/happened:
	now the scene being referenced is the entire game;
	let the minimum time ago be the time [period] since the entire game began;
	repeat with Scn running through D:
		unless Scn has happened, next;
		let T be the time since Scn began;
		if T <= the minimum time ago:
			now the minimum time ago is T;
			now the scene being referenced is Scn;
	decide on the minimum time ago.
	

[section 2 - the time since (description of scenes) ended ]

To decide which time [period] is [the] time [period] since (D - a description of scenes) ended:
	now the scene being referenced is the entire game;
	let the minimum time ago be the time [period] since the entire game began [because that's guaranteed to be longer ago than any scene's *ending*];
	repeat with Scn running through D:
		unless Scn has ended, next;
		let T be the time since Scn ended;
		if T <= the minimum time ago:
			now the minimum time ago is T;
			now the scene being referenced is Scn;
	decide on the minimum time ago.

To decide which number is the --/number --/of turns since (D - a description of scenes) began/happened: decide on the time since to turns since for (the time since D began).
[	decide on (the time since D began) as a number.  [todo?]]

To decide which number is the --/number --/of turns since (D - a description of scenes) ended: decide on the time since to turns since for (the time since D ended).
[	decide on (the time since D ended) as a number.  [todo?]]


Section 5 - helper for time-since-scenes - unindexed

To decide which number is time since to turns since for (X - a time):
	if minutes-per-turn is at least one minute:
		decide on the current turn countdown until minute increase plus (X divided by minutes-per-turn);
	otherwise: [turns per minute is at least one] 
		decide on (X) as a number multiplied by turns per minute.




Chapter 6 - helper phrases

Section 1 - expose I6 internals - unindexed

minutes-per-turn is a time that varies. 
minutes-per-turn variable translates into I6 as "time_rate".

The current turn countdown until minute increase is a number that varies. 
The current turn countdown until minute increase variable translates into I6 as "time_step".


Section 2 - Setting and Testing the Turns-to-Time Ratio


To decide what number is turns per minute: 
	let X be the minutes-per-turn as a number;
	if X < 0, decide on 0 - X;  [absolute value]
	if X is 1, decide on 1;  [usual case: one minute == one turn, so both "per"s are 1]
	decide on 0. [but if it's 2+ min/turn, then turn/min would round down to 0]

To decide what time is minutes per turn: 
	if minutes-per-turn is at least 0 minutes, decide on minutes-per-turn;
	decide on 0 minutes. [but if it's 2+ turns/min, then time_rate is *negative* and min/turn (a fraction) would truncate to 0]

To (S - a time [period]) per turn: 
	now minutes-per-turn is S;
	now the current turn countdown until minute increase is 0.

[ A 1:1 ratio works the same either way, but there are two different ways to represent it. So we'll change -1:-1 to 1:1 just for consistency's sake. ]
To (S - a number) turns/turn per minute:
	if S is not 1:
		now the current turn countdown until minute increase is S;
		now minutes-per-turn is (0 - S) as a time;
	otherwise:
		1 minute per turn.



Section 4 - typecasts - unindexed

[ for these, "number" does not necessarily mean turns, so there's no ratio conversion ]
To decide what time is (N - number) as a time: (- {N} -).
To decide what number is (T - a time) as a number: (- {T} -).



Chapter 5 - say phrases

section 1 - To Say a Time as a Duration of Minutes and Hours

To say (T - a time [period]) as a time period:
	if T < 0 minutes, now T is 0 minutes minus T;
	let H be the hours part of T;
	let M be the minutes part of T;
	say "[if H is at least 1][H in words] hour[s][end if][if H is at least 1 and M is at least 1] and [end if][if M is at least 1 or H is 0][M in words] minute[s][end if]".

section 2 - saying durations as durations by default - unindexed

[I've taken care with the above definitions so that, when they are placed as a say phrase, these phrases will instead run, seamlessly printing the durations "as a time period", as the way they would print on their own leads to nonsense. ]

To say the/-- time [period] until (R - a rule): 
	let T be the time until R;  [calls the above function]
	say T as a time period.  [sends it to a special time printing routine]


To say the/-- time [period] since (D - a description of scenes) began/happened: 
	let T be the time since D began;  [calls the above function]
	say T as a time period.  [sends it to a special time printing routine]

To say the/-- time [period] since (D - a description of scenes) ended: 
	let T be the time since D ended;  [calls the above function]
	say T as a time period.  [sends it to a special time printing routine]




Chapter 7 - Messy Internals

Section 1 - getting the array index of a particular event - unindexed

[quickly, from within the Repeat Through Future Events loop]
To decide which number is the chosen future event -- in loop:
	(- (I7_ST_loopingthruevents-->({-counter:loopingthruevents})) -).

[slowly, ex nihilo]
To decide which number is the index of (R - a rule): 
	repeat with R2 running through future events:
		if R is R2, decide on the chosen future event;
	decide on 0.


Section 2 - fetch raw temporal data for event - unindexed

To decide what number is TimedEventTimesTable for (i - a number):
	(- (TimedEventTimesTable-->{i}) -).


section 3 - is raw data a specific time or a turn countdown - unindexed 

To decide if (i - a number) was scheduled at a time: 
	decide on whether or not the TimedEventTimesTable for i is greater than zero.


section 4 - correct for off-by-one error for if-event-this-turn - unindexed

The scene machinery correction timer is a number that varies. 
The scene machinery correction timer is usually 0.

First scene changing rule: now the scene machinery correction timer is -1.
This is the should be last scene changing rule: now the scene machinery correction timer is 0.
          The should be last scene changing rule is listed first in the every turn rules.
          The should be last scene changing rule is listed after the adjust light rule in the turn sequence rules.


[This is the foobar rule: now the scene machinery correction timer is 0.
The foobar rule is listed last in the scene changing rules.]  [DOESN'T WORK IN 6E59]



[*****************************************************************************************************]

[
#1 first word, indicating return value
-- time [period]
-- [number of] turns

#2 measurement
-- until    (return a duration or countdown. Events. )
-- when   (return a point, like 3:30 PM. Events & Scenes.)
-- since   (return a duration, an elapsed duration from a past moment. Scenes.)

#3 the moment to measure from
-- (event)
-- the next/previous event      [ like "description of event", looking for the duration of time since the previous or until the next event ]
-- (scene) began
-- (scene) ended
-- (description of scenes) began
-- (description of scenes) ended
]


[ 
2 inputs: #/turns until, and, exact time when
4 outputs:   turn(s)/time(minutes)  when/until 
8 functions: 

#/turns until ->  #/turns until
#/turns until ->  #/minutes until
#/turns until ->  the turn when
#/turns until ->  the exact time when
exact time when ->  #/turns until
exact time when ->  #/minutes until
exact time when ->  the turn when
exact time when ->  the exact time when
]


Phrases for Adaptive Pacing ends here.

---- DOCUMENTATION ----

expands Chapter 9.11 "Future Events"

	(event) on turn (number)


The phrase "if (event) is soon" asks if the event is currently scheduled, while "never shall (event)" will un-schedule the event.  The phrase "if (event) is this turn" asks if the event is firing on that very turn.  The latter is useful as a signpost to begin or end scenes, as well as for combining output from the event's rule into, say, a room description.  For the if-phrases, "is" is optional. 

	*: Instead of saying no, I run the daily TPS reports at 6 PM.
	
	At the time when I run the daily TPS reports: do nothing.
	
	When play begins, your last chance passes you by on turn 5.
	
	Carry out eating your agenda: never shall I run the daily TPS reports.
	
	
	The rest of your life is a scene. 
	The rest of your life begins when your last chance passes you by this turn.

	Your new life is a scene.
	Your new life begins when we have eaten your agenda.


The phrases "the time since a scene began/ended" and similar for "the time when a scene began/ended" presented in 10.3 "Using the Scene Index" now accept a description of scenes.  For example, 10.4. "During Scenes" applies adjectives such as "dull" to scenes.  (Note the use of "the scene being referenced" that mirrors the built-in "scene being changed".)

	*: Every turn when the time since a new scene began is four minutes
		say "It's been four whole minutes since a new scene, [the scene being referenced], began. So get a move on!"
	
	Definition: a scene is new if it has happened.


Similar phrases for events now exist, but because we'll be talking about moments in the future rather than the past, we use "until" in lieu of "since".  And again, we may get the measurement in either turns or time.

	*: Every turn (this is the event debugging rule): 
		repeat with E running through future events:
			say "The turn when [E]:  the [the turn when E]th turn.";
			say "The time when [E]:  [the time when E].";
			say "The turns until [E]:  [the turns until E] turn[s].";
			say "The time until [E]:  [the time until E]."


The say phrase "as a time period" answers section 16.9 "Understanding kinds of value" in that it will print the time as a duration such as three hours and thirty minutes, rather than 3:30 PM.  

	*: Understand "wait for [a time period]" as a mistake ("'But [the time understood as a time period] is so long!'").
	
	Understand "wait until [a time]" as a mistake ("'But that's [the time understood minus the time of day as a time period]!'").
	
	Test me with "wait for 3 minutes / wait until 3:30 pm".


Normally, one turn takes one minute of simulated game time. We can alter this ratio with phrases like "60 turns per minute", in which each turn would take one second, and "30 minutes per turn", in which each turn would take a half hour.  We can retrieve this information with "minutes per turn" and "turns per minute", which are handy for converting between the minute and turn scales via multiplication.  A value of zero puts time at a standstill. 

	*: Understand "ratio" as a mistake ("[turns per minute in words] turn[s] per minute[line break][minutes per turn as a time period] per turn").
	
	Instead of drinking the Red Bull: four turns per minute.
	
	Instead of sleeping when turns per minute is at least two, (turns per minute minus one) turns per minute.
	
	Report examining the extension: say "'Well that only took [20 minutes divided by the turns per minute as a time period].'"


This extension allows us to have Scenes begin or end when a timed event happens.  From section 9.11 on Timed Events:

	*: An egg-timer is in the kitchen. "A plastic egg timer in the shape of a chicken can be pressed to set it going." 
	
	Instead of pushing the egg-timer: say "It begins to mark time."; the egg-timer clucks in four turns from now.
	
	At the time when the egg-timer clucks: say "Cluck! Cluck! Cluck! says the egg-timer." 


We can then write a scene to begin (or end) on that event:

	*: Dinnertime is a scene.  
	Dinnertime begins when the turn count is at least 2 and the egg-timer clucks this turn.




Example: * Dinnertime - Schedules a future event, and begins a scene when it happens

	*: "Dinnertime"

	Include Phrases for Adaptive Pacing by Ron Newcomb.

	The kitchen is a room. 

	An egg-timer is in the kitchen. "A plastic egg timer in the shape of a chicken can be pressed to set it going." 

	Instead of pushing the egg-timer: say "It begins to mark time."; the egg-timer clucks in four turns from now.
	
	At the time when the egg-timer clucks: say "'Cluck! Cluck! Cluck!' says the egg-timer." 

	Test me with "scenes / push egg-timer / z / z/ z/ z/ z/ z/ z/ z/ z/ z".

	Dinnertime is a scene.  
	Dinnertime begins when the turn count is at least two and the egg-timer clucks this turn.
	When dinnertime begins: say "The most wonderful scents fill the air."


Example: ** Life Ticking Away - Demonstrates the many phrases. 

Try "test me" for most of the time until/when phrases, "test wait" for how various waiting actions could work, or "test ratio" for testing the turns-to-minutes ratio via some caffeinated assistance.

	*: "Life Ticking Away"

	Include Phrases for Adaptive Pacing by Ron Newcomb.
 
	Your office is southwest of your home. Your agenda is carried by yourself. It is edible.

	[When play begins, 3 minutes per turn.]  

	Concert is a scene. Concert begins when jumping. Concert ends when the sand runs out this turn.
	Introspection is a scene. Introspection begins when examining your agenda.

	Every turn when the time since a new scene began is four minutes (this is the cure slow pacing issue rule): say "It's been four whole minutes since a new scene began. Get a move on!"

	Instead of waiting: do nothing.

	Every turn: say "Turn [the turn count], [time of day]:  It's been [the time since a scene began] since a new scene, '[the scene being referenced]', began[if the sand runs out this turn].  We have now run out of sand[otherwise if the sand runs out soon].  The sand runs out in [the time until sand runs out as a time period], at [the time when the sand runs out][end if]."

	Every turn (this is the event debugging rule): 
		repeat with E running through future events:
			say "The turn when [E]:  the [the turn when E]th turn.";
			say "The time when [E]:  [the time when E].";
			say "The turns until [E]:  [the turns until E] turn[s].";
			say "The time until [E]:  [the time until E]."


	Test me with "scenes / jump / z / x agenda / z / z / z / z / x agenda / z / z / z / z / x agenda / jump / x agenda / eat agenda / x agenda".
	Test ratio with "ratio/ drink red bull / ratio / sleep / ratio/ sleep / ratio / sleep / ratio / sleep / z/z/z/ drink red bull / z/z/z/z/ sleep / z/z/z/z/z/z".
	Test waiting with "wait for 3 minutes / wait until 3:30 pm / wait until 8 am".

	Instead of jumping: 
		the sand runs out in 4 turns from now; 
		I go home in 10 minutes from now.

	At the time when the sand runs out: say "Out of sand."
	At the time when I go home: say "I'm outta here."

	Instead of eating your agenda: 
		never shall I go home.

	Instead of saying no, I run the daily TPS reports at 6 PM.

	Carry out eating your agenda: never shall I run the daily TPS reports.

	At the time when I run the daily TPS reports: say "'Where did my life go wrong?'"


	Understand "wait for [a time period]" as a mistake ("'But [the time understood as a time period] is so long!'").
		
	Understand "wait until [a time]" as a mistake ("'But that's [the time understood minus the time of day as a time period]!'").
		
	Instead of drinking the Red Bull: four turns per minute.
		
	Understand "ratio" as a mistake ("[turns per minute in words] turn[s] per minute[line break][minutes per turn as a time period] per turn").

	The red bull is in your office.

	Instead of sleeping when turns per minute is at least two, (turns per minute minus one) turns per minute.

	Definition: a scene is [possibly] new [rather than recurred] [as long as]if  it has happened [LESS THAN TWICE].  [, even if it ended in a single turn, it still began recently, and should be considered new.]

	[alternate definition of new:  if a scene is not happening, then to run it would be running "a new scene". ]
	[Definition: a scene is next if it is not happening.]
	[the "next new scene" would be to re-run a recurring scene!!]

	[Definition: a scene is recent if it has happened.]
	[but no one would say "the next recent scene".  But might ask about the "most recent scene"]

