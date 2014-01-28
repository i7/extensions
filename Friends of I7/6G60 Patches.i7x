Version 1 of 6G60 Patches by Friends of I7 begins here.

"Patches to work around bugs in version 6G60 of Inform 7 for which an extension-based workaround is known to exist."

"Including workarounds by Jesse McGrew, Ron Newcomb, and SJ_43."

Volume "Common Code"

Chapter "Loops"

To repeat until a break begin -- end: (- for (::) -).

Chapter "I6 Access"

To decide what object is the I6 parent of (O - an object): (- parent({O}) -).

To decide whether a library message should be issued: (- (actor == player && ~~untouchable_silence) -).

Chapter "Output Control"

Include (-
#ifdef TARGET_ZCODE;
	Constant DISCARDED_OUTPUT_LENGTH = 256;
	Array discarded_output buffer DISCARDED_OUTPUT_LENGTH;
#endif;
-) after "Definitions.i6t".

To hide output: (-
#ifdef TARGET_ZCODE;
	@output_stream 3 discarded_output;
#ifnot;
	@getiosys sp sp;
	@setiosys 0 0;
#endif;
-).

To unhide output: (-
#ifdef TARGET_ZCODE;
	@output_stream -3;
	if (discarded_output-->0 > DISCARDED_OUTPUT_LENGTH - WORDSIZE) {
		print "Error: Overflow in hiding output.^";
	}
#ifnot;
	@stkswap;
	@setiosys sp sp;
#endif;
-).

Chapter "Extra Runtime Problems"

[This will eventually be rolled into the workaround for 0001165.]

Include (-
	Constant RTP_CANTCHANGETOPART = 61;
	Constant RTP_CANTMAKEPLAYERPART = 62;
-) after "Definitions.i6t".

Include (-
	[ ExtraRunTimeProblem n par1 par2 par3;
		if (~~enable_rte) {
			return;
		}
		enable_rte = false;
		print "^*** Run-time problem P", n, ": ";
		switch (n) {
			RTP_CANTCHANGETOPART:
				print "Attempt to change the player to ", (the) par1, ", who is part of something, ", (the) par2, ".^";
			RTP_CANTMAKEPLAYERPART:
				print "Attempt to make the player part of ", (the) par1, ".^";
		}
		print "^";
	];
-).

Volume "0000356"

Include (-
	[ ReversedHashTableRelationHandler rel task X Y  kov kx ky;
		kov = BlkValueRead(rel, RRV_KIND);
		kx = KindBaseTerm(kov, 0); ky = KindBaseTerm(kov, 1);
		switch (task) {
			RELS_SET_VALENCY:
				return RELATION_TY_SetValency(rel, X);
! BEGIN CHANGE FOR 0000356
			RELS_TEST, RELS_ASSERT_TRUE, RELS_ASSERT_FALSE, RELS_SHOW:
! END CHANGE FOR 0000356
				return HashCoreRelationHandler(rel, task, ky, kx, Y, X, 0);
			RELS_LOOKUP_ANY:
				switch (Y) {
					RLANY_GET_X: Y = RLANY_GET_Y;
					RLANY_GET_Y: Y = RLANY_GET_X;
					RLANY_CAN_GET_X: Y = RLANY_CAN_GET_Y;
					RLANY_CAN_GET_Y: Y = RLANY_CAN_GET_X;
				}
			RELS_LOOKUP_ALL_X:
				task = RELS_LOOKUP_ALL_Y;
			RELS_LOOKUP_ALL_Y:
				task = RELS_LOOKUP_ALL_X;
! BEGIN CHANGE FOR 0000356
! END CHANGE FOR 0000376
			RELS_LIST:
				switch (Y) {
					RLIST_ALL_X: Y = RLIST_ALL_Y;
					RLIST_ALL_Y: Y = RLIST_ALL_X;
				}
		}
		return HashCoreRelationHandler(rel, task, kx, ky, X, Y, 0);
	];
-) instead of "Reversed Hash Table Relation Handler" in "RelationKind.i6t".

Volume "0000376"

Section SR1/0 - Language (in place of Section SR1/0 - Language in Standard Rules by Graham Nelson)

The verb to relate (he relates, they relate, he related, it is related,
he is relating) implies the universal relation.

The verb to provide (he provides, they provide, he provided, it is provided,
he is providing) implies the provision relation.

The verb to be in implies the reversed containment relation.
The verb to be inside implies the reversed containment relation.
The verb to be within implies the reversed containment relation.
The verb to be held in implies the reversed containment relation.
The verb to be held inside implies the reversed containment relation.

The verb to contain (he contains, they contain, he contained, it is contained,
he is containing) implies the containment relation.
The verb to be contained in implies the reversed containment relation.

The verb to be on implies the reversed support relation.
The verb to be on top of implies the reversed support relation.

The verb to support (he supports, they support, he supported, it is supported,
he is supporting) implies the support relation.
The verb to be supported on implies the reversed support relation.

The verb to incorporate (he incorporates, they incorporate, he incorporated,
it is incorporated, he is incorporating) implies the incorporation relation.
The verb to be part of implies the reversed incorporation relation.
The verb to be a part of implies the reversed incorporation relation.
The verb to be parts of implies the reversed incorporation relation.

[BEGIN CHANGE for 0000376]
The verb to enclose per the enclosure relation (it encloses per the enclosure relation, they enclose per the enclosure relation, it enclosed per the enclosure relation, it is enclosed per the enclosure relation, it is enclosing per the enclosure relation) implies the enclosure relation.
Tweaked enclosure relates an object (called the vessel) to an object (called the contents) when the vessel encloses per the enclosure relation the contents.
The verb to enclose (it encloses, they enclose, it enclosed, it is enclosed, it is enclosing) implies the tweaked enclosure relation.
[END CHANGE for 0000376]

The verb to carry (he carries, they carry, he carried, it is carried, he is
carrying) implies the carrying relation.
The verb to hold (he holds, they hold, he held, it is held, he is holding)
implies the holding relation.
The verb to wear (he wears, they wear, he wore, it is worn, he is wearing)
implies the wearing relation.

Definition: a thing is worn if the player is wearing it.
Definition: a thing is carried if the player is carrying it.
Definition: a thing is held if the player is holding it.

The verb to be able to see (he is seen) implies the visibility relation.
The verb to be able to touch (he is touched) implies the touchability relation.

Definition: Something is visible rather than invisible if the player can see it.
Definition: Something is touchable rather than untouchable if the player can touch it.

The verb to conceal (he conceals, they conceal, he concealed, it is concealed,
he is concealing) implies the concealment relation.
Definition: Something is concealed rather than unconcealed if the holder of it conceals it.

Definition: Something is on-stage rather than off-stage if I6 routine "OnStage"
	makes it so (it is indirectly in one of the rooms).

The verb to be greater than implies the numerically-greater-than relation.
The verb to be less than implies the numerically-less-than relation.
The verb to be at least implies the numerically-greater-than-or-equal-to relation.
The verb to be at most implies the numerically-less-than-or-equal-to relation.

Volume "0000384"

Include (-
	!Constant TRACE_I7_SPACING;
	
	[ ClearParagraphing;
		say__p = 0; say__pc = 0;
	];
	
	[ DivideParagraphPoint;
! BEGIN CHANGE FOR 0000384
		if (statuswin_current) return;
! END CHANGE FOR 0000384
		#ifdef TRACE_I7_SPACING; print "[DPP", say__p, say__pc, "]"; #endif;
		if (say__p) {
			new_line; say__p = 0; say__pc = say__pc | PARA_COMPLETED;
			if (say__pc & PARA_PROMPTSKIP) say__pc = say__pc - PARA_PROMPTSKIP;
			if (say__pc & PARA_SUPPRESSPROMPTSKIP) say__pc = say__pc - PARA_SUPPRESSPROMPTSKIP;
		}
		#ifdef TRACE_I7_SPACING; print "[-->", say__p, say__pc, "]"; #endif;
		say__pc = say__pc | PARA_CONTENTEXPECTED;
	];
	
	[ ParaContent;
		if (say__pc & PARA_CONTENTEXPECTED) {
			say__pc = say__pc - PARA_CONTENTEXPECTED;
			say__p = 1;
		}
	];
	
	[ GoingLookBreak;
		if (say__pc & PARA_COMPLETED == 0) new_line;
		ClearParagraphing();
	];
	
	[ CommandClarificationBreak;
		new_line;
		ClearParagraphing();
	];
	
	[ RunParagraphOn;
		#ifdef TRACE_I7_SPACING; print "[RPO", say__p, say__pc, "]"; #endif;
		say__p = 0;
		say__pc = say__pc | PARA_PROMPTSKIP;
		say__pc = say__pc | PARA_SUPPRESSPROMPTSKIP;
	];
	
	[ SpecialLookSpacingBreak;
		#ifdef TRACE_I7_SPACING; print "[SLS", say__p, say__pc, "]"; #endif;
		say__p = 0;
		say__pc = say__pc | PARA_PROMPTSKIP;
	];
	
	[ EnsureBreakBeforePrompt;
		if ((say__p) ||
			((say__pc & PARA_PROMPTSKIP) && ((say__pc & PARA_SUPPRESSPROMPTSKIP)==0)))
			new_line;
		ClearParagraphing();
	];
	
	[ PrintSingleParagraph matter;
		say__p = 1;
		say__pc = say__pc | PARA_NORULEBOOKBREAKS;
		PrintText(matter);
		DivideParagraphPoint();
		say__pc = 0;
	];
-) instead of "State" in "Printing.i6t".

Volume "0000389"

[0000389 probably has a workaround, but it may be a lot of work.]

Volume "0000396"

Include (-
! BEGIN CHANGE FOR 0000396
	for (k = 0: k < 32: k++) {
		pattern-->k = PATTERN_NULL;
		pattern2-->k = PATTERN_NULL;
	}
! END CHANGE FOR 0000396
-) after "Parser Letter I" in "Parser.i6t".

Include (-
	Global implied_go = false;
-) after "Definitions.i6t".

Include (-
! BEGIN CHANGE FOR 0000396
	implied_go = (verb_word == 0 || ((verb_word->#dict_par1) & 1) == 0);
! END CHANGE FOR 0000396
-) before "Parser Letter B" in "Parser.i6t".

Include (-
	[ PrintInferredCommand from singleton_noun;
		singleton_noun = FALSE;
		if ((from ~= 0) && (from == pcount-1) &&
			(pattern-->from > 1) && (pattern-->from < REPARSE_CODE))
				singleton_noun = TRUE;
	
		if (singleton_noun) {
			BeginActivity(CLARIFYING_PARSERS_CHOICE_ACT, pattern-->from);
			if (ForActivity(CLARIFYING_PARSERS_CHOICE_ACT, pattern-->from) == 0) {
				print "("; PrintCommand(from); print ")^";
			}
			EndActivity(CLARIFYING_PARSERS_CHOICE_ACT, pattern-->from);
		} else {
			print "("; PrintCommand(from); print ")^";
		}
	];
	
	[ PrintCommand from i k spacing_flag;
	    if (from == 0) {
	        i = verb_word;
! BEGIN CHANGE FOR 0000396
	        if (LanguageVerb(i) == 0 && PrintVerb(i) == 0) {
			if (implied_go) {
				print (address) 'go', " ";
			}
			print (address) i;
		}
! END CHANGE FOR 0000396
	        from++; spacing_flag = true;
	    }
	    for (k=from : k<pcount : k++) {
	        i = pattern-->k;
	        if (i == PATTERN_NULL) continue;
	        if (spacing_flag) print (char) ' ';
	        if (i == 0) { print (string) THOSET__TX; jump TokenPrinted; }
	        if (i == 1) { print (string) THAT__TX;   jump TokenPrinted; }
	        if (i >= REPARSE_CODE)
	            print (address) VM_NumberToDictionaryAddress(i-REPARSE_CODE);
	        else
	            if (i ofclass K3_direction)
	                print (LanguageDirection) i; ! the direction name as adverb
	            else
	                print (the) i;
	      .TokenPrinted;
	        spacing_flag = true;
	    }
	];
-) instead of "Print Command" in "Parser.i6t".

Volume "0000407"

Include (-
	[ TableRowCorr tab col lookup_value lookup_col i j f;
		if (col >= 100) col=TableFindCol(tab, col, true);
		lookup_col = tab-->col;
		j = lookup_col-->0 - COL_HSIZE;
		f=0;
		if (((tab-->col)-->1) & TB_COLUMN_ALLOCATED) f=1;
		for (i=1:i<=j:i++) {
! BEGIN CHANGE FOR 0000407
			if ((lookup_col-->(i+COL_HSIZE) == TABLE_NOVALUE) &&
! END CHANGE FOR 0000407
				(CheckTableEntryIsBlank(tab,col,i))) continue;
			if (f) {
				if (BlkValueCompare(lookup_col-->(i+COL_HSIZE), lookup_value) == 0)
					return i;
			} else {
				if (lookup_col-->(i+COL_HSIZE) == lookup_value) return i;
			}
		}
		return RunTimeProblem(RTP_TABLE_NOCORR, tab);
	];
	
	[ ExistsTableRowCorr tab col entry i k v f kov;
		if (col >= 100) col=TableFindCol(tab, col);
		if (col == 0) rfalse;
		f=0;
		if (((tab-->col)-->1) & TB_COLUMN_TOPIC) f=1;
		else if (((tab-->col)-->1) & TB_COLUMN_ALLOCATED) f=2;
		k = TableRows(tab);
		for (i=1:i<=k:i++) {
			v = (tab-->col)-->(i+COL_HSIZE);
			if ((v == TABLE_NOVALUE) && (CheckTableEntryIsBlank(tab,col,i))) continue;
			switch (f) {
				1: if ((v)(entry/100, entry%100) ~= GPR_FAIL) return i;
				2: if (BlkValueCompare(v, entry) == 0) return i;
				default: if (v == entry) return i;
			}
		}
		! print "Giving up^";
		return 0;
	];
-) instead of "Table Row Corresponding" in "Tables.i6t".

Volume "0000409a and 0000854"

Include (-
	[ LanguageLM n x1 x2;
	  say__p = 1;
	  Answer,Ask:
	            "There is no reply.";
	! Ask:      see Answer
	  Attack:   "Violence isn't the answer to this one.";
	  Burn:     "This dangerous act would achieve little.";
	  Buy:      "Nothing is on sale.";
	  Climb:    "I don't think much is to be achieved by that.";
	  Close: switch (n) {
	        1:  print_ret (ctheyreorthats) x1, " not something you can close.";
	        2:  print_ret (ctheyreorthats) x1, " already closed.";
	        3:  "You close ", (the) x1, ".";
! BEGIN CHANGE FOR 0000854
			4:	print (The) actor, " close"; if (actor hasnt pluralname) print "s";
				print " ", (the) x1, ".^";
! END CHANGE FOR 0000854
			5:	print (The) x1, " close"; if (x1 hasnt pluralname) print "s";
				print ".^";
	    }
	  Consult: switch (n) {
	  		1:	"You discover nothing of interest in ", (the) x1, ".";
! BEGIN CHANGE FOR 0000854
	  		2:	print (The) actor, " look"; if (actor hasnt pluralname) print "s";
				print " at ", (the) x1, ".^";
! END CHANGE FOR 0000854
	    }
	  Cut:      "Cutting ", (thatorthose) x1, " up would achieve little.";
	  Disrobe: switch (n) {
	        1:  "You're not wearing ", (thatorthose) x1, ".";
	        2:  "You take off ", (the) x1, ".";
! BEGIN CHANGE FOR 0000854
			3:	print (The) actor, " take"; if (actor hasnt pluralname) print "s";
				print " off ", (the) x1, ".^";
! END CHANGE FOR 0000854
	    }
	  Drink:    "There's nothing suitable to drink here.";
	  Drop: switch (n) {
	        1:  if (x1 has pluralname) print (The) x1, " are "; else print (The) x1, " is ";
	            "already here.";
	        2:  "You haven't got ", (thatorthose) x1, ".";
	        3:  print "(first taking ", (the) x1, " off)^"; say__p = 0; return;
	        4:  "Dropped.";
	        5:	"There is no more room on ", (the) x1, ".";
	        6:	"There is no more room in ", (the) x1, ".";
! BEGIN CHANGE FOR 0000854
	        7:	print (The) actor, " put"; if (actor hasnt pluralname) print "s";
				print " down ", (the) x1, ".^";
! END CHANGE FOR 0000854
	    }
	  Eat: switch (n) {
	        1:  print_ret (ctheyreorthats) x1, " plainly inedible.";
	        2:  "You eat ", (the) x1, ". Not bad.";
! BEGIN CHANGE FOR 0000854
	        3:	print (The) actor, " eat"; if (actor hasnt pluralname) print "s";
				print " ", (the) x1, ".^";
! END CHANGE FOR 0000854
	    }
	  Enter: switch (n) {
	        1:  print "But you're already ";
	            if (x1 has supporter) print "on "; else print "in ";
	            print_ret (the) x1, ".";
	        2:  if (x1 has pluralname) print "They're"; else print "That's";
	            print " not something you can ";
	            switch (verb_word) {
	              'stand':  "stand on.";
	              'sit':    "sit down on.";
	              'lie':    "lie down on.";
	              default:  "enter.";
	            }
	        3:  "You can't get into the closed ", (name) x1, ".";
	        4:  "You can only get into something free-standing.";
	        5:  print "You get ";
	            if (x1 has supporter) print "onto "; else print "into ";
	            print_ret (the) x1, ".";
	        6:  print "(getting ";
	            if (x1 has supporter) print "off "; else print "out of ";
	            print (the) x1; print ")^"; say__p = 0; return;
	        7:  ! say__p = 0;
	            if (x1 has supporter) "(getting onto ", (the) x1, ")";
	            if (x1 has container) "(getting into ", (the) x1, ")";
	            "(entering ", (the) x1, ")";
! BEGIN CHANGE FOR 0000854
			8:	print (The) actor, " get"; if (actor hasnt pluralname) print "s";
				print " into ", (the) x1, ".^";
	        9:  print (The) actor, " get"; if (actor hasnt pluralname) print "s";
				print " onto ", (the) x1, ".^";
! END CHANGE FOR 0000854
	    }
	  Examine: switch (n) {
	        1:  "Darkness, noun.  An absence of light to see by.";
	        2:  "You see nothing special about ", (the) x1, ".";
	        3:  print (The) x1, " ", (isorare) x1, " currently switched ";
	            if (x1 has on) "on."; else "off.";
! BEGIN CHANGE FOR 0000854
			4:	print (The) actor, " look"; if (actor hasnt pluralname) print "s";
				print " closely at ", (the) x1, ".^";
! END CHANGE FOR 0000854
			5:	"You see nothing unexpected in that direction.";
		}
	  Exit: switch (n) {
	        1:  "But you aren't in anything at the moment.";
	        2:  "You can't get out of the closed ", (name) x1, ".";
	        3:  print "You get ";
	            if (x1 has supporter) print "off "; else print "out of ";
	            print_ret (the) x1, ".";
	        4:  print "But you aren't ";
	            if (x1 has supporter) print "on "; else print "in ";
	            print_ret (the) x1, ".";
! BEGIN CHANGE FOR 0000854
			5:	print (The) actor, " get"; if (actor hasnt pluralname) print "s";
				print " off ", (the) x1, ".^";
			6:	print (The) actor, " get"; if (actor hasnt pluralname) print "s";
				print " out of ", (the) x1, ".^";
! END CHANGE FOR 0000854
	    }
	  GetOff:   "But you aren't on ", (the) x1, " at the moment.";
	  Give: switch (n) {
	        1:  "You aren't holding ", (the) x1, ".";
	        2:  "You juggle ", (the) x1, " for a while, but don't achieve much.";
	        3:  print (The) x1;
	            if (x1 has pluralname) print " don't"; else print " doesn't";
	            " seem interested.";
	        4:  print (The) x1;
	            if (x1 has pluralname) print " aren't";
	            else print " isn't";
	            " able to receive things.";
			5:	"You give ", (the) x1, " to ", (the) second, ".";
! BEGIN CHANGE FOR 0000854
			6: print (The) actor, " give"; if (actor hasnt pluralname) print "s";
				print " ", (the) x1, " to you.^";
			7: print (The) actor, " give"; if (actor hasnt pluralname) print "s";
				print " ", (the) x1, " to ", (the) second, ".^";
! END CHANGE FOR 0000854
	    }
	  Go: switch (n) {
	        1:  print "You'll have to get ";
	            if (x1 has supporter) print "off "; else print "out of ";
	            print_ret (the) x1, " first.";
	        2:  print_ret (string) CANTGO__TX;   ! "You can't go that way."
	        6:  print "You can't, since ", (the) x1;
	            if (x1 has pluralname) " lead nowhere."; else " leads nowhere.";
			7:	"You'll have to say which compass direction to go in.";
! BEGIN CHANGE FOR 0000854
			8:	print (The) actor, " go"; if (actor hasnt pluralname) print "es";
				print " up";
			9:	print (The) actor, " go"; if (actor hasnt pluralname) print "es";
				print " down";
			10:	print (The) actor, " go"; if (actor hasnt pluralname) print "es";
				print " ", (name) x1;
			11:	print (The) actor, " arrive"; if (actor hasnt pluralname) print "s";
				print " from above";
			12:	print (The) actor, " arrive"; if (actor hasnt pluralname) print "s";
				print " from below";
			13:	print (The) actor, " arrive"; if (actor hasnt pluralname) print "s";
				print " from the ", (name) x1;
			14:	print (The) actor, " arrive"; if (actor hasnt pluralname) print "s";
			15:	print (The) actor, " arrive"; if (actor hasnt pluralname) print "s";
				print " at ", (the) x1, " from above";
			16:	print (The) actor, " arrive"; if (actor hasnt pluralname) print "s";
				print " at ", (the) x1, " from below";
			17:	print (The) actor, " arrive"; if (actor hasnt pluralname) print "s";
				print " at ", (the) x1, " from the ", (name) x2;
			18:	print (The) actor, " go"; if (actor hasnt pluralname) print "es";
				print " through ", (the) x1;
			19:	print (The) actor, " arrive"; if (actor hasnt pluralname) print "s";
				print " from ", (the) x1;
! END CHANGE FOR 0000854
			20:	print "on ", (the) x1;
			21:	print "in ", (the) x1;
			22:	print ", pushing ", (the) x1, " in front, and you along too";
			23:	print ", pushing ", (the) x1, " in front";
			24:	print ", pushing ", (the) x1, " away";
			25:	print ", pushing ", (the) x1, " in";
			26:	print ", taking you along";
			27: print "(first getting off ", (the) x1, ")^"; say__p = 0; return;
			28: print "(first opening ", (the) x1, ")^"; say__p = 0; return;
	    }
	  Insert: switch (n) {
	        1:  "You need to be holding ", (the) x1, " before you can put ", (itorthem) x1,
	            " into something else.";
	        2:  print_ret (Cthatorthose) x1, " can't contain things.";
	        3:  print_ret (The) x1, " ", (isorare) x1, " closed.";
	        4:  "You'll need to take ", (itorthem) x1, " off first.";
	        5:  "You can't put something inside itself.";
	        6:  print "(first taking ", (itorthem) x1, " off)^"; say__p = 0; return;
	        7:  "There is no more room in ", (the) x1, ".";
	        8:  "Done.";
	        9:  "You put ", (the) x1, " into ", (the) second, ".";
! BEGIN CHANGE FOR 0000854
	       10:  print (The) actor, " put"; if (actor hasnt pluralname) print "s";
				print " ", (the) x1, " into ", (the) second, ".^";
! END CHANGE FOR 0000854
	    }
	  Inv: switch (n) {
	        1:  "You are carrying nothing.";
	        2:  print "You are carrying";
	        3:  print ":^";
	        4:  print ".^";
! BEGIN CHANGE FOR 0000854
	        5:	print (The) x1, " look"; if (actor hasnt pluralname) print "s";
				print " through ", (HisHerTheir) x1, " possessions.^";
! END CHANGE FOR 0000854
	    }
	  Jump:     "You jump on the spot, fruitlessly.";
	  Kiss:     "Keep your mind on the game.";
	  Listen:   "You hear nothing unexpected.";
	  ListMiscellany: switch (n) {
	        1:  print " (providing light)";
	        2:  print " (closed)";
	        4:  print " (empty)";
	        6:  print " (closed and empty)";
	        3:  print " (closed and providing light)";
	        5:  print " (empty and providing light)";
	        7:  #ifdef SERIAL_COMMA;
	        	print " (closed, empty, and providing light)";
	        	#ifnot;
	        	print " (closed, empty and providing light)";
	        	#endif;
	        8:  print " (providing light and being worn";
	        9:  print " (providing light";
	        10: print " (being worn";
	        11: print " (";
	        12: print "open";
	        13: print "open but empty";
	        14: print "closed";
	        15: print "closed and locked";
	        16: print " and empty";
	        17: print " (empty)";
	        18: print " containing ";
	        19: print " (on ";
	        20: print ", on top of ";
	        21: print " (in ";
	        22: print ", inside ";
	    }
	  LMode1:   " is now in its ~brief~ printing mode, which gives long descriptions
	             of places never before visited and short descriptions otherwise.";
	  LMode2:   " is now in its ~verbose~ mode, which always gives long descriptions
	             of locations (even if you've been there before).";
	  LMode3:   " is now in its ~superbrief~ mode, which always gives short descriptions
	             of locations (even if you haven't been there before).";
	  Lock: switch (n) {
	        1:  if (x1 has pluralname) print "They don't "; else print "That doesn't ";
	            "seem to be something you can lock.";
	        2:  print_ret (ctheyreorthats) x1, " locked at the moment.";
	        3:  "First you'll have to close ", (the) x1, ".";
	        4:  if (x1 has pluralname) print "Those don't "; else print "That doesn't ";
	            "seem to fit the lock.";
	        5:  "You lock ", (the) x1, ".";
! BEGIN CHANGE FOR 0000854
	        6:	print (The) actor, " lock"; if (actor hasnt pluralname) print "s";
				print " ", (the) x1, ".^";
! END CHANGE FOR 0000854
	    }
	  Look: switch (n) {
	        1:  print " (on ", (the) x1, ")";
	        2:  print " (in ", (the) x1, ")";
	        3:  print " (as ", (object) x1, ")";
	        4:  print "On ", (the) x1, " ";
	            WriteListFrom(child(x1),
	              ENGLISH_BIT+RECURSE_BIT+PARTINV_BIT+TERSE_BIT+CONCEAL_BIT+ISARE_BIT);
	            ".";
	        5:
	            if (x1 ~= location) {
	                if (x1 has supporter) print "On "; else print "In ";
	                print (the) x1, " you";
	            }
	            else print "You";
	            print " can ";
! BEGIN CHANGE FOR 0000409a
	            if ((+ locale paragraph count +) > 0) print "also ";
	            print "see ";
		6:
! END CHANGE FOR 0000409a
	            if (x1 ~= location) "."; else " here.";
	        7:  "You see nothing unexpected in that direction.";
	        8:  if (x1 has supporter) print " (on "; else print " (in ";
	        	print (the) x1, ")";
! BEGIN CHANGE FOR 0000854
			9:	print (The) actor, " look"; if (actor hasnt pluralname) print "s";
				print " around.^";
! END CHANGE FOR 0000854
	    }
	  LookUnder: switch (n) {
	        1:  "But it's dark.";
	        2:  "You find nothing of interest.";
! BEGIN CHANGE FOR 0000854
			3:	print (The) actor, " look"; if (actor hasnt pluralname) print "s";
				print " under ", (the) x1, ".^";
! END CHANGE FOR 0000854
	    }
	  Mild:     "Quite.";
	  Miscellany: switch (n) {
	        1:  "(considering the first sixteen objects only)^";
	        2:  "Nothing to do!";
	        3:  print " You have died ";
	        4:  print " You have won ";
	        5:  print "^Would you like to RESTART, RESTORE a saved game";
	            #Ifdef DEATH_MENTION_UNDO;
	            print ", UNDO your last move";
	            #Endif;
	            #ifdef SERIAL_COMMA;
	            print ",";
	            #endif;
	            " or QUIT?";
	        6:  "[Your interpreter does not provide ~undo~.  Sorry!]";
	            #Ifdef TARGET_ZCODE;
	        7:  "~Undo~ failed.  [Not all interpreters provide it.]";
	            #Ifnot; ! TARGET_GLULX
	        7:  "[You cannot ~undo~ any further.]";
	            #Endif; ! TARGET_
	        8:  "Please give one of the answers above.";
	        9:  "It is now pitch dark in here!";
	        10: "I beg your pardon?";
	        11: "[You can't ~undo~ what hasn't been done!]";
	        12: "[Can't ~undo~ twice in succession. Sorry!]";
	        13: "[Previous turn undone.]";
	        14: "Sorry, that can't be corrected.";
	        15: "Think nothing of it.";
	        16: "~Oops~ can only correct a single word.";
	        17: "It is pitch dark, and you can't see a thing.";
	        18: print "yourself";
	        19: "As good-looking as ever.";
	        20: "To repeat a command like ~frog, jump~, just say ~again~, not ~frog, again~.";
	        21: "You can hardly repeat that.";
	        22: "You can't begin with a comma.";
	        23: "You seem to want to talk to someone, but I can't see whom.";
	        24: "You can't talk to ", (the) x1, ".";
	        25: "To talk to someone, try ~someone, hello~ or some such.";
	        26: "(first taking ", (the) x1, ")";
	        27: "I didn't understand that sentence.";
	        28: print "I only understood you as far as wanting to ";
	        29: "I didn't understand that number.";
	        30: "You can't see any such thing.";
	        31: "You seem to have said too little!";
	        32: "You aren't holding that!";
	        33: "You can't use multiple objects with that verb.";
	        34: "You can only use multiple objects once on a line.";
	        35: "I'm not sure what ~", (address) pronoun_word, "~ refers to.";
	        36: "You excepted something not included anyway!";
	        37: "You can only do that to something animate.";
	            #Ifdef DIALECT_US;
	        38: "That's not a verb I recognize.";
	            #Ifnot;
	        38: "That's not a verb I recognise.";
	            #Endif;
	        39: "That's not something you need to refer to in the course of this game.";
	        40: "You can't see ~", (address) pronoun_word, "~ (", (the) pronoun_obj,
	            ") at the moment.";
	        41: "I didn't understand the way that finished.";
	        42: if (x1 == 0) print "None"; else print "Only ", (number) x1;
	            print " of those ";
	            if (x1 == 1) print "is"; else print "are";
	            " available.";
	        43: "Nothing to do!";
	        44: "There are none at all available!";
	        45: print "Who do you mean, ";
	        46: print "Which do you mean, ";
	        47: "Sorry, you can only have one item here. Which exactly?";
	        48: print "Whom do you want";
	            if (actor ~= player) print " ", (the) actor;
	            print " to "; PrintCommand(); print "?^";
	        49: print "What do you want";
	            if (actor ~= player) print " ", (the) actor;
	            print " to "; PrintCommand(); print "?^";
	        50: print "Your score has just gone ";
	            if (x1 > 0) print "up"; else { x1 = -x1; print "down"; }
	            print " by ", (number) x1, " point";
	            if (x1 > 1) print "s";
	        51: "(Since something dramatic has happened, your list of commands has been cut short.)";
	        52: "^Type a number from 1 to ", x1, ", 0 to redisplay or press ENTER.";
	        53: "^[Please press SPACE.]";
	        54: "[Comment recorded.]";
	        55: "[Comment NOT recorded.]";
	        56: print ".^";
	        57: print "?^";
	        58: print (The) actor, " ", (IsOrAre) actor, " unable to do that.^";
			59:	"You must supply a noun.";
			60:	"You may not supply a noun.";
			61:	"You must name an object.";
			62:	"You may not name an object.";
			63:	"You must name a second object.";
			64:	"You may not name a second object.";
			65:	"You must supply a second noun.";
			66:	"You may not supply a second noun.";
			67:	"You must name something more substantial.";
			68:	print "(", (The) actor, " first taking ", (the) x1, ")^";
	        69: "(first taking ", (the) x1, ")";
	        70: "The use of UNDO is forbidden in this game.";
	        71: print (string) DARKNESS__TX;
	  		72: print (The) x1;
	            if (x1 has pluralname) print " have"; else print " has";
	            " better things to do.";
	        73: "That noun did not make sense in this context.";
	        74: print "[That command asks to do something outside of play, so it can
	        	only make sense from you to me. ", (The) x1, " cannot be asked to do this.]^";
	        75:  print " The End ";
	    }
	  No,Yes:   "That was a rhetorical question.";
	  NotifyOff:
	            "Score notification off.";
	  NotifyOn: "Score notification on.";
	  Open: switch (n) {
	        1:  print_ret (ctheyreorthats) x1, " not something you can open.";
	        2:  if (x1 has pluralname) print "They seem "; else print "It seems ";
	            "to be locked.";
	        3:  print_ret (ctheyreorthats) x1, " already open.";
	        4:  print "You open ", (the) x1, ", revealing ";
	            if (WriteListFrom(child(x1), ENGLISH_BIT+TERSE_BIT+CONCEAL_BIT) == 0) "nothing.";
	            ".";
	        5:  "You open ", (the) x1, ".";
! BEGIN CHANGE FOR 0000854
			6:	print (The) actor, " open"; if (actor hasnt pluralname) print "s";
				print " ", (the) x1, ".^";
! END CHANGE FOR 0000854
			7:	print (The) x1, " open";
				if (x1 hasnt pluralname) print "s";
				print ".^";
	    }
	  Pronouns: switch (n) {
	        1:  print "At the moment, ";
	        2:  print "means ";
	        3:  print "is unset";
	        4:  "no pronouns are known to the game.";
	        5:  ".";
	    }
	  Pull,Push,Turn: switch (n) {
	        1:  if (x1 has pluralname) print "Those are "; else print "It is ";
	            "fixed in place.";
	        2:  "You are unable to.";
	        3:  "Nothing obvious happens.";
	        4:  "That would be less than courteous.";
! BEGIN CHANGE FOR 0000854
			5:	print (The) actor, " pull"; if (actor hasnt pluralname) print "s";
				print " ", (the) x1, ".^";
			6:	print (The) actor, " push"; if (actor hasnt pluralname) print "es";
				print " ", (the) x1, ".^";
			7:	print (The) actor, " turn"; if (actor hasnt pluralname) print "s";
				print " ", (the) x1, ".^";
! END CHANGE FOR 0000854
	    }
	! Push: see Pull
	  PushDir: switch (n) {
	        1:  print (The) x1, " cannot be pushed from place to place.^";
	        2:  "That's not a direction.";
	        3:  "Not that way you can't.";
	    }
	  PutOn: switch (n) {
	        1:  "You need to be holding ", (the) x1, " before you can put ",
	                (itorthem) x1, " on top of something else.";
	        2:  "You can't put something on top of itself.";
	        3:  "Putting things on ", (the) x1, " would achieve nothing.";
	        4:  "You lack the dexterity.";
	        5:  print "(first taking ", (itorthem) x1, " off)^"; say__p = 0; return;
	        6:  "There is no more room on ", (the) x1, ".";
	        7:  "Done.";
	        8:  "You put ", (the) x1, " on ", (the) second, ".";
! BEGIN CHANGE FOR 0000854
	        9:  print (The) actor, " put"; if (actor hasnt pluralname) print "s";
				print " ", (the) x1, " on ", (the) second, ".^";
! END CHANGE FOR 0000854
	    }
	  Quit: switch (n) {
	        1:  print "Please answer yes or no.";
	        2:  print "Are you sure you want to quit? ";
	    }
	  Remove: switch (n) {
	        1:  if (x1 has pluralname) print "They are"; else print "It is";
	            " unfortunately closed.";
	        2:  if (x1 has pluralname) print "But they aren't"; else print "But it isn't";
	            " there now.";
	        3:  "Removed.";
	    }
	  Restart: switch (n) {
	        1:  print "Are you sure you want to restart? ";
	        2:  "Failed.";
	    }
	  Restore: switch (n) {
	        1:  "Restore failed.";
	        2:  "Ok.";
	    }
	  Rub:      "You achieve nothing by this.";
	  Save: switch (n) {
	        1:  "Save failed.";
	        2:  "Ok.";
	    }
	  Score: switch (n) {
	        1:  if (deadflag) print "In that game you scored "; else print "You have so far scored ";
	            print score, " out of a possible ", MAX_SCORE, ", in ", turns, " turn";
	            if (turns ~= 1) print "s";
	            return;
	        2:  "There is no score in this story.";
	        3:	print ", earning you the rank of ";
	    }
	  ScriptOff: switch (n) {
	        1:  "Transcripting is already off.";
	        2:  "^End of transcript.";
	        3:  "Attempt to end transcript failed.";
	    }
	  ScriptOn: switch (n) {
	        1:  "Transcripting is already on.";
	        2:  "Start of a transcript of";
	        3:  "Attempt to begin transcript failed.";
	    }
	  Search: switch (n) {
	        1:  "But it's dark.";
	        2:  "There is nothing on ", (the) x1, ".";
	        3:  print "On ", (the) x1, " ";
	            WriteListFrom(child(x1), ENGLISH_BIT+TERSE_BIT+CONCEAL_BIT+ISARE_BIT);
	            ".";
	        4:  "You find nothing of interest.";
	        5:  "You can't see inside, since ", (the) x1, " ", (isorare) x1, " closed.";
	        6:  print_ret (The) x1, " ", (isorare) x1, " empty.";
	        7:  print "In ", (the) x1, " ";
	            WriteListFrom(child(x1), ENGLISH_BIT+TERSE_BIT+CONCEAL_BIT+ISARE_BIT);
	            ".";
! BEGIN CHANGE FOR 0000854
			8:	print (The) actor, " search"; if (actor hasnt pluralname) print "es";
				print " ", (the) x1, ".^";
! END CHANGE FOR 0000854
	    }
	  SetTo:    "No, you can't set ", (thatorthose) x1, " to anything.";
	  Show: switch (n) {
	        1:  "You aren't holding ", (the) x1, ".";
	        2:  print_ret (The) x1, " ", (isorare) x1, " unimpressed.";
	    }
	  Sing:     "Your singing is abominable.";
	  Sleep:    "You aren't feeling especially drowsy.";
	  Smell:    "You smell nothing unexpected.";
	            #Ifdef DIALECT_US;
	  Sorry:    "Oh, don't apologize.";
	            #Ifnot;
	  Sorry:    "Oh, don't apologise.";
	            #Endif;
	  Squeeze: switch (n) {
	        1:  "Keep your hands to yourself.";
	        2:  "You achieve nothing by this.";
! BEGIN CHANGE FOR 0000854
			3:	print (The) actor, " squeeze"; if (actor hasnt pluralname) print "s";
				print " ", (the) x1, ".^";
! END CHANGE FOR 0000854
	    }
	  Strong:   "Real adventurers do not use such language.";
	  Swing:    "There's nothing sensible to swing here.";
	  SwitchOff: switch (n) {
	        1:  print_ret (ctheyreorthats) x1, " not something you can switch.";
	        2:  print_ret (ctheyreorthats) x1, " already off.";
	        3:  "You switch ", (the) x1, " off.";
! BEGIN CHANGE FOR 0000854
			4:	print (The) actor, " switch"; if (actor hasnt pluralname) print "es";
				print " ", (the) x1, " off.^";
! END CHANGE FOR 0000854
	    }
	  SwitchOn: switch (n) {
	        1:  print_ret (ctheyreorthats) x1, " not something you can switch.";
	        2:  print_ret (ctheyreorthats) x1, " already on.";
	        3:  "You switch ", (the) x1, " on.";
! BEGIN CHANGE FOR 0000854
			4:	print (The) actor, " switch"; if (actor hasnt pluralname) print "es";
				print " ", (the) x1, " on.^";
! END CHANGE FOR 0000854
	    }
	  Take: switch (n) {
	        1:  "Taken.";
	        2:  "You are always self-possessed.";
	        3:  "I don't suppose ", (the) x1, " would care for that.";
	        4:  print "You'd have to get ";
	            if (x1 has supporter) print "off "; else print "out of ";
	            print_ret (the) x1, " first.";
	        5:  "You already have ", (thatorthose) x1, ".";
	        6:  if (noun has pluralname) print "Those seem "; else print "That seems ";
	            "to belong to ", (the) x1, ".";
	        7:  if (noun has pluralname) print "Those seem "; else print "That seems ";
	            "to be a part of ", (the) x1, ".";
	        8:  print_ret (Cthatorthose) x1, " ", (isorare) x1,
	            "n't available.";
	        9:  print_ret (The) x1, " ", (isorare) x1, "n't open.";
	        10: if (x1 has pluralname) print "They're "; else print "That's ";
	            "hardly portable.";
	        11: if (x1 has pluralname) print "They're "; else print "That's ";
	            "fixed in place.";
	        12: "You're carrying too many things already.";
	        13: print "(putting ", (the) x1, " into ", (the) x2,
	            " to make room)^"; say__p = 0; return;
	        14: "You can't reach into ", (the) x1, ".";
	        15: "You cannot carry ", (the) x1, ".";
! BEGIN CHANGE FOR 0000854
	        16: print (The) actor, " pick"; if (actor hasnt pluralname) print "s";
				print " up ", (the) x1, ".^";
! END CHANGE FOR 0000854
	    }
	  Taste:    "You taste nothing unexpected.";
	  Tell: switch (n) {
	        1:  "You talk to yourself a while.";
	        2:  "This provokes no reaction.";
	    }
	  Think:    "What a good idea.";
	  ThrowAt: switch (n) {
	        1:  "Futile.";
	        2:  "You lack the nerve when it comes to the crucial moment.";
	    }
	  Tie:		"You would achieve nothing by this.";
	  Touch: switch (n) {
	        1:  "Keep your hands to yourself!";
	        2:  "You feel nothing unexpected.";
	        3:  "If you think that'll help.";
! BEGIN CHANGE FOR 0000854
			4:	print (The) actor, " touch"; if (actor hasnt pluralname) print "es";
				print " ", (himheritself) x1, ".^";
			5:	print (The) actor, " touch"; if (actor hasnt pluralname) print "es";
				print " you.^";
			6:	print (The) actor, " touch"; if (actor hasnt pluralname) print "es";
				print " ", (the) x1, ".^";
! END CHANGE FOR 0000854
	    }
	! Turn: see Pull.
	  Unlock:  switch (n) {
	        1:  if (x1 has pluralname) print "They don't "; else print "That doesn't ";
	            "seem to be something you can unlock.";
	        2:  print_ret (ctheyreorthats) x1, " unlocked at the moment.";
	        3:  if (x1 has pluralname) print "Those don't "; else print "That doesn't ";
	            "seem to fit the lock.";
	        4:  "You unlock ", (the) x1, ".";
! BEGIN CHANGE FOR 0000854
	        5:	print (The) actor, " unlock"; if (actor hasnt pluralname) print "s";
				print " ", (the) x1, ".^";
! END CHANGE FOR 0000854
	    }
	  Verify: switch (n) {
	        1:  "The game file has verified as intact.";
	        2:  "The game file did not verify as intact, and may be corrupt.";
	    }
	  Wait: switch (n) {
	        1:  "Time passes.";
! BEGIN CHANGE FOR 0000854
	        2:	print (The) actor, " wait"; if (actor hasnt pluralname) print "s";
				print ".^";
! END CHANGE FOR 0000854
	    }
	  Wake:     "The dreadful truth is, this is not a dream.";
	  WakeOther:"That seems unnecessary.";
	  Wave: switch (n) {
	        1:  "But you aren't holding ", (thatorthose) x1, ".";
	        2:  "You look ridiculous waving ", (the) x1, ".";
! BEGIN CHANGE FOR 0000854
			3:	print (The) actor, " wave"; if (actor hasnt pluralname) print "s";
				print " ", (the) x1, ".^";
! END CHANGE FOR 0000854
	    }
	  WaveHands:"You wave, feeling foolish.";
	  Wear: switch (n) {
	        1:  "You can't wear ", (thatorthose) x1, "!";
	        2:  "You're not holding ", (thatorthose) x1, "!";
	        3:  "You're already wearing ", (thatorthose) x1, "!";
	        4:  "You put on ", (the) x1, ".";
! BEGIN CHANGE FOR 0000854
			5:	print (The) actor, " put"; if (actor hasnt pluralname) print "s";
				print " on ", (the) x1, ".^";
! END CHANGE FOR 0000854
	    }
	! Yes:  see No.
	];
-) instead of "Long Texts" in "Language.i6t".

[0000409a]
For printing the locale description (this is the revised you-can-also-see rule):
	let the domain be the parameter-object;
	let the mentionable count be 0;
	repeat with item running through things:
		now the item is not marked for listing;
	repeat through the Table of Locale Priorities:
		[say "[notable-object entry] - [locale description priority entry].";]
		if the locale description priority entry is greater than 0,
			now the notable-object entry is marked for listing;
		increase the mentionable count by 1;
	if the mentionable count is greater than 0:
		repeat with item running through things:
			if the item is mentioned:
				now the item is not marked for listing;
		begin the listing nondescript items activity with the domain;
		if the number of marked for listing things is 0:
			abandon the listing nondescript items activity with the domain;
		otherwise:
			if handling the listing nondescript items activity:
				issue library message looking action number 5 for the domain;
				let the common holder be nothing;
				let contents form of list be true;
				repeat with list item running through marked for listing things:
					if the holder of the list item is not the common holder:
						if the common holder is nothing,
							now the common holder is the holder of the list item;
						otherwise now contents form of list is false;
					if the list item is mentioned, now the list item is not marked for listing;
				filter list recursion to unmentioned things;
				if contents form of list is true and the common holder is not nothing,
					list the contents of the common holder, as a sentence, including contents,
						giving brief inventory information, tersely, not listing
						concealed items, listing marked items only;
				otherwise say "[a list of marked for listing things including contents]";
				issue library message looking action number 6 for the domain;
				unfilter list recursion;
			end the listing nondescript items activity with the domain;
	continue the activity.
The revised you-can-also-see rule is listed instead of the you-can-also-see rule in the for printing the locale description rulebook.

Volume "0000433"



Volume "0000565"

Yourself is privately-named.
Understand "your former self" or "my former self" or "former self" or "former" as yourself when the player is not yourself.

Volume "0000602"

Include (-
	Global can_undo = false;
-) after "Definitions.i6t".

Undo available is a truth state that varies.
The undo available variable translates into I6 as "can_undo".

Last after reading a command (this is the enable undo once the player has entered a command rule):
	now undo available is true.

Include (-
	[ Perform_Undo;
		#ifdef PREVENT_UNDO; L__M(##Miscellany, 70); return; #endif;
! BEGIN CHANGE FOR 0000602
		if (~~can_undo) { L__M(##Miscellany, 11); return; }
! END CHANGE FOR 0000602
		if (undo_flag == 0) { L__M(##Miscellany, 6); return; }
		if (undo_flag == 1) { L__M(##Miscellany, 7); return; }
		if (VM_Undo() == 0) L__M(##Miscellany, 7);
	];
-) instead of "Perform Undo" in "OutOfWorld.i6t".

Volume "0000604"

The going action has an object called the prior location.

Setting action variables for going (this is the set the prior location variable for going rule):
	now the prior location is the location.

Carry out an actor going (this is the revised move player and vehicle rule):
	if the vehicle gone by is nothing:
		surreptitiously move the actor to the room gone to during going;
	otherwise:
		surreptitiously move the vehicle gone by to the room gone to during going;
		now the location is the location of the player.
The revised move player and vehicle rule is listed instead of the move player and vehicle rule in the carry out going rulebook.

Carry out an actor going (this is the revised move floating objects rule):
	if the location is not the prior location:
		update backdrop positions.
The revised move floating objects rule is listed instead of the move floating objects rule in the carry out going rulebook.

Carry out an actor going (this is the revised check light in new location rule):
	if the location is not the prior location:
		surreptitiously reckon darkness.
The revised check light in new location rule is listed instead of the check light in new location rule in the carry out going rulebook.

Report an actor going (this is the revised describe room gone into rule):
	let the actual location be the location;
	now the location is the prior location;
	follow the describe room gone into rule;
	now the location is the actual location.
The revised describe room gone into rule is listed instead of the describe room gone into rule in the report going rulebook.

Volume "0000630"

Check an actor going (this is the can't push an enclosing vehicle rule):
	if the vehicle gone by is not nothing and the vehicle gone by is the thing gone with:
		stop the action with library message going action number 1 for the vehicle gone by.

Volume "0000787"

Check an actor taking off (this is the can't exceed carrying capacity by taking off clothing rule):
	if the number of things carried by the actor is at least the carrying capacity of the actor:
		stop the action with library message taking action number 12 for the actor.

Volume "0000788"

Check an actor giving (this is the can't exceed carrying capacity by giving rule):
	if the number of things carried by the second noun is at least the carrying capacity of the second noun:
		if a library message should be issued:
			say "[The second noun] [if the second noun is singular-named]is[otherwise]are[end if] carrying too many things already.";
		stop the action.

Volume "0000806"

Carry out an actor entering (this is the check light after entering rule):
	if the actor is the player:
		surreptitiously reckon darkness.

Carry out an actor exiting (this is the check light after exiting rule):
	if the actor is the player:
		surreptitiously reckon darkness.

Volume "0000807"

[Workaround originally by SJ_43.]

Include (-
	[ POSITION_PLAYER_IN_MODEL_R player_to_be;
	
		player = selfobj;
		player_to_be = InitialSituation-->PLAYER_OBJECT_INIS;
		
		location = LocationOf(player_to_be);
		if (location == 0) {
			location = InitialSituation-->START_ROOM_INIS;
			if (InitialSituation-->START_OBJECT_INIS)
				move player_to_be to InitialSituation-->START_OBJECT_INIS;
			else move player_to_be to location;
		}
	
		if (player_to_be ~= player) {
			remove selfobj;
			ChangePlayer(player_to_be);
! BEGIN CHANGE FOR 0000807
		} else {
! END CHANGE FOR 0000807
			real_location = location;
			SilentlyConsiderLight();
		}
	
		NOTE_OBJECT_ACQUISITIONS_R(); MoveFloatingObjects();
		
		actor = player; act_requester = nothing; actors_location = real_location; action = ##Wait;
	
		InitialSituation-->DONE_INIS = true;
		rfalse;
	];
-) instead of "Position Player In Model World Rule" in "OrderOfPlay.i6t".

Volume "0000827"

The touch persona is an object that varies.
The touch persona variable translates into I6 as "touch_persona".

To decide whether considering (R - a value of kind K based rule producing a value) for (V - a K) as ACCESS_THROUGH_BARRIERS_R does results in failure:
	(- (ProcessRulebook({R}, {V}) && RulebookFailed()) -).

[Based on ACCESS_THROUGH_BARRIERS_R in Light.i6t.]
To decide what object is the touchability ceiling of (P - a person):
	let the saved touch persona be the touch persona;
	now the touch persona is P;
	let the saved person reaching be the person reaching;
	now the person reaching is P;
	let the candidate be P;
	repeat until a break:
		let the prior candidate be the candidate;
		let the candidate be the I6 parent of the component parts core of the candidate;
		let the candidate core be the component parts core of the candidate;
		let the external flag be whether or not the candidate is not the candidate core;
		if the external flag is true:
			now the candidate is the candidate core;
		if the candidate is nothing:
			now the touch persona is the saved touch persona;
			now the person reaching is the saved person reaching;
			decide on the prior candidate;
		hide output;
		if the external flag is false and considering the reaching outside rulebook for the candidate as ACCESS_THROUGH_BARRIERS_R does results in failure:
			unhide output;
			now the touch persona is the saved touch persona;
			now the person reaching is the saved person reaching;
			decide on the candidate;
		unhide output.

For supplying a missing noun while an actor smelling (this is the revised ambient odour rule):
	now the noun is the touchability ceiling of the player.
The revised ambient odour rule is listed instead of the ambient odour rule in the for supplying a missing noun rulebook.

For supplying a missing noun while an actor listening (this is the revised ambient sound rule):
	now the noun is the touchability ceiling of the player.
The revised ambient sound rule is listed instead of the ambient sound rule in the for supplying a missing noun rulebook.

Volume "0000833"

To --/-- now (O - an object) is/are regionally/-- in (L - an object):
	if O is a room and L is a region:
		now the map region of O is L;
		update backdrop positions;
	otherwise:
		move O to L.

Volume "0000852"

Include (-
	[ ChangePlayer obj flag i;
		if (~~(obj ofclass K8_person)) return RunTimeProblem(RTP_CANTCHANGE, obj);
		if (~~(OnStage(obj, -1))) return RunTimeProblem(RTP_CANTCHANGEOFFSTAGE, obj);
! BEGIN CHANGE FOR 0000852
		if (obj provides component_parent && obj.component_parent ~= nothing) return ExtraRunTimeProblem(RTP_CANTCHANGETOPART, obj, obj.component_parent);
! END CHANGE FOR 0000852
		if (obj == player) return;
	
	    give player ~concealed;
	    if (player has remove_proper) give player ~proper;
	    if (player == selfobj) {
	    	player.saved_short_name = player.short_name; player.short_name = FORMER__TX;
	    }
	    player = obj;
	    if (player == selfobj) {
	    	player.short_name = player.saved_short_name;
	    }
	    if (player hasnt proper) give player remove_proper; ! when changing out again
	    give player concealed proper;
	
	    location = LocationOf(player); real_location = location;
	    MoveFloatingObjects();
	    SilentlyConsiderLight();
	];
-) instead of "Changing the Player" in "WorldModel.i6t".

Include (-
	[ MakePart P Of First;
! BEGIN CHANGE FOR 0000852
		if (player == P) return ExtraRunTimeProblem(RTP_CANTMAKEPLAYERPART, Of);
! END CHANGE FOR 0000852
		if (parent(P)) remove P; give P ~worn;
		if (Of == nothing) { DetachPart(P); return; }
		if (P.component_parent) DetachPart(P);
		P.component_parent = Of;
		First = Of.component_child;
		Of.component_child = P; P.component_sibling = First;
	];
	
	[ DetachPart P From Daddy O;
		Daddy = P.component_parent; P.component_parent = nothing;
		if (Daddy == nothing) { P.component_sibling = nothing; return; }
		if (Daddy.component_child == P) {
			Daddy.component_child = P.component_sibling;
			P.component_sibling = nothing; return;
		}
		for (O = Daddy.component_child: O: O = O.component_sibling)
			if (O.component_sibling == P) {
				O.component_sibling = P.component_sibling;
				P.component_sibling = nothing; return;
			}
	];
-) instead of "Making Parts" in "WorldModel.i6t".

6G60 Patches ends here.

---- DOCUMENTATION ----

...

Example: * Test Case for Bug 0000356 - Printing Reversed Relations.

	*: "0000356"

	There is room.
	Offering relates one scene to various texts.
	The verb to be able to offer (it is possibly offered) implies the offering relation.
	The entire game can offer "'I heard about Donna.'"
	When play begins:
		say "Enter the command 'test me' and check that there are no mentionns of <illegal scene>."
	Test me with "relations".

Example: * Test Case for Bug 0000376 - Enclosure by Nonspecific Rooms.

	*: "0000376"

	Home is a room.
	Here is a box.
	When play begins:
		let test case passed be whether or not a room encloses a box;
		showme test case passed.

Example: * Test Case for Bug 0000384 - Automatic Line Breaks in the Status Line.

	*: "0000384"

	There is a room.
	The N0123 rules is a rulebook producing a number.
	A N0123 rule: rule succeeds with result 999.
	When play begins:
		now the left hand status line is "[the number produced by the N0123 rules]";
		say "Check that the left side of the status line is not empty."

Example: * Test Case for Bug 0000396 - Partially Understood Direction Commands.

	*: "0000396"

	There is a room.
	When play begins:
		say "Enter the command 'test me' and check that the parser errors do not include extra words."
	Test me with "north xyzzy / pick me up xyzzy / north xyzzy / go north xyzzy".

Example: * Test Case for Bug 0000407 - Correspondence of Blank Rows.

	*: "0000407"

	There is a room.

	Table of Test
	a stored action (a stored action)
	--
	--

	When play begins:
		choose row two in the Table of Test;
		change the stored action entry to the action of yourself waiting;
		choose the row with a stored action of the action of yourself waiting in the Table of Test;
		say "Check that no programming errors were detected."

Example: * Test Case for Bug 0000565 - Vocabulary for Yourself.

	*: "0000565"

	There is a room.
	Here is a person called Joe.
	When play begins:
		now the player is Joe;
		say "Enter the command 'test me' and check that there are no parser errors."
	Test me with "x my former self / x your former self / x former self / x former".

Example: * Test Case for Bug 0000602 - Rejection of Early Undos.

	*: "0000602"

	There is a room.
	When play begins:
		say "Enter the commands 'verbose' and 'undo' and check that there are no parser errors."

Example: * Test Case for Bug 0000604 - Incorrect Location after being Chauffeured.

	*: "0000604"

	South Room is a room; north is North Room.
	The truck is a vehicle in the South Room.  Bob is a man in the truck.  The player is in the truck.
	When play begins:
		try Bob going north;
		let test case passed be whether or not the location is the North Room;
		try Bob going south;
		showme test case passed.

Example: * Test Case for Bug 0000630 - Pushing an Enclosing Vehicle.

	*: "0000630"

	South Room is a room; north is North Room.
	The truck is a vehicle in the South Room.  It is pushable between rooms.  The player is in the truck.
	When play begins:
		try pushing the truck to the north;
		let test case passed be whether or not the location is the South Room;
		showme test case passed.

Example: * Test Case for Bug 0000787 - Exceeding Carrying Capacity by Doffing.

	*: "0000787"

	There is a room.
	The carrying capacity of the player is one.
	The player carries a box.
	The player wears a hat.
	When play begins:
		try taking off the hat;
		let test case passed be whether or not the player wears the hat;
		showme test case passed.

Example: * Test Case for Bug 0000788 - Exceeding Carrying Capacity by Giving.

	*: "0000788"

	There is a room.
	Here is a person called Phil.
	The carrying capacity of Phil is one.
	The player carries a box.
	Phil carries a hat.
	The block giving rule is not listed in any rulebook.
	When play begins:
		try giving the box to Phil;
		let test case passed be whether or not the player has the box;
		showme test case passed.

Example: * Test Case for Bug 0000806 - Exiting Darkness.

	*: "0000806"

	The Crypt is a room.
	The coffin is an enterable, openable, closed container in the Crypt.
	When play begins:
		now the player is in the coffin;
		try opening the coffin;
		try exiting;
		say "Check that no second description of darkness appears."

Example: * Test Case for Bug 0000807 - Beginning in a Dark Container.

	*: "0000807"

	The Crypt is a room.
	The coffin is an enterable, openable, closed container in the Crypt.
	Mary is a woman in the coffin.
	The player is Mary.
	When play begins:
		try opening the coffin;
		try exiting;
		say "Check that no second description of darkness appears."

Example: * Test Case for Bug 0000827 - Smelling or Listening in a Closing Container.

	*: "0000827"

	Treatment Lab is a room.
	The isolation chamber is a closed, openable, enterable container in the Treatment Lab.
	The player is in the isolation chamber.
	The isolation chamber can be smelt.
	Before smelling the isolation chamber:
		now the isolation chamber is smelt.
	The isolation chamber can be heard.
	Before smelling the isolation chamber:
		now the isolation chamber is heard.
	Reaching inside:
		say "Warning: output from reaching inside rule not hidden."
	Reaching outside:
		say "Warning: output from reaching outside rule not hidden."
	When play begins:
		try smelling;
		try listening;
		let test case passed be whether or not the isolation chamber is smelt and the isolation chamber is heard;
		showme test case passed;
		say "Also check that no warnings appear."

Example: * Test Case for Bug 0000833 - Moving a Room to a Region.

	*: "0000833"

	Apocalypse is a room.
	Destruction is a region.
	When play begins:
		now Apocalypse is in Destruction.

Example: * Test Case for Bug 0000852 - Player as Part of Something.

	*: "0000852"

	There is a room.
	Here is a box.
	Emilia is a woman; she is part of the box.
	Runtime errors unfired is a truth state that varies.
	The runtime errors unfired variable translates into I6 as "enable_rte".
	When play begins:
		let test case passed be true;
		now the player is part of the box;
		now test case passed is (whether or not test case passed is true and runtime errors unfired is false and the player is not part of the box);
		now runtime errors unfired is true;
		now the player is Emilia;
		now test case passed is (whether or not test case passed is true and runtime errors unfired is false and the player is not Emilia);
		now runtime errors unfired is true;
		showme test case passed.

Example: * Test Case for Bug 0000854 - Default Messages for Plural-Named Actors.

	*: "0000854"

	Home is a room.
	Here is a person called Fred.
	Here is a plural-named person called The Olivias.
	The Olivias wear some hats.
	The Olivias carry an edible thing called an apple.
	Here is a open openable lockable enterable container called the box.
	The matching key of the box is the key; The Olivias carry the key.
	The Olivias carry a device called the radio.
	Here is a portable enterable supporter called the chair.
	Up from home is the roof.
	Down from home is the basement.
	North from home is the outdoors.
	The can't eat unless edible rule is not listed in any rulebook.
	The block giving rule is not listed in any rulebook.
	When play begins:
		let the query be a topic;
		try The Olivias consulting the box about the query;
		try The Olivias taking off the hats;
		try The Olivias wearing the hats;
		try The Olivias eating the apple;
		try The Olivias entering the chair;
		try The Olivias exiting;
		try The Olivias examining the box;
		try The Olivias giving the hats to yourself;
		now the Olivias carry the hats;
		try The Olivias giving the hats to Fred;
		now the Olivias carry the hats;
		try The Olivias going up;
		try The Olivias going down;
		try The Olivias going down;
		try The Olivias going up;
		try The Olivias going north;
		try The Olivias going south;
		[going 15 on]
		try The Olivias taking inventory;
		try The Olivias closing the box;
		try The Olivias locking the box with the key;
		try The Olivias looking;
		try The Olivias looking under the box;
		try The Olivias unlocking the box with the key;
		try The Olivias opening the box;
		try The Olivias searching the box;
		try The Olivias entering the box;
		try The Olivias exiting;
		try The Olivias inserting the chair into the box;
		try The Olivias pulling the box;
		try The Olivias pushing the box;
		try The Olivias turning the box;
		try The Olivias taking the chair;
		try The Olivias dropping the chair;
		try The Olivias putting the key on the chair;
		try The Olivias squeezing the box;
		try The Olivias switching on the radio;
		try The Olivias switching off the radio;
		try The Olivias touching The Olivias;
		try The Olivias touching the player;
		try The Olivias touching the box;
		try The Olivias waiting;
		try The Olivias waving the radio;
		say "Check that all verbs are conjugated correctly."
