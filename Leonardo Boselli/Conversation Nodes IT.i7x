Version 3 of Conversation Nodes IT by Leonardo Boselli begins here.

"Builds on Conversational Defaults and adds the ability to define particular points in a conversational thread (nodes) at which particular conversational options become available. Solo tradotto in italiano."

"basato su Conversation Nodes by Eric Eve."

Book 1 - Includes

Include Conversation Responses IT by Leonardo Boselli. 
Include Conversational Defaults IT by Leonardo Boselli.

Book 2 - Definitions

Part 1 - The Convnode Kind

A convnode is a kind of thing.
A convnode can be open or closed. A convnode is usually open. 
A convnode has a convnode called the next-node. The next-node of a convnode is usually the null-node. 
A convnode has a number called the node-time. The node-time of a convnode is usually 1.

The specification of a convnode is "A convnode is a thing that represents a particular point in a conversation at which particular conversational responses become relevant (such as when an NPC has asked a question to which you might want to respond YES or NO). A convnode can be open (in which case it normally lasts only one turn, and can be effectively bypassed altogether if the player chooses to ignore the extra options available at that point) or closed (in which case only the conversational responses available for that convnode are available, and the player will be stuck in the convnode until explicitly released; this can be used to allow an NPC to force a player to answer his/her question)."


Part 2 - The Null-Node

The null-node is a convnode.
A person has a convnode called the node.
The node of a person is usually the null-node.

Part 3 - Global Variables

The node-timer is a number that varies.
The next-scheduled-node is a convnode that varies.
The next-scheduled-node is the null-node.

conversed-this-turn is a truth state that varies.
conversed-this-turn is false.

To decide which convnode is the current node:
  if the current interlocutor is not a person, decide on the null-node;
  decide on the node of the current interlocutor.


Book 2 - Node-Switching Machinery

To say node (new-node - a convnode):
  change the next-scheduled-node to the new-node;
  the node switches in 0 turns from now.

To setnode (new-node - a convnode):
  change the next-scheduled-node to the new-node;
  the node switches in 0 turns from now.

To say leavenode: 
  change the next-scheduled-node to the next-node of the current node;
  the node switches in 0 turns from now.

At the time when the node switches:  
  if the current interlocutor is a person begin;
    change the node of the current interlocutor to the next-scheduled-node;
    change the node-timer to the node-time of the current node;
    follow the node-introduction rules for the current node;
 end if.


To initiate a/-- conversation with (new-speaker - a person) at/in/using/with (new-node - a convnode):
  change the current interlocutor to new-speaker;
  change the next-scheduled-node to new-node;
  the node switches in 0 turns from now.


Book 3 - Rules

Part 1 - Node-Specific Rules

The node-introduction rules are an object-based rulebook.
The node-continuation rules are an object-based rulebook.
The node-termination rules are an object-based rulebook. The node-termination rules have default failure.

Before going from somewhere when the current node is not null-node (this is the check going during convnode rule):
  abide by the node-termination rules for the current node.

The check going during convnode rule is listed before the say goodbye when moving rule in the before rules.

Check saying goodbye to someone when the farewell type is explicit:
  abide by the node-termination rules for the current node.

Every turn when the current node is not the null-node (this is the node continuation rule):
  if conversed-this-turn is false then consider the node-continuation rules for the current node;
  otherwise change conversed-this-turn to false.
  
Before speaking when the current node is not the null-node and the current node is open (this is the decrease node-timer rule): 
  decrease the node-timer by 1.
  
Before speaking (this is the note conversation rule):
  change conversed-this-turn to true.

Every turn when the current node is not the null-node and the current node is open and the node-timer < 1 (this is the node-switching rule):
  change the node of the current interlocutor to the next-node of the current node.

To decide if at-node (cnode - a convnode):
  decide on whether or not the current node is cnode.

Part 2 -  Responses for Closed Nodes

Check asking it about when the node of the noun is closed (this is the nodal ask response rule):
  abide by the response rules for the current node;
  abide by the default ask response rules for the current node.

Check quizzing it about when the node of the noun is closed (this is the nodal quiz response rule):
   abide by the response rules for the current node; 
   abide by the default ask response rules for the current node.

Check telling it about when the node of the noun is closed (this is the nodal tell response rule):
   abide by the response rules for the current node;
   abide by the default tell response rules for the current node.

Check informing it about when the node of the noun is closed (this is the nodal inform response rule):
  abide by the response rules for the current node;
  abide by the default tell response rules for the current node.

Check answering it that when the node of the noun is closed (this is the nodal answer response rule):
  abide by the response rules for the current node;
  abide by the default answer response rules for the current node.

Check giving it to when the node of the  second noun is closed (this is the nodal give response rule):
  abide by the response rules for the current node;
  abide by the default give response rules for the current node.

Check showing it to when the node of the second noun is closed (this is the nodal show response rule):
  abide by the response rules for the current node;
  abide by the default show response rules for the current node.

Check requesting it for when the node of the noun is closed (this is the nodal request response rule):  
  abide by the response rules for the current node;
  abide by the default ask-for response rules for the current node.

Check imploring it for when the node of the noun is closed (this is the nodal implore response rule):
  abide by the response rules for the current node;
  abide by the default ask-for response rules for the current node.

Check saying yes when the current node is closed (this is the nodal yes response rule):
  abide by the response rules for the current node;
  abide by the default yes-no response rules for the current node.

Check saying no when the current node is closed (this is the nodal no response rule):
  abide by the response rules for the current node;
  abide by the default yes-no response rules for the current node.

Check saying sorry when the current node is closed (this is the nodal sorry response rule):
  abide by the response rules for the current node;
  abide by the default response rules for the current node.

Part 3 - Responses for Open Nodes

This is the open node response rule:
  if the current node is not the null-node then abide by the response rules for the current node.

The open node response rule is listed first in the report asking it about rules.
The open node response rule is listed first in the report quizzing it about rules.
The open node response rule is listed first in the report telling it about rules.
The open node response rule is listed first in the report informing it about rules.
The open node response rule is listed first in the report answering it that rules.
The open node response rule is listed first in the report requesting it for rules.
The open node response rule is listed first in the report imploring it for rules.
The open node response rule is listed first in the report saying yes rules.
The open node response rule is listed first in the report saying no rules.
The open node response rule is listed first in the report saying sorry rules.
The open node response rule is listed first in the report giving it to rules.
The open node response rule is listed first in the report showing it to rules.

Conversation Nodes IT ends here.

---- DOCUMENTATION ----

Vedi la documentazione originale di Conversation Nodes by Eric Eve.