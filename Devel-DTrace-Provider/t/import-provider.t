use strict;

use Test::More tests => 2;
use FindBin qw/ $Bin /;
use lib $Bin;

BEGIN {
	use_ok 'Test::Provider1';
	use_ok 'Test::Provider2';
}

probe1 { shift->fire('foo') };
probe2 { 
	my $arg = gather_args();
	shift->fire($arg);
};

probe3 { shift->fire };
probe4 { shift->fire };

probe5 { shift->fire };
probe6 { shift->fire };

sub gather_args {
	return "expensively gathered probe argument";
}
