Version 16.0.0 of Flexible Windows (for Glulx only) by Jon Ingold begins here.

"Gives control over the Glk windows system in Glulx."

[ Version 16 is rewritten for Inform 11, and uses many new features. But for compatibility reasons the naming of things has been, as much as possible, left as it was. Some quirks in previous versions may have been made more regular however. ]

Use authorial modesty.



Part - I6 helpers - unindexed

[ Fix spurious line breaks from being printed in the main window after running the refreshing activity ]
To safely carry out the (A - activity on value of kind K) activity with (val - K):
	(- @push say__p; @push say__pc; CarryOutActivity({A}, {val}); @pull say__pc; @pull say__p; -).

[ Because glk window is now a subkind of abstract object we can no longer set a glk window variable to "nothing", so instead we will use this. ]
To decide which glk window is the null window:
	(- (nothing) -).



Part - Windows

Chapter - Expanding the Glk window kind

[ In Inform 11 a Glk window kind is now build in, but we still need to add many additional properties. ]

Definition: a glk window is graphical rather than textual if the window type of it is graphics window type.
Definition: a glk window is buffering rather than non-buffering if the window type of it is text buffer window type.

A glk window has a glk window position called position.
The position property is accessible to Inter as "split_dir".
Definition: a glk window is vertically positioned rather than horizontally positioned if the position of it is at least placed above.

A glk window has a glk window split method called split method.
The split method property is accessible to Inter as "split_method".
The split method of a glk window is usually proportionally sized.

A glk window has a number called measurement.
The measurement property is accessible to Inter as "measurement".
The measurement of a glk window is usually 40.

A glk window can be either split with a border or split without a border.
The split with a border property is accessible to Inter as "split_border".
A glk window is usually split without a border.

A glk window can be required or unrequired.

Chapter - The spawning relationship

Spawning relates one glk window (called the spawner) to various glk windows.
The spawner property is accessible to Inter as "window_spawner".

The verb to spawn means the spawning relation.
The verb to be ancestral to implies the spawning relation.
The verb to be descended from implies the reversed spawning relation.

Chapter - The built in windows

[ Set the position of the main window just so that we can automatically arrange windows ]
The position of the main window is placed below.

The status window is spawned by the main window.
The position of the status window is placed above.
The split method of the status window is fixed size.
The measurement of the status window is 1.

The quote window is spawned by the main window.

The open built in windows using Flexible Windows rule is listed instead of the open built in windows rule in the for starting the virtual machine rulebook.
This is the open built in windows using Flexible Windows rule:
	if the main window is off-screen:
		open the main window;
	otherwise:
		clear the main window;
	focus the main window;
	if the no status window option is not active:
		open the status window;
	continue the activity;

Rule for refreshing the status window (this is the refresh the status window rule):
	redraw the status window;

[ No need for this now ]
The redraw the status line rule is not listed in the glk event handling rules.

Chapter - Object recovery

A reset glk references rule (this is the reset window properties rule):
	let i be 1000;
	repeat with win running through glk windows:
		if the rock number of win is 0:
			now the rock number of win is i;
			increase i by 10;
		now the glk window handle of win is 0;
		now win is not currently being processed;

[ The Glk object recovery rules will iterate through all Glk windows, include pair windows which we don't track, so while generally we don't support Glk windows without an I7 representation, we have to here. ]
The find existing windows rule is listed instead of the identify built in windows rule in the identify glk windows rules.
An identify glk windows rule (this is the find existing windows rule):
	let win be the window with rock number current glk object rock number;
	if win is not nothing:
		now the glk window handle of win is the current glk object reference number;

[ Recalibrate windows during GGRecoverObjects, however do not delete the main and status windows when restarting. ]
A first glk object updating rule (this is the recalibrate windows rule):
	now the current root window is the null window;
	repeat with win running through glk windows:
		if win is on-screen:
			now the current root window is the root of win;
			break;
	if the starting the virtual machine activity is going on:
		if the main window is on-screen:
			now the main window is required;
			now the current focus window is the main window;
		if the status window is on-screen and the no status window option is not active:
			now the status window is required;
	calibrate windows;
	if the current focus window is on-screen:
		focus the current focus window;

Section - Helper phrases - unindexed

To decide which glk window is the window with rock number (rock - a number):
	if rock is not 0:
		repeat with win running through glk windows:
			if the rock number of win is rock:
				decide on win;
	decide on the null window;



Part - The Flexible Windows API

Chapter - Opening and closing windows

To open up/-- (win - a glk window):
	if win is off-screen:
		[ Check that this window is connected to the current root window ]
		let root be the root of win;
		if the current root window is nothing:
			now the current root window is root;
		otherwise if root is not the current root window:
			issue the run-time problem "CannotOpenDisconnectedWindow";
			say "*** Cannot open window which is not related by spawning to the open window tree";
			stop;
		now win is required;
		now every glk window ancestral to win is required;
		calibrate windows;

To close (win - a glk window):
	if win is on-screen:
		now win is unrequired;
		now every glk window descended from win is unrequired;
		calibrate windows;
		if win is the current root window:
			now the current root window is the null window;

Section - Root window - unindexed

The current root window is a glk window variable.

To decide what glk window is the root of (win - a glk window):
	let parent be the spawner of win;
	if parent is nothing:
		decide on win;
	decide on the root of parent;

Section - Calibrating windows - unindexed

A glk window can be currently being processed.

Definition: a glk window is parental rather than childless if it spawns an on-screen glk window.

Definition: a glk window is next-step if it is the current root window or it is spawned by an on-screen glk window.

To calibrate windows:
	[ Close windows that shouldn't be open, and then open windows that shouldn't be closed ]
	while there is a not currently being processed unrequired on-screen childless glk window (called win):
		[ Only run each window once, even if we end up back in this loop (by open/close being called in a before rule), to prevent infinite loops ]
		now win is currently being processed;
		safely carry out the deconstructing activity with win;
		now win is not currently being processed;
	while there is a not currently being processed required off-screen next-step glk window (called win):
		now win is currently being processed;
		safely carry out the constructing activity with win;
		now win is not currently being processed;

Section - Constructing a window

Constructing something is an activity on glk windows.

The construct a glk window rule is listed in the for constructing rules.
The construct a glk window rule is defined by Inter as "FW_CONSTRUCT_WINDOW_R".

First after constructing a glk window (called win) (this is the check if the window was created rule):
	if win is off-screen:
		now win is unrequired;
		rule fails;

The process window split method rule is listed in the after constructing rules.
The process window split method rule is defined by Inter as "FW_PROCESS_SPLIT_R".

Section - Deconstructing windows

Deconstructing something is an activity on glk windows.

The basic deconstruction rule is listed in the for deconstructing rules.
The basic deconstruction rule is defined by Inter as "FW_DECONSTRUCT_WINDOW_R".

Chapter - Refreshing windows

To refresh (win - a glk window):
	safely carry out the refreshing activity with win;

To refresh all/-- windows:
	repeat with win running through on-screen non-buffering glk windows:
		refresh win;

Refreshing something is an activity on glk windows.
The refreshing activity has a glk window called the stored current focus window.

Before refreshing a glk window (called win) (this is the prepare for refreshing rule):
	now the stored current focus window is the current focus window;
	if win is on-screen:
		clear win;
		focus win;

A first for refreshing a glk window (called win) (this is the check the window is on-screen rule):
	if win is on-screen:
		continue the activity;

After refreshing a glk window (this is the refocus the current focus window rule):
	if the stored current focus window is not nothing and the stored current focus window is on-screen:
		focus the stored current focus window;
	otherwise:
		now the current focus window is the null window;

After constructing a glk window (called win) (this is the refresh the window rule):
	refresh win;

A glk event handling rule for a screen resize event (this is the refresh windows after screen resized rule):
	refresh all windows;

A glk event handling rule for a graphics window lost event (this is the refresh graphical windows rule):
	repeat with win running through on-screen graphical glk windows:
		refresh win;

A glk object updating rule (this is the refresh windows after restoring rule):
	refresh all windows;

Chapter - The current focus and active windows

[ Focus refers to where we are sending text right now. The "active window" is a broader concept, and is used to determine which window input requests will be made in, which window to return to after filling in the status window, etc. ]

The current focus window is a glk window variable.
The current focus window variable is defined by Inter as "current_focus_window".

[ The WindowFocus function from the Glk foundations will be augmented to remember the focus window. ]

The active window is a glk window variable.
The active window variable is defined by Inter as "active_window".

Before deconstructing a glk window (called win) (this is the fix the current windows rule):
	let parent be the spawner of win;
	if parent is nothing:
		continue the activity;
	if win is the active window:
		now the active window is parent;
	if win is the current focus window:
		now the current focus window is parent;



Part - Additional features

[ We include several non-core features which many authors will find useful ]

Chapter - Window background colours - unindexed

[ The Garglk extensions would probably be simpler than using stylehints, but unfortunately they are very broken in Garglk itself!
See https://github.com/garglk/garglk/issues/149 and https://intfiction.org/t/specifying-gargoyles-glk-extensions/12915/13 ]

[ We would prefer to have a colour that is not a valid RGB colour, but that is not currently possible. So I chose a colour that is close to Pantone 448 C (the "ugliest colour in the world"), but also not quite that, so that it's even less likely to be used by an author. ]
The unset colour is always #4A4123.

A glk window has an RGB colour called the background colour.
The background colour property is defined by Inter as "background_colour".
The background colour of a glk window is usually the unset colour.

[ For text windows we set the colour with stylehints. ]

Before constructing a textual glk window (called win) (this is the set the background colour of textual windows rule):
	if the background colour of win is not the unset colour:
		apply the background colour of win;

After constructing a textual glk window (called win) (this is the reset the background colour of textual windows rule):
	if the background colour of win is not the unset colour:
		unapply the background colour of win;

[ Setting the background color of graphics windows is handled by WindowClear which we will augment to handle background colours. It also allows you to change the background colour of graphics windows, but not text windows. That would be possible using the Garglk extensions if Garglk itself is ever fixed. Authors could try doing so themselves, at their own risk. ]

To apply the background colour of (W - a glk window):
	(- FW_Apply_Background_Colour({W}); -).

To unapply the background colour of (W - a glk window):
	(- FW_Unapply_Background_Colour({W}); -).

Chapter - Glulx Text Effects (for use with Glulx Text Effects by Emily Short)

[ This doesn't work, filed as https://inform7.atlassian.net/browse/I7-2644 ]
[The apply the Glulx Text Effects styles rule is not listed in the before starting the virtual machine rules.]

[ So instead just unapply them... ]
The unapply the Glulx Text Effects styles rule is listed after the apply the Glulx Text Effects styles rule in the before starting the virtual machine rules.
Before starting the virtual machine (this is the unapply the Glulx Text Effects styles rule):
	unapply styles for the not a glk window;

Before constructing a textual glk window (called win) (this is the apply window styles rule):
	apply styles for win;

After constructing a textual glk window (called win) (this is the unapply window styles rule):
	unapply styles for win;

Section - Unapplying styles - unindexed

To unapply styles for (W - glk window):
	repeat through the Table of User Styles:
		let window be the window entry;
		if window is all-buffer-windows:
			if W is not nothing and the window type of W is not text buffer window type:
				next;
		otherwise if window is all-grid-windows:
			if W is not nothing and the window type of W is not text grid window type:
				next;
		otherwise if window is not all-windows:
			if W is nothing or window is not W:
				next;
		if there is a background color entry:
			unapply window style (style name entry) stylehint 8;
		if there is a color entry:
			unapply window style (style name entry) stylehint 7;
		if there is a first line indentation entry:
			unapply window style (style name entry) stylehint 1;
		if there is a fixed width entry:
			unapply window style (style name entry) stylehint 6;
		if there is a font weight entry:
			unapply window style (style name entry) stylehint 4;
		if there is a indentation entry:
			unapply window style (style name entry) stylehint 0;
		if there is a italic entry:
			unapply window style (style name entry) stylehint 5;
		if there is a justification entry:
			unapply window style (style name entry) stylehint 2;
		if there is a relative size entry:
			unapply window style (style name entry) stylehint 3;
		if there is a reversed entry:
			unapply window style (style name entry) stylehint 9;

To unapply (W - a glk window) style (S - a glulx text style) stylehint (H - a number):
	(- FW_Unapply_Stylehint({W}.glk_window_type, {S}, {H}); -).

Chapter - Page margin

[ The "page margin" is not officially part of the Glk model, but many interpreters support it. The page margin exists outside any actual Glk windows. Some interpreters will change its colour when stylehints are used, so to reduce unexpected changes we will manually set it to the active window's background colour. ]

Last after constructing a textual glk window (this is the set the page margin colour rule):
	if the background colour of the active window is not the unset colour:
		set the page margin to the background colour of the active window;
	otherwise:
		set the page margin to its default;

To set the page margin to (C - RGB colour):
	(- glk_stylehint_set(wintype_TextBuffer, style_Normal, stylehint_BackColor, {C}); -).

Section - Page margin detection - unindexed

[ Unfortunately interpreters are not very consistent when trying to unset the page margin. So in interpreters that support it we will try to detect the default page margin colour. ]

The try to detect the default page margin colour rule is listed in the before starting the virtual machine rules.
The try to detect the default page margin colour rule is defined by Inter as "FW_DETECT_PAGE_MARGIN_COLOUR_R".

To set the page margin to its default:
	(- FW_Set_Default_Page_Margin_Colour(); -).

Chapter - Dynamic split methods - unindexed

[ A constrained window is a proportional window which could become fixed if its size is too big or small. ]
A glk window has a number called minimum size.
The minimum size property is accessible to Inter as "min_size".
A glk window has a number called maximum size.
The maximum size property is accessible to Inter as "max_size".

[ An aspect ratio graphics window tries to keep to a fixed aspect ratio. ]
A glk window has a real number called aspect ratio.
The aspect ratio property is accessible to Inter as "aspect_ratio".

Glk event handling rule for a screen resize event (this is the reprocess window split method rule):
	reprocess split method for the current root window and children;

To reprocess split method for (win - glk window) and children:
	reprocess split method for win;
	repeat with child running through on-screen glk windows spawned by win:
		reprocess split method for child and children;

To reprocess split method for (W - glk window):
	(- FW_Process_Split({W}); -).

Chapter - Screen measurement

The screen height measurement window is a graphics window.
The screen height measurement window is spawned by the main window.
The position of the screen height measurement window is placed left.
The split method of the screen height measurement window is fixed size.
The measurement of the screen height measurement window is 0.

The screen width measurement window is a graphics window.
The screen width measurement window is spawned by the main window.
The position of the screen width measurement window is placed above.
The split method of the screen width measurement window is fixed size.
The measurement of the screen width measurement window is 0.

Adjusted original screen height is a number variable.
Original screen width is a number variable.

After constructing the main window (this is the open the screen measurement windows rule):
	open the screen height measurement window;
	open the screen width measurement window;
	[ Save the screen height * 0.7 ]
	now adjusted original screen height is (the height of the screen height measurement window * 7) / 10;
	now original screen width is the width of the screen width measurement window;

To decide what number is the screen height in pixels:
	if the screen height measurement window is off-screen:
		issue the run-time problem "MainWindowNotOpen";
		say "*** Cannot get the screen height before the main window is open";
		decide on 0;
	decide on the height of the screen height measurement window;

To decide what number is the screen width in pixels:
	if the screen height measurement window is off-screen:
		issue the run-time problem "MainWindowNotOpen";
		say "*** Cannot get the screen width before the main window is open";
		decide on 0;
	decide on the width of the screen width measurement window;

To decide if the screen is landscape:
	if the screen height measurement window is off-screen:
		issue the run-time problem "MainWindowNotOpen";
		say "*** Cannot get the screen orientation before the main window is open";
		decide no;
	decide on whether or not the width of the screen width measurement window > the height of the screen height measurement window;

To decide if the screen is portrait:
	if the screen height measurement window is off-screen:
		issue the run-time problem "MainWindowNotOpen";
		say "*** Cannot get the screen orientation before the main window is open";
		decide no;
	decide on whether or not the height of the screen height measurement window > the width of the screen width measurement window;

To decide what real number is the screen aspect ratio:
	if the screen height measurement window is off-screen:
		issue the run-time problem "MainWindowNotOpen";
		say "*** Cannot get the screen aspect ratio before the main window is open";
		decide on 0.0;
	decide on (the width of the screen width measurement window times 1.0) divided by the height of the screen height measurement window;

To decide if there is probably a virtual keyboard on-screen:
	if the screen width in pixels is original screen width and the screen height in pixels < adjusted original screen height:
		decide yes;
	decide no;

Flexible Windows ends here.