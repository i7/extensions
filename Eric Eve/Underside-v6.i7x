Version 6.1 of Underside by Eric Eve begins here.
   
"Allows objects to be put under other objects. An underside usually starts out closed so that its contents are hidden from view. Requires Version 7 (or later) of Bulk Limiter; the space under objects is limited by bulk. Underside is compatible with Version 10 or later of Implicit Actions, but does not require it. Version 5 of Underside avoids features deprecated in Version 6E59 of Inform."

[ 6/210627: fixed small error preventing compilation when Implicit Actions was included ]

Part 1 - Includes

Include Version 9 of Bulk Limiter by Eric Eve. 

Part 2 - The Underside Kind

An underside is a kind of container. The carrying capacity of an underside is usually 10000. [limit by bulk rather than quantity]
An underside is usually closed. [so that it conceals its contents]
An underside is usually privately-named [players should never need to refer to these objects directly.]

The printed name of an underside is normally "[printed name of the holder of the item described]"

The specification of underside is "An underside is a special kind of container that represents the space under an object. To use it, define an object of kind underside and make it a part of the thing you want to be able to put things under."


Part 3 - Looking Under

This is the clever looking under rule:
   if an underside (called the underpart) is part of the noun and something is in the underpart begin;
      now the underpart is open;      
      say "Under [the noun] [is-are a list of things in the underpart]." (A);   
   otherwise;
      follow the standard looking under rule;
   end if.

The clever looking under rule is listed instead of the standard looking under rule in the carry out looking under rules.

Part 4 - Placing Under

Chapter 1 - Action Definition

Placing it under is an action applying to two things.
Understand "put [things preferably held] under/beneath/underneath [something]" as placing it under.

The placing it under action has an object called the u-side.

Setting action variables for placing something under something:
   Now the u-side is a random underside that is part of the second noun.

Chapter 2a - Before and Precondition Rules  (for use with Implicit Actions by Eric Eve)

Before placing something under something (this is the take before placing under rule):
  if the u-side is not nothing and the noun is in the u-side,
     say "[The noun] [are] already under [the second noun]." (A) instead;
  
Precondition for placing something under something (this is the placing under precondition rule):
   if the noun is not carried, carry out the implicitly taking activity with the noun;
   if the noun is not carried, stop the action.


Chapter 2b - Before Rules  (for use without Implicit Actions by Eric Eve)

Before placing something under something (this is the take before placing under rule):
  if the u-side is not nothing and the noun is in the u-side,
     say "[The noun] [are] already under [the second noun]." (A) instead;
  if the noun is not carried begin;
      let actdesc be "trying to take";
      if the player can touch the noun and the noun is portable, let actdesc be "taking";
      say "(first [actdesc] [the noun])[command clarification break]" (B);
      silently try taking the noun;
   end if;
   if the noun is not carried, stop the action.

Chapter 3 - Check, Carry Out and Report

Check an actor placing something under the noun (this is the can't put anything under itself rule):
  say "Nothing can go under itself." (A) instead.


Check placing something under something (this is the can't put under any old thing rule):
  if the u-side is not an underside,  say "[We] [can't] put anything under [the second noun]." (A) instead.

Check someone placing something under something  (this is the someone can't put things under any old thing rule):
  if the u-side is not an underside,  stop the action.

Check an actor placing something under something (this is the test bulk underneath rule):
  if u-side is an underside and u-side provides the property bulk capacity begin;
     if the bulk of the noun > the bulk capacity of u-side,
        say "[The noun] [are] too big to fit under [the second noun]." (A) instead;
     if the bulk of the noun > the free capacity of u-side,
        say "[There] [are not] enough room left under [the second noun] for [the noun]." (B) instead;
  end if.

Carry out an actor placing something under something (this is the standard place under rule):
   move the noun to the u-side.

Report an actor placing something under something (this is the standard report place under rule):
  say "Done." (A).

Part 5 - Phrases for Under

To move (obj - an object) under/underneath (targetobj - a thing), making it hidden:
   if the targetobj encloses an underside (called the underpart) which is part of the targetobj begin;
      move the obj to the underpart;
      if making it hidden, now the underpart is closed;
   end if.

To decide whether (obj - an object) is contained under/underneath/beneath (targetobj - a thing):
    if the targetobj encloses an underside (called the underpart) which is part of the targetobj,  decide on whether or not the obj is in the underpart;
    decide no.

To decide which object is the associated/attached/appropriate underside of (obj - a thing):
    if an underside (called underpart) is part of obj, decide on underpart;
    decide on nothing.

Chapter 5a - Being Notionally Under (for use without Hiding Under by Eric Eve)

Notionally-underlying relates  a thing (called X) to a thing (called Y) when X is contained under Y.


Chapter 5b - Being Notionally Under (for use with Hiding Under by Eric Eve)

Notionally-underlying relates  a thing (called X) to a thing (called Y) when X is contained under Y or X is hidden under Y.


Chapter 5c - Notionally Under Verbs

The verb to be under implies the notionally-underlying relation.

Part 6 - Finding after Taking (for use without Hiding Under by Eric Eve)

To say previously-hidden-under (obj - a thing): say "hidden underneath".

To say reveal-hidden-under (obj - a thing):
  let underpart be a random underside that is part of the obj;
  say "Taking [the obj] reveals [a list of things in the underpart] [previously-hidden-under the noun].";

The taking action has an object called the place taken from.

Setting action variables for taking:
now the place taken from is the holder of the noun.

After taking something when an underside (called the underpart) is part of the noun  (this is the reveal what was underneath when taking rule):
  if something is in the underpart begin;
	 say reveal-hidden-under the noun;
 	 now everything in the underpart is in the place taken from;
  otherwise;
	continue the action;
  end if.
 
Part 7 - Conclusion

Underside ends here.

---- DOCUMENTATION ----

Chapter: Underside

Section: The Basics

The Underside extension defines the Underside kind (a kind of container), which can be used for putting objects under other objects.

To use it, we need to define an object to be of kind Underside, and then make it a part of the object we want to put things under. For example, if we want to be able to put things under a bed we might define:

	The bed is an enterable supporter.

	An underside called under#bed is part of the bed.

It's a good idea to give the underside object a name the player is unlikely to type, since the player never needs to refer to it directly.

To have an object start under the bed we can then just write:

	The slipper is a wearable thing in under#bed.

Then the command LOOK UNDER BED will report "Under the bed is a slipper."

The extension also provides the action "placing it under" which matches the grammar "put [things] under [something]". With the above example, PUT BALL UNDER BED would move the ball to under#bed, although to the player it would appear to be under the bed.

Section: Hiding and Finding Things Under Other Things

The extension further provides a pair of useful phrases:

	move something under something, making it hidden
	if something is under something

In the above example "the slipper is under the bed" would start out true. We could also use a phrase like "move the ball under the bed" to place the ball in under#bed. The phrase option "making it hidden" , as in "move the ball under the bed, making it hidden" would additionally ensure that the ball (and anything else under the bed) remained hidden from view until the player explicitly looks under the bed.

This works by making an underside closed by default, so that items in an underside are out of scope. Issuing a LOOK UNDER X command makes the corresponding underside open, so that its contents are now in scope (the player is now aware of everything that's under the bed). The phrase option "making it hidden" simply closes the underside again, concealing its contents from view. It may sometimes be useful to make an underside open or closed in our own code to achieve the effect we want. This is not quite ideal, since it's an all-or-nothing mechanism, that doesn't allow us to let the player be aware of some but not all items placed under something. In practice, if I put a ball under the desk I'll know the ball is there, but I may not know about the pen that's also there until I deliberately look under the bed. One way to handle this situation might be to make the underside open to start with, and only move the pen there before looking under it:

	*: The desk is a supporter in the Bedroom.
	An open underside called under#desk is part of the desk.

	The pen is a thing.

	Before looking under the desk when the pen is off-stage:
 	 move the pen under the desk.

What we're aiming to do here is to keep items that are meant to be hidden out of scope until the player explicitly finds them, so that they're not accidentally revealed by TAKE ALL, or by a disambiguation prompt (e.g. "Which ball do you mean, the red ball or the blue ball?" when the red ball is meant to be hidden under the bed).

An alternative approach would be to define the underside as open and use a "rule for deciding the concealed possessions", e.g.:

	Rule for deciding the concealed possessions of the under#bed:
  		if we have looked under the bed, decide no;
		if the particular possession is handled, decide no;
  		decide yes.

Or more generally:

	*: Rule for deciding the concealed possessions of an underside (called the underpart):
		if we have looked under the holder of the underpart, decide no;
		if the particular possession is handled, decide no;
		decide yes.

One potential downside of this approach, however, is that it may not work so well with Epistemology, which takes a short-cut route to deciding what the player has seen (in the interests of performance).

Section: Testing for things being under other things

We can test whether something is under something else with the "under" relation, e.g.

	if the pen is under the bed...
	now everything under the bed is carried by the player.
	say "Under the bed is [a list of things under the bed]."

If Underside is used with the Hiding Under extension, the 'under' relation will include items hidden under the target object as well as items in the target object's underside. Note that "to be under" is a relation that tests a condition, so we can't declare "the pen is under the bed", neither can we say "now the pen is under the bed".

We can use "contained under" to test for something being in another object's underside, e.g.

	if the pen is contained under the bed...

will be true if the pen is in the bed's underside (but not if the pen is hidden under the bed in the sense that the Hiding Under extension gives to "hidden under"). Note that "contained under" is a to decide phrase, not a relation, so it can only be used in tests, not in descriptions. 

The "to decide" phrase "associated underpart of (obj - a thing)" gives us a convenient method of getting the underside that's attached for a particular object, so, for example, we could write:

	say "Contained under the bed is [a list of items in the associated underpart of the bed]."

This may be more useful when writing a more general phrase, like:

	say "Contained under [the obj] is [a list of items in the associated underpart of the obj]."

This needs to be used with caution though; if obj has no underside attached then its associated underside will be nothing.

Section: Revealing when Taking

New to Version 4 of Underside, when you take an object that has objects in its underside, these objects are automatically revealed (that is, they're left behind, and a message is displayed saying what objects taking the concealing object has revealed).

We can tailor the message that's displayed by providing our own version of:

	To say reveal-hidden-under (obj - a thing):

By default this is defined as follows:

	To say reveal-hidden-under (obj - a thing):
		let underpart be a random underside that is part of the obj;
		say "Taking [the obj] reveals [a list of things in the underpart] [previously-hidden-under the noun].";

Note how we first have to obtain the relevant underside object (here using the underpart variable) before we can list what it contains. 

In turn, previously-hidden-under-under (obj - a thing) is defined as "hidden underneath"

Together this might give us an exchange like:

	>TAKE CHAIR
	Taking the chair reveals a red sock, a blue ball, and a black book hidden underneath.

We can customize either the final phrase ("hidden underneath") or the entire messaged by providing our versions of one or the other "to say" phrases mentioned above. Our own version could be something like:

	To say reveal-hidden-under (obj - a thing):
	  let underpart be a random underside that is part of obj;
	  say "On picking up [the obj] you notice [the list of things in the underpart] left behind on the floor."




Note that this is now similar to what happens with the Hiding Under extension, although the underlying mechanism used there is a little different.

Section: Underside and Other Extensions

Underside includes Bulk Limiter, and enforces checks that the total bulk of objects placed under something does not exceed the bulk capacity of its underside. It is compatible with Implicit Actions, insofar as it will use Implicit Actions to generate an implicit take command for PUT X UNDER Y when X is not carried, but it can also be used without Implicit Actions, in which case it will use its own code to perform an implicit take.

Underside may also be used with the Hiding Under extension (also by Eric Eve), which allows us to use statements like:

	The pen is hidden under the desk.
	Hide the pen under the desk.

For the full story, see the documentation for the Hiding Under extension.



Example: * Lost Sock - Putting and Finding Objects Under Other Objects.

	*: "Lost sock" by Eric Eve

	Include Underside by Eric Eve.

	Part 1 - Additional rule for taking

	Rule for deciding whether all includes scenery: it does not.

	Part 2 - Scenario

	The Bedroom is a room. "There's little room in here for anything but the bed, the desk and a solitary chair."

	The bed is an enterable scenery supporter in the Bedroom.

	An underside called under#bed is part of the bed.

	An odd sock is wearable. It is in under#bed.

	The player is holding a red ball.

	After dropping the red ball in the Bedroom:
	   move the red ball under the bed, making it hidden;
	   say "The red ball falls to the floor and rolls under the bed."

	The chair is an enterable portable supporter in the Bedroom.
	A red sock is on the chair.
	The bulk of the chair is 11.

	An underside called under#chair is part of the chair.

	The book is in under#chair.
	The scarf is in under#chair.

	The desk is a scenery supporter in the Bedroom.
	An open underside called under#desk is part of the desk.

	The pen is a thing.

	Before looking under the desk when the pen is off-stage:
	  move the pen under the desk.

	Test me with "Drop ball/look under bed/put red sock under bed/look under bed/take odd sock/take ball/take red sock/look under bed/take chair/look/take all/look under desk/take all".



