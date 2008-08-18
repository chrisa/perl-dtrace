package Devel::DTrace::Provider;

use 5.008;
use strict;
use warnings;

=head1 NAME

Devel::DTrace::Provider - Create DTrace providers from Perl.

=cut


BEGIN {
	our $VERSION = '0.01';
	require XSLoader;
	XSLoader::load('Devel::DTrace::Provider', $VERSION);
}

use Devel::DTrace::DOF;
use Devel::DTrace::DOF::Constants qw/ :all /;
use Devel::DTrace::Probe;
use Devel::DTrace::Provider::ProbeDef;

our $Typemap = { string => 'char *', integer => 'int' };

sub new {
	my ($class, $provider_name, $module_name) = @_;
	my $self = bless {}, $class;
	$self->{_name} = $provider_name;
	$self->{_module} = $module_name;
	$self->{_class} = ucfirst $provider_name; # .camelize better
	$self->{_probe_defs} = [];
	return $self;
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
	my $stubs = {};
	my $argidx = 0;
	my $offidx = 0;
	
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
		$stubs->{$pd->name} = $probe;
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
		push @data, $stubs->{$pd->name}->probe_offset($f->addr, $pd->argc);
	}
	if (scalar @data == 0) {
		push @data, 0;
	}
	$s->data([@data]);
	push @{$f->sections}, $s;

	$s = Devel::DTrace::DOF::Section->new(DOF_SECT_PRENOFFS, 4);
	@data = ();
	for my $pd (@{$self->{_probe_defs}}) {
		push @data, $stubs->{$pd->name}->is_enabled_offset($f->addr);
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

	return $stubs;
}

1;
