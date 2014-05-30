Autosave (for Glulx only) by Daniel Stelzer begins here.

"Allows the programmer to save and restore from an autosave file without the user being aware of it"

"based on I6 code from Ultra Undo by Danii Willis"

Include (-

[AS_Save fref res;
	fref = glk_fileref_create_by_name(fileusage_SavedGame + fileusage_BinaryMode, Glulx_ChangeAnyToCString("autosave"), 0);
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
		! Delete this save file
		AS_Delete();
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
	fref = glk_fileref_create_by_name( fileusage_SavedGame + fileusage_BinaryMode, Glulx_ChangeAnyToCString("autosave"), 0 );
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
	fref = glk_fileref_create_by_name( fileusage_SavedGame + fileusage_BinaryMode, Glulx_ChangeAnyToCString("autosave"), 0 );
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

[ Clean up after ourselves when the player quits or restarts - delete all the external files ]

Include (-

[ QUIT_THE_GAME_R;
	if ( actor ~= player ) rfalse;
	GL__M( ##Quit, 2 );
	if ( YesOrNo()~=0 )
	{
		AS_Delete();
		quit;
	}
];

-) instead of "Quit The Game Rule" in "Glulx.i6t".

Include (-

[ RESTART_THE_GAME_R;
	if (actor ~= player) rfalse;
	GL__M(##Restart, 1);
	if ( YesOrNo() ~= 0 )
	{
		AS_Delete();
		@restart;
		GL__M( ##Restart, 2 );
	}
];

-) instead of "Restart The Game Rule" in "Glulx.i6t".

To autosave the game: (- AS_Save(); -).
To autorestore the game: (- AS_Restore(); -).
To delete the/-- autosave/autosaves file/files/--: (- AS_Delete(); -).

Autosave ends here.

 ---- DOCUMENTATION ----
 
 This is a simple extension based on Ultra Undo to allow "hidden" save and restore functions, which don't prompt the user for a filename. The relevant phrases are "autosave the game", "autorestore the game", and "delete the autosave file".
