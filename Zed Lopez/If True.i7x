Version 1/210928 of If True by Zed Lopez begins here.

"Allow if/unless to accept plain truth states instead of a full conditional. If
Strange Loopiness is included, extend that to while and until loops. For 6M62."

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

To repeat until (t - a truth state) begin -- end loop:
(-
  do
    {-block}
  until ({t});
-)

Section until condition with index

To repeat until (t - a truth state) with/using index (index - nonexisting number variable) begin -- end loop:
(-
  {index} = 0;
  do if (++{index}) {-block}  
  until ({t});
-)

If True ends here.

---- Documentation ----

Section Changelog

1/210928 Use I6-native do-until loop; prior implementation could break with multiple until loops
