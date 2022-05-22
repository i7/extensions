Version 4 of Inquiry by Zed Lopez begins here.

"A framework for defining Y/N, multiple choice, or free-form
 questions to be asked immediately on game startup or subsequently."

Book Main

Part Objects and accessor phrases/definitions

Chapter Inquiry object per se
 
An inquiry is a kind of object.
An inquiry has a text called the answer.
An inquiry has a text called the description.
An inquiry can be answered or unanswered.
An inquiry can be key-input or line-input.

Chapter Optional inquiry

An optional inquiry is a kind of inquiry.
An optional inquiry is usually line-input. [ don't change ]

Chapter Y/N inquiry

A y/n inquiry is a kind of inquiry.
A y/n inquiry is usually key-input. [ don't change ]
A y/n inquiry has a truth state called boolean-answer.

Section Confirmed/unconfirmed

Definition: a y/n inquiry is confirmed rather than unconfirmed if it is answered and the boolean-answer of it is true.

Chapter Multiple choice inquiry 

A multiple-choice inquiry is a kind of inquiry.
A multiple-choice inquiry has a list of texts called the multiple-choice-list.
A multiple-choice inquiry can be lettered or numbered.
A multiple-choice inquiry can be question-first or question-last.
A multiple-choice inquiry has a list of numbers called the choice-list.
The choice-list of a multiple-choice inquiry is usually {}.
A multiple-choice inquiry has a number called the extent.

[ sticking to key-input for multiple-choice is recommended.
  definitely don't use line input if the choices will go as far as 'g' ]
A multiple-choice inquiry is usually key-input. 

Section number of choices

To decide what number is the number of choices in/of (m - a multiple-choice inquiry):
  decide on the number of entries in the multiple-choice-list of m.

Book Inquiring Activity

Chapter Inquiring Activity declaration

Inquiring something is an activity on inquiries.
The inquiring activity has a snippet called the raw user input.
The inquiring activity has a text called the user input.

Chapter Inquiring Activity variable support phrases

To solicit input for (S - a snippet):
    (- {S} = getLine(); -)
  
To decide what text is the user-response for (S - a snippet):
  solicit input for S;
  decide on "[S]";

Chapter Multichoice list constants

[ lettered: after 26 choices, continue with numbers; start numbers at 0 if there are more than 35 choices;
  numbered: after 9 choices, continue with letters; start numbers at 0 if there are more than 35 choices;
]

letter35 is always { 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59 }. [ ascii for A-Z, 1-9 ]
letter36 is always { 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59 }. [ ascii for A-Z, 0-9 ]
number35 is always { 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90 }. [ ascii for 1-9, A-Z ]
number36 is always { 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59 }. [ ascii for 0-9, A-Z ]

Part Before inquiring

[ The Before Inquiring rules output the question ]

Chapter list the multiple choices rule

Before inquiring a multiple-choice inquiry (called q) (this is the list the multiple choices rule):
  if q is question-first, say "[description of q][line break]" (C);
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
    say "[entry i in choice-list of q as a char]. [entry i in the multiple-choice-list of q][line break]" (D);
  end repeat;
  if q is question-last, say "[line break][description of q] " (E);

Chapter Ask question for mono-choice line-input question 

Before inquiring a line-input inquiry (called q) when q is not a multiple-choice inquiry (this is the ask question for mono-choice line-input question rule):
  say "[the description of q] ";

Chapter Ask question for ask y/n inquiry

First before inquiring a y/n inquiry (called q) (this is the ask question for ask y/n inquiry rule):
  say "[the description of q]";

Section Final space

Last before inquiring a y/n inquiry (called q) (this is the final space for ask y/n inquiry rule):
  say " ";

Chapter Assign variables for line-input inquiry rule

Last before inquiring a line-input inquiry (this is the assign variables for line-input inquiry rule):
  now user input is the user-response for the raw user input;

Part For inquiring

[ The For inquiring rules solicit user input. In the line-input case,
  they also validate it. (Validation is irrelevant for key-input, which
  won't exit until it has a valid response.) ]

Chapter Ask y/n question

For inquiring a y/n inquiry (called q) (this is the ask y/n question rule):
  if ask y-or-n begin;
    say "Y";
    now the boolean-answer of q is true;
  else;
   say "N";
   now the boolean-answer of q is false;
  end if;
  say line break;

Chapter Key-input multiple-choice inquiry 

For inquiring a key-input multiple-choice inquiry (called q) (this is the key-input multiple-choice inquiry rule):
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

Chapter Multi-choice line-input inquiry 

For inquiring a line-input multiple-choice inquiry (called q) (this is the multi-choice line-input inquiry rule):
    let the raw choice be word number 1 in user input in title case;
    if the numeric value of raw user input >= 0, now the raw choice is "[numeric value of raw user input]";
    if the number of characters in raw choice is 1 begin;
      let the choice be ord of raw choice;
      repeat with i running from 1 to extent of q begin;
        if choice is entry i in the choice-list of q begin;
          now the answer of q is entry i in the multiple-choice-list of q;
        end if;
      end repeat;
    end if;

Part After inquiring

Chapter mark line-input inquiry answer 

First after inquiring a line-input inquiry (called q) (this is the mark line-input inquiry answer rule):
  now the answer of q is user input;
  if q is an optional inquiry or the answer of q is not empty, now q is answered;

Chapter mark key-input inquiry answer

First after inquiring a key-input inquiry (called q) (this is the mark key-input inquiry answer rule):
  now q is answered;

Part After Inquiring

[ After inquiring rules are primarily for printing errors if validation failed ]

Chapter linefeed for key-input

After inquiring a key-input inquiry (this is the line break after key-input rule): say line break;

Chapter multiple-choice inquiry error

After inquiring an unanswered multiple-choice inquiry (called q) (this is the multiple-choice inquiry error rule):
  say "Enter a choice from [(entry 1 in the choice-list of q) as a char] to [(entry (extent of q) in choice-list of q) as a char]." (A);

Chapter you've got to give me something here

After inquiring an unanswered inquiry (called q) when q is not a multiple-choice inquiry (this is the you've got to give me something here rule):
  say "Please enter a response." (B);

Chapter check scene change after answering rule

Part restart y/n

Use restart y/n translates as (- Constant RESTART_YN; -).

restart-game is an answered y/n inquiry.

First before inquiring a y/n inquiry (called q) (this is the assign text of restart inquiry rule):
  if q is restart-game, now the description of q is "[text of restart the game rule response (A)]Y/N" (C);

Include (-
[ RestartGame;
  @restart;
];
-)

To restart-game: (- RestartGame(); -).

First carry out restarting the game when the restart y/n option is active:
  now restart-game is unanswered;
  carry out the inquiry handling activity;
  if boolean-answer of restart-game is true, restart-game;
  else stop the action.
    
Part Support Functions

Chapter Getline

Include (-
[ getLine;
KeyboardPrimitive(buffer, parse);
return 100 + WordCount();
];

-);

To say (n - a number) as a char: (- print (char) {n}; -)

Chapter Line input

to decide what snippet is the line input: (- getLine(); -).

Book Inquiry Handling activity

[ This has no default use; it just exists to make it easy to write before or after rules that
know whether we're in the startup rules or during the turn sequence. ]
pregame-inquiry is initially true.

Inquiry handling is an activity.

For inquiry handling:
  let q be the first unanswered inquiry;
  while q is not the null inquiry begin;
    carry out the inquiring activity with q;
    now q is the first unanswered inquiry;
  end while;

After inquiry handling when pregame-inquiry is true (this is the pregame inquiry no more rule):
  now pregame-inquiry is false.

This is the handle inquiries rule: carry out the inquiry handling activity.

The handle inquiries rule is listed after the generate action rule in the turn sequence rules.

This is the initially handle inquiries rule:
  carry out the inquiry handling activity.

Chapter Alternative (for use with Alternative Startup Rules by Dannii Willis)

The initially handle inquiries rule is listed before the alternative start in the correct scenes rule in the after starting the virtual machine rules.

Chapter Mainstream (for use without Alternative Startup Rules by Dannii Willis)

The initially handle inquiries rule is listed before the start in the correct scenes rule in the startup rules.

Book testing (not for release)

Part "inquiries" command and supporting phrases 

Chapter output

Section show-inquiry

To show-inquiry (q - a inquiry):
  if q is not the null inquiry begin;
    say "[if the description of q is empty]<[printed name of q]>[else][description of q][end if] ";
    if q is answered begin;
      if q is a y/n inquiry, say boolean-answer of q;
      else say "[if answer of q is empty]<empty>[else][answer of q][end if]";
    else;
     say "<unanswered>";
    end if;
    say line break;
  end if;

Section show-inquiries

To show-inquiries:
  repeat with q running through inquiries begin;
    show-inquiry q;
  end repeat;

Chapter inquiries command

Inquire-showing is an action out of world.
Understand "inquiries" as inquire-showing.

Carry out inquire-showing: show-inquiries.

Book for use without parts

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

[ getRelevantKey key;
  while((key = VM_KeyChar()) == -4 or -5 or -10 or -11 or -12 or -13) continue;
  return key;
];
-).

To decide what number is get key: (- getRelevantKey() -).

To decide if ask y-or-n: (- EnterYorN() -).

Part clear windows (for use without Basic Screen Effects by Emily Short)

To clear the/-- screen: (- VM_ClearScreen(0); -).

Part shut that down

Section Inflexible Status (for use without Flexible Windows by Jon Ingold)

To close the/-- status window: do nothing;
To open the/-- status window: do nothing.

Part cast (for use without Central Typecasting by Zed Lopez)

Chapter Generic

Section Null K

To decide what K is a/-- null (name of kind of value K): (- nothing -)

Section First K

To decide what K is the first (D - description of values of kind K):
   repeat with x running through D begin;
     decide on x;
   end repeat;
   decide on the null K.

Chapter Snippet to number

Section SnippetToNumber

[ https://intfiction.org/t/converting-a-snippet-to-number-or-a-string-to-number/49834/3 ]
Include (-
[SnippetToNumber snip   snippos sniplen;
	snippos = snip/100;
	sniplen = snip%100;
	if (sniplen ~= 1) return -1;
	return TryNumber(snippos);
];
-).

Section I7 wrapper for SnippetToNumber

To decide what number is the/a/-- numeric value of (S - a snippet):
    (- SnippetToNumber({S}) -)

Part Char (For use without Char by Zed Lopez)

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

Inquiry ends here.

---- Documentation ----

Chapter Warnings

If you include this module, you won't be able to compile without defining at least one inquiry.
That could be a dummy, if for whatever reason you'd rather do that than comment out the Include.

	dummy-inquiry is an answered inquiry.

Chapter Inquiries

Use of this extension is driven by creating inquiries. (I didn't use "question" just because I
figure "inquiry" had somewhat less chance of name collision.) The actual text of the inquiry
is defined by its description field, so it can be assigned with a plain text following the
initial inquiry assertion:

	Name-q is an inquiry. "What is your name?"

(It's not an error condition to leave the description blank, but it's also not useful.)

One of inquiries' properties is answered vs. unanswered. If there are any unanswered
inquiries, they're asked in a loop that doesn't end until there are no unanswered
inquiries. The rule triggering this loop comes between the action rulebooks and the
(first) scene changing rules in the turn sequence, and before the start in the correct
scenes rule in the startup rulebook.

If you want inquiries to be asked later in the game, create them as initially answered
and change them to unanswered (or change a previously asked and answered inquiry back
to unanswered) during play. You could carry out the Inquiry handling activity manually
if you want, but otherwise it'll be asked immediately after the end of the next action.

Inquiries can be key-input or line-input. Key-input inquiries are answered with
a single keystroke.

Section Ask Y/N Inquiry

An ask y/n inquiry is a subkind of inquiry that is always key-input (well,
technically it's *usually* key-input but don't change that). It's answered
when the users hits Y or N (case-insensitive). There's a specific pair of
adjectives to test whether an ask y/n inquiry has been answered in the
positive: confirmed vs. unconfirmed. Unonfirmed is false if the inquiry is
either unanswered or was answered in the negative.

Section Multiple-choice Inquiry

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

There is an Inquiry handling activity that controls the whole loop,
and a separate Inquiring activity, which is an activity on inquiries.

Displaying the inquiry text goes in  Before inquiring rules; For inquiring
rules cover receiving the input and validation; After inquiring rules cover
either error messages or actually storing the result and marking the inquiry
answered.

Y/n inquiries don't output "Y/N" by default, but the activity makes this
easy to set up:

	Last before inquiring a y/n inquiry: say "Y/N ".

The Inquiring activity itself doesn't take any steps to ask again if an inquiry
is unanswered at the end. When the activity is over, we're still in the
Inquiry handling loop and since there's still at least an unanswered inquiry,
the Inquiring activity is carried out again.

An optional inquiry is the final sub-kind of inquiry. It's always line-input and
thus gets a free-form text answer, but the game will accept a blank answer for
an optional inquiry; in every other case, an answer is required. You may wish
to add a response for the case of a user entering a blank response for an
optional question or it looks a lot like nothing happened.

When there are multiple unanswered inquiries to be made, they are always made
in the inquiries' order of definition in the source.

Chapter restart y/n

Just to cater to my own personal preference, there's a provided use option
that will convert the restart command's question to a Y/N inquiry.

	Use restart y/n.

Chapter Changelog

v4: Having abandoned the turn sequence hijacking, there was no point left
to having a scene control question asking, so introduced the inquiry
handling activity. Also added the restart y/n use option.

v3: substantial rewrite to use KeyboardPrimitive for line-input, which
turns out to be far less intrusive than hijacking the turn sequence. Who knew?

Chapter Examples

Section Screenreader

Example: * Screenreader Question

	*: "Screenreader Question"
	
	Include Flexible Windows by Jon Ingold.
	Include Inquiry by Zed Lopez.
	
	Lab is a room. "Experiment still not alive."
	
	Screenreader-question is a y/n inquiry. "Are you using a screenreader?"
	
	Interface-value is a kind of value.
	Some interface-values are default-interface, screenreader.
	The interface is an interface-value that varies.
	
	After inquiring an answered inquiry (called q) when q is the screenreader-question:
	  if screenreader-question is confirmed, now interface is screenreader.
	
	The open status window after inquiring rule does nothing when interface is screenreader.
	
	Section Don't ask unless release (not for release)
	
	Screenreader-question is answered.

Section Miscellaneous

Example: * Miscellaneous Inquiries

	*: "Miscellaneous Inquiries"
	
	Include Inquiry by Zed Lopez.
	
	Lab is a room. "Experiment still not alive."
	
	Name-question is an inquiry. "What is your name?" 
	
	survey is a line-input multiple-choice inquiry. "What's your favorite beverage?"
	
	The multiple-choice-list of survey is { "Tea", "Coffee", "OJ", "water", "zima", "Dr. Pepper", "root beer", "vanilla cream soda", "beer", "wine" }.
	
	Self-reported-luck is a y/n inquiry. "Are you feeling lucky?"
	
	jump-passion is an answered y/n inquiry. "Do you love jumping?"
	
	blank-q is an answered optional inquiry. "Do you have an answer?"
	
	instead of jumping:
	  now blank-q is unanswered;
	  now jump-passion is unanswered;
	  now survey is unanswered;
	  now survey is key-input;
	
	test me with "inquiries / jump". [ say inquiries again manually after answering! ]
