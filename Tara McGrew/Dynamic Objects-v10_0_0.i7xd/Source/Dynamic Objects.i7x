Version 10.0.0 of Dynamic Objects (for Glulx only) by Tara McGrew begins here.

"Provides the ability to create new objects during game play."

"ported to Inform 10.1.2 by Alwinfy / ported to 10.2.x (in development) by Taryn Michelle"

Include Dynamic Tables by Tara McGrew.

Chapter 1 - Cloning objects

Include (- Array do_temp_array --> 3; -).

Cloning a new object from something is an activity on objects.

The cloning a new object from activity has an object called the new object. [This has to be first! See below.]
The cloning a new object from activity has a truth state called preserving relations.

Section 1 - 'a new object cloned from'

To decide which object is a new object cloned from (prev - an object), preserving relations: (- DO_CloneObject({prev}, {phrase options}) -).

To decide if I6 wants preserving relations: (- do_temp_array-->0 -).

First before cloning a new object from (this is the dynamic objects setting activity variables rule):
	if I6 wants preserving relations:
		now preserving relations is true.

Include (-

! FIXME: N_ATTR_BYTES is a drop-in alias for NUM_ATTR_BYTES.
! This is, according to Inform 6 design, mutable as a compiler switch,
! but currently Inform 7 uses a value of 7.
! If this ever changes, things will very certainly break catastrophically--
! if that happens, please update this value!
Constant N_ATTR_BYTES = 7;

! FIXME: See above; there's an I6 value, GLULX_OBJECT_EXT_BYTES,
! which appends some extra data (bytes) to the end of a Glulx object.
! Again, this is unused by I7, but it's what the zero here should change to
! if that fact is ever invalidated.
Constant OBJECT_STRUCT_SIZE = N_ATTR_BYTES + 25 + 0;

[ DO_CloneObject src opts  rv props i;
	! need to have something to copy from
	if ((src == 0) || (src->0 ~= $70)) rfalse;

	do_temp_array-->0 = (opts ~= 0);	! will be copied to "preserving relations"
	BeginActivity((+ cloning a new object from activity +), src);

	if (ForActivity((+ cloning a new object from activity +), src) == false) {
		! copy property table (this also allocates the fixed-size object structure at the beginning)
		rv = DO_CloneProperties(src);
		if (~~rv) { AbandonActivity((+ cloning a new object from activity +), src); rfalse; }
		props = rv + OBJECT_STRUCT_SIZE;

		! initialize object
		rv->0 = $70;						! type ID
		for ( i=1: i<=N_ATTR_BYTES: i++ ) rv->i = src->i;	! attributes
		i = (1 + N_ATTR_BYTES) / 4;
		rv-->i = 0;						! next object link
		rv-->(i+1) = src-->(i+1);					! hardware name
		rv-->(i+2) = props;					! property table
		rv-->(i+3) = 0;						! parent
		rv-->(i+4) = 0;						! sibling
		rv-->(i+5) = 0;						! child

		! use the vanilla copy fn
		! Copy__Primitive(rv, src);

		! insert object into Inform's linked lists
		DO_LinkObject(src, rv);

		! update relation structures and maintain invariants for symmetric relations
		DO_FixRelations(src, rv, opts);
	}
	
	! we can't refer to the activity variable "new object" from here, so we rely on knowing that it's the first variable in this activity (see above)
	MStack-->MstVO(10000 + (+ cloning a new object from activity +), 0) = rv;
	
	EndActivity((+ cloning a new object from activity +), src);
	return rv;
];

[ DO_CountThings cnt ptr;
	! this assumes that Inform places selfobj as the first thing in the chain
	ptr = selfobj;
	cnt = 0;
	while ((ptr + 1 + N_ATTR_BYTES)-->0) {
		ptr = (ptr + 1 + N_ATTR_BYTES)-->0;
		cnt = cnt + 1;
	}
	return cnt;
]
-).

[ HACK: We need to add this because Inform 7 actually inlines the number of objects
created at runtime, so instead we have to chase down the number of things ourselves. ]
[ // TM 2026-28-03 - No need to recount every single time though. ]
DO_current_thing_count is a number that varies. 
To decide what number is the computed number of things: (- DO_CountThings() -). [Should only ever need to call this once]

[Use of the "incremented" phrase option is meant to be invoked internally, and ONLY from the "dynamic objects belt loosening rule".
It's used to keep an accurate running total and thus avoid having to recount all objects each time something is cloned. The optimization likely only matters when we have quite a 
LOT of objects, but then, a project that means to make use of dynamic object creation might well do just that.]
To decide what number is the current number of things, incremented:
	if DO_current_thing_count <= 0:
		now DO_current_thing_count is the computed number of things;
	otherwise if incremented: [ // Note that if we just counted everything, we skip the increment as the added object will already be accounted for]
		increment DO_current_thing_count;
	decide on DO_current_thing_count.

First after cloning a new object from a thing (this is the dynamic objects belt loosening rule):
	let NT be the current number of things, incremented;
	[say "Now there are a total of [NT] things altogether in the game world.";]
	if the number of rows in the Table of Locale Priorities is less than NT:
		change the Table of Locale Priorities to have NT + 16 rows.

Section 2 - Cloning the property table

Include (-
[ DO_CloneProperties src  orig size i rv;

	! find source object's property table
	src = (src + 9 + N_ATTR_BYTES)-->0;
	orig = src;

	! measure size of table
	size = 4;
	i = src-->0;
	src = src + 4;
	while (i > 0) {
		size = size + 10 + ((src-->0 & $FFFF) * WORDSIZE);
		src = src + 10;
		i--;
	}

	! obtain memory for new table
	rv = DT_Alloc(size + OBJECT_STRUCT_SIZE);
	! print "*** Allocated ", size + OBJECT_STRUCT_SIZE, " bytes at addr ", rv, ". ***^";
	if (~~rv) rfalse;
	rv = rv + OBJECT_STRUCT_SIZE;

	! copy it
	DT_CopyBytes(size, orig, rv);

	! adjust property data pointers
	i = rv-->0;
	src = rv + 4;
	while (i > 0) {
		src-->1 = src-->1 - orig + rv;
		src = src + 10;
		i--;
	}

	return rv - OBJECT_STRUCT_SIZE;
];
-).

Section 3 - Linking the new object into the world model

[Inform 6 implements objectloop on Glulx by putting all objects in a linked list. We need to add the new object to this linked list so it can be found by objectloop.

Additionally, Inform 7 optimizes kind-based objectloops by adding properties containing a linked list for each kind: all things are linked together in one list, all containers are linked together in another list, and so on. Each kind has its own link property. There's no direct way to look up the property from the kind, but we can take advantage of the fact that they have similar names which are both available at runtime: a kind whose I6 name is K2_thing uses the link property K2_thing_Next.]

Include (-

! NOTE: This is a hack, as (obj).(prop) notations differ in I6 and I7.
! The way Inform 7 stores properties is as a pointer to 2-word array,
! where the first word is actually a type tag specifying whether the I7 property
! is in fact an I6 property or just an I6 attribute.

! Thus to make the compiler play nice, we instead store the prop in proptemp-->1,
! then say (obj).(do_proptemp).
Array do_proptemp --> 2;

[ DO_LinkObject src obj  i last prop nk;
	! add obj to the linked list of all objects
	last = 0;
	for (i=Class: i: i=(i + 1 + N_ATTR_BYTES)-->0)
		last = i;
	if (last)
		(last + 1 + N_ATTR_BYTES)-->0 = obj;
	! last = (src + 1 + N_ATTR_BYTES)-->0;
	! (obj + 1 + N_ATTR_BYTES)-->0 = last;
	! (src + 1 + N_ATTR_BYTES)-->0 = obj;

	! add obj to the linked lists for each kind it's a member of
	nk = obj.KD_Count;
	while (nk > 0) {
		i = nk*2;
		prop = DO_FindLinkProp(obj, KindHierarchy-->i);
		nk = KindHierarchy-->(i+1);
		if (prop) {
			do_proptemp-->1 = prop;
			last = src;
			while (last.do_proptemp) {
				last = last.do_proptemp;
			}
			last.do_proptemp = obj;
			obj.do_proptemp = 0;
		} else {
			! Arriving here means the object just created will not have been added to the linked list of objects of the shown class
			! The object still exists, but it won't be found by many of Inform's built-in mechanisms. The most immediately obvious consequence is that it won't 
			! show up in default room descriptions, inventory lists, or the like. 
			print "*** Failed to find link property for ", (object) KindHierarchy-->i, " ***^";
		}
	}
];

Constant DO_PROPBUF_LEN 256;
Array do_propbuf1 buffer DO_PROPBUF_LEN;	! the kind name, e.g. "K2_thing"
Array do_propbuf2 buffer DO_PROPBUF_LEN;	! the property name, e.g. "K2_thing_Next"

[ DO_FindLinkProp obj kind pt i prop;
	! get kind name
	VM_PrintToBuffer(do_propbuf1, DO_PROPBUF_LEN, DO_PrintObject, kind);

	! find obj's property table
	pt = (obj + 9 + N_ATTR_BYTES)-->0;
	! print "*** Vtable for linking found at ", pt, ". ***^";

	! check each property
	i = pt-->0;
	pt = pt + 4;
	while (i > 0) {
		prop = ((pt-->0) / $10000) & $FFFF;
		!print "*** NOTE: property ", (property) prop, " has size ", (pt-->0 & $ffff), " **^";
		if (((pt-->2) / $10000) & $1) {
			print "** WARN: property ", (property) prop, " declared private **^";
		}
		VM_PrintToBuffer(do_propbuf2, DO_PROPBUF_LEN, DO_PrintProperty, prop); ! will print result of DO_PrintProperty (prop)
		if (DO_PropBufsMatch()) {
			!print "*** NOTE: Found property so this SHOULD work ***^";
			! sanity check: ensure this property is indeed a pointer-to-object
			i = pt-->1-->0;
			if (i ~= 0 && i->0 ~= $70) {
				print "*** ERROR: found LL prop ", (property) prop, " with bad ptr ", i->0, " ***^";
				rfalse;
			}
			return prop;
		}
		pt = pt + 10;
		i--;
	}

	rfalse;
];

[ DO_PrintObject x; print (object) x; ];
[ DO_PrintProperty x; print (property) x; ];

[ DO_PropBufsMatch  len p1 p2 i;
	! do_propbuf1 contains the kind name (e.g. K2_Thing)
	! do_propbuf2 contains the property name to check. 
	!print "*** Comparing the following (p1 / p2) ^";
	!VM_PrintBuffer( do_propbuf1 );
	!print " / ";
	!VM_PrintBuffer( do_propbuf2 );
	!print "^";
	len = do_propbuf1-->0;
	! Don't bother if property name is the wrong length and so can't possibly be "<kindname>_Next"
	if (do_propbuf2-->0 ~= len + 5) rfalse;
	
	! In 10.2, compiling for glulx defaults to using 4-byte character codes (DICT_CHAR_SIZE = 4). 
	! This requires a different approach to testing the contents of the buffer array, since we need to access character codes a word (4 bytes) at a time. 
	
	! *** From this point the necessary code differs based on DICT_CHAR_SIZE, which we can't presently test at runtime. This is the correct code for 32-bit Glulx
	len = len + 1; ! Note the offset of 1 rather than WORDSIZE (because we'll be reading WORDS and not BYTES)
	for (i=1:i<len:++i) {
		! Note also the use of the --> operator as opposed to -> to access characters a 32-bit word (4 bytes) at a time
		if (do_propbuf1-->i ~= do_propbuf2-->i) rfalse; 
	}
	! We passed that check, now just test whether the last five characters of the property name are "_Next"
	if (do_propbuf2-->i++ ~= '_') rfalse;
	if (do_propbuf2-->i++ ~= 'N') rfalse;
	if (do_propbuf2-->i++ ~= 'e') rfalse;
	if (do_propbuf2-->i++ ~= 'x') rfalse;
	if (do_propbuf2-->i++ ~= 't') rfalse;
	rtrue;
] -).

[ The below version of the DO_PropBufsMatch function works with DICT_CHAR_SIZE = 1, which is the Glulx haracter format Inform 10.1 builds evidently used by default. As there is currently no easy way to detect the character size at runtime, we can't just seamlessly switch between them. Keeping the alternate format version here, commented out, in case that proves to be useful in the future. ]
[ Include (-
[ DO_PropBufsMatch  len p1 p2 i;
	! do_propbuf1 contains the kind name (e.g. K2_Thing)
	! do_propbuf2 contains the property name to check. 
	!print "*** Comparing the following (p1 / p2) ^";
	!VM_PrintBuffer( do_propbuf1 );
	!print " / ";
	!VM_PrintBuffer( do_propbuf2 );
	!print "^";
	len = do_propbuf1-->0;
	! Don't bother if property name is the wrong length and so can't possibly be "<kindname>_Next"
	if (do_propbuf2-->0 ~= len + 5) rfalse;
	
	! In 10.2, compiling for glulx defaults to using 4-byte character codes (DICT_CHAR_SIZE = 4). 
	! This requires a different approach to testing the contents of the buffer array. en using the -> operator, we end up accessing 4-byte character codes a byte at a time. 
	! For backward-compatability, we need to test this 
	
	! *** From this point the necessary code differs based on DICT_CHAR_SIZE, which we can't presently test at runtime. This is the single-byte character size version.
	len = len + WORDSIZE; ! For Z8 we're going to be reading BYTES, so increment by WORDSIZE to skip past length, then use the -> operator to read a byte at a time
	for (i=WORDSIZE:i<len:++i) {
		if (do_propbuf1->i ~= do_propbuf2->i) rfalse; 
	}
	! We passed that check, now just check that the last fiver characters of the property name are "_Next"
	if (do_propbuf2->i++ ~= '_') rfalse;
	if (do_propbuf2->i++ ~= 'N') rfalse;
	if (do_propbuf2->i++ ~= 'e') rfalse;
	if (do_propbuf2->i++ ~= 'x') rfalse;
	if (do_propbuf2->i++ ~= 't') rfalse;
	rtrue;
]; -).]

Section 4 - Restoring the object's ability to relate, and possibly its relationships

[Static various-to-various relations are stored as a rectangular bitmap, whose size is determined by the compiler based on the number of objects in the relation's domains. After cloning an object, we must resize all of the bitmaps for relations which apply to the new object.]

Include (-
[ DO_FixRelations src obj preserve  i storage;
	do_temp_array-->0 = src;
	do_temp_array-->1 = obj;
	do_temp_array-->2 = preserve;
	IterateRelations(DO_FixEachRelation);
];

[ DO_FixEachRelation rel  src obj preserve i k1 k2 list storage handler valency;
	! skip read-only relations
	if (~~(rel-->RR_PERMISSIONS & RELS_ASSERT_TRUE)) return;
	
	k1 = KindBaseTerm(rel-->RR_KIND, 0);
	k2 = KindBaseTerm(rel-->RR_KIND, 1);
	
	if (DO_RelationKindApplies(k1, obj) || DO_RelationKindApplies(k2, obj)) {
		src = do_temp_array-->0;
		obj = do_temp_array-->1;
		preserve = do_temp_array-->2;
		
		valency = RELATION_TY_GetValency(rel);
		
		if (DO_IsDynamicRelation(rel)) {
			! dynamic relation: the relation structure is fine, just add the new object to it if preserving
			if (preserve && valency ~= RRVAL_O_TO_O or RRVAL_SYM_O_TO_O) {
				list = LIST_OF_TY_Create(k2);
				handler = rel-->RR_HANDLER;
				if (valency ~= RRVAL_O_TO_V && DO_RelationKindApplies(k1, obj)) {
					handler(rel, RELS_LOOKUP_ALL_Y, src, list);
					for ( i=LIST_OF_TY_GetLength(list): i>0: i-- )
						handler(rel, RELS_ASSERT_TRUE, obj, LIST_OF_TY_GetItem(list, i));
				}
				if (valency ~= RRVAL_V_TO_O && DO_RelationKindApplies(k2, obj)) {
					handler(rel, RELS_LOOKUP_ALL_X, src, list);
					for ( i=LIST_OF_TY_GetLength(list): i>0: i-- )
						handler(rel, RELS_ASSERT_TRUE, LIST_OF_TY_GetItem(list, i), obj);
				}
				FlexFree(list);
			}
		} else if ((storage = rel-->RR_STORAGE) ~= 0) {
			! static relation: we may need to resize the storage array (for V-to-V) or clear properties (for others, when not preserving)
			switch (valency) {
				RRVAL_O_TO_V, RRVAL_V_TO_O: if (~~preserve) DO_ClearOtoX(obj, storage);
				RRVAL_O_TO_O, RRVAL_SYM_O_TO_O: DO_ClearOtoX(obj, storage);
				RRVAL_V_TO_V: rel-->RR_STORAGE = DO_AddVtoV(obj, storage, preserve, src, 0);
				RRVAL_SYM_V_TO_V: rel-->RR_STORAGE = DO_AddVtoV(obj, storage, preserve, src, 1);
				RRVAL_EQUIV: if (~~preserve) DO_ClearEquiv(obj, storage);
			}
		}
	}
];

[ DO_IsDynamicRelation rel;
	! static relations start with REL_BLOCK_HEADER (which includes the BLK_FLAG_RESIDENT bit)
	if (rel-->0 == REL_BLOCK_HEADER) rfalse;
	rtrue;
];

[ DO_RelationKindApplies rk obj;
	! relations between any kinds of objects are (as of 6E59) stored as relations of OBJECT_TY,
	! but maybe that will change in the future
	if (rk == OBJECT_TY) rtrue;
	rfalse;
];

[ DO_ClearOtoX obj prop;
	if (obj provides prop) obj.prop = nothing;
];

[ DO_ClearEquiv obj prop  last i;
	if (obj provides prop) {
		last = 0;
		objectloop (i provides prop)
			if (i.prop > last) last = i.prop;
		obj.prop = last + 1;
	}
];

Constant VTOVS_HDR_WORDS = 8;

[ DO_AddVtoV obj bitmap preserve src sym  lp rp nbmp i m l r n oli ori;
	lp = bitmap-->VTOVS_LEFT_INDEX_PROP;
	rp = bitmap-->VTOVS_RIGHT_INDEX_PROP;
	if (obj provides lp) {
		if (obj provides rp) m = 3;		! both
		else m = 1;			! left only
	} else {
		if (obj provides rp) m = 2;		! right only
		else return bitmap;
	}

	! calculate new domain size
	l = bitmap-->VTOVS_LEFT_DOMAIN_SIZE;
	if (m == 1 or 3) { oli = obj.lp; obj.lp = l; l++; }
	r = bitmap-->VTOVS_RIGHT_DOMAIN_SIZE;
	if (m == 2 or 3) { ori = obj.rp; obj.rp = r; r++; }
	n = l * r;

	! allocate memory for new bitmap
	! 1 word for static bitmap pointer + 8 word v2v header + 1 word per 16 entries in the bitmap
	nbmp = DT_Alloc((1 + VTOVS_HDR_WORDS + ((n+15)/16)) * WORDSIZE);
	if (~~nbmp) { print "*** No memory to resize V2V relation ***^"; rfalse; }

	! point from the dynamic bitmap to the static bitmap
	if (bitmap >= Flex_Heap) nbmp-->0 = bitmap-->(-1); else nbmp-->0 = bitmap;

	! point from the static bitmap to the dynamic bitmap
	!(nbmp-->0)-->0 = -1;
	!(nbmp-->0)-->1 = nbmp + WORDSIZE;

	! fill in V2V header
	nbmp = nbmp + WORDSIZE;
	nbmp-->VTOVS_LEFT_INDEX_PROP = lp;
	nbmp-->VTOVS_RIGHT_INDEX_PROP = rp;
	nbmp-->VTOVS_LEFT_DOMAIN_SIZE = l;
	nbmp-->VTOVS_RIGHT_DOMAIN_SIZE = r;
	nbmp-->VTOVS_LEFT_PRINTING_ROUTINE = bitmap-->VTOVS_LEFT_PRINTING_ROUTINE;
	nbmp-->VTOVS_RIGHT_PRINTING_ROUTINE = bitmap-->VTOVS_RIGHT_PRINTING_ROUTINE;
	nbmp-->VTOVS_CACHE_BROKEN = 1;
	nbmp-->VTOVS_CACHE = 0;

	! expand the bits
	l = bitmap-->VTOVS_LEFT_DOMAIN_SIZE;
	r = bitmap-->VTOVS_RIGHT_DOMAIN_SIZE;
	if (m == 2 or 3) {
		! need to insert bits for a new column
		DO_InsertBits(bitmap + VTOVS_HDR_WORDS*WORDSIZE, l * r, r, nbmp + VTOVS_HDR_WORDS*WORDSIZE);
	} else {
		! just copy
		for (i=(l*r + 15)/16: i>0: --i)
			nbmp-->(VTOVS_HDR_WORDS+i) = bitmap-->(VTOVS_HDR_WORDS+i);
	}

	! preserve relations if needed
	if (preserve) {
		if (m == 1 or 3)
			objectloop (i provides rp)
				if (DO_Relation_TestVtoV_Raw(src, bitmap, i, sym))
					DO_Relation_NowVtoV_Raw(obj, nbmp, i, sym);

		if ((~~sym) && m == 2 or 3)
			objectloop (i provides lp)
				if (DO_Relation_TestVtoV_Raw(i, bitmap, src, sym))
					DO_Relation_NowVtoV_Raw(i, nbmp, obj, sym);
	}

	! deallocate old bitmap if necessary
	if (bitmap >= Flex_Heap) DT_Free(bitmap - WORDSIZE);

	return nbmp;
];

! expands 'nbits' bits from src to dest, inserting a zero bit every
! 'interval' bits and using only the lower 16 bits of each word.
! the number of words used for dest is (nbits+(nbits/interval)+15)/16.
[ DO_InsertBits src nbits interval dest  sw sb dw db i si f;
	sw = 0; sb = 1; dw = 0; db = 1;
	nbits = nbits + (nbits / interval);
	f = 0; si = 0;
	for (i=0: i<nbits: i++) {
		if (db == 1) dest-->dw = 0;
		if (f) {
			f = 0;
		} else {
			if (src-->sw & sb) dest-->dw = dest-->dw | db;
			sb = sb * 2;
			if (sb == $10000) { sw++; sb = 1; }
			si++;
			if (si == interval) { f = 1; si = 0; }
		}
		db = db * 2;
		if (db == $10000) { dw++; db = 1; }
	}
];

! "raw" versions of a couple functions from Relations.i6t, to operate directly on the V2V bitmap
[ DO_Relation_NowVtoV_Raw obj1 vtov_structure obj2 sym pr pr2 i1 i2;
	if (sym && (obj2 ~= obj1)) { DO_Relation_NowVtoV_Raw(obj2, vtov_structure, obj1, false); }
	pr = vtov_structure-->VTOVS_LEFT_INDEX_PROP;
	pr2 = vtov_structure-->VTOVS_RIGHT_INDEX_PROP;
	vtov_structure-->VTOVS_CACHE_BROKEN = true; ! Mark any cache as broken
	if (pr) {
		! if ((obj1 ofclass Object) && (obj1 provides pr)) i1 = obj1.pr;
		! else return RunTimeProblem(RTP_IMPREL, obj1, relation);
		i1 = obj1.pr;
	} else i1 = obj1-1;
	if (pr2) {
		! if ((obj2 ofclass Object) && (obj2 provides pr2)) i2 = obj2.pr2;
		! else return RunTimeProblem(RTP_IMPREL, obj2, relation);
		i2 = obj2.pr2;
	} else i2 = obj2-1;
	pr = i1*(vtov_structure-->VTOVS_RIGHT_DOMAIN_SIZE) + i2;
	i1 = IncreasingPowersOfTwo_TB-->(pr%16);
	pr = pr/16 + 8;
	vtov_structure-->pr = (vtov_structure-->pr) | i1;
];

[ DO_Relation_TestVtoV_Raw obj1 vtov_structure obj2 sym pr pr2 i1 i2;
	pr = vtov_structure-->VTOVS_LEFT_INDEX_PROP;
	pr2 = vtov_structure-->VTOVS_RIGHT_INDEX_PROP;
	if (sym && (obj2 > obj1)) { sym = obj1; obj1 = obj2; obj2 = sym; }
	if (pr) {
		! if ((obj1 ofclass Object) && (obj1 provides pr)) i1 = obj1.pr;
		! else { RunTimeProblem(RTP_IMPREL, obj1, relation); rfalse; }
		i1 = obj1.pr;
	} else i1 = obj1-1;
	if (pr2) {
		! if ((obj2 ofclass Object) && (obj2 provides pr2)) i2 = obj2.pr2;
		! else { RunTimeProblem(RTP_IMPREL, obj2, relation); rfalse; }
		i2 = obj2.pr2;
	} else i2 = obj2-1;
	pr = i1*(vtov_structure-->VTOVS_RIGHT_DOMAIN_SIZE) + i2;
	i1 = IncreasingPowersOfTwo_TB-->(pr%16);
	pr = pr/16 + 8;
	if ((vtov_structure-->pr) & i1) rtrue; rfalse;
];
-).

[Previous versions of this extension had to patch the template routines that handle various-to-various relations, since I7's generated code called them with hardcoded addresses of the relation storage structures. As of 6E59, however, we can simply change the value in relation-->RR_STORAGE.]

Section 5 - A hack to make block-valued properties work in cloned objects

[ FIXME: The 'pointer valued' property seems to be inaccessible to Inform v10.

This seems to be intentional, see inform7/Internal/Inter/BasicInformKit/kinds/Protocols.neptune:

> builtin protocol POINTER_VALUE_TY {
> 	conforms-to: SAYABLE_VALUE_TY
> 	! for internal use only: cannot be named in source text
> }

Just... try not to use this on value typed properties, please? ]

[ To fix the/-- cloned (P - property) property/--: (- DO_UnlinkProp({P}, (+ new object +)); -). ]
To fix the/-- cloned (P - property) property/--: (- DO_UnlinkProp({P}, (+ new object +)); -).

Include (-
[ DO_UnlinkProp prop obj  v;
	v = obj.prop;
	obj.prop = BlkValueCreate(BlkValueWeakKind(v));
	BlkValueCopy(obj.prop, v);
];
-).

Dynamic Objects ends here.
