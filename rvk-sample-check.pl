#!/usr/bin/perl
use v5.14.1;
use HTTP::Tiny;
use URI::Escape;
use JSON::PP;

# Check whether K10plus records with RVK can automatically be enriched by BK

sub infer {
    my $rvk = shift;

    state %cache;
    if ( !exists $cache{$rvk} ) {
        my %query = (
            fromScheme => "http://bartoc.org/en/node/533",
            toScheme   => "http://bartoc.org/en/node/18785",
            from       => $rvk,
            partOf     => "any",
            strict     => 1,
            type       =>
"http://www.w3.org/2004/02/skos/core#narrowMatch|http://www.w3.org/2004/02/skos/core#narrowMatch"
        );
        my $url = "https://coli-conc.gbv.de/api/mappings/infer?" . join '&',
          map { "$_=" . uri_escape( $query{$_} ) } sort keys %query;

        my $jskos = decode_json( HTTP::Tiny->new->get($url)->{content} );
        $cache{$rvk} = join "|",
          map { $_->{to}{memberSet}[0]{notation}[0] } @$jskos;
    }

    return $cache{$rvk};
}

sub lookup {
    for (@_) {
        my $bk = infer($_);
        return $bk if $bk;    # just take the first enrichment
    }
}

while (<>) {
    chomp;
    my ( $ppn, @rvk ) = split "\t";
    my $bk = lookup(@rvk);
    say $bk ? "$ppn $bk" : $ppn;
}
