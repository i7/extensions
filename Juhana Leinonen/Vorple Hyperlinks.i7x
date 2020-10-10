Version 2/140430 of Vorple Hyperlinks (for Z-Machine only) by Juhana Leinonen begins here.

"Hyperlinks that either open a web site or execute a parser command."

Include Vorple by Juhana Leinonen.
Use authorial modesty.

To place a/-- link to a/the/-- web site (url - text) reading (txt - text), in the same window:
	let id be unique identifier;
	place "a" element called "[id] webLink" reading txt;
	execute JavaScript command "$('.[id]').attr('href','[escaped url]')";
	if not in the same window:
		execute JavaScript command "$('.[id]').attr('target','_blank')";
	if Vorple is not supported:
		say txt.
		
To place a/-- link to a/the/-- web site (url - text), in the same window:
	if in the same window:
		place a link to the web site url reading url, in the same window;
	otherwise:
		place a link to the web site url reading url.

To place a/-- link to a/the/-- command (cmd - text) reading (txt - text), without showing the command and/or without showing the response:
	let id be unique identifier;
	let classes be "[id] commandLink";
	if without showing the command:
		let classes be "[classes] hideCommand";
	if without showing the response:
		let classes be "[classes] hideResponse";
	place "a" element called classes reading txt;
	execute JavaScript command "$('.[id]').attr('href','[escaped cmd]')";
	if Vorple is not supported:
		say txt.
		
To place a/-- link to a/the/-- command (cmd - text), without showing the command and/or without showing the response:
	if without showing the command and without showing the response:
		place a link to the command cmd reading cmd, without showing the command and without showing the response;
	otherwise if without showing the command:
		place a link to the command cmd reading cmd, without showing the command;
	otherwise if without showing the response:
		place a link to the command cmd reading cmd, without showing the response;
	otherwise:
		place a link to the command cmd reading cmd.

Vorple Hyperlinks ends here.


---- DOCUMENTATION ----


A hyperlink can link to either a web URL or clicking on it can trigger a command that's sent to the parser. 

Hyperlinks open web pages in new browser windows. The URLs should include the "http://" (or "https://") prefix.

	place a link to web site "http://vorple-if.com" reading "Vorple web page";

The link can be opened in the same window by passing an option:

	place a link to web site "http://vorple-if.com" reading "Vorple web page", in the same window;

Links to commands by default work just as if they would have been typed on the prompt.

	place a link to command "open door" reading "door";

Leaving out the text content will print the link target instead (so you don't have to write 'place a link to "ask the custodian about the missing artifacts" reading "ask the custodian about the missing artifacts"' and so on).

	say "Feel free to ";
	place a link to command "look";
	say " around.";

Options "without showing the command" and "without showing the response" do exactly that: run the command but don't show it or the story's response.

	place a link to command "inventory" reading "my stuff", without showing the command;
	place a link to command "__toggle_secrets" reading "super secret", without showing the command and without showing the response;

Suppressing both the command and the response is useful if the command triggers something only in the user interface or sends information to the story file that shouldn't give feedback to the reader.

If the story is run in a normal interpreter, the link description text is displayed but not the web site address (and of course clicking on the text won't do anything).


Example: * Click to Learn More - Hyperlinks to external web pages, email links and action links, with a fallback if Vorple is not available.

Email links ("mailto:") open an external mail program with the address pre-filled.

Note how we mark the action "normal" - otherwise the out of world action would be shown in a notification instead of in the normal story flow.


	*: "Click to Learn More"
	
	Include Vorple Hyperlinks by Juhana Leinonen.
	Release along with the "Vorple" interpreter.

	Lounge is a room.

	Getting information is an action out of world.
	Understand "about" and "info" as getting information.

	Carry out getting information:
		say "This fine story has been made possible by ";
		if Vorple is supported:
			place a link to web site "http://vorple-if.com" reading "Vorple";
		otherwise:
			say "Vorple (vorple-if.com)";
		say ". Please contact us at ";
		place a link to web site "mailto:if@example.com" reading "if@example.com";
		say ".";
		mark the current action "normal".

	After looking for the first time:
		say "(Type ";
		place a link to command "ABOUT";
		say " for more information.)[line break]".

	Test me with "about".
		
		
Example: ** Click to Retry - Clickable options when play ends.

If the story makes use of hyperlinks, we will probably want the options presented when the play ends be clickable as well. This example replaces the rule in the Standard Rules with one that prints the options as hyperlinks.

Because we can't print the topic entry that contains the actual command, we'll assume that the word written in all caps is the correct command.


	*: "Click to Retry"
	
	Chapter 1 - Clickable end of story options
 
	Include Vorple Hyperlinks by Juhana Leinonen.
	Release along with the "Vorple" interpreter.
	
	This is the clickable print the final question rule:
		let named options count be 0;
		repeat through the Table of Final Question Options:
			if the only if victorious entry is false or the story has ended finally:
				if there is a final response rule entry
					or the final response activity entry [activity] is not empty:
					if there is a final question wording entry, increase named options count by 1;
		if the named options count is less than 1, abide by the immediately quit rule;
		say "Would you like to " (A);
		repeat through the Table of Final Question Options:
			if the only if victorious entry is false or the story has ended finally:
				if there is a final response rule entry 
					or the final response activity entry [activity] is not empty:
					if there is a final question wording entry and final question wording entry matches the regular expression "<A-Z>{2,}":
						place a link to command text matching regular expression reading final question wording entry;
						decrease named options count by 1;
						if the named options count is 1:
							if the serial comma option is active, say ",";
							say " or " (B);
						otherwise if the named options count is 0:
							say "?[paragraph break]";
						otherwise:
							say ", ";
	
	The clickable print the final question rule is listed instead of the print the final question rule in the before handling the final question rulebook.
	
	
	Chapter 2 - Story
	
	The Treasury is a room.	The gem is in the treasury.
	
	After taking the gem:
		end the story finally.
		
	Test me with "take gem".

