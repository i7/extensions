Version 2.0 of World Knowledge by Jeff Nyman begins here.

"Mechanics to represent what the player character knows about the world: what they have seen, what they know of, and what they believe."

"based partly on Epistemology by Eric Eve and Optimized Epistemology by Andrew Plotkin"

[Each word means one thing, and the meanings are independent:
	seen: the player character has perceived it.
	examined: the player character has looked at it closely.
	familiar: the player character knows of it, however that came about.
	known: seen or familiar.
Perceiving something does not make it familiar, and learning of something does
not make it seen, so all four combinations of seen and familiar can occur.]

Part - Perception (for use without Epistemology by Eric Eve)

A thing can be seen or unseen. A thing is usually unseen.
A thing can be examined or unexamined. A thing is usually unexamined.

[Everything the player character can see right now becomes seen. "Can see" is
Inform's own test of scope, so it includes things placed in scope with the
deciding the scope activity.]
To mark everything in view as seen:
	repeat with T running through things:
		if the player can see T, now T is seen.

Carry out looking (this is the mark things in view as seen rule):
	mark everything in view as seen.

Carry out an actor opening a container (this is the mark things in view as seen on opening rule):
	if the actor is the player, mark everything in view as seen.
The mark things in view as seen on opening rule is listed after the standard opening rule in the carry out opening rules.

[Examining is recorded as soon as it is clear the player character can see the
thing, before any instead or check rules, so a story that handles EXAMINE with
an instead rule still has its things marked examined.]
This is the mark examined things rule:
	if the actor is the player and the action name part of the current action is the examining action:
		now the noun is seen;
		now the noun is examined.
The mark examined things rule is listed after the basic visibility rule in the action-processing rules.

Part - Familiarity (for use without Epistemology by Eric Eve)

A thing can be familiar or unfamiliar. A thing is usually unfamiliar.

[Kept for stories written for version 1. It now only makes a thing familiar.]
To familiarize (T - a thing):
	now T is familiar.

Part - Knowledge

Definition: a thing is known rather than unknown if it is seen or it is familiar.

Section - Subjects

[Abstract matters the player character knows of, such as quantum mechanics or a
family feud. They have no presence in the world, so they are familiar but never
seen.]
A knowledge subject is a kind of thing. A knowledge subject is usually familiar.
The specification of a knowledge subject is "Represents a concept, entity or idea that has no real-world presence or functionality."

Section - Propositions

[A proposition is a claim about the world: "the key is in the basket". Each
person holds it at one of three levels: unaware of it, supposing it (an
uncertain belief), or having established it (known to be true). Version 1 had
suppositions and facts as separate kinds with separate relations; here a single
proposition moves along one scale, so it can begin as a supposition and become
established.]
A proposition is a kind of thing.
The specification of a proposition is "Represents a claim about the world, which a person may be unaware of, suppose, or have established."

A belief is a kind of value. The beliefs are unawareness, supposition and certainty.

Supposing relates various people to various propositions. The verb to suppose means the supposing relation.
Establishing relates various people to various propositions. The verb to establish means the establishing relation.

To decide which belief is the belief of (P - a person) about (X - a proposition):
	if P establishes X, decide on certainty;
	if P supposes X, decide on supposition;
	decide on unawareness.

[Establishing is the higher level: someone who has established a claim no
longer merely supposes it, and leading them to suppose it again changes
nothing.]
To lead (P - a person) to suppose (X - a proposition):
	if P does not establish X, now P supposes X.

To have (P - a person) establish (X - a proposition):
	now P does not suppose X;
	now P establishes X.

To have (P - a person) forget (X - a proposition):
	now P does not suppose X;
	now P does not establish X.

Definition: a proposition is established rather than unestablished if the player establishes it.
Definition: a proposition is supposed if the player supposes it.

Part - Testing - not for release

Requesting knowledge status of is an action out of world applying to one visible thing.
Understand "kstate [any thing]" as requesting knowledge status of.

Report requesting knowledge status of (this is the report knowledge status rule):
	say "[noun]";
	if the noun is a knowledge subject, say "  (SUBJECT)";
	if the noun is a proposition, say "  (PROPOSITION)";
	say "[line break][if the noun is seen]seen[otherwise]unseen[end if] / [if the noun is examined]examined[otherwise]unexamined[end if] / [if the noun is familiar]familiar[otherwise]unfamiliar[end if] / [if the noun is known]known[otherwise]unknown[end if]";
	if the noun is a proposition:
		let X be the noun;
		say " / the player: [belief of the player about X]";
	say "." (A).

World Knowledge ends here.

---- DOCUMENTATION ----

This extension keeps track of what the player character knows about the world. It is partly based on "Epistemology" by Eric Eve, with Andrew Plotkin's optimizations in mind. Epistemology, the study of how we know what we know, is a grand name for something modest: the aim here is to model the basics of how a character comes to know things, by seeing them, by learning of them, and by coming to believe claims about them.

Note that it is the player character's knowledge that is tracked, not the player's. The two can differ: a player who has played before may know where the key is, while the character has never seen it. This extension models the character.

Section: The four words

Every thing in the story has four properties:

(1) seen or unseen: the player character has perceived it.

(2) examined or unexamined: the player character has looked at it closely.

(3) familiar or unfamiliar: the player character knows of it, however that came about: told about it, read about it, or already knew.

(4) known or unknown: seen or familiar. This one is worked out from the others and can't be set directly.

Each word means one thing, and seen and familiar are independent of each other. That gives four combinations, all of which can happen:

	seen and familiar: a thing the character has both seen and knows about.
	seen but unfamiliar: a thing the character has noticed but knows nothing about.
	familiar but unseen: a thing the character has only heard of, like a key mentioned in a note.
	unseen and unfamiliar: a thing the character doesn't know exists.

Everything starts unseen, unexamined and unfamiliar, and so unknown, except knowledge subjects (below), which start familiar. You can change any of these for individual things or kinds.

Section: How things become seen

The extension marks things seen when the player character:

(1) LOOKs. This includes arriving in a room, which looks automatically. Everything the player can see becomes seen, including things placed in scope with the "deciding the scope of" activity.

(2) Opens a container. Everything then in view becomes seen, not just the container's contents.

(3) Examines something. It becomes seen and examined. This is recorded as soon as Inform has checked that the thing can be seen, before any instead or check rules run, so it still works if your story handles EXAMINE with an instead rule (most stories do). It isn't recorded if the examining fails because the thing can't be seen, for instance in the dark.

A thing moved into the room during play is not seen until the next LOOK or EXAMINE. If you need things noticed as soon as they appear, you can add:

	Every turn: mark everything in view as seen.

This checks every thing in the story each turn, which may slow a very large story.

Section: How things become familiar

Nothing becomes familiar automatically: seeing a thing doesn't mean knowing about it. Make things familiar when the character learns of them:

	now the silver key is familiar.

The phrase "familiarize (thing)" does the same, and is kept for stories written for version 1.

Section: Knowledge subjects

A knowledge subject is a thing that stands for a concept, entity or idea with no presence in the world, such as criminal behaviour, ancient history or quantum mechanics. Knowledge subjects are familiar by default, and since they are never in view they are never seen.

Section: Propositions and belief

A proposition is a claim about the world, such as "the key is in the basket". Name it as a single word or hyphenated phrase and give it a printed name, since a sentence like "The key is in the basket is a proposition" would read as an assertion:

	Key-in-basket is a proposition. The printed name is "the key is in the basket".

Each person holds each proposition at one of three levels of belief:

	unawareness: they haven't considered it.
	supposition: they believe it, but aren't sure (they suppose it).
	certainty: they know it to be true (they have established it).

Use these phrases to move along the scale:

	lead the player to suppose key-in-basket;
	have the player establish key-in-basket;
	have the player forget key-in-basket;

Establishing is the higher level. Someone who establishes a claim no longer merely supposes it, and leading them to suppose something they have already established changes nothing.

You can test belief directly:

	if the player supposes key-in-basket ...
	if the player establishes key-in-basket ...
	if the belief of the player about key-in-basket is supposition ...

For the player, the adjectives "established" and "supposed" are shortcuts:

	if key-in-basket is established ...

Belief is held per person, so other characters can believe things too. The seen, examined and familiar properties are about the player character only.

Note that familiarity and belief are separate. A proposition can be familiar (the character has heard the claim) while the character is unaware of it in the sense of not believing it, or vice versa; use whichever your story needs.

Section: Changes from version 1

(1) LOOK and opening a container now mark things seen only. In version 1 they also made everything in view familiar, which meant a thing could never be seen without being familiar, and "known" always equalled "familiar".

(2) "familiarize (thing)" now makes a thing familiar only. In version 1 it also made it seen, so an abstract thing that was familiarized became "seen".

(3) Examining is recorded even when an instead rule handles the action. In version 1 it was recorded in an after rule, which instead rules skip.

(4) Suppositions and facts are replaced by propositions with one scale of belief. Replace "the player is aware of S" with "the player supposes S", and "the player establishes F" stays as it was. "Unconfirmed" and "confirmed" are now "unestablished" and "established".

(5) The phrase "mark-everything-in-scope-as-seen" is now "mark everything in view as seen".

Section: Testing

The testing command KSTATE (not for release) shows the state of a thing: for example, KSTATE SILVER KEY. For propositions, it also shows the player's belief.

Example: * Becoming Aware - The four combinations of seen and familiar, and examining with an instead rule.

	*: "Becoming Aware"

	Include World Knowledge by Jeff Nyman.

	The Laboratory is a room.

	A rosewood bench is a supporter in the Laboratory.

	A cupboard is a closed openable container in the Laboratory.

	A wicker basket is an open container in the cupboard.

	A silver key is in the wicker basket.

	A brass lamp is a thing.

	The player is carrying a note.

	Instead of examining the note:
		say "It says: 'Silver Key in Basket'.";
		now the silver key is familiar.

	Every turn when the turn count is 2:
		now the brass lamp is in the Laboratory;
		say "Someone sets down a brass lamp."

	Test me with "kstate bench / kstate silver key / examine note / kstate note / kstate silver key / open cupboard / kstate basket / kstate silver key / kstate lamp / look / kstate lamp".

The bench is seen but unfamiliar: the character has noticed it and knows nothing more. Reading the note makes the silver key familiar while it is still unseen. Opening the cupboard makes the key seen too. The lamp is unseen and unfamiliar until the LOOK after it arrives. And the note is examined even though an instead rule handles examining it.

Example: * Supposing and Establishing - A belief that becomes certain.

	*: "Supposing and Establishing"

	Include World Knowledge by Jeff Nyman.

	Key-opens-box is a proposition. The printed name is "a key opens the puzzle box".

	Stone-in-box is a proposition. The printed name is "the stone is in the box".

	The Laboratory is a room.

	A cupboard is a closed openable container in the Laboratory.

	A silver key is in the cupboard.

	A Chinese puzzle box is a locked lockable closed openable portable container in the Laboratory.

	The matching key of the Chinese puzzle box is the silver key.

	An infinity stone is a portable thing in the puzzle box.

	Before opening the Chinese puzzle box when the Chinese puzzle box is locked:
		lead the player to suppose key-opens-box.

	After unlocking the Chinese puzzle box with the silver key:
		have the player establish key-opens-box;
		continue the action.

	After examining the infinity stone:
		have the player establish stone-in-box;
		continue the action.

	Test me with "kstate key-opens-box / open box / kstate key-opens-box / open cupboard / take key / unlock box with key / kstate key-opens-box / open box / examine stone / kstate stone-in-box".

Trying the locked box leads the player to suppose a key opens it; unlocking it with the silver key establishes it. Examining the stone establishes that it is in the box.
