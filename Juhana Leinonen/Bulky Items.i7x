Version 3 of Bulky Items by Juhana Leinonen begins here.

"Bulky items that can be carried only if the player is not carrying anything else."


Chapter Definitions

A thing can be bulky. A thing is usually not bulky.
A thing can be insubstantial. A thing is usually not insubstantial.

Definition: a thing is substantial if it is not insubstantial.


Chapter Taking bulky items

Before taking a bulky thing when the player is carrying something substantial and the player is not carrying the noun (this is the making room before taking a bulky item rule):
	say "(first dropping [the list of substantial things carried by the player] to make room)[command clarification break]" (A);
	repeat with x running through substantial things carried by the player:
		silently try dropping x.

Before taking something not bulky when the player is carrying a bulky thing (this is the dropping a bulky item before taking something else rule):
	say "(first dropping [the random bulky thing carried by the player] to make room)[command clarification break]" (A);
	repeat with x running through substantial things carried by the player:
		silently try dropping x.

To lift is a verb.

Report taking a bulky thing (this is the bulky item taken rule):
	say "[We] [lift] [the noun] to [our] arms." (A) instead.
	
Before of taking a bulky thing while multiple taking (this is the can't lift bulky things during take all rule):
	if the player is carrying a substantial thing:
		say "[Our] hands [are] already full." (A);
		stop the action.
	
The can't lift bulky things during take all rule is listed first in the before rules.
	

Chapter Multiple taking

To decide whether multiple taking: 
	if the player's command includes "all", decide yes; 
	if the player's command includes "everything", decide yes;
	decide no.

Does the player mean taking a bulky thing while multiple taking: it is very unlikely.



Bulky Items ends here.



---- DOCUMENTATION ----


Chapter: Usage

This extension introduces two new properties: "bulky" and "insubstantial". 

"Bulky" means the player can carry the item, but may not carry anything else at the same time. Picking up such item will make the player automatically drop everything else they are carrying. Picking up something when the player is carrying a bulky item will make them drop the bulky item first. 

"Insubstantial" means the thing is so small or carried in such location that it doesn't have to be dropped to carry a bulky item. Worn items are never dropped so they don't need to be marked insubstantial manually.

To illustrate, if the story contains the following items:

	The huge boulder is a thing. It is bulky.
	The pocket lint is a thing. It is insubstantial.
	The walking stick is a thing.

If the player carries the walking stick and the pocket lint when they pick up the boulder, they would drop the walking stick but not the pocket lint. Likewise they could pick up the pocket lint while carrying the boulder, but if they picked up the walking stick they would drop the boulder before doing so.

Note that by default inserting bulky items in containers (or on supporters) does not make the containers bulky; thus you could insert a boulder into a matchbox and circumvent the mechanics. See below for examples of containers that either change their bulkiness based on their contents or reject inserting bulky items.


By default, if the player is carrying something when they try to pick up a bulky item, they will automatically drop everything they have before picking it up. If we wish to block the action instead, the following code accomplishes this:
	
	The making room before taking a bulky item rule is not listed in any rulebook.
	The dropping a bulky item before taking something else rule is not listed in any rulebook.

	Instead of taking a bulky thing when the player is carrying something not bulky:
		say "[The noun] [are] too big to carry with your hands full."

	Instead of taking something when the player is carrying a bulky thing:
		say "You can't carry anything else as long as you're hauling [the random bulky thing carried by the player] with you."


Chapter: Release history

Version 3 (released April 2014) adds compatibility with the new release of Inform.

Version 2 fixed a bug where you would drop and lift again a bulky item you were already carrying when you tried to pick it up and added the example for a smarter TAKE ALL.


Example: * Going Camping - A small game where you have to carry all the items in the room in order to win.


The example includes three bulky items (a tent, a sleeping bag and an inflated raft), some matches that are so small they are not dropped when a bulky item is picked up and a backpack that can be worn so it won't be dropped. Bulky items can't be inserted into the backpack. Note that the inflated raft is a container that can hold bulky things, so the player can pick up the raft regardless of how many bulky items it holds.


	*: "Going Camping"

	Include Bulky Items by Juhana Leinonen

	Garage is a room. "This is the garage where you keep your wandering gear."

	The tent is in the garage. It is bulky.
	The sleeping bag is in the garage. It is bulky. 
	The map is in the garage.
	The compass is in the garage.
	The matches are in the garage. They are plural-named and insubstantial.

	Report taking the matches:
		say "You put the matches in your pocket." instead.

	A backpack is in the garage. It is a wearable container.

	After taking the backpack: try wearing the backpack.
	After taking off the backpack: try dropping the backpack.

	Instead of inserting something bulky into the backpack:
		say "[The noun] is just too big to fit inside the backpack."


	An deflated raft is in the garage. The description is "It's a self-inflating raft: Just push the button on its side to fill it with air."

	The button is a part of the deflated raft. The description is "It's a button reading 'push to inflate'".

	Instead of pushing the button:
		if the deflated raft is in the backpack:
			say "The backpack would probably explode if you inflated the raft inside it.";
		otherwise:
			say "The mechanism starts to emit a hissing sound and the raft is soon fully inflated.";
			remove the deflated raft from play;
			now the inflated raft is in the garage.
			
	The inflated raft is a bulky container.

	When play begins:
		say "Almost ready to go camping - all you need to do now is to pick up your gear from the garage."

	Before going or exiting:
		say "You can't leave until you are carrying with you everything you need!";
		stop the action.

	Every turn when the number of portable things in the garage is 1: [the player counts as one]
		say "Having everything you need for the camping trip with you, you're ready to set off!";
		end the story finally.
	
	Before inserting something into when the player is not carrying the noun:
		say "(first taking [the noun])[command clarification break]";
		silently try taking the noun.


	Test me with "get all/i/get tent/i/put map in backpack/push button/put tent in raft/put sleeping bag in raft/put compass in backpack/get backpack/get raft".


Example: ** Bulky Containers - Containers that become bulky when a bulky thing is inserted into them.

	*: "Bulky Containers"

	Include Bulky Items by Juhana Leinonen

	Living room is a room.

	The sack is a container. The player carries the sack.

	A television is in the living room. It is bulky.
	A coffee table is in the living room. It is bulky.
	A remote control is in the living room.
	A tv guide is in the living room.

	Check inserting something bulky into the sack when a bulky thing (called the previous occupant) is in the sack:
			say "There's no room for [the noun] anymore when [the previous occupant] [are] in the sack." instead.
	
	After inserting something bulky into the sack:
		now the sack is bulky;
		continue the action.
	
	After taking something:
		if the number of bulky things enclosed by the sack is 0:
			now the sack is not bulky;
		continue the action.


	Test me with "get remote/i/put remote in sack/get tv guide/i/get television/i/put television in sack/get coffee table/put coffee table in sack/get tv guide/i".


Example: ** Smarter TAKE ALL - Excluding bulky items from TAKE ALL and informing the player about it.

	*: "Smarter TAKE ALL"

	Include Bulky Items by Juhana Leinonen.

	Living room is a room. A television is in the living room. It is bulky. A remote control is in the living room.

	Rule for deciding whether all includes bulky things:
		it does not.

	Every turn when multiple taking:
		if a bulky handled thing is in the location and the current action is taking:
			say "(bulky items, i.e. [the list of bulky handled things in the location], were ignored)[line break]";

	Test me with "take all/take television/drop all/take all".