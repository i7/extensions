Version 5 of Object Response Tests by Juhana Leinonen begins here.

"A development tool for testing all actions on any given object - or one action on all objects - at once to see whether the game's responses are sensible."


Book 0 - Testing actor
	
The test-actor is a person that varies.

This is the set testing actor rule:
	now the test-actor is the player.

The set testing actor rule is listed last in the when play begins rulebook.


Book 1 - Testing rules

To announce tests for (_txt - indexed text):
	say "[italic type][_txt]:[roman type]".


This is the test taking rule:
	announce tests for "taking [the noun]";
	try the test-actor taking the noun.

This is the test eating rule:
	announce tests for "eating [the noun]";
	try the test-actor eating the noun.

This is the test dropping rule:
	announce tests for "dropping [the noun]";
	try the test-actor dropping the noun.

This is the test entering rule:
	announce tests for "entering [the noun]";
	try the test-actor entering the noun.

This is the test getting off rule:
	announce tests for "getting off [the noun]";
	try the test-actor getting off the noun.

This is the test examining rule:
	announce tests for "examining [the noun]";
	try the test-actor examining the noun.

This is the test looking under rule:
	announce tests for "looking under [the noun]";
	try the test-actor looking under the noun.

This is the test searching rule:
	announce tests for "searching [the noun]";
	try the test-actor searching the noun.

This is the test switching on rule:
	announce tests for "switching on [the noun]";
	try the test-actor switching on the noun.

This is the test switching off rule:
	announce tests for "switching off [the noun]";
	try the test-actor switching off the noun.

This is the test opening rule:
	announce tests for "opening [the noun]";
	try the test-actor opening the noun.

This is the test closing rule:
	announce tests for "closing [the noun]";
	try the test-actor closing the noun.

This is the test wearing rule:
	announce tests for "wearing [the noun]";
	try the test-actor wearing the noun.

This is the test taking off rule:
	announce tests for "taking off [the noun]";
	try the test-actor taking off the noun.

This is the test giving to rule:
	if the noun is a person:
		if the test-actor is not carrying something:
			say "[italic type](no inventory items; can't test giving to.)[roman type][line break]";
			rule succeeds;
		let give-object be a random thing carried by the test-actor;
		announce tests for "giving [the give-object] to [the noun]";
		try the test-actor giving the give-object to the noun;
		rule succeeds;
	if the test-actor is not carrying the noun:
		rule succeeds;
	if the test-actor can not see a person who is not the test-actor:
		say "[italic type](no persons in the location; can't test giving to.)[roman type][line break]";
		rule succeeds;
	let give-target be a random visible person who is not the test-actor; 
	announce tests for "giving [the noun] to [the give-target]";
	try the test-actor giving the noun to the give-target.

This is the test showing to rule:
	if the noun is a person:
		if the test-actor is not carrying something:
			say "[italic type](no inventory items; can't test showing to.)[roman type]";
			rule succeeds;
		let show-object be a random thing carried by the test-actor;
		announce tests for "showing [the show-object] to [the noun]";
		try the test-actor showing the show-object to the noun;
		rule succeeds; 	
	if the test-actor is not carrying the noun:
		rule succeeds;
	if the test-actor can not see a person who is not the test-actor:
		say "[italic type](no persons in the location; can't test showing to.)[roman type]";
		rule succeeds;
	let show-target be a random visible person who is not the test-actor in the location of the test-actor; 
	announce tests for "showing [the noun] to [the show-target]";
	try the test-actor showing the noun to the show-target.


This is the test throwing at rule:
	if the noun is a person:
		if the test-actor is not carrying something:
			say "[italic type](no inventory items; can't test throwing at.)[roman type]";
			rule succeeds;
		let throw-object be a random thing carried by the test-actor;
		announce tests for "throwing [the throw-object] at [the noun]";
		try the test-actor throwing the throw-object at the noun;
		rule succeeds;
 	if the test-actor is not carrying the noun:
		rule succeeds;
	if the test-actor can not see a person who is not the test-actor:
		say "[italic type](no persons in the location; can't test throwing at.)[roman type]";
		rule succeeds;
	let throw-target be a random visible person who is not the test-actor in the location of the test-actor; 
	announce tests for "throwing [the noun] at [the throw-target]";
	try the test-actor throwing the noun at the throw-target.

This is the test waking rule:
	if the noun is not a person:
		rule succeeds;
	announce tests for "waking [the noun]";
	try the test-actor waking the noun.

This is the test attacking rule:
	announce tests for "attacking [the noun]";
	try the test-actor attacking the noun.

This is the test kissing rule:
	if the noun is not a person:
		rule succeeds;
	announce tests for "kissing [the noun]";
	try the test-actor kissing the noun.

This is the test touching rule:
	announce tests for "touching [the noun]";
	try the test-actor touching the noun.

This is the test waving rule:
	announce tests for "waving [the noun]";
	try the test-actor waving the noun.

This is the test pulling rule:
	announce tests for "pulling [the noun]";
	try the test-actor pulling the noun.

This is the test pushing rule:
	announce tests for "pushing [the noun]";
	try the test-actor pushing the noun.

This is the test turning rule:
	announce tests for "turning [the noun]";
	try the test-actor turning the noun.

Definition: a direction is push-to-possible if the room it from the location of the test-actor is a room.

This is the test pushing to rule:
	let push-direction be a random push-to-possible direction;
	if the push-direction is nothing:
		say "[italic type](no exits; can't test pushing to.)[roman type][line break]";
		rule succeeds;
	announce tests for "pushing [the noun] to [push-direction]";
	try the test-actor pushing the noun to push-direction.

This is the test squeezing rule:
	announce tests for "squeezing [the noun]";
	try the test-actor squeezing the noun.

This is the test burning rule:
	announce tests for "burning [the noun]";
	try the test-actor burning the noun.

This is the test smelling rule:
	announce tests for "smelling [the noun]";
	try the test-actor smelling the noun.

This is the test listening to rule:
	announce tests for "listening to [the noun]";
	try the test-actor listening to the noun.

This is the test tasting rule:
	announce tests for "tasting [the noun]";
	try the test-actor tasting the noun.

This is the test cutting rule:
	announce tests for "cutting [the noun]";
	try the test-actor cutting the noun.

This is the test tying to rule:
	let tie-target be a random visible thing that is not the noun in the location of the test-actor;
	announce tests for "tying [the noun] to [the tie-target]";
	try the test-actor tying the noun to the tie-target;

This is the test drinking rule:
	announce tests for "drinking [the noun]";
	try the test-actor drinking the noun.

This is the test swinging rule:
	announce tests for "swinging [the noun]";
	try the test-actor swinging the noun.

This is the test rubbing rule:
	announce tests for "rubbing [the noun]";
	try the test-actor rubbing the noun.

This is the test setting to rule:
	announce tests for "setting [the noun] to 1";
	try the test-actor setting the noun to "1".

This is the test buying rule:
	announce tests for "buying [the noun]";
	try the test-actor buying the noun.

This is the test climbing rule:
	announce tests for "climbing [the noun]";
	try the test-actor climbing the noun.



Book 2 - Analyzing action 

Part 1 - Table of analyzing actions

Table of analyzing actions
topic	testing rule
"examining"	test examining rule
"looking under"	test looking under rule
"searching"	test searching rule
"listening to"	test listening to rule
"smelling"	test smelling rule
"attacking"	test attacking rule
"buying"	test buying rule
"climbing"	test climbing rule
"pulling"	test pulling rule
"pushing"	test pushing rule
"turning"	test turning rule
"pushing to"	test pushing to rule
"opening"	test opening rule
"entering"	test entering rule
"getting off"	test getting off rule
"closing"	test closing rule
"taking"	test taking rule
"switching on"	test switching on rule
"switching off"	test switching off rule
"wearing"	test wearing rule
"taking off"	test taking off rule
"throwing at"	test throwing at rule
"showing to"	test showing to rule
"giving to"	test giving to rule
"waking"	test waking rule
"kissing"	test kissing rule
"touching"	test touching rule
"rubbing"	test rubbing rule
"waving"	test waving rule
"squeezing"	test squeezing rule
"burning"	test burning rule
"cutting"	test cutting rule
"tying to"	test tying to rule
"swinging"	test swinging rule
"tasting"	test tasting rule
"drinking"	test drinking rule
"eating"	test eating rule
"dropping"	test dropping rule


Book 3 - Actions - Not for release

Object-analyzing is an action applying to one visible thing.

Understand "analyze [something]" as object-analyzing.
Understand "analyse [something]" as object-analyzing.


Carry out object-analyzing (this is the go through all analyzing rules rule):
	repeat with x running from 1 to the number of rows in the table of analyzing actions:
		if there is a testing rule in row x of the table of analyzing actions:
			follow the testing rule in row x of the table of analyzing actions.


All-encompassing analyzing is an action applying to nothing.

Carry out all-encompassing analyzing (this is the analyze everything in the location rule):
	repeat with x running through things enclosed by the location of the test-actor:
		if the test-actor can see x:
			try object-analyzing x.

Understand "analyze all" as all-encompassing analyzing.


Test-verb-trying is an action applying to one topic.

Understand "try [text]" as test-verb-trying.


Check test-verb-trying (this is the unknown verb test label rule):
	if the topic understood is not a topic listed in the Table of analyzing actions:
		say "Unknown verb test." instead.

Carry out test-verb-trying (this is the repeat an action with all objects rule):
	if the topic understood is a topic listed in the Table of analyzing actions:
		repeat with x running through things enclosed by the location of the test-actor:
			if the test-actor can see x:
				now the noun is x;
				follow the testing rule entry.


Test-actor changing is an action out of world applying to one visible thing.

Understand "actor is [any person]" as test-actor changing.

Carry out test-actor changing (this is the change testing actor rule):
	now the test-actor is the noun;
	say "Object Response Tests now uses [the noun] as the actor."


To remove the/-- (r - a rule) from object response tests:
	choose row with testing rule of r in Table of analyzing actions;
	blank out the whole row.



Object Response Tests ends here.

---- DOCUMENTATION ----

Chapter: Basic usage

Object Response Tests adds new testing commands ANALYZE and TRY. ANALYZE can be used to execute all available commands on a single object to see whether all the messages make sense. TRY is similar but in 'reverse': it tests one verb with all the objects currently in the location. The syntax is TRY <action>, for example TRY PUSHING.

There's also an ANALYZE ALL command for those who are feeling adventurous. It runs all the tests on all the objects currently in the location. It is mainly useful for locations with not that many objects to test.

For testing the default library actions, just include the extension in your project and both these commands will become available. Actions related to speaking with persons (saying, telling, asking) are excluded because of the various ways different games handle conversation.


Chapter: Removing and adding tests

Some games may disable some of the standard library actions. To avoid confusion it might be better to skip testing these actions altogether. 

To remove actions from the testing list, use:

	When play begins:
		remove the test burning rule from object response tests;
		remove the test pushing to rule from object response tests.

The rules have the same name as the action itself. The complete list can be seen in Book 2 of the extension's source text.

Of course, most games have custom actions that are not defined in the standard library. They can be included in the tests by making testing rules for them and adding those rules in the Table of analyzing actions. They will then be available for both ANALYZE and TRY commands.

	This is the test swimming in rule:
		announce tests for "swimming in [the noun]";
		try swimming in the noun.

	This is the test kicking rule:
		announce tests for "kicking [the noun]";
		try kicking the noun.

	Table of analyzing actions (continued)
	topic	testing rule
	"swimming in"	test swimming in rule
	"kicking"	test kicking rule


Chapter: Changing the actor

It is possible to run the tests as someone other than the player character. The test-actor variable holds the person who will be the actor in the tests. This can be changed during the game with the command ACTOR IS; for example ACTOR IS BOB. 

If the test-actor is not the player character any failed actions (that would usually give the "Bob is unable to do that" response) will not print anything at all. Also, the tests will not abide by the persuasion rules. In other words, if you run the tests as Bob, he will respond as if the game's source code read "try Bob shaving the yak", not as if the player had commanded BOB, SHAVE YAK which is by default blocked by the standard library ("Bob has better things to do.").

Note that the test-actor variable is set when the play begins. If the game changes the player character, the test-actor variable doesn't change automatically (that is, if you change the player character mid-game, the tests will be run as the original player character if not instructed otherwise).


Chapter: A note on releasing

The extension automatically disables itself in release versions. Any abovementioned modifications to its behavior should therefore be written in a section that has "Not for release" in the title (see chapter 2.9 "Material not for release" in the I7 manual) to avoid errors in compiling the final product.


Chapter: Version history

Section: Version 5 (2013-10-26)

	- added a way to disable tests without using the deprecated procedural rules.
	- changed deprecated "change" phrases to "now".
	- removed a duplicate test attacking rule from the test set.
	- renamed the test clothing rule to test wearing rule. Older versions of I7 choked on the word "wearing" in the rule but it seems to work in the latest.


Section: Version 4 (2010-06-14)

 	- changed 'say test announcements for' to 'announce tests for' so that the extension would be compatibile with Inform build 6E59.


Section: Version 3 (2009-09-23)

	- changed the hardcoded "[italic type]examining [the noun]: [roman type]" to a more flexible 'say test announcements for' phrase.
	- changed the extension so that the table of analyzing actions is not for debug builds only, so that you can have continuations of that table in the game code and you don't have to delete them or have them in one "not for release"-chapter when a release version is compiled.


Section: Version 2 (2008-12-23)

	- added the command TRY for testing a single verb with all items in the location (thanks to Taleslinger for the idea).

	- added the command ANALYZE ALL for running all tests on every single item in the location (thanks to Emily Short for the inspiration).

	- added the possibility to change the actor for the tests.

	 - changed the analyzing action's name to object-analyzing to avoid collisions with other code. It's likely that people might have an action called "analyzing" in their work.

	- added a not-for-release chapter heading to example B, just because that's what's recommended in the documentation (thanks to the person in ifMUD whose name I didn't write down and have blissfully forgotten).


Section: Version 1 (2008-11-18)

	- initial release


Example: * Camp Fire - An example of basic use of the extension.

	*: "Camp Fire"

	Include Object Response Tests by Juhana Leinonen.

	The Camp is a room.

	The bonfire is in the Camp. It is fixed in place. The description is "The bonfire is blazing hot."

	Alice is a woman in the Camp.

	Instead of touching the bonfire:
		say "Ow! You almost burn your fingers."

	Test me with "analyze bonfire/try touching/actor is Alice/analyze all".

Running the tests shows that at least the response to "taste bonfire" should be changed to something more appropriate.


Example: ** Porcelain - Skipping tests that destroy or alter the object.

The Ming vase will be broken if it's pushed or touched, so we'll remove those tests and replace them with new ones that do nothing if the target is the vase.


	"Porcelain"
	
	Include Object Response Tests by Juhana Leinonen.
	
	The Porcelain shop is a room.
	
	The Ming dynasty vase is in the porcelain shop. The description is "It looks very delicate and fragile."
	
	Instead of taking the Ming dynasty vase:
		say "You're afraid that you might drop it."
	
	After pushing or touching the Ming dynasty vase:
		say "Whoops! The vase falls off its pedestal and shatters into thousand pieces.";
		remove the Ming dynasty vase from play.
	
	Chapter Tests - Not for release
	
	When play begins (this is the remove destructive tests rule):
		remove the test pushing rule from object response tests;
		remove the test touching rule from object response tests.
		
	This is the new test pushing rule:
		if the noun is not the Ming dynasty vase:
			announce tests for "pushing [the noun]";
			try pushing the noun.
	
	This is the new test touching rule:
		if the noun is not the Ming dynasty vase:
			announce tests for "touching [the noun]";
			try touching the noun.
			
	Table of analyzing actions (continued)
	topic    	 testing rule
	"pushing"    	 new test pushing rule
	"touching"    	 new test touching rule
	
	Test me with "analyze vase/push vase".
	
