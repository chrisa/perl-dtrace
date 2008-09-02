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
		my $caller_package = shift;
		my $using_package = caller(0);
		
		my $providers = $providers{$caller_package};
		die "no provider for $caller_package" unless defined $providers;
		
		for my $provider (@$providers) {
			for my $probe_name ($provider->probe_names) {
				no strict 'refs';
				*{"${using_package}::${probe_name}"} = $provider->probe_function($probe_name);
			}
		}
	};
	
	{
		no strict 'refs';
		*{"${caller_package}::provider"} = $provider_sub;
		*{"${caller_package}::as"} = $as_sub;
		*{"${caller_package}::probe"} = $probe_sub;
		*{"${caller_package}::import"} = $import_sub;
	}
}

1;
