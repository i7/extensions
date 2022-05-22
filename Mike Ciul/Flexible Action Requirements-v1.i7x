Version 1 of Flexible Action Requirements by Mike Ciul begins here.

"Overrides carrying requirements for specific actions, and provides more nuanced carrying and touchability requirements when needed."

Volume - Flexible Kinds of Action

Waiting is flexible about carrying the noun.
Waiting is flexible about carrying the second noun.
Waiting is flexible about touching the noun.
Waiting is flexible about touching the second noun.

Part - Involved and Must Be Used

To decide whether (item - a thing) must be used:
	Decide on whether or not the current action involves the item.

Definition: An object is involved if it must be used.

To decide whether (O - a description of objects) must be used:
	unless the O that must be used is nothing, yes;
	no.

To decide which object is the (O - a description of objects) that must be used:
	if the noun matches O, decide on the noun;
	if the second noun matches O, decide on the second noun;
	decide on nothing.

Volume - Carrying Requirements

Part - Determining Carrying Requirements

Chapter - Only Available When Carried and Must Be Carried

Definition: an object (called item) is only available when carried:
	Follow the custom carrying requirements for the item;
	If the outcome of the rulebook is the it must be carried outcome, yes;
	no.
	
To decide whether (item - a thing) must be carried:
	If item is not involved, no;
	Decide on whether or not item is only available when carried.

Chapter - Custom Carrying Requirements Rules

The custom carrying requirements is an object-based rulebook. The custom carrying requirements rules have outcomes it must be carried (failure) and it may be merely visible (success).

Custom carrying requirements for the noun (this is the basic carrying requirements for the noun rule):
	If flexible about carrying the noun, make no decision;
	If the action requires a carried noun, it must be carried.
	
Custom carrying requirements for the second noun (this is the basic carrying requirements for the second noun rule):
	If flexible about carrying the second noun, make no decision;
	If the action requires a carried second noun, it must be carried.
			
Part - Enforcing Carrying Requirements

Chapter - The Flexible Carrying Requirements Rule

Section - Definition

An action-processing rule (this is the flexible carrying requirements rule):
	If the noun is not held by the person asked and the noun is only available when carried:
		Carry out the implicitly taking activity with the noun;
		If the noun is not carried, stop the action;
	If the second noun is not held by the person asked and the second noun is only available when carried:
		Carry out the implicitly taking activity with the second noun;
		If the second noun is not carried, stop the action.

The flexible carrying requirements rule is listed instead of the carrying requirements rule in the action-processing rules.

Chapter - Implicit Taking

For implicitly taking something (called the item):
	Do an implicit take with the item;
	
To do an implicit take with (O - an object):
	(- ImplicitTake({O}); -)
		
Volume - Touchability Requirements

Part - Determining Touchability

Chapter - Only Available When Touchable and Must Be Touched

Definition: an object (called item) is only available when touchable:
	Follow the custom touchability requirements for the item;
	If the outcome of the rulebook is the it must be touchable outcome, yes;
	no.

To decide whether (item - a thing) must be touched:
	If item is not involved, no;
	Decide on whether or not item is only available when touchable.

To decide whether (O - a description of objects) must be touched:
	[This is not only convenient, but it's faster than looping over all things to find something that is "required to be touched"]
	unless the O that must be touched is nothing, yes;
	no.

To decide which object is the (O - a description of objects) that must be touched:
	if the noun matches O and the noun is only available when touchable, decide on the noun;
	if the second noun matches O and the second noun is only available when touchable, decide on the second noun;
	decide on nothing.

Definition: a thing is required to be touched if it must be touched.

Chapter - Custom Touchability Requirements Rules
	
The custom touchability requirements is an object-based rulebook. The custom touchability requirements rules have outcomes it must be touchable (failure) and it may be merely visible (success).

Custom touchability requirements for the noun (this is the basic touchability requirements for the noun rule):
	If flexible about touching the noun, make no decision;
	If the action requires a touchable noun, it must be touchable.
	
Custom touchability requirements for the second noun (this is the basic touchability requirements for the second noun rule):
	If flexible about touching the second noun, make no decision;
	If the action requires a touchable second noun, it must be touchable.

Flexible Action Requirements ends here.

---- DOCUMENTATION ----

Section: Altering Action Requirements

Some actions in the Standard Rules are described as acting on "one carried thing." If we want to waive those requirements, our only option is to create a new action that doesn't have them. This extension removes that problem by making the carrying requirements more flexible.

In addition, we can now specify touchability requirements in the same level of detail as with carrying requirements. We can also use it to make fine-tuned tests in our own accessibility rules.

Section: Carrying Requirements

To waive the carrying requirements for an action, we can designate it as either of the "flexible about carrying the noun" or "flexible about carrying the second noun" kinds of action.

	Eating is flexible about carrying the noun.
	Unlocking something with the Force is flexible about carrying the second noun.

If that's not fine enough detail, we can add rules to the "custom carrying requirements" rulebook, which is an object-based rulebook. The rulebook has two outcomes, "it must be carried," and "it may be merely visible." If the rulebook makes no decision, we assume there are no carrying requirements.

	Custom carrying requirements for the speck of dust:
		if taking, make no decision;
		If the current action involves the speck of dust, it must be carried.

	Custom carrying requirements for the Force:
		it may be merely visible.

To test the carrying requirements, we can use the "only available when carried" adjective.

	Before doing something when the noun is only available when carried:
		if the noun is not carried:
			say "Sorry, you can't do that when you're not carrying [the noun].";
			stop the action;
		otherwise:
			say "(Good thing you're carrying [the noun] now)[command clarification break]"

All of the built-in custom carrying requirements rules test if the item is "involved," i.e. it is the noun or the second noun. If you create custom carrying requirements rules that decide "it must be carried" for any other objects, you might get unexpected results when using the "only available when carried" adjective. If you must be absolutely sure that the item is both involved AND required for its role in the current action, you can use this to-decide-whether phrase:

	if the golden plough must be carried:

A note on the use of "involved:" If you make use of the phrase "an involved thing," you will be executing a loop over all objects in the game to see which things are involved. To avoid this, you can use the phrase "a (description of objects) must be used" instead, which will be true for all matching items that are involved. You can also obtain "the (description of objects) that must be used," which will return the noun if it matches, or the second noun if it matches but the noun doesn't.

Section: Touchability Requirements

Two similar kinds of action are defined so we can waive touchability requirements for objects: "flexible about touching the noun" and "flexible about touching the second noun."

The adjective "only available when touchable" will tell us if an object is subject to touchability requirements of the current action. And we can make sure it is also involved in the current action using the to-decide-whether phrase "must be touched." 

Some phrases to help us are:

	(the item) must be touched

This phrase workes on individual objects as well as descriptions of objects:

e.g.
	if the top of the flagpole must be touched:

or:

	if a container must be touched:

We can also use a description of objects to identify a particular thing that must be touched:

	the (item) that must be touched

Finally, there is an adjective, "required to be touched" that means the same thing. Be careful about using this, though - although it's more flexible than using one of the above phrases, it will loop over all objects in the game every time it is used. If you do that in the preamble of an accessibility rule, that will happen at least once every turn!

A warning about this, though: If you regularly use this adjective or phrase in rule conditions, you're going to spend a lot of time looping over every object in the game just to see if it's involved in the action. Consider looping explicitly over the noun and the second noun instead.

To meddle with touchability requirements further, we may create "custom touchability requirements" rules. The outcomes are called "it must be touchable," and again, "it may be merely visible."

Unlike the carrying requirements modifications, though, there are no built-in changes to accessibility rules. Declaring that
	
	listening is flexible about touching the noun

will not allow us to listen to things that are out of reach. We'd have to define our own rules, perhaps like this:

	Reaching outside (this is the can always reach available when merely visible objects rule):
		unless something must be touched, allow access;

	The can always reach available when merely visible objects rule is listed before the can't reach outside closed containers rule in the reaching outside rules.

Even then, we would still need additional grammar lines or "try" statements to enable the player to perform actions on things that are not in scope.

The main value of the touchability requirements, then, is so we can designate some objects in scope as "too far away" or "too high up:" 

	Accessibility rule when the fans must be touched:
		say "The fans are too far away.";
		stop the action;

Section: Notes

Thanks to Troy Jones III and Matt Weiner for inspiring this extension. You may contact Mike Ciul at captainmikee@yahoo.com with bug reports and feedback.

Example: * "Mange Tout" - A blancmange that can't be taken but can be eaten, and tennis fans who can't be touched but can be heard.

	*: "Mange Tout"
	
	Include Flexible Action Requirements by Mike Ciul.

	Wimbledon Stadium is a room. A giant blancmange is a fixed in place edible thing in Wimbledon Stadium.

	The fans are a plural-named person in Wimbledon.

	Accessibility rule when the fans must be touched:
		say "The fans are too far away.";
		stop the action;

	Instead of listening to the fans when the blancmange is off-stage:
		say "A tremendous roar of jubilation washes over you.";
		end the story finally saying "You have won the match."
	
	Instead of listening to the fans:
		say "The crowd is hushed with terror and anticipation.";
	
	Eating is flexible about carrying the noun;
	Listening is flexible about touching the noun;

	Test me with "listen to fans/eat fans/take blancmange/eat blancmange/listen to fans"

