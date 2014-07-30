Hidden Prompt by Daniel Stelzer begins here.

"Provides a simple way to hide the command prompt during long stretches of text."

"inspired by Command Prompt On Cue by Ron Newcomb"

Include Basic Screen Effects by Emily Short.

Hidden prompt is initially false.
The implicit hidden-prompt command is initially "wait".

To say (X - number) as a key: (- print (char) {X}; -).

To hide the command prompt:
	now the former prompt is the command prompt;
	now the command prompt is "";
	now the saved first letter is "";
	now hidden prompt is true.
To hide the command prompt with implicit command (T - text):
	now the implicit hidden-prompt command is T;
	hide the command prompt.
To show the command prompt:
	now the saved first letter is "";
	now the command prompt is the former prompt;
	now hidden prompt is false.

The saved first letter is initially "".
The former prompt is initially "".

Before reading a command when hidden prompt is true (this is the hidden prompt interruption rule):
	let X be the chosen letter;
	unless X is 13 or X is 31 or X is 32 or X is -6 or X is 127:
		now the saved first letter is "[X as a key]";
		now the command prompt is "[former prompt][saved first letter]";
		now hidden prompt is false.
Rule for reading a command when hidden prompt is true (this is the hidden prompt command rule):
	change the text of the player's command to the implicit hidden-prompt command.
After reading a command when hidden prompt is false and the saved first letter is not empty (this is the hidden prompt correct first keystroke rule):
	now the command prompt is the former prompt;
	let T be the player's command;
	change the text of the player's command to "[saved first letter][T]";
[	say "(changed to [player's command])[command clarification break]";	]
	now the saved first letter is "".

Rule for printing a parser error when the latest parser error is I beg your pardon error and the saved first letter is not empty (this is the hidden prompt single-letter command failure rule):
	now the command prompt is the former prompt;
	now the saved first letter is "".

Hidden Prompt ends here.

---- DOCUMENTATION ----

This works similarly to Command Prompt On Cue by Ron Newcomb, but is (almost) pure I7 and thus unlikely to break with new updates. The most important phrases are these:
	hide the command prompt
This makes the command prompt invisible until the player attempts to type a command.
	hide the command prompt with implicit command (T - text)
This is the same as the above, but supplies T instead of "wait" if the player doesn't type anything.
	show the command prompt
If the player never interrupted, this ends the sequence.
