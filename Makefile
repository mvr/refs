all: types optics kenzo quantum life cv
optics: optics.bib.done
kenzo: kenzo.bib.done
types: types.bib.done
quantum: quantum.bib.done
life: life.bib.done
cv: cv.bib.done
.PHONY : all types optics kenzo quantum life cv

%.bib.done: %.bib
	# Validate and normalize biblatex source
	biber --tool --output-safechars --fixinits --isbn-normalise --output_indent=2 --output_fieldcase=lower --output_encoding=ascii --output-field-order=title,names,dates --configfile=biber-tool.conf --output_file=$< $<

	# Export a version that is almost compatible with bibtex
	biber --tool --output-safechars --fixinits --isbn-normalise --output_indent=2 --output_fieldcase=lower --output_encoding=ascii --output-field-order=title,names,dates --output-resolve --configfile=biber-tool.conf --output_file=$*-expanded.bib $<

	# fix the broken bibtex
	python3 bibtex-compatibility.py $*
	perl -i -pe 's/\\i\{\}/i/g;' -pe 's/\{\\i\}/i/g;' $<
	perl -i -pe 's/\\i\{\}/i/g;' -pe 's/\{\\i\}/i/g;' $*-bibtex.bib

	touch $*.bib.done

clean:
	rm -f *.blg
	rm -rf auto
	rm -f *.done
	rm -f *-expanded.bib
