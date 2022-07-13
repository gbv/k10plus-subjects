#!/usr/bin/env bash

for voc in `awk -F',' '{print $1}' classifications.csv`
do
  if [ -f $voc.tsv ]; then
    # skips dupliated notations on same PPN (if lines grouped by PPN)
    awk -F'\t' '
      BEGIN { OFS="\t" }
      {      
        if ($1 != ppn) { delete(seen); ppn=$1 }
        else if(seen[$2]) next
        seen[$2]++
        print $1,"'$voc'",$2
      }
    ' $voc.tsv
  fi
done
