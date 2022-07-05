# K10plus Subjects

This directory contains scripts to analyze subject indexing in K10plus catalogue.

## Requirements

Analysis is based on a PICA+ dump in [PICA Normalized](https://format.gbv.de/pica/normalized) format (one record per line). Dumps can be found at <https://analytics.gbv.de/dumps/kxp/>. The should include the following fields:

- `003` PPN for each record
- `044.`, `045.` all subject fields
- `144Z`, `145S`, `145Z` (optional, not analyzed yet)

Fields with classifications should include subfields `$a` (possible expanded from PPN-Link in `$9`) and `$A` (if available). In particular BK (`045Q/01`) and RVK (`045R`) need notation in `$a` also if the internal records only contains `$9`.

Data extraction from PICA+ requires [pica-rs](https://github.com/deutsche-nationalbibliothek/pica-rs) to be installed.

## Examples: RVK and BK

The basic analysis is run for each vocabulary to extract subject indexing data into TSV files. The files contains three columns:

- PPN
- notation (subfield `$a`, if given)
- source (subfield `$A`, if given)

In theory notation should not be empty but a small number of records just lack subfield `$a`, so these should be filtered out for further analysis.

If the source field is repeated, there is an additional row for each source.

Maybe we should join multiple sources into one or create a fourth row for additional sources?

Extract RVK (045R):

    pica filter '003@? && 045R?' --reduce 003@,045R $DUMP \
      | pica select '003@$0, 045R{a,A}' --tsv > rvk.tsv

Extract BK (045Q/01):

    pica filter '003@? && 045Q/01?' --reduce 003@,045Q $DUMP \
      | pica select '003@$0, 045Q/01{a,A}' --tsv > bk.tsv

Basic analysis can be done on the command line, e.g. with `wc -l`, `uniq`, `awk`...:

    wc -l *.tsv
    awk -F'\t' '$3{print $3}' bk.tsv | grep -v https | sort | uniq -c

More sophisticated analysis is easer with SQL. To import TSV

- create a SQLite database

  `sqlite> create table bk (ppn text, notation text, source text);`
  
- import into the database

  `sqlite> .mode tabs`
  
  `sqlite> .import bk.tsv bk`

Then run your queries in SQLite, e.g.:

    SELECT COUNT(DISTINCT(ppn)) from bk;
    SELECT COUNT(*) from bk;

If both rvk and bk have been imported co-occurrences can be queried via JOIN:

    SELECT bk.notation, count(*) AS freq FROM bk JOIN rvk ON rvk.ppn=bk.ppn WHERE rvk.notation="DX 4400" GROUP BY bk.notation ORDER BY freq;

The current result is skewed because it contains coli-conc enriched data as well (better exclude it?).

Maybe creating and index can speed up queries:

    sqlite> CREATE INDEX rvk_ppn ON rvk(ppn);
    sqlite> CREATE INDEX bk_ppn ON bk(ppn);

