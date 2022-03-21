Version 1 of Bit Ops (for Glulx only) by Zed Lopez begins here.

"Routines to access the Glulx VM's bitwise operators. Tested on 6M62."

Use authorial modesty.

Part Bit Ops

Chapter Not

Include (-
[ bitnot n1 result;
  @bitnot n1 result;
  return result;
];
-).

To decide what number is bitnot (n1 - a number):
  (- bitnot({n1}) -).

Chapter XOR

Include (-
[ bitxor n1 n2 result;
  @bitxor n1 n2 result;
  return result;
];
-).

To decide what number is (n1 - a number) bitxor/xor (n2 - a number):
  (- bitxor({n1},{n2}) -).

Chapter OR

Include (-
[ bitor n1 n2 result;
  @bitor n1 n2 result;
  return result;
];
-).

To decide what number is (n1 - a number) bitor (n2 - a number):
  (- bitor({n1},{n2}) -).


Chapter AND

Include (-
[ bitand n1 n2 result;
  @bitand n1 n2 result;
  return result;
];
-).

To decide what number is (n1 - a number) bitand (n2 - a number):
  (- bitand({n1},{n2}) -).

Chapter Shift Left

Include (-
[ shiftl n1 n2 result;
  @shiftl n1 n2 result;
  return result;
];
-).

To decide what number is (n1 - a number) shiftl (n2 - a number):
  (- shiftl({n1},{n2}) -).

Chapter Shift Right

Include (-
[ ushiftr n1 n2 result;
  @ushiftr n1 n2 result;
  return result;
];
-).

To decide what number is (n1 - a number) ushiftr (n2 - a number):
  (- ushiftr({n1},{n2}) -).

Bit Ops ends here.

---- Documentation ----

Chapter Examples

	"bitops"
	
	Include Bit Ops by Zed Lopez.
	Include Unit Tests by Zed Lopez.
	
	Lab is a room.
	
	Use test automatically.
	
	not-test is a unit test. "Not".
	
	For testing not-test:
	  for "~ 0" assert bitnot 0 is -1;
	  for "~ -1" assert bitnot -1 is 0;
	  for "~ 1" assert bitnot 1 is -2;
	  for "~ 5" assert bitnot 5 is -6;
	
	xor-test is a unit test. "Xor".
	
	For testing xor-test:
	  for "0 ^ 1" assert 0 xor 1 is 1;
	  for "0 ^ 0" assert 0 xor 1 is 1;
	  for "1 ^ 1" assert 0 xor 1 is 1;
	  for "5 ^ 3" assert 5 xor 3 is 6;
	  for "-3 ^ 8" assert -3 xor 8 is -11;
	  
	or-test is a unit test. "Or".
	For testing or-test:
	  for "0 | 0" assert 0 bitor 0 is 0;
	  for "0 | 1" assert 0 bitor 1 is 1;
	  for "1 | 0" assert 1 bitor 0 is 1;
	  for "1 | 1" assert 1 bitor 1 is 1;
	  for "-5 | 17" assert -5 bitor 17 is -5;
	  
	and-test is a unit test. "And".
	For testing and-test:
	  for "0 & 0" assert 0 bitand 0 is 0;
	  for "0 & 1" assert 0 bitand 1 is 0;
	  for "1 & 0" assert 1 bitand 0 is 0;
	  for "1 & 1" assert 1 bitand 1 is 1;
	  for "15 & 4" assert 15 bitand 4 is 4;
	  for "-3 & 18" assert -3 bitand 18 is 16;
	
	shiftl-test is a unit test. "Shift L".
	For testing shiftl-test:
	  for "0 << 0" assert 0 shiftl 0 is 0;
	  for "0 << 1" assert 0 shiftl 0 is 0;
	  for "0 << 2" assert 0 shiftl 0 is 0;
	  for "1 << 0" assert 1 shiftl 0 is 0;
	  for "1 << 1" assert 1 shiftl 1 is 2;
	  for "1 << 2" assert 1 shiftl 2 is 4;
	  for "2 << 2" assert 2 shiftl 2 is 8;
	  for "-1 << 7" assert -1 shiftl 7 is -128;
	
	ushiftr-test is a unit test. "Ushift R".
	For testing ushiftr-test:
	  for "0 >> 0" assert 0 ushiftr 0 is 0;
	  for "0 >> 1" assert 0 ushiftr 0 is 0;
	  for "0 >> 2" assert 0 ushiftr 0 is 0;
	  for "1 >> 0" assert 1 ushiftr 0 is 1;
	  for "1 >> 1" assert 1 ushiftr 1 is 0;
	  for "1 >> 2" assert 1 ushiftr 2 is 0;
	  for "2 >> 1" assert 2 ushiftr 1 is 1;
	  for "2 >> 2" assert 2 ushiftr 2 is 0;
