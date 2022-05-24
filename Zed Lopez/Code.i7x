Version 1 of Code by Zed Lopez begins here.

Include Custom Banner and Version by Zed Lopez.
Include If True by Zed Lopez.
Include Switch by Zed Lopez.
Include Strange Loopiness by Zed Lopez.
Include Text Loops by Zed Lopez.
Include Bit Ops by Zed Lopez.
Include List Utilities by Zed Lopez.
Include Char by Zed Lopez.
Include Textile by Zed Lopez.
Include Alternative Startup Rules by Dannii Willis.
Include Data Structures by Dannii Willis.

[Dependence on Data Structures means depending also on having the corresponding
Figures.i6t and Load-Figures.i6t under project.materials/I6T ]

Use American dialect.
Use serial comma.

The initial room description rule does nothing.
The initial whitespace rule does nothing.
To say custom banner prefix: do nothing.
For printing the banner text: say I7 credit.

Part var creation

To (name of kind of value of kind K) var (v - nonexisting K variable) = (u - a K):
(-  if (KOVIsBlockValue({-strong-kind:K})) {
    BlkValueCopy({-by-reference:v},{u});
  }
  else {
    {-by-reference:v} = {u};
  }
-)

To var (v - nonexisting K variable) = (u - a value of kind K):
(-  if (KOVIsBlockValue({-strong-kind:K})) {
    BlkValueCopy({-by-reference:v},{u});
  }
  else {
    {-by-reference:v} = {u};
  }
-)

To (name of kind of value of kind K) var (v - nonexisting K variable): (- ! -).

To (name of kind of value of kind K) var (v - nonexisting K variable) = (u - a K):
(-  if (KOVIsBlockValue({-strong-kind:K})) {
    BlkValueCopy({-by-reference:v},{u});
  }
  else {
    {-by-reference:v} = {u};
  }
-)

To decide what number is sqrt of/-- (n - a number): decide on the square root of n;

To return (something - value):
(- return {-return-value:something}; -).


To decide what K is (L - a list of values of kind K) => (n - a number): decide on entry n in L;


Part Main rules

Main is a nothing based rulebook.
This is the main staging rule: follow the main rules.
The main staging rule is listed last in the startup rulebook.

Part Bit Ops (for use with Bit Ops by Zed Lopez)

To decide what number is ~ (n1 - a number):
  (- bitnot({n1}) -).

To decide what number is (n1 - a number) ^ (n2 - a number):
  (- bitxor({n1},{n2}) -).

To  (n1 - a number) ^= (n2 - a number):
  (- @bitxor {n1} {n2} {n1}; -)

To  (n1 - a number) |= (n2 - a number):
  (- @bitor {n1} {n2} {n1}; -)

To decide what number is (n1 - a number) & (n2 - a number):
  (- bitand({n1},{n2}) -).

To decide what number is (n1 - a number) | (n2 - a number):
  (- bitor({n1},{n2}) -).

To  (n1 - a number) &= (n2 - a number):
  (- @bitand {n1} {n2} {n1}; -)

To decide what number is (n1 - a number) << (n2 - a number):
  (- shiftl({n1},{n2}) -).

To (n1 - a number) <<= (n2 - a number):
  (- @shiftl n1 n2 n1; -)

To decide what number is (n1 - a number) >> (n2 - a number):
  (- ushiftr({n1},{n2}) -).

To (n1 - a number) >>= (n2 - a number):
  (- @ushiftr n1 n2 n1; -).

Part file operations


Part properties

To decide what K is (O - an object) ~> (P - a value of kind K valued property): (- {O}.{P} -)

To assign non-block value in property (P - a number) of (O - an object) to (PP - a property) of (OO - an object): (- {OO}.{PP}={O}.{P}; -).

To decide what list of numbers is list property (P - a (list of numbers) valued property) of (O - an object):
  (- GProperty(OBJECT_TY,{O},{P})  -)
  
To say property (P - a property):
  (- PrintPropertyName({P}); -)

To say property (N - a number):
  (- PrintPropertyName({N}); -)

Part running and gettings results from rules and activities

To decide what K is a/-- result of/-- a/an/-- (r - a nothing based rulebook producing values of kind K):
  decide on the K produced by r.

To decide what K is a/-- result of/-- a/an/-- (r - an M based rulebook producing values of kind K) on/of/for/with a/an/-- (v - a value of kind M):
  decide on the K produced by r for v.

To run a/an/-- (r - an nothing based rulebook producing a value of kind K):
  let x be the result of r.

To run a/an/-- (r - a nothing based rulebook): follow r.

To run a/an/-- (r - an M based rulebook) on/of/for/with a/an/-- (v - a value of kind M):
  follow r for v.

To run a/an/-- (r - an M based rulebook producing a value of kind K) on/of/for/with a/an/-- (v - a value of kind M):
  follow r for v.

To run a/an/-- (act - an activity on nothing) activity/--: carry out the act activity.

To run a/an/-- (act - an activity on a K) activity/-- on/of/for/with a/an/-- (v - value of kind K):
  carry out the act activity with v.

Part math

To decide what number is (N - a number) % (M - a number): (- ({N} % {M}) -)

To decide what number is wrapped abs of/-- (N - a number) (this is absoluting): decide on abs of N.

To decide what number is the abs/absolute value/-- of/-- a/an/-- (n - a number):
(- NUMBER_TY_Abs({n}) -)

Part output

To puts (sv - a sayable value): say "[sv][line break]".
To puts (T - a text): say T; say line break.
To puts: say line break.
To print (sv - a sayable value): say "[sv]".
To print (T - a text): say T.

Part files

To (f - an external file) puts (sv - a sayable value): append "[sv][line break]" to f;
To (f - an external file) print (sv - a sayable value): append "[sv]" to f;
To (f - an external file) puts (T - a text): append T to f; append "[line break]" to f;
To (f - an external file) print (T - a text): append T to f;

To decide what text is read (f - an external file): decide on expanded "[text of f]";

[ both creator and destroyer, empty will create an empty file if there hadn't been one or erase the contents of a file if it was
  already there. Either way the outcome should be that the file exists and is empty. ]

To empty the/a/-- file (F - an external file):
  write "" to F.
A filemode value is a kind of value. The filemode values are <f, >f, >>f.
An external file has a filemode value called the filemode.

To decide if (F - an external file) does not exist: if F exists, no; yes.

To decide if (F - an external file) is readable: decide on whether or not ready to read F.

To decide if (F - an external file) is not readable: if ready to read F, no; yes.

To open a/an/-- (f - an external file) for/with/as (fm - a filemode value):
  unless fm is <f begin;
    if f does not exist or fm is >f, empty file f;
    mark f as not ready to read;
  end if;

To close (f - an external file):
  mark f as ready to read;

Part map

To decide what list of Ks is grep (ph - a phrase K -> truth state)  of/on/to (L - a list of values of kind K):
  let result be a list of Ks;
  repeat for v in L begin;
    if ph applied to v, add v to result;
  end repeat;
  decide on result;

Part Assignment 

Chapter Incr/Decr

To decide if (n - a number) ++ : (- ({n}++) -).
To decide if ++ (n - a number) : (- (++{n}) -).
To decide if (n - a number) -- : (- ({n}-- ) -).
To decide if -- (n - a number) : (- (--{n}) -).

Chapter Assignment Operators

To (n - a number) += (m - a number): (- {n} = {n} + {m}; -).
To (n - a number) -= (m - a number): (- {n} = {n} - {m}; -).
To (n - a number) *= (m - a number): (- {n} = {n} * {m}; -).
To (n - a number) /= (m - a number): (- {n} = {n} / {m}; -).

To decide what number is (m - a number) ** (n - a number):
  if n < 0, decide on -1; [ -1 is designated error result ]
  if n is zero, decide on 1; [ we're allowing 0 ** 0 == 1 ]
  let result be m;
  repeat with i running from 2 to n begin;
    now result is result * m;
  end repeat;
  decide on result;

To decide what text is (T - a text) * (N - a number):
  decide on "[N copies of T]";

To (L - a list of values of kind K) += (n - a K):
  (- LIST_OF_TY_InsertItem({-lvalue-by-reference:L}, {n}, 0, 0, {phrase options}); -)

To (L - a list of values of kind K) << (n - a K):
  (- LIST_OF_TY_InsertItem({-lvalue-by-reference:L}, {n}, 0, 0, {phrase options}); -)

To (T - a text) += (U - a text):
  (- {-by-reference:T} = textConcat({T},{U},{-new:text}); -).

Chapter Assignment by =

To (v1 - a value of kind K) = (v2 - a K): (-
  if (KOVIsBlockValue({-strong-kind:K})) {
    BlkValueCopy({-by-reference:v1},{v2});
  }
  else {
    {-by-reference:v1} = {v2};
  }
-).

Part ternary

Include (-
[ ternary a b c;
  if (a) return b;
  return c;
];
-).

[ can't do ternary without a function call: in I6, && and || only return 0 or 1, not the parameter ]
To decide what K is (C - a condition) ? (v1 - value of kind K) # (v2 - K): (- ternary(({C}), {v1}, {v2}) -).

Part spaceship operator

Include (-
[ codeSignedCompare x y;
if (x > y) return 1;
if (x < y) return -1;
return 0;
];

[ spaceship v1 v2 k cmp cmp_result;
  if (k == NUMBER_TY) cmp = codeSignedCompare;
  else cmp = KOVComparisonFunction(k);
  cmp_result = cmp(v1,v2);
  if (cmp_result > 0) return 1;
  if (cmp_result < 0) return -1;
  return 0;
];
-)

To decide what number is (v1 - a value of kind K) <=> (v2 - a K):
    (- spaceship({v1},{v2},{-strong-kind:K}) -)

To decide if (v1 - a value of kind K) == (v2 - a K):
  decide on whether or not v1 <=> v2 is 0;

To decide if (v1 - a value of kind K) <>/!= (v2 - a K):
  decide on whether or not v1 <=> v2 is not 0;

Book Truthiness

To decide what number is eval (C - a condition):
  (- ({C}) -)

Part numbers

To decide if (n - a number) begin -- end conditional: (- if ({n}) -).

Chapter while number

To while (n - a number) begin -- end loop:
  (- while({n}) -).

To while (n - a number) with/using index (index - nonexisting number variable) begin -- end loop:
  (- while({n}) && ++{index}) -).

Chapter until number 

To repeat until (n - a number) begin -- end loop:
(-
  do
    {-block}
  until ({n});
-)

Section until number with index

To repeat until (n - a number) with/using index (index - nonexisting number variable) begin -- end loop:
(-
  {index} = 0;
  do if (++{index})
    {-block}  
  until ({n});
-)

Part texts

To decide if (t - a text) begin -- end conditional: (- (~~(TEXT_TY_Empty({t}))) -)

To decide unless (t - a text) begin -- end conditional: (- TEXT_TY_Empty({t}) -)

Chapter while text

To while (t - a text) begin -- end loop:
  (- while (~~(TEXT_TY_Empty({t})) -)

To while (t - a text) with/using index (index - nonexisting number variable) begin -- end loop:
  (- while ((~~(TEXT_TY_Empty({t}))) && ++{index}) -).

Chapter until text

To repeat until (t - a text) begin -- end loop:
(-
  do
    {-block}
  until (~~(TEXT_TY_Empty({t})));
-)

Section until text with index

To repeat until (t - a text) with/using index (index - nonexisting number variable) begin -- end loop:
(-
  {index} = 0;
  do if (++{index})
    {-block}  
  until (~~(TEXT_TY_Empty({t})));
-)

Book regexps

To (T - a text) =~ / (regexp - a text) / , case insensitively:
  (-  TEXT_TY_Replace_RE(REGEXP_BLOB,{-by-reference:T},{-by-reference:regexp},0,{phrase options}); -)

To decide if (T - a text) =~ m/ (regexp - a text) / , case insensitively:
  (- TEXT_TY_Replace_RE(REGEXP_BLOB,{-by-reference:T},{-by-reference:regexp},0,{phrase options}) -).

To decide if (T - a text) =~ m/ (regexp - a text) /i:
  (- TEXT_TY_Replace_RE(REGEXP_BLOB,{-by-reference:T},{-by-reference:regexp},0,1) -).


To while (T - a text) =~ / (R - a text) /g begin -- end loop:
(-  {-my:1} = BlkValueCreate(TEXT_TY);
BlkValueCopy({-my:1},{-by-reference:T});
  while (TEXT_TY_Replace_RE(REGEXP_BLOB,{-my:1},{-by-reference:R},0)) {
  {-my:2} = 1+RE_Subexpressions-->0-->RE_DATA1;
  {-my:3} = RE_Subexpressions-->0-->RE_DATA2; ! - RE_Subexpressions-->0-->RE_DATA1;
    if (1) {-block}
TEXT_TY_ReplaceChars({-my:1}, {-my:2}, {-my:3}, (+ empty-string +));
}
BlkValueFree({-my:1});
-)

To while (T - a text) =~ / (R - a text) /gi begin -- end loop:
(-  {-my:1} = BlkValueCreate(TEXT_TY);
BlkValueCopy({-my:1},{-by-reference:T});
  while (TEXT_TY_Replace_RE(REGEXP_BLOB,{-my:1},{-by-reference:R},0,1)) {
    if (1) {-block}
TEXT_TY_ReplaceChars({-my:1}, (1+RE_Subexpressions-->0-->RE_DATA1), (RE_Subexpressions-->0-->RE_DATA2 - RE_Subexpressions-->0-->RE_DATA1), (+ empty-string +));
}
BlkValueFree({-my:1});
-)

To while (T - a text) =~ / (R - a text) /ig begin -- end loop:
(-  {-my:1} = BlkValueCreate(TEXT_TY);
BlkValueCopy({-my:1},{-by-reference:T});
  while (TEXT_TY_Replace_RE(REGEXP_BLOB,{-my:1},{-by-reference:R},0,1)) {
    if (1) {-block}
TEXT_TY_ReplaceChars({-my:1}, (1+RE_Subexpressions-->0-->RE_DATA1), (RE_Subexpressions-->0-->RE_DATA2 - RE_Subexpressions-->0-->RE_DATA1), (+ empty-string +));
}
BlkValueFree({-my:1});
-)

To (T - a text) =~ s/ (regexp - a text) / (sub - a text) /:
  (- if ((~~TEXT_TY_Empty({-by-reference:T})) && (~~TEXT_TY_Empty({-by-reference:regexp})) && TEXT_TY_Replace_RE(REGEXP_BLOB,{-by-reference:T},{-by-reference:regexp},0)) {
  TEXT_TY_ReplaceChars({-by-reference:T}, (RE_Subexpressions-->0-->RE_DATA1 + 1), RE_Subexpressions-->0-->RE_DATA2, {-by-reference:sub}); 
  }
  -)

To (T - a text) =~ s/ (regexp - a text) / (sub - a text) /i:
  (- {-by-reference:T} = replaceFirstRegexp({-by-reference:T},{-by-reference:regexp},{sub}), 1, 0; -).

To (T - a text) =~ s/ (regexp - a text) / (sub - a text) /g:
(- TEXT_TY_Replace_RE(REGEXP_BLOB, {-lvalue-by-reference:T}, {-by-reference:regexp}, {-by-reference:sub}); -).

To (T - a text) =~ s/ (regexp - a text) / (sub - a text) /gi:
(- TEXT_TY_Replace_RE(REGEXP_BLOB, {-lvalue-by-reference:T}, {-by-reference:regexp}, {-by-reference:sub}, 1); -).


To decide what text is $0: (- TEXT_TY_RE_GetMatchVar(0) -).
To decide what text is $1: (- TEXT_TY_RE_GetMatchVar(1) -).
To decide what text is $2: (- TEXT_TY_RE_GetMatchVar(2) -).
To decide what text is $3: (- TEXT_TY_RE_GetMatchVar(3) -).
To decide what text is $4: (- TEXT_TY_RE_GetMatchVar(4) -).
To decide what text is $5: (- TEXT_TY_RE_GetMatchVar(5) -).
To decide what text is $6: (- TEXT_TY_RE_GetMatchVar(6) -).
To decide what text is $7: (- TEXT_TY_RE_GetMatchVar(7) -).
To decide what text is $8: (- TEXT_TY_RE_GetMatchVar(8) -).
To decide what text is $9: (- TEXT_TY_RE_GetMatchVar(9) -).

The shrine to Perl 5 is a room.
The camel is an animal in the shrine.
The llama is an animal in the shrine.
  
Volume Interactions

Book DS (for use with Data Structures by Dannii Willis)

To decide which map of value of kind K to value of kind L is a/-- map (name of kind of value K) => (name of kind of value L):
(- {-new:map of K to L} -);

To decide if (M - map of value of kind K to value of kind L) => (key - K) exists:
(- MAP_TY_Has_Key({-by-reference:M}, {-by-reference:key}) -).

[what's usually the unchecked version. because of course we're taking the safety off.]
To decide what L is (M - map of value of kind K to value of kind L) => (key - K):
(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, 0, 0, 0, {-new:L}) -).

To decide what list of K is keys of/-- (M - map of value of kind K to value of kind L): (- BlkValueRead({M}, MAP_TY_KEYS) -).

To (M - map of value of kind K to value of kind L) => (key - K) ||= (val - an L):
  (- if (~~(MAP_TY_Has_Key({-by-reference:M}, {-by-reference:key}))) MAP_TY_Set_Key({-by-reference:M}, {-strong-kind:map of K to L}, {-by-reference:key}, 0, 0, {-by-reference:val}); -).

Chapter Strange Loopimaps (in place of "Chapter - Maps - Iterating" in "Data Structures by Dannii Willis")

To repeat with/for (key - nonexisting K variable) in/from/of (M - map of value of kind K to value of kind L) keys begin -- end loop:
	(-
		{-my:3} = BlkValueRead({-by-reference:M}, MAP_TY_KEYS);
		{-my:2} = BlkValueRead({-my:3}, LIST_LENGTH_F);
		{-lvalue-by-reference:key} = BlkValueRead({-my:3}, LIST_ITEM_BASE);
		for ({-my:1} = 0: {-my:1} < {-my:2}: {-my:1}++, {-lvalue-by-reference:key} = BlkValueRead({-my:3}, LIST_ITEM_BASE + {-my:1}))
	-).

To repeat with/for (val - nonexisting L variable) in/from/of (M - map of value of kind K to value of kind L) values begin -- end loop:
	(-
		{-my:3} = BlkValueRead({-by-reference:M}, MAP_TY_VALUES);
		{-my:2} = BlkValueRead({-my:3}, LIST_LENGTH_F);
		{-lvalue-by-reference:val} = BlkValueRead({-my:3}, LIST_ITEM_BASE);
		for ({-my:1} = 0: {-my:1} < {-my:2}: {-my:1}++, {-lvalue-by-reference:val} = BlkValueRead({-my:3}, LIST_ITEM_BASE + {-my:1}))
	-).

To repeat with/for (key - nonexisting K variable) and/to/=> (val - nonexisting L variable) in/from/of (M - map of value of kind K to value of kind L) begin -- end loop:
	(-
		{-my:4} = BlkValueRead({-by-reference:M}, MAP_TY_VALUES);
		{-my:3} = BlkValueRead({-by-reference:M}, MAP_TY_KEYS);
		{-my:2} = BlkValueRead({-my:3}, LIST_LENGTH_F);
		{-lvalue-by-reference:key} = BlkValueRead({-my:3}, LIST_ITEM_BASE);
		{-lvalue-by-reference:val} = BlkValueRead({-my:4}, LIST_ITEM_BASE);
		for ({-my:1} = 0: {-my:1} < {-my:2}: {-my:1}++, {-lvalue-by-reference:key} = BlkValueRead({-my:3}, LIST_ITEM_BASE + {-my:1}), {-lvalue-by-reference:val} = BlkValueRead({-my:4}, LIST_ITEM_BASE + {-my:1}))
	-).

Code ends here.

---- Documentation ----

You always need whitespace between operators and operands.

Local variable creation

With the kind name and var:

number var x;

Immediate assignment with the kind name and var:

number var x = 5;

But if you're making an assignment, you don't need to specify the kind:

var x = 5;

Well, almost never. With a topic you'd need:

topic var t = "donuts";

because just

var t = "donuts";

would result in t being a text variable.

Assignment with =

let t be a text;
let L be a list of numbers;
let n be 12;

t = "cat";
L = { 2, 4 };
n = 5;

A ternary operator

i = (j > 1) ? j # k;

Comparison with ==, <>, !=

let s be "cat";
if t == s, say "meow";
if L == { 2, 4 }, say "unchanged";

With texts, this is equivalent to if t exactly matches the text s (i.e., *not* if t is s).

You can also test not-equal with your choice of <> or !=. I'm not one to judge.

Attribute accessor

Instead of <property name p> of <object o> you can just use:

o ~> p.

Arithmetic assignment operators:

n += 1; [ n = n + 1 ]
x -= 2;
i /= 3;
j *= 4;

They don't return a value and can't be used in conditionals.

Increment/decrement operators for numbers in conditionals:

if ( n ++ ) [...]
unless ( -- i ) [...]

They don't work outside of conditionals; use += or -= for imperative phrases.

Bit operators 

Not:

l = ~ m;

XOR:

m = n ^ o;

AND:

i = j & k;

OR:

k = l | m;

Shift left:

b = c << 1;

Shift right:

f = g >> 2;

All of the above have assignment variants, too:

b <<= 1;
m |= n;

Truthiness and Falsiness

Truth states, numbers, and texts are conditionals unto themselves. With numbers, 0 is considered false; with texts, the empty string is considered false.

Regexp operators

Matches:

t = "banana";
t ~= / "((na)+)" /;
n = $1; [ "nana" ]

The whole matched text is in $0; the first 9 subexpressions are in $1 to $9.

In a conditional, the opening slash must be preceded by ``m``:

if t ~= m/ "xyzzy" / [...]

And substitutions:

t =~ s/ "na" / "X" /; [ banana => baXna ]
t =~ s/ "na" / "X" /g; [ banana => baXX ]
