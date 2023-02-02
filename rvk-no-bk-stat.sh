#!/usr/bin/bash

zcat kxp-subjects.tsv.gz | awk -F"\t" '$2 == "rvk"  || $2 == "bk" {print $1,$2}' | uniq \
    | awk '$1!=ppn{if(rvk && !bk) { print ppn } bk=0; rvk=0; ppn=$1} $2=="rvk" {rvk=1} $2=="bk" {bk=1}'
