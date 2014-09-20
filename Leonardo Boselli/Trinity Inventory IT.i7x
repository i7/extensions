Version 5/140705 of Trinity Inventory IT by Leonardo Boselli begins here.

"Translation in italian of 5/070114 of Trinity Inventory by Mikael Segercrantz. Provides a framework for listing inventories in natural sentences, akin to Infocom's game Trinity. Separates carried and worn objects, followed by objects that contains other objects. What's listed in the third section is customizable via a rulebook. Objects can be marked as not listed when carried or worn as well as marked as having their contents listed in the inventory when they're empty. This extension is based upon the extension Written Inventory by Jon Ingold."

[Updated for Inform 6L02 by Matt Weiner as of July 1, 2014. There should be no changes in performance, but you may wish to triple-check the behavior of the adaptive text.]

Include Trinity Inventory by Mikael Segercrantz.

Chapter - Responses

    container inventory contents rule response (A) is ", e [regarding the player][hai]".
    container inventory contents rule response (B) is ". [regarding the player][maiuscolo][Hai][maiuscolo] anche".
    container inventory contents rule response (C) is " [list of listed when carried things in the item] dentro ".
    container inventory contents rule response (D) is "[item]".
    container inventory contents rule response (E) is "[the item]".
    container inventory contents rule response (F) is ", e [if item is specially-inventoried][item][otherwise][the item][end if]".
    container inventory contents rule response (G) is ". [Item]".
    container inventory contents rule response (H) is ". [The item]".
    container inventory contents rule response (I) is " [regarding the item][sei] [vuoto]".
    holdall inventory contents rule response (A) is ", e [regarding the player][hai]".
    holdall inventory contents rule response (B) is ". [regarding the player][maiuscolo][Hai][maiuscolo] anche".
    holdall inventory contents rule response (C) is " [list of listed when carried things in the item] dentro ".
    holdall inventory contents rule response (D) is "[item]".
    holdall inventory contents rule response (E) is "[the item]".
    holdall inventory contents rule response (F) is ", e [if item is specially-inventoried][item][otherwise][the item][end if]".
    holdall inventory contents rule response (G) is ". [Item]".
    holdall inventory contents rule response (H) is ". [The item]".
    holdall inventory contents rule response (I) is " [regarding the item][sei] [vuoto]".
    supporter inventory contents rule response (A) is ", e [regarding the player][hai]".
    supporter inventory contents rule response (B) is ". [regarding the player][maiuscolo][Hai][maiuscolo] anche".
    supporter inventory contents rule response (C) is " [list of listed when carried things on the item] sopra ".
    supporter inventory contents rule response (D) is "[item]".
    supporter inventory contents rule response (E) is "[the item]".
    supporter inventory contents rule response (F) is ", e [if item is specially-inventoried][item][otherwise][the item][end if]".
    supporter inventory contents rule response (G) is ". [Item]".
    supporter inventory contents rule response (H) is ". [The item]".
    supporter inventory contents rule response (I) is " non [regarding the item][hai] nulla sopra".
    inventory intro rule response (A) is "[run paragraph on]".
    empty inventory rule response (A) is "Non [regarding the player][stai] portando nulla[run paragraph on]".
    non-empty inventory rule response (A) is "[regarding the player][maiuscolo][Stai][maiuscolo] portando [list of listed when carried things carried by the player][run paragraph on]".
    empty wearing rule response (A) is "[run paragraph on]".
    non-empty wearing rule response (A) is ", ma [regarding the player][stai]".
    non-empty wearing rule response (B) is ". [regarding the player][maiuscolo][Stai][maiuscolo]".
    non-empty wearing rule response (C) is " indossando [list of listed when worn things worn by the player][run paragraph on]".
    deliver second-level inventory list rule response (A) is ". [run paragraph on]".
    inventory outro rule response (A) is "[paragraph break]".
    inventory special rule response (A) is "[inventory listing of target]".
    inventory normal rule response (A) is "[target with article]".


Trinity Inventory IT ends here.

---- DOCUMENTATION ----

Read the original documentation of 5/070114 of Trinity Inventory by Mikael Segercrantz.
