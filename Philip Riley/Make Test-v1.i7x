Version 1.0.0 of Make Test by Philip Riley begins here.

"Allows automatic creation of 'test' phrases"

Recording test is a truth state that varies.

Recorded test is a text that varies.

Recording name is a text that varies.

Start recording is an action applying to one topic. Understand "record [text]" as start recording.

Check start recording:
	if recording test is true:
		say "Already recording a test." instead;
		
Stop recording is an action applying to nothing. Understand "record off" as stop recording.

Check stop recording:
	if recording test is false:
		say "Not recording a test." instead;
		
Carry out start recording:
	now recording name is the topic understood;
	now recording test is true;
	
Report start recording:
	say "Recording.";
		
Carry out stop recording:
	now recording test is false;
	say "test text:[line break]";
	say "[bold type]test [recording name] with '[recorded test]'.[roman type][line break]";
	
Report stop recording:
	say "Recording stopped.";
	
This is the record command rule:
	if recording test is true:
		let act be the action name part of the current action;
		if act is not start recording action and act is not stop recording action:
			if recorded test is "":
				now recorded test is the player's command;
			otherwise:
				now recorded test is the substituted form of "[recorded test]/[the player's command]";
				
The record command rule is listed after the parse command rule in the turn sequence rules.
			


Make Test ends here.


---- Documentation ----

This extension adds the command "record", which commences recording the user's successful commands until the user issues the command 
	record off

at which point the extension will emit the previously recorded commands in the form:

	test mytest with "w/w/s/open desk/e".

The record command expects the name of the test, like so: 

	record mytest


