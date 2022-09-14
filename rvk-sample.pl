#!/usr/bin/perl
use v5.14.1;
my $percentage = 500 / 6572521;
my @cur;
while (<>) {
    chomp;
    my ( $ppn, $voc, $id ) = split "\t";
    next if $voc ne 'rvk';
    if ( $ppn eq $cur[0] ) {
        push @cur, $id;
    }
    else {
        say join "\t", @cur if @cur and rand() < $percentage;
        @cur = ( $ppn, $id );
    }
}

