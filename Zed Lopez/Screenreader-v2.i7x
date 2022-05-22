Version 2 of Screenreader by Zed Lopez begins here.

"On startup, asks user 'Are you using a screenreader?' and sets
 a global that can subsequently be tested."

Use authorial modesty.

Interface-value is a kind of value.
Some interface-values are default-interface, screenreader.
The interface is an interface-value that varies.

Screenreader-toggling something is an activity on truth states.

Screenreader-setting is an action out of world.
Understand "screenreader on/--" or "screenreader off" as screenreader-setting.

Carry out screenreader-setting:
  if the player's command includes "off", carry out the screenreader-toggling activity with false;
  else carry out the screenreader-toggling activity with true;

Report screenreader-setting:
  say "Screenreader mode is [if the interface is screenreader]on[else]off[end if].";

For screenreader-toggling a truth state (called status):
  if status is true, now the interface is screenreader;
  else now the interface is default-interface.
  
Use screenreader query translates as (- Constant SCREENREADER_QUERY; -).

Book without Inquiry or Agreeable (for use without Inquiry by Zed Lopez)

Part agreement (for use without Agreeable by Zed Lopez)

First when play begins when the screenreader query option is active (this is the ask about screenreader rule):
  let the screenreader-query-question be "Are you using a screenreader? y/n" (A);
  if the player agrees to the screenreader-query-question begin;
    say "Y";
    carry out the screenreader-toggling activity with true;
  else;
    say "N";
  end if;
  say line break;

Include (-
[ EnterYorN t key;
  TEXT_TY_Say(t);
  while(key = VM_KeyChar()) {
    if (key == 'y' or 'Y') rtrue;
    if (key == 'n' or 'N') rfalse;
    if (key == -6 && t) { print "^"; TEXT_TY_Say(t); }
  }
];
-).

To decide if ask y-or-n for/with a/an/-- (T - a text): (- EnterYorN({T}) -).

To decide if the/a/-- player agrees to/with a/an/-- (T - a text):
    now T is "[line number 1 in T] "; [strip spaces then add one back at the end]
    decide on whether or not ask y-or-n for T.

Book Inquiries (for use with Inquiry by Zed Lopez)

screenreader-inquiry is an answered y/n inquiry. 

[ This is just to make the text modifiable as a rule response ]
This is the ask screenreader question rule:
  if the screenreader query option is active begin;
    now the description of the screenreader-inquiry is "Are you using a screenreader? y/n" (B);
    now screenreader-inquiry is unanswered;
  end if;

After inquiring an inquiry (called q) when q is the screenreader-inquiry:
    carry out the screenreader-toggling activity with boolean-answer of q.

Before inquiry handling when pregame-inquiry is true and screenreader query option is active:
    follow the ask screenreader question rule.

Book other extension interactions

Part Alternative (for use with Alternative Startup Rules by Dannii Willis)

The initial whitespace rule does nothing.

Part Simple Spelling (for use with Simple Spelling by Alice Grove)

The introduce the simple spelling features rule does nothing.

Use simple spelling features intro translates as (- Constant SIMPLE_SPELLING_INTRO; -).

Last when play begins (this is the conditionally introduce simple spelling features rule):
  if the simple spelling features intro option is active, say text of introduce the simple spelling features rule response (B).

Part shut that down

Section Flexible Status (for use with Flexible Windows by Jon Ingold)

Use no status bar with screenreaders translates as (- Constant NO_SCREENREADER_STATUSBAR; -). 

Before inquiry handling when pregame-inquiry is true and screenreader query option is active:
  close the status window.

After screenreader-toggling a truth state (called status):
  if interface is screenreader and no status bar with screenreaders option is active, close the status window;
  else open the status window.

[The screenreader close status window rule does nothing if the no status bar with screenreaders option is active.]

Volume Use screenreader (for release only)

Use screenreader query.

Screenreader ends here.

---- Documentation ----

When not compiling for release, this extension doesn't do anything, unless you:

```
Use screenreader query.
```

Then on startup, the game will clear the screen and ask "Are you using a screenreader?". Your story can then include queries like:

```
if the interface is screenreader [...]
```

Using screenreader query is the default when compiling for release; if that isn't desired, override the relevant section (or un-include the extension).

If you'd like to change the question, add something like:

```
First when play begins: now the ask about screenreader rule response (A) is "Are you using a screenreader? (Y/N)".
```

If your story includes Flexible Windows by Jon Ingold and you want to deactivate the status bar when the interface is screenreader, you can:

```
Use no status bar with screenreaders.
```

If your story includes Simple Spelling by Alice Grove, this extension deactivates Simple Spelling's own presentation of such a question, and along with it, that extension's display of introductory text if the user says yes. If you *do* want to print that text:

```
Use simple spelling features intro.
```

If you include Simple Spelling at all, the "spell" command will exist; this Use option only affects whether the intro text is displayed. If you want to display some other text:

```
Use simple spelling features intro.
First when play begins: now the introduce the simple spelling features rule response (B) is "Alternative text.[line break]"
```

Chapter Changelog

Version 2: created screenreader-toggling activity; added screenreader on/off commands; ceased clearing screen; added Inquiry support.

Chapter Examples

Example: * "Screenreader Demo"

	*: "Screenreader Demo"

	Include Screenreader by Zed Lopez.

	Use screenreader query.

	After looking when the interface is not screenreader, say "Gratuitous image."

	Lab is a room.

	Test me with "look".
