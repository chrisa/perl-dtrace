package Devel::DTrace::DOF::File;
use strict;
use warnings;

use Devel::DTrace::DOF::FileData;
use Devel::DTrace::DOF::Constants qw/ :all /;

sub new {
	my ($class) = @_;
	my $self = bless {}, $class;
	$self->{_sections} = [];
	$self->{_filedata} = Devel::DTrace::DOF::FileData->new();
	return $self;
}

sub sections {
	my ($self) = @_;
	return $self->{_sections};
}

sub addr {
	my ($self) = @_;
	return $self->{_filedata}->addr;
}

sub allocate {
	my ($self, $size) = @_;
	$self->{_filedata}->allocate($size);
}

sub append {
	my ($self, $data) = @_;
	$self->{_filedata}->append($data);
}

sub data {
	my ($self) = @_;
	return $self->{_filedata}->data;
}

sub loaddof {
	my ($self, $module_name) = @_;
	return $self->{_filedata}->loaddof($module_name);
}

sub generate {
	my ($self) = @_;
	my $hdr = Devel::DTrace::DOF::Header->new();
	$hdr->secnum(scalar @{$self->{_sections}});
	my $filesz = $hdr->hdrlen;
	my $loadsz = $filesz;
	my $dof_version = 1;
	
	for my $section (@{$self->{_sections}}) {
		if ($section->section_type == DOF_SECT_PRENOFFS) {
			$dof_version = 2;
		}
		
		my $length = $section->generate;
		$section->offset($filesz);
		
		my $pad = 0;
		my $align = $section->align;
		my $offset = $section->offset;
		if ($align > 1) {
			my $i = $offset % $align;
			if ($i > 0) {
				$pad = $align - $i;
				$section->offset($pad + $offset);
				$section->pad("\0" x $pad);
			}
		}

		$section->size($length);
		$loadsz += ($section->size + $pad) if ($section->flags & 1) == 1;
		$filesz += ($section->size + $pad);
	}

	$hdr->loadsz($loadsz);
	$hdr->filesz($filesz);
	$hdr->dof_version($dof_version);
	$self->append($hdr->generate);
	
	for my $section (@{$self->{_sections}}) {
		$self->append($section->header);
	}
	
	for my $section (@{$self->{_sections}}) {
		$self->append($section->pad) if defined $section->pad;
		$self->append($section->dof);
	}
}

1;
				     
__END__

=pod

=head1 NAME

Devel::DTrace::DOF::File - a set of DOF sections describing a USDT provider.

=head1 SYNOPSIS

  my $file = Devel::DTrace::DOF::File->new();
  my $section = ... ;
  push @{$f->sections}, $section;
  ...
  $f->allocate($dof_size); 
  $f->generate;
  $f->loaddof($module_name);
 
=head1 DESCRIPTION

Represents the set of DOF sections describing a USDT provider, and
handles loading the generated DOF into the kernel.

The buffer into which the generated DOF is written is part of a File
object, and since the location of the buffer is important--and affects
the probe offsets stored in the DOF--there is a restriction on when
the buffer must be allocated.

On Mac OS X, the location of the probe is given as an offset from the
location of the DOF. This implies that the location of the DOF is
known, which is simple when it's compiled into an executable but less
so when it must be in a buffer on the heap. 

The complication is that the offset is written into the DOF
itself--meaning that you need to estimate the size of the DOF, and
allocate a large enough buffer, before you create the probes. If you
were to reallocate the buffer as required, it would almost certainly
move, invalidating the probe offsets already computed.

A suitable approach is to perform the following operations:

=over 4

=item Evaluate probes and their arguments, creating the string table.

=item Allocate a large-enough DOF buffer based on the probes and strings.

=item Create offset sections and provider section. 

=back

By starting with the probes, arguments and string table, we can
estimate the size of the DOF, then allocate the buffer and continue
computing offsets knowing we don't need to reallocate the buffer.

=head1 METHODS

=head2 new()

Constructor. Returns an empty File object, with no DOF buffer allocated.

=head2 allocate($size)

Allocate a DOF buffer of the given size in bytes. While you can call
this more than once to extend the DOF buffer, if you have already used
the location of the buffer to compute offsets, they will become
invalid. 

=head2 generate()

Run the DOF generation process for all the sections, and compose the
full DOF. Must be called after allocate() has been used to create a
sufficently large buffer. Dies if the buffer is unallocated or too
small.

=head2 loaddof()

Loads the generated DOF into the kernel, via the DTrace helper
device. This does not require root or dtrace privileges. 

=cut
