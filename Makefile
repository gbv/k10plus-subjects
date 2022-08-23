default:
	@echo See README.md
	
clean-subjects.tsv: subjects.tsv
	./clean-subjects.pl < $< > $@ 2> invalid-ids.tsv

rdf: kxp-subjects.nt.gz
kxp-subjects.nt.gz:	clean-subjects.tsv
	./triples.pl < $< | gzip -c > $@

