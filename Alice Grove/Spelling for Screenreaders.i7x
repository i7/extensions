Version 1/201208 of Spelling for Screenreaders by Alice Grove begins here.

"This extension is unfinished. It is not recommended for general use."

["Gives players the option to have unusual words spelled letter-by-letter so they'll be more screenreader-friendly."]


Section - Spelling Mode

spelling-mode is a truth state that varies. spelling-mode is initially false.

A thing can be spellable. A thing is usually not spellable.

A thing can be either unspelled in spelling mode or spelled in spelling mode. A spellable thing is usually spelled in spelling mode.

After printing the name of an spellable thing (called the current item) when spelling-mode is true and the current item is spelled in spelling mode (this is the actually spell the spellable thing rule):
	let current name be the printed name of the current item;
	let total characters be the number of characters in current name;
	say " (spelled [run paragraph on]" (A);
	repeat with N running from 1 to total characters :
		say "[character number N in current name]" (B);
		if N is not total characters:
			say " " (C);
	say ")" (D).


Section - Introducing Spelling Mode
	
When play begins (this is the introduce spelling mode when play begins rule):
	say "[italic type]This story offers an option to spell unusual words so they will be more screenreader-friendly. Would you like to turn on spelling mode? (Y/N)>" (A);
	say "[roman type]" (B);
	if the player consents:
		now spelling-mode is true;
		say "[line break][italic type]Spelling mode is now on. To toggle spelling mode, type 'SPELLING.' In spelling mode, all unusual words will be spelled by default, but you can turn off spelling for individual words. To stop spelling a word, type the command 'STOP SPELLING' followed by the word. To start spelling all unusual words again, type 'SPELL ALL.' To show these instructions, type 'SPELLING HELP.'" (C);
	otherwise:
		say "[italic type]Spelling mode is off for now. To turn it on later, type 'SPELLING.'" (D);
	say "[roman type][line break]" (E).


Section - Toggling Spelling Action

Toggling spelling mode is an action out of world.

Understand "spelling" as toggling spelling mode.

Carry out toggling spelling mode (this is the toggle spelling mode rule):
	if spelling-mode is false:
		now spelling-mode is true;
	otherwise:
		now spelling-mode is false.
		
Report toggling spelling mode (this is the tell the player we are toggling spelling mode rule):
	say "Spelling mode has now been turned [if spelling-mode is true]on[otherwise]off[end if]. For information about other spelling commands, please type 'SPELLING HELP.'".


Section - Stopping Spelling Action

Stopping spelling is an action applying to one visible thing.
Understand "stop spelling [thing]" as stopping spelling.

Check stopping spelling (this is the make sure spelling-mode is on before we stop spelling a given word rule):
	if spelling-mode is false:
		say "You seem to want to stop spelling something, but spelling mode is not currently on. To toggle spelling mode, type 'spelling.'" (A) instead.

Check stopping spelling (this is the make sure a word is currently spelled before we stop spelling it rule):		
	if (the noun is not spellable) or (the noun is not spelled in spelling mode):
		say "You seem to want to stop spelling something, but '[noun]' is not currently being spelled." (A) instead.
		
Carry out stopping spelling (this is the stop spelling a word rule):
	now the noun is unspelled in spelling mode.
	
Report stopping spelling (this is the tell the player we will stop spelling the word rule):
	say "Now '[noun]' will no longer be spelled." (A).
	
	
Section - Spelling All Action

Spelling all is an action out of world.
Understand "spell all" as spelling all.

Check spelling all (this is the make sure spelling-mode is on before spelling all spellable words rule):
	if the spelling-mode is false:
		say "You seem to want to turn on spelling for all unusual words, but spelling mode is not currently on. To toggle spelling mode, type 'SPELLING.'" (A) instead.

Carry out spelling all (this is the spell all the spellable words rule):
	repeat with item running through spellable things:
		if item is unspelled in spelling mode:
			now item is spelled in spelling mode.
			
Report spelling all (this is the tell the player we will now spell all unusual words rule):
	say "Now all unusual words will be spelled." (A).


Section - Asking for Spelling Help Action

Asking for spelling help is an action out of world.
Understand "spelling help" as asking for spelling help.

spelling-instructions is some text that varies. spelling-instructions are "Spelling mode is currently [if spelling-mode is true]on[otherwise]off[end if]. To toggle spelling mode, type 'SPELLING.' In spelling mode, all unusual words will be spelled by default, but you can turn off spelling for individual words. To stop spelling a word, type the command 'STOP SPELLING' followed by that word. To start spelling all unusual words again, type 'SPELL ALL.' To show these instructions, type 'SPELLING HELP.'".

Understand "spell [text]" and "spelling [text]" as a mistake ("[spelling-instructions]").

Report asking for spelling help (this is the give the player spelling instructions rule):
	say "[spelling-instructions][line break]" (A).
	
	
Section - Command List (for use with Common Commands Sidebar by Alice Grove)

Table of Extension-Provided Sidebar Commands (continued)
Displayed Command
"Spelling"
"Stop spelling it"
"Spell all"
"Spelling help"
	

Spelling for Screenreaders ends here.


---- DOCUMENTATION ---- 

This extension was an experiment. I do not plan to finish it.

[This extension is intended for stories with many unusually-spelled things. Stories with only a few unusually-spelled things may want to handle them with footnotes that allow the player to request the spelling of particular words (see this thread: http://www.intfiction.org/forum/viewtopic.php?f=6&t=19617&start=30#p109201).

To make a thing spellable, we declare it to be "spellable." If we want things to be spelled out when they appear in descriptions, we'll need to put them in square brackets so that Inform knows when it is printing the name of a particular thing.

(Note: If we happen to be using the Common Commands Sidebar extension in the same project, we can include the option "including extension commands" in our "prepare the commands sidebar" line to automatically add the spelling commands to the sidebar.)

Example: * Spelling Lab - A tiny game featuring some spellable items. Please type "Y" at the opening prompt in order for the test script to work as it should.

	*: "Spelling Lab"
	
	Include Spelling for Screenreaders by Alice Grove.

	Spelling Lab is a room.

	A gurphlub is here. "A [gurphlub] lies on the floor." The gurphlub is spellable.

	A detember is here. "A [detember] is stowed away in the corner." The detember is spellable.

	A sneaker is here.

	Test me with "stop spelling gurphlub / look / spell all / look / spelling / look".

]
