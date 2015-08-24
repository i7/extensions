Play Counter (for Glulx only) by Daniel Stelzer begins here.

"Allows an author to check how many times their story has been played."

Table of Play Count
count
0 [play count]
0 [ending count]
0 [final ending count]

To decide which number is the play count:
	select row 1 in the Table of Play Count;
	decide on the count entry.
To decide which number is the ending count:
	select row 2 in the Table of Play Count;
	decide on the count entry.
To decide which number is the final ending count:
	select row 3 in the Table of Play Count;
	decide on the count entry.

To read count data:
	read the File of Play Count into the Table of Play Count.
To write count data:
	write the File of Play Count from the Table of Play Count.

When play begins:
	read count data.

The first-turn flag is initially true.
After doing anything:
	now the first-turn flag is false;
	select row 1 in the Table of Play Count;
	increment the count entry;
	write count data;
	continue the action.

When play ends:
	select row 2 in the Table of Play Count;
	increment the count entry;
	if the story has ended finally:
		select row 3 in the Table of Play Count;
		increment the count entry;
	write count data.

Play Counter ends here.

---- DOCUMENTATION ----

To use this extension, you must add a line to your story defining the filename to use.

	The File of Play Count is called "YOURSTORYTITLEplaycount".

(Replace YOURSTORYTITLE with your title.)

Then you can check how many times the story has been played by referring to "the play count" (which is incremented whenever the story is started and goes past the first move), "the ending count" (which is incremented whenever the story ends), and "the final ending count" (which is incremented whenever the story ends finally).
