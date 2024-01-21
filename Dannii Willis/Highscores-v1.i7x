Version 1.2 of Highscores (for Glulx only) by Dannii Willis begins here.

"Record and review highscores to an external file"



Section - Internals - unindexed

Include (-
Array Highscores_time_struct --> 3;
Array Highscores_date_struct -->8;
Global Highscores_current_time_high;
Global Highscores_current_time_low;

[ Highscores_get_current_time;
	@copy Highscores_time_struct sp;
	@glk 352 1 0;
	Highscores_current_time_high = Highscores_time_struct-->0;
	Highscores_current_time_low = Highscores_time_struct-->1;
];
-).

To decide which number is the header checksum: (- (HDR_CHECKSUM-->0) -).
To get the current time: (- Highscores_get_current_time(); -).
The current time high word is a number variable.
The current time high word variable translates into I6 as "Highscores_current_time_high".
The current time low word is a number variable.
The current time low word variable translates into I6 as "Highscores_current_time_low".

To decide which list of number is a new highscore of (score - a number):
	let new highscore be a list of numbers;
	get the current time;
	add the current time high word to new highscore;
	add the current time low word to new highscore;
	add the header checksum to new highscore;
	add score to new highscore;
	decide on new highscore;

Highscore file stream is a number variable.

Include (-
[ Highscores_open_file extf struc fref;
	(+ highscore file stream +) = 0;
	if ((extf < 1) || (extf > NO_EXTERNAL_FILES))
	{
		return FileIO_Error(extf, "tried to access a non-file");
	}
	struc = TableOfExternalFiles-->extf;
	fref = glk_fileref_create_by_name(fileusage_Data + fileusage_BinaryMode, Glulx_ChangeAnyToCString(struc-->AUXF_FILENAME), 0);
	if (fref == 0)
	{
		jump RFailed;
	}
	(+ highscore file stream +)= glk_stream_open_file_uni(fref, filemode_ReadWrite, 0);
	glk_fileref_destroy(fref);
	rtrue;
	.RFailed;
	(+ highscore file stream +) = 0;
];
-).

To open highscore file (ext - external file): (- Highscores_open_file({ext}); -).

To decide which number is the next word in the highscore file: (- glk_get_char_stream_uni((+ highscore file stream +)) -).

To decide which list of number is the next highscore from the highscore file:
	let timestamp high be the next word in the highscore file;
	if timestamp high is -1:
		decide on {};
	let new highscore be a list of numbers;
	add timestamp high to new highscore;
	add the next word in the highscore file to new highscore;
	add the next word in the highscore file to new highscore;
	add the next word in the highscore file to new highscore;
	decide on new highscore;

To decide whether highscore (A - a list of numbers) is equal to (B - a list of numbers):
	if entry 1 of A is entry 1 of B and entry 2 of A is entry 2 of B and entry 3 of A is entry 3 of B and entry 4 of A is entry 4 of B:
		yes;
	no;

To say date of (highscore - a list of numbers):
	do nothing;

To write (A - a number) to the highscore file: (- glk_put_char_stream_uni((+ highscore file stream +), {A}); -).

To record highscore of (highscore - a list of numbers):
	write entry 1 in highscore to the highscore file;
	write entry 2 in highscore to the highscore file;
	write entry 3 in highscore to the highscore file;
	write entry 4 in highscore to the highscore file;

To close the highscore stream: (- glk_stream_close((+ highscore file stream +), NULL); -).

Include (-
Global Highscore_date_year;
Global Highscore_date_month;
Global Highscore_date_day;

[ Highscore_convert_timestamps;
	Highscores_time_struct-->0 = Highscores_current_time_high;
	Highscores_time_struct-->1 = Highscores_current_time_low;
	glk_time_to_date_local(Highscores_time_struct, Highscores_date_struct);
	Highscore_date_year = Highscores_date_struct-->0;
	Highscore_date_month = Highscores_date_struct-->1;
	Highscore_date_day = Highscores_date_struct-->2;
];
-).

The highscore date year is a number variable.
The highscore date year variable translates into I6 as "Highscore_date_year".
The highscore date month is a number variable.
The highscore date month variable translates into I6 as "Highscore_date_month".
The highscore date day is a number variable.
The highscore date day variable translates into I6 as "Highscore_date_day".

To convert highscore timestamps: (- Highscore_convert_timestamps(); -).	

To convert the timestamp of (highscore - a list of numbers):
	now the current time high word is entry 1 of highscore;
	now the current time low word is entry 2 of highscore;
	convert highscore timestamps;

To say highscore month of (M - a number):
	if M is:
		-- 1: say "January";
		-- 2: say "February";
		-- 3: say "March";
		-- 4: say "April";
		-- 5: say "May";
		-- 6: say "June";
		-- 7: say "July";
		-- 8: say "August";
		-- 9: say "September";
		-- 10: say "October";
		-- 11: say "November";
		-- 12: say "December";

To say date of (highscore - a list of numbers):
	convert the timestamp of highscore;
	say "[highscore date day] [highscore month of highscore date month], [highscore date year]";

Include (-
[ Highscore_print_checksum checksum i temp;
	for ( i = 28 : i >= 0 : i = i - 4 )
	{
		@ushiftr checksum i temp;
		temp = temp & $0F;
		if ( temp > 9 )
		{
			print (char) ( temp + 55 );
		}
		else
		{
			print temp;
		}
	}
];
-).

To say checksum of (checksum - a numbers): (- Highscore_print_checksum({checksum}); -);

To say checksum of (highscore - a list of numbers):
	say checksum of entry 3 of highscore;



Section - Highscores

To say the game checksum: (- Highscore_print_checksum(HDR_CHECKSUM-->0); -).

To record score of (score - a number) and review highscores from (ext - external file):
	let new highscore be a new highscore of score;
	let this version highscore be new highscore;
	let all versions highscore be new highscore;
	open highscore file ext;
	while 1 is 1:
		let comparison highscore be the next highscore from the highscore file;
		if the number of entries in comparison highscore is 0:
			break;
		if entry 4 of comparison highscore is greater than entry 4 of this version highscore and entry 3 of comparison highscore is the header checksum:
			now this version highscore is comparison highscore;
		if entry 4 of comparison highscore is greater than entry 4 of all versions highscore:
			now all versions highscore is comparison highscore;
	if highscore all versions highscore is equal to new highscore:
		say that this highscore is the best of all time;
	otherwise if highscore this version highscore is equal to new highscore:
		say that this highscore is best for this version with all time high of all versions highscore;
	otherwise:
		say highscores of this version highscore and all versions highscore;
	record highscore of new highscore;
	close the highscore stream;

To say that this highscore is the best of all time:
	say "This is your best highscore of all time.";

To say that this highscore is best for this version with all time high of (highscore - a list of numbers):
	say "This is your best highscore for this version; your highscore for all versions was [entry 4 in highscore] on [date of highscore] for version [checksum of highscore].";

To say highscores of (this version highscore - a list of numbers) and (all versions highscore - a list of numbers):
	say "Your highscore for this version was [entry 4 in this version highscore] on [date of this version highscore]; your highscore for all versions was [entry 4 in all versions highscore] on [date of all versions highscore] for version [checksum of all versions highscore].";
	


Highscores ends here.



---- DOCUMENTATION ----

This extension lets your record highscores to an external file. There is one basic phrase:

	record score of (score - a number) and review highscores from (ext - external file)

Depending on whether the score is a new highscore or not, there are three say phrases for reporting back the result. You can overwrite these in your game as you wish.

The "say the game checksum" phrase will also print the game's checksum, which you could display after the game's banner or anywhere else.

This extension is released under the Creative Commons Attribution licence. Bug reports, feature requests or questions should be made at <https://github.com/i7/extensions/issues>.



Example: * Highscores Example

	*: "Highscores Example"
	
	The Records Room is a room.

	Include Highscores by Dannii Willis.

	After printing the banner text:
		say "Checksum [the game checksum][line break]";

	The File of Highscores is called "testscores".

	Recording a score is an action applying to one number.
	Understand "record [a number]" as recording a score.

	Carry out recording a score:
		record score of the number understood and review highscores from The File of Highscores;
