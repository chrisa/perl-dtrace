package Devel::DTrace::Provider::Builder;
use strict;
use warnings;
use Devel::DTrace::Provider;

our %providers;

sub import {
	my $caller_package = caller(0);

	my $coderef;
	my $provider;

	my $provider_sub = sub ($$) {
		my $provider_name = shift;
		$provider = Devel::DTrace::Provider->new($provider_name, 'perl');
		$coderef->();
		$provider->enable;
		$providers{$caller_package} ||= [];
		push @{$providers{$caller_package}}, $provider;
	};

	my $as_sub = sub (&) {
		$coderef = shift;
	};

	my $probe_sub = sub ($;@) {
		my $probe_name = shift;
		my @args = @_;
		$provider->probe($probe_name, @args);
	};
		
	my $import_sub = sub {
		my $using_package = shift;
		my $caller_package = caller(0);
		
		my $providers = $providers{$using_package};
		die "no provider for $using_package" unless defined $providers;
		
		for my $provider (@$providers) {
			for my $probe_name ($provider->probe_names) {
				no strict 'refs';
				*{"${caller_package}::${probe_name}"} = $provider->probe_function($probe_name);
				*{"${caller_package}::${probe_name}_enabled"} = $provider->probe_enabled_function($probe_name);
			}
		}
	};
	
	{
		no strict 'refs';
		*{"${caller_package}::provider"} = $provider_sub;
		*{"${caller_package}::as"}       = $as_sub;
		*{"${caller_package}::probe"}    = $probe_sub;
		*{"${caller_package}::import"}   = $import_sub;
	}
}

1;

__END__

=pod

=head1 NAME 

Devel::DTrace::Provider::Builder - declaratively create DTrace USDT providers

=head1 SYNOPSIS

  package MyApp::DTraceProviders;

  use strict;
  use warnings;

  use Devel::DTrace::Provider::Builder;

  provider 'backend' => as {
      probe 'process_start', 'integer';
      probe 'process_end',   'integer';
  };

  provider 'frontend' => as {
      probe 'render_start', 'string';
      probe 'render_end',   'string';
  };

  # elsewhere

  use MyApp::DTraceProviders;

  process_start

=head1 DESCRIPTION

This module provides a declarative way of creating DTrace providers,
in packages which export their probes on import. This is typically
what you want when creating a provider for use in a large application:

=over 4

=item Declare your provider in its own package

=item Use the provider in your application

=item Fire the probes imported

=back

=head2 Declare the providers

You can declare any number of providers in a single package: they will
all be enabled and their probes imported when the package is used. 

The general syntax of a provider declaration is:

  provider 'provider_name' => as {
    probe 'probe_name', [ 'argument-type', ... ];
    ...
  };

The supported argument types are 'integer' and 'string', corresponding
to native int and char * probe arguments. 

=head2 Use the provider

Just use the package where you defined the provider:

  use MyApp::DTraceProviders;

This will import all the probe subs defined in the package into your
namespace.

=head2 Fire the probes

To fire a probe, call the function, passing a coderef in which you
call the C<fire> method on C<$_[0]>:

  probe { shift->fire };

The coderef is only called if the probe is enabled by DTrace, so you
can do whatever work is necessary to gather probe arguments and know
that code will not run when DTrace is not active:

  probe { 
    my @args = gather_expensive_args();
    shift->fire(@args);
  }; 

=head1 DISABLED PROBE EFFECT

Two features allow you to reduce the disabled probe effect:

=over 4

=item Argument-gathering coderef

=item *_enabled functions

=back

=head2 Argument-gathering coderef

This applies to code on DTrace enabled systems: the coderef is
only executed if the probe is enabled, so you can put code there which
only runs when tracing is active. 

=head2 *_enabled functions

This applies to systems without DTrace: if you form your probe
tracepoints with a postfix if, like this:

  fooprobe { shift->fire } if fooprobe_enabled();

on a system without DTrace, fooprobe_enabled will be a constant sub
returning 0, and the entire line will be optimised away, which means
probes embedded in code have zero overhead. This feature is taken from
Tim Bunce's DashProfiler:

http://search.cpan.org/~timb/DashProfiler-1.13/lib/DashProfiler/Import.pm

=head1 CAVEATS

This code only works on Mac OS X 10.5 "Leopard" and Solaris 10U1 and
later (including OpenSolaris, SXCE, etc), running on i386 or x86_64
with a 32 bit perl. SPARC and PowerPC are currently unsupported.

=cut
