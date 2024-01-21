Version 2.1 of After Not Doing Something by Ron Newcomb begins here.

"Allows us to write rules that happen after an action fails, such as 'After not examining or searching something'. 'After Not Doing Something' is short for 'After Failing To Do Something'"

The after not rules are an action based rulebook.
The after not rules have default success.

Section BeginAction v10+ (for use with Basic Inform by Graham Nelson)

Include (-
[ BeginAction a n s moi notrack rv previous_actor;
	 ChronologyPoint();

	 @push action; @push noun; @push second; @push self; @push multiple_object_item;

	 action = a; noun = n; second = s; self = noun; multiple_object_item = moi;
	 if (action < 4096) { 
		previous_actor = actor;
		rv = ActionPrimitive();
		if (rv == false && RulebookFailed()) {
			actor = previous_actor;
			FollowRulebook((+ the after not rules +));
		}
	 }

	 @pull multiple_object_item; @pull self; @pull second; @pull noun; @pull action;

	 if (notrack == false) TrackActions(true, meta);
	 return rv;
]; 
-) replacing "BeginAction".

Section BeginAction (for use without Basic Inform by Graham Nelson)

Include (-
[ BeginAction a n s moi notrack rv previous_actor;
	 ChronologyPoint();

	 @push action; @push noun; @push second; @push self; @push multiple_object_item;

	 action = a; noun = n; second = s; self = noun; multiple_object_item = moi;
	 if (action < 4096) { 
		previous_actor = actor;
		rv = ActionPrimitive();
		if (rv == false && RulebookFailed()) {
			actor = previous_actor;
			FollowRulebook((+ the after not rules +));
		}
	 }

	 @pull multiple_object_item; @pull self; @pull second; @pull noun; @pull action;

	 if (notrack == false) TrackActions(true, meta);
	 return rv;
]; 
-).

Include (- -) instead of "Begin Action" in "Actions.i6t".  [ rulechange_sp isn't declared until later ]

After Not Doing Something ends here.

---- DOCUMENTATION ----

Inform has always allowed us to write rules which take place after a character has done something.

	After doing something to the fragile wineglass, say "Careful, that's real crystal."

But Inform doesn't allow us the same flexibility if whatever action we were attempting failed.  This extension addresses this by allowing us to write "after not" rules.

	After not taking or climbing something, say "Maybe if you washed the butter off your fingers?"

Just like the After and Instead rules, the After Not rules will only run the single most applicable rule, unless of course that rule ends with "make no decision".

Section: Changelog

2/220518 Modified by Zed Lopez for v10 compatibility

Example: * I Try, and I Try - Some people are never happy.

	*: "I Try, and I Try"

	Include after not doing something by Ron Newcomb.

	Your parent's house is a room. Your disapproving mother is a woman, here. A TV is fixed in place, here.

	After not doing something, say "In the background, you hear your mother sigh.  'Oh if you'd only worked harder, [the current action] wouldn't be a problem now, would it?'"

	After not pushing or rubbing something, say "Your mother sighs.  'Here, *I'll* get it for you.'"

	Test me with "go outside / turn on TV / dust TV / push TV / nap".


