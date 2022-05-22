Version 8.2 of Extended Grammar by Aaron Reed begins here.

"Adds some of the most commonly attempted verb synonyms and alternate grammar lines. Based on the Inform 6 extension ExpertGrammar.h by Emily Short."

[Changelog:
  -- V8: Updated to newest build.
  -- V7: Removed swear words in anticipation of I7 doing so soon also.
  -- V6: Added "put x on ground" and variants as synonym for drop.
  -- Version 5: Added useful section breaks; Added a few more things from intfiction.org newbie threads.
  -- Version 4: Absorbed a few prepositionless alternatives formerly in Small Kindnesses.
  -- Version 3: Added some new vocabulary as a result of newbie Sand-dancer transcripts.
  -- Version 2: Clarified climbing something enterable versus something not enterable; added a few new preposition forms to some commands.
]

[Concerns: Should "lift" be pull or take? Has been seen used in both cases. Also "raise."]

Section - Extended Grammar for Attack

Understand the command "injure" or "kick" or "strike" or "smack" as "attack".

Understand "break in/into/down/through [something]" as attacking.
Understand "break [something] in/down" as attacking.

Section - Extended Grammar for Burn

Understand the command "melt" or "ignite" or "incinerate" or "kindle" or "bake" or "toast" as "burn".

Section - Extended Grammar for Cut

Understand the command "carve" as "cut".

Section - Extended Grammar for Climb

Understand "climb on/in/into/onto [something]" as climbing.

Understand "throw [something preferably held] away" as dropping.
Understand "throw away [something preferably held]" as dropping.

Section - Extended Grammar for Drop

Understand the command "toss" or "fling" or "hurl" as "drop".

Understand "put [something preferably held] on floor/ground" as dropping.

Section - Extended Grammar for Examine

Understand the command "view" or "observe" or "inspect" as "examine".

Section - Extended Grammar for Enter

Understand the command "board" as "enter".
Understand "climb on/onto/in/into [something enterable]" as entering.
Understand "exit through/using/by/out/-- [a door]" as entering.
Understand "sit [something]" as entering. [Note: This breaks I7 [recap of command] / I6 PrintCommand, which expects the player has typed a grammatical command. Thus we might get messages like "What do you want to sit?"]
Understand "sit down on/in [something]" as entering.
Understand "jump on/in/into/onto [something]" as entering.
Understand "sit down" as entering.

Section - Extended Grammar for Exit

Understand the command "escape" or "depart" as "exit".

Section - Extended Grammar for Give

Understand the command "hand" or "deliver" as "give".

Section - Extended Grammar for Go

Understand the command "proceed" or "wander" or "explore" as "go".
Understand "upstairs/ascend" as up.
Understand "downstairs/descend" as down. 

Understand "go to [direction]" as going.
Understand "climb [a direction]" as going.

Section - Extended Grammar for Listen

Understand "listen [something]" as listening to.

Section - Extended Grammar for Look

Understand the command "see" as "look".
Understand "look around/about" as looking.

Section - Extended Grammar for Pull

Understand the command "raise" or "lift" as "pull".

Section - Extended Grammar for Push

Understand the command "lower" as "push".

Section - Extended Grammar for Put

Understand the command "place" or "stick" or "shove" or "stuff" as "put".

Section - Extended Grammar for Switch

Understand the command "activate" or "start" as "switch".
Understand the command "deactivate" or "stop" as "switch".

Section - Extended Grammar for Take

Understand the command "steal" or "grab" or "acquire" or "snatch" or "bring" as "take".

Section - Extended Grammar for Turn

Understand the command "spin" as "turn".

Section - Extended Grammar for Saying Yes

Understand "okay" or "ok" as saying yes.

Section - Extended Grammar for Throw

Understand "throw [something preferably held] into/through/to [something]" as throwing it at.

Extended Grammar ends here.

---- DOCUMENTATION ----

Including this extension adds about sixty new verbs to a story's vocabulary, including words like GRAB, INSPECT, DESCEND, and KICK. Note that no new actions are created: these are all simply synonyms for existing commands.

A few new command forms are also understood as well: for instance, CLIMB UP is understood as going, CLIMB INTO THE CHAIR as entering, and CLIMB ON WALL as climbing, all three of which are normally unrecognized.

The functionality is similar to that provided by the old Inform 6 extension ExpertGrammar.h by Emily Short, minus some of the features since incorporated by default into Inform's grammar, and plus a few words and command forms I observed new IF players try to use during the testing of various projects. Emily's comments in the original extension note that many of these words are either standard in other IF languages, or were observed in the command logs of an online version of Zork.

Example: * Look Around You -

	*: "Give My Creation Life"

	Include Extended Grammar by Aaron Reed.

	The Laboratory is above the Operating Room. A slab is an enterable supporter in the Operating Room. A man called the Creature is on the slab. The player carries a raw steak. The oscillitron is a device in Operating Room. Instead of attacking the creature, say "It's alive!"

	Test me with "descend / look around / observe the creature / activate oscillitron / sit down on the slab / hand steak to Creature / place steak on slab / kick Creature / upstairs"  



