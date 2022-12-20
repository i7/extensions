Version 2.0.221220 of Enterable Underside by Gavin Lambert begins here.

"Adds the ability to enter 'under' some object, such as hiding under a bed."

"Inspired by and based on a forum post by Eric Conrad."

Include Underside by Eric Eve.
Include Prepositional Correctness by Gavin Lambert.

Section - Misc Patches to other extensions

The clever looking under rule response (A) is "Under [the noun] [is-are a list of locale-supportable things in the underpart]."

Carry out placing something under something closed (this is the reveal underside contents when placing under rule):
	[This doesn't actually list the contents of the underside, as the player has pushed an object in without looking.  But we
	 do need to allow the objects underneath to be considered in scope, to let them refer to the object they just put there.]
   now the u-side is open.

To decide whether (obj - an object) is enclosed under/underneath/beneath (targetobj - a thing):
	if the targetobj encloses an underside (called the underpart) which is part of the targetobj,  decide on whether or not the obj is enclosed by the underpart;
	decide no.
	
Notionally-indirectly-underlying relates  a thing (called X) to a thing (called Y) when X is enclosed under Y.

The verb to be enclosed under implies the notionally-indirectly-underlying relation.

[This is a little bit of hammerspace logic -- if the player is somewhere where a large object won't fit, and yet are
 still carrying that large object, they still shouldn't be allowed to drop it there.]
Check an actor dropping (this is the can't drop what won't fit by bulk rule):
	let the receptacle be the holder of the actor;
	if the receptacle provides the property bulk capacity:
		if the bulk of the noun is greater than the bulk capacity of the receptacle:
			if the receptacle is an underside:
				say "[The noun] [are] too big to fit under [the holder of the receptacle]." (A) instead;
			otherwise:
				say "[The noun] [are] too big to fit in [the receptacle]." (B) instead;
		if the bulk of the noun is greater than the free capacity of the receptacle:
			if the receptacle is an underside:
				say "[There] [are not] enough room left under [the holder of the receptacle] for [the noun]."  (C) instead;
			otherwise:
				say "[There] [are not] enough room left in [the receptacle] for [the noun]."  (D) instead.
  
Section - Prepositional Correctness

The verb to get under means the reversed containment relation.
The verb to get out from under means the reversed containment relation.

The preposition of an underside is usually "under".
The printed name of an underside is usually "[preposition of the item described] [the holder of the item described]".
The entering preposition of an underside is usually the verb get under.
The exiting preposition of an underside is usually the verb get out from under.

To say enter underneath to the (O - underside) -- running on:
	say "[adapt entering preposition of O] [the holder of O]".

To say entering underneath to the (O - underside) -- running on:
	say "[present participle of entering preposition of O] [the holder of O]".

To say exit underneath from the (O - underside) -- running on:
	say "[adapt exiting preposition of O] [the holder of O]".

To say exiting underneath from the (O - underside) -- running on:
	say "[present participle of exiting preposition of O] [the holder of O]".

Rule for room heading describing a thing (called the surrounding) when the player is enclosed under the surrounding (this is the standard underside preposition rule):
	say printed name of the associated underside of surrounding.

Section - Entering the Underside

Entering underneath is an action applying to one thing.

The specification of the entering underneath action is "Entering underneath is the action allowing the player to enter the 'underside' of some object -- whereas the regular 'entering' action applies to the top-side instead.  Note that the noun of this action is the object that incorporates the underside, not the underside itself.  By default this is not permitted unless the underside is marked as enterable."

The entering underneath action has an object called the underside being entered.

Setting action variables for entering underneath:
	now the underside being entered is a random underside that is part of the noun.

Check an actor entering underneath (this is the can't enter underneath something with no underside rule):
	if the underside being entered is nothing:
		if the actor is the player, say "[There's] no space under [regarding the noun][those]." (A);
		stop the action.

Check an actor entering underneath (this is the can't enter underneath something already entered rule):
	let the local ceiling be the common ancestor of the actor with the underside being entered;
	if the local ceiling is the underside being entered:
		if the actor is the player, say "But [we]['re] already under [the noun]." (A);
		stop the action.

To enter is a verb.
Check an actor entering underneath (this is the can't enter underneath something not enterable rule):
	if the underside being entered is not enterable:
		if the actor is the player, say "[We] [can't enter] [regarding the noun][those]." (A);
		stop the action.
		
Check an actor entering underneath (this is the can't fit underneath something rule):
	if the bulk of the actor > the bulk capacity of the underside being entered:
		if the actor is the player, say "[We]['re] too big to fit under [the noun]." (A);
		stop the action;
	if the bulk of the actor > the free capacity of the underside being entered:
		if the actor is the player, say "[There] [are not] enough room left under [the noun]." (B);
		stop the action.

Check an actor entering underneath (this is the implicitly pass underneath other barriers rule):
	let the original noun be the noun;
	now the noun is the underside being entered;
	follow the implicitly pass through other barriers including undersides rule;
	now the noun is the original noun;
	if the rule failed, stop the action.

Carry out an actor entering underneath (this is the standard enter underneath rule):
	surreptitiously move the actor to the underside being entered.
	
Report an actor entering underneath (this is the standard report enter underneath rule):
	if the actor is the player:
		if the action is not silent:
			say "[We] [enter underneath to the underside being entered]." (A);
	otherwise:
		say "[The actor] [enter underneath to the underside being entered]." (B);
	continue the action.

Report an actor entering underneath (this is the describe contents entered underneath rule):
	if the actor is the player, try looking under the noun.

Section - Exiting the Underside

[Mostly the standard 'exit' action works fine for exiting *from* an underside, but we need to fix up the response.]

Report an actor exiting when the container exited from is an underside (this is the standard report exiting underneath rule):
	if the action is not silent:
		if the actor is the player:
			say "[We] [exit underneath from the container exited from]." (B);
		otherwise:
 			say "[The actor] [exit underneath from the container exited from]." (C);
		stop the action;
	continue the action.
	
[We also need a bit of extra work to correctly exit *to* an underside, since normally Inform doesn't like exiting to parts.]

Carry out an actor exiting when the holder of the container exited from is an underside (this is the standard underside exiting rule):
	let the former exterior be the holder of the container exited from;
	surreptitiously move the actor to the former exterior;
	stop the action. [this still reports, it just prevents the standard carry out from running]

Carry out an actor getting off when the holder of the noun is an underside (this is the standard underside getting off rule):
	let the former exterior be the holder of the noun;
	surreptitiously move the actor to the former exterior;
	stop the action. [this still reports, it just prevents the standard carry out from running]

Section - Underside Indirection

[It really feels like there ought to be a better way to restructure Inform's world model than this.]

Check an actor entering (this is the implicitly pass through other barriers including undersides rule):
	if the holder of the actor is the holder of the noun, continue the action;
	let the local ceiling be the common ancestor of the actor with the noun;
	while the holder of the actor is not the local ceiling:
		let the current home be the holder of the actor;
		if the player is the actor:
			if the current home is an underside:
				say "([exiting underneath from the current home])[command clarification break]" (F);
			otherwise if the current home is a supporter or the current home is an animal:
				[say text of implicitly pass through other barriers rule response (A);]
				say "([exiting the current home])[command clarification break]" (A);
			otherwise:
				[say text of implicitly pass through other barriers rule response (B);]
				say "([exiting the current home])[command clarification break]" (B);
		silently try the actor trying exiting;
		if the holder of the actor is the current home, stop the action;
	if the holder of the actor is the noun, stop the action;
	if the holder of the actor is the holder of the noun, continue the action;
	let the target be the holder of the noun;
	if the noun is part of the target, let the target be the holder of the target;
	while the target is a thing:
		if the target is an underside and the holder of the target is in the local ceiling:
			if the player is the actor, say "([entering underneath to the target])[command clarification break]" (G);
			silently try the actor trying entering underneath the holder of the target;
			if the holder of the actor is not the target, stop the action;
			convert to the entering action on the noun;
			continue the action;
		otherwise if the holder of the target is the local ceiling:
			if the player is the actor:
				if the target is a supporter:
					[say text of implicitly pass through other barriers rule response (C);]
					say "([entering the target])[command clarification break]" (C);
				otherwise if the target is a container:
					[say text of implicitly pass through other barriers rule response (D);]
					say "([entering the target])[command clarification break]" (D);
				otherwise:
					[say text of implicitly pass through other barriers rule response (E);]
					say "(entering [the target])[command clarification break]" (E);
			silently try the actor trying entering the target;
			if the holder of the actor is not the target, stop the action;
			convert to the entering action on the noun;
			continue the action;
		let the target be the holder of the target.
		
The implicitly pass through other barriers including undersides rule is listed instead of the implicitly pass through other barriers rule in the check entering rulebook.

Section - Describing the Underside

For printing a locale paragraph about a thing (called the roof) when the player is under the roof (this is the underside contents reporting rule):
	if an underside (called the underpart) is part of the roof and a locale-supportable thing is in the underpart:
		set pronouns from the roof;
		repeat with possibility running through things in the underpart:
			now the possibility is marked for listing;
			if the possibility is mentioned:
				now the possibility is not marked for listing;
		increase the locale paragraph count by 1;
		say "[capital preposition of the underpart] [the roof] " (A);
		list the contents of the underpart, as a sentence, including contents,
			giving brief inventory information, tersely, not listing
			concealed items, prefacing with is/are, listing marked items only;
		say ".[paragraph break]";
	continue the activity.
	
Section - Not describing the Topside

[This doesn't actually move the topside out of scope, so it's still possible to interact with things if you know they're there already.]

Rule for choosing notable locale objects when the player is under something (called the roof) (this is the don't describe things on top when underneath rule):
	repeat with item running through things held by the roof:
		set the locale priority of the item to 0;
	continue the activity.

Enterable Underside ends here.

---- DOCUMENTATION ----

This extension is based on Underside by Eric Eve, extending that to support the player actually entering the underside of objects.

It defines one new action, "entering underneath", which can move the player (or another actor) underneath any object that has had an underside created for it.  By default, this requires that the underside (specifically) has been declared as "enterable".

Naturally, the space under things is often quite limited.  Underside uses the Bulk Limiter extension (also by Eric Eve) to manage this; see the documentation for that extension for more details on setting the "bulk" (size) of each object and the "bulk capacity" (available space) in the underside.  By default, entering underneath will only be allowed if there's enough free space in the underside for the actor to actually fit.  (Although note that a little bit of Hammerspace may apply here -- by default the player's inventory is not counted in their bulk, so they can quite happily enter underneath something while carrying something else too large to fit underneath.  You can fix this by carefully setting the player's bulk capacity (so that they cannot pick up enough things to not fit) and/or dynamically changing the player's bulk depending on their current inventory.)

Note that this extension only introduces the new action -- it does not introduce any corresponding grammar to allow the player to actually perform it.  This is because depending on the specific objects in your story, different commands may make more sense than others.  You can define whatever commands you like; for example:
	
	Understand "hide under/beneath [something]" as entering underneath.

You can alternatively trigger "try entering underneath bed" from some other command's rules, as you'd expect, even if you don't define any commands for it.

You may also want to override the default response text to make it more suitable for the commands you're using, for example:
	
	can't enter underneath something not enterable rule response (A) is "[regarding the noun][Those] [aren't] something [we] [can] hide under."
	
Have a look at the "entering underneath" action in the Index for all the standard responses (and to quickly edit them using the 'set' link).

Since this builds on top of Prepositional Correctness, you're also able to customise the "under" preposition used in the room heading when the player is underneath, or in room descriptions when other objects are:

	The preposition of under#bed is "beneath".

Example: * Hide and Seek - Hiding under beds, tables, or chairs.

	*: "Hide and Seek"
	
	Include Enterable Underside by Gavin Lambert.
	
	Bedroom is a room.  It contains a small bed, a table, and a chair.
	The bed is an enterable fixed in place supporter.
	The table is an enterable fixed in place supporter.
	The chair is an enterable fixed in place supporter.
	Rule for room heading describing the bed: say "lying on a comfortable bed".

	A fluffy pillow is on the bed.  The bulk is 2.

	An enterable underside called under#bed is part of the bed.
	The bulk capacity of under#bed is 5.  The bulk of the player is 4.
	
	An enterable underside called under#table is part of the table.
	The bulk capacity of under#table is 3.
	
	A large blanket is in under#bed.  The bulk is 3.
	A small stuffed bear is in under#bed.

	Understand "hide under/beneath [something]" as entering underneath.

	Test me with "hide under bed / look under bed / get blanket / hide under bed / l / exit".

Example: * The Sweet Life - Also hiding under a bed, but with more drama.

	*: "The Sweet Life" by Eric Conrad

	Include Enterable Underside by Gavin Lambert.

	Understand "hide under/underneath [something]" as entering underneath.

	Bedroom is a room.

	The bed is an enterable supporter.  It is in the bedroom.  The player is on the bed.  Angelina is a woman on the bed.

	The under#bed is an underside.  It is part of the bed.  It is enterable and transparent.

	The shoebox is a container.  It is in the under#bed.  Roberto is a man.  He is in the under#bed.

	After looking under the bed for the first time:
		say "'Angelina?  How could you -- with Roberto?'".

	[ Two normal people can just fit under the bed provided there is nothing else there. ]
	The bulk of a person is usually 5.

	When play begins:
		now the story viewpoint is first person singular;
		say "[italic type](Dedicated to those dubbed Italian comedies from the early 1970s)[roman type][paragraph break]The door to the apartment slams shut.  From the hallway, the voice calls out 'Mi amore, I'm home.'  Panic-stricken, Angelina looks at me and whispers 'It's Giovanni.  Quickly, you must hide!'  Giovanni's steps grow softer as he walks toward the kitchen.  She breathes a sigh of relief as we hear the refrigerator open.  'Now hide.'  She points down, under the bed.".

	Arrival is a scene.  Arrival begins when the player is in the under#bed.

	When arrival begins:
		say "As Giovanni enters the bedroom, he says, 'Mia cara!  It's so fine to be home.'  Angelina answers, 'O Giovanni, I missed you so.  Please buy some wine to celebrate!'[paragraph break]As her husband leaves for the store, she says, 'Both of you, out!'";
		try Roberto exiting.

	Test me with "exit / look under bed / hide under bed / take shoebox / hide under bed / exit".
	
Example: * A Nice Picnic - Spreading out a picnic blanket underneath a tree.

Undersides are not really intended to model large spaces like this, since they deliberately conceal what lies underneath unless you're actively looking under.  But they can -- and until version 2 this sort of thing didn't work due to some quirks in how Inform handles entering and exiting things with component parts, so this serves as a demonstration that this has been worked around successfully.

	*: "A Nice Picnic"
	
	Include Enterable Underside by Gavin Lambert.
	
	Picnic Area is a room.  "A bright open area close to a large tree.  [if the blanket is carried]You can either set up your picnic out in the open or under the tree.[end if]".
	A large tree is scenery in Picnic Area.  The description is "An oak, you think."
	An underside called under#tree is part of the tree.  It is enterable and transparent.  The preposition is "beneath".
	The verb to go beneath means the reversed containment relation.  The entering preposition of under#tree is verb go beneath.
	
	The player carries a large checkered blanket and a small picnic basket.  The blanket is an enterable supporter.  The basket is a locked container.
	
	Understand "sit under/beneath [tree]" as entering underneath.

	Test me with "put blanket under tree / sit on blanket / drop basket / l / exit / exit".
