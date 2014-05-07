Version 2 of Regional Travel by Juhana Leinonen begins here.

"Allows the player to travel between regions. Useful for example when the player travels between large regions far apart from each other (e.g. cities), or for traveling in vehicles and public transportation."


Chapter 1

A region has a room called travel entry point.

Traveling regionally to is an action applying to one visible thing.

Understand "travel to [any room]" as traveling regionally to.
Understand "travel to [text]" as a mistake ("That's not a place where [we] [can] travel to.").

Does the player mean traveling regionally to an unvisited room: it is unlikely.


Chapter 2a (for use without Epistemology by Eric Eve)

Check traveling regionally to an unvisited room (this is the can only travel to visited rooms rule):
	say "That's not a place where [we] [can] travel to." (A) instead.


Chapter 2b (for use with Epistemology by Eric Eve)

[We have to extend Epistemology's definitions to cover rooms as well.]
A room can be familiar or unfamiliar. A room is usually unfamiliar.

Definition: a room is seen if it is visited.
Definition: a room is unseen if it is not seen.

Definition: a room is known if it is familiar or it is seen.
Definition: a room is unknown if it is not known.

Check traveling regionally to an unknown room (this is the can only travel to visited rooms rule):
	say "That's not a place where [we] [can] travel to." (A) instead.

Does the player mean traveling regionally to a known room: it is very likely.


Chapter 3

Check traveling regionally to (this is the can only travel to room in a region rule):
	if the noun is not in a region, say "[We] [can't] travel there." (A) instead.

Check traveling regionally to (this is the can't travel where you already are rule):
	if the noun is in a region (called the target region):
		if the location of the player is the travel entry point of the target region:
			say "[We] [are] already there." (A) instead;
		otherwise if the location of the player is in the target region:
			say "[We] [are] already near [the noun]." (B) instead.

Carry out traveling regionally to (this is the clarify the region we're traveling to rule):
	[this can't be a report rule because it has to print before we move the player and show the new room description]
	if the noun is in a region (called the target region):
		say "(travel[if the American dialect option is not active]l[end if]ing to [the target region])[command clarification break]" (A).

After traveling regionally to (this is the move player to the new region rule):
	if the noun is in a region (called the target region):
		now the player is in the travel entry point of the target region;
	continue the action.


Regional Travel ends here.


---- DOCUMENTATION ----

Chapter: Usage

The Regional Travel extension adds a new action, traveling regionally to, that allows the player to travel between different regions with the command TRAVEL TO. This kind of technique is sometimes used in games where the player can travel between distant locations, for example between cities or between separate locations inside a city. The extension can also be used when the player needs a vehicle for traveling to certain areas (see example B for a demonstration).

The minimal setup is to group rooms into regions (see chapter 3.4 in Inform 7 (5Z71) documentation) and define what is the "travel entry point" of each region. The travel entry point is the room where the player will end up when traveling to that region. Note that the travel entry point doesn't actually have to be inside the region. Example A demonstrates a basic setup.

By default the player can't travel to any region that is unvisited. If we want the player to be able at any point of the game to travel somewhere they haven't visited yet it's recommended to include another extension, Epistemology by Eric Eve. When we're using Epistemology we can make a room 'familiar' which allows traveling there. See Epistemology's documentation for more information or example B for another method for granting travel access to an unvisited location.


Chapter: Version history

Version 2 (April 2014): Modified the extension for compatibility with the new release of Inform. Message variables are now removed and changing messages is handled through means provided by Inform itself. The travel destination announcements option is removed and removing the announcement is done by removing the rule that prints it.


Example: * East Side West Side - A bare minimum example of setting up Regional Travel

In this example we set up the rooms in chapter 1 as we normally would and divide them into two regions. In chapter 2 we add travel entry points to both regions and allow traveling to "west bank" and "east bank" by making "bank" a synonym for the entry points.

	* : Include Regional Travel by Juhana Leinonen.

	Use travel destination announcements.

	Chapter 1 - Setting up the world

	The West Bank is a region. The East Bank is a region.

	West end of the bridge is a room. Western Main Road is west of the West end of the bridge. Market Square is north of the Western Main Road. The Church is south of the Western Main Road.

	East end of the bridge is east of West end of the bridge. Eastern Main Road is east of the East end of the bridge. The Inn is southeast of the Eastern Main Road. The Blacksmith is south of the Eastern Main Road.

	West end of the bridge, Western Main Road, Market Square, and the Church are in the West Bank.
	East end of the bridge, Eastern Main Road, the Inn and the Blacksmith are in the East Bank.


	Chapter 2 - Travel entry points

	The travel entry point of the West Bank is the West end of the bridge. 
	The travel entry point of the East Bank is the East end of the bridge.     
	Understand "bank" as the West end of the bridge. Understand "bank" as the East end of the bridge.

	Test me with "e/e/s/travel to church/travel to foobar/travel to eastern main road/travel to blacksmith/travel to west bank/w/s/travel to blacksmith/e/travel to church/travel to east bank".


Example: ** The Detective - Driving around the city in a car

	* : Include Regional Travel by Juhana Leinonen.
	
	Chapter Setup
	
	Understand "drive to [any room]" as traveling regionally to.
	Understand "drive to [text]" as a mistake ("That's not a place you could drive to.").
	
	The can only travel to visited rooms rule response (A) is "That's not a place you could drive to."
	
	A room can be known or unknown. A room is usually unknown.
	
	The can only travel to visited rooms rule is not listed in any rulebook.
	
	Check traveling regionally to an unknown room (this is the can travel to unvisited but known rooms rule):
		say "That's not a place you can drive to."
	
	Check traveling regionally to when the player is not in a vehicle (this is the can only travel in a vehicle rule):
		say "You need to be in a car before you can drive anywhere." instead.
	
	Before traveling regionally to when the player is not in a vehicle and the player can see a vehicle (called the transportation method):
		say "(first entering [the transportation method])[command clarification break]";
		silently try entering the transportation method.
	
	Does the player mean traveling regionally to a known room: it is very likely.
	
	The car is a vehicle.
	
	A road is a kind of room.
	
	Check going when the player is in a vehicle:
		if the room noun of the location is a room and the room noun of the location is not a road:
			say "You can't drive there!" instead.
	
	Chapter Setting
	
	The Mansion is a room. Rule for printing the name of the mansion while asking which do you mean: say "inside the mansion". Understand "inside" as the mansion.
	
	A body is in the mansion. The description is "The corpse is clutching something in its hand."
	
	The hand is a part of the body. The description is "[if the business card is in the hand]There's a business card in the victim's hand.[otherwise]There's nothing there anymore.[end if]"
	
	The business card is in the hand. The description is "'Bob's Auto Repairs and Garage.'"
	
	After examining the business card:
		now Bob's Garage is known.
	
	The Mansion driveway is a road. It is outside of the mansion.
	
	The car is a vehicle in the mansion driveway.
	
	The murder scene is a region. The mansion and mansion driveway is in the murder scene.
	The travel entry point of the murder scene is the mansion driveway.
	
	Bob's Garage is a room. Understand "bob" and "auto" and "repairs" and "and" as Bob's Garage.
	
	Entrance to Garage is a road. It is outside of Bob's Garage.
	
	Maple Street is a road. "Bob's Auto Repairs and Garage is to the south."
	Maple Street is north of Bob's Garage.
	
	The garage area is a region. Bob's Garage, Maple Street, and Entrance to Garage are in the garage area.
	The travel entry point of the garage area is the Maple Street.
	
	Test me with "x body/x hand/read card/drive to bob's garage/out/drive to bob's garage/s/out/in".
	


