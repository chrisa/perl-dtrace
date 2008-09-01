use Test::More tests => 1;
use Data::Dumper;

BEGIN {
	use_ok('Devel::DTrace::Provider');

	# Create provider in BEGIN to get sugared probe subs.
	my $provider = Devel::DTrace::Provider->new('prov', 'perl');
	$provider->probe('test');
	my $stubs = $provider->enable;
}

Devel::DTrace::Probe::prov::test { shift->fire; print "fired\n"; };

