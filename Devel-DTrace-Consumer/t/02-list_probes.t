use strict;
use warnings;

use Test::More tests => 1;
use Devel::DTrace::Consumer;
use Devel::DTrace::Context;

my $c = Devel::DTrace::Context->new;
ok($c);

# my $iter = $c->probes;
# ok($iter);

# while (my $probe = $iter->next) {
# 	ok($probe);
# 	ok($probe->provider);
# 	ok($probe->module);
# 	ok($probe->function);
# 	ok($probe->name);
# }

$c->probes(sub {
		   my $probe = shift;
		   ok($probe);
		   ok($probe->provider);
		   ok($probe->module);
		   ok($probe->function);
		   ok($probe->name);

# 		   printf ("%s:%s:%s:%s\n",
# 			   $probe->provider,
# 			   $probe->module,
# 			   $probe->function,
# 			   $probe->name);
	   });
