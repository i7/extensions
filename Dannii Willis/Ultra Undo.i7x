Version 1/130107 of Ultra Undo (for Glulx only) by Dannii Willis begins here.

"Handles undo using external files for very big story files"

Include (-

! Our undo counter
Global ultra_undo_counter = 0;

[ VM_Undo result_code;
	! If we are using external files
	if ( ultra_undo_counter > 0 )
	{
		return Ultra_Undo();
	}
	
	@restoreundo result_code;
	return ( ~~result_code );
];

[ VM_Save_Undo result_code;
	! If we are using external files
	if ( ultra_undo_counter > 0 )
	{
		return Ultra_Save_Undo();
	}
	
	@saveundo result_code;
	! Check if it we have just restored
	if ( result_code == -1 )
	{
		GGRecoverObjects();
		return 2;
	}
	! Check if it failed
	if ( result_code == 1 )
	{
		return Ultra_Save_Undo();
	}
	return ( ~~result_code );
];

[ Ultra_Undo fref res;
	! Restore from our file
	fref = glk_fileref_create_by_name( fileusage_SavedGame + fileusage_BinaryMode, Glulx_ChangeAnyToCString( Ultra_Undo_Filename ), 0 );
	if (fref == 0) jump RFailed;
	gg_savestr = glk_stream_open_file(fref, $02, GG_SAVESTR_ROCK);
	glk_fileref_destroy(fref);
	if (gg_savestr == 0) jump RFailed;
	@restore gg_savestr res;
	glk_stream_close(gg_savestr, 0);
	gg_savestr = 0;
	.RFailed;
	return 0;
];

[ Ultra_Save_Undo fref res;
	ultra_undo_counter++;
	fref = glk_fileref_create_by_name( fileusage_SavedGame + fileusage_BinaryMode, Glulx_ChangeAnyToCString( Ultra_Undo_Filename ), 0 );
	if (fref == 0) jump SFailed;
	gg_savestr = glk_stream_open_file(fref, $01, GG_SAVESTR_ROCK);
	glk_fileref_destroy(fref);
	if (gg_savestr == 0) jump SFailed;
	@save gg_savestr res;
	if (res == -1) {
		! The player actually just typed "undo". But first, we have to recover all the Glk objects; the values
		! in our global variables are all wrong.
		GGRecoverObjects();
		glk_stream_close(gg_savestr, 0); ! stream_close
		gg_savestr = 0;
		! Remember do decrement the counter!
		ultra_undo_counter--;
		return 2;
	}
	glk_stream_close(gg_savestr, 0); ! stream_close
	gg_savestr = 0;
	if (res == 0) return 1;
	.SFailed;
	ultra_undo_counter--;
	return 0;
];

[ Ultra_Undo_Filename ix;
	print "ultraundo";
	for (ix=6: ix <= UUID_ARRAY->0: ix++) print (char) UUID_ARRAY->ix;
	print ultra_undo_counter;
];

-) instead of "Undo" in "Glulx.i6t".

Ultra Undo ends here.