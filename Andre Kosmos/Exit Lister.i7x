exit lister by Andre Kosmos begins here.

A door has a text called passing text. Passing text of a door is usually "through".

To say closed door: say "(closed)".

To say exit list:
	let place be location;
	let counter be 0;
	repeat with way running through directions
	begin;
		let place be the room way from the location;
		if place is a room then increase counter by 1;
	end repeat;
	if counter is 0 then say "nowhere";
	repeat with way running through directions
	begin;
		let place be the room way from the location;
		if place is a room
		begin;
			Let gateway be location;
			if mentioning doors is yes
				begin;		
				repeat with item running through doors
					begin;
						if front side of the item is location and back side of the item is place then let gateway be item;
						if front side of the item is place and back side of the item is location then let gateway be item;
					end repeat;
				end if;
				decrease counter by 1;
				say "[way]";
				if gateway is not location
				begin; say " [passing text of gateway] [the gateway]";
					if gateway is closed then say "[closed door]";
				end if;
			if place is visited and room memory is yes then say " to [place]";
			if counter is greater than 1 then say ", ";
			if counter is 1 then say " or ";
		end if;
	end repeat.
	
listing exits is an action applying to nothing.
understand "exits"  as listing exits.
carry out listing exits: say "You can go [exit list] from here.".
Yes_No_flag is a kind of value.
Yes_no_flags are yes and  no.
List exits is an Yes_no_flag that varies. List exits is yes.
mentioning doors is an Yes_no_flag that varies. mentioning doors is yes.
Room memory is an Yes_no_flag that varies. Room memory is yes.

This is the exits rule: if list exits is yes then say "You can go [exit list] from here.".
The exits rule is listed last in the carry out looking rules.

Turning exits on is an action out of world.
Understand "exits on" as turning exits on.
carry out turning exits on: change list exits to yes.
Report turning exits on: say "(exits listing is on)".

Turning exits off is an action out of world.
Understand "exits off" as turning exits off.
carry out turning exits off: change list exits to no.
Report turning exits off: say "(exits listing is off)".

To don't mention doors: now mentioning doors is no.
To mention doors: now mentioning doors is yes.
To mention visited rooms: now room memory is yes.
To don't mention visited rooms: now room memory is no.


exit lister by Andre Kosmos ends here.

---- DOCUMENTATION ----

This extension gives you a list of available exits at the end of the room description.
There are options to mention doors that are in your way, and to mention rooms you have already visited.


 new commands:

...for the player

	'EXITS'	 ------- this gives a list of the available exits.
	'EXITS ON' ---- after this command there will be a list of available exits at the end of the room description. (default setting)
	'EXITS OFF' --- after this command the list of exits will no longer appear at the end of the room description.


 ...for you:	[note: you must use these commands as part of a rule! Like: If (condition) then (command)]

	'mention doors'
		after this command the exit lister will mention if there is a door in the way of an exit. (default setting)

	'don't mention doors'
		after this command doors will no longer be mentioned in the exit list.

	'mention visited rooms'
		after this command exits leading to a visited room will mention this room. (default setting)

	'don't mention visited rooms'
		after this command exits leading to a visited room will no longer mention this room.

 various

Doors have a new property called passing text. The default is "through"
some suggestions for other types of doors are : "over" for bridges, "climbing" for ropes and ladders

Closed doors are mentioned with the text "(closed)" by default, but you can write your own text with:
	To say closed door: say "(after you have managed to open it)".
If you don't want to mention the fact that a door is closed you can use:
	To say closed doors: do nothing instead.

PROBLEM!!!
When you have a door between two locations, but there are also 2 ways between those locations, like a north-south passage and a east west passage, things might go wrong. See example B: test problem for exit lister.




Example: * test game for exit lister - 

	"test game for exit lister" by Andre Kosmos.

	include exit lister by Andre Kosmos. 

	Hallway is a room. "This hallway is decorated with the simplest wallpaper you have ever seen. There are no pictures, or plates with wise words, nor tiles with proverbs hanging on any 	of the walls. The only thing you notice is that all the doors are painted in different colors."

	The pink door is east of hallway and west of Bathroom. It is a door and scenery.
	The description of the bathroom is "Everything in here is pink. The tiles on the walls, the toilet bowl, the bathtub, the floor, and even the ceiling. The only thing not pink is a large mirror 	on the wall, but since all it reflects is pink that hardly matters.".
	A large mirror is scenery in bathroom. Instead of examining mirror, say "Don't be vain, you look fine.".

	The brown door is west of hallway and east of the Living Room. It is a door and scenery.
	The description of the living room is "You are in a well decorated room here, there are numerous pictures on the walls, some comfy looking chairs, and a big television set."

	The green door is south of hallway and north of Garden. It is a door and scenery.
	The description of garden is "A large garden with very short cut grass, and various flowerbeds. The main thing you notice is a large oak tree. From between the leaves of the trees 	you see a rope ladder hanging down to the ground. The ladder is dug into the ground to keep it from swinging to much when you climb it."

	The rope ladder is up from garden and down from the Tree house. It is a open unopenable door and scenery.
	The passing text of rope ladder is "climbing". Instead of climbing the rope ladder in tree house, try going down. Instead of climbing the rope ladder in garden, try going up.

	The description of the tree house is "A Rather untraditional tree house, the walls are decorated with a rather ugly wallpaper with pink and purple flowers, and a thick red carpet covers 	the floor."

	A wooden bridge is east of garden and west of the Main Street. It is an open unopenable door and scenery. The passing text of the wooden bridge is "over".

	The description of the main street is "This is the main street, from here you could go to town to see a movie, visit a pub, or something. If only the author of this game wasn't to lazy 	to write those pleasant locations in. Ah well...  maybe next version."

	When play begins:
		say "Do you want a list of possible exits at the end of the room description?";
		if player consents, try turning exits on;
		otherwise try turning exits off;
		say "[paragraph break]You can always turn the exit list on or off with the commands EXITS ON and EXITS OFF. You can also always ask for an exit list with the command 			EXITS.[paragraph break]Do you want the exit lister to mention locations you have already visited?";
		if player consents, now room memory is yes;
		otherwise now room memory is no;
		say "[paragraph break]Sometimes the exit list can tell you that you can go north, but when you try to the game tells you that You can't, since some door is in the way.				[paragraph break]Do you want to mention those doors in the exit list?";
		if player consents, mention doors;
		otherwise don't mention doors;
		say "[paragraph break]".


	test me with "open green door / s / e / w / u"


Example: *  test problem for exit lister - 

	"test problem for exit lister" by Andre Kosmos.

	include exit lister by Andre Kosmos. 

	Hallway is a room. "This hallway is decorated with the simplest wallpaper you have ever seen. There are no pictures, or plates with wise words, nor tiles with proverbs hanging on any 	of the walls. The only thing you notice is that all the doors are painted in different colors."

	The brown door is west of hallway and east of the Living Room. It is a door and scenery.
	The description of the living room is "You are in a well decorated room here, there are numerous pictures on the walls, some comfy looking chairs, and a big television set."

	The green door is south of hallway and north of Living room. It is a door and scenery.

	
The green door is now mentioned instead of the brown door. And if you have only one door it will be mentioned for both directions. Maybe I will find a solution for this problem, but I doubt it. My advise is to avoid this situation. If you have two connections between the same two rooms, don't put any doors there! 
