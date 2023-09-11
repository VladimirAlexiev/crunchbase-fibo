PNG = $(patsubst %.ttl, %.png, $(filter-out prefixes.ttl, $(wildcard *.ttl)))

all: $(PNG) README.html bibliography.html ipos-fibo.ttl ipos-fibo.ru

%.png: %.ttl
	rdfpuml.bat $*.ttl
	puml.bat $*.puml
	rm $*.puml

%.html: %.md
	pandoc $^ --defaults=pandoc-defaults -o $@

# just for testing
bibliography.html: bibliography.bib
	pandoc $^ --defaults=pandoc-defaults --from=bibtex --metadata title=bibliography -o $@

ipos-fibo.ttl: ipos-agents.ttl ipos-offering.ttl ipos-financials.ttl ipos-currencies.ttl
	cat $^ > $@

ipos-fibo.ru: ipos-fibo.ttl prefixes.rq 
	perl -S rdf2sparql.pl \
	--filterColumn updated_at \
	--filter "<cb> cb:updatedAt ?UPDATED_AT_DT bind(replace(str(?UPDATED_AT_DT),'T',' ') as ?UPDATED_AT) filter(?updated_at > ?UPDATED_AT)" \
	$< | cat common.h prefixes.rq - | cpp -P -C -nostdinc - > $@
