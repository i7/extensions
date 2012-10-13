Version 1/121013 of High Performance Indexed Text by Dannii Willis begins here.

[
Aim:
	Inline calls to BlkValueRead() and BlkValueWrite() in Indexed Text related loops

Note:
	Sometimes the original code loops from 0 to <= BlkValueExtent(), other times only to < BlkValueExtent(). Is this buggy?
	We now have one generic range error in UpdateBlkStruct. It doesn't give as much info as the old ones in BlkValue* do, but that info probably isn't useful anyway!
	BlkValueSetExtent() can turn a single-block text into a multi-block text -> Block structs must be reinitialised!
	If a function using block structs calls another function using block structs they cannot use the same structs!

Templates:

	!ch = BlkValueRead(indt, i);
	#ifdef TARGET_ZCODE;
		ch = (ITA-->1)++->0;
	#ifnot;
		@aload ITA 1 sp; @aloads sp 0 ch; ITA-->1 = ITA-->1 + 2;
	#endif;
	if ( ITA-->1 >= ITA-->2 ) UpdateBlkStruct( ITA );
	
TODO:
	IndexedText - Unserialisation
	IndexedText - Blob Access etc?
	IndexedText - Casing
	IndexedText - Change Case
	IndexedText - Setting the Player's Command
	RegExp - ...
]

Section - Introduction

[ In order to inline the BlkValue* calls we use structs (arrays) to refer to the important variables for each IT. An IT* struct has the following entries:
	0: block addr
	1: block data addr
	2: end of block data addr
	3: original block addr ]

Include (-

Array ITA --> 4;
Array ITB --> 4;
Array ITC --> 4;
Array ITD --> 4;
Array ITE --> 4;

#ifdef TARGET_ZCODE;
	Constant HPIT_WSIZE 1;
#ifnot;
	Constant HPIT_WSIZE 2;
#endif;

! If you don't pass in a block, set to the next linked block
[ UpdateBlkStruct array block	overflow headersize;
	if ( block == 0 )
	{
		overflow = array-->1 - array-->2;
		block = (array-->0)-->BLK_NEXT;
		if ( block == NULL )
		{
			"*** UpdateBlkStruct: reached end of multi-block structure! ***";
		}
	}
	else
	{
		array-->3 = block;
	}
	headersize = BLK_DATA_OFFSET;
	if ( (block->BLK_HEADER_FLAGS) & BLK_FLAG_MULTIPLE )	
	{
		headersize = BLK_DATA_MULTI_OFFSET;
	}
	array-->0 = block;
	array-->1 = block + headersize + overflow;
	array-->2 = block + BlkSize( block );
	! Keep going if we're still overflowing!
	if ( array-->1 >= array-->2 )
	{
		UpdateBlkStruct( array );
	}
];

! Set a Block Struct to a particular array address
[ SetBlkStructAddr array i;
	UpdateBlkStruct( array, array-->3, i * HPIT_WSIZE );
];

-).

Section - Template replacements

[ Deep Copy - uses A B ]

Include (-

[ BlkValueCopy blockto blockfrom dsize i sf;
	if (blockto == 0) { print "*** Deep copy failed: destination empty ***^"; rfalse; }
	if (blockfrom == 0) { print "*** Deep copy failed: source empty ***^"; rfalse; }

	if (blockfrom->BLK_HEADER_N == 0) {
		! A hack to handle precompiled array constants: N=0 blocks otherwise don't exist
		LIST_OF_TY_CopyRawArray(blockto, blockfrom, 1, 0);
		return blockto;
	}

	if (blockfrom-->BLK_HEADER_KOV ~= blockto-->BLK_HEADER_KOV) {
		print "*** Deep copy failed: types mismatch ***^"; rfalse;
	}

	BlkValueDestroy(blockto);

	dsize = BlkValueExtent(blockfrom);

	if (((blockfrom->BLK_HEADER_FLAGS) & BLK_FLAG_MULTIPLE) &&
		(BlkValueSetExtent(blockto, dsize, -1) == false)) {
		print "*** Deep copy failed: resizing failed ***^"; rfalse;
	}

	sf = KOVSupportFunction(blockfrom-->BLK_HEADER_KOV);

	if (sf) sf(PRECOPY_KOVS, blockto, blockfrom);
	
	! If we are copying indexed text take some short cuts
	if ( BlkType( blockfrom ) == INDEXED_TEXT_TY )
	{
		UpdateBlkStruct( ITA, blockfrom );
		UpdateBlkStruct( ITB, blockto );
		for ( i = 0 : i < dsize : i++ )
		{
			if ( ITA-->1 >= ITA-->2 ) UpdateBlkStruct( ITA );
			if ( ITB-->1 >= ITB-->2 ) UpdateBlkStruct( ITB );
			#ifdef TARGET_ZCODE;
				(ITB-->1)++->0 = (ITA-->1)++->0;
			#ifnot;
				@aload ITA 1 sp; @aloads sp 0 sp; ITA-->1 = ITA-->1 + 2;
				@aload ITB 1 sp; @astores sp 0 sp; ITB-->1 = ITB-->1 + 2;
			#endif;
		}
	}
	else
	{
		for (i=0:i<dsize:i++) BlkValueWrite(blockto, i, BlkValueRead(blockfrom, i));
	}

	if (sf) sf(COPY_KOVS, blockto, blockfrom);
	else { print "*** Impossible runtime copy ***^"; rfalse; }
	return blockto;
];

-) instead of "Deep Copy" in "BlockValues.i6t".

[ Casting - uses A ]
Include (-

#ifndef IT_MemoryBufferSize;
Constant IT_MemoryBufferSize = 512;
#endif;

Constant IT_Memory_NoBuffers = 2;

#ifndef IT_Memory_NoBuffers;
Constant IT_Memory_NoBuffers = 1;
#endif;

#ifdef TARGET_ZCODE;
Array IT_MemoryBuffer -> IT_MemoryBufferSize*IT_Memory_NoBuffers; ! Where characters are bytes
#ifnot;
Array IT_MemoryBuffer --> (IT_MemoryBufferSize+2)*IT_Memory_NoBuffers; ! Where characters are words
#endif;

Global RawBufferAddress = IT_MemoryBuffer;
Global RawBufferSize = IT_MemoryBufferSize;

Global IT_cast_nesting;

[ INDEXED_TEXT_TY_Cast tx fromkov indt
	len i str oldstr offs realloc news buff buffx freebuff results;
	#ifdef TARGET_ZCODE;
	buffx = IT_MemoryBufferSize;
	#ifnot;
	buffx = (IT_MemoryBufferSize + 2)*WORDSIZE;
	#endif;
	
	buff = RawBufferAddress + IT_cast_nesting*buffx;
	IT_cast_nesting++;
	if (IT_cast_nesting > IT_Memory_NoBuffers) {
		buff = VM_AllocateMemory(buffx); freebuff = buff;
		if (buff == 0) {
			BlkAllocationError("ran out with too many simultaneous indexed text conversions");
			return;
		}
	}

	.RetryWithLargerBuffer;
	if (tx == 0) {
		#ifdef TARGET_ZCODE;
		buff-->0 = 1;
		buff->2 = 0;
		#ifnot;
		buff-->0 = 0;
		#endif;
		len = 1;
	} else {
		#ifdef TARGET_ZCODE;
		@output_stream 3 buff;
		#ifnot;
		if (unicode_gestalt_ok == false) { RunTimeProblem(RTP_NOGLULXUNICODE); jump Failed; }
		oldstr = glk_stream_get_current();
		str = glk_stream_open_memory_uni(buff, RawBufferSize, filemode_Write, 0);
		glk_stream_set_current(str);
		#endif;

		@push say__p; @push say__pc;
		ClearParagraphing();
		if (fromkov == SNIPPET_TY) print (PrintSnippet) tx;
		else {
			if (tx ofclass String) print (string) tx;
			if (tx ofclass Routine) (tx)();	
		}
		@pull say__pc; @pull say__p;

		#ifdef TARGET_ZCODE;

		@output_stream -3;
		len = buff-->0;
		if (len > RawBufferSize-1) len = RawBufferSize-1;
		offs = 2;
		buff->(len+2) = 0;

		#ifnot; ! i.e. GLULX
		
		results = buff + buffx - 2*WORDSIZE;
		glk_stream_close(str, results);
		if (oldstr) glk_stream_set_current(oldstr);
		len = results-->1;
		if (len > RawBufferSize-1) {
			! Glulx had to truncate text output because the buffer ran out:
			! len is the number of characters which it tried to print
			news = RawBufferSize;
			while (news < len) news=news*2;
			news = news*4; ! Bytes rather than words
			i = VM_AllocateMemory(news);
			if (i ~= 0) {
				if (freebuff) VM_FreeMemory(freebuff);
				freebuff = i;
				buff = i;
				RawBufferSize = news/4;
				jump RetryWithLargerBuffer;
			}
			! Memory allocation refused: all we can do is to truncate the text
			len = RawBufferSize-1;
		}
		offs = 0;
		buff-->(len) = 0;

		#endif;

		len++;
	}

	IT_cast_nesting--;

	if (indt == 0) {
		indt = BlkAllocate(len+1, INDEXED_TEXT_TY, IT_Storage_Flags);
		if (indt == 0) jump Failed;
	} else {
		if (BlkValueSetExtent(indt, len+1, 1) == false) { indt = 0; jump Failed; }
	}
	
	!#ifdef TARGET_ZCODE;
	!for (i=0:i<=len:i++) BlkValueWrite(indt, i, buff->(i+offs));
	!#ifnot;
	!for (i=0:i<=len:i++) BlkValueWrite(indt, i, buff-->(i+offs));
	!#endif;
	
	UpdateBlkStruct( ITA, indt );
	buff = buff + offs;
	for ( i=0 : i <= len : i++ )
	{
		if ( ITA-->1 >= ITA-->2 ) UpdateBlkStruct( ITA );
		#ifdef TARGET_ZCODE;
			(ITA-->1)++->0 = buff->i;
		#ifnot;
			@aload buff i sp; @aload ITA 1 sp; @astores sp 0 sp; ITA-->1 = ITA-->1 + 2;
		#endif;
	}

	.Failed;
	if (freebuff) VM_FreeMemory(freebuff);

	return indt;
];

-) instead of "Casting" in "IndexedText.i6t".

[ Comparison - uses A B ]
Include (-

[ INDEXED_TEXT_TY_Compare indtleft indtright pos ch1 ch2 dsizeleft dsizeright;
	dsizeleft = BlkValueExtent(indtleft);
	dsizeright = BlkValueExtent(indtright);
	
	UpdateBlkStruct( ITA, indtleft );
	UpdateBlkStruct( ITB, indtright );
	
	for (pos=0:(pos<dsizeleft) && (pos<dsizeright):pos++)
	{
		!ch1 = BlkValueRead(indtleft, pos);
		!ch2 = BlkValueRead(indtright, pos);
		if ( ITA-->1 >= ITA-->2 ) UpdateBlkStruct( ITA );
		if ( ITB-->1 >= ITB-->2 ) UpdateBlkStruct( ITB );
		#ifdef TARGET_ZCODE;
			ch1 = (ITA-->1)++->0;
			ch2 = (ITB-->1)++->0;
		#ifnot;
			@aload ITA 1 sp; @aloads sp 0 ch1; ITA-->1 = ITA-->1 + 2;
			@aload ITB 1 sp; @aloads sp 0 ch2; ITB-->1 = ITB-->1 + 2;
		#endif;
		
		if (ch1 ~= ch2) return ch1-ch2;
		if (ch1 == 0) return 0;
	}
	if (pos == dsizeleft) return -1;
	return 1;
];

[ INDEXED_TEXT_TY_Distinguish indtleft indtright;
	if (INDEXED_TEXT_TY_Compare(indtleft, indtright) == 0) rfalse;
	rtrue;
];

-) instead of "Comparison" in "IndexedText.i6t".

[ Hashing - uses A ]

Include (-

[ INDEXED_TEXT_TY_Hash indt  rv len i temp;
	UpdateBlkStruct( ITA, indt );
	rv = 0;
	len = BlkValueExtent(indt);
	for (i=0: i<len: i++)
	{
		!rv = rv * 33 + BlkValueRead(indt, i);
		if ( ITA-->1 >= ITA-->2 ) UpdateBlkStruct( ITA );
		#ifdef TARGET_ZCODE;
			temp = (ITA-->1)++->0;
		#ifnot;
			@aload ITA 1 sp; @aloads sp 0 temp; ITA-->1 = ITA-->1 + 2;
		#endif;
		rv = rv * 33 + temp;
	}
	return rv;
];

-) instead of "Hashing" in "IndexedText.i6t".

[ Printing - uses A ]

Include (-

[ INDEXED_TEXT_TY_Say indt  ch i dsize;
	if ((indt==0) || (BlkType(indt) ~= INDEXED_TEXT_TY)) return;
	
	UpdateBlkStruct( ITA, indt );
	
	dsize = BlkValueExtent(indt);
	for (i=0:i<dsize:i++)
	{
		!ch = BlkValueRead(indt, i);
		if ( ITA-->1 >= ITA-->2 ) UpdateBlkStruct( ITA );
		#ifdef TARGET_ZCODE;
			ch = (ITA-->1)++->0;
		#ifnot;
			@aload ITA 1 sp; @aloads sp 0 ch; ITA-->1 = ITA-->1 + 2;
		#endif;
		!print BlkValueRead(indt, i), " ", ch, "^";
		
		if (ch == 0) break;
		#ifdef TARGET_ZCODE;
		print (char) ch;
		#ifnot; ! TARGET_ZCODE
		glk_put_char_uni(ch);
		#endif;
	}
];

-) instead of "Printing" in "IndexedText.i6t".

[ Serialisation - uses A ]

Include (-

[ INDEXED_TEXT_TY_WriteFile txb len pos ch;
	
	UpdateBlkStruct( ITA, txb );
	
	len = BlkValueExtent(txb);
	print "S";
	for (pos=0: pos<=len: pos++) {
		!if (pos == len) ch = 0; else ch = BlkValueRead(txb, pos);
		if (pos == len) ch = 0;
		else
		{
			if ( ITA-->1 >= ITA-->2 ) UpdateBlkStruct( ITA );
			#ifdef TARGET_ZCODE;
				ch = (ITA-->1)++->0;
			#ifnot;
				@aload ITA 1 sp; @aloads sp 0 ch; ITA-->1 = ITA-->1 + 2;
			#endif;
		}
		if (ch == 0) {
			print "0;"; break;
		} else {
			print ch, ",";
		}
	}
];

-) instead of "Serialisation" in "IndexedText.i6t".

[ Skipping Unserialisation - for now ]

[ Recognition-only-GPR - uses A ]

Include (-

[ INDEXED_TEXT_TY_ROGPR indt
	pos len wa wl wpos bdm ch own;
	if (indt == 0) return GPR_FAIL;
	
	UpdateBlkStruct( ITA, indt );
	
	bdm = true; own = wn;
	len = BlkValueExtent(indt);
	for (pos=0: pos<=len: pos++) {
		!if (pos == len) ch = 0; else ch = BlkValueRead(indt, pos);
		if (pos == len) ch = 0;
		else
		{
			if ( ITA-->1 >= ITA-->2 ) UpdateBlkStruct( ITA );
			#ifdef TARGET_ZCODE;
				ch = (ITA-->1)++->0;
			#ifnot;
				@aload ITA 1 sp; @aloads sp 0 ch; ITA-->1 = ITA-->1 + 2;
			#endif;
		}
		if (ch == 32 or 9 or 10 or 0) {
			if (bdm) continue;
			bdm = true;
			if (wpos ~= wl) return GPR_FAIL;
			if (ch == 0) break;
		} else {
			if (bdm) {
				bdm = false;
				if (NextWordStopped() == -1) return GPR_FAIL;
				wa = WordAddress(wn-1);
				wl = WordLength(wn-1);
				wpos = 0;
			}
			if (wa->wpos ~= ch or IT_RevCase(ch)) return GPR_FAIL;
			wpos++;
		}
	}
	if (wn == own) return GPR_FAIL; ! Progress must be made to avoid looping
	return GPR_PREPOSITION;
];

-) instead of "Recognition-only-GPR" in "IndexedText.i6t".

[ Skipping Blobs etc - for now ]

[ Replace Text - uses C D E ]

Include (-

[ IT_ReplaceText blobtype indt findt rindt
	cindt csize ilen flen i cl mpos ch chm whitespace punctuation;
	
	if (blobtype == REGEXP_BLOB or CHR_BLOB) 
		return IT_Replace_RE(blobtype, indt, findt, rindt);
	
	ilen = IT_CharacterLength(indt);
	flen = IT_CharacterLength(findt);
	cindt = BlkValueCreate(INDEXED_TEXT_TY);
	csize = BlkValueExtent(cindt);
	mpos = 0;
	
	UpdateBlkStruct( ITD, indt );
	UpdateBlkStruct( ITE, findt );
	UpdateBlkStruct( ITC, cindt );
	
	whitespace = true; punctuation = false;
	for (i=0:i<=ilen:i++)
	{
		!ch = BlkValueRead(indt, i);
		if ( ITD-->1 >= ITD-->2 ) UpdateBlkStruct( ITD );
		#ifdef TARGET_ZCODE;
			ch = (ITD-->1)++->0;
		#ifnot;
			@aload ITD 1 sp; @aloads sp 0 ch; ITD-->1 = ITD-->1 + 2;
		#endif;
		
		.MoreMatching;
		
		!chm = BlkValueRead(findt, mpos++);
		if ( ITE-->1 >= ITE-->2 ) UpdateBlkStruct( ITE );
		#ifdef TARGET_ZCODE;
			chm = (ITE-->1)++->0;
		#ifnot;
			@aload ITE 1 sp; @aloads sp 0 chm; ITE-->1 = ITE-->1 + 2;
		#endif;
		mpos++;
		
		if (mpos == 1) {
			switch (blobtype) {
				WORD_BLOB:
					if ((whitespace == false) && (punctuation == false)) chm = -1;
			}
		}
		whitespace = false;
		if (ch == 10 or 13 or 32 or 9) whitespace = true;
		punctuation = false;
		if (ch == '.' or ',' or '!' or '?'
			or '-' or '/' or '"' or ':' or ';'
			or '(' or ')' or '[' or ']' or '{' or '}') {
			if (blobtype == WORD_BLOB) chm = -1;
			punctuation = true;
		}
		if (ch == chm) {
			if (mpos == flen) {
				if (i == ilen) chm = 0;
				else
				{
					!chm = BlkValueRead(indt, i+1);
					#ifdef TARGET_ZCODE;
						chm = (ITD-->1)->0;
					#ifnot;
						@aload ITD 1 sp; @aloads sp 0 chm;
					#endif;
				}
				if ((blobtype == CHR_BLOB) ||
					(chm == 0 or 10 or 13 or 32 or 9) ||
					(chm == '.' or ',' or '!' or '?'
						or '-' or '/' or '"' or ':' or ';'
						or '(' or ')' or '[' or ']' or '{' or '}')) {
					
					mpos = 0;
					SetBlkStructAddr( ITE, 0 );
					
					cl = cl - (flen-1);
					SetBlkStructAddr( ITC, cl );
					
					!BlkValueWrite(cindt, cl, 0);
					#ifdef TARGET_ZCODE;
						(ITC-->1)->0 = 0;
					#ifnot;
						@aload ITC 1 sp; @astores sp 0 0;
					#endif;
					
					IT_Concatenate(cindt, rindt, CHR_BLOB);
					csize = BlkValueExtent(cindt);
					cl = IT_CharacterLength(cindt);
					
					SetBlkStructAddr( ITC, cl );
					
					continue;
				}
			}
		} else {
			mpos = 0;
			SetBlkStructAddr( ITE, 0 );
		}
		if (cl+1 >= csize) {
			if (BlkValueSetExtent(cindt, 2*cl, 9) == false) break;
			csize = BlkValueExtent(cindt);
			SetBlkStructAddr( ITC, cl );
		}
		
		!BlkValueWrite(cindt, cl++, ch);
		if ( ITC-->1 >= ITC-->2 ) UpdateBlkStruct( ITC );
		#ifdef TARGET_ZCODE;
			(ITC-->1)++->0 = ch;
		#ifnot;
			@aload ITC 1 sp; @astores sp 0 ch; ITC-->1 = ITC-->1 + 2;
		#endif;
		cl++;
	}
	BlkValueCopy(indt, cindt);	
	BlkFree(cindt);
];

-) instead of "Replace Text" in "IndexedText.i6t".

[ Character Length - uses A ]

Include (-

[ IT_CharacterLength indt ch i dsize;
	if ((indt==0) || (BlkType(indt) ~= INDEXED_TEXT_TY)) return 0;
	
	UpdateBlkStruct( ITA, indt );
	
	dsize = BlkValueExtent(indt);
	for (i=0:i<dsize:i++) {
	
		!ch = BlkValueRead(indt, i);
		if ( ITA-->1 >= ITA-->2 ) UpdateBlkStruct( ITA );
		#ifdef TARGET_ZCODE;
			ch = (ITA-->1)++->0;
		#ifnot;
			@aload ITA 1 sp; @aloads sp 0 ch; ITA-->1 = ITA-->1 + 2;
		#endif;
		
		if (ch == 0) return i;
	}
	return dsize;
];

[ INDEXED_TEXT_TY_Empty indt;
	if ((indt==0) || (BlkType(indt) ~= INDEXED_TEXT_TY)) rfalse;
	if (IT_CharacterLength(indt) == 0) rtrue;
	rfalse;
];

-) instead of "Character Length" in "IndexedText.i6t".

[ Concatenation - uses A B ]

Include (-

[ IT_Concatenate indt_to indt_from blobtype indt_ref
	pos len ch i tosize x y case;
	if ((indt_to==0) || (BlkType(indt_to) ~= INDEXED_TEXT_TY)) rfalse;
	if ((indt_from==0) || (BlkType(indt_from) ~= INDEXED_TEXT_TY)) return indt_to;
	
	switch(blobtype) {
		CHR_BLOB, 0:
			pos = IT_CharacterLength(indt_to);
			len = IT_CharacterLength(indt_from);
			if (BlkValueSetExtent(indt_to, pos+len+1, 10) == false) return indt_to;
			
			UpdateBlkStruct( ITA, indt_from );
			UpdateBlkStruct( ITB, indt_to, pos * HPIT_WSIZE );

			for (i=0:i<len:i++)
			{
				!ch = BlkValueRead(indt_from, i);
				!BlkValueWrite(indt_to, i+pos, ch);
				if ( ITA-->1 >= ITA-->2 ) UpdateBlkStruct( ITA );
				if ( ITB-->1 >= ITB-->2 ) UpdateBlkStruct( ITB );
				#ifdef TARGET_ZCODE;
					(ITB-->1)++->0 = (ITA-->1)++->0;
				#ifnot;
					@aload ITA 1 sp; @aloads sp 0 ch; ITA-->1 = ITA-->1 + 2;
					@aload ITB 1 sp; @astores sp 0 ch; ITB-->1 = ITB-->1 + 2;
				#endif;
			}
			BlkValueWrite(indt_to, len+pos, 0);
			return indt_to;
		REGEXP_BLOB:
			return IT_RE_Concatenate(indt_to, indt_from, blobtype, indt_ref);
		default:
			print "*** IT_Concatenate used on impossible blob type ***^";
			rfalse;
	}
];

-) instead of "Concatenation" in "IndexedText.i6t".

Section - Unit tests (not for release) (for use with Simple Unit Tests by Dannii Willis)

Unit test (this is the Mutable Kinds rule):
	let T be indexed text;
	let T be "Hello World!";
	[1] assert that T is "Hello World!";
	[2] assert that the number of characters in T is 12;
	let T2 be indexed text;
	let T2 be "Hello World!";
	[3] assert that T is T2;
	replace the word "Hello" in T2 with "Goodbye";
	[4] assert that T2 is "Goodbye World!";

High Performance Indexed Text ends here.

---- DOCUMENTATION ----

This extension improves the performance of Indexed Text and Regular Expressions by altering much of their template code. There are no changes to how you use either feature.

The latest version of this extension can be found at <https://github.com/i7/extensions>. This extension is released under the Creative Commons Attribution licence. Contact the author at <curiousdannii@gmail.com>