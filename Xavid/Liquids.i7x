Version 1/190523 of Liquids by Xavid begins here.

"Basic support for sources of liquids and things that can hold a liquid, more minimalist than Liquid Handling by Al Golden."

Chapter 1 - Basic Implementation

Section 1 - Kinds

A thing can be water-tight.

A vessel is a kind of thing. Vessels are always water-tight.

A liquid is a kind of value.
There is a liquid called emptiness.

Section 2 - Properties

A thing has a liquid called the contained liquid.
Definition: a thing (called T) is empty rather than nonempty if the contained liquid of T is emptiness.

A thing has a liquid called the available liquid.
Definition: a thing is liquid-yielding if the available liquid of it is not emptiness.

Section 3 - Relations

Full of relates a thing (called T) to a liquid (called L) when the contained liquid of T is L.
The verb to be full of means the full of relation.
The verb to fill means the reversed full of relation.

Source of relates a thing (called T) to a liquid (called L) when the available liquid of T is L.
The verb to yield means the source of relation.
The verb to be available at means the reversed source of relation.

Section  4 - Understanding Liquids

Understand the contained liquid property as describing a thing when the item described is nonempty.

Understand "empty" as an empty water-tight thing.
[ This lets you do things like "x cup of water", "x full cup", or "x cup full of water". ]
Understand "full" or "of" as an nonempty water-tight thing.

Understand the available liquid property as describing a thing when the item described is liquid-yielding.

Section 6 - Printing

Rule for printing inventory details of a water-tight thing (called v):
	say "[vessel detail for v]".
Rule for printing room description details of a water-tight thing (called v):
	say "[vessel detail for v]".
To say vessel detail for (v - a water-tight thing):
	if v is nonempty:
		say " (full of [the contained liquid of v])";
	else if nothing is in v:
		say " (empty)".

Chapter 2 - Verbs

Section 1 - Filling

Filling it from is an action applying to two things.
Understand "fill [a water-tight thing] from/at/in/with [a visible liquid-yielding thing]" as filling it from.
Understand "fill [a water-tight thing] from/at/in/with [a nonempty water-tight thing]" as filling it from.
Understand "fill [something preferably held] from/at/in/with [something]" as filling it from.
Understand "pour [a nonempty water-tight thing] into/in [a water-tight thing]" as filling it from (with nouns reversed).
Understand "pour [something preferably held] into/in [something preferably held]" as filling it from (with nouns reversed).
Understand "put [a nonempty water-tight thing] in/into [a water-tight thing]" as filling it from (with nouns reversed).
Understand "put [a visible liquid-yielding thing] in/into [a water-tight thing]" as filling it from (with nouns reversed).
Understand the command "empty" as "pour".

Check an actor filling something from (this is the can't fill from itself rule):
	if the noun is the second noun:
		instead say "You can't fill something from itself!".
Check an actor filling something from (this is the can't fill something not water-tight rule):
	if the noun is not water-tight:
		instead say "[The noun] can't hold a liquid!".
Check an actor filling something from (this is the can't fill from things without liquid rule):
	if the second noun is not liquid-yielding and the second noun is not water-tight:
		instead say "You can't fill something from [the second noun]!".
Check an actor filling something from (this is the can't fill something closed rule):
	if the noun is openable and the noun is closed:
		instead say "[The noun] [are] closed."
Check an actor filling something from (this is the can't fill from something closed rule):
	if the second noun is openable and the second noun is closed:
		instead say "[The second noun] [are] closed."
Check an actor filling something from (this is the can't fill from something empty rule):
	if the second noun is an empty water-tight thing:
		instead say "[The second noun] is empty!".
Check an actor filling something from (this is the can't fill something full rule):
	if the noun is not empty:
		instead say "[The noun] is already full of [the contained liquid of the noun]!".
Check an actor filling something from (this is the implicitly take portable sources when filling rule):
	if the second noun is portable and the actor is not carrying the second noun:
		carry out the implicitly taking activity with the second noun;
		if the actor is not carrying the second noun, stop the action.
Check an actor filling something from (this is the implicitly take thing being filled if portable rule):
	if the noun is portable and the actor is not carrying the noun:
		carry out the implicitly taking activity with the noun;
		if the actor is not carrying the noun, stop the action.
		
Carry out an actor filling something from something water-tight (this is the filling from something water-tight rule):
	now the contained liquid of the noun is the contained liquid of the second noun;
	now the contained liquid of the second noun is emptiness.
Carry out an actor filling something from something liquid-yielding (this is the filling from something liquid-yielding rule):
	now the contained liquid of the noun is the available liquid of the second noun.

To pour is a verb. To fill is a verb.
Report an actor filling something from a portable water-tight thing (this is the report filling from a portable water-tight thing rule):
	say "[The actor] [pour] the [contained liquid of the noun] from [the second noun] into [the noun].";
Report an actor filling something from a portable liquid-yielding thing (this is the report filling from a portable liquid-yielding thing rule):
	say "[The actor] [pour] some [contained liquid of the noun] from [the second noun] into [the noun].";
Report an actor filling something from something fixed in place (this is the report filling from something fixed in place rule):
	say "[The actor] [fill] [the noun] with [contained liquid of the noun] from [the second noun]."

Section 2 - Emptying

Emptying is an action applying to one carried thing.
Understand "empty [a held nonempty water-tight thing]" as emptying.
Understand "empty [something preferably held]" as emptying.
Understand "pour out/-- [a held nonempty water-tight thing] out/--" as emptying.
Understand "pour out/-- [something preferably held] out/--" as emptying.

The emptying action has a liquid called the former contents.

To do is a verb.
Check an actor emptying something (this is the can't empty something empty rule):
	if the noun is not a nonempty water-tight thing and the noun contains nothing:
		instead say "[The noun] [don't] have anything in [them] to pour out."
Check an actor emptying something (this is the can't empty something closed rule):
	if the noun is openable and the noun is closed:
		instead say "[The noun] [are] closed."

Carry out an actor emptying something (this is the emptying rule):
	now the former contents is the contained liquid of the noun;
	now the contained liquid of the noun is emptiness;
	now every thing is unmarked for listing;
	repeat with T running through things in the noun:
		now T is marked for listing;
		now T is in the location of the actor.

To pour is a verb. To dump is a verb.
Report an actor emptying something (this is the report emptying rule):
	if the former contents is emptiness:
		say "[The actor] [dump] out [the list of marked for listing things] from [the noun].";
	else if the list of marked for listing things is empty:
		say "[The actor] [pour] out the [former contents] from [the noun].";
	else:
		say "[The actor] [dump] out the [former contents] as well as [the list of marked for listing things] from [the noun].";
	now every thing is unmarked for listing.

Emptying it from is an action applying to one liquid and one carried thing.
Understand "empty [a liquid] from [a held nonempty water-tight thing]" as emptying it from.
Understand "empty [a liquid] from [something preferably held]" as emptying it from.
Understand "remove [a liquid] from [a held nonempty water-tight thing]" as emptying it from.
Understand "remove [a liquid] from [something preferably held]" as emptying it from.

Check an actor emptying a liquid (called L) from something:
	if the contained liquid of the second noun is L:
		instead try the actor emptying the second noun;
	else if the contained liquid of the second noun is emptiness:
		instead say "[The second noun] [don't] have any [L] in [them] to pour out.";
	else:
		instead say "[The second noun] [are] full of [the contained liquid of the second noun], not [L]."

Section 3 - Pouring Onto

Pouring it onto is an action applying to one carried thing and one thing.
Understand "empty [a held nonempty water-tight thing] on/onto [something]" as pouring it onto.
Understand "empty [something preferably held] on/onto [something]" as pouring it onto.
Understand "pour out/-- [a held nonempty water-tight thing] out/-- on/onto/at [something]" as pouring it onto.
Understand "pour out/-- [something preferably held] out/-- on/onto/at [something]" as pouring it onto.
Understand "douse [something] with [a held nonempty water-tight thing]" as pouring it onto (with nouns reversed).
Understand "douse [something] with [something preferably held]" as pouring it onto (with nouns reversed).
Understand the command "dump" as "pour".

Definition: something is non-supporter if it is not a supporter.
Understand "put [a held nonempty water-tight thing] on [a non-supporter thing]" as pouring it onto.

Check an actor pouring something onto something (this is the can't pour something not held rule):
	if the actor is not carrying the noun: 
		carry out the implicitly taking activity with the noun; 
		if the actor is not carrying the noun, stop the action.
Check an actor pouring something onto something (this is the can't pour something empty onto rule):
	if the noun is not a nonempty water-tight thing:
		if the noun is liquid-yielding:
			instead say "That doesn't seem like it'd work very well.";
		else:
			instead say "[The noun] [don't] have anything in [them] to pour out."
Last check an actor pouring something onto something (this is the block pouring onto rule):
	instead say "Drenching [the second noun] in [contained liquid of the noun] doesn't seem like it would improve the situation."

Carry out an actor pouring something onto something (this is the pouring onto rule):
	now the contained liquid of the noun is emptiness.

Report an actor pouring something onto something (this is the report pouring onto rule):
	say "[The actor] [pour] out the [former contents] from [the noun] onto [the second noun]."

Section 4 - Drinking

Understand "drink from [something preferably held]" as drinking.
Understand "drink from [a nonempty held water-tight thing]" as drinking.
Understand "drink from [a visible liquid-yielding thing]" as drinking.
Understand "drink [a visible liquid-yielding thing]" as drinking.
Understand "drink [a nonempty held water-tight thing]" as drinking.

The drinking action has a liquid called the beverage.

The block drinking rule is not listed in any rulebook.

To drink is a verb.
Check an actor drinking something (this is the can't drink non-liquidy things rule):
	if the noun is not liquid-yielding and the noun is not a nonempty water-tight thing:
		instead say "[The noun] doesn't contain anything to drink!".
Check an actor drinking something (this is the implicitly take thing being drunk if portable rule):
	if the noun is portable and the actor is not carrying the noun:
		carry out the implicitly taking activity with the noun;
		if the actor is not carrying the noun, stop the action.

Carry out an actor drinking something water-tight (this is the drinking from something water-tight rule):
	now the beverage is the contained liquid of the noun;	
	now the contained liquid of the noun is emptiness;
Carry out an actor drinking something liquid-yielding (this is the drinking from something liquid-yielding rule):
	now the beverage is the available liquid of the noun.

Report an actor drinking something (this is the report drinking rule):
	say "[The actor] [drink] the [beverage] from [the noun]."

Section 5 - Error Messages

Check an actor inserting something into a water-tight thing that is not a container (this is the can't insert into water-tight non-containers rule):
	if the actor is the player:
		say "[The second noun] is better suited for carrying liquids.";
	stop the action.

Chapter 3 - Standard Liquids

Section 1 - Water

There is a liquid called water.

Definition: something is watery if it yields water or it is full of water.

Watering is an action applying to one thing.
Understand "water [something]" as watering.

Check an actor watering something (this is the need a water source to water something rule):
	if the actor does not hold something watery:
		instead say "[The actor] [do]n't have any water."
Carry out an actor watering something:
	try the actor pouring a random watery thing held by the actor onto the noun.

Liquids ends here.

---- DOCUMENTATION ----

This extension provides basic support for sources of liquids and things that can hold a liquid. It has some similarities to Liquid Handling by Al Golden but restricts itself to pretty basic functionality, not addressing possibilities like mixing liquids and interactions between liquids and other objects. It also isn't interested in measuring volumes of liquid.

Chapter 1 - Vessels and Water-Tight Things

A thing can be water-tight, which means it can hold a liquid. A vessel is a kind of thing that is water-tight, but you can also declare things water-tight directly, for example if you want a water-tight container (that can hold both liquids and things).

A water-tight thing has a property called the contained liquid. Thus, you can create a vessel full of water with:
	
	A vessel called a bottle is here. The contained liquid is water.

Liquids are a kind of enumerated value, rather than a thing. (The water in two different things is equivalent, rather than them being two separate objects.) You can't interact with the liquid directly, but with whatever it's in. (However, you can use the contained liquid to refer to the thing it's in.)

If there's nothing currently in a water-tight thing, its contained liquid is the special "liquid" emptiness. Aside from emptiness, the only default liquid is water, but you can easily create new liquids with something like:
	
	There is a liquid called milk.

Water-tight things are considered empty or nonempty based on whether they contain a liquid. You can also refer to them with phrases like "if the noun is full of water" or "if water fills the noun".
	
Chapter 2 - Liquid-Yielding Things

Sometimes you want to have something be an infinite source of a liquid. To do this, just set the available liquid property of it.

	A thing called the fountain is here. The available liquid is water.

You can fill containers at these liquid-yielding things freely.

Such things are considered liquid-yielding, and you can refer to them with phrases like "if the noun yields water" or "if water is available at the noun".

Chapter 3 - Actions

This extension defines only a few basic actions to do with liquids, with the expectation that individual games will probably want to add more depending on how they want liquids to be used.

You can fill a water-tight thing from a liquid-yielding thing or from another water-tight thing. (In the latter case, the source thing will now be empty, because it's assumed that all water-tight things have equivalent capacities.)

You can pour out a water-tight thing, in which case the contained liquid is lost.

You can pour a water-tight thing onto something specific. By default, this is blocked by the block pouring onto rule.

You can also drink from a water-tight thing. The default behavior assumes that liquids are safe to drink and have no side-effects.

Chapter 4 - Bugs and Comments

This extension is hosted in Github at https://github.com/i7/extensions/tree/master/Xavid. Feel free to email me at extensions@xavid.us with questions, comments, bug reports, suggestions, or improvements.

Example: * Kitchen - Basic manipulation of liquids.

	*: "Kitchen"
	
	Include Liquids by Xavid.

	Kitchen is a room.

	There is a liquid called milk.

	A sink is here. It is fixed in place. The available liquid is water.

	A vessel called a cup is here.

	A vessel called a jug is here. The contained liquid is milk.

	Test me with "pour milk into cup / i / drink milk / fill cup from sink / i / empty cup / i".

Example: ** Unit Tests

	*: "Unit Tests"

	Include Liquids by Xavid.
	Include Command Unit Testing by Xavid.

	Kitchen is a room.

	There is a liquid called milk.
	There is a liquid called juice.
	There is a liquid called vinegar.

	A sink is here. It is fixed in place. The available liquid is water.

	A vessel called a mug is here.

	A thing called a big jug is here. The available liquid is milk.
	
	A vessel called a cup is here. The contained liquid is juice.
	
	A closed water-tight openable container called a jar is here. The contained liquid is vinegar.

	An animal called a weasel is here.

	Unit test:
		start test "implicit taking";
		assert that "fill mug from jug" produces "(first taking the big jug)[line break](first taking the mug)[line break]You pour some milk from the big jug into the mug.";
		do "drop mug";
		assert that "empty mug" produces "(first taking the mug)[line break]You pour out the milk from the mug.";
		do "drop all";
		assert that "fill mug from cup" produces "(first taking the cup)[line break](first taking the mug)[line break]You pour the juice from the cup into the mug.";
		do "drop mug";
		assert that "drink juice" produces "(first taking the mug)[line break]You drink the juice from the mug.";
		do "drop all";
		assert that "fill cup from sink" produces "(first taking the cup)[line break]You fill the cup with water from the sink.";	
		assert that "put water in mug" produces "(first taking the mug)[line break]You pour the water from the cup into the mug.";
		assert that "douse weasel" produces "(with the mug)[line break]Drenching the weasel in water doesn't seem like it would improve the situation.";
		assert that "dump mug on weasel" produces "Drenching the weasel in water doesn't seem like it would improve the situation.";
		assert that "dump cup on weasel" produces "The cup doesn't have anything in it to pour out.";
		assert that "empty juice from mug" produces "The mug is full of water, not juice.";
		assert that "empty water from mug" produces "You pour out the water from the mug.";
		assert that "remove juice from mug" produces "The mug doesn't have any juice in it to pour out.";
		do "take jar";
		assert that "empty jar" produces "The jar is closed.";
		assert that "pour jar into cup" produces "The jar is closed.";
		do "fill mug from sink";
		assert that "pour mug into jar" produces "The jar is closed.";
	
	Test me with "unit".
