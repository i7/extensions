Version 6.0.220604 of Extended Banner by Nathanael Nerode begins here.

"More control over what is printed in a banner, including an easily-included copyright line."

"based on Version 5 by Gavin Lambert; which was based on Version 4 by Stephen Granade"

Section - I7 Version Number

Include (-

[ I7VersionNumber;
	print (PrintI6Text) I7_VERSION_NUMBER;
	#ifdef DEBUG;
	print " / D";
	#endif;
];

-)

Section - Serial Number Glulx (for Glulx only)

Include (-

[ SerialNumber i;
	for (i=0 : i<6 : i++) print (char) ROM_GAMESERIAL->i;
];

-)

Section - Serial Number Z-machine (for Z-machine only)

Include (-

[ SerialNumber i;
	for (i=0 : i<6 : i++) print (char) HDR_GAMESERIAL->i;
];

-)

Section - Access Low-Level Data

[The extended story headline is necessary so that, if the author doesn't set the story headline value, "An Interactive Fiction" is printed out.]
To say extended story headline: (- TEXT_TY_Say(Headline); -).
To say story serial number: (- SerialNumber(); -).
To say I7 version number: (- I7VersionNumber(); -).

Section - Check Texts for Blank

To decide if (s - text) is blank: if the substituted form of s is "", yes; no.
To decide if (s - text) is not blank: if the substituted form of s is not "", yes; no.

Section - Copyright Line Related Rules

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
	say "Release [release number] / Serial number [story serial number] / Inform 7 v[I7 version number][line break]";
	rule succeeds.

Extended Banner ends here.

---- DOCUMENTATION ----

Extended Banner provides all of the tools necessary to rewrite the banner that is printed when a game begins.

Section: Fully Customizable Banner

By default, it primarily defines several new text substitutions: the extended story headline, the story serial number, and the I7 version number. For example, the game "Totally Normal Banner" has a rule which would print a version of the banner that's the same as the default one.

You can tweak this, as with the example game "Less Normal Banner".

Section: Predefined Copyright Options

To add a copyright line to the banner, you don't have to write a rule like the one in "Totally Normal Banner". Instead, you can define the story copyright string with the year or years for which you're claming copyright:

	The story copyright string is "2005-6".

You can also change the rights you are claiming by changing the story rights string (this is only printed if you specify the story copyright string):

	The story rights statement is "Released under the Creative Commons Attribution-NonCommercial-ShareAlike 2.5 License"

By default the story rights statement is "All rights reserved".

Note that if you replace the default story copyright line rule then it won't print the story copyright string or story rights statement, but you can still use these in your own rule.

Changelog:

	6.0.220604: rearrange examples & documentation to format nicely
	version 6: rewritten by Nathanael Nerode to compile in Inform 10.1 and to foolproof blank string handling; also provide a copy-pasteable example, and reorganize
	version 5: updated by Gavin Lambert to compile in 6M62 and make it easier to entirely replace the copyright line
	version 4 and earlier: originally by Stephen Granade

Example: * Totally Normal Banner - Same as default banner

Note: the "if story author is not blank" text substitution here uses a new pair of say-phrases from this extension which determine whether or not a piece of text is blank.

	*: "Totally Normal Banner"

	Include Extended Banner by Nathanael Nerode.
	The release number is 1.
	
	Rule for printing the banner text:
		say "[bold type][story title][roman type][line break][extended story headline][if story author is not blank] by [story author][end if][line break]Release [release number] / Serial number [story serial number] / Inform 7 v[I7 version number][line break]" instead.

	Test room is a room.

Example: * Less Normal Banner - A little bit of custom text

	*: "Normal Banner"

	Include Extended Banner by Nathanael Nerode.
	The release number is 1.
	
	Rule for printing the banner text:
		say "[bold type][story title][roman type][unicode 8212]or is it?[line break][extended story headline][if story author is not blank] by [story author][end if][line break]Release [release number] / Serial number [story serial number] / Inform 7 v[I7 version number][line break]" instead.

	Test room is a room.

Example: * A Simple Copyright - A copyright and license statement

	*: "A Simple Copyright"

	Include Extended Banner by Nathanael Nerode.

	The story copyright string is "2005-6".
	The story rights statement is "Released under the Creative Commons
Attribution-NonCommercial-ShareAlike 2.5 License"

	Test room is a room.

If you have something more complicated to say for your copyright statement, you can replace or adjust the "printing the story copyright line" activity:

Example: * A Silly Copyright - A bogus copyright and licence statement

	*: "A Silly Copyright"

	Include Extended Banner by Nathanael Nerode.

	Rule for printing the story copyright line:
		say "Based on a true story originally written by Suspicious Badger in 1823.[line break]" instead.
		
	Before printing the story copyright line:
		say "An anarchic kerfuffle.[line break]"
		
	After printing the story copyright line:
		say "You can discuss this story in the forum at https://my.awesome.website/[line break]"

	Badger Land is a room.
