Version 16.0.0 of Flexible Windows (for Glulx only) by Jon Ingold begins here.

"Gives control over the Glk windows system in Glulx."

[ Version 16 is rewritten for Inform 11, and uses many new features. But for compatibility reasons the naming of things has been, as much as possible, left as it was. Some quirks in previous versions may have been made more regular however. ]

Use authorial modesty.



Part - I6 helpers - unindexed

[ Fix spurious line breaks from being printed in the main window after running the refreshing activity ]
To safely carry out the (A - activity on value of kind K) activity with (val - K):
	(- @push say__p; @push say__pc; CarryOutActivity({A}, {val}); @pull say__pc; @pull say__p; -).



Part - Windows

Chapter - Expanding the Glk window kind

[ In Inform 11 a Glk window kind is now build in, but we still need to add many additional properties. ]

Definition: a glk window is graphical rather than textual if the window type of it is graphics window type.
Definition: a glk window is buffering rather than non-buffering if the window type of it is text buffer window type.

A glk window has a glk window position called position.
The position property translates into Inter as "split_dir".
Definition: a glk window is vertically positioned rather than horizontally positioned if the position of it is at least placed above.

A glk window has a glk window split method called split method.
The split method property translates into Inter as "split_method".
The split method of a glk window is usually proportionally sized.

A glk window has a number called measurement.
The measurement property translates into Inter as "split_size".
The measurement of a glk window is usually 40.

A glk window can be either split with a border or split without a border.
The split with a border property translates into Inter as "split_border".
A glk window is usually split without a border.

A glk window can be required or unrequired.

Chapter - The spawning relationship

Spawning relates one glk window (called the spawner) to various glk windows.
The spawner property is accessible to Inter as "window_spawner".

The verb to spawn means the spawning relation.
The verb to be ancestral to implies the spawning relation.
The verb to be descended from implies the reversed spawning relation.

Chapter - The built in windows

[ TODO: add windows above the main window ]

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

Chapter - Object recovery

A reset glk references rule (this is the reset window properties rule):
	let i be 1000;
	repeat with win running through glk windows:
		if the rock number of win is 0:
			now the rock number of win is i;
			increase i by 10;
		now the glk window handle of win is 0;
		now win is not currently being processed;

The find existing windows rule is listed instead of the identify built in windows rule in the identify glk windows rules.
An identify glk windows rule (this is the find existing windows rule):
	let win be the window with rock number current glk object rock number;
	if win is not nothing:
		now the glk window handle of win is the current glk object reference number;

[ Recalibrate windows during GGRecoverObjects, however do not delete the main and status windows when restarting. ]
A first glk object updating rule (this is the recalibrate windows rule):
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

[ The Glk object recovery rules will iterate through all Glk windows, include pair windows which we don't track, so while generally we don't support Glk windows without an I7 representation, we have to here. ]
To decide which glk window is the invalid window:
	(- (nothing) -).

To decide which glk window is the window with rock number (rock - a number):
	if rock is not 0:
		repeat with win running through glk windows:
			if the rock number of win is rock:
				decide on win;
	decide on the invalid window;



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
			now the current root window is nothing;

Section - Root window - unindexed

The current root window is a glk window variable.
The current root window variable is defined by Inter as "current_root_window".

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

Before constructing a glk window (called win) (this is the fix the split method rule):
	let parent be the spawner of win;
	if parent is nothing:
		continue the activity;
	[ Check invalid measurement ]
	if the split method of win is proportionally sized:
		if the measurement of win > 100 or the measurement of win < 0:
			issue the run-time problem "InvalidProportionalMeasurement";
			say "*** Cannot open window with invalid proportionally sized measurement";
			now win is unrequired;
			abandon the constructing activity;
	[ Arrange windows automatically ]
	if the position of win is inherited:
		now the position of win is the position of parent;

The construct a g-window rule is listed in the for constructing rules.
The construct a g-window rule translates into I6 as "FW_ConstructGlkWindow".

First after constructing a glk window (called win) (this is the check if the window was created rule):
	if win is off-screen:
		now win is unrequired;
		rule fails;

Section - Deconstructing windows

Deconstructing something is an activity on glk windows.

The basic deconstruction rule is listed in the for deconstructing rules.
The basic deconstruction rule translates into I6 as "FW_DeconstructGlkWindow".

Chapter - Clearing and refreshing windows

[ The Glk foundations now has a clear window phrase. Do we need to do anything to augment it here? Perhaps to account for altered window background colours? ]

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
	if the stored current focus window is not nothing:
		focus the stored current focus window;
	otherwise:
		now the current focus window is nothing;

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

Flexible Windows ends here.