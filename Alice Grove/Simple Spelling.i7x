Version 1/160603 of Simple Spelling by Alice Grove begins here.

"Simple Spelling aims to make stories more screenreader-friendly by allowing players to request the spelling of any visible thing. This extension adds two actions: 'listing visible items for spelling' and 'spelling the numbered word.'"


Section - Introduction

introduce simple spelling features is a truth state that varies. introduce simple spelling features is usually true. 

When play begins (this is the introduce the simple spelling features rule):
	if introduce simple spelling features is true:
		say "Are you using a screen reader? (Y/N)>[run paragraph on]";
		if player consents:
			say "[line break]This story allows you to request the spelling of visible things. Please type the word SPELL for a list of visible items to spell. Each time you do this, a new list will be generated.[paragraph break]To spell the name of an item, please type the word SPELL followed by its number in the list." (A);
		say line break.


Section - Spelling Reference Number Property

A thing has a number called a spelling reference number.


Section - Phrases for Making a New Spelling List

To clear all spelling reference numbers:
	repeat with item running through things:
		now the spelling reference number of item is 0.
		
inspect simple spelling list for duplicates is a truth state that varies. Inspect simple spelling list for duplicates is usually true.

To decide which list of things is the new spelling list:
	let brand-new spelling list be a list of things;
	if inspect simple spelling list for duplicates is true:
		let unique item names be a list of texts;
		repeat with current item running through visible things:
			let current name be the printed name of current item;
			if current name is not listed in unique item names:
				add current item to brand-new spelling list;
				add current name to unique item names;
	otherwise:
		repeat with current item running through visible things:
			add current item to brand-new spelling list;
	decide on brand-new spelling list.


Section - Listing Visible Items

Listing visible items for spelling is an action out of world.
Understand "spell" as listing visible items for spelling.

Check listing visible items for spelling (this is the make sure there is at least one visible item to put on the spelling list rule):
	if the number of visible things < 1:
		say "There are no visible items to spell." (A) instead.

Carry out listing visible items for spelling (this is the list the visible items and their spelling reference numbers rule):
	clear all spelling reference numbers;
	let spelling list be the new spelling list;
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
		try spelling the numbered word 1.
		

Section - Spelling a Word

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

Thanks to Neil Butters for the code feedback!

Section: Basic Use

Punctuation, words that sound like other words, and made-up words aren't always clear when spoken by a screenreader. Nevertheless, parser IF requires players to spell the names of things in order to refer to them. This extension aims to make stories more screenreader-friendly by allowing players to request the spelling of any visible thing.

This extension adds two actions:  "listing visible items for spelling" and "spelling the numbered word."

The command SPELL leads to the "listing visible items for spelling" action. This action will automatically display a list of visible things, numbering them for the player's reference. This list is made only after clearing any numbers that have previously been assigned to things in the story.

To request the spelling of an item, the player can then type SPELL followed by the item's number on the list.


Section: Options

By default, players will be asked at the start of play if they are using a screen reader. Then if the player answers "yes," the spelling features will be briefly explained. To turn off this opening question and introduction (for instance, if we want to introduce the spelling features elsewhere) we can include this line in our code:

	*: introduce simple spelling features is false.
	
By default, this extension will check for duplicates when making a spelling list so as not to include the same entry twice. This is helpful if we have duplicate items in our story and want to avoid, for instance, listing twenty identical coins as twenty separate items in the list. If we want to skip the check-for-duplicates step, we can add the following line to our code:

	*: inspect simple spelling list for duplicates is false.


Example: * Simple Spelling Lab - A room with some spellable items and characters.

	*: "Simple Spelling Lab"
	
	Include Simple Spelling by Alice Grove.
	
			
	A dictionary is a kind of thing.
	
	Spelling Lab is a room.

	Donna Hopkins-Brown is a woman in Spelling Lab. Donna Hopkins-Brown carries 4 dictionaries.

	An inspection table is a supporter in Spelling Lab. A perse purse is on the inspection table. A pale pail is on the inspection table. A piece of Pete's pizza is on the inspection table.
	
	The player carries a xyzzifier.
	
	
	Test me with "spell / spell 1 / spell 2 / spell 3 / spell 4 / spell 5 / spell 6 / spell 7 / spell 8".
