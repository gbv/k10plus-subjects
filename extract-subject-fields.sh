#!/bin/bash
date=2022-06-30

subjects=kxp-subjects_$date.dat
log=extract.log
full=../kxp-catalog-full_$date

set -e
echo -n > $subjects
echo -n > $log

for dat in  $full/*.dat; do
  pica filter --skip-invalid '003@?' --reduce '003@,013D,013E,044.,045.,144Z,145S,145Z' "$dat" \
      | grep -Pv '^003@..0[0-9X]+.$' >> $subjects
  echo $dat >> $log
done

split -l 5000000 --numeric-suffixes=01 $subjects kxp-subjects_$date_
