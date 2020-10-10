Version 3 of Dynamic Rooms by Aaron Reed begins here.

"Lets new rooms be created on the fly."

[History:
 -- Version 3: Added positioned rooms which keep track of their coordinates in 3D space.
 -- Version 2: Updated to use no deprecated features.
]


Chapter - Adding/Removing Rooms

Section - Initialization

A dynamic room is a kind of room.

The unformed room list is a list of objects that varies.

First when play begins (this is the Dynamic Rooms initialization rule):
	now the unformed room list is the list of dynamic rooms.

Section - Utility

To decide what number is available dynamic rooms:
	decide on the number of entries in the unformed room list.

To decide what number is used dynamic rooms: decide on the number of dynamic rooms - the number of entries in the unformed room list.

To decide whether out of dynamic rooms:
	if available dynamic rooms is 0, decide yes;
	decide no.


Section - Creating a room

To decide which object is a newly created room with name (new name - some text):
	if out of dynamic rooms, decide on location;
	let selected be entry 1 in the unformed room list;
	now the printed name of selected is new name;
	remove selected from unformed room list;
	decide on selected.

To decide which object is a newly created room (dir - a direction) of/from (place - a room) with name (new name - some text):
	let excavation be a newly created room with name new name;
	change dir exit of place to excavation;
	change ( opposite of dir ) exit of excavation to place;
	decide on excavation.


Section - Deleting a room

To dissolve (rm - a room):
	now printed name of rm is "room";
	now description of rm is "";
	repeat with dir running through directions:
		if the room dir from rm is a room:
			change ( opposite of dir ) exit of ( the room dir from rm ) to nothing;
			change dir exit of rm to nothing;
	add rm to the unformed room list, if absent.
	
Chapter - Tracking Room Locations

Section - Coordinates

A room is either present in the coordinate system or absent from the coordinate system. A room is usually absent from the coordinate system.

Every room has a number called the x-coordinate. The x-coordinate of a room is usually 0.
Every room has a number called the y-coordinate. The y-coordinate of a room is usually 0.
Every room has a number called the z-coordinate. The z-coordinate of a room is usually 0.

The maximum-map-x is a number that varies. The maximum-map-x is usually 10000.
The maximum-map-y is a number that varies. The maximum-map-y is usually 10000.
The maximum-map-z is a number that varies. The maximum-map-z is usually 10000.
The minimum-map-x is a number that varies. The minimum-map-x is usually -10000.
The minimum-map-y is a number that varies. The minimum-map-y is usually -10000.
The minimum-map-z is a number that varies. The minimum-map-z is usually -10000.

Section - Mapping Directions to Coordinates

Table of Direction Map Positioning
basedir	map-x	map-y	map-z
north	0	1	0
northeast	1	1	0
east	1	0	0
southeast	1	-1	0
south	0	-1	0
southwest	-1	-1	0
west	-1	0	0
northwest	-1	1	0
up	0	0	1
down	0	0	-1

Definition: a direction is coordinate compatible if it is north or it is northeast or it is east or it is southeast or it is south or it is southwest or it is west or it is northwest or it is up or it is down.	

Section - Utility Functions

To locate (place - a room) at xyz (xyz - a list of numbers):
	now x-coordinate of place is entry 1 of xyz;
	now y-coordinate of place is entry 2 of xyz;
	now z-coordinate of place is entry 3 of xyz;
	now place is present in the coordinate system.
	
To assign xyz coordinates based on (place - a room):
	repeat with dir running through coordinate compatible directions:
		let next room be the room dir of place;
		if next room is a room and next room is absent from the coordinate system:
			let next coordinates be the coordinate set dir of place;
			locate next room at xyz next coordinates;
			assign xyz coordinates based on next room.

To decide what list of numbers is the coordinate set (dir - a direction) of (place - a room):
	let x-target be x-coordinate of place;
	let y-target be y-coordinate of place;
	let z-target be z-coordinate of place;
	if there is a basedir of dir in Table of Direction Map Positioning:
		choose row with a basedir of dir in Table of Direction Map Positioning;
		increase x-target by map-x entry;
		increase y-target by map-y entry;
		increase z-target by map-z entry;
	let target be a list of numbers;
	add x-target to target;
	add y-target to target;
	add z-target to target;
	decide on target.	

To decide which room is the room positioned at coordinates (xyz - a list of numbers):
	repeat with candidate running through rooms which are present in the coordinate system:
		if x-coordinate of candidate is entry 1 of xyz and y-coordinate of candidate is entry 2 of xyz and z-coordinate of candidate is entry 3 of xyz:
			decide on candidate;
	decide on map vector origin.

Section - The Validating a map connection rulebook

Validating a map connection is a rulebook producing a room. 
The map vector origin is a room that varies. The map vector direction is a direction that varies.
Destination coordinates is a list of numbers that varies. The destination coordinates is {0, 0, 0}.
To decide what number is x of destination coordinates: decide on entry 1 of destination coordinates.
To decide what number is y of destination coordinates: decide on entry 2 of destination coordinates.
To decide what number is z of destination coordinates: decide on entry 3 of destination coordinates.

Section - Built-in validating a map connection rules

First validating a map connection rule (this is the set destination coordinates rule):
	if map vector origin is absent from the coordinate system, rule fails;
	now destination coordinates is the coordinate set map vector direction of map vector origin.

A validating a map connection rule (this is the check for an existing room at those coordinates rule):
	let candidate be the room positioned at coordinates destination coordinates;
	if candidate is not map vector origin, rule succeeds with result candidate.
	
A validating a map connection rule (this is the check for sufficient dynamic rooms rule):
	if out of dynamic rooms, rule fails.

A validating a map connection rule (this is the check coordinate bounds rule):
	if x of destination coordinates > maximum-map-x or x of destination coordinates < minimum-map-x or
	y of destination coordinates > maximum-map-y or y of destination coordinates < minimum-map-y or
	z of destination coordinates > maximum-map-z or z of destination coordinates < minimum-map-z,
		rule fails.

Last validating a map connection rule (this is the create a new dynamic room rule):
	let excavation be entry 1 in the unformed room list;
	remove excavation from unformed room list;
	locate excavation at xyz destination coordinates;
	rule succeeds with result excavation.

Section - Creating a new positioned room

To decide which object is a newly created positioned room (dir - a direction) of/from (place - a room) with name (new name - some text):
	now the map vector origin is place;
	now the map vector direction is dir;
	let room counter be available dynamic rooms;
	let excavation be the room produced by the validating a map connection rules;
	if excavation is not nothing:
		if available dynamic rooms < room counter:
			now the printed name of excavation is new name;
		change map vector direction exit of map vector origin to excavation;
		change ( opposite of map vector direction ) exit of excavation to map vector origin;	
		decide on excavation;
	decide on place.

Section - Testing

Coordinate testing is an action applying to nothing. Understand "coord" as coordinate testing.

coord-test-on is a truth state variable.
Carry out coordinate testing:
	now coord-test-on is true.
	
Every turn when coord-test-on is true: say "-->Coordinates of this location: [bracket][if location is present in the coordinate system][x-coordinate of location], [y-coordinate of location], [z-coordinate of location][otherwise]absent from the coordinate system[end if][close bracket]."


Dynamic Rooms ends here.

---- DOCUMENTATION ----

With this extension, you can easily create and destroy new rooms during play. While this is also possible with Jesse McGrew's "Dynamic Objects," the method here is a little easier for authors, customized for rooms, and available for both z-code and Glulx.

The extension works by creating a reserve of empty rooms when the game first begins and swapping them in and out as needed. The author must declare the maximum number of dynamic rooms that will be needed:

	There are 50 dynamic rooms.

This statement should appear *after* you define your initial starting room (unless you explicitly move the player when play begins). Also note that you can only define 100 duplicates at once; so if you needed 200 dynamic rooms, you'd need something like this (note, however, that performance may suffer with large numbers of dynamic rooms):

	There are 100 dynamic rooms. There are 100 dynamic rooms.

Before creating a new room, you need to check whether there are any unused rooms left. You can use the phrase:

	if out of dynamic rooms:

Or perform more elaborate calculations by checking the number of:

	available dynamic rooms
	used dynamic rooms

To create a new room, you must give it a printed name and assign it to an object variable:

	let excavation be a newly created room with name "Cave";
	
To destroy a dynamic room:

	dissolve excavation;

This will remove any map connections to or from the room, un-name it, and return it to the pool of available dynamic rooms.	

By default, a newborn dynamic room will have no entrances or exits. For convenience, you can instead create a room with a reciprocal exit connecting to any existing location via the shortcut phrase:

	let excavation be a newly created room east of location with name "Cave";

Note that Inform's concept of rooms does not position them in a spatial grid; it's perfectly possible to make a hallway that loops back on itself or other spatial impossibilities. If you want to limit newly created rooms to a standard grid system and avoid allowing new rooms to be placed at the same spatial location as existing rooms, you can use the variation:

	let excavation be a newly created positioned room east of location with name "Cave";
	
You'll also need to establish grid coordinates for any rooms your dynamic rooms can connect to:

	When play begins: locate End of the Tunnel at xyz {0, 0, 0}.
	
Now the extension can automatically track the X/Y/Z coordinates of new dynamic rooms (where the x-axis is east/west, y is north/south, and z is up/down) and prevent them from overlapping each other. Note that you should probably disallow rooms created in "inside" or "outside" directions for this to work, and if your game features non-standard directions you'll have to extend the Table of Direction Map Positioning (open up the extension code to see how to do this).

As a shortcut to defining coordinates for multiple existing rooms, you can simply give a single seed location a coordinate and then relatively position all connected rooms: 

	When play begins: locate End of the Tunnel at xyz {0, 0, 0}; assign xyz coordinates based on End of the Tunnel.
	
...which would locate a room south of End of the Tunnel at {0, -1, 0}, and so on. This works best with relatively small areas; with larger maps this might cause the z-machine to run out of memory. Switching to Glulx should solve the problem.

A few other points about positioned rooms: you can set numerical edges for how far they can extend along certain directions by setting the values of the minimum-map-x and maximum-map-x variables (and their y and z counterparts). You can add more complicated restrictions on when new connections can be made by adding rules to the "validating a map connection" rulebook, which should fail if the connection is disallowed or decide on an existing room if it should connect to it. 

Finally, if any of the newly created room phrases are unable to assign a new room for whatever reason, they will return the room you requested the connection to be made from instead-- in some cases it might be useful to check that these values are not the same before proceeding.

Example: * Frobozz Magic Excavator - Allow the player to create new rooms.

Shows how to use positioned rooms, including simulating an implied spatial infrastructure (the maximum-map options prevent the player from digging east of or above the starting location, near a cliff) and creating a series of rooms within the cliff that the player can discover and connect to.

	*: "Frobozz Magic Excavator"

	Include Dynamic Rooms by Aaron Reed.  

	Near the Cliff is a room. "Ah, a fresh cliff face to the west, just ready for new excavation!" There are 50 dynamic rooms. When play begins: locate Near the Cliff at xyz {10, 0, 0}. The maximum-map-x is 9. The minimum-map-x is 0. The maximum-map-z is 0.
	
	Anteroom is a room. Down from Anteroom is Treasure Chamber. Some precious jewels are in Treasure Chamber. "There are precious jewels here!" When play begins: locate Anteroom at xyz {8, -1, -3}; assign xyz coordinates based on Anteroom.

	The player holds a Frobozz Magic Excavator. Instead of examining Excavator, say "Try DIG (a direction)." Instead of dropping Excavator, say "Better not, at least if you want your deposit back."
 
	Understand "dig [a direction]" as excavating. Excavating is an action applying to one visible thing.
 
	Check excavating:      
		let way be noun;
		if the room way from location is a room, instead say "You've already excavated in that direction.";
		if out of dynamic rooms, instead say "Your Frobozz Magic Excavator seems to be out of juice.";
		if noun is inside or noun is outside, instead say "You can only tunnel up, down, or in a cardinal direction."
	   
	Carry out excavating:  
		let ctr be available dynamic rooms;
		let rm be a newly created positioned room noun of location with name "Cave"; 
		say "You power up your Frobozz Magic Excavator";
		if available dynamic rooms < ctr: 
			say " and tunnel out a passage to the [noun]. As you finish, the charge indicator drops to ([available dynamic rooms] out of [the number of dynamic rooms]).";
		else if the rule failed: 
			say ", but the mass meter indicates insufficient stable rock in that direction to make an excavation.";
		else:
			say " and begin tunneling to the [noun], but soon break through into an open space."
	
	Definition: a direction (called thataway) is viable if the room thataway from the location is a room.

	After looking: 
		let count of exits be the number of viable directions; 
		if the count of exits is 0, say "There are no useful exits." instead;
		if the count of exits is 1, say "From here, the only way out is to [a list of viable directions].";
		otherwise say "From here, the viable exits are to [a list of viable directions]."
	
	test me with "dig e / dig u / dig w / w / dig w / w/ dig s / s / dig d / d / dig d / d / dig d / d / d / get jewels".

Example: ** Cave-In - A randomly generated map.

In this example, we'll generate a random map of ten rooms, and also add the possibility for the floor to collapse and new rooms to be created below the current location.

	*: "Cave-In"

	Include Dynamic Rooms by Aaron Reed.  

	When play begins: say "Stunned, you brush yourself off and stand to your feet. It looks like you fell quite a way through that cave in. Let's hope you can find another way to the surface-- and that the floor is more solid on this level.".

	Cave-In is a room. Daylit Passage is a room.

	There are 15 dynamic rooms.

	The viable cave directions list is a list of objects that varies. The viable cave directions list is {northeast, northwest, southeast}. 

	The cave room names list is a list of texts that varies. The cave room names list is {"Passage", "Cavern", "Tunnel", "Hallway", "Maze", "Scramble", "Jumble"}.

	When play begins:
		let current room be Cave-In;
		let cave name be text;
		let new room be Cave-In;
		let dir be north;
		while available dynamic rooms > 5:
			now dir is entry ( a random number from 1 to the number of entries in the viable cave directions list ) in the viable cave directions list;  
			if the room dir from current room is a room, now current room is the room dir from current room;
			now cave name is entry ( a random number from 1 to the number of entries in cave room names list ) in cave room names list;
			now new room is a newly created room dir of current room with name cave name;
			if a random chance of 1 in 3 succeeds, now current room is new room;
		change up exit of current room to Daylit Passage.

	Every turn when location is Daylit Passage: end the story finally.

	fall count is a number that varies.

	Every turn when we are going and a random chance of 1 in 4 succeeds:
		if the room down from location is nowhere and the printed name of location is not "Pit" and available dynamic rooms > 0:
			let collapse be a newly created room down from location with name "Pit";
			say "Suddenly, the floor gives way underneath you and you fall, adding to your injuries!";
			increase fall count by 1;
			if fall count > 3:
				say "[line break]The fall proves fatal!";
				end the story saying "You have died.";
			else:
				try going down.
		
	Definition: a direction (called thataway) is viable if the room thataway from the location is a room.

	After looking: 
		let count of exits be the number of viable directions; 
		if the count of exits is 0:
			say "The fresh sunlight shines on your face.";
		else if the count of exits is 1:
			say "From here, the only way out is to [a list of viable directions].";
		else:
			say "From here, the viable exits are to [a list of viable directions].";
		continue the action. 

Example: *** Generating Grids of Rooms - Some utility code.

This code is useful to produce large grids of interconnected rooms for testing purposes. Run this code to generate Inform 7 code instantiating an interconnected map of dimensions specified in the gridsize variable. Then copy and paste the output into another project to test map-related code.

	*: "Generating Grids of Rooms"

	x is room. 
	gridsize is a number variable. gridsize is 8.

	When play begins:
		repeat with x running from 1 to gridsize * gridsize:
			say "Room[x] is a room. [if the remainder after dividing x by gridsize is not 0]East is room[x + 1]. [end if][if x + gridsize <= gridsize * gridsize and the remainder after dividing x by gridsize is not 0]Southeast is room[x + gridsize + 1]. [end if][if x + gridsize <= gridsize * gridsize]South is room[x + gridsize]. [end if][if x + gridsize <= gridsize * gridsize and the remainder after dividing x - 1 by gridsize is not 0]Southwest is room[x + gridsize - 1]. [end if][line break]".
			
	  