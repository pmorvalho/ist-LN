################### Testa os tradutores ################
rm  *.fst *.pdf *.png *.ps

for f in numbers/*.txt
do
	filename=$(basename $f .txt)
	echo "testing number $filename"
	fstcompile --isymbols=syms.txt --osymbols=syms.txt $f | fstarcsort > fst_in/$filename.fst
	fstcompose fst_in/$filename.fst ../transdutorRomano.fst > fst_out/test_$filename.fst
	#fstcompose fst_in/$filename.fst ../mintransdutorRomano.fst > fst_out/test_$filename.fst
	fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait fst_out/test_$filename.fst | dot -Tpng > test_$filename.png
done