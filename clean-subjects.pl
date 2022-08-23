#!/usr/bin/env perl
use v5.14.1;
use JSON::PP;

# notation patterns for validation
my %patterns =
  map  { $_->{VOC} => qr{^$_->{notationPattern}$} }
  grep { $_->{notationPattern} }
  @{ decode_json do { local ( @ARGV, $/ ) = 'vocabularies.json'; <> }
  };

# additional cleanup rules
my %cleanups = (
    ddc => sub {
        $_[0] =~ s![\\/']!!g;
        $_[0];
    }
);

my ( $ppn, %seen );

while (<>) {
    my ( $id, $voc, $notation ) = split "\t", $_;    # ignore sources
    my $pattern = $patterns{$voc} or next;    # ignore vocs without pattern

    # cleanup and filter notations
    $notation =~ s/^\s|\s+$//g;
    $notation = $cleanups{$voc}->($notation) // '' if $cleanups{$voc};
    if ( $pattern && $notation !~ $pattern ) {
        say STDERR "$ppn\t$voc\t$notation";
        next;
    }

    # skips dupliated notations on same PPN (if lines grouped by PPN)
    if ( $id ne $ppn ) {
        %seen = ();
        $ppn  = $id;
    }
    else {
        next if $seen{$voc}{$notation};
    }
    $seen{$voc}{$notation} = 1;

    say "$ppn\t$voc\t$notation" if $notation ne '';
}
