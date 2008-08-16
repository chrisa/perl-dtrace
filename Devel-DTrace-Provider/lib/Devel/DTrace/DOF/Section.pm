package Devel::DTrace::DOF::Section;
use strict;
use warnings;

use Carp qw/ confess /;

use Devel::DTrace::DOF::Constants qw/ :all /;

sub new {
	my ($class, $type, $index) = @_;
	my $self = bless {}, $class;

	$self->{_section_type} = $type;
	$self->{_index}	       = $index;
	$self->{_flags}	       = 1; # DOF_SECF_LOAD
	$self->{_data}	       = {};
	$self->{_align}	       = $self->align;
	$self->{_offset}       = 0;
	$self->{_size}	       = 0;

	return $self;
}

sub section_type {
	my ($self) = @_;
	return $self->{_section_type};
}

sub dof {
	my ($self) = @_;
	return $self->{_dof};
}

sub entsize {
	my ($self, $entsize) = @_;
	$self->{_entsize} = $entsize;
}

sub flags {
	my ($self, $flags) = @_;
	if (defined $flags) {
		$self->{_flags} = $flags;
	}
	return $self->{_flags};
}

sub data {
	my ($self, $data) = @_;
	if (defined $data) {
		$self->{_data} = $data;
	}
	return $self->{_data};
}

sub offset {
	my ($self, $offset) = @_;
	if (defined $offset) {
		$self->{_offset} = $offset;
	}
	return $self->{_offset};
}

sub pad {
	my ($self, $pad) = @_;
	if (defined $pad) {
		$self->{_pad} = $pad;
	}
	return $self->{_pad};
}

sub size {
	my ($self, $size) = @_;
	if (defined $size) {
		$self->{_size} = $size;
	}
	return $self->{_size};
}

sub generate {
	my ($self) = @_;

	my $sections = {
			&DOF_SECT_COMMENTS => \&dof_generate_comments,
			&DOF_SECT_STRTAB   => \&dof_generate_strtab,
			&DOF_SECT_PROBES   => \&dof_generate_probes,
			&DOF_SECT_PRARGS   => \&dof_generate_prargs,
			&DOF_SECT_PROFFS   => \&dof_generate_proffs,
			&DOF_SECT_PRENOFFS => \&dof_generate_prenoffs,
			&DOF_SECT_PROVIDER => \&dof_generate_provider,
			&DOF_SECT_UTSNAME  => \&dof_generate_utsname,
		       };	

	if (defined $sections->{$self->{_section_type}}) {
		$self->{_dof} = $sections->{$self->{_section_type}}->($self);
	}
	else {
		return;
	}

	if (ref $self->{_data} eq 'ARRAY') {
		if (scalar @{$self->{_data}} > 0) {
			$self->{_entsize} = length($self->{_dof}) / scalar @{$self->{_data}};
		}
		else {
			$self->{_entsize} = 0;
		}
	}
	else {
		$self->{_entsize} = 0;
	}

	return length $self->{_dof};
}

sub align {
	my ($self) = @_;

	my $alignments = {
			  &DOF_SECT_COMMENTS => 1,
			  &DOF_SECT_STRTAB   => 1,
			  &DOF_SECT_PROBES   => 8,
			  &DOF_SECT_PRARGS   => 1,
			  &DOF_SECT_PROFFS   => 4,
			  &DOF_SECT_PRENOFFS => 4,
			  &DOF_SECT_PROVIDER => 4,
			  &DOF_SECT_UTSNAME  => 1,
			 };

	confess "unknown type: $self->{_section_type}"
	     unless defined $alignments->{$self->{_section_type}};

	return $alignments->{$self->{_section_type}};
}
			
1;
