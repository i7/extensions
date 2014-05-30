Version 2 of Reversed Persuasion Correction by Juhana Leinonen begins here.

"Automatically corrects commands given to NPCs where the order is reversed, for example HELLO, ALICE instead of ALICE, HELLO."

Use silent persuasion correction translates as (- Constant SILENT_REVERSING; -). 
Definition: a person is commandable if it can be seen by the player.
The looping-failsafe is a truth state that varies. Looping-failsafe is false.

After reading a command (this is the correct reversed persuasion rule):
	[chained commands are too complex to handle, so we'll skip the rule altogether if they turn up.]
	if the player's command matches the regular expression "\..+":
		continue the action;
	[If the player types in an ambiguous name (for example there are two Bobs in the room and the player commands BOB, HELLO), the parser jumps to asking the disambiguation question right in the middle of this rule. When the player answers, this rule fires again, so we'll have to handle that.]
	if the player's command includes "xxzzyyzzxx":
		continue the action;
	let T be indexed text;
	let T be the player's command;
	let original command be indexed text;
	let original command be the player's command;
	if the original command matches the regular expression ",":
		replace the regular expression "\s*,\s*" in T with " xxzzyyzzxx ";
		change the text of the player's command to T;
		now looping-failsafe is true;
		if the player's command includes "[a commandable person] xxzzyyzzxx": [the command was correct]
			if looping-failsafe is false:
				continue the action; [if we have already parsed the command successfully we don't need to go on]
			change the text of the player's command to the original command;
		otherwise:
			if looping-failsafe is false:
				continue the action;
			let T be the player's command;
			replace the regular expression "(.*) xxzzyyzzxx (\P*)" in T with "\2 xxzzyyzzxx \1"; [the \P takes only non-punctuation characters so commands like "how's it going, bob?" won't confuse the system]
			change the text of the player's command to T; 
			now looping-failsafe is true;
			if the player's command includes "[a commandable person] xxzzyyzzxx": [retrying to see whether switching the order makes it better]
				if looping-failsafe is false:
					continue the action;
				replace the regular expression " xxzzyyzzxx" in T with ",";
				change the text of the player's command to T; 
				if the silent persuasion correction option is not active:
					let the correct-command be the original command;
					replace the regular expression "(.*), *(\P*)" in correct-command with "\2, \1";
					say "([the correct-command])[command clarification break]";
			otherwise:
				if looping-failsafe is false:
					continue the action;
				let T be the player's command;
				replace the regular expression "(.*) xxzzyyzzxx (.*)" in T with "\2, \1";
				change the text of the player's command to T;
	now looping-failsafe is false.


Reversed Persuasion Correction ends here.


---- DOCUMENTATION ----

Chapter: Functionality

In English it's grammatically acceptable to say either ALICE, GO WEST or GO WEST, ALICE. The latter might even sound more natural in some cases (HELLO, BOB) but Inform accepts only the former NPC, COMMAND syntax. This is unfortunate especially to people new to IF because commanding something like HELLO, BOB always gives the "you seem to want to talk to someone, but I can't see whom" response, which is misleading at best if Bob is standing right there.

This extension allows the player to give the NPC's name in any order, before or after the comma. Including this extension is all that's needed.

For the benefit of teaching players the usual IF conventions the extension notifies the player of the correction that was made. If the player types OPEN DOOR, CHARLES the game says (charles, open door). If you don't like this feature you can disable it by adding "Use silent persuasion correction." to your source code.


Chapter: Limitations

Multiple commands given at once are too complex to correct using this extension, so commands like "SIT, BOB. TAKE A CUP OF TEA, BOB" are unfortunately left uncorrected. On the bright side it's probable that a player who knows how to give multiple commands like this already knows the correct syntax for commanding NPCs.

If the player misspells the name of the NPC the game thinks the player has given two regular commands:

	>JUMP, BOBB

	You jump on the spot, fruitlessly.

	That's not a verb I recognise.

This is unfortunate but unavoidable without disabling the player's ability to give multiple commands at the same time separated by commas (e.g. GO NORTH, OPEN DOOR, IN.)


Chapter: Change log

Version 2 (2010-07-08)

- Updated the extension to work with deprecated features from I7 build 6E59 onwards

- Fixed a bug where NPC disambiguation would mess up the reversal (e.g. if there were two Alices in the room HI, ALICE would give the "you seem to want to talk to someone" reply regardless of the player's answer to the disambiguation question.)

- Added the ability to strip punctuation from the end of the command so that question marks won't confuse the parser (HOW GOES, BOB? is now parsed correctly.)

- Minor fix to the chained command detection so that commands that just end in a full stop aren't considered chained

- Added an example to facilitate testing with the future Inform builds


Version 1 (2009-11-14)

Initial release.


Example: * In the Army - A demonstration of the extension's functionality.

	*: "In the Army"

	Include Reversed Persuasion Correction by Juhana Leinonen.

	The Training camp is a room. Private Johnson, Private Smith, Private Stevens and Private Miller are men in the training camp.

	Persuasion rule for asking people to try doing something: persuasion succeeds.

	Instead of an actor jumping:
		say "[The person asked] jumps.";
		rule succeeds.

	Test me with "johnson, jump/jump, johnson/private, jump/stevens/jump, private/miller".
