package FixPica;

use v5.14;
use PICA::Data ':all';

use base 'Exporter';
our @EXPORT = qw(replace_non_repeated_subfield);

# generic
sub replace_non_repeated_subfield {
    my $path = shift;
    my $fix  = shift;

    my $parser = pica_parser('plus');
    my $writer = pica_writer( 'plain', annotate => 1 );

    while ( my $record = $parser->next ) {
        my $ppn = $record->fields('003@');
        next if @$ppn ne 1;

        my @changes;

        # TODO: pica_modify_subfield ?
        for my $field ( @{ $record->fields($path) } ) {
            my @values = pica_values( [$field], $path );
            next if @values != 1;

            my $fixed = $fix->( $field, $values[0] );
            if ( defined $fixed && $fixed ne $values[0] ) {
                my $after = [@$field];

                pica_annotation( $field, '-' );

                # FIXME: pica_update is not exported?
                PICA::Data::pica_update( [$after], $path, $fixed );
                pica_annotation( $after, '+' );
                push @changes, $field, $after;
            }
        }

        $writer->write( [ $ppn->[0], @changes ] ) if @changes;
    }
}

1;
