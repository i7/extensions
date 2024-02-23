Version 2/200807 of Glk Events (for Glulx only) by Dannii Willis begins here.

"A low level event handling system"

Use authorial modesty.

Include version 1/160919 of Glulx Definitions by Dannii Willis.



Chapter - Basic event handling

Section - Event result variables

Include (-
Global GE_Event_Struct_type;
Global GE_Event_Struct_win;
Global GE_Event_Struct_val1;
Global GE_Event_Struct_val2;
-) before "Glulx.i6t".

The glk event type is a g-event variable.
The glk event type variable translates into I6 as "GE_Event_Struct_type".
The glk event window ref is a number variable.
The glk event window ref variable translates into I6 as "GE_Event_Struct_win".
The glk event value 1 is a number variable.
The glk event value 1 variable translates into I6 as "GE_Event_Struct_val1".
The glk event value 2 is a number variable.
The glk event value 2 variable translates into I6 as "GE_Event_Struct_val2".



Section - The glulx input handling rules

[Event handling without any bells or whistles]
The glk event processing rules are a g-event based rulebook.

[This rulebook was originally part of Glulx Entry Points.]
The glulx input handling rules are a g-event based rulebook.

[If Glulx Entry Points is not included, treat input handling rules as event processing rules.]
A glk event processing rule for a g-event (called the event) (this is the glk event compatibility rule):
	abide by the glulx input handling rules for the event.


Section - Intercepting glk_select()

[ Rather than implementing HandleGlkEvent() as GEP did, we will intercept glk_select(). This allows us to intercept events before the Inform 7 template starts processing them. ]
Include (-
Replace glk_select;
-) before "Glulx.i6t".

Include (-
! Replacement function from Glk Events by Dannii Willis
[ glk_select event_struct;
	! Call the real glk_select
	@push event_struct;
	@glk 192 1 0;
	
	! Copy values to our variables
	GE_Event_Struct_type = event_struct-->0;
	GE_Event_Struct_win = event_struct-->1;
	GE_Event_Struct_val1 = event_struct-->2;
	GE_Event_Struct_val2 = event_struct-->3;
	
	! Run the glulx input handling rules (but disable rules debugging because it crashes if keyboard input events are pending)
	@push debug_rules; @push say__p; @push say__pc;
	debug_rules = false; ClearParagraphing(1);
	FollowRulebook( (+ the glk event processing rules +), GE_Event_Struct_type, true );
	@pull say__pc; @pull say__p; @pull debug_rules;

	! Copy back to the original event structure
	event_struct-->0 = GE_Event_Struct_type;
	event_struct-->1 = GE_Event_Struct_win;
	event_struct-->2 = GE_Event_Struct_val1;
	event_struct-->3 = GE_Event_Struct_val2;
	return 0;
];
-) after "Infglk" in "Glulx.i6t".



Glk Events ends here.