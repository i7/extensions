Version 1 of Helpful Functions by Daniel Stelzer begins here.

"A set of functions I have often found useful, with checks to prevent conflicts with extensions."

"including code by Ron Newcomb, Jesse McGrew, and Emily Short"

Section - Truth States

[Thanks Ron Newcomb!]
To decide whether we/there is/are/should/need a/an/the/-- (X - a truth state):
	decide on whether or not X is true.
To decide whether we/there don't/isn't/aren't/shouldn't need/have/-- a/an/the/-- (X - a truth state):
	decide on whether or not X is false.

Section - Doors (for use without Facing by Emily Short)

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

Section - Light

Definition: a room is light-filled rather than darkness-filled if I6 routine "OffersLight" says so (it contains a light source).
Definition: a thing is light-filled rather than darkness-filled if I6 routine "OffersLight" says so (it contains a light source).

Section - Beta Comments

After reading a command (this is the ignore beta-comments rule):
	if the player's command matches the regular expression "^\p":
		say "(Noted.)";
		reject the player's command.

Section - Understanding

Understand "your" or "yours" as a thing when the item described is enclosed by the person asked.
Understand "my" or "mine" as a thing when the item described is enclosed by the player.
Understand "here" as a room when the item described is the location.

Section - Touching

To decide whether (item - a thing) must be touched:
	if the item is the noun and the action requires a touchable noun, yes;
	if the item is the second noun and the action requires a touchable second noun, yes;
	no.

To decide whether (table - a supporter) must be touched indirectly:
	repeat with the item running through things on the table:
		if the item must be touched, yes;
	if the table must be touched, yes;
	no.

To decide whether (box - a container) must be touched indirectly:
	repeat with the item running through things in the box:
		if the item must be touched, yes;
	if the box must be touched, yes;
	no.

Section - Matching

To decide whether (txt - indexed text) matches (top - topic): [This is a horrible, horrible hack by Vaporware. You can only compare topics to snippets, so this snippetifies indexed text to make a comparison.]
	let tmp be indexed text;
	let tmp be the player's command;
	change the text of the player's command to txt;
	let result be whether or not the player's command matches top;
	change the text of the player's command to tmp;
	decide on result.

Section - Style Fixing (for use without Glulx Text Styles by Daniel Stelzer)

To say using input style: do nothing. [Hack!]

Section - Forcing Commands

Include Basic Screen Effects by Emily Short.

To force the command (typed command - indexed text):
	say "[command prompt][using input style][run paragraph on]";
	let the index be 1;
	while the index is less than the number of characters in the typed command:
		wait for any key; [Get a keypress.]
		let X be the chosen letter;
		if X is zero or X is -6 or X is -7, next; [Ignore nothing at all, DELETE, and ENTER.]
		say character number index in the typed command;
		increment the index;
[	if the chosen letter is -6, wait for any key; [This prevents a command from being shown too quickly when ENTER is pressed.]	]
	while the chosen letter is not -6: [Wait for ENTER to execute the command]
		wait for any key;
	say "[roman type][line break]".

To force (idea - a stored action) with command (typed command - indexed text):
	force the command typed command;
	try the idea.

Section - Player Checking

The global actor is a person that varies.

Before an actor doing something (this is the set global actor rule): now the global actor is the actor.

To to the player say (T - indexed text):
	if the global actor is the player, say T.

To show the/-- player/-- (T - indexed text) at (item - an object):
	if the player can see the item, say T.

Helpful Functions ends here.
