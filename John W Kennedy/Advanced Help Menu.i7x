Advanced Help Menu by John W Kennedy begins here.

"Builds on Emily Short's Basic Help Menu, with hints that are enabled under program control and sample transcriptions"

Include Basic Help Menu by Emily Short.

To activate hint (H - table-name):
	if H is a subtable listed in the table of all hints begin;
		choose row with a subtable of H in the Table of all hints;
		let M be the parent subtable entry;
		let T be the title entry;
		blank out the whole row;
		choose a blank row in M;
		change the title entry to T;
		change the subtable entry to H;
		change toggle entry to the hint toggle rule;
	end if.

To activate hint menu (M - table-name):
	if M is a menu listed in the table of all hint menus begin;
		choose row with a menu of M in the Table of all hint menus;
		let P be the parent subtable entry;
		let T be the title entry;
		blank out the whole row;
		choose a blank row in P;
		change the title entry to T;
		change the subtable entry to M;
	end if.

This is the sample-transcript rule:
	clear the screen;
	choose row current menu selection in the current menu;
	let the transcription be the subtable entry;
	repeat through the transcription begin;
		say the sample text entry;
		say paragraph break;
	end repeat;
	say "Press SPACE to return to the menu.";
	wait for the SPACE key;
	redraw status line;

Advanced Help Menu ends here.


---- DOCUMENTATION ----

This first requires that the following two tables be created. The tables themselves must be as given, but the contents depend on the game. The first table gives a list of all hint menus except the master hint menu (here called "Table of general hints". The second table gives a list of all hints

	Table of all hint menus
	menu	title	parent subtable
	Table of Somerset hints	"In Somerset Town"	Table of general hints
	Table of Enchanted Forest hints	"In the Enchanted Forest"	Table of general hints

	Table of all hints
	subtable	title	parent subtable
	Table of forest entry hints	"How can I enter the Forest?"	Table of Somerset hints
	Table of goblet hints	"What can I do with the goblet?"	Table of Somerset hints
	Table of tavern hints	"What should I do at the Full Moon Tavern?"	Table of Enchanted Forest hints

In addition to these, the actual hint tables must be created, just as in Emily Short's basic system, and the hint menus can be created. Note that each hint menu must be created with sufficient blank rows, or there will be an error at run time.

	To activate any hint,
		Activate hint (hint-table-name).
	To activate any hint menu,
		Activate hint menu (hint-menu-name).

A further feature is that one or more sample transcripts can be created. To do so, put in a help menu a row such as this.

	"Sample transcription"	Table of the sample	--	sample-transcript rule

A sample-transcription table contains a column called "sample text", filled with material to be emitted. Each one will be displayed with a trailing paragraph break.

Example: * Samplex - A small game mostly consisting of such help.

	"Samplex" by John W Kennedy

	Include Advanced Help Menu by John W Kennedy.

	When play begins:
		choose row 1 in Table of Basic Help Options;
		change description entry to "This is a demonstration of John W. Kennedy's Advanced Help Menu.";
		activate hint menu Table of Entrance hints menu;
		activate hint Table of entering hints.

	The Cave Entrance is a room.
	"You are outside a cave, which is south of you."
	South is the Cave Interior.

	The Cave Interior is a room.
	"This is the interior of the cave."
	After going in the Cave Interior:
		activate hint menu Table of Cave hints menu;
		activate hint Table of opening hints;
		continue the action.

	The treasure chest is an openable closed container in the Cave Interior.
	After opening the treasure chest:
		end the game in victory.

	Table of Basic Help Options (continued)
	title	subtable	description	toggle
	"Setting options"	Table of Setting Options
	"Sample transcript"	Table of a sample transcript	--	sample-transcript rule
	"Hints"	Table of general hint menus

	Table of a Sample Transcript
	sample text
	"[italic type]This is not a transcript from [bold type]Samplex[roman type][italic type], but illustrates the sort of thing that can happen.[roman type]"
	"[bold type]Bedroom[roman type][line break]This is your bedroom. The kitchen is to your east."
	">inventory"
	"You are holding a mousetrap."
	">east"
	"[bold type]Kitchen[roman type][line break]This is your kitchen. Tiny black dots on the floor confirm your worst fears."
	">put the mousetrap on the floor"
	"That would be pointless, as the mousetrap is not set."

	Table of all hint menus
	menu	title	parent subtable
	Table of Entrance hints menu	"At the cave entrance"	Table of general hint menus
	Table of Cave hints menu	"In the cave"	Table of general hint menus

	Table of general hint menus
	title	subtable	description	toggle
	--	a table-name	--	a rule
	with 1 blank row. [2 blank rows total]

	Table of Entrance hints menu
	title	subtable	description	toggle
	--	a table-name	--	a rule
	[1 blank row total]

	Table of Cave hints menu
	title	subtable	description	toggle
	--	a table-name	--	a rule
	[1 blank row total]

	Table of all hints
	subtable	title	parent subtable
	Table of entering hints	"How can I enter the cave?"	Table of Entrance hints menu
	Table of opening hints	"How can I open the chest?"	Table of Cave hints menu

	Table of entering hints
	hint	used
	"Well, you could simply wish yourself into the cave."	a number
	"Something simpler would work better."
	"Just go south."

	Table of opening hints
	hint	used
	"Just open it!"	a number
