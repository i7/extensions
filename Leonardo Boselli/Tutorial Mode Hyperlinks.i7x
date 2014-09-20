Version 2/140825 of Tutorial Mode Hyperlinks by Leonardo Boselli begins here.

"Adds a tutorial mode, which is on by default, to any game, to introduce key actions for the novice player. Can be revised or expanded by the author. Changes to the original version: added the hyperlinks of the Hyperlink Interface. Based on Tutorial Mode by Emily Short."

Include Conversation Package by Eric Eve.
Include Hyperlink Interface by Leonardo Boselli.

Section 1 - Creating tutorial mode and controls

After looking for the first time (this is the tutor first time looking rule):
	say "[no line break]([italic type]Type [t]TUTORIAL ON[x][italic type] to follow an interactive tutorial about the game[roman type]).[paragraph break]" (A);
	continue the action.

Tutorial mode is a truth state that varies. Tutorial mode is false.

Understand "tutorial mode off" or "tutorial off" as turning off tutorial mode.
Understand "tutorial" or "tutorial on" or "tutorial mode" or "tutorial mode on" as turning on tutorial mode.

Turning off tutorial mode is an action out of world.

Check turning off tutorial mode (this is the turn off tutorial rule):
	if tutorial mode is false, say "Tutorial mode is already off." (A) instead.

Carry out turning off tutorial mode:
	now tutorial mode is false;
	continue the action;
	
Report turning off tutorial mode (this is the report turn off tutorial rule):
	say "[t]Tutorial mode[x] is now off. You[']d better to continue the tutorial if the meaning of the hyperlinks emphasized with the following styles is not clear to you: [o]objects[x], [d]directions[x], [t]topics[x]." (A).

Turning on tutorial mode is an action out of world.

Check turning on tutorial mode (this is the check turning on tutorial rule):
	if tutorial mode is true, say "Tutorial mode is already on or it is already fully executed." (A) instead.

Carry out turning on tutorial mode:
	now tutorial mode is true;
	continue the action;
	
Report turning on tutorial mode (this is the report turning on tutorial rule):
	say "Tutorial mode is now on." (A).

Section 2 - Forcing player response

The example-thing is a thing that varies.
The example-worn is a thing that varies.
The example-talker is an person that varies.
The example-argument is an object that varies.
The example-contained is a thing that varies.
The example-container is a container that varies.
The example-direction is a direction that varies.

The expected command is an indexed text that varies. 
The held rule is a rule that varies. 
The completed instruction list is a list of rules that varies.

Understand "restore" or "quit" or "save" or "restart" or "version" as "[meta]". 

After reading a command when tutorial mode is true (this is the require correct response rule):
	if the player's command includes "tutorial", make no decision;
	if the player's command includes "[meta]", make no decision;
	if the expected command is "THE END":
		try silently turning off tutorial mode;
		make no decision;
	now the expected command is the substituted form of "[the expected command in lower case]";
	let the translated command be the substituted form of "[the player's command]";
	if the translated command exactly matches the text expected command:
		now the expected command is "THE END";
		if the held rule is a selector listed in the Table of Instruction Followups:
			choose row with a selector of the held rule in the Table of Instruction Followups;
			say "[italic type][followup entry][roman type][paragraph break]";
		otherwise:
			say "[italic type][one of]Very well[or]Excellent[or]Good[or]Perfect[at random][one of]![or].[at random][roman type]" (A);
		add the held rule to the completed instruction list;
		now the held rule is the little-used do nothing rule;
	otherwise:
		say "[italic type][one of]No[or]I[']m sorry[at random], [one of]it[']s not this[or]retry[at random].[roman type]" (B);
		reject the player's command;

Section 3 - The Instructional Rules

Before reading a command when tutorial mode is true (this is the offer new prompt rule):
	follow the instructional rules.

The instructional rules are a rulebook.

An instructional rule (this is the teach looking rule): 
	if the teach looking rule is listed in the completed instruction list, make no decision;
	say "[italic type]In every moment, to get a look around, type [t]LOOK[x][italic type] on the command line and you'll get a description of what is around you. (If you are already familiar with interactive fiction and this kind of interface based on hyperlinks, you can stop the tutorial typing [t]TUTORIAL OFF[x][italic type].)[roman type]" (A);
	now the expected command is "look" (B);
	now the held rule is the teach looking rule;
	rule succeeds.

An instructional rule (this is the teach examining rule): 
	if the teach examining rule is listed in the completed instruction list, make no decision;
	if the player can see the example-thing:
		let N be "[the example-thing]";
		say "[italic type]Also the objects have their descriptions. You can examine any object to learn something more about it just typing [t]EXAMINE [N in upper case][x][italic type].[roman type]" (A);
		now the expected command is substituted form of "examine [N]" (B);
		now the held rule is the teach examining rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach taking rule):
	if the teach taking rule is listed in the completed instruction list, make no decision;
	if (the player does not carry the example-thing) and (the player does not wear the example-thing):
		let N be "[the example-thing]";
		say "[italic type]You can take objects, when you see them, typing [t]TAKE [N in upper case][x][italic type].[roman type]" (A);
		now the expected command is substituted form of "take [N]" (B);
		now the held rule is the teach taking rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach inventory rule): 
	if the teach inventory rule is listed in the completed instruction list, make no decision;
	if the player carries the example-thing:
		say "[italic type]Now you hold something in your hands. To discover all the objects that you carry or wear, type [t]INVENTORY[x][italic type].[roman type]" (A);
		now the expected command is "inventory" (B);
		now the held rule is the teach inventory rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach dropping rule):
	if the teach dropping rule is listed in the completed instruction list, make no decision;
	if the player carries the example-thing:
		let N be "[the example-thing]";
		say "[italic type]If you want to free you hands, drop the objects typing [t]DROP [N in upper case][x][italic type].[roman type]" (A);
		now the expected command is substituted form of "drop [N]" (B);
		now the held rule is the teach dropping rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach taking off rule):
	if the teach taking off rule is listed in the completed instruction list, make no decision;
	if the player wears the example-worn:
		let N be "[the example-worn]";
		say "[italic type]You can take off what you wear typing [t]TAKE OFF [N in upper case][x][italic type].[roman type]" (A);
		now the expected command is substituted form of "take off [N]" (B);
		now the held rule is the teach taking off rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach wearing rule):
	if the teach wearing rule is listed in the completed instruction list, make no decision;
	if the teach dropping rule is not listed in the completed instruction list, make no decision;
	if the player carries the example-worn:
		let N be "[the example-worn]";
		say "[italic type]You can also wear objects typing [t]WEAR [N in upper case][x][italic type].[roman type]" (A);
		now the expected command is substituted form of "wear [N]" (B);
		now the held rule is the teach wearing rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach extracting rule):
	if the teach extracting rule is listed in the completed instruction list, make no decision;
	if the example-contained is contained in the example-container:
		let N be "[the example-contained]";
		say "[italic type]You can also take an object which is into a container, like [the example-contained][italic type] in [the example-container][italic type]. If you want to take it, type [t]TAKE [N in upper case][x][italic type] as usual.[roman type]" (A);
		now the expected command is substituted form of "take [N]" (B);
		now the held rule is the teach extracting rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach inserting into rule):
	if the teach inserting into rule is listed in the completed instruction list, make no decision;
	if the player carries the example-contained:
		let N be "[the example-contained]";
		let N1 be "in [the example-container]" (A);
		say "[italic type]To put an object in a container, you can type [t]PUT [N in upper case] [N1 in upper case][x][italic type].[roman type]" (B);
		now the expected command is substituted form of "put [N] [N1]" (C);
		now the held rule is the teach inserting into rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach hailing rule):
	if the teach hailing rule is listed in the completed instruction list, make no decision;
	if the player can see the example-talker:
		let N be "[example-talker]";
		say "[italic type]If you want to begin a conversation with someone, type [t][N in upper case], HI[x][italic type].[roman type]" (A);
		now the expected command is substituted form of "[N], hi" (B);
		now the held rule is the teach hailing rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach asking about rule):
	if the teach asking about rule is listed in the completed instruction list, make no decision;
	if the teach hailing rule is not listed in the completed instruction list, make no decision;
	if the current interlocutor is the example-talker:
		let N be "[the example-argument]" (A);
		say "[italic type]If you want to ask about specific informations, type [t]ASK ABOUT [N in upper case][x][italic type].[roman type]" (B);
		now the expected command is substituted form of "ask about [N]" (C);
		now the held rule is the teach asking about rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach goodbye rule):
	if the teach goodbye rule is listed in the completed instruction list, make no decision;
	if the teach hailing rule is not listed in the completed instruction list, make no decision;
	if the teach asking about rule is not listed in the completed instruction list, make no decision;
	if the current interlocutor is the example-talker:
		say "[italic type]To quit a boring conversation, type [t]BYE[x][italic type].[roman type]" (A);
		now the expected command is "bye" (B);
		now the held rule is the teach goodbye rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach compass directions rule):
	if the teach compass directions rule is listed in the completed instruction list, make no decision;
	let N be "[example-direction]";
	say "[italic type]To move from a location to the other, you can type the compass directions (NORTH, SOUTH, EAST, WEST, and also NORTHEAST, NORTHWEST, etc.).[line break]For example, type [d][N in upper case][x][italic type].[roman type]" (A);
	now the expected command is substituted form of "[N]" (B);
	now the held rule is the teach compass directions rule;
	rule succeeds.

A last instructional rule (this is the teach meta-features rule):
	if the teach meta-features rule is listed in the completed instruction list, make no decision;
	say "[italic type]This tutorial covers some commands that you need to know, but there are a lot of other verbs that you can use while the game proceeds and you sould be able to guess which are important from the context. Don't worry about experimenting new actions.[paragraph break]As you may have already noticed, you can also use the hyperlinks that appear below the command line: they give a quick access to the most common actions.[paragraph break]To quit the game, type [t]QUIT[x][italic type]; to save the current state of the game, type [t]SAVE[x][italic type]. To load a saved game, type [t]RESTORE[x][italic type], while [t]RESTART[x][italic type] restarts the game from the beginning.[roman type]" (A);
	add the teach meta-features rule to the completed instruction list;
	rule succeeds. 

Table of Instruction Followups
selector	followup
teach looking rule	"Excellent! LOOK (or simply L) prints a description of the environment like this one:"
teach examining rule	"Very well. Since you are going to examine objects frequently, you can also use X, the short form of the command.[line break]As you can see, some words are emphasized with particular styles and transformed in hyperlinks, just like [the example-thing][italic type]. This means that you can examine that object typing its name, even omitting the X.[line break]After examining an object, a few suggestions of possible actions applicable to that object may appear as hyperlinks, just after its description.[line break]Here is the description of the object:"
teach inventory rule	"That[']s right! You can also use the short form INV, or even I. As you can see, the command prints a description of what is in your possession:"
teach dropping rule	"The action of dropping an object moves it in the environment, as in this case:"
teach taking rule	"Well done. Now you are going to receive a message saying that you have taken [the example-thing][italic type] with success:"
teach compass directions rule	"Good! Just like other common commands, the compass directions have a short form: N, S, E, W, NE, NW, and so on. Also UP and DOWN (U and D) are possible in some situations.[line break]Read carefully the description of the environment to discover the available directions. There are also words emphasized in [d]this way[x][italic type] that represent doors or locations towards which you can move: to do that you can type the corresponding word.[paragraph break]As you enter the room, you get its description, like this one:"
teach wearing rule	"Good! The action of wearing an object moves it on the character[']s body, as in this case:"
teach taking off rule	"That[']s right! The action of taking off an object moves it from the character's body to the hands, as in this case:"
teach hailing rule	"Perfect! The action of hailing a character begins a conversation, as in this case:"
teach asking about rule	"Very well. As you may guess, it[']s enough to type [t][example-argument][x][italic type] because it[']s a word emphasized with the style of the topics. Asking or telling about specific topics can drive the conversation at will, as in this case:"
teach goodbye rule	"Perfect! Saying goodbye quits the conversation, as in this case:"
teach extracting rule	"That[']s right! The action of taking an object that is into a container moves it from the container to the hands of the player's character, as in this case:"
teach inserting into rule	"Good job! The action of putting an object into a container moves it from the hands of the player's character into the container, as in this case:"

Tutorial Mode Hyperlinks ends here.

---- Documentation ----

Read the original documentation of Tutorial Mode by Emily Short.