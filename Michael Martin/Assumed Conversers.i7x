Version 2 of Assumed Conversers by Michael Martin begins here.

"A minimal extension that makes the NPC optional in ASK NPC ABOUT TOPIC and TELL NPC ABOUT TOPIC commands."

[Version 2: Workaround for bizarre action redirection bug in 5T18. Fixed problems where the default converser won't reassign sensibly when going.]

Use authorial modesty.

The default converser is a person that varies. The default converser is yourself.
Asking generically is an action applying to one topic. Understand "ask about [text]" or "a [text]" as asking generically.
Telling generically is an action with past participle told, applying to one topic. Understand "tell about [text]" and "t [text]" as telling generically. 

Check asking generically (This is the check for only one sensible converser rule):
  change the default converser to the player;
  if the number of persons enclosed by the location is two begin;
    repeat with candidate running through the persons enclosed by the location begin;
      if the candidate is not the player, change the default converser to the candidate;
    end repeat;
  end if.

Check asking generically (This is the check for sensible converser rule):
  if the default converser is player, say "[bracket]I can't figure out who you want to talk to.[close bracket][paragraph break]" instead;
  if the default converser is not visible, say "[The default converser] isn't here anymore." instead.

Check asking generically (This is the convert to asking it about rule):
	try asking the default converser about instead.

The check for only one sensible converser rule is listed in the check telling generically rules.
The check for sensible converser rule is listed in the check telling generically rules.
Check telling generically (this is the convert to telling it about rule):
	try telling the default converser about instead.

The convert to asking it about rule is listed last in the check asking generically rules.
The convert to telling it about rule is listed last in the check telling generically rules.

Before asking or telling or answering (this is the log latest converser rule):
  change the default converser to the noun.

Assumed Conversers ends here.

---- DOCUMENTATION ----

This extension enables the player to use the commands ASK ABOUT TOPIC or TELL ABOUT TOPIC when in extended conversation with a single character. It will normally direct conversation to the last person talked to, but if only one other person is in the location, it will direct it to that person instead.

The extremely short forms A TOPIC and T TOPIC are also provided.

No special support in the main source text is needed; just include Assumed Conversers.
