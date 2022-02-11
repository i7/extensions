Screenreader by Zed Lopez begins here.

"On startup, asks user 'Are you using a screenreader?' and sets
 a global that can subsequently be tested. For 6M62."

Use authorial modesty.

Interface-value is a kind of value.
Some interface-values are default-interface, screenreader.
The interface is an interface-value that varies.

Use screenreader query translates as (- Constant SCREENREADER_QUERY; -).

First when play begins when the screenreader query option is active (this is the ask about screenreader rule):
  close-status-window;
  clear the screen;
  let the screenreader-query-question be "Are you using a screenreader?" (A);
  if the player agrees to the screenreader-query-question, now the interface is screenreader;
  open-status-window;
  clear the screen.

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
-).

To decide if ask y-or-n for/with a/an/-- (T - a text): (- EnterYorN({T}) -).

To decide if the/a/-- player agrees to/with a/an/-- (T - a text):
    now T is "[line number 1 in T] "; [strip spaces then add one back at the end]
    decide on whether or not ask y-or-n for T.

Part Simple Spelling (for use with Simple Spelling by Alice Grove)

The introduce the simple spelling features rule does nothing.

Use simple spelling features intro translates as (- Constant SIMPLE_SPELLING_INTRO; -).

Last when play begins (this is the conditionally introduce simple spelling features rule):
  if the simple spelling features intro option is active, say text of introduce the simple spelling features rule response (B).

Part clear windows (for use without Basic Screen Effects by Emily Short)

To clear the/-- screen: (- VM_ClearScreen(0); -).

Part shut that down

Section Flexible Status (for use with Flexible Windows by Jon Ingold)

Use no status bar with screenreaders translates as (- Constant NO_SCREENREADER_STATUSBAR; -).

To close-status-window: close the status window.
To open-status-window:
    unless the interface is screenreader and the no status bar with screenreaders option is active, open the status window.
    
Section Inflexible Status (for use without Flexible Windows by Jon Ingold)

To close-status-window: do nothing.
To open-status-window: do nothing.

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

Chapter Examples

Example: * "Screenreader Demo"

	*: "Screenreader Demo"

	Include Screenreader by Zed Lopez.

	Use screenreader query.

	After looking when the interface is not screenreader, say "Gratuitous image."

	Lab is a room.

	Test me with "look".
