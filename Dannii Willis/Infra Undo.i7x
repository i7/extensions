Version 1/170502 of Infra Undo (for Glulx only) by Dannii Willis begins here.

"Handles undo using external files for very big story files"

Include Version 7 of Glulx Entry Points by Emily Short.

Use maximum file based undo count of at least 5 translates as (- Constant INFRA_UNDO_MAX_COUNT = {N}; -). 

Use file based undo translates as (- Constant INFRA_UNDO_ALWAYS_ON; -).


[ If the interpreter cannot perform an undo for us, store the state using external files. We can do this by hijacking VM_Undo and VM_Save_Undo. ]

Include (-

! Our undo counter
Global infra_undo_counter = 0;
Global infra_undo_needed = 0;

! A fileref to a tempfile to store infra_undo_counter across restores
Global infra_undo_counter_fileref = 0;
Constant IU_COUNTER_ROCK = 999;

! Array of fileref values to keep track of temporary undo files
Array undo_array --> INFRA_UNDO_MAX_COUNT;
Constant IU_FILE_ROCK_0 = 1000;

[ Init_Infra_Undo_Counter; 
	!Initiate Infra Undo Counter fileref
	if ( infra_undo_needed == 1)
	{
		infra_undo_counter_fileref = glk_fileref_create_temp( fileusage_SavedGame + fileusage_BinaryMode, IU_COUNTER_ROCK );
		if ( infra_undo_counter_fileref ~= 0 ) Write_Infra_Undo_Counter_File(); 
	}
];

[ Write_Infra_Undo_Counter_File str; 
	str = glk_stream_open_file( infra_undo_counter_fileref, filemode_Write, 0 );
	if (str == 0) rfalse;

	glk_put_char_stream_uni( str, infra_undo_counter );
	glk_stream_close( str, 0 );
];

! Test if the VM is able to perform an undo. This is necessary because Git won't tell us that it can't.
[ Infra_Undo_Test res;
	
#ifdef INFRA_UNDO_ALWAYS_ON;
	infra_undo_needed = 1;
	rfalse;
#endif;

	@saveundo res;
	if ( res == 1 ) ! Failure
	{
		infra_undo_needed = 1;
		rfalse;
	}
	if ( res == -1 ) ! Success
	{
		infra_undo_needed = 0;
		rfalse;
	}
	@restoreundo res;
	if ( res == 1 ) ! Failure
	{
		infra_undo_needed = 1;
		rfalse;
	}
];

[ VM_Undo result_code;
	! If we are using external files
	if ( infra_undo_needed )
	{
		return Infra_Undo();
	}
	
	@restoreundo result_code;
	return ( ~~result_code );
];

[ VM_Save_Undo result_code;
	! Handle Undo being disabled by Undo Output Control
	if ( ~~(+ save undo state +) )
	{
		return -2;
	}
	
	! If we are using external files
	if ( infra_undo_needed )
	{
		return Infra_Save_Undo();
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
		infra_undo_needed = 1;
		return Infra_Save_Undo();
	}
	return ( ~~result_code );
];

[ Infra_Undo fref res;
	Write_Infra_Undo_Counter_File(); 
	! Restore from our file
	fref = undo_array --> Infra_Undo_Index();
	if ( fref == 0 ) jump RFailed;
	gg_savestr = glk_stream_open_file( fref, $02, GG_SAVESTR_ROCK );
	if ( gg_savestr == 0 ) jump RFailed;
	@restore gg_savestr res;
	glk_stream_close( gg_savestr, 0 );
	gg_savestr = 0;
	.RFailed;
	infra_undo_counter = 0;
	return 0;
];

[ Infra_Save_Undo fref res;
	infra_undo_counter++;
	Write_Infra_Undo_Counter_File();
	! Delete old save file
	Infra_Undo_Delete( Infra_Undo_Index() );
	! Create an undo tempfile and put it in undo_array
	undo_array --> Infra_Undo_Index() = glk_fileref_create_temp( fileusage_SavedGame + fileusage_BinaryMode, IU_FILE_ROCK_0 + Infra_Undo_Index() );
	fref = undo_array --> Infra_Undo_Index();
	if ( fref == 0 ) jump SFailed;
	gg_savestr = glk_stream_open_file( fref, $01, GG_SAVESTR_ROCK );
	if ( gg_savestr == 0 ) jump SFailed;
	@save gg_savestr res;
	if ( res == -1 )
	{
		! The player actually just typed "undo". But first, we have to recover all the Glk objects; the values
		! in our global variables are all wrong.
		GGRecoverObjects();
		glk_stream_close( gg_savestr, 0 ); ! stream_close
		gg_savestr = 0;
		! Delete this save file
		Infra_Undo_Delete( Infra_Undo_Index() );
		! Remember to decrement the counter!
		infra_undo_counter--;
		return 2;
	}
	glk_stream_close( gg_savestr, 0 ); ! stream_close
	gg_savestr = 0;
	if ( res == 0 ) return 1;
	.SFailed;
	infra_undo_counter--;
	return 0;
];

[ Infra_Undo_Index;
	return ( infra_undo_counter % INFRA_UNDO_MAX_COUNT );
];

[ Infra_Undo_Delete val fref exists;
	fref = undo_array --> val;
	if ( fref ~= 0 )
	{
		if ( glk_fileref_does_file_exist( fref ) )
		{
			glk_fileref_delete_file( fref );
			exists = 1;
		}
		glk_fileref_destroy( fref );
		undo_array --> val = 0;
	}
	rfalse;
];

! Delete all known external files and destroy all filerefs
[ Infra_Undo_Delete_All ix;
	for ( ix = 0 : ix < INFRA_UNDO_MAX_COUNT : ix++ )
	{
		Infra_Undo_Delete( ix );
	}
	if ( glk_fileref_does_file_exist( infra_undo_counter_fileref ) )
		glk_fileref_delete_file( infra_undo_counter_fileref );
	glk_fileref_destroy( infra_undo_counter_fileref );
	infra_undo_counter = 0;
	rfalse;
];

-) instead of "Undo" in "Glulx.i6t".

Section - Items to slot into HandleGlkEvent and IdentifyGlkObject

[These rules belong to rulebooks defined in Glulx Entry Points.]

A glulx zeroing-reference rule (this is the removing references to uufiles rule):
	zero undo array.

To zero undo array:
	(- Zero_Undo_Array(); -)

Include (-

[ Zero_Undo_Array ix;
	if ( infra_undo_needed == 1 )
	{
		for ( ix = 0 : ix < INFRA_UNDO_MAX_COUNT : ix++ )
		{
			undo_array --> ix = 0;
		}
		infra_undo_counter_fileref = 0;
	}
];

-)


A glulx resetting-filerefs rule (this is the restoring uufiles rule):
	identify glulx rock.

To identify glulx rock:
	(- Restoring_Undo_Array(); -)

Include (-

[ Restoring_Undo_Array str;
	if ( infra_undo_needed == 1 )
	{
		! Finding and restoring all filerefs in undo_array
		if ( ( (+current glulx rock+) >= IU_FILE_ROCK_0 ) && ( (+current glulx rock+) < ( IU_FILE_ROCK_0 + INFRA_UNDO_MAX_COUNT ) ) )
		{
			undo_array --> ( (+current glulx rock+) - IU_FILE_ROCK_0 ) = (+ current glulx rock-ref +);

		}		! Finding and restoring infra_undo_counter_fileref
		else if ( (+current glulx rock+) == IU_COUNTER_ROCK )
		{
			infra_undo_counter_fileref = (+ current glulx rock-ref +);
			str = glk_stream_open_file( infra_undo_counter_fileref, filemode_Read, 0 );
			infra_undo_counter = glk_get_char_stream_uni(str);
			glk_stream_close( str, 0 );
		}
	}
];

-)


Section - Tests

[ Test if the VM is able to perform an undo. This is necessary because Git won't tell us that it can't. ]

The Infra Undo Test rule translates into I6 as "Infra_Undo_Test".
The Infra Undo Test rule is listed last in the startup rules.

The init Infra Undo counter rule translates into I6 as "Init_Infra_Undo_Counter".
The init Infra Undo counter rule is listed last in the startup rules.


[ Rerun the tests if we load a saved game. ]

Section (for use with Interpreter Sniffing by Friends of I7) 

The Infra Undo Test rule is listed in the resniffing rules.

Section (for use without Interpreter Sniffing by Friends of I7) 

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
		!  RESTORE_THE_GAME_RM('B'); the Z-Code Inform library does this correctly
		! now. But first, we have to recover all the Glk objects; the values
		! in our global variables are all wrong.
		Infra_Undo_Test();
		GGRecoverObjects();
		glk_stream_close(gg_savestr, 0); ! stream_close
		gg_savestr = 0;
		RESTORE_THE_GAME_RM('B'); new_line;
		rtrue;
	}
	glk_stream_close(gg_savestr, 0); ! stream_close
	gg_savestr = 0;
	if (res == 0) { SAVE_THE_GAME_RM('B'); new_line; rtrue; }
	.SFailed;
	SAVE_THE_GAME_RM('A'); new_line;
];

-) instead of "Save The Game Rule" in "Glulx.i6t".



Section - Cleaning up

[ Clean up after ourselves when the player quits or restarts - delete all the external files ]

Include (-

[ QUIT_THE_GAME_R;
	if ( actor ~= player ) rfalse;
	QUIT_THE_GAME_RM('A');
	if ( YesOrNo()~=0 )
	{
		if ( infra_undo_needed == 1 ) Infra_Undo_Delete_All();
		quit;
	}
];

-) instead of "Quit The Game Rule" in "Glulx.i6t".

Include (-

[ RESTART_THE_GAME_R;
	if (actor ~= player) rfalse;
	RESTART_THE_GAME_RM('A');
	if ( YesOrNo() ~= 0 )
	{
		if ( infra_undo_needed == 1 ) Infra_Undo_Delete_All();
		@restart;
		RESTART_THE_GAME_RM('B'); new_line;
	}
];

-) instead of "Restart The Game Rule" in "Glulx.i6t".



[ Compatibility with Undo Output Control. If it's not included, add the variable we refer to. If it is, don't let it replace our Undo code. ]

Chapter (for use without Undo Output Control by Erik Temple) unindexed

Save undo state is a truth state that varies. Save undo state is usually true.

Chapter (for use with Undo Output Control by Erik Temple)

Section - Undo save control (in place of Section - Undo save control in Undo Output Control by Erik Temple)



Infra Undo ends here.

---- DOCUMENTATION ----

This is Ultra Undo by Dannii Willis modified to use temporary files rather than standard external files. The reason for this is to avoid cluttering up the game directory with lots of undo files.

A problem with this approach is that on interpreters that automatically save the game state on exit, the undo files might all be gone (along with all other temporary files) when the game state is restored at a later point, particularly after a system restart. We should at least add a proper error message for these situations.

Some interpreters, like Lectrote, will hide away all external files in a special directory. Others, like the browser-based Quixe, will write temporary files, standard save files and other external files all to the same directory. On those, this extension will not do much good.

There is definitely more of Danni Willis's code than mine in here. It was written for Counterfeit Monkey, but is not used there at present.


ORIGINAL DOCUMENTATION FOR ULTRA UNDO

Some interpreters have limitations which mean that for very large story files the Undo function stops working. So far the only known example of this is Emily Short's Counterfeit Monkey, for which this extension was written. Infra Undo will keep Undo working when the interpreter cannot, by using external files. You do not need to do anything other than include the extension - it will take care of everything for you, including cleaning up after itself (i.e., deleting those files when the player quits or restarts.)

There is a use option "maximum file based undo count" which controls how many how many turns can be undone using external files. By default that number is 5.

The use option "file based undo" will switch on file based undo permanently, bypassing the standard memory based undo entirely. This can be used to lower the memory footprint of a game, and is also useful for testing.

This extension is compatible with Conditional Undo by Jesse McGrew and Undo Output Control by Erik Temple.

The latest version of this extension can be found at <https://github.com/i7/extensions>. This extension is released under the Creative Commons Attribution licence. Bug reports, feature requests or questions should be made at <https://github.com/i7/extensions/issues>.
