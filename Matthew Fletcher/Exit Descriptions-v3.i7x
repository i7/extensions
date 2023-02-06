Version 3 of Exit Descriptions by Matthew Fletcher begins here.

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
