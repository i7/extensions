Flexible Windows allows the [Glk Windows API](https://www.eblong.com/zarf/glk/Glk-Spec-076.html#window) to be controlled from within Inform 7.

Opening windows and controlling their positions
-----------------------------------------------

In Inform 11 a `Glk window` kind is now built in, but it does not allow for you to create new windows. Flexible Windows augments the `Glk window kind` to add extra functionality. The most important of these are the `position`, `split method`, and `measurement` properties, and the `spawning` relation. So to create a basic window:

```
The side panel is a text buffer window.
The side panel is spawned by the main window.
The position of the side panel is placed right.
The split method of the side panel is proportionally sized.
The measurement of the side panel is 30.
```

This will define a text buffer window which is spawned from the main window. It will be placed on the right, and will take up 30% of the main window's space, reducing the main window to 70%. But this code won't actually open the window, to do that you need to use the `open (window)` phrase:

```
When play begins:
	open the side panel;
```

You can change how a window has been split off its parent window, but for the changes to take effect you must first `close (window)` the window before opening it again. While we often refer to the "parent" of a window, to refer to it in code use the `spawner` property.

Opening and closing windows uses the `constructing` and `deconstructing` activities. You can add rules to these activities, for example you might want to automatically open a child window after its parent window has been opened. The above `when play begins` rule could be changed to this instead:

```
After constructing the main window:
	open the side panel;
```

Glk window properties
---------------------

This extension adds several properties to the Glk window kind:

| Property | Description |
|----------|-------------|
| `aspect ratio` | For the `fixed aspect ratio` split method, a real number. |
| `background colour` | An RGB colour to use as the background colour of the window. If you change this after a window has been opened the graphics windows will use the new colour next time the window is cleared, but textual windows will ignore the change (you must close and reopen them instead.) |
| `maximum size`, `minimum size` | Window constraints for the `constrained` split method. |
| `measurement` | The size of the window. Each split method will interpret this in its own way. |
| `position` | Which side of the parent window the window will take, must be one of `placed left`, `placed right`, `placed above`, or `placed below`. |
| `spawner` | The parent window which spawns this window. |
| `split method` | How a window will be split from its parent window, must be one of `fixed size`, `proportionally sized`, `constrained`, `fixed aspect ratio`. |
| `split with a border` or `split without a border` | Whether the window will be split with or without a border. Without is the default. This may not have any effect in some Glk libraries. |

Split methods
-------------

There are four `split method` options, two basic, and two dynamic.

1. `fixed size`: The window will be given a specific fixed size in the direction of the split: for left/right splits the `measurement` refers to the width, for above/below splits it refers to the height. For graphics window `measurement` refers to pixels, for buffer and grid windows it refers to characters.
2. `proportionally sized`: The window will take up the specified proportion of its parent window, `measurement` being used as a percentage.
3. `constrained`: A constrained window's `measurement` is first used as if it were proportionally sized, but then the `minimum size` and `maximum size` properties will be considered. So if the calculated size of the window would be less than its minimum or maximum, it will change to be fixed size. Setting the minimum or maximum to 0 will ignore that constraint.
4. `fixed aspect ratio`: The window's measurements will be adjusted so that it keeps a particular aspect ratio: setting the `aspect ratio` property to `1.0` would result in a square, `2.0` would result in a window twice as wide as it is high, and `0.5` would result in a window twice as high as it is wide. Note that this is only intended for use on graphics windows. If you use it on a text window then it will perform its calculations as if each character had square dimensions even though that is almost certainly not the case.

Note that all of these methods are limited by the Glk model. The parent window might not have enough space for the requested measurement, in which case the child window might consume all the space of the parent, hiding the parent window entirely. In addition, a child window cannot influence how much space was allocated for the parent window; you can't expand a parent window by setting one of its children to a particular size.

Refreshing windows
------------------

Inform 11 already includes a `focus (window)` phrase allowing you to switch which window text will be sent to. But often a better way is to use the refreshing system, as it will automatically update a window when it's initially created, after restoring, or when the interpeter window's size is changed (resulting in the individual Glk windows' sizes being changed and therefore possibly needing to be updated.) You can use the `refresh (window)` or `refresh all windows` phrases to refresh one or all windows, and then add instructions for how to refresh a window as rules in the `refereshing` activity's `for` rulebook.

```
Rule for refreshing the side panel:
	try taking inventory;
```

The current focus and active windows
------------------------------------

Flexible Windows keeps track of two window variables: the `current focus window`, and the `active window`. The current focus window is updated whenever you use `focus (window)`, and is used to ensure that after refreshing or restoring the intended window is focused again.

The `active window` is used to determine which window input requests will be made in. You could change it in order to shift input to a secondary window. Or you can create "popover" windows by opening a proportional window with a measurement of 100%. If you set the active window to the child window then it will appear as if you had just cleared the screen, but when you close the popover window the original window's content will still be there. This is a good approach for menus.

Glulx Text Effects
------------------

This extension has been designed to work alongside Glulx Text Effects. GTE has been updated to allow you to specify a particular Glk window in the `Table of User Styles`.

Page margin
-----------

The "page margin" refers to the area inside of the interpreter window but outside of any Glk window. It is not officially part of the Glk model, but many interpreters use it. For example Gargoyle puts a small margin around the whole window, and Parchment may not use the entire width of a browser, with the left and right sides being considered the margin. These interpeters may change its colour as stylehints are used, so Flexible Windows will attempt to set it to the active window's background colour. You may also set it yourself using the `set the page margin to (RGB colour)` phrase.

Screen measurements
-------------------

Flexible Windows uses some hidden windows to allow you to measure the size of the interpeter window (as much as it has access to, so excluding any page margins.) You can use these phrases to decide how you want to lay out your windows:

| Phrase | Description |
|--------|-------------|
| `if the screen is landscape` | True if the screen is wider than it is tall. |
| `if the screen is portrait` | True if the screen is taller than it is wide. |
| `if there is probably a virtual keyboard on-screen` | True if it is likely that there is a virtual keyboard on-screen (for mobile interpreters). Flexible Windows can't directly detect this, so it tries to infer it by checking if the width is the same as when the virtual machine started up, but the height is less than 70% of the original height. |
| `screen aspect ratio` | The aspect ratio of the screen (real number). |
| `screen height in pixels` | The height of screen in pixels. |
| `screen width in pixels` | The width of screen in pixels. |

About this extension
--------------------

This extension was originally by Jon Ingold. Since version 15 it has been maintained by Dannii Willis.

The latest version of this extension can be found at <https://github.com/i7/extensions>. This extension is released under the Creative Commons Attribution licence. Bug reports, feature requests or questions can be made at <https://github.com/i7/extensions/issues>.