Version 6 of Conversation Rules IT by Leonardo Boselli begins here.

"A way of controlling conversations using rules and tables. Also implements topic suggestions and Conversation nodes. Requires Plurality by Emily Short and Conversation Framework, Epistemology and List Control by Eric Eve. Solo tradotto in italiano." "based on Version 6 of Conversation Rules by Eric Eve."

Book 1 - Includes Include Italian by Leonardo Boselli.
[Include Plurality by Emily Short.]
Include Conversation Framework IT by Leonardo Boselli.
Include List Control by Eric Eve.

Book 2 - Conversation Model

Part  1 - People and Tables

A person has a table-name called quizzing table.
A person has a table-name called informing table.

The quizzing table of a person is normally the Table of Null Response.
The informing table of a person is normally the Table of Null Response.

Table of Null Response
subject		response rule			response table	suggest
yourself		default no response rule		table-name	0

A person has a rule called the unknown quizzing rule.
A person has a rule called the unknown informing rule.

The unknown quizzing rule of a person is normally the default no response rule.

The unknown informing rule of a person is normally the default no response rule.

This is the default no response rule:
  say "Non ottieni alcuna risposta."

Part 2 - Action Handling

Report quizzing someone about something known when the second noun is a subject listed in the quizzing table of the noun (this is the standard quizzing report rule):  
  if there is a suggest entry and the suggest entry is -1 then continue the action;
  if there is a response rule entry then consider the response rule entry;
  if there is a response table entry then show the next response from the response table entry;
  if there is a suggest entry and the suggest entry > 0 begin;
    let sug be the suggest entry;
    decrease sug by 1;
    change the suggest entry to sug;
 end if;
 stop the action.
  

Report quizzing someone about something when the noun provides the property unknown quizzing rule (this is the default quizzing report rule):
  consider the unknown quizzing rule of the noun instead

[
A procedural rule when quizzing somebody about something:
  if the second noun is unknown or the second noun is not a subject listed in the quizzing table of the noun then ignore the greet a new interlocutor rule.
]

Report informing someone about something known when the second noun is a subject listed in the informing table of the noun (this is the standard informing report rule):  
  if there is a suggest entry and the suggest entry is -1 then continue the action;
  if there is a response rule entry then consider the response rule entry;
  if there is a response table entry then show the next response from the response table entry;
  if there is a suggest entry and the suggest entry > 0 begin;
    let sug be the suggest entry;
    decrease sug by 1;
    change the suggest entry to sug;
 end if;
 stop the action.
  

Report informing someone about something when the noun provides the property unknown informing rule (this is the default informing report rule):
  consider the unknown informing rule of the noun instead.

Part  3 - Some useful shortcuts

To say reveal (item - a thing): now the item is familiar.

This is the quiz-inform rule:
  try informing the noun about the second noun instead.

This is the inform-quiz rule:
  try quizzing the noun about the second noun instead.

Part 4 - Suggesting Topics

Requesting suggested topics is an action out of world applying to nothing.

Understand "argomenti" as requesting suggested topics.

Check requesting suggested topics when the current interlocutor is not a person (this is the can't suggest if no interlocutor rule):
  say "Non stai conversando con nessuno." instead.

Report requesting suggested topics (this is the standard list suggested topics rule):
  let ask topics be the number of current suggestions in the quizzing table of the current interlocutor;
  let tell topics be the number of current suggestions in the informing table of the current interlocutor;
  if ask topics + tell topics is 0 and the suggestions of the current convnode is "blank" then say "Non hai nulla in mente di cui discutere [con-prep the current interlocutor] in questo momento." instead;
  say "(Potresti ";
  if the suggestions of the current convnode is not "blank" begin;
     say "[suggestions of the current convnode]";
    if the current convnode is limited then say ".)" instead;
    if ask topics + tell topics > 0 then say ", or ";
  end if;
  if ask topics > 0  begin;
    say "chiedere [a-prep the current interlocutor] di ";
    list the current suggestions in the quizzing table of the current interlocutor;   
    if tell topics > 0 then say ", o ";
  end if;
  if tell topics > 0 begin;
    say "parlare [a-prep the current interlocutor] di ";
    list the current suggestions in the informing table of the current interlocutor;   
  end if;
  say ".)"

To decide which number is the number of current suggestions in (tab - a table-name):
  let count be 0;
  repeat through tab begin;
    if the subject entry is known and there is a suggest entry and the suggest entry > 0 then
        increase count by 1;
  end repeat;
  decide on count.

To list the current suggestions in (tab - a table-name):
  let count be the number of current suggestions in tab; 
  let suggested topics be 0;
  repeat through tab begin;
  if the subject entry is known and there is a suggest entry and the suggest entry > 0 begin;
       say "[the topic name of the subject entry]";
       increase suggested topics by 1; 
       if suggested topics is count - 1 begin;
            say " o "; 
       otherwise;
            if suggested topics < count then say ", ";
      end if;
    end if;
  end repeat.

To say the topic name of (item  - a thing):
  if the item is the current interlocutor then
      say "[the current interlocutor]";   
  otherwise say "[the item]".
  

To set the quiz suggestions of (item - a thing) to (n - a number):
  if the current interlocutor is a person begin;
    if the item is a subject listed in the quizzing table of the current interlocutor
      then change the suggest entry to n;
  end if.

To set the inform suggestions of (item - a thing) to (n - a number):
  if the current interlocutor is a person begin;
    if the item is a subject listed in the informing table of the current interlocutor
      then change the suggest entry to n;
  end if.

To say quiz (item - a thing) to (n - a number):
  set the quiz suggestions of the item to n.

To say inform (item - a thing) to (n - a number):
  set the inform suggestions of the item to n.


Part  5 - Yes and No

[Dealing with YES and NO]

The block saying yes rule is not listed in any rulebook.
The block saying no rule is not listed in any rulebook.

Report saying yes when the current interlocutor is a person (this is the saying yes or no to someone rule):
  say "'[if saying yes]S[otherwise]No[end if],' rispondi.

'Ma non ti ho chiesto nulla,' dice [the current interlocutor]." instead.

The saying yes or no to someone rule is listed in the report saying no rules.


Part 6 - Conversation Nodes

A Conversation Node is a kind of thing. A Conversation Node has a rule called the node rule. The node rule of a Conversation Node is normally the do nothing rule.
A Conversation Node has a text called suggestions. The suggestions of a Conversation Node is usually "blank".
A Conversation Node can be either limited or unlimited. A Conversation Node is normally limited.

This is the do nothing rule: do nothing.

The current convnode is a Conversation Node that varies. The current convnode is the null-node.

The null-node is a Conversation Node.

Check asking it about when the current convnode is not the null-node (this is the try convnode when conversing rule):
   abide by the node rule of the current convnode.

The try convnode when conversing rule is listed in the check telling it about rules.
The try convnode when conversing rule is listed in the check quizzing it about rules.
The try convnode when conversing rule is listed in the check informing it about rules.
The try convnode when conversing rule is listed in the check asking it for rules.
The try convnode when conversing rule is listed in the check answering it that rules.


Check saying yes when the current interlocutor is a person (this is the try convnode when saying yes or no rule):
  if the current convnode is not the null-node then
  abide by the node rule of the current convnode;
     
The try convnode when saying yes or no rule is listed in the check saying no rules.

To say convnode (newnode - a Conversation Node):
  change the current convnode to newnode;
  if the suggestions of the current convnode is not "blank" then 
  consider the standard list suggested topics rule;


Xspcing is an action applying to nothing.

Check Xspcing when the current convnode is not the null-node (this is the Special Topic rule):
  abide by the node rule of the current convnode.


Book 3 - Additional Grammar


[We use primary and secondary as a further way to disambiguate similar objects in conversational contexts]

[This is an attempt to provide unnecessary disambiguation prompts when the same vocab may apply to a number of things.]

A thing can be primary or secondary. A thing is normally secondary.


Understand "chiedi [a-art] [someone] [di-art] [any primary known thing]" as quizzing it about.
Understand "c [any primary known thing]" as implicit-quizzing.
Understand "chiedi [di-art] [any primary known thing]" as implicit-quizzing.
Understand "parla [a-art] [someone] [di-art] [any primary known thing]" as informing it about.
Understand "p [any primary known thing]" as implicit-informing.


Conversation Rules IT ends here.

---- DOCUMENTATION ----

Vedi la documentazione originale di Conversation Rules by Eric Eve.
