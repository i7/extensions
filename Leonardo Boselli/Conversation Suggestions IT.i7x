Version 6 of Conversation Suggestions IT by Leonardo Boselli begins here.

"Translation in italian of Version 6 of Conversation Suggestions by Eric Eve.

Provides a means of suggesting topics of conversation to the player, either in response to a TOPICS command or when NPCs are greeted. This extension requires Conversation Framework. Version 3 makes use of Complex Listing by Emily Short if it's included in the same game rather than indexed text to generate a list of suggestions."

Book 1 - Includes

Include Conversation Suggestions by Eric Eve

Include Conversation Framework IT by Leonardo Boselli.

Book 2 - Definitions


Part 2 - The misc-suggestion Kind

Section H (for use with Hyperlink Interface IT by Leonardo Boselli)

When play begins:
	now the printed name of yes-suggestion is "dire [t]sì[x]";
	now the printed name of no-suggestion is "dire [t]no[x].";
	now the printed name of yes-no-suggestion is "dire [t]sì[x] o [t]no[x]";
	now the printed name of self-suggestion is "[regarding the current interlocutor]se [stesso]".

Section K (for use without Hyperlink Interface IT by Leonardo Boselli)

When play begins:
	now the printed name of yes-suggestion is "dire sì";
	now the printed name of no-suggestion is "dire no.";
	now the printed name of yes-no-suggestion is "dire sì o no";
	now the printed name of self-suggestion is "[regarding the current interlocutor]se [stesso]".


Book 3 - Rules

Part 2 - The Listing Suggested Topics Action

Understand "argomenti" or "argo" as listing suggested topics.

To say nothing specific:
   say "[Ora] non [regarding the player][hai] nulla di specifico da discutere con [the printed name of the current interlocutor]."


Chapter - Responses

can't suggest topics when not talking to anyone rule response (A) is "[Ora] non [regarding the player][stai] parlando con nessuno.".

The complex list suggested topics rule is not listed in any rulebook.
Carry out listing suggested topics (this is the italian complex list suggested topics rule):
	follow the suggestion list construction rules;
	let ask-suggs be the number of entries in sugg-list-ask;
	let tell-suggs be the number of entries in sugg-list-tell;
	let other-suggs be the number of entries in sugg-list-other;
	if ask-suggs + tell-suggs + other-suggs is 0:
		say "[nothing specific]" (A);
		rule succeeds;
	let sugg-rep be a text;
	say "[if topic-request is implicit]([end if][regarding the player][maiuscolo][Puoi][maiuscolo] " (B);
	if other-suggs > 0:
		let sugg-rep be "[sugg-list-other]";
		replace the regular expression "\band\b" in sugg-rep with "o";
		say "[sugg-rep][if tell-suggs + ask-suggs > 0]; o [end if]" (C);
	if ask-suggs > 0:
		say "chiedere [ap the current interlocutor] " (D);
		let CT be 0;
		repeat with TT running through sugg-list-ask:
			say "[dip the TT]" (E);
			increment CT;
			if CT < ask-suggs - 1:
				say ", " (F);
			otherwise if CT < ask-suggs:
				say " o " (G);
		say "[if tell-suggs > 0]; o [end if]" (H);
	if tell-suggs > 0:
		say "parlare [ap the current interlocutor] " (I);
		let CT be 0;
		repeat with TT running through sugg-list-tell:
			say "[dip the TT]" (J);
			increment CT;
			if CT < tell-suggs - 1:
				say ", ";
			otherwise if CT < tell-suggs:
				say " o ";
	say "[if topic-request is implicit].)[otherwise].[end if][paragraph break]" (K).


Conversation Suggestions IT ends here.

---- DOCUMENTATION ----

Read the original documentation of Version 6 of Conversation Suggestions by Eric Eve.
