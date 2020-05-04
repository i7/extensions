Version 11 of Implicit Actions IT by Leonardo Boselli begins here.

"Provides implicit taking, opening, closing, locking and unlocking actions for a variety of cases where this makes for smoother game play. The extension also defines phrases which make it easy to define additional implicit actions if desired. Version 11 can be used with Locksmith by Emily Short (although Implicit Actions covers most of what Locksmith does, and in most cases it will be better to use Implicit Actions without Locksmith). Requires Plurality by Emily Short and Version 4 of Text Capture by Eric Eve."

"basato su Implicit Actions by Eric Eve."

Include Italian by Leonardo Boselli.
Include Version 4 of Text Capture by Eric Eve.
[Include Plurality by Emily Short.]

Volume 1 -  Implicit Action Framework


Book 1 - The Precondition Rulebook

The precondition rules are a rulebook 

This is the precondition stage rule: abide by the precondition rules.

The precondition stage rule is listed before the basic accessibility rule in the action-processing rules.


Book 2 - Global Variables

implicit action stack depth is a number that varies.
implicit action report is an indexed text that varies.
implicit action failure is a truth state that varies.
implicit action attempted is a truth state that varies.
parenthesize implicit actions is a truth state that varies.
parenthesize implicit actions is true.

Book 3 - Phrases

To say implicit action summary:
  if parenthesize implicit actions is true then
     say "(prima [implicit action report])[command clarification  break]";
  otherwise  say "[implicit action report].";  
  change implicit action failure to false;
  change implicit action report to "".

To initialize the implicit action:
   if the implicit action stack depth is 0 begin; 
       change implicit action failure to false;      
       change implicit action attempted to true;
       start capturing text;
   end if;
   increase the implicit action stack depth by 1.

To finish the implicit action with participle (partc - some text) infinitive (inf - some text) object (obj - an indexed text) and condition (cond - a truth state):
  decrease the implicit action stack depth by 1;
  if the implicit action stack depth is 0, stop capturing text;
  if implicit action failure is false begin;
  if parenthesize implicit actions is true then
     change the implicit action report to "[implicit action report][if number of characters in implicit action report > 0], poi [end if][if cond is true][partc][otherwise]cerca di [inf][end if] [obj]";
  otherwise change the implicit action report to "[implicit action report][if number of characters in implicit action report > 0], poi [end if][if cond is false]cerca di [end if][inf] [obj]";
  end if;
  if cond is false, change implicit action failure to true;  
  if the implicit action stack depth is 0 begin;
    say "[implicit action summary]";
    if cond is false,  say "[captured text]";   
  end if.

To abort the implicit action with message (txt - some text):
    if text capturing is active, say "[txt][line break]";
    otherwise change implicit action attempted to false.
 
To abort the implicit action:
    change implicit action attempted to false.


Book 4 - Activities

Part 1 - Implicit Opening

Implicitly opening something is an activity.

Rule for implicitly opening something (called the obstructor) (this is the implicit opening rule):
   initialize the implicit action;
   silently try opening the obstructor;  
   finish the implicit action with participle "apri" infinitive "aprire" object "[the obstructor]" and condition (whether or not the obstructor is open).


Part 2 - Implicit Unlocking

Implicitly unlocking something is an activity.

Rule for implicitly unlocking something (called the obstructor) (this is the implicit unlocking rule):         
      let the appropriate-key be the known-key of the obstructor;
      if the matching key of the obstructor is not no-key and the appropriate-key is not visible begin; 
         say "[don't have right key for obstructor].";
         rule fails;
      end if;
      initialize the implicit action;
      if the matching key of the obstructor is no-key then
         silently try unbolting the obstructor;
      otherwise
         silently try unlocking the obstructor with the appropriate-key;  
      finish the implicit action with participle "sblocchi" infinitive "sbloccare" object "[the obstructor][if the appropriate-key is not no-key] [con-prep the appropriate-key][end if]" and condition (whether or not the obstructor is unlocked).

To say don't have right key for (obstructor - an object):
   say "Non sembra che tu abbia la chiave giusta"


Part 3 - Implicit Taking

Rule for implicitly taking something (called the object desired) (this is the implicit taking rule):  
  initialize the implicit action;
  silently try taking the object desired;  
  finish the implicit action with participle "prendi" infinitive "prendere" object "[the object desired]" and condition (whether or not the object desired is carried).


Part 4 - Implicit Closing

implicitly closing something is an activity.

Rule for implicitly closing something (called the obj) (this is the implicit closing rule):
  initialize the implicit action;
  silently try closing the obj;
  finish the implicit action with participle "chiudi" infinitive "chiudere" object "[the obj]" and condition (whether or not the obj is closed).


Part 5 - Implicit Exiting

implicitly exiting something is an activity.

Rule for implicitly exiting something (called the nested room) (this is the implicit exiting rule):
  initialize the implicit action;   
  let outer-nested be the holder of the nested room;
  while outer-nested is not a room begin;
     increase the implicit action stack depth by 1;
     silently try exiting;    
     finish the implicit action with participle "lascia" infinitive "lasciare" object "[the nested room]" and condition (whether or not the player is not in the nested room);
     change the nested room to outer-nested;
     change outer-nested to the holder of the nested room;
  end while; 
  silently try exiting;  
  finish the implicit action with participle "lascia" infinitive "lasciare" object "[the nested room]" and condition (whether or not the player is in the location).


Book 3 - Precondition Rules Using Implicit Actions

Part 1 - General

Precondition for taking something when the noun is inside a closed container (called the receptacle) (this is the open before taking contents rule):
  carry out the implicitly opening activity with the receptacle;
  if the receptacle is closed and implicit action attempted is true, stop the action.


Precondition for putting something on something when the noun is not carried (this is the take object before putting it on rule):
  if the noun is on the second noun then
    say "[The noun] [is|are] già [su-prep the second noun]." instead;
 carry out the implicitly taking activity with the noun;
 if the noun is not carried and implicit action attempted is true then stop the action.

   
Precondition for inserting something into something when the noun is not carried (this is the take object before inserting it into rule):
  if the noun is in the second noun then
    say "[The noun] [is|are] già dentro [the second noun]." instead;
 carry out the implicitly taking activity with the noun;
 if the noun is not carried and implicit action attempted is true then stop the action.


Precondition for inserting something into something when the second noun is an openable closed container (this is the open container before inserting rule):
  carry out the implicitly opening activity with the second noun;
  if the second noun is closed and implicit action attempted is true then stop the action.


Precondition for searching a closed openable opaque container (this is the open container before searching rule):
  carry out the implicitly opening activity with the noun;
  if the noun is closed and implicit action attempted is true then stop the action.


Precondition for going from a room when the holder of the player is not a room (this is the exit holder before leaving room rule):
  carry out the implicitly exiting activity with the holder of the player;
  if the holder of the player is not a room and implicit action attempted is true, stop the action.


Part 2 - Locks and Door (for use without Locksmith by Emily Short)

Precondition for unlocking something with something when the second noun is not carried (this is the take key before unlocking rule):
  if the holder of the second noun is a keyring, let the item needed be the holder of the second noun;
  otherwise let the item needed be the second noun;
  if the item needed is carried, continue the action;
  carry out the implicitly taking activity with the item needed;
  if the item needed is not carried and implicit action attempted is true, stop the action.

Precondition for locking something with something when the second noun is not carried (this is the take key before locking rule):
  if the holder of the second noun is a keyring, let the item needed be the holder of the second noun;
  otherwise let the item needed be the second noun;
  if the item needed is carried, continue the action;
  carry out the implicitly taking activity with the item needed;
  if the item needed is not carried and implicit action attempted is true, stop the action.


Precondition for locking something open with something (this is the close before locking rule):
  carry out the implicitly closing activity with the noun;
  if the noun is open and implicit action attempted is true, stop the action.
   

Precondition for going through a closed openable door (called the obstructor) (this is the open door before going through rule):
   carry out the implicitly opening activity with the obstructor;
   if the obstructor is closed and implicit action attempted is true, stop the action.


Precondition for opening something locked when the noun is lockable and the noun provides the property matching key and the matching key of the noun is the known-key of the noun (this is the unlock before opening rule):   
   if the matching key of the noun is no-key or the player can see the matching key of the noun begin;
      carry out the implicitly unlocking activity with the noun;
      if the noun is locked and implicit action attempted is true, stop the action;
   end if.


Volume 2 - Locks and Keys (for use without Locksmith by Emily Short)

Book 1 - Objects, Kinds and Properties

no-key is a thing.

A door has a thing called the known-key. The known-key of a door is usually no-key.

A container has a thing called the known-key. The known-key of a container is usually no-key.

A key is a kind of thing.
The specification of a key is "A key is an object that can be placed on a keyring. There is otherwise no need to make objects of kind key to allow them to function as keys, but doing so will help the parser make more intelligent choices in locking and unlocking actions."



A passkey is a kind of key. A passkey has a list of objects called the objects opened list.
The specification of a passkey is "The only difference between using a passkey and an ordinary thing to lock and unlock containers and doors is that a passkey displays a list of what it is known to lock and unlock, both when it is described and in inventory listings."

Definition: a passkey is identified if the number of entries in the objects opened list of it > 0.

After examining an identified passkey (this is the passkey description rule): 
  say "[The noun] sblocca [the objects opened list of the noun with definite articles]."


After printing the name of an identified passkey (called the item) while taking inventory (this is the name passkey in inventory rule):
	say " (che apre [the objects opened list of the item with definite articles])";

When play begins (this is the initialize passkey rule):
   repeat with cur running through lockable things begin;
      if the known-key of cur is a passkey then
        add cur to the objects opened list of the known-key of cur;
   end repeat.


Book 2 - Noting the Effect of Locking and Unlocking

carry out unlocking something with something (this is the note the known-key when unlocking rule):
  change the known-key of the noun to the second noun.

carry out locking something with something (this is the note the known-key when locking rule):
  change the known-key of the noun to the second noun.

carry out unlocking something with a passkey (this is the note unlocking with passkey rule):
  add the noun to the objects opened list of the second noun, if absent.

carry out locking something with a passkey (this is the note locking with passkey rule):
  add the noun to the objects opened list of the second noun, if absent.


Book 3 - The Bolting Action

Part 1 - Defining Bolting

bolting is an action applying to one thing.
unbolting is an action applying to one thing.

The specification of the bolting action is "The bolting action (corresponding to LOCK SOMETHING) can be used in two ways. If the object to be locked has a known-key, and the known-key is available to the player, then LOCK WHATEVR with be redirected to LOCK WHATEVER WITH KNOWN KEY. If the object to be locked has a matching key of no-key, then it doesn't need a key to lock it, so that LOCK WHATEVER will simply go ahead and lock it."

The specification of the unbolting action is "The unbolting action (corresponding to UNLOCK SOMETHING) can be used in two ways. If the object to be unlocked has a known-key, and the known-key is available to the player, then UNLOCK WHATEVR with be redirected to UNLOCK WHATEVER WITH KNOWN KEY. If the object to be unlocked has a matching key of no-key, then it doesn't need a key to unlock it, so that UNLOCK WHATEVER will simply go ahead and unlock it."


Understand "sblocca [something]" or "sblocca [art-det] [something]" as unbolting.
Understand "sblocca [door]" or "sblocca [art-det] [door]" as unbolting.
Understand "sblocca [locked door]" or "sblocca [art-det] [locked door]" as unbolting.
Understand "sblocca [container]" or "sblocca [art-det] [container]" as unbolting.
Understand "sblocca [locked container]" or "sblocca [art-det] [locked container]" as unbolting.

Understand "blocca [something]" or "blocca [art-det] [something]" as bolting.
Understand "blocca [door]" or "blocca [art-det] [door]" as bolting.
Understand "blocca [unlocked door]" or "blocca [art-det] [unlocked door]" as bolting.
Understand "blocca [container]" or "blocca [art-det] [container]" as bolting.
Understand "blocca [unlocked container]" or "blocca [art-det] [unlocked container]" as bolting.

Part 2 - Rules for Bolting and Unbolting

Chapter 1 - Unbolting Rules

Before unbolting something lockable when the noun provides the property matching key and the known-key of the noun is not no-key and the known-key of the noun is touchable (this is the convert unbolt to unlock with rule):
   say "([con-prep the known-key of the noun])[command clarification break]";
   try unlocking the noun with the known-key of the noun instead.
 
Check an actor unbolting an unlocked lockable thing (this is the can't unbolt something unlocked rule):
  if the actor is visible,  say "[The noun] non [is|are] bloccat[genderity]." instead;
  otherwise stop the action.

Check an actor unbolting something lockable when the noun provides the property matching key and the matching key of the noun is not no-key (this is the can't unbolt without a key rule):
  if the actor has a key (called the trial-key) and the actor is the player begin;
     say "([con-prep the trial-key])[command clarification break]";
     try unlocking the noun with the trial-key instead;
  end if;
  if the actor is the player,  say "Hai bisogno di una chiave per sbloccare [the noun]." instead;
  otherwise stop the action.

Check an actor unbolting something that is not lockable (this is the can't unbolt ordinary objects rule):
  if the actor is the player, say "[The noun] non [is|are] qualcosa che puoi sbloccare." instead;
  otherwise stop the action.
 
Check an actor unbolting something lockable when the noun does not provide the property matching key (this is the can't unbolt without matching key rule):
  say "Non è chiaro come si può fare." instead.
 
Carry out an actor unbolting something (this is the standard unbolting rule):
   change the noun to unlocked.

Report unbolting something (this is the report unbolting rule):
  say "Sblocchi [the noun]."

Report someone unbolting something (this is the report npc unbolting rule):
  if the actor is visible, say "[The actor] sblocca [the noun]."


Chapter 2 - Bolting Rules

Before bolting something lockable when the known-key of the noun is touchable (this is the convert bolt to lock with rule):
  say "([con-prep the known-key of the noun])[command clarification break]";
   try locking the noun with the known-key of the noun instead.

Precondition for bolting an open lockable thing when the noun provides the property matching key and the matching key of the noun is no-key:
  carry out the implicitly closing activity with the noun;
  if the noun is open, stop the action.

Check an actor bolting something that is not lockable (this is the can't bolt ordinary objects rule):
  if the actor is the player, abide by the can't lock without a lock rule;
  otherwise stop the action.
 
Check an actor bolting a locked lockable thing (this is the can't bolt something locked rule):
  if the player is the actor, abide by the can't lock what's already locked rule;
  otherwise stop the action.

Check an actor bolting something lockable when the noun provides the property matching key and the matching key of the noun is not no-key (this is the can't bolt without key rule):
   if the actor is the player, say "Ti manca la chiave necessaria." instead;
   otherwise stop the action.

Check an actor bolting something lockable when the noun does not provide the property matching key (this is the can't bolt without matching key rule):
   say "Non è chiaro come si può fare." instead.

Carry out an actor bolting something (this is the standard bolting rule):
  change the noun to locked.

Report bolting something (this is the report bolting rule):
  say "Blocchi [the noun]."

Report someone bolting something (this is the report npc bolting rule):
  if the actor is visible, say "[The actor] blocca [the noun]."



Chapter 3 - Rules for Using a Key on Something that Doesn't Need One

Check unlocking something lockable with something when the noun provides the property matching key and the matching key of the noun is no-key (this is the object doesn't need a key to unlock rule):
   say "Non hai bisogno di una chiave per bloccare [the noun]." instead.

Check locking something lockable with something when the noun provides the property matching key and the matching key of the noun is no-key (this is the object doesn't need a key to lock rule):
   say "Non hai bisogno di una chiave per bloccare [the noun]." instead.

Chapter 4a - Disambigution (for use with Disambiguation Control by Jon Ingold)

Should the game suggest unlocking a door with something (this is the suggest key for unlocking door rule):
  if the noun is not lockable, it is a bad suggestion;
  if the second noun is the known-key of the noun and the noun is locked, it is an excellent suggestion;
  if the second noun is the known-key of the noun or the noun is locked, it is a good suggestion;   
  it is a passable suggestion.

Should the game suggest unlocking a container with something (this is the suggest key for unlocking container rule):
  if the noun is not lockable, it is a bad suggestion;
  if the second noun is the known-key of the noun and the noun is locked, it is an excellent suggestion;
  if the second noun is the known-key of the noun or the noun is locked, it is a good suggestion;   
  it is a passable suggestion.

Should the game suggest locking a door with something (this is the suggest key for locking door rule):
  if the noun is not lockable, it is a bad suggestion;
  if the second noun is the known-key of the noun and the noun is unlocked, it is an excellent suggestion;
  if the second noun is the known-key of the noun or the noun is unlocked, it is a good suggestion;   
  it is a passable suggestion.

Should the game suggest locking a container with something (this is the suggest key for locking container rule):
  if the noun is not lockable, it is a bad suggestion;
  if the second noun is the known-key of the noun and the noun is unlocked, it is an excellent suggestion;
  if the second noun is the known-key of the noun or the noun is unlocked, it is a good suggestion;   
  it is a passable suggestion.


Should the game suggest bolting an unlocked lockable thing (this is the suggest bolting something unlocked rule):
  it is a good suggestion.

Should the game suggest bolting a locked lockable thing (this is the passably suggest bolting something locked rule):
  it is a passable suggestion.

Should the game suggest bolting something that is not lockable (this is the don't suggest bolting something unlockable rule):
  it is a bad suggestion.

Should the game suggest unbolting a locked lockable thing (this is the suggest unbolting something unlocked rule):
  it is a good suggestion.

Should the game suggest unbolting an unlocked lockable thing (this is the passably unsuggest bolting something locked rule):
  it is a passable suggestion.

Should the game suggest unbolting something that is not lockable (this is the don't unsuggest bolting something unlockable rule):
  it is a bad suggestion.





Chapter 4b - Disambiguation (for use without Disambiguation Control by Jon Ingold)

Does the player mean unlocking something lockable with a key: it is likely.
Does the player mean locking something lockable with a key: it is likely.

Does the player mean bolting an unlocked lockable thing (this is the player probably means bolting something unlocked rule):
  it is likely.

Does the player mean bolting a locked lockable thing (this is the player might mean bolting something locked rule):
  it is possible.

Does the player mean bolting something that is not lockable (this is the player probably doesn't mean bolting something unlockable rule):
  it is unlikely.

Does the player mean unbolting a locked lockable thing (this is the player probably means unbolting something locked rule):
  it is likely.

Does the player mean unbolting an unlocked lockable thing (this is the player might mean unbolting something unlocked rule):
  it is possible.

Does the player mean unbolting something that is not lockable (this is the player probably doesn't mean unbolting something unlockable rule):
  it is unlikely.


Book 4 - The Keyring Kind

A keyring is a kind of supporter that is portable.

Check putting something on a keyring when the noun is not a key (this is the only keys can go on a keyring rule):
  say "[The noun] non si può mettere [su-prep the second noun]." instead.

This is the keyring-sensitive can't put onto something being carried rule:
  if the second noun is not a keyring, abide by the can't put onto something being carried rule.

The keyring-sensitive can't put onto something being carried rule is listed instead of the can't put onto something being carried rule in the check putting it on rules.


This is the keyring-sensitive carrying requirements rule:
  if (an actor locking something with something or an actor unlocking something with something) and the second noun is on a keyring, continue the action;
  otherwise abide by the carrying requirements rule.

The keyring-sensitive carrying requirements rule is listed instead of the carrying requirements rule in the the action-processing rules.

This is the keyring-sensitive can't lock without the correct key rule:
  if (the holder of the second noun is not the actor and the holder of the second noun is not a keyring carried by the actor) 
or the noun does not provide the property matching key 
or the matching key of the noun is not the second noun,
stop the action with library message locking it with action number 4 for the second noun.  


The keyring-sensitive can't lock without the correct key rule is listed instead of the can't lock without the correct key rule in the check locking it with rules.

This is the keyring-sensitive can't unlock without the correct key rule:
  if (the holder of the second noun is not the actor and the holder of the second noun is not a keyring carried by the actor) 
or the noun does not provide the property matching key 
or the matching key of the noun is not the second noun,
stop the action with library message unlocking it with action number 3 for the second noun..  


The keyring-sensitive can't unlock without the correct key rule is listed instead of the can't unlock without the correct key rule in the check unlocking it with rules.


Understand "metti [key] [su-art] [keyring]" or  "metti [art-det] [key] [su-art] [keyring]" as putting it on.


Implicit Actions IT ends here.

---- DOCUMENTATION ----

Vedi documentazione originale di Implicit Actions by Eric Eve.
