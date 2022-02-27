Version 1/220227 of Text Box by Zed Lopez begins here.

"Flexible framework to define and display text boxes. For 6M62."

[ one last crucial thing: separate displaying boxes and dumping
  equivalents if overflow or overlap away from window handling stuff ]

[ center-aligned boxes should still think about margins ]

Include Version 15 of Flexible Windows by Jon Ingold.
Include Text Loops by Zed Lopez. 

[ this needs to be at top, 'cause I7 balks if default press any key is mentioned before defining ]
Part keyboard (for use without Key Input by Zed Lopez)

Default press any key is always "Press a key to continue [command prompt]".

To pause-the-game (this is pause-the-game-func):
  wait for any key;

Section Not basic (for use without Basic Screen Effects by Emily Short)

Include (-
[ getRelevantKey key;
  while((key = VM_KeyChar()) == -4 or -5 or -10 or -11 or -12 or -13) continue;
  return key;
];
-).

To wait for a/any/-- key: (- getRelevantKey(); -) 

volume main

Line-style-value is a kind of value.
The line-style-values are single-line-style, blank-line-style, double-line-style, heavy-line-style.

Orientation-value is a kind of value. The orientation-values are horizontal-value and vertical-value.

Position-value is a kind of value. The Position-values are top-value, right-value, bottom-value, left-value.

[ box-alignments other than center render the opposing margin irrelevant. If you're top-aligned, bottom margin doesn't matter, etc. ]
[ this is used for both line alignments and box alignments though top-align and bottom-align are meaningless for line alignments ]
alignment-value is a kind of value. The alignment-values are center-align, left-align, right-align, top-align, bottom-align.

A box-corner-value is a kind of value. The box-corner-values are top-left-corner,top-right-corner, bottom-left-corner, bottom-right-corner.

A box-status-value is a kind of value. The box-status-values are box-success, width-overflow-error, height-overflow-error, box-overlap-error.

[A box-wiggle-value is a kind of value. The box-wiggle-values are inflexible-wiggle, flexible-wiggle. [ more values anticipated ]]

A grid-loc is a kind of value. 999x999 specifies a grid-loc with parts x-pos and y-pos.

Box-padding-default is always { 1, 4, 1, 4 }.
Box-margin-default is always { 0, 1, 0, 1 }.

A text-box is a kind of object.
A text-box has a list of line-style-values called the line-styles.
A text-box has a list of unicode characters called the edge-glyphs.
A text-box has a list of unicode characters called the corner-glyphs.
A text-box has a list of numbers called the box-paddings.
The box-paddings of a text-box is usually box-padding-default.
A text-box has a list of numbers called the box-margins.
The box-margins of a text-box is usually box-margin-default.
A text-box has a text called the epigraph.
A text-box has a number called the tb-line-width.
A text-box has a number called the tb-width.
A text-box has a number called the tb-height.
A text-box has a list of texts called the box-text-lines.
A text-box has a list of texts called the tb-line-list.
A text-box has a list of alignment-values called the tb-alignment-list.
A text-box has a alignment-value called the horizontal-box-align.
A text-box has a alignment-value called the vertical-box-align.
A text-box has a box-status-value called the box-status.
A text-box can be unbordered or bordered.
A text-box has a list of numbers called the edge-locs.

An active text-box is a kind of text-box.
An active text-box has a phrase nothing -> nothing called the text-box-action.
The text-box-action of an active text-box is usually pause-the-game-func.

A borderless text-box is a kind of text-box.
A borderless text-box is usually unbordered.
The box-paddings of a borderless text-box is usually { 0, 0, 0, 0 }.
The box-margins of a borderless text-box is usually { 1, 2, 1, 2 }.

A box-layout is a kind of object.
A box-layout can be fleeting or persistent.
A box-layout has a list of text-boxes called the box-list.
A box-layout has a box-status-value called the layout-outcome.
A box-layout can be overlapping-allowed or overlapping-forbidden.

default-box-layout is a box-layout.

Prompt-box is a unbordered active text-box.
The horizontal-box-align of prompt-box is center-align.
The vertical-box-align of prompt-box is bottom-align.
The box-paddings of prompt-box is { 0, 1, 1, 0 }.
The box-margins of prompt-box is { 0, 0, 0, 0 }.
The epigraph of prompt-box is default press any key.

rounded-corners is always { 9581, 9582, 9584, 9583 }; [ top left, top right, lower left, lower right ]

To add (tb - a text-box) to (bl - a box-layout):
  add tb to the box-list of bl;

To set (tb - a text-box) position to (cv - a box-corner-value):
  if cv is top-left-corner or cv is top-right-corner, now the vertical-box-align of tb is top-align;
  if cv is bottom-left-corner or cv is bottom-right-corner, now the vertical-box-align of tb is bottom-align;
  if cv is top-left-corner or cv is bottom-left-corner, now the horizontal-box-align of tb is left-align;
  if cv is top-right-corner or cv is bottom-right-corner, now the horizontal-box-align of tb is right-align;

To decide what orientation-value is an/-- orientation of/-- a/an/-- (pv - a position-value):
  if pv is top-value or pv is bottom-value, decide on horizontal-value;
  decide on vertical-value.

To wipe (box - a text-box):
  now horizontal-box-align of box is center-align;
  now vertical-box-align of box is center-align;
  change line-styles of box to have 0 entries;
  change edge-glyphs of box to have 0 entries;
  now box-paddings of box is box-padding-default;
  now box-margins of box is box-margin-default;
  change corner-glyphs of box to have 0 entries;
  change tb-line-list of box to have 0 entries;
  change box-text-lines of box to have 0 entries;
  now the epigraph of box is "";
  now the tb-line-width of box is 0;
  now the tb-width of box is 0;
  now the tb-height of box is 0;
  change tb-alignment-list of box to have 0 entries;
  now box is bordered;
  truncate edge-locs of box to 0 entries;

To wipe (bl - a box-layout):
  truncate box-list of bl to 0 entries;
  now the layout-outcome of bl is box-success;
  now bl is fleeting;
    
To sanitize (box - a text-box):
  change line-styles of box to have 4 entries;
  if the number of entries in the edge-glyphs of box is not 4, set the edges for box;
  if the number of entries in the corner-glyphs of box is not 4, set the corners for box;
  if the number of entries in box-paddings of box is not 4, now the box-paddings of box is box-padding-default;
  if the number of entries in box-margins of box is not 4, now the box-margins of box is box-margin-default;
  truncate the box-text-lines of box to 0 entries;
  truncate the tb-line-list of box to 0 entries;
  truncate the tb-alignment-list of box to 0 entries;
  
To set the/-- line style of (box - a text-box) to (v - a line-style-value):
  change line-styles of box to have 0 entries;
  repeat with i running from 1 to 4 begin;
    add v to line-styles of box;
  end repeat.

unicode-plus is always unicode 43.
unicode-vertical-bar is always unicode 45.
unicode-dash is always unicode 166. 
ascii-corners is always { unicode-plus, unicode-plus, unicode-plus, unicode-plus }.
ascii-edges is always { unicode-vertical-bar, unicode-dash, unicode-vertical-bar, unicode-dash }.

To set the/a/an/-- (box - a text-box) to ascii:
  now the corner-glyphs of box is ascii-corners;
  now the edge-glyphs of box is ascii-edges;

To set the/-- corners of (box - a text-box) to rounded:
  now the corner-glyphs of box is num-to-char applied to rounded-corners;

To set the/-- vertical line style of (box - a text-box) to (v - a line-style-value):
  if the number of entries in the line-styles of box is not 4, set the line style of box to single-line-style;
  now entry right-value cast as a number in the line-styles of box is v;
  now entry left-value cast as a number in the line-styles of box is v;

To set the/-- horizontal line style of (box - a text-box) to (v - a line-style-value):
  if the number of entries in the line-styles of box is not 4, set the line style of box to single-line-style;
  now entry top-value cast as a number in the line-styles of box is v;
  now entry bottom-value cast as a number in the line-styles of box is v;

To decide what unicode character is a/an/-- (corner - a box-corner-value) corner of/for (box - a text-box):
  decide on entry (corner cast as a number) of corner-glyphs of box;

To decide what unicode character is a/an/-- (edge - a position-value) edge of/for (box - a text-box):
  decide on entry (edge cast as a number) of edge-glyphs of box;

To set the/-- edges for (box - a text-box):
  truncate the edge-glyphs of box to 0 entries;
  repeat with position running through the position-values begin;
    add the glyph for position of box to the edge-glyphs of box;
  end repeat;

To set the/-- corners for (box - a text-box):
  truncate the corner-glyphs of box to 0 entries;
  repeat with cv running through box-corner-values begin;
    add corner cv of box to the corner-glyphs of box;
  end repeat;

To decide what line-style-value is the style of/for (pv - a position-value) of/for (box - a text-box):
  decide on entry (pv cast as a number) in the line-styles of box.

To decide what unicode character is the glyph for (pv - a position-value) of (box - a text-box):
  let ov be the orientation of pv;
  let ls be the style of pv for box;
  if ls is blank-line-style, decide on 32 cast as a unicode character;
  let result be 9472;
  if ov is vertical-value, now result is result + 2;
  if ls is double-line-style begin;
    if ov is horizontal-value, now result is result + 80;
    else now result is result + 79;
  else;
    if ls is heavy-line-style, now result is result + 1;
  end if;
  decide on result cast as a unicode character;

To decide what position-value is the horizontal edge meeting (corner - a box-corner-value):
  if corner is top-left-corner or corner is top-right-corner, decide on top-value;
  decide on bottom-value.

To decide what position-value is the vertical edge meeting (corner - a box-corner-value):
  if corner is top-left-corner or corner is bottom-left-corner, decide on left-value;
  decide on right-value.

To decide what unicode character is corner (corner - a box-corner-value) of/for (box - a text-box):
  let h-pos be the horizontal edge meeting corner;
  let v-pos be the vertical edge meeting corner;
  let h-edge be the style of h-pos for box;
  let v-edge be the style of v-pos for box;
  let result be 9484;
  let corner-mod be 4;
  if h-edge is double-line-style or v-edge is double-line-style, now corner-mod is 3;
  now result is result + ((corner cast as a number - 1) * corner-mod);
  if h-edge is double-line-style and v-edge is double-line-style, decide on result + 72 cast as a unicode character;
  if h-edge is double-line-style, decide on result + 70 cast as a unicode character;
  if v-edge is double-line-style, decide on result + 71 cast as a unicode character;
  if h-edge is heavy-line-style, now result is result + 1;
  if v-edge is heavy-line-style, now result is result + 2;
  decide on result cast as a unicode character;

To display single box (box - a text-box) with (T - a text) on (w - a text grid g-window):
  now page-display-target is w;
  display single box box with T;  

To display single box (box - a text-box) with (T - a text):
  truncate box-list of default-box-layout to 0 entries;
  add box to default-box-layout;
  now the epigraph of box is T;
  carry out the page-displaying activity with default-box-layout.

To decide what grid-loc is the grid coordinate of (cv - a box-corner-value) of/for (tb - a text-box):
  let tx be 0;
  let ty be 0;
  if cv is top-left-corner or cv is top-right-corner, now ty is top-value edge-loc of tb;
  else now ty is bottom-value edge-loc of tb;
  if cv is top-left-corner or cv is bottom-left-corner, now tx is left-value edge-loc of tb;
  else now tx is right-value edge-loc of tb;
  decide on the grid-loc with x-pos part tx y-pos part ty.

To decide what number is the (pos - a position-value) edge-loc of (tb - a text-box):
  decide on entry pos cast as a number in the edge-locs of tb.

To set the (pos - a position-value) edge-loc of (tb - a text-box) to (n - a number):
    now entry pos cast as a number in the edge-locs of tb is n;

To decide what number is the (pos - a position-value) padding of (tb - a text-box):
  decide on entry pos cast as a number in the box-paddings of tb.

To set the (pos - a position-value) padding of (tb - a text-box) to (n - a number):
    now entry pos cast as a number in the box-paddings of tb is n;

To decide what number is the (pos - a position-value) margin of (tb - a text-box):
  decide on entry pos cast as a number in the box-margins of tb.

To set the (pos - a position-value) margin of (tb - a text-box) to (n - a number):
    now entry pos cast as a number in the box-margins of tb is n;

page-display-arg is a list of text-boxes that varies.
default-box-quote-window is a text grid g-window.
page-display-target is initially default-box-quote-window.

[ globals so they can be set in page-displaying and accessed by
  box-planning ]
page-display-target-height is initially 0.
page-display-target-width is initially 0.

Page-displaying something is an activity on a box-layout.
The page-displaying activity has a list of g-windows called the restore-list.
The page-displaying activity has a g-window scale method called the old-page-display-target-scale.
The page-displaying activity has a number called the old-page-display-target-measurement.

To display box-layout (bl - a box-layout):
  repeat with box running through box-list of the current box-layout begin;
    display text-box box;
  end repeat;

First before page-displaying (this is the setup windows before page-displaying rule):
  if the current box-layout is fleeting, add prompt-box to the box-list of the current box-layout;
  truncate restore-list to 0 entries;
  now page-display-target is spawned by the main window;
  now old-page-display-target-scale is the scale method of page-display-target;
  now old-page-display-target-measurement is the measurement of page-display-target;
  now the scale method of page-display-target is g-proportional;
  now the measurement of page-display-target is 100;
  repeat with w running through g-present g-windows begin;
    if w is not the main window, add w to restore-list;
  end repeat;
  [ we do it separately to avoid confusion stemming from changing the
  number of g-present g-windows during a loop over them ]
  repeat with w running through restore-list begin;
    close w;
  end repeat;
  open page-display-target, as the acting main window;
  now page-display-target-height is the height of page-display-target;
  now page-display-target-width is the width of page-display-target;

validate layout is a box-layout based rulebook producing a box-status-value.

First validate layout (this is the they're good boxes brent rule):
  repeat with box running through box-list of the current box-layout begin;
    carry out the box-planning activity with box;
  end repeat;
  let status be box-success;
  repeat with box running through box-list of the current box-layout begin;
    now status is the box-status of box;
    if status is not box-success, rule succeeds with result status;
  end repeat;

Validate layout an overlapping-forbidden box-layout (this is the forbid overlapping boxes rule):
  repeat with index running from 1 to the number of entries in the box-list of the current box-layout - 1 begin;
    repeat with inner-index running from index + 1 to the number of entries in the box-list of the current box-layout begin;
      if entry index in the box-list of the current box-layout overlaps entry inner-index in the box-list of the current box-layout, rule succeeds with result box-overlap-error;
    end repeat;
  end repeat;
  rule succeeds with result box-success;

To decide if (tb - a text-box) surrounds (g - a grid-loc):
  let gx be the x-pos part of g;
  let gy be the y-pos part of g;
  let left-edge-x be left-value edge-loc of tb;
  let right-edge-x be right-value edge-loc of tb;
  let top-edge-y be top-value edge-loc of tb;
  let bottom-edge-y be bottom-value edge-loc of tb;
  if tb is bordered begin;
    decrement left-edge-x;
    decrement top-edge-y;
    increment right-edge-x;
    increment bottom-edge-y;
  end if;
  if gx >= left-edge-x and gx <= right-edge-x and gy >= top-edge-y and gy <= bottom-edge-y, yes;
  no.

To decide if (b1 - a text-box) overlaps (b2 - a text-box):
  repeat with cv running through the box-corner-values begin;
    if b2 surrounds the grid coordinate of cv of b1, yes;
  end repeat;
  [they don't *intersect*, but b2 could be wholly within b1 ]
  repeat with cv running through the box-corner-values begin;
    if b1 surrounds the grid coordinate of cv of b2, yes;
  end repeat;
  no;

For page-displaying (this is the display good layout page-displaying rule):
  now the layout-outcome of the current box-layout is the box-status-value produced by the validate layout rules for the current box-layout;
  if the layout-outcome of the current box-layout is box-success, display box-layout current box-layout;

After page-displaying (this is the window cleanup after page-displaying rule):
  close page-display-target;
  now the scale method of page-display-target is old-page-display-target-scale;
  now the measurement of page-display-target is old-page-display-target-measurement;
  repeat with w running through restore-list begin;
    open w;
  end repeat;
  refresh all windows;
  refresh main window;

Last after page-displaying a box-layout (called layout) when the layout-outcome of layout is not box-success (this is the dump plain text after bad layout rule):
  [if the layout-outcome of the current box-layout is not box-success,]
  text-dump current box-layout;

To page-display (bl - a box-layout):
  carry out the page-displaying activity with bl;

[ TODO sort them ]
To text-dump (bl - a box-layout):
  repeat with box running through box-list of the current box-layout begin;
    if the box is prompt-box, next;
    repeat with line running through tb-line-list of box begin;
      say line;
      say line break;
    end repeat;
    say line break;
  end repeat;

To decide what grid-loc is the grid coordinate of/-- x (xpos - a number) and y (ypos - a number):
  decide on the grid-loc with x-pos part xpos y-pos part ypos.

To display text-box (tb - a text-box):
  let index be 0;
  let tx be left-value edge-loc of tb;
  let ty be top-value edge-loc of tb;
  repeat with line running through the box-text-lines of tb begin;
    put line at x tx and y ty + index;
    increment index;
  end repeat;
  if tb is an active text-box, apply text-box-action of tb.
  
Box-planning something is an activity on text-boxes.

To decide what text-box is the/-- current box: (- parameter_value -).
To decide what box-layout is the/-- current box-layout: (- parameter_value -).

Before box-planning (this is the prep boxes before box-planning rule):
  sanitize the current box;
  let len be 0;
  let tb-text-alignment be a alignment-value;
  repeat for p in paragraphs of epigraph of current box with index i begin;
    unless i is 1 begin;
      add "" to tb-line-list of current box;
      add left-align to tb-alignment-list of current box;
    end unless;
    repeat for line in lines of p begin;
      if line matches the regular expression "^\<(<LCR>)\>\s*", case insensitively begin;
        let alignment-initial be the substituted form of the text matching subexpression 1 in lower case;
        replace the text text matching regular expression in line with "";
        if alignment-initial is "l", now tb-text-alignment is left-align;
        if alignment-initial is "c", now tb-text-alignment is center-align;
        if alignment-initial is "r", now tb-text-alignment is right-align;
        end if;
      if number of characters in line > len, now len is number of characters in line;
      add line to tb-line-list of current box;
      add tb-text-alignment to tb-alignment-list of current box;
    end repeat;
  end repeat;
  now the tb-line-width of the current box is len;
  now the tb-height of the current box is the number of entries in tb-line-list of current box;
  if the tb-line-width of the current box > the page-display-target-width, now the box-status of the current box is width-overflow-error;
  if the tb-height of the current box > the page-display-target-height, now the box-status of the current box is height-overflow-error;

For box-planning (this is the set parameters box-planning rule):
  if the box-status of the current box is box-success begin;
    let border-character-width be 2;
    if the current box is unbordered, now border-character-width is 0;
    let first-row be 0;
    let first-column be 0;
    now the tb-width of the current box is the tb-line-width of the current box;
    now the tb-width of the current box is tb-width of the current box + (the left-value padding of current box) + (the right-value padding of current box);
    now the tb-height of the current box is the tb-height of current box + (the top-value padding of current box) + (the bottom-value padding of current box);
    if the tb-width of the current box > the page-display-target-width, now the box-status of the current box is width-overflow-error;
    if the tb-height of the current box > the page-display-target-height, now the box-status of the current box is height-overflow-error;
    if the horizontal-box-align of the current box is center-align begin;
      now first-column is (the page-display-target-width - (tb-width of the current box + border-character-width)) / 2;
    else;
     if the horizontal-box-align of the current box is right-align, now first-column is the page-display-target-width - (tb-width of the current box + the right-value margin of the current box + (border-character-width / 2));
     else now first-column is 1 + the left-value margin of the current box;
    end if;
    if the vertical-box-align of the current box is center-align begin;
      now first-row is (page-display-target-height - (tb-height of the current box + border-character-width)) / 2;
    else;
      if the vertical-box-align of the current box is bottom-align, now first-row is 1 + the page-display-target-height - (tb-height of the current box + the bottom-value margin of the current box + border-character-width);
      else now first-row is 1 + the top-value margin of the current box;
    end if;
    change edge-locs of the current box to have 0 entries;
    add first-row to edge-locs of the current box; [top]
    add first-column + tb-width of the current box to edge-locs of the current box; [right]
    add first-row + tb-height of the current box to edge-locs of the current box; [bottom]
    add first-column to edge-locs of the current box; [left]
  end if;

After box-planning (this is the finish building boxes after box-planning rule):
  if the box-status of the current box is box-success begin;
    if the current box is bordered begin;
      add top-border to current box;
      add top-value spacers to current box;
    end if;
    load contents into current box;
    if the current box is bordered begin;
      add bottom-value spacers to current box;
      add bottom-border to current box;
    end if;
  end if;

To add top-border to (tb - a text-box):
  let result be "[(top-value edge of tb) * tb-width of tb]";
  if tb is bordered, now result is "[top-left-corner corner of tb][result][top-right-corner corner of tb]";
  add result to the box-text-lines of tb;

To add bottom-border to (tb - a text-box):
  let result be "[(bottom-value edge of tb) * tb-width of tb]";
  if tb is bordered, now result is "[bottom-left-corner corner of tb][result][bottom-right-corner corner of tb]";
  add result to the box-text-lines of tb;

To load contents into (tb - a text-box):
  let index be 0;
  repeat with line running through tb-line-list of tb begin;
    increment index;
    let align be entry index in the tb-alignment-list of tb;
    let left-space-count be 0;
    let right-space-count be 0;
    now left-space-count is left-value padding of tb;
    now right-space-count is right-value padding of tb;
    if align is left-align begin;
      now right-space-count is right-value padding of tb + tb-line-width of tb - (number of characters in line);
    end if;
    if align is right-align begin;
      now left-space-count is left-value padding of tb + (tb-line-width of tb - (number of characters in line));
    end if;
    if align is center-align begin;
      let diff be tb-line-width of tb - (number of characters in line);
      let half be (diff / 2);
      now left-space-count is left-value padding of tb + half;
      now right-space-count is right-value padding of tb + half + the remainder after dividing diff by 2;
    end if;
    let result be "[unicode-space * left-space-count][line][unicode-space * right-space-count]";
    if tb is bordered, now result is "[left-value edge of tb][result][right-value edge of tb]";
    add result to box-text-lines of tb;
  end repeat;

To add (pos - a position-value) spacers to (tb - a text-box):
  repeat with i running from 1 to (the pos padding of tb) begin;
    add "[left-value edge of tb][unicode-space * tb-width of tb][right-value edge of tb]" to box-text-lines of tb;
  end repeat;

Part grid (for use without Text Griddle by Zed Lopez)

To put (t - a text) at x (col - a number) and/-- y (row - a number):
  put t at x col and y row of acting main window.

To put (t - a text) at x (col - a number) and/-- y (row - a number) of (win - a g-window): 
(- glk_window_move_cursor({win}.(+ ref number +), {col} - 1, {row} - 1); TEXT_TY_Say({t}); -).

Part char (for use without Char by Zed Lopez)

unicode-space is a unicode character that varies. [ defaults to unicode 32, a space. ]

To decide what unicode character is wrapped char (N - a number) (this is num-to-char):
  decide on N cast as a unicode character.

Section n copies z (for z-machine only)

To say (U - a unicode character) * (N - a number):     (- for ({-my:1} = 0 : {-my:1} < {N} : {-my:1}++ ) print (char) {U}; -)

section n copies g (for glulx only)

To say (u - a unicode character) * (n - a number): (- {-my:2} = {u}; for ({-my:1} = 0 : {-my:1} < {N} : {-my:1}++ )  @streamunichar {-my:2}; -).

Part casting (for use without Central Typecasting by Zed Lopez)

To decide what K is a/an/-- (unknown - a value) cast as a/an/-- (name of kind of value K): (- {unknown} -).

To decide what K is a/-- null (name of kind of value K): (- nothing -)

Text box ends here.

---- Documentation ----

Chapter Examples

Example: * Box demo

	*: "Text Box" by Zed Lopez
	
	Include Text Box by Zed Lopez.
	Include Custom Banner and Version by Zed Lopez.
	
	Lab is a room.
	
	The display banner rule is not listed in any rulebook.
	
	i7-credit-box is a borderless text-box.
	banner-box is a text-box.
	quote-box is a text-box.
	chapter-box is a borderless text-box.
	The epigraph of chapter-box is "Chapter [chapter-number]".
	chapter-number is initially 0.
	
	layout is a fleeting box-layout.
	
	The story headline is "An extension demonstration".
	
	when play begins:
	  set corners of banner-box to rounded;
	  now epigraph of banner-box is "<c>[Story title][line break][line break][story headline] by [story author]";
	  add banner-box to layout;
	  now epigraph of i7-credit-box is "<R>[I7 name-version][line break][I6T name-version][line break][I6 name-version]";
	  set i7-credit-box position to top-right-corner;
	  add i7-credit-box to layout;
	  carry out the page-displaying activity with layout;
	
	Instead of jumping:
	  wipe layout;
	  let title quote be
	  "<c>Through the Looking-Glass[line break]
	  [line break]
	  by[line break]
	  [line break]
	  Charles Dodgson[line break]
	  [line break]
	  <L>'And the wabe is the grass-plot round,[line break]
	  a sun-dial, I suppose?' said Alice,[line break]
	  surprised at her own ingenuity.[line break]
	  [line break]
	  'Of course it is. It[']s called wabe,[line break]
	  you know, because it goes a long way,[line break]
	  before it, and a long way behind it.'[line break]
	  [line break]
	  <R>-- 1871";
	  set line style of quote-box to double-line-style;
	  now the epigraph of quote-box is title quote;
	  add quote-box to layout;
	  now chapter-number is 3;
	  set chapter-box position to top-left-corner;
	  add chapter-box to layout;
	  carry out the page-displaying activity with layout;
	  try looking;
	
