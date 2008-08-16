package Devel::DTrace::DOF::File;
use strict;
use warnings;

use Devel::DTrace::DOF::Constants qw/ :all /;

sub new {
	my ($class) = @_;
	my $self = bless {}, $class;
	$self->{sections} = [];
	return $self;
}

sub generate {
	my ($self) = @_;
	my $hdr = Devel::DTrace::DOF::Header->new();
	$hdr->secnum(scalar @{$self->{sections}});
	my $filesz = $hdr->hdrlen;
	my $loadsz = $filesz;
	my $dof_version = 1;
	
	for my $section (@{$self->{sections}}) {
		if ($section->section_type == DOF_SECT_PRENOFFS) {
			$dof_version = 2;
		}
		
		my $length = $section->generate;
		$s->offset($filesz);
		
		my $pad = 0;
		if ($s->align > 1) {
			my $i = $s->offset % $s->align;
			if ($i > 0) {
				my $pad = int ($s->align - $i);
				$s->offset($pad + $s->offset);
				$s->pad("\0" x $pad);
			}
		}

		$s->size($length + $pad);
		
		$loadsz += $s->size if ($s->flags & 1) == 1;
		$filesz += $s->size;
	}
	
	$hdr->loadsz($loadsz);
	$hdr->filesz($filesz);
	$hdr->dof_version($dof_version);
	
	$self->append_dof($hdr->generate);
	
	for my $section (@{$self->{sections}}) {
		$self->append_dof($s->generate_header);
	}
	
	for my $section (@{$self->{sections}}) {
		$self->append_dof($s->pad) if $s->pad;
		$self->append_dof($s->dof);
	}
}

1;
				     
	
