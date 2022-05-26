The Friends of Inform 7 extensions group
========================================

Here you'll find many Inform 7 extensions -- some are ready for public use, others are barely working experiments. Enjoy!

The full list of extensions is visible here: <https://i7.github.io/extensions/>

Inform (aka Inform 7) is a programming language used for interactive fiction and other creative purposes. For user documentation, and downloads of the apps, go to the Inform home page at: <http://www.inform7.com>.

If you find a bug in any of these extensions, or indeed in any Inform 7 extension at all, please make a new issue and we may be able to help. The purpose of the group is that we can all work together to maintain and develop these extensions. Sharing the load will make it easier on us all, while experienced programmers can help those just starting out.

Public Library
-------------
This repository now includes all of the extensions in the Public Library as of 2020-10-10, so you don't need to download them separately.  Sadly they're not organised by theme any more, so you'll have to use other means to find the particular extensions that you want to use.

How to download a few extensions
--------------------------------
1. Locate the extension that you want to use via the GitHub website.
2. Click on the Raw button.
3. Download the resulting file anywhere on your computer.
4. Inside I7, go to File -> Install Extension and locate the file you just downloaded.
5. Repeat this for any other extensions that the one you wanted also includes (and you don't already have).
6. Repeat all of this for any other extensions that you want.

How to download *all* the extensions
------------------------------------
1. Locate your current Extensions folder -- from within I7, select File -> Show Installed Extensions Folder -- then close I7.
2. Go up to the parent directory and rename the `Extensions` folder to `Extensions Old` (for now).
3. Download [this zip file](https://github.com/i7/extensions/archive/master.zip) and extract it into that location.
4. Rename the `extensions-master` folder that it just created to just `Extensions` (such that this now contains subfolders with peoples' names).
5. You now have all of the extensions in this repository, which includes those from the Public Library.  (Don't touch the blue or purple buttons in the Public Library tab, or you'll downgrade something.)
6. If there's any extensions from your `Extensions Old` folder that you need to "rescue" (perhaps some you've written yourself, or installed from elsewhere), you can use File -> Install Extension to copy them from that folder into the new Extensions folder (or close down I7 and move them manually).
7. To update in the future, you can either update the extensions one-by-one as above or you can download a fresh zip and install the whole thing over the top.

(Alternatively, if you're familiar with Git then you can use a Git clone in place of downloading the zip, if you prefer.)

How to contribute your own extensions
-------------------------------------

If you want to contribute your own extension,
[create a pull request](https://github.com/i7/extensions/pulls).

If you would access to the repository to add your own extensions, please ask here: <http://www.intfiction.org/forum/viewtopic.php?f=7&t=5229>

See [CONTRIBUTING.md](./CONTRIBUTING.md) for more information on
how to create a contribution.

Related sites
-------------

The main repository for Inform (Inform 7) itself is:
<https://github.com/ganelson/inform>.

It may help to know that the I7 Public Library of extensions (integrated with the 6L38 IDE) can be found at:
http://www.emshort.com/pl/payloads/
