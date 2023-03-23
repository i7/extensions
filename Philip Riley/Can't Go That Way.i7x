Version 1/230318 of Can't Go That Way by Philip Riley begins here.

Table of Excuses
source room (a room)	dirs (a list of directions)	excuse (a text)
with 1 blank row.

The room you tried to leave is a room that varies.

The excuse text rules is a direction based rulebook producing texts.

excuse text for a direction (called dir) (this is the standard excuse text rule):
	let source be the room you tried to leave;
	repeat through the Table of Excuses:
		if there is a dirs entry:
			if (source room entry is source) and (dir is listed in dirs entry):
				rule succeeds with result excuse entry;
	if dir is up:
		rule succeeds with result "[We] [can] neither climb walls nor fly." (A);
	if dir is down:
		if source is floored:			
			rule succeeds with result "[regarding the player][Are] [we] going to burrow downward?" (B) in sentence case;
		otherwise:
			rule succeeds with result "[We] [can't] go that way." (C);
	if dir is inside:
		rule succeeds with result "What [regarding the player][do] [we] want to enter?" (D);
	if dir is outside:
		rule succeeds with result "[text of the can't exit when not inside anything rule response (A)]";
	repeat through the Table of Excuses:		
		if there is no dirs entry:
			if source room entry is source:
				rule succeeds with result excuse entry;
	rule succeeds with result "[We] [can't] go that way." (E);

To decide which text is the excuse for (source - a room) to (dir - a direction):
	now the room you tried to leave is source;
	decide on the text produced by the excuse text rules for dir;

Instead of going nowhere:
	let ex be the excuse for location to the noun;
	say "[ex][paragraph break]";

The can't exit when not inside anything rule does nothing.

Check an actor exiting (this is the new can't exit when not inside anything rule):
	let the local room be the location of the actor;
	if the container exited from is the local room:
		if the player is the actor:
			say "[excuse for local room to outside][line break]" (A);
		stop the action.

Section 1 - floored (for use without Floors by Philip Riley)

A room can be floored.
A room is usually floored.

Can't Go That Way ends here.


---- DOCUMENTATION ----

This extension allows for custom "can't go that way" messages depending on location and direction.

Volume 1 - Rules

Specify "can't go that way" messages in the Table of Excuses (continued):
	
	Table of Excuses (continued)
	source room (a room)	dirs (a list of directions)	excuse (a text)
	Quiet Glade	--	"That way is blocked by impenetrable forest."
	Quiet Glade	{ north, northwest }	"[We] would have to climb a sheer cliff face to go that way."
	Quiet Glade { east }	"A deep pond blocks your progress in that direction."
	
Can't Go That Way chooses messages based on the following rules:

1. Choose a message with the current location, and with the direction in question contained in the dirs list. 

2. Choose a message with the current location, and empty dirs entry.

3. Fall back to the default message (text of the standard excuse text rule (E)) for everything but directions up, down, inside, and outside. By default "[We] [can't] go that way."

4. For up, when no custom message exists, it uses the default text "text of the standard excuse text rule (A)". By default "[We] [can] neither climb walls nor fly."

5. For down, when no custom message exists, there are two cases: if using the extension "Floors by Philip Riley" and the current location has a floor, it uses "text of the standard excuse text rule (B)" (by default) "[regarding the player][Are] [we] going to burrow butownward?"; otherwise use the default text "text of the standard excuse text rule (C)". By default "[We] [can't] go that way".

6. For inside, when no custom message exists, it uses the default text "text of the standard excuse text rule (D)", by default "What [regarding the player][do] [we] want to enter?".

7. For outside, when no custom message exists, it uses the default text "text of the can't exit when not inside anything rule response (A)" from the Standard Rules, by default "But [we] [aren't] in anything at the [if story tense is present tense]moment[otherwise]time[end if]."

The can't exit when not inside anything rule is replaced so that it uses custom text when it exists.

Example: Prison Cell

	*: "Prison Cell"

	Include Can't Go That Way by Philip Riley.
	
	The prison cell is a room. "You are in prison. The barred cell door is to the south."
	
	Table of Excuses (continued)
	source room (a room)	dirs (a list of directions)	excuse (a text)
	prison cell	--	"Nothing that way but cold cinderblock walls."
	prison cell	{ south }	"You can't squeeze through the bars!"
	prison cell	{outside}	"Escaping isn't that easy."
	
	test me with "n/e/s/d/u/out/in";
	



