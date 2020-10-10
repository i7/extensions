Version 4 of Deluxe Doors by Emily Short begins here.

"Allows for doors that are implemented as having independent 'faces' -- to put a knocker on that can only be seen from on side, for instance, or to allow the player to lock one side with a key but the other with a latch. Also introduces a 'latched door' kind."

[Updated for adpative responses.]

Include Locksmith by Emily Short. 

To seem is a verb. To lock is a verb. To latch is a verb.

Section 1 - Door Unity

[Doors have reciprocal relations with their other halves]

Door-unity relates one door to another (called the reverse side). The verb to be a half-door of implies the door-unity relation. 

Definition: a door is halved if it is a half-door of something.

Carry out an actor opening a halved door (this is the complete openings rule):
	now the reverse side of the noun is open.
	
Carry out an actor closing a halved door (this is the complete closings rule):
	now the reverse side of the noun is closed.
	
Carry out an actor locking a halved door with something (this is the complete lockings rule):
	now the reverse side of the noun is locked.
	
Carry out an actor unlocking a halved door with something (this is the complete unlockings rule):
	now the reverse side of the noun is unlocked.

 
Section 2 - Latched doors

After deciding the scope of the player:
	repeat with questionable-door running through open doors in the location:
		if the questionable-door is a half-door of a door (called the far side):
			place the far side in scope.
	
Does the player mean doing something with a door which is a half-door of a door which is in the location (this is the don't mess with partial doors rule):
	it is very unlikely.
	
Rule for clarifying the parser's choice of an open door which is a half-door of something (this is the don't ask about partial doors rule): do nothing instead.
	
Setting action variables (this is the assign alternative door targets rule):
	if the noun is a door which is a half-door of a door (called real target):
		if real target is in the location of the actor:
			now the noun is real target; 
	if the second noun is a door which is a half-door of a door (called real target):
		if real target is in the location of the actor:
			now the second noun is real target; 

Rule for reaching inside a room when the particular possession is part of an open door (called target) (this is the arrange scope for partial doors rule):
	if the target is a half-door of a touchable door, allow access.

Section 3 - Safely Phrases

[These can be used to keep the locking and unlocking of halved doors in sync.]

To safely close (N - a door):
	now N is closed;
	if N is halved, now the reverse side of N is closed.

To safely lock (N - a door):
	now N is locked;
	if N is halved and the reverse side of N is lockable:
		now the reverse side of N is locked.

To safely open (N - a door):
	now N is open;
	if N is halved, now the reverse side of N is open.

To safely unlock (N - a door):
	now N is unlocked;
	if N is halved and the reverse side of N is lockable:
		now the reverse side of N is unlocked.

Section 4 - Latched Doors

A latched door is a kind of door. The specification of a latched door is "A door that can be locked by latch rather than with a key. (Usually best used as the 'inside' half of a two-sided door.)"

A door-latch is a kind of thing. Understand "latch" or "latches" as a door-latch. The printed name of a door-latch is "latch". One door-latch is part of every latched door. After examining a latched door, say "It appears to incorporate a latch." 

The specification of a door-latch is "A part of a latched door, which can be turned to lock or unlock that door."

Understand "latch [an unlocked latched door]" as locking keylessly.

Understand "latch [a locked latched door]" or "unlatch [a locked latched door]" as unlocking keylessly.

Section 5 - Keyless Latching and Unlatching

Check an actor unlocking keylessly a latched door (this is the redirect to latching rule):  
	if the noun is unlocked:
		if the actor is the player:
			say "[The noun] [are] already unlocked." (A) instead;
		stop the action; 
	abide by the latching-redirect rule.



Check an actor locking keylessly a latched door (this is the redirect to unlatching rule):
	if the noun is locked: 
		if the actor is the player:
			say "[The noun] [are] already secure." (A) instead;
		stop the action; 
	abide by the latching-redirect rule.

This is the latching-redirect rule:
	let target-latch be a random door-latch which is part of the noun;
	if the target-latch is a thing:
		try the person asked turning the target-latch instead;
	otherwise:
		if the person asked is the player:
			say "[regarding the noun]The latch [seem] to be missing from [the noun]." (A);
		stop the action.

Check an actor locking a latched door with something (this is the can't lock latched doors with keys rule): 
	if the player is the actor:
		say "[The noun] [lock] [if the noun is a half-door of a door which is not a latched door]from this side [end if]with a latch, not with a key." (A) instead;
	otherwise:
		stop the action.

	

Check an actor unlocking a latched door with something (this is the can't unlock latched doors with keys rule):
	if the player is the actor:
		say "[The noun] [lock] [if the noun is a half-door of a door which is not a latched door]from this side [end if]with a latch, not with a key." (A) instead;
	otherwise:
		stop the action.


Carry out an actor turning a door-latch which is part of something (called the parent door) (this is the carry out turning door-latches rule): 
	if the parent door is locked:
		safely unlock parent door;
	otherwise:
		safely lock parent door. 
		
Report an actor turning a door-latch which is part of something (called the parent door) (this is the default report unlatching rule):
	say "[The actor] [if the parent door is locked][otherwise]un[end if][latch] [the parent door]." (A) instead.

Deluxe Doors ends here.

---- Documentation ----

Deluxe Doors allows for doors to have two sides, so that they can be unlocked differently from different directions and also so that they can have things visible on one face but not on the other. It also allows for doors to be latched rather than locked and unlocked with keys.

Deluxe Doors requires Plurality and Locksmith by Emily Short.

Chapter: Two One-sided Doors

Section: Setting Up

To set up a pair of doors, we use the "door-unity" relation, expressed with the phrase "is a half-door of". Thus

	Porch is a room. The house door is south of Porch. It is a lockable door. Through the house door is the Living Room. 

	The porch door is north of Living Room. Through the porch door is the Porch. The porch door is a door. The porch door is a half-door of the house door. 

creates a pair of one-way doors that are now understood to be linked. We can also use the adjective "a halved door" to refer to doors that are only half of a larger entity, and "the reverse side of (a given door)" to refer to that door's other half.

This now means that objects can be added to one side of a door, as in

	A brass knocker is part of the house door.

with some special implications: it will be visible and touchable when the player is on the "house door" side -- that is, standing on the Porch looking in. That's the easy part. The trickier part is that it will also be visible and touchable when the player is in the Living Room, if the porch door/house door combo is open. 

Section: A Warning

This does require a little authorial self-discipline. If you have a place in your code where you say

	now the gilded door is open;

that doesn't ensure that its other half is open. Instead, Deluxe Doors provides a couple of phrases to use instead:

	safely lock the gilded door
	safely open the gilded door
	safely close the gilded door
	safely unlock the gilded door

Using these will guarantee that both halves of a door will be maintained in their proper configuration.

Chapter: Latched Doors

Section: Setting Up

The latched door features here can be used without the Deluxe Doors at all, if we like. A latched door is defined to be one that has a latch and thus can be opened without a key (and will in fact give an error message if the player tries to use a key instead). We can just write

	The porch door is a latched door.

to invoke this; every latched door will automatically have one door-latch object assigned to it.

Example: ** Denise - We have a door that can be locked on one side and latched on the other; and another character we can annoy by endless knocking.

	*: Include Deluxe Doors by Emily Short. 

	Porch is a room. "Here is your front porch, relatively tranquil because it is not your living room. Being inside has become more and more of a torture every day of late."

	The house door is south of Porch. It is a lockable door. Through the house door is the Living Room. The initial appearance of the house door is "The door into the house [if open]stands open[otherwise]is firmly shut[end if]."

	The player carries a silver key. The silver key unlocks the house door.

	Instead of going inside in the Porch, try going south. Instead of exiting in the Living Room, try going north.

	The porch door is north of Living Room. "The door to the porch [if open]is thrown invitingly wide[otherwise]is shut[end if]." Through the porch door is the Porch. The porch door is a latched door. The porch door is a half-door of the house door. 

	A brass knocker is part of the house door. The description is "The brass knocker scowls at you: the old witch has a ring clenched in her teeth. Her incisors look almost like vampire fangs." Understand "witch" or "old" or "ring" or "teet" or "incisors" or "vampire" or "fangs" as the brass knocker.

	The description of the Living Room is "It's completely decorated by Denise, cleaned by Denise, and managed by Denise. The faintly bitter odor in the air is Denise's vetiver room scent."

	Denise is a woman in the Living Room. "Denise herself is bent over her antique sewing machine, pumping hard at the pedals and muttering under her breath." [The sewing machine prop is left as an exercise to the reader.]

	Every turn when the knocker is just-knocked and the location is the Porch and the porch door is closed: 
		say "'[one of]Coming[or]Just a minute[or]Hang on[or]AAAARGH[stopping]!' calls a muffled voice from within.";
		let rude comment be "Forget your key[one of][or] again[stopping]?";
		if the porch door is unlocked, now rude comment is "It was open! Why didn't you try opening it yourself?"; 
		try Denise opening the porch door;
		if the porch door is open, say "'[rude comment]' asks Denise[one of][or], a little ungraciously[or], looking frankly irritated[stopping]. [one of]Since you're not a guest, she doesn't bother staying at the door, but wanders back to what she was doing[or]Muttering, she goes back to her task[or]She sets her jaw angrily and retreats from the door[stopping].";

	Every turn: now the knocker is not just-knocked.
	
	The knocker can be just-knocked. 

	Understand "knock [knocker]" or "knock on/with [knocker]" or "use [knocker]" as attacking. 

	Instead of attacking the knocker: say "You knock loudly with the brass knocker."; now the knocker is just-knocked.

	Understand "knock on [something]" as knocking on. Knocking on is an action applying to one thing.

	Instead of knocking on the house door, try attacking the knocker.

	A thing can be soft or hard. A thing is usually hard. A person is usually soft. A wearable thing is usually soft.

	Report knocking on something soft:
		say "[The noun] [are] too soft for knocking to give any interesting effect." instead.

	Report knocking on something:
		say "You rap your knuckles against [the noun], to no effect."
	
	Test me with "x latch / open door / close door / knock on door / close door / lock door with key / knock on door / x knocker / x latch / in / x knocker / x latch / close door / x knocker / x latch / latch door / open door".



