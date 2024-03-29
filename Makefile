default:
	@echo See README.md
	
normalized: tsv rdf

clean-subjects.tsv: subjects.tsv
	./clean-subjects.pl < $< > $@ 2> invalid-ids.tsv

rdf: kxp-subjects.nt.gz
kxp-subjects.nt.gz:	clean-subjects.tsv
	./triples.pl < $< | gzip -c > $@

tsv: kxp-subjects.tsv.gz
kxp-subjects.tsv.gz: clean-subjects.tsv
	gzip -c $< > $@

stats: normalized
	./stats.sh

model.svg: model.mmd
	npm run mmdc -- -i $< -o $@ 
