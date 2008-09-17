package Devel::DTrace::DOF::Header;
use strict;
use warnings;

sub new {
	my ($class) = @_;
	my $self = bless {}, $class;
	return $self;
}

sub loadsz {
	my ($self, $loadsz) = @_;
	if (defined $loadsz) {
		$self->{_loadsz} = $loadsz;
	}
	return $self->{_loadsz};
}

sub filesz {
	my ($self, $filesz) = @_;
	if (defined $filesz) {
		$self->{_filesz} = $filesz;
	}
	return $self->{_filesz};
}

sub secnum {
	my ($self, $secnum) = @_;
	if (defined $secnum) {
		$self->{_secnum} = $secnum;
	}
	return $self->{_secnum};
}

sub dof_version {
	my ($self, $dof_version) = @_;
	if (defined $dof_version) {
		$self->{_dof_version} = $dof_version;
	}
	return $self->{_dof_version};
}

1;

__END__

=pod

=head1 NAME 

Devel::DTrace::DOF::Header - a DOF header

=head1 SYNOPSIS

  my $header = Devel::DTrace::DOF::Header->new();
  $header->secnum(scalar @sections);
  ...
  $header->filesz($size);
  $header->loadsz($load_size);
  $header->dof_version($ver);
  my $dof = $header->generate();

=head1 DESCRIPTION

Represents a DOF header. Used like Devel::DTrace::DOF::Section objects.

=head1 METHODS

=head2 new()

Constructor. Takes no arguments.

=head2 secnum($num)

Sets the number of DOF sections associated with this header.

=head2 loadsz($size)

Sets the "loadable" size of the DOF (full size less any sections not
required by the kernel).

=head2 filesz($size)

Sets the full size of the DOF.

=head2 dof_version($ver)

Sets the version number of this DOF: 

=over 4

=item Version 1: Solaris, without is_enabled probes

=item Version 2: Solaris, with is_enabled probes

=item Version 3: Mac OS X

=back

=head2 generate

Returns the generated DOF section.

=cut
