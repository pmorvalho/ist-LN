#!/bin/bash

rm *.fst *.png

fstcompile --isymbols=syms.txt --osymbols=syms.txt roman2arab.txt  > roman2arab.fst

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait roman2arab.fst | dot -Tpng  > roman2arab.png

fstinvert	roman2arab.fst arab2roman.fst

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait arab2roman.fst | dot -Tpng  > arab2roman.png

fstcompile --isymbols=syms.txt --osymbols=syms.txt transdutor-a-z.txt  > transdutor-a-z.fst

fstcompile --isymbols=syms.txt --osymbols=syms.txt transdutorTraco.txt  > transdutorTraco.fst

fstconcat arab2roman.fst transdutorTraco.fst transdutorArabTraco.fst

fstunion transdutorArabTraco.fst transdutor-a-z.fst transdutor1.fst

fstclosure	transdutor1.fst transdutor1.fst

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait transdutor1.fst | dot -Tpng  > transdutor1.png

