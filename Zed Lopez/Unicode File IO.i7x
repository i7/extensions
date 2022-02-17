Version 1 of Unicode File IO (for Glulx only) by Zed Lopez begins here.

"Quick and dirty proof of concept of unicode file IO"

To read unicode (filename - external file) into (T - table name):
(- FileIO_GetTableUni({filename}, {T}); -).

To write unicode (filename - external file) from (T - table name):
(- FileIO_PutTableUni({filename}, {T}); -).

To decide if unicode (filename - external file) exists:
(- (FileIO_Exists({filename}, false)) -).

To decide if ready to read unicode (filename - external file):
(- (FileIO_ReadyUni({filename}, false)) -).
    
To mark unicode (filename - external file) as ready to read:
(- FileIO_MarkReadyUni({filename}, true); -).

To mark unicode (filename - external file) as not ready to read:
(- FileIO_MarkReadyUni({filename}, false); -).

To write (T - text) to unicode (FN - external file):
(- FileIO_PutContentsUni({FN}, {T}, false); -).

To append (T - text) to unicode (FN - external file):
(- FileIO_PutContentsUni({FN}, {T}, true); -).

To say text of unicode (FN - external file):
(- FileIO_PrintContentsUni({FN}); say__p = 1; -).


Include (-
[ FileIO_PutTableUni extf tab rv  struc oldstream;
	if ((extf < 1) || (extf > NO_EXTERNAL_FILES))
		return FileIO_Error(extf, "tried to write table to a non-file");
	struc = TableOfExternalFiles-->extf;
	if (struc-->AUXF_BINARY)
		return FileIO_Error(extf, "writing a table will not work with binary files");
	oldstream = glk_stream_get_current();
	if (FileIO_OpenUni(extf, true) == 0) rfalse;
	rv = TablePrint(tab);
	FileIO_CloseUni(extf);
	if (oldstream) glk_stream_set_current(oldstream);
	if (rv) return RunTimeProblem(RTP_TABLE_CANTSAVE, tab);
	rtrue;
];

[ FileIO_GetTableUni extf tab  struc;
	if ((extf < 1) || (extf > NO_EXTERNAL_FILES))
		return FileIO_Error(extf, "tried to read table from a non-file");
	struc = TableOfExternalFiles-->extf;
	if (struc-->AUXF_BINARY)
		return FileIO_Error(extf, "reading a table will not work with binary files");
	if (FileIO_OpenUni(extf, false) == 0) rfalse;
	TableRead(tab, extf);
	FileIO_CloseUni(extf);
	rtrue;
];


[ FileIO_PutContentsUni extf text append_flag  struc str ch oldstream;
	if ((extf < 1) || (extf > NO_EXTERNAL_FILES))
		return FileIO_Error(extf, "tried to access a non-file");
	struc = TableOfExternalFiles-->extf;
	if (struc-->AUXF_BINARY)
		return FileIO_Error(extf, "writing text will not work with binary files");
	oldstream = glk_stream_get_current();
	str = FileIO_OpenUni(extf, true, append_flag);
	if (str == 0) rfalse;
	@push say__p; @push say__pc;
	ClearParagraphing(19);
	TEXT_TY_Say(text);
	FileIO_CloseUni(extf);
	if (oldstream) glk_stream_set_current(oldstream);
	@pull say__pc; @pull say__p;
	rfalse;
];


[ FileIO_ReadyUni extf  struc fref usage str ch;
if ((extf < 1) || (extf > NO_EXTERNAL_FILES)) rfalse;
	struc = TableOfExternalFiles-->extf;
	if ((struc == 0) || (struc-->AUXF_MAGIC ~= AUXF_MAGIC_VALUE)) rfalse;
	if (struc-->AUXF_BINARY) usage = fileusage_BinaryMode;
	else usage = fileusage_TextMode;
	fref = glk_fileref_create_by_name(fileusage_Data + usage,
		Glulx_ChangeAnyToCString(struc-->AUXF_FILENAME), 0);
	if (glk_fileref_does_file_exist(fref) == false) {
		glk_fileref_destroy(fref);
		rfalse;
	}
	str = glk_stream_open_file_uni(fref, filemode_Read, 0);
	ch = glk_get_char_stream_uni(str);
	glk_stream_close(str, 0);
	glk_fileref_destroy(fref);
	if (ch ~= '*') rfalse;
	rtrue;
];

[ FileIO_MarkReadyUni extf readiness  struc fref str ch usage;
	if ((extf < 1) || (extf > NO_EXTERNAL_FILES))
		return FileIO_Error(extf, "tried to open a non-file");
	struc = TableOfExternalFiles-->extf;
	if ((struc == 0) || (struc-->AUXF_MAGIC ~= AUXF_MAGIC_VALUE)) rfalse;
	if (struc-->AUXF_BINARY) usage = fileusage_BinaryMode;
	else usage = fileusage_TextMode;
	fref = glk_fileref_create_by_name(fileusage_Data + usage,
		Glulx_ChangeAnyToCString(struc-->AUXF_FILENAME), 0);
	if (glk_fileref_does_file_exist(fref) == false) {
		glk_fileref_destroy(fref);
		return FileIO_Error(extf, "only existing files can be marked");
	}
	if (struc-->AUXF_STATUS ~= AUXF_STATUS_IS_CLOSED) {
		glk_fileref_destroy(fref);
		return FileIO_Error(extf, "only closed files can be marked");
	}
	str = glk_stream_open_file_uni(fref, filemode_ReadWrite, 0);
	glk_stream_set_position(str, 0, 0); ! seek start
	if (readiness) ch = '*'; else ch = '-';
	glk_put_char_stream_uni(str, ch); ! mark as complete
	glk_stream_close(str, 0);
	glk_fileref_destroy(fref);
];

[ FileIO_OpenUni extf write_flag append_flag
	struc fref str mode ix ch not_this_ifid owner force_header usage;
	if ((extf < 1) || (extf > NO_EXTERNAL_FILES))
		return FileIO_Error(extf, "tried to open a non-file");
	struc = TableOfExternalFiles-->extf;
	if ((struc == 0) || (struc-->AUXF_MAGIC ~= AUXF_MAGIC_VALUE)) rfalse;
	if (struc-->AUXF_STATUS ~= AUXF_STATUS_IS_CLOSED)
		return FileIO_Error(extf, "tried to open a file already open");
	if (struc-->AUXF_BINARY) usage = fileusage_BinaryMode;
	else usage = fileusage_TextMode;
	fref = glk_fileref_create_by_name(fileusage_Data + usage,
		Glulx_ChangeAnyToCString(struc-->AUXF_FILENAME), 0);
	if (write_flag) {
		if (append_flag) {
			mode = filemode_WriteAppend;
			if (glk_fileref_does_file_exist(fref) == false)
				force_header = true;
		}
		else mode = filemode_Write;
	} else {
		mode = filemode_Read;
		if (glk_fileref_does_file_exist(fref) == false) {
			glk_fileref_destroy(fref);
			return FileIO_Error(extf, "tried to open a file which does not exist");
		}
	}
	str = glk_stream_open_file_uni(fref, mode, 0);
	glk_fileref_destroy(fref);
	if (str == 0) return FileIO_Error(extf, "tried to open a file but failed");
	struc-->AUXF_STREAM = str;
	if (write_flag) {
		if (append_flag)
			struc-->AUXF_STATUS = AUXF_STATUS_IS_OPEN_FOR_APPEND;
		else
			struc-->AUXF_STATUS = AUXF_STATUS_IS_OPEN_FOR_WRITE;
		glk_stream_set_current(str);
		if ((append_flag == FALSE) || (force_header)) {
			print "- ";
			for (ix=6: ix <= UUID_ARRAY->0: ix++) print (char) UUID_ARRAY->ix;
			print " ", (string) struc-->AUXF_FILENAME, "^";
		}
	} else {
		struc-->AUXF_STATUS = AUXF_STATUS_IS_OPEN_FOR_READ;
		ch = FileIO_GetC(extf);
		if (ch ~= '-' or '*') { jump BadFile; }
		if (ch == '-')
			return FileIO_Error(extf, "tried to open a file which was incomplete");
		ch = FileIO_GetC(extf);
		if (ch ~= ' ') { jump BadFile; }
		ch = FileIO_GetC(extf);
		if (ch ~= '/') { jump BadFile; }
		ch = FileIO_GetC(extf);
		if (ch ~= '/') { jump BadFile; }
		owner = struc-->AUXF_IFID_OF_OWNER;
		ix = 3;
		if (owner == UUID_ARRAY) ix = 8;
		if (owner ~= NULL) {
			for (: ix <= owner->0: ix++) {
				ch = FileIO_GetC(extf);
				if (ch == -1) { jump BadFile; }
				if (ch ~= owner->ix) not_this_ifid = true;
				if (ch == ' ') break;
			}
			if (not_this_ifid == false) {
				ch = FileIO_GetC(extf);
				if (ch ~= ' ') { jump BadFile; }
			}
		}
		while (ch ~= -1) {
			ch = FileIO_GetC(extf);
			if (ch == 10 or 13) break;
		}
		if (not_this_ifid) {
			struc-->AUXF_STATUS = AUXF_STATUS_IS_CLOSED;
			glk_stream_close(str, 0);
			return FileIO_Error(extf,
				"tried to open a file owned by another project");
		}
	}
	return struc-->AUXF_STREAM;
	.BadFile;
	struc-->AUXF_STATUS = AUXF_STATUS_IS_CLOSED;
	glk_stream_close(str, 0);
	return FileIO_Error(extf, "tried to open a file which seems to be malformed");
];

[ FileIO_CloseUni extf  struc;
	if ((extf < 1) || (extf > NO_EXTERNAL_FILES))
		return FileIO_Error(extf, "tried to open a non-file");
	struc = TableOfExternalFiles-->extf;
	if (struc-->AUXF_STATUS ~=
		AUXF_STATUS_IS_OPEN_FOR_READ or
		AUXF_STATUS_IS_OPEN_FOR_WRITE or
		AUXF_STATUS_IS_OPEN_FOR_APPEND)
		return FileIO_Error(extf, "tried to close a file which is not open");
	if (struc-->AUXF_STATUS ==
		AUXF_STATUS_IS_OPEN_FOR_WRITE or
		AUXF_STATUS_IS_OPEN_FOR_APPEND) {
		glk_stream_set_position(struc-->AUXF_STREAM, 0, 0); ! seek start
		glk_put_char_stream_uni(struc-->AUXF_STREAM, '*'); ! mark as complete
	}
	glk_stream_close(struc-->AUXF_STREAM, 0);
	struc-->AUXF_STATUS = AUXF_STATUS_IS_CLOSED;
];

[ FileIO_GetCUni extf  struc;
	if ((extf < 1) || (extf > NO_EXTERNAL_FILES)) return -1;
	struc = TableOfExternalFiles-->extf;
	if (struc-->AUXF_STATUS ~= AUXF_STATUS_IS_OPEN_FOR_READ) return -1;
	return glk_get_char_stream_uni(struc-->AUXF_STREAM);
];

[ FileIO_PutCUni extf char  struc;
	if ((extf < 1) || (extf > NO_EXTERNAL_FILES)) return -1;
		return FileIO_Error(extf, "tried to write to a non-file");
	struc = TableOfExternalFiles-->extf;
	if (struc-->AUXF_STATUS ~=
		AUXF_STATUS_IS_OPEN_FOR_WRITE or
		AUXF_STATUS_IS_OPEN_FOR_APPEND)
		return FileIO_Error(extf,
			"tried to write to a file which is not open for writing");
	return glk_put_char_stream_uni(struc-->AUXF_STREAM, char);
];

[ FileIO_PrintLineUni extf ch  struc;
	if ((extf < 1) || (extf > NO_EXTERNAL_FILES))
		return FileIO_Error(extf, "tried to write to a non-file");
	struc = TableOfExternalFiles-->extf;
	for (::) {
		ch = FileIO_GetCUni(extf);
		if (ch == -1) rfalse;
		if (ch == 10 or 13) { print "^"; rtrue; }
#iftrue (WORDSIZE==4);
@streamunichar ch;
#ifnot;
		print (char) ch;
#endif;
	}
];


[ FileIO_PrintContentsUni extf tab  struc;
	if ((extf < 1) || (extf > NO_EXTERNAL_FILES))
		return FileIO_Error(extf, "tried to access a non-file");
	struc = TableOfExternalFiles-->extf;
	if (struc-->AUXF_BINARY)
		return FileIO_Error(extf, "printing text will not work with binary files");
	if (FileIO_OpenUni(extf, false) == 0) rfalse;
	while (FileIO_PrintLineUni(extf)) ;
	FileIO_CloseUni(extf);
	rtrue;
];


-)



Unicode File IO ends here.

---- Documentation ----

unicode files are not a separate type; they're just external files that you're obliged to access
with the alternate phrases defined within.
