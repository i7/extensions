Location Images (for Glulx only) by Emily Short begins here.

"Allows the author to set per-room images and show these as the player moves from room to room. Requires Simple Graphical Window by Emily Short."

Include Simple Graphical Window by Emily Short.

A room has a figure-name called room-illustration. 
	
The image-setting rule is listed in the carry out looking rules. 

This is the image-setting rule:
	now currently shown picture is the room-illustration of the location;
	follow the current graphics drawing rule.

Location Images ends here.

---- Documentation ----

Location Images allows us to assign an illustration to each room of the game, to be displayed automatically in a graphics window at the top of the screen as the player moves around.

For example, the source text

	Include Location Images by Emily Short.

	Figure of Shadefruit is the file "SmallShadefruit.jpg".
	Figure of Frostweed is the file "Smallfrostweed.jpg". 
	
	Frosty Ground is a room. The room-illustration is Figure of Frostweed. 

	Shaded Area is west of Frosty Ground. The room-illustration is Figure of Shadefruit.

would create the graphical window automatically and (assuming we have provided the image files for our project) show the illustrations as we moved from room to room.

For more information about providing image files for a project, see the main Inform documentation on Illustrations.

The size of the window and color of the background shading can be controlled as described in the documentation for Simple Graphical Window.