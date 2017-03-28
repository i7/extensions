Music by Daniel Stelzer begins here.

"A music-focused sound extension, which allows authors to loop sounds on different channels and fade between them."

"based on code by Massimo Stella and Wade Clarke (Glulx sound), Erik Temple (Glulx timing), and Eliuk Blau (DAMUSIX for I6)"

Include Glulx Entry Points by Emily Short.

Book I - Channels and Loops

A sound channel is a kind of value. The sound channels are foreground, background, and midground.

Include (-

Global gg_midgroundchan = 0;
Constant GG_MIDGROUNDCHAN_ROCK 412;

[ MidgroundCreate;
	if (glk_gestalt(gestalt_Sound, 0)) {
		if (gg_midgroundchan == 0)
			gg_midgroundchan = glk_schannel_create(GG_MIDGROUNDCHAN_ROCK);
	}
];

-) before "Glulx.i6t".

To initialize additional sound channels:
	(- MidgroundCreate(); -).

After starting the virtual machine (this is the initialize sound channels rule):
	initialize additional sound channels.

To loop (SFX - sound name):
	now the sound channel of the SFX is the foreground;
	internally play the SFX on the foreground repeating -1 times .

To loop (SFX - sound name) on (ground - sound channel):
	now the sound channel of the SFX is the ground;
	internally play the SFX on the ground repeating -1 times.

To play (SFX - sound name) repeating (N - number) time/times:
	now the sound channel of the SFX is the foreground;
	internally play the SFX on the foreground repeating N times.

To play (SFX - sound name) on (ground - sound channel) repeating (N - number) time/times:
	now the sound channel of the SFX is the ground;
	internally play the SFX on the ground repeating N times.

To play (SFX - sound name) on (ground - sound channel):
	now the sound channel of the SFX is the ground;
	internally play the SFX on the ground repeating one time.

To internally play (SFX - sound name) on (ground - sound channel) repeating (N - number) time/times:
	(- PlaySoundLoop(ResourceIDsOfSounds-->{SFX},{ground},{N}); -).

Include (-
[ DereferenceChannel channel N;
	switch(channel){
		1: N = gg_foregroundchan;
		2: N = gg_backgroundchan;
		3: N = gg_midgroundchan;
		default: N = -1;
	}
	return N;
];

[ GetIntensity channel N;
	switch(channel){
		1: N = 1;
		2: N = 1;
		3: N = 1;
		default: N = -1;
	}
	return N;
];
-)

Include (-
[ PlaySoundLoop resource_ID channel loop N;
	N = DereferenceChannel(channel);
	if (resource_ID == 0) return;
	ResourceUsageFlags->resource_ID = true;
	if (glk_gestalt(gestalt_Sound, 0)){
		glk_schannel_play_ext(N, resource_ID, loop, 0);
	}
];
-).

A sound name has a sound channel. [This stores the channel it is currently playing on.]

To stop (SFX - sound name):
	let the ground be the sound channel of the SFX;
	stop the SFX on the ground.

To stop (SFX - sound name) on (ground - sound channel):
	(-StopSound(ResourceIDsOfSounds-->{SFX},{ground}); -).

Include (-
[ StopSound resource_ID channel N;
	N = DereferenceChannel(channel);
	if (resource_ID == 0) return;
	ResourceUsageFlags->resource_ID = true;
	if (glk_gestalt(gestalt_Sound, 0)){
		glk_schannel_stop(N);
	}
];
-).

Book II - Fades

Chapter 1 - Volume

Include (-
[ SetVolume channel volume N;
	N = DereferenceChannel(channel);
	volume = volume / GetIntensity(channel);
	if (glk_gestalt(gestalt_SoundVolume,0)) {
		if ((volume <= 65536) && (volume >=0)) {
			glk_schannel_set_volume(N, volume);
		}else {
			"SetVolume error: value must be between 0 and 65536.";
		}
	}else {
		"SetVolume error: your interpreter does not support volume control."; 
	}
];
-).

To set the/-- volume of (ground - sound channel) to (volume - number):
	(- SetVolume({ground},{volume}); -).

Chapter 2 - Timing

To set the/a/-- timer for (T - number) milliseconds/millisecond/ms:
	(- if(glk_gestalt(gestalt_Timer, 0)) glk_request_timer_events({T}); -).

To stop a/the/-- timer:
	(- if(glk_gestalt(gestalt_Timer, 0)) glk_request_timer_events(0); -).

Chapter 3 - Straight Fading

The current fade tick is a number that varies.
The current fade start is a number that varies.
The current fade end is a number that varies.
The current fade length is a number that varies.
The current fade channel is a sound channel that varies.
The fade flag is a truth state that varies.

To decide whether a fade is in progress:
	decide on the fade flag.

To fade the/-- (ground - a sound channel) from (start volume - a number) to (end volume - a number) over (time - a number) milliseconds/millisecond/ms:
	if the fade flag is true, stop;
	set the timer for five milliseconds;
	now the current fade channel is the ground;
	now the current fade tick is zero;
	now the current fade start is the start volume;
	now the current fade end is the end volume;
	now the current fade length is the time divided by 10; [Why is this necessary? I have no idea.]
	now the fade flag is true.

A glulx timed activity rule (this is the straight fade timing rule):
	if the fade flag is true, calculate the fade.

To calculate the fade:
	(- FadeStep(); -).

Include (-
[ FadeStep vol time delta;
	vol = (+current fade end+) - (+current fade start+); ! the difference between the end and the start
	time = (+current fade length+) / 5; ! the time required to change, in ticks
	delta = vol / time; ! the amount it should change per tick
	vol = delta * (+current fade tick+); ! delta times the tick we're on
	vol = vol + (+current fade start+); ! plus the volume we started at
	(+current fade tick+)++; ! increment the tick
	if(((+current fade start+)>(+current fade end+) && vol < (+current fade end+)) || ((+current fade start+)<(+current fade end+) && vol > (+current fade end+))){
		(+fade flag+) = false; ! end the fade if we're past the end volume
	}else{
		SetVolume((+current fade channel+), vol); ! set the volume
	}
];
-).

Chapter 4 - Cross-Fading

The current crossfade start is a number that varies.
The current crossfade end is a number that varies.
The current crossfade channel is a sound channel that varies.
The current crossfade tick is a number that varies. [We need two tick counters for one edge case: rounding errors cause the normal fade to stop one tick before the crossfade, so the crossfade never finishes and blocks the sound system forever.]
The crossfade flag is a truth state that varies.

To decide whether or not a crossfade is in progress:
	decide on the crossfade flag.

To start a crossfade with the/-- (primary - a sound channel) going from (primary start - a number) to (primary end - a number) and the/-- (secondary - a sound channel) going from (secondary start - a number) to (secondary end - a number) over (time - a number) milliseconds/millisecond/ms:
	if the fade flag is true or the crossfade flag is true, stop;
	fade the primary from primary start to primary end over time ms;
	now the current crossfade channel is the secondary;
	now the current crossfade start is the secondary start;
	now the current crossfade end is the secondary end;
	now the current crossfade tick is zero;
	now the crossfade flag is true.

A glulx timed activity rule (this is the crossfade timing rule):
	if the crossfade flag is true, calculate the crossfade.

To calculate the crossfade:
	(- XFadeStep(); -).

Include (-
[ XFadeStep vol time delta;
	vol = (+current crossfade end+) - (+current crossfade start+); ! the difference between the end and the start
	time = (+current fade length+) / 5; ! the time required to change, in ticks
	delta = vol / time; ! the amount it should change per tick
	vol = delta * (+current crossfade tick+); ! delta times the tick we're on
	vol = vol + (+current crossfade start+); ! plus the volume we started at
	(+current crossfade tick+)++; ! increment the tick
	if(((+current crossfade start+)>(+current crossfade end+) && vol < (+current crossfade end+)) || ((+current crossfade start+)<(+current crossfade end+) && vol > (+current crossfade end+))){
		(+crossfade flag+) = false; ! end the crossfade if we're past the end volume
	}else{
		SetVolume((+current crossfade channel+), vol); ! set the volume
	}
];
-).

Chapter 5 - Additional Music Fade Rules

The main music channel is a sound channel that varies. [The main music channel is foreground.]
The opposing music channel is a sound channel that varies.
To decide which sound channel is the opposite to (ground - a sound channel):
	if the ground is foreground, decide on background;
	if the ground is background, decide on foreground;
	decide on midground.

To introduce (SFX - sound name):
	if the crossfade flag is true, stop; [No overlap!]
	now the opposing music channel is the main music channel;
	if the main music channel is foreground, now the main music channel is background;
	otherwise now the main music channel is foreground;
	loop the SFX on the main music channel;
	start a crossfade with the main music channel going from 0 to 65535 and the opposing music channel going from 65535 to 0 over 2000 milliseconds.

Music ends here.

---- DOCUMENTATION ----

This is a very simple sound and music library for Glulx. There are three sound channels: foreground, background, and midground. (More can be created, but it requires editing the extension.) Sounds are initialized as described in Writing with Inform, but the process of controlling them has changed.

	loop (sound name)
	loop (sound name) on (sound channel)
	play (sound name) repeating (number) times
	play (sound name) on (sound channel)
	play (sound name) on (sound channel) repeating (number) times
	stop (sound name)

If no channel is specified, it defaults to the foreground.

You can also fade a channel in or out, or crossfade them, although only one fade can be running at a time.

	fade (sound channel) from (volume) to (volume) over (number) milliseconds/ms
	start a crossfade with (sound channel) going from (volume) to (volume) and (sound channel) going from (volume) to (volume) over (number) milliseconds/ms

Volumes are specified as numbers between 0 (silent) and 65535 (maximum volume). All sounds start at 65535 unless otherwise specified.

To make crossfades easier in the most common usage case, there is a simpler phrase as well.

	introduce (sound name)

This starts a new soundtrack looping on either the foreground or the background channel and crossfades it in over two seconds, sending the opposite channel to zero.
NB: If you attempt to introduce a new sound while a different one is still being faded in, the older one will take precedence! To prevent that, you can use this check.

	if a crossfade is in progress...

Depending on your usage, you could add a simple do-nothing loop until the fade is finished, or modify the "calculate the crossfade rule" to switch tracks in the middle of the fade.
