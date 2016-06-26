Version 1/111022 of Glimmr Debugging Console (for Glulx only) by Erik Temple begins here.

"Provides a dynamic console window for Glimmr debugging output."

Use authorial modesty.


Section - Window definition

The console-window is a text-buffer g-window spawned by the main-window.
 

Section - Window positioning

The position of the console-window is usually g-placebelow.


Section - Open console

To initiate the/-- Glimmr console:
	open up the console-window.

After constructing the console-window:
	If the current action is opening the g-console:
		continue the action;[We don't want to follow this rule if we've already opened the console using an action.]
	if console-window is g-present:
		say "[>console][bracket]Glimmr Console[close bracket]: Console initiated by source code directive.[unless the Glimmr debugging option is active][bracket]Glimmr Console[close bracket]: Automated logging may be disabled. If expected output does not appear, activate the Glimmr debugging use option.[end if][<]";
	otherwise:
		say "*** An unknown error prevented the Glimmr console window from opening.";
	continue the action.

To cease logging to Glimmr console:
	unless console-window is g-unpresent:
		shut down the console-window;
		unless console-window is g-unpresent:
			say "*** An unknown error prevented the Glimmr console window from closing.";


Section - Command to open the console

Opening the g-console is an action applying to nothing. Understand "open g-console" as opening the g-console.

Check opening the g-console:
	if console-window is g-present:
		say "The Glimmr console window is already open.";
		rule fails.

Carry out opening the g-console:
	say "Opening the Glimmr console window...";
	open up the console-window;
	if console-window is g-present:
		say "[>console][bracket]Glimmr Console[close bracket]: Console initiated by command-line input.[unless the Glimmr debugging option is active][bracket]Glimmr Console[close bracket]: Automated logging is disabled. To enable, activate the Glimmr debugging use option.[end if][<]";
		say "";[This seemingly useless line lets Inform get its paragraphing back on track.]
	otherwise:
		say "*** An unknown error prevented the Glimmr console window from opening."


Section - Command to close the console

Closing the g-console is an action applying to nothing. Understand "close g-console" as closing the g-console.

Check closing the g-console:
	if console-window is g-unpresent:
		say "The Glimmr console is already closed.";
		rule fails.

Carry out closing the g-console:
	shut down the console-window;
	if console-window is g-unpresent:
		say "Glimmr console window closed.";
	otherwise:
		say "*** An unknown error prevented the Glimmr console window from closing."


Section - Direct output to the console-window

The console output window is usually the console-window.



Glimmr Debugging Console ends here.


---- DOCUMENTATION ----

Glimmr Debugging Console is a simple extension that provides a separate window for Glimmr's debugging output, along with commands for opening and closing the window. It requires Glimmr Drawing Commands.

For the debugging console to be useful, the Glimmr debugging option must be set:

	Use Glimmr debugging.

If this option is not set, there will be no debugging output and thus nothing for the window to do!

The "console-window," as the window is called, is a Flexible Windows text-buffer g-window. By default, it will open below the main window, because Glimmr debugging statements tend to be long and so are more readable in a wide window. If we want to open the window in another position, we can specify it as we would for any other Flexible Windows window, e.g:

	The position of the console-window is g-placeright.


Section: Opening and closing the console-window

The console-window can be opened and closed either using commands in game, or by source code directive. To control the window from source code, use the following commands:

	initiate Glimmr console (opens the console window)
	cease logging to Glimmr console (closes the console window, safely)

To control the window in-game, type:

	OPEN G-CONSOLE
	CLOSE G-CONSOLE


Section: The console and the transcript

By default, windows other than the main window do not output content to the transcript. However, we may want to have Glimmr output information in our transcript. To do this, include this use option:

	Use Glimmr console transcript logging


Section: Credits

Glimmr Debugging Console is inspired by the console window in the GWindows system for Inform 6(http://gwindows.trenchcoatsoft.com/).


Section: Contact info

If you have comments about the extension, please feel free to contact me directly at ek.temple@gmail.com.

Please report bugs on the Google Code project page, at http://code.google.com/p/glimmr-i7x/issues/list.

For questions about Glimmr, please consider posting to either the rec.arts.int-fiction newsgroup or at the intfiction forum (http://www.intfiction.org/forum/). This allows questions to be public, where the answers can also benefit others. If you prefer not to use either of these forums, please contact me directly via email (ek.temple@gmail.com).

