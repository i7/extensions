Version 1/150104 of Glulx Virtual Timers (for Glulx only) by Erik Temple begins here.

Include Glulx Entry Points by Emily Short.

[****The basic virtual timer mechanism is possibly incorrect--we probably ought to check all timers each time any timer is activated or deactivated to ensure that the global timer reflects their intervals most efficiently. The current model may achieve that in the vast majority of cases, but it certainly doesn't  do it directly...]

Part - The virtual timer kind

A virtual timer is a kind of value. Some virtual timers are timer-1, timer-2, timer-3, timer-4, timer-5, timer-6, and timer-7.

A virtual timer can be active or inactive.
A virtual timer can be cyclic.
A virtual timer can be reserved or unreserved.

The triggered timer is a virtual timer variable.
The last created timer is a virtual timer variable.


Chapter - Timer controls

A virtual timer has a number called the interval.
A virtual timer has a number called the timer count.
A virtual timer has a number called the timer frame-multiple. The timer frame-multiple is usually 1.
A virtual timer has a number called the cycles completed. The cycles completed is usually 0.
A virtual timer has a number called the cycle target. The cycle target is usually 0.
A virtual timer has a text called the text-callback.
A virtual timer has a rule called the rule-callback.
A virtual timer has a truth state called interrupting line input. Interrupting line input is usually true.

Virtual timers active is a truth state variable. Virtual timers active is usually true.

To decide whether timers are queued:
	if there is an active virtual timer, decide yes.
	
To decide whether a virtual timer is ticking:
	if there is an active virtual timer and the global timer interval > 0, decide yes.
	

Part - Timer control phrases

The global timer interval is a number variable.
The standard interval divisor is a number variable. The standard interval divisor is 50.
[The standard interval divisor is used for performance reasons. We round all timer requests so that they are multiples of this number. This makes it more likely that we will have larger actual timer intervals. Without it, if the author specified concurrent virtual timer intervals of 41 and 83, then the global timer would have to tick every millisecond in order to space them accurately. No Glulx VM can currently manage this accurately, and it would put a strain on resources. With the standard interval divisor set to 100, the extension will silently adjust the intervals to 50 and 100 respectively, meaning that the timer will tick every 50 ms.]

To start a/-- Glulx timer of (T - a number) millisecond/milliseconds:
	if virtual timers active is false:
		rule fails;
	let N be the greater of the standard interval divisor or T to the nearest (standard interval divisor);[we round to the nearest 10 ms by default]
	#if utilizing inline debugging;
	say "[>console]Interval of [T] ms specified for virtual timer[if N is not T], rounded to [N] (nearest [standard interval divisor])[end if].[<]";
	#end if;
	if the global timer interval is greater than 0[i.e., there is a virtual timer running]:
		let N be the greatest common divisor of N and the global timer interval;	
		#if utilizing inline debugging;
		say "[>console]Global timer interval of [N] ms selected as greatest common divisor of the specified interval and the existing timer interval of [global timer interval] ms.[<]";
		#end if;
		let standardizer be a real number;
		now standardizer is N divided by the global timer interval;
		repeat with chron running through active virtual timers:
			now the timer frame-multiple of the chron is the interval of the chron divided by N;
			if the timer frame-multiple of the chron is 0, now the timer frame-multiple of the chron is 1;[prevents division errors]
			now the timer count of the chron is the remainder after dividing the timer count of the chron by the timer frame-multiple of the chron;
			unless standardizer is 1.0000:
				now the timer count of the chron is the timer count of the chron multiplied by the standardizer to the nearest whole number;
			#if utilizing inline debugging;
			say "[>console]Virtual timer [i][chron][/i] will fire every [timer frame-multiple of the chron] tick(s) of the global timer. Current offset: [timer count of the chron] frames.[<]";
			#end if;
	request virtualized timer event at N milliseconds;
	#if utilizing inline debugging;
	say "[>console]Global timer event requested for every [N] milliseconds.[<]";
	#end if.

 To pause virtualized timers:
	now virtual timers active is false;
	request virtualized timer event at 0 milliseconds;
	#if utilizing inline debugging;
	say "[>console][bold type]Stopping all virtual timers. Use 'restart virtualized timers' to restart[roman type].[<]";
	#end if.
	
To stop virtualized timers:
	request virtualized timer event at 0 milliseconds.

To restart virtualized timers:
	now virtual timers active is true;
	recalibrate the Glulx timer;
	#if utilizing inline debugging;
	say "[>console][bold type]Restarting virtual timers[roman type].[<]";
	#end if.

To request virtualized timer event at (T - a number) milliseconds:
	(- glk_request_timer_events({T}); (+ global timer interval +) = {T}; -).
	
To request non-virtualized timer event at (T - a number) milliseconds:
	(- glk_request_timer_events({T}); -).

[Inform 7 seems to have no way to test whether an enumerated value is valid for its kind; this does that for virtual timers.]
To decide whether (chron - a virtual timer) is a valid timer:
	repeat with test running through virtual timers:
		if chron is test:
			decide yes;
	decide no.

To deactivate (chron - a virtual timer):
	now chron is inactive;
	#if utilizing inline debugging;
	say "[>console]Virtual timer [italic type][triggered timer][roman type] deactivated.[<]";
	#end if;
	recalibrate the Glulx timer;
	unless a virtual timer is ticking:
		stop virtualized timers.

To reset the Glulx timer:
	start a Glulx timer of (global timer interval) milliseconds.
	
To recalibrate the Glulx timer:
	let min be 2147483647[maximum Glk integer value];
	repeat with chron running through active virtual timers:
		now min is the lesser of min or the interval of the chron;
	if min is greater than the global timer interval:
		now the global timer interval is min;
	reset the Glulx timer.
	

Chapter - Restart the timer after restoring

[The state of the timer is not automatically restored, so we must start the global timer on restore at the same speed it was running when the game was saved. The state of virtual timers is saved automatically since they are implemented as objects.]

First report restoring the game:
	reset the Glulx timer;
	continue the action.


Chapter - Restart the timer after undoing

[The state of the timer is not automatically saved with the game state, so we must start a timer after undoing at the same speed it was running when the game state was saved.]

The after undoing an action rules are a rulebook.

After undoing an action:
	#if utilizing inline debugging;
	say "[>console]Last turn undone. Restoring state of timers.[<]";
	#end if;
	reset the Glulx timer.
	
	
Part - Delaying the player's input

Definition: A g-event is glk-initiated if it is timer-event or it is sound-notify-event or it is arrange-event or it is not redraw-event.

To decide what number is glk event handled in (ev - a g-event) context:
	(- HandleGlkEvent(gg_event, {ev}, gg_arguments) -)


Chapter - Delaying input until all timers end

To delay input until all timers are complete:
	#if utilizing inline debugging;
	say "[>console]Input delayed while all active virtual timers complete.[<]";
	#end if;
	while timers are queued:
		wait for glk input;
		if the current glk event is glk-initiated:
			let event-outcome be glk event handled in null-event context;[Handles the event; we'll just ignore the outcome since it doesn't stem from player input.]
			

Chapter - Delaying input until just one timer has ended

To delay input until (chron - a virtual timer) is complete:
	#if utilizing inline debugging;
	say "[>console]Input delayed while the virtual timer [i][chron][/i] completes.[<]";
	#end if;
	while chron is active:
		wait for glk input;
		if the current glk event is glk-initiated:
			let event-outcome be glk event handled in null-event context;[Handles the event; we'll just ignore the outcome since it doesn't stem from player input.]
		
			
Chapter - Pausing input for a specified period

To wait (N - a number) before continuing:
	after (N) follow the little-used do nothing rule, disallowing input.
	
	
Part - Processing timer events

The timers deferred is a truth state variable. Timers deferred is usually false.
The timer deferral interval is initially 500.
			
A glulx timed activity rule when timers are queued and timers deferred is false (this is the virtual timer dispatch rule):
	if we are in alternate parsing:
		now timers deferred is true;
		request non-virtualized timer event at (timer deferral interval) milliseconds;
		#if utilizing inline debugging;
		say "[>console]Alternate library parsing routine is in use[if we are in a yes-no question] (yes-no response)[else if we are disambiguating] (disambiguation)[else if we are answering the final question] (answering final question)[end if]. Deferring virtual timers.[<]";
		#end if;
	otherwise:
		repeat with chron running through active virtual timers:
			increase the timer count of chron by 1;
			#if utilizing inline debugging;
			say "[>console][bold type][chron][roman type] count: [timer count of chron].[<]";
			#end if;
			if the remainder after dividing the timer count of the chron by the timer frame-multiple of the chron is 0:
				#if utilizing inline debugging;
				say "[>console][bold type][chron][roman type]: processing effect.[<]";
				#end if;
				now the triggered timer is chron;
				follow the timer exception rules for chron;
				if the outcome of the rulebook is the allow timer event outcome:
					if interrupting line input of the chron is true:
						suspend standard line input;
					if the text-callback of the chron is not empty:
						#if utilizing inline debugging;
						say "[>console][bold type][chron]:[roman type] text callback firing.[<]";
						#end if;
						say text-callback of the chron;
						say "[run paragraph on]";
					if the rule-callback of chron is not the little-used do nothing rule:
						#if utilizing inline debugging;
						say "[>console][bold type][chron]:[roman type] callback firing: [rule-callback of chron].[<]";
						#end if;
						follow the rule-callback of the chron;
					if chron is cyclic:
						increment cycles completed of the chron;
						#if utilizing inline debugging;
						say "[>console][bold type][chron]:[roman type] cycles completed = [cycles completed of the chron][if cycle target of the chron > 0]; cycles queued = [cycle target of the chron][end if].[<]";
						#end if;
						if the cycle target of the chron > 0 and the cycles completed of the chron >= the cycle target of the chron:
							#if utilizing inline debugging;
							say "[>console][bold type][chron]:[roman type] All cycles completed.[<]";
							#end if;
							deactivate the chron;
					else:
						deactivate the chron;
					if interrupting line input of the chron is true:
						resume standard line input;
				otherwise:
					#if utilizing inline debugging;
					say "[>console][bold type][chron]:[roman type] The timer exception rulebook prevented the event from firing.[<]";
					#end if;
		
First glulx timed activity rule when timers are queued and timers deferred is true (this is the bide timers rule):
	Unless we are in alternate parsing:
		now timers deferred is false;
		reset the Glulx timer;
		#if utilizing inline debugging;
		say "[>console]Alternate parsing complete.[<]";
		#end if.

To suspend standard line input (this is the cancel standard line input rule):
	#if utilizing inline debugging;
	say "[>console]   Suspending line input in main window.[<]";
	#end if;
	cancel line input in the main window, preserving keystrokes.
		
To resume standard line input (this is the resume standard line input rule):
	#if utilizing inline debugging;
	say "[>console]   Resuming line input in main window.[<]";
	#end if;
	say "[paragraph break][command prompt][run paragraph on]";
	re-request line input in main window.
		
				
Chapter - Timer exception rules

[This rulebook can be used to intervene in the normal firing of a virtual timer. Example: 

A timer exception rule:
	if a given condition holds:
		disallow timer event.
]

The timer exception rules are a virtual timer based rulebook. The timer exception rules have outcomes disallow timer event (failure) and allow timer event (success - the default).

Last timer exception rule (this is the allow timer events rule):
	allow timer event.


Part - Phrases to invoke virtual timers

To start (chron - a virtual timer) at (N - a number) milliseconds, without cancelling line input, disallowing input:
	[this rule assumes that the timer's main properties have already been set elsewhere.]
	if without cancelling line input:
		now interrupting line input of the chron is false;
	activate chron at N milliseconds;
	#if utilizing inline debugging;
	say "[>console]Created [bold type][chron]:[roman type] [if chron is not cyclic]not [end if]cyclic, interval [interval of the chron] milliseconds, [if interrupting line input of the chron is true]interrupts[otherwise]does not interrupt[end if] line input.[<]";
	#end if;
	if disallowing input:
		delay input until chron is complete.
		
To decide which virtual timer is a new timer (this is the new timer selection rule):
	if there is an inactive unreserved virtual timer:
		let chron be a random inactive unreserved virtual timer;
		#if utilizing inline debugging;
		say "[>console]New virtual timer requested, [chron] chosen at random.[<]";
		#end if;
		reset critical timer properties for the chron;
		decide on chron;
	otherwise:
		say "ERROR: A new virtual timer was requested but there are no free timers available. Create one or more new timers."
		
To reset critical timer properties for (chron - a virtual timer):
	now the text-callback of the chron is "";
	now the rule-callback of the chron is the little-used do nothing rule;
	now the interval of chron is 0;
	now the timer count of chron is 0;
	now the timer frame-multiple of chron is 1;
	now interrupting line input of the chron is true;
	now cycles completed of the chron is 0;
	now cycle target of the chron is 0;
	now the chron is not cyclic.
	
To activate (chron - a virtual timer) at (N - a number) milliseconds:
	now the last created timer is chron; 
	now the chron is active;
	now the interval of the chron is N to the nearest (standard interval divisor);
	start a Glulx timer of N milliseconds.
		

Chapter - Beefing up text callbacks

To say @ (ph - phrase): (- if (0==0) {ph}; RunParagraphOn(); -).

To say interrupt:
	suspend standard line input;
	say run paragraph on.

To say resume:
	resume standard line input;
	say run paragraph on[prevents printing issue].
		

Chapter - One-time events

To after (N - a number) say (callback - a text), without cancelling line input, disallowing input:
	let chron be a new timer;
	now text-callback of the chron is callback;
	if without cancelling line input:
		now interrupting line input of the chron is false;
	if disallowing input:
		start chron at N milliseconds, disallowing input;
	otherwise:
		start chron at N milliseconds.
		
To after (N - a number) follow (callback - a rule), cancelling line input, disallowing input:
	let chron be a new timer;
	now rule-callback of the chron is callback;
	unless cancelling line input:
		now interrupting line input of the chron is false;
	if disallowing input:
		start chron at N milliseconds, disallowing input;
	otherwise:
		start chron at N milliseconds.


Section - One-time events on a specific virtual timer
		 
To after (N - a number) on (chron - a virtual timer) say (callback - a text), without cancelling line input, disallowing input:
	reset critical timer properties for the chron;
	now text-callback of the chron is callback;
	if without cancelling line input:
		now interrupting line input of the chron is false;
	if disallowing input:
		start chron at N milliseconds, disallowing input;
	otherwise:
		start chron at N milliseconds.
		
To after (N - a number) on (chron - a virtual timer) follow (callback - a rule), cancelling line input, disallowing input:
	reset critical timer properties for the chron;
	now rule-callback of the chron is callback;
	unless cancelling line input:
		now interrupting line input of the chron is false;
	if disallowing input:
		start chron at N milliseconds, disallowing input;
	otherwise:
		start chron at N milliseconds.
		

Chapter - Cyclic events
		
To every (N - a number) say (callback - a text), without cancelling line input, disallowing input:
	let chron be a new timer;
	now chron is cyclic;
	now text-callback of the chron is callback;
	if without cancelling line input:
		now interrupting line input of the chron is false;
	if disallowing input:
		start chron at N milliseconds, disallowing input;
	otherwise:
		start chron at N milliseconds.
		
To every (N - a number) follow (callback - a rule), cancelling line input, disallowing input:
	let chron be a new timer;
	now chron is cyclic;
	now rule-callback of the chron is callback;
	unless cancelling line input:
		now interrupting line input of the chron is false;
	if disallowing input:
		start chron at N milliseconds, disallowing input;
	otherwise:
		start chron at N milliseconds.
		

Section - Cyclic events on a specific virtual timer
		
To every (N - a number) on (chron - a virtual timer) say (callback - a text), without cancelling line input, disallowing input:
	reset critical timer properties for the chron;
	now chron is cyclic;
	now text-callback of the chron is callback;
	if without cancelling line input:
		now interrupting line input of the chron is false;
	if disallowing input:
		start chron at N milliseconds, disallowing input;
	otherwise:
		start chron at N milliseconds.

To every (N - a number) on (chron - a virtual timer) follow (callback - a rule), cancelling line input, disallowing input:
	reset critical timer properties for the chron;
	now chron is cyclic;
	now rule-callback of the chron is callback;
	unless cancelling line input:
		now interrupting line input of the chron is false;
	if disallowing input:
		start chron at N milliseconds, disallowing input;
	otherwise:
		start chron at N milliseconds.
		
		
Chapter - Cyclic events with sunset

To every (N - a number) up to (T - a number) times say (callback - a text), without cancelling line input, disallowing input:
	let chron be a new timer;
	now chron is cyclic;
	now cycle target of the chron is T;
	now text-callback of the chron is callback;
	if without cancelling line input:
		now interrupting line input of the chron is false;
	if disallowing input:
		start chron at N milliseconds, disallowing input; 
	otherwise:
		start chron at N milliseconds.

To every (N - a number) up to (T - a number) times follow (callback - a rule), cancelling line input, disallowing input:
	let chron be a new timer;
	now chron is cyclic;
	now cycle target of the chron is T;
	now rule-callback of the chron is callback;
	unless cancelling line input:
		now interrupting line input of the chron is false;
	if disallowing input:
		start chron at N milliseconds, disallowing input; 
	otherwise:
		start chron at N milliseconds.		

		
Section - Sunsetting cyclic events on a specific virtual timer
		
To every (N - a number) up to (T - a number) times on (chron - a virtual timer) say (callback - a text), without cancelling line input, disallowing input:
	reset critical timer properties for the chron;
	now chron is cyclic;
	now cycle target of the chron is T;
	now text-callback of the chron is callback;
	if without cancelling line input:
		now interrupting line input of the chron is false;
	if disallowing input:
		start chron at N milliseconds, disallowing input;
	otherwise:
		start chron at N milliseconds.
		
To every (N - a number) up to (T - a number) times on (chron - a virtual timer) follow (callback - a rule), cancelling line input, disallowing input:
	reset critical timer properties for the chron;
	now chron is cyclic;
	now cycle target of the chron is T;
	now rule-callback of the chron is callback;
	unless cancelling line input:
		now interrupting line input of the chron is false;
	if disallowing input:
		start chron at N milliseconds, disallowing input;
	otherwise:
		start chron at N milliseconds.
		

Part - New syntax for timed events

To (R - rule) on the next turn:
	(- SetTimedEvent({-mark-event-used:R}, 1, 0); -).
		

Part - Phrases for input maintenance

To re-request line input in main window:
	(- glk_request_line_event(gg_mainwin, stored_buffer + WORDSIZE, INPUT_BUFFER_LEN - WORDSIZE, stored_buffer-->0); -)

To cancel line input in the/-- main window, preserving keystrokes:
	(- glk_cancel_line_event(gg_mainwin, gg_event); stored_buffer-->0 = gg_event-->2; -)

To decide whether we are disambiguating:
	(- stored_buffer == buffer2 -)
	
To decide whether we are in a yes-no question:
	(- yes_no == 1 -)
	
To decide whether we are answering the final question:
	(- final_answer == 1 -)
	
To decide whether we are in alternate parsing:
	if we are disambiguating or we are in a yes-no question or we are answering the final question, decide yes.
	
[The following phrase is provided in case the user needs it. However, the extension does not attempt to handle character input.]
To cancel character input in the/-- main window:
	(- glk_cancel_char_event(gg_mainwin); -)
	

Part - Conversions

To decide which number is (N - arithmetic value) millisecond/milliseconds/ms:
	decide on N to the nearest whole number;
	
To decide which number is (N - a arithmetic value) second/seconds/s:
	decide on N * 1000 to the nearest whole number;
	
To decide which number is (N - a arithmetic value) hour/hours/h:
	decide on N * 3600000 to the nearest whole number;
	
	
Part - I/O management template hacks

Include (- Global stored_buffer = 0 ; Global yes_no = 0; Global final_answer = 0; -) after "Definitions.i6t"


Chapter - Keyboard Input template replacement

Include (-

[ VM_KeyChar win nostat done res ix jx ch;
	jx = ch; ! squash compiler warnings
	if (win == 0) win = gg_mainwin;
	if (gg_commandstr ~= 0 && gg_command_reading ~= false) {
		done = glk_get_line_stream(gg_commandstr, gg_arguments, 31);
		if (done == 0) {
			glk_stream_close(gg_commandstr, 0);
			gg_commandstr = 0;
			gg_command_reading = false;
			! fall through to normal user input.
		} else {
			! Trim the trailing newline
			if (gg_arguments->(done-1) == 10) done = done-1;
			res = gg_arguments->0;
			if (res == '\') {
				res = 0;
				for (ix=1 : ix<done : ix++) {
					ch = gg_arguments->ix;
					if (ch >= '0' && ch <= '9') {
						@shiftl res 4 res;
						res = res + (ch-'0');
					} else if (ch >= 'a' && ch <= 'f') {
						@shiftl res 4 res;
						res = res + (ch+10-'a');
					} else if (ch >= 'A' && ch <= 'F') {
						@shiftl res 4 res;
						res = res + (ch+10-'A');
					}
				}
			}
	   		jump KCPContinue;
		}
	}
	done = false;
	glk_request_char_event(win);
	while (~~done) {
		glk_select(gg_event);
		switch (gg_event-->0) {
		  5: ! evtype_Arrange
			if (nostat) {
				glk_cancel_char_event(win);
				res = $80000000;
				done = true;
				break;
			}
			DrawStatusLine();
		  2: ! evtype_CharInput
			if (gg_event-->1 == win) {
				res = gg_event-->2;
				done = true;
				}
		}
		ix = HandleGlkEvent(gg_event, 1, gg_arguments);
		if (ix == 2) {
			res = gg_arguments-->0;
			done = true;
		} else if (ix == -1)  done = false;
	}
	if (gg_commandstr ~= 0 && gg_command_reading == false) {
		if (res < 32 || res >= 256 || (res == '\' or ' ')) {
			glk_put_char_stream(gg_commandstr, '\');
			done = 0;
			jx = res;
			for (ix=0 : ix<8 : ix++) {
				@ushiftr jx 28 ch;
				@shiftl jx 4 jx;
				ch = ch & $0F;
				if (ch ~= 0 || ix == 7) done = 1;
				if (done) {
					if (ch >= 0 && ch <= 9) ch = ch + '0';
					else                    ch = (ch - 10) + 'A';
					glk_put_char_stream(gg_commandstr, ch);
				}
			}
		} else {
			glk_put_char_stream(gg_commandstr, res);
		}
		glk_put_char_stream(gg_commandstr, 10); ! newline
	}
  .KCPContinue;
	return res;
];

[ VM_KeyDelay tenths  key done ix;
	glk_request_char_event(gg_mainwin);
	glk_request_timer_events(tenths*100);
	while (~~done) {
		glk_select(gg_event);
		ix = HandleGlkEvent(gg_event, 1, gg_arguments);
		if (ix == 2) {
			key = gg_arguments-->0;
			done = true;
		}
		else if (ix >= 0 && gg_event-->0 == 1 or 2) {
			key = gg_event-->2;
			done = true;
		}
	}
	glk_cancel_char_event(gg_mainwin);
	glk_request_timer_events(0);
	return key;
];

[ VM_ReadKeyboard  a_buffer a_table done ix;
	if (gg_commandstr ~= 0 && gg_command_reading ~= false) {
		done = glk_get_line_stream(gg_commandstr, a_buffer+WORDSIZE,
			(INPUT_BUFFER_LEN-WORDSIZE)-1);
		if (done == 0) {
			glk_stream_close(gg_commandstr, 0);
			gg_commandstr = 0;
			gg_command_reading = false;
		}
		else {
			! Trim the trailing newline
			if ((a_buffer+WORDSIZE)->(done-1) == 10) done = done-1;
			a_buffer-->0 = done;
			VM_Style(INPUT_VMSTY);
			glk_put_buffer(a_buffer+WORDSIZE, done);
			VM_Style(NORMAL_VMSTY);
			print "^";
			jump KPContinue;
		}
	}
	done = false;
	stored_buffer = a_buffer;
	glk_request_line_event(gg_mainwin, a_buffer+WORDSIZE, INPUT_BUFFER_LEN-WORDSIZE, 0);
	while (~~done) {
		glk_select(gg_event);
		switch (gg_event-->0) {
		  5: ! evtype_Arrange
			DrawStatusLine();
		  3: ! evtype_LineInput
			if (gg_event-->1 == gg_mainwin) {
				a_buffer-->0 = gg_event-->2;
				done = true;
			}
		}
		ix = HandleGlkEvent(gg_event, 0, a_buffer);
		if (ix == 2) done = true;
		else if (ix == -1) done = false;
	}
	if (gg_commandstr ~= 0 && gg_command_reading == false) {
		glk_put_buffer_stream(gg_commandstr, a_buffer+WORDSIZE, a_buffer-->0);
		glk_put_char_stream(gg_commandstr, 10); ! newline
	}
  .KPContinue;
	VM_Tokenise(a_buffer,a_table);
	! It's time to close any quote window we've got going.
	if (gg_quotewin) {
		glk_window_close(gg_quotewin, 0);
		gg_quotewin = 0;
	}
	#ifdef ECHO_COMMANDS;
	print "** ";
	for (ix=WORDSIZE: ix<(a_buffer-->0)+WORDSIZE: ix++) print (char) a_buffer->ix;
	print "^";
	#endif; ! ECHO_COMMANDS
];

-) instead of "Keyboard Input" in "Glulx.i6t"


Chapter - Yes or No flag template replacement

Include (-

[ YesOrNo i j;
	for (::) {
		#Ifdef TARGET_ZCODE;
		if (location == nothing || parent(player) == nothing) read buffer parse;
		else read buffer parse DrawStatusLine;
		j = parse->1;
		#Ifnot; ! TARGET_GLULX;
		if (location ~= nothing && parent(player) ~= nothing) DrawStatusLine();
		yes_no = 1; ! ***Added flag so that we can test whether alternate parsing is in process
		RunParagraphOn(); ! ***Prevents DivideParagraphPoint() from printing newline during line input
		KeyboardPrimitive(buffer, parse);
		j = parse-->0;
		#Endif; ! TARGET_
		if (j) { ! at least one word entered
			i = parse-->1;
			if (i == YES1__WD or YES2__WD or YES3__WD) { yes_no = 0; rtrue; }
			if (i == NO1__WD or NO2__WD or NO3__WD) { yes_no = 0; rfalse; }
		}
		YES_OR_NO_QUESTION_INTERNAL_RM('A'); print "> ";
	}
];

[ YES_OR_NO_QUESTION_INTERNAL_R; ];

-) instead of "Yes/No Questions" in "Parser.i6t"


Chapter - Final answer flag template replacement

Include (-
[ READ_FINAL_ANSWER_R;
	DrawStatusLine();
	final_answer = 1; ! ***Added flag so that we can test whether alternate parsing is in process
	RunParagraphOn(); ! ***Prevents DivideParagraphPoint() from printing newline during line input
	KeyboardPrimitive(buffer, parse);
	players_command = 100 + WordCount();
	num_words = WordCount();
	wn = 1;
	rfalse;
];

-) instead of "Read The Final Answer Rule" in "OrderOfPlay.i6t"


Part - Undo hook requires Keyboard template replacement

Include (-
[ Keyboard  a_buffer a_table  nw i w w2 x1 x2;
	sline1 = score; sline2 = turns;

	while (true) {
		! Save the start of the buffer, in case "oops" needs to restore it
		for (i=0 : i<64 : i++) oops_workspace->i = a_buffer->i;
	
		! In case of an array entry corruption that shouldn't happen, but would be
		! disastrous if it did:
		#Ifdef TARGET_ZCODE;
		a_buffer->0 = INPUT_BUFFER_LEN;
		a_table->0 = 15;  ! Allow to split input into this many words
		#Endif; ! TARGET_
	
		! Print the prompt, and read in the words and dictionary addresses
		PrintPrompt();
		DrawStatusLine();
		KeyboardPrimitive(a_buffer, a_table);
	
		! Set nw to the number of words
		#Ifdef TARGET_ZCODE; nw = a_table->1; #Ifnot; nw = a_table-->0; #Endif;
	
		! If the line was blank, get a fresh line
		if (nw == 0) {
			@push etype; etype = BLANKLINE_PE;
			players_command = 100;
			BeginActivity(PRINTING_A_PARSER_ERROR_ACT);
			if (ForActivity(PRINTING_A_PARSER_ERROR_ACT) == false) {
				PARSER_ERROR_INTERNAL_RM('X', noun); new_line;
			}
			EndActivity(PRINTING_A_PARSER_ERROR_ACT);
			@pull etype;
			continue;
		}
	
		! Unless the opening word was OOPS, return
		! Conveniently, a_table-->1 is the first word on both the Z-machine and Glulx
	
		w = a_table-->1;
		if (w == OOPS1__WD or OOPS2__WD or OOPS3__WD) {
			if (oops_from == 0) { PARSER_COMMAND_INTERNAL_RM('A'); new_line; continue; }
			if (nw == 1) { PARSER_COMMAND_INTERNAL_RM('B'); new_line; continue; }
			if (nw > 2) { PARSER_COMMAND_INTERNAL_RM('C'); new_line; continue; }
		
			! So now we know: there was a previous mistake, and the player has
			! attempted to correct a single word of it.
		
			for (i=0 : i<INPUT_BUFFER_LEN : i++) buffer2->i = a_buffer->i;
			#Ifdef TARGET_ZCODE;
			x1 = a_table->9;  ! Start of word following "oops"
			x2 = a_table->8;  ! Length of word following "oops"
			#Ifnot; ! TARGET_GLULX
			x1 = a_table-->6; ! Start of word following "oops"
			x2 = a_table-->5; ! Length of word following "oops"
			#Endif; ! TARGET_
		
			! Repair the buffer to the text that was in it before the "oops"
			! was typed:
			for (i=0 : i<64 : i++) a_buffer->i = oops_workspace->i;
			VM_Tokenise(a_buffer,a_table);
		
			! Work out the position in the buffer of the word to be corrected:
			#Ifdef TARGET_ZCODE;
			w = a_table->(4*oops_from + 1); ! Start of word to go
			w2 = a_table->(4*oops_from);    ! Length of word to go
			#Ifnot; ! TARGET_GLULX
			w = a_table-->(3*oops_from);      ! Start of word to go
			w2 = a_table-->(3*oops_from - 1); ! Length of word to go
			#Endif; ! TARGET_
		
			! Write spaces over the word to be corrected:
			for (i=0 : i<w2 : i++) a_buffer->(i+w) = ' ';
		
			if (w2 < x2) {
				! If the replacement is longer than the original, move up...
				for (i=INPUT_BUFFER_LEN-1 : i>=w+x2 : i-- )
					a_buffer->i = a_buffer->(i-x2+w2);
		
				! ...increasing buffer size accordingly.
				#Ifdef TARGET_ZCODE;
				a_buffer->1 = (a_buffer->1) + (x2-w2);
				#Ifnot; ! TARGET_GLULX
				a_buffer-->0 = (a_buffer-->0) + (x2-w2);
				#Endif; ! TARGET_
			}
		
			! Write the correction in:
			for (i=0 : i<x2 : i++) a_buffer->(i+w) = buffer2->(i+x1);
		
			VM_Tokenise(a_buffer, a_table);
			#Ifdef TARGET_ZCODE; nw = a_table->1; #Ifnot; nw = a_table-->0; #Endif;
		
			return nw;
		}

		! Undo handling
	
		if ((w == UNDO1__WD or UNDO2__WD or UNDO3__WD) && (nw==1)) {
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
			FollowRulebook( (+ after undoing an action rules +) );
			continue;
		}
		return nw;
	}
];
-) instead of "Reading the Command" in "Parser.i6t"


Part - Debugging (for use without Glulx Debugging Console by Erik Temple)

Use inline debugging translates as (- Constant INLINE_DEBUG; -)

To #if utilizing inline debugging:
	(- #ifdef INLINE_DEBUG; -)
	
To #end if:
	(- #endif; -)
	
[If we don't have the Glulx Debugging Console extension installed, we direct console output inline into the transcript.]
To say >console:
	say echo stream of main-window.
	
To say <:
	say stream of main-window;
	say run paragraph on.
			

Part - Utility functions

To decide which number is the greater of (X - arithmetic value) or (Y - arithmetic value):
	if Y > X, decide on Y;
	decide on X.
	
To decide which number is the lesser of (X - arithmetic value) or (Y - arithmetic value):
	if Y < X, decide on Y;
	decide on X.
	
[Greatest common divisor function from Ben Cressey: http://www.intfiction.org/forum/viewtopic.php?f=7&t=3424]
To decide what number is the greatest common divisor of (A - a number) and (B - a number):
	if B is 0, decide on A;
	decide on the greatest common divisor of B and the remainder after dividing A by B.
	
		
Glulx Virtual Timers ends here.
