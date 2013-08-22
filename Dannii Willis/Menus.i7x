Version 1/130822 of Menus by Dannii Willis begins here.

"Display full-screen menus defined by tables"

Use authorial modesty.

Include Basic Screen Effects by Emily Short.



Part - Tables

Chapter - Menu columns

[ Define the column types for Menus. The old column names will still work. ]

Table of Menu column definitions
title	text	description	submenu	subtable	rule	toggle
""	""	""	a table-name	a table-name	a rule	a rule

Chapter - Status tables

Table of Shallow Menu Status
left	central	right
""	"[current menu title]"	""

Table of Deep Menu Status
left	central	right
""	"[current menu title]"	""
""	""	""
" Select a number"	""	"Esc/Q = Back "

Chapter - Menu history

Table of Menu history
title	submenu
""	a table-name
with 9 blank rows



Part - Menus [Variables]

The current menu is a table-name variable. The current menu is Table of Menu column definitions.
The current menu title is a text variable. The current menu title is "Instructions".

Section - unindexed

Menu header is a table-name variable. The menu header is Table of Deep Menu Status.



Part - Menu labels

[ This Part can be replaced to allow more/different labels to be printed and accepted ]

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

Section (for Z-machine only) unindexed

To decide what number is the chosen menu option for (x - a number):
	if x is 81 or x is 113 or x is 27:
		decide on -1;
	if x > 48 and x < 58:
		decide on x - 48;
	if x > 64 and x < 76:
		decide on x - 55;
	if x > 96 and x < 108:
		decide on x - 87;
	decide on 0;

Section (for Glulx only) unindexed



Part - Interface phrases

Section (for Z-machine only) unindexed

To wait for any non navigating key:
	while 1 is 1:
		let key be the chosen letter;
		if key is 129 or key is 130:
			next;
		stop;

Section (for Glulx only)



Part - Displaying a menu

Displaying is an activity.

The displaying a menu rules are a rulebook.

Rule for displaying (this is the display a menu rule):
	while the number of filled rows in Table of Menu history > 0:
		consider the displaying a menu rules;

To display the/-- (t - a table-name) menu with title (x - text):
	blank out the whole of Table of Menu history;
	choose a blank row in Table of Menu history;
	now the title entry is x;
	now the submenu entry is t;
	carry out the displaying activity;

[ Support the old Menus way of running the displaying activity directly ]
First before displaying rule (this is the fix the Table of Menu history rule):
	choose row 1 in Table of Menu history;
	if there is no title entry or the title entry is "":
		now the title entry is the current menu title;
		now the submenu entry is the current menu;



Chapter - Clearing the screen

Section (for Z-machine only)

Before displaying (this is the clear the window before displaying rule):
	clear the screen;

After displaying (this is the clear the window after displaying rule):
	clear the screen;

Section (for Glulx only)

[ TODO: In Glulx hide the main window rather than clearing ]



Chapter - Displaying one single menu

Section (for Z-machine only)

Displaying a menu rule (this is the main menu display rule):
	clear the screen;
	let count be 1;
	choose row (number of filled rows in Table of Menu history) in Table of Menu history;
	let my menu be the submenu entry;
	repeat through my menu:
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

Section (for Glulx only)



Chapter - The menu's status line unindexed

To redraw status line:
	(- DrawStatusLine(); -).

Displaying a menu rule (this is the force a status line refresh rule):
	let temp menu title be the current menu title;
	choose row (number of filled rows in Table of Menu history) in Table of Menu history;
	now the current menu title is the title entry;
	redraw status line;
	now the current menu title is the temp menu title;

Rule for constructing the status line while displaying (this is the constructing status line while displaying rule):  
	fill status bar with the Menu header;
	rule succeeds;



Chapter - Process a command unindexed

To decide whether processing menu option (x - a number) is valid:
	let count be 1;
	choose row (number of filled rows in Table of Menu history) in Table of Menu history;
	let my menu be the submenu entry;
	repeat through my menu:
		if there is no title entry or the title entry is "":
			next;
		if there is a text entry or there is a description entry or there is a submenu entry or there is a subtable entry or there is a rule entry or there is a toggle entry:
			if count is x:
				if there is a rule entry:
					consider the rule entry;
					decide yes;
				if there is a toggle entry:
					consider the toggle entry;
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
	let n be the number of filled rows in Table of Menu history + 1;
	now title in row n of Table of Menu history is t;
	now submenu in row n of Table of Menu history is m;

To show menu page (page - a text) with title (t - a text):
	clear the screen;
	say "[line break][page][paragraph break][italic type]Press any key to go back.[roman type]";
	now the menu header is Table of Shallow Menu Status;
	let temp menu title be the current menu title;
	now the current menu title is t;
	redraw status line;
	now the current menu title is the temp menu title;
	now the menu header is Table of Deep Menu Status;
	wait for any non navigating key;
	clear the screen;

Section (for Z-machine only)

Displaying a menu rule (this is the process a menu command rule):
	while 1 is 1:
		let key be the chosen letter;
		let command be the chosen menu option for key;
		if command is -1:
			choose row (number of filled rows in Table of Menu history) in Table of Menu history;
			blank out the whole row;
			stop;
		if command is 0:
			next;
		[ We have a menu choice! ]
		if processing menu option command is valid:
			stop;

Section (for Glulx only)



Menus ends here.
