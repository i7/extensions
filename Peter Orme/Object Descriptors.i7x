Version 3 of Object Descriptors by Peter Orme begins here.

Section 1 - the Object Descriptor Rule Book 

The Object Descriptor Rulebook is an object-based rulebook.

[There is a bug with rules that decide on lists of values, so for now we use a global list to get around it.]
the descriptor list is a list of text that varies; 

Section 2 - Basic Object Descriptor Rules

the first Object Descriptor rule (this is the clear descriptor outcome rule): 
	truncate the descriptor list to 0 entries; 

an Object Descriptor rule for a person (called item) (this is the Descriptors of gender rule):
	if the item is male, add "male" to the descriptor list;
	if the item is female, add "female" to the descriptor list;
	if the item is neuter, add "neuter" to the descriptor list;

an Object Descriptor rule for a thing (called item) (this is the Descriptors of Things rule):
	if the item is fixed in place, add "fixed in place" to the descriptor list;
	if the item is portable, add "portable" to the descriptor list;
	if the item is edible, add "edible" to the descriptor list;
	if the item is inedible, add "inedible" to the descriptor list;
	if the item is lit, add "lit" to the descriptor list;
	if the item is unlit, add "unlit" to the descriptor list;
	if the item is scenery, add "scenery" to the descriptor list;
	if the item is wearable, add "wearable" to the descriptor list;
	if the item is pushable between rooms, add "pushable between rooms" to the descriptor list;

an Object Descriptor rule for an object (called item) (this is the Descriptors of Naming rule):
	if the item is singular-named, add "singular-named" to the descriptor list;
	if the item is ambiguously plural, add "ambiguously plural" to the descriptor list;
	if the item is plural-named, add "plural-named" to the descriptor list;
	if the item is proper-named, add "proper-named" to the descriptor list;
	if the item is improper-named, add "improper-named" to the descriptor list;
	
an Object Descriptor rule for a container (called item) (this is the Descriptors of Containers rule):
	if the item is open, add "open" to the descriptor list;
	if the item is closed, add "closed" to the descriptor list;
	if the item is openable, add "openable" to the descriptor list;
	if the item is unopenable, add "unopenable" to the descriptor list;
	if the item is locked, add "locked" to the descriptor list;
	if the item is unlocked, add "unlocked" to the descriptor list;

an Object Descriptor rule for a container (called item) (this is the Descriptors of Enterables rule):
	if the item is enterable, add "enterable" to the descriptor list;
	if the item is not enterable, add "not enterable" to the descriptor list;

an Object Descriptor rule for a door (called item) (this is the Descriptors of Doors rule):
	if the item is open, add "open" to the descriptor list;
	if the item is closed, add "closed" to the descriptor list;
	if the item is openable, add "openable" to the descriptor list;
	if the item is unopenable, add "unopenable" to the descriptor list;
	if the item is locked, add "locked" to the descriptor list;
	if the item is unlocked, add "unlocked" to the descriptor list;

an Object Descriptor rule for a device (called item) (this is the Descriptors of Devices rule):
	if the item is switched on, add "switched on" to the descriptor list;
	if the item is switched off, add "switched off" to the descriptor list;

Section 3 - Deciding on Object Descriptors of an Object
	
to decide what list of text is the object descriptors of (item - an object):
	follow the Object Descriptor Rulebook for the item;
	decide on the descriptor list.
	
section 4 - Dev inspecting - Not for Release

dev inspecting is an action out of world applying to one visible thing.

understand "dev inspect [any thing]" as dev inspecting.

carry out dev inspecting something (called the item):
	say "[the item] - [the object descriptors of the item]"

Object Descriptors ends here.


---- DOCUMENTATION ----

Object Descriptors adds the ability to list properties of objects, a bit like the "showme" command does, but this makes it available from 
other code (for example, for inclusion in debug logs).  

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

	The laser slicer is a switched off, unlit device in the den.

	after switching on the laser slicer: 
		now the laser slicer is lit;
		continue the action.

	after switching off the laser slicer: 
		now the laser slicer is unlit;
		continue the action.

	[Let's also introduce a new Kind of Thing. Custom properties won't break anything, but they won't be described unless we add an object descriptor rule for it]

	a wooz is a kind of thing. a wooz can be floppy or stiff. 

	an Object Descriptor rule for a wooz (called item):
		if the item is floppy, add "floppy" to the descriptor list;
		if the item is stiff, add "stiff" to the descriptor list;

	There is a floppy edible wooz called a spongy cake in the lab.

	when play begins:
		repeat with item running through things:
			say "[item] - [the object descriptors of the item].";


