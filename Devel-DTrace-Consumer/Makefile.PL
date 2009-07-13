use inc::Module::Install;
use 5.008006;

license  'perl';

name 'Devel-DTrace-Consumer';
all_from 'lib/Devel/DTrace/Consumer.pm';

# TODO: catch early versions of these, handle failure by not building
# the XS part.
my $platform = $^O;
my $build_native = 0;
if ($platform eq 'darwin') {
	print STDERR "Building for OS X\n";
	if (-f '/usr/include/dtrace.h') {
		print STDERR "DTrace available, building native components\n";
		$build_native = 1;
	}
}
elsif ($platform eq 'solaris') {
	print STDERR "Building for Solaris\n";
	if (-f '/usr/include/dtrace.h') {
		print STDERR "DTrace available, building native components\n";
		$build_native = 1;
	}
}

WriteMakefile(
    NAME              => 'Devel::DTrace::Consumer',
    VERSION_FROM      => 'lib/Devel/DTrace/Consumer.pm',
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (AUTHOR         => 'Chris Andrews <chris@nodnol.org>') : ()),
    LIBS              => ['-ldtrace'],
    DEFINE            => '-g -D_LONGLONG_TYPE',
    INC               => '-I.',
    ($build_native ? # DTrace available?
     (OBJECT          => '$(O_FILES)',) : 
     (NEEDS_LINKING   => 0, SKIP => ['dynamic'])
    ),
);
