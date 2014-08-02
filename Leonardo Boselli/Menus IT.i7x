Version 3 of Menus IT by Leonardo Boselli begins here.

"A table-based way to display full-screen menus to the player. Semplicemente tradotto in italiano."

"basato su Version 3 of Menus by Emily Short."

Use authorial modesty.

Include Basic Screen Effects by Emily Short.

Section 1

Menu depth is a number that varies. Menu depth is 0.

The endnode flag is a number that varies. The endnode flag is 0.

The current menu title is text that varies. The current menu title is "Istruzioni".

Table of Sample Options
title	subtable	description	toggle
"foo"	a table-name	"bar"	a rule

Current menu is a table-name that varies. The current menu is the Table of Sample Options.

Current menu selection is a number that varies. Current menu selection is 1.

Table of Menu Commands
number	effect
78	move down rule
110	move down rule
80	move up rule
112	move up rule
81	quit rule
113	quit rule
13	select rule
32	select rule
130	move down rule
129	move up rule
27	quit rule

This is the quit rule:  
	now menu depth is menu depth - 1;
	rule succeeds. 

This is the move down rule: 
	if current menu selection is less than the number of filled rows in the current menu, now current menu selection is current menu selection + 1;
	reprint the current menu;
	make no decision.

This is the move up rule:
	if current menu selection is greater than 1, now current menu selection is current menu selection - 1;
	reprint the current menu;
	make no decision.

This is the select rule:  
	choose row current menu selection in the current menu;
	if there is a toggle entry
	begin;
		follow the toggle entry; reprint the current menu;
	otherwise;
		if there is a subtable entry
		begin;
			now the current menu title is title entry;
			now the current menu selection is 1; 
			now the current menu is subtable entry;
			show menu contents;
		otherwise;
			let the temporary title be the current menu title;
			now the current menu title is title entry;
			now the endnode flag is 1;
			redraw status line;
			now the endnode flag is 0;
			clear only the main screen;
			say "[variable letter spacing][description entry][paragraph	 break]";
			say "Premi SPAZIO per continuare."; 
			wait for the SPACE key;
			now the current menu title is temporary title;
			reprint the current menu;
		end if;
	end if.
	

To redraw status line:
	(- DrawStatusLine(); -)

Displaying is an activity.

To reprint (selected menu - a table-name):
	redraw status line;
	say fixed letter spacing;
	let __index be 1;
	clear only the main screen;
	repeat through selected menu
	begin;
		if __index is current menu selection, say " >"; otherwise say "  ";
		say " [title entry][line break]";
		now __index is __index + 1;
	end repeat;
	say variable letter spacing;

To show menu contents:
	now menu depth is menu depth + 1;
	let temporary depth be the menu depth;
	let temporary menu be the current menu;
	let temporary title be the current menu title;
	let __x be 0;
	let __index be 0;
	while __index is not 1
	begin;
		now the current menu is the temporary menu; 
		let __n be 0;
		repeat through current menu
		begin;
			increase __n by 1;
			if title entry is current menu title, now current menu selection is __n;
		end repeat;
		now the current menu title is the temporary title; 
		reprint current menu;
		let __x be the chosen letter;
		if __x is a number listed in the Table of Menu Commands
		begin;
			follow the effect entry; 
			if temporary depth > menu depth
			begin;
				now __index is 1; 
			end if;
		end if;
	end while.

Rule for displaying (this is the basic menu contents rule): 
	now current menu selection is 1;
	show menu contents.

Rule for constructing the status line while displaying (this is the constructing status line while displaying rule):  
	if the endnode flag is 0,
		fill status bar with Table of Deep Menu Status;
	otherwise fill status bar with Table of Shallow Menu Status; 
	rule succeeds.

Table of Shallow Menu Status
left	central	right
""	"[current menu title]"	""

Table of Deep Menu Status
left	central	right
""	"[current menu title]"	""
" N = Successivo"	""	"Q = [if menu depth > 1]Ultimo Menù[otherwise]Ritorna[end if]"
" P = Precedente"	""	"INVIO = Scegli"

Table of Sample Hints
hint	used
"Semplice suggerimento"	a number

To say known hints from (hint booklet - table-name):
	let __index be 0;
	clear only the main screen; 
	repeat through hint booklet
	begin;
		now __index is __index + 1;
		if there is a used entry
		begin;
			say "[__index]/[number of rows in hint booklet]: [hint entry][paragraph break]";
		otherwise;
			if __index is 1
			begin;
				now used entry is turn count;
				say "[__index]/[number of rows in hint booklet]: [hint entry][paragraph break]";
			end if;
		end if;
	end repeat; 
	say "Premi SPAZIO per tornare al menù o H per rivelare un altro suggerimento."


To say hints from (hint booklet - table-name): 
	let __index be 0;
	clear only the main screen; 
	repeat through hint booklet
	begin;
		now __index is __index + 1;
		say "[__index]/[number of rows in hint booklet]: [hint entry][paragraph break]"; 
		if there is a used entry
		begin;
			do nothing;
		otherwise;
			now used entry is turn count;
			say "Premi SPAZIO per tornare al menù[if __index < number of rows in hint booklet] o H per rivelare un altro suggerimento[end if].";
			make no decision; 
		end if;  
	end repeat; 
	say "Premi SPAZIO per tornare al menù[if __index < number of rows in hint booklet] o H per rivelare un altro suggerimento[end if]."

This is the hint toggle rule:
	choose row current menu selection in the current menu;
	let the temporary title be the current menu title;
	now the current menu title is title entry;
	now the endnode flag is 1;
	redraw status line;
	now the endnode flag is 0;
	say known hints from the subtable entry; 
	let __index be 0;
	while __index < 1
	begin;
		let __x be the chosen letter;
		if __x is 13 or __x is 31 or __x is 32, let __index be 1;
		if __x is 72 or __x is 104, say hints from the subtable entry;
	end while;
	now the current menu title is temporary title.

Section 2 (for Glulx only) 

Table of Menu Commands (continued)
number	effect
-8		quit rule
-6		select rule
-5		move down rule
-4		move up rule

Menus IT ends here.

---- Documentation ----

NOTA: Questa è una lieve modifica dell'estensione originale Menus di Emily Short. Ho ridotto solo l'ampiezza della barra e tradotto i testi.

Per la documentazione completa vedi l'estensione originale.
