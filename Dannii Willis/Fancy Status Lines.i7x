Version 1/130201 of Fancy Status Lines by Dannii Willis begins here.

[ I had to stop this experiment when I discovered that Gargoyle doesn't support different text justifications. It doesn't support different font sizes either. :( ]

Include Basic Screen Effects by Emily Short.
Include Dynamic Objects by Jesse Mcgrew.
Include Flexible Windows by Jon Ingold.

[Part - System changes

Chapter - VM_Initialise

[ We want to run VM_Initialise() as a for starting the virtual machine rule ]
Include (-
[ VIRTUAL_MACHINE_STARTUP_R;
	ProcessRulebook(Activity_before_rulebooks-->STARTING_VIRTUAL_MACHINE_ACT);
	ProcessRulebook(Activity_for_rulebooks-->STARTING_VIRTUAL_MACHINE_ACT);
	ProcessRulebook(Activity_after_rulebooks-->STARTING_VIRTUAL_MACHINE_ACT);
	print "^^^";
	rfalse;
];
-) instead of "Virtual Machine Startup Rule" in "OrderOfPlay.i6t".

The VM_Initialise rule is listed in the for starting the virtual machine rules.
The VM_Initialise rule translates into I6 as "VM_Initialise".

Chapter - Moving rules to their correct homes

The allocate rocks rule is not listed in the when play begins rules.
The allocate rocks rule is listed first in the after starting the virtual machine rules.

Section (for use without Basic Hyperlinks by Emily Short)

The initial hyperlink request rule is not listed in the when play begins rules.
The initial hyperlink request rule is listed in the after starting the virtual machine rules.]



Part - Making a fancy status window

Chapter - The status window cache

A status window g-window is a kind of text-buffer g-window.
The status window g-window has a text-justification. The text-justification of a status window g-window is usually left-justified.

The status window template is a status window g-window.
The rock-value of the status window template is 1000000.
The status window rock counter is a number variable. The status window rock counter is 1000000.

[ We don't know how many status window objects we'll need, so we'll create them dynamically, and store them in a cache so they can be reused ]
The status window cache is a list of status window g-windows that varies.

After cloning a new object from the status window template (this is the set the g-window rock rule):
	now the rock-value of the new object is the status window rock counter;
	now the status window rock counter is the status window rock counter + 10;

To decide which g-window is an unused status window:
	[ Go through the cache to find an unused window ]
	repeat with win running through the status window cache:
		if win is g-unpresent:
			decide on win;
	[ If all the windows are in use, create a new one! ]
	let win be a new object cloned from the status window template;
	add win to the status window cache;
	decide on win;



[Chapter - Hiding the standard status line

[ We don't want to use the standard status line, but if it doesn't exist then we can't use our fancy one ]
Include (-
[ Hide_gg_statuswin;
	(+ the status window parent +) = glk_window_get_parent(gg_statuswin);
	!VM_StatusLineHeight( 0 );
	rfalse;
];
-).
The hide the standard status line rule is listed after the virtual machine startup rule in the startup rules.
The hide the standard status line rule is listed before the seed random number generator rule in the startup rules.
The hide the standard status line rule translates into I6 as "Hide_gg_statuswin".]



Chapter - Status line format numbers

To decide what number is (x - a truth state) times (b - a number):
	(- ( {x} * {b} ) -).

[ The correct row must already have been chosen ]
To decide what number is the current status line format for line (line - a number):
	choose row line in the current status window table;
	[ Check whether each part of the row is non-blank ]
	let pattern be indexed text;
	let pattern be "\S";
	let L be whether or not the left entry matches the regular expression pattern;
	let C be whether or not the central entry matches the regular expression pattern;
	let R be whether or not the right entry matches the regular expression pattern;
	[ Decide on the format - this is just the binary for these three ]
	decide on ( L times 4 ) + ( C times 2 ) + ( R times 1 );



Chapter - Filling the new status window

The current status window table is a table-name that varies.

The status window references list is a list of g-windows that varies.

[ Our replacement phrase to construct the status window from a table ]
To fill the/-- status bar/line with (selected table - a table-name):
	[ Rearrange the status windows if we've changed table ]
	if the current status window table is not selected table:
		now the current status window table is selected table;
		rearrange the status windows;
	[ Fill the windows with their contents ]
	let i be 0;
	let height be the number of rows in the current status window table;
	while i < height:
		choose row ( i + 1 ) in the current status window table;
		let format be the current status line format for line ( i + 1 );
		let offset be i * 3;
		move focus to main-window;
		if format is:
			[-- 0:] [ blank row! ]
			-- 1: [ right only ]
				move focus to entry ( offset + 1 ) of the status window references list, clearing the window;
				say right entry;
			-- 2: [ centre only ]
				move focus to entry ( offset + 2 ) of the status window references list, clearing the window;
				say central entry;
			-- 4: [ left only ]
				move focus to entry ( offset + 3 ) of the status window references list, clearing the window;
				say left entry;
			-- otherwise:
				move focus to entry ( offset + 1 ) of the status window references list, clearing the window;
				say "[left entry] [central entry] [right entry]";
		increment i;

[ Rearrange the status windows ]
To rearrange the status windows:
	[ Clear the current status line ]
	repeat with win running through the status window cache:
		now every g-window descended from win is g-unrequired;
	calibrate windows;
	[ Construct the new status line, line by line ]
	let i be 0;
	let height be the number of rows in the current status window table;
	change the status window references list to have height times 3 entries;
	while i < height:
		[ Make the windows inside the row ]
		let format be the current status line format for line ( i + 1 );
		if format is:
			-- 0: [ blank row! ]
				let row be a status row window left-justified;
			-- 1: [ right only ]
				now entry ( ( i * 3 ) + 1 ) of the status window references list is a status row window right-justified;
			-- 2: [ centre only ]
				now entry ( ( i * 3 ) + 2 ) of the status window references list is a status row window center-justified;
			-- 4: [ left only ]
				now entry ( ( i * 3 ) + 3 ) of the status window references list is a status row window left-justified;
			-- otherwise:
				now entry ( ( i * 3 ) + 1 ) of the status window references list is a status row window left-justified;
		increment i;

To decide what status window g-window is a status row window (j - a text-justification):
	[ Find or create a new g-window for this row ]
	let row be an unused status window;
	[ Fix the window properties to make this a row ]
	now row is spawned by the main-window;
	now the position of row is g-placeabove;
	now the scale method of row is g-fixed-size;
	now the measurement of row is 1;
	now the text-justification of row is j;
	[ Open up the row ]
	now row is g-required;
	g-make row;
	decide on row.

[ Add our justification styles ]
To set the status justification to (j - a text-justification):
	(- glk_stylehint_set( wintype_Textbuffer, 0, stylehint_Justification, ( {j} - 1 ) ); -).

Before constructing a status window g-window (called win) (this is the set status window justification rule):
	set the status justification to the text-justification of win.

To reset the status justification:
	(- glk_stylehint_clear( wintype_Textbuffer, 0, stylehint_Justification ); -).

After constructing a status window g-window (this is the reset status window justification rule):
	reset the status justification.
	
[ Ensure our fancy status line is automatically used ]
Rule for constructing the status line (this is the always use a fancy status line rule):
	fill status bar with Table of Ordinary Status;
	rule succeeds.



Chapter - Replacing the fill the status line phrase

Section - Replacing the fill the status line phrase  (in place of Section 1 - Spacing and Pausing in Basic Screen Effects by Emily Short) 

Include (-

[ KeyPause i; 
	i = VM_KeyChar(); 
	rfalse;
];

[ SPACEPause i;
	while (i ~= 13 or 31 or 32)
	{
		i = VM_KeyChar();	
	}
];

[ GetKey i;
	i = VM_KeyChar(); 
	return i;
];

-)

To clear the/-- screen:
	(- VM_ClearScreen(0); -)

To clear only the/-- main screen:
	(- VM_ClearScreen(2); -)

To clear only the/-- status line:
	(- VM_ClearScreen(1); -).

To wait for any key:
	(- KeyPause(); -)

To wait for the/-- SPACE key:
	(- SPACEPause(); -)

To decide what number is the chosen letter:
	(- GetKey() -)

To pause the/-- game: 
	say "[paragraph break]Please press SPACE to continue.";
	wait for the SPACE key;
	clear the screen.
	
To center (quote - text):
	(- CenterPrintComplex({quote}); -);

To center (quote - text) at the/-- row (depth - a number):
	(- CenterPrint({quote}, {depth}); -);
	
To stop the/-- game abruptly:
	(- quit; -)
	
To show the/-- current quotation:
	(- ClearBoxedText(); -);


Include (-

#ifndef printed_text;
Array printed_text --> 64;
#endif;

[ CenterPrint str depth i j;
	font off;
	i = VM_ScreenWidth();
			VM_PrintToBuffer(printed_text, 63, str);
	j = (i-(printed_text-->0))/2; 
	j = j-1;
	VM_MoveCursorInStatusLine(depth, j);
	print (I7_string) str; 
	font on;
];

[ CenterPrintComplex str i j;
	font off;
	print "^"; 
	i = VM_ScreenWidth();
			VM_PrintToBuffer(printed_text, 63, str);
	j = (i-(printed_text-->0))/2; 
	spaces j-1;
	print (I7_string) str; 
	font on;
];

-)

To decide what number is screen width:
	(- VM_ScreenWidth() -);

To decide what number is screen height:
	(- I7ScreenHeight() -);

Include (-

[ I7ScreenHeight i screen_height;
	i = 0->32;
		  if (screen_height == 0 or 255) screen_height = 18;
		  screen_height = screen_height - 7;
	return screen_height;
];

-)

To deepen the/-- status line to (depth - a number) rows:
	(- DeepStatus({depth}); -);

To move the/-- cursor to (depth - a number):
	(- I7VM_MoveCursorInStatusLine({depth}); -)

To right align the/-- cursor to (depth - a number):
	(- RightAlign({depth}); -)

Include (- 

[ DeepStatus depth i screen_width;
	VM_StatusLineHeight(depth);
	screen_width = VM_ScreenWidth();
	#ifdef TARGET_GLULX;
		VM_ClearScreen(1);
	#ifnot;
		style reverse;
		for (i=1:i<depth+1:i++)
		{
			 @set_cursor i 1;
			 spaces(screen_width);
		} 
	#endif;
]; 

[ I7VM_MoveCursorInStatusLine depth;
	VM_MoveCursorInStatusLine(depth, 1);
];

[ RightAlign depth screen_width o n;
	screen_width = VM_ScreenWidth(); 
	n = (+ right alignment depth +);
	o = screen_width - n;
	VM_MoveCursorInStatusLine(depth, o);
];

-)

Table of Ordinary Status
left	central	right
"[location]"	""	"[score]/[turn count]" 

Status bar table is a table-name that varies. Status bar table is the Table of Ordinary Status.

[To fill the/-- status bar/line with (selected table - a table-name):
	let __n be the number of rows in the selected table;
	deepen status line to __n rows;
	let __index be 1;
	repeat through selected table
	begin;
		move cursor to __index; 
		say "[left entry]";
		center central entry at row __index;
		right align cursor to __index;
		say "[right entry]";
		increase __index by 1;
	end repeat.]

Right alignment depth is a number that varies. Right alignment depth is 14.



Fancy Status Lines ends here.