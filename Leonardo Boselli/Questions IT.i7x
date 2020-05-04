Version 4 of Questions IT by Leonardo Boselli begins here.

"Basato su Version 4 of Questions by Michael Callaghan."

"An extension to allow us to suspend normal parser input to receive and respond to answers to questions."

Chapter 1 - Global provisions for asking questions

Section 1 - Variables for asking questions

Current question is text that varies.
Current prompt is text that varies.
Saved prompt is text that varies.
Current question menu is a list of text that varies.
Current answer is indexed text that varies.

Section 2 - Default command line prompts for asking questions

Closed number prompt is text that varies.  Closed number prompt is "Inserisci un numero >".
Open number prompt is text that varies.  Open number prompt is ">".

Closed menu prompt is text that varies.  Closed menu prompt is "Inserisci un numero tra 1 e [number of entries in current question menu] >".
Open menu prompt is text that varies.  Open menu prompt is ">".

Closed yes/no prompt is text that varies.  Closed yes/no prompt is "Inserisci S o N (Sì o No) >".
Open yes/no prompt is text that varies.  Open yes/no prompt is ">".

Closed gender prompt is text that varies.  Closed gender prompt is "Inserisci M, F o N (Maschio, Femmina e Neutro) >".
Open gender prompt is text that varies.  Open gender prompt is ">".

Closed text prompt is text that varies.  Closed text prompt is "Inserisci la tua risposta >".
Open text prompt is text that varies.  Open text prompt is ">".

Section 3 - Flag to determine if the question is open or closed

Closed question mode is a truth state that varies.

Section 4 - Phrase used to ask questions in closed mode

To ask a closed question, in number mode, in menu mode, in yes/no mode, in gender mode or in text mode:
	now closed question mode is true;
	now saved prompt is the command prompt;
	if in number mode:
		if current prompt is "":
			now the command prompt is the closed number prompt;
		otherwise:
			now the command prompt is the current prompt;
		now number question mode is true;
	if in menu mode:
		if current prompt is "":
			now the command prompt is the closed menu prompt;
		otherwise:
			now the command prompt is the current prompt;
		now menu question mode is true;
	if in yes/no mode:
		if current prompt is "":
			now the command prompt is the closed yes/no prompt;
		otherwise:
			now the command prompt is the current prompt;
		now yes/no question mode is true;
	if in gender mode:
		if current prompt is "":
			now the command prompt is the closed gender prompt;
		otherwise:
			now the command prompt is the current prompt;
		now gender question mode is true;
	if in text mode:
		if current prompt is "":
			now the command prompt is the closed text prompt;
		otherwise:
			now the command prompt is the current prompt;
		now text question mode is true;
	if current question is not "":
		say "[current question][line break]";
	if in menu mode:
		repeat with counter running from 1 to the number of entries in the current question menu:
			say "[counter] - [entry counter of the current question menu][line break]".

Section 5 - Phrase used to ask questions in open mode

To ask an open question, in number mode, in menu mode, in yes/no mode, in gender mode or in text mode:
	now closed question mode is false;
	now saved prompt is the command prompt;
	if in number mode:
		if current prompt is "":
			now the command prompt is the open number prompt;
		otherwise:
			now the command prompt is the current prompt;
		now number question mode is true;
	if in menu mode:
		if current prompt is "":
			now the command prompt is the open menu prompt;
		otherwise:
			now the command prompt is the current prompt;
		now menu question mode is true;
	if in yes/no mode:
		if current prompt is "":
			now the command prompt is the open yes/no prompt;
		otherwise:
			now the command prompt is the current prompt;
		now yes/no question mode is true;
	if in gender mode:
		if current prompt is "":
			now the command prompt is the open gender prompt;
		otherwise:
			now the command prompt is the current prompt;
		now gender question mode is true;
	if in text mode:
		if current prompt is "":
			now the command prompt is the open text prompt;
		otherwise:
			now the command prompt is the current prompt;
		now text question mode is true;
	if current question is not "":
		say "[current question][line break]";
	if in menu mode:
		repeat with counter running from 1 to the number of entries in the current question menu:
			say "[counter] - [entry counter of the current question menu][line break]".

Chapter 2 - Questions that require a number answer

Section 1 - Flag to set number question mode

Number question mode is a truth state that varies.

Section 2 - Action for number questions

Number questioning is an action applying to one number.

Understand "[number]" as number questioning when number question mode is true.
Understand "dici [number]" as number questioning when number question mode is true.

Section 3 - Rules for number questions

Number question rules is a rulebook.

The number question rules have outcomes exit (success), retry (failure) and parse (failure).

The first number question rule (this is the invalid number reply rule):
	if the player's command does not match "[number]":
		if closed question mode is true:
			retry;
		if closed question mode is false:
			parse.

The last number question rule (this is the default number question rule):
	exit.

Section 4 - Processing number questions

After reading a command when number question mode is true:
	follow the number question rules;
	if the outcome of the rulebook is the exit outcome:
		deactivate number question mode;
		follow the every turn rules;
		follow the advance time rule;
		reject the player's command;
	if the outcome of the rulebook is the retry outcome:
		reject the player's command;
	if the outcome of the rulebook is the parse outcome:
		deactivate number question mode.

Section 5 - To deactivate number question mode

To deactivate number question mode:
	now the Command Prompt is the saved prompt;
	now the Current Prompt is "";
	now number question mode is false.

Chapter 3 - Questions that require an answer from a menu

Section 1 - Flag to set menu question mode

Menu question mode is a truth state that varies.

Section 2 - Action for menu questions

Menu questioning is an action applying to one number.

Understand "[number]" as menu questioning when menu question mode is true.
Understand "dici [number]" as menu questioning when menu question mode is true.

Section 3 - Rules for menu questions

Menu question rules is a rulebook.

The menu question rules have outcomes exit (success), retry (failure) and parse (failure).

The first menu question rule (this is the invalid menu reply rule):
	if the player's command does not match "[number]":
		if closed question mode is true:
			retry;
		if closed question mode is false:
			parse;
	if the number understood is less than 1:
		retry;
	if the number understood is greater than the number of entries in the current question menu:
		retry.

The last menu question rule (this is the default menu question rule):
	exit.

Section 4 - Processing menu questions

After reading a command when menu question mode is true:
	follow the menu question rules;
	if the outcome of the rulebook is the exit outcome:
		deactivate menu question mode;
		follow the every turn rules;
		follow the advance time rule;
		reject the player's command;
	if the outcome of the rulebook is the retry outcome:
		reject the player's command;
	if the outcome of the rulebook is the parse outcome:
		deactivate menu question mode.

Section 5 - To deactivate menu question mode

To deactivate menu question mode:
	now the Command Prompt is the saved prompt;
	now the Current Prompt is "";
	now menu question mode is false.

Chapter 4 - Questions that require a yes/no answer

Section 1 - Flag to set yes/no question mode

Yes/no question mode is a truth state that varies.

Section 2 - Value for use with yes/no questions

Decision is a kind of value.  The decisions are Yes and No.

Understand "S" as Yes when yes/no question mode is true.
Understand "N" as No when yes/no question mode is true.

Section 3 - Action for yes/no questions

Yes/no questioning is an action applying to one decision.

Understand "[decision]" as yes/no questioning when yes/no question mode is true.
Understand "dici [decision]" as yes/no questioning when yes/no question mode is true.

Section 4 - Rules for yes/no questions

Yes/no question rules is a rulebook.

The yes/no question rules have outcomes exit (success), retry (failure) and parse (failure).

The first yes/no question rule (this is the invalid yes/no reply rule):
	if the player's command does not match "[decision]":
		if closed question mode is true:
			retry;
		if closed question mode is false:
			parse.

The last yes/no question rule (this is the default yes/no question rule):
	exit.

Section 5 - Processing yes/no questions

After reading a command when yes/no question mode is true:
	follow the yes/no question rules;
	if the outcome of the rulebook is the exit outcome:
		deactivate yes-no question mode;
		follow the every turn rules;
		follow the advance time rule;
		reject the player's command;
	if the outcome of the rulebook is the retry outcome:
		reject the player's command;
	if the outcome of the rulebook is the parse outcome:
		deactivate yes-no question mode.

Section 6 - To deactivate yes/no question mode

To deactivate yes-no question mode:
	now the Command Prompt is the saved prompt;
	now yes/no question mode is false.

Chapter 5 - Questions that require a gender answer

Section 1 - Flag to set gender question mode

Gender question mode is a truth state that varies.

Section 2 - Value for use with gender questions

Gender is a kind of value.  The genders are Masculine, Feminine and Neutral.

Understand "M" as Masculine when gender question mode is true.
Understand "F" as Feminine when gender question mode is true.
Understand "N" as Neutral when gender question mode is true.

Section 3 - Action for gender questions

Gender questioning is an action applying to one gender.

Understand "[gender]" as gender questioning when gender question mode is true.
Understand "dici [gender]" as gender questioning when gender question mode is true.

Section 4 - Rules for gender questions

Gender question rules is a rulebook.

The gender question rules have outcomes exit (success), retry (failure) and parse (failure).

The first gender question rule (this is the invalid gender reply rule):
	if the player's command does not match "[gender]":
		if closed question mode is true:
			retry;
		if closed question mode is false:
			parse.

The last gender question rule (this is the default gender question rule):
	exit.

Section 5 - Processing gender questions

After reading a command when gender question mode is true:
	follow the gender question rules;
	if the outcome of the rulebook is the exit outcome:
		deactivate gender question mode;
		follow the every turn rules;
		follow the advance time rule;
		reject the player's command;
	if the outcome of the rulebook is the retry outcome:
		reject the player's command;
	if the outcome of the rulebook is the parse outcome:
		deactivate gender question mode.

Section 6 - To deactivate gender question mode

To deactivate gender question mode:
	now the Command Prompt is the saved prompt;
	now the Current Prompt is "";
	now gender question mode is false.

Chapter 6 - Questions that require a text answer

Section 1 - Flag to set text question mode

Text question mode is a truth state that varies.
Punctuation removal is a truth state that varies.

Section 2 - Action for text questions

Text questioning is an action applying to one topic.

Understand "[text]" as text questioning when text question mode is true.
Understand "dici [text]" as text questioning when text question mode is true.

Section 3 - Rules for text questions

Text question rules is a rulebook.

The text question rules have  outcomes exit (success), retry (failure) and parse (failure).

The first text question rule (this is the remove punctuation from text questions rule):
	if punctuation removal is true:
		replace the regular expression "\p" in the current answer with "";

The last text question rule (this is the default text question rule):
	if closed question mode is true:
		retry;
	if closed question mode is false:
		parse.

Section 4 - Processing text questions

After reading a command when text question mode is true:
	now the current answer is the player's command;
	replace the regular expression "^dici " in the current answer with "", case insensitively;
	follow the text question rules;
	if the outcome of the rulebook is the exit outcome:
		deactivate text question mode;
		follow the every turn rules;
		follow the advance time rule;
		reject the player's command;
	if the outcome of the rulebook is the retry outcome:
		reject the player's command;
	if the outcome of the rulebook is the parse outcome:
		deactivate text question mode.

Section 5 - To deactivate text question mode

To deactivate text question mode:
	now the Command Prompt is the saved prompt;
	now the Current Prompt is "";
	now text question mode is false.

Chapter 7 - Real number question mode (for use with Fixed Point Maths by Michael Callaghan)

Section 1 - Default command line prompts for real numbers

Closed real number prompt is text that varies.  Closed real number prompt is "Inserisci un numero >".
Open real number prompt is text that varies.  Open real number prompt is ">".

Section 2 - Phrase to ask a real number question in closed mode

To ask a closed question in real number mode:
	now closed question mode is true;
	now saved prompt is the command prompt;
	if current prompt is "":
		now the command prompt is the closed real number prompt;
	otherwise:
		now the command prompt is the current prompt;
	now real number question mode is true;
	if current question is not "":
		say "[current question][line break]".

Section 3 - Phrase to ask a real number question in open mode

To ask an open question in real number mode:
	now closed question mode is false;
	now saved prompt is the command prompt;
	if current prompt is "":
		now the command prompt is the open real number prompt;
	otherwise:
		now the command prompt is the current prompt;
	now real number question mode is true;
	if current question is not "":
		say "[current question][line break]".

Section 4 - Flag for real number question mode

Real number question mode is a truth state that varies.

Section 5 - Action for real number questions

Real number questioning is an action applying to one real number.

Understand "[real number]" as real number questioning when real number question mode is true.
Understand "dici [real number]" as real number questioning when real number question mode is true.

Section 6 - Answer form for real numbers

Current number is a real number that varies.

Section 7 - Rules for real number questions

Real number question rules is a rulebook.

The real number question rules have outcomes exit (success), retry (failure) and parse (failure).

The first real number question rule (this is the invalid real number reply rule):
	let T be indexed text;
	let T be the player's command;
	replace the regular expression "^dici " in T with "", case insensitively;
	now the current number is the number derived from T;
	if invalid conversion is true:
		if closed question mode is true:
			retry;
		if closed question mode is false:
			parse.

The last real number question rule (this is the default real number question rule):
	exit.

Section 7 - Processing real number questions

After reading a command when real number question mode is true:
	follow the real number question rules;
	if the outcome of the rulebook is the exit outcome:
		deactivate real number question mode;
		follow the every turn rules;
		follow the advance time rule;
		reject the player's command;
	if the outcome of the rulebook is the retry outcome:
		reject the player's command;
	if the outcome of the rulebook is the parse outcome:
		deactivate real number question mode.

Section 8 - To deactivate real number question mode

To deactivate real number question mode:
	now the Command Prompt is the saved prompt;
	now the Current Prompt is "";
	now real number question mode is false.

Chapter 8 - To decide if we are in question mode

Section 1 - Basic decision (for use without Fixed Point Maths by Michael Callaghan)

To decide if we are asking a question:
	if number question mode is true:
		decide yes;
	if menu question mode is true:
		decide yes;
	if yes/no question mode is true:
		decide yes;
	if gender question mode is true:
		decide yes;
	if text question mode is true:
		decide yes;
	decide no.

Section 2 - Extended decision (for use with Fixed Point Maths by Michael Callaghan)

To decide if we are asking a question:
	if number question mode is true:
		decide yes;
	if menu question mode is true:
		decide yes;
	if yes/no question mode is true:
		decide yes;
	if gender question mode is true:
		decide yes;
	if text question mode is true:
		decide yes;
	if real number question mode is true:
		decide yes;
	decide no.

Questions IT ends here.

---- DOCUMENTATION ----

Leggi la documentazione originale di Version 4 of Questions by Michael Callaghan.
