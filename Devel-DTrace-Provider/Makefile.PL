use 5.008;
use ExtUtils::MakeMaker;

# TODO: catch early versions of these, handle failure by not building
# the XS part.
my $platform = $^O;
my $build_native = 0;
if ($platform eq 'darwin') {
	print STDERR "Building for OS X\n";
	symlink 'DTrace_Probe.xs-darwin', 'DTrace_Probe.xs';
	if (-f '/usr/include/dtrace.h') {
		print STDERR "DTrace available, building native components\n";
		$build_native = 1;
	}
}
elsif ($platform eq 'solaris') {
	print STDERR "Building for Solaris\n";
	symlink 'DTrace_Probe.xs-solaris', 'DTrace_Probe.xs';
	if (-f '/usr/include/dtrace.h') {
		print STDERR "DTrace available, building native components\n";
		$build_native = 1;
	}
}

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Devel::DTrace::Provider',
    VERSION_FROM      => 'lib/Devel/DTrace/Provider.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Devel/DTrace/Provider.pm', # retrieve abstract from module
       AUTHOR         => 'Chris Andrews <chris@nodnol.org>') : ()),
    LIBS              => [''], # e.g., '-lm'
    DEFINE            => '-g', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
    ($build_native ? # DTrace available?
     (OBJECT          => '$(O_FILES)',) : 
     (NEEDS_LINKING   => 0, SKIP => ['dynamic'])
    ),
);
