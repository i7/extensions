Version 1/200925 of Enterable Underside by Gavin Lambert begins here.

"Adds the ability to enter 'under' some object, such as hiding under a bed."

"Inspired by and based on a forum post by Eric Conrad."

Include Underside by Eric Eve.
Include Prepositional Correctness by Gavin Lambert.

Section - Misc Patches to other extensions

The clever looking under rule response (A) is "Under [the noun] [is-are a list of locale-supportable things in the underpart]."

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

Room description heading description for a thing (called the surrounding) when the player is under the surrounding and an underside (called the underpart) is part of the surrounding (this is the standard underside preposition rule): say "under [the surrounding]".

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
	follow the implicitly pass through other barriers rule;
	now the noun is the original noun;
	if the rule failed, stop the action.

Carry out an actor entering underneath (this is the standard enter underneath rule):
	surreptitiously move the actor to the underside being entered.
	
Report an actor entering underneath (this is the standard report enter underneath rule):
	if the actor is the player:
		if the action is not silent:
			say "[We] [get] under [the noun]." (A);
	otherwise:
		say "[The actor] [get] under [the noun]." (B);
	continue the action.

Report an actor entering underneath (this is the describe contents entered underneath rule):
	if the actor is the player, try looking under the noun.

the implicitly pass through other barriers rule response (D) is "(getting [if the target is an underside]under [the holder of the target][otherwise]into [the target][end if])[command clarification break]".

Section - Exiting the Underside

[Mostly the standard 'exit' action works fine, but we need to fix up the response.]

Report an actor exiting when the container exited from is an underside (this is the standard report exiting underneath rule):
	if the action is not silent:
		if the actor is the player:
			say "[We] [get] out from under [the holder of the container exited from]." (B);
		otherwise:
 			say "[The actor] [get] out from under [the holder of the container exited from]." (C);
		stop the action;
	continue the action.

the implicitly pass through other barriers rule response (B) is "(getting out [if the current home is an underside]from under [the holder of the current home][otherwise]of [the current home][end if])[command clarification break]".

Section - Describing the Underside

For printing a locale paragraph about a thing (called the roof) when the player is under the roof (this is the underside contents reporting rule):
	if an underside (called the underpart) is part of the roof and a locale-supportable thing is in the underpart:
		set pronouns from the roof;
		repeat with possibility running through things in the underpart:
			now the possibility is marked for listing;
			if the possibility is mentioned:
				now the possibility is not marked for listing;
		increase the locale paragraph count by 1;
		say "Under [the roof] " (A);
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

Section: Known Bugs

The Underside extension implements the undersides as a part of the object that they're under.  When this object is itself a container or supporter, then Inform's model of the world gets a bit confused by the whole idea of a thing that contains things directly while having another part that contains different things.  This is mostly a bug in the Standard Library itself (or at least an overly simplistic world view).  How it currently manifests in practice is that if you put one container or supporter (call it B) underneath another (call it A), then entering B causes Inform to believe that you are now in/on both A and B (and in particular, no longer under A, even though B is still under A).  Currently, you should just try to avoid getting into that sort of situation.

Example: * Hide and Seek

	*: "Hide and Seek"
	
	Include Enterable Underside by Gavin Lambert.
	
	Bedroom is a room.  It contains a small bed, a table, and a chair.
	The bed is an enterable fixed in place supporter.
	The table is an enterable fixed in place supporter.
	The chair is an enterable fixed in place supporter.
	A room description heading description rule for the bed: say "lying on a comfortable bed".

	A fluffy pillow is on the bed.  The bulk is 2.

	An enterable underside called under#bed is part of the bed.
	The bulk capacity of under#bed is 5.  The bulk of the player is 4.
	
	An enterable underside called under#table is part of the table.
	The bulk capacity of under#table is 3.
	
	A large blanket is in under#bed.  The bulk is 3.
	A small stuffed bear is in under#bed.

	Understand "hide under/beneath [something]" as entering underneath.

	Test me with "look under bed / get blanket / hide under bed / l / exit".
