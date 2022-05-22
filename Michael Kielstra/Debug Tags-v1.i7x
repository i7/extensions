Version 1 of Debug Tags by Michael Kielstra begins here.

"Take quick notes about what needs doing: bugs, ideas, et cetera.  Helpful for debugging."

Use authorial modesty.

Book 0 - Basic setup
[Define debug tags and serious debug tags here, so that any that stay in the game by accident don't mess things up too badly.]

A debug tag is a kind of thing.  A debug tag is usually scenery.  A debug tag has a text called the type.  A debug tag has a number called the priority. A debug tag has a text called the assignee.

A serious debug tag is a kind of debug tag.

Book 1 - Rules and commands - Not for release

The type of a debug tag is usually "TODO".  The priority of a debug tag is usually 100.  Understand "debug tag" as a debug tag. 

The type of a serious debug tag is usually "STOPSHIP".  The priority of a serious debug tag is usually 10.

The urgency threshold is a number that varies.  The urgent tags message is a text that varies.

To display (the tag - a debug tag):
	say "[the type of the tag]: [the tag][if the location of the tag is not nowhere] (in [the location of the tag])[end if][if the assignee of the tag is not empty].  Assigned to [the assignee of the tag][end if]."

Carry out examining a debug tag (called the tag):
	display the tag instead.

Listing tags is an action applying to nothing.  Understand "tags" as listing tags.

Carry out listing tags:
	If the urgency threshold is 0:
		now the urgency threshold is 99;
	Let T be the list of debug tags;
	If T is not empty:
		sort T in priority order;
		if the priority of entry 1 of T is less than the urgency threshold:
			if the urgent tags message is empty:
				now the urgent tags message is "DO NOT RELEASE: SERIOUSLY INCOMPLETE";
			say "[the urgent tags message][paragraph break]";
		repeat with the tag running through T:
			display the tag;
	Otherwise:
		say "[paragraph break]".

When play begins:
	try listing tags.
		
Book 2 - Defining tags
[Once again, this goes out to release as well.]

TODO, XXX, HACK, NOTE, QUESTION, ALERT, CAVEAT, IDEA are kinds of debug tags.

STOPSHIP, FIXME, BUG are kinds of serious debug tags.

Book 3 - Destroying tags - Only for release
[Delete all tags in rooms at the beginning of released games.]

When play begins:
	repeat with the current tag running through debug tags:
		now the current tag is nowhere.

Debug Tags ends here.

---- DOCUMENTATION ----

Section: Using Debug Tags

Many programmers now use debug tags, also known as comment tags, to mark points in their code that need attention.  This extension adds a way of doing this in Inform that is scriptable, manageable, and, most importantly, doesn't mess up released code.

A debug tag is just an object like anything else.  We create one thusly:
	
	*:CANNOT OPEN DOOR is a debug tag.
	
However, we generally don't refer directly to debug tags.  Instead, we create different types, for ease of reference:
	
	*:CANNOT OPEN DOOR is a FIXME.
	IMPLEMENT DOOR OPENING MECHANISM is a TODO.
	
Both these tag types are defined by the extension.  A list of all such predefined tag types is given in a later section.

When the game starts, we will be given a list of all debug tags.  With default settings, the previous example would generate the following:
	
	DO NOT RELEASE: SERIOUSLY INCOMPLETE
	STOPSHIP: CANNOT OPEN DOOR.
	TODO: IMPLEMENT DOOR OPENING MECHANISM.
	
Note that the FIXME tag calls itself a STOPSHIP.  Tags have control over what they call themselves (called the type of the tag), and we try to keep the number of different reported types for tags down to a minimum for easy reading, even as more and more different actual types are defined.  (STOPSHIP and FIXME, for instance, are both valid kinds of tags with type "STOPSHIP".)

During the game, the command TAGS will reprint the list of debug tags for convenience.  Tags are automatically moved to nowhere at the beginning of released games, and the printout will not appear.

Section: Advanced Usage and Creating Debug Tags

Tags can be put in locations.  This will be reported at game start, and provides an Inform-friendly way of reminding yourself where the problem is.  Example B uses this.  Tags are scenery, so they shouldn't affect beta-testing much.

Each tag also has an assignee.  This is just a text field for the name of who should be fixing the bug or implementing the feature.  Example B demonstrates this.

Finally, each tag has a priority.  Smaller numbers mean more serious bugs.  Normal tags are at 100 by default; "serious" tags like STOPSHIP and FIXME are at 10.  By default, having any tags with priority of 99 or higher will cause a "DO NOT RELEASE" message to be displayed at the beginning of the game.  The urgent tags message, the priority of each tag, and the urgency threshold can all be overridden.  Example B demonstrates how, and the relevant lines are repeated here:

	*:An unimplemented object is a kind of debug tag.  The priority of an unimplemented object is usually 1.
	The urgent tags message is "Some F-35 systems not fully implemented."
	The urgency threshold is 5.
	
This will cause unimplemented objects, but not serious tags, to cause an urgent tags message to be shown.  If you don't want the message to ever be shown, set the urgency threshold to -1.  If you set it to 0, it will be reset to 99.

Tags are always printed sorted in priority order, lowest first.

Section: Defaults and Predefined Debug Tags

The default urgent message is "DO NOT RELEASE: SERIOUSLY INCOMPLETE".  The default urgent threshold is 99 -- tags with priority of 100 or lower will not cause the message to be printed.

Predefined serious tags ("STOPSHIP"):
	
	STOPSHIP
	FIXME
	BUG
	
Predefined standard tags ("TODO"):
	
	TODO
	XXX
	HACK
	NOTE
	QUESTION
	ALERT
	CAVEAT
	IDEA

Example: * The Lab - A basic example.

We'd like to implement a chemistry lab, so we go ahead and create a lab and a lab bench.  Immediately, we have some great ideas, but we don't know quite what to do with them so we write them down to come back to later.  A quick test reveals a serious bug, but we want to keep putting the lab together so we note it down to fix later.  We make it a STOPSHIP so it has a higher priority, meaning that it will be printed first when we next run the game.

	*: "The Lab"
	
	Include Debug Tags by Michael Kielstra.

	The Lab is a room.  The lab bench is in the Lab.  The chemical box is in the lab.  It is an openable open container.  The chemical phial is in the chemical box.

	IMPLEMENT CHEMICAL MIXING/ALCHEMY SYSTEM is a TODO.
	MAYBE ADD SOME PHENOLPHTHALEIN - I LOVE PHENOLPHTHALEIN is an IDEA.
	
	PLAYER CANNOT PUT PHIAL ON LAB BENCH is a STOPSHIP.
		
	Test me with "take phial / put chemical phial on lab bench".

	
Example: * The Jet - A more complex example with priorities, urgency overriding, an assignee, and custom messages.

We're implementing a fighter jet, but someone's linked the controls together strangely.  Plus, the missiles don't work.  The first of these problems is something we can fix right now, but the second's really more Iceman's responsability than ours, so we make a note.  The next time he runs our development copy of the game, he'll see we've assigned the guidance to him.

Difficult-to-understand controls for complex machines are almost a tradition of IF, so we don't worry particularly about our ignition/self-destruct problem.  It shouldn't go out to the public, so we make it a STOPSHIP, but the only bug we're properly worried about is the complete lack of missile implementation.  To give this a higher priority, we create a new type of tag in case this kind of thing comes up in the future, and give it a more serious (numerically lower) priority.  We make the urgency threshold more serious as well, so only our new kind of tag causes the urgent message.

Since we've now got a more concrete use for the urgent tags message, we give a more specific piece of text for it instead of the usual warning, and, just for quality-of-life and because we can, we tell the game to stop prefixing STOPSHIP tags with "STOPSHIP" and use "Doesn't work" instead.

	*: "The Jet"
	
	Include Debug Tags by Michael Kielstra.
	
	The F-35 is a room.  The ignition button is in the F-35.  The missile guidance control is in the F-35.  The self-destruct button is in the F-35.
	
	Instead of pushing the ignition button, try pushing the self-destruct button.
	
	Instead of pushing the self-destruct button, end the story saying "The jet blows up with you inside."
	
	An unimplemented object is a kind of debug tag.  The type of an unimplemented object is usually "UNIMPLEMENTED".  The priority of an unimplemented object is usually 1.
		
	PRESSING IGNITION ACTIVATES SELF-DESTRUCT is a STOPSHIP in the F-35.
	CANNOT USE MISSILE GUIDANCE is an unimplemented object in the F-35.  The assignee is "Iceman".

	The urgency threshold is 5.
	
	The urgent tags message is "Some F-35 systems not fully implemented."
	
	The type of a STOPSHIP is "Doesn't work"
	
	Test me with "push ignition".