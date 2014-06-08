Version 6 of Conversation Suggestions IT by Leonardo Boselli begins here.

"Translation in italian of Version 6 of Conversation Suggestions by Eric Eve.

Provides a means of suggesting topics of conversation to the player, either in response to a TOPICS command or when NPCs are greeted. This extension requires Conversation Framework. Version 3 makes use of Complex Listing by Emily Short if it's included in the same game rather than indexed text to generate a list of suggestions."

Book 1 - Includes

Include Conversation Suggestions by Eric Eve

Include Conversation Framework IT by Leonardo Boselli.

Book 2 - Definitions


Part 2 - The misc-suggestion Kind

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
    complex list suggested topics rule response (A) is "[nothing specific]".
    complex list suggested topics rule response (B) is "[if topic-request is implicit]([end if][regarding the player][puoi] ".
    complex list suggested topics rule response (C) is "[sugg-rep][if tell-suggs + ask-suggs > 0], o [end if]".
    complex list suggested topics rule response (D) is "chiedere [ap the current interlocutor] di [sugg-rep][if tell-suggs > 0], o [end if]".
    complex list suggested topics rule response (E) is "parlare [ap the current interlocutor] di [sugg-rep]".
    complex list suggested topics rule response (F) is "[if topic-request is implicit])[otherwise].[end if][paragraph break]".


Conversation Suggestions IT ends here.

---- DOCUMENTATION ----

Read the original documentation of Version 6 of Conversation Suggestions by Eric Eve.
