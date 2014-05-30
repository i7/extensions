Version 1/121012 of Mutable Kinds by Dannii Willis begins here.

"Change the default values of the properties of Mutable Kinds at run-time"

[ TODO:
	better error messages for running out of mutable properties
	inheritance?
]

Use maximum mutable kinds of at least 5 translates as (- Constant MAX_MUT_KINDS = {N}; -). 
Use maximum mutable properties of at least 5 translates as (- Constant MAX_MUT_PROPS = {N}; -). 

Include (-

! Stores the default value of each kind, each row is Kind, Default Object
Constant MAX_MUT_KINDS_LEN = MAX_MUT_KINDS * 2;
Array kind_defaults --> MAX_MUT_KINDS_LEN;

! Each row on the mutable property table is: Kind, Prop, Value, Default Value
!Constant MAX_MUT_KINDS_PROPS = MAX_MUT_KINDS * MAX_MUT_PROPS;
Constant MAX_MUT_PROPS_LEN = MAX_MUT_PROPS * 4;
Array mutable_properties --> MAX_MUT_PROPS_LEN;

-).

Section - Functions for accessing mutable kinds

Include (-

! Find the kind of an object
[ KindOfObj obj;
	return KindHierarchy-->( ( obj.KD_Count ) * 2 );
];

! Check if an kind is mutable
[ IsMutKind kind	i;
	while ( i < MAX_MUT_KINDS_LEN )
	{
		if ( kind_defaults-->i == kind )
			return 1;
		if ( kind_defaults-->i == 0 )
			return 0;
		i = i + 2;
	}
];

! Make a kind mutable
[ MakeMutKind kind	i obj;
	while ( i < MAX_MUT_KINDS_LEN )
	{
		! This kind is already mutable. Hurray!
		if ( kind_defaults-->i == kind )
			return;
		
		! Find and set the default object for this kind
		if ( kind_defaults-->i == 0 )
		{
			kind_defaults-->i = kind;
			objectloop( obj ofclass kind )
			{
				kind_defaults-->(i + 1) = obj;
				return;
			}
		}
		i = i + 2;
	}
	print "Error: too many mutable kinds!^^";
];

! Find the default object for a mutable kind
[ DefaultObjOfKind kind	i;
	while ( i < MAX_MUT_KINDS_LEN )
	{
		if ( kind_defaults-->i == kind )
			return kind_defaults-->(i + 1);
		if ( kind_defaults-->i == 0 )
			break;
		i = i + 2;
	}
	print "Error: mutable kind not found!^^";
];

! Test if a kind is a subkind of another kind
[ TestSubkind subclass superclass	i;
	! These classes are outside the kind heirarchy and must be dealt with first
	if ( subclass == Class or Object or Routine or String or VPH_Class )
		rfalse;
	
	while (1)
	{
		if ( KindHierarchy-->i == subclass )
			return KindHierarchy-->( KindHierarchy-->(i + 1) * 2 ) == superclass;
		i = i + 2;
	}
];

-).

Section - Phrases for accessing mutable kinds

To decide which K is kind of/-- (kind - name of kind of value of kind K):
	(- KindOfObj( {-default-value-for:kind} ) -).

To repeat with (loopvar - nonexisting K variable) running through the/-- kinds of (kind - name of kind of value of kind K) begin -- end:
	(- objectloop( {loopvar} && metaclass({loopvar}) == Class && TestSubkind({loopvar}, KindOfObj({-default-value-for:kind})) ) -).

Section - Implementing mutable kinds

Include (-
[ GProperty K V pr	obj i kind val defaultval;
	if (K == OBJECT_TY) obj = V; else obj = KOV_representatives-->K;
	if (obj == 0) { RunTimeProblem(RTP_PROPOFNOTHING, obj, pr); rfalse; }
	
	! Property of a Kind
	if ( metaclass(obj) == Class )
	{
		while ( i < MAX_MUT_PROPS_LEN )
		{
			! mutable property not set
			if ( mutable_properties-->i == 0 )
				return DefaultObjOfKind(obj).pr;
			
			! Retreive a mutable property
			if ( mutable_properties-->i == obj && mutable_properties-->(i + 1) == pr )
				return mutable_properties-->(i + 2);
			
			i = i + 4;
		}
		rfalse;
	}
	
	if (obj provides pr) {
		if (K == OBJECT_TY) {
			if (pr == door_to) return obj.pr();
			if (WhetherProvides(V, false, pr, true))
			{
				! Get the object's own property
				val = obj.pr;
				kind = KindOfObj( obj );
				
				! Non-mutable kind, return the object's own property
				if ( IsMutKind( kind ) == 0 )
					return val;
					
				! Search the mutable properties table
				while ( i < MAX_MUT_PROPS_LEN )
				{
					! mutable property not set
					if ( mutable_properties-->i == 0 )
						return val;
					
					! Retreive a mutable property
					if ( mutable_properties-->i == kind && mutable_properties-->(i + 1) == pr )
					{
						! Check if this object has a non-default property value and return it, otherwise return the kind's default value
						defaultval = mutable_properties-->(i + 3);
						if ( val == defaultval )
							return mutable_properties-->(i + 2);
						else
							return val;
					}
					i = i + 4;
				}
			}
			rfalse;
		}
		if (obj ofclass K0_kind)
			WhetherProvides(V, false, pr, true); ! to force a run-time problem
		if ((V < 1) || (V > obj.value_range)) {
			RunTimeProblem(RTP_BADVALUEPROPERTY); return 0; }
		return (obj.pr)-->(V+COL_HSIZE);
	} else {
		if (obj ofclass K0_kind)
			WhetherProvides(V, false, pr, true); ! to force a run-time problem
	}
	rfalse;
];
-) instead of "Value Property" in "RTP.i6t".

Include (-
[ WriteGProperty K V pr val	obj i;
	if (K == OBJECT_TY) obj = V; else obj = KOV_representatives-->K;
	if (obj == 0) { RunTimeProblem(RTP_PROPOFNOTHING, obj, pr); rfalse; }
	if (K == OBJECT_TY) {
		if ( metaclass(obj) == Class )
		{
			! Make this a mutable kind
			MakeMutKind( obj );
		
			! Add this property to the list of mutable properties
			while ( i < MAX_MUT_PROPS_LEN )
			{
				! New mutable property
				if ( mutable_properties-->i == 0 )
				{
					mutable_properties-->i = obj;
					mutable_properties-->(i + 1) = pr;
					mutable_properties-->(i + 2) = val;
					mutable_properties-->(i + 3) = DefaultObjOfKind(obj).pr;
					return;
				}
				! Updating a mutable property
				if ( mutable_properties-->i == obj && mutable_properties-->(i + 1) == pr )
				{
					mutable_properties-->(i + 2) = val;
					return;
				}
				i = i + 4;
			}
			print "Error: no more mutable properties!^^";
		}
		else if (WhetherProvides(V, false, pr, true)) obj.pr = val;
	} else {
		if ((V < 1) || (V > obj.value_range))
			return RunTimeProblem(RTP_BADVALUEPROPERTY);
		if (obj provides pr) { (obj.pr)-->(V+COL_HSIZE) = val; }
	}
];
-) instead of "Write Value Property" in "RTP.i6t".

Include (-
[ GetEitherOrProperty obj pr	i res kind defaultval;
	if (obj == nothing) rfalse;
	if (pr<0) pr = ~pr;
	
	! Property of a Kind
	if ( metaclass(obj) == Class )
	{
		while ( i < MAX_MUT_PROPS_LEN )
		{
			! mutable property not set
			if ( mutable_properties-->i == 0 )
			{
				kind = DefaultObjOfKind(obj);
				if (pr<FBNA_PROP_NUMBER) { if (kind has pr) rtrue; rfalse; }
				if ((kind provides pr) && (kind.pr)) rtrue;
				rfalse;
			}
			
			! Retreive a mutable property
			if ( mutable_properties-->i == obj && mutable_properties-->(i + 1) == pr )
				return mutable_properties-->(i + 2);
			
			i = i + 4;
		}
		rfalse;
	}
	
	if (WhetherProvides(obj, true, pr, false)) {
		! Get the object's own property
		if (pr<FBNA_PROP_NUMBER) { if (obj has pr) res = 1; }
		else if ((obj provides pr) && (obj.pr)) res = 1;
		
		kind = KindOfObj( obj );
		
		! Non-mutable kind, return the object's own property
		if ( IsMutKind( kind ) == 0 )
			return res;
			
		! Search the mutable properties table
		while ( i < MAX_MUT_PROPS_LEN )
		{
			! mutable property not set
			if ( mutable_properties-->i == 0 )
				return res;
			
			! Retreive a mutable property
			if ( mutable_properties-->i == kind && mutable_properties-->(i + 1) == pr )
			{
				! Check if this object has a non-default property value and return it, otherwise return the kind's default value
				defaultval = mutable_properties-->(i + 3);
				if ( res == defaultval )
					return mutable_properties-->(i + 2);
				else
					return res;
			}
			i = i + 4;
		}
	}
];
-) instead of "Get Either-Or Property" in "RTP.i6t".

Include (-
[ SetEitherOrProperty obj pr negate adj	val i defaultobj defaultval;
	if (pr<0) { pr = ~pr; negate = ~negate; val = 1; }
	
	if ( metaclass(obj) == Class )
	{
		! Make this a mutable kind
		MakeMutKind( obj );
	
		! Add this property to the list of mutable properties
		while ( i < MAX_MUT_PROPS_LEN )
		{
			! New mutable property
			if ( mutable_properties-->i == 0 )
			{
				mutable_properties-->i = obj;
				mutable_properties-->(i + 1) = pr;
				mutable_properties-->(i + 2) = val;
				defaultobj = DefaultObjOfKind(obj);
				if (pr<FBNA_PROP_NUMBER) { if (defaultobj has pr) defaultval = 1; }
				else if ((defaultobj provides pr) && (defaultobj.pr)) defaultval = 1;
				mutable_properties-->(i + 3) = defaultval;
				return;
			}
			! Updating a mutable property
			if ( mutable_properties-->i == obj && mutable_properties-->(i + 1) == pr )
			{
				mutable_properties-->(i + 2) = val;
				return;
			}
			i = i + 4;
		}
		print "Error: no more mutable properties!^^";
	}
	
	if (adj) {
		(adj)(obj);
	} else if (WhetherProvides(obj, true, pr, true)) {
		if (negate) {
			if (pr<FBNA_PROP_NUMBER) give obj ~pr; else obj.pr = false;
		} else {
			if (pr<FBNA_PROP_NUMBER) give obj pr; else obj.pr = true;
		}
	}
];
-) instead of "Set Either-Or Property" in "RTP.i6t".

Section - Unit Tests (not for release) (for use with Simple Unit Tests by Dannii Willis)

To decide what K is the default value of (V - object):
	(- DefaultObjOfKind( {V} ) -).

Test Kind A is a kind of thing. There is a Test Kind A.
The description of a Test Kind A is usually "A".
A test kind A is usually plural-named.

Test Thing A is a Test Kind A.
Test Thing B is a Test Kind A.
The description of Test Thing B is "B".
Test Thing C is a Test Kind A.

Test Kind B is a kind of thing. There is a Test Kind B.

Unit test (this is the Mutable Kinds rule):
	[ Check that the original values of our test objects are correct ]
	[1] assert that the description of the default value of Test Kind A is "A";
	[2] assert that the description of Test Thing A is "A";
	[3] assert that the description of Test Thing B is "B";
	[4] assert that the description of Test Thing C is "A";
	[ Check that regular object modifications work ]
	now the description of Test Thing C is "C";
	[5] assert that the description of Test Thing C is "C";
	let A be the kind of Test Kind A;
	stop capturing text;
	now the description of A is "AA";
	[ Check that our new defaults are obeyed, but only for objects without a custom value]
	[6] assert that the description of the default value of Test Kind A is "AA";
	[7] assert that the description of Test Thing A is "AA";
	[8] assert that the description of Test Thing B is "B";
	[9] assert that the description of Test Thing C is "C";
	[ Check that kind objects work after getting another kind object ]
	let A be the kind of Test Kind A;
	let B be the kind of Test Kind B;
	now the description of A is "AAA";
	now the description of B is "BBB";
	[10] assert that the description of the default value of Test Kind A is "AAA";
	[11] assert that the description of the default value of Test Kind B is "BBB";
	[ And now the same for attributes ]
	[12] assert that (the default value of A is plural-named);
	[13] assert that (Test Thing A is plural-named);
	[14] assert that (A is plural-named);
	now A is singular-named;
	[15] assert that (the default value of A is singular-named);
	[16] assert that (Test Thing A is singular-named);
	[17] assert that (A is singular-named);
	
Mutable Kinds ends here.

---- DOCUMENTATION ----

This extension adds support for mutable kinds, allowing you to change the default value of a property at run-time.

It uses the default value of each kind (as shown in the index), which means you cannot modify it yourself. The easiest way to make a safe default value object is to use the "There is a..." phrase immediately after defining the kind:

	An apple is a kind of thing. There is an apple.

Use "the kind of ..." phrase to access a mutable kind. The properties can then be altered as usual:

	let A be the kind of apple;
	now the description of A is "Mmm, tasty!";

Obejcts with non-default property values will not be affected. However note that should a object's non-default property ever be set to the property's original default value, it will be treated from then on as if it had always had the default value, and will be affected by mutable kind property changes. This is especially the case with truth state values, so it is recommended that if you need to change a kind's truth state property you do not customise that property for any of the kind's objects.

There are two use options:

1. maximum mutable kinds - the number of mutable kinds, default is 5.
	
2. maximum mutable properties - the number of mutable properties, default is 5. These are shared between all mutable kinds, so by default you could change 1 property on 5 kinds, 5 properties on 1 kind, or something between those extremes.

These limits can be changed as usual:

	Use maximum mutable kinds of at least 10.
	Use maximum mutable properties of at least 10.

The latest version of this extension can be found at <https://github.com/i7/extensions>. This extension is released under the Creative Commons Attribution licence. Contact the author at <curiousdannii@gmail.com>

Example: * Time Machine - Stop time for everything else but yourself

The player carries a machine which somehow stops time for everyone other than themselves. Play with the machine and notice how the time the watch tells is always changing. This is because the watch's now property has been customised, whereas the other clocks get their time from the clock kind itself.

	*: "Time Machine"
	
	Shop is a room. "There are hundreds of clocks on every wall."
		
	A clock is a kind of thing. There is a clock.
	A clock has a time called now.
	The now of a clock is usually 10:00 am.

	Instead of examining a clock:
		say "It says [the now of the noun]."

	Every turn:
		increment the now of the watch;
		if the machine is switched off:
			let C be the kind of clock;
			increment the now of C;

	Here is a clock called a grandfather clock.
	Here is a clock called a stylish clock.
	Here is a clock called a sundial.

	The player wears a clock called a watch.
	The now of the watch is 11:00 am.

	The player carries a device called the machine.

	Test me with "x sundial/g/x watch/g/switch on machine/x sundial/g/x watch/g/switch off machine/x sundial/g/x watch/g".