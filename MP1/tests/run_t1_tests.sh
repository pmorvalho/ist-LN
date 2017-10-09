################### Testa os tradutores ################


mkdir fst_in
mkdir fst_out
mkdir numbers

python gennumbers.py

# transdutor 1 tests
for f in numbers/*.txt
do
	filename=$(basename $f .txt)
	echo "testing number $filename"
	fstcompile --isymbols=syms.txt --osymbols=syms.txt $f | fstarcsort > fst_in/$filename.fst
	fstcompose fst_in/$filename.fst ../transdutor1.fst > fst_out/test_$filename.fst
	fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait fst_out/test_$filename.fst | dot -Tpng > test_$filename.png
done

rm -r fst_out
rm -r fst_in
rm -r numbers