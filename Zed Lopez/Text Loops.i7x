Version 1 of Text Loops by Zed Lopez begins here.

"Loop through characters, words, lines, or paragraphs in a text."

Include 6M62 Patches by Friends of I7. [ need TEXT_TY_BlobAccess fix ]

Book Text manipulation

Part Characters

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in chars/characters in/of (T - text) with/using index (index - nonexisting number variable) begin -- end loop:
    (- {-my:1} = TEXT_TY_BlobAccess({-by-reference:T}, CHR_BLOB);
for ( {index} = 1  : {index} <= {-my:1} : {index}++)
if (BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob({-new:text}, {-by-reference:T}, {index}, CHR_BLOB)))
-)

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in chars/characters in/of (T - text) begin -- end loop:
    (- {-my:1} = TEXT_TY_BlobAccess({-by-reference:T}, CHR_BLOB);
for ( {-my:2} = 1 : {-my:2} <= {-my:1} : {-my:2}++ )
if (BlkValueCopy({-by-reference:loopvar}, TEXT_TY_GetBlob({-new:text}, {-by-reference:T}, {-my:2}, CHR_BLOB)))
-)

Part Words

To repeat with/for (loopvar - nonexisting text variable) running/-- through/in words in/of (T - text) with/using index (index - nonexisting number variable) begin -- end loop:
    (- {-my:1} = TEXT_TY_BlobAccess({-by-reference:T}, WORD_BLOB);
for ( {index} = 1  : {index} <= {-my:1} : {index}++)
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

Text Loops ends here.

---- Documentation ----

This is experimental and mostly made out of the undocumented features in the Standard Rules the docs call on us not to use.

Ways you can also loop through text (uword = unpunctuated word; pword = punctuated word):

```
repeat with ch running through characters in T:
repeat with w running through words in T:
repeat with uw running through uwords in T:
repeat with pw running through pwords in T:
repeat with line running through lines in T:
repeat with p running through paragraphs in T:
```

"Characters" may be abbreviated as "chars" and all of the above can also have an index specified:

```
repeat for ch in chars of T with index i;
```

