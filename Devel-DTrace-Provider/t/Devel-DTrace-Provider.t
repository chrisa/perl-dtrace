# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Devel-DTrace-Provider.t'

use Data::Dumper;

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 9;
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

# Make a UTSNAME section, generate its header, and the section itself
my $sec = Devel::DTrace::DOF::Section->new(DOF_SECT_UTSNAME, 0);
my $hdr = $sec->header;
ok($hdr, 'DOF header generated');
ok(length $hdr == 32, 'DOF header length');

my $len = $sec->generate;
ok($len, 'DOF utsname section generated');
ok($len == 1280, 'DOF utsname section length');

# Make a comments section, check its DOF length
$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_COMMENTS, 0);
$sec->data('abcdefghij');
$len = $sec->generate;
ok($len, 'DOF comments section generated');
ok($len == 11, 'DOF comments section DOF length');

# Make a probes section
$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROBES, 0);
$sec->data([
	    {
	     enoffidx => 14,
	     argidx   => 16,
	     nenoffs  => 1,
	     offidx   => 14,
	     name     => 1,
	     addr     => 0x8082a78,
	     nargc    => 1,
	     func     => 5,
	     xargc    => 1,
	     nargv    => 3,
	     noffs    => 1,
	     xargv    => 3
	    },
	    {
	     enoffidx => 15,
	     argidx   => 17,
	     nenoffs  => 1,
	     offidx   => 15,
	     name     => 4,
	     addr     => 0x807429c,
	     nargc    => 3,
	     func     => 9,
	     xargc    => 3,
	     nargv    => 6,
	     noffs    => 1,
	     xargv    => 7
	    },
	   ]);
$len = $sec->generate;
ok($len, 'DOF probes section generated');
ok($len == 96, 'DOF probes section DOF length');

	     
