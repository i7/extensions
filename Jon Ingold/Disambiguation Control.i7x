Version 9/171416 of Disambiguation Control by Jon Ingold begins here.

"Allows finer control over the disambiguation process used by Inform to decide what the player was referring to. Less guesswork, more questions asking for more input. Also removes the multiple-object-rejection in favour of asking for more information."

"updated for 6M62 by Matt Weiner and Daniel Stelzer"


[ KNOWN ISSUES LIST:

	"Doing something with" only checks for first noun:
		-> particularly annoying for give and show, which check their reversed forms first
		-> meaning the first attempt at parsing will ignore all rules about animate contexts!
		-> current workaround throws out non-animates for giving and showing to.
			This isn't great (see comments in the appropriate section) - but the problem is the order in which the parser defines the grammar lines
			and that's impossible to change!


	The parser will "auto-guess" if it matches a group of "indistinguishable" items, but the parser doesn't always know when items are indistinguishable. In particular, if you use "[something related by containment]" to refer to a generic container / kind of container, the parser will treats these items as indistinguishable (same grammar) despite the fact the player can - easily - distinguish them.
		-> Need some way to step in and tell the parser "these are not the same"
		-> was possible in I6 "##TheSame" , not sure how to do it now

]

[Version 8: A few tiny patches have been made by Matt Weiner to attempt to get Disambiguation Control running under 6L02]

Use disambiguation list length of at least 6 translates as (- Constant TRUNCATE_LIST = {N}; -).

Use no parser suggestions translates as (- Constant NO_SUGGESTIONS; -).
Use no multiple suggestions translates as (- Constant NO_MULTIPLE; -).

Use debug choose objects translates as (- Constant COBJ_DEBUG; -).



Volume - Front End Stuff



Book - New Rulebooks

Chapter - should the game choose?

[ 
For diverting actions where the player has specified something in a slick way.
This is never really necessary, but it can sometimes be slick:
	for example if the player types "open door with key" we
	can provide a rule to guess the correct key.
]

The should the game choose rules are a rulebook. 
The should the game choose rules have outcomes  it is an excellent choice, it is a good choice, it is a passable choice and never.

[should the game choose doing something to a person when matching a creature token is true (this is the prefer animate nouns for animate contexts rule): 
	it is likely.]

Section - what else are we considering?

[ Is there at least one of the type given? ]

To decide if considering some (D - a description of objects):
[ if D intersect the match list is non-empty ... ]
	let L be the match list;
	let Y be a list of objects; let Y be the list of D;
	if L intersect Y is non-empty, decide yes;
	decide no. 

To decide if also considering (k - an object):
	(-  (IncludedInMatchList({k}) && ~~IncludedInMatchList(0)) 	-).

To decide if only/also only/also/just considering (k - an object): 
	(- IncludedInMatchList({k}, 1)	-).

To decide if comparing it/-- against/with/alongside (k - an object): 
	(- IncludedInMatchList({k}, 1)	-).

[ are we considering nothing but..? ]

[ two things - same phrase above but never mind ]

To decide if comparing (x0 - an object) against (x1 - a object):
[	say "comparing [x0] against [x1] when the match list is [the match list] and the noun is [noun]...."; ]
	if x0 is not under consideration, decide no;
	let L be the match list;
	remove the x0 from L, if present;
	remove x1 from L, if present;
	if the number of entries in L is 0, decide yes;
	decide no.

To decide if comparing (x1 - a object) +/plus (x2 - a object):
	let L be the match list;
	remove x1 from L, if present;
	remove x2 from L, if present;
	if the number of entries in L is 0, decide yes;
	decide no.

[ three things ]

To decide if comparing (x0 - an object) against (x1 - an object) + (x2 - an object):
[say "comparing [x0] with [x1] and [x2]";]
	if x0 is not under consideration, decide no;
	let L be the match list;
	remove the x0 from L, if present;
	remove x1 from L, if present;
	remove x2 from L, if present;
	if the number of entries in L is 0, decide yes;
	decide no.

To decide if comparing (x1 - an object) +(x2 - an object) + (x3 - an object):
	let L be the match list; 
	remove x1 from L, if present;
	remove x2 from L, if present;
	remove x3 from L, if present;
	if the number of entries in L is 0, decide yes;
	decide no.

[ four things ]

To decide if comparing (x0 - an object) against (x1 - an object) +(x2 - an object) + (x3 - an object):
	if x0 is not under consideration, decide no;
	let L be the match list; 
	remove the x0 from L, if present;
	remove x1 from L, if present;
	remove x2 from L, if present;
	remove x3 from L, if present;
	if the number of entries in L is 0, decide yes;
	decide no.

To decide if comparing (x0 - an object) + (x1 - an object) + (x2 - an object) + (x3 - an object):
	let L be the match list; 
	remove x0 from L, if present;
	remove x1 from L, if present;
	remove x2 from L, if present;
	remove x3 from L, if present;
	if the number of entries in L is 0, decide yes;
	decide no.

[ unlimited things via a description ]

To decide if comparing (C - a description of objects):
	let L be a list of objects;
	let L be the list of C;
	if the match list is a subset of L, decide yes;
	decide no.

To decide if comparing (x0 - an object) against (C - a description of objects):
	if x0 is not under consideration, decide no;
	let L be a list of objects;
	remove the x0 from L, if present;
	let L be the list of C;
	if the match list is a subset of L, decide yes;
	decide no.

Section - some phrases for testing whether we've checking noun or second

To decide if (x - an object) is not under consideration:
	if testing noun and x is not the noun, decide yes;
	if not testing noun and x is not the second noun, decide yes;
	decide no.	

To decide if testing the/a/-- noun:	(- (TestingNoun()) -).
To decide if testing the/a/-- second noun: 	
	if testing noun, decide no;
	decide yes.

Include (-
[ TestingNoun;
	if (parameters > 0 || look_ahead) 
	{
!		print "[testing second]^";
		rfalse;
	}
!	print "[testing noun]^";
	rtrue;
];
-).


Chapter - Should the game suggest?

[ 
 outcomes from this indicate probability of a certain action pattern
 impossible will remove it from the list entirely if the parser is guessing
 always impossible will remove it from the list of suggestions provided even when the player types something
]

The Should the game suggest rules are a rulebook. 
The Should the game suggest rules have outcomes it is an excellent suggestion, it is a good suggestion, it is a passable suggestion, it is a bad suggestion (failure - the default) and never.


Chapter - Initial Expectations

Section - animate contexts

[
	This is the problem now: the rule below fires only on the noun, and that's regardless of which term is the animate token anyway.
	So this rule needs to know - was the token under consideration the first or the second word?
	This is ugly - possibly ought to sit hard-coded in ChooseObjects - but I don't like the idea of not being able to circumvent / promote other things
	...so forth. 
	Since it's a suggest rule, though, it will be overridden by choice rules -- and other things can be suggested to meet/beat it.

	Oh, okay, for now then.

]

[
Should the game suggest doing something to a person when matching a creature token is true (this is the expect animate nouns for animate contexts rule): 
	it is a good suggestion.
]

Should the game suggest showing something to someone when testing second noun (this is the expect animate nouns for giving rule): 
	it is a good suggestion.

Should the game suggest giving something to someone when testing second noun (this is the expect animate nouns for showing rule): 
	it is a good suggestion.

[ THE FOLLOWING RULES ARE NOT GREAT.

	What they do is ensure that when the game checks "giving (animate) (noun)" (reversed) it'll fail, moving onto the second line (which is not reversed).
	The problem is that the first one can't be structurally dismissed because it doesn't have a preposition!
	(Whereas if the two verbs line were the other way around, it would check the preposition, see it's missing for the reversed case, and then move on.
	Not sure of a good solution: for the moment, this means that "showing" and "giving" things to non-animates will always require absolute specificity on the part of the player
		(it was previously impossible, so this is still an improvement!)
	Also giving an animate to an animate may ask for clarification which it then ignores
		(but at least when it says "whom" it'll mean "whom.)
]

Should the game suggest showing something to something when testing second noun (this is the reject inanimate nouns for giving rule): 
	never.

Should the game suggest giving something to something when testing second noun (this is the reject inanimate nouns for showing rule): 
	never.



section - opening, locking, closing and unlocking

Should the game suggest closing a thing (called x) (this is the standard suggest closing rule): 
	if x is not openable, it is a bad suggestion;
	if x is closed, it is a passable suggestion;
	if x is open, it is a good suggestion.

Should the game suggest opening a thing (called x) (this is the standard suggestion opening rule): 
	if x is not openable, it is a bad suggestion;
	if x is open, it is a passable suggestion;
	if x is closed, it is a good suggestion.



Should the game suggest unlocking a thing (called x) with when testing noun (this is the standard suggest unlocking rule): 
	if x is not lockable, it is a bad suggestion;
	if x is unlocked, it is a passable suggestion;
	if x is locked, it is a good suggestion.

Should the game suggest locking a thing (called x) with when testing noun (this is the standard suggest locking rule): 
	if x is not lockable, it is a bad suggestion;
	if x is locked, it is a passable suggestion;
	if x is unlocked, it is a good suggestion.



Section - entering and getting off

Should the game suggest entering something (called x) (this is the standard suggest entering rule): 
	if x is not enterable, it is a bad suggestion;
	if the player is enclosing x, it is a bad suggestion;
	if the player is in x or the player is on x, it is a passable suggestion;
	it is a good suggestion.

Should the game suggest getting off something (called x) (this is the standard suggest getting off rule): 
	if the noun is not enterable, it is a bad suggestion;
	if the player is in x or the player is on x, it is a good suggestion;
	it is a passable suggestion.


Section - wearing, eating


Should the game suggest wearing something (called x) (this is the standard suggest wearing rule): 
	if x is scenery, never;
	if x is not wearable, it is a bad suggestion;
	if the player is wearing x, it is a passable suggestion;
	it is a good suggestion.

Should the game suggest eating something (called x) (this is the standard suggest eating rule): 
	if x is scenery, never;
	if x is not edible, it is a bad suggestion;
	it is a good suggestion.




Section - taking, dropping

Should the game suggest taking the player  (this is the don't suggest taking yourself rule): 
	never.

Should the game suggest taking something enclosed by a person  (this is the don't suggest taking something someone's got rule): 
	it is a bad suggestion.

Should the game suggest taking something scenery (this is the don't suggest taking the scenery rule): 
	it is a bad suggestion.

Should the game suggest taking something fixed in place (this is the don't suggest taking something fixed  rule): 
	it is a bad suggestion.

The last Should the game suggest taking something portable (this is the suggest to take portable things rule): 
	it is a good suggestion.

Should the game suggest taking a person (this is the don't suggest taking a person  rule): 
	it is a bad suggestion.

Should the game suggest taking something carried by the player (this is the don't suggest to take what's carried rule): 
	it is a passable suggestion.

Should the game suggest dropping something not enclosed by the player (this is the don't suggest dropping something you've not got rule): 
	if the noun is portable, it is a passable suggestion;
	it is a bad suggestion.

The first Should the game suggest dropping something carried by the player (this is the drop what's you've got rule):
	it is a good suggestion.


Section - inserting, putting

[ world modelling ]

Should the game suggest inserting into something when the second noun is not a container and testing second noun (this is the don't suggest inserting into a non-container rule):
	it is a bad suggestion.

Should the game suggest putting on when the second noun is not a supporter and testing second noun  (this is the don't suggest putting into a non-supporter rule):
	it is a bad suggestion.

[ Second noun viability testing:

 * problem - these overrule defaults!
 * so if you have two objects: one default (not-so-great), another good, being put into a valid container, both will return as good! 

-- solution?

]


Should the game suggest inserting into something when the second noun is a container and testing second noun  (this is the suggest inserting into a container rule):
	it is a good suggestion.
Should the game suggest putting something on something when the second noun is a supporter and testing second noun  (this is the suggest putting on a supporter rule):
	it is a good suggestion.

[ ought to be carried -- not sure if i want these, to be honest ]

Should the game suggest inserting something into something when the noun is carried and testing noun  (this is the expect to put held things into rule):
	it is a good suggestion.
Should the game suggest putting something on something when the noun is carried and testing noun  (this is the suggest to put held things on rule):
	it is a good suggestion.

[ actions which are already done: these rules apply to both noun and second ]

The first Should the game suggest inserting something into something when the noun is inside the second noun (this is the don't suggest inserting somewhere it already is rule):
	it is a bad suggestion.
The first Should the game suggest putting something on something when the noun is on the second noun (this is the don't suggest putting somewhere it already is rule):
	it is a bad suggestion.

[ actions which look stupid: these rules apply to both noun and second ]

The first Should the game suggest inserting something into something when the noun is the second noun (this is the don't expecting inserting something into itself rule): 
	never.
The first Should the game suggest putting something on something when the noun is the second noun (this is the don't suggest putting something into itself rule): 
	never.





Section - giving

Should the game suggest giving something carried by the player to someone when testing noun  (this is the suggest giving held things rule):
	it is a good suggestion.


Section - removing

[
Removing is confused by being attached to the multi-except tokens. Anything else using this (other things in I7?) will need some rules similar to these writing 
if they're going to pick out obvious best choices. 
]

Should the game suggest removing from something when the second noun is not a container and the second noun is not a supporter and testing second noun (this is the don't expect to remove from items not including other items rule):
	it is a bad suggestion.

[ prevent taking things from places they aren't: applies to both noun and second ] 

The first should the game suggest removing something from something when the noun is not inside the second noun and the noun is not on the second noun (this is the don't expect to remove items from things they're not in rule):
	it is a bad suggestion.

[ encourage taking things from places they are: applies to both noun and second ] 

Should the game suggest removing from something when the noun is inside the second noun or the noun is on the second noun (this is the expect to remove items from things they are in rule):
	it is a good suggestion.

Section - yourself

The first should the game suggest rule when the noun is yourself and testing the noun (this is the never suggest yourself rule):
	never.

Chapter - I7 Functions to Manipulate Sets

Section - is X a subset of Y?

To decide if (X - a list of objects) is a subset of (Y - a list of objects):
	remove Y from X, if present;
	if the number of entries in X is 0, decide yes;
	decide no.

Section - is X intersect Y non-empty?

To decide if (X - a list of objects) intersect (Y - a list of objects) is non-empty:
	let starting number be the number of entries in X;
	remove Y from X, if present;
	if the number of entries in X is not the starting number, decide yes;
	decide no.

Volume - New Parser Messages

[ Thanks to Ron Newcomb for this code block. ]
[
Table of Disambiguation Messages
message-id	message text
1			"Please be more specific - "
2			"Whom do you want[actor-or-player] to [print-or-construct]: "
3			"What do you want[actor-or-player] to [print-or-construct]: "
4			"Whom do you want[actor-or-player] to [print-or-construct]?[paragraph break]"
5			"What do you want[actor-or-player] to [print-or-construct]?[paragraph break]"
6			"whom do you want[actor-or-player] to [print-or-construct]: "
7			"what do you want[actor-or-player] to [print-or-construct]: "
8			"whom do you want[actor-or-player] to [print-or-construct]?[paragraph break]"
9			"what do you want[actor-or-player] to [print-or-construct]?[paragraph break]"
10			"?[line break]"
11			"?[paragraph break]"
12			"You can only have one item here. Which exactly?"
20			"take things from"
21			"put things in"
22			"put things on"
]

The message-id-requested is a number that varies.

This is the disambiguation printing rule:
	if the message-id-requested is:
		-- 1: say "Please be more specific - " (A);
		-- 2: say "Whom [regarding the player][do] [we] want[actor-or-player] to [print-or-construct]: " (B);
		-- 3: say "What [regarding the player][do] [we] want[actor-or-player] to [print-or-construct]: " (C);
		-- 4: say "Whom [regarding the player][do] [we] want[actor-or-player] to [print-or-construct]?[paragraph break]" (D);
		-- 5: say "What [regarding the player][do] [we] want[actor-or-player] to [print-or-construct]?[paragraph break]" (E);
		-- 6: say "whom [regarding the player][do] [we] want[actor-or-player] to [print-or-construct]: " (F);
		-- 7: say "what [regarding the player][do] [we] want[actor-or-player] to [print-or-construct]: " (G);
		-- 8: say "whom [regarding the player][do] [we] want[actor-or-player] to [print-or-construct]?[paragraph break]" (H);
		-- 9: say "what [regarding the player][do] [we] want[actor-or-player] to [print-or-construct]?[paragraph break]" (I);
		-- 10: say "?[line break]" (J);
		-- 11: say "?[paragraph break]" (K);
		-- 12: say "[We] [can] only have one item here. Which exactly?" (L);
		-- 20: say "take things from" (M);
		-- 21: say "put things in" (N);
		-- 22: say "put things on" (O);

To say actor-or-player: (-ActorOrPlayer(); -).
To say print-or-construct: (- PrintOrConstruct(); -).

Include (-

[ ParserMessage n m;
!	print "--- ", n, " ----^";

! we swap messages if we're in indef mode

	if (indef_wanted > 0)
	{
		m = 0;
		switch(n)
		{	
			2:  	m = 6;
			3:  	m = 7;
			4: 	m = 8;
			5: 	m = 9;
		}
		if (m > 0)	! m had better never equal any of the values listed above!!
		{
			ParserMessage(1);
			ParserMessage(m);
			rtrue;
		}
		
	}


	(+message-id-requested+) = n;
	(+disambiguation printing rule+)();

];

[ ActorOrPlayer i;
	 i = 1;
       if (actor~=player) print " ", (the) actor; 
	#ifdef FIRST_PERSON;
		if (actor == player) print " me";
	#endif;
];


[ PrintOrConstruct ;

 	if (~~look_ahead) PrintCommand();
	else if (action_to_be == ##Remove) ParserMessage(20);
	else if (action_to_be == ##Insert) ParserMessage(21);
	else if (action_to_be == ##PutOn) ParserMessage(22);

! to get here, the user must have created a new action with the Multi_held or multi_inside tokens.
! We'll have to let the parser do the best it can
! if we get strange messages for new actions, this might be the place to add something in!!

	else PrintCommand();

];

-)



[ ******************************************************************************************************** ]


Volume - Backend Stuff

Chapter - The Match list

[ The match list stores the objects that met the players input. This is what we intend to disambiguate between. ]

Section - Building the match list as an I7 list

To decide which list of objects is the match list:
	let L be a list of objects;
	repeat with N running from 1 to 100:
		let i be item N from the match list;
		if i is no-object:	
			break;
		add i to L;
	decide on L.

To decide which thing is item (N - a number) from the match list:
(- MatchListEntry({N}) -).


Section - Guesswork

[ Sometimes the parser is informed: other times it's guessing blind. Compare

> TAKE KEY
Which key do you mean..?

and 

>TAKE

This extension allows us to separate the two cases by asking if we're "guessing". 

This is critical on the lower levels to how the parsing is carried out: it affects whether the parser should be allowed to offer opinions on what's going on.

We're guessing if a nameless object which is always in scope appears in the possible noun list. 

 ]

No-object is a privately-named thing. After deciding the scope of the player: place no-object in scope.
Should the game suggest doing something with no-object: never.
Rule for deciding whether all includes no-object: it does not.

To decide if guessing:
(-	
	(GuessingI6())
-)


section - i6 routines for accessing the match list

[
	The match list contains the objects the parser is currently considering for the noun it's thinking about
	We use the following routines for rules that say, "when comparing the x and the y" or "when also considering the k"
]

Include (-

[ MatchListGuessing;
	return IncludedInMatchList(0);
];

[ IncludedInMatchList
obj excl_flag
 i 
;
if (obj == 0) obj = (+no-object+);

for (i = 0: i< number_matched : i++)
{ 	!print " ", (the) match_list-->i;
	if (match_list-->i == obj) 
		if (excl_flag == 0 || (excl_flag == 1 && number_matched == 2))  rtrue;
}	

rfalse;
];

[MatchListEntry N;
	if ( N > number_matched) return (+no-object+);
	return match_list-->(N-1);
];

-).



Book - Parser replacements

Chapter - Noun Domain

[ 

Does the heavy lifting:

* produces a match list for the current input
* sets the guessing flag to true or flag
* runs the adjudicate routine on the match list and input
* decides whether to fail the line, pass it or ask for additional input
* if additional input is required, it gathers it and then stitches it back into the original line of input
* this is done twice - once for stitching text onto the end of the line, once for dropping it in the middle

Extensively rewritten!

Lots of replicated code so this isn't very tidy. I may try to break it up into routines later.

]

Include (-
Global look_ahead = 0;
Global guessed_first_noun = false;
-) after "Grammar Line Variables" in "Parser.i6t".


Include (-

Array  printed_text -> 123;  



Global guessing;
[GuessingI6; return guessing; ];

! ----------------------------------------------------------------------------
!  NounDomain does the most substantial part of parsing an object name.
!
!  It is given two "domains" - usually a location and then the actor who is
!  looking - and a context (i.e. token type), and returns:
!
!   0    if no match at all could be made,
!   1    if a multiple object was made,
!   k    if object k was the one decided upon,
!   REPARSE_CODE if it asked a question of the player and consequently rewrote
!        the player's input, so that the whole parser should start again
!        on the rewritten input.
!
!   In the case when it returns 1<k<REPARSE_CODE, it also sets the variable
!   length_of_noun to the number of words in the input text matched to the
!   noun.
!   In the case k=1, the multiple objects are added to multiple_object by
!   hand (not by MultiAdd, because we want to allow duplicates).
! ----------------------------------------------------------------------------


[ MultiContext tkn;

! return true if the grammar token is one that allows for multiple objects
! ie. grammar line expects multiple objects

  if (tkn == MULTI_TOKEN or MULTIHELD_TOKEN or MULTIEXCEPT_TOKEN or MULTIINSIDE_TOKEN)
     rtrue;
  rfalse;
];



[ WorthGuessingNoun act;

! Version 7 - I think this routine is no longer used, having been replaced by the I7 rules

	if (act == 

! list of actions for which guessing the only available non-scenery-type noun is worth doing

 ##Take or ##Drop or ##PutOn or ##Insert or ##Remove

	) rtrue; 
  rfalse;
];


[ NounDomain domain1 domain2 context    first_word i j k l
                                        answer_words marker flag;


#ifdef DEBUG;
  if (parser_trace>=4)
  {   print "   [NounDomain called at word ", wn, "^";
      print "   ";
      if (indef_mode)
      {   print "seeking indefinite object: ";
          if (indef_type & OTHER_BIT)  print "other ";
          if (indef_type & MY_BIT)     print "my ";
          if (indef_type & THAT_BIT)   print "that ";
          if (indef_type & PLURAL_BIT) print "plural ";
          if (indef_type & LIT_BIT)    print "lit ";
          if (indef_type & UNLIT_BIT)  print "unlit ";
          if (indef_owner ~= 0) print "owner:", (name) indef_owner;
          new_line;
          print "   number wanted: ";
          if (indef_wanted == 100) print "all"; else print indef_wanted;
          new_line;
          print "   most likely GNAs of names: ", indef_cases, "^";
      }
      else print "seeking definite object^";
  }
#endif;

! initialise variables

match_length=0; 
number_matched=0; 
match_from=wn; 

! build the match list

  SearchScope(domain1, domain2, context);

#ifdef DEBUG;
  if (parser_trace>=4) print "   [ND made ", number_matched, " matches]^";
#endif;

! use the match-list to determine if we were guessing or not
! seems backwards to use the results of parsing to decide if there's no text, but
! that's the way it's done.

  guessing = MatchListGuessing();

  #ifdef DEBUG;
  if (parser_trace>=4)
  {
  if (guessing)
   {
     print "[ND guessing]^";
   }
  else
   { print "[ND informed]^";

     for (i = 0: i< number_matched: i++)
  	if (match_list-->i~=0) print "^", (the) match_list-->i, "..?^";
   }
  }
  #endif;

  wn=match_from+match_length;

!  If nothing worked at all, leave with the word marker skipped past the
!  first unmatched word, and ditch this line

  if (number_matched==0) { wn++; rfalse; }

!  Suppose that there really were some words being parsed (i.e., we did
!  not just guess).  If so, and if there was only one match, it must be
!  right and we return it...

  if (match_from <= num_words)
  {   if (number_matched==1) 
      {
        i=match_list-->0; return i;
      }

!  ...now suppose that there was more typing to come, i.e. suppose that
!  the user entered something beyond this noun.  If nothing ought to follow,
!  then there must be a mistake, (unless what does follow is just a full
!  stop, and or comma)

!!! this, note, would be a great place to check PUT <x> DOWN and catch that problem!!
 
     if (wn<=num_words)
      {   i=NextWord(); wn--;
          if (i ~=  AND1__WD or AND2__WD or AND3__WD or comma_word
                 or THEN1__WD or THEN2__WD or THEN3__WD
                 or BUT1__WD or BUT2__WD or BUT3__WD)
          {   if (lookahead==ENDIT_TOKEN) rfalse;
          }

! DC Improvement
! We add the ability for the grammar line to check, here and now, if the next word in the input
! is the preposition the game is expecting for this line. This lets us fail the grammar line quickly
! if we're matching the wrong line entirely. The standard parser does do this, and can lead to Inform
! making guesses and disambiguating in contexts when it's no good to even try.

	#ifdef COBJ_DEBUG;
		print "Next token lookahead: ", line_ttype-->pcount , "!^";
	#endif;

		if (line_ttype-->pcount == PREPOSITION_TT)
		{
      	  		if (~~PrepositionChain(i, pcount) ~= -1) 
			{
!				print "(We've failed to match our preposition. Woohoo! Let's move on)";
      		 	rfalse;
			}
		}


! otherwise, if the next token is another noun, we run the parser to gather results for the second noun, so we
! can do a ChooseObjects pass - using the I7 rules - using full lines, rather than partially matched ones.

		if (line_ttype-->pcount == ELEMENTARY_TT or ATTR_FILTER_TT or ROUTINE_FILTER_TT)
		{		

			SafeSkipDescriptors();

			! save the current match state, since we're experimenting here
			@push token_filter; @push wn; @push match_length; @push match_from; @push number_matched;
			
			! now get all the matches for the second noun
			match_length = 0; number_matched = 0; match_from = wn;

			if (line_ttype-->pcount == ELEMENTARY_TT)
			{
				! cheapest way of filling the match list
				SearchScope(actor, actors_location, line_tdata-->pcount);
			}
			else
			{
				! more complex tokens need a bit more work

				if (line_ttype-->pcount == ATTR_FILTER_TT)
				{	token_filter = 1 + line_tdata-->pcount;
				}
				else
				{	token_filter = line_tdata-->pcount;
				}
				SearchScope(actor, actors_location, NOUN_TOKEN);
			}

			#ifdef DEBUG;
				if (parser_trace >= 4)
					print number_matched, " possible continuation nouns";
			#endif;

			i = number_matched;

			! reset the position of the parser from before this pass
			@pull number_matched; @pull match_from; @pull match_length; @pull wn; @pull token_filter;

			! Are there no matches for the second noun? If so, we can give up here and now.
			if (i == 0) 
			{
				#ifdef DEBUG;
					if (parser_trace >= 4)
						print "(Failed to match follow-on words. Moving to next line.)^";
				#endif;
				rfalse;
			}
					
		}
      }
}

!  Now, if there's more than one choice, let's see if we can do better

  number_of_classes=0;

  if (number_matched > 1) 
  {  	
	(+list-outcomes+) = false; 	! we set the list-writer to false and see if the outcomes can make it true again

	! Now we run Adjudicate, which in turn runs ChooseObjects and the I7 routines
	! these routines will score the options, and delete inappropriate ones

	i=Adjudicate(context);
	
	! Did we fail to get anything from Adjudicate?
	if (i == -1)
	{
		! If we're guessing, then there was nothing valid. So let's ask the player to explain themselves.
		if (guessing) 
		{
			if (indef_possambig)
			{
				if (parser_trace == 5)
					print "    [Failed to find anything using an ambiguous input.]^";
				rfalse;
			}
			jump Incomplete;		
		}
		
		! otherwise, if we weren't guessing, then what the player typed made no sense after all, so fail the line.
		rfalse;
	}

      if (i==1)  ! A multiple object was matched. 
      {

		! If we're not looking for a multiple noun, then we have a fundamental problem
	 	if (~~MultiContext(context)) 
			 print "[BUG in Disambiguation: Multiple object made it out of Adjudicate!]^";

		rtrue;

      }

  }

! If i is non-zero, then we're looking at an object

!  If i is non-zero here, one of two things is happening: either
!  (a) an inference has been successfully made that object i is
!      the intended one from the user's specification, or
!  (b) the user finished typing some time ago, but we've decided
!      on i because it's the only possible choice.
!  In either case we have to keep the pattern up to date,
!  note that an inference has been made and return.
!  (Except, we don't note which of a pile of identical objects.)


  if (i~=0)
  {   
	if (dont_infer && ~~guessing) 
	{
		
		! we're not guessing. We're always allow to default
		! when we're not guessing
		return i;
	}

	! if we are guessing, we're only allowed to default if list-outcomes made it to true

	if (guessing && (+list-outcomes+) == false)	
	{
		! in which case, we jump to incomplete and act all surprised.

	!	print "[*** Jumping to incomplete due to rubbish matches ***]^";

		jump Incomplete;
	}

! this is where we record that we guessed this one, rather than being told about it
! we need to record this fact for the insertion of "it" that'll happen later, if there's a parse-line
! reconstruction. 

! for a first-pass, let's just set a flag.

      if (inferfrom==0) 
	{
		inferfrom=pcount;
		if (guessing)
		{
			! this was our first point of guesswork on this line, as the interfrom was still zero
			if (parser_trace >= 4) print "[Setting guessed first noun to true]^";
			guessed_first_noun = true;
		}
	}
      pattern-->pcount = i;
      return i;
  }


!  If we get here, there was no obvious choice of object to make.  If in
!  fact we've already gone past the end of the player's typing (which
!  means the match list must contain every object in scope, regardless
!  of its name), then it's foolish to give an enormous list to choose
!  from - instead we go and ask a more suitable question...

! if we're not guessing, but at the end of the line, we still want to add
! extra text to the end of the input, rather that in the middle somewhere
! We have to do these two differently, because of the way text is spliced together

  if (match_from > num_words && ~~guessing) jump Incomplete;

.ListOutPoint;

!  Now we print up the question, using the equivalence classes as worked
!  out by Adjudicate() so as not to repeat ourselves on plural objects...

	BeginActivity(ASKING_WHICH_DO_YOU_MEAN_ACT);
	if (ForActivity(ASKING_WHICH_DO_YOU_MEAN_ACT)) jump SkipWhichQuestionB;


#ifdef NO_SUGGESTIONS;
			ParserMessage(1);
            	if (context==CREATURE_TOKEN) ParserMessage(8); else ParserMessage(9);

#ifnot;

	
	if (number_of_classes > TRUNCATE_LIST || (+list-outcomes+) == false) 
	{		
			ParserMessage(1);
			if (context==CREATURE_TOKEN) ParserMessage(8); else ParserMessage(9);
			jump SkipWhichQuestionB;
	}

	else
	{

		if (context==CREATURE_TOKEN) ParserMessage(2); else ParserMessage(3);

		PrintMatchClasses(match_list, number_of_classes, 0);

		ParserMessage(10);

	}

	.SkipWhichQuestionB; 
	EndActivity(ASKING_WHICH_DO_YOU_MEAN_ACT);

    ! ...and get an answer:


  .WhichOne;
  for (i=2:i<120:i++) buffer2->i=' ';
  answer_words=Keyboard(buffer2, parse2);


  if (guessing==1) jump DoneIncompleteInput;



  first_word=(parse2-->1);

!  Take care of "all", because that does something too clever here to do
!  later on:

  if (first_word == ALL1__WD or ALL2__WD or ALL3__WD or ALL4__WD or ALL5__WD)
  {
      if (MultiContext(context)) ! we stick all of these guys into the multiple object list. Do we really want to do it this way?
						  ! this list just then gets "used" as a normal reply (i guess it's okay; isn't it?!?)
      {   l=multiple_object-->0;
          for (i=0:i<number_matched && l+i<63:i++)
          {   k=match_list-->i;
              multiple_object-->(i+1+l) = k;
          }
          multiple_object-->0 = i+l;   
          rtrue;
      }

	ParserMessage(12);
!      PARSER_CLARIF_INTERNAL_RM('C');
      jump WhichOne;
  }

!  If the first word of the reply can be interpreted as a verb, then
!  assume that the player has ignored the question and given a new
!  command altogether.
!  (This is one time when it's convenient that the directions are
!  not themselves verbs - thus, "north" as a reply to "Which, the north
!  or south door" is not treated as a fresh command but as an answer.)

  #ifdef LanguageIsVerb;
  if (first_word==0)
  {   j = wn; first_word=LanguageIsVerb(buffer2, parse2, 1); wn = j;
  }
  #endif;
    if (first_word ~= 0) {
        j = first_word->#dict_par1;
        if ((0 ~= j&1) && ~~LanguageVerbMayBeName(first_word)) {
            VM_CopyBuffer(buffer, buffer2);
            jump RECONSTRUCT_INPUT;
        }
    }

!  Now we insert the answer into the original typed command, as
!  words additionally describing the same object
!  (eg, > take red button
!       Which one, ...
!       > music
!  becomes "take music red button".  The parser will thus have three
!  words to work from next time, not two.)

    #Ifdef TARGET_ZCODE;
    k = WordAddress(match_from) - buffer; l=buffer2->1+1;
    for (j=buffer + buffer->0 - 1 : j>=buffer+k+l : j-- ) j->0 = 0->(j-l);
    for (i=0 : i<l : i++) buffer->(k+i) = buffer2->(2+i);
    buffer->(k+l-1) = ' ';
    buffer->1 = buffer->1 + l;
    if (buffer->1 >= (buffer->0 - 1)) buffer->1 = buffer->0;
    #Ifnot; ! TARGET_GLULX
    k = WordAddress(match_from) - buffer;
    l = (buffer2-->0) + 1;
    for (j=buffer+INPUT_BUFFER_LEN-1 : j>=buffer+k+l : j-- ) j->0 = j->(-l);
    for (i=0 : i<l : i++) buffer->(k+i) = buffer2->(WORDSIZE+i);
    buffer->(k+l-1) = ' ';
    buffer-->0 = buffer-->0 + l;
    if (buffer-->0 > (INPUT_BUFFER_LEN-WORDSIZE)) buffer-->0 = (INPUT_BUFFER_LEN-WORDSIZE);
    #Endif; ! TARGET_
  


!  Having reconstructed the input, we warn the parser accordingly
!  and get out.

	.RECONSTRUCT_INPUT;

	num_words = WordCount();
    wn = 1;
    #Ifdef LanguageToInformese;
    LanguageToInformese();
    ! Re-tokenise:
    VM_Tokenise(buffer,parse);
    #Endif; ! LanguageToInformese
	num_words = WordCount();
    players_command = 100 + WordCount();
	FollowRulebook(Activity_after_rulebooks-->READING_A_COMMAND_ACT, true);

  return REPARSE_CODE;

!  Now we come to the question asked when the input has run out
!  and can't easily be guessed (eg, the player typed "take" and there
!  were plenty of things which might have been meant).

  .Incomplete;

  	BeginActivity(ASKING_WHICH_DO_YOU_MEAN_ACT);
	if (ForActivity(ASKING_WHICH_DO_YOU_MEAN_ACT)) jump AfterWhichMessage;


      if (context==CREATURE_TOKEN)
      	ParserMessage(4); else ParserMessage(5);

	.AfterWhichMessage;

	EndActivity(ASKING_WHICH_DO_YOU_MEAN_ACT);


 	.AskedIncomplete;

    #Ifdef TARGET_ZCODE;
    for (i=2 : i<INPUT_BUFFER_LEN : i++) buffer2->i=' ';
    #Endif; ! TARGET_ZCODE
    answer_words = Keyboard(buffer2, parse2);


.DoneIncompleteInput;

  first_word=(parse2-->1);
  #ifdef LanguageIsVerb;
  if (first_word==0)
  {   j = wn; first_word=LanguageIsVerb(buffer2, parse2, 1); wn = j;
  }
  #endif;

!  Once again, if the reply looks like a command, give it to the
!  parser to get on with and forget about the question...



  if (first_word ~= 0)
  {   j=first_word->#dict_par1;
      if (0~=j&1)
      {   VM_CopyBuffer(buffer, buffer2);


          return REPARSE_CODE;
      }
  }

!  ...but if we have a genuine answer, then:
!
!  (1) we must glue in text suitable for anything that's been inferred.

    if (inferfrom ~= 0) {
        for (j=inferfrom : j<pcount : j++) {
            if (pattern-->j == PATTERN_NULL) continue;
            #Ifdef TARGET_ZCODE;
            i = 2+buffer->1; (buffer->1)++; buffer->(i++) = ' ';
            #Ifnot; ! TARGET_GLULX
            i = WORDSIZE + buffer-->0;
            (buffer-->0)++; buffer->(i++) = ' ';
            #Endif; ! TARGET_

            #Ifdef DEBUG;
            if (parser_trace >= 5)
            	print "[Gluing in inference with pattern code ", pattern-->j, "]^";
            #Endif; ! DEBUG

            ! Conveniently, parse2-->1 is the first word in both ZCODE and GLULX.

            parse2-->1 = 0;

            ! An inferred object.  Best we can do is glue in a pronoun.
            ! (This is imperfect, but it's very seldom needed anyway.)

! BUG 24/7/10:
! The following code provides for cases where the parser has filled in the first word
! from no input entirely and asked for clarification on the second word.
! It needs to glue something into the "gap" to cover the missing noun, otherwise the 
! line will no longer match.
! Problem is, if the parser had some text here -- which seems to happen in the case
! of an adjudication between identical copy items -- then it shoves "it" on the end, and 
! this fails to match.
! So ideally this block of code will ONLY fire if there was NOTHING in the input line for the first noun.
! How do we check for this? Can we use one of the guessing-type flags set above??

! First pass: get something to print out which case we're in
! Tests are : >GIVE ITEM X / >PERSON Y when the player has 2 Xs
! SNARK / > PERSON Y, when there is a rule for "Suggesting" item X for snarking (no duplicate X required.)

            if (pattern-->j >= 2 && pattern-->j < REPARSE_CODE)
		{
			if (guessed_first_noun)
			{
	                PronounNotice(pattern-->j);
       	        for (k=1 : k<=LanguagePronouns-->0 : k=k+3)
              	      if (pattern-->j == LanguagePronouns-->(k+2)) {
                     	   parse2-->1 = LanguagePronouns-->k;
                        		#Ifdef DEBUG;
                        		if (parser_trace >= 4)
                        			print "[Using pronoun as guessed_first was true.]^";
                        		if (parser_trace >= 5)
                        			print "[Using pronoun '", (address) parse2-->1, "']^";
                        		#Endif; ! DEBUG
                       	   break;
                    }
			else if (parser_trace >=4 ) print "[Not using pronoun as guessed_first was false.]^";
		}
            }
            else {
                ! An inferred preposition.
                parse2-->1 = VM_NumberToDictionaryAddress(pattern-->j - REPARSE_CODE);
                #Ifdef DEBUG;
                if (parser_trace >= 5)
                	print "[Using preposition '", (address) parse2-->1, "']^";
                #Endif; ! DEBUG
            }

            ! parse2-->1 now holds the dictionary address of the word to glue in.

            if (parse2-->1 ~= 0) {
                k = buffer + i;
                #Ifdef TARGET_ZCODE;
                @output_stream 3 k;
                 print (address) parse2-->1;
                @output_stream -3;
                k = k-->0;
                for (l=i : l<i+k : l++) buffer->l = buffer->(l+2);
                i = i + k; buffer->1 = i-2;
                #Ifnot; ! TARGET_GLULX
                k = Glulx_PrintAnyToArray(buffer+i, INPUT_BUFFER_LEN-i, parse2-->1);
                i = i + k; buffer-->0 = i - WORDSIZE;
                #Endif; ! TARGET_
            }
        }
    }

!  (2) we must glue the newly-typed text onto the end.

    #Ifdef TARGET_ZCODE;
    i = 2+buffer->1; (buffer->1)++; buffer->(i++) = ' ';
    for (j=0 : j<buffer2->1 : i++,j++) {
        buffer->i = buffer2->(j+2);
        (buffer->1)++;
        if (buffer->1 == INPUT_BUFFER_LEN) break;
    }
    #Ifnot; ! TARGET_GLULX
    i = WORDSIZE + buffer-->0;
    (buffer-->0)++; buffer->(i++) = ' ';
    for (j=0 : j<buffer2-->0 : i++,j++) {
        buffer->i = buffer2->(j+WORDSIZE);
        (buffer-->0)++;
        if (buffer-->0 == INPUT_BUFFER_LEN) break;
    }
    #Endif; ! TARGET_

    ! (3) we fill up the buffer with spaces, which is unnecessary, but may
    !     help incorrectly-written interpreters to cope.

    #Ifdef TARGET_ZCODE;
    for (: i<INPUT_BUFFER_LEN : i++) buffer->i = ' ';
    #Endif; ! TARGET_ZCODE


    return REPARSE_CODE;

];



[ PrintMatchClasses ar max imark i marker k ;
!print "(max ", max, " imark ", imark, ")^";
    marker = imark;
    for (i=1 : i<=max : i++) {
        while (((match_classes-->marker) ~= i) && ((match_classes-->marker) ~= -i))
	  {
!		print match_classes-->marker, " / from marker ", marker, "^";
		marker++;
	  }
        k = ar-->marker;

        if (match_classes-->marker > 0) print (the) k; else print (a) k;

        if (i < max-1)  print ", ";
        if (i == max-1) {
			#Ifdef SERIAL_COMMA;
			print ",";
        	#Endif; ! SERIAL_COMMA
       	PARSER_CLARIF_INTERNAL_RM('H');
        }
    }
 ];

[ PARSER_CLARIF_INTERNAL_R; ];

-) instead of "Noun Domain" in "Parser.i6t".



chapter - adjudicate 

[

 Edited to provide better multiple object error behaviour. 

]

Include (-

[ BestScore its_score best i;
    best = -1000;
    for (i=0 : i<number_matched : i++) {
        its_score = match_scores-->i; if (its_score > best) best = its_score; 
    }
    return best;
];

[ Adjudicate context i j k good_flag good_ones last n ultimate flag offset  best_score;


    #Ifdef DEBUG;
    if (parser_trace >= 4) {
        print "   [Adjudicating match list of size ", number_matched,
        	" in context ", context, "^";
        print "   ";
        if (indef_mode) {
            print "indefinite type: ";
            if (indef_type & OTHER_BIT)  print "other ";
            if (indef_type & MY_BIT)     print "my ";
            if (indef_type & THAT_BIT)   print "that ";
            if (indef_type & PLURAL_BIT) print "plural ";
            if (indef_type & LIT_BIT)    print "lit ";
            if (indef_type & UNLIT_BIT)  print "unlit ";
            if (indef_owner ~= 0) print "owner:", (name) indef_owner;
            new_line;
            print "   number wanted: ";
            if (indef_wanted == 100) print "all"; else print indef_wanted;
            new_line;
            print "   most likely GNAs of names: ", indef_cases, "^";
        }
        else print "definite object^";
    }
    #Endif; ! DEBUG

    j = number_matched-1; good_ones = 0; last = match_list-->0;
    for (i=0 : i<=j : i++) {
        n = match_list-->i;
        match_scores-->i = good_ones;
        ultimate = ScopeCeiling(n);

        if (context==HELD_TOKEN && parent(n)==actor)
        {   good_ones++; last=n; }

        if (context==MULTI_TOKEN && ultimate==ScopeCeiling(actor)
            && n~=actor && n hasnt concealed !&& n hasnt scenery
		) 
        {   good_ones++; last=n; }

        if (context==MULTIHELD_TOKEN && parent(n)==actor)
        {   good_ones++; last=n; }

        if (context==MULTIEXCEPT_TOKEN or MULTIINSIDE_TOKEN)
        {   if (advance_warning==-1)
            {   if (context==MULTIEXCEPT_TOKEN)
                {   good_ones++; last=n;
                 }
                if (context==MULTIINSIDE_TOKEN)
                {   if (parent(n)~=actor) { good_ones++; last=n; }
                 }
            }
            else
            {   if (context==MULTIEXCEPT_TOKEN && n~=advance_warning)
                {   good_ones++; last=n; }
                if (context==MULTIINSIDE_TOKEN && n in advance_warning)
                {   good_ones++; last=n; }
            }
         }
        if (context==CREATURE_TOKEN && CreatureTest(n)==1)
        {   good_ones++; last=n; }
        
        match_scores-->i = 1000*(good_ones - match_scores-->i);
    }

    if (good_ones == 1)
	{	
		! these are good, regardless of our rules (this is duplication, but it'll do for now)

		(+list-outcomes+) = true;		

		 return last;
	}

  ! If there is ambiguity about what was typed, but it definitely wasn't
  ! animate as required, then return anything; higher up in the parser
  ! a suitable error will be given.  (This prevents a question being asked.)
  ! if (context==CREATURE_TOKEN && good_ones==0) return match_list-->0;

  	if (indef_mode==0) indef_type=0;

	ScoreMatchL(context);
	if (number_matched == 0) return -1;

	!print "(Made ", number_matched, " indef ", indef_mode, " & ", indef_wanted, ".^";
 
  if (indef_mode == 0 && guessing == false)
  {   !  Is there now a single highest-scoring object?
      i = SingleBestGuess();
      if (i >= 0)
      {
#ifdef DEBUG;
          if (parser_trace>=4)
              print "   Single best-scoring object returned.]^";
#endif;
          return i;
      }
  }

  best_score = BestScore();

 ! ------If we've made a multiple object we investigate it, term by term, to check that everything in it should be in it
 !         note that we load up the multiple object list not from 0 but from wherever it happens to be
 ! 	   and, even worse, we load it up out of order, chuck away the match list scores and chuck away the match list itself
 ! 	   and the only ray of hope in all this is it assembles the multiple object list in order of preference
 !	   (although why it does that I have no idea, because I'm sure all this info is later ignored.)


  

  if (indef_mode==1 && indef_type & PLURAL_BIT ~= 0)
  {

#ifndef PUT_IN_FOR_NOW;

	if (~~MultiContext(context)) 
	{
		indef_mode = 0; !print "JUMPING MULTI";
		jump PostMultiObject; 
	}


#endif;

!print "DOING MULTI";

      i=0; offset=multiple_object-->0; 
      for (j=BestGuess():j~=-1 && i<indef_wanted
           && i+offset<63:j=BestGuess())
      {   flag=0;


	
	            BeginActivity(DECIDING_WHETHER_ALL_INC_ACT, j);
	            if ((ForActivity(DECIDING_WHETHER_ALL_INC_ACT, j)) == 0) {

        	  if (j hasnt concealed && j hasnt worn) flag=1;

       		   if (context==MULTIHELD_TOKEN or MULTIEXCEPT_TOKEN
       	      		 && parent(j)~=actor) flag=0;
	       	   if (action_to_be == ##Take or ##Remove && parent(j)==actor) flag=0;

        	  k=ChooseObjects(j,flag);
	
	          if (k==1) flag=1; else { if (k==2) flag=0; }
	
	            } else {
	                flag = 0; if (RulebookSucceeded()) flag = 1;
	            }
	            EndActivity(DECIDING_WHETHER_ALL_INC_ACT, j);



          if (flag==1)
          {   i++; multiple_object-->(i+offset) = j;
#ifdef DEBUG;
              if (parser_trace>=4) print "   Accepting it^";
#endif;
          }
          else
          {   i=i;
#ifdef DEBUG;
              if (parser_trace>=4) print "   Rejecting it^";
#endif;
          }
      }
      if (i<indef_wanted && indef_wanted<100)
      {   etype=TOOFEW_PE; multi_wanted=indef_wanted;
          multi_had=i;
          return -1;
      }
      multiple_object-->0 = i+offset;
      multi_context=context;
#ifdef DEBUG;
      if (parser_trace>=4)
          print "   Made multiple object of size ", i, "]^";
#endif;
      return 1;
  }


.PostMultiObject;

! We set match classes in a routine so we can do it again below

		n =	SetMatchClasses(match_list, 0, number_matched);


#ifdef DEBUG;
  if (parser_trace>=4)
  {   print "  ** Grouped into ", n, " possibilities by name:^";
      for (i=0:i<number_matched:i++)
          if (match_classes-->i > 0)
              print "   ", (The) match_list-->i,
                  " (", match_list-->i, ")  ---  group ",
                  match_classes-->i, "^";
  }
#endif;


  if (indef_mode == 0)
  {   if (n > 1)
      {   k = -1;
          for (i=0:i<number_matched:i++)
          {   if (match_scores-->i > k)
              {   k = match_scores-->i;                ! current highest
                  j = match_classes-->i; j=j*j;        ! j = classes^2 ?!? (fix sign?)
                  flag = 0;
              }
              else
              if (match_scores-->i == k)                ! we found a draw
              {   if ((match_classes-->i) * (match_classes-->i) ~= j)
                      flag = 1;                                 ! we found a different class
              }
          }
          if (flag)
          {
#ifdef DEBUG;
              if (parser_trace>=4)
                  print "   Unable to choose best group, so ask player.]^";
#endif;

!                  if (guessing)
!                  {
#ifdef DEBUG;
              if (parser_trace>=4)
                    print "[Highest score ", k, " -- deleting all lower scores.]^";
#endif;

                     for (i=0:i<number_matched:i++)
                      {   while (match_scores-->i < k)
                          {   if (i == number_matched-1) { number_matched--; break; }
                              for (j=i:j<number_matched:j++)
                              {   match_list-->j = match_list-->(j+1);
                                  match_scores-->j = match_scores-->(j+1);
                              }
                              number_matched--;
                          }
                      }

#ifdef DEBUG;
              if (parser_trace>=4)
                       print "[", number_matched, " entries remaining.]^";
#endif;
		
			SetMatchClasses(match_list, 0, number_matched);
!                  }
              return 0;
          }

#ifdef DEBUG;
          if (parser_trace>=4)
              print "   Best choices are all from the same group.^";
#endif;
      }
  }

!  When the player is really vague, or there's a single collection of
!  indistinguishable objects to choose from, choose the one the player
!  most recently acquired, or if the player has none of them, then
!  the one most recently put where it is.

  !if (n == 1) dont_infer = true;
  return BestGuess();
];




[ SetMatchClasses ar st en max i n flag j;
	max = en + st - 1;

  for (i = st :i <= max  :i++) match_classes-->i=0;

  n=1;
  for (i = st :i <= max : i++)
      if (match_classes-->i==0)
      {   match_classes-->i=n++; flag=0; 
          for (j=i+1 : j<=max : j++)
              if (match_classes-->j==0
                  && Identical(ar-->i, ar-->j)==1)
              {   flag=1; 
                  match_classes-->j=match_classes-->i;
              }
          if (flag==1) match_classes-->i = 1-n;
      }
  n--; number_of_classes = n;
  return n;
];



-) instead of "Adjudicate" in "Parser.i6t".


Section - ScoreMatchL

Include (-

Constant SCORE__CHOOSEOBJ = 1000;
Constant SCORE__IFGOOD = 500;
Constant SCORE__UNCONCEALED = 100;
Constant SCORE__BESTLOC = 60;
Constant SCORE__NEXTBESTLOC = 40;
Constant SCORE__NOTCOMPASS = 20;
Constant SCORE__NOTSCENERY = 10;
Constant SCORE__NOTACTOR = 5;
Constant SCORE__GNA = 1;
Constant SCORE__DIVISOR = 20;

Constant PREFER_HELD;

[ ScoreMatchL context its_owner its_score obj i j threshold met a_s l_s fda ;

!   if (indef_type & OTHER_BIT ~= 0) threshold++;
    if (indef_type & MY_BIT ~= 0)    threshold++;
    if (indef_type & THAT_BIT ~= 0)  threshold++;
    if (indef_type & LIT_BIT ~= 0)   threshold++;
    if (indef_type & UNLIT_BIT ~= 0) threshold++;
    if (indef_owner ~= nothing)      threshold++;

    #Ifdef DEBUG;
    if (parser_trace >= 4) print "   Scoring match list: indef mode ", indef_mode, " type ",
      indef_type, ", satisfying ", threshold, " requirements:^";
    #Endif; ! DEBUG

    #ifdef PREFER_HELD;
    a_s = SCORE__BESTLOC; l_s = SCORE__NEXTBESTLOC;
    if (action_to_be == ##Take or ##Remove) {
        a_s = SCORE__NEXTBESTLOC; l_s = SCORE__BESTLOC;
    }
    context = context;  ! silence warning
    #ifnot;
    a_s = SCORE__NEXTBESTLOC; l_s = SCORE__BESTLOC;
    if (context == HELD_TOKEN or MULTIHELD_TOKEN or MULTIEXCEPT_TOKEN) {
        a_s = SCORE__BESTLOC; l_s = SCORE__NEXTBESTLOC;
    }
    #endif; ! PREFER_HELD


  for (i=0: i<number_matched: i++) {
      obj = match_list-->i; its_owner = parent(obj); its_score=0;

!      if (indef_type & OTHER_BIT ~=0
!          &&  obj~=itobj or himobj or herobj) met++;
      if (indef_type & MY_BIT ~=0  &&  its_owner==actor) met++;
      if (indef_type & THAT_BIT ~=0  &&  its_owner==actors_location) met++;
      if (indef_type & LIT_BIT ~=0  &&  obj has light) met++;
      if (indef_type & UNLIT_BIT ~=0  &&  obj hasnt light) met++;
      if (indef_owner~=0 && its_owner == indef_owner) met++;

      if (met < threshold)
      {
#ifdef DEBUG;
          if (parser_trace >= 4)
              print "   ", (The) match_list-->i,
                    " (", match_list-->i, ") in ", (the) its_owner,
                    " is rejected (doesn't match descriptors)^";
#endif;
          match_list-->i=-1;
      }
      else
      {   its_score = 0;



		fda = ChooseObjects(obj, 2, context);
		if (fda > -1) its_score = SCORE__CHOOSEOBJ * fda;
		else match_list-->i = -1;

          if (obj hasnt concealed) its_score = its_score + SCORE__UNCONCEALED;

          if (its_owner==actor)   its_score = its_score + a_s;
          else
          if (its_owner==actors_location) its_score = its_score + l_s;
          else
          if (its_owner~=compass) its_score = its_score + SCORE__NOTCOMPASS;
	

          if (obj hasnt scenery) its_score = its_score + SCORE__NOTSCENERY;
          if (obj ~= actor) its_score = its_score + SCORE__NOTACTOR;

          !   A small bonus for having the correct GNA,
          !   for sorting out ambiguous articles and the like.

          if (indef_cases & (PowersOfTwo_TB-->(GetGNAOfObject(obj))))
              its_score = its_score + SCORE__GNA;



          match_scores-->i = match_scores-->i + its_score;

#ifdef DEBUG;
          if (parser_trace >= 4)
	{
		
	              print "     ", (The) obj,
                    " (", obj, ") in ", (the) its_owner;
		if (match_list-->i == -1) print " :  deleted by ChooseObjects^";
		else print " : ", match_scores-->i, " points^";
	}
#endif;
      }
  }



! remove dead entries from the match list

  for (i=0:i<number_matched:i++)
  {   while (match_list-->i == -1)
      {   if (i == number_matched-1) { number_matched--; break; }
          for (j=i:j<number_matched:j++)
          {   match_list-->j = match_list-->(j+1);
              match_scores-->j = match_scores-->(j+1);              
          }
          number_matched--;
      }
  }


if (guessing == true || (guessing == false && ChooseObjectsBypassDisambiguate()))
  for (i=0: i<number_matched:i++)
  { 
	if (match_list-->i~=-1)
	{	! we need to rescore everything using the more straightforward system
		! this gives scores for everything except actor's held / player held, which tends to separate stuff out

		its_score = 0;
		obj = match_list-->i; 

		its_owner = parent(obj);	 

		fda = ChooseObjects(obj, 2, context);
		if (fda > -1) its_score = its_score + SCORE__CHOOSEOBJ * fda;

          if (obj hasnt concealed) its_score = its_score +  SCORE__UNCONCEALED;

          if (its_owner~=compass) its_score = its_score + SCORE__NOTCOMPASS;

   !       if (obj hasnt scenery) its_score = its_score + SCORE__NOTSCENERY;
          if (obj ~= actor) its_score = its_score + SCORE__NOTACTOR;

          !   A small bonus for having the correct GNA,
          !   for sorting out ambiguous articles and the like.

          if (indef_cases & (PowersOfTwo_TB-->(GetGNAOfObject(obj))))
              its_score = its_score + SCORE__GNA;

          match_scores-->i = its_score;
#ifdef DEBUG;
          if (parser_trace >= 4)
              print "     ", (The) match_list-->i,
                    " (", match_list-->i, ") rescored at: ", match_scores-->i, " points^";
#endif;
	
	
	}

  }




];

-) instead of "ScoreMatchL" in "Parser.i6t".


Section - Descriptors

Include (-

Global mf;

[ Descriptors allow_multiple  o x flag cto type n;

 mf = 0;

   ResetDescriptors();
   if (wn > num_words) return 0;

   for (flag=true:flag:)
   {   o=NextWordStopped(); flag=false;

       for (x=1:x<=LanguageDescriptors-->0:x=x+4)
           if (o == LanguageDescriptors-->x)
           {   flag = true;
               type = LanguageDescriptors-->(x+2);
               if (type ~= DEFART_PK) indef_mode = true;
               indef_possambig = true;
               indef_cases = indef_cases & (LanguageDescriptors-->(x+1));

               if (type == POSSESS_PK)
               {   cto = LanguageDescriptors-->(x+3);
                   switch(cto)
                   {  0: indef_type = indef_type | MY_BIT;
                      1: indef_type = indef_type | THAT_BIT;
                      default: indef_owner = PronounValue(cto);
                        if (indef_owner == NULL) indef_owner = InformParser;
                   }
               }

               if (type == light)
                   indef_type = indef_type | LIT_BIT;
               if (type == -light)
                   indef_type = indef_type | UNLIT_BIT;
           }

       if (o==OTHER1__WD or OTHER2__WD or OTHER3__WD)
                            { indef_mode=1; flag=1;
                              indef_type = indef_type | OTHER_BIT; }
       if (o==ALL1__WD or ALL2__WD or ALL3__WD or ALL4__WD or ALL5__WD)
                            { indef_mode=1; flag=1; indef_wanted=100;
                              if (take_all_rule == 1)
                                  take_all_rule = 2;
                              indef_type = indef_type | PLURAL_BIT; 
                              if (mf==0) mf = wn-1;
                            }
       if (allow_plurals && allow_multiple)
       {   n=TryNumber(wn-1);
           if (n==1)        { indef_mode=1; flag=1; }
           if (n>1)         { indef_guess_p=1;
                              indef_mode=1; flag=1; indef_wanted=n;
                              indef_nspec_at=wn-1;
                              indef_type = indef_type | PLURAL_BIT;
                              if (mf==0) mf = wn-1;
                            }
       }
       if (flag==1
           && NextWordStopped() ~= OF1__WD or OF2__WD or OF3__WD or OF4__WD)
           wn--;  ! Skip 'of' after these
   }
   wn--;

!   if ((indef_wanted > 0) && (~~allow_multiple)) return MULTI_PE;

   return 0;
];

[ SafeSkipDescriptors;
	@push indef_mode; @push indef_type; @push indef_wanted;
	@push indef_guess_p; @push indef_possambig; @push indef_owner;
	@push indef_cases; @push indef_nspec_at;
	
	Descriptors();
	
	@pull indef_nspec_at; @pull indef_cases;
	@pull indef_owner; @pull indef_possambig; @pull indef_guess_p;
	@pull indef_wanted; @pull indef_type; @pull indef_mode;
];

-) instead of "Parsing Descriptors" in "Parser.i6t".


Section - Parser Lookaheads should tell Choose Objects to behave differently

Include (-

        advance_warning = -1; indef_mode = false;
        for (i=0,m=false,pcount=0 : line_token-->pcount ~= ENDIT_TOKEN : pcount++) {
            scope_token = 0;

            if (line_ttype-->pcount ~= PREPOSITION_TT) i++;

            if (line_ttype-->pcount == ELEMENTARY_TT) {
                if (line_tdata-->pcount == MULTI_TOKEN) m = true;
                if (line_tdata-->pcount == MULTIEXCEPT_TOKEN or MULTIINSIDE_TOKEN  && i == 1) {
                    ! First non-preposition is "multiexcept" or
                    ! "multiinside", so look ahead.


                    #Ifdef DEBUG;
                    if (parser_trace >= 2) print " [Trying look-ahead]^";
                    #Endif; ! DEBUG

                    ! We need this to be followed by 1 or more prepositions.

                    pcount++;
                    if (line_ttype-->pcount == PREPOSITION_TT) {
                        ! skip ahead to a preposition word in the input
                        do {
                            l = NextWord();
                        } until ((wn > num_words) ||
                                 (l && (l->#dict_par1) & 8 ~= 0));
                        
                        if (wn > num_words) {
                            #Ifdef DEBUG;
                            if (parser_trace >= 2)
                                print " [Look-ahead aborted: prepositions missing]^";
                            #Endif;
                            jump LineFailed;
                        }
                        
                        do {
                            if (PrepositionChain(l, pcount) ~= -1) {
                                ! advance past the chain
                                if ((line_token-->pcount)->0 & $20 ~= 0) {
                                    pcount++;
                                    while ((line_token-->pcount ~= ENDIT_TOKEN) &&
                                           ((line_token-->pcount)->0 & $10 ~= 0))
                                        pcount++;
                                } else {
                                    pcount++;
                                }
                            } else {
                                ! try to find another preposition word
                                do {
                                    l = NextWord();
                                } until ((wn >= num_words) ||
                                         (l && (l->#dict_par1) & 8 ~= 0));
                                
                                if (l && (l->#dict_par1) & 8) continue;
                                
                                ! lookahead failed
                                #Ifdef DEBUG;
                                if (parser_trace >= 2)
                                    print " [Look-ahead aborted: prepositions don't match]^";
                                #endif;
                                jump LineFailed;
                            }
                            l = NextWord();
                        } until (line_ttype-->pcount ~= PREPOSITION_TT);
                        
                        ! put back the non-preposition we just read
                        wn--;

                        if ((line_ttype-->pcount == ELEMENTARY_TT) &&
                        	(line_tdata-->pcount == NOUN_TOKEN)) {
                            l = Descriptors();  ! skip past THE etc
                            if (l~=0) etype=l;  ! don't allow multiple objects

	! set flags for choose objects to use
					look_ahead = true;
					cobj_flag = 0;
					
				
                            l = NounDomain(actors_location, actor, NOUN_TOKEN);
	
	! unset them again, so we can pretend this never happened
					look_ahead = 0;
					cobj_flag = 0;

                            #Ifdef DEBUG;
                            if (parser_trace >= 2) {
                                print " [Advanced to ~noun~ token: ";
                                if (l == REPARSE_CODE) print "re-parse request]^";
                                if (l == 1) print "but multiple found]^";
                                if (l == 0) print "error ", etype, "]^";
                                if (l >= 2) print (the) l, "]^";
                            }
                            #Endif; ! DEBUG
                            if (l == REPARSE_CODE) jump ReParse;
                            if (l >= 2) advance_warning = l;
                        }
                    }
                    break;
                }
            }
        }

        ! Slightly different line-parsing rules will apply to "take multi", to
        ! prevent "take all" behaving correctly but misleadingly when there's
        ! nothing to take.

        take_all_rule = 0;
        if (m && params_wanted == 1 && action_to_be == ##Take)
            take_all_rule = 1;

        ! And now start again, properly, forearmed or not as the case may be.
        ! As a precaution, we clear all the variables again (they may have been
        ! disturbed by the call to NounDomain, which may have called outside
        ! code, which may have done anything!).

        inferfrom = 0;
        parameters = 0;
        nsns = 0; special_word = 0;
        multiple_object-->0 = 0;
        etype = STUCK_PE;
        wn = verb_wordnum+1;

-) instead of "Parser Letter F" in "Parser.i6t".


Section - reset cobj_flags on reparsing (the library should do this anyway, I think)

Include (-

    if (held_back_mode == 1) {
        held_back_mode = 0;
        VM_Tokenise(buffer, parse);
        jump ReParse;
    }

  .ReType;
	cobj_flag = 0;
    BeginActivity(READING_A_COMMAND_ACT); if (ForActivity(READING_A_COMMAND_ACT)==false) {
		Keyboard(buffer,parse);

		players_command = 100 + WordCount();
		num_words = WordCount();

    } if (EndActivity(READING_A_COMMAND_ACT)) jump ReType;

  .ReParse;

	! added in for the purposes of the bug fix
	guessed_first_noun = false;
	cobj_flag = 0;
    	parser_inflection = name;

    ! Initially assume the command is aimed at the player, and the verb
    ! is the first word

    num_words = WordCount();
    wn = 1;

    #Ifdef LanguageToInformese;
    LanguageToInformese();
    ! Re-tokenise:
    VM_Tokenise(buffer,parse);
    #Endif; ! LanguageToInformese


    num_words = WordCount();

    k=0;
    #Ifdef DEBUG;
    if (parser_trace >= 2) {
        print "[ ";
        for (i=0 : i<num_words : i++) {

            #Ifdef TARGET_ZCODE;
            j = parse-->(i*2 + 1);
            #Ifnot; ! TARGET_GLULX
            j = parse-->(i*3 + 1);
            #Endif; ! TARGET_
            k = WordAddress(i+1);
            l = WordLength(i+1);
            print "~"; for (m=0 : m<l : m++) print (char) k->m; print "~ ";

            if (j == 0) print "?";
            else {
                #Ifdef TARGET_ZCODE;
                if (UnsignedCompare(j, HDR_DICTIONARY-->0) >= 0 &&
                    UnsignedCompare(j, HDR_HIGHMEMORY-->0) < 0)
                     print (address) j;
                else print j;
                #Ifnot; ! TARGET_GLULX
                if (j->0 == $60) print (address) j;
                else print j;
                #Endif; ! TARGET_
            }
            if (i ~= num_words-1) print " / ";
        }
        print " ]^";
    }
    #Endif; ! DEBUG
    verb_wordnum = 1;
    actor = player;
    actors_location = ScopeCeiling(player);
    usual_grammar_after = 0;

  .AlmostReParse;

    scope_token = 0;
    action_to_be = NULL;

    ! Begin from what we currently think is the verb word

  .BeginCommand;

    wn = verb_wordnum;
    verb_word = NextWordStopped();

    ! If there's no input here, we must have something like "person,".

    if (verb_word == -1) {
        best_etype = STUCK_PE;
        jump GiveError;
    }

    ! Now try for "again" or "g", which are special cases: don't allow "again" if nothing
    ! has previously been typed; simply copy the previous text across


    if (verb_word == AGAIN2__WD or AGAIN3__WD) verb_word = AGAIN1__WD;
    if (verb_word == AGAIN1__WD) {
        if (actor ~= player) {
            best_etype = ANIMAAGAIN_PE;
            jump ReType;
        }
        #Ifdef TARGET_ZCODE;
        if (buffer3->1 == 0) {
           PARSER_COMMAND_INTERNAL_RM('D'); new_line;
            jump ReType;
        }
        #Ifnot; ! TARGET_GLULX
        if (buffer3-->0 == 0) {
            PARSER_COMMAND_INTERNAL_RM('D'); new_line;
            jump ReType;
        }
        #Endif; ! TARGET_
        for (i=0 : i<INPUT_BUFFER_LEN : i++) buffer->i = buffer3->i;
        VM_Tokenise(buffer,parse);
		num_words = WordCount();
    	players_command = 100 + WordCount();
		jump ReParse;
    }



    ! Save the present input in case of an "again" next time

    if (verb_word ~= AGAIN1__WD)
        for (i=0 : i<INPUT_BUFFER_LEN : i++) buffer3->i = buffer->i;

    if (usual_grammar_after == 0) {
        j = verb_wordnum;
        i = RunRoutines(actor, grammar); 
        #Ifdef DEBUG;
        if (parser_trace >= 2 && actor.grammar ~= 0 or NULL)
            print " [Grammar property returned ", i, "]^";
        #Endif; ! DEBUG

        if ((i ~= 0 or 1) && (VM_InvalidDictionaryAddress(i))) {
            usual_grammar_after = verb_wordnum; i=-i;
        }

        if (i == 1) {
            parser_results-->0 = action;
            parser_results-->1 = noun;
            parser_results-->2 = second;
            rtrue;
        }
        if (i ~= 0) { verb_word = i; wn--; verb_wordnum--; }
        else { wn = verb_wordnum; verb_word = NextWord(); }
    }
    else usual_grammar_after = 0;


-) instead of "Parser Letter A" in "Parser.i6t".





[ ************************************************************************************************************************************************************ ]

Volume - the System for Disambiguation


Book - Choose Objects entrypoint

Chapter - replacing I7's choose objects routine

Matching a creature token is a truth state that varies.

List-outcomes is a truth state that varies.

Include (-



Constant COBJ_BITS_SIZE = (MATCH_LIST_WORDS*MATCH_LIST_WORDS/8);

! the highest value returned by CheckDPMR (see the Standard Rules)
Constant HIGHEST_DPMR_SCORE = 9;

Array alt_match_list --> (MATCH_LIST_WORDS+1);

#ifdef TARGET_GLULX;
[ COBJ__Copy words from to  i;
	for (i=0: i<words: i++)
		to-->i = from-->i;
];
#ifnot;
[ COBJ__Copy words from to  bytes;
	bytes = words * 2;
	@copy_table from to bytes;
];
#endif;

! swap alt_match_list with match_list/number_matched
[ COBJ__SwapMatches i x;
	! swap the counts
	x = number_matched;
	number_matched = alt_match_list-->0;
	alt_match_list-->0 = x;
	! swap the values
	if (x < number_matched) x = number_matched;
	for (i=x: i>0: i-- ) {
		x = match_list-->(i-1);
		match_list-->(i-1) = alt_match_list-->i;
		alt_match_list-->i = x;
	}
];



! ChooseObjects comes with three strategies:
! 1)   	We're trying the first noun of a line like TAKE FISH WITH POLE, with the query on the first noun.
!			We use scope/matching to build a list of possible second nouns, and loop across all of them, collecting the best score
! 2)		We're doing nothing complicated: either TAKE ROCK, or TAKE ROCK WITH MAGNET with the query on the second noun
!			We just build an action pattern and try it.	
! 3)		We're doing the reverse of 1 - the query is on the second noun, but the first noun is variable
!			Either because we're doing a lookahead (PUT CAT IN BAG checks BAG before CAT)
!			or we're looking at a multiple object (GIVE ALL TO JIM or GIVE COINS TO JIM)


[ ChooseObjects obj code context  l i swn spcount a b c old_ad otf gdata;


	#ifdef COBJ_DEBUG;
 		print "(entering with ", (the) obj, " and flag ", cobj_flag, " lookahead? ", look_ahead, ")^";
	#endif;


! we ditch the no-object tracking object immediately
	if (obj == (+no-object+)) return -1;

! we record this for use by the expectation rules - currently redundant, but may well reappear

	if (context == CREATURE_TOKEN) 
		(+matching a creature token+) = 1;
	else 
		(+matching a creature token+) = 0;
	
! we shouldn't really be here under I7 rules with an all...
	if (code<2) rfalse;

! by default, the smart score should be always ignore 
	c = -1;

!	if  multiple object exists for the first parameter and we're now looking for the second
! 	then copy the mult into the alt list, and use code 3

	if (parameters > 0  && multiple_object-->0 > 0)
	{
		#ifdef COBJ_DEBUG;
			print "[We've found a multiple list in the first object.]^";
		#endif;
	
		CopyMultipleObjectList();
		cobj_flag = 3;
	}

	if (cobj_flag == 1 && parameters > 0)
	{
		#ifdef COBJ_DEBUG;
			print "[now scoring the second: drop into simple mode.]^";
		#endif;
		cobj_flag = 2;
	}

	if (cobj_flag == 1) 
	{
		.CodeOne;
		if (parameters > 0) 
			print_ret "[Bug in C-Ob: this should be unreachable. (Are we here directly from a jump statement?]^";

			#ifdef COBJ_DEBUG;
				print "[scoring ", (the) obj, " (first) in ", alt_match_list-->0, " combinations]^";
			#endif;

			return ScoreCombos(0, 1, obj, context);
	}


	if (cobj_flag == 2) {
	
	!Works for TAKE FISH(?) or WEAR HAT(?)
	! also TIE FISH(!) TO CARPET(?)
	!Both occasions we know everything we need to in advance

		.CodeTwo;
		#ifdef COBJ_DEBUG;
			print "[scoring ", (the) obj, " (simple)]^";
		#endif;
		if (parameters==0)
		{	
			b = GuessScoreDabCombo(obj, 0, context, 1);
			c = SmartScoreDabCombo(obj, 0);
		}
		else
		{
			b =  GuessScoreDabCombo(parser_results-->2, obj, context, 2);
			c =  SmartScoreDabCombo(parser_results-->2, obj);
		}
		return ResolveChooseScores(b, c);
	}


	if (cobj_flag == 3)
	{
! we loop over the possible first nouns and score them
! same as code 1 above only backwards!

		.CodeThree;
	
			#ifdef COBJ_DEBUG;
				print "[scoring ", alt_match_list-->0, " combinations for ", (the) obj, " (second)^";
			#endif;

			return ScoreCombos(-1, 2, obj, context); ! testing for no. two
	}

	.ChooseStrategy;
	#ifdef COBJ_DEBUG;
		print "[choosing a cobj strategy: ";
	#endif;

	swn = wn;
	spcount = pcount;

	if (look_ahead ~= 0)
	{
		wn = verb_wordnum + 1; 
		pcount = 0;

		SkipPrepositions();

		if ((line_ttype-->pcount == ELEMENTARY_TT or ATTR_FILTER_TT or ROUTINE_FILTER_TT) && (
						line_tdata-->pcount ~= SPECIAL_TOKEN  or NUMBER_TOKEN   or TOPIC_TOKEN  or ENDIT_TOKEN
							)) 
		{

			! Advance past the prepositions in the input
			while (wn < swn-1) 
			{

				l = NextWord(); 	
				if ( 		l && (l->#dict_par1) &8 == 0	)				! if *not* preposition
				{
					if (l == ALL1__WD or ALL2__WD or ALL3__WD or ALL4__WD or ALL5__WD) 
					{
						CreateAltList();
						#ifdef COBJ_DEBUG;
							print "all generated ", alt_match_list-->0, " possible first nouns]^";
						#endif;

					}
					else
					{
						wn--;

	                              BuildTheLookAheadList();

						#ifdef COBJ_DEBUG;
							print alt_match_list-->0, " possible first nouns]^";
						#endif;
					}					
			
					wn = swn;
					pcount = spcount;
					cobj_flag = 3;
					jump CodeThree;				
				}
			}
		}
		
		print "[Lookahead mode failed to achieve anything. Not sure how this is possible?]^";	

	}

	! so now we just look ahead ourselves and see what happens next in the grammar line

	if (line_ttype-->pcount == PREPOSITION_TT or ELEMENTARY_TT or ROUTINE_FILTER_TT or ATTR_FILTER_TT) 
	{
		SkipPrepositions();
		if ((line_ttype-->pcount == ELEMENTARY_TT or ROUTINE_FILTER_TT or ATTR_FILTER_TT) && (

				line_tdata-->pcount ~= SPECIAL_TOKEN  or NUMBER_TOKEN   or TOPIC_TOKEN  or ENDIT_TOKEN

							)) 
		{
			! Advance past the last preposition
			while (wn < num_words)
			{
				l = NextWord();
				if ( l && (l->#dict_par1) &8 ) 		! if preposition
				{	

					if (l == ALL1__WD or ALL2__WD or ALL3__WD or ALL4__WD or ALL5__WD) continue;

                              BuildtheLookAheadList();

					#ifdef COBJ_DEBUG;
						print alt_match_list-->0, " possible second nouns]^";
					#endif;

					wn = swn;
					cobj_flag = 1;
					pcount = spcount;
					jump CodeOne;
				}
			}
		}
		
	}

	#ifdef COBJ_DEBUG;
		print "nothing interesting]^";
	#endif;

	! reset everything

	pcount = spcount;
	wn = swn;	
	cobj_flag = 2;
	jump CodeTwo;
];


[ BuildTheLookAheadList otf gdata;

! remembers filters and reset if we need to

	otf = token_filter;
	token_filter = 0;
        gdata = line_tdata-->pcount;
	if (line_ttype-->pcount == ROUTINE_FILTER_TT)
	{
	   print "(checking routine filter)^";
	   token_filter = line_tdata-->pcount;
	   gdata = NOUN_TOKEN;
	}
	if (line_ttype-->pcount == ATTR_FILTER_TT)
	{
	   print "(checking attribute filter)^";
	   token_filter = 1 + line_tdata-->pcount;
	   gdata = NOUN_TOKEN;
	}

	SafeSkipDescriptors();

	! save the current match state
	@push match_length; @push match_from;

	alt_match_list-->0 = number_matched;
	COBJ__Copy(number_matched, match_list, alt_match_list+WORDSIZE);

	! now get all the matches we can
	match_length = 0; number_matched = 0; match_from = wn;

	SearchScope(actor, actors_location, gdata);

	! restore match variables
	COBJ__SwapMatches();
       @pull match_from; @pull match_length;
       token_filter = otf;

];

[	SkipPrepositions;
		while (line_ttype-->pcount == PREPOSITION_TT) 	pcount++;
];

[ ScoreCombos
	defaultscore	varier	obj	context		l	i	spcount		b	c	n	s
;
			l = defaultscore;		! note the difference. Because now ...?
			for (i=1: i<=alt_match_list-->0: i++)
			 {
				if (varier == 2) 
				{
					s = obj;
					n = alt_match_list-->i;	
				}
	
				if (varier == 1) ! varier = thing we're testing NOT thing which varies (what dumbass wrote this?)
				{
					n = obj;
					s = alt_match_list-->i;	
				}
				b = GuessScoreDabCombo(n, s, context, varier);
				c = SmartScoreDabCombo(n, s);
				spcount = ResolveChooseScores(b, c);
			!	print (the) n, " / ", (the) s, " => b ", b, " c ", c , " => ", spcount, ".^";

				if (spcount == HIGHEST_DPMR_SCORE) 
				{
					#ifdef COBJ_DEBUG;
						print "[scored ", spcount, " - best possible]^";
					#endif;
					return spcount;
				}
				if (spcount>l) l = spcount;
			}
			#ifdef COBJ_DEBUG;
				print "[scored ", spcount, "]^";
			#endif;
			return l;
];


[ CreateAltList i;
! we copy the whole scope into the alt_match_list
	LoopOverScope(AddToAltMatch);
];

[ AddToAltMatch obj;
	(alt_match_list-->0)++;
	alt_match_list-->(alt_match_list-->0) = obj;
];

[ CopyMultToMatch i;
	for (i = 0: i < multiple_object-->0 : i++)
	{	match_list-->i = multiple_object-->(i+1);
		#ifdef COBJ_DEBUG;
			if (i > 0) print (the) match_list-->i, " / ";
		#endif;
	}
	return multiple_object-->0;
];


[ CopyMultipleObjectList i;
	for (i = 0: i<=multiple_object-->0 : i++)
	{	alt_match_list-->i = multiple_object-->i;
		#ifdef COBJ_DEBUG;
			if (i > 0) print (the) alt_match_list-->i, " / ";
		#endif;
	}
!	new_line;
	
];

-) instead of  "Choose Objects" in "Parser.i6t".




Chapter - should the game choose

Include (-


[ SmartScoreDabCombo a b  result;

	if (guessing) rfalse;	

	@push action; @push act_requester; @push noun; @push second;
	action = action_to_be;
	act_requester = player;
	if (action_reversed) { noun = b; second = a; }
	else { noun = a; second = b; }
	result = SmartCheckDPMR();
	#ifdef COBJ_DEBUG;
	print "[smart: ", (the) noun, " / ", (the) second, " => ", result, "]^";
	#endif;
	@pull second; @pull noun; @pull act_requester; @pull action;

	return result;
];

	[ SmartCheckDPMR result sinp1 sinp2 rv;

		sinp1 = inp1; sinp2 = inp2; inp1 = noun; inp2 = second;
		rv = FollowRulebook( (+ should the game choose rules+) );
		inp1 = sinp1; inp2 = sinp2;
		if (RulebookSucceeded()) { ! was (rv) &&
			result = ResultOfRule();
			if (result == (+ it is an excellent choice outcome +) ) return 9;
			if (result == (+ it is a good choice outcome  +) ) return 8;
			if (result == (+ it is a passable choice outcome  +) ) return 7;
!			if (result == (+ it is possible outcome +) ) return 6;
			if (result == (+ never outcome  +) ) return -1;
		}
		rfalse;
	];

-).





Chapter - Should the game suggest

Include (-

[ GuessScoreDabCombo a b context varying_item result;
	@push action; @push act_requester; @push noun; @push second;
	action = action_to_be;
	act_requester = player;
	if (action_reversed) { noun = b; second = a; }
	else { noun = a; second = b; }
	result = GuessCheckDPMR();

	if (context == CREATURE_TOKEN)
	{
	#ifdef COBJ_DEBUG;
		print "^(checking a creature context with v-i ", varying_item, ")^";
	#endif;
		if 	(	(varying_item == 1 && a has animate)
			||	(varying_item == 2 && b has animate)
			)	
			{
			
				#ifdef COBJ_DEBUG;
					print "(adjudicating creature context from ", result, " up to ", MaxOf(result, 3), ".)^";
				#endif;			
				result = MaxOf(result, 3);
			}
	}

	#ifdef COBJ_DEBUG;
	print "[guess: ", (the) noun, " / ", (the) second, " => ", result, "]^";
	#endif;
	@pull second; @pull noun; @pull act_requester; @pull action;

	return result;
];

[ MaxOf a b;
	if (a > b) return a; return b;
];

	[ GuessCheckDPMR result sinp1 sinp2 rv;

!	if (inp1 == 0 && inp2 ~= 0 && multiple_object-->0 > 0) print "(Made a multiple list!)^";

		sinp1 = inp1; sinp2 = inp2; inp1 = noun; inp2 = second;
		rv = FollowRulebook( (+Should the game suggest rules+) );
		inp1 = sinp1; inp2 = sinp2;
		if (RulebookSucceeded()) { ! was (rv) &&
			result = ResultOfRule();
			if (result == (+ it is an excellent suggestion outcome +) ) return 4;
			if (result == (+ it is a good suggestion outcome +) ) return 3;
			if (result == (+ it is a passable suggestion outcome +) ) return 2;
			

			if (result == (+ never outcome +) ) 
			{	
				if (~~guessing) return -2; 	! only ever return this when not guessing. 
										! Otherwise, same as impossible, which falls through
			}
		}

! so either we had no information or  the (result == (+ it is a bad suggestion outcome +) ) 

! if guessing, we want no list and no default

		 if (guessing)  return -1;

! if not guessing, we want list and default but not good ones.
! recall that this is the bottom of the scoring tree so we can afford to give it a score.

		 return 1;

	];
-);


Chapter  - bypass disambiguate

[ 
Bypass disambiguation rules allow us to use the old parser mechanism of favouring held objects in cases where it's faster and less annoying.
By default we never do this. 

Bypass disambiguation when smelling a rose: yes.

[ note: actually, this doesn't yet work, because it doesn't copy in the action pattern. TO DO! ]

]


The bypass disambiguation rules are a rulebook.
The bypass disambiguation rules have outcomes yes and no.

Include(-

[ ChooseObjectsBypassDisambiguate rv;

		rv = FollowRulebook( (+bypass disambiguation rules+) );
		if (RulebookSucceeded() && ResultOfRule() == (+yes outcome+)) 
		{
!			print "(bypass disambig: Rulebook succeeded.)^";

			rfalse;
		}
!		print "(bypass disambig: Rulebook not succeeded.)^";
		rtrue;
];

-).

Chapter - we resolve scores from the three types of test


Include 
(-

[ ResolveChooseScores expectation_score preference_score;

! print "Resolving: ", noun_set_score, " / ", expectation_score , " / ", preference_score, "^";

! if guessing, this is easy
	if (guessing) 
	{
		if (expectation_score >= 3) (+list-outcomes+) = true; 	! we've scored high enough to list what we found
		return expectation_score;
	}

! otherwise, we take individual score, then noun subset score, then guess score


       if (expectation_score == -2) return -1;
							! if the combination is declared "always impossible"
							! this takes absolute priority over everything else and we delete


	if (expectation_score > 0)		! 0 => it was a "bad" suggestion, which isn't good enough to print a list
		(+list-outcomes+) = true; 	! this is automatically high enough to qualify now, because either we found a preference rule
								! (okay, so later these might include "unlikely" but they don't for now)
								! or we found bad-at-worst, which we still list


       if (preference_score ~= 0) 
		return preference_score;			! preference_score =-1 is a good return score for individual stuff

	if (expectation_score ~= -1) 	return expectation_score;
						! otherwise we use the guess score, but we never delete!

	rfalse;				! so we tell the score system nothing


];

-)


Disambiguation Control ends here.

---- DOCUMENTATION ----


Chapter: Problems This Extension Tackles

Inform has a clever parser, capable of making intelligent deductions based on the incomplete and sometimes plain lazy input of its human players. However, its algorithm is not perfect and Inform 6 and 7 authors have frequently struggled with namespace clashes and the problem, not obviously associated, of over-eager parser guesswork. A frequent question on the programming newsgroup is "how do I make the parser ask which object the player means instead of choosing itself?" This extension aims to extend more control to authors over how Inform makes these decisions, and to promote a philosophy of "ask more questions and make fewer guesses".

There are four major areas tackled by "Disambiguation Control". Each section is headed by a piece of real parser interaction from an I7 sample game.

Section: Namespace clashes

Consider the following:

	There is a tree here. In the tree is a tree house.
	
	>EXAMINE TREE
	Which do you mean, the tree or the tree house?

	>TREE
	Which do you mean, the tree or the tree house?

This is an example of a namespace clash - one object, whose accepted synonyms are a subset of another's, making it impossible to refer to the first object. Inform 7 authors will be as familiar with their players, the language itself faces the same difficulties! This extension provides a rulebook which details to the parser how to disambiguate in these situations and ensure the player always gets the object intended.

Traditionally, these cases have been tackled by using a "does the player mean" rule to promote the under-named noun: in the above example, we would write

	Does the player mean doing something with the tree: it is likely.

Unfortunately, these rules cause an unfortunate side-effect, namely:

Section: Over-eager Guesswork

	>TAKE
	(the tree)
	That's fixed in place.

The problem arises because the parser uses the same "does the player mean" rules to distinguish cases when the player has given unclear input (such as "TREE" above, or more commonly something like "TAKE KEY" when there are several keys nearby); and cases when the player has given no input - either through laziness or a misunderstanding of the commands recognised by the game. At its least serious, over-eager guesswork can make a game look stupid: at its worst - in time-critical scenes, say, or in perilous locations - a parser guessing can lead to the player's demise and the need for an UNDO.

Clearly preferable would be the following:

	>TAKE
	What do you want to take: the apple, the tree, the ladder or the tree house?

or, perhaps, even better:

	>TAKE
	What do you want to take: the apple or the ladder?

"Disambiguation Control" aims to produce questions of this type under all circumstances when there is not a single, obvious possibility. It will list all the sensible options for a particular verb, if it can find any, and if it can't, it will ask simply "What do you want to take?". It provides a rulebook to decide what kind of objects are sensible in a given context which the author can alter and add to. It also provides functionality to limit the length of the list of options produced, to stop unwieldy output and, if preferred, to turn it off completely and produce a more tidy

	>TAKE
	What do you want to take?

every time.

Inform 7 does have a system of automatic defaulting built in, based on the location of the object and the type of verb being used. However, it is unpredictable and non-transparent for the player, and tends to lead to more guesswork and fewer questions. On the occasions that it guesses correctly, it's magic. On those when it fails, however, it can be frustrating and, for unseasoned players, confusing. This extension removes this mechanism entirely (although I6 and template users may be interested to know that it maintains the score bonuses for being non-scenery, non-actor and non-compass objects.) 

(The original system is left intact, and the extension provides a hook for turning it back on, although at present this is not fully coded up because I've not yet found it useful!)

Section: Creating Specific Defaults

	>DRINK BEER
	Which beer do you mean, your beer or his beer?

In situations like this, it would often be nice to provide the correct default rather than bore the player with an "unnecessary" question. However, using a "does the player mean rule" has the usual over-eager guesswork consequence mentioned above. "Disambiguation Control" provides a new rulebook for providing these kind of defaults, that does not interfere with the process of "guesswork" mentioned above. 

Finally, "Disambiguation Control" leverages the "which do you mean" method for the case of:

Section: Rejecting Multiple Actions

	>EXAMINE FRUIT
	You can't use multiple objects with that verb.

This is a little brusque, at least - and made worse by the fact that some "multiple objects" are in fact single objects with plural names...

"Disambiguation Control" replaces this message entirely with a system of offering a choice, using the same rulebooks and code as the rest of the disambiguation process, producing:

	>EXAMINE FRUIT
	Please be more specific - what do you want to examine: a cherry or the apple?

Should the multiple object actually be a set of identical objects (of the same kind), the game will pick one to act as a representative, giving the following:

	>EXAMINE CHERRIES
	(a cherry)
	The cherry is a rich red colour and has a beautiful smooth skin.


Chapter: How to Update an Existing Project

You can include this extension without making any changes to your code. It will automatically improve points (2) and (4) above, namely, producing less parser guesswork and more "which do you mean" questions, and replacing the multiple action error with a prompt for more detail.

You will, however, need to update any "does the player mean" rules in your code - this extension renders this rulebook redundant (although it borrows its output values of "it is likely", and so forth).

How you should update each rule depends on its function. There are two types:





Section: Should the game choose rules (Does the player mean doing something specific...)

Consider:

	In the Living Room is a leather armchair and a hard wicker chair. Marcus is a man on the wicker chair. 
	Does the player mean entering the leather armchair: it is likely.

Here the "does the player mean" rulebook is being used to guide the player into the correct chair automatically: the game is being "smart" and ensuring that a player who merely types "SIT ON CHAIR" will not be offered a choice (the leather armchair or the wicker chair?) when there is no choice available.

"Disambiguation Control" maintains this idea, using the "should the game choose" rulebook. This has the following set of (positive!) outcomes: 

	it is an excellent choice
	it is a good choice
	it is a passable choice

and one way of removing an option entirely, so that disambiguation will never allow it (although directly typing it will still work, of course):

	never

These rules take precedence over everything else so should be used with caution - but with one substantial improvement from the normal I7 "does the player mean rules": they will never fire unless the player has typed at least one noun signifier. This avoids behaviour like:

	>SIT
	(on the wicker chair)

	>EXAMINE
	(the wicker chair)
	
	>KISS
	(the wicker chair)
	
	... and so forth.

A second improvement over I7 is a bug-fix: when writing rules for actions such as "put <x> in <x>", there's no need to remember to write the rule without the first noun: "Disambiguation Control" searches comprehensively across all possible nouns, so will fire rules written as either "put into something" or "put something into something". (If all that means nothing to you, don't worry, it's only one less thing to worry about.)

Because these rules are so powerful, they often need quite careful context: not just where the player is and what's happening around him, but also what other options the player might be referring to in the particular input. Several phrases are provided to help with this:


Firstly, phrases to check whether match list contains certain objects (amongst others)

	...when also considering (a particular object)
	...when considering some (things matching a description)

A phrase to test if the match list consists of one specific other thing:

	...when also only considering (a particular object)  ... (or only also, or only just)

(This condition is good for separating namespace clashes, with rules such as:

      Should the game choose doing something with the lemon when also only considering the lemon grass: it is a good suggestion.)


We can also check if the match list is entirely contained by some specified set of objects, using the "comparing phrases":

One, two or three objects separated by and/or/against...
	Should the game choose when comparing the lemon against the lemon grass:
		it is a good choice.

	Should the game choose when comparing the cat against the cat flap + the cat nip:
		it is a good choice.

A description...
	Should the game choose doing something with the plain door when comparing doors:
		it is a good choice.

[ and i'd like to include, a list of objects, but despite working in the last build it's now gone weird, so I'll have to look into that i guess. ]

Note, we either include the action description "doing something with"... or we have no action description, and use "comparing <the thing in question> against <other things>". 

The "+" separating terms in the comparing phrases is clunky, but using "and" or "or" confuses Inform!




Section: Should the game suggest rules (Does the player mean doing something, in general ...)

Consider:

	Does the player mean taking something heavy: it is unlikely.
	Does the player mean drinking something liquid: it is likely.

These are rules that reflect elements of the simulation: the player will want to enter enterable things, open closed things, eat edible things, and so forth. "Disambiguation Control" uses this kind of rule to help provide sensible options for the player when guessing, and also to provide the opportunity for some defaulting when the player's ambiguous input has only one sensible meaning. 

The rulebook used for teaching the parser the rules of the world is called the "Should the game suggest" rulebook. It has six outcomes: it is an excellent suggestion, it is a good suggestion, it is a passable suggestion, no opinion, it is a bad suggestion and never. The "excellent" outcome is provided as "slack": the library does not use them and the author is advised to leave them be.  (The more different levels of score there are, the more likely the parser is to find a unique best guess and default without the player understanding what's happened!)

The following are the rules above, rewritten for use with this extension:

	Should the game suggest taking something heavy: it is a bad suggestion.
	Should the game suggest drinking something liquid: it is a good suggestion.

The extension comes preloaded with a set of basic rules covering the usual I7 world model. Here are four rules from within it:

	Should the game suggest closing an open thing: it is a good suggestion.
	Should the game suggesting taking a portable thing: it is a passable suggestion.
	Should the game suggest taking a scenery thing: it is a bad suggestion.
	Should the game suggest wearing a scenery thing: never.


The parser will either default to a single choice, or offer a list of outcomes, or offer a blank request for more information ("What would do you want to take?") The rules for how it decides are slightly fiddly, and in this version, not user-configurable. In order to choose which outcomes to provide for any given rules, some rules of thumb are provided below.

Excellent:
Not necessary, probably, but provided as a stepping-stone between actions that should always happen, but that don't take precedence over namespace clashes

Good:
These are the outcomes which will be favoured under normal conditions.

Passable:
This sits just above the default value - this is for action the library wants to leave as a last resort, such as taking things you already have or wearing a hat you've got on your head.

(Passable is a somewhat odd category - the parser will never offer them to the player when the player has only typed a verb (it would seem strange to suggest the hat on your head is a suitable thing to try and WEAR); but if the player has been more specific then the parser will both offer this as an option, and accept it as a default value.)

Bad: - the default
This covers actions which would look stupid if offered by the game at any time. Taking this as the default prevents the game from offering long lists to open commands (TAKE) but doesn't prevent the player being offered objects he's referenced if there's nothing better (TAKE OAK). The extension includes several of these despite this outcome being the default - a bit of precision was never a bad thing!

Never:
Never actions should be those which have a high cost (damage, death or irrevocable change); actions which away puzzle solutions that the player could solve by accident; and actions involving fake objects which are only there to provide particular responses and don't really exist in the game-world.

The "Should the game suggest" rules must be extended if the parser is to suggest things which are have meaningful actions outside of the standard model-world rules, typically those handled by Instead and Check rules rather than Carry Out rules; as well as new aspects of simulation added by the author. For example, we might include:

	Should the game suggest climbing the roses: it is a good suggestion.
	Should the game suggest opening the newspaper: it is a good suggestion.
	Should the game suggest pulling a rope: it is a good suggestion.


Note that "excellent" suggestions will beat all those in the library (with the caveat that it has to reach the rule you want it to...)

Section: What are we checking for?

Note that the same rules apply when checking the noun part or the second noun part of the action. Sometimes this doesn't matter - for example, the rule that prevents us trying to put something inside itself applies to both the noun and the second noun part of the phrase. But sometimes, we want a rule only to apply when we're testing a particular part of the phrase.

We can do this use the conditions "if testing the noun" and "if testing the second noun". For example, in a game featuring a key kind, the following rules might be added:

	Should the game suggest unlocking with a key when testing the second noun: it is a good suggestion.
	Should the game suggest locking with a key when testing the second noun: it is a good suggestion.

Here we need the "if testing the second noun" because if we left it out, the game would assign "good" status to bad action patterns like "lock yourself with brass key" or "unlock apple with brass key", which ought to be considered poor because of their noun part.

Section: Use Options to alter the lists produced

In games with lots of objects, "Disambiguation Control" can lead to very large lists of options, especially in response to blank input lines. We have some mechanisms for controlling this:

	Use disambiguation list length of at least 4;

Limits the length of the option list produced: if it contains more than 4 items, the game will ask for clarification without offering a list. The default list length is 6. (Note the "at least" is meaningless here - the number is definitely "at most". Unfortunately, I7's variable use options take this format only.)

	Use no parser suggestions.

This will prevent blank "guesswork" lines from offering suggestions, so typing a blank "TAKE" will always reply "What do you want to take?" (unless there is one best-guess object, in which case this will be chosen).
	
	Use no multiple suggestions.

This prevent "EXAMINE ALL" printing a list of possible things to examine: instead it will always reply "Please be specific - what do you want to examine?"

Section: To alter the text of the messages

Messages used to be stored in a table, but now use the standard Response system. You will probably want to replace one of the responses of the Disambiguation Printing Rule.

Chapter: Summary of the Disambiguation Process

Section: Guesswork Situations

For input like

	>TAKE
	>DROP
	>PUT HAT IN

the order of flow is:

1) 	Is there only one object in scope? If so, pick this.
2)	Consult the "Should the game suggest" rules. Is there only one object at the best level of suggestion? If so, default? (We never default to "passable" or worse suggestions, however.)
3)    Are there several possibilities at a good or better level of suggestion? If so, list them and ask the player for more information.
4)  	If the best objects are passable or worse, ask generically for more information, but don't print a list.
5)	If all the objects are identical and good or better, pick one 

Section: Ambiguous Input

For input like

	>EXAMINE RED
	>TAKE KEY

where there are multiple objects to which the player may be referring. The order of flow is:

1) 	Is there only one object in scope? If so, pick this.
2)	Consult the "should the game choose" rules. Is there an object which is the best choice? If so, default to this.
3)	Consult the "Should the game suggest" rules. Remove any "never" objects. If there is now only one object, default to this.
4)  	If the best objects are bad or worse, ask generically for more information, but don't print a list.
5)	If all the objects are identical and passable or better, pick one 


Section: Unusable Plural Input

For input like

	>EXAMINE ALL
	>PUSH STATUES

the order of flow is:

1) 	If no nouns/adjective have been provided, treat the input as just a verb (guesswork, above)
2)	If nouns/adjectives are supplied, treat this as ambiguous input

Chapter: Summary of New Rulebooks

Section: should the game choose?

Used to default the parser smoothly, given specific circumstances. Most useful for scripting situations in which a particular ambiguity has a "correct" choice (such as taking the model Eiffel tower, drinking your own beer or climbing the step-ladder rather the ladder in your tights.)

The "never" outcome will remove the object from all disambiguation lists (under the context of the action).

Only affects input with some content. 

Take precedence over all other rulebooks which means this rulebook can take precedence over a namespace clash, which make it impossible for the player to try some actions! Use with caution!

Examples:
	should the game choose drinking my beer: it is a good choice.
	should the game choose wearing my hat when also considering Lucy's hat: it is a passable choice.
	should the game choose wearing Lucy's hat when the player cannot see Lucy: it is an excellent choice.
	should the game choose attacking the vial of poison: never. 

When conditions:
	also considering <an item>
	also considering <some thing matching a description>
	also only considering <an item, and nothing else>

Outcomes:
	it is an excellent choice
	it is a good choice
	it is a passable choice
	never

(this is probably far more outcomes than anyone would reasonably need, but the slack is there.)



Section: Should the game suggest?

Used to give the parser an idea of what's appropriate in the model world. It's used to streamline the responses given by the parser in response to a verb with no noun qualifiers at all, such as "EXAMINE", "TAKE" or "PUT CAT IN" (but also "EXAMINE ALL", "CLIMB ALL"). The rules will be consulted on all objects in scope and objects at the best level of outcome will be collected up.

Good suggestions will be printed together, and if there's only one it'll be defaulted to.
Passable suggestions will never be printed, but if there's only one it'll be defaulted to.
Bad and Never suggestions will not be printed or defaulted to.

The suggest rules are also used when the player has given the game some information: they take a lower priority than the "choose" rules, and act as a sanity check. The only difference is that passage and bad suggestions will be listed on-screen, however, bad choices will never be defaulted to.

Note that objects not matching any rules will be given a default value that sits between "passable" and "bad", but will share list/default properties with the category *below* them.


Examples:

	Should the game suggest playing a musical instrument: it is a good suggestion.
	Should the game suggest taking the castle: it is a good suggestion. 
	Should the game suggest entering the crossword competition: it is a good suggestion.
	
For actions which should be offered because, although they're not great, they make more sense than the alternative:
	Should the game try wearing something wearable when the player is wearing the noun: it is a passable suggestion.
	Should the game try tying a knotted knot: it is a passable suggestion. 

For actions which could be offered to the player if he asked for them, but should not be defaulted to because they're dangerous
	Should the game suggest taking something flaming: it is a bad suggestion.

For actions that should never be offered to the player under any circumstances:
	Should the game suggest taking your nose: never.
	Should the game suggest unlocking the door with the hairpin: never.

  

Outcomes:
	it is an excellent suggestion
	it is a good suggestion
	it is a passable suggestion
	it is a bad suggestion
	never


Section: To Bypass Disambiguation

I7's inbuilt system will prefer held objects except when Taking or Removing, when it prefers objects in the location. This should be now effectively handled by the "Should the game suggest" rules, but in case it isn't, and you want I7 to make it's own choices, you should use a "bypass disambiguate rule" to make it guess as it normally would.

(At present these rules are not properly implemented because I don't think they're useful. Currently, they take in no data about the action but should return "yes" or "no". They will eventually respond to action patterns.)

Chapter: Thanks, Notes and Limitations

Section: Thanks

Disambiguation is built in, on and out of Graham Nelson's I6 parser, an intricately complicated machine. This extension begs, borrows and cuts-and-pastes extensively. The code may work, but in no way does it detract from the major achievement that the original library represents.

Thanks for Eric Eve and Ron Newcomb for feedback and suggestions.

Matt Weiner and Daniel Stelzer updated this extension for version 6L02.

Section: Notes and Limitations

The various rules in this extension will get called repeatedly on a turn. Needless to say, they should not attempt to say anything, and cannot be used reliably to track or reference variables. 

The phrase "when comparing <a thing> against <something else>" isn't much good when talking about classes of objects, because everything thing must be a thing, not a description! You should be able to create any tests with classes using the "considering" rules, but you might have to be careful to catch the situation you want. (See the "Scrumping" example for a demonstration of disambiguating between a kind and a specific thing.)

The multiple action support only works for "all", not for specific numbers: so "EXAMINE ALL APPLES" (or just "EXAMINE APPLES") will be handled, but "EXAMINE TWO APPLES" won't be. (This is because Inform wants to treat "two" as an adjective rather than a quantifier in non-multiple actions: I may look into this at some point, but for now, consider it a drawback.)


Section: Feedback

If you have comments, suggestions, questions or bugs please contact me at matt@mattweiner.net.

Section: Changelog

Version 6 - Updated to compile with 6E59.

Version 7 - Small fix for an error with rebuilding the input line after querying the second noun when the first noun was an object picked from a set of identical objects.

- FIx for failing to parse the word "her": the system was interpreting this as a possessive, missing extra information. It now changes its mind if the "indef_possambig" flag is true, mimicking what the standard parser does.

Version 8 - Attempt by Matt Weiner and Daniel Stelzer to adapt extension for 6L02.

- Changed deprecated phrase "End the game in victory" in example "Scrumping".
- Replaced table of messages with standard responses.

Version 9/171416 - Attempt by Matt Weiner to adapt extension for 6M62.

- Changed every instance of "yes" and "no" in a To decide if phrase to "decide yes" and "decide no."
- Changed the feedback address from Jon's to Matt's.

Example: * Keys and Locks - A quick example showing how to make keys and locks that the parser prefers to choose

*:

	"Keys and Locks"

	Include Disambiguation Control by Jon Ingold.

	A lock is a kind of thing. A lock can be lockable. A lock can be locked. A lock is always lockable. A lock is usually unlocked. 

	A key is a kind of thing.

	Section - the rules

	Should the game suggest locking a lock with when testing the noun:
		it is a good suggestion.
	Should the game suggest unlocking a lock with when testing the noun:
		it is a good suggestion.


	The first should the game suggest unlocking something with something when the second noun unlocks the noun:
		it is an excellent suggestion.
	The first should the game suggest locking something with something when the second noun unlocks the noun:
		it is an excellent suggestion.


	Should the game suggest locking something with a key when testing the second noun:
		it is a good suggestion.
	Should the game suggest unlocking something with a key when testing the second noun:
		it is a good suggestion.

	Section - The scene

	The Lock Shop is a room.

	There is a brass lock, an iron lock and a lock of hair in the Lock Shop.
	There is a brass key, an iron key, a key chain in the Lock Shop.

	The brass key and iron key are keys.
	The brass lock and iron lock are locks.

	The brass key unlocks the brass lock.
	The iron key unlocks the iron lock.

	There is a metal mincer in the Lock Shop.

	Instead of inserting something into the metal mincer:
		remove the noun from play;
		say "The metal mincer minces [the noun].";

	Test me with "lock lock with key / iron / put brass lock in mincer / unlock lock with brass"

	

Example: * Scrumping - An example demonstrating multiple actions, suggestions and defaults

*:	
	
	"Scrumping"

	Include Disambiguation Control by Jon Ingold.

	The Orchard is a room.

	An apple is a kind of thing. A cherry is a kind of thing.
	An apple is edible. A cherry is edible.

	Understand "fruit" as the plural of apple.
	Understand "fruit" as the plural of cherry.

	A tree is a kind of supporter. Understand "trees" as the plural of tree. A tree is scenery.

	In the Orchard is a tree called the apple tree.
	In the Orchard is a tree called the cherry tree.
	In the Orchard are some bushes.

	Five apples are on the apple tree.
	Seven cherries are on the cherry tree.

	Instead of climbing the cherry tree: say  "The branches are too flimsy."

	Instead of climbing the apple tree:
		say "You leap up the apple tree and tuck in!";
		end the story finally saying "You have won".


	Should the game choose climbing the apple tree (this is the climb apple not cherry rule):
		it is a good choice.

	Should the game choose doing something with an apple when also considering the apple tree (this is the namespace default to apple not apple tree rule):   
		it is a good choice.

	Should the game suggest climbing a tree (this is the trees are good for climbing rule):
		it is a good suggestion.

	Test multiples with "examine trees / examine fruit / examine all / climb all".

	Test suggestions with "examine / eat / take / climb".

	Test choosing with "eat apple / climb cherry / climb tree"

	Test me with "test multiples / test suggestions / test choosing"

Example: * Pile of Bricks - an example showing a pile of objects from which an individual object can be taken (which is a common cause of namespace clashes). 

*:	
	
	"Pile of Bricks"

	Include Disambiguation Control by Jon Ingold.

	The Building Site is a room. In the building site is a pile of bricks.

	The brick is a thing.

	Instead of climbing or entering the pile of bricks:
		say "You'd break your neck if you climbed up the bricks."

	Instead of taking the pile of bricks when the brick is on-stage:
		say "You've already got a brick."

	Instead of taking the pile of bricks:
		move the brick to the player;
		say "You take a brick from the pile."

	Understand "brick" as the pile of bricks.

	Should the game suggest when comparing the pile of bricks against the brick (this is the pick the brick over the pile of bricks under all straight face-offs rule): never.

	Should the game suggest entering or climbing the pile of bricks when also only considering the brick (this is the we can climb up the pile of bricks rule) : it is a good suggestion.

	Test me with "take brick / take brick / drop brick / take brick / enter brick / take pile of bricks".
