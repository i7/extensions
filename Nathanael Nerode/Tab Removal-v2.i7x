Version 2.0.220522 of Tab Removal by Nathanael Nerode begins here.

Use authorial modesty.

"For commands with tabs in them, replaces tabs with spaces before passing them on to the game.  Prevents all kinds of confusing weirdness when the player types tabs."

[
Many interpreters unfortunately pass tabs through into the command.  Tabs are treated as *letters* which are part of a word, unhelpfully, which leads to confusing error responses with embedded tabs.  Worse, when Glulxe goes to print the error message with the embedded tab, it issues a runtime error saying that it can't print character 9* (the tab character) -- in the middle of this "word"!  This is a pretty cryptic error message.

By contrast, Glulxe will, hilariously, print "[unicode 9]" with no complaints... it prints a tab! :-)

The implementation for the Z-machine is straightforwardly done with "after reading a command".

But while the straightforward implementation works for the Z-machine, *it fails for Glulx*.  In both glulxe and git, the "\t" regular expression does not match the tab as it should.  It matches tabs inserted into your code using [unicode 9], but not tabs typed at the command line.  I can't figure out why.

So for Glulx we replace the tokenizer.  (We can't replace the tokenizer with the Z-machine because on the Z-machine the tokenizer is on the interpreter-side.)

In Inform v10, the tokenizer is in the BasicInformKit in the Glulx.i6t file, for reference.
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
[ VM_Tokenise buf tab
    cx numwords len bx ix wx wpos wlen val res dictlen entrylen;
    len = buf-->0;
    buf = buf+WORDSIZE;

    ! First, split the buffer up into words. We use the standard Infocom
    ! list of word separators (comma, period, double-quote).

    ! The following was added by the Tab Removal extension.
    ! Tab removal is done here since it can't be matched in I7 due to bugs in Glulxe.
    cx = 0;
    while (cx < len) {
        if (buf->cx == 9) {  ! it's a tab character
            buf->cx = ' '; ! now it's a space character
        }
        cx++;
    }
    ! This ends the changes made by the Tab Removal extension.

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
-) replacing "VM_Tokenise".

Tab Removal ends here.

---- DOCUMENTATION ----

When the player types tabs, this extension replaces them with spaces.

Tabs can appear in commands when typed at the keyboard by the player.  Tabs are handled very badly in the Standard Rules; they are treated as part of a word (like letters).  They can't be printed by Glulx.  This creates all kinds of confusing problems.  This fixes those problems.

The worst problem:  When Glulxe goes to print an error message which contains a tab which originally came from the keyboard, it issues a runtime error saying that it can't print character 9* (the tab character) -- in the middle of this "word"!  This is a pretty cryptic error message, especially since Glulx can actually print tab characters if they're specified in the Inform source code as [unicode 9].

Accordingly, I recommend that everyone use this extension at all times for all games.

The Z-machine implementation is pretty clean and should continue to work in all versions.

The Glulx implementation has been tested with Inform v10.1.0, but it is dependent on the internals of the Inform implementation.  (This is because of a nasty bug in the implementation of Inform for Glulx which I haven't been able to track down, where it doesn't translate correctly from the input alphabet to the output alphabet.)

Changelog:
	2.0.220522: Docs typo fix.
	2.0.220520: Adapt to Inform 7 v10, by changing the method of replacing I6 code.
              Minor documentation updates.  Use authorial modesty on this one.
	1/210314: Change short description.
