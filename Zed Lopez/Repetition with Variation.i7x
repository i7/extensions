Version 2/210922 of Repetition with Variation by Zed Lopez begins here.

"Repeat variants to: loop through characters, words, lines, or paragraphs
in a text;  loop counting down over a numeric range; loop through a list
of values; loop through all of a kind of enumerated value by name without
specifying a range; infinitely loop. Allows more flexible syntax for existing
loops. For most loop types, offers access to the loop index. For 6M62."

Include 6M62 Patches by Friends of I7. [ need TEXT_TY_BlobAccess fix ]

Book Infinite Loop

[ it's your responsibility to break out! ]
To repeat forever begin -- end loop:
    (- while(1) -)

Book Descending

To repeat with/for (loopvar - nonexisting K variable) from/in (v - arithmetic value of kind K) down to (w - K) begin -- end loop:
      (- for ({loopvar}={v}: {loopvar}>={w}: {loopvar}-- ) -).

Book Overwriting Standard Rules 

Section Clobber Standard Repeat Rules (in place of Section SR5/3/3 - Control phrases - Repeat in Standard Rules by Graham Nelson)

Use ineffectual.

Part Alternate Repetitions

Chapter Specified numeric range

To repeat with/for (loopvar - nonexisting K variable)
	running/-- from/in (v - arithmetic value of kind K) to (w - K) begin -- end loop
	(documented at ph_repeat):
		(- for ({loopvar}={v}: {loopvar}<={w}: {loopvar}++ )  -).

Chapter Specified enumerated value range

To repeat with/for (loopvar - nonexisting K variable)
	running/-- from/in (v - enumerated value of kind K) to (w - K) begin -- end loop
	(documented at ph_repeat):
		(- for ({loopvar}={v}: {loopvar}<={w}: {loopvar}++ )  -).

Section Specified enumerated value range with index

To repeat with/for (loopvar - nonexisting K variable)
	running/-- from/in (v - enumerated value of kind K) to (w - K) with/using index (loopvar2 - nonexisting number variable) begin -- end loop
	(documented at ph_repeat):
		(- for ({loopvar}={v}, {loopvar2}={v}: {loopvar}<={w}: {loopvar}++, {loopvar2}={loopvar})  -).

Chapter Description of objects

[ {-primitive-definition:repeat-through} ]
To repeat with/for (loopvar - nonexisting K variable)
	running/-- through/in (OS - description of values of kind K) begin -- end loop
	(documented at ph_runthrough):
		(-
 {-my:1} = 0; objectloop({loopvar} ofclass Object)
if ({-matches-description:loopvar:OS} && ++{-my:1}) -).

Section Description of objects with index

To repeat with/for (loopvar - nonexisting K variable)
running/-- through/in (OS - description of values of kind K) with index (loopvar2 - nonexisting number variable) begin -- end loop
	(documented at ph_runthrough):
(- {loopvar2} = 0; objectloop({loopvar} ofclass Object)
if ({-matches-description:loopvar:OS} && ++{loopvar2}) -).

Chapter List of values

To repeat with/for (loopvar - nonexisting K variable)
	running/-- through/in (L - list of values of kind K) begin -- end loop
	(documented at ph_repeatlist):
		(- print "listcode^"; {-primitive-definition:repeat-through-list} -).

Section list of values with index

To repeat with/for (loopvar - nonexisting K variable)
	running/-- through/in (L - list of values of kind K) with/using index (loopvar2 - nonexisting number variable) begin -- end loop
	(documented at ph_repeatlist):
        (- {-my:1} = LIST_OF_TY_GetLength({L});
                for ({loopvar2} = 1 : {loopvar2} <= {-my:1} : {loopvar2}++ )
                if ({loopvar} = LIST_OF_TY_GetItem({L}, {loopvar2}))
-).


Chapter Table

Section forward

To repeat running/-- through/in (T - table name) begin -- end loop
	(documented at ph_repeattable): (-
		@push {-my:ct_0}; @push {-my:ct_1};
		for ({-my:1}={T}, {-my:2}=1, ct_0={-my:1}, ct_1={-my:2}:
			{-my:2}<=TableRows({-my:1}):
			{-my:2}++, ct_0={-my:1}, ct_1={-my:2})
			if (TableRowIsBlank(ct_0, ct_1)==false)
				{-block}
		@pull {-my:ct_1}; @pull {-my:ct_0};
	-).

Section forward with index

To repeat running/-- through/in (T - table name) with/using index (index - nonexisting number variable) begin -- end loop
	(documented at ph_repeattable): (-
		@push {-my:ct_0}; @push {-my:ct_1};
		for ({-my:1}={T}, {-my:2}=1, ct_0={-my:1}, ct_1={-my:2}, {index} = ct_1:
			{-my:2}<=TableRows({-my:1}):
			{-my:2}++, ct_0={-my:1}, ct_1={-my:2}, {index} = ct_1)
			if (TableRowIsBlank(ct_0, ct_1)==false)
				{-block}
		@pull {-my:ct_1}; @pull {-my:ct_0};
	-).

Section reverse

To repeat running/-- through/in (T - table name) in/-- reverse/backwards order/-- begin -- end loop
	(documented at ph_repeattablereverse): (-
		@push {-my:ct_0}; @push {-my:ct_1};
		for ({-my:1}={T}, {-my:2}=TableRows({-my:1}), ct_0={-my:1}, ct_1={-my:2}:
			{-my:2}>=1:
			{-my:2}--, ct_0={-my:1}, ct_1={-my:2})
			if (TableRowIsBlank(ct_0, ct_1)==false)
				{-block}
		@pull {-my:ct_1}; @pull {-my:ct_0};
	-).

Section reverse with index

To repeat running/-- through/in (T - table name) in/-- reverse/backwards order/-- with/using index (index - nonexisting number variable) begin -- end loop
	(documented at ph_repeattablereverse): (-
		@push {-my:ct_0}; @push {-my:ct_1};
		for ({-my:1}={T}, {-my:2}=TableRows({-my:1}), ct_0={-my:1}, ct_1={-my:2}, {index}=ct_1:
			{-my:2}>=1:
			{-my:2}--, ct_0={-my:1}, ct_1={-my:2}, {index}=ct_1)
			if (TableRowIsBlank(ct_0, ct_1)==false)
				{-block}
		@pull {-my:ct_1}; @pull {-my:ct_0};
	-).

Section forward sorted by column

To repeat running/-- through/in (T - table name) in/by (TC - table column) order/-- begin -- end loop
	(documented at ph_repeattablecol): (-
		@push {-my:ct_0}; @push {-my:ct_1};
		for ({-my:1}={T}, {-my:2}=TableNextRow({-my:1}, {TC}, 0, 1), ct_0={-my:1}, ct_1={-my:2}:
			{-my:2}~=0:
			{-my:2}=TableNextRow({-my:1}, {TC}, {-my:2}, 1), ct_0={-my:1}, ct_1={-my:2})
				{-block}
		@pull {-my:ct_1}; @pull {-my:ct_0};
	-).

Section forward sorted by column with index

To repeat running/-- through/in (T - table name) in/by (TC - table column) order/-- with/using index (index - nonexisting number variable) begin -- end loop
	(documented at ph_repeattablecol): (-
		@push {-my:ct_0}; @push {-my:ct_1};
		for ({-my:1}={T}, {-my:2}=TableNextRow({-my:1}, {TC}, 0, 1), ct_0={-my:1}, ct_1={-my:2}, {index}=ct_1:
			{-my:2}~=0:
			{-my:2}=TableNextRow({-my:1}, {TC}, {-my:2}, 1), ct_0={-my:1}, ct_1={-my:2},{index}=ct_1)
				{-block}
		@pull {-my:ct_1}; @pull {-my:ct_0};
	-).

Section reverse sorted by column

To repeat running/-- through/in (T - table name) in/by reverse/backwards (TC - table column) order/-- begin -- end loop
	(documented at ph_repeattablecolreverse): (-
		@push {-my:ct_0}; @push {-my:ct_1};
		for ({-my:1}={T}, {-my:2}=TableNextRow({-my:1}, {TC}, 0, -1), ct_0={-my:1}, ct_1={-my:2}:
			{-my:2}~=0:
			{-my:2}=TableNextRow({-my:1}, {TC}, {-my:2}, -1), ct_0={-my:1}, ct_1={-my:2})
				{-block}
		@pull {-my:ct_1}; @pull {-my:ct_0};
	-).

Section reverse sorted by column with index

To repeat running/-- through/in (T - table name) in/by reverse/backwards (TC - table column) order/-- with/using index (index - nonexisting number variable) begin -- end loop
	(documented at ph_repeattablecolreverse): (-
		@push {-my:ct_0}; @push {-my:ct_1};
		for ({-my:1}={T}, {-my:2}=TableNextRow({-my:1}, {TC}, 0, -1), ct_0={-my:1}, ct_1={-my:2}, {index}=ct_1:
			{-my:2}~=0:
			{-my:2}=TableNextRow({-my:1}, {TC}, {-my:2}, -1), ct_0={-my:1}, ct_1={-my:2}, {index}=ct_1)
				{-block}
		@pull {-my:ct_1}; @pull {-my:ct_0};
	-).

Book Through enumerated values

Chapter Enumerated Values

To repeat with/for (loopvar - nonexisting K variable) running/-- through/in values of (V - name of kind of enumerated value K): 
    (- {-my:1} = {-new:K}; {-my:2} = B_{-printing-routine:K}({-my:1});
    for ({loopvar} = {-my:1} : {loopvar} <= {-my:2} : {loopvar}++)
    -)

Section Enumerated values with index

To repeat with/for (loopvar - nonexisting K variable) running/-- through/in values of (V - name of kind of enumerated value K) with/using index (index - nonexisting number variable) begin -- end loop:
    (- {-my:1} = {-new:K}; {-my:2} = B_{-printing-routine:K}({-my:1});
    for ({loopvar} = {-my:1}, {index}={loopvar} : {loopvar} <= {-my:2} : {loopvar}++, {index}={loopvar})
    -)
    
Book Text manipulation

Part Characters

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in chars/characters in/of (T - text) with/using index (index - nonexisting number variable) begin -- end loop:
    (- {-my:1} = TEXT_TY_BlobAccess({-by-reference:T}, CHR_BLOB);
    for ( {index} = 1 : {index} <= {-my:1} : {index}++ )
         if (BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob({-new:text}, {-by-reference:T}, {index}, CHR_BLOB)))
-)    

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in chars/characters in/of (T - text) begin -- end loop:
    (- {-my:1} = TEXT_TY_BlobAccess({-by-reference:T}, CHR_BLOB);
for ( {-my:2} = 1  : {-my:2} <= {-my:1} : {-my:2}++, BlkValueCopy({-by-reference:loopvar}))
  if (BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob({-new:text}, {-by-reference:T}, {-my:2}, CHR_BLOB)))
-)

Part Words

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in words in/of (T - text) with/using index (index - nonexisting number variable) begin -- end loop:
    (- {-my:1} = TEXT_TY_BlobAccess({-by-reference:T}, WORD_BLOB);
for ( {index} = 1  : {index} <= {-my:1} : {index}++, BlkValueCopy({-by-reference:loopvar}))
if (BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob({-new:text}, {-by-reference:T}, {index}, WORD_BLOB)))
-)

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in words in/of (T - text) begin -- end loop:
    (- {-my:1} = TEXT_TY_BlobAccess({-by-reference:T}, WORD_BLOB);
for ( {-my:2} = 1 : {-my:2} <= {-my:1} : {-my:2}++ )
if (BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob({-new:text}, {-by-reference:T}, {-my:2}, WORD_BLOB)))
-)

Part Pwords

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in pwords in/of (T - text) with/using index (index - nonexisting number variable) begin -- end loop:
    (- {-my:1} = TEXT_TY_BlobAccess({-by-reference:T}, PWORD_BLOB);
for ( {index} = 1 : {index} <= {-my:1} : {index}++ )
if (BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob({-new:text}, {-by-reference:T}, {index}, PWORD_BLOB)))
-)

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in pwords in/of (T - text) begin -- end loop:
    (- {-my:1} = TEXT_TY_BlobAccess({-by-reference:T}, PWORD_BLOB);
for ( {-my:2} = 1 : {-my:2} <= {-my:1} : {-my:2}++ )
if (BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob({-new:text}, {-by-reference:T}, {-my:2}, PWORD_BLOB)))
-)

Part Uwords

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in uwords in/of (T - text) with/using index (index - nonexisting number variable) begin -- end loop:
    (- {-my:1} = TEXT_TY_BlobAccess({-by-reference:T}, UWORD_BLOB);
for ( {index} = 1  : {index} <= {-my:1} : {index}++ )
if (BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob({-new:text}, {-by-reference:T}, {index}, UWORD_BLOB)))
-)

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in uwords in/of (T - text) begin -- end loop:
    (- {-my:1} = TEXT_TY_BlobAccess({-by-reference:T}, UWORD_BLOB);
for ( {-my:2} = 1 : {-my:2} <= {-my:1} : {-my:2}++ )
if (BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob({-new:text}, {-by-reference:T}, {-my:2}, UWORD_BLOB)))
-)

Part Lines

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in lines in/of (T - text) with/using index (index - nonexisting number variable) begin -- end loop:
    (-
{-my:1} = TEXT_TY_BlobAccess({-by-reference:T}, LINE_BLOB);
for ( {index} = 1 : {index} <= {-my:1} : {index}++ )
if (BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob({-new:text}, {-by-reference:T}, {index}, LINE_BLOB)))
-)

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in lines in/of (T - text) begin -- end loop:
    (-
{-my:1} = TEXT_TY_BlobAccess({-by-reference:T}, LINE_BLOB); 
for ( {-my:2} = 1 : {-my:2} <= {-my:1} : {-my:2}++ )
if (BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob({-new:text}, {-by-reference:T}, {-my:2}, LINE_BLOB)))
-)

Part Paragraphs

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in paragraphs in/of (T - text) with/using index (index - nonexisting number variable) begin -- end loop:
    (- {-my:1} = TEXT_TY_BlobAccess({-by-reference:T}, PARA_BLOB);
for ( {index} = 1  : {index} <= {-my:1} : {index}++ )
if (BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob({-new:text}, {-by-reference:T}, {index}, PARA_BLOB)))
-)

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in paragraphs in/of (T - text) begin -- end loop:
    (- {-my:1} = TEXT_TY_BlobAccess({-by-reference:T}, PARA_BLOB);
for ( {-my:2} = 1 : {-my:2} <= {-my:1} : {-my:2}++ )
if (BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob({-new:text}, {-by-reference:T}, {-my:2}, PARA_BLOB)))
-)

Repetition with Variation ends here.

---- Documentation ----

This is experimental and mostly made out of the undocumented features in the Standard Rules the docs call on us not to use.

Infinitely loop (your obligation to break out):

```
repeat forever:
```

Repeat down across a numeric range:

```
repeat with x running from 12 down to 2:
```

For all of the loops except numeric ranges, you can also provide a loop index variable. Enumerated values in a specified range:

```
repeat with the-color running from red to blue with index i:
```

Descriptions of objects:

```
repeat with closed-thing running through closed things with index i:
```

Lists:

```
repeat with item running through L with index i:
```

Tables (the index is the actual row number, no matter whether you're sorting by a column or in reverse):

```
repeat through Table of Regrets with index i:
```

A named kind of enumerated value. The compiler does magic I can't reproduce to let the same phrase preamble work for descriptions of objects and descriptions of enumerated values, so we have to add 'values of' here:

```
repeat through values of colors with index i:
```

You can also loop through text in different ways. uword = unpunctuated word; pword = punctuated word.

```
repeat with ch running through characters in T:
repeat with w running through words in T:
repeat with uw running through uwords in T:
repeat with pw running through pwords in T:
repeat with line running through lines in T:
repeat with p running through paragraphs in T:
```

All of the above can also have an index specified:

```
repeat with ch running through characters in T with index i;
```

Also modifies existing syntax:

Redefines existing "repeat" statements such that:

"repeat running through" and "repeat through" are interchangeable (i.e., "running" is permissible while looping through tables, and omitting it is permissible everywhere)

"for" may replace "with"

"in" may replace "from"

"in" may replace "through"

So all of the following are equivalent:

Repeat with i running from 1 to 10
Repeat with i from 1 to 10
Repeat for i in 1 to 10

And these are equivalent:

Repeat running through the Table of Regrets:
Repeat through the Table of Regrets:
Repeat in the Table of Regrets:

other examples:

repeat through the table of regrets backwards by decision-badness using index row_no

Repeat for char  in chars of str with index i

Repeat with p running through the paragraphs in T

Extensively uses undocumented features and is likely to break at next release.

Section Changelog

2/210922: put the now working text phrases back, added with index variants for the others
1/210918: removed some looping through text phrases that weren't working
