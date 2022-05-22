<!--

Thank you for adding or updating an extension!

This extension now requires all extensions for Inform 7 release 10.1 and 9.3 (6M62) to be production-ready. Any extensions for older Inform 7 releases or for experiments and works-in-progress, should be committed to the [master branch](https://github.com/i7/extensions/tree/master).

-->

Please ensure that you have followed these steps to make a pull request for 10.1 or 9.3 (6M62):

- [ ] This extension is stable and production-ready
  - Please also check that your extension only depends on other stable extensions which are supported for the target Inform 7 release. An extension which depends on extensions which are not stable cannot be accepted.
- [ ] This extension has a valid version number:
  - For 10.1: use [semantic versioning](https://semver.org/): `MAJOR.MINOR.PATCH`, ex: `2.1.0`. This means that the major version number must be incremented when and only when you make a change that is not backwards compatible.
  - For 9.3: use Inform's date based version number: `MAJOR/DATE`, ex: `2/220517`.
- [ ] This extension has the correct file name:
  - For 10.1: put the major version number at the end of the file name, ex: `Extension Name-v1.i7x`
  - For 9.3: do not include the version number, and the file name must match the extension's name as defined in the file exactly, ex:
    - File name: `Extension Name.i7x`
    - Extension begins: `Version 1/220517 of Extension Name by Author Name begins here.`
- [ ] This extension has documentation
- [ ] The correct branch (10.1 or 9.3) has been selected for this pull request
