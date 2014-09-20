Version 2/140823 of Exit Lister by Leonardo Boselli begins here.

"Based on Exit Lister by Eric Eve and Exit Descriptions by Matthew Fletcher. Appends a list of exit directions and names any previously visited rooms at the end of a room description and adds a list of available directions to the status line."


Show exit descriptions is a truth state that varies. Show exit descriptions is false.

Section 1 - Apparent

A door can be apparent. A door is usually apparent.
A room can be apparent. A room is usually apparent.

Section 2 - Dark Stuff

dark-exits-invisible is a truth state that varies. dark-exits-invisible is false.

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


Section 3 - Looking Exits

Looking exits is an activity.

For looking exits (this is the looking exits rule):
	if show exit descriptions is false:
		rule fails;
	let amount be 0;
	repeat with dir running through directions:
		let farplace be the room dir from the location;
		let direction-object be the room-or-door dir from the location;
		if the direction-object is apparent and farplace is not darkness-occluded:
			increment amount;
	let num be 0;
	repeat with dir running through directions:
		let farplace be the room dir from the location;   
		let direction-object be the room-or-door dir from the location;
		if direction-object is apparent and farplace is not darkness-occluded:
			if num is 0:
				say "From [here] [we] [can] go" (A);
			say " [dir]" (B);
			if the direction-object is a closed door or the farplace is not visited:
				say " through [the direction-object]" (C);
			if the farplace is visited:
				say " towards [the farplace]" (D);
			decrement amount;
			increment num;
			if amount is 0:
				say ".";
			otherwise if amount is 1:
				say " and" (E);
			otherwise:
				say ",";

First after looking:
	carry out the looking exits activity;
	continue the action.

Section 4 - Status Bar

The status exit table is a table-name that varies. The status exit table is the Table of Beginning Status.

Table of Beginning Status
left	central	right
""	"[story title]"	"" 
""	"by"	"" 
""	"[story author]"	"" 

Table of No Exits Status
left		central				right 
" [if map region of the location is not nothing][map region of the location] - [end if][if in darkness]in darkness[otherwise][location][end if]"	"| Score: [score]/[maximum score]"	"| Steps: [turn count] | Rooms: [number of visited rooms]/[number of rooms]" 

Table of Exits Status
left	central				right 
" Score: [score]/[maximum score]"	"| Steps: [turn count]"	"| Rooms: [number of visited rooms]/[number of rooms]" 
" [if map region of the location is not nothing][map region of the location] - [end if][if in darkness]in darkness[otherwise][location][end if]"	""	"| [exit list]" 

The standard status line rule is not listed in any rulebook.
Rule for constructing the status line (this is the automap exits status line rule):
	if exit listing is true:
		fill status bar with status exit table and map;
	otherwise:
		fill status bar with the standard status table and map;
	rule succeeds.

Instead of going nowhere (this is the going nowhere replacement rule):
	say "[We] [can't] go in that direction." (A);
	carry out the looking exits activity.

First when play begins:
	now standard status table is Table of No Exits Status;
	now status exit table is Table of No Exits Status;
	now right alignment depth is 30.

To say exit list:
	carry out the exits listing activity.

Exits listing is an activity.
For exits listing (this is the exits listing rule):
	let exits count be 0;
	let farplace be location;   
	say "Exits: " (A);
	repeat with way running through directions:
		let farplace be the room way from the location;
		let direction-object be the room-or-door way from the location;
		if direction-object is apparent and farplace is not darkness-occluded:
			increase the exits count by 1;      
			if farplace is unvisited:
				say "[unvisited way] ";
			otherwise:
				say "[visited way] ";          
	if exits count is 0:
		say "None" (B);
 
Section H (for use with Hyperlink Interface by Leonardo Boselli)

to say unvisited (way - a direction):
	let cap-way be "[way]";
	say "[d][cap-way in upper case][x]".

to say visited (way - a direction):
	say "[d][way][x]".

Section K (for use without Hyperlink Interface by Leonardo Boselli)

to say unvisited (way - a direction):
	let cap-way be "[way]";
	say "[cap-way in upper case]".

to say visited (way - a direction):
	say "[way]".

Section - Commands

Understand the command "exits" as something new.

Exit listing is a truth state that varies. Exit listing is true.

ExitStopping is an action out of world.

Carry out ExitStopping (this is the standard exit stopping rule):
	now exit listing is false.

Report ExitStopping (this is the report exit stopping rule):
	clear only the status line;
	say "Exit listing is now off." (A).

Understand "exits off" as ExitStopping.

ExitStarting is an action out of world.

Carry out ExitStarting (this is the standard exit starting rule):
	now exit listing is true.

Report ExitStarting (this is the report exit starting rule):
	say "Exit listing is now on." (A);
  
Understand "exits on" as ExitStarting.

ExitListing is an action out of world.

Understand "exits" as ExitListing.

Carry out ExitListing (this is the standard carry out exit listing rule):
	carry out the looking exits activity.

listing explained is a truth state that varies. listing explained is false.

Section H (for use with Hyperlink Interface by Leonardo Boselli)
  
Report ExitListing when listing explained is false (this is the explain exit listing rule):
  now listing explained is true;
  say "(Use [t]EXITS ON[x] to enable the status line exit lister and [t]EXITS OFF[x] to turn it off.)" (A).  
	
Section K (for use without Hyperlink Interface by Leonardo Boselli)

Report ExitListing when listing explained is false (this is the explain exit listing rule):
  now listing explained is true;
  say "(Use EXITS ON to enable the status line exit lister and EXITS OFF to turn it off.)" (A).


Exit Lister ends here.

---- DOCUMENTATION ----

No documentation yet.
