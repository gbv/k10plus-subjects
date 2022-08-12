#!/usr/bin/env perl
use v5.14;
use FindBin;
use lib $FindBin::Bin;
use FixPica;

# Remove letter in front of DDC notation
replace_non_repeated_subfield(
    '045F$a',
    sub {
        my ( $field, $value ) = @_;
        $value =~ s{^[a-z]([0-9.'/]+)$}{$1};
        return $value;
    }
);

