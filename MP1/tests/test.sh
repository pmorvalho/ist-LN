# tests
rm  *.fst *.pdf *.png *.ps

mkdir fst_in
mkdir fst_out
mkdir examples
mkdir numbers

rm t1_output/*.*
rm t2_output/*.*
rm t3_output/*.*
rm cod_output/*.*
rm descod_output/*.*


python genexamples.py
python gennumbers.py

cd .. 
sh run.sh
cd tests

function run_test(){

	fstcompose fst_in/$2.fst ../$1.fst | fstshortestpath > fst_out/test_$3_$2.fst
	fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait fst_out/test_$3_$2.fst | dot -Tpdf > test_$3_$2.pdf
	
	# remover eps e minimizar pra ter output mais bonito (opcional)
	fstrmepsilon fst_out/test_$3_$2.fst fst_out/test_$3_$2.fst

	fstprint --isymbols=syms.txt --osymbols=syms.txt fst_out/test_$3_$2.fst | sort -gr | awk -F " " '{print $4}' | grep -v "eps" | tr -d "\n" > $3_output/$2.output
	cp $3_output/$2.output $3_expected_output/$2.expected
	diff -y $3_expected_output/$2.expected $3_output/$2.output
	echo "\n"

}

# for f in numbers/*.txt
# do
# 	filename=$(basename $f .txt)
# 	fstcompile --isymbols=syms.txt --osymbols=syms.txt $f | fstarcsort > fst_in/$filename.fst
	
# 	fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait fst_in/$filename.fst | dot -Tpng  > $filename.png

# 	echo " transdutorRomanos -- $filename --    "
# 	run_test transdutorRomanos $filename tR

# 	fstcompose fst_in/$filename.fst ../transdutorRomanos.fst | fstshortestpath > fst_out/test_tR_$filename.fst
# 	fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait fst_out/test_tR_$filename.fst | dot -Tpdf > test_tR_$filename.pdf
	
# 	# remover eps e minimizar pra ter output mais bonito (opcional)
# 	# fstrmepsilon fst_out/test_tR_$filename.fst fst_out/test_tR_$filename.fst

# 	fstprint --isymbols=syms.txt --osymbols=syms.txt fst_out/test_tR_$filename.fst | sort -gr | awk -F " " '{print $4}'| tr -d "\n" > tR_output/$filename.output

# 	# cp tR_output/$filename.output tR_expected_output/$filename.expected
# 	diff -y tR_expected_output/$filename.expected tR_output/$filename.output

# done	

for f in examples/*.txt
do
	filename=$(basename $f .txt)
	# echo "testing number $filename \n"
	fstcompile --isymbols=syms.txt --osymbols=syms.txt $f | fstarcsort > fst_in/$filename.fst
	fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait fst_in/$filename.fst | dot -Tpng  > $filename.png

	echo " transdutor1 -- $filename --    "
	run_test transdutor1 $filename t1
	echo " transdutor2 -- $filename --\n"
	run_test transdutor2 $filename t2
	echo " transdutor3 -- $filename --\n"
	run_test transdutor3 $filename t3
	echo " codificador -- $filename --\n"
	run_test codificador $filename cod
	echo " descodificador -- $filename --\n"
	run_test descodificador $filename descod
	
done


rm -r fst_out
rm -r fst_in
rm -r examples
rm -r numbers
rm  *.fst  *.png *.ps *.pdf
