Version 2 of Introductions by Emily Short begins here.

"Introductions provides an introductory paragraph about objects in a room description the first time the player looks in that location. It also allows the author to add segue text that will appear between one description and the next."

Section 1 - Introductions for objects

A thing can be as-yet-unknown or introduced. A thing is usually as-yet-unknown.
A thing has some text called the introduction. The introduction of a thing is usually "".

Definition: a thing is introduceable if it is as-yet-unknown and its introduction is not "" and it is visible.
	
To introduce (special-target - an object):
	now the special-target is introduced;
	say "[introduction of the special-target]".

Rule for writing a paragraph about an introduceable thing (called special-target) (this is the introduce unknowns rule):
	now the special-target is mentioned;
	introduce the special-target; 
	now the special-target is holding-paragraph-break.

A thing can be holding-paragraph-break or paragraph-complete.
	
After writing a paragraph about something (called original-target) which segue-suggests an introduceable thing (called special-target) (this is the connect related paragraphs rule): 
	segue from original-target to special-target;
	if the special-target is not introduced, 
		carry out the writing a paragraph about activity with the special-target;
	otherwise say fake-paragraph-break;
	now the original-target is paragraph-complete;
	now the special-target is paragraph-complete.

After writing a paragraph about something (called special-target) which is holding-paragraph-break: 
	now the special-target is paragraph-complete;
	say fake-paragraph-break.

fake-paragraph-break is some text that varies. fake-paragraph-break is "[line break]".
	
segue-suggesting relates various things to various things. The verb to segue-suggest (it segue-suggests, they segue-suggest, it segue-suggested, it is segue-suggested, it is segue-suggesting) implies the segue-suggesting relation.

When play begins (this is the initialize segues rule):
	repeat through the Table of Segues:
		now first entry segue-suggests second entry.

To segue from (original item - a thing) to (next item - a thing):
	repeat through Table of Segues:
		if original item is the first entry:
			if the next item is the second entry:
				say " [segue entry]";
				blank out the whole row;
				rule succeeds.

To say override intro/introduction of/for (N - a thing):
	now N is mentioned;
	now N is introduced.
	
Table of Segues
first (a thing)	second (a thing)	segue (text)
--	--	--


Section 2 - Room Introductions

A room has some text called the introduction. The introduction of a room is usually "".
Definition: a room is introduceable if it is as-yet-unknown and its introduction is not "".

A room can be as-yet-unknown or introduced. A room is usually as-yet-unknown.

The first time looking rule is listed last in the carry out looking rules.

This is the first time looking rule: 
	if location is introduceable:
		introduce the location;
		say paragraph break.

Introductions ends here.

---- Documentation ----

Introductions allows the author to write introductions that will appear the first time the player sees certain items and rooms, and also to create segues drawing two passages of introductory text together.

Chapter: Things

Section: Introductory text for things

Introductions allows us to write special introductory text that will appear the first time the player sees an object in a room description, like this:

	The introduction of the table is "In the corner is the table your aunt bought from the thrift store. The top surface of it is decoupaged with newspaper advertisements for organic produce. You can't eat a bowl of macaroni without being chided by images of alfalfa and bran."

This text will appear in place of the initial appearance property or any other similar text that might otherwise introduce the table.

Section: Segues between object introductions

We can also write segues to be shown between two specific items being introduced.

If Introductions introduces one item, and a second, segue-related item is scheduled to be introduced later in the room description, it will change the order in which it produces output in order to use the segue.

To create new segues, we must add to the Table of Segues, thus:

	Table of Segues (continued)
	first	second	segue
	orange	apple	"And speaking of fruit... "
	apple	orange	"You've never really cared for fruits, though. "   

Section: Segues that completely replace existing introductions

There may be times when we want our segue to completely override the introduction of the second item, rather than merely adding text to the beginning of it. In that case, we can override the introduction entirely, like this:

	Table of Segues (continued)
	first	second	segue 
	apple	mare	"[override intro for the mare]The apple was probably brought here as a bribe for the mare in the corner, but it doesn't look as though she was interested." 

Section: Spacing introductions and segues

The segue text will be printed after the introduction of the first item and before the introduction of the second; by default, there is no paragraph break anywhere here, which gives us maximum freedom to add our own. If, for instance, we wanted to produce the text

	Fred is prowling near the fireplace, looking morose. He's an old friend of yours, but lately you've found him more and more difficult to take: all his little tics -- impatience, rudeness, tendency to interrupt -- have grown more pronounced since Lisa left. Some of your social circle now act as though he weren't there at all, as though his stammered, tactless commentary were no more than background noise from a radio.

	Fred is no favorite with Doctor Pearson, either, which is why you're surprised to see the old man sitting serenely in the leather recliner, sipping a vodka gimlet.

we could create this effect by putting the paragraph break inside the segue, thus:

	Table of Segues (continued)
	first	second	segue
	Fred	Doctor Pearson	"[paragraph break][override intro for Pearson]Fred is no favorite with Doctor Pearson, either, which is why you're surprised to see the old man sitting serenely in the leather recliner, sipping a vodka gimlet. "

Chapter: Rooms

Section: Introductions

Finally, we can provide introductions for a whole room, and that text will appear as a final item in the room description, after the objects there, as in

	Pipe Crossing
	This is a meeting of several pipes: one leads abruptly down and to the north, while gently upward-sloping pipes lead southeast and southwest. A cold and murky white liquid flows from both southern pipes into the northern one.

	A licorice gum drop has been caught by one of the seams of metal, doubtless the only reason it has not been swept away by the current.

	It smells like almonds in here. <-- this is the room introduction.

Section: Adding one-time text elsewhere in a room description

This is hardly the only place where we might want to add special text to a room description, but most other places are easier to add to using existing entry points. For instance, if we wanted

	You catch a whiff of almonds as you splash downstream... <-- this is the new text

	Pipe Crossing
	This is a meeting of several pipes: one leads abruptly down and to the north, while gently upward-sloping pipes lead southeast and southwest. A cold and murky white liquid flows from both southern pipes into the northern one.

	A licorice gum drop has been caught by one of the seams of metal, doubtless the only reason it has not been swept away by the current.

we would instead write

	After going to Pipe Crossing:
		if Pipe Crossing is not visited, say "You catch a whiff of almonds as you splash downstream.";
		continue the action.

Or if we wanted that one-time text to appear just before or after the main room description paragraph, like this

	Pipe Crossing
	The smell of almonds is overpowering when you enter. <-- this is the one-time text

	This is a meeting of several pipes: one leads abruptly down and to the north, while gently upward-sloping pipes lead southeast and southwest. A cold and murky white liquid flows from both southern pipes into the northern one.

we might write

	The description of Pipe Crossing is "[if unvisited]The smell of almonds is overpowering when you enter. [paragraph break][end if]This is a meeting of several pipes: one leads abruptly down and to the north, while gently upward-sloping pipes lead southeast and southwest. A cold and murky white liquid flows from both southern pipes into the northern one."

or similarly 

	Pipe Crossing
	This is a meeting of several pipes: one leads abruptly down and to the north, while gently upward-sloping pipes lead southeast and southwest. A cold and murky white liquid flows from both southern pipes into the northern one.

	The smell of almonds is overpowering when you enter. <-- this is the one-time text

we might write

	The description of Pipe Crossing is "This is a meeting of several pipes: one leads abruptly down and to the north, while gently upward-sloping pipes lead southeast and southwest. A cold and murky white liquid flows from both southern pipes into the northern one.[if unvisited][paragraph break]The smell of almonds is overpowering when you enter. [end if]"

Chapter: Troubleshooting and Compatibility

Section: Introductions don't appear for objects in the room

Introductory text will appear for an object that is in a room for description, unless we have explicitly written a writing a paragraph about rule that is more specific and takes precedence over the default rule.

For instance, the following would prevent the appearance of the table's introduction:

	Rule for writing a paragraph about the table:
		say "A TABLE IS HERE."

Section: Introductions don't appear for objects on supporters

Introductions relies on the writing a paragraph about activity, which, by default, is activated for objects appearing in the room, but not for those which are visibly set on supporters. We can explicitly override this if we want to.

One way to do this is demonstrated in the "Kill Doctor Pearson" example, below. It works best, though, if the supporters in question are not scenery.

Note that this is a complication that arises with the default behavior of Inform; the replacement room description extensions Tailored Room Description and Ordinary Room Description are more customizable.

Section: Using with alternative room description extensions

Introductions can be used on its own, or in combination with the extensions Tailored Room Description or Ordinary Room Description. 

Ordinary Room Description emulates the default output of Inform, and is useful primarily because it allows us to use the base extension Room Description Control: we get the same type of output as usual, but with increasing control over the order in which items are printed within the description, and more ability to omit our chosen objects from the description entirely.

Tailored Room Description provides an alternate type of output, which gets rid of parenthetical remarks such as "(on which are a bone and a piece of dried grass)" in favor of full sentences describing contents and supported objects.

To use Introductions with one of these extensions, we should install Room Description Control and either Ordinary Room Description or Tailored Room Description; include the extension of our choice; and then add

	When play begins:
		change fake-paragraph-break to "[line break][line break][run paragraph on]".

This latter portion is necessary because there are slight differences in the way the extensions handle paragraph breaking, and without it the spacing will look wrong in some circumstances.

Introductions is *not* compatible with the Single Paragraph Description extension.

Example: *  Marzipan Sea - Several objects with introductions and segues flowing together.

	*: "Marzipan Sea"

	Include Introductions by Emily Short. Include Ordinary Room Description by Emily Short.

	Pipe Crossing is a room.  "This is a meeting of several pipes: one leads abruptly down and to the north, while gently upward-sloping pipes lead southeast and southwest. A cold and murky white liquid flows from both southern pipes into the northern one."

	The introduction of Pipe Crossing is "There is a strange smell of almonds here." 

	Instead of smelling Pipe Crossing:
		say "Definitely almonds, sweet and bitter at once." 

	The licorice gum drop is in Pipe Crossing. 
		The introduction is "[A licorice gum drop] has been caught by one of the seams of metal, doubtless the only reason it has not been swept away by the current." [This will be printed on first viewing.]
		The initial appearance is "The licorice gum drop is still lodged in place." [This will be printed on subsequent viewings, until the player moves the gum drop.]
	
	The walnut shell boat is a vehicle in Pipe Crossing.
		The introduction is "A hollowed walnut shell, just large enough for you to ride inside, spins in an eddy of the current." 
		The initial appearance is "The walnut shell bobs on the surface of the water, ready for you to ride."
	
	The paper is in Pipe Crossing. "A bit of paper bobs on the waves." [this is also an initial appearance, to be printed after the introduction.]
		The introduction is "Some paper bobs on the surface of the water, reminding you of a small boat." [this is the introduction of the paper, but it will not actually appear, because we have a segue (below) from the walnut boat which completely overrides this introduction.] 

	Table of Segues (continued)
	first	second	segue
	licorice gum drop	walnut boat	"The gum drop is not the only bit of detritus from above, either. " 
	walnut boat	paper	"[override intro for paper]Swirling into the same vortex is a small bit of paper. " 

	Test me with "look".

Example: ** Kill Doctor Pearson - A slightly more complex example where NPCs are scattered around at the beginning of play. Demonstrates how to handle introductions of objects that start on supporters, which might not otherwise get their own paragraphs.

In this scenario, we are going to randomize where the characters start at the beginning of play in order to demonstrate a slightly more complex treatment of introductions. We'll also have one character who starts out on a supporter, rather than in a room: this needs special treatment because, under normal circumstances, the paragraph would be written about the supporter rather than about the supported object. 

	*: "Kill Doctor Pearson"

	Include Introductions by Emily Short. 

	When play begins:
		repeat with pawn running through people who are not the player
		begin;
			move pawn to a random room;
		end repeat;
		move Doctor Pearson to a random enterable supporter.

	Doctor Pearson is a man.
		The introduction is "Doctor Pearson is resting in [the holder of Pearson]. He winks at you as you walk in: the man has never mastered the concept of discretion, and at 65 he apparently thinks you still cherish hopes of reliving the affair you had twenty years ago, when you were a vulnerable seventeen."

	Fred is a man.
		The introduction is "[initial appearance of Fred] He's an old friend of yours, but lately you've found him more and more difficult to take: all his little tics -- impatience, rudeness, tendency to interrupt -- have grown more pronounced since Lisa left. Some of your social circle now act as though he weren't there at all, as though his stammered, tactless commentary were no more than background noise from a radio."
		The initial appearance is "Fred is prowling near [the random scenery thing which is in the location], looking morose. "
	
	Annie is a woman.
		The introduction is "It's a relief to see Annie: solid and dependable, Annie keeps secrets and acts sensible."
		The initial appearance is "Annie stands nearby. Only someone well-acquainted with her would be able to see how tense she feels."

	Rule for writing a paragraph about a supporter which supports Pearson when Pearson is not mentioned:
		carry out the writing a paragraph about activity with Pearson instead.

	[And to prevent mention of those supporters when someone is not sitting in them:]

	Rule for writing a paragraph about an enterable supporter (called target):
		now the target is mentioned;
		rule succeeds.

	The Library is a room. The fireplace is scenery in the Library. The leather recliner is an enterable supporter in the Library.

	North of the Library is the Home Theater. The comfy chair is an enterable supporter in the Home Theater. The screen is scenery in the Home Theater.

	Table of Segues (continued)
	first   	 second   	 segue
	Fred   	 Doctor Pearson   	 "[paragraph break][override intro for Pearson]Fred is no favorite with Doctor Pearson, either, which is why you're surprised to see the old man sitting serenely in [the holder of Pearson], sipping a vodka gimlet. "	
	Fred	Annie	"[paragraph break][override intro for Annie]Annie gives you a kind of wry look: solid, sensible Annie, she is kinder to Fred than most others, but that's because she practices a disciplined sort of kindness, not because she doesn't find him irritating."
	Annie	Fred	"She will have had plenty of chance to practice, too: "

	Test me with "look / north / look".

The "rule for writing a paragraph about an enterable supporter" is designed to keep Inform from mentioning the chairs unless someone is sitting in them. Note that this rule won't work with Tailored Room Description because there are already other, more complex rules about supporters that will take priority through normal rule-ordering.

On the other hand, with TRD we could use a description-concealing rule to omit any mention of those supporters anyway.