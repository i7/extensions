Version 1.0 of Modify Viewpoint and Tense by Jeff Nyman begins here.

"Commands for switching the story's narrative viewpoint and tense while testing adaptive text (FIRST PERSON, PAST TENSE, VIEWTENSE...), and [singular] and [plural] for making verbs agree with things other than the subject."

Part - Making Verbs Agree

[Adaptive verbs ("[are]", "[face]") agree with whatever was last named, usually
"[we]" or an object. For a sentence whose subject is just words in the text,
these say which: "the statue [singular][face] east", "the paths [plural][curve]".]

To say singular:
	say regarding 1.

To say plural:
	say regarding 2.

Part - The Commands

Chapter - When they work

[The commands are understood only while this is true: always in a testing build
(see the section for testing below), and in a release only with the use option.]
The narration commands enabled is a truth state that varies.

Use narration commands in release translates as (- Constant MVT_NARRATION_IN_RELEASE; -).

When play begins (this is the allow narration commands in a release rule):
	if the narration commands in release option is active, now the narration commands enabled is true.

Section - Testing builds (not for release)

When play begins (this is the allow narration commands while testing rule):
	now the narration commands enabled is true.

Chapter - Viewpoint

Changing the narrative viewpoint to is an action out of world applying to one narrative viewpoint.
Understand "[narrative viewpoint]" as changing the narrative viewpoint to when the narration commands enabled is true.

[A short form mustn't be read before a longer name it begins (FIRST PERSON before
FIRST PERSON PLURAL), so each value lists its longest names first.]
Understand "first person singular" or "first person" or "fp" as first person singular.
Understand "first person plural" or "fpp" as first person plural.
Understand "second person singular" or "second person" or "sp" as second person singular.
Understand "second person plural" or "spp" as second person plural.
Understand "third person singular" or "third person" or "tp" as third person singular.
Understand "third person plural" or "tpp" as third person plural.

Carry out changing the narrative viewpoint to (this is the change the narrative viewpoint rule):
	now the story viewpoint is the narrative viewpoint understood.

Report changing the narrative viewpoint to (this is the report the narration rule):
	say "[narration example]".

Chapter - Tense

Changing the grammatical tense to is an action out of world applying to one grammatical tense.
Understand "[grammatical tense]" as changing the grammatical tense to when the narration commands enabled is true.

Understand "past perfect tense" or "past perfect" or "ppt" as past perfect tense.
Understand "past tense" or "past" or "pst" as past tense.
Understand "present tense" or "prt" as present tense.

[Inform already has a verb PRESENT (PRESENT something TO someone), and a command
that begins with it is only matched against that verb's grammar, so neither
PRESENT nor PRESENT TENSE reaches the line above. PRESENT TENSE is given to the
verb as a line of its own instead; plain PRESENT is left to mean giving.]
Changing to the present tense is an action out of world.
Understand "present tense" as changing to the present tense when the narration commands enabled is true.
Carry out changing to the present tense (this is the change to the present tense rule):
	try changing the grammatical tense to present tense.
Understand "perfect tense" or "perfect" or "pft" as perfect tense.
Understand "future tense" or "future" or "frt" as future tense.

Carry out changing the grammatical tense to (this is the change the grammatical tense rule):
	now the story tense is the grammatical tense understood.

Report changing the grammatical tense to (this is the report the new tense rule):
	say "[narration example]".

Chapter - Reporting

Reporting the narration is an action out of world.
Understand "viewtense" or "narration" as reporting the narration when the narration commands enabled is true.

Carry out reporting the narration (this is the report the current narration rule):
	say "[narration example]".

[The current viewpoint and tense, and a sentence written in them.]
To say narration example:
	say "[bracket][story viewpoint], [story tense]: [regarding the player][We] [are] in [the location].[close bracket][line break]".

Modify Viewpoint and Tense ends here.

---- DOCUMENTATION ----

Inform can tell a story in any of six viewpoints (first, second or third person, singular or plural) and five tenses (present, past, perfect, past perfect and future), and its adaptive text follows them: "[We] [are]" can become "I am", "they were" or "you will be". This extension adds commands to switch the viewpoint and tense while playing, so you can see how your text reads in each, and two substitutions, "[singular]" and "[plural]", that help verbs agree.

Changing the viewpoint or tense only changes text written to adapt: Inform's own messages, and your text where it uses substitutions such as "[We]" and "[are]". Fixed text stays as it is.

Section: The commands

The viewpoints, each by its full name or a shorter form:

	FIRST PERSON SINGULAR (or FIRST PERSON, FP)
	FIRST PERSON PLURAL (or FPP)
	SECOND PERSON SINGULAR (or SECOND PERSON, SP)
	SECOND PERSON PLURAL (or SPP)
	THIRD PERSON SINGULAR (or THIRD PERSON, TP)
	THIRD PERSON PLURAL (or TPP)

The tenses:

	PRESENT TENSE (or PRT; plain PRESENT already means giving something)
	PAST TENSE (or PAST, PST)
	PERFECT TENSE (or PERFECT, PFT)
	PAST PERFECT TENSE (or PAST PERFECT, PPT)
	FUTURE TENSE (or FUTURE, FRT)

Each change answers in the new voice, so it shows itself:

	[first person plural, past tense: We were in the Hall.]

VIEWTENSE (or NARRATION) says the same about the current viewpoint and tense. None of these take any time.

Third person singular uses the player's own gender, so "[We]" becomes "he" for Inform's default player; for "she", "it" or a name, change the player.

Section: Testing, or in release

The commands are for testing: they work while you test your story, but not in a released story, where they simply aren't understood. For a story in which switching the narration is part of what the player does, allow them in release too:

	Use narration commands in release.

Section: Making verbs agree

An adaptive verb agrees with whatever was named last: "[We] [are]" agrees with the player, "[The noun] [are]" with the noun. When the subject is just words in your text, like "the statue" or "the paths", say which kind of subject it is, singular or plural, just before the verb:

	"The statue [singular][face] east, and the paths [plural][curve] away."

They're short for Inform's "[regarding 1]" and "[regarding 2]".

A verb used this way must be declared as a verb first, unless Inform already knows it ("[are]", "[have]" and other common verbs are built in):

	To face is a verb. To curve is a verb.

Section: Changes from version 1

(1) The commands are for testing: in a released story they work only with "Use narration commands in release".

(2) The perfect and past perfect tenses can be chosen too (PERFECT, PAST PERFECT).

(3) Every change answers in the new viewpoint and tense; in version 1 the commands printed nothing. VIEWTENSE says the same.

(4) Two actions, "changing the narrative viewpoint to" and "changing the grammatical tense to", take the place of eleven; all the version 1 commands still work, and PAST, FUTURE, PERFECT, PAST PERFECT, NARRATION are new.

(5) The documentation's example declares its verbs, without which it didn't compile.

Example: * A Walk in Five Tenses - Seeing a description and Inform's own messages change.

	*: "A Walk in Five Tenses"

	Include Modify Viewpoint and Tense by Jeff Nyman.

	To face is a verb. To sparkle is a verb. To curve is a verb. To stand is a verb.

	Palace Gate is a room. "The gates of the park [singular][stand] open to the north."
	Broad Walk is north of Palace Gate. "A brooding statue of Queen Victoria [singular][face] east, where the waters of the Round Pond [plural][sparkle] in the afternoon sun. [It's] possible to follow the crowded Broad Walk north and south until its borders [plural][are] lost amid the bustle of perambulators. Small paths [plural][curve] northeast and southeast between the trees."

	A guidebook is in Palace Gate.

	Test me with "take guidebook / n / past / look / future / look / perfect / look / past perfect / look / present tense / first person / i / third person plural / i / viewtense".

The Broad Walk's description changes with every tense: "faced", "will face", "has faced", "had faced". TAKE GUIDEBOOK and INVENTORY show Inform's own messages following the viewpoint too.
