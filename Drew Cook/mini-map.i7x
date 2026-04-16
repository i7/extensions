Version 1.0 of Mini-Map by Drew Cook begins here.

"Prints a mini-map of the player's current location, with the player at the map's center. Since this is integrated with mathbrush's 'Bisquixe' interpreter, various rooms are displayed as hyperlinks. Other than including the needed extensions and interpreter, this should work automatically. As rooms are added to the project, the mini-map should display the relevant information.

This has only been tested with Inform 10. It should work fine, though some tweaks might be required.

Requires Simple Multimedia Effects or Simple Multimedia Effects for v10, both by mathbrush."

include basic screen effects by emily short.

book 1 (prelude)

chapter 1 (frequently used text substitutions) 

to say lb:
	say line break;

to say pb:
	say paragraph break;

to say fls:
	say fixed letter spacing;

to say rt:
	say roman type;
	
to say bt:
	say bold type;

chapter 2 (some basic logic and setup)

[this language comes from Emily Short's Basic Screen Effects. Note that, out of the gate, the extension does nothing with the other elements of the status line. So ideally you might copy/paste the table of your choice (left-, center-, or right-aligned) and set it to be the "chosen table." As in,

	the chosen table is map_table
	
if you have, for instance, called your copy "map_table".

the default is the table of center-aligned status.]

rule for constructing the status line:
	fill status bar with the chosen table;
	rule succeeds;
	
the chosen table is a table name that varies.
the chosen table is usually the table of center-aligned status.

[these tables are hard to read! be careful experimenting with them.

if you need to add to the other columns, you can copy the table to your own project and edit it there. CF

https://zedlopez.github.io/i7doc/WI_27.html#section_9

Inform 10.1 Documentation 27.9]

book 3 (the tables)
	
chapter 1 (table of left-aligned status)
	
table of left-aligned status
left	central	right
"[northwest by northwest] [north by northwest] [northeast by northwest][northwest by north] [north by north] [northeast by north][northwest by northeast] [north by northeast] [northeast by northeast]"	""	""
[]
"[west by northwest][NW room][east by northwest][west by north][N room][east by north][west by northeast][NE room][east by northeast]"	""	""
[]
"[southwest by northwest] [south by northwest] [southeast by northwest][southwest by north] [south by north] [southeast by north][southwest by northeast] [south by northeast] [southeast by northeast]"	""	""
[]
"[northwest by west] [north by west] [northeast by west][northwest by central] [north by central] [northeast by central][northwest by east] [north by east] [northeast by east]"	""	""
[]
"[west by west][west room][east by west][west by central](@)[east by central][west by east][east room][east by east]"	""	""
[]
"[southwest by west] [south by west] [southeast by west][southwest by central] [south by central] [southeast by central][southwest by east] [south by east] [southeast by east]"	""	""
[]
"[northwest by southwest] [north by southwest] [northeast by southwest][northwest by south] [north by south] [northeast by south][northwest by southeast] [north by southeast] [northeast by southeast]"	""	""
[]
"[west by southwest][southwest room][east by southwest][west by south][S room][east by south][west by southeast][SE room][east by southeast]"	""	""
[]
"[southwest by southwest] [south by southwest] [southeast by southwest][southwest by south] [south by south] [southeast by south][southwest by southeast] [south by southeast] [southeast by southeast]"	""	""

chapter 2 (table of center-aligned status)

table of center-aligned status
left	central	right
""	"[bt][northwest by northwest] [north by northwest] [northeast by northwest][northwest by north] [north by north] [northeast by north][northwest by northeast] [north by northeast] [northeast by northeast]"	"scores"
[]
""	"[bt][west by northwest][NW room][east by northwest][west by north][N room][east by north][west by northeast][NE room][east by northeast]"	""
[]
""	"[bt][southwest by northwest] [south by northwest] [southeast by northwest][southwest by north] [south by north] [southeast by north][southwest by northeast] [south by northeast] [southeast by northeast]"	""
[]
""	"[bt][northwest by west] [north by west] [northeast by west][northwest by central] [north by central] [northeast by central][northwest by east] [north by east] [northeast by east]"	""
[]
""	"[bt][west by west][west room][east by west][west by central](@)[east by central][west by east][east room][east by east]"	""
[]
""	"[bt][southwest by west] [south by west] [southeast by west][southwest by central] [south by central] [southeast by central][southwest by east] [south by east] [southeast by east]"	""
[]
""	"[bt][northwest by southwest] [north by southwest] [northeast by southwest][northwest by south] [north by south] [northeast by south][northwest by southeast] [north by southeast] [northeast by southeast]"	""
[]
""	"[bt][west by southwest][southwest room][east by southwest][west by south][S room][east by south][west by southeast][SE room][east by southeast]"	""
[]
""	"[bt][southwest by southwest] [south by southwest] [southeast by southwest][southwest by south] [south by south] [southeast by south][southwest by southeast] [south by southeast] [southeast by southeast]"	""

chapter 3 (table of right-aligned status)

table of right-aligned status
left	central	right
"[The Location]"	""	"[northwest by northwest] [north by northwest] [northeast by northwest][northwest by north] [north by north] [northeast by north][northwest by northeast] [north by northeast] [northeast by northeast]"
[]
""	""	"[west by northwest][NW room][east by northwest][west by north][N room][east by north][west by northeast][NE room][east by northeast]"
[]
""	""	"[southwest by northwest] [south by northwest] [southeast by northwest][southwest by north] [south by north] [southeast by north][southwest by northeast] [south by northeast] [southeast by northeast]"
[]
""	""	"[northwest by west] [north by west] [northeast by west][northwest by central] [north by central] [northeast by central][northwest by east] [north by east] [northeast by east]"
[]
""	""	"[west by west][west room][east by west][west by central](@)[east by central][west by east][east room][east by east]"
[]
""	""	"[southwest by west] [south by west] [southeast by west][southwest by central] [south by central] [southeast by central][southwest by east] [south by east] [southeast by east]"
[]
""	""	"[northwest by southwest] [north by southwest] [northeast by southwest][northwest by south] [north by south] [northeast by south][northwest by southeast] [north by southeast] [northeast by southeast]"
[]
""	"[west by southwest][southwest room][east by southwest][west by south][S room][east by south][west by southeast][SE room][east by southeast]"	""
[]
""	""	"[southwest by southwest] [south by southwest] [southeast by southwest][southwest by south] [south by south] [southeast by south][southwest by southeast] [south by southeast] [southeast by southeast]"

[what follows are a series of "to say" constructions for each room and connector. if you have nonstandard geography, ie, non-reciprocating exits or a map that doesn't conform to a grid, you may have to add your own special conditions to these definitions. The map is broken up into chapters for this reason.]

book 4 (geography)

chapter 1 (the northwest sector)

to say NW room:
	let W be the room west of the location;
	let N be the room north of the location;
	let T be the location;
	if W is a room and the room north of W is a room:
		now T is the room north of W;
	otherwise if N is a room and the room west of N is a room:
		now T is the room west of N;
	otherwise if the room northwest of the location is a room:
		now T is the room northwest of the location;
	[new]
	if the number of moves from the location to T is one and T is not the location:
		let way be the best route from the location to T;
		hyperlink "([if t is visited]O[otherwise]?[end if])" as "[way]";
	[end new]
	otherwise IF T is not the location and T is visited:
		say "( )";
	otherwise:
		say "   ";
		


to say northwest by northwest:
	let T be the location;
	let nw be the room northwest of the location;
	let w be the room west of the location;
	let n be the room north of the location;
	if nw is a room and the room northwest of nw is a room and nw is visited:
		say "\";
		rule succeeds;
	otherwise if the room north of w is a room:
		now t is the room north of w;
	otherwise if the room west of n is a room:
		now t is the room west of n;
	if t is a room and t is visited and the room northwest of t is a room and t is not the location:
		say "\";
	otherwise:
		say " ";
			
		
to say north by northwest:
	let T be the location;
	let nw be the room northwest of the location;
	let w be the room west of the location;
	let n be the room north of the location;
	if nw is a room and the room north of nw is a room and nw is visited:
		say "|";
		rule succeeds;
	otherwise if the room north of w is a room:
		now t is the room north of w;
	otherwise if the room west of n is a room:
		now t is the room west of n;
	if t is a room and t is visited and the room north of t is a room and t is not the location:
		say "|";
	otherwise:
		say " ";

to say northeast by northwest:
	let T be the location;
	let nw be the room northwest of the location;
	let w be the room west of the location;
	let n be the room north of the location;
	if nw is a room and the room northeast of nw is a room and nw is visited:
		say "/";
		rule succeeds;
	otherwise if the room north of w is a room:
		now t is the room north of w;
	otherwise if the room west of n is a room:
		now t is the room west of n;
	if t is a room and t is visited and the room northeast of t is a room and t is not the location:
		say "/";
	otherwise:
		say " ";
		


to say east by northwest:
	let T be the location;
	let nw be the room northwest of the location;
	let w be the room west of the location;
	let n be the room north of the location;
	if nw is a room and the room east of nw is a room and nw is visited:
		say "-";
		rule succeeds;
	otherwise if the room north of w is a room:
		now t is the room north of w;
	otherwise if the room west of n is a room:
		now t is the room west of n;
	if t is a room and t is visited and the room east of t is a room and t is not the location:
		say "-";
	otherwise:
		say " ";
		
to say southeast by northwest:
	let T be the location;
	let nw be the room northwest of the location;
	let w be the room west of the location;
	let n be the room north of the location;
	if nw is a room and the room southeast of nw is a room and nw is visited:
		say "\";
		rule succeeds;
	otherwise if the room north of w is a room:
		now t is the room north of w;
	otherwise if the room west of n is a room:
		now t is the room west of n;
	if t is a room and t is visited and the room southeast of t is a room and t is not the location:
		say "\";
	otherwise:
		say " ";
				
to say south by northwest:
	let T be the location;
	let nw be the room northwest of the location;
	let w be the room west of the location;
	let n be the room north of the location;
	if nw is a room and the room south of nw is a room and nw is visited:
		say "|";
		rule succeeds;
	otherwise if the room north of w is a room:
		now t is the room north of w;
	otherwise if the room west of n is a room:
		now t is the room west of n;
	if t is a room and t is visited and the room south of t is a room and t is not the location:
		say "|";
	otherwise:
		say " ";
		
to say southwest by northwest:
	let T be the location;
	let nw be the room northwest of the location;
	let w be the room west of the location;
	let n be the room north of the location;
	if nw is a room and the room southwest of nw is a room and nw is visited:
		say "/";
		rule succeeds;
	otherwise if the room north of w is a room:
		now t is the room north of w;
	otherwise if the room west of n is a room:
		now t is the room west of n;
	if t is a room and t is visited and the room southwest of t is a room and t is not the location:
		say "/";
	otherwise:
		say " ";
		
to say west by northwest:
	let T be the location;
	let nw be the room northwest of the location;
	let w be the room west of the location;
	let n be the room north of the location;
	if nw is a room and the room west of nw is a room and nw is visited:
		say "-";
		rule succeeds;
	otherwise if the room north of w is a room:
		now t is the room north of w;
	otherwise if the room west of n is a room:
		now t is the room west of n;
	if t is a room and t is visited and the room west of t is a room and t is not the location:
		say "-";
	otherwise:
		say " ";
				
chapter 2 (the north central sector)

to say N room:
	let T be the location;
	let ne be the room northeast of the location;
	let nw be the room northwest of the location;
	let w be the room west of the location;
	let es be the room east of the location;
	let n be the room north of the location;
	if n is a room and n is north of the location:
		now t is n;
	otherwise if the room west of ne is a room:
		now t is the room west of ne;
	otherwise if the room east of ne is a room:
		now t is the room east of ne;
	otherwise if the room northeast of w is a room:
		now t is the room northeast of w;
	otherwise if the room northwest of es is a room:
		now t is the room northwest of es;
	[new]
	if the number of moves from the location to T is one and T is not the location:
		let way be the best route from the location to T;
		hyperlink "([if t is visited]O[otherwise]?[end if])" as "[way]";
	[end new];
	otherwise if t is a room and t is visited and t is not the location:
		say "( )";
	[end new]
	otherwise:
		say "   ";
	

			
to say northwest by north:
	let T be the location;
	let ne be the room northeast of the location;
	let nw be the room northwest of the location;
	let w be the room west of the location;
	let es be the room east of the location;
	let n be the room north of the location;
	if n is a room and n is north of the location:
		now t is n;
	otherwise if the room west of ne is a room:
		now t is the room west of ne;
	otherwise if the room east of ne is a room:
		now t is the room east of ne;
	otherwise if the room northeast of w is a room:
		now t is the room northeast of w;
	otherwise if the room northwest of es is a room:
		now t is the room northwest of es;
	if t is a room and t is visited and t is not the location and the room northwest of t is a room:
		say "\";
	otherwise:
		say " ";
	
to say north by north:
	let T be the location;
	let ne be the room northeast of the location;
	let nw be the room northwest of the location;
	let w be the room west of the location;
	let es be the room east of the location;
	let n be the room north of the location;
	if n is a room and n is north of the location:
		now t is n;
	otherwise if the room west of ne is a room:
		now t is the room west of ne;
	otherwise if the room east of ne is a room:
		now t is the room east of ne;
	otherwise if the room northeast of w is a room:
		now t is the room northeast of w;
	otherwise if the room northwest of es is a room:
		now t is the room northwest of es;
	if t is a room and t is visited and t is not the location and the room north of t is a room:
		say "|";
	otherwise:
		say " ";
	
to say northeast by north:
	let T be the location;
	let ne be the room northeast of the location;
	let nw be the room northwest of the location;
	let w be the room west of the location;
	let es be the room east of the location;
	let n be the room north of the location;
	if n is a room and n is north of the location:
		now t is n;
	otherwise if the room west of ne is a room:
		now t is the room west of ne;
	otherwise if the room east of ne is a room:
		now t is the room east of ne;
	otherwise if the room northeast of w is a room:
		now t is the room northeast of w;
	otherwise if the room northwest of es is a room:
		now t is the room northwest of es;
	if t is a room and t is visited and t is not the location and the room northeast of t is a room:
		say "/";
	otherwise:
		say " ";
	
to say east by north:
	let T be the location;
	let ne be the room northeast of the location;
	let nw be the room northwest of the location;
	let w be the room west of the location;
	let es be the room east of the location;
	let n be the room north of the location;
	if n is a room and n is north of the location:
		now t is n;
	otherwise if the room west of ne is a room:
		now t is the room west of ne;
	otherwise if the room east of ne is a room:
		now t is the room east of ne;
	otherwise if the room northeast of w is a room:
		now t is the room northeast of w;
	otherwise if the room northwest of es is a room:
		now t is the room northwest of es;
	if t is a room and t is visited and t is not the location and the room east of t is a room:
		say "-";
	otherwise:
		say " ";
	
to say southeast by north:
	let T be the location;
	let ne be the room northeast of the location;
	let nw be the room northwest of the location;
	let w be the room west of the location;
	let es be the room east of the location;
	let n be the room north of the location;
	if n is a room and n is north of the location:
		now t is n;
	otherwise if the room west of ne is a room:
		now t is the room west of ne;
	otherwise if the room east of ne is a room:
		now t is the room east of ne;
	otherwise if the room northeast of w is a room:
		now t is the room northeast of w;
	otherwise if the room northwest of es is a room:
		now t is the room northwest of es;
	if t is a room and t is visited and t is not the location and the room southeast of t is a room:
		say "\";
	otherwise:
		say " ";
	
to say south by north:
	let T be the location;
	let ne be the room northeast of the location;
	let nw be the room northwest of the location;
	let w be the room west of the location;
	let es be the room east of the location;
	let n be the room north of the location;
	if n is a room and n is north of the location:
		now t is n;
	otherwise if the room west of ne is a room:
		now t is the room west of ne;
	otherwise if the room east of ne is a room:
		now t is the room east of ne;
	otherwise if the room northeast of w is a room:
		now t is the room northeast of w;
	otherwise if the room northwest of es is a room:
		now t is the room northwest of es;
	if t is a room and t is visited and t is not the location and the room south of t is a room:
		say "|";
	otherwise:
		say " ";
	
to say southwest by north:
	let T be the location;
	let ne be the room northeast of the location;
	let nw be the room northwest of the location;
	let w be the room west of the location;
	let es be the room east of the location;
	let n be the room north of the location;
	if n is a room and n is north of the location:
		now t is n;
	otherwise if the room west of ne is a room:
		now t is the room west of ne;
	otherwise if the room east of nw is a room:
		now t is the room east of nw;
	otherwise if the room northeast of w is a room:
		now t is the room northeast of w;
	otherwise if the room northwest of es is a room:
		now t is the room northwest of es;
	if t is a room and t is visited and t is not the location and the room southwest of t is a room:
		say "/";
	otherwise:
		say " ";
	
to say west by north:
	let T be the location;
	let ne be the room northeast of the location;
	let nw be the room northwest of the location;
	let w be the room west of the location;
	let es be the room east of the location;
	let n be the room north of the location;
	if n is a room and n is north of the location:
		now t is n;
	otherwise if the room west of ne is a room:
		now t is the room west of ne;
	otherwise if the room east of ne is a room:
		now t is the room east of ne;
	otherwise if the room northeast of w is a room:
		now t is the room northeast of w;
	otherwise if the room northwest of es is a room:
		now t is the room northwest of es;
	if t is a room and t is visited and t is not the location and the room west of t is a room:
		say "-";
	otherwise:
		say " ";
	
chapter 3 (the northeast sector)

to say NE room:
	let E be the room east of the location;
	let N be the room north of the location;
	let T be the location;
	if E is a room and the room north of E is a room:
		now T is the room north of E;
	otherwise if N is a room and the room east of N is a room:
		now T is the room east of N;
	otherwise if the room northeast of the location is a room:
		now T is the room northeast of the location;
	[new]
	if the number of moves from the location to T is one and T is not the location:
		let way be the best route from the location to T;
		hyperlink "([if t is visited]O[otherwise]?[end if])" as "[way]";
	[end new]
	otherwise IF T is not the location and T is visited:
		say "( )";
	otherwise:
		say "   ";

to say northwest by northeast:
	let T be the location;
	let ne be the room northeast of the location;
	let es be the room east of the location;
	let n be the room north of the location;
	if ne is a room and ne is visited:
		now t is ne;
	otherwise if the room north of es is a room:
		now t is the room north of es;
	otherwise if the room east of n is a room:
		now t is the room east of n;
	if t is a room and t is visited and the room northwest of t is a room and t is not the location:
		say "\";
	otherwise:
		say " ";
	
to say north by northeast:
	let T be the location;
	let ne be the room northeast of the location;
	let es be the room east of the location;
	let n be the room north of the location;
	if ne is a room and ne is visited:
		now t is ne;
	otherwise if the room north of es is a room:
		now t is the room north of es;
	otherwise if the room east of n is a room:
		now t is the room east of n;
	if t is a room and t is visited and the room north of t is a room and t is not the location:
		say "|";
	otherwise:
		say " ";
	
to say northeast by northeast:
	let T be the location;
	let ne be the room northeast of the location;
	let es be the room east of the location;
	let n be the room north of the location;
	if ne is a room and ne is visited:
		now t is ne;
	otherwise if the room north of es is a room:
		now t is the room north of es;
	otherwise if the room east of n is a room:
		now t is the room east of n;
	if t is a room and t is visited and the room northeast of t is a room and t is not the location:
		say "/";
	otherwise:
		say " ";
	
to say east by northeast:
	let T be the location;
	let ne be the room northeast of the location;
	let es be the room east of the location;
	let n be the room north of the location;
	if ne is a room and ne is visited:
		now t is ne;
	otherwise if the room north of es is a room:
		now t is the room north of es;
	otherwise if the room east of n is a room:
		now t is the room east of n;
	if t is a room and t is visited and the room east of t is a room and t is not the location:
		say "-";
	otherwise:
		say " ";
	
to say southeast by northeast:
	let T be the location;
	let ne be the room northeast of the location;
	let es be the room east of the location;
	let n be the room north of the location;
	if ne is a room and ne is visited:
		now t is ne;
	otherwise if the room north of es is a room:
		now t is the room north of es;
	otherwise if the room east of n is a room:
		now t is the room east of n;;
	if t is a room and t is visited and the room southeast of t is a room and t is not the location:
		say "\";
	otherwise:
		say " ";
	
to say south by northeast:
	let T be the location;
	let ne be the room northeast of the location;
	let es be the room east of the location;
	let n be the room north of the location;
	if ne is a room and ne is visited:
		now t is ne;
	otherwise if the room north of es is a room:
		now t is the room north of es;
	otherwise if the room east of n is a room:
		now t is the room east of n;
	if t is a room and t is visited and the room south of t is a room and t is not the location:
		say "|";
	otherwise:
		say " ";
	
to say southwest by northeast:
	let T be the location;
	let ne be the room northeast of the location;
	let es be the room east of the location;
	let n be the room north of the location;
	if ne is a room and ne is visited:
		now t is ne;
	otherwise if the room north of es is a room:
		now t is the room north of es;
	otherwise if the room east of n is a room:
		now t is the room east of n;
	if t is a room and t is visited and the room southwest of t is a room and t is not the location:
		say "/";
	otherwise:
		say " ";
	
to say west by northeast:
	let T be the location;
	let ne be the room northeast of the location;
	let es be the room east of the location;
	let n be the room north of the location;
	if ne is a room and ne is visited:
		now t is ne;
	otherwise if the room north of es is a room:
		now t is the room north of es;
	otherwise if the room east of n is a room:
		now t is the room east of n;
	if t is a room and t is visited and the room west of t is a room and t is not the location:
		say "-";
	otherwise:
		say " ";
	
chapter 4 (the central west sector)

to say west room:
	let NW be the room northwest of the location;
	let W be the room west of the location;
	let SW be the room southwest of the location;
	let n be the room north of the location;
	let s be the room south of the location;
	let T be the location;
	if W is a room:
		now T is W;
	otherwise if the room north of sw is a room:
		now t is the room north of sw;
	otherwise if the room south of nw is a room:
		now t is the room south of nw;
	otherwise if the room southwest of n is a room:
		now t is the room southwest of n;
	otherwise if the room northwest of s is a room:
		now t is the room northwest of s;
	[new]
	if the number of moves from the location to T is one and T is not the location:
		let way be the best route from the location to T;
		hyperlink "([if t is visited]O[otherwise]?[end if])" as "[way]";
	[end new]
	otherwise if t is not the location and t is visited:
		say "( )";
	otherwise:
		say "   ";
	

to say northwest by west:
	let NW be the room northwest of the location;
	let W be the room west of the location;
	let SW be the room southwest of the location;
	let n be the room north of the location;
	let s be the room south of the location;
	let T be the location;
	if W is a room:
		now T is W;
	otherwise if the room north of sw is a room:
		now t is the room north of sw;
	otherwise if the room south of nw is a room:
		now t is the room south of nw;
	otherwise if the room southwest of n is a room:
		now t is the room southwest of n;
	otherwise if the room northwest of s is a room:
		now t is the room northwest of s;
	if t is not the location and t is visited and the room northwest of t is a room:
		say "\";
	otherwise:
		say " ";
	
to say north by west:
	let NW be the room northwest of the location;
	let W be the room west of the location;
	let SW be the room southwest of the location;
	let n be the room north of the location;
	let s be the room south of the location;
	let T be the location;
	if W is a room:
		now T is W;
	otherwise if the room north of sw is a room:
		now t is the room north of sw;
	otherwise if the room south of nw is a room:
		now t is the room south of nw;
	otherwise if the room southwest of n is a room:
		now t is the room southwest of n;
	otherwise if the room northwest of s is a room:
		now t is the room northwest of s;
	if t is not the location and t is visited and the room north of t is a room:
		say "|";
	otherwise:
		say " ";
	
to say northeast by west:
	let NW be the room northwest of the location;
	let W be the room west of the location;
	let SW be the room southwest of the location;
	let n be the room north of the location;
	let s be the room south of the location;
	let T be the location;
	if W is a room:
		now T is W;
	otherwise if the room north of sw is a room:
		now t is the room north of sw;
	otherwise if the room south of nw is a room:
		now t is the room south of nw;
	otherwise if the room southwest of n is a room:
		now t is the room southwest of n;
	otherwise if the room northwest of s is a room:
		now t is the room northwest of s;
	if t is not the location and t is visited and the room northeast of t is a room:
		say "/";
	otherwise:
		say " ";
	
to say east by west:
	let NW be the room northwest of the location;
	let W be the room west of the location;
	let SW be the room southwest of the location;
	let n be the room north of the location;
	let s be the room south of the location;
	let T be the location;
	if W is a room:
		now T is W;
	otherwise if the room north of sw is a room:
		now t is the room north of sw;
	otherwise if the room south of nw is a room:
		now t is the room south of nw;
	otherwise if the room southwest of n is a room:
		now t is the room southwest of n;
	otherwise if the room northwest of s is a room:
		now t is the room northwest of s;
	if t is not the location and t is visited and the room east of t is a room:
		say "-";
	otherwise:
		say " ";
	
to say southeast by west:
	let NW be the room northwest of the location;
	let W be the room west of the location;
	let SW be the room southwest of the location;
	let n be the room north of the location;
	let s be the room south of the location;
	let T be the location;
	if W is a room:
		now T is W;
	otherwise if the room north of sw is a room:
		now t is the room north of sw;
	otherwise if the room south of nw is a room:
		now t is the room south of nw;
	otherwise if the room southwest of n is a room:
		now t is the room southwest of n;
	otherwise if the room northwest of s is a room:
		now t is the room northwest of s;
	if t is not the location and t is visited and the room southeast of t is a room:
		say "\";
	otherwise:
		say " ";
		
	
to say south by west:
	let NW be the room northwest of the location;
	let W be the room west of the location;
	let SW be the room southwest of the location;
	let n be the room north of the location;
	let s be the room south of the location;
	let T be the location;
	if W is a room:
		now T is W;
	otherwise if the room north of sw is a room:
		now t is the room north of sw;
	otherwise if the room south of nw is a room:
		now t is the room south of nw;
	otherwise if the room southwest of n is a room:
		now t is the room southwest of n;
	otherwise if the room northwest of s is a room:
		now t is the room northwest of s;
	if t is not the location and t is visited and the room south of t is a room:
		say "|";
	otherwise:
		say " ";


to say southwest by west:
	let NW be the room northwest of the location;
	let W be the room west of the location;
	let SW be the room southwest of the location;
	let n be the room north of the location;
	let s be the room south of the location;
	let T be the location;
	if W is a room:
		now T is W;
	otherwise if the room north of sw is a room:
		now t is the room north of sw;
	otherwise if the room south of nw is a room:
		now t is the room south of nw;
	otherwise if the room southwest of n is a room:
		now t is the room southwest of n;
	otherwise if the room northwest of s is a room:
		now t is the room northwest of s;
	if t is not the location and t is visited and the room southwest of t is a room:
		say "/";
	otherwise:
		say " ";


	
to say west by west:
	let NW be the room northwest of the location;
	let W be the room west of the location;
	let SW be the room southwest of the location;
	let n be the room north of the location;
	let s be the room south of the location;
	let T be the location;
	if W is a room:
		now T is W;
	otherwise if the room north of sw is a room:
		now t is the room north of sw;
	otherwise if the room south of nw is a room:
		now t is the room south of nw;
	otherwise if the room southwest of n is a room:
		now t is the room southwest of n;
	otherwise if the room northwest of s is a room:
		now t is the room northwest of s;
	if t is not the location and t is visited and the room west of t is a room:
		say "-";
	otherwise:
		say " ";	
	
chapter 5 (central section)

to say northwest by central:
	let T be the location;
	if the room northwest of t is a room:
		say "\";
		rule succeeds;
	otherwise:
		say " ";	
	
to say north by central:
	let T be the location;
	if the room north of t is a room:
		say "|";
		rule succeeds;
	otherwise:
		say " ";	
	
to say northeast by central:
	let T be the location;
	if the room northeast of t is a room:
		say "/";
		rule succeeds;
	otherwise:
		say " ";	
	
to say east by central:
	let T be the location;
	if the room east of t is a room:
		say "-";
		rule succeeds;
	say " ";	
	
to say southeast by central:
	let T be the location;
	if the room southeast of t is a room:
		say "\";
		rule succeeds;
	otherwise:
		say " ";	
		
to say south by central:
	let sw be the room southwest of the location;
	let se be the room southeast of the location;
	let s be the room south of the location;
	if s is a room:
		say "|";
	otherwise:
		say " "
	
to say southwest by central:
	let T be the location;
	if the room southwest of t is a room:
		say "/";
		rule succeeds;
	otherwise:
		say " ";	
	
to say west by central:
	let T be the location;
	if the room west of t is a room:
		say "-";
		rule succeeds;
	otherwise:
		say " ";
	
chapter 6 (east central section)

to say east room:
	let E be the room East of the location;
	let NE be the room northeast of the location;
	let SE be the room southeast of the location;
	let N be the room north of the location;
	let S be the room south of the location;
	let T be the location;
	if the E is a room:
		now t is E;
	otherwise if SE is a room and the room north of SE is a room:
		now T is the room north of SE;
	otherwise if NE is a room and the room south of NE is a room:
		now T is the room south of NE;
	otherwise if N is a room and the room southeast of N is a room:
		now t is the room southeast of n;
	otherwise if S is a room and the room northeast of S is a room:
		now t is the room northeast of S;
	[new]
	if the number of moves from the location to T is one and T is not the location:
		let way be the best route from the location to T;
		hyperlink "([if t is visited]O[otherwise]?[end if])" as "[way]";
	[end new]
	otherwise if T is not the location and T is a room and T is visited:
		say "( )";
	otherwise:
		say "   ";


to say northwest by east:
	let T be the location;
	let ne be the room northeast of the location;
	let se be the room southeast of the location;
	let n be the room north of the location;
	let s be the room south of the location;
	let es be the room east of the location;
	if es is a room:
		now t is es;
	otherwise if the room south of ne is a room:
		now t is the room south of ne;
	otherwise if the room north of se is a room:
		now t is the room north of se;
	otherwise if the room southeast of n is a room:
		now t is the room southeast of n;
	otherwise if the room northeast of s is a room:
		now t is the room northeast of s;
	if t is a room and t is visited and the room northwest of t is a room and t is not the location:
		say "\";
	otherwise:
		say " ";
	
to say north by east:
	let T be the location;
	let ne be the room northeast of the location;
	let se be the room southeast of the location;
	let n be the room north of the location;
	let s be the room south of the location;
	let es be the room east of the location;
	if es is a room:
		now t is es;
	otherwise if the room south of ne is a room:
		now t is the room south of ne;
	otherwise if the room north of se is a room:
		now t is the room north of se;
	otherwise if the room southeast of n is a room:
		now t is the room southeast of n;
	otherwise if the room northeast of s is a room:
		now t is the room northeast of s;
	if t is a room and t is visited and the room north of t is a room and t is not the location:
		say "|";
	otherwise:
		say " ";
	
to say northeast by east:
	let T be the location;
	let ne be the room northeast of the location;
	let se be the room southeast of the location;
	let n be the room north of the location;
	let s be the room south of the location;
	let es be the room east of the location;
	if es is a room:
		now t is es;
	otherwise if the room south of ne is a room:
		now t is the room south of ne;
	otherwise if the room north of se is a room:
		now t is the room north of se;
	otherwise if the room southeast of n is a room:
		now t is the room southeast of n;
	otherwise if the room northeast of s is a room:
		now t is the room northeast of s;
	if t is a room and t is visited and the room northeast of t is a room and t is not the location:
		say "/";
	otherwise:
		say " ";
	
to say east by east:
	let T be the location;
	let ne be the room northeast of the location;
	let se be the room southeast of the location;
	let n be the room north of the location;
	let s be the room south of the location;
	let es be the room east of the location;
	if es is a room:
		now t is es;
	otherwise if the room south of ne is a room:
		now t is the room south of ne;
	otherwise if the room north of se is a room:
		now t is the room north of se;
	otherwise if the room southeast of n is a room:
		now t is the room southeast of n;
	otherwise if the room northeast of s is a room:
		now t is the room northeast of s;
	if t is a room and t is visited and the room east of t is a room and t is not the location:
		say "-";
	otherwise:
		say " ";

	
to say southeast by east:
	let T be the location;
	let ne be the room northeast of the location;
	let se be the room southeast of the location;
	let n be the room north of the location;
	let s be the room south of the location;
	let es be the room east of the location;
	if es is a room:
		now t is es;
	otherwise if the room south of ne is a room:
		now t is the room south of ne;
	otherwise if the room north of se is a room:
		now t is the room north of se;
	otherwise if the room southeast of n is a room:
		now t is the room southeast of n;
	otherwise if the room northeast of s is a room:
		now t is the room northeast of s;
	if t is a room and t is visited and the room southeast of t is a room and t is not the location:
		say "\";
	otherwise:
		say " ";
	
to say south by east:
	let T be the location;
	let ne be the room northeast of the location;
	let se be the room southeast of the location;
	let n be the room north of the location;
	let s be the room south of the location;
	let es be the room east of the location;
	if es is a room:
		now t is es;
	otherwise if the room south of ne is a room:
		now t is the room south of ne;
	otherwise if the room north of se is a room:
		now t is the room north of se;
	otherwise if the room southeast of n is a room:
		now t is the room southeast of n;
	otherwise if the room northeast of s is a room:
		now t is the room northeast of s;
	if t is a room and t is visited and the room south of t is a room and t is not the location:
		say "|";
	otherwise:
		say " ";

to say southwest by east:
	let T be the location;
	let ne be the room northeast of the location;
	let se be the room southeast of the location;
	let n be the room north of the location;
	let s be the room south of the location;
	let es be the room east of the location;
	if es is a room:
		now t is es;
	otherwise if the room south of ne is a room:
		now t is the room south of ne;
	otherwise if the room north of se is a room:
		now t is the room north of se;
	otherwise if the room southeast of n is a room:
		now t is the room southeast of n;
	otherwise if the room northeast of s is a room:
		now t is the room northeast of s;
	if t is a room and t is visited and the room southwest of t is a room and t is not the location:
		say "/";
	otherwise:
		say " ";
	
to say west by east:
	let T be the location;
	let ne be the room northeast of the location;
	let se be the room southeast of the location;
	let n be the room north of the location;
	let s be the room south of the location;
	let es be the room east of the location;
	if es is a room:
		now t is es;
	otherwise if the room south of ne is a room:
		now t is the room south of ne;
	otherwise if the room north of se is a room:
		now t is the room north of se;
	otherwise if the room southeast of n is a room:
		now t is the room southeast of n;
	otherwise if the room northeast of s is a room:
		now t is the room northeast of s;
	if t is a room and t is visited and the room west of t is a room and t is not the location:
		say "-";
	otherwise:
		say " ";
	
chapter 7 (southwest section)

to say southwest room:
	let W be the room west of the location;
	let S be the room south of the location;
	let SW be the room southwest of the location;
	let T be the location;
	if SW is a room:
		now T is SW;
	otherwise if S is a room and the room west of S is a room:
		now T is the room west of S;
	otherwise if W is a room and the room south of W is a room:
		now T is the room south of W;
	[new]
	if the number of moves from the location to T is one and T is not the location:
		let way be the best route from the location to T;
		hyperlink "([if t is visited]O[otherwise]?[end if])" as "[way]";
	[end new]
	otherwise if T is a room and T is not the location and T is visited:
		say "( )";
	otherwise:
		say "   ";

to say northwest by southwest:
	let W be the room west of the location;
	let S be the room south of the location;
	let SW be the room southwest of the location;
	let T be the location;
	if SW is a room:
		now T is SW;
	otherwise if S is a room and the room west of S is a room:
		now T is the room west of S;
	otherwise if W is a room and the room south of W is a room:
		now T is the room south of W;
	if t is a room and t is visited and the room northwest of t is a room and t is not the location:
		say "\";
		rule succeeds;
	say " ";		

to say north by southwest:
	let W be the room west of the location;
	let S be the room south of the location;
	let SW be the room southwest of the location;
	let T be the location;
	if SW is a room:
		now T is SW;
	otherwise if S is a room and the room west of S is a room:
		now T is the room west of S;
	otherwise if W is a room and the room south of W is a room:
		now T is the room south of W;
	if t is a room and t is visited and the room north of t is a room and t is not the location:
		say "|";
		rule succeeds;
	say " ";	
	
to say northeast by southwest:
	let W be the room west of the location;
	let S be the room south of the location;
	let SW be the room southwest of the location;
	let T be the location;
	if SW is a room:
		now T is SW;
	otherwise if S is a room and the room west of S is a room:
		now T is the room west of S;
	otherwise if W is a room and the room south of W is a room:
		now T is the room south of W;
	if t is a room and t is visited and the room northeast of t is a room and t is not the location:
		say "/";
		rule succeeds;
	say " ";	
	
to say east by southwest:
	let W be the room west of the location;
	let S be the room south of the location;
	let SW be the room southwest of the location;
	let T be the location;
	if SW is a room:
		now T is SW;
	otherwise if S is a room and the room west of S is a room:
		now T is the room west of S;
	otherwise if W is a room and the room south of W is a room:
		now T is the room south of W;
	if the t is a room and t is visited and the room east of t is a room and t is not the location:
		say "-";
		rule succeeds;
	say " ";
	
to say southeast by southwest:
	let W be the room west of the location;
	let S be the room south of the location;
	let SW be the room southwest of the location;
	let T be the location;
	if SW is a room:
		now T is SW;
	otherwise if S is a room and the room west of S is a room:
		now T is the room west of S;
	otherwise if W is a room and the room south of W is a room:
		now T is the room south of W;
	if t is visited and the room southeast of t is a room and t is not the location:
		say "\";
		rule succeeds;
	say " ";	
	
to say south by southwest:
	let W be the room west of the location;
	let S be the room south of the location;
	let SW be the room southwest of the location;
	let T be the location;
	if SW is a room:
		now T is SW;
	otherwise if S is a room and the room west of S is a room:
		now T is the room west of S;
	otherwise if W is a room and the room south of W is a room:
		now T is the room south of W;
	if t is visited and the room south of t is a room and t is not the location:
		say "/";
		rule succeeds;
	say " ";	
	
to say west by southwest:
	let W be the room west of the location;
	let S be the room south of the location;
	let SW be the room southwest of the location;
	let T be the location;
	if SW is a room:
		now T is SW;
	otherwise if S is a room and the room west of S is a room:
		now T is the room west of S;
	otherwise if W is a room and the room south of W is a room:
		now T is the room south of W;
	if t is visited and the room west of t is a room and t is not the location:
		say "-";
		rule succeeds;
	say " ";			
	
to say southwest by southwest:
	let W be the room west of the location;
	let S be the room south of the location;
	let SW be the room southwest of the location;
	let T be the location;
	if SW is a room:
		now T is SW;
	otherwise if S is a room and the room west of S is a room:
		now T is the room west of S;
	otherwise if W is a room and the room south of W is a room:
		now T is the room south of W;
	if t is visited and the room southwest of t is a room and t is not the location:
		say "/";
		rule succeeds;
	say " ";				
	

chapter 8 (south central section)

section 1 (s room)

to say S room:
	let t be the location;
	let sw be the room southwest of the location;
	let se be the room southeast of the location;
	let s be the room south of the location;
	if S is a room, now t is S;
	otherwise if sw is a room and the room east of SW is a room:
		now T is the room east of SW;
	otherwise if SE is a room and the room west of SE is a room:
		now T is the room west of SE;
		[new]
	if the number of moves from the location to T is one and T is not the location:
		let way be the best route from the location to T;
		hyperlink "([if t is visited]O[otherwise]?[end if])" as "[way]";
		[end new]
	otherwise if T is not the location and T is visited:
		say "( )";
		rule succeeds;
	otherwise:
		say "   ";
		
section 2 (northwest by south)

to say northwest by south:
	let t be the location;
	let sw be the room southwest of the location;
	let se be the room southeast of the location;
	let s be the room south of the location;
	if S is a room:
		now t is S;
	otherwise if sw is a room and the room east of SW is a room:
		now T is the room east of SW;
	otherwise if SE is a room and the room west of SE is a room:
		now T is the room west of SE;
	if t is visited and t is not the location and the room northwest of t is a room:
		say "\";
		rule succeeds;
	say " ";
	
section 3 (north by south)
	
to say north by south:
	let t be the location;
	let sw be the room southwest of the location;
	let se be the room southeast of the location;
	let s be the room south of the location;
	if S is a room:
		now t is S;
	otherwise if sw is a room and the room east of SW is a room:
		now T is the room east of SW;
	otherwise if SE is a room and the room west of SE is a room:
		now T is the room west of SE;
	if t is visited and t is not the location and the room north of t is a room:
		say "|";
		rule succeeds;
	say " ";
	
section 4 (northeast by south)

to say northeast by south:
	let t be the location;
	let sw be the room southwest of the location;
	let se be the room southeast of the location;
	let s be the room south of the location;
	if S is a room:
		now t is S;
	otherwise if sw is a room and the room east of SW is a room:
		now T is the room east of SW;
	otherwise if SE is a room and the room west of SE is a room:
		now T is the room west of SE;
	if t is visited and t is not the location and the room northeast of t is a room:
		say "/";
		rule succeeds;
	say " ";
	
section 5 (east by south)
	
to say east by south:
	let t be the location;
	let sw be the room southwest of the location;
	let se be the room southeast of the location;
	let s be the room south of the location;
	if S is a room:
		now t is S;
	otherwise if sw is a room and the room east of SW is a room:
		now T is the room east of SW;
	otherwise if SE is a room and the room west of SE is a room:
		now T is the room west of SE;
	if t is visited and t is not the location and the room east of t is a room:
		say "-";
		rule succeeds;
	say " ";
	
section 6 (southeast by south)
	
to say southeast by south:
	let t be the location;
	let sw be the room southwest of the location;
	let se be the room southeast of the location;
	let s be the room south of the location;
	if S is a room:
		now t is S;
	otherwise if sw is a room and the room east of SW is a room:
		now T is the room east of SW;
	otherwise if SE is a room and the room west of SE is a room:
		now T is the room west of SE;
	if t is visited and t is not the location and the room southeast of t is a room:
		say "\";
		rule succeeds;
	say " ";
	
section 7 (south by south)
	

to say south by south:
	let t be the location;
	let sw be the room southwest of the location;
	let se be the room southeast of the location;
	let s be the room south of the location;
	if S is a room:
		now t is S;
	otherwise if sw is a room and the room east of SW is a room:
		now T is the room east of SW;
	otherwise if SE is a room and the room west of SE is a room:
		now T is the room west of SE;
	if t is visited and t is not the location and the room south of t is a room:
		say "|";
		rule succeeds;
	say " ";
	
section 8 (southwest by south)
	
to say southwest by south:
	let t be the location;
	let sw be the room southwest of the location;
	let se be the room southeast of the location;
	let s be the room south of the location;
	if S is a room:
		now t is S;
	otherwise if sw is a room and the room east of SW is a room:
		now T is the room east of SW;
	otherwise if SE is a room and the room west of SE is a room:
		now T is the room west of SE;
	if t is visited and t is not the location and the room southwest of t is a room:
		say "/";
		rule succeeds;
	say " ";
	
section 9 (west by south)
	
to say west by south:
	let t be the location;
	let sw be the room southwest of the location;
	let se be the room southeast of the location;
	let s be the room south of the location;
	if S is a room:
		now t is S;
	otherwise if sw is a room and the room east of SW is a room:
		now T is the room east of SW;
	otherwise if SE is a room and the room west of SE is a room:
		now T is the room west of SE;
	if t is visited and t is not the location and the room west of t is a room:
		say "-";
		rule succeeds;
	say " ";
	
chapter 9 (the southeast sector)

to say se room:
	let E be the room east of the location;
	let S be the room south of the location;
	let SE be the room southeast of the location;
	let T be the location;
	if SE is a room:
		now T is SE;
	otherwise if S is a room and the room east of S is a room:
		now T is the room west of S;
	otherwise if E is a room and the room south of E is a room:
		now T is the room south of E;
	[new]
	if the number of moves from the location to T is one and T is not the location:
		let way be the best route from the location to T;
		hyperlink "([if t is visited]O[otherwise]?[end if])" as "[way]";
	[end new]
	otherwise if T is a room and T is not the location and T is visited:
		say "( )";
	otherwise:
		say "   ";

to say northwest by southeast:
	let T be the location;
	let E be the room east of the location;
	let S be the room south of the location;
	let SE be the room southeast of the location;
	if SE is a room:
		now T is SE;
	otherwise if S is a room and the room east of S is a room:
		now T is the room east of S;
	otherwise if E is a room and the room south of E is a room:
		now T is the room south of E;
	if T is visited and T is not the location and the room northwest of t is a room:
		say "\";
	otherwise:
		say " ";		
	
to say north by southeast:
	let T be the location;
	let E be the room east of the location;
	let S be the room south of the location;
	let SE be the room southeast of the location;
	if SE is a room:
		now T is SE;
	otherwise if S is a room and the room east of S is a room:
		now T is the room east of S;
	otherwise if E is a room and the room south of E is a room:
		now T is the room south of E;
	if T is visited and T is not the location and the room north of t is a room:
		say "|";
	otherwise:
		say " ";	
	
to say northeast by southeast:
	let T be the location;
	let E be the room east of the location;
	let S be the room south of the location;
	let SE be the room southeast of the location;
	if SE is a room:
		now T is SE;
	otherwise if S is a room and the room east of S is a room:
		now T is the room east of S;
	otherwise if E is a room and the room south of E is a room:
		now T is the room south of E;
	if t is visited and T is not the location and the room northeast of t is a room:
		say "/";
	otherwise:
		say " ";	
	
to say east by southeast:
	let T be the location;
	let E be the room east of the location;
	let S be the room south of the location;
	let SE be the room southeast of the location;
	if SE is a room:
		now T is SE;
	otherwise if S is a room and the room east of S is a room:
		now T is the room east of S;
	otherwise if E is a room and the room south of E is a room:
		now T is the room south of E;
	if t is visited and T is not the location and the room east of t is a room:
		say "-";
	otherwise:
		say " ";	
	
to say southeast by southeast:
	let T be the location;
	let E be the room east of the location;
	let S be the room south of the location;
	let SE be the room southeast of the location;
	if SE is a room:
		now T is SE;
	otherwise if S is a room and the room east of S is a room:
		now T is the room east of S;
	otherwise if E is a room and the room south of E is a room:
		now T is the room south of E;
	if t is visited and T is not the location and the room southeast of t is a room:
		say "\";
	otherwise:
		say " ";	
	
to say south by southeast:
	let T be the location;
	let E be the room east of the location;
	let S be the room south of the location;
	let SE be the room southeast of the location;
	if SE is a room:
		now T is SE;
	otherwise if S is a room and the room east of S is a room:
		now T is the room east of S;
	otherwise if E is a room and the room south of E is a room:
		now T is the room south of E;
	if T is visited and T is not the location and the room south of t is a room:
		say "|";
	otherwise:
		say " ";	
	
to say southwest by southeast:
	let T be the location;
	let E be the room east of the location;
	let S be the room south of the location;
	let SE be the room southeast of the location;
	if SE is a room:
		now T is SE;
	otherwise if S is a room and the room east of S is a room:
		now T is the room east of S;
	otherwise if E is a room and the room south of E is a room:
		now T is the room south of E;
	if t is visited and T is not the location and the room southwest of t is a room:
		say "/";
	otherwise:
		say " ";	
	
to say west by southeast:
	let T be the location;
	let E be the room east of the location;
	let S be the room south of the location;
	let SE be the room southeast of the location;
	if SE is a room:
		now T is SE;
	otherwise if S is a room and the room east of S is a room:
		now T is the room east of S;
	otherwise if E is a room and the room south of E is a room:
		now T is the room south of E;
	if t is visited and T is not the location and the room west of t is a room:
		say "-";
	otherwise:
		say " ";	

Mini-Map ends here.

---- DOCUMENTATION ----

Mini-map v4 uses Emily Short's Basic Screen Effects to build a custom status bar containing nearby rooms and exits as an ASCII map. This should just work out of the gate. Inform will build the map based on the exits and rooms available in the current location. It also attempts to account for rooms that would be on the map but aren't accessible, ie, a discovered room is on the 3x3 grid but there is no route to it that takes only one step.

The map currently uses three characters per room, which makes for a large status window. A future update will likely trim this to one character per room, but there is no timeline for that.

It's best to buid with the extension in mind. Keep things on a neat grid with reciprocating exits and everything ought to work.

Limitation: there is no current support for up and down exits. My solution has been to add both up and another direction leading to the same room.

	attic is north of hallway.
	attic is up from hallway.
	
This seems to work fine, though you may have issues if you have a lot of exits and can't spare one. I haven't encountered that situation yet in my own work, so I may never get around to handling it here.


	"Consult the Map"
	
	include basic screen effects by emily short.
	include simple multimedia effects for v10 by mathbrush.
	include mini-map by drew cook.
	
	release along with a "bisquixe" interpreter.

	lab is a room.
	closet is east of lab.
	basement is down from lab.
	basement is south from lab.
	hallway is west from lab.
	annex is west of hallway.
	storage room is south of hallway.
	monitoring is northwest from lab.
	power plant is north from monitoring.
	candy land is southwest from power plant.

