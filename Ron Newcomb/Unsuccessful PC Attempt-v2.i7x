Version 2 of Unsuccessful PC Attempt by Ron Newcomb begins here.

"Will run the Unsuccessful Attempt By rules for all characters, including the player.  Also silences the library messages printed by the built-in Check rules."

Silent checks is a truth state that varies.  Silent checks is usually true.

This is the modified check stage rule: 
	anonymously follow the specific check rulebook;
	if [that] rule succeeded, [this] rule succeeds; [if a check rule succeeds, it ends action processing but does not call the Unsuccessful Attempt By rules. We mimic that here because it's useful: we can write a Check rule to both say a one-liner and end the action in a single line, and, we can still tell Unsuccessful Attempt to narrate a failed action without needing to ensure a one-line was said by checking The Reason The Action Failed against a list of rules that have one-liners. ]
	if the rule failed begin;
		if the actor is the player, follow the unsuccessful attempt by rules; [ ..will be called for NPCs from the usual place]
		rule fails;
	end if.

To anonymously follow (R - a rule): (- anon_follow({R}); -).

Include (-
[ anon_follow R;
	@push untouchable_silence; 
	untouchable_silence = (+ silent checks +);       ! checked by L__M() and related library functions
	if (reason_the_action_failed = FollowRulebook(R))    ! this sets, then tests, that variable
	{
		if (RulebookSucceeded()) ActRulebookSucceeds(reason_the_action_failed); 
		else ActRulebookFails(reason_the_action_failed); 
	}
	@pull untouchable_silence;  
];
-). 

The modified check stage rule is listed instead of the check stage rule in the specific action-processing rules.

Unsuccessful PC Attempt ends here.


---- DOCUMENTATION ----

Behavior in interactive fiction is not pre-determined but instead chosen moment to moment.  There are three instances where we may wish to comment on a kind of behavior:  before the behavior is tried, after the behavior is done, and after the behavior was attempted but wasn't able to be done.  For example, 

	Before an actor behaving ill-bred in the presence of the governess: 
		say "'Don't you dare do that.  Please remember what happened to poor Lydia!'".
	
	After an actor behaving ill-bred in the presence of the governess: 
		say "'You should be ashamed of yourself.  What if you had been seen?'".
	
	Unsuccessful attempt by an actor behaving ill-bred in the presence of the governess: 
		say "'Well I suppose you feel very foolish now.  Jane and Elizabeth would never have tried such a thing.'".

Typically in Inform, our player's character has their failed attempts narrated by the Check rules, and our non-player characters' failed attempts are narrated by the Unsuccessful Attempt By rules.  However, this presents two problems.  First, how do we comment on our player failing to achieve a general kind of behavior, since we cannot write "Check behaving ill-bred"?  And secondly, in games with multiple possible player-characters, where do we put the failure messages for each of them?  In our example, neither Kitty's or Mary's messages are always approprate for the Check rules, because we don't know ahead of time if the player wishes to be the studious Mary or sociable Kitty.  We don't wish to be prejudiced.

This small extension runs the Unsuccessful Attempt By rules for the player's character, treating him or her no differently than anyone else.  So when we write a rule beginning with "Unsuccessful attempt by an actor", we really mean it.  

By default, this extension silences the built-in library messages that Inform uses for check rules.  (Extensions will still print their messages, but most extensions are ready to have said messages replaced.)  The built-in library messages may be restored by:

	*: When play begins: change silent checks to false.


Example: * "Road Test" - Success and failure on the road to nowhere. 

	*: "Road Test"
	
	Include Unsuccessful Pc Attempt by Ron Newcomb.

	Unsuccessful attempt by an actor doing something: say "Oomph!  [Actor] can't because of the [reason the action failed]."

	The block sleeping rule is not listed in any rulebook.

	Check an actor sleeping (this is the gravel road rule): say "(Can't sleep here!)" instead.
	Check an actor waiting (this is the kinda already doing rule): say "(Waiting is a little too easy.)"; rule succeeds.

	Carry out an actor sleeping: say "[Actor] sleeps quietly."
	Carry out an actor waiting: say "[Actor] waits quietly."

	Sleeping is being silly.

	A gravel road is a room. Bob is a man in a gravel road. A stop sign is fixed in place in a gravel road. Persuasion: rule succeeds.

	Test me with "sleep / bob, sleep / wait / bob, wait / take stop sign / bob, take stop sign ".




