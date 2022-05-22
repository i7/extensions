Version 1 of Cleared Events by Daniel Stelzer begins here.

Include (-
[ ClearTimedEvent rule i b;
	for (i=1: i<=(TimedEventsTable-->0): i++) {
		if (rule == TimedEventsTable-->i) { b=i; break; }
		if (TimedEventsTable-->i == 0) rtrue; ! We went through the whole table and didn't find this event.
	}
	TimedEventsTable-->b = 0;
];
-).

To (R - rule) never:
	(- ClearTimedEvent({-mark-event-used:R}); -).

Cleared Events ends here.

---- DOCUMENTATION ----
This is a very simple extension, adding only a single phrase.

	(timed event) never.

This turns off a timed event, preventing it from firing (until it's set again). For example:

	Instead of pressing the red button:
		say "Tick...tick...tick...";
		the bomb explodes in five turns from now.
	
	Instead of pressing the green button:
		say "The ticking ceases.";
		the bomb explodes never.

The green button now disarms the bomb, but pressing the red button again will re-start the timer at five minutes.
