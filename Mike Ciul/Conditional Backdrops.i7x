Version 3/111020 of Conditional Backdrops by Mike Ciul begins here.

"An extension to allow a single rulebook to determine the presence of multiple backdrops."

"updated from Version 1 by John Clemens"

Chapter - Floating Objects Template Code

Include (-
[ MoveFloatingObjects i k l m address flag;
	if (real_location == nothing) return;
 	objectloop (i) {
		if (ObjectFloats(i)) {
			if (ObjectFoundIn(i, real_location)) move i to real_location;
			else remove i;
		}
	}
];

[ ObjectFloats B address;
	return (B.&found_in ~= 0 && B hasnt absent);
];

[ ObjectFoundIn B R k l m address;
	if (~~ObjectFloats( B )) rfalse;
	address = B.&found_in;
	if (ZRegion(address-->0) == 2) {
		return (B.found_in(R) ~= 0);
	}
	else {
		k = B.#found_in;
		for (l=0 : l<k/WORDSIZE : l++) {
			m = address-->l;
			if (ZRegion(m) == 2 && m.call(R) ~= 0) rtrue;
			if (m == R || m in R) rtrue;
		}
	}
	rfalse;
];

[ MoveBackdrop bd D x address;
	if (~~(bd ofclass K7_backdrop)) return RunTimeProblem(RTP_BACKDROPONLY, bd);
	if (bd.#found_in > WORDSIZE) {
		address = bd.&found_in;
		address-->0 = D;
	} else bd.found_in = D;
	give bd ~absent;
	MoveFloatingObjects();
];
-)  instead of "Floating Objects" in "WorldModel.i6t"

Chapter - The Conditional Backdrop Kind

A conditional backdrop is a kind of thing.

A conditional backdrop is always fixed in place. A conditional backdrop is never portable. A conditional backdrop is usually scenery.

Include (- with found_in [ ; ProcessRulebook( (+ Backdrop condition rules +), self );  return (RulebookSucceeded()); ] -) when defining a conditional backdrop.

The specification of conditional backdrop is "Like a backdrop, but allows rules for determining presence or absence in a given room."

Chapter - The Backdrop Condition Rules

Backdrop condition rules are an object-based rulebook.

Backdrop condition rules have outcomes present (success), it is present (success), it is absent (failure) and absent (failure - the default).

Chapter - The Moving Floating Objects Activity

Moving floating objects is an activity.

For moving floating objects:
	update backdrop positions;

Carry out an actor going (this is the customizable moving floating objects rule):
	If the actor is the player, carry out the moving floating objects activity.

The customizable moving floating objects rule is listed instead of the move floating objects rule in the carry out going rulebook.

Conditional Backdrops ends here.

---- DOCUMENTATION ----

This is a simple extension to allow rules for determining whether a backdrop is present in a particular room. Although moving backdrops has been possible within I7 since version 5T18, it must be done with a description of objects that doesn't refer to the backdrop being moved (at least as of 6G60). This quirk prevented a single rulebook from controlling the location of multiple backdrops. Conditional Backdrops avoids the problem by creating a new kind governed by a special rulebook.

The "conditional backdrop" kind is governed by the "backdrop condition" rulebook. By default, a conditional backdrop will not be present in any room. This can be changed by adding backdrop condition rules for the object. Such a rule should conclude with the one of the phrases "it is present" or "it is absent" to make a decision.

A conditional backdrop is not a kind of backdrop, and so it can't be moved by the rules that apply only to backdrops. Only the "backdrop condition" rulebook may be used.

	The sky is a conditional backdrop.
	A backdrop condition for the sky: if the location is the yard, it is present.

Note: Backdrops are only automatically updated at certain times (such as when moving from one room to another). If a backdrop condition can change under other circumstances, this must be updated manually. This extension creates an activity to make this behavior more flexible. The "moving floating objects" activity invokes the Standard Rules phrase "update backdrop positions." We can carry out this activity whenever we move things around, and we can also add rules to the activity if we want to respond to changes in the location.

Conditional Backdrops was originally written by John Clemens before there was any provision for moving backdrops in I7, and this update merely allows the extension to work with version 6G60. If you have any questions, suggestions or bug reports, you may send them to Mike Ciul at captainmikee@yahoo.com.

Example: * Exclusion - Excluding one room in a region.

	*: "Exclusion"

	Include Conditional Backdrops by Mike Ciul.

	Living room is a room. Study is east of living room. Kitchen is south of living room. Yard is north of living room.
	The house is a region. Living room, study, and kitchen are in the house.

	The rug is a conditional backdrop. The rug is not scenery.

	Backdrop condition for the rug:
		if the location is the kitchen, it is absent;
		if the location is in the house, it is present.

	Test me with "e / w / s / n / n / s".

Example: ** Ostrich - Updating backdrop conditions manually.

	*: "Ostrich"

	Include Conditional Backdrops by Mike Ciul.

	The garden is a room. The path is east of the garden.

	The player carries the paper bag. The paper bag is wearable.

	The sky is a conditional backdrop.
	The grass is a conditional backdrop.

	Backdrop condition when the player wears the paper bag: it is absent.

	Backdrop condition for the sky: it is present.
	Backdrop condition for the grass: it is present.

	After wearing the paper bag:
		consider the move floating objects rule;
		say "You hide your head in the paper bag."

	After taking off the paper bag:
		consider the move floating objects rule;
		say "You bravely withdraw your head from the bag."

	Test me with "x sky / x grass / wear bag / x sky / x grass / remove bag / x sky / x grass".
