aHidden Prompt by Daniel Stelzer begins here.

"Provides a simple way to hide the command prompt during long stretches of text."

"inspired by Command Prompt On Cue by Ron Newcomb"

Include Basic Screen Effects by Emily Short.
Include Command Preloading by Daniel Stelzer.

Section A

Hidden prompt is initially false.
The implicit hidden-prompt command is initially "wait".
The former prompt is initially "".

To say (X - number) as a key: (- print (char) {X}; -).

The hidden-prompt signal is initially "[close bracket] ".

Rule for reading a command when hidden prompt is true (this is the hidden prompt command rule):
	say "[italic type][implicit hidden-prompt command][roman type][line break]";
	change the text of the player's command to the implicit hidden-prompt command.

Section B1 (for use with Command Modification by Daniel Stelzer)

To hide the command prompt:
	if the command override queue is not empty, stop;
	if hidden prompt is true, stop;
	now the former prompt is the command prompt;
	now the command prompt is the hidden-prompt signal;
	now hidden prompt is true.
To hide the command prompt with implicit command (T - text):
	if the command override queue is not empty, stop;
	if hidden prompt is true, stop;
	now the implicit hidden-prompt command is T;
	hide the command prompt.
To show the command prompt:
	if the command override queue is not empty, stop;
	if hidden prompt is false, stop;
	now the command prompt is the former prompt;
	now hidden prompt is false.

Section B2 (for use without Command Modification by Daniel Stelzer)

To hide the command prompt:
	if hidden prompt is true, stop;
	now the former prompt is the command prompt;
	now the command prompt is the hidden-prompt signal;
	now hidden prompt is true.
To hide the command prompt with implicit command (T - text):
	if hidden prompt is true, stop;
	now the implicit hidden-prompt command is T;
	hide the command prompt.
To show the command prompt:
	if hidden prompt is false, stop;
	now the command prompt is the former prompt;
	now hidden prompt is false.

Section C1 (for use with Command Preloading by Daniel Stelzer)

Before reading a command when hidden prompt is true (this is the hidden prompt interruption rule):
	say "[hidden-prompt signal][run paragraph on]";
	let X be the chosen letter;
	unless X is 13 or X is 31 or X is 32 or X is -6 or X is 127:
		preload the command "[X as a key]";
		now the command prompt is the former prompt;
		now hidden prompt is false.

Section C2 (for use without Command Preloading by Daniel Stelzer)

The saved first letter is initially "".

Before reading a command when hidden prompt is true (this is the hidden prompt interruption rule):
	say "[hidden-prompt signal][run paragraph on]";
	let X be the chosen letter;
	unless X is 13 or X is 31 or X is 32 or X is -6 or X is 127:
		now the saved first letter is "[X as a key]";
		now the command prompt is "[former prompt][saved first letter]";
		now hidden prompt is false.

Rule for printing a parser error when the latest parser error is I beg your pardon error and the saved first letter is not empty (this is the hidden prompt single-letter command failure rule):
	now the command prompt is the former prompt;
	now the saved first letter is "".

First after reading a command when hidden prompt is false and the saved first letter is not empty (this is the hidden prompt correct first keystroke rule):
	now the command prompt is the former prompt;
	change the text of the player's command to "[saved first letter][player's command]";
	[say "(changed to [player's command])[command clarification break]";]
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
