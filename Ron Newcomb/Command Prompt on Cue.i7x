Version 3/140513 of Command Prompt on Cue by Ron Newcomb begins here.

"Creates a situation without a command prompt where the player may simply press space or enter to WAIT.  But if the player instead begins to type a command, the command prompt will then appear."

Book 1 - The Command Prompt on Cue extension

Chapter 1 - knobs and dials and readouts for the game's use

Command prompt on cue is a truth state that varies.  Command prompt on cue is usually false. 
The implicit unobtrusive command is some text that varies.  The implicit unobtrusive command is usually "wait".
Unobtrusive player is a truth state that varies.  

Chapter 2 - mere details - unindexed

Section 1 - main 

To decide if the player is pressing SPACE: (- Interrupt_test() -).

Unobtrusive player variable translates into I6 as "unobtrusive_player".
The saved optional command prompt is some text that varies.  The saved optional command prompt initially is "".
Interrupting key is a number that varies.  Interrupting key variable translates into I6 as "interrupting_key".  

Include (-
Global interrupting_key = 90;		! a capital Z, for the WAIT command.  Needed so "the player's command" isn't invalid on the first turn
Global unobtrusive_player;

[ Interrupt_test ch;
	while (1) {
		do {
			interrupting_key = VM_KeyChar();
		} until (interrupting_key < 253);
		!print "code ", interrupting_key, "^";
		if (interrupting_key == ' ' or 13 or 10 or -6 or 127)  {
			unobtrusive_player = true;  
			rtrue;
		} else if (interrupting_key >= ' ') {
			unobtrusive_player = false;  ! then player will take action
			print (TEXT_TY_Say) (+ saved optional command prompt +);
#IFDEF TARGET_GLULX;
			style bold;
#ENDIF;
			print (char) interrupting_key;
#IFDEF TARGET_GLULX;
			style roman;
#ENDIF;
			rfalse;
		}
	} 
];
-) after "Definitions.i6t".


Section 2 - fix a bug when command prompt on cue is on during the very first turn

When play begins (this is the initialize command prompt on cue rule): 
	prepend the interrupting key to the player's command.  

To prepend the interrupting key to the player's command: 
(-	
#IFDEF TARGET_GLULX;
	LTI_Insert(4, interrupting_key); 
#IFNOT;
	LTI_Insert(2, interrupting_key); 
#ENDIF;
	VM_Tokenise(buffer, parse);
	players_command = 100 + WordCount();
-).



Chapter 3 - the main rules

Last for reading a command when command prompt on cue is true (this is the Optional Command Prompt rule):
	now the saved optional command prompt is the command prompt; 
	now the command prompt is "";  [so it won't print before the 2nd letter]
	if not the player is pressing SPACE begin;
		continue the action; [ preventing normal parsing, as it isn't needed to WAIT ]
	end if.

First after reading a command when command prompt on cue is true  (this is the command prompt on cue restoration rule):
	now the command prompt is the saved optional command prompt; 
	if unobtrusive player is true, 	replace the player's command with the implicit unobtrusive command;
	otherwise prepend the interrupting key to the player's command.


Chapter 4 - handy for debugging - not for release

Rule for printing a parser error when the latest parser error is not a verb I recognise error and command prompt on cue is true (this is the command prompt on cue debugging rule):
	say "'[player's command]' is not something I recognise."


Chapter 5 - parser error rules

Before printing a parser error when the latest parser error is I beg your pardon error and command prompt on cue is true  (this is the gracefully fail single-letter commands rule):
	now the command prompt is the saved optional command prompt;
	now interrupting key is 32; [a space, so the player re-types their L, Z, or G, it will work the 2nd time ]

After printing a parser error when command prompt on cue is true (this is the command prompt on cue fixes whitespace issue rule): say "[line break][run paragraph on]".	


Command Prompt on Cue ends here.

---- DOCUMENTATION ----

Section : Purpose

When our player is in a multi-way conversation, or is witnessing a scene that they may or may not wish to intervene, when to allow the player to intervene becomes a design problem.  Too infrequently, and the player may feel railroaded for the sake of prose.  Too frequently, and the prose suffers from the choppy intrusion of the command prompts, many of which have only a WAIT command on them. 

This extension suppresses the command prompt in such scenes until the player begins to type a command.  If the player does not wish to enter a command, pressing SPACE will allow the prose to continue unhindered.  Clever use of the Say phrase "run paragraph on" can even allow several turns to go by within a single paragraph, allowing a command prompt at any time between sentences.  


Section : Knobs and Dials and Readouts

The truth state variable "command prompt on cue" is the master switch for the extension.  When true, the extension works as advertised.  When false, the extension turns itself off.  By default, it is off when play begins.  This is because it is assumed the extension's mode of play will be used only within the work's busier scenes.

	*: When the rapier duel begins: 
		say "'Then you'll die by my blade, upstart.'";
		now command prompt on cue is true.
	
	When the rapier duel ends:
		say "Then he turned and walked away, leaving you with your injured lover.";
		now command prompt on cue is false.


"The implicit unobtrusive command" is the command we wish to run when our player presses SPACE.  By default, it equals "WAIT", so pressing SPACE calls the game's waiting action.  We may change this whenever we wish, to whatever we wish.

	*: After entering the closet during an eavesdropping scene: 
		change the implicit unobtrusive command to "LISTEN".


"Unobtrusive player" is a readout.  When true, it means that this turn, our player has merely pressed SPACE -- he or she has decided not to intervene.  When false, it means our player had decided to join in and try a command.  This allows us to distinguish why the implicit action was called.



Section : Caveats

Due to technical reasons, the extension does not deal well with single-letter commands.  When our player tries to interrupt with a L (for LOOK) or i (for INVENTORY), a spurious "I beg your pardon" error will result.  The player may then proceed normally.  Secondly, the player cannot delete the first typed letter.  Finally, fast typists may lose the second letter -- understanding "ak" and "tll" may be called for.

Section : 6L02 Compatibility Update

This extension differs from the author's original version: it has been modified for compatibility with version 6L02 of Inform. The latest version of this extension can be found at <https://github.com/i7/extensions>. 

This extension is released under the Creative Commons Attribution licence. Bug reports, feature requests or questions should be made at <https://github.com/i7/extensions/issues>.

Example: * It Must Be the Argument Clinic - John and Marsha need some time away from each other.

As we use the SPACE bar a lot, a TEST ME script does not perform well.  When running the example, just press SPACE a few times until you get your bearings, then try some ASK ABOUT or TELL ABOUT commands.

	*: "It Must Be the Argument Clinic"

	Include Command Prompt on Cue by Ron Newcomb.
	
	The living room is a room. "It seems like John and Marsha are at it again.   Press the space bar or enter key to listen.  Or try to help matters and ASK her what's wrong or TELL him some good advice."  

	When play begins: 
		now command prompt on cue is true;
		now the command prompt is "You decide to ".
	
	Some headphones are a wearable thing in the living room. 
	Carry out wearing the headphones: now command prompt on cue is false.
	Last report wearing the headphones: say "Blessed silence."
	Carry out taking off the headphones: now command prompt on cue is true.
	
	John is a man in the living room.  Marsha is a woman in the living room. 
	
	Instead of waiting when the remainder after dividing the turn count by 2 is 0, say "'You never showed any love!' says John."
	
	Instead of waiting when the remainder after dividing the turn count by 2 is 1, say "'You were always out at the bar with the guys!' says Marsha."
	
	Instead of answering John that, say "'Oh don't you start in on me, too!' says John."
	
	Instead of answering Marsha that, say "'He never listens,' she says to you."
	
	Instead of asking John about, say "He shakes his head.  It seems [the topic understood] angers him."	
	
	Instead of asking Marsha about, say "'Oh John knows all about [italic type][topic understood][roman type].  Ask him anything, he knows it all!'".	
	
	Instead of telling John about, say "'Try telling her that!'"	
	
	Instead of telling Marsha about, say "'I know you're trying to help, but there's no help for him.'"	
	
	Understand "ask [someone] [text]" as asking it about.
	Understand "ak [someone] [text]" as asking it about.
	
	Understand "tell [someone] [text]" as telling it about.
	Understand "tll [someone] [text]" as telling it about.

