Version 1.2 of Glk Input Suspending (for Glulx only) by Gavin Lambert begins here.

"Provides a mechanism to 'suspend' line and character inputs in progress to allow something to be printed, and then input resumed afterwards."

Include Glulx Entry Points by Emily Short.

Use authorial modesty.

Section - Simple Windows

[This section could be replaced by another extension that knows that Flexible Windows or another
 window manager is included, but I didn't want to depend on that here.  But note that even when
 actually using Flexible Windows you shouldn't need to replace this if you only ever accept
 keyboard input in the acting main window, as is typical.]

To decide which number is the main window's ref:
	(- gg_mainwin -).

To suspend the current glk input event:
	suspend the current glk input event in window ref (the main window's ref).
	
To resume the current glk input event:
	resume the current glk input event in window ref (the main window's ref).

To replace the current glk input event with text input (command - text), silently:
	if silently, replace the current glk input event in window ref (the main window's ref) with text input command, silently;
	otherwise replace the current glk input event in window ref (the main window's ref) with text input command.

Section - Input Suspending

[Anything said while input is suspended is captured, then printed below the original prompt
 (followed by a fresh prompt, for line input) when input is resumed or replaced.  Styles are not
 preserved in the captured text.]
To suspend the current glk input event in window ref (win - number):
	let suspended be false;
	if glk line-event for window ref win is pending:
		cancel pending glk line-event for window ref win;
		now suspended is true;
	if glk char-event for window ref win is pending:
		cancel pending glk char-event for window ref win;
		now suspended is true;
	if suspended is true, start capturing suspended output.

Section - Input Resuming/Replacement

[Call one or the other of these after suspending input.  Don't forget, or you can end up stalling the VM.]

To resume the current glk input event in window ref (win - number):
	replace the current glk input event in window ref win with text input "".

To replace the current glk input event in window ref (win - number) with text input (command - text), silently:
	show suspended output in window ref win;
	if command is empty:
		if glk line-event for window ref win is resumable:
			redraw the status line;
			resume glk line-event;
		otherwise if glk char-event for window ref win is resumable:
			resume glk char-event;
	otherwise if glk line-event for window ref win is resumable:
		acknowledge pending glk line-event for window ref win;
		if not silently, show the glk input event replacement command;
		change the text of the player's command to command;
		now the glk event type is line-event;
		now the glk event window ref is win;
		now the glk event value 1 is the number of characters in command;
		now the glk event value 2 is zero;
	otherwise if glk char-event for window ref win is resumable:
		acknowledge pending glk char-event for window ref win;
		now the glk event type is char-event;
		now the glk event window ref is win;
		now the glk event value 1 is keycode 1 of command;
		now the glk event value 2 is zero;
	[if one of these events is not resumable then it means nobody was looking for character or line
	 input at the time this was called; we don't have anyone to report the command to, so we have
	 to just discard it.]

Section - Input Display

[Allow for easy replacement of this section by another extension.]

To show the glk input event replacement (command - text):
	show suspended output in window ref (the main window's ref);
	say "[input-style-for-glulx][command][roman type][line break]".

Section - Event Acknowledgement

First glulx input handling rule for a line-event (this is the acknowledge successful line-event rule):
	echo completed glk line-event for window ref glk event window ref with length glk event value 1;
	acknowledge pending glk line-event for window ref glk event window ref.

First glulx input handling rule for a char-event (this is the acknowledge successful char-event rule):
	acknowledge pending glk char-event for window ref glk event window ref.

Section - Compatibility code (for use without Glulx Entry Points by Emily Short)

To update/redraw the/-- status line:
	(- DrawStatusLine(); -)

To print prompt:
	(- PrintPrompt(); -)

To say input-style-for-Glulx: 
	(- glk_set_style(style_Input); -)

Section - Utility

To decide what number is keycode (N - number) of (T - text):
	(- TEXT_TY_GetCharacterNumber({T}, {N}) -).

Section - Low Level - unindexed

To cancel pending glk line-event for window ref (W - number):
	(- glk_cancel_line_event({W}, GLK_NULL); -).

To cancel pending glk char-event for window ref (W - number):
	(- glk_cancel_char_event({W}); -).

To acknowledge pending glk line-event for window ref (W - number):
	(- acknowledge_glk_line_event({W}); -).

To echo completed glk line-event for window ref (W - number) with length (N - number):
	(- echo_glk_line_event({W}, {N}); -).

To start capturing suspended output:
	(- gis_start_capture(); -).

To show suspended output in window ref (W - number):
	(- gis_show_suspended_output({W}); -).

To acknowledge pending glk char-event for window ref (W - number):
	(- acknowledge_glk_char_event({W}); -).

To decide whether glk line-event for window ref (W - number) is idle:
	(- (captured_glk_line_event-->0 == 0 || captured_glk_line_event-->1 ~= ({W})) -).

To decide whether glk char-event for window ref (W - number) is idle:
	(- (captured_glk_char_event-->0 == 0 || captured_glk_char_event-->1 ~= ({W})) -).

To decide whether glk line-event for window ref (W - number) is pending:
	(- (captured_glk_line_event-->0 == 1 && captured_glk_line_event-->1 == ({W})) -).

To decide whether glk char-event for window ref (W - number) is pending:
	(- (captured_glk_char_event-->0 == 1 && captured_glk_char_event-->1 == ({W})) -).

To decide whether glk line-event for window ref (W - number) is resumable:
	(- (captured_glk_line_event-->0 == 2 && captured_glk_line_event-->1 == ({W})) -).

To decide whether glk char-event for window ref (W - number) is resumable:
	(- (captured_glk_char_event-->0 == 2 && captured_glk_char_event-->1 == ({W})) -).

To resume glk line-event:
	(- resume_glk_line_event(); -).

To resume glk char-event:
	(- resume_glk_char_event(); -).

[There really ought to be a more efficient way to do this...]
Include (-
[ TEXT_TY_GetCharacterNumber txt i  cp p ch;
	cp = txt-->0; p = TEXT_TY_Temporarily_Transmute(txt);
	if ((i<=0) || (i>TEXT_TY_CharacterLength(txt))) ch = 0;
	else ch = BlkValueRead(txt, i-1);
	TEXT_TY_Untransmute(txt, p, cp);
	return ch;
];
-).

Section - Lowest Level - unindexed

[This all assumes that only one window will have an active line-input or char-input event
 request at a time -- and that both will not be concurrently active.  This should normally
 be true due to how both keyboards and stories work, but it is not actually guaranteed by
 Glk itself.  Just avoid doing silly things and you should be fine.]

[We do however still keep the captured line and char events separate, because one supported
 use case is to interrupt one kind of input to do the other one and then resume the original.]

Include (-
Array captured_glk_line_event --> 6;
Array captured_glk_char_event --> 2;

[ resume_glk_line_event  win buf maxlen initlen;
	win = captured_glk_line_event-->1;
	buf = captured_glk_line_event-->2;
	maxlen = captured_glk_line_event-->3;
	initlen = captured_glk_line_event-->4;
	@push initlen;
	@push maxlen;
	@push buf;
	@push win;
	@glk 208 4 0;
	captured_glk_line_event-->0 = 1;
];

[ acknowledge_glk_line_event win;
	if (captured_glk_line_event-->1 == win) {
		captured_glk_line_event-->0 = 0;
	}
];

! The library does not echo when we requested with echo off, so print the
! completed line ourselves, as the Glk spec prescribes.
[ echo_glk_line_event win len  str;
	if (captured_glk_line_event-->0 ~= 1 || captured_glk_line_event-->1 ~= win) return;
	if (captured_glk_line_event-->5 == 0) return;
	str = glk_window_get_stream(win);
	glk_set_style_stream(str, style_Input);
	glk_put_buffer_stream(str, captured_glk_line_event-->2, len);
	glk_set_style_stream(str, style_Normal);
	glk_put_char_stream(str, 10);
];

Constant GIS_CAPTURE_LEN = 2048;
Array gis_capture_buf --> GIS_CAPTURE_LEN;
Array gis_capture_result --> 2;
Global gis_capture_str = 0;
Global gis_capture_old = 0;

[ gis_start_capture;
	if (gis_capture_str) return;
	gis_capture_old = glk_stream_get_current();
	gis_capture_str = glk_stream_open_memory_uni(gis_capture_buf, GIS_CAPTURE_LEN, filemode_Write, 0);
	glk_stream_set_current(gis_capture_str);
];

[ gis_show_suspended_output win  start len str line;
	if (gis_capture_str == 0) return;
	glk_stream_set_current(gis_capture_old);
	glk_stream_close(gis_capture_str, gis_capture_result);
	gis_capture_str = 0;
	len = gis_capture_result-->1;
	if (len > GIS_CAPTURE_LEN) len = GIS_CAPTURE_LEN;
	while (len > 0 && gis_capture_buf-->(len-1) == 10) len--;
	start = 0;
	while (start < len && gis_capture_buf-->start == 10) start++;
	if (start >= len) return;
	line = (captured_glk_line_event-->0 == 2 && captured_glk_line_event-->1 == win);
	str = glk_window_get_stream(win);
	glk_set_style_stream(str, style_Normal);
	! Without echo suppression, cancelling already ended the prompt line.
	if (~~(line && captured_glk_line_event-->5 == 0)) glk_put_char_stream(str, 10);
	glk_put_buffer_stream_uni(str, gis_capture_buf + start*WORDSIZE, len - start);
	glk_put_char_stream(str, 10);
	glk_put_char_stream(str, 10);
	if (line) {
		ClearParagraphing(17);
		PrintPrompt();
	}
];

[ resume_glk_char_event  win;
	win = captured_glk_char_event-->1;
	@push win;
	@glk 210 1 0;
	captured_glk_char_event-->0 = 1;
];

[ acknowledge_glk_char_event win;
	if (captured_glk_char_event-->1 == win) {
		captured_glk_char_event-->0 = 0;
	}
];
-).

Include (-
[ glk_request_line_event win buf maxlen initlen;
	captured_glk_line_event-->0 = 1;
	captured_glk_line_event-->1 = win;
	captured_glk_line_event-->2 = buf;
	captured_glk_line_event-->3 = maxlen;
	captured_glk_line_event-->4 = initlen;
	! Echo must be off before the request: glk_set_echo_line_event does not
	! affect a pending request, so suspending cannot toggle it mid-input.
	captured_glk_line_event-->5 = 0;
	if (glk_window_get_type(win) == wintype_TextBuffer && glk_gestalt(gestalt_LineInputEcho, 0)) {
		glk_set_echo_line_event(win, 0);
		captured_glk_line_event-->5 = 1;
	}
	@push initlen;
	@push maxlen;
	@push buf;
	@push win;
	@glk 208 4 0;
	return 0;
];
-) replacing "glk_request_line_event".

Include (-
[ glk_cancel_line_event win event;
	if (captured_glk_line_event-->0 == 1 && captured_glk_line_event-->1 == win) {
		if (event == GLK_NULL) event = gg_event;
		event-->0 = 0;
		@push event;
		@push win;
		@glk 209 2 0;
		! update captured initlen according to input thus far
		if (event-->0 == evtype_LineInput) {
			captured_glk_line_event-->4 = event-->2;
		}
		captured_glk_line_event-->0 = 2;
	} else {
		@push event;
		@push win;
		@glk 209 2 0;
		captured_glk_line_event-->0 = 0;
	}
	return 0;
];
-) replacing "glk_cancel_line_event".

Include (-
[ glk_request_char_event win;
	captured_glk_char_event-->0 = 1;
	captured_glk_char_event-->1 = win;
	@push win;
	@glk 210 1 0;
	return 0;
];
-) replacing "glk_request_char_event".

Include (-
[ glk_cancel_char_event win;
	if (captured_glk_char_event-->0 == 1 && captured_glk_char_event-->1 == win) {
		captured_glk_char_event-->0 = 2;
	} else {
		captured_glk_char_event-->0 = 0;
	}
	@push win;
	@glk 211 1 0;
	return 0;
];
-) replacing "glk_cancel_char_event".

Glk Input Suspending ends here.

---- DOCUMENTATION ----

This is an extremely-low-level extension intended only for people messing with Glk input events.

According to the Glk spec, it is illegal for anything to be printed to a window that is currently waiting for line or character input,  However, there are certain other kinds of event (such as mouse and hyperlink events) which are very likely to occur while otherwise waiting for input (usually line input); ordinarily this means that rules that handle these events cannot print anything, on pain of getting a fatal error (or simply ignored, depending on the interpreter).

Unfortunately, that can at times be quite inconvenient, for example if you're trying to debug these rules by printing things, or if Inform randomly decides that it wants to output a paragraph break for reasons known only to itself.

This extension monitors line and character input events, allowing you to detect if they're in progress.  It also allows you to cancel an event, do something else (such as printing text), and then resume the event.

(It does not presently intercept the Unicode-specific input events, but then currently the Inform library does not make use of these anyway.)

This is not invisible to the player (so do it sparingly) and outside of specific circumstances you can get the VM into trouble, so use with caution.

This extension also introduces an alternative method to replace the player's command from a Glk event than the one provided by Glulx Entry Points.  This method should be preferred as the latter has been broken at some point and doesn't actually work anyway.

Further documentation is not provided; read the source.  If you can't understand the source, you shouldn't be using this extension directly.

Example: * Compilation Check

This is just here to verify that this extension compiles without additional dependencies.

	*: "Compilation Check"
	
	Include Glk Input Suspending by Gavin Lambert.
	
	There is a room.
