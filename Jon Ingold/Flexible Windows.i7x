Version 14/140322 of Flexible Windows (for Glulx only) by Jon Ingold begins here.

"An extension for constructing multiple-window interfaces. Windows can be created and destroyed during play. Facilities for per-window character input and hyperlinks are provided."

"with contributions by Erik Temple and Dannii Willis"

[Changed:
6/26/10	Made the main-window a text-buffer g-window.
6/26/10	The built-in text hyperlinks system now doesn't compile if we're using Basic Hyperlinks.
7/31/10	New rule for allocating rocks.
7/31/10	New not-for-release section that validates rocks, disallowing duplicates.
7/31/10	Added documentation for manual setting of rock values.
7/31/10	Removed out-of-date section on hyperlinking from the documentation.
21/6/11 Added a "does window exist" check before setting background colour.
3 Aug 2013: Performance improvements (Changed spawning to be an alias of regular containment)
]

Include Glulx Entry Points by Emily Short.

Before starting the virtual machine:
	do nothing. [Hack that, for complicated reasons, prevents character streams going to the wrong place at game startup under some conditions.]

[ Code to make compatible with status line extensions. -- Aaron Reed. ]

Use no status line translates as (- Constant USE_NO_STATUS_LINE 1; -).
Include (-
#ifndef USE_NO_STATUS_LINE;
Constant USE_NO_STATUS_LINE 0;
#endif;
-). 



Chapter 1 - Initialisations, windows and values

Section - Definitions of properties and values

A g-window is a kind of container. [ So be careful iterating through all containers! ]

Include (-
Attribute g_present;
-) after "Definitions.i6t". 

A g-window can be g-present or g-unpresent. A g-window can be g-required or g-unrequired.

The g-present property translates into I6 as "g_present".

A g-window is g-unpresent. A g-window is g-unrequired.

A g-window-position is a kind of value. The g-window-positions are g-placenull, g-placeleft, g-placeright, g-placeabove and g-placebelow.

A g-window-type is a kind of value. The g-window-types are g-proportional, g-using-minimum and g-fixed-size.

A g-window-kind is a kind of value. The g-window-kinds are g-text-buffer, g-text-grid and g-graphics.


Section - Assigning properties to g-windows

A g-window has a g-window-position called position.
A g-window has a g-window-kind called type.
A g-window has a g-window-type called scale method.
A g-window has a number called measurement.
A g-window has a number called minimum size.

A g-window has a g-window called direct parent. The direct parent is usually the main-window.

The minimum size of a g-window is usually 0.
The measurement of a g-window is usually 40.

A g-window has a number called rock-value. The rock-value is usually 0.
A g-window has a number called ref-number. The ref-number is usually 0.
Rock-value property translates into I6 as "rock_value".
Ref-number property translates into I6 as "ref_number".

direct parent property translates into I6 as "direct_parent".

A graphics g-window is a kind of g-window. The type of a graphics g-window is g-graphics.
A text-buffer g-window is a kind of g-window. The type of a text-buffer g-window is g-text-buffer.
A text-grid g-window is a kind of g-window. The type of a text-grid g-window is g-text-grid.

The window-drawing rules are an object-based rulebook.


Section - Spawning relations - unindexed

[ Spawning used to be a custom relation between g-windows, but Inform doesn't produce optimised code, meaning that rearranging windows was very slow. Piggy-backing onto the containment relation allows us to get the benefit of Inform's much better optimised code for that relation, resulting in a 30 times speed improvement! And by defining a new verb, old code doesn't need to be updated. ]

The verb to spawn (he spawns, they spawn, he spawned, it is spawned, he is spawning) implies the containment relation.

The verb to be the spawner of implies the containment relation.

[ There is a slight change here: previously these verbs would say that a window was ancestral to/descended from itself. I can't see when that would ever be desired however, so the change shouldn't impact anyone. ]
The verb to be ancestral to implies the enclosure relation.
The verb to be descended from implies the reversed enclosure relation.

Definition: a g-window is paternal rather than childless if it spawns something g-present.

To decide which g-window is the direct-parent of (g - a g-window):
	if the holder of g is a g-window:
		decide on the holder of g;


Section - Test spawning relations (not for release)

Peeping is an action applying to one visible thing.

Understand "peep through [any g-window]" as peeping.

Carry out peeping (this is the peep rule):
	say "[noun]: spawns [a list of g-windows spawned by the noun]."; 
	say "ancestors: [a list of g-windows ancestral to noun].";
	say "descendants: [a list of g-windows descended from noun].";
	if noun is paternal, say "(currently paternal) ";
	otherwise say "(currently childless) ";
	if noun is g-present, say "(present) "; otherwise say "(missing) ";
	if noun is g-required, say "(required)."; otherwise say "(unneeded).";

tracking it to is an action applying to two visible  things.

Understand "track [any g-window] to [any g-window]" as tracking it to.

Carry out tracking it to:
	say "no. =>: [number of steps via the containment relation from noun to second noun].";
	say "no. <=: [number of steps via the containment relation from second noun to noun].";

Throwing open is an action applying to one visible  thing.
Slamming shut is an action applying to one visible  thing.

Understand "slam shut [any g-window]" as slamming shut.
Understand "throw open [any g-window]" as throwing open.

Carry out slamming shut:
	shut down the noun;

Carry out throwing open:
	open up the noun;


Section - The built in windows - unindexed

The main-window is a text-buffer g-window.
The main-window is g-present.
The main-window is g-required.
The rock-value of the main-window is 100.

The status-window is a text-grid g-window.
The status-window is g-present.
The status-window is g-required.
The scale method of the status-window is g-fixed-size.
The measurement of the status-window is 1.
The position of the status-window is g-placeabove.
The main-window spawns the status-window.

gg_mainwin is a number variable. The gg_mainwin variable translates into I6 as "gg_mainwin".
gg_statuswin is a number variable. The gg_statuswin variable translates into I6 as "gg_statuswin".

First after constructing a g-window (called win) (this is the update built in windows rule):
	if win is the main-window:
		now gg_mainwin is the ref-number of main-window;
		set focus to the main-window;
	if win is the status-window:
		now gg_statuswin is the ref-number of status-window;

First after window-shutting a g-window (called win) (this is the reset built in windows rule):
	if win is the main-window:
		now gg_mainwin is 0;
	if win is the status-window:
		now gg_statuswin is 0;


Section - Allocating window rocks - unindexed

First when play begins (this is the allocate rocks rule):
	let cnt be 200;
	repeat with item running through g-windows:
		if the rock-value of item is 0:
			set item rock to cnt;
			increase cnt by 10;
		now the direct parent of item is the direct-parent of item;
	set main-window ref.

To set main-window ref:
(- MainWinRef(); -).

Include (-

[ MainWinRef;
	(+ main-window +).rock_value = GG_MAINWIN_ROCK; 
	(+ main-window +).ref_number = gg_mainwin;
	give (+ main-window +) g_present;
	(+ status-window +).rock_value = GG_STATUSWIN_ROCK; 
	(+ status-window +).ref_number = gg_statuswin;
	give (+ status-window +) g_present;
];

 -).

To set (g - a g-window) rock to (n - a number):
	(- {g}.rock_value = {n}; -).

To decide if rocks are currently unassigned: 
	if rock-value of main-window is 100:
		yes;
	no;


Section - Validating rock numbers (not for release)

When play begins (this is the rock validation rule):
	repeat with item running through g-windows:
		let L be the list of g-windows;
		remove item from L;
		repeat with compared running through L:
			if the rock-value of item is the rock-value of compared:
				say "***Warning: There appears to be a conflict in the rock numbers of the g-windows '[item]' and '[compared]'. Assign all rock-values for custom windows manually to remedy this problem. Avoid using 201 or 202, as these are reserved.";
				stop.




Chapter 2 - Opening, closing and calibrating

Section - Opening and closing windows

[ Set the specified windows to be required or unrequried, as well as any ancestral or descendant windows, and then call calibrate, which will do the actual work ]

To open up (win - a g-window):
	if win is g-unpresent and (win is the main-window or the main-window is ancestral to win):
		now win is g-required;
		now every g-window ancestral to win is g-required;
		calibrate windows;

To shut down (win - a g-window):
	if win is g-present:
		now win is g-unrequired;
		now every g-window descended from win is g-unrequired;
		calibrate windows;


Section - Calibrating the window set to match expectations - unindexed

Definition: a g-window is a next-step if it is the main-window or it is spawned by something g-present.

To calibrate windows:
	[ close windows that shouldn't be open and then open windows that shouldn't be closed ]
	while there is a g-unrequired g-present childless g-window (called H):
		carry out the window-shutting activity with H;
	while there is a g-required g-unpresent next-step g-windows (called H):
		carry out the constructing activity with H;



Chapter 3 - I6 and Glulx Calls

Section - I6 for making a window - unindexed

Constructing something is an activity.

For constructing a g-window (called win) (this is the basic constructing a window rule):
	let p0 be the ref-number of the direct parent of win;	
	let p1 be the pos-val for win of the position of win + method-val of the scale method of win;
	let p2 be a number;
	if the scale method of win is g-using-minimum:
		now p2 is the minimum size of win;
	otherwise:
		now p2 is the measurement of win;
	let p3 be the kind-val of the type of win;
	now the ref-number of win is the reference created from p0 with p1 and p2 and p3 and rock value rock-value of win;
	now win is g-present;

For constructing the main-window (this is the construct the main-window rule):
	let p3 be the kind-val of the type of the main-window;
	let rock be the rock-value of the main-window;
	now the ref-number of the main-window is the reference created from 0 with 0 and 0 and p3 and rock value rock;
	now the main-window is g-present;

To decide which number is the reference created from (p0 - a number) with (p1 - a number) and (p2 - a number) and (p3 - a number) and rock value (rock - a number):
	(- ( glk_window_open( {p0}, {p1}, {p2}, {p3}, {rock} ) ) -).

To decide which number is the pos-val for (g - a g-window) of (N - a g-window-position): (-  (GetPos({N}, {g})) -).
To decide which number is the method-val of (N - a g-window-type): (- (GetMethod({N})) -).
To decide which number is the kind-val of (N - a g-window-kind): (- (GetKind({N})) -).

Include (-

[ GetKind kind;
	switch(kind)
	{
		(+g-text-buffer+):	return wintype_textbuffer;
		(+g-text-grid+):		return wintype_textgrid;
		(+g-graphics+):		return wintype_graphics;
	}
];

[ GetMethod type;
	switch(type)
	{	
		(+g-proportional+): 	return winmethod_Proportional;
		default:		  	return winmethod_Fixed;	
	}
];

[ GetPos pos win;
	switch(pos)
	{
		(+g-placeabove+): return winmethod_Above;
		(+g-placebelow+): return winmethod_Below;
		(+g-placeleft+): return winmethod_Left;
		(+g-placeright+): return winmethod_Right;
	} 

];

-)

First after constructing a g-window (called win) (this is the window could not be created rule):
	if the ref-number of win is zero:
		now win is g-unpresent;


Section - I6 for destroying a window - unindexed

Window-shutting something is an activity.

For window-shutting a g-window (called win) (this is the basic shut down rule):
	now win is g-unpresent;
	delete ref-number of win;

To delete (N - a number):
	(- glk_window_close( {N}, 0 ); -).


section - Identify glx rubbish - unindexed

A glulx zeroing-reference rule (this is the default removing references rule):
	doll-up properties; 	[ rebuild I7 properties, if we need to. ]
	if rocks are currently unassigned, follow the allocate rocks rule;
	repeat with g running through g-windows begin;
		if g is not main-window
		begin;
			now the ref-number of g is 0;
			now g is g-unpresent;
		end if;
	end repeat;

To doll-up properties: (- CreatePropertyOffsets(); -)

Definition: a g-window is on-call if the rock-value of it is the current glulx rock.

A glulx resetting-windows rule (this is the default reobtaining references rule):
	let g be a random on-call g-window; [ get the particular window we're looking to build]
	if g is a g-window and the current glulx rock is not zero begin;
		now the ref-number of g is the current glulx rock-ref;
		now g is g-present; [ the window is RIGHT HERE ]
	end if;
	[ by the end of this, all the windows which are actually present are marked thus, and have ref numbers. All those which aren't present are also marked. We then match this up to requirements. ]

The first glulx object-updating rule (this is the recalibrate windows when needed rule):
	set main-window ref;
	[ We'd like to just call calibrate windows, but we can't because its next-step/childless restrictions mean it may not catch all the windows ]
	while there is a g-unrequired g-present g-window (called H):
		shut down H;
	while there is a g-required g-unpresent g-windows (called H):
		open up H;



Section - Updating the contents of the windows

A glulx arranging rule (this is the arranging all rule):
	follow the refresh windows rule.

A glulx redrawing rule (this is the redrawing all rule):
	follow the refresh windows rule.

A glulx object-updating rule (this is the updating-after-undo all rule):
	follow the refresh windows rule.

This is the refresh windows rule:
	let old current be the current g-window;
	repeat with item running through g-present g-windows:
		now current g-window is the item;
		follow the window-drawing rules for the item;
	if the old current is g-present:
		now current g-window is the old current;
		purely focus the current g-window;
	
To refresh windows:
	follow the refresh windows rule.

The last after constructing a g-window (called win) (this is the draw window after construction rule):
	if win is g-present:
		follow the window-drawing rules for win;


Section - Some useful little functions

To decide which number is the measure of (g - a g-window):
	if the position of g is at least g-placeabove, decide on the height of g;
	decide on the width of g.

To decide which number is the width of (g - a g-window):
(-  	WindowSize({g}, 0) 	-).

To decide which number is the height of (g - a g-window):
(-  	WindowSize({g}, 1) 	-).

Include (-  

[ WindowSize g  index result;
	if (g hasnt g_present) return 0;
	result = glk_window_get_size(g.ref_number, gg_arguments, gg_arguments+WORDSIZE);
            return  gg_arguments-->index;
];

-)



Chapter 4 - The constructing activity

Section - Fixing problems with window scaling 

Before constructing a g-window (called win) (this is the fix method and measurement rule):
	[ Fix broken proportions ]
	if the scale method of win is g-proportional:
		if the measurement of win > 100 or the measurement of win < 0:
			now the scale method of win is g-fixed-size;
	[ Tile windows automatically ]
	if the position of win is g-placenull:
		if the position of the direct parent of win is at least g-placeabove:
			now the position of win is g-placeright; 
		otherwise:
			now the position of win is g-placeabove;
	[ Reset the minimum ]
	if the scale method of win is g-using-minimum:
		now the scale method of win is g-proportional;
	[ Use the minimum size ]
	if the scale method of win is g-proportional:
		let p1 be 100 multiplied by the minimum size of win;
		[actually, this should be the size of the direct parent, shouldn't it? ]
		let p2 be the measurement of win multiplied by width of the direct parent of win;
		if p1 > p2:
			now the scale method of win is g-using-minimum;


Section - Gargoyle Workaround

[Added by Erik Temple 22 May 2010]

[Workaround provided by Ben Cressey, with this explanation:

"Gargoyle has a bit of an issue with multiple text buffers.  The
background color for the most recently created text buffer is used as
the color of the padding between the application borders and the
boundaries of the Glk window model.  This padding is not part of Glk's
model and at best its behavior is undefined.  At worst, the very
existence of such padding is disallowed by the spec.  (I don't
actually know for sure.) 

Gargoyle uses these hints to "guess" the appropriate color of the
padding.  The above example would set it back to white, once you're
done opening all of your text buffers.  Per the Glk spec, this will
have no effect on any Glk windows until the next time you open a text
buffer, so as a practical matter it should do nothing in other Glk
implementations."

( from http://groups.google.com/group/rec.arts.int-fiction/msg/b88316e2dcf1bb6b )

(The workaround as incorporated here accepts a glulx color value (see Glulx Text Effects) rather than defaulting to white as in the originally posted code.)

After each text-buffer window is opened, the "Gargoyle text-buffer workaround rule" resets the text-buffer background color stylehint to the background color of the main-window.

The phrase used to accomplish this could also be used to set the Gargoyle border color to a *different* color from that of any of the windows. After all of your text-buffers have been opened, set the background color as desired, e.g.:

	set the Gargoyle background color to the color g-Lavender.

]

After constructing a g-window (called win) (this is the Gargoyle text-buffer workaround rule):
	if the type of win is g-text-buffer or the type of win is g-text-grid:
		if the back-colour of the main-window is g-placenullcol:
			set the text-buffer background color to g-white;
		otherwise:
			reset the text-buffer background color to the back-colour of the main-window;

To set/reset the/-- Gargoyle/-- text/text-buffer/-- window/-- background color/-- to the/-- color/-- (color_value - a glulx color value):
	(- HintGargoyleBorder ({color_value});-)

Include (-

[ HintGargoyleBorder color_value col ;
	col = ColVal(color_value);
	glk_stylehint_set(wintype_textbuffer, 0, stylehint_backcolor, col);
];

-).



Chapter 5 - Writing to different windows

Section - Shifting and knowing where we are

[ With version 14 we incorporate Erik Temple's Text Window Input-Output Control extension. ]

[ The current g-window refers to where the current focus is - when you print text, where will it go? ]
The current g-window is a g-window variable. The current g-window is the main-window.
[ The current text input window can be used to change where line input is requested ]
The current text input window is a g-window variable. The current text input window is the main-window.
[ The current text output window can be used to effectively change what Inform considers the main window to be - all Inform's normal behaviour will use it instead ]
The current text output window is a g-window variable. The current text output window is the main-window.

To set/move/shift the/-- focus to (g - a g-window), clearing the window:
	if g is g-present:
		now the current g-window is g;
		set cursor to ref-number of g;
		if clearing the window:
			clear the current g-window;

To purely focus (g - a g-window):
	(- if ( {g} has g_present ) { glk_set_window( {g}.ref_number ); } -).

To set cursor to the/-- (N - a number):
	(- glk_set_window({n}); -).

To clear the/-- (win - a g-window):
	if the type of win is g-graphics:
		graphics-clear win;
	otherwise:
		text-clear win.
        
To text-clear the/-- (g - a g-window):
(-    if ({g} has g_present) glk_window_clear({g}.ref_number); -).

To graphics-clear the/-- (g - a g-window):
(-    if ({g} has g_present) BlankWindowToColor({g}); -).

Include (-

[ BlankWindowToColor g result graph_width graph_height col;
    col = ColVal(g.back_colour);
    result = glk_window_get_size(g.ref_number, gg_arguments, gg_arguments+WORDSIZE);
                 graph_width  = gg_arguments-->0;
                 graph_height = gg_arguments-->1; 

    glk_window_fill_rect(g.ref_number, col, 0, 0, graph_width, graph_height);
];

-).


Section - Opening a window as the main input/output window

To open up (win - a g-window) as the/-- main/current/-- text/-- output window:
	if win is g-unpresent:
		open up win;
	now the current text output window is win;
	echo the stream of win to the transcript;
	set focus to the win;
	now gg_mainwin is the ref-number of win;
	
To open up (win - a g-window) as the/-- main/current/-- text/-- input window:
	if win is g-unpresent:
		open up win;
	now the current text input window is win;
	echo the stream of win to the transcript;


Section - Addition for the window-shutting activity

Before window-shutting a g-window (called the window) (this is the fix the current text output and input windows rule):
	if the window is the current text output window:
		now the current text output window is the main-window;
		set focus to the main-window;
		now gg_mainwin is the ref-number of the main-window;
	if the window is the current text input window:
		now the current text input window is the main-window;



Section - Which window is actually focused? (not for release) unindexed

To decide which g-window is the actually focused g-window:
	let target be the current stream;
	repeat with w running through g-windows:
		if target is the stream of w:
			decide on w;

To say the misbehaving g-window:
	let target be the actually focused g-window;
	say "[if target is not the current g-window][target][otherwise]";

To decide which number is the current stream:
 (- (CurrentStream()) -).
 
 To decide which number is the stream of (win - g-window):
 (- (StreamOfWindow( {win}.ref_number )) -).

Include (-

[ CurrentStream;
	return glk_stream_get_current();
];

[ StreamOfWindow win;
	return glk_window_get_stream( win );
];

-).



Chapter 5A - Replacing the user's input

[Glulx Entry Points' routines for pasting commands need to be modified for our purposes.]

Section - Cancelling input before printing to the input line

[First, we eliminate the standard rule that cancels input in the main window when a mouse click generates a command. We need to make this happen in the current text input window, so we provide the flexible cancelling input rule.]

The cancelling input in the main window rule is not listed in any rulebook.

An input-cancelling rule (this is the flexible calling input rule):
	cancel line input in the current text input window;
	cancel character input in the current text input window.
		
To cancel line input in (win - a g-window):
	(- glk_cancel_line_event({win}.ref_number, GLK_NULL); -)
	
To cancel character input in (win - a g-window):
	(- glk_cancel_char_event({win}.ref_number); -)

Section - Pasting commands to the input window

[ Here we provide a new command-pasting rule that targets our current text input window. We also provide some control over the state of paragraphing across the sometimes troublesome switch between windows. This control comes via the "command-pasting terminator" a global text variable that we can set to whatever we need to make things look good. By default, there is no terminator (the value is ""). If we are clearing the input window after each input, however, we will want to set the command-pasting terminator equal to "[run paragraph on]", or we will get an extra line break in the output window after each pasted command. ]

The print text to the input prompt rule is not listed in any rulebook.

The command-pasting terminator is a text variable.

A command-showing rule (this is the print text to the input window rule):
	purely focus the current text input window;
	say "[input-style-for-glulx][Glulx replacement command][roman type][command-pasting terminator]";
	purely focus the current g-window;



Chapter 5B - Printing prompts in the correct main window

Section - Printing the command prompt

[Here we rewrite the basic command prompt routine as an I7 activity. We can customize this as we see fit, or we can use it as a hook for other behavior.]

Printing the command prompt is an activity.

Rule for printing the command prompt (this is the standard prompt printing rule):
	purely focus the current text input window;
	ensure break before prompt;
	say "[roman type][command prompt][run paragraph on]";
	purely focus the current g-window;
	clear boxed quotation;
	clear paragraphing.
	
To ensure break before prompt:
	(- EnsureBreakBeforePrompt(); -)
	
To clear boxed quotation:
	(- ClearBoxedText(); -)
	
To clear paragraphing:
	(- ClearParagraphing(); -)

Section - Printing the final prompt

[The final prompt (i.e., the prompt for the final question, after play has ended) is printed independently of the in-game command prompt. Here we substitute a new rule for the Standard Rules' "print the final prompt rule" to handle this correctly.]

The print the final prompt rule is not listed in any rulebook.

The flexible print the final prompt rule is listed before the read the final answer rule in before handling the final question. 

This is the flexible print the final prompt rule:
	carry out the printing the command prompt activity.

Section - Yes-No question prompting

[There is one other situation in which the prompt is not controlled by the standard prompt printing activity. This is when the player answers a yes-no question, such as in response to whether she wishes to quit or restart the game, or to the "if the player consents" phrase. To handle these cases, we provide a rulebook and a global variable for holding an alternate prompt that can be used in the input window for yes/no questions only.]

The yes-no prompting rules are a rulebook.

The yes-no prompt is a text variable. The yes-no prompt is "".

[Ths saving, switching, and restoring of the prompt text is a bit awkward, but it allows for a different prompt to be used w/o requiring the surrounding behavior--i.e., the before and after rules for the command prompt activity to be specified twice--i.e., with one activity for the standard prompt, and one for the yes-no prompt.]

Last yes-no prompting rule (this is the default yes-no prompting rule):
	if the yes-no prompt is not "":
		say line break;
	let saved-prompt be the command prompt;
	now the command prompt is the yes-no prompt;
	carry out the printing the command prompt activity;
	now the command prompt is the saved-prompt.



Chapter 5C - Hacking the templates

Section - Keyboard input

Include (-

[ VM_KeyChar win nostat done res ix jx ch;
	jx = ch; ! squash compiler warnings
	if (win == 0) win = (+ current text input window +).ref_number;
	if (gg_commandstr ~= 0 && gg_command_reading ~= false) {
		done = glk_get_line_stream(gg_commandstr, gg_arguments, 31);
		if (done == 0) {
			glk_stream_close(gg_commandstr, 0);
			gg_commandstr = 0;
			gg_command_reading = false;
			! fall through to normal user input.
		} else {
			! Trim the trailing newline
			if (gg_arguments->(done-1) == 10) done = done-1;
			res = gg_arguments->0;
			if (res == '\') {
				res = 0;
				for (ix=1 : ix<done : ix++) {
					ch = gg_arguments->ix;
					if (ch >= '0' && ch <= '9') {
						@shiftl res 4 res;
						res = res + (ch-'0');
					} else if (ch >= 'a' && ch <= 'f') {
						@shiftl res 4 res;
						res = res + (ch+10-'a');
					} else if (ch >= 'A' && ch <= 'F') {
						@shiftl res 4 res;
						res = res + (ch+10-'A');
					}
				}
			}
	   		jump KCPContinue;
		}
	}
	done = false;
	glk_request_char_event(win);
	while (~~done) {
		glk_select(gg_event);
		switch (gg_event-->0) {
		  5: ! evtype_Arrange
			if (nostat) {
				glk_cancel_char_event(win);
				res = $80000000;
				done = true;
				break;
			}
			DrawStatusLine();
		  2: ! evtype_CharInput
			if (gg_event-->1 == win) {
				res = gg_event-->2;
				done = true;
				}
		}
		ix = HandleGlkEvent(gg_event, 1, gg_arguments);
		if (ix == 2) {
			res = gg_arguments-->0;
			done = true;
		} else if (ix == -1)  done = false;
	}
	if (gg_commandstr ~= 0 && gg_command_reading == false) {
		if (res < 32 || res >= 256 || (res == '\' or ' ')) {
			glk_put_char_stream(gg_commandstr, '\');
			done = 0;
			jx = res;
			for (ix=0 : ix<8 : ix++) {
				@ushiftr jx 28 ch;
				@shiftl jx 4 jx;
				ch = ch & $0F;
				if (ch ~= 0 || ix == 7) done = 1;
				if (done) {
					if (ch >= 0 && ch <= 9) ch = ch + '0';
					else                    ch = (ch - 10) + 'A';
					glk_put_char_stream(gg_commandstr, ch);
				}
			}
		} else {
			glk_put_char_stream(gg_commandstr, res);
		}
		glk_put_char_stream(gg_commandstr, 10); ! newline
	}
  .KCPContinue;
	return res;
];

[ VM_KeyDelay tenths  key done ix;
	glk_request_char_event( (+ current text input window +).ref_number );
	glk_request_timer_events(tenths*100);
	while (~~done) {
		glk_select(gg_event);
		ix = HandleGlkEvent(gg_event, 1, gg_arguments);
		if (ix == 2) {
			key = gg_arguments-->0;
			done = true;
		}
		else if (ix >= 0 && gg_event-->0 == 1 or 2) {
			key = gg_event-->2;
			done = true;
		}
	}
	glk_cancel_char_event( (+ current text input window +).ref_number );
	glk_request_timer_events(0);
	return key;
];

[ VM_ReadKeyboard  a_buffer a_table done ix;
	if (gg_commandstr ~= 0 && gg_command_reading ~= false) {
		done = glk_get_line_stream(gg_commandstr, a_buffer+WORDSIZE,
			(INPUT_BUFFER_LEN-WORDSIZE)-1);
		if (done == 0) {
			glk_stream_close(gg_commandstr, 0);
			gg_commandstr = 0;
			gg_command_reading = false;
			! L__M(##CommandsRead, 5); would come after prompt
			! fall through to normal user input.
		}
		else {
			! Trim the trailing newline
			if ((a_buffer+WORDSIZE)->(done-1) == 10) done = done-1;
			a_buffer-->0 = done;
			VM_Style(INPUT_VMSTY);
			glk_put_buffer(a_buffer+WORDSIZE, done);
			VM_Style(NORMAL_VMSTY);
			print "^";
			jump KPContinue;
		}
	}
	done = false;
	glk_request_line_event( (+ current text input window +).ref_number, a_buffer+WORDSIZE, INPUT_BUFFER_LEN-WORDSIZE, 0);
	while (~~done) {
		glk_select(gg_event);
		switch (gg_event-->0) {
		  5: ! evtype_Arrange
			DrawStatusLine();
		  3: ! evtype_LineInput
			if (gg_event-->1 == (+ current text input window +).ref_number) {
				a_buffer-->0 = gg_event-->2;
				done = true;
			}
		}
		ix = HandleGlkEvent(gg_event, 0, a_buffer);
		if (ix == 2) done = true;
		else if (ix == -1) done = false;
	}
	if (gg_commandstr ~= 0 && gg_command_reading == false) {
		glk_put_buffer_stream(gg_commandstr, a_buffer+WORDSIZE, a_buffer-->0);
		glk_put_char_stream(gg_commandstr, 10); ! newline
	}
  .KPContinue;
	VM_Tokenise(a_buffer,a_table);
	! It's time to close any quote window we've got going.
	if (gg_quotewin) {
		glk_window_close(gg_quotewin, 0);
		gg_quotewin = 0;
	}
   #ifdef ECHO_COMMANDS;
	print "** ";
	for (ix=WORDSIZE: ix<(a_buffer-->0)+WORDSIZE: ix++) print (char) a_buffer->ix;
	print "^";
	#endif; ! ECHO_COMMANDS
];

-) instead of "Keyboard Input" in "Glulx.i6t"

Section - The command prompt routine

Include (-

[ PrintPrompt i;
	!style roman;
	!EnsureBreakBeforePrompt();
	!glk_set_window( (+ current text input window +).ref_number );
	!PrintText( (+ command prompt +) );
	!glk_set_window( (+ current text output window +).ref_number );
	!ClearBoxedText();
	!ClearParagraphing();
	CarryOutActivity( (+ printing the command prompt +) );
	enable_rte = true;
];

-) instead of "Prompt" in "Printing.i6t"

Chapter - Inline graphics

Include (-

[ VM_Picture resource_ID;
	if (glk_gestalt(gestalt_Graphics, 0)) {
		glk_image_draw( (+ current text output window +).ref_number, resource_ID, imagealign_InlineCenter, 0);
	} else {
		print "[Picture number ", resource_ID, " here.]^";
	}
];

!No change made to sound effect code by Text Window I-O Control; included only as part of the same source code section as the figure display code.

[ VM_SoundEffect resource_ID;
	if (glk_gestalt(gestalt_Sound, 0)) {
		glk_schannel_play(gg_foregroundchan, resource_ID);
	} else {
		print "[Sound effect number ", resource_ID, " here.]^";
	}
];

-) instead of "Audiovisual Resources" in "Glulx.i6t"

Section - Screen routines

Include (-

[ VM_ClearScreen window;
	if (window == WIN_ALL or WIN_MAIN) {
		!glk_window_clear(gg_mainwin);
		glk_window_clear( (+ current text output window +).ref_number );
		if (gg_quotewin) {
			glk_window_close(gg_quotewin, 0);
			gg_quotewin = 0;
		}
	}
	if (gg_statuswin && window == WIN_ALL or WIN_STATUS) glk_window_clear(gg_statuswin);
];

[ VM_ScreenWidth  id;
	!id=gg_mainwin;
	id = (+ current text output window +).ref_number;
	if (gg_statuswin && statuswin_current) id = gg_statuswin;
	glk_window_get_size(id, gg_arguments, 0);
	return gg_arguments-->0;
];

[ VM_ScreenHeight;
	!glk_window_get_size(gg_mainwin, 0, gg_arguments);
	glk_window_get_size( (+ current text output window +).ref_number, 0, gg_arguments );
	return gg_arguments-->0;
];

-) instead of "The Screen" in "Glulx.i6t"

[
Section - Window color routines

Include (-

[ VM_SetWindowColours f b window doclear  i fwd bwd swin;
	if (clr_on && f && b) {
		if (window) swin = 5-window; ! 4 for TextGrid, 3 for TextBuffer

		fwd = MakeColourWord(f);
		bwd = MakeColourWord(b);
		for (i=0 : i<style_NUMSTYLES: i++) {
			if (f == CLR_DEFAULT || b == CLR_DEFAULT) {  ! remove style hints
				glk_stylehint_clear(swin, i, stylehint_TextColor);
				glk_stylehint_clear(swin, i, stylehint_BackColor);
			} else {
				glk_stylehint_set(swin, i, stylehint_TextColor, fwd);
				glk_stylehint_set(swin, i, stylehint_BackColor, bwd);
			}
		}

		! Now re-open the windows to apply the hints
		if (gg_statuswin) glk_window_close(gg_statuswin, 0);
		gg_statuswin = 0;

		if (doclear || ( window ~= 1 && (clr_fg ~= f || clr_bg ~= b) ) ) {
			glk_window_close( (+ current text output window +).ref_number, 0);
			gg_mainwin = glk_window_open(0, 0, 0, wintype_TextBuffer, (+ current text output window +).rock_value);
			if (gg_scriptstr ~= 0)
				glk_window_set_echo_stream((+ current text output window +).ref_number, gg_scriptstr);
		}

		gg_statuswin =
			glk_window_open(gg_mainwin, winmethod_Fixed + winmethod_Above,
				statuswin_cursize, wintype_TextGrid, GG_STATUSWIN_ROCK);
		if (statuswin_current && gg_statuswin) VM_MoveCursorInStatusLine(); else VM_MainWindow();

		if (window ~= 2) {
			clr_fgstatus = f;
			clr_bgstatus = b;
		}
		if (window ~= 1) {
			clr_fg = f;
			clr_bg = b;
		}
	}
];

[ VM_RestoreWindowColours; ! used after UNDO: compare I6 patch L61007
	if (clr_on) { ! check colour has been used
		VM_SetWindowColours(clr_fg, clr_bg, 2); ! make sure both sets of variables are restored
		VM_SetWindowColours(clr_fgstatus, clr_bgstatus, 1, true);
		VM_ClearScreen();
	}
];

[ MakeColourWord c;
	if (c > 9) return c;
	c = c-2;
	return $ff0000*(c&1) + $ff00*(c&2 ~= 0) + $ff*(c&4 ~= 0);
];

-) instead of "Window Colours" in "Glulx.i6t"
]

Section - Main window routine

Include (-

[ VM_MainWindow;
	glk_set_window( (+ current text output window +).ref_number ); ! set_window
	statuswin_current=0;
];

-) instead of "Main Window" in "Glulx.i6t"

Section - Box quote window routine

Include (-

[ Box__Routine maxwid arr ix lines lastnl parwin;
	maxwid = 0; ! squash compiler warning
	lines = arr-->0;

	if (gg_quotewin == 0) {
		gg_arguments-->0 = lines;
		ix = InitGlkWindow(GG_QUOTEWIN_ROCK);
		if (ix == 0)
			gg_quotewin =
				!glk_window_open(gg_mainwin, winmethod_Fixed + winmethod_Above,
				!	lines, wintype_TextBuffer, GG_QUOTEWIN_ROCK);
				glk_window_open( (+ current text output window +).ref_number, winmethod_Fixed + winmethod_Above, lines, wintype_TextBuffer, GG_QUOTEWIN_ROCK );
	} else {
		parwin = glk_window_get_parent(gg_quotewin);
		glk_window_set_arrangement(parwin, $12, lines, 0);
	}

	lastnl = true;
	if (gg_quotewin) {
		glk_window_clear(gg_quotewin);
		glk_set_window(gg_quotewin);
		lastnl = false;
	}

	VM_Style(BLOCKQUOTE_VMSTY);
	for (ix=0 : ix<lines : ix++) {
		print (string) arr-->(ix+1);
		if (ix < lines-1 || lastnl) new_line;
	}
	VM_Style(NORMAL_VMSTY);

	if (gg_quotewin) glk_set_window( (+ current text output window +).ref_number );
];

-) instead of "Quotation Boxes" in "Glulx.i6t"

Section - Transcript routine

Include (-

[ SWITCH_TRANSCRIPT_ON_R;
	if (actor ~= player) rfalse;
	if (gg_scriptstr ~= 0) return GL__M(##ScriptOn, 1);
	if (gg_scriptfref == 0) {
		gg_scriptfref = glk_fileref_create_by_prompt($102, $05, GG_SCRIPTFREF_ROCK);
		if (gg_scriptfref == 0) jump S1Failed;
	}
	! stream_open_file
	gg_scriptstr = glk_stream_open_file(gg_scriptfref, $05, GG_SCRIPTSTR_ROCK);
	if (gg_scriptstr == 0) jump S1Failed;
	BeginActivity( (+activating the transcript+) );
	ForActivity( (+activating the transcript+) );
	!	glk_window_set_echo_stream(gg_mainwin, gg_scriptstr);
	!	GL__M(##ScriptOn, 2);
	!	VersionSub();
	EndActivity( (+activating the transcript+) );
	return;
	.S1Failed;
	GL__M(##ScriptOn, 3);
];

-) instead of "Switch Transcript On Rule" in "Glulx.i6t"

Section - FileIO_Close()

Include (-

[ FileIO_Close extf  struc;
	if ((extf < 1) || (extf > NO_EXTERNAL_FILES))
		return FileIO_Error(extf, "tried to open a non-file");
	struc = TableOfExternalFiles-->extf;
	if (struc-->AUXF_STATUS ~=
		AUXF_STATUS_IS_OPEN_FOR_READ or
		AUXF_STATUS_IS_OPEN_FOR_WRITE or
		AUXF_STATUS_IS_OPEN_FOR_APPEND)
		return FileIO_Error(extf, "tried to close a file which is not open");
	if ((struc-->AUXF_BINARY == false) &&
		(struc-->AUXF_STATUS ==
		AUXF_STATUS_IS_OPEN_FOR_WRITE or
		AUXF_STATUS_IS_OPEN_FOR_APPEND)) {
		!glk_set_window(gg_mainwin);
		glk_set_window( (+ current text output window +).ref_number );
	}
	if (struc-->AUXF_STATUS ==
		AUXF_STATUS_IS_OPEN_FOR_WRITE or
		AUXF_STATUS_IS_OPEN_FOR_APPEND) {
		glk_stream_set_position(struc-->AUXF_STREAM, 0, 0); ! seek start
		glk_put_char_stream(struc-->AUXF_STREAM, '*'); ! mark as complete
	}
	glk_stream_close(struc-->AUXF_STREAM, 0);
	struc-->AUXF_STATUS = AUXF_STATUS_IS_CLOSED;
];

-) instead of "Close File" in "FileIO.i6t".

Section - Yes-no question routine

Include (-

[ YesOrNo i j;
	for (::) {
	RunParagraphOn();
		ProcessRulebook( (+ yes-no prompting rules +) );

	KeyboardPrimitive(buffer, parse);
		j = parse-->0;
		
		if (j) { ! at least one word entered
			i = parse-->1;
			if (i == YES1__WD or YES2__WD or YES3__WD) rtrue;
			if (i == NO1__WD or NO2__WD or NO3__WD) rfalse;
		}
		L__M(##Quit, 1); 
	}
];

-) instead of "Yes/No Questions" in "Parser.i6t"



Chapter 5D - Miscellaneous stuff that should probably be moved somewhere else


Section - Returning to the main window

To return to the/-- main window/screen:
	set focus to the current text output window;


Section - Setting the cursor

To position the cursor in (g - a g-window) at row (y - a number) column (x - a number):
(-	SetCursorTo({g}, {x}, {y}); 		-).

Include (-

[ SetCursorTo win row col;
	if (win has g_present)
		glk($002B, win.ref_number, row-1, col-1); ! window_move_cursor
];

-).



Section - Background colours

Include Glulx Text Effects by Emily Short.

Table of Common Color Values (continued)
glulx color value		assigned number
g-placenullcol		0
g-darkgreen	25600
g-green		32768
g-lime		65280
g-midnightblue	1644912
g-steelblue	4620980
g-terracotta	11674146
g-navy		128
g-mediumblue	205
g-blue		255
g-indigo		4915330
g-cornflowerblue	6591981
g-mediumslateblue	8087790
g-maroon	8388608
g-red		16711680
g-deeppink	16716947
g-brown		9127187
g-darkviolet	9699539
g-khaki		12433259
g-silver		12632256
g-crimson	14423100
g-orangered	16729344
g-gold		16766720	
g-darkorange	16747520
g-lavender	16773365
g-yellow		16776960
g-pink		16761035

A g-window has a glulx color value called back-colour. The back-colour of a g-window is usually g-placenullcol. The back-colour property translates into I6 as "back_colour".

Before constructing a g-window (called win) (this is the set background colour of text windows rule):
	if the type of win is g-text-buffer or the type of win is g-text-grid:
		set the background text-colour of win;

After constructing a g-window (called win) (this is the reset background colours rule):
	if the type of win is g-text-buffer or the type of win is g-text-grid:
		reset the background text-colour of win;

After constructing a g-window (called win) (this is the set background colour of graphics windows rule):
	if the type of win is g-graphics:
		set the background colour of win;

To set the background text-colour of (g - a g-window):
(-	SetBTcol({g});	-).

To reset the background text-colour of (g - a g-window):
(-	if ({g} has g_present) glk_window_clear({g}.ref_number);
	ResetBTCol();
-)

To set the background colour of (g - a g-window):
(-	if ({g} has g_present) SetBCol({g}.ref_number, {g}.back_colour);	
-).

Include 
(- 

Constant glulx_colour_table = (+Table of Common color Values+);

[ ColVal c i max;
	max=TableRows(glulx_colour_table);
	for ( i=1:i<=max:i++ ) {
		if (TableLookUpEntry(glulx_colour_table, 1, i) ==  c) 
			return TableLookUpEntry(glulx_colour_table, 2, i);
	} 
];

[ ResetBTCol i;
  for (i = 0: i < style_NUMSTYLES : i++)
	glk_stylehint_clear( wintype_AllTypes, i, stylehint_backcolor );
];


[ SetBTCol gwin col i;
  col = gwin.back_colour;
  if (col == (+g-placenullcol+)) rfalse;
  col = ColVal(col);
  for (i = 0: i < style_NUMSTYLES : i++)
 	 glk_stylehint_set( wintype_AllTypes, i, stylehint_BackColor, col );
];

[ SetBCol win col result;
	if (col ~= (+g-placenullcol+)) glk_window_set_background_color(win, ColVal(col));
	glk_window_clear(win);
];

-)


Include
(-
	[ InitGlkWindow winrock i col;
		switch(winrock){
			GG_MAINWIN_ROCK:	
				if ((+main-window+).back_colour ~=  (+g-placenullcol+))
				{ 	col = ColVal((+main-window+).back_colour);
					for (i = 0: i < style_NUMSTYLES : i++)
					glk_stylehint_set(wintype_TextBuffer, i, stylehint_BackColor, col);
					if ((+main-window+).ref_number) glk_window_clear((+main-window+).ref_number);
  glk_stylehint_set(wintype_TextBuffer, style_Emphasized, stylehint_Oblique, 1);
  glk_stylehint_set(wintype_TextBuffer, style_Emphasized, stylehint_weight, 0);

					rfalse;
				}
			GG_STATUSWIN_ROCK: 
				if (USE_NO_STATUS_LINE == 1) rtrue;		! - Aaron Reed
		}
		
		rfalse;

	];

-) after "Definitions.i6t". 


Section - Reverse-colouring windows

To set-reverse: 	(-	SetReverse(1);	-);
To unset-reverse: 	(-	SetReverse(0);	-);

Include (-

[ SetReverse flag i;
   for (i = 0: i < style_NUMSTYLES : i++)
       if (flag)	
	glk_stylehint_set(wintype_textgrid, i, stylehint_ReverseColor, 0);
      else
	glk_stylehint_clear(wintype_textgrid, i, stylehint_ReverseColor);

];

-).


Section - Bordered g-windows

A bordered g-window is a kind of g-window. A bordered g-window has a glulx color value called border-colour.
A bordered g-window has a number called border-measure. The border-measure of a bordered g-window is usually 3.

A g-border is a kind of g-window. 
The type of a g-border is always g-graphics. The scale method of a g-border is always g-fixed-size.

Every bordered g-window spawns four g-borders.

After constructing a bordered g-window (called the main-panel) (this is the place-borders rule):
	apply borders to main-panel;

To apply borders to (main-panel - a g-window):
	let border piece be g-placeleft;
	repeat with item running through g-borders spawned by the main-panel 
	begin;
		now the back-colour of the item is the border-colour of the main-panel;
		now the measurement of the item is the border-measure of the main-panel;
		now the position of the item is border piece;
		let the border piece be the g-window-position after border piece;
		now the item is g-required;
	end repeat.

When play begins when the main-window is a bordered g-window:
	apply borders to main-window.


Chapter 6 - Echo streams
	
To set the/-- echo stream of (win1 - a g-window) to the/-- stream of (win2 - a g-window):
	(- glk_window_set_echo_stream({win1}.ref_number, glk_window_get_stream({win2}.ref_number)); -)
	
To set the/-- echo stream of (win1 - a g-window) to the/-- echo stream of (win2 - a g-window):
	(- if (glk_window_get_echo_stream({win2}.ref_number)) {glk_window_set_echo_stream({win1}.ref_number, glk_window_get_echo_stream({win2}.ref_number)); } -)
	
To echo the/-- stream of (win2 - a g-window) to the/-- stream of (win1 - a g-window):
	(- glk_window_set_echo_stream({win1}.ref_number, glk_window_get_stream({win2}.ref_number)); -)
	
To shut down the/-- echo stream of (win - a g-window):
	(- if (glk_window_get_echo_stream({win}.ref_number)) { glk_window_set_echo_stream({win}.ref_number, GLK_NULL); } -)
	
To decide whether (win - a g-window) has an/-- echo stream:
	(- (glk_window_get_echo_stream({win}.ref_number)) -)


[The following phrase allows us to print text directly to the echo stream of a window, bypassing the window itself. We can, for example, use it to print text directly to the transcript, without showing the written text during play at all. For example, if the SCRIPT ON command is active, the echo stream of the main window is almost certain to be the transcript. If we want to write one block of text to the transcript alone, and a second block of text to both the screen and the transcript, we could do this:

	say "[echo stream of main-window]This text goes only to the transcript. [stream of main-window]This text goes to both the main-window and the transcript."
]

To say echo stream of (win - a g-window):
	(- if (glk_window_get_echo_stream({win}.ref_number)) { glk_stream_set_current( glk_window_get_echo_stream({win}.ref_number) ); } -)
	
To say stream of (win - a g-window):
	(- glk_set_window({win}.ref_number); -)


Section - Echo streams and the transcript

To decide whether we are writing to/-- the/a/-- transcript:
	(- gg_scriptstr -)
	
To echo the/-- text/-- stream of (win - a g-window) to the/-- transcript:
	(- if (gg_scriptstr) glk_window_set_echo_stream({win}.ref_number, gg_scriptstr); -)

Section - Transcript control for the current input/output window

[The Inform library directs only input from the main window to the transcript by default. This rule sends output from both of our windows to the transcript. It also recreates the library output. To change the standard library output, you can replace this rule with one of your own.]

Activating the transcript is an activity.

For activating the transcript (this is the transcript activation rule):
	echo the stream of the current text output window to the transcript;
	echo the stream of the current text input window to the transcript;
	say "Start of a transcript of[line break]";
	consider the announce the story file version rule.



Chapter 7 - Glk event handling phrases

[Added by Erik Temple 22 May 2010]

[These phrases only work within the Glk event-handling rulebooks defined in the Glulx Entry Points extension. These are:

The glulx line input rules	command line input
The glulx character input rules	keystroke input
The glulx hyperlink rules	text hyperlink
The glulx mouse input rules	mouse input in a graphics window
The glulx redrawing rules	graphic window needs redrawing
The glulx arranging rules	windows may need redrawing
The glulx sound notification rules	sound has finished playing
The glulx timed activity rules	timer event
]

[The following phrase will only work within the rules defined in the Glulx Entry Points extension. Specifically, it will only work with the following rulebooks:
	
The glulx redrawing rules
The glulx arranging rules
The glulx mouse input rules
The glulx character input rules
The glulx line input rules
The glulx hyperlink rules

The phrase will return 0 for the timed activity and sound notification rules, which are not associated with any window.

The phrase can be used with Flexible Windows like so:
	
	if the ref-number of the current window is the reference of the window in which the event was requested:
		...do something with this information...
]

To decide which number is the reference of the/-- window in/of/-- which/-- the/-- event was/-- requested/occurred/--:
	(- (gg_event-->1) -)
	
[The following phrase can only be used within the glulx hyperlink rulebook.]

To decide which number is the link/-- number of the/-- selected/clicked hyperlink:
	(- (gg_event-->2) -)


Chapter 8 - Basic keystroke input

[Added by Erik Temple 22 May 2010]

[These phrases simply recast the keystroke commands from Basic Screen Effects in a way that allows them to be called from any compatible window (that is, from a text-buffer or text-grid window; char input cannot be called from a graphics window).]

To request character input in (win - a g-window):
	(- glk_request_char_event({win}.ref_number); -)

To cancel line input in (win - a g-window):
	(- glk_cancel_line_event({win}.ref_number, GLK_NULL); -)
	
To cancel character input in (win - a g-window):
	(- glk_cancel_char_event({win}.ref_number); -)

To wait for any key in (win - a g-window):
	(- WinKeyPause({win}.ref_number); -)

To wait for the/-- SPACE key in (win - a g-window):
	(- WinSPACEPause({win}.ref_number); -)

To decide what number is the character code entered in (win - a g-window):
	(- WinGetKey({win}.ref_number) -)

Include (-

[ WinKeyPause win i ; 
	i = VM_KeyChar(win); 
	rfalse;
];

[ WinSPACEPause win i;
	while (i ~= 13 or 31 or 32)
	{
		i = VM_KeyChar(win);	
	}
];

[ WinGetKey win i;
	i = VM_KeyChar(win); 
	return i;
];

-)


Chapter 9 - Text hyperlinks (for use without Basic Hyperlinks by Emily Short)

[Added by Erik Temple 22 May 2010 -- Heavily based on Basic Hyperlinks by Emily Short]

Section - Initiating hyperlink handling

The current hyperlink window is a g-window variable.

When play begins (this is the initial hyperlink request rule):
	request glulx hyperlink event in the main-window;
	request glulx hyperlink event in the status window.
	
After constructing a g-window (called win) (this is the look for links on opening rule):
	if the type of win is not g-graphics:
		request glulx hyperlink event in win;
	
The look for links on opening rule is listed after the draw window after construction rule in after constructing.


Section - Hyperlink event handling

A glulx hyperlink rule (this is the default hyperlink handling rule):
	unless the status window is the hyperlink source:
		now the current hyperlink window is the window with the reference of the window in which the event occurred;
	now the current hyperlink ID is the link number of the selected hyperlink;
	unless the current hyperlink ID is 0:
		cancel glulx hyperlink request in the current hyperlink window;[just to be safe]
		follow the hyperlink processing rules;
	if the status window is the hyperlink source:
		request glulx hyperlink event in status window;
	otherwise:
		request glulx hyperlink event in the current hyperlink window.

To request glulx hyperlink event in (win - a g-window):
	(-  if (glk_gestalt(gestalt_Hyperlinks, 0)) glk_request_hyperlink_event({win}.ref_number); -)

To cancel glulx hyperlink request in (win - a g-window):
	(-  if (glk_gestalt(gestalt_Hyperlinks, 0)) glk_cancel_hyperlink_event({win}.ref_number); -)

To request glulx hyperlink event in the/-- status window:
	(-  if (glk_gestalt(gestalt_Hyperlinks, 0)  && gg_statuswin) glk_request_hyperlink_event(gg_statuswin); -)
	
To cancel glulx hyperlink event in the/-- status window:
	(-  if (glk_gestalt(gestalt_Hyperlinks, 0) && gg_statuswin) glk_cancel_hyperlink_event(gg_statuswin); -)

To decide whether the status window is the hyperlink source:
	(- (gg_event-->1==gg_statuswin) -)

To decide which g-window is the window with (N - a number):
	repeat with item running through g-windows:
		if N is the ref-number of item:
			decide on item;
	decide on main-window.


Section - Placing hyperlinks
	
To say link (N - a number):
	(-  if (glk_gestalt(gestalt_Hyperlinks, 0)) glk_set_hyperlink({N}); -)

To say end link:
	(-  if (glk_gestalt(gestalt_Hyperlinks, 0)) glk_set_hyperlink(0); -)


Section - Processing hyperlinks

The hyperlink processing rules are a rulebook.

The current hyperlink ID is a number that varies.


Section - Selecting the replacement command

The last hyperlink processing rule (this is the default command replacement by hyperlink rule):  
	repeat through the Table of Glulx Hyperlink Replacement Commands:
		if the current hyperlink ID is link ID entry:
			now the glulx replacement command is replacement entry;
			rule succeeds;
	now glulx replacement command is "".


Table of Glulx Hyperlink Replacement Commands
link ID	replacement
a number	some text


Flexible Windows ends here.


---- DOCUMENTATION ----

	Chapter: Introduction

	Section: Overview

Flexible Windows allows the Glulx author to construct and fill a series of multiple windows, which can be created and destroyed safely during the course of play. Restarts and restores are all handled properly. Windows can be graphical, text-buffers (like the main window is) or text-grids (in which case, glk calls can be used to place characters anywhere within them).

Although Flexible Windows does not supply any rules for using graphical windows beyond the most basic, several can be found in Emily Short's Simple Graphical Window extension. The examples below demonstrate some ideas. However, Flexible Windows is not compatible with Simple Graphical Window. The Glimmr family of extensions provides extensive support for graphics in Flexible Windows.

Note that as of version 9, the method of specifying drawing rules for windows has changed. See the Window Rules section below.

The latest version of this extension can be found at <https://github.com/i7/extensions>. This extension is released under the Creative Commons Attribution licence. Bug reports, feature requests or questions should be made at <https://github.com/i7/extensions/issues>.

	Chapter: Constructing a Layout

	Section: Concepts

All games start, by default, with a status bar along the top of the screen, and the main window below. Glulx windows are formed from the main window by carving off segments using either horizontal or vertical strokes, with each stroke creating one new window, from which further windows can be cut. This automatically creates a tree-structure for windows, with each new window being sliced from one that came before. The extension refers to this process as "spawning", and you set up your layout of windows by telling the game which window spawns which. 

These relationships - which window spawns which - must be inflexible throughout the game: although they may be multiple structures which the game can chop and change between, altering which window spawns which will likely cause UNDO and RESTORE commands to fail in strange ways. However, in practice this isn't too much of a restriction, as two windows with different names can easily be made to do the same things (see the section on Using the Windows, below).

One g-window object is created by default, though its properties are unimportant. It is called main-window, and its purpose is to spawn other windows.

	Section: Positioning windows

Each window is a thing of the kind g-window, which has several properties relating to its layout.

The position of each new window is specified using one of four positions, g-placeabove, g-placebelow, g-placeleft and g-placeright. Note, these indicate where the new window will be, rather than the direction of the slice taken.

So for example, to creating a banner between the main screen and the status, we would write

	The banner-window is a g-window. The main-window spawns the banner-window. The position of the banner-window is g-placeabove.

For a more complicated layout, akin to a standard email client, with folder list, contacts, preview and files windows, we would write

	The contacts-pane, folder-list and preview-window are g-windows. The main-window spawns the preview-window and the contacts-pane. The contacts-pane spawns the folder-list.

	The position of the preview-window is g-placebelow. The position of the contacts-pane is g-placeleft. The position of the folder-list is g-placeabove.

(Try sketching it out on a piece of paper.)

	Section: Sizing Windows

Once the rough positions of the windows has been decided, the next thing to allocate is their size. This can be done two ways, either by taking a proportional of the window being spawned from (so a 40% slice or a 15% slice), or taking a window of fixed size (in pixels for graphics windows, and in columns/rows for text windows). The proportion to take, or the width of a fixed size side-window (equivalently, the height of a top or bottom window) is set using the "measurement" property of the g-window. So we could write

	The scale method of the side-window is g-proportional. The measurement of the side-window is 25.

	The scale method of the banner-window is g-fixed-size. The measure of the banner-window is 30.

Finally, if we are using proportional windows, we can optionally set a "minimum size", which if the window gets below, it will take, rather than using the proportional scale.

	Section: Specifying Window Type

As mentioned above there are three types of Glulx window, text-buffer, text-grid and graphics. A text-buffer is a teletype-style stream of text (akin to the main window), a graphics screen cannot accept text but can render images, and a text-grid allows for flexible positioning of text characters using cursor-movement functions. 

There are two potential ways to define a window's type. One is to declare it to be of the appropriate kind:

	The side-window is a text-buffer g-window
	The side-window is a text-grid g-window
	The side-window is a graphics g-window

The other way is to set the "type" property to one of g-text-buffer, g-text-grid, or g-graphics. This is useful when we can't use one of the kinds given above. For example, the "bordered g-window" kind described below can potentially be any of the three types, so it is best to simply specify it by using the property. The following statements are true (although they don't actually appear anywhere in the extension):

	The type of the main-window is g-text-buffer.
	The type of the status-window is g-text-grid.

Window type can be changed during the game, however, it will only take effect when the window is opened.


	Section: Defaults and Corrections

Opening a new window is an activity that gets called for the pending window. This activity is the "constructing something" activity, and it's used to set background colours, neatly arranged unpositioned new windows, and apply the minimum width rules. New rules can be written before and after this activity. Note that for before rules the window will not yet be in existence on the screen but its properties can be changed, and for after rules it should be present on the screen.

Should you want to make changes to the styles for the windows, this is also the place to do it (see the Glk spec for more information on this). During the before phase, set the stylehint you want. During the after phase, remove it again, so that it doesn't affect other newly created windows. (See background colour rules for an example of this). 


	Section: Rock values

Internally, Glulx windows are dynamic objects, created as they are opened. Our g-windows, on the other hand, are static objects. When Flexible Windows opens a window, it gives the window a number, called the "rock" This rock value serves to identify the dynamic Glk/Glulx window object as the current instantiation of the static g-window object that shares the same rock.

Normally, Flexible Windows will set the rock values for all g-windows automatically, and the whole process occurs behind the scenes. There may be times, however, when we want to set a g-window's rock to a particular value. For example, Quixe, the javascript Glulx interpreter, uses rock values to identify windows for styling with CSS. In that system, the CSS for a window with rock value 210 might look like this:

	.WindowRock_210 { background-color: blue; }

Rocks should be numbered 200 and above. It is customary, though not necessary, to skip 10 when adding a new window; that is, for three windows, we'd have 200, 210, and 220. In fact, this is how Flexible Windows will assign them if we don't intervene. To ensure that a g-window gets a particular rock value, we can set it like so:

	The rock-value of the graphics-window is 245.

If we set numbers ending in 5 for our manual rocks, we will never conflict with the automated numbering.


	Chapter: Using Windows
	
	Section: Overview

This extension provides little in the way of support for graphics windows or text-grid windows, both of which can display images and draw shapes in a full range of colours. Text-grids can also locate the cursor (so, say, could be used to make a pac-man game). A few useful phrases for text-buffer windows are supplied.

	Section: Opening Windows

	open up side-window
	open up banner-window

The only point to note is that the "open up" command will, if necessary, also open any sub-windows required to reach the window you've asked for. So if the side-window is a spawn of the banner-window, and the banner-window is currently not open, the "open up side-window" command will open both. As mentioned above, spawning order is not editable once the game has started, so if you need flexibility on this, you'll need to make multiple, identical-acting windows (see Window Rules, below).

We set the cursor using
		
	shift focus to the main-window;

When writing and drawing to windows we should be careful they exist, otherwise the game will crash strangely. You can check the existence of a window at any time by testing for the g-present property.

	if side-window is g-present...
	if side-window is g-unpresent...

Since a lot of I6 code comes along with Glulx windows, these attributes exist cleanly in I6 too, (note the underscore replacing the hyphen).

	if ((+side-window+) has g_present)...
	if ((+banner-window+) hasnt g_present)...

	Section: Closing Windows
	
	shut down side-window

The point above applies here, in reverse: shutting a window will also shut all sub-windows contained by it.

	Section: Window Rules

When a window is opened or redrawn, the window-drawing rules for that window are consulted. The window-drawing rule should (ideally) be able to reconstruct entirely the contents of the window (otherwise, after an UNDO or a RESTORE, information will be lost). Rules for graphical drawing will want to use glk calls to place images--see Simple Graphical Window for examples. 

Text windows are supplied with three important phrases: one to move the focus to a different window, one to clear that window (if required), and one to shift the focus back. A drawing rule for a window designed to display the player's inventory would use all three, and take the following form:

	A window-drawing rule for the side-window (this is the display inventory in side-window rule):
		move focus to side-window, clearing the window;
		try taking inventory;
		return to main screen;

Any text window can be cleared at any time using

	clear main-window;
	clear side-window;

Note that Version 9's handling of drawing rules is different from earlier versions', and will require some changes to existing source code:

	1) The "drawing rule" property for windows no longer exists. References to this property should be removed.

	2) The rule preamble for drawing rules should be changed to the form:

		A window-drawing rule for the side-window

	3) Specific invocations of drawing rules should be changed to read as follows:

		follow the window-drawing rules for the side-window

	
	Section: Locating the current window

Side windows taking inventories and such-like might want to be able to tell the usual game rules that they're the ones doing so. Throughout the game, the variable "current g-window" tells the game where the output is going. So

	Rule for printing the name of the old book while taking inventory and the current g-window is side-window:
		say "The Meteor, the Stone (etc.)" instead.

	Section: Placing the cursor (text-grids only)

We can position the cursor in text-grid windows using the following phrase

	... position the cursor in side-window at row 2 column 1;

where row and column start from (1,1) in the top left.

	Section: Redrawing windows

We can redraw a specific window by saying

	follow the window-drawing rules for the side-window

though this should really be more careful that the side-window exists at present. Better yet is

	if side-window is g-present, follow the window-drawing rules for the side window

If we want to update all the sub-windows quickly, we can invoke the refresh window rule

	follow the refresh windows rule
	refresh windows

which does just that, carefully, and without bothering windows that aren't there.


	Chapter: Debugging verbs

This may or may not be helpful!

	Throw open any window - force open the window
	Slam shut any window - force close the window

	Track window to window - counts the number of spawn steps from noun to second (and back again, so you don't need to get the order right)

	Peep through window - Debug info on the window: what does it spawn, what spawns from it, and what Flexible Window attributes does it carry.

	Chapter: Special features

	Section: Overview

Note: these don't render well across the spectrum of Glulx interpreters.

	Section: Background Colour

Windows can have a back-colour, specified as one from the (reasonably large) Table of Common Color Values (based on but extended from Glulx Text Effects, by Emily Short). The possible colours are:

	g-darkgreen, g-green, g-lime, g-midnightblue, g-steelblue, g-terracotta, g-navy, g-mediumblue, g-blue, g-indigo, g-cornflowerblue, g-mediumslateblue, g-maroon, g-red, g-deeppink, g-brown, g-darkviolet, g-khaki, g-silver, g-crimson, g-orangered, g-gold, g-darkorange,g-lavender, g-yellow, g-pink.

and they are assigned by including a line like so:

	The side-window has back-colour g-red.
	The main-window has back-colour g-darkgreen.

At present, colours in graphics windows are reasonably well-supported (and if not, are unlikely to do any harm). Background colours in text windows can cause a series of ugly effects; such as the colour only appearing behind printed characters, or the background colour copying itself into all other text windows. 

The main-window can be supplied a background colour in the same way.

	Section: Borders

A window can be defined as a "bordered g-window", and it will then be produced with a border of "border-measure" thickness and "border-colour" colour. (This is wastefully done; it actually places four thin windows around the window constructed, but harmlessly so). 

The main-window can be bordered too, by declaring that "the main-window is a bordered g-window". 

    Section: Status Line

By default, Glulx games will incorporate a status line. To turn this off quickly, a use option is provided:

	Use no status line.


	Chapter: Alternative input

	Section: Character input (single keystroke)

The built-in extension Basic Screen Effects already handles single keystroke input (also known as "char input" or "character input"), but it can do so only in the main window. Even in a multiple window layout, this if often sufficient, since in nearly all games the main window will always be open, and thus always available for input. However, there may be some situations in which we want to accept character input in other windows, such as when another window has been opened "in front" of the main-window for some special purpose. For these situations we offer the following phrases. Note that most of them are simply extensions of the Basic Screen Effects phrases to allow specification of the window:

	wait for any key in the side-window
	wait for the SPACE key in the side-window

	...the character code entered in the side-window
	
The latter phrase both checks for a keypress and return a representation of the input as a numerical code. For example, the following would check for a keypress on startup, and print something if the key pressed was the spacebar:

	When play begins:
		if the character code entered in the main-window is 32:
			say "You pressed the space bar. Good work."


	Section: Hyperlinked text

Flexible Windows also offers the ability to place hyperlinks in text windows. The hyperlink functionality in Flexible Windows is based on that in Emily Short's Basic Hyperlinks extension. In fact, if you are moving an existing project to Flexible Windows, you may simply include Basic Hyperlinks to avoid making any changes to your existing hyperlink code. If you are starting a new project, though, it is recommended that you simply use the Flexible Windows commands (Though the functionality is similar, Flexible Windows uses a different namespace from Basic Hyperlinks.) 

By default, Flexible Windows's response to a clicked hyperlink is to enter a replacement command at the prompt on behalf of the player. To set a hyperlink, enclose the text to be linked between "set link <number>" and "end link" phrases:

	say "To the [set link 1]north[end link] a wide field opens, while to the [set link 2]south[end link] a narrow path winds into dark woods."

Hyperlink replacement commands are defined by the Table of Glulx Hyperlink Replacement Commands. Hyperlinks are numbered, starting from 1:

	Table of Glulx Hyperlink Replacement Commands (continued)
	link ID	replacement
	1	"GO NORTH"
	2	"GO SOUTH"

If a link ID number has no corresponding text command in the table of replacement commands, nothing will happen when the link is clicked.

To define custom behavior for a particular link, we write a new rule for the hyperlink processing rulebook. For example, to have a hyperlink simply clear the screen immediately, without pasting any text to the command line:

	Hyperlink processing rule when the current hyperlink ID is 1:
		clear the main-window;
		silently try looking;
		say "[command prompt][run paragraph on]";
		rule succeeds.

When we use this type of rule, we need not put anything in the Table of Glulx Hyperlink Replacement Commands. This table is only consulted when the default hyperlink processing rule is run.

Note that Flexible Windows will also register hyperlinks in the status line. We define these like we do any other hyperlink, e.g.:

	When play begins:
		now the right hand status line is "[set link 1]clear screen[end link]"


	Chapter: Echo streams and the transcript

With multiwindowed layouts, we may run into questions about what should be written to the transcript--if we have three windows, all of them displaying text, which of these should go to the transcript. The Inform library provides for only the main window to write to the transcript, but by using "echo streams" we can exercise much more control over what gets written.

Glulx allows each window to specify a maximum of one echo stream. An echo stream is another window or more often, a file on the hard disk, to which the output of the stream is "echoed". The most common use for this functionality is to allow for the main window to be echoed to the transcript file (the standard behavior of Inform after the player has entered the SCRIPT ON command). Flexible Windows provides a number of phrases that allow for the testing, assignment, and specification of echo streams.

First, we can test whether a given window has an echo stream like so:

	if the side-window has an echo stream

This will be true whether the side-window is echoing to the transcript or to another window.

We can also find out whether the transcript is currently be written to an external file (in other words, whether the transcript stream itself currently exists or not):

	if we are writing to the transcript

And we can directly set any window to write to the transcript:

	echo the stream of the side-window to the transcript

Any number of windows can be simultaneously echoed to the transcript. 

We can also direct windows to echo to other windows--essentially, both windows will display the same text at the same time. This probably has no real use apart from brief special effects, but is available nonetheless. These two phrases set the echo stream of the side window so that it will echo the main window's content:

	set the echo stream of the side-window to the stream of the main-window
	echo the stream of the main-window to the stream of the side-window

We can also set a window's echo stream to be the same as the echo stream of another window:

	set the echo stream of the side-window to the echo-stream of the main-window

A window stops echoing when either the window itself, or the stream to which it was echoing, is closed. We can also manually cease echoing a window's ouput:

	shut down the echo stream of the side-window

Finally, it is possible to write directly to the echo stream of a window, bypassing the window itself. This is likely to be most useful for selectively streaming information to the transcript:

	say "[echo stream of main-window]This text goes only to the transcript. [stream of main-window]This text goes to both the main-window and the transcript."


	Chapter: Change log

Version 13 - 3/8/13

	Changes how spawning works under the hood, so that the extension performs up to 30 times as fast. g-windows are now containers, so be careful not to repeat through all containers. Additionally, a window is no longer ancestral to/descended from itself.

Version 9 - 27/5/10

	Updated for use with Inform build 6Exx.

	Implemented a new object-based rulebook for window-drawing. This requires minor changes to existing source code.

	Added support for character input and textual hyperlinks, as well as limited support for echo streams. Improved behavior of window background colors under Gargoyle.

Version 8 - 26/6/09

	Changed code for clearing graphics windows to make it faster under Zoom for Mac (thanks to Erik Temple for this.) Note this clears the window by repainting it in its background colour, so this will have to be set for this to work correctly.

	Added use option for no status line (thanks to Aaron Reed for this.)





Example: * Inventory Window - A simple example showing how to place an side window displaying the player's inventory.

	*: "Inventory Window"

	The Study is a room. In the study is an old oak desk. On the desk is a Parker pen, a letter, an envelope and twenty dollars.

	Include Flexible Windows by Jon Ingold.

	The side-window is a text-buffer g-window spawned by the main-window.

The default setting for position - on the right - will do here, but the window could be smaller.

	*: The measurement of the side-window is 30.

	Window-drawing rule for the side-window (this is the construct inventory rule):
		move focus to side-window, clearing the window;
		try taking inventory;
		return to main screen.

Finally, two rules: one to make the window appear, and the other to keep it up-to-date.

	*: When play begins:
	open up the side-window.

	Every turn when the side-window is g-present: follow the window-drawing rules for the side-window.

	Test me with "take pen/take letter/i/take all".





Example: ** Inventory Window and Picture - A more complex example, that also provides an image panel above the inventory.

	*: "Inventory Window and Picture"

	The Study is a room. In the study is an old oak desk. On the desk is a Parker pen, a letter, an envelope and twenty dollars.

	Include Flexible Windows by Jon Ingold.

	The side-window is a text-buffer g-window spawned by the main-window.

	The measurement of the side-window is 30.

	A window-drawing rule for the side-window (this is the construct inventory rule):
		move focus to side-window, clearing the window;
		try taking inventory;
		return to main screen.

	Every turn when the side-window is g-present: follow the window-drawing rules for the side-window.

Now we set up and open the graphics-window. Note that we don't need to open the inventory window, since it will be called into being by the graphics window that it has spawned. 

	*: The graphics-window is a graphics g-window spawned by the side-window.

	When play begins:
		open up the graphics-window.

This is enough to set up the graphics panel. Now let's give it some images.

	*: The current image is a figure-name that varies.

	Figure 1 is the file "letter.jpg". Figure 2 is the file "scraps.jpg".

	Carry out examining the letter:
		depict Figure 1;

	Instead of attacking the letter:
		remove the letter from play;
		depict Figure 2;
		say "You tear the letter to shreds." instead.

	To depict (f - a figure-name):
		now the current image is f;
		follow the window-drawing rules for the graphics-window.

Finally, here's the rule and routines to actually get the picture to display.
	
	*: Window-drawing rule for the graphics-window (this is the draw scaled image rule):
		if graphics-window is g-unpresent, rule fails;
		clear the graphics-window;
		draw scaled copy of current image in graphics-window.

	To draw scaled copy of (f - a figure-name) in (g - a g-window):
		(- DrawScaled({f}, {g}); -).

What follows is some I6 code for handling the glulx imagery. Note that you may need to copy and paste the I6 code directly from this page rather than use the paste button.

	*: Include (-  

		! Doing scaling calculations in I6 lets us handle bigger numbers

		[ GetImageSize curimg index result;
			result = glk_image_get_info( ResourceIDsOfFigures-->curimg, gg_arguments,  gg_arguments+WORDSIZE);
			return gg_arguments-->index;
		];

		[ DrawScaled figure g w_total h_total graph_height graph_width w_offset h_offset;
		graph_height = WindowSize(g, 1);
		graph_width = gg_arguments-->0;
		w_total = GetImageSize(figure, 0);
		h_total = gg_arguments-->1;
	
		if (graph_height - h_total < 0) !	if the image won't fit, find the scaling factor
		{
			w_total = (graph_height * w_total)/h_total;
			h_total = graph_height;

		}

		if (graph_width - w_total < 0)
		{
			h_total = (graph_width * h_total)/w_total;
			w_total = graph_width;
		}

		w_offset = (graph_width - w_total)/2; if (w_offset < 0) w_offset = 0;
		h_offset = (graph_height - h_total)/2; if (h_offset < 0) h_offset = 0;
	
		glk_image_draw_scaled(g.ref_number, ResourceIDsOfFigures-->figure, w_offset, h_offset, w_total, h_total); 
		];
	
	-).

	Test me with "examine letter/z/attack letter".

