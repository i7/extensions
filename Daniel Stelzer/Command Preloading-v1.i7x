Version 1.0.20230916 of Command Preloading (for Glulx only) by Daniel Stelzer begins here.

"A simple way to preload input onto the command line before the player begins to type."

"based on I6 code by Andrew Plotkin"

The preloaded input buffer is initially "".
To empty the preloaded input buffer (this is preload-reset): now the preloaded input buffer is "".
To preload the command (T - text): now the preloaded input buffer is T.

[When you update to a new Inform version, copy all this from Glulx.i6t or Architecture32Kit/InputOutputTemplate as needed; the next update is going to change the parser to use Unicode which will require modifications here]
[The change is right in the middle]

Include (-
[ VM_ReadKeyboard  a_buffer a_table done ix;
    if (gg_commandstr ~= 0 && gg_command_reading ~= false) {
        done = glk_get_line_stream(gg_commandstr, a_buffer+WORDSIZE,
        	(INPUT_BUFFER_LEN-WORDSIZE)-1);
        if (done == 0) {
            glk_stream_close(gg_commandstr, 0);
            gg_commandstr = 0;
            gg_command_reading = false;
        }
        else {
            ! Trim the trailing newline
            if ((a_buffer+WORDSIZE)->(done-1) == 10) done = done-1;
            a_buffer-->0 = done;
            VM_Style(INPUT_VMSTY);
            glk_put_buffer(a_buffer+WORDSIZE, done);
            VM_Style(NORMAL_VMSTY);
            print "^";
            jump KPContinue;
        }
    }
    done = false;
	
	VM_PrintToBuffer(a_buffer, INPUT_BUFFER_LEN-WORDSIZE, TEXT_TY_Say, (+ preloaded input buffer +)); !!! CHANGED
	glk_request_line_event(gg_mainwin, a_buffer+WORDSIZE, INPUT_BUFFER_LEN-WORDSIZE, a_buffer-->0); !!! CHANGED
	((+ preload-reset +)-->1)(); !!! CHANGED
	
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
    if (KIT_CONFIGURATION_BITMAP & ECHO_COMMANDS_TCBIT) {
		print "** ";
		for (ix=WORDSIZE: ix<(a_buffer-->0)+WORDSIZE: ix++) print (char) a_buffer->ix;
		print "^";
	}
];

-) replacing "VM_ReadKeyboard".

Command Preloading ends here.

---- DOCUMENTATION ----

This provides a simple way to preload the command line, so that there are already some letters there in the buffer when the player starts to type.

	preload the command "take "

This phrase puts "take " into the input buffer as though the player had typed it when their next command begins.
