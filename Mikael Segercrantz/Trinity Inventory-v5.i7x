Version 5.1 of Trinity Inventory by Mikael Segercrantz begins here.

"Provides a framework for listing inventories in natural sentences, akin to Infocom's game Trinity. Separates carried and worn objects, followed by objects that contains other objects. What's listed in the third section is customizable via a rulebook. Objects can be marked as not listed when carried or worn as well as marked as having their contents listed in the inventory when they're empty. This extension is based upon the extension Written Inventory by Jon Ingold."

[Updated for Inform 6L02 by Matt Weiner as of July 1, 2014. There should be no changes in performance, but you may wish to triple-check the behavior of the adaptive text.]

Chapter 1 - Modifications

Section 1a - Modifying the thing kind

A thing can be listed when worn or unlisted when worn. A thing is usually listed when worn.
A thing can be listed when carried or unlisted when carried. A thing is usually listed when carried.
A thing can be empty-listed or not empty-listed. A thing is usually not empty-listed.
A thing has a text called inventory listing. The inventory listing of a thing is usually "".


Section 1b - Removing standard rules from the carry out taking inventory rulebook

The print empty inventory rule is not listed in the carry out taking inventory rules. The print standard inventory rule is not listed in the carry out taking inventory rules.


Chapter 2 - Definitions and phrases

Section 2a - Encasement relation

Encasement relates a thing (called X) to a thing (called Y) when X is part of Y or X is held by Y or the holder of Y is X. The verb to be encased by implies the encasement relation.


Section 2b - Empty and non-empty definitions

Definition: a container is empty if the number of things in it is zero.
Definition: a player's holdall is empty if the number of things in it is zero.
Definition: a supporter is empty if the number of things on it is zero.
Definition: a thing is empty if the number of things encased by it is zero.

Definition: a thing is non-empty if it is not empty.


Section 2c - Specially-inventoried

Definition: a thing is specially-inventoried if the inventory listing of it is not "".
Definition: a thing is normally-inventoried if it is not specially-inventoried.


Chapter 3 - Visibility

Section 3a - Contents of a container are visible

To decide whether the contents of (item - a container) are visible:
	if the item is transparent:
		decide yes;
	otherwise:
		if the item is open, decide yes;
		otherwise decide no.


Section 3b- Contents of a player's holdall are visible

To decide whether the contents of (item - a player's holdall) are visible:
	if the item is transparent:
		decide yes;
	otherwise:
		if the item is open, decide yes;
		otherwise decide no.


Section 3c - Contents of a supporter are visible

To decide whether the contents of (item - a supporter) are visible:
	decide yes.


Section 3d - Contents of a thing are visible

To decide whether the contents of (item - a thing) are visible:
	decide yes.
		

Chapter 4 - Activities

Section 4a - The inventory listing the contents activity

Inventory listing the contents of something is an activity.


Section 4b - Marker for having used ", and"

TI first option anded is a number which varies. TI first option anded is 0.


Section 4c - Container inventory contents rule

Rule for inventory listing the contents of a container (called the item) (this is the container inventory contents rule):
	if TI first option anded is greater than 1:
		if a random chance of TI first option anded in 10 succeeds, now TI first option anded is 0;
	if TI first option anded is greater than 0, now TI first option anded is TI first option anded plus 1;
	if the number of listed when carried things encased by the item is at least one:
		if TI first option anded is 0:
			say ", and [we] [have]" (A);
			now TI first option anded is 1;
		otherwise:
			say ". [We] also [have]" (B);
		now content-listing is true;
		say " [list of listed when carried things in the item] in " (C);
		now content-listing is false;
		now articulating is true;
		if the item is specially-inventoried, say "[item]" (D);
		otherwise say "[the item]" (E);
		now articulating is false;
	otherwise:
		if TI first option anded is 0:
			now articulating is true;
			say ", and [if item is specially-inventoried][item][otherwise][the item][end if]" (F);
			now articulating is false;
			now TI first option anded is 1;
		otherwise:
			now articulating is true;
			if the item is specially-inventoried, say ". [Item]" (G);
			otherwise say ". [The item]" (H);
			now articulating is false;
		say " [regarding the item][are] empty" (I).


Section 4d - Player's holdall inventory contents rule

Rule for inventory listing the contents of a player's holdall (called the item) (this is the holdall inventory contents rule):
	if TI first option anded is greater than 1:
		if a random chance of TI first option anded in 10 succeeds, now TI first option anded is 0;
	if TI first option anded is greater than 0, now TI first option anded is TI first option anded plus 1;
	if the number of listed when carried things encased by the item is at least one:
		if TI first option anded is 0:
			say ", and [we] [have]" (A);
			now TI first option anded is 1;
		otherwise:
			say ". [We] also [have]" (B);
		now content-listing is true;
		say " [list of listed when carried things in the item] in " (C);
		now content-listing is false;
		now articulating is true;
		if the item is specially-inventoried, say "[item]" (D);
		otherwise say "[the item]" (E);
		now articulating is false;
	otherwise:
		if TI first option anded is 0:
			now articulating is true;
			say ", and [if item is specially-inventoried][item][otherwise][the item][end if]" (F);
			now articulating is false;
			now TI first option anded is 1;
		otherwise:
			now articulating is true;
			if the item is specially-inventoried, say ". [Item]" (G);
			otherwise say ". [The item]" (H);
			now articulating is false;
		say " [regarding the item][are] empty" (I).


Section 4e - Supporter inventory contents rule

Rule for inventory listing the contents of a supporter (called the item) (this is the supporter inventory contents rule):
	if TI first option anded is greater than 1:
		if a random chance of TI first option anded in 10 succeeds, now TI first option anded is 0;
	if TI first option anded is greater than 0, now TI first option anded is TI first option anded plus 1;
	if the number of listed when carried things encased by the item is at least one:
		if TI first option anded is 0:
			say ", and [we] [have]" (A);
			now TI first option anded is 1;
		otherwise:
			say ". [We] also [have]" (B);
		now content-listing is true;
		say " [list of listed when carried things on the item] on " (C);
		now content-listing is false;
		now articulating is true;
		if the item is specially-inventoried, say "[item]" (D);
		otherwise say "[the item]" (E);
		now articulating is false;
	otherwise:
		if TI first option anded is 0:
			now articulating is true;
			say ", and [if item is specially-inventoried][item][otherwise][the item][end if]" (F);
			now articulating is false;
			now TI first option anded is 1;
		otherwise:
			now articulating is true;
			if the item is specially-inventoried, say ". [Item]" (G);
			otherwise say ". [The item]" (H);
			now articulating is false;
		say " [regarding the item][have] nothing on [them]" (I).


Section 4f - Thing inventory contents rule

Rule for inventory listing the contents of a thing (called the item) (this is the thing inventory contents rule):
	do nothing.


Chapter 5 - Our own carry out taking inventory rules

Section 5a - Inventory intro rule

First carry out taking inventory (this is the inventory intro rule):
	say "[We]['re] [run paragraph on]" (A).


Section 5b - Empty inventory rule

Carry out taking inventory when the number of listed when carried things carried by the player is zero (this is the empty inventory rule):
	say "not holding anything[run paragraph on]" (A).


Section 5c - Non-empty inventory rule

Carry out taking inventory when the number of listed when carried things carried by the player is at least one (this is the non-empty inventory rule):
	say "holding [list of listed when carried things carried by the player][run paragraph on]" (A).


Section 5d - Empty wearing rule

Carry out taking inventory when the number of listed when worn things worn by the player is zero (this is the empty wearing rule):
	say "[run paragraph on]" (A).


Section 5e - Non-empty wearing rule

Carry out taking inventory when the number of listed when worn things worn by the player is at least one (this is the non-empty wearing rule):
	if the number of listed when carried things carried by the player is zero, say ", but [we]['re]" (A);
	if the number of listed when carried things carried by the player is at least one, say ". [We]['re]" (B);
	say " wearing [list of listed when worn things worn by the player][run paragraph on]" (C).


Section 5f - Set-up second-level inventory list rule

Carry out taking inventory (this is the set-up second-level inventory list rule):
	now everything is unmentioned;
	now the player is mentioned;
	now everything unlisted when carried is mentioned;
	now TI first option anded is 0;
	now articulating is false;
	now content-listing is false;
	if the number of listed when carried things carried by the player is at least one, now TI first option anded is 1;
	if the number of listed when carried things carried by the player is zero and the number of listed when worn things worn by the player is at least one, now TI first option anded is 1;
	if the number of listed when worn things worn by the player is zero, now TI first option anded is 0;
	if the number of listed when carried things carried by the player is at least one and the number of listed when worn things worn by the player is one, now TI first option anded is 0.


Section 5g - Deliver second-level inventory list rule

Carry out taking inventory (this is the deliver second-level inventory list rule):
	let item be a random unmentioned non-empty thing encased by something mentioned;
	if item is nothing, let item be a random unmentioned empty empty-listed thing encased by something mentioned;
	while item is a thing:
		if the contents of item are visible:
			if the number of listed when carried things encased by the item is at least one, carry out the inventory listing the contents activity with the item;
			if the number of listed when carried things encased by the item is zero and the item is empty-listed, carry out the inventory listing the contents activity with the item;
		now the item is mentioned;
		let item be a random unmentioned non-empty thing encased by something mentioned;
		if item is nothing, let item be a random unmentioned empty empty-listed thing encased by something mentioned;
	say ". [run paragraph on]" (A);

Section 5h - Inventory outro rule

Last carry out taking inventory (this is the inventory outro rule):
	say "[paragraph break]" (A).


Chapter 6 - Item-specific rules

Section 6a - Truth states

Articulating is a truth state that varies. Articulating is false.
Content-listing is a truth state that varies. Content-listing is false.


Section 6b - A specially-inventoried thing

Rule for printing the name of a specially-inventoried thing (called the target) while taking inventory (this is the inventory special rule):
	say "[inventory listing of target]" (A);
	if content-listing is true, now target is unmentioned.


Section 6c - Other things

Rule for printing the name of a normally-inventoried thing (called the target) while taking inventory and articulating is false (this is the inventory normal rule):
	say "[target with article]" (A);
	if content-listing is true, now target is unmentioned.


Chapter 7 - Articles

Section 7a - Article for target

To say (target - a thing) with article:
	now articulating is true;
	if the target is proper-named, say "[definite article for target]";
	otherwise say "[indefinite article for target]";
	now articulating is false.

Section 7b - Indefinite article for target

To say indefinite article for (target - a thing):
	(- print (a) {target}; -).


Section 7c - Definite article for target

To say definite article for (target - a thing):
	(- print (the) {target}; -).


Trinity Inventory ends here.

---- DOCUMENTATION ----

Chapter: Introduction

Provides a wide, prose-style, customisable inventory listing, of the following form:

	You're holding a briefcase and a lemon. You're wearing the old top hand, and you have a folder of papers in the briefcase. You also have a map of Slovakia in the folder of papers.

Section: Version history

	Version 1/071124 - A basic rewrite of Jon Ingold's Written Inventory extension, to modify the output to match more closely how the game Trinity (by Infocom) displays the inventory listing.

	Version 2/071217 - Added support for the inventory listing property to things. Also modified the way containment is shown, allowing for an occasional use of ", and " instead of ". ".

	Version 3/071223 - Separated the printing of articles out from the lists into separate rules, which improves the support for the inventory listing property, as well as brings better support of indefinite and definite articles. Fixed a bug with containers showing their contents, even when opaque and closed. Also fixed a bug with the player's holdall's contents not being listed, as well as a bug with contents of supporters not being listed. In addition, fixed a bug (partially introduced in Version 2/071217) regarding nested containers/supporters not listing their contents. Also found a bug which had existed already in Version 1/071124, where if the player wasn't wearing anything, it would write out two dots separated by a space; this has now been fixed.

	Version 4/080508 - Updated to fit version 5T18 of Inform 7, by adding the inventory listing property back to things. It also changes the syntax to use the new if-while-repeat syntax.

Chapter: Usage

Section: Customizing the contents of something

This works by printing objects directly carried and worn first (if there are any). It then runs an activity on any objects one level lower, called the "inventory listing the contents of" activity. By default this will provide the "In the briefcase..." style sentence above, but it can be customised:

	Rule for inventory listing the contents of the folder of papers: say ". The folder of papers contains [list of things in the folder of papers]";

Note the period at the start of the rule's output, and the lack of one at the end.

Section: Suppressing the contents of something

Should we want to suppress something's contents from an inventory listing, use a "do nothing rule":
	
	Rule for inventory listing the contents of the lemon: do nothing instead.

Note, that this will produce a list of the contents of the contents of the lemon (so it may append "In the pips of the lemon is the genetic material necessary for a new lemon tree"). To eradicate this, give the lemon's contents the "mentioned" property:

	Rule for inventory listing the contents of the lemon: 
		now everything enclosed by the lemon is mentioned; do nothing instead.

Section: Removing something from listing

To remove an object from being listed in the inventory is possible, separately for when it is carried and for when it is worn. To do this, you can use the phrases "unlisted when carried" and "unlisted when worn". If, at some point in the game, you need to change the item back to listed form, you can use "listed when carried" and "listed when worn" respectively. The defaults in both cases are for the item being listed.

	The player wears a vacation outfit. The vacation outfit is unlisted when worn.

Section: Adding certain containers or supporters as having their contents listed even if empty

In certain cases, it might be necessary to list a container's contents, even if that container is empty. Even this is possible using this extension: you can define the container as "empty-listed" or "not empty-listed" as required, with the default being "not empty-listed".

	A container called your pocket is a part of the vacation outfit. Your pocket is empty-listed.

Section: Parts of things

A final note: the extension automatically describes containers and supporters, and considers anything which contains a component part, but by default this third type of object prints nothing (since most of the time printing the parts of an object is unhelpful). This does provide an entry-point should you want an object to comment on its parts:

	Rule for inventory listing the contents of the ring-tailed lemur:
		say ". The lemur's extraordinary tail is coiled around your neck";

...and should any of those parts be containers or supporters themselves, they will be considered even if the part itself it ignored. (Therefore a player wearing a coat with a deep pocket should be told he is wearing the jacket, unless it is marked as not listed when worn, and the contents of the pocket will be listed, without being told separately that the pocket is part of the coat).

Section: The inventory listing property

As of Version 2/071217, this extension provides support for the "inventory listing" property. This property, described more closely in "Writing with Inform" in the section "Three descriptions of things", allows us to override the printed name of a thing when it is displayed in an inventory listing. This support has been improved with Version 3/071223, such that the "inventory listing" property can now contain a preceding article, or something working to that effect, as the article display mechanism has been separated from the list display to separate rules.

For example,

	A plain ring is in the Gazebo. The inventory listing of the plain ring is "that worthless old ring."

gives the following transcript

	Gazebo
	The gazebo stands slightly off to one edge of the lawn, almost in the center, but slightly closer to the edge the house is towards. A path leads north towards an intimidating forest and south towards the spooky old Victorian-style house you inherited from your great-aunt Mathilda.

	You can see a plain ring here.

	> TAKE RING
	Taken.

	> I
	You are holding that worthless old ring.

Chapter: Definitions

Note the extension provides one relation and two adjectives: "empty" and "non-empty" describe containers and supporters appropriately, and other things will be declared non-empty if and only if they have no component parts. (But a supporter with component parts may be empty if there is nothing on it). The relation is called "encasement" and describes direct enclosure. (That is, containment, carrying, wearing, or incorporation). 

Example: ** Trinity - Demonstrating the use of items not listed in the inventory and containers listed even if empty.

	*: "Trinity"
	
	Include Version 4 of Trinity Inventory by Mikael Segercrantz.
	
	Palace Gate is a room. "A tide of perambulators surges north along the crowded Broad Walk. Shaded glades stretch away to the northeast, and a hint of color marks the western edge of the Flower Walk."
	
	The player wears a vacation outfit. The vacation outfit is unlisted when worn.
	The player wears a wristwatch. Understand "watch" as the wristwatch.
	A container called your pocket is part of the vacation outfit. Your pocket is empty-listed.
	A credit card is in your pocket.
	A seven-sided coin is in your pocket. Understand "seven" and "sided" as the seven-sided coin.
	
	The seconds count is a number which varies. The seconds count is 0.
	
	The realistic time rule is listed instead of the advance time rule in the turn sequence rulebook.
	
	This is the realistic time rule:
		now the seconds count is the seconds count + 15;
		while the seconds count is at least 60:
			now the seconds count is the seconds count - 60;
			now the time of day is the time of day + 1 minute.
	
	The description of the wristwatch is "[if the hours part of the time of day is greater than 12][the hours part of the time of day - 12][otherwise][the hours part of the time of day][end if]:[if the minutes part of the time of day is less than 10]0[end if][the minutes part of the time of day]:[if seconds count is less than 10]0[end if][seconds count] [if the hours part of the time of day is at most 11]am[otherwise]pm[end if]."

	When play begins:
		say "Sharp words between the superpowers. Tanks in East Berlin. And now, reports the BBC, rumors of a satellite blackout. It's enough to spoil your continental breakfast.
	
	But the world will have to wait. This is the last day of your $599 London Getaway Package, and you're determined to soak up as much of that authentic English ambience as you can. So you've left the tour bus behind, ditched the camera and escaped to Hyde Park for a contemplative stroll through the Kensington Gardens."
	
	Test me with "i / x watch / take coin / i / x watch / take card / i".
