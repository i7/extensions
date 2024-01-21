Version 6 of Modified Exit by Emily Short begins here.

"Changes the handling of the EXIT action, allowing commands such as EXIT PLATFORM and GET OUT OF CHAIR, making characters leave enterable objects before traveling, and altering the default interpretation of >OUT when the player is neither inside an object nor in a room with an outside exit. Updated for adaptive text."

Use authorial modesty.

Use sequential action translates as (- Constant SEQUENTIAL_ACTION; -).

Section 1 - Leaving a named object

Understand "exit [thing]" as getting off. Understand "get out of [thing]" as getting off.

This is the new can't get off things rule:	
	if the actor is on the noun, continue the action;
	if the actor is carried by the noun, continue the action;
	if the actor is in the noun, continue the action;
	say "[text of can't get off things rule response (A)][line break]";
	stop the action.

The new can't get off things rule is listed instead of the can't get off things rule in the check getting off rules.

Section 2 - Getting out before taking something

Check an actor taking (this is the clever can't take what you're inside rule): 
	if the holder of the person asked is the noun, 
		abide by the implicit exiting rule;
	if the holder of the person asked is in the noun, rule fails.

The can't take what you're inside rule is not listed in any rulebook.

Section 3 - Getting up before walking away

Instead of going nowhere when the holder of the player is an enterable thing (called the divan) (this is the no motion without purpose rule): 
	if the noun is outside, try exiting instead;
	say "[There's] no exit that way, and [we] [are] [if the divan is a supporter]on[otherwise]in[end if] [the divan] anyway."

Section 4a - Rising before departure (for use without Rideable Vehicles by Graham Nelson)

Check an actor going somewhere when the holder of the person asked is an enterable thing (called the chaise) (this is the rising before departure rule):
	if the chaise is a vehicle, make no decision; [we do not want to activate this rule if the player is for instance in a car or on a bicycle]
	while the holder of the person asked is an enterable thing (called the chaise):
		abide by the implicit exiting rule;
		if the holder of the person asked is the chaise, stop the action;

Section 4b - Rising before departure (for use with Rideable Vehicles by Graham Nelson)

Check an actor going somewhere when the holder of the person asked is an enterable thing (called the chaise) (this is the rising before departure rule):
	if the person asked is on a rideable vehicle or the person asked is on a rideable animal:
		make no decision;
	if the chaise is a vehicle, make no decision; [we do not want to activate this rule if the player is for instance in a car or on a bicycle]
	while the holder of the person asked is an enterable thing (called the chaise):
		abide by the implicit exiting rule;
		if the holder of the person asked is the chaise, stop the action;

Section 5 - Implicit exiting defined

This is the implicit exiting rule:
	let the chaise be the holder of the person asked;
	if the person asked is the player and the sequential action option is not active:
		say "(first getting [if the chaise is a supporter]off[otherwise]out of[end if] [the chaise])[command clarification break]" (A);
		silently try the person asked exiting;
	otherwise:
		try the person asked exiting.

Section 6 - Bare Exit Means OUT

The new convert exit into go out rule is listed instead of the convert exit into go out rule in the check exiting rules.

This is the new convert exit into go out rule: 
	let the local room be the location of the actor;
	if the container exited from is the local room, convert to the going action on the outside.

Section 7 - Stand Up does NOT mean OUT (for use without Postures by Emily Short)

Understand the command "stand" as something new.

Understand "stand on [something]" as entering.

Understand "stand" or "stand up" as standing.

Standing is an action applying to nothing. 

Check an actor standing (this is the check holder for standing rule):
	if the holder of the actor is a room:
		if the actor is the player, say "[We] [are] already up." (A);
		stop the action; 

Carry out an actor standing (this is the convert standing to getting off rule):
	try the person asked getting off the holder of the person asked;
	rule succeeds.

Section 7a - Stand UP does NOT mean OUT (for use with Postures by Emily Short)

[We don't need the definition of stand up, because Postures provides its own version.]

Section 8 - Sequential Action Suppresses Room Description On Exit

The new describe room emerged into rule is listed instead of the describe room emerged into rule in the report exiting rules.

The new describe room stood up into rule is listed instead of the describe room stood up into rule in the report getting off rules.

This is the new describe room emerged into rule:
	if the sequential action option is not active:
		abide by the describe room emerged into rule.

This is the new describe room stood up into rule:
	if the sequential action option is not active:
		abide by the describe room stood up into rule.

Modified Exit ends here.

---- Documentation ----

Modified Exit makes a few minor tweaks to the way the Standard Rules handle exits and containers.

Most trivially, it adds the synonyms >EXIT THING and >GET OUT OF THING for the existing >GET OFF THING; and it allows the getting off action to apply to containers as well as to supporters. Thus >GET OUT OF BOAT should work as well as >GET OFF DAIS.

Second, it implements rules so that a player will automatically rise from an enterable portable object before attempting to take that object (as in the case of camp chairs, picnic blankets, and the like).

Third, it makes the player automatically rise from his seat, bed, or any other enterable thing that is not a vehicle, before attempting to go in a direction, except in the case that the chosen direction leads nowhere. In that case, the player does not bother to get up, but a sensible refusal message is printed instead. 

Another effect of the Modified Exit extension is that, if the player is not in a container of some kind, >OUT and its equivalents always try to go outside (rather than printing the "But you aren't in anything at the moment." message Inform uses as a default if there is no room outside from the current location). For instance, currently 

	The Chamber is a room. North of the Chamber is the Barracks. Instead of going outside in the Chamber, try going north.

will never cause the instead rule to fire, because the "convert exit into go out rule" in the standard rules will determine that there is no point in generating the GO OUT action in the first place, so the player would see

	Chamber

	>out
	But you aren't in anything at the moment.

With Modified Exit, we would instead get

	Chamber

	>out

	Barracks

There is one additional exception: Modified Exit does not allow "stand" or "stand up" to be converted to >GO OUTSIDE. Thus we get

	Chamber

	>out

	Barracks

but

	Chamber
	
	>stand up
	But you aren't in anything at the moment.

Finally, Modified Exit observes the "sequential action" option, meaning that if we would like the player's implicit actions to be described one after another as normal reports rather than as "(first getting off the divan)", we may use

	Use sequential action.

This corresponds to the behavior of the Locksmith extension and some other extensions by the same author. 

When sequential action is used, we suppress the "describe room stood up into" rule and the "describe room emerged into" rule, because otherwise the game prints two room descriptions whenever the player moves -- the description of the room that held the container, and the description of the new room to which he travels, like this:

	>w
	You get out of the box.

	Cell
	You can see a box (empty) here.

	Hallway
	This is the hall outside your Cell.

With the descriptions suppressed, we instead get

	>w
	You get out of the box.

	Hallway
	This is the hall outside your Cell.

If we do NOT want to suppress the first of the two room descriptions, we write

	The no room description on exit rule is not listed in any rulebook.

Version 4 of Modified Exit is identical to version 3 except that it is made compatible with Postures by Emily Short. If Postures is included, Modified Exit does not define a STAND UP action, but relies on the more sophisticated implementation included there.

Version 5 adds a tweak for compatibility with Rideable Vehicles by Graham Nelson, the removal of some procedural rules, and a minor fix to output. 

Example: * Simple Test - Test demonstrating the extension behavior.

	*: "Standing Test"

	Include Modified Exit by Emily Short.

	Use sequential action.

	The Chamber is a room. The Chamber contains an enterable supporter called a sofa. The pillow is an enterable supporter on the sofa. North of the Chamber is the Barracks.

	Clark is a man in the Chamber. A persuasion rule: persuasion succeeds.

	The beanbag chair is an enterable container in the Chamber.

	Instead of an actor going outside in the Chamber:
		try the person asked going north;
		rule succeeds. [The 'rule succeeds' bit tells Inform that this was a successful performance of going outside, rather than an unsuccessful one, so that telling Clark to go outside will generate the action (which it would anyway) but then not give the 'Clark can't do that' response afterward.]
 
	Test me with "test one / test two / test three".
	
	Test one with "sit on sofa / get up / sit on pillow / exit pillow / exit sofa / out / s / stand up / sit in chair / get off chair / get out of chair / sit on sofa / s / n / s ";

	Test two with "sit on chair / s / n / s / sit on chair / get chair / drop chair / sit on chair / get out of chair".

	Test three with "Clark, sit on chair / Clark, north / n / Clark, s / s / Clark, sit on sofa / Clark, north / n / Clark, s / s / Clark, sit on sofa / Clark, stand up / Clark, stand up".