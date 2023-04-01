Version 1 of Beta Test by Zed Lopez begins here.

"Automatically start transcript at beginning of game; accept comments with '*'
 without error messages."

[ *Not* designated 'for testing only' so that you can give testers what
  is otherwise the release version.

  Doesn't use authorial modesty so it shows up in the VERSION output
  to act as a reminder to remove it before the real release! ]

Use manual transcript start translates as (- Constant DONT_AUTOSTART_TRANSCRIPT = 1; -).

Volume Beta Test Notes

Section transcript helper phrases

To decide if the transcript is on: (- gg_scriptstr -).

To decide if the transcript is off: (- (~~(gg_scriptstr)) -).

Book beta test logging action

Beta Test Logging is an action out of world applying to one topic.

Part beta test logging action rules

Check beta test logging when the transcript is off (this is the beta transcribe before you proscribe rule):
  try switching the story transcript on.

Report beta test logging (this is the beta comment notation rule):
  say "Noted." (A).

Part beta test logging understanding

Understand "* [text]" as beta test logging.

Book beta test logging misunderstanding

Understand "*" as a mistake ("(Nothing noted.)").

Book conditional autostart

First when play begins when the manual transcript start option is not active
  (this is the conditionally autostart the transcript rule):
  try switching the story transcript on.

Part beta comment prompt reminder rule

Beta Test ends here.

---- Documentation ----

When this is included, the game will automatically prompt for a transcript file
at the start of the game *unless* you:

	use manual transcript start.

It facilitates the long-time standard of beta testers using '*' to leave
comments in the transcript, but with a polite "(Noted.)" instead of a
"That's not a verb I recognize." error.

If the transcript is not already on, upon the first use of '*', it's
automatically turned on.

Chapter Examples

Example: * "Betar late than never"

	*: "Betar late than never"

	Include Beta Test by Zed Lopez.
	Use manual transcript start.
	
	When play begins: say "big opening number."
	
	Lab is a room.
	
	Test me with "* / * hated the opening number / quit".

Example: * "You Beta Not Pout"

	*: "You Beta Not Pout"

	Include Beta Test by Zed Lopez.

	Last when play begins:
	  let dashes be "-------------------------------------------------------------------------[line break]";
	  say dashes;
	  say "*** Enter comments at the command prompt by starting them with [']*['], e.g.,[line break][line break]";
	  say ">* I think you meant 'xyzzy'[line break]";
	  say dashes;

	Lab is a room.
