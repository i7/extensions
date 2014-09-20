Version 1/140824 of MilleUna Conversation by Leonardo Boselli begins here.

"The part of the MilleUna Framework that manages conversations."

Include Conversation Package by Eric Eve.


Part - Conversation

Chapter 1 - Highlighting

First when play begins:
	now topic hyperlink highlighting is true;

Chapter 2 - Discussions

A thing can be discussable or speakable or unspeakable. A thing is usually unspeakable.

Instead of examining a speakable thing (called the argument) when the current interlocutor is a person:
	if the argument is listed in the ask-suggestions of the node of the current interlocutor:
		try quizzing the current interlocutor about the argument;
	otherwise if the argument is listed in the tell-suggestions of the node of the current interlocutor:
		try informing the current interlocutor about the argument;
	otherwise:
		continue the action.

Instead of examining a discussable thing (called the argument):
	if the current interlocutor is a person:
		if the argument is listed in the ask-suggestions of the node of the current interlocutor:
			try quizzing the current interlocutor about the argument;
		otherwise if the argument is listed in the tell-suggestions of the node of the current interlocutor:
			try informing the current interlocutor about the argument;
		otherwise:
			say "[arg-discusso argument]";
	otherwise:
		say "[arg-discusso argument]".

To say arg-discusso (argument - a discussable thing):
	say "[The argument] [are] a topic of conversation.[list-topics]"

To say list-topics:
	try silently listing suggested topics.

Section H (for use with Hyperlink Interface by Leonardo Boselli)

To say nothing specific:
   say "[We] [have] nothing to discuss with [the current interlocutor]. [We] [can] say [t]goodbye[x]."

Section K (for use without Hyperlink Interface by Leonardo Boselli)

To say nothing specific:
   say "[We] [have] nothing to discuss with [the current interlocutor]. [We] [can] say goodbye."

Section Common

Definition: a person is hailable if it is not the player and it is not an animal and it is visible.
Check hailing (this is the new check what's being hailed rule):
	if the current interlocutor is a visible person:
		if the current interlocutor is the nearest-person:
			say "[We] [are] already talking to [the current interlocutor]." (A) instead;
		otherwise:
			now the farewell type is implicit;
			try silently leavetaking;
			now the farewell type is explicit;
	now the noun is the nearest-person;
	if the nearest-person is not a person,
		now the noun is a random hailable person;
	if the noun is a person:
		say "(talking to [the noun])" (B);
	otherwise:
		say "[We] [are] alone [here]." (C) instead.

The check what's being hailed rule is not listed in any rulebook.

Chapter 3 - Hyperlinked Suggestions

To list-topics-please:
	say "[line break]";
	now the topic-request is implicit;
	try silently listing suggested topics;
	say "[run paragraph on]".

Section H (for use with Hyperlink Interface by Leonardo Boselli)

When play begins:
	now the printed name of yes-suggestion is "say [t]yes[x]";
	now the printed name of no-suggestion is "say [t]no[x].";
	now the printed name of yes-no-suggestion is "say [t]yes[x] or [t]no[x]";
	now the printed name of self-suggestion is "[regarding the current interlocutor][themselves]".

Section Common

The complex list suggested topics rule is not listed in any rulebook.
Carry out listing suggested topics (this is the hyperlink complex list suggested topics rule):
	follow the suggestion list construction rules;
	let ask-suggs be the number of entries in sugg-list-ask;
	let tell-suggs be the number of entries in sugg-list-tell;
	let other-suggs be the number of entries in sugg-list-other;
	if ask-suggs + tell-suggs + other-suggs is 0:
		say "[nothing specific]" (A);
		rule succeeds;
	let sugg-rep be a text;
	say "[if topic-request is implicit]([end if][We] [could] " (B);
	if other-suggs > 0:
		let sugg-rep be "[sugg-list-other]" (C);
		replace the regular expression "\band\b" in sugg-rep with "or";
		say "[sugg-rep][if tell-suggs + ask-suggs > 0]; or [end if]" (D);
	if ask-suggs > 0:
		say "ask [regarding the current interlocutor][them] about " (E);
		let CT be 0;
		repeat with TT running through sugg-list-ask:
			say "the [emphasize TT]" (F);
			increment CT;
			if CT < ask-suggs - 1:
				say ", " (G);
			otherwise if CT < ask-suggs:
				say " or " (H);
		say "[if tell-suggs > 0]; or [end if]" (I);
	if tell-suggs > 0:
		say "tell [regarding the current interlocutor][them] about " (J);
		let CT be 0;
		repeat with TT running through sugg-list-tell:
			say "the [emphasize TT]" (K);
			increment CT;
			if CT < tell-suggs - 1:
				say ", " (L);
			otherwise if CT < tell-suggs:
				say " or " (M);
	say "[if topic-request is implicit].)[otherwise].[end if][paragraph break]" (N).

Section H (for use with Hyperlink Interface by Leonardo Boselli)

To say emphasize (TT - an object):
	say "[t][TT][x]";

Section K (for use without Hyperlink Interface by Leonardo Boselli)

To say emphasize (TT - an object):
	say "[TT]";


Chapter END

MilleUna Conversation ends here.

---- Documentation ----

This is part of the MilleUna Framework, that contains all is needed to write interactive fiction readable online and playable clicking hyperlinks.
Visit http://youdev.it/page/MilleUna-Framework to know more.