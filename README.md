# K10plus Subjects

This directory contains scripts analyze, convert and publish subject indexing data from K10plus catalog.

## Summary

The data is reduced and cleaned up in three steps:

1. Full K10plus dumps (PICA+): not published
2. Reduction to subject-related fields (TSV): <https://doi.org/10.5281/zenodo.6817455>
3. Normalized subject indexing data (TSV and RDF): <https://doi.org/10.5281/zenodo.7016625>

## Requirements

Dumps of subject indexing in K10plus catalog are published yearly to quarterly at . Each dump is around 15 Gigabytes and split into multiple files. Copies of the full dump may be found at <https://analytics.gbv.de/dumps/kxp/>.

Script `zenodo-get` in this repository can be used for automatic download from Zenodo.

Data is provided in [PICA Normalized](https://format.gbv.de/pica/normalized) format with one record per line. Further extraction and analysis of PICA Normalized requires [pica-rs](https://github.com/deutsche-nationalbibliothek/pica-rs), Bash and Perl to be installed.

## Scope

The data is reduced to data fields used for subject indexing in K10plus catalog and limited to records with at least one library holding. Records without any subject indexing are omitted. See the file README.md of <https://doi.org/10.5281/zenodo.6817455> for further description of the data.

## Extract raw indexing for each vocabulary

See <https://format.k10plus.de/k10plushelp.pl?cmd=pplist&katalog=Standard#titel> for documentation of PICA fields.

Script `extract-subjects.pl` extracts indexing data from PICA to TSV format, e.g.

    cat kxp-subjects-sample_2021-06-30*.dat | ./extract-subjects.pl > subjects.tsv

This should take around half an hour at most.

The resulting TSV files contains three columns:

- PPN
- notation (subfield `$a`)
- source (subfield `$A` if available)

Multiple sources are concatenated with separator `|`. 

**Note:** Use of sources field (`$A` in most cases) contains a large number of errors when the label of a concept was put in the sources field by accident!

Repeated subfield result in repeated rows. An example:

~~~
1077626444	CF 5017	
665018533	QQ 800	BSZ
160684654X	NZ 79700	DE-24/20sred
160684654X	NZ 79700	DA3
~~~

Basic analysis can be done on the command line, e.g. with `wc -l`, `uniq`, `awk`...

The data can also be used to detect cataloging errors such as invalid notations etc.

### Reduce extracted indexing data

If not interested in sources (`$A`) and details of cataloging, reduce the data to PPN, vocabulary and notation. Vocabularies without `notationPattern` in `vocabularies.json` are ignored.

    <subjects.tsv ./clean-subjects.pl >clean-subjects.tsv

Invalid notations are emitted to STDERR, add `2>/dev/null` for silence.

The file `clean-subjects.tsv` contains three columns

- PPN
- Vocabulary (e.g. `rvk`)
- Notation

To import this file into a SQLite database:

    sqlite3 subjects.db < import-subjects.sql

Then run your queries in SQLite, e.g.:

    SELECT COUNT(DISTINCT(ppn)) from subjects;
    SELECT voc,COUNT(*) FROM subjects GROUP BY voc;

If both rvk and bk have been imported co-occurrences can be queried via JOIN:

    SELECT b.notation, count(*) AS freq FROM subjects AS b JOIN subjects AS a ON a.ppn=b.ppn WHERE a.voc="rvk" AND b.voc="bk" AND a.notation="NQ 2350" GROUP BY b.notation ORDER BY freq DESC LIMIT 10;

### Transform reduced indexing data to RDF

Scipt `triples.pl` transforms `clean-subjects.tsv` to `kxp-subjects.nt.gz`:

    make rdf

