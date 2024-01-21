Version 1.2 of Menus by Dannii Willis begins here.

"Display full-screen menus defined by tables"

Use authorial modesty.

Part - Included Extensions

Include Basic Screen Effects by Emily Short.



Part - Tables

[ Define the column types for Menus. The old column names will still work. ]

Table of Menu column definitions
title	text	description	submenu	subtable	rule	toggle	hidden-row
""	""	""	a table-name	a table-name	a rule	a rule	a truth state

[ These tables define how the status bar is shown in menus ]

Table of Shallow Menu Status
left	central	right
""	"[current menu title]"	""

Table of Deep Menu Status
left	central	right
""	"[current menu title]"	""
""	""	""
" Select a number"	""	"Esc/Q = Back "

[ This table stores the history of menus considered. Essentially we push/pop to it. ]

Table of Menu history
title (text)	submenu (table-name)
with 10 blank rows



Part - Menus [Variables]

The current menu is a table-name variable. The current menu is Table of Menu column definitions.
The current menu title is a text variable. The current menu title is "Instructions".

Section - unindexed

Menu header is a table-name variable. The menu header is Table of Deep Menu Status.

Menu depth is a number variable. Menu depth is 0.


Part - Menu labels

[ This Part can be replaced to allow more/different labels to be printed and accepted ]

[ We support 1-9 and A-P by default. This phrase is for your code to check - the extension does not use it. ]
To decide which number is the maximum number of menu labels:
	decide on 25;

Section - unindexed

To say menu character number (x - a number):
	(- print (char) ({x} + 55); -).

To say menu label (x - a number):
	if x < 10:
		say x;
	otherwise:
		say menu character number x;

[ For use with glulx hyperlinks ]
To decide what number is the character number for menu label (x - a number):
	if x is -1:
		decide on 81;
	if x < 10:
		decide on x + 48;
	otherwise:
		decide on x + 55;

[ -1 = Go back, 0 = invalid, 1+ = menu choice (but the menu must be checked to see if the row even exists!) ]
To decide what number is the chosen menu option for (x - a number):
	[ Esc/Q ]
	if x is -8 or x is 27 or x is 81 or x is 113:
		decide on -1;
	if x > 48 and x < 58:
		decide on x - 48;
	if x > 64 and x < 81:
		decide on x - 55;
	if x > 96 and x < 113:
		decide on x - 87;
	decide on 0;

To request a key press:
	say "[italic type]Press a key to go back.[roman type][run paragraph on]";



Part - Displaying a menu

Displaying is an activity.

[ The entering and exiting rules can be used to alter menu tables, which can be useful for options menus ]
The entering a menu rules are a table-name based rulebook.
The displaying a menu rules are a rulebook.
The exiting a menu rules are a table-name based rulebook.

To display the/-- (t - a table-name) menu with title (x - text):
	blank out the whole of Table of Menu history;
	choose row 1 in Table of Menu history;
	now the title entry is x;
	now the submenu entry is t;
	carry out the displaying activity;

[ Support the old Menus way of running the displaying activity directly ]
First before displaying rule (this is the fix the Table of Menu history rule):
	choose row 1 in Table of Menu history;
	if there is no title entry or the title entry is "":
		now the title entry is the current menu title;
		now the submenu entry is the current menu;
	now menu depth is the number of filled rows in Table of Menu history;

Before displaying (this is the run the entering a menu rules rule):
	follow the entering a menu rules for the submenu in row 1 of the Table of Menu history;

Rule for displaying (this is the display a menu rule):
	while menu depth > 0:
		follow the displaying a menu rules;

[ Authors may use this phrase to show a single page, so we need to take care of the before/after displaying rules manually ]
To show menu page (page - a text) with title (t - a text):
	let manually running be a number;
	if the displaying activity is not going on:
		now manually running is 1;
	if manually running is 1:
		begin the displaying activity;
	clear the screen;
	say "[line break][page][paragraph break]";
	request a key press;
	now the menu header is Table of Shallow Menu Status;
	let temp menu title be the current menu title;
	now the current menu title is t;
	redraw status line;
	now the current menu title is the temp menu title;
	now the menu header is Table of Deep Menu Status;
	wait for any key;
	clear the screen;
	if manually running is 1:
		end the displaying activity;



Chapter - Clearing the screen

Before displaying (this is the clear the window before displaying rule):
	clear the screen;

After displaying (this is the clear the window after displaying rule):
	clear the screen;



Chapter - Displaying one single menu

Displaying a menu rule (this is the main menu display rule):
	clear the screen;
	let count be 1;
	let my menu be the submenu in row menu depth of Table of Menu history;
	repeat through my menu:
		[ Skip hidden rows]
		if there is a hidden-row entry and the hidden-row entry is true:
			next;
		say line break;
		[ Blank rows are okay! ]
		if there is no title entry or the title entry is "":
			next;
		[ Say the menu entry label only if there's something to do ]
		say fixed letter spacing;
		if there is a text entry or there is a description entry or there is a submenu entry or there is a subtable entry or there is a rule entry or there is a toggle entry:
			say " [menu label count]  ";
			increment count;
		otherwise:
			say "    ";
		say "[variable letter spacing][title entry]";
	say run paragraph on;



Chapter - The menu's status line - unindexed

To redraw status line:
	(- DrawStatusLine(); -).

Displaying a menu rule (this is the force a status line refresh rule):
	let temp menu title be the current menu title;
	now the current menu title is the title in row menu depth of Table of Menu history;
	redraw status line;
	now the current menu title is the temp menu title;

Rule for constructing the status line while displaying (this is the constructing status line while displaying rule):
	fill status bar with the Menu header;
	rule succeeds;



Chapter - Process a command - unindexed

To decide whether processing menu option (x - a number) is valid:
	let count be 1;
	let my menu be the submenu in row menu depth of Table of Menu history;
	repeat through my menu:
		[ Skip hidden rows]
		if there is a hidden-row entry and the hidden-row entry is true:
			next;
		if there is no title entry or the title entry is "":
			next;
		if there is a text entry or there is a description entry or there is a submenu entry or there is a subtable entry or there is a rule entry or there is a toggle entry:
			if count is x:
				if there is a rule entry:
					follow the rule entry;
					decide yes;
				if there is a toggle entry:
					follow the toggle entry;
					decide yes;
				if there is a submenu entry:
					show submenu submenu entry with title title entry;
					decide yes;
				if there is a subtable entry:
					show submenu subtable entry with title title entry;
					decide yes;
				if there is a description entry:
					show menu page description entry with title title entry;
					decide yes;
				if there is a text entry:
					show menu page text entry with title title entry;
					decide yes;
			increment count;
	decide no;

To show submenu (m - a table-name) with title (t - a text):
	increment menu depth;
	choose row menu depth in Table of Menu history;
	now the title entry is t;
	now the submenu entry is m;
	follow the entering a menu rules for m;

Displaying a menu rule (this is the process a menu command rule):
	while 1 is 1:
		let key be the chosen letter;
		let command be the chosen menu option for key;
		if command is -1:
			leave the current menu;
			stop;
		if command is 0:
			next;
		[ We have a menu choice! ]
		if processing menu option command is valid:
			stop;

To leave the current menu:
	follow the exiting a menu rules for the submenu in row menu depth of Table of Menu history;
	choose row menu depth in Table of Menu history;
	blank out the whole row;
	decrement menu depth;



Part - Glulx interface effects (for Glulx only)

Chapter - Popover menu window (for use with Flexible Windows by Jon Ingold)

disable the popover menu window is a truth state variable. [ False by default - i.e. the popover window will be used ]

The popover menu window is a text buffer g-window spawned by the main window.
The position of the popover menu window is g-placeabove.
The scale method of the popover menu window is g-proportional.
The measurement of the popover menu window is 100.

First before displaying rule (this is the switch to the popover menu window rule):
	if disable the popover menu window is false:
		open the popover menu window, as the acting main window;

Last after displaying rule (this is the switch back to the main-window rule):
	if disable the popover menu window is false:
		close the popover menu window;



Chapter - Open the status window if required - unindexed (for use with Flexible Windows by Jon Ingold)

The old status window presence is a truth state variable.

First before displaying rule (this is the open the status window if required rule):
	now the old status window presence is whether or not the status window is g-present;
	if the old status window presence is false:
		open the status window;

Last after displaying rule (this is the close the status window if required rule):
	if the old status window presence is false:
		close the status window;



Chapter - Menu hyperlinks - unindexed (for use with Glulx Entry Points by Emily Short)

enable menu hyperlinks is a truth state variable. [ False by default ]

After starting the virtual machine (this is the check if menus can use hyperlinks rule):
	unless glk hyperlinks are supported:
		now enable menu hyperlinks is false;

The main menu display with hyperlinks rule is listed instead of the main menu display rule in the displaying a menu rules.
Displaying a menu rule (this is the main menu display with hyperlinks rule):
	clear the screen;
	let count be 1;
	let my menu be the submenu in row menu depth of Table of Menu history;
	repeat through my menu:
		[ Skip hidden rows]
		if there is a hidden-row entry and the hidden-row entry is true:
			next;
		say line break;
		[ Blank rows are okay! ]
		if there is no title entry or the title entry is "":
			next;
		[ Say the menu entry label only if there's something to do ]
		say fixed letter spacing;
		if there is a text entry or there is a description entry or there is a submenu entry or there is a subtable entry or there is a rule entry or there is a toggle entry:
			if enable menu hyperlinks is true:
				set menu hyperlink for (the character number for menu label count);
			say " [menu label count]  ";
			increment count;
		otherwise:
			say "    ";
		say "[variable letter spacing][title entry]";
		if enable menu hyperlinks is true:
			end menu hyperlink;
	if enable menu hyperlinks is true:
		say paragraph break;
		set menu hyperlink for 81; [Q]
		say "[fixed letter spacing]    [variable letter spacing][italic type]Go back[roman type]";
		end menu hyperlink;
	say run paragraph on;

To request a key press:
	if enable menu hyperlinks is true:
		set menu hyperlink for 81; [Q]
	say "[italic type]Press a key to go back.[roman type][run paragraph on]";
	if enable menu hyperlinks is true:
		end menu hyperlink;

To set menu hyperlink for (N - a number):
	(- glk_set_hyperlink( {N} ); -).

To end menu hyperlink:
	(- glk_set_hyperlink( 0 ); -).

A glulx input handling rule for a hyperlink-event while displaying (this is the intercept menu hyperlinks rule):
	if enable menu hyperlinks is true:
		convert the hyperlink code to the character code;
		cancel character input in the main window;
		request hyperlink input again;
		replace player input;
		
[ gg_arguments-->0 will be used as the character code selected, so set it to the hyperlink code ]
To convert the hyperlink code to the character code:
	(- gg_arguments-->0 = gg_event-->2; -).

To request hyperlink input again:
	(- glk_request_hyperlink_event( gg_event-->1 ); -).

Last after displaying rule (this is the cancel character input if we left by clicking a hyperlink rule):
	cancel character input in the main window;



Menus ends here.



---- Documentation ----

Section: Basic Use

"Menus" provides a table-based way to display menus to the player. The menu takes over the main screen of the game and prevents parser input while it is active. 

"Menus" is not suitable for contexts where we want the player to be able to choose a numbered option during regular play (such as a menu of conversation choices when talking to another character). It is intended rather for situations where we wish to give the player optional instructions or hints separated from the main game.

Any given menu option may do one (and only one) of the following three things:

1) display some text to players, after which they can press a key to return to the menu. This tends to be useful for such menu options as "About this Game" and "Credits", where we have a few paragraphs of information that we would like to share.

2) trigger a secondary menu with additional options. The player may navigate this submenu, then return to the main menu. Submenus may be nested.

3) carry out a rule. This might perform any action, including making changes to the game state.

Menus are specified by tables, in which each row contains one of the menu options, together with instructions to Inform about how to behave when that option is selected. 

Each menu table should have columns called "title", "text", "submenu", "rule", and "hidden-row".

"Title" should be the name of the option we want the player to see: "Credits", "Hints", "About This Game", and so on.

"Text" is the text that will be printed when the option is selected. We can fill it in with as much information as we like.

"Submenu" is used to create a submenu; this column holds the name of the table that specifies the menu. For instance:

	Table of Options
	title	text (some text)	submenu (a table-name)	rule (a rule)	hidden-row (a truth state)
	"Settings"	--	Table of Setting Options

would create an option entitled "Settings", which the player could select to view a submenu of setting options. That submenu would in turn need its own table, thus

	Table of Setting Options
	title	text (some text)	submenu (a table-name)	rule (a rule)	hidden-row (a truth state)
	""

If we do not want a given option to trigger a new submenu, we can leave it as "--".

The "rule" column contains the rule carried out when this option is chosen. In theory, this rule could be absolutely anything. In practice, the feature is mostly useful for giving the player a table of setting options which he can toggle on and off: for instance, we might provide the option "use verbose room descriptions", and then have the toggle rule change the game's internal settings about how room descriptions are displayed. (See the example attached for further guidance.)

It is only useful for a given option to have one of these three features -- text or a submenu or a rule. In the event that more than one column is filled out, the game will obey the rule in preference to creating a submenu, and create a submenu in preference to displaying text. 

The "hidden-row" column can be used if we want to hide a given option. To hide the menu option, we mark this column "true". If we want the option visible, we can either leave the column empty, or mark it "false".

To display our menu to the player, we can write

	display the Table of Options menu with title "Instructions"

where "Table of Options" is the name of our table, and "Instructions" is the heading we'd like to appear above the menu.

Section: Optional Glulx Features

This extension offers a few additional features for Glulx projects: a popover window, and menu hyperlinks.

A popover window will temporarily hide (rather than permanently clear) the visible story text when the player opens a menu. When players exit the menu, they will be able to see their previous actions in scrollback.

The popover window feature requires the extension Flexible Windows by Jon Ingold. We will need to include Flexible Windows before Menus in our project. So long as we do this, the popover window will be used by default.

If we've included Flexible Windows but don't want the popover window, we can disable this feature as follows:

	disable the popover menu window is true
	
Menu hyperlinks require the extension Glulx Entry Points by Emily Short, which must be included before Menus.

Menu hyperlinks are disabled by default. We can enable them as follows:

	enable menu hyperlinks is true


Example: * Tabulation - A simple table of hints and help (see also Basic Help Menu).

For instance our Table of Options might look like this:

	*: "Tabulation" by Secretive J.
	
	Include Menus by Dannii Willis. [Change this to Emily Short when the extension is finished.]
	Use scoring.

	Table of Options
	title	text (some text)	submenu (a table-name)	rule (a rule)	hidden-row (a truth state)
	"Introduction to [story title]"	"This is a simple demonstration [story genre] game."
	"Settings"	--	Table of Setting Options
	"About the Author"	"[story author] is too reclusive to wish to disseminate any information. Sorry."
[	"Hints"	--	Table of Hints	Commenting this out for now because it doesn't work]

	Table of Setting Options
	title	text (some text)	submenu (a table-name)	rule (a rule)	hidden-row (a truth state)
	"[if notify mode is on]Score notification on[otherwise]Score notification off[end if]"	--	--	switch notification status rule

	To decide whether notify mode is on:
		(- notify_mode -);

	This is the switch notification status rule:
		if notify mode is on, try switching score notification off;
		otherwise try switching score notification on.

	[After each activation of the toggle rule, the menu redraws itself, so the player will see "score notification on" change to "score notification off" (and vice versa).]

[ Commenting out the hint menu related documentation, because it doesn't work at the moment:

	[Menus also provides for the case where we would like to display hints and give the player the option of revealing more and more detailed instructions. To this end, there is a special form for tables that lead to hints and tables which contain the hints themselves. The table leading to hints should look like this:]

	Table of Hints
	title	text (a text)	submenu (a table-name)	rule (a rule)	hidden-row (a truth state)
	"How do I reach the mastodon's jawbone?"	--	Table of Mastodon Hints		hint toggle rule
	"How can I make Leaky leave me alone?"		--	Table of Leaky Hints	hint toggle rule

	[where the toggle is always "hint toggle rule", and the submenu is always a table containing the hints themselves. A table of hints consists of just two columns, and one of those is for internal bookkeepping and should be initialized to contain a number. So:]

	Table of Mastodon Hints
	hint	used
	"Have you tried Dr. Seaton's Patent Arm-Lengthening Medication?"	a number
	"It's in the pantry."
	"Under some cloths."	

	Table of Leaky Hints
	hint	used
	"Perhaps it would help if you knew something about Leaky's personality."	a number
	"Have you read the phrenology text in the library?"	
	"Have you found Dr. Seaton's plaster phrenology head?"	
	"Now you just need a way to compare this to Leaky's skull."	
	"Too bad he won't sit still."	
	"But he has been wearing a hat. Perhaps you could do something with that."
	"You'll need to get it off his head first."	
	"Have you found the fishing pole?"	
	"And the wire?"	
	"Wait on the balcony until Leaky passes by underneath on his way to the Greenhouse."	
	"FISH FOR THE HAT WITH THE HOOK ON THE WIRE."	
	"Now you'll have to find out what the hat tells you."	
	"Putting it on the phrenology head might allow you to compare."	
	"Of course, if you do that, you'll reshape the felt. Hope you saved a game!"
	"You need a way to preserve the stiffness of the hat."	
	"Have you found the plaster of paris?"	
	"And the water?"	
	"And the kettle?"	

	[...etc. (Hints 19-135 omitted for brevity.)]

	[Because the toggle rule is always consulted when the player selects an option and before any other default behavior occurs, we can use this rule to override normal menu behavior more or less however we like. The hint toggle rule is just one example.]
]
	[Finally, if we wanted to create a HELP command that would summon our menu, we would then add this:]

	Understand "help" or "hint" or "hints" or "about" or "info" as asking for help.

	Asking for help is an action out of world.
	
	Carry out asking for help:
		display the Table of Options menu with title "Instructions".
		
[ Is any of this stuff still necessary?
		now the current menu is the Table of Options; 
		carry out the displaying activity;
		clear the screen;
		try looking.]
		
	The Cranial Capacity Calculation Chamber is a room. Leaky is a man in the Chamber. Leaky wears a pair of overalls and some muddy boots. He is carrying a fishing rod.
[Is this still necessary?
The displaying activity displays whatever is set as the current menu, so we must set the current menu before activating the activity. Afterward it is a good idea to clear the screen before returning to regular play.]