Version 1/190924 of Better Flex (for Glulx only) by Dannii Willis begins here.

"Better performance for the Flex/Block value systems using Glulx's native malloc features"



Chapter - Replacing the Flex system

Include (-
Constant BLK_HEADER_N = 0;
Constant BLK_HEADER_FLAGS = 1;
Constant BLK_FLAG_MULTIPLE = $$00000001;
Constant BLK_FLAG_16_BIT   = $$00000010;
Constant BLK_FLAG_WORD     = $$00000100;
Constant BLK_FLAG_RESIDENT = $$00001000;
Constant BLK_FLAG_TRUNCMULT = $$00010000;
Constant BLK_HEADER_KOV = 1;
Constant BLK_HEADER_RCOUNT = 2;
Constant BLK_LENGTH = 3;

Constant BLK_DATA_OFFSET = 4 * WORDSIZE;
-) instead of "Blocks" in "Flex.i6t".

Include (- -) instead of "The Heap" in "Flex.i6t".

Include (-
[ HeapInitialise; ];
-) instead of "Initialisation" in "Flex.i6t".

Include (- -) instead of "Net Free Space" in "Flex.i6t".

Include (-
[ HeapDebug;
    print "With the Better Flex extension, the heap is managed by the VM.";
];
-) instead of "Make Space" in "Flex.i6t".

Include (-
[ FlexAllocate size kov flags
    block fullsize;

    fullsize = BLK_DATA_OFFSET + size;
    block = VM_AllocateMemory( fullsize );
    if ( block == 0 ) FlexError( "malloc failed" );
	
    @mzero fullsize block;

    block->BLK_HEADER_N = 1; ! Fudge the size
	block->BLK_HEADER_FLAGS = flags;
	block-->BLK_HEADER_KOV = KindAtomic( kov );
	block-->BLK_HEADER_RCOUNT = 1;
    block-->BLK_LENGTH = fullsize;

	return block;
];
-) instead of "Block Allocation" in "Flex.i6t".

Include (- -) instead of "Merging" in "Flex.i6t".

Include (- -) instead of "Recutting" in "Flex.i6t".

Include (-
[ FlexFree block;
	if ( block == 0 ) return;
	if ( ( block->BLK_HEADER_FLAGS ) & BLK_FLAG_RESIDENT ) return;
	if ( ( block->BLK_HEADER_N ) & $80 ) return; ! not a flexible block at all

    if ( block >= HDR_ENDMEM-->0 )
    {
	    VM_FreeMemory( block );
    }
];
-) instead of "Deallocation" in "Flex.i6t".

Include (-
[ BFFlexResize block newsize
    flags newblock newblocksize oldsize;

    if ( block == 0 ) FlexError( "failed resizing null block" );
	flags = block->BLK_HEADER_FLAGS;
	if ( flags & BLK_FLAG_MULTIPLE == 0 ) FlexError( "failed resizing inextensible block" );

    newblocksize = BLK_DATA_OFFSET + newsize;
    newblock = VM_AllocateMemory( newblocksize );  
    if ( newblock == 0 ) FlexError( "resizing failed: malloc failed" );

    @mzero newblocksize newblock;
    oldsize = block-->BLK_LENGTH;
    @mcopy oldsize block newblock;
    newblock-->BLK_LENGTH = newblocksize;

    if ( block >= HDR_ENDMEM-->0 )
    {
        VM_FreeMemory( block );
    }
    return newblock;
];
-) instead of "Resizing" in "Flex.i6t".

Include (-
[ FlexSize block; ! Size of an individual block, including header
	if ( block == 0 ) return 0;
	return block-->BLK_LENGTH;
];

[ FlexTotalSize block;
	if ( block == 0 ) return 0;
	return block-->BLK_LENGTH - BLK_DATA_OFFSET;
];
-) instead of "Block Size" in "Flex.i6t".

Include (- -) instead of "Debugging Routines" in "Flex.i6t".



Chapter - Replacing the Block Values system

Include (-
[ BlkValueLBCapacity bv  long_block array_size_in_bytes entry_size_in_bytes flags;
	long_block = BlkValueGetLongBlock(bv);
	if (long_block == 0) return 0;

	array_size_in_bytes = FlexTotalSize(long_block);

	flags = long_block->BLK_HEADER_FLAGS;
	entry_size_in_bytes = 1;
	if (flags & BLK_FLAG_16_BIT) entry_size_in_bytes = 2;
	else if (flags & BLK_FLAG_WORD) entry_size_in_bytes = WORDSIZE;

	return array_size_in_bytes / entry_size_in_bytes;
];

[ BlkValueSetLBCapacity bv new_capacity  long_block flags entry_size_in_bytes new_long_block;
	if (bv == 0) rfalse;
	BlkMakeMutable(bv);
	long_block = BlkValueGetLongBlock(bv);
	if (long_block == 0) rfalse;

	flags = long_block->BLK_HEADER_FLAGS;
	entry_size_in_bytes = 1;
	if (flags & BLK_FLAG_16_BIT) entry_size_in_bytes = 2;
	else if (flags & BLK_FLAG_WORD) entry_size_in_bytes = WORDSIZE;

	new_long_block = BFFlexResize(long_block, new_capacity*entry_size_in_bytes);
	bv-->0 = new_long_block;
	rtrue;
];
-) instead of "Long Block Capacity" in "BlockValues.i6t".

Include (-
[ BlkValueRead from pos do_not_indirect
	long_block flags entry_size_in_bytes seek_byte_position;

	if ( from == 0 ) rfalse;
	if ( do_not_indirect )
		long_block = from;
	else
		long_block = BlkValueGetLongBlock( from );

	flags = long_block->BLK_HEADER_FLAGS;
	entry_size_in_bytes = 1;
	if ( flags & BLK_FLAG_16_BIT )
        entry_size_in_bytes = 2;
	else if ( flags & BLK_FLAG_WORD )
        entry_size_in_bytes = WORDSIZE;

	seek_byte_position = pos * entry_size_in_bytes;

    if ( ( seek_byte_position >= 0 ) && ( seek_byte_position < FlexTotalSize( long_block ) ) )
    {
        long_block = long_block + BLK_DATA_OFFSET + seek_byte_position;
        switch ( entry_size_in_bytes )
        {
            1: return long_block->0;
            2: return ( long_block->0 ) * 256 + ( long_block->1 );
            4: return long_block-->0;
        }
    }
	"*** BlkValueRead: reading from index out of range: ", pos, " in ", from, " ***";
];

[ BlkValueWrite to pos val do_not_indirect
	long_block flags entry_size_in_bytes seek_byte_position;

	if ( to == 0 ) rfalse;
	if ( do_not_indirect )
		long_block = to;
	else {
		BlkMakeMutable( to );
		long_block = BlkValueGetLongBlock( to );
	}

	flags = long_block->BLK_HEADER_FLAGS;
	entry_size_in_bytes = 1;
	if ( flags & BLK_FLAG_16_BIT )
        entry_size_in_bytes = 2;
	else if ( flags & BLK_FLAG_WORD )
        entry_size_in_bytes = WORDSIZE;

	seek_byte_position = pos * entry_size_in_bytes;

    if ( ( seek_byte_position >= 0 ) && ( seek_byte_position < FlexTotalSize( long_block ) ) )
    {
        long_block = long_block + BLK_DATA_OFFSET + seek_byte_position;
        switch ( entry_size_in_bytes )
        {
            1: long_block->0 = val;
            2: long_block->0 = ( val / 256 ) % 256;
               long_block->1 = val % 256;
            4: long_block-->0 = val;
        }
        return;
    }
	"*** BlkValueWrite: writing to index out of range: ", pos, " in ", to, " ***";
];
-) instead of "Long Block Array Access" in "BlockValues.i6t".

Include (-
[ BlkValueSeekZeroEntry from
	long_block flags entry_size_in_bytes
	addr from_addr to_addr;

	if ( from == 0 ) return -1;
	long_block = BlkValueGetLongBlock( from );

	flags = long_block->BLK_HEADER_FLAGS;
	entry_size_in_bytes = 1;
	if ( flags & BLK_FLAG_16_BIT )
        entry_size_in_bytes = 2;
	else if ( flags & BLK_FLAG_WORD )
        entry_size_in_bytes = WORDSIZE;

    from_addr = long_block + BLK_DATA_OFFSET;
    to_addr = from_addr + FlexTotalSize( long_block );
    switch ( entry_size_in_bytes )
    {
        1:
            for ( addr = from_addr: addr < to_addr: addr++ )
                if ( addr->0 == 0 )
                    return addr - from_addr;
        2:
            for  (addr = from_addr: addr < to_addr: addr = addr + 2 )
                if ( ( addr->0 == 0 ) && ( addr->1 == 0 ) )
                    return ( addr - from_addr ) / 2;
        4:
            for ( addr = from_addr: addr < to_addr: addr = addr + 4 )
                if ( addr-->0 == 0 )
                    return ( addr - from_addr ) / 4;
    }
	return -1;
];
-) instead of "First Zero Entry" in "BlockValues.i6t".

Include (-
[ BlkValueMassCopyEntries to_bv from_bv no_entries_to_copy
	from_long_block from_addr from_bytes_left from_header_size_in_bytes
	to_long_block to_addr to_bytes_left to_header_size_in_bytes
	bytes_to_copy flags entry_size_in_bytes min;

	BlkMakeMutable(to_bv);

	from_long_block = BlkValueGetLongBlock(from_bv);
	to_long_block = BlkValueGetLongBlock(to_bv);

	flags = from_long_block->BLK_HEADER_FLAGS;
	entry_size_in_bytes = 1;
	if (flags & BLK_FLAG_16_BIT)
        entry_size_in_bytes = 2;
	else if (flags & BLK_FLAG_WORD)
        entry_size_in_bytes = WORDSIZE;

	if ((flags & (BLK_FLAG_MULTIPLE + BLK_FLAG_TRUNCMULT)) &&
		(BlkValueSetLBCapacity(to_bv, no_entries_to_copy) == false))
		BlkValueError("copy resizing failed");

	if (flags & BLK_FLAG_MULTIPLE)
        from_header_size_in_bytes = BLK_DATA_MULTI_OFFSET;
	else
        from_header_size_in_bytes = BLK_DATA_OFFSET;
	flags = to_long_block->BLK_HEADER_FLAGS;
	if (flags & BLK_FLAG_MULTIPLE)
        to_header_size_in_bytes = BLK_DATA_MULTI_OFFSET;
	else
        to_header_size_in_bytes = BLK_DATA_OFFSET;

	from_addr = from_long_block + from_header_size_in_bytes;
	from_bytes_left = FlexSize(from_long_block) - from_header_size_in_bytes;
	to_addr = to_long_block + to_header_size_in_bytes;
	to_bytes_left = FlexSize(to_long_block) - to_header_size_in_bytes;

	bytes_to_copy = entry_size_in_bytes*no_entries_to_copy;
	while (true)
    {
        if ( from_bytes_left == 0 )
        {
            BlkValueError("copy destination exhausted");
        }
        else if (to_bytes_left == 0)
        {
            BlkValueError("copy source exhausted");
        }
        else
        {
            min = from_bytes_left;
            if (to_bytes_left < min)
                min = to_bytes_left;
			if (bytes_to_copy <= min)
            {
				Memcpy(to_addr, from_addr, bytes_to_copy);
				return;
			}
			Memcpy(to_addr, from_addr, min);
			bytes_to_copy = bytes_to_copy - min;
			from_addr = from_addr + min;
			from_bytes_left = from_bytes_left - min;
			to_addr = to_addr + min;
			to_bytes_left = to_bytes_left - min;
        }
	}
];
-) instead of "Mass Copy Entries" in "BlockValues.i6t".

Include (-
[ BlkValueMassCopyFromArray to_bv from_array from_entry_size no_entries_to_copy
	to_long_block to_addr to_entries_left to_header_size to_entry_size
	flags;

	BlkMakeMutable(to_bv);

	to_long_block = BlkValueGetLongBlock(to_bv);

	flags = to_long_block->BLK_HEADER_FLAGS;
	to_entry_size = 1;
	if (flags & BLK_FLAG_16_BIT)
        to_entry_size = 2;
	else if (flags & BLK_FLAG_WORD)
        to_entry_size = WORDSIZE;

	if ((flags & (BLK_FLAG_MULTIPLE + BLK_FLAG_TRUNCMULT)) &&
		(BlkValueSetLBCapacity(to_bv, no_entries_to_copy) == false))
		BlkValueError("copy resizing failed");

	if (flags & BLK_FLAG_MULTIPLE)
        to_header_size = BLK_DATA_MULTI_OFFSET;
	else
        to_header_size = BLK_DATA_OFFSET;

	to_addr = to_long_block + to_header_size;
	to_entries_left = (FlexSize(to_long_block) - to_header_size)/to_entry_size;

	while (no_entries_to_copy > to_entries_left) {
		Arrcpy(to_addr, to_entry_size, from_array, from_entry_size, to_entries_left);
		no_entries_to_copy = no_entries_to_copy - to_entries_left;
		from_array = from_array + to_entries_left*from_entry_size;
	}
	if (no_entries_to_copy > 0) {
		Arrcpy(to_addr, to_entry_size, from_array, from_entry_size, no_entries_to_copy);
	}
];
-) instead of "Mass Copy From Array" in "BlockValues.i6t".

Include (-
[ BlkValueFree bv kovs d;
	if (bv == 0) return;

	! Dispose of any data in the long block
	kovs = KOVSupportFunction(BlkValueWeakKind(bv), "impossible deallocation");
	BlkValueDestroyPrimitive(bv, kovs);

	! Free any heap memory occupied by the short block
    FlexFree( bv - BLK_DATA_OFFSET );
];
-) instead of "Freeing" in "BlockValues.i6t".

Include (-
[ BlkDebugAddress addr flag d;
	if (flag) { print "###"; return; }

	d = addr - blockv_stack;
	if ((d >= 0) && (d <= WORDSIZE*BLOCKV_STACK_SIZE)) {
		print "s+", (BlkPrintHexadecimal) d;
		d = addr - I7SFRAME;
		print "=f"; if (d >= 0) print "+"; print d;
		return;
	}
	
	d = addr - BLK_DATA_OFFSET;
	if ( d >= HDR_ENDMEM-->0 )
    {
		print "h+", (BlkPrintHexadecimal) d;
		return;
	}

	print (BlkPrintHexadecimal) addr;
];
-) instead of "Printing Memory Addresses" in "BlockValues.i6t".



Better Flex ends here.
