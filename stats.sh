#!/bin/bash

TSV=kxp-subjects.tsv.gz
RDF=kxp-subjects.nt.gz

num() {
    LC_NUMERIC="en_US.UTF-8"
    printf "%'d" "$1"
}

N1=$(zcat $TSV | awk '{print $1}' | uniq | wc -l)
N2=$(zcat $TSV | wc -l)
N1=$(num $N1)
N2=$(num $N2)

echo "The TSV dataset is $N1 records and $N2 links to concepts."
echo
echo "Number of concepts per vocabulary:"
echo
zcat $TSV | awk '{print $2}' | perl -lnE '$h{$_}++; END{printf "$_\t%9d\n", $h{$_} for keys %h}' | sort -nk2
echo
TRIPLES=$(zcat $RDF | wc -l)
echo "Number of RDF Triples: " $(num $TRIPLES)
