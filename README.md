# K10plus Subjects

This directory contains scripts to analyze subject indexing in K10plus catalog.

## Requirements

Dumps of subject indexing in K10plus catalog are published yearly to quarterly at <https://doi.org/10.5281/zenodo.6810556>. Each dump is around 15 Gigabytes and split into multiple files. Copies of the full dump may be found at <https://analytics.gbv.de/dumps/kxp/>.

Data is provided in [PICA Normalized](https://format.gbv.de/pica/normalized) format with one record per line. Further extraction and analysis of PICA Normalized requires [pica-rs](https://github.com/deutsche-nationalbibliothek/pica-rs) and Perl to be installed.

## Scope

The data is reduced to data fields used for subject indexing in K10plus catalog and limited to records with at least one library holding. Records without any subject indexing are omitted. See the file README.md of <https://doi.org/10.5281/zenodo.6810556> for further description of the data.

## Analysis of classification

Complete analysis depends on the fields to be analysed. The following analysis is limited to classification data.

File `classifications.csv` contains a list of classifications, each with the corresponding PICA field. See <https://format.k10plus.de/k10plushelp.pl?cmd=pplist&katalog=Standard#titel> for documentation of PICA fields.

Script `extract-classification.pl` helps to extract classification data from PICA to TSV format, e.g.

    cat kxp-subjects-sample_2021-06-30*.dat | ./extract-classification.pl rvk

The resulting TSV files contains three columns:

- PPN
- notation (subfield `$a`)
- source (subfield `$A` if available)

Repeated subfield result in repeated rows. An example:

~~~
1077626444	CF 5017	
665018533	QQ 800	BSZ
160684654X	NZ 79700	DE-24/20sred
160684654X	NZ 79700	DA3
~~~

Basic analysis can be done on the command line, e.g. with `wc -l`, `uniq`, `awk`...:

    wc -l *.tsv
    awk -F'\t' '$3{print $3}' bk.tsv | grep -v https | sort | uniq -c

If not interested in sources (`$A`), reduce the data to PPN, vocabulary and notation:

    ./classification-subjects.sh > subjects.tsv

The file `subjects.tsv` contains three columns

- PPN
- Vocabulary (e.g. `rvk`)
- Notation

To import this file into a SQLite database:

    sqlite3 subjects.db < import-subjects.sql

Then run your queries in SQLite, e.g.:

    SELECT COUNT(DISTINCT(ppn)) from subjects;
    SELECT voc,COUNT(*) FROM subjects GROUP BY voc;

If both rvk and bk have been imported co-occurrences can be queried via JOIN:

    SELECT b.notation, count(*) AS freq FROM subjects AS b JOIN subjects AS a ON a.ppn=b.ppn WHERE a.voc="rvk" AND b.voc="bk" AND a.notation="NQ 2350" GROUP BY b.notation ORDER BY freq;

