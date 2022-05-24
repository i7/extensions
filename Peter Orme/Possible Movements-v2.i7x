Version 2.2 of Possible Movements by Peter Orme begins here.

section listing enterables

To say enterable list: 
	if an enterable container (called playerbox) encloses the player:
		say "You could try exiting from [the playerbox].";
	otherwise:
		let L be the list of enterable things in the location of the player;
		if L is not empty:
			say "You could try entering [L with definite articles]. ";
		[otherwise:
			say "There is nothing obvious you can enter. ";]
				
To say exit list: 
	say "Obvious exits from [the location]: [line break]";
	repeat with way running through directions: 
		let place be the room way from the location; 
		if place is a visited room:
			say "[way] to [the place][line break]";
		otherwise if place is a room:
			say "[way][line break]";

		
listing enterables is an action applying to nothing. 
Understand "enterables" as listing enterables.
carry out listing enterables: say enterable list.

listing exits is an action applying to nothing.
Understand "exits" as listing exits.
carry out listing exits: say "[exit list][enterable list]";

Possible Movements ends here.

---- DOCUMENTATION ----

This provides two commands available to the player: "exits" which lists all the obvious exits in the current location, and "enterables" which lists the enterable things. 