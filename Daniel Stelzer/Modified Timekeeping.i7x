Version 1 of Modified Timekeeping by Daniel Stelzer begins here.

"Changes the one-minute-per-turn rule to account for failed and implicit actions."

"based on code by Vyznev Xnebara"

The action-processing success flag is a truth state that varies.

The modified generate action rule is listed instead of the generate action rule in the turn sequence rulebook.

The record action success rule is listed before the carry out stage rule in the specific action-processing rulebook.

Looking is acting fast.

This is the implicit actions add time rule:
	follow the advance time rule;
	follow the every turn rules;
	continue the activity.
The implicit actions add time rule is listed first in the for implicitly taking rulebook.

This is the modified generate action rule:
	now the action-processing success flag is false;
	abide by the generate action rule;
	[say "Current action: [current action].";]
	if the action-processing success flag is false, rule succeeds;
	if the current action is acting fast, rule succeeds;
	make no decision.
	[say "    Time passing.";]

This is the record action success rule: now the action-processing success flag is true; make no decision.

To take no time:
	now the action-processing success flag is false.
To say take no time:
	now the action-processing success flag is false.
To take full time:
	now the action-processing success flag is true.
To say take full time:
	now the action-processing success flag is true.

Section A - Implicit Actions (for use with Implicit Actions by Eric Eve)

The implicit actions add time rule is listed first in the for implicitly opening rulebook.
The implicit actions add time rule is listed first in the for implicitly unlocking rulebook.
The implicit actions add time rule is listed first in the for implicitly closing rulebook.
The implicit actions add time rule is listed first in the for implicitly exiting rulebook.

Modified Timekeeping ends here.

---- DOCUMENTATION ----

With this extension installed, failed actions take no time and successful implicit actions do; that is, if you enter the commands "drop watch", "eat watch", "eat watch" in sequence, the first eating attempt will take a turn (because the player picks up the watch before realizing that it's inedible) but the second does not (because he already carries it). The phrase (and say-phrase) "take no time" causes a successful action to take no time as well, whereas "take full time" is the reverse. Neither of these will have any effect in a before, check, or instead rule; they are meant to be used at the carry out stage or later. Defining an action as "acting fast" does the same thing.
