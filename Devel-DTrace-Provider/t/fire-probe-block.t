use Test::More tests => 1;
use Data::Dumper;

use_ok('Devel::DTrace::Provider');

my $provider = Devel::DTrace::Provider->new('provider1', 'perl');
$provider->probe('probe1', 'string');
my $stubs = $provider->enable;

$stubs->{probe1}->fire('foo');
