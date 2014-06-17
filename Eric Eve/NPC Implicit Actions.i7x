Version 4 of NPC Implicit Actions by Eric Eve begins here.
"A basic extension of the Implicit Actions extension into actions carried out by NPCs. This extension automatically includes Implicit Actions."

Book 1 - Includes

Include Implicit Actions by Eric Eve.

Book 2 - Before Rules Causing Implicit Actions

Before someone taking something when the noun is inside a closed container (called the receptacle) (this is the npc open before taking contents rule):
  try the actor opening the receptacle;
  if the receptacle is closed, stop the action.


Before someone unlocking something with something when the second noun is not carried by the actor (this is the npc must hold key before unlocking rule):
  let the item needed be the second noun;
  if the holder of the second noun is a keyring, let the item needed be the holder of the second noun;  
  if the item needed is carried by the actor, continue the action;
  try the actor taking the item needed;
  if the item needed is not carried by the actor, stop the action.


Before someone locking something with something when the second noun is not carried by the actor (this is the npc take key before locking rule):
  let the item needed be the second noun;
  if the holder of the second noun is a keyring, let the item needed be the holder of the second noun; 
  if the item needed is carried by the actor, continue the action;
  try the actor taking the item needed;
  if the item needed is not carried by the actor, stop the action.


Before someone locking something open with something (this is the npc close before locking rule):
  try the actor closing the noun;
  if the noun is open, stop the action.
   

Before someone going through a closed door (called the obstructor) (this is the npc open door before going through rule):
   try the actor opening the obstructor;
   if the obstructor is closed, stop the action.


Before someone opening something locked when actor is key-cognizant of the noun (this is the npc unlock with key before opening rule):   
   try the actor unlocking the noun with the matching key of the noun;
   if the noun is locked, stop the action.


Before someone opening something locked when the matching key of the noun is no-key:
  try the actor unbolting the noun;
  if the noun is locked, stop the action.


Before someone putting something on something when the noun is not carried by the actor (this is the npc take object before putting it on rule):
  if the noun is on the second noun, continue the action;
 try the actor taking the noun;
 if the noun is not carried by the actor, stop the action.

   
Before someone inserting something into something when the noun is not carried by the actor (this is the npc take object before inserting it into rule):
  if the noun is in the second noun, continue the action;
 try the actor taking the noun;
 if the noun is not carried by the actor, stop the action.


Before someone inserting something into something when the second noun is an openable closed container (this is the npc open container before inserting rule):
  try the actor opening the second noun;
  if the second noun is closed, stop the action.


Before someone searching a closed opaque container (this is the npc open container before searching rule):
  try the actor opening the noun;
  if the noun is closed, stop the action.


Before someone going from a room when the holder of the actor is not a room (this is the npc exit holder before leaving room rule):
  try the actor exiting;
  if the holder of the actor is not a room, stop the action.


Book 3 - NPC Knowledge of Keys

key-knowledge relates various people to various things.

The verb to be key-cognizant of implies the key-knowledge relation.

Carry out an actor locking something with something (this is the npc remembers locking rule):
  now everyone who can see the actor is key-cognizant of the noun.

Carry out an actor unlocking something with something (this is the npc remembers unlocking rule):
  now everyone who can see the actor is key-cognizant of the noun.

Book 4 - NPC Bolting and Unbolting

Before someone bolting something when the matching key of the noun is not no-key and the actor is key-cognizant of the noun and the actor can touch the matching key of the noun (this is the npc convert bolting to locking with rule):
  try the actor locking the noun with the matching key of the noun instead.


Before someone unbolting something when the matching key of the noun is not no-key and the actor is key-cognizant of the noun and the actor can touch the matching key of the noun (this is the npc convert unbolting to unlocking with rule):  
   try the actor unlocking the noun with the matching key of the noun instead.

Book 5 - Implicit Taking


Rule for implicitly taking something (called the object desired) when the person asked is not the player (this is the npc implicit taking rule):    
  try the person asked taking the object desired.
  




NPC Implicit Actions ends here.

---- DOCUMENTATION ----

This extension provides a basic mechanism for NPCs to use the same implicit actions as the Implicit Actions extension provides for the player character (for details of which, see the Implicit Actions documentation).

The mechanism is basic because, although NPCs will carry out the same implicit actions as the player character, there is no attempt to tidy up or group the implicit reaction reports. We'll just see things like:
	
	>bob, lock cabinet
	Bob picks up the silver key.

	Bob closes the glass cabinet.

	Bob locks the glass cabinet.

In the above example, Bob obviously knows what key to use. We keep track of this via the key-knowledge relation, which is expressed through the verb to be key-cognizant of. For example "Bob is key-cognizant of the glass cabinet" would mean the Bob knows which key to use to lock and unlock the glass cabinet. By default the extension keeps track of which actors are key-cognizant of which lockable items by making them so whenever they witness a key being successfully used to lock or unlock a cabinet or door. If we wanted Bob to start with some knowledge of what keys fit some locks, we could do so with statements like:

	Bob is key-cognizant of the gold chest.
	Bob is key-cognizant of the front door.

Likewise, if someone (the player character, say) tells Bob what key unlocks the gold chest in the course of the game, we could reflect that gain in knowledge with:

	Now Bob is key-cognizant of the gold chest.



Example:* Bossing Bob - An NPC who carries out implicit actions in the course of obeying commands.

This is the same scenario as the first example in Implicit Actions, except that here we get Bob to do most of the work.

	*: "Bossing Bob"

	Include NPC Implicit Actions by Eric Eve.
	Use full-length room descriptions.

	The Study is a Room. "A large wooden table stands to one side of the room, opposite a glass cabinet. An oak door leads south."

	The chair is an enterable scenery supporter in the Study.
	The player is on the chair.

	The large wooden table is a scenery supporter in the Study.

	The red box is a closed openable container. It is on the table.
	In the red box is a key called the silver key.

	A keyring called the gold keyring is on the table.

	The glass cabinet is a closed locked openable lockable transparent scenery container. It is in the study.
	The matching key of the glass cabinet is the silver key.
	A key called the brass key is in the glass cabinet.

	The oak door is a closed locked scenery door. It is south of the Study and north of the Hall.
	The matching key of the oak door is the brass key.

	Bob is a man. Bob is in the Study. 
	The description is "Bob is looking unusually obedient. He is currently carrying [the list of things carried by Bob]."

	Rule for writing a paragraph about Bob:
            say "Bob is standing here, waiting for instructions."

	Persuasion rule for asking Bob to try doing something: persuasion succeeds.

	The Hall is a Room. "This room is quite bare, but an oak door leads north, and a pine door east."

	The pine door is a closed locked scenery door. It is east of the Hall and west of the Closet.
 	The matching key of the pine door is no-key.

	The Closet is a Room. "This small closet is little more than a broom-cupboard (though there is not a broom in sight). A pine door leads out to the west."
	Instead of exiting in the Closet, try going west.
	
	Test me with "bob, s/bob, look in red box/bob, unlock glass cabinet with silver key/bob, unlock oak door with brass key/bob, s/s/bob, n/n/bob, lock door/bob, drop all/close red box/bob, put silver key in red box/bob, put brass key in cabinet/bob, lock cabinet/bob, drop silver key/bob, sit on chair/bob, s"




