Version 1 of Pseudodevices by Zed Lopez begins here.

"Facilitate giving switched on/off to kinds other than devices."

Definition: a thing is devicive if it provides the property switched on.

Carry out examining a devicive thing (this is the examine devicive rule):
  say "[The noun] [are] [if story tense is present tense]currently [end if]switched [if the noun is switched on]on[else]off[end if].";
  now examine text printed is true.

The examine devicive rule is listed instead of the examine devices rule in the carry out examining rules.

Pseudodevices ends here.

---- Documentation ----

If you would like supporters or containers (or other kinds) to support being switched on or off like devices, just specify that they have the switched on property.

The self-opening box is a container.
The self-opening box can be switched on or switched off.

Since Inform 7 already knows switched on and switched off are opposites, you actually only need one or the other. Either of these would work.

The self-opening box can be switched on.
The self-opening box can be switched off.

But since it's not a device, it won't be caught by conditionals of the form ``if X is a device``. The extension provides the devicive adjective for such tests.

if T is devicive [ <-- use this ]
if T is a device... [ <-- Don't use this! ]

Example: * Light table

*: "Light Table"

Include Pseudodevices by Zed Lopez.

Lab is a room.
The switch is a fixed in place device in the Lab.
The switch is switched on.
The light table is a supporter in the Lab.
The light table can be switched on or switched off.

After deciding the scope of the player when the location is the Lab and the Lab is dark:
    place the light table in scope.

Carry out switching on the light table:
    now the light table is lit.

Carry out switching off the light table:
    now the light table is unlit.

Carry out switching on the switch:
  now the Lab is lighted.

Carry out switching off the switch:
  now the Lab is dark.

Test me with "turn on table / turn off switch / turn off table / turn on table".

