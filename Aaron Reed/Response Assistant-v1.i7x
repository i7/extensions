Version 1 of Response Assistant by Aaron Reed begins here.

"Adds some helpful testing commands for changing default responses."

Part - Response Assistant (not for release)

Chapter - Actions

Section - Response Tracking

Response tracking is an action out of world applying to nothing. Understand "track responses" as response tracking. Carry out response tracking: say "Now tracking responses. Type 'track off' to disable."; now tracking responses is true.

Section - Disabling Response Tracking

Disabling response tracking is an action out of world applying to nothing. Understand "track off" as disabling response tracking. Carry out disabling response tracking: say "Response tracking off."; now tracking responses is false.

Section - Requesting Response Info

Requesting response info is an action out of world applying to one number. Understand "response [number]" as requesting response info.

Carry out requesting response info:
	let x be the number understood;
	let resp be entry x of recent responses;
	say "[bold type][resp][roman type]";
	say "[paragraph break]Currently:[line break]";
	suppress_text_substitution;
	say "[text of resp]";
	reinstate_text_substitution;
	say "[paragraph break]To change, copy and pase the following line into your source:[line break]The [resp] is 'New response text.'[first time][line break]* Note: if this response was defined in your own source text, of course, it's easier to change it by searching for the text in your project and updating the original.[only]";

Chapter - Variables

Tracking responses is initially false.

Recent responses is a list of responses variable.

[Note: the below won't work for commands that are interrupt the normal parsing sequence, like OOPS, but it's not really a big deal.]
After reading a command when the player's command does not include "response" (this is the Response Assistant reset responses list rule):
	truncate recent responses to 0 entries.

Chapter - Reporting

Before issuing the response text of a response (called R) when tracking responses is true and we are not requesting response info (this is the Response Assistant before showing response text rule):
	say "[bracket]".

After issuing the response text of a response (called R) when tracking responses is true and we are not requesting response info (this is the Respose Assistant after showing response text rule):
	add R to recent responses;
	let N be the number of entries in recent responses;
	say " - [italic type]";
	if N is 1:
		say "type 'response [N]' for details";
	else:
		say "response [N]";
	say "[roman type][close bracket]".

Chapter - Inform 6 Hooks

To suppress_text_substitution: (- SuppressTextSub(); -).
To reinstate_text_substitution: (- ReinstateTextSub(); -).

Include (- [SuppressTextSub; suppress_text_substitution = true; ]; -) after "Tests.i6t".
Include (- [ReinstateTextSub; suppress_text_substitution = false; ]; -) after "Tests.i6t".

Response Assistant ends here.

---- DOCUMENTATION ----

This extension makes it easier to adjust responses from the Standard Rules or extensions. Type "track responses" to append each response seen with a numbered tag. You can then type "response 1" (and so on) to see details about the current form of the message, and a template you can copy and paste in your source text to change it. Type "track off" to stop tracking responses.

The entire extension is marked "not for release", so it can safely be left in a released project without affecting its functionality or file size.

More information about responses can be found in the "Adapative Text and Responses" chapter on the "Documentation" pane. As a reminder, you can list all the responses associated with the Standard Rules or a particular extension via the testing command RESPONSES, or see all responses associated with a particular action on the Index pane, Actions tab, by clicking a specific action and then clicking the speech bubble icon at the bottom of the action listing.

