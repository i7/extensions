Version 3.0.0 of Exit Descriptions by Matthew Fletcher begins here.

"Appends a list of exit directions and names any previously visited rooms at the end of a room description."

The amount is a number variable.
The amount is 0.

The num is a number variable.
The num is 0.

The ExitsMessage is some text that varies.
The ExitsMessage is "Exits:".

The ExitsAndText is some text that varies.
The ExitsAndText is " and".

The ExitsToText is some text that varies.
The ExitsToText is " to".

After looking (this is the exit descriptions rule):
	Now the amount is the number of adjacent rooms;
	repeat with destination running through adjacent rooms begin; 
		if the num is 0, say "[ExitsMessage]";
		let the way be the best route from the location to the destination, using even locked doors;
		if the way is a direction, say " [way]";
		if the destination is visited, say "[ExitsToText] [the destination]";
		Decrease the amount by 1;
		Increase the num by 1;
		if the amount is 0, say ".";
		if the amount is 1, say "[ExitsAndText]";
		if the amount is greater than 1, say ",";
	end repeat;
	Now the amount is 0;
	Now the num is 0.

Exit Descriptions ends here.

---- DOCUMENTATION ----

During gameplay, Exit Descriptions lists the directions of the exits available to the player from their current location after every turn. The name of the location is included in the listing when it was previosly visited by the player.

Example: * Touring the First Floor - Create a map of the main rooms on the first floor of a house with a test script that navigates through all of the rooms. Notice how Exit Descriptions displays the exits depending on whether adjoining rooms were visited or not.

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

	Test me with "in / south / north / north / east / south / south / west / north / out"