Version 1/221012 of Formatting Capture by Daniel Stelzer begins here.

Include Text Capture by Eric Eve.

Section A - Escape Character

Use escape code of at least 167 translates as (- Constant ESCAPE_CODE = {N}; -).

Section B - Formatting Commands (in place of section SR5/1/7 - Saying - Fonts and visual effects in Standard Rules by Graham Nelson)

To say escape code: (- print (char) ESCAPE_CODE; -).

To say internal bold type -- running on:
	(- style bold; -).
To say internal italic type -- running on:
	(- style underline; -).
To say internal roman type -- running on:
	(- style roman; -).
To say internal fixed letter spacing -- running on:
	(- font off; -).
To say internal variable letter spacing -- running on:
	(- font on; -).

To display the boxed quotation (Q - text)
	(documented at ph_boxed):
	(- DisplayBoxedQuotation({-box-quotation-text:Q}); -).

To say bold type -- running on
	(documented at phs_bold):
	if text capturing is active, say "[escape code]b";
	otherwise say internal bold type.
To say italic type -- running on
	(documented at phs_italic):
	if text capturing is active, say "[escape code]i";
	otherwise say internal italic type.
To say roman type -- running on
	(documented at phs_roman):
	if text capturing is active, say "[escape code]r";
	otherwise say internal roman type.
To say fixed letter spacing -- running on
	(documented at phs_fixedspacing):
	if text capturing is active, say "[escape code]f";
	otherwise say internal fixed letter spacing.
To say variable letter spacing -- running on
	(documented at phs_varspacing):
	if text capturing is active, say "[escape code]v";
	otherwise say internal variable letter spacing.

Section C - Escape Detection Rules

The escape detection rules are a number based rulebook.
Escape detection for 98: say bold type.
Escape detection for 105: say italic type.
Escape detection for 114: say roman type.
Escape detection for 102: say fixed letter spacing.
Escape detection for 118: say variable letter spacing.

Part II - I6 Filtering (in place of Part 3 - I6 Code in Text Capture by Eric Eve)

[Unchanged]
Include (- Global capture_active = 0; -).

Section G - Safe Printing (for Glulx only)

[This part's unchanged]
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
-).

[This one's new]
Include (-
[ PrintCapture len i;
	len = captured_text-->0;
	i = 1;
	@push say__pc;
	say__pc = PARA_NORULEBOOKBREAKS;
	while(i <= len){
		if(captured_text-->i == ESCAPE_CODE){
			i++;
			FollowRulebook((+ escape detection rules +), captured_text-->i);
		}else{
			glk_put_char_uni(captured_text-->i);
		}
		i++;
	}
	@pull say__pc;
];
-).

Section Z - Safe Printing (for Z-machine only)

[This part's unchanged]
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
-).

[This one's new]
Include (-
[ PrintCapture len i;
	len = captured_text-->0;
	i = 2;
	@push say__pc;
	say__pc = PARA_NORULEBOOKBREAKS;
	while(i <= len+1){
		if(captured_text->i == ESCAPE_CODE){
			i++;
			FollowRulebook((+ escape detection rules +), captured_text->i);
		}else{
			print (char) captured_text->i;
		}
		i++;
	}
];
-).

Section F - FireVM (for Glulx Only) (for use with FyreVM Support by TextFyre)

[I don't know enough about FireVM to make this work unfortunately]
[So for now, FireVM is unsupported]

Formatting Capture ends here.

---- DOCUMENTATION ----

This is a patch to Text Capture by Eric Eve that preserves basic formatting. With this extension, capturing text will preserve bold, italic, roman, fixed-width, and variable-width formatting, and output it again when saying the captured text.

It does this by overriding [italic type] and its ilk to instead print an escape sequence when text capture is active: [escape code] followed by a single letter indicating the type of formatting. When the captured text is printed, any escape codes encountered are passed to the "escape detection rules", which turn them back into the appropriate formatting.

	*: "Echo Echo Echo"
	
	Include Formatting Capture by Daniel Stelzer.
	
	Mirror Gallery is a room. "Mirrors line the walls. You see every action reflected back at you many times over."
	
	[Record all the output resulting from the player's actions]
	First before doing anything except looking:
		start capturing text.
	[Then play it back twice over]
	First every turn:
		stop capturing text;
		say the captured text;
		say the captured text.
	
	[And of course we need to show off our formatting!]
	Instead of waiting: say "[bold type]Bold [italic type]Italic [roman type]Roman [fixed letter spacing]Fixed [variable letter spacing]Variable!".
	
	Test me with "z".
