Version 7 of Adaptive Hints by Eric Eve begins here.

"An adaptive hint system based on Menus by Emily Short."

Include Menus by Emily Short.

Part 1 - Activation and Deactivation

To activate (hintname - a table-name):
if the hintname is a subtable listed in the Table of Potential Hints
begin;
  let h_title be the title entry; 
  blank out the whole row;
  choose a blank row in the Table of Active Hints;
  now title entry is h_title;
  now subtable entry is hintname;
  now toggle entry is the hint toggle rule;  
end if.

To deactivate (hintname - a table-name):
if the hintname is a subtable listed in Table of Potential Hints
   begin;
      blank out the whole row;
   otherwise;
   if the hintname is a subtable listed in the Table of Active Hints begin;
      blank out the whole row;
      compact the Table of Active Hints;
   end if;
end if.

Part 2 - Compacting


[ The following is needed due to a bug in the sort order of blank rows in the current I7 compiler]

To compact (hints - table-name):
 if the number of blank rows in hints > 0 or the number of filled rows in hints > 0
 begin;
  let first blank be 0;
  let last filled be 0;
  repeat with N running from 1 to the number of rows in hints
     begin;
         choose row N in hints;
         if there is a title entry
         begin;
            now last filled is N;
         otherwise;
            if first blank is 0, now first blank is N;
         end if;
     end repeat;
     if first blank < last filled
     begin;
       choose row last filled in hints;
       let t_title be the title entry;
       let t_subtable be the subtable entry;       
       blank out the whole row;
       choose row first blank in hints;
       now the title entry is t_title;
       now the subtable entry is t_subtable;
       now the toggle entry is hint toggle rule;
     end if;
end if.

Part 3 - Activation and Deactivation Rulebooks

The hint activation rules is a rulebook.

The first hint activation rule:
  if the number of filled rows in the Table of Potential Hints is 0, the rule fails.

The hint deactivation rules is a rulebook.

[ The following last hint deactivation rule could be used in place of compacting the table,
  if only sorting a table left all the blank rows at the end. ]

[The last hint deactivation rule:  
 Sort the Table of Active Hints in title order. ]

Part 4 - Requesting Hints

Asking for hints is an action out of world.

Understand the command "hint" as something new.
Understand the command "hints" as something new.

Understand "hint" or "hints" as asking for hints.

This is the display hints rule:
     follow the hint activation rules;
     follow the hint deactivation rules;
     if the number of filled rows in the Table of Active Hints is 0
     begin;
        say "Sorry, no hints are available at this time." (A);
        rule fails;
     end if;
     now the current menu is the Table of Active Hints; 
     now the current menu selection is 1;     
     carry out the displaying activity;
    

Carry out asking for hints (this is the carry out displaying hints rule):
   abide by the display hints rule;
   clear the screen;   
   say "[paragraph break][paragraph break]";
   try looking.

Check asking for hints for the first time (this is the first time hinting rule):
  say "Some players may find the temptation to rely on hints overwhelming, and you may prefer to remove temptation by disabling hints for the rest of this game. If you do so, however, you will not be able to access the hints unless you restart. Do you wish to disable hints? >>" (A);
      if player consents,  silently try disabling hints;
      otherwise say "Okay - but if you change your mind later you can use the HINTS OFF command to disable hints." (B).

Check asking for hints (this is the block disallowed hints rule):
  if hint access is disallowed,  say "Hints have been disabled. The only way you can access hints now is by restarting."  (A) instead.
      
To disallow hints:   
   now hint access is disallowed.   

disabling hints is an action out of world.

Understand "hints off" or "hint off" as disabling hints.   

Check disabling hints (this is the query disabling hints rule):
  say "If you disable hints now, you will not be able to access hints again unless you restart. Are you sure you wish to disable hints for the remainder of this game? >>" (A);
  if player consents,  do nothing;  
  otherwise say "[line break]Okay, you can carry on using hints for now." (B) instead.   
     
Carry out disabling hints (this is the hint disabling rule):
  disallow hints.  
  
Report disabling hints (this is the standard report disabling rule):
  say "[line break]Hints are now disabled for this game. The only way you can regain access to hints from now on is by restarting." (A).

A permission is a kind of value. The permissions are allowed and disallowed.
Hint access is a permission that varies. Hint access is allowed.  

Table of Active Hints 
title (text)	subtable(table-name)		description (text)	toggle (a rule)
with 20 blank rows

Table of Potential Hints 
title (text)			subtable (table-name)
with 20 blank rows


Adaptive Hints ends here.

---- DOCUMENTATION ----

Emily Short's Menus extension includes a mechanism for showing hints, but provides only for static hint menus. In many cases we may want our hint system to adapt to the situation in the game, showing only those hints that are currently relevant.

For example, it may be premature to display a series of hints on "How do I extract the golden egg from the glass goose?" until the player knows that there are such objects as the golden egg and the glass goose. Conversely there is no point in continuing to display this hint once the player has solved the golden egg puzzle. The Adaptive Hints extension builds on Emily Short's Menus extension to allow the author to activate and deactivate hints as appropriate.

To set up a system of adaptive hints, we first need to supply a table of hints for each hint topic, as in the Tabulation example that comes with the Menus extension. For example we might create hint tables like:

	Table of Golden Egg Hints
	hint															used
	"How might you get an object out of a closed glass container?"	a number
	"You can't just smash the glass goose, because you might never get it back together again,
	and Professor Gosling asked you to bring it back in one piece."
	"Maybe you could cut the glass with something?"
	"It would have to be something sharp and hard."
	"Have you wondered what you might do with that diamond?"
	
Then, to use the Adaptative Hints extension, we need to define a pair of table continuations to contain, first the hints that are going to come into play later in our game, and second, the currently active hints. The first of these tables must be called "The Table of Potential Hints (continued)" and contains just two columns, "title" and "subtable":

	Table of Potential Hints (continued)
	title													subtable
	"How do I extract the golden egg from the glass goose?"	Table of Golden Egg Hints
	"How do I unlock the lead door?"						Table of Lead Door Hints
	"How do I get past the deranged ostrich?"				Table of Ostrich Hints
	
The second table, "The Table of Active Hints", is defined in the extension, and allows for up to twenty hints to be active at once. If we need more than this we can define a continuation table, which must be called "The Table of Active Hints (continued)" and must contain four columns: "title", "subtable", "description", "toggle". This table must contain enough blank rows to accommodate the maximum number of hints that may be active at any one time. For example, if we think that we may have a maximum of thirty hints active at some point in our game, we shall need to define a continuation table with an extra 10 rows:

	Table of Active Hints (continued)
	title	subtable		description	toggle
	text	table-name		text		a rule
	with 10 blank rows

On the other hand, if we are sure there will never be more than twenty hints active at once, we need not define this continuation table at all.	
	
We next need some mechanism for activating and deactivating hints as required. To this end we can simply use "activate {Table Name}" or "deactivate {Table Name}" as required; for example:

	activate the Table of Golden Egg Hints.
	deactivate the Table of Ostrich Hints.
	
The first phrase moves the Table of Golden Egg Hints row from the Table of Potential Hints to the Table of Active Hints, and automatically fills in the toggle column with the appropriate hint toggle rule. The second simply blanks out the row corresponding to the specified table name from either the Table of Active Hints or the Table of Potential Hints (depending which table the row currently resides in). If there is no row containing the table name, then the deactivate phrase will have no effect. Once a hint has been deactivated it is therefore no longer available to be reactivated, since it will almost certainly not be needed again. If for any reason we did need to reactivate a hint we could always choose a blank row in either the Table of Active Hints or the Table of Potential Hints and fill in the appropriate columns; e.g.:

	To reinstate (hint table - a table-name) with (hint title - text):
	  choose a blank row in the Table of Potential Hints;
	  now the title entry is hint title;
	  now the subtable entry is hint table.
	  
Activate and deactivate may be used at any convenient place in our code; for example, to make a hint available from the start of the game we might write:

	When play begins: activate the Table of Fruit Basket Hints.
	
During play, it may be more convenient to watch for conditions that require hints to be activated or deactivated rather than adding activate and deactivate phrases to action responses. To this end the Adaptive Hints extension supplies a pair of rulebooks called the hint activation rules and the hint deactivation rules. These are consulted just before the current set of hints is displayed. The hint activation rules are consulted before the hint deactivation rules to ensure that obsolete rules are cleared out even if they have only just become active. To use these rules we might, for example, write:

	A hint activation rule: 
		if the Goose Vault is visited, activate the Table of Golden Egg Hints.
		
	A hint deactivation rule:
		if the golden egg is handled, deactivate the Table of Golden Egg Hints.
		
Note that these rulebooks are only consulted when the player asks for hints, since there is no need to bring the list of active hints up to date until the player wants to view it.

Finally, we need a way of displaying hints. This is achieved by invoking the display hints rule, which is what the asking for hints action provided in the Adaptive Hints extension does. The extension defines HINT and HINTS as the commands to display hints. It does not make HELP a synonym for HINTS since some authors may prefer to use HELP for other purposes (e.g. as a synonym for ABOUT or to display a general help menu rather than specific hints). If you want HELP to be a synonym for HINTS you can, of course, simply define:

	Understand "help" as asking for hints.

The first time the HINTS command is used the player is given the option of disabling hints altogether. Hints can also be disabled subsequently using the HINTS OFF command. The extension does not provide a HINTS ON command to reverse this process, since this would defeat the object of allowing players to disable hints in the first place.		
	
NOTE: Both this extension and Basic Help Menu by Emily Short define responses to the commands HINT and HINTS. To avoid a clash when you use both extensions, please include Adaptive Hints AFTER Basic Help Menu in your code: Adaptive Hints explicitly defines the commands "hint" and "hints" as something new before assigning them to its own asking for hints action.
	
Example: ** Escape from an Old House - A short game with several adaptive hints

	*: "Escape from an Old House" by Eric Eve

	Include Adaptive Hints by Eric Eve.
	Use scoring.

	Part 1 - Hint Tables

	Table of Potential Hints (continued)
	title	subtable	
	"What should I do now?"	Table of General Hints	
	"What can I do in the Hall?"	Table of Hall Hints
	"What should I do in the Lounge?"	Table of Lounge Hints	
	"How do I open the front door?"	Table of Front Door Hints
	"How do I unlock the tall cabinet?"	Table of Cabinet Hints
	"How can I get through the window?"	Table of Window Hints
	"How do I unlock the front door?"	Table of Iron Key Hints

	Table of General Hints
	hint	used
	"Try exploring a bit."	a number
	"Then trying exploring a bit more."
	"Have you explored enough yet?"

	Table of Lounge Hints
	hint	used
	"Look around."
	"But frankly there's not much here."
	"Except that mouldy old carpet."

	Table of Hall Hints
	hint	used
	"Search it thoroughly."
	"What did you find?"
	"Perhaps that tall cabinet is worth investigating."

	Table of Cabinet Hints
	hint	used
	"Obviously, you need to find a key."
	"Maybe it's been dropped somewhere."
	"Somewhere not that obvious."
	"And maybe it slid under something."
	"Like a carpet."

	Table of Front Door Hints
	hint	used
	"Well, finding the key would be a start."
	"It may not be far from the front door"
	"Have you tried looking in the cabinet?"
	"What did you find there?"

	Table of Iron Key Hints
	hint	used
	"What did you find in the hall cabinet?"
	"How thoroughly have you examined it?"
	"Did it have a pocket?"
	"What was in the pocket?"


	Table of Window Hints
 	hint	used	
	"Forget it"
	"There's no way you're going to get through that window."


	A hint deactivation rule:
  	if the number of visited rooms is the number of rooms - 1, 
  	deactivate the Table of General Hints. 

	A hint deactivation rule:
  	If the tall cabinet has been open begin;
		deactivate the Table of Cabinet Hints;
		deactivate the Table of Hall Hints;
		deactivate the Table of Front Door Hints;
	end if.

	A hint deactivation rule:
	If the iron key is seen begin;
		deactivate the Table of Window Hints;
		deactivate the Table of Iron Key Hints;
  	end if.

	A hint deactivation rule:
	If the brass key is seen, deactivate the Table of Lounge Hints.

	A hint activation rule:
	if the lounge is visited, activate the Table of Lounge Hints.

	A hint activation rule:
	If the hall is visited, activate the Table of Hall Hints.

	A hint activation rule:
	If the window is seen, activate the Table of Window Hints.

	A hint activation rule:
	If the tall cabinet has been open,
		activate the Table of Iron Key Hints.

	Part 2 - Game World

	Chapter 1 - Setup

	Use full-length room descriptions.
	When play begins: activate the Table of General Hints.

	After printing the banner text when the turn count is 1:
	say "[line break]You woke up this morning to find yourself trapped in this creepy old house. Now you just want to get out."

	Every thing is either seen or unseen. A thing is usually unseen.

	Before printing the name of a thing (called the item):
	Now the item is seen.

	Carry out examining something (called the item):
	Now the item is seen.

	The maximum score is 4.

	Chapter 2 - The Map

	Section 1 - The Drawing Room

	The Drawing Room is a room. "A window overlooks the drive to the north, but unfortunately it is solidly barred and there seems to be no way to open it. But you could go south to the lounge or east to the hall."

	The barred window is scenery in the drawing room. The description is "You can see through it onto the drive, but there seems to be no way you could open it, and even if you could the bars would prevent your climbing through." Understand "bars" as the window.

	Instead of entering or opening the window:
  	now the window is seen;
	say "The bars prevent you."

	Instead of attacking the window: 
	now the window is seen;
	say "Beating your bare fists against the bars proves painful and unproductive."


	Section 2 - The Lounge

	The Lounge is a room. "A mouldy carpet covers most of the floor all the way up to the archway leading into the drawing room to the north."

	The mouldy carpet is scenery in the lounge. The description is "Worn and woven in muddy colours, this carpet was probably new when Horatio Nelson was still a midshipman."

	Instead of looking under the mouldy carpet for the first time:
	Now the brass key is carried by the player;
	increase score by 1;
	say "You turn up one corner of the carpet after another, and your fourth attempt you find a small brass key, which you duly take."

	Instead of looking under the mouldy carpet:
	say "You find nothing more but dust."

	The plain archway is a door. It is south of the Drawing Room and north of the Lounge. It is scenery, open and unopenable. The description is "Rather plain, it nevertheless just about serves to separate the drawing room and lounge into two separate areas."

	Section 3 - The Hall

	The Hall is east of the Drawing Room.
	"Large enough to count as pretentious, the hall stretches towards a heavy front door to the north. A broad staircase leads up to the first floor, while the drawing room lies to the west."

	The tall wooden cabinet is here. "A tall wooden cabinet stands proudly against the wall." The cabinet is a container. It is openable, closed, lockable, locked and fixed in place. The description is "You're no expert on antique furniture, but you'd judge this to be a regency piece." Understand "regency" or "antique" or "furniture" as the tall wooden cabinet.

	The small brass key unlocks the tall wooden cabinet.

	Before opening the tall wooden cabinet when the cabinet is locked:
	activate the Table of Cabinet Hints.

	The old trench coat is in the cabinet. "An old trench coat hangs in the cabinet". It is wearable. The description is "It looks battered enough to have been through the Battle of the Somme. It does have one pocket still intact however."

	The pocket is part of the coat. It is an unopenable open container. Understand "coat pocket" as the pocket.

	Instead of searching the coat, try searching the pocket.

	In the pocket is a large iron key. The description of the large iron key is "It looks just the job for unlocking a large, heavy door."

	The solid front door is a door. It is north of the hall and south of the drive. The description is "It's made of thick, solid oak. There's clearly going to be no way through it without opening it, and it's current [if open]open[otherwise]firmly closed[end if]." It is closed, scenery, lockable and locked. The large iron key unlocks the front door.

	Before opening the front door when the front door is locked:
	activate the Table of Front Door Hints.

	The drive is a room. After going to the drive:
	say "At last, you're out of that wretched house!";
  	increase score by 3;
  	end the story finally saying "You have won".

	The staircase is a door. The staircase is above the Hall and below the Landing. It is scenery, open and unopenable. Understand "stairs" as the staircase.

	Instead of climbing the staircase: try entering the staircase.

	Section  4 - The Landing

	The Landing is a room. "This long landing runs between many bedrooms, all of which you have searched thoroughly already. A staircase leads back down to the hall."

	Instead of going nowhere from the landing, say "You've already searched thoroughly up here, and in any case the only way out of this wretched house is surely downstairs."


	Chapter 3 - Testing
 
	test first with "Open window/break window/e/n/open door/climb the stairs/n/d/open the cabinet"

	test second with "w/s/look under the carpet/n/e/unlock the cabinet/open it/look in cabinet"

	test third with "take coat/wear it/x it/look in pocket/unlock door with iron key/open door/n"

	test me with "test first/test second/test third"

Note that although this test runs through the game to completion, it doesn't of itself demonstrate the hint system. For that you need to run through the game manually and try out the hints every few turns to see how they change.
