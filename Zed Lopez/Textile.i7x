Version 1 of Textile by Zed Lopez begins here.

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

To decide what number is the left/-- index of/-- a/an/-- regexp (T - a text) in (U - a text):
  if T is empty, decide on 0;
  if U rmatches "((.*?)([T]))", decide on 1 + length of match 2;
  decide on 0.

[ the same regexp as above would work here, but this one is probably quicker ]
To decide what number is the left/-- index of/-- a/an/-- (T - a text) in (U - a text):
  if T is empty, decide on 0;
  if U rmatches "(([T]).*)", decide on 1 + length of U - size of match 1;
  decide on 0.

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
  if U exactly matches "" or V exactly matches "", decide on T;
  let idx be index of U in T;
  if idx is 0, decide on T;
  decide on expanded "[T with chars idx to idx + (length U - 1) replaced with V]";

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

Textile ends here.

---- Documentation ----

