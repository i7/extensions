Version 1/121014 of High Performance Indexed Text by Dannii Willis begins here.

[
Aim:
	Inline calls to BlkValueRead() and BlkValueWrite() in Indexed Text related loops

Note:
	Sometimes the original code loops from 0 to <= BlkValueExtent(), other times only to < BlkValueExtent(). Is this buggy?
	We now have one generic range error in UpdateBlkStruct. It doesn't give as much info as the old ones in BlkValue* do, but that info probably isn't useful anyway!
	BlkValueSetExtent() can turn a single-block text into a multi-block text -> Block structs must be reinitialised!
	
TODO:
	IndexedText - Unserialisation
	IndexedText - Blob Access etc?
	IndexedText - Casing
	IndexedText - Change Case
	IndexedText - Setting the Player's Command
	RegExp - ...
]

Section - Introduction

[ In order to inline the BlkValue* calls we use structs (arrays) to refer to the important variables for each IT. An IT* struct has the following structure:
	0: head block addr
	1: multi-block?
	2: block addr
	3: block data addr
	4: end of block data addr ]

Include (-

#ifdef TARGET_ZCODE;
	Constant HPIT_SIZE 1;
#ifnot;
	Constant HPIT_SIZE 2;
#endif;

[ UpdateBlkStruct array block	overflow headersize;
	! If you don't pass in an array, get a new block value
	if ( array == 0 )
	{
		array = BlkAllocate( 5 * WORDSIZE );
		array = array + 2 * WORDSIZE;
	}
	! If you don't pass in a block, set to the next linked block
	if ( block == 0 )
	{
		overflow = array-->3 - array-->4;
		block = (array-->2)-->BLK_NEXT;
		if ( block == NULL )
		{
			"*** UpdateBlkStruct: reached end of multi-block structure! ***";
		}
	}
	else
	{
		array-->0 = block;
		array-->1 = ( (block->BLK_HEADER_FLAGS) & BLK_FLAG_MULTIPLE ) && block-->BLK_NEXT;
	}
	headersize = BLK_DATA_OFFSET;
	if ( (block->BLK_HEADER_FLAGS) & BLK_FLAG_MULTIPLE )	
	{
		headersize = BLK_DATA_MULTI_OFFSET;
	}
	array-->2 = block;
	array-->3 = block + headersize + overflow;
	array-->4 = block + BlkSize( block );
	! Keep going if we're still overflowing!
	if ( array-->3 >= array-->4 )
	{
		UpdateBlkStruct( array );
	}
	return array;
];

! Set a Block Struct to a particular array address
[ SetBlkStructAddr array i;
	UpdateBlkStruct( array, array-->0, i * HPIT_SIZE );
];

[ FreeBlkStruct array;
	BlkFreeSingleBlock( array - 2 * WORDSIZE );
];

-).

Section - Template replacements

[ Deep Copy ]

Include (-

[ BlkValueCopy blockto blockfrom dsize i sf	ITA ITB z;
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
		ITA = UpdateBlkStruct( 0, blockfrom );
		ITB = UpdateBlkStruct( 0, blockto );
		for ( i = 0 : i < dsize : i++ )
		{
			if ( ITA-->3 >= ITA-->4 ) UpdateBlkStruct( ITA );
			if ( ITB-->3 >= ITB-->4 ) UpdateBlkStruct( ITB );
			#ifdef TARGET_ZCODE;
				@loadw ITA 3 z; @loadb z 0 sp; @inc z; @storew ITA 3 z;
				@loadw ITB 3 z; @storeb z 0 sp; @inc z; @storew ITB 3 z;
			#ifnot;
				@aload ITA 3 z; @aloads z 0 sp; @add z 2 z; @astore ITA 3 z;
				@aload ITB 3 z; @astores z 0 sp; @add z 2 z; @astore ITB 3 z;
			#endif;
		}
		FreeBlkStruct( ITB );
		FreeBlkStruct( ITA );
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

[ Casting ]
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
	
	buff = buff + offs;
	INDEXED_TEXT_TY_Cast_Inner( indt, buff, len );

	.Failed;
	if (freebuff) VM_FreeMemory(freebuff);

	return indt;
];

[ INDEXED_TEXT_TY_Cast_Inner indt buff len	ITA i z;
	ITA = UpdateBlkStruct( 0, indt );
	
	for ( i=0 : i <= len : i++ )
	{
		if ( ITA-->3 >= ITA-->4 ) UpdateBlkStruct( ITA );
		#ifdef TARGET_ZCODE;
			@loadw ITA 3 z; @loadb buff i sp; @storeb z 0 sp; @inc z; @storew ITA 3 z;
		#ifnot;
			@aload ITA 3 z; @aload buff i sp; @astores z 0 sp; @add z 2 z; @astore ITA 3 z;
		#endif;
	}
	
	FreeBlkStruct( ITA );
];

-) instead of "Casting" in "IndexedText.i6t".

[ Comparison ]
Include (-

[ INDEXED_TEXT_TY_Compare indtleft indtright ITA ITB ret;
	ITA = UpdateBlkStruct( 0, indtleft );
	ITB = UpdateBlkStruct( 0, indtright );
	ret = INDEXED_TEXT_TY_Compare_Inner( indtleft, indtright, ITA, ITB );
	FreeBlkStruct( ITB );
	FreeBlkStruct( ITA );
	return ret;
];

[ INDEXED_TEXT_TY_Compare_Inner indtleft indtright ITA ITB
		pos ch1 ch2 dsizeleft dsizeright z;
	dsizeleft = BlkValueExtent(indtleft);
	dsizeright = BlkValueExtent(indtright);
	
	for (pos=0:(pos<dsizeleft) && (pos<dsizeright):pos++)
	{
		!ch1 = BlkValueRead(indtleft, pos);
		!ch2 = BlkValueRead(indtright, pos);
		if ( ITA-->3 >= ITA-->4 ) UpdateBlkStruct( ITA );
		if ( ITB-->3 >= ITB-->4 ) UpdateBlkStruct( ITB );
		#ifdef TARGET_ZCODE;
			@loadw ITA 3 z; @loadb z 0 ch1; @inc z; @storew ITA 3 z;
			@loadw ITB 3 z; @loadb z 0 ch2; @inc z; @storew ITB 3 z;
		#ifnot;
			@aload ITA 3 z; @aloads z 0 ch1; @add z 2 z; @astore ITA 3 z;
			@aload ITB 3 z; @aloads z 0 ch2; @add z 2 z; @astore ITB 3 z;
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

[ Hashing ]

Include (-

[ INDEXED_TEXT_TY_Hash indt  rv len i	ITA z temp;
	ITA = UpdateBlkStruct( 0, indt );
	rv = 0;
	len = BlkValueExtent(indt);
	for (i=0: i<len: i++)
	{
		!rv = rv * 33 + BlkValueRead(indt, i);
		if ( ITA-->3 >= ITA-->4 ) UpdateBlkStruct( ITA );
		#ifdef TARGET_ZCODE;
			@loadw ITA 3 z; @loadb z 0 temp; @inc z; @storew ITA 3 z;
		#ifnot;
			@aload ITA 3 z; @aloads z 0 temp; @add z 2 z; @astore ITA 3 z;
		#endif;
		rv = rv * 33 + temp;
	}
	FreeBlkStruct( ITA );
	return rv;
];

-) instead of "Hashing" in "IndexedText.i6t".

[ Printing ]

Include (-

[ INDEXED_TEXT_TY_Say indt  ch i dsize	ITA z;
	if ((indt==0) || (BlkType(indt) ~= INDEXED_TEXT_TY)) return;
	
	ITA = UpdateBlkStruct( 0, indt );
	
	dsize = BlkValueExtent(indt);
	for (i=0:i<dsize:i++)
	{
		!ch = BlkValueRead(indt, i);
		if ( ITA-->3 >= ITA-->4 ) UpdateBlkStruct( ITA );
		#ifdef TARGET_ZCODE;
			@loadw ITA 3 z; @loadb z 0 ch; @inc z; @storew ITA 3 z;
		#ifnot;
			@aload ITA 3 z; @aloads z 0 ch; @add z 2 z; @astore ITA 3 z;
		#endif;
		
		if (ch == 0) break;
		#ifdef TARGET_ZCODE;
		print (char) ch;
		#ifnot; ! TARGET_ZCODE
		glk_put_char_uni(ch);
		#endif;
	}
	FreeBlkStruct( ITA );
];

-) instead of "Printing" in "IndexedText.i6t".

[ Serialisation ]

Include (-

[ INDEXED_TEXT_TY_WriteFile txb len pos ch	ITA z;
	ITA = UpdateBlkStruct( 0, txb );
	
	len = BlkValueExtent(txb);
	print "S";
	for (pos=0: pos<=len: pos++) {
		!if (pos == len) ch = 0; else ch = BlkValueRead(txb, pos);
		if (pos == len) ch = 0;
		else
		{
			if ( ITA-->3 >= ITA-->4 ) UpdateBlkStruct( ITA );
			#ifdef TARGET_ZCODE;
				@loadw ITA 3 z; @loadb z 0 ch; @inc z; @storew ITA 3 z;
			#ifnot;
				@aload ITA 3 z; @aloads z 0 ch; @add z 2 z; @astore ITA 3 z;
			#endif;
		}
		if (ch == 0) {
			print "0;"; break;
		} else {
			print ch, ",";
		}
	}
	FreeBlkStruct( ITA );
];

-) instead of "Serialisation" in "IndexedText.i6t".

[ Skipping Unserialisation - for now ]

[ Recognition-only-GPR - uses A ]

Include (-

[ INDEXED_TEXT_TY_ROGPR indt ITA ret;
	if (indt == 0) return GPR_FAIL;
	ITA = UpdateBlkStruct( 0, indt );
	ret = INDEXED_TEXT_TY_ROGPR_Inner( indt, ITA );
	FreeBlkStruct( ITA );
	return ret;
];

[ INDEXED_TEXT_TY_ROGPR_Inner indt ITA z
	pos len wa wl wpos bdm ch own;
	
	bdm = true; own = wn;
	len = BlkValueExtent(indt);
	for (pos=0: pos<=len: pos++) {
		!if (pos == len) ch = 0; else ch = BlkValueRead(indt, pos);
		if (pos == len) ch = 0;
		else
		{
			if ( ITA-->3 >= ITA-->4 ) UpdateBlkStruct( ITA );
			#ifdef TARGET_ZCODE;
				@loadw ITA 3 z; @loadb z 0 ch; @inc z; @storew ITA 3 z;
			#ifnot;
				@aload ITA 3 z; @aloads z 0 ch; @add z 2 z; @astore ITA 3 z;
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

[ Replace Text ]

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

	whitespace = true; punctuation = false;
	for (i=0:i<=ilen:i++) {
		ch = BlkValueRead(indt, i);
		.MoreMatching;
		chm = BlkValueRead(findt, mpos++);
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
			or '(' or ')' or '[' or ']' or '{' or '}')
		{
			if (blobtype == WORD_BLOB) chm = -1;
			punctuation = true;
		}
		if (ch == chm) {
			if (mpos == flen) {
				if (i == ilen) chm = 0;
				else chm = BlkValueRead(indt, i+1);
				if ((blobtype == CHR_BLOB) ||
					(chm == 0 or 10 or 13 or 32 or 9) ||
					(chm == '.' or ',' or '!' or '?'
						or '-' or '/' or '"' or ':' or ';'
						or '(' or ')' or '[' or ']' or '{' or '}'))
				{
					mpos = 0;
					cl = cl - (flen-1);
					BlkValueWrite(cindt, cl, 0);
					IT_Concatenate(cindt, rindt, CHR_BLOB);
					csize = BlkValueExtent(cindt);
					cl = IT_CharacterLength(cindt);
					continue;
				}
			}
		} else {
			mpos = 0;
		}
		if (cl+1 >= csize) {
			if (BlkValueSetExtent(cindt, 2*cl, 9) == false) break;
			csize = BlkValueExtent(cindt);
		}
		BlkValueWrite(cindt, cl++, ch);
	}
	BlkValueCopy(indt, cindt);	
	BlkFree(cindt);
];

-) instead of "Replace Text" in "IndexedText.i6t".

[ Character Length ]

Include (-

[ IT_CharacterLength indt ch i dsize	ITA z;
	if ((indt==0) || (BlkType(indt) ~= INDEXED_TEXT_TY)) return 0;
	
	ITA = UpdateBlkStruct( 0, indt );
	
	dsize = BlkValueExtent(indt);
	for (i=0:i<dsize:i++) {
	
		!ch = BlkValueRead(indt, i);
		if ( ITA-->3 >= ITA-->4 ) UpdateBlkStruct( ITA );
		#ifdef TARGET_ZCODE;
			@loadw ITA 3 z; @loadb z 0 ch; @inc z; @storew ITA 3 z;
		#ifnot;
			@aload ITA 3 z; @aloads z 0 ch; @add z 2 z; @astore ITA 3 z;
		#endif;
		
		if (ch == 0)
		{
			!return i;
			dsize = i;
			break;
		}
	}
	FreeBlkStruct( ITA );
	return dsize;
];

[ INDEXED_TEXT_TY_Empty indt;
	if ((indt==0) || (BlkType(indt) ~= INDEXED_TEXT_TY)) rfalse;
	if (IT_CharacterLength(indt) == 0) rtrue;
	rfalse;
];

-) instead of "Character Length" in "IndexedText.i6t".

[ Concatenation ]

Include (-

[ IT_Concatenate indt_to indt_from blobtype indt_ref
	pos len ch i tosize x y case	ITA ITB z;
	if ((indt_to==0) || (BlkType(indt_to) ~= INDEXED_TEXT_TY)) rfalse;
	if ((indt_from==0) || (BlkType(indt_from) ~= INDEXED_TEXT_TY)) return indt_to;
	
	switch(blobtype) {
		CHR_BLOB, 0:
			pos = IT_CharacterLength(indt_to);
			len = IT_CharacterLength(indt_from);
			if (BlkValueSetExtent(indt_to, pos+len+1, 10) == false) return indt_to;
			
			ITA = UpdateBlkStruct( 0, indt_from );
			ITB = UpdateBlkStruct( 0, indt_to, pos * HPIT_SIZE );

			for (i=0:i<len:i++)
			{
				!ch = BlkValueRead(indt_from, i);
				!BlkValueWrite(indt_to, i+pos, ch);
				if ( ITA-->3 >= ITA-->4 ) UpdateBlkStruct( ITA );
				if ( ITB-->3 >= ITB-->4 ) UpdateBlkStruct( ITB );
				#ifdef TARGET_ZCODE;
					@loadw ITA 3 z; @loadb z 0 sp; @inc z; @storew ITA 3 z;
					@loadw ITB 3 z; @storeb z 0 sp; @inc z; @storew ITB 3 z;
				#ifnot;
					@aload ITA 3 z; @aloads z 0 sp; @add z 2 z; @astore ITA 3 z;
					@aload ITB 3 z; @astores z 0 sp; @add z 2 z; @astore ITB 3 z;
				#endif;
			}
			FreeBlkStruct( ITB );
			FreeBlkStruct( ITA );
			
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