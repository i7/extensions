Version 1/200930 of Story Substrate by Jeff Nyman begins here.

"Provides information about the substrate that a story is executing on."

Chapter - Serial Number (for Glulx only)

Include (-
[ SerialNumber i;
	for (i=0 : i < 6 : i++) print (char) ROM_GAMESERIAL -> i;
];
-).

Chapter - Serial Number (for Z-Machine only)

Include (-
[ SerialNumber i;
	for (i=0 : i < 6 : i++) print (char) HDR_GAMESERIAL -> i;
];
-).

Chapter - Serial Number Phrase

To say story serial number: (- SerialNumber(); -).

Chapter - IFID

The print ID number rule translates into I6 as "UUID_R".

Include (-
[ UUID_R ix;
	for (ix=6 : ix <= UUID_ARRAY -> 0 : ix++) print (char) UUID_ARRAY -> ix;
];
-).

To say story IFID number: (- UUID_R(); -).

Part - Inform Information

Chapter - I7 (NI) Build

Include (-
[ I7_Build;
	print (string) NI_BUILD_COUNT;
];
-).

To say I7 build: (- I7_Build(); -).

Chapter - I6 Build

Include (-
[ I6_Build;
	inversion;
];
-).

To say I6 build: (- I6_Build(); -).

Chapter - I6 Library

Include (-
[ I6_Library;
	print (string) LibRelease;
];
-).

To say I6 library: (- I6_Library(); -).

Chapter - I7 Identifier

Include (-
[ I7_Identity;
	print (string) NI_BUILD_COUNT, " ";
	print "(I6/v"; inversion;
	print " lib ", (string) LibRelease, ") ";
#ifdef STRICT_MODE;
	print "S";
#endif;
#ifdef INFIX;
	print "X";
#ifnot;
#ifdef DEBUG;
	print "D";
#endif;
];
-).

To say I7 identity: (- I7_Identity(); -).

Part - Interpreter Information (for Glulx only)

Chapter - Bitwise Calculations (unindexed)

Include (-
[ is_logical_right_shift value distance;
	@ushiftr value distance sp;
	@return sp;
];
-).

To decide what number is the bitwise and of (I - an arithmetic value) and (J - a number):
	(- ({I} & {J}) -).

To decide what number is (I - an arithmetic value) logically shifted (D - a number) bit/bits right:
	(- is_logical_right_shift({I}, {D}) -).

Chapter - Version Numbers

A terp version number is a kind of value.
65535.255.255 specifies a terp version number.

To say (N - a terp version number):
	let the major terp version number be N logically shifted 16 bits right;
	let the minor terp version number be the bitwise and of N logically shifted 8 bits right and 255;
	let the patch level be the bitwise and of N and 255;
	say "[the major terp version number].[no line break][the minor terp version number].[no line break][the patch level]".

Chapter - Glulx Version

Include (-
[ is_glulx_version;
	@gestalt 0 0 sp;
	@return sp;
];
-).

To decide what terp version number is current Glulx version number: (- is_glulx_version() -).

Chapter - Interpreter Version

Include (-
[ is_interpreter_version;
	@gestalt 1 0 sp;
	@return sp;
];
-).

To decide what terp version number is current interpreter version number: (- is_interpreter_version() -).

Chapter - Glk Test (unindexed)

Include (-
[ is_glk;
	@gestalt 4 2 sp;
	@return sp;
];
-).

To decide whether the Glk gestalt is set: (- is_glk() -).

Chapter - I/O Version

Section - IO Values

An IO implementation is a kind of value.
Unknown Glk implementation and Unknown non-Glk implementation are IO implementations.

Section - IO Detected (unindexed)

IO implementation already detected is a truth state that varies.
IO implementation already detected is false.

The cached result of IO implementation detection is an IO implementation that varies.

Section - Detecting IO

The IO implementation detection rulebook is a nothing based rulebook producing an IO implementation.

To decide what IO implementation is the current IO implementation:
	if IO implementation already detected is false:
		now the cached result of IO implementation detection is the IO implementation produced by the IO implementation detection rulebook;
		unless the rule succeeded:
			if the Glk gestalt is set:
				now the cached result of IO implementation detection is Unknown Glk implementation;
			otherwise:
				now the cached result of IO implementation detection is Unknown non-Glk implementation;
		now IO implementation already detected is true;
	decide on the cached result of IO implementation detection.

Section - Detecting IO Version

Include (-
[ is_io_version
	canGetVersion;
	@gestalt 4 2 canGetVersion;
	if (~~canGetVersion) {
		return 0;
	}
	return glk_gestalt(gestalt_Version, 0);
];
-).

To decide what terp version number is the current IO version number: (- is_io_version() -).

Part - Action for Getting Substrate Information

Reporting the substrate is an action out of world.
Understand "show substrate" as reporting the substrate.

Report reporting the substrate:
	say "Serial number: [story serial number].";
	say "IFID: [story IFID number].";
	say "Inform 7 compiler: [I7 build].";
	say "Inform 6 compiler: [I6 build].";
	say "Inform 6 library: [I6 library].";
	say "Inform 7 Identity: [I7 identity].";
	say "Glulx version: [current Glulx version number].";
	say "Interpreter version: [current interpreter version number].";
	say "I/O version: [current IO version number]."

Story Substrate ends here.

---- DOCUMENTATION ----

Story files are built on a particular version of Inform 7 which is utilizing a series of extensions to provide functionality. Inform 7 is, in turn, backed up by a version of Inform 6 which is itself using a particular Inform 6 library. Much of this information is printed as part of the "banner" that displays when a story file starts or if a "version" command is used. There may be a desire to get some of that information individually and that's what this extension helps to do.

There is also the interpreter that the story itself is running on. This extension will attempt to gather some of that information, although interpreter information can only be recovered in a Glulx context.

All of this is what I refer to as the "substrate." This extension helps recover and display that information.

Section - Serial Number

To get the serial number:

	say "Serial number: [story serial number]."

Section - IFID

IFID stands for Interactive Fiction IDentifier. An IFID is a number that is unique to each story file. This gives players, authors, and archivists a universal and unambiguous way in which to refer to a given story file. The IFID forever refers to that story file in all of its versions, regardless of its serial number, release number and so forth. Conceptually it's pretty much identical to the idea of the ISBN system for books. The IFID system is defined by the Treaty of Babel, which was created in 2006.

To get the IFID:

	say "IFID: [story IFID number]."

Section - Inform 7

Inform 7 provides a specific compiler called NI (Natural Inform) which has its own version. To get that version:

	say "Inform 7 compiler: [I7 build]."

NI is the Inform 7 compiler that in turn relies on a specific Inform 6 compiler. To get that version:

	say "Inform 6 compiler: [I6 build]."

Inform 6 relies on a specific library of code. To get the version of the Inform 6 library:

	say "Inform 6 library: [I6 library]."

All of the above translates into what I call the "Inform 7 Identity", meaning that with the above information you can construct a very specific identity for the particular version of Inform that was used to compile a given story file. You can get that full identity with:

	say "Inform 7 Identity: [I7 identity]."

This "identity" is essentially what's printed as part of the starting banner. Having a simple way to refer to the string, however, means you can recover it if you decided to override how, or even if, the banner is displayed.

Section - Interpreter Style (Glulx Only)

There have been various ways to get information about the interpreter that the story file is running on. Most of them are imperfect at best so this extension doesn't really try to do much of what's called "interpreter sniffing." These next bits only work under Glulx interpreters.

To get the Glulx verison number that the story is being interpreted under:

	say "Glulx version: [current Glulx version number]."

Glulx is the virtual machine, which has its own version number, as distinct from the interpreter that is implementing the virtual machine. To get the Glulx interpreter version number:

	say "Interpreter version: [current interpreter version number]."

There is yet one more level to consider which is the I/O implementation being used, which has to do with Glk. This, too, will have its own version. To get the I/O version:

	say "I/O version: [current IO version number]."

Whether the above information is useful really depends on whether you are using some effect or feature that is known to exist only within certain Glulx versions or with certain Glk I/O implementations. The interpreter version is less useful without knowing what the actual interpreter is so, for now, that's included for completeness of versioning information rather than as anything terribly useful.
