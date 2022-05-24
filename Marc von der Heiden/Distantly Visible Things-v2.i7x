Version 2.0.220523 of Distantly Visible Things by Marc Von Der Heiden begins here.

"Provides flexible handling of things that can be seen in multiple rooms, but - unlike backdrops - still have one distinct location."

[Version number and filename updated by Nathanael Nerode for Inform 10.1, with no other changes needed from the 6L62 version.]

Chapter 1 - Basic framework

Distant visibility relates various things to various rooms. The verb to be distantly visible from implies the distant visibility relation.
 
A thing has a text called distant description.

The distance visibility rules are an action based rulebook. The distance visibility rules have outcomes allow action (success) and deny action (failure). The distance visibility rules have default failure.

Printing a refusal for distantly handling something is an activity on things

Chapter 2 - Bringing distantly visible things in scope

After deciding the scope of the player (this is the put distantly visible things in scope rule):
	if the player is not enclosed by a closed opaque container:
		repeat with X running through things that are distantly visible from the location of the player:
			if X is not enclosed by a closed opaque container:
				if X is lit or the location of X is lit or X can see a lit thing, place X in scope, but not its contents.

Chapter 3 - Handling touchability of distantly visible things

The can't touch distantly visible things rule is listed before the access through barriers rule in the accessibility rulebook.
Accessibility rule (this is the can't touch distantly visible things rule):
	if the action requires a touchable noun and the noun is a thing that is distantly visible from the location of the player:
		carry out the printing a refusal for distantly handling activity with the noun; 
		stop the action;
	if the action requires a touchable second noun and the second noun is a thing that is distantly visible from the location of the player:
		carry out the printing a refusal for distantly handling activity with the second noun;
		stop the action.

Chapter 4 - The distance visibility rulebook

The distance visibility stage rule is listed before the instead stage rule in the action-processing rulebook.
This is the distance visibility stage rule:
	unless the noun is a thing that is distantly visible from the location of the player or the second noun is a thing that is distantly visible from the location of the player, continue the action;
	follow the Distance visibility rulebook;
	if rule succeeded, continue the action;
	if rule failed, stop the action.

Last distance visibility rule (this is the block actions with distantly visible things rule):
	if the noun is a thing that is distantly visible from the location of the player:
		carry out the printing a refusal for distantly handling activity with the noun;
		deny action;
	if the second noun is a thing that is distantly visible from the location of the player:
		carry out the printing a refusal for distantly handling activity with the second noun;
		deny action.

Distance visibility for Examining (this is the examining distantly visible things rule):
	unless the noun provides a distant description, make no decision;
	if the distant description of the noun is "", make no decision;
	say the distant description of the noun;
	say paragraph break;
	deny action.

Chapter 5 - Standard refusal message for distantly visible things

Rule for printing a refusal for distantly handling a thing (called target) (this is the standard printing a refusal for distantly handling rule):
	say "[We] [need] to get closer to [the target][unless best route from the location of the player to the location of the target is nothing], which [regarding the target][are] to the [best route from the location of the player to the location of the target][end unless]." (A).

Distantly Visible Things ends here.

---- DOCUMENTATION ----

Distantly Visible Things allows us to implement things that can not only be seen (and referenced by the player) in their actual location, but also in other rooms. The extension provides an easy way to have those things respond differently to the players' command when she references them "from far". This could - for example - be useful if we wanted to design a rather open environment in which the different rooms are not seperated by walls. Unlike backdrops, which are automatically moved around by the game and are mostly used for objects that don't need to be manipulated by the player, distantly visible things retain one distinct location in which they are "physically" in.

Chapter: Standard behavior of the extension

In order to make a thing visible from another room, we use the newly created "Distant visibility" relation which is implied by the verb "to be distantly visible by"

	The huge estate is a room. The street ist south of the estate. The mansion is a thing in the estate. The mansion is distantly visible from the street.

The player can now reference the mansion while she is on the street, so she doesn't get a "You can't see any such thing." response - which would be silly if, for example, we had mentioned it in the description of the street - or if it was otherwise obvious that it should be visible from there.

A thing can be distantly visible from more than one room and a room can have more than one thing in it that is distantly visible. Things that are contained, supported or incorporated in a distantly visible thing will NOT automatically be so too; we have to set the distant visibility relationship for them manually (so making the big marble fountain visible from another room doesn't necessarily mean that the coins inside its basin are also visible from afar). 

A thing that's distantly visible is never touchable from another room. If we tried to take it (or perform some other action that required touchability) we will get a standard refusal message that tells the player to go closer to the object and hint her which way to go (if there's a map connection). Even most other actions (such as looking under) will by default be blocked from being done over distance. 

The only special case is the Examining action: The extension defines a new property for things, a text called the "distant description". Whenever the player examines a distantly visible thing that has a distant description, this will be printed instead of the refusal message. So with this code:

	The distant description of the mansion is "A beautiful mansion that dates back to the Victorian era.". The description of the mansion is "From up close, the number of cracks in the masonry make the deterioration of the building more than obvious.".

the player will be able to get a good glimpse at the house from the street, but the truth will only be discovered on a closer look.

Chapter: Customizing the mechanics

Although the standard behavior might just meet most of the needs, we can customize some of the features.

Section: Changing the refusal message

The refusal message is printed by an object-based activity called "printing a refusal to distantly handling". The standard behavior is to say...

	You need to get closer to the mansion, which is to the north.

or - if there was no (direct or indirect) map connection - just...

	You need to get closer to the mansion.

As with all activities we can provide additional before, for or after rules. We could try, for example:

	After printing a refusal for distantly handling the house: say "(you'd really like to, but you were raised to respect private property)".

and the house will be subject to our mannerly upbringing.
If we wanted to override the behavior in its entirety, we could replace the "for" rule that comes with the extension (called the standard printing a refusal for distantly handling rule). With the new features of build 6L02 we could also just replace response (A) of this rule. (Now the standard printing a refusal for distantly handling rule response (A) is...)

Section: A new stage in action-processing: the distance visibility rules

Just before the Instead stage, a new rulebook called the distance visibility rules is followed if either the noun or the second noun is distantly visible from the player's location. At this point all actions that would have required a distantly visible thing to be touched will already have been blocked. Initially the new rulebook consists of two rules:

	Distance visibility for Examining (this is the examining distantly visible things rule)

...prints out the "distant description" of the noun if it provides one, otherwise does nothing.

	Last distance visibility rule (this is the block actions with distantly visible things rule)

...prints out the standard refusal message via the aforementioned activity (see last section).

We can add rules to this rulebook freely. If a rule in this rulebook ends with outcome "deny action", the action will be stopped immediately (assuming that a suitable response for the player has been printed); if it ends with outcome "allow action", the action will resume with the Instead stage and we might probably not want to say anything and leave that to action-processing. Out of the box this is never the case.

Examples:

	Distance visibility rule for Looking under the doormat when the key is not handled:
		say "The doormat has a suspicious bulge but you can't exactly see from here what might be under it.";
		deny action.

This rule prints out the response and then stops action processing. (Since "deny action" is the default outcome of this rulebook, the last line is optional.). The standard refusal ("You need to get closer to the doormat...") will not be printed, since the new rule is more specific than the block actions with distantly visible things rule.

	Distance visibility rule for Examining the mansion: allow action.

would make the mansion print its standard description when examined from another room (thus making the distant description for the mansion useless).

Section: Changing the rules for basic accessibility

By default all distantly visible things are never touchable and it is recommended to leave it this way. (They can, of course, be touched in the room they're actually in. They don't count as distantly visible there). This is handled in the 

	can't touch distantly visible things rule 

which is part of the accessibility rulebook. To alter this behavior we would need to unlist or rewrite this rule and probably meddle with the built-in can't reach inside rooms rule. Handle with care!

Example: * Manor House - Showing the standard behavior of the Distantly Visible Things extension

	*: "Manor House"
	
	Include Distantly Visible Things by Marc Von Der Heiden.
	
	End of Street is a room. "The road ends at the old manor house which dominates the landscape. The estate is surrounded by a metal fence, but right here a gate opens up to the north onto the property."
	The gate is a scenery thing in End of street. The description is "Nicely ornamented, with the former owner's family crest at the top.". Understand "fence" and "crest" as the gate. 
		
	Instead of touching the gate, say "Though it's a warm day, the metal feels somehow chilly.".
	
	The Huge estate is north of End of street. "You are standing on a lawn which would make every gardener happy. The manor house, three storeys tall, stands proudly in front of you. There's a fence around the lawn but a gate to the south leads to the street."
	The lawn is a scenery thing in the estate. The description is "Perfectly trimmed!".
	The mansion is a scenery thing in the estate. Understand "manor" or "house" or "building" as the mansion. The description of the mansion is "From up close, the number of cracks in the masonry make the deterioration of the building more than obvious.".

	The mansion is distantly visible from End of street. The distant description of the mansion is "A beautiful building that dates back to the Victorian era.". 
	
	The gate is distantly visible from the estate.
	
	test me with "x manor house / x gate / touch gate / n / x manor house / x gate / touch gate / x lawn / s / x lawn".
	
Notice how differently the house and the gate react to being examined from afar which is the consequence of one having a distant description and one having none (actually having one which is ""). The lawn, not being distantly visible anywhere, retains the usual behavior of the Standard Rules.

Example: ** Manor House 2 - Customizing distance visibility rules and refusal messages

	*: "Manor House 2"
	
	Include Distantly Visible Things by Marc Von Der Heiden.
	
	End of Street is a room. "The road ends at the old manor house which dominates the landscape. The estate is surrounded by a metal fence, but right here a gate opens up to the north onto the property."
	The gate is a scenery thing in End of street. The description is "Nicely ornamented, with the former owner's family crest at the top.". Understand "fence" and "crest" as the gate. The gate is distantly visible from the huge estate.
	The cobblestone is a thing in End of street. Understand "stone" as the cobblestone. The initial appearance is "A single cobblestone lies on the side of the road.". 

	The huge estate is north of End of street. "You are standing on a lawn which would make every gardener happy. The manor house, three storeys tall, stands proudly in front of you. There's a fence around the lawn but a gate to the south leads to the street. You can go around the house to enter a back garden to the north."
	The mansion is a scenery thing in the huge estate. Understand "manor" or "house" or "building" as the mansion. The description of the mansion is "From up close, the number of cracks in the masonry make the deterioration of the building more than obvious.". The mansion is distantly visible from End of street and the back garden.

	The back garden is north of the huge estate. "You are standing in a small garden north of the house. Most of the view is blocked by a maze of tall hedges, but a small path leads back to the front side of the house.". The goose feather is a thing in the back garden.

	The distant description of the mansion is "A beautiful building that dates back to the Victorian era.".
	Distance Visibility rule for Examining the mansion in the back garden: allow action.

	After printing a refusal for distantly handling the mansion when the huge estate is not visited, say "(although you'd really like to, you are somehow hesistant, because you were raised to respect private property)[paragraph break]".
	Rule for printing a refusal for distantly handling the gate: say "Actually you are standing in the middle of the huge lawn and the gate is some good 100 yards away!".

	Distance visibility rule for Throwing something at the mansion: allow action.
	Distance visibility rule for Throwing something at the mansion in end of street:
		say "You're too far away to hit the house from here.";
		deny action.
	Instead of Throwing the cobblestone at the mansion:
		now the cobblestone is off-stage;
		say "You hurl the stone in the direction of the house and hear some glass shatter.".

	test me with "x house / enter house / take stone / throw stone at house / n / close gate / x house / n / x house / get feather / throw feather at house / throw stone at house"
	
We use the Printing a refusal to distantly handling activity and the Distance visibility rules to customize the behavior of distantly visible things. See how differently the throwing it at action behaves in this example: only one situation (throwing something at the mansion when in end of street) is blocked by a Distance visibility rule, the rest is delivered back to the usual action processing, thus being handled in an Instead rule or by the built-in block throwing at rule.
