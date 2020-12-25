Version 3/181103 of Vorple Status Line (for Glulx only) by Juhana Leinonen begins here.

"The Vorple version of the standard status line."

Use authorial modesty.

Include version 3 of Vorple Screen Effects by Juhana Leinonen.
Include version 3 of Vorple Element Manipulation by Juhana Leinonen.

Use full-width status line translates as (- Constant VORPLE_STATUS_LINE_FULL_WIDTH; -).


Chapter 1 - Constructing the status line

Left hand Vorple status line, middle Vorple status line, right hand Vorple status line and mobile Vorple status line are text that varies.

The left hand Vorple status line is usually " [left hand status line]".
The right hand Vorple status line is usually "[right hand status line] ".
The mobile Vorple status line is usually "[if the Vorple status line size is 1][middle Vorple status line][otherwise][left hand status line][end if]".

[don't change this number directly – internal use only]
The Vorple status line size is a number that varies. The Vorple status line size is 0.

Constructing the Vorple status line is an activity.

To construct the/a/-- Vorple status line with (column count - number) column/columns:
	if column count > 3 or column count < 0:
		throw Vorple run-time error "Vorple Status Line: status line must have exactly 1, 2 or 3 columns, [column count] requested";
		rule fails;
	now Vorple status line size is column count;
	remove the Vorple status line;
	place an element called "status-line-container" at the top level;
	if the full-width status line option is active:
		execute JavaScript command "$('.status-line-container').prependTo('main#haven')";
	otherwise:
		execute JavaScript command "$('.status-line-container').prependTo('#output')";
	set output focus to element called "status-line-container";
	if column count is greater than 1:
		place a block level element called "status-line-left col-xs lg-only";
	if column count is not 2:
		place a block level element called "status-line-middle col-xs lg-only";
	if column count is greater than 1:
		place a block level element called "status-line-right col-xs lg-only";
	place a block level element called "status-line-mobile col-xs sm-only";
	set output focus to the main window.
	
Last rule for constructing the Vorple status line (this is the default Vorple status line rule):
	if Vorple status line size is greater than 1:
		display text left hand Vorple status line in the element called "status-line-left";
	if Vorple status line size is not 2:
		display text middle Vorple status line in the element called "status-line-middle";
	if Vorple status line size is greater than 1:
		display text right hand Vorple status line in the element called "status-line-right";
	display text mobile Vorple status line in the element called "status-line-mobile";
	make no decision.

To refresh the/-- Vorple status line:
	if Vorple is supported and the Vorple status line size > 0:
		save the internal state of line breaks;
		carry out the constructing the Vorple status line activity;
		restore the internal state of line breaks.

To remove the/-- Vorple status line:
	remove the element called "status-line-container".
	
To clear the/-- Vorple status line:
	execute JavaScript command "$('.status-line-container').children().empty()".

A Vorple interface update rule (this is the refresh Vorple status line rule):
	refresh the Vorple status line.

Vorple Status Line ends here.


---- DOCUMENTATION ----

By default Vorple doesn't show the standard Glulx status line that you'd see in a traditional non-Vorple interpreter. This extension re-adds the status line feature, with some extra functionality.


Chapter: Constructing the status line

The Vorple status line can have either 1, 2 or 3 columns. The status line is created by calling the phrase "construct the Vorple status line with N columns" where N is the number of required columns.

	*: When play begins:
		construct the Vorple status line with 2 columns.

The contents of the status line are determined by variables called left hand Vorple status line, middle Vorple status line, right hand Vorple status line and mobile Vorple status line. The default contents of left and right hand columns are the same as the contents of the Glulx status line, and the middle column is empty (except in the 1-column status line, where the middle column has the contents of the Glulx left hand status line).

The following example creates a 3-column status line with different content in each column.

	*: The left hand Vorple status line is "You are: [the printed name of the player]".
	The middle Vorple status line is "Location: [the player's surroundings]".
	The right hand Vorple status line is "Time: [time of day]".

	When play begins:
		construct the Vorple status line with 3 columns.

(Note that instead of 'location' it's better to use 'the player's surroundings' because it'll print 'in darkness' instead when there's no light in the room, or the container's name if the player is inside an opaque container.)

Column contents can also be changed during the play with "now the left hand Vorple status line is ..." and so on.

When the status line is constructed with 1 column, only the middle column is shown. When constructed with 2 columns, only left and right hand columns are shown.

The contents of the columns are automatically aligned left in the left hand column, centered in the middle column and aligned right in the right hand column.

The columns of the standard Glulx status line have a fixed height. The Vorple status line adapts its height to its contents, so any text that doesn't fit in a column automatically wraps to a new line. Each column takes an equal amount of space on the screen, so a 2-column status line's columns both occupy half the width and 3 columns take one third each.

The status line can be removed at any point with:

	remove the Vorple status line;

After removing the status line it can be recreated with the "construct the status line" phrase. Changing the amount of columns is also possible by constructing the status line with a new column count.

We can also remove the contents of the status line with

	clear the Vorple status line;
	
which removes the contents but leaves the columns in place, but that's useful only in custom status line construction rules because the default status line construction rule will just fill the columns again at the end of the turn.


Chapter: Mobile status line

If the browser screen is 568 pixels wide or smaller, the usual status line columns are replaced with a special mobile status line. The idea is to automatically reduce two and three column status lines to just one so that individual columns don't become too narrow on small screens.

The contents of the mobile status line can be changed by setting the value of "mobile Vorple status line". The default content is the same as the left hand Vorple status line, except when the status line is constructed with 1 column. In that case the default content is the same as the column that is shown in the wide view (middle Vorple status line.) 

Here we'll set the mobile status line to all three columns separated by slashes. This works well when the columns have very short content.

	*: The mobile Vorple status line is "[left hand Vorple status line] / [middle Vorple status line] / [right hand Vorple status line]".
	
When there content is longer it's often better to place the columns on top of each other, or just omit the less important information.

	*: The mobile Vorple status line is "[left hand Vorple status line][line break][middle Vorple status line][line break][right hand Vorple status line]".

We can test the mobile status line by resizing the browser window. The mobile status line toggles automatically when the screen width crosses the 568 pixel limit.


Chapter: Using together with the standard status line

The Vorple left hand and right hand status lines are initially defined to have the same content as the standard Glulx status line (which you see in non-Vorple interpreters). The extension initializes the status line contents with this code:

	The left hand Vorple status line is usually " [left hand status line]".
	The right hand Vorple status line is usually "[right hand status line] ".

If left as is, changing the "left hand status line" and "right hand status line" variables will change both the Vorple status line and the Glulx status line. Changing the Vorple status line variables to something else will break this connection.

The Glulx right hand status line has a character limit of 14 characters. Vorple doesn't have this limitation, but if the same content is used for both status lines, the right hand should be limited to 14 characters.


Chapter: Manually refreshing the status line

The status line is automatically refreshed to show current information at the end of each turn. Sometimes we might want to refresh manually, for example when waiting for a keypress or an answer to a yes/no question. It can be done with:
	
	follow the refresh Vorple status line rule;


Chapter: Custom status line construction rules

An activity called "constructing the Vorple status line" is responsible for updating the status line. The default rule creates the status line as described earlier, but it any custom rules can be added to the activity. The example "Petting Zoo" below shows an example of how that can be done. Adding 'rule succeeds' at the end will block the default rule from running (which would usually otherwise overwrite whatever the custom rule has done.)

For the purposes of adding content to the status line columns, the elements are named "status-line-left", "status-line-middle", "status-line-right" and "status-line-mobile". The entire status line is called "status-line-container".


Chapter: Styling the status line

By default the status line is as wide as the column that displays the story text. The status line can be made to span the entire screen width with the "full-width status line" option:

	Use full-width status line.

CSS can be used to style the status line in virtually any fashion. For example, the following CSS rule changes the line below the status line from double lines to a single line and makes the background light blue:

	.status-line-container {
		border-bottom: 1px solid;
		background-color: #ddddff;
	}

The relevant CSS classes are "status-line-container", "status-line-left", "status-line-middle", "status-line-righ" and "status-line-mobile", as described in the previous chapter.

See the Vorple documentation at vorple-if.com for more information about CSS.


Example: *** Petting Zoo - An icon in the status line to show the player character's mood

This example shows how to insert images to the status line. The status line reflects a change in a value - the player character's mood - by showing appropriate icons in the left column. In the mobile view the icons are shown in the middle of the status line.

Because the extension doesn't directly have features to insert images into the status line, we'll write a custom status line construction rule for it. The rule first removes old content from the status line, then puts the image in the left column and the location to the right column.

The image files used in this example can be downloaded from https://vorple-if.com/resources.zip

	*: "Petting Zoo"

	Include Vorple Status Line by Juhana Leinonen.
	Include Vorple Multimedia by Juhana Leinonen.
	
	Release along with the "Vorple" interpreter.
	
	Release along with the file "Face-crying.png".
	Release along with the file "Face-sad.png".
	Release along with the file "Face-neutral.png".
	Release along with the file "Face-smiling.png".
	Release along with the file "Face-happy.png".
	
	
	Chapter 1 - Status line
	
	When play begins:
		construct a Vorple status line with 2 columns.
	
	Rule for constructing the Vorple status line:
		clear the Vorple status line;
		set the output focus to the element called "status-line-left";
		place an image "Face-[mood of the player].png" with the description "[mood of the player]";
		set the output focus to the element called "status-line-right";
		say "[the player's surroundings]";
		set the output focus to the element called "status-line-mobile";
		place an image "Face-[mood of the player].png" with the description "[mood of the player]";
		set the output focus to the main window;
		rule succeeds.
	
	
	Chapter 2 - Moods
	
	A mood is a kind of value. Moods are crying, sad, neutral, smiling and happy.
	
	A person has a mood. The mood of a person is usually neutral.
	
	To make the player sadder:
		if the player is not crying:
			now the player is the mood before the mood of the player.
	
	To make the player happier:
		if the player is not happy:
			now the player is the mood after the mood of the player.
	
	When play begins (this is the plain status line setup rule): 
		now the right hand status line is "[the mood of the player]".
		
	When play begins (this is the preload mood icons rule):
		repeat with M running through moods:
			preload image "Face-[M].png".
	
	
	Chapter 3 - World
	
	The Petting Zoo is a room. "There are many kinds of animals you can pet here."
	
	Understand the command "pet" as "touch".
	
	An animal can be friendly or dangerous.
	
	A bunny is here. The bunny is a friendly animal.
	A puppy is here. The puppy is a friendly animal.
	A sheep is here. The sheep is a friendly animal.
	
	A crocodile is here. The crocodile is a dangerous animal.
	A warthog is here. The warthog is a dangerous animal.
	A snake is here. The snake is a dangerous animal.
	
	Instead of touching a friendly animal:
		say "You pet [the noun] and feel better.";
		make the player happier.
		
	Instead of touching a dangerous animal:
		say "You approach [the noun] and it almost bites your hand off!";
		make the player sadder.
		
	Test me with "pet crocodile / pet warthog / pet bunny / pet puppy/ pet sheep / pet bunny".
		
