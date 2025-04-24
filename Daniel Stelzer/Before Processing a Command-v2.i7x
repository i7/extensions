Version 2.0.20250424 of Before Processing a Command by Daniel Stelzer begins here.

Section - I7 Code

Before processing a command is a rulebook.

Section - I6 Code

Include (-
[ Parser__parse
	syntax line num_lines line_address i j k token l m inferred_go;
	cobj_flag = 0;
	parser_results-->ACTION_PRES = 0;
	parser_results-->NO_INPS_PRES = 0;
	parser_results-->INP1_PRES = 0;
	parser_results-->INP2_PRES = 0;
	meta = false;

! @h Parser Letter A.
! Get the input, do OOPS and AGAIN.
! 
! =
	
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

  .ReParse;

    parser_inflection = name;

    ! Initially assume the command is aimed at the player, and the verb
    ! is the first word

    num_words = WordCount(); players_command = 100 + num_words;
    wn = 1; inferred_go = false;

    LanguageToInformese();
    ! Re-tokenise:
    VM_Tokenise(buffer,parse);

    num_words = WordCount(); players_command = 100 + num_words; token_filter = 0;
    allow_plurals = true; ResetDescriptors();
    
	! CHANGED DMS
	FollowRulebook((+ before processing a command +));
	if(RulebookFailed()) jump ReType;
	! END CHANGE

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
        
        ! i = RunRoutines(actor, grammar);
        !#Ifdef DEBUG;
        !if (parser_trace >= 2 && actor.grammar ~= 0 or NULL)
        !    print " [Grammar property returned ", i, "]^";
        !#Endif; ! DEBUG
        i = 0;

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

! @h Parser Letter B.
! Is the command a direction name, and so an implicit GO? If so, go to (K).
! 
! =
    if (verb_word == 0) {
        i = wn; verb_word = LanguageIsVerb(buffer, parse, verb_wordnum);
        wn = i;
    }

    ! If the first word is not listed as a verb, it must be a direction
    ! or the name of someone to talk to

    if (verb_word == 0 || ((verb_word->#dict_par1) & 1) == 0) {
        ! So is the first word an object contained in the special object "compass"
        ! (i.e., a direction)?  This needs use of NounDomain, a routine which
        ! does the object matching, returning the object number, or 0 if none found,
        ! or REPARSE_CODE if it has restructured the parse table so the whole parse
        ! must be begun again...

        wn = verb_wordnum; indef_mode = false; token_filter = 0; parameters = 0;
        @push actor; @push action; @push action_to_be;
        actor = player; meta = false; action = ##Go; action_to_be = ##Go;
        l = NounDomain(Compass, 0, 0);
        @pull action_to_be; @pull action; @pull actor;
        if (l == REPARSE_CODE) jump ReParse;

        ! If it is a direction, send back the results:
        ! action=GoSub, no of arguments=1, argument 1=the direction.

        if ((l~=0) && (l ofclass K3_direction)) {
            parser_results-->ACTION_PRES = ##Go;
            parser_results-->NO_INPS_PRES = 1;
            parser_results-->INP1_PRES = l;
            inferred_go = true;
            jump LookForMore;
        }

    } ! end of first-word-not-a-verb

! @h Parser Letter C.
! Is anyone being addressed?
! 
! =
	! Only check for a comma (a "someone, do something" command) if we are
	! not already in the middle of one.  (This simplification stops us from
	! worrying about "robot, wizard, you are an idiot", telling the robot to
	! tell the wizard that she is an idiot.)

	if (actor == player) {
		for (j=2 : j<=num_words : j++) {
			i=NextWord();
			if (i == comma_word) jump Conversation;
		}
	}
	jump NotConversation;

	! NextWord nudges the word number wn on by one each time, so we've now
	! advanced past a comma.  (A comma is a word all on its own in the table.)

	.Conversation;
	j = wn - 1;

	! Use NounDomain (in the context of "animate creature") to see if the
	! words make sense as the name of someone held or nearby

	wn = 1; lookahead = HELD_TOKEN;
	scope_reason = TALKING_REASON;
	l = NounDomain(player, actors_location, CREATURE_TOKEN);
	scope_reason = PARSING_REASON;
	if (l == REPARSE_CODE) jump ReParse;
	if (l == 0) {
		if (verb_word && ((verb_word->#dict_par1) & 1)) jump NotConversation;
		best_etype = MISSINGPERSON_PE; jump GiveError;
	}

	.Conversation2;

	! The object addressed must at least be "talkable" if not actually "animate"
	! (the distinction allows, for instance, a microphone to be spoken to,
	! without the parser thinking that the microphone is human).

	if (l hasnt animate && l hasnt talkable) {
 		best_etype = ANIMALISTEN_PE; noun = l; jump GiveError;
	}

	! Check that there aren't any mystery words between the end of the person's
	! name and the comma (eg, throw out "dwarf sdfgsdgs, go north").

	if (wn ~= j) {
		if (verb_word && ((verb_word->#dict_par1) & 1)) jump NotConversation;
		best_etype = TOTALK_PE; jump GiveError;
	}

	! The player has now successfully named someone.  Adjust "him", "her", "it":

	PronounNotice(l);

	! Set the global variable "actor", adjust the number of the first word,
	! and begin parsing again from there.

	verb_wordnum = j + 1;

	! Stop things like "me, again":

	if (l == player) {
		wn = verb_wordnum;
		if (NextWordStopped() == AGAIN1__WD or AGAIN2__WD or AGAIN3__WD) {
			best_etype = ANIMAAGAIN_PE;
			jump GiveError;
		}
	}

	actor = l;
	actors_location = ScopeCeiling(l);
	#Ifdef DEBUG;
	if (parser_trace >= 1)
		print "[Actor is ", (the) actor, " in ", (name) actors_location, "]^";
	#Endif; ! DEBUG
	jump BeginCommand;

! @h Parser Letter D.
! Get the verb: try all the syntax lines for that verb.
! 
! =
	.NotConversation;
	if (verb_word == 0 || ((verb_word->#dict_par1) & 1) == 0) {
		verb_word = UnknownVerb(verb_word);
		if (verb_word ~= 0) jump VerbAccepted;
		best_etype = VERB_PE;
		jump GiveError;
	}
	.VerbAccepted;

    ! We now definitely have a verb, not a direction, whether we got here by the
    ! "take ..." or "person, take ..." method.  Get the meta flag for this verb:

    meta = ((verb_word->#dict_par1) & 2)/2;

    ! You can't order other people to "full score" for you, and so on...

    if (meta == 1 && actor ~= player) {
        best_etype = VERB_PE;
        meta = 0;
        jump GiveError;
    }

    ! Now let i be the corresponding verb number...

    i = DictionaryWordToVerbNum(verb_word);

    ! ...then look up the i-th entry in the verb table, whose address is at word
    ! 7 in the Z-machine (in the header), so as to get the address of the syntax
    ! table for the given verb...

    #Ifdef TARGET_ZCODE;
    syntax = (HDR_STATICMEMORY-->0)-->i;
    #Ifnot; ! TARGET_GLULX
    syntax = (#grammar_table)-->(i+1);
    #Endif; ! TARGET_

    ! ...and then see how many lines (ie, different patterns corresponding to the
    ! same verb) are stored in the parse table...

    num_lines = (syntax->0) - 1;

    ! ...and now go through them all, one by one.
    ! To prevent pronoun_word 0 being misunderstood,

    pronoun_word = NULL; pronoun_obj = NULL;

    #Ifdef DEBUG;
    if (parser_trace >= 1)
    	print "[Parsing for the verb '", (address) verb_word, "' (", num_lines+1, " lines)]^";
    #Endif; ! DEBUG

    best_etype = STUCK_PE; nextbest_etype = STUCK_PE;
    multiflag = false;

    ! "best_etype" is the current failure-to-match error - it is by default
    ! the least informative one, "don't understand that sentence".
    ! "nextbest_etype" remembers the best alternative to having to ask a
    ! scope token for an error message (i.e., the best not counting ASKSCOPE_PE).
    ! multiflag is used here to prevent inappropriate MULTI_PE errors
    ! in addition to its unrelated duties passing information to action routines

! @h Parser Letter E.
! Break down a syntax line into analysed tokens.
! 
! =
    line_address = syntax + 1;

    for (line=0 : line<=num_lines : line++) {

        ! Unpack the syntax line from Inform format into three arrays; ensure that
        ! the sequence of tokens ends in an ENDIT_TOKEN.

        line_address = UnpackGrammarLine(line_address);

        #Ifdef DEBUG;
        if (parser_trace >= 1) {
            if (parser_trace >= 2) new_line;
            print "[line ", line; DebugGrammarLine();
            print "]^";
        }
        #Endif; ! DEBUG

        ! We aren't in "not holding" or inferring modes, and haven't entered
        ! any parameters on the line yet, or any special numbers; the multiple
        ! object is still empty.

        inferfrom = 0;
        parameters = 0;
        nsns = 0; special_word = 0;
        multiple_object-->0 = 0;
        multi_context = 0;
        etype = STUCK_PE; multi_had = 0;

        ! Put the word marker back to just after the verb

        wn = verb_wordnum+1;

! @h Parser Letter F.
! Look ahead for advance warning for |multiexcept|/|multiinside|.
! 
! There are two special cases where parsing a token now has to be affected by
! the result of parsing another token later, and these two cases (multiexcept
! and multiinside tokens) are helped by a quick look ahead, to work out the
! future token now. We can only carry this out in the simple (but by far the
! most common) case:
! 
! 	|multiexcept <one or more prepositions> noun|
! 
! and similarly for |multiinside|.
! 
! =
        advance_warning = -1; indef_mode = false;
        for (i=0,m=false,pcount=0 : line_token-->pcount ~= ENDIT_TOKEN : pcount++) {
            scope_token = 0;

            if (line_ttype-->pcount ~= PREPOSITION_TT) i++;

            if (line_ttype-->pcount == ELEMENTARY_TT) {
                if (line_tdata-->pcount == MULTI_TOKEN) m = true;
                if (line_tdata-->pcount == MULTIEXCEPT_TOKEN or MULTIINSIDE_TOKEN  && i == 1) {
                    ! First non-preposition is "multiexcept" or
                    ! "multiinside", so look ahead.

                    #Ifdef DEBUG;
                    if (parser_trace >= 2) print " [Trying look-ahead]^";
                    #Endif; ! DEBUG

                    ! We need this to be followed by 1 or more prepositions.

                    pcount++;
                    if (line_ttype-->pcount == PREPOSITION_TT) {
                        ! skip ahead to a preposition word in the input
                        do {
                            l = NextWord();
                        } until ((wn > num_words) ||
                                 (l && (l->#dict_par1) & 8 ~= 0));

                        if (wn > num_words) {
                            #Ifdef DEBUG;
                            if (parser_trace >= 2)
                                print " [Look-ahead aborted: prepositions missing]^";
                            #Endif;
                            jump EmptyLine;
                        }

                        do {
                            if (PrepositionChain(l, pcount) ~= -1) {
                                ! advance past the chain
                                if ((line_token-->pcount)->0 & $20 ~= 0) {
                                    pcount++;
                                    while ((line_token-->pcount ~= ENDIT_TOKEN) &&
                                           ((line_token-->pcount)->0 & $10 ~= 0))
                                        pcount++;
                                } else {
                                    pcount++;
                                }
                            } else {
                                ! try to find another preposition word
                                do {
                                    l = NextWord();
                                } until ((wn >= num_words) ||
                                         (l && (l->#dict_par1) & 8 ~= 0));

                                if (l && (l->#dict_par1) & 8) continue;

                                ! lookahead failed
                                #Ifdef DEBUG;
                                if (parser_trace >= 2)
                                    print " [Look-ahead aborted: prepositions don't match]^";
                                #endif;
                                jump LineFailed;
                            }
                            if (wn <= num_words) l = NextWord();
                        } until (line_ttype-->pcount ~= PREPOSITION_TT);

                        .EmptyLine;
                        ! put back the non-preposition we just read
                        wn--;

                        if ((line_ttype-->pcount == ELEMENTARY_TT) &&
                        	(line_tdata-->pcount == NOUN_TOKEN)) {
                            l = Descriptors();  ! skip past THE etc
                            if (l~=0) etype=l;  ! don't allow multiple objects
                        	k = parser_results-->INP1_PRES; @push k; @push parameters;
                        	parameters = 1; parser_results-->INP1_PRES = 0;
                            l = NounDomain(actors_location, actor, NOUN_TOKEN, true);
                            @pull parameters; @pull k; parser_results-->INP1_PRES = k;
                            #Ifdef DEBUG;
                            if (parser_trace >= 2) {
                                print " [Advanced to ~noun~ token: ";
                                if (l == REPARSE_CODE) print "re-parse request]^";
                                else {
                                	if (l == 1) print "but multiple found]^";
                                	if (l == 0) print "error ", etype, "]^";
                                	if (l >= 2) print (the) l, "]^";
                                }
                            }
                            #Endif; ! DEBUG
                            if (l == REPARSE_CODE) jump ReParse;
                            if (l >= 2) advance_warning = l;
                        }
                    }
                    break;
                }
            }
        }

        ! Slightly different line-parsing rules will apply to "take multi", to
        ! prevent "take all" behaving correctly but misleadingly when there's
        ! nothing to take.

        take_all_rule = 0;
        if (m && params_wanted == 1 && action_to_be == ##Take)
            take_all_rule = 1;

        ! And now start again, properly, forearmed or not as the case may be.
        ! As a precaution, we clear all the variables again (they may have been
        ! disturbed by the call to NounDomain, which may have called outside
        ! code, which may have done anything!).

        inferfrom = 0;
        parameters = 0;
        nsns = 0; special_word = 0;
        multiple_object-->0 = 0;
        etype = STUCK_PE; multi_had = 1;
        wn = verb_wordnum+1;

! @h Parser Letter G.
! Parse each token in turn (calling |ParseToken| to do most of the work).
! 
! The |pattern| gradually accumulates what has been recognised so far,
! so that it may be reprinted by the parser later on.
! 
! =
		m = true;
        for (pcount=1 : : pcount++)
            if (line_token-->(pcount-1) == ENDIT_TOKEN) {
            	if (pcount >= 2) {
            		while ((((line_token-->(pcount-2))->0) & $10) ~= 0) pcount--;
            		AnalyseToken(line_token-->(pcount-2));
            		if (found_ttype == PREPOSITION_TT) {
            			l = -1;
            			while (true) {
            				m = NextWordStopped();
            				if (m == -1) break;
            				l = m;
            			}
            			if (PrepositionChain(l, pcount-2) == -1) {
            				m = false;
							#Ifdef DEBUG;
							if (parser_trace >= 2)
								print "[line rejected for not ending with correct preposition]^";
							#Endif; ! DEBUG
						} else m = true;
	           		}
            	}
            	break;
            }
		wn = verb_wordnum+1;

		if (m) for (pcount=1 : : pcount++) {
            pattern-->pcount = PATTERN_NULL; scope_token = 0;

            token = line_token-->(pcount-1);
            lookahead = line_token-->pcount;

            #Ifdef DEBUG;
            if (parser_trace >= 2)
                print " [line ", line, " token ", pcount, " word ", wn, " : ", (DebugToken) token,
                  "]^";
            #Endif; ! DEBUG

            if (token ~= ENDIT_TOKEN) {
                scope_reason = PARSING_REASON;
                AnalyseToken(token);

                l = ParseToken(found_ttype, found_tdata, pcount-1, token);
                while ((l >= GPR_NOUN) && (l < -1)) l = ParseToken(ELEMENTARY_TT, l + 256);
                scope_reason = PARSING_REASON;

                if (l == GPR_PREPOSITION) {
                    if (found_ttype~=PREPOSITION_TT && (found_ttype~=ELEMENTARY_TT ||
                        found_tdata~=TOPIC_TOKEN)) params_wanted--;
                    l = true;
                }
                else
                    if (l < 0) l = false;
                    else
                        if (l ~= GPR_REPARSE) {
                            if (l == GPR_NUMBER) {
                                if (nsns == 0) special_number1 = parsed_number;
                                else special_number2 = parsed_number;
                                nsns++; l = 1;
                            }
                            if (l == GPR_MULTIPLE) l = 0;
                            parser_results-->(parameters+INP1_PRES) = l;
                            parameters++;
                            pattern-->pcount = l;
                            l = true;
                        }

                #Ifdef DEBUG;
                if (parser_trace >= 3) {
                    print "  [token resulted in ";
                    if (l == REPARSE_CODE) print "re-parse request]^";
                    if (l == 0) print "failure with error type ", etype, "]^";
                    if (l == 1) print "success]^";
                }
                #Endif; ! DEBUG

                if (l == REPARSE_CODE) jump ReParse;
                if (l == false) break;
            }
            else {

                ! If the player has entered enough already but there's still
                ! text to wade through: store the pattern away so as to be able to produce
                ! a decent error message if this turns out to be the best we ever manage,
                ! and in the mean time give up on this line

                ! However, if the superfluous text begins with a comma or "then" then
                ! take that to be the start of another instruction

                if (wn <= num_words) {
                    l = NextWord();
                    if (l == THEN1__WD or THEN2__WD or THEN3__WD or comma_word) {
                        held_back_mode = true; hb_wn = wn-1;
                    } else {
                        for (m=0 : m<32 : m++) pattern2-->m = pattern-->m;
                        pcount2 = pcount;
                        etype = UPTO_PE;
                        break;
                    }
                }

                ! Now, we may need to revise the multiple object because of the single one
                ! we now know (but didn't when the list was drawn up).

                if (parameters >= 1) {
                	if (parser_results-->INP1_PRES == 0) {
                	    l = ReviseMulti(parser_results-->INP2_PRES);
                	    if (l ~= 0) { etype = l; parser_results-->ACTION_PRES = action_to_be; break; }
                	}
                }
                if (parameters >= 2) {
                	if (parser_results-->INP2_PRES == 0) {
            	        l = ReviseMulti(parser_results-->INP1_PRES);
                	    if (l ~= 0) { etype = l; break; }
                	} else {
                		k = parser_results-->INP1_PRES; l = parser_results-->INP2_PRES;
                		if (k && l) {
	                 		if ((multi_context==MULTIEXCEPT_TOKEN && k == l) ||
	                			((multi_context==MULTIINSIDE_TOKEN && k notin l && l notin k))) {
                				best_etype = NOTHING_PE;
                				parser_results-->ACTION_PRES = action_to_be; jump GiveError;
                			}
                		}
                	}
                }

                ! To trap the case of "take all" inferring only "yourself" when absolutely
                ! nothing else is in the vicinity...

                if (take_all_rule == 2 && parser_results-->INP1_PRES == actor) {
                    best_etype = NOTHING_PE;
                    jump GiveError;
                }

				if (multi_had > 1) {
                    best_etype = TOOFEW_PE;
                    jump GiveError;
				}

                #Ifdef DEBUG;
                if (parser_trace >= 1) print "[Line successfully parsed]^";
                #Endif; ! DEBUG

                ! The line has successfully matched the text.  Declare the input error-free...

                oops_from = 0;

                ! ...explain any inferences made (using the pattern)...

                if (inferfrom ~= 0) {
                	PrintInferredCommand(inferfrom);
                    ClearParagraphing(20);
                }

                ! ...copy the action number, and the number of parameters...

                parser_results-->ACTION_PRES = action_to_be;
                parser_results-->NO_INPS_PRES = parameters;

                ! ...reverse first and second parameters if need be...

                if (action_reversed && parameters == 2) {
                    i = parser_results-->INP1_PRES;
                    parser_results-->INP1_PRES = parser_results-->INP2_PRES;
                    parser_results-->INP2_PRES = i;
                    if (nsns == 2) {
                        i = special_number1; special_number1 = special_number2;
                        special_number2 = i;
                    }
                }

                ! ...and to reset "it"-style objects to the first of these parameters, if
                ! there is one (and it really is an object)...

                if (parameters > 0 && parser_results-->INP1_PRES >= 2)
                    PronounNotice(parser_results-->INP1_PRES);

                ! ...and return from the parser altogether, having successfully matched
                ! a line.

                if (held_back_mode) {
                    wn=hb_wn;
                    jump LookForMore;
                }
                rtrue;

            } ! end of if(token ~= ENDIT_TOKEN) else
        } ! end of for(pcount++)

        .LineFailed;
        ! The line has failed to match.
        ! We continue the outer "for" loop, trying the next line in the grammar.

        if (etype > best_etype) best_etype = etype;
        if (etype ~= ASKSCOPE_PE && etype > nextbest_etype) nextbest_etype = etype;

        ! ...unless the line was something like "take all" which failed because
        ! nothing matched the "all", in which case we stop and give an error now.

        if (take_all_rule == 2 && etype==NOTHING_PE) break;

    } ! end of for(line++)

    ! The grammar is exhausted: every line has failed to match.

! @h Parser Letter H.
! Cheaply parse otherwise unrecognised conversation and return.
! 
! (Errors are handled differently depending on who was talking. If the command
! was addressed to somebody else (eg, DWARF, SFGH) then it is taken as
! conversation which the parser has no business in disallowing.)
! 
! The parser used to return the fake action |##NotUnderstood| when a
! command in the form PERSON, ARFLE BARFLE GLOOP is parsed, where a character
! is addressed but with an instruction which the parser can't understand.
! (If a command such as ARFLE BARFLE GLOOP is not an instruction to someone
! else, the parser prints an error and requires the player to type another
! command: thus |##NotUnderstood| was only returned when |actor| is not the
! player.) And I6 had elaborate object-oriented ways to deal with this, but we
! won't use any of that: we simply convert to a |##Answer| action, which
! communicates a snippet of words to another character, just as if the
! player had typed ANSWER ARFLE BARFLE GLOOP TO PERSON. For I7 purposes, the
! fake action |##NotUnderstood| does not exist.
! 
! In order to assist people who do want to parse that type of mistyped command
! in extensions, wn is left pointing at the first word not parsed as a command.
! 
! =
  .GiveError;

    etype = best_etype;
    if (actor ~= player) {
        if (usual_grammar_after ~= 0) {
            verb_wordnum = usual_grammar_after;
            jump AlmostReParse;
        }
        m = wn; ! Save wn so extension authors can parse command errors if they want to
        wn = 1;
        while ((wn <= num_words) && (NextWord() ~= comma_word)) ;
        parser_results-->ACTION_PRES = ##Answer;
        parser_results-->NO_INPS_PRES = 2;
        parser_results-->INP1_PRES = actor;
        parser_results-->INP2_PRES = 1; special_number1 = special_word;
        actor = player;
        consult_from = wn; consult_words = num_words-consult_from+1;
        wn = m; ! Restore wn so extension authors can parse command errors if they want to
        rtrue;
    }

! @h Parser Letter I.
! Print best possible error message.
! 
! =
    ! If the player was the actor (eg, in "take dfghh") the error must be printed,
    ! and fresh input called for.  In three cases the oops word must be jiggled.

    if ((etype ofclass Routine) || (etype ofclass String)) {
        if (ParserError(etype) ~= 0) jump ReType;
    } else {
		if (verb_wordnum == 0 && etype == CANTSEE_PE) etype = VERB_PE;
		players_command = 100 + WordCount(); ! The snippet variable "player's command"
        BeginActivity(PRINTING_A_PARSER_ERROR_ACT);
        if (ForActivity(PRINTING_A_PARSER_ERROR_ACT)) jump SkipParserError;
    }
    pronoun_word = pronoun__word; pronoun_obj = pronoun__obj;

    if (etype == STUCK_PE) {    PARSER_ERROR_INTERNAL_RM('A'); new_line; oops_from = 1; }
    if (etype == UPTO_PE) {
        for (m=0 : m<32 : m++) pattern-->m = pattern2-->m;
        pcount = pcount2;
    	if (inferred_go) {
    		PARSER_ERROR_INTERNAL_RM('C');
    		print (name) parser_results-->INP1_PRES;
    	} else {
    		PARSER_ERROR_INTERNAL_RM('B');
        	PrintCommand(0);
        }
        print ".^";
    }
    if (etype == NUMBER_PE) {   PARSER_ERROR_INTERNAL_RM('D'); new_line; }
    if (etype == CANTSEE_PE) {  PARSER_ERROR_INTERNAL_RM('E'); new_line; oops_from=saved_oops; }
    if (etype == TOOLIT_PE) {   PARSER_ERROR_INTERNAL_RM('F'); new_line; }
    if (etype == NOTHELD_PE) {  PARSER_ERROR_INTERNAL_RM('G'); new_line; oops_from=saved_oops; }
    if (etype == MULTI_PE) {    PARSER_ERROR_INTERNAL_RM('H'); new_line; }
    if (etype == MMULTI_PE) {   PARSER_ERROR_INTERNAL_RM('I'); new_line; }
    if (etype == VAGUE_PE) {    PARSER_ERROR_INTERNAL_RM('J'); new_line; }
    if (etype == ITGONE_PE) {
        if (pronoun_obj == NULL) { PARSER_ERROR_INTERNAL_RM('J'); new_line; }
        else { PARSER_ERROR_INTERNAL_RM('K', noun); new_line; }
    }
    if (etype == EXCEPT_PE) {   PARSER_ERROR_INTERNAL_RM('L'); new_line; }
    if (etype == ANIMA_PE) {    PARSER_ERROR_INTERNAL_RM('M'); new_line; }
    if (etype == VERB_PE) {     PARSER_ERROR_INTERNAL_RM('N'); new_line; }
    if (etype == SCENERY_PE) {  PARSER_ERROR_INTERNAL_RM('O'); new_line; }
    if (etype == JUNKAFTER_PE) {  PARSER_ERROR_INTERNAL_RM('P'); new_line; }
    if (etype == TOOFEW_PE) {  PARSER_ERROR_INTERNAL_RM('Q', multi_had); new_line; }
    if (etype == NOTHING_PE) {
    	if (parser_results-->ACTION_PRES == ##Remove &&
        	parser_results-->INP2_PRES ofclass Object) {
        	noun = parser_results-->INP2_PRES; ! ensure valid for messages
            if (noun has animate) { PARSER_N_ERROR_INTERNAL_RM('C', noun); new_line; }
            else if (noun hasnt container or supporter) { PARSER_N_ERROR_INTERNAL_RM('D', noun); new_line; }
            else if (noun has container && noun hasnt open)  { PARSER_N_ERROR_INTERNAL_RM('E', noun); new_line; }
            else if (children(noun)==0) { PARSER_N_ERROR_INTERNAL_RM('F', noun); new_line; }
            else parser_results-->ACTION_PRES = 0;
        }
        if (parser_results-->ACTION_PRES ~= ##Remove) {
            if (multi_wanted==100) { PARSER_N_ERROR_INTERNAL_RM('A'); new_line; }
            else                  {  PARSER_N_ERROR_INTERNAL_RM('B'); new_line; }
        }
    }
    if (etype == NOTINCONTEXT_PE) { PARSER_ERROR_INTERNAL_RM('R'); new_line; }
    if (etype == ANIMAAGAIN_PE) { PARSER_ERROR_INTERNAL_RM('S'); new_line; }
    if (etype == COMMABEGIN_PE) { PARSER_ERROR_INTERNAL_RM('T'); new_line; }
    if (etype == MISSINGPERSON_PE) { PARSER_ERROR_INTERNAL_RM('U'); new_line; }
    if (etype == ANIMALISTEN_PE) { PARSER_ERROR_INTERNAL_RM('V', noun); new_line; }
    if (etype == TOTALK_PE) { PARSER_ERROR_INTERNAL_RM('W'); new_line; }
    if (etype == ASKSCOPE_PE) {
        scope_stage = 3;
        if (scope_error() == -1) {
            best_etype = nextbest_etype;
            if (~~((etype ofclass Routine) || (etype ofclass String)))
            	EndActivity(PRINTING_A_PARSER_ERROR_ACT);
            jump GiveError;
        }
    }

    .SkipParserError;
    if ((etype ofclass Routine) || (etype ofclass String)) jump ReType;
    say__p = 1;
    EndActivity(PRINTING_A_PARSER_ERROR_ACT);

! @h Parser Letter J.
! Retry the whole lot.
! 
! =
    ! And go (almost) right back to square one...

    jump ReType;

    ! ...being careful not to go all the way back, to avoid infinite repetition
    ! of a deferred command causing an error.

! @h Parser Letter K.
! Last thing: check for THEN and further instructions(s), return.
! 
! =
    ! At this point, the return value is all prepared, and we are only looking
    ! to see if there is a "then" followed by subsequent instruction(s).

  .LookForMore;

    if (wn > num_words) rtrue;

    i = NextWord();
    if (i == THEN1__WD or THEN2__WD or THEN3__WD or comma_word) {
        if (wn > num_words) {
           held_back_mode = false;
           return;
        }
        hb_wn = wn;
        held_back_mode = true;
       return;
    }
    best_etype = UPTO_PE;
    jump GiveError;

! @h End of Parser Proper.
! 
! =
]; ! end of Parser__parse
-) replacing "Parser__parse".

Before Processing a Command ends here.

---- DOCUMENTATION ----

This extension adds a new rulebook, "before processing a command", which is run before each iteration of the parser. In other words, if the player enters a command like "N. E. JUMP", this rulebook will run once with the player's command set to "N. E. JUMP", once with it set to "E. JUMP", and once with it set to "JUMP".

This is intended to avoid many of the headaches created by "after reading a command" rules, and acts similarly to them in as many respects as possible. In particular, it also allows you to "reject the player's command", which returns control to the keyboard, skipping any remaining commands.

Note that this is a single rulebook, not an activity. There are no "for processing a command" or "after processing a command" rules.

Example: * Echo - A basic demonstration of the extension.

"Echo"

Include Before Processing a Command by Daniel Stelzer.

Before processing a command: say "[player's command]".

Lab is a room.

Test me with "wait / jump then wait then wave / wave. jump".

Example: *** The Riddle of the Labyrinth - Cancelling a series of commands when something dramatic happens in the world.

"The Riddle of the Labyrinth"

Include Before Processing a Command by Daniel Stelzer.

[We want to interrupt ongoing commands if something dramatic has happened since the last time the player typed something on the keyboard.

We handle this with a flag: it gets set to false whenever the player has the opportunity to type, and set to true whenever dramatic changes happen in the world.

If the flag is true "before processing a command", then, we want to cancel all processing. This is where "reject the player's command" comes in.]

The interruption flag is initially false.
Before reading a command: now the interruption flag is false.
Before processing a command when the interruption flag is true:
	say "(Since something dramatic has happened, the remainder of your command---'[player's command]'---has been cut off.)[paragraph break]";
	now the interruption flag is false;
	reject the player's command.

To interrupt ongoing commands:
	now the interruption flag is true.

[Now we contrive a reason why the player would want to type a long sequence of commands on a single line, but might also get interrupted in the process.

This is a sort of maze that was very popular in the early 80s, where every wrong step leads back to the starting location. The intended result is that you need to know the correct path in advance. But what usually happened instead was that players would map it by brute force.]

Definition: a direction (called the way) is viable if the room-or-door (way) from the location is not nothing.
A maze is a kind of room. The printed name of a maze is "Labyrinth". The description of a maze is "Exits lead [list of viable directions]."

Start is a maze. The description of Start is "You've chalked a big X on the floor here to mark your starting point. Exits lead [list of viable directions]." North of Start is Start. East of Start is Maze1. West of Start is Start. South of Start is Start.

Maze1 is a maze. North of Maze1 is Maze2. East of Maze1 is Start. West of Maze1 is Start. South of Maze1 is Start.

Maze2 is a maze. North of Maze2 is Maze3. East of Maze2 is Start. West of Maze2 is Start. South of Maze2 is Start.

Maze3 is a maze. North of Maze3 is Start. East of Maze3 is Maze4. West of Maze3 is Start. South of Maze3 is Start.

Maze4 is a maze. North of Maze4 is Start. East of Maze4 is Maze5. West of Maze4 is Start. South of Maze4 is Start.

Maze5 is a maze. North of Maze5 is Start. East of Maze5 is Start. West of Maze5 is Start. South of Maze5 is Maze6.

Maze6 is a maze. North of Maze6 is Start. East of Maze6 is Start. West of Maze6 is Maze7. South of Maze6 is Start.

Maze7 is a maze. North of Maze7 is Start. East of Maze7 is Start. West of Maze7 is Start. South of Maze7 is Start. Southeast of Maze7 is End.

End is a room. The description of End is "That last passage dropped you in a dead end with no exits. How can you escape now?" Northeast of End is nothing.

[And our source of interruptions!]

The Minotaur is a man.
Instead of jumping in the presence of the Minotaur:
	say "You jump on the spot. The Minotaur is startled and flees!";
	now the Minotaur is nowhere.
Instead of doing anything in the presence of the Minotaur:
	say "The Minotaur charges. The results are unfortunately too gory to describe in text.";
	end the story saying "You have died".

Every turn:
	if a random chance of 1 in 5 succeeds:
		move the Minotaur to the location;
		say "The Minotaur lumbers into the room!";
		interrupt ongoing commands.

[We don't really want to make the player brute-force the maze.]

The player carries a clue. The description of the clue is "Instead of the traditional spool of thread, the king's daughter gave you this slip of paper. On the front it says: 'E. N. N. E. E. S. W. SE. Then say the magic word.' On the back it says: 'Jumping scares the Minotaur away.'"

[And the final magic word. SAY XYZZY will, by default, map to "answering yourself that xyzzy".]

Instead of answering yourself that a topic:
	say "You cry out, '[topic understood]'! But there is no answer."

[The correct path through the maze has drawn out this magic letter on the map.]

Instead of answering yourself that "r" when the location is End:
	say "As you call out the magic word, a hidden door swings open in the wall...";
	end the story finally saying "But what happens next?".
