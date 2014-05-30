Version 1/100607 of Real-Time Delays (for Glulx only) by Erik Temple begins here.

"Allows the author to specify a delay of a given number of seconds/milliseconds before continuing the action."

Section - Dependencies

Include Glulx Entry Points by Emily Short.


Section - Declare waiting flag

The waiting flag is a truth state that varies. The waiting flag variable translates into I6 as "wait_flag".

Include (-

Global wait_flag = 0;

-) before "Glulx.i6t".


Section - Basic rules and phrases

To wait (T - a number) millisecond/milliseconds/ms before continuing, strictly:
	if glulx timekeeping is supported:
		now the waiting flag is true;
		start a T millisecond timer;
		if strictly:
			wait strictly for the timer flag;
		otherwise:
			wait for the timer flag.

A glulx timed activity rule (this is the redirect from timer rule):
	now the waiting flag is false;
	stop the timer.
	
To start a/-- (T - a number) millisecond timer:
	(- if (glk_gestalt(gestalt_Timer, 0)) glk_request_timer_events({T});  -)
	
To stop the/-- timer:
	(- if (glk_gestalt(gestalt_Timer, 0)) glk_request_timer_events(0); -)
	
To wait strictly for the timer flag:
	(- EscDelay(); -)

To wait for the timer flag:
	(- WaitDelay(); -)


Section - I6 Delay routines

Include (-

[ EscDelay key ix;
	while (wait_flag) {
		glk_select(gg_event); 
		ix = HandleGlkEvent(gg_event, 0, gg_arguments);
	}
];

[ WaitDelay key ix;
	glk_request_char_event(gg_mainwin);
	while (wait_flag) {
		glk_select(gg_event); 
		ix = HandleGlkEvent(gg_event, 1, gg_arguments); 
		if (ix >= 0 && gg_event-->0 == 2) { 
			key = gg_event-->2;
			if ((key == $fffffff8) || (key == -6) || (key == 3) || (key == 32)) {
				wait_flag = 0;
			}
		} 
	}
	glk_cancel_char_event(gg_mainwin);  
];

-)


Real-Time Delays ends here.


---- Documentation ----

Real-Time Delays allows an author to request a delay of a given number of seconds. This delay occurs immediately, and no input or output can occur until the specified time has elapsed. It requires both Glulx Entry Points (built in) and Michael Callaghan's Fixed Point Maths extension.

The use of the extension is quite simple. The length of the delay is specified in milliseconds, e.g. 1000 represents one second. We may write a phrase such as

	wait 1450 milliseconds before continuing
	wait 14500 ms before continuing

at virtually any point in our source code. The delay is triggered immediately, and the action will not advance until the specified period has passed. However, we may tap the Return/Enter, Space, or ESC key at any time to immediately end the delay. To disable this for the Enter and Space keys, add "strictly" to the instruction:

	wait 1450 milliseconds before continuing, strictly

The Escape key will always allow the action to continue, no matter which version of the phrase is used.

The extension will ignore calls to the real-time functions on interpreters that don't support them. If you'd like to subsititute an alternate effect on those interpreters, you can use this phrasing to fork between the two treatments:

	if glulx timekeeping is supported

See the documentation for Glulx Entry Points for more information.


Example: * The Chamber - A simple illustration of basic usage.

	*: "The Chamber"

	Include Real-Time Delays by Erik Temple.

	The Tantalus Chamber is a room. The chocolate bar is in the chamber.

	Instead of taking the chocolate bar:
		say "You pause. Do you really want...[paragraph break]";
		if glulx timekeeping is supported:
			wait 2000 milliseconds before continuing;
		say "...God! Of course you do! You devour it without removing the wrapper.";
		remove the chocolate bar from play.

	Test me with "take bar".

Example: ** Teletype - Shows how to use real-time delays to mimic a teletype effect, with a short pause after each letter, and a longer pause after each line. The code here makes use of three global variables to set the speed for different types of output--delay for line breaks and paragraph breaks can be set separately from other characters. A few other phrases are included to show how common tasks such as changing the basic teletype rate can be made easier.

It should be noted that interpreters based on Windows Glk have poor temporal resolution, perhaps 20-90 milliseconds. These include Windows Glulxe (WinGlulxe) and Windows Git. The Gargoyle and Zoom interpreters both implement a much better timer and should give better results.

	*: 	"Teletype"

	Include Real-Time Delays by Erik Temple.

	The Lab is a room. The computer is a device in the Lab.

	Current teletype character delay is a number variable. The current teletype character delay is 40.
	Current teletype line break delay is a number variable. The current teletype line break delay is 400.
	Current teletype paragraph break delay is a number variable. The current teletype paragraph break delay is 400.

	To teletype (text-to-be-printed - an indexed text):
		repeat with N running from 1 to the number of characters in the text-to-be-printed:
			if character number N in the text-to-be-printed is "[line break]":
				wait (current teletype line break delay) milliseconds before continuing;
			if character number N in the text-to-be-printed is "[paragraph break]":
				wait (current teletype paragraph break delay) milliseconds before continuing;
			say "[character number N in the text-to-be-printed][run paragraph on]";
			wait (current teletype character delay) milliseconds before continuing, strictly.

	To teletype (text-to-be-printed - an indexed text) at/with (speed - a number) ms/milliseconds/-- delay/--:
		change the current teletype character delay to the speed;
		teletype the text-to-be-printed.
	
	To say change teletype delay to (speed - a number) ms/milliseconds/--:
		change the current teletype character delay to speed.
		
	Instead of switching on the computer:
		say "[line break]";
		teletype "[change teletype delay to 40 ms]Cross-referencing subacoustic interlaces. . . [line break]";
		teletype "Calibrating pre-Devonian energetic imbalances. . . [line break]" with 20 ms delay;
		teletype "Preparing final systems. . . [line break]Ready." with 5 ms delay;
		say "[paragraph break]".

	Test me with "turn on computer".


