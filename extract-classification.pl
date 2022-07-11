#!/usr/bin/perl
use v5.14.1;

open( my $csv, "<", "classifications.csv" );
my %classifications = map { chomp; split ",", $_ } <$csv>;

my ($voc) = @ARGV;
my $field = $classifications{$voc};

die "Usage: $0 " . join( '|', keys %classifications ) . "\n" if !$field;

system(
"pica filter '003@? && $field.a?' --reduce '003@,$field' | pica select '003@.0,$field\{a,A}' --tsv > $voc.tsv"
);
say `wc -l $voc.tsv`;
