Version 1/140813 of Suggested Actions IT by Leonardo Boselli begins here.

"After examining a thing, this extension lists the possible actions. The commands are written in italian."

Chapter 1 - Proximity

The nearest-person is an object that varies. Nearest-person is usually nothing.
The nearest-supporter is an object that varies. The nearest-supporter is usually nothing.
The nearest-container is an object that varies. The nearest-container is usually nothing.

After examining a person (called the examined):
	now the nearest-person is the examined;
	continue the action.

After examining a supporter (called the examined):
	now the nearest-supporter is the examined;
	continue the action.

After examining a container (called the examined):
	now the nearest-container is the examined;
	continue the action.

Chapter 2 - Suggested Actions

last action-noun is an object that varies. last action-noun is initially nothing.
last action-noun2 is an object that varies. last acrion-noun2 is initially nothing.

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
	set action-noun to the container exited from;
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
	if last action-noun2 is not nothing:
		try suggesting actions for last action-noun2;
		now last action-noun2 is nothing;
	try suggesting actions for last action-noun;
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
Understand "suggerisci [something]" as suggesting actions for.

Definition: a thing is takeable if it is not a person and it is not part of something and it is not fixed in place. 

Carry out suggesting actions for a thing (called the O):
	let txt be an indexed text;
	if the O is a device:
		if the O is switched off:
			now txt is "accendi";
		otherwise:
			now txt is "spegni";
		say "[suggest single-action txt on O]";
	if the O is worn by the player:
		now txt is "togliti";
		say "[suggest single-action txt on O]";
	otherwise:
		if the O is wearable:
			now txt is "indossa";
			say "[suggest single-action txt on O]";
		if the O is carried by the player:
			now txt is "lascia";
			say "[suggest single-action txt on O]";
			if the O is edible:
				now txt is "annusa";
				say "[suggest single-action txt on O]";
				now txt is "assaggia";
				say "[suggest single-action txt on O]";
				now txt is "mangia";
				say "[suggest single-action txt on O]";
			if the nearest-supporter is not nothing and the nearest-supporter is visible:
				if the nearest-supporter is not the O:
					say "[suggest multi-action on O][setlink]metti [the O] [sup the nearest-supporter][endlink]";
			if the nearest-container is not nothing and the nearest-container is visible:
				if the nearest-container is not the O:
					if free capacity of the nearest-container >= bulk of O:
						say "[suggest multi-action on O][setlink]metti [the O] [inp the nearest-container][endlink]";
			if the nearest-person is not nothing and the nearest-person is visible:
				say "[suggest multi-action on O][setlink]dai [the O] [ap the nearest-person][endlink]";
		otherwise if the O is takeable:
			now txt is "prendi";
			say "[suggest single-action txt on O]";
		if the O is a container:
			if the O is open:
				if the O is openable:
					now txt is "chiudi";
					say "[suggest single-action txt on O]";
				let Objs be the list of things carried by the player;
				if Objs is not empty:
					if O is listed in Objs:
						remove O from Objs;
					repeat with T running through Objs:
						if free capacity of O < bulk of T:
							remove T from Objs;
					if Objs is not empty:
						say "[suggest multi-action on O]metti ";
						let CT be 0;
						repeat with T running through Objs:
							say "[setlink][the T][aslink]metti [the T] [inp the O][endlink]";
							increment CT;
							unless CT is the number of entries in Objs:
								say " / ";
						say " [inp the O]";
			otherwise:
				now txt is "apri";
				say "[suggest single-action txt on O]";
		otherwise if the O is a supporter:
			let Objs be the list of things carried by the player;
			if Objs is not empty:
				if O is listed in Objs:
					remove O from Objs;
				if Objs is not empty:
					say "[suggest multi-action on O]metti ";
					let CT be 0;
					repeat with T running through Objs:
						say "[setlink][the T][aslink]metti [the T] [sup the O][endlink]";
						increment CT;
						unless CT is the number of entries in Objs:
							say " / ";
					say " [sup the O]";
		if the O is enterable:
			if the O is a supporter:
				if the player is on the O:
					say "[suggest multi-action on O][setlink]scendi[endlink]";
				otherwise:
					say "[suggest multi-action on O][setlink]sali [sup the O][endlink]";
			otherwise if the O is a container:
				if the player is in the O:
					say "[suggest multi-action on O][setlink]esci[endlink]";
				otherwise:
					say "[suggest multi-action on O][setlink]entra [inp the O][endlink]";
		otherwise if the O is a person:
			if the number of things carried by the player > 0:
				say "[suggest multi-action on O]dai ";
				let CT be 0;
				repeat with T running through the things carried by the player:
					say "[setlink][the T][aslink]dai [the T] [ap the O][endlink]";
					increment CT;
					unless CT is the number of things carried by the player:
						say " / ";
				say " [ap the O]";
	say "[run paragraph on]";

Section E

Last carry out suggesting actions for a thing (called the O):
	say "[stop suggesting-actions on O]";

Chapter END

Suggested Actions IT ends here.

---- Documentation ----

Dopo aver esaminato un oggetto, vengono elencate le azioni che è possibile applicargli.
