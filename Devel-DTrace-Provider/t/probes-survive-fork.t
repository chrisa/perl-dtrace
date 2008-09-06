use strict;

use Test::More tests => 1;
use FindBin qw/ $Bin /;
use lib $Bin;

BEGIN {
	use_ok 'Test::Provider1';
}

if (fork()) {
	# parent
	probe1 { shift->fire('parent') };
}
else {
	# child
	probe1 { shift->fire('child') };
}
