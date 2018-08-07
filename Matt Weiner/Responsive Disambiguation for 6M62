Responsive Disambiguation for 6M62 by Matt Weiner begins here.

Section 1 - New Globals

Include 
(- Global processing_disambiguation;                  ! RD: set to 1 if we are currently processing a disambiguation request
    Global asked_for_disambiguation;                    ! RD: set to 1 if we just asked for disambiguation
    Global processing_failed_disambig;	!  RD: set to 1 if we are processing a failed disambiguation
-) before "Parser.i6t".

Processing failed disambiguation is a number that varies. The processing failed disambiguation variable translates into I6 as "processing_failed_disambig".

Section 2 - Parser Letter A Replacement

[The only change here is that we reset the flags. We reset the asked_for_disambiguation flag before the point where we jump to reparse, and we reset the processing_disambiguation flag after the point where we jump to reparse, if the asked_for_disambiguation flag isn't currently set. That should mean that when we're reparsing a disambiguated command the processing_disambiguation flag stays set, while they get reset with every fresh command]

Include 
(-
   if (held_back_mode) {
        held_back_mode = false; wn = hb_wn;
        if (verb_wordnum > 0) i = WordAddress(verb_wordnum); else i = WordAddress(1);
        j = WordAddress(wn);
        if (i<=j) for (: i<j : i++) i->0 = ' ';
        i = NextWord();
        if (i == AGAIN1__WD or AGAIN2__WD or AGAIN3__WD) {
            ! Delete the words "then again" from the again buffer,
            ! in which we have just realised that it must occur:
            ! prevents an infinite loop on "i. again"

            i = WordAddress(wn-2)-buffer;
            if (wn > num_words) j = INPUT_BUFFER_LEN-1;
            else j = WordAddress(wn)-buffer;
            for (: i<j : i++) buffer3->i = ' ';
        }

        VM_Tokenise(buffer, parse);
        jump ReParse;
    }

  .ReType;

	cobj_flag = 0;
	actors_location = ScopeCeiling(player);
    BeginActivity(READING_A_COMMAND_ACT); if (ForActivity(READING_A_COMMAND_ACT)==false) {
		Keyboard(buffer,parse);
		num_words = WordCount(); players_command = 100 + num_words;
    } if (EndActivity(READING_A_COMMAND_ACT)) jump ReType;

   asked_for_disambiguation = 0; ! RD: reset asked_for_disambiguation after getting the normal command and before reparsing

  .ReParse;

! RD: while reparsing, if we didn't ask for disambiguation, we want to make sure we haven't
! RD: marked that we're processing disambiguation       
    if (asked_for_disambiguation == 0) processing_disambiguation =0;

    parser_inflection = name;

    ! Initially assume the command is aimed at the player, and the verb
    ! is the first word

    num_words = WordCount(); players_command = 100 + num_words;
    wn = 1; inferred_go = false;

    #Ifdef LanguageToInformese;
    LanguageToInformese();
    ! Re-tokenise:
    VM_Tokenise(buffer,parse);
    #Endif; ! LanguageToInformese

    num_words = WordCount(); players_command = 100 + num_words;

    k=0;
    #Ifdef DEBUG;
    if (parser_trace >= 2) {
        print "[ ";
        for (i=0 : i<num_words : i++) {

            #Ifdef TARGET_ZCODE;
            j = parse-->(i*2 + 1);
            #Ifnot; ! TARGET_GLULX
            j = parse-->(i*3 + 1);
            #Endif; ! TARGET_
            k = WordAddress(i+1);
            l = WordLength(i+1);
            print "~"; for (m=0 : m<l : m++) print (char) k->m; print "~ ";

            if (j == 0) print "?";
            else {
                #Ifdef TARGET_ZCODE;
                if (UnsignedCompare(j, HDR_DICTIONARY-->0) >= 0 &&
                    UnsignedCompare(j, HDR_HIGHMEMORY-->0) < 0)
                     print (address) j;
                else print j;
                #Ifnot; ! TARGET_GLULX
                if (j->0 == $60) print (address) j;
                else print j;
                #Endif; ! TARGET_
            }
            if (i ~= num_words-1) print " / ";
        }
        print " ]^";
    }
    #Endif; ! DEBUG
    verb_wordnum = 1;
    actor = player;
    actors_location = ScopeCeiling(player);
    usual_grammar_after = 0;

  .AlmostReParse;

    scope_token = 0;
    action_to_be = NULL;

    ! Begin from what we currently think is the verb word

  .BeginCommand;

    wn = verb_wordnum;
    verb_word = NextWordStopped();

    ! If there's no input here, we must have something like "person,".

    if (verb_word == -1) {
        best_etype = STUCK_PE; jump GiveError;
    }
	if (verb_word == comma_word) {
		best_etype = COMMABEGIN_PE; jump GiveError;
	}

    ! Now try for "again" or "g", which are special cases: don't allow "again" if nothing
    ! has previously been typed; simply copy the previous text across

    if (verb_word == AGAIN2__WD or AGAIN3__WD) verb_word = AGAIN1__WD;
    if (verb_word == AGAIN1__WD) {
        if (actor ~= player) {
            best_etype = ANIMAAGAIN_PE;
			jump GiveError;
        }
        #Ifdef TARGET_ZCODE;
        if (buffer3->1 == 0) {
            PARSER_COMMAND_INTERNAL_RM('D'); new_line;
            jump ReType;
        }
        #Ifnot; ! TARGET_GLULX
        if (buffer3-->0 == 0) {
            PARSER_COMMAND_INTERNAL_RM('D'); new_line;
            jump ReType;
        }
        #Endif; ! TARGET_
        for (i=0 : i<INPUT_BUFFER_LEN : i++) buffer->i = buffer3->i;
        VM_Tokenise(buffer,parse);
		num_words = WordCount(); players_command = 100 + num_words;
    	jump ReParse;
    }

    ! Save the present input in case of an "again" next time

    if (verb_word ~= AGAIN1__WD)
        for (i=0 : i<INPUT_BUFFER_LEN : i++) buffer3->i = buffer->i;

    if (usual_grammar_after == 0) {
        j = verb_wordnum;
        i = RunRoutines(actor, grammar); 
        #Ifdef DEBUG;
        if (parser_trace >= 2 && actor.grammar ~= 0 or NULL)
            print " [Grammar property returned ", i, "]^";
        #Endif; ! DEBUG

        if ((i ~= 0 or 1) && (VM_InvalidDictionaryAddress(i))) {
            usual_grammar_after = verb_wordnum; i=-i;
        }

        if (i == 1) {
            parser_results-->ACTION_PRES = action;
            parser_results-->NO_INPS_PRES = 0;
            parser_results-->INP1_PRES = noun;
            parser_results-->INP2_PRES = second;
            if (noun) parser_results-->NO_INPS_PRES = 1;
            if (second) parser_results-->NO_INPS_PRES = 2;
            rtrue;
        }
        if (i ~= 0) { verb_word = i; wn--; verb_wordnum--; }
        else { wn = verb_wordnum; verb_word = NextWord(); }
    }
    else usual_grammar_after = 0;
-) instead of "Parser Letter A" in "Parser.i6t".

Section 3 - NounDomain Replacement

Include
(-
[ NounDomain domain1 domain2 context dont_ask
	first_word i j k l answer_words marker;
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

    if (number_matched == 1) {
    	i = match_list-->0;
		if (indef_mode == 1 && indef_type & PLURAL_BIT ~= 0) {
			if (context == MULTI_TOKEN or MULTIHELD_TOKEN or
				MULTIEXCEPT_TOKEN or MULTIINSIDE_TOKEN or
				NOUN_TOKEN or HELD_TOKEN or CREATURE_TOKEN) {
				BeginActivity(DECIDING_WHETHER_ALL_INC_ACT, i);
				if ((ForActivity(DECIDING_WHETHER_ALL_INC_ACT, i)) &&
					(RulebookFailed())) rfalse;
				EndActivity(DECIDING_WHETHER_ALL_INC_ACT, i);
			}
		}
    }
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

	if (dont_ask) return match_list-->0;

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
	j = 1; marker = 0;
	for (i=1 : i<=number_of_classes : i++) {
		while (((match_classes-->marker) ~= i) && ((match_classes-->marker) ~= -i))
			marker++;
		if (match_list-->marker hasnt animate) j = 0;
	}
	if (j) PARSER_CLARIF_INTERNAL_RM('A');
	else PARSER_CLARIF_INTERNAL_RM('B');

    j = number_of_classes; marker = 0;
    for (i=1 : i<=number_of_classes : i++) {
        while (((match_classes-->marker) ~= i) && ((match_classes-->marker) ~= -i)) marker++;
        k = match_list-->marker;

        if (match_classes-->marker > 0) print (the) k; else print (a) k;

        if (i < j-1)  print ", ";
        if (i == j-1) {
			#Ifdef SERIAL_COMMA;
			if (j ~= 2) print ",";
        	#Endif; ! SERIAL_COMMA
        	PARSER_CLARIF_INTERNAL_RM('H');
        }
    }
    print "?^";

	.SkipWhichQuestion; EndActivity(ASKING_WHICH_DO_YOU_MEAN_ACT);

    ! ...and get an answer:

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
        PARSER_CLARIF_INTERNAL_RM('C');
        jump WhichOne;
    }

	! Look for a comma, and interpret this as a fresh conversation command
	! if so:

	for (i=1 : i<=answer_words : i++)
		if (WordFrom(i, parse2) == comma_word) {
            VM_CopyBuffer(buffer, buffer2);
            jump RECONSTRUCT_INPUT;		
		}

    ! RD: if we didn't jump out of that, we're processing a disambiguation request
    ! RD: Instead of checking whether the first word is a verb to decide whether to process it,
    ! RD: we just proceed to inserting the answer into the original typed command.
    ! RD: If that doesn't work, we will hit a parser error, at which point we go back
    ! RD: and reprocess the disambiguation response as a new command.
    ! RD: All we need to do now is set the flag that we're processing a disambiguation request
    ! RD: which will be checked when it comes time to print a parser error.
    
    processing_disambiguation = 1;
    asked_for_disambiguation = 1;

    ! Now we insert the answer into the original typed command, as
    ! words additionally describing the same object
    ! (eg, > take red button
    !      Which one, ...
    !      > music
    ! becomes "take music red button".  The parser will thus have three
    ! words to work from next time, not two.)

    ! RD: had to insert spaces between -- and ) in two lines so it didn't prematurely end the I6 inclusion
    #Ifdef TARGET_ZCODE; 
    k = WordAddress(match_from) - buffer; l=buffer2->1+1;
    for (j=buffer + buffer->0 - 1 : j>=buffer+k+l : j-- ) j->0 = 0->(j-l); ! RD: here
    for (i=0 : i<l : i++) buffer->(k+i) = buffer2->(2+i);
    buffer->(k+l-1) = ' ';
    buffer->1 = buffer->1 + l;
    if (buffer->1 >= (buffer->0 - 1)) buffer->1 = buffer->0;
    #Ifnot; ! TARGET_GLULX
    k = WordAddress(match_from) - buffer;
    l = (buffer2-->0) + 1;
    for (j=buffer+INPUT_BUFFER_LEN-1 : j>=buffer+k+l : j-- ) j->0 = j->(-l); ! RD: and here
    for (i=0 : i<l : i++) buffer->(k+i) = buffer2->(WORDSIZE+i);
    buffer->(k+l-1) = ' ';
    buffer-->0 = buffer-->0 + l;
    if (buffer-->0 > (INPUT_BUFFER_LEN-WORDSIZE)) buffer-->0 = (INPUT_BUFFER_LEN-WORDSIZE);
    #Endif; ! TARGET_

    ! Having reconstructed the input, we warn the parser accordingly
    ! and get out.

	.RECONSTRUCT_INPUT;

	num_words = WordCount(); players_command = 100 + num_words;
    wn = 1;
    #Ifdef LanguageToInformese;
    LanguageToInformese();
    ! Re-tokenise:
    VM_Tokenise(buffer,parse);
    #Endif; ! LanguageToInformese
	num_words = WordCount(); players_command = 100 + num_words;
    actors_location = ScopeCeiling(player);
	FollowRulebook(Activity_after_rulebooks-->READING_A_COMMAND_ACT);

    return REPARSE_CODE;

    ! Now we come to the question asked when the input has run out
    ! and can't easily be guessed (eg, the player typed "take" and there
    ! were plenty of things which might have been meant).

  .Incomplete;

    if (context == CREATURE_TOKEN) PARSER_CLARIF_INTERNAL_RM('D', actor);
    else                           PARSER_CLARIF_INTERNAL_RM('E', actor);
    new_line;

    #Ifdef TARGET_ZCODE;
    for (i=2 : i<INPUT_BUFFER_LEN : i++) buffer2->i=' ';
    #Endif; ! TARGET_ZCODE
    answer_words = Keyboard(buffer2, parse2);

	! Look for a comma, and interpret this as a fresh conversation command
	! if so:

	for (i=1 : i<=answer_words : i++)
		if (WordFrom(i, parse2) == comma_word) {
			VM_CopyBuffer(buffer, buffer2);
			jump RECONSTRUCT_INPUT;
		}

    first_word=(parse2-->1);
    #Ifdef LanguageIsVerb;
    if (first_word==0) {
        j = wn; first_word=LanguageIsVerb(buffer2, parse2, 1); wn = j;
    }
    #Endif; ! LanguageIsVerb

    ! Once again, if the reply looks like a command, give it to the
    ! parser to get on with and forget about the question...

   ! if (first_word ~= 0) {
   !     j = first_word->#dict_par1;
   !     if ((0 ~= j&1) && ~~LanguageVerbMayBeName(first_word)) {
   !         VM_CopyBuffer(buffer, buffer2);
   !         jump RECONSTRUCT_INPUT;
   !     }
   ! }

   ! RD: As above, we don't try to figure out whether the command starts with a verb
   ! RD: We just set the disambiguation flags, paste in the answer, and let the parser try to handle it
    processing_disambiguation = 1;
    asked_for_disambiguation = 1;
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

    jump RECONSTRUCT_INPUT;

]; ! end of NounDomain

[ PARSER_CLARIF_INTERNAL_R; ]; 
-) instead of "Noun Domain" in "Parser.i6t".

Section 4 - Parser Letter H Replacement


Include
(-
  .GiveError;
   ! RD: If we hit a parser error while processing disambiguation, that means we failed to understand
    ! RD: the answer to the question as a disambiguation response.
    ! RD: So we reprocess that as a new command. 
    if (processing_disambiguation == 1) {
	print "I couldn't understand that as a response to the question, so I am treating that as a new command. (This should be a library message.)^";
	! RD: now since we've given up on processing this as a disambiguation command
	! RD: we reset the flags (at the end of Parser Letter H) to note that we aren't processing a disambiguation anymore
	! RD: copy the secondary buffer (which contained the typed command) to the primary buffer
	! RD: set the flag that tells the next for reading a command rule to just read the primary buffer
	! RD: and let things move along to Parser Letter I, which will produce a parser error
	! RD: which we squash with a Rule for printing a parser error, in the next section
	VM_CopyBuffer(buffer, buffer2);
	processing_failed_disambig = 1;
	}
	! RD: That's the end of the Responsive Disambiguation code
	! RD: if we weren't processing disambiguation, we give a parser error as usual
    etype = best_etype;
      ! RD: in the next line, added a processing_disambiguation check
      ! RD: so "bob, x board"/which board?/"yzzy" doesn't get processed as answering it that
    if (actor ~= player && processing_disambiguation == 0) {
        if (usual_grammar_after ~= 0) {
            verb_wordnum = usual_grammar_after;
            jump AlmostReParse;
        }
        wn = verb_wordnum;
        special_word = NextWord();
        if (special_word == comma_word) {
            special_word = NextWord();
            verb_wordnum++;
        }
        parser_results-->ACTION_PRES = ##Answer;
        parser_results-->NO_INPS_PRES = 2;
        parser_results-->INP1_PRES = actor;
        parser_results-->INP2_PRES = 1; special_number1 = special_word;
        actor = player;
        consult_from = verb_wordnum; consult_words = num_words-consult_from+1;
        rtrue;
    }
      ! RD: Now we reset the disambiguation flags
	! RD: have to do it here instead of above, so we can check the flag to avoid a spurious answering action 
      processing_disambiguation = 0;
	asked_for_disambiguation = 0; 
-) instead of "Parser Letter H" in "Parser.i6t".

Section 5 - Processing the failed disambiguation

[when disambiguation fails, the outcome is technically a parser error (usually "you can't see any such thing"), but we don't want that to print]
First before printing a parser error when processing failed disambiguation is 1 (this is the end before printing a parser error on failed disambiguation rule): rule fails.
For printing a parser error when processing failed disambiguation is 1: do nothing.
First after printing a parser error when processing failed disambiguation is 1 (this is the end after printing a parser error on failed disambiguation rule): rule fails.

[and then we just want to process the answer to the disambiguation prompt as a normal command. Since the modified Parser Letter H has already loaded that answer into buffer, we don't have to do anything; just let the "for reading a command" rule run and it will interrupt the normal process of reading a command and send the contents of buffer into the parser. This is a good place to reset the processing failed disambiguation flag, so that's what we do here, but the main effect of the rule is that it preempts the normal operation of the reading a command activity.]
For reading a command when processing failed disambiguation is 1:
	now processing failed disambiguation is 0.

Responsive Disambiguation for 6M62 ends here.

---- DOCUMENTATION ----

Responsive Disambiguation is a plug-and-play extension; it should have its desired effect merely by including it. 

It is intended to produce more responsive behavior in response to disambiguation questions. The usual state of affairs is that when the I7 parser asks "Which do you mean, the red block or the blue block?", it determines whether what the player types is meant as an answer to the question by testing whether the first word is a verb. Usually this will work, but if it has asked (say) "Which do you mean, the Go board or the chess board?" then it will treat the reply "Go" as a new command (to go in some unspecified direction) even though "Go board" was one of the answers listed.

Responsive Disambiguation resolves this by testing any answer whatsoever to the disambiguation question to see whether it would work as a disambiguation. As is the usual behavior with disambiguation, it inserts the answer into the original command and runs the command. If it does not result in a parser error, it is a successful disambiguation. If it does result in a parser error, then Responsive Disambiguation copies the answer (still held in the I6 buffer2) into the standard player input buffer (the I6 buffer), setting a flag to indicate that we are now processing a failed attempt at disambiguation. 

It then allows the parser to process the old command as a parser error, but suppresses the output with a For printing a parser error rule that fires when the flag for processing a failed disambiguation has been set. That flag then causes a For reading a command rule to run that preempts the ordinary mechanism of reading a command; since buffer has already been filled with the response to the disambiguation prompt, this is now processed as a new command. 

Responsive Disambiguation also changes the behavior of disambiguation in a command given to NPCs. The default behavior without Responsive Disambiguation is to insert the disambiguation response into the command, and if the command cannot be parsed to process it as the answering it that action. So this

>Bob, x board

Which do you mean, the chess board or the go board?

>north

would be treated as though we had typed "Bob, x north board," yielding the action of answering Bob that "x north board". Under Responsive Disambiguation, "north" is treated as a new command.

Since Responsive Disambiguation directly modifies Noun Domain and other parts of the Inform 6 parser template, it will not be compatible with other extensions governing disambiguation that also modify the template. However, Responsive Documentation does not make too many changes to the parser, and it should be reasonably straightforward to copy them into other modified versions of NounDomain and Parser Letter H. All changes are marked with I6 comments beginning "RD:".

Also, Responsive Disambiguation may react unpredictably with After Reading A Command rules. Authors should be careful!

Please contact me at (myfirstname)@(myfirstname)(mylastname).net with any issues or suggestions, or PM me at intfiction.org (my username is matt w).

Example: * Games Room - A simple example of Responsive Documentation.

Include Responsive Disambiguation for 6M62 by Matt Weiner.

Games Room is a room. A chess board and a Go board are in Games room.

Test me with "x board / go / x board / jump / x board / fthagn". 
