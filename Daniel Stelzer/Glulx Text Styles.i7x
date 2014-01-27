Glulx Text Styles (for Glulx only) by Daniel Stelzer begins here.

"Glulx Text Styles provides a more powerful way to set up special text effects for Glulx."

"based on code by Emily Short and Brady Garvin"

Glulx color value is a kind of value. Some glulx color values are defined by the Table of Common Color Values.

Table of Common Color Values
glulx color value	assigned number
g-black	0
g-dark-grey	4473924
g-medium-grey	8947848
g-light-grey	14540253
g-white	16777215

text-justification is a kind of value. The text-justifications are left-justified, left-right-justified, center-justified, and right-justified. 

[glulx-style is a kind of value. The glulx-styles are style-normal, style-emphasized, style-preformatted, style-header, style-subheader, style-alert, style-note, style-block-quote, style-input, special-style-1, and special-style-2.]
glulx-style is a kind of value. The glulx-styles are normal style, italic style, preformatted style, header style, bold style, alert style, note style, block-quote style, input style, special-style-1, and special-style-2.

boldness is a kind of value. The boldnesses are light-weight, regular-weight, and bold-weight.

obliquity is a kind of value.  The obliquities are no-obliquity and italic-obliquity.

fixity is a kind of value. The fixities are fixed-width-font and proportional-font.

Before starting the virtual machine:
	initialize user styles.
	
Table of User Styles
style name	justification	obliquity	indentation	first-line indentation	boldness	fixed width	relative size	glulx color glulx background color
a glulx-style		a text-justification	an obliquity	a number	a number	a boldness	a fixity	a number	a glulx color value	a glulx color value


To initialize user styles:
	repeat through the Table of User Styles:
		if there is a justification entry, apply justification of (justification entry) to (style name entry);
		if there is an obliquity entry, apply obliquity (obliquity entry) to (style name entry);
		if there is an indentation entry, apply (indentation entry) indentation to (style name entry);
		if there is a first-line indentation entry, apply (first-line indentation entry) first-line indentation to (style name entry);
		if there is a boldness entry, apply (boldness entry) boldness to (style name entry);
		if there is a fixed width entry, apply fixed-width-ness (fixed width entry) to (style name entry);
		if there is a relative size entry, apply (relative size entry) size-change to (style name entry);
		if there is a glulx color entry, apply (assigned number of glulx color entry) color to (style name entry).

To apply (color change - a number) color to (chosen style - a glulx-style):
	(- SetColor({chosen style}, {color change}); -).

To apply (color change - a number) background color to (chosen style - a special-style):
	(- SetBackgroundColor({chosen style}, {color change}); -).

To apply (relative size change - a number) size-change to (chosen style - a glulx-style):
	(- SetSize({chosen style}, {relative size change}); -).

To apply (chosen boldness - a boldness) boldness to (chosen style - a glulx-style):
	(- BoldnessSet({chosen style}, {chosen boldness}); -).

To apply (indentation amount - a number) indentation to (chosen style - a glulx-style):
	(- Indent({chosen style}, {indentation amount}); -).

To apply (indentation amount - a number) first-line indentation to (chosen style - a glulx-style):
	(- ParaIndent({chosen style}, {indentation amount}); -).

To apply justification of (justify - a text-justification) to (chosen style - a glulx-style):
	(- Justification({chosen style}, {chosen style}); -).

To apply fixed-width-ness (chosen fixity - a fixity) to (chosen style - a glulx-style):
	(- FixitySet({chosen style}, {chosen fixity}); -).

To apply obliquity (chosen obliquity - an obliquity) to (chosen style - a glulx-style):
	(- Obliquify({chosen style}, {chosen obliquity}); -).

Include (-

[ SetColor S N;
	S--;
	glk_stylehint_set(wintype_TextBuffer, S, stylehint_TextColor, N); 
];

[ SetBackgroundColor S N;
	S--;
	glk_stylehint_set(wintype_TextBuffer, S, stylehint_BackColor, N);
];

[ FixitySet S N;
	N--;
	S--;
	glk_stylehint_set(wintype_TextBuffer, S, stylehint_Proportional, N); 
];

[ SetSize S N;
	S--;
	glk_stylehint_set(wintype_TextBuffer, S, stylehint_Size, N); 
];

[ BoldnessSet S N;
	N = N-2;
	S--;
	glk_stylehint_set(wintype_TextBuffer, S, stylehint_Weight, N); 
];

[ ParaIndent S N;
	S--;
	glk_stylehint_set(wintype_TextBuffer, S, stylehint_ParaIndentation, N); 
];

[ Indent S N;
	S--;
	glk_stylehint_set(wintype_TextBuffer, S, stylehint_Indentation, N); 
];

[ Justification N S;
	N--;
	S--;
	glk_stylehint_set(wintype_TextBuffer, S, stylehint_Justification, N); 
];

[ Obliquify S N;
	N--;
	S--;
	glk_stylehint_set(wintype_TextBuffer, S, stylehint_Oblique, N); 
];

-)

To say using (chosen style - a glulx-style):
	(-glk_set_style({chosen style}-1);-)

Glulx Text Styles ends here.

---- DOCUMENTATION ----

This is an expansion of Emily Short's Glulx Text Effects extension which allows the writer to use or manipulate any of the standard Glk styles. The tables and such work almost exactly as in Glulx Text Effects (so don't use them together), and this extension should be fully "backwards-compatible" with Glulx Text Effects code.

The styles are called normal style, italic style, preformatted style, header style, bold style, alert style, note style, block-quote style, input style, special-style-1, and special-style-2. (The last two are hyphenated to maintain compatibility.)

To invoke any of these styles, use the say phrase "using [style]". For example, "This text is [using bold style]bold[using normal style]!" would be equivalent to "This text is [bold type]bold[roman type]!" on the Z-machine.

The Inform style names match the Glk ones, with a few exceptions: the User1 and User2 styles are named as in Glulx Text Effects, and the Emphasized and Subheader styles are renamed to italic and bold (which is what Inform uses them for by default).

The one change to the table is the addition of the "glulx background color" column, which changes the background color of the specified style. On Gargoyle changing the color of the normal style changes the background color of the window, but this is non-standard behavior.
