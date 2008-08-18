# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Devel-DTrace-Provider.t'

use Data::Dumper;

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 3;
BEGIN { use_ok('Devel::DTrace::Provider') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

$SIG{__WARN__} = sub {
        CORE::dump if $_[0] =~ /uninitialized value in subroutine entry/;
        CORE::dump if $_[0] =~ /Attempt to free/;
        warn @_;
};
     
use Devel::DTrace::DOF::Constants qw/ :all /;

# Make a provider with ::Provider
my $provider = Devel::DTrace::Provider->new('prov', 'perl');
ok($provider, 'created provider');
$provider->probe('test');
my $stubs = $provider->enable;
ok($stubs, 'got stubs');

for my $i (1..5) {
	$stubs->{test}->fire();
}
