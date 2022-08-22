default:
	@echo See README.md
	
clean-subjects.tsv: subjects.tsv
	./clean-subjects.pl < $< > $@
