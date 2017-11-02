.PHONY: all build vim clean

all: build

build: 
	mkdir -p obj
	mkdir -p obj/src
	if [ -e obj/pes_att.aux ];\
	then\
		cp obj/pes_att.aux obj/pes_att_old.aux;\
	fi
	pdflatex -jobname pes_att -output-directory obj pes_att.tex
	#cd obj && bibtex pes_att.aux
	latex_count=5 ; \
	while ! cmp -s obj/pes_att.aux obj/pes_att_old.aux && [ $$latex_count -gt 0 ] ;\
	do \
		echo "Rerunning latex....." ;\
		cp obj/pes_att.aux obj/pes_att_old.aux;\
		pdflatex -jobname pes_att -output-directory obj pes_att.tex ;\
		latex_count=`expr $$latex_count - 1` ;\
	done

vim: 
	mkdir -p obj
	mkdir -p obj/src
	if [ -e obj/pes_att.aux ];\
	then\
		cp obj/pes_att.aux obj/pes_att_old.aux;\
	fi
	pdflatex -jobname pes_att -output-directory obj -halt-on-error pes_att.tex
	#cd obj && bibtex pes_att.aux
	latex_count=5 ; \
	while ! cmp -s obj/pes_att.aux obj/pes_att_old.aux && [ $$latex_count -gt 0 ] ;\
	do \
		echo "Rerunning latex....." ;\
		cp obj/pes_att.aux obj/pes_att_old.aux;\
		pdflatex -jobname pes_att -output-directory obj -halt-on-error pes_att.tex ;\
		latex_count=`expr $$latex_count - 1` ;\
	done

clean:
	rm -f obj/*.aux
	rm -f obj/src/*.aux
	rm -f obj/*.bbl
	rm -f obj/*.blg
	rm -f obj/*.lof
	rm -f obj/*.log
	rm -f obj/*.lot
	rm -f obj/*.out
	rm -f obj/*.tdo
	rm -f obj/*.toc
