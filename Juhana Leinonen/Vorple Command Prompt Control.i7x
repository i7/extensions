Version 3/181103 of Vorple Command Prompt Control (for Glulx only) by Juhana Leinonen begins here.

"Manually triggering parser commands, changing the contents of the command prompt and manipulating the command history."

Include version 3 of Vorple by Juhana Leinonen.

Use authorial modesty.

Chapter 1 - Queueing parser commands

To queue a/the/-- parser command (cmd - text), without showing the command:
	let hide command be false;
	if without showing the command:
		now hide command is true;
	execute JavaScript command "vorple.prompt.queueCommand('[escaped cmd]'[if hide command is true],true[end if])".
	

Chapter 2 - Command history

To add a/the/-- command (cmd - text) to the/-- command history:
	execute JavaScript command "haven.prompt.history.add('[escaped cmd]')".
	
To remove the/-- last command from the/-- command history:
	execute JavaScript command "haven.prompt.history.remove()".
	
To change the/-- last command in the/-- command history to (cmd - text):
	remove the last command from the command history;
	add the command cmd to the command history.
	
To clear the command history:
	execute JavaScript command "haven.prompt.history.clear()".
	

Chapter 3 - Prefilling the command line

To prefill the/-- command line with (cmd - text):
	execute JavaScript command "vorple.prompt.setValue('[escaped cmd]')".
	

Chapter 4 - Changing the previous command

To change the/-- text of the player's previous command to (cmd - text):
	execute JavaScript command "$('.lineinput.last .prompt-input').text('[escaped cmd]')".


Chapter 5 - Hiding the prompt

To hide the prompt:
	execute JavaScript command "vorple.prompt.hide()".

To unhide the prompt:
	execute JavaScript command "vorple.prompt.unhide()".
	
Vorple Command Prompt Control ends here.


---- DOCUMENTATION ----

Chapter: Queueing parser commands

The phrase

	queue a parser command "test me";
	
adds a command to a queue that executes it as player input as soon as the prompt becomes available. For example, the following code runs the commands "about" and "inventory" when the play begins, just as if the player would have typed the commands:

	When play begins:
		queue a parser command "about";
		queue a parser command "inventory".
		
Specifying "without showing the command" hides the command from view, but not the result of the command. The following example runs the command "inventory" whenever the player examines the player character:
	
	After examining the player:
		queue a parser command "inventory", without showing the command.
		
The modifier causes the output to be something similar to:
	
	>x me
	As good-looking as ever.
	
	You are carrying nothing.
	
Hiding the command is purely a visual effect. It doesn't stop the turn counter from incrementing or block every turn rules from running, or in any other way differ from commands that the player types. The player can also bring up the hidden command from the command history by pressing the up key (see the next chapter).
	
The feature should be used sparingly: unless there's a specific reason to pass the commands through the parser this way, in vast majority of cases it's better to trigger actions using the standard "try" construct. In the previous example we should rather write "After examining the player: try taking inventory."

Why queue the commands instead of just passing them to the prompt immediately? Whenever any Inform code is executed, the game loop is processing a turn. Technically the input prompt is available only between turns, so we must wait for it to become available. The story can't start processing a new turn while it's still processing the previous one. 


Chapter: Manipulating the command history

The command history is the list of commands that the player has typed previously and can be browsed by pressing the up and down keys on the keyboard. The phrases to add, remove, change and clear the command history are these:
	
	add the command "version" to the command history;
	remove the last command from the command history;
	change the last command in the command history to "examine mailbox";
	clear the command history;

Additions, removals and changes always operate on the most recent command in the history. Trying to remove commands from the history when there's nothing to remove doesn't cause an error, the phrase just doesn't do anything. The "clear the command history" wipes out all of them at once.

This feature can be useful when combined with hidden parser commands described in the previous chapter:
	
	queue a parser command "act secretly", without showing the command;
	
	Before acting secretly when "[player's command]" is "act secretly":
		remove the last command from the command history.

...although this is somewhat cumbersome and, as said before, much easier with a standard "try acting secretly" unless there's a very good reason to pass the command through the parser.


Chapter: Prefilling the command line

We can insert some text into the command line:

	prefill the command line with "look";

At the end of the turn when it's the player's turn to type a command, the word "look" is already entered into the command line. The player can then either continue to type the rest of the command or delete the prefilled text and issue some other command.


Chapter: Changing the previous command

We can also visually change the text of the command the player just typed. The following example changes the abbreviation L to LOOK:

	After reading a command:
		if the player's command matches "L":
			change the text of the player's previous command to "LOOK".
			
This only changes the text on the screen, nothing else. The story file still receives the original command and the command history will show the original command as well, unless changed with the "change the last command in the command history" phrase.


Chapter: Hiding and showing the prompt

(Note: this feature is for advanced usage only and not useful unless there's custom JavaScript code involved, so the documentation gets somewhat technical.)

The phrases "hide the prompt" and "unhide the prompt" hide and show the command prompt. When the prompt is hidden, the player can't type any commands. This feature is useful for custom JavaScript actions that take some time to finish, e.g. retrieving data from a server, and we don't want the player to take any actions while something triggered by the previous action is still being processed.

Hiding the prompt is needed only for asynchronous operations that don't already block script execution in the browser. It's not necessary to hide the prompt for slow synchronous operations that just take some time to finish.

In most cases the JavaScript code itself will unhide the prompt when it's ready. The JavaScript command to show the prompt is "vorple.prompt.unhide()". The script can also hide the prompt with "vorple.prompt.hide()".

"Hide the prompt" only prevents user input. Passing commands to the prompt programmatically with "queue a parser command" still works even when the prompt is hidden.

As the name suggests, the "unhide" phrase only undoes what the "hide the prompt" phrase does. If the prompt is hidden for some other reason (e.g. the story is waiting for a keypress) it will not force the prompt to appear.


Example: * Let Me Show You - A walkthrough command that automatically runs commands

Many stories include a WALKTHROUGH command that either shows the list of commands that get you to the end or tells you where to find it. Here we're making a walkthrough command that actually enters the commands on the player's behalf.


	*: "Let Me Show You"
	
	Include Vorple Command Prompt Control by Juhana Leinonen.
	Release along with the "Vorple" interpreter.
	
	
	Chapter 1 - World Setup
		
	The Occult Store is a room. 
	
	The puzzle box is here. The puzzle box is a locked container. The description of the puzzle box is "An intricate, wooden box with all sorts of weird decorations, including a carving of the moon, a wooden rabbit's ear, and a jewel."
	
	A moon carving is part of the puzzle box. A rabbit's ear is part of the puzzle box. A jewel is part of the puzzle box. A secret is in the puzzle box.
	
	Correct steps taken is a number that varies. Correct steps taken is 0.
	
	Instead of pushing the moon carving for the first time:
		say "You hear a faint click.";
		increment the correct steps taken.
	
	Instead of pulling the rabbit's ear for the first time:
		say "The ear decoration moves a little.";
		increment the correct steps taken.
	
	Instead of turning the jewel for the first time:
		say "The jewel turns just a bit.";
		increment the correct steps taken.
		
	Every turn when the correct steps taken is 3:
		say "There's an audible rumble as the mechanism inside the puzzle box turns and finally unlocks the box.";
		now the puzzle box is unlocked;
		now the correct steps taken is 0.
	
	
	Chapter 2 - Walkthrough
		
	Requesting the walkthrough is an action out of world applying to nothing.
	Understand "walkthrough" and "walkthru" as requesting the walkthrough.
	
	Carry out requesting the walkthrough:
		if Vorple is supported:
			say "Ok, let's go...";
			if the player is not carrying the puzzle box:
				queue a parser command "take puzzle box";
			[note that at this point the "take puzzle box" command is still in the queue, so the command hasn't been taken place and we haven't taken the puzzle box yet.]
			queue a parser command "push moon";
			queue a parser command "pull ear";
			queue a parser command "turn jewel";
		otherwise:
			say "Try this: PUSH MOON / PULL EAR / TURN JEWEL".
			
	Test me with "walkthrough".


Example: ** Clarification Helper - Prefilling the command line with a partial command

This example shows brings the player's command back to the command prompt after the story has shown the "What do you want to..." clarification request. If the player types just "take", the story asks "What do you want to take?". The word "take" is added to the next prompt and the player can continue typing with the name of the thing that they wanted to take.

	
	*: "Clarification Helper"
		
	Include Vorple Command Prompt Control by Juhana Leinonen.
	Release along with the "Vorple" interpreter.
	
	After issuing the response text of a response (called R):
		if R is parser clarification internal rule response (D) or R is parser clarification internal rule response (E):
			prefill the command line with "[parser command so far] ".
			
	The playroom is a room. A wooden block and a toy horse are here.
	
	Test me with "x".


Example: *** The Manchurian Candidate - Retroactively replacing the player's commands

A common trick to force the player to type a specific command is to print a fake command prompt, wait for keypresses and print the predetermined command one character at a time, regardless of what keys the player actually presses.

Thanks to the full control we have over the command line and the output, we can take the effect one step further and switch the player's command to something else after the player has already typed it.

This example gives the effect the full treatment: the player's command is intercepted and replaced with a new one inside the game itself, in the scrollback, and in the command history. The fake commands are functionally identical to any commands the user would have typed themselves.


	*: "The Manchurian Candidate"
	
	Include Vorple Command Prompt Control by Juhana Leinonen.
	Release along with the "Vorple" interpreter.
	
	
	Chapter 1 - Forcing commands
	
	The list of forced commands is a list of text that varies. The list of forced commands is {"enter book depository", "up", "open window", "inventory", "put rifle on sill", "shoot"}.
	
	After reading a command when the list of forced commands is not empty:
		let the new command be entry 1 in the list of forced commands;
		change the text of the player's command to the new command;
		change the text of the player's previous command to the new command;
		change the last command in the command history to the new command;
		remove entry 1 from the list of forced commands.
	
		
	Chapter 2 - World Setup
	
	Elm Street is a room. The book depository is scenery in Elm Street.
	
	The Book Depository Foyer is a room.
	The Sixth Floor is up from the Book Depository Foyer.
	The window is in the Sixth Floor. The window can be openable. The window can be open or closed. It is openable and closed. A sill is part of the window. The sill is a supporter.
	
	The player is carrying a rifle.
	
	Instead of entering the book depository:
		say "Something compels you to go inside the book depository.";
		now the player is in the Book Depository Foyer.
		
	Before going up from the Book Depository Foyer:
		say "You can't help but move up the stairs."
		
	After opening the window:
		say "The presidential motorcade is just approaching in the distance."
		
	Instead of taking inventory:
		say "You are carrying a rifle. You can't remember where you got it."
		
	After putting the rifle on the sill:
		say "You place the rifle on the window sill."
	
	Shooting is an action applying to nothing. Understand "shoot" as shooting.		
	Carry out shooting:
		say "Without hesitation you take aim and squeeze the trigger...";
		end the story.
