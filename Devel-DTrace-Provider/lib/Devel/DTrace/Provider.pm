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

Devel::DTrace::Provider - Create DTrace providers from Perl.

=head1 SYNOPSIS

  use Devel::DTrace::Provider;
    
  my $provider = Devel::DTrace::Provider->new('provider1', 'perl');
  $provider->probe('probe1', 'string');
  my $probes = $provider->enable;

  $probes->{probe1}->fire('foo');

=head1 DESCRIPTION

This module lets you create DTrace providers from Perl. 

If you want to create providers to form part of a larger application,
in a more declarative style, see Devel::DTrace::Provider::Builder --
this module provides the raw API, and is more suitable for small
scripts.

When you create a provider and call its enabled method, the following
happens:

Native functions are created for each probe, containing the DTrace
tracepoints to be enabled later by the kernel. DOF (DTrace object
format) is then generated representing the provider and the
tracepoints generated, and is inserted into the kernel via the DTrace
helper device. Perl functions are created for each probe, so they can
be fired from Perl code. 

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

=cut









