Version 1 of Parser Error Details (for Glulx only) by Zed Lopez begins here.

"Says where the parser ceased understanding a command, and describes
 ways the dictionary does know how to use that verb. Tested on 6M62."

"based on code by Aaron Reed and Andrew Plotkin" [ https://intfiction.org/t/i7-parser-errors-what-parts-did-the-parser-understand/1320/ ]

Use authorial modesty.

Use DICT_WORD_SIZE of 10.
Use show commands after parser error translates as (- Constant SHOW_COMMANDS_AFTER_PARSER_ERROR; -).

Command-showing is an action out of world applying to one topic.
Understand "showcommand [text]" as command-showing.

Carry out command-showing: describe-verb.

To describe-verb: (- DescribeVerbSub(); -).

After printing a parser error when the show commands after parser error option is active: now VerbToExplain is true.

VerbToExplain is a truth state that varies.

For reading a command when VerbToExplain is true and the show commands after parser error option is active:
now VerbToExplain is false;
replace the player’s command with "showcommand [word number 1 in the player’s command]".

VerbExplaining is an action out of world applying to nothing.

To verb-explain: (- DescribeVerbSub(); -).

To say dictionary word entry (n - a number): (- print (address) {n}; -)

To say canonical verb for (n - a number) and (act - an action name) (this is canon-verb):
  say canonical verb text for n and act.

To decide what text is the canonical verb text for/-- (n - a number) and (act - an action name):
  [ will always be a single word; return value should always be a single word ]
  let t be the substituted form of the canonical verb text for n;
  let act-name be the substituted form of "[act]";
  if act-name is "throwing it at", decide on "throw";
  if act-name is "examining" and t is "look", decide on "examine";
  if act-name is "switching off" and t is "close", decide on "shut";
  decide on t;

To decide what text is the canonical verb text for/-- (n - a number):
  let t be the substituted form of "[dictionary word entry n]";
  if t is "hop" or t is "skip", decide on "jump";
  if t is "carry" or t is "hold", decide on "take";
  if t is "don", decide on "wear";
  if t is "discard", decide on "drop";
  if t is "pay" or t is "offer" or t is "feed", decide on "give";
  if t is "present" or t is "display", decide on "show";
  if t is "walk" or t is "run", decide on "go";
  if t is "i" or t is "inv", decide on "inventory";
  if t is "l", decide on "look";
  if t is "unwrap" or t is "uncover", decide on "open";
  if t is "shut" or t is "cover", decide on "close";
  if t is "cross", decide on "enter";
  if t is "leave" or t is "out", decide on "exit";
  if t is "x" or t is "watch" or t is "describe" or t is "check", decide on "examine";
  if t is "y", decide on "yes";
  if t is "adjust", decide on "set";
  if t is "drag", decide on "pull";
  if t is "move" or t is "shift" or t is "clear" or t is "press", decide on "push";
  if t is "rotate" or t is "twist" or t is "unscrew" or t is "screw", decide on "turn";
  if t is "break" or t is "smash" or t is "hit" or t is "fight" or t is "torture" or t is "wreck" or t is "crack" or t is "destroy" or t is "murder" or t is "kill" or t is "punch" or t is "thump", decide on "attack";
  if t is "z", decide on "wait";
  if t is "nap", decide on "sleep";
  if t is "scale", decide on "climb";
  if t is "purchase", decide on "buy";
  if t is "squash", decide on "squeeze";
  if t is "awake" or t is "awaken", decide on "wake";
  if t is "embrace" or t is "hug", decide on "kiss";
  if t is "sniff", decide on "smell";
  if t is "feel", decide on "touch";
  if t is "shine" or t is "polish" or t is "sweep" or t is "clean" or t is "dust" or t is "wipe" or t is "scrub", decide on "rub";
  if t is "attach" or t is "fasten", decide on "tie";
  if t is "light", decide on "burn";
  if t is "swallow" or t is "sip", decide on "drink";
  decide on t; 

Include (-

[ DescribeVerbSub address lines meta i x verb_addr;
  wn = 2; x = NextWordStopped();
  if (x == 0 || ((x->#dict_par1) & 1) == 0) return;
  meta = ((x->#dict_par1) & 2)/2;
  i = DictionaryWordToVerbNum(x);
  address = VM_CommandTableAddress(i);
  lines = address->0;
  address++;
  verb_addr = VM_PrintCommandWords_spec(i);
  new_line;
  if (lines == 0) "has no grammar lines.";
  for (: lines>0 : lines-- ) {
    address = UnpackGrammarLine(address);
    print " "; VerbDebugGrammarLine(verb_addr); new_line;
  }
  ParaContent();
];

[ VerbDebugGrammarLine verb_addr pcount;
    print " * ";
((+ canon-verb +)-->1)(verb_addr,action_to_be);
    for (: line_token-->pcount ~= ENDIT_TOKEN : pcount++) {
      if ((line_token-->pcount)->0 & $10) print "/";
      else print " ";
      print (VerbDebugToken) line_token-->pcount; !, " ";
    }
    print " -> ", (SayActionName) action_to_be;
    !print " (", (VerbDebugAction) action_to_be, ")";
    if (action_reversed) print " (with nouns reversed)";
];

[ VerbDebugAction a str;
    if (a >= 4096) { print "<fake action ", a-4096, ">"; return; }
    if (a < 0 || a >= #identifiers_table-->7) print "<invalid action ", a, ">";
    else {
        str = #identifiers_table-->6;
        str = str-->a;
        if (str) print (string) str; else print "<unnamed action ", a, ">";
    }
];

[ VerbDebugToken token;
  AnalyseToken(token);
  switch (found_ttype) {
    ILLEGAL_TT:
    print "<illegal token number ", token, ">";
    ELEMENTARY_TT:
    switch (found_tdata) {
      NOUN_TOKEN: print "{something}";
      HELD_TOKEN: print "{something held}";
      MULTI_TOKEN: print "{one or more things}";
      MULTIHELD_TOKEN: print "{one or more things held}";
      MULTIEXCEPT_TOKEN: print "{one or more things}";
      MULTIINSIDE_TOKEN: print "{one or more things inside another thing}";
      CREATURE_TOKEN: print "{someone}";
      SPECIAL_TOKEN: print "{special}";
      NUMBER_TOKEN: print "{a number}";
      TOPIC_TOKEN: print "{any text}";
      ENDIT_TOKEN: print "{END}";
    }
    PREPOSITION_TT:
    print "", (address) found_tdata, "";
    ROUTINE_FILTER_TT: print "<noun routine>";
    ATTR_FILTER_TT:
    print (VerbDebugAttribute) found_tdata;
    SCOPE_TT: print "<scope routine>";
    GPR_TT: print "<GPR routine>";
  }
  return found_ttype;
];

[ VerbDebugAttribute a str;
    if (a < 0 || a >= NUM_ATTR_BYTES*8) print "<invalid attribute ", a, ">";
    else {
        str = #identifiers_table-->4;
        str = str-->a;
        if (str) print (string) str; else print "<unnamed attribute ", a, ">";
    }
];

[ VM_PrintCommandWords_spec i wd j dictlen entrylen ctr result found;
  ctr = 0;
  found = 0;
  dictlen = #dictionary_table–->0;
  entrylen = DICT_WORD_SIZE + 7;
  for (j = 0 : j < dictlen : j++ ) {
    wd = #dictionary_table + WORDSIZE + (entrylen * j);
    if (DictionaryWordToVerbNum(wd) == i) found++;
    if (found > 1) break;
  }
  for (j = 0 : j < dictlen : j++ ) {
    wd = #dictionary_table + WORDSIZE + (entrylen * j);
    if (DictionaryWordToVerbNum(wd) == i) {
      if (ctr == 0) result = wd;
      if (ctr >= 1) print ", ";
      if (ctr == 0) { 
        print "Here are all the ways I know how to use the verb";
        if (found > 1) print "s";
        print " ";
      }
      print (address) wd;
      ctr++;
    }
  }
  print ": ";
  return result;
];
-).

Rule for printing a parser error when the latest parser error is the only understood as far as error and the show commands after parser error option is active:
  let cw be "[the command word]";
  let cu be "[the partial command understood]";
  let mw be "[the misunderstood words]";
  say "I understood the command '[cu]'[unless cw exactly matches the text cu] (that is, '[cw]')[end unless], but not the word";
  if mw matches the text " ", say "s";
  say " '";
  say the misunderstood words;
  say "' at the end.";

To say the command word: (- SayCommandWord(); -).
To say the partial command understood: (- SayCommandUnderstood(); -).
To say the misunderstood word/words: (- SayMisunderstoodWords(); -).

Include (-

[ SayCommandWord m;
	for (m=0 : m<32 : m++) pattern-->m = pattern2-->m;
	pcount = pcount2;
	PrintCommand(0);
];

[ SayCommandUnderstood m ix addr len;
	for (ix=1: ix < wn-1; ix++) {
		if (ix ~= 1) print " ";
		addr = WordAddress(ix);
		len = WordLength(ix);
		while (len) {
			print (char) addr->0;
			addr++; len--;
		}
	}
];

[ SayMisunderstoodWords ix addr len;
	for (ix=wn-1 : ix <= num_words; ix++) {
		if (ix ~= wn-1) print " ";
		addr = WordAddress(ix);
		len = WordLength(ix);
		while (len) {
			print (char) addr->0;
			addr++; len--;
		}
	}
];
-)

Parser Error Details ends here.

---- Documentation ----

This offers ``showcommand``, which beefs up version of the testing command ``showverb``,
chiefly by listing all of the equivalent verbs for a given verb.

It has no dependency on ShowVerbSub or any testing routines, so it could be compiled for release.

The use option:

```
Use show commands after parser error.
```

makes it automatically invoke after parser errors.

This is offered as a running version of Andrew and Aaron's decade-old proofs of concept.
``showcommand`` may be useful to authors during development, but I don't conceive of
this as something anyone would want to drop as is into a game for release.
