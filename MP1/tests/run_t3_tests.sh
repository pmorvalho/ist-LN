# transdutor 3 tests
rm  *.fst *.pdf *.png *.ps

mkdir fst_in
mkdir fst_out
mkdir examples_t3

python genexamplest3.py

for f in examples_t3/*.txt
do
	filename=$(basename $f .txt)
	echo "testing number $filename"
	fstcompile --isymbols=syms.txt --osymbols=syms.txt $f | fstarcsort > fst_in/$filename.fst
	fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait fst_in/$filename.fst | dot -Tpng  > $filename.png
	fstcompose fst_in/$filename.fst ../transdutor3.fst > fst_out/test_$filename.fst
	fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait fst_out/test_$filename.fst | dot -Tpdf > test_$filename.pdf
done

rm -r fst_out
rm -r fst_in
rm -r examples_t3