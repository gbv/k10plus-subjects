#!/usr/bin/env perl
use v5.14.1;
use JSON::PP;
use URI::Escape;

my $kxpNamespace = "http://uri.gbv.de/document/opac-de-627:ppn:";

my %vocs =
  map { $_->{VOC} => $_ }
  @{ decode_json do { local ( @ARGV, $/ ) = 'vocabularies.json'; <> }
  };

# expects clean subjects
while (<>) {
    chomp;
    my ( $ppn, $voc, $id ) = split "\t";

    # uriFromNotation
    my $uri;
    if ( $voc eq 'ddc' ) {

        # This is a hack and may include some false attribution to edition 23
        $uri = "http://dewey.info/class/" . uri_escape($id) . "/e23/";
    }
    else {
        $voc = $vocs{$voc} or next;
        my $namespace = $voc->{namespace} or next;
        $uri = $voc->{namespace} . uri_escape($id);
    }

    say "<$kxpNamespace$ppn> <http://purl.org/dc/terms/subject> <$uri> .";
}

__END__

Uses dct:subject

https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/subject
