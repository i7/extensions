Version 2 of Dishes by Emily Short begins here.

"Dishes is a convenience extension for use with Measured Liquid. It provides some standard-sized cups, glasses, graduated measuring cups, jugs, bottles, etc., as well as a corked bottle kind that opens with the use of a secondary cork object."

Include Measured Liquid by Emily Short.

To need is a verb. To hold is a verb. To stopper is a verb. To acquire is a verb.

Chapter 1 - Ordinary Containers

Section 0 - Plates

A plate is a kind of supporter. A plate is portable. The carrying capacity of a plate is 1.

Section 1 - Fluid containers

A glass is a kind of fluid container. [Standard-size] A glass is usually preferred for drinking.
A cup is a kind of fluid container. A cup is usually preferred for drinking.
A flask is a kind of fluid container. A flask is usually closed and openable.

A measuring cup is a kind of fluid container. A measuring cup is usually graduated. The description of a measuring cup is usually "A measuring cup measuring up to [fluid capacity of the item described]."
Before printing the name of a measuring cup when at least two measuring cups are visible (this is the label cups rule):
	say "[fluid capacity] " (A).
Understand the fluid capacity property as describing a measuring cup.

A jug is a kind of fluid container.
A bottle is a kind of fluid container. Bottles are usually openable, transparent, and closed. 

Section 2 - Imperial Definitions (for use without Metric Units by Graham Nelson)

The fluid capacity of a cup is usually 8.0 fl oz.
The fluid capacity of a flask is usually 10.0 fl oz.
The fluid capacity of a bottle is usually 25.0 fl oz.
The fluid capacity of a jug is 32.0 fl oz.

Section 3 - Metric Definitions (for use with Metric Units by Graham Nelson)

The fluid capacity of a cup is usually 237 mL.
The fluid capacity of a flask is usually 300 mL.
The fluid capacity of a bottle is usually 750 mL.
The fluid capacity of a jug is 1000 mL.

Chapter 2 - Corked Bottles

Section 1 - The Bottle and Cork

A corked bottle is a kind of bottle. It is privately-named. The printed name is "bottle". Understand "bottle" as a corked bottle. Understand "bottles" as the plural of a corked bottle.

A cork is a kind of thing. A cork is in every corked bottle.  

The examining corked bottles rule is listed before the examining fluid containers rule in the carry out examining rules.

This is the examining corked bottles rule: 
	if the noun is a corked bottle:
		say "[The noun] [fill description of the noun][paragraph break]" (A); 
		rule succeeds. [we need to do this because we want to prevent hearing about the cork]

The prefix closedness rule is not listed in any rulebook.

Before printing the name of a closed transparent fluid container (called the target) while taking inventory (this is the new prefix closedness rule):
	unless the target is a corked bottle: 
		say "closed " (A);
	otherwise:
		say "stoppered " (B).

Section 2 - Manipulating Corks

Understand "cork [something]" as corking. Understand the command "stopper" as "cork".

Understand "uncork [something]" as uncorking.

Corking is an action applying to one thing.

Check an actor corking something which is not a corked bottle (this is the can't cork what isn't a corked bottle rule):
	if the actor is the player:
		say "[The noun] [cannot] be corked." (A) instead;
	stop the action.

Carry out an actor corking something (this is the convert corking to closing rule):
	try the actor closing the noun.

Uncorking is an action applying to one thing.

Check an actor uncorking something which is not a corked bottle (this is the can't uncork what isn't a corked bottle rule):
	if the player is the actor:
		say "[The noun] [cannot] be uncorked." (A) instead;
	stop the action.

Carry out an actor uncorking (this is the convert uncorking to opening rule):
	try opening the noun.

Understand "close [something] with [something]" as corking it with.

Understand "cork [something] with [something]" as corking it with.

Corking it with is an action applying to two things.

Check an actor corking something which is not a corked bottle with something (this is the can't cork what isn't a corked bottle with anything rule):
	if the actor is the player:
		say "[The noun] [cannot] be corked." (A) instead;
	stop the action.

Check an actor corking something with something which is not a cork (this is the can't cork with noncorks rule):
	if the actor is the player:
		say "[The second noun] [do] not fit in [the noun]." (A) instead;
	stop the action.

Check an actor corking something with something which is not held by the actor (this is the take corks before using them rule):
	if the actor is the player:
		say "(first taking [the second noun])[command clarification break]" (A);
	silently try the actor taking the second noun;
	if the actor does not carry the second noun:
		stop the action.
	
Carry out an actor corking something with something (this is the convert corking into inserting rule):
	try the actor inserting the second noun into the noun instead.

Check an actor closing a corked bottle (this is the convert closing corked bottles into inserting rule):
	if a cork (called the item) is carried by the actor:
		try the actor inserting the item into the noun instead;
	otherwise:
		if the player is the actor:
			say "[We] [need] a stopper of some kind." (A);
		stop the action.

Check an actor opening a corked bottle (this is the convert opening corked bottles into taking rule):
	if a cork (called the item) is in the noun: 
		try the actor taking the item instead;
	otherwise:
		if the player is the actor:
			say "[The noun] [have] no stopper." (A);
		stop the action.

The new no solids rule is listed instead of the can't put solids into a fluid container rule in the check inserting it into rules.

This is the new no solids rule:
	if the second noun is a fluid container and the noun is not a cork:
		say "[The second noun] [hold] only liquids." (A) instead.

After an actor inserting a cork into a corked bottle (this is the report corkages rule):
	now the second noun is closed;
	if the player is the actor:
		say "[We] [stopper] [the second noun] with [the noun]." (A);
	otherwise:
		if the player can see the actor:
			say "[The actor] [stopper] [the second noun] with [the noun]." (B)

Rule for reaching inside a closed corked bottle (this is the cork can be accessed rule):
	if the noun is a cork or the second noun is a cork:
		rule succeeds.

Carry out an actor taking a cork when the noun is in a closed corked bottle (called the item) (this is the taking corks opens bottles rule): 
	now the item is open.

Report taking a cork (this is the standard report cork-taking rule):
	say "[We] [acquire] the cork." (A) instead.
  
[We convert all this to the take action because that guarantees correct management of inventory -- so if we take the cork, we shuffle other objects into our bag, etc. We could convert take cork to open bottle instead, but that leaves all that bookkeeping unaccounted for.]

Section 3 - The Corkscrew and Sealed Bottles

A corked bottle can be sealed or unsealed. A corked bottle is usually sealed.

A corkscrew is a kind of thing.

A corked bottle is lockable.

Check an actor unlocking a corked bottle with a corkscrew (this is the convert unlocking to cork removal rule):
	try the actor uncorking the noun instead.

Check an actor taking a cork when the noun is in a sealed bottle (this is the can't open without a corkscrew assuming corkscrews exist rule):
	if the number of corkscrews is at least 1:
		if the actor carries a corkscrew:
			continue the action;
		if the actor can see a corkscrew (called the target):
			if the actor is the player:
				say "(first taking [the target])[command clarification break]" (A);
			otherwise:
				say "([the actor] first taking [the target])[command clarification break]" (B);
			silently try the actor taking the target;
			if the actor carries the target:
				continue the action;
			otherwise:
				stop the action;
		if the player is the actor:
			say "[We] [need] a corkscrew."  (C) instead;
		stop the action.

Carry out an actor opening a corked bottle (this is the unseal a corked bottle once opened rule):
	now the noun is unsealed.

Dishes ends here.

---- Documentation ----

Dishes is a convenience extension for use with Measured Liquid by Emily Short. Dishes provides some standard-sized cups, glasses, graduated measuring cups, jugs, bottles, etc., as well as a corked bottle kind that opens with the use of a secondary cork object.

The kinds defined by dishes are:

	Glass: standard 12 oz (or similar in Metric units)
	Measuring Cup (graduated -- see Measured Liquid): 12.0 fl oz
	Cup: 8.0 fl oz / 237 mL
	Flask (openable, opaque): 10.0 fl oz. / 300 mL
	Bottle (openable, transparent): 25.0 fl oz / 750 mL
	Jug: 32.0 fl oz / 1000 mL

Glasses and cups are marked "preferred for drinking", which means that the game will try to have the player sip from these in preference to jugs or bottles, if a command is ambiguous.

A subkind of the bottle is the corked bottle: it has the same fluid capacity as an ordinary bottle, but it comes with a cork which must be removed for drinking.

A corkscrew kind is also provided. If there is a corkscrew in the game, it will be required to open a corked bottle for the first time; if not, the player character is presumed to have the gift of opening corked bottles by the power of his mind alone.

Example: * Sipping - A bottle of hard cider and a glass and corkscrew to assist in drinking from it.

	*: "Sipping"
	
	Include Dishes by Emily Short.

	The Kitchen is a room. The cabinet is a closed openable container in the kitchen. It is fixed in place. 

	The cabinet contains a glass and a corkscrew.

	The player carries a corked bottle called a heavy bottle. The liquid of the heavy bottle is hard cider. The fluid content of the heavy bottle is 25.0 fl oz.

	Table of Liquids (continued)
	liquid	potable	flavor
	hard cider	true	"It tastes deliciously tangy."	

	Understand "hard" or "cider" as the hard cider.

	Test me with "i / drink cider / open cider / open cabinet / open cider / drink cider / pour cider in glass / drink cider / cork bottle / drink cider / g / g / g / g / g / drink bottle / i".
