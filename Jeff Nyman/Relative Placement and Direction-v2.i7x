Version 2.0 of Relative Placement and Direction by Jeff Nyman begins here.

"Lets the player move and turn relative to the way they face (forward, back, left, right), describes things relative to that facing, and can show a compass rose in the status line."

"based (partly) on Directional Facing by Tim Pittman and someone who goes by 'Poster'."

Part - Facing

Section - The facing relation

Facing relates various things to one direction.
The verb to be facing implies the facing relation.

Section - The compass points

[The eight compass points in clockwise order. Every turn is arithmetic on the
bearing: a quarter turn is two steps, an about-face four. The arrow is the
status line symbol for facing that way, and the label marks an exit.
Inform 10.2: it knows Unicode character names, so the arrows can be written by
name: 8593 upwards arrow, 8599 north east arrow, 8594 rightwards arrow, 8600
south east arrow, 8595 downwards arrow, 8601 south west arrow, 8592 leftwards
arrow, 8598 north west arrow (as in "[unicode upwards arrow] "). On Inform 10.1
the names need the Unicode Character Names extension.]

Table of Compass Points
point	bearing	arrow	label
north	1	"[unicode 8593] "	"N "
northeast	2	"[unicode 8599] "	"NE"
east	3	"[unicode 8594] "	"E "
southeast	4	"[unicode 8600] "	"SE"
south	5	"[unicode 8595] "	"S "
southwest	6	"[unicode 8601] "	"SW"
west	7	"[unicode 8592] "	"W "
northwest	8	"[unicode 8598] "	"NW"

Definition: a direction is horizontal if it is a point listed in the Table of Compass Points.

To decide which number is the bearing of (way - a direction):
	if the way is a point listed in the Table of Compass Points, decide on the bearing entry;
	decide on 1.

[Steps are eighths of a turn: positive is clockwise, negative counterclockwise.]
To decide which direction is (steps - a number) eighths clockwise from (way - a direction):
	let N be the bearing of the way;
	let N be N + steps;
	let N be N + 15;
	let N be the remainder after dividing N by 8;
	let N be N + 1;
	choose row with a bearing of N in the Table of Compass Points;
	decide on the point entry.

Section - Which way something faces

[The player always faces one of the eight compass points: travel up, down, in
or out doesn't change it, and only a horizontal direction can be faced.]

To decide which direction is the facing direction of (T - a thing):
	if T is facing a direction (called the way) and the way is horizontal, decide on the way;
	decide on north.

A room has an object called the arrival facing. The arrival facing of a room is usually nothing.

When play begins (this is the initial facing rule):
	if the player is not facing a horizontal direction:
		let the way be the arrival facing of the location;
		if the way is a horizontal direction, now the player is facing the way;
		otherwise now the player is facing north.

Carry out going (this is the face the way of travel rule):
	if the noun is horizontal:
		now the player is facing the noun;
	otherwise:
		let the way be the arrival facing of the room gone to;
		if the way is a horizontal direction, now the player is facing the way.

Before examining something that is facing a horizontal direction (called the way) (this is the face what is examined rule):
	now the player is facing the opposite of the way.

Part - Relative Directions

A relative direction is a kind of value. The relative directions are forward, rightward, backward and leftward.

[L is not an abbreviation for left: it means LOOK.]
Understand "forward" or "forwards" or "ahead" or "f" as forward.
Understand "back" or "backward" or "backwards" or "around" or "b" as backward.
Understand "left" or "leftward" or "leftwards" as leftward.
Understand "right" or "rightward" or "rightwards" or "r" as rightward.

To decide which number is the eighths of (R - a relative direction):
	if R is:
		-- forward: decide on 0;
		-- rightward: decide on 2;
		-- backward: decide on 4;
		-- leftward: decide on -2.

To decide which direction is the direction (R - a relative direction) of (T - a thing):
	let the way be the facing direction of T;
	let N be the eighths of R;
	decide on N eighths clockwise from the way.

Section - Going relatively

Going relatively is an action applying to one relative direction.
Understand "go [relative direction]" or "walk [relative direction]" or "[relative direction]" as going relatively.

Carry out going relatively (this is the go the relative way rule):
	let the way be the direction the relative direction understood of the player;
	try going the way.

Section - Turning relatively

Turning relatively is an action applying to one relative direction.
Understand "turn [relative direction]" or "turn to the [relative direction]" or "face [relative direction]" as turning relatively.

Check turning relatively (this is the can't turn forward rule):
	if the relative direction understood is forward:
		say "[We] [are] already facing [facing direction of the player]." instead.

Carry out turning relatively (this is the turn the relative way rule):
	now the player is facing the direction the relative direction understood of the player.

Report turning relatively (this is the report turning relatively rule):
	if the relative direction understood is backward:
		say "[We] turn around, to face [facing direction of the player].";
	otherwise if the relative direction understood is leftward:
		say "[We] turn to [our] left, to face [facing direction of the player].";
	otherwise:
		say "[We] turn to [our] right, to face [facing direction of the player]."

Section - Facing a compass direction

Turning to face is an action applying to one visible thing.
Understand "face [direction]" or "turn [direction]" or "turn to [direction]" or "turn to face [direction]" as turning to face.

Check turning to face (this is the can't face a non-compass direction rule):
	if the noun is not a horizontal direction:
		say "[We] can only face one of the eight compass directions." instead.

Check turning to face (this is the can't face where already facing rule):
	if the player is facing the noun:
		say "[We] [are] already facing [noun]." instead.

Carry out turning to face (this is the face the compass direction rule):
	now the player is facing the noun.

Report turning to face (this is the report turning to face rule):
	say "[We] turn to face [noun]."

Part - Relative Descriptions

[Where a direction lies from the player's point of view.]

To say (way - a direction) facing:
	if the way is horizontal:
		let N be the bearing of the way;
		let N be N + 8;
		let N be N - the bearing of the facing direction of the player;
		let N be the remainder after dividing N by 8;
		if N is:
			-- 0: say "in front of [us]";
			-- 1: say "ahead of [us] and to [our] right";
			-- 2: say "to [our] right";
			-- 3: say "behind [us] and to [our] right";
			-- 4: say "behind [us]";
			-- 5: say "behind [us] and to [our] left";
			-- 6: say "to [our] left";
			-- 7: say "ahead of [us] and to [our] left";
	otherwise if the way is up:
		say "above [us]";
	otherwise if the way is down:
		say "below [us]";
	otherwise:
		say "[way]".

Part - Compass Rose

[Three lines, eleven characters wide: exits up and down on the left, the eight
compass exits around an arrow for the facing, and in/out on the middle row. In
darkness the exits are hidden but the arrow still shows.]

To decide whether there is an exit (way - a direction):
	if in darkness, decide no;
	if the room-or-door way from the location is nothing, decide no;
	decide yes.

To say rose (way - a direction):
	if there is an exit way:
		if the way is up:
			say "U ";
		otherwise if the way is down:
			say "D ";
		otherwise if the way is a point listed in the Table of Compass Points:
			say "[label entry]";
	otherwise:
		say "  ".

To say compass rose top:
	say "[rose up] [rose northwest] [rose north] [rose northeast]".

To say compass rose middle:
	if there is an exit inside and there is an exit outside:
		say "IO";
	otherwise if there is an exit inside:
		say "I ";
	otherwise if there is an exit outside:
		say "O ";
	otherwise:
		say "  ";
	choose row with a point of the facing direction of the player in the Table of Compass Points;
	say " [rose west] [arrow entry] [rose east]".

To say compass rose bottom:
	say "[rose down] [rose southwest] [rose south] [rose southeast]".

Use compass rose status line translates as (- Constant COMPASS_ROSE_STATUS_LINE; -).

[The status line: the room name on the left of the top row, and the rose on the
right of all three. Inform 10.1 and 10.2 have different routines for sizing the
status window and placing the cursor in it, so this talks to the virtual machine
directly (Glk on Glulx, the screen opcodes on the Z-machine), which both
versions allow. When this rule runs, both have already sent the output to the
status window.
Inform 10.2: Basic Inform can draw a status window from a table, so this rule,
the three phrases after it and the Inform 6 code can be replaced by
	Table of Compass Rose Status
	left	central	right
	" [location]"	""	"[compass rose top] "
	""	""	"[compass rose middle] "
	""	""	"[compass rose bottom] "
and a rule that says "draw the status window with the Table of Compass Rose
Status; rule succeeds." That places the room name one column further in.]

Rule for constructing the status line when the compass rose status line option is active (this is the compass rose status line rule):
	open the status window to 3 rows;
	let C be the status window width;
	decrease C by 12;
	move the status cursor to row 1 and column 1;
	say " [location]";
	move the status cursor to row 1 and column C;
	say "[compass rose top]";
	move the status cursor to row 2 and column C;
	say "[compass rose middle]";
	move the status cursor to row 3 and column C;
	say "[compass rose bottom]";
	rule succeeds.

To open the status window to (N - a number) rows: (- RP_StatusRows({N}); -).
To decide which number is the status window width: (- (RP_StatusWidth()) -).
To move the status cursor to row (R - a number) and column (C - a number): (- RP_StatusCursor({R}, {C}); -).

Include (-
#Ifdef TARGET_GLULX;
! The window whose stream output is going to: the status window, here.
[ RP_StatusWindow win str;
	str = glk_stream_get_current();
	win = glk_window_iterate(0, 0);
	while (win) {
		if (glk_window_get_stream(win) == str) return win;
		win = glk_window_iterate(win, 0);
	}
	return 0;
];
[ RP_StatusRows n win;
	win = RP_StatusWindow();
	if (win == 0) return;
	glk_window_set_arrangement(glk_window_get_parent(win), $12, n, 0);
	glk_window_clear(win);
];
[ RP_StatusWidth win;
	win = RP_StatusWindow();
	if (win == 0) return 80;
	glk_window_get_size(win, gg_arguments, 0);
	return gg_arguments-->0;
];
[ RP_StatusCursor r c win;
	win = RP_StatusWindow();
	if (win) glk_window_move_cursor(win, c - 1, r - 1);
];
#Ifnot;
[ RP_StatusRows n i w;
	@split_window n;
	w = RP_StatusWidth();
	for (i = 1 : i <= n : i++) { @set_cursor i 1; spaces w; }
];
[ RP_StatusWidth; return 0->33; ];
[ RP_StatusCursor r c; @set_cursor r c; ];
#Endif;
-).

Relative Placement and Direction ends here.

---- DOCUMENTATION ----

This extension gives the player character a facing: one of the eight compass directions. The player can then move and turn relative to it ("go forward", "turn left"), and descriptions can say where things are relative to it ("to your left", "behind you").

Section: Facing

The player always faces one of the eight compass points (north, northeast, east, and so on round to northwest). They face:

	at the start, the arrival facing of the starting room, or north if it has none;
	after walking in a compass direction, that direction;
	after going up, down, in or out, the arrival facing of the room they arrive in, if it has one; otherwise they keep facing the way they were;
	after examining something that faces a direction, that thing (see below).

A failed move doesn't change the facing. To start facing some other way, say so:

	The player is facing east.

Give a room an arrival facing for travel that has no compass direction of its own:

	The arrival facing of the Tent is east.

Section: Commands

	FORWARD, AHEAD or F; BACK, BACKWARD or B; LEFT; RIGHT or R: go that way relative to the facing. GO and WALK can come first ("go left").
	TURN LEFT, TURN RIGHT, TURN AROUND (or TURN BACK): turn by a quarter or half turn.
	FACE NORTH, TURN EAST, TURN TO FACE SOUTHWEST: face a compass direction.

Left and right are always a quarter turn, from any of the eight directions, so LEFT while facing northeast goes northwest. L is not an abbreviation for LEFT, because L means LOOK.

Section: Things that face a direction

Anything can face a direction, using the same relation:

	The statue is facing east.

When the player examines something that faces a direction, they turn to face it. If they examine a statue that faces east, they end up facing west, looking at its front. Nothing needs a facing: things without one are examined as usual.

All the movement and turning is for the player character. Other characters can be given a facing, but nothing moves or turns them.

Section: Relative descriptions

"[north facing]" says where north lies from the player's point of view, as one of eight phrases:

	in front of you; ahead of you and to your right; to your right; behind you and to your right; behind you; behind you and to your left; to your left; ahead of you and to your left.

Any direction can be used ("[southwest facing]"). "[up facing]" and "[down facing]" give "above you" and "below you".

For use in rules, "the facing direction of (a thing)" is the direction it faces (north for something that faces no compass direction), "the direction (a relative direction) of (a thing)" turns a relative direction into a compass one ("the direction leftward of the player"), and a direction is "horizontal" if it is one of the eight compass points.

Section: The compass rose

The extension can show a compass rose in the status line, with the room name on the left. Turn it on with:

	Use compass rose status line.

The rose shows the exits, with an arrow in the middle for the way the player faces:

	U  NW N  NE
	IO W  ↑  E
	D  SW S  SE

Exits up and down are on the left, and in and out on the middle row (I, O or IO). Exits through doors count, open or not. In darkness the exits are hidden and only the arrow shows.

For a status line of your own, the three rows are "[compass rose top]", "[compass rose middle]" and "[compass rose bottom]", each eleven characters wide.

This version works with Inform 10.1 as well as 10.2. Originally I used two things new in 10.2 (Unicode character names, and drawing the status window from a table); this extension now writes the arrows by number and draws the status window itself.

Section: Changes from version 1

(1) Relative directions are now real grammar rather than a rewrite of the typed command. In version 1, any command containing "in", "out", "exit" or "leave" changed the facing (PUT COIN IN BOX did), and L moved the player instead of meaning LOOK.

(2) Left and right are a quarter turn from every direction. In version 1 they were a quarter turn from north, south, east and west but an eighth from the diagonals, and wrong from southwest.

(3) The player always faces a compass direction. In version 1, going up, down, in or out made them face that way, after which turning did nothing and FORWARD, BACK and RIGHT weren't understood.

(4) Turning works from the diagonals; in version 1 it said it did but left the facing alone. TURN AROUND, TURN LEFT and TURN RIGHT now say which way the player ends up facing.

(5) "[(direction) facing]" works for all eight directions, plus up and down. In version 1 it printed nothing for a diagonal.

(6) default-facing is now the arrival facing, and it is optional: a room without one leaves the facing alone. No "When play begins" rule is needed to set the starting facing.

(7) New: FACE (direction), TURN (direction).

(8) The compass rose is part of the extension, behind a use option, and shows doors, in, out and all eight facings. It needs no other extensions.

Example: * A Relative Stroll Through a Park - Walking and turning relative to the way you face.

	*: "A Relative Stroll Through a Park"

	Include Relative Placement and Direction by Jeff Nyman.

	Use compass rose status line.

	Part - Locations

	Palace Gate is a room. "The gates of Kensington Gardens. The Broad Walk is [north facing] and the Flower Walk [east facing]; a grassy clearing lies [northeast facing]."

	Black Lion Gate is a room.
	Lancaster Gate is a room.

	Broad Walk is a room. "A brooding statue of Queen Victoria stands here. The Round Pond is [east facing], and the gate [south facing]."

	The statue of Queen Victoria is scenery in Broad Walk. The statue is facing east. The description of the statue is "The Queen gazes out over the Round Pond, which lies [east facing]."

	Flower Walk is a room.
	Lancaster Walk is a room.

	Along Bayswater Road is a room.
	Round Pond is a room.
	The Grassy Clearing is a room.
	Grassy Area is a room.

	Long Water is a room. "The Long Water glitters [east facing]. A tent stands at the water's edge, with a trapdoor in the ground beside it."
	The Tent is a room. "Canvas all around. The way out is [west facing]."
	Sinkhole is a room.

	The arrival facing of the Tent is east.
	The arrival facing of Sinkhole is north.

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

	The Tent is inside from Long Water.
	A trapdoor is down from Long Water and up from Sinkhole. The trapdoor is a closed openable scenery door.

	Test me with "right / turn left / forward / left / f / look / turn around / look / x statue / look / go back / f / walk forward / f / in / out / look / face up / turn forward / open trapdoor / down / up / look / l".

The walk begins at Palace Gate facing north. RIGHT goes east to the Flower Walk; TURN LEFT and FORWARD reach the Lancaster Walk facing north, and LEFT, then F, lead west past the Round Pond to the Broad Walk. There the pond is behind you until you turn around. Examining the statue, which faces east, turns you to face west, so the pond is behind you again. Going back east and on to the Long Water, the tent's arrival facing turns you east as you go in, so its way out is behind you; coming out leaves you facing east. The trapdoor leads down to the Sinkhole, which turns you north, and going back up keeps that facing, so the water is now to your right. FACE UP and TURN FORWARD are refused, and L is LOOK throughout.
