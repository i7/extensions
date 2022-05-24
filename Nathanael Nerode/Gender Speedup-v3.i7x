Version 3.0.220524 of Gender Speedup by Nathanael Nerode begins here.

"When using Gender Options, clean up some I6 internals with functions related to gender which are irrelevant to English or rendered obsolete with Gender Options.  Since these are called in the depths of ListWriter this should slightly improve speed.  Not included in Gender Options due to likely interference with other extensions.  Requires Gender Options.  Will not work with languages with gendered plurals.  Tested with Inform 10.1."

Include Gender Options by Nathanael Nerode.

[ Implementation strategy:  We eliminate all remaining uses of GetGender and GetGNAOfObject. Gender Options removed most of them, and this gets rid of the rest.  Most of the rest were checking gender in places where English doesn't care, such as plurals. ]

Section - Remove GetGender

[ This was in Parser.i6t in CommandParserKit ]
[ GetGender was already dead code in the Standard Rules.  Its interface isn't even meaningful now; remove it. ]

Include (-
-) replacing "GetGender"

Section - Replace GetGNAOfObject

[ This is in Parser.i6t in CommandParserKit ]
[ This is a backup implementation in case the story writer has to disable another section of Gender Speedup.  It only reports plurals. ]

Include (-
[ GetGNAOfObject obj;
	! New protocol: return 5 if we should use plural conjugations and declensions, 2 if we should use singular conjugations and declensions.
	! If anyone's using the old protocol, this will be read as "neuter animate", which is the best default.
	if (obj has pluralname) return 5;
	else return 2;
];
-) replacing "GetGNAOfObject"

Section - Patch ScoreMatchL

[ This is in Parser.i6t in CommandParserKit ]
[ This used GetGNAOfObject as the final 1-point disambiguator.  Our new implementation still does check gender, though it's not very important whether it matches. ]
[ We make only one change in this entire procedure, replacing PowersOfTwo_TB-->(GetGNAOfObject(obj)) with GetGNABitfield ]

Include (-
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
                    if (its_owner ~= Compass) its_score = its_score + SCORE__NOTCOMPASS;

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

            j = GetGNABitfield(obj) || $$000000001000 ; ! 0 -> inanimate neuter singular
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
-) replacing "ScoreMatchL"

Section - Patch PrefaceByArticle

[ This is in Printing.i6t in CommandParserKit ]
[ This used GetGNAOfObject and then applies LanguageGNAsToArticles, which strips the gender and animate status out, to get articles.  This is irrelevant for English.]
[ We make only one small change: we remove the bit twiddling code which used GetGNAOfObject. ]

Include (-
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

    ! Gender Speedup: This is the ultra-fast English-only way of checking for plurals.
    i = pluralise || (obj has pluralname);
    
    artform = LanguageArticles
        + 3*WORDSIZE*LanguageContractionForms*(short_name_case + i*LanguageCases);

    switch (LanguageContractionForms) {
      2: if (artform-->acode ~= artform-->(acode+3)) findout = true;
      3: if (artform-->acode ~= artform-->(acode+3)) findout = true;
         if (artform-->(acode+3) ~= artform-->(acode+6)) findout = true;
      4: if (artform-->acode ~= artform-->(acode+3)) findout = true;
         if (artform-->(acode+3) ~= artform-->(acode+6)) findout = true;
         if (artform-->(acode+6) ~= artform-->(acode+9)) findout = true;
      default: findout = true;
    }

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
-) replacing "PrefaceByArticle"

Section - Patch RegardingMarkedObjects

[ This is in ListWriter.i6t in WorldModelKit ]
[ This used GetGNAOfObject % 3 to set prior_named_list_gender (in two places), which is dead code (intended for non-English langauges). ]
[ Our express implementation of RegardingMarkedObjects just checks plurals.  We strip out all the prior_named_list_gender tracking, since plurals aren't gendered in English.  And prior_named_list is only ever checked for >=2 in English, so we stop counting at 2; this avoids most of an entire object loop. ]

Include (-
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
-) replacing "RegardingMarkedObjects"

Section - Patch RegardingSingleObject

[ This is now in Utilities.i6t in BasicInformKit ]
[ Strip prior_named_list_gender tracking ]

Include (-
[ RegardingSingleObject obj;
	prior_named_list = 1;
	prior_named_noun = obj;
];
-) replacing "RegardingSingleObject"

Section - Patch RegardingNumber

[ This is now in Utilities.i6t in BasicInformKit ]
[ Strip prior_named_list_gender tracking ]

Include (-
[ RegardingNumber n;
	prior_named_list = n;
	prior_named_noun = nothing;
];
-) replacing "RegardingNumber"

Section - Patch PNToVP

[ This is in ListWriter.i6t in WorldModelKit; PNToVP is called by the autogenerated verb conjugation code. ]
[ This used (GetGNAOfObject % 6 ) / 3. Again, it's only checking plurals. We only check plurals. ]

Include (-
[ PNToVP gna;
	if (prior_named_noun == player) return story_viewpoint;
	if ( (prior_named_list >= 2) || (prior_named_noun && (prior_named_noun has pluralname) ) ) return 6;
	return 3;
];
-) Replacing "PNToVP"

Section - Patch WriteListOfMarkedObjects

[ remove calculation of prior_named_list_gender, which is dead code in English.]

Include (-
[ WriteListOfMarkedObjects in_style
	obj common_parent first mixed_parentage length;

	objectloop (obj ofclass Object && obj has workflag2) {
		length++;
		if (first == nothing) { first = obj; common_parent = parent(obj); }
		else { if (parent(obj) ~= common_parent) mixed_parentage = true; }
	}
	if (mixed_parentage) common_parent = nothing;

	if (length == 0) {
		if (in_style & ISARE_BIT ~= 0) LIST_WRITER_INTERNAL_RM('W');
		else if (in_style & CFIRSTART_BIT ~= 0) LIST_WRITER_INTERNAL_RM('X');
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

		WriteListFrom(first, in_style, 0, false, MarkedListIterator);

		FreeStack(MarkedObjectArray);
		@pull MarkedObjectLength; @pull MarkedObjectArray;
	}
	prior_named_list = length;
	return;
];
-) replacing "WriteListOfMarkedObjects"

Gender Speedup ends here.

---- DOCUMENTATION ----

Section - Purpose and Function

If you're using the English language, there's a lot of unnecessary gender tracking code in the Inform 6 templates layer, which is used for French, German, etc.  This includes heavily used loops when listing objects.  My extension Gender Options replaces a substantial amount of the gender tracking code.  Since the Inform 6 compiler doesn't do any optimization, it's worth doing it ourselves.  This gets rid of the rest of the dead and irrelevant gender tracking code for a small speedup.

It is strongly recommended to tell the I6 compiler to strip out unused subroutines to shrink the story file size.
	Use OMIT_UNUSED_ROUTINES of 1.

Section - Interaction with Other Extensions

This requires rather invasive replacements of large sections of I6 template code just to change one or two lines.  This may interfere with other extensions which patch the I6 code.  If this happens, each section can be individually disabled, as follows:

	Section - Disabled 1 (in place of Section - Patch ScoreMatchL in Gender Speedup by Nathanael Nerode)
	Section - Disabled 2 (in place of Section - Patch PrefaceByArticle in Gender Speedup by Nathanael Nerode)
	Section - Disabled 3 (in place of Section - Patch PNToVP and RegardingMarkedObjects in Gender Speedup by Nathanael Nerode)
	Section - Disabled 4 (in place of Section - Patch WriteListOfMarkedObjects in Gender Speedup by Nathanael Nerode)

One section exists solely to support other extensions which are patching the other sections, so you shouldn't replace it, but if you need to:
	Section - Disabled 7 (in place of Section - Replace GetGNAOfObject in Gender Speedup by Nathanael Nerode)

The ScoreMatchL changes specifically conflict with Disambiguation Control by Jon Ingold, which is not currently working with 10.1 (and no other extension I know of).  I may try to get this working.

The PrefaceByArticle changes conflict with multiple extensions making bugfixes to PrefaceByArticle.  I may try to get the bugfixes pushed upstream.

Fluid Pronouns by Zed Lopez touches all of this code and is likely to conflict with both this and Gender Options.

Section - Changelog:

	3.0.220534: Section documentation.  Format Changelog.
	3.0.220523: Adaptation to Inform 10.1.  Additional documentation on extension conflicts.
	2/210331: Change disambiguation treatment with names of rooms.  Should fix Counterfeit Monkey regtests
	1/170816: first version
