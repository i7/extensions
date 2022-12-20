Version 2.3.1 of Prepositional Correctness by Gavin Lambert begins here.

"Provides a way to customise the prepositions used to refer to containment or support, and perhaps other custom relationships added by other extensions."

Section - Preposition Framework

A thing has some text called preposition.  A thing has some text called capital preposition.
A thing has a verb called entering preposition.  A thing has a verb called exiting preposition.
The capital preposition of a thing is usually "[preposition of the item described in sentence case]".

Prepositionally naming something is an activity on objects.
Capital prepositionally naming something is an activity on objects.

To say at the (O - thing) -- running on:
	carry out the prepositionally naming activity with O.

To say At the (O - thing) -- running on:
	carry out the capital prepositionally naming activity with O.

To say enter the (O - thing) -- running on:
	say "[adapt entering preposition of O] [the O]".

To say entering the (O - thing) -- running on:
	say "[present participle of entering preposition of O] [the O]".

To say exit the (O - thing) -- running on:
	say "[adapt exiting preposition of O] [the O]".

To say exiting the (O - thing) -- running on:
	say "[present participle of exiting preposition of O] [the O]".

Last rule for prepositionally naming a thing (this is the standard prepositionally naming rule):
	say "[preposition of parameter-object] [the parameter-object]".

Last rule for capital prepositionally naming a thing (this is the standard capital prepositionally naming rule):
	say "[capital preposition of parameter-object] [the parameter-object]".

[These responses are here because they no longer contain any 'real' English text on their own]
The you-can-also-see rule response (B) is "[At the domain] [we] ".
The you-can-also-see rule response (C) is "[At the domain] [we] ".
The use initial appearance in room descriptions rule response (A) is "[At the item] ".
The describe what's on scenery supporters in room descriptions rule response (A) is "[At the item] ".
The describe what's on mentioned supporters in room descriptions rule response (A) is "[At the item] ".
The describe room gone into rule response (M) is "[at the vehicle gone by]".
The describe room gone into rule response (N) is "[at the vehicle gone by]".
The examine containers rule response (A) is "[At the noun] ".
The examine supporters rule response (A) is "[At the noun] ".
The standard search containers rule response (A) is "[At the noun] ".
The standard search supporters rule response (A) is "[At the noun] ".

Section - Room Description Headings

[These are called out separately so that they can be replaced without affecting the regular prepositions.]

Room heading describing something is an activity on objects.

Last rule for room heading describing a thing (called place) (this is the standard room heading description rule):
	say at the place.

To say room description heading description for (place - thing) -- running on:
	carry out the room heading describing activity with the place.

The room description heading rule response (B) is " ([room description heading description for the intermediate level])".
The room description heading rule response (C) is " ([room description heading description for the intermediate level])".

Section - Standard English

[These rules replicate the default behaviour of the Standard Rules.]
The verb to get into means the reversed containment relation.
The verb to get onto means the reversed support relation.
The verb to get out of means the reversed containment relation.
The verb to get off means the reversed support relation.
The preposition of a thing is usually "in".
The preposition of a supporter is usually "on".
The preposition of an animal is usually "on".
The entering preposition of a thing is usually verb get into.
The entering preposition of a supporter is usually verb get onto.
The exiting preposition of a thing is usually verb get out of.
The exiting preposition of a supporter is usually verb get off.
[There are a couple of places where the Standard Rules previously printed "inside" or "on top of" rather than "in" or "on" as we'll be doing now.
 It wouldn't be impossible to support these extra cases too, but I think this is already getting complex enough.]

[These aren't actually referenced anywhere in the code that I could find, but they do actually get called somehow.  Must be internal compiler magic.]
The list writer internal rule response (R) is "[preposition of the noun] [if the noun is a person]whom[otherwise]which[end if] ".
The list writer internal rule response (S) is ", [preposition of the noun] [if the noun is a person]whom[otherwise]which[end if] ".
The list writer internal rule response (T) is "[preposition of the noun] [if the noun is a person]whom[otherwise]which[end if] ".
The list writer internal rule response (U) is ", [preposition of the noun] [if the noun is a person]whom[otherwise]which[end if] ".

The can't drop if this exceeds carrying capacity rule response (A) is "[There] [are] no more room [at the receptacle]."
The can't drop if this exceeds carrying capacity rule response (B) is "[There] [are] no more room [at the receptacle]."
The stand up before going rule response (A) is "(first [exiting the chaise])[command clarification break]".
The can't travel in what's not a vehicle rule response (A) is "[We] [would have] to [exit the nonvehicle] first."
The can't travel in what's not a vehicle rule response (B) is "[We] [would have] to [exit the nonvehicle] first."
The can't enter what's already entered rule response (A) is "But [we]['re] already [at the noun]."
The can't enter what's already entered rule response (B) is "But [we]['re] already [at the noun]."
The can't enter closed containers rule response (A) is "[We] [can't] [adapt entering preposition of the noun] the closed [noun]."
The can't enter if this exceeds carrying capacity rule response (A) is "[There] [are] no more room [at the noun]."
The can't enter if this exceeds carrying capacity rule response (B) is "[There] [are] no more room [at the noun]."
The can't take what you're inside rule response (A) is "[We] [would have] to [exit the noun] first."
The can't get off things rule response (A) is "But [we] [aren't] [at the noun] at the [if story tense is present tense]moment[otherwise]time[end if]."
The standard search supporters rule response (B) is "[There] [are] nothing [at the noun]."
The can't search closed opaque containers rule response (A) is "[We] [can't see] [preposition of the noun], since [the noun] [are] closed."
The implicitly pass through other barriers rule response (A) is "([exiting the current home])[command clarification break]".
The implicitly pass through other barriers rule response (B) is "([exiting the current home])[command clarification break]".
The implicitly pass through other barriers rule response (C) is "([entering the target])[command clarification break]".
The implicitly pass through other barriers rule response (D) is "([entering the target])[command clarification break]".
The standard report entering rule response (A) is "[We] [enter the noun]."
The standard report entering rule response (B) is "[We] [enter the noun]."
The standard report entering rule response (C) is "[The actor] [enter the noun]."
The standard report entering rule response (D) is "[The actor] [enter the noun]."
The standard report exiting rule response (A) is "[We] [exit the container exited from]."
The standard report exiting rule response (B) is "[We] [exit the container exited from]."
The standard report exiting rule response (C) is "[The actor] [exit the container exited from]."

Section - Riding (for use with Rideable Vehicles by Graham Nelson)

The verb to mount means the reversed support relation.
The verb to dismount means the reversed support relation.
The preposition of a rideable animal is usually "riding".
The preposition of a rideable vehicle is usually "riding".
The entering preposition of a rideable animal is usually verb mount.
The exiting preposition of a rideable animal is usually verb dismount.

Prepositional Correctness ends here.

---- DOCUMENTATION ----

Chapter - Compatibility

This extension was written for Inform 6M62 and verified with Inform 10.1.2.  Since it delves heavily into Standard Library messages it is likely incompatible with any other version of Inform, but YMMV.

It does not depend on any other extensions, but does introduce some extra features to enhance "Rideable Vehicles by Graham Nelson" if you happen to be using that as well.

Chapter - Prepositions in General

Inform's world model currently only defines two types of things that can contain other things:
	
- Containers, which have things "in" them, and (if enterable) will show "(in the container)" in the room description heading.
- Supporters, which have things "on" them, and (if enterable) will show "(on the supporter)" in the room description heading.

Sometimes, however, we want to be more creative than this -- perhaps rather than "(on the ladder)" you'd rather see "(dangling from the ladder)".  Or in another case you might want "(under the chassis)" or perhaps even just "(lounging about)".  Or when describing the things contained in a closet, you might want to say "Hanging in the closet" rather than simply "In the closet".

This extension overrides a ton of internal things in the Standard Rules to (hopefully) allow you to replace *almost* all of the places where the default prepositions are used with your own item-specific ones:
	
	The preposition of the closet is "hanging inside".
	
Note that prepositions should always be specified in lower case.  They'll be automatically capitalised if required when used at the beginning of a sentence.  But if you don't like the automatic capitalisation, you can override it:
	
	The capital preposition of the closet is "Hanging within".
	
For more complex cases, you can either put if conditions in the preposition, or you can write a special rule -- but note that there are still a small number of places where only the preposition is used, not the rule:

	Rule for capital prepositionally naming a supporter (called the table):
		if the table is magical, say "Glowing runes surround [the table], illuminating";
		otherwise continue the activity.

Note that you need to specify the full text (typically including the name; while that's not mandatory it would usually be confusing without it), and (for the 'capital' variant only) needs to sound correct when followed by a list of objects.

Chapter - Entering/Exiting Prepositions

There are a few places where Inform wants to print a verb related to the preposition -- for example, when entering and exiting, it may want to use phrases like "get into" or "gets out of" or "getting onto".  These don't fit neatly into a simple text property since they need to adapt to the story narrative tense and whether the actor being mentioned is plural or not and a few other factors, so instead we're piggybacking on Inform's rich adaptive verb system to handle these.

To add a new action phrase, you first need to link it to a relation that Inform is aware of (while Inform does support verbs "for saying" that aren't linked to relations, it doesn't currently allow using prepositions with these for some reason):

	The verb to squeeze into means the reversed containment relation.
	The verb to pop out of means the reversed containment relation.
	The entering preposition of the small chest is the verb squeeze into.
	The exiting preposition of the small chest is the verb pop out of.
	
It doesn't really matter which relation you associate with them (unless you use the phrase elsewhere in your source text), but typically "reversed containment" and "reversed support" make the most sense, or perhaps another relation that is defined by an extension.

(And yes, you can just use a verb without a preposition, despite the property name.  But calling the property this keeps them logically related, despite not being entirely grammatically accurate.)

These don't have associated rules/activities, but if you need them to be dynamic for some reason then you can change the property during play as required.
	
Chapter - The Room Description Heading

By default, the same prepositions will be used in the room description heading (when inside or on top of something) as in other places.  However, since these are only printed for the player (whereas the others are most commonly used for things other than the player), it's fairly likely that you'd want to customise them independently.  This can be done through another activity:
	
	Rule for room heading describing the ladder: say "dangling from [the ladder]".
	Rule for room heading describing an animal (called the mount): say "riding [the mount]".
	
Note that you need to specify the full text that you want to appear in the parentheses, typically including the name of the thing that the player is inside or on, otherwise it may be confusing for the player.

Also note that these rules will only be used for the parenthetical extensions after the main location name -- if someone gets into a closet, then it will print the location name and follow the rule to print the closet's prepositional phrase afterwards; but if they then close the closet so they can no longer see the external room, then the closet is now the "visibility ceiling" and it will simply print its name without any parenthetical extensions and without trying these rules (unless the player were inside something else inside the closet).  If you really want to replace this text as well, then you'll have to use a different technique, such as:
	
	This is the closeted rule:
		say "[bold type]Hiding inside the closet[roman type][line break]";
		say run paragraph on with special look spacing.
		
	The closeted rule substitutes for the room description heading rule when the player is inside the closed closet.

Note that this requires more boilerplate, since you're replacing the entire standard rule.  (And this replacement rule doesn't check if the player is inside something else that is in turn inside the closet, so try to avoid doing that sort of thing, or you'll need a more complex rule or condition, or perhaps to intercept "printing the name" instead.)

Chapter - What's not affected

The response text for several actions (notably, the "putting it on" and "inserting it into" actions) have deliberately not been altered to use custom prepositions.  This is to remain consistent with the parser's grammar for the command itself.

If you want to recognise additional custom prepositions in player commands, then you will need to define additional commands and/or amend the grammar yourself.  Since Inform's parser is (in general) a left-to-right one, it isn't really feasible to have these parse using a preposition property for a not-yet-known second noun.

Chapter - Using with non-English languages

While this is heavily based on the English language version of the Standard Rules, it should in theory be feasible to provide similar support for other languages, provided they at least follow a somewhat similar grammatical structure.  This requires writing another extension that either entirely replaces this, or includes this along with a replacement section thusly:
	
	Section - Another Language (in place of Section - English Language in Prepositional Correctness by Gavin Lambert)
	
	Your definitions go here.

Example: * Excessive Comfort - Hiding in a closet, draping on a sofa, and lying on a bed.

	*: "Excessive Comfort"
	
	Include Prepositional Correctness by Gavin Lambert.
	
	Small Apartment is a room.  "An opulently decorated small apartment room, to a nearly ridiculous level for its size.  And yet, nothing actually appears out of place."
	
	A closet is an enterable openable lit container in the apartment.
	The description is "[if the player is inside the closet]It was a tight squeeze through some expensive leather coats, but you've found a space within.[otherwise]Mahogany.  Mmmmm-ahogany.[end if]  [closet state]".
	Understand "closet door" as the closet.  Understand "door" as the closet when the player is inside the closet.
	To say closet state:
		if the player is inside the closet:
			if the closet is open, say "The closet door is still open.";
			otherwise say "The closet is closed, but sufficient light still filters through to the inside.";
		otherwise:
			if the closet is open, say "The closet is invitingly open.";
			otherwise say "The closet is closed."
	
	A sofa is an enterable supporter in the apartment.
	The description is "You're not entirely sure what kind of upholstery this sofa is decked out in, but [if the player is on the sofa]it is the softest thing ever[otherwise]it looks invitingly soft[end if]."
	The preposition is "draped on".
	A plush cushion is on the sofa.
	
	A large bed is an enterable supporter in the apartment.
	The description is "[if the player is on the bed]It's like sleeping on a cloud.[otherwise]The sheets and spreads are entirely white, but not starkly so.  Somehow, airy.  Tempting."
	The preposition is "lying on".
	Understand "lie down/-- on [bed]" as entering.
	A fluffy pillow is on the bed.

	Rule for room heading describing the open closet: say "awkwardly standing inside [the closet]".
	Rule for room heading describing the sofa: say "lounging about on [the sofa]".
	Rule for room heading describing the bed: say "floating amongst the clouds".
	
	The verb to squeeze into means the reversed containment relation.
	The verb to pop out of means the reversed containment relation.
	The entering preposition of the closet is the verb squeeze into.
	The exiting preposition of the closet is the verb pop out of.

	Rule for printing the locale description for the closet: try examining the closet.

	Test me with "enter closet / l / close closet / l / open closet / sit on sofa / l / sit on bed / l".

Example: * Horseback - Riding a horse with Rideable Vehicles.

	*: "Horseback"
	
	Include Rideable Vehicles by Graham Nelson.
	Include Prepositional Correctness by Gavin Lambert.
	
	Grasslands is a room.  "Wide open grasslands stretch as far as the eye can see."

	A horse is a kind of rideable animal.  Understand "horse" as a horse.

	Spirit is a horse in Grasslands.  "Spirit grazes aimlessly nearby."
	The description is "This is your horse, of course, of course."

	Test me with "mount horse / l".
