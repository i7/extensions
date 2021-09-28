Version 1 of If True by Zed Lopez begins here.

"Allow if/unless to accept plain truth states instead of a full conditional.
If Strange Loopiness is included, extend that to while and until loops."

Part if/unless with truth states

Chapter if with truth state

To if (t - a truth state) begin -- end conditional:
    (- if ({t}) -)

Chapter unless with truth state

To unless (t - a truth state) begin -- end conditional:
    (- if (~~({t})) -)

Book Repetition (for use with Strange Loopiness by Zed Lopez)

Chapter while truth state

Section while truth state plain

[ for an infinite loop, just ``repeat while true:``.
  it's your responsibility to break out! ]
To repeat while (t - a truth state) begin -- end loop:
    (- while ({t}) -).

Section while truth state with index

To repeat while (t - a truth state) with/using index (index - nonexisting number variable) begin -- end loop:
    (- {index} = 0; while ({t} && ++{index}) -).

Chapter until truth state

Section until truth state plain

To repeat until (t - a truth state) begin -- end loop:
(- .TopOfLoop;
if (1) {-block}
if (~~({t})) jump TopOfLoop;
-)

Section until truth state with index

To repeat until (t - a truth state) with/using index (index - nonexisting number variable) begin -- end loop:
(- {index} = 0;
.TopOfLoop;
if (++{index}) {-block}
if (~~({t})) jump TopOfLoop;
-)

If True ends here.

