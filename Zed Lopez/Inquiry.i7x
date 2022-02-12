Inquiry by Zed Lopez begins here.

"A framework for asking the user questions at startup
 (or subsequently)."

An inquiry is a kind of object.
An inquiry has a text called the answer.
An inquiry has a text called the description.
An inquiry can be answered or unanswered.
An inquiry can be key-input or line-input.

An optional inquiry is a kind of inquiry.
An optional inquiry is usually line-input. [ don't change ]

A y/n inquiry is a kind of inquiry.
A y/n inquiry is usually key-input. [ don't change ]
A y/n inquiry has a truth state called boolean-answer.

A multiple-choice inquiry is a kind of inquiry.
A multiple-choice inquiry has a list of texts called the multiple-choice-list.
A multiple-choice inquiry can be lettered or numbered.
A multiple-choice inquiry can be question-first or question-last.
A multiple-choice inquiry has a list of numbers called the choice-list.
The choice-list of a multiple-choice inquiry is usually {}.
A multiple-choice inquiry has a number called the extent.
A multiple-choice inquiry is usually key-input. [ switch to line-input as desired ]

To decide what number is the number of choices in/of (m - a multiple-choice inquiry):
  decide on the number of entries in the multiple-choice-list of m.

Definition: a y/n inquiry is confirmed rather than unconfirmed if it is answered and the boolean-answer of it is true.

The original-command-prompt is a text that varies.

Part inquiring activity

Inquiring something is an activity on inquiries.

Section multichoice list constants

[ lettered: after 26 choices, continue with numbers; start numbers at 0 if there are more than 35 choices;
  numbered: after 9 choices, continue with letters; start numbers at 0 if there are more than 35 choices;
]

letter35 is always { 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59 }. [ ascii for A-Z, 1-9 ]
letter36 is always { 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59 }. [ ascii for A-Z, 0-9 ]
number35 is always { 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90 }. [ ascii for 1-9, A-Z ]
number36 is always { 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59 }. [ ascii for 0-9, A-Z ]

To say (n - a number) as a char: (- print (char) {n}; -)

Chapter before rules

Before inquiring an unanswered multiple-choice inquiry (called q) (this is the list the multiple choices rule):
  if q is question-first, say "[the description of q][line break]";
  if choice-list of q is empty begin;
    if q is numbered begin;
      if the number of choices in q <= number of entries in number35, now choice-list of q is number35;
      else now choice-list of q is number36;
    else;
      if the number of choices in q <= number of entries in letter35, now choice-list of q is letter35;
      else now choice-list of q is letter36;
    end if;
    now extent of q is the number of entries in choice-list of q;
  end if;
  if the number of choices in q < extent of q, now extent of q is the number of choices in q;
  repeat with i running from 1 to extent of q begin;
    say "[entry i in choice-list of q as a char]. [entry i in the multiple-choice-list of q][line break]";
  end repeat;
  if q is question-last, say "[line break][the description of q] ";

Before inquiring a line-input inquiry (called q) when q is not a multiple-choice inquiry (this is the set command prompt for line-input question rule):
  now the command prompt is "[the description of the q] ";

Before inquiring a multiple-choice inquiry:
    now the command prompt is original-command-prompt.

For inquiring a key-input multiple-choice inquiry (called q):
   let choice be 0;
   let result be 0;
   while result is 0 begin;
     now choice is get key;
     if choice >= 97 and choice <= 122, now choice is choice - 32; [ lower case -> upper case ]
     repeat with i running from 1 to extent of q begin;
       if choice is entry i in the choice-list of q begin;
         now result is i;
         break;
       end if;
     end repeat;
   end while;
   say choice as a char;
   now the answer of q is entry result in the multiple-choice-list of q;
   now q is answered;

For inquiring a y/n inquiry (called q) (this is the ask y/n question rule):
  if the player agrees to "[the description of q] ", now the boolean-answer of q is true;
  now q is answered;

After inquiring an answered key-input inquiry: follow the scene changing rules.

After inquiring a key-input inquiry (this is the after key-input rule): say line break.

To ask-q:
    let q be an inquiry;
    now q is the first unanswered inquiry;
    while q is not the null inquiry and q is key-input begin;
      carry out the inquiring activity with q;
      now q is the first unanswered inquiry;
    end while;

Inquiry-error is an inquiry based rulebook.

Inquiry-error an inquiry (called q) when q is a multiple-choice inquiry (this is the multi-choose wisely rule):
    say "Enter a choice from [(entry 1 in the choice-list of q) as a char] to [(entry (extent of q) in choice-list of q) as a char]." (A);
   
For printing a parser error during Inquiring Minds (this is the no blank answers rule):
  if the latest parser error is the I beg your pardon error begin;
  let q be the first unanswered inquiry;
    if q is an optional inquiry begin;
      now the answer of q is ""; [ just in case it had previously been answered...]
      now q is answered;
      follow the scene changing rules;
    else;
      if q is a multiple-choice inquiry, follow the inquiry-error rules for q;
      else say "Please enter a response." (B);
      reject the player's command;
    end if;
  end if;

After reading a command during Inquiring Minds (this is the process line-input inquiry answers rule):
  let line be "[the player's command]";
  let q be the first unanswered inquiry; [ we know this is line-input ]
  if the q is a multiple-choice inquiry begin;
    let the raw choice be word number 1 in line in title case;
    if the numeric value of the player's command >= 0, now the raw choice is "[numeric value of the player's command]";
    if the number of characters in raw choice is 1 begin;
      let the choice be ord of raw choice;
      repeat with i running from 1 to extent of q begin;
        if choice is entry i in the choice-list of q begin;
          now the answer of q is entry i in the multiple-choice-list of q;
          now q is answered;
          break;
        end if;
      end repeat;
    end if;
    if q is unanswered begin;
      follow the inquiry-error rules for q;   
    end if;
  else;
    now the answer of the q is the player's command;
    now q is answered;
  end if;
  now q is the first unanswered inquiry;
  if q is not the null inquiry begin;
    if q is key-input, ask-q;
    else carry out the inquiring activity with q;
  else;
    follow the scene changing rules;
  end if;
  reject the player's command;

Initial-inquiry is initially true.

Last startup rule (this is the confirm startup rules have run rule):
  now initial-inquiry is false.

This is the check for inquiring mindlessness rule:
    if Inquiring Minds is not happening, now initial-inquiry is false.

The check for inquiring mindlessness rule is listed before the when play begins stage rule in the startup rules.

The when play begins stage rule does nothing when initial-inquiry is true.
The fix baseline scoring rule does nothing when initial-inquiry is true.
The display banner rule does nothing when initial-inquiry is true.
The initial room description rule does nothing when initial-inquiry is true.
The confirm startup rules have run rule does nothing when initial-inquiry is true.
  
Inquiring Minds is a recurring scene.
Inquiring Minds begins when there is an unanswered inquiry.
Inquiring Minds ends when there is no unanswered inquiry.

When Inquiring Minds begins (this is the close status window before initially inquiring rule):
    if initial-inquiry is true, close status window.

When Inquiring Minds begins (this is the clear screen before initially inquiring rule):
    if initial-inquiry is true, clear screen.

When Inquiring Minds begins (this is the start inquiring rule):
    now the original-command-prompt is the command prompt;
    ask-q;
    if there is an unanswered inquiry, carry out the inquiring activity with the first unanswered inquiry;

When Inquiring Minds ends (this is the open status window after inquiring rule):
  if initial-inquiry is true, open status window;

When Inquiring Minds ends (this is the clear screen after inquiring rule):
  if initial-inquiry is true, clear screen;

When Inquiring Minds ends (this is the restore command prompt rule):
  now the command prompt is the original-command-prompt;
    
Last when Inquiring Minds ends (this is the you only stop inquiring for the first time once rule):
  if initial-inquiry is true begin;
    follow the when play begins stage rule;
    follow the fix baseline scoring rule;
    follow the display banner rule;
    follow the initial room description rule;
    now initial-inquiry is false;
  end if;
  
Part testing (not for release)

To show-inquiry (q - a inquiry): say "[description of q] ";
  if q is not the null inquiry begin;
  if q is unanswered, say "unanswered.";
  else say "[if q is a y/n inquiry][boolean-answer of q][else][answer of q][end if].";
  end if;
  
To show-inquiries:
  repeat with q running through inquiries begin;
    show-inquiry q;
  end repeat;

Inquire-showing is an action out of world.
Understand "inquiries" as inquire-showing.

Carry out inquire-showing: show-inquiries.

Part agreement (for use without Agreeable by Zed Lopez)

Include (-
[ EnterYorN t key;
  TEXT_TY_Say(t);
  while(key = VM_KeyChar()) {
    if (key == 'y' or 'Y') rtrue;
    if (key == 'n' or 'N') rfalse;
    if (key == -6 && t) { print "^"; TEXT_TY_Say(t); }
  }
];

[ getKey key;
  while((key = VM_KeyChar()) == -4 or -5 or -10 or -11 or -12 or -13) continue;
  return key;
];
-).

To decide what number is get key: (- getKey() -).

To decide if ask y-or-n: (- EnterYorN() -).

To decide if ask y-or-n for/with a/an/-- (T - a text): (- EnterYorN({T}) -).

To decide if the/a/-- player agrees to/with a/an/-- (T - a text):
    now T is "[line number 1 in T] "; [strip spaces then add one back at the end]
    decide on whether or not ask y-or-n for T.

Part clear windows (for use without Basic Screen Effects by Emily Short)

To clear the/-- screen: do nothing. [ (- VM_ClearScreen(0); -).]

Part shut that down

Section Inflexible Status (for use without Flexible Windows by Jon Ingold)

To close the/-- status window: do nothing;
To open the/-- status window: do nothing.

Part cast (for use without Central Typecasting by Zed Lopez)

To decide what K is a/an/-- (unknown - a value) cast as a/an/-- (name of kind of value K): (- {unknown} -).

To decide what K is a/-- null (name of kind of value K): (- nothing -)

To decide what K is the first (D - description of values of kind K):
   repeat with x running through D begin;
     decide on x;
   end repeat;
   decide on the null K.
   
[ https://intfiction.org/t/converting-a-snippet-to-number-or-a-string-to-number/49834/3 ]
Include (-
[SnippetToNumber snip   snippos sniplen;
	snippos = snip/100;
	sniplen = snip%100;
	if (sniplen ~= 1) return -1;
	return TryNumber(snippos);
];
-).

To decide what number is the/a/-- numeric value of (S - a snippet):
    (- SnippetToNumber({S}) -)

Chapter Char (For use without Char by Zed Lopez)

Include (-
[ unicodeValue s n x cp1 p1 dsize;
if (n < 0) return 0;
cp1 = s-->0; p1 = TEXT_TY_Temporarily_Transmute(s);
dsize = BlkValueLBCapacity(s);
if (n >= dsize) return 0;
x = BlkValueRead(s,n);
TEXT_TY_Untransmute(s, p1, cp1);
return x;
];
-)

To decide what number is an/-- ord of/-- a/an/-- (T - a text): (- unicodeValue({T},0) -).

Part clear windows (for use without Basic Screen Effects by Emily Short)

To clear the/-- screen: (- VM_ClearScreen(0); -).

Inquiry ends here.

---- Documentation ----

If you include this module, you won't be able to compile without defining at least one inquiry.
That could be a dummy, if for whatever reason you'd rather do that than comment out the Include.

	dummy-inquiry is an answered inquiry.

Use of this extension is driven by creating inquiries. (I didn't use "question" just because I
figure "inquiry" had somewhat less chance of name collision.) The actual text of the inquiry
is defined by its description field, so it can be assigned with a plain text following the
initial inquiry assertion:

	Name-q is an inquiry. "What is your name?"

(It's not an error condition to leave the descirption blank, but it's also not useful.)

One of inquiries' properties is answered vs. unanswered. If there are any unanswered
inquiries, the Inquiring Minds scene begins and governs answering them. It doesn't 
end until there are no unanswered inquiries.

If you want inquiries to be asked later in the game, create them as initially answered
and change them to unanswered (or change a previously asked and answered inquiry back
to unanswered) during play. Inquiring Minds is recurring and it will start again.

Inquiries can be key-input or line-input. Key-input inquiries are answered with
a single keystroke.

An ask y/n inquiry is a subkind of inquiry that is always key-input (well,
technically it's *usually* key-input but don't change that). It's answered
when the users hits Y or N (case-insensitive). There's a specific pair of
adjectives to test whether an ask y/n inquiry has been answered in the
positive: confirmed vs. unconfirmed. Unonfirmed is false if the inquiry is
either unanswered or was answered in the negative.

Another subkind of inquiry is the multiple-choice inquiry. It can be key-input
or line-input. Choices are specified in a multiple-choice-list list of texts.

	Survey is a line-input multiple-choice inquiry. "What's your favorite beverage?"
	
	The multiple-choice-list of survey is
	  { "Tea", "Coffee", "OJ", "water", "zima", "Dr. Pepper",
	    "root beer", "vanilla cream soda", "beer", "wine" }.

It can be numbered or lettered, depending on whether you want the choices'
labels to begin with numerals or the alphabet, but either way it will
continue with the other if a numbered multiple-choice inquiry has more than 9
choices or a lettered one has more than 26. There's thus a limit of 36 choices.
It's not an error condition to exceed that, but choices in excess of that won't
be offered. An answer must be supplied, so include a "Skip" or "n/a" choice
as desired.

The big difference between line-input and key-input is that with line-input,
the user will have to hit enter after their selection, and they'll get an
error message if they entered something that isn't a choice; whereas with
key-input it'll just sit there if they enter wrong choices.

Inquiring something is an activity on inquiries so there's a lot of
opportunity to customize things for various types of inquiry or for
some particular inquiry. But there's a bizarre detail here: key-input
inquiries are wholly handled by the activity, but line-input inquiries
can't be: displaying the question must happen at the end of one turn
and its processing must happen after a command has been read. So key
parts of the action occur in an After reading a command rule.

An optional inquiry is the final sub-kind of inquiry. It's always line-input and
thus gets a free-form text answer, but the game will accept a blank answer for
an optional inquiry; in every other case, an answer is required. You may wish
to add a response for the case of a user entering a blank response for an
optional question or it looks a lot like nothing happened. Spreading out
the action of this Extension further, optional inquiries get marked answered
within a rule For printing a parser error.

Section Startup / Inquiring Minds scene details

I wanted any initial inquiries to come before other output, but it would be a pain
to attempt line input any other way than to be in the turn processing loop. So
the when play begins stage rule, fix baseline scoring rule, display banner rule,
and initial room description rule all do nothing if Inquiring Minds is happening
(the 7th rule in the startup rules, the start in the correct scenes rule,
makes that the case if there are unanswered inquiries).

If there were unanswered inquiries at startup and thus an Inquiring Minds scene,
a final When Inquiring Minds ends rule finally runs those rules (and sets the
initial-inquiry global to ensure this only happens once.)

Chapter Examples

Section Screenreader

Example: * Screenreader Question

	*: "Screenreader Question"
	
	Include Flexible Windows by Jon Ingold.
	Include Inquiry by Zed Lopez.
	
	Lab is a room. "Still not alive."
	
	Screenreader-question is a y/n inquiry. "Are you using a screenreader?"
	
	Interface-value is a kind of value.
	Some interface-values are default-interface, screenreader.
	The interface is an interface-value that varies.
	
	After inquiring an inquiry (called q) when q is screenreader-question:
	  if screenreader-question is confirmed, now interface is screenreader.
	
	The open status window after inquiring rule does nothing when interface is screenreader.
	
	Section Don't ask unless release (not for release)
	
	Screenreader-question is answered.

Section Miscellaneous

Example: * Miscellaneous Inquiries

	*: "Miscellaneous Inquiries"
	
	Include Inquiry by Zed Lopez.
	
	Lab is a room. "Still not alive."
	
	Name-question is an inquiry. "What is your name?" 
	
	survey is a line-input multiple-choice inquiry. "What's your favorite beverage?"
	
	The multiple-choice-list of survey is { "Tea", "Coffee", "OJ", "water", "zima", "Dr. Pepper", "root beer", "vanilla cream soda", "beer", "wine" }.
	
	You really want to hurt me is a y/n inquiry. "Do you really want to hurt me?".
	You really want to make me cry is a y/n inquiry. "Do you really want to make me cry?".
	
	jump-passion is an answered y/n inquiry. "Do you love jumping?"
	
	blank-q is an answered optional inquiry. "Do you have an answer?"
	
	instead of jumping:
	  now blank-q is unanswered;
	  now jump-passion is unanswered;
	  now survey is unanswered;
	  now survey is key-input;
	
	test me with "inquiries / jump". [ say inquiries again manually after answering! ]
