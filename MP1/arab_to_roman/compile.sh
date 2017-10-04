#!/bin/bash

rm *.fst *.png *transdutorRomano.*
################### Tradutores de tradução ################
# Compilar e desenhar transdutores parciais
for f in startwith[1-9].txt
do
	filename=$(basename $f .txt) # $f -> startwith1.txt
	echo "compiling number $filename" # $filename -> startwith1
	fstcompile --isymbols=syms.txt --osymbols=syms.txt $f | fstarcsort > $filename.fst
	fstminimize $filename.fst $filename.fst
	fstarcsort $filename.fst $filename.fst
	fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait $filename.fst | dot -Tpng  > $filename.png
done


# Juntar os transdutores parciais num geral
fstunion startwith1.fst startwith2.fst transdutorRomano.fst
fstunion transdutorRomano.fst startwith3.fst transdutorRomano.fst
fstunion transdutorRomano.fst startwith4.fst transdutorRomano.fst
fstunion transdutorRomano.fst startwith5.fst transdutorRomano.fst
fstunion transdutorRomano.fst startwith6.fst transdutorRomano.fst
fstunion transdutorRomano.fst startwith7.fst transdutorRomano.fst
fstunion transdutorRomano.fst startwith8.fst transdutorRomano.fst
fstunion transdutorRomano.fst startwith9.fst transdutorRomano.fst
fstrmepsilon transdutorRomano.fst transdutorRomano.fst
fstarcsort transdutorRomano.fst transdutorRomano.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait transdutorRomano.fst | dot -Tpng  > transdutorRomano.png


# Versao minimizada do transdutor final
fstdeterminize transdutorRomano.fst mintransdutorRomano.fst
fstminimize mintransdutorRomano.fst mintransdutorRomano.fst
fstarcsort mintransdutorRomano.fst mintransdutorRomano.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait mintransdutorRomano.fst | dot -Tpng  > mintransdutorRomano.png

