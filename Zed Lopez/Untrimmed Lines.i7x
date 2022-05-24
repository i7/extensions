Version 1 of Untrimmed Lines by Zed Lopez begins here.

"I7's line number phrase returns lines with left and right whitespace
trimmed; other than using regexps, there isn't a built-in means to
access the raw untrimmed line. This adds an ``untrimmed line number``
phrase."

Include 6M62 Patches by Friends of I7. [ need TEXT_TY_BlobAccess fix ]

Include (-
Replace TEXT_TY_BlobAccessI;
-) after "Definitions.i6t".

Include (-

Constant UNTRIMMED_LINE_BLOB = 8;

[ BreakingCharacter ch blobtype;
  if (ch == 10 or 13) rtrue;
  if (blobtype == UNTRIMMED_LINE_BLOB) rfalse;
  if (ch == 32 or 9) rtrue;
  rfalse;
];

[ TEXT_TY_BlobAccessI txt blobtype ctxt wanted rtxt
	brm oldbrm ch i dsize csize blobcount gp cl j;
	dsize = BlkValueLBCapacity(txt);
	if (ctxt) csize = BlkValueLBCapacity(ctxt);
	else if (rtxt) "*** rtxt without ctxt ***";
	brm = WS_BRM;
	for (i=0:i<dsize:i++) {
		ch = BlkValueRead(txt, i);
		if (ch == 0) break;
		oldbrm = brm;
		if (BreakingCharacter(ch, blobtype)) {
			if (oldbrm ~= WS_BRM) {
				gp = 0;
				for (j=i:j<dsize:j++) {
					ch = BlkValueRead(txt, j);
					if (ch == 0) { brm = WS_BRM; break; }
					if (ch == 10 or 13) { gp++;
                                          continue; }
					if (ch ~= 32 or 9) break;
				}
				ch = BlkValueRead(txt, i);
				if (j == dsize) brm = WS_BRM;
				switch (blobtype) {
					PARA_BLOB: if (gp >= 2) brm = WS_BRM;
					LINE_BLOB: if (gp >= 1) brm = WS_BRM;
					UNTRIMMED_LINE_BLOB: if (gp >= 1) brm = WS_BRM;
					default: brm = WS_BRM;
				}
			}
		} else {
			gp = false;
			if ((blobtype == WORD_BLOB or PWORD_BLOB or UWORD_BLOB) &&
				(ch == '.' or ',' or '!' or '?'
						or '-' or '/' or '"' or ':' or ';'
						or '(' or ')' or '[' or ']' or '{' or '}'))
				gp = true;
			switch (oldbrm) {
				WS_BRM:
					brm = ACCEPTED_BRM;
					if (blobtype == WORD_BLOB) {
						if (gp) brm = SKIPPED_BRM;
					}
					if (blobtype == PWORD_BLOB) {
						if (gp) brm = ACCEPTEDP_BRM;
					}
				SKIPPED_BRM:
					if (blobtype == WORD_BLOB) {
						if (gp == false) brm = ACCEPTED_BRM;
					}
				ACCEPTED_BRM:
					if (blobtype == WORD_BLOB) {
						if (gp) brm = SKIPPED_BRM;
					}
					if (blobtype == PWORD_BLOB) {
						if (gp) brm = ACCEPTEDP_BRM;
					}
				ACCEPTEDP_BRM:
					if (blobtype == PWORD_BLOB) {
						if (gp == false) brm = ACCEPTED_BRM;
						else {
							if ((ch == BlkValueRead(txt, i-1)) &&
								(ch == '-' or '.')) blobcount--;
							blobcount++;
						}
					}
				ACCEPTEDN_BRM:
					if (blobtype == WORD_BLOB) {
						if (gp) brm = SKIPPED_BRM;
					}
					if (blobtype == PWORD_BLOB) {
						if (gp) brm = ACCEPTEDP_BRM;
					}
				ACCEPTEDPN_BRM:
					if (blobtype == PWORD_BLOB) {
						if (gp == false) brm = ACCEPTED_BRM;
						else {
							if ((ch == BlkValueRead(txt, i-1)) &&
								(ch == '-' or '.')) blobcount--;
							blobcount++;
						}
					}
			}
		}
		if (brm == ACCEPTED_BRM or ACCEPTEDP_BRM) {
			if (oldbrm ~= brm) blobcount++;
			if ((ctxt) && (blobcount == wanted)) {
				if (rtxt) {
					BlkValueWrite(ctxt, cl, 0);
					TEXT_TY_Concatenate(ctxt, rtxt, CHR_BLOB);
					csize = BlkValueLBCapacity(ctxt);
					cl = TEXT_TY_CharacterLength(ctxt);
					if (brm == ACCEPTED_BRM) brm = ACCEPTEDN_BRM;
					if (brm == ACCEPTEDP_BRM) brm = ACCEPTEDPN_BRM;
				} else {
					if (cl+1 >= csize) {
						if (BlkValueSetLBCapacity(ctxt, 2*cl) == false) break;
						csize = BlkValueLBCapacity(ctxt);
					}
					BlkValueWrite(ctxt, cl++, ch);
				}
			} else {
				if (rtxt) {
					if (cl+1 >= csize) {
						if (BlkValueSetLBCapacity(ctxt, 2*cl) == false) break;
						csize = BlkValueLBCapacity(ctxt);
					}
					BlkValueWrite(ctxt, cl++, ch);
				}
			}
		} else {
			if ((rtxt) && (brm ~= ACCEPTEDN_BRM or ACCEPTEDPN_BRM)) {
				if (cl+1 >= csize) {
					if (BlkValueSetLBCapacity(ctxt, 2*cl) == false) break;
					csize = BlkValueLBCapacity(ctxt);
				}
				BlkValueWrite(ctxt, cl++, ch);
			}
		}
	}
	if (ctxt) BlkValueWrite(ctxt, cl++, 0);
	return blobcount;
];

-) after "Output.i6t".

To decide what text is an/-- untrimmed line number (N - a number) in/of/from (T - text):
	(- TEXT_TY_GetBlob({-new:text}, {-by-reference:T}, {N}, UNTRIMMED_LINE_BLOB) -).

Untrimmed Lines ends here.

---- Documentation ----

This adds a single phrase:

the/an/-- untrimmed line number <number> in <text> ... text

It returns the corresponding line but unlike the plain 'line number X in', it 
maintains and left or right whitespace.

Example: * Untrimmed Whitespace

	*: "Untrimmed Whitespace"
	
	Include Untrimmed Lines by Zed Lopez.
	
	wabe-list is always
	    { "And the wabe is the grass-plot round[line break]",
	      "   a sun-dial, I suppose?' said Alice,[line break]",
	      "surprised at her own ingenuity.[line break]",
	      "[line break]",
	      "'Of course it is. It[']s called wabe,[line break]",
	      "   you know, because it goes a long way[line break]",
	      "before it, and a long way behind it.'[line break]" }.
	
	Lab is a room.
	
	When play begins:
	  let wabe be "";
	  repeat with i running from 1 to the number of entries in wabe-list begin;
	    now wabe is "[wabe][entry i in wabe-list]";
	  end repeat;
	  say wabe;
	  say "[line break]--[line break][line break]";
	  repeat with i running from 1 to the number of lines in wabe begin;
	    say line number i in wabe;
	    say line break;
	  end repeat;
	  say "[line break]--[line break][line break]";
	  repeat with i running from 1 to the number of lines in wabe begin;
	    say untrimmed line number i in wabe;
	    say line break;
	  end repeat;
	
