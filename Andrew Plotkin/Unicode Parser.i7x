Version 7 of Unicode Parser (for Glulx only) by Andrew Plotkin begins here.

[Modernized for 6K92.]

[Tell the I6 compiler to generate a dictionary containing Unicode values rather than 8-bit characters. This requires I6 version 6.32 or later.]
Use DICT_CHAR_SIZE of 4.

[Change the three buffer arrays from length/byte format to simple word arrays.]
Include (-
Array gg_event --> 4;
Array gg_arguments buffer 28;
Global gg_mainwin = 0;
Global gg_statuswin = 0;
Global gg_quotewin = 0;
Global gg_scriptfref = 0;
Global gg_scriptstr = 0;
Global gg_savestr = 0;
Global gg_commandstr = 0;
Global gg_command_reading = 0;      ! true if gg_commandstr is being replayed
Global gg_foregroundchan = 0;
Global gg_backgroundchan = 0;

Constant INPUT_BUFFER_LEN = 260;    ! No extra byte necessary
Constant MAX_BUFFER_WORDS = 20;
Constant PARSE_BUFFER_LEN = 61;

! The buffer arrays have "table" structure, but we're going to be writing to
! entry zero a lot, so we just use word arrays.
Array  buffer    --> INPUT_BUFFER_LEN+1;
Array  buffer2   --> INPUT_BUFFER_LEN+1;
Array  buffer3   --> INPUT_BUFFER_LEN+1;
Array  parse     --> PARSE_BUFFER_LEN;
Array  parse2    --> PARSE_BUFFER_LEN;
-) instead of "Variables and Arrays" in "Glulx.i6t".


[I am Replacing VM_ReadKeyboard, rather than using a template replacement, because the "Keyboard Input" section has three functions and I only want to touch one of them.

Replacing functions in a one-file I6 program can be problematic, if the function is recursive or if it's invoked before the second definition occurs. The usage here is okay! But when something goes mysteriously wrong, come back here and look to make sure that's still true.]

Include (-
Replace VM_ReadKeyboard;
-) before "Glulx.i6t".

Include (-
! Modified VM_ReadKeyboard to read into a word array, rather than a byte array.

[ VM_ReadKeyboard  a_buffer a_table done ix;
    if (gg_commandstr ~= 0 && gg_command_reading ~= false) {
        done = glk_get_line_stream_uni(gg_commandstr, a_buffer+WORDSIZE,
            (INPUT_BUFFER_LEN-1)-1);
        if (done == 0) {
            glk_stream_close(gg_commandstr, 0);
            gg_commandstr = 0;
            gg_command_reading = false;
        }
        else {
            ! Trim the trailing newline
            if ((a_buffer+WORDSIZE)-->(done-1) == 10) done = done-1;
            a_buffer-->0 = done;
            VM_Style(INPUT_VMSTY);
            glk_put_buffer_uni(a_buffer+WORDSIZE, done);
            VM_Style(NORMAL_VMSTY);
            print "^";
            jump KPContinue;
        }
    }
    done = false;
    glk_request_line_event_uni(gg_mainwin, a_buffer+WORDSIZE, INPUT_BUFFER_LEN-1, 0);
    while (~~done) {
        glk_select(gg_event);
        switch (gg_event-->0) {
          5: ! evtype_Arrange
            DrawStatusLine();
          3: ! evtype_LineInput
            if (gg_event-->1 == gg_mainwin) {
                a_buffer-->0 = gg_event-->2;
                done = true;
            }
        }
        ix = HandleGlkEvent(gg_event, 0, a_buffer);
        if (ix == 2) done = true;
        else if (ix == -1) done = false;
    }
    if (gg_commandstr ~= 0 && gg_command_reading == false) {
        glk_put_buffer_stream(gg_commandstr, a_buffer+WORDSIZE, a_buffer-->0);
        glk_put_char_stream(gg_commandstr, 10); ! newline
    }
  .KPContinue;
    VM_Tokenise(a_buffer,a_table);
    ! It's time to close any quote window we've got going.
    if (gg_quotewin) {
        glk_window_close(gg_quotewin, 0);
        gg_quotewin = 0;
    }
    #ifdef ECHO_COMMANDS;
    print "** ";
    for (ix=0: ix<(a_buffer-->0): ix++) print (char) a_buffer-->(1+ix);
    print "^";
    #endif; ! ECHO_COMMANDS
];

-) after "Keyboard Input" in "Glulx.i6t".


Include (-
[ VM_CopyBuffer bto bfrom i;
    for (i=0: i<INPUT_BUFFER_LEN: i++) bto-->i = bfrom-->i;
];

! Prints an object (string, function, etc) to a buffer whose format is like
! the input buffer: a word array whose zeroth entry is the length (in
! characters). Do not use this with a byte array.
[ VM_PrintToBuffer buf len a b c;
    if (b) {
        if (metaclass(a) == Object && a.#b == WORDSIZE
            && metaclass(a.b) == String)
            buf-->0 = Glulx_PrintAnyToArrayUni(buf+WORDSIZE, len, a.b);
        else if (metaclass(a) == Routine)
            buf-->0 = Glulx_PrintAnyToArrayUni(buf+WORDSIZE, len, a, b, c);
        else
            buf-->0 = Glulx_PrintAnyToArrayUni(buf+WORDSIZE, len, a, b);
    }
    else if (metaclass(a) == Routine)
        buf-->0 = Glulx_PrintAnyToArrayUni(buf+WORDSIZE, len, a, b, c);
    else
        buf-->0 = Glulx_PrintAnyToArrayUni(buf+WORDSIZE, len, a);
    if (buf-->0 > len) buf-->0 = len;
    return buf-->0;
];

Constant LOWERCASE_BUF_SIZE = 2*DICT_WORD_SIZE;
Array gg_lowercasebuf --> LOWERCASE_BUF_SIZE;

! Tokenise the buffer, which is now a word array.
! Entries written into the parse table are measured in characters,
! not bytes.
[ VM_Tokenise buf tab
    cx numwords len bx ix wx wpos wlen val res dictlen ch bytesperword uninormavail;
    len = buf-->0;
    buf = buf+WORDSIZE;

    ! First, split the buffer up into words. We use the standard Infocom
    ! list of word separators (comma, period, double-quote).

    cx = 0;
    numwords = 0;
    while (cx < len) {
        while (cx < len && buf-->cx == ' ') cx++;
        if (cx >= len) break;
        bx = cx;
        if (buf-->cx == '.' or ',' or '"') cx++;
        else {
            while (cx < len && buf-->cx ~= ' ' or '.' or ',' or '"') cx++;
        }
        tab-->(numwords*3+2) = (cx-bx);
        tab-->(numwords*3+3) = 1+bx;
        numwords++;
        if (numwords >= MAX_BUFFER_WORDS) break;
    }
    tab-->0 = numwords;

    ! Now we look each word up in the dictionary.

    dictlen = #dictionary_table-->0;
    bytesperword = DICT_WORD_SIZE * DICT_CHAR_SIZE;
    uninormavail = glk($0004, 16, 0);

    for (wx=0 : wx<numwords : wx++) {
        wlen = tab-->(wx*3+2);
        wpos = tab-->(wx*3+3);

        ! Copy the word into the gg_tokenbuf array, clipping to DICT_WORD_SIZE
        ! characters and lower case. We'll do this in two steps, because
        ! lowercasing might (theoretically) condense characters and allow more
        ! to fit into gg_tokenbuf.
        if (wlen > LOWERCASE_BUF_SIZE) wlen = LOWERCASE_BUF_SIZE;
        cx = wpos - 1;
        for (ix=0 : ix<wlen : ix++) {
            ch = buf-->(cx+ix);
            gg_lowercasebuf-->ix = ch;
        }
        wlen = glk_buffer_to_lower_case_uni(gg_lowercasebuf, LOWERCASE_BUF_SIZE, wlen);
        if (uninormavail) {
            ! Also normalize the Unicode -- combine accent marks with letters
            ! where possible.
            wlen = glk($0124, gg_lowercasebuf, LOWERCASE_BUF_SIZE, wlen); ! buffer_canon_normalize_uni
        }
        if (wlen > DICT_WORD_SIZE) wlen = DICT_WORD_SIZE;
        for (ix=0 : ix<wlen : ix++) {
            gg_tokenbuf-->ix = gg_lowercasebuf-->ix;
        }
        for (: ix<DICT_WORD_SIZE : ix++) gg_tokenbuf-->ix = 0;

        val = #dictionary_table + WORDSIZE;
        @binarysearch gg_tokenbuf bytesperword val DICT_ENTRY_BYTES dictlen 4 1 res;
        tab-->(wx*3+1) = res;
    }
];

! Insert a character into the (global) buffer array.
! (See DM4 appendix A3.)
[ LTI_Insert i ch  b y;

    ! In the original code, buffer was a funny array type. Now it isn't,
    ! but I am minimizing code changes, so we'll keep this alias.
    b = buffer;

    ! Insert character ch into buffer at point i.
    ! Being careful not to let the buffer possibly overflow:
    y = b-->0;
    if (y > INPUT_BUFFER_LEN) y = INPUT_BUFFER_LEN;

    ! Move the subsequent text along one character:
    for ( y=y+1 : y>i : y-- ) b-->y = b-->(y-1);
    b-->i = ch;

    ! And the text is now one character longer:
    if (b-->0 < INPUT_BUFFER_LEN) (b-->0)++;
];
-) instead of "Buffer Functions" in "Glulx.i6t".


Include (-

! Unchanged.
[ VM_InvalidDictionaryAddress addr;
    if (addr < 0) rtrue;
    rfalse;
];

! Unchanged.
[ VM_DictionaryAddressToNumber w; return w; ];
[ VM_NumberToDictionaryAddress n; return n; ];

! Now a word array, to match the buffer.
Array gg_tokenbuf --> DICT_WORD_SIZE;

! Updated for word-array buffer.
[ GGWordCompare str1 str2 ix jx;
    for (ix=0 : ix<DICT_WORD_SIZE : ix++) {
        jx = (str1-->ix) - (str2-->ix);
        if (jx ~= 0) return jx;
    }
    return 0;
];

-) instead of "Dictionary Functions" in "Glulx.i6t".

Include (-

! Like Glulx_PrintAnyToArray, but it writes to a word array. Returns
! the number of characters printed. (If the text printed is longer than
! the array, the extra characters are safely dropped rather than overflowing
! the array; they are still counted in the returned count.)
[ Glulx_PrintAnyToArrayUni _vararg_count arr arrlen str oldstr len;
    @copy sp arr;
    @copy sp arrlen;
    _vararg_count = _vararg_count - 2;

    oldstr = glk_stream_get_current();
    str = glk_stream_open_memory_uni(arr, arrlen, 1, 0);
    if (str == 0) return 0;

    glk_stream_set_current(str);

    @call Glulx_PrintAnything _vararg_count 0;

    glk_stream_set_current(oldstr);
    @copy $ffffffff sp;
    @copy str sp;
    @glk $0044 2 0; ! stream_close
    @copy sp len;
    @copy sp 0;
    return len;
];

-) after "Glulx-Only Printing Routines" in "Glulx.i6t".


[I am Replacing WordAddress rather than using a template replacement, because it's just one tiny function. See caveat above.]

Include (-
Replace WordAddress;
-) before "Words" in "Parser.i6t".

Include (-

! WordAddress returns the address of the beginning of the word. Thus,
! the first letter is WordAddress(n)-->0, and the last letter is
! WordAddress(n)-->(WordLength(n)-1).
[ WordAddress wordnum; return buffer + WORDSIZE * parse-->(wordnum*3); ];

-) after "Words" in "Parser.i6t".

Include (-

! Updated to support word-array buffer.
[ PrintSnippet snip from to i w1 w2;
    w1 = snip/100; w2 = w1 + (snip%100) - 1;
    if ((w2<w1) || (w1<1) || (w2>WordCount())) {
        if ((w1 == 1) && (w2 == 0)) rfalse;
        return RunTimeProblem(RTP_SAYINVALIDSNIPPET, w1, w2);
    }
    from = WordAddress(w1); to = WordAddress(w2) + WORDSIZE * WordLength(w2);
    for (i=from: i<to: i=i+4) print (char) i-->0;
];

! Updated to support word-array buffer.
[ SpliceSnippet snip t i w1 w2 nextw at endsnippet newlen;
    w1 = snip/100; w2 = w1 + (snip%100) - 1;
    if ((w2<w1) || (w1<1)) {
        if ((w1 == 1) && (w2 == 0)) return;
        return RunTimeProblem(RTP_SPLICEINVALIDSNIPPET, w1, w2);
    }
    @push say__p; @push say__pc;
    nextw = w2 + 1;
    at = (WordAddress(w1) - buffer) / WORDSIZE;
    if (nextw <= WordCount()) endsnippet = 100*nextw + (WordCount() - nextw + 1);
    buffer2-->0 = INPUT_BUFFER_LEN;
    newlen = VM_PrintToBuffer(buffer2, INPUT_BUFFER_LEN, SpliceSnippet__TextPrinter, t, endsnippet);
    for (i=0: (i<newlen) && (at+i<INPUT_BUFFER_LEN): i++) buffer-->(at+i) = buffer2-->(1+i);
    buffer-->0 = at+i;
    for (:at+i<INPUT_BUFFER_LEN:i++) buffer-->(at+i) = ' ';
    VM_Tokenise(buffer, parse);
    players_command = 100 + WordCount();
    @pull say__pc; @pull say__p;
];

! Unchanged.
[ SpliceSnippet__TextPrinter t endsnippet;
    TEXT_TY_Say(t);
    if (endsnippet) { print " "; PrintSnippet(endsnippet); }
];

! Unchanged.
[ SnippetIncludes test snippet w1 w2 wlen i j;
    w1 = snippet/100; w2 = w1 + (snippet%100) - 1;
    if ((w2<w1) || (w1<1)) {
        if ((w1 == 1) && (w2 == 0)) rfalse;
        return RunTimeProblem(RTP_INCLUDEINVALIDSNIPPET, w1, w2);
    }
    if (metaclass(test) == Routine) {
        wlen = snippet%100;
        for (i=w1, j=wlen: j>0: i++, j-- ) {
            if (((test)(i, 0)) ~= GPR_FAIL) return i*100+wn-i;
        }
    }
    rfalse;
];

! Unchanged.
[ SnippetMatches snippet topic_gpr rv;
    wn=1;
    if (topic_gpr == 0) rfalse;
    if (metaclass(topic_gpr) == Routine) {
        rv = (topic_gpr)(snippet/100, snippet%100);
        if (rv ~= GPR_FAIL) rtrue;
        rfalse;
    }
    RunTimeProblem(RTP_BADTOPIC);
    rfalse;
];

-) instead of "Snippets" in "Parser.i6t".

Include (-

! Rather than replace the definition of the oops_workspace array, we just
! create a new one.
Constant OOPS_WORKSPACE_SIZE 64;
Array oops_workspace_uni --> OOPS_WORKSPACE_SIZE;

! Modified to use oops_workspace_uni instead of oops_workspace. No other changes.
[ Keyboard  a_buffer a_table  nw i w w2 x1 x2;
    sline1 = score; sline2 = turns;

    while (true) {
        ! Save the start of the buffer, in case "oops" needs to restore it
        for (i=0 : i<OOPS_WORKSPACE_SIZE : i++) oops_workspace_uni-->i = a_buffer-->i;
    
        ! In case of an array entry corruption that shouldn't happen, but would be
        ! disastrous if it did:
        #Ifdef TARGET_ZCODE;
        a_buffer->0 = INPUT_BUFFER_LEN;
        a_table->0 = 15;  ! Allow to split input into this many words
        #Endif; ! TARGET_
    
        ! Print the prompt, and read in the words and dictionary addresses
        PrintPrompt();
        DrawStatusLine();
        KeyboardPrimitive(a_buffer, a_table);
    
        ! Set nw to the number of words
        #Ifdef TARGET_ZCODE; nw = a_table->1; #Ifnot; nw = a_table-->0; #Endif;
    
        ! If the line was blank, get a fresh line
        if (nw == 0) {
            @push etype; etype = BLANKLINE_PE;
            players_command = 100;
            BeginActivity(PRINTING_A_PARSER_ERROR_ACT);
            if (ForActivity(PRINTING_A_PARSER_ERROR_ACT) == false) {
              PARSER_ERROR_INTERNAL_RM('X', noun); new_line;
            }
            EndActivity(PRINTING_A_PARSER_ERROR_ACT);
            @pull etype;
            continue;
        }
    
        ! Unless the opening word was OOPS, return
        ! Conveniently, a_table-->1 is the first word on both the Z-machine and Glulx
    
        w = a_table-->1;
        if (w == OOPS1__WD or OOPS2__WD or OOPS3__WD) {
            if (oops_from == 0) { PARSER_COMMAND_INTERNAL_RM('A'); new_line; continue; }
            if (nw == 1) { PARSER_COMMAND_INTERNAL_RM('B'); new_line; continue; }
            if (nw > 2) { PARSER_COMMAND_INTERNAL_RM('C'); new_line; continue; }
        
            ! So now we know: there was a previous mistake, and the player has
            ! attempted to correct a single word of it.
        
            for (i=0 : i<INPUT_BUFFER_LEN : i++) buffer2-->i = a_buffer-->i;
            #Ifdef TARGET_ZCODE;
            x1 = a_table->9;  ! Start of word following "oops"
            x2 = a_table->8;  ! Length of word following "oops"
            #Ifnot; ! TARGET_GLULX
            x1 = a_table-->6; ! Start of word following "oops"
            x2 = a_table-->5; ! Length of word following "oops"
            #Endif; ! TARGET_
        
            ! Repair the buffer to the text that was in it before the "oops"
            ! was typed:
            for (i=0 : i<OOPS_WORKSPACE_SIZE : i++) a_buffer-->i = oops_workspace_uni-->i;
            VM_Tokenise(a_buffer,a_table);
        
            ! Work out the position in the buffer of the word to be corrected:
            #Ifdef TARGET_ZCODE;
            w = a_table->(4*oops_from + 1); ! Start of word to go
            w2 = a_table->(4*oops_from);    ! Length of word to go
            #Ifnot; ! TARGET_GLULX
            w = a_table-->(3*oops_from);      ! Start of word to go
            w2 = a_table-->(3*oops_from - 1); ! Length of word to go
            #Endif; ! TARGET_
        
            ! Write spaces over the word to be corrected:
            for (i=0 : i<w2 : i++) a_buffer-->(i+w) = ' ';
        
            if (w2 < x2) {
                ! If the replacement is longer than the original, move up...
                for (i=INPUT_BUFFER_LEN-1 : i>=w+x2 : i-- )
                    a_buffer-->i = a_buffer-->(i-x2+w2);
        
                ! ...increasing buffer size accordingly.
                #Ifdef TARGET_ZCODE;
                a_buffer->1 = (a_buffer->1) + (x2-w2);
                #Ifnot; ! TARGET_GLULX
                a_buffer-->0 = (a_buffer-->0) + (x2-w2);
                #Endif; ! TARGET_
            }
        
            ! Write the correction in:
            for (i=0 : i<x2 : i++) a_buffer-->(i+w) = buffer2-->(i+x1);
        
            VM_Tokenise(a_buffer, a_table);
            #Ifdef TARGET_ZCODE; nw = a_table->1; #Ifnot; nw = a_table-->0; #Endif;
        
            return nw;
        }

        ! Undo handling
    
        if ((w == UNDO1__WD or UNDO2__WD or UNDO3__WD) && (nw==1)) {
            Perform_Undo();
            continue;
        }
        i = VM_Save_Undo();
        #ifdef PREVENT_UNDO; undo_flag = 0; #endif;
        #ifndef PREVENT_UNDO; undo_flag = 2; #endif;
        if (i == -1) undo_flag = 0;
        if (i == 0) undo_flag = 1;
        if (i == 2) {
            VM_RestoreWindowColours();
            VM_Style(SUBHEADER_VMSTY);
            SL_Location(); print "^";
            ! print (name) location, "^";
            VM_Style(NORMAL_VMSTY);
            IMMEDIATELY_UNDO_RM('E'); new_line;
            continue;
        }
        return nw;
    }
];

-) instead of "Reading the Command" in "Parser.i6t";


Include (-
! Updated buffer3 ("again") handling for word arrays

    if (held_back_mode == 1) {
        held_back_mode = 0;
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
            print "~"; for (m=0 : m<l : m++) print (char) k-->m; print "~ ";

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
        for (i=0 : i<INPUT_BUFFER_LEN : i++) buffer-->i = buffer3-->i;
        VM_Tokenise(buffer,parse);
        num_words = WordCount(); players_command = 100 + num_words;
        jump ReParse;
    }

    ! Save the present input in case of an "again" next time

    if (verb_word ~= AGAIN1__WD)
        for (i=0 : i<INPUT_BUFFER_LEN : i++) buffer3-->i = buffer-->i;

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

-) instead of "Parser Letter A" in "Parser.i6t";

Include (-

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
        if (verb_wordnum > 0) i = WordAddress(verb_wordnum); else i = WordAddress(1);
        j = WordAddress(wn);
        if (i<=j) for (: i<j : i=i+4) i-->0 = ' ';
        i = NextWord();
        if (i == AGAIN1__WD or AGAIN2__WD or AGAIN3__WD) {
            ! Delete the words "then again" from the again buffer,
            ! in which we have just realised that it must occur:
            ! prevents an infinite loop on "i. again"

            i = (WordAddress(wn-2)-buffer) / WORDSIZE;
            if (wn > num_words) j = INPUT_BUFFER_LEN-1;
            else j = (WordAddress(wn)-buffer) / WORDSIZE;
            for (: i<j : i++) buffer3-->i = ' ';
        }
        VM_Tokenise(buffer,parse);
        held_back_mode = true;
        return;
    }
    best_etype = UPTO_PE;
    jump GiveError;

-) instead of "Parser Letter K" in "Parser.i6t";

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
    k = (WordAddress(match_from) - buffer) / WORDSIZE;
    l = (buffer2-->0) + 1;
    for (j=INPUT_BUFFER_LEN-1 : j>=k+l : j-- ) buffer-->j = buffer-->(j-l);
    for (i=0 : i<l : i++) buffer-->(k+i) = buffer2-->(1+i);
    buffer-->(k+l-1) = ' ';
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
                        return REPARSE_CODE;
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
            i = 1 + buffer-->0;
            (buffer-->0)++; buffer-->(i++) = ' ';
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
                k = Glulx_PrintAnyToArrayUni(buffer+WORDSIZE*i, INPUT_BUFFER_LEN-i, parse2-->1);
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
    i = 1 + buffer-->0;
    (buffer-->0)++; buffer-->(i++) = ' ';
    for (j=0 : j<buffer2-->0 : i++,j++) {
        buffer-->i = buffer2-->(j+1);
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

[ PARSER_CLARIF_INTERNAL_R; ];

-) instead of "Noun Domain" in "Parser.i6t";


Include (-

! Adjust for word-array buffers.
[ TryNumber wordnum   i j c num len mul tot d digit;
    i = wn; wn = wordnum; j = NextWord(); wn = i;
    j = NumberWord(j); ! Test for verbal forms ONE to TWENTY
    if (j >= 1) return j;

    num = WordAddress(wordnum); len = WordLength(wordnum);

    if (len >= 4) mul=1000;
    if (len == 3) mul=100;
    if (len == 2) mul=10;
    if (len == 1) mul=1;

    tot = 0; c = 0; len = len-1;

    for (c=0 : c<=len : c++) {
        digit=num-->c;
        if (digit == '0') { d = 0; jump digok; }
        if (digit == '1') { d = 1; jump digok; }
        if (digit == '2') { d = 2; jump digok; }
        if (digit == '3') { d = 3; jump digok; }
        if (digit == '4') { d = 4; jump digok; }
        if (digit == '5') { d = 5; jump digok; }
        if (digit == '6') { d = 6; jump digok; }
        if (digit == '7') { d = 7; jump digok; }
        if (digit == '8') { d = 8; jump digok; }
        if (digit == '9') { d = 9; jump digok; }
        return -1000;
     .digok;
        tot = tot+mul*d; mul = mul/10;
    }
    if (len > 3) tot=10000;
    return tot;
];

-) instead of "TryNumber" in "Parser.i6t";


Include (-

Constant SHORT_NAME_BUFFER_LEN = 250;
Array StorageForShortName --> SHORT_NAME_BUFFER_LEN;

! Replacement for the CPrintOrRun routine, using modern printing commands.
! This is a Glulx-only implementation, but then this whole extension is
! Glulx-only.
[ CPrintOrRun obj prop  v length;
    if ((obj ofclass String or Routine) || (prop == 0))
        length = Glulx_PrintAnyToArrayUni(StorageForShortName, SHORT_NAME_BUFFER_LEN, obj);
    else {
        if (obj.prop == NULL) rfalse;
        if (metaclass(obj.prop) == Routine or String)
            length = Glulx_PrintAnyToArrayUni(StorageForShortName, SHORT_NAME_BUFFER_LEN, obj.prop);
        else return RunTimeError(2, obj, prop);
    }
    
    ! Perhaps the name contained more than 250 characters. If so, it was
    ! truncated (safely) to the array length.
    if (length > SHORT_NAME_BUFFER_LEN) length = SHORT_NAME_BUFFER_LEN;
    
    ! This is the best way to print text with the first character capitalized:
    !   length = glk_buffer_to_title_case_uni(StorageForShortName, SHORT_NAME_BUFFER_LEN, length, false);
    !   glk_put_buffer_uni(StorageForShortName, length);
    
    ! However, that crashes on the Mac IDE (6G60), apparently due to a Zoom
    ! bug. So we do it the old-fashioned way. Hopefully a future version can
    ! be made Unicode-aware.
    if (length)
        StorageForShortName-->0 = VM_LowerToUpperCase(StorageForShortName-->0);
    glk_put_buffer_uni(StorageForShortName, length);

    if (length) say__p = 1;

    return;
];

[ Cap str nocaps;
    if (nocaps) print (string) str;
    else CPrintOrRun(str, 0);
];

-) instead of "Short Name Storage" in "Printing.i6t".

Include (-

! This is a Glulx-only implementation.
[ SetPlayersCommand from_txt i len p cp;
    cp = from_txt-->0; p = TEXT_TY_Temporarily_Transmute(from_txt);
    len = TEXT_TY_CharacterLength(from_txt);
    if (len > INPUT_BUFFER_LEN) len = INPUT_BUFFER_LEN;
    buffer-->0 = len;
    for (i=0:i<len:i++) buffer-->(i+1) = CharToCase(BlkValueRead(from_txt, i), 0);
    for (:i+1<INPUT_BUFFER_LEN:i++) buffer-->(i+1) = ' ';
    VM_Tokenise(buffer, parse);
    players_command = 100 + WordCount(); ! The snippet variable ``player's command''
    TEXT_TY_Untransmute(from_txt, p, cp);
];

-) instead of "Setting the Player's Command" in "Text.i6t".


Include (-

! Unchanged.
[ TEXT_TY_ROGPR txt p cp r;
        if (txt == 0) return GPR_FAIL;
        cp = txt-->0; p = TEXT_TY_Temporarily_Transmute(txt);
        r = TEXT_TY_ROGPRI(txt);
        TEXT_TY_Untransmute(txt, p, cp);
        return r;
];
! WordAddress returns --> array now.
[ TEXT_TY_ROGPRI txt
        pos len wa wl wpos bdm ch own;
        bdm = true; own = wn;
        len = BlkValueLBCapacity(txt);
        for (pos=0: pos<=len: pos++) {
                if (pos == len) ch = 0; else ch = BlkValueRead(txt, pos);
                if (ch == 32 or 9 or 10 or 0) {
                        if (bdm) continue;
                        bdm = true;
                        if (wpos ~= wl) return GPR_FAIL;
                        if (ch == 0) break;
                } else {
                        if (bdm) {
                                bdm = false;
                                if (NextWordStopped() == -1) return GPR_FAIL;
                                wa = WordAddress(wn-1);
                                wl = WordLength(wn-1);
                                wpos = 0;
                        }
                        if (wa-->wpos ~= ch or TEXT_TY_RevCase(ch)) return GPR_FAIL;
                        wpos++;
                }
        }
        if (wn == own) return GPR_FAIL; ! Progress must be made to avoid looping
        return GPR_PREPOSITION;
];

-) instead of "Recognition-only-GPR" in "Text.i6t".


[I am Replacing DA_Topic rather than using a template replacement, because it's just one tiny function. See caveat above.]

Include (-
Replace DA_Topic;
-) before "Printing Actions" in "Actions.i6t".

Include (-

! Updated for word-array buffers.
[ DA_Topic x a b c d i cf cw;
    cw = x%100; cf = x/100;
    print "~";
    for (a=cf:d<cw:d++,a++) {
        wn = a; b = WordAddress(a); c = WordLength(a);
        for (i=0:i<c:i++) {
            print (char) b-->i;
        }
        if (d<cw-1) print " ";
    }
    print "~";
];

-) after "Actions.i6t".


Include (-

! Upate for word-array buffers.
! (Note: small numbers are parsed by TryNumber, but large numbers fall through to here.)
[ DECIMAL_TOKEN wnc wna r n wa wl sign base digit digit_count original_wn group_wn;
    wnc = wn; original_wn = wn; group_wn = wn;
{-call:Plugins::Parsing::Tokens::Values::number}
    wn = wnc;
    r = ParseTokenStopped(ELEMENTARY_TT, NUMBER_TOKEN);
    if ((r == GPR_NUMBER) && (parsed_number ~= 10000)) return r;
    wn = wnc;
    wa = WordAddress(wn);
    wl = WordLength(wn);
    sign = 1; base = 10; digit_count = 0;
    if (wa-->0 ~= '-' or '$' or '0' or '1' or '2' or '3' or '4'
        or '5' or '6' or '7' or '8' or '9')
        return GPR_FAIL;
    if (wa-->0 == '-') { sign = -1; wl--; wa=wa+WORDSIZE; }
    if (wl == 0) return GPR_FAIL;
    n = 0;
    while (wl > 0) {
        if (wa-->0 >= 'a') digit = wa-->0 - 'a' + 10;
        else digit = wa-->0 - '0';
        digit_count++;
        switch (base) {
            2:  if (digit_count == 17) return GPR_FAIL;
            10:
                #Iftrue (WORDSIZE == 2);
                if (digit_count == 6) return GPR_FAIL;
                if (digit_count == 5) {
                    if (n > 3276) return GPR_FAIL;
                    if (n == 3276) {
                        if (sign == 1 && digit > 7) return GPR_FAIL;
                        if (sign == -1 && digit > 8) return GPR_FAIL;
                    }
                }
                #Ifnot; ! i.e., if (WORDSIZE == 4)
                if (digit_count == 11) return GPR_FAIL;
                if (digit_count == 10) {
                    if (n > 214748364) return GPR_FAIL;
                    if (n == 214748364) {
                        if (sign == 1 && digit > 7) return GPR_FAIL;
                        if (sign == -1 && digit > 8) return GPR_FAIL;
                    }
                }
                #Endif; 
            16: if (digit_count == 5) return GPR_FAIL;
        }
        if (digit >= 0 && digit < base) n = base*n + digit;
        else return GPR_FAIL;
        wl--; wa=wa+WORDSIZE;
    }
    parsed_number = n*sign; wn++;
    return GPR_NUMBER;
];

-) instead of "Understanding" in "Number.i6t".


Include (-

! Upate for word-array buffers.
[ TIME_TOKEN first_word second_word at length flag
    illegal_char offhour hr mn i original_wn;
    original_wn = wn;
{-call:Plugins::Parsing::Tokens::Values::time}
    wn = original_wn;
    first_word = NextWordStopped();
    switch (first_word) {
        'midnight': parsed_number = 0; return GPR_NUMBER;
        'midday', 'noon': parsed_number = TWELVE_HOURS;
        return GPR_NUMBER;
    }
    ! Next try the format 12:02
    at = WordAddress(wn-1); length = WordLength(wn-1);
    for (i=0: i<length: i++) {
        switch (at-->i) {
            ':': if (flag == false && i>0 && i<length-1) flag = true;
            else illegal_char = true;
            '0', '1', '2', '3', '4', '5', '6', '7', '8', '9': ;
            default: illegal_char = true;
        }
    }
    if (length < 3 || length > 5 || illegal_char) flag = false;
    if (flag) {
        for (i=0: at-->i~=':': i++, hr=hr*10) hr = hr + at-->i - '0';
        hr = hr/10;
        for (i++: i<length: i++, mn=mn*10) mn = mn + at-->i - '0';
        mn = mn/10;
        second_word = NextWordStopped();
        parsed_number = HoursMinsWordToTime(hr, mn, second_word);
        if (parsed_number == -1) return GPR_FAIL;
        if (second_word ~= 'pm' or 'am') wn--;
        return GPR_NUMBER;
    }
    ! Lastly the wordy format
    offhour = -1;
    if (first_word == 'half') offhour = HALF_HOUR;
    if (first_word == 'quarter') offhour = QUARTER_HOUR;
    if (offhour < 0) offhour = TryNumber(wn-1);
    if (offhour < 0 || offhour >= ONE_HOUR) return GPR_FAIL;
    second_word = NextWordStopped();
    switch (second_word) {
        ! "six o'clock", "six"
        'o^clock', 'am', 'pm', -1:
            hr = offhour; if (hr > 12) return GPR_FAIL;
        ! "quarter to six", "twenty past midnight"
        'to', 'past':
            mn = offhour; hr = TryNumber(wn);
            if (hr <= 0) {
                switch (NextWordStopped()) {
                    'noon', 'midday': hr = 12;
                    'midnight': hr = 0;
                    default: return GPR_FAIL;
                }
            }
            if (hr >= 13) return GPR_FAIL;
            if (second_word == 'to') {
                mn = ONE_HOUR-mn; hr--; if (hr<0) hr=23;
            }
            wn++; second_word = NextWordStopped();
        ! "six thirty"
        default:
            hr = offhour; mn = TryNumber(--wn);
            if (mn < 0 || mn >= ONE_HOUR) return GPR_FAIL;
            wn++; second_word = NextWordStopped();
    }
    parsed_number = HoursMinsWordToTime(hr, mn, second_word);
    if (parsed_number < 0) return GPR_FAIL;
    if (second_word ~= 'pm' or 'am' or 'o^clock') wn--;
    return GPR_NUMBER;
];

! Unchanged.
[ HoursMinsWordToTime hour minute word x;
    if (hour >= 24) return -1;
    if (minute >= ONE_HOUR) return -1;
    x = hour*ONE_HOUR + minute; if (hour >= 13) return x;
    x = x % TWELVE_HOURS; if (word == 'pm') x = x + TWELVE_HOURS;
    if (word ~= 'am' or 'pm' && hour == 12) x = x + TWELVE_HOURS;
    return x;
];

-) instead of "Understanding" in "Time.i6t".

[I am Replacing FLOAT_TOKEN rather than using a template replacement, because it's just one not-so-tiny function. See caveat above.]

Include (-
Replace FloatParse;
Replace FLOAT_TOKEN;
-) before "Printing reals" in "RealNumber.i6t".

Include (-
! This now operates on a word array.
[ FloatParse buf len useall
	res ix val ch ten negative intpart fracpart fracdiv
	expon expnegative count;
	
!	print "FloatParse <";
!	for (ix=0: ix<len: ix++) print (char) buf-->ix;
!	print ">^";

	if (len == 0)
		return FLOAT_NAN;
		
	ix = 0;
	negative = false;
	intpart = 0;
	fracpart = 0;
	@numtof 10 ten;

	! Sign character (optional)
	ch = buf-->ix;
	if (ch == '-') {
		negative = true;
		ix++;
	}
	else if (ch == '+') {
		ix++;
	}

	! Some digits (optional)
	for (count=0 : ix<len : ix++, count++) {
		ch = buf-->ix;
		if (ch < '0' || ch > '9')
			break;
		val = (ch - '0');
		@numtof val val;
		@fmul intpart ten intpart;
		@fadd intpart val intpart;
	}

	! Decimal point and more digits (optional)
	if (ix<len && buf-->ix == '.') {
		ix++;
		@numtof 1 fracdiv;
		for ( : ix<len : ix++, count++) {
			ch = buf-->ix;
			if (ch < '0' || ch > '9')
				break;
			val = (ch - '0');
			@numtof	val val;
			@fmul fracpart ten fracpart;
			@fadd fracpart val fracpart;
			@fmul fracdiv ten fracdiv;
		}
		@fdiv fracpart fracdiv fracpart;
	}

	! If there are no digits before *or* after the decimal point, fail.
	if (count == 0)
		return FLOAT_NAN;

	! Combine the integer and fractional parts.
	@fadd intpart fracpart res;

	! Exponent (optional)
	if (ix<len && buf-->ix == 'e' or 'E' or ' ' or '*' or 'x' or 'X' or $D7) {
		if (buf-->ix == 'e' or 'E') {
			! no spaces, just the 'e'
			ix++;
			if (ix == len)
				return FLOAT_NAN;
		}
		else {
			! any number of spaces, "*", any number of spaces more, "10^"
			while (ix < len && buf-->ix == ' ')
				ix++;
			if (ix == len)
				return FLOAT_NAN;
			if (buf-->ix ~= '*' or 'x' or 'X' or $D7)
				return FLOAT_NAN;
			ix++;
			while (ix < len && buf-->ix == ' ')
				ix++;
			if (ix == len)
				return FLOAT_NAN;
			if (buf-->ix ~= '1')
				return FLOAT_NAN;
			ix++;
			if (buf-->ix ~= '0')
				return FLOAT_NAN;
			ix++;
			if (buf-->ix ~= $5E)
				return FLOAT_NAN;
			ix++;
		}

		! Sign character (optional)
		expnegative = false;
		ch = buf-->ix;
		if (ch == '-') {
			expnegative = true;
			ix++;
		}
		else if (ch == '+') {
			ix++;
		}

		expon = 0;
		! Some digits (mandatory)
		for (count=0 : ix<len : ix++, count++) {
			ch = buf-->ix;
			if (ch < '0' || ch > '9')
				break;
			expon = 10*expon + (ch - '0');
		}

		if (count == 0)
			return FLOAT_NAN;

		if (expnegative)
			expon = -expon;

		if (expon) {
			@numtof expon expon;
			@pow ten expon val;
			@fmul res val res;
		}
	}

	if (negative) {
		! set the value's sign bit
		res = $80000000 | res;
	}

	if (useall && ix ~= len)
		return FLOAT_NAN;
	return res;
];

! WordAddress() returns --> array now.
[ FLOAT_TOKEN buf bufend ix ch firstwd newstart newlen lastchar lastwasdot;
	if (wn > num_words)
		return GPR_FAIL;

	! We're going to collect a set of words. Start with zero words.
	firstwd = wn;
	buf = WordAddress(wn);
	bufend = buf;
	lastchar = 0;

	while (wn <= num_words) {
		newstart = WordAddress(wn);
		if (newstart ~= bufend) {
			! There's whitespace between the previous word and this one.
			! Whitespace is okay around an asterisk...
			if ((lastchar ~= '*' or 'x' or 'X' or $D7)
				&& (newstart-->0 ~= '*' or 'x' or 'X' or $D7)) {
				! But around any other character, it's not.
				! Don't include the new word.
				break;
			}
		}
		newlen = WordLength(wn);
		for (ix=0 : ix<newlen : ix++) {
			ch = newstart-->ix;
			if (~~((ch >= '0' && ch <= '9')
				|| (ch == '-' or '+' or 'E' or 'e' or '.' or 'x' or 'X' or '*' or $D7 or $5E)))
				break;
		}
		if (ix < newlen) {
			! This word contains an invalid character.
			! Don't include the new word.
			break;
		}
		! Okay, include it.
		bufend = newstart + newlen*WORDSIZE;
		wn++;
		lastchar = (bufend-WORDSIZE)-->0;
		lastwasdot = (newlen == 1 && lastchar == '.');
	}

	if (wn > firstwd && lastwasdot) {
		! Exclude a trailing period.
		wn--;
		bufend = bufend - WORDSIZE;
	}

	if (wn == firstwd) {
		! No words accepted.
		return GPR_FAIL;
	}

	parsed_number = FloatParse(buf, (bufend-buf)/WORDSIZE, true);
	if (parsed_number == FLOAT_NAN)
		return GPR_FAIL;
	return GPR_NUMBER;
];

-) after "Printing reals" in "RealNumber.i6t".


[I am Replacing TestKeyboardPrimitive rather than using a template replacement, because it's just one tiny function. See caveat above.]

Include (-
Replace TestKeyboardPrimitive;
-) before "Test Command" in "Tests.i6t".

Include (-

! if any test scenarios...
#Iftrue ({-value:NUMBER_CREATED(test_scenario)} > 0);

[ TestKeyboardPrimitive a_buffer a_table p i j l spaced ch;
    if (test_sp == 0) {
        test_stack-->2 = 1;
        return VM_ReadKeyboard(a_buffer, a_table);
    }
    else {
        p = test_stack-->(test_sp-4);
        i = test_stack-->(test_sp-3);
        l = test_stack-->(test_sp-1);
        print "[";
        print test_stack-->2;
        print "] ";
        test_stack-->2 = test_stack-->2 + 1;
        style bold;
        while ((i < l) && (p->i ~= '/')) {
            ch = p->i;
            if (spaced || (ch ~= ' ')) {
                if ((p->i == '[') && (p->(i+1) == '/') && (p->(i+2) == ']')) {
                    ch = '/'; i = i+2;
                }
                a_buffer-->(j+1) = ch;
                print (char) ch;
                i++; j++;
                spaced = true;
            } else i++;
        }
        style roman;
        print "^";
        #ifdef TARGET_ZCODE;
        a_buffer->1 = j;
        #ifnot; ! TARGET_GLULX
        a_buffer-->0 = j;
        #endif;
        VM_Tokenise(a_buffer, a_table);
        if (p->i == '/') i++;
        if (i >= l) {
            test_sp = test_sp - 4;
        } else test_stack-->(test_sp-3) = i;
    }
];

#endif; ! ...if any test scenarios

-) after "Test Command" in "Tests.i6t".


Unicode Parser ends here.


---- DOCUMENTATION ----

When you include this extension, I7 will appear to behave as it always does. However, the command line will be read using a Unicode-friendly input call, and the internal parsing dictionary will contain Unicode strings instead of byte strings. This means that, theoretically, you can define nouns and verbs using any Unicode character (not just basic Latin-1.)

However, the I7 language does not currently permit this. So we have to indulge in some trickery to make these definitions possible.

(By the way, if you're reading these docs in the I7 IDE, you'll see a lot of "[unicode ...]" substitutions in the sample code. You can type Unicode characters directly in your I7 source code! The samples should be written that way, but I7 mangles them when it formats the IDE documentation. Read the Unicode Parser.i7x file directly to see cleaner sample code.)


Section: Unicode synonyms for verbs

To define a verb synonym with Unicode characters:

	Include
	(- Verb '@{3C0}@{3B1}@{3AF}@{3C1}@{3BD}@{3C9}' = 'get';
	Verb '@{3C0}@{3B1}@{3B9}@{3C1}@{3BD}@{3C9}' = 'get';
	Verb '@{11D}et' = 'get'; -)
	after "Grammar" in "Output.i6t".

The strings here are single-quoted strings of characters defined with the I6 '@{hexadecimal}' format. The first line is the Greek word "παίρνω". (I apologize for butchering Greek here -- all my translation is due to Google!) With this definition, the command "παίρνω lamp" will work. So will "Παίρνω Lamp"; as usual, commands are converted to lower case where possible.

The second line is the same word, but without the accent mark. The dictionary considers accents significant while matching, so if you want to accept the verb "παιρνω" (or "Παιρνω") you need this line. (Again, I don't know if a Greek speaker would leave off the accent mark! Probably not.)

The third line defines the verb "ĝet" in the same way. This is by way of demonstrating normalization. The Unicode standard permits two ways to define this string: "ĝet" and "ĝet". These probably look the same to you, but they're not. The former is three characters long, as you might expect; it starts with the Unicode character named LATIN SMALL LETTER G WITH CIRCUMFLEX. (Unicode loves these verbose names.) The second example is *four* characters long; the first character is LATIN SMALL LETTER G, and the second is COMBINING CIRCUMFLEX ACCENT. The "^" stacks on top of the "g" when the pair is displayed.

The combined form is more common, but a player might type either form. Therefore, this extension *tries* to accept both, by "normalizing" the input words. However, the Glk normalization function is relatively new, and may not be available. The Mac Inform IDE 6G60 lacks this call, for example. So the four-character form will not be recognized by the verb definition shown above. To accept it, we'd need an additional line:

	Include (- Verb 'g@{302}et' = 'get'; -)
	after "Grammar" in "Output.i6t".

You can also define an entire verb line (with prepositions and everything), using the I6 syntax:

	Include (- Verb '@{11D}et' * 'i@{3B7}' noun -> Enter; -)
	after "Grammar" in "Output.i6t".

(Accepts the command "ĝet iη boat".)

However, it is currently not possible to refer to a custom action this way -- only to the predefined ones.


Section: Unicode synonyms for nouns

This is also ugly. To define a synonym for an object, we have to define an I6 class:

	Include (- Class rock_name_class
	with name '@{3B2}@{3C1}@{3AC}@{3C7}@{3BF}@{3C2}' '@{3B2}@{3C1}@{3AC}@{3C7}@{3BF}@{3C3}'; -)
	before "Object Tree" in "Output.i6t".
	
	The rock is a thing.
	Include (- class rock_name_class -) when defining the rock.

The rock_name_class class acts as a mix-in which adds the strings "βράχος" and "βράχοσ" to the rock. (I'm including the two variations on the final letter sigma.) We can now accept the command "παίρνω βράχος" (or "Παίρνω Βράχος").


Section: Synonyms from Unicode properties

It's possible to recognize an object from an indexed text property, and the indexed text can contain Unicode. This is less ugly, and you can set it up without requiring I6 code. But it's not very flexible; it only lets you recognize one Unicode word per object. (Or one per property, I suppose. You could add several properties that work this way.)

	The lamp has an indexed text called the greek-synonym.
	Understand the greek-synonym property as describing the lamp.
	
	The greek-synonym of the lamp is "λυχνία".


Section: Details for the I6 hacker

This extension modifies Inform's internal command buffers to be Unicode arrays (arrays of 32-bit integers) rather than plain character arrays (arrays of 8-bit characters). These are the "buffer", "buffer2", and "buffer3" arrays.

We update the parser functions that manage these arrays: VM_ReadKeyboard, VM_CopyBuffer, VM_PrintToBuffer, VM_Tokenise, LTI_Insert, GGWordCompare, WordAddress, PrintSnippet, SpliceSnippet, NounDomain, CPrintOrRun, SetPlayersCommand, DECIMAL_TOKEN, TIME_TOKEN, INDEXED_TEXT_TY_ROGPR, DA_Topic, TestKeyboardPrimitive, and of course a couple of sections of Parser__parse. We add a Glulx_PrintAnyToArrayUni function, which prints to a Unicode array.


Section: Caveats

This extension is intended for Inform 7 build 6K92. It will not work with earlier versions, and has not been tested with any later version.

Things which definitely don't work (as of 6K92):

- Parsing defined units, such as "$1.25" or "26 kg". The parsing routines for these are generated by I7.

- Automatic testing of Unicode commands, such as "test me with 'get λυχνία'." The test-command arrays are generated by I7 as byte arrays, and any Unicode characters are mangled into literal "[unicode ...]" strings. (Test commands that contain only Latin-1 characters will continue to work.)

- Writing and reading Unicode in command-history files. This is possible (it would require modifying more uses of gg_commandstr) but the feature is not in common use these days.

- Any extension that uses I6 code to manipulate the command buffer directly.


Example: ** Ungrammatical Greek - Defining verb and noun synonyms containing Unicode characters.

In this sample, we accept the synonym "παίρνω" for taking, "σήμα" for the sign, and "βράχος" for the rock.

We also accept the variant "παιρνω", and "σημα", and "βραχος", "βράχοσ", "βραχοσ".

	*: "Ungrammatical Greek"
	
	Include Unicode Parser by Andrew Plotkin.

	Ancient Greece is a room. "You stand in the crossroads at the center of Classical Athens, circa 330 BC. Except that you used a cut-rate time machine to get here, so everybody is wearing blue jeans and you're pretty sure their Greek is by way of Google Translate."

	A sign is fixed in place in Greece. "A [sign] reads: Test me with 'παίρνω βράχος'!"
	After printing the name of the sign: say " (σήμα)".

	A rock is in Greece.
	After printing the name of the rock: say " (βράχος)".

	Include (- Class sign_name_class
	with name '@{3C3}@{3AE}@{3BC}@{3B1}' '@{3C3}@{3B7}@{3BC}@{3B1}'; -)
	before "Object Tree" in "Output.i6t".

	Include (- class sign_name_class -) when defining the sign.

	Include (- Class rock_name_class
	with name '@{3B2}@{3C1}@{3AC}@{3C7}@{3BF}@{3C2}' '@{3B2}@{3C1}@{3AC}@{3C7}@{3BF}@{3C3}' '@{3B2}@{3C1}@{3B1}@{3C7}@{3BF}@{3C2}' '@{3B2}@{3C1}@{3B1}@{3C7}@{3BF}@{3C3}'; -)
	before "Object Tree" in "Output.i6t".

	Include (- class rock_name_class -) when defining the rock.

	Include (- Verb '@{3C0}@{3B1}@{3AF}@{3C1}@{3BD}@{3C9}' '@{3C0}@{3B1}@{3B9}@{3C1}@{3BD}@{3C9}' = 'get'; -)
	after "Grammar" in "Output.i6t".


Example: **** Tedious UniParse Test - A bunch of boring test cases to ensure that everything works.

	*: "Tedious Test"

	Include Unicode Parser by Andrew Plotkin.

	The Kitchen is a room. The description is "To really test this extension, run through all of the following commands. (I can't use a 'test me' script for all of this, because Unicode isn't interpreted correctly in testing commands!)[para][command list]".

	To say command list:
		say "  [fix]>> test me[/fix]   [em]('x me'; tests a basic test command)[/em][br]";
		say "  [fix]>> παίρνω βράχος[/fix]   [em](takes the rock)[/em][br]";
		say "  [fix]>> drop ΒΡΑΧΟΣ[/fix]   [em](drops the rock)[/em][br]";
		say "  [fix]>> examine article[/fix]   [em](prints 'An article is a device to test capitalization. The article is not otherwise interesting; it's just an article'; tests a/an/the/A/An/The)[/em][br]";
		say "  [fix]>> examine brass lamp[/fix]   [em](tests property recognition of indexed text)[/em][br]";
		say "  [fix]>> xyz me[/fix]   [em](translated to 'examine me'; tests snippet splicing)[/em][br]";
		say "  [fix]>> xyz βράχος[/fix]   [em](examines the rock; tests snippet splicing with unicode)[/em][br]";
		say "  [fix]>> say hello there to steve[/fix]   [em](tests topic parsing)[/em][br]";
		say "  [fix]>> say παίρνω βράχος to steve[/fix]   [em](ditto, unicode)[/em][br]";
		say "  [fix]>> x qlamp[/fix]   [em](examines the rock; tests replacing the player's command)[/em][br]";
		say "  [fix]>> x qrock[/fix]   [em](examines the lamp; ditto, unicode)[/em][br]";
		say "  [fix]>> say qrock foo to steve[/fix]   [em](tests splicing *and* replacement)[/em][br]";
		say "  [fix]>> set lamp to lead[/fix]   [em]('You set the lead lamp to 'lead''; tests displaying an action with a topic)[/em][br]";
		say "  [fix]>> x lead lamp[/fix]   [em](recognition of new property)[/em][br]";
		say "  [fix]>> set lamp to Ω37∞Б[/fix]   [em]('You set the ω37∞б lamp to 'ω37∞б''; ditto, unicode; also lowercasing)[/em][br]";
		say "  [fix]>> x ω37∞б lamp[/fix]   [em](recognition of new property)[/em][br]";
		say "  [fix]>> examine dfg rock[/fix]   [em]('You can't see any such thing'...)[/em][br]";
		say "  [fix].. oops βράχος[/fix]   [em](tests 'oops')[/em][br]";
		say "  [fix]>> get   [/fix][em]('What do you want to get?')[/em][br]";
		say "  [fix].. βράχος[/fix]   [em](takes the rock; tests disambiguation splicing)[/em][br]";
		say "  [fix]>> get lamp then get rock   [/fix][em](tests command chaining)[/em][br]";
		say "  [fix]>> examine me[/fix][br]";
		say "  [fix].. again[/fix]   [em](tests 'again')[/em][br]";
		say "  [fix]>> examine βράχος[/fix] [br]";
		say "  [fix].. again[/fix]   [em](ditto, unicode)[/em][br]";
		say "  [fix]>> i.again[/fix]   [em](tests a particular parser guard against infinite loop)[/em][br]";
		say "  [fix]>> count 3. count 19. count 321. count five[/fix]   [em](test number parsing)[/em][br]";
		say "  [fix]>> count 98765. count -543210[/fix]   [em](test large number parsing)[/em][br]";
		say "  [fix]>> measure 3. measure -2.1. measure 1.2e3. measure 4*10^-1[/fix]   [em](test real number parsing)[/em][br]";
		say "  [fix]>> measure -4.jump. measure 3.1 * 10^1. examine me[/fix]   [em](more real number parsing)[/em][br]";
		say "  [fix]>> time 3[/fix]   [em](test time parsing)[/em][br]";
		say "  [fix]>> time 11 pm[/fix]   [em](ditto; multiple on a line don't work)[/em][br]";
		say "  [fix]>> time 4:50[/fix] [br]";
		say "  [fix]>> time 20 to 5 pm[/fix] [br]";

	The lamp is in the Kitchen.
	The lamp has an indexed text called the adjective. The adjective of the lamp is "brass".
	The printed name of the lamp is "[adjective] lamp".
	Understand the adjective property as describing the lamp.

	The rock is in the Kitchen.

	An article is in the Kitchen.

	Steve is a person in the Kitchen.

	Check examining the article:
		instead say "[A noun] is a device to test capitalization. [The noun] is not otherwise interesting; it's just [a noun]."

	Include (- Class rock_name_class
	with name '@{3B2}@{3C1}@{3AC}@{3C7}@{3BF}@{3C2}' '@{3B2}@{3C1}@{3AC}@{3C7}@{3BF}@{3C3}' '@{3B2}@{3C1}@{3B1}@{3C7}@{3BF}@{3C2}' '@{3B2}@{3C1}@{3B1}@{3C7}@{3BF}@{3C3}'; -)
	before "Object Tree" in "Output.i6t".

	Include (- class rock_name_class -) when defining the rock.

	Include (- Verb '@{3C0}@{3B1}@{3AF}@{3C1}@{3BD}@{3C9}' '@{3C0}@{3B1}@{3B9}@{3C1}@{3BD}@{3C9}' = 'get'; -)
	after "Grammar" in "Output.i6t".

	To decide what snippet is snippet at word (N - number) length (L - number):
		(- (({N})*100 + ({L})) -).

	To say para -- running on:
		(- DivideParagraphPoint(); new_line; -).
	To say br -- running on:
		(- new_line; -).

	To say em -- running on:
		(- style underline; -).
	To say /em -- running on:
		(- style roman; -).
	To say fix -- running on:
		(- font off; -).
	To say /fix -- running on:
		(- font on; -).

	After reading a command: 
		let T be indexed text; 
		let T be the player's command;
		if T matches the regular expression "^xyz":
			replace word number 1 in T with "examine";
			say "(Changing command to '[T]'.)";
			change the text of the player's command to T;
		if word number 2 in T is "qlamp":
			let snip be snippet at word 2 length 1;
			replace snip with  "lamp";
			say "(Changing command to '[the player's command]'.)";
		if word number 2 in T is "qrock":
			let snip be snippet at word 2 length 1;
			replace snip with  "βράχος";
			say "(Changing command to '[the player's command]'.)";

	Check answering Steve that:
		instead say "You say '[the topic understood]' to Steve."

	Check setting the lamp to:
		say "(Current action: [current action].)[br]";
		now the adjective of the lamp is the topic understood;
		instead say "You set the lamp to '[the topic understood]'."

	Counting is an action applying to one number.

	Understand "count [number]" as counting.

	Report counting:
		say "You count to [the number understood]."

	Measuring is an action applying to one real number.

	Understand "measure [real number]" as measuring.

	Report measuring:
		say "You measure [the real number understood]."

	Time-checking is an action applying to one time.

	Understand "time [time]" as time-checking.

	Report time-checking:
		say "That's [the time understood]."

	Test me with "x me".

