Version 1/200925 of Prepositional Correctness by Gavin Lambert begins here.

"Provides rulebooks that allow customising the extra description of the player's location heading when in or on something."

Section - Framework

The room description heading description rules are an object based rulebook with default success.
The room description heading preposition rules are an object based rulebook with default success.

Last room description heading description rule for a thing (called place) (this is the standard room heading description rule):
	follow the room description heading preposition rules for the place;
	say " [the place]".

To say room description heading description for (place - thing) -- running on:
	follow the room description heading description rules for the place.

The room description heading rule response (B) is " ([room description heading description for the intermediate level])".
The room description heading rule response (C) is " ([room description heading description for the intermediate level])".

Section - Standard English

[These rules replicate the default behaviour of the Standard Rules.  They also deliberately don't use response text since they're trivial to override and replace entirely.]
Last room description heading preposition rule for a supporter (this is the standard supporter preposition rule): say "on".
Last room description heading preposition rule for an animal (this is the standard animal preposition rule): say "on".
Last room description heading preposition rule (this is the standard other preposition rule): say "in".

Prepositional Correctness ends here.

---- DOCUMENTATION ----

By default, when the player enters a supporter or container, Inform will automatically amend the room description heading to show "(on the chair)" or "(in the chest)" or similar.

Sometimes, however, we want to be more creative than this -- perhaps rather than "(on the ladder)" you'd rather see "(dangling from the ladder)".  Or in another case you might want "(under the chassis)" or perhaps even just "(lounging about)".

This extension defines two rulebooks that can be used to customise the text printed in these situations.  The first is typically the one you'll most commonly want to use, which simply allows you to specify a word or phrase to replace "X" in "(X the Y)", where Y is the thing you're in/on.

	Room description heading preposition for the ladder: say "dangling from".
	Room description heading preposition for the bed: say "lazing about on".
	Room description heading preposition for a ledge: say "precariously edging along".
	Room description heading preposition for an animal: say "riding".
	
If for some reason you want to replace the name of the place as well ("the Y"), you can use this form instead, where you specify all of the text that appears in the parentheses.  This can be anything you like, and doesn't have to mention the name at all, although you should try to avoid confusing the player (unless that's the goal, of course).

	Room description heading description for the ladder: say "desperately clinging onto the rungs for dear life".
	
Since these are rules, you can either name specific objects, entire kinds, or use adjectives or other conditions to figure out which rule should apply and what to say.  But by default once it enters the rule you must say something -- or it will not try other rules and say anything, which will look weird.  If you have some additional conditions that you want to check after entering the body of the rule, and they determine that this rule doesn't apply, then you should explicitly "make no decision":
	
	Room description heading preposition for a thing (called place):
		if the player is not afraid of the place, make no decision;
		say "fearfully tiptoeing around".
		
For these sorts of conditions, you can often merge them into the rule heading itself instead:
	
	Room description heading preposition for a thing (called place) when the place is uncomfortable: say "restlessly shuffling about on".

It's worth mentioning that there are many other places in the Standard Library where the "in" or "on" text can be printed, and this extension makes no attempt to intercept all of these.  It is purely focused (at least in the current incarnation) on the room description heading alone.

Finally, note that all of these rules only apply for things that the player is in or on within a larger room or thing that is still visible.  While multiple of these can apply and be printed in turn, these rules don't apply to the top level -- usually the room itself, but potentially something else, for example if the player is inside a closed container.  In that case, it will *not* call these rules -- it will just print the name and stop.  For that situation, you'll need to use another technique (such as conditionally overriding the "room description heading rule") if you want to display something fancier:
	
	This is the closeted rule:
		say "[bold type]Hiding inside the closet[roman type][line break]";
		say run paragraph on with special look spacing.
		
	The closeted rule substitutes for the room description heading rule when the player is inside the closed closet.

Note that this requires more boilerplate, since you're replacing the entire standard rule.  (And this replacement rule doesn't check if the player is inside something else that is in turn inside the closet, so try to avoid doing that sort of thing, or you'll need a more complex rule or condition.)

Example: * Excessive Comfort

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
	
	A large bed is an enterable supporter in the apartment.
	The description is "[if the player is on the bed]It's like sleeping on a cloud.[otherwise]The sheets and spreads are entirely white, but not starkly so.  Somehow, airy.  Inviting."
	Understand "lie down/-- on [bed]" as entering.
	
	Room description heading preposition for the open closet: say "awkwardly standing inside".
	Room description heading preposition for the sofa: say "lounging about on".
	Room description heading description for the bed: say "floating amongst the clouds".

	Rule for printing the locale description for the closet: try examining the closet.

	Test me with "enter closet / close closet / l / open closet / exit / sit on sofa / l / sit on bed / l".
