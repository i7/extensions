Version 7/130712 of Dynamic Objects (for Glulx only) by Jesse McGrew begins here.

"Provides the ability to create new objects during game play."

Include Dynamic Tables by Jesse McGrew.

Chapter 1 - Cloning objects

Include (- Array do_temp_array --> 3; -).

Cloning a new object from something is an activity on objects.

The cloning a new object from activity has an object called the new object. [This has to be first! See below.]
The cloning a new object from activity has a truth state called preserving relations.

Section 1 - 'a new object cloned from'

To decide which object is a new object cloned from (prev - an object), preserving relations: (- DO_CloneObject({prev}, {phrase options}) -).

First before cloning a new object from (this is the dynamic objects setting activity variables rule): initialize cloning activity variables.

To initialize cloning activity variables: (- (+preserving relations+) = do_temp_array-->0; -).

Include (-
Constant OBJECT_STRUCT_SIZE = NUM_ATTR_BYTES + 25;

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
		for ( i=1: i<=NUM_ATTR_BYTES: i++ ) rv->i = src->i;	! attributes
		i = (1 + NUM_ATTR_BYTES) / 4;
		rv-->i = 0;						! next object link
		rv-->(i+1) = src-->(i+1);					! hardware name
		rv-->(i+2) = props;					! property table
		rv-->(i+3) = 0;						! parent
		rv-->(i+4) = 0;						! sibling
		rv-->(i+5) = 0;						! child

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
-).

First after cloning a new object from a thing (this is the dynamic objects belt loosening rule):
	let NT be the number of things;
	if the number of rows in the Table of Locale Priorities is less than NT, change the Table of Locale Priorities to have NT + 4 rows.

Section 2 - Cloning the property table

Include (-
[ DO_CloneProperties src  orig size i rv;
	! find source object's property table
	src = (src + 9 + NUM_ATTR_BYTES)-->0;
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

Additionally, Inform 7 optimizes kind-based objectloops by adding properties containing a linked list for each kind: all things are linked together in one list, all containers are linked together in another list, and so on. Each kind has its own link property. There's no direct way to look up the property from the kind, but we can take advantage of the fact that they have similar names which are both available at runtime: a kind whose I6 name is K2_thing uses the link property IK2_Link.]

Include (-
! compatibility with 6F95
#ifndef KD_Count;
Constant KD_Count = IK_0;
#endif;

[ DO_LinkObject src obj  i last prop nk;
	! add obj to the linked list of all objects
	last = 0;
	for (i=Class: i: i=(i + 1 + NUM_ATTR_BYTES)-->0)
		last = i;
	if (last)
		(last + 1 + NUM_ATTR_BYTES)-->0 = obj;

	! add obj to the linked lists for each kind it's a member of
	nk = obj.KD_Count;
	while (nk > 0) {
		i = nk*2;
		prop = DO_FindLinkProp(obj, KindHierarchy-->i);
		if (prop) {
			last = src;
			while (last.prop) last = last.prop;
			last.prop = obj;
			obj.prop = 0;
		} else {
			print "*** Failed to find link property for ", (object) KindHierarchy-->i, " ***^";
		}
		nk = KindHierarchy-->(i+1);
	}
];

Constant DO_PROPBUF_LEN 16;
Array do_propbuf1 buffer DO_PROPBUF_LEN;	! the kind name, e.g. "K2_thing"
Array do_propbuf2 buffer DO_PROPBUF_LEN;	! the property name, e.g. "IK2_Link"

[ DO_FindLinkProp obj kind pt i prop;
	! get kind name
	VM_PrintToBuffer(do_propbuf1, DO_PROPBUF_LEN, DO_PrintObject, kind);

	! find obj's property table
	pt = (obj + 9 + NUM_ATTR_BYTES)-->0;

	! check each property
	i = pt-->0;
	pt = pt + 4;
	while (i > 0) {
		prop = ((pt-->0) / $10000) & $FFFF;
		VM_PrintToBuffer(do_propbuf2, DO_PROPBUF_LEN, DO_PrintProperty, prop);
		if (DO_PropBufsMatch()) return prop;
		pt = pt + 10;
		i--;
	}

	rfalse;
];

[ DO_PrintObject x; print (object) x; ];
[ DO_PrintProperty x; print (property) x; ];

[ DO_PropBufsMatch  len p1 p2 c1 c2 lc2;
	len = do_propbuf1-->0;
	if (do_propbuf2-->0 <= len) len = do_propbuf2-->0 - 1;
	p1 = do_propbuf1 + WORDSIZE;
	p2 = do_propbuf2 + WORDSIZE + 1;
	lc2 = 0;
	while (len > 0) {
		c1 = p1->0; c2 = p2->0;
		! we used to only have to compare up to the first underscore, but 6G60 added
		! "IK#_Count" properties so we have to make sure the character after the
		! underscore is an L
		if (c1 ~= c2) {
			if (lc2 == '_' && c2 == 'l' or 'L') rtrue;
			rfalse;
		}
		len--; p1++; p2++;
		lc2 = c2;
	}
	rfalse;
];
-).

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
				BlkFree(list);
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
	if (bitmap >= Blk_Heap) nbmp-->0 = bitmap-->(-1); else nbmp-->0 = bitmap;

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
	if (bitmap >= Blk_Heap) DT_Free(bitmap - WORDSIZE);

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

To fix the/-- cloned (P - pointer value valued property) property/--: (- DO_UnlinkProp({P}, (+ new object +)); -).

Include (-
[ DO_UnlinkProp prop obj  v;
	v = obj.prop;
	obj.prop = BlkValueCreate(v-->BLK_HEADER_KOV);
	BlkValueCopy(obj.prop, v);
];
-).

Dynamic Objects ends here.

---- DOCUMENTATION ----

Chapter: Basic cloning

This extension allows new objects to be created by cloning existing objects. Once we've defined a suitable prototype object, we can refer to "a new object cloned from" it, like so:

	let the copy be a new object cloned from the prototype;

That line will create the new object and assign it to the variable called "copy". The copy will be the same kind as the prototype, and have all the same property values.

By default, the new object will not be participating in any of the relationships of the prototype object. To clone the relationships as well, use the "preserving relations" option:

	let the copy be a new object cloned from the prototype, preserving relations;

Note that even with this option, one-to-various (or various-to-one) relationships are only preserved when the cloned object is on the "various" side, and one-to-one relationships are never preserved.

If memory runs out and the new object cannot be created, the phrase will return "nothing".

Chapter: The "cloning a new object from" activity

The cloning process is implemented as an activity called "cloning a new object from". We can write "before cloning a new object from" rules to intervene before the object is cloned, and in those rules we can refer to "preserving relations" as a truth state which is true if the process is going to preserve object relationships.

We can also write "after cloning a new object from" rules to intervene after the object is cloned, and in those we can also refer to the clone as "the new object":

	A thing has a number called the clone generation.
	
	After cloning a new object from something:
		increase the clone generation of the new object by 1.

In this example, we change the behavior of "preserving relations" so that when the original object relates to itself, the clone also relates to itself (and not to the original object):

	Love relates various people to various people. The verb to love (he loves, they love, he is loving, he is loved) implies the love relation.
	
	After cloning a new object from a person (called the original):
		if preserving relations is true and the original loves the original:
			now the new object does not love the original;
			now the original does not love the new object;
			now the new object loves the new object.

Section: Handling block value properties

When cloning objects that have properties containing block values (indexed text, stored actions, lists, or dynamic relations), we must indicate which properties those are so the extension can copy their values correctly; otherwise we may encounter unexpected behavior or runtime problem messages if the property values are changed. Use the "fix the cloned _ property" phrase in an "after cloning a new object from" rule:

	A person has a list of numbers called the favorite numbers.
	
	After cloning a new object from a person:
		fix the cloned favorite numbers property.

Chapter: Caveats

If we plan to clone any rooms or doors, we must disable fast route-finding (which is enabled by default on Glulx):

	Use slow route-finding.

Chapter: Change log

Version 2 uses Dynamic Tables (by the same author) to avoid replacing the standard locale description rules, and allows cloned objects to participate in all relations.

Version 3 works with Inform 7 version 5U92.

Version 4 fixes a bug with relations.

Version 5 works with Inform 7 version 6E59. It also adds the "cloning a new object from" activity and the "fix the cloned _ property" phrase to allow block-type properties to be cloned correctly. It also changes the behavior (and specification) of "preserving relations" with regard to one-to-one relations: now they are never preserved, since that would result in removing the original object from the relation.

Version 6 works with Inform 7 version 6G60.

Version 7 fixes another bug with relations and a bug that prevented the "new object cloned from" phrase from being used in certain contexts.

Example: * The Cubbins Effect - Creating a new hat every time the player removes the one he's wearing.

	*: "The Cubbins Effect" by Geodor Theisel
	
	Include Dynamic Objects by Jesse McGrew.
	
	King Derwin's Court is a room. "You have been summoned here for the crime of failing to remove your hat in the king's presence."
	
	A hat is a kind of thing.
	
	A hat style is a kind of value. The hat styles are red, blue, green, yellow, white, black, brown, zebra-striped, tall, pointy, short, gray, pink, fuzzy, rainbow-colored, and feathered.
	
	A hat has a hat style. Before printing the name of a hat, say "[hat style] ". Understand the hat style property as describing a hat.
	
	The player wears a hat which is red.
	
	Instead of taking off a hat which is worn by the player:
		now the noun is in the location;
		if 500 hats are in the location:
			say "You remove [the noun] and drop it. It seems that was the last one!";
			end the story finally saying "You have won";
		otherwise:
			let the new hat be a new object cloned from the noun;
			now the player is wearing the new hat;
			say "You remove [the noun] and drop it, only to find another hat upon your head -- a [hat style of the new hat] one."

	After cloning a new object from a hat (called the original hat):
		while the hat style of the new object is the hat style of the original hat:
			now the hat style of the new object is a random hat style.
	
	Rule for printing a number of hats (called the particular headwear):
		say "[listing group size in words] [hat style of the particular headwear] hats".
	
	Test me with "remove hat / remove hat / remove hat / i / look".