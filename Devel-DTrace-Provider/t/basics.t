use Test::More tests => 89;

BEGIN { use_ok Devel::DTrace::Provider; }
use Devel::DTrace::DOF::Constants qw/ :all /;

# Make a UTSNAME section, generate its header, and the section itself
my $sec = Devel::DTrace::DOF::Section->new(DOF_SECT_UTSNAME, 0);
$sec->entsize(1);
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

# bad comments section
$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_COMMENTS, 0);
eval { $sec->generate };
ok($@ =~ /No 'data' in dof_generate_comments/, 'missing data in comments section noted');

# really bad comments section
$sec = bless [], 'Devel::DTrace::DOF::Section';
eval { $sec->dof_generate_probes };
ok($@ =~ /self is not a hashref/, 'bad self in comments section noted');

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

# Bad probes sections
$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROBES, 0);
delete $sec->{_data};
eval { $sec->generate };
ok($@ =~ /No 'data'/, 'missing data noted in probe section');

$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROBES, 0);
$sec->data([ [] ]);
eval { $sec->generate };
ok($@ =~ /probe data element is not a hashref/, 'bad probe data noted in probe section');

$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROBES, 0);
$sec->data({});
eval { $sec->generate };
ok($@ =~ /bad data/, 'bad data noted in probe section');

for my $missing (qw/ enoffidx argidx nenoffs offidx name addr 
		     nargc func xargv nargv noffs xargv /)
{
	$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROBES, 0);
	my $probe = {
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
		    };
	delete $probe->{$missing};
	$sec->data([$probe]);
	eval { $sec->generate };
	ok($@ =~ /No '$missing'/, "missing $missing noted in probe section");
}

# Make a prargs section
$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PRARGS, 0);
$sec->data([1, 2]);
$len = $sec->generate;
ok($len, 'DOF prargs section generated');
ok($len == 2, 'DOF prargs section length');

# Bad prargs sections
$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PRARGS, 0);
delete $sec->{_data};
eval { $sec->generate };
ok($@ =~ /No 'data'/, 'missing data noted in prargs section');

$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PRARGS, 0);
$sec->data({});
eval { $sec->generate };
ok($@ =~ /bad data/, 'bad data noted in prargs section');

$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PRARGS, 0);
$sec->data([ undef ]);
eval { $sec->generate };
ok($@ =~ /bad data for prarg/, 'bad prarg data noted in prargs section');

# Make a proffs section
$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROFFS, 0);
$sec->data([3, 4]);
$len = $sec->generate;
ok($len, 'DOF proffs section generated');
ok($len == 8, 'DOF proffs section length');

# Bad proffs sections
$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROFFS, 0);
delete $sec->{_data};
eval { $sec->generate };
ok($@ =~ /No 'data'/, 'missing data noted in proffs section');

$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROFFS, 0);
$sec->data({});
eval { $sec->generate };
ok($@ =~ /bad data/, 'bad data noted in proffs section');

$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROFFS, 0);
$sec->data([ undef ]);
eval { $sec->generate };
ok($@ =~ /bad data for proff/, 'bad proff data noted in proffs section');

# Make a prenoffs section
$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PRENOFFS, 0);
$sec->data([5, 6]);
$len = $sec->generate;
ok($len, 'DOF prenoffs section generated');
ok($len == 8, 'DOF prenoffs section length');

# Bad prenoffs sections
$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PRENOFFS, 0);
delete $sec->{_data};
eval { $sec->generate };
ok($@ =~ /No 'data'/, 'missing data noted in prenoffs section');

$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PRENOFFS, 0);
$sec->data({});
eval { $sec->generate };
ok($@ =~ /bad data/, 'bad data noted in prenoffs section');

$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PRENOFFS, 0);
$sec->data([ undef ]);
eval { $sec->generate };
ok($@ =~ /bad data for prenoff/, 'bad prenoff data noted in prenoffs section');

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

# bad provider sections
$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROVIDER, 0);
delete $sec->{_data};
eval { $sec->generate };
ok($@ =~ /No 'data'/, 'missing data noted in provider section');

$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROVIDER, 0);
$sec->data([]);
eval { $sec->generate };
ok($@ =~ /bad data/, 'bad data noted in provider section');

for my $missing (qw/ strtab probes prargs proffs prenoffs name
		     provattr modattr funcattr nameattr argsattr /) {
	
	$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROVIDER, 0);
	my $data = {
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
		   };
	delete $data->{$missing};
	$sec->data($data);
	eval { $sec->generate };
	ok($@ =~ /No '$missing'/, "missing $missing noted in provider section");
}

for my $attr (qw/ provattr modattr funcattr nameattr argsattr /) {
	for my $missing (qw/ name data class /) {
		
		$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROVIDER, 0);
		my $data = {
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
			   };
		delete $data->{$attr}->{$missing};
		$sec->data($data);
		eval { $sec->generate };
		ok($@ =~ /bad data for $missing/, "missing $missing noted in $attr");
	}
}

# Bad section headers
$sec = Devel::DTrace::DOF::Section->new(DOF_SECT_PROVIDER, 0);
eval { $sec->header };
ok($@ =~ /No 'entsize'/, 'missing entsize noted');

# Really bad section object
$sec = bless [], 'Devel::DTrace::DOF::Section';
eval { $sec->header };
ok($@ =~ /not a hashref/, 'bad self noted in Section header');

# Create a ::File object
my $f = Devel::DTrace::DOF::File->new();
ok(ref $f eq 'Devel::DTrace::DOF::File', 'file gets blessed correctly');
undef $f;
ok(1, 'call destroy survived');

# Use a ::File object, but blow it up
$f = Devel::DTrace::DOF::File->new();
eval {
	$f->allocate(40964096409640964096);
};
ok($@ =~ 'Failed to allocate memory for DOF: Cannot allocate memory', 'memory allocation error caught');

# Use it properly.
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
$hdr->loadsz(372);
$hdr->filesz(372);
$len = $hdr->hdrlen;
ok($len, 'Header has some length');
ok($len == 224, 'Header length correct');
$dof = $hdr->generate;
ok($dof, 'Header DOF generated');

# bad header objects
$hdr = Devel::DTrace::DOF::Header->new();
$hdr->loadsz(372);
$hdr->filesz(372);
eval { $hdr->generate };
ok($@ =~ /No 'secnum'/, 'missing secnum noted');

$hdr = Devel::DTrace::DOF::Header->new();
$hdr->secnum(5);
$hdr->filesz(372);
eval { $hdr->generate };
ok($@ =~ /No 'loadsz'/, 'missing loadsz noted');

$hdr = Devel::DTrace::DOF::Header->new();
$hdr->loadsz(372);
$hdr->secnum(5);
eval { $hdr->generate };
ok($@ =~ /No 'filesz'/, 'missing filesz noted');

$hdr = Devel::DTrace::DOF::Header->new();
eval { $hdr->hdrlen };
ok($@ =~ /No 'secnum'/, 'missing secnum noted in hdrlen');

# Really bad Header object (hashref expected)
$hdr = bless [], "Devel::DTrace::DOF::Header";
eval { $hdr->hdrlen };
ok($@ =~ /self is not a hashref/, 'bad self noted in hdrlen');

$hdr = bless [], "Devel::DTrace::DOF::Header";
eval { $hdr->generate };
ok($@ =~ /self is not a hashref/, 'bad self noted in generate');
