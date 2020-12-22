Version 1/200930 of Supplemental by Jeff Nyman begins here.

"Personal extension to keep the main source text clean."

Use authorial modesty.

Part - Extensions

Include Story Substrate by Jeff Nyman.

Section G (for Glulx only)

Include Glulx Text Effects by Emily Short.

Part - Operation Details

Use American dialect.
Use no deprecated features.
Use unabbreviated object names.

Section G (for Glulx only)

Use DICT_WORD_SIZE of 15.

Part - Unicode Determination

[ This logic is derived from the extension "Unicode Interrogation" by Michael Martin. ]

Section Z (for Z-Machine only)

To decide whether unicode (X - a number) is supported exactly/--:
	(- (unicode_test({X}) == 1) -)

Include (-
[ unicode_test x i;
	if (0->$32 == 0) return 0;
	@check_unicode x -> i;
	return i & 1;
];
-).

Section G (for Glulx only) (unindexed)

To decide whether unicode (X - a number) is supported exactly:
	(- (glk_gestalt(gestalt_CharOutput, {X}) == gestalt_CharOutput_ExactPrint) -).

To decide whether unicode (X - a number) is supported:
	(- (glk_gestalt(gestalt_CharOutput, {X}) ~= gestalt_CharOutput_CannotPrint) -).

Part - Text Substitutions

To say i -- beginning say_i -- running on: (- style underline; -).
To say /i -- ending say_i -- running on: (- style roman; -).
To say em -- beginning say_em -- running on: (- style underline; -).
To say /em -- ending say_em -- running on: (- style roman; -).

To say p -- running on: (- DivideParagraphPoint(); new_line; -).
To say br -- running on: (- new_line; -).
To say r -- running on: (- RunParagraphOn(); -).

To say tt -- beginning say_tt -- running on: (- font off; -).
To say /tt -- ending say_tt -- running on: (- font on; -).

Section Z (for Z-Machine only)

To say b -- beginning say_b -- running on: (- style bold; -).
To say /b -- ending say_b -- running on: (- style roman; -).

To say strong -- beginning say_strong -- running on: (- style bold; -).
To say /strong -- ending say_strong -- running on: (- style roman; -).

Section G (for Glulx only)

To say b -- beginning say_b -- running on: say first custom style.
To say /b -- ending say_b -- running on: (- style roman; -).

To say strong -- beginning say_strong -- running on: say first custom style.
To say /strong -- ending say_strong -- running on: (- style roman; -).

Section - Symbols

To say copyright symbol:
	if unicode 169 is supported:
		say unicode 169; [copyright]
	otherwise:
		say "(C)".

To say --:
	if Unicode 8212 is supported:
		say Unicode 8212; [em-dash]
	otherwise:
		say "--".

To say -:
	if Unicode 8211 is supported:
		say Unicode 8211; [en-dash]
	otherwise:
		say "-".

Part - User Styles

Section G (for Glulx only)

Table of User Styles (continued)
style name	relative size	color	background color
italic-style	--	--	--
fixed-letter-spacing-style	--	"#444444"	--
header-style	10	--	--
bold-style	2	"#888888"	--
alert-style	5	"#FF0000"
note-style	--	"#00FF00"
blockquote-style	--	"#FFFF00"
input-style	--	"#0000FF"

Table of User Styles (continued)
style name	relative size	justification	italic	indentation	first line indentation	font weight	color
special-style-1	--	left-right-justified	--	--	--	bold-weight	--
special-style-2	4	left-right-justified	true	--	--	light-weight	"#888888"

Part - Story Info

Requesting story information is an action out of world applying to nothing.
Understand "info" as requesting story information.

Carry out requesting story information:
	say the complete list of extension credits.

The specification of requesting story information action is "Requesting story information is a way to get a list of all of the extensions that have been applied to the current story."

Supplemental ends here.

---- DOCUMENTATION ----

This extension is in place so that the main source file does not get cluttered by what is effectively supporting material. If there are defined aspects of related functionality, that functionality should go in a separate extension.

Section: Text Breaks

Inform allows paragraph breaks, line breaks, and paragraph runs to be specified as text substitutions. This extension allows you shorten the wording:

	say "Here is a line break.[br]"
	say "Here is a paragraph break.[p]"
	say "Here is running the next paragraph into this one. [r]"

Section: Text Formatting

Inform allows bold and italic text substitutions. This extension allows you to shorten the wording as well as provide the substitutions as related opening and closing terms:

	say "[i]Here is a sentence in italics.[/i]"
	say "[b]Here is a sentence in bold.[/b]"

It's also possible to use names that are used in HTML for these purposes:

	say "[em]Here is a sentence in italics.[/em]"
	say "[strong]Here is a sentence in bold.[/strong]"

This extension also allows you to specify the true type font style in a slightly shorter format:

	say "[tt]This is a true type font.[/tt]"

Note that the above is equivalent to "font off" and "font on" which is also essentially equivalent with "fixed letter spacing" and "variable letter spacing".

Section: Symbols

You can use text subsitutions for dashes as well:

	say "Display an em-dash: [--]"
	say "Display an en-dash: [-]"

You can also apply the copyright symbol:

	say "Copyright [copyright symbol]"

Whether the above substitutions work or not will depend on whether the interpreter the story file is running on supports Unicode character display.
