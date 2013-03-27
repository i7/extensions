Version 1 of Conversation Package IT by Leonardo Boselli begins here.

"This extension includes both Conversation Nodes and Conversation Suggestions, and makes the suggestions aware of conversation nodes. It therefore includes the complete conversational system in one package. It also requires Conversation Responses, Conversational Defaults, Conversation Framework and Epistemology. The documentation for this extension give some guidance on how these other extensions can be mixed and matched. Solo tradotto in italiano."

"basato su Conversation Package by Eric Eve"

Part 1 - Include Conv Nodes &  Suggestions

Include Conversation Nodes IT by Leonardo Boselli.
Include Conversation Suggestions IT by Leonardo Boselli.

Part 2 - Modifications to Conv Nodes

A convnode has a list of objects called ask-suggestions.
A convnode has a list of objects called tell-suggestions.
A convnode has a list of objects called other-suggestions.
A convnode can be auto-suggesting. 
A convnode is usually not auto-suggesting.
A closed convnode is usually auto-suggesting.

Part 3 - New Rules for Conv Nodes

To decide which object is the appropriate-suggestion-database:
  if the current node is closed, decide on the current node;
  decide on the current interlocutor.

A suggestion list construction rule when the current node is not the null-node and the current node is open (this is the add the current node's suggestion lists rule):
  add the other-suggestions of the current node to sugg-list-other, if absent;
  add the ask-suggestions of the current node to sugg-list-ask, if absent;
  add the tell-suggestions of the current node to sugg-list-tell, if absent.

This is the use a closed node's suggestion lists rule:
  change sugg-list-other to the other-suggestions of the current node;
  change sugg-list-ask to the ask-suggestions of the current node;
  change sugg-list-tell to the tell-suggestions of the current node.

The use the current interlocutor's suggestion lists rule is not listed in the suggestion list construction rules.

The first suggestion list construction rule (this is the use the appropriate suggestion lists rule):
   if the current node is not the null-node and the current node is closed then consider use a closed node's suggestion lists rule;
   otherwise consider the use the current interlocutor's suggestion lists rule;

A node-introduction rule for a closed convnode when the current node is auto-suggesting (this is the show node suggestions rule):
   Show the topic suggestions implicitly.

The show node suggestions rule is listed last in the node-introduction rules.

Conversation Package IT ends here.

---- DOCUMENTATION ----

Vedi la documentazione originale di Conversation Packages by Eric Eve.