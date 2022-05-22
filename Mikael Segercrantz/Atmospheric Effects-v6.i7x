Version 6.2 of Atmospheric Effects by Mikael Segercrantz begins here.

"A table-based way to add atmospheric effects to rooms, regions, things and scenes."


Part 1 - Generalia

Chapter 1(a) - Kinds of value

Section 1(a)1 - Scenic type

A scenic type is a kind of value.
The scenic types are full random, fully random, random and ordered.

Section 1(a)2 - Running type

A running type is a kind of value.
The running types are run once, once, run forever and forever.

Section 1(a)3 - Further type

A further type is a kind of value.
The further types are default and stopping.

Section 1(a)4 - Ignoring type

An ignoring type is a kind of value.
The ignoring types are ignore and do not ignore.

Section 1(a)5 - Shown type

A shown type is a kind of value.
The shown types are already shown and unshown.


Chapter 1(b) - Modifications

Section 1(b)1 - Room

A room has a table-name called scenic table.
The scenic table of a room is usually the Table of Default Atmospherics.

A room has an ignoring type called ignoring.
The ignoring of a room is usually do not ignore.

Section 1(b)2 - Region

A region has a table-name called scenic table.
The scenic table of a region is usually the Table of Default Atmospherics.

A region has an ignoring type called ignoring.
The ignoring of a region is usually do not ignore.

A region has a shown type called isshown.
The isshown of a region is usually unshown.

Section 1(b)3 - Things

A thing has a table-name called scenic table.
The scenic table of a thing is usually the Table of Default Atmospherics.

A thing has an ignoring type called ignoring.
The ignoring of a thing is usually do not ignore.


Chapter 1(c) - Global tables

Section 1(c)1 - Table of Default Atmospherics

Table of Default Atmospherics
during (a scene)		initch (a number)		latch (a number)		aftcnt (a number)		curcnt (a number)		sctype (a scenic type)		runtype (a running type)		frtype (a further type)		igtype (an ignoring type)		subtable (a table name)
--

Section 1(c)2 - Table of Atmospheric Definition

Table of Atmospheric Definition
loci (an object)		ignoring (an ignoring type)			subtable (a table name)
--

Section 1(c)3 - Table of Default Messages

Table of Default Messages
used (a number)		message (text)
--

Section 1(c)4 - Table of Messages to Show

Table of Messages to Show
message (text)
with 20 blank rows


Chapter 1(d) - Other globals

Section 1(d)1 - The empty region

The empty region is a region.


Part 2 - Initialization

Chapter 2(a) - Corrections

Section 2(a)1 - Correct synonyms

To correct synonyms:
	repeat with r running through rooms:
		correct synonyms of r;
	repeat with r running through regions:
		correct synonyms of r;
	repeat with r running through things:
		correct synonyms of r.

Section 2(a)2 - Correct synonyms of

To correct synonyms of (r - an object):
	if r is a room or r is a region or r is a thing:
		repeat through the scenic table of r:
			if the scenic table of r is the Table of Default Atmospherics:
				now the runtype entry is run forever;
			if the subtable entry is the Table of Default Messages, now the runtype entry is run forever;
			if the sctype entry is full random, now the sctype entry is fully random;
			if the runtype entry is once, now the runtype entry is run once;
			if the runtype entry is forever, now the runtype entry is run forever.
	

Chapter 2(b) - Initialization

Section 2(b)1 - Initializing from Table of Atmospheric Definition

To initialize from table:
	repeat through the Table of Atmospheric Definition:
		if the loci entry is a room or the loci entry is a region or the loci entry is a thing:
			now the scenic table of the loci entry is the subtable entry;
			now the ignoring of the loci entry is the ignoring entry.

Section 2(b)2 - Initializing the locations

To initialize the locations:
	repeat with r running through rooms:
		initialize the location r;
	repeat with r running through regions:
		initialize the location r;
	repeat with r running through things:
		initialize the location r.

Section 2(b)3 - Initialize the location

To initialize the location (r - an object):
	if r is a room or r is a region or r is a thing:
		let tbl be the scenic table of r;
		repeat with n running from 1 to the number of rows in tbl:
			choose row n in tbl;
			if there is a subtable entry:
				if there is an initch entry:
					do nothing;
				otherwise:
					now the initch entry is 100;
				if there is a latch entry:
					do nothing;
				otherwise:
					now the latch entry is the initch entry;
				if there is an aftcnt entry:
					do nothing;
				otherwise:
					now the aftcnt entry is 0;
				if the aftcnt entry is less than 0, now the aftcnt entry is 0;
				now the curcnt entry  is 0;
				if there is an sctype entry:
					do nothing;
				otherwise:
					now the sctype entry  is random;
				if there is a runtype entry:
					do nothing;
				otherwise:
					now the runtype entry  is run forever;
				if there is an frtype entry:
					do nothing;
				otherwise:
					now the frtype entry  is stopping;
				if there is an igtype entry:
					do nothing;
				otherwise:
					now the igtype entry is do not ignore;
				if the subtable entry is the Table of Default Messages:
					now the frtype entry  is stopping;
					now the runtype entry is run forever;
				repeat through the subtable entry:
					now the used entry  is 0.

Section 2(b)4 - When play begins

When play begins:
	initialize from table;
	initialize the locations;
	correct synonyms.


Part 3 - Decisions and counting

Chapter 3(a) - Counting

Section 3(a)1 - Number of used rows

To decide what number is the number of used rows in (tbl - a table-name):
	let count be 0;
	repeat through tbl:
		if there is a used entry:
			if the used entry is greater than 0, increase the count by 1;
	decide on count.

Section 3(a)2 - Number of free rows

To decide what number is the number of free rows in (tbl - a table-name):
	let count be 0;
	repeat through tbl:
		if there is a used entry:
			if the used entry is 0, increase the count by 1;
	decide on count.


Chapter 3(b) - Numerical decisions

Section 3(b)1 - Maximum number

To decide what number is the largest number in (tbl - a table-name):
	let current be 0;
	repeat through tbl:
		if there is a used entry:
			if the used entry is greater than current, now current is the used entry;
	decide on current.


Chapter 3(c) - Decisions

Section 3(c)1 - A scenic is shown

To decide whether a scenic with initch (ic - a number) latch (lc - a number) aftcnt (ac - a number) curcnt (cc - a number) is shown:
	if ac is 0:
		if a random chance of ic in 100 succeeds, decide yes;
		decide no;
	otherwise:
		if cc is less than ac:
			if a random chance of ic in 100 succeeds, decide yes;
			decide no;
		otherwise:
			if a random chance of lc in 100 succeeds, decide yes;
			decide no.


Part 4 - Saying

Chapter 4(a) - General

Section 4(a)1 - Display row

To display row (row number - a number) in (tbl - a table-name) running (runtype - a running type):
	let current row be 0;
	sort tbl in used order;
	repeat with i running from 1 to the number of rows in tbl:
		choose row i in tbl;
		if there is a message entry:
			if current row is less than row number, increase current row by 1;
			if current row is row number and the used entry is 0:
				increase current row by 1;
				let txt be the message entry;
				choose a blank row in the Table of Messages to Show;
				now the message entry  is txt;
				choose row i in tbl;
				now the used entry is the turn count;
				if runtype is run once, blank out the whole row.

Section 4(a)2 - Clean all messages

To clean all messages in (tbl - a table-name):
	repeat through tbl:
		now the used entry is 0.


Chapter 4(b) - Rules for fully random messages

Section 4(b)1 - To say a fully random

To say a fully random scenic message of (tbl - a table-name) running (runtype - a running type):
	let row number be a random number between 1 and the number of filled rows in tbl;
	display row row number in tbl running runtype;
	clean all messages in tbl.


Chapter 4(c) - Rules for random messages

Section 4(c)1 - To say a random

To say a random scenic message of (tbl - a table-name) running (runtype - a running type):
	let current count be the number of free rows in tbl;
	let maximum be the largest number in tbl;
	let original count be current count;
	if current count is 0:
		clean messages of tbl with maximum;
		let current count be the number of filled rows in tbl minus 1;
		if the number of filled rows in tbl is 1:
			clean last message of tbl;
			let current count be the number of filled rows in tbl;
	let row number be a random number between 1 and current count;
	let current row be 0;
	display row row number in tbl running runtype;
	if the original count is 0 and the number of filled rows in tbl is greater than 0 and maximum is greater than 0:
		choose row with used of maximum in tbl;
		now the used entry is 0.

Section 4(c)2 - Clean messages

To clean messages of (tbl - a table-name) with (maximum - a number):
	repeat through tbl:
		if the used entry is less than maximum, now the used entry is 0.

Section 4(c)3 - Clean last message

To clean last message of (tbl - a table-name):
	clean all messages in tbl.


Chapter 4(d) - Rules for ordered messages

Section 4(d)1 - To say an ordered

To say an ordered scenic message of (tbl - a table-name) running (runtype - a running type):
	let current count be the number of free rows in tbl;
	let maximum be the largest number in tbl;
	let original count be current count;
	if current count is 0:
		let current count be 1;
		clean messages of tbl with maximum;
		if the number of filled rows in tbl is 1, clean last message of tbl;
	display row 1 in tbl running runtype;
	if the original count is 0 and the number of filled rows in tbl is greater than 0 and maximum is greater than 0:
		choose row with used of maximum in tbl;
		now the used entry is 0.


Part 5 - Common phrases for rooms, regions and things

Chapter 5(a) - Displaying

Section 5(a)1 - Display messages of

To display messages of (r - an object):
	if r is a room or r is a region or r is a thing:
		let tbl be the scenic table of r;
		let ign be 0;
		repeat with n running from 1 to the number of rows in tbl:
			choose row n in tbl;
			let doshow be 0;
			if there is a during entry:
				if the during entry is happening, now doshow is 1;
			otherwise:
				now doshow is 1;
			if there is a subtable entry:
				do nothing;
			otherwise:
				now doshow is 0;
			if ign is 1, now doshow is 0;
			if doshow is 1:
				if a scenic with initch initch entry latch latch entry aftcnt aftcnt entry curcnt curcnt entry is shown:
					let cc be the curcnt entry;
					increase cc by 1;
					if cc is greater than the number of filled rows in tbl, now cc is the number of filled rows in tbl;
					now the curcnt entry is cc;
					let rtype be the runtype entry;
					let stbl be the subtable entry;
					let scenic be the sctype entry;
					if scenic is fully random, say a fully random scenic message of stbl running rtype;
					if scenic is random, say a random scenic message of the stbl running rtype;
					if scenic is ordered, say an ordered scenic message of stbl running rtype;
					choose row n in tbl;
					if the igtype entry is ignore, now ign is 1;
					if the number of filled rows in the subtable entry is 0 and the frtype entry is default:
						now the subtable entry is the Table of Default Messages;
						now the frtype entry is stopping;
						now the runtype entry is run forever.

Section 5(a)2 - Display all messages

To display all messages:
	let nummessages be the number of filled rows in the Table of Messages to Show;
	sort the Table of Messages to Show in random order;
	repeat through the Table of Messages to Show:
		say "[message entry] ";
		blank out the whole row;
	if nummessages is greater than 0, say "[paragraph break]".


Part 6 - Rooms

Chapter 6(a) - Every turn in rooms

Section 6(a)1 - Check room messages

To check room messages:
	let shw be 1;
	repeat through the Table of Atmospheric Definition:
		if the ignoring entry is ignore:
			if the loci entry is a thing:
				if the player can see the loci entry, now shw is 0;
	if shw is 1, display messages of location.


Part 7 - Regions

Chapter 7(a) - Every turn in regions

Section 7(a)1 - Check region messages

To check region messages:
	let shw be 1;
	repeat through the Table of Atmospheric Definition:
		if the ignoring entry is ignore:
			if the loci entry is a thing:
				if the player can see the loci entry, now shw  is 0;
			otherwise:
				if the loci entry is a room:
					if the loci entry is the location, now shw is 0;
	if shw is 1:
		clean regions;
		let count be the number of located regions;
		repeat with n running from 1 to count:
			let the final region be the smallest unshown region;
			if the final region is not the empty region:
				display messages of the final region;
				now isshown of the final region is already shown;
			otherwise:
				now n is count.

Section 7(a)2 - Clean regions

To clean regions:
	repeat with r running through regions:
		now isshown of r is unshown;
	now isshown of the empty region is already shown.

Section 7(a)3 - The number of located regions

To decide what number is the number of located regions:
	let count be 0;
	repeat with r running through regions:
		if the player is regionally in r and isshown of r is unshown, increase count by 1;
	decide on count.

Section 7(a)4 - The smallest unshown region

To decide which region is the smallest unshown region:
	let final region be the empty region;
	repeat with r running through regions:
		if final region is the empty region:
			if the player is regionally in r:
				if isshown of r is unshown:
					let final region be r;
				repeat through the Table of Atmospheric Definition:
					if the loci entry is r and the ignoring entry is ignore:
						let final region be r;
	repeat with r running through regions:
		if the player is regionally in r:
			if r is in the final region:
				if isshown of r is unshown:
					let final region be r;
				repeat through the Table of Atmospheric Definition:
					if the loci entry is r and the ignoring entry is ignore:
						let final region be r;
	if isshown of the final region is already shown:
		let final region be the empty region;
	decide on the final region.


Part 8 - Things

Chapter 8(a) - Every turn in the presence of

Section 8(a)1 - Check thing messages

To check thing messages:
	repeat with t running through things:
		if the player can see t:
			display messages of t.


Part 9 - Overridables

Chapter 9(a) - Before reading a command

Section 9(a)1 - The scenic messaging rule

A first every turn rule (this is the scenic messaging rule):
	correct synonyms;
	check thing messages;
	check room messages;
	check region messages.

Section 9(a)2 - The scenic displaying rule

A last before reading a command rule (this is the scenic displaying rule):
	display all messages.


Atmospheric Effects ends here.

---- DOCUMENTATION ----

Chapter: Version Note

This version of the extension breaks compatibility with any previous version earlier than version 4. It is highly recommended to upgrade all code using any previous version of Atmospheric Effects to use this version.

Version 4 of Atmospheric Effects was a complete rewrite, containing almost all the features available in previous releases. This version is improved to work better, and to separate the displaying of scenic messages from the generation of them in a greater degree. (In the last version, where the messages were generated just before the prompt, the scene changing mechanism had run between the result of the action and the generation of messages; now, the messages are generated just after getting the result of the action, and the messages are displayed only just before prompting for the next command, which seems to fix the problem of messages dependent on scenes.)

Section: 6L02 Compatibility Update

This extension differs from the author's original version: it has been modified for compatibility with version 6L02 of Inform. The latest version of this extension can be found at <https://github.com/i7/extensions>. 

This extension is released under the Creative Commons Attribution licence. Bug reports, feature requests or questions should be made at <https://github.com/i7/extensions/issues>.

Chapter: The Kinds Provided

This extension provides four kinds of value; a scenic type, a running type, a further type and an ignoring type.

Section: The Sceninc Types

The scenic types are
	* fully random (with full random as a synonym), displaying messages in a completely random order, without regard to if the message has been shown or not;
	* random, displaying messages in a constrained random order, so that each message in the table is shown once before any message may repeat; and
	* ordered, listing the messages in the same order they are defined in the table.

Section: The Running Types

The running types are
	* run once (with once as a synonym), the messages of the table will show up only once; and
	* run forever (with forever as a synonym), the messages will loop once the table has been used, and if the scenic type is random, again in a random order (making sure the same message does not appear twice in a row).

Section: The Further Types

The further types are
	* default, which changes to the Table of Default Messages once all the messages in the current table have been exhausted; and
	* stopping, which stops the current table once it has been exhausted and doesn't bring in a new source of messages.

Section: The Ignoring Types

The ignoring types are
	* ignore, which
		1) In the Atmospheric Definition table on things tells the extension to ignore rooms and regions (note that at the moment this means that even if the thing has ran out of messages, it forces the room and regions to be quiet whenever it is present);
		2) In the Atmospheric Definition table on rooms tells the extension to ignore regions;
		3) In the Atmospheric Definition table on regions tells the extension to ignore larger regions; and
		4) In the subtables of the Atmospheric Definition table tells the extension to ignore all lines after the current line in case a message was shown.
	and
	* do not ignore, which is the opposite of ignore.

Section: How Types Interact

For entries with a scenic type of fully random, the running type and the further type are completely ignored, and for entries with a running type of run forever, the further type is completely ignored.

Chapter: The Tables Required

Section: The Table of Atmospheric Definition

To use scenic effects in our games, we need to define the following table:

	Table of Atmospheric Definition (continued)
	loci		ignoring		subtable
	an object	an ignoring type	a table-name

The loci entry contains the name of the room or region for which to use the subtable entry for messages, while the ignoring type tells the extension whether to ignore messages from larger entities containing the player.

Section: The Sub-Tables of the Table of Atmospheric Definition

In addition, for each separate subtable required, we need to define a table following the form of:

	Table of Example Atmospheric Definition
	during	initch		latch		aftcnt		curcnt		sctype		runtype		frtype		igtype		subtable
	a scene	a number	a number	a number	a number	a scenic type	a running type	a further type	an ignoring type		a table-name

Where the during entry is the name of the scene during which the messages from the subtable will be displayed (or empty for any time), initch is the initial chance of displaying messasges, latch is the later chance for displaying messages, aftcnt is the number of messages to show before changing from the initial chance to the later chance, curcnt is the current amount of messages shown, sctype is the scenic type of the messages to be shown, runtype the running type, frtype the further type, igtype the ignoring type and finally subtable contains the name of the table from which the messages will be picked.

If any of these entries except the during entry and the subtable entry are missing, they will be initialized automatically. The initial chance to 100 percent, the later chance to the initial chance, the after count to 0, the scenic type to random, the running type to run forever, the further type to stopping and the ignoring type to do not ignore. If the subtable is the Table of Default Messages, the running type is automatically set to run forever and the further type to stopping. The current count is always initialized to 0. If there is no subtable entry, the whole row is ignored.

Section: The Sub-Tables of the Sub-Tables of the Table of Atmospheric Definition

For each separate table of messages required, we also need to define a table according to the following specification:

	Table of Example Messages
	used		message
	a number	text

Section: The Table of Messages to Show

In addition, we may need to continue the Table of Messages to Show, in case there may be more than 20 messages to show at one time. This is done as follows:

	Table of Messages to Show (continued)
	message
	with <number> blank rows

Chapter: The Tables Defined

This extension provides a few tables of its own, each one empty except for one blank row to contrain the contents of the table. We have already encountered one of these, the Table of Atmospheric Definition, which is used to initialize the locations and regions of the game world with the correct scenic messasges.

The second one is the Table of Default Atmospherics. If we fill this table up with information, the messages of any subtables of it will be shown in any room or region not mentioned in the Table of Atmospheric Definition.

We are also provided with the Table of Default Messages, which can be filled with messages to be used when the further type of some messasge source is default and all the messages in the original table of messages have been shown.

Also, the extension brings us the Table of Messages to Show, which is used to collect the messages to be displayed during one turn. The default size of the table is 20 rows, which may be increased if necessary.

Chapter: Overriding

Section: How to Override this Extension's Default Behavior

If necessary, it is possible to override two of the rules provided by this extension. The first, called "the scenic messaging rule", allows for the modification of the message-generating process. The second, called "the scenic displaying rule", allows for the modification of the message-displaying process. If we wish to override one or both of these rules, it is possible with a procedural rule such as the following one:

	Procedural rule:
		substitute own messaging rule for the scenic messaging rule;
		substitute own displaying rule for the scenic displaying rule.

Section: How the Scenic Messaging Rule is Defined

The scenic messaging rule provided by the extension is defined as follows:

	A first every turn rule (this is the scenic messaging rule):
		correct synonyms;
		check thing messages;
		check room messages;
		check region messages.

Section: How the Scenic Displaying Rule is Defined

The scenic displaying rule provided by the extension is defined as follows:

	A last before reading a command rule (this is the scenic displaying rule):
		display all messages.

This rule has been defined as a before reading a command rule, so that the first messages will be shown before reading the first command in the game.

Chapter: Internals

The extension defines a kind of value called shown type used on regions. It is highly recommended that it not be used by anyone.

The extension also defines a region called the empty region. It is used by the extension to manage looking through regions.


Example: * Forest and Clearing - A simple example of regional and room effects, and ignoring messages.

	*: "Forest and Clearing"

	Include Version 6 of Atmospheric Effects by Mikael Segercrantz.

	Western Edge of the Forest is a room. East of the western edge of the forest is a room called A Forest Clearing. East of a forest clearing is a room called Eastern Edge of the Forest.

	The Forest Region is a region. Western edge of the forest, a forest clearing and eastern edge of the forest are in the forest region.

	Table of Atmospheric Definition (continued)
	loci			ignoring		subtable
	A Forest Clearing		ignore		Table of Clearing Definition
	Forest Region		do not ignore	Table of Forest Definition

	Table of Clearing Definition
	during		initch	latch		aftcnt		curcnt		sctype		runtype		frtype		igtype		subtable
	a scene		50	a number	a number	a number	fully random	a running type	a further type	an ignoring type	Table of Clearing Atmosphere

	Table of Clearing Atmosphere
	used		message
	a number	"The sound of a small river running nearby reaches your ear."
	--		"A cuckoo can be heard not far away." 

	Table of Forest Definition
	during		initch	latch	aftcnt	curcnt		sctype	runtype		frtype		igtype		subtable
	a scene		75	33	5	a number	random	a running type	a further type	an ignoring type	Table of Forest Region Atmosphere

	Table of Forest Region Atmosphere
	used		message
	a number	"A fox runs across the path."
	--		"Birds chirp off in the distance."
	--		"A rabbit bounces off with sudden haste."

Example: ** City and Neighborhood - A more complex example on using Atmospheric Effects on rooms and regions, with regions contained in other regions.

	*: "City and Neighborhood"

	Include Version 6 of Atmospheric Effects by Mikael Segercrantz.

	Tower Street North is a room. Tower Street South is a room. Tower Street Middle is a room.
	Tower Street North is north of Tower Street Middle.
	Tower Street Middle is north of Tower Street South.
	The Tower Neighborhood is a region. Tower Street North, Tower Street South and Tower Street Middle are in the Tower Neighborhood.

	Main Street West is a room. Main Street Middle is a room. Main Street East is a room.
	Main Street West is west of Main Street Middle.
	Main Street Middle is west of Main Street East.
	The Main Neighborhood is a region. Main Street West, Main Street East and Main Street Middle are in the Main Neighborhood.

	Madden Park is a room.
	Madden Park is east of Main Street East.
	Madden Park is west of Tower Street Middle.

	The City is a region. Madden Park, the Main Neighborhood and the Tower Neighborhood are in the City.

	The player is in Main Street West.

	Table of Atmospheric Definition (continued)
	loci			ignoring		subtable
	Madden Park		ignore		Table of Madden Park Definition
	Tower Neighborhood	ignore		Table of Tower Neighborhood Definition
	City			do not ignore	Table of City Definition

	Table of Madden Park Definition
	during	initch	latch	aftcnt		curcnt		sctype	runtype		frtype		igtype		subtable
	a scene	100	0	a number	a number	random	run forever	a further type	an ignoring type	Table of Park Sounds

	Table of Park Sounds
	used		message
	a number	"Birds chirp off in the trees."
	--		"The fountain unleashes a gush of water."
	--		"A man sitting atop a lawn-mover is taking care of the grass."

	Table of Tower Neighborhood Definition
	during	initch	latch	aftcnt		curcnt		sctype	runtype		frtype		igtype		subtable
	a scene	100	0	a number	a number	ordered	run forever	a further type	an ignoring type	Table of Tower Neighborhood Sounds

	Table of Tower Neighborhood Sounds
	used		message
	a number	"You hear nothing but the peace and quiet of the Tower Neighborhood."
	--		"Some small children run towards Madden Park."
	--		"The neighborhood is quiet, and peace prevails."
	--		"Some children enter the neighborhood from the park nearby."

	Table of City Definition
	during	initch	latch		aftcnt		curcnt		sctype		runtype		frtype		igtype		subtable
	a scene	75	a number	a number	a number	fully random	run forever	a further type	an ignoring type		Table of City Noise

	Table of City Noise
	used		message
	a number	"Many cars pass by, making for a loud noise level."
	--		"A car screeches to a halt as a pedestrian carelessly walks onto the street."
	--		"Sires can be heard in the distance, coming your way."

Example: **** The City-Plane of Union - Showing how to use the Atmospheric Effects extension using as a setting the City-Plane of Union from the Epic Level Handbook for the latest edition of AD&D.

	*: "The City-Plane of Union"

	Include Version 6 of Atmospheric Effects by Mikael Segercrantz.

	Use full-length room descriptions and the serial comma.

	Part 1 - Geography

	Chapter 1(a) - Planar Gate

	Planar Gate is a room.

	Planar Gate Region is a region. The planar gate is in the planar gate region.

	Chapter 1(b) - Temple Quarter

	Northwest Temple Quarter is a room. South of northwest temple quarter is a room called Southwest Temple Quarter. East of southwest temple quarter is a room called East Temple Quarter. It is southeast of northwest temple quarter.

	Temple Quarter Region is a region. Northwest temple quarter, southwest temple quarter and east temple quarter are in the temple quarter region.

	Chapter 1(c) - Material Gate

	Material Gate is a room.

	Material Gate Region is a region. The material gate is in the material gate region.

	Chapter 1(d) - Military Quarter

	South Military Quarter is a room. North of south military quarter is a room called North Military Quarter.

	Military Quarter Region is a region. North military quarter and south military quarter are in the military quarter region.

	Chapter 1(e) - High Quarter

	Southeast High Quarter is a room. Northwest of southeast high quarter is a room called Northwest High Quarter.

	High Quarter Region is a region. Southeast high quarter and northwest high quarter are in the high quarter region.

	Chapter 1(f) - Commerce Quarter

	Northwest Commerce Quarter is a room. South of northwest commerce quarter is a room called Southwest Commerce Quarter. East of northwest commerce quarter is a room called Northeast Commerce Quarter. It is northeast of southwest commerce quarter. South of northeast commerce quarter is a room called Southeast Commerce Quarter. It is east of southwest commerce quarter and southeast of northwest commerce quarter.

	Commerce Quarter Region is a region. Northwest commerce quarter, southwest commerce quarter, northeast commerce quarter and southeast commerce quarter are in the commerce quarter region.

	Chapter 1(g) - Market Quarter

	Northwest Market Quarter is a room. South of northwest market quarter is a room called Southwest Market Quarter. East of southwest market quarter is a room called South Market Quarter. It is southeast of northwest market quarter. North of south market quarter is a room called North Market Quarter. It is northeast of southwest market quarter and east of northwest market quarter. East of north market quarter is a room called Northeast Market Quarter. It is northeast of south market quarter. South of northeast market quarter is a room called Central Southeast Market Quarter. It is southeast of north market quarter and east of south market quarter. East of central southeast market quarter is a room called Southeast Market Quarter. It is southeast of northeast market quarter.

	Market Quarter Region is a region. Northwest market quarter, southwest market quarter, north market quarter, south market quarter, northeast market quarter, central southeast market quarter and southeast market quarter are in the market quarter region.

	Chapter 1(h) - Magic Quarter

	West Magic Quarter is a room. East of west magic quarter is a room called East Magic Quarter.

	Magic Quarter Region is a region. West magic quarter and east magic quarter are in the magic quarter region.

	Chapter 1(i) - Perfumed Quarter

	Southwest Perfumed Quarter is a room. East of southwest perfumed quarter is a room called Southeast Perfumed Quarter. North of southwest perfumed quarter is a room called North Perfumed Quarter. It is northwest of southeast perfumed quarter.

	Perfumed Quarter Region is a region. Southwest perfumed quarter, southeast perfumed quarter and north perfumed quarter are in the perfumed quarter region.

	Chapter 1(j) - Tavern Quarter

	East Tavern Quarter is a room. West of east tavern quarter is a room called West Tavern Quarter.

	Tavern Quarter Region is a region. East tavern quarter and west tavern quarter are in the tavern quarter region.

	Chapter 1(k) - Guild Quarter

	Southeast Guild Quarter is a room. Northwest of southeast guild quarter is a room called Northwest Guild Quarter.

	Guild Quarter Region is a region. Southeast guild quarter and northwest guild quarter are in the guild quarter region.

	Chapter 1(l) - Staircase Gate

	Staircase Gate is a room.

	Staircase Gate region is a region. Staircase gate is in the staircase gate region.

	Chapter 1(m) - Bridges

	Planar-Temple Bridge is a room. It is south of planar gate and north of northwest temple quarter.

	Planar-Material Bridge is a room. It is north of planar gate and south of material gate.

	Planar-Commerce Bridge is a room. It is northeast of planar gate and southwest of southwest commerce quarter.

	Temple-Market Bridge is a room. It is northeast of east temple quarter and southwest of southwest market quarter.

	Material-Military Bridge is a room. It is north of material gate and south of south military quarter.

	Material-Commerce Bridge is a room. It is east of material gate and west of southwest commerce quarter.

	Military-High Bridge is a room. It is northwest of north military quarter and southeast of southeast high quarter.

	Military-Commerce Bridge is a room. It is southeast of south military quarter and northwest of northwest commerce quarter.

	Commerce-Market Bridge is a room. It is south of southeast commerce quarter and north of northwest market quarter.

	Market-Magic Bridge is a room. It is north of northeast market quarter and south of west magic quarter.

	Commerce-Magic Bridge is a room. It is southeast of northeast commerce quarter and northwest of west magic quarter.

	Magic-Perfumed Bridge is a room. It is northeast of east magic quarter and southwest of southwest perfumed quarter.

	Magic-Staircase Bridge is a room. It is north of east magic quarter and south of staircase gate.

	Commerce-Guild Bridge is a room. It is north of northeast commerce quarter and south of southeast guild quarter.

	Guild-Tavern Bridge is a room. It is northeast of southeast guild quarter and southwest of west tavern quarter.

	Tavern-Staircase Bridge is a room. It is southeast of west tavern quarter and northwest of staircase gate.

	Tavern-Perfumed-Staircase Bridge is a room. It is east of east tavern quarter, north of staircase gate and west of north perfumed quarter.

	Chapter 1(n) - The City-Plane

	City-Plane of Union is a region. Planar-temple bridge, planar-commerce bridge, planar-material bridge, temple-market bridge, material-military bridge, material-commerce bridge, military-high bridge, military-commerce bridge, commerce-market bridge, market-magic bridge, commerce-magic bridge, magic-perfumed bridge, magic-staircase bridge, commerce-guild bridge, guild-tavern bridge, tavern-staircase bridge, tavern-perfumed-staircase bridge, planar gate region, material gate region, military quarter region, high quarter region, temple quarter region, commerce quarter region, market quarter region, magic quarter region, perfumed quarter region, tavern quarter region, guild quarter region and staircase gate region are in the city-plane of union.

	Chapter 1(o) - Objects

	A gushing fountain is in southwest commerce quarter. It is fixed in place.

	Part 2 - Atmospherics

	Chapter 2(a) - Full City-Plane

	Table of City-Plane of Union Definition
	during		initch	latch	aftcnt	curcnt	sctype		runtype		frtype		igtype		subtable
	Arrival		100	33	1	0	ordered		run once	stopping		do not ignore	Table of Arrival Messages
	Encounters	50	50	0	0	random		run forever	stopping		do not ignore	Table of Encounter Messages

	Table of Arrival Messages
	used	message
	0	"The sudden bustling of activity as you enter the City-Plane of Union almost overwhelmes you."
	0	"You are slowly, ever so slowly, getting used to the bustling of activities ."
	0	"The bustling activities continue as usual, but you are getting more and more acclimatized to them."
	0	"Suddenly, you realize you no longer notice anything unusal about all the activities going on around you."

	Table of Encounter Messages
	used	message
	0	"A patrol of Union City guards stop to question people."
	0	"In the distance, you can see a patrol of guards coming closer to you."
	0	"You are stopped by a patrol of Union City guards and asked for your papers. You show the papers to them."
	0	"A mercane is looking at you, squinting [if a random chance of 1 in 2 succeeds]his[otherwise]her[end if] eyes."

	Chapter 2(b) - Specific things

	Table of Gushing Fountain Definition
	during	initch	latch	aftcnt	curcnt	sctype		runtype			frtype		igtype		subtable
	--	100	100	0	0	random		run forever		stopping		do not ignore	Table of Gushing Fountain Messages

	Table of Gushing Fountain Messages
	used	message
	0	"The fountain unleases a gush of water, at least 20 feet high."
	0	"You hear a gurgling sound from the fountain, as it sucks in water from the pool."
	0	"A glimmer of gold catches your eye, deep in the pool of the fountain."
	0	"The constant stream of water from the fountain flies about the area as a gust of wind arrives."

	Chapter 2(c) - The Stairway Gate

	Table of Stairway Gate Definition
	during	initch	latch	aftcnt	curcnt	sctype		runtype			frtype		igtype		subtable
	--	100	50	2	0	random		run forever		stopping		do not ignore	Table of Stairway Gate Messages

	Table of Stairway Gate Messages
	used	message
	0	"People come in and leave through the Stairway Gate to the Infinite Stairway."
	0	"The bustling of people travelling through the Stairway Gate is awe-inspring."

	Chapter 2(d) - Definition

	Table of Atmospheric Definition (continued)
	loci				ignoring			subtable
	City-Plane of Union		do not ignore		Table of City-Plane of Union Definition
	gushing fountain			do not ignore		Table of Gushing Fountain Definition
	Staircase Gate			do not ignore		Table of Stairway Gate Definition

	Part 3 - Scenes

	Chapter 3(a) - Arrival

	Arrival is a scene. Arrival begins when play begins. Arrival ends when the number of filled rows in the Table of Arrival Messages is 0.

	Chapter 3(b) - Encounters

	Encounters is a scene. Encounters begins when Arrival ends.

	Part 4 - Modifications

	Chapter 4(a) - Room

	The description of a room is usually "[exit list]".

	To say exit list:
		let count be 0;
		repeat with d running through directions:
			let r be the room d from the location;
			if r is a room, increase count by 1;
		if the count is 0:
			say "You appear to be trapped in here.";
		otherwise:
			if the count is 1:
				say "From here, the only way is";
			otherwise:
				say "From here, the viable exits are";
			let original be count;
			repeat with d running through directions:
				let r be the room d from the location;
				if r is a room:
					say " [d] to [r]";
					decrease count by 1;
					if count is 1:
						if original is 2, say " and";
						otherwise say "[optional comma] and";
					otherwise:
						if count is 0, say ".";
						otherwise say ",".

	To say optional comma:
		if the serial comma option is active, say ",".

	Chapter 4(b) - Status line

	When play begins:
		now the left hand status line is "[map region of the location]";
		now the right hand status line is "[number of visited rooms]/[number of rooms]".

	Part 5 - Starting and ending the game

	Chapter 5(a) - Starting

	When play begins:
		say "What happenstance.

	You have been trying to reach this place for the last few years, and suddenly, you find yourself here. 	In... The City-Plane of Union.

	Now, you want to find out everything there is to know about the place. Thankfully, you've memorized the map of the place.[line break](To win, visit every room and see every message)[paragraph break]".

	Chapter 5(b) - Ending

	Every turn:
		let total be 0;
		repeat with n running from 1 to the number of rows in the Table of Atmospheric Definition:
			choose row n in the table of Atmospheric Definition;
			if there is a subtable entry:
				let tbl be the subtable entry;
				repeat with o running from 1 to the number of rows in tbl:
					choose row o in tbl;
					if there is a subtable entry:
						if the sctype entry is ordered or the sctype entry is random:
							let c be the curcnt entry;
							let d be the number of filled rows in the subtable entry;
							let f be d minus c;
							if f is less than 0, now f is 0;
							increase total by f;
						otherwise:
							let lbt be the subtable entry;
							repeat with p running from 1 to the number of rows in lbt:
								if there is a message entry:
									if the used entry is 0, increase total by 1;
		increase total by the number of rooms;
		decrease total by the number of visited rooms;
		if total is 0, end the story saying "You have visited all rooms and seen all messages".
