Version 3 of Multiple Sounds by Massimo Stella begins here.

"Provides facilities for the basic reproduction of multiple-channel audio with loops under Glulx."

"based on original Glulx code by Wade Clarke" 

[Original 2 channel extension by Massimo Stella. Midground channel additions from Wade Clarke.]

[Massimo: The idea for this extension was born from some code written by Eliak Blau on rec.arts.int-fiction in 2008. Thanks to Sarganar for his bug report. Thanks to Wade for his additions.]

[Wade: 65536 is the maximum glk volume.]

Section - IF6 Code

Include (-

Global gg_thirdchan = 0;
Constant GG_THIRDCHAN_ROCK 412;

Global gg_fourthchan = 0;
Constant GG_FOURTHCHAN_ROCK 413;

Global gg_fifthchan = 0;
Constant GG_FIFTHCHAN_ROCK 414;

Global gg_sixthchan = 0;
Constant GG_SIXTHCHAN_ROCK 415;

-) before "Glulx.i6t".

[Add globals for any more channels you want in the above Include section.]

Include (-

[ SoundReproduce sound chan loop;
if (glk_gestalt(gestalt_Sound,0) && glk_gestalt(gestalt_SoundMusic,0))  { 
	glk_schannel_play_ext(chan,sound,loop,0); 
	}
else { 
	"Your interpreter doesn't support sound reproduction."; 
	}
];

[ VolumeControl chan val;
if (glk_gestalt(gestalt_SoundVolume,0)) {
	if ((val <= 5) && (val > 0)) {
		glk_schannel_set_volume(chan, val * 13107+1);
		}
	else if (val == 0) { 
		glk_schannel_set_volume(chan, val);
	}
	else {
		"Invalid Volume Level: please insert a value between 0 and 5.";
		}
	}
else {
	"Your interpreter doesn't support volume control."; 
	}
];

[ VolumeRaw chan val;
if (glk_gestalt(gestalt_SoundVolume,0)) {
	if ((val <= 65536) && (val >=0)) {
		glk_schannel_set_volume(chan, val);
		}
	else {
		"Invalid Volume Level: please insert a value between 0 and 65536.";
		}
	}
else {
	"Your interpreter doesn't support volume control."; 
	}
];

[ SoundStop chan;
if (glk_gestalt(gestalt_Sound,0) && glk_gestalt(gestalt_SoundMusic,0))  { 
	glk_schannel_stop(chan);  
	}
else { 
	"Your interpreter doesn't support sound stopping."; 
	}
];

[ ThirdCreate;
	if (glk_gestalt(gestalt_Sound, 0)) {
		if (gg_thirdchan == 0)
			gg_thirdchan = glk_schannel_create(GG_THIRDCHAN_ROCK);
	}
];

[ FourthCreate;
	if (glk_gestalt(gestalt_Sound, 0)) {
		if (gg_fourthchan == 0)
			gg_fourthchan = glk_schannel_create(GG_FOURTHCHAN_ROCK);
	}
];

[ FifthCreate;
	if (glk_gestalt(gestalt_Sound, 0)) {
		if (gg_fifthchan == 0)
			gg_fifthchan = glk_schannel_create(GG_FIFTHCHAN_ROCK);
	}
];

[ SixthCreate;
	if (glk_gestalt(gestalt_Sound, 0)) {
		if (gg_sixthchan == 0)
			gg_sixthchan = glk_schannel_create(GG_SIXTHCHAN_ROCK);
	}
]; -).

[Add your own 'Create' calls for any new channels you want to add to your game here.]

[Wade: I added the VolumeRaw call to allow the programmer to directly set the 0-65536 volume from their I7 code. This is needed for programming your own fades.]


Section - Declaring Commands

[Creation Commands]

To create the midground channel:
(- ThirdCreate(GG_THIRDCHAN_ROCK); -)

To create the midground 0 channel:
(- ThirdCreate(GG_THIRDCHAN_ROCK); -)

To create the midground 1 channel:
(- FourthCreate(GG_FOURTHCHAN_ROCK); -)

To create the midground 2 channel:
(- FifthCreate(GG_FIFTHCHAN_ROCK); -)

To create the midground 3 channel:
(- SixthCreate(GG_SIXTHCHAN_ROCK); -)

[Add your own 'Create' declarations for any new channels you want to add to your game here.]

[Playing Commands]

To play (SND - a sound name) in foreground:
(- SoundReproduce(ResourceIDsOfSounds-->{SND},gg_foregroundchan,1); -)

To play (SND - a sound name) in background:
(- SoundReproduce(ResourceIDsOfSounds-->{SND},gg_backgroundchan,1); -)

To play (SND - a sound name) in midground:
(- SoundReproduce(ResourceIDsOfSounds-->{SND},gg_thirdchan,1); -)

To play (SND - a sound name) in midground 0:
(- SoundReproduce(ResourceIDsOfSounds-->{SND},gg_thirdchan,1); -)

To play (SND - a sound name) in midground 1:
(- SoundReproduce(ResourceIDsOfSounds-->{SND}, gg_fourthchan,1); -)

To play (SND - a sound name) in midground 2:
(- SoundReproduce(ResourceIDsOfSounds-->{SND}, gg_fifthchan,1); -)

To play (SND - a sound name) in midground 3:
(- SoundReproduce(ResourceIDsOfSounds-->{SND}, gg_sixthchan,1); -)

[Loop Commands]

To play (SND - a sound name) in foreground with loop:
(- SoundReproduce(ResourceIDsOfSounds-->{SND},gg_foregroundchan,-1); -)

To play (SND - a sound name) in foreground for (loop - a number) times:
(- SoundReproduce(ResourceIDsOfSounds-->{SND},gg_foregroundchan,{loop}); -)

To play (SND - a sound name) in background with loop:
(- SoundReproduce(ResourceIDsOfSounds-->{SND},gg_backgroundchan,-1); -)

To play (SND - a sound name) in background for (loop - a number) times:
(- SoundReproduce(ResourceIDsOfSounds-->{SND},gg_backgroundchan,{loop}); -)

To play (SND - a sound name) in midground with loop:
(- SoundReproduce(ResourceIDsOfSounds-->{SND},gg_thirdchan,-1); -)

To play (SND - a sound name) in midground for (loop - a number) times:
(- SoundReproduce(ResourceIDsOfSounds-->{SND},gg_thirdchan,{loop}); -)

To play (SND - a sound name) in midground 0 with loop:
(- SoundReproduce(ResourceIDsOfSounds-->{SND},gg_thirdchan,-1); -)

To play (SND - a sound name) in midground 0 for (loop - a number) times:
(- SoundReproduce(ResourceIDsOfSounds-->{SND},gg_thirdchan,{loop}); -)

To play (SND - a sound name) in midground 1 with loop:
(- SoundReproduce(ResourceIDsOfSounds-->{SND},gg_fourthchan,-1); -)

To play (SND - a sound name) in midground 1 for (loop - a number) times:
(- SoundReproduce(ResourceIDsOfSounds-->{SND},gg_fourthchan,{loop}); -)

To play (SND - a sound name) in midground 2 with loop:
(- SoundReproduce(ResourceIDsOfSounds-->{SND},gg_fifthchan,-1); -)

To play (SND - a sound name) in midground 2 for (loop - a number) times:
(- SoundReproduce(ResourceIDsOfSounds-->{SND},gg_fifthchan,{loop}); -)

To play (SND - a sound name) in midground 3 with loop:
(- SoundReproduce(ResourceIDsOfSounds-->{SND},gg_sixthchan,-1); -)

To play (SND - a sound name) in midground 3 for (loop - a number) times:
(- SoundReproduce(ResourceIDsOfSounds-->{SND},gg_sixthchan,{loop}); -)

[Volume Commands - The argument has to be a value between 0 and 5]

To set the foreground volume to (VOL - a number):
(- VolumeControl(gg_foregroundchan,{VOL}); -)

To set the background volume to (VOL - a number):
(- VolumeControl(gg_backgroundchan,{VOL}); -)

To set the midground volume to (VOL - a number):
(- VolumeControl(gg_thirdchan,{VOL}); -)

To set the midground 0 volume to (VOL - a number):
(- VolumeControl(gg_thirdchan,{VOL}); -)

To set the midground 1 volume to (VOL - a number):
(- VolumeControl(gg_fourthchan,{VOL}); -)

To set the midground 2 volume to (VOL - a number):
(- VolumeControl(gg_fifthchan,{VOL}); -)

To set the midground 3 volume to (VOL - a number):
(- VolumeControl(gg_sixthchan,{VOL}); -)

[RawVolume Commands -  The argument has to be a value between 0 and 65536]

To set the raw foreground volume to (VOL - a number):
(- VolumeRaw(gg_foregroundchan,{VOL}); -)

To set the raw background volume to (VOL - a number):
(- VolumeRaw(gg_backgroundchan,{VOL}); -)

To set the raw midground volume to (VOL - a number):
(- VolumeRaw(gg_thirdchan,{VOL}); -)

To set the raw midground 0 volume to (VOL - a number):
(- VolumeRaw(gg_thirdchan,{VOL}); -)

To set the raw midground 1 volume to (VOL - a number):
(- VolumeRaw(gg_fourthchan,{VOL}); -)

To set the raw midground 2 volume to (VOL - a number):
(- VolumeRaw(gg_fifthchan,{VOL}); -)

To set the raw midground 3 volume to (VOL - a number):
(- VolumeRaw(gg_sixthchan,{VOL}); -)

[Stop Commands]

To stop the foreground sound:
(- SoundStop(gg_foregroundchan); -)

To stop the background sound:
(- SoundStop(gg_backgroundchan); -)

To stop the midground sound:
(- SoundStop(gg_thirdchan); -)

To stop the midground 0 sound:
(- SoundStop(gg_thirdchan); -)

To stop the midground 1 sound:
(- SoundStop(gg_fourthchan); -)

To stop the midground 2 sound:
(- SoundStop(gg_fifthchan); -)

To stop the midground 3 sound:
(- SoundStop(gg_sixthchan); -)


Multiple Sounds ends here.

---- DOCUMENTATION ---- 

After having declared the name of an audio file, like indicated in the IF7 main documentation:

	Sound of frogs is the file "Frogs.ogg". 

We can choose how to reproduce it, on the background channel or on the foreground one:

	play the sound of frogs in background;
	play the sound of frogs in foreground;

Starting from Version 3, Multiple Sounds supports more than 2 audio channels, however the extra ones have to be declared inside the IF7 game code.  Use the 'create' commands to establish any desired extra channels BEFORE you try to play any sounds on those! A good time to do it is when play begins:

	When play begins:
		create the midground channel;
		create the midground 1 channel;
		create the midground 2 channel;
		play the sound of frogs in  midground;

The enumeration distinguishes the various midground channels created by the author. Please bear in mind that the midground and the midground 0 are the same channel. Currently Multiple Sounds has 4 midground channels {0,1,2,3}, implemented by Wade Clarke, however with minimal interventions the user can create additional channels. The number of effectively well functioning audio channels depends on the interpreter used and may greatly vary. Almost surely the three background, midground and foreground channels should be enough for most of the IF works.

Sometimes a continuous loop might be useful:

	play the sound of frogs in background with loop;
	play the sound of frogs in foreground with loop;
	play the sound of frogs in midground with loop;

Also the repetition of a specific audio file for N times is supported:

	play the sound of frogs in background for 5 times;
	play the sound of sea in foreground for 10 times;
	play the sound of sea in midground 2 for 25 times;
	
Glulx allows to play multiple sounds at the same time, provided they are reproduced on different channels:

	play the sound of frogs in background;
	play the sound of fifths in foreground;
	play the sound of air in midground 1;

To stop an audio file:

	stop the foreground sound;
	stop the midground 2 sound;
	stop the background sound;

To modify volume from a minimum level of 0 (silence) to a maximum level of 5 (full volume):

	set the foreground volume to 2;
	set the background volume to 1;
	set the midground volume to 4;
	
To modify the volume from a minimum level of 0 (silence) to a maximum level of 65536 (full volume) use instead the raw volume option:

	set the raw foreground volume to 10000;
	set the raw midground volume to 2000;
	set the raw background volume to 3500.
	
Example: * Rainforest - Shows how to use multiple sounds effects to mimic a natural environment.

	*:	"Rainforest"
	
	Include Multiple Sounds by Massimo Stella.
	
	The Swamp is a room. The description is "A beautiful mirror of water is in front of your eyes while behind you there are the tallest trees you've ever seen. You can hear the sound of some frogs in the distance."
	
	Sound of frogs is the file "Frogs.ogg". 
	Sound of water is the file "Water.ogg".
	Sound of wind is the file "Storm.ogg".
	
	When play begins:
		set the background volume to 2;
		play the sound of frogs in background;
		set the foreground volume to 3;
		play the sound of water in foreground with loop;
		create the midground channel;
		set the raw midground volume to 10000;
		play the sound of wind in midground.
	