Version 2 of Footnotes by Stephen Granade begins here.

"Provides a framework for organizing and displaying footnotes in a game. Version 2 makes Footnotes responsive and 6L38-compatible."

Section 1 - Implementing Footnotes

Footnote-name is a kind of value. The footnote-names are defined by the Table of Footnotes

Current footnote is a number that varies. The current footnote is 1.

Footnotes are a thing. Footnotes can be on or off. Footnotes can be given repeatedly or given only once. 

A footnote-name has a number called the footnote-index. The footnote-index of a footnote-name is usually 0.
A footnote-name has a truth state called the footnote-read. The footnote-read of a footnote-name is usually false.

Table of Footnotes
Name	Note
footnote-placeholder	""	

[A forced-note is printed whether or not it's been shown before. A regular note is only printed if it's not been shown befeore.]
To say a/the/-- forced-note (fn - a footnote-name): 
	if footnotes are on:
		if footnote-index of fn is 0:
			now the footnote-index of fn is the current footnote;
			increment the current footnote;
		say "[bracket][footnote-index of fn][close bracket]".

To say a/the/-- note (fn - a footnote-name): 
	if footnotes are on:
		if footnotes are given only once: 
			if footnote-read of fn is false, say forced-note fn;
		otherwise:
			say forced-note fn.
			 

Section 2 - Player Controls

Giving a footnote is an action out of world applying to one number. Understand "footnote [number]" or "note [number]" as giving a footnote.

Check giving a footnote (this is the there are no footnotes less than one rule):
	if the number understood is less than 1, instead say "There is no footnote with a number less than 1." (A)

Carry out giving a footnote (this is the standard giving a footnote rule): 
	repeat with item running through footnote-names:
		if number understood is the footnote-index of item:
			if item is a name listed in the Table of Footnotes:
				say "[note entry][line break]" (A);
				now footnote-read of item is true;
				continue the action;
			else:
				say "BUG: no content for this footnote." (B);
				continue the action;
	say "There is no footnote with that number." (C).

Turning on footnotes is an action out of world applying to nothing. Understand "footnotes on" or "notes on" as turning on footnotes.

Check turning on footnotes (this is the can't turn on footnotes if they're already on rule):
	if footnotes are on, instead say "Footnotes are already being given." (A).

Carry out turning on footnotes (this is the standard turning on footnotes rule): now footnotes are on.

Report turning on footnotes (this is the standard report turning on footnotes rule): say "Footnotes will now be given. Type NOTE # to read a footnote." (A).

Turning off footnotes is an action out of world applying to nothing. Understand "footnotes off" or "notes off" as turning off footnotes.

Check turning off footnotes (this is the can't turn off footnotes if they're already off rule):
	if footnotes are off, instead say "Footnotes are already not being given." (A).

Carry out turning off footnotes (this is the standard turning off footnotes rule): now footnotes are off.

Report turning off footnotes (this is the standard report turning off footnotes rule): say "Footnotes will no longer be given." (A).

Giving the footnote state is an action out of world applying to nothing. Understand "footnotes" or "notes" as giving the footnote state.

Report giving the footnote state (this is the standard report giving the footnote state rule): say "Footnotes are currently [if footnotes are off]not[end if] being given." (A).

Footnotes ends here.

---- DOCUMENTATION ----

This extension lets you add footnotes to your game, similar to those in the Infocom game Hitchhiker's Guide to the Galaxy. Footnotes are numbered beginning with 1, and are only assigned numbers as they are referenced.

Footnotes are stored in the Table of Footnotes. This extension defines the table; you merely need to continue it:

	Table of Footnotes (continued)
	Name	Note	
	hdtv-footnote	"The TV is actually HDTV-ready, not fully HDTV capable."

"Name" is the name of the footnote, while "Note" is the text of the footnote.

This extension adds the to say phrase

	note NAME

to give a footnote number. Here NAME is the name of the footnote as given in the Table of Footnotes.

Footnotes can be given only once or given repeatedly. By default, the footnotes are given only until that note has been read.

	>x laser
	It utilizes a flowing gas approach rather than a closed tube and is specially designed to be extremely stable(1).
	
	>note 1
	K. M. O'Hara, S. R. Granade, M. E. Gehm, T. A. Savard, S. Bali, C. Freed, and J.E. Thomas, Ultrastable CO2 laser trapping of lithium fermions, Phys. Rev. Lett., vol. 82 (1999), pp. 4204.
	
	>x laser
	It utilizes a flowing gas approach rather than a closed tube and is specially designed to be extremely stable.

(Note that footnote numbers are printed inside square brackets rather than parentheses. They are given as parentheses here due to a limitation of extension documentation.) To change this behavior so that footnotes are given over and over, add the line

	Footnotes are given repeatedly.

to your game. Also by default, the game begins with footnotes turned off. To have them displayed from the beginning of the game, add the line

	Footnotes are on.

to your game.

This extension adds four player commands. FOOTNOTES ON or NOTES ON turns on the display of footnotes, while FOOTNOTES OFF or NOTES OFF turns them off again. FOOTNOTE # or NOTE # reads a numbered footnote, while FOOTNOTES or NOTES reports whether or not footnotes are being displayed.

Example: * Shameless Plug - Adds a footnote to the description of one object in the game.

	*: "Shameless Plug"

	Include Footnotes by Stephen Granade. Footnotes are on.

	The Lab is a room. "Filled with all of the equipment that you need to trap neutral lithium atoms and cool them to just above absolute zero."

	The carbon dioxide laser is in the Lab. "On one side of the lab is a carbon dioxide laser." The description is "It utilizes a flowing gas approach rather than a closed tube and is specially designed to be extremely stable[note laser-ref]." It is fixed in place. Understand "co2" as the laser.

	Table of Footnotes (continued)
	Name	Note	
	laser-ref	"K. M. O’Hara, S. R. Granade, M. E. Gehm, T. A. Savard, S. Bali, C. Freed, and J.E. Thomas, Ultrastable CO2 laser trapping of lithium fermions, Phys. Rev. Lett., vol. 82 (1999), pp. 4204."

	Test me with "x laser / note 1".
