Distant Movement by Daniel Stelzer begins here.

Include Hidden Prompt by Daniel Stelzer.
Include Epistemology by Eric Eve.

Volume - Definitions

Book I - Rooms

A room can be familiar or unfamiliar. A room is usually unfamiliar.
Definition: a room is known rather than unknown:
	if it is visited, yes;
	if it is familiar, yes;
	no.

The continuation count is initially zero.

Definition: a room is navigable rather than innavigable if it is known. [TODO: expand]

Book II - People

A person has an object called the destination. The destination of a person is usually nothing.
Definition: a person is non-travelling rather than travelling if her destination is nothing.

A person can be currently moving. [This means they moved this turn; following characters should continue to follow.] A person is usually not currently moving.
Carry out an actor going:
	now the actor is currently moving.
After reading a command:
	now every person is not currently moving.

Definition: a person is other if they are not the player.

Every turn when an other person is travelling (this is the move travelling NPCs rule):
	repeat with the subject running through travelling other people:
		try the subject continuing.

Volume - Actions

Book I - Navigating To and Finding

Navigating to is an action applying to one visible thing. Understand "go to [any room]" or "navigate to [any room]" or "approach [any room]" or "find [any room]" or "come to/-- [any room]" as navigating to.
Understand "here" as a room when the item described is the location. [ALICE, COME HERE]

Check an actor navigating to a room (this is the don't navigate to innavigable destination rule):
	if the noun is innavigable:
		if the actor is the player, say "[We] [don't] know where that [regarding nothing][are]." (A);
		stop the action.

Check an actor navigating to a room (this is the don't navigate to the location rule):
	if the noun is the location of the actor:
		if the actor is the player, say "[We]['re] already [here]." (A);
		stop the action.

Carry out an actor navigating to a room (this is the convert navigating rule):
	now the destination of the actor is the noun;
	if the actor is the player:
		say "[We] [set] out toward [the noun]." (A);
		hide the command prompt with implicit command "continue";
		now the continuation count is zero;
		try continuing;

Finding is an action applying to one visible thing. Understand "go to [any known thing]" or "navigate to [any known thing]" as finding.

Check an actor finding something (this is the don't find unknown things rule):
	if the noun is unknown:
		if the actor is the player, say "[We] [don't] know where [regarding the noun][those] [are]." (A);
		stop the action.

Check an actor finding something (this is the don't find visible things rule):
	if the noun is enclosed by the location of the actor:
		if the actor is the player, say "[The noun] [are] close at hand already." (A);
		stop the action.

Carry out an actor finding something (this is the convert finding rule):
	now the destination of the actor is the noun;
	if the actor is the player:
		say "[We] [set] out toward [the noun]." (A);
		hide the command prompt with implicit command "continue";
		now the continuation count is zero;
		try continuing;

[Report finding something (this is the standard report finding rule):
	say "[We] [set] out toward [the destination of the player]." (A).]

Chapter 1 - Modified Finding (for use with Remembering by Aaron Reed)

Understand "approach [any known thing]" or "find [any known thing]" as remembering.

Section A - Glulx (for Glulx only)

To decide what room is the location-conversion of (item - an object):
	if the item is a room, decide on the item;
	if the item is seen, decide on the remembered location of the item;
	decide on the location of the item.

Section B - Z-Machine (for Z-Machine only)

To decide what room is the location-conversion of (item - an object):
	if the item is a room, decide on the item;
	decide on the location of the item.

Chapter 2 - Unmodified Finding (for use without Remembering by Aaron Reed)

Understand "approach [any known thing]" or "find [any known thing]" as finding.

To decide what room is the location-conversion of (item - an object):
	if the item is a room, decide on the item;
	decide on the location of the item.

Book II - Continuing and Stopping

Continuing is an action applying to nothing. Understand "continue" as continuing.

Check an actor continuing (this is the need a destination rule):
	if the destination of the actor is nothing:
		if the actor is the player, say "But you aren't going anywhere at the moment." (A);
		stop the action.

Carry out continuing when hidden prompt is false (this is the hide command prompt when continuing rule):
	say "You continue toward [the destination of the player]." (A);
	hide the command prompt with implicit command "continue";
	now the continuation count is zero.

Carry out continuing when hidden prompt is true (this is the increment continuation count rule):
	increment the continuation count.

The increment continuation count rule is listed after the hide command prompt when continuing rule in the carry out continuing rulebook. [So that the count is incremented the first turn of movement.]

Carry out an actor continuing (this is the convert continuing rule):
	let the place be the location-conversion of the destination of the actor;
	try the actor moving toward the place;
	[Now check if the actor has arrived.]
	let the place be the destination of the actor;
	if the place is not a room, let the place be the location of the place;
	if the location of the actor is the place:
		silently try the actor stopping.

Stopping is an action applying to nothing. Understand "stop" or "halt" as stopping.

Carry out stopping when hidden prompt is true (this is the show command prompt when stopping rule):
	show the command prompt.

Carry out an actor stopping (this is the standard stopping rule):
	now the destination of the actor is nothing.

Report stopping (this is the standard report stopping rule):
	say "You stop in your tracks." (A).

Book III - Moving Toward

Moving toward is an action applying to one visible thing. Understand "move toward [any room]" or "step toward [any room]" or "step to [any room]" or "approach [any room]" as moving toward.

The moving toward action has an object called the direction moved. The moving toward action has an object called the room moved toward.
Setting action variables for moving toward (this is the set direction moved rule):
	now the direction moved is the best route from the location of the actor to the noun[ through navigable rooms], using even locked doors;
	if the direction moved is a direction:
		now the room moved toward is the room direction moved from the location of the actor.

Check an actor moving toward a room (this is the don't move toward the location rule):
	if the noun is the location of the actor:
		if the actor is the player, say "You are already here." (A);
		stop the action.

Check an actor moving toward a room (this is the don't move when there's no path rule):
	if the direction moved is nothing: [I.e. there's no path]
		if the actor is the player, say "You can't think of any direct route from here to [the noun]." (A);
		silently try the actor stopping;
		stop the action.

Carry out moving toward a room when the action is not silent (this is the report moving toward rule): [This should really be in a Report rule, but that would run *after* the room description had been printed. We want it before.]
	now the prior named object is the player;
	let the place be the destination of the player;
	if the place is not a room, let the place be the location of the place;
	if the room moved toward is the place or the place is nothing:
		if the continuation count is greater than 1:
			say "...and finally [direction moved] to arrive at [the room moved toward]." (A);
		otherwise:
			say "[We] [go] [direction moved] to [the room moved toward]." (B);
		continue the action;
	if the continuation count is:
		-- 0: do nothing;
		-- 1: say "[We] [start] [direction moved] towards [the room moved toward]" (C);
		-- 2: say "...then [regarding the player][continue] [direction moved] to [the room moved toward]" (D);
		-- 3: say "...[run paragraph on][direction moved] through [the room moved toward]" (E);
		-- otherwise: say "...[run paragraph on][direction moved] [one of]to[or]through[or]toward[at random] [the room moved toward]" (F);
	say "...".
To head is a verb. To start is a verb. To continue is a verb.

Carry out an actor moving toward a room (this is the convert moving toward rule):
	try the actor going the direction moved.

Distant Movement ends here.
