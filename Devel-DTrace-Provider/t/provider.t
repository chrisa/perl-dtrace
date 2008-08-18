use Test::More tests => 2;

BEGIN { use_ok Devel::DTrace::Provider; }
use Devel::DTrace::DOF::Constants qw/ :all /;

my $provider = Devel::DTrace::Provider->new('test0', 'test1module');
$provider->probe('test');
ok($provider->enable, 'Generate provider DOF');


