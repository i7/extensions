Version 1 of Interpreter Sniffing (for Glulx only) by Friends of I7 begins here.

"Phrases for testing, as far as is possible, which interpreter the story is running under."

"Including Contributions from Dannii Willis and Brady Garvin."

Book "Kinds for Describing Interpreters"

Chapter "Glulx Implementations"

A Glulx implementation is a kind of value.
Unknown Glulx implementation is a Glulx implementation.

Chapter "IO Implementations"

An IO implementation is a kind of value.
Unknown Glk implementation and Unknown non-Glk implementation are IO implementations.

Chapter "Interpreters"

An interpreter is a kind of value.
Unknown interpreter is an interpreter.

Chapter "Version Numbers"

A version number is a kind of value.
65535.255.255 specifies a version number.

Section "Support Phrases for Saying Version Numbers without Leading Zeros" (unindexed)

Include (-
	[ is_logicalRightShift value distance;
		@ushiftr value distance sp;
		@return sp;
	];
-).

To decide what number is the bitwise and of (I - an arithmetic value) and (J - a number): (- ({I} & {J}) -).
To decide what number is (I - an arithmetic value) logically shifted (D - a number) bit/bits right: (- is_logicalRightShift({I}, {D}) -).

Section "Saying Version Numbers without Leading Zeros"

[This override does not affect showmes, but extra zeros in debugging output give no great harm.]

To say (N - a version number):
	let the major version number be N logically shifted 16 bits right;
	let the minor version number be the bitwise and of N logically shifted 8 bits right and 255;
	let the patch level be the bitwise and of N and 255;
	say "[the major version number].[no line break][the minor version number].[no line break][the patch level]".

Book "Framework for Detecting Interpreters"

Chapter "Workarounds" (unindexed)

[For Inform bug 759.]
To consider (R - a nothing based rule): (- ProcessRulebook({R}); -).
To decide what K is the (name of kind K) produced by (R - a nothing based rule producing a value of kind K): (- ResultOfRule({R}, 0, true, {-strong-kind:K}) -).

Chapter "Responding to Restores" (unindexed)

[A player can save a story under one interpreter and restore under another; we need to resniff (and possibly notify the story) after any restore.]

The resniffing rulebook is a nothing based rulebook.
The when the interpreter changes rulebook is a nothing based rulebook.

To resniff the interpreter after a restore (this is resniffing the interpreter after a restore):
	consider the resniffing rulebook;
	let the old result of Glulx implementation detection be a Glulx implementation;
	let the new result of Glulx implementation detection be a Glulx implementation;
	let the old result of IO implementation detection be an IO implementation;
	let the new result of IO implementation detection be an IO implementation;
	if Glulx implementation already detected is true:
		now the old result of Glulx implementation detection is the cached result of Glulx implementation detection;
		now Glulx implementation already detected is false;
		now the new result of Glulx implementation detection is the current Glulx implementation;
	if IO implementation already detected is true:
		now the old result of IO implementation detection is the cached result of IO implementation detection;
		now IO implementation already detected is false;
		now the new result of IO implementation detection is the current IO implementation;
	unless the old result of Glulx implementation detection is the new result of Glulx implementation detection and the old result of IO implementation detection is the new result of IO implementation detection:
		consider the when the interpreter changes rulebook.

Section "Initial Resniffing" (unindexed)

This is the resniffing stage rule:
	consider the resniffing rulebook.
The resniffing stage rule is listed before the virtual machine startup rule in the startup rulebook.

Section "Injection of Post-Restore Resniffing" (unindexed)

Include (-
	[ SAVE_THE_GAME_R res fref;
		if (actor ~= player) rfalse;
		fref = glk_fileref_create_by_prompt($01, $01, 0);
		if (fref == 0) jump SFailed;
		gg_savestr = glk_stream_open_file(fref, $01, GG_SAVESTR_ROCK);
		glk_fileref_destroy(fref);
		if (gg_savestr == 0) jump SFailed;
		@save gg_savestr res;
		if (res == -1) {
			! The player actually just typed "restore". We're going to print
			!  GL__M(##Restore,2); the Z-Code Inform library does this correctly
			! now. But first, we have to recover all the Glk objects; the values
			! in our global variables are all wrong.
			((+ resniffing the interpreter after a restore +)-->1)();
			GGRecoverObjects();
			glk_stream_close(gg_savestr, 0); ! stream_close
			gg_savestr = 0;
			return GL__M(##Restore, 2);
		}
		glk_stream_close(gg_savestr, 0); ! stream_close
		gg_savestr = 0;
		if (res == 0) return GL__M(##Save, 2);
		.SFailed;
		GL__M(##Save, 1);
	];
-) instead of "Save The Game Rule" in "Glulx.i6t".

Chapter "Detecting Glulx Implementations"

Section "Cached Glulx Implementation Detection" (unindexed)

Glulx implementation already detected is a truth state that varies; Glulx implementation already detected is false.
The cached result of Glulx implementation detection is a Glulx implementation that varies.

Chapter "Rulebook and Phrase for Detecting Glulx Implementations"

The Glulx implementation detection rulebook is a nothing based rulebook producing a Glulx implementation.

To decide what Glulx implementation is the current Glulx implementation:
	if Glulx implementation already detected is false:
		now the cached result of Glulx implementation detection is the Glulx implementation produced by the Glulx implementation detection rulebook;
		unless the rule succeeded:
			now the cached result of Glulx implementation detection is Unknown Glulx implementation;
		now Glulx implementation already detected is true;
	decide on the cached result of Glulx implementation detection.

Chapter "Detecting Glulx Versions"

Include (-
	[ is_glulxVersion;
		@gestalt 0 0 sp;
		@return sp;
	];
-).

To decide what version number is the current Glulx version number: (- is_glulxVersion() -).

Chapter "Detecting IO Implementations"

Section "Cached IO Implementation Detection" (unindexed)

IO implementation already detected is a truth state that varies; IO implementation already detected is false.
The cached result of IO implementation detection is an IO implementation that varies.

Section "Glk Test" (unindexed)

Include (-
	[ is_Glk;
		@gestalt 4 2 sp;
		@return sp;
	];
-).
To decide whether the Glk gestalt is set: (- is_Glk() -).

Chapter "Rulebook and Phrase for Detecting IO Implementations"

The IO implementation detection rulebook is a nothing based rulebook producing an IO implementation.

To decide what IO implementation is the current IO implementation:
	if IO implementation already detected is false:
		now the cached result of IO implementation detection is the IO implementation produced by the IO implementation detection rulebook;
		unless the rule succeeded:
			if the Glk gestalt is set:
				now the cached result of IO implementation detection is Unknown Glk implementation;
			otherwise:
				now the cached result of IO implementation detection is Unknown non-Glk implementation;
		now IO implementation already detected is true;
	decide on the cached result of IO implementation detection.

Chapter "Detecting IO Versions"

Include (-
	[ is_ioVersion
		canGetVersion;
		@gestalt 4 2 canGetVersion;
		if (~~canGetVersion) {
			return 0;
		}
		return glk_gestalt(gestalt_Version, 0);
	];
-).

To decide what version number is the current IO version number: (- is_ioVersion() -).

Chapter "Detecting Interpreter Versions"

Include (-
	[ is_interpreterVersion;
		@gestalt 1 0 sp;
		@return sp;
	];
-).

To decide what version number is the current interpreter version number: (- is_interpreterVersion() -).

Book "Glulx Implementation Tests"

Chapter "Git/Gift"

Git/Gift Glulx is a Glulx implementation.

Section "Git/Gift Test" (unindexed)

Include (-
	[ is_GitGift;
		@gestalt 31040 0 sp;
		@return sp;
	];
-).
To decide whether the Git gestalt is set: (- is_GitGift() -).

Section "Git/Gift Rule" (unindexed)

Glulx implementation detection (this is the test for Git/Gift rule):
	if the Git gestalt is set:
		rule succeeds with result Git/Gift Glulx.

Chapter "FyreVM"

FyreVM Glulx is a Glulx implementation.

Section "FyreVM Test" (unindexed)

Include (-
	[ is_FyreVM;
		@gestalt 4 20 sp;
		@return sp;
	];
-).
To decide whether the FyreVM gestalt is set: (- is_FyreVM() -).

Section "FyreVM Rule" (unindexed)

Glulx implementation detection (this is the test for FyreVM rule):
	if the FyreVM gestalt is set:
		rule succeeds with result FyreVM Glulx.

Book "IO Implementation Tests"

Chapter "FyreVM Channel System"

The FyreVM channel system is an IO implementation.

Section "FyreVM Channel System Test" (unindexed)

[See Section "FyreVM Test" above.]

Section "FyreVM Channel System Rule" (unindexed)

IO implementation detection (this is the test for the FyreVM channel system rule):
	if the FyreVM gestalt is set:
		rule succeeds with result FyreVM channel system.

Chapter "CocoaGlk"

CocoaGlk is an IO implementation.

Section "CocoaGlk Test" (unindexed)

The CocoaGlk detection flag is a truth state that varies; the CocoaGlk detection flag is false.

Include (-
	Array is_cocoaKeyWindowCheck --> 1;
	[ is_detectCocoaGlk
		glkSupported root nonroot firstWindow secondWindow;
		! Detect CocoaGlk via Inform bug 819, without falling afoul of Inform bug 961.
		(+ CocoaGlk detection flag +) = false;
		! If there is no Glk, there is obviously no CocoaGlk, so rule out that case first.
		@gestalt 4 2 glkSupported;
		if (~~glkSupported) {
			rfalse;
		}
		! Now, to identify bug 819 we need two related windows whose circumstances of creation we know about.
		! (So that we can be sure that one should be the key window of the other.)
		! We do not want to rely on anything the story has done previously, so we will create these windows ourselves and destroy them later.
		! Windows are created by establishing a root or by splitting, depending on whether a root already exists.
		! Therefore, test for a root.
		root = glk_window_get_root();
		if (root) {
			! A root already exists, so we must split.
			! Under 961, closing a window split off of the root without also closing the root can make the story invisible.
			! Consequently, we cannot safely split the root itself.
			! So we look for a nonroot window.
			for (nonroot = 0: nonroot = glk_window_iterate(nonroot, 0):) {
				if (nonroot ~= root) {
					break;
				}
			}
			! If we found a window to split, the loop terminated by a break and set nonroot to that window.
			! Otherwise nonroot is zero, from the end of the glk_window_iterate cycle.
			if (nonroot) {
				! Since we found a window, split it.
				firstWindow = glk_window_open(nonroot, winmethod_Below | winmethod_Proportional, 50, wintype_TextBuffer, 0);
			} else {
				! Otherwise we know that there is exactly one window open.
				! Rather than risk bug 961, we opt to close this window and create a root.
				! The story's Glk recovery code should be able to handle that reasonably.
				glk_window_close(root, 0);
				firstWindow = glk_window_open(0, 0, 0, wintype_TextBuffer, 0);
			}
		} else {
			! A root does not exist, so we may create one.
			firstWindow = glk_window_open(0, 0, 0, wintype_TextBuffer, 0);
		}
		! Root creation and window splitting may fail under some Glk implementations, but not CocoaGlk.
		! If we saw a failure, we can skip the rest of this detection process.
		if (firstWindow) {
			! Now there must be a root, and we are sure that firstWindow is safe to split.
			! Split it.
			secondWindow = glk_window_open(firstWindow, winmethod_Below | winmethod_Proportional, 50, wintype_TextBuffer, 0);
			! Again, window splitting may fail under some Glk implementations, but not CocoaGlk.
			! If we saw a failure, we can skip the rest of this detection process, except for cleaning up the window we did create.
			if (secondWindow) {
				! Finally, we have our two windows whose circumstances of creation we know about.
				! We ask the Glk implementation for the key of firstWindow, expecting it to be secondWindow.
				glk_window_get_arrangement(glk_window_get_parent(firstWindow), 0, 0, is_cocoaKeyWindowCheck);
				! If, instead, we got a result of firstWindow, that's bug 819, and we're dealing with CocoaGlk.
				(+ CocoaGlk detection flag +) = (is_cocoaKeyWindowCheck-->0) == firstWindow;
				! Now clean up the second window.
				glk_window_close(secondWindow, 0);
			}
			! And clean up the first window.
			glk_window_close(firstWindow, 0);
		}
		rfalse;
	];
-).

The detect CocoaGlk rule translates into I6 as "is_detectCocoaGlk".
The detect CocoaGlk rule is listed in the resniffing rulebook.

Section "CocoaGlk Rule" (unindexed)

IO implementation detection (this is the test for CocoaGlk rule):
	if the CocoaGlk detection flag is true:
		rule succeeds with result CocoaGlk.

Book "Interpreter Tests"

FyreVM, Zoom, and Git/Gift-based interpreter are interpreters.

To decide what interpreter is the current interpreter:
	if the current IO implementation is:
		-- FyreVM channel system:
			decide on FyreVM;
		-- CocoaGlk:
			decide on Zoom; [This is potentially controversial, as the I7 Mac IDE also uses CocoaGlk.]
		-- Unknown Glk implementation:
			if the current Glulx implementation is:
				-- Git/Gift Glulx:
					decide on Git/Gift-based interpreter;
	decide on Unknown interpreter.

Interpreter Sniffing ends here.

---- DOCUMENTATION ----

With Interpreter Sniffing included we can determine the interpreter the story is
running under by writing

	the current interpreter

as in

	if the current interpreter is Zoom:
		....

At present, the possibilities are

	FyreVM

	Zoom

	Git/Gift-based interpreter

and

	Unknown interpreter

They all have the kind

	an interpreter

For more detail, we can ask about

	the current Glulx implementation

which has kind

	a Glulx implementation

and the possibilities

	Git/Gift Glulx

	FyreVM Glulx

and

	Unknown Glulx implementation

Likewise, we may wish to know

	the current IO implementation

which has the kind

	an IO implementation

It may be

	FyreVM channel system

	CocoaGlk

	Unknown Glk implementation

or

	Unknown non-Glk implementation

All of these tests have associated phrases to determine corresponding version
numbers:

	the current interpreter version number

	the current Glulx version number

and

	the current IO version number

Each of these decides on a value with the kind

	a version number

which is an arithmetic kind of value written in three parts, major version,
minor version, and patch level, separated by dots.  For example,

	3.1.2

has major version 3, minor version 1, and patch level 2.

With this syntax we can write conditionals like

	if the current Glulx version number is at least 3.1.2:
		....

Finally, it is possible for the interpreter to change mid-story if the player
saves and restores.  If the change can be detected, rules in

	the when the interpreter changes rulebook

will be run; these are written

	When the interpreter changes:
		....

Note that these rules are run as soon as possible, and the story might not have
regained its bearings yet.  (In particular, no Glk recovery has happened.)  It
is generally not safe to produce output within such rules; we should instead
note the differences and respond at a less precarious time, such as before the
next command prompt.

Example: * Fourth Wall - Interpreter information in the story banner and other parts of the story.

	*: "Fourth Wall"
	
	Include Interpreter Sniffing by Friends of I7.
	
	After printing the banner text:
		say "[The current interpreter] [the current interpreter version number][line break]".

	Terp is a room.
	"[A lonely wooden sign] swings from an otherwise bare ceiling, and three of the walls are similarly blank.  Through [the fourth wall], however, you can vaguely make out [the author]."
	
	The ceiling is scenery in the terp.
	The description is "Blank, unstoried."

	Some blank walls are scenery in the terp.
	The description is "Blank, unstoried."
	
	A lonely wooden sign is scenery in the terp.
	The description is "The sign reads '[The current Glulx implementation] [the current Glulx version number]'."
	
	The fourth wall is scenery in the terp.
	Understand "etched" and "surface" as the fourth wall.
	The description of the fourth wall is "Etched on the surface is the text, '[The current IO implementation] [the current IO version number]'."
	Instead of searching the fourth wall:
		try examining the author.
	
	The author is a scenery person in the terp.
	The description is "As best you can tell, [the author] is [the author's name]."
	
	Include (-
		#ifdef Story_Author;
			Constant Author_Name = Story_Author;
		#ifnot;
			Constant Author_Name = (+ "Anonymous" +);
		#endif;
	-) after "Definitions.i6t".
	To decide what text is the author's name: (- Author_Name -).

	Interpreter changed is a truth state that varies; interpreter changed is false.
	When the interpreter changes:
		now interpreter changed is true.
	Before reading a command when interpreter changed is true:
		say "Whoa, déjà vu.  (It happens when they change something.)";
		now interpreter changed is false.
	
	Test me with "x sign / x wall / x author".
