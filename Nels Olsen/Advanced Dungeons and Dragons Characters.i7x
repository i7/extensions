Version 1/160118 of Advanced Dungeons and Dragons Characters by Nels Olsen begins here.

"Provides rudimentary support for a party of old-school D&D characters."

Include Protagonists by Kevin Norris.
Include Slotted Wearing and Wielding by Nels Olsen.

Chapter - Characters

A PC is a kind of person. 
He is usually playable.
He is usually ready to follow.

An NPC is a kind of person.
He is usually not playable.
He is usually not ready to follow.

Section - Character Abilities

Every person has a number called strength.
The strength of a person is usually 10.

Every person has a number called intelligence.
The intelligence of a person is usually 10.

Every person has a number called wisdom.
The wisdom of a person is usually 10.

Every person has a number called dexterity.
The dexterity of a person is usually 10.

Every person has a number called constitution.
The constitution of a person is usually 10.

Every person has a number called charisma.
The charisma of a person is usually 10.

Section - Character Status

Every person has a number called level.
The level of a person is usually 0.

Every person has a number called hit points.
The hit points of a person is usually 5.

Every person is either paralyzed or not paralyzed.
A person is usually not paralyzed.

Every person is either frightened or not frightened.
A person is usually not frightened.

Every person is either sane or insane.
A person is usually sane.

To decide whether (P - a PC) is capable of following (this is the followers must be able and willing rule):
	if the hit points of P is less than 1, decide no;
	if P is paralyzed, decide no;
	if P is frightened, decide no;
	if P is insane, decide no;
	decide yes.

Check an actor going (this is the incapable followers can't go rule):
	if the actor is capable of following, continue the action;
	otherwise stop the action.

Check an actor entering (this is the incapable followers can't enter rule):
	if the actor is capable of following, continue the action;
	otherwise stop the action.
	
Check an actor exiting (this is the incapable followers can't exit rule):
	if the actor is capable of following, continue the action;
	otherwise stop the action.

Check an actor getting off (this is the incapable followers can't get off rule):
	if the actor is capable of following, continue the action;
	otherwise stop the action.

Section - Character Races

Character Race is a kind of value.
The Character Races are human, elf, dwarf, gnome and halfling.
Every person has a Character Race called race.
The race of a person is usually human.

Section - Character Classes

Character Class is a kind of value.
The Character Classes are commoner, barbarian, fighter, cleric, wizard, thief, druid, illusionist, paladin, ranger and monk.
Every person has a Character Class called class.
The class of a person is usually commoner.

Chapter - Equipment

A thing can be magical or non-magical.  A thing is seldom magical.
Magic-aura is a kind of value.  The magic-auras are no-aura, faint-aura, moderate-aura, strong-aura and overwhelming-aura.
Everything has a magic-aura called magical aura.  The magical aura of a thing is usually no-aura.

Section - Weight and Encumbrance

Weight is a kind of value.  10.0lb specifies a weight.  Everything has a weight.
The verb to weigh means the weight property.  A thing usually weighs 1lb.

Every container has a weight called encumbrance capacity.
The encumbrance capacity of a container is usually 50lb.

To decide what weight is the effective weight of (T - a thing):
	let W be the weight of T;
	decide on W.

To decide what weight is the weight contained by (C - a container):
	let W be 0lb;
	repeat with item running through the list of things contained by C:
		let E be the effective weight of the item;
		now W is W plus E;
	decide on W.

To decide what weight is the effective weight of (C - a container):
	let E be the weight of C plus the weight contained by C; 
	decide on E.

To decide what weight is the weight born by (P - a person):
	let W be 0lb;
	repeat with item running through the list of things worn by P:
		let E be the effective weight of the item;
		now W is W plus E;
	repeat with item running through the list of things carried by P:
		let E be the effective weight of the item;
		now W is W plus E;
	decide on W.

To decide what weight is the effective weight of (P - a person):
	let E be the weight of P plus the weight born by P; 
	decide on E.

To decide what weight is the maximum weight bearable by (P - a person):
	[TODO: Use the D&D 1e rules]
	decide on 80lb.

Check an actor taking something (this is the can't bear weight beyond your strength limit rule):
	let item be the noun;
	let P be the actor;
	let B be the weight born by P;
	let E be the effective weight of the item;
	let M be the maximum weight bearable by P;
	if B + E > M:
		say "Taking [the item][if the number of things held by P is greater than 0] along with everything else worn and carried[end if] would be more weight than [P] can bear.";
		stop the action.

Check an actor inserting something into something:
	let item be the noun;
	let C be the second noun;
	let B be the weight contained by C;
	let E be the effective weight of the item;
	let M be the encumbrance capacity of C;
	if B + E > M:
		say "[The C] [is-are]n't able to bear the weight of [the item][if the number of  things contained by C is greater than 0] along with everything else in [it-them].";
		stop the action.

Section - Adventuring Equipment

A small-belt-pouch is a kind of wearable-slot-filling-container.
The printed name is "small belt pouch".
The encumbrance capacity is 5lb.
The required-wearable-slots are { "belt" }.
Understand "small belt pouch", "small pouch" as small-belt-pouch.

A large-belt-pouch is a kind of wearable-slot-filling-container.
The printed name is "large belt pouch".
The encumbrance capacity is 10lb.
The required-wearable-slots are { "belt" }.
Understand "large belt pouch", "large pouch" as large-belt-pouch.

A small-sack is a kind of wearable-slot-filling-container.
The printed name is "small sack".
The encumbrance capacity is 15lb.
The required-wearable-slots are { "belt" }.
Understand "small sack" as small-sack.
 
A backpack is a kind of wearable-slot-filling-container.
The printed name is "backpack".
The encumbrance capacity is 25lb.
The required-wearable-slots are { "back" }.
Understand "backpack", "pack" as backpack.

A large-sack is a kind of wearable-slot-filling-container.
The printed name is "large sack".
The encumbrance capacity is 40lb.
The required-wearable-slots are { "back" }.
Understand "large sack" as large-sack.

A small-bag-of-holding is a kind of wearable-slot-filling-container.
The printed name is "small bag of holding".
The encumbrance capacity is 500lb.
The required-wearable-slots are { "belt" }.
Understand "small bag of holding" as small-bag-of-holding.

A large-bag-of-holding is a kind of wearable-slot-filling-container.
The printed name is "large bag of holding".
The encumbrance capacity is 1500lb.
The required-wearable-slots are { "back" }.
Understand "large bag of holding" as large-bag-of-holding. 

Section - Armor

Every wearable-slot-filler has a number called enchantment bonus.  The enchantment bonus is usually 0.

Some armor is a kind of wearable-slot-filler.
The indefinite article is usually "some".
The printed name is "armor". 
The required-wearable-slots are usually { "head", "chest", "leg", "leg", "arm", "arm" }.
All armor has a number called base defense bonus.

A robe is a kind of armor.
The indefinite article is usually "a".
The printed name is "robe".
It weighs 2.5lb.
The base defense bonus is 0.
The required-wearable-slots are { "chest", "leg", "leg" }.
Understand "robe" as robe.

Some leather-armor is a kind of armor.
The printed name is "leather armour".
It weighs 15lb.
The base defense bonus is 2.
Understand "leather armor" as leather-armor.

Some studded-leather-armor is a kind of armor.
The printed name is "studded leather armor".
It weighs 25lb.
The base defense bonus is 3.
Understand "studded leather armor" as studded-leather-armor.

Some ring-mail is a kind of armor.
The printed name is "ring mail".
It weighs 30lb.
The base defense bonus is 3.
Understand "ring mail" as ring-mail.

Some hide-armor is a kind of armor.
The printed name is "hide armor".
It weighs 30lb.
The base defense bonus is 4.
Understand "hide armor" as hide-armor.

Some scale-mail is a kind of armor.
The printed name is "scale mail".
It weighs 40lb.
The base defense bonus is 4.
Understand "scale mail" as scale-mail.

Some chain-mail is a kind of armor.
The printed name is "chain mail".
It weighs 40lb.
The base defense bonus is 5.
Understand "chain mail" as chain-mail.

Some splint-mail is a kind of armor.
The printed name is "splint mail".
It weighs 40lb.
The base defense bonus is 6. 
Understand "splint mail" as splint-mail.

Some banded-mail is a kind of armor.
The printed name is "banded mail".
It weighs 35lb.
The base defense bonus is 6. 
Understand "banded mail" as banded-mail.

Some plate-mail is a kind of armor.
The printed name is "plate mail".
It weighs 50lb.
The base defense bonus is 7.
Understand "plate mail" as plate-mail.

A shield is kind of wieldable-slot-filler.
The indefinite article is usually "a".
The printed name is "shield".
The required-wieldable-slots are usually { "hand" }.
Every shield has a number called base defense bonus.  The base defense bonus is usually 1.
Every shield has a number called enchantment bonus.  The enchantment bonus is usually 0.
Every shield has a number called total blocks per round.  The total blocks per round is usually 2.
Every shield has a number called blocks used this round.  The blocks used this round is usually 0.

A small-wooden-shield is a kind of shield.
The printed name is "small wooden shield".
It weighs 5lb.
The total blocks per round are 1.
Understand "small wooden shield" as small-wooden-shield.

A small-metal-shield is a kind of shield.
The printed name is "small metal shield".
It weighs 5lb.
The total blocks per round are 1.
Understand "small metal shield" as small-metal-shield.

A medium-wooden-shield is a kind of shield.
The printed name is "medium wooden shield".
It weighs 10lb.
The total blocks per round are 2.
Understand "medium wooden shield" as medium-wooden-shield.

A medium-metal-shield is a kind of shield.
The printed name is "medium metal shield".
It weighs 10lb.
The total blocks per round are 2.
Understand "medium metal shield" as medium-metal-shield.

A large-wooden-shield is a kind of shield.
The printed name is "large wooden shield".
It weighs 15lb.
The total blocks per round are 3.
Understand "large wooden shield" as large-wooden-shield.

A large-metal-shield is a kind of shield.
The printed name is "large metal shield".
It weighs 15lb.
The total blocks per round are 3.
Understand "large metal shield" as large-metal-shield.

To decide what number is the AC of (P - a person) (this is armor class determining): 
	let running-AC be 10;
	repeat with item running through the list of armor worn by P:
		now running-AC is running-AC - (the base defense bonus of item);
	repeat with item running through the list of wearable-slot-fillers worn by P:
		now running-AC is running-AC - (the enchantment bonus of item);
	decide on running-AC.

To say the AC of (P - a person):
	let X be the AC of P;
	say X.

Section - Ammunition

Some ammunition is a kind of thing.
The indefinite article is usually "some".
The printed name is "ammunition".
It usually weighs 0.1lb.
Every ammunition has a number called enchantment bonus.  The enchantment bonus is usually 0.

A thing can be arrow-like or not arrow-like.  A thing is seldom arrow-like.
An arrow is a kind of arrow-like ammunition.

A thing can be bolt-like or not bolt-like.  A thing is seldom bolt-like.
A bolt is a kind of bolt-like ammunition.

A thing can be bullet-like or not bullet-like.  A thing is seldom bullet-like.
A bullet is a kind of bullet-like ammunition.

Weapon-firing-mode is a kind of value.
The weapon-firing-modes are shoots-arrows, shoots-bolts, hurls-bullets and fires-nothing.

Section - Weapons

Weapon-complexity-type is a kind of value.
The weapon-complexity-types are simple, martial and exotic.

Momentum-damage-type is a kind of value.
The momentum-damage-types are slashing, bludgeoning and piercing.

Energy-damage-type is a kind of value.
The energy-damage-types are fire, cold, acid, electricity, positive-energy, negative-energy and no-energy.

Weapon-handedness-type is a kind of value.
The weapon-handedness-types are one-handed and two-handed.

A weapon is a kind of wieldable-slot-filler.
The indefinite article is usually "a".
The required-wieldable-slots are usually { "hand" }.
Every weapon can be swingable or not swingable.  A weapon is usually swingable.
Every weapon can be throwable or not throwable.  A weapon is seldom throwable.
Every weapon can be fireable or not fireable.  A weapon is seldom fireable.
Every weapon has a weapon-handedness-type called handedness.  The handedness is usually one-handed.
Every weapon has a weapon-complexity-type called complexity.  The complexity is usually martial.
Every weapon has momentum-damage-type called momentum damage type.  The momentum damage type is usually bludgeoning.
Every weapon has an energy-damage-type called energy damage type.  The energy damage type is usually no-energy.
Every weapon has an weapon-firing-mode called firing mode.  The firing mode is usually fires-nothing.
Every weapon has a number called base damage rating.
Every weapon has a number called enchantment bonus.  The enchantment bonus is usually 0.

A great-axe is a kind of weapon.
The printed name is "great axe".
It is swingable, not throwable, and not fireable.
The complexity is martial.
The momentum damage type is slashing.
The base damage rating is 12.
Understand "great axe" as great-axe.
The handedness is two-handed.  The required-wieldable-slots of a great-axe are { "hand", "hand" }.

A war-hammer is a kind of weapon.
The printed name is "war hammer".
It is swingable, not throwable, and not fireable.
The complexity is martial.
The momentum damage type is bludgeoning.
The base damage rating is 8.
Understand "war hammer" as war-hammer.

A long-sword is a kind of weapon.
The printed name is "long sword".
It is swingable, not throwable, and not fireable.
The complexity is martial.
The momentum damage type is slashing.
The base damage rating is 8.
Understand "long sword" as long-sword.

A scimitar is a kind of weapon.
The printed name is "scimitar".
It is swingable, not throwable, and not fireable.
The complexity is martial.
The momentum damage type is slashing.
The base damage rating is 8.
Understand "scimitar" as scimitar.

A short-sword is a kind of weapon.
The printed name is "short sword".
It is swingable, not throwable, and not fireable.
The complexity is martial.
The momentum damage type is slashing.
The base damage rating is 6.
Understand "short sword" as short-sword.

A dagger is a kind of weapon.
The printed name is "dagger".
It is swingable, throwable , and not fireable.
The complexity is simple.
The momentum damage type is piercing.
The base damage rating is 4.
Understand "dagger" as dagger.

A mace is a kind of weapon.
The printed name is "mace".
It is swingable, not throwable, and not fireable.
The complexity is simple.
The momentum damage type is bludgeoning.
The base damage rating is 8.
Understand "mace" as mace.

A long-bow is a kind of weapon.
The printed name is "long bow".
It is not swingable, not throwable, and fireable.
The complexity is martial.
The momentum damage type is piercing.
The firing mode is shoots-arrows.
The base damage rating is 8.
The handedness is two-handed.  The required-wieldable-slots of a long-bow are { "hand", "hand" }.
Understand "long bow" as long-bow.

A short-bow is a kind of weapon.
The printed name is "short bow".
It is not swingable, not throwable, and fireable.
The complexity is martial.
The momentum damage type is piercing.
The firing mode is shoots-arrows.
The base damage rating is 6.
The handedness is two-handed.  The required-wieldable-slots of a short-bow are { "hand", "hand" }.
Understand "short bow" as short-bow.

A light-crossbow is a kind of weapon.
The printed name is "light crossbow".
It is not swingable, not throwable, and fireable.
The complexity is simple.
The momentum damage type is piercing.
The firing mode is shoots-arrows.
The base damage rating is 8.
The handedness is two-handed.  The required-wieldable-slots of a light-crossbow are { "hand", "hand" }.
Understand "light crossbow" as light-crossbow.

A heavy-crossbow is a kind of weapon.
The printed name is "heavy crossbow".
It is not swingable, not throwable, and fireable.
The complexity is martial.
The momentum damage type is piercing.
The firing mode is shoots-arrows.
The base damage rating is 8.
The handedness is two-handed.  The required-wieldable-slots of a heavy-crossbow are { "hand", "hand" }.
Understand "heavy crossbow" as heavy-crossbow.

A sling is a kind of weapon.
The printed name is "sling".
It is not swingable, not throwable, and fireable.
The complexity is simple.
The momentum damage type is bludgeoning.
The firing mode is hurls-bullets.
The base damage rating is 6.
Understand "sling" as sling.

A quarterstaff is a kind of weapon.
The printed name is "quarterstaff".
It is swingable, not throwable , and not fireable.
The complexity is simple.
The momentum damage type is bludgeoning.
The base damage rating is 8.
The handedness is two-handed.  The required-wieldable-slots of a quarterstaff are { "hand", "hand" }.
Understand "quarterstaff" as quarterstaff.

Some nunchucks are a kind of weapon.
The printed name is "nunchucks".  It is plural-named.
It is swingable, not throwable , and not fireable.
The complexity is exotic.
The momentum damage type is bludgeoning.
The base damage rating is 8.
Understand "nunchucks" as nunchucks.

Chapter - Combat

Chapter - Character Sheets

Characterizing is an action out of world applying to one thing.

Understand "characterize [something]" as characterizing. 

Check characterizing:
	let P be the noun;
	if P is not a person:
		say "Only people have character statistics.";
		stop the action;
	if P is not a PC:
		say "You aren't privy to the character statistics of someone not in your party.";
		stop the action.

Report characterizing:
	let P be the noun;
	say the character statistics of P.

To say the character statistics of (P - a person):
	say "[printed name of P]: level [level of P] [race of P] [class of P][line break]
STR: [strength of P][line break]
INT: [intelligence of P][line break]
WIS: [wisdom of P][line break]
DEX: [dexterity of P][line break]
CON: [constitution of P][line break]
CHA: [charisma of P][line break]
HP: [hit points of P][line break]
AC: [AC of P][line break]
Enc: [weight born by P] of [maximum weight bearable by P][line break]
".

Advanced Dungeons and Dragons Characters ends here.
