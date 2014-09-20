Version 1/140823 of Suggested Actions by Leonardo Boselli begins here.

"After examining a thing, this extension lists the possible actions."

Chapter 1 - Proximity

The nearest-person is an object that varies. Nearest-person is nothing.
The nearest-supporter is an object that varies. The nearest-supporter is nothing.
The nearest-container is an object that varies. The nearest-container is nothing.

After examining a person (called the examined):
	if the examined is not the player and the examined is not an animal:
		now the nearest-person is the examined;
	continue the action.

After examining a supporter (called the examined):
	now the nearest-supporter is the examined;
	continue the action.

After examining a container (called the examined):
	now the nearest-container is the examined;
	continue the action.

Chapter 2 - Support for Suggesting

last action-noun is an object that varies. last action-noun is initially nothing.
last action-noun2 is an object that varies. last action-noun2 is initially nothing.

To set action-noun to (O - a thing):
	now last action-noun is O.
To set action-nouns to (O - a thing) and (O2 - a thing):
	set action-noun to O;
	now last action-noun2 is O2.
	
Before examining something (called the O):
	set action-noun to O;
	continue the action.
	
Before dropping something (called the O):
	set action-noun to O;
	continue the action.

Before taking something (called the O):
	set action-noun to O;
	continue the action.

Before wearing something (called the O):
	set action-noun to O;
	continue the action.

Before taking off something (called the O):
	set action-noun to O;
	continue the action.

Before inserting something (called the O) into something (called the C):
	set action-nouns to O and C;
	continue the action.
	
Before putting something (called the O) on something (called the S):
	set action-nouns to O and S;
	continue the action.
	
Before entering something (called the S):
	set action-noun to S;
	continue the action.

Before opening something (called the C):
	set action-noun to C;
	continue the action.

Before closing something (called the C):
	set action-noun to C;
	continue the action.

Before locking something (called the C) with something (called the K):
	set action-nouns to C and K;
	continue the action.

Before unlocking something (called the C) with something (called the K):
	set action-nouns to C and K;
	continue the action.

Before exiting:
	if the container exited from is not a room:
		set action-noun to the container exited from;
	continue the action.

Before getting off something (called the S):
	set action-noun to S;
	continue the action.

Before switching on something (called the D):
	set action-noun to D;
	continue the action.

Before switching off something (called the D):
	set action-noun to D;
	continue the action.

Before giving something (called the T) to something (called the P):
	set action-nouns to T and P;
	continue the action.

Every turn when last action-noun is not nothing and last action-noun is visible:
	try suggesting actions for last action-noun;
	if last action-noun2 is not nothing:
		if last action-noun2 is not last action-noun:
			try suggesting actions for last action-noun2;
		now last action-noun2 is nothing;
	now last action-noun is nothing;
	say "[run paragraph on]".

prev-single-action is a truth state that varies. prev-single-action is initially false.
prev-multi-action is a truth state that varies. prev-multi-action is initially false.
To say suggest single-action (txt - a text) on (O - an object):
	if prev-single-action is true:
		say " / ";
	otherwise if prev-multi-action is true:
		say "[line break]* ";
		now prev-single-action is true;
		now prev-multi-action is false;
	otherwise:
		say "* ";
		now prev-single-action is true;
	say "[setlink][txt][aslink][txt] [the O][endlink]".

To say suggest multi-action on (O - an object):
	if prev-single-action is true:
		say " [the O][line break]* ";
		now prev-single-action is false;
		now prev-multi-action is true;
	otherwise if prev-multi-action is true:
		say "[line break]* ";
	otherwise:
		say "* ";
		now prev-multi-action is true;

To say stop suggesting-actions on (O - an object):
	if prev-single-action is true:
		say " [the O]";
		now prev-single-action is false;
	otherwise if prev-multi-action is true:
		now prev-multi-action is false;
	otherwise:
		say "[run paragraph on]";

Suggesting actions for is an action applying to a thing.

Definition: a thing is takeable if it is not a person and it is not part of something and it is not fixed in place. 

Chapter 3 - Suggesting Actions

Show suggested actions is a truth state that varies. Show suggested actions is true.

Before suggesting actions for a thing (called the O):
	if show suggested actions is false:
		stop the action;
	if the O is not visible:
		stop the action;

Carry out suggesting actions for a door (called the O) (this is the suggesting door rule):
	let txt be an indexed text;
	if the O is open:
		now txt is "close" (A);
	otherwise:
		now txt is "open" (B);
	say "[suggest single-action txt on O]";
	now txt is "go" (C);
	say "[suggest single-action txt on O]";
	say "[run paragraph on]";
		
Carry out suggesting actions for a device (called the O) (this is the suggesting device rule):
	let txt be an indexed text;
	if the O is switched off:
		now txt is "switch on" (A);
	otherwise:
		now txt is "switch off" (B);
	say "[suggest single-action txt on O]";
	say "[run paragraph on]";

Carry out suggesting actions for a worn thing (called the O) (this is the suggesting worn thing rule):
	let txt be "take off" (A);
	say "[suggest single-action txt on O]";
	say "[run paragraph on]";

Carry out suggesting actions for a wearable carried thing (called the O) (this is the suggesting wearable thing rule):
	let txt be "wear" (A);
	say "[suggest single-action txt on O]";
	say "[run paragraph on]";

Carry out suggesting actions for a carried thing (called the O) (this is the suggesting carried thing rule):
	let txt be "drop" (A);
	say "[suggest single-action txt on O]";
	if the O is edible:
		now txt is "smell" (B);
		say "[suggest single-action txt on O]";
		now txt is "taste" (C);
		say "[suggest single-action txt on O]";
		now txt is "eat" (D);
		say "[suggest single-action txt on O]";
	if the nearest-supporter is not nothing and the nearest-supporter is visible:
		if the nearest-supporter is not the O:
			if the nearest-supporter is not the last action-noun or the nearest-supporter is not the last action-noun2:
				say "[suggest multi-action on O][setlink]put [the O] on [the nearest-supporter][endlink]" (E);
	if the nearest-container is not nothing and the nearest-container is visible:
		if the nearest-container is not the O:
			if bulk capacity of the nearest-container >= bulk of O:
				if the nearest-container is not the last action-noun or the nearest-container is not the last action-noun2:
					say "[suggest multi-action on O][setlink]put [the O] into [the nearest-container][endlink]" (F);
	if the nearest-person is not nothing and the nearest-person is visible:
		if the nearest-person is not the last action-noun and the nearest-person is not the last action-noun2:
			say "[suggest multi-action on O][setlink]give [the O] to [the nearest-person][endlink]" (G);
	say "[run paragraph on]";

Carry out suggesting actions for a thing (called the O) (this is the suggesting takeable rule):
	if O is not carried and O is not worn:
		if the O is takeable:
			let txt be "take" (A);
			say "[suggest single-action txt on O]";
			say "[run paragraph on]";
		
Carry out suggesting actions for a container (called the O) (this is the suggesting container rule):
	let txt be an indexed text;
	if the O is open:
		if the O is openable:
			now txt is "close" (A);
			say "[suggest single-action txt on O]";
		let Objs be the list of things carried by the player;
		if Objs is not empty:
			if O is listed in Objs:
				remove O from Objs;
			repeat with T running through Objs:
				if bulk capacity of O < bulk of T:
					remove T from Objs;
			if Objs is not empty:
				say "[suggest multi-action on O]put " (B);
				let CT be 0;
				repeat with T running through Objs:
					say "[setlink][the T][aslink]put [the T] into [the O][endlink]" (C);
					increment CT;
					unless CT is the number of entries in Objs:
						say " / ";
				say " into [the O]" (D);
	otherwise:
		now txt is "open" (E);
		say "[suggest single-action txt on O]";
	say "[run paragraph on]";

Carry out suggesting actions for a supporter (called the O) (this is the suggesting supporter rule):
	let Objs be the list of things carried by the player;
	if Objs is not empty:
		if O is listed in Objs:
			remove O from Objs;
		if Objs is not empty:
			say "[suggest multi-action on O]put " (A);
			let CT be 0;
			repeat with T running through Objs:
				say "[setlink][the T][aslink]put [the T] on [the O][endlink]" (B);
				increment CT;
				unless CT is the number of entries in Objs:
					say " / ";
			say " on [the O]" (C);
			say "[run paragraph on]";

Carry out suggesting actions for an enterable thing (called the O) (this is the suggesting enterable rule):
	if the O is a supporter:
		if the player is on the O:
			say "[suggest multi-action on O][setlink]get off[endlink]" (A);
		otherwise:
			say "[suggest multi-action on O][setlink]enter [the O][endlink]" (B);
	otherwise if the O is a container:
		if the player is in the O:
			say "[suggest multi-action on O][setlink]exit[endlink]" (C);
		otherwise:
			say "[suggest multi-action on O][setlink]enter [the O][endlink]" (D);
	say "[run paragraph on]";

Carry out suggesting actions for a person (called the O) (this is the suggesting person rule):
	if the O is not the player and the number of things carried by the player > 0:
		say "[suggest multi-action on O]give " (A);
		let CT be 0;
		repeat with T running through the things carried by the player:
			say "[setlink][the T][aslink]give [the T] to [the O][endlink]" (B);
			increment CT;
			unless CT is the number of things carried by the player:
				say " / ";
		say " to [the O]" (C);
		say "[run paragraph on]";

Section - Last Carry Out

Last carry out suggesting actions for a thing (called the O):
	say "[stop suggesting-actions on O]";


Chapter END

Suggested Actions ends here.

---- Documentation ----

After examining an object, it's written a list of the possible actions applicable to that object.
