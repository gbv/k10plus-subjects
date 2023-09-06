#!/bin/bash

DIR=${1:-.}
TSV=$DIR/kxp-subjects.tsv.gz
RDF=$DIR/kxp-subjects.nt.gz

records=$(zcat $TSV | awk '{print $1}' | uniq | wc -l)
links=$(zcat $TSV | wc -l)
triples=$(zcat $RDF | wc -l)
subjects=$(zcat $TSV | awk '{print $2}' | perl -lnE '$h{$_}++; END{printf ",\"$_\":\ %d\n", $h{$_} for keys %h}' | sort -nrk2)

cat << JSON | jq
{
  "records": $records,
  "links": $links,
  "triples": $triples,
  "subjects": { ${subjects:1} }
}
JSON
