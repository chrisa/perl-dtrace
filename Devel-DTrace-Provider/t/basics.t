use Test::More tests => 26;

BEGIN { use_ok Devel::DTrace::Provider; }
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
