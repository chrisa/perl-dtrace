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

sub _compute_entsize {
	my ($self) = @_;
	return 0;
}

1;

__END__

=pod

=head1 NAME

Devel::DTrace::DOF::Section::Strtab - a DOF ELF-style string table

=head1 SYNOPSIS

  my $index = 0;
  my $strtab = Devel::DTrace::DOF::Section::Strtab->new(0);
  $strtab->add('foo');
  $strtab->add('bar');
  my $length = $sec->generate();
  my $dof = $sec->dof();

=head1 DESCRIPTION

Implements an ELF-style string table as a DOF section. Strings can be
added incrementally, but are not uniqued - there will be one instance
of a string in the table for every invocation of add(). 

=head1 METHODS

=head2 new($index)

Constructor. Takes the index of the string table in the DOF, often 0. 

=head2 add($string)

Adds a string to the table, returning its index in the string table (a
byte offset from the start of the table) as required by other DOF
sections.

=head1 SEE ALSO

Devel::DTrace::DOF::Section

=cut

