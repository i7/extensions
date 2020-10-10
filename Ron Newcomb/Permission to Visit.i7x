Version 7 of Permission to Visit by Ron Newcomb begins here.

"In lieu of compass directions, we may VISIT, ATTEND, GO TO, and FIND various people, events, places, and things.  Characters may INVITE, PERMIT, and FORBID each other to or from their respective domains."

Volume - Permission to Visit

Chapter 1 - Basic Definitions

Section 0 - prevent compiler error - unindexed

Default-region-to-prevent-compiler-error is a region. 
To decide which region is nothing as a region: (- 0 -).

Section 1 - Properties

[ Gatekeeper is an object instead of a person so permission can be dictated by keycards, badges, and even abstract concepts like the doorman's recognizing you ]
A region has an object called the gatekeeper.  The gatekeeper of a region is usually nothing.
A room can be public.  A room is usually not public.

Definition: a region is public if the gatekeeper of it is nothing.

Section 2 - Relations

Visit-ability relates a person (called the traveller) to a object (called the destination) when the traveller could travel to the destination. [a complicated To phrase]
The verb to be able to visit (he is visitable) implies the visit-ability relation.
[The verb to be able to attend (he is attendable) implies the visit-ability relation.]
[The verb to be able to find (he is findable) implies the visit-ability relation.]

Gatekeep-ability relates a person (called the keeper) to an object (called the destination) when the keeper has indirect authority over the destination.
The verb to gatekeep (he gatekeeps, they gatekeep, he gatekept, it is gatekept, he is gatekeeping) implies the gatekeep-ability relation. 

Section 3 - verbs

To leave is a verb.
To invite is a verb.
To allow is a verb.
To permit is a verb.
To forbid is a verb.

Section 5 - these phrases implement the above relations - unindexed

To decide whether (traveller - a person) has indirect authority over (destination - an object):
	let X be true;  
	if we are forbidding, now X is false; [ FORBID is the only action that is disallowed for public spaces. Anyone can INVITE someone to a public faire, for instance ]
	if the traveller is the destination, decide on X;  [ can you gatekeep yourself?  INVITE BOB without a second noun uses INVITE BOB TO BOB to mean INVITE BOB TO EVERYTHING ]
	if the destination is nothing, decide on X;  [ assuming the nothing came from a Region being passed in, as in INVITE BOB which invites him everywhere -- no region specified = "nothing" ]
	if the destination is a thing, now the destination is the location of the destination;  [ thing --> room ]
	if the destination is a direction, now the destination is the room (destination) from the location of the traveller; [ direction --> room ]
	if the destination is nothing, decide no;  [ the thing is off-stage, or, there isn't a room that-a-way from the traveller's location; no one has authority over that ]
	if the destination is a public room, decide on X;
	if the destination is a [private] room, now the destination is the map region of the destination;   [ room --> region ]
	if the destination is nothing, decide on X;   [ rooms without a region are also public ]
	if the gatekeeper of the destination is nothing, decide on X;  [ regions without a gatekeeper are public ]
	decide on whether or not the traveller is the gatekeeper of the destination;  [ obviously, the traveller will always let himself into his own region ]


To decide whether (traveller - a person) can/could travel to (destination - an object):
	if the traveller is the destination, decide yes;  [ can you visit yourself?  INVITE BOB without a second noun uses INVITE BOB TO BOB to mean INVITE BOB TO EVERYTHING ]
	if the destination is nothing, decide yes;  [ assuming the nothing came from a Region being passed in, as in INVITE BOB which invites him everywhere -- no region specified = "nothing" ]
	if the destination is a thing, now the destination is the location of the destination;  [ thing --> room ]
	if the destination is a direction, now the destination is the room (destination) from the location of the traveller; [ direction --> room ]
	if the destination is nothing, decide no;  [ the thing is off-stage, or, there isn't a room that-a-way from the traveller's location ]
	if the destination is a public room, decide yes;  [ obviously ]
	if the destination is a [private] room, now the destination is the map region of the destination;   [ room --> region ]
	if the destination is nothing, decide yes;   [ an un-set map region propery means the room has no region, so is public by default ]
	if the destination is not a region, decide no;  [ sanity check ]
	let the permitter be the gatekeeper of the destination;   [ so, who owns the region we'll be going to? ]
	if the permitter is nothing, decide yes;  [ room has a region, but the region has no gatekeeper -- the region is public ]
	if the permitter is the traveller, decide yes;  [ obviously, the traveller will let himself into his own region ]
	repeat through the table of Invitations begin;
		if the permitter is the invitor entry and the traveller is the invitee entry begin;
			unless there is a place entry, decide yes;  [ blank place entries means invited everywhere ]
			if the place entry is nothing, decide yes;   [ ditto.  blank entry is not equal to Nothing.  either way, it means "invited everywhere" ]
			if the place entry is the destination, decide yes;  [ if the place entry is filled in, then only if it matches our destination region does ]
		end if;
	end repeat;
	decide on whether or not the traveller carries the permitter.  [if the permitter is a keycard, or a doorman's recognition, then carrying it works ]

Expire-the-invitation-now is a truth state that varies. Expire-the-invitation-now is usually false.

Section 4 - Handy Phrases

[the Index looks beter with "region" as the return value, but "nothing" is a value that must be able to be returned without runtime errors]
To decide which [region]object is the region of (destination - an object):
	if the destination is a thing, now the destination is the location of the destination;  [ thing --> room ]
	if the destination is a direction, now the destination is the room (destination) from the location of the person asked; [ direction --> room ]
	if the destination is a room, now the destination is the map region of the destination;   [ room --> region ]
	decide on the destination.

  [ don't assume the traveller is actually in the place whose invitation may expire  ]
To decide whether (traveller - a person) invitation to (possibly unreturnable place - an object) will expire by going to (new place - an object):
	let the source-region be the region of the possibly unreturnable place;
	if the region of the new place is the source-region, decide no;  [ in other words, if we're not changing regions, no, nothing expires]
	repeat through the table of Invitations begin; 
		if the temporary entry is true and the invitee entry is the traveller begin;
			if (not there is a place entry) or (the place entry is nothing) or (the place entry is the source-region) begin;
				if expire-the-invitation-now is true, blank out the whole row;
				decide yes;
			end if;
		end if;
	end repeat;
	decide no.

To expire (traveller - a person) invitation to (place - an object) by going to (new place - an object): 
	now expire-the-invitation-now is true;
	if traveller invitation to the place will expire by going to the new place, do nothing;
	now expire-the-invitation-now is false.  
[ this bizarre construction exists merely so we needn't duplicate all the code in the To Decide Whether, which would eat memory ]



Chapter 3 - Preferences and Assumptions

Section - the adjective nearby prefers stuff in the same region

[ These rules exist so "go to the kitchen" always chooses the kitchen in the same house you are in, assuming each house is a region.  Likewise for nearby people or things. ]

Definition: a room is nearby if the map region of it is the map region of the location.

Does the player mean visiting when the noun is nearby: it is likely.   
Does the player mean travelling to when the noun is nearby: it is likely.
Does the player mean finding when the noun is nearby: it is likely.


Section - each action prefers a particular kind


Does the player mean visiting a person: it is likely.
Does the player mean visiting a room: it is possible.
Does the player mean visiting a thing: it is unlikely.

Does the player mean travelling to a room: it is likely.
Does the player mean travelling to a person: it is possible.
Does the player mean travelling to a thing: it is unlikely.

Does the player mean finding a thing: it is likely.
Does the player mean finding a person: it is possible.
Does the player mean finding a room: it is unlikely.


Section - public rooms usually serve as landing points, so prefer travelling there

Does the player mean travelling to when the noun is public: it is likely.


Section - unsuccessful attempt message curtailing

[ the Check rules in this extension already narrate failure for everyone ]
[Unsuccessful Attempt by someone travelling to (this is the curtail unsuccessful NPC travel rule): do nothing. 
Unsuccessful Attempt by someone visiting (this is the curtail unsuccessful NPC visit rule): do nothing. 
Unsuccessful Attempt by someone finding (this is the curtail unsuccessful NPC find rule): do nothing. 
Unsuccessful Attempt by someone inviting to (this is the curtail unsuccessful NPC invite rule): do nothing.
Unsuccessful Attempt by someone permitting to (this is the curtail unsuccessful NPC permit rule): do nothing.
Unsuccessful Attempt by someone forbidding from (this is the curtail unsuccessful NPC forbid rule): do nothing.]


Section - assume the listener (for use with Conversation Framework by Eric Eve)

Does the player mean inviting the current interlocutor (this is the invite listener rule): it is likely.
Does the player mean permitting the current interlocutor (this is the permit listener rule): it is likely.
Does the player mean forbidding the current interlocutor (this is the forbid listener rule): it is likely.


Chapter 2 - Movement verbs

Section 1 - understanding

[  I specifically "break out" the below Understand statments to further enforce each verb's noun-type preference 
VISIT, V  : person takes precedence, then room.  Thing only if nothing else is available.
FIND, F  : thing takes precedence, then person.  Room only if nothing else is available.
ATTEND, GO : room takes precedence, then person.  Thing only if nothing else available.
]


Understand "find [any thing]" or "f [any thing]" as finding.
Understand "visit [any person]" or "v [any person]" as visiting.
Understand "go to/toward/into [any room]" or "go [any room]" or "visit [any room]" or "v [any room]" or "attend [any room]" as travelling to. 
Understand "go to/toward/into [any person]" or "go [any person]" or "attend [any person]"  as visiting. 
Understand "go to/toward/into [any thing]" or "go [any thing]" or "visit [any thing]" or "attend [any thing]" or "v [any thing]" as finding. 
Understand "find [any person]" or "f [any person]" as visiting.
Understand "find [any room]" or "f [any room]" as travelling to.


[ All the movement verbs in this extension call Travelling To.  Visit and Find merely do a quick translation before calling Travelling To.]

Section 2 - the finding action

Finding is an action with past participle found, applying to one visible thing. The specification of the finding action is "Functionally identical to the GO TO (PLACE) command, the finding action is intended to be used on props, and in cases of disambiguation, will prefer props to people, and people to rooms. The finding action uses the travelling to action internally."

Carry out an actor finding (this is the Find Uses Travel-To rule): 
	if the noun is a room, try actor travelling to the noun;
	otherwise try the actor travelling to the location of the noun. 


Section 3 - the visiting action

Visiting is an action applying to one visible thing. The specification of the visiting action is "Functionally identical to the GO TO (PLACE) command, the visiting action is intended to be used on people, and in cases of disambiguation, will prefer people to rooms (or events), and rooms to props.  The visiting action uses the travelling to action within."
Carry out an actor visiting (this is the Visit Uses Travel-To rule):  
	if the noun is a room, try actor travelling to the noun;
	otherwise try the actor travelling to the location of the noun. 


Section 4 - the Travelling To action


Travelling to is an action applying to one visible thing. The specification of the travelling to action is "Functionally identical to the GO TO (PLACE) command, the travelling to action is intended to be used on rooms, and in cases of disambiguation, will prefer rooms to people, and people to rooms."


The travelling to action has a room  called the room travelled from. 
The travelling to action has a room  called the room travelled to. 
The source region and the destination region are objects that vary.  
[ these aren't put into the rulebook so that the error messages (from Check) in table P2V may use them ]
[The travelling to action has a region called the source region;
The travelling to action has a region called the destination region;]

Setting action variables for travelling to: 
	if the noun is a room, now the room travelled to   is the noun;
	otherwise                   now the room travelled to   is the location of the noun;
	now the room travelled from    is the location of the actor;
	if the room travelled from is nothing, now the source region is nothing;
	otherwise now the source region is the map region of the room travelled from;
	now the destination region is the map region of the room travelled to.

Check an actor travelling to (this is the already here rule): 
	if the room travelled to is the room travelled from begin;
		say "[We] [are] already [there]." (A) instead;
		rule succeeds;
	end if.

Check an actor travelling to (this is the permission to visit rule):
	if the actor cannot visit the room travelled to,	
		say "[The person asked] [need] [the gatekeeper of the destination region][if the gatekeeper of the destination region is a person]'s permission[end if] to enter [the destination region]." (A) instead.

Carry out an actor travelling to (this is the end invitation rule):  
	expire the actor invitation to the room travelled from by going to the room travelled to.


Section 5 - the soft hiatus

[ The Issue Move Command rule also issues a Look command, and the * * * must appear beforehand.  Hence, this assertion. ]
The soft hiatus rule is listed before the issue move command rule in the carry out travelling to rules. 

Carry out [the player] travelling to (this is the soft hiatus rule): 
	unless the region of the room travelled to is the region of the room travelled from, 
		say "[line break]        *    *    *[line break]" (A).


Section 6 - the actual move


Carry out an actor travelling to (this is the issue move command rule): 
	move the actor to the room travelled to.


Section 7 - a default NPC report rule

Report someone travelling to (this is the default report travelling rule):
	if the player is in the room travelled from, say "[The person asked] [leave]." (A);
	if the player is in the room travelled to, say "[The person asked] [arrive]." (B).


Chapter - Updating Cardinal Movement

Section 1 - the important rules

Check an actor going (this is the permission to go rule):
	if the actor cannot visit the room gone to,
		say "[The person asked] [need] [the gatekeeper of the destination region][if the gatekeeper of the destination region is a person]'s permission[end if] to enter [the destination region].[line break]" (A) instead.

Carry out an actor going (this is the expire the invitation rule):
	expire the actor invitation to the room gone from by going to the room gone to.

Section 2 - optionally set for messages

[ set these for the benefit of the Check messages ]
Setting action variables for going (this is the set global region variables for messages rule):
	now the source region is the region of the room gone from;
	now the destination region is the region of the room gone to. 



Chapter 4 - Regional Permission Verbs


Section 1 - Invite

Inviting it to is an action applying to two visible things. The specification of the inviting it to action is "Characters can own rooms and regions, including the player.  INVITE allows the player to unblock NPCs from entering owned places.  This action is also very useful to be called internally from the author's 'try' statement to simulate NPCs unblocking areas of the map for the player.  Invitations are temporary:  once the invited character leaves the area, they cannot re-enter."

Understand "invite [any person] to [any region]" as inviting it to.
Understand "invite [any person] to [any room]" as inviting it to.

Check an actor inviting to (this is the Lacks Authority To Invite rule):
	if the actor does not gatekeep the second noun,
		say "[The person asked] [lack] [if the second noun is nothing]the authority[otherwise]authority over [the second noun][end if]." (A) instead;

Carry out an actor inviting to (this is the standard invite rule): 
	unless the region of the second noun is nothing, now the second noun is the region of the second noun;
	repeat through the table of Invitations begin;  [ check for duplicates ]
		if the invitor entry is the actor and the invitee entry is the noun begin;
			if there is no place entry or the place entry is nothing or the place entry is the second noun, rule succeeds; 
		end if;
	end repeat; 
	choose a blank row in the table of Invitations; 
	now the invitor entry is the actor;
	now the invitee entry is the noun; 
	unless the second noun is nothing, now the place entry is the second noun;
	now the temporary entry is true. 


Section 2 - Permit


Permitting it to is an action applying to two visible things. The specification of the permitting it to action is "Characters can own rooms and regions, including the player.  PERMIT differs from INVITE only in that it grans an open invitation.  That is to say, the invitiation is permanent."
Understand "permit [any person] to [any region]" as permitting it to. 
Understand "permit [any person] to [any room]" as permitting it to.

Check an actor permitting to (this is the Lacks Authority To Permit rule): 
	if the actor does not gatekeep the second noun,
		say "[The person asked] [lack] [if the second noun is nothing]the authority[otherwise]authority over [the second noun][end if]." (A) instead.

Carry out an actor permitting to (this is the standard permit rule): 
	now the second noun is the region of the second noun;
	repeat through the table of Invitations begin;  [ check for duplicates ]
		if the invitor entry is the actor and the invitee entry is the noun begin;
			if the place entry is nothing or the place entry is the second noun begin;
				now the temporary entry is false;  [ in case it was previously just an invite ]
				rule succeeds; 
			end if;
		end if;
	end repeat; 
	choose a blank row in the table of Invitations; 
	now the invitor entry is the actor; 
	now the invitee entry is the noun; 
	unless the second noun is nothing, now the place entry is the second noun;
	now the temporary entry is false. 


Section 3 -  Forbid

Forbidding it from is an action with past participle forbidden, applying to two visible things. The specification of the forbidding it from action is "Characters can own rooms and regions, including the player.  FORBID undoes the effects of the inviting and permitting actions.  It can be used while the character is still in the forbidden region, and if done so, the author needs to move the intruder because they will be otherwise unable to move."
Understand "forbid [any person] from [any region]" as forbidding it from.
Understand "forbid [any person] from [any room]" as forbidding it from.

Check an actor forbidding from (this is the Lacks Authority To Forbid To check rule): 
	if the actor does not gatekeep the second noun,
		say "[The person asked] [lack] [if the second noun is nothing]the authority[otherwise]authority over [the second noun][end if]." (A) instead.

Carry out an actor forbidding from (this is the standard forbid rule): 
	now the second noun is the region of the second noun;
	repeat through the table of Invitations begin; 
		if the invitor entry is the actor and the invitee entry is the noun begin;
			if the second noun is nothing, blank out the whole row; 
			if there is a place entry and the place entry is the second noun, blank out the whole row; 
		end if;
	end repeat. 


Chapter 4 - single-noun regional permissions

Section 1 - single-noun invite

Understand "invite [any person]" as inviting it to.
Rule for supplying a missing second noun while an actor inviting something to (this is the invite to everywhere rule): now the second noun is the noun.
Before an actor inviting to when the noun is the second noun (this is the invite to nowhere means everywhere rule): now the second noun is nothing.

Section 2 - single-noun permit

Understand "permit [any person]" as permitting it to.
Rule for supplying a missing second noun while an actor permitting something to (this is the permit to everywhere rule): now the second noun is the noun.
Before an actor permitting to when the noun is the second noun (this is the permit to nowhere means everywhere rule): now the second noun is nothing.

Section 3 - single-noun forbid

Understand "forbid [any person]" as forbidding it from.
Rule for supplying a missing second noun while an actor forbidding something from (this is the forbid from everywhere rule): now the second noun is the noun.
Before an actor forbidding from when the noun is the second noun (this is the forbid from nowhere means everywhere rule): now the second noun is nothing.



Chapter 5 - storage

Section 1 - store all invitations and permits


Table of Invitations
invitor		invitee 		place		temporary
object		object		region		truth state
with 10 blank rows.

Section 2 - default report rules

Report an actor inviting something to     	(this is the default inviting     report rule): say "[The actor] [invite] [the noun][if the second noun is not nothing] to [the second noun][end if]." (A).
Report an actor permitting something to 	(this is the default permitting report rule): say "[The actor] [allow] [the noun] access[if the second noun is not nothing] to [the second noun][end if]." (A).
Report an actor forbidding something from 	(this is the default forbidding report rule): say "[The actor] [forbid] [the noun][if the second noun is not nothing] from [the second noun][end if]." (A).


Chapter 6 - INVITATIONS testing command, not for release

Understand "invitations" as a mistake ("[INVITATIONS testing command]").
To say INVITATIONS testing command:
	repeat through the table of Invitations begin; 
		say "[The invitor entry] [if the temporary entry is true][invite][otherwise][permit][end if] [invitee entry][if there is a place entry] to [place entry][otherwise] anywhere[end if]."; 
	end repeat. 

[Version 7: added Responses for new build ]
[Version 6: 6E59 upgrade: rearranged to make Index nicer; re-named testing command so it's obvious in the index; ]
[Version 5: setting variables for travel to  threw errors on an out-of-play actor ]
[Version 4: multiple invite-to-anywhere threw runtime error on blank place entry; specific room in invite was being dropped even though there wasn't a region]
[Version 3: added past participles.  Fixed two missing "try an actor" bits. Added Report Someone rule with entries in the p2v message table. ]

Permission to Visit ends here.

---- DOCUMENTATION ----

Section: Compass Hiatus


The craft of writing holds that if a journey doesn't advance the plot or deepen relationships, the journey should be skipped with a sentence or two.  This extension defines the verbs VISIT, ATTEND, GO TO, and FIND in accordance with this writing advice by plucking the character from one location and setting him in another, bypassing the need for cardinal directions.  The author may also free herself and her players from geographical concerns altogether by simply not connecting locations together with cardinal directions, and concentrate her efforts on story concerns.  

The author can still provide guidance to the player by asserting certain regions of the work as off-limits.  Each region has a "gatekeeper", which is either a character whose explicit permission (or temporary invitation) is required, or, is an item the player must be carrying, to enter the region.  Individual rooms may be declared "public" so that they may always be entered by the player.  For example, outside the entrance to a secure building would typically be public. 

Whether a room is public or not may be changed by the author during the game.  Changing the gatekeepers is also done directly.  (A region is public when its gatekeeper is "nothing".)  Invitations and permissions however are changed via the actions PERMIT, FORBID, and INVITE. Invitations are temporary, expiring when the invitee leaves the region.  Permitting a character grants a permanent invitation, or at least until the gatekeeper forbids the character. 
	now the gatekeeper of Dune is Leto Atreides;
	now the courtyard entrance is public;
	try Leto forbidding the Harkonnens from Dune;
	try Leto permitting Paul Atreides to Dune;
	try the Fremen inviting Duncan Idaho to the desert.


These Actions work equally well with PCs and NPCs. PCs can themselves become -- and cease to be -- gatekeepers.  For example, if we would allow our player to claim regions as his own:
	*: Understand "claim [any region]" as claiming. 
	Claiming is an action applying to one visible object. 
	Carry out claiming: now the gatekeeper of the noun is the actor. 
	Report claiming: say "You claim [the noun] for Spain!"


Modifying our player's inventory to list these many new resources is almost certainly in order.  We'll need a new rule for each.
	*: First carry out taking inventory:
		if the number of player-owned regions is not 0, say "You own [list of player-owned regions].";
		otherwise say "You don't own any real estate.  Even your apartment is rented."

	First carry out taking inventory:
		repeat through the table of Invitations begin; 
			say "[The invitor entry] [if the temporary entry is true]invites[otherwise]permits[end if] [invitee entry][if there is a place entry] to [place entry][otherwise] anywhere[end if]."; 
		end repeat. 

A testing command, "list invitations", is provided.  It will list all permissions and invitations currently held by anyone, anywhere. 

Compass directions are still supported, of course.  Permissions are checked when moving thus.


Section: Miscellany

Visit, Attend, Find, and Go To are all functionally synonymous with one another:  each command moves the character to the location of the desired person, place, thing, or event, provided the gatekeeper allows it of course.  The verbs can be used interchangably with all noun types as an allowance to the player, but in the case of disambiguations, each has specific preferences:  Visit prefers persons, then rooms, and finally things; Find prefers things, then persons, then rooms; and Attend & Go prefer rooms, then people, and finally things.  This is an important point because any rules the author's game affects will affect all of these verbs equally.  Such consistancy is usually a good thing, if at first unexpected.

Modifying the default behavior for hybrid works is relatively painless.  For example, if we are writing an exploratory game and do not wish the player to skip rooms:
	*: Check travelling to (this is the Don't Jump To Unvisited Places rule): if the destination is unvisited, say "You don't know where [the noun] is." instead.


Similarly, if we wish to warn the player when his invitation is about to expire:
	*: Check travelling to (this is the invitation expiration warning rule):
		if the actor invitation to the room travelled from will expire by going to the room travelled to begin;
			say "Your invitation will expire.  Are you sure? ";
			unless the player consents, do nothing instead;
		end if.


If we would like to hide unknown people and items, using extension Epistemology by Eric Eve:
	*: Check visiting (this is the Don't Jump To Unknown People rule): if the noun is unknown, say "You don't know where [the noun] is." instead.
	Check finding (this is the Don't Jump To Unknown Items rule): if the noun is unknown, say "You don't know where [the noun] is." instead.


If we would like to introduce concepts of last known locations, hard to find people, and things misplaced by other characters, here's a start:
	*: A thing has a room called the last known location.
	
	This is the Last Known Location rule: 
		try actor travelling to the last known location of the noun.  
	
	The Last Known Location rule is listed instead of the Visit Uses Travel-To rule in the carry out visiting rules.  
	The Last Known Location rule is listed instead of the Find Uses Travel-To rule in the carry out finding rules.


We can ask at any time if a person "can visit" a region, room, thing, person, or even a direction. 
	if Uncle Ernie can visit Aunt Bertha,
	if the player can visit the skeleton key,
	if the actor can visit the town square,
	if the player can visit north, say "You can go north from here."


Example: ** Testing Area - A touching story about a lone cattle prod.

	*: "Testing Area"

	Include Permission to Visit by Ron Newcomb. Use no scoring.  
	
	Section 1 - as the story opens
	
	Area 51 is a region. 
	Roswell is a region.   
	HQ is a region.    
	The RV is a region.
	 
	Silo 1 and a shady spot are rooms.  
	Silo 5 is a room in Area 51.   
	The general store is a room in Roswell. "Everyone in Roswell stops by this filled-to-bursting little store.  It's amazing anyone can find anything."
	The office full of answers is a room in HQ. "Ah! Yes! It's all here! Aliens are involved!".
	your RV is a room in the RV. "Looking out the window of your RV, you can see the town of Roswell and, in the distance, a couple of grain silos. [if office is visited]'Oh bother, where's that keycard? I need it as proof!'[otherwise]'How odd, to have grain silos in the desert,' you ponder.[end if]". Understand "home" as your RV.  
	  
	Mayor 'Shorty' Grein Mannie is a man in shady spot.   The gatekeeper of Roswell is Mayor Mannie. 
	The keycard is a thing in the store.  The gatekeeper of HQ is the keycard. 
	The player is in your RV. The gatekeeper of the RV is yourself. 
	  
	[ Intentionally creating "spot" as an animal, a room, and a thing.]  
	A dalmatian named Spot is an animal in silo 1.  Understand "dog" as the dalmatian. 
	A targeting spot missile is a thing in silo 5. It is not portable. 
	The printed name of shady spot is "shady spot behind silo 1".
	
	Shady spot is north of Silo 1. The general store is north of shady spot.
	
	Definition: a thing is inanimate if it is not a person.
	Definition: a region is player-owned rather than other-owned if the player is the gatekeeper of it. 
	
	First carry out taking inventory:
		if the number of player-owned regions is not 0, say "You own [the list of player-owned regions].";
		otherwise say "You don't own any real estate.  Even your apartment is rented."
	
	When play begins: now the left hand status line is "[the location of the player], within [the map region of the location of the player]"; say "You arrive in Roswell NV just as your TV blares the news, 'Roswell is now under martial law, as declared by its brand-new ruler, Mayor 'Shorty' Grein Mannie.  Checkpoints are setup around the town's entry points, and no one without explicit permission is allowed in.'[line break][line break]You're sure it's just a suggestion, though.[line break][line break]You must get into the main offices of Area 51 to find out what's really going on.".
	
	The agenda is a thing in your RV. The description of it is "People to visit: [a list of people which is not the player].[line break]Things to find: [a list of every inanimate thing not carried by the player].[line break]Places to travel: [a list of every unvisited room].[line break]Regions to explore: [a list of every region]."
	
	
	Section 2 - a strange device
	
	The bizarre cattle prod is a thing in Silo 1. The description of the bizarre cattle prod is "There's a disclaimer sticker on it that reads, 'Warning: do not [bold type]touch[roman type] yourself with the mind-control prod.'". 
	
	Understand "zap [someone]" as touching.
	Persuasion for asking the dalmatian to try doing something when we have touched the dalmatian: rule succeeds.
	Persuasion for asking the mayor to try doing something when we have touched the mayor: rule succeeds.
	
	Instead of touching:
		if the noun is the dalmatian, say "You pet Spot, but it doesn't win him over.";
		if the noun is the mayor, say "You shake hands with the mayor, but it doesn't win him over.";
	
	 
	Section 3 - a likely ordering of events 
	
	Instead of touching someone when the prod is carried, say "[The noun] goes kinda glassy-eyed[if the noun is the mayor] and says, 'Yes, my leader. You may [bold type]take[roman type] Roswell, or any other region you desire'[end if]."
	
	Understand "take [any region]" as taking ownership when the player carries the cattle prod. Taking ownership is an action applying to one visible thing. Check an actor taking ownership HQ: say "Hm. A keycard-locked door keeps you out, and the mind-control prod doesn't seem to be much help with inanimate objects." instead. Check an actor taking ownership: if the actor is the gatekeeper of the noun, say "[Actor] already owns that." instead. Carry out an actor taking ownership: now the gatekeeper of the noun is the actor; say "[Actor] now owns [the noun].".
	
	Carry out travelling to when the location is the office: say "In your haste to leave, you accidentally drop the keycard!"; try silently dropping keycard.
	
	Instead of travelling to the office when the keycard is in the office: say "Curses! It's in the office! You've locked yourself out! What an unwinnable state of affairs!"
	
	Instead of touching yourself when the prod is carried: end the story saying "You go kinda glassy-eyed until a unnerved cop, three days later, orders you to drop the weapon."
	
	Test all with "test spot/go home/test me".
	Test spot with "go home/visit spot/go home/go to spot/go home/find spot". [broken: FIND doesn't go to Target Spot Missile]
	Test me with "take agenda/x agenda/go office/go store/visit silo 1/x prod/take prod/touch the dog/n/touch the mayor/take roswell/i/x agenda/take area 51/go to office/take hq/find keycard/take keycard/go to office/i/find RV/find keycard/x agenda/touch me".



Example: * Lax Security - Forget the keycards.  Just ask a coworker to let you in.

	*: "Lax Security"

	Include Permission to Visit by Ron Newcomb.     
	   
	section 1 -  people and places    
	
	HR, sales, purchasing, R&D, and the basement are regions. After printing the name  of a room, say ", a part of [the map region of the item described]".          
	   
	H wing is a room in HR.  
	R wing is a room in R&D. The gatekeeper of R&D is Charlie.
	P wing is a room in Purchasing. The gatekeeper of Purchasing is Bob.
	S wing is a room in Sales. The gatekeeper of Sales is Bob.
	The stairwell is a room in the basement. The gatekeeper of the basement is the wrench.      
	
	The break room is a room. "North is HR in H wing, managed by no one.  [line break]East is R&D in R wing, managed by Charlie.  [line break]South is Sales in S wing, managed by Bob.  [line break]West is Purchasing in P wing, managed by Bob.  [line break]Southwest is the stairwell with the broken door."
	H wing is north of break room. "The break room is south of here.".
	R wing is east of break room. "The break room is west of here.".
	P wing is west of break room. "The break room is east of here.".
	S wing is south of break room. "The break room is north of here.".
	The stairwell is southwest of break room. "The breakroom is northeast.".
	
	The player is in H wing. Bob, Charlie, and Stan are men in H wing. The wrench is in H wing.  Persuasion rule: persuasion succeeds. The soft hiatus rule is not listed in any rulebook.     
	
	  
	section 2 - expand our notions of Inventory      
		
	First carry out taking inventory:
		repeat through the table of Invitations begin;
			if the temporary entry is false, say "[The invitor entry] has granted [invitee entry] permission to visit [if there is a place entry][place entry][otherwise][regions owned by invitor entry]and anywhere else he holds authority[end if].";
			otherwise say "[The invitor entry] has invited [invitee entry] to [if there is a place entry][place entry][otherwise][regions owned by invitor entry]anywhere you'd like to see[end if].";
		end repeat.
  	
		   
	section 3 - handy stuff
	
	To say regions owned by (character - a person):
		repeat with R running through regions begin;
			if the gatekeeper of R is the character, say "[R], ";
		end repeat.
	
	Test me with "TEST denied/TEST expired-invite/TEST permit/TEST forbid/TEST fixit".
	Test denied with "stan, invite me / stan, invite me to sales".
	Test expired-invite with "i/bob, invite me to sales/visit p/i/visit s/i/visit h/i".
	Test permit with "i/bob, permit me/i/visit p/visit s/i/visit r".
	Test forbid with "i/visit bob/bob, forbid me/i/visit p/visit s/i".
	Test fixit with "go to break room/sw/find wrench/take wrench/go to break room/sw".


