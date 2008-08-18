# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Devel-DTrace-Provider.t'

use Data::Dumper;

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 27;
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

# Make a prargs section
$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PRARGS, 0);
$sec->data([1, 2]);
$len = $sec->generate;
ok($len, 'DOF prargs section generated');
ok($len == 2, 'DOF prargs section length');

# Make a proffs section
$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROFFS, 0);
$sec->data([3, 4]);
$len = $sec->generate;
ok($len, 'DOF proffs section generated');
ok($len == 8, 'DOF proffs section length');

# Make a prenoffs section
$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PRENOFFS, 0);
$sec->data([5, 6]);
$len = $sec->generate;
ok($len, 'DOF prenoffs section generated');
ok($len == 8, 'DOF prenoffs section length');

# Make a provider section
$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROVIDER, 0);
$sec->data({
	    strtab => 1,
	    probes => 2,
	    prargs => 3,
	    proffs => 4,
	    prenoffs => 5,
	    name => 1,
	    provattr => { name => 1, data => 1, class => 1 },
	    modattr  => { name => 1, data => 1, class => 1 },
	    funcattr => { name => 1, data => 1, class => 1 },
	    nameattr => { name => 1, data => 1, class => 1 },
	    argsattr => { name => 1, data => 1, class => 1 }
	   });
$len = $sec->generate;
ok($len, 'DOF provider section generated');
ok($len == 44, 'DOF provider section length');

# Create a ::File object
my $f = Devel::DTrace::DOF::File->new();
ok(ref $f eq 'Devel::DTrace::DOF::File', 'file gets blessed correctly');
undef $f;
ok(1, 'call destroy survived');

# Use a ::File object
$f = Devel::DTrace::DOF::File->new();
$f->allocate(4096);
ok($f->data eq '', 'file is empty to start with');
ok($f->addr, 'file has an addr');
my $data = 'abcdefghij';
$f->append($data);
ok($f->data eq $data, 'file has data appended');
$f->append($data);
ok($f->data eq "$data$data", 'file has data appended again');

# Header object
$hdr = Devel::DTrace::DOF::Header->new();
$hdr->secnum(5);
$len = $hdr->hdrlen;
ok($len, 'Header has some length');
ok($len == 224, 'Header length correct');
$dof = $hdr->generate;
ok($dof, 'Header DOF generated');

# Make a provider
$f = Devel::DTrace::DOF::File->new();
$f->allocate(4096);

$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_STRTAB, 0);
$sec->data (['test', 'main', 'test1']);
push @{$f->sections}, $sec;

$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROBES, 1);
$sec->data([
	    {
	     noffs    => 1,
	     enoffidx => 0,
	     argidx   => 0,
	     name     => 1,
	     nenoffs  => 0,
	     offidx   => 0,
	     addr     => 0,
	     nargc    => 0,
	     func     => 6,
	     xargc    => 0
	    },
	   ]);
push @{$f->sections}, $sec;

$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PRARGS, 2);
$sec->data([ 0 ]);
push @{$f->sections}, $sec;

$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROFFS, 3);
$sec->data([ 36 ]);
push @{$f->sections}, $sec;

$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PRENOFFS, 4);
$sec->data([ 0 ]);
push @{$f->sections}, $sec;
    
$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROVIDER, 5);
$sec->data({
	    strtab => 0,
	    probes => 1,
	    prargs => 2,
	    proffs => 3,
	    prenoffs => 4,
	    name   => 11,
	    provattr => { name => 5, data => 5, class => 5 },
	    modattr  => { name => 1, data => 1, class => 5 },
	    funcattr => { name => 1, data => 1, class => 5 },
	    nameattr => { name => 5, data => 5, class => 5 },
	    argsattr => { name => 5, data => 5, class => 5 }
	   });
push @{$f->sections}, $sec;
$f->generate;

# Make a provider with ::Provider
my $provider = Devel::DTrace::Provider->new('test0', 'test1module');
$provider->probe('test');
ok($provider->enable, 'Generate provider DOF');

#my $cmd = sprintf '/usr/sbin/dtrace -l -n test0%s:::', $$;
#my @dtrace = `$cmd`;
#ok(scalar @dtrace == 2, 'probes generated');

sleep 120
