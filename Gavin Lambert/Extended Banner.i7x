Version 5 of Extended Banner by Gavin Lambert begins here.

"More control over what is printed in a banner, including an easily-included copyright line."

"based on Version 4 by Stephen Granade"

Section 1

Include (-

[ I7BuildVersion;
	print (PrintI6Text) NI_BUILD_COUNT, " ";
	print "(I6/v"; inversion;
	print " lib ", (PrintI6Text) LibRelease, ") ";
#ifdef STRICT_MODE;
	print "S";
#endif;
#ifdef DEBUG;
	print "D";
#endif;
];

-)

Section 1G (for Glulx only)

Include (-

[ SerialNumber i;
	for (i=0 : i<6 : i++) print (char) ROM_GAMESERIAL->i;
];

-)

Section 1Z (for Z-machine only)

Include (-

[ SerialNumber i;
	for (i=0 : i<6 : i++) print (char) HDR_GAMESERIAL->i;
];

-)

Section 2

To decide if (s - text) is blank: if s is "", yes; no.
To decide if (s - text) is not blank: if s is not "", yes; no.

[The extended story headline is necessary so that, if the author doesn't set the story headline value, "An Interactive Fiction" is printed out.]
To say extended story headline: (- TEXT_TY_Say(Headline); -).
To say story serial number: (- SerialNumber(); -).
To say I7 version number: (- I7BuildVersion(); -).

The story copyright string and story rights statement are text variables.

Printing the story copyright line is an activity.

Last rule for printing the story copyright line (this is the standard story copyright rule):
	if the story copyright string is not blank:
		say "Copyright [unicode 169] [story copyright string][if story author is not blank] by [story author][end if][line break]";
		if the story rights statement is not blank, say "[story rights statement]";
		otherwise say "All rights reserved";
		say "[line break]";
	rule succeeds.

Last rule for printing the banner text (this is the extended banner rule):
	say "[bold type][story title][roman type][line break][extended story headline][if story author is not blank] by [story author][end if][line break]";
	carry out the printing the story copyright line activity;
	say "Release [release number] / Serial number [story serial number] / Inform 7 build [I7 version number][line break]";
	rule succeeds.

Extended Banner ends here.

---- DOCUMENTATION ----

Extended Banner provides all of the tools necessary to rewrite the banner that is printed when a game begins.

It was originally written by Stephen Granade; but in version 2, Gavin Lambert updated it to compile in 6M62 and made it easier to entirely replace the copyright line.

By default it does nothing but define several new text substitutions: the extended story headline, the story serial number, and the I7 version number. For example, the following rule would print a version of the banner that's the same as the default one:

	Rule for printing the banner text:
		say "[bold type][story title][roman type][line break][extended story headline][if story author is not blank] by [story author][end if][line break]Release [release number] / Serial number [story serial number] / Inform 7 build [I7 version number][line break]" instead.

The "if story author is not blank" text substitution uses a new phrase that determines whether or not a piece of text is blank.

To add a copyright line to the banner, you don't have to write a rule like the one above. Instead, you can define the story copyright string with the year or years for which you're claming copyright:

	The story copyright string is "2005-6".

You can also change the rights you are claiming by changing the story rights string (this is only printed if you specify the story copyright string):

	The story rights statement is "Released under the Creative Commons Attribution-NonCommercial-ShareAlike 2.5 License"

By default the story rights statement is "All rights reserved".

If you have something more complicated to say for your copyright statement, you can replace or adjust the "printing the story copyright line" activity:
	
	Rule for printing the story copyright line:
		say "Based on a true story originally written by Suspicious Badger in 1823." instead.
		
	Before printing the story copyright line:
		say "An anarchic kerfuffle."
		
	After printing the story copyright line:
		say "You can discuss this story in the forum at https://my.awesome.website/"

Note that if you replace the default story copyright line rule then it won't print the story copyright string or story rights statement, but you can still use these in your own rule.
