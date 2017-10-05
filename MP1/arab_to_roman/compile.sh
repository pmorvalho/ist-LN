#!/bin/bash

# rm *.fst *.png *transdutorRomano.*
################### Tradutores de tradução ################
# Compilar e desenhar transdutores parciais
# for f in startwith[1-9].txt
# do
# 	filename=$(basename $f .txt) # $f -> startwith1.txt
# 	echo "compiling number $filename" # $filename -> startwith1
# 	fstcompile --isymbols=syms.txt --osymbols=syms.txt $f | fstarcsort > $filename.fst
# 	fstminimize $filename.fst $filename.fst
# 	fstarcsort $filename.fst $filename.fst
# 	fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait $filename.fst | dot -Tpng  > $filename.png
# done
fstcompile --isymbols=syms.txt --osymbols=syms.txt roman2arab.txt | fstarcsort > roman2arab.fst
fstminimize roman2arab.fst roman2arab.fst
fstarcsort $filename.fst $filename.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait roman2arab.fst | dot -Tpng  > roman2arab.png

# Juntar os transdutores parciais num geral
# fstunion startwith1.fst startwith2.fst transdutorRomano.fst
# fstunion transdutorRomano.fst startwith3.fst transdutorRomano.fst
# fstunion transdutorRomano.fst startwith4.fst transdutorRomano.fst
# fstunion transdutorRomano.fst startwith5.fst transdutorRomano.fst
# fstunion transdutorRomano.fst startwith6.fst transdutorRomano.fst
# fstunion transdutorRomano.fst startwith7.fst transdutorRomano.fst
# fstunion transdutorRomano.fst startwith8.fst transdutorRomano.fst
# fstunion transdutorRomano.fst startwith9.fst transdutorRomano.fst
fstrmepsilon roman2arab.fst roman2arab.fst
fstarcsort roman2arab.fst roman2arab.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait roman2arab.fst | dot -Tpng  > roman2arab.png


# Versao minimizada do transdutor final
# fstdeterminize roman2arab.fst mintransdutorRomano.fst
# fstminimize mintransdutorRomano.fst mintransdutorRomano.fst
fstinvert	roman2arab.fst arab2roman.fst
fstarcsort arab2roman.fst arab2roman.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait arab2roman.fst | dot -Tpng  > arab2roman.png

