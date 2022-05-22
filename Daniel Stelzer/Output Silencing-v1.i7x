Version 1 of Output Silencing by Daniel Stelzer begins here.

Volume I - Z-machine version (for Z-machine only)

Include (-

[ OutputSilence ;
	@output_stream -1;
];

[ OutputUnsilence ;
	@output_stream 1;
];

-).

Volume II - Glulx version (for Glulx only)

Include (-

Global silence_stream;
Global previous_stream;

[ OutputSilence ;
	if(previous_stream ~= 0) rtrue; ! Already silenced
	silence_stream = glk_stream_open_memory(0, 0, 1, 0);
	previous_stream = glk_stream_get_current();
	glk_stream_set_current(silence_stream);
];

[ OutputUnsilence ;
	if(previous_stream == 0) rtrue; ! Already unsilenced
	glk_stream_set_current(previous_stream);
	@copy $ffffffff sp; ! This is just a stream_close call
	@copy silence_stream sp; ! Because I7 doesn't include a wrapper for it
	@glk $0044 2 0;
	silence_stream = 0;
	previous_stream = 0;
];

-).

Volume III - Non-format-dependent parts

To silence the/all/-- output: (- OutputSilence(); -).
To unsilence the/all/-- output: (- OutputUnsilence(); -).

Output Silencing ends here.
