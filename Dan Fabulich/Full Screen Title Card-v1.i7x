Version 1.0 of Full Screen Title Card (for Glulx only) by Dan Fabulich begins here.

"A full-screen text-grid title card."

Use authorial modesty.



Section - Colors

The full-screen title card window color is a text that varies.
The full-screen title card window color is usually "".

The full-screen title card background color is a text that varies.
The full-screen title card background color is usually "".

The full-screen title card text color is a text that varies.
The full-screen title card text color is usually "".

The full-screen title card surrounding text color is a text that varies.
The full-screen title card surrounding text color is usually "".

The full-screen title card hyperlink color is a text that varies.
The full-screen title card hyperlink color is usually "".

To set the/-- full-screen title card window color to (C - text):
	now the full-screen title card window color is C.

To set the/-- full-screen title card background color to (C - text):
	now the full-screen title card background color is C.

To set the/-- full-screen title card text color to (C - text):
	now the full-screen title card text color is C.

To set the/-- full-screen title card surrounding text color to (C - text):
	now the full-screen title card surrounding text color is C.

To set the/-- full-screen title card hyperlink color to (C - text):
	now the full-screen title card hyperlink color is C.



Section - Optional text

The full-screen title card text before is a text that varies.
The full-screen title card text before is usually "".

The full-screen title card text after is a text that varies.
The full-screen title card text after is usually "".

The full-screen title card continue prompt is a text that varies.
The full-screen title card continue prompt is usually "Press any key to continue.".

To set the/-- full-screen title card text before to (T - text):
	now the full-screen title card text before is T.

To set the/-- full-screen title card text after to (T - text):
	now the full-screen title card text after is T.

To set the/-- full-screen title card continue prompt to (T - text):
	now the full-screen title card continue prompt is T.



Section - Phrases

To display a/-- full-screen title card (T - text):
	perform the full-screen title card with T.



Section - Helper - unindexed

To perform the/-- full-screen title card with (T - text):
	(- TitleCard_Display({-by-reference:T}); -).



Section - Type styles - unindexed

[ TODO: Only bold is supported. Italic is mapped to bold. True italic and
bold+italic would need more Glk styles than we can spare for in-card vs
out-of-card colors. ]
To say bold type -- running on:
	(- TitleCard_ApplyBold(); -).
To say italic type -- running on:
	(- TitleCard_ApplyItalic(); -).
To say roman type -- running on:
	(- TitleCard_ApplyRoman(); -).



Section - I6 implementation - unindexed

Include (-

Constant TitleCard_HorizontalPadding = 2;
Constant TitleCard_ContinueLinkValue = 1;
Constant TitleCard_MAP_OFF = 0;
Constant TitleCard_MAP_OUTSIDE = 1;
Constant TitleCard_MAP_CARD = 2;

! Style remapping while a title card is printing.
Global TitleCard_style_map = 0;

[ TitleCard_ApplyBold;
	! [bold type] → Subheader normally; remapped while a title card prints.
	! Outside uses Subheader (Lectrote CSS: font-weight bold). Emphasized is italic
	! in Lectrote's stylesheet, so we must not use it for bold.
	if (TitleCard_style_map == TitleCard_MAP_CARD) {
		glk_set_style(style_User2);
	} else if (TitleCard_style_map == TitleCard_MAP_OUTSIDE) {
		glk_set_style(style_Subheader);
	} else {
		style bold;
	}
];

[ TitleCard_ApplyItalic;
	! TODO: italic is treated as bold (see Section - Type styles).
	TitleCard_ApplyBold();
];

[ TitleCard_ApplyRoman;
	! Card → BlockQuote (Lectrote CSS gives blockquote a background fill).
	! Outside → User1 (no default background in Lectrote CSS).
	if (TitleCard_style_map == TitleCard_MAP_CARD) {
		glk_set_style(style_BlockQuote);
	} else if (TitleCard_style_map == TitleCard_MAP_OUTSIDE) {
		glk_set_style(style_User1);
	} else {
		style roman;
	}
];

! Scratch results from TitleCard_MeasureText
Global TitleCard_measured_line_count = 0;
Global TitleCard_measured_max_width = 0;

Global TitleCard_card_line_count = 0;
Global TitleCard_card_max_width = 0;
Global TitleCard_before_line_count = 0;
Global TitleCard_before_max_width = 0;
Global TitleCard_after_line_count = 0;
Global TitleCard_after_max_width = 0;
Global TitleCard_prompt_line_count = 0;
Global TitleCard_prompt_max_width = 0;

Global TitleCard_window_background = 0;
Global TitleCard_card_background = 0;
Global TitleCard_card_text_color = 0;
Global TitleCard_surrounding_text_color = 0;
Global TitleCard_hyperlink_text_color = 0;
Global TitleCard_default_background = 0;
Global TitleCard_default_foreground = 0;

! Glulx iosys filter state for printing packed texts with [bold]/[italic] while recentering.
Global TitleCard_filter_base_col = 0;
Global TitleCard_filter_row = 0;
Global TitleCard_filter_left_pad = 0;
Global TitleCard_filter_right_pad = 0;
Global TitleCard_filter_line_width = 0;
Global TitleCard_filter_col_count = 0;
Global TitleCard_filter_saw_cr = 0;

[ TitleCard_ColorFromText text_value default_color
	packed_type old_packing capacity index character rgb_value;
	if (TEXT_TY_Empty(text_value)) {
		return default_color;
	}
	packed_type = text_value-->0;
	old_packing = TEXT_TY_Temporarily_Transmute(text_value);
	capacity = BlkValueLBCapacity(text_value);
	rgb_value = 0;
	for (index = 0 : index < capacity : index++) {
		character = BlkValueRead(text_value, index);
		if (character == 0) {
			break;
		} else if (character > 47 && character < 58) {
			rgb_value = rgb_value * 16 + character - 48;
		} else if (character > 64 && character < 71) {
			rgb_value = rgb_value * 16 + character - 55;
		} else if (character > 96 && character < 103) {
			rgb_value = rgb_value * 16 + character - 87;
		}
	}
	TEXT_TY_Untransmute(text_value, old_packing, packed_type);
	return rgb_value;
];

[ TitleCard_MixColors background_color foreground_color
	back_red back_green back_blue fore_red fore_green fore_blue;
	! 85% background + 15% foreground
	back_red = (background_color / $10000) & $FF;
	back_green = (background_color / $100) & $FF;
	back_blue = background_color & $FF;
	fore_red = (foreground_color / $10000) & $FF;
	fore_green = (foreground_color / $100) & $FF;
	fore_blue = foreground_color & $FF;
	return
		((((back_red * 85) + (fore_red * 15)) / 100) * $10000) +
		((((back_green * 85) + (fore_green * 15)) / 100) * $100) +
		(((back_blue * 85) + (fore_blue * 15)) / 100);
];

[ TitleCard_MeasureDefaultColors;
	! Fallback when style_measure is unavailable (e.g. Parchment): black on white.
	TitleCard_default_background = $FFFFFF;
	TitleCard_default_foreground = 0;
	if (gg_mainwin == 0) {
		return;
	}
	if (glk_style_measure(gg_mainwin, style_Normal, stylehint_BackColor, gg_arguments)) {
		TitleCard_default_background = gg_arguments-->0;
	}
	if (glk_style_measure(gg_mainwin, style_Normal, stylehint_TextColor, gg_arguments)) {
		TitleCard_default_foreground = gg_arguments-->0;
	}
];

[ TitleCard_SetupColors;
	! Call while the stock main window still exists so style_measure works.
	TitleCard_MeasureDefaultColors();
	TitleCard_window_background = TitleCard_ColorFromText(
		(+ full-screen title card window color +), TitleCard_default_background);
	TitleCard_card_text_color = TitleCard_ColorFromText(
		(+ full-screen title card text color +), TitleCard_default_foreground);
	TitleCard_surrounding_text_color = TitleCard_ColorFromText(
		(+ full-screen title card surrounding text color +), TitleCard_default_foreground);
	TitleCard_hyperlink_text_color = TitleCard_ColorFromText(
		(+ full-screen title card hyperlink color +), TitleCard_default_foreground);
	TitleCard_card_background = TitleCard_ColorFromText(
		(+ full-screen title card background color +),
		TitleCard_MixColors(TitleCard_default_background, TitleCard_default_foreground));
];

[ TitleCard_ApplyStylehints;
	! Spatterlight paints hyperlinks with style_Normal's TextColor (linkTextAttributes).
	! Style map (hints apply when the grid is created):
	!   Normal     = continue prompt / hyperlink color
	!   User1      = surrounding text (outside the card)
	!   BlockQuote = normal text inside the card
	!   User2      = bold inside the card
	!   Subheader  = bold outside the card ([italic type] is also mapped here)
	! Lectrote/Quixe ignore stylehints; their CSS already gives BlockQuote a
	! background and Subheader bold weight, so this map still degrades usefully.
	! TODO: In-card bold (User2) has no Lectrote CSS background, so bold spans show as
	! white holes on the card — fixable only in Lectrote/Quixe, not here.
	! TODO: italic is coerced to bold; true italic / bold+italic need more styles.
	glk_stylehint_set(wintype_TextGrid, style_Normal, stylehint_ReverseColor, 0);
	glk_stylehint_set(wintype_TextGrid, style_User1, stylehint_ReverseColor, 0);
	glk_stylehint_set(wintype_TextGrid, style_BlockQuote, stylehint_ReverseColor, 0);
	glk_stylehint_set(wintype_TextGrid, style_User2, stylehint_ReverseColor, 0);
	glk_stylehint_set(wintype_TextGrid, style_Subheader, stylehint_ReverseColor, 0);

	glk_stylehint_set(wintype_TextGrid, style_Normal, stylehint_BackColor, TitleCard_window_background);
	glk_stylehint_set(wintype_TextGrid, style_Normal, stylehint_TextColor, TitleCard_hyperlink_text_color);

	glk_stylehint_set(wintype_TextGrid, style_User1, stylehint_BackColor, TitleCard_window_background);
	glk_stylehint_set(wintype_TextGrid, style_User1, stylehint_TextColor, TitleCard_surrounding_text_color);

	glk_stylehint_set(wintype_TextGrid, style_BlockQuote, stylehint_BackColor, TitleCard_card_background);
	glk_stylehint_set(wintype_TextGrid, style_BlockQuote, stylehint_TextColor, TitleCard_card_text_color);

	glk_stylehint_set(wintype_TextGrid, style_User2, stylehint_BackColor, TitleCard_card_background);
	glk_stylehint_set(wintype_TextGrid, style_User2, stylehint_TextColor, TitleCard_card_text_color);
	glk_stylehint_set(wintype_TextGrid, style_User2, stylehint_Weight, 1);
	glk_stylehint_set(wintype_TextGrid, style_User2, stylehint_Oblique, 0);

	glk_stylehint_set(wintype_TextGrid, style_Subheader, stylehint_BackColor, TitleCard_window_background);
	glk_stylehint_set(wintype_TextGrid, style_Subheader, stylehint_TextColor, TitleCard_surrounding_text_color);
	glk_stylehint_set(wintype_TextGrid, style_Subheader, stylehint_Weight, 1);
	glk_stylehint_set(wintype_TextGrid, style_Subheader, stylehint_Oblique, 0);
];

[ TitleCard_ClearStylehints;
	! Avoid leaking colors into the restored status line (also a text grid).
	glk_stylehint_clear(wintype_TextGrid, style_Normal, stylehint_ReverseColor);
	glk_stylehint_clear(wintype_TextGrid, style_User1, stylehint_ReverseColor);
	glk_stylehint_clear(wintype_TextGrid, style_BlockQuote, stylehint_ReverseColor);
	glk_stylehint_clear(wintype_TextGrid, style_User2, stylehint_ReverseColor);
	glk_stylehint_clear(wintype_TextGrid, style_Subheader, stylehint_ReverseColor);
	glk_stylehint_clear(wintype_TextGrid, style_Normal, stylehint_BackColor);
	glk_stylehint_clear(wintype_TextGrid, style_Normal, stylehint_TextColor);
	glk_stylehint_clear(wintype_TextGrid, style_User1, stylehint_BackColor);
	glk_stylehint_clear(wintype_TextGrid, style_User1, stylehint_TextColor);
	glk_stylehint_clear(wintype_TextGrid, style_BlockQuote, stylehint_BackColor);
	glk_stylehint_clear(wintype_TextGrid, style_BlockQuote, stylehint_TextColor);
	glk_stylehint_clear(wintype_TextGrid, style_User2, stylehint_BackColor);
	glk_stylehint_clear(wintype_TextGrid, style_User2, stylehint_TextColor);
	glk_stylehint_clear(wintype_TextGrid, style_User2, stylehint_Weight);
	glk_stylehint_clear(wintype_TextGrid, style_User2, stylehint_Oblique);
	glk_stylehint_clear(wintype_TextGrid, style_Subheader, stylehint_BackColor);
	glk_stylehint_clear(wintype_TextGrid, style_Subheader, stylehint_TextColor);
	glk_stylehint_clear(wintype_TextGrid, style_Subheader, stylehint_Weight);
	glk_stylehint_clear(wintype_TextGrid, style_Subheader, stylehint_Oblique);
];

[ TitleCard_MeasureText text_value
	packed_type old_packing capacity index character
	line_length max_width line_count ended_with_newline;
	! Sets TitleCard_measured_line_count and TitleCard_measured_max_width. Empty text => 0 lines.
	packed_type = text_value-->0;
	old_packing = TEXT_TY_Temporarily_Transmute(text_value);
	capacity = BlkValueLBCapacity(text_value);
	TitleCard_measured_line_count = 0;
	TitleCard_measured_max_width = 0;
	if (capacity == 0 || BlkValueRead(text_value, 0) == 0) {
		TEXT_TY_Untransmute(text_value, old_packing, packed_type);
		return;
	}
	line_count = 0;
	max_width = 0;
	line_length = 0;
	ended_with_newline = true;
	for (index = 0 : index < capacity : index++) {
		character = BlkValueRead(text_value, index);
		if (character == 0) {
			break;
		}
		if (character == 10 or 13) {
			if (character == 13 && (index + 1) < capacity && BlkValueRead(text_value, index + 1) == 10) {
				index++;
			}
			if (line_length > max_width) {
				max_width = line_length;
			}
			line_count++;
			line_length = 0;
			ended_with_newline = true;
		} else {
			line_length++;
			ended_with_newline = false;
		}
	}
	if (~~ended_with_newline) {
		if (line_length > max_width) {
			max_width = line_length;
		}
		line_count++;
	}
	TEXT_TY_Untransmute(text_value, old_packing, packed_type);
	TitleCard_measured_line_count = line_count;
	TitleCard_measured_max_width = max_width;
];

[ TitleCard_EmitSpaces count;
	while (count > 0) {
		print (char) ' ';
		count--;
	}
];

[ TitleCard_FilterPutChar ch;
	if (unicode_gestalt_ok) {
		glk_put_char_uni(ch);
	} else {
		if (ch > 255) {
			ch = '?';
		}
		glk_put_char(ch);
	}
];

[ TitleCard_FilterFinishLine i;
	while (TitleCard_filter_col_count < TitleCard_filter_line_width) {
		TitleCard_FilterPutChar(' ');
		TitleCard_filter_col_count++;
	}
	for (i = 0 : i < TitleCard_filter_right_pad : i++) {
		TitleCard_FilterPutChar(' ');
	}
];

[ TitleCard_FilterStartLine i;
	TitleCard_filter_col_count = 0;
	glk_window_move_cursor(gg_mainwin, TitleCard_filter_base_col, TitleCard_filter_row);
	for (i = 0 : i < TitleCard_filter_left_pad : i++) {
		TitleCard_FilterPutChar(' ');
	}
];

[ TitleCard_CharFilter ch;
	! Glulx iosys mode 1: every printed character arrives here. Style changes
	! (bold/italic/roman) are glk_set_style calls and bypass this filter.
	if (ch == 13) {
		TitleCard_filter_saw_cr = true;
		return;
	}
	if (ch == 10) {
		TitleCard_filter_saw_cr = false;
		TitleCard_FilterFinishLine();
		TitleCard_filter_row++;
		TitleCard_FilterStartLine();
		return;
	}
	TitleCard_filter_saw_cr = false;
	if (TitleCard_filter_col_count < TitleCard_filter_line_width) {
		TitleCard_FilterPutChar(ch);
		TitleCard_filter_col_count++;
	}
];

[ TitleCard_PrintStyled text_value base_col start_row left_pad right_pad line_width
	packed_type;
	! Print a packed text with say-substitutions (bold/italic) active. Newlines
	! re-anchor at base_col with left_pad, and each line is padded to line_width
	! then right_pad (for the card's inner margins).
	if (TEXT_TY_Empty(text_value)) {
		return;
	}
	TitleCard_filter_base_col = base_col;
	TitleCard_filter_row = start_row;
	TitleCard_filter_left_pad = left_pad;
	TitleCard_filter_right_pad = right_pad;
	TitleCard_filter_line_width = line_width;
	TitleCard_filter_saw_cr = false;
	TitleCard_FilterStartLine();
	@push say__p; @push say__pc;
	ClearParagraphing(0);
	packed_type = text_value-->0;
	if (packed_type & BLK_BVBITMAP_LONGBLOCKMASK) {
		! Already unpacked: no style runs available; print characters only.
		TEXT_TY_Say(text_value);
	} else {
		@setiosys 1 TitleCard_CharFilter;
		PrintI6Text(text_value-->1);
		@setiosys 2 0;
	}
	@pull say__pc; @pull say__p;
	! If the text did not end with a newline, pad the final in-progress line.
	if (TitleCard_filter_col_count > 0) {
		TitleCard_FilterFinishLine();
	}
];

[ TitleCard_FillGrid window width height  column row;
	glk_window_clear(window);
	glk_set_window(window);
	glk_set_style(style_Normal);
	for (row = 0 : row < height : row++) {
		glk_window_move_cursor(window, 0, row);
		for (column = 0 : column < width : column++) {
			print (char) ' ';
		}
	}
];

[ TitleCard_DrawCenteredBlock window text_value start_row line_count max_width screen_width
	glk_style hyperlink_value  left_column;
	if (line_count < 1) {
		return;
	}
	if (max_width > screen_width) {
		max_width = screen_width;
	}
	left_column = (screen_width - max_width) / 2;
	if (left_column < 0) {
		left_column = 0;
	}
	if (glk_style == style_Normal) {
		TitleCard_style_map = TitleCard_MAP_OFF;
	} else {
		TitleCard_style_map = TitleCard_MAP_OUTSIDE;
	}
	glk_set_style(glk_style);
	if (hyperlink_value && glk_gestalt(gestalt_Hyperlinks, 0)) {
		glk_set_hyperlink(hyperlink_value);
	}
	TitleCard_PrintStyled(text_value, left_column, start_row, 0, 0, max_width);
	if (hyperlink_value && glk_gestalt(gestalt_Hyperlinks, 0)) {
		glk_set_hyperlink(0);
	}
	TitleCard_style_map = TitleCard_MAP_OFF;
	glk_set_style(style_Normal);
];

[ TitleCard_DrawCard window text_value start_column start_row card_width;
	TitleCard_style_map = TitleCard_MAP_CARD;
	glk_set_style(style_BlockQuote);
	glk_window_move_cursor(window, start_column, start_row);
	TitleCard_EmitSpaces(card_width);

	TitleCard_PrintStyled(text_value, start_column, start_row + 1,
		TitleCard_HorizontalPadding, TitleCard_HorizontalPadding,
		TitleCard_card_max_width);

	glk_window_move_cursor(window, start_column,
		start_row + 1 + TitleCard_card_line_count);
	TitleCard_EmitSpaces(card_width);
	TitleCard_style_map = TitleCard_MAP_OFF;
	glk_set_style(style_Normal);
];

[ TitleCard_CloseQuoteWindow;
	if (gg_quotewin) {
		glk_window_close(gg_quotewin, 0);
		gg_quotewin = 0;
	}
];

[ TitleCard_HyperlinksSupported;
	if (glk_gestalt(gestalt_Hyperlinks, 0) == 0) {
		rfalse;
	}
	if (glk_gestalt(gestalt_HyperlinkInput, wintype_TextGrid) == 0) {
		rfalse;
	}
	rtrue;
];

[ TitleCard_WaitForDismiss  finished handle_result;
	glk_request_char_event(gg_mainwin);
	if (TitleCard_HyperlinksSupported()) {
		glk_request_hyperlink_event(gg_mainwin);
	}
	finished = false;
	while (~~finished) {
		glk_select(gg_event);
		switch (gg_event-->0) {
		  evtype_Arrange:
			;
		  evtype_CharInput:
			if (gg_event-->1 == gg_mainwin) {
				finished = true;
			}
		  evtype_Hyperlink:
			if (gg_event-->1 == gg_mainwin && gg_event-->2 == TitleCard_ContinueLinkValue) {
				finished = true;
			}
		}
		handle_result = HandleGlkEvent(gg_event, 1, gg_arguments);
		if (handle_result == 2) {
			finished = true;
		} else if (handle_result == -1) {
			finished = false;
		}
	}
	glk_cancel_char_event(gg_mainwin);
	if (TitleCard_HyperlinksSupported()) {
		glk_cancel_hyperlink_event(gg_mainwin);
	}
];

[ TitleCard_EnterFullScreen  grid_window;
	TitleCard_CloseQuoteWindow();
	if (gg_statuswin) {
		glk_window_close(gg_statuswin, 0);
		gg_statuswin = 0;
	}
	if (gg_mainwin) {
		glk_cancel_char_event(gg_mainwin);
		glk_cancel_line_event(gg_mainwin, GLK_NULL);
		if (TitleCard_HyperlinksSupported()) {
			glk_cancel_hyperlink_event(gg_mainwin);
		}
		glk_window_close(gg_mainwin, 0);
		gg_mainwin = 0;
	}
	TitleCard_ApplyStylehints();
	grid_window = glk_window_open(0, 0, 0, wintype_TextGrid, GG_MAINWIN_ROCK);
	gg_mainwin = grid_window;
	if (grid_window == 0) {
		rfalse;
	}
	glk_set_window(grid_window);
	rtrue;
];

[ TitleCard_LeaveFullScreen;
	if (gg_mainwin) {
		glk_cancel_char_event(gg_mainwin);
		if (TitleCard_HyperlinksSupported()) {
			glk_cancel_hyperlink_event(gg_mainwin);
		}
		glk_window_close(gg_mainwin, 0);
		gg_mainwin = 0;
	}
	TitleCard_ClearStylehints();
	gg_mainwin = glk_window_open(0, 0, 0, wintype_TextBuffer, GG_MAINWIN_ROCK);
	if (gg_mainwin == 0) {
		quit;
	}
	if (gg_scriptstr) {
		glk_window_set_echo_stream(gg_mainwin, gg_scriptstr);
	}
	gg_statuswin = glk_window_open(gg_mainwin, winmethod_Fixed + winmethod_Above,
		statuswin_cursize, wintype_TextGrid, GG_STATUSWIN_ROCK);
	glk_set_window(gg_mainwin);
	DrawStatusLine();
];

[ TitleCard_Display card_text
	screen_width screen_height card_width card_height total_height
	current_row card_left_column text_before text_after continue_prompt gap_before_card;
	TitleCard_SetupColors();

	text_before = (+ full-screen title card text before +);
	text_after = (+ full-screen title card text after +);
	continue_prompt = (+ full-screen title card continue prompt +);

	TitleCard_MeasureText(card_text);
	TitleCard_card_line_count = TitleCard_measured_line_count;
	TitleCard_card_max_width = TitleCard_measured_max_width;
	if (TitleCard_card_line_count < 1) {
		rfalse;
	}

	TitleCard_MeasureText(text_before);
	TitleCard_before_line_count = TitleCard_measured_line_count;
	TitleCard_before_max_width = TitleCard_measured_max_width;

	TitleCard_MeasureText(text_after);
	TitleCard_after_line_count = TitleCard_measured_line_count;
	TitleCard_after_max_width = TitleCard_measured_max_width;

	TitleCard_MeasureText(continue_prompt);
	TitleCard_prompt_line_count = TitleCard_measured_line_count;
	TitleCard_prompt_max_width = TitleCard_measured_max_width;

	if (TitleCard_EnterFullScreen() == 0) {
		rfalse;
	}
	glk_window_get_size(gg_mainwin, gg_arguments, gg_arguments + WORDSIZE);
	screen_width = gg_arguments-->0;
	screen_height = gg_arguments-->1;
	if (screen_width < 8) { screen_width = 80; }
	if (screen_height < 4) { screen_height = 24; }

	if (TitleCard_before_max_width > screen_width) {
		TitleCard_before_max_width = screen_width;
	}
	if (TitleCard_after_max_width > screen_width) {
		TitleCard_after_max_width = screen_width;
	}
	if (TitleCard_prompt_max_width > screen_width) {
		TitleCard_prompt_max_width = screen_width;
	}

	card_width = TitleCard_card_max_width + (TitleCard_HorizontalPadding * 2);
	if (card_width > screen_width) {
		TitleCard_card_max_width = screen_width - (TitleCard_HorizontalPadding * 2);
		if (TitleCard_card_max_width < 1) {
			TitleCard_card_max_width = 1;
		}
		card_width = TitleCard_card_max_width + (TitleCard_HorizontalPadding * 2);
	}
	card_height = TitleCard_card_line_count + (TitleCard_HorizontalPadding * 2);

	total_height = 0;
	gap_before_card = 0;
	if (TitleCard_before_line_count > 0) {
		total_height = total_height + TitleCard_before_line_count;
		gap_before_card = 1;
	}
	if (gap_before_card) {
		total_height++;
	}
	total_height = total_height + card_height;
	if (TitleCard_after_line_count > 0) {
		total_height++;
		total_height = total_height + TitleCard_after_line_count;
	}
	if (TitleCard_prompt_line_count > 0) {
		total_height++;
		total_height = total_height + TitleCard_prompt_line_count;
	}

	if (total_height > screen_height) {
		! Prefer keeping the card; still draw what fits starting at row 0.
		current_row = 0;
	} else {
		current_row = (screen_height - total_height) / 2;
	}
	card_left_column = (screen_width - card_width) / 2;
	if (card_left_column < 0) { card_left_column = 0; }

	TitleCard_FillGrid(gg_mainwin, screen_width, screen_height);

	if (TitleCard_before_line_count > 0) {
		TitleCard_DrawCenteredBlock(gg_mainwin, text_before, current_row,
			TitleCard_before_line_count, TitleCard_before_max_width, screen_width,
			style_User1, 0);
		current_row = current_row + TitleCard_before_line_count + 1;
	}

	TitleCard_DrawCard(gg_mainwin, card_text, card_left_column, current_row, card_width);
	current_row = current_row + card_height;

	if (TitleCard_after_line_count > 0) {
		current_row++;
		TitleCard_DrawCenteredBlock(gg_mainwin, text_after, current_row,
			TitleCard_after_line_count, TitleCard_after_max_width, screen_width,
			style_User1, 0);
		current_row = current_row + TitleCard_after_line_count;
	}

	if (TitleCard_prompt_line_count > 0) {
		current_row++;
		TitleCard_DrawCenteredBlock(gg_mainwin, continue_prompt, current_row,
			TitleCard_prompt_line_count, TitleCard_prompt_max_width, screen_width,
			style_Normal, TitleCard_ContinueLinkValue);
		current_row = current_row + TitleCard_prompt_line_count;
	} else if (TitleCard_after_line_count == 0) {
		! No prompt and no text-after: leave a blank line under the card.
		current_row++;
	}

	! Parchment (and similar) put the char-input field at the Glk cursor.
	! Park it on the line after the prompt, or after text-after, or two lines
	! below the card when neither is shown — never flush beside the card.
	if (current_row >= screen_height) {
		current_row = screen_height - 1;
	}
	if (current_row < 0) {
		current_row = 0;
	}
	glk_window_move_cursor(gg_mainwin, 0, current_row);

	TitleCard_WaitForDismiss();

	TitleCard_LeaveFullScreen();
];

-) .



Full Screen Title Card ends here.

---- DOCUMENTATION ----

Full Screen Title Card temporarily replaces the usual status line and main text buffer with a single text-grid window, draws a preformatted card centered horizontally and vertically (optionally with text above and below), waits for a keypress, then restores the stock windows.

Full-screen mode assumes Inform's usual two-window layout. It is not integrated with Flexible Windows.

Use it like this:

	display a full-screen title card "First line[line break]Second line";

The phrase restores the stock main text buffer and status line. Scrollback from before the takeover is discarded when the main window is closed. Authors should probably follow with "try looking" so play continues with a fresh room description.

	Displaying full-screen is an action applying to nothing.
	Understand "full screen" as displaying full-screen.

	Carry out displaying full-screen:
		display a full-screen title card "First line[line break]Second line";
		try looking.

Section: Text around the card

Optional captions sit above and below the card, in the surrounding text color:

	The full-screen title card text before is "Chapter One".
	The full-screen title card text after is "London, 1897".

Leave them as "" (the default) to omit them.

"[bold type]" and "[italic type]" both render as bold (with "[roman type]" returning to the surrounding style). True italic and bold+italic are not supported — that would need more Glk styles than we can use for separate in-card and out-of-card colors.

Below that, a continue prompt is shown in the hyperlink color. When the interpreter supports hyperlinks, the prompt is also a clickable link (any key still dismisses the card):

	The full-screen title card continue prompt is "Press any key to continue.".

Set the continue prompt to "" to hide it.

Section: Colors

By default, the card background is an 85%/15% mix of the default normal background color and text color (e.g. a light grey if the background is white and the text is black).

To override, set CSS hex strings like this:

	The full-screen title card window color is "#f4f1e8".
	The full-screen title card background color is "#f2c4d0".
	The full-screen title card text color is "#0b1026".
	The full-screen title card surrounding text color is "#4a4640".
	The full-screen title card hyperlink color is "#7ec8e3".

(Note that some interpreters don't honor the hyperlink color, always showing hyperlinks in their default color. Test your colors in Gargoyle.)

Example: * Full Screen Title Card Example

	*: "Full Screen Title Card Example"

	Include Full Screen Title Card by Dan Fabulich.

	The Lab is a room. "Type 'full screen'."

	Displaying full-screen is an action applying to nothing.
	Understand "full screen" as displaying full-screen.

	Carry out displaying full-screen:
		now the full-screen title card text before is "A reading from";
		now the full-screen title card text after is "-- Through the Looking-Glass";
		display a full-screen title card "And 'the wabe' is the grass-plot round[line break]a sun-dial, I suppose? said Alice,[line break]surprised at her own ingenuity.";
		try looking.
