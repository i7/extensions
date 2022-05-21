Version 1 of MilleUna for Quixe by Leonardo Boselli begins here.

"Release for web with the Quixe interpreter."


FOR-WEB is a truth state that varies. FOR-WEB is true.

Chapter - Multimedia

Section - Images

The default figure format ext is an indexed text that varies. The default figure format ext is "png".

To decide which text is the name of (FIG - a figure name):
	let FILENAME be the substituted form of "[FIG]";
	if FILENAME matches the regular expression "^Figure of (.+)":
		now FILENAME is "[text matching subexpression 1].[default figure format ext]";
	decide on FILENAME;

To say show (FIG - a figure name):
	show FIG.
To show (FIG - a figure name):
	let OUT be the name of FIG;
	now OUT is the substituted form of "<img src='Figures/[OUT]' align='left' />";
	say "[OUT][run paragraph on]";

Section - Sounds

To decide which text is the name of (SND - a sound name):
	let FILENAME be the substituted form of "[SND]";
	if FILENAME matches the regular expression "^Sound of (.+)":
		decide on text matching subexpression 1;
	decide on FILENAME;

To say play-back (SND - a sound name):
	play-back SND.
To play-back (SND - a sound name):
	let OUT be the name of SND;
	say "{playsound('[OUT]');}";;
	say "[run paragraph on]".
	
To say play-fore (SND - a sound name):
	play-fore SND.
To play-fore (SND - a sound name):
	say play-back SND;


MilleUna for Quixe ends here.

---- Documentation ----

No documentation yet.
