Version 1.2 of Glk Text Formatting (for Glulx only) by Dannii Willis begins here.

"Provides functions for controlling colours and reverse styling at character granularity"

Use authorial modesty.



Section - I6 definitions

Include (-

Constant gestalt_GarglkText = $1100;
Constant zcolor_Default = -1;
Constant zcolor_Current = -2;

[ garglk_set_zcolors _vararg_count;
	! garglk_set_zcolors( fg, bg )
	@glk $1100 _vararg_count 0;
	return 0;
];

[ garglk_set_zcolors_stream _vararg_count;
	! garglk_set_zcolors_stream( str, fg, bg )
	@glk $1101 _vararg_count 0;
	return 0;
];

[ garglk_set_reversevideo _vararg_count;
	! garglk_set_reversevideo( reverse )
	@glk $1102 _vararg_count 0;
	return 0;
];

[ garglk_set_reversevideo_stream _vararg_count;
	! garglk_set_reversevideo_stream( str, reverse )
	@glk $1103 _vararg_count 0;
	return 0;
];

! Borrow the colour conversion function from Glulx Text Effects so that we don't need to depend on it

[ GTF_ConvertColour txt p1 cp1 dsize i ch progress;
	! Transmute the text
	cp1 = txt-->0;
	p1 = TEXT_TY_Temporarily_Transmute( txt );
	dsize = BlkValueLBCapacity( txt );
	for ( i = 0 : i < dsize : i++ )
	{
		! Decode the hex characters
		ch = BlkValueRead( txt, i );
		if ( ch == 0 )
		{
			break;
		}
		else if ( ch > 47 && ch < 58 )
		{
			progress = progress * 16 + ch - 48;
		}
		else if ( ch > 64 && ch < 71 )
		{
			progress = progress * 16 + ch - 55;
		}
		else if ( ch > 96 && ch < 103 )
		{
			progress = progress * 16 + ch - 87;
		}
	}
	! Clean up and return
	TEXT_TY_Untransmute( txt, p1, cp1 );
	return progress;
];

-) before "Glulx.i6t".



Section - Text formatting phrases

To decide whether glk/-- text formatting is supported:
	(- glk_gestalt( gestalt_GarglkText, 0 ) -).

To set foreground/fg/-- color/colour (N - a text):
	(- garglk_set_zcolors( GTF_ConvertColour( {-by-reference:N} ), zcolor_Current ); -).

To set background/bg color/colour (N - a text):
	(- garglk_set_zcolors( zcolor_Current, GTF_ConvertColour( {-by-reference:N} ) ); -).

To reset the/-- foreground/fg color/colour:
	(- garglk_set_zcolors( zcolor_Default, zcolor_Current ); -).

To reset the/-- background/bg color/colour:
	(- garglk_set_zcolors( zcolor_Current, zcolor_Default ); -).

To set reverse mode/-- on:
	(- garglk_set_reversevideo( 1 ); -).

To set reverse mode/-- off:
	(- garglk_set_reversevideo( 0 ); -).

To say reverse mode/-- on:
	(- garglk_set_reversevideo( 1 ); -).

To say reverse mode/-- off:
	(- garglk_set_reversevideo( 0 ); -).



Glk Text Formatting ends here.



---- Documentation ----

Glk Text Formatting allows you to control text colours and reverse mode at character granularity. Instead of only having one colour per style, you can now manually specify colours for each paragraph, sentence, word, or even single character.

Glk Text Formatting uses non-standard Glk functions specified at <https://curiousdannii.github.io/if/gargoyle.html>. At present, they are supported only in Windows Glulxe/Git. Gargoyle will support these functions in its next release.

It is strongly recommended that you test whether these functions are supported before using them. If you do not your interpreter may raise a fatal error.

	if glk text formatting is supported:
		say "[reverse mode on]Reversed![reverse mode off]";

Phrases are provided to set the foreground and background colours, as well as turning on and off reverse mode. Colours are specified as CSS colours (just as you would with Glulxe Text Effects).

	set color/colour "#FF0000";
	set background/bg color/colour: "#0000FF";
	reset the foreground/fg color/colour;
	reset the background/bg color/colour;
	set reverse mode on;
	set reverse mode off;
	say reverse mode on;
	say reverse mode off;

The latest version of this extension can be found at <https://github.com/i7/extensions>. This extension is released under the Creative Commons Attribution licence. Bug reports, feature requests or questions can be made at <https://github.com/i7/extensions/issues>.



Example: * Rainbow and space invader

	*: "Rainbow and space invader"

	Include Version 1 of Glk Text Formatting by Dannii Willis.

	The Show Case is a room. "This is the show case for Glk Text Formatting.

[if glk text formatting is supported]Here is a pretty rainbow:

[rainbow]

And here is a space invader:

[space invader][otherwise]Your interpreter does not support Glk text formatting.[end if]".

	To say rainbow:
		let the rainbow colours be {"#ff0000", "#ff3000", "#ff6000", "#ff9000", "#ffc000", "#fff000", "#deff00", "#aeff00", "#7eff00", "#4eff00", "#1eff00", "#00ff12", "#00ff42", "#00ff72", "#00ffa2", "#00ffd2", "#00fcff", "#00ccff", "#009cff", "#006cff", "#003cff", "#000cff", "#2400ff", "#5400ff", "#8400ff", "#b400ff", "#e400ff", "#ff00ea", "#ff00ba", "#ff008a", "#ff005a", "#ff002a"};
		say "[fixed letter spacing][reverse mode on]";
		repeat with C running through the rainbow colours:
			set color C;
			say "  ";
		reset fg color;
		say "[reverse mode off][variable letter spacing]";

	To say space invader:
		say "[fixed letter spacing]    [reverse on]  [reverse off]          [reverse on]  [reverse off]
[line break]      [reverse on]  [reverse off]      [reverse on]  [reverse off]
[line break]    [reverse on]              [reverse off]
[line break]  [reverse on]    [reverse off]  [reverse on]      [reverse off]  [reverse on]    [reverse off]
[line break][reverse on]                      [reverse off]
[line break][reverse on]  [reverse off]  [reverse on]              [reverse off]  [reverse on]  [reverse off]
[line break][reverse on]  [reverse off]  [reverse on]  [reverse off]          [reverse on]  [reverse off]  [reverse on]  [reverse off]
[line break]      [reverse on]    [reverse off]  [reverse on]    [reverse off]
[line break][variable letter spacing]".
