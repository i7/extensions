Version 2/140731 of Command Line (for Glulx only) by Leonardo Boselli begins here. 

"Provides a command line in the bottom part of the screen, in which the player finds the most common commands. Glulx only."

Include Version 7 of Glulx Entry Points by Emily Short.


Section 1 - The Command Line

Show command line is a truth state that varies. Show command line is true.

Every turn:
	follow the command line drawing rule;
	continue the action.

Definition: a room is discernible: 
	if in darkness, no;
	yes;

To say top rose:
	let place be the room up from the location;
	if the place is a discernible room, say "[set link 11][if the place is visited]u [else]U [end if][end link]"; otherwise say "* ";
	let place be the room northwest from the location;
	if place is a discernible room, say "[set link 19][if the place is visited]nw[else]NW[end if][end link]"; otherwise say "**";
	let place be the room north from the location;
	if place is a discernible room, say "[set link 12][if the place is visited] n [else] N [end if][end link]"; otherwise say " * ";
	let place be the room northeast from the location;
	if place is a discernible room, say "[set link 13][if the place is visited]ne[else]NE[end if][end link] "; otherwise say "** ";

To say middle rose:
	say "  ";
	let place be the room west from the location;
	if place is a discernible room, say "[set link 18][if the place is visited]w [else]W [end if][end link]"; otherwise say "* ";
	say " X ";
	let place be the room east from the location;
	if place is a discernible room, say "[set link 14][if the place is visited] e[else] E[end if][end link] "; otherwise say " * ";

To say bottom rose:
	let place be the room down from the location;
	if the place is a discernible room, say "[set link 20][if the place is visited]d [else]D [end if][end link]"; otherwise say "* ";
	let place be the room southwest from the location;
	if place is a discernible room, say "[set link 17][if the place is visited]sw[else]SW[end if][end link]"; otherwise say "**";
	let place be the room south from the location;
	if place is a discernible room, say "[set link 16][if the place is visited] s [else] S [end if][end link]"; otherwise say " * ";
	let place be the room southeast from the location;
	if place is a discernible room, say "[set link 15][if the place is visited]se[else]SE[end if][end link] "; otherwise say "** ";

Section 1a - Drawing Rule (for use with Automap by Mark Tilford)

This is the command line drawing rule:
	if show command line is false:
		rule fails;
	focus the command window;
	say "[fixed letter spacing][top rose] |[set link 2]look[end link]  |[set link 3]inventory[end link]|[set link 7]x me[end link][line break][middle rose] |" (A);
	if object hyperlink highlighting is true:
		say "[set link 5]things[end link]|" (B);
	if direction hyperlink highlighting is true:
		say "[set link 6]exits[end link]    |" (C);
	if topic hyperlink highlighting is true:
		say "[set link 4]topics[end link]" (D);
	say "[line break][bottom rose] |[set link 8]save[end link]  |[set link 9]restore[end link]  |" (E);
	say "[set link 10]zoom[end link][variable letter spacing][no line break]" (F);
	focus the main window;
	say "[run paragraph on]".


Section 1b - Drawing Rule (for use without Automap by Mark Tilford)

This is the command line drawing rule:
	if show command line is false:
		rule fails;
	focus the command window;
	say "[fixed letter spacing][top rose] |[set link 2]look[end link]  |[set link 3]inventory[end link]|[set link 7]x me[end link][line break][middle rose] |" (A);
	if object hyperlink highlighting is true:
		say "[set link 5]things[end link]|" (B);
	if direction hyperlink highlighting is true:
		say "[set link 6]exits[end link]    |" (C);
	if topic hyperlink highlighting is true:
		say "[set link 4]topics[end link]" (D);
	say "[line break][bottom rose] |[set link 8]save[end link]  |[set link 9]restore[end link]  |[variable letter spacing][no line break]"(E);
	if true is false:
		say "***" (F);
	focus the main window;


Section 2 - I6/I7 Command Line Stuff

Include(-  
	Constant GG_CMDWIN_ROCK = 300;
	Global gg_cmdwin = 0; 
-) before "Glulx.i6t".   

Before starting the virtual machine:
	do nothing. [Hack that, for complicated reasons, prevents character streams going to the wrong place at game startup under some conditions.]

When play begins (this is the command line construction rule):
	follow the command line drawing rule;

Check restarting the game: 
	destroy the command window;
	follow the set hyperlink command prompt rule;
	continue the action;

Check saving the game: 
	destroy the command window;
	follow the set hyperlink command prompt rule;
	continue the action;

Check restoring the game: 
	destroy the command window;
	follow the set hyperlink command prompt rule;
	continue the action;

To destroy the command window:
	(- DestroyCommandLine(); -)

To set the command line prompt:
	now the command prompt is ">";

To focus the command window:
	if command line build result is 1:
		set the command line prompt;
	set and clear command window;

To set and clear command window:
	(-
		if (gg_cmdwin ~= 0) {
			glk_set_window(gg_cmdwin);
			glk_window_clear(gg_cmdwin);
		}
	-)

To focus the main window:
	(- glk_set_window(gg_mainwin); -)

To clear the main window:
	(- glk_window_clear(gg_mainwin); -)

To decide which number is command line build result:
	(- BuildCommandLine() -)

Include (-

[ BuildCommandLine ;
	if (gg_cmdwin == 0) {
		gg_cmdwin = glk_window_open(gg_mainwin, (winmethod_Below+winmethod_Fixed), 3, wintype_TextGrid, GG_CMDWIN_ROCK);
		if (glk_gestalt(gestalt_Hyperlinks, 0)) glk_request_hyperlink_event(gg_cmdwin);
		return 1;
	}
	return 0;
];

[ DestroyCommandLine ;
	if(gg_cmdwin ~= 0) glk_window_close(gg_cmdwin,0);
	gg_cmdwin = 0;
];

-)

Section 3 - Hyperlinks Manager

[Heavily based on Basic Hyperlinks by Emily Short]

When play begins:
	start looking for status hyperlinks;

To start looking for status hyperlinks:
	(-
		if (glk_gestalt(gestalt_Hyperlinks, 0)) glk_request_hyperlink_event(gg_cmdwin);
	-)
	
A glulx hyperlink rule (this is the default command and status hyperlink setting rule):
	perform glulx command and status hyperlink request.

To perform glulx command and status hyperlink request:
	(-
		if (glk_gestalt(gestalt_Hyperlinks, 0)) {
			setlink(); 
			if(gg_cmdwin ~= 0) playCommandHyperlink(gg_event-->2);
			playStatusHyperlink(gg_event-->2);
		}
	-)

Include (-

[ playCommandHyperlink n;
	(+ current link number +) = n;
	if (n > 0) { 
		glk_cancel_hyperlink_event(gg_cmdwin);
		FollowRulebook( (+ clicking hyperlink rules +) ); 
		if (glk_gestalt(gestalt_Hyperlinks, 0)) glk_request_hyperlink_event(gg_cmdwin);
	};
];

[ playStatusHyperlink n;
	(+ current link number +) = n;
	if (n > 0) { 
		glk_cancel_hyperlink_event(gg_statuswin);
		FollowRulebook( (+ clicking hyperlink rules +) ); 
		if (glk_gestalt(gestalt_Hyperlinks, 0)) glk_request_hyperlink_event(gg_statuswin);
	};
];

-)


Command Line ends here.

---- Documentation ----

Command Line creates one text window and writes a compass and the most common commands in it. The window is placed below the main text window. 
