Version 1/160601 of Simple Spelling by Alice Grove begins here.

"Allows players using screen readers to request the spelling of any visible thing."


Section - Introduction

introduce spelling feature is a truth state that varies. introduce spelling feature is usually true. 

When play begins (this is the introduce the spelling feature rule):
	if introduce spelling feature is true:
		say "Are you using a screen reader? (Y/N)>[run paragraph on]";
		if player consents:
			say "[line break]This story allows you to request the spelling of visible things. Please type the word SPELL for a list of visible items to spell. Each time you do this, a new list will be generated.[paragraph break]To spell the name of an item, please type the word SPELL followed by its number in the list." (A);
		say line break.


Section - Spelling Reference Number Property

A thing has a number called a spelling reference number.


Section - Listing Visible Items

Listing visible items for spelling is an action out of world.
Understand "spell" as listing visible items for spelling.

Check listing visible items for spelling (this is the clear all spelling reference numbers before assigning new ones rule):
	repeat with item running through things:
		now the spelling reference number of item is 0.

Carry out listing visible items for spelling (this is the list the visible items and their spelling reference numbers rule):
	let spelling list be a list of things;
	repeat with visible item running through visible things:
		add visible item to spelling list;
	if the number of entries in spelling list > 1:
		say "To spell the name of something, please type the word SPELL followed by a number from 1 to [number of entries in spelling list]." (A);
		let N be 0;
		repeat with item running through spelling list:
			increment N;
			now the spelling reference number of item is N;
			let current name be the printed name of item;
			say "To spell [current name in upper case], type [spelling reference number of item]." (B);
	otherwise if the number of entries in spelling list is 1:
		let lone item be entry 1 in spelling list;
		now the spelling reference number of lone item is 1;
		say "You can see only [printed name of lone item]." (C);
		try spelling the numbered word 1;
	otherwise:
		say "There are no visible items to spell." (D).
		

Section - Spelling the Word

Spelling the numbered word is an action applying to one number.
Understand "spell [number]" as spelling the numbered word.

Check spelling the numbered word (this is the make sure there is a visible item with the given spelling number rule):
	repeat with visible item running through visible things:
		if the spelling reference number of the visible item is the number understood:
			continue the action;
	say "There are no visible things assigned the number [number understood]. To list visible things and their numbers, please type the word SPELL." (A) instead.

Carry out spelling the numbered word (this is the spell the word that has the given spelling number rule):
	repeat with visible item running through visible things:
		if the spelling reference number of the visible item is the number understood:
			let current name be the printed name of the visible item;
			say "[Current name in upper case] is spelled[run paragraph on]" (B);
			repeat with N running from 1 to  the number of characters in current name:
				say " " (C);
				let current letter be character number N in current name;
				if current letter is " ":
					say "space" (D);
				otherwise if current letter is "-":
					say "hyphen" (E);
				otherwise if current letter is "[']":
					say "apostrophe" (F);
				otherwise if current letter is ".":
					say "[if American dialect option is active]period[otherwise]full stop[end if]" (G);
				otherwise:
					say current letter in upper case;
			say "." (H).
			
			
Section - Command List (for use with Common Commands Sidebar by Alice Grove)

Table of Extension-Provided Sidebar Commands (continued)
Displayed Command
"Spell"
"Spell (number)"


Simple Spelling ends here.


---- DOCUMENTATION ---- 

This extension adds a "listing visible items for spelling" action and a "spelling the numbered word" action.

The "listing visible items for spelling" action will automatically assign numbers to all visible items, and list the items and their numbers for the player. Each time this action is done, any existing assigned numbers are cleared before the new list is created.

To request the spelling of an item, the player can then type SPELL followed by the item number.

By default, players will be asked at the start of play if they are using a screen reader. If the player answers yes, a brief introduction will be given to the spelling feature. To turn off this question (for instance, if we want to introduce the spelling feature elsewhere) we can add

	introduce spelling feature is false.
	
to our code.


Example: * Simple Spelling Lab - A room with a few spellable items and characters.

	*: "Simple Spelling Lab"
	
	Include Simple Spelling by Alice Grove.
			
	
	Spelling Lab is a room.

	Donna Hopkins-Brown is a woman in Spelling Lab.

	A table is a supporter in Spelling Lab. A hmzerizer is on the table.

	The player carries a glass of goat's milk.
	

	Test me with "spell / spell 1 / spell 2 / spell 3 / spell 4 / spell 5".
		
