Version 2/140513 of Basic Real Time (for Glulx only) by Sarah Morayati begins here. 

"Allows the author to incorporate Glulx real time events into an 
Inform 7 project." 

Include Glulx Entry Points by Emily Short. 

Section 1 - Variable Definitions 

Include (- 
Global timer_finished = 0; 
Global time_total = 0; 
Global time_elapsed = 0;
Constant TIME_FREQUENCY = 50;
Constant TIME_SCALAR = 1000/TIME_FREQUENCY;
! Scales the Glulx timer tick to 1 second. Tested on my machine,
! but it can be changed if necessary. Note that the Windows
! IDE will be somewhat slower; these are calibrated for the
! released file. -) 
after "Definitions.i6t". 

Section 2 - Save/Restore

Include (-

! This is the SAVE_THE_GAME_R routine from Glulx.16t, with a StartTimer routine injected.
! Saving a game saves the states of the global variables too. However, without this
! injected routine, the Glulx timer will not restart. This rectifies that. NOTE: If you
! are using any other extension that modifies SAVE_THE_GAME_R, there may be conflicts.

[ SAVE_THE_GAME_R res fref;
	if (actor ~= player) rfalse;
	fref = glk_fileref_create_by_prompt($01, $01, 0);
	if (fref == 0) jump SFailed;
	gg_savestr = glk_stream_open_file(fref, $01, GG_SAVESTR_ROCK);
	glk_fileref_destroy(fref);
	if (gg_savestr == 0) jump SFailed;
	@save gg_savestr res;
	if (res == -1) {
		! The player actually just typed "restore". We first have to recover
		! all the Glk objects; the values in our global variables are all wrong.
		GGRecoverObjects();
		glk_stream_close(gg_savestr, 0); ! stream_close
		gg_savestr = 0;
		StartTimer(time_total - time_elapsed);
		RESTORE_THE_GAME_RM('B'); new_line;
		rtrue;
	}
	glk_stream_close(gg_savestr, 0); ! stream_close
	gg_savestr = 0;
	if (res == 0) { SAVE_THE_GAME_RM('B'); new_line; rtrue; }
	.SFailed;
	SAVE_THE_GAME_RM('A'); new_line;
];

-) instead of "Save The Game Rule" in "Glulx.i6t".

Section 3 - Inform 6 Routines 

Include (- 
[ StartTimer sec ; 
time_total = sec; 
time_elapsed = timer_finished = 0;
glk_request_timer_events(TIME_FREQUENCY); ! To keep track of time elapsed so pausing works. 
]; -) 

Include (- 
[ SetNewTimer newsec ; 
time_total = newsec; 
time_elapsed = timer_finished = 0; 
glk_request_timer_events(TIME_FREQUENCY); 
]; -) 

Include (- 
[ DeductFromTimer newsec ; 
time_elapsed = time_elapsed + newsec;
glk_request_timer_events(TIME_FREQUENCY); 
]; -) 

Include (- 
[ AddToTimer newsec ;  
time_elapsed = time_elapsed - newsec;
glk_request_timer_events(TIME_FREQUENCY); 
]; -) 

Include (- 
[ PauseTimer ; 
glk_request_timer_events(0); 
time_total = time_total - time_elapsed; 
]; -) 

Include (- 
[ ResumeTimer ; 
time_elapsed = timer_finished = 0; 
glk_request_timer_events(TIME_FREQUENCY); 
]; -) 

Include (- 
[ TimedAction ; 
switch (timer_finished) { 
0: if (time_elapsed >= time_total) timer_finished = 1; time_elapsed++; 
1: glk_request_timer_events(0); SetTimedEvent( (+ the next real-time action fires +), 1, 0);
} ]; -) 

Include (-
[ PrintSecondsRemaining seconds_remaining ;
seconds_remaining = (time_total - time_elapsed) / TIME_SCALAR;
if (seconds_remaining < 0) seconds_remaining = 0;
print "", seconds_remaining, ""; ]; -)

Include (-
[ PrintSecondsElapsed seconds_elapsed ;
seconds_elapsed = (time_elapsed) / TIME_SCALAR;
print "", seconds_elapsed, ""; ]; -)

Section 4 - Inform 7 Syntax 

The next real-time action is a stored action that varies. 

A glulx timed activity rule: perform the next real-time action;

To start the/-- timer for (sec - a number) second/seconds: (- 
StartTimer({sec}*TIME_SCALAR);  -) 

To set the/-- timer for (newsec - a number) second/seconds: (- 
SetNewTimer({newsec}*TIME_SCALAR); -) 

To pause the/-- timer: (- PauseTimer(); -)

To resume the/-- timer: (- ResumeTimer(); -) 

To deduct (sec - a number) second/seconds from the/-- timer: (-
DeductFromTimer({sec}*TIME_SCALAR); -)

To add (sec - a number) second/seconds to the/-- timer: (-
AddToTimer({sec}*TIME_SCALAR); -)

To stop the/-- timer: (- glk_request_timer_events(0); time_elapsed = 0;  -) 

To perform the next real-time action: (- TimedAction(); -) 

[Add a phrase referencing 'the next real-time action fires' from i7 to placate the compiler]
To immediately fire the next real-time action:
	The next real-time action fires in 0 turns from now.

At the time when the next real-time action fires: try the next real-time action; 

To say seconds remaining: (- PrintSecondsRemaining(); -)

To say seconds elapsed: (- PrintSecondsElapsed(); -)

Basic Real Time ends here. 

---- DOCUMENTATION ---- 
Basic Real Time is a wrapper for Glulx's real time functions. The 
extension requires Glulx Entry Points by Emily Short. It also
requires you, of course, to compile to Glulx (not .z5 or .z8).

This extension differs from the author's original version: it has been modified for compatibility with version 6L02 of Inform. The latest version of this extension can be found at <https://github.com/i7/extensions>. 

This extension is released under the Creative Commons Attribution licence. Bug reports, feature requests or questions should be made at <https://github.com/i7/extensions/issues>.

The original author can be contacted at: morayati (at) email (dot) unc (dot) edu

Normally, Inform 7 games are turn-based: that is, events happen, and 
time passes, only when the player inputs a command. 

Glulx allows the inclusion of real time events: events that happen 
based on time in the "real world". 

This extension uses the Glulx timer, which normally repeats events at 
regular intervals. Here, the event will fire only once, when the timer 
is finished. 

Once the timer runs out, the event will fire after the player's next 
turn (this is to avoid interfering with the command prompt.) 

Usage: 
	start timer for (number) second/seconds; 

Starts the timer. Once the action fires, the timer automatically stops. 

	set timer for (number) second/seconds; 

Changes the time remaining to a specific amount.

	deduct (number) second/seconds from timer;

Deducts time from the timer.

	add (number) second/seconds to timer;

Adds time to the timer.

	pause timer; 

Pauses the timer. 

	resume timer; 

Resumes the timer. 

	stop timer; 

Stops the timer manually. 

	say seconds remaining; 

Prints the amount of seconds remaining; can be called in quotes:

	[seconds remaining].

	say seconds elapsed; 

Prints the amount of seconds elapsed; can be called in quotes: 

	[seconds elapsed].

	A glulx timed activity: perform the next real-time action; 

Triggers the next action. It will fire on the next available turn. 

The next real-time action is a stored action which can be altered 
in a story's source code, first when play begins, then each time 
the author starts the timer:

	now the next real-time action is the action of...

As with any other stored action, this can either be an action built 
into the standard Inform 7 library or a new action defined by the 
author. 

The latter in particular gives versatility; the author can schedule, 
in real time, anything that can be defined as a result of an action.

Example:	* "Green Button" - Starting, stopping, and altering the timer.

	*:"Green Button"

	Include Basic Real Time by Sarah Morayati.

	The story headline is "An interactive panic button".

	Control Room is a room. "It's your first day on the job at Technologies and they've already got you in charge of all the controls. Your boss didn't tell you what all these buttons and switches were for. All she said was to press the green button, and that there would be severe consequences if you pressed the red button. (The exact word she used was 'fired.')"

	When play begins:
		now the next real-time action is the action of releasing the terrors;

	The gadgets are scenery in Control Room. They are plural-named. Instead of doing something to the gadgets, say "There are too many of them and they're too intimidatingly gray. You don't even know where to begin." Understand "buttons" and "button" and "switches" and "switch" and "control" and "controls" as the gadgets.

	The green button is scenery in Control Room. The green button can be pressed or unpressed. It is unpressed. The description of the green button is "It's an enticing pale green and has 'YES' splayed across it in white lettering."

	Instead of pushing the green button for the first time:
		now the green button is pressed;
		now the description of Control Room is "It's your first day on the job at Technologies and they've already got you in charge of all the controls. Your boss didn't tell you what all these buttons and switches were for. She also didn't tell you that pressing the green button would release world-rending terrors. Oops.";
		start timer for 15 seconds;
		say "You press the green button. Almost immediately, a pleasant female voice (you briefly wonder why they're never male, or horrifying) intones, 'Green button pressed. Releasing world-rending terrors in [seconds remaining] seconds.'";

	Instead of pushing the green button:
		deduct 1 second from timer;
		say "You jab at the green button. The voice intones, 'Thank you for your impatience. The world-rending terrors will be released one second sooner.' Your boss left this part out.";

	The red button is scenery in Control Room. The description of the red button is "If the fact that it was bright red wasn't warning enough, the text reads 'NO' in bold letters."

	Instead of pushing the red button:
		if the green button is unpressed:
			say "You just got this job. Clearly what you should do is disobey a direct order. Clearly.";
		otherwise:
			stop timer;
			say "You debate the relative merits of remaining employed versus dealing with world-rending terrors, figure you'd rather lose your job than your life, and press the red button. The voice, no longer so pleasant, whines 'No world-rending terrors will be released. I hope you're happy.' Huh. Guess that was the world-rending-terror-ending button. You wait for your boss to walk in, a trapdoor to appear below you, or a big boot to kick you out the window, but apparently it isn't a day for cartoon tropes. Huh. Maybe you'll be OK after all.";
			end the story finally saying "You have saved the world";

	Releasing the terrors is an action applying to nothing.
	Carry out releasing the terrors:
		say "You're no good at keeping time, so you're a bit startled when that voice intones: 'Releasing world-rending terrors now. Have a nice day.' What conspires next is too terrible for words. Good thing, really, because you no longer have a way to speak them.";
		end the story saying "You have died";