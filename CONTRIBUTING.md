# Contributing Guide for Inform Extensions

Thank you for investing your time in contributing to our project!

Please be respectful of others.

# Extension location

Create your extensions inside a subdirectory with your full name.
Subdirectories are generally named "Firstnamex&nbsp;Lastname";
notice the space.
you can use middle name or middle initial, but don't include a period
after an initial (that will be interpreted as a full stop).

# Extension template

When creating an extension for this collection use a template like this:

~~~~
Version 1.0.0 of MyExtensionName by MyFirstName LastName begins here.
"Your description here."

[ Released under the terms of the
Creative Commons Attribution 4.0 International (CC-BY-4.0) license.
See https://creativecommons.org/licenses/by/4.0/ for license details.

SPDX-License-Identifier: CC-BY-4.0

Copyright (C) MyFirstName MyLastName and MyExtensionName project contributors.]

... (code here)

MyExtensionName ends here.

---- DOCUMENTATION ----

,,, (documentation)

Example: * MyExampleName - MyExtensionName

    "MyExampleName" by MyFirstName MyLastName.

    Include MyExtensionName by MyFirstName MyLastName.

    ... example code

    Test me with "...".
~~~~

Again, MyFirstName MyLastName can have names and initials in the middle,
but don't include a terminating period.

Make sure you include a URL to the full license text.
The `SPDX-License-Identifier` provides a simple machine-readable format
for a SPDX license expression;
see the [SPDX License List](https://spdx.org/licenses/) for more information.

There should be a copyright statement, but don't
include the years or try to provide a complete list of contributor names.
This goes quickly out of date.
See [Copyright Notices in Open Source Software Projects](https://www.linuxfoundation.org/blog/copyright-notices-in-open-source-software-projects/)
from the Linux Foundation for more information.

You can release an extension under multiple licenses
(and allow potential users to use any of them).
For example, to allow users to use either the
Creative Commons Attribution 4.0 International license, the
Artistic License 2.0, *or* the MIT license,
use this as the "Released by..." and SPDX-License-Identifier text:

> Released under the terms of the
> Creative Commons Attribution 4.0 International (CC-BY-4.0) license.
> See https://creativecommons.org/licenses/by/4.0/ for license details.
> You may also use this under the terms of the Artistic License.
> See https://opensource.org/licenses/Artistic-2.0 for license details.
> You may also use this under the terms of the MIT license.
> See https://opensource.org/licenses/MIT for license details.
>
> SPDX-License-Identifier: CC-BY-4.0 OR Artistic-2.0 OR MIT

# Branches

Inform changes over time, so extensions that work in one version
might not work in another.

We have branches named for each major release of Inform.
Extensions that work with that release should be included in each
branch the extension works with.
That *does* mean that if you're updating an extension, you may need
to update it in multiple branches (one for each release).
