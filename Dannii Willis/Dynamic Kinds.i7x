Version 1/121001 of Dynamic Kinds by Dannii Willis begins here.

"Dynamic Kinds can be changed at run-time"

[TODO: proper RTP for running out of dynamic properties]

Use maximum dynamic kinds of at least 5 translates as (- Constant MAX_DYN_KINDS = {N}; -). 
Use maximum dynamic properties of at least 5 translates as (- Constant MAX_DYN_PROPS = {N}; -). 

Include (-

! Stores the default value of each kind, each row is Kind, Default Object
Constant MAX_DYN_KINDS_LEN = MAX_DYN_KINDS * 2;
Array kind_defaults --> MAX_DYN_KINDS_LEN;

! Each row on the dynamic property table is: Kind, Prop, Value, Default Value
!Constant MAX_DYN_KINDS_PROPS = MAX_DYN_KINDS * MAX_DYN_PROPS;
Constant MAX_DYN_PROPS_LEN = MAX_DYN_PROPS * 4;
Array dynamic_properties --> MAX_DYN_PROPS_LEN;

-).

Section - Functions for accessing dynamic kinds

Include (-

! Find the kind of an object
[ KindOfObj obj;
	return KindHierarchy-->( ( obj.KD_Count ) * 2 );
];

! Find the kind of an object, and turn it into a dynamic kind
[ MakeDynKindFromObj obj	kind i;
	kind = KindHierarchy-->( ( obj.KD_Count ) * 2 );
	! Add this kind to kind_defaults
	while ( i < MAX_DYN_KINDS_LEN )
	{
		if ( kind_defaults-->i == kind )
			return kind;
		! New Kind!
		if ( kind_defaults-->i == 0 )
		{
			kind_defaults-->i = kind;
			kind_defaults-->(i + 1) = obj;
			return kind;
		}
		i = i + 2;
	}
	print "Error: too many dynamic kinds!^^";
	return kind;
];

! Check if an kind is dynamic
[ IsDynKind kind	i;
	while ( i < MAX_DYN_KINDS_LEN )
	{
		if ( kind_defaults-->i == kind )
			return 1;
		if ( kind_defaults-->i == 0 )
			return 0;
		i = i + 2;
	}
];

! Find the default object for a dynamic kind
[ DefaultObjOfKind kind	obj i;
	while ( i < MAX_DYN_KINDS_LEN )
	{
		if ( kind_defaults-->i == kind )
			return kind_defaults-->(i + 1);
		if ( kind_defaults-->i == 0 )
		{
			break;
		}
		i = i + 2;
	}
	print "Error: dynamic kind not found!^^";
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

Section - Phrases for accessing dynamic kinds

To decide which K is kind of/-- (kind - name of kind of value of kind K):
	(- MakeDynKindFromObj( {-default-value-for:kind} ) -).

Section - Implementing dynamic kinds

Include (-
[ GProperty K V pr	obj i kind val defaultval;
	if (K == OBJECT_TY) obj = V; else obj = KOV_representatives-->K;
	if (obj == 0) { RunTimeProblem(RTP_PROPOFNOTHING, obj, pr); rfalse; }
	
	! Property of a Kind
	if ( metaclass(obj) == Class )
	{
		while ( i < MAX_DYN_PROPS_LEN )
		{
			! Dynamic property not set
			if ( dynamic_properties-->i == 0 )
			{
				return DefaultObjOfKind(obj).pr;
			}
			! Retreive a dynamic property
			if ( dynamic_properties-->i == obj && dynamic_properties-->(i + 1) == pr )
			{
				return dynamic_properties-->(i + 2);
			}
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
				
				! Non-dynamic kind, return the object's own property
				if ( IsDynKind( kind ) == 0 )
					return val;
					
				! Search the dynamic property table
				while ( i < MAX_DYN_PROPS_LEN )
				{
					! Dynamic property not set
					if ( dynamic_properties-->i == 0 )
					{
						return val;
					}
					! Retreive a dynamic property
					if ( dynamic_properties-->i == kind && dynamic_properties-->(i + 1) == pr )
					{
						! Check if this object has a non-default property value and return it, otherwise return the kind's default value
						defaultval = dynamic_properties-->(i + 3);
						if ( val == defaultval )
							return dynamic_properties-->(i + 2);
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
			! Add this property to the list of dynamic properties
			while ( i < MAX_DYN_PROPS_LEN )
			{
				! New dynamic property
				if ( dynamic_properties-->i == 0 )
				{
					dynamic_properties-->i = obj;
					dynamic_properties-->(i + 1) = pr;
					dynamic_properties-->(i + 2) = val;
					dynamic_properties-->(i + 3) = DefaultObjOfKind(obj).pr;
					return;
				}
				! Updating a dynamic property
				if ( dynamic_properties-->i == obj && dynamic_properties-->(i + 1) == pr )
				{
					dynamic_properties-->(i + 2) = val;
					return;
				}
				i = i + 4;
			}
			print "Error: no more dynamic properties!^^";
		}
		else if (WhetherProvides(V, false, pr, true)) obj.pr = val;
	} else {
		if ((V < 1) || (V > obj.value_range))
			return RunTimeProblem(RTP_BADVALUEPROPERTY);
		if (obj provides pr) { (obj.pr)-->(V+COL_HSIZE) = val; }
	}
];
-) instead of "Write Value Property" in "RTP.i6t".

Section - Unit Tests (not for release) (for use with Simple Unit Tests by Dannii Willis)

To decide what K is the default value of (V - object):
	(- DefaultObjOfKind( {V} ) -).

Test Kind A is a kind of thing. There is a Test Kind A.
The description of a Test Kind A is usually "A".

Test Thing A is a Test Kind A.
Test Thing B is a Test Kind A.
The description of Test Thing B is "B".
Test Thing C is a Test Kind A.

Test Kind B is a kind of thing. There is a Test Kind B.

Unit test (this is the Dynamic Kinds rule):
	[ 1-4: Test that the original values of our test objects are correct ]
	assert that the description of the default value of Test Kind A is "A";
	assert that the description of Test Thing A is "A";
	assert that the description of Test Thing B is "B";
	assert that the description of Test Thing C is "A";
	[ 5: Test that regular object modifications work ]
	now the description of Test Thing C is "C";
	assert that the description of Test Thing C is "C";
	let A be the kind of Test Kind A;
	now the description of A is "AA";
	[ 6-9: Check that our new defaults are obeyed, but only for objects without a custom value ]
	assert that the description of the default value of Test Kind A is "AA";
	assert that the description of Test Thing A is "AA";
	assert that the description of Test Thing B is "B";
	assert that the description of Test Thing C is "C";
	[ 10-13: Test that kind objects work after getting another kind object ]
	let A be the kind of Test Kind A;
	let B be the kind of Test Kind B;
	say default value of A;
	assert that the captured output is "Test Kind A";
	say default value of B;
	assert that the captured output is "Test Kind B";
	now the description of A is "AAA";
	now the description of B is "BBB";
	assert that the description of the default value of Test Kind A is "AAA";
	assert that the description of the default value of Test Kind B is "BBB";
	
Dynamic Kinds ends here.

---- DOCUMENTATION ----

This extension adds support for dynamic kinds, allowing you to change the default value of a property at run-time.

It uses the default value of each kind (as shown in the index), which means you cannot modify it yourself. The easiest way to make a safe default value object is to use the "There is a..." phrase immediately after defining the kind:

	An apple is a kind of thing. There is an apple.

Use "the kind of ..." phrase to access a dynamic kind. The properties can then be altered as usual:

	let A be the kind of apple;
	now the description of A is "Mmm, tasty!";

There are two use options:

1. maximum dynamic kinds - the number of dynamic kinds, default is 5
	
2. maximum dynamic properties - the number of dynamic properties, default is 5. These are shared between all dynamic kinds, so by default you could change 1 property on 5 kinds, 5 properties on 1 kind, or something between those extremes.

These limits can be changed as usual:

	Use maximum dynamic kinds of at least 10.
	Use maximum dynamic properties of at least 10.

The latest version of this extension can be found at <https://github.com/i7/extensions>. This extension is released under the Creative Commons Attribution licence. Contact the author at <curiousdannii@gmail.com>

Example: * Time Machine - Stop time for everyone else but yourself

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