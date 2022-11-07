#!/bin/bash
set -e

error() {
  echo "$1"
  exit 1
}

FROM=$(realpath -s $1) # will die if path not exists
DATE=$(basename $FROM | grep -E -o '[0-9]{4}-[0-9]{2}-[0-9]{2}' | cat)
[ -z "$DATE" ] && error "Ausgangspfad enthält kein Datum!"

DIR=$(dirname $FROM)/kxp-subjects_$DATE
mkdir -p $DIR

subjects=$DIR/kxp-subjects_$DATE.dat

echo -n > $subjects

for dat in  $FROM/*.dat; do
  pica filter --skip-invalid '003@?' --reduce '003@,013D,013E,044.,045.,144Z,145S,145Z' "$dat" \
      | grep -Pv '^003@..0[0-9X]+.$' >> $subjects
done

# split -l 5000000 --numeric-suffixes=01 $subjects kxp-subjects_$DATE_
