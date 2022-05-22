Version 1.3 of If True by Zed Lopez begins here.

"Allow if/unless and while to accept plain truth states instead of
a full conditional. If Strange Loopiness is included, extend that
to until loops."

Part if/unless with truth states

Chapter if with truth state

To if (t - a truth state) begin -- end conditional:
    (- if ({t}) -)

Chapter unless with truth state

To unless (t - a truth state) begin -- end conditional:
    (- if (~~({t})) -)

Part while loops

Chapter while truth state plain

[ for an infinite loop, just ``while true:``.
  it's your responsibility to break out! ]
To while (t - a truth state) begin -- end loop:
    (- while ({t}) -).

Chapter while truth state with index

To while (t - a truth state) with/using index (index - nonexisting number variable) begin -- end loop:
    (- {index} = 0; while ({t} && ++{index}) -).
    
Book Repetition (for use with Strange Loopiness by Zed Lopez)

Chapter until truth state

To repeat until (t - a truth state) begin -- end loop:
(-
  do
    {-block}
  until ({t});
-)

Chapter until truth state with index

To repeat until (t - a truth state) with/using index (index - nonexisting number variable) begin -- end loop:
(-
  {index} = 0;
  do if (++{index}) {-block}  
  until ({t});
-)

If True ends here.

---- Documentation ----

Section Changelog

1/211209 remove truth state valued table columns
1/211128 move while loops outside of For use with Strange Loopiness
1/211127 add while loops
1/211003 add truth state valued table columns
1/210928 Use I6-native do-until loop; prior implementation could break with multiple until loops
