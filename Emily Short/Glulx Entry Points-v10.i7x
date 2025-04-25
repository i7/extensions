Version 10.0.200602 of Glulx Entry Points (for Glulx only) by Emily Short begins here.

"Provides hooks to allow the author to write specialized multimedia behavior that would normally go through HandleGlkEvent. This is a rather dull utility library that will be of most use to authors wanting to write Glulx extensions compatible with other Glulx extensions already in use."

Use authorial modesty.

[Include version 1/160919 of Glulx Definitions by Dannii Willis.]

Chapter - Testing interpreter features (gestalts)

Include (-

[ GD_GlulxGestalt sel arg res;
	@gestalt sel arg res;
	return res;
];
-).

To decide what number is the glulx version:
	(- GD_GlulxGestalt( 0 ) -).

To decide what number is the interpreter version:
	(- GD_GlulxGestalt( 1 ) -).

To decide whether glulx memory resizing is supported:
	(- GD_GlulxGestalt( 2 ) -).

To decide whether glulx undo is supported:
	(- GD_GlulxGestalt( 3 ) -).

To decide whether glulx memory copying is supported:
	(- GD_GlulxGestalt( 6 ) -).

To decide whether glulx malloc is supported:
	(- GD_GlulxGestalt( 7 ) -).

To decide whether glulx function acceleration is supported:
	(- GD_GlulxGestalt( 9 ) -).

To decide whether glulx real numbers are supported:
	(- GD_GlulxGestalt( 11 ) -).



To decide what number is the glk version:
	(- glk_gestalt( gestalt_Version, 0 ) -).

To decide whether glk/glulx character input is supported:
	(- glk_gestalt( gestalt_CharInput, 0 ) -).

To decide whether glk/glulx line input is supported:
	(- glk_gestalt( gestalt_LineInput, 0 ) -).

To decide whether glk/glulx mouse input is supported:
	(- glk_gestalt( gestalt_MouseInput, 0 ) -).

To decide whether glk/glulx graphic-window mouse input is supported:
	(- glk_gestalt( gestalt_MouseInput, winType_Graphics ) -).

To decide whether glk/glulx text-grid mouse input is supported:
	(- glk_gestalt( gestalt_MouseInput, winType_TextGrid ) -).

To decide whether glk/glulx timekeeping is supported:
	(- glk_gestalt( gestalt_Timer, 0 ) -).

To decide whether glk/glulx graphics are/is supported:
	(- glk_gestalt( gestalt_Graphics, 0 ) -).

To decide whether glk/glulx text-buffer graphics are/is supported:
	(- glk_gestalt( gestalt_DrawImage, winType_TextBuffer ) -).

To decide whether glk/glulx graphic-window graphics are/is supported:
	(- glk_gestalt( gestalt_DrawImage, winType_Graphics ) -).

To decide whether glk/glulx basic/-- sounds/sound are/is supported:
	(- glk_gestalt( gestalt_Sound, 0 ) -).

To decide whether glk/glulx sound volume is supported:
	(- glk_gestalt( gestalt_SoundVolume, 0 ) -).

To decide whether glk/glulx sound notification is supported:
	(- glk_gestalt( gestalt_SoundNotify, 0 ) -).

To decide whether glk/glulx hyperlinks are supported:
	(- glk_gestalt( gestalt_Hyperlinks, 0 ) -).

To decide whether glk/glulx hyperlink input is supported:
	(- glk_gestalt( gestalt_HyperlinkInput, 0 ) -).

To decide whether glk/glulx mod sound is supported:
	(- glk_gestalt( gestalt_SoundMusic, 0 ) -).

To decide whether glk/glulx PNG transparency is supported:
	(- glk_gestalt( gestalt_GraphicsTransparency, 0 ) -).

To decide whether glk/glulx unicode is supported:
	(- glk_gestalt( gestalt_Unicode, 0 ) -).

To decide whether glk/glulx unicode normalization is supported:
	(- glk_gestalt( gestalt_UnicodeNorm, 0 ) -).

To decide whether glk/glulx line input echo suppression is supported:
	(- glk_gestalt( gestalt_LineInputEcho, 0 ) -).

To decide whether glk/glulx line input terminators are supported:
	(- glk_gestalt( gestalt_LineTerminators, 0 ) -).

To decide whether the/-- glk/glulx system clock is supported:
	(- glk_gestalt( gestalt_DateTime, 0 ) -).

To decide whether glk/glulx sounds are fully supported:
	(- glk_gestalt( gestalt_Sound2, 0 ) -).

To decide whether glk/glulx resource streams are supported:
	(- glk_gestalt( gestalt_ResourceStream, 0 ) -).

To decide whether glk/glulx graphics window character input is supported:
	(- glk_gestalt( gestalt_GraphicsCharInput, 0 ) -).



Chapter - Glulx and Glk kinds

Section - Events

A g-event is a kind of value.
The specification of a g-event is "The interpreter sends player actions as events".
The g-events are timer-event,
	char-event,
	line-event,
	mouse-event,
	arrange-event,
	redraw-event,
	sound-notify-event,
	hyperlink-event,
	volume-event.

[ Events which occur due to player actions are dependent on the player; all others are independent ]
Definition: a g-event is dependent on the player rather than independent of the player if
	it is char-event or
	it is line-event or
	it is mouse-event or
	it is hyperlink-event.

To decide which g-event is null-event:
	(- 0 -).

[Include version 1/160919 of Glk Object Recovery by Dannii Willis.]

Section - Glk object recovery

[ These should technically all be called 'glk' rulebooks, but we'll keep them named 'glulx' for compatibility. ]
The glulx zeroing-reference rules is a rulebook.
The glulx resetting-windows rules is a rulebook.
The glulx resetting-streams rules is a rulebook.
The glulx resetting-filerefs rules is a rulebook.
The glulx resetting-channels rules is a rulebook.
The glulx object-updating rules is a rulebook.

Current glulx rock is a number that varies.
Current glulx rock-ref is a number that varies.



Section - GGRecoverObjects

[ Rather than intercepting IdentifyGlkObject() as GEP does, replace GGRecoverObjects(). This allows us to move the built in I6 variable management to rules which can be replaced by other extensions if needed. ]

Include (-
! Replacement GGRecoverObjects from Glk Object Recovery by Dannii Willis
[ GGRecoverObjects ref;
	! Reset all Glk references as if none existed
	FollowRulebook( (+ glulx zeroing-reference rules +) );
	
	! Iterate through each of the windows, streams, file refs and sound channels
	while ( ref = glk_window_iterate( ref, gg_arguments ) )
	{
		(+ current glulx rock +) = gg_arguments-->0;
		(+ current glulx rock-ref +) = ref;
		FollowRulebook( (+ glulx resetting-windows rules +) );
	}
	ref = 0;
	while ( ref = glk_stream_iterate( ref, gg_arguments ) )
	{
		(+ current glulx rock +) = gg_arguments-->0;
		(+ current glulx rock-ref +) = ref;
		FollowRulebook( (+ glulx resetting-streams rules +) );
	}
	ref = 0;
	while ( ref = glk_fileref_iterate( ref, gg_arguments ) )
	{
		(+ current glulx rock +) = gg_arguments-->0;
		(+ current glulx rock-ref +) = ref;
		FollowRulebook( (+ glulx resetting-filerefs rules +) );
	}
	if ( glk_gestalt( gestalt_Sound, 0 ) )
	{
		ref = 0;
		while ( ref = glk_schannel_iterate( ref, gg_arguments ) )
		{
			(+ current glulx rock +) = gg_arguments-->0;
			(+ current glulx rock-ref +) = ref;
			FollowRulebook( (+ glulx resetting-channels rules +) );
		}
	}

	! Tell the game to tie up any loose ends
	FollowRulebook( (+ glulx object-updating rules +) );
	rfalse;
];
-) replacing "GGRecoverObjects".



Section - The built in object recovery rules

[ The following code was extracted from the original GGRecoverObjects() ]
The built in object zeroing rule is listed first in the glulx zeroing-reference rules.
The built in object zeroing rule translates into I6 as "GOR_zeroing".
Include (-
[ GOR_zeroing;
	gg_mainwin = 0;
	gg_statuswin = 0;
	gg_quotewin = 0;
	gg_scriptfref = 0;
	gg_scriptstr = 0;
	gg_savestr = 0;
	statuswin_cursize = 0;
	gg_foregroundchan = 0;
	gg_backgroundchan = 0;
	gg_commandstr = 0;
	gg_command_reading = false;
	rfalse;
];
-).

The identify built in windows rule is listed first in the glulx resetting-windows rules.
The identify built in windows rule translates into I6 as "GOR_indentify_windows".
Include (-
[ GOR_indentify_windows;
	switch ( (+ current glulx rock +) )
	{
		GG_MAINWIN_ROCK:
			gg_mainwin = (+ current glulx rock-ref +);
		GG_STATUSWIN_ROCK:
			gg_statuswin = (+ current glulx rock-ref +);
		GG_QUOTEWIN_ROCK:
			gg_quotewin = (+ current glulx rock-ref +);
	}
	rfalse;
];
-).

The identify built in streams rule is listed first in the glulx resetting-streams rules.
The identify built in streams rule translates into I6 as "GOR_indentify_streams".
Include (-
[ GOR_indentify_streams;
	switch ( (+ current glulx rock +) )
	{
		GG_SAVESTR_ROCK:
			gg_savestr = (+ current glulx rock-ref +);
		GG_SCRIPTSTR_ROCK:
			gg_scriptstr = (+ current glulx rock-ref +);
		GG_COMMANDWSTR_ROCK:
			gg_commandstr = (+ current glulx rock-ref +);
			gg_command_reading = false;
		GG_COMMANDRSTR_ROCK:
			gg_commandstr = (+ current glulx rock-ref +);
			gg_command_reading = true;
	}
	rfalse;
];
-).

The identify built in file refs rule is listed first in the glulx resetting-filerefs rules.
The identify built in file refs rule translates into I6 as "GOR_indentify_filerefs".
Include (-
[ GOR_indentify_filerefs;
	switch ( (+ current glulx rock +) )
	{
		GG_SCRIPTFREF_ROCK:
			gg_scriptfref = (+ current glulx rock-ref +);
	}
	rfalse;
];
-).

The identify built in sound channels rule is listed first in the glulx resetting-channels rules.
The identify built in sound channels rule translates into I6 as "GOR_indentify_schannels".
Include (-
[ GOR_indentify_schannels;
	switch ( (+ current glulx rock +) )
	{
		GG_FOREGROUNDCHAN_ROCK:
			gg_foregroundchan = (+ current glulx rock-ref +);
		GG_BACKGROUNDCHAN_ROCK:
			gg_backgroundchan = (+ current glulx rock-ref +);
	}
	if ( gg_foregroundchan ~= 0 )
	{
		glk_schannel_stop( gg_foregroundchan );
	}
	if ( gg_backgroundchan ~= 0 )
	{
		glk_schannel_stop( gg_backgroundchan );
	}
	rfalse;
];
-).

[Include version 1/160919 of Glk Events by Dannii Willis.]

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

The glulx input handling rules are a g-event based rulebook.



Section - Intercepting glk_select()

[ Rather than implementing HandleGlkEvent() as GEP did, we will intercept glk_select(). This allows us to intercept events before the Inform 7 template starts processing them. ]

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
	FollowRulebook( (+ the glulx input handling rules +), GE_Event_Struct_type, true );
	@pull say__pc; @pull say__p; @pull debug_rules;

	! Copy back to the original event structure
	event_struct-->0 = GE_Event_Struct_type;
	event_struct-->1 = GE_Event_Struct_win;
	event_struct-->2 = GE_Event_Struct_val1;
	event_struct-->3 = GE_Event_Struct_val2;
	return 0;
];
-) replacing "glk_select".



Section - Use option

[As of version 10, Glulx Entry Points has a somewhat more flexible approach to event handling than did earlier versions: Whereas the latter consulted one of eight separate rulebooks depending on the event type, Glulx Input Loops passes the event type into a single parametrized rulebook. This means, for example, that we can have a general rule for event handling that fires no matter what the event, alongside the usual event-based rules. It allows us to group events by broader type (e.g. events generated by the player vs. events generated by the system).

Many existing extensions are based on the older system, however, and we would break those extensions if we simply removed the older event-handling rulebooks. So, we retain them, and Glulx Entry Points will (by default) still pass event-handling to those rulebooks. This means that existing code will continue to work as before, and we can also use the new parameterized rulebook if we like.

This use option disables the old rulebooks, and should be used only when we know that we are not using an extension that depends on the old rulebooks.]

Use direct event handling translates as (- Constant DIRECT_GLK_EVENT_HANDLING; -).



Section - Global variables

Glulx replacement command is some indexed text that varies.

Library input context is a number variable. [This describes the event context in which input was received, e.g. whether the Inform library was awaiting line input or char input. If 0, the library was awaiting line input, if 1, char input. This is not as useful as an event-typed value would be; with such a value, we could detect any input context--e.g., we are waiting for hyperlink input. Perhaps a future version of Glulx Entry Points will discard the old convention in favor of a more expansive system.]



Section - Wrappers for event structure, return values, etc

To wait for glk input:
	(- glk_select(gg_event); -)

To decide whether the current input context is line input (deprecated):
	(- ( (+ library input context +) == 0 ) -)

To decide whether the current input context is char/character input (deprecated):
	(- ( (+ library input context +) == 1 ) -)
	
To decide which g-event is the current glk event (deprecated):
	decide on GEP internal current glk event.
	
To decide what number is the window of the current glk event (deprecated):
	(- GE_Event_Struct_win -)
	
To decide what number is the character code returned (deprecated):
	(- GE_Event_Struct_val1 -)

To decide what number is input replacement (deprecated):
	decide on GEP internal input replacement.

To decide what number is input continuation (deprecated):
	decide on GEP internal input continuation.


Section - Internal-use wrappers - unindexed

[These exist to avoid triggering deprecation warnings from our own code, which is a problem if "use no deprecated features" is active.]

To decide which g-event is the GEP internal current glk event:
	(- GE_Event_Struct_type -)

To decide what number is GEP internal input replacement:
	(- 2 -)

To decide what number is GEP internal input continuation:
	(- 1 -)


Section - Event Handling


The glulx input handling rules have outcomes replace player input (success) and require input to continue (success).

[This is an I7 version of the event handling that was included in the I6 HandleGlkEvent routine in previous versions of Glulx Entry Points, with minor changes to allow any event type to provide a replacement command. Converted to I7 code in version 10.]

To decide what number is the value returned by glk event handling (this is the handle glk event rule):
	now glulx replacement command is "";
	follow the glulx input handling rules for the GEP internal current glk event;
	if the outcome of the rulebook is the replace player input outcome:
		decide on GEP internal input replacement;
	if the outcome of the rulebook is the require input to continue outcome:
		decide on GEP internal input continuation;
	follow the command-counting rules;
	if the rule succeeded:
		follow the input-cancelling rules;
		follow the command-showing rules;
		follow the command-pasting rules;
		if the [command-pasting] rule succeeded:
			decide on GEP internal input replacement.


Section - HandleGlkEvent routine

Include (- Array evGlobal --> 4; -) before "Glulx.i6t".

[Include (- 

  [ HandleGlkEvent ev context abortres newcmd cmdlen i ;
      for (i=0:i<3:i++) evGlobal-->i = ev-->i;
      (+ library input context +) = context;
      return (+ value returned by glk event handling +) ;
  ];

-) before "Glulx.i6t".]


Section - Useful function wrappers

To update/redraw the/-- status line:
	(- DrawStatusLine(); -)

To print prompt:
	(- PrintPrompt(); -)



Section - Legacy rulebooks

The glulx timed activity rules is a rulebook.
The glulx redrawing rules is a rulebook.
The glulx arranging rules is a rulebook.
The glulx sound notification rules is a rulebook.
The glulx mouse input rules is a rulebook.
The glulx character input rules is a rulebook.
The glulx line input rules is a rulebook.
The glulx hyperlink rules is a rulebook.

[ These rules route input to the separate event-handling rulebooks originally used by older versions of Glulx Entry Points. They do nothing if we have activated the direct event handling use option. ]

Last glulx input handling rule for a timer-event when the direct event handling option is not active (this is the redirect to GEP timed activity rule):
	abide by the glulx timed activity rules.

Last glulx input handling rule for a char-event when the direct event handling option is not active (this is the redirect to GEP character input rule):
	abide by the glulx character input rules.

Last glulx input handling rule for a line-event when the direct event handling option is not active (this is the redirect to GEP line input rule):
	follow the glulx line input rules;
	if the rule succeeded:
		replace player input.

Last glulx input handling rule for a mouse-event when the direct event handling option is not active (this is the redirect to GEP mouse input rule):
	abide by the glulx mouse input rules.

Last glulx input handling rule for an arrange-event when the direct event handling option is not active (this is the redirect to GEP arranging rule):
	abide by the glulx arranging rules.

Last glulx input handling rule for a redraw-event when the direct event handling option is not active (this is the redirect to GEP redrawing rule):
	abide by the glulx redrawing rules.

Last glulx input handling rule for a sound-notify-event when the direct event handling option is not active (this is the redirect to GEP sound notification rule):
	abide by the glulx sound notification rules.

Last glulx input handling rule for a hyperlink-event when the direct event handling option is not active (this is the redirect to GEP hyperlink rule):
	abide by the glulx hyperlink rules.



Section - Debounce arrange events - unindexed

[ Gargoyle sends an arrange event while the user is dragging the window borders, but we really only want one event at the end. Debounce the arrange event to ignore the earlier ones. ]

[Arranging now in GEP is a truth state variable. Arranging now in GEP is false.

First glulx input handling rule for an arrange-event while arranging now in GEP is false (this is the debounce arrange event rule):
	let i be 0; [ for the I6 polling code to use ]
	let final return value be a number;
	let arrange again be true;
	[ Poll for further arrange events ]
	while 1 is 1:
		poll for events in GEP;
		if the current event number in GEP is 0:
			break;
		otherwise if the current glk event is an arrange-event:
			next;
		[ We have a different event ]
		otherwise:
			[ Run the arrange rules ]
			let temp event type be the current glk event;
			set the current glk event in GEP to an arrange-event;
			now final return value is the glulx input handling rules for an arrange event;
			set the current glk event in GEP to temp event type;
			now arrange again is false;
			now final return value is the value returned by glk event handling;
			break;
	[ Run the arrange rules if we didn't get another event type ]
	if arrange again is true:
		now final return value is the glulx input handling rules for an arrange event;
	[ Return values ]
	if final return value is input replacement:
		replace player input;
	if final return value is input continuation:
		require input to continue;
	rule fails;

To decide what number is the glulx input handling rules for an arrange event:
	let final return value be a number;
	now arranging now in GEP is true;
	now final return value is the value returned by glk event handling;
	now arranging now in GEP is false;
	decide on final return value;

To poll for events in GEP:
	(- glk_select_poll( gg_event ); for ( tmp_0 = 0 : tmp_0 < 3 : tmp_0++) { evGlobal-->tmp_0 = gg_event-->tmp_0; } -).

To decide what number is the current event number in GEP:
	(- evGlobal-->0 -).

To set the current glk event in GEP to (ev - a g-event):
	(- evGlobal-->0 = {ev}; -).]



Section - Command-counting rules

The command-counting rules are a rulebook.

A command-counting rule (this is the ordinary checking for content rule):
	if the number of characters in the glulx replacement command is 0, rule fails;
	rule succeeds.


Section - Input-cancelling rules
	
The input-cancelling rules are a rulebook.

An input-cancelling rule (this is the cancelling input in the main window rule):
	cancel line input in the main window;
	cancel character input in the main window;
	
To cancel line input in the/-- main window:
	(- glk_cancel_line_event(gg_mainwin, GLK_NULL); -)
	
To cancel character input in the/-- main window:
	(- glk_cancel_char_event(gg_mainwin); -)


Section - Command showing rules

The command-showing rules are a rulebook.

A command-showing rule (this is the print text to the input prompt rule):
	say input-style-for-glulx;
	say Glulx replacement command;
	say roman type;

To say input-style-for-Glulx: 
	(- glk_set_style(style_Input); -)
 

Section - Command pasting rules

The command-pasting rules are a rulebook. 

A command-pasting rule (this is the glue replacement command into parse buffer rule): 
	change the text of the player's command to the Glulx replacement command;
	rule succeeds.



Glulx Entry Points ends here.

---- Documentation ----

Please note that this extension is provided as a framework and as a basis for other extensions. Thanks to Eliuk Blau and Jon Ingold for pointing out some bugs in version 5, and to Erik Temple for the patch handling input cancellation that brings us to version 7.

Version 10/200602 was a trivial patch by Gavin Lambert to avoid the use of deprecated phrases within the extension itself, fixing compatibility with "use no deprecated features".

Chapter: Events

Glulx allows the author to set responses to certain events:

	Timer       - event repeated at fixed intervals
	CharInput   - keystroke input in a window
	LineInput   - full line of input in a window
	MouseInput  - mouse input in a window
	Arrange     - some windows sizes have changed
	Redraw      - graphic windows need redrawing
	SoundNotify - sound finished playing
	Hyperlink   - selection of a hyperlink in a window

As of version 10, Glulx Entry Points provides a rulebook, the "glulx input handling rules" so that the author can add responses to the these events without himself having to include any Inform 6 code. The glulx input handling rules is a parameterized rulebook, meaning that the author can specify which event or events a given rule responds to by specifying a kind of value, the "g-event". The g-events corresponding to the events types described above are:

	timer-event
	char-event
	line-event
	mouse-event
	arrange-event
	redraw-event
	sound-notify-event
	hyperlink-event

It is also possible to refer to groups of g-events using adjectives. Two adjectives are provided, though the user could of course create more. These are:

	independent of the player - includes timer events, sound notification events, arrange events, and redraw events.
	dependent on the player - includes all other events, i.e. the events that can only happen due to player input.

We can get basic information about the last event handled using these phrases:

	current glk event - the g-event type last handled.
	window of the current glk event - if the last event was associated with a window (char-event, line-event, mouse-event, or hyperlink-event), this contains the number of the window's glk reference.

The glulx input handling rulebook replaces the set of eight rulebooks defined in versions of Glulx Entry Points previous to version 9. These rulebooks, listed below, should be considered deprecated and may be removed in a future version of the extension, but for now they will still work just as they did in past versions:

	The glulx timed activity rules is a rulebook.
	The glulx redrawing rules is a rulebook.
	The glulx arranging rules is a rulebook.
	The glulx mouse input rules is a rulebook.
	The glulx character input rules is a rulebook.
	The glulx line input rules is a rulebook.
	The glulx sound notification rules is a rulebook.
	The glulx hyperlink rules is a rulebook.

If you are certain that you do not need these rulebooks in a project (i.e., you are not using extensions that employ them), you can stop Inform from calling them by declaring the use option:

	Use direct event handling.


Chapter: Replacement Commands 

One of the things we may want to do -- especially with mouse input or hyperlinks -- is generate a command for the player. To do this, we set the value of Glulx replacement command to whatever string of text we want to turn into the player's command. If we do this, Inform will treat whatever command we issued in "Glulx replacement command" as though the player had typed it at the command prompt. The extension Basic Hyperlinks builds on this infrastructure and provides an example of how to make use of these features. 

Because the Glulx replacement command is indexed text, it is possible to build on to the string automatically, if for some reason we need to auto-generate our recommended commands. 



Section: A Note on Sound Support

Currently Inform is not designed to support sound output properly across all systems. The Mac OS X IDE will not play sounds in-game, so if we are developing a sound-rich game on the Mac, we will need to test the sounds by releasing the game file and playing it on a separate interpreter; at the time of writing, the best Mac sound support was provided by Gargoyle.


Chapter: Useful Phrases

Two phrases that may be useful to those working with Glulx input/output are provided:

	update the status line - calls the Inform library's routine to refresh the status window
	print prompt - calls the Inform library's routine to print the command prompt


Example: * Input Handling - Very basic use of the glulx input handling rules. Shows how to detect events according to whether they are generated by player input, how to override the player's typed input with a replacement command, and how to use the "current glk event" phrase.

	Include version 10 of Glulx Entry Points by Emily Short.
	
	Use direct event handling.
	
	Glk Testing is a room.
	
	Glulx input handling rule for an independent of the player g-event:
	say "[bracket]Non-input event detected: [current glk event][close bracket][line break]".
		
	Glulx input handling rule for a dependent on the player g-event:
		say "[bracket]Player input detected: [current glk event][close bracket][line break]".
		
	Glulx input handling rule for a line-event:
		now the Glulx replacement command is "jump".


Example: * Working Without Sound - Printing a warning at the beginning of the game if the interpreter does not use sound.

	*: "Working Without Sound"

	Include Glulx Entry Points by Emily Short.

	Include Basic Screen Effects by Emily Short.

	First when play begins:
		unless glulx sound is supported:
			say "This game uses sound effects extensively. The interpreter you're using is unable to play sounds, so you will be missing part of the intended experience.
		
Would you like to continue anyway?";
			unless the player consents:
				stop game abruptly.

	Royal Albert Hall is a room.
	
	Test me with "listen".