Version 6.0.0 of Dynamic Tables by Tara McGrew begins here.

"Provides a way to change the capacity of a table during the game."

"ported to Inform v10.1.2 by Alwinfy / further ported to Inform v10.2 (in development) by Taryn Michelle"

Chapter 1 - New stuff

To change (T - table name) to have (N - number) row/rows: (- DT_ResizeTable({T}, {N}); -).

To decide which number is the original number of rows in (T - table name): (- DT_OrigSize({T}) -).

To decide which table name is a new table with columns (CS - list of table columns) and (N - number) blank row/rows: (- DT_NewTable({N}, {-by-reference:CS}); -).

To deallocate (T - table name): (- DT_FreeTable({T}); -).

To decide whether (T - table name) was dynamically created: (- (DT_IsFullyDynamic({T})) -).

[ FIXME: Stubbed as it's hard-coded for Inform v10.
Include (-
! Force the heap to be enabled for Dynamic Tables.
#ifndef MEMORY_HEAP_SIZE;
Constant MEMORY_HEAP_SIZE = 4096;
#endif;
-).
]

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
	! Pretend we're allocating text, since FlexAllocate demands a valid KOV.
	rv = FlexAllocate(s, TEXT_TY, 0);
	if (rv) return rv + BLK_DATA_OFFSET;
	print "*** Failed to allocate ", s, " bytes ***^";
	rfalse;
];

[ DT_Free b; if (b) FlexFree(b - BLK_DATA_OFFSET); ];

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
			FlexFree(v);
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
		if (kov == NUMBER_TY or TIME_TY or LIST_OF_TY or TEXT_TY || kov >= 100)
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
-) replacing "CheckTableEntryIsBlank".

Include (-
[ ForceTableEntryBlank tab col row i at oldv flags;
	if (col >= 100) col = TableFindCol(tab, col);
	if (col == 0) rtrue;
	flags = (tab-->col)-->1;
	oldv = (tab-->col)-->(row+COL_HSIZE);
	if ((flags & TB_COLUMN_ALLOCATED) && (oldv ~= 0 or TABLE_NOVALUE))
		FlexFree(oldv);
	(tab-->col)-->(row+COL_HSIZE) = TABLE_NOVALUE;
	if (flags & TB_COLUMN_NOBLANKBITS) return;
	row--;
	at = DT_FindBlankBits(tab, col) + (row/8);
	(at->0) = (at->0) | (CheckTableEntryIsBlank_LU->(row%8));
];
-) replacing "ForceTableEntryBlank".

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
-) replacing "ForceTableEntryNonBlank".

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
-) replacing "TableSwapBlankBits".

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
-) replacing "TableMoveBlankBitsDown".

[And here we replace PrintTableName to show something sensible for fully dynamic tables.]

[ TODO stubbed
Include (-
[ PrintTableName T;
	switch(T) {
{-call:Tables::Support::compile_print_table_names}
		default:
			if (DT_IsFullyDynamic(T))
				print "** Dynamically created table **";
			else
				print "** No such table **";
	}
];
-) replacing "Print Table Name".
]

Section 2 - Missing from Inform 10.2 BasicInformKit 

[ // TM 2026-03-28 - The following Inform6 functions have been copied from the version 10.1 Basic Inform template. 
The fact that they no longer appear in the 10.2 Basic Inform "kit" suggests an intentional move away from these methods. 
If I understand the direction correctly, going forward, Inform means to allow more flexibility with respect to the addition of new "kinds", so while restoring the below four functions "works" 
at this point with the current build of 10.2, it may not suffice to handle the changes that are coming. At the least, keep this in mind when making use of any new "kind" creation features of the language, 
and be sure to test thoroughly before relying on this extension.  ]

Include (-
[ KOVIsBlockValue 
	k ! Implied call parameter
	;
	k = KindAtomic(k);
	if (k == 14 or 30 or 34 or 38 or 40) rtrue;
	rfalse;
];
-).

Include (-
[ KindAtomic kind;
	if ((kind >= 0) && (kind < BASE_KIND_HWM)) return kind;
	return kind-->0;
];
-).

Include(-
[ KindBaseArity kind;
	if ((kind >= 0) && (kind < BASE_KIND_HWM)) return 0;
	return kind-->1;
];
-).

Include(- 
[ KindBaseTerm kind n;
	if ((kind >= 0) && (kind < BASE_KIND_HWM)) return UNKNOWN_TY;
	return kind-->(2+n);
];
-).

Dynamic Tables ends here.
