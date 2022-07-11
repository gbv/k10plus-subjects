#!/usr/bin/env bash

for voc in `awk -F',' '{print $1}' classifications.csv`
do
  if [ -f $voc.tsv ]; then
    awk -F'\t' 'BEGIN {OFS="\t"}{print $1,"'$voc'",$2}' $voc.tsv | uniq
  fi
done
