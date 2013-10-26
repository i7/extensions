Version 1/120223 of Universal Opening by Peter Orme begins here.

Chapter 1 - Universal opening commands - Not for release

Section - universal opening all doors and things

universal opening of doors is an action out of world applying to nothing.
understand "openalldoors" as universal opening of doors. 

carry out universal opening of doors (this is the universal opening of doors rule):
	repeat with chosen door running through every door:
		if the chosen door is closed:
			say "[The chosen door] - opening.";
			now the chosen door is open;
		otherwise:
			say "[The chosen door] - already open.";
	say "Now every door in the world should be open.";

		
universal opening of things is an action out of world applying to nothing. 
Understand "openallthings" as universal opening of things.

carry out universal opening of things (this is the universal opening of things rule):
	repeat with chosen item running through every openable thing which is not a door:
		if the chosen item is closed:
			say "[The chosen item] - opening.";
			now the chosen item is open;
		otherwise:
			say "[The chosen item] - already open.";
	say "Now everything (except doors) in the world should be open.";
	
universal opening everything is an action out of world applying to nothing. Understand "openall" as universal opening everything;

carry out universal opening everything (this is the universal opening of everything rule):
	try universal opening of things;
	try universal opening of doors;

section - universal opening of single things

universal-opening is an action out of world applying to one thing.

understand "openall [something]" as universal-opening.

carry out universal-opening something (called chosen item)(this is the universal opening something specific rule):
	if the chosen item is openable:
		if the chosen item is closed:
			now the chosen item is open;
			say "Opening [the chosen item].";
		otherwise:
			say "[The chosen item] is already open.";
	otherwise:
		say "[The chosen item] cannot be opened.";

Universal Opening ends here.

---- DOCUMENTATION ----

This extension provides you with testing commands for force opening things. The commands are all in sections marked as "not for release" - this is intended to be a tool during development and test, not for actual games. 

Section: Testing commands available to the player

The extension provides you with a "openall" command, available in several versions. 

First of all you can open one single thing.If you have a safe and you want it open, just go "openall safe". This works both on doors and containers - anything that is "openable". Note that it does not unlock things, but rather just opens them, ignoring any locked property. 

Second, you can open lots of things at once. "openalldoors", in one word, will open all doors. All of them at once, that is.

Third, you can do that to all things except doors. The command is "openallthings". 

Fourth, you can open everything - all doors, and all things. The command is "just openall". 

Example: * The secure piggy bank - A piggy bank that you can put things inside, even it it's closed and locked. Including the key! In the test, you put the key in the locked piggy bank and use "openall bank" to make it open.

	*: "The Secure Piggy Bank"

	Include Universal Opening by Peter Orme.

	Nursery is a room. 

	The piggy bank is a closed openable lockable container in the nursery. It is locked.

	The pink key unlocks the piggy bank. The player is carrying the pink key.

	instead of inserting something into the piggy bank:
		say "You slip [the noun] through the slot on the piggy's back.";
		now the noun is in the piggy bank.
	
	test me with "put key in bank / take key / open bank / openall bank / take key / close bank / open bank";





