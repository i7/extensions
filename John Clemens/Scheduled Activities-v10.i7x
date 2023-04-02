Version 10.1 of Scheduled Activities by John Clemens begins here.

"An extension to allow scheduling of activities."

Section 1 - Scheduling Rule

Table of Scheduled Events
SA_Moment	SA_Turn	SA_Event	SA_Object_Event		SA_Target		SA_Similar
a time	a number	an activity on nothing	an activity on objects		an object		a number
with 49 blank rows

This is the scheduled events rule:
	check skipped events;
	now stored_preceding is 0;
	repeat through the Table of Scheduled Events:
		if (there is a SA_Moment entry and the SA_Moment entry is time of day) or (there is a SA_Turn entry and the SA_Turn entry is turn count):
			if there is a SA_Similar entry and SA_Similar entry is 1:
				 now stored_preceding is 2;
			otherwise:
				if there is a SA_Event entry, mark SA_Event entry activities;
				otherwise mark SA_Object_Event entry activities;
			if there is a SA_Target entry, carry out the SA_Object_Event entry activity with the SA_Target entry;
			otherwise carry out the SA_Event entry activity; 
			if a paragraph break is pending, say conditional paragraph break;
			now stored_preceding is 1;
			blank out the whole row;
	unmark similar entries.

The scheduled events rule is listed before the timed events rule in the turn sequence rules.


Section 2 - Utility functions - unindexed

The stored_preceding is a number that varies. The stored_preceding is 0.
 
[ 0: first activity this turn, 1 : some activity precedes, 2: same activity precedes]

To mark (E - activity) activities:
	repeat through the Table of Scheduled Events:
		if the SA_Event entry is E, now the SA_Similar entry is 1.

To mark (E - activity on objects) activities:
	repeat through the Table of Scheduled Events:
		if the SA_Object_Event entry is E, now the SA_Similar entry is 1.


To unmark similar entries:
	repeat through the Table of Scheduled Events:
		now the SA_Similar entry is 0.

[ The next check is done to account for time advancements of more than one minute. ]

To check skipped events:
	unless skipped events, rule succeeds;
	while skipped events:
		repeat through the Table of Scheduled Events in SA_Moment order:
			if there is a SA_Target entry, carry out the SA_Object_Event entry activity with the SA_Target entry;
			otherwise carry out the SA_Event entry activity;
			if a paragraph break is pending, say conditional paragraph break;
			blank out the whole row.
	
To decide if skipped events:
	repeat through the Table of Scheduled Events:
		if there is a SA_Moment entry and the SA_Moment entry is before the time of day and 30 minutes after the SA_Moment entry is after the time of day, decide yes;
	decide no.


Section 3 - Scheduling activities

To schedule (E - activity on objects) for/on/with (T - object) at (M - time):
	if the number of blank rows in the Table of Scheduled Events is 0, rule fails;
	choose a blank row in the Table of Scheduled Events;
	now the SA_Moment entry is M;
	now the SA_Object_Event entry is E;
	now the SA_Target entry is T.

To schedule (E - activity) at (M - time):
	if the number of blank rows in the Table of Scheduled Events is 0, rule fails;
	choose a blank row in the Table of Scheduled Events;
	now the SA_Moment entry is M;
	now the SA_Event entry is E.

To schedule (E - activity on objects) for/on/with (T - object) in/on/after (n - number) minutes: 
	schedule E for T at n minutes after the time of day.

To schedule (E - activity) in/after (n - number) minute/minutes: 
	schedule E at n minutes after the time of day.

To schedule (E - activity on objects) for/on/with (T - object) now: 
	schedule E for T at the time of day.

To schedule (E - activity) now: 
	schedule E at the time of day.

To schedule (E - activity on objects) for/on/with (T - object) in/on/after (d - number) turn/turns:
	if the number of blank rows in the Table of Scheduled Events is 0, rule fails;
	choose a blank row in the Table of Scheduled Events;
	now the SA_Turn entry is turn count + d;
	now the SA_Object_Event entry is E;
	now the SA_Target entry is T.

To schedule (E - activity) in/on/after (d - number) turn/turns:
	if the number of blank rows in the Table of Scheduled Events is 0, rule fails;
	choose a blank row in the Table of Scheduled Events;
	now the SA_Turn entry is turn count + d;
	now the SA_Event entry is E;

To schedule (E - activity on objects) for/of/with (T - object) in/at/for (d - number) turn/turns from now:
	schedule E for T in d turns.

To schedule (E - activity) in (d - number) turn/turns from now:
	schedule E in d minutes.

Section 4 - Scheduling activities on descriptions of objects

To schedule (E - activity on objects) in (n - number) minute/minutes for (C - description of objects): 
	repeat with T running through C begin; schedule E for T in n minutes; end repeat.

To schedule (E - activity on objects) in (d - number) turn/turns for (C - description of objects):
	repeat with T running through C begin; schedule E for T in d turns; end repeat.

To schedule (E - activity on objects) in (d - number) turn/turns from now for (C - description of objects):
	repeat with T running through C begin; schedule E for T in d turns; end repeat.

Section 5 - Canceling activities

To cancel all scheduled events for/on/with (T - object):
	repeat through the Table of Scheduled Events:
		if there is a SA_Target entry and the SA_Target entry is T, blank out the whole row.

To cancel all scheduled events:
	repeat through the Table of Scheduled Events:
		blank out the whole row.

To cancel next timed event for/on/with (T - object):
	repeat through the Table of Scheduled Events in SA_Moment order:
		if there is a SA_Target entry and SA_Target entry is T:
			blank out the whole row;
			rule succeeds.
		
To cancel next timed event:
	repeat through the Table of Scheduled Events in SA_Moment order:
		blank out the whole row;
		rule succeeds.

To cancel all scheduled (E - activity):
	repeat through the Table of Scheduled Events:
		if there is an SA_Event entry and the SA_Event entry is E, blank out the whole row.

To cancel all scheduled (E - activity on objects):
	repeat through the Table of Scheduled Events:
		if there is an SA_Object_Event entry and the SA_Object_Event entry is E, blank out the whole row.

To cancel all scheduled (E - activity on objects) for/on/with (T - object):
	repeat through the Table of Scheduled Events:
		if there is a SA_Target entry and the SA_Target entry is T and there is an SA_Object_Event entry and the SA_Object_Event entry is E, blank out the whole row.

To cancel all scheduled events at (M - time):
	repeat through the Table of Scheduled Events:
		if there is a SA_Moment entry and the SA_Moment entry is M, blank out the whole row.

To cancel all scheduled events for/on/with (T - object) at (M - time):
	repeat through the Table of Scheduled Events:
		if there is a SA_Target entry and the SA_Target entry is T and there is a SA_Moment entry and the SA_Moment entry is M, blank out the whole row.


Section 6 - Checking activities

To decide if there is an event scheduled:
	if the number of filled rows in the Table of Scheduled Events is 0, decide no;
	decide yes.

To decide if there is an event scheduled for/on/with (T - object):
	if there is a SA_Target of T in the Table of Scheduled Events, decide yes;
	decide no.

To decide if there is (E - activity on objects) scheduled for/on/with (T - object):
	repeat through the Table of Scheduled Events:
		if there is a SA_Target entry and the SA_Target entry is T and there is an SA_Object_Event entry and the SA_Object_Event entry is E, decide yes;
	decide no.

To decide if there is (E - activity) scheduled:
	if there is an SA_Event of E in the Table of Scheduled Events, decide yes;
	decide no.

To decide if there is (E - activity on objects) scheduled:
	if there is an SA_Object_Event of E in the Table of Scheduled Events, decide yes;
	decide no.

To decide if there is an event scheduled at (M - time):
	if there is a SA_Moment of M in the Table of Scheduled Events, decide yes;
	decide no.

To decide if there is an event scheduled for/on/with (T - object) at (M - time):
	repeat through the Table of Scheduled Events:
		if there is a SA_Target entry and the SA_Target entry is T and there is a SA_Moment entry and the SA_Moment entry is M, decide yes;
	decide no.

To decide if there is (E - activity) scheduled at (M - time):
	repeat through the Table of Scheduled Events:
		if there is a SA_Moment entry and the SA_Moment entry is M and there is an SA_Event entry and the SA_Event entry is E, decide yes;
	decide no.

To decide if there is (E - activity on objects) scheduled at (M - time):
	repeat through the Table of Scheduled Events:
		if there is a SA_Moment entry and the SA_Moment entry is M and there is an SA_Object_Event entry and the SA_Object_Event entry is E, decide yes;
	decide no.


To decide if there is (E - activity on objects) scheduled for/on/with (T - object) at (M - time):
	repeat through the Table of Scheduled Events:
		if there is a SA_Target entry and the SA_Target entry is T and there is an SA_Object_Event entry and the SA_Object_Event entry is E and there is a SA_Moment entry and the SA_Moment entry is M, decide yes;
	decide no.

To decide if there is an event scheduled now:
	repeat through the Table of Scheduled Events:
		if (there is a SA_Moment entry and the SA_Moment entry is time of day) or (there is a SA_Turn entry and the SA_Turn entry is turn count), decide yes;
	decide no.
	
To decide if there is (E - activity) scheduled now:
	repeat through the Table of Scheduled Events:
		if there is an SA_Event entry and the SA_Event entry is E:
			if (there is a SA_Moment entry and the SA_Moment entry is time of day) or (there is a SA_Turn entry and the SA_Turn entry is turn count), decide yes;
	decide no.

To decide if there is (E - activity on objects) scheduled now:
	repeat through the Table of Scheduled Events:
		if there is an SA_Object_Event entry and the SA_Object_Event entry is E:
			if (there is a SA_Moment entry and the SA_Moment entry is time of day) or (there is a SA_Turn entry and the SA_Turn entry is turn count), decide yes;
	decide no.

To decide if there is an event scheduled for/on/with (T - object) now:
	repeat through the Table of Scheduled Events:
		if there is a SA_Target entry and the SA_Target entry is T:
			if (there is a SA_Moment entry and the SA_Moment entry is time of day) or (there is a SA_Turn entry and the SA_Turn entry is turn count), decide yes;
	decide no.
	
To decide if there is (E - activity on objects) scheduled for/on/with (T - object) now:
	repeat through the Table of Scheduled Events:
		if there is an SA_Object_Event entry and the SA_Object_Event entry is E and there is a SA_Target entry and the SA_Target entry is T:
			if (there is a SA_Moment entry and the SA_Moment entry is time of day) or (there is a SA_Turn entry and the SA_Turn entry is turn count), decide yes;
	decide no. 

Section 7 - Reporting activities

To decide if first current activity:
	if stored_preceding is 0, decide yes;
	decide no.

To decide if first similar activity:
	if stored_preceding is 2, decide no;
	decide yes.

Pending relates an object (called T) to an activity on objects (called E) when there is E scheduled for T now.
The verb to be pending implies the pending relation.

Section 8 - Phrases for descriptions

To schedule (E - activity on objects) at (M - time) for/on/with (C - description of objects):
	repeat with T running through C begin; schedule E for T at M; end repeat;

To schedule (E - activity on objects) in (n - number) minutes for/on/with (C - description of objects): 
	repeat with T running through C begin; schedule E for T in n minutes; end repeat.

To schedule (E - activity on objects) now for/on/with (C - description of objects): 
	repeat with T running through C begin; schedule E for T at the time of day; end repeat.

To schedule (E - activity on objects) in (d - number) turns for/on/with (C - description of objects):
	repeat with T running through C begin; schedule E for T in d turns; end repeat.

To cancel all scheduled events for/on/with (C - description of objects):
	repeat with T running through C begin; cancel all scheduled events for T; end repeat.

To cancel all scheduled (E - activity on objects) for/on/with (C - description of objects):
	repeat with T running through C begin; cancel all scheduled E for T; end repeat.
	
To decide if there is an event scheduled for/on/with (C - description of objects):
	repeat through the Table of Scheduled Events:
		if there is a SA_Target entry and the SA_Target entry matches C, decide yes;
	decide no.
	
To decide if there is (E - activity on objects) scheduled for/on/with (C - description of objects):
	repeat through the Table of Scheduled Events:
		if there is a SA_Target entry and the SA_Target entry matches C and there is an SA_Event entry and the SA_Event entry is E, decide yes;
	decide no.
	
To decide if there is an event scheduled now for/on/with (C - description of objects):
	repeat through the Table of Scheduled Events:
		if there is a SA_Target entry and the SA_Target entry matches C:
			if (there is a SA_Moment entry and the SA_Moment entry is time of day) or (there is a SA_Turn entry and the SA_Turn entry is turn count), decide yes;
	decide no.
	
To decide if there is (E - activity on objects) scheduled now for/on/with (C - description of objects):
	repeat through the Table of Scheduled Events:
		if there is an SA_Event entry and the SA_Event entry is E and there is a SA_Target entry and the SA_Target entry matches C:
			if (there is a SA_Moment entry and the SA_Moment entry is time of day) or (there is a SA_Turn entry and the SA_Turn entry is turn count), decide yes;
	decide no.


Scheduled Activities ends here.

---- Documentation ----

This extension allows activities to be scheduled at absolute and relative times. These activities may later be checked or cancelled. The advantage of this over the standard events is that activities may take a variable, and the same activity may be scheduled multiple times. Rudimentary support is also provided for grouping output of multiple activities scheduled for the same turn. The extension only allows for activities which are applied to objects or to nothing (i.e., it does not allow activities applied to other kinds of value).

Scheduled activities are stored in a table called the Table of Scheduled Events. This table initially holds 50 future activities; if more storage is needed, you can add a table continuation as follows:
	Table of Scheduled Events (continued)
	SA_Moment	SA_Turn	SA_Event	SA_Object_Event	SA_Target	SA_Similar
	a time	a number	an activity on nothing	an activity on objects	an object	a number
	with 100 blank rows

A new rule (the scheduled events rule) is inserted before the timed events rule (the rule which handles the usual timed events). So scheduled activities will occur immediately before events invoked with phrases like "the egg-timer clucks in four turns from now".

SCHEDULING: The extension provides the following phrases to schedule activities:
	schedule (an activity) for (an object) at (a time)
	schedule (an activity) at (a time)
	schedule (an activity) for (an object) in (a number) minutes
	schedule (an activity) in (a number) minutes
	schedule (an activity) for (an object) now
	schedule (an activity) now
	schedule (an activity) for (an object) in (a number) turns
	schedule (an activity) in (a number) turns

Here, "now" means at the end of the current turn.

CANCELING: Activities can also be canceled:
	cancel all scheduled events for (an object)
	cancel all scheduled events
	cancel next timed event for (an object)
	cancel next timed event
	cancel all scheduled (an activity)
	cancel all scheduled (an activity) for (an object)
	cancel all scheduled events at (a time)
	cancel all scheduled events for (an object) at (a time)

Note that "next timed event" considers only events scheduled in times, not those scheduled in turns. Also note that only activities scheduled with the phrases above can be canceled or checked in this way.

CHECKING: The following conditions are supplied:
	if there is an event scheduled
	if there is an event scheduled for (an object)
	if there is (an activity) scheduled for (an object)
	if there is (an activity) scheduled
	if there is an event scheduled at (a time)
	if there is an event scheduled for (an object) at (a time)
	if there is (an activity) scheduled at (a time)
	if there is (an activity) scheduled for (an object) at (a time)
	if there is an event scheduled now
	if there is (an activity) scheduled now
	if there is an event scheduled for (an object) now
	if there is (an activity) scheduled for (an object) now

REPORTING: Several conditions allow better reporting of multiple activities happening in the same turn.
	if first current activity

This condition is true when carrying out the first scheduled activity during a given turn.
	if first similar activity

This condition is true when carrying out a particular activity for the first time during a given turn (even if other activities have been carried out). This can be used to combine reports for carrying out the same activity with multiple objects in the same turn; see the example "Bunnies".

Note that these two conditions do not apply to skipped events caused by changing the time directly.

A new relation, the pending relation, is defined between objects and activities when the given activity is scheduled for the object during the current turn. So, for instance, the condition
	if a rabbit is pending waking

will be true if the waking activity is scheduled for some rabbit during the current turn.

DESCRIPTIONS: Several phrases are included allowing object descriptions, so it is possible to say, for instance, "schedule dispersing in 5 turns for everything enclosed by the location." The included phrases are:
	schedule (an activity) at (a time) for (a description)
	schedule (an activity) in (a number) minutes for (a description)
	schedule (an activity) now for (a description)
	schedule (an activity) in (a number) turns for (a description)
	cancel all scheduled events for (a description)
	cancel all scheduled (an activity) for (a description)
	if there is an event scheduled for (a description)
	if there is (an activity) scheduled for (a description)
	if there is an event scheduled now for (a description)
	if there is (an activity) scheduled now for (a description)


Example: * Tinitinitis - Scheduling, testing, and canceling activities.
	
	*:"Tinitinitis"

	Include Scheduled Activities by John Clemens.

	The Concert Hall is a room.

	A percussive instrument is a kind of thing. A percussive instrument can be ringing.  A percussive instrument has a number called duration. The duration of a percussive instrument is usually 5.

	The cymbal is a percussive instrument in the concert hall. 
	The triangle is a percussive instrument in the concert hall. The duration of the triangle is 1.
	
	Striking is an action applying to one thing. Understand "strike [something]" as striking.
	Report striking: say "You strike [the noun]."

	Instead of striking a percussive instrument:
		if the noun is ringing, say "You strike [the noun] again[if the noun is pending silencing], just in time[end if].";
		otherwise say "You strike [the noun] and it starts ringing.";
		now the noun is ringing;
		cancel all scheduled silencing for the noun;
		schedule silencing for the noun in duration of noun minutes.

	Silencing something is an activity.
	Rule for silencing something (called bell):
		if the bell is ringing, say "[The bell] stops ringing.";
		now the bell is not ringing.
	
	Test me with "strike cymbal / strike cymbal / strike triangle / strike triangle / z / z / z".

Example: * Perfume - Using descriptions and rooms.

	*:"Perfume"

	Include Scheduled Activities by John Clemens.

	A room is either smelly or unscented. A room is usually unscented.
	A thing is either smelly or unscented. A thing is usually unscented.

	Instead of smelling a smelly room: say "A horrible perfume odor assaults your nostrils."
	Instead of smelling a smelly thing, say "You can still smell the perfume on [the noun]."

	Living room is a room. Study is west of the living room. Kitchen is east of the living room.
	A rare book, a newspaper, and a sweater are in the study. 

	The perfume bottle is in the living room. The description is "A perfume spray bottle."

	Dispersing something is an activity.
	Rule for dispersing a room (called place):
		if place is smelly and place is the location, say "The perfume haze finally clears.";
		now place is unscented.
	Rule for dispersing a thing (called item): now item is unscented.

	Understand "spray [something]" as spraying. Spraying is an action applying to one carried thing.
	Check spraying: if the noun is not the perfume, instead say "You can't spray that."
	Carry out spraying:
		cancel all scheduled dispersing for the location;
		cancel all scheduled dispersing for everything enclosed by the location;
		now the location is smelly;
		now everything enclosed by the location is smelly;
		schedule dispersing for the location in 2 turns;
		schedule dispersing in 5 turns for everything enclosed by the location.
	Report spraying: say "You spray the perfume into the air, leaving a noxious haze."
	
	Test me with "smell / spray perfume / smell /  w /smell book / spray perfume / smell / smell book / smell / smell book / e / smell / w / smell book".

Example: ** Bunnies - Grouping activity reports.

	*:"Bunnies"

	Include Scheduled Activities by John Clemens.

	When play begins, say "You have snuck into the castle to steal the King's scepter. You have heard tales of the fierce rabbits guarding the palace, but are armed with a supply of holy hand grenades."

	A mood is a kind of value. The moods are asleep, suspicious, vicious, and mutilated.

	Definition: a rabbit is living if it is not mutilated.

	To say long mood of (bugs - a rabbit): 
		if bugs is asleep, say "sleeping peacefully";
		if bugs is suspicious, say "eyeing you suspiciously";
		if bugs is vicious, say "snarling viciously";
		if bugs is mutilated, say "splattered on the walls".

	A rabbit is a kind of animal. A rabbit has a mood. A rabbit is usually asleep. Understand the mood property as describing a rabbit. The printed name of a rabbit is usually "[mood] rabbit". The printed plural name of a rabbit is usually "[mood] rabbits".
	Rule for printing the name of a rabbit (called bugs) while listing contents of a room: say "rabbit [long mood of item described]". Rule for printing the plural name of a rabbit while listing contents of a room: say "rabbits [long mood of item described]".

	Instead of doing something to a mutilated rabbit, say "There's really not much left of it."

	After going to somewhere:
		repeat with bugs running through rabbits in location begin;
			if bugs is asleep, schedule rousing for bugs now;
			if bugs is suspicious, schedule angering for bugs now;
		end repeat;
		continue the action.

	Every turn when a vicious rabbit is in location:
		say "You are suddenly beset by sharp pointy teeth as [if the number of vicious rabbits in location > 1][the number of vicious rabbits in location in words] vicious rabbits lunge[otherwise]a vicious rabbit lunges[end if] for your throat.";
		end the game in death.

	Rousing something is an activity. 
	Rule for rousing an asleep rabbit (called bugs): 
		now bugs is suspicious;
		schedule angering for bugs in 1 turn;
		if first similar activity and a visible rabbit is pending rousing, say "Hearing you, the sleeping rabbit[if the number of visible rabbits pending rousing is 1] begins[otherwise]s begin[end if] to stir."

	Angering something is an activity. 
	Rule for angering a suspicious rabbit (called bugs):
		now bugs is vicious;
		if first similar activity and a visible rabbit is pending angering, say "The suspicious rabbit[if the number of visible rabbits pending angering is 1] bares its[otherwise]s bare their[end if] teeth at you."

	A holy hand grenade is a kind of thing. The player carries five holy hand grenades.

	Understand "throw [holy hand grenade] [direction]" as lobbing it toward. Understand the commands "lob" and "lobbeth" as "throw". Instead of dropping a holy hand grenade, try lobbing the noun toward down.

	Lobbing it toward is an action applying to one carried thing and one visible thing.

	Check lobbing it toward: abide by the can't drop what's not held rule.

	The target room is a room that varies.

	Carry out lobbing it toward:
		if there is exploding scheduled for the noun begin;
			say "You throw the grenade";
		otherwise;
			say "You pull the pin and throw the grenade";
			schedule exploding for the noun in 2 turns;
		end if;
		now the target room is the room second noun from location;
		if the second noun is down, now the target room is location;
		if target room is not a room begin;
			say " [second noun], where it bounces off [if second noun is up]the ceiling[otherwise]the wall[end if] and lands at your feet.";
			move noun to location;
		otherwise;
			if target room is location, say " on the ground.";
			otherwise say " into [the target room].";
			move noun to target room;
		end if.
	
	Exploding something is an activity. 
	Rule for exploding a holy hand grenade (called bomb):
		if bomb is in the location begin;
			say "[bold type]Boom! [roman type]The grenade explodes, killing you instantly.";
			cancel all scheduled events;
			end the game in death;
		otherwise;
			let destroyed be the location of bomb;
			if destroyed is a room begin;
				say "You hear an explosion from [the best route from location to destroyed][if a living rabbit is in destroyed], followed by the unmistakable sound of rabbit screams[end if].";
				now every rabbit in destroyed is mutilated;
				[we do not need to cancel activities for the rabbits since the activity rules don't apply to mutilated rabbits]
				repeat with item running through holy hand grenades in destroyed begin;
					cancel all scheduled events for item;
					remove item from play;
				end repeat;
			end if;
		end if.		

	The Entrance is a room. "A Hall stretches to the east, and the exit is back west."
	The Hall is east of the entrance. "The entrance is west, and the banquet room is south." In the Hall are five rabbits.
	The Banquet Room is south of the hall. "The hall is north, and the throne room is west." In the Banquet Room are 3 rabbits and 1 suspicious rabbit.
	The Throne room is west of the banquet room. "The treasure is stored here." In the throne room are two vicious rabbits.
	The scepter is in the throne room. The description of the scepter is "Covered with jewels, and worth the risk."
	Instead of going west in the Entrance: say "Not without the scepter."
	Instead of going west in the Entrance when the player carries the scepter: say "You escape with the scepter, ensuring your fortune."; end the game in victory.

	Test me with "e / lobbeth holy hand grenade / w / z / e / throw grenade s / z / z / s / throw grenade w / z / z / w / take scepter / e / n / w / w".

	Test death with "e / s / n".


Section Changelog

version 10.1.1 2023-04-01 removed "for 6M62" from rubric for v10 version

version 10 January 10, 2022
	updated for 6M62 by Zed Lopez

version 9 September 10, 2010
	updated activity types for compatibility with 6E59/6E72 type checking
	minor code cleanup

version 8 (May 11, 2009)
	code cleanup
	more explicit table column names to preclude conflicts
	pending relation now behaves properly again

version 7 (May 8, 2008)
	updated for compatibility with 5T18
	updated documentation
	minor code improvement

version 6 (date forgotten)
	minor compatibility update

version 5 (August 11, 2007)
	Updated for compatibility with 4W37
	changed the Target column to SA_Target to avoid name-space conflict

version 4 (March 26, 2007) 
	Updated for compatibility with 4S08
	Pending relation replaced with several phrase for compatibility with 4S08
	Removed use of procedural rule
	Changed skipped events checking to agree with Inform behavior for timed events (processes events less than 30 minutes before time of day)
	Fixed bug to do with checking preceding similar activities

version 3 (October 1, 2006)
	Note: This version requires at least compiler version 3Z95; if you are using an earlier compiler version you should use version 2.
	"Thing" has been changed to "object", so activities can now be scheduled for rooms
	Added phrases utilizing descriptions
	Added example "Perfume"
	Added syntax for "turn", "minute", and "turns from now"
	Updated documentation
	Updated example "Bunnies" for 3Z95
	Minor tidying of code

version 2 (July 19, 2006):
	Improved paragraph breaks between activities
	Added the new syntax: schedule now
	Added reporting conditions: if first current activity and if first similar activity
	Added the pending relation
	Added example "Bunnies"

version 1 (July 15, 2006): Initial version 
