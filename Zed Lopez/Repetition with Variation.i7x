Version 1 of Repetition with Variation by Zed Lopez begins here.

"Facilitates looping over words or lines in a text; provides an
infinite loop; provides an indexed loop that counts down; allows
more flexible syntax for existing loops. For 6M62."

Include 6M62 Patches by Friends of I7. [ need TEXT_TY_BlobAccess fix ]

Book Now with Index

[ works while looping through a list or table.
  doesn't work with set descriptions.
  entirely subject to breaking on next release of I7 ]

To decide what number is the loop index: (- tmp_1 -).

Book Text manipulation

Part Characters

To repeat with/for (loopvar - nonexisting text variable) and index (loopvar2 - nonexisting number variable) running/-- through/in chars/characters in (T - text) begin -- end loop:
    (- {-my:rwc_count} = TEXT_TY_BlobAccess({-by-reference:T}, CHR_BLOB);
for ( {loopvar2} = 1, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*2), {-by-reference:T}, {loopvar2}, CHR_BLOB))  : {loopvar2} <= rwc_count : {loopvar2}++, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*2), {-by-reference:T}, {loopvar2}, CHR_BLOB)))
-)

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in chars/characters in (T - text) begin -- end loop:
    (- {-my:rwc_count} = TEXT_TY_BlobAccess({-by-reference:T}, CHR_BLOB);
for ( {-my:word_index} = 1, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*2), {-by-reference:T}, word_index, CHR_BLOB))  : word_index <= rwc_count : word_index++, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*2), {-by-reference:T}, word_index, CHR_BLOB)))
-)

Part Words

To repeat with/for (loopvar - nonexisting text variable) and index (loopvar2 - nonexisting number variable) running/-- through/in words in (T - text) begin -- end loop:
    (- {-my:rwc_count} = TEXT_TY_BlobAccess({-by-reference:T}, WORD_BLOB);
for ( {loopvar2} = 1, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*4), {-by-reference:T}, {loopvar2}, WORD_BLOB))  : {loopvar2} <= rwc_count : {loopvar2}++, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*4), {-by-reference:T}, {loopvar2}, WORD_BLOB)))
-)

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in words in (T - text) begin -- end loop:
    (- {-my:rwc_count} = TEXT_TY_BlobAccess({-by-reference:T}, WORD_BLOB);
for ( {-my:word_index} = 1, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*4), {-by-reference:T}, word_index, WORD_BLOB))  : word_index <= rwc_count : word_index++, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*4), {-by-reference:T}, word_index, WORD_BLOB)))
-)

Part Pwords

To repeat with/for (loopvar - nonexisting text variable) and index (loopvar2 - nonexisting number variable) running/-- through/in pwords in (T - text) begin -- end loop:
    (- {-my:rwc_count} = TEXT_TY_BlobAccess({-by-reference:T}, PWORD_BLOB);
for ( {loopvar2} = 1, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*4), {-by-reference:T}, {loopvar2}, WORD_BLOB))  : {loopvar2} <= rwc_count : {loopvar2}++, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*4), {-by-reference:T}, {loopvar2}, PWORD_BLOB)))
-)

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in pwords in (T - text) begin -- end loop:
    (- {-my:rwc_count} = TEXT_TY_BlobAccess({-by-reference:T}, PWORD_BLOB);
for ( {-my:word_index} = 1, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*4), {-by-reference:T}, word_index, WORD_BLOB))  : word_index <= rwc_count : word_index++, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*4), {-by-reference:T}, word_index, PWORD_BLOB)))
-)

Part Uwords

To repeat with/for (loopvar - nonexisting text variable) and index (loopvar2 - nonexisting number variable) running/-- through/in uwords in (T - text) begin -- end loop:
    (- {-my:rwc_count} = TEXT_TY_BlobAccess({-by-reference:T}, UWORD_BLOB);
for ( {loopvar2} = 1, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*4), {-by-reference:T}, {loopvar2}, WORD_BLOB))  : {loopvar2} <= rwc_count : {loopvar2}++, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*4), {-by-reference:T}, {loopvar2}, UWORD_BLOB)))
-)

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in uwords in (T - text) begin -- end loop:
    (- {-my:rwc_count} = TEXT_TY_BlobAccess({-by-reference:T}, UWORD_BLOB);
for ( {-my:word_index} = 1, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*4), {-by-reference:T}, word_index, WORD_BLOB))  : word_index <= rwc_count : word_index++, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*4), {-by-reference:T}, word_index, UWORD_BLOB)))
-)

Part Lines

To repeat with/for (loopvar - nonexisting text variable) and index (loopvar2 - nonexisting number variable) running/-- through/in lines in (T - text) begin -- end loop:
    (- {-my:rwc_count} = TEXT_TY_BlobAccess({-by-reference:T}, LINE_BLOB);
for ( {loopvar2} = 1, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*8), {-by-reference:T}, {loopvar2}, LINE_BLOB))  : {loopvar2} <= rwc_count : {loopvar2}++, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*8), {-by-reference:T}, {loopvar2}, LINE_BLOB)))
-)

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in lines in (T - text) begin -- end loop:
    (- {-my:rwc_count} = TEXT_TY_BlobAccess({-by-reference:T}, LINE_BLOB);
for ( {-my:line_index} = 1, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*8), {-by-reference:T}, line_index, LINE_BLOB))  : line_index <= rwc_count : line_index++, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*8), {-by-reference:T}, line_index, LINE_BLOB)))
-)

Part Paragraphs

To repeat with/for (loopvar - nonexisting text variable) and index (loopvar2 - nonexisting number variable) running/-- through/in paragraphs in (T - text) begin -- end loop:
    (- {-my:rwc_count} = TEXT_TY_BlobAccess({-by-reference:T}, PARA_BLOB);
for ( {loopvar2} = 1, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*10), {-by-reference:T}, {loopvar2}, PARA_BLOB))  : {loopvar2} <= rwc_count : {loopvar2}++, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*10), {-by-reference:T}, {loopvar2}, PARA_BLOB)))
-)

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in paragraphs in (T - text) begin -- end loop:
    (- {-my:rwc_count} = TEXT_TY_BlobAccess({-by-reference:T}, PARA_BLOB);
for ( {-my:word_index} = 1, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*10), {-by-reference:T}, word_index, PARA_BLOB))  : word_index <= rwc_count : word_index++, BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob((I7SFRAME+WORDSIZE*10), {-by-reference:T}, word_index, PARA_BLOB)))
-)

Book Infinite Loop

[ it's your responsibility to break out! ]
To repeat forever begin -- end loop:
    (- while(1) -)

Book Descending

To repeat with/for (loopvar - nonexisting K variable) from/in (v - arithmetic value of kind K) downto (w - K) begin -- end loop:
      (- for ({loopvar}={v}: {loopvar}>={w}: {loopvar}-- ) -).

Book Overwriting Standard Rules 

Section Flexible Repeat Syntax (in place of Section SR5/3/3 - Control phrases - Repeat in Standard Rules by Graham Nelson)

To repeat with/for (loopvar - nonexisting K variable)
	running/-- from/in (v - arithmetic value of kind K) to (w - K) begin -- end loop
	(documented at ph_repeat):
		(- for ({loopvar}={v}: {loopvar}<={w}: {loopvar}++)  -).

To repeat with/for (loopvar - nonexisting K variable)
	running/-- from/in (v - enumerated value of kind K) to (w - K) begin -- end loop
	(documented at ph_repeat):
		(- for ({loopvar}={v}: {loopvar}<={w}: {loopvar}++)  -).

To repeat with/for (loopvar - nonexisting K variable)
	running/-- through/in (OS - description of values of kind K) begin -- end loop
	(documented at ph_runthrough):
		(- {-primitive-definition:repeat-through} -).

To repeat with/for (loopvar - nonexisting object variable)
	running/-- through/in (L - list of values) begin -- end loop
	(documented at ph_repeatlist):
		(- {-primitive-definition:repeat-through-list} -).

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

To repeat running/-- through/in (T - table name) in reverse order begin -- end loop
	(documented at ph_repeattablereverse): (-
		@push {-my:ct_0}; @push {-my:ct_1};
		for ({-my:1}={T}, {-my:2}=TableRows({-my:1}), ct_0={-my:1}, ct_1={-my:2}:
			{-my:2}>=1:
			{-my:2}--, ct_0={-my:1}, ct_1={-my:2})
			if (TableRowIsBlank(ct_0, ct_1)==false)
				{-block}
		@pull {-my:ct_1}; @pull {-my:ct_0};
	-).
To repeat running/-- through/in (T - table name) in (TC - table column) order begin -- end loop
	(documented at ph_repeattablecol): (-
		@push {-my:ct_0}; @push {-my:ct_1};
		for ({-my:1}={T}, {-my:2}=TableNextRow({-my:1}, {TC}, 0, 1), ct_0={-my:1}, ct_1={-my:2}:
			{-my:2}~=0:
			{-my:2}=TableNextRow({-my:1}, {TC}, {-my:2}, 1), ct_0={-my:1}, ct_1={-my:2})
				{-block}
		@pull {-my:ct_1}; @pull {-my:ct_0};
	-).

To repeat running/-- through/in (T - table name) in reverse (TC - table column) order begin -- end loop
	(documented at ph_repeattablecolreverse): (-
		@push {-my:ct_0}; @push {-my:ct_1};
		for ({-my:1}={T}, {-my:2}=TableNextRow({-my:1}, {TC}, 0, -1), ct_0={-my:1}, ct_1={-my:2}:
			{-my:2}~=0:
			{-my:2}=TableNextRow({-my:1}, {TC}, {-my:2}, -1), ct_0={-my:1}, ct_1={-my:2})
				{-block}
		@pull {-my:ct_1}; @pull {-my:ct_0};
	-).

Repetition with Variation ends here.

---- Documentation ----

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

Repeat running through the Table of Ill-considered decisions
Repeat for the Table of Ill-considered decisions

Facilitates looping through characters, words, punctuated words, unpunctuated words, paragraphs, with or without an index:

Repeat for char and index i in chars in str

Repeat with p running through the paragraphs in T

