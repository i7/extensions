Version 2/140430 of Vorple Notifications (for Z-Machine only) by Juhana Leinonen begins here.

"Notifications and dialogs."

Include Vorple by Juhana Leinonen.
Use authorial modesty.

Chapter 1 - Locations

An element position has some text called noty name. 

The noty name of top banner is "top".
The noty name of bottom banner is "bottom".
The noty name of top left is "topLeft".
The noty name of top center is "topCenter".
The noty name of top right is "topRight".
The noty name of center left is "centerLeft".
The noty name of screen center is "center".
The noty name of center right is "centerRight".
The noty name of bottom left is "bottomLeft".
The noty name of bottom center is "bottomCenter".
The noty name of bottom right is "bottomRight".


Chapter 2 - Vorple wrappers

To show notification (msg - text):
	execute JavaScript command "vorple.notify.show('[escaped msg]')";
	add msg to the displayed notifications.

To hide all/-- notifications:
	execute JavaScript command "vorple.notify.closeAll()".

To show notification (msg - text) at/in (pos - element position):
	execute JavaScript command "vorple.notify.show('[escaped msg]',{layout:'[noty name of pos]'})";
	add msg to the displayed notifications.

To show alert (msg - text):
	execute JavaScript command "vorple.notify.alert('[escaped msg]')";
	add msg to the displayed notifications.

To set the/-- default notification position to (pos - element position):
	execute JavaScript command "vorple.notify.defaults.layout='[noty name of pos]'".


Chapter 3 - Fallback

Displayed notifications is a list of text that varies.

Before reading a command (this is the print notifications fallback rule):
	if Vorple is not supported:
		repeat with note running through displayed notifications:
			say "[italic type][bracket]" (A);
			say note;
			say "[close bracket][roman type][paragraph break]" (B).

Before reading a command (this is the empty displayed notifications list rule):
	truncate displayed notifications to 0 entries.


Vorple Notifications ends here.


---- DOCUMENTATION ----

Chapter: Notifications

Notifications are messages that show briefly on the screen and then fade away. A notification can be displayed simply with:

	show notification "Hello World!";


Chapter: Positioning

There are 11 possibilities for positioning notifications: top banner, bottom banner, top left, top center, top right, center left, center, center right, bottom left, bottom center, and bottom right. The default position is bottom right. It can be changed individually:

	show notification "Up here!" in top banner;

...or globally:

	*: When play begins:
		set the default notification position to top banner.


Chapter: Alerts

An alert is a notification that comes with an "OK" button that must be clicked to dismiss the notification. It's always in the middle of the screen.

	When play begins:
		show alert "If you need assistance, type HELP at the prompt."


Chapter: Clearing notifications

Multiple notifications are shown on the screen at the same time; a new notification in the same position pushes the old notification down (or up) if it hasn't had time to clear away yet. Sometimes you might want to make sure that the old notifications are cleared before showing new ones. All notifications currently on the screen can be removed with:

	hide notifications;


Chapter: Fallback

If Vorple isn't available, the fallback is to display the notifications at the end of turn as plain text. The feature can be overridden by checking Vorple's availability:

	if Vorple is available:
		show notification "Click on your inventory items to examine them more closely";
	otherwise:
		say "Type EXAMINE followed by an inventory item's name to examine them more closely.";
		
	if Vorple is available:
		show notification "Welcome to Vorple-enhanced [story title]!";

The default fallback can also be turned off completely:

	*: The print notifications fallback rule is not listed in any rulebook.


Example: * How To I - Showing small tips to new players who might not be familiar with the standard IF conventions.

	*: "How To I"
	
	Include Vorple Notifications by Juhana Leinonen.  
	Release along with the "Vorple" interpreter.

	Lab is a room. "You're in a fancy laboratory."
	Corridor is north of lab.

	A test tube is in the lab.
	A trolley is in the lab. It is pushable between rooms.

	When play begins:
		show notification "Type LOOK (or just L) to see the room description again".

	After taking something for the first time:
		show notification "Type INVENTORY (or just I) to see a list of what you're carrying";
		continue the action.

	After examining the trolley for the first time:
		show notification "You can push the trolley between rooms by commanding PUSH TROLLEY followed by a compass direction".

	After reading a command when the player's command includes "examine":
		show notification "Tip: You can abbreviate EXAMINE to just X".
			
	Test me with "take test tube / examine test tube / x trolley".


Example: ** Score Notifications - A visual notification when the player is awarded points.

We'll create a rule that will show the score change as a Vorple notification, or use the original score notification rule if the game is being played in a non-Vorple interpreter.
	
	*: "Score Notifications"
	
	Include Vorple Notifications by Juhana Leinonen.
	Release along with the "Vorple" interpreter.
	
	Use scoring. The maximum score is 5.
	
	
	Chapter 1 - New score notifications
	
	To say score notification message:
		(- NotifyTheScore(); -).
	
	This is the enhanced notify score changes rule:
		if Vorple is supported:
			if the last notified score is not the score:
				show notification "[score notification message]" at top center;
				now the last notified score is the score;
		otherwise:
			follow the notify score changes rule.
	
	The enhanced notify score changes rule is listed instead of the notify score changes rule in the turn sequence rulebook.
	
	
	Chapter 2 - Treasure chamber
	
	Treasure Chamber is a room. "Wealth beyond your dreams is piled all over this room."
	
	A valuable is a kind of thing. The pearls, gold coins, diamonds, rubies and emeralds are plural-named valuables in the Treasure Chamber. 
	
	Carry out taking a valuable when the noun is not handled (this is the award points for finding valuables rule):
		increase the score by one.
	
	Test me with "take coins / take diamonds and rubies / take all".
