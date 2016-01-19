Version 1/160118 of Slotted Wearing and Wielding by Nels Olsen begins here.

"Requires armor, clothing and other worn and held items to occupy specific slots on the body."

Include Plurality by Emily Short.

Chapter - Slotted Wearing and Wielding

Section - Body Parts

A body-part is a kind of thing.  It is usually fixed in place.  Every body-part has text called slot-type.

A head-body-part is a kind of body-part.  The printed name is "head".  The slot-type is "head".
A head-body-part (called head) is part of every person.  The printed name is "head".

An eye-body-part is a kind of body-part.  The printed name is "eye".  The slot-type is "eye".
A right-eye-body-part is a kind of eye-body-part.  The printed name is "right eye".
A right-eye-body-part (called right eye) is part of every person.  The printed name is "right eye".
A left-eye-body-part is a kind of eye-body-part.  The printed name is "left eye".
A left-eye-body-part (called left eye) is part of every person.  The printed name is "left eye".

A neck-body-part is a kind of body-part.  The printed name is "neck".  The slot-type is "neck".
A neck-body-part (called neck) is part of every person.

A nape-body-part is a kind of body-part.  The printed name is "nape".  The slot-type is "nape".
A nape-body-part (called nape) is part of every person.  [This is where a cloak attaches to.]

A chest-body-part is a kind of body-part.  The printed name is "chest".  The slot-type is "chest".
A chest-body-part (called chest) is part of every person.

A back-body-part is a kind of body-part.  The printed name is "back".  The slot-type is "back".
A back-body-part (called back) is part of every person.

A hand-body-part is a kind of body-part.  The printed name is "hand".  The slot-type is "hand".
A right-hand-body-part is a kind of hand-body-part.  The printed name is "right hand".
A right-hand-body-part (called right hand) is part of every person.  The printed name is "right hand".
A left-hand-body-part is a kind of hand-body-part.  The printed name is "left hand".
A left-hand-body-part (called left hand) is part of every person.  The printed name is "left hand".

An arm-body-part is a kind of body-part.  The printed name is "arm".  The slot-type is "arm".
A right-arm-body-part is a kind of arm-body-part.  The printed name is "right arm".
A right-arm-body-part (called right arm) is part of every person.  The printed name is "right arm".
A left-arm-body-part is a kind of arm-body-part.  The printed name is "left arm".
A left-arm-body-part (called left arm) is part of every person.  The printed name is "left arm".

A finger-body-part is a kind of body-part.  The printed name is "finger".  The slot-type is "finger".
A ring-finger-body-part is a kind of body-part.  The printed name is "ring finger".
A right-ring-finger-body-part is a kind of ring-finger-body-part.  The printed name is "right ring finger".
A right-ring-finger-body-part (called right ring finger) is part of every person.  The printed name is "right ring finger".
A left-ring-finger-body-part is a kind of ring-finger-body-part.  The printed name is "left ring finger".
A left-ring-finger-body-part (called left ring finger) is part of every person.  The printed name is "left ring finger".

A waist-body-part is a kind of body-part.  The printed name is "waist".  The slot-type is "waist".
A waist-body-part (called waist) is part of every person.

A leg-body-part is a kind of body-part.  The printed name is "leg".  The slot-type is "leg".
A right-leg-body-part is a kind of leg-body-part.  The printed name is "right leg".
A right-leg-body-part (called right leg) is part of every person.  The printed name is "right leg".
A left-leg-body-part is a kind of leg-body-part.  The printed name is "left leg".
A left-leg-body-part (called left leg) is part of every person.  The printed name is "left leg".

A foot-body-part is a kind of body-part.  The printed name is "foot".  The slot-type is "foot".
A right-foot-body-part is a kind of foot-body-part.  The printed name is "right foot".
A right-foot-body-part (called right foot) is part of every person.  The printed name is "right foot".
A left-foot-body-part is a kind of foot-body-part.  The printed name is "left foot".
A left-foot-body-part (called left foot) is part of every person.  The printed name is "left foot".

Section - Wearable Slots

A wearable-slot-filler is a kind of thing.  It is usually portable.  It is usually wearable.
Every wearable-slot-filler has a list of text called required-wearable-slots.

Wearable-slot-filling relates one wearable-slot-filler (called the slot-filler) to various body-parts.
The verb to wearable-slot-fill means the wearable-slot-filling relation.
The verb to wearable-slot-receive means the reversed wearable-slot-filling relation. 

Definition: A thing (called the item) is slot-wearable if the item is wearable and the item is a wearable-slot-filler.
Definition: A thing (called the item) is slot-worn if the item is worn and the item wearable-slot-fills something.
Definition: A body-part is wearable-slot-filled if it wearable-slot-receives something.

Slot-wearing relates a person (called P) to a wearable-slot-filler (called the slot-filler) when the slot-filler wearable-slot-fills a body-part that is part of P.
The verb  to slot-wear means the slot-wearing relation.

[HACK] A container is a kind of wearable-slot-filler.  It is usually not wearable.
A wearable-slot-filling-container is a kind of container.  It is usually portable.  It is usually wearable.

Section - Wearing

Slot-wearing is an action applying to one thing.
Understand "wear [something]", "don [something]", "put on [something]" as slot-wearing.

Attempting-to-wear-as-part-of-slot-wearing is a truth state that varies.

Instead of an actor wearing something (this is the wearing redirects to slot-wearing as needed rule):
	let item be the noun;
	if attempting-to-wear-as-part-of-slot-wearing is true:
		continue the action;
	try the actor slot-wearing the item instead.

Check an actor slot-wearing something (this is the can't slot-wear what won't fit rule):
	let item be the noun;
	if the item is not slot-wearable:
		say "[The item] isn't wearable.";
		stop the action;
	if the actor is slot-wearing the item:
		say "[The actor] is already wearing [an item]!";
		stop the action;
	let matched-slots be a list of text;
	let available-body-parts be a list of body-parts;
	let actor-body-parts be the list of body-parts that are part of the actor;
	repeat with actor-body-part running through actor-body-parts:
		add actor-body-part to available-body-parts;
	let required-count be the number of entries in the required-wearable-slots of the item;
	repeat with required-wearable-slot running through the required-wearable-slots of the item:
		repeat with considered-body-part running through available-body-parts:
			if "[required-wearable-slot]" exactly matches the text "[slot-type of considered-body-part]":
				if considered-body-part does not wearable-slot-receive any thing:
					add required-wearable-slot to matched-slots;
					remove considered-body-part from available-body-parts;
					break;
		let matched-count be the number of entries in matched-slots;
		if matched-count is required-count:
			continue the action;
	stop the action.

Carry out an actor slot-wearing something (this is the slot-wearing fills slots rule):
	let item be the noun;
	now attempting-to-wear-as-part-of-slot-wearing is true;
	silently try the actor wearing the item;
	now attempting-to-wear-as-part-of-slot-wearing is false;
	if the actor does not wear the item:
		stop the action;
	let matched-slots be a list of text;
	let actor-body-parts be the list of body-parts that are part of the actor;
	let required-count be the number of entries in the required-wearable-slots of the item;
	repeat with required-wearable-slot running through the required-wearable-slots of the item:
		repeat with considered-body-part running through actor-body-parts:
			if "[required-wearable-slot]" exactly matches the text "[slot-type of considered-body-part]":
				if the considered-body-part is not wearable-slot-receiving any thing:
					add required-wearable-slot to matched-slots;
					now the considered-body-part wearable-slot-receives the item;
					break;
		let matched-count be the number of entries in matched-slots;
		if matched-count is required-count:
			continue the action;
	say "INTERNAL ERROR:  Somehow all of the required slots of [the item] were not filled while carrying out slot-wearing!";
	stop the action.

Report an actor slot-wearing something (this is the report slot-wearing rule):
	let item be the noun;
	let covered-body-part-names be a list of text;
	let covered-body-parts be the list of body-parts that are part of the actor wearable-slot-receiving the item;
	repeat with covered-body-part running through covered-body-parts:
		add "[covered-body-part]" to covered-body-part-names;
	say "(covering up [its-their of the actor] [covered-body-part-names])[command clarification break]";
	say "[if the actor is the player]Worn[else][The actor] puts on [the item][end if]."

Section - Taking Off

Slot-unwearing is an action applying to one thing.
Understand "unwear [something]", "doff [something]", "take off [something]" as slot-unwearing.

Attempting-to-take-off-as-part-of-slot-unwearing is a truth state that varies.
Uncovered-wearable-slot-names is a list of text that varies.

Instead an actor taking off something (this is the taking off redirects to slot-unwearing as needed rule):
	let item be the noun;
	if attempting-to-take-off-as-part-of-slot-unwearing is true:
		continue the action;
	try the actor slot-unwearing the item instead.

Check an actor slot-unwearing something (this is the can't slot-unwear what's not slot-worn rule):
	let item be the noun;
	if the actor is not slot-wearing the item:
		say "[The actor] isn't wearing [an item].";
		stop the action.

Carry out an actor slot-unwearing something (this is the slot-unwearing empties slots rule):
	let item be the noun;
	now attempting-to-take-off-as-part-of-slot-unwearing is true;
	silently try the actor taking off the item;
	now attempting-to-take-off-as-part-of-slot-unwearing is false;
	if the item is worn by the actor:
		stop the action;
	now uncovered-wearable-slot-names is { };
	repeat with considered-body-part running through every body-part that is part of the actor:
		if the considered-body-part is wearable-slot-receiving the item:
			now the considered-body-part does not wearable-slot-receive the item;
			add "[considered-body-part]" to uncovered-wearable-slot-names;
	continue the action.

Report an actor slot-unwearing something (this is the report slot-unwearing rule):
	let item be the noun;
	say "(uncovering [its-their of the actor] [uncovered-wearable-slot-names])[command clarification break]";
	say "[if the actor is the player]Taken off[else][The actor] takes off [the item][end if]."

Section - Wieldable Slots

A wieldable-slot-filler is a kind of thing.  It is usually portable.
Every wieldable-slot-filler has a list of text called required-wieldable-slots.

Wieldable-slot-filling relates one wieldable-slot-filler (called the slot-filler) to various body-parts.
The verb to wieldable-slot-fill means the wieldable-slot-filling relation.
The verb to wieldable-slot-receive means the reversed wieldable-slot-filling relation.

Definition: A thing (called the item) is slot-wieldable if the item is portable and the item is a wieldable-slot-filler.
Definition: A thing (called the item) is slot-wielded if the item is carried and the item wieldable-slot-fills something.
Definition: A body-part is wieldable-slot-filled if it wieldable-slot-receives something.

Slot-wielding relates a person (called P) to a wieldable-slot-filler (called the slot-filler) when the slot-filler wieldable-slot-fills a body-part that is part of P.
The verb to slot-wield means the slot-wielding relation.

Section - Wielding

Slot-wielding is an action applying to one thing.
Understand "wield [something]", "ready [something]" as slot-wielding.

Check an actor slot-wielding something (this is the this is the can't slot-wield what won't fit rule):
	let item be the noun;
	if the item is not slot-wieldable:
		say "[The item] isn't wieldable.";
		stop the action;
	if the actor is slot-wielding the item:
		say "[The actor] is already wielding [an item]!";
		stop the action;
	let matched-slots be a list of text;
	let available-body-parts be a list of body-parts;
	let actor-body-parts be the list of body-parts that are part of the actor;
	repeat with actor-body-part running through actor-body-parts:
		add actor-body-part to available-body-parts;
	let required-count be the number of entries in the required-wieldable-slots of the item;
	repeat with required-wieldable-slot running through the required-wieldable-slots of the item:
		repeat with considered-body-part running through available-body-parts:
			if "[required-wieldable-slot]" exactly matches the text "[slot-type of considered-body-part]":
				if considered-body-part does not wieldable-slot-receive any thing:
					add required-wieldable-slot to matched-slots;
					remove considered-body-part from available-body-parts;
					break;
		let matched-count be the number of entries in matched-slots;
		if matched-count is required-count:
			continue the action;
	say "[The actor] doesn't have the all of the required open slots to wield [an item].";
	stop the action.
		
Carry out an actor slot-wielding something  (this is the slot-wielding fills slots rule):
	let item be the noun;
	if the actor does not carry the item:
		silently try the actor taking the item;
		if the actor does not carry the item:
			stop the action;
	let matched-slots be a list of text;
	let actor-body-parts be the list of body-parts that are part of the actor;
	let required-count be the number of entries in the required-wieldable-slots of the item;
	repeat with required-wieldable-slot running through the required-wieldable-slots of the item:
		repeat with considered-body-part running through actor-body-parts:
			if "[required-wieldable-slot]" exactly matches the text "[slot-type of considered-body-part]":
				if the considered-body-part is not wieldable-slot-receiving any thing:
					add required-wieldable-slot to matched-slots;
					now the considered-body-part wieldable-slot-receives the item;
					break;
		let matched-count be the number of entries in matched-slots;
		if matched-count is required-count:
			continue the action;
	say "INTERNAL ERROR:  Somehow all of the required slots of [the item] were not filled while carrying out slot-wielding!";
	stop the action.

Report an actor slot-wielding something (this is the report slot-wielding rule):
	let item be the noun;
	let filled-body-part-names be a list of text;
	let filled-body-parts be the list of body-parts that are part of the actor wieldable-slot-receiving the item;
	repeat with filled-body-part running through filled-body-parts:
		add "[filled-body-part]" to filled-body-part-names;
	say "(filling [its-their of the actor] [filled-body-part-names])[command clarification break]";
	say "[if the actor is the player]Wielded[else][The actor] wields [the item][end if]."

Section - Unwielding

Slot-unwielding is an action applying to one thing.
Understand "unwield [something]", "unready [something]" as slot-unwielding.

Attempting-to-drop-as-part-of-slot-unwielding is a truth state that varies.
Emptied-wieldable-slot-names is a list of text that varies.

Instead of an actor dropping something  (this is the dropping redirects to slot-unwielding as needed rule):
	let item be the noun;
	if the actor is not slot-wielding the item:
		continue the action;
	if attempting-to-drop-as-part-of-slot-unwielding is true:
		continue the action;
	try the actor slot-unwielding the item instead.

Check an actor slot-unwielding something  (this is the can't slot-unwield what's not slot-wielded rule):
	let item be the noun;
	if the actor is not slot-wielding the item:
		say "[The actor] isn't wielding [an item].";
		stop the action.
		
Carry out an actor slot-unwielding something  (this is the slot-unwielding empties slots rule):
	let item be the noun;
	now attempting-to-drop-as-part-of-slot-unwielding is true;
	silently try the actor dropping the item;
	now attempting-to-drop-as-part-of-slot-unwielding is false;
	if the item is carried by the actor:
		stop the action;
	now emptied-wieldable-slot-names is { };
	repeat with considered-body-part running through every body-part that is part of the actor:
		if the considered-body-part is wieldable-slot-receiving the item:
			now the considered-body-part does not wieldable-slot-receive the item;
			add "[considered-body-part]" to emptied-wieldable-slot-names;
	continue the action.

Report an actor slot-unwielding something (this is the report slot-unwielding rule):
	let item be the noun;
	say "(emptying [its-their of the actor] [emptied-wieldable-slot-names])[command clarification break]";
	say "[if the actor is the player]Unwielded[else][The actor] unwields [the item][end if]."

Slotted Wearing and Wielding ends here.
