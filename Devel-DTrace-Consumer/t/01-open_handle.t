use strict;
use warnings;

use Test::More tests => 1;
use Devel::DTrace::Consumer;

my $c = Devel::DTrace::Context->new;
ok($c);


