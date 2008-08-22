my $dtracefd;

sub dtrace_start {
	my ($script, $time) = @_;
	
	my $collect_time = $time . 's';
	my $time_ns = $time * 1_000_000_000;

	print STDERR "PID: $$\n";

	my $dtrace = <<END_OF_DTRACE;
/usr/sbin/dtrace -Z -n 'dtrace:::BEGIN { start = timestamp; }' -n '$script' -n 'profile:::tick-$collect_time, profile:::tick-1s/timestamp - start >= $time_ns/{ exit(0); }'
END_OF_DTRACE

	print STDERR $dtrace;

        open $dtracefd,"$dtrace |" or die "can not start dtrace: $!";
	select undef, undef, undef, 0.1;
}

sub dtrace_stop {
	return unless defined $dtracefd;
	my $output;
	while (my $line = <$dtracefd>) {
		$output .= $line;
	}
	print STDERR "output: $output\n";
	return $output;
}

1;
