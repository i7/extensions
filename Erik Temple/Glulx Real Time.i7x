Version 1/150115 of Glulx Real Time (for Glulx only) by Erik Temple begins here.

"Allows the user to easily create multiple virtual timers for real-time events. Compatible with Inform build 6L38."

Include Glulx Entry Points by Emily Short.

[****The basic virtual timer mechanism is possibly incorrect--we probably ought to check all timers each time any timer is activated or deactivated to ensure that the global timer reflects their intervals most efficiently. The current model may achieve that in the vast majority of cases, but it certainly doesn't do iittut directly...]

Part - The virtual timer kind

A virtual timer is a kind of value. Some virtual timers are timer-1, timer-2, timer-3, timer-4, timer-5, timer-6, and timer-7.

A virtual timer can be active or inactive.
A virtual timer can be cyclic.
A virtual timer can be reserved or unreserved. A virtual timer is usually reserved.

Timer-1 is unreserved. Timer-2 is unreserved. Timer-3 is unreserved. Timer-4 is unreserved. Timer-5 is unreserved. Timer-6 is unreserved.  Timer-7 is unreserved.

The triggered timer is a virtual timer variable.
The last created timer is a virtual timer variable.


Chapter - Timer controls

A virtual timer has a number called the interval.
A virtual timer has a number called the timer count.
A virtual timer has a number called the timer frame-multiple. The timer frame-multiple is usually 1.
A virtual timer has a number called the cycles completed. The cycles completed is usually 0.
A virtual timer has a number called the cycles desired. The cycles desired is usually 0.
A virtual timer has a text called the text-callback.
A virtual timer has a rule called the rule-callback.
A virtual timer has a truth state called interrupting line input. Interrupting line input is usually false.

virtual timers active is a truth state variable. Virtual timers active is usually true.

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
	if timers are queued:
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
	if chron >= first value of virtual timer and chron <= last value of virtual timer:
		decide yes.

To deactivate (chron - a virtual timer):
	now chron is inactive;
	#if utilizing inline debugging;
	say "[>console]Virtual timer [italic type][triggered timer][roman type] deactivated.[<]";
	#end if;
	if a virtual timer is ticking:
		recalibrate the Glulx timer;
	otherwise:
		stop virtualized timers.

To reset the Glulx timer:
	start a Glulx timer of (global timer interval) milliseconds.
	
To recalibrate the Glulx timer:
	let min be 2147483647[maximum Glk integer value];
	#if utilizing inline debugging;
	say "[>console]Recalibrating timers.[<]";
	#end if;
	repeat with chron running through active virtual timers:
		#if utilizing inline debugging;
		say "[>console]  [italic type][chron][roman type]: [interval of the chron].[<]";
		#end if;
		now min is the lesser of min or the interval of the chron;
	if min is greater than the global timer interval and min is not 2147483647:
		now the global timer interval is min;
	if the global timer interval > 0 and min < 2147483647:
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

To wait for/-- (N - a number) before continuing:
	after (N) follow the little-used do nothing rule, disallowing input.
	
	
Part - Processing timer events

The timers deferred is a truth state variable. Timers deferred is usually false.
The timer deferral interval is initially 500.
			
A glulx timed activity rule when timers are queued and timers deferred is false (this is the virtual timer dispatch rule):
	if we are receiving alternate input:
		now timers deferred is true;
		request non-virtualized timer event at (timer deferral interval) milliseconds;
		#if utilizing inline debugging;
		say "[>console]Alternate library parsing routine is in use[if we are in a yes-no question] (yes-no response)[else if we are disambiguating] (disambiguation)[else if we are answering the final question] (answering final question)[end if]. Deferring virtual timers.[<]";
		#end if;
	otherwise:
		repeat with chron running through active virtual timers:
			if we are receiving alternate input:
				#if utilizing inline debugging;
				say "[>console]Aborting processing of virtual timers until after deferral stage.[<]";
				#end if;
				break;
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
					if chron is cyclic:
						increment cycles completed of the chron;
						#if utilizing inline debugging;
						say "[>console][bold type][chron]:[roman type] cycles completed = [cycles completed of the chron][if cycles desired of the chron > 0]; cycles queued = [cycles desired of the chron][end if].[<]";
						#end if;
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
						if the cycles desired of the chron > 0 and the cycles completed of the chron >= the cycles desired of the chron:
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
	Unless we are receiving alternate input:
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

To start (chron - a virtual timer) at (N - a number) milliseconds, cancelling line input, disallowing input:
	[this rule assumes that the timer's main properties have already been set elsewhere.]
	unless cancelling line input:
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
		say "[interrupt]ERROR: A new virtual timer was requested but there are no free timers available. Create one or more new timers.[resume][line break][run paragraph on]"
		
To reset critical timer properties for (chron - a virtual timer):
	now the text-callback of the chron is "";
	now the rule-callback of the chron is the little-used do nothing rule;
	now the interval of chron is 0;
	now the timer count of chron is 0;
	now the timer frame-multiple of chron is 1;
	now interrupting line input of the chron is false;
	now cycles completed of the chron is 0;
	now cycles desired of the chron is 0;
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

To after (N - a number) say (callback - a text), cancelling line input, disallowing input:
	let chron be a new timer;
	now text-callback of the chron is callback;
	unless cancelling line input:
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
		 
To after (N - a number) on (chron - a virtual timer) say (callback - a text), cancelling line input, disallowing input:
	reset critical timer properties for the chron;
	now text-callback of the chron is callback;
	unless cancelling line input:
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
		
To every (N - a number) say (callback - a text), cancelling line input, disallowing input:
	let chron be a new timer;
	now chron is cyclic;
	now text-callback of the chron is callback;
	unless cancelling line input:
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
		
To every (N - a number) on (chron - a virtual timer) say (callback - a text), cancelling line input, disallowing input:
	reset critical timer properties for the chron;
	now chron is cyclic;
	now text-callback of the chron is callback;
	unless cancelling line input:
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

To every (N - a number) up to (T - a number) times say (callback - a text), cancelling line input, disallowing input:
	let chron be a new timer;
	now chron is cyclic;
	now cycles desired of the chron is T;
	now text-callback of the chron is callback;
	unless cancelling line input:
		now interrupting line input of the chron is false;
	if disallowing input:
		start chron at N milliseconds, disallowing input; 
	otherwise:
		start chron at N milliseconds.

To every (N - a number) up to (T - a number) times follow (callback - a rule), cancelling line input, disallowing input:
	let chron be a new timer;
	now chron is cyclic;
	now cycles desired of the chron is T;
	now rule-callback of the chron is callback;
	unless cancelling line input:
		now interrupting line input of the chron is false;
	if disallowing input:
		start chron at N milliseconds, disallowing input; 
	otherwise:
		start chron at N milliseconds.		

		
Section - Sunsetting cyclic events on a specific virtual timer
		
To every (N - a number) up to (T - a number) times on (chron - a virtual timer) say (callback - a text), cancelling line input, disallowing input:
	reset critical timer properties for the chron;
	now chron is cyclic;
	now cycles desired of the chron is T;
	now text-callback of the chron is callback;
	unless cancelling line input:
		now interrupting line input of the chron is false;
	if disallowing input:
		start chron at N milliseconds, disallowing input;
	otherwise:
		start chron at N milliseconds.
		
To every (N - a number) up to (T - a number) times on (chron - a virtual timer) follow (callback - a rule), cancelling line input, disallowing input:
	reset critical timer properties for the chron;
	now chron is cyclic;
	now cycles desired of the chron is T;
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
	
To decide whether we are receiving alternate input:
	if we are disambiguating or we are in a yes-no question or we are answering the final question or the alternate input flag is true, decide yes.
	

Chapter - Manual flag for alternate input

[When this flag is set to true, virtual timers will be automatically suspended until the author sets it to false. This allows for any input to be collected without being interrupted by an attempt to print to the screen illegally.]
The alternate input flag is initially false.


Chapter - Safe phrases for getting keystroke input

To wait for any key while deferring virtual timers:
	let cached flag be the alternate input flag;
	now the alternate input flag is true;
	wait for any key;
	now the alternate input flag is the cached flag.
	
To wait for the/-- SPACE key while deferring virtual timers:
	let cached flag be the alternate input flag;
	now the alternate input flag is true;
	wait for the SPACE key;
	now the alternate input flag is the cached flag.
	
To decide what number is the timer-safe chosen letter:
	let cached flag be the alternate input flag;
	now the alternate input flag is true;
	let N be the chosen letter;
	now the alternate input flag is the cached flag;
	decide on N.
	
[The following phrase is provided in case the user needs it. It isn't used by the extension, which doesn't make any attempt to deal comprehensively with character input. ]
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
	say echo stream of main window.
	
To say <:
	say stream of main window;
	say run paragraph on.
	
To say echo stream of main window:
	(- if (glk_window_get_echo_stream(gg_mainwin)) { glk_stream_set_current( glk_window_get_echo_stream(gg_mainwin) ); } -)
	
To say stream of main window:
	(- glk_set_window(gg_mainwin); -)


Chapter - Abbreviations

[These are phpBB-inspired macros for some fairly keystroke-intensive I7 text substitutions.]

To say b:
	say "[bold type]";

To say /b:
	say "[roman type]";

To say i:
	say "[italic type]";

To say /i:
	say "[roman type]";
			

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
	
		
Glulx Real Time ends here.

---- Documentation ----

Glulx Real Time allows authors to freely create real-time events that fire on either a one-time or a cyclical basis. Timers can be used for many purposes, including keeping track of elapsed time, printing atmospheric text to the screen, implementing time-limited input and various multimedia effects, and more. It automatically deals with undo and with restored games.

Section: Types of virtual timers

There are three types of timers: those that fire just once, those that cycle indefinitely, and those that cycle a prescribed number of times ("sunset timers"). All of these types can do one of two things when an event fires: print a text (including special performative texts), or fire a rule. Timers are usually initialized anonymously, and they begin ticking immediately. Examples of the three types of timer:

	after 400 milliseconds say "[interrupt]Manna begins to fall from the heavens![resume]".
	after 30 seconds follow the manna from heaven rule.
	
	every 180 seconds say atmospherics [a text variable].
	every 10 minutes follow the atmospheric effects rule.
	
	every 1 hour up to 5 times say "[interrupt]You have wasted [one of]an[or]another[stopping] hour playing this game![resume]".
	every 3800 milliseconds up to 10 times follow the annoy the player rule.
	
Intervals may be enumerated in milliseconds, seconds, minutes, or hours. You may have up to seven timers running at the same time without making any special effort. If you need more than that, you may create your own; see the next section.

Section: Performative text

Glulx Real Time allows for special "performative" construction. Just include a @ before a phrase instruction and it will be called as if it were its own line of code:

	after 300 milliseconds say "[@ follow the annoy the player rules][interrupt]Annoyed yet?[resume]".

Due to limitations in Inform text substitutions, some punctuation will not work in these performative substitutions. Otherwise, just about any phrase can be invoked in this way.

Section: Triggering standard Inform timed events

An extension available for earlier versions of Inform (Basic Real Time by Sarah Morayati) allowed Inform's standard timed events to be triggered by a real-time event.  This is useful to allow for real time's passage to influence the game without breaking the turn-by-turn feeling of the interface. Use the phrase "<timed event> on the next turn" to cause a timed event to happen on the turn following a real-time event:

	After 300 seconds follow the egg timer rule.
	
	This is the egg timer rule:
		the egg-timer clucks on the next turn.
		
Or, using "performative" text:

	After 300 seconds "[@ the egg-timer clucks on the next turn]".	

See §9.11 Future Events in the Inform manual for more on timed events.


Section: Pausing the game

It is possible to pause the game until a timer fires; that is, to disallow the player any input until the event fires. For example, this will pause the game for one seconds, then prompt the player.

	after 1000 milliseconds, say "[interrupt]You should try going north.[resume]", disallowing input.
	
Be warned that a rule like the following will pause the game permanently unless you provide logic to cancel the input from within the fired rule.

	every 3 seconds follow the terrible beeps rule, disallowing input.
	
To cancel the timer from within the rule, use "deactivate the triggered timer" from within the rule called by the timer, e.g.:

	The delay counter is initially 0.
	
	This is the terrible beeps rule:
		if a random chance of 1 in 5 succeeds:
			increment the delay counter;
		if the delay counter is greater than 3:
			deactivate the triggered timer;
		otherwise:
			play the sound of terrible beep.
			
If you simply want to pause the game for a period without any other effect:
	 
	 wait 1 second before continuing.
	 
It is also possible to pause the game until one or all timers complete using these phrases:

	delay input until <virtual timer> is complete;
	delay input until all timers are complete;
	
The pause begins immediately. Be careful with the second one! If you have a cyclic timer that doesn't cancel itself or isn't canceled by another timer, the pause will never end.

See the next section for working with named timers.

			
Section: New timers, including named timers

If you need to run more than seven timers at once, you will need to create new virtual timers. (Note that running so many timers concurrently is not necessarily to be recommended, since it has at least the potential to negatively impact performance.) New timers can be either anonymous, or named so that we can easily interact with them later. We can create new anonymous timers like so:

	Timer-8 is a virtual timer. It is unreserved.
	
The keyword "unreserved" allows the timer to be used in the same anonymous way as the built-in timers. Timers--including any of the built-in timers--can also be declared "reserved". This means that they cannot be used anonymously. Instead, they can only be used by name.

Newly created timers are in fact "reserved" by default, and can be therefore be defined quite simply:

	The countdown is a virtual timer.
	
To use a reserved timer, we must be instantiate it by providing its name, e.g. for a timer called "countdown":

	Every 1 second up to 6 times on the countdown follow the counting down rule.
	
We can refer to the timer by name anywhere in our code. For that reason, it will usually be best to name a timer if we need to, for example, cancel it based on external effects. That said, we can use the following terms to refer to both anonymous and named (i.e. reserved and unreserved) timers:
		
	the triggered timer - this phrase should be used only within a rule that is fired by a timer.
	
	the last created timer - this identifier should only be used within the same rule that instantiated a timer. It refers to the timer defined in the last "After <time>..." or "Every <time>..." phrase.
	
			
Section: Safely printing text from a timer

It is illegal to print text to a window while Glulx is waiting for keyboard input in that window. Because an Inform game is almost always waiting for typed input when a timer event fires, we need to ensure that we cancel the input request before printing to the screen. Note that it is only necessary to cancel input when printing to the same window in which the input is pending. If your game uses the standard library for input and you are printing to the main window, you will need to cancel input each time. But if your timers only print to the status line or to a secondary window (e.g., created using Flexible Windows), then you probably won't need to cancel input.

Glulx Real Time provides two ways to cancel standard keyboard input ("line input" in Glk parlance). We can add a bit at the end of the timer definition, e.g.:

	every 3800 milliseconds up to 10 times follow the annoy the player rule, cancelling line input.
	after 12 seconds on my fancy timer say "Fancy, huh?", cancelling line input.
	
This will cancel line input before triggering the requested text or effect, and then restart it again afterward.  Actually, line input will be requested automatically, even if a line input request was not pending prior to cancellation.

Alternatively, we can do this manually using the text substitutions "interrupt" and "resume":

	after 1000 milliseconds, say "[interrupt]You should try going north.[resume]"
	
See the extension's example game for a situation where this manual method turns out to be useful.

Glulx Real Time does not make any attempt to deal with single-character input.


Section:  Special input

Glulx Real Time deals with certain types of "special input" by simply putting timer events on hold. This is true of the Inform library's disambiguation prompts, yes/no prompts, and the final question prompt. Any timer event that would fire while these alternate states are in effect is deferred until standard input is resumed.

While Glulx Real Time doesn't provide support for single-character or "char" input, it is possible to request the same deferral of timer-triggered events for single-character input. We must request char input with one of the following phrases (modified from the built-in Basic Screen Effects extension):

	wait for any key while deferring virtual timers;
	wait for the SPACE key while deferring virtual timers;
	let the character entered be the timer-safe chosen letter;
	
Section: Timer cycles and suppressing triggered effects

We can find out how many times a cyclic timer has fired by referring to the "cycles completed" of that timer, e.g.:

	anonymous timer: cycles completed of the triggered timer
	named timer: cycles completed of the countdown
	
We can also use the "cycles desired" property to find out how many cycles were specified for a "sunset" timer. An indefinitely cycling timer's cycles desired is 0.

Finally, we can prevent a timer's effect from triggering by writing a "timer exception rule". The timer exception rulebook has two possible outcomes. The default is to "allow timer event", while we can suppress the triggered effect using the "disallow timer event" outcome:

	A timer exception rule for the countdown:
		if a given condition holds:
			disallow timer event.

Note that the timer will consider itself to have completed a cycle even if the timer exception rules prevent the effect from firing (that is, the cycles completed property will be incremented). For a one-shot timer, there will simply be no effect; the timer will be deactivated.


Section: Pausing and restarting all timers

We can pause and restart all timers using the following phrases:

	pause virtualized timers;
	restart virtualized timers;
	
When paused, the timers will remain in a frozen state, and restarting them will cause them to start exactly as they were.

We can also ask:

	whether a virtual timer is ticking: true only if the timer is presently running
	whether timers are queued: true if there is a timer queued, even if timers currently happen to be paused

Section: Debugging

If we employ the "inline debugging" use option, we can get a detailed debugging log of timer behavior:

	Use inline debugging.

Because of the difficulties with printing text to the screen during timer events, the debugging log is printed only to the transcript. To avoid missing any of the log, we can start a new transcript at the beginning of play like so:

	First when play begins:
		try switching the story transcript on.
		
Alternatively, if we use the Glulx Debugging Console extension (requires Flexible Windows by Jon Ingold), the log will be printed to a subsidiary window rather than to the transcript. 



Example: *** Soggy Caverns - A short and quite unfair race to escape from a flooding cavern, in which a number of uses for virtual timers are demonstrated.

	*:  "Soggy Caverns"

	Include Basic Screen Effects by Emily Short.
	[Release along with an interpreter and a website. ]

	[Include Glulx Debugging Console by Erik Temple.
	Use inline debugging.]

	Include Glulx Real Time by Erik Temple.


	Section - Startup
		
	[First when play begins:
		say "This is a demonstration of most of the features of the Glulx Real Time extension.  Would you like to open the debugging console window now? ";
		[if the player consents:
			initiate console;]
		say "[line break]You can open and close the console window using these commands:[paragraph break]     OPEN G-CONSOLE[line break]     CLOSE G-CONSOLE[paragraph break][italic type]Press any key.[roman type]";
		wait for any key;
		clear the screen.]
		
The following rules, and particularly the teletype routine, demonstrate the use of the "wait...before continuing" phrase. We pause for a brief period after printing each letter of the title, mimicking the common (and unfortunately still popular) "typewriter effect". 

In the set up timers rule, we invoke three recurring events, each using a different interval. Every second, we increment the time elapsed variable, providing a real-time count of the time played. (Note that this is done using a "performative" text substitution, though we could equally have called a rule--the text substitution is briefer.) See the notes below for more information on the other two timers that are set up here.

	*: When play begins:
		repeat with lines running from 1 to 10:
			say "[line break]";
		teletype "   Soggy Caverns[line break]  %an unfair demo";[the % symbol is read as a change to roman type]
		wait 1000 milliseconds before continuing;
		say "[paragraph break][italic type]   Press any key.[roman type]";
		wait for any key;
		clear the screen.
		
	When play begins (this is the set up timers rule):
		now the right hand status line is "[timer-icon]";
		every 1 second say "[@ increment time elapsed]";[this is a quick perform phrase]
		every 6 seconds say an atmospheric effect;
		every 15 seconds follow the flooding rule.
		
	To teletype (text-to-be-printed - text):
		say "[bold type]";
		repeat with N running from 1 to the number of characters in the text-to-be-printed:
			if character number N in the text-to-be-printed is "[line break]":
				wait 400 milliseconds before continuing;
			if character number N in the text-to-be-printed is "[paragraph break]":
				wait 400 milliseconds before continuing;
			if character number N in the text-to-be-printed is "%":
				say "[roman type]";
				replace character number N in the text-to-be-printed with " ";
			say "[character number N in the text-to-be-printed][run paragraph on]";
			wait 50 milliseconds before continuing;
		say "[roman type]".
		
	After printing the banner text:
		say "[paragraph break]The caverns are filling rapidly with water. Can you find your way before you are swallowed up?[paragraph break]Be aware of the following:[line break]     * Every 15 seconds, the water will rise.[line break]     * You have just a few seconds to type each command.[line break]     * Watch for random atmospheric effects that will appear once in a while.[line break]     * Type SCORE to see how many seconds have elapsed."


	Section - Elapsed time

	Time elapsed is initially 0.

	Report requesting the score:
		say "Time elapsed: [time elapsed] seconds."

Next we set up a sunset timer that will begin each time the command prompt appears. If the player completes his command before this timer finishes all of its cycles, all is well. But if the timer reaches its final cycle, it prints an error message, possibly punishing the player by raising the water level in the caverns. The timer is then restarted, which we need to do because we have not rejected a command from the player--we have simply interrupted the input to print text and perform calculations.

The cycling timer also fills up a meter to allow the player to gauge his progress. Each tick of the timer, it prints to the status line a series of open or filled boxes. 

	*: Section - Command timeout

	Input-timer is a virtual timer.

	Before reading a command:
		every 1 second up to 6 times on the input-timer follow the input timer rule.
		
	This is the input timer rule:
		update the status line;
		if cycles completed of the input-timer is 6:
			say "[interrupt][one of]Watch yourself! You have only a few second to enter your command. If the line of pips in the upper right fills up, the water will rise immediately.[line break][line break][italic type]Press any key.[roman type][or][@ increment the current depth]You've been idle for too long! [bold type]The water level rises noticeably--it's [entry current depth of water depths]![roman type][line break][line break][italic type]Press any key.[roman type][stopping]";
			wait for any key while deferring virtual timers;
			say resume;
			every 1 second up to 6 times on the input-timer follow the input timer rule.
		
	To say timer-icon:
		let current stage be cycles completed of the input-timer;
		say "          ";
		repeat with index running from 2 to 5:
			if index > current stage:
				say "▫";
			otherwise:
				say "▪"
				
Every 6 seconds, we check to see whether we ought to print an atmospheric effect. Actually, we print the text each time, but via a substitution, the text itself regulates whether or not it will print any text. There is a 1 in 10 chance that an atmospheric message will be printed. Notice how we only interrupt and resume input when it is necessary to actually write text to the screen.
	
	*: Section - Atmospheric effects

	An atmospheric effect is initially "[if a random chance of 1 in 10 succeeds][interrupt][italic type][one of]You hear the sound of far-off rushing water[or]You wonder if you are alone down here.[or]Was that a screech?[or][slippage][or]Your ears strain to resolve what sound like weird whispers[stopping].[roman type][resume][else][run paragraph on][end if]".
				
	To say slippage:
		say "You slip [if the current depth > 1]and plunge into the frigid water. As if things weren't bad enough[end if]but recover yourself"
		
Finally, every 15 seconds, we increase the depth of water in the cave. The water depth is an integer between 0 and 6--once it reaches 6, the game is over.

	*: Section - Flooding

	The water depths are initially {"up to your ankles", "up to your knees", "up to your waist", "up to your armpits", "up to your neck", "above your head"}. The current depth is initially 0.
		
	This is the flooding rule:
		depth report occurs on the next turn.
		
	At the time when the depth report occurs:
		increment the current depth;
		say "[bold type]The water rapidly and mysteriously rises [entry current depth of water depths]![roman type][line break]";

	Every turn:
		if the current depth > 5, end the story saying "You have drowned".
		

	Section - Map

	The printed name of a room is usually "Cavern".

	The description of a room is usually "High walls of [one of]smooth[or]dimpled[or]phosphorescent[or]striated[or]water-streaked[or]orange-streaked[or]mica-flaked[or]milky[sticky random] [one of]flowstone[or]rock[or]stone[or]limestone[or]calcareous extrusions[or]white pillars[or]stalagmitic growths[sticky random]. [water situation][line break][exit list][run paragraph on]".

	To say water situation:
		if the current depth is 0:
			say "The floor is [one of]wet[or]mud-streaked[or]slick[or]glossy[at random] and [one of]scattered[or]littered[or]strewn[at random] with puddles.";
		otherwise if the current depth is less than 6:
			say "You are [if current depth is 1]sloshing[otherwise][one of]slogging[or]plowing[or]spashing[or]wading[purely at random] [end if] through water [entry current depth of water depths].";
		otherwise:
			say "[paragraph break]You struggle to get your nose and mouth above the surface of the water!"
		
	To say exit list:
		if current depth < 6:
			let place be location; 
			say "Exits: ";
			let dirs be a list of directions;
			repeat with way running through directions: 
				let place be the room way from the location; 
				if place is a room, add way to dirs;
			if dirs is not empty:
				say "[dirs].";
			otherwise:
				say "none."

	R01 is a room. R02 is north of R01. R03 is east of R01. R04 is north of R02 and northwest of R03. R05 is northeast of R02. R06 is north of R05. R07 is west of R06. R08 is southwest of R04 and northwest of R02. R09 is east of R06. R10 is northeast of R06. R11 is east of R10. R12 is southeast of R09. R13 is south of R12. R14 is northeast of R12. R14 is southeast of R11. R15 is up from R03. R16 is east of R15. R17 is north of R16. R18 is down from R17.

	After looking in R18 when current depth < 6:
			say "You feel a cool breath of air from the northeast."
		
	Exit is northeast of R18. Exit is outside from R18. The printed name of Exit is "Outside". "You emerge into sunlight." Southwest from Exit is nowhere. Inside from Exit is nowhere. After looking in Exit, end the story saying "You have won".


