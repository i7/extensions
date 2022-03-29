Version 1/220328 of Textile by Zed Lopez begins here.

"Text utility functions."

The empty-string is always "".

To decide what text is an/-- expanded (T - a text):
    (- TEXT_TY_SubstitutedForm({-new:text}, {-by-reference:T}) -).

To decide if (S - text) exactly matches (T - text): decide on whether or not S exactly matches the text T;

To decide if (S - text) does not exactly match (T - text): if S exactly matches T, no; yes.

To decide if (S - text) includes (T - text): decide on whether or not S matches the text T;

To decide if (S - text) does not include (T - text): if S includes T, no; yes.

To decide what number is the occurrences of (substr - a text) in (str - a text):
    decide on the number of times str matches the text substr.

To decide what text is (T - a text) trimmed:
  if T rmatches "^\s*(.*?)\s*$", now T is match 1;
  decide on T.

To puts (sv - a sayable value): say "[sv][line break]".
To puts (T - a text): say T; say line break.

Definition: a text (called T) is blank if the substituted form of T exactly matches the text "".

To rmatch (V - a text) by (R - a text), case insensitively:
  (- TEXT_TY_Replace_RE(REGEXP_BLOB,{-by-reference:V},{-by-reference:R},0,{phrase options}); -).

To decide if (V - a text) rmatches (R - a text), case insensitively:
  (- TEXT_TY_Replace_RE(REGEXP_BLOB,{-by-reference:V},{-by-reference:R},0,{phrase
  options}) -).

[ unfortunate ambiguity if we add case insensitively here ]
To decide if (V - a text) does not rmatch (R - a text), case insensitively:
  (- (~~(TEXT_TY_Replace_RE(REGEXP_BLOB,{-by-reference:V},{-by-reference:R},0,{phrase options}))) -).

[ use immediately after a regular expression match ]
To decide what text is the/a/-- match (N - a number):
    (- TEXT_TY_RE_GetMatchVar({N}) -).

To decide what number is the left/-- index of/-- a/an/-- regexp (R - a text) in (U - a text):
  if R is blank or U is blank, decide on 0;
  let result be 0;
  if U rmatches "((.*?)([R]))", now result is 1 + length of match 2;
  rmatch U by R; [ don't screw up whatever parenthetical groups R might have had ]
  decide on result;

[ the same regexp as above would work here, but this one is probably quicker ]
To decide what number is the left/-- index of/-- a/an/-- (T - a text) in (U - a text):
  if T is blank or U is blank, decide on 0;
  let result be 0;
  if U rmatches "(([T]).*)", now result is 1 + length of U - size of match 1;
  decide on result;

To decide what number is a/-- length/size/count of/-- a/an/-- (T - a text):
  decide on the number of characters in T.

To say char/chars/character/characters (start - a number) to (end - a number) in/of (T - a text):
    let len be length of T;
    if start < 1 or end > len begin;
      say "[line break]*** characters [start] to [len] out of range for text |[T]| of length [len].";
    else;
      repeat with i running from start to end begin;
        say character number i in T;
      end repeat;
     end if;

To decide what text is the/a/-- substr of (T - a text) from (start - a number) to (end - a number):
  let len be length of T;
  if start < 1 or end > len begin;
    say "[line break]*** characters [start] to [len] out of range for text |[T]| of length [len].";
    decide on "";
  end if;
  decide on expanded "[chars start to end of T]";
  
To decide what text is the first (n - a number) char/chars/character/characters of (T - a text):
  decide on substr of T from 1 to n;

To decide what text is the first char/character of (T - a text):
  decide on character number 1 in T;

To decide what text is the last char/character of (T - a text):
  decide on character number (number of characters in T) in T;

To decide what text is the last (n - a number) char/chars/character/characters of (T - a text):
  let len be length of T;
  let start be 1 + len - n;
  decide on substr of T from start to len;

To decide what text is the substr in/of (T - a text) from (start - a number) for (substrlen - a number) char/chars/character/characters:
  decide on the substr of T from start to (start + substrlen - 1);

To decide what text is char/character (n - a number) in/of (T - a text):
  decide on character number n in T;

To decide what text is (T - a text) with char/chars/character/characters/-- (m - a number) to (n - a number) replaced with/-- (R - a text):
  let result be text;
  if m > 1, now result is "[chars 1 to m - 1 of T]";
  now result is result + R;
  if n < length T, now result is result + "[chars n + 1 to length T of T]";
  if n is length T, now result is result + "[last 1 char of T]";
  decide on expanded result;

To decide what text is (T - a text) with char/chars/character/characters/-- (m - a number) to (n - a number) cut:
  decide on expanded "[T with m to n replaced with empty-string]";

To say (T - a text) with char/character/-- (n - a number) cut:
  say T with n to n replaced with "";

To decide what text is text (T - a text) with char/chars/character/characters/-- (m - a number) to (n - a number) cut (this is decide-cut):
  decide on expanded "[T with m to n cut]";

To decide what text is (T - a text) with first (U - a text) replaced with (V - a text):
  if U exactly matches "", decide on T;
  let idx be index of U in T;
  if idx is 0, decide on T;
  decide on expanded "[T with chars idx to idx + (length U - 1) replaced with V]";

To decide what text is (T - a text) with first regexp (R - a text) replaced with (V - a text):
  if T is blank or R is blank, decide on T;
  let index be 0;
  let len be 0;
  let result be T;
  if T rmatches "^(.*?)([R])" begin;
    now len is size of match 2;
    now index is 1 + size of match 1;
    now result is T with chars index to (index + len - 1) replaced with V;
  end if;
  rmatch T by R;
  decide on expanded result;

Include (-
[ textConcat t u result;
BlkValueCopy(result,t);
return TEXT_TY_Concatenate(result, u);
];
-);

To decide what text is (T - a text) with (U - a text) inserted at char/character/-- (n - a number):
  now U is "[U][char n in T]";
  replace character number n in T with U;
  decide on T;

To decide what text is (T - a text) plus/concat/+ (U - a text):
  (- textConcat({T},{U},{-new:text}) -).

To decide what text is (T - a text) with (U - a text) inserted at char/character/-- (n - a number):
  replace character number n in T with U + character number n in T;
  decide on T;

To decide what list of texts is (T - a text) split on/by/with/-- (sep - a text):
  let L be a list of texts;
  let idx be the index of sep in T;
  let slen be length sep;
  while idx is not 0 begin;
    add first idx - 1  chars of T to L;
    now T is T with chars 1 to (idx + slen - 1) cut;
    now idx is the index of sep in T;
  end while;
  add T to L;
  decide on L;

Textile ends here.

---- Documentation ----

Chapter Examples

Example: * Textile

	*: "Textile"
	
	Include Textile by Zed Lopez.
	Include Unit Tests by Zed Lopez.
	
	Use test automatically.
	Use quit after autotesting.
	
	Lab is a room.
	
	
	To say lbrack: say bracket.
	To say rbrack: say close bracket.
	
	expansive is a unit test. "Expanded".
	
	To say xxx: say "123".
	To say zzz: say "123".
	To say xyz: say "456".
	To say emptiness: say "".
	
	
	xyzzy is always "xyzzy".
	banana is always "banana".
	
	For testing expansive:
	  for "literal" assert expanded "fubar" exactly matches "fubar";
	  for "empty" assert expanded "" is blank;
	  for "[lbrack]xxx[rbrack]" assert expanded "[xxx]" exactly matches "123";
	  for "[lbrack]xxx[rbrack]" assert expanded "[xxx]" is "123"; [ "is" should work, as there's a literal on one side ]
	
	[ skipped text matches/does not match topic; text includes / does not include topic ]
	
	Exactly-matches is a unit test. "<text> exactly matches <text>".
	
	For testing exactly-matches:
	  for "[lbrack]xxx[rbrack]" assert "[xxx]" exactly matches "123";
	  for "[lbrack]xxx[rbrack] and [lbrack]zzz[rbrack]" assert "[xxx]" exactly matches "[zzz]";
	  for "[lbrack]xxx[rbrack]" refute "[xxx]" exactly matches "[xyz]";
	  for "[lbrack]xxx[rbrack]" refute "[xxx]" exactly matches "1231";
	  for "123" assert "123" exactly matches "123";
	  for "123" refute "123" exactly matches "0123";
	  for "123" refute "123" exactly matches "1234";
	  for "empty" assert "" is blank;
	  for "empty" refute "" exactly matches " ";
	  for "empty" assert "[emptiness]" is blank;
	
	Does-not-exactly-match is a unit test. "<text> does not exactly match <text>".
	
	
	For testing does-not-exactly-match:
	  for "[lbrack]xxx[rbrack]" refute "[xxx]" does not exactly match "123";
	  for "[lbrack]xxx[rbrack] and [lbrack]zzz[rbrack]" refute "[xxx]" does not exactly match "[zzz]";
	  for "[lbrack]xxx[rbrack]" assert "[xxx]" does not exactly match "[xyz]";
	  for "[lbrack]xxx[rbrack]" assert "[xxx]" does not exactly match "1231";
	  for "123" refute "123" does not exactly match "123";
	  for "123" assert "123" does not exactly match "0123";
	  for "123" assert "123" does not exactly match "1234";
	  for "empty" refute "" does not exactly match "";
	  for "empty" assert "" does not exactly match " ";
	  for "empty" refute "[emptiness]" does not exactly match "";
	
	Text-includes is a unit test. "<text> includes <text>".
	
	For testing text-includes:
	  for "1234" assert "1234" includes "23";
	  for "1234" assert "1234" includes "123";
	  for "1234" assert "1234" includes "234";
	  for "1234" assert "1234" includes "1";
	  for "1234" assert "1234" includes "4";
	  for "1234" assert "1234" includes "2";
	  for "1234" refute "1234" includes "0";
	  for "1234" refute "1234" includes "0234";
	  for "[lbrack]xxx[rbrack]" assert "[xxx]" includes "3";
	  for "[lbrack]xxx[rbrack]" refute "[xxx]" includes "5";
	
	Text-does-not-include is a unit test. "<text> does not include <text>".
	
	For testing text-does-not-include:
	  for "1234" refute "1234" does not include "23";
	  for "1234" refute "1234" does not include "123";
	  for "1234" refute "1234" does not include "234";
	  for "1234" refute "1234" does not include "1";
	  for "1234" refute "1234" does not include "4";
	  for "1234" refute "1234" does not include "2";
	  for "1234" assert "1234" does not include "0";
	  for "1234" assert "1234" does not include "0234";
	  for "[lbrack]xxx[rbrack]" refute "[xxx]" does not include "3";
	  for "[lbrack]xxx[rbrack]" assert "[xxx]" does not include "5";
	
	Occurrent is a unit test. "Occurrent".
	
	For testing occurrent:
	  for "x, banana" assert the occurrences of "x" in "banana" is 0;
	  for "a, banana" assert the occurrences of "a" in "banana" is 3;
	  for "n, banana" assert the occurrences of "n" in "banana" is 2;
	
	Trimmed is a unit test. "Trimmed."
	
	For testing trimmed:
	  for "  [lbrack]xxx[rbrack]   " assert "  [xxx]   " trimmed is "[xxx]";
	  for "[lbrack]xxx[rbrack]  " assert "[xxx]  " trimmed is "[xxx]";
	  for "  [lbrack]xxx[rbrack]" assert "  [xxx]" trimmed is "[xxx]";
	  for "[lbrack]xxx[rbrack]" assert "[xxx]" trimmed is "[xxx]";
	  for "  123   " assert "  123   " trimmed is "123";
	  for "123  " assert "123  " trimmed is "123";
	  for "  123" assert "  123" trimmed is "123";
	  for "123" assert "123" trimmed is "123";
	
	[ put rmatch, if rmatches, does not rmatch, match <n> here]
	
	
	left-index-regexp is unit test. "left index regexp".
	
	For testing left-index-regexp:
	  for "123, 123" assert the left index of regexp "123" in "123" is 1;
	  for "ca, abecadarium" assert index of regexp "ca" in "abecadarium" is 4;
	  for "an, banana" assert the index of regexp "na" in "banana" is 3;
	  for "us, publius" assert the index of regexp "us" in "publius" is 6;
	  for "empty in whitespace" assert the index of regexp "" in "  " is 0;
	  for "xyz, banana" assert the index of regexp "xyz" in "banana" is 0;
	  for "xyz, xzy" assert the index of regexp "xyz" in "xzy" is 0;
	  for "an, banana" assert the index of regexp ".a" in "banana" is 1;
	  for "an, banana" assert the index of regexp ".n" in "banana" is 2;
	  for "an, banana" assert the index of regexp ".na$" in "banana" is 4;
	
	Left-index is a unit test. "Left index".
	
	For testing left-index:
	  for "123, 123" assert the left index of "123" in "123" is 1;
	  for "ca, abecadarium" assert index of "ca" in "abecadarium" is 4;
	  for "an, banana" assert the index of "na" in "banana" is 3;
	  for "us, publius" assert the index of "us" in "publius" is 6;
	  for "empty in whitespace" assert the index of "" in "  " is 0;
	  for "xyz, banana" assert the index of "xyz" in "banana" is 0;
	  for "xyz, xzy" assert the index of "xyz" in "xzy" is 0;
	
	length is a unit test. "Length."
	
	For testing length:
	  for "empty" assert length of "" is 0;
	  for "X" assert size "X" is 1;
	  for "banana" assert count "banana" is 6;
	
	say-chars is a unit test. "Say chars <m> to <n> of <text>".
	
	For testing say-chars:
	  for "xyzzy, 1-3" assert "[chars 1 to 3 of xyzzy]" exactly matches "xyz";
	  for "banana, 5-6" assert "[chars 5 to 6 of banana]" exactly matches "na";
	  for "empty, 0-0 error" assert "[chars 0 to 0 of empty-string]" reports error;
	  for "xyzzy, 1-1" assert "[chars 1 to 1 of xyzzy]" exactly matches "x";
	  for "xyzzy, 5-5" assert "[chars 5 to 5 of xyzzy]" exactly matches "y";
	  for "banana, -3 to -1 error" assert "[chars -3 to -1 of banana]" reports error;
	
	substr is a unit test. "Substr".
	
	For testing substr:
	  for "xyzzy, 1-3" assert substr of xyzzy from 1 to 3 exactly matches "xyz";
	  for "banana, 5-6" assert substr of banana from 5 to 6 exactly matches "na";
	  for "empty, 0-0" assert substr of empty-string from 0 to 0 is empty;
	  for "empty, 0-0 error" assert "[substr of empty-string from 0 to 0]" reports error;
	  for "empty, 1-2" assert substr of empty-string from 1 to 2 is empty;
	  for "empty, 1-2 error" assert "[substr of empty-string from 1 to 2]" reports error;
	  for "xyzzy, 1-1" assert substr of xyzzy from 1 to 1 exactly matches "x";
	  for "xyzzy, 5-5" assert substr of xyzzy from 5 to 5 exactly matches "y";
	  for "banana, -3 to -1" assert substr of banana from -3 to -1 is empty;
	  for "banana, -3 to -1 error" assert "[substr of banana from -3 to -1]" reports error;
	  for "banana, 0 to 0" assert substr of banana from 0 to 0 is empty;
	  for "banana, 0 to 0" assert "[substr of banana from 0 to 0]" reports error;
	
	first-chars is a unit test. "First n characters".
	
	For testing first-chars:
	  for "xyzzy, 0" assert first 0 chars of xyzzy is empty;
	  for "xyzzy, 1" assert first 1 char of xyzzy exactly matches "x";
	  for "xyzzy, 6" assert first 6 chars of xyzzy is empty;
	  for "xyzzy, 6 error" assert "[first 6 chars of xyzzy]" reports error;
	
	last-chars is a unit test. "Last n characters".
	
	For testing last-chars:
	  for "xyzzy, 0" assert last 0 chars of xyzzy is empty;
	  for "xyzzy, 1" assert last 1 char of xyzzy exactly matches "y";
	  for "xyzzy, 6" assert last 6 chars of xyzzy is empty;
	  for "xyzzy, 6 error" assert "[last 6 chars of xyzzy]" reports error;
	
	say-replaced is a unit test. "<t> with chars <m> to <n> replaced with <r>".
	
	For testing say-replaced:
	  for "banana with chars 1 to 2 replaced with xyzzy" assert "[banana with chars 1 to 2 replaced with xyzzy]" exactly matches "xyzzynana";
	  for "banana with chars 2 to 3 replaced with xyzzy" assert "[banana with chars 2 to 3 replaced with xyzzy]" exactly matches "bxyzzyana";
	
	say-cut is a unit test. "<t> with chars <m> to <n> cut".
	
	For testing say-cut:
	  for "banana with chars 2 to 3 cut" assert "[banana with chars 2 to 3 cut]" exactly matches "bana".
	
	first-replaced-with is a unit test. "<t> with first <u> replaced with <v>".
	
	For testing first-replaced-with:
	  for "banana with first 'n' replaced with 'x'" assert banana with first "n" replaced with "x" exactly matches "baxana";
	
	split is a unit test. "<text> split on/by/with <text>".
	
	For testing split:
	  for "abc / d" assert "abc" split on "d" is { "abc" };
	  for "abc / b" assert "abc" split on "b" is { "a", "c" };
