Version 2.0 of Nuanced Timekeeping by Jeff Nyman begins here.

"Keeps time to the second, and lets actions take different amounts of time."

Part - Seconds

[The seconds past the current minute. The clock itself is still Inform's time
of day; the seconds count is kept alongside it.]

The seconds count is a number that varies. The seconds count is 0.

[How long a turn takes when no duration rule says otherwise.]

The seconds per turn is a number that varies. The seconds per turn is usually 15.

[The time of day as this extension last left it. If the story sets the time of
day itself, the two differ, and the seconds start again from zero.]

The minute last kept is a time that varies. The minute last kept is 9:00 am.

To decide which number is the current seconds:
	if the time of day is not the minute last kept, decide on 0;
	decide on the seconds count.

Part - Durations

[How long the action the player starts this turn takes, in seconds; -1 while no
action has been timed yet this turn.]
The turn duration is a number that varies. The turn duration is -1.

The duration rules are an action based rulebook.

[A duration rule sets the time only if no rule has yet this turn, so the most
specific rule (examining the painting before examining) wins.]
To take (N - a number) seconds:
	if the turn duration < 0, now the turn duration is N.

To take (N - a number) minute/minutes:
	let S be N * 60;
	take S seconds.

To take no time:
	take 0 seconds.

[Timing the first action the player starts in a turn: the command's own action.
The timing starts afresh just before the command's action, so actions outside
the turn sequence (the opening look, say) don't count. Actions it tries along
the way (an implicit take, say) are part of it, and a command for several things
(TAKE ALL) takes one action's time.]
This is the start timing the turn rule:
	now the turn duration is -1.

The start timing the turn rule is listed before the generate action rule in the turn sequence rules.

This is the time the player's action rule:
	if the actor is the player and the turn duration < 0:
		follow the duration rules;
		if the turn duration < 0, now the turn duration is the seconds per turn.

The time the player's action rule is listed before the before stage rule in the action-processing rules.

Part - Realistic Time

Use realistic time translates as (- Constant NUANCED_REALISTIC_TIME; -).

[With realistic time, this replaces Inform's advance time rule: it counts the
turn, as that rule does, then advances the clock by the turn's duration instead
of a minute. Without it, Inform's own rule runs.]

This is the realistic time rule:
	if the realistic time option is active:
		increment the turn count;
		let D be the turn duration;
		if D < 0, now D is the seconds per turn;
		now the seconds count is the current seconds + D;
		while the seconds count is at least 60:
			now the seconds count is the seconds count - 60;
			now the time of day is the time of day + 1 minute;
		now the minute last kept is the time of day;
	otherwise:
		follow the advance time rule.

The realistic time rule is listed instead of the advance time rule in the turn sequence rules.

Part - Saying the Time

To say realistic time:
	let H be the hours part of the time of day;
	let M be the minutes part of the time of day;
	let S be the current seconds;
	let H12 be the remainder after dividing H by 12;
	if H12 is 0, now H12 is 12;
	say "[H12]:[if M < 10]0[end if][M]:[if S < 10]0[end if][S] [if H < 12]am[otherwise]pm[end if]".

Nuanced Timekeeping ends here.

---- DOCUMENTATION ----

This extension keeps time to the second, and lets different actions take different amounts of time.

Section: Realistic time

Turn it on with:

	Use realistic time.

Each turn then takes 15 seconds instead of Inform's usual minute, and the time of day moves on a minute every four turns. Change the length of a turn with:

	The seconds per turn is 20.

Any number of seconds works, including more than a minute.

Everything else about time carries on as usual: the turn count goes up by one each turn, timed events ("At 9:05 am: ...") fire, and the clock wraps at midnight. Out-of-world actions take no time, as always.

Section: Saying the time

"[realistic time]" says the time with seconds, such as "9:04:30 am". It can be used with or without realistic time; without it, every turn takes a whole minute and the seconds stay at zero.

	say "Your watch says it's [realistic time]."

The seconds past the minute are "the current seconds".

If the story sets the time of day itself ("now the time of day is 10:00 am"), the seconds start again from zero. The rest of that turn then passes as usual, so a turn of 15 seconds that sets the clock to 10:00 am ends at 10:00:15 am.

Section: How long actions take

With realistic time, actions can take different amounts of time. Write duration rules for them:

	Duration for examining: take 5 seconds.
	Duration for going: take 1 minute.
	Duration for examining the painting: take 2 minutes.
	Duration for waiting: take 30 seconds.
	Duration for looking: take no time.

Duration rules work like other rules about actions, so they can name things, places and conditions. The most specific rule applies: examining the painting takes two minutes, while examining anything else takes five seconds. An action with no duration rule takes the seconds per turn.

A turn takes the time of the action the player's command starts. Anything that action does along the way (an implicit take before eating, say, or going after GO FORWARD from another extension) is part of it, and a command for several things (TAKE ALL) takes the time of the first. A command given to another character ("Floyd, go north") takes the seconds per turn.

"Take no time" still counts the turn, and every-turn rules still run; it just leaves the clock where it is.

Section: Changes from version 1

(1) Realistic time is turned on with a use option, "Use realistic time", instead of listing the rule by hand.

(2) The turn count goes up again. In Inform 10, the advance time rule that version 1 replaced also counts turns, so with version 1 the turn count stayed at 1.

(3) Midnight and the hour after it say 12, not 0 ("12:00:15 am").

(4) The seconds start again from zero when the story sets the time of day.

(5) The length of a turn is a setting, the seconds per turn.

(6) New: duration rules, for actions that take different amounts of time.

Example: * Watching the Clock - Turns of different lengths, and a watch that shows the seconds.

	*: "Watching the Clock"

	Include Nuanced Timekeeping by Jeff Nyman.

	Use realistic time.

	When play begins:
		now the time of day is 11:58 pm.

	The Gallery is a room. "A long gallery. The east door leads to the Annex."
	The Annex is east of the Gallery. "A small annex, mostly empty."

	A painting is scenery in the Gallery. "A vast canvas, full of tiny figures. You could spend hours on it."
	A bench is a scenery supporter in the Gallery.

	The player carries a pocket watch. The description of the watch is "It says [realistic time]."

	Duration for examining: take 5 seconds.
	Duration for examining the painting: take 2 minutes.
	Duration for going: take 1 minute.
	Duration for examining the watch: take no time.

	At 12:00 am: say "Somewhere, a clock strikes midnight."

	Test me with "x watch / z / x watch / x bench / x watch / x painting / x watch / east / west / x watch".

The story starts at 11:58 pm, and the watch is read between actions: looking at it takes no time. Waiting takes the usual 15 seconds and examining the bench 5. The painting takes two minutes, which passes midnight, and going east and back takes a minute each way.
