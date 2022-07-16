#!/usr/bin/env perl
use v5.14.1;

open( my $csv, "<", "classifications.csv" );
my %classifications = map { chomp; split ",", $_ } <$csv>;

# TODO: take notationPattern from configuration
my %patterns = (
    ddc => qr/^([0-9]{1,3}|[0-9]{3}\.[0-9]+)$/,
    bk  => qr/^(0|1-2|3-4|5|7-8|[0-9]{2}(\.[0-9]{2})?)$/,
    rvk =>
qr/^(LD,)?[A-Z]([A-Z]( [0-9]+([a-z]|\.[0-9]+)?( [A-Z][0-9]*)?)?)?( - [A-Z]([A-Z]( [0-9]+([a-z]|\.[0-9]+)?( [A-Z][0-9]*)?)?)?)?$/,
);

my %cleanups = (
    ddc => sub {
        $_[0] =~ s![\\/']!!g;
        $_[0];
    }
);

for my $voc ( keys %classifications ) {
    next unless -f "$voc.tsv";

    my $cleanup = $cleanups{$voc};
    my $pattern = $patterns{$voc};

    open my $tsv, "<", "$voc.tsv";
    my $ppn;
    my %seen = ();
    while (<$tsv>) {
        my ( $id, $notation, $source ) = split "\t", $_;

        # cleanup and filter notations
        $notation =~ s/^\s|\s+$//g;
        $notation = $cleanup->($notation) // '' if $cleanup;
        if ( $pattern && $notation !~ $pattern ) {
            say STDERR "$ppn\t$voc\t$notation";
            $notation = '';
        }

        # skips dupliated notations on same PPN (if lines grouped by PPN)
        if ( $id ne $ppn ) {
            %seen = ();
            $ppn  = $id;
        }
        else {
            next if $seen{$notation};
        }
        $seen{$notation} = 1;

        say "$ppn\t$voc\t$notation" if $notation ne '';
    }
    close $tsv;
}
