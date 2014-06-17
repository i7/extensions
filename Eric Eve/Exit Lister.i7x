Version 11 of Exit Lister by Eric Eve begins here.

"A status line exit-lister and an EXITS command, with optional colouring of unvisited exits. Selected rooms and doors can be optionally be excluded from the list of exits."

Chapter 1 - Exit Lister Includes

Include Basic Screen Effects by Emily Short.

Chapter 2 - Exit Lister Setup

Section 1 - Apparent

A room has a text called destination name. The destination name of a room is usually "".

A door can be apparent. A door is usually apparent.
A room can be apparent. A room is usually apparent.

Section 2 - Dark Stuff

dark-exits-invisible is a truth state that varies. dark-exits-invisible is true.

The light-meter is a privately-named scenery thing. 

Definition: a room (called the target room) is light-filled: 
    if the target room is lighted, decide yes; 
    move the light-meter to the target room; 
    if the light-meter can see a lit thing, decide yes; 
    remove the light-meter from play; 
    decide no. 


Definition: a room (called target-destination) is darkness-occluded: 
	if dark-exits-invisible is false, decide no;
	if not in darkness, decide no;	
	decide on whether or not target-destination is not light-filled.


Chapter 3 - Exit Lister Tables

The status exit table is a table-name that varies. 
The status exit table is the Table of Exit Status.

The standard status table is a table-name that varies. 
The standard status table is the Table of Standard Status.

Table of Exit Status
left	central	right
" [left hand status line]"	""	"[right hand status line]"
" [exit list]"	""	""

Table of Standard Status
left	central	right
" [left hand status line]"	""	"[right hand status line]"

Chapter 4 - Exit Lister Rules

Rule for constructing the status line (this is the exit lister status line rule):
   if exit listing is enabled,
     fill status bar with the status exit table;
   otherwise
     fill status bar with the standard status table;
   rule succeeds.

To say exit list:
  let exits count be 0;
  let farplace be location;   
  say "Exits: ";
  repeat with way running through directions
  begin;
    let farplace be the room way from the location;
    now direction-object is the room-or-door way from the location;
    if direction-object is apparent and farplace is not darkness-occluded
    begin;      
      increase the exits count by 1;      
      if farplace is unvisited and indicate-unvisited is show-unvisited,  say "[unvisited-mark][u-v way][end-unvisited-mark]";
      otherwise say "[way]";          
      say " ";
    end if;
  end repeat;
  if exits count is 0,
  say "[italic type][no-exits][roman type]".
 
To say no-exits: say "None".

Chapter 5 - Exit Lister Values

A listing_state is a kind of value. The listing_states are enabled and disabled.

Exit listing is a listing_state that varies. Exit Listing is enabled.

A visiting-mark is a kind of value. The visiting-marks are show-unvisited and dont-show-unvisited.

indicate-unvisited is a visiting-mark that varies.

indicate-unvisited is show-unvisited.

The direction-object is an object that varies.

Chapter 6 - Exit Lister Actions

Section 1 - ExitStarting and ExitStopping

ExitStarting is an action out of world.

ExitStopping is an action out of world.

Carry out ExitStopping (this is the standard Exit Stopping rule):
  now exit listing is disabled.
  

Report ExitStopping (this is the report exit stopping rule):
  clear only the status line;
  say "Exit listing is now off." (A).


Understand "exits off" as ExitStopping.

Understand "exits on" as ExitStarting.

Carry out ExitStarting (this is the standard Exit Starting rule):
  now exit listing is enabled.

Report ExitStarting (this is the report exit starting rule):
  say "Exit listing is now on." (A);
  
Section 2- ExitListing
  
ExitListing is an action out of world.

Understand "exits" as ExitListing.

Carry out ExitListing (this is the standard carry out exit listing rule):
  list the exits.

[ This is defined as a separate phrase so that it can be called from
  user code, e.g. to replace the standard "You can't go that way" message. ]  
  
To list the exits:
  let exits count be 0;
  let farplace be location;    
  repeat with way running through directions
  begin;
    let farplace be the room way from the location;
    now direction-object is the room-or-door way from the location;
    if the direction-object is apparent and farplace is not darkness-occluded, increase exits count by 1;
  end repeat;
  if exits count is 0
  begin;
    say "[no-obvious-exits]";
    rule fails;
  end if;
  let i be exits count;
  if exits count is 1, say "[only-obvious-exit] ";
  otherwise say "[obvious-exits] ";
  repeat with way running through directions
  begin;
    let farplace be the room way from the location;   
    now direction-object is the room-or-door way from the location;
    if direction-object is apparent and farplace is not darkness-occluded
    begin;
        say "[way]";
        if farplace is visited, say " ([to-preposition] [destname farplace])";       
        decrease i by 1;
        if i is 0, say ".";
        if i is 1, say " [and-conjunction] ";
        if i > 1, say ", ";       
    end if;   
  end repeat.

To say list the exits: list the exits. 
    
To say no-obvious-exits: say "There are no obvious exits."
To say only-obvious-exit: say "The only obvious exit is".
To say obvious-exits: say "The obvious exits are".
To say and-conjunction: say "and".
To say to-preposition: say "to".

Report ExitListing when listing explained is false (this is the explain exit listing rule):
  now listing explained is true;
  say "(Use EXITS ON to enable the status line exit lister and EXITS OFF to turn it
 off.)" (A).
  
To say destname (place - a room):
  if the destination name of place is "", say "[the place]" in lower case;
  otherwise say "[destination name of place]".
 
listing explained is a truth state that varies.  
  
Chapter 7 - Exit Lister Indicating Unvisited

exit colouring is an action out of world.
understand "exit colour/color" as exit colouring.

exit-colour-num is a number that varies.
exit-colour-num is 1.
exit-symbol-num is a number that varies.


exit symboling is an action out of world.

Understand "exit symbol" as exit symboling.

exit-marker is a text that varies.


Carry out exit symboling (this is the standard exit symboling rule):
  increase exit-symbol-num by 1;
  if exit-symbol-num > the number of rows in the Table of Exit Symbols,  now exit-symbol-num is 1;
  choose row exit-symbol-num in the Table of Exit Symbols;
  now exit-marker is the exit-symbol entry.

Report exit symboling:
  say "Done."


Table of Exit Symbols
exit-symbol
""
"="
"-"
"*"
"+"


Section 7G (for Glulx Only)

exit-symbol-num is 1.
exit-marker is "".

Carry out exit colouring (this is the standard exit colouring rule):
   now indicate-unvisited is the visiting-mark after indicate-unvisited.

to say unvisited-mark:
  say "[exit-marker]".

to say end-unvisited-mark:  
  say "[exit-marker]".

to say u-v (way - a direction):  
   let cap-way be "[way]";
   say "[cap-way in upper case] ".


Section 7Z (for Z-machine only)


Carry out exit colouring (this is the standard exit colouring rule):
  increase exit-colour-num by 1;
  if exit-colour-num > 4  begin;
    now exit-colour-num is 0;
    now indicate-unvisited is dont-show-unvisited;
 otherwise;
   now indicate-unvisited is show-unvisited;
 end if.

Report exit colouring (this is the default report exit colouring rule):
 say "Done." (A). 



to say unvisited-mark:
if exit-colour-num is 1 begin;
  turn the background red;
otherwise if exit-colour-num is 2;
  turn the background yellow;
otherwise if exit-colour-num is 3;
  turn the background blue;
otherwise;
  turn the background green;
end if;
say "[exit-marker]".

to say end-unvisited-mark:
  say "[exit-marker][default letters]".


exit-symbol-num is 1.
exit-marker is "".

to say u-v (way - a direction):
  say "[way]".


   
Exit Lister ends here.

---- DOCUMENTATION ----

Chapter: Basic Overview

Section: What's New

Version 10 of Exit Lister suppresses the listing of exits that lead from one dark room to another, although this behaviour can be changed by setting the global variable.dark-exits-invisible to false. For further details see the section on Listing or Hiding Exits in the Dark below.

Section: Status Line Exit Lister

This extension implements a status line exit lister similar to that provided as standard in TADS 3. The player can turn it on and off with the EXITS ON and EXITS OFF command. Its presence or absence may also be controlled programmatically by setting Exit Listing to enabled or disabled.

The extension also provides an EXITS command that lists the available exits, together with their destinations if these have been visited. The first time the EXITS command is used, the EXITS ON and EXITS OFF commands are explained.

Any room may optionally be given a destination name property. If we defined a destination room property for a room, it will be used in place of the printed name property when the room is shown as the destination of an exit in response to an EXITS command. This can result in better looking output, e.g.:

    The obvious exits are north to the garden and east to the path.
    
Instead of:

    The obvious exits are north to Garden and east to Path.  
    

Section: Alternative Status Lines

The table used to construct the status line when exit listing is on is held in the global variable status exit table. This allows us to use the exit lister with a different status line layout if we wish. For example, we might define:

	
	Table of New Exit Status
	left	central	right 
	" [left hand status line]"	""	"[right hand status line]" 
	" Explored: [number of visited rooms]/[number of rooms]"	""	"Turn count:[turn count]" 
	" [exit list]"	""	""

	
And we could then use this table instead of the one defined in this extension by using the command:

	now status exit table is Table of New Exit Status.


Section: Listing Exits Programmatically - A Smart Cant Go 

The available exits can be listed using the command:
	list the exits
	
This could be used to provide a "smart cant go" response, such as:

	*: Instead of going nowhere:
	     say "You can't go that way. ";
	     list the exits.	

You can also use "[list the exits]" as a to say phrase, for example:

	*: Instead of going nowhere:
	     say "You can't go that way. [list the exits]";


Chapter: Showing Unvisited Rooms

Section: The Standard Behaviour

In a Z-Code game, exits leading to an unvisited room can be indicated in a different colour. In a Glulx game they can be shown in capitals. In both Z-Code and Glulx games, they can be shown preceded and followed by a marker character (either =, -, + or *). By default, unvisited exits are shown in red in a Z-Code game and in capitals in a Glulx game. 

The command EXIT COLOUR or EXIT COLOR is provided to allow players to cycle through the options to find the one that best suits their interpreter and their preferences. In a Z-Code game the colours of unvisited exits will cycle between red, yellow, blue, green and none (i.e. the default colour, usually white). In a Glulx game unvisited exits will toggle between upper and lower case.

In both Z-Code and Glulx games the command EXIT SYMBOL can be used to cycle the symbols between =, -, *, + and none. This may be useful for a player using a Z-Code interpreter (such as Gargolye) that doesn't have the capability to change colours.


Section: Customization

By default this marking of unvisited exits is enabled at the start of a Z-Code game. If you do not want this you can disable it when play begins:

	When play begins:
	 	now  indicate-unvisited is dont-show-unvisited;

Conversely, you can enable this feature under programatic control with the command:

	 now indicate-unvisited is show-unvisited;

You can also change the colour (in Z-Code)  by changing the value of the exit-colour-num variable according to the following table: 

	Table
	exit-colour-num		Z-Code Colour	
	         1			red		
	         2			yellow		 
	         3			blue		
	         4			green		

Finally,  you can change the marker symbol to anything you like by changing the exit-marker variable; e.g.:

	now exit-marker is "?".

Of course, unless you disable the EXIT SYMBOL command, the player will still be able to change your choice of symbol.	

You can also extend the range of symbols on offer by continuing the Table of Exit Symbols, e.g.

	Table of Exit Symbols (continued)
	exit-symbol
	"!"
	"~"
	"¦"
	"%"



Chapter: Hiding or Showing Exits

Section: Apparent or Not Apparent

Doors can be apparent or not apparent. In some cases you may not want an exit shown in the exit lister because the player is not yet meant to know that an exit exists in that direction (for example, if a bookcase is in fact a secret door). In such a case you can declare the door through which the secret exit leads as not apparent. Once the player has discovered the secret exit you can make the door apparent, and then the exit will show up in the lister.

Rooms can also be apparent on not apparent. By default every room is apparent, but if for some reason we do not want the exits leading to a room to show up in the exit lister, we can make that room not apparent. If we want the same room to be apparent from some locations but not others, then we need to create some mechanism to switch the room between apparent and not apparent depending on the location of the player or other circumstances, perhaps in a before going or every turn rule, e.g.:

	Every turn:
		if the location is the Short Path, now the Sunken Garden is apparent;
		otherwise now the Sunken Garden is not apparent.

Section: Listing or Hiding Exits in the Dark

If the player character is in a dark room we may not want the player to see any of the exits leading to other unlit rooms: the Exit Lister could potentially give too much information away in cases where the game text is telling us "It is pitch darkness and you can't see a thing" but the Status Line Exit Lister (and the EXITS commands) nevertheless lists all the exits leading from this pitch dark location. By default Exit Lister therefore suppresses the listing of directions that would lead to unlit locations when the player character is in a darkness. In this context "unlit" means a room that is not only dark itself but also contains no visible light source.

To change this behaviour we can simply set the value of the truth state variable dark-exits-invisible to false. When dark-exits-invisible is false all exits are listed (provided they are apparent) regardless of the state of the lighting. This is illustrated further in Example B.

We might also want to prevent travel to an unlit room from a dark location on the grounds that the player character can't see where he's going. To do this we can take advantage of the fact that Exit Lister defines the adjective darkness-occluded to refer to unlit rooms adjacent to a room where the player character is in darkness. To prevent dark-to-dark travel without giving anything away we could thus use something like:

	*: Instead of going nowhere when in darkness: say can't see way in dark.
	Instead of going to a darkness-occluded room: say can't see way in dark.
	To say can't see way in dark: say "It's too dark to see where you're going."

This is also illustrated in Example B below.

Chapter: Customizing No Exit Messages

We can also customize what is displayed when there are no exits from a particular location. By default the status line exit lister will show "None" and the exits listed in response to an EXIT command will say "There are no obvious exits." We can change these if we like by providing our own definition of  the phrases:

	To say no-exits:
	To say no-obvious-exits:
	
For example:

	A room can be mapworthy or not mapworthy. A room is usually mapworthy.

	To say no-exits: 
	if the location is mapworthy, say "None";
	otherwise say "Unclear";

	To say no-obvious-exits:
	if the location is mapworthy, say "There are no obvious exits.";
	otherwise say "It's unclear where the exits are."

	
	
Example: * A Walk in the Woods - A brief exit lister example

	*: "A Walk in the Woods"

	Include Exit Lister by Eric Eve.

	Use full-length room descriptions.

	Instead of going nowhere:
		say "You can't go that way. ";
		list the exits.

	A fixture is a kind of thing. A fixture is usually scenery. A fixture is always fixed in place.

	A thing can be near or distant. A thing is usually near.

	Instead of doing anything except examining with a distant thing (called the remote), say "[The remote] is too far away."

	The Junction of Paths is a room. "Here the long north-south path running through the fields meets a narrow lane disappearing of into a dark wood to the east. A little way ahead to the north lies a low hill." The destination name is "the path junction".

	Instead of going south in the Junction of Paths, say "You've just come from there, and you don't fancy going back."

	The overgrown fields are a fixture in the Junction of Paths. The description is "They look rather overgrown - too overgrown to be readily walked over."

	The low hill is a distant fixture in the Junction of Paths. The description is "It's just a short way up ahead and doesn't look too difficult to climb."

	The dark wood is a distant fixture in the Junction of Paths. The description is "It looks pretty dense from here, but the lane running into it looks passable enough."

	Instead of entering the wood, try going east.

	Heart of the Wood is east of Junction of Paths. "Here the lane from the west forks to northeast and southeast." The destination name is "the heart of the wood".

	River Bank is southeast of Heart of the Wood. "The path from the northwest comes to the end on the bank of a broad river. You could walk along the bank to the north." The destination name is "the riverbank".

	The Clearing is north of River Bank and northeast of Heart of the Wood. "A river flows sluggishly through the middle of the clearing, while paths lead south along the river bank and southwest into the wood." The destination name is "the clearing".

	The sluggish river is a backdrop. The sluggish river is in the Clearing and the River Bank. The description is "It looks far too wide to cross." Understand "wide" as the river.

	The Hilltop is north of the Junction of Paths. "From the top of the hill you can see a long path running through the fields to the south. On the other side of the hill to the north is an evil-looking marsh." The destination name is "the top of the hill".

	Instead of going north in the Hilltop, say "You really don't like the look of that marsh to the north."

	The evil-looking marsh is a distant fixture in the Hilltop. The description is "You don't like the look of it at all - from where you stand there seems to be no safe way through."

	[Testing commands that aren't much use]

	Test me with "w/n/n/x marsh/s/x hill/s/w/e/exits/ne/s/s/nw/e/w".


You can run the above test, but it won't really show what's happening in the status line lister, so you might do better to enter the commands manually one at at a time.


Example: * Exploring the Dark - Hiding and Showing Dark Exits

	*: "Exploring the Dark"
	
	Include Exit Lister by Eric Eve.

	The Secluded Grove is a room. "You stand just outside the mouth of a dark cave to the east."

	The blazing torch is in the Secluded Grove. It is lit.

	The Dark Cave is east of Secluded Grove. 
	"The main exit is to the east. Other exits lead north and south."
	It is dark.

	Narrow Crawl is north of Dark Cave. "This seems to be a dead end. The only way out is back south." It is dark.

	Long Tunnel is south of Dark Cave. "The tunnel comes to a dead end. The only way out is back north." It is dark. 

	Instead of thinking:
		say "You have a [if dark-exits-invisible is true]bright[otherwise]dim[end if] idea, as a result of which you [if dark-exits-invisible is true]can[otherwise]can't[end if] now see darkened exits.";
		now dark-exits-invisible is whether or not dark-exits-invisible is false.
		
	Instead of going nowhere when in darkness: say can't see way in dark.

	Instead of going to a darkness-occluded room: say can't see way in dark.

	To say can't see way in dark: say "It's too dark to see where you're going."
		
There's little point including a "test me" script for this example, since it would run too fast for us to see the changes to the status line. We can try exploring the caves with or without the torch, and with or without issuing a THINK command to see the effect.