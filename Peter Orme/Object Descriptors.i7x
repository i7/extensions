Version 1 of Object Descriptors by Peter Orme begins here.

Section 1 - Text list wrappers

[This is a little helper object that contains a list of text. Sometimes you need to use an object and not a list.]

A text list wrapper is a kind of object. 
Every text list wrapper has a list of text called the contents. 

Section 2 - the Object Descriptor Rule Book 

[Because a rulebook can not produce a list of text, we need this global dummy object to wrap a list of text in. 
The rulebook formally produces a text list wrapper, but it will always produce the same one. The interesting 
thing is what is in the "contents" - the actual list of text - of this object after we've followed the rules for some object.]

The object descriptor text list wrapper is a text list wrapper.

The object descriptor rules are an object-based rulebook producing a text list wrapper.
The object descriptor rulebook has a list of text called descriptors.

the last object descriptor rule (this is the wrap properties up rule):
	truncate the contents of the object descriptor text list wrapper to 0 entries;
	add descriptors to the contents of the object descriptor text list wrapper;
	rule succeeds with result the object descriptor text list wrapper.	

Section 3 - Basic Object Descriptor Rules

an object descriptor rule for a person (called item) (this is the descriptors of gender rule):
	if the item is male, add "male" to the descriptors;
	if the item is female, add "female" to the descriptors;
	if the item is neuter, add "neuter" to the descriptors;

an object descriptor rule for a thing (called item) (this is the descriptors of things rule):
	if the item is fixed in place, add "fixed in place" to the descriptors;
	if the item is portable, add "portable" to the descriptors;
	if the item is edible, add "edible" to the descriptors;
	if the item is inedible, add "inedible" to the descriptors;
	if the item is lit, add "lit" to the descriptors;
	if the item is unlit, add "unlit" to the descriptors;
	if the item is scenery, add "scenery" to the descriptors;
	if the item is wearable, add "wearable" to the descriptors;
	if the item is pushable between rooms, add "pushable between rooms" to the descriptors;

an object descriptor rule for an object (called item) (this is the descriptors of naming rule):
	if the item is singular-named, add "singular-named" to the descriptors;
	if the item is ambiguously plural, add "ambiguously plural" to the descriptors;
	if the item is plural-named, add "plural-named" to the descriptors;
	if the item is proper-named, add "proper-named" to the descriptors;
	if the item is improper-named, add "improper-named" to the descriptors;
	
an object descriptor rule for a container (called item) (this is the descriptors of containers rule):
	if the item is open, add "open" to the descriptors;
	if the item is closed, add "closed" to the descriptors;
	if the item is openable, add "openable" to the descriptors;
	if the item is unopenable, add "unopenable" to the descriptors;
	if the item is locked, add "locked" to the descriptors;
	if the item is unlocked, add "unlocked" to the descriptors;

an object descriptor rule for a container (called item) (this is the descriptors of enterables rule):
	if the item is enterable, add "enterable" to the descriptors;
	if the item is not enterable, add "not enterable" to the descriptors;

an object descriptor rule for a door (called item) (this is the descriptors of doors rule):
	if the item is open, add "open" to the descriptors;
	if the item is closed, add "closed" to the descriptors;
	if the item is openable, add "openable" to the descriptors;
	if the item is unopenable, add "unopenable" to the descriptors;
	if the item is locked, add "locked" to the descriptors;
	if the item is unlocked, add "unlocked" to the descriptors;

an object descriptor rule for a device (called item) (this is the descriptors of devices rule):
	if the item is switched on, add "switched on" to the descriptors;
	if the item is switched off, add "switched off" to the descriptors;

Section 4 - Deciding on Object Descriptors of an Object
	
to decide what list of text is the object descriptors of (item - an object):
	let wrapper be the text list wrapper produced by the object descriptor rules for the item;
	decide on the contents of the wrapper.
	
section 5 - Dev inspecting - Not for Release

dev inspecting is an action out of world applying to one visible thing.

understand "_dev inspect [any thing]" as dev inspecting.

carry out dev inspecting something (called the item):
	say "[the item] - [the object descriptors of the item]";

Object Descriptors ends here.


---- DOCUMENTATION ----

Object Descriptors adds the ability to list properties of objects, a bit like the "showme" command does. 

We can add rules to customize which properties are listed when we're inspecting a specific object kind. 

The extension comes with rules already set up for many of the built-in kinds such as containers and people, but it is easy to add additional rules for other kinds.


Example: * The Den - just describing some things 

This example just sets up some random objects, and there's a "when play begins" rule that iterates over all the things and list the properties. This is just to give you and idea of how this works. 
It also illustrates how to add a new rule for a specific kind. 

*: "The Den"

	Include Object Descriptors by Peter Orme.

	The Den is a room.

	The wooden chest is a container in the den. It is closed, openable.

	Mrs Benson is a woman in the den.

	the marble bench is a supporter in the den. It is fixed in place. 

	the portal is a door. It is outside from the den.

	the rat king is an animal in the den. The indefinite article is "a". it is plural-named.

	[Let's also introduce a new Kind of Thing. Custom properties won't break anything, but they won't be described unless we add an object descriptor rule for it]

	a wooz is a kind of thing. a wooz can be floppy or stiff. 

	an object descriptor rule for a wooz (called item):
		if the item is floppy, add "floppy" to the descriptors;
		if the item is stiff, add "stiff" to the descriptors;

	There is a floppy edible wooz called a spongy cake in the lab.

	when play begins:
		repeat with item running through things:
			say "[item] - [the object descriptors of the item].";


