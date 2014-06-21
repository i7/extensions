Version 1/140416 of Menus by Dannii Willis begins here.

"Display full-screen menus defined by tables"

Use authorial modesty.

Include Basic Screen Effects by Emily Short.

Section (for Glulx only)

Include version 10 of Glulx Entry Points by Emily Short.
Include version 14/140416 of Flexible Windows by Jon Ingold.



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



Part - Interface phrases - unindexed

[ Wait for a safe non navigating key. The user might press Down/PgDn or use the mouse scroll wheel when reading a menu page, so we will stop those key codes from returning to the menu. ]
To wait for any non navigating key:
	(- WaitForNonNavigatingKey(); -).
	
Include (-

[ WaitForNonNavigatingKey key;
	while ( 1 )
	{
		key = VM_KeyChar();
		#Ifdef TARGET_ZCODE;
		if ( key == 63 or 129 or 130 or 132 )
		{
			continue;
		}
		#Ifnot; ! TARGET_GLULX
		if ( key == -4 or -5 or -10 or -11 or -12 or -13 )
		{
			continue;
		}
		#Endif; ! TARGET_
		rfalse;
	}
];

-).

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
	wait for any non navigating key;
	clear the screen;
	if manually running is 1:
		end the displaying activity;

After displaying (this is the run the exiting a menu rules rule):
	follow the exiting a menu rules for the submenu in row 1 of the Table of Menu history;



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
		if there is a hidden-row entry:
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
		if there is a hidden-row entry:
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



Book - Glulx interface effects (for Glulx only)

Part - Glulx Menu options

disable the popover menu window is a truth state variable. [ False by default - i.e. the popover window will be used ]
enable menu hyperlinks is a truth state variable. [ False by default ]



Chapter - Popover menu window

The popover menu window is a text-buffer g-window spawned by the main-window.
The position of the popover menu window is g-placeabove.
The scale method of the popover menu window is g-proportional.
The measurement of the popover menu window is 100.

First before displaying rule (this is the switch to the popover menu window rule):
	if disable the popover menu window is false:
		open up the popover menu window as the main text output window;

Last after displaying rule (this is the switch back to the main-window rule):
	if disable the popover menu window is false:
		shut down the popover menu window;



Chapter - Open the status window if required - unindexed

The old status-window presence is a truth state variable.

[ The order is important: this must be before the switch to the popover menu window rule, or else there'll be no room for the status window ]
The open the status window if required rule is listed before the switch to the popover menu window rule in the before displaying rules.

First before displaying rule (this is the open the status window if required rule):
	now the old status-window presence is whether or not the status-window is g-present;
	if the old status-window presence is false:
		open up the status-window;

Last after displaying rule (this is the shut down the status window if required rule):
	if the old status-window presence is false:
		shut down the status-window;



Chapter - Menu hyperlinks - unindexed

After starting the virtual machine (this is the check if menus can use hyperlinks rule):
	unless glulx hyperlinks are supported:
		now enable menu hyperlinks is false;

The main menu display with hyperlinks rule is listed instead of the main menu display rule in the displaying a menu rules.
Displaying a menu rule (this is the main menu display with hyperlinks rule):
	clear the screen;
	let count be 1;
	let my menu be the submenu in row menu depth of Table of Menu history;
	repeat through my menu:
		[ Skip hidden rows]
		if there is a hidden-row entry:
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
