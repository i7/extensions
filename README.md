The Friends of Inform 7 extensions group
========================================

Here you'll find many Inform 7 extensions -- some are ready for public use, others are barely working experiments. Enjoy!

If you would access to the repository to add your own extensions, please ask here: http://www.intfiction.org/forum/viewtopic.php?f=7&t=5229

It may help to know that the I7 Public Library of extensions (integrated with the 6L38 IDE) can be found at:
http://www.emshort.com/pl/payloads/

If you find a bug in any of these extensions, or indeed in any Inform 7 extension at all, please make a new issue and we may be able to help. The purpose of the group is that we can all work together to maintain and develop these extensions. Sharing the load will make it easier on us all, while experienced programmers can help those just starting out.

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
5. Start up I7 again, and go to the Extensions -> Public Library tab.
6. Click the yellow DOWNLOAD EXTENSIONS button at the bottom.  (Don't click the blue or purple buttons, they will both downgrade things.)
7. Close and restart I7 (otherwise it gets very confused about which extensions are installed).
8. You now have a merge of both the Public Library and all of the extensions in this repository.
9. If there's any extensions from your `Extensions Old` folder that you need to "rescue" (perhaps some you've written yourself, or installed from elsewhere), you can use File -> Install Extension to copy them from that folder into the new Extensions folder (or close down I7 and move them manually).
10. To update in the future, you can either update the extensions one-by-one as above or you can download a fresh zip and install the whole thing over the top.

(Alternatively, if you're familiar with Git then you can use a Git clone in place of downloading the zip, if you prefer.)
