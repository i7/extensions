The Friends of Inform 7 extensions (for v10.1)
==============================================

This [git branch](https://www.atlassian.com/git/tutorials/using-branches) of the Friends of I7 Extensions is for Inform 7 version 10.1 (the current version, released in 2022). The extensions here are believed to work in 10.1 (or, at a minimum to compile). Per the [LICENSE](./LICENSE) they are shared with no implied warranty of fitness for a particular purpose.

- If you are using Inform 7 v9.3/6M62 (the previous release, from 2015) see the [Friends of I7 Extensions 9.3/6M62 branch](https://github.com/i7/extensions/tree/9.3)
- If you would like to see a larger collection of extensions that may not identify which version of I7 they're for and may be a draft that never worked in any version, see the [Friends of I7 development branch](https://github.com/i7/extensions/tree/master)
- If you're looking for old extensions, most of which were for versions 6G60-6L38 and would not work in any subsequent version, see the [Friends of I7 Extension archive](https://github.com/i7/archive)

If you would like access to the repository to add your own extensions, please ask at the [intfiction.org forums Friends of I7 Github repo thread](https://intfiction.org/t/friends-of-i7-github/4103)

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
3. Download [this zip file](https://github.com/i7/extensions/archive/10.1.zip) and extract it into that location.
4. Rename the `extensions-10.1` folder that it just created to just `Extensions` (such that this now contains subfolders with peoples' names).
5. You now have all of the extensions in this repository, which includes those from the Public Library.  (Don't touch the blue or purple buttons in the Public Library tab, or you'll downgrade something.)
6. If there's any extensions from your `Extensions Old` folder that you need to "rescue" (perhaps some you've written yourself, or installed from elsewhere), you can use File -> Install Extension to copy them from that folder into the new Extensions folder (or close down I7 and move them manually).
7. To update in the future, you can either update the extensions one-by-one as above or you can download a fresh zip and install the whole thing over the top.

(Alternatively, if you're familiar with Git then you can use a Git clone in place of downloading the zip, if you prefer.)
