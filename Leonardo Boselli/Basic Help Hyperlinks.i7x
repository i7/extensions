Version 3/140811 of Basic Help Hyperlinks by Leonardo Boselli begins here.

"Define a command HELP that lists standard instructions accessible through hyperlinks. Based on Basic Help Menu by Emily Short."

Chapter - Announce

After looking for the first time (this is the help first time looking rule):
	announce the help availability;
	continue the action.

To announce the help availability:
	say "[italic type](Type [t]HELP[x][italic type] if you don[']t know how to proceed.)[roman type][paragraph break]".

Chapter - Help Menus

Table of Basic Help Options
title	subtable (a table name)	description	toggle (a rule)
"Introduction to '[bold type][story title][fixed letter spacing]'"	--	"[line break][story description]"	--
"Instructions for play"	Table of Instruction Options	--	--

Table of Instruction Options
title	subtable	description	toggle
"About Interactive Fiction"	--	"[line break]The game you are playing is a work of Interactive Fiction.  In interactive fiction you play the main character of a story.  You type commands which determine the actions of the character and the flow of the plot.  Some IF games include graphics, but most do not: the imagery is provided courtesy of your imagination.  On the other hand, there's a wide range of action available: whereas in other games you may be restricted to shooting, movement, or searching items you can click on with a mouse, IF allows you a wide range of verbs."	--
"What to do with '[command prompt]'"	--	"[line break]The '[command prompt]' is where the game says, 'Okay, what do you want to do now?'  You may respond by typing an instruction -- usually an imperative verb, possibly followed by prepositions and objects.  So, for instance, LOOK, LOOK AT FISH, TAKE FISH."	--
"Getting Started"	--	"[line break]The first thing you want to do when starting a game is acquaint yourself with your surroundings and get a sense of your goal. To this end, you should read the introductory text carefully. Sometimes it contains clues. You will also want to look at the room you are in. Notice where the exits from the room are, and what objects are described here. If any of these seem interesting, you may want to EXAMINE them. [paragraph break]You might also want to examine yourself (EXAMINE ME) to see whether the author has left you any clues about your character. TAKE INVENTORY will tell you what you're carrying, as well.[paragraph break]Once you've gotten your bearings, you may want to explore. Move from room to room, and check out every location available."	--
"Rooms and Travel"	--	"[line break]At any given time, you are in a specific location, or room. When you go into a room, the game will print a description of what you can see there. This description will contain two vital kinds of information: things in the room you can interact with or take, and a list of exits, or ways out. If you want to see the description again, you may just type LOOK. [paragraph break]When you want to leave a location and go to another one, you may communicate this to the game using compass directions: eg, GO NORTH. For simplicity's sake, you are allowed to omit the word GO, and to abbreviate the compass directions. So you may use NORTH, SOUTH, EAST, WEST, NORTHEAST, SOUTHEAST, NORTHWEST, SOUTHWEST, UP, and DOWN, or in short form N, S, E, W, NE, SE, NW, SW, U, and D.[paragraph break]In some locations, IN and OUT will also be useful."	--
"Objects"	--	"[line break]Throughout the game there will be assorted objects that you can do things with. Most importantly, you may TAKE or GET items, and (when you are tired of them) DROP them again. INVENTORY (abbreviated I) will list the items you are currently holding. [paragraph break]There are usually assorted things you may do with these objects. OPEN, CLOSE, WEAR, EAT, LOCK, and UNLOCK are especially common.[paragraph break]Occasionally, you will find that the game does not recognize the name of an object even though it has been described as being in the room with you. If this is the case, the object is just there for scenery, and you may assume that you do not need to interact with it."	--
"Controlling the Game"	--	"[line break]There are a few simple commands for controlling the game itself. These are: [paragraph break]SAVE saves a snapshot of the game as it is now. [line break]RESTORE puts the game back to a previous saved state. You may keep as many saved games as you like. [line break]RESTART puts the game back to the way it was at the beginning. [line break]QUIT ends the game."	--
"How the World is Assembled"	Table of IF Elements	--	--
"If You Get Stuck"	Table of Stuckness Advice	--	--

Table of Stuckness Advice
title	subtable	description	toggle
"Explore"	--	"[line break]Examine every object and look at everything in your inventory. Open all the doors you can find, and go through them. Look inside all closed containers. Make sure you've exhausted all the options in your environment. [paragraph break]Try out all your senses. If the game mentions texture, odor, or sound, try touching, smelling, listening to, or tasting objects.[paragraph break]Be thorough. If you still can't figure out what to do, try opening windows, looking under beds, etc. Sometimes objects are well-hidden."
"Read carefully"	--	"[line break]Reread. Look back at things you've already looked at. Sometimes this will trigger an idea you hadn't thought of. [paragraph break]Take hints from the prose of the game. Things that are described in great detail are probably more important than things that are given one-liners. Play with those objects. If a machine is described as having component parts, look at the parts, and try manipulating them.  Likewise, notice the verbs that the game itself uses. Try using those yourself. Games often include special verbs -- the names of magic spells, or other special commands. There's no harm in attempting something if the game mentions it.[paragraph break]Check the whole screen. Are there extra windows besides the main window?  What's going on in those?  Check out the status bar, if there is one -- it may contain the name of the room you're in, your score, the time of day, your character's state of health, or some other important information.  If there's something up there, it's worth paying attention to that, too.  When and where does it change?  Why is it significant?  If the bar is describing your character's health, you can bet there is probably a point at which that will be important."
"Be creative"	--	"[line break]Rephrase. If there's something you want to do, but the game doesn't seem to understand you, try alternative wordings. [paragraph break]Try variations. Sometimes an action doesn't work, but does produce some kind of unusual result. These are often indications that you're on the right track, even if you haven't figured out quite the right approach yet. Pressing the red button alone may only cause a grinding noise from inside the wall, so perhaps pressing the blue and then the red will open the secret door.[paragraph break]Consider the genre of the game. Mysteries, romances, and thrillers all have their own types of action and motivation. What are you trying to do, and how do conventional characters go about doing that? What's the right sort of behavior for a detective/romance heroine/spy?"
"Cooperate"	--	"[line break]Play with someone else. Two heads are often better than one. If that doesn't work, try emailing the author or (better yet) posting a request for hints on the newsgroup rec.games.int-fiction.  For best results, put the name of the game you want help with in the subject line; then leave a page or so of blank spoiler space (so that no one will read about where you got to in the game unless they've already played it), and describe your problem as clearly as possible.  Someone will probably be able to tell you how to get around it."	--

Table of IF Elements
title	subtable	description	toggle
"Space"	--	"[line break]Most IF games are set in a world made up of rooms without internal division. Movement between rooms is possible; movement within a room does not always amount to anything. >WALK OVER TO THE DESK is rarely a useful sort of command. On the other hand, if something is described as being high or out of reach, it is sometimes relevant to stand on an object to increase your height. This kind of activity tends to be important only if prompted by the game text."	--
"Containment"	--	"[line break]One thing that IF does tend to model thoroughly is containment. Is something in or on something else? The game keeps track of this, and many puzzles have to do with where things are -- in the player's possession, lying on the floor of the room, on a table, in a box, etc."	--
"Types of Action"	--	"[line break]Most of the actions you can perform in the world of IF are brief and specific. >WALK WEST or >OPEN DOOR are likely to be provided. >TAKE A JOURNEY or >BUILD A TABLE are not. Things like >GO TO THE HOTEL are on the borderline: some games allow them, but most do not. In general, abstract, multi-stage behavior usually has to be broken down in order for the game to understand it."	--
"Other Characters"	--	"[line break]Other characters in IF games are sometimes rather limited. On the other hand, there are also games in which character interaction is the main point of the game. You should be able to get a feel early on for the characters -- if they seem to respond to a lot of questions, remember what they're told, move around on their own, etc., then they may be fairly important. If they have a lot of stock responses and don't seem to have been the game designer's main concern, then they are most likely present either as local color or to provide the solution to a specific puzzle or set of puzzles. Characters in very puzzle-oriented games often have to be bribed, threatened, or cajoled into doing something that the player cannot do -- giving up a piece of information or an object, reaching something high, allowing the player into a restricted area, and so on."	--

Understand "help" or "hint" or "hints" or "about" or "info" as asking for help.
Asking for help is an action out of world.
Carry out asking for help (this is the help request rule):
	now the current menu is the Table of Basic Help Options;
	try asking for help list;

Understand "< [number] >" as asking for particular help.
Asking for particular help is an action applying to a number.
Carry out asking for particular help (this is the particular help request rule):
	let N be the number understood;
	if N < 1 or N > number of rows in the current menu:
		say "[italic type]Unknown option.[roman type][line break]";
	otherwise:
		choose row N in the current menu;
		if there is a description entry:
			say "[line break][bold type][title entry][roman type]";
			say "[description entry][line break]";
			say "[line break][o]list of options[x]";
		otherwise if there is a subtable entry:
			now the current menu is subtable entry;
			try asking for help list;
		otherwise:
			say "[bold type]< [N] >[italic type] does not correspond to any action.[roman type][line break]";

Understand "list of options" as asking for help list.
Asking for help list is an action out of world.
The current menu is a table name that varies.
Carry out asking for help list (this is the help list request rule):
	repeat with N running from 1 to the number of rows in the current menu: 
		choose row N in the current menu; 
		say "[o]< [N] >[x] [title entry][line break]";
	if current menu is not Table of Basic Help Options:
		say "[o]help[x]";

Basic Help Hyperlinks ends here.

---- DOCUMENTATION ----

NOTE: This is a modification of the original extension Basic Help Menu by Emily Short to support hyperlinks and to avoid menus.
