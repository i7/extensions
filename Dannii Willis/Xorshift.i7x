Version 1/140818 of Xorshift by Dannii Willis begins here.

"Allows Inform 7's random number generator to be replaced with one that is consistent across all interpreters"

Section - The xorshift random number generator

Include (-

Global xorshift_seed;

! Replace Inform's default random function with one that will use the xorshift generator (when enabled)
Replace random;
[ random range result mod temp;
	! Use the VM's @random if xorshift isn't enabled
	if ( xorshift_seed == 0 )
	{
		#ifdef TARGET_ZCODE;
			@random range -> result;
		#ifnot;
			@random range result;
			result++;
		#endif;
		return result;
	}
	! If the number we generate is close to MAX_POSITIVE_NUMBER then the results may be skewed
	mod = MAX_POSITIVE_NUMBER % range;
	! The xorshift generator (xorshift* for Glulx)
	.Begin;
	#ifdef TARGET_ZCODE;
		! This xorshift generator is from http://b2d-f9r.blogspot.com/2010/08/16-bit-xorshift-rng.html
		@log_shift xorshift_seed 4 -> temp;
		! The Z-Machine has no xor opcode! :'(
		xorshift_seed = ( xorshift_seed | temp ) & ( ~( xorshift_seed & temp ) );
		@log_shift xorshift_seed (-3) -> temp;
		xorshift_seed = ( xorshift_seed | temp ) & ( ~( xorshift_seed & temp ) );
		@log_shift xorshift_seed 7 -> temp;
		xorshift_seed = ( xorshift_seed | temp ) & ( ~( xorshift_seed & temp ) );
		result = xorshift_seed & MAX_POSITIVE_NUMBER;
	#ifnot;
		! This xorshift* generator is from https://gist.github.com/Marc-B-Reynolds/0b5f1db5ad7a3e453596
		@shiftl xorshift_seed 13 sp;
		@bitxor xorshift_seed sp xorshift_seed;
		@ushiftr xorshift_seed 17 sp;
		@bitxor xorshift_seed sp xorshift_seed;
		@shiftl xorshift_seed 5 sp;
		@bitxor xorshift_seed sp xorshift_seed;
		result = ( xorshift_seed * 1597334677 ) & MAX_POSITIVE_NUMBER;
	#endif;
	! Check if we're too close to MAX_POSITIVE_NUMBER, and generate a new number if so
	if ( result + mod < 0 )
	{
		jump Begin;
	}
	return ( result % range ) + 1;
];

! Using @random seed the xorshift generator
[ xorshift_seed_randomly temp;
	.Begin;
	#ifdef TARGET_ZCODE;
		@random 256 -> temp;
		temp--;
		@log_shift temp 8 -> temp;
		@random 256 -> xorshift_seed;
		xorshift_seed--;
		xorshift_seed = xorshift_seed | temp;
	#ifnot;
		@random 0 xorshift_seed;
	#endif;
	if ( xorshift_seed == 0 )
	{
		jump Begin;
	}
];

-) before "Definitions.i6t".

The xorshift seed is a number variable.
The xorshift seed variable translates into I6 as "xorshift_seed".

To seed the xorshift generator randomly:
	(- xorshift_seed_randomly(); -).

Xorshift ends here.

---- DOCUMENTATION ----

Inform allows you to seed the random number generator so that if you use the same seed the same sequence of 'random' numbers will be generated. Unfortunately it isn't consistent when you change interpreters or computers. This extension replaces Inform's built in random number generator with another one called xorshift, which is consistent across all interpreters and computers. (Though not if you switch from the Z-Machine to Glulx or vice versa.) Unlike the other extensions for randomness, this extension will affect every part of Inform that has random behaviour.

The xorshift generator is controlled by the "xorshift seed" variable. To turn it on, set the variable to any number other than 0. To turn it off, set it to 0. If you like, you can use the "seed the xorshift generator random" phrase, which sets the seed using a random number from the built in generator. The seed variable is continually updated as random numbers are generated, so if you want to reuse a seed, you should store it in another variable. Once you have set the seed variable no other code changes are needed.

	After starting the virtual machine:
		[ set the seed to a specific number ]
		now the xorshift seed is 1000;
		[ set the seed to a random number ]
		seed the xorshift generator randomly;
		say the xorshift seed;
		[ turn off the xorshift generator ]
		now the xorshift seed is 0;

All psuedo random number generators have flaws, but considering its speed, the xorshift algorithm is one of the most reliable generators known. It is slower than the VM's built in random function, but it's unlikely to ever be noticably slower. For more information about xorshift generators see <http://en.wikipedia.org/wiki/Xorshift>.

The latest version of this extension can be found at <https://github.com/i7/extensions>. This extension is released under the Creative Commons Attribution licence. Bug reports, feature requests or questions should be made at <https://github.com/i7/extensions/issues>.