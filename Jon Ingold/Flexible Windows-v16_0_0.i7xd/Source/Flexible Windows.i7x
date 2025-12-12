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

[ In Inform 11 a glk window kind is now build in, but we still need to add many additional properties. ]

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

Spawning relates various glk windows to one glk window (called the spawner).

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
	if the no status line option is active:
		close the status window;
	otherwise:
		open the status window;
	close the quite window;
	continue the activity;



Part - The Flexible Windows API

Chapter - Opening and closing windows

To open up/-- (win - a glk window), as the acting main window:
	if win is off-screen and (win is the main window or the main window is ancestral to win):
		now win is required;
		now every glk window ancestral to win is required;
		calibrate windows;
		if as the acting main window:
			set win as the acting main window;

To close (win - a glk window):
	if win is on-screen:
		now win is unrequired;
		now every glk window descended from win is unrequired;
		calibrate windows;

Section - Calibrating windows - unindexed

A glk window can be currently being processed.

Definition: a glk window is parental rather than childless if it spawns an on-screen glk window.

Definition: a glk window is next-step if it is the main window or it is spawned by something on-screen.

To calibrate windows:
	[ Close windows that shouldn't be open, and then open windows that shouldn't be closed ]
	while there is a not currently being processed unrequired on-screen childless glk window (called win):
		[ Only run each window once, even if we end up back in this loop (by open/close being called in a before rule), to prevent infinite loops ]
		now win is currently being processed;
		safely carry out the deconstruction activity with win;
		now win is not currently being processed;
	while there is a not currently being processed required off-screen next-step glk window (called win):
		now win is currently being processed;
		safely carry out the construction activity with win;
		now win is not currently being processed;

Section - Constructing a window

Constructing something is an activity on glk windows.

Before constructing a glk window (called win) (this is the fix the split method rule):
	let parent be the spawner of win;
	if parent is nothing:
		continue the activity;
	[ Check invalid measurement ]
	if the split method of win is proportionally sized:
		if the measurement of win > 100 or the measurement of win is < 0s:
			issue the run-time problem "InvalidProportionalMeasurement";
			say "*** Cannot open window with invalid proportionally sized measurement";
			now win is unrequired;
			abandon the constructing activity;
	[ Tile windows automatically ]
	if the position of win is inherited:
		now the position of win is the position of parent;
	[ TODO: using minimum method ]

The construct a g-window rule is listed in the for constructing rules.
The construct a g-window rule translates into I6 as "FW_ConstructGlkWindow".

First after constructing a glk window (called win) (this is the check if the window was created rule):
	if win is off-screen:
		now win is unrequired;
		rule fails;

Section - Deconstructing windows

Deconstructing something is an activity on g-windows.

The basic deconstruction rule is listed in the for deconstructing rules.
The basic deconstruction rule translates into I6 as "FW_DeconstructGlkWindow".

Flexible Windows ends here.