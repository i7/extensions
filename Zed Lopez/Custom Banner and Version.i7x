Version 1/220215 of Custom Banner and Version by Zed Lopez begins here.

"A framework for customizing banner and version output. For 6M62."

Include (-
[ SerialNumber i;
    for (i=0 : i<6 : i++) print (char) ROM_GAMESERIAL->i;
];

[ SerialNumberYear i;
  ! ROM_GAMESERIAL has ASCII numerals; 48 is ASCII for 0; 528 is 10*48 + 1*48
  i = (10 * ROM_GAMESERIAL->0) + ROM_GAMESERIAL->1 - 528;
  ! Y2122 problem = someone else's problem!
  if (i < 22) i = i + 100;
  return i + 2000; 
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
  print (string) LibSerial;
];

[ PrintIFID ix;
  for (ix=8: ix <= (UUID_ARRAY->0)-2: ix++) print (char) UUID_ARRAY->ix;
];

-).

To decide what number is the serial number year: (- SerialNumberYear() -).

To decide what number is the first published year:
  if the story creation year is not 0, decide on the story creation year;
  decide on the serial number year.

To say I6 version: (- inversion; -).
To say I6T version: (- print (PrintI6Text) LibRelease; -).

To say interpreter version: (- PrintJustInterpreterVersion(); -).
To say vm version: (- PrintVmVersion(); -).
To say library serial number: (- PrintLibrarySerialNumber(); -).

To say dev flags: (- DevFlags(); -).

To say story serial number: (- SerialNumber(); -).

To say story IFID: (- PrintIFID(); -).
To say I7 version: (- print (PrintI6Text) NI_BUILD_COUNT; -).

The default story headline is always "An Interactive Fiction".

[ since this is defined as the last rule, any "for printing the banner text:" rule you define will override it ]
Last for printing the banner text (this is the original flavor banner text rule):
  say "[b][story title][/b][line break]" (A);
  say "[story headline][if story author is not empty] by [story author][end if][line break]" (B);
  say "Release [release number] / Serial number [story serial number] / Inform 7 build [I7 version] (I6/v[I6 version] lib [I6T version]) [dev flags][line break]" (C);

Versioning is an action out of world.
Understand the command "version" as something new.
Understand "version" as versioning.

Carry out versioning (this is the version command output rule):
    say banner text; [ carries out the printing the banner text activity ]
    say "Identification number: //[story IFID]//[line break]" (D);
    say "Interpreter version [interpreter version] / VM [vm version] / Library serial number [library serial number][line break]" (E);
    say "[the list of extension credits]" (F);

This is the bibliographic details rule:
  say "Title: [story title][line break]" (G);
  say "Author: [if story author is not empty][story author][else]Anonymous[end if][line break]" (H);
  say "Headline: [story headline][line break]" (I);
  say "Genre: [story genre][line break]" (J);
  say "Release number: [release number][line break]" (K);
  say "First published: [first published year][line break]" (L);
  let lang be word number 1 in "[language of play]";
  say "Language of play: [lang][line break]" (M);
  say "IFID: [story IFID][line break]" (N);
  say "Story description: [if story description is empty]None[else][story description][end if][line break]" (O);

To say bibliographic details: follow the bibliographic details rule.

To say I7 name-version: say "Inform 7 [I7 version]".
To say I6 name-version: say "I6 [I6 version]".
To say I6t name-version: say "I6T [I6T version]".
To say custom banner prefix: say "Made with ".

This is the custom banner I7 credit rule:
  say "[custom banner prefix][I7 name-version] / [I6 name-version] / [I6t name-version][line break]" (P).

To say I7 credit: follow the custom banner I7 credit rule.

This is the custom banner story header rule:
  if the story headline is the default story headline begin;
    say "[b][story title][/b][if story author is not empty] by [story author][end if][line break]" (Q);
  else;
    say "[b][story title][/b][line break]" (R);
    say "[story headline][if story author is not empty] by [story author][end if][line break]" (S);
  end if;

To say story header: follow the custom banner story header rule.

Use abbreviated banner text translates as (- Constant ABBREV_BANNER_TEXT; -).
Use abbreviated version translates as (- Constant ABBREV_VERSION_TEXT; -).

For printing the banner text (this is the abbreviated banner text rule):
  say story header;
  say I7 credit;

The abbreviated banner text rule does nothing when the abbreviated banner text option is not active.

This is the abbreviated version rule:
  say story header;
  say "Release [release number]/[story serial number][line break]" (T);
  say "IFID: [story IFID][line break]" (U);
  say I7 Credit;
  say "[the list of extension credits]" (V);

The abbreviated version rule substitutes for the version command output rule when the abbreviated version option is active.

Part bold (for use without Typography by Zed Lopez)

To say b -- beginning say_b -- running on: (- style bold; -).
To say /b -- ending say_b -- running on: (- style roman; -).

Custom Banner and Version ends here.

---- Documentation ----

This extension kidnaps the printing the banner text activity and the version
command and replaces them with exact duplicates. And then provides the story
author a toolkit for customizing them.

This is an example banner, by the default:

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
that). 6/12N is the library release number (and has been the same
for at least 6G60 through 6M62). The "library serial number" given with
by version command is also associated with the I6 Template Layer (and
has remained constant at 080126 for at least 6G60 through 6M62. These
are defined in Output.i6t. (Since 6.12/N thus does little to identify
the specific version of the library used and the I7 version number
*does* of itself imply some particular version, one could argue that
including 6.12/N is superfluous toward identifying the library. But it
has traditionally been there.)

So for the things we *must* include in the banner to be compliant with
the license, the following should suffice:

	"[I7 version-name] / [I6 version-name] / [I6T version-name]"

The Banner Day example below gives an example of omitting the story headline
if it hasn't been changed from the default.

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
license. The existing version command behavior doesn't have much to do
with what actually satisfying the terms of this license would look like,
but we pretend that it does. Cross your fingers that an extension author
(or their heir) doesn't start calling for actual compliance. At any rate,
the list of extension credits should not be removed.

This extension also defines a "say bibliographic details" phrase to
output an equivalent of the bibliographic card in the Project Index.

Chapter Easy replacements

Suggested pre-made alternatives for each of the banner and the
version output are included. You can use either or both of these
Use options:

	Use abbreviated banner text.
	Use abbreviated version.

These would produce for the banner:

	Banner Day
	An extension example by Zed Lopez
	
	Made with Inform 7 6M62 / I6 6.36 / I6T 6/12N

and for the version:

	Banner Day
	An extension example by Zed Lopez
	Release 1/220215
	IFID: C1BA3705-8444-4887-B03B-880F32CFB1DB
	
	Made with Inform 7 6M62 / I6 6.36 / I6T 6/12N
	Standard Rules version 3/120430 by Graham Nelson
	Custom Banner and Version version 1/220215 by Zed Lopez

or, if the headline hasn't been changed from the default,
banner:

	Banner Day by Zed Lopez
	
	Made with Inform 7 6M62 / I6 6.36 / I6T 6/12N

and version:

	Banner Day by Zed Lopez
	Release 1/220215
	IFID: C1BA3705-8444-4887-B03B-880F32CFB1DB
	
	Made with Inform 7 6M62 / I6 6.36 / I6T 6/12N
	Standard Rules version 3/120430 by Graham Nelson
	Custom Banner and Version version 1/220215 by Zed Lopez

Chapter References regarding Inform License Obligations

Section Inform License excerpt

A story file produced with the Inform system belongs to whoever wrote
it and may be sold for profit if so desired, without the need for
royalty payment, provided that it prints a game banner conforming to
the standard library's banner at an early stage in play: in
particular, this banner must contain the information that the story
file was compiled by Inform, and the version numbers of compiler and
library used.

Section Recipe Book §11.1. Start-Up Features excerpt

When the story file starts up, it often prints a short introductory
passage of text (the "overture") and then a heading describing itself,
together with some version numbering (the "banner"). It is traditional
that the banner must appear eventually (and one of the few requirements
of the Inform licence is that the author acknowledge Inform somewhere,
for which the banner is sufficient).

Chapter Banner Day

Section Banner Day story

This adds a "biblio" command to print the bibliographic data and
otherwise demonstrates how one would perform the equivalent
customizations one would get with:

	Use abbreviated banner text.
	Use abbreviated version.

Example: * Banner Day

	*: "Banner Day" by Zed Lopez
	
	Include Custom Banner and Version by Zed Lopez.
	
	Lab is a room.
	
	To say story header:
	  if the story headline is the default story headline begin;
	    say "[b][story title][/b][if story author is not empty] by [story author][end if][line break]";
	  else;
	    say "[b][story title][/b][line break]";
	    say "[story headline][if story author is not empty] by [story author][end if][line break]";
	  end if;
	
	For printing the banner text:
	  say story header;
	  say I7 credit;
	  
	This is the custom version rule:
	  say story header;
	  say "Release [release number]/[story serial number][line break]";
	  say "IFID: [story IFID][line break]";
	  say line break;
	  say I7 credit;
	  say "[the list of extension credits]";
	  
	The custom version rule is listed instead of the version command output rule in the carry out versioning rules.
	
	Biblioing is an action out of world.
	Understand "biblio" as biblioing.
	carry out biblioing: say bibliographic details.
	
	Test me with "version / biblio".

Section Banner Day output

anner Day by Zed Lopez

Made with Inform 7 6M62 / I6 6.36 / I6T 6/12N

Lab

>test me
(Testing.)

>[1] version
Banner Day by Zed Lopez
Release 1/220215
IFID: C1BA3705-8444-4887-B03B-880F32CFB1DB


Made with Inform 7 6M62 / I6 6.36 / I6T 6/12N
Standard Rules version 3/120430 by Graham Nelson
Custom Banner and Version version 1/220215 by Zed Lopez

>[2] biblio

Title: Banner Day
Author: Zed Lopez
Headline: An Interactive Fiction
Genre: Fiction
Release number: 1
First published: 2022
Language of play: English
IFID: C1BA3705-8444-4887-B03B-880F32CFB1DB
Story description: None
