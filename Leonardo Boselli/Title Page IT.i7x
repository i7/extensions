Version 2 of Title Page IT by Leonardo Boselli begins here.

"Fornisce un pannello introduttivo al gioco, con un menù, la possibilità di caricare e ricominciare, una citazione e (in Glulx) una figura. Semplicemente tradotto dall'originale."

"basato su Version 2 of Title Page by Jon Ingold."

section 1 - inclusions

Include Menus IT by Leonardo Boselli.
Include Basic Screen Effects by Emily Short. 

section 2 - definitions

[The quotation is some text that varies. The quotation is "[story headline]".]

To say quotation: say story headline.

The intro menu is a table-name that varies. [The intro menu is the Table of Sample Options.]

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

[AGGIUNTO...]

To display (chosen figure - a figure-name) centered:
	say roman type; say " ";
	display chosen figure inline;
	say " [line break]"; 
	say roman type;
	
To display (chosen figure - a figure-name) inline:
	(- DrawInline({chosen figure}); -)

Include (-
[ DrawInline N;
	glk_image_draw(gg_mainwin, ResourceIDsOfFigures-->N,  imagealign_InlineUp, 0);
]; 
-)

[... IN MODO DA NON INCLUDERE]
[Include Glulx Image Centering by Emily Short.]

Figure opening figure is the file "Cover.jpg".
To display art if appropriate: 
	display figure opening figure centered;

Section 3b - no cover art (for Z-machine only)

To display art if appropriate: do nothing.


Section 4a - title screen rule

TITLEPAGE-DISPLAY-ART is a truth state that varies. TITLEPAGE-DISPLAY-ART is true;

The first when play begins rule (this is the title screen rule):
while true is true begin;
	clear the screen;
	redraw status line;
	say "[line break]       [bold type][story title][roman type]";
	[centre "[story title]", bold;]
	say "[line break]          di [story author]";
	[centre "   di [story author]";]
	say paragraph break;
	if TITLEPAGE-DISPLAY-ART is true begin;
		display art if appropriate;
		say line break;
	end if;
	say fixed letter spacing;
	say "   [quotation]";
	[centre "[quotation]", italic;]
	say roman type;
	say paragraph break;
	say fixed letter spacing;
	say "       M   :   Mostra il menù d[']aiuto[line break]";
	say "   (SPAZIO):   Inizia la storia dall[']inizio[line break]";
	say "       R   :   Continua una storia salvata[line break]";
	say "       Q   :   Esci[line break]";  
	say variable letter spacing;       
	let k be 0;
	while k is 0 begin;
		let k be the chosen letter;
	end while;
	if k is 13 or k is 31 or k is 32 begin;
		clear the screen; 
		redraw status line;
		make no decision;
	otherwise if k is 113 or k is 81;
		stop game abruptly;
	otherwise if k is 82 or k is 114;
		follow the restore the game rule;
	otherwise if k is 109 or k is 77;
		now the current menu is the intro menu;
		carry out the displaying activity;
	end if;
	say "Premi SPAZIO per continuare.";
	wait for SPACE key;
end while;


Title Page IT ends here.

---- DOCUMENTATION ----

Vedi la documentazione originale in Version 2 of Title Page by Jon Ingold.
