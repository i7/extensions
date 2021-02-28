# Informant

For the Friends of I7 Extensions Github Pages: given a Friends of I7 Extensions directory,
it produces a stand-alone HTML page that lists the contents with links to the corresponding
files on github.com.

It writes to STDOUT; redirect as desired.

With no command-line arguments, it assumes the current working directory is the extensions
directory to operate on, e.g, within the extensions dir itself:

    $ docs/informant/informant.rb > docs/index.html

Optionally, the name of the extensions directory can specified as a command-line parameter,
e.g., in one's docs directory:

    $ ./informant/informant.rb .. > index.html

For portability's sake, its only requirements are from Ruby's standard library.
