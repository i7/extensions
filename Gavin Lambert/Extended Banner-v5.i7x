Version 5.0.1 of Extended Banner by Gavin Lambert begins here.

"More control over what is printed in a banner, including an easily-included copyright line."

"based on Version 4 by Stephen Granade"

Section 1

Include (-

[ I7BuildVersion;
	print (PrintI6Text) I7_VERSION_NUMBER;
#ifdef DEBUG;
	print " / D";
#endif; ! DEBUG
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
	say "Release [release number] / Serial number [story serial number] / Inform 7 v[I7 version number][line break]";
	rule succeeds.

Extended Banner ends here.

---- DOCUMENTATION ----

Extended Banner provides all of the tools necessary to rewrite the banner that is printed when a game begins.

It was originally written by Stephen Granade; but in version 5, Gavin Lambert updated it to compile in 6M62 and made it easier to entirely replace the copyright line.
Version 5.0.1 is an update to make it compatible with 10.1.2.

By default it does nothing but define several new text substitutions: the extended story headline, the story serial number, and the I7 version number. For example, the following rule would print a version of the banner that's the same as the default one:

	Rule for printing the banner text:
		say "[bold type][story title][roman type][line break][extended story headline][if story author is not blank] by [story author][end if][line break]Release [release number] / Serial number [story serial number] / Inform 7 v[I7 version number][line break]" instead.

The "if story author is not blank" text substitution uses a new phrase that determines whether or not a piece of text is blank.

For additional examples of customisations, see below.

Example: * Defaults - A simple demonstration of the defaults.

The default behaviour is exactly the same as if you hadn't even included the extension, so this is not especially interesting as an example, but it's useful for automated testing.  (Albeit with the caveat that intest ignores the release banner, so some manual comparison is still needed.)

	*: "Defaults" by Gavin Lambert

	Include Extended Banner by Gavin Lambert.
	
	There is a room.

Example: * Copyright - Adding some copyright text to the banner.

To add a copyright line to the banner, you don't have to write a rule like the one above. Instead, you can define the story copyright string with the year or years for which you're claming copyright:

	*: "Copyright" by Gavin Lambert
	
	Include Extended Banner by Gavin Lambert.
	
	The story copyright string is "2022".

	There is a room.

Example: * Explicitly Licensed - Adding some explicit license text as well.

You can also change the rights you are claiming by changing the story rights string (this is only printed if you specify the story copyright string):

	*: "Explicitly Licensed" by Gavin Lambert.
	
	Include Extended Banner by Gavin Lambert.

	The story copyright string is "2022".
	The story rights statement is "Released under the Creative Commons Attribution-NonCommercial-ShareAlike 2.5 License".
	
	There is a room.

By default the story rights statement is "All rights reserved".

Example: * Further Customization - Adjusting the copyright line in more depth.

If you have something more complicated to say for your copyright statement, you can replace or adjust the "printing the story copyright line" activity:

	*: "Further Customization" by Gavin Lambert.
	
	Include Extended Banner by Gavin Lambert.

	The story copyright string is "1823".
	
	Rule for printing the story copyright line:
		say "Based on a true story originally written by Suspicious Badger in [story copyright string]." instead.
		
	Before printing the story copyright line:
		say "An anarchic kerfuffle."
		
	After printing the story copyright line:
		say "You can discuss this story in the forum at https://my.awesome.website/."

	There is a room.

Note that if you replace the default story copyright line rule then it won't print the story copyright string or story rights statement, but you can still use these in your own rule.
