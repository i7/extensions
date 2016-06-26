Version 1/111022 of Glimmr Simple Graphics Window (for Glulx only) by Erik Temple begins here.

"Creates a graphics window that can be used with any Flexible Windows project. If used with Glimmr Canvas-Based Drawing, also creates a canvas to be displayed in the window. Includes code for drawing a single image centered in the window."


Use authorial modesty.


Section - Console settings
[This is a macro that allows the extension to identify itself in the Glimmr console window with fewer keystrokes on my part.]

To say GSGW:
	say "[bracket]Glimmr SGW[close bracket]: ".


Section - Basic window definition

The graphics-window is a graphics g-window spawned by the main-window. 


Section - Canvas (for use with Glimmr Canvas-Based Drawing by Erik Temple)

The graphics-canvas is a g-canvas. 
The associated canvas of the graphics-window is the graphics-canvas.
The associated canvas of a g-element is usually the graphics-canvas.

First when play begins when the canvas-width of the graphics-canvas is 0 or the canvas-height of the graphics-canvas is 0 (this is the assign simple graphics window canvas dimensions rule):
	if the background image of the graphics-canvas is Figure of Null:
		now the canvas-width of the graphics-canvas is 600;
		now the canvas-height of the graphics-canvas is 450;
		#if utilizing Glimmr debugging;
		say "[>console][GSGW]Dimensions were not specified for canvas [i]graphics-canvas[/i]. Width set to [canvas-width of the graphics-canvas], height set to [canvas-height].[<]";
		#end if. 


Section - Current window (for use with Glimmr Drawing Commands by Erik Temple)

The current graphics window is the graphics-window.


Section - Very basic drawing rule (for use without Glimmr Canvas-Based Drawing by Erik Temple)

[If we aren't using Canvas-Based Drawing, then we want to provide a stub rule, one that everyone is likely to use. This will clear the window to its background color, and we can add any rule we wish after it to actually do something.]

First window-drawing rule for the graphics-window (this is the clear the graphics-window rule):
	clear the graphics-window.


Section - Enable graphic hyperlinks (for use with Glimmr Graphic Hyperlinks by Erik Temple)

The graphics-window is g-graphlinked.


Chapter - Debugging niceties (for use without Glimmr Canvas-Based Drawing by Erik Temple)

[We only define the phrases in the following section if *both* GCBD and GDC are not included.]

Section - Debugging niceties (for use without Glimmr Drawing Commands by Erik Temple)

To #if utilizing Glimmr debugging:
	(- #ifdef Glimmr_DEBUG; -)
	
To #end if:
	(- #endif; -)

To say >console:
	do nothing.
 
To say <:
	do nothing.


Glimmr Simple Graphics Window ends here.


---- DOCUMENTATION ----

Glimmr Simple Graphics Window creates a very basic graphics window. It can be used in any Flexible Windows project, but will be extended with special capabilities when used with Glimmr Canvas-Based Drawing or Glimmr Graphic Hyperlinks. The extension is probably most useful for quick prototyping and testing, though it can also be used quite easily for any game that needs at least one graphics window. Glimmr Simple Graphics Window (GSGW) will not be listed in a game's credits.


Section: Including Glimmr Simple Graphics Window in your project

If you are using GSGW with a Glimmr project, it must be included *after* Glimmr Drawing Commands, Glimmr Canvas-Based Drawing, and/or Glimmr Graphic Hyperlinks:

	Include Glimmr Canvas-Based Drawing by Erik Temple.
	Include Glimmr Graphic Hyperlinks by Erik Temple.
	Include Glimmr Simple Graphics Window by Erik Temple.

If you are not using other Glimmr extensions, then you will need to include GSGW after Flexible Windows (or another extension that includes Flexible Windows):

	Include Flexible Windows by Jon Ingold.
	Include Glimmr Simple Graphics Window by Erik Temple.


Section: Basic Usage

Glimmr Simple Graphics Window creates a graphics g-window of the kind "graphics g-window" (see Flexible Windows). GSGW does not set any default settings for the window, and also does not open it. So, after including the extension, we need to, at minimum, open the window. To do this at the beginning of the game:

	When play begins:
		open up the graphics-window.

In the absence of other settings, this will open a vertically oriented window with a black background, to the right of the main window. Use the standard Flexible Windows g-window properties to change these defaults, e.g.:

	The back-colour of the graphics-window is g-Lavender.
	The position of the graphics-window is g-placeabove.

The window created by GSGW is called the "graphics-window".

If GSGW is not used with Glimmr Canvas-Based Drawing, only a bare bones window-drawing rule is provided. This rule, the "clear the graphics-window rule", does nothing but clear the window to its background color. To amplify the window-drawing routine, add another window-drawing rule:

	A window-drawing rule for the graphics-window:
		let win_width be the width of the graphics-window;
		let win_height be the height of the graphics-window;
		let img_width be the image-width of the current image;
		let img_height be the image-height of the current image;
		(etc.)

The example game below includes a complete drawing rule and supporting code that will display an image centered in the window (scaling it down to fit if necessary).			


Section: Using GSGW with Glimmr Graphic Hyperlinks

When Glimmr Graphic Hyperlinks is included in the project, it is assumed that the graphics-window should be receptive to graphic hyperlinks, and the window is accordingly given the "g-graphlinked" property. If this is not desired, change it before opening the window, like so:

	When play begins:
		now the graphics-window is not g-graphlinked;
		open up the graphics-window.


Section: Using GSGW with Glimmr Canvas-Based Drawing

When used with Glimmr Canvas-Based Drawing, GSGW will automatically create a canvas and associate it with the graphics-window. This canvas is called the "graphics-canvas". If we don't assign a size or a background image to the graphics-canvas, it will be sized at 600 by 450. Any g-elements created will automatically be associated with the graphics-canvas unless otherwise specified in the declaration of the element.

To change the canvas, set the properties described in Glimmr Canvas-Based Drawing, e.g.:

	The canvas-width of the graphics-canvas is 400.
	The canvas-height of the graphics-canvas is 900.


Section: Debugging

At present, no debugging features are associated with Glimmr Simple Graphics Window, and the extension makes no output to the Glimmr debugging log.


Section: Contact info

If you have comments about the extension, please feel free to contact me directly at ek.temple@gmail.com.

Please report bugs on the Google Code project page, at http://code.google.com/p/glimmr-i7x/issues/list.

For questions about Glimmr, please consider posting to either the rec.arts.int-fiction newsgroup or at the intfiction forum (http://www.intfiction.org/forum/). This allows questions to be public, where the answers can also benefit others. If you prefer not to use either of these forums, please contact me directly via email (ek.temple@gmail.com).


Example: * Ramrod - This simple example illustrates the use of GSGW on its own, without any of the other Glimmr extensions. The example includes a drawing rule that centers an image (specified using the "current image" variable) in the graphics-window. If the image is too large to fit in the window, it will be scaled down.

Note that this example requires an image to function. The image referred to in the example can be downloaded, along with all of the other images used in Glimmr examples, from http://code.google.com/p/glimmr-i7x/downloads/list.

Also note that this example includes I6 inclusions. Due to a bug in Inform, these do not transfer properly when using the paste button. You will need to manually add -) after the body of multi-line I6 inclusions. 

	*: "Ramrod"

	Boston 1775 is a room.

	Include Flexible Windows by Jon Ingold.
	Include Glimmr Simple Graphics Window by Erik Temple.

	The position of the graphics-window is g-placeabove. The back-colour of the graphics-window is g-Black.

	When play begins:
		open up the graphics-window.
	
	Figure of Gunnery is the file "Revolution.jpg".

	After looking:
		follow the window-drawing rules for the graphics-window.
	

You may insert only the code below to use the window-drawing rule in your own code. Just remember to delete the sentence "The current image is Figure of Gunnery". You will also need to remember to include an appropriate regime for updating the window. If you are using an image for each location, for example, it will probably be best to update the window in an "after looking" rule (as in this example). To update the window, use the phrase "follow the window-drawing rules for the graphics-window".

The code for image display and so on (everything after the window-drawing rule) is borrowed from Glimmr Drawing Commands.
	
	*: The current image is a figure name variable. The current image is Figure of Gunnery.
	
	A window-drawing rule for the graphics-window (this is the scaled image display rule):
		let win_width be the width of the graphics-window;
		let win_height be the height of the graphics-window;
		let img_width be the image-width of the current image;
		let img_height be the image-height of the current image;
		let scale_factor be 100;
		let width_factor be (win_width * 100) / img_width;
		let height_factor be (win_height * 100) / img_height;
		if width_factor is greater than height_factor:
			let scale_factor be height_factor;
		otherwise:
			 let scale_factor be width_factor;
		let img_width be (img_width * scale_factor) / 100;
		let img_height be (img_height * scale_factor) / 100;
		let offset_width be the greater of 0 or (win_width - img_width) / 2;
		let offset_height be the greater of 0 or (win_height - img_height) / 2;
		display the current image in the graphics-window at (offset_width) by (offset_height) with dimensions (img_width) by (img_height).

	After printing the banner text:
		say "[line break]This exceedingly dull example, for the Glimmr Simple Graphics Window extension, illustrates how to write a simple graphics window rule in I7. The rule that scales and centers the image is as follows:[paragraph break]    A window-drawing rule for the graphics-window (this is the scaled image display rule):[line break]                 let win_width be the width of the graphics-window;[line break]                 let win_height be the height of the graphics-window;[line break]                 let img_width be the image-width of the current image;[line break]                 let img_height be the image-height of the current image;[line break]                 let scale_factor be 100;[line break]                 let width_factor be (win_width * 100) / img_width;[line break]                 let height_factor be (win_height * 100) / img_height;[line break]                 if width_factor is greater than height_factor:[line break]                 	let scale_factor be height_factor;[line break]                 otherwise:[line break]                 	 let scale_factor be width_factor;[line break]                 let img_width be (img_width * scale_factor) / 100;[line break]                 let img_height be (img_height * scale_factor) / 100;[line break]                 let offset_width be the greater of 0 or (win_width - img_width) / 2;[line break]                 let offset_height be the greater of 0 or (win_height - img_height) / 2;[line break]                 display the current image in the graphics-window at (offset_width) by (offset_height) with dimensions (img_width) by (img_height).[paragraph break]"
	
	To display (ID - a figure name) in (win - a g-window) at (x1 - a number) by/x (y1 - a number) with size/dimensions (width - a number) by/x (height - a number):
		(- DrawImageScaled({ID}, {win}, {x1}, {y1}, {width}, {height}); -)
	

	Include (-

	[DrawImageScaled ID win x y image_x image_y ;
		if (win.ref_number) {
			glk_image_draw_scaled(win.ref_number, ResourceIDsOfFigures-->ID, x, y, image_x, image_y);
		}
	];  

	-).

	To decide which number is the greater/max of/-- (X - a number) or (Y - a number):
		if Y > X, decide on Y;
		decide on X.
	
	To decide what number is the image-width of (img - a figure name):
		(- FindImageWidth({img}) -)
	
	To decide what number is the image-height of (img - a figure name):
		(- FindImageHeight({img}) -)
	

	Include (-

	[ FindImageWidth  img result img_width;
		result = glk_image_get_info(ResourceIDsOfFigures-->img, gg_arguments, gg_arguments+WORDSIZE);
	             		img_width  = gg_arguments-->0;
		return img_width;
	];

	[ FindImageHeight  img result img_height;
		result = glk_image_get_info(ResourceIDsOfFigures-->img, gg_arguments, gg_arguments+WORDSIZE);
	             		img_height  = gg_arguments-->1;
		return img_height;
	];

	-)




