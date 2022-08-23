This dataset contains **normalized subject indexing data of K10plus library union catalog**. It includes links between bibliographic records in K10plus and concepts (subjects or classes) from controlled vocabularies:

- `kxp-subjects_2022-06-30.tsv.gz`: subject indexing with syntactically valid identifiers
- `kxp-subjects_2022-06-30.nt.gz`: RDF representation in form of NTriples 
- `vocabularies.json`: information about vocabularies

**K10plus** is a union catalog of German libraries, run by library service centers BSZ and VZG since 2019. The catalog contains bibliographic data of the majority of academic libraries in Germany.

## Statistics

The TSV dataset is 23.306.480 records and 77.705.044 links to concepts.

Number of concepts per vocabulary:

    asb	     5340
    stw	   104118
    nlm	   129289
    ssd	   153242
    kab	   159543
    sfb	   432141
    sdnb	  4593798
    ddc	  9248794
    rvk	 10172838
    bk	 13321229
    gnd	 39384712

Number of RDF Triples: 77.545.501

## TSV

The `.tsv` file contains three tab-separated columns:

1. Bibliographic record identifier (PPN)
2. Vocabulary symbol
3. Notation or identifier in the vocabulary

An example:

    0010000011	bk	58.55
    0010000011	gnd	4036582-7

Record `0010000011` is indexed with class `58.55` from Basic Classification and with authority record `4036582-7` from Integrated authority file.

Several APIs exist to retrieve more data for a record via its PPN, e.g.

    https://opac.k10plus.de/PPNSET?PPN={PPN}
    https://unapi.k10plus.de/?format=marcxml&id=opac-de-627:ppn:{PPN}
    https://ws.gbv.de/suggest/csl2?citationstyle=ieee&language=en&database=opac-de-627&query=pica.ppn=010000011

The first can be used to link into the K10plus OPAC and the third can be used for instance to display a simple citation.

APIs to look up more data from a notation or identifier of a vocabulary can be found in <https://bartoc.org/>. For instance BK class `58.55` can be retrieved via DANTE API:

    https://api.dante.gbv.de/data?uri=http%3A%2F%2Furi.gbv.de%2Fterminology%2Fbk%2F58.55

See `vocabularies.json` for mapping of vocabulary symbol to BARTOC URI and additional information.

## RDF

The NTriples file contains RDF triples with a subset of the information given in the TSV file. Only vocabularies with known mapping to RDF are included. An example:

    <http://uri.gbv.de/document/opac-de-627:ppn:0010000011> <http://purl.org/dc/terms/subject> <http://d-nb.info/gnd/4036582-7> .
<http://uri.gbv.de/document/opac-de-627:ppn:0010000011> <http://purl.org/dc/terms/subject> <http://uri.gbv.de/terminology/bk/58.55> .

## License and provenance

All data is public domain but references are welcome. See <https://coli-conc.gbv.de/> for related projects and documentation.

The data has been derived from a larger datase of all subject indexing data, published at <https://doi.org/10.5281/zenodo.6817455>. 

This dataset has been created with public scripts from git repository <https://github.com/gbv/k10plus-subjects>.

