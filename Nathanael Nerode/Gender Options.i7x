Version 3/170818 of Gender Options by Nathanael Nerode begins here.

"More broad-minded English language gender/number model where male, female, and neuter are three separate true-false properties.  Allows for objects to respond to any specified combination of HE, SHE, IT, and THEY.  As fast as the Standard Rules.  Tested with Inform 6M62."

[We replace very, very specific bits of the standard rules. This is based on 2/090402.]

Include Standard Rules by Graham Nelson.

Volume 1 - Enhanced Gender and Number Model

[Make male, female, and neuter independent.]

Chapter 1 - Replace Standard Rules Elements Always

Section SR1/11 - People and things with gender (in place of Section SR1/11 - People in Standard Rules by Graham Nelson)

[These must overrride all other definitions.]
A thing can be neuter.  A thing is usually neuter.
A thing can be male.  A thing is usually not male.
A thing can be female.  A thing is usually not female.

[Ambiguously plural is defined in Standard Rules.  It isn't fully implemented, however.  It allows for "ambiguously plural" nouns like "a pair of shoes".  This line already exists in SR1/1 and is essentially redundant, but we need it, so restate it in case Standard Rules moves it or something.]
An object can be ambiguously plural.

[Beginning of text from original section SR1/11.]

The specification of person is "Despite the name, not necessarily
a human being, but anything animate enough to envisage having a
conversation with, or bartering with."

Include (-
	has transparent animate
	with before NULL,
-) when defining a person.

A person has a number called carrying capacity.
The carrying capacity of a person is usually 100.

The yourself is an undescribed person. The yourself is proper-named.

The yourself object translates into I6 as "selfobj".
Include (-
	with saved_short_name "yourself",
 -) when defining yourself.

Section SR1/11 C - Assumptions about people

[This section is separated out in case someone wants to replace it.]

A person is usually not neuter.

A person is usually female.
A person is usually male.
[* This is less weird than it appears.  If you make a generic, unnamed person, the player can refer to said person as "him" or "her", interchangably.]

Section SR1/12 - Animals, men and women revised (in place of Section SR1/12 - Animals, men and women in Standard Rules by Graham Nelson)

The plural of man is men. The plural of woman is women.

A man is a kind of person.
The specification of man is "Represents a man or boy."
A man is usually male.
A man is usually not female.
A man is usually not neuter.

A woman is a kind of person.
The specification of woman is "Represents a woman or girl."
A woman is usually female.
A woman is usually not male.
A woman is usually not neuter.

An animal is a kind of person.
An animal is usually not male.
An animal is usually not female.
An animal is usually neuter.
[By default, refer to an animal as "it".]

The specification of animal is "Represents an animal, or at any rate a
non-human living creature reasonably large and possible to interact with: a
giant Venus fly-trap might qualify, but not a patch of lichen."

Section SR1/16 A - Inform 6 equivalent for male

[This saves a property since Inform 6 already has an unused male property.  This is actually only *required* for compatibility with Original Parser, which uses the term 'linguistically male' for what has to be the same property.]
The male property translates into I6 as "male".

Chapter 2A - Yourself Description - Standard

Section SR1/11 A - Yourself Description 

[ this is (for use without Neutral Standard Responses by Nathanael Nerode) ]

The description of yourself is usually "As good-looking as ever."

Chapter 2B - Yourself Description (for use with Neutral Standard Responses by Nathanael Nerode)

[We do it this way so that we can handle other extensions which interfere with the same text in the same way.  Which is likely.]

Section SR1/11 A - Deleted Yourself Description (in place of Section SR1/11 A - Yourself Description in Gender Options by Nathanael Nerode)

dummy_variable_1234567890 is a truth state that varies.
[* We don't need to give a description, because Neutral Standard Responses does.  Unfortunately, there must be something, not a commment, in every section or bug 0001841 causes a compiler crash.  This is the smallest possible dummy we can create, occupying between 1 bit and 1 byte.]

Volume 2 - Parser Modifications for Pronoun Handling

[Make pronouns behave properly.]

Part 1 - Universal Fix

Chapter 1 - Fix Pronoun Bitmask Table

[Aw heck.  After all that work below it turns out there's a conceptual error in the bitmask table --
it thinks all inanimate objects are neuter.  Drop down to I6 and fix it.  There may be a cleaner
method, but this is the least invasive, unbelievably.]

Include (-

! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Gender Options replacement for Language.i6t: Pronouns
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====

Array LanguagePronouns table

  ! word        possible GNAs                   connected
  !             to follow:                      to:
  !             a     i
  !             s  p  s  p
  !             mfnmfnmfnmfn

    'it'      $$001000001000                    NULL
    'him'     $$100000100000                    NULL
    'her'     $$010000010000                    NULL
    'them'    $$000111000111                    NULL;

-) instead of "Pronouns" in "Language.i6t".

Part 2A - Core i6 Parser Fix (for use without Original Parser by Ron Newcomb)

Chapter 1 - Revisions Not Made

[Oddly, it turns out we don't need to alter the Gender section of the parser, which defines GetGender and GetGNAOfObject.

We could and should remove GetGender, which will give bad info.  It is dead code.

GetGNAOfObject is used in four places: two in ListWriter.i6t, and one each in Printing.i6t and Parser.i6t.

ListWriter applies GetGNAOfObject mod 3 to track prior_named_list_gender, but prior_named_list_gender is a write-only variable (dead code).

Printing uses GetGNAOfObject, then applies LanguageGNAsToArticles, which strips out the gender and gives only the plural status.
This is used only to match articles (the / an / some), so it checks only for pluralname, not for ambigpluralname, which is correct.
(An ambiguous plural name like 'pair of shoes' should have a 'the'/'an'.)

ListWriter applies (GetGNAOfObject mod 6 / 3) in PNToVP, which is called by the autogenerated verb conjugation code.  It's only checking for plurals, again.  This could be patched.
There is a suggestion to patch it to allow for "singular they".  "The shadowy figure lurks; they look angry."

Parser only uses GetGNAOfObject in 'best guess', which is a 1 point disambiguator and not very important.
It does unfortunately check gender, using the old method.
We could fix it by replacing the ENTIRE ScoreMatchL section of the parser, but it's not worth the sheer level of invasiveness.

To work with foreign languages which have gendered plurals, it would be necessary to:
(a) use GetGNABitfield in Parser
(b) rewrite GetGNAOfObject to check the preferred printing genders for the other calls.

Summary: new code should not use GetGender or GetGNAOfObject, but we don't need to edit the old code.
]

Chapter 2 - Pronoun Handling Revised

[Most of this is the same as in the original.  
However, PronounNotice is different, and GetGNABitfield is new.

The change to PronounNotice should actually work for all languages and new pronouns;
but a new language would require a different GetGNABitfield implementation.

FWIW, ResetVagueWords and PronounNoticeHeldObjects are obsolete.
SetPronoun is also obsolete, but we fix its runtime error number anyway.]

Include (-

! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Gender Options replacement for Parser.i6t: Pronoun Handling
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====

[ SetPronoun dword value x;
    for (x=1 : x<=LanguagePronouns-->0 : x=x+3)
        if (LanguagePronouns-->x == dword) {
            LanguagePronouns-->(x+2) = value; return;
        }
    RunTimeError(12);
];

[ PronounValue dword x;
    for (x=1 : x<=LanguagePronouns-->0 : x=x+3)
        if (LanguagePronouns-->x == dword)
            return LanguagePronouns-->(x+2);
    return 0;
];

[ ResetVagueWords obj; PronounNotice(obj); ];

[ GetGNABitfield obj g gn;
	! First calculate three-bit gender field
	g = 0;
	if ( obj has (+ neuter +) ) {
		g = g + 1;	! bit position 0
		}
	if ( obj has (+ female +) ) {
		g = g + 2;	! bit position 1
		}
	if ( obj has (+ male +) ) {
		g = g + 4;	! bit position 2
		}
	gn = 0;
	if ( obj has (+ ambiguously plural +) ) {
		gn = g * 9;	 ! plural in low significant digits, plus singular shifted three to the left
	} else if ( obj has (+ plural-named +) ) {
		gn = gn + g;	! plural is in low significant digits
	} else {	! obj is singular-named
		gn = gn + g * 8;	! singular is shifted 3 to the left
	}
	if ( obj has animate ) {
		return gn * 64;	! shift 6 to the left for animate objects
		}
	return gn;	! shift 0
];

[ PronounNotice obj x bm;
    if (obj == player) return;

	bm = GetGNABitfield(obj);  ! This is the change made by Gender Options by Nathanael Nerode.

    for (x=1 : x<=LanguagePronouns-->0 : x=x+3)
        if (bm & (LanguagePronouns-->(x+1)) ~= 0)
            LanguagePronouns-->(x+2) = obj;
];

[ PronounNoticeHeldObjects x;
#IFNDEF MANUAL_PRONOUNS;
  objectloop(x in player) PronounNotice(x);
#ENDIF;
  x = 0; ! To prevent a "not used" error
  rfalse;
];

-) instead of "Pronoun Handling" in "Parser.i6t".

Part 2B - Original Parser Fix (for use with Original Parser by Ron Newcomb)

Chapter 1 - Pronoun Handling Revised ( in place of Chapter - Pronoun Handling in Original Parser by Ron Newcomb )

[Most of this is the same as in the original.  However, "To decide which word usage is the gender-animation usages for " is *completely* different.]

[To reset vague words with (obj - an object) (this is ResetVagueWords): set pronouns from the obj.]

To change (pronoun - an understood word) to (obj - an object) (this is SetPronoun):
	if the pronoun is listed as one of the pronouns in the language's pronoun list:
		now chosen antecedent element is obj;
		stop;
	issue the 14th run-time message "** Library error 14 (0,0) **[line break]** (unexplained) **[line break]".

[ Returns 'nothing' if the inputted word isn't one of the four pronouns.  Returns the 'used-up object' (NULL) if it's an unset pronoun. ]
To decide which object is what (pronoun - an understood word) stands for (this is PronounValue):
	if the pronoun is listed as one of the pronouns in the language's pronoun list:
		decide on the antecedent element.

[We're handling the gender rules differently from standard Inform and differently from Ron's extension.

The key is that an object can have multiple gender matches and multiple singular/plural matches, and they're all handled correctly.

In Original Parser, the GNA/ grammatical case should be a separate type from the word usage, but it isn't.  Yet. 

This is a super-tedious way of dealing with the translation between I7 and I6 without fighting too much with I7's type system.  It cannot possibly be efficient.

The acronyms stand for:
"Animate" or "Inanimate"
"Singular" or "Plural"
"Male", "Female", or "Neuter"
]
To decide what word usage is
	the empty bitfield: 	(- $$000000000000 -).
To decide what word usage is 
	_a_s_m: 	(- $$100000000000 -).
To decide what word usage is
	 _a_s_f: 	(- $$010000000000 -).
To decide what word usage is
 	_a_s_n: 	(- $$001000000000 -).
To decide what word usage is 
	_a_p_m: 	(- $$000100000000 -).
To decide what word usage is 
	_a_p_f: 	(- $$000010000000 -).
To decide what word usage is 
	_a_p_n: 	(- $$000001000000 -).
To decide what word usage is 
	_i_s_m:	(- $$000000100000 -).
To decide what word usage is 
	_i_s_f:	(- $$000000010000 -).
To decide what word usage is 
	_i_s_n: 	(- $$000000001000 -).
To decide what word usage is 
	_i_p_m: 	(- $$000000000100 -).
To decide what word usage is 
	_i_p_f: 	(- $$000000000010 -).
To decide what word usage is 
	_i_p_n:	(- $$000000000001 -).

[This pulls up the matching pronoun types for an object.

It has been modified to account for ambiguously plural objects and multi-gendered things and people.

Note: the animate-handling is wrong; it makes it hard to call a ship "her".]
	
To decide which word usage is the gender-animation usages for (obj - object):
	Let GNAbits be a word usage;
	Let GNAbits be the empty bitfield;
	Let animated be a truth state;
	if obj is a person:
		now animated is true;
	otherwise:
		now animated is false;
	if animated is true:
		if obj is singular-named or obj is ambiguously plural:
			if obj is male, include _a_s_m in GNAbits;
			if obj is female, include _a_s_f in GNAbits;
			if obj is neuter, include _a_s_n in GNAbits;
		if obj is plural-named or obj is ambiguously plural:
			if obj is male, include _a_p_m in GNAbits;
			if obj is female, include _a_p_f in GNAbits;
			if obj is neuter, include _a_p_n in GNAbits;
	otherwise:
		if obj is singular-named or obj is ambiguously plural:
			if obj is male, include _i_s_m in GNAbits;
			if obj is female, include _i_s_f in GNAbits;
			if obj is neuter, include _i_s_n in GNAbits;
		if obj is plural-named or obj is ambiguously plural:
			if obj is male, include _i_p_m in GNAbits;
			if obj is female, include _i_p_f in GNAbits;
			if obj is neuter, include _i_p_n in GNAbits;
	decide on GNAbits.
	
[This will correctly match if you give it a combination of multiple pronoun options.  Test this with androgynes and ambiguously plural nouns.]

[This eliminates the use of GetGNAOfObject in the parser, but unfortunately it's still used in an exported capacity by Language.i6t.]

To set pronouns from (obj - an object) (this is PronounNotice):
	if the obj is the player, stop;  [ even in 3rd person, the player wouldn't refer to his avatar as him/her. ]
	repeat through all three columns of the language's pronoun list:
		if the gender-animation element includes any of the gender-animation usages for the obj:
			now chosen antecedent element is obj.

Chapter 2 - English Pronoun Names For I7

[This allows statements like "now 'he' is Alan".  Poorly tested.]

To decide what understood word is 'he': (- 'he' -).
To decide what understood word is 'she': (- 'she' -).
To decide what understood word is 'it': (- 'it' -).
To decide what understood word is 'them': (- 'them' -).

Volume 3 - English Language (for use with English Language by Graham Nelson)

[It proved necessary to replace practically the entire extension. Modal verbs and contractions and Grammatical definitions are unchanged.]

Section 1 - Preferred Gender

Prefer neuter gender is a truth state that varies.
Prefer neuter gender is usually true.
The preferred animate gender is a grammatical gender which varies.
The preferred animate gender is usually masculine gender.  [Matches old-fashioned English.]

To decide which grammatical gender is the printing gender for (o - an object):
	[not male or female, always use "it"]
	if o is not male and o is not female:
		decide on neuter gender;
	[neuter and prefer neuter gender, always use "it"]
	if o is neuter and prefer neuter gender is true:
		decide on neuter gender;
	[female and male, use preferred animate gender]
	if o is female and o is male:
		decide on preferred animate gender;
	[classic male; and non-neuter or male overrrides neuter]
	if o is male:
		decide on masculine gender;
	[classic female; and non-neuter or female overrrides neuter]
	if o is female:
		decide on feminine gender.

Section 2 - Viewpoint pronouns (in place of Section 2 - Saying pronouns in English Language by Graham Nelson)

To say we:
	now the prior named object is the player;
	if the story viewpoint is:
		-- first person singular: say "I";
		-- second person singular: say "you";
		-- third person singular:
			if printing gender for the player is:
				-- the masculine gender: say "he";
				-- the feminine gender: say "she";
				-- the neuter gender: say "it";
		-- first person plural: say "we";
		-- second person plural: say "you";
		-- third person plural: say "they";

To say us:
	now the prior named object is the player;
	if the story viewpoint is:
		-- first person singular: say "me";
		-- second person singular: say "you";
		-- third person singular:
			if printing gender for the player is:
				-- the masculine gender: say "him";
				-- the feminine gender: say "her";
				-- the neuter gender: say "it";
		-- first person plural: say "us";
		-- second person plural: say "you";
		-- third person plural: say "them";

To say ours:
	now the prior named object is the player;
	if the story viewpoint is:
		-- first person singular: say "mine";
		-- second person singular: say "yours";
		-- third person singular:
			if printing gender for the player is:
				-- the masculine gender: say "his";
				-- the feminine gender: say "hers";
				-- the neuter gender: say "its";
		-- first person plural: say "ours";
		-- second person plural: say "yours";
		-- third person plural: say "theirs";

To say ourselves:
	now the prior named object is the player;
	if the story viewpoint is:
		-- first person singular: say "myself";
		-- second person singular: say "yourself";
		-- third person singular:
			if printing gender for the player is:
				-- the masculine gender: say "himself";
				-- the feminine gender: say "herself";
				-- the neuter gender: say "itself";
		-- first person plural: say "ourselves";
		-- second person plural: say "yourselves";
		-- third person plural: say "themselves";

To say our:
	now the prior named object is the player;
	if the story viewpoint is:
		-- first person singular: say "my";
		-- second person singular: say "your";
		-- third person singular:
			if printing gender for the player is:
				-- the masculine gender: say "his";
				-- the feminine gender: say "her";
				-- the neuter gender: say "its";
		-- first person plural: say "our";
		-- second person plural: say "your";
		-- third person plural: say "their";

To say We:
	now the prior named object is the player;
	if the story viewpoint is:
		-- first person singular: say "I";
		-- second person singular: say "You";
		-- third person singular:
			if printing gender for the player is:
				-- the masculine gender: say "He";
				-- the feminine gender: say "She";
				-- the neuter gender: say "It";
		-- first person plural: say "We";
		-- second person plural: say "You";
		-- third person plural: say "They";

To say Us:
	now the prior named object is the player;
	if the story viewpoint is:
		-- first person singular: say "Me";
		-- second person singular: say "You";
		-- third person singular:
			if printing gender for the player is:
				-- the masculine gender: say "Him";
				-- the feminine gender: say "Her";
				-- the neuter gender: say "It";
		-- first person plural: say "Us";
		-- second person plural: say "You";
		-- third person plural: say "Them";

To say Ours:
	now the prior named object is the player;
	if the story viewpoint is:
		-- first person singular: say "Mine";
		-- second person singular: say "Yours";
		-- third person singular:
			if printing gender for the player is:
				-- the masculine gender: say "His";
				-- the feminine gender: say "Hers";
				-- the neuter gender: say "Its";
		-- first person plural: say "Ours";
		-- second person plural: say "Yours";
		-- third person plural: say "Theirs";

To say Ourselves:
	now the prior named object is the player;
	if the story viewpoint is:
		-- first person singular: say "Myself";
		-- second person singular: say "Yourself";
		-- third person singular:
			if printing gender for the player is:
				-- the masculine gender: say "Himself";
				-- the feminine gender: say "Herself";
				-- the neuter gender: say "Itself";
		-- first person plural: say "Ourselves";
		-- second person plural: say "Yourselves";
		-- third person plural: say "Themselves";

To say Our:
	now the prior named object is the player;
	if the story viewpoint is:
		-- first person singular: say "My";
		-- second person singular: say "Your";
		-- third person singular:
			if printing gender for the player is:
				-- the masculine gender: say "His";
				-- the feminine gender: say "Her";
				-- the neuter gender: say "Its";
		-- first person plural: say "Our";
		-- second person plural: say "Your";
		-- third person plural: say "Their";

Section 3 - Further pronouns (in place of Section 3 - Further pronouns in English Language by Graham Nelson)

To say those:
	say those in the accusative.

To say Those:
	say Those in the nominative.

To say those in (case - grammatical case):
	if the case is nominative:
		let the item be the prior named object;
		if the prior naming context is plural:
			say "those";
		otherwise if the item is the player:
			say "[we]";
		otherwise:
			if printing gender for the item is:
				-- the masculine gender: say "he";
				-- the feminine gender: say "she";
				-- the neuter gender: say "that";
	otherwise:
		let the item be the prior named object;
		if the prior naming context is plural:
			say "those";
		otherwise if the item is the player:
			say "[we]";
		otherwise:
			if printing gender for the item is:
				-- the masculine gender: say "him";
				-- the feminine gender: say "her";
				-- the neuter gender: say "that";

To say Those in (case - grammatical case):
	if the case is nominative:
		let the item be the prior named object;
		if the prior naming context is plural:
			say "Those";
		otherwise if the item is the player:
			say "[We]";
		otherwise:
			if printing gender for the item is:
				-- the masculine gender: say "He";
				-- the feminine gender: say "She";
				-- the neuter gender: say "That";
	otherwise:
		let the item be the prior named object;
		if the prior naming context is plural:
			say "Those";
		otherwise if the item is the player:
			say "[We]";
		otherwise:
			if printing gender for the item is:
				-- the masculine gender: say "Him";
				-- the feminine gender: say "Her";
				-- the neuter gender: say "That";

To say they:
	let the item be the prior named object;
	if the prior naming context is plural:
		say "they";
	otherwise if the item is the player:
		say "[we]";
	otherwise:
		if printing gender for the item is:
			-- the masculine gender: say "he";
			-- the feminine gender: say "she";
			-- the neuter gender: say "it";

To say They:
	let the item be the prior named object;
	if the prior naming context is plural:
		say "They";
	otherwise if the item is the player:
		say "[We]";
	otherwise:
		if printing gender for the item is:
			-- the masculine gender: say "He";
			-- the feminine gender: say "She";
			-- the neuter gender: say "It";

To say their:
	let the item be the prior named object;
	if the prior naming context is plural:
		say "their";
	otherwise if the item is the player:
		say "[our]";
	otherwise:
		if printing gender for the item is:
			-- the masculine gender: say "his";
			-- the feminine gender: say "her";
			-- the neuter gender: say "its";

To say Their:
	let the item be the prior named object;
	if the prior naming context is plural:
		say "Their";
	otherwise if the item is the player:
		say "[Our]";
	otherwise:
		if printing gender for the item is:
			-- the masculine gender: say "His";
			-- the feminine gender: say "Her";
			-- the neuter gender: say "Its";

To say them:
	let the item be the prior named object;
	if the prior naming context is plural:
		say "them";
	otherwise if the item is the player:
		say "[us]";
	otherwise:
		if printing gender for the item is:
			-- the masculine gender: say "him";
			-- the feminine gender: say "her";
			-- the neuter gender: say "it";

To say Them:
	let the item be the prior named object;
	if the prior naming context is plural:
		say "Them";
	otherwise if the item is the player:
		say "[Us]";
	otherwise:
		if printing gender for the item is:
			-- the masculine gender: say "Him";
			-- the feminine gender: say "Her";
			-- the neuter gender: say "It";

To say theirs:
	let the item be the prior named object;
	if the prior naming context is plural:
		say "theirs";
	otherwise if the item is the player:
		say "[ours]";
	otherwise:
		if printing gender for the item is:
			-- the masculine gender: say "his";
			-- the feminine gender: say "hers";
			-- the neuter gender: say "its";

To say Theirs:
	let the item be the prior named object;
	if the prior naming context is plural:
		say "Theirs";
	otherwise if the item is the player:
		say "[Ours]";
	otherwise:
		if printing gender for the item is:
			-- the masculine gender: say "His";
			-- the feminine gender: say "Hers";
			-- the neuter gender: say "Its";

To say themselves:
	let the item be the prior named object;
	if the prior naming context is plural:
		say "themselves";
	otherwise if the item is the player:
		say "[ourselves]";
	otherwise:
		if printing gender for the item is:
			-- the masculine gender: say "himself";
			-- the feminine gender: say "herself";
			-- the neuter gender: say "itself";

To say Themselves:
	let the item be the prior named object;
	if the prior naming context is plural:
		say "Themselves";
	otherwise if the item is the player:
		say "[Ourselves]";
	otherwise:
		if printing gender for the item is:
			-- the masculine gender: say "Himself";
			-- the feminine gender: say "Herself";
			-- the neuter gender: say "Itself";

[English Language used /they're/ to do "that's" which is counterintuitive, but preserved.
 /they/ /'re/ gives the expected behavior.
]
To say they're:
	let the item be the prior named object;
	if the prior naming context is plural:
		say "they";
	otherwise if the item is the player:
		say "[we]";
	otherwise:
		if printing gender for the item is:
			-- the masculine gender: say "he";
			-- the feminine gender: say "she";
			-- the neuter gender: say "that";
	say "['re]".

To say They're:
	let the item be the prior named object;
	if the prior naming context is plural:
		say "They";
	otherwise if the item is the player:
		say "[We]";
	otherwise:
		if printing gender for the item is:
			-- the masculine gender: say "He";
			-- the feminine gender: say "She";
			-- the neuter gender: say "That";
	say "['re]".

To say It:
	say "[regarding nothing]It".

To say There:
	say "[regarding nothing]There".

To say it:
	say "[regarding nothing]it".

To say there:
	say "[regarding nothing]there".

To say It's:
	say "[regarding nothing]It['re]".

To say There's:
	say "[regarding nothing]There['re]".

To say it's:
	say "[regarding nothing]it['re]".

To say there's:
	say "[regarding nothing]there['re]".

To say possessive:
	let the item be the prior named object;
	if the item is the player:
		say "[our]";
	otherwise if the prior naming context is plural:
		say "[the item][apostrophe]";
	otherwise:
		say "[the item][apostrophe]s";

To say Possessive:
	let the item be the prior named object;
	if the item is the player:
		say "[Our]";
	otherwise if the prior naming context is plural:
		say "[The item][apostrophe]";
	otherwise:
		say "[The item][apostrophe]s".

Volume 5 - Compatibility with Plurality (for use with Plurality by Emily Short)

Section - Deleted (in place of Section 4 - Enumeration in Plurality by Emily Short)

[The function of this section of Plurality was incorporated into the main pronoun rewrite, above.]

Section - Backward Compatibility for Plurality

[Both usages are deprecated.]

To have the parser notice (o - an object): 
	set pronouns from o.

To notice (o - an object) boringly:
	set pronouns from o.
	
Gender Options ends here.

---- DOCUMENTATION ----

Section 1 - Summary

Gender Options makes male, female, and neuter into independent on-off properties, each of which determines respectively whether "HE", "SHE", or "IT" can be used to refer to the thing.  It makes "THEY" refer to any plural-named or ambiguously plural thing.  It also allows some authorial choices over which pronoun to print for things with multiple valid genders or numbers.  It should be just as fast and efficient as the standard rules.

I have a taste for writing stuff with odd gender behavior, and so I decided to do this in a general-purpose manner.  There are several purposes most of which are shown in the City Park example.

Section 2 - Gender/Number Model and Pronouns

In the new model, male, female, and neuter are each separate properties, so that a thing is "male" or "not male", "female" or "not female", and "neuter" or "not neuter".  This allows for maximum flexibility short of adding new pronouns (which is much more complicated and probably slower).

The gender is primarily for pronoun purposes. 
When the player types "HE", anything male will match.
When the player types, "SHE", anything female will match.
When the player types "IT", anything neuter will match.  
Something which is none of the three will never match any singular pronoun, which is not usually desirable, but may occasionally be useful (e.g. "The Exalted One shall not be referred to by pronouns!").

If you define a "man" or "men", it will by default be male, and not female or neuter.
If you define a "woman" or "women", it will by default be female, and not male or neuter.
If you define a "person" or "people", it will by default be male and female, but not neuter.  This makes more sense than it might at first appear; a person of unknown gender can be referred to as "he" or "she" by the player.
If you define a "thing" or an "animal", it will by default be neuter, and not male or female.

All of these can be overrriden and changed by specifying things like:
	Tracy is not male.
	Tracy is not female.
	Tracy is neuter.

The parser will update and recognize the appropriate pronouns when used by the player.  So a character who is both male and female can be referred to as "he" or "she" by the player, a ship can be referred to as "it" or "she", etc.

A similarly flexible model is implemented for number.  Any object which is plural-named or ambiguously plural can be referred to as "THEY".  Any object which is ambiguously plural can additionally be referred to using the singular pronouns -- whichever ones apply according to its gender.

So an amibguously plural, male, female, neuter thing can be referred to by any of the pronouns THEY, HE, SHE, IT.  Even if it's singular-named.
	The jumble is an ambiguously plural, male, female, neuter thing.  
	The description of the jumble is "Things and people, all in a jumble! [They] [are] quite something."

The concept of "ambiguously plural" items is present in the Standard Rules but is not fully implemented.  (A singular-named ambiguously plural item will not match "they" in the Standard Rules.  It will match with Gender Options active.)

Section 3 - Advice on the gender model

This is designed to be a plug-in extension which requires no change in existing code and keeps the same behavior if you have been using "man", "woman", or "animal".  If you have been using "person" to refer to generic non-gendered people and using "ambiguously plural" appropriately, this should simply improve the pronoun behavior with no code changes necessary.   But there may be some changes required if you have been using explicit gender adjectives.

This is because now male, female, and neuter are entirely separate traits; setting one does not set another.  Consider this code:
	Tracy is a person.
	Tracy is male.
	
Because the default for "person" is both male and female, responding to "him" and "her", this makes Tracy both male and female; the "male" adjective does nothing.  If you want to make Tracy a man (male and not female), you would have to do this:
	Now Tracy is not female.

Now suppose you want to change Tracy from a man to a woman (female and not male).  You'll have to make two statements:
	Now Tracy is female.
	Now Tracy is not male.

Now you want to make Tracy respond to "it".
	Now Tracy is neuter.
	
Tracy is still female.  If you want Tracy to stop responding to "her":
	Now Tracey is not female.

Similarly, if you make an animal female, the player can refer to the animal as both "it" and "her" (unless you also make the animal not neuter):
	Peppy is a female animal.
	
This is usually desirable.

Section 4 - Gender in output messages

Gender and number is used for a second purpose other than recognizing pronouns in the English Language extension, and we must fix this up too.
It shows up in message substitutions such as [those].
For this, each object must have a single preferred grammatical gender, even when it has multiple genders which match player input.

We define two variables for this purpose: "prefer neuter gender" and "default animate gender".  These are variables so that they can be changed at runtime (for effect).

	Prefer neuter gender is a truth state which varies.
	Prefer neuter gender is usually true.
If you have a dog or a ship which can be referred to as "it" or "her", this will print "it".
If you would rather have "she" printed, use this:
	Prefer neuter gender is false.

	The preferred animate gender is a grammatical gender which varies.
	The preferred animate gender is usually the masculine gender.
If you have an androgynous person (both male and female, but not neuter), this will print "him".
If you would rather have "her" printed, use this:
	The preferred animate gender is the feminine gender.
	
Prefer neuter gender is checked first; if it is false, then the preferred animate gender is checked.  An object will never be printed with a pronoun which isn't valid for it, unless it is not male, not female, *and* not neuter -- not responding to any pronouns from the player -- in which case "it" will be used.

Note that these use values of a different kind from the genders of objects for parsing purposes; the phrase "masculine gender", "feminine gender", and "neuter gender" must be specifically used.

This is all implemented with the following decide phrase.  If you don't like these rules and want to do something even more complicated (perhaps a per-object choice), override the decide phrase.

	To decide which grammatical gender is the printing gender for (o - an object):

Section 5 - Number in output messages

Ambiguously plural items (like "pair of shoes") will be treated as plural or singular by output messages depending on whether they are "plural-named" or "singular-named"  This is standard behavior.  This does not affect the ability to refer to them by pronouns (you can always use both "they" and the singular pronouns for their gender).

The plural-named property is also used for the items like "the trees" which are always plural.  This is standard behavior.

Please note that for a thing which is ambiguously plural but singular-named, such as "pair of dice", the substitution "[they're]" will produce "that's", while "[they]['re]" will produce "it's".  Choose wisely!

Section 6 - Printing differences from standard behavior

For reference, this is the procedure currently used in the Standard Rules as of the time of writing:

	For non-people:
	If person is plural, the plural form ("they") is used.
	Otherwise, neuter form ("it") is used.

	For people (including animals)
	If person is the player, "you" is used.
	If person is plural, plural form ("they") is used.
	Otherwise, if person is female, female form ("her") is used.
	Otherwise, if person is neuter, neuter form ("it") is used.
	Otherwise, male form ("him") is used.

In contrast, this is the procedure in Emily Short's Plurality:

	If the thing/person is plural, plural form ("they") is used.
	Otherwise, if the thing/person is the player, "you" is used.
	Otherwise, if the thing/person is neuter, neuter form ("it") is used.
	Otherwise, if the thing/person is male, male form ("he") is used.
	Otherwise, if the thing/person is female, female form ("she") is used.

Changing the gender model causes these to be two different procedures, which is why I wrote an entirely new and more versatile procedure.

Section 7 - Interaction with Other Extensions

Gender Options replaces parts of Standard Rules by Graham Nelson and should be included after it.
Gender Options replaces most of English Language by Graham Nelson and should be included after it.

Gender Options is compatible with Neutral Standard Responses by Nathanael Nerode.
Gender Options is incompatible with Neutral Library Messages by Aaron Reed, which predates the "reponses" system.  Neutral Standard Responses is intended as a replacement.

Gender Options includes fixes for the gender handling in Original Parser by Ron Newcomb.  However, Original Parser is broken on the current version of Inform, so don't use it.  As a result this is untested and Gender Options probably doesn't work as well with Original Parser as it does with the standard parser.

Gender Options is compatible with Plurality by Emily Short in that it is safe to include both.  But they will probably not interact well due to conflicting gender assumptions.  Plurality is largely obsolete due to incorporation of most of its features in the Standard Rules as of Inform 6M62; please use the Standard Rules features in preference to the features in Plurality.

Gender Options is incompatible with Second Gender by Felix Larsson.  The two do very similar things, but IMO Gender Options does so in a cleaner and more comprehensive fashion.  It was developed completely independently.

Section 8 - Changelog

Version 3/170818 - Small documentation and comment tweaks.
Version 3/170816 - Replaced "always" with "usually" for man and woman.  Eliminated implications which didn't work.  Mboved "person is usually not neuter" into correct section.  Removed androgyne kind and collective noun property for efficiency (they were syntactic sugar).  Revised documentation, comments, and City Park exmaple.  Added "It for All" example.
Version 2/170815 - First public release for gamma testing.

Example: * City Park 

This consists of a room with items featuring most of the combinations of gender and number options which seemed plausible.  Take special note of the toy ship (you can call it "she").  This is also the test suite for the extension.

	*: "Everyone Comes To City Park" by Nathanael Nerode
	
	The release number is 2. [Second released version of this test suite]
	Include Gender Options by Nathanael Nerode.
	City Park is a room.
	The description of City Park is "Everyone comes to City Park!"
	
	The shadow is a person in the park.  "Someone skulks in the shadow."
	Understand "skulker" as the shadow.
	The description of the shadow is "[We] [can't get] a good look at [regarding the shadow][them]."
        The shadow is neuter.
	
	John is a man in the park.
	The description of John is "John is a dapper man."
	Understand "dapper man" as John.
	
	Jane is a woman in the park.
	The description of Jane is "Jane is an elegant woman."
	Understand "elegant woman" as Jane.
	
	A deity is an androgyne in the park.
	Understand "Hermaphroditus" as deity.
	Description of deity is "A deity with both male and female characteristics."
	Deity is male.
	Deity is female.
	
	A couple of girls are women in the park.
	Description of couple of girls is "Two girls who clutch each other inseparably."
	A couple of girls is ambiguously plural.
	A couple of girls is plural-named.
	A couple of girls has indefinite article "a".
		
	A bunch of boys are men in the park.
	Description of bunch of boys is "A bunch of boys wander around."
	A bunch of boys is ambiguously plural.
	A bunch of boys is plural-named.
	A bunch of boys has indefinite article "a".
	
	Some sunbathers are people in the park.
	Description of the sunbathers is "A mixed-gender group is out bathing in the sun."
	Sunbathers are male.
	Sunbathers are female.
	Sunbathers are ambiguously plural.
	Sunbathers are plural-named.
	Sunbathers are not proper-named.
	Sunbathers have indefinite article "a few".
	Understand "few sunbathers" as sunbathers.
	Understand "group" as sunbathers.
	Understand "mixed-gender group" as sunbathers.

	A deer-animal is a kind of animal.
	Deer-animal usually have printed plural name "deer".
	
	A group of does are deer-animal in the park.
	Description of the does is "A group of does are grazing in the park."
	Does are female.
	Does are ambiguously plural.
	Does are plural-named.
	Does have indefinite article "a".
	Understand "deer" as does.
	
	A buck is an deer-animal in the park.
	Description of the buck is "The buck is watching the does."
	Buck is male.
	Understand "deer" as buck.

	A cute puppy is an animal in the park.
	Description of the puppy is "There's a cute puppy running around."
	Puppy is female.
	Puppy is neuter.
	
	A plastic banana is a thing in the park.
	Description of banana is "It's a plastic banana.  I don't know why it exists, either."
	
	A pair of dice is a thing in the park.  "A pair of dice lie abandoned on the ground."
	Description of pair of dice is "A pair of casino-style dice."
	A pair of dice is ambiguously plural.
	A pair of dice is not plural-named.
	
	A toy ship is a thing in the park.  "A toy ship lies abandoned to one side."
	Description of ship is "A toy ship called the 'Santa Maria'."
	Ship is female.
	Understand "Santa Maria" as ship.
	
	A large cardboard box is a container in the park.
	Description of cardboard box is "A large cardboard box is lying out in the sun."
	Cardboard box is enterable.
	Cardboard box is openable.
	
	The jumble is an ambiguously plural, male, female, neuter thing in the park.
	The description of the jumble is "Things and people, all in a jumble! [They] [are] quite something.".
	
	The Unpronounable One is a thing in the park.
	The description of the Unpronounable One is "[We] [may] not refer to the Unpronounable One by pronouns."
	The Unpronounable One is not neuter.

	Analyzing is an action applying to one thing.
	Understand "gender [something]" as analyzing.
	Carry out analyzing:
		say "[A noun] [are] here; [regarding the noun][they]['re] here." 
		
	setting female default is an action applying to nothing.
	Understand "matriarchy" as setting female default.
	Carry out setting female default:
		now preferred animate gender is feminine gender.

	setting male default is an action applying to nothing.
	Understand "patriarchy" as setting male default.
	Carry out setting male default:
		now preferred animate gender is masculine gender.

	setting gendered default is an action applying to nothing.
	Understand "anthropomorphize" as setting gendered default.	
	Carry out setting gendered default:
		now prefer neuter gender is false.
		
	setting neuter default is an action applying to nothing.
	Understand "objectify" as setting neuter default.
	Carry out setting neuter default:
		now prefer neuter gender is true.
	
	test pronouns with "pronouns / x john / pronouns / x jane / pronouns / x deity / pronouns / x girls / pronouns / x boys / pronouns / x sunbathers / pronouns / x does / pronouns / x buck  / pronouns  / x dice / pronouns / x ship / pronouns / x unpronounable one / pronouns / x jumble / pronouns"  in City Park.

	test gender with "anthropomorphize / gender buck / gender puppy / gender shadow / objectify / gender buck / gender puppy / gender shadow / anthropomorphize / matriarchy / gender deity  / gender shadow  / x shadow / patriarchy / gender deity / gender shadow / x shadow" in City Park.

	test number with "gender girls / gender boys / gender sunbathers / gender dice" in City Park.
	
Example: ** It for All

Some authors have requested that "it" apply to anything, plural or singular, of any gender, for the convenience of their players.

	"It for All"

	Include Gender Options by Nathanael Nerode.

	A person is neuter. A man is neuter.  A woman is neuter.  [Overrides "usually not neuter", makes people respond to IT]
	A plural-named thing is ambiguously plural. [Makes all plural-named objects respond to IT]
	Prefer neuter gender is false. [Printed text shouldn't refer to characters as "it" if they're male or female.]

	Marching Grounds is a room.  "The place for marching!"

	to march is a verb. to watch is a verb.

	The soldiers are plural-named men in Marching Grounds. 
	The description of the soldiers is "[Regarding the soldiers][They] [march] up and down."

	An observer is a improper-named woman in Marching Grounds.
	The description of the observer is "[Regarding the observer][They] [watch] the soldiers."

	test pronouns with "x soldiers / pronouns / x observer / pronouns".

	
