#! /bin/zsh
# Customtex
# Usage: fulltex filename (without extension)

echo "1) Processing $1.tex with pdflatex (x2)…";
/usr/texbin/pdflatex -synctex=1 -interaction=nonstopmode $1.tex > /dev/null;
/usr/texbin/pdflatex -synctex=1 -interaction=nonstopmode $1.tex > /dev/null; 
echo "Done."
echo "2) Starting bibtex processing… (bibtex - pdflatex - bibtex)";
/usr/texbin/bibtex $1.aux > /dev/null;
/usr/texbin/pdflatex -synctex=1 -interaction=nonstopmode $1.tex > /dev/null;
/usr/texbin/bibtex $1.aux > /dev/null;
echo "Done."
echo "3) Starting second processing with pdflatex (x2)…";
/usr/texbin/pdflatex -synctex=1 -interaction=nonstopmode $1.tex > /dev/null;
/usr/texbin/pdflatex -synctex=1 -interaction=nonstopmode $1.tex > /dev/null;
echo "Done processing, removing garbage… (.aux, .synctex.gz, .out, …)"
rm *.aux *.synctex.gz *.out *.blg *.toc *.bbl *.log;
echo "4) Pushing to filedump";
scp $1.pdf strato:"~/dumpdir/Hausarbeiten/";
#echo "Done.\nOpening preview for $1.pdf in Quick Look if specified (TBI)...";
#qlmanage -p $1.pdf > /dev/null;
echo "All done.";
