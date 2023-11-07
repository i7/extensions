Version 2.0.231013 of Autosave (for Glulx only) by Daniel Stelzer begins here.

"Allows the programmer to save and restore from an autosave file without the user being aware of it."

"based on I6 code from Ultra Undo by Danii Willis"

Include (-
	Array DEFAULT_AUTOSAVE_FN --> PACKED_TEXT_STORAGE "autosave";
	Global just_restored = 0;
	Global autosave_fn = DEFAULT_AUTOSAVE_FN;
-).

The autosave filename is a text variable. The autosave filename variable translates into I6 as "autosave_fn". [The autosave filename is usually "autosave".]

Include (-

[AS_Save opt fref res;
	fref = glk_fileref_create_by_name(fileusage_SavedGame + fileusage_BinaryMode, Glulx_ChangeAnyToCString(TEXT_TY_Say, autosave_fn), 0);
	if ( fref == 0 ) jump SFailed;
	gg_savestr = glk_stream_open_file( fref, $01, GG_SAVESTR_ROCK );
	glk_fileref_destroy( fref );
	if ( gg_savestr == 0 ) jump SFailed;
	@save gg_savestr res;
	if ( res == -1 )
	{
		! We actually just autorestored. But first, we have to recover all the Glk objects; the values
		! in our global variables are all wrong.
		GGRecoverObjects();
		glk_stream_close( gg_savestr, 0 ); ! stream_close
		gg_savestr = 0;
		! Delete this save file if "only once" is set
		if(opt) AS_Delete();
		return 2;
	}
	glk_stream_close( gg_savestr, 0 ); ! stream_close
	gg_savestr = 0;
	if ( res == 0 ) return 1;
	.SFailed;
	return 0;
];

[AS_Restore fref res;
	! Restore from our file
	fref = glk_fileref_create_by_name( fileusage_SavedGame + fileusage_BinaryMode, Glulx_ChangeAnyToCString(TEXT_TY_Say, autosave_fn), 0 );
	if ( fref == 0 ) jump RFailed;
	gg_savestr = glk_stream_open_file( fref, $02, GG_SAVESTR_ROCK );
	glk_fileref_destroy( fref );
	if ( gg_savestr == 0 ) jump RFailed;
	@restore gg_savestr res;
	glk_stream_close( gg_savestr, 0 );
	gg_savestr = 0;
	.RFailed;
	return 0;
];

[AS_Delete fref;
	fref = glk_fileref_create_by_name( fileusage_SavedGame + fileusage_BinaryMode, Glulx_ChangeAnyToCString(TEXT_TY_Say, autosave_fn), 0 );
	if ( fref ~= 0 )
	{
		if ( glk_fileref_does_file_exist( fref ) )
		{
			glk_fileref_delete_file( fref );
		}
		glk_fileref_destroy( fref );
	}
];

-).

[ Clean up after ourselves when the player quits or restarts - delete all the external files unless using PERSISTENT_AUTOSAVE ]

Include (-

[ QUIT_THE_GAME_R;
	if ( actor ~= player ) rfalse;
	if ((actor == player) && (untouchable_silence == false))
		QUIT_THE_GAME_RM('A');
	if ( YesOrNo()~=0 ){
		#ifndef PERSISTENT_AUTOSAVE;
		AS_Delete();
		#endif;
		quit;
	}
];

-) replacing "QUIT_THE_GAME_R".

Include (-

[ RESTART_THE_GAME_R;
	if (actor ~= player) rfalse;
	RESTART_THE_GAME_RM('A');
	if (YesOrNo() ~= 0){
		#ifndef PERSISTENT_AUTOSAVE;
		AS_Delete();
		#endif;
		@restart;
		RESTART_THE_GAME_RM('B'); new_line;
	}
];

-) replacing "RESTART_THE_GAME_R".

To autosave the game, only restoring once: (- just_restored = AS_Save({phrase options}); -).
To autorestore the game: (- AS_Restore(); -).
To delete the/-- autosave/autosaves file/files/--: (- AS_Delete(); -).
To decide whether we/-- just/-- restored from/-- an/the/-- autosave: (- (just_restored == 2) -);

Use persistent autosaves translates as (- Constant PERSISTANT_AUTOSAVE; -).

Autosave ends here.

---- DOCUMENTATION ----

This is a simple extension based on Ultra Undo to allow "hidden" save and restore functions, which don't prompt the user for a filename.

The relevant phrases are:

	autosave the game
	autosave the game, only restoring once

These create an autosave to jump back to later. If "only restoring once" is specified, the save will be deleted after it's been used once; this is useful for something like a roguelike, where you can save to leave and come back later, but not to restore after a mistake. (This has to be specified in the saving phrase, rather than the restoring one, because that's where execution continues after restoring.)

	if we restored from an autosave

When restoring an autosave, the program continues right after the "autosave the game" phrase was called. We can check this condition to know whether we're coming from a save or a restore.

	autorestore the game

This phrase jumps back to the most recent autosave, without any prompting. The code after this phrase will only be executed if the restore failed.

	delete the autosave file

This phrase does exactly what it sounds like. If no autosave data exists, it does nothing.

There's one text variable that you should probably change for your particular story:

	the autosave filename

By default, this is simply "autosave", but if multiple games use the same filename, their autosaves *might* overwrite each other. (Whether they actually do or not depends on the interpreter; some interpreters keep each game's autosaves separate, while others save them all as normal files in the current working directory.)

So to avoid problems, it's better to make this include your story's name, e.g. "acheton_autosave". It *is* legal to change this during play, but if it changes between saving and restoring, the story won't be able to find its save data.

By default, autosaves are deleted when the player quits or restarts the game—not just closing the interpreter, but using the QUIT or RESTART command. If you don't want this, you can specify:

	Use persistent autosaves.
