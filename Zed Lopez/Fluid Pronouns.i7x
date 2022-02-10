Fluid Pronouns by Zed Lopez begins here.

"Allows arbitrary custom pronouns (including support for pronouns whose grammatical number
differs from its antecedent's, i.e., verb conjugation matches appropriately for the
singular 'they'). Removes all consequences from the built-in male, female, and neuter
properties. By default, objects of kind person have a singular 'they' pronoun. A limitation
is that things can only have exactly one pronoun at a time. For 6M62."

"Incorporates code from Gender Speedup by Nathanael Nerode and comments from Original Parser by Ron Newcomb"

Volume Inclusions

Part cast (for use without Central Typecasting by Zed Lopez)

To decide what K is a/an/-- (unknown - a value) cast as a/an/-- (name of kind of value K): (- {unknown} -).

To decide what K is a/-- null (name of kind of value K): (- nothing -)

Part grammar (for use without Grammar Tests by Zed Lopez) [TODO: rename]

Grammatical-number is a kind of value.
A grammatical-number has a text called the printed name.
The grammatical-numbers are gn-singular and gn-plural.
The printed name of gn-singular is "singular".
The printed name of gn-plural is "plural".
To say (g - a grammatical-number): say the printed name of g.

Some grammatical cases are possessive, reflexive, possessive adjective. 
To decide what narrative viewpoint is a/-- viewpoint of (N - a number) and a/an/-- (G - a grammatical-number): (- ((({G} - 1) * 3) + {N}) -)

Volume Pronouns

Book Smash the Gender Binary

Include (- -) instead of "Pronouns" in "Language.i6t". 
Include (- -) instead of "Gender" in "Parser.i6t".

Book Parser

Part NounDomain

Include (-

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
	    	for (j=0 : j<number_matched-1 : j++ )
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
	for (i=1 : i<=number_of_classes : i++ ) {
		while (((match_classes-->marker) ~= i) && ((match_classes-->marker) ~= -i))
			marker++;
		if (match_list-->marker hasnt animate) j = 0;
	}
	if (j) PARSER_CLARIF_INTERNAL_RM('A');
	else PARSER_CLARIF_INTERNAL_RM('B');

    j = number_of_classes; marker = 0;
    for (i=1 : i<=number_of_classes : i++ ) {
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
    for (i=2 : i<INPUT_BUFFER_LEN : i++ ) buffer2->i = ' ';
    #Endif; ! TARGET_ZCODE
    answer_words=Keyboard(buffer2, parse2);

    ! Conveniently, parse2-->1 is the first word in both ZCODE and GLULX.
    first_word = (parse2-->1);

    ! Take care of "all", because that does something too clever here to do
    ! later on:

    if (first_word == ALL1__WD or ALL2__WD or ALL3__WD or ALL4__WD or ALL5__WD) {
        if (context == MULTI_TOKEN or MULTIHELD_TOKEN or MULTIEXCEPT_TOKEN or MULTIINSIDE_TOKEN) {
            l = multiple_object-->0;
            for (i=0 : i<number_matched && l+i<MATCH_LIST_WORDS : i++ ) {
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

	for (i=1 : i<=answer_words : i++ )
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
    for (i=0 : i<l : i++ ) buffer->(k+i) = buffer2->(2+i);
    buffer->(k+l-1) = ' ';
    buffer->1 = buffer->1 + l;
    if (buffer->1 >= (buffer->0 - 1)) buffer->1 = buffer->0;
    #Ifnot; ! TARGET_GLULX
    k = WordAddress(match_from) - buffer;
    l = (buffer2-->0) + 1;
    for (j=buffer+INPUT_BUFFER_LEN-1 : j>=buffer+k+l : j-- ) j->0 = j->(-l);
    for (i=0 : i<l : i++ ) buffer->(k+i) = buffer2->(WORDSIZE+i);
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
    for (i=2 : i<INPUT_BUFFER_LEN : i++ ) buffer2->i=' ';
    #Endif; ! TARGET_ZCODE
    answer_words = Keyboard(buffer2, parse2);

	! Look for a comma, and interpret this as a fresh conversation command
	! if so:

	for (i=1 : i<=answer_words : i++ )
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

    if (first_word ~= 0) {
        j = first_word->#dict_par1;
        if ((0 ~= j&1) && ~~LanguageVerbMayBeName(first_word)) {
            VM_CopyBuffer(buffer, buffer2);
            jump RECONSTRUCT_INPUT;
        }
    }

    ! ...but if we have a genuine answer, then:
    !
    ! (1) we must glue in text suitable for anything that's been inferred.

    if (inferfrom ~= 0) {
        for (j=inferfrom : j<pcount : j++ ) {
            if (pattern-->j == PATTERN_NULL) continue;
            #Ifdef TARGET_ZCODE;
            i = 2+buffer->1; (buffer->1)++; buffer->(i++ ) = ' ';
            #Ifnot; ! TARGET_GLULX
            i = WORDSIZE + buffer-->0;
            (buffer-->0)++; buffer->(i++ ) = ' ';
            #Endif; ! TARGET_

            #Ifdef DEBUG;
            if (parser_trace >= 5)
            	print "[Gluing in inference with pattern code ", pattern-->j, "]^";
            #Endif; ! DEBUG

            ! Conveniently, parse2-->1 is the first word in both ZCODE and GLULX.

            parse2-->1 = 0;

            ! An inferred object.  Best we can do is glue in a pronoun.
            ! (This is imperfect, but it's very seldom needed anyway.)
print "noundomain reparse_code:", REPARSE_CODE, "pattern-->j: ", pattern-->j, "^";
            if (pattern-->j >= 2 && pattern-->j < REPARSE_CODE) {
                PronounNotice(pattern-->j);
                for (k=1 : k<=FluidLanguagePronouns-->0 : k=k+3)
print "pattern ", pattern-->j, "^";
print (stringarray) FluidLanguagePronouns-->k, "^";
                    if (pattern-->j == FluidLanguagePronouns-->k) {
                        parse2-->1 = FluidLanguagePronouns-->(k+1);
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
                for (l=i : l<i+k : l++ ) buffer->l = buffer->(l+2);
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
    i = 2+buffer->1; (buffer->1)++; buffer->(i++ ) = ' ';
    for (j=0 : j<buffer2->1 : i++,j++ ) {
        buffer->i = buffer2->(j+2);
        (buffer->1)++;
        if (buffer->1 == INPUT_BUFFER_LEN) break;
    }
    #Ifnot; ! TARGET_GLULX
    i = WORDSIZE + buffer-->0;
    (buffer-->0)++; buffer->(i++ ) = ' ';
    for (j=0 : j<buffer2-->0 : i++,j++ ) {
        buffer->i = buffer2->(j+WORDSIZE);
        (buffer-->0)++;
        if (buffer-->0 == INPUT_BUFFER_LEN) break;
    }
    #Endif; ! TARGET_

    ! (3) we fill up the buffer with spaces, which is unnecessary, but may
    !     help incorrectly-written interpreters to cope.

    #Ifdef TARGET_ZCODE;
    for (: i<INPUT_BUFFER_LEN : i++ ) buffer->i = ' ';
    #Endif; ! TARGET_ZCODE

    jump RECONSTRUCT_INPUT;

]; ! end of NounDomain

[ PARSER_CLARIF_INTERNAL_R; ];

-) instead of "Noun Domain" in "Parser.i6t".


[
[We now reach the final major block of code in the parser: the part which tries
to match a given object's name(s) against the text at word position |match_from|
in the player's command, and calls |MakeMatch| if it succeeds. There are
basically four possibilities: ME, a pronoun such as IT, a name which doesn't
begin misleadingly with a number, and a name which does. In the latter two
cases, we pass the job down to |TryGivenObject|.]

To decide if  (item - an object) is the antecedent for (i - an understood [pronoun] word):
(- (({i} >= 2) && ({i} < 128) && (LanguagePronouns-->{i} == {item}))  -).
]


Include (-

[ MatchTextAgainstObject item i;
    if (token_filter ~= 0 && ConsultNounFilterToken(item) == 0) return;

	if (match_from <= num_words) { ! If there's any text to match, that is
		wn = match_from;
		i = NounWord();
		if ((i == 1) && (player == item)) MakeMatch(item, 1); ! "me"
!print "^MatchTextAgainstObject item: ", item, "i: ", i, "^";
!print "^";
		if ((i >= 2) && (i < 128) && (FluidLanguagePronouns-->i == item)) MakeMatch(item, 1);
	}

	! Construing the current word as the start of a noun, can it refer to the
	! object?

	wn = match_from;
	if (TryGivenObject(item) > 0)
		if (indef_nspec_at > 0 && match_from ~= indef_nspec_at) {
			! This case arises if the player has typed a number in
			! which is hypothetically an indefinite descriptor:
			! e.g. "take two clubs".  We have just checked the object
			! against the word "clubs", in the hope of eventually finding
			! two such objects.  But we also backtrack and check it
			! against the words "two clubs", in case it turns out to
			! be the 2 of Clubs from a pack of cards, say.  If it does
			! match against "two clubs", we tear up our original
			! assumption about the meaning of "two" and lapse back into
			! definite mode.

			wn = indef_nspec_at;
			if (TryGivenObject(item) > 0) {
				match_from = indef_nspec_at;
				ResetDescriptors();
			}
			wn = match_from;
		}
];

-) instead of "Parsing Object Names" in "Parser.i6t".

Include (-
[ TryGivenObject obj nomatch threshold k w j;
    #Ifdef DEBUG;
    if (parser_trace >= 5) print "    Trying ", (the) obj, " (", obj, ") at word ", wn, "^";
    #Endif; ! DEBUG

	if (nomatch && obj == 0) return 0;

! if (nomatch) print "*** TryGivenObject *** on ", (the) obj, " at wn = ", wn, "^";

    dict_flags_of_noun = 0;

!  If input has run out then always match, with only quality 0 (this saves
!  time).

    if (wn > num_words) {
    	if (nomatch) return 0;
        if (indef_mode ~= 0)
            dict_flags_of_noun = $$01110000;  ! Reject "plural" bit
        MakeMatch(obj,0);
        #Ifdef DEBUG;
        if (parser_trace >= 5) print "    Matched (0)^";
        #Endif; ! DEBUG
        return 1;
    }

!  Ask the object to parse itself if necessary, sitting up and taking notice
!  if it says the plural was used:

    if (obj.parse_name~=0) {
        parser_action = NULL; j=wn;
        k = RunRoutines(obj,parse_name);
        if (k > 0) {
            wn=j+k;

          .MMbyPN;

            if (parser_action == ##PluralFound)
                dict_flags_of_noun = dict_flags_of_noun | 4;

            if (dict_flags_of_noun & 4) {
                if (~~allow_plurals) k = 0;
                else {
                    if (indef_mode == 0) {
                        indef_mode = 1; indef_type = 0; indef_wanted = 0;
                    }
                    indef_type = indef_type | PLURAL_BIT;
                    if (indef_wanted == 0) indef_wanted = INDEF_ALL_WANTED;
                }
            }

            #Ifdef DEBUG;
            if (parser_trace >= 5) print "    Matched (", k, ")^";
            #Endif; ! DEBUG
            if (nomatch == false) MakeMatch(obj,k);
            return k;
        }
        if (k == 0) jump NoWordsMatch;
    }

    ! The default algorithm is simply to count up how many words pass the
    ! Refers test:

    parser_action = NULL;

    w = NounWord();

    if (w == 1 && player == obj) { k=1; jump MMbyPN; }

    if (w >= 2 && w < 128 && (FluidLanguagePronouns-->w == obj)) { k = 1; jump MMbyPN; }

    if (Refers(obj, wn-1) == 0) {
        .NoWordsMatch;
        if (indef_mode ~= 0) { k = 0; parser_action = NULL; jump MMbyPN; }
        rfalse;
    }

	threshold = 1;
	dict_flags_of_noun = (w->#dict_par1) & $$01110100;
	w = NextWord();
	while (Refers(obj, wn-1)) {
		threshold++;
		if (w)
		   dict_flags_of_noun = dict_flags_of_noun | ((w->#dict_par1) & $$01110100);
		w = NextWord();
	}

    k = threshold;
    jump MMbyPN;
];

-) instead of "TryGivenObject" in "Parser.i6t".

Include (- 
[ streq s1 s2
    i;
!print "streq s1 ";
!print (dstring) s1;
!print " s2 ";
!print (stringarray) s2;
!print "^";
!if (s1 == s2) rtrue;
!if (s1->0 ~= s2->0) rfalse; ! different lengths
!if (~~(s1->0) && ~~(s2->0)) return 1; ! both null
for ( i = 1 : i <= s2->0 : i++ ) {
if (~~s1->(i)) rfalse; ! s1 too short.
if (s1->(i) ~= s2->i) rfalse; ! { print "false^"; rfalse; }
!if (~~(s1->i) || ~~(s2->i)) { print "false^"; rfalse; }
!i++;
!print (char) s1->i;
!} until (~~(s1->i));
}
!if (s2->i) { print "false^"; rfalse; }
return ~~(s1->i);
];
-).

[|NounWord| (which takes no arguments) returns:
(a) 0 if the next word is not in the dictionary or is but does not carry the
``noun'' bit in its dictionary entry,
(b) 1 if it is a word meaning ``me'',
(c) the index in the pronoun table (plus 2) of the value field of a pronoun,
if it is a pronoun,
(d) the address in the dictionary if it is a recognised noun.]

Include (-

[ NounWord i j s;
    i = NextWord();
    if (i == 0) rfalse;
    if (i == ME1__WD or ME2__WD or ME3__WD) return 1;
!print "NounWord ";
    s = FluidLanguagePronouns-->0;
!print "nounword s ", s, " i ";
!print (dstring) i;
!print "^";
    for (j=1 : j<=s : j=j+3) {
!print "j ", j, "^";
!print (stringarray) FluidLanguagePronouns-->j;
!print "^----^";
!print FluidLanguagePronouns-->(j+1);
!print "^";
        if (streq(i, FluidLanguagePronouns-->j)) {
!print "streq eqd; returning ", j+2, "^";
!print (name) FluidLanguagepronouns-->(j+2);
            return j+2;
}
!print "streq false^";
}
    if ((i->#dict_par1)&128 == 0) rfalse;
    return i;
];

-) instead of "NounWord" in "Parser.i6t".

Part LanguagePronouns replacement

Use pronoun length of at least 10 translates as
(- Constant PronounLength = {N}; -).

Use number of pronouns of at least 5 translates as
(- Constant NumPronouns = {N}; -).

Use pronoun length of at least 6.
Use number of pronouns of at least 20.

Include (-

Array FluidLanguagePronouns table 3 * NumPronouns;
Array FluidLanguagePronounText -> ((PronounLength + 1) * NumPronouns);

! lengths must be <= 255...

[ LoadTable i j k;
 @mzero ((PronounLength + 1) * NumPronouns) FluidLanguagePronounText;
for (i = 0; i < NumPronouns; i++ ) {
  j = 3*i + 1;
print "loadtable j ", j, " --> ", (PronounLength + 1) * i, "^";
  FluidLanguagePronouns-->j = FluidLanguagePronounText + (PronounLength + 1) * i;
 print "FLP addr : ", FluidLanguagePronouns-->j, "^";
}
];

[ textToTable i txt
        raw len cp1 p1 j x len0;
  cp1 = txt-->0;
  p1 = TEXT_TY_Temporarily_Transmute(txt);
  raw = BlkValueLBCapacity(txt);
  x = FluidLanguagePronounText + (i*(PronounLength+1));
!print "text to table x: ", x, "^";
len0 = PronounLength + 1;
  @mzero len0 x;
  j = 0;
  while (raw = BlkValueRead(txt,j)) {
    FluidLanguagePronounText->((i*(PronounLength+1))+j+1) = raw;
!print "i: ", i, " FLPT addr ", FluidLanguagePronounText+(i*(PronounLength+1))+j+1, " val ", FluidLanguagePronounText->((i*(PronounLength+1))+j);
    j++;
  }
  FluidLanguagePronounText->(i*(PronounLength+1)) = j;
!print " len ", j, " to ", FluidLanguagePronounText->(i*(PronounLength+1)), "^";
  TEXT_TY_Untransmute(txt, p1, cp1);
];

[ getAntecedent i;
return FluidLanguagePronouns-->(i*3);
];

[ setAntecedent i obj;
  FluidLanguagePronouns-->(i*3) = obj;
];

[ dstring s j;
j = 1;
while (s->j) { print (char) s->j; j++; }
];

[ stringarray buf
i ;
  for (i=1:i<=buf->0:i++) print (char) buf->i;
];

[ sayTable i j x ;
for (i = 1; i < FluidLanguagePronouns-->0; i = i + 3 ) {
  print (stringarray) FluidLanguagePronouns-->i, "^";
}
];



-).

to set p-antecedent (n - a number) to (o - an object):
(- setAntecedent({n},{o}); -).    

to decide what thing is the p-antecedent for/-- (n - a number):
(- getAntecedent({n}); -).

to saytable: (- SayTable(); -).

to loadtable: (- LoadTable(); -).


to set table-entry (i - a number) with (t - a text):
    (- textToTable({i},{t}); -).

[
foo1 is initially "foo".
bar1 is initially "bar".

first when play begins:
   say "lt0.";
    loadtable;
    say "lt1.";
    set table-entry 1 with "strengths.";
    say "lt2.";
    set table-entry 2 with bar1;
    saytable;
    set table-entry 1 with foo1;
    saytable;
]

    
most-recent-reference-value is a kind of value. The most-recent-reference-values are pronominal and nominal.

A thing has a most-recent-reference-value called most recent reference.
The most recent reference of a thing is usually nominal.

Before printing the name of a thing (called item): now the most recent reference of the item is nominal.

A pronoun is a kind of object.

[ singular-named vs. plural-named:
  determines what grammatical number is used to conjugate corresponding verbs ]
A pronoun is usually singular-named. 

[ 1, 2, or 3. Only 3s' accusatives go into accusative-list ]
A pronoun has a number called the grammatical-person.

A third-person-personal-pronoun is a kind of pronoun.
The grammatical-person of third-person-personal-pronoun is usually 3.

[ corresponding to grammatical cases as defined in English Language and extended by Grammar Tests [TODO rename]:
  nominative, accusative, possessive, reflexive, possessive adjective,
  e.g., { "I", "me", "mine", "myself", "my" }. ]
A pronoun has a list of texts called the declensions. 

[ set neuter if antecedent can/should be referred to as "that"]
A pronoun can be neuter.

To decide what narrative viewpoint is the viewpoint of (p - a pronoun):
    let gnum be gn-singular;
    if p is plural-named, now gnum is gn-plural;
    decide on the viewpoint of grammatical-person of p and gnum.

Include (-
[ ANNOUNCE_PRONOUN_MEANINGS_R; ];
-) instead of "Announce Pronoun Meanings Rule" in "OutOfWorld.i6t".

The announce the pronoun meanings rule is not listed in any rulebook.

carry out requesting the pronoun meanings:
    say "At the moment, ";
    let l be a list of texts;
    repeat with i running from 1 to the number of entries in accusative-list begin;
      let ante be the p-antecedent for i;
[    say "[i] [entry i in accusative-list] [ante].";]
      if ante is not the null thing, add "[entry i in accusative-list] means [ante]" to l;
      else add "[entry i in accusative-list] is unset" to l;
[      if p relates to a thing by the pronoun-represents-thing relation, add "'[p]' means [thing to which p relates by the pronoun-represents-thing relation]" to l;
      else add "'[p]' is unset" to l;]
    end repeat;
    say l;
    say ".";

Include (-

! RegardingMarkedObjects, RegardingSingleObject, RegardingNumber from Gender Speedup by Nathanael Nerode

! Adds expresss implementation of RegardingMarkedObjects, eliminating costly features not used in English.
! Stops tracking prior_named_list_gender, which is dead code in English.

! Express implementation of "regarding marked objects" for English only.
! Don't track prior_named_list_gender, which is dead code in English.
! prior_named_list is only ever checked for >=2 in English, so stop counting at 2; avoids most of an entire object loop.

[ RegardingMarkedObjects
	obj;
	prior_named_list = 0;
	prior_named_noun = nothing;
	objectloop (obj ofclass Object && obj has workflag2) {
		prior_named_list++;
		if (prior_named_list == 1) {
			! Prior named noun is the *first* object in the list.
			prior_named_noun = obj;
		}
		if (prior_named_list == 2) break; ! This is all we need to know in English.
	}
	return;	
];

! Strip prior_named_list_gender tracking
[ RegardingSingleObject obj;
	prior_named_list = 1;
	prior_named_noun = obj;
];

! Strip prior_named_list_gender tracking
[ RegardingNumber n;
	prior_named_list = n;
	prior_named_noun = nothing;
];

[ PNToVP ; ! gna;
	if (prior_named_noun == player) return story_viewpoint;
    if (prior_named_list >= 2) return 6;
    if (prior_named_noun) {
      if ((prior_named_noun provides (+ most recent reference +)) && prior_named_noun.(+ most recent reference +) == (+ pronominal +)) {
        if (prior_named_noun.(+ third-singular-pronoun +) && prior_named_noun.(+ third-singular-pronoun +) has pluralname) return 6;
        return 3;
      }
      if (prior_named_noun has pluralname) return 6;
    }
	return 3;
];

[ PrintVerbAsValue vb;
	if (vb == 0) print "(no verb)";
	else { print "verb "; vb(1); }
];

[ VerbIsMeaningful vb;
	if ((vb) && (BlkValueCompare(vb(CV_MEANING), Rel_Record_0) ~= 0)) rtrue;
	rfalse;
];

[ VerbIsModal vb;
	if ((vb) && (vb(CV_MODAL))) rtrue;
	rfalse;
];

-) instead of "List Number and Gender" in "ListWriter.i6t".

Include (-
[ SetPronoun dword value;
  ((+ set-pronoun +) -->1)(dword, value);
];

[ PronounValue dword
i;
for (i = 1 : i < FluidLanguagePronouns-->0 : i = i + 2 ) 
  if (FluidLanguagePronouns-->i == dword)
    return FluidLanguagePronouns-->(i+1);
  return 0;  
];

[ ResetVagueWords obj; PronounNotice(obj); ];

[ PronounNotice obj;
  ((+ pronoun-notice +) -->1)(obj);
];

[ PronounNoticeHeldObjects x;
#IFNDEF MANUAL_PRONOUNS;
  objectloop(x in player) PronounNotice(x);
#ENDIF;
  x = 0; ! To prevent a "not used" error
  rfalse;
];

-) instead of "Pronoun Handling" in "Parser.i6t".

Include (-

! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Gender Speedup replacement for Parser.i6t: ScoreMatchL
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====

! We make only one change in this entire procedure, replacing
! PowersOfTwo_TB-->(GetGNAOfObject(obj)) with GetGNABitfield

Constant SCORE__CHOOSEOBJ = 1000;
Constant SCORE__IFGOOD = 500;
Constant SCORE__UNCONCEALED = 100;
Constant SCORE__BESTLOC = 60;
Constant SCORE__NEXTBESTLOC = 40;
Constant SCORE__NOTCOMPASS = 20;
Constant SCORE__NOTSCENERY = 10;
Constant SCORE__NOTACTOR = 5;
Constant SCORE__GNA = 1;
Constant SCORE__DIVISOR = 20;

Constant PREFER_HELD;
[ ScoreMatchL context its_owner its_score obj i j threshold met a_s l_s;
!   if (indef_type & OTHER_BIT ~= 0) threshold++;
    if (indef_type & MY_BIT ~= 0)    threshold++;
    if (indef_type & THAT_BIT ~= 0)  threshold++;
    if (indef_type & LIT_BIT ~= 0)   threshold++;
    if (indef_type & UNLIT_BIT ~= 0) threshold++;
    if (indef_owner ~= nothing)      threshold++;

    #Ifdef DEBUG;
    if (parser_trace >= 4) print "   Scoring match list: indef mode ", indef_mode, " type ",
      indef_type, ", satisfying ", threshold, " requirements:^";
    #Endif; ! DEBUG

    #ifdef PREFER_HELD;
    a_s = SCORE__BESTLOC; l_s = SCORE__NEXTBESTLOC;
    if (action_to_be == ##Take or ##Remove) {
        a_s = SCORE__NEXTBESTLOC; l_s = SCORE__BESTLOC;
    }
    context = context;  ! silence warning
    #ifnot;
    a_s = SCORE__NEXTBESTLOC; l_s = SCORE__BESTLOC;
    if (context == HELD_TOKEN or MULTIHELD_TOKEN or MULTIEXCEPT_TOKEN) {
        a_s = SCORE__BESTLOC; l_s = SCORE__NEXTBESTLOC;
    }
    #endif; ! PREFER_HELD

    for (i=0 : i<number_matched : i++) {
        obj = match_list-->i; its_owner = parent(obj); its_score=0; met=0;

        !      if (indef_type & OTHER_BIT ~= 0
        !          &&  obj ~= itobj or himobj or herobj) met++;
        if (indef_type & MY_BIT ~= 0 && its_owner == actor) met++;
        if (indef_type & THAT_BIT ~= 0 && its_owner == actors_location) met++;
        if (indef_type & LIT_BIT ~= 0 && obj has light) met++;
        if (indef_type & UNLIT_BIT ~= 0 && obj hasnt light) met++;
        if (indef_owner ~= 0 && its_owner == indef_owner) met++;

        if (met < threshold) {
            #Ifdef DEBUG;
            if (parser_trace >= 4)
              print "   ", (The) match_list-->i, " (", match_list-->i, ") in ",
                    (the) its_owner, " is rejected (doesn't match descriptors)^";
            #Endif; ! DEBUG
            match_list-->i = -1;
        }
        else {
            its_score = 0;
            if (obj hasnt concealed) its_score = SCORE__UNCONCEALED;

            if (its_owner == actor) its_score = its_score + a_s;
            else
                if (its_owner == actors_location) its_score = its_score + l_s;
                else
                    if (its_owner ~= compass) its_score = its_score + SCORE__NOTCOMPASS;

            its_score = its_score + SCORE__CHOOSEOBJ * ChooseObjects(obj, 2);

            if (obj hasnt scenery) its_score = its_score + SCORE__NOTSCENERY;
            if (obj ~= actor) its_score = its_score + SCORE__NOTACTOR;

            !   A small bonus for having a matching GNA,
            !   for sorting out ambiguous articles and the like.
            !   Patched by Gender Speedup by Nathanael Nerode.

            ! For this purpose, but *not* for pronouns, treat rooms, directions, 
            ! and other objects which lack the GNA attributes entirely,
            ! as inanimate neuter singular -- as the standard version does.

            ! Fixes debugging commands like GONEAR Room Name in the situation
            ! where there is also a thing with a similar name.

            ! Since rooms are only added to scope manually, should have little effect on gameplay.
            ! Directions are in scope, but SCORE__NOTCOMPASS is much larger than SCORE__GNA.
            ! Everything else in default scope to non-meta verbs is a thing with attributes.
! TODO: address.
!            j = GetGNABitfield(obj) || $$000000001000 ; ! 0 -> inanimate neuter singular
j = 0;
            if (indef_cases & j ) ! matched player's command on at least one GNA attribute
                its_score = its_score + SCORE__GNA;

            match_scores-->i = match_scores-->i + its_score;
            #Ifdef DEBUG;
            if (parser_trace >= 4) print "     ", (The) match_list-->i, " (", match_list-->i,
              ") in ", (the) its_owner, " : ", match_scores-->i, " points^";
            #Endif; ! DEBUG
        }
     }

    for (i=0 : i<number_matched : i++) {
        while (match_list-->i == -1) {
            if (i == number_matched-1) { number_matched--; break; }
            for (j=i : j<number_matched-1 : j++) {
                match_list-->j = match_list-->(j+1);
                match_scores-->j = match_scores-->(j+1);
            }
            number_matched--;
        }
    }
];


-) instead of "ScoreMatchL" in "Parser.i6t".

Section - Patch PrefaceByArticle

Include (-

! From Gender Speedup by Nathanael Nerode:

! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Gender Speedup replacement for Printing.i6t: Object Names II
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====

! We make only one small change: we remove the bit twiddling code which used GetGNAOfObject.

Global short_name_case;

[ PrefaceByArticle obj acode pluralise capitalise  i artform findout artval;
    if (obj provides articles) {
        artval=(obj.&articles)-->(acode+short_name_case*LanguageCases);
        if (capitalise)
            print (Cap) artval, " ";
        else
            print (string) artval, " ";
        if (pluralise) return;
        print (PSN__) obj; return;
    }

    i = pluralise || (obj has pluralname) || obj.(+ third-singular-pronoun +) has pluralname;
    
    artform = LanguageArticles
        + 3*WORDSIZE*LanguageContractionForms*(short_name_case + i*LanguageCases);

    #Iftrue (LanguageContractionForms == 2);
    if (artform-->acode ~= artform-->(acode+3)) findout = true;
    #Endif; ! LanguageContractionForms
    #Iftrue (LanguageContractionForms == 3);
    if (artform-->acode ~= artform-->(acode+3)) findout = true;
    if (artform-->(acode+3) ~= artform-->(acode+6)) findout = true;
    #Endif; ! LanguageContractionForms
    #Iftrue (LanguageContractionForms == 4);
    if (artform-->acode ~= artform-->(acode+3)) findout = true;
    if (artform-->(acode+3) ~= artform-->(acode+6)) findout = true;
    if (artform-->(acode+6) ~= artform-->(acode+9)) findout = true;
    #Endif; ! LanguageContractionForms
    #Iftrue (LanguageContractionForms > 4);
    findout = true;
    #Endif; ! LanguageContractionForms

    #Ifdef TARGET_ZCODE;
    if (standard_interpreter ~= 0 && findout) {
        StorageForShortName-->0 = 160;
        @output_stream 3 StorageForShortName;
        if (pluralise) print (number) pluralise; else print (PSN__) obj;
        @output_stream -3;
        acode = acode + 3*LanguageContraction(StorageForShortName + 2);
    }
    #Ifnot; ! TARGET_GLULX
    if (findout) {
        if (pluralise)
            Glulx_PrintAnyToArray(StorageForShortName, 160, EnglishNumber, pluralise);
        else
            Glulx_PrintAnyToArray(StorageForShortName, 160, PSN__, obj);
        acode = acode + 3*LanguageContraction(StorageForShortName);
    }
    #Endif; ! TARGET_

    Cap (artform-->acode, ~~capitalise); ! print article
    if (pluralise) return;
    print (PSN__) obj;
];

-) instead of "Object Names II" in "Printing.i6t".

Include (-
! From Gender Speedup by Nathanael Nerode:

! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Gender Speedup replacement for ListWriter.i6t: WriteListOfMarkedObjects
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
Global MarkedObjectArray = 0;
Global MarkedObjectLength = 0;

! Gender Speedup: remove calculation of prior_named_list_gender, which is dead code in English.

[ WriteListOfMarkedObjects style
	obj common_parent first mixed_parentage length;

	objectloop (obj ofclass Object && obj has workflag2) {
		length++;
		if (first == nothing) { first = obj; common_parent = parent(obj); }
		else { if (parent(obj) ~= common_parent) mixed_parentage = true; }
	}
	if (mixed_parentage) common_parent = nothing;

	if (length == 0) {
		if (style & ISARE_BIT ~= 0) LIST_WRITER_INTERNAL_RM('W');
		else if (style & CFIRSTART_BIT ~= 0) LIST_WRITER_INTERNAL_RM('X');
		else LIST_WRITER_INTERNAL_RM('Y');
	} else {
		@push MarkedObjectArray; @push MarkedObjectLength;
		MarkedObjectArray = RequisitionStack(length);
		MarkedObjectLength = length;
		if (MarkedObjectArray == 0) return RunTimeProblem(RTP_LISTWRITERMEMORY); 

		if (common_parent) {
			ObjectTreeCoalesce(child(common_parent));
			length = 0;
			objectloop (obj in common_parent) ! object tree order
				if (obj has workflag2) MarkedObjectArray-->length++ = obj;
		} else {
			length = 0;
			objectloop (obj ofclass Object) ! object number order
				if (obj has workflag2) MarkedObjectArray-->length++ = obj;
		}

		WriteListFrom(first, style, 0, false, MarkedListIterator);

		FreeStack(MarkedObjectArray);
		@pull MarkedObjectLength; @pull MarkedObjectArray;
	}
	prior_named_list = length;
	return;
];

-) instead of "WriteListOfMarkedObjects" in "ListWriter.i6t".


I-pronoun is a pronoun.
The grammatical-person of I-pronoun is 1.
The declensions of I-pronoun are { "I", "me", "mine", "myself", "my" }.

We-pronoun is a pronoun.
The grammatical-person of we-pronoun is 1.
We-pronoun is plural-named.
The declensions of we-pronoun are { "we", "us", "ours", "ourselves", "our" }.

It-pronoun is a pronoun.
It-pronoun is neuter.
The grammatical-person of it-pronoun is 3.
The declensions of it-pronoun are { "it", "it", "its", "itself", "its" }.

He-pronoun is a pronoun.
The grammatical-person of he-pronoun is 3.
The declensions of he-pronoun are { "he", "him", "his", "himself", "his" }.

She-pronoun is a pronoun.
The grammatical-person of she-pronoun is 3.
The declensions of she-pronoun are { "she", "her", "hers", "herself", "her" }.

Singular-you-pronoun is a pronoun.
The grammatical-person of singular-you-pronoun is 2.
The declensions of singular-you-pronoun are { "you", "you", "yours", "yourself", "your" }.

Plural-you-pronoun is a pronoun.
The grammatical-person of plural-you-pronoun is 2.
Plural-you-pronoun is plural-named.
The declensions of plural-you-pronoun are { "you", "you", "yours", "yourselves", "our" }.

They-pronoun is a pronoun.
The grammatical-person of they-pronoun is 3.
They-pronoun is plural-named.
The declensions of They-pronoun are { "they", "them", "theirs", "themselves", "their" }.

Singular-they-pronoun is a pronoun.
The grammatical-person of singular-they-pronoun is 3.
Singular-they-pronoun is plural-named.
The declensions of singular-they-pronoun are { "they", "them", "theirs", "themself", "their" }.

[Pronounless-3 is a pronoun.
The grammatical-person of Pronounless-3 is 3.
The declensions of Pronounless-3 are { "[printed name of prior named object]", "[printed name of prior named object]", "[possessive]", "[printed name of prior named object]", "[possessive]" }.]

An object has a pronoun called the third-singular-pronoun.
The third-singular-pronoun of an object is usually it-pronoun.

A thing has a pronoun called the third-plural-pronoun.
The third-plural-pronoun of a thing is usually they-pronoun.

A person has a pronoun called the first-singular-pronoun.
The first-singular-pronoun of a person is usually I-pronoun.
A person has pronoun called the first-plural-pronoun.
The first-plural-pronoun of a person is usually we-pronoun.
A person has pronoun called the second-singular-pronoun.
The second-singular-pronoun of a person is usually singular-you-pronoun.
A person has pronoun called the second-plural-pronoun.
The second-plural-pronoun of a person is usually plural-you-pronoun.
The third-singular-pronoun of a person is usually singular-they-pronoun.

[ These are defaults and can be over-ridden as desired ]
The third-singular-pronoun of a man is usually he-pronoun.
The third-singular-pronoun of a woman is usually she-pronoun.

To decide what text is the (gc - a grammatical case) declension of (p - a pronoun):
    decide on entry (gc cast as a number) in (the declensions of p).

To decide what text is the (nv - a narrative viewpoint) pronoun in a/an/-- (gc - a grammatical case) case/--:
  if nv is first person singular, decide on the gc declension of the first-singular-pronoun of the prior named object;
  if nv is first person plural, decide on the gc declension of the first-plural-pronoun of the prior named object;
  if nv is second person singular, decide on the gc declension of the second-singular-pronoun of the prior named object;
  if nv is second person plural, decide on the gc declension of the second-plural-pronoun of the prior named object;
  if nv is third person singular, decide on the gc declension of the third-singular-pronoun of the prior named object;
  if nv is third person plural, decide on the gc declension of the third-plural-pronoun of the prior named object;

To decide what text is the (gc - a grammatical case) pronoun of (p - a person):
  now the prior named object is p;
  if p is the player, decide on the story viewpoint pronoun in gc case;

To decide what text is the (gc - a grammatical case) viewpoint pronoun:
[now the prior named object is the player;]
[say "prior named object: [prior named object].";
say "the story viewpoint pronoun in gc case: [the story viewpoint pronoun in gc case].";]
decide on the story viewpoint pronoun in gc case;

To decide what text is the (nv - a narrative viewpoint) pronoun in a/an/-- (gc - a grammatical case) case/-- for/of (p - a person):
  if nv is first person singular, decide on the gc declension of the first-singular-pronoun of the prior named object;
  if nv is first person plural, decide on the gc declension of the first-plural-pronoun of the prior named object;
  if nv is second person singular, decide on the gc declension of the second-singular-pronoun of the prior named object;
  if nv is second person plural, decide on the gc declension of the second-plural-pronoun of the prior named object;
  if nv is third person singular, decide on the gc declension of the third-singular-pronoun of the prior named object;
  if nv is third person plural, decide on the gc declension of the third-plural-pronoun of the prior named object;


Procede is a text based rulebook producing a text.
The procede rules have default success.
Procede rulebook has an object called the antecedent.
Procede rulebook has a grammatical-number called the context.

Procede "we" [when the antecedent is the player]:
  rule succeeds with result story viewpoint pronoun in nominative case for player;

Procede "us" [when the antecedent is the player]:
  rule succeeds with result story viewpoint pronoun in accusative case for player;

Procede "our" [when the antecedent is the player]:
  rule succeeds with result story viewpoint pronoun in possessive adjective case for player;

Procede "ours" [when the antecedent is the player]:
  rule succeeds with result story viewpoint pronoun in possessive case for player;

Procede "ourselves" [when the antecedent is the player]:
  rule succeeds with result story viewpoint pronoun in reflexive case for player;

Procede "they" when the context is gn-plural:
  rule succeeds with result "they".

Procede "they" when the antecedent is the player:
  abide by the procede rules for "we";

Procede "they" when the antecedent is a person:
  rule succeeds with result nominative declension of the third-singular-pronoun of the antecedent;

Procede "them" when the context is gn-plural:
  rule succeeds with result "them".

Procede "them" when the antecedent is the player:
  abide by the procede rules for "us";

Procede "them" when the antecedent is a person:
  rule succeeds with result accusative declension of the third-singular-pronoun of the antecedent;

Procede "theirs" when the context is gn-plural:
  rule succeeds with result "theirs".

Procede "theirs" when the antecedent is the player:
  abide by the procede rules for "ours";

Procede "theirs" when the antecedent is a person:
  rule succeeds with result possessive declension of the third-singular-pronoun of the antecedent;

Procede "their" when the context is gn-plural:
  rule succeeds with result "their".

Procede "their" when the antecedent is the player:
  abide by the procede rules for "our";

Procede "their" when the antecedent is a person:
  rule succeeds with result possessive adjective declension of the third-singular-pronoun of the antecedent;

Procede "themselves" when the context is gn-plural:
  rule succeeds with result "themselves".

Procede "themselves" when the antecedent is the player:
  abide by the procede rules for "ourselves".

Procede "themselves" when the antecedent is a person:
  rule succeeds with result reflexive declension of the third-singular-pronoun of the antecedent.

[ for "those"/"Those" we provide separate rules because lower case is accusative
  and upper case is nominative ]
  
Procede "those" when the context is gn-plural: rule succeeds with result "those".

Procede "those" when the antecedent is the player:
    abide by the procede rules for "we".

Procede "those" when the third-singular-pronoun of the antecedent is neuter:
    rule succeeds with result "that".

Procede "those": rule succeeds with result the accusative declension of the third-singular-pronoun of the antecedent.

Procede "Those" when the context is gn-plural: rule succeeds with result "Those".

Procede "Those" when the antecedent is the player:
    abide by the procede rules for "us";

Procede "Those" when the third-singular-pronoun of the antecedent is neuter:
    rule succeeds with result "That".

Procede "Those":
    rule succeeds with result the nominative declension of the third-singular-pronoun of the antecedent.

Procede text (called the arg) (this is the setup procede rule):
if the arg is "we" or the arg is "us" or the arg is "our" or the arg is "ours" or the arg is "ourselves", now the prior named object is the player;
now the most recent reference of the prior named object is pronominal;
now the antecedent is the prior named object;
now the context is gn-singular;
if the prior naming context is plural, now the context is gn-plural;
continue the action;

The setup procede rule is listed first in the procede rules.
    
To decide what text is pronoun of/for/-- a/an/-- (p - a text):
    let result be text produced by the procede rules for p in lower case;
    decide on result;
    
Volume English Language substitutions

Section 2 - Viewpoint pronouns (in place of Section 2 - Saying pronouns in English Language by Graham Nelson)

To say we: say pronoun "we".
To say We: say (pronoun "we") in title case.
To say us: say pronoun "us".
To say Us: say (pronoun "us") in title case.
To say ours: say pronoun "ours".
To say Ours: say (pronoun "ours") in title case.
To say ourselves: say pronoun "ourselves".
To say Ourselves: say (pronoun "ourselves") in title case.
To say our: say pronoun "our".
To say Our: say (pronoun "our") in title case.

Section 3 - Further pronouns (in place of Section 3 - Further pronouns in English Language by Graham Nelson)

To say they: say pronoun "they".
To say They: say (pronoun "they") in title case.
To say them: say pronoun "them".
To say Them: say (pronoun "them") in title case.
To say their: say pronoun "their".
To say Their: say (pronoun "their") in title case.
To say themselves: say pronoun "themselves".
To say Themselves: say (pronoun "themselves") in title case.
To say theirs: say pronoun "theirs".
To say Theirs: say (pronoun "theirs") in title case.
To say those: say pronoun "those".
To say Those: say pronoun "Those".

To say they're: if the third-singular-pronoun of the prior named object is neuter, say "that";
else say pronoun "they";
say 're.

To say They're: say "[they're]" in title case.



To say it: say "[regarding nothing]it".

To say It: say "[regarding nothing]It".

To say there: say "[regarding nothing]there".

To say There: say "[regarding nothing]There".

To say it's: say "[regarding nothing]it['re]".

To say It's: say "[regarding nothing]It['re]".

To say there's: say "[regarding nothing]there['re]".

To say There's: say "[regarding nothing]There['re]".

To decide what text is the possessive-text:
  if the prior naming context is plural, decide on "[the prior named object][apostrophe]";
  if the prior named object is the player, decide on the possessive adjective pronoun of the player;
  decide on "[the prior named object][apostrophe]s";

To say possessive: say possessive-text;

To say Possessive: say possessive-text in title case.


volume initialization

accusative-list is a list of texts that varies.
animate-list is a list of texts that varies.
To say (p - a pronoun):
  say declensions of p;

[ really one text, but I7 has a bug with one to various relations ]
accusative-to-pronoun-list relates various texts to various pronouns. 
the verb to pronate means the accusative-to-pronoun-list relation.

to decide what number is the max pronoun length: (- PronounLength -).
to decide what number is the max number of pronouns: (- NumPronouns -).

[ TODO: do we need to separate singular and plural ? ]
to initialize-pronouns:
    now animate-list is {};
    repeat with p running through other people begin;
      add the accusative declension of the third-singular-pronoun of p to animate-list, if absent;
    end repeat;
    now accusative-list is {};
    repeat with p running through pronouns begin;
[      say "considering p [p]";
      say line break;]
      if the grammatical-person of p is not 3, next;
[      say "... was 3, continuing.";]
      let acc be the (accusative declension of p);
[      say "considering acc [acc]: ";]
      if acc [the accusative declension of p] is unsubstituted, next;
[      say "wasn't unsubstituted, continuing.";]
      if the number of characters in acc > max pronoun length begin;
        say "**Fatal Error: pronoun [acc] exceeds pronoun length option of [max pronoun length].";
        end the story finally;
      end if;
[      say "now [acc] pronates [p].";]
      now acc pronates p;
      add acc to accusative-list, if absent;
      if the number of entries in accusative-list > max number of pronouns begin;
        say "**Fatal Error: pronoun [acc] would exceeds max pronouns of [max number of pronouns].";
        end the story finally;
      end if;
    end repeat;
loadtable;
    let acc-ind be 0;
    repeat with acc-pronoun running through accusative-list begin;
      set table-entry acc-ind with acc-pronoun;
      increment acc-ind;
    end repeat;
    say "initted.";
    saytable;

Book asr (for use with Alternative Startup Rules by Dannii Willis)

Last after starting the virtual machine: initialize-pronouns.

Book no-asr (for use without Alternative Startup Rules by Dannii Willis)

First when play begins: initialize-pronouns.

Volume acc-test

[ if the thing is plural, we must look to its third-plural;
otherwise we must look at its third-singular ]
To decide if (t - a thing) is a candidate for (pronoun-text - a text):
    if t is plural-named and third-plural-pronoun of t is listed in the list of pronouns to which pronoun-text relates by the accusative-to-pronoun-list relation, yes;
if third-singular-pronoun of t is listed in the list of pronouns to which pronoun-text relates by the accusative-to-pronoun-list relation, yes;
no;

[pronoun-represents-thing relates various texts to one thing.
The verb to pronoun-represent means the pronoun-represents-thing relation.]

parser-word is initially "".

to decide what number is the accusative index of (t - a text):
    let result be 0;
    repeat with i running from 1 to (the number of entries in accusative-list) begin;
      if the substituted form of t is entry i in accusative-list begin;
        now result is i;
        break;
      end if;
    end repeat;
  decide on result;

[TODO: when you set a pronoun, unset other pronouns that might have the same value ]
[ SetPronoun]
To set (pronoun-text - a text) to (item - a thing) (this is set-pronoun):
    let acc-ind be accusative index of pronoun-text;
    if acc-ind > 0, set p-antecedent acc-ind to item;

[ TODO: I7 existing behavior leaves pronouns set even when you're now in a different room.
  probably better to change that. ]
[ PronounNotice ]
To pronoun notice (t - a thing) (this is pronoun-notice):
  unless t is the player begin;
    if t is plural-named or t is ambiguously plural, set the accusative declension of the third-plural-pronoun of t to t;
    if t is singular-named, set the accusative declension of the third-singular-pronoun of t to t;
  end unless;

Fluid Pronouns ends here.

---- documentation ----

Chapter Examples

Section Pronoun

Example: * Pronoun


	"pronoun" by Zed Lopez
	
	Include Fluid Pronouns by Zed Lopez.
	
	Use the serial comma.
	
	Lab is a room.
	The Conservatory is north of the lab.
	The desk is a supporter in the conservatory.
	
	The pile of girders is a plural-named thing in the lab.
	
	To stop is a verb.
	To feel is a verb.
	
	Sam is a person in the lab.
	Alice is a woman in the lab.
	Bob is a man in the lab.
	Murderbot is a person in the lab.
	The third-singular-pronoun of Murderbot is it-pronoun.
	
	[Ogg is a person in the lab.
	The third-singular-pronoun of Ogg is pronounless-3.]
	
	ze-pronoun is a third-person-personal-pronoun.
	The declensions of ze-pronoun are { "ze", "zim", "zirs", "zirself", "zir" }.
	understand "zim" as "[ze-pronoun]". [ could just as well be a dummy thing, but don't let it be a potentially in-scope object. ]
	
	Star is a person in the lab.
	The third-singular-pronoun of Star is ze-pronoun.
	
	definition: a thing is other if it is not the player.
	
	A person can be bobandalice.
	Bob is bobandalice.
	Alice is bobandalice.
	
	Qbert is a person in the lab.
	
	when play begins:
	  say "No one gave [us] a gift, so [we]['re] going to give [ourselves] a present for [our] birthday and once delivered to [us] it will be [ours].";
	  repeat with p running through [other] people in the lab begin;
	    say "([p]) No one gave [regarding p][them] a gift, so [they]['re] going to give [themselves] a present for [their] birthday and once delivered to [them] it will be [theirs].";
	  end repeat;
	  say "(Bob and Alice) No one gave [regarding bobandalice people][them] a gift, so [they]['re] going to give [themselves] a present for [their] birthday and once delivered to [them] it will be [theirs].";
	  say "[regarding Sam][They] [stop] walking when [Sam] [feel] like it.";
	  say "[Sam] [stop] walking when [they] [feel] like it.";
	
	Test me with "pronouns / touch it / touch them / touch him / touch her / touch zim".
