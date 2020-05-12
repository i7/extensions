Version 4/200510 of Title Page by Jon Ingold begins here.

"Provides an intro panel to the game, offering a menu, a restore and restart prompt, a quotation and (under Glulx) a picture. Updated to version 3 for compatibility with Inform 6L02 and later by Emily Short.  Updated to version 4 by Gavin Lambert to fix an error with 'use skip intro'."

section 1 - inclusions

Include Menus by Emily Short. 
Include Basic Screen Effects by Emily Short. 

section 2 - definitions

Use menus translates as (- Constant USE_MENUS; -). 
Use skip intro translates as (- Constant Skip_Intro; -).
Use cover art title display translates as (- Constant COVER_ART_TITLE_DISPLAY; -).

[The quotation is some text that varies. The quotation is "[story headline]".]

To say quotation: say story headline.

The intro menu is a table-name that varies. The intro menu is the Table of Sample Options.

To centre (t - an indexed text), bold or italic:
	let N be the number of characters in T;
	say spaces to centre N;
	if bold, say bold type;
	if italic, say italic type;
	say T;
	say roman type.

To say spaces to centre (n -  a number) -- running on:
(- 	print "^"; spaces (((VM_ScreenWidth() - {n})/2)-1); 
-)

Section 3 - cover art (for Glulx only)

Figure opening figure is a figure-name that varies. 

Include Glulx Image Centering by Emily Short. 

To display art if appropriate: 	
	if cover art title display option is active:
		display figure opening figure centered;

Section 3b - no cover art (for Z-machine only)

To display art if appropriate: do nothing.

Section 4a - title screen rule


Title-debugging is a truth state that varies. Title-debugging is false.

The first when play begins rule (this is the title screen rule):
	if the skip intro option is active:
		if title-debugging is true:
			make no decision;
	while 1 is 1:
		clear the screen;
		redraw status line;
		centre "[story title]", bold;
		centre "   by [story author]";
		say paragraph break;
		display art if appropriate;
		say line break;
		say fixed letter spacing;
		centre "[quotation]", italic;
		say roman type;
		say paragraph break;
		say fixed letter spacing;
		if the menus option is active:
			say "   Display help menu                       :       M[line break]" (A);
		say "   Start the story - from the beginning    :    (SPACE)[line break]" (B);
		say "                   - from a saved position :       R[line break]" (C);
		say "   Quit                                    :       Q[line break]" (D);  
		say variable letter spacing;       
		let k be 0;
		while k is 0:
			let k be the chosen letter;
		if k is 13 or k is 31 or k is 32:
			clear the screen; 
			make no decision;
		otherwise if k is 113 or k is 81:
			stop game abruptly;
		otherwise if k is 82 or k is 114:
			follow the restore the game rule;
		otherwise if k is 109 or k is 77:
			if the menus option is active:
				now the current menu is the intro menu;
				carry out the displaying activity;
		pause the game.
	

Section 5 - the debug option - not for release

This is the set debugging rule:
	now title-debugging is true.
 
The set debugging rule is listed before the title screen rule in the when play begins rules.

Title Page ends here.

---- DOCUMENTATION ----

Title Page inserts a intro page to your project. This prints the name and by-line of the game, followed by a quotation - by default this is the game's "headline", but you can change it by declaring:

	To say quotation:
		say "...."

This needs to come after the extension is included. (Note: you must declare exactly "To say quotation", with no "the").

If you're compiling a Glulx project, Title Page can also display the cover.jpg file as stored in the "Materials" folder of the project. To include this feature, add

	Use cover art title display.

It then provides a menu of options: start a new game, restore a saved game and quit. You can also make it display a "show menu" option by setting the menus option and setting the intro menu.

	Use menus.
	
	This is the set intro rule:
		now the intro menu is the Table of Introductory Information.
 
	The set intro rule is listed before the title screen rule in the when play begins rules.

Note that the extension always includes the extension Menus that ships with Inform, and so this framework should be used for writing Menu tables.

If we want to change the phrasing of the menu, we can do so by setting responses A through D of the title screen rule. The only challenge here is that this response has to be set before the title screen runs, so just "when play begins" won't do -- again, we need to change this response before the title screen rule fires, thus:
	
	This is the set response rule:
		now the title screen rule response (A) is "   Show me introductory text                      :       M[line break]"
 
	The set response rule is listed before the title screen rule in the when play begins rules. 
	
Since the letters for selecting particular outcomes are hard-coded, we can't change these letter options at the moment.

Finally, for debug project (specifically, those in the testing panel) it can be tedious to start the game with an intro panel every time (and indeed, the "restore" option doesn't work in the test pane of the I7 application). Therefore an option is provided to skip the intro on debug versions, but still include it on released versions. 

	Use skip intro.


Example: * Extra Info - Adding an informational section for the player to read before play.

Sometimes we want to offer the player advice about how to play or provide some content warnings about the story they're about to experience.

	*: "Extra Info" by Emily Short.
	
	Limbo is a room.
	
	Include Title Page by Jon Ingold.
	
	Use menus.
	
	This is the set intro rule:
		now the intro menu is the Table of Introductory Information;
		now the title screen rule response (A) is "Introduction (recommended to new players)  :       M[line break]".
	 
	The set intro rule is listed before the title screen rule in the when play begins rules.
	
	Table of Introductory Information
	title	subtable	description	toggle
	"Special Commands"	--	"This game has a VERBS command. At any time, VERBS will list verbs that you could use in play."	-- 
	"Warnings"	--	"This game contains Strong Language and Graphic Violence. It may not be suitable for younger audiences. Please use your own discretion in deciding whether this is right for you."	-- 
	 
