Version 3/120428 of Glulx Input Loops (for Glulx only) by Erik Temple begins here.

[TO DO: Use unicode put_char instead of print (char).]
[TO DO: Make sure that the window-dependent works well...]
[TO DO: Documentation for line input features. Be sure to mention that it uses the same buffer as the player's command, so you need to cache the latter if you want to keep track of it.]


"Provides two types of input loop, primary and secondary, for more flexible use of multiple input sources. Also provides multiple entry points into and better tracking of input handling. Allows for easy handling of keystroke input."


Chapter - Inclusions

Include Flexible Windows by Jon Ingold.


Chapter - Use options

Use input loop debugging translates as (- Constant LOOP_DEBUG; -)

To #if utilizing input loop debugging:
	(- #ifdef LOOP_DEBUG; -)

To #end if:
	(- #endif; -)


Chapter - Definition of event types
[The g-event KOV translates directly to the evtype constants at the I6 level. Note that some of these event types must occur in a specific window, so we set up an adjective to allow us to refer to only this subset.]

A g-event is a kind of value. The g-events are timer-event, char-event, line-event, mouse-event, arrange-event, redraw-event, sound-notify-event, and hyperlink-event.

Definition: A g-event (called ev) is player-initiated if it is not timer-event and it is not sound-notify-event and it is not arrange-event and it is not redraw-event.

Definition: A g-event is nonstandard input if it is not line-event.

To decide which g-event is null-event: (- 0 -)


Chapter - Definition of input loop kind

An input-loop is a kind of thing. An input-loop is privately-named.

Loop-primacy is a kind of value. The loop-primacies are g-unspecified, g-primary and g-secondary.

An input-loop has a loop-primacy called the stored loop context.
An input-loop has a loop-primacy called the loop context.
An input-loop has a g-event called the focal event type. The focal event type is usually char-event.[The focal event type is the type of event that the event is intended to respond to. The loop will also be able to react to other events, but this is the primary input it is waiting on.]
An input-loop has a g-event called the handled event type. [The handled event type is the event type that the loop is currently handling, regardless of which is its focal type.]
An input-loop has a g-window called the focal window. The focal window is usually the main-window. [The focal window is the window that the event loop anticipates an event being associated with. The loop will be able to respond to loop in other windows, but this lets us know that it is primarily looking for events in this window.]


Section - Main input loop
[This input loop object stands in for the basic, library-provided VM_ReadKeyboard() routine. It cannot be directly invoked by the author--the Inform library is responsible for this--but can still be modified.]

main input is an input-loop. The focal event type is usually line-event. The stored loop context is always g-primary.


Section - Character input

character input is an input-loop. The focal event type is char-event.


Chapter - Global variables

The current child loop is an input-loop variable.
The delegate event handling to parent loop is a truth state variable.
The line event pending is a truth state variable.

The current input loop is an input-loop variable.[This should only be used with the special input loop rulebooks, and carefully even then.]
The current loop context is a loop-primacy variable.[This is set immediately before the input loop event-handling rules are called, so that they can accurately refer to the context. This is to be recommended over using the "current input loop" + "loop context"]


Chapter - Input loops

To decide whether a primary loop is in progress:
	if the reading a command activity is going on, decide yes;
	if the input looping activity is going on, decide yes.

Input looping something is an activity on objects.

To process/invoke/initiate (loop - an input-loop) loop/--:
	if loop is main input:
		say "***Warning: Attempted to invoke the 'main input' loop from source text. This is not allowed. While we can refer to and change the parameters of the main input loop, only the Inform library can specify when it is to run. The main input loop is the Inform 6 routine VM_ReadKeyboard(), and is intimately embedded in other library routines, so it would not make sense to invoke it separately.";
		rule fails;
	now the current input loop is the loop;
	if a primary loop is in progress:
		#if utilizing input loop debugging;
		if the stored loop context of the loop is g-primary, say "[line break]-->Note: The input loop [italic type][loop][roman type] is defined as a primary input loop, but it is being run as a secondary one. That is, it is being run while another input loop is already running. [currently running input loops][line break]";
		#end if;
		now loop context of loop is g-secondary;
	otherwise:
		#if utilizing input loop debugging;
		if the stored loop context of the loop is g-secondary, say "[line break]-->Note: The input loop [italic type][loop][roman type] is defined as a secondary input loop, but it is being run as a primary one. [currently running input loops][line break]";
		#end if;
		now loop context of loop is g-primary;
	#if utilizing input loop debugging;
	say "[line break]-->Starting the [italic type][loop][roman type] input loop as a [if loop context of loop is g-primary]primary[else]secondary[end if] loop.[line break]";
	#end if;
	begin the input looping activity with the loop;
	update the status line;
	if handling the input looping activity with the loop:
		let done be false;
		while done is false:
			follow the input loop setup rules for the focal event type of the loop;[input request, for example, can be put in the input loop setup rules.]
			if the focal event type of the loop is line-event:
				now line event pending is true;
			#if utilizing input loop debugging;
			say "-->Input requested ([italic type][loop][roman type]); focal event type of loop is [focal event type of loop].[line break]";
			#end if;
			wait for glk input;
			now the current loop context is the loop context of the loop;
			#if utilizing input loop debugging;
			say "-->Input received: [current glk event]; consulting the input loop event-handling rules.[line break]";
			#end if;
			follow the input loop event-handling rules for the current glk event;
			now the current input loop is the loop;[Just in case we've invoked another loop in the input loop event-handling rules, we need to register that we've returned to this loop again.]
			let don't handle event be false;
			if the rule succeeded and the loop context of the loop is g-secondary:
				now done is true;
				now the current child loop is loop;
				now delegate event handling to parent loop is true;
			otherwise:
				if rule succeeded:
					now done is true;
				if the outcome of the rulebook is the delay input handling outcome:
					now delegate event handling to parent loop is true;
					let don't handle event be true;
				if rule failed:
					let don't handle event be true;
			if loop context of loop is g-primary and don't handle event is false:[We run HandleGlkEvent from here only if the loop is primary]
				set JUMP POINT HandleGlkEvent;[a special jump point—the code will resume here if the JUMP TO line below is reached.]
				#if utilizing input loop debugging;
				if delegate event handling to parent loop is false, say "-->Consulting HandleGlkEvent from the primary loop [italic type][loop][roman type].[line break]";
				#end if;
				now delegate event handling to parent loop is false;
				let event-outcome be glk event handled in (focal event type of the loop) context;
				if delegate event handling to parent loop is true:[This will be true only for a secondary input loop that was run as the result of input that occurred during this loop's call to HandleGlkEvent.]
					#if utilizing input loop debugging;
					say "-->Consulting HandleGlkEvent from within the primary loop [italic type][loop][roman type] on behalf of the secondary loop [italic type][current child loop][roman type].[line break]";
					#end if;
					JUMP TO HandleGlkEvent;[Check HandleGlkEvent again, this time using the input from the secondary loop.]
				if event-outcome is 2:[HandleGlkEvent has decided that the player's input is to be replaced]
					now done is true;
				if event-outcome is -1[HandleGlkEvent has decided that the input loop should continue, regardless of having received valid input]:
					now done is false;[This will cancel any decision by the input loop event-handling rules that the loop should end.]
				if the focal event type of the loop is line-event and line event pending is false:
					follow the input loop setup rules for the focal event type of the loop;
					now line event pending is true;
	end the input looping activity with the loop;
	#if utilizing input loop debugging;
	say "-->End [italic type][loop][roman type] input loop ([if loop context of loop is g-primary]primary[else]secondary[end if]).[line break]";
	#end if.


Section - I7 phrase wrappers

To wait for glk input:
	(- glk_select(gg_event); -)
	
To decide which g-event is the current glk event:
	(- gg_event-->0 -)
	
To decide which number is the window of the current glk event:
	(- gg_event-->1 -)
	
To decide what number is the character/-- code/input returned:
	(- gg_event-->2 -)

To decide what number is glk event handled in (ev - a g-event) context:
	(- HandleGlkEvent(gg_event, {ev}, gg_arguments) -)

To set jump point HandleGlkEvent:
	(- .HGEContinue; -)
	
To jump to HandleGlkEvent:
	(- jump HGEContinue; -)

To decide whether the supplied window is the input window:
	repeat with item running through g-windows:
		if the ref-number of item is the window of the current glk event:
			decide yes.

To cancel pending line event in (win - a g-window):
	if line event pending is true:
		cancel line input in win, preserving keystrokes;
		say "[line break][run paragraph on]";[needed for Zoom—other terps insert line break automatically. This results in double breaks for other interpreters, but there doesn't seem to be any way around the problem.]
		now line event pending is false.

To update the status line:
	(- DrawStatusLine(); -)

To print prompt:
	(- PrintPrompt(); -)


Chapter - Input loop setup rules
[These rules are called just before we await input. They are the place where we can ensure that input is expected in our window of choice.]

The input loop setup rules are a g-event based rulebook.


Section - Input loop setup for char input

The keystroke-code is a number variable.
The keystroke is an indexed text variable.

The null char is a number variable. The null char is usually -2147483648.

Last input loop setup rule for a char-event when the focal event type of the current input loop is char-event (this is the basic char input setup rule):
	now keystroke-code is the null char;
	now keystroke is "";
	unless the type of the focal window of the current input loop is g-graphics:
		cancel pending line event in the focal window of the current input loop;
		request character input in the focal window of the current input loop;
	otherwise:
		say "***Warning: Attempted to get char input (input loop [italic type][current input loop][roman type]) in a graphics window ([italic type][the focal window of the current input loop][roman type])."


Section - Input loop setup for line input

Last input loop setup rule when the current input loop is main input (this is the suppress line input rule):
	if the focal event type of main input is not line-event:
		rule succeeds.


Chapter - Input loop event-handling rules
[These rules are run immediately after input is received. They are useful if we need to do something special before—or instead—of the regular event handling provided by HandleGlkEvent().]

The input loop event-handling rules are a g-event based rulebook.

The input loop event-handling rules have outcomes continue input loop processing (failure), stop input loop processing (success), and delay input handling (success).


Section - Arrange events

An input loop event-handling rule for an arrange-event (this is the update status line on arrange rule):
	update the status line.


Section - Redraw events

An input loop event-handling rule for a redraw-event (this is the update status line on redraw rule):
	update the status line.


Section - Handling for a char event

First input loop event-handling rule for a char-event when the focal event type of the current input loop is char-event (this is the basic char event handling rule):
	now keystroke-code is the character code returned;
	now keystroke is the keystroke-code resolved to an indexed text;
	#if utilizing input loop debugging;
	say "-->Keystroke ([the keystroke-code cleansed for printing]) received.[line break]";
	#end if;

First input loop event-handling rule when the focal event type of the current input loop is char-event (this is the char event null assignment rule):
	if the current glk event is not char-event:
		now keystroke-code is the null char;
		now keystroke is "";
		#if utilizing input loop debugging;
		say "-->Input other than char-event received. Assigning null char to keystroke-code variable.[line break]";
		#end if.

Last input loop event-handling rule for a char-event when the focal event type of the current input loop is char-event (this is the complete char event handling rule):
	stop input loop processing.

The char event null assignment rule is listed before the basic char event handling rule in the input loop event-handling rules.

To say (N - a number) cleansed for printing:
	if (N > 31 and N < 127) or (N > 160 and N < 384):[i.e., we have a standard keystroke and not an unprintable one]
		say "[N]: '[char-code (N)]'";
	otherwise:
		say "[N]".
		

Section - Phrases to convert character input to indexed text
	
To decide which indexed text is (N - a number) resolved to an/-- indexed text:
	if (N > 31 and N < 127) or (N > 160 and N < 384):[i.e., we have a standard keystroke and not an unprintable one]
		decide on "[char-code (N)]";
	otherwise:
		decide on "".
		
To say char-code (N - a number):
	(- print (char) {N}; -)

To wait for any key:
	now keystroke-code is the null char;
	while keystroke-code is the null char:
		process the character input loop.

To wait for the/-- SPACE key:
	now keystroke-code is the null char;
	while keystroke-code is not 13 and keystroke-code is not 31 and keystroke-code is not 32:
		process the character input loop.


Chapter - Line input

[The code provided here allows for us to create input loops based on line input other than the main input loop. This might be to ask a secondary question, e.g. JUMP. How high? 14 FEET, where the second response would likely not be passed through the normal action sequence (though it could be). Or we might use this facility to grab line input in a different window.]

Section - Line input definitions

The player's typed input is a snippet variable.


Section - Input setup rules for line input

Last input loop setup rule when the current input loop is not main input and the focal event type of the current input loop is line-event (this is the basic line input setup rule):
	unless the type of the focal window of the current input loop is g-graphics:
		cancel character input in the main-window;[just to be safe]
		request line input in the main-window;
	otherwise:
		say "***Warning: Attempted to get line input (input loop [italic type][current input loop][roman type]) in a graphics window ([italic type][the focal window of the current input loop][roman type])."

To request line input in (win - g-window):
(- glk_request_line_event({win}.ref_number, buffer+WORDSIZE, INPUT_BUFFER_LEN-WORDSIZE, 0); -)


Section - Input handling rules for line input

First input loop event-handling rule for a line-event when the current input loop is not main input and the focal event type of the current input loop is line-event (this is the basic line event handling rule):
	if the current glk event is line-event:
		now the player's typed input is the input line tokenized;
		#if utilizing input loop debugging;
		say "-->Line input tokenized: '[the player's typed input]'.[line break]";
		#end if;
		
First input loop event-handling rule for nonstandard input when the current input loop is not main input and the focal event type of the current input loop is line-event (this is the line event null assignment rule):
	replace the player's typed input with "";
	#if utilizing input loop debugging;
	say "-->Input other than line event received. The player's typed input variable has been set to null.[line break]";
	#end if.
	
Last input loop event-handling rule for a line-event when the current input loop is not main input and the focal event type of the current input loop is line-event (this is the complete line event handling rule):
	stop input loop processing.


Section - Slotting input into a variable
[Code to get a snippet or indexed text from line input. The code provided in GIL returns a snippet. However, if we replace "Section - Line input definitions" and provide the following, the player's input will be automatically provided as indexed text instead:

	The player's typed input is a snippet variable.]

To decide which indexed text is input line tokenized:
	let T be a snippet;
	let T be the input line tokenized;
	decide on "[T]".

To decide what snippet is input line tokenized:
	(- TokenizeAlternate() -).

Include (-
	[ TokenizeAlternate ;
		buffer-->0 = gg_event-->2;
		VM_Tokenise(buffer, parse);
		return 100 + WordCount();
	];
-) after "Glulx.i6t".


Chapter - Polling running activities
[Oddly, Inform doesn't provide an I7 phrase for checking whether an activity is running *with a given parameter*, though the template code does provide that functionality. This phrase wrapper provides us the ability to test this.]

To decide if (A - an activity on values) is running/going --/on with parameter/-- (O - a value) parameter/-- specified/--:
	(- TestActivity({A}, 0, {O}) -)

To say currently running input loops:
	let count be 1;[The count will be 1 more than the number of loops we have listed.]
	say "The following input loops are currently running:[line break]";
	if the reading a command activity is going on:
		say "   [count]. [italic type]Main input[roman type]: primary.";
		increase count by 1;
	repeat with loop running through input-loops:
		if the input looping activity is running with the loop specified:
			say "   [count]. [italic type][loop][roman type]: [if loop context of loop is g-primary]primary[else]secondary[end if].";
			increase count by 1;
	if count is 1, say "   No input loops are running.";
	if count > 3:[There are three or more input loops running.]
		say "[line break]***Warning: There are more than two input loops running simultaneously."



[Inform's "not for release" doesn't refer to the DEBUG constant, but that would actually be preferred—we may for example want to debug a blorb file, especially if we have a multimedia game, and this is made impossible by "not for release," which is controlled by I7 and works only when the Release button has been pressed in the IDE. The upshot is that we need to use a bifurcated means of including debugging code. By including the Extended Debugging extension, we can produce a blorb file (i.e., a "release" build) with the debugging command. Failing that, our debugging command will only be usable in the IDE.]
Chapter - Debugging command (for use with Extended Debugging by Erik Temple)
[The debug command itself is probably useless for most situations, since by the time it runs we will have exited both from the secondary loop where it was entered and from main input as well. Still, it is provided for completeness. The more effective route will be to deploy a simple say phrase from source code; that is, use the phrase 'say "[currently running input loops]"' at the appropriate point in your source code.]

Understand "loops" or "input loops" as a mistake ("[line break][currently running input loops]").


Chapter - Debugging command (for use without Extended Debugging by Erik Temple)


Section - Show currently running loops command (not for release)

Understand "loops" or "input loops" as a mistake ("[line break][currently running input loops]").


Chapter - New HandleGlkEvent routine

Glk input context is a g-event variable. [This is available as a hook for authors—it is filled with the focal event type of the loop in which input was received.]

To decide what number is the value returned by glk event handling:
	now glulx replacement command is "";
	follow the glulx input handling rules for the current glk event;
	if the outcome of the rulebook is the replace player input outcome:
		return input replacement;
	if the outcome of the rulebook is the require input loop to continue outcome:
		return input continuation;
	follow the command-counting rules;
	if the rule succeeded:
		follow the input-cancelling rules;
		follow the command-showing rules;
		follow the command-pasting rules;
		if the rule succeeded:
			return input replacement.


Section - Wrapper phrases for return values from HandleGlkEvent

To return input replacement:
	(- return 2; -)

To return input continuation:
	(- return -1; -)


Section - New HandleGlkEvent (in place of Section - HandleGlkEvent routine in Glulx Entry Points by Emily Short)

Include (- 

  [ HandleGlkEvent ev context abortres newcmd cmdlen  ;
      (+ glk input context +) = context;
      #ifdef LOOP_DEBUG;
          print "-->Handling glk event (", (PrintEvType) (+ current glk event +) ,") from the ";
                style underline; 
                print (PrintShortName) (+ current input loop +); style roman;
                print " input loop.^";
      #endif; ! LOOP_DEBUG
      return (+ value returned by glk event handling +) ;
  ];

-) before "Glulx.i6t".


Section - Use option
[Our new HandleGlkEvent has a somewhat more flexible approach to event handling than does Glulx Entry Points: Whereas the latter consults one of eight separate rulebooks depending on the event type, Glulx Input Loops passes the event type into a single parametrized rulebook. This means, for example, that we can have a general rule for event handling that fires no matter what the event, alongside the usual event-based rules.

By default, Glulx Input Loops passes event handling to Glulx Entry Points's rulebooks. This means that existing code will continue to work as before with GIL. However, we can also employ this use option to avoid that. This will be best for applications that don't use extensions that use the GEP rulebooks.]

Use direct event handling translates as (- Constant GLI_EVENTS; -).
	

Section - The glulx input handling rulebook

The glulx input handling rules are a g-event based rulebook. The glulx input handling rules have outcomes replace player input (success) and require input loop to continue (success).

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


Chapter - Library replacement

Include (- 

[ VM_KeyChar win nostat done res ix jx ch;
    #ifdef LOOP_DEBUG;
         print "***Warning: The I6 routine VM_KeyChar was called, providing an input loop intended for single-character input (char input). Be aware that VM_KeyChar is not controlled by Glulx Input Loops, and input handling options will not be as flexible. You can use the 'character input' input-loop for full support.^";
    #endif; ! LOOP_DEBUG
    jx = ch; ! squash compiler warnings
    if (win == 0) win = gg_mainwin;
   
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
    
    return res;
];

[ VM_KeyDelay tenths  key done ix;
    #ifdef LOOP_DEBUG;
         print "***Warning: The I6 routine VM_KeyDelay was called, providing a timer-expired input loop intended for single-character input (char input). Be aware that VM_KeyDelay is not controlled by Glulx Input Loops, and input handling options will not be as flexible.^";
    #endif; ! LOOP_DEBUG
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
    stored_buffer = a_buffer;
    #ifdef LOOP_DEBUG;
         print "^-->Starting the " ; style underline; print "main input"; style roman; 
         print " loop (primary).^";
     #endif;
    (+ current input loop +) = (+ main input +);
    done = false;
    
    while (~~done) {
        ! Request line event should only be called if delegate event handling to parent loop
        ! is false--we don't want to do a line event request when the HandleGlkEvent rules might print text etc.
        if ( ~~(+ delegate event handling to parent loop +) ) {
             if ( FollowRulebook( (+ input loop setup rules +), (+ focal event type of main input +) ) == false) {
               glk_request_line_event((+ focal window of current input loop +).ref_number, a_buffer+WORDSIZE, INPUT_BUFFER_LEN-WORDSIZE, 0);
               (+ line event pending +) = 1;
             }
         }
        if ( (+ delegate event handling to parent loop +) ) {
                #ifdef LOOP_DEBUG;
                     print "-->Skipping to HandleGlkEvent on behalf of previous primary loop.";
                #endif; ! LOOP_DEBUG
               (+ delegate event handling to parent loop +) = false;
                jump HGEContinue;
        }
        #ifdef LOOP_DEBUG;
             print "-->Input requested ("; style underline; print "main input"; style roman;
             print "); focal event type of loop is ",
             (PrintEvType) (+ main input +).(+ focal event type +) ,".^";
        #endif;
        glk_select(gg_event);
        (+ current loop context +) = (+ g-primary +);
	#ifdef LOOP_DEBUG;
	       print "-->Input received: ", (PrintEvType) gg_event-->0, "; consulting the input loop event-handling rules.^";
	#endif;
	if ( FollowRulebook( (+ input loop event-handling rules +), gg_event-->0 ) == false) {
             switch (gg_event-->0) {
                   3: ! evtype_LineInput
                       if (gg_event-->1 == (+ focal window of current input loop +).ref_number) {
                            a_buffer-->0 = gg_event-->2;
                            done = true;
                   }
             }
        }
       (+ current input loop +) = (+ main input +);!Just in case the author has invoked another input loop from the input loop event-handling rules, we need to register that we are again running in main input.
        .HGEContinue;
        !(+ delegate event handling to parent loop +) = false;
        #ifdef LOOP_DEBUG;
                   if ( ~~ (+ delegate event handling to parent loop +) ) {
                       print "-->Consulting HandleGlkEvent from the primary loop " ;
                       style underline; print "main input"; style roman; print ".^";
                   }
        #endif;
        (+ delegate event handling to parent loop +) = false;
        ix = HandleGlkEvent(gg_event, gg_event-->0, a_buffer);
        if ( (+ delegate event handling to parent loop +) ) {
             #ifdef LOOP_DEBUG;
                   print "-->Consulting HandleGlkEvent from within the primary loop " ;
                   style underline; print "main input "; style roman; 
                   print "on behalf of the secondary loop ";
                   style underline; print (PrintShortName) (+ current child loop +); style roman; 
                   print ".^";
             #endif; ! LOOP_DEBUG
	      print "jumping.";
             jump HGEContinue; !A secondary input loop is running within the primary loop; repeat HandleGlkEvent, this time with the event array from the secondary event.
        }
        if (ix == 2) done = true;
        else if (ix == -1) done = false;
        if ( (+ line event pending +) == 0 && (+ main input +).(+ focal event type +) == 3) { 
              !PrintPrompt();
              glk_request_line_event((+ focal window of current input loop +).ref_number, a_buffer+WORDSIZE, INPUT_BUFFER_LEN-WORDSIZE, 0);
              (+ line event pending +) = true;
        }
    }
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
    #ifdef LOOP_DEBUG;
         print "-->End the " ; style underline; print "main input"; style roman; 
         print " input loop (primary).^";
    #endif; ! LOOP_DEBUG
];

[ PrintEvType value;
    switch(value) {
        1: print "timer-event";
        2: print "char-event";
        3: print "line-event";
        4: print "mouse-event";
        5: print "arrange-event";
        6: print "redraw-event";
        7: print "sound-notify-event";
        8: print "hyperlink-event";
        default: print "<illegal g-event>";
    }
];

-) instead of "Keyboard Input" in "Glulx.i6t".

Include (- Global stored_buffer = 0 ; -) after "Definitions.i6t"

To cancel line input in (win - a g-window), preserving keystrokes:
    (- glk_cancel_line_event({win}.ref_number, gg_event); stored_buffer-->0 = gg_event-->2; -)

To re-request line input in (win - a g-window):
    (-  glk_request_line_event({win}.ref_number, stored_buffer + WORDSIZE, INPUT_BUFFER_LEN - WORDSIZE, stored_buffer-->0); -)


Glulx Input Loops ends here.


---- Documentation ----

Glulx Input Loops replaces Inform's main input loop with a more flexible framework, and also allows us to create our own named input loops. Input loops are handled in such a way as to minimize the possibility of input events nesting in situations where one event immediately triggers another (these will be an issue only when we are doing something really radical). Also alters the internal workings of Glulx Entry Points to provide somewhat more flexible event handling (existing code written for use with GEP should need no changes).

Glulx Input Loops requires Jon Ingold's Flexible Windows extension, and includes it automatically. However, an obscure bug in Inform sometimes causes problems if we do not also include Flexible Windows in our story text, before including Glulx Input Loops, like so:

	Include Flexible Windows by Jon Ingold.
	Include Glulx Input Loops by Erik Temple.

Glulx Input Loops does not require Emily Short's Basic Screen Effects, but is compatible with it. However, Glulx Input Loops must be included after the latter or some features to do with keypress input will not work properly, e.g.:

	Include Flexible Windows by Jon Ingold.
	Include Basic Screen Effects by Emily Short.
	Include Glulx Input Loops by Erik Temple.

Glulx Input Loops is not compatible with Text Window Input-Output Control. 


Section: Basics of input handling

Nearly all input--regardless of whether it is standard typed input, hyperlink input, or mouse input in a graphics window--occurs while Inform is waiting for "line input"; that is, for input at the command line prompt. Inform's standard library handles this input according to the following flow:

	1) Input is requested in the appropriate window (the main-window).
	2) Wait for input; the game is paused until an event is received.
	3) The library does very minimal handling of the input event.
	4) The event is then passed off to user event handling rules (the Glulx Entry Points extension provides a framework for handling these events).
	5) If the event results in usable input (a command), the loop is ended and the command is passed on to other routines for parsing.
	6) Otherwise, we return to step 1 and try again.

Glulx Input Loops follows this same basic outline, but adds new hooks for user customization at every point, as well as providing ways for input loops to "nest" inside of other input loops. There are a number of concepts and terms to be laid out first, but you can see the full event flow that Glulx Input Loops provides later on.

Input, and particularly Glulx input, is a complicated topic, and this short documentation has no aspirations to explain it fully. This extension is thus intended for intermediate to advanced authors. Those who need more information about Glulx and input handling generally will find these sites useful:

	http://www.iffydoemain.org/glkdunces/index.htm
	http://adamcadre.ac/gull/
	http://eblong.com/zarf/glulx/ 


Chapter: Creating input loops

Glulx Input Loops allows us to create any number of named input loops, defining them by the event they are primarily intended to handle, and if we like by the window we want it to seek input in (this will usually be the main-window, and if we don't provide a window that's what we will get by default). To declare an input loop, we simply write (note the hyphen in "input-loop"):

	Hyperlink input is an input-loop. The focal window is the main-window.


Section: Event types

We can also specify a "focal event type". This is the type of input event that the loop is primarily intended to handle; that is, the input type that the loop requests at the outset. It can be changed while the game is in progress. Here is the definition of hyperlink loop again, this time with the focal event specified:

	Hyperlink input is an input-loop. The focal event type is hyperlink-event.

Event types are specified using the "g-event" kind of value. The standard options are:

	line-event: Standard command line input, from a text-buffer or text-grid window.
	char-event: Keystroke input, from a text-buffer or text-grid window.
	hyperlink-event: Text hyperlink, from a text-buffer or text-grid window.
	mouse-event: Mouse input, from a graphics or text-grid window.

These are the input events, but it is also possible--though unlikely to be useful--to set up an input loop that waits for *any* kind of event. The remaining event types are these:

	arrange-event: The player has resized the window.
	redraw-event: The windows need to be resized thanks to some event such as the monitor resolution changing.
	timer-event: The timer has fired.
	sound-notify-event: A sound has stopped playing.


Section: The focal window

We can also specify a g-window for our input-loop using the "focal window" property. This is the window where input will be requested. Example:

	The focal window of hyperlink input is the links-window.

The default focal window for input-loops is the main-window, so we need not specify any window if the main-window is our target.


Chapter: Invoking an input loop

To invoke an input loop, we simply write "process [input-loop] loop" (alternately, "start" or "invoke" will also work):

	process hyperlink input loop

We will need to have defined rules for the "input loop setup" and "input loop event-handling" rulebooks for this loop to do anything really interesting, though Glulx Input Loops does provide relatively complete handling for char-event loops (see next section). 


Section: The character input loop

Glulx Input Loops defines the "character input" input-loop. This is intended to serve the purpose that Inform I6 library's VM_KeyChar routine handles--to get char input and return the key pressed. To require a keypress before continuing we can simply invoke the loop:

	process character input loop

If you want to know which key the player pressed, you can check these global variables, which are available once the input loop has completed:

	keystroke: an indexed text containing the letter pressed.
	keystroke-code: the numeric code (think ASCII) of the key pressed.

Note that the keystroke variable will only be filled if the key pressed is printable, defined as belonging to the printable ASCII or Latin Extended A character sets. If the player presses return, escape, an arrow key, or some other unprintable character, or if the player does some other input instead, such as resizing the window, then keystroke will be an empty string ("").

So, if we want to echo the player's input back immediately, something like this provides the basic outline:

	process the character input loop;
	say "You typed: [keystroke]."

Because by default *any* glk event, not just a keypress, will allow the input loop to complete, it will be convenient to use one or both of the keystroke variables to set up a control structure for our input processing. For example, here is how we might set up the situation where we want to wait for any key before continuing:

	now keystroke-code is the null char;
	while keystroke-code is the null char:
		process the character input loop.

The "null char" is a value that can be tested against the keystroke-code variable to indicate whether a key has been pressed. If the keystroke-code variable is equal to the null char after processing a char-event input loop, it is certain that the player entered some input other than a keypress (such as resizing the window). So, this code uses a "while" loop to check whether a key has been pressed; as long as keystroke-code is the null char, no key has been pressed.

It is common enough to want to wait for a key that this code block can be invoked with a single phrase:

	wait for any key 

(This replaces the "wait for any key" behavior as defined by Basic Screen Effects.)

If we want to know what key the player pressed, we can simply check the keystroke and/or keystroke-code variable:

	wait for any key;
	if keystroke is "r" or keystroke is "R":
		try restoring the game.

The Basic Screen Effects extension offers a phrase to allow the game to wait for the space or return key. Glulx Input Loops does the same; use

	wait for the space key

This replaces the Basic Screen Effects implementation, and will pause the game until either the space or return key is pressed.

By default, any user-defined input loop with the focal event type "char-event" will act in the same way as does the pre-defined character input loop. This behavior is defined by three rules in the input loop event-handling rulebook (see below). These three rules are:

	"char event null assignment rule" - assigns the null char for any event other than a keypress;
	"basic char event handling rule" - assigns the keypress to the keystroke and keystroke-code variables;
	"complete char event handling rule" - runs at the end of the rulebook and stops the input loop, provided that a key was pressed.


Section: The main input loop

In addition to creating our own loops, we can also specify much of the behavior of Inform's main input loop (both the focal event type and the focal window, in fact). However, we cannot invoke the main input loop ourselves. This is because the main input loop is actually the I6 routine VM_ReadKeyboard, and is intimately embedded with other library routines (see the template layer documentation for more information).

The main input loop in Inform accepts standard typed input--"line input" in Glulx parlance. We can, however, change that simply by specifying the "focal event type" of main input:

	The focal event type of main input is hyperlink-event.

The main input loop will now be considered to be looking primarily for hyperlink input; line input will not be requested. Note that we are responsible for requesting input for these loops. To continue the hyperlink example, if we are using the hyperlink functionality built into Flexible Windows (or using certain other extensions, such as Inline Hyperlinks or Basic Hyperlinks), hyperlink input will be requested automatically by those extensions and we need not worry about it. If we are in a situation where we need to request input ourselves during the input loop, we can do so in the "input loop setup" rulebook; see below.

The main input loop should result in text being entered as the player's command. We can do this in the "input loop event-handling" rulebook, which runs immediately after input is received, or in HandleGlkEvent, the I6 routine that is hooked into by the Glulx Entry Points extension. See below for more on this, as Glulx Input Loops provides a somewhat more flexible I7 implementation of HandleGlkEvent that allows any event to produce a command. The "No Typing Allowed" example replaces the standard line input with hyperlink input.


Chapter: Input loop rulebooks

There are two rulebooks that are called from within the flow of an input loop. These are the "input loop setup" and "input loop event-handling" rulebooks.


Section: The input loop setup rulebook

The input loop setup rules are invoked at the beginning of the input loop, just before we put the game on hold while we wait for input. The most obvious thing to do here is to request a particular type of input, if necessary; the input event requested should be the focal event type of the input loop. Note that a Glulx input "request" merely prepares a window to receive a certain type of input; it is not the same as what this documentation calls "waiting for input," when the game is paused while waiting for the player to do something. Glulx input requests are for the most part not mutually exclusive--you can have hyperlink input pending in the same window that line input is pending, for example. (However, character input and line input *are* mutually exclusive. It is illegal to have these two types active at the same time.)

If we need to reset any global variables that we are using in our input loop, the input loop setup rules are also a good place to do that.

The input loop setup rules are a g-event rulebook, meaning that we can specify what focal event type they are associated with:

	An input loop setup rule for a char-event:

This input loop setup rule will fire for any input loop whose focal event type is char-event, which works well and allows us to write generic code for all of our char-input loops. However, we may also want to include code that's specific to a certain loop. We can use the "current input loop" variable to specify a given loop:

	An input loop setup rule when the current input loop is character input:
	An input loop setup rule for a char-event when the current input loop is character input:

Glulx Input Loops includes two input loop setup rules. The first is the "basic char input setup rule", which cancels line input and requests character input in the focal window of the current loop. This is usually something we will want for any character input loop, but it can of course be modified by delisting or replacing the rule.

The other input loop setup rule supplied by Glulx Input Loops in the "suppress line input rule". This is run only for the main input loop, and all it does is suppress the main input loop's line input request if the focal event type of the main input loop has been set to something other than line input.


Section: The input loop event-handling rulebook

The input loop event-handling rulebook is called immediately after an event is actually received. This event could be either input from the player, or one of the non-input events (such as a timer event or a sound notification event).

The input loop event-handling rules replace the library (as opposed to the author-provided) phase of event-handling as described in step 3 of the flow described in the "Basics of Input Handling" section above. They can be used for preliminary input handling (for example, to set variables that we will later handle using the rulebooks provided by Glulx Entry Points), or they can be used for complete input handling. This will more often than not be a matter of style, but one rule of thumb might be:

	Use the input loop event-handling rules for behavior that pertains only to a certain input loop, while using the Glulx Entry Points rulebooks for behavior that would apply regardless of the loop.

It is also possible for the input loop event-handling rules to decide that the Glulx Entry Points rulebooks should be skipped, so keep that in mind as well; this is done using a named rulebook outcome.

There are three named outcomes that we may use in the input loop-event handling rulebook that can help to direct the flow of events. These are:

	continue input loop processing (failure)
	stop input loop processing (success)
	delay input handling (success)

Each of these does something different. See the discussion below for more information.

The input loop event-handling rules are, like the input loop setup rules, a g-event based rulebook, but the g-event specified is not the focal event type of the input loop. Instead, the input-handling rule preamble refers to the actual event that was received. To handle a hyperlink event, for example, we can do these types of things:

	An input loop event-handling rule for a hyperlink-event:
	An input loop event-handling rule for a hyperlink-event when the current input loop is character input:

Should we need to know what the last received event was outside of the input loop event-handling rules, we can test--but not assign--it using the "current glk event", e.g. "if the current glk event is char-event".

Glulx Input Loops provides three input loop event-handling rules. The first two of these redraw the status line immediately when the window is resized, whether by the player's explicit command (arrange-event), or due to some other factor, such as the monitor resolution being changed (redraw-event). These rules are:

	update status line on arrange rule
	update status line on redraw rule

There is also a rule that fires when character input is received, but only when the focal event type of the input loop is character-event. All that this rule does is issue the "stop input loop processing" rulebook outcome, to ensure that the event completes the loop. This is the

	basic char event handling rule


Chapter: Primary and secondary input loops

Usually in Inform games, there is only one input loop in process at a time: We are either getting a typed command from the player, or we are waiting for a keypress before continuing. However, if we want to create a nonstandard interface, we may find that we want to run one input loop from within another. For example, we may want to build up commands from multiple character, hyperlink, or mouse inputs (see the "Under Doom" example below). Or we may want to imitate text input in a graphics window using a combination of mouse input to select text fields and character input with which to enter text in those fields (see the "Glimmr Form Fields" extension). If we try to do this kind of things with Inform's standard input loops, we will find it difficult to control our event flow, because the two loops don't offer many control structures.

To better accommodate this kind of interaction, Glulx Input Loops introduces a new concept: primary vs. secondary loops. A secondary loop is one that runs while a primary loop is already running, and a primary loop is simply a loop that begins while no other loop is running. The main input loop is always a primary loop, as is a loop that is begun before or after that loop runs. For example, an input loop (call it A) that is invoked from within an action will be a primary loop because the action rules are called only after the main input loop has completed. However, an input loop invoked during loop A would be a secondary loop. We should not try to invoke a loop from within a secondary loop. Instead, use the primary loop to call secondary loops as needed in succession (i.e., use the primary loop as a control structure).

Note that whether a loop is primary or secondary is not determined in advance by the author; that is, we do not define a loop's status. Instead, Glulx Input Loops identifies a loop as secondary any time it is running while another loop is in effect. Again, the main input loop is always primary.

When a loop is running in secondary context, its behavior is somewhat different from a primary loop. The major difference is that secondary loops call only the input loop event-handling rulebook; they do not call the HandleGlkEvent rules (that is, the Glulx Entry Points rulebooks). Instead, by default, they defer event handling until the author's flow of instructions returns to the "parent" loop (usually after the rulebook that called the secondary loop is completed).

We can test whether the current loop is running in primary or secondary context using the "loop context" property of input-loops; this property is automatically set to "g-primary" or "g-secondary" as needed (we should not set it directly!). Example:

	if the loop context of the current loop is g-primary

For the input loop event-handling and Glulx Entry Points rulebooks (and any rulebook called by these), it will be better to refer to the "current loop context", a global variable that is updated to track which loop's events we are handling in the currently running instance of the event-handling rules:

	if the current loop context is g-secondary

In the input loop event-handling and Glulx Entry Points rulebooks, we can also refer to the "current child loop", which will tell us what loop we are handling input for.

	if the current loop context is g-secondary:
		if the current child loop is hyperlink input:
			...do something specific to the hyperlink input loop...


Chapter: Modifications to Glulx Entry Points (the glulx input handling rules)

The Glulx Entry Points extension, which is a built-in extension and required by Glulx Input Loops to operate, provides hooks for authors to write event-handling rules for any type of glk event, whether player-generated (e.g., line input, hyperlink input) or not (e.g., timer, sound notification). After the initial (and minimal) library handling of an event, Inform passes the event type to the I6 function HandleGlkEvent stage. Glulx Entry Points then routes this to one of eight named rulebooks, one rulebook for each type of event. For example:

	Glulx timed activity rules (timer-event)
	Glulx line input rules (line-event)
	Glulx character input rules (char-event)
	Glulx hyperlink rules (hyperlink-event)

For two of these rulebooks--the hyperlink and mouse input rules--Glulx Entry Points allows the author to specify a "glulx replacement command" (indexed text variable), which if given a value will replace the player's command with the text given, as well as print it to the command line. This allows the player to, for example, use hyperlinks to issue commands.

Glulx Input Loops modifies the Glulx Entry Points approach in two ways:

First, Glulx Input Loops uses one single rulebook to rule them all--all types of glk events, that is. This approach allows a bit more breathing room for authors, and allows most of the structural logic that Glulx Entry Points implements using I6 code to be recast in I7 for easier accessibility. When HandleGlkEvent receives (from an input loop) the instruction to handle an event , Glulx Input Loops passes the event type, as a g-event value, to the "glulx input handling rules", a g-event parametrized rulebook. Hence, the author can write such instructions as:

	A glulx input handling rule: <do something>
	A glulx input handling rule for a char-event: <do something>

To avoid breaking existing code, the specific event rules in the rulebook call the corresponding rulebooks from Glulx Entry Points by default. We can override this globally by activating the "direct event handling" use option, or situationally using standard rulebook approaches. An example of one of the default rules:

	Last glulx input handling rule for a hyperlink-event when the direct event handling option is not active (this is the redirect to GEP hyperlink rule):
		abide by the glulx hyperlink rules. <--this is the rulebook provided by Glulx Entry Points

The second main modification to Glulx Entry Points's functioning is that, in Glulx Input Loops, *any* event type can (in principle) replace the player's command. There are two ways to make this happen. First, the manual option: If (and only if) we are using the glulx input rules, we can set the player's command directly (e.g., "change the text of the player's command to 'Arggh!'"), then end the rule with the "replace player input" rulebook outcome. This option is not available from the rulebooks created by Glulx Entry Points (e.g., the glulx hyperlink rules), because they do not have the necessary rulebook outcomes. Note that, if we want the replacement command to be printed to the command line as well, we will need to do this ourselves, with code something like this:

	say "[input-style-for-glulx]<replacement text>[roman type]"

The other option, the automated option, is available from either the glulx input handling rules or the Glulx Entry Points rulebook, is to simply set the "glulx replacement command" variable to the text we want for the player's command. The replacement text will automatically be printed to the command line as well as substituted for the player's command. To use this option, we must *not* end the glulx input handling rules with "replace player input", as doing so will skip the automated command replacement.

There is in fact a third modification, but it is not expected to be particularly useful. The I6 Inform library includes the ability for HandleGlkEvent to instruct the input loop that calls it to continue as if the player entered no input at all. Glulx Entry Points does not provide for this, but we can do it in Glulx Input Loops by ending a glulx input handling rule with the "require input loop to continue" outcome.


Chapter: Event loop flow

Now that we have identified all of the appropriate terms, here is the full flow for a primary loop:

	1. Follow the before rules for the input looping activity (hook for authors).
	2. Update the status line.
	3. Follow the input loop setup rules for the focal event type of the loop.
	4. Wait for input.
	5. Follow the input loop event-handling rules for the glk event received. If the outcome is:
		a. success/stop input loop processing: go to step 6.
		b. failure/continue input loop processing: go to step 3.
		c. delay input handling (success): go to step 3.
	6. Follow the Glulx Entry Points (glulx input handling) rulebook for the received event. If the outcome is:
		a. success/failure/no decision: go to step 7.
		b. replace player input: the player's input is replaced with the glulx replacement command (see Glulx Entry Points); go to step 7.
		c. require input loop to continue: go to step 3.
	7. If the focal event type of the loop is line event and we have interrupted line input, restart it now.
	8. Follow the after rules for the input looping activity (hook for authors).
	9. (Loop ends)

And here is the flow for a secondary loop:

	1. Follow the before rules for the input looping activity (hook for authors).
	2. Update the status line.
	3. Follow the input loop setup rules for the focal event type of the loop.
	4. Wait for input.
	5. Follow the input loop event-handling rules for the glk event received. If the outcome is:
		a. success/stop input loop processing: go to step 6.
		b. failure/continue input loop processing: go to step 3.
		c. delay input handling: go to step 6.
	6. Follow the after rules for the input looping activity (hook for authors).
	7. (Loop ends)
		a. If the input loop event-handling rules ended in success, the Glulx Entry Points (glulx input handling) rulebook in the parent loop will fire for the event processed.
	
The examples below, particularly "Under Doom," illustrate some of the ways in which we can use both types of loop. The Glimmr Form Fields extension also makes extensive use of Glulx Input Loops.


Chapter: Debugging

A special debugging option is provided that will trace the progress of input loops for us. To use this option, activate the use option:

	Use input loop debugging.

This will print debugging statements, set off by a --> symbol, at each stage of your input loops, including the main input loop. 

A debugging command is also provided; type LOOPS or INPUT LOOPS at the command prompt to see a summary of the currently running input loops. Unfortunately, this debug command is probably useless for most situations, since by the time it runs we will have exited from the main input loop, and very likely from any other input loop as well. Still, it is provided for completeness. The more effective route will be to deploy this say phrase from source code:

	say "[currently running input loops]"

This will provide the same type of output as the command, but triggered from your source code at the exact moment when you need it.


Section: Change Log

Version 3: Added support for line input in loops other than the main input loop. Fixed minor bugs with identifying classes of event.

Version 2: Extended "focal window" capability to main input loop in ReadKeyboard(); in other words, we can now get standard line input in alternate windows by setting the focal window of the input loop.

Version 1: Initial release.


Example: * Any Key to Continue - In this example, we use the character input loop to require the player to press a key to begin playing; we also echo the key pressed. 

Note that the character input loop is here running as a primary input-loop, because it is carried out before the first input prompt.

	*: "Any Key to Continue"
	
	Include Glulx Input Loops by Erik Temple.
	
	Anticipation is a room. "This game is bound to be awesome."
	
	When play begins:
		say "Press any key to start playing this great game.";
		wait for any key;
		say "You pressed '[keystroke]'.";
		if keystroke is "i", say "[line break]How did you know that 'i' was my favorite key?! Oh well, let's get on with playing this pile of awesome!"

Example: * Secondary Typed Input - Glulx Input Loops includes support for getting line input from loops other than the main input loop. In this example, we show how to run a secondary input loop to ask the player a question in response to a command. The secondary input is not parsed. Instead, we look for keywords in the input--only if the player's bragging includes egocentric language will his bragging be effective.

Note that the code below shows how to translate the snippet containing the player's typed input from the secondary loop into indexed text for processing. This isn't strictly necessary for this example--we could just as easily ask whether the snippet matches text or regular expression. However, it's useful to illustrate the conversion into indexed text.

	*: Include Glulx Input Loops by Erik Temple.
	
	Secondary input is an input-loop. The focal event type is line-event.
	
	Bombast Chamber is a room. "Here you may BRAG."
	
	Bragging is an action applying to nothing. Understand "brag" as bragging.
	
	Instead of bragging:
		say "Of what great feat do you wish to tell?[line break]>>[run paragraph on]";
		process secondary input;
		let the player's input be an indexed text;
		let the player's input be "[the player's typed input]";
		if the player's input is "":
			say "You decide not to speak.";
			stop the action;
		if the player's input matches the regular expression "(\bi\b|\bmy\b|\bme\b|\bmine\b)", case insensitively:
			say "Plaudits resound!";
			stop the action;
		otherwise:
			say "Your story lacks verve. Try again.";
			try bragging.


Example: * No Typing Allowed - This simple example illustrates how to alter the main input loop to accept hyperlink input in lieu of line input. The hyperlink input requests and command replacement are handled automatically by the Inline Hyperlinks extension, so there is no need to use the input loop setup rules (see above).

	*: "No Typing Allowed"

	Include Glulx Input Loops by Erik Temple.
	Include Inline Hyperlinks by Erik Temple.

	The Green Room is a room. "You can [link]go south[end link]."
	
	The Stage is south of the Green Room. "You can [link]go north[end link]."
	
	The focal event type of main input is hyperlink-event.


Example: *** Under Doom - The primary intention of this example is to demonstrate the use of a secondary input loop (running within the main input loop). It also shows how to reconfigure the main input loop to use character (single-keystroke) input rather than the default line input, how to use the input loop setup rules, and how to create and use new input loops. 

The example completely alters the method by which commands are entered into the game. Instead of typing out our commands, we simply enter a single key for the verb: the entire verb word will appear on the command line as if we had typed it. If the command also requires a noun, we enter a secondary loop (we use the "character input" input-loop object for this purpose), where we can hit another keystroke to indicate the noun and complete the command. The available verbs are displayed in a commands window off to the right so that we know what keys to enter (this window switches to display the nouns when we enter the secondary loop).

The commands are processed by Inform's parser as normal, so this example really only alters input--everything else about the "game" follows standard conventions. Of course, since we are limited to verb or verb + noun input, the resulting game is considerably less capable than Inform's parser. We could, though, relatively easily expand the input scheme to allow for more complex input.

If you want to see exactly how the input loops interact, activate the input loop debugging use option (paste link at bottom of example; note that all of the preceding paste blocks need to be added to your code in order to compile the example.)

	*: "Under Doom" by Erik Temple
	
	[Use input loop debugging.]
	
	Section - Inclusions
	
	Include Flexible Windows by Jon Ingold.
	Include Basic Screen Effects by Emily Short.
	Include Glulx Input Loops by Erik Temple.
	
	Section - The commands window
	
	The commands-window is a text-buffer g-window spawned by the main-window. The position is g-placeright. The measurement is 25. 

	Section - Introduction
	
	When play begins:
		try getting help;
		say "[line break]Press any key.";
		wait for any key;
		clear the screen;
		open up the commands-window.

Here we reassign the focal event type of the main input loop object, so that it handles character input instead of line input. We also use the input loop setup rule as a convenient hook on which to hang the commands window refresh, since we know it will be called every time we're ready for input. (Another perfectly good hook would be in "before handling the input looping activity with main input" activity.)
	
	*: Section - Main input loop setup
	
	The focal event type of main input is char-event.
	
	An input loop setup rule for a char-event when the current input loop is main input:
		now key-verb is "Commands";
		display the Table of Keystroke Commands in the commands-window;
		say "[run paragraph on]".


In this section, we actually handle all of the main input. After declaring a few global variables to hold the player's input and the verb word it translates to, we define the main input-handling rule for the main input loop (this is the "main char input handling rule"). This rule compares the character input to the Table of Keystroke Commands. If the player's (case-sensitive) keypress is found in the table, the player's command is changed to the corresponding verb word(s), which are also printed to the command line. If the "stage" entry in the table contains a 0, this indicates that the command is complete in itself and we stop input processing to parse the command.

Otherwise, we need to get a noun from the player to complete the command. A table of nouns (the Table of Visible Objects) is constructed, including all objects in scope, and this table is then displayed in the commands window to prompt the player for a second input. We then invoke the "second phrase input" loop, which will run as a secondary loop and accept the keypress input for the noun part of the command. From the event-handling rule in this loop, we check the Table of Visible Objects (again, built dynamically) instead of the Table of Keystroke Commands, but the basic process is the same.

One thing of note in this "secondary char input handling rule" is the test for a character code returned of -8; this code results from pressing the Escape (ESC) key. If the player presses ESC, we abort the command, setting a truth state variable ("secondary input escaped") that will serve to inform the main char input handling rule that input in the secondary input loop was aborted. 

	*: Section - Handling core input
	
	The key-verb is an indexed text variable.
	
	Secondary input escaped is a truth state variable.
	
	First glulx input handling rule for a char-event:
		unless the number of characters in the player's command is 0:
			replace player input.
	
	An input loop event-handling rule for a char-event when the current input loop is main input (this is the main char input handling rule):
		change the text of the player's command to "";
		if there is a key of keystroke in the Table of Keystroke Commands:
			choose row with key of keystroke in the Table of Keystroke Commands;
			if stage entry is 0:
				say "[input-style-for-glulx][command entry][roman type]";
				change the text of the player's command to "[command entry]";
				stop input loop processing;
			otherwise:
				say "[input-style-for-glulx][command entry][roman type] [run paragraph on]";
				now the key-verb is command entry;
				create table of local objects;
				display the Table of Visible Objects in commands-window;
				process second phrase input loop;
				if secondary input escaped is true:
					now secondary input escaped is false;
					continue input loop processing;
				otherwise:
					stop input loop processing;
		otherwise:
			continue input loop processing.

	Second phrase input is an input-loop. The focal event type is char-event.
	
	Input loop event-handling rule for a char-event when the current input loop is second phrase input (this is the secondary char input handling rule):
		now secondary input escaped is false;
		if keystroke-code is -8:
			cancel the command;
			stop input loop processing;
		if keystroke-code is the null char, continue input loop processing;
		repeat through Table of Visible Objects:
			if key entry is keystroke:
				say "[input-style-for-glulx][command entry][roman type]";
				change the text of the player's command to "[key-verb] [command entry]";
				stop input loop processing;
		continue input loop processing.

	To cancel the command:
		say "[line break]--Action canceled.[paragraph break][command prompt][run paragraph on]";
		now secondary input escaped is true.


The cancel secondary input on alternate input rule isn't really necessary for this example, but if our game had alternate sources of input or other events--such as hyperlinks or timed events--then we would need to define behavior for those events during the special secondary loop. This rule shows how to halt the noun input when an event other than a keypress is received. (Note that we do nothing for an arrange or redraw event, neither of which have any direct impact on gameplay.)

	*: First input loop event-handling when the current input loop is second phrase input and the current glk event is not char-event (this is the cancel secondary input on alternate input rule):
		unless the current glk event is arrange-event or current glk event is redraw-event:
			cancel the command;
			stop input loop processing;
	
	Section - Verb ("command") input
	
	Table of Keystroke Commands
	key (indexed text)	command (indexed text)	stage
	"x"	"more about"	1
	"l"	"look"	0
	"t"	"take"	1
	"D"	"drop"	1
	"W"	"wear"	1
	"n"	"go north"	0
	"e"	"go east"	0
	"w"	"go west"	0
	"s"	"go south"	0
	"u"	"go up"	0
	"d"	"go down"	0
	"i"	"take inventory"	0
	"h"	"help"	0
	"q"	"quit"	0
	
	Section - Create list of objects for noun input
	
	To create table of local objects:
		blank out the whole of the Table of Visible Objects;
		let count be 1;
		repeat with item running through things:
			if the player can see the item:
				choose a blank row in the Table of Visible Objects;
				now the key entry is "[char-code (count + 47)]";
				if item is yourself:
					now the command entry is "myself";
				otherwise:
					now the command entry is "[the item]";
				increase count by 1;
		choose a blank row in the Table of Visible Objects;
		now the key entry is "ESC";
		now the command entry is "Cancel".
	
	Table of Visible Objects
	key (indexed text)	command (indexed text)
	--	--
	with 40 blank rows
	
	To display (T - a table name) in (win - a g-window):
		let max be the number of filled rows in T;
		let count be 1;
		move focus to commands-window, clearing the window;
		say "[bold type][key-verb]:[roman type][line break]";
		repeat through T:
			say "[key entry] - [command entry][line break]";
			increase count by 1;
		return to main screen.


We implement the yes-no clarification for quitting the game using the "character input" input-loop. Rather than use the "wait for any key" phrase, however, we check the result of the input loop and take action only if the keypress is "y/Y" or "n/N". In a real game, we'd probably want to write the yes-no logic as reusable code, but this will do for the example.
	
	*: Section - Handling Quitters
	
	Carry out quitting the game:
		say "Are you sure you want to quit?";
		move focus to commands-window, clearing the window;
		say "[bold type]Quit?[roman type][line break]y - quit[line break]n - continue playing";
		return to main screen;
		now keystroke is "";
		while keystroke is not "y" and keystroke is not "Y" and keystroke is not "n" and keystroke is not "N":
			process the character input loop;
			if keystroke is "Y" or keystroke is "y":
				say "[input-style-for-glulx][keystroke][roman type][paragraph break]Exiting...";
				shut down the commands-window;
				abide by the immediately quit rule;
			if keystroke is "N" or keystroke is "n":
				say "[input-style-for-glulx][keystroke][roman type][line break]";
				rule succeeds.
	
	Section - Commands
	
	Getting help is an action out of world applying to nothing. Understand "help" as getting help.
	
	Carry out getting help:
		say "This example uses the Glulx Input Loops extension to provide a keystroke interface rather than the standard text input. Type single characters to fill in words and phrases. The commands available at any given time, along with the keystrokes needed to invoke them, can be found in the window at the right."
	
	Understand "more about [something]" as examining.
	
	Section - "Scenario"
	
	Tunnel is a room. "The tunnel slopes down to the west, farther into the mountain. A reddish glow stains the bottom, and the air shimmers with the heat."
	
	Instead of going east in Tunnel:
		say "Turn back now? No."
	
	Instead of going down in the Tunnel:
		try going west.
	
	The ring is a wearable thing in the Tunnel. The description of the ring is "A simple gold ring."
	
	Instead of wearing the ring:
		say "No, you won't wear it; it drove him insane. All you need is to drop it into the flames at the heart of the mountain."
	
	At the Edge is west of the Tunnel. "The tunnel opens onto a wide ledge. Surrounding the ledge is a lake of fire, the heart of the volcano."
	
	Report dropping the ring in the Edge:
		say "You pitch the ring into the heaving pool of lava. A spark and a hiss, then an explosive concussion that shakes the very walls.[paragraph break]*** You have destroyed it ***";
		say "[paragraph break]Exiting...";
		shut down the commands-window;
		abide by the immediately quit rule;
	
	The description of yourself is "Tired, hungry, in need of a warm meal and a cold tankard."
	

This last paste block is optional. Include it if you want to see a blow-by-blow of the input loop flow.
	
	*: Use input loop debugging.
	

