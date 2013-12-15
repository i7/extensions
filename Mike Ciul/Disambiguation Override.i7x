Version 1/121212 of Disambiguation Override by Mike Ciul begins here.

"Disables the disambiguation prompt on demand. Also provides a rulebook for disambiguating objects outside of an action context."

"based on ideas in Original Parser by Ron Newcomb and I6 advice from Andrew Plotkin"

[TODO: snippets for the noun and second noun?]

Section - Noun Domain Replacement

Disambiguation style is a kind of value. The disambiguation styles are default disambiguation, aborted disambiguation, disambiguation refusal.

The disambiguation mode is a disambiguation style that varies.
The disambiguation mode variable translates into I6 as "disambig_mode".

To silence disambiguation: now the disambiguation mode is aborted disambiguation.
To reparse the player's command instead of disambiguating: silence disambiguation.
To refuse disambiguation: now the disambiguation mode is disambiguation refusal.
To allow disambiguation: now the disambiguation mode is default disambiguation.

[TODO: refuse disambiguation with the you lost that item error]

After reading a command:
	allow disambiguation.

Include (-
Constant DEFAULT_DISAMBIG = 1;
Constant ABORT_DISAMBIG = 2;
Constant REFUSE_DISAMBIG = 3;

Global disambig_mode = 0;

! Tell NounDomain whether we should return, and with what return value
! As a side effect, reset the disambiguation mode.
! but we automatically re-enable disambiguation so that the activity can only set it temporarily.
! returning REPARSE_CODE is considered a success, which would be nice for snippet matching.
! but if it ever gets called when reading the player's command, it gets stuck in an infinite loop.
! A return value of 0 is considered failure, and results in "You can't see any such thing."
! Snippet matching doesn't care that much - we just iterate over the match list anyway.

[ DisambigDecision rv;
	rv = 0;
	if (disambig_mode == DEFAULT_DISAMBIG) {
		! Don't return from NounDomain
		rv = -1;
	}
	if (number_matched == 1) {
		! Clarify the parser's choice?
		#Ifdef DEBUG;
		if (parser_trace >= 4) {
			print "matched 1 item";
		}
		#Endif;
		rv = match_list-->0;
	}
	if (disambig_mode == ABORT_DISAMBIG) {
		rv = REPARSE_CODE;
	}
	disambig_mode = DEFAULT_DISAMBIG;
	return rv;
];

! The only changes to NounDomain are the calls to DisambigDecision

[ NounDomain domain1 domain2 context
	first_word i j k l answer_words marker rv;
    #Ifdef DEBUG;
    if (parser_trace >= 4) {
        print "   [NounDomain called at word ", wn, "^";
        print "   ";
        if (indef_mode) {
            print "seeking indefinite object: ";
            if (indef_type & OTHER_BIT)  print "other ";
            if (indef_type & MY_BIT)     print "my ";
            if (indef_type & THAT_BIT)   print "that ";
            if (indef_type & PLURAL_BIT) print "plural ";
            if (indef_type & LIT_BIT)    print "lit ";
            if (indef_type & UNLIT_BIT)  print "unlit ";
            if (indef_owner ~= 0) print "owner:", (name) indef_owner;
            new_line;
            print "   number wanted: ";
            if (indef_wanted == INDEF_ALL_WANTED) print "all"; else print indef_wanted;
            new_line;
            print "   most likely GNAs of names: ", indef_cases, "^";
        }
        else print "seeking definite object^";
    }
    #Endif; ! DEBUG

    match_length = 0; number_matched = 0; match_from = wn;

    SearchScope(domain1, domain2, context);

    #Ifdef DEBUG;
    if (parser_trace >= 4) print "   [ND made ", number_matched, " matches]^";
    #Endif; ! DEBUG

    wn = match_from+match_length;

    ! If nothing worked at all, leave with the word marker skipped past the
    ! first unmatched word...

    if (number_matched == 0) { wn++; rfalse; }

    ! Suppose that there really were some words being parsed (i.e., we did
    ! not just infer).  If so, and if there was only one match, it must be
    ! right and we return it...

    if (match_from <= num_words) {
        if (number_matched == 1) {
            i=match_list-->0;
            return i;
        }

        ! ...now suppose that there was more typing to come, i.e. suppose that
        ! the user entered something beyond this noun.  If nothing ought to follow,
        ! then there must be a mistake, (unless what does follow is just a full
        ! stop, and or comma)

        if (wn <= num_words) {
            i = NextWord(); wn--;
            if (i ~=  AND1__WD or AND2__WD or AND3__WD or comma_word
                   or THEN1__WD or THEN2__WD or THEN3__WD
                   or BUT1__WD or BUT2__WD or BUT3__WD) {
                if (lookahead == ENDIT_TOKEN) rfalse;
            }
        }
    }

    ! Now look for a good choice, if there's more than one choice...

    number_of_classes = 0;

    if (number_matched == 1) i = match_list-->0;
    if (number_matched > 1) {
		i = true;
	    if (number_matched > 1)
	    	for (j=0 : j<number_matched-1 : j++)
				if (Identical(match_list-->j, match_list-->(j+1)) == false)
					i = false;
		if (i) dont_infer = true;
        i = Adjudicate(context);
        if (i == -1) rfalse;
        if (i == 1) rtrue;       !  Adjudicate has made a multiple
                             !  object, and we pass it on
    }

    ! If i is non-zero here, one of two things is happening: either
    ! (a) an inference has been successfully made that object i is
    !     the intended one from the user's specification, or
    ! (b) the user finished typing some time ago, but we've decided
    !     on i because it's the only possible choice.
    ! In either case we have to keep the pattern up to date,
    ! note that an inference has been made and return.
    ! (Except, we don't note which of a pile of identical objects.)

    if (i ~= 0) {
    	if (dont_infer) return i;
        if (inferfrom == 0) inferfrom=pcount;
        pattern-->pcount = i;
        return i;
    }

    #Ifdef DEBUG;
    if (parser_trace >= 4) print "[Disambiguation Override mode ", disambig_mode, " before asking which do you mean]^";
    #Endif;
    rv = DisambigDecision();
    if (rv ~= -1) {
	#Ifdef DEBUG;
	if (parser_trace >= 4) print "[Disambiguation Override returning ", rv, " from ND before asking which do you mean]^";
	#Endif;
	return rv;
    }

    ! If we get here, there was no obvious choice of object to make.  If in
    ! fact we've already gone past the end of the player's typing (which
    ! means the match list must contain every object in scope, regardless
    ! of its name), then it's foolish to give an enormous list to choose
    ! from - instead we go and ask a more suitable question...

    if (match_from > num_words) jump Incomplete;

    ! Now we print up the question, using the equivalence classes as worked
    ! out by Adjudicate() so as not to repeat ourselves on plural objects...

	BeginActivity(ASKING_WHICH_DO_YOU_MEAN_ACT);
	if (ForActivity(ASKING_WHICH_DO_YOU_MEAN_ACT)) jump SkipWhichQuestion;
	! Give the Before Asking Which Do You Mean rulebook a chance to filter the match list
	if (number_matched == 1) {
    		#Ifdef DEBUG;
    		if (parser_trace >= 4) print "[Disambiguation Override matched exactly 1 object in mode ", disambig_mode, " while asking which do you mean]^";
		#Endif;

		rv = DisambigDecision(); ! Clarifying the parser's choice?
		#Ifdef DEBUG;
		if (parser_trace >= 4) print "[Disambiguation Override returning ", (the) rv, " from ND instead of asking which do you mean]^";
		#Endif;
		! This is a bit scary... will we always end the activity properly now?
		EndActivity(ASKING_WHICH_DO_YOU_MEAN_ACT);
		return rv;
	}
	j = 1; marker = 0;
	for (i=1 : i<=number_of_classes : i++) {
		while (((match_classes-->marker) ~= i) && ((match_classes-->marker) ~= -i))
			marker++;
		if (match_list-->marker hasnt animate) j = 0;
	}
	if (j) L__M(##Miscellany, 45); else L__M(##Miscellany, 46);

    j = number_of_classes; marker = 0;
    for (i=1 : i<=number_of_classes : i++) {
        while (((match_classes-->marker) ~= i) && ((match_classes-->marker) ~= -i)) marker++;
        k = match_list-->marker;

        if (match_classes-->marker > 0) print (the) k; else print (a) k;

        if (i < j-1)  print (string) COMMA__TX;
        if (i == j-1) {
	#Ifdef SERIAL_COMMA;
	if (j ~= 2) print ",";
        	#Endif; ! SERIAL_COMMA
        	print (string) OR__TX;
        }
    }
    L__M(##Miscellany, 57);

	.SkipWhichQuestion; EndActivity(ASKING_WHICH_DO_YOU_MEAN_ACT);

    ! ...and get an answer:
	
    ! If the asking which do you mean activity decided to suppress disambiguation, we need to check that here.
    #Ifdef DEBUG;
    if (parser_trace >= 4) print "[Disambiguation Override mode ", disambig_mode, " after asking which do you mean]^";
    #Endif;

    rv = DisambigDecision();
    if (rv ~= -1) {
	#Ifdef DEBUG;
	if (parser_trace >= 4) print "[Disambiguation Override returning ", rv, " from ND after asking which do you mean]^";
	#Endif;
	return rv;
    }

  .WhichOne;
    #Ifdef TARGET_ZCODE;
    for (i=2 : i<INPUT_BUFFER_LEN : i++) buffer2->i = ' ';
    #Endif; ! TARGET_ZCODE
    answer_words=Keyboard(buffer2, parse2);

    ! Conveniently, parse2-->1 is the first word in both ZCODE and GLULX.
    first_word = (parse2-->1);

    ! Take care of "all", because that does something too clever here to do
    ! later on:

    if (first_word == ALL1__WD or ALL2__WD or ALL3__WD or ALL4__WD or ALL5__WD) {
        if (context == MULTI_TOKEN or MULTIHELD_TOKEN or MULTIEXCEPT_TOKEN or MULTIINSIDE_TOKEN) {
            l = multiple_object-->0;
            for (i=0 : i<number_matched && l+i<MATCH_LIST_WORDS : i++) {
                k = match_list-->i;
                multiple_object-->(i+1+l) = k;
            }
            multiple_object-->0 = i+l;
            rtrue;
        }
        L__M(##Miscellany, 47);
        jump WhichOne;
    }

	! Look for a comma, and interpret this as a fresh conversation command
	! if so:

	for (i=1 : i<=answer_words : i++)
		if (WordFrom(i, parse2) == comma_word) {
            VM_CopyBuffer(buffer, buffer2);
            jump RECONSTRUCT_INPUT;		
		}

    ! If the first word of the reply can be interpreted as a verb, then
    ! assume that the player has ignored the question and given a new
    ! command altogether.
    ! (This is one time when it's convenient that the directions are
    ! not themselves verbs - thus, "north" as a reply to "Which, the north
    ! or south door" is not treated as a fresh command but as an answer.)

    #Ifdef LanguageIsVerb;
    if (first_word == 0) {
        j = wn; first_word = LanguageIsVerb(buffer2, parse2, 1); wn = j;
    }
    #Endif; ! LanguageIsVerb
    if (first_word ~= 0) {
        j = first_word->#dict_par1;
        if ((0 ~= j&1) && ~~LanguageVerbMayBeName(first_word)) {
            VM_CopyBuffer(buffer, buffer2);
            jump RECONSTRUCT_INPUT;
        }
    }

    ! Now we insert the answer into the original typed command, as
    ! words additionally describing the same object
    ! (eg, > take red button
    !      Which one, ...
    !      > music
    ! becomes "take music red button".  The parser will thus have three
    ! words to work from next time, not two.)

    #Ifdef TARGET_ZCODE;
    k = WordAddress(match_from) - buffer; l=buffer2->1+1;
    for (j=buffer + buffer->0 - 1 : j>=buffer+k+l : j-- ) j->0 = 0->(j-l);
    for (i=0 : i<l : i++) buffer->(k+i) = buffer2->(2+i);
    buffer->(k+l-1) = ' ';
    buffer->1 = buffer->1 + l;
    if (buffer->1 >= (buffer->0 - 1)) buffer->1 = buffer->0;
    #Ifnot; ! TARGET_GLULX
    k = WordAddress(match_from) - buffer;
    l = (buffer2-->0) + 1;
    for (j=buffer+INPUT_BUFFER_LEN-1 : j>=buffer+k+l : j-- ) j->0 = j->(-l);
    for (i=0 : i<l : i++) buffer->(k+i) = buffer2->(WORDSIZE+i);
    buffer->(k+l-1) = ' ';
    buffer-->0 = buffer-->0 + l;
    if (buffer-->0 > (INPUT_BUFFER_LEN-WORDSIZE)) buffer-->0 = (INPUT_BUFFER_LEN-WORDSIZE);
    #Endif; ! TARGET_

    ! Having reconstructed the input, we warn the parser accordingly
    ! and get out.

	.RECONSTRUCT_INPUT;

	num_words = WordCount();
    wn = 1;
    #Ifdef LanguageToInformese;
    LanguageToInformese();
    ! Re-tokenise:
    VM_Tokenise(buffer,parse);
    #Endif; ! LanguageToInformese
	num_words = WordCount();
    players_command = 100 + WordCount();
    actors_location = ScopeCeiling(player);
	FollowRulebook(Activity_after_rulebooks-->READING_A_COMMAND_ACT, true);

    return REPARSE_CODE;

    ! Now we come to the question asked when the input has run out
    ! and can't easily be guessed (eg, the player typed "take" and there
    ! were plenty of things which might have been meant).

  .Incomplete;

    if (context == CREATURE_TOKEN) L__M(##Miscellany, 48);
    else                           L__M(##Miscellany, 49);

    #Ifdef TARGET_ZCODE;
    for (i=2 : i<INPUT_BUFFER_LEN : i++) buffer2->i=' ';
    #Endif; ! TARGET_ZCODE
    answer_words = Keyboard(buffer2, parse2);

    first_word=(parse2-->1);
    #Ifdef LanguageIsVerb;
    if (first_word==0) {
        j = wn; first_word=LanguageIsVerb(buffer2, parse2, 1); wn = j;
    }
    #Endif; ! LanguageIsVerb

    ! Once again, if the reply looks like a command, give it to the
    ! parser to get on with and forget about the question...

    if (first_word ~= 0) {
        j = first_word->#dict_par1;
        if (0 ~= j&1) {
            VM_CopyBuffer(buffer, buffer2);
            return REPARSE_CODE;
        }
    }

    ! ...but if we have a genuine answer, then:
    !
    ! (1) we must glue in text suitable for anything that's been inferred.

    if (inferfrom ~= 0) {
        for (j=inferfrom : j<pcount : j++) {
            if (pattern-->j == PATTERN_NULL) continue;
            #Ifdef TARGET_ZCODE;
            i = 2+buffer->1; (buffer->1)++; buffer->(i++) = ' ';
            #Ifnot; ! TARGET_GLULX
            i = WORDSIZE + buffer-->0;
            (buffer-->0)++; buffer->(i++) = ' ';
            #Endif; ! TARGET_

            #Ifdef DEBUG;
            if (parser_trace >= 5)
            	print "[Gluing in inference with pattern code ", pattern-->j, "]^";
            #Endif; ! DEBUG

            ! Conveniently, parse2-->1 is the first word in both ZCODE and GLULX.

            parse2-->1 = 0;

            ! An inferred object.  Best we can do is glue in a pronoun.
            ! (This is imperfect, but it's very seldom needed anyway.)

            if (pattern-->j >= 2 && pattern-->j < REPARSE_CODE) {
                PronounNotice(pattern-->j);
                for (k=1 : k<=LanguagePronouns-->0 : k=k+3)
                    if (pattern-->j == LanguagePronouns-->(k+2)) {
                        parse2-->1 = LanguagePronouns-->k;
                        #Ifdef DEBUG;
                        if (parser_trace >= 5)
                        	print "[Using pronoun '", (address) parse2-->1, "']^";
                        #Endif; ! DEBUG
                        break;
                    }
            }
            else {
                ! An inferred preposition.
                parse2-->1 = VM_NumberToDictionaryAddress(pattern-->j - REPARSE_CODE);
                #Ifdef DEBUG;
                if (parser_trace >= 5)
                	print "[Using preposition '", (address) parse2-->1, "']^";
                #Endif; ! DEBUG
            }

            ! parse2-->1 now holds the dictionary address of the word to glue in.

            if (parse2-->1 ~= 0) {
                k = buffer + i;
                #Ifdef TARGET_ZCODE;
                @output_stream 3 k;
                 print (address) parse2-->1;
                @output_stream -3;
                k = k-->0;
                for (l=i : l<i+k : l++) buffer->l = buffer->(l+2);
                i = i + k; buffer->1 = i-2;
                #Ifnot; ! TARGET_GLULX
                k = Glulx_PrintAnyToArray(buffer+i, INPUT_BUFFER_LEN-i, parse2-->1);
                i = i + k; buffer-->0 = i - WORDSIZE;
                #Endif; ! TARGET_
            }
        }
    }

    ! (2) we must glue the newly-typed text onto the end.

    #Ifdef TARGET_ZCODE;
    i = 2+buffer->1; (buffer->1)++; buffer->(i++) = ' ';
    for (j=0 : j<buffer2->1 : i++,j++) {
        buffer->i = buffer2->(j+2);
        (buffer->1)++;
        if (buffer->1 == INPUT_BUFFER_LEN) break;
    }
    #Ifnot; ! TARGET_GLULX
    i = WORDSIZE + buffer-->0;
    (buffer-->0)++; buffer->(i++) = ' ';
    for (j=0 : j<buffer2-->0 : i++,j++) {
        buffer->i = buffer2->(j+WORDSIZE);
        (buffer-->0)++;
        if (buffer-->0 == INPUT_BUFFER_LEN) break;
    }
    #Endif; ! TARGET_

    ! (3) we fill up the buffer with spaces, which is unnecessary, but may
    !     help incorrectly-written interpreters to cope.

    #Ifdef TARGET_ZCODE;
    for (: i<INPUT_BUFFER_LEN : i++) buffer->i = ' ';
    #Endif; ! TARGET_ZCODE

    return REPARSE_CODE;

]; ! end of NounDomain 


-) instead of "Noun Domain" in "Parser.i6t".
	
Section - Low-Level Phrases

The number of objects in the match list is a number that varies. 

The number of objects in the match list variable translates into I6 as "number_matched".

To loop over the match list with (func - phrase thing -> nothing): (- LoopOverMatchList({func}); -);

Include (-
[ LoopOverMatchList func i;
	for (i = 0; i < number_matched; i++) {
		indirect(func-->1, match_list-->i);
	}
];

-)

To decide which object is the first match: (- FirstMatch() -)

Include (-
[ FirstMatch;
	if (number_matched < 1) {
		print "PROGRAMMING ERROR: No matches^";
		return 0;
	}
	return match_list-->0;
];
-)

To filter the match list with/for (O - a description of objects), leaving at least one choice, or restoring the entire match list on failure: (- FilterMatchList({O}, {phrase options}); -)
	
Include (-
[ FilterMatchList filter opt i obj count class_id prev_class;
                ! If we're asking which do you mean, we have to keep track of match classes
            	#Ifdef DEBUG;
	if (parser_trace >= 4) {
		print "Filtering match list with ", number_matched, " items in ", number_of_classes, " classes. Options=", opt, "^";
	}
	#Endif;

	count = 0;
	for ( i=number_matched-1 : i>=0 : i-- ) {
		! loop backwards to preserve the order of the match list
		obj = match_list-->i;
		class_id = match_classes-->i;
		if (indirect(filter, obj)) {
 			count++;
	          		#Ifdef DEBUG;
			if (parser_trace >= 4) {
				print "Accepted ", count, "th item, original index ", i, " in class ", class_id, ": ", (the) obj, ".^";
			}
			#Endif;
			@push obj;
			@push class_id;
		}
		else {
			#Ifdef DEBUG;
			if (parser_trace >= 4) {
				print "Rejected item with original index ", i, " in class ", class_id, ": ", (the) obj, ".^";
			}
			#Endif;
		}
		! print "class_id=", class_id, " obj=", (the) obj, "^";
	}
	if (count == 0 ) {
		if (opt == 2) {
			#Ifdef DEBUG;
			if (parser_trace >= 4) {
				print "No matches. Restoring the entire match list on failure.^";
			}
			#Endif;
			return;
		} 
		if (opt == 1) {
			#Ifdef DEBUG;
			if (parser_trace >= 4) {
				print "No matches. Leaving at least one choice.^";
			}
			#Endif;
			number_matched = 1;
			number_of_classes = 1;
			return;
		}
	}
	number_of_classes = 0;
	number_matched = 0;
	prev_class = 0;
	for (i=0 : i < count : i++ ) {
		@pull class_id;
		@pull obj;
 		if (class_id < 0) { class_id = -class_id; }
		! convert old class id to a new value, in sequence with accepted objects
		if (class_id == prev_class) {
 	          		#Ifdef DEBUG;
			if (parser_trace >= 4) {
				print (the) obj, ":  Not unique: original class_id of ", class_id, " converted to ", -number_of_classes, ".^";
			}
			#Endif;
			class_id = -number_of_classes;
		}
		else {
			number_of_classes++;
 	          		#Ifdef DEBUG;
			if (parser_trace >= 4) {
				print (the) obj, "  Unique: original class_id of ", class_id, " converted to ", number_of_classes, ".^";
			}
			#Endif;
			prev_class = class_id;
			class_id = number_of_classes;
		}
		match_classes-->number_matched = class_id;
		match_list-->number_matched++ = obj;
	}
	#Ifdef DEBUG;
	if (parser_trace >= 4) {
		print "Matched ", number_matched, "objects in  ", number_of_classes, " classes.^";
	}
	#Endif;
];
-)

To truncate the match list to (N - a number) choice/choices: (- TruncateMatchList({N}); -)

Include (-
[ TruncateMatchList size;
	number_matched = size;
	number_of_classes = match_classes-->number_matched;
	if (number_of_classes < 0) { number_of_classes = -number_of_classes; }
	#Ifdef DEBUG;
	if (parser_trace >= 4) {
		print "Truncated match list to ", number_matched, " choices and ", number_of_classes, " distinguishable choices.^";
	}
	#Endif;
];
-)

Section - High-Level Phrases

The scope decider is a rule producing a truth state that varies.  
The scope decider variable translates into I6 as "scope_token".

To decide whether we are parsing for unseen objects: (- scope_token ~= 0 -).
To decide whether we are parsing for present objects: (- scope_token == 0 -).

To decide which object is the most likely match between (snip - a snippet) and (T - a topic):
	refuse disambiguation;
	if snip matches T, do nothing [yet];
	decide on the most likely match;

Section - Did the Player Choose

did the player choose is an object based rulebook.
The did the player choose rules have outcomes it is very likely, it is likely, it is possible, it is unlikely, it is very unlikely.

To decide which number is the/-- match score for (item - an object):
	follow the did the player choose rules for item;
	if the outcome of the rulebook is:
		-- the it is very likely outcome: decide on 4;
		-- the it is likely outcome: decide on 3;
		-- the it is possible outcome: decide on 2;
		-- the it is unlikely outcome: decide on 1;
		-- the it is very unlikely outcome: decide on 0;
	decide on 2;

Section - Choosing the Most Likely Object

The best match score is a number that varies. The best match score is -1.
The already matched item is an object that varies.

To decide whether nothing matched:
	decide on whether or not the best match score is -1;

To decide whether something matched:
	decide on whether or not the best match score is at least 0;

To decide which object is the/-- most likely match:
	if the number of objects in the match list is 1:
		Now the best match score is 0;
		Decide on the first match;
	Now the best match score is -1;
	Now the already matched item is nothing;
	Loop over the match list with match-likeliness checking;
	Decide on the already matched item;

To check whether (the candidate - an object) is the most likely match so far (this is match-likeliness checking):
	Let the current match score be the match score for the candidate;
	If the current match score is less than the best match score, stop;
	If the current match score is the best match score:
		now the already matched item is nothing;
		stop;
	Now the already matched item is the candidate;
	Now the best match score is the current match score;

[TODO: Filter the match list by match score]

Section - Refusing to Disambiguate

[TODO: need parser error for no valid disambiguation choices - this activity isn't used]

Printing a disambiguation refusal is an activity.

For printing a disambiguation refusal:
	say "You must be more specific.";

For asking which do you mean when the number of objects in the match list is 0:
	if the disambiguation mode is default disambiguation, refuse disambiguation.

Section - Testing Commands - Not for Release

[match-checking is an action out of world applying to one topic. Understand "objmatch [text]" as match-checking.

Report match-checking:
	showme the list of things identified with the topic understood;
	showme the list of rooms identified with the topic understood;
	showme the list of directions identified with the topic understood;
	showme the list of regions identified with the topic understood;]

Disambiguation Override ends here.

---- DOCUMENTATION ----

Disambiguation Override handles the case where we might ask whether a snippet matches a topic, when the topic includes multiple matching objects. A glitch in standard I7 causes the "asking which do you mean" activity to run in this case. This actually works when a disambiguating answer is provided, but not when the player attempts to type a new command. Disambiguation Override makes it possible to turn off the disambiguation question completely, and in addition allows us to peek at the match list and see which objects match. It also provides a rulebook for manually disambiguating objects identified in this way.

It is not compatible with Disambiguation Control by Jon Ingold.

If at any time we want to disable disambiguation, we need simply say:
	
	refuse disambiguation

or:

	silence disambiguation

This statement will take effect until the next disambiguation question is skipped, or until the beginning of the next turn (after reading a command) - whichever comes first. 

The phrase:

	reparse the player's command instead of disambiguating

is a convenient synonym for "silence disambiguation," but it is only meaningful if we are actually parsing the player's command, not if we are merely testing a snippet.

The difference is that "refuse disambiguation" will result in an error being printed, while "silence disambiguation" will not. If we use "silence disambiguation" when we are parsing the player's command, it will cause the command to be reparsed. If we do that, we must make sure to change something about the way parsing is done (manipulate scope or change the text of the player's command) - or else the parser will get stuck in an infinite loop.

If we change our minds, we can say:

	allow disambiguation.

To avoid a refusal even if we're not allowing disambiguation, we can use this phrase:

	filter the match list with/for (O - a description of objects)

So if we only wanted to allow containers to match, we could say:

	Before asking which do you mean:
		filter the match list for containers

If we are currently refusing disambiguation, the parser will not fail as long as we end up with exactly one item in the match list.

The "filter the match list" phrase has some phrase options. The first is "leaving at least one choice." If we use this option, the first item in the match list will be preserved even if nothing matched the description. Most of the time, this option is a good idea because it can prevent runtime problems associated with an empty match list.

	filter the match list for people, leaving at least one choice;
	if the first match is not a person:
		say "We didn't match any people, but we have one choice now."

The second option is "restoring the entire match list on failure." This causes the match list to be untouched if the filter failed to catch anything at all.

	Let N be the number of objects in the match list;
	Filter the match list for containers, restoring the entire match list on failure;
	If the number of objects in the match list is N and the first match is not a container:
		say "We didn't match any containers, but the match list is unchanged."	

[TODO: phrases to expose whether we're looking for a noun, second noun, or snippet match]

To match an object against a snippet and get the result, use this phrase:

	the most likely match between the topic understood and "[any thing]"

This phrase will return an object if there is exactly one match, otherwise it will return nothing, even if there were multiple matches. To find out what happened, we can test one of these phrases:
	if nothing matched
	if something matched

To control what objects match, we can use a scoring system similar to the Does the Player Mean rules. This is managed using the "Did the Player Choose" rulebook. The difference is that the Did the Player Choose rules are object based, so we need to pass a description of the object we're testing:

	Did the player choose an exclamation when answering someone that: It is very likely.

To access the match list, we must use a phrase value:

	To report the match of (item - an object) (this is match reporting):
		say "[the item] matched.";

	Loop over the match list with match reporting.

The "most likely" phrase will reject any objects that score lower than the best choice. But if there are two or more objects that score equally high, it will still return nothing. To find out whether the phrase failed because nothing match or because of multiple matches, we can test "if nothing matched," "if something matched," and which objects were "likeliest" immediately after calling the phrase:
	
	Let the choice be the most likely match between the player's command and "[any thing]";
	if the choice is nothing:
		if nothing matched, say "You didn't mention any things I recognize.";
		if something matched:
			say "Your command matched the following things: ";
			loop over the match list with match reporting;

[
TODO: likeliest

Remember that the "likeliest" adjective merely runs the "did the player choose" rulebook on the item described - it doesn't test whether that object was part of the "most likely" test just performed, so you must reiterate any other conditions used to invoke the phrase.
]

To test what objects match any snippet, you can use the "objmatch" testing command:

	>objmatch me
	"list of things identified with the topic understood" = list of things: {yourself}
	"list of rooms identified with the topic understood" = list of rooms: {}
	"list of directions identified with the topic understood" = list of directions: {}
	"list of regions identified with the topic understood" = list of regions: {}

Section: Changes

20121212: Fixed a bug in FilterMatchList with phrase options. Documented the phrase options. Added the "restoring the entire match list on failure" option.

20121002: Fixed a bug in Noun Domain that only appears in release versions, causing the asking which do you mean activity to list zero choices.

20120926: Fixed a bug in which the asking which do you mean activity never ends.

Example: * Exclamations - Creates a new action that can be parsed from the command "[someone], [something]"

	*: "Exclamations"

	Include Disambiguation Override by Mike Ciul.

	Exclaiming it to is an action applying to two visible things.
	Report exclaiming it to: say "You say '[noun]' to [the second noun]."

	An exclamation is a kind of thing. Hello is an exclamation.

	Check answering someone that:
		Let item be the most likely match between the topic understood and "[any thing]";
		If item is a thing:
			instead try exclaiming item to the noun;
		[Let item be the most likely thing named in the topic understood;
		if something matched:
			say "Your command did not exactly match anything you can say, but [the list of likeliest things named in the topic understood] matched part[if item is nothing]s[end if] of it.";
			stop the action.]

	Test is a room. Bob is a man in Test.

	Test me with "say hello to bob/bob, hello how are you Bob"