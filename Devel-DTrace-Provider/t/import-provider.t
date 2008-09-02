use Test::More tests => 2;
use FindBin qw/ $Bin /;
use lib $Bin;

BEGIN { use_ok Test::Provider1; use_ok Test::Provider2 };

probe1 { shift->fire };
probe2 { shift->fire };

probe3 { shift->fire };
probe4 { shift->fire };

probe5 { shift->fire };
probe6 { shift->fire };

