Version 2 of Scope Control by Ron Newcomb begins here.

"Allows us to ask why the Deciding the Scope For Something activity is running, so we can modify the scope only when we absolutely need to.  Highly useful for giving NPCs commands over telephones or while in darkness, creating 'can hear' relations, or modifying how Inform parses the command line."

To decide if parsing the/a/an/some/any/-- nouns: (- (scope_reason == 0) -).
To decide if parsing for/-- persuasion: (- (scope_reason == 1) -).
To decide if looping over scope: (- (scope_reason == 5) -).
To decide if testing scope: (- (scope_reason == 6) -).

Section - really only useful for testing scope control - not for release - unindexed 

The reason for deciding scope is a number that varies.
The reason for deciding scope variable translates into I6 as "scope_reason".

To say the/-- reason for deciding scope:
	if the reason for deciding scope is:
		-- 0: say "parsing nouns";
		-- 1: say "parsing for persuasion";
		-- 5: say "looping over scope";
		-- 6: say "testing scope";
		-- otherwise: say "other".

Scope Control ends here.


---- DOCUMENTATION ----

Deciding what a character can interact with at any given moment is determined by her senses and the physical reality of her universe.  The complicated reasoning to enforce all this is collectively called "scope".  Chapter 12 of Writing with Inform talks of this at length under the rubrics of reachability and visibility. 

However, both technology and magic can overcome such obstacles.  Clairvoyance and cell phones exist in many universes, so player commands such as BOB, REACH OUT AND TOUCH SOMEONE should be possible without undue difficulty.

While the Deciding the Scope of Something activity can naïvely modify scope this way:

	*: After deciding the scope of the player while the player calls someone: 
		place the other party of the player in scope.

...it causes certain problems, such as the player being able to see, hear, and touch what he should only be able to hear:

	> JESSE, LOOK
	"I'm still across town.  I'll call you back when I get close."

	> EXAMINE JESSE
	She looks exhausted from the confusing drive. 

This extension allows four conditions that can be attached to rules in the Deciding the Scope of Something activity.  They are:
	while parsing the nouns
	while parsing for persuasion
	while looping over scope
	while testing scope

Hence, we can modify scope correctly:

	*: After deciding the scope of the player while parsing for persuasion and while the player calls someone: 
		place the other party of the player in scope.


Example: * "Asking for Directions" - A new internet acquaintance needs our help.

Try the following test both with and without including this extension and its purpose becomes clear.

	*: "Asking for Directions"
	
	Include Scope Control by Ron Newcomb.
	
	Chapter 1 - The Emerald City
	
	The smell of coffee is a backdrop. A person can be lost in it.  Persuasion rule when the actor is lost in it: persuasion succeeds.
	
	Pike Place Market is west of Bauhaus Coffeeshop.  Bauhaus Coffeeshop is south of your apartment.  Yourself is in your apartment.
	
	Some salmon is in Pike Place Market.  A salmon dinner is in your apartment. 
	
	Coffee is everywhere.
	
	Jesse is a woman in Pike Place Market.  Jesse is lost in it.
	
	After looking for the first time: say "Your phone rings.  'Hey, it's Jesse.  How do I get to your place?'". 
	
	Chapter 2 - scope changes while we're on the phone
	
	Section 1 - the old way (for use without Scope Control by Ron Newcomb)
	
	After deciding the scope of the player when Jesse is lost in it:
		place Jesse in scope.
	
	Section 2 - the new way (for use with Scope Control by Ron Newcomb)
	
	After deciding the scope of the player while parsing for persuasion and Jesse is lost in it: 
		place Jesse in scope.
	
	Chapter 3 - Maze of Streets
	
	After anyone going: say "'OK.'". 
	
	Instead of Jesse going nowhere: say "'I think I'm lost.  Are you sure you gave me good directions?'"; now Jesse is in Pike Place Market; rule succeeds.
	
	After Jesse looking: say "'I think I'm at [the location of Jesse].'"
	
	A description of Jesse is "A brunette in a pullover hoodie and jeans, with legs made for striding up hills, Jesse has finally made it out to visit." 
	
	Test me with "jesse, look / jesse, e / jesse, s / examine jesse / * She's not in front of me, so I shouldn't be able to examine her right now. / jesse, look / jesse, e / jesse, n / jesse, look / examine jesse ".

