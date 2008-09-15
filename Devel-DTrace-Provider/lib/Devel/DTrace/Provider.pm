package Devel::DTrace::Provider;

use 5.008;
use strict;
use warnings;


BEGIN {
	our $VERSION = '0.01';
	require XSLoader;
	eval {
		XSLoader::load('Devel::DTrace::Provider', $VERSION);
	};

	my $DTRACE_AVAILABLE = 1;
	if ($@ && $@ =~ /Can't locate loadable object/) {
		# No object - assume it wasn't built, and we should noop everything. 
		$DTRACE_AVAILABLE = 0;
	}

	sub DTRACE_AVAILABLE { $DTRACE_AVAILABLE };
}

use Devel::DTrace::DOF;
use Devel::DTrace::DOF::Constants qw/ :all /;
use Devel::DTrace::Probe;
use Devel::DTrace::Provider::ProbeDef;

my $Typemap = { string => 'char *', integer => 'int' };

sub new {
	my ($class, $provider_name, $module_name) = @_;
	my $self = bless {}, $class;
	$self->{_name} = $provider_name;
	$self->{_module} = $module_name;
	$self->{_class} = ucfirst $provider_name; # .camelize better
	$self->{_probe_defs} = [];
	return $self;
}

sub name {
	my ($self) = @_;
	return $self->{_name};
}

sub probe_names {
	my ($self) = @_;
	return keys %{$self->{_probes}};
}

sub probe {
	my ($self, $name, @types) = @_;
	my $options = {};
	if (ref $types[0] eq 'HASH') {
		$options = shift @types;
	}
	my (undef, undef, undef, $caller) = caller();
	if (defined $caller) {
		$options->{function} = $caller;
	}
	else {
		$options->{function} = $name;
	}
	
	my $pd = Devel::DTrace::Provider::ProbeDef->new($name, $options->{function});
	for my $type (@types) {
		if (!defined $Typemap->{$type}) {
			die "type '$type' invalid";
		}
		push @{$pd->args}, $Typemap->{$type};
	}
	push @{$self->{_probe_defs}}, $pd;
}

sub dof_size {
	my ($self) = @_;
	my $probes = scalar @{$self->{_probe_defs}};
	my $args = 0;
	for my $probe (@{$self->{_probe_defs}}) {
		$args += scalar @{$probe->args};
	}
	
	my $size = 0;
	for my $sec (
		     DOF_DOFHDR_SIZE(),
		     (DOF_SECHDR_SIZE() * 6),
		     $self->{_strtab}->length,
		     (DOF_PROBE_SIZE() * $probes),
		     (DOF_PRARGS_SIZE() * $args),
		     (DOF_PROFFS_SIZE() * $probes),
		     (DOF_PRENOFFS_SIZE() * $probes),
		     DOF_PROVIDER_SIZE()
		    ) {
		$size += $sec;
		my $i = $size % 8;
		if ($i > 0) {
			$size += int((8 - $i));
		}
	}
	return $size;
}

sub enable {
	my ($self) = @_;

	my $f = Devel::DTrace::DOF::File->new();

 	$self->{_strtab} = Devel::DTrace::DOF::Section::Strtab->new(0);
 	my $provider_name_idx = $self->{_strtab}->add($self->{_name});
	push @{$f->sections}, $self->{_strtab};

	my $s = Devel::DTrace::DOF::Section->new(DOF_SECT_PROBES, 1);
	my $probes = [];
	my $argidx = 0;
	my $offidx = 0;

	$self->{_probes} = {};
	
	for my $pd (@{$self->{_probe_defs}}) {
		my $argc = $pd->argc;
		
		my $argv = 0;
		for my $type (@{$pd->args}) {
			my $i = $self->{_strtab}->add($type);
			$argv = $i if $argv == 0;
		}
		
		my $probe = Devel::DTrace::Probe->new($argc);
		push @$probes, 
		{
		 name     => $self->{_strtab}->add($pd->name),
		 func     => $self->{_strtab}->add($pd->function),
		 noffs    => 1,
		 enoffidx => $offidx,
		 argidx   => $argidx,
		 nenoffs  => 1,
		 offidx   => $offidx,
		 addr     => $probe->addr,
		 nargc    => $argc,
		 xargc    => $argc,
		 nargv    => $argv,
		 xargv    => $argv,
		};
		$self->{_probes}->{$pd->name} = $probe;
		$argidx += $argc;
		$offidx++;
	}
	$s->data($probes);
	push @{$f->sections}, $s;

	$s = Devel::DTrace::DOF::Section->new(DOF_SECT_PRARGS, 2);
	my @data;
	for my $pd (@{$self->{_probe_defs}}) {
		for my $i (0 .. (scalar @{$pd->args}) - 1) {
			push @data, $i;
		}
	}
	if (scalar @data == 0) {
		push @data, 0;
	}
	$s->data([@data]);
	push @{$f->sections}, $s;

	$f->allocate($self->dof_size);

	$s = Devel::DTrace::DOF::Section->new(DOF_SECT_PROFFS, 3);
	@data = ();
	for my $pd (@{$self->{_probe_defs}}) {
		push @data, $self->{_probes}->{$pd->name}->probe_offset($f->addr, $pd->argc);
	}
	if (scalar @data == 0) {
		push @data, 0;
	}
	$s->data([@data]);
	push @{$f->sections}, $s;

	$s = Devel::DTrace::DOF::Section->new(DOF_SECT_PRENOFFS, 4);
	@data = ();
	for my $pd (@{$self->{_probe_defs}}) {
		push @data, $self->{_probes}->{$pd->name}->is_enabled_offset($f->addr);
	}
	if (scalar @data == 0) {
		push @data, 0;
	}
	$s->data([@data]);
	push @{$f->sections}, $s;

 	$s = Devel::DTrace::DOF::Section->new(DOF_SECT_PROVIDER, 5);
 	my $provider = {
			strtab => 0,
			probes => 1,
			prargs => 2,
			proffs => 3,
			prenoffs => 4,
			name   => $provider_name_idx,

			provattr => { 
				     name  => DTRACE_STABILITY_EVOLVING,
				     data  => DTRACE_STABILITY_EVOLVING,
				     class => DTRACE_STABILITY_EVOLVING 
				    },
			modattr  => { 
				     name => DTRACE_STABILITY_PRIVATE,
				     data => DTRACE_STABILITY_PRIVATE,
				     class => DTRACE_STABILITY_EVOLVING 
				    },
			funcattr => { 
				     name => DTRACE_STABILITY_PRIVATE,
				     data => DTRACE_STABILITY_PRIVATE,
				     class => DTRACE_STABILITY_EVOLVING
				    },
			nameattr => { 
				     name => DTRACE_STABILITY_EVOLVING,
				     data => DTRACE_STABILITY_EVOLVING,
				     class => DTRACE_STABILITY_EVOLVING
				    },
			argsattr => {
				     name => DTRACE_STABILITY_EVOLVING,
				     data => DTRACE_STABILITY_EVOLVING,
				     class => DTRACE_STABILITY_EVOLVING
				    },
		       };

 	$s->data($provider);
 	push @{$f->sections}, $s;

	$f->generate;
	$f->loaddof($self->{_module});
	$self->{_file} = $f; # reference to File keeps provider alive
	
	return $self->{_probes};
}

sub probe_function { 
	my ($self, $probe_name) = @_;
	my $stub = $self->{_probes}->{$probe_name};
 	return sub (&) { shift->($stub) if $stub->is_enabled };
}

sub probe_enabled_function { 
	my ($self, $probe_name) = @_;
	my $stub = $self->{_probes}->{$probe_name};
	return sub { $stub->is_enabled };
}

1;

__END__

=pod

=head1 NAME

Devel::DTrace::Provider - Create DTrace providers for Perl programs.

=head1 SYNOPSIS

  # Create a provider in OO style:

  use Devel::DTrace::Provider;
    
  my $provider = Devel::DTrace::Provider->new('provider1', 'perl');
  $provider->probe('probe1', 'string');
  my $probes = $provider->enable;

  $probes->{probe1}->fire('foo');

  # or, with the Builder module, declaratively:

  use Devel::DTrace::Provider::Builder;

  provider 'provider1' => as {
    probe 'probe1', 'string';
  };

  probe1 { shift->fire('foo') } if probe1_is_enabled;

=head1 DESCRIPTION

This module lets you create DTrace providers for your Perl programs,
from Perl - no further native code is required. 

If you want to create providers to form part of a larger application,
in a more declarative style, see Devel::DTrace::Provider::Builder --
this module provides the raw API, and is more suitable for small
scripts.

When you create a provider and call its C<enable> method, the following
happens:

Native functions are created for each probe, containing the DTrace
tracepoints to be enabled later by the kernel. DOF (DTrace Object
Format) is then generated representing the provider and the
tracepoints generated, and is inserted into the kernel via the DTrace
helper device. Perl functions are created for each probe, so they can
be fired from Perl code.

Your program does not need to run as root to create providers.

Providers created by this module should survive fork(), and become
visible from both parent and child processes separately.  Redefining a
provider should be possible within the same process. These two
features permit providers to be created by mod_perl applications. 

This module may be installed on systems which do not support DTrace:
in this case, no native code is built, and providers created by the
Builder module will be stubbed out such that there is zero runtime
overhead. This can be useful for applications which should run on
multiple platforms while still having the probe code embedded. 

=head2 Using Perl providers

=over4

=item Listing probes available

To list the probes created by your providers, invoke dtrace(1):

  $ sudo /usr/sbin/dtrace -l -n 'myprovider*:::'

where "myprovider" is the name of your provider. To restrict this to a
specific process by PID, replace the * by the pid:

  $ sudo /usr/sbin/dtrace -l -n 'myprovider1234:::'

=item Observing probe activity

To just see the probes firing, use a command like:

  $ sudo /usr/sbin/dtrace -n 'myprovider*:::'

If your script is not already running when you run dtrace(1), use the
-Z flag, which indicates that dtrace(1) should wait for the probes to
be created, rather than exiting with an error:

  $ sudo /usr/sbin/dtrace -Z -n 'myprovider*:::'

=item Collecting probe arguments

To collect arguments from a specific probe, you can use the trace()
action:

  $ sudo /usr/sbin/dtrace -n 'myprovider*:::myprobe{ trace(arg0); }'

for an integer argument, and:

  $ sudo /usr/sbin/dtrace -n 'myprovider*:::myprobe{ trace(copyinstr(arg0)); }'
  
for a string argument. 

There are numerous other actions and predicates - see the DTrace guide
for full details:

  http://docs.sun.com/app/docs/doc/817-6223

=back

=head1 CAVEATS

=head2 Platform support

This release supports DTrace on both Solaris and Mac OS X Leopard, but
only on i386, 32 bit. 

Support for Solaris on SPARC, OS X on PowerPC and 64 bit processes
will follow.

=head2 Testing

The tests in the distribution do not actually verify the probes are
created or fired, because DTrace requires additional privileges. It's
also complex to start an external dtrace(1) to perform the testing. 

However, they do verify that it's possible to run the provider
creation code. I plan to add optional tests which do full testing if
run with additional privileges.

=head1 METHODS

=head2 new($provider_name, $module_name)

Create a provider. Takes the name of the provider, and the name of the
module it should appear to be in to DTrace (in native code this would
be the library, kernel module, executable etc). 

Returns an empty provider object. 

=head2 probe($probe_name, @argument_types...)

Adds a probe to the provider, named $probe_name. Arguments are set up
with the types specified. Supported types are 'string' (char *) and
'integer' (int). A maximum of eight arguments is supported. 

=head2 enable()

Actually adds the provider to the running system. Croaks if there was
an error inserting the provider into the kernel, or if memory could
not be allocated for the tracepoint functions.

Returns a hash of probe "stubs", Devel::DTrace::Probe objects. 

=head1 DEVELOPMENT

The source to Devel::DTrace::Provider is in github:

  http://github.com/chrisa/perl-dtrace/tree/master/Devel-DTrace-Provider


=head1 AUTHOR

Chris Andrews <chris@nodnol.org>

=head1 LICENCE AND COPYRIGHT

Copyright (C) 2008, Chris Andrews <chris@nodnol.org>. All rights reserved. 

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut









