Version 2/140731 of Simple HTML Window (for Glulx only) by Leonardo Boselli begins here. 

"Provides an HTML window in the left part of the screen, in which the player may write anything. Glulx only."

Include Version 7 of Glulx Entry Points by Emily Short.


Section 1 - The HTML Window

Show HTML window is a truth state that varies. Show HTML window is true.

Text of the HTML window is an indexed text that varies. Text of the HTML window is "".
This is the HTML window drawing rule:
	if show HTML window is false:
		rule fails;
	focus the HTML window;
	say "[text of the HTML window]";
	focus the main window 2;
	say "[run paragraph on]".

To update HTML window with (TXT - a text):
	now the text of the HTML window is TXT;
	follow the HTML window drawing rule;

Section 2 - I6/I7 Command Line Stuff

Include(-  
	Constant GG_HTMLWIN_ROCK = 301;
	Global gg_htmlwin = 0; 
-) before "Glulx.i6t".   

Before starting the virtual machine:
	do nothing. [Hack that, for complicated reasons, prevents character streams going to the wrong place at game startup under some conditions.]

When play begins (this is the HTML window construction rule):
	follow the HTML window drawing rule;

Check restarting the game: 
	destroy the HTML window;
	continue the action;

Check saving the game: 
	destroy the HTML window;
	continue the action;

Check restoring the game: 
	destroy the HTML window;
	continue the action;

To destroy the HTML window:
	(- DestroyHTMLWindow(); -)

To focus the HTML window:
	build the HTML window;
	set and clear HTML window;

To set and clear HTML window:
	(-
		if (gg_htmlwin ~= 0) {
			glk_set_window(gg_htmlwin);
			glk_window_clear(gg_htmlwin);
		}
	-)

To focus the main window 2:
	(- glk_set_window(gg_mainwin); -)

To build the HTML window:
	(- BuildHTMLWindow(); -)

Include (-

[ BuildHTMLWindow ;
	if (gg_htmlwin == 0) {
		gg_htmlwin = glk_window_open(gg_mainwin, (winmethod_Left+winmethod_Fixed), 17, wintype_TextGrid, GG_HTMLWIN_ROCK);
	}
];

[ DestroyHTMLWindow ;
	if(gg_htmlwin ~= 0) glk_window_close(gg_htmlwin,0);
	gg_htmlwin = 0;
];

-)


Simple HTML Window ends here.

---- Documentation ----

Simple HTML Window creates one text window 17 chars wide (120px). The window is placed below the main text window. 
