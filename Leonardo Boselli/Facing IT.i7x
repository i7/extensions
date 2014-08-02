Version 9 of Facing IT by Leonardo Boselli begins here.

"Basato su Version 9 of Facing by Emily Short."

"Provides actions to face a direction, look toward a named room, or look through a named door."

[ There are three possible ways the player can specify that he wishes to look into another room from the present location:

1. facing a direction; 2. looking toward a named room; 3. looking through a given door.

In all three cases we want to establish the direction, the goal room, and the intervening door, then apply check and carry out rules in a sensible way. This is not quite as complex as the going action, which has to keep track of direction traveled, door traveled through, objects pushed along, and vehicles; but we use a similar technique of setting a bunch of global variables and then consolidating the check rules in such a way that any given rule (such as "the player cannot see through a closed door") is expressed in only one place.]

Viewed location is a room that varies. Occluding door is an object that varies. Direction faced is a direction that varies.

A door can be transparent.

[Now some routines to help us handle all this. ]

To decide what object is the door between (this place - a room) and (that place - a room):
	repeat with item running through doors enclosed by this place
	begin;
		if that place is the front side of the item or that place is the back side of the item, decide on the item;
	end repeat;
	decide on nothing.

Definition: a room (called the considered room) is proximate:
	repeat with item running through doors in the location:
		if the other side of the item is the considered room:
			yes;
	no.

[To handle LOOK THROUGH DOOR:]

Instead of searching a door (this is the player looking through doors rule):
	abide by the looking through doors rule.

Instead of someone trying searching a door (this is the other person looking through doors rule):
	abide by the looking through doors rule.

This is the looking through doors rule:
	now the direction faced is the direction of the noun from the location;
	if direction faced is not a direction
	begin;
		if the player is the person asked,
			say "[nothing-to-see-that-way][paragraph break]";
		stop the action;
	end if;
	now the viewed location is the other side of the noun;
	if the player is the person asked, try looking toward the viewed location;
	otherwise try the person asked trying looking toward the viewed location.

nothing-to-see-that-way is some text that varies. nothing-to-see-that-way is "Non puoi vedere nulla in quella direzione."


Understand "guarda [direction]" or "guarda a/verso [direction]" as facing.

Facing is an action applying to one visible thing.

Check someone trying facing (this is the setting someone's direction faced rule): abide by the setting direction faced rule.

Check facing (this is the setting your direction faced rule): abide by the setting direction faced rule.

This is the setting direction faced rule:
	now the direction faced is the noun.

Check facing (this is the redirect to looking toward rule):
	now the viewed location is the room noun from the location;
	if viewed location is a room, try looking toward the viewed location.

Check someone trying facing (this is the redirect someone to looking toward rule):
	now the viewed location is the room noun from the location;
	if viewed location is a room, try the person asked trying looking toward the viewed location.

Report facing (this is the standard report facing rule):
	if viewed location is not a room, say "[nothing-to-see-that-way][paragraph break]".

Report someone trying facing (this is the standard report someone facing rule):
	if viewed location is not a room, say "Non c[']衭olto da vedere per [the person asked] in quella direzione."

[Here is where we might also add special rules for "look up" or "look down" if so inclined: Instead of looking up: might be a good place to put in comments about a ceiling or sky object if there is one, for instance. The extension does not preprogram anything like this on the assumption that games will vary widely in their furnishings, but it would be easy to put in.]

Understand "guarda [any adjacent room]" or "guarda verso [any adjacent room]" as looking toward.
Understand "guarda il/lo/la/i/gli/le/l [any adjacent room]" or "guarda verso il/lo/la/i/gli/le/l [any adjacent room]" as looking toward.
[Understand "examine [any proximate room]" as looking toward.]

Looking toward is an action applying to one visible thing.

Check an actor looking toward a room (this is the can't see through closed door rule):
	now the occluding door is the door direction faced from the location;
	if the occluding door is a door and the occluding door is closed and the occluding door is not transparent
	begin;
		if the person asked is the player
		begin;
			if the sequential action option is active
			begin;
				try opening the occluding door;
			otherwise;
				say "(prima apri [the occluding door])[command clarification break]";
				silently try opening the occluding door;
			end if;
		otherwise;
			try the person asked trying opening the occluding door;
		end if;
		if the occluding door is closed
		begin;
			if the player is not the person asked, say "[The person asked] non  può vedere in quella direzione perché [the occluding door] [sei] [chiuso]." instead;
			stop the action;
		end if;
	end if.


Use sequential action translates as (- Constant SEQUENTIAL_ACTION; -).

Carry out looking toward (this is the describing a room from afar rule):
	carry out the distantly describing activity with the noun.

Report someone trying looking toward:
	let N be indexed text;
	now N is "[the noun]";
	say "[The person asked] guarda verso [N in lower case]."


Distantly describing something is an activity.

Rule for distantly describing a room (called target) (this is the default distant description rule):
	let N be indexed text;
	now N is "[the target]";
	say "In quella direzione vedi [N in lower case]."

Facing IT ends here.

---- DOCUMENTATION ----

Leggi la documentazione originale di
