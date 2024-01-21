Version 1.0.240121 of Reparse by Nathanael Nerode begins here.

"Provides a hook for the game, or other extensions, to send a different command through the parser."

Chapter - Core Reparsing

Section - Command Debugging

Use command debugging translates as a configuration flag.

Section - Special Reparse Flag

[Are we currently heading into a reparse?]
The special reparse flag is a truth state that varies.

Section - Revised Command Text For Reparsing

[This is the text to be reparsed]
The revised command text for reparsing is a text that varies.

Section - Reparse Silently Flag

[Should we issue no command clarification when we reparse?]
The reparse silently flag is a truth state that varies.

Section - Reparsing

[This is done when the action decides to kick the command back to reparse.]
[Sometimes we can't decide to do that until after the action has triggered.]

[The reparse is actually done by moving on to the next cycle in the turn sequence.  But we don't want to advance the turn count.]
[So this is injected just after the action, and before anything else happens.]
[This will terminate processing of the turn rulebook completely, in particular before time is advanced.]
The turn terminated for reparsing rule is listed before the early scene changing stage rule in the turn sequence rulebook.
This is the turn terminated for reparsing rule:
    if the special reparse flag is true, rule succeeds.

[Replace the command reading routine with one which simply processes our prepackaged command.]
For reading a command when the special reparse flag is true (this is the parse revised command rule):
	if the command debugging option is active or the reparse silently flag is false:
		say "([revised command text for reparsing])[command clarification break]";
	change the text of the player's command to the revised command text for reparsing;
	now the special reparse flag is false;

Section - Request reparsing by phrase

To reparse with/using the/a/-- command/-- (T - a text), silently:
	now the revised command text for reparsing is the substituted form of T;
	now the special reparse flag is true;
	if silently:
		now the reparse silently flag is true;
	otherwise:
		now the reparse silently flag is false;

Reparse ends here.

---- DOCUMENTATION ----

This provides a hook.  Suppose you're doing some clever parsing and partway through you decide you would really rather
have the game interpret it as a different command.  This sends it back through the parser, starting the whole parsing and
action generation process over again.

It should be used in Instead, Before, or Check rulebooks, or parser error responses, or similar.  If it is used too late,
two turns will happen.  The actual mechanism is to go to the next turn, but skipping the rest of this turn (including
skipping the carry out rules, advance time rules, etc.)  It is essential to stop the rest of this turn's processing.

This is invoked with a phrase:

    T is "pick up the box";
    reparse with T;
    stop the action;

It is essential with the phrase to include the "stop the action" line yourself; the phrase can't do it.

Because most of the applications of this are alternative phrasings for "standard" IF stuff, the
default implementation of this gives a command clarification, telling the player what the rewritten
command is, to steer them in the right direction.
To suppress this with the phrase, use the "silently" option:

    T is "pick up the box";
    reparse with T, silently;
    stop the action;

The ``Use command debugging`` option will make all the silent versions issue a clarification.

This extension is used by Compliant Characters by Nathanael Nerode.
It is used in the revised Remembering by Aaron Reed (revised by Nathanael Nerode).

Changelog:

	1.0.240121: Broken out from Compliant Characters and made fancy for use in Remembering.
