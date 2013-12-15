Version 3/121206 of Lost Items by Mike Ciul begins here.

"Prints a special message instead of 'You can't see any such thing' when certain items are out of scope, indicating that they have disappeared unexpectedly. Useful for flashbacks, theft, and NPCs who might sneak away."

Include Epistemology by Eric Eve.

Include Disambiguation Override by Mike Ciul.
Include Scope Caching by Mike Ciul.

Book 1 - Lost

Chapter 1 - Losable Things

A thing can be losable.

Chapter 2 - Definition of lost

[Definition: A thing is lost:
	follow did we lose rules for it;
	if the outcome of the rulebook is the we did outcome, decide yes;
	no;]

A thing can be lost.

Section 3 - The Determine Loss rulebook

Did we lose is an object-based rulebook. The did we lose rules have outcomes we didn't (failure), and we did (success).

[Weird things can happen if this rule is applied to a visible thing, but under normal circumstances that doesn't happen.]
Did we lose a known losable [not marked visible] thing (this is the default did we lose rule): we did.

The default did we lose rule is listed last in the did we lose rulebook.

Book 2 - Noticing what is lost

Part 1 - The Noticing Absence activity

Chapter 1 - Defining the rulebook

Noticing absence of something is an activity on objects.

Chapter 2 - A default rule (for use without Custom Library Messages by Ron Newcomb)

Section 1 - Acting Plural (for use without Plurality by Emily Short)

To decide whether (item - a thing) acts plural:
	Decide on whether or not item is plural-named.

Section 2 - The default notice absence rule

To say The (item - a thing) does-do: if the item acts plural, say "[The item] do"; otherwise say "[The item] does";

For noticing absence of something (called the missing item) (this is the default notice absence rule):
	say "[The missing item does-do]n't seem to be here anymore."

Chapter 4 - A default rule (for use with Custom Library Messages by Ron Newcomb)

For noticing absence of something (called the missing item) (this is the default notice absence rule):
	say "[The missing item] [aux][do*]n't seem to be here anymore."

Part 2 - When to notice absence

Chapter 1 - The Looking for Lost Items Flag

Looking for lost items is a truth state that varies.

To decide whether we are looking for lost items:
	Decide on whether or not looking for lost items is true.

To decide whether we are not looking for lost items:
	Decide on whether or not looking for lost items is false.

To start looking for lost items:
	Now looking for lost items is true.

To stop looking for lost items:
	Now looking for lost items is false.

Chapter 2 - Printing a parser error

[The parser's wn is a number that varies. The parser's wn variable translates into I6 as "wn".]

A command parser error can be relevant to lost items.

The can't see any such thing error is relevant to lost items.
The noun did not make sense in that context error is relevant to lost items.

Rule for printing a parser error (this is the check for lost items rule):
	if we are looking for lost items:
		[we added lost items to scope but didn't find any, so return to normal]
		stop looking for lost items;
		make no decision;
	unless the latest parser error is relevant to lost items, make no decision;
	Start looking for lost items.

The check for lost items rule is listed first in the for printing a parser error rules.

For reading a command when we are looking for lost items (this is the skip reading a command when re-parsing for lost items rule):
	[Normally there is no line break before an error message, but there is one before an action. The noticing absence activity usually happens during an action, but we want to make it look like an error]
	say run paragraph on.

Chapter 3 - Adding Lost Items to Scope

Section 1 - Determining Loss

[Running this after deciding the scope means that "did we lose" rules can depend on the action (I think). But it also means they can run multiple times for different actions, which might make it slow. Do we want a caching option so this doesn't run more than once per turn?

Maybe we can make use of the "scope decider" or "we are parsing for unseen/present objects"]

After deciding the scope of the player when we are looking for lost items:
	Now everything is not lost;
	Repeat with item running through marked invisible things:
		Follow the did we lose rules for item;
		if the outcome of the rulebook is the we did outcome:
			now item is lost;
			Place item in scope, but not its contents;

Section 2 - Keeping Lost Items Invisible

After caching scope when we are looking for lost items (this is the keep lost items invisible rule):
	now every lost thing is marked invisible;

The keep lost items invisible rule is listed last in the after caching scope rules.

Chapter 4 - Refusing to Disambiguate Lost Items

Before asking which do you mean when we are looking for lost items (this is the don't notice lost items if visible items match rule):
	[This will choose the first lost item in the match list if there are multiple lost items and no visible items]
	[We might want to do something more complicated in order to check whether there's more than one lost item]
	[and/or we might want to add noun/second noun awareness to DPMR or some other object-choosing scheme to make sure we're targeting the right noun phrase]
	Filter the match list for not lost objects, leaving at least one choice;
	If the number of objects in the match list is not 1, refuse disambiguation;

Chapter 5 - Processing Lost Items Within Actions

For clarifying the parser's choice of a lost thing when we are looking for lost items (this is the don't clarify lost things rule):
	Do nothing.

Before doing anything when we are looking for lost items (this is the notice absence of lost items rule):
	If the noun is lost:
		carry out the noticing absence activity with the noun;
		stop the action;
	if the second noun is lost:
		carry out the noticing absence activity with the second noun;
		stop the action;
	[can we ever get here? What would the consequences be?]
	[Yes we can, if the action takes multiple nouns! The consequences of stopping the search for lost items are that you might trigger the reaching into a room rules.]
	[Stop looking for lost items;]

The notice absence of lost items rule is listed first in the before rules.

A turn sequence rule when we are looking for lost items (this is the halt the turn sequence after noticing absence rule):
	Stop looking for lost items;
	rule fails.

The halt the turn sequence after noticing absence rule is listed before the every turn stage rule in the turn sequence rules.

[
Book 3 - Avoiding Extra Line Breaks When Trying an Action During a Parser Error

Converting parser error to action is a truth state that varies.

Before printing a parser error (this is the not yet converting parser error to action rule):
	Now converting parser error to action is false.

After printing a parser error when converting parser error to action is true (this is the prevent extra line breaks when converting parser error to action rule):
	say run paragraph on.

Before doing anything when the printing a parser error activity is going on (this is the now converting parser error to action rule):
	Now converting parser error to action is true.
]

Book 4 - Testing commands - not for release

[Additional epistemic status regarding losable and lost items]

Report requesting epistemic status of:
	if the noun is not losable, say "not ";
	say "losable / ";
	if the noun is not marked visible, say "not ";
	say "visible / ";
	if the noun is not lost, say "not ";
	say "lost";
	say ".";

Lost item debugging is a truth state that varies.

Enabling lost item debugging is an action out of world. Understand "lost" as enabling lost item debugging.

Carry out enabling lost item debugging: Now lost item debugging is true.

Report enabling lost item debugging: say "Lost item debugging is now on. You will see reports about which items are being checked for loss."

Did we lose something (called the item) when lost item debugging is true (this is the DWL debugging rule):
	say "Did we lose [the item]?";

The DWL debugging rule is listed first in the did we lose rulebook.

Disabling lost item debugging is an action out of world. Understand "lost off" as disabling lost item debugging.

Carry out disabling lost item debugging: Now lost item debugging is false.

Report disabling lost item debugging: say "Lost item debugging disabled."

Before noticing absence of something (called the item) when lost item debugging is true (this is the noticing absence debugging rule):
	say "Noticing absence of [the printed name of the item].";

Book 5 - Autoundo compatibility (for use with Autound for Object Response Tests by Mike Ciul)

Part 3 - Restoring Undo State in Whole Turns Modes (in place of Part - Restoring Undo State in Whole Turns Modes in Autoundo for Object Response Tests by Mike Ciul) 

[we need the Iterative Parsing extension to make this more general]

Before reading a command when we are not looking for lost items:
	if the current save-restore status is successful save, restore undo state.

Last before reading a command when we are not looking for lost items and the autoundo mode is freeze every turn:
	if the current save-restore status is failure to save:
		now the current save-restore status is the result of saving undo state;

After printing the player's obituary when the autoundo mode is freeze every turn:
	restore undo state.

Lost Items ends here.

---- DOCUMENTATION ----

Requires Epistemology by Eric Eve, Disambiguation Override by Mike Ciul, and Scope Caching by Mike Ciul. Intended to work optionally with Remembering by Aaron Reed and Custom Library Messages by Ron Newcomb. Not compatible with Disambiguation Control by Jon Ingold.

Mike Ciul's extensions can be found at http://www.eyeballsun.org/i/

Section: Losable and Lost

By default, objects in the story are not expected to move around without the player's knowledge. Lost Items creates a new property for things called "losable." Things are not losable by default.

	The gold watch is losable.

Just like Epistemology has a "familiar" property that we can set, and a "known" adjective that we can test, Lost Items gives things a "lost" adjective. A losable thing can't be lost unless it is known. But if a thing is both losable and known, it will be lost, and therefore subject to the Notice Absence rulebook.

	If the gold watch has been lost for exactly one turn:
		say "Your pockets feel a little lighter."

One thing that is different from Epistemology, however, is that we can rewrite the rules about when an item is lost. The rulebook is called "Did we lose," and it has outcomes "we did" and "we didn't.":

	Did we lose a losable thing carried by the urchin: we did.

	Did we lose something (this is the misplaced things don't count as lost rule): we didn't.

	The misplaced things don't count as lost rule is listed instead of the default did we lose rule in the did we lose rulebook.

Section: The Noticing Absence Activity

The heart of Lost Items is the "noticing absence" activity. When the parser is about to give the error "you can't see any such thing," the "check for lost items" rule intercepts it. If the player did mention a lost item in his or her command, the Noticing Absence activity is performed with the mentioned item.

If the player mentions more than one lost item, or uses a phrase that matches more than one lost item, only the first item checked will be used. It is assumed that there will only be a small number of losable items, so there shouldn't be many conflicts, but it is important to be aware of this possibility.

The "default notice absence rule" for noticing absence normally handles the Noticing Absence activity. It tells the player:

	(The missing item) doesn't seem to be here anymore.

To customize the message, we may replace the default notice absence rule, or add additional rules for different items and situations.

Section: Use with and without Custom Library Messages by Ron Newcomb

All messages printed by Lost Items should print in the correct person and tense when used with CLM. Since CLM makes use of Plurality by Emily Short, one phrase from Plurality is duplicated in the event that neither Plurality nor CLM is included in the source. No matter what other extensions are included, we will still be able to use this phrase:

	if the noun acts plural

Section: Use with Remembering by Aaron Reed

Remembering prints a special message when examining, taking, or dropping an object that has been seen already. When used with glulx, it tells the player where the PC last saw the object. We can make this work with all verbs using the following rule:

	*: For noticing absence of something (called item) (this is the remember lost items rule):
		Try remembering item;

	The remember lost items rule is listed instead of the default notice absence rule in the for noticing absence rulebook.

There's a little bit going on behind the scenes here, because normally an extra line break is printed when an action is tried during the printing a parser error activity. To make the line breaks work out as we'd expect, Lost Items implements a global variable (converting parser error to action) and a trio of rules (the "not yet converting parser error to action" rule in the before printing a parser error rulebook, the "now converting parser error to action" rule in the before rulebook, and the "prevent extra line breaks when converting parser error to action" rule in the after printing a parser error rulebook). It's unlikely that we'll need to interfere with these rules, but it's good to know that they exist.

Section: Testing Commands

There are no new testing commands for Lost Items, but it adds a line to the "epistat" output defined by Epsitemology. The new line tells whether the inspected object is losable, visible, or lost.

Section: Changes


Version 3:

121206: Updated dependencies in documentation.

121126: Fixed a bug in which the extension ended too early.

121126: Expanded Lost Items parsing to cover the "noun did not make sense in that context" error. Not sure if this will have unwanted consequences... definitely an experimental feature.

120927: Fixed a bug that arises when making an action that takes multiple nouns, and some of them are lost.

120903: Changed the approach from printing a message during a parser error to iterative parsing - before issuing the "you can't see any such thing error," the extension switches to "looking for lost items" mode and adds all lost things to scope before re-parsing the command.

Version 2:

Updated to work with Version 6 of Remembering by Aaron Reed. Actually what this means is that Version 2 does nothing at all with the Remembering verb. Aaron has already implemented all the functionality that was in Lost Items Version 1, although some of it only works with glulx.

Fixed a bug in interactions with Neutral Library Messages by Aaron Reed and possibly other code that depends on the parser's word-number variable.

Gave a name to the check for lost items rule.

Fixed a bug causing an extra line break when an action is triggered by the noticing absence activity.

Section: Credits

Thanks to Eric Eve, Aaron Reed and Ron Newcomb for the other extensions that make this work. Aaron Reed has been a big inspiration for making interactive fiction more user-friendly. Ron Newcomb and Brady Garvin provided some instrumental advice and bugfixes for version 2. Andrew Plotkin and Emily Short, as well as many others on intfiction.org, have always been forthcoming with advice and explanations for the more arcane aspects of Inform.

If you have questions, suggestions or bugfixes, please contact the author at captainmikee@yahoo.com.

Example: * The Artful Dodger - Handling stolen items.

	*: "The Artful Dodger"

	Include Lost Items by Mike Ciul.

	Saffron Hill is a room. An urchin is a man in Saffron Hill.

	The player carries a gold watch. The watch is losable.

	Every turn when the player carries the watch and the urchin is in the location:
		say "The boy bumps into you. 'Terribly sorry, sir, I must look where I'm going.' he says.";
		now the urchin carries the gold watch.
	
	Rule for deciding the concealed possessions of the urchin: yes.

	Test me with "x watch/g"

Example: *** Living in the Past - Using the Remembering extension and implementing flashbacks. This will tell the player where they last saw some things if it is compiled to glulx.

	*: "Living in the Past"

	Include Remembering by Aaron Reed.
	Include Lost Items by Mike Ciul.

	Chapter 1 - Things that come and go

	[We are going to have a flashback. Some things only belong to the present time, and other things only belong to the past. We want to keep track of that so we will have the appropriate "notice absence" message.]

	A thing can be past or present.

	The Street is a room. In the Street is a flower. The flower is losable and familiar.
	The Park is east of the Street.

	Amelia is a losable past woman.

	Chapter 2 - The Passage of Time

	[Let's demonstrate what happens when an object moves unexpectedly.]
	
	After looking for the first time:
		[TODO: why does this happen more than once?]
		say "You are startled by a strong gust of wind.";
		move the flower to the Park.

 	[The Remembering extension assumes that things stay where you put them, so it would, tell you that you saw it in the Street, even though you haven't seen it since it left the Park. Lost Items corrects for this situation by keeping track of where you saw losable things as well as people.]
	
	[Now let's demonstrate what happens when the time frame changes and lots of things move around:]
	
	Flashback is a scene. Flashback begins when smelling the flower in the Park. Flashback ends when kissing Amelia.

	Instead of smelling the flower in the Park:
		say "You breathe deep, and the fragrance takes you back to a happier time...";

	When flashback begins:
		remove the flower from play;
		Now Amelia is in the park;
		try looking;
	
	Instead of kissing Amelia:
		say "You hold her close, but before your lips touch, the vision fades...";
	
	When flashback ends:
		Remove Amelia from play;
		Now the flower is in the park;
		try looking;

	Chapter 3 - Reporting Lost and Missing Items

	Section 1 - Making sure something is truly lost

	[In this scenario, "lost" doesn't mean misplaced or stolen, it means it doesn't belong to the current time frame]

	Did we lose a present thing when flashback is not happening: we didn't.

	Did we lose a past thing when flashback is happening: we didn't.

	Section 1 - Customized messages for different time periods

	For noticing absence of a past thing (called memento) when flashback is not happening:
		say "Though your heart aches, you cannot bring [the memento] back.";

	For noticing absence of a present thing when flashback is happening:
		say "That is something from another time.";

	Section 3 - Noticing absence instead of remembering, sometimes

	[This demonstrates how we might sometimes change the behavior of remembering to mimic the "noticing absence" message, so for example "smell" and "examine" would have identical results.]

	Instead of remembering something lost (called item) when the noun is not a person:
		carry out the noticing absence activity with item;
	
	For printing the name of the location when remembering:
		say "right here"

	Chapter 4 - Testing

	test me with "x flower/smell flower/e/x amelia/smell flower/x flower/smell flower/kiss amelia/g/x amelia"
