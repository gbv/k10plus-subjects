#!/usr/bin/env bash

declare -A field
while read -r line
do
    IFS=, read -r key value <<< "$line"
    field[$key]="$value"
done < classifications.csv

extract() {
    if [ ! -v 'field[$1]' ]; then
        echo "Unknown vocabulary '$1'"
        exit 1
    fi

    voc=$1
    pp="${field[$voc]}"
    # TODO --reduce "003@,$pp", requires https://github.com/deutsche-nationalbibliothek/pica-rs/issues/463 
    pica filter "003@? && $pp.a?" | pica select "003@.0,$pp{a,A}" --tsv > $voc.tsv
    wc -l $voc.tsv
}

if [[ $# -ne 1 ]]; then
    echo "Usage: cat *.dat | $0 VOC"
    echo "VOC must be one of ${!field[@]}"
else
    extract "$1"
fi
