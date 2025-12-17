Version 6.0.0 of Glulx Text Effects (for Glulx only) by Emily Short begins here.

"Gives control over text formatting in Glulx."

[ Version 6 is rewritten for Inform 11, and uses many new features. But for compatibility reasons the naming of things has been, as much as possible, left as it was. This means we have both the US and Commonwealth spelling of color/colour, and we refer to "Glulx" styles rather than Glk styles, as they more accurately should be called. ]

Use authorial modesty.

Chapter - Extra windows

[ We define these windows so that stylehints can be specified for one or both kind of text window. ]

All-windows is a glk window.
All-buffer-windows is a glk window.
All-grid-windows is a glk window.

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

Before starting the virtual machine (this is the sort of the Table of User Styles rule):
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

Chapter - Apply the styles - unindexed

[ We're planning ahead here, for the benefit of Flexible Windows. ]

The apply the Glulx Text Effects styles rule is listed instead of the set default stylehints rule in the before starting the virtual machine rules.
Before starting the virtual machine (this is the apply the Glulx Text Effects styles rule):
	apply styles for the not a glk window;

To decide which glk window is the not a glk window: (- (nothing) -).

To apply styles for (W - glk window):
	repeat through the Table of User Styles:
		let window be the window entry;
		let window type be a number;
		if window is all-windows:
			now window type is 0;
		otherwise if window is all-buffer-windows:
			if W is not nothing and the window type of W is not text buffer window type:
				next;
			now window type is 3;
		otherwise if window is all-grid-windows:
			if W is not nothing and the window type of W is not text grid window type:
				next;
			now window type is 4;
		otherwise:
			if W is nothing or window is not W:
				next;
			if the window type of W is text buffer window type:
				now window type is 3;
			otherwise:
				now window type is 4;
		if there is a background color entry:
			apply window type style (style name entry) stylehint 8 of (background color entry);
		if there is a color entry:
			apply window type style (style name entry) stylehint 7 of (color entry);
		if there is a first line indentation entry:
			apply window type style (style name entry) stylehint 1 of (first line indentation entry);
		if there is a fixed width entry:
			let proportional be 1;
			if the fixed width entry is true:
				now proportional is 0;
			apply window type style (style name entry) stylehint 6 of (proportional);
		if there is a font weight entry:
			apply window type style (style name entry) stylehint 4 of (font weight entry);
		if there is a indentation entry:
			apply window type style (style name entry) stylehint 0 of (indentation entry);
		if there is a italic entry:
			apply window type style (style name entry) stylehint 5 of (italic entry);
		if there is a justification entry:
			apply window type style (style name entry) stylehint 2 of (justification entry);
		if there is a relative size entry:
			apply window type style (style name entry) stylehint 3 of (relative size entry);
		if there is a reversed entry:
			apply window type style (style name entry) stylehint 9 of (reversed entry);

To apply (W - a number) style (S - a glulx text style) stylehint (H - a number) of (V - a value):
	(- GTE_Apply_Stylehint({W}, {S}, {H}, {V}); -).

Include (-
[ GTE_Apply_Stylehint wintype stylenum hint value i;
	if (stylenum == style_All) {
		for (i = 0: i < style_NUMSTYLES : i++) {
			glk_stylehint_set(wintype, i, hint, value);
		}
	}
	else {
		glk_stylehint_set(wintype, stylenum, hint, value);
	}
];
-).

Chapter - Additional style phrases

To say alert style:
	(- glk_set_style(style_Alert); -).

To say blockquote style:
	(- glk_set_style(style_BlockQuote); -).

To say header style:
	(- glk_set_style(style_Header); -).

To say input style:
	(- glk_set_style(style_Input); -).

To say note style:
	(- glk_set_style(style_Note); -).

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

Glulx Text Effects ends here.
