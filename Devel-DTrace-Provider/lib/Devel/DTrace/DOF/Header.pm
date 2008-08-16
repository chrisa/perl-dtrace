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
