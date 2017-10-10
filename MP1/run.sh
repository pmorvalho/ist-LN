#!/bin/bash

rm *.fst *.pdf

# Transdutor Numeros Romanos para Arabes

fstcompile --isymbols=syms.txt --osymbols=syms.txt roman2arab.txt  > roman2arab.fst

# fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait roman2arab.fst | dot -Tpng  > roman2arab.png

#  Transdutor que inverte o transdutor de numero romanos para arabes, ficando um transdutor que transforma numeros arabes em romanos

fstinvert	roman2arab.fst  transdutorRomanos.fst

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait  transdutorRomanos.fst | dot -Tpdf  >  transdutorRomanos.pdf

# Transdutor que le as letras minusculas de 'a' a 'z'

fstcompile --isymbols=syms.txt --osymbols=syms.txt transdutor-a-z.txt  > transdutor-a-z.fst

# transdutor que le um '_'

fstcompile --isymbols=syms.txt --osymbols=syms.txt transdutorTraco.txt  > transdutorTraco.fst

# cria um transdutor que transforma os numeros arabaes em romanos e le um '_' no final

fstconcat  transdutorRomanos.fst transdutorTraco.fst transdutorArabTraco.fst

# cria o transdutor 1

fstunion transdutorArabTraco.fst transdutor-a-z.fst transdutor1.fst

fstclosure	transdutor1.fst transdutor1.fst

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait transdutor1.fst | dot -Tpdf  > transdutor1.pdf


# Transdutor 2

fstcompile --isymbols=syms.txt --osymbols=syms.txt transdutorRoman2Code.txt  > transdutorRoman2Code.fst

fstunion transdutorRoman2Code.fst transdutor-a-z.fst transdutor2.fst

fstclosure	transdutor2.fst transdutor2.fst

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait transdutor2.fst | dot -Tpdf  > transdutor2.pdf


# fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait transdutor2.fst | dot -Tpng  > transdutor2.png

# Transdutor 3

fstcompile --isymbols=syms.txt --osymbols=syms.txt transdutor3.txt  > transdutor3.fst

fstarcsort transdutor3.fst transdutor3.fst

fstclosure transdutor3.fst transdutor3.fst

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait transdutor3.fst | dot -Tpdf  > transdutor3.pdf

# Transdutor Codificador

fstarcsort transdutor1.fst transdutor1.fst

fstarcsort transdutor2.fst transdutor2.fst

fstcompose transdutor1.fst transdutor2.fst transdutor21.fst

fstarcsort transdutor21.fst transdutor21.fst

fstarcsort transdutor3.fst transdutor3.fst

fstcompose transdutor21.fst transdutor3.fst codificador.fst

fstrmepsilon codificador.fst codificador.fst

fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait codificador.fst | dot -Tpdf  > codificador.pdf

# Transdutor Descodificador

fstinvert transdutor3.fst transdutor3inv.fst
fstinvert transdutor2.fst transdutor2inv.fst

fstcompose transdutor3inv.fst transdutor2inv.fst transdutor32inv.fst

fstinvert transdutor1.fst transdutor1inv.fst

fstcompose transdutor32inv.fst transdutor1inv.fst descodificador.fst

fstrmepsilon descodificador.fst descodificador.fst

fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait descodificador.fst | dot -Tpdf  > descodificador.pdf


rm transdutorTraco.fst transdutorArabTraco.fst transdutor-a-z.fst 
rm roman2arab.fst transdutor32inv.fst transdutor21.fst transdutor3inv.fst 
rm transdutor2inv.fst transdutor1inv.fst transdutorRoman2Code.fst