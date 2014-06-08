Version 2/140602 of Conversation Builder (for glulx only) by Chris Conley begins here. 

"An interactive question-and-answer system for building conversations."

"an expansion of the original extension by Emily Short to use indexed text, now 6L02-compatible"

[TODO: get filter to work so that it's easy to add automatic understanding features to quips as we design them.]

Book I - Settings

Include Threaded Conversation by Chris Conley.

Use suppressed subject list translates as (- Constant NO_SUBJECT_LIST; -). 

Use conversation building translates as (- Constant BUILDING_CONVERSATION; -). Use conversation building.

Use MAX_STATIC_DATA of 200000.

Book II - I6 Inclusions

Include (-

Default STRING_BUFFER_SIZE 450;
Default STRING_TEMP_BUFFER_SIZE 450;

Array string_buffer -> STRING_BUFFER_SIZE;
Array string_temp_buffer -> (STRING_TEMP_BUFFER_SIZE+WORDSIZE);

Constant LARGE_BUFFER_LENGTH = 3000;

Array content_buffer -> STRING_BUFFER_SIZE;

[ CreateFileCalled nym  fref str;
	fref = glk_fileref_create_by_name(fileusage_Data+fileusage_BinaryMode, Glulx_ChangeAnyToCString(nym), 0);
];
 
[ PurgeFileCalled file_name fref str maxlen i mode;
	fref = glk_fileref_create_by_name(fileusage_Data+fileusage_BinaryMode, Glulx_ChangeAnyToCString(file_name), 0);
	mode = filemode_Write;
	str = glk_stream_open_file(fref, mode, 0); 
	glk_stream_set_current(str);
	maxlen = STRING_BUFFER_SIZE;
	for  (i=0:i<string_temp_buffer-->0 && i<maxlen:i++ ) { 
		print " ";
	}
	glk_set_window(gg_mainwin);
	glk_stream_close(str, 0);
]; 

[ WriteArrayToFile file_name array_name append_flag  fref length str i maxlen mode;
	fref = glk_fileref_create_by_name(fileusage_Data+fileusage_BinaryMode, Glulx_ChangeAnyToCString(file_name), 0);
	if (append_flag) mode = filemode_WriteAppend; else mode = filemode_Write;
	str = glk_stream_open_file(fref, mode, 0); 
	glk_stream_set_current(str);
	maxlen = STRING_BUFFER_SIZE;
	for  (i=0:i<array_name-->0 && i<maxlen:i++ ) { 
		print (char) array_name->(i+WORDSIZE);
	}
	glk_set_window(gg_mainwin);
	glk_stream_close(str, 0);
];

[ WriteTextToFile file_name new_str append_flag  fref length str i maxlen mode;
	fref = glk_fileref_create_by_name(fileusage_Data+fileusage_BinaryMode, Glulx_ChangeAnyToCString(file_name), 0);
	if (append_flag) mode = filemode_WriteAppend; else mode = filemode_Write;
	str = glk_stream_open_file(fref, mode, 0); 
	glk_stream_set_current(str);
	TEXT_TY_Say(new_str);
	glk_set_window(gg_mainwin);
	glk_stream_close(str, 0);
];

[ OpenFile file_name new_str append_flag  fref length str i maxlen mode;
	fref = glk_fileref_create_by_name(fileusage_Data+fileusage_BinaryMode, Glulx_ChangeAnyToCString(file_name), 0);
	if (append_flag) mode = filemode_WriteAppend; else mode = filemode_Write;
	str = glk_stream_open_file(fref, mode, 0); 
	glk_stream_set_current(str); 
	return str;
];

[ Closefile file_name new_str append_flag  fref length str i maxlen mode;
!	fref = glk_fileref_create_by_name(fileusage_Data+fileusage_BinaryMode, Glulx_ChangeAnyToCString(file_name), 0);
!	str = glk_stream_open_file(fref, mode, 0); 
	glk_set_window(gg_mainwin);
	glk_stream_close((+ currently open reference +), 0);
];

[ WriteQuotemarkToFile file_name new_str append_flag  fref length str i maxlen mode;
	fref = glk_fileref_create_by_name(fileusage_Data+fileusage_BinaryMode, Glulx_ChangeAnyToCString(file_name), 0);
	if (append_flag) mode = filemode_WriteAppend; else mode = filemode_Write;
	str = glk_stream_open_file(fref, mode, 0); 
	glk_stream_set_current(str);
	print (char) 34;
	glk_set_window(gg_mainwin);
	glk_stream_close(str, 0);
];

[ WriteArrayToRockFile rock array_name append_flag  fref length str i maxlen mode;
	str = glk_stream_open_file(rock, mode, 0); 
	glk_stream_set_current(str);
	maxlen = STRING_BUFFER_SIZE;
	for  (i=0:i<string_temp_buffer-->0 && i<maxlen:i++ )
	{ 
		print (char) string_temp_buffer->(i+WORDSIZE);
	}
	glk_set_window(gg_mainwin);
	glk_stream_close(str, 0);
];

[ LineBreakFile file_name array_name append_flag  fref length str i mode;
	fref = glk_fileref_create_by_name(fileusage_Data+fileusage_BinaryMode, Glulx_ChangeAnyToCString(file_name), 0);
!	if (append_flag) mode = filemode_WriteAppend; else mode = filemode_Write;
	mode = filemode_WriteAppend;
	str = glk_stream_open_file(fref, mode, 0); 
	glk_stream_set_current(str); 
	new_line;
	glk_set_window(gg_mainwin);
	glk_stream_close(str, 0);
];

[ AcquireArrayFromFile file_name array_name n  fref length str i maxlen;
	fref = glk_fileref_create_by_name(fileusage_Data+fileusage_BinaryMode, Glulx_ChangeAnyToCString(file_name), 0);

	str = glk_stream_open_file(fref, filemode_Read, 0);
	for (i=0:i<n:i++)
	{
		length = glk_get_line_stream(str, big_content_buffer, LARGE_BUFFER_LENGTH); 
		
		!CharBufferDump(array_name, length);
		! borrows  STRING_BUFFER_SIZE from McGrew's extension
	}
	array_name-->0 = length; 
	maxlen =LARGE_BUFFER_LENGTH;
	for  (i=0:i<array_name-->0 && i<maxlen:i++ )
	{ 
		array_name->(i+WORDSIZE) = big_content_buffer->i;
!		print (i+WORDSIZE), ":"; print (char) content_buffer->i; print (char) string_temp_buffer->(i+WORDSIZE);  new_line;
	}
	return length;
]; 

[ CharBufferDump array_name length maxlen i;  
	maxlen = STRING_BUFFER_SIZE;
	if (length == 0) length = array_name-->0;
	for  (i=0:i<array_name-->0 && i<length:i++ )
	{ 
!		print (i+WORDSIZE), ":";
		if (array_name->(i+WORDSIZE) < 127 && array_name->(i+WORDSIZE) > 31) 
			print (char) array_name->(i+WORDSIZE);
	} 
]; 


[ OpenFileByName file_name array_name n  fref length str i maxlen;

	fref = glk_fileref_create_by_prompt(fileusage_Data+fileusage_BinaryMode, filemode_Read, 0);
	str = glk_stream_open_file(fref, filemode_Read, 0);
	for (i=0:i<n:i++)
	{
		length = glk_get_line_stream(str, content_buffer, STRING_BUFFER_SIZE); 
		
		!CharBufferDump(array_name, length);
		! borrows  STRING_BUFFER_SIZE from McGrew's extension
	}
	string_temp_buffer-->0 = length; 
	maxlen = STRING_BUFFER_SIZE;
	for  (i=0:i<string_temp_buffer-->0 && i<maxlen:i++ )
	{ 
		string_temp_buffer->(i+WORDSIZE) = content_buffer->i;
!		print (i+WORDSIZE), ":"; print (char) content_buffer->i; print (char) string_temp_buffer->(i+WORDSIZE);  new_line;
	}
	return length;
];

[ CreateFileByName  fref;
	fref = glk_fileref_create_by_prompt(fileusage_Data+fileusage_BinaryMode, filemode_Write, 0);
];

[ RockFileByName rock  fref;
	fref = glk_fileref_create_by_prompt(fileusage_Data+fileusage_BinaryMode, filemode_Write, rock);
];

[ OpenFileByRock  rock array_name n  length str i maxlen;

	str = glk_stream_open_file(rock, filemode_Read, 0);
	for (i=0:i<n:i++)
	{
		length = glk_get_line_stream(str, content_buffer, STRING_BUFFER_SIZE); 
		
		!CharBufferDump(array_name, length);
		! borrows  STRING_BUFFER_SIZE from McGrew's extension
	}
	string_temp_buffer-->0 = length; 
	maxlen = STRING_BUFFER_SIZE;
	for  (i=0:i<string_temp_buffer-->0 && i<maxlen:i++ )
	{ 
		string_temp_buffer->(i+WORDSIZE) = content_buffer->i;
!		print (i+WORDSIZE), ":"; print (char) content_buffer->i; print (char) string_temp_buffer->(i+WORDSIZE);  new_line;
	}
	return length;
];

Array big_big_buffer -> LARGE_BUFFER_LENGTH;
Array big_content_buffer -> LARGE_BUFFER_LENGTH;

[ StuffBuffer a_buffer done ix i;
    if (gg_commandstr ~= 0 && gg_command_reading ~= false) {
         ! get_line_stream
         done = glk($0091, gg_commandstr, a_buffer+WORDSIZE, LARGE_BUFFER_LENGTH-WORDSIZE);
         if (done == 0) {
             glk($0044, gg_commandstr, 0); ! stream_close
             gg_commandstr = 0;
             gg_command_reading = false;
             ! L__M(##CommandsRead, 5); would come after prompt
             ! fall through to normal user input.
         }
         else {
             ! Trim the trailing newline
             if ((a_buffer+WORDSIZE)->(done-1) == 10) done = done-1;
             a_buffer-->0 = done;
             glk($0086, 8); ! set input style
             glk($0084, a_buffer+WORDSIZE, done); ! put_buffer
             glk($0086, 0); ! set normal style
             print "^";
             jump KPContinue;
         }
     }
!     print "reading input..."
     done = false;
     glk($00D0, gg_mainwin, a_buffer+WORDSIZE, LARGE_BUFFER_LENGTH-WORDSIZE, 0); ! request_line_event
     while (~~done) {
         glk($00C0, gg_event); ! select
         switch (gg_event-->0) {
           5: ! evtype_Arrange
             DrawStatusLine();
           3: ! evtype_LineInput
             if (gg_event-->1 == gg_mainwin) { 
                 a_buffer-->0 = gg_event-->2;
                 done = true;
             }
         }
         ix = HandleGlkEvent(gg_event, 0, a_buffer);
         if (ix == 2) done = true;
         else if (ix == -1) done = false;
     }
     DisplayLine(a_buffer);
     if (gg_commandstr ~= 0 && gg_command_reading == false) {
         ! put_buffer_stream
         glk($0085, gg_commandstr, a_buffer+WORDSIZE, a_buffer-->0);
         glk($0081, gg_commandstr, 10); ! put_char_stream (newline)
     } 
	.KPContinue; 
	for (i = WORDSIZE : i <= (a_buffer-->0)+(WORDSIZE-1) : i++) { 
		if ((a_buffer->i) == '"') {
			a_buffer->i = 39; ! replace quote mark with apostrophe
		}
	}
	WriteArrayToFile("NewConversation", a_buffer, 1);
];

[ DisplayLine a_buffer  ix ch;
	for (ix=WORDSIZE : ix<a_buffer-->0+WORDSIZE : ix++) {
		ch = a_buffer->ix;
		if (ch == $20)
			print " ";
		else if (ch >= $0 && ch < $100)
			glk($0080, ch); ! put_char
		else
			glk($0128, ch); ! put_char_uni
	}
	new_line;
];

-)

To say temporary buffer:
	(- CharBufferDump(string_temp_buffer); -)

To say big buffer:
	(- CharBufferDump(big_big_buffer); -)
	
To create new/-- file by name:
	(- CreateFileByName(); -)

To create new/-- file: [called (S - some text):]
	(- CreateFileCalled("NewConversation"); -)

To create new/-- file by name as rock (rock - a number):
	(- RockFileByName({rock}); -)
	
To purge file: [called (S - some text):]
	(- PurgeFileCalled("NewConversation"); -)
	
To write temporary buffer over file (N - a number):
	(- WriteArrayToRockFile({N}, string_temp_buffer); -)
	
To write temporary buffer over file: [(S - some text):]
	(- WriteArrayToFile("NewConversation", string_temp_buffer); -)
	
To write temporary buffer after file: [(S - some text):]
	(- WriteArrayToFile("NewConversation", string_temp_buffer, 1); -)

To decide what number is the reference resulting from opening file [(S - some text)] for writing:
	(- OpenFile("NewConversation",0,1) -)

Currently open reference is a number that varies.

To close file [(S - some text)] for writing:
	(- CloseFile("NewConversation"); -)

To write (NS - some text) after file: [(S - some text):]
	(- WriteTextToFile("NewConversation", {NS}, 1); -)

To write quotemark after file: [(S - some text):]
	(- WriteQuotemarkToFile("NewConversation", 0, 1); -)
	
To draw temporary buffer from line (N - a number) of file: [(S - some text):]
	(- AcquireArrayFromFile("NewConversation", string_temp_buffer, {n}); -)
	
To draw big buffer from line (N - a number) of file: [(S - some text):]
	(- AcquireArrayFromFile("NewConversation", big_big_buffer, {n}); -)

To draw temporary buffer from line (N - a number) of named file:
	(- OpenFileByName(0, string_temp_buffer, {n}); -)

To draw temporary buffer from line (N - a number) of file (rock - a number):
	(- OpenFileByRock({rock}, string_temp_buffer, {n}); -)
	
To add a/-- line break to file: [(S - some text):]
	(- LineBreakFile("NewConversation", string_temp_buffer, 0); -)

To stuff buffer: 
	(- StuffBuffer(big_big_buffer); -)

Book III - Quip Building

Part One - The Sample Quip

Sample-quip is a text which varies. 
Nominal-sample-quip is a text that varies.
We need to escape trouble words is a truth state that varies.

The last-designed-quip is a text that varies.
The last-prettified-quip is a text that varies.

The file of New Conversation is called "NewConversation".

When play begins (this is the new conversation creation rule):
	if the file of New Conversation exists:
		do nothing;
	otherwise:
		create new file; [called "NewConversation";]

When play begins (this is the clean conversation creation rule):
	purge file; [called "NewConversation".]
	
Asking about is an action applying to one topic.
Telling about is an action applying to one topic.

Understand "ask [someone] [text]" as asking it about.
Understand "ask [text]" as asking about.

Understand "tell [someone] [text]" as telling it about.
Understand "tell [text]" and "say [text]" as telling about.

Understand "ask about [text] of [talk-eligible person]" as asking it about (with nouns reversed).
Understand "ask [text] of [talk-eligible person]" as asking it about (with nouns reversed).
Understand "tell about [text] to [talk-eligible person]" as telling it about (with nouns reversed).
Understand "tell [text] to [talk-eligible person]" as telling it about (with nouns reversed).

Part Two - Naming Quips

The variable snippet is a snippet that varies.

To store base quip text:
	now we need to escape trouble words is false;
	now the nominal-sample-quip is the variable snippet;
	follow the quip-name-management rules;
	now the sample-quip is the variable snippet.

The quip-name-management rules are a rulebook.

A quip-name-management rule (this is the get rid of dangerous verbs rule):
	repeat through the Table of Quip-Name Conversions:
		while the variable snippet includes the topic entry:
			replace the matched text with the replacement entry;
			now used entry is true;
			now we need to escape trouble words is true.

Table of Quip-Name Conversions
topic	replacement	understanding	used
"have"	"hath"	"have"	false
"has"	"hath"	"has"	false
"wear"	"dons"	"wear"	false
"wears"	"dons"	"wears"	false
"contain"	"incorporates"	"contain"	false
"contains"	"incorporates"	"contains"	false
"support"	"holds up"	"support"	false
"supports"	"holds up"	"supports"	false
"is"	"seems"	"is"	false
"are"	"seem"	"are"	false
"with"	"alongside"	"with"	false
"and"	"plus"	"and"	false
"I am"	"you are"	"I am"	false
"I"	"you"	"I"	false
"knows"	"kens"	"knows"	false
"know"	"ken"	"know"	false
"when"	"whenever"	"when"	false
"while"	"whilst"	"while"	false


First for printing a parser error when the current interlocutor is a person (this is the read all performative quips rule):
	now the variable snippet is the player's command; 
	store base quip text;
	say "That speech act is not implemented. Draft a new one? >" (A);
	if the player consents:
		now the currently open reference is the reference resulting from opening file ["NewConversation"] for writing;
		say "[sample-quip]" (B);
		close file ["NewConversation"] for writing; 
		write " is a performative quip." (C) after file ["NewConversation"];
		if we need to escape trouble words is true, escape troubled quip-names;
		carry out the filling in standard quip activity;
	otherwise:
		say line break;
		make no decision.

To escape troubled quip-names:
	move quip line forward;
	[write "	Understand " after file "NewConversation";
	enquote "[sample-quip]";
	change the currently open reference to the reference resulting from opening file "NewConversation" for writing;
	say " as [sample-quip]. The printed name is ";
	close file "NewConversation" for writing; ]
	write "	The printed name is " after file ["NewConversation"];
	enquote "[nominal-sample-quip]";
	write ". The true-name is " after file ["NewConversation"]; 
	enquote "[sample-quip]";
	write ". " after file ["NewConversation"].

To enquote (N - some text):
	write quotemark after file ["NewConversation"];
	now the currently open reference is the reference resulting from opening file ["NewConversation"] for writing;
	say N;
	close file ["NewConversation"] for writing;
	write quotemark after file ["NewConversation"];

Part Three - Vague Asking/Telling/Answering Rules

Instead of asking someone about (this is the convert asking it about to asking about rule):
	now the current interlocutor is the noun;
	try asking about the topic understood.
	
To need is a verb.
	
Instead of asking about (this is the vague asking rule):
	if the current interlocutor is nothing, say "[We] [need] to talk to someone first." (A) instead;
	now the variable snippet is the topic understood; 
	store base quip text;
	say "That question is not implemented. Draft a new one? >" (B);
	if the player consents:
		now the currently open reference is the reference resulting from opening file ["NewConversation"] for writing;
		say "[sample-quip] is a questioning quip. " (C); 
		close file ["NewConversation"] for writing; 
		if we need to escape trouble words is true, escape troubled quip-names;
		carry out the filling in standard quip activity.

Instead of telling someone about (this is the convert telling it about to telling about rule):
	now the current interlocutor is the noun;
	try telling about the topic understood.

Instead of telling about  (this is the vague telling rule):
	if the current interlocutor is nothing, say "[Text of the vague asking rule response (A)]" (A) instead;
	now the variable snippet is the topic understood; 
	store base quip text;
	say "That remark is not implemented. Draft a new one? >" (B);
	if the player consents:
		now the currently open reference is the reference resulting from opening file ["NewConversation"] for writing;
		say "[sample-quip] is an informative quip. " (C);
		close file ["NewConversation"] for writing; 
		if we need to escape trouble words is true, escape troubled quip-names;
		carry out the filling in standard quip activity.

Instead of answering someone that something (this is the convert answering to telling rule):
	try telling the noun about it.

Part Four - Initializing Quips
	
To initialize new quip:
[	treat the topic understood as quoted text;	]
[	copy the quoted text to the sample-quip;	]
	now the sample-quip is the topic understood;
	write temporary buffer after file ["NewConversation"];

Filling in standard quip is an activity.

Rule for filling in standard quip (this is the basic quip construction rule):
	follow auto-quip-understanding rules;
	follow the quip-building rules.

To end new quip line:
	write "." after file ["NewConversation"];
	move quip line forward;

To move quip line forward:
	increase file line count by 1;  
	add line break to file ["NewConversation"];

To get text for a quoted field:
	write quotemark after file ["NewConversation"];
	stuff buffer;
	write quotemark after file ["NewConversation"];

The auto-quip-understanding rules are a rulebook.

An auto-quip-understanding rule (this is the add understanding individual verbs rule): 
	repeat through the Table of Quip-Name Conversions:
		if used entry is true:
			move quip line forward;
			write "	Understand " (A) after file ["NewConversation"];
			write quotemark after file ["NewConversation"];
			now the currently open reference is the reference resulting from opening file ["NewConversation"] for writing;
			say "[understanding entry]" (B);
			close file ["NewConversation"] for writing;
			write quotemark after file ["NewConversation"];
			now the currently open reference is the reference resulting from opening file ["NewConversation"] for writing;
			say " as [sample-quip]. " (C);
			close file ["NewConversation"] for writing;
		now used entry is false.

Table of Quip-Name Understandings
topic	understanding
"I/me/myself/you/yourself"	"you"
"I/me/myself/you/yourself"	"yourself"
"I/me/myself/you/yourself"	"myself"
"I/me/myself/you/yourself"	"me"
"are"	"am"
"am"	"are"
"himself/herself"	"[current interlocutor]"

An auto-quip-understanding rule (this is the add understanding special names rule): 
	let N be 0;
	repeat through the Table of Quip-Name Understandings:
		if variable snippet includes the topic entry:
			if N is 0:
				move quip line forward;
				write "	Understand " (A) after file ["NewConversation"];
				write quotemark after file ["NewConversation"];
				now the currently open reference is the reference resulting from opening file ["NewConversation"] for writing;
				increment N;
			otherwise:
				say " or " (B);
			say "[understanding entry]";
	if N is positive:
		close file ["NewConversation"] for writing;
		write quotemark after file ["NewConversation"];
		now the currently open reference is the reference resulting from opening file ["NewConversation"] for writing;
		say " as [sample-quip]. " (C);
		close file ["NewConversation"] for writing.


The quip-building rules are a rulebook. 
	The quip-building rulebook has a quip-setting called single character setting.
	The quip-building rulebook has a quip-setting called immediacy setting.
	The quip-building rulebook has a quip-setting called indirection setting.

A quip-setting is a kind of value. The quip-settings are q-set-yes and q-set-no.

The first quip-building rule (this is the establish quip-settings rule):
	now single character setting is q-set-no;
	now immediacy setting is q-set-no;
	now indirection setting is q-set-no;

A quip-building rule (this is the getting a main comment rule):
	say "What would you like the player to say at this point?[paragraph break]" (A);
	write "	The comment is " after file ["NewConversation"];
	get text for a quoted field;
	end new quip line.

A quip-building rule (this is the setting mentions rule):
	move quip line forward;
	say "[line break]Based on what you just wrote, what subjects does this remark refer to? " (A);
	if the suppressed subject list option is active, do nothing;
	otherwise say "[if the number of subjects is 0]There are no conversation subjects yet defined[otherwise]Current conversation subjects include [italic type][list of subjects][roman type][end if][one of], but quips may also refer to objects in the game[or][stopping]. " (B);
	say "[first time](Provide your answer as a list separated by commas. It is not necessary to list any synonyms for any subject or game-object, as they will be parsed automatically.)[only][line break]" (C);
	write "	It mentions " (D) after file ["NewConversation"];
	stuff buffer;
	end new quip line.

A quip-building rule (this is the getting a reply rule):
	say "[line break]And what would you like [the current interlocutor] to say in reply? [paragraph break]" (A); 
	write "	The reply is " (B) after file ["NewConversation"];
	get text for a quoted field;
	end new quip line.

A quip-building rule (this is the making interlocutor specific rule):
	say "[line break]Is this something that the player can say only to [the current interlocutor]? >" (A);
	if the player consents:
		now single character setting is q-set-yes;
		now the currently open reference is the reference resulting from opening file ["NewConversation"] for writing;
		say "	It quip-supplies [the current interlocutor]" (B);
		close file ["NewConversation"] for writing;
		end new quip line.

A quip-building rule (this is the marking repeatable quips rule):
	say "May the player say this more than once[if the single character setting is q-set-no] to the same character[end if]? >" (A);
	if the player consents:
		now the currently open reference is the reference resulting from opening file ["NewConversation"] for writing;
		say "	It is repeatable" (B);
		close file ["NewConversation"] for writing;
		end new quip line.

A quip-building rule (this is the marking restrictive quips rule):
	say "Will the player be restricted to a small set of responses to this? >" (A);
	if the player consents:
		now the currently open reference is the reference resulting from opening file ["NewConversation"] for writing;
		say "	It is restrictive" (B);
		close file ["NewConversation"] for writing;
		end new quip line.

A quip-building rule (this is the making remark follow the last quip rule):
	if the current quip is generic-quip, make no decision;
	say "Does this remark have to follow immediately after [the current quip]? [if the current quip is restrictive](Because the current quip restricts the player to a limited set of answers, you should choose YES if you want the player to be able to use this message as an answer to the foregoing remark.)[end if] >" (A);
	if the player consents:
		now immediacy setting is q-set-yes;
		now the currently open reference is the reference resulting from opening file ["NewConversation"] for writing;
		say "	It directly-follows [the true-name of the current quip]" (B);
		close file ["NewConversation"] for writing;
		end new quip line.

A quip-building rule (this is the making remark distantly follow the last quip rule):
	if the current quip is generic-quip, make no decision;
	if immediacy setting is q-set-yes, make no decision;
	say "Does this remark have to come [italic type]some time[roman type] (but maybe not immediately) after [the current quip]? >" (A);
	if the player consents:
		now the indirection setting is q-set-yes;
		now the currently open reference is the reference resulting from opening file ["NewConversation"] for writing;
		say "	It indirectly-follows [the true-name of the current quip]" (B);
		close file ["NewConversation"] for writing;
		end new quip line;.

A quip-building rule (this is the making remark follow the previously defined quip rule):
	if the last-designed-quip is "", make no decision;
	if immediacy setting is q-set-yes, make no decision; [because it already follows the current quip]
	if indirection setting is q-set-yes, make no decision; [because it already indirectly follows the current quip]
	say "Does this remark have to come immediately after the quip you just added, namely [the last-prettified-quip]? >" (A);
	if the player consents:
		now immediacy setting is q-set-yes;
		now the currently open reference is the reference resulting from opening file ["NewConversation"] for writing;
		say "	It directly-follows [the last-designed-quip]" (B);
		close file ["NewConversation"] for writing;
		end new quip line;.

A quip-building rule (this is the making remark distantly follow the previously defined quip rule):
	if the last-designed-quip is "", make no decision;
	if immediacy setting is q-set-yes, make no decision;
	if indirection setting is q-set-yes, make no decision;
	say "Does this remark have to come [italic type]some time[roman type] (but maybe not immediately) after the quip you just added, namely [the last-prettified-quip]? >" (A);
	if the player consents:
		now the currently open reference is the reference resulting from opening file ["NewConversation"] for writing;
		say "	It indirectly-follows [the last-designed-quip]" (B);
		close file ["NewConversation"] for writing;
		end new quip line.

The last quip-building rule (this is the finalize quip rule):
	increase the file line count by 1;
	now the last-designed-quip is the sample-quip;
	now the last-prettified-quip is the nominal-sample-quip;
	add line break to file ["NewConversation"];
	reject the player's command.

file line count is a number that varies;

Check quitting the game (this is the show source before stopping rule):
	try looking at new source.

Looking at new source is an action out of world. Understand "show source" and "source" as looking at new source.

Carry out looking at new source (this is the source examination rule):
	say "You review your new code: [paragraph break]" (A); 
	repeat with N running from 1 to file line count:
[		say "L[N]: ";]
		draw big buffer from line N of file ["NewConversation"];
		say big buffer;
		say line break.

The character pursues own ideas rule is not listed in any rulebook.
[	This rule, though it provides natural conversation flow, often prevents the player from being able to react to certain quips;	]
[	so when testing/building conversations, we explicitly break after every exchange, to allow the user/player to add information to that stage.	]
	
Conversation Builder ends here.

---- Documentation ----

Conversation Builder interactively drafts source code for use with the Threaded Conversation extension.

Chapter: Getting Started

NOTE to new users: This documentation assumes some familiarity with the workings of the Threaded Conversation extension -- please begin reading there!

Section: Quick Start Instructions

We begin by downloading and installing the Threaded Conversation extension from the Inform website, if we don't already have it installed. Conversation Builder depends on this. (And Conversation Framework by Eric Eve. Threaded Conversation also depends on that extension.)

We must also make sure that the Settings tab is set to compile to Glulx.

We may then begin with as little as a room and a character, such as 

	Include Conversation Builder by Chris Conley.

	The Raven Tower is a room. The King is a man in the Raven Tower.

Once these are defined, we can begin with

	>talk to king

and then a question or comment such as

	>ask king whether he plans for war
	>persuade king to make peace treaty
	>say I represent the Ooambu tribe

CB will then invite us to answer a series of questions to define the new piece of conversation, or "quip".

We can repeat this process as much as we'd like; when we've written all the conversation we want to write on this iteration, we can quit, whereupon CB will print out the generated source.

We now copy the generated source from the game window; paste it into the source window (ideally in a special section of the code devoted to conversation quips and appearing towards the end of the game); make any editing touches we want (such as correcting typos); and re-compile the game. 

If the newly compiled game starts with such feedback as

	peace treaty is a subject.
	Ooambu tribe is a subject.

we should copy these lines into the part of the source where we list subjects of conversation (ideally, these should appear before the quips are defined). This is also a good time to add alternative names to the new subjects, such as
	
	Understand "accord" or "agreement" as peace treaty.

Then re-compile again.

When the new conversation compiles and produces no header warnings, it is safely incorporated into the game, and we can begin this process again.

Chapter: Detailed Overview

Conversation Builder is designed to generate source code for the Threaded Conversation extension. It is possible to write Threaded Conversation code by hand, of course; CB is chiefly intended to automate the more repetitive aspects of writing a sizable conversation; to produce source that is uniformly organized and easy to read (more of a factor when there is a large amount of data); and to avoid certain easily-avoided bugs and flaws by escaping object names that are likely to cause namespace clashes in Inform. 

Section: Making a new quip

If we have Conversation Builder running, the game will detect when the player/author attempts to ask a question or make a remark that is not currently implemented. It also, rather ambitiously, assumes that all input it can't interpret at all -- anything generating a parser error -- is an attempt to use a performative quip, like "apologize to Fred" or "cheer Lily up". 

For simplicity, the CB limits its syntax to three simple commands when generating new quips:

	ASK {a new intended questioning quip's name}
	TELL {a new intended informative quip's name}
	{a new intended performative quip's name}

When this happens, CB will create a new quip, escaping any instances of "with", "is", "are", "have", or "has" that might cause compilation problems in the finished source. Under most circumstances we can ignore this behavior entirely, but for more information see ESCAPING NAMES below.

Section: Adding items mentioned

Next, CB will prompt the player to list things mentioned by this quip. 

As a rule, quips about objects or people in the game should mention those objects or people. This will ensure that the quip parses all of the viable names for those items, without our having to specifically type out all the alternatives. In fact, a good rule of thumb is to have a quip 'mention' something for every noun that appears in the quip -- whether those are in-game things like people, or subjects like "peace" or "freedom". This vastly simplifies the problem of making our conversation parse smoothly and consistently with the rest of the model world.

CB will also provide a list of subjects that are already defined, to jog our memory.

Section: Writing comment and reply properties

Now CB will ask for a comment and reply appropriate to this quip. Because pressing return will indicate the end of a comment or reply, we should use the "[paragraph break]" substitution if we want to introduce additional lines of spacing into the middle of one of these fields. A maximum length of 3000 characters is set for comments and replies, as determined by the LARGE_BUFFER_LENGTH constant.

There is nothing to stop the author/player from using "[one of] ... [or] ... [or] ... [stopping]" and similar text variation effects when defining what the player will say or how the character will respond; similarly, facts can be indicated in brackets as usual, as in "The prince tells you his feet smell funny[funny-foot-smell].". If these are new facts not previously defined, they will fail to compile through when the code is pasted in, but the author can add the facts to his fact table and proceed as normal.

Similarly, new quips from other characters can be queued up using the "[queue {quip name}]" substitution defined in Threaded Conversation.

Comments and replies may safely be written with either single or double quotes; all double-quotes will be converted back to a single quote before being saved in the source.

Section: Conversation threading

CB will next ask the player/author a couple of questions about how the quip relates to the current conversation context. It is assumed that the player/author wants to add new material to the conversation that's currently in progress, so it's a good idea to invoke this ability when the conversation is already at the stage we want to add to.

New conversation may be set to follow whatever quip the game used last (the current quip) OR whichever quip we ourselves just defined. This means that we can define a whole thread of questions and answers in a single editing session, before dumping source and recompiling; but CB is not designed for more complex editing than this in a single session.

Section: output

CB will then write appropriate code out to a file called "NewConversation". 

At the end of play, before quitting, CB will print to screen all the source code it has written over the course of the editing session. This source code also remains stored in the file "NewConversation". In builds of an Inform project, "NewConversation" will be inside the top-level Inform/Projects folder; if we are running the game on an independent interpreter, "NewConversation" will appear in the same directory with the game file. We may also bring up this code mid-play by typing
	
	SHOW SOURCE

To compile this code into the next session, we simply cut and paste it over to the appropriate place in the source window. This tends to work most effectively on a relatively short play-build-play cycle: we play the game for a bit, add five or ten new quips at various points in the conversation, then play again.

Conversation Builder assumes a certain amount of astuteness from the user. It is conceivable that if we have given a question a name that clashes with an existing quip, compilation will fail and we will have to modify the source somewhat; but under many circumstances the results will simply compile and play. It is also up to the user to make sure that, for instance, the subjects mentioned by any given quip correspond to the source code as desired; Inform will create new subjects if a quip mentions something that isn't listed elsewhere in the code, but this also means that typos and misremembered names will generate spurious subjects rather than conforming to existing ones.

Chapter: Advanced Features

Section: Escaping names

As mentioned earlier, CB catches and changes instances of "is", "are", and some common relation verbs in the names of quips, because they almost always cause compilation errors: given a sentence such as

	John is fat is a quip.

Inform will try to understand (John) is (fat is a quip), and have trouble because it doesn't know what "fat is a quip" might be. Other common verbs cause trouble as well.

Where these words occur, they will be replaced according to the Table of Quip-Name Conversions, of which a representative sample is

	Table of Quip-Name Conversions
	topic	replacement	understanding	used 
	"is"	"seems"	"is"	0
	"are"	"seem"	"are"	0
	"with"	"alongside"	"with"	0

(The actual table is some lines longer, drawn from experience with problematic quip names.) If we find that we are very frequently running into compilation problems with other words, we may continue this table with our own replacements.

The escaping is done by the quip-name-management rulebook; currently it contains only one rule, 

	the get rid of dangerous verbs rule

but if we want to, we may add further quip-name-management rules as well. For most purposes, adding to the Table of Quip-Name Conversions will be adequate, but if not, we can write our own free-form code.

Another table, the Table of Quip-Name Understandings, does not alter the name of the quip as we have typed it, but it does add additional understand rules to a quip; this guarantees that, for instance, any instance of "himself" or "herself" will also match the name of the current interlocutor; or that quips containing "you are..." will also recognize "I am...". 

CB then generates Understand... and printed name... instructions so that the quip will be printed and understood exactly as the player/author typed it. A rule called

	the add understanding individual verbs rule

uses the "understanding" column of the table of quip-name conversions to add additional synonyms to the quip.

CB also stores the source name of the quip in the "true-name" property; this allows future use of Conversation Builder to build code that correctly refers back to this quip. 

If we want to mingle code built by CB with code written by hand, we must remember to always define a "true-name" for every hand-written quip whose printed name differs from its source name.

Section: Adding special features to the conversation

Conversation Builder does not attempt to handle very complicated situations: there are many cases for which we will want to write our own custom plausibility and availability rules, for instance. For any of the following tasks, we should consult the documentation for Threaded Conversation:

	(1) restricting some quips to occur only during specific scenes; starting and ending scenes based on quip status
	(2) building other, arbitrarily complex rules regarding which quips may be displayed under which circumstances
	(3) changing the output format so that the game presents the player with a menu rather than conversation choices
	(4) turning off or modifying the printing of cues such as "You could ask about the peace treaty."
	(5) making characters provide atypical replies to a whole set of quips under special circumstances (e.g., having a character who gets angry and responds rudely everything the player says) 

and, in general, if there are things that Conversation Builder does not explain, we should probably turn to the documentation for Threaded Conversation, and to its accompanying examples.

Chapter: Customizing Conversation Builder

Section: Customizing CB for our own use

When constructing quip code, Conversation Builder follows a rulebook called the quip-building rules. If we wish to construct our quips differently, we may add to, replace, or remove rules from this rulebook. The existing quip-building rules can serve as a guide for constructing additions.

We may also stop Conversation Builder from being quite so enthusiastic in interpreting any input as a performative quip by turning off
	
	the read all performative quips rule

Section: Customizing CB for collaborative design projects

Some authors may wish to use Conversation Builder in collaborative design projects, by releasing a game that includes CB and encouraging players to submit files of new conversation, by using CB to involve a dialogue-writer who isn't otherwise involved in code development, or by inviting beta-testers to submit additional lines for the player.

It is likely, in that case, that a somewhat stripped version of the code-building would be desirable: one might, for instance, remove most of the rules from the quip-building rulebook and invite players simply to submit their suggested new questions and the line of dialogue they wanted the player to be able to say, leaving it up to the author to complete this with the character's reply and the more technical features of the quip.

One way to do this would be to add the following bit of code to the source:

	The cut off quips rule is listed before the getting a reply rule in the quip-building rules.

	This is the cut off quips rule:
		follow the finalize quip rule;
		say "[line break]Suggestion noted.";
		rule succeeds.

Similarly, by default, Conversation Builder will give the player a list of already-defined subjects, as a hint about what a new comment can safely 'mention'. We might want to suppress this in a game released to beta-testers or players, or we might simply find that the subject list is getting long and is more of a hindrance than a help. In that case, we may 

	Use suppressed subject list.

to omit the feature.

We might also want to skip having the generated source code appear every time the player quits the game; to do this, we would remove the check quitting rule that currently does this:

	The show source before stopping rule is not listed in any rulebook.

Finally, when working on our own, we usually do not want the NewConversation file to grow longer and longer with each editing session; but if we are collecting feedback from others, we might want them to be able to accumulate a long file with the results of multiple sessions appended to it. To do this, we simply skip purging the NewConversation file when the game starts up, by declaring that

	The clean conversation creation rule is not listed in any rulebook.

Chapter: Changelog

Section: Version 2

	Adapted to Inform 7 build 6L02