Version 2/220301 of Text Box by Zed Lopez begins here.

"Flexible framework to define and display text boxes. For 6M62."

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
[ there's no blank-line-style: use an unbordered box with padding of at least { 1, 1, 1, 1 } for
  the same effect ]
The line-style-values are single-line-style, double-line-style, heavy-line-style.

[ box-alignments other than center render the opposing margin irrelevant. If you're top-aligned, bottom margin doesn't matter, etc. ]
[ this is used for both line alignments and box alignments though top-align and bottom-align are meaningless for line alignments ]
Alignment-value is a kind of value. The alignment-values are center-align, left-align, right-align, top-align, bottom-align.

Extent-value is a kind of value. The extent-values are tb-none, tb-text, tb-padded, tb-bordered, tb-external.

Position-value is a kind of value. The Position-values are top-value, right-value, bottom-value, left-value. 

A box-corner-value is a kind of value. The box-corner-values are top-left-corner,top-right-corner, bottom-left-corner, bottom-right-corner.

A box-status-value is a kind of value. The box-status-values are box-success, overflow-error, box-overlap-error, box-invalid-error.

The default-box-paddings are always { 0, 0, 0, 0 }.
The default-box-margins are always { 1, 2, 1, 2 }.
A text-box is a kind of object.
A text-box has a list of numbers called the box-paddings.
A text-box has a list of numbers called the box-margins.
The box-paddings of a text-box is usually the default-box-paddings.
The box-margins of a text-box is usually the default-box-margins.
A text-box has a text called the epigraph.
A text-box has a number called the tb-text-width.
A text-box has a list of texts called the tb-line-list.
A text-box has a alignment-value called the horizontal-box-align.
A text-box has a alignment-value called the vertical-box-align.
A text-box has a box-status-value called the box-status.
A text-box can be currently-displayed.
A text-box has a number called the border size.
A text-box has a number called the first-row.
A text-box has a number called the first-column.

To decide what number is the direction-modifier of/for (pv - a position-value):
  if pv is top-value or pv is left-value, decide on -1;
  decide on 1.

To decide what number is the (pv - position-value) edge of/for (ev - extent-value) of (tb - a text-box):
  let result be 0;
  if ev is tb-none, decide on result;
  if pv is left-value, now result is first-column of tb;
  if pv is right-value, now result is first-column of tb + tb-text-width of tb - 1;
  if pv is top-value, now result is first-row of tb;
  if pv is bottom-value, now result is first-row of tb + number of entries in tb-line-list of tb - 1;
  if ev is tb-text, decide on result;
  let modifier be 0;
  if ev >= tb-padded, now modifier is modifier + pv padding of tb;
  if ev >= tb-bordered, now modifier is modifier + border size of tb;
  if ev is tb-external, now modifier is modifier + pv margin of tb;
  decide on result + (direction-modifier of pv * modifier);

To decide what number is the (ev - extent-value) height of (tb - a text-box):
  if ev is tb-none, decide on 0;
  let result be the number of entries in tb-line-list of tb;
  if ev is tb-padded, now result is result + top-value padding of tb + bottom-value padding of tb;
  if ev is tb-bordered, now result is result + (border size of tb * 2);
  if ev is tb-external, now result is result + top-value margin of tb + bottom-value margin of tb;
  decide on result;

To decide what number is the (ev - extent-value) width of (tb - a text-box):
  if ev is tb-none, decide on 0;
  let result be the tb-text-width of tb;
  if ev is tb-padded, now result is result + left-value padding of tb + right-value padding of tb;
  if ev is tb-bordered, now result is result + (border size of tb * 2);
  if ev is tb-external, now result is result + left-value margin of tb + right-value margin of tb;
  decide on result;

An active text-box is a kind of text-box.
An active text-box has a phrase nothing -> nothing called the text-box-action.
The text-box-action of an active text-box is usually pause-the-game-func.

Lined-box-padding-default is always { 1, 4, 1, 4 }.
Lined-box-margin-default is always { 0, 1, 0, 1 }.

The default-line-styles is always { single-line-style, single-line-style, single-line-style, single-line-style }.
A bordered text-box is a kind of text-box.
A bordered text-box has a list of line-style-values called the line-styles.
The line-styles of a bordered text-box are usually the default-line-styles.
A bordered text-box has a list of unicode characters called the edge-glyphs.
A bordered text-box has a list of unicode characters called the corner-glyphs.
The box-paddings of a bordered text-box is usually lined-box-padding-default.
The box-margins of a bordered text-box is usually lined-box-margin-default.
The border size of a bordered text-box is usually 1.

Definition: a text-box is unbordered if it is not a bordered text-box.

A box-layout is a kind of object.
A box-layout can be fleeting or persistent.
A box-layout has a list of text-boxes called the box-list.
A box-layout has a box-status-value called the layout-outcome.
A box-layout has an extent-value called the layout-strictness.
[ by default, margins can overlap without complaint. set to tb-external to forbid that ]
The layout-strictness of a box-layout is usually tb-bordered.

default-text-box is a bordered text-box.
default-box-layout is a box-layout.

Prompt-box is an active text-box.
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

To wipe (box - a text-box):
  now horizontal-box-align of box is center-align;
  now vertical-box-align of box is center-align;
  change tb-line-list of box to have 0 entries;
  now the epigraph of box is "";
  now the tb-text-width of box is 0;
  if box is a bordered text-box begin;
    truncate corner-glyphs of box to 0 entries;
    truncate edge-glyphs of box to 0 entries;
    now the line-styles of box are the default-line-styles;
    now the box-paddings of box are lined-box-padding-default;
    now the box-margins of box are lined-box-margin-default;
  else;
    now the box-paddings of box are default-box-paddings;
    now the box-margins of box are default-box-margins;
  end if;

To wipe (bl - a box-layout):
  truncate box-list of bl to 0 entries;
  now the layout-outcome of bl is box-success;
  now bl is fleeting;
    
To sanitize (box - a text-box):
  if box is a bordered text-box begin;
    if the number of entries in the edge-glyphs of box is not 4, set the edges for box;
    if the number of entries in the corner-glyphs of box is not 4, set the corners for box;
  end if;
  truncate the tb-line-list of box to 0 entries;
  
To set the/-- line style of/for a/an/-- (box - a text-box) to a/an/-- (v - a line-style-value):
  repeat with i running from 1 to 4 begin;
    now entry i in line-styles of box is v;
  end repeat.

unicode-plus is always unicode 43.
unicode-vertical-bar is always unicode 45.
unicode-dash is always unicode 166. 
ascii-corners is always { unicode-plus, unicode-plus, unicode-plus, unicode-plus }.
ascii-edges is always { unicode-vertical-bar, unicode-dash, unicode-vertical-bar, unicode-dash }.

To set the/a/an/-- (box - a text-box) to ascii:
  now the corner-glyphs of box is ascii-corners;
  now the edge-glyphs of box is ascii-edges;

To set the/-- corners of (box - a bordered text-box) to rounded:
  now the corner-glyphs of box is num-to-char applied to rounded-corners;

To set the/-- vertical line style of (box - a bordered text-box) to (v - a line-style-value):
  now entry right-value cast as a number in the line-styles of box is v;
  now entry left-value cast as a number in the line-styles of box is v;

To set the/-- horizontal line style of (box - a text-box) to (v - a line-style-value):
  now entry top-value cast as a number in the line-styles of box is v;
  now entry bottom-value cast as a number in the line-styles of box is v;

To decide what line-style-value is the line style of/for (pv - a position-value) of/for (box - a text-box):
  decide on entry (pv cast as a number) in the line-styles of box.

To set a/an/the/-- (pv - a position-value) line style of/for a/an/--  of/for a/an/-- (box - a text-box) to (v - a line-style-value):
  now entry (pv cast as a number) in the line-styles of box is v.

To decide what unicode character is a/an/-- (corner - a box-corner-value) corner of/for (box - a bordered text-box):
  decide on entry (corner cast as a number) of corner-glyphs of box;

To decide what unicode character is a/an/-- (edge - a position-value) edge-glyph of/for (box - a bordered text-box):
  decide on entry (edge cast as a number) of edge-glyphs of box;

To set the/-- edges for (box - a bordered text-box):
  truncate the edge-glyphs of box to 0 entries;
  repeat with position running through the position-values begin;
    add the glyph for position of box to the edge-glyphs of box;
  end repeat;

To set the/-- corners for (box - a bordered text-box):
  truncate the corner-glyphs of box to 0 entries;
  repeat with cv running through box-corner-values begin;
    add corner cv of box to the corner-glyphs of box;
  end repeat;

To decide what unicode character is the glyph for (pv - a position-value) of (box - a text-box):
  let ls be the line style of pv for box;
  let result be 9472;
  if pv is left-value or pv is right-value, now result is result + 2;
  if ls is double-line-style begin;
    if pv is top-value or pv is bottom-value, now result is result + 80;
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
  let h-edge be the line style of h-pos for box;
  let v-edge be the line style of v-pos for box;
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

To display text box with (T - a text):
  wipe default-text-box;
  display single box default-text-box with T;

To display single box (box - a text-box) with (T - a text) on (w - a text grid g-window):
  now page-display-target is w;
  display single box box with T;  

To display single box (box - a text-box) with (T - a text):
  wipe default-box-layout;
  add box to default-box-layout;
  now the epigraph of box is T;
  carry out the page-displaying activity with default-box-layout.

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
  repeat with box running through box-list of bl begin;
    unless box is currently-displayed, follow the box-displaying rules for box;
  end repeat;

First before page-displaying a box-layout (called bl) (this is the setup windows before page-displaying rule):
  if the bl is fleeting, add prompt-box to the box-list of the bl;
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
  now the layout-outcome of the bl is the box-status-value produced by the validate layout rules for the bl;

Validate layout is a box-layout based rulebook producing a box-status-value.

First validate layout a box-layout (called bl) (this is the they're good boxes brent rule):
  repeat with box running through box-list of the bl begin;
    carry out the box-planning activity with box;
  end repeat;
  let status be box-success;
  repeat with box running through box-list of the bl begin;
    now status is the box-status of box;
    if status is not box-success, rule succeeds with result status;
  end repeat;
  repeat with index running from 1 to the number of entries in the box-list of the bl - 1 begin;
    repeat with inner-index running from index + 1 to the number of entries in the box-list of the bl begin;
      if entry index in the box-list of the bl intersects entry inner-index in the box-list of the bl by the layout-strictness of bl, rule succeeds with result box-overlap-error;
    end repeat;
  end repeat;
  rule succeeds with result box-success;
  
To decide if the/-- (tb - a text-box) intersects (x - a number) and (y - a number) by (ev - an extent-value):
  if x >= left-value edge of ev of tb and x <= right-value edge of ev of tb and y >= top-value edge of ev of tb and y <= bottom-value edge of ev of tb, yes;
  no.

To decide if (b1 - a text-box) intersects (b2 - a text-box) by (ev - an extent-value):
  repeat with cv running through the box-corner-values begin;
    if b2 intersects ((the vertical edge meeting cv) edge for ev of b1) and ((the horizontal edge meeting cv) edge for ev of b1) by ev, yes;
  end repeat;
  [ still possible that they don't intersect because b2 is entirely within the bounds of b1, so we check one corner the other way ]
  if b1 intersects the bottom-value edge of ev of b2 and the right-value edge of ev of b2 by ev, yes;
  no.

For page-displaying a box-layout (called bl) (this is the display good layout page-displaying rule):
  if the layout-outcome of the bl is box-success, display box-layout bl;

After page-displaying a box-layout (called bl) (this is the window cleanup after page-displaying rule):
  repeat with box running through the box-list of bl begin;
    now box is not currently-displayed;
  end repeat;
  close page-display-target;
  now the scale method of page-display-target is old-page-display-target-scale;
  now the measurement of page-display-target is old-page-display-target-measurement;
  repeat with w running through restore-list begin;
    open w;
  end repeat;
  refresh all windows;
  refresh main window;

Last after page-displaying a box-layout (called bl) when the layout-outcome of bl is not box-success (this is the dump plain text after bad layout rule):
  text-dump bl;

To page-display (bl - a box-layout):
  carry out the page-displaying activity with bl;

[ TODO sort them ]
To text-dump (bl - a box-layout):
  repeat with box running through box-list of bl begin;
    if the box is prompt-box, next;
    repeat with line running through tb-line-list of box begin;
      say line;
      say line break;
    end repeat;
    say line break;
  end repeat;

Box-displaying is a text-box based rulebook.

First box-displaying a bordered text-box (called tb):
  let ty be first-row of tb - (border size of tb + top-value padding of tb);
  let tx be first-column of tb - (border size of tb + left-value padding of tb);
  put "[top-left-corner corner of tb][(top-value edge-glyph of tb) * tb-padded width of tb][top-right-corner corner of tb]" at x tx and y ty;
  repeat with i running from 1 to top-value padding of tb begin;
    put text line "" for tb at x tx and y (ty + i);
  end repeat;

Box-displaying a text-box (called tb):
  let tx be first-column of tb;
  if tb is a bordered text-box, now tx is tx - (border size of tb + left-value padding of tb);
  let index be 0;
  repeat with line running through tb-line-list of tb begin;
    put text line line for tb at x tx and y first-row of tb + index;
    increment index;
  end repeat;
  now tb is currently-displayed;

Last box-displaying a bordered text-box (called tb):
  let ty be first-row of tb + tb-text height of tb - 1;
  let tx be first-column of tb - (border size of tb + left-value padding of tb);
  repeat with i running from 1 to bottom-value padding of tb begin;
    put text line "" for tb at x tx and y (ty + i);
  end repeat;
  put "[bottom-left-corner corner of tb][(bottom-value edge-glyph of tb) * tb-padded width of tb][bottom-right-corner corner of tb]" at x tx and y (ty + bottom-value padding of tb + 1);

Last box-displaying a text-box (called tb) when tb is an active text-box:
   apply text-box-action of tb.

Box-planning something is an activity on text-boxes.

First before box-planning a text-box (called tb) (this is the prep boxes before box-planning rule):
  sanitize tb;
  let widest-line-length be 0;
  let tb-text-alignment be an alignment-value;
  let temp-alignment-list be a list of alignment-values;
  let temp-lines be a list of texts;
  repeat for p in paragraphs of epigraph of tb with index i begin;
    unless i is 1 begin; [ insert a blank link before new paragraphs (but not before the first paragraph) ]
      add "" to temp-lines;
      add left-align to temp-alignment-list;
    end unless;
    repeat for line in lines of p begin; [ as a side effect of loop, lines have left and right whitespace trimmed ]
      if line matches the regular expression "^\<(<LCR>)\>\s*", case insensitively begin;
        let alignment-initial be the substituted form of the text matching subexpression 1 in lower case;
        replace the text text matching regular expression in line with "";
        if alignment-initial is "l", now tb-text-alignment is left-align;
        if alignment-initial is "c", now tb-text-alignment is center-align;
        if alignment-initial is "r", now tb-text-alignment is right-align;
        end if;
      if number of characters in line > widest-line-length, now widest-line-length is number of characters in line;
        add line to temp-lines;
      add tb-text-alignment to temp-alignment-list;
    end repeat;
    end repeat;
    now the tb-text-width of tb is widest-line-length;
    let i be 0;
    [ we make every line the width of the widest-line-length, padding appropriately per the relevant text alignment ]
    repeat with line running through temp-lines begin;
      increment i;
      if entry i in temp-alignment-list is center-align begin;
        let x be (widest-line-length - number of characters in line) / 2;
        add "[unicode-space * x][line][unicode-space * x]" to tb-line-list of tb;
        next;
      end if;
      if entry i in temp-alignment-list is left-align, add "[line][unicode-space * (widest-line-length - number of characters in line)]" to tb-line-list of tb;
      else add "[unicode-space * (widest-line-length - number of characters in line)][line]" to tb-line-list of tb; [ right-align ]
    end repeat;

For box-planning a text-box (called tb) (this is the set parameters box-planning rule):
  if the horizontal-box-align of tb is center-align, now first-column is ((the left-value margin of tb) + (the border size of tb) + (the left-value padding of tb) +  the page-display-target-width - (right-value margin of tb + border size of tb + right-value padding of tb + the tb-text-width of tb)) / 2;
  if the horizontal-box-align of tb is right-align, now first-column is the page-display-target-width - (left-value margin of tb + border size of tb + left-value padding of tb + tb-text-width of tb);
  if the horizontal-box-align of tb is left-align, now first-column is 1 + the left-value margin of tb + the border size of tb + the left-value padding of tb;
  if the vertical-box-align of tb is center-align, now first-row of tb is the ((top-value margin of tb) + (the border size of tb) + (the top-value padding of tb) + (page-display-target-height) - (bottom-value margin of tb + border size of tb + bottom-value padding of tb + the number of entries in tb-line-list of tb)) / 2;
  if the vertical-box-align of tb is bottom-align, now first-row of tb is 1 + the page-display-target-height - (tb-text height of tb + the bottom-value margin of tb + the border size of tb + the bottom-value padding of tb);
  if the vertical-box-align of tb is top-align, now first-row of tb is 1 + the top-value margin of tb + the border size of tb + the top-value padding of tb;

After box-planning a text-box (called tb):
  if the tb-external width of tb > page-display-target-width or the tb-external height of tb > page-display-target-height, now the box-status of tb is overflow-error.

[ TODO what if T is too long? ]
To decide what text is text line (T - a text) of/for (tb - a text-box):
 if tb is unbordered, decide on "[unicode-space * left-value padding of tb][T][unicode-space * (tb-text-width of tb - number of characters in T)][unicode-space * right-value padding of tb]";
 decide on "[left-value edge-glyph of tb][unicode-space * left-value padding of tb][T][unicode-space * (tb-text-width of tb - number of characters in T)][unicode-space * right-value padding of tb][right-value edge-glyph of tb]";

Part debug (not for release)

To debug-output (layout - a box-layout):
repeat with box running through the box-list of layout begin;
  say "[box] row: [first-row of box] col: [first-column of box] text-width: [tb-text-width of box] border size: [border size of box].";
  say "  paddings: [box-paddings of box].";
  say "  margins: [box-margins of box].";
  repeat with pv running through the position-values begin;
    say "  [pv] [direction-modifier of pv].";
    repeat with ev running through the extent-values begin;
      say "  [ev] : [the pv edge of ev of box].";
    end repeat;
  end repeat;
end repeat;

Part grid (for use without Text Griddle by Zed Lopez)

To put (t - a text) at x (col - a number) and/-- y (row - a number):
  put t at x col and y row of acting main window.

To put (t - a text) at x (col - a number) and/-- y (row - a number) of (win - a g-window): 
(- glk_window_move_cursor({win}.(+ ref number +), {col} - 1, {row} - 1); TEXT_TY_Say({t}); -).

Part no boxes with screenreader (for use with Screenreader by Zed Lopez)

Last before page-displaying a box-layout (called bl) when the interface is screenreader (this is the plain box text for screenreaders rule):
  now the layout-outcome of bl is box-invalid-error.

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

Chapter Introduction

Text Box offers a lot of options, but the simplest usage is uncomplicated:

When play begins:
  display text box with "My object all sublime[line break]I shall achieve in time[line break]To make the punishment[line break]Fit the crime."


Section Line Styles

Bordered boxes' edges default to having single-line-style; other possibilities are double-line-style or heavy-line-style. To set all 4 edges to some style:

set the line style of quote-box to double-line-style.

To set either both horizontal or both vertical edges:

set the horizontal line style of quote-box to heavy-line-style.
set the vertical line style of quote-box to double-line-style.

If you really want to set an individual line, or set all 4 to arbitrary values:

set the top-value line style of quote-box to heavy-line style.
now the line-styles of quote-box are { single-line-style, heavy-line-style, double-line-style, single-line-style }.


To get the style of a given edge:

line style of/for <position-value> of/for <text-box>


Chapter Changelog

v2: extensively refactored.
    unbordered now the top-level kind,
    with bordered as a subkind of it. 

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
	
