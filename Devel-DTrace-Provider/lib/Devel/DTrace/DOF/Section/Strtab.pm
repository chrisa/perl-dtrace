package Devel::DTrace::DOF::Section::Strtab;
use strict;
use warnings;

use base qw/ Devel::DTrace::DOF::Section /;

use Devel::DTrace::DOF::Constants qw/ :all /;

sub new {
	my ($class, $index) = @_;
	my $self = $class->SUPER::new(DOF_SECT_STRTAB, $index);
	$self->{_data} = [];
	$self->{_idx} = 1;
	return $self;
}

sub add {
	my ($self, $string) = @_;
	my $idx = $self->{_idx};
	$self->{_idx} += (length $string) + 1;
	push @{$self->{_data}}, $string;
	return $idx;
}

sub length {
	my ($self) = @_;
	return $self->{_idx};
}

sub compute_entsize {
	my ($self) = @_;
	return 0;
}

1;
