package Devel::DTrace::Probe;
use strict;
use warnings;

1;

__END__

=head1 NAME

Devel::DTrace::Probe - a live DTrace probe

=head1 SYNOPSIS

  use Devel::DTrace::Provider;
    
  my $provider = Devel::DTrace::Provider->new('provider1', 'perl');
  $provider->probe('probe1', 'string');
  my $probes = $provider->enable;
  
  if ($probes->{probe1}->is_enabled()) {
    $probes->{probe1}->fire('foo');
  }

=head1 DESCRIPTION

This is the actual probe object, providing methods to call the
'is_enabled' tracepoint function, and the actual 'fire' tracepoint
function.

=head1 METHODS

=head2 is_enabled

Returns a true value if the probe is currently enabled by DTrace. You
can use this to determine whether to spend time gathering arguments
for the probe.

=head2 fire

Fires the probe. Expects to be called with as many arguments of the
appropriate type as were declared for the probe. 

=cut
