Version 3/190914 of Vorple Modal Windows (for Glulx only) by Juhana Leinonen begins here.

"Modal windows are dialog prompts or other information windows that pop up on top of the play area and require user action to dismiss."

Include version 3 of Vorple by Juhana Leinonen.

Use authorial modesty.

Chapter 1 - Modal windows

To show a/-- modal window reading (content - text), without pausing:
	let modal message be escaped content using "\n" as line breaks;
	if Vorple is not supported:
		say "[content][paragraph break]";
	if without pausing:
		execute JavaScript code "vorple.layout.block();vorple.prompt.hide();vex.closeAll();vex.dialog.open({message:'[modal message]',buttons:[bracket]vex.dialog.buttons.YES[close bracket],callback:function(){vorple.layout.unblock();vorple.prompt.unhide()}})";
	otherwise:
		execute JavaScript code "vorple.layout.block();vorple.prompt.hide();vex.closeAll();vex.dialog.open({message:'[modal message]',buttons:[bracket]vex.dialog.buttons.YES[close bracket],callback:function(){vorple.layout.unblock();vorple.prompt.unhide();vorple.prompt.queueKeypress(' ')}})";
		wait for any key.

To show a/-- modal window:
	show a modal window reading "", without pausing.

To set output focus to the/-- modal window:
	set output focus to the element called "vex-dialog-message".
	

Chapter 2 - Waiting for keypress (for use without Basic Screen Effects by Emily Short)

To wait for any key:
	(- KeyPause(); -).
	
Include (-
	[ KeyPause key; 
		while ( 1 )
		{
			key = VM_KeyChar();
			if ( key == -4 or -5 or -10 or -11 or -12 or -13 )
			{
				continue;
			}
			rfalse;
		}
	];
-).

Vorple Modal Windows ends here.


---- DOCUMENTATION ----

A modal window is a screen that pops up on top of the interpreter with text content and a button that closes the modal.


Chapter: Simple modals

A modal window with plain text content can be created with:
	
	show a modal window reading "Hello World!";
	
The modal pops up with the text and an OK button and waits for the player to either click on the button, press enter, space or esc, or click somewhere outside the modal window.

By default the game will pause to wait for the user to dismiss the modal window. This behavior can be switched off with a "without pausing" option:

	show a modal window reading "Merry Christmas!", without pausing;
	say "And a happy new year!";

In the above example the modal doesn't pause the game, so the player can see the text "And a happy new year" printed immediately in the game's normal text flow below the modal window. Without the "without pausing" option the text would appear only after dismissing the modal.


Chapter: Modals with styled content

The "show a modal window reading ..." lets us show only plain text, but if we want more complex content, we can open the modal without any content and then redirect all following output to it. Anything between phrases "set output focus to the modal window" and "set output focus to the main window" is printed inside the modal.

	show a modal window;
	set output focus to the modal window;
	say "[bold type]Welcome![roman type]";
	place the image "Cover.jpg" with description "Cover page", centered;
	set output focus to the main window;
	wait for any key;

("Place the image" phrase is from the Vorple Multimedia extension.)

Note that when creating a modal window this way we should "wait for any key" after creating the modal so that the game pauses to wait for the player to act.


Example: * The Greeter - Showing a modal at the start of the play
	
This basic example pops up the modal when the play begins and displays the story title and some basic gameplay instructions.

	*: "The Greeter"
	
	Include Vorple Modal Windows by Juhana Leinonen.
	Release along with the "Vorple" interpreter.
	
	There is a room.
	
	When play begins:
		show a modal window reading "Welcome to [story title]! Use LOOK to look around, EXAMINE what you see, and TAKE what you can!".


Example: ** Version Popup - Show the version information in a modal window

We have two rules here that cause the normal banner to show in a modal instead of in the story text. The first check rule shows a modal window and sets the output focus to it. From then on everything that the game prints (the banner, in this case) will be printed inside the modal. The second report rule runs after the banner has been printed, resuming output back to the normal flow of the game text.
	
	*: "Version Popup"
	
	Include Vorple Modal Windows by Juhana Leinonen.
	Release along with the "Vorple" interpreter.
	
	There is a room.
	
	Check requesting the story file version:
		show a modal window;
		set output focus to the modal window.
		
	Report requesting the story file version:
		set output focus to the main window.
		
	Test me with "version".