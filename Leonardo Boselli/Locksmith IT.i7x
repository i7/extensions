Version 7 of Locksmith IT by Leonardo Boselli begins here.

"Gestione implicita di porte e contenitori cosicché la manipolazione della chiusura sia automatica se il giocatore possiede le chiavi necessarie. Basato su Version 7 of Locksmith by Emily Short."

Use authorial modesty.

Volume 1 - Automatic locking and unlocking with necessary actions

Use sequential action translates as (- Constant SEQUENTIAL_ACTION; -).

Before going through a closed door (called the blocking door) (this is the opening doors before entering rule):
	if using the sequential action option:
		try opening the blocking door;
	otherwise:
		say "(prima apri [the blocking door])[command clarification break]";
		silently try opening the blocking door;
	if the blocking door is closed, stop the action.

Before locking an open thing (called the door ajar) with something (this is the closing doors before locking rule):
	if using the sequential action option:
		try closing the door ajar;
	otherwise:
		say "(prima chiudi [the door ajar])[command clarification break]";
		silently try closing the door ajar;
	if the door ajar is open, stop the action.
	
Before locking keylessly an open thing (called the door ajar) (this is the closing doors before locking keylessly rule):
	if using the sequential action option:
		try closing the door ajar;
	otherwise:
		say "(prima chiudi [the door ajar])[command clarification break]";
		silently try closing the door ajar;
	if the door ajar is open, stop the action.

Before opening a locked thing (called the sealed chest) (this is the unlocking before opening rule): 
	if using the sequential action option:
		try unlocking keylessly the sealed chest;
	otherwise:
		say "(prima sblocca [the sealed chest])[command clarification break]";
		silently try unlocking keylessly the sealed chest;
	if the sealed chest is locked, stop the action.
	
Before someone trying going through a closed door (called the blocking door) (this is the intelligently opening doors rule):
	try the person asked trying opening the blocking door;
	if the blocking door is closed, stop the action.
	
Before someone trying locking an open thing (called the door ajar) with something (this is the intelligently closing doors rule):
	try the person asked trying closing the door ajar;
	if the door ajar is open, stop the action.
	
Before someone trying locking keylessly an open thing (called the door ajar)  (this is the intelligently closing keyless doors rule):
	try the person asked trying closing the door ajar;
	if the door ajar is open, stop the action.
	
Before someone trying opening a locked thing (called the sealed chest) (this is the intelligently opening containers rule):
	try the person asked trying unlocking keylessly the sealed chest;
	if the sealed chest is locked, stop the action.

Volume 2 - Default locking and unlocking

Part 1 - The matching key rule

This is the need a matching key rule:
	if the noun provides the property matching key:
		let the item be the matching key of the noun;
		if the person asked encloses the item:
			change the second noun to the item;
			abide by the must have accessible the second noun rule;
		otherwise:
			if the item is a passkey and the item unbolts the noun and the item is visible:
				change the second noun to the item;
				abide by the must have accessible the second noun rule;
			otherwise:
				if the player is the person asked, say "[key-refusal for noun]";
				stop the action;
	otherwise:
		if the player is the person asked, say "[key-refusal for noun]";
		stop the action.

To say key-refusal for (locked-thing - an object):
	carry out the refusing keys activity with the locked-thing.

Refusing keys of something is an activity.

Rule for refusing keys of something (called locked-thing) (this is the standard printing key lack rule):
	say "Non hai la chiave che sblocca [the locked-thing]."

Definition: a thing is key-accessible:
	if the person asked carries it, yes;
	if it is on a keychain which is carried by the person asked, yes;
	no.

Part 2 - Unlocking

Section 1 - Regular unlocking

Understand the command "sblocca" as something new. Understand "sblocca [things] con [something]" as unlocking it with. Understand "sblocca [locked lockable things] con [something]" as unlocking it with. Understand "sblocca [lockable things] con [something]" as unlocking it with.

Understand the command "apri" as something new. Understand "apri [things]" as opening. Understand "apri [things] con [something]" as unlocking it with. Understand "apri [locked lockable things] con [something]" as unlocking it with. Understand "apri [lockable things] con [something]" as unlocking it with.

Check unlocking it with (this is the must be able to reach the key rule):
	abide by the must have accessible the second noun rule.

Procedural rule: substitute the right second rule for the can't unlock without the correct key rule.

This is the right second rule:
	if the noun provides the property matching key:
		if the second noun is not the matching key of the noun, say "[The second noun] non sblocca [the noun]." instead;
	otherwise:
		say "[The second noun] non sblocca [the noun]." instead.

Section 2 - Keylessly

Understand "sblocca [things]" as unlocking keylessly. Understand "sblocca [locked lockable things]" as unlocking keylessly. Understand "sblocca [lockable things]" as unlocking keylessly.

Unlocking keylessly is an action applying to one thing.

Check unlocking keylessly (this is the check keylessly unlocking rule):
	abide by the can't unlock without a lock rule;
	abide by the can't unlock what's already unlocked rule;
	abide by the need a matching key rule.

Carry out unlocking keylessly (this is the standard keylessly unlocking rule):
	if using the sequential action option, do nothing; otherwise say "(con [the matching key of the noun])[command clarification break]";
	try unlocking the noun with the matching key of the noun.
	 
Check someone trying unlocking keylessly (this is the check someone else keylessly unlocking rule):	 
	abide by the can't unlock without a lock rule;
	abide by the can't unlock what's already unlocked rule;
	abide by the need a matching key rule.
	
Carry out someone trying unlocking keylessly (this is the standard someone else keylessly unlocking rule):
	try the person asked trying unlocking the noun with the matching key of the noun.
	

Part 3 - Locking

Section 1 - Regular locking

Understand the command "blocca" as something new. Understand "blocca [things] con [something]" as locking it with. Understand "blocca [unlocked lockable things] con [something]" as locking it with. Understand "blocca [lockable things] con [something]" as locking it with.

Check locking it with:
	abide by the must have accessible the second noun rule.

Procedural rule: substitute the right second rule for the can't lock without the correct key rule. 

Section 2 - Keylessly

Understand "blocca [things]" as locking keylessly.  Understand "blocca [unlocked lockable things]" as locking keylessly. Understand "blocca [lockable things]" as locking keylessly.

Locking keylessly is an action applying to one thing.

Check locking keylessly (this is the check keylessly locking rule):
	abide by the can't lock without a lock rule;
	abide by the can't lock what's already locked rule;
	abide by the can't lock what's open rule;
	abide by the need a matching key rule.
	
Carry out locking keylessly (this is the standard keylessly locking rule):
	if using the sequential action option, do nothing; otherwise say "(con [the matching key of the noun])[command clarification break]";
	try locking the noun with the matching key of the noun.

Check someone trying locking keylessly (this is the check someone keylessly locking rule):
	abide by the can't lock without a lock rule;
	abide by the can't lock what's already locked rule;
	abide by the can't lock what's open rule;
	abide by the need a matching key rule.
	
Carry out someone trying locking keylessly (this is the standard someone keylessly locking rule): 
	try the person asked trying locking the noun with the matching key of the noun.

Volume 3 - The Passkey kind, needed only if you want keys to name themselves

A passkey is a kind of thing. The specification of a passkey is "A kind of key whose inventory listing changes to reflect the player's knowledge about what it unlocks."

Definition: a passkey is identified if it unbolts something.

Unbolting relates one passkey to various things. The verb to unbolt (it unbolts, they unbolt, it unbolted, it is unbolted) implies the unbolting relation.


After printing the name of an identified passkey (called the item) while taking inventory:
	say " (che apre [the list of things unbolted by the item])";
	
After examining an identified passkey (this is the passkey description rule):
	say "[The noun] sblocca [the list of things unbolted by the noun]."
	
Carry out unlocking something with a passkey (this is the standard passkey unlocking rule):
	if the second noun is the matching key of the noun, now the second noun unbolts the noun.
	
Report someone trying unlocking something with a passkey (this is the observe someone unlocking rule):
	now the second noun unbolts the noun.

Volume 4 - The Keychain kind, needed only if you want a keychain


A keychain is a kind of supporter that is portable. The specification of a keychain is "A keychain which can hold the player's keys without forcing the player to take them off the ring in order to unlock things."

Instead of putting something which is not a passkey on a keychain (this is the limiting keychains rule):
	say "[The noun] non è una chiave."

Procedural rule when putting something on a keychain (this is the allow putting things on the keychain rule):
	ignore the can't put onto something being carried rule. 

Procedural rule for locking something with something which is on a keychain (called target) (this is the allow locking access to keys on a chain rule):
	substitute the keychain carrying rule for the carrying requirements rule.

Procedural rule for unlocking something with something which is on a keychain (called target) (this is the allow unlocking access to keys on a chain  rule):
	substitute the keychain carrying rule for the carrying requirements rule.

This is the keychain carrying rule:
	if the player is carrying the second noun, continue the action;
	if the second noun is on a keychain (called target):
		if the player is carrying the target:
			continue the action;
		otherwise:
			if the player can see the target:
				if using the sequential action option:
					try taking the target;
				otherwise:
					say "(prima prendi [the target])[command clarification break]";
					try silently taking the target;
			if the player is carrying the target, continue the action;
	stop the action.

Understand "metti [passkey] su [keychain]" as putting it on.

After examining a keychain which supports something (this is the list included keys rule):
	say "Su [the noun] [is-are a list of passkeys which are on the noun]."

Rule for deciding whether all includes passkeys which are on a keychain (this is the don't strip keys rule): 
	if the second noun is not a keychain, it does not.

Volume 5 - Support Materials

This is the noun autotaking rule:
	if using the sequential action option:
		if the player is the person asked:
			try taking the noun;
		otherwise:
			try the person asked trying taking the noun;
	otherwise:
		if the player is the person asked:
			say "(prima prendi [the noun])";
			silently try taking the noun;
		otherwise:
			try the person asked trying taking the noun.
	
This is the second noun autotaking rule:
	if using the sequential action option:
		if the player is the person asked:
			try taking the second noun;
		otherwise:
			try the person asked trying taking the second noun;
	otherwise:
		if the player is the person asked:
			say "(prima prendi [the second noun])";
			silently try taking the second noun;
		otherwise:
			try the person asked trying taking the second noun.
	
This is the must hold the noun rule:
	if the person asked does not have the noun, follow the noun autotaking rule;
	if the person asked does not have the noun, stop the action; 
	make no decision.

This is the must hold the second noun rule:
	if the person asked does not have the second noun, follow the second noun autotaking rule;
	if the person asked does not have the second noun, stop the action;
	make no decision.

This is the must have accessible the noun rule:
	if the noun is not key-accessible:
		if the noun is on a keychain (called the containing keychain), change the noun to the containing keychain;
		follow the noun autotaking rule;
	if the noun is not key-accessible:
		if the player is the person asked,
			say "Senza avere [the noun], non puoi fare nulla.";
		stop the action;
	make no decision.

This is the must have accessible the second noun rule:
	if the second noun is not key-accessible:
		if the second noun is on a keychain (called the containing keychain),
			change the second noun to the containing keychain;
		follow the second noun autotaking rule;
	if the second noun is not key-accessible:
		if the player is the person asked,
			say "Senza avere [the second noun], non puoi fare nulla.";
		stop the action;
	make no decision.


Volume 6 - Unlocking all - Not for release

Understand "unlockall" as universal unlocking.

Universal unlocking is an action applying to nothing.

Carry out universal unlocking (this is the lock debugging rule):
	repeat with item running through locked things:
		now the item is unlocked;
		say "Unlocking [the item]."

Report universal unlocking (this is the report universal unlocking rule):
	say "A loud stereophonic click assures you that everything in the game has been unlocked."

Locksmith IT ends here.

---- DOCUMENTATION ----

NOTA: Questa è una lieve modifica dell'estensione originale Locksmith di Emily Short. Ho solo tradotto i testi.

Per la documentazione completa vedi l'estensione originale.
