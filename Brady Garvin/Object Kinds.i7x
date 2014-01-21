Version 1 of Object Kinds by Brady Garvin begins here.

"The ability to treat object kinds as values."

[Based on RTP.i6t and The Inform Technical Manual.]

Chapter "Object Kinds as Values"

An object kind is a kind of value.
Object Kind #9999 specifies an object kind.  [I opt for an arithmetic kind of value to prevent authors from giving kinds properties; at the moment, that isn't supported.]

To decide what object kind is the generic object kind: (- 0 -).

Chapter "The Spare Object"

The spare object is an object.

Chapter "Counting Object Kinds on the Z-Machine" (for Z-Machine only)

To decide what object kind is the last object kind: (- (#highest_class_number - 5) -).

Chapter "Counting Object Kinds in Glulx" (for Glulx only)

Include (-
	Global get_last_object_kind = compute_and_get_last_object_kind;
-) after "Definitions.i6t".

Include (-
	Global last_object_kind;
	[ compute_and_get_last_object_kind i result;
		result = 0;
		for (i = K0_kind: i: i = i-->6) ++result;
		get_last_object_kind = just_get_last_object_kind;
		return last_object_kind = result;
	];
	[ just_get_last_object_kind;
		return last_object_kind;
	];
-).

To decide what object kind is the last object kind: (- get_last_object_kind() -).

Chapter "Operations on Object Kinds"

Include (-
	[ object_kind_is_valid kind;
		return kind >= 0 && kind <= (+ the last object kind +);
	];
-).

Definition: an object kind is valid rather than invalid if I6 routine "object_kind_is_valid" says so (it is at least zero, the minimum object kind, and at most the maximum object kind).

To repeat with (I - a nonexisting object kind variable) running through object kinds begin -- end: (- for({I} = 1: {I} < (+ the last object kind +): ++{I}) -).

To decide what object kind is the parent of (K - an object kind): (- KindHierarchy-->({K} * 2 + 1) -).

To decide what list of object kinds is the children of (K - an object kind):
	let the result be a list of object kinds;
	repeat with the candidate running through object kinds:
		if the parent of the candidate is K:
			add the candidate to the result;
	decide on the result.

To say the singular of (K - an object kind): (-
	switch ({K}) {
		0: print "object";
		default: print (I7_Kind_Name)(KindHierarchy-->(2 * {K}));
	}
-).
To say the plural of (K - an object kind): (-
	switch ({K}) {
		0: print "objects";
		1: print "rooms";
		2: print "things";
		default:
			((+ the spare object +).&2)-->0 = KindHierarchy-->(2 * {K});
			print (string)(+ the spare object +).(KindHierarchy-->(2 * {K}))::plural;
	}
-).

Chapter "Identifying Object Kinds from Descriptions"

Cached object kind identification relates various descriptions of objects to one object kind.

[At present, declaring something as an object actually makes it a thing.  So we have to write the kind property twice below.]
To make the spare object temporarily behave as if it has the kind (K - an object kind): (-
	((+ the spare object +).&2)-->0 = KindHierarchy-->(2 * {K});
	((+ the spare object +).&2)-->1 = KindHierarchy-->(2 * {K});
-).

To decide what object kind is the object kind for (D - a description of values of kind K):
	let the test object be an object;
	now the test object is the spare object;
	if D relates to an object kind by the cached object kind identification relation:
		decide on the object kind that D relates to by the cached object kind identification relation;
	repeat with the candidate running through object kinds:
		make the spare object temporarily behave as if it has the kind candidate;
		if the test object matches D:
			now the cached object kind identification relation relates D to the candidate;
			decide on the candidate;
	now the cached object kind identification relation relates D to the generic object kind;
	decide on the generic object kind.

Chapter "Relating Objects and Object Kinds"

To decide what object kind is the object kind of (O - an object): (- ({O}.KD_Count) -).
To decide whether (O - an object) is of kind (K - an object kind): (- ({O} ofclass (KindHierarchy-->(2 * {K}))) -).

Object Kinds ends here.

---- DOCUMENTATION ----

When Object Kinds is included, we can treat the kinds of objects as values in
their own right.  Ordinarily we write these values using the syntax

	the object kind for (K - a kind name in the plural)

For instance,

	showme the object kind for things;

will print

	Object Kind #2

because "thing" is the third kind defined by Inform ("object" is Object Kind #0,
and room is Object Kind #1).  We can also write kinds by number, though this is
less usually useful:

	showme Object Kind #2;

will give the same output.

In the latter case, it may be useful to test

	if (K - an object kind) is valid:
		....

or

	if (K - an object kind) is invalid:
		....

because the extension's other phrases are liable to produce error messages if we
give them an object kind that doesn't actually exist.

Other ways to obtain object kinds are via the loop

	repeat with (I - a nonexisting object kind variable) running through object kinds:
		....

or by asking an object for its kind:

	the object kind of (O - an object)

Once we have a kind, we can get its parent, which is its direct superkind, or
"object" if none exists:

	the parent of (K - an object kind)

as well as a list of its children (its direct subkinds):

	the children of (K - an object kind)

It is also possible to test whether an object has a certain kind:

	if (O - an object) is of kind (K - an object kind):
		....

and to say the preferred singular and plural forms:

	say "[the singular of (K - an object kind)]"

	say "[the plural of (K - an object kind)]"

Example: * Object Kinds Demonstration - Printing a summary of the story's kind hierarchy.

	*: "Object Kinds Demonstration"

	Include Object Kinds by Brady Garvin.

	There is a room.
	A pteranodon is a kind of animal; a military-grade flying hamster ball is a kind of device.
	When play begins:
		say "Object kind of the player: [the singular of the object kind of the player].";
		say "Object kind of pteranodons: [the singular of the object kind for pteranodons].";
		repeat with I running through object kinds:
			say "[the singular of I] / [the plural of I]: kind of [the singular of the parent of I].[line break]    Children kinds: ";
			let child printed be false;
			repeat with J running through the children of I:
				say "[if child printed is true], [end if][the singular of J]";
				now child printed is true;
			if child printed is false:
				say "(none)";
			say ".[line break]    Whether the player is of this kind: [whether or not the player is of kind I].";
