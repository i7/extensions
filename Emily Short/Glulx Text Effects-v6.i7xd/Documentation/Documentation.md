Glulx Text Effects provides an easy way to set up special text effects for Glulx.

Styles in Glulx
---------------

Unlike the Z-Machine, which allows arbitrary combinations of features (such as color and boldness) to be applied to text, Glulx requires the author to define and then use text styles. (Though note that through a common extension of Glk, per-character formatting is now supported in many Glulx interpreters).

There are eleven of these styles:

| Style name | Explanation |
|------------|-------------|
| normal-style | the style used for regular text |
| italic-style | used for italic text (this is what the `[italic type]` phrase uses) |
| bold-style | used for bold text (this is what the `[bold type]` phrase uses) |
| fixed-letter-spacing-style | used for monospaced text (this is what the `[fixed letter spacing]` phrase uses) |
| alert-style | used when printing an end of game message such as "\*\*\* You have died. \*\*\*" |
| blockquote-style | used for printing box quotations |
| header-style | used to print the title of the game |
| input-style | used for the player's own input |
| note-style | used for messages such as "[Your score has increased by one point.]" |
| special-style-1 | these two styles are not used by Inform, and you are free to use them for any purpose you want |
| special-style-2 | |

Additionally, when defining styles you can set `all-styles` which will define all eleven styles at once.

Defining styles
---------------

To define the appearance of each style, add a table continuation to the Table of User Styles in your code. For example:

```
Table of User Styles (continued)
window	style name	color	italic	relative size
all-buffer-windows	all-styles	#FF0000	true	--
all-buffer-windows	header-style	#0000FF	false	1
all-buffer-windows	special-style-1	#00FF00
```

This definition table above will make everything red and italics, except for the title (header) which will be blue and a size bigger. Special style 1 is set to green, but it won't be used without the author manually turning it on.

Your table continuation does not need to include every column in the Table of User Styles, nor does it need to define every style. You can also continue the table multiple times, and even define a style in multiple places; if you do then the definitions will be combined together. If you do not want to set a feature for a style you can leave it blank with `--`.

Styles are applied from most general to most specific. So `all-windows` styles are applied before `all-buffer-windows` styles, and `all-styles` before a specific style like `header-style`.

Specifying styles through table columns
---------------------------------------

Each row of the Table of User Styles can have the following columns:

| Feature | Kind | Explanation |
|---------|------|-------------|
| window | glk window | specifies which type of window to apply the styles to. Can be set to `all-windows`, `all-buffer-windows` (the default), or `all-grid-windows`. (Setting to a specific window, such as the `main window`, is not supported in this extension, but is supported in Flexible Windows by Jon Ingold.) |
| background color | RGB colour | specifies the background color of the text |
| color | RGB colour | specifies the color of the text itself |
| fixed width | truth state | If true then the text will be displayed with a fixed width (monospace) font |
| font weight | | specifies the weight of the font. Can be set to `light-weight`, `regular-weight` (the default), or `bold-weight` |
| indentation | number | specifies the number of units of indentation for the whole block of text. Units are defined by interpreter, but are often equivalent to spaces |
| first line indentation | number | specifies additional (or negative) indentation for the first line of the text block |
| italic | truth state | If true then the text will be displayed in italics |
| justification | | can be set to `left-justified`, `center-justified`, `right-justified`, or `left-right-justified` for justified on the left and right (often called full justification) |
| relative size | number | specifies how many font sizes above or below the browser's default a style should be set to |
| reversed | truth state | If true then the foreground and background colors of the text will be reversed. This is most commonly used for the status line |

Colors are defined by specifying a RGB colour. RGB colors specify the red/green/blue components of a color in hexadecimal, and a correctly specified color will be 6 characters long, for example: `#00FF00`. Note that shortcut CSS colors (`#000`) are not supported.

Not all interpreters support all of these features. Notably, Gargoyle does not support justification or font sizes. If the interpreter does not support one of the features it will just be quietly ignored. On the other hand, some interpreters don't support setting any stylehints at all, most notably Lectrote.

Using the styles
----------------

You may invoke the text styles by using the following phrases

| Style name | Phrase |
|------------|--------|
| normal-style | `[roman type]` |
| italic-style | `[italic type]` |
| bold-style | `[bold type]` |
| fixed-letter-spacing-style | `[fixed letter spacing]` (Return to regular variable spaced type with either `[variable letter spacing]` or just `[roman type]`) |
| alert-style | `[alert style]` |
| blockquote-style | `[blockquote style]` |
| header-style | `[header style]` |
| input-style | `[input style]` |
| note-style | `[note style]` |
| special-style-1 | `[special-style-1]`, `[first special style]`, `[first custom style]`, etc. (there are multiple options to support older code) |
| special-style-2 | `[special-style-2]`, `[second special style]`, `[second custom style]`, etc. |

About this extension
--------------------

This extension was originally by Emily Short. Since version 5 it has been maintained by Dannii Willis.

The latest version of this extension can be found at <https://github.com/i7/extensions>. This extension is released under the Creative Commons Attribution licence. Bug reports, feature requests or questions can be made at <https://github.com/i7/extensions/issues>.