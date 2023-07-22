After Action Report by Zed Lopez begins here.

"Demonstrates capturing output of in-world actions for post-processing.
 Here it's paginating the text manually. This is a goof; for a real project,
 let the interpreter do it."

capturing is initially true.

before reading a command: now capturing is false.

To say captured action:
  try the current action;

character target is initially 800.

before doing anything when capturing is false:
  now capturing is true;
  let t be the substituted form of "[captured action]";
  now capturing is false;
  let line count be the number of lines in t;
  let character count be 0;
  let line be "";
  repeat with i running from 1 to line count begin;
    now line is line number i in t;
    say line;
    if i is line count, break;
    now character count is character count + the number of characters in line;
    if (i < line count) and (character count + (number of characters in line number (i + 1) in t) > character target) begin;
      solicit pressing any key saying "[line break]--More --";
      now character count is 0;
    end if;
    unless character count is 0, say paragraph break;
  end repeat;
  say paragraph break;
  stop the action;

Chapter not key (for use without Key Input by Zed Lopez)

To solicit pressing any key saying (T - a text):
  say T;
  say " ";
  wait for any key;


Section Not basic (for use without Basic Screen Effects by Emily Short)

Include (-
[ getRelevantKey key;
  while((key = VM_KeyChar()) == -4 or -5 or -10 or -11 or -12 or -13) continue;
  return key;
];
-).

To wait for a/any/-- key: (- getRelevantKey(); -)

After Action Report ends here.

---- Documentation ----

The technique of capturing all (not out-of-world) actions for post-processing might
be of some interest, even if program-control of pagination is not.
