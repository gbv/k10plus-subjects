#!/bin/bash

TSV=clean-subjects.tsv
RDF=k10plus-subjects.nt.gz

N1=$(zcat $TSV | awk '{print $1}' | uniq | wc -l)
N2=$(zcat $TSV | wc -l)
N1=$(printf "%'d" $N1)
N2=$(printf "%'d" $N2)

echo "The TSV dataset is $N1 records and $N2 links to concepts."
echo
echo "Number of concepts per vocabulary:"
echo
zcat $TSV | awk '{print $2}' | perl -lnE '$h{$_}++; END{printf "$_\t%9d\n", $h{$_} for keys %h}' | sort -nk2
echo
echo "Number of RDF Triples: " $(zcat $RDF | wc -l)
