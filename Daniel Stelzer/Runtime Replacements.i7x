Runtime Replacements by Daniel Stelzer begins here.

Table of Text Macros
input (text)	replacement (text)
with 16 blank rows.

Table of Regex Macros
input (text)	replacement (text)
with 16 blank rows.

The temporary working text is initially "". [The replacement machinery doesn't seem to work on local variables.]

After reading a command:
	if word number 1 in the player's command is "undef", make no decision; [Don't make replacements here!]
	now the temporary working text is the player's command;
	repeat through the Table of Text Macros:
		replace the word "[input entry]" in the temporary working text with "[replacement entry]";
	repeat through the Table of Regex Macros:
		replace the regular expression input entry in the temporary working text with the replacement entry;
	change the text of the player's command to the temporary working text.

Defining a replacement of is an action out of world applying to a topic. Understand "def [text]" as defining a replacement of.
Carry out defining a replacement of a topic:
	create a replacement with input (the substituted form of "[topic understood]") and regex mode false.

Defining a regex replacement of is an action out of world applying to a topic. Understand "regex [text]" as defining a regex replacement of.
Carry out defining a regex replacement of a topic:
	create a replacement with input (the substituted form of "[topic understood]") and regex mode true.

Undefining is an action out of world applying to a topic. Understand "undef [text]" as undefining.
Carry out undefining a topic:
	let the count be zero;
	repeat through the Table of Text Macros:
		if the input entry is the topic understood:
			blank out the whole row;
			increment the count;
	repeat through the Table of Regex Macros:
		if the input entry is the topic understood:
			blank out the whole row;
			increment the count;
	say "[bracket][count] replacements for '[topic understood]' removed.[close bracket][paragraph break]".

Listing macros is an action out of world applying to nothing. Understand "macro" or "macros" as listing macros.
Carry out listing macros:
	say "Text replacements:[line break]";
	if the Table of Text Macros is empty:
		say "    None defined. (Use 'def <input> = <output>' to add some.)";
	else:
		repeat through the Table of Text Macros:
			say "    '[input entry]' => '[replacement entry]'[line break]";
	say line break;
	say "Regex replacements:[line break]";
	if the Table of Regex Macros is empty:
		say "    None defined. (Use 'regex <input> = <output>' to add some.)";
	else:
		repeat through the Table of Regex Macros:
			say "    '[input entry]' => '[replacement entry]'[line break]";

To create a replacement with input (X - text) and regex mode (mode - a truth state):
	let the replacement table be the Table of Text Macros;
	if the mode is true: [This is a regex rather than a text replacement.]
		let the replacement table be the Table of Regex Macros;
	if X matches the regular expression "^(.+?)\s+=\s+(.+?)$": [Start, then characters, then space, then equals, then space, then characters, then end.]
		let Y be the text matching subexpression 1;
		let Z be the text matching subexpression 2;
		if the number of blank rows in the replacement table is not zero:
			choose a blank row from the replacement table;
			now the input entry is Y;
			now the replacement entry is Z;
			say "[bracket][if the mode is true]Regex[else]Text[end if] substitution defined: '[Y]' => '[Z]'[close bracket][paragraph break]";
		otherwise:
			say "[bracket]Error: too many replacements defined! Use 'undef <input>' to remove one first.[close bracket][paragraph break]";
	otherwise:
		say "[bracket]To define a replacement, use 'def <input> = <output>' or 'regex <input> = <output>'.[close bracket][paragraph break]";

Runtime Replacements ends here.

---- DOCUMENTATION ----

This utility extension allows players to define replacements to alter their own commands. It does not affect the world model or the game itself in any way, only the user interface.

With this extension installed, players have access to four new commands:

	def input = output

This defines a new text replacement: all instances of the word "input" in commands will now be replaced with "output".

	regex input = output

This similarly adds a new replacement, but this time "input" will be taken as a regular expression rather than a simple piece of text.

	undef input

This allows the player to remove a previously-defined replacement. It actually removes *every* replacement which takes the given input, in case there are multiple.

	macros

This shows the definitions which have been defined thus far.

Note that text replacements are taken to apply to whole words by default: if you redefine "o" to mean "open", then "o box" will become "open box" rather than "open bopenx". Regular expressions apply anywhere unless you specify otherwise, and thus can get around this if necessary.

Example: * Rezrov
	
	"Rezrov"

	Include Runtime Replacements by Daniel Stelzer.

	The Antechamber is a room. "You have survived the dangers of the maze and escaped with your magical treasures! Now all that remains between you and victory are some locked doors to the east. Such tedium..."
	The player carries a thaumaturgical sensor, a thaumaturgical dooropener, and a broken dooropener.

	Instead of unlocking a locked door with the thaumaturgical dooropener:
		say "[The noun] [are] magically unsealed.";
		now the noun is unlocked.

	The Red Chamber, the Orange Chamber, the Yellow Chamber, the Green Chamber, the Blue Chamber, the Indigo Chamber, and the Violet Chamber are rooms.
	The Red Door is a locked door. It is east of the Antechamber and west of the Red Chamber.
	The Orange Door is a locked door. It is east of the Red Chamber and west of the Orange Chamber.
	The Yellow Door is a locked door. It is east of the Orange Chamber and west of the Yellow Chamber.
	The Green Door is a locked door. It is east of the Yellow Chamber and west of the Green Chamber.
	The Blue Door is a locked door. It is east of the Green Chamber and west of the Blue Chamber.
	The Indigo Door is a locked door. It is east of the Blue Chamber and west of the Indigo Chamber.
	The Violet Door is a locked door. It is east of the Indigo Chamber and west of the Violet Chamber.

	After going to the Violet Chamber: end the story finally saying "You have escaped at last!"

	Last after reading a command: say "[italic type][bracket]Command: '[player's command]'[close bracket][roman type][line break]"

	Test boring with "unlock red door with thaumaturgical dooropener / go east / unlock orange door with thaumaturgical dooropener / go east".
	Test text-define with "def t = thaumaturgical dooropener / unlock red with t / go east / unlock orange with t / go east".
	Test regex-define with "regex rezrov (.+) = unlock \1 with thaumaturgical dooropener / rezrov red / go east / rezrov orange / go east".
