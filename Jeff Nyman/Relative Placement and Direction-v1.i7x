Version 1.3 of Relative Placement and Direction by Jeff Nyman begins here.

"allowing relative directional movement as well as locationally relative descriptions."

"based (partly) on Directional Facing by Tim Pittman and someone who goes by 'Poster'."

Include Basic Screen Effects by Emily Short.
Include Unicode Character Names by Graham Nelson.

Part - Establish a Facing Relation

Facing relates various things to one direction.
The verb to be facing implies the facing relation.

Part - Provide Default Facing Kind

A room has a direction called default-facing.

Part - Relative Direction Commands

Understand "go left/right/forward/back/backward/backwards/l/r/f/b" as "[going-directional]".
Understand "left/right/forward/back/backward/backwards/l/r/f/b" as "[going-directional]".

After reading a command:
	if the player's command matches "[going-directional]":
		if the player's command includes "left", replace matched text with "l";
		if the player's command includes "right", replace matched text with "r";
		if the player's command includes "forward", replace matched text with "f";
		if the player's command includes "back", replace matched text with "b";
		if the player's command includes "backward", replace matched text with "b";
		if the player's command includes "backwards", replace matched text with "b";
		if the player is facing north:
			if the player's command includes "l", replace the matched text with "w";
			if the player's command includes "r", replace the matched text with "e";
			if the player's command includes "f", replace the matched text with "n";
			if the player's command includes "b", replace the matched text with "s";
		if the player is facing northwest:
			if the player's command includes "l", replace the matched text with "w";
			if the player's command includes "r", replace the matched text with "n";
			if the player's command includes "f", replace the matched text with "nw";
			if the player's command includes "b", replace the matched text with "se";
		if the player is facing northeast:
			if the player's command includes "l", replace the matched text with "n";
			if the player's command includes "r", replace the matched text with "e";
			if the player's command includes "f", replace the matched text with "ne";
			if the player's command includes "b", replace the matched text with "sw";
		if the player is facing south:
			if the player's command includes "l", replace matched text with "e";
			if the player's command includes "r", replace matched text with "w";
			if the player's command includes "f", replace matched text with "s";
			if the player's command includes "b", replace matched text with "n";
		if the player is facing southwest:
			if the player's command includes "l", replace matched text with "s";
			if the player's command includes "r", replace matched text with "w";
			if the player's command includes "f", replace matched text with "sw";
			if the player's command includes "b", replace matched text with "ne";
		if the player is facing southeast:
			if the player's command includes "l", replace matched text with "e";
			if the player's command includes "r", replace matched text with "s";
			if the player's command includes "f", replace matched text with "se";
			if the player's command includes "b", replace matched text with "nw";
		if the player is facing east:
			if the player's command includes "l", replace matched text with "n";
			if the player's command includes "r", replace matched text with "s";
			if the player's command includes "f", replace matched text with "e";
			if the player's command includes "b", replace matched text with "w";
		if the player is facing west:
			if the player's command includes "l", replace matched text with "s";
			if the player's command includes "r", replace matched text with "n";
			if the player's command includes "f", replace matched text with "w";
			if the player's command includes "b", replace matched text with "e";
	otherwise:
		let verb-direction be zero;
		if the player's command includes "exit", let verb-direction be one;
		if the player's command includes "leave", let verb-direction be one;
		if the player's command includes "out", let verb-direction be one;
		if the player's command includes "in", let verb-direction be two;
		if verb-direction is one:
			let current-room-facing be the default-facing of the location;
			if current-room-facing is not a direction:
				now the player is facing north;
			else:
				now the player is facing current-room-facing;
		if verb-direction is two:
			let current-room-facing be the default-facing of the location;
			if current-room-facing is not a direction:
				now the player is facing south;
			else:
				now the player is facing current-room-facing.

Part - Player Faces Direction of Movement

Before going somewhere:
	now the player is facing the noun.

Part - Player Orientation with Respect to Objects

Before examining something that is facing a direction (called the way):
	now the player is facing the opposite of the way.

Part - Descriptions Based on Relative Orientation

To say (way - a direction) facing:
	if the way is north:
		if player is facing north, say "in front of [us]";
		if player is facing south, say "behind [us]";
		if player is facing east, say "to [our] left";
		if player is facing west, say "to [our] right";
	if the way is south:
		if player is facing south, say "in front of [us]";
		if player is facing north, say "behind [us]";
		if player is facing east, say "to [our] right";
		if player is facing west, say "to [our] left";
	if the way is east:
		if player is facing east, say "in front of [us]";
		if player is facing west, say "behind [us]";
		if player is facing south, say "to [our] left";
		if player is facing north, say "to [our] right";
	if the way is west:
		if player is facing west, say "in front of [us]";
		if player is facing east, say "behind [us]";
		if player is facing north, say "to [our] left";
		if player is facing south, say "to [our] right".

Part - Turning Actions

Turning-left is an action applying to nothing.
Understand "turn left" as turning-left.

Turning-right is an action applying to nothing.
Understand "turn right" as turning-right.

Turning-around is an action applying to nothing.
Understand "turn around" as turning-around.

Carry out turning-left:
	if the player is facing south:
		now the player is facing east;
		rule succeeds;
	if the player is facing east:
		now the player is facing north;
		rule succeeds;
	if the player is facing north:
		now the player is facing west;
		rule succeeds;
	if the player is facing west:
		now the player is facing south;
		rule succeeds.

Carry out turning-right:
	if the player is facing south:
		now the player is facing west;
		rule succeeds;
	if the player is facing west:
		now the player is facing north;
		rule succeeds;
	if the player is facing north:
		now the player is facing east;
		rule succeeds;
	if the player is facing east:
		now the player is facing south;
		rule succeeds.

Carry out turning-around:
	if the player is facing south:
		now the player is facing north;
		rule succeeds;
	if the player is facing west:
		now the player is facing east;
		rule succeeds;
	if the player is facing east:
		now the player is facing west;
		rule succeeds;
	if the player is facing north:
		now the player is facing south;
		rule succeeds.

Report turning-left:
	say "[We] turn to [our] left.";

Report turning-right:
	say "[We] turn to [our] right.";

Report turning-around:
	say "[We] turn around and face the other way.";

Part - Status Line

Table of Various Directions
chosen path	abbrev	spacing
up	"U   "	"    "
northwest	"NW"	"  "
north	" N "	"   "
northeast	"NE"	"  "
east	" E"	" "
west	"W "	" "
southeast	"SE"	"  "
south	" S "	"   "
southwest	"SW"	"  "
down	"D   "	"    "

To say (path - a direction) abbreviation:
	choose row with a chosen path of path in the Table of Various Directions;
	say abbrev entry.

To say (path - a direction) spacing:
	choose row with a chosen path of path in the Table of Various Directions;
	say spacing entry.

To say rose (path - a direction):
	let place be the room path from the location;
	if the place is a room, say "[path abbreviation]";
	otherwise say "[path spacing]".

To say top rose:
	say "[rose up][rose northwest][rose north][rose northeast]".

To check-up-down:
	if player is facing up:
		say "[unicode black up-pointing triangle]   ";
	otherwise:
		if player is facing down:
			say "[unicode black down-pointing triangle]   ";
		else:
			say "    ".

To say middle rose:
	check-up-down;
	let place be the room west from the location;
	if place is a room, say "W "; otherwise say "  ";
	if player is facing north, say " [unicode black up-pointing triangle] ";
	if player is facing south, say " [unicode black down-pointing triangle] ";
	if player is facing east, say " [unicode black right-pointing pointer] ";
	if player is facing west, say " [unicode black left-pointing pointer] ";
	if player is facing northwest, say " [unicode bullet operator] ";
	if player is facing southwest, say " [unicode bullet operator] ";
	if player is facing northeast, say " [unicode bullet operator] ";
	if player is facing southeast, say " [unicode bullet operator] ";
	let place be the room east from the location;
	if place is a room, say " E"; otherwise say "  ";


To say bottom rose:
	say "[rose down][rose southwest][rose south][rose southeast]".

Relative Placement and Direction ends here.

---- DOCUMENTATION ----

You should create a "When play begins:" rule and make sure you have a phrase like this:

	The player is facing <direction>.

 Here <direction> is a cardinal compass direction.

This extension allows the player to make relative direction references for movement. For example, instead of saying a cardinal direction ("north", "east", etc), the player can say "go forward" or "go backward".

This will move the player in the direction that they are facing.

The player can also turn to face a relative direction by saying "turn left" or "turn right". It's also possible for the player to "turn around".

Directions allowed are "forward" or "f", "back" or "b", "left" or "l", and "right" or "r". There are some new verbs established that allow these relative directions to be used:

	"turn left"
	"turn right"
	"turn around"

When the player moves to a new room, he will face the way he is traveling. So if the player is facing north in a given room but goes east (or left) they will be facing to the left when they get to the new room.

This extension provides a relation about "facing." So something can be set up as "to be facing [a direction]". For example, you could have this:

	The statue is facing east.

Let's say this refers to a statue in a room where the player just entered it from the south and is facing north. If the player now examines that statue, the player will be facing west, as if they turned toward the statue to look at it. This is purely optional as no objects (or people) are required to have an orientation set in the story.

As part of the descriptions for objects or rooms, you can use a construct like this:

	"[north facing]"

Here "north" can be replaced by any cardinal compass direction. (Or, rather, any of the straight compass directions: north, south, east, west. Currently diagnoal directions do not really work for this.) What this substitution does is produce text that provides a relative direction, such as "to your left", "to your right", "in front of you", or "behind you" depending on the direction the player is facing when the description is produced.

One downside is that, currently, the diagonal directions (northwest, northeast, southwest, southesat) are not fully supported. The directional commands should work in those contexts but a visual facing indicator is not possible in the status line display, as its unclear what symbol to use. So if the player is facing a diagonal direction, the visual indicator will simply be a bullet/point display.

For any rooms that use in / out or enter / exit), this can get tricky but you can allow the player to face a particular way upon leaving or entering. The extension makes sure that each room has a default-facing property and this can be set as such:

	The default-facing of Long Water is east.

This will provide a default way for the player to be facing when one of the cardinal or relative directions is not used. If this value isn't specified, the default facing direction is north.

It's important to note that any of the directional information, movement, and orientation references are for the player character. There are no provisions to handle any of this for non-player characters.

Example: * A Relative Stroll Through a Park

	*: "A Relative Stroll Through a Park"

	Include Relative Placement and Direction by Jeff Nyman.

	Part - Locations

	Palace Gate is a room.
	Black Lion Gate is a room.
	Lancaster Gate is a room.

	Broad Walk is a room.
	Flower Walk is a room.
	Lancaster Walk is a room.

	Along Bayswater Road is a room.
	Round Pond is a room.
	Grassy Area is a room.

	Long Water is a room.
	Wading is a room.

	The default-facing of Wading is east.

	Part - Connections

	Broad Walk is north of Palace Gate.
	Flower Walk is east of Palace Gate.
	Lancaster Walk is north of Flower Walk.

	Black Lion Gate is north of Broad Walk.
	Lancaster Gate is north of Lancaster Walk.

	Along Bayswater Road is east of Black Lion Gate and west of Lancaster Gate.
	Along Bayswater Road is northeast of Broad Walk and northwest of Lancaster Walk.

	Round Pond is east of Broad Walk and west of Lancaster Walk.
	Round Pond is southeast of Black Lion Gate and southwest of Lancaster Gate.
	Round Pond is south of Along Bayswater Road.

	The Grassy Clearing is south of Round Pond, northeast of Palace Gate, and northwest of Flower Walk.
	The Grassy Clearing is southeast of Broad Walk and southwest of Lancaster Walk.

	Grassy Area is east of Lancaster Walk.
	Long Water is east of Grassy Area.

	A door called the tent door is down from Long Water and up from Sinkhole.
	The tent door is closed and openable.

	Wading is inside from Long Water.
	Wading is east of Long Water.

	Part - Setup of Status Line

	When play begins:
		now the player is facing north.

		Table of Fancy Status
		left			central	right
		""				""		"[top rose]"
		" [location]"	""		"[middle rose]"
		""				""		"[bottom rose]"

	Rule for constructing the status line:
		fill the status bar with the Table of Fancy Status;
		rule succeeds.
