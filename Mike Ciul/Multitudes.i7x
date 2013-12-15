Version 1/110513 of Multitudes by Mike Ciul begins here.

"A way to implement collections of objects that can spread across multiple rooms, like stones in a pile of gravel. The player may interact with individual objects from the collection, and the extension will keep track of how many are in each room. Requires Conditional Backdrops by Mike Ciul."

Include Conditional Backdrops by Mike Ciul.

Volume - Multitudes and Specimens

Book - Kinds and Relations

Chapter - Multitudes

A multitude is a kind of conditional backdrop. A multitude is usually not scenery. A multitude has a text called the collection-name. The collection-name of a multitude is usually "collection". A multitude can be supporting or containing.

The specification of a multitude is "A backdrop-like presence representing a countable number of identical objects. Each multitude is associated with a thing, called the specimen, which represents an individual object from the collection."

To say on the (collection - a multitude):
	say "[if the collection is containing]in[otherwise]on[end if] the [collection-name of the collection]";

Chapter - Specimens

[Thanks to Victor Gjisbers for this suggestion]

Specimen collection relates various multitudes to one thing.

The verb to be a collection of implies the specimen collection relation.
The verb to be a specimen of implies the reversed specimen collection relation.

Definition: a thing is multitudinous rather than unique if it is a specimen of something.

To decide which object is the specimen of (the mess - a multitude):
	Let S be a random thing that is a specimen of the mess;
	if S is not a thing, say "*** Multitudes run-time problem: The [printed name of the mess] multitude does not have a specimen defined.";
	Decide on S.

To decide which object is the collection of (the piece - a thing):
	unless the piece is a specimen of something, decide on nothing;
	decide on a random thing that is a collection of the piece;

Chapter - The Table of Littering
	
Table of Littering
substance	field 	quantity
a multitude	a room	a number
with 100 blank rows.

Section - Checking the Table

Littering relates a multitude (called the mess) to a room (called the site) when the count of the mess in the site is at least 1. The verb to litter (he litters, they litter, he littered, it is littered, it is littering) implies the littering relation.

To decide what number is the count of (the mess - a multitude) in (the site - a room):
	unless there is a field of the site in Table of Littering, decide on 0;
	Repeat through Table of Littering:
		if field entry is the site and substance entry is the mess, decide on the quantity entry;
	decide on 0;
	
Section - Changing the Table

To change the number/count of (the mess - a multitude) in (the site - a room) to (N - a number), without updating:
	if N is effectively infinite, now N is effective infinity;
	Repeat through Table of Littering:
		if field entry is the site and substance entry is the mess:
			if N is less than 1:
				blank out the whole row;
				unless without updating, update backdrop positions;
				stop;
			now quantity entry is N;
			stop;
	if N is less than 1, stop;
	choose a blank row in Table of Littering;
	now the field entry is the site;
	now the substance entry is the mess;
	now the quantity entry is N;
	unless without updating, update backdrop positions;
	
Section - High-level Phrases and Adjectives
	
To decide what number is the present number of (item - a thing):
	Let M be the item;
	If M is multitudinous, now M is the collection of M;
	if M is not a multitude:
		if the item is in the location of the person asked, decide on 1;
		decide on 0;
	decide on the count of the M in the location of the person asked.

Definition: A thing is presently located rather than presently elsewhere if the present number of it is greater than 0.
Definition: A thing is presently singular rather than presently plural if the present number of it is 1.
Definition: A thing is presently unlimited rather than presently limited if the present number of it is effectively infinite.
	
To add some of/-- (mess - a multitude) to/in (the place - a room), without updating:
	Let N be the count of the mess in the place;
	if N is less than maximum multiplicity:
		if without updating, change the number of the mess in the place to N + 1, without updating;
		otherwise change the number of the mess in the place to N + 1.
		
To add some of/-- (mess - a multitude) to/in all/every (O - a description of objects):
	repeat with the place running through O:
		if the place is a room, add some of the mess to the place, without updating;
	update backdrop positions;
		
To remove some of/-- (mess - a multitude) from/in (the place - a room), without updating:
	Let N be the count of the mess in the place;
	if N is at least one and N is effectively finite:
		if without updating, change the number of the mess in the place to N - 1, without updating;
		otherwise change the number of the mess in the place to N - 1;
		
To remove some of/-- (mess - a multitude) from/in all/every (O - a description of objects):
	repeat with the place running through O:
		if the place is a room, remove some of the mess from the place, without updating;
	update backdrop positions;
	
To fill (the place - a room) with (mess - a multitude), without updating:
	if without updating, change the number of the mess in the place to effective infinity, without updating;
	otherwise change the number of the mess in the place to effective infinity.
				
Book - Quantities

Chapter - Effective Infinity

Use maximum multiplicity of at least 100 translates as (- Constant MAX_MULTIPLICITY = {N}; -).

[todo: allow quantities to be represented as numerals or spelled out, using use options]

To decide which number is maximum multiplicity: (- (MAX_MULTIPLICITY) -).

To decide which number is effective infinity: decide on maximum multiplicity plus one.

Definition: a number is effectively infinite rather than effectively finite if it is greater than maximum multiplicity.

Chapter - Printing an Approximate Number

Printing an approximate number of something is an activity on numbers.

To say (N - a number) as an approximate number:
	Carry out the printing an approximate number activity with N.

For printing an approximate number for a number (called N):
	[watch out for the 0 bug: if this activity is called with 0, N could have any value at all!]
	if N is effectively infinite:
		say "a great many";
	otherwise if N is zero:
		say "no";
	otherwise if N is one:
		say "a";
	otherwise if N is two:
		say "a couple";
	otherwise if N is three:
		say "a few";
	otherwise:
		say "several";

Chapter - Printing the Name of a Multitude

Section - Collectively-named

Definition: A thing is collectively-named if it is presently unlimited.

Section - The Indefinite Article

The indefinite article of a multitude is usually "[a quantity of the item described]";

To say a quantity of (item - a thing):
	carry out the printing a quantity activity with item.

Printing a quantity of something is an activity on objects.
	
For printing a quantity of something (called the collection):
	Let N be the present number of the collection;
	if the collection is collectively-named:
		say "a [collection-name of the collection] of";
	otherwise if N is 0:
		say "no";
	otherwise:
		carry out the printing an approximate number activity with N;
			
Section - The Name Itself

For printing the plural name of a multitudinous thing when the printed plural name of the item described is empty (this is the default pluralization of specimens rule): say "[item described]s";

For printing the name of a collectively-named multitude (called the mess):
	say "[printed name of the mess]";

For printing the name of a multitude (called the mess):
	if the present number of the mess is 1, say "[specimen of the mess]";
	otherwise carry out the printing the plural name activity with the specimen of the mess.
		
Volume - Change in Multitudes

Book - Updates

Backdrop condition for a multitude (called the mess) (this is the location of multitudes rule):
	If the mess is presently located, it is present;
		
Resetting the availability of something is an activity on objects.

For resetting the availability of something (called the piece):
	let M be the collection of the piece;
	if M is a multitude, now the piece is a part of M.

To update specimens:
	Repeat with the home running through multitudes:
		Let the piece be the specimen of the home;
		if the piece is nothing:
			next;
		if the piece is in a room:
			add some of the home to the location of the piece;
			carry out the resetting the availability activity with the piece;
		otherwise if the piece is off-stage:
			carry out the resetting the availability activity with the piece;

When play begins:
	Update specimens.	

[This rule should not be necessary with the standard rules, because dropping and eating are covered separately. But we don't want to surprise anyone who makes their own "move to the location" or "remove from play" rules.]

Every turn when a multitudinous thing is off-stage or a multitudinous thing is in a room (this is the return specimens to their multitudes rule):
	update specimens.
	
The return specimens to their multitudes rule is listed first in the every turn rulebook.

Book - Actions on Multitudes

[This is a bit risky, but it gets rid of annoying messages when multitudes are similarly named to their specimens]

For clarifying the parser's choice of a multitude (this is the don't mention that the multitude is different from its specimen rule):
	do nothing;

Chapter - Visibility of the Specimen

Definition: A multitude is concrete rather than abstract if the specimen of it is visible.
	
Chapter - Parsing

Section - Parsing a Multitude as its Specimen

Specimen presence relates a multitude (called the set) to a thing (called the element) when the element is a specimen of the set and the element is visible.

Understand "[something related by reversed specimen presence]" as a thing.

Definition: A thing is involved if it is the noun or it is the second noun.

Does the player mean doing something when a multitude is involved: It is unlikely.

Does the player mean doing something when something that is part of a multitude is involved: it is likely.

Section - Parsing an Absent Specimen as its Collection

Specimen absence relates a multitude (called the set) to a thing (called the element) when the set is abstract and the element is the specimen of the set.

Understand "[something related by specimen absence]" as a multitude when a visible multitude is abstract.

Chapter - Handling Actions

[
Section - Redirecting to the Specimen

Instead of an actor doing anything other than examining with a concrete multitude (called the mess) (this is the redirect most actions on a multitude to the specimen rule):
	now the noun is the specimen of the mess;
	try the current action;
]

Section - The Examining Action

Check examining a presently limited multitude (this is the count specimens instead of examining a limited multitude rule):
	say "You see [present number of the noun in words] ";
	carry out the printing the plural name activity with the specimen of the noun;
	say ".";
	stop the action;

Check examining a presently singular multitude (this is the convert examining to the specimen of a singular multitude rule):
	if the noun is concrete:
		convert to the examining action on the specimen of the noun;
	otherwise if the description of the specimen of the noun is not empty:
		say "[description of the specimen of the noun][paragraph break]";
		stop the action;

The convert examining to the specimen of a singular multitude rule is listed before the count specimens instead of examining a limited multitude rule in the check examining rulebook.

Chapter - Attempting to Take a Multitude
	
Check taking a multitude (this is the can't take a multitude when the specimen is not available rule):
	say "You can't take all of it. You'll need to retrieve [the specimen of the noun] from [the holder of the specimen of the noun].";
	stop the action.
	
Chapter - Attempting to Drop a Multitude

Check an actor dropping a multitude (this is the can't drop a multitude because it's never held rule):
	stop the action with library message dropping action number 2 for the noun.
	
Book - Actions on Specimens

Chapter - Taking

Section - Attempting to Take an Extra Specimen

Check taking a multitudinous thing when the player is the holder of the noun (this is the can't take an extra specimen rule):
	say "You don't need another [noun].";
	stop the action.
	
The can't take an extra specimen rule is listed before the can't take what's already taken rule in the check taking rulebook.
	
Section - Taking Component Parts of a Multitude

Check an actor taking (this is the can't take component parts of a non-multitude rule):
	if the noun is part of something (called the whole):
		if the whole is a multitude and the noun is the specimen of the whole:
			continue the action;
		stop the action with library message taking action number 7 for the whole.
		
The can't take component parts of a non-multitude rule is listed instead of the can't take component parts rule in the check taking rulebook.

The can't take component parts of a non-multitude rule is listed instead of the can't take component parts rule in the check removing it from rulebook.

[anxiously waiting for the "X rule doesn't apply when..." feature]

Section - Taking from

The taking action has an object called the previous holder (matched as "from").

Setting action variables for taking:
	now the previous holder is the holder of the noun;
	
Carry out an actor taking something from a multitude (this is the clean up the mess after taking a specimen rule):
	if the noun is the specimen of the previous holder, remove some of the previous holder from the location of the actor;
	
The clean up the mess after taking a specimen rule is listed after the standard taking rule in the carry out taking rulebook.

Section - Reporting taking from

Report an actor taking (this is the report taking under normal circumstances rule):
	if the actor is not the player:
		issue actor-based library message taking action number 16 for the noun;
	otherwise if the previous holder is not a multitude or the present number of the noun is less than one:
		issue library message taking action number 1 for the noun;

The report taking under normal circumstances rule is listed instead of the standard report taking rule in the report taking rulebook.

Report taking from a multitude when the present number of the noun is at least one (this is the report taking from a multitude rule):
	say "You take ";
	if the previous holder is presently singular:
		say "[a noun].";
	otherwise if the previous holder is collectively-named:
		say "[a noun] from [the previous holder].";
	otherwise:
		say "one of [the previous holder].";

Chapter - Dropping

Carry out an actor dropping a multitudinous thing (this is the don't leave specimens on the ground rule):
	update specimens;
	
The don't leave specimens on the ground rule is listed after the standard dropping rule in the carry out dropping rulebook.

Report an actor dropping (this is the report dropping under normal circumstances rule):
	if the actor is not the player:
		issue actor-based library message dropping action number 7 for the noun;
	otherwise 	if the noun is presently singular:
		issue library message dropping action number 4 for the noun;

The report dropping under normal circumstances rule is listed instead of the standard report dropping rule in the report dropping rulebook.

Report dropping something presently plural (this is the report dropping onto a multitude rule):
	say "You discard [the noun], and it joins the other one[if the present number of the noun is greater than two]s[end if][if the present number of the noun is effectively infinite and the noun is multitudinous] [on the collection of the noun][end if].";

Chapter - Eating

Carry out an actor eating a multitudinous thing (this is the there's more where that came from rule):
	update specimens;
	
The there's more where that came from rule is listed after the standard eating rule in the carry out eating rulebook.

Volume - Testing - Not for Release

Requesting the table of littering is an action out of world. Understand "littering" as requesting the table of littering.

Carry out requesting the table of littering:
	say "Table of Littering:[paragraph break]";
	Repeat through the Table of Littering:
		say "[quantity entry] [printed name of substance entry] in [field entry][line break]";

Multitudes ends here.

---- DOCUMENTATION ----

Multitudes is a way for one object to represent a large number of identical things. It's implemented using the "Conditional Backdrops" extension and a table. I haven't attempted to find out how well it does in terms of speed and memory, but I expect it to do well in cases where there are a few different kinds of multitudes, and not a large number of rooms. If you do have a lot of rooms, or you want the player to be able to work with more than one copy of a thing at a time, you might be better off creating a separate kind for each collection and instantiating a large number of copies of it.

Chapter: Multitudes and Specimens

Section: The Multitude Kind and the Multitudinous Adjective

There is one new kind in this extension, called a multitude. A multitude represents an abstract collection of things. It is a kind of conditional backdrop, and as with any backdrop, the player is not expected to interact with it much. The thing the player will usually be in contact with is called the specimen of a multitude:

	Repeat with M running through multitudes:
		say "[The specimen of M] is a concrete example of the abstract collection [M]."

A specimen can also refer to its associated multitude as the collection:

	Repeat with S running through things:
		if the collection of S is a multitude, say "[The collection of S] represents a number of [the S]."

A specimen is not a special kind - it can be any sort of thing. But there is an adjective by which we may identify specimens. A thing is "multitudinous" if it is the specimen of a multitude. If it isn't, it is "unique". So we could have written the previous statement like this:

	Repeat with S running through multitudinous things:
		say ...

Section: Creating Multitudes

Since a multitude is a Conditional Backdrop, which is not a sub-kind of Backdrop, it can't be placed like a normal backdrop or a thing. Instead, we have phrases we can use when play begins.

	Gravel is a multitude. When play begins: fill the quarry with gravel.

To set up the association between multitudes and specimens, we use the "specimen collection" relation.

	Gravel is a collection of the rock. [specimen collection relation]

or,

	The rock is a specimen of gravel. [reversed specimen collection relation]

That's pretty much all we need to do to get started. But there's a lot more going on under the hood...

Chapter: Presence and Quantities

Section: The Littering Relation

To check for the presence of a multitude, we can use the littering relation:

	If the Quarry is littered by gravel:
		say "Yep, it's a quarry."

	If gravel litters the quarry:
		say "Same thing."

Section: Concrete and Abstract

"Concrete" and "abstract" are adjectives that can be applied to a multitude to determine if the specimen is visible. They don't check whether the multitude is visible at all.

	If gravel is concrete, say "If you can see the gravel right now, you can see the rock."

	if gravel is abstract, say "Maybe you can see the gravel, but the rock's not around so you can't interact with it. It's possible that someone left the rock in a container or on a supporter in another room."

They are also used in a special Understand line, which makes use of the "specimen absence" relation. Specimen absence is a conditional relation that is true for a pair of multitude and specimen when the specimen is not visible. This allows the parser to pretend that the multitude is the specimen:

	Understand "[something related by specimen absence]" as a multitude when a visible multitude is abstract.

It turns out that checking this relation is extremely slow. Any command where the noun may be difficult to match could result in a noticeable parsing delay. The "when a visible multitude is abstract" condition is actually redundant in this line, but it prevents the parsing from taking place when it is certain that there will be no match. In future versions, there may be a means to turn off this feature completely.

Section: Counting

When a multitude is placed in a room using the normal declaration, the quantity in that room is considered to be unlimited.

	The gravel is in the Quarry.

But as the player interacts with the world, they may drop pieces here and there, and those pieces are countable. Every place where a multitude is found has a number representing the quantity. To find out how much of a multitude is in any room, we can use the "count of something in" phrase:

	say "The Quarry has [count of gravel in the Quarry] rocks in it."

Please note that no "COUNT" verb has been implemented.

Section: Effective Infinity

An unlimited quantity is represented by a constant we call "effective infinity". We can test if a number is at least as big as "effective infinity" using the "effectively infinite" phrase:

	if the present number of gravel is effectively infinite:
		say "There is as much gravel as you could possibly want here."

We can also check if something is "effectively finite," the opposite of effectively infinite.

Section: The Present Number

Usually we only want to know how much there is where we are. We can check the quantity of a multitude in the current location using a phrase to find the "present number:"

	If the present number of gravel is greater than 0:
		say "There is gravel here."

Present refers to "right here" as well as "right now." In this case, "here" is the location of the "person asked," so if another actor is performing an action, we'll get the count wherever they are. If our game has NPCs interacting with multitudes, though, it would be wise to keep in mind that a multitude is really only present in the location of the player, just like any other backdrop. 

The present number phrase can also be used indirectly, by giving it the specimen instead of the multitude:

	If the present number of the rock is greater than 2:
		say "There are more rocks here."

The present number phrase also applies to all other things, but in order to be consistent with the way multitudes behave, it only counts objects that are directly contained by the location. If an object is touchable but it's carried or it's in a container, the present number of it will be zero. In addition, if the player is trapped in a container, the present number of something in the room will be one, even though it is not touchable. This shouldn't come up very often, because the phrase is most often used for finding out if something is a multitude, and if it is, whether there's more than one of it. Which leads us to...

Section: Presently Located and Presently Elsewhere

Multitudes defines a few pairs of adjectives we can use to check on the present number of something. The first and most basic are "presently located" and "presently elsewhere." "Presently located" means  the present number is at least one, and "presently elsewhere" means the present number is zero. In the case of an ordinary thing, "presently located" is exactly the same as "in the location of the person asked," i.e. it means the item is directly contained by the location. In the case of a multitude, that means at least one specimen is theoretically available from the multitude, although we may be prevented from taking it if the specimen is contained by something far away.

	If the rock is presently located:
		say "All we know for sure is that the count of gravel in this room is at least one. The rock might be in a container in another room and we still would be prevented from taking it."

	If the rock is presently elsewhere:
		say "We might be able to take the rock, but we know that we will not be taking it from the gravel - it would be in some other container or supporter. We also know that if the rock is in this room, it is acting like a unique object and not like a collection of many things."

	if gravel is presently elsewhere:
		say "This is true in exactly the same set of cases as the previous statement."

Section: Presently Plural and Presently Singular

We can use these if all we need to check about a number is whether it's singular or plural. A thing is presently singular if the present number of it is one - otherwise it is presently plural. Notably, zero is plural. This shouldn't be an issue normally, because most of the time when we check the number of something, we already know it's there.

	say "There [if gravel is presently singular]is[otherwise]are[end if] [a gravel] here."

	Instead of smelling a presently plural thing:
		say "The smell is strong, since there are so many of them."

In the case of both "presently available" and "presently plural" we should remember that after taking something, the number in the multitude may be one less than it was when the action started. For example, if there were two rocks in the room and we took one, the gravel is presently singular at the end of the action.

Section: Presently Unlimited and Presently Limited

Two more adjectives allow us the convenience of checking whether the present number is effectively infinite or effectively finite:

	if gravel is presently unlimited, say "Usually we treat an unlimited supply of a multitude more like a separate thing."

	if gravel is presently limited, say "When the supply is not unlimited, it acts more like a collection of specimens."

Chapter: Moving and Changing Multitudes

Section: Phrases on Multitudes

There are a number of phrases available for changing the quantity of a multitude:

	Change the number of gravel in the quarry to effective infinity.
	Fill the quarry with gravel. (same effect as the previous sentence)

	Change the number of gravel in the road to 0.
	Empty the road of gravel. (same as the previous sentence)

	Add some gravel to the road. (increases the number of gravel by 1)

	Remove some gravel from the road. (decreases the number of gravel by 1)

	Add some gravel to every lighted room.

	Remove some gravel from every room in the Office Park.

Section: Removing Multitudes from Play

As mentioned before, the "Move the X backdrop to all Y" phrase won't work for multitudes because they're not real backdrops. In addition, manually moving multitudes or specifying their presence with "Backdrop Condition" rules may have unpredictable results because they could interfere with the "Location of Multitudes" rule. The above phrases should be used instead.

However, it should be safe to remove a backdrop with a "Backdrop Condition" rule even when its present number is not zero, as long as our own source doesn't depend on the present number to tell us whether a backdrop is really there:

	A backdrop condition for the Living Creatures when Creation is happening: it is absent.

Section: The Maximum Multiplicity Option

It turns out that effective infinity is really a finite number, and it can be set using an option:

	Use maximum multiplicity of at least 100.

"Maximum multiplicity" is a number one less than effective infinity. Multitudes will never allow a number to change from finite to infinite, or vice versa, unless we explicity tell it to do so. So if we say this:

	Use maximum multiplicity of at least 100.

	Change the number of gravel in the Quarry to maximum multiplicity.

	Add some gravel to the Quarry.

The Quarry will still have 100 pieces of gravel. But we can always do this:

	Fill the Quarry with gravel.

And now we'll have an unlimited supply.

Note for old-schoolers: Though it may be tempting to set maximum multiplicity to 69,105, that number is outside the range of numbers in the Z-machine, and it will wrap around to 3569.

Section: Actions on Specimens

Most actions on a multitude will be redirected to the specimen if it is visible. The exceptions follow the general philosophy of Multitudes, which is this:

An unlimited multitude acts more like an independent object.

A finite but plural multitude acts like a number of specimens.

A singular multitude should behave exactly like the specimen whenever possible.

To enable this, the examining action does different things depending on the number of a multitude. Examining an unlimited multitude prints its description. Examining a limited multitude prints the number of specimens. Examining a singular multitude is converted to examining the specimen, when the specimen is visible. Otherwise it prints the description of the specimen.

All of the actions defined in the Standard Rules should work properly with multitudes. The relevant ones are taking, dropping and eating. Dropping a specimen will cause it to be added to its collection in the current room. Eating a specimen (if you'll pardon the imagery) will cause it to return to the collection as well.

Some of the rules for taking and dropping have been split in two - one rule for "normal circumstances" and another dealing with multitudes. If our game or another extension we've included interferes with these rules, we may need to do some adjudication. These are the replaced rules:

	The can't take component parts of a non-multitude rule is listed instead of the can't take component parts rule in the check taking rulebook.

	The can't take component parts of a non-multitude rule is listed instead of the can't take component parts rule in the check removing it from rulebook.

	The report taking under normal circumstances rule is listed instead of the standard report taking rule in the report taking rulebook.

	The report dropping under normal circumstances rule is listed instead of the standard report dropping rule in the report dropping rulebook.

Future versions of I7 promise to provide a means to modify the condition of a rule. The author intends to do away with these rule-replacements when that becomes part of the language.

In addition, some housekeeping rules were added to make sure that specimens always return to their collections when they are left. If we create actions that might affect multitudes, we should make sure that the housekeeping is done in the same way.

Multitudes adds an action variable to the taking action, called the previous holder. We can now describe actions as "taking from X," which is useful to determine whether something has been removed from a multitude.

This rule makes sure that the number of a multitude is decremented after taking a specimen:

	The clean up the mess after taking a specimen rule is listed after the standard taking rule in the carry out taking rulebook.

This rule does the same for eating:
	
	The there's more where that came from rule is listed after the standard eating rule in the carry out eating rulebook.

And finally, a rule for dropping makes sure the multitude gets incremented and the specimen gets put away:

	The don't leave specimens on the ground rule is listed after the standard dropping rule in the carry out dropping rulebook.

There is also an every turn rule that acts as a catchall:
	The return specimens to their multitudes rule is listed first in the every turn rulebook.

Section: The Resetting the Availability Activity

All four of the rules listed above invoke the "resetting the availablity" activity, which makes sure that no specimens are left in a room or out of play. We should invoke this activity too if we want to remove a specimen from its present place or if we leave it in a room. We can also take advantage of this activity if we need to reset the state of the specimen:

	The mini-tupperware is a container. It is a specimen of the plastic pile. The mini-tupperware is openable and closed.

	Before resetting the availability of the mini-tupperware:
		repeat with item running through things in the mini-tupperware:
			let H be the holder of the mini-tupperware;
			if H is nothing, remove item from play;
			otherwise now item is in H;
		now the mini-tupperware is closed.

Chapter: Messages

It is possible to change all of the text that Multitudes may output. Here is a rundown of everything the extension might say:

Section: Responses to the Player's Actions

Since there is only one specimen of a multitude, we must prevent any attempt at having more than one of them in the world at a time. The player can't take a second specimen if they're already carrying one, and they also can't take a specimen if the existing one is in a container or on a supporter somewhere. These rules all stop actions that would normally be stopped anyway (taking something the player already has, taking something that is fixed in place), but the default messages would not make sense, so these were added.

The following rules will give the player the following messages:

	the count specimens instead of examining a limited multitude rule:  "You see 100 rocks.";

	the can't take an extra specimen rule: "You don't need another rock."

	the can't take a multitude when the specimen is not available rule: "You can't take all of it. You'll need to retrieve the rock from the bucket."

	the report taking from a multitude rule: "You take a rock from the gravel."

	the report dropping onto a multitude rule: "You discard the rock, and it joins the other ones on the pile.";

Section: The Collectively-named Adjective

A multitude is usually not scenery, so its name will be printed in room descriptions. (That means we can give in an initial appearance, too!) The name tends to change depending on the present quantity.

Sometimes a multitude behaves like a single object. Other times it behaves like a number of individual objects. We define the "collectively-named" adjective to help Multitudes figure out which way to treat it. By default, collectively-named is defined this way:

	Definition: a thing is collectively-named if it is presently unlimited.

In other words, if a multitude is effectively infinite, it behaves most like itself. At other times, it tries to get out of the way, masquerading as a number of copies of the specimen.

The collectively-named adjective can also be used as a hint about whether the verb in a sentence should be singular or plural:

	say "[A gravel] [if gravel is collectively-named]is[otherwise]are[end if] tumbling over the cliff."

yielding:

	A few rocks are tumbling over the cliff.

or:

	A pile of gravel is tumbling over the cliff.

With Emily Short's Plurality extension, we could add this:

	*: To decide whether (item - a multitude) acts plural:
		if the item is collectively-named or the present number of the item is 1:
			no;
		yes.

Section: The Printed Name of a Multitude and the Plural Name of a Specimen

Out of the box, the printed name of a multitude depends on whether it is collectively-named. If it is, its printed name will be given without any change. But if it's not, the name of its specimen will be given instead. That's fine if the quantity is one, but what if the specimen should be plural? It turns out that the "thing" kind doesn't have a printed plural name. If Multitudes finds that the specimen doesn't have a plural name, it will do the dumbest possible thing, and add an "s" to the end of the name. We can easily override that by setting the printed plural name of our specimen, though.

	The printed plural name of the rock is "stones".

Section: Numbers and the Indefinite Article of a Multitude

In addition to the name itself, Multitudes attempts to include a number in the indefinite article of a multitude. By default, numbers will be given vaguely, like "a couple" for two and "several" for four or more.

Section: The Collection-name Property of a Multitude

When a multitude is collectively-named, its indefinite article defaults to "a collection of." We can change this by setting the collection-name property of a multitude. For example, if we set the collection-name of gravel to "pile," an effectively infinite number of gravel will print as "a pile of gravel."

	The collection-name of the gravel is "pile".
 
Section: Printing a Quantity of Something

The printing of quantities is governed by a pair of activities. At the top level, printing the indefinite article of a multitude is performed by the "printing a quantity of" activity, an activity on objects which says "a [number] of". If the multitude is collectively-named, it makes use of the collection-name. But if it's not, it invokes the "printing an approximate number" activity with the present number of the multitude.

If we define our own quantity terms for a particular multitude, and they're expressed more as a collection than as a count, we'll want to keep the collectively-named adjective in sync with our wording:

	rule for printing a quantity of gravel when the present number of gravel is at least 4:
		if the present number of infestation is:
			-- 4: say "a collection of";
			-- 5: say "a small pile of";
			-- otherwise: say "a big pile of";

	Definition: the gravel is collectively-named if the present number of it is at least 4.

The collectively-named adjective will be checked by the report taking from a multitude rule:

	You can see a small pile of gravel here.

	> GET ROCK

	You take a rock from the pile.

As opposed to:

	You can see a few rocks here.

	> GET ROCK

	You take one of the rocks. 


Section: Printing an Approximate Number for a Number

If the multitude is not collectively-named, the printing a quantity of something activity goes on to perform the printing an approximate number activity, which is an activity on numbers. This is the one we might want to override if we'd prefer our numbers written a different way:

	rule for printing an approximate number for (N - a number):
		say "[N in words]";

	rule for printing an approximate number for (N - a number) when the writing style is totally wild:
		if N is 0:
			say "zilch";
		if N is 1:
			say "an all-a-lonely";
		if N is 2:
			say "a coupla";
		if N is at least 3 and N is less than 10:
			say "not a whole lotta";
		otherwise:
			say "a really freakin whole big bunch of"

Section: Printing Numbers

To take advantage of these activities in our own text, we simply write:

	"[a gravel]"

and it will output the indefinite article and the printed name, like so:

	a couple rocks

	a pile of gravel

Care should be taken to make sure that our multitude is improper-named. If we do this:

	gravel is a multitude.

we might end up leaving out the number altogether, and we'll end up with:

	rocks

	gravel

If we want to output just a number, we can make use of a couple of "to say" phrases. The "a quantity of something" phrase prints a number using the "printing a quantity of" activity:

	say "[a quantity of gravel]"

This would output something like:

	a couple

	a pile of

The "N as an approximate number" phrase uses the "printing an approximate number" activity:

	say "[3 as an approximate number]"

would output:
	
	a few
 
Section: Supporting vs Containing

The "report dropping onto a multitude" rule also uses a special prepositional phrase that refers to the collection-name of a collectively-named multitude. Because we don't want to assume which preposition to use, the multitude kind also has an either-or property called "supporting" or "containing." As we might expect, a "supporting" multitude will report that things were dropped "on the collection," while a "containing" multitude will describe them as "in the collection."

	The gravel is supporting.

	The crowd is containing.

Chapter: Memory Considerations

Quantities of each multitude are tracked using the Table of Littering. By default, it has 100 rows. As long as there are enough rows (and we're not doing something weird like creating rooms dynamically), there should be no problem. But if we don't allocate enough space for our game world, there will be unpredictable results. Here's how to make sure there is enough space:

The maximum number of rows used will always be (R * M) - the number of rooms times the number of multitudes. So if we have 100 rooms and 1 multitude, or 50 rooms and 2 multitudes, or 33 rooms and 3 multitudes, we're fine. But if we have more than that, we need to extend the table.

Suppose we have 30 rooms and 5 multitudes. 30 * 5 = 150, so we need 50 more rows in the table:

	Table of Littering (continued)
	with 50 blank rows.

That should do it.

Chapter: Testing

Multitudes has one testing command. "LITTERING" will cause the Table of Littering to be printed out.

Chapter: Notes

Thanks to Erik Temple, Victor Gijsbers, and Andrew Plotkin for some useful tips on creating this extension. Thanks to John Clemens for the original version of Conditional Backdrops. Matt Weiner and Wade Clarke pitched in to rewrite the rubric of this extension so people will understand what the heck it's for. Also thanks to Ron Newcomb, Emily Short, Jim Aikin and everyone on intfiction.org for their numerous answers to my needling questions, which have expanded my knowledge of Inform a thousandfold.

If you have feedback of any kind regarding this extension or any of my extensions, please contact me at captainmikee@yahoo.com.

Example: * The Quarry - A very simple example showing the basic functionality of Multitudes.

Note in particular that saying "Fill the quarry with gravel" creates an unlimited supply there, and "A rock is a thing in the road. The rock is a specimen of the gravel" causes the number of gravel in the road to be 1, without actually leaving the rock there.

The testing commands illustrate the wide range of text responses that are built in.

	*: "The Quarry"

	Include Multitudes by Mike Ciul

	The Quarry is a room. The Road is west of the quarry.

	The gravel is a multitude. The collection-name of the gravel is "pile". The gravel is supporting.

	When play begins: Fill the quarry with gravel.

	A rock is a thing in the road. The rock is a specimen of the gravel.

	The bucket is a container in the road.

	Test me with "x rock/x gravel/get rock/w/x rock/x gravel/drop rock/l/e/get rock/w/take rock/drop rock/x gravel/l/put rock in bucket/l/get bucket/l/drop bucket/e/get rock/get gravel/drop rock/x rock/w/get rock/drop rock/get rock/e/drop rock/w/get rock/e/drop rock/w/get rock/drop rock/e/get gravel"

Example: *** Feast - Demonstrates edible and animate multitudes.

	*: "Feast"

	Include Multitudes by Mike Ciul.

	Dining Hall is a room. Corridor is west of Dining Hall. Foyer is west of Corridor. Sun Room is north of Corridor. Restroom is south of Corridor. Auditorium is east of Dining Hall.

	A buffet is a multitude. For printing the name of a buffet when listing nondescript items: say "[if the buffet is presently plural]pastries and goodies[otherwise]pastry". The collection-name of a buffet is "fine array". A pastry is an edible thing. A pastry is a specimen of a buffet. The printed plural name of pastry is "pastries".

	An infestation is a multitude. A roach is an animal. A roach is a specimen of an infestation. The printed plural name of a roach is "roaches". Understand "roaches" and "swarm" as a roach.

	When play begins: Fill the Dining Hall with the buffet.

	After eating a pastry in Dining Hall:
		Say "As you stuff the last crumbs in your mouth, you see a hint of movement underneath one of the pastries here. A single cockroach emerges and crawls towards you!";
		Add some infestation to the Dining Hall.

	Definition: A room is infested rather than uninfested if it is littered by the infestation.
	Definition: A room is spreading if the count of the infestation in it is at least 3.

	Every turn:
		Repeat with the place running through infested rooms:
			if the place is the location:
				say "More roaches arrive.";
			Add some infestation to the place;
		Repeat with the place running through uninfested rooms adjacent to a spreading room:
			if the place is the location:
				Let the source be a random spreading room adjacent to the place;
				say "A roach crawls in from the [source].";
			Add some infestation to the place.

	For printing a quantity of the infestation:
		let N be the present number of the infestation;
		if N is less than 4, make no decision;
		If N is:
			-- 4: say "a swarm of";
			-- 5: say "a huge swarm of";
			-- otherwise: say "a tremendous swarm teeming with";

	test me with "get pastry/w/drop pastry/e/get pastry/w/drop pastry/e/get pastry/w/drop pastry/e/get pastry/w/drop pastry/l/eat pastry/g/e/eat pastry/l/w/n/l/l/l/l/l/l/eat roach/touch roach/roaches, hello/infestation, hello"

