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
				     
	
