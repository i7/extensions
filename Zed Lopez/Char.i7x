Version 1 of Char by Zed Lopez begins here.

Part 32-bit chars on glulx (for Glulx only)

[ This seems to work, but is probably a reckless thing to do.
  Use at your own risk. ]

Use UTF-32 translates as
(- Constant UTF_32; -).

Include (-
#ifdef UTF_32; 
Constant TEXT_TY_Storage_Flags = BLK_FLAG_MULTIPLE + BLK_FLAG_WORD;
#ifnot;
Constant TEXT_TY_Storage_Flags = BLK_FLAG_MULTIPLE + BLK_FLAG_16_BIT;
#endif; 
Constant Large_Unicode_Tables;

{-segment:UnicodeData.i6t}
{-segment:Char.i6t}

-) instead of "Character Set" in "Text.i6t".

Part Char type

include (-
[ unicodeValue s n x cp1 p1 dsize;
if (n < 0) return 0;
cp1 = s-->0; p1 = TEXT_TY_Temporarily_Transmute(s);
dsize = BlkValueLBCapacity(s);
if (n >= dsize) return 0;
x = BlkValueRead(s,n);
TEXT_TY_Untransmute(s, p1, cp1);
return x;
];
-)

To decide what number is an/-- ord of/-- a/an/-- (T - a text): (- unicodeValue({T},0) -).

[ equivalent to c cast as a number ]
To decide what number is an/-- ord of/-- a/an/-- (C - a unicode character): (- {C} -).

[ named version for application -- can't use inline I6]
To decide what number is wrapped ord (C - a unicode character) (this is char-to-num): decide on ord of C.

To decide what unicode character is a/-- char (N - a number) of/for a/an/-- (T - a text):  (- unicodeValue({T},({N}-1)) -)

To decide what unicode character is a/-- char of/for a/an/-- (T - a text):  (- unicodeValue({T},0) -)

To decide what list of numbers is an/-- ord of/-- a/an/-- (L - a list of unicode characters):
  decide on char-to-num applied to L;

[ equivalent to n cast as a unicode character ]
To decide what unicode character is a/-- char of/for/-- a/an/-- (N - a number): (- {N} -).

To decide what unicode character is a/-- char of/for/-- a/an/-- (u - a unicode character): (- {u} -).

[ named version for application -- can't use inline I6]
To decide what unicode character is wrapped char (N - a number) (this is num-to-char):
  decide on char of N.

To decide what list of unicode characters is char/chars of/-- a/an/-- (L - a list of numbers):
  decide on num-to-char applied to L.
  
To decide what list of unicode characters is chars of/-- a/an/-- (T - a text):
    let result be a list of unicode characters;
    let len be number of characters in T;
    repeat with i running from 1 to len begin;
      add char for character number i in T to result;
    end repeat;
    decide on result;

To say (L - a list of sayable values) join/joined by/with/-- a/an/-- (sep - a sayable value):
  let len be the number of entries in L;
  repeat with i running from 1 to len - 1 begin;
    say entry i in L;
    say sep;
  end repeat;
  say entry len in L;

To say (L - a list of sayable values) join/joined:
  repeat with i running through L begin;
    say i;
  end repeat;

To decide what text is (L - a list of unicode characters) as a/-- text:
  decide on "[L joined]".

Section n copies z (for z-machine only)

To say (N - a number) copies of (U - a unicode character):
    (- for ({-my:1} = 0 : {-my:1} < {N} : {-my:1}++ ) print (char) {U}; -)

section n copies g (for glulx only)

To say (n - a number) copies of (u - a unicode character): (- {-my:2} = {u}; for ({-my:1} = 0 : {-my:1} < {N} : {-my:1}++ )  @streamunichar {-my:2}; -).

section n spaces

unicode-space is a unicode character that varies. [ defaults to unicode 32, a space. ]

To say (N - a number) spaces: say "[N copies of unicode-space]".

Char ends here.

---- Documentation ----

Example: * Char

*: "Char"
	
	Include Char by Zed Lopez.
	Include Unit Tests by Zed Lopez.
	
	Use test automatically.
	Use quit after autotesting.
	
	Lab is a room.
	
	Ord-text is a unit test. "Ordinal of text".
	
	For testing ord-text:
	  for "Cat" assert ord of "Cat" is 67;
	  for "empty" assert ord of "" is 0;
	  for "B" assert ord of "B" is 66;
	
	Char-for-num is a unit test. "char for <number>".
	
	For testing char-for-num:
	  for "32 -> space" assert "[char 32]" exactly matches " ";
	  for "122 -> z" assert "[char 122]" exactly matches "z";
	
	Text-to-char is a unit test. "char of <text>".
	
	For testing text-to-char:
	  for "space" assert char of " " is char 32;
	  for "z" assert char of "z" is char 122;
	
	Ord-char is a unit test. "Ordinal of char".
	
	For testing ord-char:
	  for "C" assert ord of char 67 is 67;
	  for " " assert ord of char 32 is 32;
	
	Char-list-to-num-list is a unit test. "ord of <list of unicode characters>".
	
	For testing char-list-to-num-list:
	  let L be a list of unicode characters;
	  add char 67 to L;
	  add char 97 to L;
	  add char 116 to L;
	  for "Cat" assert ord of L is { 67, 97, 116 };
	
	Num-list-to-char-list is a unit test. "chars of <list of numbers>".
	
	For testing num-list-to-char-list:
	  let L be chars of { 67, 97, 116 };
	  for "Cat" assert entry 2 in L is char 97;
	  for "Cat" assert number of entries in L is 3;
	
	Text-to-chars is a unit test. "chars of <text>".
	
	For testing text-to-chars:
	  let L be chars of "Cat";
	  for "Cat, first" assert entry 1 in L is char 67;
	  for "Cat, last" assert entry 3 in L is char 116;
	  for "Cat" assert number of entries in L is 3;
	
	Join-char-list is a unit test. "<list of sayable values> joined by <sayable value>".
	
	Numericat is a list of unicode characters that varies.
	asterisk is initially "*".
	comma-space is initially ", ".
	empty-string is initially "".
	
	For testing join-char-list:
	  now numericat is chars of { 67, 97, 116 };
	  for "C*a*t" assert "[numericat joined by asterisk]" exactly matches "C*a*t";
	  for "C, a, t" assert "[numericat joined by comma-space]" exactly matches "C, a, t";
	  for "saying Cat" assert "[numericat joined by empty-string]" exactly matches "Cat";
	
	Say list of chars as a text is a unit test.
	
	For testing say list of chars as a text:
	  let L be chars of { 67, 97, 116 };
	  for "say cat" assert "[L as a text]" exactly matches "Cat";
	
	Joined is a unit test. "Joined"
	
	For testing joined:
	  let L be chars of { 67, 97, 116 };
	  for "join L" assert "[L joined]" exactly matches "Cat";
	
	Alice is a person. Bob is a person.
	
	Alice-and-bob is initially { Alice, Bob }.
	
	sv-joined is a unit test. "Sayable value joined."
	
	For testing sv-joined:
	  for "alicebob" assert "[alice-and-bob joined]" exactly matches "AliceBob".
	
	char-list-as-text is a unit test. "List of chars as a text".
	
	For testing char-list-as-text:
	  let L be chars of { 67, 97, 116 };
	  let T be L as a text;
	  for "char list as text" assert T exactly matches "Cat";
	
	n-copies is a unit test. "N copies".
	
	For testing n-copies:
	  for "0 copies" assert "[0 copies of char 88]" exactly matches "";
	  for "3 copies" assert "[3 copies of char 88]" exactly matches "XXX";
	
	n-spaces is a unit test. "N spaces".
	
	For testing n-spaces:
	  for "5 spaces" assert "[5 spaces]" exactly matches "     ";
