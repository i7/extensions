Version 2 of Debug Files (for Glulx only) by Juhana Leinonen begins here.

"A development tool for saving debugging information to an external text file during beta testing."

The file of debug information is called "debug".

The prompt count is a number that varies. The PSIN is a number that varies. 

Use debug files translates as (- Constant USE_FILE_DEBUGGING; -).
	
When play begins (this is the initialize the Debug Files extension rule):
	if the debug files option is active:
		now PSIN is a random number from 10000 to 99999;
		now the command prompt is "[bracket][the advanced prompt count][close bracket] >";
		append "[paragraph break]---[paragraph break][banner text][paragraph break]" to the file of debug information.
	
After printing the banner text when the debug files option is active (this is the print PSIN after the banner rule):
	say "Play session identifier number: [PSIN][line break]" (A).

To say the advanced prompt count:
	increase the prompt count by 1;
	say prompt count.
	
To debug (txt - indexed text):
	if the debug files option is active:
		append "[bracket][prompt count][close bracket]: [txt][paragraph break]" to the file of debug information.

Debug Files ends here.

---- DOCUMENTATION ----

Chapter: Overview

The purpose of the Debug Files extension is to provide a way to record debugging information to a text file while beta testers play the game. This information can then help the author to locate problems found during the testing.

The usual convention is that the beta testers save a transcript of their playthroughs for the author to read. When using this extension the game creates another file, called "debug.glkdata" (the actual extension depends on the interpreter used). The author can have the game output information to this file at any point. The text is not displayed to the player so beta testers can play the game without debug information cluttering the view.

Z-machine can't save external files. Therefore this extension is Glulx-only.


Chapter: How to use it

To use this extension you have to declare "Use debug files" in addition to including the extension.

	* : Include Debug Files by Juhana Leinonen.
	Use debug files.

The purpose of the use option is that you can remove that line when you release the game, so that the final version will not save any debugging information. (I7 has a built-in system that could disable the extension in released games, but the use option is there because the author might not want to give debug builds to beta testers.)

There will be two changes in the game itself: firstly, a "play session identifier number" is displayed after the banner text. This random 5-digit number is shown in both the transcripts (if not, the testers should type VERSION after starting the transcript to have it shown) and debug files. The purpose is to facilitate matching debug files to the corresponding transcripts.

Secondly, there is an incrementing number printed before the prompt (the prompt counter). The number helps matching the debug information to the corresponding action in the transcript. Note that this number is not the same as turn count: the prompt counter advances every time the player issues a command, regardless of whether the action advances the turn count.

To save information to the file, use the command 'debug':

	After burning a match:
		say "The match burns quickly out.";
		remove the noun from play;
		debug "There are [number of matches in the matchbox] matches remaining."

The debug text is saved to the file with the prompt counter automatically added. Nothing is printed to the player. If you remove the "Use debug files" option, the debug commands do nothing.

The author might use this functionality to, for example, track a wandering NPC:

	Every turn:
		debug "Bob is now in [the location of Bob]."

The debug file would then read:

	<2>: Bob is now in the gym.
	<3>: Bob is now in women's dressing room.
	<4>: Bob is now in the police lockup.

(numbers would be in square brackets.) The numbers would correspond to the prompt counter shown in the transcript.


Chapter: About the saved file

The location where the debug file is saved will depend on the interpreter. This is probably the same directory where the game file is. The Inform 7 IDE saves the file to the same location where the project file is. 

If the interpreter can't save the debug file for some reason, the game will probably crash.

If the debug file already exists, new information will be appended to the old data.


Chapter: Version history

Version 2 (April 2014): Modified the extension for compatibility with the new release of Inform.


Example: * Bear Hunter - An example where some information of the game mechanics is saved to the debug file.

	* : Include Debug Files by Juhana Leinonen. 

	Use debug files.

	The glacier is a room. A bipolar bear is a male animal in the glacier. The bipolar bear can be manical or depressed. The description of the bear is "The bipolar bear looks [if manical]like he's full of life[otherwise]quite depressed[end if]."

	A person has a number called hit points. The hit points of a person is usually 10.

	Every turn when a random chance of 1 in 3 succeeds:
		if the bear is depressed:
			now the bear is manical;
			debug "The bear has a manic episode.";
		otherwise:
			now the bear is depressed;
			debug "The bear is now depressed."

	Instead of attacking the depressed bear:
		say "You strike the bear with all your strength.";
		decrease the hit points of the bear by a random number between 1 and 5;
		debug "Bear's hit points reduced to [hit points of the bear].";
		if the hit points of the bear is less than 1:
			say "[line break]The mighty bipolar bear falls and you get another victory.";
			end the game in victory;
		otherwise:
			say "[line break]'Go ahead. Life's not worth it anyways,' the bear says."

	Instead of attacking the manical bear:
		say "'Oh no you don't!' the bear roars and slams you with his mighty white paw. 'There's nothing that could stop me today!'";
		decrease the hit points of the player by a random number between 1 and 5;
		debug "Player's hit points reduced to [hit points of the player].";
		if the hit points of the player is less than 1:
			say "[line break]The Great Bipolar Bear of the North proves to be stronger than you.";
			end the game in death.

	Test me with "x bear/attack bear/g/g/g/g/g".

After a test run the debug file might look something like this (except with brackets around the prompt numbers):

	<3>: Bear's hit points reduced to 6.

	<4>: Bear's hit points reduced to 3.

	<5>: Bear's hit points reduced to 1.

	<5>: The bear has a manic episode.

	<6>: Player's hit points reduced to 6.

	<6>: The bear is now depressed.

	<7>: Bear's hit points reduced to -3.
