Version 2 of Real Date and Time (for Glulx only) by Ron Newcomb begins here.

"Allows the author to get the real-world time and date from the player's computer."


A weekday is a kind of value. The weekdays are Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday.  

A month is a kind of value. The months are January, February, March, April, May, June, July, August, September, October, November, December.

A timezone is a kind of value. [ It's just an alternate way of printing a time as a relative measure, not in words. ]

Represent time locally is a truth state that varies. The represent time locally variable translates into I6 as "UTCvsLocal". [Represent time locally is usually true.]


To decide if the player's time/date is available:			(- (glk($0004, 20, 0) ~= 0) -). [! gestalt_DateTime]

To decide what number	is the player's year:			(- GetNthDateTimeComponent(0) -).
To decide what month	is the player's month:			(- GetNthDateTimeComponent(1) -).
To decide what number	is the player's day:			(- GetNthDateTimeComponent(2) -).
To decide what weekday	is the player's weekday:		(- GetNthDateTimeComponent(3) -).
To decide what time		is the player's time:			(- GetNthDateTimeComponent(4) -). [ and 5 ]
To decide what number	is the player's seconds:		(- GetNthDateTimeComponent(6) -).
To decide what number	is the player's microseconds:	(- GetNthDateTimeComponent(7) -).

To decide what timezone	is the player's timezone:		(- GetPlayersTimezone() -).

To while suspending time begin -- end:     (- for(suspend_glk_get_time = GetNthDateTimeComponent(-1) : suspend_glk_get_time : --suspend_glk_get_time)         -).
To while suspending time, (ph - a phrase): (- for(suspend_glk_get_time = GetNthDateTimeComponent(-1) : suspend_glk_get_time : --suspend_glk_get_time) {ph}; -).

To say (tz - a timezone):
	let T be tz as a time;
	if T is less than zero minutes:
		say "-";
		now T is 0 minutes minus T;
	otherwise:
		say "+";
	let H be the hours part of T;
	let M be the minutes part of T;
	say "[if H is less than ten]0[end if][H][unless M is zero]:[M]".

To decide what time is (t - timezone) as a time: (- {t} -).
To decide what timezone is (t - time) as a timezone: (- {t} -).

Include (-
Array countofseconds --> 3;   ! this holds the number of microseconds elapsed since midnight on January 1, 1970, GMT/UTC
Array datetime --> 8;       ! this holds the above broken down into year, month, day, weekday, hour, minute, second, and microseconds
Global UTCvsLocal = 1;      ! truth state: 1 = local time; 0 = GMT otherwise known as UTC
Global suspend_glk_get_time = 0;  !   0 = not suspended; 1 = suspended

[ GetNthDateTimeComponent n;
   if (glk($0004, 20, 0) == 0) return 0;  !  glk_gestalt_DateTime(20, 0);
   if (~~suspend_glk_get_time) 
   {
	   glk($0160, countofseconds); !  glk_current_time(timeval);
	   if (UTCvsLocal)	glk($0169, countofseconds, datetime); ! glk_time_to_date_local(tv, date);
	   else			glk($0168, countofseconds, datetime); ! glk_time_to_date_utc(tv, date);
   }
   if (n == -1) return 1;    ! used by "while suspending time"
   if (n == 3) return datetime-->3 + 1;
   if (n == 4 or 5) return datetime-->4 * 60 + datetime-->5;
   return datetime-->n;
];

Array countofseconds2 --> 3;	! as above, for timezone calculations.  
Array datetime2 --> 8;		! This is so player can use it inside "while suspending time".  Otherwise, it corrupts the held time.
[ GetPlayersTimezone zonesec zonemin zonehour firstsecondcount;
   if (glk($0004, 20, 0) == 0) return 0;  !  glk_gestalt_DateTime(20, 0);
   glk($0160, countofseconds2); ! glk_current_time()
   glk($0169, countofseconds2, datetime2); ! glk_time_to_date_local()
   firstsecondcount = countofseconds2-->1;
   glk($016C, datetime2, countofseconds2); ! glk_date_to_time_utc()
   zonesec = (countofseconds2-->1 - firstsecondcount);          ! UTC - local 
   zonehour = zonesec / 3600;
   zonesec = zonesec % 3600;
   zonemin = zonesec / 60;
   return (zonehour * 60) + zonemin;   
];
-) after "Definitions.i6t".



Real Date and Time ends here.

---- DOCUMENTATION ----

This extension allows the author to get the date and time of the real world, as opposed to the fictional world we're building.  This of course relies on the player having the date and time set correctly on his computer, cell phone, or tablet, and that the interpreter running the game supports the feature.  We can test the interpreter like this.

	*: When play begins:
		unless the player's time is available, say "This interpreter lacks a necessary feature."

If supported, then these variables become available.

	the player's year - a four-digit number
	the player's month - of kind "month"
	the player's day - a number from 1 to 31
	the player's weekday - of kind "weekday" (Sunday, etc.)
	the player's time - of type time
	the player's seconds - a number from 0 to 59
	the player's microseconds - a number from 0 to 999,999
	the player's timezone - offset from UTC, of kind "timezone"

With which we could, for example, test the player's device for a year preceding the published date of our work.

	*: When play begins when the player's time is available and the story creation year is greater than the player's year, say "I believe your computer's date is set incorrectly.  This work was published in [the story creation year], which is decidedly in the future from where you sit in [the player's year]."

Presumably the individual values for "weekday" and "month" need no introduction, but appear in the index just the same.  The "timezone" type is a "time" that prints in standard UTC format.  For instance, Seattle's timezone is at -8 hours relative to UTC; Boston's is at -5; and many European cities are at +1:  Amsterdam, Madrid, Paris, Rome, Oslo, Stockholm.  Moscow is at +3; Tokyo, +9; Sydney, +10.  Time zone offsets aren't always an exact hour, such as Delhi, India, at +5:30, or the country of Nepal at +5:45.  For authors of historical works, it may be worth researching if the timezone of a city or country has changed, including what years, if any, Daylight Saving Time was in effect, and between which dates. All dates and times are local to our player, but they can instead be given in UTC, formerly known as GMT, by changing the following truth state.

	*: now represent time locally is false;

One reason we might tender the time of London while our player reads in Rio de Janeiro is, as usual, for bookkeeping.  If our player travels across time zones, then as far as the story software is concerned he has traveled through time as well.  London's tendency to stay where it is reduces confusion.  

As if readers coming unmoored in time and space weren't enough of an issue, sometimes even a simple statement like the following can produce wrong answers.

	*: say "Today is [player's weekday], [player's month] [player's day], [player's year]."

What if New Year's hits within the scant microseconds it takes for that statement to finish?  December of the brand new year comes early, is what.  If the date and time are in the status bar and updated every turn, there's probably no need to worry about such an intransient thing.  But what if we have a chronologically sorted table of milestones, each milestone being timestamped when the player accomplishes them?  Or we're trying to see how much time a rule takes to execute, down to the microsecond?  Then this minor bug could have larger consequences.  For this, we place our phrases within a "while suspending time" construction.

	*: while suspending time, say "Now is [player's time]:[player's seconds],[player's microseconds]."

	*: while suspending time:
		say "Like if-statements, there's one-liner and indented versions.";
		say "Now is [player's time]:[player's seconds].[player's microseconds]."

Within the "while suspending time" phrase, all the variables report the time as it was when "while suspending time" itself happened.  This also implies that any changes to the "represent time locally" setting won't have any effect within the while.

A microsecond is one millionth of a second.  If we need milliseconds (which are the much larger thousandths of a second), then we divide the microseconds by one thousand for a number less extraordinary.

	*: To decide what number is the player's milliseconds: 
		decide on the player's microseconds divided by 1000.

It is likely not worth mentioning that "the player's seconds" can occasionally hit 60 for a leap second.  

Example: * Time Capsules of the Future! - A test case from the year 2423! (Allegedly.)
	
	*: "Time Capsules of the Future!"
	
	Include the real date and time by Ron Newcomb.
	
	The story creation year is 2423.
	
	When play begins, unless the player's time is available, say "Your interpreter does not support this feature.  Try the Quixe interpreter from http://eblong.com/zarf/glulx/quixe/ either online, or, downloaded and installed and using the following line of code.[paragraph break]Release along with the 'Quixe' interpreter."
	
	When play begins when the player's time is available and the story creation year is greater than the player's year, say "I believe your computer's date is set incorrectly.  This work was published in [story creation year], which is far into the future from where you sit in [the player's year]."
	
	When play begins when the player's time is available:
		repeat with foo running from 1 to 3:
			while suspending time:
				say "Seconds & microseconds: [player's seconds]:[player's microseconds].";
				say "Your time is [the player's time].";
				say "Your date is [player's weekday], [player's month] [player's day], [player's year].";
				say "Oh, and your timezone is [the player's timezone].";
				say "Seconds & microseconds: [player's seconds]:[player's microseconds].";
			say "Seconds & microseconds (after suspension): [player's seconds]:[player's microseconds].";
			say line break.
	
	There is a room. 
	
	Release along with the "Quixe" interpreter.
	
	
	


