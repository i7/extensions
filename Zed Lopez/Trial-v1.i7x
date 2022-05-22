Version 1 of Trial by Zed Lopez begins here.

"Simple means to use a command ('try') to launch tests of code
that isn't naturally command-centric. Facilitates testing such
code with regtest."

Use authorial modesty.

Book of Trial (not for release)

Trial is a text based rulebook producing nothing.
The Trial rules have default success.
Trial: say "(undefined).".

Trialing is an action out of world applying to one topic.

Understand "try [text]" as trialing.

Carry out Trialing: follow the trial rules for "[the topic understood]".

Trial ends here.

---- Documentation ----

This is just asimple way to facilitate testing code that isn't
command-centric, intended for use with regtest (but potentially
useful without it). Just set up tests by name like so:

```
Trial "one and one":
    let i be 1;
    let x be i + 1;
    say "[x][line break]";
```

and a corresponding regtest entry:

```
> try one and one
/^2$
```
