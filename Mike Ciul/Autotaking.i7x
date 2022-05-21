Version 1 of Autotaking by Mike Ciul begins here.

"Implicit taking of noun or second noun that may be invoked by (or used as) a check rule."

Section - Sequential Action Option

Use sequential action translates as (- Constant SEQUENTIAL_ACTION; -).

Section - Autotaking Nouns Rules

This is the noun autotaking rule:
	if sequential action option is active:
		if the player is the person asked:
			try taking the noun;
		otherwise:
			try the person asked trying taking the noun;
	otherwise:
		if the player is the person asked:
			say "(first taking [the noun])";
			silently try taking the noun;
		otherwise:
			try the person asked trying taking the noun.
	
This is the second noun autotaking rule:
	if sequential action option is active:
		if the player is the person asked:
			try taking the second noun;
		otherwise:
			try the person asked trying taking the second noun;
	otherwise:
		if the player is the person asked:
			say "(first taking [the second noun])";
			silently try taking the second noun;
		otherwise:
			try the person asked trying taking the second noun.

Section - Must Hold Nouns Rules	

This is the must hold the noun rule:
	if the person asked does not have the noun, follow the noun autotaking rule;
	if the person asked does not have the noun, stop the action; 
	make no decision.

This is the must hold the second noun rule:
	if the person asked does not have the second noun, follow the second noun autotaking rule;
	if the person asked does not have the second noun, stop the action;
	make no decision.

Autotaking ends here.

---- DOCUMENTATION ----

Derived from (and largely copied and pasted from) Emily Short's extension "Locksmith," Autotaking provides a convenient way for any action to ensure that the noun or the second noun is held before being carried out. It also provides for the "sequential action" output style to be used instead of the default "(first taking the noun)" message.

Whenever we create an action that involves a noun or second noun that must be held, we can invoke the "must hold the noun" rule or the "must hold the second noun" rule:

	Attacking it with is an action applying to two things.

	The must hold the second noun rule is listed first in the check attacking it with rulebook.

This will generate an automatic take if the actor doesn't have the second noun, and the action will be stopped if the autotake fails.

We can also invoke the "noun autotaking" and "second noun autotaking" rules explicitly:

	Check an actor attacking something with something (this is the weapons must be held rule):
		if the actor does not hold the second noun, follow the second noun autotaking rule;
		if the actor does not hold the second noun, stop the action.

By default, automatic taking actions are described as other automatic actions usually are in Inform: the player sees something like "(first taking...)" before he takes an object used in an action. The "Use sequential action" mode is provided for the case where we would prefer to see "Taken." instead. 

Example: * Butterfingers - Making sure the "attacking it with" action always uses a held weapon.

	*: "Butterfingers"

	Include Autotaking by Mike Ciul.

	Attacking it with is an action applying to two things.

	Understand "attack [something] with [something]" as attacking it with.

	The must hold the second noun rule is listed first in the check attacking it with rulebook.

	Check attacking something with something:
		If the noun is not a person:
			say "You do very little damage to [the noun].";
			stop the action.

	Check attacking the player with something:
		say "You wound yourself slightly, but the pain causes you to stop.";
		stop the action.

	Carry out attacking something with something:
		Now the second noun is in the location.

	Report attacking something with something:
		say "With a mighty yell, you swing [the second noun] at [the noun]. Unfortunately, it slips from your sweaty fingers and falls to the ground."

	Arena is a room.

	The gladiator is a man in Arena.

	There is a sword in Arena. There is a big rock in Arena.

	Instead of taking the big rock, say "You strain to lift the rock, but it's too heavy for you."

	test me with "i/attack rock with sword/i/attack me with sword/attack gladiator with sword/g/attack gladiator with rock"
