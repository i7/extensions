Version 2/111114 of Text Window Input-Output Control (for Glulx only) by Erik Temple begins here.

[Fixed variable declarations so that current text i/o windows are "usually" assigned to the main-window. 10/14/2011]
[Minor typos in docs fixed. 1/22/2011]
"Allows authors to accept input in a separate window from output, or to redirect output to windows other the main window. Input and output windows can be changed during play. Also provides more control over transcript output. Requires Flexible Windows."Chapter 0 - InclusionsInclude version 9 of Flexible Windows by Jon Ingold.Chapter - Global window variables	The current text input window is a g-window that varies. The current text input window is usually the main-window.The current text output window is a g-window that varies. The current text output window is usually the main-window.Chapter - Managing windowsSection - New phrases for opening a windowTo open up (win - a g-window) as the/-- main/current/-- text/-- output window:	if win is g-unpresent and the main-window is ancestral to win:		now every g-window ancestral to win is g-required;		calibrate windows;	now the current text output window is win;	echo the stream of win to the transcript;	set focus to win.	To open up (win - a g-window) as the/-- main/current/-- text/-- input window:	if win is g-unpresent and the main-window is ancestral to win:		now every g-window ancestral to win is g-required;		calibrate windows;	now the current text input window is win;	echo the stream of win to the transcript.Section - Addition to the window-shutting activityBefore window-shutting a g-window (called the window):	if the window is the current text output window:		now the current text output window is the main-window;		set focus to the main-window;	if the window is the current text input window:		now the current text input window is the main-window.Section - Hacked returning to the main screen (in place of Section - Returning to the main screen in Flexible Windows by Jon Ingold)To return to main screen/window: set focus to the current text output window.	Chapter - Printing the command prompt[Here we rewrite the basic command prompt routine as an I7 activity. We can customize this as we see fit, or we can use it as a hook for other behavior.]Printing the command prompt is an activity.Rule for printing the command prompt (this is the standard prompt printing rule):	set focus to the current text input window;	ensure break before prompt;	say "[roman type][command prompt][run paragraph on]";	set focus to current text output window;	clear boxed quotation;	clear paragraphing.	To ensure break before prompt:	(- EnsureBreakBeforePrompt(); -)	To clear boxed quotation:	(- ClearBoxedText(); -)	To clear paragraphing:	(- ClearParagraphing(); -)		Section - Printing the final prompt[The final prompt (i.e., the prompt for the final question, after play has ended) is printed independently of the in-game command prompt. Here we substitute a new rule for the Standard Rules' "print the final prompt rule" to handle this correctly.]The print the final prompt rule is not listed in any rulebook.The flexible print the final prompt rule is listed before the read the final answer rule in before handling the final question. This is the flexible print the final prompt rule:	carry out the printing the command prompt activity.Section - Yes-No question prompting[There is one other situation in which the prompt is not controlled by the standard prompt printing activity. This is when the player answers a yes-no question, such as in response to whether she wishes to quit or restart the game, or to the "if the player consents" phrase. To handle these cases, we provide a rulebook and a global variable for holding an alternate prompt that can be used in the input window for yes/no questions only.]The yes-no prompting rules are a rulebook.The yes-no prompt is a text variable. The yes-no prompt is ">>"[Ths saving, switching, and restoring of the prompt text is a bit awkward, but it allows for a different prompt to be used w/o requiring the surrounding behavior--i.e., the before and after rules for the command prompt activity to be specified twice--i.e., with one activity for the standard prompt, and one for the yes-no prompt.]Last yes-no prompting rule (this is the default yes-no prompting rule):	say line break;	let saved-prompt be the command prompt;	now the command prompt is the yes-no prompt;	carry out the printing the command prompt activity;	now the command prompt is the saved-prompt.	Chapter - Transcript control[The Inform library directs only input from the main window to the transcript by default. This rule sends output from both of our windows to the transcript. It also recreates the library output. To change the standard library output, you can replace this rule with one of your own.]Activating the transcript is an activity.For activating the transcript (this is the transcript activation rule):	echo the stream of the current text output window to the transcript;	echo the stream of the current text input window to the transcript;	say "Start of a transcript of[line break]";	consider the announce the story file version rule.	Chapter - Mouse input[Glulx Entry Points' routines for pasting commands need to be modified for our purposes.]Section - Cancelling input before printing to the input line[First, we eliminate the standard rule that cancels input in the main window when a mouse click generates a command. We need to make this happen in the current text input window, so we provide the flexible cancelling input rule.]The cancelling input in the main window rule is not listed in any rulebook.An input-cancelling rule (this is the flexible calling input rule):	cancel line input in the current text input window;	cancel character input in the current text input window.		To cancel line input in (win - a g-window):	(- glk_cancel_line_event({win}.ref_number, GLK_NULL); -)	To cancel character input in (win - a g-window):	(- glk_cancel_char_event({win}.ref_number); -)	Section - Pasting commands to the input window[Here we provide a new command-pasting rule that targets our current text input window. We also provide some control over the state of paragraphing across the sometimes troublesome switch between windows. This control comes via the "command-pasting terminator" a global text variable that we can set to whatever we need to make things look good. By default, there is no terminator (the value is ""). If we are clearing the input window after each input, however, we will want to set the command-pasting terminator equal to "[run paragraph on]", or we will get an extra line break in the output window after each pasted command.]The print text to the input prompt rule is not listed in any rulebook.The command-pasting terminator is a text variable.A command-showing rule (this is the print text to the input window rule):	set focus to the current text input window;	[say input-style-for-glulx;	say Glulx replacement command;	say roman type;]	say "[input-style-for-glulx][Glulx replacement command][roman type][command-pasting terminator]";	set focus to current text output window.	Chapter - Hacked VM routinesInclude (-[ VM_KeyChar win nostat done res ix jx ch;    jx = ch; ! squash compiler warnings    if (win == 0) win = (+ current text input window +).ref_number;    if (gg_commandstr ~= 0 && gg_command_reading ~= false) {        done = glk_get_line_stream(gg_commandstr, gg_arguments, 31);        if (done == 0) {            glk_stream_close(gg_commandstr, 0);            gg_commandstr = 0;            gg_command_reading = false;            ! fall through to normal user input.        } else {            ! Trim the trailing newline            if (gg_arguments->(done-1) == 10) done = done-1;            res = gg_arguments->0;            if (res == '\') {                res = 0;                for (ix=1 : ix<done : ix++) {                    ch = gg_arguments->ix;                    if (ch >= '0' && ch <= '9') {                        @shiftl res 4 res;                        res = res + (ch-'0');                    } else if (ch >= 'a' && ch <= 'f') {                        @shiftl res 4 res;                        res = res + (ch+10-'a');                    } else if (ch >= 'A' && ch <= 'F') {                        @shiftl res 4 res;                        res = res + (ch+10-'A');                    }                }            }       		jump KCPContinue;        }    }    done = false;    glk_request_char_event(win);    while (~~done) {        glk_select(gg_event);        switch (gg_event-->0) {          5: ! evtype_Arrange            if (nostat) {                glk_cancel_char_event(win);                res = $80000000;                done = true;                break;            }            DrawStatusLine();          2: ! evtype_CharInput            if (gg_event-->1 == win) {                res = gg_event-->2;                done = true;                }        }        ix = HandleGlkEvent(gg_event, 1, gg_arguments);        if (ix == 2) {            res = gg_arguments-->0;            done = true;        } else if (ix == -1)  done = false;    }    if (gg_commandstr ~= 0 && gg_command_reading == false) {        if (res < 32 || res >= 256 || (res == '\' or ' ')) {            glk_put_char_stream(gg_commandstr, '\');            done = 0;            jx = res;            for (ix=0 : ix<8 : ix++) {                @ushiftr jx 28 ch;                @shiftl jx 4 jx;                ch = ch & $0F;                if (ch ~= 0 || ix == 7) done = 1;                if (done) {                    if (ch >= 0 && ch <= 9) ch = ch + '0';                    else                    ch = (ch - 10) + 'A';                    glk_put_char_stream(gg_commandstr, ch);                }            }        } else {            glk_put_char_stream(gg_commandstr, res);        }        glk_put_char_stream(gg_commandstr, 10); ! newline    }  .KCPContinue;    return res;];[ VM_KeyDelay tenths  key done ix;    glk_request_char_event( (+ current text input window +).ref_number );    glk_request_timer_events(tenths*100);    while (~~done) {        glk_select(gg_event);        ix = HandleGlkEvent(gg_event, 1, gg_arguments);        if (ix == 2) {            key = gg_arguments-->0;            done = true;        }        else if (ix >= 0 && gg_event-->0 == 1 or 2) {            key = gg_event-->2;            done = true;        }    }    glk_cancel_char_event( (+ current text input window +).ref_number );    glk_request_timer_events(0);    return key;];[ VM_ReadKeyboard  a_buffer a_table done ix;    if (gg_commandstr ~= 0 && gg_command_reading ~= false) {        done = glk_get_line_stream(gg_commandstr, a_buffer+WORDSIZE,        	(INPUT_BUFFER_LEN-WORDSIZE)-1);        if (done == 0) {            glk_stream_close(gg_commandstr, 0);            gg_commandstr = 0;            gg_command_reading = false;            ! L__M(##CommandsRead, 5); would come after prompt            ! fall through to normal user input.        }        else {            ! Trim the trailing newline            if ((a_buffer+WORDSIZE)->(done-1) == 10) done = done-1;            a_buffer-->0 = done;            VM_Style(INPUT_VMSTY);            glk_put_buffer(a_buffer+WORDSIZE, done);            VM_Style(NORMAL_VMSTY);            print "^";            jump KPContinue;        }    }    done = false;    glk_request_line_event( (+ current text input window +).ref_number, a_buffer+WORDSIZE, INPUT_BUFFER_LEN-WORDSIZE, 0);    while (~~done) {        glk_select(gg_event);        switch (gg_event-->0) {          5: ! evtype_Arrange            DrawStatusLine();          3: ! evtype_LineInput            if (gg_event-->1 == (+ current text input window +).ref_number) {                a_buffer-->0 = gg_event-->2;                done = true;            }        }        ix = HandleGlkEvent(gg_event, 0, a_buffer);        if (ix == 2) done = true;        else if (ix == -1) done = false;    }    if (gg_commandstr ~= 0 && gg_command_reading == false) {        glk_put_buffer_stream(gg_commandstr, a_buffer+WORDSIZE, a_buffer-->0);        glk_put_char_stream(gg_commandstr, 10); ! newline    }  .KPContinue;    VM_Tokenise(a_buffer,a_table);    ! It's time to close any quote window we've got going.    if (gg_quotewin) {        glk_window_close(gg_quotewin, 0);        gg_quotewin = 0;    }   #ifdef ECHO_COMMANDS;    print "** ";    for (ix=WORDSIZE: ix<(a_buffer-->0)+WORDSIZE: ix++) print (char) a_buffer->ix;    print "^";    #endif; ! ECHO_COMMANDS];-) instead of "Keyboard Input" in "Glulx.i6t"Chapter - Hacked printing the command prompt routineInclude (-[ PrintPrompt i;	!style roman;	!EnsureBreakBeforePrompt();	!glk_set_window( (+ current text input window +).ref_number );	!PrintText( (+ command prompt +) );	!glk_set_window( (+ current text output window +).ref_number );	!ClearBoxedText();	!ClearParagraphing();	CarryOutActivity( (+ printing the command prompt +) );	enable_rte = true;];-) instead of "Prompt" in "Printing.i6t"Chapter - Hacked code for including inline graphicsInclude (-[ VM_Picture resource_ID;	if (glk_gestalt(gestalt_Graphics, 0)) {		glk_image_draw( (+ current text output window +).ref_number, resource_ID, imagealign_InlineCenter, 0);	} else {		print "[Picture number ", resource_ID, " here.]^";	}];!No change made to sound effect code by Text Window I-O Control; included only as part of the same source code section as the figure display code.[ VM_SoundEffect resource_ID;	if (glk_gestalt(gestalt_Sound, 0)) {		glk_schannel_play(gg_foregroundchan, resource_ID);	} else {		print "[Sound effect number ", resource_ID, " here.]^";	}];-) instead of "Audiovisual Resources" in "Glulx.i6t"Chapter - Hacked screen routinesInclude (-[ VM_ClearScreen window;    if (window == WIN_ALL or WIN_MAIN) {        glk_window_clear( (+ current text output window +).ref_number );        if (gg_quotewin) {            glk_window_close(gg_quotewin, 0);            gg_quotewin = 0;        }    }    if (gg_statuswin && window == WIN_ALL or WIN_STATUS) glk_window_clear(gg_statuswin);];[ VM_ScreenWidth  id;    id= (+ current text output window +).ref_number;    if (gg_statuswin && statuswin_current) id = gg_statuswin;    glk_window_get_size(id, gg_arguments, 0);    return gg_arguments-->0;];[ VM_ScreenHeight;    glk_window_get_size( (+ current text output window +).ref_number, 0, gg_arguments);    return gg_arguments-->0;];-) instead of "The Screen" in "Glulx.i6t"[Chapter - Hacked window color routinesInclude (-[ VM_SetWindowColours f b window doclear  i fwd bwd swin;    if (clr_on && f && b) {        if (window) swin = 5-window; ! 4 for TextGrid, 3 for TextBuffer        fwd = MakeColourWord(f);        bwd = MakeColourWord(b);        for (i=0 : i<style_NUMSTYLES: i++) {            if (f == CLR_DEFAULT || b == CLR_DEFAULT) {  ! remove style hints                glk_stylehint_clear(swin, i, stylehint_TextColor);                glk_stylehint_clear(swin, i, stylehint_BackColor);            } else {                glk_stylehint_set(swin, i, stylehint_TextColor, fwd);                glk_stylehint_set(swin, i, stylehint_BackColor, bwd);            }        }        ! Now re-open the windows to apply the hints        if (gg_statuswin) glk_window_close(gg_statuswin, 0);        gg_statuswin = 0;        if (doclear || ( window ~= 1 && (clr_fg ~= f || clr_bg ~= b) ) ) {            glk_window_close( (+ current text output window +).ref_number, 0);            gg_mainwin = glk_window_open(0, 0, 0, wintype_TextBuffer, (+ current text output window +).rock_value);            if (gg_scriptstr ~= 0)                glk_window_set_echo_stream((+ current text output window +).ref_number, gg_scriptstr);        }        gg_statuswin =        	glk_window_open(gg_mainwin, winmethod_Fixed + winmethod_Above,        		statuswin_cursize, wintype_TextGrid, GG_STATUSWIN_ROCK);        if (statuswin_current && gg_statuswin) VM_MoveCursorInStatusLine(); else VM_MainWindow();        if (window ~= 2) {            clr_fgstatus = f;            clr_bgstatus = b;        }        if (window ~= 1) {            clr_fg = f;            clr_bg = b;        }    }];[ VM_RestoreWindowColours; ! used after UNDO: compare I6 patch L61007    if (clr_on) { ! check colour has been used        VM_SetWindowColours(clr_fg, clr_bg, 2); ! make sure both sets of variables are restored        VM_SetWindowColours(clr_fgstatus, clr_bgstatus, 1, true);        VM_ClearScreen();    }];[ MakeColourWord c;    if (c > 9) return c;    c = c-2;    return $ff0000*(c&1) + $ff00*(c&2 ~= 0) + $ff*(c&4 ~= 0);];-) instead of "Window Colours" in "Glulx.i6t"]Chapter - Hacked main window routineInclude (-[ VM_MainWindow;    glk_set_window( (+ current text output window +).ref_number ); ! set_window    statuswin_current=0;];-) instead of "Main Window" in "Glulx.i6t"Chapter - Hacked box quote window routineInclude (-[ Box__Routine maxwid arr ix lines lastnl parwin;    maxwid = 0; ! squash compiler warning    lines = arr-->0;    if (gg_quotewin == 0) {        gg_arguments-->0 = lines;        ix = InitGlkWindow(GG_QUOTEWIN_ROCK);        if (ix == 0)            gg_quotewin =            	glk_window_open(gg_mainwin, winmethod_Fixed + winmethod_Above,            		lines, wintype_TextBuffer, GG_QUOTEWIN_ROCK);    } else {        parwin = glk_window_get_parent(gg_quotewin);        glk_window_set_arrangement(parwin, $12, lines, 0);    }    lastnl = true;    if (gg_quotewin) {        glk_window_clear(gg_quotewin);        glk_set_window(gg_quotewin);        lastnl = false;    }	VM_Style(BLOCKQUOTE_VMSTY);    for (ix=0 : ix<lines : ix++) {        print (string) arr-->(ix+1);        if (ix < lines-1 || lastnl) new_line;    }	VM_Style(NORMAL_VMSTY);    if (gg_quotewin) glk_set_window( (+ current text output window +).ref_number );];-) instead of "Quotation Boxes" in "Glulx.i6t"Chapter - Hacked transcript routineInclude (-[ SWITCH_TRANSCRIPT_ON_R;	if (actor ~= player) rfalse;	if (gg_scriptstr ~= 0) return GL__M(##ScriptOn, 1);	if (gg_scriptfref == 0) {		gg_scriptfref = glk_fileref_create_by_prompt($102, $05, GG_SCRIPTFREF_ROCK);		if (gg_scriptfref == 0) jump S1Failed;	}	! stream_open_file	gg_scriptstr = glk_stream_open_file(gg_scriptfref, $05, GG_SCRIPTSTR_ROCK);	if (gg_scriptstr == 0) jump S1Failed;	BeginActivity( (+activating the transcript+) );	ForActivity( (+activating the transcript+) );	!	glk_window_set_echo_stream(gg_mainwin, gg_scriptstr);	!	GL__M(##ScriptOn, 2);	!	VersionSub();	EndActivity( (+activating the transcript+) );	return;	.S1Failed;	GL__M(##ScriptOn, 3);];-) instead of "Switch Transcript On Rule" in "Glulx.i6t"Chapter - Hacked yes-no question routineInclude (-[ YesOrNo i j;    for (::) {	RunParagraphOn();        ProcessRulebook( (+ yes-no prompting rules +) );	KeyboardPrimitive(buffer, parse);        j = parse-->0;                if (j) { ! at least one word entered            i = parse-->1;            if (i == YES1__WD or YES2__WD or YES3__WD) rtrue;            if (i == NO1__WD or NO2__WD or NO3__WD) rfalse;        }        L__M(##Quit, 1);     }];-) instead of "Yes/No Questions" in "Parser.i6t"Text Window Input-Output Control ends here.
---- Documentation ----

Text Window Input-Output Control allows an author to direct the game's main input and output--both of which would normally be directed to a game's "main window"--to any text window she chooses. We can, for example, split input and output, so that the player's input is entered into one window, while the game responds in another. Window input-output (I/O) can be changed at any time during the game. The extension also provides more control over transcript output.

Text Window Input-Output Control is built on, and requires, Jon Ingold's Flexible Windows extension.


Section: Basic Usage

Text Window Input-Output Control provides two new global g-window variables:

	current text input window
	current text output window

These variables define the windows into which the game's main output and input will be directed. Both are initially set to the main window (Flexible Windows's "main-window" object), so that if neither of the variables are changed during play, all I/O will occur in the main window (the standard behavior).

The major use of this extension is expected to be for splitting input and output across two windows; that is, for creating a separate window for input. To do this, we can merely set the "current text input window" to window we wish to use for the command prompt. This can be either a text-buffer window or a text-grid window.

It is important to note that the "current text output window" is distinct from the "current g-window" defined by Flexible Windows, and changing it will probably only rarely be necessary. Unlike the current g-window variable, the current text output window is intended to be used when the main output--that is, the game's main stream of output, occurring over multiple turns--needs to be redirected away from the (always open) main window to some other window. That window will then become, for nearly all intents and purposes, the "main window" (indeed, the Flexible Windows phrase "return to main screen" will direct output to the window that is defined as the current text output window). This is most likely to be useful when we want to use multiple "main windows" within a game, alternating a text-grid window, say, or a window with a different background color. See the "Terminal" example below for an example.

There is thus no need to provide a Flexible Windows window-drawing rule for windows assigned as the current text output window or the current text input window; Inform's library takes care of requesting input and printing output. Note that when the current text input window or current text output window is closed, the main window will automatically take over. 

NOTE: The Inform library will not redirect input/output until the beginning of the next turn. If you want to begin printing to a new "current" window immediately, use the "set focus to <a text g-window>" phrase:

	Instead of turning on the computer:
		change the current text output window to the terminal-window;
		set focus to the current text output window;
		say "..."

Most often, we will want to set a window to be the new current text output/input window at the time we open it. Two phrases are provided that take care of all of the bookkeeping for us:

	open up <a text g-window> as the main text output window
	open up <a text g-window> as the main text input window

If, for example we want to use the main window for output, but provide input in a separate window, we define the input window as usual (see the Flexible Windows documentation), and then we open it like so:

	When play begins:
		open up the input window as the main text input window.

These phrases will immediately shift I/O to the designated window(s), and they also ensure that the text that is printed to the window is also printed to the transcript.


Section: A caveat

Inform's complex paragraph printing and line breaking algorithms (see http://inform7.com/sources/src/i6template/Woven/B-print.pdf ) were not designed with multiple windows in mind, and not everything works perfectly when we use them. Most notably, switching output streams can cause line break issues, as Inform's paragraphing functions are not aware of the change in window streams. In writing this extension, I have tried to provide as little as possible in the way of customized spacing behavior, since I expect the extension will have many potential uses. In most cases customizing display issues won't be too onerous a task (not any more onerous than dealing with line-spacing in general, anyway), but be prepared to need to customize a few things. The examples, particularly "On the Edge", give some idea of the kinds of tweaks that may be necessary.


Section: Command prompts

The extension provides added control over the three different command prompts provided by the Inform library. Here are the three rules and activities provided for controlling the prompts:

	The "printing the command prompt" activity now controls the printing of the standard prompt seen for most commands. The character used for the prompt itself is defined, as in the standard Inform library, by the "command prompt" global variable.

	The final prompt, which is printed after the game ends, is controlled by the "flexible print the final prompt rule".

	The yes-no prompt, which is printed in response to yes-no questions, is controlled by the "yes-no prompting" rulebook. The prompt for yes-no questions can be set using the "yes-no prompt" global variable, which is initially defined as ">>". (Inform's standard library has no yes-no prompt; instead, the input directly follows the question, on the same line.)

Both the flexible print the final prompt rule and the default yes-no prompting rule call the printing the command prompt activity. If we want to customize all of the prompts in the game in the same way, that activity is the most natural place to start. For example, to clear the current input window after each command, we might write:

	Before printing the command prompt:
		clear the current text input window.

A note on yes-no prompting: If we are not accepting input in a separate window and want to maintain Inform's standard yes-no behavior, we can restore that behavior by setting the yes-no prompt to "" when play begins and adding the following rule to our story text:

	*: Yes-no prompting:
		say " [run paragraph on]";
		rule succeeds.


Section: Transcripts

With multiple windows, we need a bit more control over what is written to the transcript than the Inform library provides. Text Window Input-Output Control should automatically handle directing the streams of the current text output and current text input windows to the transcript. This is handled internally by the extension in two ways: (1) Through the "activating the transcript" activity, which allows us to dictate which windows send output to the transcript, as well as what is output in response to the SCRIPT ON command. The default is set by the "transcript activation rule," which attempts to echo both the current text output window and the current text input window to the transcript. (2) Additionally, any window opened as the current text input/output window (using the "open ... as" phrases described in the Basic Usage section) after a transcript is already in progress will be added to the transcript.

If we have a more dynamic window layout, we can add window streams to the transcript manually by using the "echo the stream of <a text g-window> to the transcript" phrase. This can be done both by extending the activating the transcript activity:

	For activating the transcript:
		echo the stream of the optional-window to the transcript.

...and by adding rules to Flexible Windows's "constructing a g-window" activity:

	After constructing the optional-window:
		echo the stream of the optional-window to the transcript.

Including the instruction in the activating the transcript phrase ensures that an existing window will be echoed when a transcript is started, while doing so in the after constructing activity ensures that a window opened after the transcript has begun will also be echoed. Note that the "echo the stream" phrase does nothing if the transcript is not already active, so it is safe to use anywhere in our code.

We can also stop a window's stream from being echoed to the transcript without closing the window by using this phrase:

	shut down the echo stream of <a text g-window>

It is also possible to send output to the transcript more selectively; see the "On the Edge" and "Terminal" examples below.


Section: Notes on pasting commands from mouse input

Emily Short's Glulx Entry Points extension provides rules that allow for commands to be pasted to the game's command line in response to the player's clicking on a hyperlink or a defined portion of a graphics window. Text Window Input-Output Control reroutes this pasting to the current text input window, whatever that is defined to be.

The extension also provides some control over the state of paragraphing across the sometimes troublesome switch between windows. This control comes via the "command-pasting terminator," a global text variable that we can set to whatever we need to make things look good. By default, there is no terminator (the value is ""). But if, for example, we are clearing the input window after each input, we will want to set the command-pasting terminator equal to "[run paragraph on]", or we will get an extra line break in the output window after each pasted command.


Section: Miscellaneous notes

One interesting consequence of the ability to set the main text output window is that we can now select text-grid windows as the main output or input windows. Doing so carries with it all the limitations of text-grid windows--most notably, the absence of scrolling and the inability to display images--but might be useful for certain effects (see the "Terminal" example below).  

Note that the character input routines from Basic Screen Effects ("wait for any key", "wait for the SPACE key", "the chosen letter") will now apply to whichever window is declared as the current text input window. To specify which window we want to accept character input, we can use the phrases defined in Flexible Windows (version 9+).

The current text output window also determines where figures are printed when we use the Inform library's "display the figure of ..." command. If the current text output window is not a text-buffer window, figures will not be displayed.

Similarly, the I6 routines VM_ClearScreen window(), VM_ScreenWidth(), and VM_ScreenHeight() will now operate on the current text output window rather than exclusively on the main window.


Section: Change Log

Version 2: Updated for 6F95. Now uses no deprecated features.

Version 1: Initial release.


Example: * Minimal - A very basic dual-window I/O setup. There are no tweaks to the standard behavior.

	*: "Minimal"

	Include Text Window Input-Output Control by Erik Temple.

	The input-window is a text-buffer g-window spawned by the main-window. The position is g-placebelow. The measurement is 10. The back-colour is g-lavender.

	When play begins:
		open up the input-window as the main text input window.
	
	Minimal Room is a room. "There really isn't anything at all to see or do here. I foresee lots of jumping, waiting, waving of hands, and self-examination."


Example: ** On the Edge - Another dual-window I/O example, but this time with a number of refinements. The input window clears after each command, to avoid scrolling, and is set off from the main window by a horizontal line (actually, a very narrow graphics window). To make up for the lack of command history in the input window, we echo each command in the output window before printing the result. The example also serves to illustrate a number of tweaks related to line spacing and transcript output.

We begin by defining the input window, as well as the graphics window that serves as the border between the input window and the main window. After opening these windows and declaring the input window to be the "current text input window", we start the game with some yes-no input, as a way of demonstrating that functionality.

	*: "On the Edge"

	Include Text Window Input-Output Control by Erik Temple.
	
	The input-window is a text-buffer g-window spawned by the main-window. The position is g-placebelow. The measurement is 10.
	
	The border-window is a graphics g-window spawned by the main-window. The position is g-placebelow. The scale method is g-fixed-size. The measurement is 2. The back-colour is g-dark-grey.
	
	When play begins:
		open up the input-window as the main text input window;
		open up the border-window;
		say "Are you sure you want to 'play' this 'game'?";
		unless the player consents:
			say "Well, that's probably for the best. Enjoy your life.";
			follow the immediately quit rule;
		say "OK, here we go...".	

We want the input window to clear after each command, so we slot that behavior into the "printing the command prompt" activity. We also insert some line breaks to improve the paragraphing behavior.

	*: Before printing the command prompt:
		clear the current text input window.
		
	After printing a parser error:
		say line break.
	
	Before reading a command when the current action is restarting the game or the current action is quitting the game:
		say line break.

We are clearing the input window after each command. This leaves the player with no visual record of the commands she has entered. So, we append the text of the command to the main window after reading it, printing it in italics to set it off from the other text in the window. However, because the transcript is receiving text streams from both the input and output windows, it will already have the input text. To avoid printing the player's input to the transcript twice, we temporarily suspend the main window's "echo stream"--the stream of data that is sent to the transcript--before printing the input in the main window.

This example also includes hyperlink input (see the next code block). Commands pasted from the hyperlink look good onscreen, but they need a line break when printing to the transcript. The definition of the "command-pasting terminator" global variable adds a line break to the transcript ONLY, bypassing the main window.

	*: After reading a command:
		shut down the echo stream of the main-window;
		say "[italic type][player's command][roman type]: [run paragraph on]";
		echo the stream of the main-window to the transcript.
	
	 The command-pasting terminator is "[run paragraph on][if we are writing a transcript][echo stream of current text input window][line break][stream of current text input window][end if]".

Finally, we have the scenario. We include two alternate forms of input, a hyperlink interface and single keystroke, merely to illustrate how such alternate input methods might work with the dual-window I/O, you are correct. Standard input works as well.

	*: Ledge is a room. "You are standing on a narrow ledge that encircles the upper floor of a very high building. There are no windows, no signs of life, no apparent exit except [link 1]jumping[end link]."	
	
	Table of Glulx Hyperlink Replacement Commands (continued)
	link ID	replacement
	1	"JUMP"
	2	"EXAMINE THE PEN"
	3	"TAKE THE PEN"
	
	Instead of jumping:
		say "You throw yourself forward...";
		end the game in death.
					
	The pen is in the Ledge. "Someone left a [link 2]pen[end link] on the ledge..." The description is "Odd, the [link 3]pen[end link] looks familiar."
	
	Instead of taking the pen:
		say "Press the space bar.";
		wait for the SPACE key in the current text output window;
		clear the current text output window;
		say "The world fades as if it were mist, and you are now in an office. Your office, in fact. You find that you are drooling on a yellow legal pad. ";
		end the game in victory.

Example: ** Terminal - This example illustrates one use for changing the current text output window. Basically, the player must interact with a computer terminal, and during this interaction  the game's interface apes the terminal. We open a new window (the terminal-output-window) in front of the main window, covering the latter completely. This new window is a text-grid window with reversed color-scheme and monotype font (both defaults for text-grid windows).

Another point of interest might be the "To say terminal text" phrase, which shows how to write text *only* to the transcript, and not to the screen. We do this here because we are using the status line (also a text-grid window) to display the name of the terminal. Since the I7 library (for good reason) doesn't write the status line to the transcript, we stream this text to it manually. 

	*: "Terminal"

	Include Basic Screen Effects by Emily Short.
	Include version 1 of Text Window Input-Output Control by Erik Temple.

	The terminal-input-window is a text-grid g-window spawned by the main-window. The position is g-placebelow. The measurement is 10.

	The terminal-output-window is a text-grid g-window spawned by the main-window. The position is g-placeabove. The measurement is 100.

	Before printing the command prompt when the location is TERM:
		clear the current text input window.

	[The following two rules restore the default behavior of the yes-no prompt.]

	When play begins:
		change the yes-no prompt to "".
		
	Yes-no prompting:
		say "[run paragraph on]";
		rule succeeds.

	The Control Center is a room. "Ancient machines sputter, buzz, and whine. How are they still operational after so many eons?"

	The terminal is a device in the Control Center. It is switched off. It is fixed in place.

	Instead of switching on the terminal:
		say "The terminal flickers to life. [paragraph break]Please press any key.";
		wait for any key;
		clear the main-window;
		move the player to TERM;
		open up the terminal-input-window as the main text input window;
		open up the terminal-output-window as the main text output window;
		change the right hand status line to "";
		say terminal text;
		say "WAKING...[paragraph break]RUNNING DIAGNOSTICS[paragraph break]SYSTEM CHECK OK[paragraph break]--------------[paragraph break]";
		say terminal selection;
		now the terminal is switched on;[we do this manually since we are bypassing the standard  behavior of the switching on action with this instead rule.]
	
	Procedural rule when the location is not the Control Center:
		ignore the room description heading rule;
		ignore the advance time rule.
	
	To say terminal text:
		if we are writing a transcript:
			say "[echo stream of current text output window][line break]----[location]----[line break][stream of current text output window]"
	
	Rule for constructing the status line when the player is not in the Control Center:
		center "[location]" at row 1;
		rule succeeds.
	
	To say terminal selection:
		say "MAKE SELECTION:[paragraph break]1. ACCESS CONTROL PROGRAM[line break]2. EXIT[paragraph break]"

	TERM is a room. The printed name is "TERMINAL 42.54.1". 

	Every turn when the location is TERM:
		say terminal text.
	
	After reading a command when the location is TERM:
		if the player's command does not match "[number]":
			reject the player's command.
	
	Entering terminal commands is an action applying to one number. Understand "[number]" as entering terminal commands when the location is TERM.

	Carry out entering terminal commands:
		if the number understood is 1:
			clear the current text output window;
			say "*****************[line break]* ACCESS DENIED *[line break]*****************[paragraph break]";
			say terminal selection;
		otherwise if the number understood is 2:
			clear the current text output window;
			say "********[line break]* EXIT *[line break]********[paragraph break]HIBERNATING...";
			wait for any key;
			shut down the terminal-output-window;
			shut down the terminal-input-window;
			say "The terminal flickers off. Guess you'd better hunt for a password. (Well, really, that's for a different game--this is just a little demo...)";
			move the player to the Control Center;
			change the right hand status line to "[score]/[turn count]";
			now the terminal is switched off;
			rule succeeds;
		otherwise:
			reject the player's command.







