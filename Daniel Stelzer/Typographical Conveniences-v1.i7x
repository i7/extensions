Version 1 of Typographical Conveniences by Daniel Stelzer begins here.

Include Unicode Interrogation by Michael Martin.

Chapter A - All Platforms

To say i -- beginning say_i -- running on: (- style underline; -).
To say /i -- ending say_i -- running on: (- style roman; -).
To say b -- beginning say_b -- running on: (- style bold; -).
To say /b -- ending say_b -- running on: (- style roman; -).

To say p -- running on: (- DivideParagraphPoint(); new_line; -).
To say br -- running on: (- new_line; -).
To say r -- running on: (- RunParagraphOn(); -).

To say tt -- beginning say_tt -- running on: (- font off; -).
To say /tt -- ending say_tt -- running on: (- font on; -).

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

To say t: say "    ".
[To say (N - number) tabs: repeat N times begin; say "        "; end repeat.]

Chapter Z - Specifics (for Z-machine only)

To say note -- beginning say_note -- running on: (- style underline; -).
To say /note -- ending say_note -- running on: (- style roman; -).
To say alert -- beginning say_alert -- running on: (- style bold; -).
To say /alert -- ending say_alert -- running on: (- style roman; -).

Chapter G - Specifics (for Glulx only)

Include Glulx Text Styles by Daniel Stelzer.

Section 1 - Combining Bold and Italic (for use with Default Styles by Daniel Stelzer)

To say ib -- continuing say_i -- running on: say using alert style.
To say /ib -- continuing say_i -- running on: say using italic style.
To say bi -- continuing say_b -- running on: say using alert style.
To say /bi -- continuing say_b -- running on: say using bold style.

To say l -- beginning say_l -- running on: say using block-quote style.
To say /l -- ending say_l -- running on: say using normal style.
To say li -- continuing say_l -- running on: say using note style.
To say /li -- continuing say_l -- running on: say using block-quote style.
To say il -- continuing say_i -- running on: say using note style.
To say /il -- continuing say_i -- running on: say using italic style.

Section 2 - Notes

To say note -- beginning say_note -- running on: say using note style.
To say /note -- ending say_note -- running on: say using normal style.
To say alert -- beginning say_alert -- running on: say using alert style.
To say /alert -- ending say_alert -- running on: say using normal style.

Typographical Conveniences ends here.
