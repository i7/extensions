Version 4.0.220524 of Ordinary Room Description by Emily Short begins here.

"An extension to go with Room Description Control, which emulates as closely as possible the behavior of Inform defaults, but allows the intervention of Room Description Control."

Include Room Description Control by Emily Short. 

Section 1 - Use writing a paragraph rules to create initial descriptions

Rule for writing a paragraph about an initially-describable thing (called target) (this is the listing initial appearances of things rule):
	now the target is mentioned;
	say "[initial appearance of the target][paragraph break]" (A).

Rule for writing a paragraph about an initially-describable supporter (called target) which supports something (this is the listing initial appearances of supporters rule):
	now the target is mentioned;
	say "[initial appearance of the target] [paragraph break]" (A);
	carry out the disclosing supported contents activity with the target.

Rule for writing a paragraph about something which is on a scenery supporter (called target) (this is the listing things on supporters rule):
	carry out the disclosing supported contents activity with the target.  

Rule for writing a paragraph about something which is on a supporter (called target) which supports the player (this is the listing things on the player's supporter rule):
	carry out the disclosing supported contents activity with the target. 

Disclosing supported contents of something is an activity.


Rule for disclosing supported contents of something (called the target) which encloses the player (this is the default shared contents description rule):
	say "On [the target] [we] [can] see " (A);
	list the contents of the target, giving brief inventory information, as a sentence, including contents, tersely, not listing concealed items;
	say ".[paragraph break]" (B). 

Rule for disclosing supported contents of something (called the target) (this is the default contents description rule):
	say "On [the target] " (A);
	list the contents of the target, giving brief inventory information, as a sentence, including contents, tersely, prefacing with is/are, not listing concealed items;
	say ".[paragraph break]" (B). 

Definition: a thing is initially-describable if it is initially-described and it is not handled.

Definition: a thing is initially-described if it provides the property initial appearance and its initial appearance is not "".

Section 2 - List Nondescript items
 
A last description-priority rule (this is the nondescript items preparation rule):
	now every thing is not marked for listing;
	repeat through the Table of Seen things:
		if the output subject entry is unmentioned:
			now the output subject entry is marked for listing;
	if a marked for listing thing is in the location:
		carry out the listing nondescript items activity with the location.

Rule for listing nondescript items of a room (called target) (this is the nondescript items listing rule): 
	say "[We] [can] [if something is mentioned]also [end if]see [a list of marked for listing things] here." (A)

Definition: a container is see-through if it is open or it is transparent.

After printing the name of a see-through container (called target) while listing nondescript items of a room (this is the disclose see-through container contents rule):
	if the target does not contain a marked for listing thing:
		make no decision;
	otherwise:
		say " (in which [is-are a list of marked for listing things in the target])" (A);

After printing the name of a supporter (called target) while listing nondescript items of a room (this is the disclose supporter contents rule):
	if the target does not support a marked for listing thing:
		make no decision;
	otherwise:
		say " (on which [is-are a list of marked for listing things on the target])" (A);

Section 3 - Entering and Leaving

A description-concealing rule when entering something (called target) (this is the silence unnecessary description while entering rule):
	repeat with item running through marked for listing things:
		if the item is not enclosed by the target:
			now the item is not marked for listing.

Ordinary Room Description ends here.

---- Documentation ----

The purpose of Ordinary Room Description is to replicate as closely as possible the default room description behavior of Inform while relying on the framework provided by Room Description Control.

This means that including Ordinary Room Description should, by itself, change nothing about the way descriptions are presented in our game. 

The advantage of including it is that we can then make use of Room Description Control to make slight tweaks to Inform's default behavior, as for instance by writing description-concealing rules or changing the priority of items so that they are listed in a different order from the usual within a room.

For more detail on these abilities, see the documentation for Room Description Control.

Changelog:

	Version 4.0.220524 updated to Inform v10.1 version numbering.  (Modified by Nathanael Nerode.)
	Version 4/210333 added the missing space in "On the dresser are[ ]a set of sheets."
	Version 4/210332 stopped trying to print initial descriptions when the initial description was "".
	Version 4/210322 is updated to work with version 14 of Room Description Control, which renamed the "output" column of the Table of Seen Things to "output subject" to reduce namespace conflicts with games.  (Modified by Nathanael Nerode.)

Example: * Quiet Shelf - A scenery supporter which does not list its contents in the room description. 

	*: "Quiet Shelf"

	Include Ordinary Room Description by Emily Short.

	Sample Chamber is a room. The shelf is scenery in Sample Chamber. On the shelf is a gold coin.

	A description-concealing rule:
		now every thing on the shelf is not marked for listing.

	Test me with "look / get coin / look / drop coin / look".
