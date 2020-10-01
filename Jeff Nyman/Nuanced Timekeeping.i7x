Version 1/201001 of Nuanced Timekeeping by Jeff Nyman begins here.

"Provides more nuanced aspects of tracking time within a game."

Chapter - Realistic Time

Section - Seconds

The seconds count is a number that varies.
The seconds count is 0.

Section - Time Rule

This is the realistic time rule:
	now the seconds count is the seconds count + 15;
	while the seconds count is at least 60
	begin;
		now the seconds count is the seconds count - 60;
		now the time of day is the time of day + 1 minute;
	end while.

Section - Phrase for Time

To say realistic time:
	say "[if the hours part of the time of day is greater than 12][the hours part of the time of day - 12][otherwise][the hours part of the time of day][end if]:[if the minutes part of the time of day is less than 10]0[end if][the minutes part of the time of day]:[if seconds count is less than 10]0[end if][seconds count] [if the hours part of the time of day is at most 11]am[otherwise]pm[end if]"

Nuanced Timekeeping ends here.

---- DOCUMENTATION ----

This extension provides a slightly more realistic accounting of time by allowing the time value to include seconds.

If you want the more nuanced, or more realistic, you simply have to apply the rule from this extension as so:

	The realistic time rule is listed instead of the advance time rule in the turn sequence rules.

If you want the time to be reflected you can use a phrase as such:

	say "Your watch says it's [realistic time]."
