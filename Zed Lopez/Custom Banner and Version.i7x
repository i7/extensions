Version 1 of Custom Banner and Version by Zed Lopez begins here.

"Facilitates customizing banner and version output."

Include (-
[ SerialNumber i;
	for (i=0 : i<6 : i++) print (char) ROM_GAMESERIAL->i;
];

[ DevFlags;
#ifdef STRICT_MODE;
	print "S";
#endif;
#ifdef DEBUG;
	print "D";
#endif;
];

[ PrintJustInterpreterVersion ix;
@gestalt 1 0 ix;
print ix / $10000, ".", (ix & $FF00) / $100, ".", ix & $FF;
];

[ PrintVmVersion ix;
@gestalt 0 0 ix;
print ix / $10000, ".", (ix & $FF00) / $100, ".", ix & $FF;
];

[ PrintLibrarySerialNumber;
print (string) LibSerial, "^";
];

[ PrintIFID   ix;
    for (ix=8: ix <= (UUID_ARRAY->0)-2: ix++) print (char) UUID_ARRAY->ix;
];

-).



To say I6 version: (- inversion; -).
To say I6T version: (- print (PrintI6Text) LibRelease; -).

To say interpreter version: (- PrintJustInterpreterVersion(); -).
To say vm version: (- PrintVmVersion(); -).
To say library serial number: (- PrintLibrarySerialNumber(); -).

To say dev flags: (- DevFlags(); -).

To say story serial number: (- SerialNumber(); -).

To say story IFID: (- PrintIFID(); -).
To say I7 version: (- print (PrintI6Text) NI_BUILD_COUNT; -).

To say b -- beginning say_b -- running on: (- style bold; -).
To say /b -- ending say_b -- running on: (- style roman; -).

The default story headline is always "An Interactive Fiction".

[ since this is defined as the last rule, any "for printing the banner text:" rule you define will override it ]
Last for printing the banner text (this is the original flavor banner text rule):
  say "[b][story title][/b][line break]";
  say "[story headline][if story author is not empty] by [story author][end if][line break]";
  say "Release [release number] / Serial number [story serial number] / Inform 7 build [I7 version] (I6/v[I6 version] lib [I6T version]) [dev flags][line break]";

Versioning is an action out of world.

Understand the command "version" as something new.
Understand "version" as versioning.

Carry out versioning (this is the version command output rule):
    say banner text; [ carries out printing the banner text activity ]
    say "Identification number: //[story IFID]//[line break]";
    say "Interpreter version [interpreter version] / VM [vm version] / Library serial number [library serial number][line break]";
    say "[the list of extension credits]";

To say bibliographic details:
  say "Title: [story title][line break]";
  say "Author: [if story author is not empty][story author][else]Anonymous[end if][line break]";
  say "Headline: [story headline][line break]";
  say "Genre: [story genre][line break]";
  say "Release number: [release number][line break]";
  say "Story creation year: [story creation year][line break]";
  let lang be "[language of play]";
  say "Language of play: [word number 1 in lang][line break]";
  say "IFID: [story IFID][line break]";
  say "Story description: [if story description is empty]None[else][story description][line break]";

Custom Banner and Version ends here.

---- Documentation ----

This extension kidnaps the printing the banner text activity and the version
command and replaces them with exact duplicates. And then provides the story
author a toolkit for customizing them.

This is an example default banner:

Banner
An Interactive Fiction by Zed Lopez
Release 1 / Serial number 220214 / Inform 7 build 6M62 (I6/v6.36 lib 6/12N) SD

Release and Serial number are in reference to your particular story.
Release is the I7 global variable Release Number, which defaults to 1.
Serial number is the date of compilation; the I7 compiler hard-codes
this into the I6 output.

The Inform license obliges that an Inform 7 game prints a "banner conforming
to the standard library's banner at an early stage in play: in particular,
this banner must contain the information that the story file was compiled
by Inform, and the version numbers of compiler and library used."

"Library" here refers to the I6 Template Layer (my guess is that a lot
of people have seen "lib 6.12/N" a lot of times without ever knowing
that). "6/12N" is the library release number, and has been the same
for at least 6G60 through 6M62. The "library serial number" given with
in the default version command is also associated with the I6 Template
Layer. And it has remained constant at 080126 for at least 6G60 through
6M62. (These are defined in Output.i6t, which also defines a constant
LIBRARY_VERSION of 612, also consistent from 6G60 through 6M62.) 

So for the things we *must* include in the banner to be compliant with
the license, the following should suffice:

	say "Made with Inform 7 [I7 version] / I6 [I6 version] / I6T [I6T version][line break]";

The example below gives an example of omitting the story headline if it
hasn't been changed from the default.

This is an example of default version command output:

	Banner
	An Interactive Fiction by Zed Lopez
	Release 1 / Serial number 220214 / Inform 7 build 6M62 (I6/v6.36 lib 6/12N) SD
	Identification number: //C1BA3705-8444-4887-B03B-880F32CFB1DB//
	Interpreter version 1.3.6 / VM 3.1.2 / Library serial number 080126
	Standard Rules version 3/120430 by Graham Nelson
	Custom Banner and Version version 1 by Zed Lopez

By default, the version command repeats the banner and prints the story's
IFID number. The interpreter version is just that, the version of, e.g.,
Quixe, or Glulxe, or Git in use. (It would be somewhat more useful if the
interpreter were also identified by name.) VM is again, just that, the
version of Glulx or the Z-Machine in use. The library serial number was
explained above.

Finally, it lists the extension credits of those included extensions that
didn't specify they were using authorial modesty. Extensions in the Public
Library, or formerly available on the Inform 7 website, or in the Friends
of I7 Github repo were/are released under a Creative Commons Attribution
license. The existing version command behavior doesn't come close to
satisfying the terms of this license, but we pretend that it does. Cross
your fingers that an extension author or their heir doesn't start
calling for actual compliance. At any rate, this information should
not be removed.

This extension also defines a "say bibliographic details" phrase to
output an equivalent of the bibliographic card in the Project Index.

Chapter Inform License Obligations

Section References

From the Inform License

A story file produced with the Inform system belongs to whoever wrote
it and may be sold for profit if so desired, without the need for
royalty payment, provided that it prints a game banner conforming to
the standard library's banner at an early stage in play: in
particular, this banner must contain the information that the story
file was compiled by Inform, and the version numbers of compiler and
library used.

RB §11.1. Start-Up Features

When the story file starts up, it often prints a short introductory
passage of text (the "overture") and then a heading describing itself,
together with some version numbering (the "banner"). It is traditional
that the banner must appear eventually (and one of the few requirements
of the Inform licence is that the author acknowledge Inform somewhere,
for which the banner is sufficient).

Section Examples

Example: * Banner Day

	*: "Banner Day" by Zed Lopez
	
	Include Custom Banner and Version by Zed Lopez.
	
	Lab is a room.
	
	For printing the banner text:
	  if the story headline is the default story headline begin;
	    say "[b][story title][/b][if story author is not empty] by [story author][end if][line break]";
	  else;
	    say "[b][story title][/b][line break]";
	    say "[story headline][if story author is not empty] by [story author][end if][line break]";
	  end if;
	  say "Made with Inform 7 [I7 version] / I6 [I6 version] / I6T [I6T version][line break]";
	
	This is the custom version rule:
	        say "[banner text][line break]";
	        say "[the list of extension credits]";
	
	The custom version rule is listed instead of the version command output rule in the carry out versioning rules.
