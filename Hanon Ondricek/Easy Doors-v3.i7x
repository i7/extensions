Version 3.2 of Easy Doors by Hanon Ondricek begins here.

"Easy Doors provides a new kind of door which does not use map connections, and may be manipulated via rules more flexibly than the standard doors provided in Inform 7.  Version 3 removes elements for compatibility with 6M62"

[Removed the I6 "perform" dropin as it no longer consistently functions properly under 6M62]

An easydoor is a kind of thing.
An easydoor is usually fixed in place.
An easydoor can be enterable.  An easydoor is usually enterable.
An easydoor can be scenery.
An easydoor can be openable or unopenable. An easydoor can be open or closed.  An easydoor is usually openable.
An easydoor can be lockable.  An easydoor can be locked or unlocked.

An easydoor has a text called dooraction.  The dooraction of an easydoor is usually "".

The description of an easydoor is usually "[The noun] [are] [if open]open[otherwise]closed[end if]."

Understand "[easydoor]" as entering.

Roomconnecting relates one room (called the outpoint) to various things.

The verb to lead to implies the reversed roomconnecting relation.

Portalling relates one easydoor (called the doorfriend) to another.

The verb to portal implies the portalling relation.

Understand "door/doorway" as an easydoor.

Before an actor entering an easydoor (called D) (this is the implicitly open easydoors rule):
	if D is closed:
		try the person asked opening D.
	
Check an actor entering an easydoor (this is the can't enter a locked easydoor rule):
	if the noun is locked:
		stop the action.
	
After entering an easydoor (this is the say dooraction and move the player rule):
	if dooraction of noun is "":
		say "[dooraction of noun][run paragraph on]" (A);
	otherwise:
		say "[dooraction of the noun][line break]" (B);
	now the player is in the outpoint of the noun.
	
After someone entering an easydoor (called D) (this is the NPC uses easydoor rule):
	say "[The person asked] [go] through [the D]." (A);
	now the person asked is in the outpoint of the noun.
	
Check an actor entering a portable easydoor (called D) (this is the we are not MC Escher rule):
	if the the person asked carries D:
		say "[The person asked] [can't] enter [the D] while holding it." (A);
		stop the action.
	
Check entering an easydoor (this is the disallow entering easydoors with no outpoint rule):
	if the outpoint of the noun is nothing:
		if the dooraction of the noun is "":
			say "[The noun] [don't] lead anywhere." (A);
		otherwise:
			say "[dooraction of the noun][line break]" (B);
		stop the action.
		
Check someone entering an easydoor (this is the disallow npc entering easydoors with no outpoint rule):
	if the outpoint of the noun is nothing:
		say "[The noun] [don't] seem to lead anywhere." (A);
		stop the action.
	
Carry out an actor opening an easydoor (called D) (this is the open doorfriend rule):
	now the doorfriend of D is open.
	
Carry out an actor closing an easydoor (called D) (this is the close doorfriend rule):
	now the doorfriend of D is closed.
	
Carry out an actor unlocking an easydoor (called D) with something (this is the unlock doorfriend rule):
	now the doorfriend of D is unlocked.
	
Carry out an actor locking an easydoor (called D) with something (this is the lock doorfriend rule):
	now the doorfriend of D is locked.
	
Before an actor unlocking an easydoor with something (called K):
	If K unlocks the doorfriend of the noun:
		now K unlocks the noun.  
		
Before an actor locking an easydoor with something (called K):
	If K unlocks the doorfriend of the noun:
		now K unlocks the noun. 
	
Volume 1 - Not for release

When play begins:
	repeat with D running through easydoors:
		if D leads to nothing:
			say "*** CAUTION - [bold type][The D][roman type] in [bold type][the location of D][roman type] does not lead anywhere!!! ***[paragraph break]"
	
	

Easy Doors ends here.

---- DOCUMENTATION ----

Chapter : Introduction

Doors as implemented in Inform 7 are limited and sometimes frustrating to use since they must connect two rooms using map directions.  They can thwart some architectural and magical realism: they cannot be moved during play, and they cannot change their destination.  We cannot have an enterable broom closet on the same wall as a map direction.  Doors cannot be part of an object, or inside an enterable container.  

Easy Doors is a small extension that provides a new kind called "easydoor". These behave like normal doors and can be placed anywhere, providing one-way, directionless transport to any location in the game world.  Easydoors can be moved around the map, on and off-stage, and can change what location they lead to at the author's whim using normal rules.  Since easydoors do not require directional hookups on the map, they are very simple to implement. 

Section : Update Log

2016.04-25 - Removed "perform" functionality as it no longer operates consistently in 6M62 and using it with certain actions cause a compiler error with no specific indication what caused the error.  Functionality can be duplicated using the "carry out" phase of entering an easydoor as explained below.

Section : Acknowledgements

Thanks to Carolyn VanEseltine and Jason Lautzenheimer for suggestions about door behaviors.  Also to Daniel Stelzer and Andrew Schultz for assistance and advice and testing.

Please feel free to email hanon.ondricek@gmail.com with any feedback, questions, or bug reports.

Chapter : Creating Easydoors

Easydoors can be created and placed wherever we want.  They behave in the expected way a door would, by default fixed in place, openable and closed.  We can declare them also lockable and locked or unlocked (unlocked is default) and create keys to unlock them.  We can make them open and unopenable to simulate stairs or an open passage.  We also specify where an easydoor leads to when a player enters one.

Section : One-Way Easydoors

	The front door is an easydoor in Porch.  It leads to Foyer.
	
This is the minimum code for a working easydoor.  We can of course give our easydoor an initial appearance, a description (the default just says whether the door is closed or open) and use all of the normal rules for opening and closing and locking.  (The exception to be careful with is AFTER ENTERING - see the section later for details.)

	An iron grating is an easydoor in Dungeon Mouth.  It leads to Dungeon Throat.  It is lockable and locked.
	The dungeon key unlocks iron grating.  Dungeon key is carried by the fearsome ogre.
	
	A windy passage is an easydoor in Dungeon Throat.  "A windy passage leads deeper into the dungeon."  It is unopenable and open.  It leads to Dungeon Lungs.
	
Notice none of these specify compass directions.  We can place as many doors in a location as we wish.  The player can enter an easydoor and be transported to the location it leads to by using any synonym of the entering action, or by typing the name of an easydoor as if it were a direction.

	>ENTER FRONT DOOR
	>GRATING
	>GO THROUGH WINDY PASSAGE
	
If the easydoor is closed and not locked, the parser will open it implicitly.  If it is locked, the player will be informed and not allowed to open it until they find a key. 
	
We can simulate that an easydoor leads in a direction by redirecting the player's input to the entering action.

	A revolving door is an easydoor in Plaza.  "The department store's revolving door slices and dices holiday shoppers to the north."  It is unopenable and open.  It leads to Women's Shoes.  The description of revolving door is "It makes you sort of ill to watch it for too long."
	
	Instead of going north in Plaza: try entering revolving door.
	
Section : Two-Way Doors

Since easydoors traverse only one way, we might wish to provide the other half of the door so there is a two-way connection.

	some automatic doors are an easydoor in Women's Shoes.  "You note some automatic doors to the south that lead back out into the street."  It leads to Plaza.  The dooraction is "At least you don't have to contend with the revolving door this time as glass panels are whisked aside automatically for you."
	
	Instead of going south in Women's Shoes:
		try entering automatic doors.
		
Section : Portalling Two Easydoors as One

When we are simulating both sides of a door with two separate easydoors, we would like them to stay in sync with regard to locking,  unlocking, opening and closing.  We do that by connecting them with the portalling relation, which is reciprocal and only needs to be declared on one of the matching portals.

	The coaster security gate is an easydoor in Midway.  It is lockable and locked.  It leads to Roller Coaster.  The description is "Through the chain link, you can see the wooden supports of the roller coaster."  Understand "chain/link" as security gate.
	
	The gate back to the midway is an easydoor in Roller Coaster.  "A gate here appears to lead back to the midway."  The description is "It's the back side of that security gate you saw earlier."  It leads to midway.  It portals coaster security gate.  Understand "security" as gate back to midway.
	The passkey unlocks coaster security gate.  Passkey is on security guard's corpse.
	
This will ensure that if we unlock the security gate from one side but slip into the Roller Coaster grounds by other means, when we encounter the allegedly same gate from the other side that it will also be unlocked.  It also allows the same key to lock and unlock the other half of the portalled door.

Section : Dooraction

Every easydoor contains a text called "dooraction" which can optionally be used to provide some descriptive text when the player moves through the door.  

	a spiral staircase is an open, unopenable easydoor in Minimalistic Apartment. It leads to Loft.  the dooraction of spiral staircase is "Your knees complain as you climb the wrought iron twists of this contraption."

	a time machine is an open, unopenable easydoor in Laboratory. "A humming time machine sits in the corner, the passage into it glowing expectantly."  It leads to Swirly Void.  The dooraction of time machine is "All right.  Here goes."
		
The dooraction should encompass the actual traversal of the door.  The opening and closing are separate actions and shouldn't necessarily be included in the dooraction.

	a crypt door is an openable easydoor in Graveyard.  It leads to Inner Tomb.  The dooraction is "As you cross the threshold, a cold wind ruffles your hair.".
	
	After an actor opening crypt door, say "The door of the crypt creaks open."  
	After an actor closing crypt door, say "The crypt door bangs shut."
	
Section:  After Entering an Easydoor

In most cases, we should not override the AFTER ENTERING rules affecting an easydoor, as this is where the player is moved to the location that the door leads to (called an "outpoint" in code).  Should you need to do anything fancy when an easydoor is traversed, The best place to work it out is in the carry out phase of entering.

	A revolving door is an easydoor in Plaza.  "The department store's revolving door slices and dices holiday shoppers to the north."  It is unopenable and open.  It leads to Women's Shoes.  The description of revolving door is "It makes you sort of ill to watch it for too long."  The dooraction of revolving door is "You are whirled for several minutes[if the player encloses a mitten], losing a mitten in the process[end if].  Finally you are through and your shopping can begin!"
	
	Carry out entering revolving door:
		if the player encloses a mitten:
			now a random mitten enclosed by the player is off-stage.
	
If you decide you need to use the after rules, you should ensure that you move the player to the outpoint of the easydoor as well.

Easy Doors usually lead to a room.  Altering the AFTER ENTERING rules would be one way to, for whatever reason, have a door lead to the inside of an enterable container or onto a supporter.  Take care with this, as getting your player stuck inside an object or in a backdrop might have strange consequences.  An example is provided below.

Section : Portable Doors

Easydoors are usually immobile as far as the player is concerned, although the author can move them as part of gameplay using rules.  An easydoor can be declared portable, leading to wild effects.

	A round black hole is an easydoor carried by the player.  It is portable.  It leads to Phobos.  
	
A portable door must be dropped before it can be entered, of course, because carrying a door through itself would break even imaginary laws of physics and cause your game to collapse into itself and wink out of existence.

	Carry out turning the Infinite Improbability dial:
		now round black hole leads to Magrathea.

Chapter : Debug

An easydoor without a destination (in code, an "outpoint") would transport the player off-stage, which could cause all kinds of nasty effects.  When a game is run in the Inform IDE, easydoors without outpoints will be flagged when play begins.

We may have good reason to have a destination-less door (as shown in the example below) and can ignore these warnings which will not appear in a published game.  This is provided to notify the author in case of inadvertently forgetting to include a destination for an easydoor.  Instead of recklessly transporting the player offstage, the extension will inform the player that the door leads nowhere, and change the outpoint of the easydoor to its own location should the player try again.  

Chapter : NPCs, and Pathfinding

Easy Doors can handle an NPC character manipulating and entering an easydoor if manually told to in rules by the author, or by a player if persuasion succeeds.  Unfortunately Inform's automatic pathfinding ("The best route from A to B") will not take easydoors into account.  Any route to a location will detour around an easydoor if there is another way using regular map connections and doors, or will fail as "nothing" if an easydoor is the only route.  

If our game relies on routefinding and autonomous NPCs, some suggestions are:
	
A: Create the world with map connections and regular doors where we need NPCs to travel, reserving easydoors for special cases. (In TRANSPARENT, there is a map connection between the study and the library that ghosts can use, but the player is directed from the map connection through an easydoor, which might be locked.)

B: Divide the map into regions that easydoors connect, and have Inform find "The best route from A to (an easydoor)."  Once arrived, have the NPC try entering the easydoor and continue their route to a destination. 

C: Find plot reasons to teleport the NPCs.

Hopefully if our game involves traveling NPCs and extended logic to move them, we are skilled enough to manage within the limitations of this extension, or modify it to suit. 

A vague caution:  This extension is designed to help authors solve some door problems, and create special effects.  While it can be used to make an entire game full of non-traditional map traversal, it has not been stress-tested with hundreds of portaling doors in a game.  Some memory limitations and weirdness might be encountered if we are using this extension to write a game called "Maze of a Million Doors". 

Example: ** And I Want to Paint It - Easy Doors in action, hopefully demonstrating the entire range of use, including debug messages.
	
	*: "And I Want to Paint It"

	Include Easy Doors by Hanon Ondricek.

	Hub is a room.
	Room1 is a room.
	Room2 is a room.
	Room3 is a room.
	
	Alice is a woman in Hub.  "Alice is here, looking rather lost."
	
	Before Alice entering an easydoor:
		say "'Aha!' Alice exclaims."
	
	A persuasion rule: persuasion succeeds.

	An easydoor called the first door is an easydoor in Hub.  It leads to room1.

	A green door is a lockable, locked easydoor in Hub.  It leads to room2.

	A blue door is a lockable, locked easydoor in Hub.  It leads to room3.

	The player carries a green key.  Green key unlocks green door.
	
	A blue key is in Room2.  It unlocks blue door.

	An incorrectly-made door is an easydoor in Hub.

	a return door is a kind of easydoor.
	One return door is in room1.  It leads to Hub.  It portals first door.
	One return door is in room2.  It leads to Hub.  It is lockable and locked.  It portals green door.
	One return door is in room3.  It leads to Hub.  It is lockable and locked.  It portals blue door.

	A false door is an easydoor in Hub.

	After opening false door:
	say "Hunh.  This door opens onto a solid brick wall.  You're not going anywhere through this."
	
	Yourself can be injured.

	The dooraction of false door is "Ow.  Bricks meet nose."
	
	Carry out entering false door:
		now the player is injured.
	
	A red herring door is an easydoor in hub.  It is lockable and locked.

	a time machine is an open, unopenable easydoor in Room3. "A humming time machine sits in the corner, the passage into it glowing expectantly."  It leads to Swirly Void.  The dooraction of time machine is "All right.  Here goes."

	Swirly Void is a room.  "How temporally disorienting!".

	A rapidly approaching light is an open, unopenable easydoor in Swirly Void.  The description is "It's approaching fast."  It leads to Drawing Room.  The dooraction of rapidly approaching light is "You fall for a long time, afraid of meeting the ground at rapid pace.  Luckily the next time you blink, you find yourself somewhere else...and there seems to be no way back."

	Drawing Room is a room.  "You've arrived in Victorian London, it seems, from the look of this place."

	The parlour door is an easydoor in Drawing Room.  "The Parlour is west."  It leads to The Parlor.

	Instead of going west in Drawing Room: try entering parlour door.

	The Parlor is a room.  "The Parlour.  How boring.".  The printed name of parlor is "The Parlour"

	The drawing room door is an easydoor in Parlor. "The drawing room door leads back to the east.".  It leads to Drawing Room.  It portals parlour door.

	Instead of going east in parlor: try entering the drawing room door. 

	A magic mushroom is an edible thing in Drawing Room.

	Carry out eating magic mushroom:
		say "The parlour door seems to ripple strangely.";
		now the parlour door leads to Wonderland;
		now the dooraction of parlour door is "As you cross the threshold of the parlour door, there is a liquid ripple and your surroundings melt away, leading you somewhere else...".
	
	Wonderland is a room.  "Oh no.  Not this again.  Your croquet skills are rusty.  You feel like jumping in frustration."

	some very damp clothing is a wearable thing.

	The pool of tears is a fixed in place, enterable, transparent container in wonderland.

	Carry out entering pool of tears:
		now the player wears damp clothing.

	hundreds of gallons of tears is a fixed in place thing in pool of tears.

	Yourself can be wet.

	A whirlpool is an open, unopenable easydoor.  It leads to Hub.  The dooraction is "Down...down...down...whirling...you hold your breath until finally you end up in... Well, foo.  That was all for naught."
	
	Carry out entering whirlpool:
		now the player wears damp clothing.

	Instead of jumping:
		say "You stamp your foot angrily.";
		if the location is Wonderland:
			say "[line break]The rumbling of your frustration seems to have caused a crack in the earth to open up, and the pool of tears begins to circle, draining away.";
			now whirlpool is in pool of tears;
		rule succeeds.
		
	test me with "open green door/alice, open blue door/alice, enter red herring door/enter false door/unlock green door with green key/alice, go through green door/enter green door/alice, take blue key/alice, go return door/return/alice, unlock blue door/alice, open blue door/enter blue door/get in time machine/enter light/take mushroom/w/e/eat mushroom/w/x pool/jump/enter pool/enter whirlpool"

		
Example: **** His Lovely Assistant - Using Easy Doors to transport the player into an enterable container.

	*: "His Lovely Assistant"

	Include Easy Doors by Hanon Ondricek.

	Use scoring.

	The Wicked Stage is a room.  "[one of]Here, elevated on the boards before a sold-out audience, Mumford the Magician has but one astounding trick left to perform.[or]The audience watches raptly, each member perched on the edge of their respective seat.[stopping]"

	a magic trunk is a fixed in place, enterable, openable, closed, lit container in Wicked Stage.  The description is "It's big enough for a person to get into, but exceedingly heavy to carry around as you well know."  Understand "disappearing/box" as trunk.

	a trap door is an easydoor in magic trunk.  It leads to Understage.  It is openable.  The dooraction is "You contort your body through the narrow square trap in the bottom of the trunk and the hole cut underneath it down through the stage floor."

	After opening trap door:
		say "You quietly open the trap door."

	Instead of going down when the player is in magic trunk:
		try entering trap door.

	a concealed panel is an easydoor in Understage.  "Above your head you can see the concealed panel through the trap cut into the stage that the trunk is sitting on top of."   It leads to Wicked Stage.  It portals trap door.  Understand "trap" as concealed panel.

	The printed name of Understage is "Beneath the Stage".

	a scrap of newspaper clipping is in understage.  The description is "Hmn.  It's a slightly-charred newspaper article detailing the rash of stage magician's assistant murders that has been ravaging the community!  This looks like an important clue to the mystery!"
	
	Carry out taking scrap of newspaper for the first time:
		increase the score by 1.

	After closing concealed panel:
		say "You close the panel with the slightly audible 'thunk' that Mumford is listening for."
	
	After entering concealed panel:
		now the player is in magic trunk;
		say "You twist your way flexibly back up through the stage into the trunk."
	
	Instead of going up in understage: try entering concealed panel.

	To say response:
		say "[line break]'[one of]Ooooooooh[or]Ahhhhhh[or]Ooh! Ahh[cycling]!' goes the audience."
	
	To say murmur:
		say "The audience murmurs, perhaps a bit less astounded than they were before."
	
	The audience is scenery in Wicked Stage.  The description is "There are hundreds of people out there, even if you can't make out anyone specifically.  Any one of them could be the Magician's Assistant Murderer!  You hope you catch him soon so you can stop this whole undercover gig for Mumford."

	Pre Magic is a scene.  Pre Magic begins when the turn count is 2.  Pre Magic ends when the player is in magic trunk.

	When Pre Magic Begins:
		say "Mumford holds up his hands, cutting off the applause from the previous trick.  'And now, for our spectacular finale.  I give you THE MAGIC DISAPPEARING BOX!'[response]";
		if magic trunk is closed:
			say "He flourishes his cape, and opens the trunk.";
			now magic trunk is open.
	
	Every turn during Pre Magic:
		say "[one of]Mumford offers a hand to assist you.  'And now, my lovely assistant will enter the mysterious mystery of THE DISAPPEARING BOX!'[response][or]'That's it, my lovely assistant,' Mumford says.  'Just step into THE MAGIC DISAPPEARING BOX!'[response][or]'Ha ha!  My lovely assistant fears THE MAGIC DISAPPEARING BOX!'[response][or]Mumford mutters under his breath, 'Just get in the box like we rehearsed it, okay?'  He flourishes and smiles for the audience to stall for you.[stopping][murmur]".
	
	Switcheroo is a scene.  Switcheroo begins when Pre Magic Ends.  Switcheroo ends when the player is in understage and concealed panel is closed. 

	To say magicwords:
		say "'And now for [one of]some[or]some more[stopping] magic words!' Mumford bellows above.  '[one of]ABRACADABRA[OR]ALAKHAZAM[OR]HOCUS POCUS[OR]...erm MACARONI AND CHEESE[or]...and you will be AMAZED when you CANNOT SEE my LOVELY ASSISTANT!  Who [italic type]WILL HAVE VANISHED[roman type] from the MAGIC DISAPPEARING BOX[or]...UT-SHAY THE AGIC-MAY ANEL-PAY[or]I'm thinking I'll be in the market for a new Lovely Assistant soon,' Mumford ad-libs, no doubt waggling his eyebrows at the audience who chuckle appreciatively.  'BIBBITY BOBBITY[or]...um HAVA NAGILA[cycling]!'[response]"

	When Switcheroo begins:
		say "Mumford swirls his cape.  'And we say goodbye to my lovely assistant as we explore the mysteries of THE MAGICAL DISAPPEARING BOX!' he says, wiggling his fingers as you duck down in the trunk.[response]He closes the trunk lid and you hear him making a big show with the locks on the outside.";
		now magic trunk is closed.
	
	Every turn during switcheroo:
		if magic trunk is open:
			now magic trunk is closed;
			say "Mumford [one of]pushes the trunk closed again.[or]slams the trunk, almost taking one of your fingers with it.[or]resolutely pushes the trunk closed and holds it for a moment.[cycling]";
		say "[magicwords]".

	When switcheroo ends:
		say "'And now...WATCH and be ASTOUNDED!' hollers Mumford from above."
	
	The audience can be amazed.
	
	The Show is a scene.  The Show begins when switcheroo ends.  The show ends when audience is amazed.

	Instead of entering concealed panel during The Show:
		say "You really not supposed to be in the box while Mumford is doing his stuff.";
		stop the action.
	
	some fake scorpions are a thing.
	
	showcount is a number that varies.  showcount is 0.

	Every turn during The Show:
		increase showcount by 1;
		if fake scorpions are not in magic trunk:
			move fake scorpions to magic trunk;
		say "[one of]'You all saw my Lovely Assistant locked securely inside THE DISAPPEARING BOX!' he announces.  But things ARE NOT ALWAYS WHAT THEY APPEAR!'[or]'If my Lovely Assistant were in the MAGICAL DISAPPEARING BOX, would I consider STABBING IT REPEATEDLY WITH THESE RAZOR SHARP SWORDS?'  (You hear metal clashing above.)[response][or]'Or would I pour this bucket of LIVE DEADLY SCORPIONS DIRECTLY INTO THE MAGICAL DISAPPEARING BOX?'  (You hear a pattering above.)[response][or]'Would I even consider SETTING THE MAGICAL DISAPPEARING BOX ON FIRE???'  (You hear a crackling whoosh of flash powder.)[response][or]I wouldn't do these things unless my Lovely Assistant HAD ACTUALLY DISAPPEARED!'  The audience applauds enthusiastically as he drops the front of the trunk to reveal that you are, indeed, not inside it.[stopping]";
		if showcount is 5:
			now the audience is amazed.
	
	When The Show ends:
		say "You hear the trunk being hastily reassembled above, and Mumford continues.  'But THE MAGICAL DISAPPEARING BOX has a secret!  With more magic words...the mystery can be solved!  DUCK A LA RAHNGE!' he calls, which is your cue."
	
	The Reveal is a scene.  The reveal begins when The Show ends.  The reveal ends when the player is in magic trunk and magic trunk is open.

	Every turn during the Reveal:
		say "[one of]'I said DUCKALARAAAANGE!'[or]'Could my Lovely Assistant have suffered some type of TERRIBLE PERIL?' Mumford yells, and you can hear his foot tapping the trunk above.[or]'Hey!' he whispers harshly above.[or]'More magic words!' he cheefully announces.  'ET-GAY OR-YAY UTT-BAY ACK-BAY IN THE OX-BAY!'[cycling]"

	When the Reveal ends:
		say "Mumford drinks in the deafening applause for a minute, before deferring some to you.  'MY LOVELY ASSISTANT, LADIES AND GENTLEMAN!!!'  You take a graceful bow, understanding finally what it's like to be adored by hundreds of people.  But it is short-lived as there's a 'thoop' sound and a simultaneous gasp in the audience.  Mumford's eyes are wide as he realizes he's been shot with a poison crossbow!  The Killer is in the audience!  You yell for nobody to move as you retrieve your sidearm from where it was uncomfortably concealed in your skimpy outfit...";
		end the story saying "You vow to avenge the Mystical Mumford the Magician!"
	
	The player wears a skimpy outfit.  The description of skimpy outfit is "It's a bit tighter and feathery-er than your normal uniform."

	Instead of taking off skimpy outfit, say "Like this isn't humiliating enough."

	The description of the player is "Yes, you are actually wearing feathers.  It's going to be a good long time before your cohorts stop giving you hell for this back at the station."

	A person called The Amazing Mumford is in wicked stage.  The description is "He's been around the block a few times, and probably in his younger days was quite dashing in his cape and top hat."

	test me with "z/enter box/open box/z/open trap/d/shut panel/x newspaper/take newspaper/up/z/enter panel/open box"
	
