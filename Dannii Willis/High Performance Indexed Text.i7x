Version 1/121012 of High Performance Indexed Text by Dannii Willis begins here.

[
Aim: Inline calls to BlkValueRead() and BlkValueWrite() in Indexed Text related loops
Note:
	Sometimes the original code loops from 0 to <= BlkValueExtent(), other times only to < BlkValueExtent(). Is this buggy?

See:
	IT_CharacterLength - prototype single text loop
	INDEXED_TEXT_TY_Compare - prototype multi text loop
	
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

Include (-

#ifdef TARGET_ZCODE;
	Constant HPIT_HEADER_SIZE = 8;
#ifnot;
	Constant HPIT_HEADER_SIZE = 16;
#endif;

-) after "Definitions.i6t".

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

	INDEXED_TEXT_TY_Cast_Write( indt, buff + offs, len );

	.Failed;
	if (freebuff) VM_FreeMemory(freebuff);

	return indt;
];

[ INDEXED_TEXT_TY_Cast_Write indt buff len	i blockaddr dataaddr maxdataaddr val;
	blockaddr = indt;
	
	while ( i < len )
	{
		if ( blockaddr == NULL )
		{
			"*** BlkValueWrite: writing to index out of range: ", i, " in ", indt, " ***";
		}
		
		dataaddr = blockaddr + HPIT_HEADER_SIZE;
		maxdataaddr = blockaddr + BlkSize( blockaddr );
		
		while ( dataaddr < maxdataaddr && i < len )
		{
			#ifdef TARGET_ZCODE;
				dataaddr->0 = buff->i;
				dataaddr = dataaddr + 1;
			#ifnot;
				val = buff-->i;
				dataaddr->0 = ( val / 256 ) % 256;
				dataaddr->1 = val % 256;
				dataaddr = dataaddr + 2;
			#endif;
			i = i + 1;
		}
		
		blockaddr = blockaddr-->BLK_NEXT;
	}
];

-) instead of "Casting" in "IndexedText.i6t".

[ Comparison ]
Include (-

[ INDEXED_TEXT_TY_Compare textA textB	lenA lenB i posA posB maxA maxB valA valB;
	lenA = BlkValueExtent( textA );
	lenB = BlkValueExtent( textB );
	if ( lenA ~= lenB )
	{
		return lenA - lenB;
	}
	
	! Initial blocks
	posA = textA + HPIT_HEADER_SIZE;
	maxA = textA + BlkSize( textA );
	posB = textB + HPIT_HEADER_SIZE;
	maxB = textB + BlkSize( textB );
	
	while ( i < lenA )
	{
		while ( i < lenA && posA < maxA && posB < maxB )
		{
			#ifdef TARGET_ZCODE;
				valA = posA->0;
				valB = posB->0;
				posA = posA + 1;
				posB = posB + 1;
			#ifnot;
				valA = (posA->0) * 256 + posA->1;
				valB = (posB->0) * 256 + posB->1;
				posA = posA + 2;
				posB = posB + 2;
			#endif;
			if ( valA ~= valB ) return valA - valB;
			if ( valA == 0 ) return 0;
			i = i + 1;
		}
		
		! Reached the end of block A
		if ( posA == maxA )
		{
			textA = textA-->BLK_NEXT;
			posA = textA + HPIT_HEADER_SIZE;
			maxA = textA + BlkSize( textA );
		}
		! Reached the end of block B
		if ( posB == maxB )
		{
			textB = textB-->BLK_NEXT;
			posB = textB + HPIT_HEADER_SIZE;
			maxB = textB + BlkSize( textB );
		}
	}
];

[ INDEXED_TEXT_TY_Distinguish indtleft indtright;
	if (INDEXED_TEXT_TY_Compare(indtleft, indtright) == 0) rfalse;
	rtrue;
];

-) instead of "Comparison" in "IndexedText.i6t".

[ Skipping Hashing - is it ever used? ]

[ Printing ]

Include (-

[ INDEXED_TEXT_TY_Say indt	i len blockaddr dataaddr maxdataaddr ch;
	if ((indt==0) || (BlkType(indt) ~= INDEXED_TEXT_TY)) return;
	
	blockaddr = indt;
	len = BlkValueExtent( indt );
	
	while ( i < len )
	{
		dataaddr = blockaddr + HPIT_HEADER_SIZE;
		maxdataaddr = blockaddr + BlkSize( blockaddr );
		
		while ( dataaddr < maxdataaddr && i < len )
		{
			#ifdef TARGET_ZCODE;
				ch = dataaddr->0;
				dataaddr = dataaddr + 1;
			#ifnot;
				ch = (dataaddr->0) * 256 + dataaddr->1;
				dataaddr = dataaddr + 2;
			#endif;
			if ( ch == 0 )
			{
				return;
			}
			#ifdef TARGET_ZCODE;
				print (char) ch;
			#ifnot; ! TARGET_ZCODE
				glk_put_char_uni(ch);
			#endif;
			i = i + 1;
		}
		
		blockaddr = blockaddr-->BLK_NEXT;
	}
];

-) instead of "Printing" in "IndexedText.i6t".

[ Serialisation ]

Include (-

[ INDEXED_TEXT_TY_WriteFile indt	i len blockaddr dataaddr maxdataaddr ch;
	print "S";
	
	blockaddr = indt;
	len = BlkValueExtent( indt );
	
	while ( i < len )
	{
		dataaddr = blockaddr + HPIT_HEADER_SIZE;
		maxdataaddr = blockaddr + BlkSize( blockaddr );
		
		while ( dataaddr < maxdataaddr && i < len )
		{
			#ifdef TARGET_ZCODE;
				ch = dataaddr->0;
				dataaddr = dataaddr + 1;
			#ifnot;
				ch = (dataaddr->0) * 256 + dataaddr->1;
				dataaddr = dataaddr + 2;
			#endif;
			if ( ch == 0 )
			{
				jump End;
			}
			print ch, ",";
			i = i + 1;
		}
		
		blockaddr = blockaddr-->BLK_NEXT;
	}
	.End;
	print "0;";
];

-) instead of "Serialisation" in "IndexedText.i6t".

[ Skipping Unserialisation - for now ]

[ Recognition-only-GPR ]

Include (-

[ INDEXED_TEXT_TY_ROGPR indt	i len blockaddr dataaddr maxdataaddr ch bdm own wpos wa wl;
	if (indt == 0) return GPR_FAIL;
	
	bdm = true; own = wn;
	blockaddr = indt;
	len = BlkValueExtent( indt );
	
	while ( i < len )
	{
		dataaddr = blockaddr + HPIT_HEADER_SIZE;
		maxdataaddr = blockaddr + BlkSize( blockaddr );
		
		while ( dataaddr < maxdataaddr && i < len )
		{
			#ifdef TARGET_ZCODE;
				ch = dataaddr->0;
				dataaddr = dataaddr + 1;
			#ifnot;
				ch = (dataaddr->0) * 256 + dataaddr->1;
				dataaddr = dataaddr + 2;
			#endif;

			if (ch == 32 or 9 or 10 or 0) {
				if (bdm) continue;
				bdm = true;
				if (wpos ~= wl) return GPR_FAIL;
				if (ch == 0) jump End;
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
			
			i = i + 1;
		}
		
		blockaddr = blockaddr-->BLK_NEXT;
	}
	
	.End;
	if (wn == own) return GPR_FAIL; ! Progress must be made to avoid looping
	return GPR_PREPOSITION;
];

-) instead of "Recognition-only-GPR" in "IndexedText.i6t".

[ Skipping Blobs etc - for now ]

[ Replace Text ]

[ Character Length ]

Include (-

[ IT_CharacterLength indt	i len blockaddr dataaddr maxdataaddr ch;
	if ((indt==0) || (BlkType(indt) ~= INDEXED_TEXT_TY)) return 0;
	
	blockaddr = indt;
	len = BlkValueExtent( indt );
	
	while ( i < len )
	{
		dataaddr = blockaddr + HPIT_HEADER_SIZE;
		maxdataaddr = blockaddr + BlkSize( blockaddr );
		
		while ( dataaddr < maxdataaddr && i < len )
		{
			#ifdef TARGET_ZCODE;
				ch = dataaddr->0;
				dataaddr = dataaddr + 1;
			#ifnot;
				ch = (dataaddr->0) * 256 + dataaddr->1;
				dataaddr = dataaddr + 2;
			#endif;
			if ( ch == 0 )
			{
				return i;
			}
			i = i + 1;
		}
		
		blockaddr = blockaddr-->BLK_NEXT;
	}
	return len;
];

[ INDEXED_TEXT_TY_Empty indt;
	if ((indt==0) || (BlkType(indt) ~= INDEXED_TEXT_TY)) rfalse;
	if (IT_CharacterLength(indt) == 0) rtrue;
	rfalse;
];

-) instead of "Character Length" in "IndexedText.i6t".

High Performance Indexed Text ends here.