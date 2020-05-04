Version 1/140824 of MilleUna Conversation IT by Leonardo Boselli begins here.

"The part of the MilleUna Framework that manages conversations. Translated in Italian."

Include MilleUna Conversation by Leonardo Boselli.
Include Conversation Package IT by Leonardo Boselli.


Part - Conversation

Chapter 2 - Discussions

The inst-ex-disc rule response (A) is "[arg-discusso-ita argument]".
The inst-ex-disc rule response (B) is "[arg-discusso-ita argument]".

To say arg-discusso-ita (argument - a discussable thing):
	say "[The argument] [sei] un argomento di discussione.[list-topics]"

Section H (for use with Hyperlink Interface by Leonardo Boselli)

To say nothing specific:
   say "Non [regarding the player][hai] nient[']altro in mente da discutere [conp the current interlocutor]. [regarding the player][maiuscolo][Puoi][maiuscolo] congedarti con un [t]addio[x]."

Section K (for use without Hyperlink Interface by Leonardo Boselli)

To say nothing specific:
   say "Non [regarding the player][hai] nient[']altro in mente da discutere [conp the current interlocutor]. [regarding the player][maiuscolo][Puoi][maiuscolo] congedarti con un addio."

Section Common

the new check what's being hailed rule response (A) is "[regarding the player][maiuscolo][Stai][maiuscolo] già parlando [conp the current interlocutor].".
the new check what's being hailed rule response (B) is "(rivolgendo[regarding the player][ti] [ap the noun])".
the new check what's being hailed rule response (C) is "[Qui] [regarding the player][ci sei] solo [tu].".

Chapter 3 - Hyperlinked Suggestions

Section H (for use with Hyperlink Interface by Leonardo Boselli)

When play begins:
	now the printed name of yes-suggestion is "dire [t]sì[x]";
	now the printed name of no-suggestion is "dire [t]no[x].";
	now the printed name of yes-no-suggestion is "dire [t]sì[x] o [t]no[x]";
	now the printed name of self-suggestion is "[regarding the current interlocutor]se [stesso]".

Section Common

The italian complex list suggested topics rule is not listed in any rulebook.

the hyperlink complex list suggested topics rule response (A) is "[nothing specific]".
the hyperlink complex list suggested topics rule response (B) is "[if topic-request is implicit]([end if][regarding the player][maiuscolo][Puoi][maiuscolo] ".
the hyperlink complex list suggested topics rule response (C) is "[sugg-list-other]".
the hyperlink complex list suggested topics rule response (D) is "[sugg-rep][if tell-suggs + ask-suggs > 0]; o [end if]".
the hyperlink complex list suggested topics rule response (E) is "chiedere [ap the current interlocutor] ".
the hyperlink complex list suggested topics rule response (F) is "[emphasize TT]".
the hyperlink complex list suggested topics rule response (G) is ", ".
the hyperlink complex list suggested topics rule response (H) is " o ".
the hyperlink complex list suggested topics rule response (I) is "[if tell-suggs > 0]; o [end if]".
the hyperlink complex list suggested topics rule response (J) is "parlare [ap the current interlocutor] ".
the hyperlink complex list suggested topics rule response (K) is "[emphasize TT]".
the hyperlink complex list suggested topics rule response (L) is ", ".
the hyperlink complex list suggested topics rule response (M) is " o ".
the hyperlink complex list suggested topics rule response (N) is "[if topic-request is implicit])[otherwise].[end if][paragraph break]".

Section H (for use with Hyperlink Interface by Leonardo Boselli)

To say emphasize (O - an object):
	let TT be "[dip the O]";
	if TT exactly matches the regular expression "dell['](.+)":
		say "dell['][t][text matching subexpression 1]";
	otherwise:
		say "[the word number 1 in TT] [t][the word number 2 in TT]";
		repeat with CT running from 3 to the number of words in TT:
			say " [the word number CT in TT]";
	say "[x]";

Chapter END

MilleUna Conversation IT ends here.

---- Documentation ----

This is part of the MilleUna Framework, that contains all is needed to write interactive fiction readable online and playable clicking hyperlinks.
Visit http://youdev.it/milleuna to know more.