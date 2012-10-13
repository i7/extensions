Version 1/121013 of High Performance Indexed Text by Dannii Willis begins here.

[
Aim:
	Inline calls to BlkValueRead() and BlkValueWrite() in Indexed Text related loops

Note:
	Sometimes the original code loops from 0 to <= BlkValueExtent(), other times only to < BlkValueExtent(). Is this buggy?
	We now have one generic range error in UpdateBlkStruct. It doesn't give as much info as the old ones in BlkValue* do, but that info probably isn't useful anyway!

Templates:

	!ch = BlkValueRead(indt, i);
	#ifdef TARGET_ZCODE;
		ch = (ITA-->1)++->0;
	#ifnot;
		@aload ITA 1 sp; @aloads sp 0 ch; ITA-->1 = ITA-->1 + 2;
	#endif;
	if ( ITA-->1 >= ITA-->2 ) UpdateBlkStruct( ITA );
	
TODO:
	BlockValues - Deep Copy
	IndexedText - Hashing
	IndexedText - Unserialisation
	IndexedText - Blob Access etc?
	IndexedText - Replace Text
	IndexedText - Casing
	IndexedText - Change Case
	IndexedText - Concatenation
	IndexedText - Setting the Player's Command
	RegExp - ...
]

Section - Introduction

[ In order to inline the BlkValue* calls we use structs (arrays) to refer to the important variables for each IT. An IT* struct has the following entries:
	0: block addr
	1: block data addr
	2: end of block data addr ]

Include (-

Array ITA --> 3;
Array ITB --> 3;
Array ITC --> 3;

! If you don't pass in a block, set to the next linked block
[ UpdateBlkStruct array block	headersize;
	if ( block == 0 )
	{
		block = (array-->0)-->BLK_NEXT;
		if ( block == NULL )
		{
			"*** UpdateBlkStruct: reached end of multi-block structure! ***";
		}
	}
	headersize = BLK_DATA_OFFSET;
	if ( (block->BLK_HEADER_FLAGS) & BLK_FLAG_MULTIPLE )
	{
		headersize = BLK_DATA_MULTI_OFFSET;
	}
	array-->0 = block;
	array-->1 = block + headersize;
	array-->2 = block + BlkSize( block );
];

-).

Section - Template replacements

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
	
	UpdateBlkStruct( ITA, indt );
	buff = buff + offs;
	for ( i=0 : i <= len : i++ )
	{
		#ifdef TARGET_ZCODE;
			(ITA-->1)++->0 = buff->i;
		#ifnot;
			@aload buff i sp; @aload ITA 1 sp; @astores sp 0 sp; ITA-->1 = ITA-->1 + 2;
		#endif;
		if ( ITA-->1 >= ITA-->2 ) UpdateBlkStruct( ITA );
	}

	.Failed;
	if (freebuff) VM_FreeMemory(freebuff);

	return indt;
];

-) instead of "Casting" in "IndexedText.i6t".

[ Comparison ]
Include (-

[ INDEXED_TEXT_TY_Compare indtleft indtright pos ch1 ch2 dsizeleft dsizeright;
	dsizeleft = BlkValueExtent(indtleft);
	dsizeright = BlkValueExtent(indtright);
	
	UpdateBlkStruct( ITA, indtleft );
	UpdateBlkStruct( ITB, indtright );
	
	for (pos=0:(pos<dsizeleft) && (pos<dsizeright):pos++)
	{
		!ch1 = BlkValueRead(indtleft, pos);
		#ifdef TARGET_ZCODE;
			ch1 = (ITA-->1)++->0;
		#ifnot;
			@aload ITA 1 sp; @aloads sp 0 ch1; ITA-->1 = ITA-->1 + 2;
		#endif;
		if ( ITA-->1 >= ITA-->2 ) UpdateBlkStruct( ITA );
		
		!ch2 = BlkValueRead(indtright, pos);
		#ifdef TARGET_ZCODE;
			ch2 = (ITB-->1)++->0;
		#ifnot;
			@aload ITB 1 sp; @aloads sp 0 ch2; ITB-->1 = ITB-->1 + 2;
		#endif;
		if ( ITB-->1 >= ITB-->2 ) UpdateBlkStruct( ITB );
		
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

[ Skipping Hashing - is it ever used? ]

[ Printing ]

Include (-

[ INDEXED_TEXT_TY_Say indt  ch i dsize;
	if ((indt==0) || (BlkType(indt) ~= INDEXED_TEXT_TY)) return;
	
	UpdateBlkStruct( ITA, indt );
	
	dsize = BlkValueExtent(indt);
	for (i=0:i<dsize:i++) {
	
		!ch = BlkValueRead(indt, i);
		#ifdef TARGET_ZCODE;
			ch = (ITA-->1)++->0;
		#ifnot;
			@aload ITA 1 sp; @aloads sp 0 ch; ITA-->1 = ITA-->1 + 2;
		#endif;
		if ( ITA-->1 >= ITA-->2 ) UpdateBlkStruct( ITA );
		
		if (ch == 0) break;
		#ifdef TARGET_ZCODE;
		print (char) ch;
		#ifnot; ! TARGET_ZCODE
		glk_put_char_uni(ch);
		#endif;
	}
];

-) instead of "Printing" in "IndexedText.i6t".

[ Serialisation ]

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
			#ifdef TARGET_ZCODE;
				ch = (ITA-->1)++->0;
			#ifnot;
				@aload ITA 1 sp; @aloads sp 0 ch; ITA-->1 = ITA-->1 + 2;
			#endif;
			if ( ITA-->1 >= ITA-->2 ) UpdateBlkStruct( ITA );
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

[ Recognition-only-GPR ]

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
			#ifdef TARGET_ZCODE;
				ch = (ITA-->1)++->0;
			#ifnot;
				@aload ITA 1 sp; @aloads sp 0 ch; ITA-->1 = ITA-->1 + 2;
			#endif;
			if ( ITA-->1 >= ITA-->2 ) UpdateBlkStruct( ITA );
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

[ Character Length ]

Include (-

[ IT_CharacterLength indt ch i dsize;
	if ((indt==0) || (BlkType(indt) ~= INDEXED_TEXT_TY)) return 0;
	
	UpdateBlkStruct( ITA, indt );
	
	dsize = BlkValueExtent(indt);
	for (i=0:i<dsize:i++) {
	
		!ch = BlkValueRead(indt, i);
		#ifdef TARGET_ZCODE;
			ch = (ITA-->1)++->0;
		#ifnot;
			@aload ITA 1 sp; @aloads sp 0 ch; ITA-->1 = ITA-->1 + 2;
		#endif;
		if ( ITA-->1 >= ITA-->2 ) UpdateBlkStruct( ITA );
		
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

High Performance Indexed Text ends here.