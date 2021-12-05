Version 1/211205 of Supercredits by Zed Lopez begins here.

"Provides the Supercredits command to list the complete list of extension
credits (i.e., including those that use authorial modesty) alphabetized by
author name then extension name, and formatted nicely. The whole extension
is marked Not for Release. For 6M62."

Volume Supercredit (Not for release)

Use authorial modesty.

Part Inclusions

Include Text Loops by Zed Lopez.

Part Left-padding helpers (for use without Textile by Zed Lopez)

To say (N - a number) copies of (T - a text):
    repeat with i running from 1 to N begin;
      say T;
    end repeat.

To decide what text is (N - a number) spaces:
    let T be " ";
    decide on "[N copies of T]";

Part Define the Table

[ Counterfeit Monkey has 84 extensions; Scroll Thief has 45. ]
Table of AuthExts
toa-auth (text)	auth-len (number)
with 50 blank rows.

Part Set Up the Command

Chapter Understanding

[ Be warned: Without setting DICT_WORD_SIZE > 9,
  I7 can't tell "supercredits" from "supercredo". ]
Understand "supercredits" as supercrediting.

Chapter Action

Supercrediting is an action out of world.
Carry out supercrediting (this is the supercrediting rule): supercredit.
  
Part Output supercredits rule

To supercredit: follow the output supercredits rule.

This is the output supercredits rule:
  let L be a list of texts;
  let ext-credits be  "[the list of extension credits]";
  repeat for line in lines of ext-credits begin;
     add line to L;
  end repeat; 
  let regexp be "^(.+?)\s+by\s+(<^(>+)(\s+\(.*)?";
  let complete-ext-credits be "[the complete list of extension credits]";
  let max_auth_length be 0;
  blank out the whole of the Table of AuthExts;
  let overflow_warning be false;
  repeat for line in lines of complete-ext-credits with index i begin;
    if line matches the regular expression regexp begin;
      let auth be substituted form of "[text matching subexpression 2]";
      if the number of blank rows in the Table of AuthExts is 0 begin;
        if overflow_warning is false begin;
          now overflow_warning is true;
          let overflow be number of lines in complete-ext-credits plus 1 minus i;
          say "[line break]** Number of extensions exceeds capacity. [overflow] extension[if overflow > 1]s[end if] not sorted/formatted:[line break]" (A);
        end if;
        say "   [auth] / [text matching subexpression 1] [if line is not listed in L]*[end if][line break]" (B);
        next;
      end if;
      let auth_len be the number of characters in auth;
      if auth_len > max_auth_length, now max_auth_length is auth_len;
      choose a blank row from the table of authexts;
      now toa-auth entry is the substituted form of the "[auth] / [text matching subexpression 1] [if line is not listed in L]*[end if]" (C);
      now auth-len entry is auth_len;
    else; say "** Error: didn't match [line]." (D);
    end if;
   end repeat;
   sort table of AuthExts in toa-auth order;
   if overflow_warning is true, say "[line break]";
   unless the number of entries in L is the number of rows in the Table of AuthExts, say "* indicates modesty[line break][line break]" (E);
   increment max_auth_length; [ one extra space on the left ]
   repeat through Table of AuthExts begin;
     say "[(max_auth_length - auth-len entry) spaces][toa-auth entry][line break]" (F);
   end repeat;

Supercredits ends here.

---- Documentation ----

Section Explanation

Adds a "supercredits" command that lists all included extensions, including those marked with authorial modesty, alphabetized first by author, then by extension name. The whole extension is marked not for release.

By default, it can work with a list of up to 50 extensions. If you wanted to add 25 more, add this to your story:

```
Table of AuthExts (continued)
with 25 blank rows.
```

There isn't catastrophic failure if you exceed the limit; extensions in excess of that will be reported, just not formatted and sorted with the others. 

Section Example

Example: * Supercredits

	"Supercredits"

	Include Supercredits by Zed Lopez.

	Lab is a room.

	Test me with "supercredits".

produces, e.g.:

```

>test me
(Testing.)

>[1] supercredits
* indicates modesty

 Friends of I7 / 6M62 Patches version 2/210913 *
 Graham Nelson / English Language version 1 *
 Graham Nelson / Standard Rules version 3/120430
     Zed Lopez / Supercredits version 1/211205 *
     Zed Lopez / Text Loops version 1

>
```

Section Changelog

1/211205: Added specific instructions for continuing table to documentation.
