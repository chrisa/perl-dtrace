package Test::Provider1;
use strict;
use warnings;

use Devel::DTrace::Provider::Builder;

provider 'provider1' => as {
	probe 'probe1', 'string';
	probe 'probe2', 'string';
};

1;
