default:
	@echo See README.md
	
clean-subjects.tsv: subjects.tsv
	./clean-subjects.pl < $< > $@

rdf: k10plus-subjects.nt.gz
k10plus-subjects.nt.gz:	clean-subjects.tsv
	./triples.pl < $< | gzip -c > $@

