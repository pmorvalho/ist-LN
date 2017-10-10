# transdutor 2 tests
rm  *.fst *.pdf *.png *.ps

mkdir fst_in
mkdir fst_out
mkdir examples_cod

python genexamplescod.py

for f in examples_cod/*.txt
do
	filename=$(basename $f .txt)
	echo "testing number $filename"
	fstcompile --isymbols=syms.txt --osymbols=syms.txt $f | fstarcsort > fst_in/$filename.fst
	fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait fst_in/$filename.fst | dot -Tpng  > $filename.png
	fstcompose fst_in/$filename.fst ../codificador.fst > fst_out/test_$filename.fst
	fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait fst_out/test_$filename.fst | dot -Tpdf > test_$filename.pdf
	fstrmepsilon fst_out/test_$filename.fst fst_out/test_$filename.fst
	fstminimize fst_out/test_$filename.fst fst_out/test_$filename.fst
	fstprint --isymbols=syms.txt --osymbols=syms.txt fst_out/test_$filename.fst
done

rm -r fst_out
rm -r fst_in
rm -r examples_cod