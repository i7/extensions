Version 2.0.220529 of Title Case for Headings by Nathanael Nerode begins here.

"Applies title case to room names printed as a heading or in the status line.  Creates the printing a heading activity for further customization.  Tested with Inform 10.1.0.  Requires Undo Output Control by Nathanael Nerode to handle the case of room name printing after UNDO."

[Distinguish printing the *title* of a room in a heading, which should be titlecased, from printing the *name* of a room under other circumstances, which should not.  This allows more coherent use of room names like "a meadow".
There are two "heading" usages in the Standard Rules: the room description heading, and the status line.  There is also a subtle third usage when the room name is printed after "undo".]

Chapter 1 - Title Case for Headings

Section 0 - New activities

Printing a heading is an activity.
Reacting after undoing is an activity.

Section 1 - Replace room description heading rule

[We have to replace the room description heading rule.]
The room description heading with activity rule is listed instead of the room description heading rule in the carry out looking rules.

Carry out looking (this is the room description heading with activity rule):
	say bold type;
	if the visibility level count is 0:
		begin the printing the name of a dark room activity;
		if handling the printing the name of a dark room activity:
			say "[text of the room description heading rule response (A)]" (A);
[			say "Darkness" (A);]
		end the printing the name of a dark room activity;
	otherwise:
		begin the printing a heading activity;
		if handling the printing a heading activity:
			if the visibility ceiling is the location:
				say "[visibility ceiling]";
			otherwise:
				say "[The visibility ceiling]";
		end the printing a heading activity;
	say roman type;
	let intermediate level be the visibility-holder of the actor;
	repeat with intermediate level count running from 2 to the visibility level count:
		if the intermediate level is a supporter or the intermediate level is an animal:
			say "[text of the room description heading rule response (B)]" (B);
[			say " (on [the intermediate level])" (B);]
		otherwise:
			say "[text of the room description heading rule response (C)]" (C);
[			say " (in [the intermediate level])" (C);]
		let the intermediate level be the visibility-holder of the intermediate level;
	if the reacting after undoing activity is going on:
		stop the action; [We only print the room name after "undo", we don't print the rest]
	say line break;
	say run paragraph on with special look spacing.

Section 2 - Titled Rooms

[We have to convince the upcoming code that title is a property!]
A titled room is a kind of room.
A titled room has some text called title.

Section 3 - Default Rule

[This is the default rule: use title case, or title property if present.  It can be overridden, and the examples do so.]
[This *must absolutely* appear before the status line rules, or there is a stack overflow at runtime!]

Rule for printing the name of an object (called item) while printing a heading:
	if the item provides the property title:
		say title of item;
	otherwise:
		[Note that we can't use "[item]" because that will call *this* rule again.]
		let title be the printed name of the item in title case;
		say title. 

Section 4 - Status Line Fix

[The status line has to be handled separately, sadly.  This is the obvious technique:

Before constructing the status line:
	begin the printing a heading activity.
After constructing the status line:
	end the printing a heading activity.

But the obvious technique generates run-time problem P13.  So we do it differently.
Note that this code must be included AFTER the default rule, or there is a stack overflow at runtime!
]

Rule for printing the name of an object (called item) while constructing the status line:
	begin the printing a heading activity;
	carry out the printing the name activity with the item;
	end the printing a heading activity.

Section 5 - Undo Fix

[ Oh, good grief.  We have to dig into Inform 6 again.
UNDO calls SL_Location in order to print its location.  We have to get a hook into the code in the parser
in order to wrap it.  We use Undo Output Control to get the hooks. ]

[Want to print the room name before the "undo succeeded" response.]
The report room after undo rule is listed before the report undo successful rule in the report undoing an action rules.
A report undoing an action rule (this is the report room after undo rule):
	begin the reacting after undoing activity;
	try looking;
	end the reacting after undoing activity;

[Must be before the "default report undoing an action rule", which fails.]
The report undo successful rule is listed in the report undoing an action rules.
A report undoing an action rule (this is the report undo successful rule):
	say "[text of the immediately undo rule response (E)][line break]";
	rule succeeds.

Volume 2 - Disabling Undo Fix when substructure unavailable

Book - first implementation check (for use without Undo Output Control by Erik Temple)

Part - second implementation check (for use without Undo Output Control by Nathanael Nerode)

Section 5 - No Undo Fix (in place of Section 5 - Undo Fix in Title Case for Headings by Nathanael Nerode)

[required to avoid compilation error in 6M62 -- not needed in Inform v10 !  Yay!]
[ dummy_variable_97538642 is a truth state which varies. ]


Title Case for Headings ends here.

---- DOCUMENTATION ----

Section - The Problem

It is traditional to give rooms titlecased names, like "The Meadow".  However, it is also often desirable to put a room into scope.  This may be done so that people can say "look at the meadow", or so that people can look at faraway rooms.  When the room is in scope, or for other reasons, the room name may be printed in various other contexts, including some of the responses in the Standard Rules.  And often we don't want those to be titlecase.

For instance, if you try this, the title in the status line and room description heading will be "Meadow"; but 'take meadow' will print "You would have to get out of the Meadow first."

	*: "Too Much Uppercase"

	The Meadow is a room.  "This is a meadow."

	After deciding the scope of an object (called character):
		Place the location of the character in scope, but not its contents.

And if you try this, 'take meadow' will print "You would have to get out of the meadow first", but the title in the status line and room description heading will be "meadow".

	*: "too much lowercase"

	a meadow is a room.  "This is a meadow."

	After deciding the scope of an object (called character):
		Place the location of the character in scope, but not its contents.

	test case with "take meadow / look"

When you start having rooms with possessive names like "John's Hotel Room", it gets even more complicated. You probably want it to be called "the hotel room" in text but "John's Hotel Room" in the status line and headings.

Section - The Solution

This extension will convert names like "babbling brook" to "Babbling Brook" (or "box" to "Box", etc.) for the heading at the
top of the room description, and for the status line, but otherwise keep them in lowercase.  So we will see:
	Babbling Brook
	This is a location.
	> take brook
	You would have to get out of the babbling brook first.

The example Meadow does this.

In addition, if a room or other object has the property "title", that will be used for the headings instead.  The type "titled room" is provided as a kind of room with a "title" property, but you can also give other kinds a "title" property if you want to.

The examples The Meadow and Near the Pond do this.

Section - Advanced Solution - the printing a heading activity

This extension also introduces the "printing a heading" activity.

Printing a heading is active when  printing the room name at the top of a room description.  It is not active when printing the name of a dark room, which has its own "printing the name of a dark room" activity.

Printing a heading is also active when printing the name of a thing at the top of the visibility threshold.  For instance, if you're inside a closed opaque box, the heading should read:
	Box
But it is not active when printing the name of a container which is not at the top level, so that you will get:
	Green Room (in the box)

Printing a heading is also active when printing a name for the status line.  (This does not normally have parenthetical expressions on it so I did not special-case them.)

By default, printing a heading will apply title case to the printed name of the object (See "Meadow".)  If the object has a "title" property, it will instead print that.  (See "The Meadow" and "Near the Pond".)  But it can be overridden to print whatever you want.

The example "People's Rooms" implements a complex naming scheme involving possessives, which change depending on who the player character is.

Section - Making it work right with "Undo" - Include Undo Output Control

There is one annoying corner case.  When "undo" is successfully executed, the room name is printed as a heading.  For this extension to process this heading correctly, it is necessary to:

	Include Undo Output Control by Nathanael Nerode.

The newest version of Undo Output Control is on the "Friends of I7" extension page on Github.  I updated it specifically so that I could fix this bug.
If you have trouble including Undo Output Control, you may just be willing to live with the bug.

Section - Changelog

	2.0.220529: Remove documentation section numbers to allow for automated numbering
	2.0.220527: Revise examples to work with automated testing of examples
	2.0.220524: Reformat Changelog
	2.0.220522: Correct a version number SNAFU
	1.2.220522: Example bugfix, remove unnecessary dummy variable, add Changelog
	1.2.220521: Proper update to Inform v10
	1.2: Partial update to Inform v10
	1/170902: Version for inform 6M62

Section 6 - Examples

Example: * Meadow - The title is Meadow, the name is meadow

The title in the status line and room description will be "Meadow".
'take meadow' will print "You would have to get out of the meadow first."

	*: "Meadow"

	Include Undo Output Control by Nathanael Nerode.
	Include Title Case for Headings by Nathanael Nerode.

	A meadow is a room.  "This is a meadow."

	After deciding the scope of an object (called character):
	Place the location of the character in scope, but not its contents.

	test case with "take meadow / look / undo"

Example: * The Meadow - But we want the title to be *The* Meadow.

The title in the status line and room description will be "The Meadow".
'take meadow' will still print "You would have to get out of the meadow first."

	*: "The Meadow"

	Include Undo Output Control by Nathanael Nerode.
	Include Title Case for Headings by Nathanael Nerode.

	A meadow is a titled room.  "This is a meadow."
	The title of the meadow is "The Meadow".

	After deciding the scope of an object (called character):
		Place the location of the character in scope, but not its contents.

	test case with "take meadow / look / undo"

Example: ** Around the Pond - A more complex example

Pond rooms will have titles like "South of the Pond", which confuses Inform 7.  We have four rooms which should be called the
same name when printed in ordinary sentences, which also confuses Inform 7.  Accordingly they're privately-named and we handle
names manually.

	*: "Around the Pond"

	The story author is "Nathanael Nerode".
	The release number is 2.
	Include Undo Output Control by Nathanael Nerode.
	Include Title Case for Headings by Nathanael Nerode.
	
	After deciding the scope of an object (called character):
		Place the location of the character in scope, but not its contents.

	A pond room is a kind of room.
	A pond room is always privately-named.
	A pond room is always improper-named.
	The printed name of a pond room is usually "grassy verge".

	A pond room has some text called title.

	Pond-Center is a pond room.
	The printed name of Pond-Center is "pond".
	The title of Pond-Center is "The Pond".
	The description of Pond-Center is "The pond is still and calm.".
	Understand "pond" as Pond-Center.
	Instead of going to Pond-Center, say "[We]['re] not dressed for swimming."

	After deciding the scope of an object (called character):
		if the location of the character is a pond room:
			Place Pond-Center in scope, but not its contents.

	Pond-N, Pond-S, Pond-E, and Pond-W are pond rooms.
	The title of Pond-N is "North of the Pond".
	The title of Pond-S is "South of the Pond".
	The title of Pond-E is "East of the Pond".
	The title of Pond-W is "West of the Pond".

	The description of Pond-N is "This is the grassy verge north of the pond."
	The description of Pond-S is "This is the grassy verge south of the pond."
	The description of Pond-E is "This is the grassy verge east of the pond."
	The description of Pond-W is "This is the grassy verge west of the pond."

	Understand "verge","grassy verge", "grassy", and "grass" as Pond-N.
	Understand "verge","grassy verge", "grassy", and "grass" as Pond-S.
	Understand "verge","grassy verge", "grassy", and "grass" as Pond-E.
	Understand "verge","grassy verge", "grassy", and "grass" as Pond-W.

	Pond-N is northeast of Pond-W.
	Pond-S is southeast of Pond-W.
	Pond-N is northwest of Pond-E.
	Pond-S is southwest of Pond-E.

	Pond-N is north of the Pond-Center.
	Pond-S is south of the Pond-Center.
	Pond-E is east of the Pond-Center.
	Pond-W is west of the Pond-Center.
	
	The player is in Pond-N.
	
	test descriptions with "x verge / x pond / take grass / take pond"
	
Example: **** People's Rooms - Rooms with possessive names

This example lets you play the game as John or Alice, using an initial Pick Identity scene.  After picking an identity at the start of the game, the default "yourself" object is removed.  The text substitutions adjust the printed names and titles of the dorm rooms to match (so one of them is "Your Dorm Room" and the other is "Alice's Dorm Room" or "John's Dorm Room".  

There is one really tricky bit.  The Standard Rules will not list an item in the room description if it believes the item has been mentioned already.  Using the possessive form of John in the title of the room causes it to be marked as mentioned, so it must be unmentioned before the room description is printed -- or else John will turn invisible when in his own room.

In the Pick Identity scene, it is necessary to run the scene checking rules manually to trigger the scene change at the right time.  The initial room description must be deferred until after the identity is chosen, as well.

Note the careful attention to capitalization in the descriptions.  The title case in the headings, however, happens automatically.

Test this by looking at all the rooms as John, and then by looking at all the rooms as Alice.

	*:  "People's Rooms"

	The story author is "Nathanael Nerode".
	The release number is 2.
	Include Undo Output Control by Nathanael Nerode.
	Include Title Case for Headings by Nathanael Nerode.

	[This is critically important -- otherwise Alice will disappear from the listing in Alice's room]
	To say unmention (item - a thing):
		now item is not mentioned;

	Pick Identity is a scene.
	Pick Identity begins when play begins.
	Pick Identity ends when the player is not yourself.

	When Pick Identity begins:
		now the command prompt is "Would you like to play as John or Alice? >".
	
	[Don't print the room description until we know who we are.]
	The initial room description rule is not listed in the startup rulebook.

	[The player starts as "yourself"; we delete this after picking identity.]
	After reading a command when Pick Identity is happening:
		if the player's command matches "Alice":
			now the player is Alice;
			[If the player's command is rejected the scene will not change automatically.]
			follow the scene changing rules;
		otherwise if the player's command matches "John":
			now the player is John;
			[If the player's command is rejected the scene will not change automatically.]
			follow the scene changing rules;
		otherwise:
			say "I didn't understand that.  Please type 'Alice' or 'John'.";
		reject the player's command. [Don't run command through normal parser]
	
	When Pick Identity ends: 
		now the command prompt is ">";
		now yourself is nowhere;
		say line break;
		try looking.
	
	To say (T - a text) capitalized/capitalised:
		let temp be T;
		replace the regular expression "^(\w)" in T with "\u1";
		say T;
	
	To say (O - an object) capitalized/capitalised:
		let temp be "[O]";
		say temp capitalized;
	
	Dormitory Hallway is a room.  "This is the hallway of the dormitory.  [Dorm room 1 capitalized] is to the west and [dorm room 2] is to the east."
	
	A dorm room is a kind of room. 
	Occupancy relates various dorm rooms to one person (called the occupant).
	The verb to be occupied by means the occupancy relation.
	The verb to occupy means the reversed occupancy relation.
	Dorm room 1 is occupied by John.
	Dorm room 2 is occupied by Alice.

	Rule for printing the name of a dorm room (called item) while printing a heading:
		say "[regarding the occupant of item][Possessive] Dorm Room[unmention the occupant]".
	Rule for printing the name of a dorm room (called item):
		say "[regarding the occupant of item][possessive] dorm room[unmention the occupant]".

	Dorm room 1 is a dorm room.
	Dorm room 1 is west of hallway.
	The description of dorm room 1 is "[We]['re] in [dorm room 1].  [We] [can] leave to the east."
	
	Dorm room 2 is a dorm room. 
	Dorm room 2 is east of hallway.  
	The description of dorm room 2 is "[We]['re] in [dorm room 2]. [We] [can] leave to the west."

	John is a man.  
	The description of John is "[John] [look] no different from last time you saw [them]."
	John is in dorm room 1.
	Persuasion rule for asking John to try going: persuasion succeeds.

	Alice is a woman.
	The description of Alice is "[Alice] [look] no different from last time you saw [them]."
	Alice is in dorm room 2.
	Persuasion rule for asking Alice to try going: persuasion succeeds.
