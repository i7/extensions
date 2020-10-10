Version 8 of Text Capture by Eric Eve begins here.

"Allows the capture of text that would otherwise be sent to the screen, so that the text can be further manipulated, displayed at some other point, or simply discarded. Version 6/120511 allows the use of unicode in Glulx."

"with contributions from Dannii Willis"

Part 1 - Define a Use Option

Use maximum capture buffer length of at least 256 translates as (- Constant CAPTURE_BUFFER_LEN = {N}; -). 

Part 2 - Define Our Four Phrases (for use without FyreVM Support by TextFyre)

To decide whether text capturing is active: (- (capture_active > 0) -).

To start capturing text:
	(- StartCapture(); -).

To stop capturing text:
	(- EndCapture(); -).

To say the/-- captured text:
	(- PrintCapture(); -).

Part 2F - FyreVM phrases (for use with FyreVM Support by TextFyre)

To decide whether text capturing is active: (- (capture_active > 0) -).

To start capturing text:
	(- FyreVMStartCapture(); -).

To stop capturing text:
	(- FyreVMEndCapture(); -).

To say the/-- captured text:
	(- FyreVMPrintCapture(); -).
  
Part 3 - I6 Code

Include (-	Global capture_active = 0;	-).

Chapter Z - Z-Machine Version (for Z-Machine Only)

Include (-

Array captured_text -> CAPTURE_BUFFER_LEN + 3;

[ StartCapture;
	if (capture_active ==1)
		return;
	capture_active = 1;
	@output_stream 3 captured_text;
];


[ EndCapture;
	if (capture_active == 0)
		return;
	capture_active = 0;
	@output_stream -3;
	if (captured_text-->0 > CAPTURE_BUFFER_LEN)
	{
		print "Error: Overflow in EndCapture.^";
	}
];

[ PrintCapture len i;
	len = captured_text-->0;
	for ( i = 0 : i < len : i++ )
	{
		print (char) captured_text->(i + 2);
	}
];

-).

Chapter G - Glulx (for Glulx Only)

Include (-

Array captured_text --> CAPTURE_BUFFER_LEN + 1;

Global text_capture_old_stream = 0;
Global text_capture_new_stream = 0;

[ StartCapture i;   
	if (capture_active ==1)
		return;
	capture_active = 1;
	text_capture_old_stream = glk_stream_get_current();
	text_capture_new_stream = glk_stream_open_memory_uni(captured_text + WORDSIZE, CAPTURE_BUFFER_LEN, 1, 0);
	glk_stream_set_current(text_capture_new_stream);
];

[ EndCapture len;
	if ( capture_active == 0 )
		return;
	capture_active = 0;
	glk_stream_set_current(text_capture_old_stream);
	@copy $ffffffff sp;
	@copy text_capture_new_stream sp;
	@glk $0044 2 0; ! stream_close
	@copy sp len;
	@copy sp 0;
	captured_text-->0 = len;
	if (len > CAPTURE_BUFFER_LEN)
	{
		captured_text-->0 = CAPTURE_BUFFER_LEN;
	}
];

[ PrintCapture len i;
	len = captured_text-->0;
	for ( i = 0 : i < len : i++ )
	{
		glk_put_char_uni(captured_text-->(i + 1));
	}
];

-).

Chapter F - FyreVM Support (for Glulx Only) (for use with FyreVM Support by TextFyre)

[ Does OpenOutputBuffer support unicode? Assuming not. ]

Include (-

[ FyreVMStartCapture;
	if (is_fyrevm)
	{
		if (capture_active > 0)
			return;
		capture_active = 1;
		OpenOutputBuffer(captured_text + WORDSIZE, CAPTURE_BUFFER_LEN);
		return;
	}
	StartCapture();     
];


[ FyreVMEndCapture len;
	if(is_fyrevm)
	{
		if (capture_active == 0)
			return;
		capture_active = 0;
		len = CloseOutputBuffer(0);
		captured_text-->0 = len;
		if (len > CAPTURE_BUFFER_LEN)
		{
			captured_text-->0 = CAPTURE_BUFFER_LEN;
		}
		return;
	}
	EndCapture(); 
];

[ FyreVMPrintCapture len i;
	len = captured_text-->0;
	for ( i = 0 : i < len : i++ )
	{
		print (char) captured_text->(i + 4);
	}
];

-).

Text Capture ends here.

---- DOCUMENTATION ----

This extension defines four new phrases:

	start capturing text
	stop capturing text
	say captured text
	if text capturing is active

The first and second of these phrases allow you to capture any text before it is sent to the screen. The captured text can subsequently be displayed (or copied to an indexed text variable) using the third of these phrases.

A typical situation where this is useful is when we want to not only suppress the standard report from an action (with 'silently') but any failure reports as well. A typical pattern would be:

	start capturing text;
	silently try taking the noun;
	stop capturing text;

If it proved impossible to take the noun (because it was fixed in place or locked in a glass container, say), the failure message would not be displayed, and the action would be completely silent. The failure message would still be available however; we could either display it at some other point with:

	say captured text;

Or store it in an indexed text variable for later use:

	now mytextvar is "[captured text]";

The test "if text capturing is active" can be used to determing whether or text capturing is currently in progress. The phrases "start capturing text" and "stop capturing text" effectively make this check in any case, so that issuing "start capturing text" when text capturing is already active does nothing, as does "stop capturing text" when text capturing is not active.

LIMITATIONS

1.  The extension uses only a single text buffer, and each time a start capturing text/output something/stop capturing text sequence is executed, the buffer contents will be overwritten. You can get round this by copying the contents of the buffer to an indexed text variable, as shown above.

2.  By default the text capture buffer has a maximum length of 256 characters, so it should only be used for fairly short pieces of text. Overflowing the buffer will cause a run-time error in Z-Code games, and the loss of all characters beyond the 256th in Glulx games. If a larger buffer is needed, use the maximum capture buffer length option:

	Use maximum capture buffer length of at least 512.

3.  Beware of using certain debugging verbs such as RULES or RULES ALL whenever text capturing might become active, since their output will be captured as well, which will almost certainly overflow the buffer.

Example: * Intelligent Putting - Using text capture to improve implicit take messages.

It generally makes for smoother game-play if commands like PUT BALL IN BOX or PUT BOX ON TABLE perform an implicit take when the object to be put somewhere isn't already held. We generally do this by saying "(first taking the whatever)" and then using 'silently try taking the whatever' to attempt the implicit take. 

If, however, the attempted take  doesn't succeed (perhaps because the object we're trying to take is fixed in place), then a message like "(first taking the whatever)" is a little misleading, since we have not in fact taken the object in question, we have merely attempted to do so. In this situation "(first trying to take the whatever)" would be more appropriate. The difficulty is that we don't know whether 'silently try taking the whatever' will succeed until we try it, so we don't know whether we want "first taking..." or "first trying to take..." until we've tried to take the object and maybe seen a message explaining why we can't; but we'd then want "(first trying to take the whatever)" to be displayed before the message explaining why it couldn't be taken.

One way round this is to capture the output from the take action, then test whether it succeeded so we can decide what form of the implicit take message to use, and only then display the captured message if we need to explain why the take failed.

	*: "Intelligent Putting"

	Include Text Capture by Eric Eve

	Part 1 - Implicit Taking Mechanism

	Before putting something on something when the noun is not carried:
	 if the noun is on the second noun,
	     say "[The noun] [are] already on [the second noun]." instead;
	 take the noun implicitly;
	 if the noun is not carried, stop the action.

	Before inserting something into something when the noun is not carried:
	 if the noun is in the second noun,
	     say "[The noun] [are] already in [the second noun]." instead;
	 take the noun implicitly;
	 if the noun is not carried, stop the action.

	To take (obj - a thing) implicitly:
	  start capturing text; 
	  silently try taking the obj;
	  stop capturing text;
	  say "(first [if the obj is carried]taking[otherwise]trying to take[end if] [the obj])[command clarification break]";
	  if the obj is not carried, say captured text.

	Part 2 - Scenario

	The Lumber Room is a Room. "The Junk of decades has accumulated here."
	
	A large wooden table is here.

	A small red box is on the table. It is an openable open container.

	An old black comb is here.
	A spare sock is here.

	A bust of King George V is here.
            Instead of taking the bust: say "The bust is too heavy for you to lift."

	Test me with "put comb in box/put sock on table/put table in box/put bust on table."
