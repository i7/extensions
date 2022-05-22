Version 1.2 of Basic Help by David Cornelson begins here.

Helping is an action out of world applying to one visible thing.
DefaultHelping is an action out of world.
Understand "help [any help command]" as helping.
Understand "help" as defaulthelping.

A help command is a kind of thing.
It is always privately-named.

Help Switch is a truth state that varies.
Help Count is a number that varies.
Help Fade is a number that varies.

When play begins:
	say "This game is equipped with a simple help system. Type [bold type]help[roman type] to learn more about Interactive Fiction.";
	now the Help Count is 0;
	now the Help Fade is 5;
	now the Help Switch is true.

Every turn when the help switch is true:
	increase Help Count by 1;
	if Help Count is less than Help Fade:
		Print the Help Notice;
	else:
		now Help Count is 0;
		now Help Switch is false;
		say "The help system will now turn off its reminder, but you can always type 'help' at any time."

After printing a parser error:
	if the Help Switch is true:
		say "[line break]";
		Print the Help Notice.

To Print the Help Notice:
	say "Remember, you can type 'help' if you need assistance."

Chapter 1 - Basic Help

Basic Help is a help command.
Understand "basic" as Basic Help.

Report defaulthelping:
	Print Basic Help.
	
Report helping Basic Help:
	Print Basic Help.

To Print Basic Help:
	say "[bold type]Welcome to Interactive Fiction![roman type]

You are entering a new world where you play the main character in a fictional story. Unlike reading a book, Interactive Fiction allows you to enter natural language commands that are translated to the story.

For more help, type one of the following commands:[line break][line break]
    [bold type]help commands[line break]
    help map[line break]
    help puzzles[line break]
    help characters[roman type][line break]".

Chapter 2 - Map Help

Map Help is a help command.
Understand "map","n","north","s","south","e","east","w","west","ne","northeast","nw","northwest","se","southeast","sw","southwest","in","out","up","down","directions","directional","exits" as Map Help.

Report helping Map Help:
	say "[bold type]Map Help[roman type]

In order to move around the setting of an Interactive Fiction game,  the most common method is using compass directions. This includes [bold type]north[roman type], [bold type]south[roman type], [bold type]east[roman type], [bold type]west[roman type], as well as [bold type]northeast[roman type], [bold type]northwest[roman type], [bold type]southeast[roman type], [bold type]southwest[roman type]. You can abbreviate these with [bold type]n[roman type], [bold type]s[roman type], [bold type]e[roman type], [bold type]w[roman type], [bold type]ne[roman type], [bold type]nw[roman type], [bold type]se[roman type], [bold type]sw[roman type]. Other directional commands include [bold type]in[roman type], [bold type]out[roman type], [bold type]up[roman type] or [bold type]u[roman type], and [bold type]down[roman type] or [bold type]d[roman type]. Sometimes you can [bold type]enter[roman type] or [bold type]embark[roman type] and then [bold type]exit[roman type] or [bold type]disembark[roman type]."

Chapter 3 - Puzzle Help

Puzzle Help is a help command.
Understand "hint","hints","puzzle","puzzles" as Puzzle Help.

Report helping Puzzle Help:
	say "[bold type]Puzzle Help[roman type]

During the game you will encounter puzzles within the story. You may need to open something, talk to someone about something, find something, discover something, and more. Most puzzles should have a logical explanation although sometimes authors get tricky and raise the level of difficulty in a game. In these cases, you should read all of the game text thoroughly, talk to your friends about the game, and eventually you will find a solution. Of course you can always ask for a hint by typing [italic type]hint[roman type]."

Chapter 4 - Command Help

Command Help is a help command.
Understand "command","commands","syntax","words" as Command Help.

Report helping Command Help:
	say "[bold type]Command Help[roman type]

Each Interactive Fiction story has a common set of commands as well as additional commands particular to the story. Common commands include: [Help Common Commands].

Some commands require a single object, as in [italic type]examine painting[roman type]. Other commands have a more complex syntax, such as [italic type]put sock in drawer[roman type]. In some cases, a command will require a preposition and possibly adjectives, as in [italic type]pull the green cart into the south tunnel with the long rope[roman type].

There are several commands that are called 'out of world' commands and these help you interact with the product and not the story. The out of world commands include:[line break][line break]
[bold type]save[roman type] - allows you to save your game[line break]
[bold type]restore[roman type] - allows you to restore a previously saved game[line break]
[bold type]restart[roman type] - allows you to start the game from the beginning[line break]
[bold type]quit[roman type] - allows you to quit the game and close the product[line break]
[bold type]undo[roman type] - allows you to undo up to five previous turns[line break]
[bold type]transcript[roman type] - allows you to output the game text to an external text file (transcript on/transcript off)[line break]
[bold type]version[roman type] - allows you to see the version and credits for the game[line break]
[bold type]score[roman type] - displays the current score, if the game implements scoring[line break]
[bold type]brief[roman type] - displays short location setting descriptions, but be careful - many games hide their best puzzles in the details of a good description[line break]
[bold type]verbose[roman type] - displays full location setting descriptions (recommended)[line break]"

Help Common Commands is a list of text that varies.
Help Common Commands is {"examine", "search", "look", "inventory", "run", "jump", "kiss", "eat", "listen", "smell", "taste", "touch", "take", "get", "drop", "hit", "kill", "attack", "punch", "light", "turn", "push", "press", "pull", "move", "steal", "put", "read", "remove", "turn", "show", "switch"}.

To Say Help Common Commands:
	let x be the number of entries in Help Common Commands;
	let y be a number;
	let y be 0;
	repeat with n running through Help Common Commands:
		increase y by 1;
		if y is less than x:
			say "[bold type][n][roman type], ";
		else:
			say "and ";
			say "[bold type][n][roman type]".

Chapter 5 - Characters Help

Character Help is a help command.
Understand "character", "characters", "people", "actor", "actors", "npc", "npcs" as Character Help.

Report helping Character Help:
	say "[bold type]Characters Help[roman type]

Every story has a protagonist, the lead, or main character. This is the part that you're playing. But every story also has other characters and Interactive Fiction is no different. Although it's entirely possible to encounter an Interactive Fiction story without any other characters, it's important to understand how to interact with them. Obviously you can use some of the common commands to [italic type]kiss[roman type] or [italic type]kill[roman type] another character, but sometimes it's best to just talk. In order to talk to another character you need to initiate a conversation. Interactive Fiction, just like many books, has different ways of handling conversation.

The most common conversation types include:[line break]
[bold type]menu driven[roman type] - menu driven conversations are a tree-like menu system that allows you to select preset talking points like 'You ask Bob about borrowing the lawn mower.'[line break]
[bold type]ask/tell[roman type] - ask/tell is a simple conversation system that requires you to ask a character about a topic, such as 'ask carol about bob' or 'ask bob about work'[line break]
[bold type]talk to[roman type] - talk to is an even simpler conversation system that requires you to simply talk to a character, as in 'talk to bob' or 'talk to carol' and will often use your current circumstances to identify the appropriate response

The characters within an Interactive Fiction story may help you or they may hinder you. They may provide valuable information or be completely useless. They may follow you or have their own paths to follow. Some will be people, some will be animals, and some might even be a ghost.[line break]";


Chapter A - Test Commands

test me with "help / help commands / help map / help puzzles / help characters";

Basic Help ends here.

---- DOCUMENTATION ----

This extension allows you to add basic Interactive Fiction help to your game.

When play begins, that the help system will display a message telling of its existence.

After a parser error, the hint system will remind the player it's available.

For the first 4 turns in the game, the hint system will show a notice.

The author can add common commands by using the list 'add' feature and this will display them within the 'help commands' description.

	when play begins:
		add "xyzzy" to Help Common Commands.

After the help has stopped reminding the player, the author can set the Help Switch to true and for another 4 turns, the help reminder will be displayed.

If the author simply wants to remind the player directly, they can 'Print the Help Notice' at any time.


Section: 6L02 Compatibility Update

This extension differs from the author's original version: it has been modified for compatibility with version 6L02 of Inform. The latest version of this extension can be found at <https://github.com/i7/extensions>. 

This extension is released under the Creative Commons Attribution licence. Bug reports, feature requests or questions should be made at <https://github.com/i7/extensions/issues>.

