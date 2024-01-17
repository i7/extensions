Version 1.0.240116 of Beta Testing Support by Nathanael Nerode begins here.

"Provides an intro and instructions for beta testers."

Section - Inclusions (not for release)

[Remove this once they're integrated into Core Inform.]
Include Basic Screen Effects by Emily Short.

Section - Beta Testing Commands (not for release)

[Reference Writing With Inform section 17.21]
Understand "* [text]" as a mistake ("[italic type]Noted in transcript.[roman type]").

Section - Check Transcript Status (not for release)

to decide whether transcripting: (- ( VM_TranscriptIsOn() ) -).

Section - Beta Testing Intro (not for release)

The author's email is a text that varies.
The author's email is usually "".

[Reference Writing With Inform section 24.7]

to say intro for beta testers:
	say italic type;
	say "Welcome beta testers!";
	say "First of all, thank you for testing this game.";
	say "After you press a key, the game will start recording a transcript. Please pick a place to save the transcript.";
	say "[bracket]Press any key to continue[close bracket]";
	wait for any key;
	try switching the story transcript on;
	if not transcripting:
		say "[italic type]To switch the transcript on later, please type:[line break]";
		say "[bold type][fixed letter spacing]SCRIPT ON[variable letter spacing][line break]";
	say "[italic type]To add a comment to the transcript, type:[line break]";
	say "[bold type][fixed letter spacing]* This is a comment[variable letter spacing][line break]";
	say "[italic type]To switch the transcript off, type:[line break]";
	say "[bold type][fixed letter spacing]SCRIPT OFF[variable letter spacing][line break]";
	if the substituted form of "[author's email]" is not "":
		say "[italic type]When you're done with a playthrough, please send the transcript to the author at:[line break]";
		say "[roman type][fixed letter spacing][author's email][variable letter spacing][line break]";
	say "[italic type][bracket]Press any key to start the game[close bracket]";
	say roman type;
	wait for any key;
	clear the screen;
	do nothing.

Section - Activate Beta Testing Intro (not for release)

The intro for beta testers rule is listed before the when play begins stage rule in the startup rulebook.

This is the intro for beta testers rule:
		say intro for beta testers

Beta Testing Support ends here.

---- DOCUMENTATION ----

This provides an introductory section of text which turns on the transcript (or tells beta testers to do so);
tells beta testers how to add comments using the standard "* comment" protocol suggested in Writing With Inform
(and implements this), and (if an email address is provided) tells beta testers to send the transcript to the author by email.

Set your email with:

	The author's email is "example@example.com"

It should work out of the box for most games. It runs before "when play begins".

Changelog:
	1.0.240116: First version.
