#!/usr/bin/env bash

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 VOC PATH"
    echo "Example: $0 rvk 045R < pica.dat"  
    exit 1
fi

voc=$1
path=$2

pica filter "$path.a?" | pica select "003@.0,$path.a" --tsv \
    | awk -F'\t' 'BEGIN {OFS="\t"} {print $1,"'$voc'",$2}'
