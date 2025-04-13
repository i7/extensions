Version 2.2.0 of Story Mode by Drew Cook begins here.

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
	
VERSION 1: Initial release.

VERSION 2: Major teardown/rewrite due to conflicts with autosaving and the undo stack.

* Added check to determine if the story can read/write external files.
* Added check/write to final question options to replace UNDO with RESUME when story mode is paused.
* Set story mode to automatically name the save file based on title and version number.
* Several bug fixes and tweaks to output text.
* Set default freedoms (autonomous) for all persons in-game.
* Added templates to copy/paste for extending tables and modifying rules
* Added all out-of-world commands to whitelist in extension to spare author the trouble of keying them in manually.
* Added substantial text substitutions for commonly used punctuation and style modifiers. For instance, substituting "[italic type]" for "[italic type]"
* Spoofed UNDO responses on the first turn to populate prompt and/or roll back action count.
* Added example story.

VERSION 2.1:

* Minor line spacing changes


VERSION 2.2

* Code and commentary revisions for readability
* Changed the regular expression used to name the autosave file
* Changed whitelist behavior to allow whitelisted commands in the walkthrough script
* Introduced variables like "storybook" to allow authors to change data sources without breaking open the extension code
* Converted all printed text to rule responses that can be modified by authors in the usual way

Version 2.2 of Story Mode first appeared in Release 7 of Repeat the Ending and Release 1 of Marbles, D, and the Sinister Spotlight.

Note that version 2.2 is backward compatible.

]

Include Basic Screen Effects by Emily Short.
Include Undo Output Control by Nathanael Nerode.
Include Command Preloading by Daniel Stelzer.
Include Autosave by Daniel Stelzer.


Chapter 1 - naming some values

[

autonomous: free play/story mode disabled
guided: following the walkthrough
in-scene: walkthrough is temporarily paused

In the case of PC's that are not the built-in "player," we ought to specifically designate their freedoms.

Additionally, in the case of multiple playable characters, the freedom must be passed around.

	if the player is bob:	
		now the player is jenny;
		now the freedom of jenny is the freedom of bob.
	
why do it this way? I have a general theory that modular configuration is best, especially for low-effort items like this.

]

freedom is a kind of value.
the freedoms are autonomous, in-scene, and guided.
a person has a freedom.
a person is usually autonomous. [note that story mode is off unless specifically activated it in your project.]

[

1 = traditional gameplay
2 = story mode

It might seem like this is being tracked redundantly, but story mode can be active or paused. Playmode is rather inflexible, as it's set at play start (or it's risky to start it some other time, anyway) and turning it off is generally irrevocable. So I maintain it as a separate value.

This is also just another case where I prefer modular settings.]

playmode is a number that varies.
playmode is initially one.

[Action count is a variable that is matched to the index entry of the storybook. It is the basic unit of progression through Story Mode.]

action count is a number that varies.
action count is one.

[Story Mode uses autosave functionality to resume paused walkthroughs. It makes sense to verify that a game can write/read an external file before activating Story Mode.

Note that the Story Mode extension does not use this verification anywhere. The determination is made here so that authors can perform checks before activating story mode in their games. For instance:
	
	when play begins:
		if story mode is supported:
			now the freedom of the player is guided;
			now playmode is two;
		
]

story mode supported is a truth state that varies.
story mode supported is false.

[
The "delete file" phrase below is based on Inform 6 sorcery. I have no idea what it is or how it works. Since it isn't terribly readable (not to me, anyway), it is situated at the end of this extension. Wade Clarke posted the code in this thread:
	
https://intfiction.org/t/ignore-when-play-begins-rules-when-restarting/52247
]

the file of mythical creatures is called "mythic".
	
[this is just a dummy table that we use to do our file test when play begins]

table of mythical creatures
name
"chimera"

[We write out the dummy file, then try to check it. If the file is present, "story mode supported" is declared true.]

first when play begins (this is the initial file check rule):
	write file of mythical creatures from table of mythical creatures;
	if file of mythical creatures exists:
		now story mode supported is true;
		delete file of mythical creatures;
		determine the save name;
	otherwise:
		now story mode supported is false.
		
[The goal is just to arrive at a reasonably distinctive filename for the autosave. If another name is preferred, that poses no problem, since the last named file wins. We can just declare our own.

Note: if a game has an unusual character in its title, it may require a manually-configured filename.

This regular expression is looking for the first (up to five) characters of the game's title. version 3 of a game named "D" would get an autosave filename of "D_3_autosave.glksave" while version 1 of a game called "Marbles, D, and the Sinister Spotlight" would be called "Marbl_1_autosave.glksave".]


to determine the save name:
	let trimmed txt be a text;
	if story title is "":
		now trimmed txt is "far_out";
	otherwise if story title matches the regular expression "^.{1,5}":
		now trimmed txt is text matching regular expression;
	now autosave filename is "[trimmed txt]_[release number]_autosave".


Chapter 1 - data

Section 1a - walkthrough information/steps

[
The storybook is a simple table containing a list of commands. Story mode will execute these commands, one at a time, in order. These are entered as text in quotes.

	the storybook is the table of sample code.

	table of sample code
	index	input
	(a number)	"get lamp"
	--	"go east"
	--	"turn on lamp"

We will likely want to make their own table in a project and change the storybook variable to point at it. The below table is just a placeholder allowing us to compile the game. 

Why index numbers when row numbers could be used instead? It's possible to change the numbers during play, but changing rows isn't nearly as convenient. It's simply a door left open; changing index entries is not something I currently do.
]
		
the storybook is a table name that varies.
the storybook is usually the table of story steps.

table of story steps
index	input
1	""

[this is just a convenience to make manual row numbering unnecessary. it can be delisted if desired]

when play begins (this is the story mode autonumbering rule):
	let t be one;
	repeat through the storybook:
		now index entry is t;
		increment t;

Section 1b - the whitelist

[

Whitelisted commmands do not pause the walkthrough. If a player wants to save a game or open a hint menu, we can permit it without shutting things down or printing extra messages.

Unlike the storybook, it might be preferable to keep the default since it includes every out-of-world command. In that case, just continue the existing table. New entries can be added in this manner:
	
	table of whitelisted commands (continued)
	input
	"jump"

]

the whitelist is a table name that varies.
the whitelist is usually the table of whitelisted commands.

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


[A check to determine if a text (the player's command) is on the whitelist. This is checked against every command while the player is guided.]

to decide if (t - a text) is whitelisted:
	repeat through the whitelist:
		if t is input entry:
			decide yes;
	decide no;

Chapter 2 - decisions

[If an Inform game is asked to read an empty row, it will throw a runtime error. Story Mode will exit before precipitating this condition. These two checks are used to verify that there is at least one pending command to process.

If the Action Count variable is greater than the number of filled rows in the storyboook, Story Mode will exit.]

to decide if there are story steps remaining:
	let FR be the number of filled rows in the storybook;
	if the action count is less than FR or action count is FR:
		decide yes.
		
to decide if there are no story steps remaining:
	let FR be the number of filled rows in the storybook;
	if the action count is greater than FR:
		decide yes.
		
[Every Action Count (a number) has a corresponding command (the current step), and the Action Count goes up as commands are processed.]
		
to decide which text is the current step:
	choose row with an index of action count from the storybook;
	decide on input entry in lower case.

Chapter 3 - before reading a command

[

Each of these rules checks to verify there are available steps in the walkthrough before proceeding]

[in a normal walkthrough situation:
	
1. autosave
2. load a command from the table of story steps
3. autopopulate the command prompt with it (Command Preloading by Daniel Stelzer).

if story mode has resumed (loaded an autosave):

1. Switch back to guided player state
2. load a command from the table
3. autopopulate the prompt (Command Preloading by Daniel Stelzer).

]

[Every printed text in this extension is a rule response that authors can modify in-game without editing the extension itself.]


before reading a command when the player is guided and there are no story steps remaining (this is the first empty buffer rule):
	say "Command buffer empty. Leaving story mode." (A);
	now the player is autonomous;
	now playmode is 1;
	rule succeeds;	

before reading a command when the player is guided and there are story steps remaining (this is the command preparation rule):
	if action count is less than the number of filled rows in the storybook: [if we autosave on the last turn of the game, post-game resumes may not work]
		autosave the game;
		preload the command current step;
	if we restored an autosave:[this is a feature built into the autosave extension, we can check this during action processing]
		say "[line break][bracket][italic type]Resuming story mode and restoring previous world state.[roman type][close bracket][line break]" (A);
		now the player is guided;
		preload the command current step;
		try looking;
	continue the action;
		
rule for repairing an empty command (this is the command repair rule): [from Undo Output Control]
	if the player is guided:
		say "[bracket][italic type]Performing the next command in the walkthrough: [bold type][current step][roman type][close bracket][line break]" (A);
		change the text of the player's command to "[current step]";
	otherwise if the player is in-scene:
		try resuming.
		
[
	
Undo should behave "normally" outside of story mode. It's mostly "normal" inside, too, but expectations might make things seem weird. The undo stack is part of a saved game. If the game autorestores, a new undo stack comes along with that.

Note that "normal" *UNDO* behavior can mean the player has undone a resume command, or possibly redone a comand that would pause or resume the walkthrough. A player can easily UNDO from in-scene to guided mode. While this all makes sense, it may make trolling the extension feel more revelatory than it actually is. In version one of story mode, I disabled UNDO unless resuming the walkthrough. Ultimately, I decided that if players want to experiment, I should protect them from breaking the game but otherwise leave them to it.

]

[This is all high effort because of exceptions such as "what happens on the first turn?" or "what if an out of world command happened, since those don't advance turn count?" etc. Hopefully that's all covered.]
		
before undoing an action when the player is guided (this is the first turn undo rule):
	if turn count is one:
		if action count is greater than one:[This is essentially a spoof. If turn count and action count get out of sync (due to out-of-world actions, possibly), we just need to roll back action count and keep moving.]
			say "[bracket]Previous turn undone.[close bracket][line break]" (A);
			decrement the action count;
			choose row with an index of action count from the storybook;
			preload the command input entry;
			rule fails;
		otherwise:[This is a spoof, too, of a parser error.]
			say "You can’t 'undo' what hasn’t been done!" (B);
			choose row with an index of action count from the storybook;
			preload the command input entry;
			rule fails;

[if the player enters *UNDO* during guided mode, we want to continue populating the prompt with the next command. Both this and the previous undo customizaiton use Nathanael Nerode's "Undo Output Control"]

[This isn't changing undo operation. Instead, it is responding to what play mode the the player undoes INTO. That is, whether Story Mode is active at the start of the turn, what is the state after Undoing? This gets verified before printing some feedback.]

report undoing an action when playmode is 2 (this is the undo during story mode rule):
	if the player is guided:
		say "[bracket]Previous turn undone. Story mode is currently active.[close bracket]" (A);
		say line break;
		choose row with an index of action count from the storybook;
		preload the command input entry;
		rule succeeds;
	if the player is in-scene:
		say "[bracket]Previous turn undone. Story mode is currently paused.[close bracket]" (B);
		rule succeeds;
	
Chapter 4 - after reading a command

[Another check to prevent runtime errors]

after reading a command when the player is guided and there are no story steps remaining (this is the second empty buffer rule):
	say "Command buffer empty. Leaving story mode." (A);
	now the player is autonomous;
	now playmode is 1;
	rule succeeds;
	
[This is the typical Story Mode behavior. Check the command against the whitelist, then check it against the storybook.

Depending on what matches up, either advance or pause Story Mode.]
	
after reading a command when the player is guided and there are story steps remaining (this is the story progression rule):
	let t be the player's command in lower case;
	if t is whitelisted and t is not the current step:[process whitelisted commands without pausing story mode]
		continue the action;
	otherwise:
		if t is not the current step:[pause story mode if the command is not on-script]
			now the player is in-scene;
			say "[bracket][italic type]Temporarily leaving story mode. You can return at any time by entering a blank/empty command or else typing RESUME.

If you wish to permanently leave story mode, simply *LEAVE STORY MODE*.[roman type][close bracket][line break]" (A);
		otherwise if t is the current step:[advance through the walkthrough]
			increment the action count;


Chapter 5 - other stuff
		
section 1 - resume

[I use *RESUME* because it makes intuitive sense. I think most people will resume by pressing enter on a blank line, anyway. As always, authors can add their own "understand" grammar lines.]

resuming is an action out of world applying to nothing.
carry out resuming (this is the resume play rule):
	if the player is in-scene:
		autorestore the game;
		say "File not found. Resuming story mode is not possible. Please consider notifying the author of the story mode extension. He will be entirely mortified." (A);[this only prints if autorestore fails]
	otherwise if the player is guided:
		say "Resuming is only possible while story mode is paused." (B);
	otherwise:
		say "Resuming is specific to story mode, which isn't currently active." (C);
		
this is the final resume rule:
	autorestore the game.
	
understand "resume" as resuming.

section 3 - leaving story mode

[This is a wordy command, but I want to make sure the player thinks first. We can always add other "understand" lines.]

leaving story mode is an action applying to nothing.
understand "leave story mode" as leaving story mode.

Carry out leaving story mode (this is the exit story mode rule):
	say "Would you like to permanently leave story mode? This decision is irreversible." (A);
	if the player consents:
		say "Understood. Leaving story mode." (B);
		now the player is autonomous;
		now playmode is 1;
		now the command prompt is ">";[This should never be needed unless the game itself has been modifying the command prompt, or unless ]
		try looking;
	otherwise:
		say "Understood. Remaining in story mode." (C);

	
Chapter 6 (switch undo/resume as needed at end of game)

[As a last touch, players with a paused story when the game ends should be offered a "resume" rather than an "undo" option. Since the player's freedom can change during the game, this will need to be verified whenever the story ends.

These options are stored in the table of final question options (in the standard rules), so we'll have to do some table lookups and changes on the fly when the game is over.

Because Inform sees texts and topics as separate things (a truly valuable distinction, I'm sure), it's necessary to update topics in the table of final question options via a very roundabout method. The approach is to set the topic by choosing a topic in another table.]

to decide which topic is the relevant option:
	choose row with a status of the freedom of the player from the table of pointless distinctions;
	decide on topic entry;
	
table of pointless distinctions
status	topic
autonomous	"undo"
guided	"undo"
in-scene	"resume"
			
last when play ends (this is the finalized questions rule):
	if the player is not in-scene:
		if there is a final question wording of "UNDO the last command" in the table of final question options:
			rule succeeds;
		otherwise if there is a final question wording of "RESUME from the story mode checkpoint" in the table of final question options:
			choose row with a final question wording of "RESUME from the story mode checkpoint" from the table of final question options;
			now final question wording entry is "UNDO the last command";
			now topic entry is the relevant option;
			now the final response rule entry is immediately undo rule;
	otherwise if the player is in-scene:
		if there is a final question wording of "RESUME from the story mode checkpoint" in the table of final question options:
			rule succeeds;
		otherwise if there is a final question wording of "UNDO the last command" in the table of final question options:
			choose row with a final question wording of "UNDO the last command" from the table of final question options;
			now final question wording entry is "RESUME from the story mode checkpoint";
			now topic entry is the relevant option;
			now final response rule entry is final resume rule.

	

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

This is version 2.2 of Story Mode.

Story mode is one of a few efforts to provide a more accessible experience in parser games. I got the idea from John Ziegler, as he included this feature in his IFComp 2023 entry. This extension guides the player by preloading walkthrough commands from a table. Players need only press "enter" to proceed through the story. The preload is handled by Daniel Stelzer's "Command Preloading" extension. Pressing enter when the line is blank will progress the walkthrough as well. The other feature is a sandbox mode that players can use to experiment of familiarize themselves with parser gameplay. If a player enters a command that is not part of the walkthrough, story mode will pause until resumed by the player. In the interim, it is safe to experiment with with the game; there is no way to disrupt the walkthrough or damage the game world. This resume feature is realized via Daniel Stelzer's "Autosave extension." I should mention Wade Clarke, who made his own "Guide Mode" extension and gave me advice and encouragement. His solution is definitely worth a look.

The primary goal of this effort is improved accessibility in parser games. Learn more about the Interactive Fiction Technology Foundation's report on disability testing here:
	
http://accessibility.iftechfoundation.org/

How is Story Mode different from other, similar extensions? Cosmetic differences are likely significant. This extension populates the command prompt, while others modify the prompt (or get rid of it completely).

This extension handles out of world commands with minimal fuss, like command preloading after saving and restoring (and cancellations/failures of the same).

A whitelist permits designated actions without disrupting the walkthrough.

Depending on the current mode of play, the final question options will include either UNDO or RESUME.

Ultimately, other options may work just as well as Story Mode--better, even--so try before you buy.

A special thanks to Tabitha for taking a final look at the extension before the v2 release; I am very grateful for their help.

Section 0 - implementing story mode in your project

A simple to-do list:

1. Determine a means for setting the needed startup values 	
2. Create your own walkthrough by creating and naming the "storybook" (a table name)
3. Add whitelisted commands if needed.
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

We need more granularity, though, so every person in a game has a value called "freedom." There are three possibilities: autonomous, guided, and in-scene. Autonomous is companion to playmode one, but we need two options for playmode 2. These are guided and in-scene. When the player is guided, story mode is active. When the player is in-scene, story mode is paused. Every person is autonomous when play begins (in case you have multiple protagonists). These can be changed in action processing.

	when play begins:
		now the player is guided.
	
For emphasis: configure both playmode and freedom when play begins.
	
The extension as written can handle changes to a player's freedom, with one exception. The author really should provide a way for the player to choose which mode they would like to experience, as a choice will be desirable in most imaginable cases.

A simple possibility:
	
	when play begins:
		say "This game features a 'Story Mode' feature that will automatically move the player through the story. Would you like to begin in Story Mode?";
		if the player consents:
			say "Story Mode is now active.";
			now playmode is 2;
			now the player is guided.
			
another possibility:
	
	after looking for the first time:
		say "Type STORY at the command prompt to enter Story Mode, an automated walkthrough feature. Note that it is only possible to enter Story Mode now, at the beginning of the game.";
		
	story moding is an action out of world applying to nothing.
	understand "story" as story moding.
	
	check story moding:
		if turn count is not 1:
			say "Story Mode is only available at the start of the game." instead.
			
	carry out story moding:
		"OK! Story Mode is now active.";
		now playmode is 2;
		now the player is guided.
	
Here's yet another, more complex approach (this is what I use in my own work), based on code by Wade Clarke:

	[This checks to a keypress and can be used before the game proper begins. The "key-pressed" number will be used in a moment.]
	
	To decide what number is the key-pressed:
		let keypress be 0;
		while keypress is 0:
			let keypress be the chosen letter;
		now keypress is keypress minus 48;[keypress doesn't match the number pressed, which isn't so strange given the number of non-numeric keys on a keyboard.]
	[say "[cc] Keypress number is [keypress].[line break]";][Uncomment this line to see what number the game is seeing when the player presses a particular key.]
		decide on the keypress;
		
	[now, we can set up a definition that we can use (and reuse) to set variables with our key-pressed]
	
	To ask the story mode question:
	while 1 is 1:
		let KEYPRESS be the key-pressed;
		if KEYPRESS > 0 and KEYPRESS < 3:[We can set these parameters to whatever we need. In our case, we will only have two options for the player.]
			now chosen interface is KEYPRESS;[store the answer, a 1 or 2, for later, in this variable.]
			make no decision;[once the player presses either the 1 or two key, the "question" has been answered.]
			
	[now we can ask our question whenever we like]
	
	when play begins:
		say "How would you like to experience this game?

	1. [bold type]Classic[roman type]. A traditional parser game experience.
	[line break]2. [bold type]Story Mode. A comfortable way of experiencing the story. Commands are automatically entered while the player reads along. Pause at any time to explore or experiment.";
		say line break;
		ask the story mode question;
		if key-pressed is 1:
			say "Traditional Mode it is!";
		otherwise if key-pressed is 2:
			say "Confirmed. Story mode is now active.";
			now playmode is 2;
			now the player is guided.	
		
These are just ideas. The important thing is that the variables must be set in-game.

Section 2 - setting up the walkthrough
	
Once the relevant values are set, implementing story mode is straightforward. Two tables are required, the "storybook" and the "whitelist". They are just what they sound like.

First, we should set the "storybook" and "whitelist" variables if we are using our own table names.

	the storybook is the table of walkthrough information.
	the whitelist is the table walkthrough alternatives.
	
Next, the template of the "table of story steps" must be added to our own project. The "index" column should be filled with two consecutive dashes, or "--" (it is possible to number them manually, but that will probably be an atypical case). The input column contains the steps of the Story Mode walkthrough. Add one command per line, enclosed by quotation marks (the entry is a text in Inform terms). Since my imagined target audience includes persons unfamiliar with parser games, I recommend avoiding abbreviations. Focus on readable commands, because they are meant to be read! A walkthrough should lead the player to the end of the game, unless it is meant to serve as a tutorial of some kind.

	table of walkthrough information
	index	input
	(a number)	"jump"
	--	"take the hamburger"
	--	"put the hamburger in the trash can"
	--	"XYZZY"
	--	"UNLOCK DOOR WITH KEY"
	
...and so forth.

Section 3 - setting up the whitelist

Copy the template of the "table of whitelisted commands (continued)" if necessary. Note that the table checks commands as they are entered, so if there is a possible abbreviation, grant the full command and the abbreviation each rows of their own. Besides out of world meta commands, things like help, about, and so forth might be good to include. Anything that you would like the player to use without pausing story mode belongs here. Note that out-of-world commands do not advance turn count, and keeping turn count and action count synced might be desirable.

I try to avoid advancing turn count with whitelisted commands, even though there are currently no known issues with doing so.

Section 4 - changing player feedback text (optional)

As of version 2.2 of Story Mode, all printed texts are rule responses that can be modified without changing the extension's code. For instance:
	
	the resume play rule response (A) is "Your autosave file is missing. Bummer :([line break]".

Section 999 - on randomness and other snags

A rigid walkthrough and randomized game conditions rarely fit together. While Inform offers ways to handle randomness in test situations, we may be happier with a simple "if the player is guided" condition. "IF the player consents" are not presently accounted for this tool, either. The assumption is that the author will choose whatever option suits the story.

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
			
Story Mode sets values for authors to hook into, thereby manipulating texts or actions.

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

To the north, a very mysterious exit has a fuzzy, indeterminate appearance."

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
	say "This beaker is here for players to break, thereby pausing story mode. When story mode is resumed, the beaker will be whole once more. Not only that, the next command will be preloaded to the command line."
	
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
