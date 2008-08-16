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
	print STDERR "allocating $size bytes\n";
	$self->{_filedata}->allocate($size);
}

sub append {
	my ($self, $data) = @_;
	printf STDERR "appending %d bytes\n", length $data;
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
		if ($section->align > 1) {
			my $i = $section->offset % $section->align;
			print STDERR "i: $i\n";
			if ($i > 0) {
				my $pad = int ($section->align - $i);
				print STDERR "pad: $pad\n";
				$section->offset($pad + $section->offset);
				$section->pad("\0" x $pad);
			}
		}

		$section->size($length + $pad);
		
		$loadsz += $section->size if ($section->flags & 1) == 1;
		$filesz += $section->size;
	}
	
	$hdr->loadsz($loadsz);
	$hdr->filesz($filesz);
	$hdr->dof_version($dof_version);
	
	print STDERR "header\n";
	$self->append($hdr->generate);
	
	for my $section (@{$self->{_sections}}) {
		print STDERR "section header\n";
		$self->append($section->header);
	}
	
	for my $section (@{$self->{_sections}}) {
		print STDERR "padding\n" if $section->pad;
		$self->append($section->pad) if $section->pad;
		print STDERR "section DOF: $section->{_index}, offset $section->{_offset}\n";
		$self->append($section->dof);
	}

	printf STDERR "DOF len: %d\n", length $self->{_filedata}->data;
	
	#use URI::Escape;
	#printf STDERR "DOF:\n%s\n", uri_escape($self->{_filedata}->data);
	
	open DOF, ">dof$$" or die "can't write to dof$$: $!";
	print DOF $self->{_filedata}->data;
	close DOF;
}

1;
				     
	
