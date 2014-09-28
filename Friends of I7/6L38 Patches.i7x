Version 1/140928 of 6L38 Patches by Friends of I7 begins here.

"Patches to work around bugs in version 6L38 of Inform 7 for which an extension-based workaround is known to exist."

"Including workarounds by Dannii Willis"

Use authorial modesty.



Volume 0001429 - FileIO and the output stream

[ The FileIO functions do not return the output stream to what it was before. This breaks both writing to memory and other windows. ]

Include (-

[ FileIO_Close extf  struc;
	if ((extf < 1) || (extf > NO_EXTERNAL_FILES))
		return FileIO_Error(extf, "tried to open a non-file");
	struc = TableOfExternalFiles-->extf;
	if (struc-->AUXF_STATUS ~=
		AUXF_STATUS_IS_OPEN_FOR_READ or
		AUXF_STATUS_IS_OPEN_FOR_WRITE or
		AUXF_STATUS_IS_OPEN_FOR_APPEND)
		return FileIO_Error(extf, "tried to close a file which is not open");
	if ((struc-->AUXF_BINARY == false) &&
		(struc-->AUXF_STATUS ==
		AUXF_STATUS_IS_OPEN_FOR_WRITE or
		AUXF_STATUS_IS_OPEN_FOR_APPEND)) {
		! 6L38 Patch for 0001429
		!glk_set_window(gg_mainwin);
	}
	if (struc-->AUXF_STATUS ==
		AUXF_STATUS_IS_OPEN_FOR_WRITE or
		AUXF_STATUS_IS_OPEN_FOR_APPEND) {
		glk_stream_set_position(struc-->AUXF_STREAM, 0, 0); ! seek start
		glk_put_char_stream(struc-->AUXF_STREAM, '*'); ! mark as complete
	}
	glk_stream_close(struc-->AUXF_STREAM, 0);
	struc-->AUXF_STATUS = AUXF_STATUS_IS_CLOSED;
];

-) instead of "Close File" in "FileIO.i6t".

Include (-

[ FileIO_PutContents extf text append_flag  struc str ch oldstream;
	if ((extf < 1) || (extf > NO_EXTERNAL_FILES))
		return FileIO_Error(extf, "tried to access a non-file");
	struc = TableOfExternalFiles-->extf;
	if (struc-->AUXF_BINARY)
		return FileIO_Error(extf, "writing text will not work with binary files");
	! 6L38 Patch for 0001429
	oldstream = glk_stream_get_current();
	str = FileIO_Open(extf, true, append_flag);
	if (str == 0) rfalse;
	@push say__p; @push say__pc;
	ClearParagraphing(19);
	TEXT_TY_Say(text);
	FileIO_Close(extf);
	if ( oldstream ) glk_stream_set_current( oldstream );
	@pull say__pc; @pull say__p;
	rfalse;
];

-) instead of "Print Text" in "FileIO.i6t".

Include (-

[ FileIO_PutTable extf tab rv  struc oldstream;
	if ((extf < 1) || (extf > NO_EXTERNAL_FILES))
		return FileIO_Error(extf, "tried to write table to a non-file");
	struc = TableOfExternalFiles-->extf;
	if (struc-->AUXF_BINARY)
		return FileIO_Error(extf, "writing a table will not work with binary files");
	! 6L38 Patch for 0001429
	oldstream = glk_stream_get_current();
	if (FileIO_Open(extf, true) == 0) rfalse;
	rv = TablePrint(tab);
	FileIO_Close(extf);
	if ( oldstream ) glk_stream_set_current( oldstream );
	if (rv) return RunTimeProblem(RTP_TABLE_CANTSAVE, tab);
	rtrue;
];

[ FileIO_GetTable extf tab  struc;
	if ((extf < 1) || (extf > NO_EXTERNAL_FILES))
		return FileIO_Error(extf, "tried to read table from a non-file");
	struc = TableOfExternalFiles-->extf;
	if (struc-->AUXF_BINARY)
		return FileIO_Error(extf, "reading a table will not work with binary files");
	if (FileIO_Open(extf, false) == 0) rfalse;
	TableRead(tab, extf);
	FileIO_Close(extf);
	rtrue;
];

-) instead of "Serialising Tables" in "FileIO.i6t".



6L38 Patches ends here.