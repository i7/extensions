Version 1/121214 of Crowds by Mike Ciul begins here.

"A way to implement collections of people that can spread across multiple rooms. The extension will keep track of the size of the crowd in each room. Requires Conditional Backdrops by Mike Ciul."

Include Version 3 of Conditional Backdrops by Mike Ciul.
Include Approximate Quantities by Mike Ciul.

Chapter - The Crowd Kind

A crowd is a kind of person. A crowd is usually not scenery. A crowd is usually ambiguously plural. A crowd has a table-name called the approximations. The approximations of a crowd is usually the Table of Numerical Approximation.

Include (- with found_in [ ; ProcessRulebook( (+ Backdrop condition rules +), self );  return (RulebookSucceeded()); ] -) when defining a crowd.

Backdrop condition for a crowd (called the c-mob) (this is the location of crowds rule):
	If the c-mob is presently located, it is present;

The specification of a crowd is "A person who is also a backdrop-like presence representing a countable number of indistinguishable people."

Chapter - The Table of Occupancy
	
Table of Occupancy
group	field 	quantity
a crowd	a room	a number
with 100 blank rows.

Section - Checking the Table

Occupancy relates a crowd (called the c-mob) to a room (called the site) when the count of the c-mob in the site is at least 1.

[[This could be a dynamic relation, but let's make it static and trade memory for speed]

Occupancy relates various crowds to various rooms.]

The verb to occupy (he occupies, they occupy, he occupied, it is occupied, it is occupying) implies the occupancy relation.

The occupancy-cached item is an object that varies.

A room has a number called the cached occupancy count.

To decide what number is the count of (the c-mob - a crowd) in (the site - a room):
	If the c-mob is not the occupancy-cached item, cache occupancy counts for the c-mob;
	decide on the cached occupancy count of the site;

To cache occupancy counts for (the c-mob - a crowd):	
	Now the occupancy-cached item is the c-mob;
	Repeat with the place running through rooms:
		Now the cached occupancy count of the place is 0;
	Repeat through Table of occupancy:
		if the group entry is the c-mob, now the cached occupancy count of the field entry is the quantity entry;

[If we wanted, we could cache occupancy by room instead...]
	
Section - Changing the Table, Internals

To decide whether we/-- set occupancy for (the c-mob - a crowd) in (the site - a room) with (N - a number), by a relative amount:
	if N is 0 and by a relative amount, no;
	if the c-mob occupies the site:
		repeat through Table of Occupancy:
			if field entry is the site and group entry is the c-mob:
				if by a relative amount:
					Now N is the quantity entry increased by N within counting range;
				otherwise if N is the quantity entry:
					no;
				If N is less than 1:
					blank out the whole row;
					now N is 0;
				otherwise:
					now the quantity entry is N;
				if the occupancy-cached item is the c-mob, now the cached occupancy count of the site is N;
				yes;
	if N is less than 1, no;
	choose a blank row in Table of Occupancy;
	now the field entry is the site;
	now the group entry is the c-mob;
	now the quantity entry is N;
	if the occupancy-cached item is the c-mob, now the cached occupancy count of the site is N;
	yes.

Section - High-level Phrases for Changing Occupancy
	
To change the number/count of (the c-mob - a crowd) in (the site - a room) to (N - a number), without updating:
	if we set occupancy for the c-mob in the site with N:
		unless without updating, carry out the moving floating objects activity;
	
To add some of/-- (c-mob - a crowd) to/in (the place - a room), without updating:
	if we set occupancy for the c-mob in the place with 1, by a relative amount:
		unless without updating, carry out the moving floating objects activity;
		
To add some of/-- (c-mob - a crowd) to/in all/every (O - a description of objects):
	repeat with the place running through O:
		if the place is a room, add some of the c-mob to the place, without updating;
	carry out the moving floating objects activity;
		
To remove some of/-- (c-mob - a crowd) from/in (the place - a room), without updating:
	if we set occupancy for the c-mob in the place with -1, by a relative amount:
		unless without updating, carry out the moving floating objects activity;
		
To remove some of/-- (c-mob - a crowd) from/in all/every (O - a description of objects):
	repeat with the place running through O:
		if the place is a room, remove some of the c-mob from the place, without updating;
	carry out the moving floating objects activity;
	
To fill (the place - a room) with (c-mob - a crowd), without updating:
	if we set occupancy for the c-mob in the place with effective infinity:
		unless without updating, carry out the moving floating objects activity;
			
To empty (the site - a room) of (c-mob - a crowd), without updating:
	if we set occupancy for the c-mob in the site with 0:
		unless without updating, carry out the moving floating objects activity;

Section - Phrases and Adjectives for Testing Occupancy
	
To decide what number is the present number of (item - a thing):
	Let M be the item;
	if M is not a crowd:
		if the item is in the location of the person asked, decide on 1;
		decide on 0;
	decide on the count of the M in the location of the person asked.

[TODO - split into overloaded adjectives?]

Definition: A thing (called the item) is presently located rather than presently elsewhere:
	if the location of the person asked is nothing, no;
	if the item is a crowd, decide on whether or not the item occupies the location of the person asked;
	otherwise decide on whether or not the location of the item is the location of the person asked;

Definition: A thing is presently singular rather than presently plural if the present number of it is 1.
Definition: A thing is presently unlimited rather than presently limited if the present number of it is effectively infinite.
	
Chapter - Printing the Name of a Crowd

Section - The Indefinite Article

The indefinite article of a crowd is usually "[present number of the item described as an approximate quantity using the approximations of the item described]"

Section - The Name Itself

For printing the plural name of a crowd when the printed plural name of the item described is empty (this is the default pluralization of specimens rule): say "[item described]s";

For printing the name of a crowd (called the c-mob):
	[if the present number of the mess is 1, say "[specimen of the mess]";]
	if the c-mob is singular-named or the c-mob is presently singular, say "[printed name of the c-mob]";
	otherwise carry out the printing the plural name activity with the c-mob.
		
Volume - Testing - Not for Release

Requesting the table of occupancy is an action out of world.

Understand "occupancy" as requesting the table of occupancy.

Carry out requesting the table of occupancy:
	say "Table of Occupancy:[paragraph break]";
	Repeat through the Table of Occupancy:
		say "[quantity entry] [printed name of group entry] in [field entry][line break]";

Crowds ends here.

---- DOCUMENTATION ----

Crowds is a way for one object to represent a large group of people that spreads over multiple locations. It's implemented using the "Conditional Backdrops" extension and a table.

Chapter: Definitions

Section: The Crowd Kind

There is one new kind in this extension, called a crowd. A crowd represents a collection of people. It is a kind of person, but it inherits behaviors from the conditional backdrop kind. As with backdrops and people, the player is not expected to pick them up, drop them, or eat them. If they did, things could get buggy.

Section: Creating Crowds

Since a crowd is a kind of person, and not a kind of backdrop or conditional backdrop, it can't be placed like a normal backdrop or a thing. Instead, we have phrases we can use when play begins.

	The audience is a crowd. When play begins: fill the House with the audience.

Chapter: Presence and Quantities

Section: The Occupancy Relation

To check for the presence of a crowd, we can use the occupancy relation:

	If the House is occupied by the audience:
		say "We've got a full house tonight!"

	If the audience occupies the House:
		say "Same thing."

Section: Counting

When a crowd is placed in a room using the "fill" declaration, the quantity in that room is considered to be unlimited.

But we can have crowds that ebb and swell. Every place where a crowd is found has a number representing the quantity. To find out how much of a crowd is in any room, we can use the "count of something in" phrase:

	say "The House has [count of the audience in the House] audience members in it."

Please note that no "COUNT" verb has been implemented.

We make use of the Approximate Quantities extension, also by Mike Ciul, to test if a quantity is unlimited:

	if the present number of the queue is effectively infinite:
		say "You could wait for eternity at the end of this queue."

For more details, see the the documentation for the extension.

Because various-to-various relations can be costly, there is some caching implemented to accelerate access to crowd counts. The caching is done per crowd - in other words, once you find the count of a crowd in one place, it will be cached for all places. If for any reason you need to loop over both crowds and rooms, doing it in this nesting order will be much faster:

	Repeat with the group running through crowds:
		Repeat with the place running through rooms:

Section: The Present Number

Usually we only want to know how much there is where we are. We can check the quantity of a crowd in the current location using a phrase to find the "present number:"

	If the present number of the audience is greater than 0:
		say "The audience is here."

Present refers to "right here" as well as "right now." In this case, "here" is the location of the "person asked," so if another actor is performing an action, we'll get the count wherever they are. If our game has NPCs interacting with crowds, though, it would be wise to keep in mind that a crowd is really only present in the location of the player, just like any other backdrop. 

The present number phrase also applies to all other things, but in order to be consistent with the way crowds behave, it only counts objects that are directly contained by the location. If an object is touchable but it's carried or it's in a container, the present number of it will be zero. In addition, if the player is trapped in a container, the present number of something in the room will be one, even though it is not touchable. This shouldn't come up very often, because the phrase is most often used for finding out if something is a crowd, and if it is, whether there's more than one of it. Which leads us to...

Section: Presently Located and Presently Elsewhere

Crowds defines a few pairs of adjectives we can use to check on the present number of something. The first and most basic are "presently located" and "presently elsewhere." "Presently located" means the present number is at least one, and "presently elsewhere" means the present number is zero. In the case of an ordinary thing, "presently located" is exactly the same as "in the location of the person asked," i.e. it means the item is directly contained by the location

	If the audience is presently located:
		say "We have an audience."

	If the audience is presently elsewhere:
		say "No one's looking!"

Section: Presently Plural and Presently Singular

We can use these if all we need to check about a number is whether it's singular or plural. A thing is presently singular if the present number of it is one - otherwise it is presently plural. Notably, zero is plural. This shouldn't be an issue normally, because most of the time when we check the number of something, we already know it's there.

	say "There [if the audience is presently singular]is an audience member[otherwise]are audience members[end if] here."

	Instead of smelling a presently plural thing:
		say "The smell is strong, since there are so many of them."

Section: Presently Unlimited and Presently Limited

Two more adjectives allow us the convenience of checking whether the present number is effectively infinite or effectively finite:

	if the audience is presently unlimited, say "Usually we treat an unlimited supply of a crowd more like a separate thing."

	if the audience is presently limited, say "When the supply is not unlimited, we might treat it like a number of individuals."

Chapter: Moving and Changing Crowds

Section: Phrases on Crowds

There are a number of phrases available for changing the quantity of a crowd:

	Change the number of the audience in the lobby to effective infinity.
	Fill the lobby with the audience. (same effect as the previous sentence)

	Change the number of the audience in the lobby to 0.
	Empty the lobby of the audience. (same as the previous sentence)

	Add some audience to the street. (increases the number of the audience by 1)

	Remove some audience from the street. (decreases the number of the audience by 1)

	Add some audience to every lighted room.

	Remove some audience from every room in the Theater.

All of these phrases have a "without updating" option. If you use the option, Crowds will not automatically carry out the "moving floating objects" activity, which puts backdrops in place. This can make things faster if you know you are going to change several rooms before the presence of a crowd is tested.

Section: Removing Crowds from Play

As mentioned before, the "Move the X backdrop to all Y" phrase won't work for crowds because they're not backdrops. In addition, manually moving crowds or specifying their presence with "Backdrop Condition" rules may have unpredictable results because they could interfere with the "Location of Crowds" rule. The above phrases should be used instead.

However, it should be safe to remove a crowd with a "Backdrop Condition" rule even when its present number is not zero, as long as our own source doesn't depend on the present number to tell us whether a backdrop is really there:

	A backdrop condition for the Living Creatures when Creation is happening: it is absent.

Chapter: Messages

It is possible to change all of the text that Crowds may output. Here is a rundown of everything the extension might say:

Section: The Collectively-named Adjective

A crowd is usually not scenery, so its name will be printed in room descriptions. (That means we can give it an initial appearance, too!) The name tends to change depending on the present quantity.

Section: The Printed Name and Printed Plural Name of a Crowd

The printed name of a crowd should be a text that describes a single member, so if the present number of the audience is one, you might see:

	a spectator

The printed plural name should be defined as well, so we can see:

	a pair of spectators

But if we don't define it, Crowds will do the dumbest possible thing, and add an "s" to the end of the name.

The "location of crowds" rule places a present crowd in the location whenever backdrop positions are updated.

A Crowd is ambiguously plural by default (according to Emily Short's Plurality extension), and this should normally be left alone, because it enables the printing of approximate quantities to work correctly.

Section: Numbers and the Indefinite Article of a Crowd

In addition to the name itself, Crowds attempts to include a number in the indefinite article. By default, numbers will be given vaguely, like "a couple" for two and "several" for four or more.

Section: Printing Numbers

By default, the indefinite article of a crowd uses the Approximate Quantities extension to say how big it is. If we write:

	"[an audience]"

it will output different things depending on the present number of the audience.

	a couple spectators

	hundreds of spectators

Care should be taken to make sure that our crowd is improper-named. If we do this:

	audience is a crowd.

we might end up leaving out the number altogether, and we'll end up with:

	spectators

	spectators

By default, numerical quantities are looked up in the Table of Numerical Approximation, defined in the Approximate Quantities extension. But we can use any table by changing the "approximation" property of a crowd.

	The approximation of the audience is the Table of Spectator Approximations.

Chapter: Testing

Crowds has one testing command. "OCCUPANCY" will cause the Table of Occupancy to be printed out.

Chapter: Notes

This extension started out as the more ambitious "Multitudes" extension. After adding the "Conditional Backdrops" extension I realized that things could be a lot simpler, and did away with the "specimen collection" relation that made Multitudes so complicated. By limiting the extension to people, I was also able to do away with the complexities of taking and dropping "specimens."

Thanks to Erik Temple, Victor Gijsbers, and Andrew Plotkin for some useful tips on creating "Multitudes." Thanks to John Clemens for the original version of Conditional Backdrops. Matt Weiner and Wade Clarke pitched in to rewrite the rubric of "Multitudes" so people will understand what the heck it's for, and I hope their wisdom has transferred a little to the documentation of this extension. Also thanks to Ron Newcomb, Emily Short, Jim Aikin and everyone on intfiction.org for their numerous answers to my needling questions, which have expanded my knowledge of Inform a thousandfold.

If you have feedback of any kind regarding this extension or any of my extensions, please contact me at captainmikee@yahoo.com.

Chapter: Changes

121214: Added missing "empty [room] of [crowd]" phrase.

Example: * Theater - A very simple example showing the basic functionality of Crowds. An audience inhabits different rooms in a theater

	*: "Theater"

	Include Crowds by Mike Ciul

	The House is a room. The Lobby is south of the House. The Coat-Check is west of the Lobby. The Balcony is up from the Lobby. The Street is south of the Lobby.

	The audience members are a crowd.

	When play begins:
		Repeat with the place running through rooms:
			Fill the place with the audience;
	
Example: *** Feast - Demonstrates edible and animate crowds.

	*: "Feast"

	Include Crowds by Mike Ciul.

	Use maximum counting number of at least 6.

	Dining Hall is a room. Corridor is west of Dining Hall. Foyer is west of Corridor. Sun Room is north of Corridor. Restroom is south of Corridor. Auditorium is east of Dining Hall.

	A fine array of pastries and goodies is scenery in Dining Hall. Understand "pastry" as pastries.

	The roaches are a crowd. The printed name is "roach". Understand "roach" as roaches. The printed plural name is "roaches". The approximations of the roaches is the Table of Roach Quantities.

	Instead of taking the pastries in Dining Hall:
		Say "You grab one and eat it immediately. As you stuff the last crumbs in your mouth, you see a hint of movement underneath one of the pastries here. A single cockroach emerges and crawls towards you!";
		Add some roaches to the Dining Hall.

	Definition: A room is infested rather than uninfested if it is occupied by the roaches.
	Definition: A room is spreading if the count of the roaches in it is at least 3.

	Every turn:
		Repeat with the place running through infested rooms:
			if the place is the location:
				say "More roaches arrive.";
			Add some roaches to the place;
		Repeat with the place running through uninfested rooms adjacent to a spreading room:
			if the place is the location:
				Let the source be a random spreading room adjacent to the place;
				say "A roach crawls in from the [source].";
			Add some roaches to the place.

	Table of Roach Quantities
	threshold	approximation	style
	1	"no"	truly plural
	2	"a single"	collective
	3	"a couple of"	truly plural
	4	"a few"	truly plural
	5	"a swarm of"	collective
	6	"a huge swarm of"	collective
	30000	"a tremendous swarm teeming with"	collective

	test me with "get pastry/w/drop pastry/e/w/e/w/e/w/l/g/e/l/w/n/l/l/l/l/l/l/eat roach/touch roach/roaches, hello"

