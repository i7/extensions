Version 1/111030 of Glimmr Canvas Animation (for Glulx only) by Erik Temple begins here.

"Provides a 'track'-based system for independent animation of graphic elements, canvases, and windows. Features animation presets, automated easing/tweening, and a detailed debugging log."


Part - Inclusions

Include Glimmr Canvas-Based Drawing by Erik Temple.


Part - Settings and resources

Chapter - Use options

Section - Debug logging

Use animation debugging translates as (- Constant ANIM_DEBUG; -)

To #if utilizing animation debugging:
	(- #ifdef ANIM_DEBUG; -)


Chapter - Console settings

To say CA:
	say "[bracket]Glimmr Anim[close bracket]: ".

When play begins when the animation debugging option is active:
	say "[>console][CA]Animation logging active. Note that some interpreters (such as Gargoyle) may not show per-frame debugging messages unless you display them in a separate window. Use the Glimmr Debugging Console extension if you are not seeing the expected output in your interpreter of choice.[<]". 


Chapter - Useful phrases


Section - Mathematical functions

To decide what number is ABS/absolute value/-- of/-- (N - a number):
	if N < 0, decide on 0 - N;
	decide on N.

[Greatest common divisor function from Ben Cressey: http://www.intfiction.org/forum/viewtopic.php?f=7&t=3424]
To decide what number is the greatest common divisor of (A - a number) and (B - a number):
	if b is 0, decide on A;
	decide on the greatest common divisor of B and the remainder after dividing A by B.


Section - Shortcuts for fixed point maths
[The doubled symbols are used when we need to perform an operation on one number and one "real number" or two "real numbers"; we must use standard symbols to operate on two numbers. The use of the doubled symbols improves readability with easing equations, which often need to use fractional values.]

To decide which real number is (A - value) ++ (B - value):
	decide on A real plus B.
	
To decide which real number is (A - value) -- (B - value):
	decide on A real minus B.
	
To decide which real number is (A - value) ** (B - a value):
	decide on A real times B.
	
To decide which real number is (A - value) // (B - a value):
	decide on A real divided by B.
	
To decide whether (A - a value) << (B - a value):
	if A is real less than B, decide yes.

To decide whether (A - a value) >> (B - a value):
	if A is real greater than B, decide yes.
	
To decide which real number is (A - value) ^^ (B - value):
	decide on A to the power B.

To decide which real number is sqrt (A - a value):
	decide on the real square root of A.


Section - Greasing the wheels for callbacks
[From John Clemens: http://www.math.psu.edu/clemens/IF/I7tricks.html#command]

 To say perform/@ (ph - phrase): (- if (0==0) {ph} -).


Section - Adjusting origins and endpoints
[This phrase is intended to allow origins of g-elements and g-windows to be changed simply. It can also be used to change the endpoint of a primitive g-element.]

To adjust the (P - a (list of numbers) valued property) of (O - an object) by (dX - a number) and (dY - a number):
	let X be entry 1 of list property P of O;
	let Y be entry 2 of list property P of O;
	let X be X + dX;
	let Y be Y + dY;
	now entry 1 of list property P of O is X;
	now entry 2 of list property P of O is Y.


Part - Animation tracks and animation controls


Chapter - The animation track kind

An animation track is a kind of object.


Section - Track timer controls

An animation track has a number called the timer interval.
An animation track has a number called the timer count.
An animation track has a number called the timer frame-multiple. The timer frame-multiple is usually 1.


Section - Animation track presets

An animation preset is a kind of value. The animation presets are custom, reel, parameterized reel, motion, parameterized motion, zooming, parameterized zooming, flicker, fade, and temporalizing.

An animation track has an animation preset.


Section - Modalities for animation tracks

An animation track can be cycling. An animation track is usually not cycling.
An animation track can be animation-randomized. An animation track is usually not animation-randomized.


Section - Properties for basic tracking
[These properties determine whether the track is active as well as tracking progress]

An animation track has a g-activity called the animation-flag. The animation-flag of an animation track is usually g-inactive.

An animation track has a number called the current-frame.
An animation track has a number called the animation-length. The animation-length is usually 1.
An animation track has a number called the cycle-length. The cycle-length is usually 1.
An animation track has a number called the cycles completed.


Section - Properties to track animated objects

An animation track has an object called the animation-target. The animation-target is usually g-null-element.

An animation track has a g-canvas called the target-canvas.

An animation track has a list of figure names called the image-reel.

An animation track has a text called the animation-callback.


Section - Properties to control easing

An animation track has a phrase (number, number, number, number) -> number called the easing. The easing of an animation track is usually the linear easing rule.

[The secondary easing can be activated for a motion track to enable independent easing of the y-axis for  movement; the (primary) easing will then control the x-axis movement.]
An animation track has a phrase (number, number, number, number) -> number called the secondary easing. The secondary easing of an animation track is usually the null easing rule.

[These are used to manage the easing calculations for a track.]
An animation track has a number called the delta-x.
An animation track has a number called the delta-y.
An animation track has a number called the start-x.
An animation track has a number called the start-y.


Section - The default track
[The default track is an instance of the animation track kind, supplied for use by authors.]

The default track is an animation track.


Chapter - Deciding whether animation is happening
[There are actually two steps to deciding whether animation is happening:
1. Is the timer running?
2. If it is, is there an active animation track?

If the answer to both is yes for any given tick of the timer, then the animation rules will be triggered.]

Definition: An animation track (called the item) is animation-active if the animation-flag of the item is g-active.

To decide whether animation is queued:
	if there is an animation-active animation track, decide yes.

To decide whether animation is underway:
	if there is an animation-active animation track and the global timer interval > 0, decide yes.
	

Chapter - Basic animation phrases

To animate (A - an animation track) at (N - a number):
	now the animation-flag of A is g-active;
	now the timer interval of A is N to the nearest (standard interval divisor);
	now the timer count of A is 0;
	start a Glulx timer of N milliseconds.

[Nearly the same as the basic animate... phrase, but intended for use only once an animation is already running; as such, it does not reset the timer count to 0. The phrase for starting the Glulx timer will set the timer count appropriately.]
To time (A - an animation track) at (N - a number):
	now the animation-flag of A is g-active;
	now the timer interval of A is N to the nearest (standard interval divisor);
	start a Glulx timer of N milliseconds.
	
To activate (A - an animation track):
	now the animation-flag of A is g-active;
	#if utilizing animation debugging;
	say "[>console][CA]Animation track [i][A][/i] activated.[<]";
	#end if.

To deactivate (A - an animation track):
	now the animation-flag of A is g-inactive;
	#if utilizing animation debugging;
	say "[>console][CA]Animation track [i][A][/i] deactivated.[<]";
	#end if.
	
To decide which number is (N - a number) frame/frames/-- per/-- second/fps:
	decide on 1000 / N.

To decide which number is (N - a number) milliseconds/ms per frame:
	decide on N.
	
To set up (track - an animation track) as (preset - animation preset) with duration (len - a number):
	now the track is preset;
	now cycles completed of the track is 0;
	unless len is 0:
		now the animation-length of the track is len;
	now the current-frame of the track is 1;
	#if utilizing animation debugging;
	describe animation track;
	#end if.
	
To set up (track - an animation track) as (preset - animation preset):
	now the track is preset;
	now cycles completed of the track is 0;
	now the current-frame of the track is 1;
	#if utilizing animation debugging;
	describe animation track;
	#end if.

To describe animation (track - an animation track):
	say "[>console][CA]Track [i][track][/i] has been set up as a [animation preset of the track] animation with animation-length of [animation-length of the track] frame(s)[if the track is cycling], cycling[end if].[<]";


Section - Timer control phrases

The global timer interval is a number variable.
[The standard interval divisor is used for performance reasons. We round all timer requests so that they are multiples of this number. This makes it more likely that we will have larger actual timer intervals. Without it, if the author specified intervals for concurrent animations of 41 and 83, then the timer would have to tick every millisecond in order to space them accurately (no Glulx VM can currently manage this accurately). With the standard interval divisor set to 10, GCA will silently adjust the intervals to 40 and 80, meaning that the timer will tick every 40 ms.]
The standard interval divisor is a number variable. The standard interval divisor is 10.

To start a/-- Glulx timer of (T - a number) millisecond/milliseconds:
	let N be MAX (standard interval divisor) or T to the nearest (standard interval divisor);[we round to the nearest 10 ms by default]
	#if utilizing animation debugging;
	say "[>console][CA]Interval of [T] ms specified for animation[if N is not T], rounded to [N] (nearest [standard interval divisor])[end if].[<]";
	#end if;
	if the global timer interval is greater than 0 and the number of animation-active animation tracks > 1:
		let N be the greatest common divisor of N and the global timer interval;	
		#if utilizing animation debugging;
		say "[>console][CA]Global timer interval of [N] ms selected as greatest common divisor of the specified interval and the existing timer interval of [global timer interval] ms.[<]";
		#end if;
		let standardizer be N as a fixed point number real divided by global timer interval;
		repeat with track running through animation-active animation tracks:
			if the timer frame-multiple of the track is 0, now the timer frame-multiple of the track is 1;[prevents division errors]
			now the timer count of the track is the remainder after dividing the timer count of the track by the timer frame-multiple of the track;
			unless standardizer real equals 1.0000:
				now the timer count of the track is the timer count of the track multiplied by the standardizer as an integer;
			now the timer frame-multiple of the track is the timer interval of the track divided by N;
			#if utilizing animation debugging;
			say "[>console][CA]Track [i][track][/i] will fire every [timer frame-multiple of the track] tick(s) of the timer. Current offset: [timer count of the track] frames.[<]";
			#end if;
	request Glk timer event at N milliseconds;
	#if utilizing animation debugging;
	say "[>console][CA]Timer event requested for every [N] milliseconds.[<]";
	#end if.

 To pause/stop the/-- Glulx timer:
	request Glk timer event at 0 milliseconds;
	#if utilizing animation debugging;
	say "[>console][CA]Timer event requested at 0 milliseconds.[<]";
	#end if.

To request Glk timer event at (T - a number) milliseconds:
	(- glk_request_timer_events({T}); (+ global timer interval +) = {T}; -).

To reset the Glulx timer:
	start a Glulx timer of (global timer interval) milliseconds.


Section - Restart the timer after restoring
[The state of the timer is not automatically restored, so we must start a timer on restore at the same speed it was running when the game was saved.]

First report restoring the game:
	reset the Glulx timer;
	continue the action.


Section - Restart the timer after undoing
[The state of the timer is not automatically saved with the game state, so we must start a timer after undoing at the same speed it was running when the game state was saved.]

Include Undo Output Control by Erik Temple.

After undoing an action:
	reset the Glulx timer.


Section - Glk events (for use without Glulx Input Loops by Erik Temple)
[This section provides definitions and phrase wrappers that allow us to write I7 code for handling raw input. This code comes from the Glulx Input Loops extensions, so we include it only if that extension is not also present.]

A g-event is a kind of value. The g-events are timer-event, char-event, line-event, mouse-event, arrange-event, redraw-event, sound-notify-event, and hyperlink-event.

Definition: A g-event is window-dependent if the g-event is not timer-event or the g-event is not sound-notify-event or the g-event is not arrange-event or the g-event is not redraw-event.

Definition: A g-event is glk-initiated if the g-event is timer-event or the g-event is sound-notify-event or the g-event is arrange-event or the g-event is not redraw-event.


To decide which g-event is null-event: (- 0 -)

To wait for glk input:
	(- glk_select(gg_event); -)
	
To decide which g-event is the current glk event:
	(- gg_event-->0 -)
	
To decide which number is the window of the current glk event:
	(- gg_event-->1 -)
	
To decide what number is the character code returned:
	(- gg_event-->2 -)

To decide what number is glk event handled in (ev - a g-event) context:
	(- HandleGlkEvent(gg_event, {ev}, gg_arguments) -)


Chapter - Delaying the player's input

Section - Delaying input until all animations end

To delay input until all animations are complete:
	#if utilizing animation debugging;
	say "[>console][CA]Input delayed while all running animation tracks complete.[<]";
	#end if;
	while animation is queued:
		wait for glk input;
		if the current glk event is glk-initiated:
			let event-outcome be glk event handled in null-event context;[Handles the event; we'll just ignore the outcome since it doesn't stem from player input.]
			

Section - Delaying input until just one animation has ended

To delay input until (track - an animation track) is complete:
	#if utilizing animation debugging;
	say "[>console][CA]Input delayed while the animation track [i][track][/i] completes.[<]";
	#end if;
	while track is animation-active:
		wait for glk input;
		if the current glk event is glk-initiated:
			let event-outcome be glk event handled in null-event context;[Handles the event; we'll just ignore the outcome since it doesn't stem from player input.]


Part - Animation dispatch and handling

Chapter - Animation dispatch

A glulx timed activity rule when animation is queued (this is the animation dispatch rule):
	let frames-processed be 0;
	repeat with track running through animation-active animation tracks:
		increase the timer count of the track by 1;
		if the remainder after dividing the timer count of the track by the timer frame-multiple of the track is 0:
			follow the animation rules for the track;
			increase frames-processed by 1;
	if frames-processed is greater than 0:
		#if utilizing animation debugging;
		say "[>console][CA]Calculations for running animations completed; drawing graphics window(s).[paragraph break][<]";
		#end if;
		carry out the updating graphics windows for animation activity.

Section - Updating windows activity

Updating graphics windows for animation is an activity.
	
For updating graphics windows for animation (this is the animation window-updating rule):
	repeat with win running through g-present graphics g-windows:
		follow the window-drawing rules for win.


Chapter - Common code for animation rules

Last animation rule for an animation track (called the track):
	advance the track.

To advance (track - an animation track):
	increment current-frame;
	[say "current frame: [current-frame]; cycles completed: [cycles completed of the track].";]
	if the track is cycling:
		let cyclic-frame be current-frame of the track - (cycle-length of the track * cycles completed of the track);
		[say "Comparing cyclic frame ([cyclic-frame]) to cycle length ([cycle-length of the track]).";]
		if the cyclic-frame > the cycle-length of the track:
			increment cycles completed of the track;
		if (current-frame of the track > animation-length of the track) and the animation-length of the track is not the cycle-length of the track:
			cease animating the track;
	otherwise:
		if current-frame of the track > animation-length of the track:
			cease animating the track.
				
To cease animating (track - an animation track):
	now the animation-flag of the track is g-inactive;
	unless the animation-callback of the track is "":
		say the animation-callback of the track;
		say run paragraph on;
	unless animation is queued:
		stop the Glulx timer.


Section - Animation handlers

To cycle (track - an animation track):
	now track is cycling.
	
To stop cycling (track - an animation track):
	now track is not cycling.
	
To randomize (track - an animation track):
	now track is animation-randomized.
	
To remove randomization from (track - an animation track):
	now track is not animation-randomized.

[The following "fit" rule is intended only for reel and parameterized reel tracks; it allows us to change the length of a reel sequence to a specified number of frames. The animation rule will use the easing of the track to extend or contract the length of the animation using the frames in the original reel. For example, if our original image reel was specified as a list with four entries, and we then fit the sequence to 12 frames using the linear easing rule, each of the four images in the original would be displayed for approximately 3 frames. However, note that, due to rounding errors, this will not always work well, particularly when the original reel sequence specified is short.]
To fit (track - an animation track) sequence into/to (N - a number) frame/frames:
	if the track is reel or the track is parameterized reel: 
		now the cycle-length of the track is N;
		now the animation-length of the track is N;
		#if utilizing animation debugging;
		say "[>console][CA]Track [i][track][/i] was manually fit to a sequence of [N] frames.[<]";
		#end if.


Chapter - The animation rulebook

The animation rules are an object-based rulebook.


Part - Animation preset handling rules

Chapter - Custom animation preset

Section - Animation rule for custom preset
[This is only the most generic rule, advancing the track and printing a simple debugging message.]

Animation rule for a custom animation track (called the track) (this is the minimal custom animation rule):
	#if utilizing animation debugging;
	say "[>console][CA]Processed frame [b][current-frame][/b] of [i][track][/i] as a custom animation track.[<]";
	#end if


Section - Invocation phrases for custom preset

To animate (track - an animation track) as a custom animation at (interv - a number), randomized and/or cycling:
	if randomized:
		now the track is animation-randomized;
	otherwise:
		now the track is not animation-randomized;
	if cycling:
		now the track is cycling;
	otherwise:
		now the track is not cycling;
	set up track as custom;
	animate the track at interv[ ms per frame].
	
To animate (track - an animation track) as a custom animation at (interv - a number) with a/-- duration of/-- (len - a number) frame/frames, randomized and/or cycling:
	if randomized:
		now the track is animation-randomized;
	otherwise:
		now the track is not animation-randomized;
	if cycling:
		now the track is cycling;
	otherwise:
		now the track is not cycling;
	now the cycle-length of the track is len;
	set up track as custom with duration len;
	animate the track at interv[ ms per frame].


Chapter - Reel animation preset

Section - Reel animation rule
[The reel animation rule applies to either g-elements (sprites) or to g-canvases (background image). If you supply a graphics g-window to the "animate..." phrase, it will be remapped to the canvas shown in that window.]

First animation rule for a reel animation track (called the track) (this is the default reel animation rule):
	let img be a figure name;
	let x be a number;
	let cyclic-frame be current-frame of the track - (cycles completed of the track * cycle-length of the track);
	if the track is animation-randomized:
		let x be a random number between 1 and the number of entries in the image-reel of the track;
	otherwise if the cycle-length of the track is not the number of entries of the image-reel of the track:
		let x be the easing of the track applied to the cyclic-frame and the cycle-length of the track and 1 and the number of entries of the image-reel of the track;
	otherwise:
		let x be cyclic-frame;
	if x is greater than the number of entries of the image-reel of the track:
		now x is the number of entries of the image-reel of the track;
	now img is entry (x) of the image-reel of the track;
	if the animation-target of the track is a g-element:
		now the image-ID of the animation-target of the track is img;
	otherwise if the animation-target of the track is a g-canvas:
		now the background image of the animation-target of the track is img;
	otherwise if the animation-target of the track is a graphics g-window:
		now the background image of the associated canvas of the animation-target of the track is img;
	#if utilizing animation debugging;
	say "[>console][CA]Processed frame [b][current-frame][/b][if track is cycling] (frame [cyclic-frame] of cycle [cycles completed of the track + 1])[end if] of [i][track][/i] as a reel track targeting [the animation-target of the track]. Image displayed: [img] (entry [x] of the reel)[if the cycle-length of the track is not the number of entries of the image-reel of the track], selected using the [easing of the track] (t: [cyclic-frame], d: [cycle-length of the track], b: [start-x of the track], c: [delta-x of the track])[end if].[<]";
	#end if.	
	

Section - Invocation phrases for reel preset

To animate (track - an animation track) as a reel animation targeting (targ - an object) at (interv - a number), randomized and/or cycling:
	if randomized:
		now the track is animation-randomized;
	otherwise:
		now the track is not animation-randomized;
	if cycling:
		now the track is cycling;
	otherwise:
		now the track is not cycling;
	if the targ provides the property display status:
		now the display status of the targ is g-active;
	now the cycle-length of the track is the number of entries in the image-reel of the track;
	set up track as a reel with duration cycle-length of the track;
	now the animation-target of the track is targ;
	animate the track at interv[ ms per frame].
	
To animate (track - an animation track) as a reel animation targeting (targ - an object) at (interv - a number) with a/-- duration of/-- (len - a number) frame/frames, randomized and/or cycling:
	if randomized:
		now the track is animation-randomized;
	otherwise:
		now the track is not animation-randomized;
	if cycling:
		now the track is cycling;
	otherwise:
		now the track is not cycling;
	if the targ provides the property display status:
		now the display status of the targ is g-active;
	now the cycle-length of the track is the number of entries in the image-reel of the track;
	set up track as a reel with duration len;
	now the animation-target of the track is targ;
	animate the track at interv[ ms per frame].


Chapter - Motion animation preset

Section - Motion animation rule
[The motion animation rule applies to either g-elements or to g-windows. If you supply any other object (including a canvas) to the "animate..." phrase, Inform will print a run-time error (P10) indicating that the object does not have the requisite property.]

First animation rule for a motion animation track (called the track) (this is the default motion animation rule):
	let cyclic-frame be current-frame of the track - (cycles completed of the track * cycle-length of the track);
	let xx be a number;
	let yy be a number;
	if the animation-target of the track provides the property endpoint:
		let xx be entry 1 of the endpoint of the animation-target of the track - entry 1 of the origin of the animation-target of the track;
		let yy be entry 2 of the endpoint of the animation-target of the track - entry 2 of the origin of the animation-target of the track;
	if the delta-x of the track is not 0:
		now entry 1 of the origin of the animation-target of the track is the easing applied to the cyclic-frame and the cycle-length of the track and the start-x of the track and the delta-x of the track;
	if the delta-y of the track is not 0:
		if the secondary easing of the track is not the null easing rule:
			now entry 2 of the origin of the animation-target of the track is the secondary easing applied to the cyclic-frame and the cycle-length of the track and the start-y of the track and the delta-y of the track;
		otherwise:
			now entry 2 of the origin of the animation-target of the track is the easing applied to the cyclic-frame and the cycle-length of the track and the start-y of the track and the delta-y of the track;
	if the animation-target of the track provides the property endpoint:
		now entry 1 of the endpoint of the animation-target of the track is entry 1 of the origin of the animation-target of the track + xx;
		now entry 2 of the endpoint of the animation-target of the track is entry 2 of the origin of the animation-target of the track + yy;
	#if utilizing animation debugging;
	say "[>console][CA]Processed frame [b][current-frame][/b][if track is cycling] (frame [cyclic-frame] of cycle [cycles completed of the track + 1])[end if] of [i][track][/i] as a motion track targeting [the animation-target of the track], using the [easing of the track] (t: [cyclic-frame], d: [cycle-length of the track], b: [start-x of the track], c: [delta-x of the track])[if the secondary easing of the track is not the null easing rule] and the [secondary easing of the track] (t: [cyclic-frame], d: [cycle-length of the track], b: [start-y of the track], c: [delta-y of the track])[end if]. Origin: {[entry 1 of the origin of the animation-target of the track], [entry 2 of the origin of the animation-target of the track]}.[<]";
	#end if.


Section - Invocation phrases for motion preset	

[Specify movement by points, duration, and timer.]
To animate (track - an animation track) as a motion animation targeting (targ - an object) and ending at (end pt - a list of numbers) at (interv - a number) with a/-- duration of/-- (len - a number) frame/frames, cycling:
	if cycling:
		now the track is cycling;
	otherwise:
		now the track is not cycling;
	now the start-x of the track is entry 1 of the origin of targ;
	now the start-y of the track is entry 2 of the origin of targ;
	now the delta-x of the track is (entry 1 of end pt) -  start-x of the track;
	now the delta-y of the track is (entry 2 of end pt) - start-y of the track;
	now the animation-target of the track is targ;
	if the targ provides the property display status:
		now the display status of the targ is g-active;
	now the cycle-length of the track is len;
	set up track as motion with duration len;
	animate the track at interv[ ms per frame].
	
[Specify movement by points, average velocity, and timer.]
To animate (track - an animation track) as a motion animation targeting (targ - an object) and ending at (end pt - a list of numbers) at (interv - a number) with a/-- velocity of/-- (V - a number) --/unit/units, cycling:
	if cycling:
		now the track is cycling;
	otherwise:
		now the track is not cycling;
	now the start-x of the track is entry 1 of the origin of targ;
	now the start-y of the track is entry 2 of the origin of targ;
	now the delta-x of the track is (entry 1 of end pt) -  start-x of the track;
	now the delta-y of the track is (entry 2 of end pt) - start-y of the track;
	[say "start-x: [start-x of the track]; start-y: [start-y of the track]; delta-x: [delta-x of the track]; delta-y: [delta-y of the track].";]
	let X be the square root of (delta-x of the track * delta-x of the track) + (delta-y of the track * delta-y of the track);
	[say "X: [X]; V: [V].";]
	let len be X / V;
	if len < 1, now len is 1;
	now the animation-target of the track is targ;
	if the targ provides the property display status:
		now the display status of the targ is g-active;
	now the cycle-length of the track is len;
	set up track as motion with duration len;
	animate the track at interv[ ms per frame]. 


Chapter - Zooming animation preset

[The zooming animation rule can apply to g-elements or to windows. Trying to apply it to a canvas will result in its being applied to the window that displays the canvas (actually, to all windows that display the canvas; they will be scaled in the same way that the last created window that displays the window scaled the canvas. Note that scaling the entire window/canvas triggers the use of the "arbitrary scaling factor" of the window (see the Glimmr Canvas-Based Drawing documents).]

Section - Zooming animation rule

First animation rule for a zooming animation track (called the track) (this is the default zooming animation rule):
	let Xx be a number;
	let Yy be a number;
	let targ be the animation-target of the track;
	let cyclic-frame be current-frame of the track - (cycles completed of the track * cycle-length of the track);
	if the asymmetrical scaling option is active and the targ is a g-element:
		let Xx be the easing applied to the cyclic-frame and the cycle-length of the track and the start-x of the track and the delta-x of the track;
		if the secondary easing of the track is not the null easing rule:
			let Yy be the secondary easing applied to the cyclic-frame and the cycle-length of the track and the start-y of the track and the delta-y of the track;
		otherwise:
			let Yy be the easing applied to the cyclic-frame and the cycle-length of the track and the start-y of the track and the delta-y of the track;
	otherwise:
		let Xx be the easing of the track applied to the cyclic-frame and the cycle-length of the track and the start-x of the track and the delta-x of the track;
	let X be (Xx // 10000.0000);[the easing equations give us a number; we need to translate it into a real number to use as a scaling factor]
	if the targ is a g-element and the asymmetrical scaling option is active:
		let Y be (Yy // 10000.0000);
		now the x-scaling factor of the targ is X;
		now the y-scaling factor of the targ is Y;
	otherwise if the targ is a g-element:
		now the scaling factor of the targ is X;
	otherwise if the targ is a g-window:
		now the arbitrary scaling factor of the targ is X;
	if the targ is a g-canvas:
		repeat with win running through graphics g-windows:
			if the targ is the associated canvas of win:
				now the arbitrary scaling factor of win is X;
	#if utilizing animation debugging;
	say "[>console][CA]Processed frame [b][current-frame][/b][if track is cycling] (frame [cyclic-frame] of cycle [cycles completed of the track + 1])[end if] of [i][track][/i] as a zooming track targeting [the targ], using the [easing of the track] (t: [cyclic-frame], d: [cycle-length of the track], b: [start-x of the track], c: [delta-x of the track])[if the secondary easing of the track is not the null easing rule] and the [secondary easing of the track] (t: [cyclic-frame], d: [cycle-length of the track], b: [start-y of the track], c: [delta-y of the track])[end if]. [if the asymmetrical scaling option is not active or the targ is a g-canvas]Scaling factor: [scaling factor of the targ][otherwise]X-scaling factor: [x-scaling factor of the targ]; y-scaling factor: [y-scaling factor of the targ][end if].[<]";
	#end if.


Section - Invocation phrase for zooming preset
	
To animate (track - an animation track) as a zooming animation targeting (targ - an object) and ending at (x-end - a real number) at (interv - a number) with a/-- duration of/-- (len - a number) frame/frames, cycling:
	let x-start be a real number;
	let y-start be a real number;
	if cycling:
		now the track is cycling;
	otherwise:
		now the track is not cycling;
	now the animation-target of the track is targ;
	if the targ is a g-element:
		now the display status of the targ is g-active;
		if the asymmetrical scaling option is active:
			let x-start be the x-scaling factor of targ;
			let y-start be the y-scaling factor of targ;
		otherwise:
			let x-start be the scaling factor of targ;
	if the targ is a g-canvas:
		repeat with win running through graphics g-windows:
			if targ is the associated canvas of win:
				now the arbitrary scaling factor of win is the scaling factor of win;
				now the x-start is the arbitrary scaling factor of win;
	if the targ is a g-window:
		let x-start be the scaling factor of targ;
	now the start-x of the track is (x-start ** 10000) as an integer;
	now the delta-x of the track is ( (x-end -- x-start) ** 10000) as an integer;
	if the targ is a g-element and the asymmetrical scaling option is active:
		now the start-y of the track is (y-start ** 10000) as an integer;
		now the delta-y of the track is the delta-x of the track;	
	[say "start-x: [start-x of the track]; delta-x: [delta-x of the track].";]
	now the cycle-length of the track is len;
	set up track as zooming with duration len;
	animate the track at interv[ ms per frame].


Chapter - Flicker animation preset

Section - Flicker animation rule
[The flicker animation rule can apply to g-elements or to canvases. Applying it to a window will result in its being applied to the canvas shown in that window.]

First animation rule for a flicker animation track (called the track) (this is the default flicker animation rule):
	let g-toggled be false;
	if the track is animation-randomized and a random chance of 50 in 100 succeeds:
		toggle animation-target of the track for the track;
		let g-toggled be true;
	otherwise if current-frame of the track is odd:
		toggle animation-target of the track for the track;
		let g-toggled be true;
	#if utilizing animation debugging;
	say "[>console][CA]Processed frame [b][current-frame][/b][if track is cycling] (frame [current-frame of the track - (cycles completed of the track * cycle-length of the track)] of cycle [cycles completed of the track + 1])[end if] of [i][track][/i] as a flicker track targeting [the animation-target of the track] (display status [if g-toggled is true]toggled[otherwise]unchanged[end if]).[<]";
	#end if.
	
To toggle (O - an object) for (track - an animation track):
	if O provides the property display status:
		if the display status of O is g-active:
			now the display status of O is g-inactive;
		otherwise:
			now the display status of O is g-active;
	if O is a g-window:
		toggle canvas for O of track;
	if O is a g-canvas:
		repeat with target running through graphics g-windows:
			if O is the associated canvas of target:
				toggle canvas for target of track.

To toggle canvas for (win - object) of (track - animation track):
	if the associated canvas of win is g-null-canvas:
		now the associated canvas of win is the target-canvas of the track;
	otherwise:
		now the associated canvas of win is g-null-canvas.
				

Section - Invocation phrases for flicker preset
[Flicker-animating a canvas and flicker-animating a window are nearly, but not quite, the same thing. Whatever canvas is shown in a targeted window will blink on and off. When a canvas is targeted, though, that canvas will be toggled in any and all windows in which it is currently displayed.]

[NOTE: If the canvas is not being displayed in a window when the animation is invoked, it will be necessary to identify it specifically before invoking the animation.]

To animate (track - an animation track) as a flicker animation targeting (targ - an object) at (interv - a number) with a/-- duration of/-- (len - a number) frame/frames, randomized and/or cycling:
	if targ is a graphics g-window:
		now the target-canvas of the track is the associated canvas of targ;
	now the animation-target of the track is targ;
	if randomized:
		now the track is animation-randomized;
	otherwise:
		now the track is not animation-randomized;
	if cycling:
		now the track is cycling;
	otherwise:
		now the track is not cycling;
	set up track as flicker with duration len;
	now the cycle-length of the track is len;
	animate the track at interv[ ms per frame].

To animate (track - an animation track) as a flicker animation targeting (targ - an object) at (interv - a number), randomized and/or cycling:
	set up track as flicker;
	if targ is a graphics g-window:
		now the target-canvas of the track is the associated canvas of targ;
	now the animation-target of the track is targ;
	if randomized:
		now the track is animation-randomized;
	otherwise:
		now the track is not animation-randomized;
	now the track is cycling;[Notice that, with no duration specified, the animation is always a cycling one--otherwise, we'd have only a single frame of flicker]
	now the cycle-length of the track is 1;
	animate the track at interv[ ms per frame].
	

Chapter - Fade animation preset

Section - Fade animation rule

First animation rule for a fade animation track (called the track) (this is the default fade animation rule):
	#if utilizing animation debugging;
	say "[>console][CA]Processed frame [b][current-frame of the track + 1][/b][if track is cycling] (frame [(current-frame of the track + 1) - (cycles completed of the track * cycle-length of the track)] of cycle [cycles completed of the track + 1])[end if] of [i][track][/i] as a fade track targeting [the animation-target of the track].[<]";
	#end if.


Section - Invocation phrase for fade preset
	
To animate (track - an animation track) as a fade animation targeting (targ - an object) and using (fader - a fader overlay) from (fadefrom - a number) %/percent to (fadeto - a number) %/percent at (interv - a number) with a/-- duration of/-- (len - a number) frame/frames, cycling:
	if cycling:
		now the track is cycling;
	otherwise:
		now the track is not cycling;
	now the cycle-length of the track is len;
	now the animation-target of the track is targ;
	if targ is a g-element:
		activate targ;
	if targ is a g-element or targ is a g-window:
		now the associated canvas of the fader is the associated canvas of the targ;
	if targ is a g-canvas:
		now the associated canvas of the fader is the targ;
	now the target-fader of the track is fader;
	let coeff be 100 / (the number of entries in the fader-reel of the fader - 1); 
	now the start-x of the track is (fadefrom / coeff) + 1;
	now the delta-x of the track is ( (fadeto - fadefrom) / coeff ) + 1;
	set up track as fade with duration len;
	now the current-frame of the track is 0;
	animate the track at interv[ ms per frame].	


Section - The fader overlay g-element type

A fader overlay is a kind of g-element.
A fader overlay has a list of figure names called the fader-reel.
The display-layer of a fader overlay is usually 9999.

An animation track has a fader overlay called the target-fader.


Section - Faders block mouse input

The graphlink status of a fader overlay is usually g-active.
The linked replacement-command of a fader overlay is "".


Section - Null-fader
[There must be at least one fader in the world, so we define this one.]

The null-fader is a fader overlay.
	

Section - Fader overlay display rule

Last element display rule for a fader overlay (called the present fader) (this is the default fader display rule):
	repeat with track running through animation-active fade animation tracks:
		if the target-fader of the track is the present fader:
			let fade-reel be the fader-reel of the target-fader of the track;
			let anim-target be the animation-target of the track;
			let cyclic-frame be current-frame of the track - (cycles completed of the track * cycle-length of the track);
			let next-fade be the easing of the track applied to the cyclic-frame and the cycle-length of the track and the start-x of the track and the delta-x of the track;
			if next-fade > the number of entries of the fade-reel, now next-fade is the number of entries of the fade-reel;
			if next-fade < 1, now next-fade is 1;
			repeat with win running through g-present graphics g-windows:
				if the anim-target is win:[target is a window]
					update fade-reel to next-fade for win;
					#if utilizing animation debugging;
					say "[>console][CA][Present fader] (frame [current-frame of the track]): Fader overlay for [win] (full window) updated using fade-reel entry [next-fade], [entry next-fade of the fade-reel].[<]";
					#end if;
				otherwise if the anim-target is the associated canvas of win:[target is a canvas]
					update fade-reel to next-fade for anim-target in win;
					#if utilizing animation debugging;
					say "[>console][CA][Present fader] (frame [current-frame of the track]): Fader overlay for [anim-target] ([win]) updated using fade-reel entry [next-fade], [entry next-fade of the fade-reel].[<]";
					#end if;
				otherwise if the associated canvas of win is the associated canvas of the anim-target:[target is a g-element]
					update fade-reel to next-fade for anim-target in win;
					#if utilizing animation debugging;
					say "[>console][CA][Present fader] (frame [current-frame of the track]): Fader overlay for [anim-target] ([associated canvas of win], [win]) updated using fade-reel entry [next-fade], [entry next-fade of the fade-reel].[<]";
					#end if.
					

Section - Drawing phrases for different element types
					
To update (fade-reel - a list of figure names) to (next-fade - a number) for (win - a g-window):
	draw (entry next-fade of the fade-reel) in (win) at 0 by 0 with dimensions (width of win) by (height of win).
	
To update (fade-reel - a list of figure names) to (next-fade - a number) for (anim-target - a g-canvas) in (win - a g-window):
	draw (entry next-fade of the fade-reel) in (win) at x-offset of win by y-offset of win with dimensions (scaled width of anim-target) by (scaled height of anim-target).
					
To update (fade-reel - a list of figure names) to (next-fade - a number) for (anim-target - a sprite) in (win - a g-window):
	draw (entry next-fade of the fade-reel) in (win) at (win-x of anim-target) by (win-y of anim-target) with dimensions (sprite-x of anim-target) by (sprite-y of anim-target).
	
To update (fade-reel - a list of figure names) to (next-fade - a number) for (anim-target - a primitive) in (win - a g-window):
	if the anim-target provides the property stroke:
		let xx be (min win-x of anim-target or end-x of anim-target) - stroke of anim-target;
		let yy be (min win-y of anim-target or end-y of anim-target) - stroke of anim-target;
		draw (entry next-fade of the fade-reel) in (win) at (xx) by (yy) with dimensions ((max win-x of anim-target or end-x of anim-target) + stroke of anim-target - xx) by ((max win-y of anim-target or end-y of anim-target)  + stroke of anim-target - yy);
	otherwise if the anim-target provides the property end-x:[primitive without a stroke]
		draw (entry next-fade of the fade-reel) in (win) at (win-x of anim-target) by (win-y of anim-target) with dimensions (end-x of anim-target) by (end-y of anim-target).
		
To update (fade-reel - a list of figure names) to (next-fade - a number) for (anim-target - a bitmap-rendered string) in (win - a g-window):
	draw (entry next-fade of the fade-reel) in (win) at (win-x of anim-target - dot-size of anim-target) by (win-y of anim-target - dot-size of anim-target) with dimensions ((length of the anim-target * dot-size of anim-target) + dot-size of anim-target) by ((dot-size of anim-target * font-height of the associated font of anim-target) + dot-size of anim-target).
	
To update (fade-reel - a list of figure names) to (next-fade - a number) for (anim-target - an image-rendered string) in (win - a g-window):
	let margin be background-margin of the associated font of the anim-target real times the calculated scaling factor of the anim-target as an integer;
	let vertical-size be font-height of the associated font of the anim-target real times the calculated scaling factor of the anim-target as an integer;
	draw (entry next-fade of the fade-reel) in (win) at (win-x of anim-target - margin) by (win-y of anim-target - margin) with dimensions (length of the anim-target + margin + margin) by (vertical-size + margin + margin).
	
To update (fade-reel - a list of figure names) to (next-fade - a number) for (anim-target - a bitmap) in (win - a g-window):
	draw (entry next-fade of the fade-reel) in (win) at (win-x of anim-target) by (win-y of anim-target) with dimensions (dot-size of anim-target * number of entries in entry 1 of bitmap-array of anim-target) by (dot-size of anim-target * number of entries in bitmap-array of anim-target).

To update (fade-reel - a list of figure names) to (next-fade - a number) for (anim-target - an image-map) in (win - a g-window):
	draw (entry next-fade of the fade-reel) in (win) at (win-x of anim-target) by (win-y of anim-target) with dimensions (scaled tile-width of anim-target * number of entries of entry 1 of the figure-array of the anim-target) by (scaled tile-height of anim-target * number of entries in the figure-array of the anim-target).


Chapter - Temporalizing animation preset

Section - Temporalizing animation rule

First animation rule for a temporalizing animation track (called the track) (this is the default temporalizing animation rule):
	#if utilizing animation debugging;
	say "[>console][CA]Processed frame [b][current-frame][/b][if track is cycling] (frame [(current-frame of the track) - (cycles completed of the track * cycle-length of the track)] of cycle [cycles completed of the track + 1])[end if] of [i][track][/i] as a temporalizing track.[<]";
	#end if.


Section - Invocation phrases for temporalizing preset
	

To animate (track - an animation track) as a temporalizing animation at (interv - a number) with a/-- duration of/-- (len - a number) frame/frames, cycling:
	if cycling:
		now the track is cycling;
	otherwise:
		now the track is not cycling;
	now the cycle-length of the track is len;
	set up the track as temporalizing with duration len;
	animate the track at interv[ ms per frame].
	
To animate (track - an animation track) as a temporalizing animation at (interv - a number), cycling:
	now the track is cycling;
	set up the track as temporalizing;
	animate the track at interv[ ms per frame].


Part - Parameterized animations


Chapter - Setup

[I7 is currently very bad at dealing with values of unknown type, so there is a lot of hackish rigamarole to set up to make it possible to pass the name of a property into a phrase, then store it for the animation rules to act on.]

Section - Correspondence between property names and numbers
[A relation between a text representation of a property name and the internal property number. The text acts as a handle that we can refer to in code, since there is no way of knowing the property number in advance, and we can't store or ask questions (e.g. if-then) about the I7 representation of the property name.]
	
Property-naming relates one text to one number. The verb to property-name (he property-names, they property name) implies the property-naming relation.

After starting the virtual machine:
	now "image-ID" property-names image-ID converted to a number;
	now "background image" property-names background image converted to a number;
	now "tint" property-names tint converted to a number;
	now "background tint" property-names background tint converted to a number;
	now "origin" property-names origin converted to a number;
	now "endpoint" property-names endpoint converted to a number;
	now "scaling factor" property-names scaling factor converted to a number;
	now "x-scaling factor" property-names x-scaling factor converted to a number;
	now "y-scaling factor" property-names y-scaling factor converted to a number;
	now "arbitrary scaling factor" property-names arbitrary scaling factor converted to a number;
	now "text-string" property-names text-string converted to a number;
	now "linked replacement-command" property-names linked replacement-command converted to a number;
	now "cursor" property-names cursor converted to a number;
	now "line-weight" property-names line-weight converted to a number;
	now "bit-size" property-names bit-size converted to a number;
	now "associated font" property-names associated font converted to a number;
	now "associated canvas" property-names associated canvas converted to a number;
	now "associated tileset" property-names associated tileset converted to a number;
	now "bitmap-array" property-names bitmap-array converted to a number;
	now "tile-array" property-names tile-array converted to a number;
	now "figure-array" property-names figure-array converted to a number.


Section - Phrases for typecasting access to properties

To decide what number is (P - a property) converted to a number: (- {P} -).

To decide whether (O - an object) has property number (P - a number): (- WhetherProvides({O},({P}<attributed_property_offsets_SIZE)&&((attributed_property_offsets-->{P})~=-1),{P}) -).

To store non-block value (V - a value) as property number (P - a number) in (O - an object): (- {O}.{P}={V}; -).

To store block value (V - a value) as property number (P - a number) in (O - an object): (- BlkValueCopy(GProperty(OBJECT_TY,{O},{P}),{V}); -).

To store non-block value at entry (N - a number) of (L - a list of values) as property number (P - a number) in (O - an object): (- WriteGProperty(OBJECT_TY, {O},{P},LIST_OF_TY_GetItem({L},{N})); -)

To store block value at entry (N - a number) of (L - a list of values) as property number (P - a number) in (O - an object): (- BlkValueCopy(GProperty(OBJECT_TY, {O},{P}),LIST_OF_TY_GetItem({L},{N})); -)

To assign non-block value in property (P - a number) of (O - an object) to (PP - a property) of (OO - an object): (- {OO}.{PP}={O}.{P}; -).

To decide what list of numbers is list property (P - a (list of numbers) valued property) of (O - an object):
	(- GProperty(OBJECT_TY,{O},{P})  -)
	
To say property (P - a property):
	(- PrintPropertyName({P}); -)

To say property (N - a number):
	(- PrintPropertyName({N}); -)
				
Chapter - Parametrized reel animation tracks


Section - Animation track properties for reel animations
[We need slots for storage of both the number and the text handle of each property. We also need lists typed for each possible property type, to act as our animation reels.]

An animation track has a number called property-storage.
An animation track has a text called the property-name-storage.

An animation track has a list of glulx color values called the color-reel.
An animation track has a list of lists of numbers called the coordinates-reel.
An animation track has a list of numbers called the numerical-reel.
An animation track has a list of indexed texts called the indexed-text-reel.
An animation track has a list of lists of lists of numbers called the numerical-array-reel.
An animation track has a list of lists of lists of figure names called the image-array-reel.
An animation track has a list of objects called the associated-objects-reel.
An animation track has a list of real numbers called the scaling-reel.


Section - Parametrized reel animation rule

First animation rule for a parameterized reel animation track (called the track) (this is the default parameterized reel animation rule):
	let max-frames be the reel-length appropriate to the track and the property-name-storage of the track;
	let N be a number;
	let cyclic-frame be current-frame of the track - (cycles completed of the track * cycle-length of the track);
	if the track is animation-randomized:
		let N be a random number between 1 and max-frames;
	otherwise if the cycle-length of the track is not max-frames:
		let N be the easing of the track applied to the cyclic-frame and the cycle-length of the track and 1 and max-frames;
	otherwise:
		let N be cyclic-frame;
	if N is greater than max-frames:
		now N is max-frames;
	let T be the property-name-storage of the track;
	if T is "image-ID" or T is "background image":
		store non-block value at entry N of the image-reel of the track as property number (property-storage of the track) in the animation-target of the track;
	if T is "tint" or T is "background tint":
		store non-block value at entry N of the color-reel of the track as property number (property-storage of the track) in the animation-target of the track;
	if T is "scaling factor" or T is "x-scaling factor" or T is "y-scaling factor" or T is "arbitrary scaling factor":
		store non-block value at entry N of the scaling-reel of the track as property number (property-storage of the track) in the animation-target of the track;
	if T is "cursor" or T is "line-weight" or T is "bit-size":
		store non-block value at entry N of the numerical-reel of the track as property number (property-storage of the track) in the animation-target of the track;
	if T is "origin" or T is "endpoint":
		store block value at entry N of the coordinates-reel of the track as property number (property-storage of the track) in the animation-target of the track;
	if T is "text-string" or T is "linked replacement-command":
		store block value at entry N of the indexed-text-reel of the track as property number (property-storage of the track) in the animation-target of the track;
	if T is "associated font" or T is "associated canvas" or T is "associated tileset":
		store non-block value at entry N of the associated-objects-reel of the track as property number (property-storage of the track) in the animation-target of the track;
	if T is "bitmap-array" or T is "tile-array":
		store block value at entry N of the numerical-array-reel of the track as property number (property-storage of the track) in the animation-target of the track;
	if T is "figure-array":
		store block value at entry N of the image-array-reel of the track as property number (property-storage of the track) in the animation-target of the track;
	#if utilizing animation debugging;
	say "[>console][CA]Processed frame [b][current-frame][/b][if track is cycling] (frame [cyclic-frame] of cycle [cycles completed of the track + 1])[end if] of [i][track][/i] as a parameterized reel track targeting the [T] of [the animation-target of the track]. Entry [N] of the reel displayed[if the cycle-length of the track is not max-frames], selected using the [easing of the track] (t: [cyclic-frame], d: [cycle-length of the track], b: [start-x of the track], c: [delta-x of the track])[end if].[<]";
	#end if.
	

Section - Parameterized reel invocation phrases

To animate (track - an animation track) as a parameterized reel animation targeting (P - a value of kind K valued property) of (targ - an object) at (interv - a number) with a/-- duration of/-- (len - a number) frame/frames, randomized and/or cycling:
	let P1 be P converted to a number;
	now the animation-target of the track is targ;
	if the targ provides the property display status:
		now the display status of the targ is g-active;
	if targ has property number P1:
		now the property-storage of the track is P1;
		let X be the text which relates to P1 by the property-naming relation;
		now the property-name-storage of the track is X;
	if randomized:
		now the track is animation-randomized;
	otherwise:
		now the track is not animation-randomized;
	if cycling:
		now the track is cycling;
	otherwise:
		now the track is not cycling;
	now the cycle-length of the track is the reel-length appropriate to the track and the property-name-storage of the track;
	set up track as a parameterized reel with duration len;
	animate the track at interv[ ms per frame].
		
To animate (track - an animation track) as a parameterized reel animation targeting (P - a value of kind K valued property) of (targ - an object) at (interv - a number), randomized and/or cycling:
	let P1 be P converted to a number;
	now the animation-target of the track is targ;
	if the targ provides the property display status:
		now the display status of the targ is g-active;
	if targ has property number P1:
		now the property-storage of the track is P1;
		let X be the text which relates to P1 by the property-naming relation;
		now the property-name-storage of the track is X;
	if randomized:
		now the track is animation-randomized;
	otherwise:
		now the track is not animation-randomized;
	if cycling:
		now the track is cycling;
	otherwise:
		now the track is not cycling;
	now the cycle-length of the track is the reel-length appropriate to the track and the property-name-storage of the track;
	set up track as a parameterized reel with duration cycle-length of the track;
	animate the track at interv[ ms per frame].


Section - Retrieving the length of a reel
[Here we use the text handle for properties to choose the correct reel list and return its length (number of entries).]

To decide what number is the reel-length appropriate to (track - an animation track) and (T - a text):
	if T is "image-ID" or T is "background image", decide on the number of entries in the image-reel of the track;
	if T is "tint" or T is "background tint", decide on the the number of entries in the color-reel of the track; 
	if T is "origin" or T is "endpoint", decide on the the number of entries in the coordinates-reel of the track;
	if T is "scaling factor" or T is "x-scaling factor" or T is "y-scaling factor" or T is "arbitrary scaling factor", decide on the the number of entries in the scaling-reel of the track;
	if T is "text-string" or T is "linked replacement-command", decide on the the number of entries in the indexed-text-reel of the track;
	if T is "cursor" or T is "line-weight" or T is "bit-size", decide on the the number of entries in the numerical-reel of the track;
	if T is "associated font" or T is "associated canvas" or T is "associated tileset", decide on the the number of entries in the associated-objects-reel of the track;
	if T is "bitmap-array" or T is "tile-array", decide on the the number of entries in the numerical-array-reel of the track;
	if T is "figure-array", decide on the the number of entries in the image-array-reel of the track.


Chapter - Parameterized motion tracks

Section - Parameterized motion animation rule

First animation rule for a parameterized motion animation track (called the track) (this is the default parameterized motion animation rule):
	let cyclic-frame be current-frame of the track - (cycles completed of the track * cycle-length of the track);
	let P be the property-storage of the track;
	let xx be a number;
	let yy be a number;
	if the delta-x of the track is not 0:
		let xx be the easing applied to the cyclic-frame and the cycle-length of the track and the start-x of the track and the delta-x of the track;
		if the property-name-storage of the track is "":
			store non-block value (xx) as property number (P) in the animation-target of the track;
		if the property-name-storage of the track is "origin":
			now entry 1 of the origin of the animation-target of the track is xx;
		if the property-name-storage of the track is "endpoint":
			now entry 1 of the endpoint of the animation-target of the track is xx;
	if the delta-y of the track is not 0:
		if the secondary easing of the track is not the null easing rule:
			let yy be the secondary easing applied to the cyclic-frame and the cycle-length of the track and the start-y of the track and the delta-y of the track;
		otherwise:
			let yy be the easing applied to the cyclic-frame and the cycle-length of the track and the start-y of the track and the delta-y of the track;
		if the property-name-storage of the track is "":
			store non-block value (yy) as property number (P) in the animation-target of the track;
		if the property-name-storage of the track is "origin":
			now entry 2 of the origin of the animation-target of the track is yy;
		if the property-name-storage of the track is "endpoint":
			now entry 2 of the endpoint of the animation-target of the track is yy;
	#if utilizing animation debugging;
	say "[>console][CA]Processed frame [b][current-frame][/b][if track is cycling] (frame [cyclic-frame] of cycle [cycles completed of the track + 1])[end if] of [i][track][/i] as a parameterized motion track targeting the [property-name-storage] of [the animation-target of the track], using the [easing of the track] (t: [cyclic-frame], d: [cycle-length of the track], b: [start-x of the track], c: [delta-x of the track])[if the secondary easing of the track is not the null easing rule] and the [secondary easing of the track] (t: [cyclic-frame], d: [cycle-length of the track], b: [start-y of the track], c: [delta-y of the track])[end if].[<]";
	#end if.
	

Section - Invocation phrases for motion on simple values

[Specify movement by points, duration, and timer.]
To animate (track - an animation track) as a parameterized motion animation targeting (P - a value of kind K valued property) of (targ - an object) and ending at (end pt - a number) at (interv - a number) with a/-- duration of/-- (len - a number) frame/frames, cycling:
	let P1 be P converted to a number;
	now the animation-target of the track is targ;
	if targ has property number P1:
		now the property-storage of the track is P1;
		now the property-name-storage of the track is "";
	if cycling:
		now the track is cycling;
	otherwise:
		now the track is not cycling;
	assign non-block value in property P1 of targ to start-x of the track;
	now the start-y of the track is 0;
	now the delta-x of the track is end pt - start-x of the track;
	now the delta-y of the track is 0;
	now the animation-target of the track is targ;
	if the targ provides the property display status:
		now the display status of the targ is g-active;
	now the cycle-length of the track is len;
	set up track as parameterized motion with duration len;
	animate the track at interv[ ms per frame].
	

[Specify movement by points, average velocity, and timer.]
To animate (track - an animation track) as a parameterized motion animation targeting (P - a value of kind K valued property) of (targ - an object) and ending at (end pt - a number) at (interv - a number) with a/-- velocity of/-- (V - a number) --/unit/units, cycling:
	let P1 be P converted to a number;
	now the animation-target of the track is targ;
	if targ has property number P1:
		now the property-storage of the track is P1;
		now the property-name-storage of the track is "";
	if cycling:
		now the track is cycling;
	otherwise:
		now the track is not cycling;
	assign non-block value in property P1 of targ to start-x of the track;
	now the start-y of the track is 0;
	now the delta-x of the track is end pt - start-x of the track;
	now the delta-y of the track is 0;
	let len be ABS (delta-x of the track) / V;
	if len < 1, now len is 1;
	now the animation-target of the track is targ;
	if the targ provides the property display status:
		now the display status of the targ is g-active;
	now the cycle-length of the track is len;
	set up track as parameterized motion with duration len;
	animate the track at interv[ ms per frame].
	

Section - Invocation phrases for motion on coordinates

[Specify movement by points, duration, and timer.]
To animate (track - an animation track) as a parameterized motion animation targeting (P - a value of kind K valued property) of (targ - an object) and ending at (end pt - a list of numbers) at (interv - a number) with a/-- duration of/-- (len - a number) frame/frames, cycling:
	let P1 be P converted to a number;
	now the animation-target of the track is targ;
	if targ has property number P1:
		now the property-storage of the track is P1;
		let X be the text which relates to P1 by the property-naming relation;
		now the property-name-storage of the track is X;
	if cycling:
		now the track is cycling;
	otherwise:
		now the track is not cycling;
	let L be a list of numbers;
	let L be list property P of targ;
	now start-x of the track is entry 1 of L;
	now start-y of the track is entry 2 of L;
	now the delta-x of the track is (entry 1 of end pt) -  start-x of the track;
	now the delta-y of the track is (entry 2 of end pt) - start-y of the track;
	now the animation-target of the track is targ;
	if the targ provides the property display status:
		now the display status of the targ is g-active;
	now the cycle-length of the track is len;
	set up track as parameterized motion with duration len;
	animate the track at interv[ ms per frame].

To animate (track - an animation track) as a parameterized motion animation targeting (P - a value of kind K valued property) of (targ - an object) and ending at (end pt - a list of numbers) at (interv - a number) with a/-- velocity of/-- (V - a number) --/unit/units, cycling:
	let P1 be P converted to a number;
	now the animation-target of the track is targ;
	if targ has property number P1:
		now the property-storage of the track is P1;
		let X be the text which relates to P1 by the property-naming relation;
		now the property-name-storage of the track is X;
	if cycling:
		now the track is cycling;
	otherwise:
		now the track is not cycling;
	let L be a list of numbers;
	let L be list property P of targ;
	now start-x of the track is entry 1 of L;
	now start-y of the track is entry 2 of L;
	now the delta-x of the track is (entry 1 of end pt) -  start-x of the track;
	now the delta-y of the track is (entry 2 of end pt) - start-y of the track;
	let X be the square root of (delta-x of the track * delta-x of the track) + (delta-y of the track * delta-y of the track);
	let len be X / V;
	if len < 1, now len is 1;
	now the animation-target of the track is targ;
	if the targ provides the property display status:
		now the display status of the targ is g-active;
	now the cycle-length of the track is len;
	set up track as parameterized motion with duration len;
	animate the track at interv[ ms per frame].


Chapter - Parameterized zooming tracks

Section - Parameterized zooming rule

First animation rule for a parameterized zooming animation track (called the track) (this is the default parameterized zooming animation rule):
	let cyclic-frame be current-frame of the track - (cycles completed of the track * cycle-length of the track);
	let P be the property-storage of the track;
	let Zz be the easing of the track applied to the cyclic-frame and the cycle-length of the track and the start-x of the track and the delta-x of the track;
	let Z be (Zz // 10000.0000);[the easing equations give us a number; we need to translate it into a real number to use as a scaling factor]
	store non-block value (Z) as property number (P) in the animation-target of the track;
	#if utilizing animation debugging;
	say "[>console][CA]Processed frame [b][current-frame][/b][if track is cycling] (frame [cyclic-frame] of cycle [cycles completed of the track + 1])[end if] of [i][track][/i] as a parameterized zooming track targeting the [property P] of [the animation-target of the track], using the [easing of the track] (t: [cyclic-frame], d: [cycle-length of the track], b: [start-x of the track], c: [delta-x of the track]): [Z].[<]";
	#end if.


Section - Invocation phrase for parameterized zooming 
	
To animate (track - an animation track) as a parameterized zooming animation targeting (P - a value of kind K valued property) of (targ - an object) and ending at (zto - a real number) at (interv - a number) with a/-- duration of/-- (len - a number) frame/frames, cycling:
	let P1 be P converted to a number;
	if cycling:
		now the track is cycling;
	otherwise:
		now the track is not cycling;
	now the animation-target of the track is targ;
	if targ has property number P1:
		now the property-storage of the track is P1;
	if the targ provides the property display status:
		now the display status of the targ is g-active;
	let zfrom be the value stored in property number P1 of targ;
	now the start-x of the track is (zfrom ** 10000) as an integer;
	now the delta-x of the track is ( (zto -- zfrom) ** 10000) as an integer;
	[say "start-x: [start-x of the track]; delta-x: [delta-x of the track].";]
	now the cycle-length of the track is len;
	set up track as parameterized zooming with duration len;
	animate the track at interv[ ms per frame].

To decide what real number is the value stored in property number (P - a number) of (O - an object): (- {O}.{P} -).


Part - Easing equations

[For useful resources on easing, see:

http://www.actionscript.org/forums/showthread.php3?t=5312
http://www.gizma.com/easing/
http://timotheegroleau.com/Flash/experiments/easing_function_generator.htm
http://snippets.dzone.com/posts/show/4005
http://jqueryui.com/demos/effect/easing.html
]

[This phrase extends the number of input parameters to a phrase to 4:]

To decide what N is (function - phrase (value of kind K, value of kind L, value of kind M, value of kind O) -> value of kind N)
	applied to (input - K) and (second input - L) and (third input - M) and (fourth input - O):
	(- {-function-application} -).


Chapter - Easing equations

Section - Null easing

To decide what number is null easing for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the null easing rule):
	decide on 0.


Section - Linear easing
[Equation adapted from http://www.gizma.com/easing/, by Robert Penner]

To decide what number is linear easing for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the linear easing rule):
	decide on ( (c * t) / d ) + b.
	

Section - Quadratic easing
[Equations adapted from http://www.gizma.com/easing/, by Robert Penner]

To decide what number is quadratic easing in for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the quadratic easing in rule):
	let t1 be (t as a fixed point number) // d;
	decide on (c ** t1 ** t1) ++ b as an integer.

To decide what number is quadratic easing out for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the quadratic easing out rule):
	let t1 be (t as a fixed point number) // d;
	decide on ( (0 - c) ** t1 ** (t1 -- 2) ) ++ b as an integer.
	
To decide what number is quadratic easing in-out for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the quadratic easing in-out rule):
	let t1 be (t as a fixed point number) // (d / 2);
	if t1 << 1:
		decide on ((c / 2) ** t1 ** t1) ++ b as an integer;
	let t1 be t1 -- 1;
	decide on (((0 - c) / 2) ** ((t1 ** (t1 -- 2)) -- 1)) ++ b as an integer.


Section - Cubic easing
[Equations adapted from http://www.gizma.com/easing/, by Robert Penner]

To decide what number is cubic easing in for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the cubic easing in rule):
	let t1 be (t as a fixed point number) // d;
	decide on ( (c ** t1 ** t1 ** t1) ++ b ) as an integer.
	
To decide what number is cubic easing out for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the cubic easing out rule):
	let t1 be (t as a fixed point number) // d;
	let t1 be t1 -- 1;
	decide on ((c ** ((t1 ** t1 ** t1) ++ 1) ) as an integer ) + b.
	
To decide what number is cubic easing in-out for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the cubic easing in-out rule):
	let t1 be (t as a fixed point number) // (d / 2);
	if t1 << 1.0000:
		decide on ( (c / 2) ** (t1 ** t1 ** t1) ) ++ b as an integer;
	let t1 be t1 -- 2;
	decide on (( c / 2 ) ** ( (t1 ** t1 ** t1) ++ 2 )) ++ b as an integer.


Section - Circular easing
[Equations adapted from http://www.gizma.com/easing/, by Robert Penner]

To decide what number is circular easing in for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the circular easing in rule):
	let t1 be (t as a fixed point number) // d;
	decide on ((0 - c) ** (sqrt (1 -- (t1 ** t1)) -- 1)) ++ b as an integer.

To decide what number is circular easing out for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the circular easing out rule):
	let t1 be ( (t as a fixed point number) / d ) -- 1;
	decide on (c ** (sqrt (1 -- (t1 ** t1)))) ++ b as an integer.

To decide what number is circular easing in-out for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the circular easing in-out rule):
	let t1 be (t as a fixed point number) // ((d as a fixed point number) / 2);
	if t1 << 1:
		decide on ( (0 -- (c as a fixed point number // 2)) ** (sqrt (1 -- (t1 ** t1)) -- 1) ) ++ b as an integer;
	else:
		let t2 be t1 -- 2;
		decide on ( ((c as a fixed point number // 2)) ** (sqrt (1 -- (t2 ** t2)) ++ 1) ) ++ b as an integer.


Section - Back easing (cubic)
[Equations adapted from http://snippets.dzone.com/posts/show/4005, by Robert Penner]

[We define a "constant" to determine how far back we should go before going forward. The smaller the number, the less the backward motion.]
The back easing parameter is a real number variable. The back easing parameter is usually 1.7016.

To decide what number is cubic back easing in for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the cubic back easing in rule):
	let param be the back easing parameter;
	#if utilizing animation debugging;
	let b1 be b;
	say "[>console][CA]Cubic back easing in: using custom parameter of [param] (change the global variable 'back easing parameter' to adjust).[<]";
	#end if;
	let t1 be (t as a fixed point number) // d;
	decide on (c ** t1 ** t1 ** (((param ++ 1) ** t1 ) -- param)) ++ b as an integer.
	
To decide what number is cubic back easing out for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the cubic back easing out rule):
	let param be the back easing parameter;
	#if utilizing animation debugging;
	let b1 be b;
	say "[>console][CA]Cubic back easing in: using custom parameter of [param] (change the global variable 'back easing parameter' to adjust).[<]";
	#end if;
	let t1 be  ((t as a fixed point number) // d ) -- 1;
	decide on (c ** (1 ++ ( (t1 ** t1) ** ((param ** t1) ++ t1 ++ param) ))) ++ b as an integer.

To decide what number is cubic back easing in-out for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the cubic back easing in-out rule):
	#if utilizing animation debugging;
	let b1 be b;
	say "[>console][CA]Cubic back easing in-out: using custom parameter of [back easing parameter] (change the global variable 'back easing parameter' to adjust).[<]";
	#end if;
	let t1 be  ( (t as a fixed point number) // ( (d as a fixed point number) // 2 ) );
	let param1 be the back easing parameter ** 1.5250;
	[if t1 << 1:
		decide on ((((c as a fixed point number) // 2) ** t) ** t ** (((param1 ++ 1) ** t) -- param1) ) ++ b as an integer;]
	if t1 << 1:
		decide on ( (2 * b) ++ ((c ** t1 ** t1) ** ((param1 ** ( t1 -- 1)) ++ t1) )) // 2 as an integer;
	else:
		let t2 be t1 -- 2;
		decide on b ++ ((c ** (2 ++ ((t2 ** t2) ** (param1 ++ t2 ++ (param1 ** t2))))) // 2) as an integer.


Section - Parabolic bounce easing
[Equations adapted from http://snippets.dzone.com/posts/show/4005, by Robert Penner]

To decide what number is bounce easing out for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the bounce easing out rule):
	let t1 be (t as a fixed point number) // d;
	if t1 << 0.3636:
		decide on ( ( c ** (7.5625 ** t1 ** t1) ) ++ b ) as an integer;
	if t1 << 0.7272:
		let t1 be t1 -- 0.5454;
		decide on ( c ** ((7.5625 ** t1 ** t1) ++ 0.7500) as an integer ) + b;
	if t1 << 0.9090:
		let t1 be t1 -- 0.8181;
		decide on ( c ** ((7.5625 ** t1 ** t1) ++ 0.9375) as an integer) + b;
	let t1 be t1 -- 0.9545; 
	decide on ( c ** ((7.5625 ** t1 ** t1) ++ 0.9844) as an integer) + b.
	
To decide what number is bounce easing in for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the bounce easing in rule):
	decide on c - (bounce easing out for time (d - t) duration (d) beginning (0) change (c) ) + b.
	
To decide what number is bounce easing in-out for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the bounce easing in-out rule):
	if t < (d / 2):
		decide on (((bounce easing in for time (t * 2) duration (d) beginning (0) change (c) ) ** 0.5000 ) as an integer) + b;
	otherwise:
		decide on ((((bounce easing out for time ((t * 2) - d) duration (d) beginning (0) change (c) ) ** 0.5000) ++ (c ** 0.5000) ) as an integer) + b.


Glimmr Canvas Animation ends here.


---- DOCUMENTATION ----

Glimmr Canvas Animation (GCA) extends Glimmr Canvas-Based Drawing, allowing for graphic elements of any type to be animated. GCA includes a number of presets that make even complex animations a matter of just a few lines of code, including motion, flipbook-style, zooming, flickering, and more. There is also support for "tweening", using a number of different easing equations (authors can also add their own). Authors can also create completely custom animation routines that do whatever they like.

Section: The state of animation in Glulx

Glulx has no built-in animation support. Instead, animation is achieved through what is essentially a hack: we start a repeating timer, and every time that timer "ticks", we update the display. Unlike true game animation engines, which skip frames to maintain the timing when the processor is unable to realize the requested framerate, Glulx simply skips timer ticks: every frame of the animation will be shown, and the animation will simply unfold more slowly than intended if the processor can't keep time.

Moreover, the Glulx timer is explicitly not intended to be perfectly reliable. Some interpreters have better timer implementations than others, and combined with performance variability in graphics drawing and other operations, this means that the precise performance of a given animation is not guaranteed to be the same on different Glulx virtual machines.

Finally, many standard graphical effects are not provided in Glulx. Glulx does allow for images to be scaled, but we cannot dynamically rotate a sprite, for example, nor can we affect the opacity of an image. There are labor-intensive ways to at least partially get around these (basically, create multiple versions of each sprite, at different opacities or rotations), but they are limiting. 

Despite all this, animation in Glulx can still work pretty well, as long as we keep things simple and don't expect *too* much from the system. We will also want to test our game on a few different interpreters and systems before releasing it to the world--if it works better in some 'terps than others, we want to be able to communicate that to players.

The timer approach to animation makes simple animations fairly easy to write, especially when combined with the object-oriented approach taken by Glimmr Canvas-Based Drawing. For example, even without this Canvas Animation extension, we would be able to animate "zooming in" on an image with just a few lines. GCA, however, leverages Glimmr Canvas-Based Drawing to provide a number of different animation presets, so that something like this can be invoked with just a single line of code. GCA also provides the ability to use "easing" equations to influence the time-curve of animated movement. GCA's concept of the "animation track" allows you to write your own animation rules, and even to animate text or game events rather than graphics.


Chapter: Including Glimmr Canvas Animation in a project

Inform remains fairly unsophisticated in its mechanisms for organizing included extensions. When we are dealing with a complex system of modular extensions such as Glimmr, it is very easy to trip it up, and the result is usually a list of unhelpful errors. For this reason, each Glimmr extension includes a section--such as this one--about how to include it, particularly in relation to other extensions.

Glimmr Canvas Animation automatically includes Glimmr Canvas-Based Drawing, Glimmr Drawing Commands, Flexible Windows, Fixed Point Maths, Undo Output Control, and their dependencies. You do not need to include any of these extensions explicitly in your story file; GCA will include them automatically (provided they are installed with your copy of Inform, of course).

If you are using Glimmr Graphic Hyperlinks you MUST include it before Glimmr Canvas Animation. Conversely, you must include any Glimmr font, tileset, or fader extensions after GCA. For example:

	*: Include Glimmr Graphic Hyperlinks by Erik Temple.
	Include Glimmr Canvas Animation by Erik Temple.
	Include Glimmr Image Font by Erik Temple.


Section: A note on compatibility

Glimmr Canvas Animation uses a rudimentary system of "virtual timers" to enable animations to run at different speeds despite the fact that Glulx has only a single timer. This means that GCA is probably incompatible with any other real-time extension, at least if we are hoping to track real-time and animation events at the same time. 


Chapter: Getting started with Glimmr Canvas Animation

Before you can do any work with Glimmr Canvas Animation, you will need to set up at least one graphics window in your project. Please refer to the documentation for Jon Ingold's Flexible Windows extension for more information. You can also copy the window-related code from the examples in GCA if you just want to get started quickly.

Once you have a graphics window, you will also need to set up a Glimmr canvas and add some graphics elements--that way you'll have something to animate! See the Glimmr Canvas-Based Drawing extension for instructions and a number of examples. Of course, you can also just plunder the examples in GCA if you just want to get a feel for how things work.

Next, you will create one or more "animation tracks". Each track controls a single animation effect acting on a single graphics object (either a single sprite, a canvas, or an entire window's display). Multiple tracks can run at the same time; for example, one track might move an image across the screen, while the other makes it smaller and smaller until it disappears. Creating a track is as simple as:

	The movement track is an animation track.
	
To actually make that track do something, apply an animation preset to it via a phrase like this, placed in the rule that you want to trigger the animation:

	animate the movement track as a motion animation targeting My Sprite and ending at {500, 100} at 250 milliseconds per frame with a duration of 12 frames

That is all that is required to create a 12-frame animation that moves the sprite from its current position to coordinate (500, 100). The extension will automatically update the graphics window or windows involved, and will stop the timer when all animations have finished.

Some animations will require a bit more setup. For example, a reel animation requires you to predefine a list of the images to be shown:

	The image-reel of the flipbook track is {Figure 1, Figure 2, Figure 3, Figure 5, Figure 4}.
	
Many types of GCA animation also allow you to specify "easing" to adjust the speed, timing, or even path of motion (see http://glimmr.wordpress.com/2011/06/11/animation-demo-series-2/ for an introduction to easing). This is completely optional, and is again accomplished with a single line, e.g.:

	The easing of the movement track is the cubic easing out rule.

See the appropriate sections below for more information on animation tracks, the animation presets available and how to invoke them, easing (also known as tweening), and other topics. There are also a number of in-depth examples at the end of this documentation. More discussion of some of the examples can also be found at glimmr.wordpress.com:

	http://glimmr.wordpress.com/2011/06/05/glimmr-animation-series-1/
	http://glimmr.wordpress.com/2011/06/11/animation-demo-series-2/
	http://glimmr.wordpress.com/2011/06/23/animation-demo-series-3/


Chapter: Animation and the timer

Animations are controlled by the Glulx virtual machine's timer functionality. The Glulx timer is global--there is only one "ticker"--but GCA uses "virtual timers" to allow simultaneous animations to run at different speeds. 

When only one animation is running, or when all running animations are running at the same rate, then each tick of the global timer represents one "frame" of animation. When we specify multiple rates of animation, however, GCA works out how to subdivide the timer interval so that each animation fires at the requested rate. For example, if we trigger Animation A at 80 milliseconds per frame, and Animation B at 160 milliseconds per frame, then the timer will fire at 80 milliseconds per frame, with Animation A firing every frame, and Animation B every 2 frames.

Users of Glimmr Canvas Animation's animation tracks will rarely if ever need to deal with the timer directly, as the commands for invoking animation tracks automate the process. If needed, though, we can find out what the current interval between ticks of the global timer is by referring to the "global timer interval" global variable (the timer for any given animation track can be got at by checking the "timer interval" property of the track):

	say "The interval between ticks is [global timer interval] milliseconds."

The "global timer interval" variable is dynamic: it only contains a value when there is a timer running, and resets to zero when the timer stops. Note that we should *never change* the variable directly; doing so will not change the interval. If we want to set a new interval, we simply need to invoke an animation track, or change the timer directly, like so:

	start a Glulx timer of 200 milliseconds

Any time we start a new timer, GCA will look at any animations that may be running and adjust the rate we've requested to maintain their rates. It is probably best never to set the timer directly when animations are involved--just use the "animate..." phrases, detailed below, to trigger animations.
		
The timer can, of course, run independently of animations. If we want to use the timer for some other purpose in our game, we are welcome to simply start the timer using the same phrase, without using an animation preset. Animations are not activated unless we specifically start them with an animation phrase. It is not a good idea to try to use timed events for other purposes while animations are running--when animations are running, the virtual timer system is invoked, which may cause unpredictability in timed behaviors that don't take that system into account. You can study the source code to see how you might take the system into account, but the easiest way to deal with the situation is to use custom animation tracks--see the chapter on custom animation below--to control all of your non-graphical timed events. This will allow them to use the virtual timer system.

To stop *all* running timers, use:

	pause the Glulx timer

Warning: This will stop the timer, but any animations that are running will still be marked as active. If you start another timer, they will begin again, and they will also be factored into the virtual timer system.


Section: Implementation details

At each tick of the timer, Inform calls the "glulx timed activity" rulebook (provided by Emily Short's Glulx Entry Points extension). If one or more of our animation tracks is active, the "animation dispatch rule", one of the timed activity rules, will fire. This rule iterates through all of the active animation tracks, processing each in turn. This processing occurs in the "animation" rulebook. Most users will not need to add rules to the animation rulebook, but it is necessary to do so to create custom animations (see below), and it can sometimes be useful if we wish to trigger other events from within preset animations, rather than via callbacks at the end. See the "Animation Rule Variations" example below for some illustrations.

Note that the rules in the animation rulebook are intended for making changing to the properties of targeted objects/elements, not for actually drawing to the screen. Once all of the tracks have been processed, the "updating graphics windows for animation" activity is called. There is only one rule in this activity, the "animation window-updating rule", which updates the graphics in each of the open graphics windows. If we have a number of static graphics windows alongside one with animation, we can improve performance by preempting this rule with one of our own that updates only the window with animations. (Otherwise, we are needlessly redrawing all windows every tick of the timer.)


Section: Undo, Save, Restore

GCA handles undo and restore transparently:

	UNDO - The Inform library saves the state of the game just before getting input, at the beginning of a new turn. When the player types UNDO, the game will resume where it was when the state was saved, with any animations picking up exactly where they were.

	SAVE - Inform saves the game at the moment that the player confirms the intention to save the game. Again, when the game is restored, GCA will pick up exactly where it left off.

Implementation note:

The Glulx virtual machine does not store the state of the timer when saving the state of the game. That means that we need to do that ourselves in order to properly restore the game or undo a previous turn. GCA takes care of this for us by storing the timer interval in a global variable, and then either triggering the timer at the appropriate speed or turning it off as appropriate immediatedly after restoring or undoing. If we are making changing to save/restore, the after restoring the game rules, or undo code, we should be sure that we don't break this functionality.

Glimmr Canvas Animation uses the Undo Output Control extension to manage the timer after UNDO. If you are using Ron Newcomb's Custom Library Messages or Default Messages extensions, however, you can simply include "[@ reset the Glulx timer]" in the text of your undo report message to manage the same thing. If you'd rather do this, include the following code block in your game, and you won't need Undo Output Control.

	*: Section - Reset timer after UNDO (in place of Section - Restart the timer after undoing in Glimmr Canvas Animation by Erik Temple)

	table of custom library messages (continued)
	library-action (action-name) 	library-message-id (number)	library-message-text (text)
	--		13	"[@ reset the Glulx timer][bracket]Previous turn undone.[close bracket]"


Chapter: Animation tracks

GCA simplifies the specification of animations through the concept of the "animation track". An animation track handles one and only one kind of animation effect for one and only one graphic element. However, tracks are "stackable"--you can run multiple tracks simultaneously--so you can build up very complex animations. To display a person walking, for example, you might have two tracks running simultaneously, one responsible for the motion of the sprite from point A to B, and the other for cycling the image used to represent the sprite.

Animation tracks can also do such things as increase or decrease the scaling factor of an element ("zooming" it), fade an element or the entire canvas out to a background color, or simply mark time. 


Section: Basics of animation tracks

In programming terms, an animation track is an Inform 7 object, not too different from the "things" that authors use to build their storyworlds. However, they are not intended to be physical game objects; they are simply convenient containers for storing and organizing information, usually in the form of properties. (Users of Glimmr Canvas-Based Drawing will recognize the same concept in the use of g-elements, which are also objects in the same sense.) Defining an animation track is quite simple. Here we do two at a stroke:

	The movement track and the walking track are animation tracks.

Rather than requiring us to set each of the relevant properties individually, GCA allows us to use an abbreviated, single-phrase command to set up and trigger each animation track, by using animation presets. The code for the walking animation mentioned above might look like this, for example:

	animate the movement track as a motion animation targeting the Walker and ending at {300, 100} at 12 fps with duration of 24 frames;
	animate the walking track as a reel animation targeting the Walker at 12 fps with duration of 24 frames, cycling.

Note the reference to "motion" and "reel"--these are two of the types of animation preset provided by GCA. Motion tracks animate the movement of an element across the canvas/window, while reel tracks change the image used to display the element. See the sections that detail the different presets below. 

Some circumstances will require us to manually set properties of the track in addition to the command. For example, all reel tracks require us to specify the list of images that make up the "reel" that will be displayed. Here is the full code required to set up a reel animation:

	The waving track is an animation track. The image-reel of the waving track is {Figure of Hand Left, Figure of Hand Right}.

	Instead of waving hands:
		animate the waving track as a reel animation targeting the player avatar at 4 fps with duration of 6 frames.

This will animate the reel for 6 frames at a rate of 4 frames per second; that is, with a timer tick every 250 milliseconds. Each frame, the image used to display the sprite element we have called "player avatar" will change according to the image-reel list we have defined. Note that since the reel has only two images in it, the track will select the first figure for 1 frame, and the second figure for 5 frames. If we want to repeat the reel after reaching the end, we add the "cycling" option:

	animate the waving track as a reel animation targeting the player avatar at 4 fps with duration of 6 frames, cycling.

This will repeat through the reel for each pair of frames, producing a smooth alternation of the figures: Figure of Hand Left, Figure of Hand Right, Figure of Hand Left, Figure of Hand Right, Figure of Hand Left, Figure of Hand Right.  More information on the cycling option is given below.

Note that the timer is started *immediately* after an animate phrase is invoked. The animation will begin after one interval has passed. In other words, the first frame of the animation will be displayed after one tick of the timer; if we have specified an interval of 4 frames per second, the first frame will be displayed 250 milliseconds after Inform processes the animation phrase.

To summarize, the basic steps for defining an animation are:

	1) Declare the track object: "X is an animation track"
	2) Set up any auxiliary properties that need setting up, e.g. "The image-reel of X is {....}"
	3) Invoke the track using the encapsulated command: "animate X as a..."

Tracks are fully recyclable, meaning that once a track is done running, we can invoke it again with a totally different set of parameters. We can even change the type of the animation if we wish, e.g.:

	animate the default track as a motion animation...
	(later...)
	animate the default track as a reel animation...

Unless we are obsessed with efficiency, though, it probably isn't the best idea to reuse a track for a totally different purpose in this way. It won't be quite as easy to read the code later. Study the "Scourge of the Vampyr" example to see how multiple tracks can be used alone and together to both organize and control animations.

GCA includes one pre-declared animation track, called the "default track". We can make use of this track or not in our own game as we like.

See below for the different types of animation preset, the commands used to invoke them, and brief usage examples.


Section: Animation callbacks

A callback is a function that fires once the animation has finished. Callbacks can in principle do anything: start or start another animation track, play a sound, print some text, etc. An animation track can have one or more associated callback routines associated. 

At first glance, the implementation of callbacks in GCA may seem a bit odd, and in fact it is something of an experiment. Rather than assign a rule to be fired, we use a text, stored in the track's "animation-callback" property. At its simplest, this just means that we print a text when the animation completes, e.g.:

	The animation-callback of the default track is "Whew!"
	
But thanks to a little trick from John Clemens (http://www.math.psu.edu/clemens/IF/I7tricks.html), we can actually invoke standard Inform phrase functions, like so:

	 The animation-callback of the default track is "[@ animate the default track as a reel animation targeting the player-avatar at 6 frames per second]".

The "@" indicates that Inform should read the text substitution that follows as a phrase to be executed. We can chain all this stuff together, e.g.:

	The animation-callback of the default track is "The wheel reverses direction[@ now the image-reel of the Wheel is the reverse-reel][@ animate the default track as a reel animation targeting the Wheel at 8 frames per second]."

The ability to combine straight printing, "to say" phrases, and standard function phrases in a single statement makes for a compact and flexible approach to callback functions.

Note that we are bound by the usual restrictions on the content of text substitutions. In particular, they cannot contain commas or brackets of any type, which means that we will need to define intermediary phrases in order to refer to Glimmr coordinates or to provide phrase options, which are separated from their phrase by a comma.  


Section: Delaying input until animations finish

By default, animations will continue to run while other game functions are operating--the player will be free to continue typing commands and so on while animation in underway. Sometimes, though, we may want to pause the textual part of our game while an animation plays out. We can do this with one of two different commands:

	delay input until all animations are complete
	delay input until <track> is complete
	
These phrases prevent the game from asking for commands from the player until either *all* animations have completed (the first phrase), or until a specific animation has completed (the second phrase).

The best place to place a delay instruction is usually immediately after the "animate" lines it is associated with. For example:

	animate the walking track as a reel animation targeting the player-sprite at 8 fps, cycling;
	animate the waypoint movement track as a motion animation targeting the player-sprite and ending at {421, 242} at 8 fps with velocity of 10;
	delay input until all animations are complete;
	say "Done!".

The game will pause immediately, and only code that fires due to animation, or to other timer events, will be run. The say phrase at the end of the block of code above will not print until the animation has completed.


Section: Manually activating and deactivating tracks

An animation track can be turned on or off manually using the following phrases. The most likely use for this functionality is to pause and restart one track while other animations are running.

	activate <track>
	deactivate <track>

Note that the timer must *also* be running for a track so activated to actually run. We can find out whether any of our animation tracks is flagged as active by using:

	if animation is queued...

We can test whether a *given track* is currently active by looking at its "animation-flag" property, which can be either "g-active" or "g-inactive":

	if the animation-flag of the default track is g-active...

If we need to, we can ask whether there are any *currently running* animations, using this phrase:

	if animation is underway...

This will return true only if an animation is flagged as active *and* the timer is running.

We can change the speed of an animation once it is already underway:

	time <track> at <interval> milliseconds

This should *only* be done when the animation is already running. It will adjust the global timer to utilize the newly selected speed.

Another useful phrase is "cease animating <track>", which like "deactivate <track>", will immediately stop the indicated track. However, the latter merely stops the track, while the former also fires the callback of the track that was stopped. For example, if Track A moves an object to a given point while Track B cycles through a short sequence, we could use either phrase to as a callback on Track A to stop Track B. However, only the "cease animating" phrase will also fire Track B's callback:

	Track A is an animation track. The animation-callback is "[@ cease animating Track B]".
	Track B is an animation track. The animation-callback is "All done."


Section: Changing track modalities

We can force a track into cycling or randomizing--or stop either of those modalities--once the animation is already running. Most often, we will do this via a callback routine, though we could also do it in response to player input. For example, we could cycle one animation until another animation completes. The second animation would then send a callback to the first to tell it to stop cycling.

The phrases required are straightforward:

	cycle <track>
	stop cycling <track>
	
	randomize <track>
	remove randomization from <track>


Chapter: Animation track presets

Each animation track will trigger a different rule from the "animation" rulebook, depending on the preset that is associated with it. For example, the "zooming" preset triggers the "default zooming animation rule", which will, for each frame of the animation, set the scaling factor of the target element to an appropriate value.

The specific parameters available for each track preset are laid out in the sections below, but the basic form for the invocation of an animation track is this:

	animate <animation track> as a <preset> animation targeting the <target> ... at <interval> with a duration of <length> frames, <options>

The items in angle brackets are present in nearly all of the commands; here are quick explanations for each of them:

	preset - this is the type of the animation, e.g. motion, reel, zooming, etc.

	target - this is the object that will be affected by the animation. Usually, this will be a graphic element, but it might also be the canvas itself, or the window framing the canvas (see the individual presets below for more information).

	interval - this is the time between frames. It can be expressed either by specifying it directly, e.g. "200 milliseconds per frame", or by providing the frames per second we desire, e.g. "12 frames per second" or just "12 fps".

	length - the number of frames in the animation. Note that this term is optional for some types of preset. If we don't specify a length for these presets, the animation will be automatically set to the most likely .

	options - we can add one or more options, depending on the type of preset; see the next section. 

As you read the following sections, you may also want to refer to the documentation for Glimmr Canvas-Based Drawing for a refresher on graphic element types and their properties.


Section: Track options

There are two track options that we can select by adding a comma and the option or options after the body of the command phrase, like so:

	animate..., cycling and randomized

These options are defined as follows:

	cycling - an animation track that has been designated as cycling will not stop when it reaches the end; instead, it will begin again at the beginning.

	randomized - a randomized track will select the state of any given frame at random from the available options.

Note that any animation track can be cycling, but tracks that involve smooth movement (such as motion or zooming tracks) cannot be randomized.


Section: Frames, cycles, and duration

Animation tracks keep an accounting of their own states. We will rarely need to access this information, but should we need to, we can refer to these properties of any given track:

	current-frame - a number that indicates how many frames, in total, an animation has passed through.

	animation-length - the duration (in frames) that the track will run before finishing.

	cycle-length - the number of frames in a single cycle of the animation. If the animation is not cycling, this will be the total duration specified for the animation.

	cycles completed - the number of cycles of the animation that have been completed.

GCA does not store the frame of the current cycle, but it can be calculated as follows:

	let cyclic-frame be the current-frame of the track - (cycle-length of the track * cycles completed of the track)


Chapter: Standard track presets

Detailed descriptions of the track presets are given below, including the types of objects that they can act on, their effects, the phrases used to create/invoke them, and examples of usage. 


Section: Reel animation tracks

"Reel" tracks show a succession of images in a way similar to that of traditional animation on film, or the animated GIFs familiar from the web. The sequence of images to be shown is specified using a list of figure names assigned to the track's "image-reel" property. Reel tracks can function only with entities that display a single image at a time, and thus we are limited to targeting:

	sprites (g-element)
	g-canvas (affecting the background image of the canvas)

(But see the "parameterized reel" preset below, which lets us define a reel for any display property of any kind of g-element, canvas, or g-window.)

The reel must be defined in advance of triggering the animation track; this is done by setting the "image-reel" property of the animation track object to a list of figure names. (We can repeat figure names in the list to show the figure a second time; this can be used to provide pacing.)

To invoke a reel preset we use the following phrase:

	animate <track> as a reel animation targeting <target> at <interval> with a duration of <length> frames, <cycling><randomized>

If we wish, we may omit the duration, resulting in this variant phrasing: 

	animate <track> as a reel animation targeting <target> at <interval>, <cycling><randomized>

If we do this, the duration will be set automatically to the number of entries in the image-reel. Moreover, if we also set the "cycling" option when no duration has been set, the track will continue to repeat ad infinitum, or until stopped by another event (such as a callback from another track; see the section on callbacks below).

The images in the image-reel list will be shown in order, unless we set the "randomized" option for a reel track, in which case an image will be chosen at random from the reel for each frame. (We can of course include multiple mentions of the same figure to influence percentages; if Figure 1 is listed twice in the reel while Figure 2 is listed just once, then the chance that Figure 1 will be displayed is twice as great as the chance that Figure 2 will be.)

Here are some examples of usage (code snippets, not complete games):

Targeting a sprite, showing each frame in the reel just once:
	*: The leaping track is an animation track.

	The image-reel of the leaping track is {Figure of Leap 01, Figure of Leap 02, Figure of Leap 03, Figure of Leap 04}.

	The Frog is a sprite. The image-ID is Figure of Frog Sitting.

	Instead of jumping:
		animate the leaping track as a reel animation targeting the Frog at 200 milliseconds per frame with a duration of 4 frames.

Targeting a canvas and using the shorter form. Note that because the "cycling" option is set and there is no duration specified, this track will repeat endlessly:
	*: The swirling track is an animation track.

	The image-reel of the swirling track is {Figure of Swirl 01, Figure of Swirl 02, Figure of Swirl 03, Figure of Swirl 04, Figure of Swirl 05}.

	The background image of the graphics-canvas is Figure of Still Water.

	When play begins:
		animate the swirling track as a reel animation targeting the graphics-canvas at 12 frames per second, cycling.

Reel tracks normally are not affected by setting the easing equations. However, if AFTER using the animate phrase we reset the length of the animation cycle so that it is not equal to the number of entries in the image-reel, easing will be used to reconcile the two. Effectively, the easing equation will describe how time will be "stretched" to fit the reel. The animation rule will use the easing of the track to extend or contract the length of the animation using the frames in the original reel. For example, if our original image reel was specified as a list with four entries, and we then fit the sequence to 12 frames using the linear easing rule, each of the four images in the original would be displayed for approximately 3 frames. If we are using a rapid in, slow out easing equation, however, then the first entry in the reel list might be displayed for only one frame, while the last might be held for four frames. Note that, due to rounding errors, this will not always work perfectly, particularly when the original reel sequence specified is short. We achieve this effect by using the "fit... sequence to ... frames" phrase:

	fit <track> sequence into/to <length> frame/frames

Extending the example above:

	*: The swirling track is an animation track. The easing of the swirling track is the quadratic easing out rule.

	The image-reel of the swirling track is {Figure of Swirl 01, Figure of Swirl 02, Figure of Swirl 03, Figure of Swirl 04, Figure of Swirl 05}.

	The background image of the graphics-canvas is Figure of Still Water.

	When play begins:
		animate the swirling track as a reel animation targeting the graphics-canvas at 8 frames per second, cycling;
		fit the swirling track sequence to 12 frames.
		
The "fit... sequence to ... frames" phrase works *only* with reel and parameterized reel tracks. It will have unanticipated effects if used with other types of animation track preset.


Section: Motion animation tracks

"Motion" tracks change the origin coordinate of the target object. If we attempt to target an object that doesn't have the origin property, Inform with throw a run-time error (error P10). The standard Glimmr objects that will support motion animations, then, are:

	any g-element
	graphics g-window

(We can, of course, create our own kind of object, and as long as it has the "origin" property, we will be able to animate it with a motion animation track.)

When a g-element that has an endpoint (boxes, rectangles, lines) is animated using the motion animation phrase, the endpoint will be changed along with the origin, so that the shape will move as a unit. If we want to do more complex effects--such as moving the endpoint without moving the origin, or vice versa--then we should use the "parameterized motion" preset (see below).

When a graphics g-window is targeted by the motion animation phrase, then the framing of the canvas in the window is changed. See Glimmr Canvas-Based Drawing for an explanation of the origin coordinate of windows vis-a-vis their canvases.

A motion animation always moves the object from its current position to the ending position we specify; the starting position of the object is not directly provided in the animation phrase. To invoke a motion preset animation we can use one of the following two phrases:

	animate <track> as a motion animation targeting <target> and ending at <final position> at <interval> with a duration of <length> frames, <cycling>

	animate <track> as a motion animation targeting <target> and ending at <final position> at <interval> with a velocity of <velocity> units, <cycling>

The second phrase allows us to specify the velocity (in canvas units per frame; see Canvas-Based Drawing for the concept of canvas units/pixels); the number of frames required to move to the ending position at the given velocity will be calculated automatically.

If we set the "cycling" option, the animation will start again from the beginning upon completion, ad infinitum or until stopped by another event (such as a callback from another track; see the section on callbacks below). 

Some examples of usage:

Targeting a sprite element, and specifying the length of the animation rather than the speed:
	*: The run-movement track is an animation track.

	Lola is a sprite. The origin is {0, 100}.

	Instead of running:
		animate the run-movement track as a motion animation targeting Lola and ending at {400, 100} at 8 fps with a duration of 24 frames.

Targeting a rendered string element, specifying the velocity rather than the duration of the animation. The text will move in from off the canvas, while an easing equation adds visual interest to the path of movement.
	*: The title bounce track is an animation track. The easing is bounce easing out.

	The Title Text is an image-rendered string. The text-string is "Your Title Here". The origin is {300, -100}.

	When play begins:
		 animate the title bounce track as a motion animation targeting the Title Text and ending at {300, 300} at 20 frames per second with a velocity of 10. 

Targeting a rectangle primitive, and cycling endlessly. We are depicting a 1980s style videogame bullet (i.e. a square) shot repeatedly from a gun turret.
	*: The gatling shot is an animation track.

	The Bullet is a rectangle primitive. The origin is {100, 150}. The endpoint is {104, 154}. The tint is g-White.

	To activate the turret:
		animate the gatling shot as a motion animation targeting the Bullet and ending at {600, 150} at 10 fps with a velocity of 8, cycling.


Motion animations, as well as parameterized motion animations (see below), can use easing equations to influence the timing and path of movement. Because motion animations can move on two axes (i.e., the x and y axes), we can also use different easing equations simultaneously on the two axes. If we specify only the "easing" for the track, then the same easing equation will be applied to both axes. If we also supply the "secondary easing" for the track, then the easing will apply to the x axis, while the secondary easing applies to the y axis. To reset a track to the defaults after using secondary easing, we specify the "null easing rule" for the secondary track, e.g.

	now the easing of the default track is the linear easing rule;
	now the secondary easing of the default track is the null easing rule.

See the "Eased Movements" example to explore the effect of easing, including differential axis easing, on animated movement.


Section: Zooming animation tracks

"Zooming" tracks affect the scaling of an object, allowing us to "zoom" graphics in or out. Zooming tracks can be function with:

	g-elements
	graphics g-windows

When targeting a g-element, a zooming animation affects the "scaling factor" property of the element. The effect this has depends on the type of g-element; only the line-weight of primitives is affected by the scaling factor, and the scaling factor of bitmaps is much more coarsely realized than that of images. See the docs for Glimmr Canvas-Based Drawing for more information. (Note that if you are using asymmetrically scaling, the zooming track will nevertheless scale symmetrically. Use the "parameterized zooming" preset--see below--to scale axes independently.)

When targeting a graphics window, the property affected is the "arbitrary scaling factor" of the window. This forces manual scaling of the window (see Glimmr Canvas-Based Drawing), so if we wish to return to automatic scaling after completing the animation, we will need to reset the arbitrary scaling factor and trigger a redraw, e.g.:

	*: now the arbitrary scaling factor of the graphics-window is 0.0000;
	refresh windows.

If we attempt to target a canvas, we will instead affect *all* windows that currently display the canvas. This is only advisable if all of these windows are set to the same scaling factor/arbitrary scaling factor, because the scaling factor of the last window to be created will be used for all windows during the animation.

Note that, to avoid aesthetic abomination, Glimmr normally does not allow the canvas to be scaled at larger than actual size. This can be changed, however, on a window-by-window basis, like so. For example:

	*: Oversize scaling of the graphics-window is true.

Also note that whether we are targeting a graphic element or a window, content that is automatically centered may show some "jiggle" due to rounding errors. To avoid this problem when zooming an individual element (such as a sprite), we can make sure that the element is "left-aligned" or "right-aligned" rather than "center-aligned" (see Glimmr Canvas-Based Drawing).

To invoke a zooming preset, we use the following phrase:

	animate <track> as a zooming animation targeting <target> and ending at <final scaling factor> at <interval> with a duration of <length> frames, <cycling>

If we set the "cycling" option, the animation will start again from the beginning upon completion, ad infinitum or until stopped by another event (such as a callback from another track; see the section on callbacks below). 

Usage examples:

Targeting an image-rendered string element, zooming it from nearly invisible to full-size. An easing equation makes the zoom more dynamic.

	*: The title zoom track is an animation track. The easing of the title zoom track is cubic easing in.

	The Title Text is an image-rendered string. The text-string is "Your Title Here". The scaling factor is 0.0001.

	When play begins:
		 animate the title zoom track as a zooming animation targeting the Title Text and ending at 1.0000 at 20 frames per second with a duration of 12 frames.

Targeting a box primitive. Because a primitive's size is determined by its endpoint, we can only zoom the weight of the line used to draw the box. This animation, which cycles endlessly, will thus produce a box whose line-weight pulsates:

	*: The line-pulsation track is an animation track.

	The Frame is a box primitive. The origin is {10, 10}. The endpoint is {100, 100}. The line-weight is 1.

	To start pulsation:
		animate the line-pulsation track as a zooming animation targeting the Frame and ending at 4.0000 at 8 frames per second with a duration of 8 frames, cycling.


Section: Flicker animation tracks

A "flicker" track blinks the targeted object on and off. A flicker can target either of the following:

	g-element
	g-canvas
	graphics g-window

Basically, each frame, the targeted object will be toggled on or off. Targeting a canvas, of course, toggles the entire canvas and all of the elements displayed on it; moreover, if the canvas is currently displayed in more than one window, it will flicker in all windows where it is showing. If we target a window, then whatever canvas is shown in that window will be blinked on and off.

When targeting a window, we should be sure that there is currently a canvas associated with the window. If no canvas is currently associated with a window, we can bind one to it by setting the window's "associated canvas" property immediately before invoking the animation, e.g.:

	now the associated canvas of the graphics-window is the alternate-canvas;
	animate...

Canvases are toggled by changing the "associated canvas" property of the window to the "g-null-canvas" (empty, at least by default) and back again. The canvas is stored in the "target-canvas" property of the track. 

To invoke a flicker animation, we have two options:

	animate <track> as a flicker animation targeting <target> at <interval> with a duration of <length> frames, <cycling><randomized>

	animate <track> as a flicker animation targeting <target> at <interval>, <randomized>

If we set the "cycling" option, the flicker will continue ad infinitum until we stop it (perhaps using a callback on another animation; see the section on callbacks below). For the second option, which specifies no duration, the animation is automatically set to cycle.

If we set the "randomized" option, then the pattern of flickering will be randomized. Each frame, there is a 50% chance that the object will be toggled.

Usage examples:

Targeting a sprite, and cycling endessly:
	*: The neon track is an animation track.

	The Neon Sign is a sprite. The display status is g-inactive.

	When play begins:
		animate the neon track as a flicker animation targeting the Neon Sign at 8 fps.

Targeting a window with a randomized flicker. Since the flicker is randomized, there is no way to ensure that the animation will end with the canvas visible. We can ensure that it will by specifying an animation callback for the track:
	*: The static track is an animation track. The animation-callback is "[@ now the associated canvas of the graphics-window is the target-canvas of the static track]".

	The TV canvas is a g-canvas. The background image is Figure of Color Bars. The associated canvas of the graphics-window is the TV canvas.

	To display static on the television:
		animate the static track as a flicker animation targeting the graphics-window at 8 fps with a duration of 24 frames, randomized.

Note that easing equations have no effect on flicker tracks!


Section: Fade animation tracks

"Fade" animations fade in or out from a background color. Glulx does not provide the ability to change opacity dynamically, so this is accomplished by means of a rather terrible hack. Rather than change a property of the target object as other animation presets do, fade tracks actually draw a transparent PNG image on top of the target. By stepping through a series of PNGs with different opacities, we imitate fading in/out.

Fade animations require a special kind of Inform object called a "fader". Like fonts and tilesets, faders are packaged as extensions plus the set of opacity-scaled images. Glimmr includes one sample fader called Glimmr Animation Fader - Black.

Fades can be invoked targeting any of these types of object:

	g-element
	g-canvas
	graphics g-window

When a g-element is targeted, the PNG image will be sized so that the entire element is covered by the fader overlay. If the target is a canvas, then the canvas dimensions will be faded; if a graphics window, then the entire window will be covered by the overlay. Selecting a canvas that is shown in multiple windows will fade the canvas in all windows simultaneously.

By default, all fader overlays will be placed on display-layer 9999. This should be sufficient for nearly all purposes, but can be changed if need be by writing, e.g. "The display-layer of the black-fader is 30000." (The display layer is the z-level on which a given element is drawn; higher display layers are drawn later. See the documentation for Glimmr Canvas-Based Drawing.)

To invoke a fade preset:

	animate <track> as a fade animation targeting <target> and using <fader> from <starting percentage> percent to <ending percentage> percent at <interval> with a duration of <length> frames, <cycling>

We must specify both the starting and the ending percentage for the fader overlay. 100 percent is solid color, while 0 percent is fully transparent. Percentages are specified as integers, and the word percent can be abbreviated using the % sign, e.g.: 90 % (note the space before the symbol: it is required).

It is important to remember to manage the before and after states of the animation, since the fader overlay is drawn *only* during the animation. An element that is invisible will be made visible once the animation starts. See the usage examples for pointers.

The rate of change of opacities can be controlled via easing equations. This will work best when there are 20 steps or so (as in the black sample overlay).

Usage examples:

Targeting a sprite, fading in from a black background. We start with the sprite inactive so that it will not be visible until after the animation starts (starting the animation will automatically reveal it).
	*: The fade-in track is an animation track.

	The Cover Image is a sprite. The display status is g-inactive.
	
	To reveal the cover:
		animate the fade-in track as a fade animation targeting the Cover Image and using the Black-fader from 100 percent to 0 percent at 8 fps with a duration of 12 frames.

Targeting a canvas, fading out to a black background. When the animation completes, the animation callback will swap the canvas for an empty canvas (the default "g-null-canvas").
	*: The fade-out track is an animation track. The animation-callback is "[@ now the associated canvas of the graphics-window is the g-null-canvas]".

	The graphics-canvas is a g-canvas. The background image is Figure of Cover. The associated canvas of the graphics-window is the graphics-canvas.

	To conceal the cover:
		animate the fade-out track as a fade animation targeting the graphics-canvas and using the Black-fader from 0 % to 100 % at 8 fps with a duration of 12 frames.

The rate of change in opacities can be controlled by easing equations.

By default, fader overlays block mouse input to the graphic elements beneath them. Once you start a fade animation over a button, for example, the player will no longer be able to click on the button. To prevent this, you can add this line of code to your source text:

	*: The graphlink status of a fader overlay is g-inactive.


Section: Temporalizing animation tracks

A "temporalizing" track does nothing at all except count off frames at a given rate. It is intended primarily to be used for delays between animations, and is frequently employed in conjunction with animation callbacks.

To invoke a temporalizing preset animation, we can either specify a length or not:

	animate <track> as a temporalizing animation at <interval> with a duration of <length> frames, <cycling>

	animate <track> as a temporalizing animation at <interval>, <cycling>

Note that temporalizing animations have no target object--since they don't produce any visual effect, they don't need one. When the "cycling" option is set, a temporalizing animation will continue to cycle until stopped by some outside event, e.g. a callback.

Usage example:

A sprite moves right, then pauses a bit, then moves back to the left. The temporalizing animation is begun at the same time as the rightward movement, but continues for 6 frames beyond it and then fires a callback to begin the leftward movement:
	*: The patrol track is an animation track.
	The pause track is an animation track. The animation-callback of the pause track is "[@ complete the patrol]".

	The Patroller is a sprite. The origin is {0, 100}.

	To begin the patrol:
		animate the patrol track as a motion animation targeting the Patroller and ending at {300, 100} at 8 fps with a duration of 24 frames;
		animate the pause track as a temporalizing animation at 8 fps with a duration of 30 frames.

	To complete the patrol:
		animate the patrol track as a motion animation targeting the Patroller and ending at {0, 100} at 8 fps with a duration of 24 frames.


Chapter: Parameterized animation tracks

A "parameterized" track is one to which the author must supply the parameter on which the track will act--generally a property of the targeted g-element, canvas, or window. Whereas a reel animation track, for example, works only on the image-ID of a sprite or the background image of a canvas, a parameterized reel track can affect pretty much any visually significant property.

A parameterized track can work on only one property of one object at a time.

If you are not using any parameterized tracks in your game, you can include the following code in your game to stop the code that supports them from being compiled into the game; this will save a bit on memory.

	*: Part - Delete parameterized animations (in place of Part - Parameterized animations in Glimmr Canvas Animation by Erik Temple)


Section: Parameterized reel animation tracks

A parameterized reel animation loops through a list of values and assigns those in turn to the chosen parameter. The types of values that can be passed as a parameters are given below; these include more or less all of the visually significant properties provided by Glimmr extensions.

	figure names
	glulx color values
	lists of numbers
	numbers
	indexed texts
	lists of lists of numbers
	lists of lists of figure names
	objects
	real numbers

To set up a parameterized reel, we must supply a list of values (the "reel") of the same type as the chosen parameter. For example, a reel of figure names targeting the image-ID property of a sprite will produce a result nearly identical to that of using a standard reel animation--a flipbook-like sequence of images. Our reel must be one of the predefined list properties of our track. Here are the names of those list properties, followed by the type of value associated with each.

	image-reel - figure names
	color-reel - glulx color values
	coordinates-reel - lists of numbers
	numerical-reel - numbers
	indexed-text-reel - indexed texts
	numerical-array-reel - list of lists of numbers
	image-array-reel - list of lists of figure names
	associated-objects-reel - objects
	scaling-reel - real numbers

To invoke a parameterized reel animation:

	animate <track> as a parameterized reel animation targeting <chosen parameter/property> of <target> at <interval> with a duration of <length> frames, <cycling><randomized>

If we wish, we may omit the duration, resulting in this variant phrasing: 

	animate <track> as a parameterized reel animation targeting <chosen parameter/property> of <target> at <interval>, <cycling><randomized>

If we do this, the duration will be set automatically to the number of entries in the reel that corresponds to the type of the property we've chosen. And if we set the "cycling" option when no duration has been set, the track will continue to repeat ad infinitum, or until stopped by another event (such as a callback from another track; see the section on callbacks).

The entries in the reel list will be shown in order, unless we've set the "randomized" option, in which case an entry will be chosen at random from the reel for each frame. (We can of course include multiple mentions of the same entity to influence percentages; if value A is listed twice in the reel while value B is listed just once, then the chance that value A will be displayed is twice as great as the chance that value B will be.)

Examples of usage:

The position of the cursor in a bitmap-rendered string:
	*: The wandering cursor track is an animation track. The numerical-reel is {26, 25, 24, 24, 24, 25, 26, 27}.

	Well-Considered Phrase is a bitmap-rendered string. The text-string is "It was a dark and stormy...". The cursor is 27.

	To move cursor aimlessly:
		animate the wandering cursor track as a parameterized reel animation targeting the cursor of the Well-Considered Phrase at 6 fps, cycling. 


The position of a sprite, "teleporting" from location to location on the canvas:
	*: The teleporting track is an animation track. The coordinates-reel is { {10, 10}, {152, 45}, {345, 12}, {72, 72}, {0, 400} }.

	Bamff is a sprite. The origin is {330, 330}.

	To teleport:
		animate the teleporting track as a parameterized reel animation targeting the origin of Bamff at 2 fps.


Showing different text strings randomly:
	*: The flashcard track is an animation track. The indexed-text-reel is {"Eat only meats!", "Capitalize on murder!", "Fleece your neighbor!", "Wear plaid!", "Treacle trickles!"}.

	The card is an image-rendered string. The text-string is "". The background tint is g-white.

	When play begins:
		animate the flashcard track as a parameterized reel animation targeting the text-string of the Card at 900 milliseconds per frame, randomized and cycling.


Easing equations normally have no effect on parameterized reel tracks. However, see the section on standard reel tracks above for the use of easing to extend or contract the apparent timing of reel transitions.


Section: Parameterized motion animation tracks

Parameterized motion tracks are like standard motion tracks (see above), except that they can target any number or coordinate property. Practically, what this means is that we can use a motion track to act on the following properties:

	origin (coordinate)
	endpoint (coordinate)
	cursor (number)
	line-weight (number)
	bit-size (number)

Clearly, parameterized motion tracks can be used on a much narrower range of properties than parameterized reel tracks; they work only on those numerical properties for which continuous motion is possible.

A parameterized motion animation on the origin coordinate is almost exactly equivalent to the basic motion track preset, with the important exception that, for g-elements that have an endpoint property (i.e., primitives), the endpoint is *not* moved along with the origin, as does happen with the motion preset. This allows us to use a parameterized motion animation targeting the origin to move the upper left corner (origin) of a primitive independently of its lower right (endpoint). And of course, targeting the endpoint will move it independently of the origin.

To invoke a parameterized motion track:

	animate <track> as a parameterized motion animation targeting <chosen parameter/property> of <target> and ending at <end point> at <interval> with a duration of <length> frames, <cycling>

Or, specifying the average velocity of movement rather than the length of the animation:

	animate <track> as a parameterized motion animation targeting <chosen parameter/property> of <target> and ending at <end point> at <interval> with a velocity of <velocity> units, <cycling>

The <end point> token can be either a coordinate (list of two numbers) or a number (single digit), or a variable containing one of these.

Usage examples:

Animating the endpoint coordinate of a line, so that it sweeps back and forth across the screen:
	*: The sweeping track is an animation track.

	The Scanline is a line primitive. The origin is {200, 100}. The endpoint of the Scanline is {0, 0}.

	When play begins:
		animate the sweeping track as a parameterized motion animation targeting the endpoint of the Scanline and ending at {400, 0} at 10 fps with a velocity of 10 units.


Animating by a simple number rather than by a coordinate. Here we move a cursor from the end of a short text back to the beginning, but with bounce easing set to move it back and forth, a bit aimlessly, along the way:
	*: The wandering cursor track is an animation track. The easing is the bounce easing out rule.

	Well-Considered Phrase is a bitmap-rendered string. The text-string is "It was a dark and stormy...". The cursor is 27.

	When play begins:
		animate the wandering cursor track as a parameterized motion animation targeting the cursor of the Well-Considered Phrase and ending at 0 at 6 fps with a velocity of 1 unit.


Parameterized motion animations can use easing equations to influence the timing and path of movement. Because coordinate-based parameterized motion animations can move on two axes (i.e., the x and y axes), we can use different easing equations simultaneously on the two axes. If we specify only the "easing" for the track, then the same easing equation will be applied to both axes. If we also supply the "secondary easing" for the track, then the easing will apply to the x axis, while the secondary easing applies to the y axis. To reset a track to the defaults after using secondary easing, we specify the "null easing rule" for the secondary track, e.g.

	now the easing of the default track is the linear easing rule;
	now the secondary easing of the default track is the null easing rule.

See the "Eased Movements" example to explore the effect of easing, including differential-axis easing, on animated movement.


Section: Parameterized zooming animation tracks

A parameterized zooming track is, as might be guessed, very similar to the standard zooming track. It can operate on any of the following four properties:

	scaling factor (of a g-element)
	x-scaling factor (of a g-element)
	y-scaling factor (of a g-element)
	arbitrary scaling factor (of a window)

For most purposes, we should just use the standard zooming track. The main use for the parameterized zooming preset is to allow us to set the x-scaling and y-scaling factors of a g-element separately; this works only when the "asymmetrical scaling" use option is set (see docs for Glimmr Canvas-Based Drawing).

To invoke a parameterized zooming track:

	animate <track> as a parameterized zooming animation targeting <chosen parameter/property> of <target> and ending at <final scaling factor> at <interval> with a duration of <length> frames, <cycling>

Usage example:

Animating the scaling of only the y-axis to "compress" a sprite visually. Making the sprite right-aligned causes it to be anchored at the bottom:
	*: Use asymmetrical scaling.
	
	The squishy track is an animation track.
	
	The Ball is a sprite. It is right-aligned. The image-ID is Figure of Ball.
	
	To squish the blob:
		animate the squishy track as a parameterized zooming animation targeting the y-scaling factor of the Blob and ending at 0.1000 at 24 fps with a duration of 4 frames.

Easing equations can be applied to a parameterized zooming track just as they can a standard zooming track.


Chapter: Custom animations

It is also possible to create entirely custom animations, using the "custom" preset. The built-in phrase for custom presets addresses only the interval, duration, and modality (i.e., cycling or randomized) of the track. It does not allow for the specification of a target object, largely because there is no assumption that the "animation" produced will be graphical in nature. Custom tracks can be used for any effect that can be thought of in terms of recurring frames, and in fact it is assumed that custom tracks will most likely be used for real-time events that don't involve graphical displays.

To invoke a custom animation, we can use this phrase:

	animate <track> as a custom animation at <interval> with a duration of <length> frames, <randomized><cycling>
	
Or, without specifying a duration:

	animate <track> as a custom animation at <interval>, <randomized><cycling>
	
Note that the latter will have a duration of 1 frame by default unless we specify it some other way.
	
On its own, our "animate..." phrase will do nothing. We also need to write an animation rule to implement the animation itself. Note that while cycling behavior will be implemented automatically, we would need to write our own randomization logic into our animation rule for the "randomized" option to have any effect (in the vast majority of cases, we will just ignore that option).

The animation rule belongs to the "animation" rulebook, and is parameterized on the animation track to be animated. In other words, if we have defined a custom animation track called "my anim-track", then we would write our animation rule's preamble like this:

	Animation rule for my anim-track:
	
(As with any other rule, of course, we can also attach conditions to the preamble, e.g. "An animation rule for my anim-track when the player carries the gun", or specify "first animation rule..." or "last animation rule..." to influence the rulebook ordering.)

GCA provides only one rule intended for custom tracks: the "minimal custom animation rule", which serves only to print a simple message to the debugging log. We can delist it if we want to provide our own debugging log print statements (see the extension's source code for examples).

We can use the phrase "cease animating <track>" to stop our custom track or any other. This will halt the animation immediately and fire its animation-callback, and is useful both for cycling animations and for those which we need to end early for some reason. A quick usage example:

	Animation rule for my anim-track:
		if the player wears the girdle:
			cease animating my anim-track.


Section: Usage examples

Here are a couple of examples of custom animation rules, and the code needed to set them up.

This code produces a timer that counts the seconds in the status bar.

	*: The timer display is an animation track.

	Seconds elapsed is a number variable.

	When play begins:
		now the right hand status line is "s: [seconds elapsed]";
		animate the timer display as a custom animation at 1 frame per second, cycling.

	Animation rule for the timer display:
		increase the seconds elapsed by 1;
		now the right hand status line is "s: [seconds elapsed]";
		update the status line;
		advance the timer display.

	To update the/-- status line:
		(- if (gg_statuswin) DrawStatusLine(); -)


This code simply counts down (silently) to a desired real-time event. 

	*: The countdown is an animation track.
	The animation-callback of the countdown is "Kablooie!".

	When play begins:
		say "The bomb will go off in 180 seconds.";
		animate the countdown as a custom animation at 1 frame per second with a duration of 180 frames.

	Animation rule for the countdown:
		advance countdown.
		

Section: Important note about animations that print text

It is illegal to print text to a window if that window is awaiting input from the player, though some interpreters will allow it. In the vast majority of games, this means that we should not use an animation rule to print text to the main window unless we invoke the "delay input until all animations are complete" phrase. Other text windows, including the status line, will not cause any problem unless we are also requesting input in those windows.

(Note that the animation debugging provided by this extension is subject to the same rules. If we are not using the Glimmr Debugging Console extension or another alternate stream for the output from the debugger, it will only print in some interpreters. Conveniently, both the OS X and Windows IDEs allow such illegally printed text; Gargoyle, however, does not. See the section on Debugging below for more on redirecting the debugging log to alternate streams.)


Section: Adding easing to a custom animation

If we want to add easing (see section on Easing below) to a custom animation rule, we must pass the appropriate parameters into the track's easing equation using this construction:

	the easing of <track> applied to the <current frame> and <duration> and <starting value> and <difference between starting and ending value>
	
For example, to calculate the current position on a scale of 1 to 100 in a cycling animation according to some easing equation, we would do something this: 

	let cyclic-frame be current-frame of my anim-track - (cycles completed of my anim-track * cycle-length of my anim-track);
	let x be the easing of my anim-track applied to the cyclic-frame and the cycle-length of my anim-track and 1 and 99;
	

Chapter: Easing (Tweening)

The term “easing” refers to motions in which the acceleration changes over time. The term may seem strange, but think of it in terms of easing into a chair–your body moves more slowly as you approach the cushion. Easing equations can imitate this sort of gradual slowing as the motion reaches the endpoint, and they can also do much more, such as imitate the bouncing of a ball, or overshoot the endpoint and snap back.

Easing is closely related to the concept of "tweening". Briefly, tweening is short for “in-betweening”. In traditional animation, animations were organized around key frames–-the critical points in any sequence. These keyframes were drawn first, and then the “betweens” were filled in to connect those key moments smoothly; because they were less critical, they were often filled in by the lower ranks of the animation team. In computer animation, keyframes are defined by the user, and the tweening is done automatically by the software.

Glimmr Canvas Animation (GCA) is no different, though it doesn’t really use the concept of the keyframe. Where programs like Flash have a master timeline punctuated by user-defined keyframes, each GCA animation track can be thought of as a self-contained timeline separating two keyframes–the starting and ending points of that particular motion or effect. GCA builds sophisticated and customizable tweening into nearly all of the preset animation types via the use of “easing” equations that interpolate movement between the starting and ending points.

The most common use of easing is in moving objects across the screen, but easing equations can be used on any continuous field of values, not just coordinates in space. For example, when used on a zooming track: instead of proceeding from 50% of actual size to 100% by equal intervals, the zoom might be “eased” using a cubic ease-out equation so that the size change starts out rapid, increases slightly in speed for the first 1/2 or so of the duration, and then slows comparatively quickly. (For just such an effect, see the Maps of Murder example included with this extension.)

The best way to start exploring the effects that easing can have on your animations is probably to try out the "Eased Movements" example included with this extension. You might also want to check out these online resources:

	http://glimmr.wordpress.com/2011/06/11/animation-demo-series-2/
	http://en.wikipedia.org/wiki/Tweening
	http://www.actionscript.org/forums/showthread.php3?t=5312
	http://www.gizma.com/easing/
	http://timotheegroleau.com/Flash/experiments/easing_function_generator.htm
	http://snippets.dzone.com/posts/show/4005
	http://jqueryui.com/demos/effect/easing.html


Section: Types of easing

GCA has 16 easing equations built in, from purely linear to a quadratic curve to a parabolic bounce. If these don't meet your needs, you can also add your own equations (see below for a few notes on rolling your own).

Most of the included equations are available in three flavors each. “Easing out” describes a sequence in which motion starts out moving rapidly and then slows, more or less gradually, to a stop. “Easing in” is the opposite–-slow to fast. “Easing in-out” combines the two effects. Different functions are used to qualify these three basic categories, resulting in the full names of the easing equations: “quadratic easing in” for example, or “circular easing out”.

Here are the names of the built-in equations:

	linear easing (constant speed--the default, not really "eased" at all)
	
	quadratic easing in
	quadratic easing out
	quadratic easing in-out
	
	cubic easing in
	cubic easing out
	cubic easing in-out
	
	circular easing in
	circular easing out
	circular easing in-out
	
	cubic back easing in
	cubic back easing out
	cubic back easing in-out
	
	bounce easing in
	bounce easing out
	bounce easing in-out
	
Again, see the "Eased Movements" example included with the extension to preview each of these effects.
	

Section: Assigning easing to animation tracks

Assigning an easing equation to an animation track is simple. An animation track has a property called the "easing", and we simply assign the appropriate easing function to this property, e.g.:

	the easing of the default track is the bounce easing in rule
	
If we don't specify an easing, then the default "linear easing" rule will be used. This rule does not involve any speed variations; it provides a simple linear interpolation of values.
	
Note that motion and parameterized motion tracks (but no others) can also utilize a "secondary easing". If a secondary easing function is applied, then this function will apply only to the y-axis, while the primary easing function will be used for the x-axis:

	The easing of the complex movement track is the cubic easing in rule.
	The secondary easing of the complex movement track is the circular easing out rule.

If we want to reset the secondary easing, we can do that by specifying "null easing". These phrases would return our track to its initial state:

	now the easing of the complex movement track is the linear easing rule;
	now the secondary easing of the complex movement track is the null easing rule.


Section: Implementation details

Every easing equation utilizes four parameters, conventionally known as "t", "d", "b", and "c":

	t - time, the current frame of the animation.
	d - duration, the length in frames of the animation.
	b - initial value of the property being animated; that is, the value at a "t" of 0.
	c - change, the difference between the ending value of the property being animated and the initial value (i.e., "b").
	
The values for "t" and "d" are calculated as needed (generally equivalent to the current-frame and the animation-length properties of the track), but the "b" and "c" are are initialized when the "animate..." phrase is invoked, and are stored in the following properties of the animation track itself:

	start-x ("b") - The initial value or x-coordinate of the object being animated. In the case of a zooming animation, this number is an integer representation of the scaling factor (the latter multiplied by 10,000).
	start-y ("b") - In the case of a motion animation or a zooming animation when we are scaling on both axes independently, we may also store the initial value or y-coordinate of the object being animated, for use in the secondary easing equation.
	delta-x ("c") - The difference between the ending value that we provide in the "animate" phrase and the starting value stored in start-x (i.e., the "b" parameter). 
	delta-y ("c") - If we are using a secondary easing equation, the difference between the ending value that we provide in the "animate" phrase and the starting value stored in start-y (i.e., the "b" parameter).


Section: Adding custom easing equations

Adding new easing equations is both easy and difficult. It is easy in that there's not much to the mechanics of the process. We simply define a "to decide" phrase using a certain rigid form for the preamble. Here is the preamble for one of the phrases included with GCA. We would copy this preamble exactly, replacing the capitalized phrase with the name of our equation:

	*: To decide what number is QUADRATIC EASING IN for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the QUADRATIC EASING IN rule):

Now on to what's hard about writing new equations. First, coming up with them in the first place. GCA borrows equations from various places around the web (see the resources listed above and in the comments to the extension's source code). There are certainly other equations out there, and the easiest thing will be to borrow those.

The next difficult thing is dealing with Inform's limited math capabilities. Inform does not follow the standard rules for precedence in mathematical operations, so we need to be very liberal in using parentheses to spell out for Inform which operations should be grouped together. Inform also does not allow fractions, so if our equation depends on fractional multipliers or divisors, we will need to use the functionality provided by Michael Callaghan's Fixed Point Maths (FPM) extension. GCA provides some short cuts for making FPM code a bit more readable: we can double the main mathematical operators to replace the "real number" operations provided by FPM. For example,

	(120 ** 2) ++ 17	would be equivalent to

	(120 real times 2) real plus 17	in FPM's notation

Here's an example of a relatively simple equation from those included with GCA:

	To decide what number is QUADRATIC EASING IN for time (t - a number) duration (d - a number) beginning (b - a number) change (c - a number ) (this is the QUADRATIC EASING IN rule):
		let t1 be (t as a fixed point number) // d;
		decide on (c ** t1 ** t1) ++ b as an integer.

Once we've completed our equation, we can refer to it just as if it were one of the built-in equations; no additional steps are needed:

	My anim-track is an animation track. The easing is the polysyllabic easing out rule.
	
	
Chapter: Debugging

Because the standard Glimmr debugging log already generates a lot of debugging output, Glimmr Canvas Animation uses a separate debugging option. To enable the log messages from GCA, enable this use option:

	Use animation debugging.
	
This can be used alongside standard Glimmr debugging ("Use Glimmr debugging"), though the output will likely be overwhelming.

By default, the animation log is written to the main window. However, unless we are using the "delay input until all animations are complete", we may not see the output in the main window, particularly the per-frame animation debugging messages. This is because in Glk/Glulx, it is illegal to print text to a window if that window is awaiting input from the player. Some interpreters, including those in the Mac and Windows IDEs, will allow this illegal printing. Others, such as Gargoyle, do not. To be sure that we are seeing debugging log output, we may want to do one of the following:

	1) Include the Glimmr Debugging Console extension, to segregate Glimmr logging output into its own window.

	2) We can set up our own alternate text-buffer window and direct log output there by setting the "console output window" variable, e.g.:

		The console output window is my-text-window [a text-buffer g-window].

	3) We can also send console log output to the transcript, while not printing it anywhere else. To do this, we include this code in our story file:

		To say >console:
			say echo stream of main-window.
	
		To say <:
			say stream of main-window;
			say run paragraph on.

	This will only work when a transcript is actually being written. To ensure that we do not forget to initiate one, we can include this:

		When play begins:
			try switching the story transcript on.
			
			
Chapter: Performance Tips

	1. Test outside of the IDE. Games played within the Inform IDE will be slower than games played in an external interpreter. The Mac IDE may sometimes show minor scaling artifacts that are not seen with external interpreters. Try pressing the Release button to produce a blorb file, and play that file in the latest version of a fast, modern interpreter.
	
	2. Bes sure to test in all of the interpreters that you expect your players to use.

	3. Be sure that your images are not too large. Images should be sized no larger than you want them to appear onscreen.
	
	4. Interpreters will vary in their ability to scale large images rapidly. Zoom handles this scaling quite well, but most other interpreters are not very good. While Gargoyle is actually faster than Zoom at most graphics operations, its performance at scaling large images is middling; it is the best alternative to Zoom, but is nowhere near as fast.

	5. If you have multiple graphics windows, only some of which have animations, change or preempt the "animation window-updating rule" to be more selective. This rule redraws *all* of the open graphics windows for each frame of an animation; we should rewrite it to update only the windows that we are animating. 

	6. If you have multiple animations running at once, see whether you get better performance by running them at the same rate. If you have animations running at different rates, make one a (preferably low) multiple of the other, e.g. 100 ms per frame and 200 ms per frame. This will mean fewer timer ticks where nothing meaningful takes place.	


Chapter: Contact info

If you have comments about the extension, please feel free to contact me directly at ek.temple@gmail.com.

Please report bugs on the Google Code project page, at http://code.google.com/p/glimmr-i7x/issues/list.

For questions about Glimmr, please consider posting to the intfiction forum (http://www.intfiction.org/forum/). This allows questions to be public, where the answers can also benefit others. If you prefer not to use this forum, please contact me directly via email (ek.temple@gmail.com).


Example: * Animation Rule Variations - This simple example shows how we can vary preset animations by adding rules to the animation rulebook. We'll have four variations on a simple horizontal motion animation. The "player" can choose from among these variation via a keypress menu. The chosen animation will play immediately, and once it finishes s/he will have a chance to choose another.

We start with basic setup, creating a graphics window, a canvas, and some stuff to animate. This is primarily a round ball, implemented as a bitmap element so that we can avoid loading any external images. There are also two non-animated point primitives, to mark the beginning and end points of the ideal path of movement; these will primarily help us to see the differences between variations 2 and 3.

	*: "Animation Rule Variations"

	Include Glimmr Canvas Animation by Erik Temple.

	[Use Glimmr debugging.]
	[Use animation debugging.]

	There is a room.

	The graphics-window is a graphics g-window spawned by the main-window. The position of the graphics-window is g-placeabove. The measurement of the graphics-window is 50. The back-colour of the graphics-window is g-black.

	The graphics-window canvas is a g-canvas. The canvas-width is 500. The canvas-height is 300. The associated canvas of the graphics-window is the graphics-window canvas.

	When play begins:
		open up the graphics-window;
		[open up the console-window.] 
	

	The associated canvas of a g-element is the graphics-window canvas.

	The Ball is a monochrome bitmap. The tint is g-White. The Ball is center-aligned. The bitmap-array is {
		{ 0, 0, 1, 1, 1, 0, 0 },
		{ 0, 1, 0, 0, 0, 1, 0 },
		{ 1, 0, 0, 0, 0, 0, 1 },
		{ 1, 0, 0, 0, 0, 0, 1 },
		{ 1, 0, 0, 0, 0, 0, 1 },
		{ 0, 1, 0, 0, 0, 1, 0 },
		{ 0, 0, 1, 1, 1, 0, 0 } }.
	
	Initial-position indicator is a point primitive. The tint is g-red. The display-layer is 2.
	Secondary-position indicator is a point primitive. The tint is g-red. The display-layer is 2.

Next, we define our animation track, and assign a few global variables to control the animation. (We use the globals so that we need only make changes in one place should we want to tweak things.) 

The after printing the banner text rule contains the entire flow of the "game": we enter a loop in which it is only possible for the player to press a number keyed to the menu, or to press "q" to quit. We store the number pressed in the "key-option" variable; we will use it later to decide which subsidiary animation rule to call. Then we invoke the animate phrase that will move the ball from its current position to the destination coordinates. We prevent the game from accepting any input until the animation completes by using the "delay input until all animations are complete" phrase. And after the animation completes, we swap the coordinates stored in the destination variable, so that the next animation will move the ball back where it came from.

	*: The movement track is an animation track.

	The motion-duration is a number variable. The motion-duration is 20.
	Base rate is a number variable. Base rate is 40.
	Rate interval is a number variable. Rate interval is 10.

	Initial position is a list of numbers variable. Initial position is {10, 100}.
	Secondary position is a list of numbers variable. Secondary position is {490, 100}.
	Destination is a list of numbers variable.

	When play begins:
		now the origin of the ball is the initial position;
		now the origin of the initial-position indicator is the initial position;
		now the origin of the secondary-position indicator is the secondary position.

	Key-option is a number variable.
	
	After printing the banner text:
		now the destination is the secondary position;
		say paragraph break;
		say "This demo shows some ways in which a simple animation can be changed using additional animation rules. Type a number to see the corresponding animation:[paragraph break]1. Simple motion along a path.[line break]2. Random noise added to a path[line break]3. Random noise added to a path, but nevertheless arriving at the originally specified ending point[line break]4. Gradual decrease in the frame rate.[paragraph break]Press Q to quit.[paragraph break]";
		while true is true:
			now key-option is the character code entered in the main-window minus 48; 
			if key-option is 65["q" = 113 (48 + 65)], break;
			if key-option is less than 1 or key-option is greater than 4, next;
			animate the movement track as a motion animation targeting the Ball and ending at the destination at (base rate) ms per frame with a duration of (motion-duration) frames;
			delay input until all animations are complete; 
			if the destination is the initial position:
				now the destination is the secondary position;
			otherwise:
				now the destination is the initial position;
		say "*** User exited demonstration ***";
		follow the immediately quit rule.	

The "key-option" variable, which contains the number of the menu that the player selected, is now used to decide which subsidiary animation to use. We don't need to run a second rule if the player pressed 1, since that corresponds to the unadorned movement invoked by the "animate..." phrase. The subsidiary rules run *after* the built-in preset animation rule, so they tweak the outcomes of that rule. (If we wanted our animation rules to run before the preset rule, we could make them "first" rules.)

Option 2 randomly deforms the basic path of motion, and requires only a very simple rule that adds or subtracts a number between 1 and 10 from the x and y coordinates of the ball's origin. The "adjust the origin..." phrase used here is an easter egg phrase provided by GCA; we can also use "adjust the endpoint" for primitive elements. Note that this option will almost never finish on the destination coordinate specified, since we are adding noise to the chosen coordinate all the way along.

Option 3 uses the same deformation as Option 2, but with a twist. We want to end on the originally specified destination point. This is tricky, because motion animations are completely relative: when the animation is set, up GCA calculates what we'll have to do to get to the destination, but doesn't save any information about the destination itself. To keep our eyes on the prize, then, we need to reconstruct the original destination coordinate, and reorient ourselves to it, every frame. This will cause the deformation to be a bit smoother than in Option 2, but still noticeable. Note that we only apply deformations for the first 3/4 of the animation's running time. That's so that we don't jump too unnaturally to the destination at the end if we are far off.

Option 4 actually changes the rate of the animation itself. Once we're about 1/3 of the way through the allotted frames, the rule kicks in to change the rate of the timer tick, increasing the time between ticks and therefore slowing the apparent speed of the animation. For a motion animation, this is probably better done with an easing equation, but this kind of speed control might work nicely for a reel animation. 

	*: Animation rule for the movement track when key-option is 2:
		adjust the origin of (the animation-target of the movement track) by (a random number between -10 and 10) and (a random number between -10 and 10).
	
	Animation rule for the movement track when key-option is 3:
		if current-frame of the movement track is less than (3 * (motion-duration / 4)):
			let end-x be start-x of the movement track plus delta-x of the movement track;
			let end-y be start-y of the movement track plus delta-y of the movement track;
			let X be a random number between -10 and 10;
			let Y be a random number between -10 and 10;
			adjust the origin of (the animation-target of the movement track) by (X) and (Y);
			now the start-x of the movement track is entry 1 of the origin of the animation-target of the movement track;
			now the start-y of the movement track is entry 2 of the origin of the animation-target of the movement track;
			now delta-x of the movement track is end-x minus start-x of the movement track;
			now delta-y of the movement track is end-y minus start-y of the movement track.

	Animation rule for the movement track when key-option is 4:
		if current-frame of the movement track is greater than (motion-duration / 3):
			let rate be (base rate) + ( (current-frame of the movement track - (motion-duration / 3)) * (rate interval) );
			time the movement track at (rate) ms per frame.



Example: ** Maps of Murder - The user interface is an ideal place to experiment with animation effects. Here, we sketch a kind of image browser for an IF game. Four thumbnail versions (the map illustrations from Dell Map-Back murder mysteries) are displayed in a grid. We can click on any one of them to maximize it; we use two animation tracks to animate the maximization, scaling the image to full size while moving it to the center of the window. Click on the cover again to return it to the original thumbnail size and location.

This example illustrates the "stacking" of animation tracks to achieve more complex effects; in this case we are stacking motion and scaling animations, with an easing effect lending a subtle arc to things. The example also demonstrates how we can test the animation state of an object so as to modify behavior appropriately, and more generally it shows how to write generalized code--we could add 20 more covers without changing any of the core code.

	*: "Maps of Murder"

	Include Glimmr Graphic Hyperlinks by Erik Temple.
	Include Glimmr Canvas Animation by Erik Temple.


	The graphics-window is a graphics g-window spawned by the main-window. The position of the graphics-window is g-placeright. The measurement of the graphics-window is 50. The back-colour of the graphics-window is g-black. The graphics-window is g-graphlinked.

	The graphics-canvas is a g-canvas. The canvas-width is 462. The canvas-height is 652. The associated canvas of the graphics-window is the graphics-canvas.

	When play begins:
		open up the graphics-window.
	
	There is a room.


	[-------------------------------]

	Figure of Whos Calling is the file "WhosCalling.png".
	Figure of Feathered Serpent is the file "FeatheredSerpent.png".
	Figure of Hidden Ways is the file "HiddenWays.png".
	Figure of Mourned Sunday is the file "MournedOnSunday.png".

	Figure of Transparent Overlay is the file "Overlay.png".

	[-------------------------------]

We create a new kind of sprite, the "cover-image", and give it a new coordinate property, the "rightful position". This is the position to which the cover should return after it has been maximized. Note that we are showing the covers at half size initially; they will be shown at full size on maximization.

When a cover has been maximized, we place a semi-transparent overlay over the other images so that they don't distract from the player's view of the enlarged sprite. (This overlay is itself a sprite.) The grid of covers is on display layer 1. The overlay, when it appears, will be drawn on layer 2, and the cover, when it is maximized is shown on layer 4. Layer 3 is used for sprites that are in the process of minimization.

	*: A cover-image is a kind of sprite. A cover-image is center-aligned. Some cover-images are defined by the Table of Covers.

	The associated canvas of a g-element is usually the graphics-canvas. The graphlink status of a cover-image is usually g-active. A cover-image is publically-named.

	A cover-image has a list of numbers called the rightful position.

	The linked replacement-command of a cover-image is usually "Toggle [the current graphlink]".

	Table of Covers
	cover-image	image-ID	origin
	the first cover	Figure of Whos Calling	{126, 173}
	the second cover	Figure of Feathered Serpent	{337, 173}
	the third cover	Figure of Hidden Ways	{126, 479}
	the fourth cover	Figure of Mourned Sunday	{337, 479}


	The transparent overlay is a sprite. The image-ID is Figure of Transparent Overlay. The origin is {0, 0}. The display status is g-inactive. The display-layer is 2.

	[-------------------------------]

	A cover-image can be maximized.

We define four tracks. Why four? It will be possible to click on another cover to maximize it while we have another cover already enlarged; we have four tracks so that both can move at the same time (using two tracks each). The primary tracks maximize, while the secondary tracks minimize the cover back to the grid.

Note that the primary zooming track has an easing equation (cubic easing out) applied. Combined with the motion, this creates a rather subtle to the overall motion of maximization. We don't apply the easing to the secondary track--it's a bit too distracting for the return journey, which is after all about minimization.

Also note the callback on the secondary zooming track. This moves the cover back to display layer 1 once it has finished moving back to its original position in the grid. By waiting until the end to move it to layer 1, we avoid seeing it move behind the semitransparent overlay. This is the last stage in a series of layer manipulations; see the carry out toggling rule below for the other layering logic.

	*: The primary zooming track, the primary motion track, the secondary zooming track, the secondary motion track are animation tracks.

	The animation-callback of the secondary zooming track is "[@ now the display-layer of the animation-target of the secondary zooming track is 1]".

	The easing of the primary zooming track is the cubic easing out rule.
	[The easing of the secondary zooming track is the cubic easing in rule.]

	The resting scaling ratio is a real number variable. The resting scaling ratio is 0.5000.
	The display scaling ratio is a real number variable. The display scaling ratio is 1.000.
	The display position is a list of numbers variable. The display position is {231, 326}.

All of the animation action takes place in the carry out toggling rule. We first check to see whether the secondary zooming track is active; if it is, that means that the sprite that was clicked on was already returning to the original grid position, and we need to deactivate that animation so that we can maximize it again (later on in the same rule).

Next we check to see whether there is already an image in the central position. If so, we need to start reducing it. We change its display layer so that it is above the semitransparent overlay, but below whichever sprite is actually the target of the player's click (which will be the noun supplied to the toggling action), then we animate it using the secondary tracks to return it to its original position and size. If this happens to be the image that we clicked on, we stop the action--we don't need to do any more, since clicking on an maximized image just toggles it back to the grid.

Finally, we deal with the case in which a small sprite is clicked on. We first move it to the uppermost layer so it overlays everything else, then we activate the semitransparent overlay and animate the primary tracks to maximize the sprite that was clicked.

All this may seem a bit complex. It does requiring some planning, and it especially helps to work out the layers you need in advance, but you will also undoubtedly also end up tweaking things as you test your original design. 

Note that the implementation of this as a standard action, particularly with the superfluous textual reports on what's been maximized and what's been minimized, is probably a poor design choice!

	*: Toggling something is an action applying to one visible thing. Understand "toggle [any thing]" as toggling something.

	Carry out toggling something:
		if the animation-flag of the secondary zooming track is g-active:
			[the sprite we clicked on is already reducing; stop that motion so we can maximize again]
			deactivate the secondary zooming track;
			deactivate the secondary motion track;
		if there is a maximized cover-image:
			[There is already a maximized sprite; we need to minimize it]
			let item be a random maximized cover-image;
			now item is not maximized;
			now the display-layer of item is 3;
			animate the secondary zooming track as a zooming animation targeting the item and ending at the resting scaling ratio at 24 fps with duration of 8 frames;
			animate the secondary motion track as a motion animation targeting the item and ending at the rightful position of the item at 24 fps with duration of 6 frames;
			now the display status of the transparent overlay is g-inactive;
			if item is the noun, stop the action;[We clicked on the already maximized image, so we don't need to enlarge it; the minimizing motion we've triggered is all that is called for.]
		now the display-layer of the noun is 4;
		now the noun is maximized;
		now the display status of the transparent overlay is g-active;
		animate the primary zooming track as a zooming animation targeting the noun and ending at the display scaling ratio at 24 fps with duration of 8 frames;
		animate the primary motion track as a motion animation targeting the noun and ending at the display position at 24 fps with duration of 6 frames.
	
	Report toggling something:
		say "[The noun] has been [if the noun is maximized]maximized[otherwise]minimized[end if]."


	When play begins:
		say "This example demonstrates the use of multiple 'tracks' to provide complex animation effects. Click on an image to zoom in and move it to the center. Click again to toggle. You can also click on a second cover while the first is zoomed; both will animate smoothly into the appropriate positions.[paragraph break]The images are the back covers of Dell Map-Back mystery books. The Map-Back was a prototype of and possibly a direct influence on the 'feelies' that accompanied classic Infocom games such as [i]Deadline[/i]. These images are from Marble River's Ephemera; you can see the front covers at http://marbleriver.blogspot.com/2010/01/backs-dell-more-map.html.";
		repeat with item running through cover-images:
			now the rightful position of the item is the origin of the item;
			now the scaling factor of the item is the resting scaling ratio.
		
	[Understand "show me source" or "source" or "source code" as a mistake ("
	Carry out toggling something:[line break]     if the animation-flag of the secondary zooming track is g-active:[line break]          [i][bracket]the sprite we clicked on is already reducing; stop that motion so we can maximize again[close bracket][/i][line break]          deactivate the secondary zooming track;[line break]          deactivate the secondary motion track;[line break]     if there is an maximized cover-image:[line break]          [i][bracket]There is already a maximized sprite; we need to minimize it[close bracket][/i][line break]          let item be a random maximized cover-image;[line break]          now item is not maximized;[line break]          now the display-layer of item is 3;[line break]          animate the secondary zooming track as a zooming animation targeting the item and ending at the resting scaling ratio at 24 fps with duration of 8 frames;[line break]          animate the secondary motion track as a motion animation targeting the item and ending at the rightful position of the item at 24 fps with duration of 6 frames;[line break]          now the display status of the transparent overlay is g-inactive;[line break]          if item is the noun, stop the action;[i][bracket]We clicked on the maximized image, so we don't need to enlarge it; the reduction motion we've already set in motion is sufficient.[close bracket][/i][line break]     now the display-layer of the noun is 4;[line break]     now the noun is maximized;[line break]     now the display status of the transparent overlay is g-active;[line break]     animate the primary zooming track as a zooming animation targeting the noun and ending at the display scaling ratio at 24 fps with duration of 8 frames;[line break]     animate the primary motion track as a motion animation targeting the noun and ending at the display position at 24 fps with duration of 6 frames.").]


Example: ** Eased Movements - This example is primarily a demo of the available easing equations. The animation itself is handled in only a single line, whereas most of the code is devoted to user input, particularly the selection of primary and secondary easing via hyperlinks. The example does however illustrate the use of a number of features that are rarely demoed and which may be of interest to those interested in animation, including mouse input and hyperlink input.

There is only a single animation track, the movement track. We initialize both its primary and secondary easing to "linear easing" (i.e., default movement, no real easing to speak of).

	*: "Eased Movements"
	
	Include Glimmr Graphic Hyperlinks by Erik Temple.
	Include Glimmr Canvas Animation by Erik Temple.
	
	Use no status line.
	
	The graphics-window is a graphics g-window spawned by the main-window. The position of the graphics-window is g-placeright. The measurement of the graphics-window is 80. The back-colour of the graphics-window is g-black. The graphics-window is g-graphlinked.
	
	The graphics-canvas is a g-canvas. The canvas-width is 200. The canvas-height is 200. The associated canvas of the graphics-window is the graphics-canvas.
	
	The secondary-window is a text-buffer g-window spawned by the graphics-window. The measurement is 25. The position is g-placeright. The back-colour is g-white. The back-colour of the main-window is g-white.
	
	The movement track is an animation track. The secondary easing is the linear easing rule.
	
	When play begins:
		try requesting the story file version;
		say run paragraph on;
		say "[i]The equation illustrations are borrowed from http://jqueryui.com/demos/effect/easing.html[/i][line break]";
		say "[paragraph break][instruction text]";
		wait for any key in the main-window;
		open up the graphics-window;
		open up the secondary-window;
		now the column-break is the number of rows in the Table of Glulx Hyperlink Replacement Commands;
		say "Break: [column-break].";
		now selected secondary easing is (column-break + 1);
		follow the hyperlink listing rule;
		while 1 is 1:
			wait for any key in the main-window.
	
	Figure of Ball is the file "Ball.png".
	
	Figure of BackEaseIn is the file "BackEaseIn.png".
	Figure of BackEaseInOut is the file "BackEaseInOut.png".
	Figure of BackEaseOut is the file "BackEaseOut.png".
	Figure of BounceEaseIn is the file "BounceEaseIn.png".
	Figure of BounceEaseInOut is the file "BounceEaseInOut.png".
	Figure of BounceEaseOut is the file "BounceEaseOut.png".
	Figure of CircularEaseIn is the file "CircularEaseIn.png".
	Figure of CircularEaseInOut is the file "CircularEaseInOut.png".
	Figure of CircularEaseOut is the file "CircularEaseOut.png".
	Figure of CubicEaseIn is the file "CubicEaseIn.png".
	Figure of CubicEaseInOut is the file "CubicEaseInOut.png".
	Figure of CubicEaseOut is the file "CubicEaseOut.png".
	Figure of LinearEasing is the file "LinearEasing.png".
	Figure of QuadEaseIn is the file "QuadEaseIn.png".
	Figure of QuadEaseOut is the file "QuadEaseInOut.png".
	Figure of QuadEaseInOut is the file "QuadEaseOut.png".
	
	The associated canvas of a g-element is usually the graphics-canvas.
	
	The Ball is a sprite. It is center-aligned. The image-ID is Figure of Ball. The origin is { 100, 100 }.
	
	The column-break is a number variable.
	Selected easing is a number variable. Selected easing is 1.
	Selected secondary easing is a number variable.
	
	This is the hyperlink listing rule:
		clear main-window;
		say "[italic type]Easing (x-axis)[roman type][paragraph break]";
		repeat with x running from 1 to 32:
			if x is (column-break + 1):
				move focus to secondary-window, clearing the window;
				say "[italic type]Secondary easing (y-axis)[roman type][paragraph break]";
			if x < (column-break + 1):
				if x is selected easing or x is selected secondary easing:
					say "[bold type][replacement corresponding to a link ID of x in the Table of Glulx Hyperlink Replacement Commands][roman type][line break]";
				otherwise:
					say "[link x][replacement corresponding to a link ID of x in the Table of Glulx Hyperlink Replacement Commands][end link] [line break]";
			if x > column-break:
				if x is selected easing or x is selected secondary easing:
					say "[bold type][replacement corresponding to a link ID of (x - column-break) in the Table of Glulx Hyperlink Replacement Commands][roman type][line break]";
				otherwise:
					say "[link x][replacement corresponding to a link ID of (x - column-break) in the Table of Glulx Hyperlink Replacement Commands][end link] [line break]";
			if x is column-break:
				display the image corresponding to a link ID of selected easing in the Table of Glulx Hyperlink Replacement Commands;
		display (the image corresponding to a link ID of (selected secondary easing - column-break) in the Table of Glulx Hyperlink Replacement Commands) in the secondary-window;
		return to main screen.
	
	There is a room.
	
	The story headline is "An interactive demonstration"
	
	To say instruction text:
		say "On the next screen, you will be able to assign easing equations to the movement of a ball.[line break]Click on one of the links in the left column to assign the easing for the x-axis of movement, and on the right to assign the easing for the y-axis.[line break]Then just click somewhere in the black part of the screen to move the ball to that point.[paragraph break]Depending on the way in which you have paired the easing equations, different effects will be generated:[paragraph break][b]1. [/b]If the easing of the two axes is the same, the ball will move in a straight line, but its acceleration will change to reflect the non-linear easing used.[line break][b]2. [/b]If linear easing on one axis is paired with nonlinear easing on the other, then requesting the ball to move diagonally will produce a motion similar to the graph shown for the nonlinear easing.[line break][b]3. [/b]If you have nonlinear easing on both axes, there will be plenty of potential for unpredictable movement, especially on the diagonal.[paragraph break]Typically, you will see more variation in the path of the ball if you request a destination diagonal from the ball's current position. Horizontally or vertically, most of the variation will tend to be in ball's acceleration patterns.[paragraph break]Maximize your window now, then [b]press any key to start experimenting![/b][paragraph break]"
	
	To display (F - a figure name) in (win - a g-window), one time only:
		(-  DisplayFigureWin({win}, ResourceIDsOfFigures-->{F}); -) .
	
	Include (-  	
		[ DisplayFigureWin win resource_ID one_time;
			if ((one_time) && (ResourceUsageFlags->resource_ID)) return;
			ResourceUsageFlags->resource_ID = true; print "^"; glk_image_draw(win.ref_number, resource_ID, imagealign_InlineCenter, 0); print "^";
		];
		-) .
	
	Section - Hyperlink control (in place of Section - Selecting the replacement command in Flexible Windows by Jon Ingold)
	
	Table of Glulx Hyperlink Replacement Commands
	link ID	easement	replacement	image
	1	linear easing rule	"linear easing"	Figure of LinearEasing
	2	quadratic easing in rule	"quadratic easing in"	Figure of QuadEaseIn
	3	quadratic easing out rule	"quadratic easing out"	Figure of QuadEaseOut
	4	quadratic easing in-out rule	"quadratic easing in-out"	Figure of QuadEaseInOut
	5	cubic easing in rule	"cubic easing in"	Figure of CubicEaseIn
	6	cubic easing out rule	"cubic easing out"	Figure of CubicEaseOut
	7	cubic easing in-out rule	"cubic easing in-out"	Figure of CubicEaseInOut
	8	circular easing in rule	"circular easing in"	Figure of CircularEaseIn
	9	circular easing out rule	"circular easing out"	Figure of CircularEaseOut
	10	circular easing in-out rule	"circular easing in-out"	Figure of CircularEaseInOut
	11	cubic back easing in rule	"back easing in"	Figure of BackEaseIn
	12	cubic back easing out rule	"back easing out"	Figure of BackEaseOut
	13	cubic back easing in-out rule	"back easing in-out"	Figure of BackEaseInOut
	14	bounce easing in rule	"bounce easing in"	Figure of BounceEaseIn
	15	bounce easing out rule	"bounce easing out"	Figure of BounceEaseOut
	16	bounce easing in-out rule	"bounce easing in-out"	Figure of BounceEaseInOut


The following are the routines that actually implement animation. We first define some values that we can pass into the animation phrase: the initial target for the animation, the desired frame-rate, and the velocity of the ball. This isn't strictly necessary, but it can be good for flexibility.

Next is a hyperlink processing rule, which reads any click to the text hyperlinks, translating the player's selection to an easing equation and assigning that equation as either the easing or secondary easing of the movement track.

Finally, the "clicking graphlink" rule fires when the player clicks on the graphics window. It grabs the coordinates clicked and converts them to canvas coordinates; these coordinates then become the ending point for the motion animation. The motion animation itself is invoked simply by plugging this end point into the "animate" phrase along with the global variables describing frame rate and velocity.

	*: The motion target is a list of numbers variable. The motion target is { 100, 100 }.
	Frame-rate is a number variable. Frame-rate is 24.
	Ball-speed is a number variable. Ball-speed is 20.
	
	Hyperlink processing rule:
		let selection be the linear easing rule;
		if the current hyperlink ID is a link ID listed in the Table of Glulx Hyperlink Replacement Commands:
			let selection be easement entry;
		otherwise if (the current hyperlink ID - column-break) is a link ID listed in the Table of Glulx Hyperlink Replacement Commands:
			let selection be easement entry;
		if the current hyperlink ID < (column-break + 1):
			now the easing of the movement track is the selection;
			now the selected easing is current hyperlink ID;
		otherwise:
			now the secondary easing of the movement track is the selection;
			now the selected secondary easing is current hyperlink ID;
		follow the hyperlink listing rule;
		say run paragraph on;
		rule succeeds.
	
	First clicking graphlink rule:
		let graph-x be current graphlink x as a fixed point number;
		let graph-y be current graphlink y as a fixed point number;
		now entry 1 of the motion target is ((graph-x real minus the x-offset of the current graphlink window) real divided by the scaling factor of the current graphlink window) as an integer;
		now entry 2 of the motion target is ((graph-y real minus the y-offset of the current graphlink window) real divided by the scaling factor of the current graphlink window) as an integer;
		animate the movement track as a motion animation targeting the Ball and ending at the motion target at frame-rate fps with velocity of ball-speed;
		rule succeeds.


Example: **** Scourge of the Vampyr - This example combines a number of different animation presets to create walking (reel + motion) and torchlight (flicker + fade) animations. Fade and zooming effects are also employed to animate the player character's entrance into and exit from the crypt. The example also exploits Glimmr's ability to move the framing of the window on the canvas to keep the player's avatar at the center of the window, so that the rest of the room seems to move around little Pelón. 

	*: "Scourge of the Vampyr"

	Include Glimmr Canvas Animation by Erik Temple.
	Include Glimmr Animation Fader - Black by Erik Temple.


	Section - Figure Definitions

	Figure of Annex is the file "Annex.png".
	Figure of Chamber is the file "Chamber.png".
	Figure of Cross is the file "Cross.png".
	Figure of Entry is the file "Entry.png".

	Figure of Entrance Mask is the file "EntranceMask.png".
	Figure of Opacity Mask is the file "OpacityMask.png".

	Figure of StandE00 is the file "StandE00.png".
	Figure of StandN00 is the file "StandN00.png".
	Figure of StandS00 is the file "StandS00.png".
	Figure of StandW00 is the file "StandW00.png".
	Figure of WalkE01 is the file "WalkE01.png".
	Figure of WalkE02 is the file "WalkE02.png".
	Figure of WalkE03 is the file "WalkE03.png".
	Figure of WalkE04 is the file "WalkE04.png".
	Figure of WalkN01 is the file "WalkN01.png".
	Figure of WalkN02 is the file "WalkN02.png".
	Figure of WalkN03 is the file "WalkN03.png".
	Figure of WalkN04 is the file "WalkN04.png".
	Figure of WalkS01 is the file "WalkS01.png".
	Figure of WalkS02 is the file "WalkS02.png".
	Figure of WalkS03 is the file "WalkS03.png".
	Figure of WalkS04 is the file "WalkS04.png".
	Figure of WalkW01 is the file "WalkW01.png".
	Figure of WalkW02 is the file "WalkW02.png".
	Figure of WalkW03 is the file "WalkW03.png".
	Figure of WalkW04 is the file "WalkW04.png".


	Section - Window initializations

	The divider is a g-window spawned by the main-window. The type is g-graphics. The position is g-placeright. The measurement is 360. The back-colour is g-lavender.

	The side-window is a text-buffer g-window spawned by the divider. The position of the side-window is g-placebelow. The measurement is 99. The back-colour is g-lavender.

	The graphics-window is a graphics g-window spawned by the divider. The position of the graphics-window is g-placeabove. The measurement of the graphics-window is 260. The back-colour of the graphics-window is g-black. The arbitrary scaling factor of the graphics-window is 1.0000.

	The graphics-canvas is a g-canvas. The canvas-width is 752. The canvas-height is 352. The associated canvas of the graphics-window is the graphics-canvas. The associated canvas of a g-element is the graphics-canvas.

	Window-drawing rule for the side-window (this is the construct inventory rule):
	     move focus to side-window, clearing the window;
	     try taking inventory;
	     return to main screen.

	Every turn when the side-window is g-present: follow the window-drawing rules for the side-window.

	When play begins:
		open up the graphics-window;
		open up the side-window.


	Section - Room sprites

	A room-sprite is a kind of sprite. The graphlink status of a room-sprite is g-inactive. The associated canvas of a room-sprite is graphics-canvas. 

	Some room-sprites are defined by the Table of Room-sprite Elements.

	Table of Room-Sprite Elements
	room-sprite	origin	image-ID	display-layer
	Entry-sprite	{0, 0}	Figure of Entry	1
	Cross-sprite	{95, 48}	Figure of Cross	1
	Annex-sprite	{302, 80}	Figure of Annex	1
	Chamber-sprite	{493, 176}	Figure of Chamber	1

	[The display status of the Chamber-sprite is g-inactive.]


	Section - Icon-sprites

	An icon-sprite is a kind of sprite. The graphlink status of an icon-sprite is g-inactive. The associated canvas of an icon-sprite is graphics-canvas. 

	Some icon-sprites are defined by the Table of Icon-sprite Elements.

	Table of Icon-Sprite Elements
	icon-sprite	origin	image-ID	display-layer	scaling factor
	Player-sprite	{26, -17}	Figure of StandS00	2	0.7500


	Table of Player Icon Positioning
	room	coordinate
	Crypt Annex	{26, 97}
	Cross-Shaped Chamber	{200, 97}
	Dim Corner	{311, 97}
	Dark Corner	{311, 226}
	Untidy Vault	{382, 226}
	Burial Hall	{591, 242}


	Section - Mask sprites

	A mask-sprite is a kind of sprite. Some mask-sprites are defined by the Table of Mask Sprites.

	Table of Mask Sprites
	mask-sprite	image-ID	display-layer	origin
	entrance mask	Figure of Entrance Mask	3	{17, -17}
	opacity mask	Figure of Opacity Mask	4	{493, 176}


	Section - Manual canvas framing

	To decide what list of numbers is (coord - a list of numbers) offset to the origin of (win - a graphics g-window):
		let L be a list of numbers;
		let x be entry 1 of coord;
		let y be entry 2 of coord;
		add ( x - (canvas-width of the associated canvas of win / 2) ) to L;
		add ( y - (canvas-height of the associated canvas of win / 2) ) to L;
		decide on L.


	Section - Walking animations

	The walking track is animation track. The image-reel is {Figure of WalkS01, Figure of WalkS02, Figure of WalkS03, Figure of WalkS04}.

	The movement track is an animation track. The animation-callback of the movement track is "[@ deactivate the walking track][@ now the image-ID of the player-sprite is the facing of the direction gone]".

	A direction has a list of figure names called the direction-reel.

	The direction-reel of north is {Figure of WalkN01, Figure of WalkN02, Figure of WalkN03, Figure of WalkN04}.
	The direction-reel of south is {Figure of WalkS01, Figure of WalkS02, Figure of WalkS03, Figure of WalkS04}.
	The direction-reel of east is {Figure of WalkE01, Figure of WalkE02, Figure of WalkE03, Figure of WalkE04}.
	The direction-reel of west is {Figure of WalkW01, Figure of WalkW02, Figure of WalkW03, Figure of WalkW04}.

	A direction has a figure name called the facing.

	The direction gone is a direction variable.
	The destination room is a room variable.

	The facing of north is Figure of StandN00.
	The facing of south is Figure of StandS00.
	The facing of east is Figure of StandE00.
	The facing of west is Figure of StandW00.

	Before window-framing adjustment of the graphics-window:
		if entrance complete is false:
			center the frame of the graphics-window on canvas coordinates {26, 97};
		otherwise:
			center the frame of the graphics-window on canvas coordinates (origin of the player-sprite);
		continue the action.

	After going (this is the basic walking animation rule):
		unless the room gone from is the Burial Hall or the room gone to is the Burial Hall:
			now the direction gone is the noun;
			now the image-reel of the walking track is the direction-reel of the direction gone;
			set up the movement animation for walking to the room gone to;
			animate the walking track as a reel animation targeting the player-sprite at 8 fps, cycling;
			delay input until all animations are complete;
		continue the action.
	
	To set up the movement animation for walking to (R - a room):
		let L be a list of numbers;
		let L be the coordinate corresponding to a room of R in the Table of Player Icon Positioning;
		animate the movement track as a motion animation targeting the player-sprite and ending at L at 8 fps with velocity of 10.
	

	Section - Walking via a waypoint
	
	The waypoint movement track is an animation track. The animation-callback of the waypoint movement track is "[@ set up the movement animation for walking to the destination room]".
	
	After going when the room gone from is the Burial Hall or the room gone to is the Burial Hall:
		now the direction gone is the noun;
		now the destination room is the room gone to;
		now the image-reel of the walking track is the direction-reel of the direction gone;
		animate the walking track as a reel animation targeting the player-sprite at 8 fps, cycling;
		animate the waypoint movement track as a motion animation targeting the player-sprite and ending at {421, 242} at 8 fps with velocity of 10;
		delay input until all animations are complete; 
		ignore the basic walking animation rule;
		continue the action.
	

	Section - Entrance animation

	The dungeon entrance track is an animation track. The animation-callback is "[@ deactivate the walking track][@ now the image-ID of the player-sprite is Figure of StandS00][@ now entrance complete is true]".

	Entrance complete is a truth state variable. 

	When play begins:
		say "You are Pelón, vampire hunter manqué.[paragraph break]You stand at the entrance to a foul fiend's crypt. Fingering your sharpened stake, you admire its pointy shadow it casts in the morning sun. Today is the day you take up the mantle you were destined to wear--Scourge of the Vampyr![paragraph break]Press any key to descend into the crypt.";
		wait for any key in the main-window;
		say "You step down into the cool damp of the staircase...";
		animate the default track as a zooming animation targeting the player-sprite and ending at 1.0000 at 8 fps with duration 4 frames;
		animate the walking track as a reel animation targeting the player-sprite at 8 fps, cycling;
		animate the dungeon entrance track as a motion animation targeting the player-sprite and ending at {26, 97} at 8 fps with velocity 10;
		delay input until all animations are complete;
		clear the main-window.

	
	Section - Lighting

	The lighting track is an animation track. The easing is the circular easing out rule. The animation-callback is "[@ activate the Chamber-sprite]".

	Understand the command "light" as something new. Understand "light [something]" as switching on.

	Instead of switching on the lamp in the Burial Hall:
		say "You ease the wick out of the base. As the flame flickers to life, the details of the room emerge.";
		deactivate the opacity mask;
		animate the default track as a flicker animation targeting the Chamber-sprite at 18 fps with a duration of 20 frames, randomized;
		animate the lighting track as a fade animation targeting the Chamber-sprite and using the black-fader from 80 % to 0 % at 18 fps with a duration of 20 frames;
		delay input until all animations are complete;
		now the lamp is lit.
	
	Understand "extinguish [something]" as switching off.
	
	Instead of switching off the lamp in the Burial Hall:
		say "You turn down the flame. ";
		animate the lighting track as a fade animation targeting the Chamber-sprite and using the black-fader from 0 % to 75 % at 18 fps with a duration of 8 frames;
		delay input until all animations are complete;
		activate the opacity mask;
		say "The lamp is extinguished.";
		now the lamp is unlit;
		follow the window-drawing rules for the graphics-window.
	
	Instead of switching on the lamp:
		say "You can see well enough thanks to the vents near the ceiling. Better save the oil until you need it."


	Section - World

	The player carries a stake and a lamp. The lamp is a device. The lamp can be lit or unlit. The lamp is unlit.

	Crypt Annex is a room. "The stairs open onto a narrow rectangular hall of vaulted stone. There's no need to fire up the lamp, at least not yet: rectangular sidelights at ground level let in just enough of the day to see by.[paragraph break]At the south end of the room, a hallway leads east."

	Instead of going north in the Annex:
		if we have examined the sarcophagus:
			now the image-reel of the walking track is the direction-reel of north;
			now the animation-callback of the dungeon entrance track is "[@ deactivate the walking track]";
			animate the default track as a fade animation targeting the graphics-window and using the black-fader from 0 % to 100 % at 8 fps with a duration of 20 frames;
			animate the walking track as a reel animation targeting the player-sprite at 8 fps, cycling;
			animate the dungeon entrance track as a motion animation targeting the player-sprite and ending at {26, -17} at 8 fps with a duration of 20 frames;
			now the animation-callback of the default track is "[@ now the associated canvas of the graphics-window is the g-null-canvas]";
			delay input until all animations are complete;
			end the story saying "You have failed to slay the vampire!";
		otherwise:
			say "You're not leaving until you've impaled the fiend."
		
	Instead of going up in the Annex:
		try going north.

	Cross-Shaped Chamber is east of Annex. "You step into a small chamber built in the shape of an Andean cross. Come to think of it, you wish you'd remembered your silver crucifix...[paragraph break]The hall continues to the east."

	Dim Corner is east of Cross-Shaped Chamber. "The hallway turns south here."

	Dark Corner is south of Dim Corner. "The hallway turns again, back to the east, and opens just ahead into a wider space. The sidelights above continue to cast a dim light."

	Untidy Vault is east of Dark Corner. "This is a rather untidy vaulted chamber. You can climb over the rubble to enter the hole that's been punched through the wall to the east."

	Burial Hall is east of Untidy Vault. "The lamp reveals a large chamber. Pillars flank a wide central aisle and disappear into the gloom above. There are no other exits except for the hole to the west by which you entered.[if we have not examined the sarcophagus][paragraph break]Hm, the lack of light from outside would make this a perfect hideaway for the villainous vamp![end if]". The hall is dark.

	After looking in the Hall when we have examined the sarcophagus:
		say "There is nothing to do but to return to the surface. You will slay no undead today.";
		continue the action.

	The sarcophagus is a container in the hall. "A large stone sarcophagus lies open in a niche at the east end of the chamber."  The sarcophagus is fixed in place.

	The description of the sarcophagus is "The sarcophagus is empty. The fiend is not here! Even the earth from his home burial ground has been removed.[paragraph break]He has moved on. You are too late, Pelón!"

	Instead of searching the sarcophagus:
		try examining the sarcophagus.

	The description of the player is "[if we have not examined the sarcophagus]You are fearsome and optimistic[otherwise]Pelón is sad[end if]."


	Section - Image credit

	Report requesting the story file version:
		say "The images used in this demo come courtesy of:[paragraph break] - Sean Howard, via his Free Pixel Project (http://www.squidi.net/pixel/index.php), released under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.[line break] - David E. Gervais (http://pousse.rapiere.free.fr/tome/), released under Creative Commons Attribution 3.0 Unported License."


