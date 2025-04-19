Version 5.0.0 of Exit Descriptions by Matthew Fletcher begins here.

"Appends a list of exit directions and names any previously visited rooms at the end of a room description."

[Added an update in v4.1.0 so that in dark rooms (that aren't lighted) will only show the exits if the destination has been visited so that the player can backtrack out of a dark room. removed/commented out the part with dark/light rooms are ignored]


An easydoor has a direction called the door_direction.
An easydoor has a text called the easydoor_exit_name.

A door has a text called the door_exit_name.

The amount is a number variable.
The amount is 0.

The num is a number variable.
The num is 0.

[The ExitListType is a number variable.
The ExitListType is usually 0.]

The ExitListTypeFlag is a truth state that varies. The ExitListTypeFlag is false.

The ShowUnvistedRoomNamesFlag is a truth state that varies. The ShowUnvistedRoomNamesFlag is false.

[The ShowUnvistedRoomNames is a number variable.
The ShowUnvistedRoomNames is usually 0.]

The ExitsMessage is some text that varies.
The ExitsMessage is "Exits:".

The ExitsAndText is some text that varies.
The ExitsAndText is " and".

The ExitsToText is some text that varies.
The ExitsToText is " to".

[An easydoor has a direction called the door_direction.
The door_direction of the manor door is west.]

After looking (this is the exit descriptions rule):
	[let thisdoordirection be "";]
	Now the amount is the number of adjacent rooms plus the number of easydoors in the location plus the number of doors in the location;
	repeat with destination running through adjacent rooms begin;
		if the num is 0, say "[ExitsMessage]";
		if the ExitListTypeFlag is true, say "[line break]";
		let the way be the best route from the location to the destination, using even locked doors;
		if the way is a direction and the ExitListTypeFlag is false, say " ";
		if the way is a direction, say "[way]";
		repeat with thiseasydoor running through easydoors in the location begin;
			if the door_direction of thiseasydoor is the way, say " through [door_exit_name of thiseasydoor]";
		end repeat;
		[if the location is lighted begin:]
		[	if the way is a direction and the ExitListTypeFlag is false, say " ";]
		[	if the way is a direction, say "[way]";]
		if the destination is visited or ShowUnvistedRoomNamesFlag is true, say "[ExitsToText] [the destination]";
		Decrease the amount by 1;
		Increase the num by 1;
			[end if;]
		[end if;]
		[if the location is dark begin and the destination is visited begin;]
		[		if the way is a direction and the ExitListTypeFlag is false, say " ";]
		[		if the way is a direction, say "[way]";]
		[		say "[ExitsToText] [the destination]";]
		[		Decrease the amount by 1;]
		[		Increase the num by 1;]
		[end if;]
		if the amount is 0 and the ExitListTypeFlag is false, say ".";
		if the amount is 0 and the ExitListTypeFlag is true, say "[line break]";
		if the amount is 1 and the ExitListTypeFlag is false, say "[ExitsAndText]";
		if the amount is greater than 1 and the ExitListTypeFlag is false, say ",";
	end repeat;
	repeat with thisdoor running through doors in the location begin;
		let the destdir be the direction of thisdoor from the location;
		let the destroom be the room destdir from the location;
		if the ExitListTypeFlag is false, say " ";
		if the ExitListTypeFlag is true, say "[line break]";
		say "[direction of thisdoor from the location] through [door_exit_name of thisdoor][if destroom is visited or ShowUnvistedRoomNamesFlag is true] to [destroom][end if]";
		Decrease the amount by 1;
		Increase the num by 1;
		if the amount is 0 and the ExitListTypeFlag is false, say ".";
		if the amount is 0 and the ExitListTypeFlag is true, say "[line break]";
		if the amount is 1 and the ExitListTypeFlag is false, say "[ExitsAndText]";
		if the amount is greater than 1 and the ExitListTypeFlag is false, say ",";
	end repeat;
	Now the amount is 0;
	Now the num is 0.


Exit Descriptions ends here.

---- DOCUMENTATION ----

During gameplay, Exit Descriptions lists the directions of the exits available to the player from their current location after every turn. The name of the location is included in the listing when it was previously visited by the player.

You can set the value ExitListTypeFlag to true (it defaults to false) to change the format of the Exits from the default of a comma separated sentence to a list. e.g. When play begins: now the ExitListType is 1.

You can set the value ShowUnvistedRoomNamesFlag to true (it defaults to false) to also show the names of unvisited rooms in the exits list.

Added an update in v5.0.0 so that the name of easydoors or doors and the rooms that they lead to are included in the exit lists.

An easydoor has a direction called the door_direction. Give both sides of the easydoor the direction value that it should show as in the exit list.
An easydoor has a text called the easydoor_exit_name. Give both sides of the easydoor a text value of what you want it to show as in the exit list.
A door has a text called the door_exit_name. Give that a text value of what you want it to show as in the exist list.


Example: * Touring the First Floor - Create a map of the main rooms on the first floor of a house with a test script that navigates through all of the rooms. Notice how Exit Descriptions displays the exit directions and only includes the name of the adjoining rooms that have been visited.

	*: "Touring the First Floor"

	Include Exit Descriptions by Matthew Fletcher.

	First Floor is a region.
	Outdoors is a region.

	Front Walkway is a room.
	Foyer is a room inside from Front Walkway. 
	West Family Room is a room.
	East Family Room is a room.
	Living Room is a room.
	Dining Room is a room.
	Kitchen is a room.

	Foyer is inside from Front Walkway.
	Foyer is north of West Family Room and south of Living Room.
	Kitchen is south of Dining Room and north of East Family Room.
	West Family Room is west of East Family Room.
	Dining Room is east of Living Room.

	Foyer, West Family Room, East Family Room, Living Room, Dining Room, and Kitchen are regionally in First Floor.

	Front Walkway is regionally in Outdoors.

	The player is in Front Walkway.

	When play begins:
		now the ExitListTypeFlag is true;
		now the ShowUnvistedRoomNamesFlag is true.

	Test me with "in / south / north / north / east / south / south / west / north / out"

