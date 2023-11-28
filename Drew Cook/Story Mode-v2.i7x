Version 2.0.1 of Story Mode by Drew Cook begins here.

[this is an Inform 10.1.2 extension. It has not been tested with any other version of Inform 7.]

"Provides an optional mode in which the game automatically steps through a walkthrough. At any time, players can pause the guide and play independently. At any future point, players can return to the walkthrough in progress. This is a 'safe' mode of play in which neither the walkthrough nor the game world can be disrupted. The primary design goal of story mode is improved accessibility, though it has potential as a tutorial feature."

[
GENERAL INFO

Very little programming expertise is required to implement this extension. The primary task is adding commands to tables (clear examples will be given). Authors will likely wish to customize in-game messages and command prompts. Adjusting conditional text may be desired as well, though this is optional.]

[
Four extensions are required for this feature. With the exception of Short's Basic Screen Effects, don't use the built-in library; download the most recent tested versions from the Friends of Inform repository:

https://github.com/i7/extensions
]

[

Release History:
	
VERSION 1: Attempted to avoid use of external files as a design goal. Primary pause-suspend look relied on action processing-type hooks in Undo Output Control by Nathanael Nerode. Autopopulated input field while story mode was active using a table of commands. Prevented select commands from pausing story mode via use of a whitelist.

VERSION 2: Major teardown/rewrite due to Parchment autosave incompatibility. Now relying on Daniel Stelzer's Autosave for resume purposes. With this came changes in the way commands were processed. Still avoids file writes with the exception of the autosave. Additionally, the following changes have been made:

* Added check to determine if the story can read/write external files.
* Set story mode to automatically name the save file based on title and version number.
* Several bug fixes and tweaks to output text.
* Set default freedoms (autonomous) for all persons in-game.
* Added templates to copy/paste for extending tables and modifying rules
* Added all out-of-world commands to whitelist in extension to spare author the trouble of keying them in manually.
* Added substantial text substitutions for commonly used punctuation and style modifiers. For instance, substituting "[it]" for "[italic type]"
* Spoofed UNDO responses on the first turn to populate prompt and/or roll back action count.
* Added dynamic updates to the Table of Final Questions Options to reflect the current mode of play.
* Added example story.

]

Include Basic Screen Effects by Emily Short.
Include Undo Output Control [Version 6.0.220529] by Nathanael Nerode.
Include Command Preloading [Version 1.0.20230916] by Daniel Stelzer.
Include Autosave [Version 2.0.231013] by Daniel Stelzer.


Chapter 1 - naming some values

[
autonomous: free play/story mode disabled
guided: following the walkthrough
in-scene: walkthrough is temporarily paused

if you have named PCs that are not the generic, built-in "player," specifically designate their freedoms.

if you change characters mid-game, be sure to pass the freedom of one character to another, like so:

if the player is bob:	
	now the player is jenny;
	now the freedom of jenny is the freedom of bob.
]

freedom is a kind of value.
the freedoms are autonomous, in-scene, and guided.
a person has a freedom.
a person is usually autonomous. [note that guide mode is off unless you've activated it in your project. see documentation below.]

[traditional/autonomous = 1
 story mode = 2]
playmode is a number that varies.
playmode is initially one.

[the current row of the walkthrough]
action count is a number that varies.
action count is one.

[Autosave uses a file read/write, so we must check to see if we can write an autosave file.]
story mode supported is a truth state that varies.
story mode supported is false.

[
The "delete file" phrase below is based on Inform 6 sorcery. I have no idea what it is or how it works. Since it isn't terribly readable unless one knows Inform 6, it is situated at the end of this extension. Wade Clarke posted this code in this thread:
	
https://intfiction.org/t/ignore-when-play-begins-rules-when-restarting/52247
]

the file of mythical creatures is called "mythic".
	
[this is just a dummy table that we use to do our file test when play begins]

table of mythical creatures
name
"chimera"

[Now we write out the dummy file, then try to check it. if story mode supported is false, account for that in the opening of your project, though honestly, I'm not sure what situation would cause this scenario to arise. This is just a precaution.]

first when play begins (this is the initial file check rule):
	write file of mythical creatures from table of mythical creatures;
	if file of mythical creatures exists:
		now story mode supported is true;
		delete file of mythical creatures;
		determine the save name;
	otherwise:
		now story mode supported is false.
		
[Yes, a more capable programmer could have done this all with a single expression. The rest of us will have to settle for this crunk, which truncates up to five letters from the front of the story title, appends an underscore with a version number, then "_autosave" to the needed file.

The goal is just to arrive at a reasonably distinctive name without pushing the autor to set their own name in action processing. Which is still doable, of course. The last named file wins.]

[note: if you have a very weird character in your title, you may have to tinker with this, making your own filename instead]

[sorry about this embarassing regex, but you get the idea]
		
to determine the save name (this is the save determination rule):
	let trimmed txt be "placeholder";
	if story title is "":
		now trimmed txt is "far_out";
	otherwise if story title matches the regular expression "^(.....)":
		now trimmed txt is text matching subexpression 1 in lower case;	
	otherwise if story title matches the regular expression "^(....)":
		now trimmed txt is text matching subexpression 1 in lower case;
	otherwise if story title matches the regular expression "^(...)":
		now trimmed txt is text matching subexpression 1 in lower case;
	otherwise if story title matches the regular expression "^(..)":
		now trimmed txt is text matching subexpression 1 in lower case;
	otherwise if story title matches the regular expression "^(.)":
		now trimmed txt is text matching subexpression 1 in lower case;
	now autosave filename is "[trimmed txt]_[release number]_autosave".

Chapter 1 - data

Section 1a - walkthrough information/steps

[Getting rid of an empty row in our walkthrough table. I may use the index number instead of row number in a future release, which would eliminate this step.]

when play begins:
	let RC be one;
	repeat through the table of story steps:
		now index entry is RC;
		increment RC;
	sort the table of story steps in index order.

table of story steps
index	input
a number	--

[

NOTE

It is possible to have out of world actions in the whitelist. In fact, there may be good reasons for doing so. However, be aware that getting turn count and action count out of sync may lead to some weird behavior near the beginning of the game, when the undo stack is short, since undo snaps back turns passed. It isn't possible, not in a clean way, to undo a SCORE request if SCORE is out of world. Use caution with out of world actions in the walkthrough.

Story mode makes Alowances for UNDO in the first turn (see the "first turn undo rule" below).

It is possible to create complex criteria for executing UNDO versus rolling back action count and spoofing an UNDO response. Undo Output Control is great for this kind of thing. Ultimately, though, accounting for special conditions like this are beyond the scope of Story Mode.

]


[start one in your story, just copy/paste:
	
table of story steps (continued)
index	input
--	"jump"
--	"look"

Every entry in "index" is -- as above. Under "input," put your walkthrough commands (one on each row in quotation marks.

Replace "jump and "look" with your own commands, of course."]

Section 1b - the whitelist

[There is also a whitelist table. Whitelisted commmands do not pause the walkthrough. These are typically out-of world commands like save, restore, and the like. Since whitelist commands do not advance the walkthrough, do not put them IN the walkthrough! That will cause the core loop to get stuck, repeating that entry endlessly. As in above, A table follows for you to continue in your own project. I've added every built-in out of world command, as well as some debug commands.

unlike the walkthrough, the order is not important.]

table of whitelisted commands
input
"save"
"restore"
"undo"
"restart"
"quit"
"verify"
"script"
"script on"
"transcript"
"transcript on"
"script off"
"transcript off"
"version"
"score"
"superbrief"
"short"
"brief"
"normal"
"verbose"
"long"
"notify"
"notify on"
"notify off"
"nouns"
"pronouns"
"resume"
"leave story mode"

[

if you have more to add, here's a template for your project:
	
table of whitelisted commands (continued)
input
"your command here"

]

Chapter 2 - decisions

[If an Inform game is asked to read an empty row, it will throw a runtime error. Here's a way to safely detect that condition before tripping the error. This should only arise if you do not have enough commands in the walkthrough to reach the story's end. If you are doing that on purpose, you will need to copy/paste the before/after reading a command rules and change the language.

These just compare the row number in the walkthrough table with the number of commands in the walkthrough. If the number is higher than the number of commands, guide mode will stop. I decided to take the long way purely for readability reasons.]

to decide if the buffer is valid:
	let FR be the number of filled rows in the table of story steps;
	if the action count is less than FR or action count is FR:
		decide yes.
		
to decide if the buffer is invalid:
	let FR be the number of filled rows in the table of story steps;
	if the action count is greater than FR:
		decide yes.

Chapter 3 - before reading a command

[

Each of these rules checks to verify there are available steps in the walkthrough before proceeding]

[in a normal walkthrough situation:
	
1. autosave
2. load a command from the table of story steps
3. autopopulate the command prompt with it (Command Preloading by Daniel Stelzer).

if story mode has resumed (loaded an autosave):

1. Switch to guided mode
2. load a command from the table
3. autopopulate the prompt (Command Preloading by Daniel Stelzer).

]


before reading a command when the player is guided (this is the small story mode rule):
	[if you're having trouble syncing up undos with playthrough steps, enable this to see where the mismatch is.
	say "turn count: [turn count]"; 
	say line break;
	say "action count: [action count]";
	say line break;]
	if the buffer is invalid:
		say "Command buffer empty. Leaving story mode.";
		now the player is autonomous;
		now playmode is 1;
		rule succeeds;
	otherwise:
		if action count is less than the number of filled rows in the table of story steps: [if we autosave on the last turn, post-game resumes may not work]
			autosave the game;
		choose row action count from the table of story steps;
		preload the command input entry;
	if we restored an autosave:
		say "[lb][bk][it]Resuming story mode and restoring previous world state[dot][rt][cb][lb]";
		now the player is guided;
		choose row action count from the table of story steps;
		preload the command input entry;
		try looking;
	continue the action;
		
[if you wish to change the messaging, copy/paste into your own project, then edit.

the small story mode rule is not listed in any rulebook;
before reading a command when the player is guided (this is the new small story mode rule):
	if the buffer is invalid:
		say "Command buffer empty. Leaving story mode.";
		now the player is autonomous;
		now playmode is 1;
		rule succeeds;
	otherwise:
		autosave the game;
		choose row action count from the table of story steps;
		preload the command input entry;
	if we restored an autosave:
		say "[lb][bk][it]Resuming story mode and restoring previous world state[dot][rt][cb][lb]";
		now the player is guided;
		choose row action count from the table of story steps;
		preload the command input entry;
		try looking;
	continue the action;]

[if the player hits enter when the command prompt is empty while story mode (the player is guided) is active, it will automatically perfom the next step in the walkthrough. If story mode is paused, it will resume.]
		
rule for repairing an empty command: [from Undo Output Control]
	if the player is guided:
		choose row action count from the table of story steps;
		say "[bk][it]Performing the next command in the walkthrough: [bt][input entry][rt][cb][lb]";
		change the text of the player's command to "[input entry]";
	otherwise if the player is in-scene:
		try resuming.
		
[

a few things to handle here:
	- if the player enters *UNDO* while in-scene, we will redirect that command to resuming, which will fire the autorestore.
	- since some walkthrough actions are out of world, we want to give accurate undo feedback when turn count and action count do not mix.
	- handle command preloading after undoing when no undo is possible
	
Undo should behave "normally" elsewhere.

Note that "normal" *UNDO* behavior can mean the player has undone a resume command, or redone a comand that would pause or resume the walkthrough. While this all makes sense, it may make trolling the extension feel more revelatory than it actually is. In version one of story mode, I disabled UNDO unless resuming the walkthrough. However, I think there are legitimate uses that should be supported.

]
		
before undoing an action when the player is guided (this is the first turn undo rule):
	if turn count is one:
		if action count is greater than one:
			say "[bk]Previous turn undone[dot][cb][lb]";
			decrement the action count;
			choose row action count from the table of story steps;
			preload the command input entry;
			rule fails;
		otherwise:		
			say "You can’t 'undo' what hasn’t been done!";
			choose row action count from the table of story steps;
			preload the command input entry;
			rule fails;

		
[if the player enters *UNDO* during guided mode, we want to continue populating the prompt with the next command. Both this and the previous undo customizaiton use Nathanael Nerode's "Undo Output Control"]

report undoing an action when playmode is 2:
	if the player is guided:
		say "[bk]Previous turn undone. Story mode is currently active[dot][cb]";
		say line break;
		choose row action count from the table of story steps;
		preload the command input entry;
		rule succeeds;
	if the player is in-scene:
		say "[bk]Previous turn undone. Story mode is currently paused[dot][cb]";
		rule succeeds;
	
Chapter 4 - after reading a command

[That was prepwork. Now we read the command and make some decisions.]

after reading a command when the player is guided (this is the big story mode rule):
	let ac be zero;
	if the buffer is invalid:
		say "Command buffer empty. Leaving story mode.";
		now the player is autonomous;
		now playmode is 1;
		rule succeeds;
	otherwise if the buffer is valid:
		repeat through the table of whitelisted commands:
			if "[the player's command]" in lower case is input entry in lower case:
				now ac is ac plus one;
		if ac is greater than one:
			continue the action; [if the command is from the whitelist, Inform will process it without advancing or exiting the walkthrough.]
		Otherwise if ac is zero:
			choose row action count from the table of story steps;
			if "[the player's command]" in lower case is input entry in lower case: [if the command matches the text in the table, perform the action and advance the walkthrough step]
				increment the action count;
				continue the action;
			otherwise	if "[the player's command]" in lower case is not input entry in lower case: [if the command doesn't match, the walkthrough is paused]
				now the player is in-scene;
				say "[bk][it]Temporarily leaving story mode. You can return at any time by entering a blank/empty command or else typing RESUME.

If you wish to permanently leave story mode, simply *LEAVE STORY MODE*[dot][rt][cb][lb]";
				now the command prompt is "[bk][it]Story mode paused. Press *ENTER* to *RESUME*.[rt][cb][pb]>".

[

If you want to change the text, copy/paste into your own project, then edit.
	
the big story mode rule is not listed in any rulebook.
after reading a command when the player is guided (this is the new big story mode rule):
	let ac be zero;
	if the buffer is invalid:
		say "Command buffer empty. Leaving story mode.";
		now the player is autonomous;
		now playmode is 1;
		rule succeeds;
	otherwise if the buffer is valid:
		repeat through the table of whitelisted commands:
			if "[the player's command]" in lower case is input entry in lower case:
				now ac is ac plus one;
				break;
		if ac is greater than one:
			continue the action; [if the command is from the whitelist, Inform will process it without advancing or exiting the walkthrough.]
		Otherwise if ac is zero:
			choose row action count from the table of story steps;
			if "[the player's command]" in lower case is input entry in lower case: [if the command matches the text in the table, perform the action and advance the walkthrough step]
				increment the action count;
				continue the action;
			otherwise if "[the player's command]" in lower case is not input entry in lower case: [if the command doesn't match, the walkthrough is paused]
				now the player is in-scene;
				say "[bk][it]Temporarily leaving story mode. You can return at any time by entering a blank/empty command or else typing RESUME.

If you wish to permanently leave story mode, simply *LEAVE STORY MODE*[dot][rt][cb][lb]";
				now the command prompt is "[bk][it]Story mode paused. Press *ENTER* to *RESUME*.[rt][cb][pb]>".
		
]

Chapter 5 - other stuff
		
section 1 - resume

[I use *RESUME* because it makes intuitive sense and story mode is not for habituated parser game fans. UNDO still works as expected.]

resuming is an action out of world applying to nothing.
carry out resuming (this is the resume play rule):
	if the player is in-scene:
		autorestore the game;
		say "File not found. Resuming story mode is not possible. Please consider notifying the author of the story mode extension. He will be entirely mortified.";[this only prints if autorestore fails]
	otherwise if the player is guided:
		say "Resuming is only possible if the player has temporarily paused story mode.";
	otherwise:
		say "Resuming is specific to story mode, which isn't currently active.";
		stop the action.
		
this is the final resume rule:
	autorestore the game.
	
understand "resume" as resuming.

section 3 - leaving story mode

[this is a wordy command, but I want to make sure the player thinks first]

leaving story mode is an action applying to nothing.
understand "leave story mode" as leaving story mode.
Carry out leaving story mode (this is the exit story mode rule):
	say "Would you like to permanently leave story mode? This decision is irreversible.";
	if the player consents:
		say "Understood. Leaving story mode.";
		now the player is autonomous;
		now playmode is 1;
		now the command prompt is ">";
		try looking;
	otherwise:
		say "Understood. Remaining in story mode."
		
Chapter 6 - text substitutions

[I use text substitution to abbreviate common symbols and modifiers]

To say em [em dash]:
	say "[unicode 8212]".

To say dot [a period without a line break]:
	say "[unicode 46]".	
	
to say q [a question mark without a line break]:
	say "[unicode 0063]".
	
to say ex [an exclamation point without a line break]:
	say "[unicode 0033]".
	
to say bk:
	say "[bracket]".
	
to say cb:
	say "[close bracket]".
	
to say it:
	say "[italic type]".
	
to say bt:
	say "[bold type]".
	
to say rt:
	say "[roman type]".
	
to say lb:
	say "[line break]".
	
to say pb:
	say "[paragraph break]".
	
To say fls:
	say "[fixed letter spacing]".
	
to say vls:
	say "[variable letter spacing]".
	
Section 7 (switch undo/resume as needed at end of game)

[As a last touch, players with a paused story when the game ends should be offered a "resume" rather than an "undo" option. Since the player's freedom can change during the game, this will need to be verified whenever the story ends.

These options are stored in the table of final question options (in the standard rules), so we'll have to do some table lookups and changes on the fly when the game is over.]

[for reasons unclear (I'm no expert!) quoted text written to a topic column is treated as a mismatch. To get around that, I copy a "topic" from a bogus table to the "real" table of final question options]

table of ridiculous effort
topic
"resume"
"undo"
	
			
[the current mode of play determines whether "undo" or "resume" should be an option for the player. We'll check and update the table of final question options as needed. Since states can change in-game, we have to check this whenever the game ends.]
			
last when play ends (this is the finalized questions rule):
	if the player is not in-scene: [applies to both autonomous and guided modes]
		if undo is available:
			rule succeeds;
		otherwise if resume is available:
			instate undo;
	otherwise if the player is in-scene: [only applies when story mode is paused]
		if resume is available:
			rule succeeds;
		otherwise if undo is available:
			instate resume;
		

[Some hopefully readable code for this operation. First, the logic behind the undo/resume available phrases.]

to decide if undo is available:
	repeat through the table of final question options:
		if final question wording entry is "UNDO the last command":
			decide yes.

			
to decide if resume is available:
	repeat through the table of final question options:
		if final question wording entry is "RESUME from the story mode checkpoint":
			decide yes.
			
[I further broke the outcomes into manageable chunks.]
			
to instate undo: [clears resume from the table of final question options, replacing it with "undo."]
	choose row with a final question wording of "RESUME from the story mode checkpoint" from the table of final question options;
	blank out the whole row;
	choose a blank row from the table of final question options;
	now the final question wording entry is "UNDO the last command";
	now the only if victorious entry is false;
	now the topic entry is the topic in row two of the table of ridiculous effort;
	now the final response rule entry is immediately undo rule.
	
to instate resume: [clears undo from the table of final question options, replacing it with "resume."]
	choose row with a final question wording of "UNDO the last command" from the table of final question options;
	blank out the whole row;
	choose a blank row from the table of final question options;
	now the final question wording entry is "RESUME from the story mode checkpoint";
	now the only if victorious entry is false;
	now the topic entry is the topic in row one of the table of ridiculous effort;
	now the final response rule entry is final resume rule.
	

Chapter 8 - culled from an arcane grimoire

[this code is copied verbatim from an intfiction forum post explaining how to delete an external file. In this case, it's only needed to get rid of two files when the game begins as a testing precaution.

https://intfiction.org/t/ignore-when-play-begins-rules-when-restarting/52247]

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

To delete (filename - external file):
	(- FileIO_DeleteFile( {filename} ); -).

Story Mode ends here.

---- DOCUMENTATION ----

This is version 2 of Story Mode. Why version 2? Version 1 relied on the Undo Output Control extension to resume story mode after a pause. After playtesting with multiple testers using Lectrote, I discovered that Parchment's autosave was not compatible with this method. This is the new, Parchment-supported version of Story Mode.

Story mode is one of a few efforts to provide a more accessible experience in parser games. I got the idea from John Ziegler, as he included this feature in his IFComp 2023 entry. This extension guides the player by preloading walkthrough commands from a table. Players need only press "enter" to proceed through the story. The preload is handled by Daniel Stelzer's "Command Preloading" extension. Pressing enter when the line is blank will progress the walkthrough as well. The other feature is a sandbox mode that players can use to experiment of familiarize themselves with parser gameplay. If a player enters a command that is not part of the walkthrough, story mode will pause until resumed by the player. In the interim, it is safe to experiment with with the game; there is no way to disrupt the walkthrough or damage the game world. This resume feature is realized via Daniel Stelzer's "Autosave extension." I should mention Wade Clarke, who made his own "Guide Mode" extension, and gave me advice and encouragement. His solution is definitely worth a look.

The primary goal of this effort is improved accessibility in parser games. Learn more about the Interactive Fiction Technology Foundation's report on disability testing here:
	
http://accessibility.iftechfoundation.org/

How is Story Mode different from other, similar extensions? Cosmetic differences are likely significant. This extension populates the command prompt, while others modify the prompt (or get rid of it completely).

This extension handles out of world commands with minimal fuss, like command preloading after saving and restoring (and cancellations/failures of the same).

Whitelisted commands do not advance the walkthrough, out of world or otherwise.

Depending on the current mode of play, the final question options will include either UNDO or RESUME

Ultimately, other options may work just as well as Story Mode--better, even--so try before you buy.

A special thanks to Tabitha for taking a final look at the extension before release; I am very grateful for their help.

Section 0 - implementing story mode in your project

A simple to-do list:

1. Determine a means for setting the needed startup values 	
2. Create your own walkthrough by continuing the "table of story steps" (template above)
3. Add whitelisted commands if needed (template above).
3. Customize user feedback (optional)

Section 1 - determine a means to set the needed startup values.

By default, story mode is disabled. To enable it, you need to read/set some variables. I automate the file test (determining if story mode supported is true or false), but the parameters likely need player input.
	
[if false, disable the relevant questions/options.]
story mode supported = true/false
	
playmode:
	1 = story mode is disabled.
	2 = story mode is enabled.
	
Therefore, if you did this:
	
when play begins:
	now playmode is 2.
	
...the game would begin in story mode.

We may want more granularity, though. Every person in a game has a value called "freedom." There are three possibilities: autonomous, guided, and in-scene. Autonomous is the same as playmode 1, but we need two options for playmode 2. These are guided and in-scene. When the player is guided, story mode is active. When the player is in-scene, story mode is paused. Every person is autonomous when play begins (in case you have multiple protagonists). These can be changed in action processing.

when play begins:
	now the player is guided.
	
For emphasis: configure both playmode and freedom when play begins.
	
The extension as written can handle changes to a player's freedom, with one exception. The author really should provide a way for the player to choose which mode they would like to experience, as a choice will be desirable in most imaginable cases.

If you'd like to see how I do this in my own work, I've published the source code to Repeat the Ending (just do a control-f for "when play begins").
	
https://kamin3ko.itch.io/repeat-the-ending. All Repeat the Ending materials are additionally stored at the IF Archive.

Section 2 - setting up the walkthrough
	
Once the relevant values are set, implementing story mode is straightforward. Two tables are required, the "table of story steps" and the "table of whitelisted commands." They are just what they sound like.
	
Copy the template of the "table of story steps (continued)" to your project. The "index" column should be filled with two consecutive dashes, or "--". The command column contains the steps of your story mode walkthrough. Add one command per line, enclosed by quotation marks (the entry is a text in Inform 7 terms). Since a target audience includes persons unfamiliar with parser games, I recommend avoiding abbreviations. Focus on readable commands, because they are meant to be read! Your walkthrough should lead the player to the end of the game, unless you intend for this to serve as a tutorial of some kind. In that case, you will probably need to replace my error message with something more informative.

Section 3 - setting up the whitelist

Copy the template of the "table of whitelisted commands (continued)" if necessary. Note that the table checks commands as they are entered, so if there is a possible abbreviation, grant the full command and the abbreviation each rows of their own. Besides out of world meta commands, things like help, about, and so forth might be good to include. Anything that you would like the player to use without pausing story mode belongs here. IMPORTANT: don't put whitelisted commands in your walkthrough. The whitelist is for commands that can be executed without pausing the walkthrough.

Section 4 - changing player feedback text (optional)

Should you wish to change my default responses and command prompt settings, see the comments above for code to copy and paste. This will disable the current rule, replacing it with something authors can edit.

Section 999 - on randmoness and other snags

A rigid walkthrough and randomized game conditions rarely fit together. Inform does offer ways to handle randomness in test situations, though you may be happier with a simple "if the player is guided" condition. "IF the player consents" are not presently accounted for this tool, either. The assumption is that the author will choose whatever option suits the story.

For example:

check taking the frob:
	if the player is not guided:
		say "Oh really? It looks super dangerous. Are you sure about that?"
			if the player consents:
				say "Hmm... if you say so.";
				continue the action;
			otherwise:
				say "Yeah, I think that's for the best.";
				stop the action;
	otherwise:
		say "Hm... if you say so.";
		continue the action.
		
Whatever your preferences might be, story mode sets values for authors to hook into, thereby manipulating texts or actions.

Example: ** A Second Chance - Break free of story mode, perform dangerous actions, then return to safety.

	*: "A Second Chance"

Include Story Mode by Drew Cook.
the player is in Lab.
the printed name of lab is "[If the player is guided]Lab ('test me' to exit the guide)[otherwise]Lab"

The Twilight Zone is north of Lab.

playmode selection is a truth state that varies.
playmode selection is false.

when play begins:
	say "'A Second Chance' offers two modes of play:

[bold type]Autonomous mode:[roman type]
[line break]Classic parser gameplay in the tradition of [italic type]Zork[roman type].
[paragraph break][bold type]Story Mode:[roman type]
[line break]A comfortable way to read the story of 'A Second Chance.' Actions are automated, though the reader can pause the mode to examine objects or explore independently.

A warning: players can leave story mode at any time, but it is only possible to enter story mode now, at the beginning of a new game.

Would you like to enable story mode?";
	if the player consents:
		now playmode is 2;
		now the player is guided;
		say "
[line break][bold type]Story mode activated.[roman type] The command prompt will automatically be filled with the next step of the walkthrough. Simply press the enter key to continue with story mode. You can also enter a blank/empty command to continue.

You can pause story mode at any time by entering something that is NOT the next pending command. In this way, you can examine objects or explore. Simply type RESUME at the prompt to return to story mode. Pressing the enter key while the command line is empty will have the same effect.

Press any key to continue.


";
	otherwise:
		now playmode is 1;
		now the player is autonomous;
		say "[line break][bold type]Autonomous mode activated.[roman type] 'A Second Chance' will provide a traditional gameplay experience.

Press any key to continue.



";
	wait for any key.


the description of lab is "This is a modest basement laboratory, filled with dirty, run-down, and rather dangerous looking equipment. In the center of the room is a large oak table. Despite its size, it is completely bare, save for a glass beaker filled with luminescent glop. A large, red button is on the wall, which you should probably look at after you've experimented a bit.

To the north, an very mysterious exit has a fuzzy, indeterminate appearance."

a large oak table is in lab. it is a scenery supporter.
the description of the large oak table is "Large. Heavy. Underused.".

a glass beaker is on the large oak table.
the glass beaker is an open container.
the glass beaker is transparent.
the glass beaker is not openable.
the description of the glass beaker is "Glass. Fragile. Gloppy."

some glop is in the glass beaker.
the description of the glop is "Mysterious. Gloppy. Glowing."

instead of doing anything other than examining to the glop:
	say "The glop looks disgusting and may well be dangerous. You decide to leave it be for now."


a beach ball is in lab.
instead of doing anything other than taking or dropping to the beach ball:
	say "The sole purpose of this beach ball is for players to leave story mode by picking it up. When story mode resumes, it will be back on the ground again, and the walkthrough will be ready to go."
	
instead of doing anything other than attacking or examining to the glass beaker:
	say "This beaker is here for players to break, therby pausing story mode. When story mode is resumed, the beaker will be whole once more. Not only that, the next command will be preloaded to the command line."
	
glassbreak is a truth state that varies.
glassbreak is false.
	
the block attacking rule does nothing when attacking the glass beaker.
carry out attacking the glass beaker:
	say "You grab the long-necked shaker by the neck, then break it against the sturdy table. The glop splashes all over you. Maybe that wasn't such a hot idea....";
	now glassbreak is true.
	
every turn when glassbreak is true:
	say "You are beginning to feel ill. That glop must have been as dangerous as it looked.".
	
The description of The Twilight Zone is "This room is completely undefined. There are no walls, no items to collect, no complex trinkets to master. It seems that Drew Cook never bothered to finish this space! And to think he hopes people will try this extension! Unfortunately, he did not even bother to make an exit. You are trapped!".

instead of going in the twilight zone:
	say "You can't even discern directions here. A blank whiteness seems to extend forever, radiating outward from you.".
	
table of story steps (continued)
index	input
--	"examine table"
--	"examine beaker"
--	"examine glop"
--	"examine ball"
--	"take beaker"
--	"push button"

the big red button is in lab.
the big red button is scenery.
instead of pushing the big red button:
	say "The laboratory suddenly explodes!";
	end the story finally saying "That was underwhelming.".

test me with "
break beaker /
get ball /
north /"
