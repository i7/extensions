Version 2/140731 of Command Line (for Glulx only) by Leonardo Boselli begins here. 

"Provides a command line in the bottom part of the screen, in which the player finds the most common commands. Glulx only."

Include Version 7 of Glulx Entry Points by Emily Short.


Section 1 - The Command Line

After going to a room:
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
	if place is a discernible room, say "[set link 18][if the place is visited]w [else]W [end if][end link] "; otherwise say "* ";
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
	focus the command window;
	clear the command window;
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


Section 1b - Drawing Rule (for use without Automap by Mark Tilford)

This is the command line drawing rule:
	focus the command window;
	clear the command window;
	say "[fixed letter spacing][top rose] |[set link 2]look[end link]  |[set link 3]inventory[end link]|[set link 7]x me[end link][line break][middle rose] |" (A);
	if object hyperlink highlighting is true:
		say "[set link 5]things[end link]|" (B);
	if direction hyperlink highlighting is true:
		say "[set link 6]exits[end link]    |" (C);
	if topic hyperlink highlighting is true:
		say "[set link 4]topics[end link]" (D);
	say "[line break][bottom rose] |[set link 8]save[end link]  |[set link 9]restore[end link]  |"(E);
	if true is false:
		say "[set link 10]zoom[end link][variable letter spacing][no line break]" (F);
	focus the main window;


Section 2 - I6/I7 Command Line Stuff

Include(-  
	Constant GG_CMDWIN_ROCK = 200;
	Global gg_cmdwin = 0; 
-) before "Glulx.i6t".   

Before starting the virtual machine:
	do nothing. [Hack that, for complicated reasons, prevents character streams going to the wrong place at game startup under some conditions.]

When play begins (this is the command line construction rule):
	build the command window;
	follow the command line drawing rule;
	now the command prompt is ">";

Carry out restarting the game: 
	destroy the command window;
	continue the action;

To destroy the command window:
	(-
		glk_window_close(gg_cmdwin,0);
		gg_cmdwin = 0;
	-)

To build the command window:
	(-
		if (gg_cmdwin == 0) gg_cmdwin = glk_window_open(gg_mainwin, (winmethod_Below+winmethod_Fixed), 3, wintype_TextGrid, GG_CMDWIN_ROCK);
	-)

To focus the command window:
	(-  if (gg_cmdwin ~= 0) glk_set_window(gg_cmdwin);  -)

To clear the command window:
	(-  if (gg_cmdwin ~= 0) glk_window_clear(gg_cmdwin);  -)

To focus the main window:
	(- glk_set_window(gg_mainwin); -)

To clear the main window:
	(- glk_window_clear(gg_mainwin); -)


Section 3 - Hyperlinks Manager

[Heavily based on Basic Hyperlinks by Emily Short]

When play begins:
	start looking for command hyperlinks;
	start looking for status hyperlinks;

To start looking for command hyperlinks:
	(- SetCommandLink(); -)
	
To start looking for status hyperlinks:
	(- SetStatusLink(); -)
	
A glulx hyperlink rule (this is the default command hyperlink setting rule):
	perform glulx command hyperlink request.

A glulx hyperlink rule (this is the default status hyperlink setting rule):
	perform glulx status hyperlink request.

To perform glulx command hyperlink request:
	(-  if (glk_gestalt(gestalt_Hyperlinks, 0)) DoCommandLink(); -)

To perform glulx status hyperlink request:
	(-  if (glk_gestalt(gestalt_Hyperlinks, 0)) DoStatusLink(); -)

Include (-
 [ DoCommandLink;
	setlink(); 
	playCommandHyperlink(gg_event-->2);
 ]; 

 [ DoStatusLink;
	setlink(); 
	playStatusHyperlink(gg_event-->2);
 ]; 

[ playCommandHyperlink n;
	(+ current link number +) = n;
	if (n > 0) { 
		glk_cancel_hyperlink_event(gg_cmdwin);
		FollowRulebook( (+ clicking hyperlink rules +) ); 
		SetCommandLink();
	};
];

[ playStatusHyperlink n;
	(+ current link number +) = n;
	if (n > 0) { 
		glk_cancel_hyperlink_event(gg_statuswin);
		FollowRulebook( (+ clicking hyperlink rules +) ); 
		SetStatusLink();
	};
];

[ SetCommandLink ;
	if (glk_gestalt(gestalt_Hyperlinks, 0)) glk_request_hyperlink_event(gg_cmdwin);
];

[ SetStatusLink ;
	if (glk_gestalt(gestalt_Hyperlinks, 0)) glk_request_hyperlink_event(gg_statuswin);
];

-)


Command Line ends here.

---- Documentation ----

Command Line creates one text window and writes a compass and the most common commands in it. The window is placed below the main text window. 
