Version 2/171001 of Nathanael's Cookbook by Nathanael Nerode begins here.

"This is just a collection of worked examples illustrating various features of Inform.  There isn't actually anything in the extension per se, but the examples in the documentation can be click-pasted in the Inform IDE for convenience."

Nathanael's Cookbook ends here.

---- DOCUMENTATION ----

This is just a collection of examples.

Example: * Examine Room -- putting the room in scope

If you're in a room called "Main Street", you probably want "look at main street" to work.  By default, it doesn't.

	*: "Examine Room"

	Main Street is a room.
	"This is the center of the city, where it all happens!"

	After deciding the scope of an object (called character) (this is the put room in scope rule):
		Place the location of the character in scope, but not its contents.

	test me with "examine street/examine main street".

Example: * Meeting Place -- using arbitrary binary relations

Use the full power of arbitrary binary relations, which are poorly documented in the Inform 7 manual.  Show how to specify an action applying to a thing in the room and a thing not in the room.

	*: "Meeting Place"

	Meeting Place is a room.

	A government is a kind of thing.

	US, UK, France, Germany, Russia, China, India, Pakistan are governments.

	Alpha, Beta, Gamma, Delta, Epsilon are people in Meeting Place.

	Trusting relates various people to various governments.
	The verb to trust means the trusting relation.

	Alpha trusts US.  Alpha trusts UK.
	Beta trusts US.  Beta trusts France.
	Gamma trusts China.  Gamma trusts France.

	Understand "ask [someone] about [any government]" as asking it opinion about.
	Asking it opinion about is an action applying to one thing and one visible thing.
	[Note the completely misleading and perverse use of "visible thing" to mean "thing not necessary touchable".]

	Report asking a person (called who) opinion about a government (called what):
		if who trusts what:
			say "[Who] [say] 'Great country, I'd love to live there.'";
		else:
			say "[Who] [say] 'Nice people there, but I wouldn't want to live under their government.'";
