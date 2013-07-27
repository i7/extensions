Version 4/130712 of Dynamic Tables by Jesse McGrew begins here.

"Provides a way to change the capacity of a table during the game."

Chapter 1 - New stuff

To change (T - table name) to have (N - number) row/rows: (- DT_ResizeTable({T}, {N}); -).

To decide which number is the original number of rows in (T - table name): (- DT_OrigSize({T}) -).

To decide which table name is a new table with columns (CS - list of table columns) and (N - number) blank row/rows: (- DT_NewTable({N}, {-pointer-to:CS}); -).

To deallocate (T - table name): (- DT_FreeTable({T}); -).

To decide whether (T - table name) was dynamically created: (- (DT_IsFullyDynamic({T})) -).

Include (-
! Force the heap to be enabled for Dynamic Tables.
#ifndef MEMORY_HEAP_SIZE;
Constant MEMORY_HEAP_SIZE = 4096;
#endif;
-) before "Flex.i6t".

Include (-
! A column flag to indicate that the table has been resized.

Constant TB_COLUMN_RESIZED $8000;

! Normally, word -->2 of a column contains the index into TB_Blanks where the column's
! blank bits are stored (unless the TB_COLUMN_NOBLANKBITS flag is set). But since we can't
! resize TB_Blanks when adding rows to the table, we need a different scheme.

! For resized columns, word -->2 points instead to the table's information block -- the same
! block for every column -- which contains fields with the offsets listed below.
! It includes some values from the original (statically allocated) table, which are used to
! return the table to its statically allocated state if it's ever changed back to the original size.

Constant DT_TIB_ORIGSIZE 0;	! the number of rows originally in the table, or 0 for a fully dynamic table
Constant DT_TIB_CIBSTART 1;	! the column info blocks start here

! The column information blocks are part of the table information block. Each column's block
! has a set number of words (DT_CIBSIZE), so the block for column N starts at offset
! DT_TIB_CIBSTART+((N-1)*DT_CIBSIZE) -- recall that column numbers start at 1.

Constant DT_CIBSIZE 2;

Constant DT_CIB_NEWBLANKS 0;	! address of the dynamically allocated blank bits (if applicable)
Constant DT_CIB_ORIGDATA 1;	! address of the original (static) column data, or 0 for a fully dynamic table

[ DT_Alloc s  rv;
	! Pretend we're allocating indexed text, since BlkFree demands a valid KOV.
	rv = BlkAllocate(s, INDEXED_TEXT_TY, 0);
	if (rv) return rv + BLK_DATA_OFFSET;
	print "*** Failed to allocate ", s, " bytes ***^";
	rfalse;
];

[ DT_Free b; if (b) BlkFree(b - BLK_DATA_OFFSET); ];

[ DT_CopyBytes num src dest  i;
	#ifdef TARGET_GLULX;
	@gestalt 6 0 i;
	if (i) @mcopy num src dest;
	else for ( i=0: i<num: i++ ) src->i = dest->i;
	#ifnot;
	@copy_table src dest num;
	#endif;
];

[ DT_ZeroBytes num loc  i;
	#ifdef TARGET_GLULX;
	@gestalt 6 0 i;
	if (i) @mzero num loc;
	else for ( i=0: i<num: i++ ) loc->i = 0;
	#ifnot;
	@copy_table loc 0 num;
	#endif;
];

! implements the phrase "change T to have N rows"
[ DT_ResizeTable tab newsize  cursize i;
	! don't bother if the new size is no different, or if it's unreasonable
	cursize = TableRows(tab);
	if (newsize == cursize || newsize < 0) return;
	
	! delegate to a more specific routine
	if (((tab-->1)-->1) & TB_COLUMN_RESIZED) {
		if (newsize == ((tab-->1)-->2)-->DT_TIB_ORIGSIZE)
			DT_DynamicToStatic(tab);
		else
			DT_ResizeDynamic(tab, newsize);
	} else {
		DT_StaticToDynamic(tab, newsize);
	}

	newsize = TableRows(tab);
	for ( i=cursize+1: i<=newsize: i++ ) TableBlankOutRow(tab, i);
];

! implements the phrase "original number of rows in T"
[ DT_OrigSize tab;
	if (((tab-->1)-->1) & TB_COLUMN_RESIZED)
		return ((tab-->1)-->2)-->DT_TIB_ORIGSIZE;
	else
		return TableRows(tab);
];

! finds the address of the blank bits for a particular table and column, whether or not it's been resized
[ DT_FindBlankBits tab col  tib cib;
	if (((tab-->col)-->1) & TB_COLUMN_RESIZED) {
		tib = (tab-->col)-->2;
		cib = tib + (DT_TIB_CIBSTART * WORDSIZE);
		cib = cib + ((DT_CIBSIZE * (col - 1)) * WORDSIZE);
		return cib-->DT_CIB_NEWBLANKS;
	} else
		return TB_Blanks + ((tab-->col)-->2);
];

! converts a static table to a dynamic one
[ DT_StaticToDynamic tab newsize  rv nc s tib cib i bbs bba obbs;
	! allocate TIB
	nc = tab-->0;
	s = DT_TIB_CIBSTART;		! # TIB header words
	s = s + (nc * DT_CIBSIZE);	! # CIB words
	s = s * WORDSIZE;		! convert words to bytes
	bbs = (newsize + 7) / 8;		! # blank bytes for each blankable column
	for ( i=1: i<=nc: i++ ) {
		if (~~(((tab-->i)-->1) & TB_COLUMN_NOBLANKBITS))
			s = s + bbs;
	}
	tib = DT_Alloc(s); if (~~tib) rfalse;

	! fill it in
	tib-->DT_TIB_ORIGSIZE = TableRows(tab);
	cib = tib + (DT_TIB_CIBSTART * WORDSIZE);
	bba = cib + (nc * DT_CIBSIZE * WORDSIZE);
	obbs = (((tab-->1)-->0) + 7) / 8;	! # blank bytes in old table
	for ( i=1: i<=nc: i++ ) {
		! fill in CIB
		if (~~(((tab-->i)-->1) & TB_COLUMN_NOBLANKBITS)) {
			cib-->DT_CIB_NEWBLANKS = bba;
			DT_CopyBlanks(TB_Blanks + ((tab-->i)-->2), obbs, bba, bbs);
			bba = bba + bbs;
		} else
			cib-->DT_CIB_NEWBLANKS = 0;
		cib-->DT_CIB_ORIGDATA = tab-->i;

		! allocate new column
		rv = DT_CopyColumn(tab-->i, newsize, 0, tib);
		if (~~rv) { DT_BackOutDyn(tab, tib, i - 1); rfalse; }
		tab-->i = rv;

		! advance to next CIB
		cib = cib + (DT_CIBSIZE * WORDSIZE);
	}

	! success
	rtrue;
];

! clean up after DT_StaticToDynamic and DT_ResizeDynamic when memory has run out
[ DT_BackOutDyn tab tib copiedcols  i j col ocol;
	for ( i=1: i<=copiedcols: i++ ) {
		! move block references back from the copied column before freeing values
		ocol = tib-->(DT_TIB_CIBSTART + (DT_CIBSIZE * (i - 1)) + DT_CIB_ORIGDATA);
		col = tab-->i;
		if ((col-->1) & TB_COLUMN_ALLOCATED) {
			for ( j=3: j<=col-->0: j++ ) {
				ocol-->j = col-->j;
				col-->j = 0;
			}
		}
		DT_FreeColumnValues(tab, col); DT_Free(col);
		tab-->i = ocol;
	}
	DT_Free(tib);
];

! converts a dynamic table to a static one
[ DT_DynamicToStatic tab  tib cib cursize newsize nc i bbs obbs dcol scol;
	cursize = (tab-->1)-->0;
	tib = (tab-->1)-->2;
	newsize = tib-->DT_TIB_ORIGSIZE;

	! copy data into static table
	nc = tab-->0;
	cib = tib + (DT_TIB_CIBSTART * WORDSIZE);
	bbs = (newsize + 7) / 8;
	obbs = (cursize + 7) / 8;
	for ( i=1: i<=nc: i++ ) {
		dcol = tab-->i;
		scol = cib-->DT_CIB_ORIGDATA;

		! copy blanks
		if (~~(((dcol)-->1) & TB_COLUMN_NOBLANKBITS))
			DT_CopyBlanks(cib-->DT_CIB_NEWBLANKS, obbs, TB_Blanks + (scol-->2), bbs);

		! copy values
		DT_CopyColumn(dcol, newsize, scol);
		DT_FreeColumnValues(tab, dcol);
		DT_Free(dcol);
		tab-->i = scol;

		! advance to next CIB
		cib = cib + (DT_CIBSIZE * WORDSIZE);
	}

	! success
	DT_Free(tib);
	rtrue;
];

! changes the size of a table that's already dynamic
[ DT_ResizeDynamic tab newsize  nc s bbs bba obbs tib cib otib ocib i rv;
	! allocate new TIB
	nc = tab-->0;
	s = DT_TIB_CIBSTART;		! # TIB header words
	s = s + (nc * DT_CIBSIZE);	! # CIB words
	s = s * WORDSIZE;		! convert words to bytes
	bbs = (newsize + 7) / 8;		! # blank bytes for each blankable column
	for ( i=1: i<=nc: i++ ) {
		if (~~(((tab-->i)-->1) & TB_COLUMN_NOBLANKBITS))
			s = s + bbs;
	}
	tib = DT_Alloc(s); if (~~tib) rfalse;

	! fill it in
	otib = (tab-->1)-->2;
	ocib = otib + (DT_TIB_CIBSTART * WORDSIZE);
	tib-->DT_TIB_ORIGSIZE = otib-->DT_TIB_ORIGSIZE;
	cib = tib + (DT_TIB_CIBSTART * WORDSIZE);
	bba = cib + (nc * DT_CIBSIZE * WORDSIZE);
	obbs = (((tab-->1)-->0) + 7) / 8;	! # blank bytes in old table
	for ( i=1: i<=nc: i++ ) {
		! fill in CIB
		if (~~(((tab-->i)-->1) & TB_COLUMN_NOBLANKBITS)) {
			cib-->DT_CIB_NEWBLANKS = bba;
			DT_CopyBlanks(ocib-->DT_CIB_NEWBLANKS, obbs, bba, bbs);
			bba = bba + bbs;
		} else
			cib-->DT_CIB_NEWBLANKS = 0;

		! save a pointer to the old *dynamic* column in case we need to back out.
		! it'll be changed to the static column later if we succeed.
		cib-->DT_CIB_ORIGDATA = tab-->i;

		! allocate new column
		rv = DT_CopyColumn(tab-->i, newsize, 0, tib);
		if (~~rv) { DT_BackOutDyn(tab, tib, i - 1); rfalse; }
		tab-->i = rv;

		! advance to next CIB
		cib = cib + (DT_CIBSIZE * WORDSIZE);
		ocib = ocib + (DT_CIBSIZE * WORDSIZE);
	}

	! success: now we can fix the origdata pointers
	cib = tib + (DT_TIB_CIBSTART * WORDSIZE);
	ocib = otib + (DT_TIB_CIBSTART * WORDSIZE);
	for ( i=1: i<=nc: i++ ) {
		! free the old dynamic column
		rv = cib-->DT_CIB_ORIGDATA;
		DT_FreeColumnValues(tab, rv);
		DT_Free(rv);

		! fix the pointer
		cib-->DT_CIB_ORIGDATA = ocib-->DT_CIB_ORIGDATA;

		! advance to next CIB
		cib = cib + (DT_CIBSIZE * WORDSIZE);
		ocib = ocib + (DT_CIBSIZE * WORDSIZE);
	}
	DT_Free(otib);
	rtrue;
];

[ DT_CopyBlanks src sbytes dest dbytes  size;
	if (dbytes > sbytes) {
		DT_CopyBytes(sbytes, src, dest);
		dest = dest + sbytes;
		dbytes = dbytes - sbytes;
		DT_ZeroBytes(dbytes, dest);		
	} else
		DT_CopyBytes(dbytes, src, dest);
];

[ DT_CopyColumn col newsize rv bbptr  i kov tc dest oldsize;
	if (rv == 0) {
		! allocate new column
		i = (newsize + COL_HSIZE + 1) * WORDSIZE;
		rv = DT_Alloc(i); if (~~rv) rfalse;
		rv-->0 = newsize + COL_HSIZE;
		rv-->1 = (col-->1) | TB_COLUMN_RESIZED;
		rv-->2 = bbptr;
	}

	kov = UNKNOWN_TY;
	if ((col-->1) & TB_COLUMN_ALLOCATED) {
		tc = (col-->1) & TB_COLUMN_NUMBER;
		kov = TC_KOV(tc);
	}

	oldsize = (col-->0) - COL_HSIZE;

	if (kov == UNKNOWN_TY) {
		if (oldsize < newsize) i = oldsize * WORDSIZE; else i = newsize * WORDSIZE;
		dest = rv + ((COL_HSIZE + 1) * WORDSIZE);
		col = col + ((COL_HSIZE + 1) * WORDSIZE);
		DT_CopyBytes(i, col, dest);
		if (newsize > oldsize) {
			i = (newsize - oldsize) * WORDSIZE;
			dest = dest + (oldsize * WORDSIZE);
			DT_ZeroBytes(i, dest);
		}
	} else {
		for ( i=1: i<=newsize: i++ ) {
			if (i <= oldsize) {
				! new column takes ownership of the pointer
				tc = col-->(COL_HSIZE + i);
				col-->(COL_HSIZE + i) = 0;
			} else
				tc = BlkValueCreate(kov);
			rv-->(COL_HSIZE + i) = tc;
		}
	}

	return rv;
];

[ DT_FreeColumnValues tab col  kov tc i v;
	kov = UNKNOWN_TY;
	if ((col-->1) & TB_COLUMN_ALLOCATED) {
		tc = (col-->1) & TB_COLUMN_NUMBER;
		kov = TC_KOV(tc);
	}

	if (kov ~= UNKNOWN_TY) {
		tc = col-->0;
		for ( i=3: i<=tc: i++ ) {
			v = col-->i;
			if (v==0) continue;
			if (v==TABLE_NOVALUE && CheckTableEntryIsBlank(tab, col, i - 2)) continue;
			BlkFree(v);
			col-->i = 0;
		}
	}
];

! implements the phrase "a new table with columns {C} and N blank rows"
[ DT_NewTable nrows collist  nc i rv tib cib s bbs bba tc kov fl;
	nc = LIST_OF_TY_GetLength(collist);

	! allocate space for table header
	s = 1 + nc;			! table header (size word + column pointers)
	
	rv = DT_Alloc(s); if (~~rv) rfalse;
	rv-->0 = nc;
	
	! allocate space for TIB
	s = DT_TIB_CIBSTART;		! # TIB header words
	s = s + (nc * DT_CIBSIZE);	! # CIB words
	s = s * WORDSIZE;		! convert words to bytes
	bbs = (nrows + 7) / 8;		! # blank bytes for each blankable column
	s = s + (bbs * nc);			! (we make every column blankable here)
	
	tib = DT_Alloc(s); if (~~tib) { DT_Free(rv); rfalse; }

	! fill in TIB
	tib-->DT_TIB_ORIGSIZE = 0;
	cib = tib + (DT_TIB_CIBSTART * WORDSIZE);
	bba = cib + (nc * DT_CIBSIZE * WORDSIZE);
	for ( i=1: i<=nc: i++ ) {
		! look up the column's KOV
		tc = LIST_OF_TY_GetItem(collist, i);
		kov = TC_KOV(tc);

		! fill in CIB
		cib-->DT_CIB_NEWBLANKS = bba;
		DT_ZeroBytes(bbs, bba);
		bba = bba + bbs;
		cib-->DT_CIB_ORIGDATA = 0;

		! allocate new column
		s = DT_Alloc((3 + nrows) * WORDSIZE);
		if (~~s) { DT_BackOutNew(rv, i - 1); rfalse; }
		rv-->i = s;

		! figure out column flags and fill in column header
		tc = tc | TB_COLUMN_RESIZED;
		if (kov == NUMBER_TY or TIME_TY || kov >= 100)
			tc = tc | TB_COLUMN_SIGNED;
		if (kov == UNDERSTANDING_TY)
			tc = tc | TB_COLUMN_TOPIC;
		if (kov == NUMBER_TY or TIME_TY or LIST_OF_TY or INDEXED_TEXT_TY || kov >= 100)
			tc = tc | TB_COLUMN_CANEXCHANGE;
		if (KOVIsBlockValue(kov))
			tc = tc | TB_COLUMN_ALLOCATED;
		s-->0 = 2 + nrows;
		s-->1 = tc;
		s-->2 = tib;

		! advance to next CIB
		cib = cib + (DT_CIBSIZE * WORDSIZE);
	}

	! leave the table blank
	for (i=1: i<=nrows: i++) TableBlankOutRow(rv, i);

	return rv;
];

! clean up after DT_NewTable when memory has run out
[ DT_BackOutNew tab donecols  i;
	for ( i=1: i<=donecols: i++ )
		DT_Free(tab-->i);
	DT_Free(tab);
];

[ DT_IsFullyDynamic tab;
	if (tab == 0) rfalse;
	if (((tab-->1)-->1 & TB_COLUMN_RESIZED) == 0) rfalse;
	if (((tab-->1)-->2)-->DT_TIB_ORIGSIZE ~= 0) rfalse;
	rtrue;
];

! implements the phrase "deallocate T"
[ DT_FreeTable tab  i nc tib;
	if (DT_IsFullyDynamic(tab)) {
		nc = tab-->0;
		tib = (tab-->1)-->2;
		for (i=1: i<=nc: i++) {
			DT_FreeColumnValues(tab, tab-->i);
			DT_Free(tab-->i);
		}
		DT_Free(tib);
		DT_Free(tab);
		rtrue;
	}
	print "*** Tried to deallocate a table that wasn't dynamically created ***^";
	rfalse;
];
-) after "Flex.i6t".

Chapter 2 - Library replacements

Section 1 - Using the dynamic blank bits

[We need to change the parts of Tables.i6t that directly use TB_Blanks to call DT_FindBlankBits instead.]

Include (-
[ CheckTableEntryIsBlank tab col row i at oldv flags;
	if (col >= 100) col = TableFindCol(tab, col);
	if (col == 0) rtrue;
	if ((tab-->col)-->(row+COL_HSIZE) ~= TABLE_NOVALUE) {
		print "*** CTEIB on nonblank value ", tab, " ", col, " ", row, " ***^";
	}
	if (((tab-->col)-->1) & TB_COLUMN_NOBLANKBITS) rtrue;
	row--;
	at = DT_FindBlankBits(tab, col) + (row/8);
	if ((at->0) & (CheckTableEntryIsBlank_LU->(row%8))) rtrue;
	rfalse;
];
-) instead of "Testing Blankness" in "Tables.i6t".

Include (-
[ ForceTableEntryBlank tab col row i at oldv flags;
	if (col >= 100) col = TableFindCol(tab, col);
	if (col == 0) rtrue;
	flags = (tab-->col)-->1;
	oldv = (tab-->col)-->(row+COL_HSIZE);
	if ((flags & TB_COLUMN_ALLOCATED) && (oldv ~= 0 or TABLE_NOVALUE))
		BlkFree(oldv);
	(tab-->col)-->(row+COL_HSIZE) = TABLE_NOVALUE;
	if (flags & TB_COLUMN_NOBLANKBITS) return;
	row--;
	at = DT_FindBlankBits(tab, col) + (row/8);
	(at->0) = (at->0) | (CheckTableEntryIsBlank_LU->(row%8));
];
-) instead of "Force Entry Blank" in "Tables.i6t".

Include (-
[ ForceTableEntryNonBlank tab col row i at oldv flags tc kov j;
	if (col >= 100) col=TableFindCol(tab, col);
	if (col == 0) rtrue;
	if (((tab-->col)-->1) & TB_COLUMN_NOBLANKBITS) return;
	flags = (tab-->col)-->1;
	oldv = (tab-->col)-->(row+COL_HSIZE);
	if ((flags & TB_COLUMN_ALLOCATED) &&
		(oldv == 0 or TABLE_NOVALUE)) {
		kov = UNKNOWN_TY;
		tc = ((tab-->col)-->1) & TB_COLUMN_NUMBER;
		kov = TC_KOV(tc);
		if (kov ~= UNKNOWN_TY) {
			if (KindBaseArity(kov) > 0) i = KindAtomic(kov); else i = 0;
			(tab-->col)-->(row+COL_HSIZE) = BlkValueCreate(kov, 0, i);
		}
	}
	row--;
	at = DT_FindBlankBits(tab, col) + (row/8);
	(at->0) = (at->0) & (CheckTableEntryIsNonBlank_LU->(row%8));
];
-) instead of "Force Entry Non-Blank" in "Tables.i6t".

Include (-
[ TableSwapBlankBits tab row1 row2 col at1 at2 bit1 bit2;
	if (col >= 100) col=TableFindCol(tab, col);
	if (col == 0) rtrue;
	if (((tab-->col)-->1) & TB_COLUMN_NOBLANKBITS) return;
	row1--;
	at1 = DT_FindBlankBits(tab, col) + (row1/8);
	row2--;
	at2 = DT_FindBlankBits(tab, col) + (row2/8);
	bit1 = ((at1->0) & (CheckTableEntryIsBlank_LU->(row1%8)));
	bit2 = ((at2->0) & (CheckTableEntryIsBlank_LU->(row2%8)));
	if (bit1) bit1 = true; 
	if (bit2) bit2 = true;
	if (bit1 == bit2) return;
	if (bit1) {
		(at1->0)
			= (at1->0) & (CheckTableEntryIsNonBlank_LU->(row1%8));
		(at2->0)
			= (at2->0) | (CheckTableEntryIsBlank_LU->(row2%8));
	} else {
		(at1->0)
			= (at1->0) | (CheckTableEntryIsBlank_LU->(row1%8));
		(at2->0)
			= (at2->0) & (CheckTableEntryIsNonBlank_LU->(row2%8));
	}
];
-) instead of "Swapping Blank Bits" in "Tables.i6t".

Include (-
[ TableMoveBlankBitsDown tab row1 row2 col at atp1 bit rx bba;
	if (col >= 100) col=TableFindCol(tab, col);
	if (col == 0) rtrue;
	if (((tab-->col)-->1) & TB_COLUMN_NOBLANKBITS) return;
	row1--; row2--;
	! Read blank bit for row1:
	bba = DT_FindBlankBits(tab, col);
	at = bba + (row1/8);
	bit = ((at->0) & (CheckTableEntryIsBlank_LU->(row1%8)));
	if (bit) bit = true;
	! Loop through, setting each blank bit to the next:
	for (rx=row1:rx<row2:rx++) {
		atp1 = bba + ((rx+1)/8);
		at = bba + (rx/8);
		if ((atp1->0) & (CheckTableEntryIsBlank_LU->((rx+1)%8))) {
			(at->0)
				= (at->0) | (CheckTableEntryIsBlank_LU->(rx%8));
		} else {
			(at->0)
				= (at->0) & (CheckTableEntryIsNonBlank_LU->(rx%8));
		}
	}
	! Write bit to blank bit for row2:
	at = bba + (row2/8);
	if (bit) {
		(at->0)
			= (at->0) | (CheckTableEntryIsBlank_LU->(row2%8));
	} else {
		(at->0)
			= (at->0) & (CheckTableEntryIsNonBlank_LU->(row2%8));
	}
];
-) instead of "Moving Blank Bits Down" in "Tables.i6t".

[And here we replace PrintTableName to show something sensible for fully dynamic tables.]

Include (-
[ PrintTableName T;
	switch(T) {
{-call:Data::Tables::compile_print_table_names}
		default:
			if (DT_IsFullyDynamic(T))
				print "** Dynamically created table **";
			else
				print "** No such table **";
	}
];
-) instead of "Print Table Name" in "Tables.i6t".

Dynamic Tables ends here.

---- DOCUMENTATION ----

This extension allows the number of rows in a table to be changed at runtime. For example:

	change the Table of Ice Cream Flavors to have 31 rows;

Using that phrase, we may change the size of any table to any non-negative number of rows at any time. After resizing the table, the data that was stored in the table will still be there, the usual table phrases like "the number of rows in Table of Ice Cream Flavors" will reflect the new size, and in general the table will behave exactly as if we had defined it with 31 rows in the source code.

The only way to tell that the table has been resized at all is to use the new phrase "the original number of rows in Table of Ice Cream Flavors", which will return the number of rows that were defined in the source code. If the table hasn't been resized, the original number of rows will be the same as the number of rows.

When we make a table larger, new blank rows are added at the end of the table.

When we make a table smaller, rows are deleted from the end of the table. If the deleted rows aren't blank, the data stored there will be lost. To avoid losing data unnecessarily, we might want to sort the table before making it smaller, since sorting will push all the blank rows to the end.

We can even change a table to have fewer rows than it was defined with. This probably isn't useful, though, since it will use more memory than if we had left the table at its original size.

Changing the size of a table will allocate memory from Inform's heap, the space that's also used for indexed text, lists, and stored actions. The operation might fail if the heap is too full, leaving the table at its old size; this extension won't print an error message, but we can check the number of rows afterward to be sure it succeeded. If we change a table back to its original size, the memory will be reclaimed and the table will go back into the space it originally occupied.

If the game doesn't use indexed text, lists, or stored actions at all, Inform won't normally create a heap, so this extension forces it to create a small heap in that situation (half the normal minimum size). If that isn't big enough, we should add a stored action variable somewhere to make Inform create the heap itself, and then the usual settings like "Use dynamic memory allocation of at least 16384" will work if we need even more space.

Section: Creating New Tables

This extension also allows us to create new tables at runtime, which can be referred to with table-name variables or properties. For example:

	let T be a new table with columns {speaker, quip} and 10 blank rows;

After that phrase, "T" is now a table-name variable pointing to a new table, containing two columns and ten rows. Despite the variable's type being called "table-name", the new table has no actual name, and "say T" will show "** Dynamically created table **" instead.

Note that we have two obligations if we use this syntax. First, we must define the columns ("speaker" and "quip" in this example) in another table in the source code somewhere, so that Inform knows what kinds of value are supposed to go there. We can reuse columns from another table we're already using, or we can define a new table just for this purpose; once the columns have been defined, we can create as many new tables using them as we need.

Second, we must not lose the value of "T", since it's the only way to refer to the new table. If the table is going to stay in use until the end of the game, we should store it in a global variable or a property. If we only need the table temporarily, we should return its memory when we're done with it by writing:

	deallocate T;

(Note that "T" will no longer be a valid table-name once it's been deallocated, so it must not be used afterward.)

To see whether a particular table-name value points to a table that was created this way, we can write:

	if T was dynamically created, [...]

This syntax is useful when we have a table-name variable that might point to a table defined in the source, or maybe a new table, and so we aren't sure whether it needs to be deallocated when we're done with it. It can also be used to check whether the table was created successfully -- if there wasn't enough memory to create the new table, the phrase will return false.

Section: Change Log

Version 2 adds the "new table" and "deallocate table" features.

Version 3 works with Inform 7 version 6E59.

Version 4 fixes a bug where dynamically created tables couldn't be resized.

Example: * Notlob - A parrot that assigns a value to everything he hears, and repeats the lines back in his preferred order.

The Table of Parrot Quips holds the lines that the parrot has heard, along with a score indicating how much the parrot likes each one, and a usage count to limit the number of times he repeats each one. We use a dynamic table, rather than three lists, because we need to keep the score and usage count associated with the correct text: table sorting keeps rows together, but lists can only be sorted independently of each other.

	*: "Notlob"
	
	Include Dynamic Tables by Jesse McGrew.
	
	Pet Shoppe is a room. "A sign reads: 'If you're looking for pets, look no further! Pets are something we sell and you can buy them from us.'"
	
	The parrot is an animal in the Pet Shoppe. "A parrot is perched here." Instead of buying the parrot, say "Except that one."
	
	Table of Parrot Quips
	quip text	quip score	usage count
	indexed text	a number	a number
	
	The highest quip score is a number that varies. The highest quip score is 0.
	
	After answering the parrot that:
		let the textual quip be indexed text;
		let the textual quip be the topic understood;
		let the current quip score be the calculated quip score of the textual quip;
		if the number of blank rows in the Table of Parrot Quips is 0, change the Table of Parrot Quips to have (2 * the number of rows in the Table of Parrot Quips) rows;
		choose a blank row in the Table of Parrot Quips;
		change the quip text entry to the textual quip;
		change the quip score entry to the current quip score;
		change the usage count entry to 0;
		sort the Table of Parrot Quips in reverse quip score order;
		if the current quip score is greater than the highest quip score:
			say "The parrot listens intently, whistling with excitement.";
			now the highest quip score is the current quip score;
		otherwise:
			say "The parrot listens."
	
	To decide which number is the calculated quip score of (msg - indexed text):
		let msg be msg in lower case;
		let the result be 0;
		repeat with N running from 1 to the number of characters in msg:
			let C be character number N in msg;
			if C is "p" or C is "a" or C is "r" or C is "o" or C is "t", increase the result by 1;
		decide on the result.
	
	Every turn when the highest quip score is greater than 0:
		choose row 1 in the Table of Parrot Quips;
		say "The parrot squawks, '[quip text entry]'";
		increase the usage count entry by 1;
		if the usage count entry is 3:
			blank out the whole row;
			if the number of filled rows in the Table of Parrot Quips is 0:
				now the highest quip score is 0;
			otherwise:
				sort the Table of Parrot Quips in reverse quip score order;
				choose row 1 in the Table of Parrot Quips;
				now the highest quip score is the quip score entry.
	
	Test me with "say hello polly / say hello polly parrot / say i've got a lovely fresh cuttlefish for you / say pining for the fjords / z / z / z / z".

Example: ** Multiplication - Using the "new table" feature to create a 2D multiplication table using cross references.

A table is a two-dimensional structure already, but you can only access columns by name, not by number. This example shows how to create a table that contains references to other tables, so that we can multiply two numbers by looking up the first one in the master table, cross referencing to another table, and looking up the second number in that other table.

	*: "Multiplication"
	
	Include Dynamic Tables by Jesse McGrew.
	
	[This is the table we'll fill in with references to the other tables.]
	
	Table of Multiplication
	factor		cross reference
	a number	a table-name
	with 19 blank rows.
	
	[This table only serves to define the "product" column.]
	
	Table of Dummy Columns
	product
	a number
	
	[Here we fill in the multiplication table, creating a cross reference subtable for each row.]
	
	When play begins:
		repeat with R running from 1 to 20:
			let the subtable be a new table with columns {factor, product} and 20 blank rows;
			choose row R in the Table of Multiplication;
			change the factor entry to R;
			change the cross reference entry to the subtable;
			repeat with C running from 1 to 20:
				choose row C in the subtable;
				change the factor entry to C;
				change the product entry to R * C.
	
	To look up (X - number) times (Y - number) in the multiplication table:
		if X is a factor listed in the Table of Multiplication:
			let the subtable be the cross reference entry;
			if Y is a factor listed in the subtable:
				say "[X in capitalized words] times [Y in words] is [product entry in words].";
				stop;
		[if we get here, either X or Y are unlisted]
		say "That isn't in the multiplication table."
	
	To say (N - number) in capitalized words:
		let temp be indexed text;
		let temp be "[N in words]";
		say temp in sentence case.
	
	[Here we need to do some trickery to get around a parser limitation, because Inform normally can't handle two numbers in the same command.]
	
	The other factor is a number that varies.
	
	After reading a command:
		if the player's command includes "by/times [number]":
			now the other factor is the number understood;
			replace the matched text with "by __num__".
	
	Multiplying is an action applying to one number. Understand "multiply [number] by/times __num__" as multiplying.
	
	Carry out multiplying:
		look up the number understood times the other factor in the multiplication table.
	
	Classroom is a room. "This is a peaceful place in which to multiply numbers by other numbers."
	
	Test me with "multiply 5 times 6 / multiply 12 by 8 / multiply 67 by 91".

(We could do this without the extension by defining all twenty-one tables in the source text, but that's a lot of typing.)
