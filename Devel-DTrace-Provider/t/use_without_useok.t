# This exists to catch a segfault-on-load bug 
# before correct "boot other XS modules" done
# (see Provider.xs).

use Test::More tests => 1;

use Devel::DTrace::Provider;
use Devel::DTrace::DOF::Constants qw/ :all /;
ok('survived');
