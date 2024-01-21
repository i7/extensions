Version 13.1 of Implicit Actions by Eric Eve begins here.

"Provides implicit taking, opening, closing, locking and unlocking actions for a variety of cases where this makes for smoother game play. The extension also defines phrases which make it easy to define additional implicit actions if desired. Version 11 can be used with Locksmith by Emily Short (although Implicit Actions covers most of what Locksmith does, and in most cases it will be better to use Implicit Actions without Locksmith). Requires  Version 8.1 (or above) of Text Capture by Eric Eve."

Include Version 8.1 of Text Capture by Eric Eve.

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
  if parenthesize implicit actions is true, 
       say "(first [implicit action report])[command clarification  break]";
  otherwise  say "[We] [implicit action report].";  
  now implicit action failure is false;
  now implicit action report is "".

To initialize the implicit action:
   if the implicit action stack depth is 0 begin; 
       now implicit action failure is false;      
       now implicit action attempted is true;
       start capturing text;
   end if;
   increase the implicit action stack depth by 1.

To finish the implicit action with participle (partc - some text) infinitive (inf - some text) object (obj - an indexed text) and condition (cond - a truth state):
  decrease the implicit action stack depth by 1;
  if the implicit action stack depth is 0, stop capturing text;
  if implicit action failure is false begin;
  if parenthesize implicit actions is true,
     now the implicit action report is "[implicit action report][if number of characters in implicit action report > 0], then [end if][if cond is true][partc][otherwise]trying to [inf][end if] [obj]";
  otherwise now the implicit action report is "[implicit action report][if number of characters in implicit action report > 0], then [end if][if cond is false]try to [end if][inf] [obj]";
  end if;
  if cond is false, now implicit action failure is true;  
  if the implicit action stack depth is 0 begin;
    say "[implicit action summary]";
    if cond is false,  say "[captured text]";   
  end if.

To abort the implicit action with message (txt - some text):
    if text capturing is active, say "[txt][line break]";
    otherwise now implicit action attempted is false.
 
To abort the implicit action:
    now implicit action attempted is false.


Book 4 - Activities

Part 1 - Implicit Opening

Implicitly opening something is an activity.

Rule for implicitly opening something (called the obstructor) (this is the implicit opening rule):
   initialize the implicit action;
   silently try opening the obstructor;  
   finish the implicit action with participle "opening" infinitive "open" object "[the obstructor]" and condition (whether or not the obstructor is open).


Part 2 - Implicit Unlocking (for use without Locksmith by Emily Short)

Implicitly unlocking something is an activity.

Rule for implicitly unlocking something (called the obstructor) (this is the implicit unlocking rule):         
      let the appropriate-key be the known-key of the obstructor;
      if the matching key of the obstructor is not no-key and the appropriate-key is not visible begin; 
         say "[We] [don't] seem to have the right key." (A);
         rule fails;
      end if;
      initialize the implicit action;
      if the matching key of the obstructor is no-key,
         silently try unbolting the obstructor;
      otherwise
         silently try unlocking the obstructor with the appropriate-key;  
      finish the implicit action with participle "unlocking" infinitive "unlock" object "[the obstructor][if the appropriate-key is not no-key] with [the appropriate-key][end if]" and condition (whether or not the obstructor is unlocked).


Part 3 - Implicit Taking

Rule for implicitly taking something (called the object desired) (this is the implicit taking rule):  
  initialize the implicit action;
  silently try taking the object desired;  
  finish the implicit action with participle "taking" infinitive "take" object "[the object desired]" and condition (whether or not the object desired is carried).


Part 4 - Implicit Closing

implicitly closing something is an activity.

Rule for implicitly closing something (called the obj) (this is the implicit closing rule):
  initialize the implicit action;
  silently try closing the obj;
  finish the implicit action with participle "closing" infinitive "close" object "[the obj]" and condition (whether or not the obj is closed).


Part 5 - Implicit Exiting

implicitly exiting something is an activity.

Rule for implicitly exiting something (called the nested room) (this is the implicit exiting rule):
  initialize the implicit action;   
  let outer-nested be the holder of the nested room;
  while outer-nested is not a room begin;
     increase the implicit action stack depth by 1;
     silently try exiting;    
     finish the implicit action with participle "leaving" infinitive "leave" object "[the nested room]" and condition (whether or not the player is not in the nested room);
     now the nested room is outer-nested;
     now outer-nested is the holder of the nested room;
  end while; 
  silently try exiting;  
  finish the implicit action with participle "leaving" infinitive "leave" object "[the nested room]" and condition (whether or not the player is in the location).


Book 3 - Precondition Rules Using Implicit Actions

Part 1 - General

Precondition for taking something when the noun is inside a closed container (called the receptacle) (this is the open before taking contents rule):
  carry out the implicitly opening activity with the receptacle;
  if the receptacle is closed and implicit action attempted is true, stop the action.


Precondition for putting something on something when the noun is not carried (this is the take object before putting it on rule):
  if the noun is on the second noun,
    say "[The noun] [are] already on [the second noun]." (A) instead;
 carry out the implicitly taking activity with the noun;
 if the noun is not carried and implicit action attempted is true, stop the action.

   
Precondition for inserting something into something when the noun is not carried (this is the take object before inserting it into rule):
  if the noun is in the second noun,
    say "[The noun] [are] already in [the second noun]." (A) instead;
 carry out the implicitly taking activity with the noun;
 if the noun is not carried and implicit action attempted is true, stop the action.


Precondition for inserting something into something when the second noun is an openable closed container (this is the open container before inserting rule):
  carry out the implicitly opening activity with the second noun;
  if the second noun is closed and implicit action attempted is true, stop the action.


Precondition for searching a closed openable opaque container (this is the open container before searching rule):
  carry out the implicitly opening activity with the noun;
  if the noun is closed and implicit action attempted is true, stop the action.


Precondition for going from a room when the holder of the player is not a room (this is the exit holder before leaving room rule):
  carry out the implicitly exiting activity with the holder of the player;
  if the holder of the player is not a room and implicit action attempted is true, stop the action.


Part 2 - Locks and Door (for use without Locksmith by Emily Short)

Precondition for unlocking something with something when the second noun is not carried (this is the take key before unlocking rule):
  let the item needed be the noun;
  if the holder of the second noun is a keyring, let the item needed be the holder of the second noun;
  otherwise let the item needed be the second noun;
  if the item needed is carried, continue the action;
  carry out the implicitly taking activity with the item needed;
  if the item needed is not carried and implicit action attempted is true, stop the action.

Precondition for locking something with something when the second noun is not carried (this is the take key before locking rule):
  let the item needed be the noun;
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


Book 4 - Overriding Implicit Actions in the Standard Rules

[ This is to avoid having the Standard Rules duplicated the functionality of Implicit Actions, and to stop it carrying out implicit actions a game author
   wishes to abort. ]

The revised can’t insert what’s not held rule is listed instead of the can't insert what's not held rule in the check inserting it into rules.

Check an actor inserting something into (this is the revised can’t insert what’s not held rule):
if the actor is carrying the noun, continue the action;
if the actor is wearing the noun, continue the action;
stop the action.

the revised can’t put what’s not held rule is listed instead of The can't put what's not held rule in the check putting it on rules.

Check an actor putting something on (this is the revised can’t put what’s not held rule):
if the actor is carrying the noun, continue the action;
if the actor is wearing the noun, continue the action;
say "[text of  can't wear what's not held rule response (A)]" (A);
stop the action.

Check an actor going (this is the revised can’t go through closed doors rule):
if the door gone through is not nothing and the door gone through is closed, stop the action.

the revised can’t go through closed doors rule is listed instead of the can’t go through closed doors rule in the check going rules.

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
  say "[The noun] [unlock] [the objects opened list of the noun with definite articles]." (A).


After printing the name of an identified passkey (called the item) while taking inventory (this is the name passkey in inventory rule):
	say " (which [regarding the item] [open] [the objects opened list of the item with definite articles])" (A).

When play begins (this is the initialize passkey rule):
   repeat with cur running through lockable things begin;
      if the known-key of cur is a passkey,
        add cur to the objects opened list of the known-key of cur;
   end repeat.


Book 2 - Noting the Effect of Locking and Unlocking

carry out unlocking something with something (this is the note the known-key when unlocking rule):
  now the known-key of the noun is the second noun.

carry out locking something with something (this is the note the known-key when locking rule):
  now the known-key of the noun is the second noun.

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


Understand "unlock [something]" as unbolting.
Understand "unlock [door]" as unbolting.
Understand "unlock [locked door]" as unbolting.
Understand "unlock [container]" as unbolting.
Understand "unlock [locked container]" as unbolting.

Understand "lock [something]" as bolting.
Understand "lock [door]" as bolting.
Understand "lock [unlocked door]" as bolting.
Understand "lock [container]" as bolting.
Understand "lock [unlocked container]" as bolting.

Part 2 - Rules for Bolting and Unbolting

Chapter 1 - Unbolting Rules

Before unbolting something lockable when the noun provides the property matching key and the known-key of the noun is not no-key and the known-key of the noun is touchable (this is the convert unbolt to unlock with rule):
   say "(with [the known-key of the noun])[command clarification break]";
   try unlocking the noun with the known-key of the noun instead.
 
Check an actor unbolting an unlocked lockable thing (this is the can't unbolt something unlocked rule):
  if the actor is visible,  say "[The noun] [are not] locked." instead;
  otherwise stop the action.

Check an actor unbolting something lockable when the noun provides the property matching key and the matching key of the noun is not no-key (this is the can't unbolt without a key rule):
  if the actor has a key (called the trial-key) and the actor is the player begin;
     say "(with [the trial-key])[command clarification break]";
     try unlocking the noun with the trial-key instead;
  end if;
  if the actor is the player,  say "[We] [need] a key to unlock [the noun]." (A) instead;
  otherwise stop the action.

Check an actor unbolting something that is not lockable (this is the can't unbolt ordinary objects rule):
  if the actor is the player, say "[regarding the noun][Those] [are] not something [we] [can] unlock." (A) instead;
  otherwise stop the action.
 
Check an actor unbolting something lockable when the noun does not provide the property matching key (this is the can't unbolt without matching key rule):
  say "[It's] not immediately clear how to do that." (A) instead.
 
Carry out an actor unbolting something (this is the standard unbolting rule):
   now the noun is unlocked.

Report unbolting something (this is the report unbolting rule):
  say "[We] [unlock] [the noun]." (A).

Report someone unbolting something (this is the report npc unbolting rule):
  if the actor is visible, say "[The actor] [unlock] [the noun]." (A).


Chapter 2 - Bolting Rules

Before bolting something lockable when the known-key of the noun is touchable (this is the convert bolt to lock with rule):
  say "(with [the known-key of the noun])[command clarification break]" (A);
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
   if the actor is the player, say "[We] [lack] the appropriate key." (A) instead;
   otherwise stop the action.

Check an actor bolting something lockable when the noun does not provide the property matching key (this is the can't bolt without matching key rule):
   say "[It's] not immediately clear how to do that." (A) instead.

Carry out an actor bolting something (this is the standard bolting rule):
  now the noun is locked.

Report bolting something (this is the report bolting rule):
  say "[We] [lock] [the noun]." (A).

Report someone bolting something (this is the report npc bolting rule):
  if the actor is visible, say "[The actor] [lock] [the noun]."



Chapter 3 - Rules for Using a Key on Something that Doesn't Need One

Check unlocking something lockable with something when the noun provides the property matching key and the matching key of the noun is no-key (this is the object doesn't need a key to unlock rule):
   say "[We] [don't] need a key to unlock [the noun]." (A) instead.

Check locking something lockable with something when the noun provides the property matching key and the matching key of the noun is no-key (this is the object doesn't need a key to lock rule):
   say "[We] [don't] need a key to lock [the noun]." (A) instead.

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
  say "[Regarding the noun] [Those] [won't] fit on [the second noun]." instead.




This is the keyring-sensitive carrying requirements rule:
  if (an actor locking something with something or an actor unlocking something with something) and the second noun is on a keyring, continue the action;
  otherwise abide by the carrying requirements rule.

The keyring-sensitive carrying requirements rule is listed instead of the carrying requirements rule in the the action-processing rules.

This is the keyring-sensitive can't lock without the correct key rule:
	if (the holder of the second noun is not the actor and the holder of the second noun is not a keyring carried by the actor) 
	or the noun does not provide the property matching key 
	or the matching key of the noun is not the second noun:
		say "[text of can't lock without the correct key rule response (A)]" (A);
		stop the action.  


The keyring-sensitive can't lock without the correct key rule is listed instead of the can't lock without the correct key rule in the check locking it with rules.

This is the keyring-sensitive can't unlock without the correct key rule:
	if (the holder of the second noun is not the actor and the holder of the second noun is not a keyring carried by the actor) 
	or the noun does not provide the property matching key 
	or the matching key of the noun is not the second noun:
		say "[text of can't unlock without the correct key rule response (A)]" (A);
		stop the action.  


The keyring-sensitive can't unlock without the correct key rule is listed instead of the can't unlock without the correct key rule in the check unlocking it with rules.


Understand "put [key] on [keyring]" as putting it on.


Implicit Actions  ends here.

---- DOCUMENTATION ----

Chapter: The Basics - A Set of Implicit Actions

Section: Introduction - Using Impicit Actions

The documentation of this extension may look quite long, but that's because it has quite a few features to explain, not because it's hard to use if we just want to use its functionality "out of the box". To do that, we just need the line:

	*: Include Implicit Actions by Eric Eve

At the start of our code, and we'll get all (or most) of the benefits of this extension without further ado. The rest of this documentation explains what those benefits are how we can extend them.


Section: What's New in Version 10

Previously Implicit Actions used the before rules to trigger implicit actions. Version 10 implements a new rulebook, the precondition rules, for this purpose. The precondition rules run between the Before rules and the Instead rules, in fact just before the basic accessibility rule. This is both because they are the same kind of thing as other rules inserted at this point (for example the carrying requirements rule which the Standard Rules uses to perform some implicit takes is located around this stage), and also, more pragmatically, because it should make it easier to write Before rules that are certain to pre-empt implicit actions, which may sometimes be necessary.

Section: What's New in Version 11

Previous versions of Implicit Actions could not be used with Locksmith by Emily Short. Version 11 can be used with Locksmith, in which case it leaves Locksmith to do all the handling of locks and doors. On the other hand if Implicit Actions is used there should be no need for Locksmith, since if Locksmith is not present Implicit Actions will provide similar functionality in a manner more consistent with the rest of Implicit Actions.

Section: What's New in Version 12

Version 12 makes no change to the functionality of Implicit Actions, but makes several changes both to the extension code and to the examples to avoid using Inform features that became deprecated in release 6E59. This should help to ensure that Implicit Actions continues to be usable with whatever future release of Inform withdraws the deprecated features.

Release 6E59 of Inform introduced its own implicit action handling for inserting objects into containers, putting objects on supporters, and going through closed doors. The Implicit Actions extension replaces the Standard Library rules that carry out these implicit actions with its own versions to avoid clashes and duplications.

Section: Common Cases of Implicit Action

There are many common situations in Interactive Fiction where an action is annoyingly prevented because some other completely obvious action has not been carried out. We want to put the diamond in the jewel case, but we're told we have to be holding it first (even though it's right there in front of us). We want to leave to the north, but we're told we can't because the front door is in the way, even though the door isn't locked and it should be obvious that we want to open it in order to go through it. Interactive Fiction is a much smoother and less frustrating experience if these kinds of obvious action are carried out for us. Actions that are carried out in order to allow other actions to go ahead are called "implicit actions". The Implicit Actions extension defines a number of these, and all we have to do is to include the extension in our game to enjoy the benefit of them.

In particular, the extension provides implicit actions for the following cases:

1. If we want to search a container that's closed, the game will first try to open it for us.

2. If we want to put something in a container that's closed, the game will first try to open it for us.

3. If we want to go through a door that's closed, the game will first try to open it for us.

4. If we want to open a door or a container that's locked, the game will first try to unlock it for us.

5. If we want to put something we're not holding into or onto something, the game will first try to take it for us.

6. If we want to leave the room while we're in an enterable container or on an enterable supporter, the game will first try to take us out of it.

7. If we want to take something that's inside a closed transparent container, the game will first try to open the container for us.

8. If we want to use a key to lock or unlock something but we're not carrying the key (although it's within reach), the game will first try to take it for us.

Note that Inform release 6E59 increases the range of implicit actions carried out by the Standard Rules, which may reduce the need for the Implicit Actions extension in some cases. Implicit Actions nevertheless extends the range of implicit actions further than does the Standard Rules and provides for better reporting of implicit actions. It also provides a franework for creating further implicit actions.

Section: Chains of Actions

Sometimes more than one implicit action may need to be carried out before we can go ahead with the command the player actually ordered. For example, suppose we want to go north through a locked door, the key to which is lying in plain sight on the table. To go through the door we first need to open it, to open it we first need to unlock it, and to unlock it we first need to take the key. The design of this extension allows each implicit action to trigger a further implicit action in turn. When there's a chain of actions like this, where each is needed to allow the next to be performed, the extension also combines all the implicit action into a single report, so that what we'd see is something like:

	>n
	(first taking the key, then unlocking the door with the key, then opening the door)

	Front Garden
	The house lies to the south...

Note that although the extension can combine a chain of implicit actions (up to any practicable) length into a single report like this, it cannot do the same with a sequence of implicit actions that are mutually independent. For example, if the player character is in a chair and needs to go through a closed door in order to leave the room, both leaving the chair and opening the door are implicit actions that need to be carried out to let us leave the room, but neither depends on the other. So what we get in this case is:

	>n
	(first leaving the chair)
	(first opening the door)
	

Rather than the neater:

	>n
	(first leaving the chair, then opening the door)

Although it may have been possible to have made the extension do the latter, the gain in neatness would probably not justify the increase in complexity (for the user as much as the author!). Moreover, the present system does have the slight advantage of making it clear which implicit actions are chained (each dependent on the one before) as opposed to simply carried out in sequence (with no dependence between them).

Section: Success and Failure

We have so far assumed that all implicit actions succeed, but that's not necessarily the case. Suppose we try to go north through a closed door which is also locked, and the key needed to unlock it is nowhere in sight. With this extension we'd then get:

	>n
	(first trying to open the door)
	The door seems to be locked.

Notice the different wording of the implicit action report here. With this extension "(first trying to do something)" means that we need to do something to carry out the command we actually issued, so we tried to do it, but we didn't succeed. This is less misleading (and less jarring) than:

	>n
	(first opening the door)
	The door seems to be locked.

The most natural meaning of which is that we did actually manage to open the door (even though in fact we couldn't, because it was locked).

When a chain of implicit commands is being carried out, it is stopped as soon as one of them fails, with a message explaining why it failed at that point. So, going back to the earlier example where the key was available, we could (in principle) get either:

	>n
	(first trying to take the key)
	One look at the scorpion sitting on the key quickly changes your mind about trying to take it.

Or

	>n
	(first taking the key, then trying to unlock the door with the key)
	The lock proves too stiff; perhaps it needs oiling.

Or

	>n
	(first taking the key, then unlocking the door with the key, then trying to open the door)
	Something seems to be jamming the door, even though it's not locked.

Section: Changing the Implicit Action Reporting Style.

All the example we have seen so far have reported implicit actions in parentheses (the normal style). To see them reported more like normal actions, we can just chnage the global variable parenthesize implicit actions to false, then we'd see (for example):

	>n
	You take the key, then unlock the door with the key, then try to open the door.

	Something seems to be jamming the door, even though it's not locked.

This is done via a global variable rather than a use option, so that we can (should we wish) change the style during the course of the game. To switch off the parenthesized style of implicit action right from the start, include the following:

	*: when play begins:
	now parenthesize implicit actions is false.

Section: Overriding or Preventing Implicit Actions

Once in a while an implicit action may not do what we want. For example, if the player encounters a red door marked DANGER it might be a bad idea to open it via an implicit action. To prevent the door being opening implicitly we need to write a special rule for implicitly opening it. This could simply take the form:

	rule for implicitly opening the red door:
	do nothing.

But this could easily cause the action to fail with no explanation at all:

	>north
	>

We could instead have our rule explicitly abort the implicit action, so that we get the standard failure report:

	rule for implicitly opening the red door:
	abort the implicit action.

This is fine provided opening the red door will only ever be a top-level implicit action (i.e. not one triggered by another implicit action higher up in the chain). If the aborted implicit action is generated by one higher up in the chain, however, the result can be be a bit messy. Suppose we have a transparent cabinet containing a brass key that we need to unlock a door that needs to be open if the player is to go north, but for some reason we don't want the cabinet to be open via an implicit action (perhaps because it's full of poison gas and we don't want to kill the player as an unintended side-effect of some other action). Stopping the implicit action with "abort the implicit action" would generate the following rather messy output:

	>n
	(first trying to take the brass key)
	The cabinet isn't open.

	The cabinet isn't open.

	It seems to be locked.

	You can't, since the oak door is in the way.

We can prevent this mess by having our custom rule print a failure message instead:

	rule for implicitly opening the cabinet:
	say "It may be dangerous to open the cabinet."

Or we can get the best of both worlds with:

	Rule for implicitly opening the cabinet:
	 abort the implicit action with message  "It may be dangerous to open the cabinet." 

This will then use a standard failure message in the implicit opening is generated by a top-level action (an explicit TAKE THE BRASS KEY), say, but will show our custom message if the implicit opening is triggered by another implicit action (such as implicitly taking the key to unlock the door).

A final technique is to tailor the failure message to the context by writing a rule that is specific to one implicit action taking place in the context of another:

	Rule for implicitly opening the cabinet while implicitly unlocking the oak door:
	  say "You need the brass key to unlock the door, but the cabinet is closed."



Chapter: Locks, Keys and Doors

Section: Using Implicit Actions Can with Locksmith

Because the Implicit Actions extensions provides its own way of dealing with implicit actions, there is no need to use Emily Short's Locksmith extension at the same time. Locksmith carries out implicit actions for locks and doors, which Implicit Actions also does. On the other hand, if you want to use both extensions together you now can. The code in Implcit Actions that deals with keys and doors has all been marked "(for use without Locksmith by Emily Short)", so that if Locksmith and Implicit Actions are both included in the same game, the two shouldn't clash. If both extensions are included, the handling of implcit actions for Locks, Keys and Doors will thus be entirely left to Locksmith, and none of the rest of the present chapter will apply.

There's no particular reason for using both Implicit Actions and Locksmith in the same game. Implicit Actions does just about everything Locksmith does, but in a slightly different way, so using the two together in the same game will give a less consistent playing experience than using Implicit Actions alone. It has been made possible to use the two together in case (a) some authors prefer the way Locksmith handles doors and keys, but want to extend the range of impllcit actions available or (b) an author starts by using Locksmith and then wants to extend the range of implicit actions used without changing code already wrirtten.

The example games below can be made to work with Locksmith, with minor modifications. References to the "key" kind would need to be changed to "passkey", and "keyring" likewise changed to "keychain". In Example C "The known-key of the oak door is the brass key." needs to be replaced with "The brass key unbolts the oak door." and "Rule for implicitly opening the cabinet while implicitly unlocking the oak door" will need to be commented out or removed, since there's no "implicitly unlocking" activity when Locksmith is used. The examples can then be compiled and run, but don't work quite so smoothly.

In sum: Implicit Actions can now be used with Locksmith, but in most cases it's probably better to use it without.


Section: Remembering Keys

Whenever a key (which can be an ordinary thing, or can be of kind key) is successfully used to lock or unlock something, it is remembered as the known-key for that item (door or container). Thereafter that key will automatically be used to unlock or lock that item (door or container) whenever possible. Every door and container has a known-key property (as well as its matching key property) for this purpose. Thus, if there are doors or containers in the game for which the player character is already meant to know the matching key at the start of the game, we can simply define the known-key property on those doors or containers accordingly. Normally, of course, the known-key property should then contain the same object as the matching key property.

Section: Locking and Unlocking Without Keys

A door or container can be defined as not needing a key to be locked or unlocked by giving it a matching key property of no-key. It can then be locked with LOCK DOOR or unlocked with UNLOCK BOX. This can be used to model doors and containers locked with catches, bolts, paddles and the like.

The extension defines bolting and unbolting actions corresponding to the grammar LOCK WHATEVER and UNLOCK WHATEVER. If WHATEVER has a matching key of no-key then these commands simply lock and unlock the whatever object without further ado. Otherwise, if the whatever object has a known-key, and the known-key is to hand, these commands use the known-key to lock and unlock the object.

If we want to define an object that locks and unlocks without a key but is controlled by some other mechanism (such as a combination lock), then we should probably not define it as lockable.

Section: Keys and Passkeys

Like Locksmith, this extension defines a passkey kind. There is no need to use the passkey kind to get any of the functionality described above. The only thing a passkey does that a ordinary thing doesn't is to display a list of the objects it's known to lock and unlock when it is examined or listed in inventory. We don't need to use a passkey at all if we don't want this particular feature.

The extension also defines a key kind (to which passkey belongs). We don't need to use the key kind to make keys work (unless we want to put them on a keyring, see below), but defining keys to be of kind key can help the parser make a more intelligent choice of indirect object in locking and unlocking commands.

Section: Keyrings

Finally, the extension defines a keyring kind (equivalent to keychain in Locksmith). This may be used to carry keys around on (provided they are defined to be of kind key or passkey). Keys on a keyring can be used to lock and unlock things without being removed from the keyring.

Chapter: Defining New Implicit Actions

This extension makes it relatively easy to define further explicit actions that work within the same framework (this is illustrated in Example B). The steps involved are basically:

1. Define a new activity that actually carries out the implicit action.

2. Define one or more Before rules that make use of the activity.

It's not strictly necessary to use an activity at stage 1; a to phrase would do the job, for example; but using an acitivity keeps the new implicit action consistent with the implicit actions defined in this extension, and allows us to use conditions like "while implicitly dropping the priceless vase". But whether we use an activity or not (and from now on we'll assume we do), our definition should follow this pattern:

	initialize the implicit action;
	silently try opening the obstructor;  
	finish the implicit action with participle "opening" infinitive "open" object "[the obstructor]" and condition (whether or not the obstructor is open).

That is we start our definition with the phrase "initialize the implicit action". We next write a phrase to silently try doing whatever the implicit action needs to attempt. We finally use the phrase "finish the implicit action" with a number of additional piece of information that facilitate the construction of the implicit action report:

- with participle "opening": this part of the phrase defines the verb form to use if the implicit action succeeds (e.g. in "opening the door" or "taking the key"). We just need the present participle here (e.g. "opening" or "taking").

- infinitive "open": this part of the phrase defines the verb form to use if the implicit action fails (e.g. in "trying to open the door" or "trying to take the key"). We just need the inifinitive (minus "to") here (e.g. "open" or "take").

- object: this part of the phrase is a string that will expand into the object or objects involved in the implicit action (e.g. "the door" or "the door with the brass key"). We'll probably need to use substitutions here so that this string will expand into the object or objects actually used.

- and condition: this final part of the phrase needs to define a truth state expression that evaluates to true if the implicit action succeeds and false if it fails. For example, in the case of an implicit opening action, the object we were trying to open (here called "the obstructor") will be open if the impicit opening succeeded, and closed if it did not, so we can use the expression (whether or not the obstructor is open) here.

We'd then normally wrap all this in an activity:

	Implicitly opening something is an activity.

	Rule for implicitly opening something (called the obstructor) (this is the implicit opening rule):
	   initialize the implicit action;
	   silently try opening the obstructor;  
	   finish the implicit action with participle "opening" infinitive "open" object "[the obstructor]" and condition (whether or not the obstructor is open).

Finally, we write a precondition rule to invoke the implicit activity when needed, e.g.:

	Precondition for going through a closed door (called the obstructor):
	   carry out the implicitly opening activitity with the obstructor;
	   if the obstructor is closed and implicit action attempted is true, stop the action.

We add the final test, stopping the action if the door remains closed after the implicit attempt to open it, because in that case the implicit action will already have printed its own failure message ("The door seems to be locked" or whatever), so we don't also want to see the failure message a later check rule would display.

The clause "and implicit action attempted is true" is added to allow for exceptions. If there's a particular door we don't want the implicit opening activity to apply to, for example the Very Dangerous Door, then we can write a special carry out implicitly opening rule for it that sets implicit action attemped to false. In that case the action can proceed to the normal check stage to display the normal failure message.

The implicitly opening action used as an example here is already defined in this extension. To see an illustration of a new implicit action that isn't, see Example B below.



Chapter: Limitations and Cautions

Section: Player Actions Only

Implicit Actions works only for actions carried out by the Player Character, not for Non-Player Characters. For many games, this will suffice, since the primary aim is to provide a smoother experience for players than to create more intelligent NPCs. Nevertheless, the framework provided here could be extended to work with NPCs, but the best way to do this would be to write a further extension (NPC Implicit Actions, say) that provides the relevant functionality for characters other than the player character. Such an extension would probably need to include this one, and then add a host of "Before someone going through a closed door" type rules.

A simple (and rather basic) NPC Implicit Actions extension is available from the official Inform Extensions page.


Section: Overflowing the Text Buffer

Implicit Actions makes use of the Text Capture extension to store the text that might be output during an implicit action to explain why an action failed (and then display it at the end of the implicit action report). The text capture buffer can hold a maximum of 256 characters, so it should be used only for fairly short pieces of text, not huge amounts of it all at once. Overrunning the buffer will cause a run-time error in Z-Code games, and the loss of all characters beyond the 256th in Glulx games. If a larger buffer is needed, because you want to display a very long failure message in the course of an implicit action, you need to change the text buffer size to something larger. You can do this with the option "Use maximum capture buffer length of at least 512" (or whatever other buffer size you want). 


Section: Debugging Commands (Such as RULES)

Implicit Actions makes use of the Text Capture extension to suppress output until it is ready to display a summary of implicit actions. This can play havoc with some of the debugging commands, particularly RULES and RULES ALL, since if they're active when an implicit action is being carried out, their output will also be captured, with the probable result that the text capture buffer will overflow, the rule tracing won't be displayed, and the game output will consist of a huge number of error messages (or the game may hang altogether). Be very careful, then, in using RULES in a game that includes Implicit Actions.

Section: Redirecting Actions - Instead vs Before

It's not uncommon in Inform programming to use Instead rules to redirect one action to another, e.g.:

	Instead of opening the sliding door, try pulling the red lever.

This could cause problems if used in conjuction with Implicit Actions, however. Implicit Actions generates implicit actions in Precondition rules, which are run before Instead rules, so our redirection could be defeated in this case:

	>open the sliding door
	(first trying to unlock the sliding door)
	The sliding door seems to be locked.

The solution is to use before rather than instead to carry out the redirection:

	Before opening the sliding door, try pulling the red lever instead.

This also applies if we need to write code to carry out the effect of an action. For example the standard rules require an actor not to be in a container or on a supporter when travelling from a location, but if we want to prevent egress through a window unless the player character is on a ladder (for example), we need to code round that restriction. The following would work just fine:

	Before going through the window when the player is on a ladder: 
	  say "You clamber through the window.";
	  if the location is the Short Narrow Alley then  move the player to the Private Office;
	  otherwise move the player to the Short Narrow Alley;
	  stop the action.

But it would not have worked if we'd put the same code in an instead rule; Implicit Actions would have carried out an implicit action to remove the player character from the ladder before the instead rule was reached, defeating the purpose of the ladder.


Example:* A Study in Two Keys - A demonstration of the various kinds of implicit action defined in the Implicit Actions extension.

This little game exhibits what Implicit Actions does straight out of the box, by offering examples of all the implicit actions it defines. The only extension-specific code in this game (beyond the Include statement) is "The matching key of the pine door is no-key", which means that we don't need a key to lock and unlock this door.

	*: "A Study in Two Keys"

	Include Implicit Actions by Eric Eve.
	
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

	The Hall is a Room. "This room is quite bare, but an oak door leads north, and a pine door east."

	The pine door is a closed locked scenery door. It is east of the Hall and west of the Closet.
 	The matching key of the pine door is no-key.

	The Closet is a Room. "This small closet is little more than a broom-cupboard (though there is not a broom in sight). A pine door leads out to the west."
	Instead of exiting in the Closet, try going west.
	
	Test me with "s/unlock door with brass key/look in red box/unlock glass cabinet with silver key/unlock oak door with brass key/s/e/lock door/out/n/lock door/drop all/close red box/put silver key in red box/put brass key in cabinet/lock cabinet/drop silver key/sit on chair/take gold/s/put brass on gold/lock oak"

When you've tried running this example, you might like to try it again with the following added, to see the difference in reporting style:

	*: when play begins:
	  now parenthesize implicit actions is false.



Example:** Football Practice - Defining a new implicit action.

In this example we define a new action (kicking) and a new implicit action (dropping something). It's a bit dificult to kick something you're holding, so we make the kick action carry out an implicit drop if the thing to be kicked is currently carried.

	*: "Football Practice"

	Include Implicit Actions by Eric Eve.

	Part 1 - Define the Implicit Drop Activity

	implicitly dropping something is an activity.
	
	rule for implicitly dropping something (called the held-thing) :
	   initialize the implicit action;
	   silently try dropping the held-thing;  
	   finish the implicit action with participle "dropping" infinitive "drop" object "[the held-thing]" and condition (whether or not the held-thing is not carried).

	Part 2 - The Kicking Action

	kicking is an action applying to one thing.
	Understand "kick [something]" as kicking.

	Precondition for kicking something that is carried:
	   carry out the implicitly dropping activity with the noun;
	   if the noun is carried and implicit action attempted is true, stop the action.

 	Check kicking yourself:
	  say "You may feel like kicking yourself, but it wouldn[apostrophe]t actually do much good." instead.
	
	Check kicking the off-pitch ball:
	  say "It[apostrophe]s off the pitch now; you[apostrophe]ll need to pick it up and bring it back before you can take another shot at the goal." instead.

	Carry out kicking the ball:
	  now the ball is off-pitch.

	Report kicking the ball:
	   say "You give [the noun] a good kick, [one of]but it goes sailing wide of the goal[or]but it narrowly misses the goal[or]and it sails nicely between the goal-posts[as decreasingly likely outcomes]."

	Part 3 - The Scenario

	The Football Pitch is a room. "[if unvisited]It is a painfully cold morning this early in the day, but you wanted to come out and practice your kicking when there was absolutely no one else around to watch you make a fool of yourself. [end if]The pitch is deserted, and the goal is a couple of dozen yards away."

	The goal is scenery in the Football Pitch. "It is just waiting there for you to kick a ball into it - if you can."
	Understand "posts" or "goal-posts" as the goal.

	The ball is in the Football Pitch. The ball can be in-play or off-pitch. It is in-play.

	Carry out taking the ball: now the ball is in-play.
	After taking the ball when the ball was off-pitch:
	  say "You pick up the ball and carry it back onto the pitch."

	Rule for writing a paragraph about the in-play ball:
	 say "A ball rests at your feet, patiently awaiting a kick."

	Rule for writing a paragraph about the off-pitch ball:
              say "The ball is just off the pitch."

	Test me with "kick ball/g/get ball/kick ball/get ball/kick ball."
	

Example: *** Poison Trap - Preventing implicit actions in specific cases

	*: "Poison Traps"

	Include Implicit Actions by Eric Eve.

	Part 1 - Scenario

	Use scoring.
	The maximum score is 5.

	The Study is a room.
	"An oak door leads north, and there is a table here."

	The cabinet is a closed openable transparent container. 
	The description is "The cabinet [if dangerous]seems to be full of green gas[otherwise]is glass-fronted."

	The cabinet can be safe or dangerous. The cabinet is dangerous.

	Understand "green" or "gas" as the cabinet when the cabinet is dangerous.
	Understand "glass-fronted" or "glass" or "fronted" as the cabinet.

	The cabinet is on the plain wooden table.

	After opening the dangerous cabinet:
	if the gas mask is worn begin;
	  say "The green gas escapes into the room, but is soon extracted by the ventillator.";
	  now the cabinet is safe;
	otherwise;
	  say "The green gas escapes into the room, killing you in seconds.";
	  end the story saying "You have died.";
	end if;
        
	The brass key is a key. The brass key is in the cabinet.

	A plain wooden table is a scenery supporter in the Study.

	Instead of looking under the plain wooden table when the gas mask is not handled:
	  if the gas mask is off-stage begin;
	    move the gas mask to the Study;
	    say "You find a gas mask under the table.";
	    increase the score by 2;
	  otherwise;
	   say "There's a gas mask under the table.";
	  end if.

	A scorpion is in the Study. "A scorpion is crawling about on the floor."

	The gas mask is a wearable thing. "A gas mask lies under the table."

	After taking the scorpion:
	  say "The scorpion gives you a nasty bite.";
	  end the story saying "You have died". 

	The oak door is a closed openable lockable locked scenery door.
	The matching key of the oak door is the brass key.
	The known-key of the oak door is the brass key.

	The oak door is north of the Study and south of the Hall.

	The Hall is a room. "An oak door leads south."

	After going to the Hall:
	  try looking;
	  say "You have escaped the trap!";
	  increase the score by 3;
	  end the story finally saying "You have won".

	Part 2 - Overridden Implicit Actions

	Rule for implicitly taking the scorpion:
	    abort the implicit action.

	Rule for implicitly opening the cabinet:
	 abort the implicit action with message  "The cabinet should only be opened with caution." 

	Rule for implicitly opening the cabinet while implicitly unlocking the oak door:
	  say "You need the brass key to unlock the door, but the cabinet is closed."

	Part 3 - Testing

	Test gas with "n/take key/open cabinet"

	Test scorpion with "put scorpion on table/take scorpion"

	Test me with "n/x cabinet/take key/put key on table/put scorpion on table/look under table/wear gas mask/open cabinet/x cabinet/north"
