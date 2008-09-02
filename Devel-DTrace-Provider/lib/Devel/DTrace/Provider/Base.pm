package Devel::DTrace::Provider::Base;
use strict;
use warnings;
#use Sub::Install;
use Data::Dumper;
use Devel::DTrace::Provider;

our %providers;

sub import {
	my $using_package = shift;
	my $caller_package = caller(0);

	if ($using_package eq __PACKAGE__) {
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
		
		{
			no strict 'refs';
			*{"${caller_package}::provider"} = $provider_sub;
			*{"${caller_package}::as"} = $as_sub;
			*{"${caller_package}::probe"} = $probe_sub;
		}

	}
	else {
		my $providers = $providers{$using_package};
		die "no provider for $using_package" unless defined $providers;
	
		for my $provider (@$providers) {
			for my $probe_name ($provider->probe_names) {
				no strict 'refs';
				*{"${caller_package}::${probe_name}"} = $provider->probe_function($probe_name);
			}
		}
	}
}

1;
