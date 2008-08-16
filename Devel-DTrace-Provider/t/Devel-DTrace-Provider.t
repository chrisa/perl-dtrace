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

# $SIG{__WARN__} = sub {
#         CORE::dump if $_[0] =~ /uninitialized value in subroutine entry/;
#         warn @_;
# };
     
use Devel::DTrace::DOF::Constants qw/ :all /;

# Make a UTSNAME section, generate its header 
my $sec = Devel::DTrace::DOF::Section->new(DOF_SECT_UTSNAME, 0);
my $dof = $sec->header;
ok($dof);
ok(length $dof == 32);

