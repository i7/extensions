Version 1/140512 of Flexible Windows (for Glulx only) by Dannii Willis begins here.

"Exposes the Glk windows system so authors can completely control the creation and use of windows"

[ Flexible Windows was originally by Jon Ingold, with many contributions by Erik Temple. This version has been rewritten from scratch for 6L02. ]

Use authorial modesty.

Include version 1/140512 of Alternative Startup Rules by Dannii Willis.
Include version 10/140425 of Glulx Entry Points by Emily Short.



Part - Windows

Chapter - The g-window kind

[ g-windows must be a kind of container in order to use the containment relation as the spawning relation. Be careful if you iterate through all containers! ]
A g-window is a kind of container.
The specification of a g-window is "Models the Glk window system."

A g-window type is a kind of value.
The g-window types are g-text-buffer, g-text-grid and g-graphics.
The specification of a g-window type is "Glk windows are one of these three types."
A g-window has a g-window type called type.

A graphics g-window is a kind of g-window.
The type of a graphics g-window is g-graphics.
A text buffer g-window is a kind of g-window.
The type of a text buffer g-window is g-text-buffer.
A text grid g-window is a kind of g-window.
The type of a text grid g-window is g-text-grid.

A g-window position is a kind of value.
The g-window positions are g-placenull, g-placeleft, g-placeright, g-placeabove and g-placebelow.
The specification of a g-window position is "Specifies which direction a window will be split off from its parent window."
A g-window has a g-window position called position.

A g-window scale method is a kind of value.
The g-window scale methods are g-proportional, g-fixed-size and g-using-minimum.
The specification of a g-window scale method is "Specifies how a new window will be split from its parent window."
A g-window has a g-window scale method called scale method.

A g-window has a number called measurement.
The measurement of a g-window is usually 40.

A g-window has a number called minimum size.

A g-window has a number called the rock.

A g-window has a number called ref number.

A g-window can be g-required or g-unrequired.
A g-window is usually g-unrequired.

A g-window can be g-present or g-unpresent.
A g-window is usually g-unpresent.



Chapter - The spawning relation

[ The most efficient relations use the object tree. Inform will only use the object tree for a few built in relations however, so we piggy back on to the containment relation. ]
The verb to spawn implies the containment relation.

The verb to be ancestral to implies the enclosure relation.
The verb to be descended from implies the reversed enclosure relation.

[To decide which g-window is the parent of (win - a g-window):
	if the holder of win is a g-window:
		decide on the holder of win;]



Chapter - The built-in windows

The main window is a text buffer g-window.
[The rock of the main window is -100.]

The status window is a text grid g-window.
The position of the status window is g-placeabove.
The scale method of the status window is g-fixed-size.
The measurement of the status window is 1.
The main window spawns the status window.

Use no status line translates as (- Constant USE_NO_STATUS_LINE 1; -).
[Include (-
#ifndef USE_NO_STATUS_LINE;
Constant USE_NO_STATUS_LINE 0;
#endif;
-).]



Chapter - Starting up - unindexed

The main window rock is a number variable.
The main window rock variable translates into I6 as "GG_MAINWIN_ROCK".
The status window rock is a number variable.
The status window rock variable translates into I6 as "GG_STATUSWIN_ROCK".

[To decide if g-window rocks are unset: 
	if the rock of the main window is -100:
		yes;
	no;]

Before starting the virtual machine (this is the set g-window rocks rule):
	now the rock of the main window is the main window rock;
	now the rock of the status window is the status window rock;
	let cnt be 1000;
	repeat with win running through g-windows:
		if the rock of win is 0:
			now the rock of win is cnt;
			increase cnt by 10;



Part - The Flexible Windows API

Chapter - Opening and closing windows

To open up/-- (win - a g-window):
	if win is g-unpresent and (win is the main window or the main window is ancestral to win):
		now win is g-required;
		now every g-window ancestral to win is g-required;
		calibrate windows;

To shut down (win - a g-window):
	if win is g-present:
		now win is g-unrequired;
		now every g-window descended from win is g-unrequired;
		calibrate windows;



Section - Calibrating windows - unindexed

Definition: a g-window is paternal rather than childless if it spawns a g-present g-window.

Definition: a g-window is a next-step if it is the main window or it is spawned by something g-present.

To calibrate windows:
	[ close windows that shouldn't be open and then open windows that shouldn't be closed ]
	[while there is a g-unrequired g-present childless g-window (called H):
		carry out the window shutting activity with H;]
	while there is a g-required g-unpresent next-step g-window (called H):
		carry out the constructing activity with H;



Section - Constructing a window

Constructing something is an activity on g-windows.

The construct a g-window rule is listed in the for constructing rules.
The construct a g-window rule translates into I6 as "ConstructGWindow".
Include (-
[ ConstructGWindow win parentwin method size type rock;
	win = parameter_value;
	! Fill in parentwin, method and size only if the window is not the main window
	if ( win ~= (+ main window +) )
	{
		parentwin = parent( win ).(+ ref number +);
		if ( win.(+ scale method +) == (+ g-proportional +) )
		{
			method = winmethod_Proportional;
		}
		else
		{
			method = winmethod_Fixed;
		}
		method = method + win.(+ position +) - 2;
		if ( win.(+ scale method +) == (+ g-using-minimum +) )
		{
			size = win.(+ minimum size +);
		}
		else
		{
			size = win.(+ measurement +);
		}
	}
	type = win.(+ type +) + 2;
	rock = win.(+ rock +);
	win.(+ ref number +) = glk_window_open( parentwin, method, size, type, rock );
];
-).

First after constructing a g-window (called win) (this is the check if the window was created rule):
	if the ref number of win is zero:
		now win is g-unrequired;
		rule fails;
	otherwise:
		now win is g-present;



Chapter - Focus and changing the main window

To set/move/shift the/-- focus to (win - a g-window):
	if win is g-present:
		[now the current g-window is win;]
		set cursor to ref number of win;
		[if clearing the window:
			clear the current g-window;]



Section - I6 to change focus etc - unindexed

To set cursor to the/-- (N - a number):
	(- glk_set_window( {N} ); -).



Section - Keeping the built-in windows up to date - unindexed

gg_mainwin is a number variable.
The gg_mainwin variable translates into I6 as "gg_mainwin".
gg_statuswin is a number variable.
The gg_statuswin variable translates into I6 as "gg_statuswin".

After constructing a g-window (called win) (this is the focus the main window rule):
	if win is the main window:
		set focus to the main window;
	[ Account for changed main windows ]

After constructing a g-window (called win) (this is the update built-in windows rule):
	if win is the main window:
		now gg_mainwin is the ref number of main window;
	if win is the status window:
		now gg_statuswin is the ref number of status window;
		[ statuswin_cursize/statuswin_size? ]



Part - Opening the built-in windows

The open the built-in windows using Flexible Windows rule is listed instead of the open built-in windows rule in the for starting the virtual machine rulebook.
This is the open the built-in windows using Flexible Windows rule:
	if the main window is g-unpresent:
		open the main window;
	[otherwise:
		clear the main window;]
	if the no status line option is active:
		shut down the status window;
	otherwise:
		open the status window;
	continue the activity;



Flexible Windows ends here.
