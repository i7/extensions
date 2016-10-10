Hyperlinks by Dannii Willis begins here.

[ The old code from Flexible Windows ]

To call glk_request_hyperlink_event for (win - a g-window):
	(- glk_request_hyperlink_event( {win}.(+ ref number +) ); -).

To decide which number is the glk event window reference:
	(- ( gg_event-->1 ) -).

To decide which number is the glk event val1:
	(- ( gg_event-->2 ) -).

To decide which g-window is the glk event window:
	let N be the glk event window reference;
	repeat with win running through g-present g-windows:
		if N is the ref number of win:
			decide on win;
	decide on the acting main window;



Chapter - Hyperlinks

To say link (N - a number):
	(- if ( glk_gestalt( gestalt_Hyperlinks, 0 ) ) { glk_set_hyperlink( {N} ); } -).

To say end link:
	(- if ( glk_gestalt( gestalt_Hyperlinks, 0 ) ) { glk_set_hyperlink( 0 ); } -).

Processing hyperlinks for something is an activity on g-windows.
The processing hyperlinks activity has a number called the hyperlink ID.

After constructing a textual g-window (called win) (this is the request hyperlink events rule):
	if glk hyperlinks are supported:
		call glk_request_hyperlink_event for win;

A glulx input handling rule for a hyperlink-event (this is the default hyperlink handling rule):
	now the glulx replacement command is "";
	carry out the processing hyperlinks activity with the glk event window;
	if the glulx replacement command is not "":
		cancel line input in the main window;
		follow the command-showing rules;
		change the text of the player's command to the Glulx replacement command;
		now the glk event type is line-event;
		now the the glk event window ref is the ref number of the acting main window;
		now the glk event value 1 is the number of characters in the glulx replacement command;

Before processing hyperlinks (this is the prepare for processing hyperlinks rule):
	now the hyperlink ID is the glk event val1;

Last for processing hyperlinks (this is the default hyperlink command replacement rule):
	repeat through the Table of Glulx Hyperlink Replacement Commands:
		if the hyperlink ID is link ID entry:
			now the glulx replacement command is replacement entry;
			rule succeeds;
	now the glulx replacement command is "";

Table of Glulx Hyperlink Replacement Commands
link ID (number)	replacement (text)
--

After processing hyperlinks for a g-window (called win) (this is the request hyperlink events again rule):
	call glk_request_hyperlink_event for win;

Hyperlinks ends here.
