Version 2 of NPC Implicit Actions IT by Leonardo Boselli begins here.

"A basic extension of the Implicit Actions extension into actions carried out by NPCs. This extension automatically includes Implicit Actions. Solo tradotto in italiano."

"basato su NPS Implicit Actions by Eric Eve."

Book 1 - Includes

Include Implicit Actions IT by Leonardo Boselli.

Book 2 - Before Rules Causing Implicit Actions

Before someone taking something when the noun is inside a closed container (called the receptacle) (this is the npc open before taking contents rule):
  try the actor opening the receptacle;
  if the receptacle is closed, stop the action.


Before someone unlocking something with something when the second noun is not carried by the actor (this is the npc must hold key before unlocking rule):
  if the holder of the second noun is a keyring, let the item needed be the holder of the second noun;
  otherwise let the item needed be the second noun;
  if the item needed is carried by the actor, continue the action;
  try the actor taking the item needed;
  if the item needed is not carried by the actor, stop the action.


Before someone locking something with something when the second noun is not carried by the actor (this is the npc take key before locking rule):
  if the holder of the second noun is a keyring, let the item needed be the holder of the second noun;
  otherwise let the item needed be the second noun;
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
 if the noun is not carried by the actor then stop the action.

   
Before someone inserting something into something when the noun is not carried by the actor (this is the npc take object before inserting it into rule):
  if the noun is in the second noun, continue the action;
 try the actor taking the noun;
 if the noun is not carried by the actor then stop the action.


Before someone inserting something into something when the second noun is an openable closed container (this is the npc open container before inserting rule):
  try the actor opening the second noun;
  if the second noun is closed then stop the action.


Before someone searching a closed opaque container (this is the npc open container before searching rule):
  try the actor opening the noun;
  if the noun is closed then stop the action.


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
  

NPC Implicit Actions IT ends here.

---- DOCUMENTATION ----

Vedi documentazione originale di NPC Implicit Actions by Eric Eve.