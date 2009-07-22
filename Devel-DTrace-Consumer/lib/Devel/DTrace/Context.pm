package Devel::DTrace::Context;
use strict;
use warnings;

sub probes (&) {
	my ($self, $callback) = @_;
	$self->_probes($callback);	
}

1;
