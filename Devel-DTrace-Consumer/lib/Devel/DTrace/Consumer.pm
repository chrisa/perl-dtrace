package Devel::DTrace::Consumer;

use 5.008;
use strict;
use warnings;

BEGIN {
	our $VERSION = '0.01';
	
	require XSLoader;
	eval {
		XSLoader::load('Devel::DTrace::Consumer', $VERSION);
	};
}
	
1;
