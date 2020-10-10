Version 1 of Rapid Prototyping (for Glulx only) by B David Paulsen begins here.

"A way to create and extend a game world on the fly during testing via a REPL idiom."

Volume 1 - Rapid Prototyping (not for release)

Include Object Kinds by Brady Garvin.

Book 1 - Mapping

When play begins:
	repeat with item running through rooms:
		if the true-name of the item is empty, now the true-name of the item is "[printed name of item]";
	repeat with item running through things:
		if the true-name of the item is empty, now the true-name of the item is "[printed name of item]".

[Creating a map and source text.]
The initial location is an object  that varies.
When play begins: now the initial location is the location of the player. 

Checked rooms is a list of rooms that varies.
Definition: a room is unchecked if it is not listed in checked rooms.
Definition: a thing is non-player if it is not the player.

To decide which list of texts is adjacent-rooms-with-dir of (origin - a room):
	let L be a list of texts;
	repeat with r running through not unchecked rooms adjacent to origin:
		let d be the best route from r to origin;
		let t be "[printed name of d] of [true-name of r]";
		add the substituted form of t to L;	
	decide on L.

To recursively map from (r - a room), finally:
	let name be the true-name of r;
	if all rooms adjacent to r are unchecked:
		if the name matches the text "[the singular of the object kind of r]":
			say "There";
		otherwise:
			say "[name]";
		say " is a room. ";
	otherwise:
		say "[name] is [adjacent-rooms-with-dir of R]. ";
	if name is not the printed name of the r:
		say "The printed name of [name] is '[printed name of the r]'. ";
	if not finally:
		say "The true-name of [name] is '[name]'.[line break]";
	otherwise:
		say "[line break]";	
	if the description of the R is not empty, say "The description of [name] is '[description of R]'";
	say line break;
	repeat with item running through non-player things held by R:
		if the item is not the locality:
			say line break;
			if not finally:
				recursively item-map the item;
			otherwise:
				recursively item-map the item, finally;
	say line break;
	add r to checked rooms;
	let L be a list of rooms;
	add the list of (unchecked rooms which are adjacent to r) to L;
	if the number of entries in L is not 0:
		repeat with place running through L:
			if the place is unchecked:
				if not finally:
					recursively map from place;
				otherwise:
					recursively map from the place, finally.

To recursively item-map (item - an object), finally:
	let nm be the object kind of the item;
	let L be a list of texts;
	if the item is not a backdrop:
		if the item is scenery:
			 add "scenery" to L;
		if the item is not scenery and the item is fixed in place:
			add "fixed in place" to L;
		if the item provides the property enterable and the item is enterable:
			add "enterable" to L;
		if the item is a thing and the item is proper-named:
			add "proper-named" to L;  
	let x be "[if the item is improper-named]The [end if][true-name of the item]";
	let x_lc be "[if the item is improper-named]the [end if][true-name of the item]";
	say "[x] is a [if L is not empty][L] [end if][the singular of nm]. ";
	if not finally:
		say "The true-name of [x_lc] is '[true-name of item]'. ";
	if the item is worn by someone (called the wearer), say "[X] wears the [true-name of item]";
	if the item is part of something (called the incorporator), say "[X] is part of [the true-name of the incorporator]";
	if the item is on something (called the supporter), say "[X] is on [the true-name of the supporter]";
	if the item is in a thing (called the container), say "[X] is in [the true-name of the container]";
	if the item is in a room (called the place), say "[X] is in [the true-name of the place]";
	say ".[run paragraph on][if the description of the item is not empty] The description of [x_lc] is '[description of the item]'[end if][line break]";
	if the item provides initial appearance:
		if the initial appearance of the item is not empty, say "The initial appearance of [x_lc] is '[initial appearance of the item]'[line break]";
	if the true-name of the item is not the printed name of the item:
		say "The printed name of [x_lc] is '[printed name of the item]'.[line break]";
	repeat with next-item running through things held by the item:
		say line break;
		if finally, recursively item-map the next-item;
		otherwise recursively item-map the item, finally.

Intermediate compiling is an action out of world. Understand "view code/source" as intermediate compiling.
Carry out intermediate compiling:
	while there is an unchecked room which is placed:
		if there are no not unchecked placed rooms:
			recursively map from the initial location;
		otherwise:
			recursively map from a random unchecked placed room;
	truncate the checked rooms to 0 entries.

Final-compiling is an action out of world. Understand "view code/source finally" as final-compiling.
Carry out final-compiling:
	while there is an unchecked room which is placed:
		if there are no not unchecked placed rooms:
			recursively map from the initial location, finally;
		otherwise:
			recursively map from a random unchecked placed room, finally;
	truncate the checked rooms to 0 entries.



Book 2 - Altering the World

Part 1 - Extending the buffer

Include (-
Array gg_event --> 4;
Array gg_arguments buffer 28;
Global gg_mainwin = 0;
Global gg_statuswin = 0;
Global gg_quotewin = 0;
Global gg_scriptfref = 0;
Global gg_scriptstr = 0;
Global gg_savestr = 0;
Global gg_commandstr = 0;
Global gg_command_reading = 0;
Global gg_foregroundchan = 0;
Global gg_backgroundchan = 0;

Constant GLK_NULL 0;

! The only thing we need to change here is the limits on buffer size.
! There's a weird relationship here between the three. Honestly,
! I just fudged the ratio.
Constant INPUT_BUFFER_LEN = 1000;
Constant MAX_BUFFER_WORDS = 200;
Constant PARSE_BUFFER_LEN = 400;

Array  buffer    buffer INPUT_BUFFER_LEN;
Array  buffer2   buffer INPUT_BUFFER_LEN;
Array  buffer3   buffer INPUT_BUFFER_LEN;
Array  parse     --> PARSE_BUFFER_LEN;
Array  parse2    --> PARSE_BUFFER_LEN;
-) instead of "Variables and Arrays" in "Glulx.i6t".


Part 2 - New actions

Chapter 1 - Text properties

Every thing has a text called the true-name.
Every room has a text called the true-name.

Understand the printed name property as describing a thing.
Understand the true-name property as describing a thing.

When play begins:
	if the true-name of the location is empty:
		now the true-name of the location is "[the singular of the object kind of the location]".


Locality is a backdrop. It is everywhere and privately-named. Understand "location" as locality. 
The printed name of the locality is "[location]".
The true-name of the locality is "[true-name of location]".
The item-in-question is an object that varies.

Understand the command "describe" as something new.
Item-description is an action applying to one thing.
Understand "describe [something]" as item-description.

Describing is a truth state variable. Describing is false.

Carry out item-description (this is the general item-description rule):
	if the noun is the locality, now the item-in-question is the location;
	otherwise now the item-in-question is the noun;
	say "Describing the " (A);
	say "[the singular of the object kind of the item-in-question] '[bold type][item-in-question][roman type]':[line break]";
	say "(press RETURN once for paragraph break, or twice to stop typing)" (B);
	if the description of item-in-question is not empty, say "[line break]([italic type]after the text[roman type] " (C);
	say "'[description of the item-in-question]')";
	now describing is true.

Rule for printing a parser error when the latest parser error is the I beg your pardon error and describing is true (this is the concluding item-description rule):
	now describing is false;
	say "Updated." (A);
	try looking.
	
After reading a command when describing is true:
	let x be the substituted form of the description of the item-in-question;
	let pc be the substituted form of the player's command;
	let n be the number of characters in x;
	let y be "[the substituted form of x][if n is not 0][paragraph break][end if][pc]";
	if character number 1 in y is " ", replace character number 1 in y with ""; 
	now the description of the item-in-question is the substituted form of y;
	if the Testing Correction option is active, now the description of the item-in-question is the description of the item-in-question in sentence case;
	reject the player's command.
	
Understand the command "undescribe" as something new.
Description-clearing is an action applying to one thing.
Understand "undescribe [something]" as description-clearing.

Carry out description-clearing (this is the general description-clearing rule):
	if the noun is the locality, now the noun is the location;
	now the description of the noun is "";
	say "Cleared." (A);
	try looking.

Item-renaming is an action applying to one thing and one topic.
Understand "name [something] [text]" as item-renaming.

Carry out item-renaming: 
	let subject be an object;
	if the noun is the locality:
		let the subject be the location;
	otherwise:
		let the subject be the noun;
	if the topic understood matches the text "|":
		let s be the substituted form of the topic understood;
		let t be s;
		replace the regular expression "\|.*" in s with "";
		replace the regular expression ".*\|" in t with "";
		now the printed name of the subject is s;
		now the true-name of the subject is the t;
	otherwise:
		let w be word number (number of words in the topic understood) in the topic understood;
		now the printed name of the subject is the topic understood;
		now the true-name of the subject is the w.

Report item-renaming (this is the report renaming for items rule):
	say  "Updated." (A);
	try looking.

Item-appearance-editing is an action applying to one thing and one topic.
Understand "appearance [something] [text]" as item-appearance-editing.
Carry out item-appearance-editing: 
	now the initial appearance of the noun is the topic understood;
	if the initial appearance of the noun is not empty and character number 1 in the initial appearance of the noun exactly matches the text "#", replace character number 1 in initial appearance of the noun with "";
	if the Testing Correction option is active, now the initial appearance of the noun is the initial appearance of the noun in sentence case.

Report item-appearance-editing (this is the report changing initial appearance for items rule):
	say  "Updated." (A);
	try looking.

Section 1 - Correcting text for the testing examples

[Testing correction is simply there to ensure that TEST ME commands aren't kept in lowercase. It's not intended for daily use.]
Use testing correction translates as (- Constant TESTING_CORR; -).

Chapter 2 - Binary properties

Fixing-in-place is an action applying to one thing. Understand "fix [something]" as fixing-in-place.
Check fixing-in-place when the noun is the locality (this is the block fix-in-place for rooms rule): say "A room can't be fixed in place." (A) instead.
Carry out fixing-in-place: now the noun is fixed in place.
Report fixing-in-place (this is the report fixing in place rule): say "Updated." (A)

Portable-making is an action applying to one thing. Understand "unfix [something]" as portable-making.
Check portable-making when the noun is the locality (this is the block making rooms portable rule): say "A room can't be portable." (A) instead.
Carry out portable-making: now the noun is portable.
Report portable-making (this is the report making portable rule): say "Updated." (A)

Scenery-making is an action applying to one thing. Understand "scenery [something]" as scenery-making.
Check scenery-making when the noun is the locality (this is the block making rooms scenery rule): say "A room can't be scenery." (A) instead.
Carry out scenery-making: now the noun is scenery.
Report scenery-making (this is the report making scenery rule): say "Updated." (A)

Not-scenery-making is an action applying to one thing. Understand "unscenery [something]" as not-scenery-making.
Check not-scenery-making when the noun is the locality (this is the block making rooms not scenery rule): say "A room can't be scenery." (A) instead.
Carry out not-scenery-making: now the noun is not scenery.
Report not-scenery-making (this is the report remove scenery status rule): say "Updated." (A)

Enterable-making is an action applying to one thing. Understand "enterable [something]" as enterable-making.
Check enterable-making when the noun is not a supporter and the noun is not a container (this is the block making enterable rule): say "That can't be entered." (A) instead.
Carry out enterable-making: now the noun is enterable.
Report enterable-making (this is the report making enterable rule): say "Updated." (A)

Not-enterable-making is an action applying to one thing. Understand "unenterable [something]" as not-enterable-making.
Check not-enterable-making when the noun is not a supporter and the noun is not a container (this is the block making unenterable rule): say "That can't be entered." (A) instead.
Carry out not-enterable-making: now the noun is not enterable.
Report not-enterable-making (this is the report making unenterable rule): say "Updated." (A)

Proper-naming is an action applying to one thing. Understand "proper [something]" as proper-naming.
Check proper-naming when the noun is not a thing (this is the block making proper-named rule): say "That can't be proper-named." (A) instead.
Carry out proper-naming: now the noun is proper-named.
Report proper-naming (this is the report making proper-named rule): say "Updated." (A)

Improper-naming is an action applying to one thing. Understand "improper [something]" as improper-naming.
Check improper-naming when the noun is not a thing (this is the block making improper-named rule): say "That can't be improper-named." (A) instead.
Carry out improper-naming: now the noun is improper-named.
Report improper-naming (this is the report removing improper-named status rule): say "Updated." (A)


Chapter 3 - Relation properties

Fusing it to is an action applying to two things. Understand "fuse [something] to [something]" as fusing it to.
Check fusing the player to something (this is the block fleshcrafting rule): say "Grisly, but disallowed. Try again." (A) instead.
Check fusing a backdrop to something (this is the block fusing backdrops rule): say "Not permitted." (A) instead.
Carry out fusing: now the noun is part of the second noun.
Report fusing (this is the report successful fusion rule): say "Good, [the noun] [are] now part of [the second noun]." (A)

[We need no unfusing function because, after all, there's the Purloin keyword for that.]

Part 3 - Spontaneous generation of objects

An object can be placed or unplaced. A thing is usually placed. A room is usually placed.

There are 50 unplaced things.
There are 20 unplaced containers.
There are 20 unplaced supporters.
There are 10 unplaced devices.
There are 5 unplaced men.
There are 5 unplaced women.
There are 5 unplaced animals.
There are 10 unplaced rooms.


Chapter 1 - Spontaneous item-creation

Spawning is an action applying to one topic. Understand "add [text]" as spawning. 

Check spawning (this is the block spawning improper objects rule):
	let t be a text;
	repeat with I running through object kinds:
		let t be "[the singular of I]";
		if t exactly matches the text the topic understood:
			if there is no unplaced thing of kind I:
				say "There's no " (A);
				say "[substituted form of t]";
				say " left, you need to declare a new one." (B) instead;
			continue the action;
	say "That is not a placeable object." (C) instead.

Carry out spawning:
	let t be a text;
	repeat with I running through object kinds:
		let n be 0;
		let t be "[the singular of I]";
		if t exactly matches the text the topic understood:
			repeat with item running through unplaced things:
				if the object kind of the item is I:
					move the item to the location of the player;
					now the item is placed;
					now the printed name of the item is "fresh [substituted form of t]";
					now the true-name of the item is "[substituted form of t] #[n]";
					increment n; 
					rule succeeds.

Report spawning (this is the report successfully spawned item rule):
	say "Added." (A)

A room can be marked for deletion.
After going from a room (called place) which is marked for deletion (this is the consequences of destruction of path rule):
	repeat with item running through things held by the place:
		if the item is not a backdrop:
			 try item-deleting the item;
	now the printed name of the place is "";
	now the description of the place is "";
	now the true-name of the place  is "";
	now the place is unplaced;
	unmap the place;
	say "The path [opposite of noun] disintegrates behind you." (A)

To unmap (r - a room):
	repeat with dir running through directions:
		if the room dir from the location is not nothing:
			let x be the room dir from the location;
			change the dir exit of the location to nothing;
			change the opposite of dir exit of the x to nothing.


Item-deleting is an action applying to one object. 
The item-deleting action has a text called the thing destroyed.

Setting action variables for item-deleting: 
	if the noun is a thing:
		let x be the printed name of the noun;
		if the noun is improper-named, let x be "The [x]";
		now the thing destroyed is the substituted form of x.

Understand "delete [something]" as item-deleting. Understand "delete [direction]" as item-deleting.
Check item-deleting when the noun is the player (this is the prevent nihilism rule): say "The editor won't let you unmake yourself." (A) instead.
Check item-deleting when the noun is a backdrop and the noun is not the locality (this is the block unmaking rule): say "[The true-name of noun] cannot be unmade." (A) instead.

Carry out item-deleting when the noun is the locality:
	now the location is marked for deletion.

Carry out item-deleting when the noun is a direction:
	let x be the room noun from the location;
	change the noun exit of the location to nothing;
	change the opposite of noun exit of the x to nothing.
	
Carry out item-deleting when the noun is a thing and the noun is not a backdrop:
	now the printed name of the noun is "";
	now the true-name of the noun is "";
	now the description of the noun is "";
	now the noun is not scenery;
	now the noun is not fixed in place;
	now the noun is unplaced;
	remove the noun from play.
	
Report item-deleting when the noun is a thing and the noun is not the locality (this is the report proper item-deletion rule):
	say "[The thing destroyed] vanishes in a puff of logic." (A)

Report item-deleting when the noun is the locality (this is the report pending room-deletion rule):
	say "This room will be deleted upon exit." (A);

Report item-deleting when the noun is a direction (this is the report vanishing path rule):
	say "The path to [the noun] vanishes." (A)

Chapter 2 - Spontaneous room creation

Digging is an action applying to one object.
Understand "dig [direction]" as digging.

Check digging (this is the can't dig into existing room rule):
	let dir be the noun;
	if the room dir from location is not nothing, say "There's already a room called [the printed name of room dir from location] in that direction." (A) instead.
	
Check digging when there is no unplaced room (this is the out of rooms rule): say "Out of placeable rooms. Increase the limit and try again." (A) instead.

Carry out digging:
	let new-room be a random unplaced room;
	let dir be the noun;
	change the dir exit of the location to the new-room;
	change the opposite of dir exit of the new-room to the location;
	now the printed name of the new-room is "room";
	now the true-name of the new-room is "room #[number of on-stage rooms]";  
	now the new-room is placed.
	
Report digging (this is the report update and going rule):
	say "Updated. Going [noun]." (A);
	try going noun.
	
Dig-connecting is an action applying to two objects.
Understand "dig [direction] [any room]" as dig-connecting.

Check dig-connecting (this is the block improper connecting of rooms rule):
	let dir be the noun;
	if the room dir from location is not nothing:
		say "There's already a room called " (A);
		say "[the printed name of room dir from location]";
		say " in that direction." (B) instead;
	if the room opposite of dir from the second noun is not nothing:
		say "There's already a room called " (C); 
		say "[the printed name of room opposite of dir from the second noun]";
		say " in that direction from [the second noun]." (D) instead.
	
Carry out dig-connecting:
	let dir be the noun;
	change the dir exit of the location to the second noun;
	change the opposite of dir exit of the second noun to the location.

Report dig-connecting (this is the report successful connection rule):
	say "Updated." (A);
	try looking.

Understand the printed name property as describing a room.
Understand the true-name property as describing a room.

Book 3 - Ease of use

Requesting help is an action applying to nothing. Understand "help" or "commands" as requesting help.

Report requesting help:
	repeat through the Table of Commands:
		say "[bold type]== [title entry] ==[roman type][paragraph break]";
		repeat through the table entry:
			say help-row for command entry and meaning entry;
		say line break.

To say (x - text) in brackets: say "[bracket]"; say x; say "[close bracket]"; 
To say h-iol: say "item or 'location'" in brackets.
To say h-i: say "item" in brackets.
To say h-l: say "'location'" in brackets.
To say h-t: say "text" in brackets.
To say h-k: say "kind" in brackets.
To say h-d: say "direction" in brackets.
To say h-r: say "room" in brackets.
To say help-row for (x - text) and (y - text): say "[bold type][x]:[italic type]         [y][line break]".

Table of Commands
title	table
"Commands relating to text"	Table of Text Prototyping Commands
"Setting and unsetting properties"	Table of Property Prototyping Commands
"Adding and removing things"	Table of Creation Prototyping Commands
"Other commands"	Table of Other Prototyping Commands

Table of Text Prototyping Commands
command	meaning
"describe [h-iol]"	"Appends new paragraph to the description of the item or location. Paragraphs are broken with ENTER. Editing ends by hitting ENTER twice."
"undescribe [h-iol]"	"Clears the description of the item or location."
"name [h-iol] [h-t]"	"Changes the name of the item or the current location into the text. Also sets the I7 name of the item or room to the last word of the text."
"name [h-iol] [h-t]|[h-t]"	"Alternate syntax to manually specify both the name of the item or room, and the internal I7 name of the item or room."
"appearance [h-i] [h-t]"	"Sets the initial appearance of the item to the text."

Table of Property Prototyping Commands
command	meaning
"enter/unenter [h-i]"	"Toggles enterable status for the item."
"fix/unfix [h-i]"	"Toggles fixed in place status for the item."
"scenery/unscenery [h-i]"	"Toggles scenery status for the item."
"proper/improper [h-i]"	"Toggles whether the item is proper-named or not."
"fuse [h-i] to [h-i]"	"Makes the first item part of the second."

Table of Creation Prototyping Commands
command	meaning
"add [h-k]"	"Spawns a blank item of the specified kind in location."
"delete [h-i]"	"Removes the item specified from the game."
"delete [h-d]"	"Removes a path in the specified direction." 
"delete [h-l]"	"Marks the current location and its contents for deletion. Deletion occurs when the player leaves the room."
"dig [h-d]"	"Makes a passage in the specified direction and places a room there."
"dig [h-d] [h-r]"	"Connects location via the specified direction to the named room."

Table of Other Prototyping Commands
command	meaning
"view code/source"	"Generates the resultant I7 code. This code contains the metainformation necessary to continue using Rapid Prototyping."
"view code/source finally"	"Generates the resultant I7 code without metainformation. This is what you use when you're done prototyping."
"help"	"Displays this help section."

Rapid Prototyping ends here.

---- DOCUMENTATION ---- 

Chapter 1 - Acknowledgements and notes

The extension relies on the "Object Kinds" extension by Brady Garvin. A useful and versatile extension, Object Kinds can unfortunately not be found in the Public Library. Instead, you need to download it from its GitHub page, via the address  

	https://github.com/i7/extensions/blob/master/Brady%20Garvin/Object%20Kinds.i7x

Thanks to Alice Grove and Matt Wighdahl, who provided sanity check, invaluable feedback and much-needed encouragement.

Chapter 2 - The reason for this extension

While Inform 7 is a very good system for creating IF, it's still a compiled language. A natural consequence of that is its lengthy iteration cycle: coding is followed by compilation (often aborted by the discovery of a bug), then testing by reaching a game state, only to discover something is lacking, at which point we go back and do it all over again. This, mind you, is in the ideal bug-free case. Every step of this sequence carries the attendant risk of getting side-tracked, losing steam, or tiring an author by constantly switching between tasks. Rapid Prototyping is an attempt to shorten the loop by giving feedback in a manner reminiscent of REPL type languages like Python.

The extension only provides basic building functionality. Nontrivial behavior such as rules and activities are well beyond its scope.
 
Using Rapid Prototyping follows a basic workflow. First, you keep the dynamically generated source code under its separate header. Next, you compile a minimal game. While walking through the game, you add and modify the world as needed, until you hit a point where the extension's facilities are inadequate (see above for examples). At that point, you "view source", copy the generated code, and paste it under the prepared header. After having added any complex functionality under its own header, you recompile, and the cycle starts again.

Chapter 3 - How to use this extension

Instead of creating the game and then testing it, Rapid Prototyping aims for a more natural process of designing an IF world: you compile an empty game, then add rooms, things and various other bits and pieces as you see fit. These changes to the game world appear at run-time, and can be interacted with seamlessly. Once you are satisfied with how the world behaves, the "view source" command produces source code that you can then use for refining the next iteration. Finally, by adding the flag "finally" to "view source", you can output source code without the metainformation used internally by the extension.

Note that all examples here use testing correction, which is only needed when using the TEST command to demonstrate functionality.

Example: * Simple test case -- Creating a small room and filling it with items.
	*: "Simple test case"
	
	Include Rapid Prototyping by B David Paulsen.
	Use testing correction.
	
	There is a room.

	test me with "test surroundings/test sofa/look/view code".
	test surroundings with "name location Your Home/describe location/Your home is as it ever was: neat, cozy, and in dire need of cleaning./Well, all right, some would say it's a filthy hovel. But they'd be wrong./".
	test sofa with "add container/enterable container/fix container/describe container/You've always had a soft spot for this leather sofa, patches and all.//appearance container Your sofa stands here invitingly./name container sofa that's seen better days|sofa/add thing/name thing patch/fuse patch to sofa".


