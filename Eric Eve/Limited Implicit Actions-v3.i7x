Version 3.0.1 of Limited Implicit Actions by Eric Eve begins here.
"A cut-down version of Implicit Actions for use where code size may be restricted and the full functionality of Implicit Actions is not needed. Compatible with Locksmith by Emily Short."

Volume 1 -  Implicit Action Framework


[ We use the same basic framework as for the full implicit actions extension ]

Book 1 - The Precondition Rulebook

ignore_preconditions is a truth state that varies. ignore_preconditions is false.

The precondition rules are a rulebook. 

This is the precondition stage rule:   abide by the precondition rules.
   

The precondition stage rule is listed before the basic accessibility rule in the action-processing rules.

Book 2 - Activities

Part 1 - Implicit Taking

Rule for implicitly taking something (called the object desired) (this is the implicit taking rule):  
  let actdesc be "trying to take";
  if the object desired is portable and the object desired is touchable, let actdesc be "taking";
  say "(first [actdesc] [the object desired])[command clarification break]" (A);
  silently try taking the object desired.  
  

Part 2 - Implicit Opening

Implicitly opening something is an activity.

The last for implicitly opening something (called the obstructor) (this is the implicit opening rule):
   let actdesc be "trying to open";
   if the obstructor is touchable and the obstructor is openable and the obstructor is unlocked, let actdesc be "opening";
   say "(first [actdesc] [the obstructor])[command clarification break]" (A);
   silently try opening the obstructor;  
   
Part 3 - Implicit Exiting

implicitly exiting something is an activity.

The last for implicitly exiting something (called the nested room)  (this is the implicit exiting rule):
  say "(first leaving [the nested room])[command clarification break]" (A);
  silently try exiting.


Book 3 - Preconditions

Precondition for putting something on something when the noun is not carried (this is the take object before putting it on rule):
  if the noun is on the second noun,
    say "[The noun] [are] already on [the second noun]."  (A) instead;
 carry out the implicitly taking activity with the noun;
 if the noun is not carried, stop the action.

Precondition for inserting something into something when the noun is not carried (this is the take object before inserting it into rule):
  if the noun is in the second noun,
    say "[The noun] [are] already in [the second noun]." (A) instead;
 carry out the implicitly taking activity with the noun;
 if the noun is not carried, stop the action.

Precondition for inserting something into something when the second noun is an openable closed container (this is the open container before inserting rule):
  carry out the implicitly opening activity with the second noun;
  if the second noun is closed, stop the action.

Precondition for searching a closed openable opaque container (this is the open container before searching rule):
  carry out the implicitly opening activity with the noun;
  if the noun is closed, stop the action.

Precondition for taking something when the noun is inside a closed container (called the receptacle) (this is the open before taking contents rule):
  carry out the implicitly opening activity with the receptacle;
  if the receptacle is closed, stop the action.

Precondition for going from a room when the holder of the player is not a room (this is the exit holder before leaving room rule):
  while the holder of the player is not a room begin;
      let loc be the holder of the player;      
      carry out the implicitly exiting activity with loc;
      if the holder of the player is loc, break;
   end while;
  if the holder of the player is not a room, stop the action.


Limited Implicit Actions ends here.

---- DOCUMENTATION ----

Chapter: The Basics

Section: What Limited Implicit Actions Is For

Limited Implicit Actions is a cut-down version of the Implicit Actions extension that may prove useful in either or both of the following circumstances:

(a)	We're writing a Z-Code game that's running short of space, and we want something less resource-hungry than the full Implicit Actions extension.

(b)	We want some implicit actions, but we also want to use Emily Short's Locksmith extension.

If neither of these conditions hold, then we may well do better to use the full Implicit Actions extension.

Note that some of the functionality of Limited Implicit Actions is now provided by the Standard Rules as from Inform release 6E59. Limited Implicit Actions does, however, handle a few more cases than the Standard Rules, as well as providing an extensible framework for simple implicit actions and slightly better reporting of implicit actions that fail. 

Limited Implicit Actions uses less resources than the full Implicit Actions extensions because:

(a)	It makes no use of indexed texts or the Text Capture extension.
(b)  It does not supply implicit actions for doors and locks (though these can be added if required, see below).
(c)  It does not attempt to group implcit action announcements, e.g. "(first taking the brass key, then unlocking the oak door with the brass key, then opening the brass door)".

What Limited Implicit Actions (LIA) does do is:

(a)	Perform an implicit take if needed for PUT X IN Y or PUT X ON Y.
(b)	Perform an implicit open if needed for SEARCH X, PUT X IN Y (when Y is a closed container) or TAKE X (when X is in a closed transparent container).
(c)	Perform impliciit exiting if the player tries to go somewhere while on an enterable supporter or in an enterable container.


Addtionally, LIA tries to guess whether the implicit action will succeed or fail, and announce it accordingly, e.g. "(first taking the ball)" for a success and "(first trying to take the ball)" for a failure. These guesses are likely to be right most of the time so long as our game doesn't do anything out of the ordinary. The guesses will be wrong, however, when, for example, we use an Instead or Before rule to prevent an action that would otherwise have succeeded. This limitation is one of the prices we have to pay for using Limited Implicit Actions instead of the full Implicit Actions extensions, but it may be a limitation worth living with.

Section: How Limited Implicit Actions Works

To use Limited Implicit Actions we simply have to include it in our game. The appropriate implicit actions described above will then be performed for us automatically. We only need to know how it works in any more detail if we want to extend or customize its behaviour.

Limited Implicit Actions follows the same basic structure as the full Implicit Actions extensions. That is, it defines a new rulebook, the Precondition Rules, which operates between Before and Instead. It also defines a number of activities which actually carry out the preconditions specified for the precondition rules. For example, in order to put Object A on Object B we first need to be holding Object A, so Limited Implicit Actions defines the precondition rule:

	Precondition for putting something on something when the noun is not carried (this is the take object before putting it on rule):
  		if the noun is on the second noun then
    		say "[The noun] [are] already on [the second noun]." instead;
 		carry out the implicitly taking activity with the noun;
 		if the noun is not carried then stop the action.

Limited Implicit Actions then defines the corresponding activity. Although there's already an implicitly taking activity in the Standard Rules, LIA defines its own version:

	Rule for implicitly taking something (called the object desired) (this is the implicit taking rule):  
		let actdesc be "trying to take";
		 if the object desired is portable and the object desired is touchable, let actdesc be "taking";
		 say "(first [actdesc] [the object desired])[command clarification break]";
  		silently try taking the object desired.

The precondition is similar to the corresponding precondition in the full Implicit Actions extension. The corresponding activity is rather simpler. The example above illustrates how LIA guesses whether an implicit action is likely to suceed or fail (and thus choose the "first taking" or "first trying to take" form of the implicit action announcement). In the case of implicit taking, it assumes the implicit action will only fail if the object to be taken isn't portable or if it can't be touched. The implicitly opening action likewise assumes that it will fail if the object to be opened is locked (or unopenable or not touchable). This guessing is necessary because the implicit action announcement is displayed before the action is attempted (unlike the full Implicit Actions extensions, which constructs the implicit action announcement in the light of what actually happens).

We can also extend Limited Implicit Actions. The next chapter gives some examples that can be pasted into game code if required, or else adapted to create other types of implicit action. A game that requires anything much more sophisticated than Limited Implicit Actions can provide may, however, be better off using the full Implicit Actions extension.

Chapter: Extending Limited Implicit Actions

Section: General Notes

We can extend Limited Implicit Actions by adding new precondition rules and defining new implicit action activities for them to trigger. A precondition rule defines what implicit action may be required under particular circumstances (e.g. unlocking a locked door before trying to open it); the activity then defines how that implicit action is reported and carried out. Hopefully this will become clearer from the examples given below, all of which concern doors, locks and openable containers. If we're using Emily Short's Locksmith extension, we probably won't need much of this, but if we're not and we want auto-opening and auto-unlocking doors (without the full Implicit Actions extension), the following examples may be useful. Each section of code is provided with a paste button so it can easily be added to your own project.

Section: Auto-Opening Doors

To make a closed door automatically open when the player tries to go through it, we can add the following to our game code:

	*: Precondition for going through a closed openable door (called the obstructor):     
  		carry out the implicitly opening activity with the obstructor;
  		if the obstructor is closed, stop the action.

The implicitly opening activity is already defined in Limited Implicit Actions, so that's all we need to do.


Section: Auto-Unlocking

If we're not using Emily Short's Locksmith extension, and we want Limited Implicit Actions to handle the implicit unlocking of doors (and containers), then we need to do a little more work. We'll assume that anything lockable needs a key to lock and unlock it. We'll also assume that implicit unlocking shouldn't occur until the player knows which key to use for a given door or container, and that the player only finds this out by successfully locking or unlocking something with the correct key. When this happens, the door or container that's just been locked or unlocked will be given the key-tested property. We can then add automatic unlocking of key-tested doors and containers to our game with the following code:

	*: A door can be key-tested. A door is usually not key-tested.
	A container can be key-tested. A container is usually not key-tested.

	Carry out unlocking something with something:
		now the noun is key-tested.

	Carry out locking something with something:
		now the noun is key-tested.

	Precondition for opening a closed locked key-tested thing when the matching key of the noun is touchable:
		carry out the implicitly unlocking activity with the noun;
		if the noun is locked, stop the action.

	implicitly unlocking something is an activity.

	Rule for implicitly unlocking something (called the obstructor):
		let my-key be the matching key of the obstructor;
		say "(first unlocking [the obstructor] with [the my-key])[command clarification break]" (A);
		silently try unlocking the obstructor with my-key.

Note that if we want the player to start out knowing which key unlocks a particular door or container (e.g. because it's the front door to his/her own house), we can just define that door or container as being key-tested from the outset, for example:

	The front door is a key-tested scenery door. The matching key is the large iron key.


Section: Smarter Auto-Unlocking

The foregoing code does the job, but its output can be slightly untidy, since it can typically produce output like:

	>e
	(first trying to open the oak door)
	(first unlocking the oak door with the brass key)

Since implicitly unlocking followed by implicitly opening is such a common case, we can improve this output by adding the following rule:

	*: Rule for implicitly opening a closed locked openable key-tested thing (called the obstructor):
		let my-key be the matching key of the obstructor;
		if my-key is not carried, continue the activity;
		say "(first unlocking [the obstructor] with [the my-key], then opening [it-them of the obstructor])[command clarification break]" (A);
		silently try unlocking the obstructor with my-key;
		silently try opening the obstructor.

Which will change the output in this case to the rather neater:

	>e
	(first unlocking the oak door with the brass key, then opening it)

Section: Smarter Key Selection

Once the player knows which key is needed to lock or unlock something, it would be good if our game would automatically select the right key for the job in response to LOCK WHATEVER or UNLOCK WHATEVER. We can achieve this very simply by pasting the following code into our game;

	*: Does the player mean locking a key-tested thing with the matching key of the noun: it is very likely.
 
	Does the player mean unlocking a key-tested thing with the matching key of the noun: it is very likely.

Section: Implicit Closing

Finally, it might be neat to have doors and containers implicitly closed when the player tries to close them. We can define the precondition so that it applies only when implicit closing would be sensible, and then the definition of the associated activity becomes very simple:

	*: Precondition for locking an open openable lockable thing with something:
   		carry out the implicitly closing activity with the noun;
   		if the noun is open, stop the action.

	Implicitly closing something is an activity.

	The last for implicitly closing something (called the open-thing):
  		say "(first closing [the open-thing])" (A);
  		 silently try closing the open-thing.

In this case defining a separate implicitly closing activity may be overkill, however. If we're only ever going to want implicit closing to operate with locking, we can remove the overhead of another activity by compressing our implementation to this:

	*: Precondition for locking an open openable lockable thing with something:
    		 say "(first closing [the noun])" (A);
    		 silently try closing the noun;
    		 if the noun is open, stop the action.

This may be a better pattern to follow for similar cases.

Section: Conclusion - Implicit Actions and Limited Implicit Actions

It's relatively straightforward to extend Limited Implicit Actions to cover more situations. The examples shown above can be pasted straight into your code it your game has doors and locks but you're not using Emily Short's Locksmith. On the other hand, Limited Implicit Actions is meant to be limited (to keep it small); if you find yourself trying to reinvent too many wheels to get it to do what you want, you may be better off using the full Implicit Actions extensions.

Note that Implicit Actions and Limited Implicit Actions should never be both included in the same game. There should never be any reason for including both, and your game won't compile if you try. It should, however, be relatively easy to switch between them. If you find yourself running out of space in a Z-Code game, you can try including Limited Implicit Actions instead of Implicit Actions. Conversely, if you find that Limited Implicit Actions isn't giving you enough functionaliy, you can switch to Implicit Actions instead. If you've defined any Preconditions or implicit activities of your own, you'll need to make some adjustments to them. If you change from Limited Implicit Actions to Implicit Actions you'll need to strip out any of the above door and lock examples you've added to your code, since equivalent functionality is already supplied in Implicit Actions.

Example:* Balancing Act - Putting Limited Implicit Actions through its basic places.

The following short example demonstrates most of what Limited Implicit Actions will do straight out of the box.

	*: "Balancing Act" by Eric Eve.

	Include Limited Implicit Actions by Eric Eve.
	
	The Old Theatre is a room.
	"Most of the seating has been stripped out, although the stage remains. The way out to the Prop Store lies east."

	The stage is a scenery enterable supporter in the Theatre.

	The wooden chair is a portable enterable supporter in the Theatre.
	"A lone wooden chair sits facing the stage."

	The Prop Store is east of the Theatre.
	"The Prop Store has been stripped bare, apart from the cupboard set into one wall. The way back to the Theatre lies west."

	The prop cupboard is a scenery openable closed container in the Prop Store.

	The small stool is a portable enterable supporter in the prop cupboard.

	A glass jar is a transparent openable closed container in the prop cupboard.

	A small red ball is in the glass jar.

	Test me with "put chair on stage/sit on chair/e/look in cupboard/take stool/take jar/x jar/take ball/close cupboard/drop jar/put jar in cupboard/put cupboard on stool/w/put stool on chair/sit on stool/e"


Example: ** The Eye of Balinor - A Jewel Theft with plenty of locks and keys

This example incorporates all the various example code snippets for doors and keys, and demonstrates how they work in action.

	*: "The Eye of Balinor" by Eric Eve.

	Include Limited Implicit Actions by Eric Eve.
	
	The story headline is "A daring jewel theft"
	
	Use scoring.

	Book 1 - World Model

	A door is usually scenery.

	Precondition for going through a closed openable door (called the obstructor):
		carry out the implicitly opening activity with the obstructor;
		if the obstructor is closed, stop the action.

	A door can be key-tested. A door is usually not key-tested.

	A container can be key-tested. A container is usually not key-tested.

	Carry out unlocking something with something:
			now the noun is key-tested.

	Carry out locking something with something:
			now the noun is key-tested.

	Precondition for opening a closed locked key-tested thing when the matching key of the noun is touchable:
		carry out the implicitly unlocking activity with the noun;
		if the noun is locked, stop the action.

	implicitly unlocking something is an activity.

	Rule for implicitly unlocking something (called the obstructor):
		let my-key be the matching key of the obstructor;
		say "(first unlocking [the obstructor] with [the my-key])[command clarification break]";
		silently try unlocking the obstructor with my-key.

	Rule for implicitly opening a closed locked openable key-tested thing (called the obstructor):
		let my-key be the matching key of the obstructor;
		if my-key is not carried, continue the activity;
		say "(first unlocking [the obstructor] with [the my-key], then opening [regarding the obstructor][them])
		[command clarification break]";
		silently try unlocking the obstructor with my-key;
		silently try opening the obstructor.

	Does the player mean locking a key-tested thing with the matching key of the noun: it is very likely.

	Does the player mean unlocking a key-tested thing with the matching key of the noun: it is very likely.

	Precondition for locking an open openable lockable thing with something:
		say "(first closing [the noun])";
		silently try closing the noun;
		if the noun is open, stop the action.

	Book 2 - Scenario

	Part 1 - The Drive

	The Drive is a room.
	"The front door of the house you have come to burgle stands immediately to the south."

	The doormat is an enterable supporter in the Drive.
	"A doormat rests on the ground just by the front door."

	Understand "mat" as the doormat.

	Instead of looking under the doormat when the brass key is off-stage:
	   move the brass key to the player;
	   say "Under the mat you find a brass key, which you take."

	The brass key is a thing.

	After locking the front door with the brass key in the Drive when the huge diamond is carried:  
	  increase the score by 10000;
	  say "You relock the front door and slip the brass key under the mat, and then turn to saunter triumphantly down the drive, the Eye of Balinor in the pocket of your dinner jacket.";
	  end the story finally saying "You have won".
	
	The front door is a closed lockable locked openable door.
	It is north of the Hall and south of the Drive.

	When play begins:
	  say "The Eye of Balinor is reputed to be the largest diamond ever found; if you can steal it you'll be the greatest jewel thief ever! But you must be careful to leave everything just as you found it -- apart from the diamond of course!"

	The maximum score is 10000.

	Part 2 - The Hall

	The brass key unlocks the front door.

	The Hall is a room.
	"Many old paintings adorn the walls, but you scarcely afford them a glance. It's not paintings you have come to steal, after all. Doors lead off in various directions from here but the only ones that concern you are the study door (to the east) and the front door (to the north)."

	The study#door is a closed openable door.
	It is east of the Hall and west of the Study.
	The printed name is "study door".
	Understand "study" or "door" as the study#door.

	After locking the front door with the brass key for the first time:
	  say "You lock the front door just to make sure you're not interrupted."

	Part 3 - The Study

	The Study is a room.
	"You ignore the paintings, bookcases and fine old furniture that adorn this fine, oak-paneled study, and focus on the only things that matter to you right now: the safe next to the wall, the oak desk in the middle of the room, and the door out to the west."

	The oak desk is a scenery supporter in the Study.
	The description is "It's a fine old desk, with a single drawer."

	The drawer is a closed openable lockable locked container. It is part of the oak desk.
	The matching key is the small dull key.

	The large silver key is in the drawer.

	The pencil case is a closed openable container on the desk.

	The small dull key is in the pencil case.

	The safe is a closed openable locked lockable scenery container in the Study.
	The description is "You recognize the make: it's a Securimax Ultra, a kind of safe that's unlocked with a large silver key."
	The matching key is the large silver key.

	Understand "securimax" or "ultra" as the safe.

	The huge diamond is in the safe.
	The description is "A gem this large can only be the famed Eye of Balinor, said to be worth more than the GDP of a small country!"

	understand "gem", "jewel", "eye", "of" or "balinor" as the huge diamond.

	Book 3 - Testing

	Test me with "look under mat/unlock front door with key/s/lock front door/e/x safe/x desk/look in pencil case/unlock drawer with small key/look in drawer/unlock safe with silver key/look in safe/x diamond/take eye/lock safe/put silver in drawer/lock drawer/put small key in case/close case/w/n/lock door"
