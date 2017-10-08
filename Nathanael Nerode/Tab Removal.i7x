Version 1/171007 of Tab Removal by Nathanael Nerode begins here.

"Rejects commands with tabs in them."

[
Many interpreters unfortunately pass tabs through into the command.  Tabs are treated as *letters* which are part of a word, unhelpfully, which leads to confusing error responses with embedded tabs.  Worse, when Glulxe goes to print the error message with the embedded tab, it issues a runtime error saying that it can't print character 9* (the tab character) -- in the middle of this "word"!  This is a pretty cryptic error message.

By contrast, Glulxe will, hilariously, print "[unicode 9]" with no complaints... it prints a tab! :-)

The implementation for the Z-machine is straightforwardly done with "after reading a command".

But while the straightforward implementation works for the Z-machine, *it fails for Glulx*.  In both glulxe and git, the "\t" regular expression does not match the tab as it should.  It matches tabs inserted into your code using [unicode 9], but not tabs typed at the command line.  I can't figure out why.

So for Glulx we replace the tokenizer.  (We can't replace the tokenizer with the Z-machine because on the Z-machine the tokenizer is on the interpreter-side.)
]

Section - The Easy Way (for Z-machine only)

The tab removal rule is listed first in the after reading a command rulebook.
After reading a command (this is the tab removal rule):
	let cmdln be text;
	let cmdln be the substituted form of "[the player's command]"; [Yes it has to be in quotes and brackets]
	if cmdln matches the regular expression "\t": [a literal tab]
		replace the regular expression "\t" in cmdln with " ";
		change the text of the player's command to cmdln;

Section - The Hard Way (for Glulx only)

Include (-
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Tab Removal replacement for Glulx.i6t: Buffer Functions
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
[ VM_CopyBuffer bto bfrom i;
    for ( i=0: i<INPUT_BUFFER_LEN: i++ ) bto->i = bfrom->i;
];

[ VM_PrintToBuffer buf len a b c;
    if (b) {
        if (metaclass(a) == Object && a.#b == WORDSIZE
            && metaclass(a.b) == String)
            buf-->0 = Glulx_PrintAnyToArray(buf+WORDSIZE, len, a.b);
		else if (metaclass(a) == Routine)
			buf-->0 = Glulx_PrintAnyToArray(buf+WORDSIZE, len, a, b, c);
        else
            buf-->0 = Glulx_PrintAnyToArray(buf+WORDSIZE, len, a, b);
    }
    else if (metaclass(a) == Routine)
        buf-->0 = Glulx_PrintAnyToArray(buf+WORDSIZE, len, a, b, c);
    else
		buf-->0 = Glulx_PrintAnyToArray(buf+WORDSIZE, len, a);
    if (buf-->0 > len) buf-->0 = len;
    return buf-->0;
];

[ VM_Tokenise buf tab
    cx numwords len bx ix wx wpos wlen val res dictlen entrylen;
    len = buf-->0;
    buf = buf+WORDSIZE;

    ! First, split the buffer up into words. We use the standard Infocom
    ! list of word separators (comma, period, double-quote).

    ! Tab Removal takes place here: since it can't be matched in I7 due to bugs in Glulxe.
	cx = 0;
	while (cx < len) {
		if (buf->cx == 9) {  ! it's a tab character
			buf->cx = ' '; ! now it's a space character
		}
		cx++;
	}

    cx = 0;
    numwords = 0;
    while (cx < len) {
        while (cx < len && buf->cx == ' ') cx++;
        if (cx >= len) break;
        bx = cx;
        if (buf->cx == '.' or ',' or '"') cx++;
        else {
            while (cx < len && buf->cx ~= ' ' or '.' or ',' or '"') cx++;
        }
        tab-->(numwords*3+2) = (cx-bx);
        tab-->(numwords*3+3) = WORDSIZE+bx;
        numwords++;
        if (numwords >= MAX_BUFFER_WORDS) break;
    }
    tab-->0 = numwords;

    ! Now we look each word up in the dictionary.

    dictlen = #dictionary_table-->0;
    entrylen = DICT_WORD_SIZE + 7;

    for (wx=0 : wx<numwords : wx++) {
        wlen = tab-->(wx*3+2);
        wpos = tab-->(wx*3+3);

        ! Copy the word into the gg_tokenbuf array, clipping to DICT_WORD_SIZE
        ! characters and lower case.
        if (wlen > DICT_WORD_SIZE) wlen = DICT_WORD_SIZE;
        cx = wpos - WORDSIZE;
        for (ix=0 : ix<wlen : ix++) gg_tokenbuf->ix = VM_UpperToLowerCase(buf->(cx+ix));
        for (: ix<DICT_WORD_SIZE : ix++) gg_tokenbuf->ix = 0;

        val = #dictionary_table + WORDSIZE;
        @binarysearch gg_tokenbuf DICT_WORD_SIZE val entrylen dictlen 1 1 res;
        tab-->(wx*3+1) = res;
    }
];

[ LTI_Insert i ch  b y;

    ! Protect us from strict mode, as this isn't an array in quite the
    ! sense it expects
    b = buffer;

    ! Insert character ch into buffer at point i.
    ! Being careful not to let the buffer possibly overflow:
    y = b-->0;
    if (y > INPUT_BUFFER_LEN) y = INPUT_BUFFER_LEN;

    ! Move the subsequent text along one character:
    for ( y=y+WORDSIZE : y>i : y-- ) b->y = b->(y-1); ! Tab Removal: spacing fixed to avoid ending I7 include section
    b->i = ch;

    ! And the text is now one character longer:
    if (b-->0 < INPUT_BUFFER_LEN) (b-->0)++;
];

-) instead of "Buffer Functions" in "Glulx.i6t".

Tab Removal ends here.

---- DOCUMENTATION ----

When the player types tabs, this extension replaces them with spaces.

Tabs can appear in commands when typed at the keyboard by the player.  Tabs are handled very badly in the Standard Rules; they are treated as part of a word (like letters).  They can't be printed by Glulx.  This creates all kinds of confusing problems.  This fixes those problems.

The Z-machine implementation is pretty clean and should continue to work in all versions.

The Glulx implementation has been tested with Inform 6M62, but it is dependent on the internals of the Inform implementation.  (This is because of a nasty bug in the implementation of Inform for Glulx which I haven't been able to track down, where it doesn't translate correctly from the input alphabet to the output alphabet.)
