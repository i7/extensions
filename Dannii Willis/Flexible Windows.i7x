Version 1/140710 of Flexible Windows (for Glulx only) by Dannii Willis begins here.

"Exposes the Glk windows system so authors can completely control the creation and use of windows"

[ Flexible Windows was originally by Jon Ingold, with many contributions by Erik Temple. This version has been rewritten from scratch for 6L02. ]

Use authorial modesty.

Include version 1/140512 of Alternative Startup Rules by Dannii Willis.
Include version 10/140425 of Glulx Entry Points by Emily Short.
Include version 5/140516 of Glulx Text Effects by Emily Short.



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



Chapter - Windows for the styles table

[ These things *must* be defined first in order for sorting to work. ]

All-windows is a g-window.
All-buffer-windows is a g-window.
All-grid-windows is a g-window.



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
The construct a g-window rule translates into I6 as "FW_ConstructGWindow".
Include (-
[ FW_ConstructGWindow win parentwin method size type rock;
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
	rfalse;
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



Part - Window styles

[ We extend Glulx Text Effects to allow you to specify styles for specific windows ]

Chapter - Extending Glulx Text Effects

Section - The Extended Table of User Styles definition (in place of Section - The Table of User Styles definition in Glulx Text Effects by Emily Short)

Table of User Styles
window (a g-window)	style name (a glulx text style)	background color (a text)	color (a text)	first line indentation (a number)	fixed width (a truth state)	font weight (a font weight)	indentation (a number)	italic (a truth state)	justification (a text justification)	relative size (a number)	reversed (a truth state)
--



Section - Sorting the Table of User Styles

[ Sort the table of User Styles taking into account both the style name and the window ]

The Flexible Windows sort the Table of User Styles rule is listed instead of the sort the Table of User Styles rule in the before starting the virtual machine rules.
Before starting the virtual machine (this is the Flexible Windows sort the Table of User Styles rule):
	[ First fix the empty columns we require ]
	repeat through the Table of User Styles:
		[ rows without specified windows will be applied to all buffer windows ]
		if there is no window entry:
			now the window entry is all-buffer-windows;
		if there is no style name entry:
			now the style name entry is all-styles;
	sort the Table of User Styles in style name order;
	sort the Table of User Styles in window order;
	let row1 be 1;
	let row2 be 2;
	[ Overwrite the first row of each style with the specifications of subsequent rows of the style ]
	while row2 <= the number of rows in the Table of User Styles:
		choose row row2 in the Table of User Styles;
		if there is a style name entry:
			if (the window in row row1 of the Table of User Styles) is the window entry and (the style name in row row1 of the Table of User Styles) is the style name entry:
				if there is a background color entry:
					now the background color in row row1 of the Table of User Styles is the background color entry;
				if there is a color entry:
					now the color in row row1 of the Table of User Styles is the color entry;
				if there is a first line indentation entry:
					now the first line indentation in row row1 of the Table of User Styles is the first line indentation entry;
				if there is a fixed width entry:
					now the fixed width in row row1 of the Table of User Styles is the fixed width entry;
				if there is a font weight entry:
					now the font weight in row row1 of the Table of User Styles is the font weight entry;
				if there is a indentation entry:
					now the indentation in row row1 of the Table of User Styles is the indentation entry;
				if there is a italic entry:
					now the italic in row row1 of the Table of User Styles is the italic entry;
				if there is a justification entry:
					now the justification in row row1 of the Table of User Styles is the justification entry;
				if there is a relative size entry:
					now the relative size in row row1 of the Table of User Styles is the relative size entry;
				if there is a reversed entry:
					now the reversed in row row1 of the Table of User Styles is the reversed entry;
				blank out the whole row;
			otherwise:
				now row1 is row2;
		increment row2;
	[ Sort once more to put the blank rows at the bottom ]
	sort the Table of User Styles in window order;



Section - Enhanced phrases for applying styles to specific window types - unindexed

To set the background color of wintype (W - a number) for (style - a glulx text style) to (N - a text):
	(- GTE_SetStylehint( {W}, {style}, stylehint_BackColor, GTE_ConvertColour( {N} ) ); -).

To set the color of wintype (W - a number) for (style - a glulx text style) to (N - a text):
	(- GTE_SetStylehint( {W}, {style}, stylehint_TextColor, GTE_ConvertColour( {N} ) ); -).

To set the first line indentation of wintype (W - a number) for (style - a glulx text style) to (N - a number):
	(- GTE_SetStylehint( {W}, {style}, stylehint_ParaIndentation, {N} ); -).

To set fixed width of wintype (W - a number) for (style - a glulx text style) to (N - truth state):
	(- GTE_SetStylehint( {W}, {style}, stylehint_Proportional, ( {N} + 1 ) % 2 ); -).

To set the font weight of wintype (W - a number) for (style - a glulx text style) to (N - a font weight):
	(- GTE_SetStylehint( {W}, {style}, stylehint_Weight, {N} - 2 ); -).

To set the indentation of wintype (W - a number) for (style - a glulx text style) to (N - a number):
	(- GTE_SetStylehint( {W}, {style}, stylehint_Indentation, {N} ); -).

To set italic of wintype (W - a number) for (style - a glulx text style) to (N - a truth state):
	(- GTE_SetStylehint( {W}, {style}, stylehint_Oblique, {N} ); -).

To set the justification of wintype (W - a number) for (style - a glulx text style) to (N - a text justification):
	(- GTE_SetStylehint( {W}, {style}, stylehint_Justification, {N} - 1 ); -).

To set the relative size of wintype (W - a number) for (style - a glulx text style) to (N - a number):
	(- GTE_SetStylehint( {W}, {style}, stylehint_Size, {N} ); -).

To set reversed of wintype (W - a number) for (style - a glulx text style) to (N - a truth state):
	(- GTE_SetStylehint( {W}, {style}, stylehint_ReverseColor, {N} ); -).

[ And some phrases to clear them again. ]

To clear the background color of wintype (W - a number) for (style - a glulx text style):
	(- FW_ClearStylehint( {W}, {style}, stylehint_BackColor, ); -).

To clear the color of wintype (W - a number) for (style - a glulx text style):
	(- FW_ClearStylehint( {W}, {style}, stylehint_TextColor ); -).

To clear the first line indentation of wintype (W - a number) for (style - a glulx text style):
	(- FW_ClearStylehint( {W}, {style}, stylehint_ParaIndentation ); -).

To clear fixed width of wintype (W - a number) for (style - a glulx text style):
	(- FW_ClearStylehint( {W}, {style}, stylehint_Proportional ); -).

To clear the font weight of wintype (W - a number) for (style - a glulx text style):
	(- FW_ClearStylehint( {W}, {style}, stylehint_Weight ); -).

To clear the indentation of wintype (W - a number) for (style - a glulx text style):
	(- FW_ClearStylehint( {W}, {style}, stylehint_Indentation ); -).

To clear italic of wintype (W - a number) for (style - a glulx text style):
	(- FW_ClearStylehint( {W}, {style}, stylehint_Oblique ); -).

To clear the justification of wintype (W - a number) for (style - a glulx text style):
	(- FW_ClearStylehint( {W}, {style}, stylehint_Justification ); -).

To clear the relative size of wintype (W - a number) for (style - a glulx text style):
	(- FW_ClearStylehint( {W}, {style}, stylehint_Size ); -).

To clear reversed of wintype (W - a number) for (style - a glulx text style):
	(- FW_ClearStylehint( {W}, {style}, stylehint_ReverseColor ); -).

Include (-
[ FW_ClearStylehint wintype style hint i;
	if ( style == (+ all-styles +) )
	{
		for ( i = 0: i < style_NUMSTYLES : i++ )
		{
			glk_stylehint_clear( wintype, i, hint );
		}
	}
	else
	{
		glk_stylehint_clear( wintype, style - 2, hint );
	}
];
-).



Section - Applying the generic styles

[ At this stage only apply the generic (non window specific) styles. ]

The set generic text styles rule is listed instead of the set text styles rule in the before starting the virtual machine rules.
Last before starting the virtual machine (this is the set generic text styles rule):
	let W be a number;
	repeat through the Table of User Styles:
		if the window entry is:
			-- All-windows:
				now W is 0;
			-- All-buffer-windows:
				now W is 3;
			-- All-grid-windows:
				now W is 4;
			-- otherwise:
				break;
		if there is a background color entry:
			set the background color of wintype W for the style name entry to the background color entry;
		if there is a color entry:
			set the color of wintype W for the style name entry to the color entry;
		if there is a first line indentation entry:
			set the first line indentation of wintype W for the style name entry to the first line indentation entry;
		if there is a fixed width entry:
			set fixed width of wintype W for the style name entry to the fixed width entry;
		if there is a font weight entry:
			set the font weight of wintype W for the style name entry to the font weight entry;
		if there is a indentation entry:
			set the indentation of wintype W for the style name entry to the indentation entry;
		if there is a italic entry:
			set italic of wintype W for the style name entry to the italic entry;
		if there is a justification entry:
			set the justification of wintype W for the style name entry to the justification entry;
		if there is a relative size entry:
			set the relative size of wintype W for the style name entry to the relative size entry;
		if there is a reversed entry:
			set reversed of wintype W for the style name entry to the reversed entry;



Section - Applying window specific styles

[ Apply styles before constructing a window and then clear them afterwards. This is tricky because we must reinstate the generic styles. ]

Before constructing a g-window (called win) (this is the set the window's styles rule):
	let W be a number;
	let found the window be a truth state;
	if the type of win is:
		-- g-text-buffer:
			now W is 3;
		-- g-text-grid:
			now W is 4;
		-- g-graphics:
			stop;
	repeat through the Table of User Styles:
		unless the window entry is win:
			if found the window is true:
				stop;
			next;
		now found the window is true;
		if there is a background color entry:
			set the background color of wintype W for the style name entry to the background color entry;
		if there is a color entry:
			set the color of wintype W for the style name entry to the color entry;
		if there is a first line indentation entry:
			set the first line indentation of wintype W for the style name entry to the first line indentation entry;
		if there is a fixed width entry:
			set fixed width of wintype W for the style name entry to the fixed width entry;
		if there is a font weight entry:
			set the font weight of wintype W for the style name entry to the font weight entry;
		if there is a indentation entry:
			set the indentation of wintype W for the style name entry to the indentation entry;
		if there is a italic entry:
			set italic of wintype W for the style name entry to the italic entry;
		if there is a justification entry:
			set the justification of wintype W for the style name entry to the justification entry;
		if there is a relative size entry:
			set the relative size of wintype W for the style name entry to the relative size entry;
		if there is a reversed entry:
			set reversed of wintype W for the style name entry to the reversed entry;

A first after constructing a g-window (called win) (this is the reset the generic styles rule):
	let W be a number;
	let resetting required be a truth state;
	if the type of win is:
		-- g-text-buffer:
			now W is 3;
		-- g-text-grid:
			now W is 4;
		-- g-graphics:
			stop;
	repeat through the Table of User Styles:
		unless the window entry is win:
			if resetting required is true:
				break;
			next;
		now resetting required is true;
		if there is a background color entry:
			clear the background color of wintype W for the style name entry;
		if there is a color entry:
			clear the color of wintype W for the style name entry;
		if there is a first line indentation entry:
			clear the first line indentation of wintype W for the style name entry;
		if there is a fixed width entry:
			clear fixed width of wintype W for the style name entry;
		if there is a font weight entry:
			clear the font weight of wintype W for the style name entry;
		if there is a indentation entry:
			clear the indentation of wintype W for the style name entry;
		if there is a italic entry:
			clear italic of wintype W for the style name entry;
		if there is a justification entry:
			clear the justification of wintype W for the style name entry;
		if there is a relative size entry:
			clear the relative size of wintype W for the style name entry;
		if there is a reversed entry:
			clear reversed of wintype W for the style name entry;
	[ I'm not sure if this will be too much of a performance hit, but it's the simplest solution ]
	if resetting required is true:
		follow the set generic text styles rule;



Part - Opening the built-in windows

Chapter - Style the built-in windows

[ These are the original styles set by Inform in VM_Initialise(). ]

Table of User Styles (continued)
window	style name	reversed	justification	font weight	italic
all-buffer-windows	italic-style	--	--	regular-weight	true
all-buffer-windows	header-style	--	left-justified
all-grid-windows	all-styles	true




Chapter - Make it happen!

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
