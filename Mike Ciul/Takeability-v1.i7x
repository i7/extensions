Version 1.2 of Takeability by Mike Ciul begins here.

Book - Relations

Part - The Keeper - The Highest-Level Thing Inseparable From a Component

To decide which thing is the keeper of (the item - a thing):
	Decide on the keeper of the item from the person asked.
	
To decide which thing is the keeper of (the item - a thing) from (the dragger - a thing):
	let H be the not-counting-parts holder of the item;
	while H is a thing and H is not the dragger:
		if H is a person, decide on H;
		let H be the not-counting-parts holder of H;
	decide on the component parts core of the item.

Definition: A thing is self-contained rather than component if it is the keeper of it.

Part - The Not-Counting-Possessions Holder

To decide which object is the not-counting-possessions holder of (the item - a thing):
	Let H be the keeper of the item;
	if H is a person, decide on H;
	Decide on the not-counting-parts holder of H;

Part - Exclusion - Being Outside Something

Exclusion relates a thing (called the exterior) to a thing (called the interior) when the exterior is not the interior and the interior does not enclose the exterior.

The verb to be beyond implies the exclusion relation.

Part - Cohesion - Being Kept By the Same Thing

Cohesion relates a thing (called the first part) to a thing (called the second part) when the keeper of the first part is the keeper of the second part.

The verb to be stuck with implies the cohesion relation.

Part - Anchoring - Keeping a Component Immobile

Book - Determining Takeability

Part - Movability - Things that are Fixed in Place or Only Move Under Their Own Will

Movability is an object-based rulebook. The movability rules have outcomes it is movable (success) and it is immobile (failure).

Movability rule for scenery (this is the can't move scenery rule): it is immobile.
Movability rule for something fixed in place (this is the can't move something fixed in place rule): it is immobile.
Movability rule for the person asked (this is the actor can move rule): it is immobile.
Movability rule for a person (this is the can't move other people rule): it is immobile.
	
Definition: A thing (called the item) is anchoring:
	follow the movability rules for the item;
	if the outcome of the rulebook is the it is immobile outcome, yes;
	no.
	
Part - Takeability Rules

Takeability is an object-based rulebook. The takeability rules have outcomes it is takeable (success) and it is not takeable (failure).

Takeability rule for something anchoring (this is the couldn't take immobile things rule): It is not takeable.

Takeability rule for the person asked (this is the couldn't take yourself rule): It is not takeable.

Takeability rule for something stuck with something anchoring (this is the couldn't take things stuck with something immobile rule): It is not takeable.

Takeability rule for something that is part of something (this is the couldn't take component parts rule): it is not takeable.

Takeability rule for something held by the person asked (this is the couldn't take what you already have rule): it is not takeable.

Definition: A thing (called the item) is takeable:
	follow the takeability rules for the item;
	if the outcome of the rulebook is the it is not takeable outcome, no;
	yes.

Book - Action

Part - Unanchoring Something - Taking and Dropping Combined, Without Inventory Limits

Unanchoring is an action applying to one thing. Understand "drop [something not held]" as unanchoring.

The unanchoring action has an object called the previous holder.

Setting action variables for unanchoring: Now the previous holder is the holder of the noun.

Check an actor unanchoring (this is the can't unanchor yourself rule):
	If the noun is the actor:
		say "You can't remove yourself from what you're in. If you want to get out, try exiting or going in some direction.";
		stop the action.
		
The can't unanchor yourself rule is listed last in the check unanchoring rules.

The can't take other people rule is listed last in the check unanchoring rules.
The can't take component parts rule is listed last in the check unanchoring rules.
The can't take people's possessions rule is listed last in the check unanchoring rules.
The can't take items out of play rule is listed last in the check unanchoring rules.
The can't take what you're inside rule is listed last in the check unanchoring rules.
The can't take scenery rule is listed last in the check unanchoring rules.
The can only take things rule is listed last in the check unanchoring rules.
The can't take what's fixed in place rule is listed last in the check unanchoring rules.

Check an actor unanchoring (this is the don't unanchor what's already here rule):
	if the previous holder is the holder of the actor:
		say "[The noun] is already here.";
		stop the action.
		
The don't unanchor what's already here rule is listed last in the check unanchoring rules.
	
The can't drop clothes being worn rule is listed last in the check unanchoring rules.
The can't drop if this exceeds carrying capacity rule is listed last in the check unanchoring rules.

The standard dropping rule is listed last in the carry out unanchoring rules.

Report an actor unanchoring:
	if the previous holder is the actor:
		follow the standard report dropping rule;
		continue the action;
	if the previous holder is a room:
		say "You pick up [the noun] and leave it ";
	otherwise:
		say "You remove [the noun] from [the previous holder], leaving it ";
	Let H be the holder of the noun;
	if H is the location, say "here.";
	otherwise say "[if H is a container]in[otherwise if H is a supporter]on[otherwise]with[end if] [the H].";

Unanchoring it from is an action applying to two things. Understand "drop [something] from [something]" as unanchoring it from.

Check unanchoring something from something (this is the can't unanchor from what's not holding it rule):
	If the second noun does not enclose the noun:
		say "You can't remove [the noun] from [the second noun] because it's not holding it.";
		stop the action;
		
Check unanchoring something from something (this is the convert unanchoring it from to unanchoring rule):
	try unanchoring the noun;
	If the second noun encloses the noun, stop the action.

Takeability ends here.
