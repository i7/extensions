Version 6.1.0 of Glulx Text Effects (for Glulx only) by Emily Short begins here.

"Gives control over text formatting in Glulx."

[ Version 6 is rewritten for Inform 11, and uses many new features. But for compatibility reasons the naming of things has been, as much as possible, left as it was. This means we have both the US and Commonwealth spelling of color/colour, and we refer to "Glulx" styles rather than Glk styles, as they more accurately should be called. ]

Use authorial modesty.

Chapter - Extra styles feature

Extra styles feature is a glk feature.
The extra styles feature value is accessible to Inter as "gestalt_ExtraStyles_FAKE".

The cache the extra styles gestalt rule is listed in the reset glk references rules.
The cache the extra styles gestalt rule translates into Inter as "CACHE_EXTRA_STYLES_GESTALT_R".

Definition: a glulx text style is custom defined if it is greater than special-style-2.

Chapter - Extra windows

[ We define these windows so that stylehints can be specified for one or both kind of text window. ]

All-windows is a glk window.
All-buffer-windows is a text buffer window.
All-grid-windows is a text grid window.

Chapter - The Table of User Styles definition

Table of User Styles
window (a glk window)	style name (a glulx text style)	background color (an RGB colour)	color (an RGB colour)	first line indentation (a number)	fixed width (a truth state)	font weight (a font weight)	indentation (a number)	italic (a truth state)	justification (a text justification)	relative size (a number)	reversed (a truth state)
with 1 blank row

Chapter - Default styles

Table of User Styles (continued)
window	style name	font weight	italic	justification	reversed
all-grid-windows	all-styles	--	--	--	true
all-buffer-windows	header-style	--	--	left-justified
all-buffer-windows	italic-style	regular-weight	true

Chapter - Sorting the Table of User Styles - unindexed

Before starting the virtual machine (this is the sort the Table of User Styles rule):
	now the window type of all-windows is the all-windows-type;
	[ First change empty windows to all buffer windows, and empty style names to all-styles ]
	repeat through the Table of User Styles:
		if there is no window entry:
			now the window entry is all-buffer-windows;
		if there is no style name entry:
			now the style name entry is all-styles;
	[ Now sort with the following algorithm ]
	sort the Table of User Styles with the table of user styles ranking;

To decide which number is the table ranking of (T - table name) rows (X - a number) and (Y - a number) (this is the table of user styles ranking):
	let window x be the window in row X of T;
	let window y be the window in row y of T;
	[ Sort the all-*-windows rows before window specific rows ]
	if window x is not window y:
		if window y is all-windows:
			decide on 1;
		if window x is all-windows:
			decide on -1;
		if (window y is all-buffer-windows or window y is all-grid-windows) and window x is not all-buffer-windows and window x is not all-grid-windows:
			decide on 1;
		if (window x is all-buffer-windows or window x is all-grid-windows) and window y is not all-buffer-windows and window y is not all-grid-windows:
			decide on -1;
	[ Sort styles in ascending order, so that all-styles comes first ]
	decide on (numerical value of style name in row X of T) - (numerical value of style name in row Y of T);

To decide which glk window type is all-windows-type:
	(- wintype_AllTypes -).

Chapter - Apply the styles - unindexed

[ We're planning ahead here, for the benefit of Flexible Windows. ]

To apply styles for (W - glk window):
	repeat through the Table of User Styles:
		let window be the window entry;
		if window is all-buffer-windows:
			if W is not nothing and the window type of W is not text buffer window type:
				next;
		otherwise if window is all-grid-windows:
			if W is not nothing and the window type of W is not text grid window type:
				next;
		otherwise if window is not all-windows:
			if W is nothing or window is not W:
				next;
		let style be the style name entry;
		if the extra styles feature is unsupported and style is custom defined:
			next;
		if there is a background color entry:
			apply (window) style (style) stylehint 8 of (background color entry);
		if there is a color entry:
			apply (window) style (style) stylehint 7 of (color entry);
		if there is a first line indentation entry:
			apply (window) style (style) stylehint 1 of (first line indentation entry);
		if there is a fixed width entry:
			let proportional be 1;
			if the fixed width entry is true:
				now proportional is 0;
			apply (window) style (style) stylehint 6 of (proportional);
		if there is a font weight entry:
			apply (window) style (style) stylehint 4 of (font weight entry);
		if there is a indentation entry:
			apply (window) style (style) stylehint 0 of (indentation entry);
		if there is a italic entry:
			apply (window) style (style) stylehint 5 of (italic entry);
		if there is a justification entry:
			apply (window) style (style) stylehint 2 of (justification entry);
		if there is a relative size entry:
			apply (window) style (style) stylehint 3 of (relative size entry);
		if there is a reversed entry:
			apply (window) style (style) stylehint 9 of (reversed entry);

To apply (W - a glk window) style (S - a glulx text style) stylehint (H - a number) of (V - a value):
	(- GTE_Apply_Stylehint({W}.glk_window_type, {S}, {H}, {V}); -).

To decide which glk window is the not a glk window: (- (nothing) -).

Section - Rule for applying styles

[ Put this rule in a section by itself so that FW can replace it. ]

The apply the Glulx Text Effects styles rule is listed instead of the set default stylehints rule in the before starting the virtual machine rules.
Before starting the virtual machine (this is the apply the Glulx Text Effects styles rule):
	apply styles for the not a glk window;

Chapter - Additional style phrases

To say alert style:
	(- glk_set_style(style_Alert); -).

To say blockquote style:
	(- glk_set_style(style_BlockQuote); -).

To say emphasised style:
	(- glk_set_style(style_Emphasized); -).

To say header style:
	(- glk_set_style(style_Header); -).

To say input style:
	(- glk_set_style(style_Input); -).

To say normal style:
	(- glk_set_style(style_Normal); -).

To say note style:
	(- glk_set_style(style_Note); -).

To say preformatted style:
	(- glk_set_style(style_Preformatted); -).

To say subheader style:
	(- glk_set_style(style_Subheader); -).

To say special-style-1:
	(- glk_set_style(style_User1); -).
To say special/custom/user style 1:
	(- glk_set_style(style_User1); -).
To say first special/custom/user style:
	(- glk_set_style(style_User1); -).

To say special-style-2:
	(- glk_set_style(style_User2); -).
To say special/custom/user style 2:
	(- glk_set_style(style_User2); -).
To say second special/custom/user style:
	(- glk_set_style(style_User2); -).

To say (style - a glulx text style) letters:
	(- glk_set_style({style}); -).

Glulx Text Effects ends here.