Version 1/140511 of Alternative Startup Rules (for Glulx only) by Dannii Willis begins here.

"Refactors the Startup Rules so that it can be more easily altered"

[ A demonstration/proof of concept for http://inform7.uservoice.com/forums/57320/suggestions/3608381

We refactor the starting the virtual machine activity so that it can be more effectively used by extensions.

The before starting the virtual machine rulebook should be used only for safe code that does not use any IO stuff - not even to print an error. Be careful!
The for starting the virtual machine rulebook should be used to set up IO systems.
The after starting the virtual machine rulebook is a good place for extensions to put their own code, so that the When Play begins rulebook can be left empty for authors to use without worrying about whether their extensions' rules have been run yet. ]

Use authorial modesty.



Chapter - Rearranging the Startup Rules

The alternative virtual machine startup rule is listed instead of the virtual machine startup rule in the startup rules.
This is the alternative virtual machine startup rule:
	carry out the starting the virtual machine activity.

[ Unfortunately we must define new rules because of bug 0001246. ]
The initialise memory rule is not listed in the startup rules.
The alternative initialise memory rule is listed first in the before starting the virtual machine rules.
The alternative initialise memory rule translates into I6 as "INITIALISE_MEMORY_R".

[ This rule must be moved earlier because otherwise we cannot check the spawning relation which means Flexible Windows could not open the status window ]
The position player in model world rule is not listed in the startup rules.
The alternative position player in model world rule is listed in the before starting the virtual machine rules.
The alternative position player in model world rule translates into I6 as "POSITION_PLAYER_IN_MODEL_R".

The enable Glulx acceleration rule is not listed in the for starting the virtual machine rules.
The enable Glulx acceleration rule is listed in the before starting the virtual machine rules.

The seed random number generator rule is not listed in the startup rules.
The alternative seed random number generator rule is listed first in the for starting the virtual machine rules.
The alternative seed random number generator rule translates into I6 as "SEED_RANDOM_NUMBER_GENERATOR_R".

First after starting the virtual machine rule (this is the initial whitespace rule):
	say "[line break][line break][line break]123".

The update chronological records rule is not listed in the startup rules.
The alternative update chronological records rule is listed in the after starting the virtual machine rules.
The alternative update chronological records rule translates into I6 as "UPDATE_CHRONOLOGICAL_RECORDS_R".

The start in the correct scenes rule is not listed in the startup rules.
After starting the virtual machine (this is the alternative start in the correct scenes rule):
	follow the scene changing rules.



Chapter - Dividing up VM_Initialise

The check for Glk rule is listed in the before starting the virtual machine rules.
The check for Glk rule translates into I6 as "CheckForGlk".
Include (-
[ CheckForGlk res;
	@gestalt 4 2 res;
	if (res == 0) quit;
	rfalse;
];
-).

The recover objects rule is listed in the before starting the virtual machine rules. 
The recover objects rule translates into I6 as "GGRecoverObjects".

The sound channel initialisation rule is listed first in the for starting the virtual machine rules.
The sound channel initialisation rule translates into I6 as "SoundChannelInitialisation".
Include (-
[ SoundChannelInitialisation;
	if (glk_gestalt(gestalt_Sound, 0)) {
		if (gg_foregroundchan == 0)
			gg_foregroundchan = glk_schannel_create(GG_FOREGROUNDCHAN_ROCK);
		if (gg_backgroundchan == 0)
			gg_backgroundchan = glk_schannel_create(GG_BACKGROUNDCHAN_ROCK);
	}
	rfalse;
];
-).

[ Instead of introducing adding a new rule for the FIX_RNG code, we'll add it into the seed random number generator rule ]
Include (- 
[ SEED_RANDOM_NUMBER_GENERATOR_R i;
	#ifdef FIX_RNG;
	@random 10000 i;
	i = -i-2000;
	print "[Random number generator seed is ", i, "]^";
	@setrandom i;
	#endif; ! FIX_RNG
	if ({-value:rng_seed_at_start_of_play}) VM_Seed_RNG({-value:rng_seed_at_start_of_play});
	for (i=1: i<=100: i++) random(i);
	rfalse;
];
-) instead of "Seed Random Number Generator Rule" in "OrderOfPlay.i6t".



Chapter - Opening the built-in windows

[(for use without Flexible Windows by Jon Ingold)]

The open built-in windows rule is listed in the for starting the virtual machine rules.
The open built-in windows rule translates into I6 as "OpenBuiltInWindows".
Include (-
[ OpenBuiltInWindows res sty;
	res = InitGlkWindow(0);
	if (res ~= 0) return;

	! Now, gg_mainwin and gg_storywin might already be set. If not, set them.

	if (gg_mainwin == 0) {
		! Open the story window.
		res = InitGlkWindow(GG_MAINWIN_ROCK);
		if (res == 0) {
			! Left-justify the header style
			glk_stylehint_set(wintype_TextBuffer, style_Header, stylehint_Justification, 0);
			! Try to make emphasized type in italics and not boldface
			glk_stylehint_set(wintype_TextBuffer, style_Emphasized, stylehint_Weight, 0);
			glk_stylehint_set(wintype_TextBuffer, style_Emphasized, stylehint_Oblique, 1);
			gg_mainwin = glk_window_open(0, 0, 0, wintype_TextBuffer, GG_MAINWIN_ROCK);
		}
		if (gg_mainwin == 0) quit; ! If we can't even open one window, give in
	} else {
		! There was already a story window. We should erase it.
		glk_window_clear(gg_mainwin);
	}

	if (gg_statuswin == 0) {
		res = InitGlkWindow(GG_STATUSWIN_ROCK);
		if (res == 0) {
			statuswin_cursize = statuswin_size;
			for (sty=0: sty<style_NUMSTYLES: sty++)
				glk_stylehint_set(wintype_TextGrid, sty, stylehint_ReverseColor, 1);
			gg_statuswin =
				glk_window_open(gg_mainwin, winmethod_Fixed + winmethod_Above,
					statuswin_cursize, wintype_TextGrid, GG_STATUSWIN_ROCK);
		}
	}
	! It's possible that the status window couldn't be opened, in which case
	! gg_statuswin is now zero. We must allow for that later on.

	glk_set_window(gg_mainwin);

	InitGlkWindow(1);
	rfalse;
];
-).



[Section - Opening the standard windows (for use with Flexible Windows by Jon Ingold)

The initial hyperlink request rule is not listed in the when play begins rules.

The allocate rocks rule is not listed in the when play begins rules.
The allocate rocks rule is listed in the before starting the virtual machine rules.

Rule for starting the virtual machine (this is the open standard windows using Flexible windows rule):
	if the ref-number of main-window is 0:
		now the main-window is g-unpresent;
		now the main-window is g-unrequired;
	otherwise:
		clear the screen;
	if the ref-number of status-window is 0:
		now the status-window is g-unpresent;
		now the status-window is g-unrequired;
	open up the main-window;
	unless the no status line option is active:
		[ I'm not sure why, but this doesn't actually work :( We have to run it a second time ]
		open up the status-window;
	continue the activity;

Last after starting the virtual machine rule (this is the open the status window rule):
	unless the no status line option is active:
		open up the status-window;

Before constructing the main-window (this is the set text styles for the main window rule):
	set text styles for the main window.
To set text styles for the main window:
(-
	! Left-justify the header style
	glk_stylehint_set( wintype_TextBuffer, style_Header, stylehint_Justification, 0 );
	! Try to make emphasized type in italics and not boldface
	glk_stylehint_set( wintype_TextBuffer, style_Emphasized, stylehint_Weight, 0 );
	glk_stylehint_set( wintype_TextBuffer, style_Emphasized, stylehint_Oblique, 1 );
-).

Before constructing the status-window (this is the set text styles for the status window rule):
	let temp be 0;
	set text styles for the status window.
To set text styles for the status window:
(-
	statuswin_cursize = statuswin_size;
	for ( t_0=0 : t_0 < style_NUMSTYLES : t_0++ )
	glk_stylehint_set( wintype_TextGrid, t_0, stylehint_ReverseColor, 1 );
-).]



Alternative Startup Rules ends here.
