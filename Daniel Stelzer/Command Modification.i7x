Version 1 of Command Modification by Daniel Stelzer begins here.

Include Typographical Conveniences by Daniel Stelzer.

Include (-
[ GetKeyReturn key; !Based on code from Basic Screen Effects, this gets a (safe) keypress and returns its value.
	while (true){
		key = VM_KeyChar();
		#Ifdef TARGET_ZCODE;
		if ( key == 63 or 129 or 130 or 131 or 132 )
		{
			continue;
		}
		#Ifnot; ! TARGET_GLULX
		if ( key == -2 or -3 or -4 or -5 or -10 or -11 or -12 or -13 )
		{
			continue;
		}
		#Endif; ! TARGET_
		return key;
	}
]; -).

To decide what number is the/-- next keypress:
	(- GetKeyReturn(); -).

To visually force the command (typed command - text): [This just does the typing thingy.]
	say "[command prompt][run paragraph on]";
	let the index be 1;
	let X be zero;
	while the index is at most the number of characters in the typed command:
		let X be the next keypress;
		if X is zero or X is -2 or X is -3 or X is -6 or X is -7 or X is 8, next; [Ignore nothing at all, DELETE, ENTER, etc.]
		say "[character number index in the typed command][r]";
		increment the index;
	while X is not -6: [Wait for ENTER to execute the command.]
		let X be the next keypress;
	say "[roman type][line break]".

The command override queue is a list of lists of text that varies.
An override mode is a kind of value. The override modes are replay mode, forced mode, and silent mode.
The command override mode is a list of override modes that varies.

Rule for reading a command when the command override queue is not empty (this is the command modification rule):
	while entry 1 in the command override queue is empty: [We've finished this set. Now on to the next one!]
		remove entry 1 from the command override queue; [We need the "while" instead of a simple "if" to deal with an edge case when the last command of one set adds another set, leaving an empty vestige behind in the queue.]
		remove entry 1 from the command override mode; [The loop means it'll be cleaned up before it causes any problems.]
		if the command override queue is empty, make no decision; [Drop back to normal reading-a-command rules when we have nothing more to do here.]
	let the new command be entry 1 in entry 1 in the command override queue; [Go one level deeper.]
	let the chosen mode be entry 1 in the command override mode;
	if the chosen mode is:
		-- replay mode:
			say "[command prompt][alert][new command][/alert][line break]" (A);
		-- forced mode:
			visually force the command (new command);
			do nothing;
		-- silent mode:
			do nothing;
	change the text of the player's command to the new command;
	remove entry 1 from entry 1 in the command override queue; [Pop this command off.]
	if entry 1 in the command override queue is empty: [Check this once at the end as well just in case.]
		remove entry 1 from the command override queue;
		remove entry 1 from the command override mode.

To push command-forcing for (commands - list of text) in (mode - override mode):
	add the commands at entry 1 in the command override queue;
	add the mode at entry 1 in the command override mode.

To push single command-forcing for (command - text) in (mode - override mode):
	let L be a list of texts;
	add the command to L;
	push command-forcing for L in the mode.

To force the command (typed command - text):
	push single command-forcing for the typed command in forced mode.

To force the command set (commands - list of text):
	push command-forcing for the commands in forced mode.

To replay the command (typed command - text):
	push single command-forcing for the typed command in replay mode.

To replay the command set (commands - list of text):
	push command-forcing for the commands in replay mode.

To silently execute the command (typed command - text):
	push single command-forcing for the typed command in silent mode.

To silently execute the command set (commands - list of text):
	push command-forcing for the commands in silent mode.

Command Modification ends here.

---- DOCUMENTATION ----

This extension allows the programmer to override what the player typed and parse different commands instead.

	force the command "jump"
	force the command set {"north", "east", "northeast"}

This "forces" the player to type the specified command, by overriding the keyboard input.

	replay the command "jump"
	replay the command set {"north", "east", "northeast"}

This prints and executes the specified command without waiting for player input, as if it were replayed from the Skein.

	silently execute the command "jump"
	silently execute the command set {"north", "east", "northeast"}

This is the same as "replay", but the command line is hidden entirely. Note that the results of the actions are still printed.
