Version 2 of Numbered Disambiguation Choices IT by Leonardo Boselli begins here.

"Numbers the options in disambiguation questions, to help new players and solve the 'disambiguation loop' problem caused by indistinguishable objects. Semplicemente tradotto in italiano."

"basato su Version 2 of Numbered Disambiguation Choices by Aaron Reed".

Every thing has a number called disambiguation id. The disambiguation id of something is usually 0.  
 
The list of disambiguables is a list of objects that varies.

disambiguation-busy is a truth state that varies. disambiguation-busy is false. [In certain cases numbers could be printed twice. Thanks to Robert Jenkins for pointing this out.]

Before printing the name of something (called macguffin) while asking which do you mean (this is the preface disambiguation objects with numbers rule):
	if disambiguation-busy is false:
		now disambiguation-busy is true;
		add macguffin to the list of disambiguables, if absent;
		now the disambiguation id of macguffin is the number of entries in list of disambiguables;
		say "[before disambiguation number text][number of entries in list of disambiguables][after disambiguation number text]".

After printing the name of something while asking which do you mean (this is the cleanup disambiguation-busy flag rule):
	now disambiguation-busy is false.

The before disambiguation number text is some text that varies. The before disambiguation number text is "". 

The after disambiguation number text is some text that varies. The after disambiguation number text is ") ". 
		
Before asking which do you mean (this is the reset disambiguables rule):
	repeat with item running through list of disambiguables:
		now disambiguation id of item is 0;
	truncate list of disambiguables to 0 entries.	
	
Understand the disambiguation id property as describing a thing.

[In testing, some players would try to respond with something like "1) dog collar". If we replace closing parentheses from the input with a space, this can still be understood, rather than producing an unhelpful error.]

After reading a command (this is the strip closing parenthesis rule):
	let disam-cmd be indexed text;
	let disam-cmd be the player's command;
	replace the regular expression "\)" in disam-cmd with " ";
	change the text of the player's command to disam-cmd.

Numbered Disambiguation Choices IT ends here.

---- DOCUMENTATION ----

Vedi documentazione originale di Numbered Disambiguation Choices by Aaron Reed.