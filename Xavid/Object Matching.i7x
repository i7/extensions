Version 1/170530 of Object Matching by Xavid begins here.

"Support for getting the matched object when matching a snippet against a pattern and for disabling clarification when a command or snippet is ambiguous."

Use authorial modesty.

Section 1 - Getting an object out of a matched snippet

The matched object is an object that varies.
The matched object variable translates into I6 as "matched_object".

To decide if (S - a snippet) object-matches (T - a topic):
	(- SnippetMatchesObject({S}, {T}) -)

Include (-

[ SnippetMatchesObject snippet topic_gpr rv prev_disable_clarification prev_etype;
	! Without this, SnippetMatchesObject sometimes causes a spurious newline to get printed, for example if the text starts with something that matches something dynamically. (E.g., Understand "fire/smoke" as something flaming.)
	RunParagraphOn();
	matched_object=nothing;
	wn=1;
	if (topic_gpr == 0) rfalse;
	if (metaclass(topic_gpr) == Routine) {
		prev_disable_clarification = disable_clarification;
		prev_etype = etype;
		disable_clarification = true;
		rv = (topic_gpr)(snippet/100, snippet%100);
		disable_clarification = prev_disable_clarification;
		etype = prev_etype;
		matched_object = rv;
		if (rv ~= GPR_FAIL) rtrue;
		rfalse;
	}
	RunTimeProblem(RTP_BADTOPIC);
	rfalse;
];

-).

Section 2 - I6T Hacking

[ We add a global variable that lets us disable the clarification flow. Otherwise, if we try to match an ambiguous object and the player answers the resulting question, we'll get a parser crash. ]

[ We expose this to Inform 7 in case someone wants to disable clarification at another time. ]
Disable clarification is a truth state that varies.
The disable clarification variable translates into I6 as "disable_clarification".

Include (-

Global matched_object;
Global disable_clarification;

-) after "Definitions.i6t".

[ I got the inspiration/confidence to just flip out and replace a section of I6T to make minor changes from Subcommands by Daniel Stelzer. (https://github.com/i7/extensions/blob/master/Daniel%20Stelzer/Subcommands.i7x)

The only changes from Inform 7 build 6M62 are passing disable_clarification to the two calls to NounDomain. ]

Include (-

    ! This is an actual specified object, and is therefore where a typing error
    ! is most likely to occur, so we set:

    oops_from = wn;

    ! So, two cases.  Case 1: token not equal to "held" (so, no implicit takes)
    ! but we may well be dealing with multiple objects

    ! In either case below we use NounDomain, giving it the token number as
    ! context, and two places to look: among the actor's possessions, and in the
    ! present location.  (Note that the order depends on which is likeliest.)

    if (token ~= HELD_TOKEN) {
        i = multiple_object-->0;
        #Ifdef DEBUG;
        if (parser_trace >= 3) print "  [Calling NounDomain on location and actor]^";
        #Endif; ! DEBUG
        l = NounDomain(actors_location, actor, token, disable_clarification);
        if (l == REPARSE_CODE) return l;                  ! Reparse after Q&A
        if (indef_wanted == INDEF_ALL_WANTED && l == 0 && number_matched == 0)
            l = 1;  ! ReviseMulti if TAKE ALL FROM empty container

        if (token_allows_multiple && ~~multiflag) {
            if (best_etype==MULTI_PE) best_etype=STUCK_PE;
            multiflag = true;
        }
        if (l == 0) {
            if (indef_possambig) {
                ResetDescriptors();
                wn = desc_wn;
                jump TryAgain2;
            }
            if (etype == MULTI_PE && multiflag) etype = STUCK_PE;
            etype=CantSee();
            jump FailToken;
        } ! Choose best error

        #Ifdef DEBUG;
        if (parser_trace >= 3) {
            if (l > 1) print "  [ND returned ", (the) l, "]^";
            else {
                print "  [ND appended to the multiple object list:^";
                k = multiple_object-->0;
                for (j=i+1 : j<=k : j++)
                    print "  Entry ", j, ": ", (The) multiple_object-->j,
                          " (", multiple_object-->j, ")^";
                print "  List now has size ", k, "]^";
            }
        }
        #Endif; ! DEBUG

        if (l == 1) {
            if (~~many_flag) many_flag = true;
            else {                                ! Merge with earlier ones
                k = multiple_object-->0;            ! (with either parity)
                multiple_object-->0 = i;
                for (j=i+1 : j<=k : j++) {
                    if (and_parity) MultiAdd(multiple_object-->j);
                    else            MultiSub(multiple_object-->j);
                }
                #Ifdef DEBUG;
                if (parser_trace >= 3)
                	print "  [Merging ", k-i, " new objects to the ", i, " old ones]^";
                #Endif; ! DEBUG
            }
        }
        else {
            ! A single object was indeed found

            if (match_length == 0 && indef_possambig) {
                ! So the answer had to be inferred from no textual data,
                ! and we know that there was an ambiguity in the descriptor
                ! stage (such as a word which could be a pronoun being
                ! parsed as an article or possessive).  It's worth having
                ! another go.

                ResetDescriptors();
                wn = desc_wn;
                jump TryAgain2;
            }

            if ((token == CREATURE_TOKEN) && (CreatureTest(l) == 0)) {
                etype = ANIMA_PE;
                jump FailToken;
            } !  Animation is required

            if (~~many_flag) single_object = l;
            else {
                if (and_parity) MultiAdd(l); else MultiSub(l);
                #Ifdef DEBUG;
                if (parser_trace >= 3) print "  [Combining ", (the) l, " with list]^";
                #Endif; ! DEBUG
            }
        }
    }

    else {

    ! Case 2: token is "held" (which fortunately can't take multiple objects)
    ! and may generate an implicit take

        l = NounDomain(actor,actors_location,token,disable_clarification);       ! Same as above...
        if (l == REPARSE_CODE) return l;
        if (l == 0) {
            if (indef_possambig) {
                ResetDescriptors();
                wn = desc_wn;
                jump TryAgain2;
            }
            etype = CantSee(); jump FailToken;            ! Choose best error
        }

        ! ...until it produces something not held by the actor.  Then an implicit
        ! take must be tried.  If this is already happening anyway, things are too
        ! confused and we have to give up (but saving the oops marker so as to get
        ! it on the right word afterwards).
        ! The point of this last rule is that a sequence like
        !
        !     > read newspaper
        !     (taking the newspaper first)
        !     The dwarf unexpectedly prevents you from taking the newspaper!
        !
        ! should not be allowed to go into an infinite repeat - read becomes
        ! take then read, but take has no effect, so read becomes take then read...
        ! Anyway for now all we do is record the number of the object to take.

        o = parent(l);
        if (o ~= actor) {
            #Ifdef DEBUG;
            if (parser_trace >= 3) print "  [Allowing object ", (the) l, " for now]^";
            #Endif; ! DEBUG
        }
        single_object = l;
    } ! end of if (token ~= HELD_TOKEN) else

    ! The following moves the word marker to just past the named object...
	
!	if (match_from ~= oops_from) print match_from, " vs ", oops_from, "^";

!    wn = oops_from + match_length;
    wn = match_from + match_length;


-) instead of "Parse Token Letter D" in "Parser.i6t".

Object Matching ends here.

---- DOCUMENTATION ----

This extension provides support for getting the matched object when matching a snippet against a pattern and for disabling clarification when a command or snippet is ambiguous.

Disambiguation Override by Mike Ciul provides similar functionality with more options, however, it doesn't seem compatible with recent Inform 7.

Chapter 1 - Object Matching

This extension provides one main construct. You can use "if (snippet) object-matches (topic)" in the same way as you use the standard Inform "if (snippet) matches (topic)". The difference is that, if the condition is true, the following code can refer to "the matched object". For example,

	if S object-matches "[any thing]":
		say "You sense that that is in [the location of the matched object]."

This is mainly useful for making overly-clever error messages without affecting the parsing of normal commands; for non-error situations you're probably better off using normal understand-based parsing.

Chapter 2 - Disabling Clarification

This extension internally disables clarification while object-matching both because it doesn't make sense and also because it doesn't work and crashes the interpreter. If the snippet matches more than one thing equally well, Inform will pick one arbitrarily instead of asking for clarification.

If you want to disable clarification in some other situation, you can do so with:
	
	Now disable clarification is true.

Note that this will last until you do "now disable clarification is false".

Chapter 3 - Bugs and Comments

This extension is hosted in Github at https://github.com/i7/extensions/tree/master/Xavid. Feel free to email me at extensions@xavid.us with questions, comments, bug reports, suggestions, or improvements.

Example: *** Psychic Examiner - Error messages with locations.

	*: "Psychic Examiner"
	
	Include Object Matching by Xavid.
	Include Snippetage by Dave Robinson.
	
	Library is a room.
	
	Study is south of Library.
	
	A thing called a laser sword is here.

	[ Sometimes it's useful to know information about various objects that might be referred to by a command to print better error messages. One approach, used in Remembering by Aaron Reed, adds "[any thing]" versions of relevant commands, but this has the downside that it can change the parsing of normal commands and add unnecessary ambiguity even when there is no error. With this approach, we can parse the command as normal and only consider other possibilities when an error has already occurred.

	For example, we could use this to mention the location of objects that match the player's command but aren't present. ]

	Rule for printing a parser error when the latest parser error is the can't see any such thing error:
		if the snippet at 2 of length (the command length - 1) object-matches "[any thing]":
			say "[regarding the matched object]You don't see [the matched object] here; your psychic intuition tells you that [it] is in the [location of the matched object].";
		else:
			say "You can't see any such thing."

	[ Note that this simple version assumes the verb is one word long and the entire rest of the command is the noun; it will work for "examine sword" but not for "look at sword" or "give sword to Fred". For a somewhat more robust version, see Expanded Understanding by Xavid. ]

	Test me with "x sword / x wombat / s / x sword".

Example: ** Unit Tests

	*: "Unit Tests"

	Include Object Matching by Xavid.
	Include Command Unit Testing by Xavid.
	Include Snippetage by Dave Robinson.

	Library is a room.

	A thing called a red apple is here. A thing called a green apple is here.

	Study is south of Library.
	
	A thing called a laser sword is here.

	Rule for printing a parser error when the latest parser error is the can't see any such thing error:
		if the snippet at 2 of length (the command length - 1) object-matches "[any thing]":
			say "[regarding the matched object]You don't see [the matched object] here; your psychic intuition tells you that [it] is in the [location of the matched object].";
		else:
			say "You can't see any such thing."

	Unit test:
		start test "successful match";
		assert that "x sword" produces "You don't see the laser sword here; your psychic intuition tells you that it is in the Study.";
		do "s";
		assert that "x sword" produces "You see nothing special about the laser sword.";
		[]
		start test "failure to match";
		assert that "x wombat" produces "You can't see any such thing.";
		[]
		start test "ambiguous match";
		assert that "x apple" produces "You don't see the red apple here; your psychic intuition tells you that it is in the Library.";

	Test me with "unit".