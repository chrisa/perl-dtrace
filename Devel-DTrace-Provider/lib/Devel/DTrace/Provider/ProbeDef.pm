package Devel::DTrace::Provider::ProbeDef;
use strict;
use warnings;

sub new {
	my ($class, $name, $function) = @_;
	my $self = bless {}, $class;
	$self->{_name} = $name;
	$self->{_function} = $function;
	$self->{_args} = [];
	return $self;
}

sub argc {
	my ($self) = @_;
	return scalar @{$self->{_args}};
}

sub args {
	my ($self) = @_;
	return @{$self->{_args}};
}

sub name {
	my ($self) = @_;
	return $self->{_name};
}

sub function { 
	my ($self) = @_;
	return $self->{_function};
}

1;
