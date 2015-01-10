Version 1/150110 of Glulx Debugging Console (for Glulx only) by Erik Temple begins here.

"Provides a separate Glulx window for debugging messages. Compatible with Inform build 6L38. Requires v14 of Flexible Windows by Jon Ingold."

Include version 14/140922 of Flexible Windows by Jon Ingold.

Chapter - Fancy debugging

Use inline debugging translates as (- Constant INLINE_DEBUG; -)

To #if utilizing inline debugging:
	(- #ifdef INLINE_DEBUG; -)
	
To #end if:
	(- #endif; -)
	

Chapter - Console command
[We can add our own text to the console log stream by using this command.]

Understand "> [text]" as a mistake ("[>console][line break]*[player's command][paragraph break][<]") when the inline debugging option is active.


Chapter - Debugging output window
[We can direct debugging info to output in any window. The primary use for this feature is expected to be the separate console window, though it can also be written to the transcript.]

The console output window is a g-window variable. 


Section - Window definition

The console-window is a text-buffer g-window spawned by the main-window. The back-colour of the console-window is usually g-lavender.
 

Section - Window positioning

The position of the console-window is usually g-placebelow.


Section - Open console

To initiate the/-- console:
	open up the console-window.

After constructing the console-window:
	If the current action is opening the g-console:
		continue the action;[We don't want to follow this rule if we've already opened the console using an action.]
	if console-window is g-present:
		say "[>console][bracket]Console[close bracket]: Console initiated by source code directive[unless the inline debugging option is active]. Automated logging may be disabled. If expected output does not appear, activate the inline debugging use option[end if].[<]";
	otherwise:
		say "*** An unknown error prevented the console window from opening.";
	continue the action.

To cease logging to console:
	unless console-window is g-unpresent:
		shut down the console-window;
		unless console-window is g-unpresent:
			say "*** An unknown error prevented the console window from closing.";


Section - Command to open the console

Opening the g-console is an action applying to nothing. Understand "open g-console" as opening the g-console.

Check opening the g-console:
	if console-window is g-present:
		say "The console window is already open.";
		rule fails.

Carry out opening the g-console:
	say "Opening the console window...";
	open up the console-window;
	if console-window is g-present:
		say "[>console]Console initiated by command-line input[unless the inline debugging option is active]. Automated logging is disabled. To enable, activate the inline debugging use option[end if].[<]";
		say "";[This seemingly useless line lets Inform get its paragraphing back on track.]
	otherwise:
		say "*** An unknown error prevented the console window from opening."


Section - Command to close the console

Closing the g-console is an action applying to nothing. Understand "close g-console" as closing the g-console.

Check closing the g-console:
	if console-window is g-unpresent:
		say "The console is already closed.";
		rule fails.

Carry out closing the g-console:
	shut down the console-window;
	if console-window is g-unpresent:
		say "Console window closed.";
	otherwise:
		say "*** An unknown error prevented the console window from closing."


Section - Direct output to the console-window

The console output window is usually the console-window.


Section - Logging to the transcript

Use console transcript logging translates as (- Constant CONSOLE_TRANSCRIPT_ON; -)

Report switching the story transcript on when the console transcript logging option is active:[we use "report" only because "after" doesn't exist for out-of-world actions.]
	if the console output window is the main-window:
		continue the action;
	if we are writing to the transcript and the console output window is g-present:
		echo the text stream of the console output window to the transcript;
	continue the action.

After constructing the console output window when the console transcript logging option is active:
	if the console output window is the main-window:
		continue the action;
	if we are writing to the transcript and the console output window is g-present:
		echo the text stream of the console output window to the transcript;
		continue the action.


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


Chapter - Debugging commands

To suspend actions tracing:
	(- trace_actions = 0; -)

To activate actions tracing:
	(- trace_actions = 1; -)

To suspend rules tracing:
	(- debug_rules = 1; -)

To activate intensive rules tracing:
	(- debug_rules = 2; -)

To activate rules tracing:
	(- debug_rules = 1; -)

To decide whether rules tracing is active:
	(- debug_rules -)

To decide whether intensive rules tracing is active:
	(- debug_rules == 2 -)

To show the/-- glk/glklist list/--:
	(- GlkListSub(); -)


Chapter - Text substitutions for logging console messages
[We preface console log messages with ">console" (the > is used to be sure that "console" doesn't conflict with any object named console. The [>console] *must* be balanced with [<] at the end: this transfers the focus back to the main window from the console.

Note that, like all "to" phrases in Inform, these can be "overloaded". To do something different with them, rewrite the phrase in your story file, beneath the include line for this extension.]

To say >console:
	(- if ( (+ console output window +) has g_present) { glk_set_window( (+ console output window +).ref_number); -).
 
To say <:
	(-   glk_set_window( gg_mainwin ); } RunParagraphOn(); -).

Glulx Debugging Console ends here.
