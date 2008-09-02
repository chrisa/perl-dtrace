package Test::Provider2;
use strict;
use warnings;

use Devel::DTrace::Provider::Builder;

provider 'provider2' => as {
	probe 'probe3';
	probe 'probe4';
};

provider 'provider3' => as {
	probe 'probe5';
	probe 'probe6';
};

1;
