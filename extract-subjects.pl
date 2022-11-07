#!/usr/bin/env perl
use v5.14.1;
use JSON::PP;

# load extraction rules
my %map =
  map { $_->{PICA} => [ $_->{VOC}, qr{$_->{ID}}, qr{$_->{SRC}} ] }
  @{ decode_json do { local ( @ARGV, $/ ) = 'vocabularies.json'; <> }
  };

# read normalized PICA+ (one record per line)
while (<>) {
    my $ppn;
    my %seen;

    # iterate fields
    for ( split /\x1E/ ) {
        my ( $field, $rest ) = split ' ', $_, 2;
        my ( undef, @sf ) = split /\x1F/, $rest;

        # PPN should be one of the first fields
        if ( $field eq '003@' ) {
            $ppn = substr $sf[0], 1;
            next;
        }

        # handle occurrence ranges
        if ( $field =~ qr{^(044[KL])/} ) {    # GND 044[KL]/00-99
            $field = '044K/00-99|044L/00-99';
        }
        elsif ( $field =~ qr{^045D/(..)} && $1 <= 48 ) {    # STW 045D/00-48
            $field = '045D/00-48';
        }

        # extract from subject fields
        my $spec = $map{$field} or next;

        my ( $id, @src );
        my ( $voc, $idPattern, $srcPattern ) = @$spec;
        for (@sf) {
            if ( $_ =~ $idPattern ) {
                $id = $1;
            }
            elsif ( $_ =~ $srcPattern ) {
                push @src, $1;
            }
        }

        if ( defined $id ) {
            my $row = join "\t", $voc, $id, join '|', @src;

            # remove dupliates (they may still exist if source is ignored)
            say "$ppn\t", $row unless $seen{$row}++;
        }
    }
}
