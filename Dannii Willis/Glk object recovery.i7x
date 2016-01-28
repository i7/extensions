Version 1/160128 of Glk object recovery (for Glulx only) by Dannii Willis begins here.

"A low level utility library for managing Glk references after restarting or restoring"

[ This extension was extracted from Glulx Entry points. See http://www.intfiction.org/forum/viewtopic.php?f=7&t=19605 for more discussion. ]

Use authorial modesty.

Section - Glk object recovery

[ These should technically all be called 'glk' rulebooks, but we'll keep them named 'glulx' for compatibility. ]
The glulx zeroing-reference rules is a rulebook.
The glulx resetting-windows rules is a rulebook.
The glulx resetting-streams rules is a rulebook.
The glulx resetting-filerefs rules is a rulebook.
The glulx resetting-channels rules is a rulebook.
The glulx object-updating rules is a rulebook.

Current glulx rock is a number that varies.
Current glulx rock-ref is a number that varies.

Include (-

[ IdentifyGlkObject phase type ref rock;
	if ( phase == 0 )
	{
		! Zero out references to our objects.
		if ( FollowRulebook( (+ glulx zeroing-reference rules +) ) && RulebookSucceeded() )
		{
			rtrue;
		}
	}

	if ( phase == 1 )
	{
		! Reset our windows, streams, filerefs and sound channels.
		(+ current glulx rock +) = rock;
		(+ current glulx rock-ref +) = ref;
		switch ( type )
		{
			0: FollowRulebook( (+ glulx resetting-windows rules +) );
			1: FollowRulebook( (+ glulx resetting-streams rules +) );
			2: FollowRulebook( (+ glulx resetting-filerefs rules +) );
			3: FollowRulebook( (+ glulx resetting-channels rules +) );
		}
		rtrue;
	}

	if ( phase == 2 )
	{
		! Update our objects.
		if ( FollowRulebook( (+ glulx object-updating rules +) ) && RulebookSucceeded() )
		{
			rtrue;
		}
	}
];

-) before "Glulx.i6t".

Glk object recovery ends here.

---- Documentation ----

This extension is a low level utility library for managing Glk references. When a Glulx game restarts and restores, the current Glk IO state is not reset. All the old windows, sound channels etc. will be kept as they were, even though the game file might be expecting a different state. This extension allows Inform 7 game files to ensure that the IO state is as it should be. It does this in three stages:

1. The "glulx zeroing-reference rulebook" is run. Rules should be added to reset all Glk references as if none existed.

2. The "glulx resetting-windows rulebook" etc. are run. These rulebooks will be run once for each Glk IO object which does currently exist.

3. The "glulx object-updating rulebook" is run. Rules should be added to correct the Glk IO state by, for example, closing windows which shouldn't exist, and opening windows which should but currently do not.

See the extension Flexible Windows by Jon Ingold for a practical demonstration of how these rulebooks are used.

The latest version of this extension can be found at <https://github.com/i7/extensions>. This extension is released under the Creative Commons Attribution licence. Bug reports, feature requests or questions should be made at <https://github.com/i7/extensions/issues>.