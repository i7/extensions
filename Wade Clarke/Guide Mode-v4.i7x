Version 4.0 of Guide Mode by Wade Clarke begins here.

"Enables you to add a guide mode to your game. The guide mode walks the player through the game one command at a time. The author creates the table of commands for the game to supply. The player can accept and enter each displayed command by pressing ENTER. If the player types a different in world command, guide mode is paused (and no more guide commands are displayed) allowing the player to experiment or explore. The player can leave guide mode by typing GUIDE OFF. Otherwise, when they UNDO during pause mode, they will be rewound to the moment just before they paused, and put back in guide mode."

[VERSION 4: 2023-11-09

IMPROVEMENTS SINCE VERSION 3:

* Extension now incorporates Daniel Stelzer's Autosave. This allows it to work across sessions in autosaving interpreters like Parchment because it no longer has to retrieve the Guide Mode rewind point from the UNDO stack; it gets it from an autosave snapshot file instead. Thanks Drew Cook for pointing out the issue.
* Extension now requires that the game author gives their autosave file a game-specific name. This requirement is described in the documentation..
* Extension no longer makes use of 'file of resumation'.
* Fixed a bug: Repeatedly entering G or AGAIN in Guide Mode no longer quotes G/AGAIN as the previous command. Instead, the real command that's being repeated is quoted.

TODO - Low priority: After cancelling a RESTART or QUIT, it takes two UNDOs to reach the previous guide command, instead of one as in the case of a cancelled SAVE or RESTORE. This is because SAVE and RESTORE 'cancel this turn' when they're aborted. There's no easy opportunity to do the same after a cancelled RESTART or QUIT, only slightly uneasy ones. Given that default Inform projects already have this two-undos-needed after cancelling issue, this extension is already behaving better than default Inform.

TODO- Low priority: If you UNDO to a rewind point, UNDO again, enter 1+ non-guide commands then UNDO to the new rewind point, there's an extra line break. Annoying, but cosmetic only.

IMPROVEMENTS SINCE VERSION 2:

* Bug fixed: The preserve the entered command rule wasn't checking whether player was in guide mode or not

IMPROVEMENTS SINCE VERSION 1:

* Extension does a safety check on boot. It needs to be able to write temp files to function. If it finds it can't, it silently disables the guide mode code.
* Code should all be safe now. No significant guide mode code runs when guide mode isn't supported or has been turned off.
* Player input is converted to lower case behind the scenes. If all table content is entered in lower case, there can be no case mismatches.
* Parser errors no longer cause the guide to pause.
* G/AGAIN are now interchangeable as far as the player and guide author are concerned. If the guide command is G/AGAIN, the automatic expansion shows what command the player will actually be entering.
* Out of world commands are now handled by a whitelist table. The author must add any out of world commands they create to this table. Thanks Drew Cook for this idea.
* Fixed a bug: Guide mode no longer breaks if player cancels a SAVE/RESTORE/RESTART/QUIT on the first turn of the game, though some extra linebreaks might be generated upon the cancel. That's the cost of victory.]



Volume - Prerequisites

Include Undo Output Control by Nathanael Nerode.
Include Autosave by Daniel Stelzer.


Volume - Variables, files and a couple of tables

guide-mode-supported is initially false.

guide-mode-active is initially false.
guide-paused is initially false.
pause-guide-mode-signal is initially false.

guide-command is initially "".
guide-display is initially "".

guide-table-pointer is initially table of guidance.
guide-row-pointer is initially 0.

last-player-command is initially "".

testing-command is initially "".

The file of writability is called "writability".
The file of undoation is called "undoation".
[DEAR GAME AUTHOR - The autosave file must be named in your project.]


table of temp guide files[a dummy table - it exists just so that we can create temporary named files from it. Its contents are irrelevant]
out-of-world(truth state)
--



Volume - i6 Calls

To file-delete (filename - external file):
	(- FileIO_DeleteFile( {filename} ); -).

Include (-
	[ FileIO_DeleteFile extf fref struc rv usage;
	if ((extf < 1) || (extf > NO_EXTERNAL_FILES)) rfalse;
	struc = TableOfExternalFiles-->extf;
	if ((struc == 0) || (struc-->AUXF_MAGIC ~= AUXF_MAGIC_VALUE)) rfalse;
	if ( struc-->AUXF_BINARY )
	{
		usage = fileusage_BinaryMode;
	} else {
		usage = fileusage_TextMode;
	}
	if ( struc-->AUXF_BINARY & 2 == 2 )
	{
		usage = usage + fileusage_SavedGame;
	} else {
		usage = usage + fileusage_Data;
	}
	fref = glk_fileref_create_by_name( usage, Glulx_ChangeAnyToCString(struc-->AUXF_FILENAME), 0 );
	rv = glk_fileref_delete_file(fref);
	glk_fileref_destroy(fref);
	return rv;
];

-).



Volume - Rules, phrases and actions

To delete undoation:
	if file of undoation exists:
		file-delete file of undoation;
		[say "JUST DELETED FILE OF UNDOATION.";]

		
To say guide-mode-about:
	say "Guide Mode will take you through the game, one command at a time, as far as you want to go. DON'T use Guide Mode if you want to avoid spoiling the game. Spoiling is inevitable![paragraph break]With Guide Mode on, a suggested command will appear before the prompt every turn. To accept and use the suggestion, just press ENTER. If you type in your own command instead (excluding utility commands like SAVE) Guide Mode will pause. You will then have full control of the game, free of guide suggestions, until you type one of two commands:[paragraph break]UNDO, entered during pause mode, will rewind the game to the moment before you paused, then resume Guide Mode.[paragraph break]GUIDE OFF, entered at any time, will end guide mode permanently for the current session.[paragraph break]Note that an UNDO entered when Guide Mode is not paused acts like a normal UNDO, taking back one turn.";

This is the invite player to use guide mode rule:[includes a safety check - this rule will do nothing if guide mode can't be run]
	if guide-mode-supported is true:
		say "* This game can be started in an optional Guide Mode. Would you like to read about the features of Guide Mode?[line break]>";
		if the player consents:
			say line break;
			say guide-mode-about;
		say "[line break]* Would you like to start the game with Guide Mode on?[line break]>";
		if the player consents:
			follow the reset guide mode rule;


To set guide-command:[always set guide-row-pointer before calling this routine, and don't call routine without making sure there's a prose entry in the row first]
	now guide-command is prose in row guide-row-pointer of guide-table-pointer;

To guidejump (N - a number):
	now guide-row-pointer is guide-row-pointer plus N minus one;

To update guide position:
	let SUCCESS be false;
	while SUCCESS is false:
		if guide-row-pointer is number of rows in guide-table-pointer:[ran out of commands - turn off guide mode behind the scenes]
			end guide mode because there are no more commands to execute;[this should never fire on the first turn of your game, because if guide mode is on, you put at least one command in the table, right?...]
			now SUCCESS is true;
		otherwise:
			increment guide-row-pointer;
			if there is a prose in row guide-row-pointer of guide-table-pointer:[in other words, blank entries will be automatically skipped. This allows author to conveniently start putting their data in when they continue the table of guidance, if nothing else.]
				[say "guide-table-pointer = [guide-table-pointer].";]
				[say "ROW POINTER = [guide-row-pointer]";]
				set guide-command;
				[say "guide-command = [guide-command].";]
				now SUCCESS is true;


This is the NEW every turn stage rule:
	if guide-mode-active is true:
		update guide position;
	follow the every turn rules;

The NEW every turn stage rule is listed instead of the every turn stage rule in the turn sequence rulebook.


To say variable command prompt:
	if guide-mode-active is false:
		say ">";
	otherwise:[guide mode is ON! So print the next command]
		say guide-command;
		say " [run paragraph on]";
		now guide-display is "";[if this remains empty, it's a sign we don't need to print an expansion/clarification after the command]
		if there is a display-prose in row guide-row-pointer of guide-table-pointer:
			now guide-display is display-prose in row guide-row-pointer of guide-table-pointer;
		otherwise:
			follow the command-expanding rules;[these operate on guide-display only]
			if rule succeeded:
				now guide-display is testing-command;
		if guide-display is not "":
			say "(";
			say guide-display;
			say ") ";
		say ">";


guide-deactivating is an action out of world.
Understand "guide off" as guide-deactivating when guide-mode-supported is true.

Check guide-deactivating when (guide-mode-active is false and guide-paused is false):
	instead say "Guide Mode is already off.";

Carry out guide-deactivating:
	say "Guide Mode is now off.";
	deactivate guide mode;

To deactivate guide mode:
	now guide-mode-active is false;
	now guide-paused is false;
	now pause-guide-mode-signal is false;
	enable saving of undo state;


To request to pause guide mode:[if line input from player doesn't match the guide's suggested command, this request is sent. It has to be sent on a delay (rather than applied immediately) because we need to check if the action was out of world, and the check takes place just before creating the prompt on the next turn.]
	now pause-guide-mode-signal is true;

To pause guide mode now:
	now guide-mode-active is false;
	now guide-paused is true;
	now guide-command is "";
	now guide-display is "";
	say "[italic type]Because you entered a non-guide command, Guide Mode is now paused. During the pause, the guide will no longer suggest commands and you can play however you like. You have the ability to safely rewind the game to this pause point and start receiving suggestions again by entering UNDO. To fully exit guide mode at any point from now (for completely independent play) enter GUIDE OFF.[roman type] ";[deliberate trailing space]
	say line break;
	disable saving of undo state;
	now pause-guide-mode-signal is false;

To end guide mode because there are no more commands to execute:
	say "[italic type]There are no more commands in the guide, so Guide Mode has been turned off.[roman type][line break]";
	deactivate guide mode;


Before undoing an action:[phrase from Undo Output Control]
	follow the guide mode snapback rule;

This is the guide mode snapback rule:
	if guide-paused is true:
		say "[italic type]You have rewound the game to the moment before you paused Guide Mode. Guide Mode is now resumed.[roman type]";
		[No need to set guide-paused to false here. In the autosave we're about to resume from, it will be false.]
		autorestore the game;

Before reading a command (this is the consider a request to pause guide mode that was generated during the previous turn rule):[It's crucial to deactivate guide mode just before the prompt is printed, as the prompt figures in guide mode]
	if guide-paused is false:
		if pause-guide-mode-signal is true:
			[say "WE GOT THE SIGNAL TO PAUSE GUIDE MODE. DOING IT NOW...";]
			pause guide mode now;
		otherwise:[if we're not paused, it's safe to create a new rewind spot]
			[say "WE JUST AUTOSAVED (A).";]
			autosave the game;
			if we restored from an autosave:
				say line break;
				try looking;
				[say "WE JUST AUTORESTORED (A)";]


This is the check if the current guide action is whitelisted rule:
	[say "CHECKING FOR WHITELISTED COMMANDS.";]
	let test-cmd be the substituted form of "[the player's command]" in lower case;
	repeat through the table of whitelisted commands:
		if test-cmd exactly matches the text "[prose entry]":
			[say "WHITELISTED.";]
			rule succeeds;
	rule fails;


Rule for repairing an empty command:[A function from Undo Output Control]
	if guide-mode-active is true:[In guide mode, we're going to input the command for the player]
		[say "guide-command is [guide-command]...";]
		change the text of the player's command to "[guide-command]";
		if there is a pre-command-rule in row guide-row-pointer of guide-table-pointer:[and if the guide includes a pre-command for this command, it's time to run that rule]
			follow pre-command-rule in row guide-row-pointer of guide-table-pointer;

After reading a command (this is the preserve the entered command rule):
	if guide-mode-active is true:
		let test-cmd be the substituted form of "[the player's command]" in lower case;
		if test-cmd exactly matches the regular expression "g|again":[if player used 'again', we won't preserve the g/again itself - we'll let the last-player-command variable continue to hold the command they're repeating]
			[say "AGAIN MATCH.";]
			if (guide-command is "g" and test-cmd is "again") or (guide-command is "again" and test-cmd is "g"):[code to make g/again interchangeable in terms of matching what player typed to a guide command]
				[say "G-AGAIN SWAP MATCH.";]
				change the text of the player's command to "[guide-command]";
		otherwise:[we won't preserve the text of the most recent entered command if it was G or AGAIN]
			now last-player-command is the substituted form of "[the player's command]";[we preserve exactly what the player typed (or accepted, if in guide mode) in this variable until the next command is entered]

After reading a command (this is the test whether we should remain in guide mode or not rule):
	if guide-mode-active is true:
		let test-cmd be the substituted form of "[the player's command]" in lower case;
		if test-cmd exactly matches the text "[guide-command]":[we'll only do more regular expression tests if the command doesn't match - this means less regular expression processing on a turn when the player just hits return]
			follow the check if the current guide action is whitelisted rule;
			if rule succeeded:
				update guide position;
			continue the action;[skips the rest of this after reading a command rule]
		if test-cmd matches the regular expression "^rules|^actions|^trace":[We won't leave guide for these test commands. They don't register as out of world, hence this special test, but they don't take any time, either.]
			continue the action; 
		replace the regular expression "\ +" in test-cmd with " ";[replace any run of spaces with one space... yes, at this point, it's necessary for us to manually do this stuff if we want to allow the player to type the command out, and have it match the suggested command, but still forgive them for misplaced spaces (without turfing them from guide mode)]
		replace the regular expression "^\ " in test-cmd with "";[delete any leading space]
		replace the regular expression "\ $" in test-cmd with "";[delete any trailing space]
		if test-cmd exactly matches the text "[guide-command]":[try again - if it still doesn't match, it's potentially time to leave guide mode]
			follow the check if the current guide action is whitelisted rule;
			if rule succeeded:
				update guide position;
		otherwise:
			follow the check if the current guide action is whitelisted rule;
			if rule failed:[if it wasn't a whitelisted command]
				[say "PAUSE REQUESTED.";]
				request to pause guide mode;


After printing a parser error when guide-mode-active is true (this is the cancel any pending guide mode pause in the case of a parser error rule):
	now pause-guide-mode-signal is false;
	[say "PARSER ERROR.";]

This is the reset guide mode rule:
	now guide-mode-active is true;
	now guide-row-pointer is 1;
	now guide-table-pointer is table of guidance;
	update guide position;


To cancel this turn:[does nothing if guide mode is off, and is never called if guide mode isn't supported]
	if guide-mode-active is true:
		unless story has ended:[if the story has ended, this phrase must be running after a RESTORE the player asked for at the final question, but then cancelled. At such time, we don't want to cancel this turn. We want the final question to be asked again, which will happen automatically.]
			[say "CANCELLING THIS TURN.";]
			say paragraph break;
			write file of undoation from table of temp guide files;[indicates we don't want to say 'Turn undone' after this undo, because it was an internal one performed by the game to get rid of a turn that shouldn't haven't been recorded for UNDO. Basically, a cancelled SAVE or RESTORE.]
			[say "JUST WROTE FILE OF UNDOATION.";]
			undo the current turn;[phrase from Undo Output Control that negates the current turn]

To say cancel this turn:
	cancel this turn;



[While Undo Output Control has new rule hooks for Reporting Undo, I like the way Inform does it by default, so I'd rather build off the default by hooking into the response that's printed after an UNDO.]

To say variable undo recovery message:
	if file of undoation exists:[if this UNDO was triggered by a 'cancel this turn' from an aborted SAVE or RESTORE, we don't want to mention the cancelling UNDO.]
		file-delete file of undoation;
		[say "JUST DELETED FILE OF UNDOATION.";]
		say run paragraph on;
	otherwise:
		say "[bracket]Previous turn undone.[close bracket] ";[deliberate trailing space]
		[say "WE JUST AUTOSAVED (B).";]
		autosave the game;
		if we restored from an autosave:
			say line break;
			try looking;
			[say "WE JUST AUTORESTORED (B).";]

To say variable no undo possible message:
	delete undoation;[if this UNDO was triggered by a 'cancel this turn' from an aborted SAVE or RESTORE, we need to get rid of the file of undoation now, after the failure of the attempted UNDO.]
	let LOWERCASED-LAST be last-player-command in lower case;
	[say "lowercased last-player-command is [LOWERCASED-LAST].";]
	let BLOCK-MESSAGE-PRINT be false;
	if guide-mode-active is true and (LOWERCASED-LAST is "save" or LOWERCASED-LAST is "restore"):[if this UNDO was triggered by a 'cancel this turn' from an aborted SAVE or RESTORE, we don't want to redundantly mention the fact that the cancelling UNDO found nothing to UNDO.]
		now BLOCK-MESSAGE-PRINT is true;
	if BLOCK-MESSAGE-PRINT is false:
		say "You can't 'undo' what hasn't been done! ";[deliberate trailing space]
[TODO ANY CHANGES NEEDED TO THE ABOVE RULE?]


When play begins (this is the test whether guide mode can be run rule):[makes sure the game can write temp files before allowing guide mode]
	write file of writability from table of temp guide files;
	if file of writability exists:
		now guide-mode-supported is true;
		file-delete file of writability;
	
When play begins (this is the prepare prompt and responses for guide mode if guide mode is supported rule):
	if guide-mode-supported is true:[we only make the following preparations if guide mode can be run.]
		now the command prompt is "[variable command prompt]";
		now the immediately undo rule response (B) is "[variable no undo possible message]";
		now the immediately undo rule response (E) is "[variable undo recovery message]";
		now the save the game rule response (A) is "Save cancelled. [cancel this turn]";
		now the restore the game rule response (A) is "Restore cancelled. [cancel this turn]";
		delete undoation;
		delete the autosave file;
		repeat through Table of Final Question Options:
			if final question wording entry is "UNDO the last command":
				now final response rule entry is final question undo rule;
				break;

[An UNDO made via the final question doesn't go through Undo Output Control's 'Before undoing an action' mechanism, meaning it has no chance to autorestore. I've tweaked the Table of Final Question Options to make such an UNDO follow the guide mode snapback rule.]

This is the final question undo rule:
	follow the guide mode snapback rule;
	follow the immediately undo rule;


Volume - The command-expanding rules, and author-editable tables

The command-expanding rules is a rulebook.

First command-expanding rule (this is the prepare testing-command variable rule):
	now testing-command is the substituted form of "[guide-command]";

Last command-expanding rule (this is the fallthrough command-expanding failure rule):
	rule fails;


A command-expanding rule (this is the replace X with examine rule):
	if testing-command matches the regular expression "^x ":
		replace the regular expression "^x " in testing-command with "examine ";
		rule succeeds;

A command-expanding rule (this is the automatic expansions rule):
	if testing-command is a prose listed in the table of command expansions:
		now testing-command is display-prose entry;
		rule succeeds;


table of command expansions
prose(text)	display-prose(text)
"n"	"north"
"s"	"south"
"w"	"west"
"e"	"east"
"u"	"up"
"d"	"down"
"nw"	"northwest"
"ne"	"northeast"
"sw"	"southwest"
"se"	"southeast"
"i"	"inventory"
"l"	"look"
"g"	"repeat previous command: ['][last-player-command]['] "
"again"	"repeat previous command: ['][last-player-command]['] "


table of whitelisted commands
prose(text)
"save"
"quit"
"q"
"restart"
"restore"
"verify"
"version"
"score"
"brief"
"normal"
"verbose"
"long"
"superbrief"
"short"
"notify"
"notify on"
"notify off"
"script"
"script on"
"script off"
"transcript"
"transcript on"
"transcript off"
"nouns"
"pronouns"


table of guidance
prose(text)	display-prose(text)	pre-command-rule(a rule)
--	--	--


Guide Mode ends here.


---- DOCUMENTATION ----

This extension was written and tested in Inform 10.2. It's based on ideas and suggestions by John Ziegler and Drew Cook.

Note that Guide Mode must be turned on at the start of the game, or at least at the start of a discrete section of the game prepared by the author. It depends on the game behaving the way the author knows it will. Guide Mode can not be turned on at some arbitrary moment during the game; it's more a lived walkthrough on rails, with the ability to adapt a little bit, and giving the player the ability to explore a bit and then snap back onto the rails. Guide Mode is not a dynamic help system.

THE MINIMUM THAT'S REQUIRED OF YOU TO MAKE GUIDE MODE WORK IN YOUR GAME (FIVE STEPS):

1. Include this extension in your project's source.

i.e.

	Include Guide Mode by Wade Clarke.

This extension requires that you've already installed the extensions Undo Output Control by Nathanael Nerode and Autosave by Daniel Stelzer in Inform. You can probably get these extensions here: https://github.com/i7/extensions/

2. Edit or add to the table of guidance in the extension, or make a continuation of it in your own game's source, with your guide commands in it. You can use the table of guidance from the example project, The Sawyer Place, as a template.

Note that the first line of the table of guidance, the one in the extension itself, can be left with its blank entries. Any lines in the table of guidance that have a blank prose entry will automatically be skipped when your game is running.

3. If you've created any new out of world commands for your game AND you are including one or more of them in your table of guidance, you must add these commands to the table of whitelisted commands. Do this either by editing this extension or making a continuation of that table in your game. (Full details down in the features section.)

4. When you include this extension, your game is going to create an autosave file during play to track undo states.

You must give this file a name specific to your game, in your source. Inform is fussy about this kind of file name. It has to be short (3-23 characters) and consist of only letters and numbers.

I suggest your autosave file name takes the form "somethingauto" where the 'something' is an abbrevation of your game's name.

To name the autosave file, you must add a 'when play begins' rule to your source, like this:

	When play begins:
		now the autosave filename is "something auto";

Here's an example: Let's say your game is called World War 7. A good name for your autosave file would be "ww7auto". To set this, you'd put the following code in your source:

	When play begins:
		now the autosave filename is "ww7auto";

5. Call the extension's default startup sequence from your game with the following code:

	When play begins:
		follow the invite player to use guide mode rule;

This rule optionally explains the features of guide mode to the player then asks them if they want to start with the mode on or off. It will turn the mode on if necessary by using the phrase 'reset guide mode'. This is the phrase that actually throws the switch, and it has to happen before play begins.

Call your own rule instead if you want to alter or customise the startup questions or instructions. Another way to customise things would be to edit the 'invite player to use guide mode' rule in the extension, and/or the about text printed by the phrase 'say guide-mode-about'.

-> In the unlikely circumstances the extension performs its initial sanity check and finds it can't write temp files to disk, the 'follow the invite player to use guide mode rule' won't do anything and guide mode won't be available.


* ONE IMPORTANT NOTE: BEHIND THE SCENES, IT'S ALL LOWER CASE

The extension converts all player input to lower case before checking it against table content and such, so when editing or adding to any tables in the extension, enter all text values in lower case.


SOME FEATURES OF GUIDE MODE:

IT'S COMPATIBLE WITH THE FINAL QUESTION

* If the player pauses Guide Mode, then dies or reaches an ending via an 'end the story' mechanism in your game while doing things on their own, they can safely UNDO from the final question back to the pre-pause point.

IT AUTOMATICALLY EXPANDS ABBREVIATED COMMANDS BY DEFAULT

* By default, guide mode displays expansions of abbreviated commands alongside the commands. e.g. n (north), (i) inventory. This makes the output more readable, and could also help teach new players the meanings of the abbreviations. When 'g' / 'again' are expanded, the expansion also mentions the command that's being repeated.

To turn off all this behaviour, deactivate the rule that does it with this code:

	the automatic expansions rule does nothing;

To add to, subtract from or edit the list of commands that are automatically expanded, and what their expansions are, you can edit or add to the table of command expansions that's in the extension, or make a continuation of it in your own game's source.

* Another default rule in the extension expands X to EXAMINE. To turn off this behaviour, use this code:
	
	the replace X with examine rule does nothing;

* You can create further command-expanding rules of your own if you want (to go in the command-expanding rulebook) perhaps using regular expressions the way the 'replace X with examine' rule does. See that rule and the 'automatic expansions' rule for code examples. The crux of coding new command-expanding rules is that the text you want to manipulate or replace will be in the variable 'testing-command'. Check that variable's contents, then alter them if you want during the rule, and if you do alter them, exit with a 'rule succeeds' to execute the replacement.

YOU CAN OPTIONALLY DISPLAY YOUR OWN EXPANSION BESIDE A COMMAND

If you want to display custom text beside a particular command in the guide (in the same style that the automatic expansions are presented) insert the prose you want displayed as text in the display-prose column of the command's row in your table of guidance. Any text you put there will veto anything that would have been produced by the command-expanding rules.

YOU CAN INCLUDE OUT OF WORLD COMMANDS IN YOUR GUIDE

It's handy for players to be able to enter non-suggested out of world commands like SAVE or TRANSCRIPT during Guide Mode without these commands causing the guide to pause or get stuck. Also, if your guide actually suggests an out of world command, it's important that after the player enters that command, the guide does indeed continue on to the next command.

To make all of this work, the extension uses a table of whitelisted commands. They're whitelisted in the sense that although they are out of world, if the guide asks the player to enter one of these and the player accepts the suggestion, the guide will not get stuck.

The table comes pre-populated with all of Inform's default out of world commands (SAVE, RESTORE etc.) but it requires that you add to it any new out of world commands you create THAT ARE ALSO USED IN YOUR GUIDE MODE.

Therefore, if you haven't added any new out of world commands to your game, you don't need to touch the table.

If you have added new out of world commands to your game, but your guide never asks the player to enter any of them, you still don't have to touch the table.

If you have added new out of world commands to your game and any of them appear in your table of guidance, you must add those commands to the table of whitelisted commands (you only have to add a command once, even if your guide uses it more than once). Do this either by adding to the table of whitelisted commands in this extension, or making a continuation of the table of whitelisted commands in your game. (See the example project, The Sawyer Place, for an example of a whitelist continuation.) 

Make sure to include all alternate spellings / phrasings of your new commands in separate lines of the table of whitelisted commands.

YOU CAN JUMP TO A DIFFERENT ROW IN YOUR GUIDE TABLE DURING PLAY

If your game includes randomised content, you may want to make the guide dynamic so it can accommodate some variations. One way to achieve this is to run rules that check the game state and then make the guide jump to a different line or section (of the table of guidance) depending on what was found. Think of this as 'moving the pointer'. Normally, the pointer moves down one row in the table, one command at a time, every time the player accepts the current command. Depending on game state, you might want to have the pointer move, say, four rows down to get the next command. This is like doing a GOTO in ye olde BASIC language.

This extension provides the phrase 'guidejump' for this purpose.

Here's an example. If you put the line

	guidejump 5;

in your source, the guide is going to continue from the command five rows down from the current one.

You can also use negative values if you want:
	
	guidejump -6

will go back 6 rows.

This brings us to,

YOU CAN RUN A PARTICULAR RULE JUST BEFORE A GUIDE COMMAND IS EXECUTED

The guide has a mechanism whereby, if the player hits ENTER to accept the current guide command, the game can run a specified rule the moment after ENTER is pressed but before the command goes through. This is called the pre-command.

In practice, a good use for such a rule is to check something about the game state and then jump to a different row in the table of guidance using the 'guidejump' phrase (the next command offered by the guide will be the one you jumped to). You can corral off blocks of your table of guidance to handle different eventualities and access them using 'guidejump's. This isn't too sophisticated a system, so it isn't intended to adapt to complex gameplay variations, but it's an easy way to have your guide automatically handle non-complex variations.

For an example, have a look at the 'go to the safe room rule' in the example project The Sawyer Place. This rule checks which room of three was randomly chosen as the 'safe' one for that play session, then tweaks the pointer position in the table of guidance as the player nears those rooms so that they will walk to the correct one. And it's not doing this using knowledge the player doesn't have; the player has already been taken, by the guide, through the part of the adventure that revealed which room was safe to visit.



Example: ** The Sawyer Place - A short adventure demonstrating most features of guide mode. The game has one randomised element which is figured into its guide: Each game, the target safe is randomly located in one of three upstairs rooms. The other two rooms bring instant death. A clue downstairs informs the player which is the correct room. The game's guide makes sure the player will have read the clue before encountering the numbered rooms, then uses a pre-command rule in its table of guidance to jump to the correct spot in the guide so that the player enters the correct room. In other words, the commands dispensed near the end of the guide automatically cater for the randomised content.

	*: "The Sawyer Place"

	Include Guide Mode by Wade Clarke.
	
	When play begins:
		now the autosave filename is "sawyerauto";
	
	When play begins (this is the ask player if they want guide mode rule):
		follow the invite player to use guide mode rule;
	
	room-with-the-safe-in-it is initially 0.
	
	When play begins:
		now the room-with-the-safe-in-it is a random number between 1 and 3;
	
	Description of the player is "Having to wear a suit is a con of the private investigator's trade.".
	
	player carries a derringer.
	Description of derringer is "A small pistol with two barrels.".
	
	Understand "help" as requesting help.
	requesting help is an action out of world applying to nothing.
	
	Carry out requesting help:
		say "[italic type]Sawyer's safe must be around here somewhere. But you've heard there are also two booby-trapped false safes.[roman type][line break]";
	
	
	Vestibule is a room. "You're in the vestibule of Old Lady Sawyer's decrepit mansion. The front door is south, but you're not ready to leave yet. Other doors go west, north and east.".
	
	Check going south in vestibule:
		instead say "You're not ready to leave this house yet.";
	
	
	Slanting Corridor is west of vestibule. "You're in a corridor that slants down to the west. You've got a bad feeling about it. The vestibule is east.".
	
	Smelly Corridor is west of slanting corridor. "The corridor here smells foul. The smell seems to be coming from the west. The corridor slants upwards to the east."
	
	Rank Corridor is west of smelly corridor. "The corridor here smells rank. Decaying flesh rank. There's a bloated wooden door to the west. Your internal sense is screaming at you not to continue, but to go back east.".
	
	a circuit board is fixed in place in rank corridor. "You see a circuit board on the wall.".
	Description of circuit board is "The circuit board is old and arcane, but according to scratchings on the wall beside it, the power is connected to rooms [if room-with-the-safe-in-it is 1]two and three upstairs, but not room one[otherwise if room-with-the-safe-in-it is 2]one and three upstairs, but not room two[otherwise]rooms one and two upstairs, but not room three[end if]. Could it be that the rooms with power are the rooms with booby-traps?".
	
	Instead of switching off circuit board:
		say "You can't work out how. This thing's so old and bizarre you might electrocute yourself if you mess with it.".
	
	
	Death Pit is west of Rank Corridor.
	
	After going to death pit:
		end the story saying "As you step through the doorway, your feet go straight through a termite-ridden floor. You crash down into Sawyer's infamous punji-stake-lined death pit. Mortally wounded, you join the vermin and the other dead."
	
	
	Kitchen is east of Vestibule. "You're in a mouldy kitchen. A door leads west.".
	
	some cobwebs are in kitchen. "Cobwebs cover one wall.".
	Understand "cobweb/web/webs" as cobwebs.
	
	a wrench is in kitchen. "A wrench lies in the dust.".
	
	a cracker is in kitchen. "There's a dessicated diet cracker by the sink.".
	Understand "dessicated/diet" as cracker.
	
	Instead of eating cracker:
		say "Maybe if you were starving, you'd eat this cracker that's been sitting in a dead woman's kitchen for months. But you're not starving.".
	
	Description of cobwebs is "They're so thick, you can't see through them.".
	
	Instead of taking cobwebs:
		say "You tear the cobwebs aside, revealing a pentagram painted on the wall... in blood!";
		now pentagram is in kitchen;
		now cobwebs are nowhere.
	
	a pentagram is fixed in place. "There's a bloody pentagram on the wall. It means something, obviously, and presumably that something is not good.".
	
	
	Hall is north of vestibule. "You're in a dingy hall with chequerboard tiling. The vestibule is south and a staircase leads up.".
	
	
	a gallery-room is a kind of room.
	
	Gallery is a gallery-room. It is up from hall. "You're in a mahogany gallery. Stairs lead down to the hall. The gallery extends north and south and there's a door to the west with a brass '2' on it.".
	
	Gallery South is a gallery-room. It is south from gallery. "You're at the south end of the gallery. There's a door to the west with a brass '3' on it.".
	
	Gallery North is a gallery-room. It is north from gallery. "You're at the north end of the gallery. There's a door to the west with a brass '1' on it.".
	
	
	a safe is a closed, locked, openable fixed in place container.
	Description of safe is "Okay, here's Sawyer's safe. But what's the combination?".
	
	Check opening safe:
		end the story saying "You don't know the combination to the safe, but working out what it is will be your next adventure.";
	
	
	A safe-room is a kind of room. The description of a safe-room is usually "You're in room [safe-id of the item described]. There's a [safe] in the west wall. A door east goes back to the gallery.".
	
	A safe-room has a number called safe-id.
	
	Room 1 is a safe-room. It is west of gallery north. The safe-id of room 1 is 1.
	Room 2 is a safe-room. It is west of gallery. The safe-id of room 2 is 2.
	Room 3 is a safe-room. It is west of gallery south. The safe-id of room 3 is 3.
	
	Carry out going to a safe-room:
		now safe is in the room gone to;
	
	After going to a safe-room:
		if room-with-the-safe-in-it is not safe-id of the location:
			end the story saying "When you touch the door handle to room [safe-id of the location], you hear a mechanical snapping sound in the adjacent wall. You wonder for a moment whether you've triggered one of Sawyer's booby-traps. A massive explosion confirms it.";
		otherwise:
			continue the action;
	
	
	
	table of guidance (continued)
	prose(text)	display-prose(text)	pre-command-rule(a rule)
	"x me"	--	--
	"i"	--	--
	"x derringer"	--	--
	"s"	--	--
	"help"	--	--
	"e"	--	--
	"x webs"	--	--
	"get webs"	--	--
	"l"	--	--
	"get wrench"	--	--
	"eat cracker"	--	--
	"w"	--	--
	"w"	--	--
	"w"	--	--
	"w"	--	--
	"x board"	--	--
	"e"	--	--
	"g"	--	--
	"g"	--	--
	"n"	--	--
	"u"	--	--
	"n"	--	--
	"s"	--	--
	"s"	--	go to the safe room rule
	"n"	--	--
	"n"	--	--
	"w"	--	--
	"x safe"	--	--
	"open safe"	--	--

	table of whitelisted commands (continued)
	prose(text)
	"help"

	This is the go to the safe room rule:
		if room-with-the-safe-in-it is:
			-- 3:
				guidejump 3;[after the current guide command is executed, the guide will continue from the table entry THREE entries below this rule]
			-- 2:
				guidejump 2;[after the current guide command is executed, the guide will continue from the table entry TWO entries below this rule]
