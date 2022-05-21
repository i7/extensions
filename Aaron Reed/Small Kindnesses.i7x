Version 13.2 of Small Kindnesses by Aaron Reed begins here.

"Provides a number of small interface improvements for players, understanding commands like GO BACK and GET IN, an EXITS command which automatically runs after failed movement, a USE verb, and more. Compatible with Modified Exit and Approaches by Emily Short, Keyword Interface by Aaron Reed, and Implicit Actions by Eric Eve."

[Changelog:
 -- Version 13: Updated for latest build and made adaptive.
 -- Version 12: Fixed a bug and improved the efficiency of "examining the room"; thanks very much to capmikee for the improved code. Added "Leave to exit" section to allow commands like "leave [location]" or "leave room" to work like exit.
 -- Version 11: Minor fixes
 -- Version 10: Updated for compatibility with Player Experience Upgrade
 -- Version 9: Updated EXIT to leave through a sole exit even if its through a door, but not to work when the only valid direction is IN; removed Automatically Leave Containers Before Going (since several other extensions, including Implicit Actions and Modified Exit already cover this). Modified exit listing to also be a standalone action. Fixed a bug in the example.
 -- Version 8: Added the "Examining rooms" section. Facing by Emily Short covers looking at adjacent rooms in a way that overrides what happens here.
 -- Version 7: Tweaked documentation for "Exit leaves when..."
 -- Version 6: Clarified documentation; moved "Prepositionless Alternatives" to Extended Grammar extension.
 -- Version 5: Implemented some minor changes based on Sand-dancer feedback: for instance, wording on failure message for "use" changed to be more explicit what the player should do differently.
 -- Version 4: Updated to remove deprecated features.
 -- Version 3: Removed several sections incorporated into build 6859, including "Automatically leave enterables before going," "Describe contents of containers / supporters", "Understand Get Down as exiting", "Understand Get In as vague entering," as well as several sections that are better handled by other extensions (mention of which was added to the documentation). Also made rules more precise and modified them to use standard library messages whenever possible.
 -- Version 2: fixed a bug where containers/supporters without descriptions showed their contents twice; made the exits lister fail in darkness; added "Allow for switching things in darkness"; added "Prepositionless alternatives."; improved automatically taking indirectly held things to allow for locking/unlocking; removed "Describe contents of containers/supporters."]

Chapter - Compatibility

Section - Parser Speak (for use without Keyword Interface by Aaron Reed)

To say as the parser: do nothing. To say as normal: do nothing.

Chapter - Exit leaves when there's only one way to go

[If a room only has a single exit, typing EXIT should use it. Works through doors. This extends the functionality in Emily Short's Modified Exit, which is already overriding the Standard Rules here. ]

Check an actor exiting (this is the Small Kindnesses exit leaves when there's only one way to go rule):
	let the local room be the location of the actor;
	if the container exited from is the local room:
		if the actor is the player and the count of indirectly-adjacent rooms is 1:
			let way be best route from location to the first indirectly-adjacent room, using even locked doors;
			if way is inside:
				say "[text of can't go that way rule response (A)]";
				say line break;
				stop the action;
			if way is a direction, convert to the going action on way;
		otherwise if the room-or-door outside from the local room is not nothing:
			convert to the going action on the outside.

To decide what number is the count of indirectly-adjacent rooms:
	let ctr be 0;
	repeat with dir running through directions:
		let dest be the room-or-door dir from location;
		if dest is a room:
			increase ctr by 1;
		otherwise if dest is a door and the other side of dest from location is a room:
			increase ctr by 1;
	decide on ctr.

To decide what room is the first indirectly-adjacent room:
	repeat with dir running through directions:
		let dest be the room-or-door dir from location;
		if dest is a room:
			decide on dest;
		otherwise if dest is a door and the other side of dest from location is a room:
			decide on the other side of dest from location;
	decide on location.
				

Section A (for use with Modified Exit by Emily Short)

The small kindnesses exit leaves when there's only one way to go rule is listed instead of the new convert exit into go out rule in the check exiting rules.

Section B (for use without Modified Exit by Emily Short)

The small kindnesses exit leaves when there's only one way to go rule is listed instead of the convert exit into go out rule in the check exiting rules.

Chapter - Leaving a named object (for use without Modified Exit by Emily Short) 

Understand "exit [thing]" as getting off. Understand "get out of [thing]" as getting off.

This is the new can't get off things rule:	
	if the actor is on the noun, continue the action;
	if the actor is carried by the noun, continue the action;
	if the actor is in the noun, continue the action;
	say "[text of can't get off things rule response (A)]";
	say line break;
	stop the action.

The new can't get off things rule is listed instead of the can't get off things rule in the check getting off rules.


Chapter - Go Back returns to previous location

[Keeps track of the player's prior location and understands GO BACK and synonyms as attempting to return. Approaches by Emily Short has a more robust implementation of this, but it expects a noun; if its included, we'll supply the noun for our abbreviated form and turn handling over.]

The small kindnesses former location is a room that varies.

First carry out going rule (this is the Small Kindnesses store former location rule): 
    now the small kindnesses former location is the location.

Section - Implementation (for use without Approaches by Emily Short)

Understand "go back" as retreating. Understand "back" or "return" or "retreat" as retreating.

Retreating is an action applying to nothing.

Carry out retreating (this is the Small Kindnesses carry out retreating rule):
	let way be the best route from the location to the small kindnesses former location through visited rooms, using even locked doors; 
	if way is a direction:
		try going way; 
	otherwise:
		say "[text of block vaguely going rule response (A)]"; ["You'll have to say which compass direction to go in."]
		say line break;
		stop the action.

Section - Implementation (for use with Approaches by Emily Short)

Understand "go to" or "go back to" or "go back" or "return" or "return to" or "revisit" or "back" or "retreat" as approaching.

Rule for supplying a missing noun when we are approaching (this is the Small Kindnesses supply missing noun when approaching rule):
	now the noun is the small kindnesses former location.


Chapter - Examining the room

Understand "look at/around/in/into the/a/an/some/-- [room]" or "look [room]" or "x [room]" or "examine [room]" or "search [room]" as overly elaborate looking. Overly elaborate looking is an action applying to one thing. 

After deciding the scope of the player when overly elaborate looking (this is the Small Kindnesses place the room in scope while looking rule):
   place the location in scope, but not its contents.

Carry out overly elaborate looking (this is the Small Kindnesses overly elaborate looking rule):
	instead try looking.
	
	
Chapter - Leave to exit

Understand "leave [room]" or "exit [room]" or "flee [room]" as getting off.

After deciding the scope of the player when getting off (this is the Small Kindnesses place the room in scope while getting off rule): place the location in scope, but not its contents.

Instead of getting off the location (this is the Small Kindnesses overly elaborate exiting rule), try exiting.

Understand "leave room/area/place/here" as exiting.


Chapter - Show valid directions after going nowhere

[Based on the "Bumping into Walls" example. Tell players trying to move invalidly which directions are open.]

Use no normal movement tricks translates as (- Constant NO_NORMAL_MOVEMENT_TRICKS; -).

Instead of going nowhere (this is the Small Kindnesses reporting on exits rule):
	if the no normal movement tricks option is active, continue the action;
	if in darkness:
		say "[text of room description body text rule response (A)]"; ["It is pitch dark, and you can't see a thing."]
		say line break;
		stop the action; 
	say "[text of can't go that way rule response (A)]";
	say line break;
	try listing exits.

Section - Listing Exits (for use without Keyword Interface by Aaron Reed)

Definition: a direction is viable if the room it from the location is a room. 

Listing exits is an action out of world applying to nothing. Understand "exits" as listing exits. The listing exits action has a number called the count of exits.

Carry out listing exits (this is the Small Kindnesses count exits rule): now count of exits is the number of viable directions.

Report listing exits when count of exits is 0 (this is the Small Kindnesses report on no exits rule):
	say "In fact, [we] [can't see] any obvious exits." (A)

Report listing exits when count of exits is 1 (this is the Small Kindnesses report on one exit rule):
	say "The only way to go [are] [list of viable directions]." (A)

Report listing exits when count of exits > 1 (this is the Small Kindnesses report on exits rule):
	say "From here, [we] [can go] [list of viable directions]." (A)


Chapter - Allow for switching things in darkness

[If the player switches off something providing light and not held, allow them to switch it back on again. ]

Definition: a thing is switchable: if it provides the property switched on, yes.

After deciding the scope of the player when in darkness (this is the Small Kindnesses allow for switching things in darkness rule):
	repeat with machine running through switchable things enclosed by location:
		unless the holder of machine is a closed opaque container and the holder of machine is not the holder of player, place machine in scope.


Chapter - Don't perform implicit actions for doomed tasks

[Inspired by (but implemented differently from) the "Delicious, Delicious Rocks" example. Don't bother to try automatically taking something as a result of a WEAR command that can't possible work (because the noun isn't wearable). This formerly included EAT and edible too, but that functionality now exists in the standard library.]

Before wearing a not wearable thing which is not held by the player (this is the Small Kindnesses don't implicitly take unwearables rule):
	say "[text of can't wear what's not clothing rule response (A)]";
	say line break;
	stop the action. 

Chapter - Implement Use verb for common actions

[Based on "Alpaca Farm" in the I7 docs. Does the most obvious action if the player tries to USE something.]

Understand "use [something]" as using. Using is an action applying to one thing.

Carry out using (this is the Small Kindnesses carry out using rule): say "You'll have to try a more specific verb than use." (A)

Understand "use [an edible thing]" as eating. 

Understand "use [a wearable thing]" as wearing. 

Understand "use [a closed openable container]" as opening. Understand "use [an open openable container]" as closing. 

Understand "use [something preferably held] on [a locked lockable thing]" as unlocking it with (with nouns reversed). Understand "use [something preferably held] on [an unlocked lockable thing]" as locking it with (with nouns reversed). 

Understand "use [a switched off device]" as switching on. [We don't have the reverse, since typically something that's switched on has a more useful function which USE might refer to.]

Understand "use [a closed door]" as opening. Understand "use [an open door]" as entering. 

Understand "use [an enterable not occupied supporter]" as entering. Understand "use [an enterable not occupied container]" as entering. Definition: something is occupied if it encloses the player.


Small Kindnesses ends here.

---- DOCUMENTATION ----

Players often stumble on minor annoyances in the standard behavior of an Inform game. Many of these have been "fixed" over and over again by individual authors. This extension packages up a number of these small kindnesses, many taken from examples in the Inform 7 documentation, to make things a little easier for your players.

This extension is designed to play well and overlap as little as possible with several similar extensions. Anyone including this extension should highly consider also using Modified Exit by Emily Short, Locksmith by Emily Short, Extended Grammar by Aaron Reed, and Implicit Actions by Eric Eve. It borrows a few pieces of functionality from these extensions, in case of compiling for a small platform. This extension should function well with or without any of these. 

Simply including the extension is all that is needed, unless you wish to remove some of the behaviors. To remove one, replace the section title with a blank or modified bit in your code (see "Extensions can interact with other extensions" in the docs). For example, if you don't want the implementation of a "use" verb:

	Chapter - No use verb (in place of Chapter - Implement Use verb for common actions in Small Kindnesses by Aaron Reed) 

Here are the names of all the sections.

	Chapter - Exit leaves when there's only one way to go
	Chapter - Go Back returns to previous location
	Chapter - Examining the room
	Chapter - Automatically leave containers before going
	Chapter - Show valid directions after going nowhere
	Chapter - Allow for switching things in darkness
	Chapter - Don't perform implicit actions for doomed tasks
	Chapter - Implement Use verb for common actions


Example: * Checkup - A small example illustrating the extension's functionality.

	*: "Checkup"

	Include Small Kindnesses by Aaron Reed.

	Sidewalk is a room. The Waiting Room is inside from Sidewalk. The Dentist's Office is east of Waiting Room. A reclined chair is a fixed in place enterable supporter in Office. "You see a comfy chair here." The player wears a backpack. The backpack is open and openable. In the backpack is a magazine.    

	Test me with "look at sidewalk / in / e / exit / n / e / get in chair / w / go back / eat chair / sit on chair / use backpack". 
