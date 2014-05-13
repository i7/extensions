Version 1 of Basic Characters by ShadowChaser begins here.

"This adds the properties health, magic and sanity to a person or animal. It allows these values to be progarmatically manipulated and includes a process that replenishes health and magic over time. It also provides commands and functions for obtaining a descriptive status of the condition of these three properties for any given person or animal."

Section 1 - Includes

Include Plurality by Emily Short.
Include Useful Functions by ShadowChaser.

Section 2 - Global Variable Place Holders

BC_val is a number that varies.
BC_maxval is a number that varies.

Section 3 - Definitions

Use no magic reporting translates as (- Constant NO_MAGIC_REPORT; -).

Section 4 - Health

Table of Health_Level
rank
"near to death"
"badly injured"
"injured"
"slightly injured"
"almost uninjured"

To say health_of (item - a thing):
	now BC_val is the health of the item;
	now BC_maxval is the max_health of the item;
	if the health of the item is 0 begin;
		 say "dead";
	otherwise if the health of the item is the max_health of the item;
		say "healthy";
	otherwise;
		say "[EqualRankOf BC_val out_of BC_maxval from_table Table of Health_Level]";
	end if.

A person has a number called health. A person has a number called max_health. A person has a number called heal_rate. A person has a number called heal_counter. A person can be either heal_safe or heal_unsafe. A person is usually heal_safe.

The health of a person is usually 10. The max_health of a person is usually 10. The heal_rate of a person is usually 5. The heal_counter of a person is usually 0.

An animal has a number called health. An animal has a number called max_health. An animal has a number called heal_rate. An animal has a number called heal_counter. An animal can be either heal_safe or heal_unsafe. An animal is usually heal_safe.

The health of an animal is usually 10. The max_health of an animal is usually 10. The heal_rate of an animal is usually 5. The heal_counter of an animal is usually 0.

To increase_health_of (person_to_heal - a thing) by (hp - a number):
	let vhp be the health of the person_to_heal;
	let vhp be vhp + hp;
	now the health of the person_to_heal is vhp;
	if the health of the person_to_heal > the max_health of the person_to_heal begin;
		now the health of the person_to_heal is the max_health of the person_to_heal;
	end if.

To decrease_health_of (person_to_heal - a thing) by (hp - a number):
	let vhp be the health of the person_to_heal;
	let vhp be vhp - hp;
	now the health of the person_to_heal is  vhp;
	if the health of the person_to_heal < 0 begin;
		now the health of the person_to_heal is 0;
	end if.

To say report_healing:
	say "You feel a little healthier[if the health of the player >= the max_health of the player]; In fact you are fully healed[end if].";

Requesting the health of the player is an action out of world.

Report requesting the health of the player: say "You are [health_of the player].".

Understand "health" as requesting the health of the player.

Definition: a person (called the dying_actor) is dead if the health of the dying_actor is 0.
Definition: an animal (called the dying_actor) is dead if the health of the dying_actor is 0.

Section 5 - Magic

Table of Magic_Rank
rank
"almost completely drained"
"extremely drained"
"drained"
"slightly drained"
"almost fully charged"

To say magic_of (item - a thing):
	now BC_val is the magic_level of the item;
	now BC_maxval is the max_magic of the item;
	if the magic_level of the item is 0 begin;
		 say "completely drained";
	otherwise if the magic_level of the item is the max_magic of the item;
		say "fully charged";
	otherwise;
		say "[EqualRankOf BC_val out_of BC_maxval from_table Table of Magic_Rank]";
	end if.

A person has a number called magic_level. A person has a number called max_magic. A person has a number called magic_regen_rate. A person has a number called magic_counter. A person can be either regen_safe or regen_unsafe. A person is usually regen_safe.

The magic_level of a person is usually 10. The max_magic of a person is usually 10. The magic_regen_rate of a person is usually 5. The magic_counter of a person is usually 0.

An animal has a number called magic_level. An animal has a number called magic_health. An animal has a number called magic_regen_rate. An animal has a number called magic_counter. An animal can be either regen_safe or regen_unsafe. An animal is usually regen_safe.

The magic_level of an animal is usually 10. The max_magic of an animal is usually 10. The magic_regen_rate of an animal is usually 5. The magic_counter of an animal is usually 0.

To increase_magic_of (item - a thing) by (mp - a number):
	let varmp be the magic_level of the item;
	let varmp be varmp + mp;
	now the magic_level of the item is varmp;
	if the magic_level of the item > the max_magic of the item begin;
		now the magic_level of the item is the max_magic of the item;
	end if.

To decrease_magic_of (itemobj - a thing) by (mp - a number):
	let varmp be the magic_level of the itemobj;
	let varmp be varmp - mp;
	now the magic_level of the itemobj is varmp;
	if the magic_level of the itemobj < 0 begin;
		now the magic_level of the itemobj is 0;
	end if.

To say report_magic_healing :
	say "You feel a little more psychically charged[if the magic_level of the player >= the max_magic of the player]; In fact, you are fully charged[end if].".

Requesting the magic level of the player is an action out of world.

Report requesting the magic level of the player: 
	if using the no magic reporting option begin;
		say "You are no magician.";
	else;
		say "You are [magic_of the player].";
	end if.

Understand "magic" as requesting the magic level of the player.

Definition: a person (called the drained_actor) is magically spent if the magic_level of the drained_actor is 0.
Definition: an animal (called the drained_actor) is magically spent if the magic_level of the drained_actor is 0.

Section 6 - Natural healing

Natural_Healing is a scene.

Natural_Healing begins when play begins.

Every turn during Natural_Healing:
	repeat with item running through people begin;
		naturally_heal the item;
		naturally_magically_heal the item;
	end repeat;
	repeat with item running through animals begin;
		naturally_heal the item;
		naturally_magically_heal the item;
	end repeat.
	
To naturally_heal (item - a thing):
	if the item is not dead and the health of the item < the max_health of the item begin;
		if the heal_rate of the item  > 0 and the item is heal_safe begin;
			now the heal_counter of the item is the heal_counter of the item + 1;
			if the heal_counter of the item is the heal_rate of the item begin;
				increase_health_of the item by 1;
				now the heal_counter of the item is 0;
				if the item is the player begin;
					say "[report_healing]";
				end if;
			end if;
		end if;
	end if.

To naturally_magically_heal (item - a thing):
	if the magic_level of the item < the max_magic of the item begin;
		if the magic_regen_rate of the item  > 0 and the item is regen_safe begin;
			now the magic_counter of the item is the magic_counter of the item + 1;
			if the magic_counter of the item is the magic_regen_rate of the item begin;
				increase_magic_of the item by 1;
				now the magic_counter of the item is 0;
				if the item is the player begin;
					say "[report_magic_healing]";
				end if;
			end if;
		end if;
	end if.

Section 7 - Sanity

Table of Sanity_Level
rank
"insane"
"flaky"
"quite shaken"
"slightly shaken"
"almost completely sane"

To say sanity_of (item - a thing):
	now BC_val is the sanity of the item;
	if the sanity of the item is 0 begin;
		say "completely insane";
	otherwise if the sanity of the item is 99;
		say "completely sane";
	otherwise;
		say "[EqualRankOf BC_val out_of 100 from_table Table of Sanity_Level]";
	end if.

A person has a number called sanity. The sanity of a person is usually 99. 

An animal has a number called sanity. The sanity of an animal is usually 99. 

To increase_sanity_of (person_to_heal - a thing) by (san - a number):
	let vsan be the sanity of the person_to_heal;
	let vsan be vsan + san;
	now the sanity of the person_to_heal is vsan;
	if the sanity of the person_to_heal > 99 begin;
		now the sanity of the person_to_heal is 99;
	end if.

To decrease_sanity_of (person_to_heal - a thing) by (san - a number):
	let vsan be the sanity of the person_to_heal;
	let vsan be vsan - san;
	now the sanity of the person_to_heal is vsan;
	if the sanity of the person_to_heal < 0 begin;
		now the sanity of the person_to_heal is 0;
	end if.

Requesting the sanity of the player is an action out of world.

Report requesting the sanity of the player: say "You are [sanity_of the player].".

Understand "sanity" as requesting the sanity of the player.

Definition: a person (called the insane_actor) is permanently insane if the sanity of the insane_actor is 0.
Definition: an animal (called the insane_actor) is permanently insane if the sanity of the insane_actor is 0.

Section 8 - Status Of The Player

Requesting the status of the player is an action out of world.

Report requesting the status of the player:
		if using  the no scoring option begin;
			say "You are ";
 			say "[health_of the player]";
			if not using the no magic reporting option begin;
				say ", [magic_of the player]";
			end if;
			say " and [sanity_of the player].";
		else;
			try requesting the score;
			say "You are ";
 			say "[health_of the player]";
			if not using the no magic reporting option begin;
				say ", [magic_of the player]";
			end if;
			say " and [sanity_of the player].";
		end if.

Understand "status" as requesting the status of the player.

Basic Characters ends here.

---- DOCUMENTATION ----

Section: Description 

This extension simulates three basic elements of characters or creatures for use in games - magic, health and sanity. It also provides a "status" command that players can use to display a description of these three basic elements.

Section: Dependencies

The following extensions are used and loaded by this one:

Plurality by Emily Short.

Useful Functions by ShadowChaser.

Section: Health

Every person or animal in the game has three user changeable values called health, max_health, and heal_rate. These are explained below:-

health - The current health of a person or animal (defaulted to 10). A person or animal can be considered dead if their health is 0 (although this extension provides no definition of death).

max_health - This is the person or animals maximum level of health (when they are uninjured - defaulted to 10). 

heal_rate - This is the speed at which a person heals (defaulted to 5). It is an indication of the number of turns before the person or animal regains 1 health point when injured. 

Note: a dead person or animal will not regain health unless you make their health at least 1 point manually first.

The command "health" will display a description of the player's health. (This is defined as an out of work action called requesting the health of the player. This won't be their actual health value; rather it will be some text like "injured" or "healthy" If the player is at 0 health it will display "dead".

Each person or animal can also be heal_safe or heal_unsafe. The default is heal_safe. If a person or animal is heal_unsafe then they will not undergo the natural healing process until they are made heal_safe again.

To print a description of the current health of an animal or person:-

	Say  health_of {personoranimal}

To increase or decrease a person or animal's health:

	increase_health_of {personoranimal} by {amount}

	decrease_health_of {personoranimal} by {amount}

If a person or animal loses all of their health they become "dead". This is a convenient way of indicating 0 health, e.g.:
	
	if the player is dead, end the game in death.

Section: Magic

Every person or animal in the game has three user changeable values called magic_level, max_magic, and magic_regen_rate. these are explained below:-

magic - The current magic level of a person or animal (defaulted to 10). 

max_magic - This is the person or animals maximum level of magic (defaulted to 10). 

magic_regen_rate - This is the speed at which a person regains magic (defaulted to 5). It is an indication of the number of turns before the person or animal regains 1 magic point when their magic level is less than max_magic.

Each person or animal can also be regen_safe or regen_unsafe. The default is regen_safe. If a person or animal is regen_unsafe then they will not undergo the natural magic level regeneration process until they are made regen_safe again.

The command "magic" will display a description of the player's magic. (This is defined as an out of work action called requesting the magic level of the player. This won't be their actual magic value; rather it will be some text like "drained" or "fully charged".

Not every game will want the player to use magic. For this reason if the following line is used:

	Use no magic reporting

Then the command "magic" will display "You are no magician.", and the magic status of the player will not be included in the "status" command.

To print a description of the current magic level of an animal or person:-

	Say  magic_of {personoranimal}

To increase or decrease a person or animal's magic:

	increase_magic_of {personoranimal} by {amount}

	decrease_magic_of {personoranimal} by {amount}

If a person or animal loses all of their magic they become "magically spent". This is a convenient way of indicating 0 magic level, e.g.:
	
	if the player is magically spent, say "You are unable to cast any more spells at present.".

Section: Sanity

Every person or animal in the game has a number called sanity (defaulted to 99). This is a measure of how sane a person or animal is.

The command "sanity" will display a description of the player's sanity. (This is defined as an out of work action called requesting the sanity of the player. This won't be their actual sanity value, rather it will be some text like "sane" or "insane".

To print a description of the current sanity level of an animal or person:-

	Say  sanity_of {personoranimal}

To increase or decrease a person or animal's sanity:

	increase_sanity_of {personoranimal} by {amount}

	decrease_sanity_of {personoranimal} by {amount}

If a person or animal loses all of their sanity they become "permanently insane". This is a convenient way of indicating 0 sanity, e.g.:
	
	if the player is permanently insane, say "You have completely lost your mind...".

Section: Status

The command "status" will display a description of the player's health, magic and sanity. (This is defined as an out of work action called requesting the status of the player. 

Example: ** The Hideous Rabbit of Thoth - This demonstrates most of the functions used in this extension. You might want to keep examining your status whilst testing.

	*: "The Hideous Rabbit of Thoth" by Shadowchaser

	Include Basic Characters by ShadowChaser.

	The health of the player is 15.

	The black chamber of spellcasting is a room. "You are standing in the black chamber of spellcasting. A sign above you says 'You may CAST a spell here only at your peril.'".

	The abyss is a room.

	The hideous mutated rabbit is an animal in the abyss. "[if the hideous mutated rabbit is dead]You see a dead mutated rabbit here.[else]A hideous mutated rabbit eyes you with an evil stare.[end if]". The description is "It is hideous beyond all comprehension".

	The hideous mutated rabbit is heal_unsafe.

	casting is an action applying to nothing.

	understand "cast" as casting.
	understand "cast spell" as casting.
	understand "chant" as casting.

	Check casting:
		if the player is magically spent begin;
			say "You have no psychic energy left." instead;
		end if.

	Carry out Casting:
		decrease_magic_of the player by 3.

	Report Casting: Say "You use up some of your psychic energy...".

	After casting:
		if the hideous mutated rabbit is not in the black chamber begin;
			say "You chant the deadly words of power. A foul smelling black smoke rises from the ground and when it clears it reveals a hideous mutated rabbit. The rabbit glares at you.";
			now the player is heal_unsafe;
			now the player is regen_unsafe;
			now the hideous mutated rabbit is in the black chamber;
			decrease_Sanity_of the player by 20;
			Say "Your sanity is shaken.";
		else if the hideous mutated rabbit is dead;
			say "You chant the deadly words of power. A foul smelling black smoke rises from the ground and when it clears it reveals a re-animated mutated rabbit. The rabbit glares at you.";
			now the player is heal_unsafe;
			now the player is regen_unsafe;
			now the health of the hideous mutated rabbit is 10;
			decrease_Sanity_of the player by 20;
			Say "Your sanity is shaken.";
		else;
			say "You chant, and a blast of psychic energy hits the rabbit.";
			hurt the rabbit by 3;
		end if.

	To hurt the rabbit by (x - a number):
		decrease_health_of the hideous mutated rabbit by x;
		say "The rabbit screams in pain.";
		if the hideous mutated rabbit is dead begin;
			Say "It collapses in a lifeless heap.";
			now the player is regen_safe;
			now the player is heal_safe;
		end if.

	Instead of attacking the hideous mutated rabbit:
		if the hideous mutated rabbit is dead begin;
			say "It's already dead.";
		else;
			say "You punch the rabbit.";
			hurt the rabbit by 2;
		end if.
			
		
	Rabbit Attack is a scene.
	Rabbit Attack begins when the hideous mutated rabbit is in the black chamber for the first time.
	Rabbit Attack ends when the health of the player is 0.

	Every turn during Rabbit Attack:
		if the rabbit is not dead begin;
			say "The rabbit launches itself at you and bites you.";
			decrease_health_of the player by 2;
			if the player is dead begin;
				Say "You die from your wounds...";
				end the game in death;
			end if;
		end if.

	Test me with "cast / hit rabbit / cast / cast / cast".
