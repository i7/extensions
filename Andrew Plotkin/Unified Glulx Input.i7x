Version 3/160213 of Unified Glulx Input (for Glulx only) by Andrew Plotkin begins here.

[### To do: (rough order of importance)
- a way for user-level code to fake in an event
- status-window support
- TEST support for other event types

- multiple-window support
- should event/buffer info linger after the rulebooks run? would simplify code that calls AwaitInput, and also you could see more stuff at after-reading time
- noecho flag and whatever it enables
- input termination keys
- write more examples (see todo notes)
- add the discardundo model
]

Chapter - Constants and Variables

Section - Basic Types

Use pass blank input lines translates as (- Constant PASS_BLANK_INPUT_LINES; -). 

[Input-contexts allow us to organize the rulebooks described in this extension. Every time the game stops to await input, it does so in an input context.]

An input-context is a kind of value. The input-contexts are primary context, disambiguation context, yes-no question context, extended yes-no question context, repeat yes-no question context, final question context, keystroke-wait context.

Definition: an input-context is command if it is primary context or it is disambiguation context.
Definition: an input-context is yes-no if it is yes-no question context or it is extended yes-no question context or it is repeat yes-no question context.

[We need a proxy object for each Glk window. Currently we just define two. (This extension is not yet compatible with Multiple Windows.)]

A glk-window is a kind of object.
The story-window is a glk-window.
The status-window is a glk-window.

[When setting up input (in a particular context), the game indicates which input requests each window should make. These are the input-request and hyperlink-input-request properties.]

A text-input-mode is a kind of value. The text-input-modes are no-input, char-input, line-input.
A glk-window has a text-input-mode called the input-request.
A glk-window has a text called the preload-input-text.
A glk-window can be hyperlink-input-request.
A glk-window can be mouse-input-request.

[Timer input is global -- not attached to any window. The timer-request variable is in milliseconds, or 0 for no timer events.]

The timer-request is a number that varies. The timer-request is 0.

[These I6 properties are used internally by the library to track whether specific Glk requests have been made or fulfilled. The game should never touch these.]

Include (-
	with current_input_request (+ no-input +), ! of type text-input-mode
	with current_hyperlink_request false,      ! true or false
	with current_mouse_request false,          ! true or false
-) when defining a glk-window.

Include (-
! Milliseconds, or 0 for no timer events.
Global current_timer_request = 0;
-) after "Variables and Arrays" in "Glulx.i6t";

[These values match up to evtype_Timer, evtype_CharInput, etc because they are defined in the same order.]
A g-event is a kind of value. The g-events are timer-event, char-event, line-event, mouse-event, arrange-event, redraw-event, sound-notify-event, and hyperlink-event.

To decide which g-event is null-event: (- 0 -)

To say hyperlink (O - object): (- if (glk_gestalt(gestalt_Hyperlinks, 0)) { glk_set_hyperlink({O}); } -).
To say hyperlink (N - number): (- if (glk_gestalt(gestalt_Hyperlinks, 0)) { glk_set_hyperlink({N}); } -).
To say /hyperlink: (- if (glk_gestalt(gestalt_Hyperlinks, 0)) { glk_set_hyperlink(0); } -).


Section - A Few Globals

[These event structures are now used in parallel with the buffer and parse arrays. For example, we'll call ParserInput(context, inputevent, buffer, parse) or ParserInput(context, inputevent2, buffer2, parse2).]

Include (-
Array inputevent --> 4;
Array inputevent2 --> 4;
-) after "Variables and Arrays" in "Glulx.i6t";

[Indicates whether the parser_results has been filled in by ParserInput (and thus we need no text parsing).]

Include (-
Global parser_results_set;
-) after "Global Variables" in "Output.i6t";


Section - Input Rulebook Data

[Globals used within the accepting input and handling input rulebooks. (Logically, these could be rulebook variables, but that turns out to be awkward. In several ways.)]

Include (-
! Array contains: a_event, a_buffer, a_table
Constant INPUT_RULEBOOK_SIZE 5;
Constant IRDAT_RB_CURRENT 0;
Constant IRDAT_EVENT 1;
Constant IRDAT_BUFFER 2;
Constant IRDAT_TABLE 3;
Constant IRDAT_NEEDPROMPT 4;
Array input_rulebook_data --> INPUT_RULEBOOK_SIZE;
-) after "Variables and Arrays" in "Glulx.i6t";

Include (-
[ InputRDataInit rb a_event a_buffer a_table;
	input_rulebook_data-->IRDAT_RB_CURRENT = rb;
	input_rulebook_data-->IRDAT_EVENT = a_event;
	input_rulebook_data-->IRDAT_BUFFER = a_buffer;
	input_rulebook_data-->IRDAT_TABLE = a_table;
	input_rulebook_data-->IRDAT_NEEDPROMPT = false;
];

[ InputRDataFinal;
	input_rulebook_data-->IRDAT_RB_CURRENT = 0;
	input_rulebook_data-->IRDAT_EVENT = 0;
	input_rulebook_data-->IRDAT_BUFFER = 0;
	input_rulebook_data-->IRDAT_TABLE = 0;
	input_rulebook_data-->IRDAT_NEEDPROMPT = false;
];
-).

[Some phrases for use in the accepting input and handling input rulebooks. Do not try to use them anywhere else!]

To decide what g-event is the/-- current input event type: (- InputRDataEvType() -).
To decide whether handling (E - g-event): (- InputRDataEvTypeIs({E}) -).
To decide what Unicode character is the/-- current input event char/character: (- InputRDataEvChar() -).
To decide what number is the/-- current input event link/hyperlink number: (- InputRDataEvHyperlink() -).
To decide what object is the/-- current input event link/hyperlink object: (- ObjectValueIsSafe(InputRDataEvHyperlink()) -).
To decide what number is the/-- current input event line word count: (- InputRDataEvLineWordCount() -).
To say the/-- current input event line text: (- InputRDataEvLinePrint(); -).
To decide what text is the/-- current input event line text: (- InputRDataEvLineStore({-new:text}) -).

To replace the/-- current input event with the/-- line (T - text): (- InputRDataSetEvent(evtype_LineInput, {T}); -).
To replace the/-- current input event with the/-- char/character (C - Unicode character): (- InputRDataSetEvent(evtype_CharInput, {C}); -).
To replace the/-- current input event with the/-- link/hyperlink number (N - number): (- InputRDataSetEvent(evtype_Hyperlink, {N}); -).
To replace the/-- current input event with the/-- link/hyperlink object (O - object): (- InputRDataSetEvent(evtype_Hyperlink, {O}); -).

To handle the/-- current input event as (act - stored action): (- InputRDataParseAction({-by-reference:act}); -);

Include (-

[ InputRDataEvType;
	if (~~input_rulebook_data-->IRDAT_EVENT)
		return evtype_None;
	return (input_rulebook_data-->IRDAT_EVENT)-->0;
];

[ InputRDataEvTypeIs typ;
	if (~~input_rulebook_data-->IRDAT_EVENT)
		return false;
	if ((input_rulebook_data-->IRDAT_EVENT)-->0 == typ)
		return true;
	return false;
];

[ InputRDataEvChar;
	if (~~input_rulebook_data-->IRDAT_EVENT)
		return 0;
	if ((input_rulebook_data-->IRDAT_EVENT)-->0 ~= evtype_CharInput)
		return 0;
	return (input_rulebook_data-->IRDAT_EVENT)-->2;
];

[ InputRDataEvHyperlink;
	if (~~input_rulebook_data-->IRDAT_EVENT)
		return 0;
	if ((input_rulebook_data-->IRDAT_EVENT)-->0 ~= evtype_Hyperlink)
		return 0;
	return (input_rulebook_data-->IRDAT_EVENT)-->2;
];

[ InputRDataEvLineWordCount;
	if (~~input_rulebook_data-->IRDAT_EVENT)
		return 0;
	if ((input_rulebook_data-->IRDAT_EVENT)-->0 ~= evtype_LineInput)
		return 0;
	if (~~input_rulebook_data-->IRDAT_TABLE)
		return 0;
	return (input_rulebook_data-->IRDAT_TABLE)-->0;
];

[ InputRDataEvLinePrint  buf;
	! Assumes that the buffer length has been stored in buffer-->0.
	if (~~input_rulebook_data-->IRDAT_EVENT)
		return;
	buf = input_rulebook_data-->IRDAT_BUFFER;
	if (~~buf)
		return;
	if (buf-->0)
		glk_put_buffer(buf+WORDSIZE, buf-->0);
];

[ InputRDataEvLineStore txt   buf;
	! Assumes that the buffer length has been stored in buffer-->0.
	if (~~input_rulebook_data-->IRDAT_EVENT)
		return txt;
	buf = input_rulebook_data-->IRDAT_BUFFER;
	if (~~buf || buf-->0 == 0)
		return txt;
	TEXT_CopyFromByteArray(txt, buf+WORDSIZE, buf-->0);
	return txt;
];

[ InputRDataEvLineIsUndo;
	if (~~input_rulebook_data-->IRDAT_EVENT)
		return 0;
	if ((input_rulebook_data-->IRDAT_EVENT)-->0 ~= evtype_LineInput)
		return 0;
	if (~~input_rulebook_data-->IRDAT_TABLE)
		return 0;
	if ((input_rulebook_data-->IRDAT_TABLE)-->0 ~= 1)
		return 0;
	if ((input_rulebook_data-->IRDAT_TABLE)-->1 == UNDO1__WD or UNDO2__WD or UNDO3__WD)
		return 1;
	return 0;
];

[ InputRDataSetEvent typ arg    ev len;
	if (~~input_rulebook_data-->IRDAT_EVENT)
		return;
	ev = input_rulebook_data-->IRDAT_EVENT;
	ev-->0 = typ;
	switch (typ) {
		evtype_CharInput:
			ev-->1 = gg_mainwin;
			ev-->2 = arg;
		evtype_LineInput:
			if (~~input_rulebook_data-->IRDAT_BUFFER)
				return; ! No text buffer!
			ev-->1 = gg_mainwin;
			len = VM_PrintToBuffer(input_rulebook_data-->IRDAT_BUFFER, INPUT_BUFFER_LEN-WORDSIZE, TEXT_TY_Say, arg);
			ev-->2 = len;
			if (input_rulebook_data-->IRDAT_TABLE) {
				VM_Tokenise(input_rulebook_data-->IRDAT_BUFFER, input_rulebook_data-->IRDAT_TABLE);
			}
		evtype_Hyperlink:
			ev-->1 = gg_mainwin;
			ev-->2 = arg;
	}
];

! InputRDataInterruptInput: Tell AwaitInput to interrupt char/line input, so that text can be printed. If there is no char/line input going on, this does nothing. (So it's safe to call it more than once.)
! The options flag tells us to preserve interrupted line input by copying it to the window's preload-input-text property. (Assuming there is line input in progress.)
! This is just a temporary interruption. If AwaitInput continues, it will re-request input according to the setting-up-input rulebook.
! This may only be called from the accepting-input rulebook. 
[ InputRDataInterruptInput winproxy options   win propstr;
	if (~~input_rulebook_data-->IRDAT_EVENT)
		return;
		
	if (winproxy == (+ story-window +) )
		win = gg_mainwin;
	else if (winproxy == (+ status-window +) )
		win = gg_statuswin;
	else
		return;
	
	if (winproxy.current_input_request == (+ line-input +) ) {
		glk_cancel_line_event(win, gg_event);
		if (input_rulebook_data-->IRDAT_BUFFER && options) {
			! Preserve the interrupted input.
			propstr = GProperty(OBJECT_TY, winproxy, (+ preload-input-text +) );
			if (gg_event-->2 == 0) {
				! Zero-length, so we assign the empty string.
				BlkValueCopy(propstr, EMPTY_TEXT_VALUE);
			}
			else {
				! Copy from the buffer.
				TEXT_CopyFromByteArray(propstr, input_rulebook_data-->IRDAT_BUFFER+WORDSIZE, gg_event-->2);
			}
		}
		winproxy.current_input_request = (+ no-input +);
	}
	else if (winproxy.current_input_request == (+ char-input +) ) {
		glk_cancel_char_event(win);
		winproxy.current_input_request = (+ no-input +);
	}
	
	input_rulebook_data-->IRDAT_NEEDPROMPT = true;
];

! InputRDataParseAction: Parse out a stored action into parser_results form. We also set parsed_number, actor, and the parser_results_set flag. I don't think we have to set up anything else. (Note that this will be immediately followed by calls to TreatParserResults and GENERATE_ACTION_R.)
! I had to stare at a lot of parser code to work out this transformation. Action data doesn't normally flow this way (from stored action into parser_results). I hope I covered all the necessary cases.
! In the interests of sanity, we don't try to handle actions which include text (topics). These are really only useful when parsing player-typed commands, and the whole point of this routine is to bypass textual input.
! We also don't handle multiple-object actions. Stored actions can't store those.
[ InputRDataParseAction stora   acname at acmask req count val;
	if (input_rulebook_data-->IRDAT_RB_CURRENT ~= (+ handling input rules +) )
		return;

	acname = BlkValueRead(stora, STORA_ACTION_F);
	at = FindAction(acname);
	if (~~at)
		print_ret "InputRDataParseAction: cannot find action ", (SayActionName) acname, ".";
		
	req = BlkValueRead(stora, STORA_REQUEST_F);
	if (req == 1) {
		val = BlkValueRead(stora, STORA_ACTOR_F);
		print_ret "InputRDataParseAction: cannot set up an ~asking ", (name) val, " to try ", (SayActionName) acname, "~ action. Did you mean ~", (name) val, " ", (SayActionName) acname, "~?";
	}
	if (req)
		print_ret "InputRDataParseAction: cannot set up an action (", (SayActionName) acname, ") which involves a topic.";
	
	parser_results_set = true;
	actor = BlkValueRead(stora, STORA_ACTOR_F);
	parser_results-->ACTION_PRES = acname;
	count = 0;
	parser_results-->INP1_PRES = 0;
	parser_results-->INP2_PRES = 0;
	
	acmask = ActionData-->(at+AD_REQUIREMENTS);
	val = BlkValueRead(stora, STORA_NOUN_F);
	if (acmask & NEED_NOUN_ABIT) {
		if (ActionData-->(at+AD_NOUN_KOV) == OBJECT_TY) {
			parser_results-->(INP1_PRES+count) = val;
		}
		else {
			parser_results-->(INP1_PRES+count) = 1;
			parsed_number = val;
		}
		count++;
	}

	val = BlkValueRead(stora, STORA_SECOND_F);
	if (acmask & NEED_SECOND_ABIT) {
		if (ActionData-->(at+AD_SECOND_KOV) == OBJECT_TY) {
			parser_results-->(INP1_PRES+count) = val;
		}
		else {
			parser_results-->(INP1_PRES+count) = 1;
			parsed_number = val;
		}
		count++;
	}

	parser_results-->NO_INPS_PRES = count;
];

! This returns val unchanged if it's really an object value. If it's anything else (zero, a string, a function, an invalid memory address) the return value will be zero (nothing).
! (This could be made safer with the I6 6.34 compiler, which allows more introspection into how many objects and classes exist in the game.)
! (Not currently compatible with Dynamic Objects.)
[ ObjectValueIsSafe val   limit;
	if (val < Class)
		return 0;
	if (val >= #grammar_table)
		return 0;
	@getmemsize limit;
	if (val > limit - (1 + NUM_ATTR_BYTES + 6*4))
		return 0;
	if (val->0 ~= $70)
		return 0;
	return val;
];

-).


Section - Glk Special Keycodes

[These are not true Unicode characters, but character input events can contain them, so we need definitions. Do not try to print these values using the usual I7 say phrase! The phrase "say extended C" will print both normal and special Unicode values.]

To decide which Unicode character is special keycode left: (- keycode_Left -).
To decide which Unicode character is special keycode right: (- keycode_Right -).
To decide which Unicode character is special keycode up: (- keycode_Up -).
To decide which Unicode character is special keycode down: (- keycode_Down -).
To decide which Unicode character is special keycode return: (- keycode_Return -).
To decide which Unicode character is special keycode delete: (- keycode_Delete -).
To decide which Unicode character is special keycode escape: (- keycode_Escape -).
To decide which Unicode character is special keycode tab: (- keycode_Tab -).
To decide which Unicode character is special keycode pageup: (- keycode_PageUp -).
To decide which Unicode character is special keycode pagedown: (- keycode_PageDown -).
To decide which Unicode character is special keycode home: (- keycode_Home -).
To decide which Unicode character is special keycode end: (- keycode_End -).
To decide which Unicode character is special keycode func1: (- keycode_Func1 -).
To decide which Unicode character is special keycode func2: (- keycode_Func2 -).
To decide which Unicode character is special keycode func3: (- keycode_Func3 -).
To decide which Unicode character is special keycode func4: (- keycode_Func4 -).
To decide which Unicode character is special keycode func5: (- keycode_Func5 -).
To decide which Unicode character is special keycode func6: (- keycode_Func6 -).
To decide which Unicode character is special keycode func7: (- keycode_Func7 -).
To decide which Unicode character is special keycode func8: (- keycode_Func8 -).
To decide which Unicode character is special keycode func9: (- keycode_Func9 -).
To decide which Unicode character is special keycode func10: (- keycode_Func10 -).
To decide which Unicode character is special keycode func11: (- keycode_Func11 -).
To decide which Unicode character is special keycode func12: (- keycode_Func12 -).

Definition: a Unicode character is a special keycode if I6 routine "UnicodeCharIsSpecial" says so (it is a control key like tab, escape, or the arrow keys).
To say extended (C - Unicode character): (- PrintUnicodeSpecialName({C}); -).

Include (-
[ UnicodeCharIsSpecial ch;
	if (ch < 0 && ch >= -keycode_MAXVAL)
		rtrue;
	rfalse;
];

[ PrintUnicodeSpecialName ch;
	if (ch >= 0 && ch < $110000) {
		@streamunichar ch;
		return;
	}
	switch (ch) {
		keycode_Left: print "left";
		keycode_Right: print "right";
		keycode_Up: print "up";
		keycode_Down: print "down";
		keycode_Return: print "return";
		keycode_Delete: print "delete";
		keycode_Escape: print "escape";
		keycode_Tab: print "tab";
		keycode_PageUp: print "pageup";
		keycode_PageDown: print "pagedown";
		keycode_Home: print "home";
		keycode_End: print "end";
		keycode_Func1: print "func1";
		keycode_Func2: print "func2";
		keycode_Func3: print "func3";
		keycode_Func4: print "func4";
		keycode_Func5: print "func5";
		keycode_Func6: print "func6";
		keycode_Func7: print "func7";
		keycode_Func8: print "func8";
		keycode_Func9: print "func9";
		keycode_Func10: print "func10";
		keycode_Func11: print "func11";
		keycode_Func12: print "func12";
		default: print "unknown";
	}
];

-).


Chapter - New Rulebooks

Section - Setting Up Input

[This rulebook sets up the input requests for parser input (the command contexts, not the yes-or-no or final questions). It is called at the top of the ParserInput loop.]
The setting up input rules are an input-context based rulebook.

[This is called by every context that sets up requests for AwaitInput. (The start of the setting up input rulebook, and also YesOrNo and other such contexts.)]
To clear all input requests (this is all-input-request-clearing):
	clear input requests for the story-window;
	clear input requests for the status-window.
	[We do not clear timer-request. That will run in the background as turns (and other inputs) go by.]

[Clear input requests for a given window.]
To clear input requests for (W - glk-window):
	now the input-request of W is no-input;
	now W is not hyperlink-input-request.
	[We do not clear the preload-input-text variable! By default, we want interrupted input to carry over from turn to turn. Of course you could add a setting-up-input rule to clear it.]

To set the/-- timer to (N - number) ms/millisec/millisecond/milliseconds:
	now timer-request is N.
To set the/-- timer to (R - real number) sec/second/seconds:
	let N be (R * 1000.0) to the nearest whole number;
	now timer-request is N.
To set/turn the/-- timer off:
	now timer-request is 0.

To decide whether the timer is active:
	if timer-request is not zero, decide yes.
To decide whether the timer is inactive:
	if timer-request is zero, decide yes.

[A flag for whether "set input undoable" has been used during the current ParserInput call. It has no meaning outside ParserInput.]
The setting-up-input-undoability-flag is a truth state that varies.

To set the/-- input undoable:
	now setting-up-input-undoability-flag is true.
To set the/-- input not undoable:
	now setting-up-input-undoability-flag is false.
To set the/-- input nonundoable/non-undoable:
	now setting-up-input-undoability-flag is false.

First setting up input rule (this is the initial clear input requests rule):
	set input non-undoable;
	clear all input requests.

Setting up input rule (this is the standard parser input line request rule):
	set input undoable;
	now the input-request of the story-window is line-input.


Section - Prompt Displaying

[This rulebook, as you might guess, is in charge of displaying the prompt before player input. Its parameter is an input-context, which distinguishes regular game input from other questions (yes-or-no, the final game question, etc).]
The prompt displaying rules are an input-context based rulebook.

[These globals are used by the extended yes-or-no system (YesOrNoPrompt). The classic YesOrNo does not use them.]
The extended yes-no prompt is a text that varies.
The repeat yes-no prompt is a text that varies.

[The default prompt rules are a bit complicated because we want to keep supporting the old prompt customization tools, which date from across Inform's history. For example, the default prompt rule displays the old "command prompt" global variable, which defaults to ">".]

Last prompt displaying rule for the keystroke-wait context (this is the keystroke-wait prompt rule):
	instead say "" (A).
Last prompt displaying rule for the yes-no question context (this is the yes-no question prompt rule):
	instead say ">" (A).
Last prompt displaying rule for the extended yes-no question context (this is the extended yes-no question prompt rule):
	instead say "[extended yes-no prompt] >" (A).
Last prompt displaying rule for the repeat yes-no question context (this is the repeat yes-no question prompt rule):
	instead say "[repeat yes-no prompt] >" (A).
Last prompt displaying rule for the final question context (this is the final question prompt rule):
	instead follow the print the final prompt rule.
Last prompt displaying rule for an input-context (this is the default prompt rule):
	[really truly last]
	instead say the command prompt.


Section - Accepting Input

The accepting input rules are an input-context based rulebook.

[Called in AwaitEvent. On success (acceptance), AwaitEvent returns the event. On no result or failure (rejection), AwaitEvent continues waiting.]

[Handy synonyms for "rule succeeds" and "rule fails".]
To accept the/-- input event: (- RulebookSucceeds(); rtrue; -).
To reject the/-- input event: (- RulebookFails(); rtrue; -).

[Same definition as in Basic Screen Effects.]
To update/redraw the/-- status line: (- DrawStatusLine(); -).

To interrupt text input for (W - glk-window), preserving input: (- InputRDataInterruptInput({W}, {phrase options}); -).

[Standard rules:]

Accepting input rule when handling arrange-event (this is the standard redraw status line on arrange rule):
	redraw the status line;
	reject input event.

Last accepting input rule (this is the standard accept all requested input rule):
	let T be the current input event type;
	if T is:
		-- line-event:
			if the input-request of the story-window is line-input:
				accept input event;
		-- char-event:
			if the input-request of the story-window is char-input:
				accept input event;
		-- hyperlink-event:
			if the story-window is hyperlink-input-request:
				accept input event;
	[This doesn't cover non-human-generated events like timer events.]
	reject input event.


Section - Checking Undo Input

The checking undo input rules are an input-context based rulebook.

To decide whether standard-undo-input-line: (- InputRDataEvLineIsUndo() -).

Checking undo input rule (this is the standard line input undo checking rule):
	if standard-undo-input-line:
		rule succeeds.


Section - Handling Input

The handling input rules are an input-context based rulebook.

[Called after (not within) any invocation of ParserInput. If a specific action is generated, that action is performed. On failure: no action is parsed or performed.]

[This rulebook is empty by default. On no result, the parser proceeds with its normal behavior: line input is parsed, other input is rejected with "I beg your pardon?"]


Chapter - Our Core Routines

Section - AwaitInput

Include (-

! AwaitInput: block and await an acceptable input. What "acceptable" means is customizable. Typically the caller will be interested in some event types (e.g., line input), will allow others to do their job (arrange events redrawing the status window), and will ignore the rest (keep awaiting input).
! This is the low-level entry point to the Glk input system; all input requests funnel down to this function. It sets up the Glk input request events and calls glk_select().
! This function also handles displaying the prompt and redrawing the status line. (Through customizable rulebooks and activities, of course.)
! AwaitInput takes four arguments: the input context, an event structure, a line input buffer, and a buffer for parsing words from line input. (The latter two arguments are optional; if not supplied then line input cannot be accepted. If a_buffer is supplied but a_table is not, then line input will be accepted but not tokenized.)

[ AwaitInput incontext a_event a_buffer a_table     runonprompt wanttextinput wantlinkinput res val len;
	! Clear our argument arrays (if present).
	a_event-->0 = evtype_None;
	if (a_buffer) {
		a_buffer-->0 = 0;
	}
	if (a_table) {
		a_table-->0 = 0;
	}
	
	! In the old-fashioned YesOrNo sequence, we want to print the prompt after the caller's printed question, with no line break. In all other cases, we ensure a line break before the prompt.
	runonprompt = (incontext == (+ yes-no question context +) );
	
	! When this function begins, the window is not awaiting any input (except perhaps timer input).
	
	if (input_rulebook_data-->IRDAT_RB_CURRENT ~= 0) {
		print "(BUG) AwaitInput called recursively!^";
	}
	InputRDataInit( (+ accepting input rules +), a_event, a_buffer, a_table);
	
	! Always start with a prompt.
	input_rulebook_data-->IRDAT_NEEDPROMPT = true;
	
	while (true) {
	
		! Before input, we do the work that was in the old PrintPrompt call. The conditions have evolved a bit, though.

		! If the story window isn't tied up awaiting input, print any pending run-time problems. (We don't care if this screws up the prompt. RTPs are allowed to be ugly.)
		if ( (+ story-window +).current_input_request == (+ no-input +) ) {
			RunTimeProblemShow();
			ClearRTP();

			! This displayed any pending quotation. (The function name is misleading.)
			! Normally this only writes to the quote window, so we could call it even if input were pending. But in cheapglk the quote goes to the main window. So we'll be paranoid.
			ClearBoxedText();
		}
	
		! If we need to print the prompt, and we're not already awaiting input, print the prompt.
		if (input_rulebook_data-->IRDAT_NEEDPROMPT && (+ story-window +).current_input_request == (+ no-input +) ) {
			input_rulebook_data-->IRDAT_NEEDPROMPT = false;
			style roman;
			if (~~runonprompt) {
				EnsureBreakBeforePrompt();
			}
			runonprompt = false;
			FollowRulebook((+ prompt displaying rules +), incontext, true);
			ClearParagraphing(14);
		}
	
		! Redraw the status line.
		! (This currently assumes that the status line never accepts text input.)
		sline1 = score; sline2 = turns;
		if (location ~= nothing && parent(player) ~= nothing) DrawStatusLine();
	
		! If test input is pending, grab it rather than requesting new input.
		#Ifdef DEBUG; #Iftrue ({-value:NUMBER_CREATED(test_scenario)} > 0);
		res = CheckTestInput(a_event, a_buffer);
		if (res && a_event-->0) {
			jump GotEvent;
		}
		#Endif; #Endif;
		
		! If replay-stream input is pending, grab that.
		if (gg_commandstr && gg_command_reading) {
			res = RecordingReadEvent(a_event, a_buffer);
			if (res && a_event-->0) {
				jump GotEvent;
			}
		}
		
		! Adjust the Glk input requests to match what the game wants. This may involve setting or cancelling requests.
		wantlinkinput = GetEitherOrProperty( (+ story-window +), (+ hyperlink-input-request +) );
		wanttextinput = GProperty(OBJECT_TY, (+ story-window +), (+ input-request +) );
		if (wanttextinput == (+ line-input +) && a_buffer == 0) {
			print "(BUG) AwaitInput: called with a line input request but no buffer argument";
			wanttextinput = (+ no-input +);
		}
	
		if ( (+ story-window +).current_input_request == (+ line-input +) && wanttextinput ~= (+ line-input +) ) {
			glk_cancel_line_event(gg_mainwin, gg_event);
			(+ story-window +).current_input_request = (+ no-input +);
			input_rulebook_data-->IRDAT_NEEDPROMPT = true;
			!print "(DEBUG) cancel line input mode^";
		}
		if ( (+ story-window +).current_input_request == (+ char-input +) && wanttextinput ~= (+ char-input +) ) {
			glk_cancel_char_event(gg_mainwin);
			(+ story-window +).current_input_request = (+ no-input +);
			!print "(DEBUG) cancel char input mode^";
		}
		if ( (+ story-window +).current_hyperlink_request && ~~wantlinkinput) {
			if (glk_gestalt(gestalt_Hyperlinks, 0))
				glk_cancel_hyperlink_event(gg_mainwin);
			(+ story-window +).current_hyperlink_request = false;
			!print "(DEBUG) cancel hyperlink input mode^";
		}
	
		if ( (+ story-window +).current_input_request ~= (+ line-input +) && wanttextinput == (+ line-input +)) {
			!print "(DEBUG) req line input mode^";
			! If the window's preload-input-text property is not empty, preload it into the buffer (and then clear the property).
			len = 0;
			val = GProperty(OBJECT_TY, (+ story-window +), (+ preload-input-text +) );
			if (~~TEXT_TY_Empty(val)) {
				len = VM_PrintToBuffer(a_buffer, INPUT_BUFFER_LEN-WORDSIZE, TEXT_TY_Say, val);
				BlkValueCopy(val, EMPTY_TEXT_VALUE);
			}
			glk_request_line_event(gg_mainwin, a_buffer+WORDSIZE, INPUT_BUFFER_LEN-WORDSIZE, len);
			(+ story-window +).current_input_request = (+ line-input +);
		}
		if ( (+ story-window +).current_input_request ~= (+ char-input +) && wanttextinput == (+ char-input +)) {
			!print "(DEBUG) req char input mode^";
			glk_request_char_event_uni(gg_mainwin);
			(+ story-window +).current_input_request = (+ char-input +);
		}
		if ((+ story-window +).current_hyperlink_request == false && wantlinkinput) {
			if (glk_gestalt(gestalt_Hyperlinks, 0)) {
				!print "(DEBUG) req hyperlink input mode^";
				glk_request_hyperlink_event(gg_mainwin);
				(+ story-window +).current_hyperlink_request = true;
			}
		}
		
		val = (+ timer-request +);
		if (current_timer_request ~= val && glk_gestalt(gestalt_Timer, 0)) {
			glk_request_timer_events(val);
			current_timer_request = val;
		}

		glk_select(a_event);
		.GotEvent;
		
		! Some required bookkeeping before we invoke the rulebook.
		switch (a_event-->0) {
			evtype_CharInput:
				if (a_event-->1 == gg_mainwin) {
					(+ story-window +).current_input_request = (+ no-input +); ! request complete
				}
			evtype_LineInput:
				if (a_event-->1 == gg_mainwin) {
					(+ story-window +).current_input_request = (+ no-input +); ! request complete
					a_buffer-->0 = a_event-->2;
					if (a_table) {
						VM_Tokenise(a_buffer, a_table);
					}
					input_rulebook_data-->IRDAT_NEEDPROMPT = true;
				}
			evtype_Hyperlink:
				if (a_event-->1 == gg_mainwin) {
					(+ story-window +).current_hyperlink_request = false; ! request complete
				}
		}
		if (gg_commandstr && ~~gg_command_reading)
			RecordingWriteEvent(a_event, a_buffer);
		FollowRulebook((+ accepting input rules +), incontext, true);
		if (RulebookSucceeded()) {
			break;
		}
		! End of loop.
	}
	
	! Cancel any remaining input requests.
	if ( (+ story-window +).current_input_request == (+ line-input +) ) {
		glk_cancel_line_event(gg_mainwin, gg_event);
		(+ story-window +).current_input_request = (+ no-input +);
		input_rulebook_data-->IRDAT_NEEDPROMPT = true;
		!print "(DEBUG) cancel line input mode^";
	}
	if ( (+ story-window +).current_input_request == (+ char-input +) ) {
		glk_cancel_char_event(gg_mainwin);
		(+ story-window +).current_input_request = (+ no-input +);
		!print "(DEBUG) cancel char input mode^";
	}
	if ((+ story-window +).current_hyperlink_request) {
		if (glk_gestalt(gestalt_Hyperlinks, 0))
			glk_cancel_hyperlink_event(gg_mainwin);
		(+ story-window +).current_hyperlink_request = false;
		!print "(DEBUG) cancel hyperlink input mode^";
	}
	
	InputRDataFinal();

	! We can close any quote box that was displayed during the input loop.
	QuoteWinCloseIfOpen();

	! When this function exits, the window is (once again) not awaiting any input (except perhaps timer input).
];

[ QuoteWinCloseIfOpen;
	if (gg_quotewin) {
		glk_window_close(gg_quotewin, 0);
		gg_quotewin = 0;
	}
];

-) instead of "Keyboard Input" in "Glulx.i6t".

[These phrases provide I7 access to the AwaitInput call.]

To await input in (C - input-context): (- AwaitInput({C}, inputevent, 0, 0); -).
To await input in (C - input-context) with primary buffer: (- AwaitInput({C}, inputevent, buffer, parse); -).
To await input in (C - input-context) with secondary buffer: (- AwaitInput({C}, inputevent2, buffer2, parse2); -).


Section - ParserInput

Include (-

! ParserInput: block and await acceptable input. Returns an event in a_event; tokenized line data will be in a_buffer and a_table.
! This is a wrapper around AwaitInput which adds "OOPS" and "UNDO" support -- features appropriate for the main parser input loop. It also permits the game to customize what kinds of input are accepted for that loop.
! This is called from Parser Letter A (primary command input) and NounDomain (disambig inputs).
! (Context-specific questions, such as YesOrNo and the end-game question, do not use this wrapper. They call AwaitInput directly.)
! In this function, unlike in AwaitInput, a_buffer and a_table are both mandatory. They may be either buffer/table (primary context) or buffer2/table2 (disambiguation context).

[ ParserInput  incontext a_event a_buffer a_table    evtyp nw i w w2 x1 x2 undoable;
	! Repeat loop until an acceptable input arrives.
	while (true) {
		! Save the start of the buffer, in case "oops" needs to restore it
		Memcpy(oops_workspace, a_buffer, 64);
		
		! Set up the input requests. (Normally just line input, but the game can customize this.)
		FollowRulebook((+ setting up input rules +), incontext, true);
		
		undoable = (+ setting-up-input-undoability-flag +);
		
		! The input deed itself.
		AwaitInput(incontext, a_event, a_buffer, a_table);

		! We have an input event now, but it could be any type. If it's line input, it's been tokenized.
		
		evtyp = a_event-->0;
		nw = 0;
		
		if (evtyp == evtype_LineInput) {
			! Set nw to the number of words
			nw = a_table-->0;
		}
		
		#ifndef PASS_BLANK_INPUT_LINES;
		! If the line was blank, get a fresh line.
		if (evtyp == evtype_LineInput && nw == 0) {
			! The old Keyboard routine cleared players_command here (to 100). I'm not sure why. If we're on buffer2/table2, the players_command snippet doesn't apply at all.
			EmptyInputParserError();
			continue;
		}
		#endif; ! PASS_BLANK_INPUT_LINES;
		
		! If this is line input, fetch the opening word.
		w = 0;
		if (evtyp == evtype_LineInput && nw > 0) {
			w = a_table-->1;
		}
		
		! Oops handling
		
		if (w == OOPS1__WD or OOPS2__WD or OOPS3__WD) {
			if (oops_from == 0) { PARSER_COMMAND_INTERNAL_RM('A'); new_line; continue; }
			if (nw == 1) { PARSER_COMMAND_INTERNAL_RM('B'); new_line; continue; }
			if (nw > 2) { PARSER_COMMAND_INTERNAL_RM('C'); new_line; continue; }
		
			! So now we know: there was a previous mistake, and the player has
			! attempted to correct a single word of it.
		
			for (i=0 : i<INPUT_BUFFER_LEN : i++) buffer2->i = a_buffer->i;
			x1 = a_table-->6; ! Start of word following "oops"
			x2 = a_table-->5; ! Length of word following "oops"
		
			! Repair the buffer to the text that was in it before the "oops"
			! was typed:
			Memcpy(a_buffer, oops_workspace, 64);
			VM_Tokenise(a_buffer,a_table);
		
			! Work out the position in the buffer of the word to be corrected:
			w = a_table-->(3*oops_from);      ! Start of word to go
			w2 = a_table-->(3*oops_from - 1); ! Length of word to go
		
			! Write spaces over the word to be corrected:
			for (i=0 : i<w2 : i++) a_buffer->(i+w) = ' ';
		
			if (w2 < x2) {
				! If the replacement is longer than the original, move up...
				for ( i=INPUT_BUFFER_LEN-1 : i>=w+x2 : i-- )
					a_buffer->i = a_buffer->(i-x2+w2);
		
				! ...increasing buffer size accordingly.
				a_buffer-->0 = (a_buffer-->0) + (x2-w2);
			}
		
			! Write the correction in:
			for (i=0 : i<x2 : i++) a_buffer->(i+w) = buffer2->(i+x1);
		
			VM_Tokenise(a_buffer, a_table);
			nw = a_table-->0;
		
			return;
		}

		! Undo handling -- check whether we got an undo command, and then save a new undo point. But we only do these if the setting-up-input rules said this is an undoable input.
		if (undoable) {
			InputRDataInit( (+ checking undo input rules +), a_event, a_buffer, a_table);
			FollowRulebook((+ checking undo input rules +), incontext, true);
			InputRDataFinal();
			if (RulebookSucceeded()) {
				Perform_Undo();
				continue;
			}
		
			i = VM_Save_Undo();
			#ifdef PREVENT_UNDO; undo_flag = 0; #endif;
			#ifndef PREVENT_UNDO; undo_flag = 2; #endif;
			if (i == -1) undo_flag = 0;
			if (i == 0) undo_flag = 1;
			if (i == 2) {
				VM_RestoreWindowColours();
				VM_Style(SUBHEADER_VMSTY);
				SL_Location(); print "^";
				! print (name) location, "^";
				VM_Style(NORMAL_VMSTY);
				IMMEDIATELY_UNDO_RM('E'); new_line;
				continue;
			}
		}
		
		! Neither OOPS nor UNDO; we're done.
		return;
	}
];

-) instead of "Reading the Command" in "Parser.i6t".


Chapter - High-Level Input Routines

Section - Yes-No Questions

Include (-

! YesOrNo routines. These block and await line input.
! Unlike in ParserInput, the input format cannot be customized. These routines are inherently about getting a typed response.

[ YesOrNo i j;
	for (::) {
		((+ all-input-request-clearing +)-->1)();
		WriteGProperty(OBJECT_TY, (+ story-window +), (+ input-request +),  (+ line-input +) );
		
		AwaitInput( (+ yes-no question context +), inputevent, buffer2, parse2);
				
		j = parse2-->0;
		if (j) { ! at least one word entered
			i = parse2-->1;
			if (i == YES1__WD or YES2__WD or YES3__WD) rtrue;
			if (i == NO1__WD or NO2__WD or NO3__WD) rfalse;
		}
		! bad response; try again
		YES_OR_NO_QUESTION_INTERNAL_RM('A');
	}
];

[ YesOrNoPrompt i j incontext;
	incontext = (+ extended yes-no question context +);
	for (::) {
		((+ all-input-request-clearing +)-->1)();
		WriteGProperty(OBJECT_TY, (+ story-window +), (+ input-request +),  (+ line-input +) );
		
		AwaitInput(incontext, inputevent, buffer2, parse2);
				
		j = parse2-->0;
		if (j) { ! at least one word entered
			i = parse2-->1;
			if (i == YES1__WD or YES2__WD or YES3__WD) rtrue;
			if (i == NO1__WD or NO2__WD or NO3__WD) rfalse;
		}
		! bad response; try again
		incontext = (+ repeat yes-no question context +);
	}
];

[ YES_OR_NO_QUESTION_INTERNAL_R; ];

-) instead of "Yes/No Questions" in "Parser.i6t".

To decide whether YesOrNoPrompt: (- YesOrNoPrompt() -).

To decide whether player consents asking (T1 - text):
	now the extended yes-no prompt is T1;
	now the repeat yes-no prompt is "Please answer yes or no. ";
	if YesOrNoPrompt:
		decide yes.

To decide whether player consents asking (T1 - text) and (T2 - text):
	now the extended yes-no prompt is T1;
	now the repeat yes-no prompt is T2;
	if YesOrNoPrompt:
		decide yes.

The print the final prompt rule is not listed in any rulebook. [Prompt-printing is now taken care of by the prompt displaying rules.]
The display final status line rule is not listed in any rulebook. [This rule updated status line globals. That's now built into AwaitInput.]


Section - The Final Question

Include (-

! Unlike in ParserInput, the input format cannot be customized. The "standard respond to final question rule" is looking for a typed response, so we must supply one.

[ READ_FINAL_ANSWER_R;
	((+ all-input-request-clearing +)-->1)();
	WriteGProperty(OBJECT_TY, (+ story-window +), (+ input-request +),  (+ line-input +) );
		
	AwaitInput( (+ final question context +), inputevent, buffer, parse);
	
	players_command = 100 + WordCount();
	num_words = WordCount();
	wn = 1;
	rfalse;
];

-) instead of "Read The Final Answer Rule" in "OrderOfPlay.i6t".


Section - Wait For A Key

[Block and wait for a key to be struck. The return value will be a Unicode character or one of the Glk special keycodes.]
To decide what Unicode character is the/-- key waited for: (- InputKeystroke() -).

[These phrases follow the definitions in Basic Screen Effects.]
To wait for any key: (- InputKeysUntilAny(); -).
To wait for the/-- SPACE key: (- InputKeysUntilSpace(); -).

[None of the above phrases print a prompt. The prompt displaying rulebook has a rule which prints nothing for the keystroke-wait context. You can override this rule, or simply print your own prompt before calling the phrase.]

Include (-

[ InputKeystroke;
	((+ all-input-request-clearing +)-->1)();
	WriteGProperty(OBJECT_TY, (+ story-window +), (+ input-request +),  (+ char-input +) );
	
	AwaitInput( (+ keystroke-wait context +), inputevent, 0, 0);

	return inputevent-->2;			
];

! Wait for space or Enter.
[ InputKeysUntilSpace ch;
	while (true) {
		ch = InputKeystroke();
		if (ch == ' ' || ch == keycode_Return)
			return;
	}
];

! Wait for a safe (non-navigating) key. The user might press Down/PgDn or use the mouse scroll wheel to scroll a page of text, so we will ignore those.
[ InputKeysUntilAny ch;
	while (true) {
		ch = InputKeystroke();
		if (ch == keycode_Up or keycode_Down or keycode_PageUp or keycode_PageDown or keycode_Home or keycode_End)
			continue;
		return;
	}
];

-).


Chapter - Parser Code Replacements

Section - Parser__parse

[Replacements for the parser code that used to call Keyboard(). It now calls ParserInput() with a slightly different calling convention. Only the bits of code around the ParserInput() calls has changed.]

Include (-
    parser_results_set = false;

    if (held_back_mode == 1) {
        held_back_mode = 0;
        VM_Tokenise(buffer, parse);
        jump ReParse;
    }

  .ReType;

	cobj_flag = 0;
	actors_location = ScopeCeiling(player);
	
    BeginActivity(READING_A_COMMAND_ACT); if (ForActivity(READING_A_COMMAND_ACT)==false) {
    	.ReParserInput;
		num_words = 0; players_command = 100;
		ParserInput( (+ primary context +), inputevent, buffer, parse);
		if (input_rulebook_data-->IRDAT_RB_CURRENT ~= 0) {
			print "(BUG) Reading-a-command called recursively!^";
		}
		parser_results_set = false;
		InputRDataInit( (+ handling input rules +), inputevent, buffer, parse);
		FollowRulebook((+ handling input rules +), (+ primary context +), true);
		InputRDataFinal();
		if (RulebookFailed()) {
			jump ReParserInput;
		}
		if (inputevent-->0 == evtype_LineInput) {
			num_words = WordCount(); players_command = 100 + num_words;
		}
		if (parser_results_set && parser_results-->ACTION_PRES ~= 0) {
			! If we're not parsing, reading a command shouldn't show the input.
			num_words = 0; players_command = 100;
		}
    } if (EndActivity(READING_A_COMMAND_ACT)) jump ReType;

  .ReParse;
  
	if (parser_results_set && parser_results-->ACTION_PRES ~= 0) {
		! The rulebook gave us an explicit action.
		rtrue;
	}
	
	num_words = 0; players_command = 100;
	if (inputevent-->0 == evtype_LineInput) {
		num_words = WordCount(); players_command = 100 + num_words;
	}
	
	if (num_words == 0) {
		! Either this was a blank line or it was not line input at all. Reject it.
		! (Blank line input could reach this point if the PASS_BLANK_INPUT_LINES option is set.)
		EmptyInputParserError();
		jump ReType;
	}

    parser_inflection = name;

    ! Initially assume the command is aimed at the player, and the verb
    ! is the first word

    wn = 1; inferred_go = false;

    #Ifdef LanguageToInformese;
    LanguageToInformese();
    ! Re-tokenise:
    VM_Tokenise(buffer,parse);
    #Endif; ! LanguageToInformese

    num_words = WordCount(); players_command = 100 + num_words;

    k=0;
    #Ifdef DEBUG;
    if (parser_trace >= 2) {
        print "[ ";
        for (i=0 : i<num_words : i++) {

            #Ifdef TARGET_ZCODE;
            j = parse-->(i*2 + 1);
            #Ifnot; ! TARGET_GLULX
            j = parse-->(i*3 + 1);
            #Endif; ! TARGET_
            k = WordAddress(i+1);
            l = WordLength(i+1);
            print "~"; for (m=0 : m<l : m++) print (char) k->m; print "~ ";

            if (j == 0) print "?";
            else {
                #Ifdef TARGET_ZCODE;
                if (UnsignedCompare(j, HDR_DICTIONARY-->0) >= 0 &&
                    UnsignedCompare(j, HDR_HIGHMEMORY-->0) < 0)
                     print (address) j;
                else print j;
                #Ifnot; ! TARGET_GLULX
                if (j->0 == $60) print (address) j;
                else print j;
                #Endif; ! TARGET_
            }
            if (i ~= num_words-1) print " / ";
        }
        print " ]^";
    }
    #Endif; ! DEBUG
    verb_wordnum = 1;
    actor = player;
    actors_location = ScopeCeiling(player);
    usual_grammar_after = 0;

  .AlmostReParse;

    scope_token = 0;
    action_to_be = NULL;

    ! Begin from what we currently think is the verb word

  .BeginCommand;

    wn = verb_wordnum;
    verb_word = NextWordStopped();

    ! If there's no input here, we must have something like "person,".

    if (verb_word == -1) {
        best_etype = STUCK_PE; jump GiveError;
    }
	if (verb_word == comma_word) {
		best_etype = COMMABEGIN_PE; jump GiveError;
	}

    ! Now try for "again" or "g", which are special cases: don't allow "again" if nothing
    ! has previously been typed; simply copy the previous text across

    if (verb_word == AGAIN2__WD or AGAIN3__WD) verb_word = AGAIN1__WD;
    if (verb_word == AGAIN1__WD) {
        if (actor ~= player) {
            best_etype = ANIMAAGAIN_PE;
			jump GiveError;
        }
        #Ifdef TARGET_ZCODE;
        if (buffer3->1 == 0) {
            PARSER_COMMAND_INTERNAL_RM('D'); new_line;
            jump ReType;
        }
        #Ifnot; ! TARGET_GLULX
        if (buffer3-->0 == 0) {
            PARSER_COMMAND_INTERNAL_RM('D'); new_line;
            jump ReType;
        }
        #Endif; ! TARGET_
        for (i=0 : i<INPUT_BUFFER_LEN : i++) buffer->i = buffer3->i;
        VM_Tokenise(buffer,parse);
		num_words = WordCount(); players_command = 100 + num_words;
    	jump ReParse;
    }

    ! Save the present input in case of an "again" next time

    if (verb_word ~= AGAIN1__WD)
        for (i=0 : i<INPUT_BUFFER_LEN : i++) buffer3->i = buffer->i;

    if (usual_grammar_after == 0) {
        j = verb_wordnum;
        i = RunRoutines(actor, grammar); 
        #Ifdef DEBUG;
        if (parser_trace >= 2 && actor.grammar ~= 0 or NULL)
            print " [Grammar property returned ", i, "]^";
        #Endif; ! DEBUG

        if ((i ~= 0 or 1) && (VM_InvalidDictionaryAddress(i))) {
            usual_grammar_after = verb_wordnum; i=-i;
        }

        if (i == 1) {
            parser_results-->ACTION_PRES = action;
            parser_results-->NO_INPS_PRES = 0;
            parser_results-->INP1_PRES = noun;
            parser_results-->INP2_PRES = second;
            if (noun) parser_results-->NO_INPS_PRES = 1;
            if (second) parser_results-->NO_INPS_PRES = 2;
            rtrue;
        }
        if (i ~= 0) { verb_word = i; wn--; verb_wordnum--; }
        else { wn = verb_wordnum; verb_word = NextWord(); }
    }
    else usual_grammar_after = 0;

-) instead of "Parser Letter A" in "Parser.i6t".


Section - NounDomain

Include (-

[ NounDomain domain1 domain2 context dont_ask
	first_word i j k l answer_words marker;
    #Ifdef DEBUG;
    if (parser_trace >= 4) {
        print "   [NounDomain called at word ", wn, "^";
        print "   ";
        if (indef_mode) {
            print "seeking indefinite object: ";
            if (indef_type & OTHER_BIT)  print "other ";
            if (indef_type & MY_BIT)     print "my ";
            if (indef_type & THAT_BIT)   print "that ";
            if (indef_type & PLURAL_BIT) print "plural ";
            if (indef_type & LIT_BIT)    print "lit ";
            if (indef_type & UNLIT_BIT)  print "unlit ";
            if (indef_owner ~= 0) print "owner:", (name) indef_owner;
            new_line;
            print "   number wanted: ";
            if (indef_wanted == INDEF_ALL_WANTED) print "all"; else print indef_wanted;
            new_line;
            print "   most likely GNAs of names: ", indef_cases, "^";
        }
        else print "seeking definite object^";
    }
    #Endif; ! DEBUG

    match_length = 0; number_matched = 0; match_from = wn;

    SearchScope(domain1, domain2, context);

    #Ifdef DEBUG;
    if (parser_trace >= 4) print "   [ND made ", number_matched, " matches]^";
    #Endif; ! DEBUG

    wn = match_from+match_length;

    ! If nothing worked at all, leave with the word marker skipped past the
    ! first unmatched word...

    if (number_matched == 0) { wn++; rfalse; }

    ! Suppose that there really were some words being parsed (i.e., we did
    ! not just infer).  If so, and if there was only one match, it must be
    ! right and we return it...

    if (match_from <= num_words) {
        if (number_matched == 1) {
            i=match_list-->0;
            return i;
        }

        ! ...now suppose that there was more typing to come, i.e. suppose that
        ! the user entered something beyond this noun.  If nothing ought to follow,
        ! then there must be a mistake, (unless what does follow is just a full
        ! stop, and or comma)

        if (wn <= num_words) {
            i = NextWord(); wn--;
            if (i ~=  AND1__WD or AND2__WD or AND3__WD or comma_word
                   or THEN1__WD or THEN2__WD or THEN3__WD
                   or BUT1__WD or BUT2__WD or BUT3__WD) {
                if (lookahead == ENDIT_TOKEN) rfalse;
            }
        }
    }

    ! Now look for a good choice, if there's more than one choice...

    number_of_classes = 0;

    if (number_matched == 1) {
    	i = match_list-->0;
		if (indef_mode == 1 && indef_type & PLURAL_BIT ~= 0) {
			if (context == MULTI_TOKEN or MULTIHELD_TOKEN or
				MULTIEXCEPT_TOKEN or MULTIINSIDE_TOKEN or
				NOUN_TOKEN or HELD_TOKEN or CREATURE_TOKEN) {
				BeginActivity(DECIDING_WHETHER_ALL_INC_ACT, i);
				if ((ForActivity(DECIDING_WHETHER_ALL_INC_ACT, i)) &&
					(RulebookFailed())) rfalse;
				EndActivity(DECIDING_WHETHER_ALL_INC_ACT, i);
			}
		}
    }
    if (number_matched > 1) {
		i = true;
	    if (number_matched > 1)
	    	for (j=0 : j<number_matched-1 : j++)
				if (Identical(match_list-->j, match_list-->(j+1)) == false)
					i = false;
		if (i) dont_infer = true;
        i = Adjudicate(context);
        if (i == -1) rfalse;
        if (i == 1) rtrue;       !  Adjudicate has made a multiple
                             !  object, and we pass it on
    }

    ! If i is non-zero here, one of two things is happening: either
    ! (a) an inference has been successfully made that object i is
    !     the intended one from the user's specification, or
    ! (b) the user finished typing some time ago, but we've decided
    !     on i because it's the only possible choice.
    ! In either case we have to keep the pattern up to date,
    ! note that an inference has been made and return.
    ! (Except, we don't note which of a pile of identical objects.)

    if (i ~= 0) {
    	if (dont_infer) return i;
        if (inferfrom == 0) inferfrom=pcount;
        pattern-->pcount = i;
        return i;
    }

	if (dont_ask) return match_list-->0;

    ! If we get here, there was no obvious choice of object to make.  If in
    ! fact we've already gone past the end of the player's typing (which
    ! means the match list must contain every object in scope, regardless
    ! of its name), then it's foolish to give an enormous list to choose
    ! from - instead we go and ask a more suitable question...

    if (match_from > num_words) jump Incomplete;

    ! Now we print up the question, using the equivalence classes as worked
    ! out by Adjudicate() so as not to repeat ourselves on plural objects...

	BeginActivity(ASKING_WHICH_DO_YOU_MEAN_ACT);
	if (ForActivity(ASKING_WHICH_DO_YOU_MEAN_ACT)) jump SkipWhichQuestion;
	j = 1; marker = 0;
	for (i=1 : i<=number_of_classes : i++) {
		while (((match_classes-->marker) ~= i) && ((match_classes-->marker) ~= -i))
			marker++;
		if (match_list-->marker hasnt animate) j = 0;
	}
	if (j) PARSER_CLARIF_INTERNAL_RM('A');
	else PARSER_CLARIF_INTERNAL_RM('B');

    j = number_of_classes; marker = 0;
    for (i=1 : i<=number_of_classes : i++) {
        while (((match_classes-->marker) ~= i) && ((match_classes-->marker) ~= -i)) marker++;
        k = match_list-->marker;

        if (match_classes-->marker > 0) print (the) k; else print (a) k;

        if (i < j-1)  print ", ";
        if (i == j-1) {
			#Ifdef SERIAL_COMMA;
			if (j ~= 2) print ",";
        	#Endif; ! SERIAL_COMMA
        	PARSER_CLARIF_INTERNAL_RM('H');
        }
    }
    print "?^";

	.SkipWhichQuestion; EndActivity(ASKING_WHICH_DO_YOU_MEAN_ACT);

    ! ...and get an answer:

  .WhichOne;
    #Ifdef TARGET_ZCODE;
    for (i=2 : i<INPUT_BUFFER_LEN : i++) buffer2->i = ' ';
    #Endif; ! TARGET_ZCODE
    
    .ReParserInput;
    ParserInput( (+ disambiguation context +), inputevent2, buffer2, parse2);
    
	if (input_rulebook_data-->IRDAT_RB_CURRENT ~= 0) {
		print "(BUG) NounDomain called recursively!^";
	}
	parser_results_set = false;
	InputRDataInit( (+ handling input rules +), inputevent2, buffer2, parse2);
	FollowRulebook((+ handling input rules +), (+ disambiguation context +), true);
	InputRDataFinal();
	if (RulebookFailed()) {
		jump ReParserInput;
	}
	
	if (parser_results_set && parser_results-->ACTION_PRES ~= 0) {
		! The rulebook gave us an explicit action. We'll return REPARSE_CODE.
		num_words = 0; players_command = 100;
		jump REPARSE_NO_INPUT;
	}
	
	answer_words = 0;
	if (inputevent2-->0 == evtype_LineInput) {
		#Ifdef TARGET_ZCODE; answer_words = parse2->1; #ifnot; answer_words = parse2-->0; #endif;
	}
	
	if (~~answer_words) {
		! Either this was a blank line or it was not line input at all. Reject it.
		! (Blank line input could reach this point if the PASS_BLANK_INPUT_LINES option is set.)
		EmptyInputParserError();
		jump ReParserInput;
	}

    ! Conveniently, parse2-->1 is the first word in both ZCODE and GLULX.
    first_word = (parse2-->1);

    ! Take care of "all", because that does something too clever here to do
    ! later on:

    if (first_word == ALL1__WD or ALL2__WD or ALL3__WD or ALL4__WD or ALL5__WD) {
        if (context == MULTI_TOKEN or MULTIHELD_TOKEN or MULTIEXCEPT_TOKEN or MULTIINSIDE_TOKEN) {
            l = multiple_object-->0;
            for (i=0 : i<number_matched && l+i<MATCH_LIST_WORDS : i++) {
                k = match_list-->i;
                multiple_object-->(i+1+l) = k;
            }
            multiple_object-->0 = i+l;
            rtrue;
        }
        PARSER_CLARIF_INTERNAL_RM('C');
        jump WhichOne;
    }

	! Look for a comma, and interpret this as a fresh conversation command
	! if so:

	for (i=1 : i<=answer_words : i++)
		if (WordFrom(i, parse2) == comma_word) {
            VM_CopyBuffer(buffer, buffer2);
            jump RECONSTRUCT_INPUT;		
		}

    ! If the first word of the reply can be interpreted as a verb, then
    ! assume that the player has ignored the question and given a new
    ! command altogether.
    ! (This is one time when it's convenient that the directions are
    ! not themselves verbs - thus, "north" as a reply to "Which, the north
    ! or south door" is not treated as a fresh command but as an answer.)

    #Ifdef LanguageIsVerb;
    if (first_word == 0) {
        j = wn; first_word = LanguageIsVerb(buffer2, parse2, 1); wn = j;
    }
    #Endif; ! LanguageIsVerb
    if (first_word ~= 0) {
        j = first_word->#dict_par1;
        if ((0 ~= j&1) && ~~LanguageVerbMayBeName(first_word)) {
            VM_CopyBuffer(buffer, buffer2);
            jump RECONSTRUCT_INPUT;
        }
    }

    ! Now we insert the answer into the original typed command, as
    ! words additionally describing the same object
    ! (eg, > take red button
    !      Which one, ...
    !      > music
    ! becomes "take music red button".  The parser will thus have three
    ! words to work from next time, not two.)

    #Ifdef TARGET_ZCODE;
    k = WordAddress(match_from) - buffer; l=buffer2->1+1;
    for (j=buffer + buffer->0 - 1 : j>=buffer+k+l : j-- ) j->0 = 0->(j-l);
    for (i=0 : i<l : i++) buffer->(k+i) = buffer2->(2+i);
    buffer->(k+l-1) = ' ';
    buffer->1 = buffer->1 + l;
    if (buffer->1 >= (buffer->0 - 1)) buffer->1 = buffer->0;
    #Ifnot; ! TARGET_GLULX
    k = WordAddress(match_from) - buffer;
    l = (buffer2-->0) + 1;
    for (j=buffer+INPUT_BUFFER_LEN-1 : j>=buffer+k+l : j-- ) j->0 = j->(-l);
    for (i=0 : i<l : i++) buffer->(k+i) = buffer2->(WORDSIZE+i);
    buffer->(k+l-1) = ' ';
    buffer-->0 = buffer-->0 + l;
    if (buffer-->0 > (INPUT_BUFFER_LEN-WORDSIZE)) buffer-->0 = (INPUT_BUFFER_LEN-WORDSIZE);
    #Endif; ! TARGET_

    ! Having reconstructed the input, we warn the parser accordingly
    ! and get out.

	.RECONSTRUCT_INPUT;

	num_words = WordCount(); players_command = 100 + num_words;
    wn = 1;
    #Ifdef LanguageToInformese;
    LanguageToInformese();
    ! Re-tokenise:
    VM_Tokenise(buffer,parse);
    #Endif; ! LanguageToInformese
	num_words = WordCount(); players_command = 100 + num_words;
	.REPARSE_NO_INPUT;
    actors_location = ScopeCeiling(player);
	FollowRulebook(Activity_after_rulebooks-->READING_A_COMMAND_ACT);

    return REPARSE_CODE;

    ! Now we come to the question asked when the input has run out
    ! and can't easily be guessed (eg, the player typed "take" and there
    ! were plenty of things which might have been meant).

  .Incomplete;

    if (context == CREATURE_TOKEN) PARSER_CLARIF_INTERNAL_RM('D', actor);
    else                           PARSER_CLARIF_INTERNAL_RM('E', actor);
    new_line;

    #Ifdef TARGET_ZCODE;
    for (i=2 : i<INPUT_BUFFER_LEN : i++) buffer2->i=' ';
    #Endif; ! TARGET_ZCODE
    
    .ReParserInput2;
    ParserInput( (+ disambiguation context +), inputevent2, buffer2, parse2);
    
	if (input_rulebook_data-->IRDAT_RB_CURRENT ~= 0) {
		print "(BUG) NounDomain called recursively!^";
	}
	parser_results_set = false;
	InputRDataInit( (+ handling input rules +), inputevent2, buffer2, parse2);
	FollowRulebook((+ handling input rules +), (+ disambiguation context +), true);
	InputRDataFinal();
	if (RulebookFailed()) {
		jump ReParserInput2;
	}
	
	if (parser_results_set && parser_results-->ACTION_PRES ~= 0) {
		! The rulebook gave us an explicit action. We'll return REPARSE_CODE.
		num_words = 0; players_command = 100;
		jump REPARSE_NO_INPUT;
	}
	
	answer_words = 0;
	if (inputevent2-->0 == evtype_LineInput) {
		#Ifdef TARGET_ZCODE; answer_words = parse2->1; #ifnot; answer_words = parse2-->0; #endif;
	}

	if (~~answer_words) {
		! Either this was a blank line or it was not line input at all. Reject it.
		! (Blank line input could reach this point if the PASS_BLANK_INPUT_LINES option is set.)
		EmptyInputParserError();
		jump ReParserInput2;
	}

	! Look for a comma, and interpret this as a fresh conversation command
	! if so:

	for (i=1 : i<=answer_words : i++)
		if (WordFrom(i, parse2) == comma_word) {
			VM_CopyBuffer(buffer, buffer2);
			return REPARSE_CODE;
		}

    first_word=(parse2-->1);
    #Ifdef LanguageIsVerb;
    if (first_word==0) {
        j = wn; first_word=LanguageIsVerb(buffer2, parse2, 1); wn = j;
    }
    #Endif; ! LanguageIsVerb

    ! Once again, if the reply looks like a command, give it to the
    ! parser to get on with and forget about the question...

    if (first_word ~= 0) {
        j = first_word->#dict_par1;
        if ((0 ~= j&1) && ~~LanguageVerbMayBeName(first_word)) {
            VM_CopyBuffer(buffer, buffer2);
            return REPARSE_CODE;
        }
    }

    ! ...but if we have a genuine answer, then:
    !
    ! (1) we must glue in text suitable for anything that's been inferred.

    if (inferfrom ~= 0) {
        for (j=inferfrom : j<pcount : j++) {
            if (pattern-->j == PATTERN_NULL) continue;
            #Ifdef TARGET_ZCODE;
            i = 2+buffer->1; (buffer->1)++; buffer->(i++) = ' ';
            #Ifnot; ! TARGET_GLULX
            i = WORDSIZE + buffer-->0;
            (buffer-->0)++; buffer->(i++) = ' ';
            #Endif; ! TARGET_

            #Ifdef DEBUG;
            if (parser_trace >= 5)
            	print "[Gluing in inference with pattern code ", pattern-->j, "]^";
            #Endif; ! DEBUG

            ! Conveniently, parse2-->1 is the first word in both ZCODE and GLULX.

            parse2-->1 = 0;

            ! An inferred object.  Best we can do is glue in a pronoun.
            ! (This is imperfect, but it's very seldom needed anyway.)

            if (pattern-->j >= 2 && pattern-->j < REPARSE_CODE) {
                PronounNotice(pattern-->j);
                for (k=1 : k<=LanguagePronouns-->0 : k=k+3)
                    if (pattern-->j == LanguagePronouns-->(k+2)) {
                        parse2-->1 = LanguagePronouns-->k;
                        #Ifdef DEBUG;
                        if (parser_trace >= 5)
                        	print "[Using pronoun '", (address) parse2-->1, "']^";
                        #Endif; ! DEBUG
                        break;
                    }
            }
            else {
                ! An inferred preposition.
                parse2-->1 = VM_NumberToDictionaryAddress(pattern-->j - REPARSE_CODE);
                #Ifdef DEBUG;
                if (parser_trace >= 5)
                	print "[Using preposition '", (address) parse2-->1, "']^";
                #Endif; ! DEBUG
            }

            ! parse2-->1 now holds the dictionary address of the word to glue in.

            if (parse2-->1 ~= 0) {
                k = buffer + i;
                #Ifdef TARGET_ZCODE;
                @output_stream 3 k;
                 print (address) parse2-->1;
                @output_stream -3;
                k = k-->0;
                for (l=i : l<i+k : l++) buffer->l = buffer->(l+2);
                i = i + k; buffer->1 = i-2;
                #Ifnot; ! TARGET_GLULX
                k = Glulx_PrintAnyToArray(buffer+i, INPUT_BUFFER_LEN-i, parse2-->1);
                i = i + k; buffer-->0 = i - WORDSIZE;
                #Endif; ! TARGET_
            }
        }
    }

    ! (2) we must glue the newly-typed text onto the end.

    #Ifdef TARGET_ZCODE;
    i = 2+buffer->1; (buffer->1)++; buffer->(i++) = ' ';
    for (j=0 : j<buffer2->1 : i++,j++) {
        buffer->i = buffer2->(j+2);
        (buffer->1)++;
        if (buffer->1 == INPUT_BUFFER_LEN) break;
    }
    #Ifnot; ! TARGET_GLULX
    i = WORDSIZE + buffer-->0;
    (buffer-->0)++; buffer->(i++) = ' ';
    for (j=0 : j<buffer2-->0 : i++,j++) {
        buffer->i = buffer2->(j+WORDSIZE);
        (buffer-->0)++;
        if (buffer-->0 == INPUT_BUFFER_LEN) break;
    }
    #Endif; ! TARGET_

    ! (3) we fill up the buffer with spaces, which is unnecessary, but may
    !     help incorrectly-written interpreters to cope.

    #Ifdef TARGET_ZCODE;
    for (: i<INPUT_BUFFER_LEN : i++) buffer->i = ' ';
    #Endif; ! TARGET_ZCODE

	jump RECONSTRUCT_INPUT; ! fix c.f. Mantis 1694
    !return REPARSE_CODE;

]; ! end of NounDomain

[ PARSER_CLARIF_INTERNAL_R; ];

-) instead of "Noun Domain" in "Parser.i6t".


Section - Test Input

Include (-

#Iftrue ({-value:NUMBER_CREATED(test_scenario)} > 0);

[ TestScriptSub;
	switch(special_word) {
{-call:PL::Parsing::TestScripts::compile_switch}
	default:
		print ">--> The following tests are available:^";
{-call:PL::Parsing::TestScripts::compile_printout}
	}
];

#ifdef TARGET_GLULX;
Constant TEST_STACK_SIZE = 128;
#ifnot;
Constant TEST_STACK_SIZE = 48;
#endif;

Array test_stack --> TEST_STACK_SIZE;
Global test_sp = 0;
[ TestStart T R l k;
	if (test_sp >= TEST_STACK_SIZE) ">--> Testing too many levels deep";
	test_stack-->test_sp = T;
	test_stack-->(test_sp+1) = 0;
	test_stack-->(test_sp+3) = l;
	test_sp = test_sp + 4;
	if ((R-->0) && (R-->0 ~= real_location)) {
	     print "(first moving to ", (name) R-->0, ")^";
	     PlayerTo(R-->0, 1);
	}
	k=1;
	while (R-->k) {
	    if (R-->k notin player) {
	        print "(first acquiring ", (the) R-->k, ")^";
	        move R-->k to player;
	    }
	    k++;
	}
	print "(Testing.)^"; say__p = 1;
];

! CheckTestInput: If a test input is pending, this fills out the event and buffer structure and returns true. Otherwise it returns false.
! This function is allowed to return any event type (even arrange or timer events). A test line beginning with '$' indicates a special event (not line input): $char X, $link Y, $timer. Unrecognized specials are skipped. See the documentation for details.
! Note that a_buffer may be 0. If so, we skip past line input events, since there's no buffer to put them in.
! (This replaces TestKeyboardPrimitive, but is invoked differently. We no longer call through to VM_ReadKeyboard when no tests are available. We just return false. Also, arguments are event/buffer instead of buffer/table.)

[ CheckTestInput a_event a_buffer    p i arg l res obj ch wd;
	.checkev_restart;
	
	if (test_sp == 0) {
		! Out of tests entirely.
		test_stack-->2 = 1;
		return false;
	}

	arg = 0;
	a_event-->0 = evtype_None;
	
	p = test_stack-->(test_sp-4);
	i = test_stack-->(test_sp-3);
	l = test_stack-->(test_sp-1);
	print "[";
	print test_stack-->2;
	print "] ";
	test_stack-->2 = test_stack-->2 + 1;
	style bold;
	
	! Note that each test-string array ends with four bytes of padding, so
	! we can use sloppy lookahead.
	
	if (i < l && p->i == '$') {
		wd = CheckTestDictWord(p+i, l-i);
		if (wd == '$char') {
			i = i+5;   ! skip '$char'
			! skip whitespace
			while ((i < l) && (p->i == ' '))
				i++;
			if ((i >= l) || (p->i == '/')) {
				! no argument; use space
				arg = ' ';
			}
			else if ((i+1 >= l) || (p->(i+1) == '/')) {
				! single-char argument; take literally
				arg = p->i;
				i++;
			}
			else if (p->i >= '0' && p->i <= '9') {
				! numeric argument; take as ASCII/Unicode code
				arg = 0;
				while (p->i >= '0' && p->i <= '9') {
					arg = arg * 10 + (p->i - '0');
					i++;
				}
			}
			else {
				! check for a special keyword
				wd = CheckTestDictWord(p+i, l-i);
				arg = 0;
				for (ch=0; TestSpecialKeys-->ch; ch=ch+2) {
					if (wd == TestSpecialKeys-->(ch+1)) {
						arg = TestSpecialKeys-->ch;
						break;
					}
				}
				if (~~arg) {
					print "$char ";
					while ((i < l) && (p->i ~= '/')) {
						print (char) p->i;
						i++;
					}
					print " (char name not recognized)";
					jump checkev_parsed;
				}
			}
			print "$char ";
			if (arg >= 0 && arg < 32)
				print "ctrl-", (char) (arg+64);
			else if (arg == 32)
				print "space";
			else
				PrintUnicodeSpecialName(arg);
			a_event-->0 = evtype_CharInput;
			a_event-->1 = gg_mainwin;
			a_event-->2 = arg;
			jump checkev_parsed;
		}
		if (wd == '$link') {
			i = i+5;   ! skip '$link'
			! skip whitespace
			while ((i < l) && (p->i == ' '))
				i++;
			if (p->i >= '0' && p->i <= '9') {
				! numeric argument
				arg = 0;
				while (p->i >= '0' && p->i <= '9') {
					arg = arg * 10 + (p->i - '0');
					i++;
				}
				print "$link ", arg;
			}
			else {
				! text argument; try to find a matching object
				arg = 0;
				wd = CheckTestDictWord(p+i, l-i);
				if (wd) {
					objectloop (obj ofclass Object && obj.&name) {
						for (ch=0; ch*WORDSIZE<obj.#name; ch++) {
							if (obj.&name-->ch == wd) {
								arg = obj;
								break;
							}
						}
					}
				}
				if (~~arg) {
					print "$link ";
					while ((i < l) && (p->i ~= '/')) {
						print (char) p->i;
						i++;
					}
					print " (link object not recognized)";
					jump checkev_parsed;
				}
				print "$link ", (name) arg;
			}
			a_event-->0 = evtype_Hyperlink;
			a_event-->1 = gg_mainwin;
			a_event-->2 = arg;
			jump checkev_parsed;
		}
		if (wd == '$timer') {
			i = i+6;   ! skip '$timer'
			print "$timer";
			a_event-->0 = evtype_Timer;
			jump checkev_parsed;
		}
		while ((i < l) && (p->i ~= '/')) {
			print (char) p->i;
			i++;
		}
		print " (event not recognized)";
		jump checkev_parsed;
	}
	else {
		! line input
		if (~~a_buffer) {
			! Can't generate a line event without a buffer to write it in.
			print "(no buffer for line input)";
			jump checkev_parsed;
		}

		arg = 0;
		while ((i < l) && (p->i ~= '/')) {
			ch = p->i;
			if ((p->i == '[') && (p->(i+1) == '/' or '$') && (p->(i+2) == ']')) {
				ch = p->(i+1); i = i+2;
			}
			a_buffer->(arg+WORDSIZE) = ch;
			print (char) ch;
			i++; arg++;
		}
		a_event-->0 = evtype_LineInput;
		a_event-->1 = gg_mainwin;
		a_event-->2 = arg;
		! (We don't have to tokenize; AwaitInput will handle that.)
	}
	
	.checkev_parsed;
	style roman;
	print "^";
	
	! Eat up any characters up to the next slash, if we haven't already.
	while ((i < l) && (p->i ~= '/')) {
		if ((p->i == '[') && (p->(i+1) == '/' or '$') && (p->(i+2) == ']')) {
			i = i+2;
		}
		i++;
	}
	
	! Consume the next slash and advance to the next test.
	if (p->i == '/') i++;
	if (i >= l) {
		test_sp = test_sp - 4;
	} else test_stack-->(test_sp-3) = i;
	
	! If no test event was successfully parsed, we restart and look at the
	! next one. (Returning false would be wrong; that would halt the whole
	! test sequence.)
	if (a_event-->0 == evtype_None) {
		jump checkev_restart;
	}
	
	return true;
];

! Look at a single word in a test string and return the matching dict word
! (or 0). Words are terminated by space or slash.
[ CheckTestDictWord buf buflen   ix dictlen entrylen val res;
	dictlen = #dictionary_table-->0;
	entrylen = DICT_WORD_SIZE + 7;

	! Copy the word into the gg_tokenbuf array, clipping to DICT_WORD_SIZE
	! characters and lower case.
	for (ix=0 : ix<buflen && ix < DICT_WORD_SIZE && (buf->ix ~= '/' or ' ') : ix++)
		gg_tokenbuf->ix = VM_UpperToLowerCase(buf->ix);
	for (: ix<DICT_WORD_SIZE : ix++) gg_tokenbuf->ix = 0;

	val = #dictionary_table + WORDSIZE;
	@binarysearch gg_tokenbuf DICT_WORD_SIZE val entrylen dictlen 1 1 res;
	return res;
];

Array TestSpecialKeys --> 32 'space' keycode_Left 'left' keycode_Right 'right' keycode_Up 'up' keycode_Down 'down' keycode_Return 'return' keycode_Delete 'delete' keycode_Escape 'escape' keycode_Tab 'tab' keycode_PageUp 'pageup' keycode_PageDown 'pagedown' keycode_Home 'home' keycode_End 'end' keycode_Func1 'func1' keycode_Func2 'func2' keycode_Func3 'func3' keycode_Func4 'func4' keycode_Func5 'func5' keycode_Func6 'func6' keycode_Func7 'func7' keycode_Func8 'func8' keycode_Func9 'func9' keycode_Func10 'func10' keycode_Func11 'func11' keycode_Func12 'func12' 0 0;


#IFNOT;

[ TestScriptSub;
	">--> No test scripts exist for this game.";
];

#ENDIF;

-) instead of "Test Command" in "Tests.i6t".

Section - Command Stream Input

Include (-

#ifdef DEBUG;

! RecordingReadEvent: If a line of input is pending from the command stream, this fills out the event and buffer structure and returns true. Otherwise it returns false.
! If the command stream ends, this closes it.
[ RecordingReadEvent a_event a_buffer;
	if (~~gg_commandstr)
		rfalse;
	if (~~gg_command_reading)
		rfalse;
	!### this doesn't actually work yet.
	rfalse;
];

! RecordingWriteEvent: Write an event to the command stream.
[ RecordingWriteEvent a_event a_buffer   val;
	if (~~gg_commandstr)
		return;
	if (gg_command_reading)
		return;
	
	switch (a_event-->0) {
	
		evtype_CharInput:
			RecordingWriteRawString(">$char ");
			val = a_event-->2;
			if (val == ' ') {
				RecordingWriteRawString("space");
			}
			else if (val < ' ' || UnicodeCharIsSpecial(val)) {
				RecordingWriteRawFunc(PrintUnicodeSpecialName, val);
			}
			else {
				glk_put_char_stream_uni(gg_commandstr, val);
			}
			glk_put_char_stream(gg_commandstr, 10); ! newline
			
		evtype_LineInput:
			glk_put_char_stream(gg_commandstr, '>');
			glk_put_char_stream(gg_commandstr, ' ');
			if (a_buffer)
				glk_put_buffer_stream(gg_commandstr, a_buffer+WORDSIZE, a_buffer-->0);
			glk_put_char_stream(gg_commandstr, 10); ! newline
			
		evtype_Hyperlink:
			RecordingWriteRawString(">$link ");
			RecordingWriteRawNumber(a_event-->2);
			glk_put_char_stream(gg_commandstr, 10); ! newline
			
	}
];

[ RecordingWriteRawString val  oldstr;
	oldstr = glk_stream_get_current();
	glk_stream_set_current(gg_commandstr);
	print (string) val;
	glk_stream_set_current(oldstr);
];

[ RecordingWriteRawNumber val  oldstr;
	oldstr = glk_stream_get_current();
	glk_stream_set_current(gg_commandstr);
	print val;
	glk_stream_set_current(oldstr);
];

[ RecordingWriteRawFunc func val  oldstr;
	oldstr = glk_stream_get_current();
	glk_stream_set_current(gg_commandstr);
	func(val);
	glk_stream_set_current(oldstr);
];

#ifnot; ! DEBUG

! Stubs which do nothing in release mode.

[ RecordingReadEvent a_event a_buffer;
	rfalse;
];

[ RecordingWriteEvent a_event a_buffer;
	rfalse;
];

#endif; ! DEBUG

-).


Section - Miscellaneous

Include (-

! This prints the "I beg your pardon" parser error. We use this when the player enters a blank line, or a input event which is not text at all (and which is not otherwise handled). There are several points in the code where we check this, so it makes sense to factor out a simple function.
[ EmptyInputParserError   oldetype;
	oldetype = etype; etype = BLANKLINE_PE;
	BeginActivity(PRINTING_A_PARSER_ERROR_ACT);
	if (ForActivity(PRINTING_A_PARSER_ERROR_ACT) == false) {
		PARSER_ERROR_INTERNAL_RM('X'); new_line;
	}
	EndActivity(PRINTING_A_PARSER_ERROR_ACT);
	etype = oldetype;
];

-) after "Reading the Command" in "Parser.i6t".

Include (-

! Copy an I6 buffer (containing bytes) into an I7 text variable. This is basically a simplified version of TEXT_TY_CastPrimitive; we know the length in advance, which makes it all much easier.
[ TEXT_CopyFromByteArray txt buf len    ubuf ix;
	! TEXT_TY_Cast does this before casting from a snippet.
	TEXT_TY_Transmute(txt);

	ubuf = VM_AllocateMemory((len+1) * WORDSIZE);
	
	for (ix=0 : ix<len : ix++) {
		ubuf-->ix = buf->ix;
	}
	ubuf-->len = 0;
	! I don't know if the terminal null is necessary, but TEXT_TY_CastPrimitive adds one. Magic chickens away!
	
	BlkValueMassCopyFromArray(txt, ubuf, 4, len+1);
	
	VM_FreeMemory(ubuf);
];

-).

Include (-
! KeyboardPrimitive no longer exists.
-) instead of "Keyboard Primitive" in "Parser.i6t".

Include (-
! PrintPrompt no longer exists.
-) instead of "Prompt" in "Printing.i6t".


Unified Glulx Input ends here.

---- DOCUMENTATION ----

Unified Glulx Input is an attempt to tidy up all the messy I6 APIs that you need to customize your game's input system. 

The Glulx Entry Points extension does this already, but that exposes all the mess -- you have to understand how Glk works to use to correctly. Unified Glulx Input tries to offer you a simple model which handles common cases easily.

(This extension was written and tested with Inform 7 releases 6L38 and 6M62.)

Chapter: Basic concepts

Section: Input-contexts: why are we awaiting input?

A game can stop and await input for many reasons. It can be waiting for a command, or for a yes-or-no answer (an "if the player consents..." test). It can be waiting for the player to hit any key to continue.

In Unified Glulx Input, all of these inputs invoke the same mechanism. The mechanism can be customized to behave in different ways -- printing different prompts, waiting for different sorts of input. But it's always the same mechanism underneath.

You customize it by writing rules. The extension has five rulebooks which cover various aspects of the problem. The default rules cover the normal input situations of an IF game -- the ones mentioned above. Of course, you can modify these or add more.

We distinguish these situations with a value called an "input-context". The rulebooks we mentioned are input-context based rulebooks. The UGI extension comes with seven:

	primary context, disambiguation context (the command input-contexts)
	yes-no question context, extended yes-no question context, repeat yes-no question context (the yes-no input-contexts)
	final question context
	keystroke-wait context

The first two (primary and disambiguation) are used by the main game loop -- the core cycle of fetching and performing commands. The others are special-purpose, ad-hoc inputs.

These are more finely divided than you usually need to bother with. For example, the game might be waiting for a normal command (primary context) or for a disambiguation reply (disambiguation context). In most games these will appear the same. So you can handle them together. For example:

	Prompt displaying rule for a command input-context:
		instead say ">>>";

This rule changes the command prompt for all main-game-loop inputs (both primary and disambiguation).

Section: G-events: what kind of input are we awaiting?

Most IF input comes as lines of text. But a game can also accept keystroke input, as in a "hit any key" prompt or a menu controlled with arrow keys.

Glulx currently supports eight types of input, described as "g-event" values:

	char-event - a keystroke
	line-event - a line of text
	hyperlink-event - selection of a hyperlink
	timer-event - event repeated at fixed intervals
	mouse-event - a mouse click
	arrange-event - window sizes have changed
	redraw-event - graphics windows need redrawing
	sound-notify-event - sound finished playing

Section: Glk-windows: what window is awaiting input?

This version of UGI is only concerned with one window, the "story-window". You can set various properties of the story-window object to customize its behavior.

There is also a "status-window" object, but it is not yet functional. Future versions of UGI will support this. Future versions will also integrate with the Multiple Windows extension to support multi-window games.

Chapter: High-level tasks

These phrases can be used with no deeper knowledge of UGI.

Section: Yes-no questions

	if the player consents: ...

This works just as it always has (WWI 11.5); it waits for the player to type "yes" or "no". You are expected to print the question first.

	if the player consents asking (T1 - text): ...
	if the player consents asking (T1 - text) and (T2 - text): ...

Similar, except UGI uses your text as the prompt (through the magic of the prompt displaying rulebook). T1 should be the initial question; T2 is a followup if the player fails to answer. If you don't supply T2, it defaults to "Please answer yes or no."

Section: Waiting for a key

These phrases are copied from the Basic Screen Effects extension; they have been updated here to work with UGI.

	wait for any key
	wait for the SPACE key

By default no prompt is printed. You can print your own beforehand, or write a prompt displaying rule:

	Prompt displaying rule for keystroke-wait context:
		say ">>>";

If you want to cause a wait and then get the key that was hit:

	the key waited for -- Unicode character

Include the Unicode Character Names extension for a complete list of characters, or my ASCII Character Names extension for the basic ones. The result may also be a special value representing a control key:

	special keycode left, special keycode right, special keycode up, special keycode down, special keycode return, special keycode delete, special keycode escape, special keycode tab, special keycode pageup, special keycode pagedown, special keycode home, special keycode end, special keycode func1, ... special keycode func12

These are not part of the Unicode spec, but I7 represents them as Unicode character values. (They are outside the official Unicode range of $0 to $10FFFF.) Don't try to print them or insert them into normal texts -- they have no normal printed representation. If you need to print a special character, use this phrase:

	say extended (C - Unicode character)

This will print special characters as "left", "right", and so on. Normal Unicode characters will be printed directly.

Chapter: The five rulebooks

We've talked about the five rulebooks, and now it's time to introduce them:

	setting up input rules - decide what kinds of input are desired
	prompt displaying rules - display a prompt, traditionally ">"
	accepting input rules - accept, reject, or alter individual input events
	checking undo input rules - check whether an input event is an UNDO command
	handling input rules - convert an input event into an action

These rulebooks are based on an input-context value. So you might write

	Prompt displaying rule for yes-or-no context: ...
	Accepting input rule for a command input-context: ...

Section: Setting up input rules

This rulebook decides what sort of input the game desires for player commands. It also decides whether the command will be an undo step. By default it requests only line input, and says that all line inputs are undo steps.

This rulebook applies only to the command contexts (primary and disambiguation). Other questions (yes-or-no, keystroke-wait, etc) do their own setup (and are not undo steps).

To customize this, set the input-request, hyperlink-input-request, and mouse-input-request properties of the story-window object. For example:

	Setting up input rule:
		now the input-request of the story-window is char-input;
		now the story-window is hyperlink-input-request;

The input-request property can be char-input, line-input, or no-input. (These are mutually exclusive.) You can set hyperlink-input-request and mouse-input-request independently.

(Note that mouse-input-request does not apply to the story-window -- buffer windows have no fixed coordinates -- so it cannot currently be used. There is a status-window object, but UGI does not yet support input requests for it.)

To indicate whether this command is an undo step, use one of these phrases:

	set input undoable
	set input non-undoable

When you set input undoable, you're telling the parser that the player *can* perform an UNDO command (whether by typing "UNDO" or some other way) and therefore this is a turn that should be added to the undo chain. If you set input non-undoable, you're telling the parser that UNDO is not supported for this command, and future UNDO commands should skip back over it.

To make this more clear: when the player does an UNDO, they don't want to jump back to the previous *input*; they want to jump back to the previous *turn*. Yes-or-no commands are inputs but never turns. When the setting-up-input rulebook is called, it's *usually* a turn, but you might want to decide otherwise.

(Note: you can suppress UNDO for your game this way, but it's better to use the "undo prevention" option. That way, UNDO commands will say "The use of 'undo' is forbidden", rather than just throwing a "not a verb I recognize" error.)

We'd better mention how to display hyperlinks in your game text. A hyperlink can contain a number or an object reference. (Or, really, any value that can be cast to an I6 integer, which is any value at all. But stick with the easy cases.) (It's best not to mix numbers and objects in the same game. Pick one.)

	say hyperlink (O - object)
	say hyperlink (N - number)
	say /hyperlink

Use these phrases in text as markup:

	say "You see a [hyperlink sword]ancient elvish sword[/hyperlink]."

Section: Prompt displaying rules

This rulebook displays a prompt before input. It applies to all input contexts.

The default for keystroke input is no prompt. For yes-no input it is ">", unless you've specified prompts by invoking the "player consents asking..." phrase. For the final question, the prompt is "> [run paragraph on]" (as defined by the old print the final prompt rule).

For other cases, including all command contexts, the prompt is ">". You can customize this by changing the old command prompt global variable, or by writing a rule:

	Prompt displaying rule for a command input-context: ...

(See example: "Changing the Prompt".)

Section: Accepting input rules

This rulebook decides whether to accept or reject an incoming event, or convert the event to a different event. It applies to all input contexts.

This is the fussiest rulebook in UGI. It's also the one you will use least often! For many games, the default rules are all you need. So don't be overwhelmed by the description here.

Every time an event arrives, this rulebook is invoked. You can get the event type with this phrase:

	the current input event type -- g-event

So you can write a rule like:

	Handling input rule when the current input event type is hyperlink-event:

Or, as a handy shortcut:

	Handling input rule when handling hyperlink-event:

Depending on the current event type, you can check its contents with one of these phrases:

	the current input event character -- Unicode character
	the current input event hyperlink number -- number
	the current input event hyperlink object -- object
	the current input event line text -- text
	the current input event line word count -- number

An important note: in the accepting input rulebook, the "player's command" snippet has not yet been set up. You cannot refer to this or any other snippet variable; you will get errors. Use the "current input event line text" phrase.

The job of the accepting input rulebook is to reject the event (keep waiting) or accept it (stop waiting and allow event to be processed). These are available as phrases (really just aliases for "rule succeeds" and "rule fails"):

	accept the input event
	reject the input event

The default rules accept character, line, and hyperlink events (assuming they were requested by the setting up input rules). Other event types are rejected by default, although a rearrange event will trigger a status-line refresh first.

You can also convert the event to a different one:

	replace the current input event with the line (T - text)
	replace the current input event with the character (C - Unicode character)
	replace the current input event with the hyperlink object (O - object)
	replace the current input event with the hyperlink number (N - number)

This is handy for simple cases -- perhaps you want to convert hyperlink clicks into a line of text and run that through the parser in the usual way. (See example: "Maze of Keys".) However, it's cleaner to handle hyperlinks in the handling input rulebook. See next section.

Here's the messy part. If you've requested character or line input, and a *different* input event arrives, the character or line input is still in progress. *You may not print text as long as character or line input is in progress.*

To be clear, this is not a problem when you *receive* a character or line event. That signals that the input is complete and printing is safe. But if you get another event type (say a timer or hyperlink event) while char/line input is in progress, you must either

(a) take background action that does not print to the story window, or

(b) accept the event, printing nothing, or

(c) interrupt text input before printing.

The standard redraw status line on arrange rule is an example of policy (a). It redraws the status line (and then rejects the event to continue waiting). See example: "Tick Tick Tick Button".

Policy (b) is fine if you plan to handle the event in the handling input rulebook. See next section.

For policy (c), you'll have to call this phrase:

	interrupt text input for (W - glk-window)

This stops line or character input. If you then reject the event, input will be re-requested automatically.

	interrupt text input for (W - glk-window), preserving input

This variation stores the player's in-progress input as the preload-input-text property of the story-window. The next time line input starts, the string will be pre-loaded into the input buffer. (See example: "Master Blaster".)

The interrupt text input phrase has an additional use: it tells UGI that you're about to print text, so the prompt might have to be redisplayed. This is sometimes helpful if you're rejecting an input event with an error message (rather than silently).

Finally, I'll say again: this is the least commonly used of the five rulebooks! Forget the mess above and read on.

Section: Checking undo input rules

At this point an input event has been accepted. This rulebook decides whether it's an UNDO command.

(UNDO commands are special; they never reach the handling-input stage, and they never become an "undoing" action. There is no such action, in fact. This is awkward but it's just the way the parser is. So we need this special rulebook to detect them.)

The default rule in this rulebook checks for line input containing just the word "UNDO". That's the expected behavior for games that accept line input.

If your game works by keystroke or hyperlink input, you might still want to support UNDO. You could write an accepting input rule that replaces the current input event with the line "undo". (See example: "Maze of Keys".) However, it's cleaner to write a checking undo rule which checks for whatever UNDO input your game wants. (See example: "Maze of Keys 2".)

This is important: if you set input undoable at setting-up-input time, you *must* accept at least one input as UNDO at checking-undo-input time! If you don't, you'll break multiple undo for the player. (They won't be able to UNDO back through this command.) 

Contrariwise, if you forget to set input undoable at setting-up-input time, then UNDO will not work for this command. The checking-undo-input rulebook will be skipped.

Section: Handling input rules

At this point an input event has been accepted (and it wasn't UNDO). This rulebook decides how to convert it into an action.

This rulebook applies only to the command contexts (primary and disambiguation). Other questions (yes-or-no, keystroke-wait, etc) do their own setup.

The phrases mentioned above, for examining the input event, still apply:

	the current input event type -- g-event
	if handling (G - g-event): ...
	the current input event character -- Unicode character
	the current input event hyperlink number -- number
	the current input event hyperlink object -- object
	the current input event line text -- text
	the current input event line word count -- number
	accept the input event
	reject the input event

If your rule rejects the event, the command does nothing. The game prompts for another command.

If your rule accepts the event, it is processed. Line input is parsed in the classic way. Any other input type causes an "I beg your pardon?" error.

So what do we do with other input types? Usually you'll invoke this phrase:

	handle the current input event as (act - stored action)

This bypasses the parser entirely. The game will proceed as if the given action had been parsed; the player will carry it out (or try to). For example, if you had a hyperlink labelled "INVENTORY", you might write:

	Handling input rule when handling hyperlink-event:
		handle the current input event as the action of taking inventory;
		accept the input event.

(Note that a stored action is always phrased "the action of...".)

See example: "A Study In Memoriam".

By the way, at the handling-input stage, all inputs have been completed or cancelled. You don't have to worry about manually interrupting text input.

Section: Which rulebook again?

The accepting-input and handling-input rulebooks both operate on input events. They both can accept and reject events. When you're building a game, you may find yourself unsure which to use.

The rules of thumb:

- If you want to generate an action, use a handling input rule.

- If you want to convert some event into a line input event, you can use either, but handling input will probably be simpler.

- If you want to respond to an event without interrupting the player's input, use an accepting input rule.

- If you want to reject an event without even printing a new prompt, use an accepting input rule.

- If you want to respond to events in every input context (including yes-or-no, keystroke-wait, etc) use an accepting input rule.

Section: What about the reading a command activity?

The old "reading a command" activity still exists under UGI. It's called by the same code that runs the handling input rulebook. It's not the same thing, though; we must be careful of the differences.

- Reading a command is an activity. You can write before rules and after rules for it. The accepting input and handling input rulebooks run "inside" reading a command -- between the before and after stages of the activity.

- In an after reading a command rule, you can refer to (or replace) the "player's command" snippet. That's not allowed in a handling input rule; the player's command is not yet set up during that rulebook.

- In a handling input rule, you can say "handle the current input event as the action of...". That's not available at after reading a command time.

- For a disambiguation input, the handling input rule sees what the player typed. In contrast, the player's command (in an after reading a command rule) is the *entire* disambiguated command! An example:

	>GET
	(handling input: text="GET".)
	(after reading: player's command="GET".)
	What do you want to get?
	>RED ROCK
	(handling input: text="RED ROCK".)
	(after reading: player's command="GET RED ROCK".)
	Taken.

In short, the reading a command activity is the most sensible place to examine or replace text. The handling input rulebook is primarily meant for translating *non-textual* input events into actions.

Chapter: The flow of the machinery

It may be helpful to diagram the whole input machine and describe exactly when each rulebook runs.

	(top of parser loop:)
	do before reading a command activity
	repeat until a command is accepted:
		...
		(ParserInput function:)
		repeat until an event is accepted:
			follow setting up input rules
			...
			(AwaitInput function:)
			repeat until an event is accepted:
				follow prompt displaying rules
				redraw the status line
				make all necessary Glk input requests
				wait for an input event to arrive
				follow the accepting input rules
			cancel any remaining Glk input requests
			(end of AwaitInput function)
			...
			reject blank lines ("I beg your pardon")
			if the setting-up rules said that this is an undoable turn:
				follow checking undo input rules
				if the input was an UNDO command:
					perform UNDO
				save an undo point
		(end of ParserInput function)
		...
		follow handling input rules
	(at this point, the "player's command" is set)
	do after reading a command activity
	if no action is recognized, say "I beg your pardon"
	otherwise, carry out the action	

Requests such as "player consents" and "wait for any key" only invoke the AwaitInput function. They bypass ParserInput, and thus ignore the setting up input rules and the handling input rules.

The inner blank-line rejection is a bit of an anomaly. It happens before the handling input rules (and the after reading a command activity), which may cause problems; you cannot handle blank line input the same way you handle other line input.

UGI offers a use option to resolve this:

	Use pass blank input lines.

If you set this, the reject blank lines step is omitted. A blank line will pass through all the same rulebooks as other line input. It will be rejected at the *last* step -- no action is recognized, say "I beg your pardon". So the player will see the same response, really.

(One difference: we will have passed through the save-undo step. That is, when this option is set, blank lines count as undoable commands. That's not great, but it's not a big nuisance either. A future version of UGI may address this.)

Chapter: Low-level invocations

UGI offers phrases to stop and wait for a particular input (a keystroke, a yes-or-no question). It's quite easy to write your own such phrase.

Say we want to stop and wait for one hyperlink click. First we'll want to define a new input-context:

	Link-wait context is an input-context.

Then we need a rule to accept hyperlink input, storing the link value in a global:

	The found object is an object that varies.
	Rule for accepting input for link-wait context when handling hyperlink-event:
		now the found object is the current input event hyperlink object;
		accept the input event.

Now we can write a phrase:

	To decide what object is the hyperlink waited for:
		now the found object is nothing;
		clear all input requests;
		now the story-window is hyperlink-input-request;
		await input in link-wait context;
		decide on the found object.

The core phrase here is

	await input in (C - input-context)

Before calling this, we *must* set the desired request properties. (Remember, the setting up input rulebook will not be run) It is best to clear all requests and then set exactly the requests desired.

If we want line input, we must use one of the alternate forms:

	await input in (C - input-context) with primary buffer
	await input in (C - input-context) with secondary buffer

Generally you will want to use the secondary buffer. That will avoid stomping on the player's command (which is always stored in the primary buffer).

For another case, see example: "Secret Number Request"

Chapter: TEST ME

Inform's standard TEST ME facility has been upgraded to support more kinds of events. You can now say

	Test me with "$char x / $char 65 / $char escape / $char".
	Test me with "$link 123 / $link sword".
	Test me with "$timer".

Any test line beginning with a dollar sign defines a special event. You can escape dollar signs and slashes in line input by writing "[$]" or "[/]".

Character (keystroke) events are defined with "$char"; they can be single characters, ASCII codes, or special names such as "escape", "left", "right", "space", etc. "$char" by itself is taken as a space keystroke.

(Note that Inform automatically lower-cases test lines. So to define an upper-case keystroke, you must use a numeric ASCII code.)

Hyperlink events are defined with "$link"; they can be a numeric value or an object name. Note that the object name parsing is extremely simplistic. Only one word is recognized after "$link", and it must be unconditionally defined for the object (not a property adjective, e.g.). There is no disambiguation; if several objects match the word, the test just picks the first one.

Timer events are defined with "$timer". There is no other information to supply.	

If you generate a test event that the game isn't expecting, it will be ignored and the game will move on to the next test.

Chapter: Under the hood

This chapter describes what UGI has changed in the deep reaches of the Parser.i6t template. It is not very interesting.

The low-level functions VM_ReadKeyboard and VM_KeyDelay are gone. Instead, AwaitInput handles the bottom-level glk_select loop. Where VM_ReadKeyboard took two arguments (buffer and table), AwaitInput takes four (input-context, event, buffer, table).

Responsibility for redrawing the status line and printing the prompt has been moved into AwaitInput. (In the old model, these had to be done before calling an input function, meaning they were required in a lot of places. Bugs resulted.)

The old Keyboard routine has been renamed ParserInput. It too now takes input-context, event, buffer, and table arguments. ParserInput is a wrapper around AwaitInput which adds OOPS and UNDO support.

Blank line rejection is still handled in ParserInput (nee Keyboard), but only for the sake of backwards compatibility. By using the "pass blank input lines" option, the game can omit this check from ParserInput. Blank lines are then handled the same way as all other line input (and rejected by the parser at a later stage).

TestKeyboardPrimitive (in Tests.i6t) is now named CheckTestInput. It now takes event and buffer arguments. (Not table, as tokenization is now handled by the caller.) 

Responsibility for getting TEST ME input (the CheckTestInput call) has been moved into AwaitInput, right next to the code that gets REPLAY stream input. CheckTestInput returns a flag indicating whether it generated a test event. (This is different from TestKeyboardPrimitive, which was called from the KeyboardPrimitive wrapper, and called through to VM_ReadKeyboard when no test event was available. KeyboardPrimitive is not needed in the new model.)

The parser itself used to call Keyboard in three places (Parser Letter A and NounDomain). It now calls ParserInput, and understands that it could receive any kind of input event (not just line input). 

The parser invokes the handling input rulebook after each ParserInput call. If that rulebook generates an action, Parser__parse returns immediately (or NounDomain returns REPARSE_CODE, which leads to the same outcome.) Then the parser rejects blank lines and non-text inputs with an "I beg your pardon" error. After that, we know we have non-blank text input, so parsing proceeds in the original path.


Example: * Changing the Prompt - Changing the command prompt in various contexts.

The old "command prompt" global variable still works, but we'd like a more rule-based approach. Here we use "What now?" for the command prompt (both primary and disambiguation) and "Answer now!" for the final question.

We also use an extended form of the "player consents" phrase, in which we supply the prompt question to use.

	*: "Changing the Prompt"
	
	Include Unified Glulx Input by Andrew Plotkin.

	Prompt displaying rule for a command input-context:
		instead say "What now? ".

	Prompt displaying rule for the final question context:
		instead say "Answer now! ".

	The Kitchen is a room. "You are in a kitchen."
	The Outdoors is outside from the Kitchen.

	Check going outside:
		if the player consents asking "Outdoors is scary. Are you sure?" and "That was a yes/no question.":
			instead end the story finally;
		else:
			instead say "You fail to overcome your agoraphobia.";

	Test me with "out / maybe / no / out / yes".


Example: ** Tick Tick Tick Button - A timer in the status window.

This timer updates a clock in the status window. It never interrupts input or writes to the story window, so we only need an accepting input rule. The rule does its work and then rejects the event. (Timer events are rejected by default, so that last line isn't necessary, but it keeps the flow clear.)

The rule doesn't specify an input-context; timer input operates in all contexts. Thus, the clock keeps running during the yes-or-no question. It would keep running even during the game's final question if we didn't switch it off.

	*: "Tick Tick Tick Button"

	Include Unified Glulx Input by Andrew Plotkin.

	The Observation Lounge is a room. "This room overlooks the test chamber. A single button is ready to launch the experiment."

	A digital clock is fixed in place in the Lounge. "A digital clock blinks impassively overhead."
	The description is "The clock reads [readout]."

	A button is scenery in the Lounge.

	Check pushing the button:
		if the player consents asking "Are you very very sure?":
			say "[line break]It is now [readout]. The experiment [one of]succeeds[or]fails[purely at random].";
			set the timer off;
			instead end the story finally;
		else:
			instead say "You demur for now.";

	When play begins:
		now the right hand status line is "[readout]";
		set the timer to 1 second.

	Rule for accepting input when handling timer-event:
		increment the counter;
		redraw the status line;
		reject input event.

	The counter is initially 60.

	To say readout:
		let M be the remainder after dividing the counter by 60;
		let H be the counter divided by 60;
		if H < 10:
			say "0";
		say H;
		say ":";
		if M < 10:
			say "0";
		say M;


Example: *** Master Blaster - A timer that triggers a game action.

In this game, the BLAST command causes an explosion exactly two seconds later.

We want the timer to interrupt player input, so we accept the timer event. The interrupt text input line is not required; UGI always interrupts all input when an event is accepted. But by invoking it explicitly with the "preserving input" option, we ensure that the player's interrupted command will be preloaded into the next input line. It also allows us to print a quick "Interrupting..." message before the rule finishes.

Note that we only accept timer events when in a command input-context. In any other context (yes-or-no, etc) we would want to ignore the event -- it wouldn't make sense to trigger one game action in the middle of another. (In fact, the handling input rules don't even run in non-command contexts, so the event would be wasted anyhow.)

Once the timer event is accepted, it proceeds to the next rulebook, the handling input rules. The rule here generates an explosioning action. (This is a special action which has no understand lines. It cannot be invoked directly by the player; the handling input rule is the only way the explosioning can occur.)

	*: "The Master Blaster"

	Include Unified Glulx Input by Andrew Plotkin.

	The Repository is a room. "You are in an immense room, even larger than the giant room. A sign reads, 'Say BLAST to wrap it all up!'"

	The gap is a thing. "A ragged gap in the south wall shows the way to victory!" 

	Check entering the gap:
		say "You march through in triumph.";
		turn the timer off;
		instead end the story finally.

	Check going south in the Repository:
		if the gap is in the Repository:
			instead try entering the gap.

	Blasting is an action applying to nothing.

	Understand "blast" as blasting.

	Carry out blasting:
		if the timer is active:
			instead say "The explosion is already on its way.";
		set the timer to 2 seconds;
		say "You say the magic word. The air prickles. Wait for it..."

	Check answering someone that "blast":
		instead try blasting.

	Explosioning is an action applying to nothing.

	Carry out explosioning:
		if the gap is not in the Repository:
			now the gap is in the Repository;
			now the gap is fixed in place;
			instead say "A tremendous explosion rocks the Repository! When the dust clears, you see a gap to the south.";
		say "Additional fireworks go off! No new gaps though."	

	Rule for accepting input for a command input-context when handling timer-event:
		interrupt text input for the story-window, preserving input;
		say "(Interrupting...)";
		accept input event.

	Rule for handling input for a command input-context when handling timer-event:
		turn the timer off;
		handle the current input event as the action of explosioning.

	Test me with "blast / $timer / blast / blast / $timer / south".


Example: ** Maze of Keys - Controlling the game with single keystrokes.

In this example, the underworld uses a different input mechanism: single keystrokes. Character events are translated into line input for the parser. (This is a crude approach. See the "Maze of Keys 2" example for a tidier model.)

	*: "Maze of Keys"

	Include Unified Glulx Input by Andrew Plotkin.
	Include Unicode Character Names by Graham Nelson.

	The Kitchen is a room. "You are in a kitchen. An open trap door beckons you downward."

	Aboveground is a region. The Kitchen is in Aboveground.

	Maze10 is a room. "You are in a maze of twisty passages, basically all alike."
	Maze20 is a room. "You are in a maze of twisty passages, all pretty much alike."
	Maze01 is a room. "You are in a maze of twisty passages, all basically alike."
	Maze11 is a room. "You are in a maze of twisty passages, all kind of alike."
	Maze21 is a room. "You are in a maze of twisty passages, more or less all alike."
	Maze02 is a room. "You are in a maze of twisty passages, pretty much all alike."
	Maze12 is a room. "You are in a maze of twisty passages, all alike."
	Maze22 is a room. "You are in a maze of twisty passages, all more or less alike."
	Maze32 is a room. "You are in a maze of twisty passages, all sort of alike."
	Maze03 is a room. "You are in a maze of twisty passages, kind of all alike."
	Maze13 is a room. "You are in a maze of twisty passages, all quite alike."
	Maze23 is a room. "You are in a maze of twisty passages, quite all alike."
	Maze33 is a room. "You are in a maze of twisty passages, sort of all alike."

	Maze12 is below the Kitchen.
	Maze10 is west of Maze20. 
	Maze10 is north of Maze11. Maze20 is north of Maze21.
	Maze01 is west of Maze11. Maze11 is west of Maze21.
	Maze01 is north of Maze02. Maze11 is north of Maze12.
	Maze02 is west of Maze12. Maze12 is west of Maze22. Maze22 is west of Maze32.
	Maze12 is north of Maze13. Maze22 is north of Maze23. Maze32 is north of Maze33.
	Maze03 is west of Maze13. Maze23 is west of Maze33.

	Rule for printing the name of a room (called R) when R is not in Aboveground:
		say "Maze".

	Check going down from the Kitchen:
		say "(Down here, single-keystroke commands rule. Use the arrow keys or NSEW to move around; Z to undo; U or escape to return upstairs.)";
		continue the action.

	Check going up when the location is not in Aboveground:
		say "You fumble your way back to the light.";
		now the player is in the Kitchen;
		stop the action.

	Prompt displaying rule when the location is not in Aboveground:
		instead say "==>".

	Setting up input rule when the location is not in Aboveground:
		now the input-request of the story-window is char-input;
		set input undoable;
		rule succeeds.

	Accepting input rule when the location is not in Aboveground and handling char-event:
		let C be the current input event character;
		if C is special keycode left or C is Unicode Latin small letter w or C is Unicode Latin capital letter W:
			say "GO WEST[line break]";
			replace the current input event with the line "go west";
			rule succeeds;
		if C is special keycode right or C is Unicode Latin small letter e or C is Unicode Latin capital letter E:
			say "GO EAST[line break]";
			replace the current input event with the line "go east";
			rule succeeds;
		if C is special keycode up or C is Unicode Latin small letter n or C is Unicode Latin capital letter N:
			say "GO NORTH[line break]";
			replace the current input event with the line "go north";
			rule succeeds;
		if C is special keycode down or C is Unicode Latin small letter s or C is Unicode Latin capital letter S:
			say "GO SOUTH[line break]";
			replace the current input event with the line "go south";
			rule succeeds;
		if C is special keycode escape or C is Unicode Latin small letter u or C is Unicode Latin capital letter U:
			say "GO UP[line break]";
			replace the current input event with the line "go up";
			rule succeeds;
		if C is Unicode Latin small letter l or C is Unicode Latin capital letter L:
			say "LOOK[line break]";
			replace the current input event with the line "look";
			rule succeeds;
		if C is Unicode Latin small letter z or C is Unicode Latin capital letter Z:
			say "UNDO[line break]";
			replace the current input event with the line "undo";
			rule succeeds;
		interrupt text input for the story-window;
		say "('[extended C]' is not a valid key.)";
		reject the input event.

	Test me with "down / $char s / $char w / $char right / $char up / $char escape / look".


Example: *** Maze of Keys 2 - Controlling the game with single keystrokes.

This is nearly the same as the previous example. But now, instead of changing char input events to line input events, we handle char events directly as going actions.

The work is now done in the accepting input rulebook. We no longer pretend that we're entering line input, and the parser is entirely bypassed.

	*: "Maze of Keys 2"

	Include Unified Glulx Input by Andrew Plotkin.
	Include Unicode Character Names by Graham Nelson.

	The Kitchen is a room. "You are in a kitchen. An open trap door beckons you downward."

	Aboveground is a region. The Kitchen is in Aboveground.

	Maze10 is a room. "You are in a maze of twisty passages, basically all alike."
	Maze20 is a room. "You are in a maze of twisty passages, all pretty much alike."
	Maze01 is a room. "You are in a maze of twisty passages, all basically alike."
	Maze11 is a room. "You are in a maze of twisty passages, all kind of alike."
	Maze21 is a room. "You are in a maze of twisty passages, more or less all alike."
	Maze02 is a room. "You are in a maze of twisty passages, pretty much all alike."
	Maze12 is a room. "You are in a maze of twisty passages, all alike."
	Maze22 is a room. "You are in a maze of twisty passages, all more or less alike."
	Maze32 is a room. "You are in a maze of twisty passages, all sort of alike."
	Maze03 is a room. "You are in a maze of twisty passages, kind of all alike."
	Maze13 is a room. "You are in a maze of twisty passages, all quite alike."
	Maze23 is a room. "You are in a maze of twisty passages, quite all alike."
	Maze33 is a room. "You are in a maze of twisty passages, sort of all alike."

	Maze12 is below the Kitchen.
	Maze10 is west of Maze20.
	Maze10 is north of Maze11. Maze20 is north of Maze21.
	Maze01 is west of Maze11. Maze11 is west of Maze21.
	Maze01 is north of Maze02. Maze11 is north of Maze12.
	Maze02 is west of Maze12. Maze12 is west of Maze22. Maze22 is west of Maze32.
	Maze12 is north of Maze13. Maze22 is north of Maze23. Maze32 is north of Maze33.
	Maze03 is west of Maze13. Maze23 is west of Maze33.

	Rule for printing the name of a room (called R) when R is not in Aboveground:
		say "Maze".

	Check going down from the Kitchen:
		say "(Down here, single-keystroke commands rule. Use the arrow keys or NSEW to move around; Z to undo; U or escape to return upstairs.)";
		continue the action.

	Check going up when the location is not in Aboveground:
		say "You fumble your way back to the light.";
		now the player is in the Kitchen;
		stop the action.

	Prompt displaying rule when the location is not in Aboveground:
		instead say "==>".

	Setting up input rule when the location is not in Aboveground:
		now the input-request of the story-window is char-input;
		set input undoable;
		rule succeeds.

	Checking undo input rule when the location is not in Aboveground:
		let C be the current input event character;
		if C is Unicode Latin small letter z or C is Unicode Latin capital letter Z:
			say "(Undoing one turn...)";
			rule succeeds.

	Handling input rule when the location is not in Aboveground and handling char-event:
		let C be the current input event character;
		if C is special keycode left or C is Unicode Latin small letter w or C is Unicode Latin capital letter W:
			say "(You try going west...)";
			handle the current input event as the action of going west;
			rule succeeds;
		if C is special keycode right or C is Unicode Latin small letter e or C is Unicode Latin capital letter E:
			say "(You try going east...)";
			handle the current input event as the action of going east;
			rule succeeds;
		if C is special keycode up or C is Unicode Latin small letter n or C is Unicode Latin capital letter N:
			say "(You try going north...)";
			handle the current input event as the action of going north;
			rule succeeds;
		if C is special keycode down or C is Unicode Latin small letter s or C is Unicode Latin capital letter S:
			say "(You try going south...)";
			handle the current input event as the action of going south;
			rule succeeds;
		if C is special keycode escape or C is Unicode Latin small letter u or C is Unicode Latin capital letter U:
			say "(You try going up...)";
			handle the current input event as the action of going up;
			rule succeeds;
		if C is Unicode Latin small letter l or C is Unicode Latin capital letter L:
			say "(You look around...)";
			handle the current input event as the action of looking;
			rule succeeds;
		say "('[extended C]' is not a valid key.)";
		reject the input event.

	Test me with "down / $char s / $char w / $char right / $char up / $char escape / look".


Example: ** A Study In Memoriam - A pure-hyperlink game.

Here we drop text input entirely. (Dropping the standard parser input line request rule accomplishes this.) Instead we set up input to be hyperlink-based. Hyperlink events are translated into the examining action, which happily works for both on-stage objects and off-stage memories.

	*: "A Study In Memoriam"

	Include Unified Glulx Input by Andrew Plotkin.

	The Study is a room. "You are in your cluttered study."

	The messy desk is a supporter in the Study. The description is "You found this battered antique in a battered [antique shop] in Chapel Hill. As you recall, it was sitting behind [a microscope]."

	A fossil is on the desk. The description is "Some species of [ammonite]."

	A copper fulgurite is on the desk. The description is "It's a chunk of melted copper that you picked up from the base of a telephone pole. It's not really fulgurite, minerallogically speaking. But it [italic type]was[roman type] formed by [lightning]!"

	A memory is a kind of thing.

	The ammonite is a memory. The description is "You've dreamed of drifting through antediluvian seas, the master of all you survey... Then the bony fishes come. The damned bony fishes."

	The microscope is a memory. The printed name is "defunct electron microscope". The description is "Yes, you once discovered an electron microsope in [an antique shop]. It was a console device, like a kitchen counter with switches all over the top and vacuum pumps hanging out underneath. You wonder if anyone ever purchased it."

	The antique shop is a memory. The description is "You discovered a mad antique shop on a years-ago trip to North Carolina. The prize of its collection was [a microscope], though you doubt anyone else would think of it that way. You bought [hyperlink desk]an old desk[/hyperlink] instead; the very one in this room."

	The lightning is a memory. The description is "One can never remember lightning properly."

	Rule for printing the name of an object (called O):
		say "[hyperlink O][printed name of O][/hyperlink]";

	The standard parser input line request rule does nothing.

	Prompt displaying rule for a command input-context:
		say "[first time](Touch a link.)[only]";
		rule succeeds.

	Setting up input rule:
		now the story-window is hyperlink-input-request.

	Handling input rule for a command input-context when handling hyperlink-event:
		let O be current input event hyperlink object;
		if O is nothing:
			reject the input event;
		if O is a room:
			handle the current input event as the action of looking;
		else:
			handle the current input event as the action of examining O;
		rule succeeds.

	Before examining something:
		say "--- [The noun] ---[paragraph break]";

	Section - not for release

	The test-me is a memory.

	When play begins:
		say "(Hit [test-me] to run the tests.)";

	Instead of examining test-me:
		run test-me.

	To run test-me: (- special_word = 'me//'; TestScriptSub(); -).

	Test me with "$link fossil / $link ammonite / $link study".


Example: **** Secret Number Request - A phrase to query the player for a number.

In this example we ask the player for a number. It's very much like "if the player consents..." except that we get back a number rather than a yes-or-no decision.

We'll want a new input-context for this operation, so we invent one: numeric context. Our prompt displaying rule relies on this to give the player a special prompt for the number-typing operation.

The "number waited for" phrase demonstrates doing a low-level input operation. First we must clear all input requests for the story window. (We don't want a request left over from regular command input.) Then we set the input request we want -- line input only. Then we "await input", using our special numeric context.

Then it gets a little bit messy. There's no easy I7 access to the input buffer. We can't use "the player's command" because that's a parser variable. We're doing this behind the parser's back, so no player's command is ever set. Nor can we match against an I7 token like "[number]".

Instead, we rely on an existing I6 function called TryNumber. This returns the parsed number, or -1000 if no number was typed. Loop until we get something valid.

Unfortunately, TryNumber is set up to use the parser's input buffer. That's why the input phrase is

	await input in numeric context with primary buffer;

This winds up stomping on "the player's command"; that snippet will be invalid for the rest of the turn. Too bad!

A better implementation would rely on the secondary buffer. We couldn't use TryNumber, though, so it would be a longer and messier example.

	*: "Secret Number Request"

	Include Unified Glulx Input by Andrew Plotkin.

	The Alley is a room. "You are in that alley from that spy game. A steel door is to the east; next to it is a button and a speaker grille."

	The steel door is scenery in the Alley. The description is "The door is closed and locked."

	Check entering the steel door:
		instead say "The door isn't open."
	Check going east in the Alley:
		instead try entering the steel door.
	Check going south in the Alley:
		instead say "You can't quit now."

	The secret number is initially 0.

	The button is scenery in the Alley.

	Check pushing the button:
		if the secret number is 0:
			now the secret number is a random number between 100 and 500;
		say "A crackly voice asks, 'What's the secret number?'";
		let N be the number waited for;
		if N is the secret number:
			say "'Did you say [N]? You're right!' The door pops open and someone on the other side tasers you.";
			end the story finally;
		else:
			say "'Did you say [N]? That's not right. The secret number today is [secret number].'[paragraph break]The door does not open.";
		stop the action.

	Numeric context is an input-context.

	Prompt displaying rule for numeric context:
		instead say "==>".

	To decide what number is the number waited for:
		while 1 is 1:
			clear all input requests;
			now the input-request of the story-window is line-input;
			await input in numeric context with primary buffer;
			let N be the hacky low-level number check;
			if N is not -1000:
				decide on N;
			say "Please enter a number.";

	To decide what number is the hacky low-level number check: (- TryNumber(1) -).

