Version 1.3 of World Knowledge by Jeff Nyman begins here.

"Mechanics to represent the player's knowledge and understanding about the world."

"based partly on Epistemology by Eric Eve and Optimized Epistemology by Andrew Plotkin"

Part - Observability (for use without Epistemology by Eric Eve)

To mark-everything-in-scope-as-seen:
	(- MarkSeenScopeFor(player); -).

Include (-
	! LoopOverScope(routine, actor) calls the given routine for each object in scope.
	! It calls routine_id(obj_id) for each obj_id in scope. If the optional actor is
	! supplied, that defines the scope. In this context, it will apply seen/familiar to
	! every item in scope. Here the "--> 1" is a word array variable reference with
	! two entries: familiarization --> 0 ("familiar") and familiarization --> 1 ("seen").
	[ MarkSeenScopeFor obj;
		LoopOverScope(((+ familiarization +)-->1), obj);
	];
-);

Part - Sight (for use without Epistemology by Eric Eve)

A thing can be examined or unexamined.
A thing is usually unexamined.

After examining something:
	now the noun is examined.

A thing can be seen or unseen.
A thing is usually unseen.

Carry out looking (this is the mark items as seen when looking rule):
	mark-everything-in-scope-as-seen.
	
Carry out an actor opening a container (this is the mark items as seen upon opening a container rule):
	mark-everything-in-scope-as-seen.

The mark items as seen upon opening a container rule is listed after the standard opening rule in the carry out opening rules.

Part - Familiarity (for use without Epistemology by Eric Eve)

A thing can be familiar or unfamiliar.
A thing is usually unfamiliar.

To familiarize (T - thing) (this is familiarization):
	now T is familiar;
	now T is seen.

Carry out examining something visible (this is the mark items as seen on examining rule):
	familiarize the noun.

Part - Knowledge State

Definition: a thing is known rather than unknown if it is familiar or it is seen.

Section - Subjects

A knowledge subject is a kind of thing.

A knowledge subject is usually familiar.

The specification of a knowledge subject is "Represents a concept, entity or idea that has no real-world presence or functionality."

Section - Suppositions

A supposition is a kind of thing.

The specification of a supposition is "Represents an uncertain belief on the part of the player character."

Awareness relates various people to various suppositions.
The verb to be aware of means the awareness relation.

Section - Facts

A fact is a kind of thing.

The specification of a fact is "Represents something that is known or proved to be true from the standpoint of the player character."

Knowledge relates various people to various facts.
The verb to establish means the knowledge relation.

Definition: a fact is unconfirmed rather than confirmed if it is not established by the player.

Part - Testing - not for release

Requesting knowledge status of is an action out of world applying to one visible thing.

Understand "kstate [any thing]" as requesting knowledge status of.

Report requesting knowledge status of (this is the report knowledge status rule):
	say "[noun]";
	if the noun is a supposition:
		say "  (SUPPOSITION)";
	if the noun is a fact:
		say "  (FACT)";
	say "[line break]
		[if the noun is examined]examined[otherwise]unexamined[end if] /
		[if the noun is seen]seen[otherwise]unseen[end if] /
		[if the noun is familiar]familiar[otherwise]unfamiliar[end if] /
		[if the noun is known]known[otherwise]unknown[end if]";
	if the noun is a supposition:
		say " / [if the player is aware of the noun]aware of[otherwise]not aware of[end if]";
	if the noun is a fact:
		say " / [if the noun is established by the player]established[otherwise]not established[end if] /
		[if the noun is unconfirmed]unconfirmed[otherwise]confirmed[end if]";
	say "." (A).

World Knowledge ends here.

---- DOCUMENTATION ----

This extension is partly based on one called "Epistemology" by Eric Eve. As a concept, epistemology refers to the study of how we know what we know. As such, the title of the original extension was a bit grandiose at best since it dealt not at all with concepts like the scope of knowledge, epistemic justification, or the rationality of belief; all of which are in the ambit of epistemology.

The aim here is a bit simpler, which is to model the very basics of how people come to know certain things about the world around them, which is generally by becoming aware of them.

Given that more modest goal, the purpose of the extension is quite simply to keep track of what objects the player character knows about, either because they have seen the objects or because they are already familiar with them for some other reason, such as prior knowledge. This extension will also model the idea of being aware of something (a supposition) and direct knowledge of something (a fact).

Section: Sight and Familiarity

With this extension in place, all objects in the story world have the following either-or distinctions:
	
(1) seen or unseen

(2) familiar or unfamiliar

(3) known or unknown

By default, all objects start unseen and unfamiliar and hence unknown. As an author you can, of course, change this for individual objects, groups of objects or kinds. A few points are important:
	
(1) The seen/unseen and familiar/unfamiliar pairs can be tested or set as is required.

(2) The known/unknown status may be tested for but not directly changed in code.

That second point must be the case since the known/unknown status derives from the other two.

Section: State of Knowledge

Given the above points, the following general rule holds: a thing is considered to be known if it is either seen or familiar; otherwise it is unknown.

These distinctions exist to model different kinds of knowledge. Consider, for example, that the player character may well know about things they have yet to see. For example, a detective character is sent to investigate a particular crime. That certainly means they, at the very least, know of the crime and, possibly, they know who the crime was committed against.

The player character may also know of or be familiar with things that can't be seen, such as concepts like crime (in a general sense) or justice and so on. Likewise, a detective may come to be familiar with certain motivations that some other character had for committing the crime. A motivation could be something internal that the player character learns about but also tied to something tangible, such as finding incriminating evidence. Of those aspects, only one could be said to be "seen" in any sense.

Things that are known about but as yet unseen or concepts that are abstract can be marked as familiar, either from the outset, or when the player learns about them during the course of the game. Also, there may be cases where it's important to distinguish whether the player character has actually seen something -- like, say, a crime scene -- or merely knows about it.

Section: Implementation

As far as possible, the extension tries to keep track of what the player character has seen in two ways.

(1) Marking as seen (and familiar) everything that's in plain view (i.e., in scope) in the location when a LOOK command is executed.

(2) Marking eveything as seen (and familiar) in plain view within a container when that container is opened.

This is a lot of calculation and this extension does incorporate changes made by Andrew Plotkin to Eric Eve's extension, essentially putting in some optimizations to the algorithm to avoid potential performance issues with games that have a lot of objects in the model world.

In general a few points about how this works:
	
(1) When the player opens a container, all objects in the room (not just the container) are marked "seen".

(2) When the player LOOKs or OPENs, objects added to scope (with the "deciding the scope of" activity) are marked "seen".

The simple way to summarize all this is that this extension only marks objects "seen" when the player looks around, opens a container, or examines something. This includes the case of when they move to a different room, which invokes LOOK. This does mean, however, that objects which are moved into a room might not be "seen" until the player does LOOK or EXAMINE.

Section: Familiarizing

The phrase "familiarize (thing)" is provided to mark a thing as both "seen" and "familiar".

You can also use the phrase "mark-everything-in-scope-as-seen" to re-scan the entire room. In fact, if you want to be absolutely certain about marking every object that appears, you can add this rule:
	
	Every turn: mark-everything-in-scope-as-seen.
	
That said, it's worth noting that this may come at the expense of some game speed.

Section - Knowledge Subjects

A new kind called "knowledge subject" is provided for more abstract objects such as criminal behavior, ancient history, quantum mechanics, and so on.

Unlike all other things in the game world, knowledge subjects are considered familiar by default.

Part - Testing World Knowledge

Finally, the testing command KSTATE (not for release) is provided to aid the testing and debugging of games using this extension. For example the command KSTATE <NOUN> will show whether the noun is seen, familiar or known. This may be useful to help track whether the knowledge state of various objects in your story is actually what you think it should be.

The KSTATE check can also be done for knowledge subjects, suppositions, and facts.

Example: * Becoming Aware - Demonstrates how knowledge is gained by scope awareness of objects

	*: "Become Aware"
	
	Include World Knowledge by Jeff Nyman.
	
	The Laboratory is a room.

	A rosewood bench is a supporter in the Laboratory.

	An iron crucible is an open container on the rosewood bench.

	A cupboard is a closed openable container in the Laboratory.

	A wicker basket is an open container in the cupboard.

	A silver key is in the wicker basket.

	A Chinese puzzle box is a thing.

	The player is carrying a note.

	Instead of examining the note:
		say "It says: 'Silver Key in Basket'.";
		now the silver key is familiar.
	
	After searching the cupboard for the second time:
		now the Chinese puzzle box is in the cupboard;
		familiarize the Chinese puzzle box;
		say "Digging deeper, you find a Chinese puzzle box."

	Test me with "kstate note / kstate silver key / examine note / kstate silver key / kstate bench / kstate crucible / kstate cupboard / kstate basket / open cupboard / kstate basket / examine basket / kstate basket / search cupboard / kstate Chinese puzzle box / search cupboard / kstate Chinese puzzle box".

Example: * Supposing and Establishing - Demonstrates suppositions and facts.

	*: "Become Aware"
	
	Include World Knowledge by Jeff Nyman.

	Need for infinity stone is a knowledge subject.

	Key exists for puzzle box is a supposition.

	Time stone in box is a fact.

	The Laboratory is a room.
	
	A rosewood bench is a supporter in the Laboratory.

	An iron crucible is an open container on the rosewood bench.

	A cupboard is a closed openable container in the Laboratory.

	A wicker basket is an open container in the cupboard.

	A silver key is in the wicker basket.
	The matching key of the Chinese puzzle box is the silver key.

	A Chinese puzzle box is a locked lockable closed openable portable container.

	An infinity stone is a portable thing in the puzzle box.

	The player is carrying a note.
	
	Before opening the Chinese puzzle box when the Chinese puzzle box is locked:
		now the player is aware of key exists for puzzle box;
		familiarize key exists for puzzle box.

	Instead of examining the note:
		say "It says: 'Silver Key in Basket'.";
		now the silver key is familiar.
	
	After searching the cupboard for the second time:
		now the Chinese puzzle box is in the cupboard;
		familiarize the Chinese puzzle box;
		say "Digging deeper, you find a Chinese puzzle box."

	After opening the Chinese puzzle box:
		if the infinity stone is seen:
			now the player establishes time stone in box.
			
