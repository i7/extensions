Conversation Touchability Fix by Daniel Stelzer begins here.

"A simple change to the Standard Rules to allow conversation to work without a touchable noun."

Use authorial modesty.

Section - Replacements (in place of Section SR4/6 - Standard actions concerning other people in Standard Rules by Graham Nelson)

Giving it to is an action applying to one carried thing and one thing.
The giving it to action translates into I6 as "Give".

The specification of the giving it to action is "This action is indexed by
Inform under 'Actions concerning other people', but it could just as easily
have gone under 'Actions concerning the actor's possessions' because -
like dropping, putting it on or inserting it into - this is an action
which gets rid of something being carried.

The Standard Rules implement this action fully - if it reaches the carry
out and report rulebooks, then the item is indeed transferred to the
recipient, and this is properly reported. But giving something to
somebody is not like putting something on a shelf: the recipient has
to agree. The final check rule, the 'block giving rule', assumes that
the recipient does not consent - so the gift fails to happen. The way
to make the giving action use its abilities fully is to replace the
block giving rule with a rule which makes a more sophisticated decision
about who will accept what from whom, and only blocks some attempts,
letting others run on into the carry out and report rules."

Check an actor giving something to (this is the can't give what you haven't got rule):
	if the actor is not the holder of the noun:
		if the actor is the player:
			say "[We] [aren't] holding [the noun]." (A);
		stop the action.

Check an actor giving something to (this is the can't give to yourself rule):
	if the actor is the second noun:
		if the actor is the player:
			say "[We] [can't give] [the noun] to [ourselves]." (A);
		stop the action.

Check an actor giving something to (this is the can't give to a non-person rule):
	if the second noun is not a person:
		if the actor is the player:
			say "[The second noun] [aren't] able to receive things." (A);
		stop the action.

Check an actor giving something to (this is the can't give clothes being worn rule):
	if the actor is wearing the noun:
		say "(first taking [the noun] off)[command clarification break]" (A);
		silently try the actor trying taking off the noun;
		if the actor is wearing the noun, stop the action;

Check an actor giving something to (this is the block giving rule):
	if the actor is the player:
		say "[The second noun] [don't] seem interested." (A);
	stop the action.

Check an actor giving something to (this is the can't exceed carrying capacity
	when giving rule):
	if the number of things carried by the second noun is at least the carrying
		capacity of the second noun:
		if the actor is the player:
			say "[The second noun] [are] carrying too many things already." (A);
		stop the action.

Carry out an actor giving something to (this is the standard giving rule):
	move the noun to the second noun.

Report an actor giving something to (this is the standard report giving rule):
	if the actor is the player:
		say "[We] [give] [the noun] to [the second noun]." (A);
	otherwise if the second noun is the player:
		say "[The actor] [give] [the noun] to [us]." (B);
	otherwise:
		say "[The actor] [give] [the noun] to [the second noun]." (C).

Showing it to is an action applying to one carried thing and one visible thing.
The showing it to action translates into I6 as "Show".

The specification of the showing it to action is "Anyone can show anyone
else something which they are carrying, but not some nearby piece of
scenery, say - so this action is suitable for showing the emerald locket
to Katarina, but not showing the Orange River Rock Room to Mr Douglas.

The Standard Rules implement this action in only a minimal way, checking
that it makes sense but then blocking all such attempts with a message
such as 'Katarina is not interested.' - this is the task of the 'block
showing rule'. As a result, there are no carry out or report rules. To
make it into a systematic and interesting action, we would need to
unlist the block showing rule and then to write carry out and report
rules: but usually for IF purposes we only need to make a handful of
special cases of showing work properly, and for those we can simply
write Instead rules to handle them."

Check an actor showing something to (this is the can't show what you haven't
	got rule):
	if the actor is not the holder of the noun:
		if the actor is the player:
			say "[We] [aren't] holding [the noun]." (A);
		stop the action.

Check an actor showing something to (this is the convert show to yourself to
	examine rule):
	if the actor is the second noun:
		convert to the examining action on the noun.

Check an actor showing something to (this is the block showing rule):
	if the actor is the player:
		say "[The second noun] [are] unimpressed." (A);
	stop the action.

Waking is an action applying to one thing.
The waking action translates into I6 as "WakeOther".

The specification of the waking action is "This is the act of jostling
a sleeping person to wake him or her up, and it finds its way into the
Standard Rules only for historical reasons. Inform does not by default
provide any model for people being asleep or awake, so this action does
not do anything in the standard implementation: instead, it is always
stopped by the block waking rule."

Check an actor waking (this is the block waking rule):
	if the actor is the player:
		now the prior named object is nothing;
		say "That [seem] unnecessary." (A);
	stop the action.

Throwing it at is an action applying to one carried thing and one visible thing.
The throwing it at action translates into I6 as "ThrowAt".

The specification of the throwing it at action is "Throwing something at
someone or something is difficult for Inform to model. So many considerations
apply: just because the actor can see the target, does it follow that the
target can accurately hit it? What if the projectile is heavy, like an
anvil, or something not easily aimable, like a feather? What if there
is a barrier in the way, like a cage with bars spaced so that only items
of a certain size get through? And then: what should happen as a result?
Will the projectile break, or do damage, or fall to the floor, or into
a container or onto a supporter? And so on.

Because it seems hopeless to try to model this in any general way,
Inform instead provides the action for the user to attach specific rules to.
The check rules in the Standard Rules simply require that the projectile
is not an item of clothing still worn (this will be relevant for women
attending a Tom Jones concert) but then, in either the 'futile to throw
things at inanimate objects rule' or the 'block throwing at rule', will
refuse to carry out the action with a bland message.

To make throwing do something, then, we must either write Instead rules
for special circumstances, or else unlist these check rules and write
suitable carry out and report rules to pick up the thread."

Check an actor throwing something at (this is the implicitly remove thrown clothing rule):
	if the actor is wearing the noun:
		say "(first taking [the noun] off)[command clarification break]" (A);
		silently try the actor trying taking off the noun;
		if the actor is wearing the noun, stop the action;

Check an actor throwing something at (this is the futile to throw things at inanimate
	objects rule):
	if the second noun is not a person:
		if the actor is the player:
			say "Futile." (A);
		stop the action.

Check an actor throwing something at (this is the block throwing at rule):
	if the actor is the player:
		say "[We] [lack] the nerve when it [if story tense is the past
			tense]came[otherwise]comes[end if] to the crucial moment." (A);
	stop the action.

Attacking is an action applying to one thing.
The attacking action translates into I6 as "Attack".

The specification of the attacking action is "Violence is seldom the answer,
and attempts to attack another person are normally blocked as being unrealistic
or not seriously meant. (I might find a shop assistant annoying, but IF is
not Grand Theft Auto, and responding by killing him is not really one of
my options.) So the Standard Rules simply block attempts to fight people,
but the action exists for rules to make exceptions."

Check an actor attacking (this is the block attacking rule):
	if the actor is the player:
		now the prior named object is nothing;
		say "Violence [aren't] the answer to this one." (A);
	stop the action.

Kissing is an action applying to one thing.
The kissing action translates into I6 as "Kiss".

The specification of the kissing action is "Possibly because Inform was
originally written by an Englishman, attempts at kissing another person are
normally blocked as being unrealistic or not seriously meant. So the
Standard Rules simply block attempts to kiss people, but the action exists
for rules to make exceptions."

Check an actor kissing (this is the kissing yourself rule):
	if the noun is the actor:
		if the actor is the player:
			say "[We] [don't] get much from that." (A);
		stop the action.

Check an actor kissing (this is the block kissing rule):
	if the actor is the player:
		say "[The noun] [might not] like that." (A);
	stop the action.

Answering it that is an action applying to one visible thing and one topic.
The answering it that action translates into I6 as "Answer".

The specification of the answering it that action is "The Standard Rules do
not include any systematic way to handle conversation: instead, Inform is
set up so that it is as easy as we can make it to write specific rules
handling speech in particular games, and so that if no such rules are
written then all attempts to communicate are gracefully if not very
interestingly rejected.

The topic here can be any double-quoted text, which can itself contain
tokens in square brackets: see the documentation on Understanding.

Answering is an action existing so that the player can say something free-form
to somebody else. A convention of IF is that a command such as DAPHNE, TAKE
MASK is a request to Daphne to perform an action: if the persuasion rules in
force mean that she consents, the action 'Daphne taking the mask' does
indeed then result. But if the player types DAPHNE, 12375 or DAPHNE, GREAT
HEAVENS - or anything else not making sense as a command - the action
'answering Daphne that ...' will be generated.

The name of the action arises because it is also caused by typing, say,
ANSWER 12375 when Daphne (say) has asked a question."

Report an actor answering something that (this is the block answering rule):
	if the actor is the player:
		now the prior named object is nothing;
		say "[There] [are] no reply." (A);
	stop the action.

Telling it about is an action applying to one visible thing and one topic.
The telling it about action translates into I6 as "Tell".

The specification of the telling it about action is "The Standard Rules do
not include any systematic way to handle conversation: instead, Inform is
set up so that it is as easy as we can make it to write specific rules
handling speech in particular games, and so that if no such rules are
written then all attempts to communicate are gracefully if not very
interestingly rejected.

The topic here can be any double-quoted text, which can itself contain
tokens in square brackets: see the documentation on Understanding.

Telling is an action existing only to catch commands like TELL ALEX ABOUT
GUITAR. Customarily in IF, such a command is shorthand which the player
accepts as a conventional form: it means 'tell Alex what I now know about
the guitar' and would make sense if the player had himself recently
discovered something significant about the guitar which might interest
Alex."

Check an actor telling something about (this is the telling yourself rule):
	if the actor is the noun:
		if the actor is the player:
			say "[We] [talk] to [ourselves] a while." (A);
		stop the action.

Report an actor telling something about (this is the block telling rule):
	if the actor is the player:
		now the prior named object is nothing;
		say "This [provoke] no reaction." (A);
	stop the action.

Asking it about is an action applying to one visible thing and one topic.
The asking it about action translates into I6 as "Ask".

The specification of the asking it about action is "The Standard Rules do
not include any systematic way to handle conversation: instead, Inform is
set up so that it is as easy as we can make it to write specific rules
handling speech in particular games, and so that if no such rules are
written then all attempts to communicate are gracefully if not very
interestingly rejected.

The topic here can be any double-quoted text, which can itself contain
tokens in square brackets: see the documentation on Understanding.

Asking is an action existing only to catch commands like ASK STEPHEN ABOUT
PENELOPE. Customarily in IF, such a command is shorthand which the player
accepts as a conventional form: it means 'engage Mary in conversation and
try to find out what she might know about'. It's understood as a convention
of the genre that Mary should not be expected to respond in cases where
there is no reason to suppose that she has anything relevant to pass on -
ASK JANE ABOUT RICE PUDDING, for instance, need not conjure up a recipe
even if Jane is a 19th-century servant and therefore almost certainly
knows one."

Report an actor asking something about (this is the block asking rule):
	if the actor is the player:
		now the prior named object is nothing;
		say "[There] [are] no reply." (A);
	stop the action.

Asking it for is an action applying to two things.
The asking it for action translates into I6 as "AskFor".

The specification of the asking it for action is "The Standard Rules do
not include any systematic way to handle conversation, but this is
action is not quite conversation: it doesn't involve any spoken text as
such. It exists to catch commands like ASK SALLY FOR THE EGG WHISK,
where the whisk is something which Sally has and the player can see.

Slightly oddly, but for historical reasons, an actor asking himself for
something is treated to an inventory listing instead. All other cases
are converted to the giving action: that is, ASK SALLY FOR THE EGG WHISK
is treated as if it were SALLY, GIVE ME THE EGG WHISK - an action for
Sally to perform and which then follows rules for giving.

To ask for information or something intangible, see the asking it about
action."

Check an actor asking something for (this is the asking yourself for something rule):
	if the actor is the noun and the actor is the player:
		try taking inventory instead.

Check an actor asking something for (this is the translate asking for to giving rule):
	convert to request of the noun to perform giving it to action with the second noun and the actor.

Conversation Touchability Fix ends here.

---- DOCUMENTATION ----

This is a simple extension to make conversational actions require visibility rather than touchability by replacing part of the Standard Rules. Tested with 6L38, don't know about earlier or later versions.
