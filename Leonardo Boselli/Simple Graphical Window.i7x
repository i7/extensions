Version 8/140908 of Simple Graphical Window (for Glulx only) by Leonardo Boselli begins here. 

"Provides a graphics window in one part of the screen, in which the author can place images; with provision for scaling, tiling, or centering images automatically, as well as setting a background color. Glulx only. Modified because of changes in 6L38 release."

Include Version 7 of Glulx Entry Points by Emily Short.

Section 1 - Creating Rocks and Building the Window Itself

Include(-  

Constant GG_PICWIN_ROCK = 200;
Global gg_picwin = 0; 

-) before "Glulx.i6t".   

Before starting the virtual machine:
	do nothing. [Hack that, for complicated reasons, prevents character streams going to the wrong place at game startup under some conditions.]

When play begins (this is the graphics window construction rule):
	build graphics window;
	follow the current graphics drawing rule.


Section 2 - Items to slot into HandleGlkEvent and IdentifyGlkObject

[These rules belong to rulebooks defined in Glulx Entry Points.]

A glulx zeroing-reference rule (this is the default removing reference to picwin rule):
	zero picwin.

To zero picwin:
	(- gg_picwin = 0; -)

A glulx resetting-windows rule (this is the default choosing picwin rule):
	identify glulx rocks.	

To identify glulx rocks:
	(- RockSwitchingSGW(); -)

Include (-

[ RockSwitchingSGW;
	switch( (+current glulx rock+) )
	{
		GG_PICWIN_ROCK: gg_picwin = (+ current glulx rock-ref +);
	}
];

-)

A glulx arranging rule (this is the default arranging behavior rule): 
	follow the current graphics drawing rule.

A glulx redrawing rule (this is the default redrawing behavior rule):
	follow the current graphics drawing rule.

A glulx object-updating rule (this is the automatic redrawing window rule):
	follow the current graphics drawing rule.

Section 3 - Inform 6 Routines for Drawing In Window

Include (-  

[ FindHeight  result graph_height;
	if (gg_picwin)
	{	result = glk_window_get_size(gg_picwin, gg_arguments, gg_arguments+WORDSIZE);
             		graph_height  = gg_arguments-->1;
	} 
	return graph_height;
];

[ FindWidth  result graph_width;
	if (gg_picwin)
	{	result = glk_window_get_size(gg_picwin, gg_arguments, gg_arguments+WORDSIZE);
             		graph_width  = gg_arguments-->0;
	} 
	return graph_width;
];

 [ MyRedrawGraphicsWindows cur_pic result graph_width graph_height 
		img_width img_height w_offset h_offset w_total h_total;

	if (FollowRulebook( (+glulx picture selection rules+) ) ) { cur_pic = ResourceIDsOfFigures-->(+ internally selected picture +); }   
	if (cur_pic == 0) rtrue;

      if (gg_picwin) {  

	result = glk_window_get_size(gg_picwin, gg_arguments, gg_arguments+WORDSIZE);
             	graph_width  = gg_arguments-->0;
             	graph_height = gg_arguments-->1;

	result = glk_image_get_info( cur_pic, gg_arguments,  gg_arguments+WORDSIZE);
	img_width  = gg_arguments-->0;
	img_height = gg_arguments-->1;

	w_total = img_width;
	h_total = img_height;

	if (graph_height - h_total < 0) !	if the image won't fit, find the scaling factor
	{
		w_total = (graph_height * w_total)/h_total;
		h_total = graph_height;

	}

	if (graph_width - w_total < 0)
	{
		h_total = (graph_width * h_total)/w_total;
		w_total = graph_width;
	}

	w_offset = (graph_width - w_total)/2; if (w_offset < 0) w_offset = 0;
	h_offset = (graph_height - h_total)/2; if (h_offset < 0) h_offset = 0;

	glk_image_draw_scaled(gg_picwin, cur_pic, w_offset, h_offset, w_total, h_total); 
	}
 ]; 

[ BlankWindowToColor color result graph_width graph_height;
  
	! color = 0;
	if (color == 0) color = $000000;

      if (gg_picwin) {  

	result = glk_window_get_size(gg_picwin, gg_arguments, gg_arguments+WORDSIZE);
             	graph_width  = gg_arguments-->0;
             	graph_height = gg_arguments-->1; 

	glk_window_fill_rect(gg_picwin, color , 0, 0, graph_width, graph_height);
	}
];

 [ TileFillGraphicsWindows cur_pic result graph_width graph_height 
		img_width img_height w_total h_total color;

	if (FollowRulebook( (+glulx picture selection rules+) ) ) { cur_pic = ResourceIDsOfFigures-->(+ internally selected picture +); }   
	if (cur_pic == 0) rtrue;

	color = 0;
	if (color == 0) color = $000000;

      if (gg_picwin) {  

	result = glk_window_get_size(gg_picwin, gg_arguments, gg_arguments+WORDSIZE);
             	graph_width  = gg_arguments-->0;
             	graph_height = gg_arguments-->1;

	result = glk_image_get_info( cur_pic, gg_arguments,  gg_arguments+WORDSIZE);
	img_width  = gg_arguments-->0;
	img_height = gg_arguments-->1;   

	while (w_total < graph_width)
	{
		while (h_total < graph_height)
		{
			glk_image_draw(gg_picwin, cur_pic, w_total, h_total); 
			h_total = h_total + img_height;
		}
		h_total = 0;
		w_total = w_total + img_width;
	}
	}
 ]; 

[ TotalFillGraphicsWindows cur_pic result graph_width graph_height 
		img_width img_height;

	if (FollowRulebook( (+glulx picture selection rules+) ) ) { cur_pic =  ResourceIDsOfFigures-->(+ internally selected picture +); }   
	if (cur_pic == 0) rtrue;

      if (gg_picwin) {  

	result = glk_window_get_size(gg_picwin, gg_arguments, gg_arguments+WORDSIZE);
             	graph_width  = gg_arguments-->0;
             	graph_height = gg_arguments-->1;

	glk_image_draw_scaled(gg_picwin, cur_pic, 0, 0, graph_width, graph_height); 
	}
 ]; 

!Array gg_arguments --> 0 0;

[ MakeGraphicsWindow depth prop pos;
	if (gg_picwin) rtrue;
	depth = (+ Graphics window pixel count +);
	prop = (+ Graphics window proportion +);
	pos = (+ Graphics window position +);
	switch(pos)
	{
		(+g-null+): pos = winmethod_Above;
		(+g-above+): pos = winmethod_Above;
		(+g-below+): pos = winmethod_Below;
		(+g-left+): pos = winmethod_Left;
		(+g-right+): pos = winmethod_Right;
	} 
	if (prop > 0 && prop < 100)
	{	
		gg_picwin = glk_window_open(gg_mainwin, (pos+winmethod_Proportional), prop, wintype_Graphics, GG_PICWIN_ROCK);
	}
	else
	{
		if (depth == 0) depth = 240;
		gg_picwin = glk_window_open(gg_mainwin, (pos+winmethod_Fixed), depth, wintype_Graphics, GG_PICWIN_ROCK);
	}
];
-). 

Section 4 - Inform 7 Wrappers for Defining Window and Colors

Include Glulx Text Effects by Emily Short. [This makes colors available to us.]

Currently shown picture is a figure-name that varies. [This the author may set during the course of the source.]

Internally selected picture is a figure-name that varies. [This is the picture selected by the picture selection rules, which might be the 'currently shown picture' (by default) or might be, say, the current frame of an animation in progress. The author should not set this directly, but instead write additional picture selection rules if he wants to change it.]

Graphics window pixel count is a number that varies. Graphics window proportion is a number that varies.

[***]
Graphics background color is a text that varies.
[***Graphics background color is a glulx color value that varies.]

Glulx window position is a kind of value. The Glulx window positions are g-null, g-above, g-below, g-left, and g-right.

Graphics window position is Glulx window position that varies.  


Section 4a - More Wrappers (for use without Collage Tools by Emily Short)

To decide what number is the current graphics window width:
	(- FindWidth() -)

To decide what number is the current graphics window height:
	(- FindHeight() -)

[***
To color the/-- graphics window (gcv - a glulx color value) from (x - a number) by (y - a number) to (xx - a number) by (yy - a number):
	let numerical gcv be the assigned number of gcv;
	color graphics window numerical gcv from x by y to xx by yy.
]

To color the/-- graphics window (gcv - a number) from (x - a number) by (y - a number) to (xx - a number) by (yy - a number):
	 (- glk_window_fill_rect(gg_picwin, {gcv} , {X}, {Y}, {XX}, {YY}); -)

To draw (fig - a figure-name) from (x - a number) by (y - a number) to (xx - a number) by (yy - a number): 
	(- glk_image_draw_scaled(gg_picwin, ResourceIDsOfFigures-->{fig}, {x}, {y}, {xx}, {yy}); -)


Section 5 - Inform 7 Wrapper Rulebook for Picture Selection

The glulx picture selection rules are a rulebook.

A glulx picture selection rule (this is the default picture selection rule):
	now the internally selected picture is the currently shown picture;
	rule succeeds.

Section 6 - Inform 7 Wrapper Phrases and Rules for Drawing

To build graphics window:
	(- MakeGraphicsWindow(); -)

Current graphics drawing rule is a rule that varies. The current graphics drawing rule is the standard placement rule.

[By default we want to clear the screen to the established background color, then draw our image centered in the window, scaling it down to fit if necessary.]

This is the standard placement rule:
	blank window to graphics background color;
	follow the centered scaled drawing rule. 

This is the bland graphics drawing rule:
	blank window to graphics background color;

To blank the/-- graphics/-- window to (bc - a text): 
	(- BlankWindowToColor( GTE_ConvertColour( {bc} ) ); -)

To blank the/-- graphics/-- window to (bc - a number):
	(- BlankWindowToColor({bc}); -)

[We can also use the centered scaled drawing rule on its own, without blanking out the background, if we want. This might be useful if, for instance, we want to fill the background with a tiled texture and then place a centered image over the top of it.]

This is the centered scaled drawing rule:
	draw centered scaled image in graphics window.

To draw centered scaled image in graphics window:
	(- MyRedrawGraphicsWindows(); -)

[And here's the rule for tiling an image:]

This is the tiled drawing rule:
	draw tiled image in graphics window.

To draw tiled image in graphics window:
	(- TileFillGraphicsWindows(); -)

[And for scaling the image to fit the graphics window, without preserving aspect ratio but simply filling all the available space:]

This is the fully scaled drawing rule:
	draw fully scaled image in graphics window.

To draw fully scaled image in graphics window:
	(- TotalFillGraphicsWindows(); -)

[The purpose of this design is to allow authors to add their own rules for drawing graphics should the provided ones be thought insufficient, without needing to replace the entire extension. To do this, create a rule with a different name, a To... phrase to call an I6 function, and the I6 function itself, emulating the format used here.]

Simple Graphical Window ends here.

---- Documentation ----

Read the original documentation of Simple Graphical Window by Emily Short.