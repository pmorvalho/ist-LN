#!/bin/bash

rm *.fst *.pdf

# ----------------------------------- TRANSDUTOR ROMANOS -----------------------------------

fstcompile --isymbols=syms.txt --osymbols=syms.txt roman2arab.txt  > roman2arab.fst

fstinvert	roman2arab.fst  transdutorRomanos.fst

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait  transdutorRomanos.fst | dot -Tpdf  >  transdutorRomanos.pdf


# ------------------------------------- TRANSDUTOR 1 ---------------------------------------

# transdutor que le um '_'

fstcompile --isymbols=syms.txt --osymbols=syms.txt transdutorTraco.txt  > transdutorTraco.fst

# cria um transdutor que transforma os numeros arabaes em romanos e le um '_' no final

fstconcat  transdutorRomanos.fst transdutorTraco.fst transdutorArabTraco.fst

python scripts/compact2fst.py compact-a-z.txt > transdutor-a-z.txt # descompacta o transdutor que le a-z e um _ no fim

fstcompile --isymbols=syms.txt --osymbols=syms.txt transdutor-a-z.txt  > transdutor-a-z.fst

fstunion transdutorArabTraco.fst transdutor-a-z.fst transdutor1.fst

fstclosure	transdutor1.fst transdutor1.fst

fstrmepsilon transdutor1.fst transdutor1.fst # necessario para os testes nao terem ramos diferentes para eps's 

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait transdutor1.fst | dot -Tpdf  > transdutor1.pdf


# ------------------------------------- TRANSDUTOR 2 ---------------------------------------

python scripts/compact2fst.py compact2.txt > transdutor2.txt

fstcompile --isymbols=syms.txt --osymbols=syms.txt transdutor2.txt  > transdutor2.fst

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait transdutor2.fst | dot -Tpdf  > transdutor2.pdf

# fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait transdutor2.fst | dot -Tpng  > transdutor2.png


# ------------------------------------- TRANSDUTOR 3 ---------------------------------------

python scripts/compact2fst.py compact3.txt > transdutor3.txt

fstcompile --isymbols=syms.txt --osymbols=syms.txt transdutor3.txt  > transdutor3.fst

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait transdutor3.fst | dot -Tpdf  > transdutor3.pdf


# ------------------------------------- CODIFICADOR ----------------------------------------

fstarcsort transdutor2.fst transdutor2.fst

fstcompose transdutor1.fst transdutor2.fst transdutor21.fst

fstarcsort transdutor3.fst transdutor3.fst

fstcompose transdutor21.fst transdutor3.fst codificador.fst

fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait codificador.fst | dot -Tpdf  > codificador.pdf


# ------------------------------------ DESCODIFICADOR --------------------------------------

fstinvert codificador.fst descodificador.fst

fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait descodificador.fst | dot -Tpdf  > descodificador.pdf


rm transdutorTraco.fst transdutorArabTraco.fst transdutor-a-z.fst transdutor2.txt transdutor3.txt 
rm roman2arab.fst transdutor21.fst transdutor-a-z.txt